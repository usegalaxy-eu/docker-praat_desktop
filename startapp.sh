#!/bin/sh
set -eu

# Galaxy sets HOME to its mounted job directory. Standalone runs use /config.
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
