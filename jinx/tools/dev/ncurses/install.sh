#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_ncurses_pkg() {
	loading "Installing Ncurses Utils" _install_ncurses_pkg_impl
}

_install_ncurses_pkg_impl() {
	if ! yes | pkg install ncurses-utils &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_ncurses_install.failed_to_install_ncurses_utils")"
		return 1
	fi
	return 0
}

_uninstall_ncurses_pkg() {
	loading "Uninstalling Ncurses Utils" _uninstall_ncurses_pkg_impl
}

_uninstall_ncurses_pkg_impl() {
	if ! pkg uninstall ncurses-utils -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_ncurses_install.failed_to_uninstall_ncurses_utils")"
		return 1
	fi
	return 0
}

_update_ncurses_pkg() {
  loading "Updating Ncurses Utils" _do_ncurses_update
}

_do_ncurses_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade ncurses-utils -y &>>"$LOG_FILE"
}

install_ncurses() {
	if command -v tput &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_ncurses_install.ncurses_utils_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_ncurses_install.installing_ncurses_utils")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_ncurses_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_ncurses_install.ncurses_utils_installed")"
	return 0
}

uninstall_ncurses() {
	if ! command -v tput &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_ncurses_install.ncurses_utils_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_ncurses_install.uninstalling_ncurses_utils")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_ncurses_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_ncurses_install.ncurses_utils_uninstalled")"
	return 0
}

update_ncurses() {
	_check_update_needed "Ncurses Utils" "$(_get_installed_pkg_version ncurses-utils "Ncurses Utils")" "$(_get_remote_pkg_version ncurses-utils)" _update_ncurses_pkg
}

reinstall_ncurses() {
	uninstall_ncurses
	install_ncurses
}
