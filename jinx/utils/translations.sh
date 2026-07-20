#!/data/data/com.termux/files/usr/bin/bash
# Language / Translation system for Jin-TermX
# Supports: en (English), es (Spanish)
# Usage: _tr "key" [args...]   → prints translated string with %s replaced by args
# Keys use underscores (not dots) to avoid bash arithmetic evaluation of brackets.

[[ -n "${__JINX_TRANSLATIONS_LOADED:-}" ]] && return
__JINX_TRANSLATIONS_LOADED=1

# ── Detect language from config ────────────────────────────────────
JINX_LANG="${JINX_LANG:-en}"
if [[ -f "$JINX_CONFIG/config" ]]; then
	source "$JINX_CONFIG/config" 2>/dev/null
	JINX_LANG="${JINX_LANG:-${jinx_lang:-en}}"
fi

# ── Translation table ──────────────────────────────────────────────
declare -A _TR

_tr_set() {
	eval "_TR[\$1]=\$2"
}

# INSTALL
_tr_set en_install_title "◈ JIN-TERMX ◈"
_tr_set es_install_title "◈ JIN-TERMX ◈"
_tr_set en_install_saving_config "Saving configuration"
_tr_set es_install_saving_config "Guardando configuración"
_tr_set en_install_config_saved "Configuration saved"
_tr_set es_install_config_saved "Configuración guardada"
_tr_set en_install_complete "Installation Complete"
_tr_set es_install_complete "Instalación Completa"
_tr_set en_install_run_start "Run"
_tr_set es_install_run_start "Ejecuta"
_tr_set en_install_to_start "to get started"
_tr_set es_install_to_start "para empezar"
_tr_set en_install_install_modules "Install modules:"
_tr_set es_install_install_modules "Instala módulos:"

# BOOTSTRAP
_tr_set en_bootstrap_import_error "jinx: import error: %s not found"
_tr_set es_bootstrap_import_error "jinx: error de importación: %s no encontrado"

