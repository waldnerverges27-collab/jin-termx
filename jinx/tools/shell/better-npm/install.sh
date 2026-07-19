#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_shell.log"
ZSH_PLUGINS_DIR="$HOME/.zsh-plugins"

_better_npm_dependencies() {
  declare -A DEPS=(
    ["zsh"]="zsh"
    ["zoxide"]="zoxide"
    ["git"]="git"
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

  log_success "$(_tr "jinx_tools_shell_better-npm_install.shell_dependencies_installed")"
  return 0
}

_install_better_npm_git() {
  loading "Installing zsh-better-npm-completion" _install_better_npm_git_impl
}

_install_better_npm_git_impl() {
  mkdir -p "$(dirname "$LOG_FILE")"
  if ! git clone --depth=1 "https://github.com/lukechilds/zsh-better-npm-completion.git" "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_shell_better-npm_install.failed_to_install_zsh_better_npm_complet")"
    return 1
  fi
  git -C "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" fetch --tags --depth=1 &>>"$LOG_FILE"
  return 0
}

install_better_npm() {
  if [[ -d "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" ]]; then
    log_info "$(_tr "jinx_tools_shell_better-npm_install.zsh_better_npm_completion_already_instal")"
    return 0
  fi

  _better_npm_dependencies

  _install_better_npm_git || return 1
  log_success "$(_tr "jinx_tools_shell_better-npm_install.installed")"
  return 0
}

_uninstall_better_npm_impl() {
  if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" ]]; then
    log_info "$(_tr "jinx_tools_shell_better-npm_install.zsh_better_npm_completion_is_not_install")"
    return 0
  fi

  rm -rf "$ZSH_PLUGINS_DIR/zsh-better-npm-completion"
}

uninstall_better_npm() {
  loading "Uninstalling zsh-better-npm-completion" _uninstall_better_npm_impl
}

_update_better_npm() {
  loading "Updating zsh-better-npm-completion" _update_better_npm_impl
}

_update_better_npm_impl() {
  if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-better-npm-completion/.git" ]]; then
    log_warn "$(_tr "jinx_tools_shell_better-npm_install.zsh_better_npm_completion_not_installed")"
    return 0
  fi

  git -C "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" pull &>>"$LOG_FILE"
}

update_better_npm() {
  _update_better_npm
}

reinstall_better_npm() {
  uninstall_better_npm
  install_better_npm
}
