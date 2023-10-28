Here is the spell and grammar checked version of your `readme.md` file:

# Cursed Philosophers Table

This project aims to solve the philosopher's table problem in increasingly unconventional or "cursed" ways. The philosopher's table is a common example used to describe deadlock when multithreading as processes compete for resources. The philosophers have access to a number of forks. There are the same number of forks as there are philosophers. One philosopher can eat when they have two forks; otherwise, they are in a "thinking state". The idea of the problem is what happens when each philosopher takes and holds onto one fork and has to wait for the philosopher next to them to drop their fork. The philosophers must wait forever. The rule is simple. They will have to be brought out of deadlock so long as it technically gets them out of deadlock; it's fair game. I'll start with regular ways of achieving this. Then I will present more ways, each hopefully more entertaining than the last.

## Plan of Implementation:

As of the moment, I'm trying to make sure everything is set up for the actual coding and testing process to be as smooth as possible. I'm close to achieving this.

Part of the reason I chose to do a philosopher's table is to strengthen my skill in parallelism and with CUDA code. My plan is to code each philosopher as an object and give each their own thread (Update: I may make each a block). As for the parallelism itself, I'm using this project as an excuse to actually use CUDA. Since each philosopher will use a CUDA thread, that means this program will have an NVIDIA GPU requirement. Here's a high-level description of what I'll be doing:

1. Create an object that represents the behavior of a philosopher. This object will contain logic for picking up forks, eating, and putting down forks.

2. Launch multiple instances of the philosopher object and assign them to separate CUDA threads (potentially blocks; I'm still considering options on the parallelism). This should allow flexibility with the philosophers.

Beyond that, text output and other more CPU-suited tasks, I'm leaving in plain C++, specifically on the C++ 20 standard. I was planning on using a simple boolean array for the forks to track their availability. Then I realized the potential for some really absurd solutions to deadlock by changing the attributes of the forks and decided I'll see if I can't make them an object. I'll keep this readme updated as this project continues.

**UPDATE 1: 9/11/2023**

I have the beginning of the philosophers' code that defines the philosopher object, how the philosophers behave, and maps them to threads. I have also made a CUDA control file to ensure nothing is wrong with CUDA and C++ 20 compilation. My time was largely spent making sure this won't be an issue for me as I make this.

**UPDATE 2: 9/14/2023**

I have added some device functions to the Philosopher object. I plan to handle device/GPU memory in the CUDA code rather than on the host due to the potential for non-trivial members in the object. The functions are simple in form now and will be changed as the object does. Hoping to have more time soon for bigger updates. I'm teaching myself CUDA as I do this. Added test kernel to test and debug different solutions in a controlled vacuum in isolation. The test table will have 5 philosophers. Fork object added.

**UPDATE 3: 9/15/2023**

Added the logic for picking up forks. Two versions actually:

1. The first version is the default version. The philosopher picks up one fork at a time, allowing for deadlock.

2. The second version is what I plan to have become my first solution to the problem. As the first, it's not a "Cursed" solution. The idea is to have philosophers pick up both forks simultaneously. This means philosophers will all either have both forks or have no forks. Theoretically, no deadlock. I'll see if the solution implemented works out in practice.

**UPDATE 4: 9/16/2023**

Added mutexes and got more of the fork object made. VS Code is throwing a fit over not recognizing `atomicExch` as a thing that exists, so next time I work on this will be me troubleshooting that. I have a feeling some part of my installation is outdated.

**UPDATE 5: 9/19/2023**

I fixed VS Code's issue with `atomicExch`. I then noticed that in the fork pickup method, I closed the mutex in the condition where the fork isn't available but didn't close it in the case where the fork is. Any philosophers that pick up a fork would've kept the fork in a mutex forever. I fixed this by closing the mutex in the if statement rather than in the put-down method, that way other philosophers can still read the fork for availability. I thought about re-implementing to use a mutex to lock philosophers from forks, but I don't really need to since the availability variable already handles it, and doing it this way allows for solutions where philosophers could steal each other's forks, which is in the spirit of the absurdity I'm going for. Beyond that, I fixed the indentations to make the code look better and be more readable. I like to pride myself on aesthetically pleasing code.

**Update 6:**

I have an array of philosophers allocated to my GPU. I'll be following a similar process to allocate the forks, and from there, I should be good to invoke the kernel from the main and manage the simulation from there.

**Update 7:**

Forks are now allocated. I'll be putting a pin on host code for now and making the actual kernel itself. I'm still considering whether to do a block per philosopher with a thread per fork or to just do a thread per philosopher. There are pros and cons, and I want to choose a solution based on scalability, modularity, and the ability to smoothly interact with the forks and philosophers to allow more solutions to deadlock.

**Update 8:**

The first kernel is starting to come together. I feel I'm close to the first running demo of the project and am getting a good understanding of CUDA. I decided to use a switch statement and a random number generator to have every philosopher use a random solution every iteration. I will also output text on every action the philosophers take; this should allow the program to tell a sort of story of what all the philosophers did in the simulation. There is one thing to note: deadlock can still theoretically happen if all of the philosophers choose the deadlockable case in the switch case and all pick up one fork. I may remove the deadlock case and put it in a "deadlockable kernel" for the purpose of the code of the original issue existing in the program. Beyond that, I did some setup for solutions that involve terminating philosophers, including a death flag, a getter for the flag, ensuring dead philosophers don't take forks to the grave with them, and a condition statement to have dead philosophers skip iterations with no action.

**Update 9:**

I realized that there is a way simpler and less problem-prone way to simulate thinking and eating: just use a for loop with a massive iteration count. No calls to anything else, no methods, no data movement, just looping.

I also changed the random number generator implementation to be more GPU-friendly (line 131).

Additionally, I deleted the unused global mutex since I'm using CUDA's built-in mutex functions, which are more GPU-friendly. I also did some clean-up elsewhere, including the deletion of duplicate "think" and "eat" methods left after the switch statement.

I've added error handling for memory allocation in the host code and set up the block and thread count in the conditionals that decide which kernel to call based on user input. I'm keeping the memory allocation outside of the conditions called once since the only thing changing is the block and thread count.

I've set up the host to call the kernel and updated the makefile, so now running "make" from the file directory should create an executable.

Due to scope issues, I had to move the fork class to be located before the philosopher. Basically, I was defining the fork object after the philosopher object has calls to it, which isn't good coding convention(it's best to define classes in logical orderso that the reader and compiler encounters the definitions in logical top down order). It was a massive oversight, and I'm admittedly a little embarrassed I didn't notice this sooner. Either way, the code itself, I believe, is about ready to test with the main issue being that my CUDA installation appears to be broken with `atomicExch` and `__syncthreads` being marked as unfound identifiers.