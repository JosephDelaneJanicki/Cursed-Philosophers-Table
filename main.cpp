#include <iostream>
#include "philosopher.cu"
#include <cuda_runtime.h>
#include <random>
#include <format>

using std::format;
using std::cout;
using std::cin;
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
    int numOfPhilosophers {}; // initialize where the number of philosophers will be stored
    int simulationChoice {};
    //prompt for the number of philosophers and read input
    while (true){
        cout << format("How many philosophers would you like to simulate?");
        if (cin >> numOfPhilosophers && numOfPhilosophers > 0) break;
        else{
            cout << "Invalid input. the number of philosophers must be a positive integer" << std::endl;
            cin.clear(); // Clear any error flags
            cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // Discard the rest of the line
        }
    }
    /*this is a prompt to allow me to choose between the test kernel and the main kernel in runtime*/
    while (true){
        cout << format("do you wish to use the main or test simulation: type 1 for main and 2 for test");
        cin >> simulationChoice;
        if ( simulationChoice == 1 || simulationChoice == 2) break;
    else{
            cout << "Invalid input. type 1 for main, type 2 for test" << std::endl;
            cin.clear(); // Clear any error flags
            cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // Discard the rest of the line
        }
    }

    /* Create philosopher objects in host code this has function scope and as a result will only call from main and be destroyed when we move to the kernel (assuming main finishes)
    the line below should account for C++'s requirement to know the size of the array at compilation by using the heap and envoking the "new" operator.*/
    Philosopher* hostPhilosophers = new Philosopher[numOfPhilosophers];
    Fork* hostForks = new Fork[numOfPhilosophers];
    // Makes philosophers and forks on host and puts them on the gpu.
    Philosopher* devicePhilosopher;
    Fork* deviceFork;
    cudaMalloc((void**)&devicePhilosopher, sizeof(Philosopher)*numOfPhilosophers);
    cudaMemcpy(devicePhilosopher, &hostPhilosophers, sizeof(Philosopher)*numOfPhilosophers, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&deviceFork,sizeof(Fork)*numOfPhilosophers);
    cudaMemcpy(deviceFork,&hostForks,sizeof(Fork)*numOfPhilosophers,cudaMemcpyHostToDevice);

    // Perform GPU operations with devicePhilosopher
    if(simulationChoice==1){
        int numBlocks={};
        int threadsPerBlock={};
        /*decided ill make the kernel first then call it accordingly*/
        //philosopherSimulation<<<numBlocks, threadsPerBlock>>>(devicePhilosopher, deviceFork, numOfPhilosophers);
        cudaDeviceSynchronize(); // Wait for the kernel to finish
    }
    else if(simulationChoice==2){
        /*ill do the same as above but for the test kernel*/
    }

    // Cleanup
    delete[] hostPhilosophers;
    delete[] hostForks;
    cudaFree(devicePhilosopher);
    cudaFree(deviceFork);

    return 0;
}