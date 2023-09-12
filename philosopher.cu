// this is the file that will make the philosopher object and map philosophers to threads. from there the gpu will handle the philosophers
// philosopher.cu
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

// Philosopher definition
class Philosopher {
public:
    // TODO: Define philosopher states and actions 

};

// kernel definition
__global__ void philosopherSimulation(Philosopher* philosophers, int numPhilosophers) {
    int philosopherIdx = threadIdx.x;
    
    // TODO: Simulate philosopher actions (picking up forks, eating, thinking, ect)
}

