set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE dynamic)

set(VCPKG_CMAKE_SYSTEM_NAME Linux)

set(VCPKG_FIXUP_ELF_RPATH ON)

set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE
  ${CMAKE_CURRENT_LIST_DIR}/../toolchain/clang-16.cmake)

message("x64-linux-clang16-dynamic triplet CMAKE_C_COMPILER = ${CMAKE_C_COMPILER}")
message("x64-linux-clang16-dynamic triplet CMAKE_CXX_COMPILER = ${CMAKE_CXX_COMPILER}")
