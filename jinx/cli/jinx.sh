#!/data/data/com.termux/files/usr/bin/bash

# Importar funciones de log y colores para el help
import "@/utils/log"
import "@/utils/colors"

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
    log_error "Command not found: $cmd"
    echo
    jinx_help
    exit 1
  fi
}

jinx_help() {
  echo
  box "◈ JIN-TERMX v${JINX_VERSION} ◈"
  echo
  log_info "$(_tr "cli.usage")"
  echo
  separator_section "$(_tr "cli.available")"
  echo
  printf "    ${D_CYAN}%-12s${NC} %s\n" "--version" "$(_tr "cli.show_version")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "brain" "$(_tr "cli.cmd_brain")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "env" "$(_tr "cli.cmd_env")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "install" "$(_tr "cli.cmd_install")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "show" "$(_tr "cli.cmd_show")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "update" "$(_tr "cli.cmd_update")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "uninstall" "$(_tr "cli.cmd_uninstall")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "reinstall" "$(_tr "cli.cmd_reinstall")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "open" "$(_tr "cli.cmd_open")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "list" "$(_tr "cli.cmd_list")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "pg" "$(_tr "cli.cmd_pg")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "init" "$(_tr "cli.cmd_init")"
  printf "    ${D_CYAN}%-12s${NC} %s\n" "voice" "$(_tr "cli.cmd_voice")"
  echo
  separator_section "$(_tr "cli.quick_start")"
  echo
  _tr_echo "cli.run_cmd"
  _tr_echo "cli.run_open"
  _tr_echo "cli.run_install"
  echo
  separator_section "$(_tr "cli.module_targets")"
  echo
  log_info "$(_tr "cli.mod_help")"
  echo
  printf "    ${D_GREEN}%-10s${NC} %s\n" "lang" "$(_tr "module.lang")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "db" "$(_tr "module.db")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "ai" "$(_tr "module.ai")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "editor" "$(_tr "module.editor")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "dev" "$(_tr "module.dev")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "npm" "$(_tr "module.npm")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "shell" "$(_tr "module.shell")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "ui" "$(_tr "module.ui")"
  printf "    ${D_GREEN}%-10s${NC} %s\n" "auto" "$(_tr "module.auto")"

  echo
  separator_section "$(_tr "cli.help_title")"
  echo
  _tr_echo "cli.run_help"
  _tr_echo "cli.example"
  _tr_echo "cli.docs"
  echo
}
