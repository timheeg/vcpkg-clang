#
# Set compiler flags
#
# See https://cmake.org/cmake/help/latest/guide/tutorial/Adding%20Usage%20Requirements%20for%20a%20Library.html#exercise-2-setting-the-c-standard-with-interface-libraries

set(gcc_like_cxx "$<COMPILE_LANG_AND_ID:CXX,Clang,GNU>")
set(msvc_cxx "$<COMPILE_LANG_AND_ID:CXX,MSVC>")

add_library(compiler_flags INTERFACE)

# Specify compiler warning flags only when building.
target_compile_options(compiler_flags INTERFACE
  "$<${gcc_like_cxx}:$<BUILD_INTERFACE:-Wall;-Wextra;-Wshadow;-Wformat=2;-Werror>>"
  "$<${msvc_cxx}:$<BUILD_INTERFACE:-W3>>"
)

# All users of this library will need at least C++20
target_compile_features(compiler_flags INTERFACE cxx_std_20)

# Use std not gnu extensions
set_target_properties(compiler_flags PROPERTIES CXX_EXTENSIONS OFF)
