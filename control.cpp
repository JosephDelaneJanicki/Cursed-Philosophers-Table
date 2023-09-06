/*This is a control file meant to act as a test case to make sure any issue isnt in how vs code is set up. 
It types a simple hello message in a modern format to ensure vs code is infact set up to compile in the C++ 20 standard.
By calling apon format in the standard library I ensure this file needs the C++ 20 standard to run.
The main file for The philosophers table will be named "main"*/
#include<iostream>
#include<format>
using std::format;
using std::cout;

int main(){
    const char s[] {"Hello"};
    cout << format("test message {}\n",s);
    
}