# Release Notes

## Unreleased

### New features

* base: add lakeshore340 module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/123
* ioc: copy locally installed software from build stages. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/55
  * This allows the IOC build phase to install custom software, available at
    runtime, under `/usr/local` tree for all targets.

## v0.14.1

### Bug fixes

* base: fix bug in lakeshore module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/120
* base: update motorParker module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/120

## v0.14.0

Users interested in `lakeshore` module from ISIS or `motorParker` module should
update to this release. Motor Parker IOC image is also available.

Users of areaDetector should consider upgrading to this release to benefit from
bug fixes, improvements and new features from ADCore and drivers released in
R3-13 and R3-14, paying attention to breaking changes. See the corresponding
release notes for details.

### Breaking changes

* base: update areaDetector to R3-14. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/53
  * The PV interface for clipping in NDPluginProcess was changed, as documented
    in the [ADCore Release
    Notes](https://github.com/areaDetector/ADCore/blob/d27d71fb73bd915bdd714c8c4c78c05e3f31b1ce/RELEASE.md#ndpluginprocess).

### New features

* base: add lakeshore module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/117
* images: add Parker image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/116
* base: add motorParker. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/116
* base: update areaDetector to R3-14. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/53

## v0.13.0

Users of the `dynamic-link` target for IOC images should update in order to
take advantage of the new image pruning steps, which should greatly lower the
size of those IOC images.

Users interested in improvements added in EPICS 7.0.8 should also update.

This release includes 3 new images: one with epics-base and PVXS tools, and one
for each EPICS gateway.

### New features

* base: update to EPICS 7.0.8.1 and OPCUA 0.10.0. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/85
* images: add PVAGW image. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/90
* ioc: run available IOC tests when building them. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/89
  * Failing tests should ideally be fixed. If that isn't possible --- no
    control over upstream, or tests require hardware access --- they can be
    disabled by setting the environment variable `SKIP_TESTS` to  `1`.
* base: update to Debian 12. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/84
  * Refer to up to date README for new/updated `RUNTIME_PACKAGES`.
* Prune unused artifacts from non-static builds by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/59
  * Pruning will happen automatically, and most cases shouldn't require any
    configuration. Refer to the README for instructions on how to configure the
    procedure when needed.
* ioc: allow compose files to override PATH. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/100
* images: add epics-base image. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/100
* Add CA Gateway image. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/101

## v0.12.0

### New features

* base: add modbus module. by @Nicolas-Moliterno in
  https://github.com/cnpem/epics-in-docker/pull/81

## v0.11.0

### Breaking changes

* base: only use major version for Alpine image names. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/77.
  * Users of the Alpine image must update their workflows to use
    `ghcr.io/cnpem/lnls-alpine-3-epics-7`.

### New features

* base: add bitshuffle support for areaDetector. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/78

* base: support building fully static IOCs when not using containers. by
  @ericonr in https://github.com/cnpem/epics-in-docker/pull/75.

## v0.10.1

This bug fix release is relevant to ipmiComm users.

### Bug fixes

* base: patch ipmiComm to handle `CODE_DESTINATION_UNAVAIL`. by
  @gustavosr8 in https://github.com/cnpem/epics-in-docker/pull/76.

## v0.10.0

Users of `ipmiComm` should update to this release, since it makes the module
much more useful. Anyone distributing or using images in hosts which aren't
properly configured with subuid and subgid should update as well, to improve
the experience of using the images.

### Bug fixes

* ioc: disable APT sandbox. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/69
  * This allows to use APT in containers deployed in systems without subuid and
    subgid.

### New features

* base: update ipmiComm patch to install general templates. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/73.

## v0.9.0

Users willing to use `iocStats`, `ipmiComm`, `pyDevSup`, `SNMP`, `motorPIGCS2`,
`mca`, or `scaler` modules should update to this release. Users of `pmac`
module should also update to have critical bugs fixed. Anyone who had trouble
with versions greater than or equal to v0.7.0 building IOCs depending on Calc
due to Sequencer linkage issues should find it easier to build with this
release. Two new IOC images are also available: MCA and Motor PIGCS2.

### Breaking changes

* base: remove CALC dependency on Sequencer. by @henriquesimoes in
  https://github.com/cnpem/epics-in-docker/pull/68.

### Bug fixes

* base: update PMAC version. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/64

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
* base: add motorPIGCS2 IOC and module, and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/64
* base: add Scaler module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/64
* base: add MCA IOC and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/64

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
