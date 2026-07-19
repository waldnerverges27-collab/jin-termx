#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

TERMUX_DIR="$HOME/.termux"
TERMUX_ASSETS_DIR="$(dirname "$JINX_PATH")/assets"
LOG_FILE="$JINX_CACHE/install_ui.log"

setup_ui() {
	separator
	box "$(_tr "jinx_modules_ui.configuring_termux_ui")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	if [[ ! -d "$TERMUX_DIR" ]]; then
		mkdir -p "$TERMUX_DIR"
		log_info "Created Termux directory: $TERMUX_DIR"
	fi

	_setup_ui_wrapper
	separator
	log_success "$(_tr "jinx_modules_ui.termux_ui_configuration_completed")"
	separator
	echo
	list_item "$(_tr "jinx_modules_ui.cursor_green_00ff00")"
	list_item "$(_tr "jinx_modules_ui.extra_keys_custom_layout_with_navigatio")"
	list_item "$(_tr "jinx_modules_ui.font_meslo_nerd_font")"
	list_item "$(_tr "jinx_modules_ui.banner_jin_termx_startup_banner")"
	echo
	log_warn "$(_tr "jinx_modules_ui.please_restart_termux_to_apply_all_chang")"
	echo
}

_setup_ui_wrapper() {
	import "@/tools/ui/all"
	install_all_ui_components
}

uninstall_ui() {
	if [[ ! -d "$TERMUX_DIR" ]]; then
		log_info "$(_tr "jinx_modules_ui.termux_ui_configuration_is_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_ui.uninstalling_termux_ui_configuration")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_ui_wrapper
	echo
	separator
	log_success "$(_tr "jinx_modules_ui.termux_ui_configuration_uninstalled")"
	separator
	echo
	log_warn "$(_tr "jinx_modules_ui.please_restart_termux_to_apply_changes")"
	echo
}

_uninstall_ui_wrapper() {
	import "@/tools/ui/all"
	uninstall_all_ui_components
}

update_ui() {
	separator
	box "$(_tr "jinx_modules_ui.updating_termux_ui_configuration")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_update_ui_wrapper
	echo
	separator
	log_success "$(_tr "jinx_modules_ui.termux_ui_configuration_updated")"
	separator
	echo
}

_update_ui_wrapper() {
  import "@/tools/ui/all"
  update_all_ui_components
}

reinstall_ui() {
  separator
  box "$(_tr "jinx_modules_ui.reinstalling_termux_ui_configuration")"
  separator
  echo

  mkdir -p "$(dirname "$LOG_FILE")"

  _reinstall_ui_wrapper
  separator
  log_success "$(_tr "jinx_modules_ui.termux_ui_configuration_reinstalled")"
  separator
  echo
  list_item "$(_tr "jinx_modules_ui.cursor_green_00ff00")"
  list_item "$(_tr "jinx_modules_ui.extra_keys_custom_layout_with_navigatio")"
  list_item "$(_tr "jinx_modules_ui.font_meslo_nerd_font")"
  list_item "$(_tr "jinx_modules_ui.banner_jin_termx_startup_banner")"
  echo
  log_warn "$(_tr "jinx_modules_ui.please_restart_termux_to_apply_all_chang")"
  echo
}

_reinstall_ui_wrapper() {
  import "@/tools/ui/all"
  reinstall_all_ui_components
}