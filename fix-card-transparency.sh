#!/usr/bin/env bash
set -euo pipefail

if ! command -v magick >/dev/null 2>&1; then
	echo "error: ImageMagick 'magick' command not found in PATH" >&2
	exit 1
fi

radius="${RADIUS:-30}"
inset="${INSET:-0}"

files=("pkb" "vrsn" "pair" "plex2pl")

for f in "${files[@]}"; do
	in="${f}.png"
	out="${f}-fixed.png"

	if [[ ! -f "$in" ]]; then
		echo "skip: $in not found"
		continue
	fi

	w="$(magick identify -format "%w" "$in")"
	h="$(magick identify -format "%h" "$in")"
	xmid="$((w / 2))"
	matte_color="${MATTE_COLOR:-$(magick "$in" -format "%[pixel:p{${xmid},1}]" info:)}"

	magick "$in" \
		\( -size "${w}x${h}" xc:none -fill white -draw "roundrectangle ${inset},${inset},$((w - 1 - inset)),$((h - 1 - inset)),${radius},${radius}" \) \
		-compose DstIn \
		-composite \
		-background "$matte_color" \
		-alpha background \
		"$out"

	echo "wrote: $out"
done
