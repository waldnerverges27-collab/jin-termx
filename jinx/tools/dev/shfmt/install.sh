#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_shfmt_pkg() {
	loading "Installing Shfmt" _install_shfmt_pkg_impl
}

_install_shfmt_pkg_impl() {
	if ! yes | pkg install shfmt &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_shfmt_install.failed_to_install_shfmt")"
		return 1
	fi
	return 0
}

_uninstall_shfmt_pkg() {
	loading "Uninstalling Shfmt" _uninstall_shfmt_pkg_impl
}

_uninstall_shfmt_pkg_impl() {
	if ! pkg uninstall shfmt -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_shfmt_install.failed_to_uninstall_shfmt")"
		return 1
	fi
	return 0
}

_update_shfmt_pkg() {
  loading "Updating Shfmt" _do_shfmt_update
}

_do_shfmt_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade shfmt -y &>>"$LOG_FILE"
}

install_shfmt() {
	if command -v shfmt &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_shfmt_install.shfmt_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_shfmt_install.installing_shfmt")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_shfmt_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_shfmt_install.shfmt_installed")"
	return 0
}

uninstall_shfmt() {
	if ! command -v shfmt &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_shfmt_install.shfmt_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_shfmt_install.uninstalling_shfmt")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_shfmt_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_shfmt_install.shfmt_uninstalled")"
	return 0
}

update_shfmt() {
	_check_update_needed "Shfmt" "$(_get_installed_pkg_version shfmt Shfmt)" "$(_get_remote_pkg_version shfmt)" _update_shfmt_pkg
}

reinstall_shfmt() {
	uninstall_shfmt
	install_shfmt
}
