# Third-party licenses

This repository contains Docker packaging and configuration for [Praat](https://praat.org/). The repository's own files are licensed under the terms in [LICENSE](LICENSE). **That license does not replace the licenses of software and assets included in the built container image.**

The image includes the following principal third-party components. This list is not an exhaustive software bill of materials (SBOM); additional packages and dependencies retain their respective licenses.

## Praat

- **Project:** Praat — doing phonetics by computer
- **Version:** 7.0.02
- **Authors:** Paul Boersma and David Weenink, with additional contributors and third-party components acknowledged upstream
- **License of Praat as a whole:** GNU General Public License v3.0 or later (`GPL-3.0-or-later`)
- **Homepage:** https://praat.org/
- **License information:** https://praat.org/manual/License.html
- **Acknowledgments and included software:** https://praat.org/manual/Acknowledgments.html
- **Corresponding upstream source (version tag):** https://github.com/praat/praat.github.io/tree/v7.0.02
- **Upstream release:** https://github.com/praat/praat.github.io/releases/tag/v7.0.02
- **GPL v3 license text:** https://www.gnu.org/licenses/gpl-3.0.html

The Dockerfile downloads Praat's upstream Linux executable and installs it without modifying the Praat program. **Redistribution of the built container image redistributes Praat under its GPL license.** Recipients must be able to obtain the corresponding source code in accordance with the GPL; distributors should provide clear source-access instructions alongside the image and ensure that the source remains available for the required period. See [GPLv3, section 6](https://www.gnu.org/licenses/gpl-3.0.html#section6).

The Dockerfile also obtains an application icon from Praat's upstream repository (`main/praat-128.png`). The icon is an upstream asset, **not** covered by this repository's MIT license; consult the upstream copyright and asset-specific licensing information.

## jlesage/baseimage-gui

- **Project:** jlesage/baseimage-gui
- **Image used:** `jlesage/baseimage-gui:ubuntu-26.04-v4.14`
- **Copyright:** © Jocelyn Le Sage and contributors, as specified upstream
- **License for the baseimage project's own code:** MIT
- **Source:** https://github.com/jlesage/docker-baseimage-gui
- **Upstream release:** https://github.com/jlesage/docker-baseimage-gui/releases/tag/v4.14.0
- **License text:** https://github.com/jlesage/docker-baseimage-gui/blob/v4.14.0/LICENSE

The base image provides the graphical environment, initialization and process management, web interface, and other services. **Its MIT license does not imply that every bundled program is MIT-licensed.** Included programs such as noVNC, TigerVNC, Openbox, NGINX, and other dependencies retain their own licenses and notices.

## SIL fonts

The Dockerfile installs these fonts from Ubuntu packages:

| Ubuntu package | Font | Copyright holder | License |
| --- | --- | --- | --- |
| `fonts-sil-charis` | Charis (formerly Charis SIL) | SIL International | SIL Open Font License 1.1 (`OFL-1.1`) |
| `fonts-sil-doulos` | Doulos SIL | SIL International | SIL Open Font License 1.1 (`OFL-1.1`) |

- **Charis:** https://software.sil.org/charis/
- **Doulos SIL:** https://software.sil.org/doulos/
- **OFL license:** https://openfontlicense.org/

The precise font versions depend on the Ubuntu packages installed during the image build. Their applicable copyright notices and license files should be preserved with the distributed fonts.

## Ubuntu packages and other dependencies

The image also includes Ubuntu 26.04 system packages, libraries, fonts, and components inherited from the base image. The Dockerfile explicitly requests packages such as `ca-certificates`, `dbus-x11`, GTK, ALSA, PulseAudio, and JACK libraries. These packages are **not uniformly MIT-licensed**; their individual license conditions apply.

On Ubuntu/Debian-based images, package copyright and licensing details are commonly available in `/usr/share/doc/<package>/copyright`. The complete set of installed packages can be inspected using `dpkg-query -W` within the built image.

## Redistribution and notices

When publishing or redistributing the built container image:

1. Preserve copyright notices, license texts, and any other notices required by the included software and fonts.
2. Provide equivalent access to the corresponding source code for GPL-covered binaries, where required by the GPL, and maintain clear instructions for obtaining it.
3. Retain applicable third-party license information when rebuilding, modifying, or redistributing the image.
4. Recheck these notices when upgrading Praat, the base image, or installed packages.

**This document is a summary, not a substitute for the full license texts or a comprehensive SBOM.** Each component remains subject to its own license terms.
