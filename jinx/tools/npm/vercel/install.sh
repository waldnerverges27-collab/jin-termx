#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_vercel_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_vercel_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_vercel_install.installing_nodejs")"
  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_vercel_npm() {
  loading "Installing Vercel CLI" _install_vercel_npm_impl
}

_install_vercel_npm_impl() {
  if ! npm install -g vercel &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_vercel_install.failed_to_install_vercel_cli")"
    return 1
  fi
  return 0
}

install_vercel() {
  if command -v vercel &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_vercel_install.installing_vercel_cli")"

  _vercel_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_vercel_npm || return 1
  log_success "$(_tr "jinx_tools_npm_vercel_install.vercel_cli_installed")"
  return 0
}

_uninstall_vercel_npm() {
  loading "Uninstalling Vercel CLI" _uninstall_vercel_npm_impl
}

_uninstall_vercel_npm_impl() {
  if ! npm uninstall -g vercel &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_vercel_install.failed_to_uninstall_vercel_cli")"
    return 1
  fi
  return 0
}

uninstall_vercel() {
  if ! command -v vercel &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_vercel_install.vercel_cli_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_vercel_install.uninstalling_vercel_cli")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_vercel_npm || return 1
  log_success "$(_tr "jinx_tools_npm_vercel_install.vercel_cli_uninstalled")"
  return 0
}

update_vercel() {
  _check_update_needed "Vercel CLI" "$(_get_installed_npm_version vercel Vercel CLI)" "$(_get_remote_npm_version vercel)" _update_vercel_impl
}

_update_vercel_impl() {
  loading "Updating Vercel CLI" _do_vercel_update
}

_do_vercel_update() {
  npm update -g vercel &>>"$LOG_FILE"
}

reinstall_vercel() {
  uninstall_vercel
  install_vercel
}
