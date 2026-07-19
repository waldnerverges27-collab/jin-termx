#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_tmate_pkg() {
	loading "Installing Tmate" _install_tmate_pkg_impl
}

_install_tmate_pkg_impl() {
	if ! yes | pkg install tmate &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_tmate_install.failed_to_install_tmate")"
		return 1
	fi
	return 0
}

_uninstall_tmate_pkg() {
	loading "Uninstalling Tmate" _uninstall_tmate_pkg_impl
}

_uninstall_tmate_pkg_impl() {
	if ! pkg uninstall tmate -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_tmate_install.failed_to_uninstall_tmate")"
		return 1
	fi
	return 0
}

_update_tmate_pkg() {
  loading "Updating Tmate" _do_tmate_update
}

_do_tmate_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade tmate -y &>>"$LOG_FILE"
}

install_tmate() {
	if command -v tmate &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_tmate_install.tmate_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_tmate_install.installing_tmate")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_tmate_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_tmate_install.tmate_installed")"
	return 0
}

uninstall_tmate() {
	if ! command -v tmate &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_tmate_install.tmate_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_tmate_install.uninstalling_tmate")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_tmate_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_tmate_install.tmate_uninstalled")"
	return 0
}

update_tmate() {
	_check_update_needed "Tmate" "$(_get_installed_pkg_version tmate Tmate)" "$(_get_remote_pkg_version tmate)" _update_tmate_pkg
}

reinstall_tmate() {
	uninstall_tmate
	install_tmate
}
