#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_db.log"

_install_sqlite_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if yes | pkg install sqlite &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_sqlite_install.sqlite_installed")"
		return 0
	else
		return 1
	fi
}

install_sqlite() {
	if command -v sqlite3 &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_sqlite_install.sqlite_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_sqlite_install.installing_sqlite")"
	loading "Installing SQLite" _install_sqlite_impl
}

_uninstall_sqlite_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if pkg uninstall sqlite -y &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_sqlite_install.sqlite_uninstalled")"
		return 0
	else
		log_error "$(_tr "jinx_tools_db_sqlite_install.failed_to_uninstall_sqlite")"
		return 1
	fi
}

uninstall_sqlite() {
	if ! command -v sqlite3 &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_sqlite_install.sqlite_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_sqlite_install.uninstalling_sqlite")"
	loading "Uninstalling SQLite" _uninstall_sqlite_impl
}

_update_sqlite_impl() {
	loading "Updating SQLite" _do_sqlite_update
}

_do_sqlite_update() {
	mkdir -p "$(dirname "$LOG_FILE")"
	pkg upgrade sqlite -y &>>"$LOG_FILE"
}

update_sqlite() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "SQLite" "$(_get_installed_pkg_version sqlite "SQLite")" "$(_get_remote_pkg_version sqlite)" _update_sqlite_impl
}

reinstall_sqlite() {
	uninstall_sqlite
	install_sqlite
}
