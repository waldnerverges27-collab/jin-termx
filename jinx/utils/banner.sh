#!/data/data/com.termux/files/usr/bin/bash

BANNER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
BANNER_FILE="$(cd "$BANNER_SCRIPT_DIR/../.." && pwd)/assets/banner/devcorex.txt"
BANNER_VERSION="$(grep "^JINX_VERSION=" "$BANNER_SCRIPT_DIR/env.sh" 2>/dev/null | cut -d'"' -f2)"

# ── Self-contained translation for banner (avoids dependency on _tr) ──
__BANNER_LANG="en"
__BANNER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/jin-termx/config"
if [[ -f "$__BANNER_CONFIG" ]]; then
	__lang_val=$(grep "^jinx_lang=" "$__BANNER_CONFIG" 2>/dev/null | cut -d"'" -f2)
	[[ -n "$__lang_val" ]] && __BANNER_LANG="$__lang_val"
fi

__banner_tr() {
	local key="$1"
	shift
	case "${__BANNER_LANG}:${key}" in
		es:banner.community)  msg="JinDev Comunidad de Desarrollo de Software" ;;
		es:banner.welcome)    msg="Bienvenido a Jin-TermX v%s" ;;
		es:banner.run_start)  msg="Ejecuta ${DGREEN}jinx${NC} para empezar" ;;
		*)                    msg="JinDev Software Development Community" ;;
	esac
	if [[ "$key" == "banner.welcome" && "$__BANNER_LANG" != "es" ]]; then
		msg="Welcome to Jin-TermX v%s"
	fi
	if [[ "$key" == "banner.run_start" && "$__BANNER_LANG" != "es" ]]; then
		msg="Run ${DGREEN}jinx${NC} to get started"
	fi
	if [[ $# -gt 0 ]]; then
		printf "$msg" "$@"
	else
		echo -n "$msg"
	fi
}
unset __lang_val

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
	printf " ${GRAY}$(__banner_tr "banner.community")${NC}\n"
	printf "     ${NC}$(__banner_tr "banner.welcome" "$BANNER_VERSION")${NC}\n"
	printf "        ${NC}$(__banner_tr "banner.run_start")${NC}\n"
fi

# ── Random Tip ──────────────────────────────────────────────

JINX_TIPS=(
	"Keep Jin-TermX updated: ${D_CYAN}jinx update jinx${NC}"
	"Check your version: ${D_CYAN}jinx --version${NC}"
	"Enable debug logs: ${D_CYAN}export JINX_DEBUG=1${NC}"
	"Install everything at once: ${D_CYAN}jinx install lang db dev npm${NC}"
	"See what's installed: ${D_CYAN}jinx list ai${NC} or ${D_CYAN}jinx list dev${NC}"
	"Update a specific tool: ${D_CYAN}jinx update ai --opencode${NC}"
	"Reinstall from scratch: ${D_CYAN}jinx reinstall shell${NC}"
	"Install all languages: ${D_CYAN}jinx install lang${NC}"
	"Install Python: ${D_CYAN}jinx install lang --python${NC}"
	"Install all databases: ${D_CYAN}jinx install db${NC}"
	"Start PostgreSQL: ${D_CYAN}jinx pg init${NC} then ${D_CYAN}jinx pg start${NC}"
	"Install all AI agents: ${D_CYAN}jinx install ai${NC}"
	"Run Ollama locally on your phone: ${D_CYAN}jinx install ai --ollama${NC}"
	"Set API keys safely: ${D_CYAN}jinx env set${NC} — input is hidden with ●●●"
	"Set up your second brain: ${D_CYAN}jinx brain init${NC}"
	"Voice-to-AI: ${D_CYAN}jinx voice opencode${NC} — speak, edit, launch agent"
)

_tip_index_file="${XDG_CACHE_HOME:-$HOME/.cache}/jin-termx/.last_tip_index"

if [[ ${#JINX_TIPS[@]} -gt 0 ]]; then
	last_index=-1
	if [[ -f "$_tip_index_file" ]]; then
		last_index=$(cat "$_tip_index_file" 2>/dev/null || echo "-1")
	fi

	new_index=$last_index
	while [[ "$new_index" == "$last_index" ]]; do
		new_index=$(( RANDOM % ${#JINX_TIPS[@]} ))
	done

	echo "$new_index" >"$_tip_index_file"

	_tip="${JINX_TIPS[$new_index]:-}"
	if [[ -n "$_tip" ]]; then
		echo
		log_tip "$_tip"
	fi
fi

echo
