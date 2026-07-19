#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_html2text_pkg() {
	loading "Installing html2text" _install_html2text_pkg_impl
}

_install_html2text_pkg_impl() {
	if ! yes | pkg install html2text &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_html2text_install.failed_to_install_html2text")"
		return 1
	fi
	return 0
}

_uninstall_html2text_pkg() {
	loading "Uninstalling html2text" _uninstall_html2text_pkg_impl
}

_uninstall_html2text_pkg_impl() {
	if ! pkg uninstall html2text -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_html2text_install.failed_to_uninstall_html2text")"
		return 1
	fi
	return 0
}

_update_html2text_pkg() {
  loading "Updating html2text" _do_html2text_update
}

_do_html2text_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade html2text -y &>>"$LOG_FILE"
}

install_html2text() {
	if command -v html2text &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_html2text_install.html2text_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_html2text_install.installing_html2text")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_html2text_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_html2text_install.html2text_installed")"
	return 0
}

uninstall_html2text() {
	if ! command -v html2text &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_html2text_install.html2text_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_html2text_install.uninstalling_html2text")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_html2text_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_html2text_install.html2text_uninstalled")"
	return 0
}

update_html2text() {
	_check_update_needed "html2text" "$(_get_installed_pkg_version html2text html2text)" "$(_get_remote_pkg_version html2text)" _update_html2text_pkg
}

reinstall_html2text() {
	uninstall_html2text
	install_html2text
}
