# Define our host system
SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_VERSION 1)
# Define the cross compiler locations
SET(CMAKE_C_COMPILER   /usr/bin/arm-linux-gnueabihf-gcc-5)
SET(CMAKE_CXX_COMPILER /usr/bin/arm-linux-gnueabihf-g++-5)
# Define the sysroot path for the RaspberryPi distribution in our tools folder 
SET(CMAKE_FIND_ROOT_PATH /usr/arm-linux-gnueabihf/)
# Use our definitions for compiler tools
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# Search for libraries and headers in the target directories only
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
#add_definitions(-funsafe-math-optimizations -ffast-math -D_ARM -Wa,-mimplicit-it=thumb)

set(tARM TRUE)
set(CURSES_LIBRARY /usr/arm-linux-gnueabihf/lib) 
set(CURSES_INCLUDE_PATH /usr/arm-linux-gnueabihf/include)

