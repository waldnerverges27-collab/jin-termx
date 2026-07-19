#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_npm.log"

_localtunnel_fix_openurl() {
  local openurl_js
  openurl_js="$(npm root -g)/localtunnel/node_modules/openurl/openurl.js"
  if [[ ! -f "$openurl_js" ]]; then
    openurl_js="$(npm root -g)/openurl/openurl.js"
  fi
  if [[ -f "$openurl_js" ]]; then
    sed -i "/default:/i\\
    case 'android':\\
        command = 'termux-open-url';\\
        break;" "$openurl_js"
  fi
}

_localtunnel_dependencies() {
  if command -v node &>/dev/null && command -v npm &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_localtunnel_install.node_js_and_npm_are_already_installed")"
    return 0
  fi

  log_info "$(_tr "jinx_tools_npm_localtunnel_install.installing_nodejs")"

  mkdir -p "$(dirname "$LOG_FILE")"
  yes | pkg install nodejs-lts &>>"$LOG_FILE"
}

_install_localtunnel_npm() {
  loading "Installing Localtunnel" _install_localtunnel_npm_impl
}

_install_localtunnel_npm_impl() {
  if ! npm install -g localtunnel &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_localtunnel_install.failed_to_install_localtunnel")"
    return 1
  fi
  log_info "$(_tr "jinx_tools_npm_localtunnel_install.applying_localtunnel_fix_for_android")"
  _localtunnel_fix_openurl &>>"$LOG_FILE"
  return 0
}

install_localtunnel() {
  if command -v lt &>/dev/null; then
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_localtunnel_install.installing_localtunnel")"

  _localtunnel_dependencies

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_localtunnel_npm || return 1
  log_success "$(_tr "jinx_tools_npm_localtunnel_install.localtunnel_installed")"
  return 0
}

_uninstall_localtunnel_npm() {
  loading "Uninstalling Localtunnel" _uninstall_localtunnel_npm_impl
}

_uninstall_localtunnel_npm_impl() {
  if ! npm uninstall -g localtunnel &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_npm_localtunnel_install.failed_to_uninstall_localtunnel")"
    return 1
  fi
  return 0
}

uninstall_localtunnel() {
  if ! command -v lt &>/dev/null; then
    log_info "$(_tr "jinx_tools_npm_localtunnel_install.localtunnel_is_not_installed")"
    return 0
  fi
  log_info "$(_tr "jinx_tools_npm_localtunnel_install.uninstalling_localtunnel")"
  mkdir -p "$(dirname "$LOG_FILE")"

  _uninstall_localtunnel_npm || return 1
  log_success "$(_tr "jinx_tools_npm_localtunnel_install.localtunnel_uninstalled")"
  return 0
}

update_localtunnel() {
  _check_update_needed "Localtunnel" "$(_get_installed_npm_version localtunnel Localtunnel)" "$(_get_remote_npm_version localtunnel)" _update_localtunnel_impl
}

_update_localtunnel_impl() {
  loading "Updating Localtunnel" _do_localtunnel_update
}

_do_localtunnel_update() {
  npm update -g localtunnel &>>"$LOG_FILE"
}

reinstall_localtunnel() {
  uninstall_localtunnel
  install_localtunnel
}
