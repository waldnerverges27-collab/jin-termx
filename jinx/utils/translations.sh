#!/data/data/com.termux/files/usr/bin/bash
# Language / Translation system for Jin-TermX
# Supports: en (English), es (Spanish)
# Usage: _tr "key" [args...]   → prints translated string with %s replaced by args

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

# ===== INSTALL =====
_TR["en.install.title"]="◈ JIN-TERMX ◈"
_TR["es.install.title"]="◈ JIN-TERMX ◈"
_TR["en.install.saving_config"]="Saving configuration"
_TR["es.install.saving_config"]="Guardando configuración"
_TR["en.install.config_saved"]="Configuration saved"
_TR["es.install.config_saved"]="Configuración guardada"
_TR["en.install.complete"]="Installation Complete"
_TR["es.install.complete"]="Instalación Completa"
_TR["en.install.run_start"]="Run"
_TR["es.install.run_start"]="Ejecuta"
_TR["en.install.to_start"]="to get started"
_TR["es.install.to_start"]="para empezar"
_TR["en.install.install_modules"]="Install modules:"
_TR["es.install.install_modules"]="Instala módulos:"

# ===== BOOTSTRAP =====
_TR["en.bootstrap.import_error"]="jinx: import error: %s not found"
_TR["es.bootstrap.import_error"]="jinx: error de importación: %s no encontrado"

# ===== CLI HELP =====
_TR["en.cli.usage"]="Usage: jinx <command> [options]"
_TR["es.cli.usage"]="Uso: jinx <comando> [opciones]"
_TR["en.cli.available"]="Available Commands"
_TR["es.cli.available"]="Comandos Disponibles"
_TR["en.cli.show_version"]="Show current version"
_TR["es.cli.show_version"]="Muestra la versión actual"
_TR["en.cli.cmd_brain"]="Second brain - save and search memories"
_TR["es.cli.cmd_brain"]="Segundo cerebro - guarda y busca recuerdos"
_TR["en.cli.cmd_env"]="Manage environment variables"
_TR["es.cli.cmd_env"]="Gestiona variables de entorno"
_TR["en.cli.cmd_install"]="Install modules and packages"
_TR["es.cli.cmd_install"]="Instala modulos y paquetes"
_TR["en.cli.cmd_show"]="Show tool documentation"
_TR["es.cli.cmd_show"]="Muestra documentacion de herramientas"
_TR["en.cli.cmd_update"]="Update modules or framework"
_TR["es.cli.cmd_update"]="Actualiza modulos o el framework"
_TR["en.cli.cmd_uninstall"]="Remove installed modules"
_TR["es.cli.cmd_uninstall"]="Elimina modulos instalados"
_TR["en.cli.cmd_reinstall"]="Uninstall + install modules"
_TR["es.cli.cmd_reinstall"]="Desinstala e instala modulos"
_TR["en.cli.cmd_open"]="Open documentation in browser"
_TR["es.cli.cmd_open"]="Abre documentacion en el navegador"
_TR["en.cli.cmd_list"]="List available tools in modules"
_TR["es.cli.cmd_list"]="Lista herramientas disponibles en modulos"
_TR["en.cli.cmd_pg"]="PostgreSQL database manager"
_TR["es.cli.cmd_pg"]="Gestor de base de datos PostgreSQL"
_TR["en.cli.cmd_init"]="Configure existing projects"
_TR["es.cli.cmd_init"]="Configura proyectos existentes"
_TR["en.cli.cmd_voice"]="Speech-to-agent via microphone"
_TR["es.cli.cmd_voice"]="Voz-a-agente mediante microfono"
_TR["en.cli.quick_start"]="Quick Start"
_TR["es.cli.quick_start"]="Inicio Rapido"
_TR["en.cli.run_cmd"]="Run: ${D_CYAN}jinx${NC} to see available commands"
_TR["es.cli.run_cmd"]="Ejecuta: ${D_CYAN}jinx${NC} para ver comandos disponibles"
_TR["en.cli.run_open"]="Run: ${D_CYAN}jinx open${NC} for official documentation"
_TR["es.cli.run_open"]="Ejecuta: ${D_CYAN}jinx open${NC} para documentacion oficial"
_TR["en.cli.run_install"]="Run: ${D_CYAN}jinx install <module>${NC} to install modules"
_TR["es.cli.run_install"]="Ejecuta: ${D_CYAN}jinx install <modulo>${NC} para instalar modulos"
_TR["en.cli.module_targets"]="Module Targets"
_TR["es.cli.module_targets"]="Modulos Disponibles"
_TR["en.cli.mod_help"]="Install, update, reinstall, uninstall, list, show or open:"
_TR["es.cli.mod_help"]="Instala, actualiza, reinstala, desinstala, lista, muestra o abre:"
_TR["en.cli.help_title"]="Help"
_TR["es.cli.help_title"]="Ayuda"
_TR["en.cli.run_help"]="Run ${D_CYAN}jinx <command>${NC} for command-specific help"
_TR["es.cli.run_help"]="Ejecuta ${D_CYAN}jinx <comando>${NC} para ayuda especifica"
_TR["en.cli.example"]="Example: ${D_CYAN}jinx pg${NC}, ${D_CYAN}jinx init${NC}"
_TR["es.cli.example"]="Ejemplo: ${D_CYAN}jinx pg${NC}, ${D_CYAN}jinx init${NC}"
_TR["en.cli.docs"]="Docs: ${D_CYAN}glow README.md${NC} or ${D_CYAN}jinx <command> --help${NC}"
_TR["es.cli.docs"]="Docs: ${D_CYAN}glow README.md${NC} o ${D_CYAN}jinx <comando> --help${NC}"
_TR["en.cli.cmd_not_found"]="Command not found: %s"
_TR["es.cli.cmd_not_found"]="Comando no encontrado: %s"

