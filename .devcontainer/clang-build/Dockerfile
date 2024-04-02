FROM registry.access.redhat.com/ubi8/ubi:8.9-1136

# Provide your own RHEL subscription
ARG RHEL8_ORG
ARG RHEL8_ACTIVATION_KEY

RUN subscription-manager register --org=$RHEL8_ORG --activationkey=$RHEL8_ACTIVATION_KEY

# Install root user .bashrc
COPY .bashrc /root/

ENTRYPOINT [ "bash" ]
