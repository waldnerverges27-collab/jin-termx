#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_openclaw_dependencies() {
  loading "Installing dependencies" _openclaw_dependencies_impl
}

_openclaw_dependencies_impl() {
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

_install_openclaw_npm() {
  loading "Installing OpenClaw and dependencies" _install_openclaw_npm_impl
}

_install_openclaw_npm_impl() {
  export GYP_DEFINES="android_ndk_path=''"
  export ANDROID_API_LEVEL=24

  npm install -g @larksuiteoapi/node-sdk nostr-tools @slack/web-api @whiskeysockets/baileys &>>"$LOG_FILE"

  if ! npm install -g openclaw@latest &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaw_install.failed_to_install_openclaw")"
    return 1
  fi

  return 0
}

install_openclaw() {
  if command -v openclaw &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_openclaw_install.openclaw_is_already_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_openclaw_install.installing_openclaw")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _openclaw_dependencies || return 1
  _install_openclaw_npm || return 1

  log_success "$(_tr "jinx_tools_ai_openclaw_install.openclaw_installed")"
  return 0
}

uninstall_openclaw() {
  if ! command -v openclaw &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_openclaw_install.openclaw_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_openclaw_install.uninstalling_openclaw")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing OpenClaw" _uninstall_openclaw_impl

  log_success "$(_tr "jinx_tools_ai_openclaw_install.openclaw_uninstalled")"
  return 0
}

_uninstall_openclaw_impl() {
  if ! npm uninstall -g openclaw @larksuiteoapi/node-sdk nostr-tools @slack/web-api @whiskeysockets/baileys &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaw_install.failed_to_uninstall_openclaw")"
    return 1
  fi
  return 0
}

update_openclaw() {
  _check_update_needed "OpenClaw" "$(_get_installed_version openclaw)" "$(_get_remote_npm_version openclaw)" _update_openclaw
}

_update_openclaw() {
  loading "Updating OpenClaw" _update_openclaw_impl
}

_update_openclaw_impl() {
  export GYP_DEFINES="android_ndk_path=''"
  export ANDROID_API_LEVEL=24

  if ! npm update -g openclaw @larksuiteoapi/node-sdk nostr-tools @slack/web-api @whiskeysockets/baileys &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_openclaw_install.failed_to_update_openclaw")"
    return 1
  fi
  return 0
}

reinstall_openclaw() {
  uninstall_openclaw
  install_openclaw
}
