# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = "/Applications/CMake 2.8-12.app/Contents/bin/cmake"

# The command to remove a file.
RM = "/Applications/CMake 2.8-12.app/Contents/bin/cmake" -E remove -f

# Escaping for special characters.
EQUALS = =

# The program to use to edit the cache.
CMAKE_EDIT_COMMAND = "/Applications/CMake 2.8-12.app/Contents/bin/ccmake"

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/ngrebenshikov/pyramid/lib/bullet/Demos

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/ngrebenshikov/pyramid/lib/bullet/Demos

# Include any dependencies generated for this target.
include HelloWorld/CMakeFiles/AppHelloWorld.dir/depend.make

# Include the progress variables for this target.
include HelloWorld/CMakeFiles/AppHelloWorld.dir/progress.make

# Include the compile flags for this target's objects.
include HelloWorld/CMakeFiles/AppHelloWorld.dir/flags.make

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o: HelloWorld/CMakeFiles/AppHelloWorld.dir/flags.make
HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o: HelloWorld/HelloWorld.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /Users/ngrebenshikov/pyramid/lib/bullet/Demos/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o"
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/AppHelloWorld.dir/HelloWorld.o -c /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld/HelloWorld.cpp

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/AppHelloWorld.dir/HelloWorld.i"
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  $(CXX_DEFINES) $(CXX_FLAGS) -E /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld/HelloWorld.cpp > CMakeFiles/AppHelloWorld.dir/HelloWorld.i

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/AppHelloWorld.dir/HelloWorld.s"
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld && /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++  $(CXX_DEFINES) $(CXX_FLAGS) -S /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld/HelloWorld.cpp -o CMakeFiles/AppHelloWorld.dir/HelloWorld.s

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.requires:
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.requires

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.provides: HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.requires
	$(MAKE) -f HelloWorld/CMakeFiles/AppHelloWorld.dir/build.make HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.provides.build
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.provides

HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.provides.build: HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o

# Object files for target AppHelloWorld
AppHelloWorld_OBJECTS = \
"CMakeFiles/AppHelloWorld.dir/HelloWorld.o"

# External object files for target AppHelloWorld
AppHelloWorld_EXTERNAL_OBJECTS =

HelloWorld/AppHelloWorld: HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o
HelloWorld/AppHelloWorld: HelloWorld/CMakeFiles/AppHelloWorld.dir/build.make
HelloWorld/AppHelloWorld: HelloWorld/CMakeFiles/AppHelloWorld.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable AppHelloWorld"
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/AppHelloWorld.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
HelloWorld/CMakeFiles/AppHelloWorld.dir/build: HelloWorld/AppHelloWorld
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/build

HelloWorld/CMakeFiles/AppHelloWorld.dir/requires: HelloWorld/CMakeFiles/AppHelloWorld.dir/HelloWorld.o.requires
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/requires

HelloWorld/CMakeFiles/AppHelloWorld.dir/clean:
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld && $(CMAKE_COMMAND) -P CMakeFiles/AppHelloWorld.dir/cmake_clean.cmake
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/clean

HelloWorld/CMakeFiles/AppHelloWorld.dir/depend:
	cd /Users/ngrebenshikov/pyramid/lib/bullet/Demos && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/ngrebenshikov/pyramid/lib/bullet/Demos /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld /Users/ngrebenshikov/pyramid/lib/bullet/Demos /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld /Users/ngrebenshikov/pyramid/lib/bullet/Demos/HelloWorld/CMakeFiles/AppHelloWorld.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : HelloWorld/CMakeFiles/AppHelloWorld.dir/depend

