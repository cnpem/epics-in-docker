# EPICS in Docker (or other container runtimes)

This project packages the [EPICS
base](https://epics-controls.org/resources-and-support/base/epics-7/) and as
many support modules as possible into a build image that can then be used to
build thin IOC container images.

## Base image

The base image is built in CI and should be obtained directly from the [GitHub
registry](https://github.com/cnpem/epics-in-docker/pkgs/container/lnls-debian-11-epics-7).

The versions used in the base image are defined in `base/.env`.

## IOC images

IOC repositories should include this repository as a submodule in their root,
as such:

```
$ git submodule add https://github.com/cnpem/epics-in-docker.git docker/
```

The build parameters should be defined in a `docker-compose.yml` file with the
following fields:

```yaml
services:
  ioc:
    image: ghcr.io/ORGANIZATION/REPOSITORY
    build:
      context: ./
      dockerfile: docker/Dockerfile
      target: static-link
      labels:
        org.opencontainers.image.source: https://github.com/ORGANIZATION/REPOSITORY
      args:
        REPONAME: REPOSITORY
        RUNDIR: /opt/REPOSITORY/iocBoot/YOUR_APP
        ENTRYPOINT: ./YOUR_ENTRYPOINT
```

By default, the IOC will be built with statically linked EPICS libraries. If
you **need** to link them dynamically, you must define the build target as
`dynamic-link`. This will increase the resulting image size, since unused
dependencies will also be copied.

The resulting image contains a standard IOC run script, `lnls-run`, which will
be run inside `RUNDIR` and will launch the container's command under procServ,
or `st.cmd` if no command is specified.

Some Docker versions don't use
[BuildKit](https://docs.docker.com/build/buildkit/) by default, and it can be
more efficient to enable it, for instance, by exporting `DOCKER_BUILDKIT=1`
when building the IOC image, because the classic builder goes through all
stages even when they are not needed.

Additional build and runtime packages to be installed can be listed in `args`,
under the `BUILD_PACKAGES` and `RUNTIME_PACKAGES` keys, respectively. It is not
necessary to quote them - e.g. `BUILD_PACKAGES: python3 python3-requests`.
Packages essential to all (or most) IOCs should be added to [this repository's
`Dockerfile`](./Dockerfile).

The template above assumes the containers will be uploaded to the GitHub
registry.

### areaDetector IOCs

`areaDetector` IOCs must be built with target `dynamic-link`. In addition, they
must include `libxml2` and `libtiff5` in the `RUNTIME_PACKAGES`, as they are
not built in `ADSupport`.

### Possible issues

Known build and runtime issues are documented in the [SwC
wiki](http://swc.lnls.br/).

## Containers

### Accessing `iocsh` inside containers

If a container is using the default `lnls-run` entrypoint (i.e. this won't work
for containers launched by the `iocs` script for SIRIUS beamlines), its IOC's
`iocsh` can be accessed with the following command (use `podman` if
appropriate):

```
$ docker exec -ti <container> nc -U ioc.sock
```
