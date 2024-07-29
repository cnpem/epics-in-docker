# Release Notes

## Unreleased

### Breaking changes

* base: remove CALC dependency on Sequencer. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/68.

### New features

* base: add IOCStats module. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/62
* base: add IPMIComm module. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/62
* base: add pyDevSup module. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/62
* base: teach lnls-get-n-unpack about ZIP files. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/67
  * This allows to use ZIP files in `RUNTIME_TAR_PACKAGES` and
    `BUILD_TAR_PACKAGES`.
* base: add SNMP module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/67

## v0.8.1

OPCUA container image build with GitHub Actions has been fixed.

## v0.8.0

A new container image, `ghcr.io/cnpem/opcua-epics-ioc`, is now available.

### New features

* base: add OPCUA and `ether_ip` IOCs and modules. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/57
* images: add OPCUA image. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/61

## v0.7.0

Users of the `autosave` and `caPutLog` modules should update to this release,
which includes critical bug fixes for both. Users of the `calc` module only
need to update if they noticed missing features.

### New features

* base: add PVXS module. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/42
* ci: add reusable job for IOC images. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/49

### Bug fixes

* base: update modules. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/43
  * This updates the autosave module and removes some resource leaks.
* base: build CALC with Sequencer support. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/48
* base: add caPutLog patch for waveforms. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/58

## v0.6.0

Users interested in the retools module should update to this release.

### New features

* base: add retools module. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/37

## v0.5.0

Users willing to use Pmac or NDSSCPimega should update to this release. A
musl-based image has been added, enabling support for linking fully static
binaries for deployment outside of containers.

### New features

* base: add support for Pmac module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/26
* base: add NDSSCPimega areaDetector plugin. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/31
  * This copies libraries built from source in the build image to the runtime
    image for all targets. This removes the need to use `RUNTIME_TAR_PACKAGES`
    for local libraries required during a module build.
* base: add musl build. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/35

## v0.4.0

All users should update to ease deployment on container setups with limited
user ranges. Users interested in using the `lnls-run` script or the `caPutLog`
module should update as well.

### Breaking changes

* ioc: add script to launch IOCs inside container. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/25
  * This changed the standard `ENTRYPOINT` to the new launcher script. It
    allows users to launch IOC startup scripts under procServ without writing
    any scripts.

### Bug fixes

* ioc: use non-interactive install for build-stage. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/22
* Install tarball packages with custom extraction by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/21

### New features

* ioc: add stage without IOC building. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/20
  * This makes it possible to use IOCs built inside modules.
* Added motor and ipac modules by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/11
* base: extract install functions to shared file. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/27
* base: add caPutLog module. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/29
