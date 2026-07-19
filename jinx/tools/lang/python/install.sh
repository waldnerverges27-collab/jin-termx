#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

_install_python_pkg() {
	loading "Installing Python" _install_python_pkg_impl
}

_install_python_pkg_impl() {
	if ! yes | pkg install python &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_python_install.failed_to_install_python")"
		return 1
	fi
	return 0
}

install_python() {
	if command -v python &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_python_install.python_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_python_install.installing_python")"

	mkdir -p "$(dirname "$LOG_FILE")"
	_install_python_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_python_install.python_installed")"
	return 0
}

_uninstall_python_pkg() {
	loading "Uninstalling Python" _uninstall_python_pkg_impl
}

_uninstall_python_pkg_impl() {
	if ! pkg uninstall python -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_python_install.failed_to_uninstall_python")"
		return 1
	fi
	return 0
}

uninstall_python() {
	if ! command -v python &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_python_install.python_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_python_install.uninstalling_python")"
	mkdir -p "$(dirname "$LOG_FILE")"
	_uninstall_python_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_python_install.python_uninstalled")"
	return 0
}

_update_python_pkg() {
  loading "Updating Python" _do_python_update
}

_do_python_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade python -y &>>"$LOG_FILE"
}

update_python() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "Python" "$(_get_installed_pkg_version python "Python")" "$(_get_remote_pkg_version python)" _update_python_pkg
}

reinstall_python() {
	uninstall_python
	install_python
}
