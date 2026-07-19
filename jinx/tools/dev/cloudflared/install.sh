#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_cloudflared_pkg() {
	loading "Installing Cloudflared" _install_cloudflared_pkg_impl
}

_install_cloudflared_pkg_impl() {
	if ! yes | pkg install cloudflared &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_cloudflared_install.failed_to_install_cloudflared")"
		return 1
	fi
	return 0
}

_uninstall_cloudflared_pkg() {
	loading "Uninstalling Cloudflared" _uninstall_cloudflared_pkg_impl
}

_uninstall_cloudflared_pkg_impl() {
	if ! pkg uninstall cloudflared -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_cloudflared_install.failed_to_uninstall_cloudflared")"
		return 1
	fi
	return 0
}

_update_cloudflared_pkg() {
  loading "Updating Cloudflared" _do_cloudflared_update
}

_do_cloudflared_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade cloudflared -y &>>"$LOG_FILE"
}

install_cloudflared() {
	if command -v cloudflared &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_cloudflared_install.cloudflared_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_cloudflared_install.installing_cloudflared")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_cloudflared_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_cloudflared_install.cloudflared_installed")"
	return 0
}

uninstall_cloudflared() {
	if ! command -v cloudflared &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_cloudflared_install.cloudflared_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_cloudflared_install.uninstalling_cloudflared")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_cloudflared_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_cloudflared_install.cloudflared_uninstalled")"
	return 0
}

update_cloudflared() {
	_check_update_needed "Cloudflared" "$(_get_installed_pkg_version cloudflared "Cloudflared")" "$(_get_remote_pkg_version cloudflared)" _update_cloudflared_pkg
}

reinstall_cloudflared() {
	uninstall_cloudflared
	install_cloudflared
}
