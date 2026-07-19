#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"

_install_perl_pkg() {
	loading "Installing Perl" _install_perl_pkg_impl
}

_install_perl_pkg_impl() {
	if ! yes | pkg install perl &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_perl_install.failed_to_install_perl")"
		return 1
	fi
	return 0
}

install_perl() {
	if command -v perl &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_perl_install.perl_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_perl_install.installing_perl")"

	mkdir -p "$(dirname "$LOG_FILE")"
	_install_perl_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_perl_install.perl_installed")"
	return 0
}

_uninstall_perl_pkg() {
	loading "Uninstalling Perl" _uninstall_perl_pkg_impl
}

_uninstall_perl_pkg_impl() {
	if ! pkg uninstall perl -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_lang_perl_install.failed_to_uninstall_perl")"
		return 1
	fi
	return 0
}

uninstall_perl() {
	if ! command -v perl &>/dev/null; then
		log_info "$(_tr "jinx_tools_lang_perl_install.perl_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_lang_perl_install.uninstalling_perl")"
	mkdir -p "$(dirname "$LOG_FILE")"
	_uninstall_perl_pkg || return 1
	log_success "$(_tr "jinx_tools_lang_perl_install.perl_uninstalled")"
	return 0
}

_update_perl_pkg() {
  loading "Updating Perl" _do_perl_update
}

_do_perl_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade perl -y &>>"$LOG_FILE"
}

update_perl() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "Perl" "$(_get_installed_pkg_version perl "Perl")" "$(_get_remote_pkg_version perl)" _update_perl_pkg
}

reinstall_perl() {
	uninstall_perl
	install_perl
}
