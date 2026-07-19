#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"

_engram_dependencies() {
  loading "Installing dependencies" _engram_dependencies_impl
}

_engram_dependencies_impl() {
  declare -A DEPS=(
    ["golang"]="go"
    ["git"]="git"
    ["sqlite"]="sqlite3"
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

_clone_engram_repo() {
  loading "Cloning engram repository" _clone_engram_repo_impl
}

_clone_engram_repo_impl() {
  if ! git clone --quiet https://github.com/Gentleman-Programming/engram "$JINX_DATA/engram" &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_engram_install.failed_to_clone_engram_repository")"
    return 1
  fi

  return 0
}

_build_engram() {
  loading "Building engram binary" _build_engram_impl
}

_build_engram_impl() {
  if ! go build -C "$JINX_DATA/engram/cmd/engram" -o $PREFIX/bin/engram &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_engram_install.failed_to_build_engram")"
    return 1
  fi

  return 0
}

install_engram() {
  if command -v engram &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_engram_install.engram_is_already_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_engram_install.installing_engram")"

  export GOPATH="$HOME/.local/go"
  export GOCACHE="$HOME/.cache/go"
  export GOMODCACHE="$GOPATH/pkg/mod"

  mkdir -p "$(dirname "$LOG_FILE")"

  _engram_dependencies || return 1
  _clone_engram_repo || return 1
  _build_engram || return 1

  log_success "$(_tr "jinx_tools_ai_engram_install.engram_installed")"
  return 0
}

uninstall_engram() {
  if ! command -v engram &>/dev/null; then
    log_info "$(_tr "jinx_tools_ai_engram_install.engram_is_not_installed")"
    return 2
  fi
  log_info "$(_tr "jinx_tools_ai_engram_install.uninstalling_engram")"
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Removing Engram" _uninstall_engram_impl

  log_success "$(_tr "jinx_tools_ai_engram_install.engram_uninstalled")"
  return 0
}

_uninstall_engram_impl() {
  if rm -rf "$JINX_DATA/engram" && rm "$PREFIX/bin/engram" &>>"$LOG_FILE"; then
    return 0
  else
    log_error "$(_tr "jinx_tools_ai_engram_install.failed_to_uninstall_engram")"
    return 1
  fi
}

update_engram() {
  _check_update_needed "Engram" "$(_get_installed_version engram)" "$(_get_remote_github_version Gentleman-Programming/engram)" _update_engram
}

_update_engram() {
	_update_engram_impl
}

_update_engram_impl() {
  export GOPATH="$HOME/.local/go"
  export GOCACHE="$HOME/.cache/go"
  export GOMODCACHE="$GOPATH/pkg/mod"

  loading "Pulling latest code" _update_engram_pull
  loading "Building Engram binary" _update_engram_build
  return $?
}

_update_engram_pull() {
  if ! git -C "$JINX_DATA/engram" pull &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_engram_install.failed_to_update_engram_repository")"
    return 1
  fi
  return 0
}

_update_engram_build() {
  rm -f "$PREFIX/bin/engram"
  go clean -C "$JINX_DATA/engram" -cache &>>"$LOG_FILE"
  go mod tidy -C "$JINX_DATA/engram" &>>"$LOG_FILE"
  go mod download -C "$JINX_DATA/engram" &>>"$LOG_FILE"

  if ! go build -C "$JINX_DATA/engram/cmd/engram" -o "$PREFIX/bin/engram" &>>"$LOG_FILE"; then
    log_error "$(_tr "jinx_tools_ai_engram_install.failed_to_build_engram")"
    return 1
  fi
  return 0
}

reinstall_engram() {
  uninstall_engram
  install_engram
}
