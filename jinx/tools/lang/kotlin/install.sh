#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

install_kotlin() {
	if command -v kotlin &>/dev/null; then
		log_info "Kotlin ya está instalado"
		return 2
	fi

	log_info "Instalando Kotlin..."
	mkdir -p "$(dirname "$LOG_FILE")"

	if ! command -v java &>/dev/null; then
		log_info "Java es necesario para Kotlin. Instalando OpenJDK..."
		import "@/tools/lang/java/install"
		install_java || return 1
	fi

	if ! command -v kotlin &>/dev/null; then
		if ! yes | pkg install kotlin &>>"$LOG_FILE"; then
			log_error "Error al instalar Kotlin"
			return 1
		fi
	fi

	log_success "Kotlin instalado"
	return 0
}

uninstall_kotlin() {
	if ! command -v kotlin &>/dev/null; then
		log_info "Kotlin no está instalado"
		return 2
	fi
	log_info "Desinstalando Kotlin..."
	pkg uninstall kotlin -y &>>"$LOG_FILE"
	log_success "Kotlin desinstalado"
	return 0
}

update_kotlin() {
	_check_update_needed "Kotlin" "$(_get_installed_pkg_version kotlin "Kotlin")" "$(_get_remote_pkg_version kotlin)" _do_update_kotlin
}

_do_update_kotlin() {
	loading "Actualizando Kotlin" bash -c "yes | pkg upgrade kotlin -y &>>$LOG_FILE"
}

reinstall_kotlin() {
	uninstall_kotlin
	install_kotlin
}
