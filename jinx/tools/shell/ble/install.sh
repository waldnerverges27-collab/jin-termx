#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_shell.log"
BLE_DIR="$HOME/.local/share/blesh"

_install_ble_deps() {
  declare -A DEPS=(
    ["bash"]="bash"
    ["git"]="git"
  )

  local pkg_name bin_name
  for pkg_name in "${!DEPS[@]}"; do
    bin_name="${DEPS[$pkg_name]}"
    if ! command -v "$bin_name" &>/dev/null; then
      if ! yes | pkg install "$pkg_name" &>>"$LOG_FILE"; then
        log_error "Error al instalar $pkg_name"
        return 1
      fi
    fi
  done

  return 0
}

_install_ble_git() {
  loading "Instalando BLE (Bash Line Editor)" _install_ble_git_impl
}

_install_ble_git_impl() {
  mkdir -p "$(dirname "$BLE_DIR")"

  if [[ -d "$BLE_DIR" ]]; then
    git -C "$BLE_DIR" pull --ff-only &>>"$LOG_FILE" || true
    return 0
  fi

  if ! git clone --recursive --depth 1 "https://github.com/akinomyoga/ble.sh.git" "$BLE_DIR" &>>"$LOG_FILE"; then
    log_error "Error al clonar BLE"
    return 1
  fi

  # Compilar e instalar
  cd "$BLE_DIR" || return 1
  make install &>>"$LOG_FILE" || return 1

  return 0
}

install_ble() {
  if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/blesh/ble.sh" ]]; then
    log_info "BLE ya está instalado"
    return 2
  fi

  log_info "Instalando BLE (Bash Line Editor)..."

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_ble_deps || return 1
  _install_ble_git || return 1

  log_success "BLE instalado correctamente"
  return 0
}

uninstall_ble() {
  if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/blesh/ble.sh" ]]; then
    log_info "BLE no está instalado"
    return 2
  fi

  log_info "Desinstalando BLE..."

  rm -rf "$BLE_DIR" "${XDG_DATA_HOME:-$HOME/.local/share}/blesh" 2>/dev/null || true

  log_success "BLE desinstalado"
  return 0
}

update_ble() {
  if [[ ! -d "$BLE_DIR/.git" ]]; then
    log_info "BLE no está instalado"
    return 2
  fi

  loading "Actualizando BLE" _install_ble_git_impl
}

reinstall_ble() {
  uninstall_ble
  install_ble
}
