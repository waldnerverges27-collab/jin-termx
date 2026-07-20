#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_shell.log"
STARSHIP_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
STARSHIP_CONFIG="$STARSHIP_CONFIG_DIR/starship.toml"
JINX_STARSHIP_CONFIG="$JINX_PATH/../assets/starship/config.toml"

_install_starship_pkg() {
  loading "Instalando Starship" _install_starship_pkg_impl
}

_install_starship_pkg_impl() {
  if yes | pkg install starship &>>"$LOG_FILE"; then
    return 0
  fi
  # Fallback: install via script
  if curl -fsSL https://starship.rs/install.sh -o /tmp/starship_install.sh &>>"$LOG_FILE"; then
    chmod +x /tmp/starship_install.sh
    sh /tmp/starship_install.sh -y &>>"$LOG_FILE"
    rm -f /tmp/starship_install.sh
    return $?
  fi
  return 1
}

_setup_starship_config() {
  mkdir -p "$STARSHIP_CONFIG_DIR"

  if [[ -f "$JINX_STARSHIP_CONFIG" ]]; then
    cp "$JINX_STARSHIP_CONFIG" "$STARSHIP_CONFIG"
    log_success "Configuración de Starship instalada"
  else
    # Config mínima por defecto
    cat >"$STARSHIP_CONFIG" <<'TOML'
format = """\
$directory\
$git_branch\
$git_status\
$line_break\
$character"""

[character]
success_symbol = "[❯](bold blue)"
error_symbol = "[❯](bold red)"

[directory]
truncation_length = 3
style = "bold cyan"

[git_branch]
format = " [$branch]($style)"
style = "bold purple"
TOML
    log_info "Usando configuración por defecto de Starship"
  fi
}

_setup_zsh_starship() {
  if ! grep -q "starship init zsh" ~/.zshrc 2>/dev/null; then
    echo >>~/.zshrc
    echo "# Starship prompt" >>~/.zshrc
    echo 'eval "$(starship init zsh)"' >>~/.zshrc
    log_info "Starship init agregado a .zshrc"
  else
    log_info "Starship ya configurado en .zshrc"
  fi
}

_setup_bash_starship() {
  if ! grep -q "starship init bash" ~/.bashrc 2>/dev/null; then
    echo >>~/.bashrc
    echo "# Starship prompt" >>~/.bashrc
    echo 'eval "$(starship init bash)"' >>~/.bashrc
    log_info "Starship init agregado a .bashrc"
  else
    log_info "Starship ya configurado en .bashrc"
  fi
}

install_starship() {
  if command -v starship &>/dev/null; then
    log_info "Starship ya está instalado"
    _setup_starship_config
    _setup_zsh_starship
    _setup_bash_starship
    return 2
  fi

  log_info "Instalando Starship prompt..."

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_starship_pkg || return 1
  _setup_starship_config
  _setup_zsh_starship
  _setup_bash_starship

  log_success "Starship instalado correctamente"
  return 0
}

uninstall_starship() {
  if ! command -v starship &>/dev/null; then
    log_info "Starship no está instalado"
    return 2
  fi

  log_info "Desinstalando Starship..."

  loading "Eliminando Starship" _uninstall_starship_impl

  # Limpiar configs
  sed -i '/starship init/d' ~/.zshrc 2>/dev/null || true
  sed -i '/starship init/d' ~/.bashrc 2>/dev/null || true

  log_success "Starship desinstalado"
  return 0
}

_uninstall_starship_impl() {
  if ! pkg uninstall -y starship &>>"$LOG_FILE"; then
    return 1
  fi
  rm -f "$STARSHIP_CONFIG"
  return 0
}

update_starship() {
  if ! command -v starship &>/dev/null; then
    log_info "Starship no está instalado"
    return 2
  fi

  # Actualizar configuración al template más reciente
  if [[ -f "$JINX_STARSHIP_CONFIG" ]]; then
    cp "$JINX_STARSHIP_CONFIG" "$STARSHIP_CONFIG"
    log_success "Configuración de Starship actualizada"
  fi

  # Verificar actualización del binario
  loading "Actualizando Starship" _update_starship_impl
}

_update_starship_impl() {
  if ! pkg upgrade -y starship &>>"$LOG_FILE"; then
    return 1
  fi
  return 0
}

reinstall_starship() {
  uninstall_starship
  install_starship
}
