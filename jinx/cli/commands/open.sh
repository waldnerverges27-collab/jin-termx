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
		log_info "La documentación está disponible localmente en el repositorio Jin-TermX."
		log_info "Ejecuta ${D_CYAN}jinx <comando> --help${NC} para ayuda específica."
		return
		;;
	esac
}

open_help() {
	echo
	box "Jin Open"
	echo
	log_info "Uso: jinx open"
	echo
	log_info "La documentación está disponible localmente en el repositorio Jin-TermX."
	echo
	list_item "Ejecuta ${D_CYAN}jinx <comando> --help${NC} para ayuda específica"
	list_item "Lee el README: ${D_CYAN}glow README.md${NC} (o ${D_CYAN}bat README.md${NC})"
	echo
}
