#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./fix-card-transparency.sh
#   ./fix-card-transparency.sh pkb vrsn pair plex2pl
#
# Expects input files named <name>.png in the current directory.
# Writes output files as <name>-fixed.png.

if ! command -v magick >/dev/null 2>&1; then
  echo "error: ImageMagick 'magick' command not found in PATH" >&2
  exit 1
fi

if [[ $# -gt 0 ]]; then
  files=("$@")
else
  files=("pkb" "vrsn" "pair" "plex2pl")
fi

for f in "${files[@]}"; do
  in="${f}.png"
  out="${f}-fixed.png"

  if [[ ! -f "$in" ]]; then
    echo "skip: $in not found"
    continue
  fi

  magick "$in" \
    -alpha set \
    -fuzz 14% \
    -fill none \
    -draw "color 0,0 floodfill" \
    -draw "color %[fx:w-1],0 floodfill" \
    -draw "color 0,%[fx:h-1] floodfill" \
    -draw "color %[fx:w-1],%[fx:h-1] floodfill" \
    -background "#0e1216" \
    -alpha background \
    "$out"

  echo "wrote: $out"
done

