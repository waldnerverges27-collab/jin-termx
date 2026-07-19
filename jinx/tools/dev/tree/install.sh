#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_tree_pkg() {
	loading "Installing Tree" _install_tree_pkg_impl
}

_install_tree_pkg_impl() {
	if ! yes | pkg install tree &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_tree_install.failed_to_install_tree")"
		return 1
	fi
	return 0
}

_uninstall_tree_pkg() {
	loading "Uninstalling Tree" _uninstall_tree_pkg_impl
}

_uninstall_tree_pkg_impl() {
	if ! pkg uninstall tree -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_tree_install.failed_to_uninstall_tree")"
		return 1
	fi
	return 0
}

_update_tree_pkg() {
  loading "Updating Tree" _do_tree_update
}

_do_tree_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade tree -y &>>"$LOG_FILE"
}

install_tree() {
	if command -v tree &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_tree_install.tree_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_tree_install.installing_tree")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_tree_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_tree_install.tree_installed")"
	return 0
}

uninstall_tree() {
	if ! command -v tree &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_tree_install.tree_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_tree_install.uninstalling_tree")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_tree_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_tree_install.tree_uninstalled")"
	return 0
}

update_tree() {
	_check_update_needed "Tree" "$(_get_installed_pkg_version tree "Tree")" "$(_get_remote_pkg_version tree)" _update_tree_pkg
}

reinstall_tree() {
	uninstall_tree
	install_tree
}
