#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_curl_pkg() {
	loading "Installing Curl" _install_curl_pkg_impl
}

_install_curl_pkg_impl() {
	if ! yes | pkg install curl &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_curl_install.failed_to_install_curl")"
		return 1
	fi
	return 0
}

_uninstall_curl_pkg() {
	loading "Uninstalling Curl" _uninstall_curl_pkg_impl
}

_uninstall_curl_pkg_impl() {
	if ! pkg uninstall curl -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_curl_install.failed_to_uninstall_curl")"
		return 1
	fi
	return 0
}

_update_curl_pkg() {
  loading "Updating Curl" _do_curl_update
}

_do_curl_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade curl -y &>>"$LOG_FILE"
}

install_curl() {
	if command -v curl &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_curl_install.curl_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_curl_install.installing_curl")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_curl_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_curl_install.curl_installed")"
	return 0
}

uninstall_curl() {
	if ! command -v curl &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_curl_install.curl_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_curl_install.uninstalling_curl")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_curl_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_curl_install.curl_uninstalled")"
	return 0
}

update_curl() {
	_check_update_needed "Curl" "$(_get_installed_pkg_version curl "Curl")" "$(_get_remote_pkg_version curl)" _update_curl_pkg
}

reinstall_curl() {
	uninstall_curl
	install_curl
}
