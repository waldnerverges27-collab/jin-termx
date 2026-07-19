#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_kimi_code_dependencies() {
  loading "Installing dependencies" _kimi_code_dependencies_impl
}

_kimi_code_dependencies_impl() {
  declare -A DEPS=(
    ["nodejs-lts"]="node"
    ["git"]="git"
    ["ripgrep"]="rg"
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

_install_kimi_code_npm() {
  loading "Installing Kimi Code" _install_kimi_code_npm_impl
}

_install_kimi_code_npm_impl() {
  if ! npm install -g @moonshot-ai/kimi-code &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_kimi-code_install.failed_to_install_kimi_code")"
    return 1
  fi

  return 0
}

install_kimi_code() {
  if command -v kimi &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_kimi-code_install.kimi_code_is_already_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_kimi-code_install.installing_kimi_code")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _kimi_code_dependencies || return 1
  _install_kimi_code_npm || return 1

  log_success "$(_tr "jinx_tools_ai_kimi-code_install.kimi_code_installed_successfully")"
  return 0
}

uninstall_kimi_code() {
  if ! command -v kimi &>/dev/null; then
    log_success "$(_tr "jinx_tools_ai_kimi-code_install.kimi_code_is_not_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_kimi-code_install.uninstalling_kimi_code")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing Kimi Code" _uninstall_kimi_code_impl

  log_success "$(_tr "jinx_tools_ai_kimi-code_install.kimi_code_uninstalled_successfully")"
  return 0
}

_uninstall_kimi_code_impl() {
  if ! npm uninstall -g @moonshot-ai/kimi-code &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_kimi-code_install.failed_to_uninstall_kimi_code")"
    return 1
  fi
  return 0
}

update_kimi_code() {
  _check_update_needed "Kimi Code" "$(_get_installed_version kimi)" "$(_get_remote_npm_version @moonshot-ai/kimi-code)" _update_kimi_code
}

_update_kimi_code() {
  loading "Updating Kimi Code" _update_kimi_code_impl
}

_update_kimi_code_impl() {
  if ! npm update -g @moonshot-ai/kimi-code &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_kimi-code_install.failed_to_update_kimi_code")"
    return 1
  fi
  return 0
}

reinstall_kimi_code() {
  uninstall_kimi_code
  install_kimi_code
}
