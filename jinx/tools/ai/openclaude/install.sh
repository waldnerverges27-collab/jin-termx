#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_openclaude_dependencies() {
  loading "Installing dependencies" _openclaude_dependencies_impl
}

_openclaude_dependencies_impl() {
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

_install_openclaude_npm() {
  loading "Installing OpenClaude" _install_openclaude_npm_impl
}

_install_openclaude_npm_impl() {
  export GYP_DEFINES="android_ndk_path=''"
  export ANDROID_API_LEVEL=24

  if ! npm install -g @gitlawb/openclaude &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaude_install.failed_to_install_openclaude")"
    return 1
  fi

  return 0
}

install_openclaude() {
  if command -v openclaude &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_openclaude_install.openclaude_is_already_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_openclaude_install.installing_openclaude")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _openclaude_dependencies || return 1
  _install_openclaude_npm || return 1

  log_success "$(_tr "jinx_tools_ai_openclaude_install.openclaude_installed")"
  return 0
}

uninstall_openclaude() {
  if ! command -v openclaude &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_openclaude_install.openclaude_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_openclaude_install.uninstalling_openclaude")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing OpenClaude" _uninstall_openclaude_impl

  log_success "$(_tr "jinx_tools_ai_openclaude_install.openclaude_uninstalled")"
  return 0
}

_uninstall_openclaude_impl() {
  if ! npm uninstall -g @gitlawb/openclaude &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaude_install.failed_to_uninstall_openclaude")"
    return 1
  fi
  return 0
}

update_openclaude() {
  _check_update_needed "OpenClaude" "$(_get_installed_version openclaude)" "$(_get_remote_npm_version @gitlawb/openclaude)" _update_openclaude
}

_update_openclaude() {
  loading "Updating OpenClaude" _update_openclaude_impl
}

_update_openclaude_impl() {
  export GYP_DEFINES="android_ndk_path=''"
  export ANDROID_API_LEVEL=24

  if ! npm update -g @gitlawb/openclaude &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaude_install.failed_to_update_openclaude")"
    return 1
  fi
  return 0
}

reinstall_openclaude() {
  uninstall_openclaude
  install_openclaude
}