# CLI HELP
_tr_set en_cli_usage "Usage: jinx <command> [options]"
_tr_set es_cli_usage "Uso: jinx <comando> [opciones]"
_tr_set en_cli_available "Available Commands"
_tr_set es_cli_available "Comandos Disponibles"
_tr_set en_cli_show_version "Show current version"
_tr_set es_cli_show_version "Muestra la versión actual"
_tr_set en_cli_cmd_brain "Second brain - save and search memories"
_tr_set es_cli_cmd_brain "Segundo cerebro - guarda y busca recuerdos"
_tr_set en_cli_cmd_env "Manage environment variables"
_tr_set es_cli_cmd_env "Gestiona variables de entorno"
_tr_set en_cli_cmd_install "Install modules and packages"
_tr_set es_cli_cmd_install "Instala módulos y paquetes"
_tr_set en_cli_cmd_show "Show tool documentation"
_tr_set es_cli_cmd_show "Muestra documentación de herramientas"
_tr_set en_cli_cmd_update "Update modules or framework"
_tr_set es_cli_cmd_update "Actualiza módulos o el framework"
_tr_set en_cli_cmd_uninstall "Remove installed modules"
_tr_set es_cli_cmd_uninstall "Elimina módulos instalados"
_tr_set en_cli_cmd_reinstall "Uninstall + install modules"
_tr_set es_cli_cmd_reinstall "Desinstala e instala módulos"
_tr_set en_cli_cmd_open "Open documentation in browser"
_tr_set es_cli_cmd_open "Abre documentación en el navegador"
_tr_set en_cli_cmd_list "List available tools in modules"
_tr_set es_cli_cmd_list "Lista herramientas disponibles en módulos"
_tr_set en_cli_cmd_pg "PostgreSQL database manager"
_tr_set es_cli_cmd_pg "Gestor de base de datos PostgreSQL"
_tr_set en_cli_cmd_init "Configure existing projects"
_tr_set es_cli_cmd_init "Configura proyectos existentes"
_tr_set en_cli_cmd_voice "Speech-to-agent via microphone"
_tr_set es_cli_cmd_voice "Voz-a-agente mediante micrófono"
_tr_set en_cli_quick_start "Quick Start"
_tr_set es_cli_quick_start "Inicio Rápido"
_tr_set en_cli_run_cmd "Run: ${D_CYAN}jinx${NC} to see available commands"
_tr_set es_cli_run_cmd "Ejecuta: ${D_CYAN}jinx${NC} para ver comandos disponibles"
_tr_set en_cli_run_open "Run: ${D_CYAN}jinx open${NC} for official documentation"
_tr_set es_cli_run_open "Ejecuta: ${D_CYAN}jinx open${NC} para documentación oficial"
_tr_set en_cli_run_install "Run: ${D_CYAN}jinx install <module>${NC} to install modules"
_tr_set es_cli_run_install "Ejecuta: ${D_CYAN}jinx install <módulo>${NC} para instalar módulos"
_tr_set en_cli_module_targets "Module Targets"
_tr_set es_cli_module_targets "Módulos Disponibles"
_tr_set en_cli_mod_help "Install, update, reinstall, uninstall, list, show or open:"
_tr_set es_cli_mod_help "Instala, actualiza, reinstala, desinstala, lista, muestra o abre:"
_tr_set en_cli_help_title "Help"
_tr_set es_cli_help_title "Ayuda"
_tr_set en_cli_run_help "Run ${D_CYAN}jinx <command>${NC} for command-specific help"
_tr_set es_cli_run_help "Ejecuta ${D_CYAN}jinx <comando>${NC} para ayuda específica"
_tr_set en_cli_example "Example: ${D_CYAN}jinx pg${NC}, ${D_CYAN}jinx init${NC}"
_tr_set es_cli_example "Ejemplo: ${D_CYAN}jinx pg${NC}, ${D_CYAN}jinx init${NC}"
_tr_set en_cli_docs "Docs: ${D_CYAN}glow README.md${NC} or ${D_CYAN}jinx <command> --help${NC}"
_tr_set es_cli_docs "Docs: ${D_CYAN}glow README.md${NC} o ${D_CYAN}jinx <comando> --help${NC}"
_tr_set en_cli_cmd_not_found "Command not found: %s"
_tr_set es_cli_cmd_not_found "Comando no encontrado: %s"

# UPDATES
_tr_set en_update_available "Update Available"
_tr_set es_update_available "Actualización Disponible"
_tr_set en_update_new_version "New version available: %s (current: %s)"
_tr_set es_update_new_version "Nueva versión disponible: %s (actual: %s)"
_tr_set en_update_run_update "Run: ${D_CYAN}jinx update jinx${D_NC} to update"
_tr_set es_update_run_update "Ejecuta: ${D_CYAN}jinx update jinx${D_NC} para actualizar"

# MODULE DESCRIPTIONS
_tr_set en_module_lang "Node, Bun, Python, Rust, C/C++, Go, etc."
_tr_set es_module_lang "Node, Bun, Python, Rust, C/C++, Go, etc."
_tr_set en_module_db "PostgreSQL, MongoDB, SQLite, Redis, etc."
_tr_set es_module_db "PostgreSQL, MongoDB, SQLite, Redis, etc."
_tr_set en_module_ai "OpenCode, Gentle AI, Claude Code, etc."
_tr_set es_module_ai "OpenCode, Gentle AI, Claude Code, etc."
_tr_set en_module_editor "Neovim + NvChad + Plugins"
_tr_set es_module_editor "Neovim + NvChad + Plugins"
_tr_set en_module_dev "GitHub CLI, wget, curl, fzf, etc."
_tr_set es_module_dev "GitHub CLI, wget, curl, fzf, etc."
_tr_set en_module_npm "Vercel, Live Server, NCU, etc."
_tr_set es_module_npm "Vercel, Live Server, NCU, etc."
_tr_set en_module_shell "ZSH + Oh My Zsh + 10 plugins"
_tr_set es_module_shell "ZSH + Oh My Zsh + 10 plugins"
_tr_set en_module_ui "Font, Cursor, Extra-keys, Banner"
_tr_set es_module_ui "Letra, Cursor, Teclas extra, Banner"
_tr_set en_module_auto "Automation Tools (n8n)"
_tr_set es_module_auto "Herramientas de Automatización (n8n)"

