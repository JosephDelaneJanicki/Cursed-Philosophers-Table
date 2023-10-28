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
    //initialize random seed
    srand(time(NULL)); 
    
    cudaError_t cudaStatus; // cudaStatus variable for error checking
    
    cudaStatus = cudaSetDevice(0);  // garuntees gpu 0 is used for those running sli however unlikely it is

    //check for a nvidia gpu and prompts the user if they dont
    if (cudaStatus != cudaSuccess) {
        std::cerr << "Cuda failed to set, the philosophers are very picky, they only eat on Nvidia brand tables." << std::endl;
        return 1;
    }
    int numOfPhilosophers {}; // initialize where the number of philosophers will be stored
    int simulationChoice {};
    int iterations {};
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
    //prompt for number of iterations or "steps" to run the simulation for
    while(true){
        cout << format("How many iterations would you like to run the simulation for?");
        
        if( cin >> iterations && iterations > 0) break;
        else{
            cout << "Invalid input. the number of iterations must be a positive integer" << std::endl;
            cin.clear(); // Clear any error flags
            cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n'); // Discard the rest of the line
        }

    }

    /* Create philosopher objects in host code this has function scope and as a result will only call from main and be destroyed when we move to the kernel (assuming main finishes)
    the line below should account for C++'s requirement to know the size of the array at compilation by using the heap and envoking the "new" operator.*/
    Philosopher* h_Philosophers = new Philosopher[numOfPhilosophers];
    Fork* h_Forks = new Fork[numOfPhilosophers];

    // Makes philosophers and forks for device
    Philosopher* d_Philosopher;
    Fork* d_Fork;
    //allocate philosophers
    cudaStatus = cudaMalloc((void**)&d_Philosopher, sizeof(Philosopher)*numOfPhilosophers);
    if (cudaStatus != cudaSuccess) {fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaStatus));return 1;}
    cudaStatus = cudaMemcpy(d_Philosopher, &h_Philosophers, sizeof(Philosopher)*numOfPhilosophers, cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaStatus));return 1;}
    //allocate forks
    cudaStatus = cudaMalloc((void**)&d_Fork,sizeof(Fork)*numOfPhilosophers);
    if (cudaStatus != cudaSuccess) {fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaStatus));return 1;}
    cudaStatus = cudaMemcpy(d_Fork,&h_Forks,sizeof(Fork)*numOfPhilosophers,cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(cudaStatus));return 1;}
    // Perform GPU operations with devicePhilosopher

    if(simulationChoice==1){ //run as one philosopher per thread
        //set the number of blocks and 
        int numBlocks=1;
        int threadsPerBlock=numOfPhilosophers;
        //envoke the kernel
        philosophersAsThreads<<<numBlocks, threadsPerBlock>>>(d_Philosopher, d_Fork, numOfPhilosophers,iterations);
        cudaDeviceSynchronize(); // Wait for the kernel to finish
    }

    else if(simulationChoice==2){
        int numBlocks=1;
        int threadsPerBlock=5;
        //envoke the kernel
        testDeadlockSolution<<<numBlocks, threadsPerBlock>>>(d_Philosopher, d_Fork,iterations);
    }

    // Cleanup
    delete[] h_Philosophers;
    delete[] h_Forks;
    cudaFree(d_Philosopher);
    cudaFree(d_Fork);

    return 0;
}