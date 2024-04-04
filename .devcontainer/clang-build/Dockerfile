FROM registry.access.redhat.com/ubi8/ubi:8.9-1136

# Provide your own RHEL subscription
ARG RHEL8_ORG
ARG RHEL8_ACTIVATION_KEY

RUN subscription-manager register --org=$RHEL8_ORG --activationkey=$RHEL8_ACTIVATION_KEY

# Install tools
#
# llvm-toolset for clang 16 compiler and tools
# vim-enhanced for color vi support in git
# zip/unzip for vcpkg
#
RUN dnf update -y \
  && dnf -y install \
  git \
  llvm-toolset \
  unzip \
  vim-enhanced \
  zip \
  && dnf clean all \
  && rm -rf /var/cache/yum

# Install cmake
WORKDIR /opt
RUN curl --fail -LO https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0-linux-x86_64.tar.gz \
  && tar -xvf cmake-3.29.0-linux-x86_64.tar.gz \
  && rm cmake-3.29.0-linux-x86_64.tar.gz

# Install ninja
WORKDIR /opt
RUN curl --fail \
  -LO "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip" \
  && mkdir -p /opt/ninja/1.11.1 \
  && unzip ninja-linux.zip -d /opt/ninja/1.11.1 \
  && rm ninja-linux.zip

# Install patchelf
WORKDIR /opt
RUN curl --fail \
  -LO "https://github.com/NixOS/patchelf/releases/download/0.14.5/patchelf-0.14.5-x86_64.tar.gz" \
  && mkdir -p /opt/patchelf/0.14.5 \
  && tar -xvf patchelf-0.14.5-x86_64.tar.gz \
  && rm patchelf-0.14.5-x86_64.tar.gz

# Clone & bootstrap vcpkg
WORKDIR /
RUN git clone https://github.com/microsoft/vcpkg.git \
  && ./vcpkg/bootstrap-vcpkg.sh -disableMetrics

# Install root user .bashrc
COPY .bashrc /root/

ENTRYPOINT [ "bash" ]
