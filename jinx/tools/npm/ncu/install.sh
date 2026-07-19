#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_ncu_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_ncu_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_ncu_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_ncu_npm() {
  loading "Installing NPM Check Updates" _install_ncu_npm_impl
}

_install_ncu_npm_impl() {
  if ! npm install -g npm-check-updates &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_ncu_install.failed_to_install_npm_check_updates")"
    return 1
  fi
  return 0
}

install_ncu() {
  if command -v ncu &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_ncu_install.installing_npm_check_updates")"

  _ncu_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_ncu_npm || return 1
  log_success "$(_tr "jinx_tools_npm_ncu_install.npm_check_updates_installed")"
  return 0
}

_uninstall_ncu_npm() {
  loading "Uninstalling NPM Check Updates" _uninstall_ncu_npm_impl
}

_uninstall_ncu_npm_impl() {
  if ! npm uninstall -g npm-check-updates &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_ncu_install.failed_to_uninstall_npm_check_updates")"
    return 1
  fi
  return 0
}

uninstall_ncu() {
  if ! command -v ncu &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_ncu_install.npm_check_updates_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_ncu_install.uninstalling_npm_check_updates")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_ncu_npm || return 1
  log_success "$(_tr "jinx_tools_npm_ncu_install.npm_check_updates_uninstalled")"
  return 0
}

update_ncu() {
  _check_update_needed "NPM Check Updates" "$(_get_installed_npm_version npm-check-updates NPM Check Updates)" "$(_get_remote_npm_version npm-check-updates)" _update_ncu_impl
}

_update_ncu_impl() {
  loading "Updating NPM Check Updates" _do_ncu_update
}

_do_ncu_update() {
  npm update -g npm-check-updates &>>"$LOG_FILE"
}

reinstall_ncu() {
  uninstall_ncu
  install_ncu
}
