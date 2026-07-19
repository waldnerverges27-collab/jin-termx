#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_db.log"

_install_postgresql_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if yes | pkg install postgresql &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_postgresql_install.postgresql_installed")"
		return 0
	else
		return 1
	fi
}

install_postgresql() {
	if command -v postgres &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_postgresql_install.postgresql_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_postgresql_install.installing_postgresql")"
	loading "Installing PostgreSQL" _install_postgresql_impl
}

_uninstall_postgresql_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if pkg uninstall postgresql -y &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_postgresql_install.postgresql_uninstalled")"
		return 0
	else
		log_error "$(_tr "jinx_tools_db_postgresql_install.failed_to_uninstall_postgresql")"
		return 1
	fi
}

uninstall_postgresql() {
	if ! command -v postgres &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_postgresql_install.postgresql_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_postgresql_install.uninstalling_postgresql")"
	loading "Uninstalling PostgreSQL" _uninstall_postgresql_impl
}

_update_postgresql_impl() {
	loading "Updating PostgreSQL" _do_postgresql_update
}

_do_postgresql_update() {
	mkdir -p "$(dirname "$LOG_FILE")"
	pkg upgrade postgresql -y &>>"$LOG_FILE"
}

update_postgresql() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "PostgreSQL" "$(_get_installed_pkg_version postgresql "PostgreSQL")" "$(_get_remote_pkg_version postgresql)" _update_postgresql_impl
}

reinstall_postgresql() {
	uninstall_postgresql
	install_postgresql
}
