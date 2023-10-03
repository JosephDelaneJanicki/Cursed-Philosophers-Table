// this is the file that will make the philosopher object and map philosophers to threads. from there the gpu will handle the philosophers
// philosopher.cu
#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <curand_kernel.h>
#include <cstdio>

//initializa mutex
/*NOTE: avoid mutexes in philosopher class, mutexes would be best in the fork class and kernel to minimize sequential time and maximize parrallel time. philosophers do the things 
forks are the rescources so let the forks protect themselves with mutexes philosophers are supposed to be fork greedy */
__device__ int mutex; // Declare a mutex variable

// Philosopher definition
class Philosopher {
    public:

        __device__ void think() {
            int startTime = clock();
            while (clock() - startTime < 1000000) { /*the philosopher is thinking, using a busy wait loop to simulate it for now will add logic as needed later on*/ }
        }

        __device__ void tryToPickUpForks(Fork& leftFork, Fork& rightFork){

            if (leftFork.isAvailable())  {leftFork.pickUp(); think();}  // by thinking here i can garuntee deadlock since now the forks are picked up one at a time
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
        __device__ void kill(Fork& leftFork, Fork& rightFork){
            dead = true;
            leftFork.putDown();
            rightFork.putDown();
        }
        //dead getter method
        __device__ bool isDead(){
            return dead;
        }

    private:
        bool dead = false;
};
// Fork object to allow solutions that involve changing something about the fork/forks. Forks are picked up and put down by philosophers
class Fork{
    private:

        bool available = true;  //fork availability to pick up, by default they are available
        int* mutex; // Private mutex for each fork

    public:

        int temprature {}; // how hot or cold the fork is to the touch

        // this method checks if a fork is available since this is a read only method i dont have a mutex here
        __device__ bool isAvailable() {
            return available;
        }

        // this method allows the fork to be picked up
        __device__ bool pickUp() {
            while (atomicExch(mutex, 1) != 0) {
            // Wait while the mutex is locked
            }
            /*other philosophers need to be able to read the fork object to check availability. 
            I also want to minimize mutext time so im closing the mutex imediately when available value changes*/ 
            if (available) {
                available = false;
                atomicExch(mutex, 0); // Release the mutex 
                return true; // Successfully picked up the fork
            }       
            else {
                atomicExch(mutex, 0); // Release the mutex
                return false; // Fork is not available
            }
        }

        // I opted not to use a mutex on this function since only one philosopher will be attempting to use this method per fork at any time
        __device__ void putDown() {
            available = true; // Fork is now available for other philosophers
        }
};

// kernel definitions
// in a way we can these about this as the table the philosophers eat at

// philosophers as blocks kernel simpler but may be less GPU efficient
__global__ void philosophersAsBlocks(Philosopher* philosophers, Fork* forks, int numPhilosophers) {
    //thread mapping
    int philosopherIdx = blockIdx.x * blockDim.x + threadIdx.x; // Calculate a unique index for each philosopher
    int leftForkIdx = philosopherIdx; // Fork on the left side of the philosopher
    int rightForkIdx = (philosopherIdx + 1) % numPhilosophers; // Fork on the right side of the philosopher
    
}

// philosophers and forks as threads will require more synchronization but is more GPU efficient
__global__ void philosophersAsThreads(Philosopher* philosophers, Fork* forks, int numPhilosophers,int iterations) {
    //thread mapping
    int philosopherIdx = threadIdx.x; // one thread per philosopher
    int leftForkIdx = philosopherIdx; // Fork on the left side of the philosopher
    int rightForkIdx = (philosopherIdx + 1) % numPhilosophers; // Fork on the right side of the philosopher

    for (int iteration = 0; iteration < iterations; ++iteration) {
        // Philosopher actions
        int philosopherId = philosopherIdx; // Get the philosopher's ID
        Philosopher& philosopher = philosophers[philosopherId];

        int randomChoice = rand() % 2; // generate random number for the thread to choose a random solution if any

        //check if the philosopher is dead and skip the iteration if they are
        bool isDead = philosophers[philosopherIdx].isDead();
        if(isDead) continue;

        // switch case that handels the choice of solution. as i make more solutions i can implement them in a case here and increase the int pool in randomChoice accordingly
        switch (randomChoice) {
            case 0:
                //first case allows deadlock to happen eat method is called in try to pick up forks
                printf("Philosopher %d is thinking.\n", philosopherId);
                philosophers[philosopherId].think();
                //this case is ordinary and avoids deadlock by having the philosopher pick up both forks at the same time
                printf("Philosopher %d is trying to pick up forks.\n", philosopherId);
                philosophers[philosopherId].tryToPickUpForks(forks[leftForkIdx],forks[rightForkIdx]);
                break;
            case 1:
                printf("Philosopher %d is thinking.\n", philosopherId);
                philosophers[philosopherId].think();
                printf("Philosopher %d is trying to pick up forks.\n", philosopherId);
                philosophers[philosopherId].tryToPickUpForksAvoidDeadlock(forks[leftForkIdx],forks[rightForkIdx]);
                break;
    }
        philosophers[philosopherId].think();
        philosophers[philosopherId].tryToPickUpForks(forks[leftForkIdx],forks[rightForkIdx]);

        // Synchronize threads to avoid conflicts
        __syncthreads();
    }
}

// this is a testing kernal I will call apon when debugging.
// the idea is this is a single solution table of 5 philosophers I can use to test and garuntee any one solution no matter how absurd does infact, end deadlock
// I'll base it on the philosophers as threads kernel
__global__ void testDeadlockResolution(Philosopher* philosophers, Fork* forks, int numPhilosophers = 5){
int philosopherIdx = threadIdx.x;
int leftForkIdx = philosopherIdx;
int rightForkIdx = (philosopherIdx + 1) % numPhilosophers;
}