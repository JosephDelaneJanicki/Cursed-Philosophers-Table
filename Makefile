CXX = g++
NVCC = nvcc
CXXFLAGS = -std=c++20
NVCCFLAGS = -std=c++20 -arch=sm_86
EXECUTABLE = CursedPhilosophersTable
SOURCE_FILES = main.cpp philosopher.cu

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE_FILES)
    $(NVCC) $(NVCCFLAGS) -o $(EXECUTABLE) $(SOURCE_FILES)

clean:
    rm -f $(EXECUTABLE)