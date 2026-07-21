#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_ai.log"
NINE_ROUTER_DATA_DIR="$HOME/.local/share/jin-termx-data/9router"

_9router_install_deps() {
  loading "Instalando dependencias" _9router_install_deps_impl
}

_9router_install_deps_impl() {
  if ! command -v node &>/dev/null; then
    if ! pkg install -y nodejs-lts &>>"$LOG_FILE"; then
      log_error "Error al instalar Node.js"
      return 1
    fi
  fi
  return 0
}

_install_9router_npm() {
  loading "Instalando 9Router" _install_9router_npm_impl
}

_install_9router_npm_impl() {
  if ! npm install -g 9router &>>"$LOG_FILE"; then
    log_error "Error al instalar 9Router"
    return 1
  fi
  return 0
}

install_9router() {
  if command -v 9router &>/dev/null; then
    log_info "9Router ya está instalado"
    return 2
  fi

  log_info "Instalando 9Router..."

  mkdir -p "$(dirname "$LOG_FILE")"

  _9router_install_deps || return 1
  _install_9router_npm || return 1

  log_success "9Router instalado correctamente"
  return 0
}

uninstall_9router() {
  if ! command -v 9router &>/dev/null; then
    log_info "9Router no está instalado"
    return 2
  fi

  log_info "Desinstalando 9Router..."
  mkdir -p "$(dirname "$LOG_FILE")"

  loading "Eliminando 9Router" _uninstall_9router_impl

  log_success "9Router desinstalado"
  return 0
}

_uninstall_9router_impl() {
  if ! npm uninstall -g 9router &>>"$LOG_FILE"; then
    log_error "Error al desinstalar 9Router"
    return 1
  fi
  return 0
}

update_9router() {
  _check_update_needed "9Router" "$(_get_installed_npm_version 9router)" "$(_get_remote_npm_version 9router)" _update_9router
}

_update_9router() {
  loading "Actualizando 9Router" _update_9router_impl
}

_update_9router_impl() {
  if ! npm update -g 9router &>>"$LOG_FILE"; then
    log_error "Error al actualizar 9Router"
    return 1
  fi
  return 0
}

reinstall_9router() {
  uninstall_9router
  install_9router
}
