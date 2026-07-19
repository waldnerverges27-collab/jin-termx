#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

open_main() {
	if [[ $# -eq 0 ]]; then
		open_help
		return
	fi

	local target="$1"

	case "$target" in
	--help | -h)
		open_help
		return
		;;
	*)
		log_info "$(_tr "cmd_open.info")"
		log_info "$(_tr "cmd_open.help_hint")"
		return
		;;
	esac
}

open_help() {
	echo
	box "$(_tr "cmd_open.help_title")"
	echo
	log_info "$(_tr "cmd_open.usage")"
	echo
	log_info "$(_tr "cmd_open.info")"
	echo
	list_item "$(_tr "cmd_open.help_hint")"
	list_item "$(_tr "cmd_open.read_hint")"
	echo
}
