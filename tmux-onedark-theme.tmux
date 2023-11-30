#!/bin/bash

getHexFromLine() {
	trimmedLine="$(echo -e "$1" | tr -d '[:space:]')"
	HEX=$(echo "$trimmedLine" | awk -F ':' '{print $2}')
}

# $1 should be the xresources line
# $2 should be the tmux color to set
setColorFromHex() {
	getHexFromLine "$line"
	prefix="tmux_"
	command="$prefix$2=$HEX"
	export "${command?}"
}

Xresources=~/.Xresources.colors

while read -r line; do
	#skip empty lines
	[ -z "$line" ] && continue
	case $line in

	*color15*)
		setColorFromHex "$line" light_white
		;;
	*color14*)
		setColorFromHex "$line" light_cyan
		;;
	*color13*)
		setColorFromHex "$line" light_magenta
		;;
	*color12*)
		setColorFromHex "$line" light_blue
		;;
	*color11*)
		setColorFromHex "$line" light_yellow
		;;
	*color10*)
		setColorFromHex "$line" light_green
		;;
	*color9*)
		setColorFromHex "$line" light_red
		;;
	*color8*)
		setColorFromHex "$line" light_black
		;;
	*color7*)
		setColorFromHex "$line" white
		;;
	*color6*)
		setColorFromHex "$line" cyan
		;;
	*color5*)
		setColorFromHex "$line" magenta
		;;
	*color4*)
		setColorFromHex "$line" blue
		;;
	*color3*)
		setColorFromHex "$line" yellow
		;;
	*color2*)
		setColorFromHex "$line" green
		;;
	*color1*)
		setColorFromHex "$line" red
		;;
	*color0*)
		setColorFromHex "$line" black
		;;
	*foreground*)
		setColorFromHex "$line" foreground
		;;
	*background*)
		setColorFromHex "$line" background
		;;
	esac
done <$Xresources

onedark_black=${tmux_black:-"#282c34"}
onedark_blue=${tmux_blue:-"#57a5e5"}
onedark_yellow=${tmux_yellow:-"#dbb671"}
onedark_red=${tmux_red:-"#de5d68"}
onedark_white=${tmux_white:-"#a7aab0"}
onedark_green=${tmux_green:-"#8fb573"}
onedark_visual_grey=${tmux_light_black:-"#3e4452"}
onedark_comment_grey="#5c6370"

onedark_foreground=${tmux_foreground:-$onedark_white}
onedark_background=${tmux_background:-$onedark_black}

get() {
	local option=$1
	local default_value=$2
	local option_value="$(tmux show-option -gqv "$option")"

	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

setw() {
	local option=$1
	local value=$2
	tmux set-window-option -gq "$option" "$value"
}

set "status" "on"
set "status-justify" "left"

set "status-left-length" "100"
set "status-right-length" "100"
set "status-right-attr" "none"

set "message-style" fg="$onedark_foreground"
set "message-style" bg="$onedark_background"

set "status-bg" "$onedark_background"
set "status-fg" "$onedark_foreground"

set "@prefix_highlight_fg" "$onedark_background"
set "@prefix_highlight_bg" "$onedark_green"
set "@prefix_highlight_copy_mode_attr" "fg=$onedark_background,bg=$onedark_green"
set "@prefix_highlight_output_prefix" "  "

status_widgets=$(get "@onedark_widgets")
time_format=$(get "@onedark_time_format" "%R")
date_format=$(get "@onedark_date_format" "%d/%m/%Y")

set "status-right" "#[fg=$onedark_foreground,bg=$onedark_background,nounderscore,noitalics]#($TMUX_PLUGIN_MANAGER_PATH/tmux-mem-cpu-load/tmux-mem-cpu-load --interval 2)  #[fg=$onedark_foreground,bg=$onedark_background,nounderscore,noitalics]${time_format}  ${date_format}  ${status_widgets}#[fg=$onedark_visual_grey,bg=$onedark_background]#[fg=$onedark_visual_grey,bg=$onedark_visual_grey]#[fg=$onedark_white, bg=$onedark_visual_grey] #[fg=$onedark_green,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_background,bg=$onedark_green,bold] #h #[fg=$onedark_yellow, bg=$onedark_green]#[fg=$onedark_red,bg=$onedark_yellow]"

set "status-left" "#[fg=$onedark_background,bg=$onedark_green,bold] #S #{prefix_highlight}#[fg=$onedark_green,bg=$onedark_background,nobold,nounderscore,noitalics]"

set "window-status-format" "#[fg=$onedark_background,bg=$onedark_visual_grey,nobold,nounderscore,noitalics]#[fg=$onedark_background,bg=$onedark_visual_grey] #I  #W #[fg=$onedark_visual_grey,bg=$onedark_background,nobold,nounderscore,noitalics]"
set "window-status-current-format" "#[fg=$onedark_background,bg=$onedark_green,nobold,nounderscore,noitalics]#[fg=$onedark_background,bg=$onedark_green] #I  #W #[fg=$onedark_green,bg=$onedark_background,nobold,nounderscore,noitalics]"
