# Release Notes

## Unreleased

### Bug fixes

* base: fix external trigger in ADEiger. by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/158
* base: prune broken symbolic links correctly in
  https://github.com/cnpem/epics-in-docker/pull/173
  * Improve the shared library symbolic link removal to prevent the mistaken
    pruning of linked libraries when there are hard-copies of shared objects
    instead of proper symlinks.
* Rectify pyDevSup IOC dependencies by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
  * Refer to the README for updated guidance on pyDevSup IOCs.
* base: update snmp to 1.1.0.6 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
* base: update reccaster to 1.9.5 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
* base: update sscan to R2-12 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Bugfixes in the buffer handling.
* base: update autosave to R6-0 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Changelog available in
    https://github.com/epics-modules/autosave/releases/tag/R6-0
  * NFS functionality of autosave is not relevant to our build, so the breaking
    change doesn't affect us.
* base: update StreamDevice to 2.8.26 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Bugfix in the buffer handling.

### Breaking changes

* images: use static-link target for opcua by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
  * Files sourced from other modules instead of the version installed in the
    IOC will no longer be available. However, we don't expect this usage to have
    been common.
* base: remove NDSSCPimega areaDetector plugin by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/172

### New features

* base: add motorSmarAct module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/132
* base: add Galil module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/162
* base: update to Debian 13 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
  * This update includes a more recent release of procServ, with support for
    the `--oneshot` flag.
* base: update to Alpine 3.23 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
* base: update epics-base to 7.0.10 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
  * Changelog is available in
    https://docs.epics-controls.org/projects/base/en/latest/RELEASE_NOTES.html#epics-release-7-0-10
* base: update opcua to v0.11.2, use open62541 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/165
  * open62541 is a different implementation of an OPCUA client. Behavior should
    remain the same. This also restores OPCUA Security support.
* base: update iocStats to 4.0.1 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Added PVs for PVA environment variables.
  * PVs for CA environment variables have been renamed and the old names are
    deprecated:
    https://github.com/epics-modules/iocStats/blob/4.0.1/iocAdmin/Db/siteEnvVarAliases.template
* base: update `ether_ip` to 3-10 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Changelog documenting new features is available in
    https://github.com/epics-modules/ether_ip/blob/ether_ip-3-10/changes.md
* base: update modbus to R3-4 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * Changelog documenting new features is available in
    https://github.com/epics-modules/modbus/blob/R3-4/RELEASE.md
* base: update asyn to R4-45 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * This release brings support for destructible ports.
* base: update PVXS to 1.5.1 by @ericonr in
  https://github.com/cnpem/epics-in-docker/pull/164
  * We were on version 1.3.0. Changelog is available in
    https://epics-base.github.io/pvxs/releasenotes.html
* base: add xspress3 module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/173
* base: add ip module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/169
* base: add motorSymetrie module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/175

## v0.15.0

This releases adds multiple new IOC images to the project. External images for
the new images listed below should no longer be needed.

We noticed a regression in v0.13.0, it's been documented in breaking changes
for that release.

### Bug fixes

* base: update CaPutLog to R4.2. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/142
  * There are relevant bug fixes in R4.1 and R4.2, improving caPutJsonLog
    support.

### Breaking changes

* images: change in IOC build process. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/133
  * The changes in the internal IOC build process in epics-in-docker affect the
    directory paths and binary locations within the images. The new paths are
    documented in the project README.

### New features

* base: add lakeshore340 module. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/123
* base: new method for IOC build. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/133
  * This approach is experimental and intended for internal use within 
    the epics-in-docker project only. It is not yet considered stable 
    or supported for external use.
* base: add motorNewport module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/146
* base: add rgamv2 module and image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/143
* base: add ADEiger module. by @gustavosr8 in
  https://github.com/cnpem/epics-in-docker/pull/141
* base: add twincat-ads module and image. by @MaikTheWay in
  https://github.com/cnpem/epics-in-docker/pull/127
* base: update motorParker module to version R1-2-1. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/139
* base: update motorPIGCS2 module to version R1-3. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/138
* images: add softIOC image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/145
* base: update pmac module to version 2-7-9 and add pmac image. by
  @guirodrigueslima in https://github.com/cnpem/epics-in-docker/pull/140
  * The image reuses the `ghcr.io/cnpem/pmac-epics-ioc` name, which used to be
    provided by <https://github.com/cnpem/pmac-epics-ioc>, and is a full
    replacement for it.

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

### Breaking changes

* images: remove libssl3 from opcua image. by @guirodrigueslima in
  https://github.com/cnpem/epics-in-docker/pull/133
  * This removes support for OPCUA Security.

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
