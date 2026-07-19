#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

_install_php_pkg() {
	loading "Installing PHP" _install_php_pkg_impl
}

_install_php_pkg_impl() {
	if ! yes | pkg install php &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_php_install.failed_to_install_php")"
		return 1
	fi
	return 0
}

install_php() {
	if command -v php &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_php_install.php_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_php_install.installing_php")"

	mkdir -p "$(dirname "$LOG_FILE")"
	_install_php_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_php_install.php_installed")"
	return 0
}

_uninstall_php_pkg() {
	loading "Uninstalling PHP" _uninstall_php_pkg_impl
}

_uninstall_php_pkg_impl() {
	if ! pkg uninstall php -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_php_install.failed_to_uninstall_php")"
		return 1
	fi
	return 0
}

uninstall_php() {
	if ! command -v php &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_php_install.php_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_php_install.uninstalling_php")"
	mkdir -p "$(dirname "$LOG_FILE")"
	_uninstall_php_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_php_install.php_uninstalled")"
	return 0
}

_update_php_pkg() {
  loading "Updating PHP" _do_php_update
}

_do_php_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade php -y &>>"$LOG_FILE"
}

update_php() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "PHP" "$(_get_installed_pkg_version php "PHP")" "$(_get_remote_pkg_version php)" _update_php_pkg
}

reinstall_php() {
	uninstall_php
	install_php
}
