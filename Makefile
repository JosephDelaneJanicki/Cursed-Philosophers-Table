CXX = g++
CXXFLAGS = -std=c++20
EXECUTABLE = control
SOURCE_FILES = control.cpp

all: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE_FILES)
    $(CXX) $(CXXFLAGS) $(SOURCE_FILES) -o $(EXECUTABLE)

clean:
    rm -f $(EXECUTABLE)