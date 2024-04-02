# vcpkg-clang

Test project that builds `vcpkg` dependencies with the `clang` compiler.

## Dev Container

Uses `RHEL8` build environment.

### Build Container

In vscode, `Ctrl + Shift + P` and select "Dev Containers: Rebuild Container".

Select the `clang-build-env` option to build a container setup for `clang`
builds. Select the `gcc-build-env` option to build a container setup for `gcc`
builds.

### RHEL container subscription

The container uses the RHEL8 UBI image.

In order to setup RHEL8 repos for `dnf install` you must register your RHEL
subscription.

Use activation keys from subscription account
<https://access.redhat.com/management/activation_keys>

See [RHEL8 Setup](docs/rhel8.md) for more details.

> ⚠️ Caution - This is currently done inside the container instance. Don't
distribute your container instance unless you want to make your RHEL8 activation
key public for everyone. 😉

## Usage

From the terminal command line,

```bash
cmake --preset x64-linux-gcc-static-release
cmake --build --preset x64-linux-gcc-static-release
```

## Vcpkg

This uses vcpkg dependency manager. It currently does not use binary caching, so
all dependencies will be built from source when the container is rebuilt.

## 🐉 Clang Builds

This project defines 2 different clang build presets for demonstration.

1. `x64-linux-clang-static-release` - uses vcpkg `x64-linux` and sets
`CMAKE_CXX_COMPILER` to clang

2. `x64-linux-custom-clang-static-release` - defines a custom vcpkg triplet and
toolchain

### ✖️ Problems only setting `CMAKE_CXX_COMPILER`

The `x64-linux-clang-static-release` preset acts exactly like the standard
`gcc` build and uses the `x64-linux` triplet. However, it sets the
`CMAKE_CXX_COMPILER` to clang for execution.

In this case, `vcpkg` is not influenced by the cmake cache variables. The vcpkg
debug output shows that it detects the old `gcc 8.5` that got installed along
with the `llvm-toolset` install, and vcpkg uses that compiler hash in
`triplet_abi`.

```sh
Detecting compiler hash for triplet x64-linux...
[DEBUG] 1008: execute_process( /opt/cmake-3.28.3-linux-x86_64/bin/cmake -DCURRENT_PORT_DIR=/vcpkg/scripts/detect_compiler -DCURRENT_BUILDTREES_DIR=/vcpkg/buildtrees/detect_compiler -DCURRENT_PACKAGES_DIR=/vcpkg/packages/detect_compiler_x64-linux -D_HOST_TRIPLET=x64-linux -DCMD=BUILD -DDOWNLOADS=/vcpkg/downloads -DTARGET_TRIPLET=x64-linux -DTARGET_TRIPLET_FILE=/vcpkg/triplets/x64-linux.cmake -DVCPKG_BASE_VERSION=2024-03-14 -DVCPKG_CONCURRENCY=21 -DVCPKG_PLATFORM_TOOLSET=external -DGIT=/usr/bin/git -DVCPKG_ROOT_DIR=/vcpkg -DPACKAGES_DIR=/vcpkg/packages -DBUILDTREES_DIR=/vcpkg/buildtrees -D_VCPKG_INSTALLED_DIR=/workspaces/vcpkg-clang/build/x64-linux-clang-static-release/vcpkg_installed -DDOWNLOADS=/vcpkg/downloads -DVCPKG_MANIFEST_INSTALL=OFF -P /vcpkg/scripts/ports.cmake)
[DEBUG] -- Found external ninja('1.11.1').
[DEBUG] -- Configuring x64-linux-rel
[DEBUG] -- The C compiler identification is GNU 8.5.0
[DEBUG] -- Detecting C compiler ABI info
[DEBUG] -- Detecting C compiler ABI info - done
[DEBUG] -- Check for working C compiler: /usr/bin/cc - skipped
[DEBUG] -- Detecting C compile features
[DEBUG] -- Detecting C compile features - done
[DEBUG] -- The CXX compiler identification is GNU 8.5.0
[DEBUG] -- Detecting CXX compiler ABI info
[DEBUG] -- Detecting CXX compiler ABI info - done
[DEBUG] -- Check for working CXX compiler: /usr/bin/c++ - skipped
[DEBUG] -- Detecting CXX compile features
[DEBUG] -- Detecting CXX compile features - done
[DEBUG] -- Configuring done (29.1s)
[DEBUG] -- Generating done (0.0s)
[DEBUG] -- Build files have been written to: /vcpkg/buildtrees/detect_compiler/x64-linux-rel
[DEBUG] 
[DEBUG] #COMPILER_HASH#4ff97eb51bf9d3de908cf50805f8f4147b1275d0
[DEBUG] #COMPILER_C_HASH#56dc1caaf1c2ff8ebbdb6cedb96af17e0d67d57e
[DEBUG] #COMPILER_C_VERSION#8.5.0
[DEBUG] #COMPILER_C_ID#GNU
[DEBUG] #COMPILER_C_PATH#/usr/bin/cc
[DEBUG] #COMPILER_CXX_HASH#2e8ef35f382c23bd5fe7864e5499d66809830d3b
[DEBUG] #COMPILER_CXX_VERSION#8.5.0
[DEBUG] #COMPILER_CXX_ID#GNU
[DEBUG] #COMPILER_CXX_PATH#/usr/bin/c++
[DEBUG] CMake Warning:
[DEBUG]   Manually-specified variables were not used by the project:
[DEBUG] 
[DEBUG]     BUILD_SHARED_LIBS
[DEBUG]     CMAKE_INSTALL_BINDIR
[DEBUG]     CMAKE_INSTALL_LIBDIR
[DEBUG]     VCPKG_PLATFORM_TOOLSET
[DEBUG]     VCPKG_SET_CHARSET_FLAG
[DEBUG]     _VCPKG_ROOT_DIR
[DEBUG] 
[DEBUG] 
[DEBUG] 
[DEBUG] 1008: cmd_execute_and_stream_data() returned 0 after 29178952 us
[DEBUG] Detected compiler hash for triplet x64-linux: 4ff97eb51bf9d3de908cf50805f8f4147b1275d0
Compiler found: /usr/bin/c++
```

