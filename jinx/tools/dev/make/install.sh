#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_make_pkg() {
	loading "Installing Make" _install_make_pkg_impl
}

_install_make_pkg_impl() {
	if ! yes | pkg install make &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_make_install.failed_to_install_make")"
		return 1
	fi
	return 0
}

_uninstall_make_pkg() {
	loading "Uninstalling Make" _uninstall_make_pkg_impl
}

_uninstall_make_pkg_impl() {
	if ! pkg uninstall make -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_make_install.failed_to_uninstall_make")"
		return 1
	fi
	return 0
}

_update_make_pkg() {
  loading "Updating Make" _do_make_update
}

_do_make_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade make -y &>>"$LOG_FILE"
}

install_make() {
	if command -v make &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_make_install.make_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_make_install.installing_make")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_make_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_make_install.make_installed")"
	return 0
}

uninstall_make() {
	if ! command -v make &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_make_install.make_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_make_install.uninstalling_make")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_make_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_make_install.make_uninstalled")"
	return 0
}

update_make() {
	_check_update_needed "Make" "$(_get_installed_pkg_version make "Make")" "$(_get_remote_pkg_version make)" _update_make_pkg
}

reinstall_make() {
	uninstall_make
	install_make
}
