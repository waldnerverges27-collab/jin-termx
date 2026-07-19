#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_nestjs_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_nestjs_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_nestjs_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_nestjs_npm() {
  loading "Installing NestJS CLI" _install_nestjs_npm_impl
}

_install_nestjs_npm_impl() {
  if ! npm install -g @nestjs/cli &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_nestjs_install.failed_to_install_nestjs_cli")"
    return 1
  fi
  return 0
}

install_nestjs() {
  if command -v nest &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_nestjs_install.installing_nestjs_cli")"

  _nestjs_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_nestjs_npm || return 1
  log_success "$(_tr "jinx_tools_npm_nestjs_install.nestjs_cli_installed")"
  return 0
}

_uninstall_nestjs_npm() {
  loading "Uninstalling NestJS CLI" _uninstall_nestjs_npm_impl
}

_uninstall_nestjs_npm_impl() {
  if ! npm uninstall -g @nestjs/cli &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_nestjs_install.failed_to_uninstall_nestjs_cli")"
    return 1
  fi
  return 0
}

uninstall_nestjs() {
  if ! command -v nest &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_nestjs_install.nestjs_cli_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_nestjs_install.uninstalling_nestjs_cli")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_nestjs_npm || return 1
  log_success "$(_tr "jinx_tools_npm_nestjs_install.nestjs_cli_uninstalled")"
  return 0
}

update_nestjs() {
  _check_update_needed "NestJS CLI" "$(_get_installed_npm_version @nestjs/cli NestJS CLI)" "$(_get_remote_npm_version @nestjs/cli)" _update_nestjs_impl
}

_update_nestjs_impl() {
  loading "Updating NestJS CLI" _do_nestjs_update
}

_do_nestjs_update() {
  npm update -g @nestjs/cli &>>"$LOG_FILE"
}

reinstall_nestjs() {
  uninstall_nestjs
  install_nestjs
}
