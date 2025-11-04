# EPICS in Docker (or other container runtimes)

This project packages the [EPICS
base](https://epics-controls.org/resources-and-support/base/epics-7/) and as
many support modules as possible into a build image that can then be used to
build thin IOC container images.

## Base image

The base image is built in CI and should be obtained directly from the [GitHub
registry](https://github.com/cnpem/epics-in-docker/pkgs/container/lnls-debian-epics-7).

The versions used in the base image are defined in `base/*_versions.sh` files.

## Included IOC images

Some IOC images are provided by this repository directly, and can be used
without any build step.

- OPCUA IOC: `ghcr.io/cnpem/opcua-epics-ioc`
- MCA IOC: `ghcr.io/cnpem/mca-epics-ioc`
- Motor PIGCS2 IOC: `ghcr.io/cnpem/motor-pigcs2-epics-ioc`
- Motor Parker IOC: `ghcr.io/cnpem/motor-parker-epics-ioc`

## Included tool images

Some images with EPICS tools are provided by this repository as well.

- EPICS Base and PVXS tools: `ghcr.io/cnpem/epics-base` (for this image, usage
  of the `latest` tag, instead of a specific tag, is encouraged)
- PVAccess Gateway: `ghcr.io/cnpem/epics-pvagw`

## IOC images

IOC repositories should include this repository as a submodule in their root,
as such: