#!/data/data/com.termux/files/usr/bin/bash

# Importar funciones de log y colores para el help
import "@/utils/log"
import "@/utils/colors"

JINX_COMMANDS=(
  "--version" "brain" "env" "install" "show" "update"
  "uninstall" "reinstall" "open" "list" "pg" "init" "voice"
  "doctor"
)

jinx_main() {
  local cmd="$1"
  shift || true

  # si no se pasa comando
  if [[ -z "$cmd" ]]; then
    jinx_help
    return
  fi

  local command_file="$JINX_PATH/cli/commands/$cmd.sh"

  # verificar si existe el comando
  if [[ -f "$command_file" ]]; then
    import "@/cli/commands/$cmd"
    "${cmd}_main" "$@"
  else
    log_error "Comando no encontrado: $cmd"
    # Buscar comandos similares
    local similar
    similar=$(_find_similar "$cmd")
    if [[ -n "$similar" ]]; then
      echo
      log_info "Quizás quisiste decir:"
      for s in $similar; do
        echo "    ${D_CYAN}jinx $s${NC}"
      done
    fi
    echo
    jinx_help
    exit 1
  fi
}

# Buscar comandos similares por prefijo o errores comunes
_find_similar() {
  local cmd="$1"
  local candidates=()
  local c

  for c in "${JINX_COMMANDS[@]}"; do
    # Prefijo coincide (ej: "up" → "update")
    if [[ "$c" == "$cmd"* ]]; then
      candidates+=("$c")
    # Error común de tipeo (1 char diferente)
    elif [[ ${#c} -eq ${#cmd} ]]; then
      local diff=0
      for ((i=0; i<${#c}; i++)); do
        [[ "${c:$i:1}" != "${cmd:$i:1}" ]] && ((diff++))
      done
      [[ $diff -le 1 ]] && candidates+=("$c")
    fi
  done

  if [[ ${#candidates[@]} -gt 0 ]]; then
    echo "${candidates[*]:0:3}"
  fi
}

jinx_help() {
  echo
  box "◈ JIN-TERMX v${JINX_VERSION} ◈"
  echo
  log_info "Uso: jinx <comando> [opciones]"
  echo
  separator_section "Comandos Disponibles"
  echo
  printf "    ${D_CYAN}%-12s${NC} %s\n" "--version" "Muestra la versión"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "brain" "Segundo cerebro — guarda recuerdos"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "env" "Variables de entorno"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "install" "Instala módulos y paquetes"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "show" "Muestra documentación"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "update" "Actualiza módulos o framework"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "uninstall" "Elimina módulos instalados"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "reinstall" "Reinstala módulos"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "open" "Abre documentación"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "list" "Lista herramientas disponibles"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "pg" "Gestor de PostgreSQL"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "init" "Configura proyectos existentes"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "voice" "Voz-a-agente por micrófono"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "doctor" "Diagnóstico del sistema"
  echo
  separator_section "Inicio Rápido"
  echo
  list_item "Ejecuta: ${D_CYAN}jinx${NC} para ver los comandos disponibles"
  list_item "Ejecuta: ${D_CYAN}jinx <comando> --help${NC} para ayuda específica"
  list_item "Ejecuta: ${D_CYAN}jinx install <módulo>${NC} para instalar"
  echo
  separator_section "Módulos Disponibles"
  echo
  log_info "Instala, actualiza, reinstala, desinstala, lista o muestra:"
  echo
  printf "    ${D_GREEN}%-10s${NC} %s\n" "lang" "Node, Bun, Python, Rust, C/C++, Go, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "db" "PostgreSQL, MongoDB, SQLite, Redis, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "ai" "OpenCode, Gentle AI, Claude Code, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "editor" "Neovim + NvChad + Plugins"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "dev" "GitHub CLI, wget, curl, fzf, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "npm" "Vercel, Live Server, NCU, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "shell" "ZSH + Oh My Zsh + 10 plugins"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "ui" "Letra, Cursor, Teclas extra, Banner"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "auto" "Herramientas de automatización (n8n)"
  echo
  separator_section "Ayuda"
  echo
  list_item "Ejecuta ${D_CYAN}jinx <comando>${NC} para ayuda específica"
  list_item "Ejemplo: ${D_CYAN}jinx pg${NC}, ${D_CYAN}jinx init${NC}"
  list_item "Lee el README: ${D_CYAN}glow README.md${NC} o ${D_CYAN}jinx <comando> --help${NC}"
  echo
}
