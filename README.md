# Cursed-Philosophers-Table
This project aims to solve the philosophers table problem in increasingly unconventional or "cursed" ways.
The philosophers table is a common example used to describe deadlock when multithreading as processes compete for rescources
The philosophers have access to a number of forks. There are the same number of forks as there are philosophers. One philosopher can eat when they have two forks, otherwise they are in a "thinking state".
The idea of the problem is what happens when each philosopher takes and holds onto one fork and has to wait for the philosopher next to them to drop their fork. The philosophers must wait forever.
The rule is simple. They will have to be brought out of deadlock. so long as it technically gets them out of deadlock its fair game.
Ill start with regular ways of achieving this. Then I will present more ways, each hopefully more entertaining then the last.

Plan of Implementation:
as of the moment im trying to make sure everything is set of for the actual coding and testing process to be as smooth as possible. im close to achieving this.

Part of the reason I chose to do a philosophers table is to strengthen my skill in parrallelism and with Cuda code. My plan is to code each philosopher as an object and give each their own thread (Update I may make each a block).
as for the parrallelism itself im using this project as an excuse to actually use cuda. Since each philosopher will use a cuda thread that means this program will have a nvidia gpu requirement.
heres a high level description of what ill be doing:
Create an object that represents the behavior of a philosopher. This object will contain logic for picking up forks, eating, and putting down forks.
Launch multiple instances of the philosopher object, and assign them to separate CUDA threads (potentially blocks im still considering options on the parrallelism). this should allow flexibility with the philosophers
beyond that text output and other more cpu suited tasks im leaving in plain C++, specifically on the C++ 20 standard.
I was planning on using a simple boolean array for the forks to track their availability. Then I realized the potential for some really absurd solutions to deadlock by changing the attributes of the forks and decided I'll see if I cant make them an object. I'll keep this readme updated as this project continues.
UPDATE 1: 9/11/2023

  I have the begining of the philosophers Code that defines the philosopher object, how the philosophers behave, and maps them to threads. 
  I have also made a cuda control file to ensure nothing is wrong with cuda and C++ 20 compilation. my time was largely spent making sure this wont be an issue for me as I make this

UPDATE 2: 9/14/2023

  I have added some device functions to the Philosopher object. I plan to handle device/gpu memory in the cuda code rather then host due to the potential for non trivial members in the object.
  The functions are simple in form now and will be changed as the object does. Hoping to have more time soon for bigger updates. I'm  teaching myself cuda as I do this.
  Added test kernel to testand debug different solutions in a controled vacuum in isolation.
  The test table will have 5 philosophers.
  Fork object added.
  
UPDATE 3: 9/15/2023

  Added the logic for picking up forks. Two versions actually:
    The first version is the default version. the philosopher picks up one fork at a time allowing for deadlock. 
    The second version is what i plan to have become my first solution to the problem. as the first its not a "Cursed" solution. the idea is to have philosophers pick up both forks simultaniously. 
    This means philosophers will all either have both forks, or have no forks. Theoretically no deadlock. I'll see if the solution implemented works out in practice.

UPDATE 4: 9/16/2023

  Added mutexes and got more of the fork object made. VS code is throwing a fit over not recognizing atomicExch as a thing that exists so next time I work on this will be me troubleshooting that. I have a feeling some part of my instalation is outdated.
  
UPDATE 5: 9/19/2023

  I fixed VS codes issue with atomicExch. I then noticed that in the fork pickup method i closed the mutex in the condition where the fork isnt available but didn't clsoe it in the case where the fork is. 
  Any philosophers that pick up a fork would've kept the fork in a mutex forever. I fixed this by closing the mutex in the if staement rather then in the put down method that  way other philosophers can still read the fork for availability.
  I though about re-implamenting to use a mutex to lock philosophers from forks but i dont really need to since the availability variable already handles it and doing it this way alows for solutions where philosophers could steal eachothers forks witch is in the spirit of the absurdity im going for.
  beyond that I fixed the indentations to make the code look better and be more readable. i like to pride myself on aesthetically pleasing code.

Update 6:

  I have an array of philosophers allocated to my gpu. I'll be following a similar process to allocate the forks and from there I should be good to envoke the kernel from main and manage the simulation from there.
  
Update 7:

  Forks are now allocated. Ill be putting a pin on host code for noe and make the actual kernel itself. 
  I'm still considering wether to do a block per philosopher with a thread per fork or to jsut do a thread per philosopher. there are pros and cons and I want to choose a solution based on scaleability, modularity, and ability to smoothly interact with the forks and philosophers to allow more solutions to deadlock.

Update 8:
  The first kernel is starting to come together. I feel im close to the first running demo of the project and am getting a good understanding of CUDA. 
  I decided to use a switch statement and a random number generator to have every philosopher use a random solution every iteration. I will also output text on every action the philosophers take. this should allow the program to tell a sort of story of what all the philosophers did in the simulation. 

  there is one thing to note. deadlock can still theoretically happen if all of the philosophers choose the deadlockable case in the switch case and all pick up one Fork.

  I may remove the deadlock case and put it in a "deadlockable kernel" for the purpose of the code of the original issue existing in the program.

  beyond that i did some set up for solutions that involve terminating philosophers including a death flag, a getter for the flag, ensuring dead philosophers dont take forks to the grave with them, and a condition statement to have dead philosophers skip iterations with no action.

Update 9:
  realized there is a way simpler and less problem prone way to simulate thinking and eating. just use a for loop with a massive iteration count, no calls to anything else  no methods, no data movement, just looping.

  changed the rng implamented to be more gpu friendly. line 131

  deleted unused global mutex since im using Cudas built in mutex functions wich is more gpu friendly. i also did clean up elsewhere including the Deletion of duplicate
  think and eat methods left after the switch statement
  
  added error handling for memory allocation in the host code and set up the block and thread count in the conditionals that decide wich kernel to call based on user input. I'm keeping the memory allocation outside of the conditions called once since the only thing changing is the block and thread count. 

  set up the host to call the kernel and updated the makefile so now running "make" from the file directory should create an executable
