CXX = g++
NVCC = nvcc
CXXFLAGS = -std=c++20
NVCCFLAGS = -std=c++14 -arch=sm_30
EXECUTABLE = control
SOURCE_FILES = control.cpp philosopher.cu

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE_FILES)
    $(NVCC) $(NVCCFLAGS) -o $(EXECUTABLE) $(SOURCE_FILES)

clean:
    rm -f $(EXECUTABLE)