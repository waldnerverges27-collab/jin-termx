#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_dev.log"

install_dev() {
	separator
	box "$(_tr "jinx_modules_dev.installing_development_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_dev.installing_development_tools")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_dev_wrapper
	log_success "$(_tr "jinx_modules_dev.tools_installed_successfully")"
	separator
	echo
	list_item "$(_tr "jinx_modules_dev.github_cli")"
	list_item "$(_tr "jinx_modules_dev.wget")"
	list_item "$(_tr "jinx_modules_dev.curl")"
	list_item "$(_tr "jinx_modules_dev.lsd_ls_replacement")"
	list_item "$(_tr "jinx_modules_dev.bat_cat_replacement")"
	list_item "$(_tr "jinx_modules_dev.proot_chroot_alternative")"
	list_item "$(_tr "jinx_modules_dev.ncurses_utils")"
	list_item "$(_tr "jinx_modules_dev.tmate_terminal_sharing")"
	list_item "$(_tr "jinx_modules_dev.tmux_terminal_multiplexer")"
	list_item "$(_tr "jinx_modules_dev.openssh_ssh_server_and_client")"
	list_item "$(_tr "jinx_modules_dev.cloudflared_cloudflare_tunnel")"
	list_item "$(_tr "jinx_modules_dev.translate_shell")"
	list_item "$(_tr "jinx_modules_dev.html2text_html_to_text_converter")"
	list_item "$(_tr "jinx_modules_dev.jq_json_processor")"
	list_item "$(_tr "jinx_modules_dev.bc_calculator")"
	list_item "$(_tr "jinx_modules_dev.tree_directory_listing")"
	list_item "$(_tr "jinx_modules_dev.fzf_fuzzy_finder")"
	list_item "$(_tr "jinx_modules_dev.imagemagick_image_manipulation")"
	list_item "$(_tr "jinx_modules_dev.shfmt_shell_script_formatter")"
	list_item "$(_tr "jinx_modules_dev.make_build_automation")"
	list_item "$(_tr "jinx_modules_dev.udocker_container_management")"
	echo
}

_install_dev_wrapper() {
	import "@/tools/dev/all"
	install_all_dev
}

uninstall_dev() {
	if ! command -v gh &>/dev/null; then
		log_info "$(_tr "jinx_modules_dev.development_tools_are_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_dev.uninstalling_development_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_dev.uninstalling_development_tools")"

	_uninstall_dev_wrapper
	log_success "$(_tr "jinx_modules_dev.tools_uninstalled")"
}

_uninstall_dev_wrapper() {
	import "@/tools/dev/all"
	uninstall_all_dev
}

update_dev() {
	separator
	box "$(_tr "jinx_modules_dev.updating_development_tools")"
	separator
	echo

	log_info "$(_tr "jinx_modules_dev.updating_development_tools")"

	_update_dev_wrapper
	log_success "$(_tr "jinx_modules_dev.tools_updated")"
}

_update_dev_wrapper() {
  import "@/tools/dev/all"
  update_all_dev
}

reinstall_dev() {
  separator
  box "$(_tr "jinx_modules_dev.reinstalling_development_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_dev.reinstalling_development_tools")"

  _reinstall_dev_wrapper
  log_success "$(_tr "jinx_modules_dev.tools_reinstalled_successfully")"
  separator
  echo
  list_item "$(_tr "jinx_modules_dev.github_cli")"
  list_item "$(_tr "jinx_modules_dev.wget")"
  list_item "$(_tr "jinx_modules_dev.curl")"
  list_item "$(_tr "jinx_modules_dev.lsd_ls_replacement")"
  list_item "$(_tr "jinx_modules_dev.bat_cat_replacement")"
  list_item "$(_tr "jinx_modules_dev.proot_chroot_alternative")"
  list_item "$(_tr "jinx_modules_dev.ncurses_utils")"
  list_item "$(_tr "jinx_modules_dev.tmate_terminal_sharing")"
  list_item "$(_tr "jinx_modules_dev.tmux_terminal_multiplexer")"
  list_item "$(_tr "jinx_modules_dev.openssh_ssh_server_and_client")"
  list_item "$(_tr "jinx_modules_dev.cloudflared_cloudflare_tunnel")"
  list_item "$(_tr "jinx_modules_dev.translate_shell")"
  list_item "$(_tr "jinx_modules_dev.html2text_html_to_text_converter")"
  list_item "$(_tr "jinx_modules_dev.jq_json_processor")"
  list_item "$(_tr "jinx_modules_dev.bc_calculator")"
  list_item "$(_tr "jinx_modules_dev.tree_directory_listing")"
  list_item "$(_tr "jinx_modules_dev.fzf_fuzzy_finder")"
  list_item "$(_tr "jinx_modules_dev.imagemagick_image_manipulation")"
  list_item "$(_tr "jinx_modules_dev.shfmt_shell_script_formatter")"
  list_item "$(_tr "jinx_modules_dev.make_build_automation")"
  list_item "$(_tr "jinx_modules_dev.udocker_container_management")"
  echo
}

_reinstall_dev_wrapper() {
  import "@/tools/dev/all"
  reinstall_all_dev
}