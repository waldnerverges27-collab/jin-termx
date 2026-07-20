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
	printf " ${GRAY}JinDev Comunidad de Desarrollo de Software${NC}\n"
	printf "     ${NC}Bienvenido a Jin-TermX ${DGREEN}v%s${NC}\n" "$BANNER_VERSION"
	printf "        ${NC}Ejecuta ${DGREEN}jinx${NC} para empezar${NC}\n"
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
