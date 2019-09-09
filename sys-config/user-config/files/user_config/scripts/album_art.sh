
#!/bin/bash
# Southern Tools
#
#set -x

music_dir=~/Music/music
cover=/tmp/cover.jpg

function reset_background
{
	printf "\e]20;;100x100+1000+1000\a"
}

{
	album="$(mpc --format %album% current)"
	file="$(mpc --format %file% current)"
	album_dir="${file%/*}"
	[[ -z "$album_dir" ]] && exit 1
	album_dir="$music_dir/$album_dir"

	covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
	src="$(echo -n "$covers" | head -n1)"
	rm -f "$cover"
	if [[ -n "$src" ]]; then
	#resize the image's width to 300px
	convert "$src" -resize 600x "$cover"
	if [[ -f "$cover" ]]; then
		#scale down the cover to 30% of the original
		printf "\e]20;${cover};30x30+1+93:op=keep-aspect\a"
	else
		reset_background
	fi

	else
	reset_background
	fi
} &
