#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_markserv_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_markserv_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_markserv_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_markserv_npm() {
  loading "Installing Markserv" _install_markserv_npm_impl
}

_install_markserv_npm_impl() {
  if ! npm install -g markserv &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_markserv_install.failed_to_install_markserv")"
    return 1
  fi
  return 0
}

install_markserv() {
  if command -v markserv &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_markserv_install.installing_markserv")"

  _markserv_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_markserv_npm || return 1
  log_success "$(_tr "jinx_tools_npm_markserv_install.markserv_installed")"
  return 0
}

_uninstall_markserv_npm() {
  loading "Uninstalling Markserv" _uninstall_markserv_npm_impl
}

_uninstall_markserv_npm_impl() {
  if ! npm uninstall -g markserv &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_markserv_install.failed_to_uninstall_markserv")"
    return 1
  fi
  return 0
}

uninstall_markserv() {
  if ! command -v markserv &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_markserv_install.markserv_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_markserv_install.uninstalling_markserv")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_markserv_npm || return 1
  log_success "$(_tr "jinx_tools_npm_markserv_install.markserv_uninstalled")"
  return 0
}

update_markserv() {
  _check_update_needed "Markserv" "$(_get_installed_npm_version markserv Markserv)" "$(_get_remote_npm_version markserv)" _update_markserv_impl
}

_update_markserv_impl() {
  loading "Updating Markserv" _do_markserv_update
}

_do_markserv_update() {
  npm update -g markserv &>>"$LOG_FILE"
}

reinstall_markserv() {
  uninstall_markserv
  install_markserv
}
