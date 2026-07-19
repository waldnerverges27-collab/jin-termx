#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ui.log"
TERMUX_DIR="$HOME/.termux"

_install_cursor_impl() {
	mkdir -p "$(dirname "$LOG_FILE")" "$TERMUX_DIR"

	cat >"$TERMUX_DIR/colors.properties" <<'EOF'
cursor=#00FF00
EOF

	log_success "$(_tr "jinx_tools_ui_cursor_install.cursor_color_set_to_00ff00_green")"
	return 0
}

install_cursor() {
	if [[ -f "$TERMUX_DIR/colors.properties" ]]; then
		log_info "$(_tr "jinx_tools_ui_cursor_install.cursor_color_already_configured")"
		return 0
	fi
	log_info "$(_tr "jinx_tools_ui_cursor_install.installing_cursor_color")"
	loading "Installing Cursor Color" _install_cursor_impl
}

_uninstall_cursor_impl() {
	if [[ -f "$TERMUX_DIR/colors.properties" ]]; then
		rm "$TERMUX_DIR/colors.properties"
		log_success "$(_tr "jinx_tools_ui_cursor_install.cursor_color_uninstalled")"
	else
		log_warn "$(_tr "jinx_tools_ui_cursor_install.cursor_color_not_configured")"
	fi
}

uninstall_cursor() {
	if [[ ! -f "$TERMUX_DIR/colors.properties" ]]; then
		log_info "$(_tr "jinx_tools_ui_cursor_install.cursor_color_is_not_installed")"
		return 0
	fi
	log_info "$(_tr "jinx_tools_ui_cursor_install.uninstalling_cursor_color")"
	loading "Uninstalling Cursor Color" _uninstall_cursor_impl
}

_update_cursor_impl() {
	install_cursor
}

update_cursor() {
  _update_cursor_impl
}

reinstall_cursor() {
	uninstall_cursor
	install_cursor
}
