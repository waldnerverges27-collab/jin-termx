#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_dev.log"

_install_openssh_pkg() {
  loading "Installing OpenSSH" _install_openssh_pkg_impl
}

_install_openssh_pkg_impl() {
  if ! yes | pkg install openssh &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_dev_openssh_install.failed_to_install_openssh")"
    return 1
  fi
  return 0
}

install_openssh() {
  if command -v sshd &>/dev/null; then
    log_info "$(_tr "jinx_tools_dev_openssh_install.openssh_is_already_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_dev_openssh_install.installing_openssh")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_openssh_pkg || return 1
  log_success "$(_tr "jinx_tools_dev_openssh_install.openssh_installed")"
  return 0
}

_uninstall_openssh_pkg() {
  loading "Uninstalling OpenSSH" _uninstall_openssh_pkg_impl
}

_uninstall_openssh_pkg_impl() {
  if ! pkg uninstall openssh -y &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_dev_openssh_install.failed_to_uninstall_openssh")"
    return 1
  fi
  return 0
}

uninstall_openssh() {
  if ! command -v sshd &>/dev/null; then
    log_info "$(_tr "jinx_tools_dev_openssh_install.openssh_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_dev_openssh_install.uninstalling_openssh")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_openssh_pkg || return 1
  log_success "$(_tr "jinx_tools_dev_openssh_install.openssh_uninstalled")"
  return 0
}

_update_openssh_pkg() {
  loading "Updating OpenSSH" _do_openssh_update
}

_do_openssh_update() {
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg upgrade openssh -y &>>"$LOG_FILE"
}

update_openssh() {
  _check_update_needed "OpenSSH" "$(_get_installed_pkg_version openssh OpenSSH)" "$(_get_remote_pkg_version openssh)" _update_openssh_pkg
}

reinstall_openssh() {
  uninstall_openssh
  install_openssh
}