### ✔️ Using Custom Triplet and Toolchain

`VCPKG_CHAINLOAD_TOOLCHAIN_FILE` defines the location of the custom toolchain
file along with the standard vcpkg toolchain.

The custom toolchain sets the `CMAKE_CXX_COMPILER` to clang.

`VCPKG_OVERLAY_TRIPLETS` points to the folder containing the custom triplet,
`x64-linux-clang16` which is the same as the standard `x64-linux` triplet, but
also defines `VCPKG_CHAINLOAD_TOOLCHAIN_FILE` fro the custom toolchain.

```sh
Detecting compiler hash for triplet x64-linux-clang16...
[DEBUG] 1012: execute_process( /opt/cmake-3.28.3-linux-x86_64/bin/cmake -DCURRENT_PORT_DIR=/vcpkg/scripts/detect_compiler -DCURRENT_BUILDTREES_DIR=/vcpkg/buildtrees/detect_compiler -DCURRENT_PACKAGES_DIR=/vcpkg/packages/detect_compiler_x64-linux-clang16 -D_HOST_TRIPLET=x64-linux-clang16 -DCMD=BUILD -DDOWNLOADS=/vcpkg/downloads -DTARGET_TRIPLET=x64-linux-clang16 -DTARGET_TRIPLET_FILE=/workspaces/vcpkg-clang/tools/vcpkg/triplets/x64-linux-clang16.cmake -DVCPKG_BASE_VERSION=2024-03-14 -DVCPKG_CONCURRENCY=21 -DVCPKG_PLATFORM_TOOLSET=external -DGIT=/usr/bin/git -DVCPKG_ROOT_DIR=/vcpkg -DPACKAGES_DIR=/vcpkg/packages -DBUILDTREES_DIR=/vcpkg/buildtrees -D_VCPKG_INSTALLED_DIR=/workspaces/vcpkg-clang/build/x64-linux-custom-clang-static-release/vcpkg_installed -DDOWNLOADS=/vcpkg/downloads -DVCPKG_MANIFEST_INSTALL=OFF -P /vcpkg/scripts/ports.cmake)
[DEBUG] clang-16 triplet CMAKE_C_COMPILER = 
[DEBUG] clang-16 triplet CMAKE_CXX_COMPILER = 
[DEBUG] -- Found external ninja('1.11.1').
[DEBUG] -- Configuring x64-linux-clang16-rel
[DEBUG] -- The C compiler identification is Clang 16.0.6
[DEBUG] -- Detecting C compiler ABI info
[DEBUG] -- Detecting C compiler ABI info - done
[DEBUG] -- Check for working C compiler: /usr/bin/clang-16 - skipped
[DEBUG] -- Detecting C compile features
[DEBUG] -- Detecting C compile features - done
[DEBUG] -- The CXX compiler identification is Clang 16.0.6
[DEBUG] -- Detecting CXX compiler ABI info
[DEBUG] -- Detecting CXX compiler ABI info - done
[DEBUG] -- Check for working CXX compiler: /usr/bin/clang++-16 - skipped
[DEBUG] -- Detecting CXX compile features
[DEBUG] -- Detecting CXX compile features - done
[DEBUG] -- Configuring done (25.3s)
[DEBUG] -- Generating done (0.0s)
[DEBUG] -- Build files have been written to: /vcpkg/buildtrees/detect_compiler/x64-linux-clang16-rel
[DEBUG] 
[DEBUG] clang-16 toolchain CMAKE_C_COMPILER = /usr/bin/clang-16
[DEBUG] clang-16 toolchain CMAKE_CXX_COMPILER = /usr/bin/clang++-16
[DEBUG] clang-16 toolchain CMAKE_C_COMPILER = /usr/bin/clang-16
[DEBUG] clang-16 toolchain CMAKE_CXX_COMPILER = /usr/bin/clang++-16
[DEBUG] clang-16 toolchain CMAKE_C_COMPILER = /usr/bin/clang-16
[DEBUG] clang-16 toolchain CMAKE_CXX_COMPILER = /usr/bin/clang++-16
[DEBUG] clang-16 toolchain CMAKE_C_COMPILER = /usr/bin/clang-16
[DEBUG] clang-16 toolchain CMAKE_CXX_COMPILER = /usr/bin/clang++-16
[DEBUG] #COMPILER_HASH#e5492bd0299c2e1e9ff4905da16a45ca183fabb2
[DEBUG] #COMPILER_C_HASH#906c5fb9c9bfe7292ed20d8d513a0f82e41c4d60
[DEBUG] #COMPILER_C_VERSION#16.0.6
[DEBUG] #COMPILER_C_ID#Clang
[DEBUG] #COMPILER_C_PATH#/usr/bin/clang-16
[DEBUG] #COMPILER_CXX_HASH#906c5fb9c9bfe7292ed20d8d513a0f82e41c4d60
[DEBUG] #COMPILER_CXX_VERSION#16.0.6
[DEBUG] #COMPILER_CXX_ID#Clang
[DEBUG] #COMPILER_CXX_PATH#/usr/bin/clang++-16
[DEBUG] CMake Warning:
[DEBUG]   Manually-specified variables were not used by the project:
[DEBUG] 
[DEBUG]     BUILD_SHARED_LIBS
[DEBUG]     CMAKE_INSTALL_BINDIR
[DEBUG]     CMAKE_INSTALL_LIBDIR
[DEBUG]     VCPKG_CRT_LINKAGE
[DEBUG]     VCPKG_CXX_FLAGS
[DEBUG]     VCPKG_CXX_FLAGS_DEBUG
[DEBUG]     VCPKG_CXX_FLAGS_RELEASE
[DEBUG]     VCPKG_C_FLAGS
[DEBUG]     VCPKG_C_FLAGS_DEBUG
[DEBUG]     VCPKG_C_FLAGS_RELEASE
[DEBUG]     VCPKG_LINKER_FLAGS
[DEBUG]     VCPKG_LINKER_FLAGS_DEBUG
[DEBUG]     VCPKG_LINKER_FLAGS_RELEASE
[DEBUG]     VCPKG_PLATFORM_TOOLSET
[DEBUG]     VCPKG_SET_CHARSET_FLAG
[DEBUG]     _VCPKG_ROOT_DIR
[DEBUG] 
[DEBUG] 
[DEBUG] 
[DEBUG] 1012: cmd_execute_and_stream_data() returned 0 after 25342913 us
[DEBUG] Detected compiler hash for triplet x64-linux-clang16: e5492bd0299c2e1e9ff4905da16a45ca183fabb2
Compiler found: /usr/bin/clang++-16
```

## 🔗 References

<https://stackoverflow.com/a/75589274/11799033>

<https://stackoverflow.com/a/73910193/11799033>

<https://learn.microsoft.com/en-us/vcpkg/users/binarycaching-troubleshooting>
