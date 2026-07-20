#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

install_java() {
	if command -v java &>/dev/null; then
		log_info "Java ya está instalado"
		return 2
	fi

	log_info "Instalando Java (OpenJDK)..."
	mkdir -p "$(dirname "$LOG_FILE")"

	if ! yes | pkg install openjdk-17 &>>"$LOG_FILE"; then
		log_error "Error al instalar Java"
		return 1
	fi

	log_success "Java instalado"
	return 0
}

uninstall_java() {
	if ! command -v java &>/dev/null; then
		log_info "Java no está instalado"
		return 2
	fi
	log_info "Desinstalando Java..."
	pkg uninstall openjdk-17 -y &>>"$LOG_FILE"
	log_success "Java desinstalado"
	return 0
}

update_java() {
	_check_update_needed "Java" "$(_get_installed_pkg_version openjdk-17 "Java")" "$(_get_remote_pkg_version openjdk-17)" _do_update_java
}

_do_update_java() {
	loading "Actualizando Java" bash -c "yes | pkg upgrade openjdk-17 -y &>>$LOG_FILE"
}

reinstall_java() {
	uninstall_java
	install_java
}
