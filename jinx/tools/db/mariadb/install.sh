#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_db.log"

_install_mariadb_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if yes | pkg install mariadb &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_mariadb_install.mariadb_installed")"
		return 0
	else
		return 1
	fi
}

install_mariadb() {
	if command -v mariadbd &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_mariadb_install.mariadb_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_mariadb_install.installing_mariadb")"
	loading "Installing MariaDB" _install_mariadb_impl
}

_uninstall_mariadb_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if pkg uninstall mariadb -y &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_mariadb_install.mariadb_uninstalled")"
		return 0
	else
		log_error "$(_tr "jinx_tools_db_mariadb_install.failed_to_uninstall_mariadb")"
		return 1
	fi
}

uninstall_mariadb() {
	if ! command -v mariadbd &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_mariadb_install.mariadb_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_mariadb_install.uninstalling_mariadb")"
	loading "Uninstalling MariaDB" _uninstall_mariadb_impl
}

_update_mariadb_impl() {
	loading "Updating MariaDB" _do_mariadb_update
}

_do_mariadb_update() {
	mkdir -p "$(dirname "$LOG_FILE")"
	pkg upgrade mariadb -y &>>"$LOG_FILE"
}

update_mariadb() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "MariaDB" "$(_get_installed_pkg_version mariadb "MariaDB")" "$(_get_remote_pkg_version mariadb)" _update_mariadb_impl
}

reinstall_mariadb() {
	uninstall_mariadb
	install_mariadb
}
