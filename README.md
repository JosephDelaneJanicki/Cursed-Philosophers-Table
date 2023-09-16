# Cursed-Philosophers-Table
This project aims to solve the philosophers table problem in increasingly unconventional or "cursed" ways.
the philosophers table is a common example used to describe deadlock whem multithreading and parrallelism as processes compete for rescources
the philosophers have access to a number of forks. There are the same number of forks as there are philosophers. 
one philosopher can eat when they have two forks, otherwise they are in a "thinking state".
the idea of the problem is what happens when each philosopher takes and holds onto one fork and has to wait phor the philosopher next to them to drop their fork.
The philosophers must wait forever.
the rule is simple. They will have to be brought out of deadlock. so long as it technically gets them out of deadlock its fair game.
ill start with regular ways of achieving this. then I will present more ways, each hopefully more entertaining then the last.

Plan of Implementation:
as of the moment im trying to make sure everything is set of for the actual coding and testing process to be as smooth as possible. im close to achieving this.

Part of the reason I chose to do a philosophers table is to strengthen my skill in parrallelism. my plan is to code each philosopher as an object and give each their own thread.
as for the parrallelism itself im using this project as an excuse to actually use cuda. since each philosopher will use a cuda thread that means this program will have a nvidia gpu requirement.
heres a high level description of what ill be doing:
Create a kernel that represents the behavior of a philosopher. This kernel will contain logic for picking up forks, eating, and putting down forks.

Launch multiple instances of the philosopher kernel, each representing one philosopher, and assign them to separate CUDA threads.

this should allow a lot of flexibility in philospher logic. 

beyond that text output and other more cpu suited tasks im leaving in plain C++, specifically on the C++ 20 standard.

I was planning on using a simple boolean array for the forks to track their availability. but then I realized the potential for some really absurd solutions to deadlock by changing the attributes of the forks and decided I'll see if I cant make them an object.

I'll keep this readme updated as this project continues

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
  
