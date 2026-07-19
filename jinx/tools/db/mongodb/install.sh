#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_db.log"

_install_mongodb_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"

	if [[ ! -f $PREFIX/etc/apt/sources.list.d/tur.list ]]; then
		if ! yes | pkg install tur-repo &>>"$LOG_FILE"; then
			log_error "$(_tr "jinx_tools_db_mongodb_install.failed_to_install_tur_repo")"
			return 1
		fi
	fi

	if yes | pkg install mongodb &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_mongodb_install.mongodb_installed")"
		return 0
	else
		return 1
	fi
}

install_mongodb() {
	if command -v mongod &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_mongodb_install.mongodb_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_mongodb_install.installing_mongodb")"
	loading "Installing MongoDB" _install_mongodb_impl
}

_uninstall_mongodb_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if pkg uninstall mongodb -y &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_mongodb_install.mongodb_uninstalled")"
		return 0
	else
		log_error "$(_tr "jinx_tools_db_mongodb_install.failed_to_uninstall_mongodb")"
		return 1
	fi
}

uninstall_mongodb() {
	if ! command -v mongod &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_mongodb_install.mongodb_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_mongodb_install.uninstalling_mongodb")"
	loading "Uninstalling MongoDB" _uninstall_mongodb_impl
}

_update_mongodb_impl() {
	loading "Updating MongoDB" _do_mongodb_update
}

_do_mongodb_update() {
	mkdir -p "$(dirname "$LOG_FILE")"
	pkg upgrade mongodb -y &>>"$LOG_FILE"
}

update_mongodb() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "MongoDB" "$(_get_installed_pkg_version mongodb "MongoDB")" "$(_get_remote_pkg_version mongodb)" _update_mongodb_impl
}

reinstall_mongodb() {
	uninstall_mongodb
	install_mongodb
}
