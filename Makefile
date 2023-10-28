CXX = g++
NVCC = nvcc
CXXFLAGS = -std=c++20
NVCCFLAGS = -std=c++14 -arch=sm_52
EXECUTABLE = CursedPhilosophersTable
SOURCE_FILES = main.cpp philosopher.cu

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE_FILES)
    $(NVCC) $(NVCCFLAGS) -o $(EXECUTABLE) $(SOURCE_FILES)

clean:
    rm -f $(EXECUTABLE)