#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_editor.log"

install_editor() {
	separator
	box "$(_tr "jinx_modules_editor.installing_code_editor")"
	separator
	echo

	log_info "$(_tr "jinx_modules_editor.installing_neovim_and_dependencies")"

	mkdir -p "$(dirname "$LOG_FILE")"

	loading "Installing Neovim dependencies" _install_editor_deps
	log_success "$(_tr "jinx_modules_editor.neovim_dependencies_installed")"

	_install_editor_wrapper
	log_success "$(_tr "jinx_modules_editor.code_editor_installed_successfully")"
	separator
	echo
	list_item "$(_tr "jinx_modules_editor.neovim_code_editor")"
	list_item "$(_tr "jinx_modules_editor.nvchad_framework_for_neovim")"
	list_item "$(_tr "jinx_modules_editor.github_copilot_ai_code_assistant")"
	list_item "$(_tr "jinx_modules_editor.codecompanion_ai_chat_assistant")"
	echo
}

_install_editor_deps() {
	yes | pkg install git neovim nodejs-lts python perl curl wget lua-language-server ripgrep stylua tree-sitter &>"$LOG_FILE"
}

_install_editor_wrapper() {
	import "@/tools/editor/all"
	install_all_editor_components
}

uninstall_editor() {
	if ! command -v nvim &>/dev/null; then
		log_info "$(_tr "jinx_modules_editor.code_editor_is_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_editor.uninstalling_code_editor")"
	separator
	echo

	log_info "$(_tr "jinx_modules_editor.uninstalling_neovim_configuration")"

	_uninstall_editor_wrapper
	log_success "$(_tr "jinx_modules_editor.code_editor_uninstalled")"
}

_uninstall_editor_wrapper() {
	import "@/tools/editor/all"
	uninstall_all_editor_components
}

update_editor() {
	separator
	box "$(_tr "jinx_modules_editor.updating_code_editor")"
	separator
	echo

	log_info "$(_tr "jinx_modules_editor.updating_nvchad_configuration")"

	_update_editor_wrapper
	log_success "$(_tr "jinx_modules_editor.code_editor_updated")"
}

_update_editor_wrapper() {
  import "@/tools/editor/all"
  update_all_editor_components
}

reinstall_editor() {
  separator
  box "$(_tr "jinx_modules_editor.reinstalling_code_editor")"
  separator
  echo

  log_info "$(_tr "jinx_modules_editor.reinstalling_neovim_and_dependencies")"

  _reinstall_editor_wrapper
  log_success "$(_tr "jinx_modules_editor.code_editor_reinstalled_successfully")"
  separator
  echo
  list_item "$(_tr "jinx_modules_editor.neovim_code_editor")"
  list_item "$(_tr "jinx_modules_editor.nvchad_framework_for_neovim")"
  list_item "$(_tr "jinx_modules_editor.github_copilot_ai_code_assistant")"
  list_item "$(_tr "jinx_modules_editor.codecompanion_ai_chat_assistant")"
  echo
}

_reinstall_editor_wrapper() {
  import "@/tools/editor/all"
  reinstall_all_editor_components
}