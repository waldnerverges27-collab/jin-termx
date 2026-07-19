#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_proot_pkg() {
	loading "Installing Proot" _install_proot_pkg_impl
}

_install_proot_pkg_impl() {
	if ! yes | pkg install proot &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_proot_install.failed_to_install_proot")"
		return 1
	fi
	return 0
}

_uninstall_proot_pkg() {
	loading "Uninstalling Proot" _uninstall_proot_pkg_impl
}

_uninstall_proot_pkg_impl() {
	if ! pkg uninstall proot -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_proot_install.failed_to_uninstall_proot")"
		return 1
	fi
	return 0
}

_update_proot_pkg() {
  loading "Updating Proot" _do_proot_update
}

_do_proot_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade proot -y &>>"$LOG_FILE"
}

install_proot() {
	if command -v proot &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_proot_install.proot_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_proot_install.installing_proot")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_proot_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_proot_install.proot_installed")"
	return 0
}

uninstall_proot() {
	if ! command -v proot &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_proot_install.proot_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_proot_install.uninstalling_proot")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_proot_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_proot_install.proot_uninstalled")"
	return 0
}

update_proot() {
	_check_update_needed "Proot" "$(_get_installed_pkg_version proot Proot)" "$(_get_remote_pkg_version proot)" _update_proot_pkg
}

reinstall_proot() {
	uninstall_proot
	install_proot
}