# ===== UPDATES =====
_TR["en.update.available"]="Update Available"
_TR["es.update.available"]="Actualizacion Disponible"
_TR["en.update.new_version"]="New version available: %s (current: %s)"
_TR["es.update.new_version"]="Nueva version disponible: %s (actual: %s)"
_TR["en.update.run_update"]="Run: ${D_CYAN}jinx update jinx${D_NC} to update"
_TR["es.update.run_update"]="Ejecuta: ${D_CYAN}jinx update jinx${D_NC} para actualizar"

# ===== MODULE DESCRIPTIONS =====
_TR["en.module.lang"]="Node, Bun, Python, Rust, C/C++, Go, etc."
_TR["es.module.lang"]="Node, Bun, Python, Rust, C/C++, Go, etc."
_TR["en.module.db"]="PostgreSQL, MongoDB, SQLite, Redis, etc."
_TR["es.module.db"]="PostgreSQL, MongoDB, SQLite, Redis, etc."
_TR["en.module.ai"]="OpenCode, Gentle AI, Claude Code, etc."
_TR["es.module.ai"]="OpenCode, Gentle AI, Claude Code, etc."
_TR["en.module.editor"]="Neovim + NvChad + Plugins"
_TR["es.module.editor"]="Neovim + NvChad + Plugins"
_TR["en.module.dev"]="GitHub CLI, wget, curl, fzf, etc."
_TR["es.module.dev"]="GitHub CLI, wget, curl, fzf, etc."
_TR["en.module.npm"]="Vercel, Live Server, NCU, etc."
_TR["es.module.npm"]="Vercel, Live Server, NCU, etc."
_TR["en.module.shell"]="ZSH + Oh My Zsh + 10 plugins"
_TR["es.module.shell"]="ZSH + Oh My Zsh + 10 plugins"
_TR["en.module.ui"]="Font, Cursor, Extra-keys, Banner"
_TR["es.module.ui"]="Letra, Cursor, Teclas extra, Banner"
_TR["en.module.auto"]="Automation Tools (n8n)"
_TR["es.module.auto"]="Herramientas de Automatizacion (n8n)"

