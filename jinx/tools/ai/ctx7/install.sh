#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_ctx7_dependencies() {
  loading "Installing dependencies" _ctx7_dependencies_impl
}

_ctx7_dependencies_impl() {
  declare -A DEPS=(
    ["nodejs-lts"]="node"
  )

  local pkg_name bin_name
  for pkg_name in "${!DEPS[@]}"; do
    bin_name="${DEPS[$pkg_name]}"
    if ! command -v "$bin_name" &>/dev/null; then
      if ! yes | pkg install "$pkg_name" &>>"$LOG_FILE"; then
        log_error "Failed to install $pkg_name"
        return 1
      fi
    fi
  done

  return 0
}

_install_ctx7_npm() {
  loading "Installing Context7" _install_ctx7_npm_impl
}

_install_ctx7_npm_impl() {
  if ! npm install -g ctx7 &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_ctx7_install.failed_to_install_context7")"
    return 1
  fi

  return 0
}

install_ctx7() {
  if command -v ctx7 &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_ctx7_install.context7_is_already_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_ctx7_install.installing_context7")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _ctx7_dependencies || return 1
  _install_ctx7_npm || return 1

  log_success "$(_tr "jinx_tools_ai_ctx7_install.context7_installed_successfully")"
  return 0
}

uninstall_ctx7() {
  if ! command -v ctx7 &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_ctx7_install.context7_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_ctx7_install.uninstalling_context7")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing Context7" _uninstall_ctx7_impl

  log_success "$(_tr "jinx_tools_ai_ctx7_install.context7_uninstalled")"
  return 0
}

_uninstall_ctx7_impl() {
  if ! npm uninstall -g ctx7 &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_ctx7_install.failed_to_uninstall_context7")"
    return 1
  fi
  return 0
}

update_ctx7() {
  _check_update_needed "Context7" "$(_get_installed_version ctx7)" "$(_get_remote_npm_version ctx7)" _update_ctx7
}

_update_ctx7() {
  loading "Updating Context7" _update_ctx7_impl
}

_update_ctx7_impl() {
  if ! npm update -g ctx7 &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_ctx7_install.failed_to_update_context7")"
    return 1
  fi
  return 0
}

reinstall_ctx7() {
  uninstall_ctx7
  install_ctx7
}
