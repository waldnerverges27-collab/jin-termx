#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_db.log"

install_db() {
	separator
	box "$(_tr "jinx_modules_db.installing_databases")"
	separator
	echo

	log_info "$(_tr "jinx_modules_db.installing_databases")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_db_tools_wrapper
	log_success "$(_tr "jinx_modules_db.databases_installed_successfully")"
	separator
	echo
	list_item "$(_tr "jinx_modules_db.postgresql")"
	list_item "$(_tr "jinx_modules_db.mariadb_mysql")"
	list_item "$(_tr "jinx_modules_db.sqlite")"
	list_item "$(_tr "jinx_modules_db.mongodb")"
	list_item "$(_tr "jinx_modules_db.redis")"
	echo
}

_install_db_tools_wrapper() {
	import "@/tools/db/all"
	install_all_db_tools
}

uninstall_db() {
	if ! command -v postgres &>/dev/null; then
		log_info "$(_tr "jinx_modules_db.databases_are_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_db.uninstalling_databases")"
	separator
	echo

	log_info "$(_tr "jinx_modules_db.uninstalling_databases")"

	_uninstall_db_tools_wrapper
	log_success "$(_tr "jinx_modules_db.databases_uninstalled")"
}

_uninstall_db_tools_wrapper() {
	import "@/tools/db/all"
	uninstall_all_db_tools
}

update_db() {
	separator
	box "$(_tr "jinx_modules_db.updating_databases")"
	separator
	echo

	log_info "$(_tr "jinx_modules_db.updating_databases")"

	_update_db_tools_wrapper
	log_success "$(_tr "jinx_modules_db.databases_updated")"
}

_update_db_tools_wrapper() {
  import "@/tools/db/all"
  update_all_db_tools
}

reinstall_db() {
  separator
  box "$(_tr "jinx_modules_db.reinstalling_databases")"
  separator
  echo

  log_info "$(_tr "jinx_modules_db.reinstalling_databases")"

  _reinstall_db_tools_wrapper
  log_success "$(_tr "jinx_modules_db.databases_reinstalled_successfully")"
  separator
  echo
  list_item "$(_tr "jinx_modules_db.postgresql")"
  list_item "$(_tr "jinx_modules_db.mariadb_mysql")"
  list_item "$(_tr "jinx_modules_db.sqlite")"
  list_item "$(_tr "jinx_modules_db.mongodb")"
  list_item "$(_tr "jinx_modules_db.redis")"
  echo
}

_reinstall_db_tools_wrapper() {
  import "@/tools/db/all"
  reinstall_all_db_tools
}