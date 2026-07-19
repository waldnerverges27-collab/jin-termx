#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_npm.log"

install_npm() {
	separator
	box "$(_tr "jinx_modules_npm.installing_node_js_modules")"
	separator
	echo

	log_info "$(_tr "jinx_modules_npm.installing_node_js_global_modules")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_npm_wrapper
	log_success "$(_tr "jinx_modules_npm.node_js_global_modules_installed")"
	echo
	list_item "$(_tr "jinx_modules_npm.typescript")"
	list_item "$(_tr "jinx_modules_npm.nestjs_cli")"
	list_item "$(_tr "jinx_modules_npm.prettier")"
	list_item "$(_tr "jinx_modules_npm.live_server")"
	list_item "$(_tr "jinx_modules_npm.localtunnel")"
	list_item "$(_tr "jinx_modules_npm.vercel_cli")"
	list_item "$(_tr "jinx_modules_npm.markserv")"
	list_item "$(_tr "jinx_modules_npm.psql_format")"
	list_item "$(_tr "jinx_modules_npm.npm_check_updates")"
	list_item "$(_tr "jinx_modules_npm.ngrok")"
	echo
	separator
	log_success "$(_tr "jinx_modules_npm.node_js_modules_installation_completed")"
	separator
	echo
}

_install_npm_wrapper() {
	import "@/tools/npm/all"
	install_all_npm_packages
}

uninstall_npm() {
	if ! command -v tsc &>/dev/null; then
		log_info "$(_tr "jinx_modules_npm.node_js_modules_are_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_npm.uninstalling_node_js_modules")"
	separator
	echo

	log_info "$(_tr "jinx_modules_npm.uninstalling_node_js_global_modules")"

	_uninstall_npm_wrapper
	log_success "$(_tr "jinx_modules_npm.node_js_global_modules_uninstalled")"
	echo
	separator
	log_success "$(_tr "jinx_modules_npm.node_js_modules_uninstallation_completed")"
	separator
	echo
}

_uninstall_npm_wrapper() {
	import "@/tools/npm/all"
	uninstall_all_npm_packages
}

update_npm() {
	separator
	box "$(_tr "jinx_modules_npm.updating_node_js_modules")"
	separator
	echo

	log_info "$(_tr "jinx_modules_npm.updating_node_js_global_modules")"

	_update_npm_wrapper
	log_success "$(_tr "jinx_modules_npm.node_js_global_modules_updated")"
	echo
	separator
	log_success "$(_tr "jinx_modules_npm.node_js_modules_update_completed")"
	separator
	echo
}

_update_npm_wrapper() {
  import "@/tools/npm/all"
  update_all_npm_packages
}

reinstall_npm() {
  separator
  box "$(_tr "jinx_modules_npm.reinstalling_node_js_modules")"
  separator
  echo

  log_info "$(_tr "jinx_modules_npm.reinstalling_node_js_global_modules")"

  _reinstall_npm_wrapper
  log_success "$(_tr "jinx_modules_npm.node_js_global_modules_reinstalled")"
  echo
  list_item "$(_tr "jinx_modules_npm.typescript")"
  list_item "$(_tr "jinx_modules_npm.nestjs_cli")"
  list_item "$(_tr "jinx_modules_npm.prettier")"
  list_item "$(_tr "jinx_modules_npm.live_server")"
  list_item "$(_tr "jinx_modules_npm.localtunnel")"
  list_item "$(_tr "jinx_modules_npm.vercel_cli")"
  list_item "$(_tr "jinx_modules_npm.markserv")"
  list_item "$(_tr "jinx_modules_npm.psql_format")"
  list_item "$(_tr "jinx_modules_npm.npm_check_updates")"
  list_item "$(_tr "jinx_modules_npm.ngrok")"
  echo
  separator
  log_success "$(_tr "jinx_modules_npm.node_js_modules_reinstallation_completed")"
  separator
  echo
}

_reinstall_npm_wrapper() {
  import "@/tools/npm/all"
  reinstall_all_npm_packages
}