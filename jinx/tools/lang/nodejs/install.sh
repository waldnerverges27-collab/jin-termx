#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

_install_npmjs_pkg() {
	loading "Installing Node.js LTS" _install_npmjs_pkg_impl
}

_install_npmjs_pkg_impl() {
	if ! yes | pkg install nodejs-lts &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_nodejs_install.failed_to_install_node_js_lts")"
		return 1
	fi
	return 0
}

_enable_corepack() {
	loading "Enabling Corepack (pnpm, yarn)" _enable_corepack_impl
}

_enable_corepack_impl() {
	if ! corepack enable &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_nodejs_install.failed_to_enable_corepack")"
		return 1
	fi
	return 0
}

install_npmjs() {
	if command -v node &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_nodejs_install.node_js_lts_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_nodejs_install.installing_node_js_lts")"

	mkdir -p "$(dirname "$LOG_FILE")"
	_install_npmjs_pkg || return 1
	_enable_corepack || return 1
	log_success "$(_tr "jinx_tools_lang_nodejs_install.node_js_lts_installed_pnpm_yarn_availa")"
	return 0
}

_uninstall_npmjs_pkg() {
	loading "Uninstalling Node.js LTS" _uninstall_npmjs_pkg_impl
}

_uninstall_npmjs_pkg_impl() {
	if ! pkg uninstall nodejs-lts -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_nodejs_install.failed_to_uninstall_node_js_lts")"
		return 1
	fi
	return 0
}

uninstall_npmjs() {
	if ! command -v node &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_nodejs_install.node_js_lts_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_nodejs_install.uninstalling_node_js_lts")"
	mkdir -p "$(dirname "$LOG_FILE")"
	_uninstall_npmjs_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_nodejs_install.node_js_lts_uninstalled")"
	return 0
}

_update_npmjs_pkg() {
  loading "Updating Node.js LTS" _do_npmjs_update
}

_do_npmjs_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade nodejs-lts -y &>>"$LOG_FILE"
}

update_npmjs() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "Node.js LTS" "$(_get_installed_pkg_version nodejs-lts "Node.js LTS")" "$(_get_remote_pkg_version nodejs-lts)" _update_npmjs_pkg
}

reinstall_npmjs() {
	uninstall_npmjs
	install_npmjs
}