# ===== COMMAND HELP TITLES =====
_TR["en.cmd_open.info"]="Documentation is available locally in the Jin-TermX repository."
_TR["es.cmd_open.info"]="La documentacion esta disponible localmente en el repositorio Jin-TermX."
_TR["en.cmd_open.help_hint"]="Run ${D_CYAN}jinx <command> --help${NC} for command-specific help"
_TR["es.cmd_open.help_hint"]="Ejecuta ${D_CYAN}jinx <comando> --help${NC} para ayuda especifica"
_TR["en.cmd_open.read_hint"]="Read the README: ${D_CYAN}glow README.md${NC} (or ${D_CYAN}bat README.md${NC})"
_TR["es.cmd_open.read_hint"]="Lee el README: ${D_CYAN}glow README.md${NC} (o ${D_CYAN}bat README.md${NC})"
_TR["en.cmd_update.jinx"]="jinx       - Update only Jin-TermX framework"
_TR["es.cmd_update.jinx"]="jinx       - Actualiza solo el framework Jin-TermX"

# ===== BANNER / TIPS =====
_TR["en.banner.welcome"]="Welcome to Jin-TermX v%s"
_TR["es.banner.welcome"]="Bienvenido a Jin-TermX v%s"
_TR["en.banner.run_start"]="Run ${DGREEN}jinx${NC} to get started"
_TR["es.banner.run_start"]="Ejecuta ${DGREEN}jinx${NC} para empezar"
_TR["en.banner.community"]="JinDev Software Development Community"
_TR["es.banner.community"]="JinDev Comunidad de Desarrollo de Software"

