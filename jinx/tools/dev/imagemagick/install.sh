#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_imagemagick_pkg() {
	loading "Installing ImageMagick" _install_imagemagick_pkg_impl
}

_install_imagemagick_pkg_impl() {
	if ! yes | pkg install imagemagick &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_imagemagick_install.failed_to_install_imagemagick")"
		return 1
	fi
	return 0
}

_uninstall_imagemagick_pkg() {
	loading "Uninstalling ImageMagick" _uninstall_imagemagick_pkg_impl
}

_uninstall_imagemagick_pkg_impl() {
	if ! pkg uninstall imagemagick -y &>>"$LOG_FILE"; then
		log_error "$(_tr "jinx_tools_dev_imagemagick_install.failed_to_uninstall_imagemagick")"
		return 1
	fi
	return 0
}

_update_imagemagick_pkg() {
  loading "Updating ImageMagick" _do_imagemagick_update
}

_do_imagemagick_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade imagemagick -y &>>"$LOG_FILE"
}

install_imagemagick() {
	if command -v magick &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_imagemagick_install.imagemagick_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_imagemagick_install.installing_imagemagick")"

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_imagemagick_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_imagemagick_install.imagemagick_installed")"
	return 0
}

uninstall_imagemagick() {
	if ! command -v magick &>/dev/null; then
		log_info "$(_tr "jinx_tools_dev_imagemagick_install.imagemagick_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_dev_imagemagick_install.uninstalling_imagemagick")"
	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_imagemagick_pkg || return 1
	log_success "$(_tr "jinx_tools_dev_imagemagick_install.imagemagick_uninstalled")"
	return 0
}

update_imagemagick() {
	_check_update_needed "ImageMagick" "$(_get_installed_pkg_version imagemagick "ImageMagick")" "$(_get_remote_pkg_version imagemagick)" _update_imagemagick_pkg
}

reinstall_imagemagick() {
	uninstall_imagemagick
	install_imagemagick
}
