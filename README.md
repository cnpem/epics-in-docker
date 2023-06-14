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
      labels:
        org.opencontainers.image.source: https://github.com/ORGANIZATION/REPOSITORY
      args:
        REPONAME: REPOSITORY
        RUNDIR: /opt/REPOSITORY/iocBoot/YOUR_APP
        ENTRYPOINT: ./YOUR_ENTRYPOINT
```

The template above assumes the containers will be uploaded to the GitHub
registry.

### Possible issues

Known build and runtime issues are documented in the [SwC
wiki](http://swc.lnls.br/).
