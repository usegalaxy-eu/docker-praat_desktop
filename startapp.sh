#!/bin/sh
set -eu

# Use the configured workspace directory, defaulting to /config.
PRAAT_WORKDIR="${PRAAT_WORKDIR:-$HOME}"

# Create input and output directories inside the workspace.
mkdir -p "$PRAAT_WORKDIR/inputs" "$PRAAT_WORKDIR/outputs"
cd "$PRAAT_WORKDIR"

# Use the workspace as Praat's home directory.
# The base image has already initialized its configuration under /config.
export HOME="$PRAAT_WORKDIR"

set -- # Start with an empty argument list
for input in "$PRAAT_WORKDIR"/inputs/*; do  # Iterate over directory entries
    [ -f "$input" ] || continue    # Skip anything that isn't a regular file
    set -- "$@" "$input"           # Append the filename as one argument
done

# If at least one input file was found, start Praat and open all collected files.
# "$#" is the number of positional arguments (i.e., input files).
if [ "$#" -gt 0 ]; then
	# Replace the startup shell with Praat so the container's cinit supervisor
	# can directly monitor the application process and manage its shutdown.
	# --new-open starts a new Praat instance and opens the supplied files
    # "$@" passes each filename as a separate argument, preserving spaces
    exec /usr/local/bin/praat --new-open "$@"
fi

# Start Praat normally when no input files are supplied.
exec /usr/local/bin/praat
