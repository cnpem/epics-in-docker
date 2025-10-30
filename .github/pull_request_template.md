# Description

Include a summary of the changes, with its context and relevant motivations.

# Checklist:

- [ ] Ensure each commit is atomic and follows the pattern `<scope>:
<description>.`
- [ ] Describe your changes (preferably with the commit title) in `CHANGES.md`.
If adding a new IOC image:
   - [ ] Add compose file to generate the image under `images` directory;
   - [ ] Refeer this compose file in `.github/workflows/base-image.yml`, in the
   `Build and push included IOC images` step, under `files`;
   - [ ] Add entry in `README.md`, under `Included IOC images`, with the IOC
   name and the registry link.
