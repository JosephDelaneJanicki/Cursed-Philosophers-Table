//this file is to test that i can compile CUDA and cpp 20. the idea much like with control is that this file is super simple and 
// for sure has no logical issue. any error MUST be with how compilation is set up
#include <iostream>
#include <format>

// Cuda kernel for GPU
__global__ void cudaKernel() {
    const char s[] = "Hello from GPU!";
    printf("%s\n", s);
}

int main() {
    // CPU Code
    const char s[] = "Hello from CPU!";
    std::cout << std::format("Host: {}\n", s);

    // Launch the CUDA kernel
    cudaKernel<<<1, 1>>>();

    // Wait for GPU to finish
    cudaDeviceSynchronize();

    return 0;
}
