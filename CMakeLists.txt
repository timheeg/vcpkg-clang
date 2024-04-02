cmake_minimum_required(VERSION 3.28)

project(vcpkg-clang LANGUAGES CXX)

find_package(unofficial-libuuid CONFIG REQUIRED)

add_executable(vcpkg-clang-exe)
target_sources(vcpkg-clang-exe PRIVATE src/main.cpp)

# Define compiler flags target
include(compiler_flags)

target_link_libraries(vcpkg-clang-exe PRIVATE
  compiler_flags
  unofficial::UUID::uuid
)