# COMMAND HELP TITLES
_tr_set en_cmd_open_info "Documentation is available locally in the Jin-TermX repository."
_tr_set es_cmd_open_info "La documentación está disponible localmente en el repositorio Jin-TermX."
_tr_set en_cmd_open_help_hint "Run ${D_CYAN}jinx <command> --help${NC} for command-specific help"
_tr_set es_cmd_open_help_hint "Ejecuta ${D_CYAN}jinx <comando> --help${NC} para ayuda específica"
_tr_set en_cmd_open_read_hint "Read the README: ${D_CYAN}glow README.md${NC} (or ${D_CYAN}bat README.md${NC})"
_tr_set es_cmd_open_read_hint "Lee el README: ${D_CYAN}glow README.md${NC} (o ${D_CYAN}bat README.md${NC})"
_tr_set en_cmd_update_jinx "jinx       - Update only Jin-TermX framework"
_tr_set es_cmd_update_jinx "jinx       - Actualiza solo el framework Jin-TermX"

# BANNER / TIPS
_tr_set en_banner_welcome "Welcome to Jin-TermX v%s"
_tr_set es_banner_welcome "Bienvenido a Jin-TermX v%s"
_tr_set en_banner_run_start "Run ${DGREEN}jinx${NC} to get started"
_tr_set es_banner_run_start "Ejecuta ${DGREEN}jinx${NC} para empezar"
_tr_set en_banner_community "JinDev Software Development Community"
_tr_set es_banner_community "JinDev Comunidad de Desarrollo de Software"

