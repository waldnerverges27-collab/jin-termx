#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_lsd_pkg() {
	loading "Installing LSD" _install_lsd_pkg_impl
}

_install_lsd_pkg_impl() {
	if ! yes | pkg install lsd &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_lsd_install.failed_to_install_lsd")"
		return 1
	fi
	return 0
}

_uninstall_lsd_pkg() {
	loading "Uninstalling LSD" _uninstall_lsd_pkg_impl
}

_uninstall_lsd_pkg_impl() {
	if ! pkg uninstall lsd -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_lsd_install.failed_to_uninstall_lsd")"
		return 1
	fi
	return 0
}

_update_lsd_pkg() {
  loading "Updating LSD" _do_lsd_update
}

_do_lsd_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade lsd -y &>>"$LOG_FILE"
}

install_lsd() {
	if command -v lsd &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_lsd_install.lsd_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_lsd_install.installing_lsd")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_lsd_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_lsd_install.lsd_installed")"
	return 0
}

uninstall_lsd() {
	if ! command -v lsd &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_lsd_install.lsd_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_lsd_install.uninstalling_lsd")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_lsd_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_lsd_install.lsd_uninstalled")"
	return 0
}

update_lsd() {
	_check_update_needed "LSD" "$(_get_installed_pkg_version lsd "LSD")" "$(_get_remote_pkg_version lsd)" _update_lsd_pkg
}

reinstall_lsd() {
	uninstall_lsd
	install_lsd
}
