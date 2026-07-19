#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_auto.log"

install_auto() {
	separator
	box "$(_tr "jinx_modules_auto.installing_automation_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_auto.installing_automation_tools")"
	echo
	mkdir -p "$(dirname "$LOG_FILE")"

	_install_auto_wrapper
	log_success "$(_tr "jinx_modules_auto.automation_tools_installed_successfully")"
	separator
	echo
	list_item "n8n"
	echo
}

_install_auto_wrapper() {
	import "@/tools/auto/all"
	install_all_auto_tools
}

uninstall_auto() {
	if ! command -v n8n &>/dev/null; then
		log_info "$(_tr "jinx_modules_auto.automation_tools_are_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_auto.uninstalling_automation_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_auto.uninstalling_automation_tools")"

	_uninstall_auto_wrapper
	log_success "$(_tr "jinx_modules_auto.automation_tools_uninstalled")"
}

_uninstall_auto_wrapper() {
	import "@/tools/auto/all"
	uninstall_all_auto_tools
}

update_auto() {
	separator
	box "$(_tr "jinx_modules_auto.updating_automation_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_auto.updating_automation_tools")"

	_update_auto_wrapper
	log_success "$(_tr "jinx_modules_auto.automation_tools_updated")"
}

_update_auto_wrapper() {
  import "@/tools/auto/all"
  update_all_auto_tools
}

reinstall_auto() {
  separator
  box "$(_tr "jinx_modules_auto.reinstalling_automation_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_auto.reinstalling_automation_tools")"
  echo
  mkdir -p "$(dirname "$LOG_FILE")"

  _reinstall_auto_wrapper
  log_success "$(_tr "jinx_modules_auto.automation_tools_reinstalled_successfull")"
  separator
  echo
  list_item "n8n"
  echo
}

_reinstall_auto_wrapper() {
  import "@/tools/auto/all"
  reinstall_all_auto_tools
}