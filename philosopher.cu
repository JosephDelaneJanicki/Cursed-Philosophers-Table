// this is the file that will make the philosopher object and map philosophers to threads. from there the gpu will handle the philosophers
// philosopher.cu
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <curand_kernel.h>

// Philosopher definition
class Philosopher {
public:

    // TODO: Define philosopher states and actions 

    /*NOTE: the busy wait loops are temporary measures to provide something the kernel can use to 
    simulate the philosphers they consume CPU cycles and generally arent cuda friendly. once i have the philosophers in deadlock
    ill go back and replace these with synchronization primitives*/
    __device__ void think() {

        int startTime = clock();
        while (clock() - startTime < 1000000) { /*the philosopher is thinking, using a busy wait loop to simulate it for now will add logic as needed later on*/ }
    }
    __device__ void tryToPickUpForks(Fork& leftFork, Fork& rightFork){
        if (leftFork.available)  {leftFork.pickUp(); think();}  // by thinking here i can garuntee deadlock since now the forks are picked up one at a time
        else  think(); tryToPickUpForks;
        while(rightFork.isAvailable() == false) think();
        rightFork.pickUp();
        eat(leftFork, rightFork);
        leftFork.putDown();
        rightFork.putDown();
    }
    /*by picking up the forks at the same time and dropping at the same time deadlock should be avoided.
    this i believe will be my first solution before going down the "cursed rought"*/
    __device__ void tryToPickUpForksAvoidDeadlock(Fork& leftFork, Fork& rightFork) {
    if (leftFork.isAvailable() && rightFork.isAvailable()) {
        leftFork.pickUp();
        rightFork.pickUp();
        eat(leftFork, rightFork);
        leftFork.putDown();
        rightFork.putDown();
    } 
    else think();
}
    __device__ void eat(Fork& leftFork, Fork& rightFork){

        int startTime = clock();
        while (clock() - startTime < 1000000) { /*the philosopher is eating, using a busy wait loop to simulate it for now. will add logic as needed later on*/ }

    }

    //Due to Philosopher being an object its best to handle device memory with device functions made below
    void allocateToDevice(Philosopher** devicePtr){

        cudaMalloc((void**)devicePtr,sizeof(Philosopher));

        cudaMemcpy(*devicePtr, this, sizeof(Philosopher), cudaMemcpyHostToDevice);

    }
    void freeDeviceMemory(){
        cudaFree(this);
    }
};
// Fork object to allow solutions that involve changing something about the fork/forks. Forks are picked up and put down by philosophers
class Fork{
public:
    int temprature {}; // how hot or cold the fork is to the touch
    bool available = true;  //fork availability to pick up, by default they are available

    // this method 
    bool isAvailable() {
        // You can use atomic operations or locks here for thread safety
        // For example, you can use atomic operations like atomicCAS in CUDA
        return available;
    }
    // this method allows the fork to be picked up
    bool pickUp(){
        
        if (available) available = false;
        else return false;

    }

    // this method allows the fork to be put down
    void putDown() {available = true;}
};

// kernel definition
//in a way we can think about this as the table itself
__global__ void philosopherSimulation(Philosopher* philosophers, Fork* forks, int numPhilosophers) {
    //thread mapping
    int philosopherIdx = blockIdx.x; // one block per philosopher
    int forkIdx = threadIdx.x; // one thread per fork
    

    // TODO: Simulate philosopher actions (picking up forks, eating, thinking, ect)
}

// this is a testing kernal I will call apon when debugging.
// the idea is this is a single solution table of 5 philosophers I can use to test and garuntee any one solution no matter how absurd does infact, end deadlock
__global__ void testDeadlockResolution(Philosopher* philosophers, Fork* forks, int numPhilosophers = 5){
    int philosopherIdx = blockIdx.x; 
    int forkIdx = threadIdx.x;
    
    
}

