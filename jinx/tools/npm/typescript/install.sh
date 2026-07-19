#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_typescript_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_typescript_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_typescript_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_typescript_npm() {
  loading "Installing TypeScript" _install_typescript_npm_impl
}

_install_typescript_npm_impl() {
  if ! npm install -g typescript &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_typescript_install.failed_to_install_typescript")"
    return 1
  fi
  return 0
}

install_typescript() {
  if command -v tsc &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_typescript_install.installing_typescript")"

  _typescript_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_typescript_npm || return 1
  log_success "$(_tr "jinx_tools_npm_typescript_install.typescript_installed")"
  return 0
}

_uninstall_typescript_npm() {
  loading "Uninstalling TypeScript" _uninstall_typescript_npm_impl
}

_uninstall_typescript_npm_impl() {
  if ! npm uninstall -g typescript &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_typescript_install.failed_to_uninstall_typescript")"
    return 1
  fi
  return 0
}

uninstall_typescript() {
  if ! command -v tsc &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_typescript_install.typescript_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_typescript_install.uninstalling_typescript")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_typescript_npm || return 1
  log_success "$(_tr "jinx_tools_npm_typescript_install.typescript_uninstalled")"
  return 0
}

update_typescript() {
  _check_update_needed "TypeScript" "$(_get_installed_npm_version typescript TypeScript)" "$(_get_remote_npm_version typescript)" _update_typescript_impl
}

_update_typescript_impl() {
  loading "Updating TypeScript" _do_typescript_update
}

_do_typescript_update() {
  npm update -g typescript &>>"$LOG_FILE"
}

reinstall_typescript() {
  uninstall_typescript
  install_typescript
}
