// this is the file that will make the philosopher object and map philosophers to threads. from there the gpu will handle the philosophers
// philosopher.cu
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

// Philosopher definition
class Philosopher {
public:

    // TODO: Define philosopher states and actions 

    //Due to Philosopher being an object its best to handle device memory with device functions made below
    void allocateToDevice(Philosopher** devicePtr){

        cudaMalloc((void**)devicePtr,sizeof(Philosopher));

        cudaMemcpy(*devicePtr, this, sizeof(Philosopher), cudaMemcpyHostToDevice);

    }
    void freeDeviceMemory(){
        cudaFree(this);
    }
};

class Fork{
public:
    
};

// kernel definition
//in a way we can think about this as the table itself
__global__ void philosopherSimulation(Philosopher* philosophers, int numPhilosophers) {
    //maps each philosopher to one thread
    int philosopherIdx = threadIdx.x;
    
    // TODO: Simulate philosopher actions (picking up forks, eating, thinking, ect)
}

// this is a testing kernal I will call apon when debugging.
// the idea is this is a single solution table of 5 philosophers I can use to test and garuntee any one solution no matter how absurd does infact, end deadlock
__global__ void testDeadlockResolution(Philosopher* philosophers, Fork* forks, int numPhilosophers){
    int philosopherIdx = threadIdx.x;
    
}

