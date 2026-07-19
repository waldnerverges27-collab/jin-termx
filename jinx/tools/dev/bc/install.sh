#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_bc_pkg() {
	loading "Installing bc" _install_bc_pkg_impl
}

_install_bc_pkg_impl() {
	if ! yes | pkg install bc &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_bc_install.failed_to_install_bc")"
		return 1
	fi
	return 0
}

_uninstall_bc_pkg() {
	loading "Uninstalling bc" _uninstall_bc_pkg_impl
}

_uninstall_bc_pkg_impl() {
	if ! pkg uninstall bc -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_bc_install.failed_to_uninstall_bc")"
		return 1
	fi
	return 0
}

_update_bc_pkg() {
  loading "Updating bc" _do_bc_update
}

_do_bc_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade bc -y &>>"$LOG_FILE"
}

install_bc() {
	if command -v bc &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_bc_install.bc_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_bc_install.installing_bc")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_bc_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_bc_install.bc_installed")"
	return 0
}

uninstall_bc() {
	if ! command -v bc &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_bc_install.bc_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_bc_install.uninstalling_bc")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_bc_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_bc_install.bc_uninstalled")"
	return 0
}

update_bc() {
	_check_update_needed "bc" "$(_get_installed_pkg_version bc "bc")" "$(_get_remote_pkg_version bc)" _update_bc_pkg
}

reinstall_bc() {
	uninstall_bc
	install_bc
}
