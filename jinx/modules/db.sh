#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_db.log"

install_db() {
	separator
	box "Installing Bases de datos"
	separator
	echo

	log_info "Installing databases..."

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_db_tools_wrapper
	log_success "Bases de datos installed successfully"
	separator
	echo
	list_item "PostgreSQL"
	list_item "MariaDB (MySQL)"
	list_item "SQLite"
	list_item "MongoDB"
	list_item "Redis"
	echo
}

_install_db_tools_wrapper() {
	import "@/tools/db/all"
	install_all_db_tools
}

uninstall_db() {
	if ! command -v postgres &>/dev/null; then
		log_info "Bases de datos are not installed"
		return 0
	fi
	separator
	box "Uninstalling Bases de datos"
	separator
	echo

	log_info "Uninstalling databases..."

	_uninstall_db_tools_wrapper
	log_success "Bases de datos uninstalled"
}

_uninstall_db_tools_wrapper() {
	import "@/tools/db/all"
	uninstall_all_db_tools
}

update_db() {
	separator
	box "Updating Bases de datos"
	separator
	echo

	log_info "Updating databases..."

	_update_db_tools_wrapper
	log_success "Bases de datos updated"
}

_update_db_tools_wrapper() {
  import "@/tools/db/all"
  update_all_db_tools
}

reinstall_db() {
  separator
  box "Reinstalling Bases de datos"
  separator
  echo

  log_info "Reinstalling databases..."

  _reinstall_db_tools_wrapper
  log_success "Bases de datos reinstalled successfully"
  separator
  echo
  list_item "PostgreSQL"
  list_item "MariaDB (MySQL)"
  list_item "SQLite"
  list_item "MongoDB"
  list_item "Redis"
  echo
}

_reinstall_db_tools_wrapper() {
  import "@/tools/db/all"
  reinstall_all_db_tools
}