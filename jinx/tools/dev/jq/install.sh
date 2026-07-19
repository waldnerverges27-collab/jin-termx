#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_jq_pkg() {
	loading "Installing jq" _install_jq_pkg_impl
}

_install_jq_pkg_impl() {
	if ! yes | pkg install jq &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_jq_install.failed_to_install_jq")"
		return 1
	fi
	return 0
}

_uninstall_jq_pkg() {
	loading "Uninstalling jq" _uninstall_jq_pkg_impl
}

_uninstall_jq_pkg_impl() {
	if ! pkg uninstall jq -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_jq_install.failed_to_uninstall_jq")"
		return 1
	fi
	return 0
}

_update_jq_pkg() {
  loading "Updating jq" _do_jq_update
}

_do_jq_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade jq -y &>>"$LOG_FILE"
}

install_jq() {
	if command -v jq &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_jq_install.jq_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_jq_install.installing_jq")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_jq_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_jq_install.jq_installed")"
	return 0
}

uninstall_jq() {
	if ! command -v jq &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_jq_install.jq_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_jq_install.uninstalling_jq")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_jq_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_jq_install.jq_uninstalled")"
	return 0
}

update_jq() {
	_check_update_needed "jq" "$(_get_installed_pkg_version jq "jq")" "$(_get_remote_pkg_version jq)" _update_jq_pkg
}

reinstall_jq() {
	uninstall_jq
	install_jq
}