# TIPS
_tr_set en_tip_keep_updated "Keep Jin-TermX updated: ${D_CYAN}jinx update jinx${NC}"
_tr_set es_tip_keep_updated "Mantén Jin-TermX actualizado: ${D_CYAN}jinx update jinx${NC}"
_tr_set en_tip_check_version "Check your version: ${D_CYAN}jinx --version${NC}"
_tr_set es_tip_check_version "Verifica tu versión: ${D_CYAN}jinx --version${NC}"
_tr_set en_tip_enable_debug "Enable debug logs: ${D_CYAN}export JINX_DEBUG=1${NC}"
_tr_set es_tip_enable_debug "Activa logs de depuración: ${D_CYAN}export JINX_DEBUG=1${NC}"
_tr_set en_tip_remember_dir "Shell remembers your last directory - open Termux where you left off"
_tr_set es_tip_remember_dir "La terminal recuerda tu último directorio - abre Termux donde lo dejaste"
_tr_set en_tip_install_all "Install everything at once: ${D_CYAN}jinx install lang db dev npm${NC}"
_tr_set es_tip_install_all "Instala todo de una vez: ${D_CYAN}jinx install lang db dev npm${NC}"
_tr_set en_tip_install_specific "Install only what you need: ${D_CYAN}jinx install ai --opencode --ollama${NC}"
_tr_set es_tip_install_specific "Instala solo lo que necesitas: ${D_CYAN}jinx install ai --opencode --ollama${NC}"
_tr_set en_tip_list_tools "See what's installed: ${D_CYAN}jinx list ai${NC} or ${D_CYAN}jinx list dev${NC}"
_tr_set es_tip_list_tools "Mira lo que tienes instalado: ${D_CYAN}jinx list ai${NC} o ${D_CYAN}jinx list dev${NC}"
_tr_set en_tip_show_tool "Read tool docs: ${D_CYAN}jinx show ai --opencode${NC}"
_tr_set es_tip_show_tool "Lee la documentación: ${D_CYAN}jinx show ai --opencode${NC}"
_tr_set en_tip_update_tool "Update a specific tool: ${D_CYAN}jinx update ai --opencode${NC}"
_tr_set es_tip_update_tool "Actualiza una herramienta específica: ${D_CYAN}jinx update ai --opencode${NC}"
_tr_set en_tip_reinstall "Reinstall from scratch: ${D_CYAN}jinx reinstall shell${NC}"
_tr_set es_tip_reinstall "Reinstala desde cero: ${D_CYAN}jinx reinstall shell${NC}"
_tr_set en_tip_uninstall "Remove a module: ${D_CYAN}jinx uninstall npm${NC}"
_tr_set es_tip_uninstall "Elimina un módulo: ${D_CYAN}jinx uninstall npm${NC}"
_tr_set en_tip_open_docs "Open tool docs in browser: ${D_CYAN}jinx open ai${NC}"
_tr_set es_tip_open_docs "Abre documentación en el navegador: ${D_CYAN}jinx open ai${NC}"
_tr_set en_tip_pg_init "Start PostgreSQL: ${D_CYAN}jinx pg init${NC} then ${D_CYAN}jinx pg start${NC}"
_tr_set es_tip_pg_init "Inicia PostgreSQL: ${D_CYAN}jinx pg init${NC} luego ${D_CYAN}jinx pg start${NC}"
_tr_set en_tip_install_ollama "Run Ollama locally on your phone: ${D_CYAN}jinx install ai --ollama${NC}"
_tr_set es_tip_install_ollama "Ejecuta Ollama localmente en tu celular: ${D_CYAN}jinx install ai --ollama${NC}"
_tr_set en_tip_install_opencode "Install OpenCode: ${D_CYAN}jinx install ai --opencode${NC}"
_tr_set es_tip_install_opencode "Instala OpenCode: ${D_CYAN}jinx install ai --opencode${NC}"
_tr_set en_tip_env_set "Set API keys safely: ${D_CYAN}jinx env set${NC} - input is hidden with ●●●"
_tr_set es_tip_env_set "Guarda API keys de forma segura: ${D_CYAN}jinx env set${NC} - la entrada se oculta con ●●●"
_tr_set en_tip_brain_init "Set up your second brain: ${D_CYAN}jinx brain init${NC}"
_tr_set es_tip_brain_init "Configura tu segundo cerebro: ${D_CYAN}jinx brain init${NC}"
_tr_set en_tip_brain_save "Save memories: ${D_CYAN}jinx brain save${NC}"
_tr_set es_tip_brain_save "Guarda recuerdos: ${D_CYAN}jinx brain save${NC}"
_tr_set en_tip_voice_agent "Voice-to-AI: ${D_CYAN}jinx voice opencode${NC} - speak, edit, launch agent"
_tr_set es_tip_voice_agent "Voz-a-AI: ${D_CYAN}jinx voice opencode${NC} - habla, edita, lanza el agente"
_tr_set en_tip_init_next "Init a Next.js project: ${D_CYAN}cd my-app && jinx init next${NC}"
_tr_set es_tip_init_next "Inicia un proyecto Next.js: ${D_CYAN}cd my-app && jinx init next${NC}"
_tr_set en_tip_init_react "Init a React+Vite project: ${D_CYAN}cd my-app && jinx init react${NC}"
_tr_set es_tip_init_react "Inicia un proyecto React+Vite: ${D_CYAN}cd my-app && jinx init react${NC}"

# ── _tr lookup function ────────────────────────────────────────────
_tr() {
	local key="$1"
	shift
	local lang="${JINX_LANG:-en}"
	# Replace dots with underscores for array key lookup
	local lookup_key="${lang}_${key//./_}"
	local msg
	eval 'msg="${_TR[$lookup_key]}"'
	if [[ -z "$msg" && "$lang" != "en" ]]; then
		lookup_key="en_${key//./_}"
		eval 'msg="${_TR[$lookup_key]}"'
	fi
	msg="${msg:-$key}"
	if [[ $# -gt 0 ]]; then
		printf "$msg" "$@"
	else
		echo -n "$msg"
	fi
}

_tr_echo() {
	_tr "$@"
	echo
}
