#!/bin/sh
set -eu

# baseimage-gui sets HOME=/config during initialization.
# The Galaxy Interactive Tool wrapper must place inputs in
# /config/inputs and collect outputs from /config/outputs.
mkdir -p "$HOME/inputs" "$HOME/outputs"
cd "$HOME/outputs"

# Use positional arguments so filenames containing spaces stay intact.
# --new-open launches the GUI and reads data/script files into that instance.
set --
for input in "$HOME"/inputs/*; do
    [ -f "$input" ] || continue
    set -- "$@" "$input"
done

if [ "$#" -gt 0 ]; then
    exec /usr/local/bin/praat --new-open "$@"
fi
exec /usr/local/bin/praat
