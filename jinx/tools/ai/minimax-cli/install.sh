#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_minimax_cli_dependencies() {
  loading "Installing dependencies" _minimax_cli_dependencies_impl
}

_minimax_cli_dependencies_impl() {
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

_install_minimax_cli_npm() {
  loading "Installing MiniMax CLI" _install_minimax_cli_npm_impl
}

_install_minimax_cli_npm_impl() {
  if ! npm install -g mmx-cli &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_minimax-cli_install.failed_to_install_minimax_cli")"
    return 1
  fi

  return 0
}

install_minimax_cli() {
  if command -v mmx &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_minimax-cli_install.minimax_cli_is_already_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_minimax-cli_install.installing_minimax_cli")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _minimax_cli_dependencies || return 1
  _install_minimax_cli_npm || return 1

  log_success "$(_tr "jinx_tools_ai_minimax-cli_install.minimax_cli_installed_successfully")"
  return 0
}

uninstall_minimax_cli() {
  if ! command -v mmx &>/dev/null; then
    log_success "$(_tr "jinx_tools_ai_minimax-cli_install.minimax_cli_is_not_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_minimax-cli_install.uninstalling_minimax_cli")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing MiniMax CLI" _uninstall_minimax_cli_impl

  log_success "$(_tr "jinx_tools_ai_minimax-cli_install.minimax_cli_uninstalled_successfully")"
  return 0
}

_uninstall_minimax_cli_impl() {
  if ! npm uninstall -g mmx-cli &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_minimax-cli_install.failed_to_uninstall_minimax_cli")"
    return 1
  fi
  return 0
}

update_minimax_cli() {
  _check_update_needed "MiniMax CLI" "$(_get_installed_version mmx)" "$(_get_remote_npm_version mmx-cli)" _update_minimax_cli
}

_update_minimax_cli() {
  loading "Updating MiniMax CLI" _update_minimax_cli_impl
}

_update_minimax_cli_impl() {
  if ! npm update -g mmx-cli &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_minimax-cli_install.failed_to_update_minimax_cli")"
    return 1
  fi
  return 0
}

reinstall_minimax_cli() {
  uninstall_minimax_cli
  install_minimax_cli
}
