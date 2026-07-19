#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_prettier_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_prettier_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_prettier_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_prettier_npm() {
  loading "Installing Prettier" _install_prettier_npm_impl
}

_install_prettier_npm_impl() {
  if ! npm install -g prettier &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_prettier_install.failed_to_install_prettier")"
    return 1
  fi
  return 0
}

install_prettier() {
  if command -v prettier &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_prettier_install.installing_prettier")"

  _prettier_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_prettier_npm || return 1
  log_success "$(_tr "jinx_tools_npm_prettier_install.prettier_installed")"
  return 0
}

_uninstall_prettier_npm() {
  loading "Uninstalling Prettier" _uninstall_prettier_npm_impl
}

_uninstall_prettier_npm_impl() {
  if ! npm uninstall -g prettier &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_prettier_install.failed_to_uninstall_prettier")"
    return 1
  fi
  return 0
}

uninstall_prettier() {
  if ! command -v prettier &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_prettier_install.prettier_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_prettier_install.uninstalling_prettier")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_prettier_npm || return 1
  log_success "$(_tr "jinx_tools_npm_prettier_install.prettier_uninstalled")"
  return 0
}

update_prettier() {
  _check_update_needed "Prettier" "$(_get_installed_npm_version prettier Prettier)" "$(_get_remote_npm_version prettier)" _update_prettier_impl
}

_update_prettier_impl() {
  loading "Updating Prettier" _do_prettier_update
}

_do_prettier_update() {
  npm update -g prettier &>>"$LOG_FILE"
}

reinstall_prettier() {
  uninstall_prettier
  install_prettier
}
