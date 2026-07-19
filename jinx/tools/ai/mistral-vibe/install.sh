#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_mistral_vibe_dependencies() {
  loading "Installing dependencies" _mistral_vibe_dependencies_impl
}

_mistral_vibe_dependencies_impl() {
  declare -A DEPS=(
    ["python"]="python"
    ["clang"]="clang"
    ["make"]="make"
    ["rust"]="rust"
    ["libffi"]=""
    ["openssl"]=""
    ["pkg-config"]=""
    ["git"]="git"
    ["ripgrep"]="rg"
  )

  local pkg_name bin_name
  for pkg_name in "${!DEPS[@]}"; do
    bin_name="${DEPS[$pkg_name]}"
    if [[ -n "$bin_name" ]] && command -v "$bin_name" &>/dev/null; then
      continue
    fi
    if ! yes | pkg install "$pkg_name" &>>"$LOG_FILE"; then
      log_error "Failed to install $pkg_name"
      return 1
    fi
  done

  pip install --upgrade pip setuptools wheel &>>"$LOG_FILE"
  return 0
}

_install_mistral_vibe_pip() {
  loading "Installing Mistral Vibe" _install_mistral_vibe_pip_impl
}

_install_mistral_vibe_pip_impl() {
  export ANDROID_API_LEVEL=24
  export GYP_DEFINES="android_ndk_path=''"

  if ! pip install mistral-vibe &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_mistral-vibe_install.failed_to_install_mistral_vibe")"
    return 1
  fi

  return 0
}

install_mistral_vibe() {
  if command -v vibe &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_mistral-vibe_install.mistral_vibe_is_already_installed")"
    return 2
  fi

  log_info "$(_tr "jinx_tools_ai_mistral-vibe_install.installing_mistral_vibe")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _mistral_vibe_dependencies || return 1
  _install_mistral_vibe_pip || return 1

  log_success "$(_tr "jinx_tools_ai_mistral-vibe_install.mistral_vibe_installed")"
  return 0
}

uninstall_mistral_vibe() {
  if ! command -v vibe &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_mistral-vibe_install.mistral_vibe_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_mistral-vibe_install.uninstalling_mistral_vibe")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing Mistral Vibe" _uninstall_mistral_vibe_impl

  log_success "$(_tr "jinx_tools_ai_mistral-vibe_install.mistral_vibe_uninstalled")"
  return 0
}

_uninstall_mistral_vibe_impl() {
  if ! pip uninstall mistral-vibe -y &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_mistral-vibe_install.failed_to_uninstall_mistral_vibe")"
    return 1
  fi
  return 0
}

update_mistral_vibe() {
  _check_update_needed "Mistral Vibe" "$(_get_installed_version vibe)" "$(_get_remote_pip_version mistral-vibe)" _update_mistral_vibe
}

_update_mistral_vibe() {
  loading "Updating Mistral Vibe" _update_mistral_vibe_impl
}

_update_mistral_vibe_impl() {
  export ANDROID_API_LEVEL=24
  export GYP_DEFINES="android_ndk_path=''"

  if ! pip install --upgrade mistral-vibe &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_mistral-vibe_install.failed_to_update_mistral_vibe")"
    return 1
  fi
  return 0
}

reinstall_mistral_vibe() {
  uninstall_mistral_vibe
  install_mistral_vibe
}
