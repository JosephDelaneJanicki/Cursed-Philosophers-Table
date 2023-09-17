#include <iostream>
#include "philosopher.cu"
#include <cuda_runtime.h>
#include <random>

// Host Code
int main() {
    //initialize mutex
    mutex = 0;
    
    // garuntees gpu 0 is used for those running sli however unlikely it is
    cudaError_t cudaStatus = cudaSetDevice(0); 

    //check for a nvidia gpu and prompts the user if they dont
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Cuda failed to set, the philosophers are very picky, they only eat on Nvidia brand tables." << std::endl;
        return 1;
    }

    // Create philosopher objects in host code
    Philosopher hostPhilosopher;
    
    // theoretically makes philosophers on host and puts them on the gpu. apon further analasys it the philosophers will be too complex to copy directly on the gpu
    // ill have to use device functions in philosopher.cu to manage memory
    /*// Transfer philosopher object to the device
    Philosopher* devicePhilosopher;
    cudaMalloc((void**)&devicePhilosopher, sizeof(Philosopher));
    cudaMemcpy(devicePhilosopher, &hostPhilosopher, sizeof(Philosopher), cudaMemcpyHostToDevice);

    // Perform GPU operations with devicePhilosopher
    
    // Cleanup
    cudaFree(devicePhilosopher);*/

    return 0;
}