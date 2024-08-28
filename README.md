# EPICS in Docker (or other container runtimes)

This project packages the [EPICS
base](https://epics-controls.org/resources-and-support/base/epics-7/) and as
many support modules as possible into a build image that can then be used to
build thin IOC container images.

## Base image

The base image is built in CI and should be obtained directly from the [GitHub
registry](https://github.com/cnpem/epics-in-docker/pkgs/container/lnls-debian-11-epics-7).

The versions used in the base image are defined in `base/.env`.

## Included IOC images

Some IOC images are provided by this repository directly, and can be used
without any build step.

- OPCUA IOC: `ghcr.io/cnpem/opcua-epics-ioc`
- MCA IOC: `ghcr.io/cnpem/mca-epics-ioc`
- Motor PIGCS2 IOC: `ghcr.io/cnpem/motor-pigcs2-epics-ioc`

## IOC images

IOC repositories should include this repository as a submodule in their root,
as such:

```
$ git submodule add -b release https://github.com/cnpem/epics-in-docker.git docker/
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
Packages that strictly need to be installed via `pip` can be listed under the
`RUNTIME_PIP_PACKAGES` key.
Packages essential to all (or most) IOCs should be added to
[this repository's `Dockerfile`](./Dockerfile).

Extra files can also be downloaded and installed by listing their TAR or ZIP
archive URLs under `BUILD_TAR_PACKAGES` or `RUNTIME_TAR_PACKAGES`. To use HTTPS
(or any other TLS-based protocol), `ca-certificates` must also be added to
`RUNTIME_PACKAGES`.

The template above assumes the containers will be uploaded to the GitHub
registry.

`:${TAG}` adds versioning to images using [our CI workflows](#ci-workflows),
and when building images locally and exporting the `TAG` environment variable.
If there is no interest in using versioned images and the resulting container
image should be tagged as `latest`, `:${TAG}` can simply be omitted.

### areaDetector IOCs

`areaDetector` IOCs must be built with target `dynamic-link`. In addition, they
must include `libxml2` and `libtiff5` in the `RUNTIME_PACKAGES`, as they are
not built in `ADSupport`.

### Pmac IOCs

`Pmac` IOCs must include `libssh2-1` in the `RUNTIME PACKAGES`, because the
module depends on it.

### Possible issues

Known build and runtime issues are documented in the [SwC
wiki](http://swc.lnls.br/).

## CI Workflows

Users of this repository for building IOC images can also take advantage of
pre-defined continuous integration workflows in order to verify that images are
built correctly after changes, and for uploading container images to the
desired registry on Git tag creation.

### GitHub Actions

A YAML file must be added to the repository's `.github/workflows/` directory
(e.g. `.github/workflows/build.yml`), with the following contents:

```yaml
name: Build image
on:
  push:
    tags:
      - 'v*'
  pull_request:

jobs:
  build_and_push:
    permissions:
      packages: write
      contents: read
    uses: cnpem/epics-in-docker/.github/workflows/ioc-images.yml@main
```

## Containers

### Accessing `iocsh` inside containers

If a container is using the default `lnls-run` entrypoint (i.e. this won't work
for containers launched by the `iocs` script for SIRIUS beamlines), its IOC's
`iocsh` can be accessed with the following command (use `podman` if
appropriate):

```
$ docker exec -ti <container> nc -U ioc.sock
```

## Alpine base image

This alternative base image can be used to build fully static IOCs for
scenarios where containerized deployment isn't an option or isn't desired for
some reason. It should also be able to cope better than the Debian-based
default image with older kernels.

It can be obtained directly from the [GitHub
registry](https://github.com/cnpem/epics-in-docker/pkgs/container/lnls-alpine-3.18-epics-7).

### Building fully static IOCs

Fully static IOCs can be built using the `lnls-build-static-ioc` script
provided by this image. One way to automate this is using a
`docker-compose.yml` file and running `docker compose up`; the file should have
the following contents:

```yaml
services:
  build-static-ioc:
    image: ghcr.io/cnpem/lnls-alpine-3.18-epics-7:RELEASE
    volumes:
      - type: bind
        source: ./
        target: /opt/REPOSITORY
    working_dir: /opt/REPOSITORY
    command: lnls-build-static-ioc REPOSITORY
```

Where `RELEASE` should be the latest available version in
<https://github.com/cnpem/epics-in-docker/tags>.

This will generate a versioned tarball containing the built IOC. For this
reason, it is recommended to use git repositories with tagged releases.
Furthermore, the `target` and `working_dir` keys are where the IOC expects to
be installed, meaning files like `envPaths` will encode this information. If it
is necessary to install it elsewhere, and building it with different values for
the keys isn't possible, it will be necessary to edit `envPaths`.

For development, one can set the `SKIP_CLEAN` environment variable (under
`environment`), to skip the cleanup build steps and speed up rebuilds.

Further `CONFIG_SITE` options can be added to a
`configure/CONFIG_SITE.local.lnls-build-static-ioc` file, if necessary.