# ===== TIPS =====
_TR["en.tip.keep_updated"]="Keep Jin-TermX updated: ${D_CYAN}jinx update jinx${NC}"
_TR["es.tip.keep_updated"]="Manten Jin-TermX actualizado: ${D_CYAN}jinx update jinx${NC}"
_TR["en.tip.check_version"]="Check your version: ${D_CYAN}jinx --version${NC}"
_TR["es.tip.check_version"]="Verifica tu version: ${D_CYAN}jinx --version${NC}"
_TR["en.tip.enable_debug"]="Enable debug logs: ${D_CYAN}export JINX_DEBUG=1${NC}"
_TR["es.tip.enable_debug"]="Activa logs de depuracion: ${D_CYAN}export JINX_DEBUG=1${NC}"
_TR["en.tip.remember_dir"]="Shell remembers your last directory - open Termux where you left off"
_TR["es.tip.remember_dir"]="La terminal recuerda tu ultimo directorio - abre Termux donde lo dejaste"
_TR["en.tip.install_all"]="Install everything at once: ${D_CYAN}jinx install lang db dev npm${NC}"
_TR["es.tip.install_all"]="Instala todo de una vez: ${D_CYAN}jinx install lang db dev npm${NC}"
_TR["en.tip.install_specific"]="Install only what you need: ${D_CYAN}jinx install ai --opencode --ollama${NC}"
_TR["es.tip.install_specific"]="Instala solo lo que necesitas: ${D_CYAN}jinx install ai --opencode --ollama${NC}"
_TR["en.tip.list_tools"]="See what's installed: ${D_CYAN}jinx list ai${NC} or ${D_CYAN}jinx list dev${NC}"
_TR["es.tip.list_tools"]="Mira lo que tienes instalado: ${D_CYAN}jinx list ai${NC} o ${D_CYAN}jinx list dev${NC}"
_TR["en.tip.show_tool"]="Read tool docs: ${D_CYAN}jinx show ai --opencode${NC}"
_TR["es.tip.show_tool"]="Lee la documentacion: ${D_CYAN}jinx show ai --opencode${NC}"
_TR["en.tip.update_tool"]="Update a specific tool: ${D_CYAN}jinx update ai --opencode${NC}"
_TR["es.tip.update_tool"]="Actualiza una herramienta especifica: ${D_CYAN}jinx update ai --opencode${NC}"
_TR["en.tip.reinstall"]="Reinstall from scratch: ${D_CYAN}jinx reinstall shell${NC}"
_TR["es.tip.reinstall"]="Reinstala desde cero: ${D_CYAN}jinx reinstall shell${NC}"
_TR["en.tip.uninstall"]="Remove a module: ${D_CYAN}jinx uninstall npm${NC}"
_TR["es.tip.uninstall"]="Elimina un modulo: ${D_CYAN}jinx uninstall npm${NC}"
_TR["en.tip.open_docs"]="Open tool docs in browser: ${D_CYAN}jinx open ai${NC}"
_TR["es.tip.open_docs"]="Abre documentacion en el navegador: ${D_CYAN}jinx open ai${NC}"
_TR["en.tip.pg_init"]="Start PostgreSQL: ${D_CYAN}jinx pg init${NC} then ${D_CYAN}jinx pg start${NC}"
_TR["es.tip.pg_init"]="Inicia PostgreSQL: ${D_CYAN}jinx pg init${NC} luego ${D_CYAN}jinx pg start${NC}"
_TR["en.tip.install_ollama"]="Run Ollama locally on your phone: ${D_CYAN}jinx install ai --ollama${NC}"
_TR["es.tip.install_ollama"]="Ejecuta Ollama localmente en tu celular: ${D_CYAN}jinx install ai --ollama${NC}"
_TR["en.tip.install_opencode"]="Install OpenCode: ${D_CYAN}jinx install ai --opencode${NC}"
_TR["es.tip.install_opencode"]="Instala OpenCode: ${D_CYAN}jinx install ai --opencode${NC}"
_TR["en.tip.env_set"]="Set API keys safely: ${D_CYAN}jinx env set${NC} - input is hidden with ●●●"
_TR["es.tip.env_set"]="Guarda API keys de forma segura: ${D_CYAN}jinx env set${NC} - la entrada se oculta con ●●●"
_TR["en.tip.brain_init"]="Set up your second brain: ${D_CYAN}jinx brain init${NC}"
_TR["es.tip.brain_init"]="Configura tu segundo cerebro: ${D_CYAN}jinx brain init${NC}"
_TR["en.tip.brain_save"]="Save memories: ${D_CYAN}jinx brain save${NC}"
_TR["es.tip.brain_save"]="Guarda recuerdos: ${D_CYAN}jinx brain save${NC}"
_TR["en.tip.voice_agent"]="Voice-to-AI: ${D_CYAN}jinx voice opencode${NC} - speak, edit, launch agent"
_TR["es.tip.voice_agent"]="Voz-a-AI: ${D_CYAN}jinx voice opencode${NC} - habla, edita, lanza el agente"
_TR["en.tip.init_next"]="Init a Next.js project: ${D_CYAN}cd my-app && jinx init next${NC}"
_TR["es.tip.init_next"]="Inicia un proyecto Next.js: ${D_CYAN}cd my-app && jinx init next${NC}"
_TR["en.tip.init_react"]="Init a React+Vite project: ${D_CYAN}cd my-app && jinx init react${NC}"
_TR["es.tip.init_react"]="Inicia un proyecto React+Vite: ${D_CYAN}cd my-app && jinx init react${NC}"

# ===== TIP KEYS =====
JINX_TIP_KEYS=(
	"tip.keep_updated" "tip.check_version" "tip.enable_debug" "tip.remember_dir"
	"tip.install_all" "tip.install_specific" "tip.list_tools" "tip.show_tool"
	"tip.update_tool" "tip.reinstall" "tip.uninstall" "tip.open_docs"
	"tip.pg_init" "tip.install_ollama" "tip.install_opencode"
	"tip.env_set" "tip.brain_init" "tip.brain_save"
	"tip.voice_agent" "tip.init_next" "tip.init_react"
)

# ── _tr function ───────────────────────────────────────────────────
_tr() {
	local key="$1"
	shift
	local lang="${JINX_LANG:-en}"
	local msg=""

	# Safe lookup using eval to avoid arithmetic evaluation of dotted keys
	eval "msg=\"\${_TR[${lang}.${key}]}\""
	if [[ -z "$msg" && "$lang" != "en" ]]; then
		eval "msg=\"\${_TR[en.${key}]}\""
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
