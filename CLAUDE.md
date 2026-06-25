# CLAUDE.md

Guidance for working in this repository.

## What this project is

A CI/CD system that builds **multi-layer Docker images of HPC software stacks** and
publishes them to DockerHub (e.g. `ncarcisl/hpcdev-*`, `benjaminkirk/hpcdev-*`). Each image
is a chosen combination of **compiler × MPI × GPU runtime × Linux distro**, with a common
set of scientific libraries (HDF5, NetCDF C/Fortran, PnetCDF, ParallelIO, FFTW, HeFFTe)
built from source on top. Despite the repo name, the substance is the `containers/devenv`
image and the GitHub Actions matrices that drive it.

## Repository layout

- `containers/devenv/Dockerfile` — **the core**, ~1480 lines, 20+ named stages. Almost all
  real work and almost every change happens here.
- `containers/devenv/Makefile` — copies `scripts/` into the build context as `extras/`.
- `containers/{demo,test,publish}/` — small downstream images: demo app, test runner
  (OSU micro-benchmarks etc.), and the final publish/SBOM stage.
- `containers/deploy/ncar-hpc/` — Apptainer/PBS deploy configs for NCAR clusters (Derecho/Casper).
- `scripts/` — `build_*.sh` for real apps (WRF, CESM, ESMF, PETSc, DART, MPAS, Kokkos, …),
  `build_common.cfg` (sourced; sets `INSTALL_ROOT`, `STAGE_DIR`), and `hello_world.*` samples.
- `.github/workflows/` — see CI section below.
- `.github/actions/{slim-action-runner,docker-cleanup}/` — composite actions to free disk
  space on GHA runners and prune Docker between stages.

## Dockerfile architecture (`containers/devenv/Dockerfile`)

A PREREQ-arg-selectable multi-stage DAG. Build-args choose which concrete stage backs each
logical layer:

```
base_os ──▶ [cuda | rocm]? ──▶ miniforge ──▶ toolkits ──▶ <compiler>
   ──▶ <mpi> ──▶ iolibs ──▶ mpi-iolibs ──▶ fftlibs ──▶ final
```

Key selector ARGs (with representative values):
- `BASE_OS` — `almalinux8/9/10`, `rockylinux8/9/10`, `leap`, `tumbleweed`, `jammy`, `noble`
  (+ `*-cuda`/`*-rocm` vendor bases).
- `COMPILER_FAMILY` — `os-gcc` (distro gcc), `gcc` (built from source, `GCC_VERSION`),
  `oneapi`, `aocc`, `nvhpc`, `clang`.
- `MPI_FAMILY` — `openmpi`, `mpich` (5.0.x) / `mpich3` (3.4.x).
- `MINIFORGE_PREREQ`, `TOOLKITS_PREREQ`, `IOLIBS_PREREQ`, `FFTLIBS_PREREQ`, `FINAL_TARGET`
  — wire the DAG (e.g. `MINIFORGE_PREREQ=cuda` layers conda on the CUDA stage; parallel
  HDF5/NetCDF are enabled when `IOLIBS_PREREQ=mpi`).

**Environment accumulation:** stages append `export …` lines to `/container/config_env.sh`
via the `add_conf` helper (PATH, CPATH, LIBRARY_PATH, LD_LIBRARY_PATH, CC/CXX/FC, CFLAGS).
That file is sourced by every login shell and is the single source of truth for the
in-image environment. Each library installs to a versioned prefix under `/container/`.

**nvhpc specifics:** installed from the `cuda_multi` tarball; unused CUDA versions are
dropped at extract time (`tar --exclude='*/cuda/<ver>/*'`) and again via `rm_paths`, and a
CUDA that matches a separately-installed `CUDA_VERSION` is symlinked rather than duplicated
(GHA disk is tight). When bumping NVHPC, update both the `NVHPC_URL` and these `<ver>`
exclude/`rm_paths` strings to the CUDA the new SDK bundles.

## Versions and how to bump them

Defaults live as `ARG`s in the Dockerfile, but the **real, authoritative versions are the
CI matrices**, which override the ARGs via build-args:
- `.github/workflows/matrix-build-images.yaml` — full production matrix.
- `.github/workflows/devel-build-images.yaml` — the PR/dev subset (4 compilers ×
  {almalinux10, noble, leap} × {openmpi, mpich}) plus an apps smoke-test job.

A version bump = edit `compiler_build_args` / `mpi_build_args` / `extra_build_args` in those
two files (library versions like HDF5/NetCDF/PIO live in `extra_build_args`). For NVHPC also
update the CUDA exclude paths in the Dockerfile (above).

## CI workflows

- `build-hpc-development-image.yaml` — **reusable** build → test → publish; called by the
  others. Builds with `docker/build-push-action`, registry-cache keyed on all build inputs
  (`…-cache` repo), then a separate publish pass via `containers/publish/Dockerfile`.
- `matrix-build-images.yaml` — full matrix (compilers × MPI × GPU × arch), production tags.
- `devel-build-images.yaml` — runs on PRs touching the Dockerfile/scripts; the subset that
  most PRs (including version bumps) are validated against.
- `dial-an-image.yaml` — `workflow_dispatch` to build a single hand-picked variant; the
  fastest way to reproduce/iterate on one failing combination.
- Also: `container-build.yaml`, `conda-build.yaml`, `derived-containers.yaml`,
  `matrix-smoketest-applications.yaml`, `trigger-workflows.yaml`, log-cleanup crons,
  `mega-linter.yml`.

## Conventions & gotchas

- **gcc-15 / C23 `-std=gnu17` pattern.** GCC 15 defaults to `-std=gnu23`; several older C
  libraries (c-blosc, pnetcdf, …) don't compile under C23. The Dockerfile guards these with
  per-library `case "${COMPILER_FAMILY}:${GCC_VERSION}" in` blocks that prepend
  `-std=gnu17`. **`nvc` (NVHPC) inherits the host GCC's C-standard default**, so on a distro
  whose system gcc is 15 (currently `leap`/`tumbleweed`, set at `Dockerfile:293`) nvhpc
  hits the same C23 errors and must be covered by the same guard — hence the
  `"gcc:15."*|"nvhpc:"*)` arms at `Dockerfile:1159` (c-blosc) and `:1289` (pnetcdf). If a
  later C library breaks under nvhpc with *"invalid combination of type specifiers"* or a
  `bool`/`_Bool` typedef error, add the same arm to that step.
- Compiler-specific quirks are handled with `case "${COMPILER_FAMILY}" in` (e.g.
  aocc/clang need `--disable-nonstandard-feature-float16` for HDF5 and a libtool `wl=`
  patch; nvhpc/clang disable the MPICH f08 interface).
- Bloat control is pervasive: `--disable-static --enable-shared`, `install-strip`,
  `docker-clean`, and removal of docs/profilers/static libs. Keep it lean.
- Spelling/lint via `.cspell.json` and `.mega-linter.yml` (MegaLinter is a separate, often
  noisy check — not part of the image build).

## Useful commands

```bash
gh pr checks <PR#>                       # see which matrix jobs failed
gh run view --job <job-id> --log         # full job log (use --log-failed for just failures)
gh run view --job <job-id> --log > out.log && grep -nE 'error:|Error 2' out.log
gh workflow run dial-an-image.yaml -f …  # rebuild a single variant to reproduce a failure
```

Note: the real compiler error in a failing image build is usually buried mid-log — the
buildx "failed to solve" tail only echoes the failing RUN recipe, not the error. Fetch the
full `--log` and grep for `error:` / `Error 2`.
