# Demonstration of GitHub Actions

Demonstration of several GitHub Actions useful within CI/CD workflows.

## Samples

### Building an Application Against a Matrix of Software Environments

The file [`.github/workflows/container-build.yaml`](https://github.com/benkirk/demo_github_actions/blob/main/.github/workflows/container-build.yaml)
builds several applications within a matrix of compiler and MPI versions. The application builds can be enable and customized through inputs to the GitHub
[`workfow_dispatch`](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow#defining-inputs-for-manually-triggered-workflows)
event.

### Building Inside a Conda Environment on Multiple Architectures

The file [`.github/workflows/conda-build.yaml`](https://github.com/benkirk/demo_github_actions/blob/main/.github/workflows/conda-build.yaml)
builds a simple application within a `conda` environment on `x86_64` and `aarch64` platforms.

### Building a Container Image with `docker`

The file [`.github/workflows/derived-containers.yaml`](https://github.com/benkirk/demo_github_actions/blob/main/.github/workflows/derived-containers.yaml)
builds a container image from `containers/demo/Dockerfile`.

---
**Latest Status**

[![Container Build](https://github.com/benkirk/demo_github_actions/actions/workflows/container-build.yaml/badge.svg)](https://github.com/benkirk/demo_github_actions/actions/workflows/container-build.yaml)
[![Conda Build](https://github.com/benkirk/demo_github_actions/actions/workflows/conda-build.yaml/badge.svg)](https://github.com/benkirk/demo_github_actions/actions/workflows/conda-build.yaml)
[![Build Derived Container Images](https://github.com/benkirk/demo_github_actions/actions/workflows/derived-containers.yaml/badge.svg)](https://github.com/benkirk/demo_github_actions/actions/workflows/derived-containers.yaml)
