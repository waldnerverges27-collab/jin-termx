#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_psqlformat_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_psqlformat_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_psqlformat_install.installing_nodejs_and_perl")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts perl &>>"$LOG_FILE"
}

_install_psqlformat_npm() {
  loading "Installing PSQL Format" _install_psqlformat_npm_impl
}

_install_psqlformat_npm_impl() {
  if ! npm install -g psqlformat &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_psqlformat_install.failed_to_install_psql_format")"
    return 1
  fi
  return 0
}

install_psqlformat() {
  if command -v psqlformat &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_psqlformat_install.installing_psql_format")"

  _psqlformat_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_psqlformat_npm || return 1
  log_success "$(_tr "jinx_tools_npm_psqlformat_install.psql_format_installed")"
  return 0
}

_uninstall_psqlformat_npm() {
  loading "Uninstalling PSQL Format" _uninstall_psqlformat_npm_impl
}

_uninstall_psqlformat_npm_impl() {
  if ! npm uninstall -g psqlformat &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_psqlformat_install.failed_to_uninstall_psql_format")"
    return 1
  fi
  return 0
}

uninstall_psqlformat() {
  if ! command -v psqlformat &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_psqlformat_install.psql_format_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_psqlformat_install.uninstalling_psql_format")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_psqlformat_npm || return 1
  log_success "$(_tr "jinx_tools_npm_psqlformat_install.psql_format_uninstalled")"
  return 0
}

update_psqlformat() {
  _check_update_needed "PSQL Format" "$(_get_installed_npm_version psqlformat PSQL Format)" "$(_get_remote_npm_version psqlformat)" _update_psqlformat_impl
}

_update_psqlformat_impl() {
  loading "Updating PSQL Format" _do_psqlformat_update
}

_do_psqlformat_update() {
  npm update -g psqlformat &>>"$LOG_FILE"
}

reinstall_psqlformat() {
  uninstall_psqlformat
  install_psqlformat
}
