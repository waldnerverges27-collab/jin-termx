#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_live_server_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_live-server_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_live-server_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_live_server_npm() {
  loading "Installing Live Server" _install_live_server_npm_impl
}

_install_live_server_npm_impl() {
  if ! npm install -g live-server &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_live-server_install.failed_to_install_live_server")"
    return 1
  fi
  return 0
}

install_live_server() {
  if command -v live-server &>/dev/null; then
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_live-server_install.installing_live_server")"

  _live_server_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_live_server_npm || return 1
  log_success "$(_tr "jinx_tools_npm_live-server_install.live_server_installed")"
  return 0
}

_uninstall_live_server_npm() {
  loading "Uninstalling Live Server" _uninstall_live_server_npm_impl
}

_uninstall_live_server_npm_impl() {
  if ! npm uninstall -g live-server &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_live-server_install.failed_to_uninstall_live_server")"
    return 1
  fi
  return 0
}

uninstall_live_server() {
  if ! command -v live-server &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_live-server_install.live_server_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_live-server_install.uninstalling_live_server")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_live_server_npm || return 1
  log_success "$(_tr "jinx_tools_npm_live-server_install.live_server_uninstalled")"
  return 0
}

update_live_server() {
  _check_update_needed "Live Server" "$(_get_installed_npm_version live-server Live Server)" "$(_get_remote_npm_version live-server)" _update_live_server_impl
}

_update_live_server_impl() {
  loading "Updating Live Server" _do_live_server_update
}

_do_live_server_update() {
  npm update -g live-server &>>"$LOG_FILE"
}

reinstall_live_server() {
  uninstall_live_server
  install_live_server
}
