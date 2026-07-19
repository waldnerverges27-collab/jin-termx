#!/data/data/com.termux/files/usr/bin/bash
import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_pi_dependencies() {
  loading "Installing dependencies" _pi_dependencies_impl
}

_pi_dependencies_impl() {
  declare -A DEPS=(
    ["nodejs-lts"]="node"
    ["ripgrep"]="rg"
    ["git"]="git"
    ["fd"]="fd"
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

_install_pi_npm() {
  loading "Installing Pi Coding Agent" _install_pi_npm_impl
}

_install_pi_npm_impl() {
  if ! npm install -g --ignore-scripts @earendil-works/pi-coding-agent &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_pi_install.failed_to_install_pi")"
    return 1
  fi

  return 0
}

install_pi() {
  if command -v pi &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_pi_install.pi_coding_agent_is_already_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_pi_install.installing_pi_coding_agent")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _pi_dependencies || return 1
  _install_pi_npm || return 1

  log_success "$(_tr "jinx_tools_ai_pi_install.pi_coding_agent_installed")"
  return 0
}

uninstall_pi() {
  if ! command -v pi &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_pi_install.pi_coding_agent_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_pi_install.uninstalling_pi_coding_agent")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing Pi Coding Agent" _uninstall_pi_impl

  log_success "$(_tr "jinx_tools_ai_pi_install.pi_uninstalled")"
  return 0
}

_uninstall_pi_impl() {
  if ! npm uninstall -g @earendil-works/pi-coding-agent &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_pi_install.failed_to_uninstall_pi")"
    return 1
  fi
  return 0
}

update_pi() {
  _check_update_needed "Pi Coding Agent" "$(_get_installed_version pi)" "$(_get_remote_npm_version @earendil-works/pi-coding-agent)" _update_pi
}

_update_pi() {
  loading "Updating Pi Coding Agent" _update_pi_impl
}

_update_pi_impl() {
  if ! npm install -g --ignore-scripts @earendil-works/pi-coding-agent &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_pi_install.failed_to_update_pi")"
    return 1
  fi
  return 0
}

reinstall_pi() {
  uninstall_pi
  install_pi
}
