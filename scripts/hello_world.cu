/* hello_world.cu
 * ---------------------------------------------------
 * A Hello World example in CUDA
 * ---------------------------------------------------
 * This is a short program which uses multiple CUDA
 * threads to calculate a "Hello World" message which
 * is then printed to the screen.  It's intended to
 * demonstrate the execution of a CUDA kernel.
 * ---------------------------------------------------
 */
#define SIZE 12
#include <cuda_runtime.h>
#include <stdio.h>
#include <stdlib.h>

/* CUDA kernel used to calculate hello world message */
__global__ void hello_world(char *a, int N);

int main(int argc, char **argv) {
  /* data that will live on host */
  char *data;

  /* data that will live in device memory */
  char *d_data;

  /* allocate and initialize data array */
  data = (char *)malloc(SIZE * sizeof(char));
  data[0] = 72;
  data[1] = 100;
  data[2] = 106;
  data[3] = 105;
  data[4] = 107;
  data[5] = 27;
  data[6] = 81;
  data[7] = 104;
  data[8] = 106;
  data[9] = 99;
  data[10] = 90;
  data[11] = 22;

  /* print data before kernel call */
  printf("Contents of data before kernel call: %s\n", data);

  /* allocate memory on device */
  cudaMalloc(&d_data, SIZE * sizeof(char));

  /* copy memory to device array */
  cudaMemcpy(d_data, data, SIZE, cudaMemcpyHostToDevice);

  /* call kernel */
  hello_world<<<4, 3>>>(d_data, SIZE);

  /* copy data back to host */
  cudaMemcpy(data, d_data, SIZE, cudaMemcpyDeviceToHost);

  /* print contents of array */
  printf("Contents of data after kernel call:  %s\n", data);

  /* clean up memory on host and device */
  cudaFree(d_data);
  free(data);
  return (0);
}

/* hello_world
 * Each thread increments an element of the input
 * array by its global thread id
 */
__global__ void hello_world(char *a, int N) {
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  if (i < N)
    a[i] = a[i] + i;
}
