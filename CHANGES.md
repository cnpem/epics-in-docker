# Release Notes

## Unreleased

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