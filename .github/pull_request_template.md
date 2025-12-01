<!--
Uncomment relevant sections and delete options which are not applicable
Please, follow the `CONTRIBUTING.md` Guidelines before submitting your contribution.
-->

<!--
# Description

Include a summary of the changes, with its context and relevant motivations.
<--

# Checklist

- [ ] Follow the commit format specified in `CONTRIBUTING.md`;
- [ ] Describe your user-facing changes in `CHANGES.md`, following the format
established by previous entries.

## If adding a new IOC image

- [ ] Create a compose file for the new IOC under the `images` directory;
- [ ] List the new compose file in `.github/workflows/base-image.yml` under the
`files` key in the `Build and push included IOC images` step;
- [ ] Add an entry in `README.md`, under `Included IOC images`, with the IOC
name and its fully qualified container image name.
