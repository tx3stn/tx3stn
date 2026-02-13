#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./fix-card-transparency.sh
#   ./fix-card-transparency.sh pkb vrsn pair plex2pl
#
# Expects input files named <name>.png in the current directory.
# Writes output files as <name>-fixed.png.
# Applies a rounded alpha mask to enforce transparent corners.
# Optional env var:
#   RADIUS=30

if ! command -v magick >/dev/null 2>&1; then
  echo "error: ImageMagick 'magick' command not found in PATH" >&2
  exit 1
fi

radius="${RADIUS:-30}"

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

  w="$(magick identify -format "%w" "$in")"
  h="$(magick identify -format "%h" "$in")"

  magick "$in" \
    \( -size "${w}x${h}" xc:none -fill white -draw "roundrectangle 0,0,$((w-1)),$((h-1)),${radius},${radius}" \) \
    -alpha off \
    -compose CopyOpacity \
    -composite \
    "$out"

  echo "wrote: $out"
done
