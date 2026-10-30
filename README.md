# Docker image for Praat-desktop

Praat: doing phonetics by computer
https://www.fon.hum.uva.nl/praat/

## Build

```bash
docker build -t praat-headless:7.0.02 .
```
The default base is [`jlesage/baseimage-gui:ubuntu-26.04-v4.14`](https://hub.docker.com/layers/jlesage/baseimage-gui/ubuntu-26.04-v4.14/images/sha256-3a1c3e47aea7e61acb25cf29b74b1c37d5dbdf34b7828f12e2d01b14e2044680)
The base manages the virtual display, Openbox, web interface, process lifecycle,
and audio services.

Install packages with the base image's `add-pkg` helper. It initializes the
user/group files required during package installation and cleans up afterward.
Using `apt-get` directly can fail in `fontconfig-config` with
`chown: invalid user: 'root:staff'`, followed by GTK/Pango dependency errors.

The amd64 binary requires an x86-64-v3 CPU.

## Run outside Galaxy

```bash
mkdir -p config/inputs config/outputs
# Optional: copy audio files and TextGrids into config/inputs before starting.
docker run --rm \
  -e WEB_AUDIO=1 \
  -e USER_ID="$(id -u)" \
  -e GROUP_ID="$(id -g)" \
  -p 127.0.0.1:5800:5800 \
  -v "$PWD/config:/config" \
  praat-headless:7.0.02
```

Open http://localhost:5800

Files in config/inputs are opened automatically with `praat --new-open`.
Script files are opened in an editor, not automatically executed.
The initial working directory is config/outputs. Save wanted results there.
Choose Quit in Praat to end the application and container. Closing a browser
tab does not end the application.

## Audio

`WEB_AUDIO=1` enables the base image's PulseAudio-to-browser streaming feature.
In the browser, enable/unmute audio if prompted. In Praat, choose PulseAudio
under Sound playing preferences if necessary. Browser microphone recording is not
configured. Playback has not yet been verified with this image.

## Galaxy integration

Galaxy can run arbitrary Virtual Research Environments (VREs). In Galaxy terms, 
such VRE's are called "Interactive Tools", as they are using the same subsystem then 
normal Galaxy tools. The only requirement is that those tools needs to run in containers 
and expose a port(s) to which Galaxy can redirect users. The Docker image for Praat you 
can find in this repository. The Galaxy tool defintion for the Praat Interactive are still
under development ([PR](https://github.com/usegalaxy-eu/galaxy/pull/419))