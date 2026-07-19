#!/data/data/com.termux/files/usr/bin/bash

BANNER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
BANNER_FILE="$(cd "$BANNER_SCRIPT_DIR/../.." && pwd)/assets/banner/devcorex.txt"
BANNER_VERSION="$(grep "^JINX_VERSION=" "$BANNER_SCRIPT_DIR/env.sh" 2>/dev/null | cut -d'"' -f2)"

# ── Colors (self-contained for shell startup sourcing) ─────
DGREEN="\033[0;32m"
NC="\033[0m"
GRAY="\033[0;90m"
D_CYAN="\033[0;36m"

# ── Reusable tip function (matches log.sh style) ───────────
log_tip() {
	echo -e " ${D_CYAN}● Tip${NC} $*"
}

if [[ -f "$BANNER_FILE" ]]; then
	cat "$BANNER_FILE"
fi

if [[ -n "$BANNER_VERSION" ]]; then
	printf "\n"
	printf " ${GRAY}$(_tr "banner.community")${NC}\n"
	printf "     ${NC}$(_tr "banner.welcome" "$BANNER_VERSION")${NC}\n"
	printf "        ${NC}$(_tr "banner.run_start")${NC}\n"
fi

# ── Random Tip ──────────────────────────────────────────────

# Tips are stored as translation keys (see translations.sh)
JINX_TIP_KEYS=(
	"tip.keep_updated"
	"tip.check_version"
	"tip.enable_debug"
	"tip.remember_dir"
	"tip.install_all"
	"tip.install_specific"
	"tip.list_tools"
	"tip.show_tool"
	"tip.update_tool"
	"tip.update_module"
	"tip.reinstall"
	"tip.uninstall"
	"tip.open_docs"
	"tip.install_lang_all"
	"tip.install_python"
	"tip.install_rust"
	"tip.install_go"
	"tip.install_bun"
	"tip.install_php"
	"tip.install_perl"
	"tip.install_clang"
	"tip.install_nodejs"
	"tip.install_db_all"
	"tip.pg_init"
	"tip.pg_shell"
	"tip.pg_create"
	"tip.pg_status"
	"tip.pg_list"
	"tip.pg_stop"
	"tip.install_mariadb"
	"tip.install_sqlite"
	"tip.install_mongodb"
	"tip.install_ai_all"
	"tip.install_ollama"
	"tip.install_opencode"
	"tip.install_qoder"
	"tip.install_claude"
	"tip.install_codex"
	"tip.install_gemini"
	"tip.install_mimocode"
	"tip.env_set"
	"tip.env_ls"
	"tip.brain_init"
	"tip.brain_save"
	"tip.brain_search"
	"tip.brain_ls"
	"tip.brain_edit"
	"tip.voice_agent"
	"tip.voice_text"
	"tip.init_next"
	"tip.init_react"
	"tip.init_express"
	"tip.init_nest"
)

_tip_index_file="${XDG_CACHE_HOME:-$HOME/.cache}/jin-termx/.last_tip_index"

if [[ ${#JINX_TIP_KEYS[@]} -gt 0 ]]; then
	last_index=-1
	if [[ -f "$_tip_index_file" ]]; then
		last_index=$(cat "$_tip_index_file" 2>/dev/null || echo "-1")
	fi

	new_index=$last_index
	while [[ "$new_index" == "$last_index" ]]; do
		new_index=$(( RANDOM % ${#JINX_TIP_KEYS[@]} ))
	done

	echo "$new_index" >"$_tip_index_file"

	_tip_key="${JINX_TIP_KEYS[$new_index]:-}"
	if [[ -n "$_tip_key" ]]; then
		echo
		log_tip "$(_tr "$_tip_key")"
	fi
fi

echo
