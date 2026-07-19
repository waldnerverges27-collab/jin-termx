#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_editor.log"

_install_neovim_impl() {
  mkdir -p "$(dirname "$LOG_FILE")"
  if yes | pkg install neovim &>>"$LOG_FILE"; then
    log_success "$(_tr "jinx_tools_editor_neovim_install.neovim_installed")"
    return 0
  else
    log_error "$(_tr "jinx_tools_editor_neovim_install.failed_to_install_neovim")"
    return 1
  fi
}

install_neovim() {
  if command -v nvim &>/dev/null; then
    log_info "$(_tr "jinx_tools_editor_neovim_install.neovim_is_already_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_editor_neovim_install.installing_neovim")"
  loading "Installing Neovim" _install_neovim_impl
}

_uninstall_neovim_impl() {
  mkdir -p "$(dirname "$LOG_FILE")"
  if pkg uninstall neovim -y &>>"$LOG_FILE"; then
    log_success "$(_tr "jinx_tools_editor_neovim_install.neovim_uninstalled")"
    return 0
  else
    log_error "$(_tr "jinx_tools_editor_neovim_install.failed_to_uninstall_neovim")"
    return 1
  fi
}

uninstall_neovim() {
  if ! command -v nvim &>/dev/null; then
    log_info "$(_tr "jinx_tools_editor_neovim_install.neovim_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_editor_neovim_install.uninstalling_neovim")"
  loading "Uninstalling Neovim" _uninstall_neovim_impl
}

_update_neovim_impl() {
  loading "Updating Neovim" _do_neovim_update
}

_do_neovim_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade neovim -y &>>"$LOG_FILE"
}

update_neovim() {
  _check_update_needed "Neovim" "$(_get_installed_pkg_version neovim "Neovim")" "$(_get_remote_pkg_version neovim)" _update_neovim_impl
}

reinstall_neovim() {
  uninstall_neovim
  install_neovim
}
