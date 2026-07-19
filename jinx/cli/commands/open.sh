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
		log_info "Documentation is available locally in the Jin-TermX repository."
		log_info "Run ${D_CYAN}jinx <command> --help${NC} for command-specific help."
		return
		;;
	esac
}

open_help() {
	echo
	box "Jin Open"
	echo
	log_info "Usage: jinx open"
	echo
	log_info "Documentation is available locally in the Jin-TermX repository."
	echo
	list_item "Run ${D_CYAN}jinx <command> --help${NC} for command-specific help"
	list_item "Read the README: ${D_CYAN}glow README.md${NC} (or ${D_CYAN}bat README.md${NC})"
	echo
}
