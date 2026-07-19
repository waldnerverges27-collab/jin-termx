#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_translate_pkg() {
	loading "Installing Translate Shell" _install_translate_pkg_impl
}

_install_translate_pkg_impl() {
	if ! yes | pkg install translate-shell &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_translate_install.failed_to_install_translate_shell")"
		return 1
	fi
	return 0
}

_uninstall_translate_pkg() {
	loading "Uninstalling Translate Shell" _uninstall_translate_pkg_impl
}

_uninstall_translate_pkg_impl() {
	if ! pkg uninstall translate-shell -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_translate_install.failed_to_uninstall_translate_shell")"
		return 1
	fi
	return 0
}

_update_translate_pkg() {
  loading "Updating Translate Shell" _do_translate_update
}

_do_translate_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade translate-shell -y &>>"$LOG_FILE"
}

install_translate() {
	if command -v trans &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_translate_install.translate_shell_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_translate_install.installing_translate_shell")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_translate_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_translate_install.translate_shell_installed")"
	return 0
}

uninstall_translate() {
	if ! command -v trans &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_translate_install.translate_shell_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_translate_install.uninstalling_translate_shell")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_translate_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_translate_install.translate_shell_uninstalled")"
	return 0
}

update_translate() {
	_check_update_needed "Translate Shell" "$(_get_installed_pkg_version translate-shell "Translate Shell")" "$(_get_remote_pkg_version translate-shell)" _update_translate_pkg
}

reinstall_translate() {
	uninstall_translate
	install_translate
}
