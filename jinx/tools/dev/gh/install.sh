#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_gh_pkg() {
	loading "Installing GitHub CLI" _install_gh_pkg_impl
}

_install_gh_pkg_impl() {
	if ! yes | pkg install gh &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_gh_install.failed_to_install_github_cli")"
		return 1
	fi
	return 0
}

_uninstall_gh_pkg() {
	loading "Uninstalling GitHub CLI" _uninstall_gh_pkg_impl
}

_uninstall_gh_pkg_impl() {
	if ! pkg uninstall gh -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_gh_install.failed_to_uninstall_github_cli")"
		return 1
	fi
	return 0
}

_update_gh_pkg() {
  loading "Updating GitHub CLI" _do_gh_update
}

_do_gh_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade gh -y &>>"$LOG_FILE"
}

install_gh() {
	if command -v gh &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_gh_install.github_cli_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_gh_install.installing_github_cli")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_gh_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_gh_install.github_cli_installed")"
	return 0
}

uninstall_gh() {
	if ! command -v gh &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_gh_install.github_cli_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_gh_install.uninstalling_github_cli")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_gh_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_gh_install.github_cli_uninstalled")"
	return 0
}

update_gh() {
	_check_update_needed "GitHub CLI" "$(_get_installed_pkg_version gh "GitHub CLI")" "$(_get_remote_pkg_version gh)" _update_gh_pkg
}

reinstall_gh() {
	uninstall_gh
	install_gh
}
