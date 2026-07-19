#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

voice_help() {
	echo
	box "$(_tr "jinx_cli_commands_voice.core_voice_speech_to_agent")"
	echo
	log_info "$(_tr "jinx_cli_commands_voice.capture_voice_from_the_microphone_revie")"
	echo
	log_info "$(_tr "jinx_cli_commands_voice.usage_jinx_voice_agent")"
	echo
	separator_section "$(_tr "jinx_cli_commands_voice.agents")"
	echo
	printf "    ${D_CYAN}%-16s${NC} %s\n" "opencode" "opencode run \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "claude-code" "claude -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "codex" "codex \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "gemini-cli" "gemini -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "hermes-agent" "hermes chat -q \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "kilocode-cli" "kilo run \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "kimi-code" "kimi -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "mimocode" "mimo run \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "mistral-vibe" "vibe --prompt \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "openclaude" "openclaude --bg \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "pi" "pi -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "qoder" "qodercli -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "qwen-code" "qwen -p \"prompt\""
	printf "    ${D_CYAN}%-16s${NC} %s\n" "text" "Print prompt to stdout"
	echo
	separator_section "$(_tr "jinx_cli_commands_voice.examples")"
	echo
	printf "    ${D_CYAN}jinx voice${NC}                   # Show this help\n"
	printf "    ${D_CYAN}jinx voice opencode${NC}          # Capture → nvim → opencode\n"
	printf "    ${D_CYAN}jinx voice qoder${NC}             # Capture → nvim → qoder\n"
	printf "    ${D_CYAN}jinx voice claude-code${NC}        # Capture → nvim → claude -p\n"
	printf "    ${D_CYAN}jinx voice text${NC}               # Capture → nvim → print to stdout\n"
	printf "    ${D_CYAN}jinx voice !${NC}                  # Alias for 'text'\n"
	echo
	separator_section "$(_tr "jinx_cli_commands_voice.requirements")"
	echo
	list_item "Termux:API package: ${D_CYAN}pkg install termux-api${NC}"
	list_item "Neovim for editing: ${D_CYAN}jinx install editor${NC}"
	list_item "Termux:API app: ${D_CYAN}https://f-droid.org/packages/com.termux.api${NC}"
	echo
}

voice_main() {
	local agent="$1"

	if [[ -z "$agent" ]] || [[ "$agent" == "--help" ]] || [[ "$agent" == "-h" ]]; then
		voice_help
		return
	fi

	# ── dependency checks ──
	if ! command -v termux-dialog &>/dev/null; then
		log_error "$(_tr "jinx_cli_commands_voice.termux_api_is_not_installed")"
		list_item "Install the package: ${D_CYAN}pkg install termux-api${NC}"
		list_item "$(_tr "jinx_cli_commands_voice.install_the_app_from_https_f_droid_or")"
		separator
		exit 1
	fi

	if ! command -v nvim &>/dev/null; then
		log_error "$(_tr "jinx_cli_commands_voice.neovim_nvim_is_not_installed")"
		list_item "Install the editor: ${D_CYAN}jinx install editor${NC}"
		separator
		exit 1
	fi

	# ── start Termux API activity ──
	termux-api-start &>/dev/null

	local is_text=false
	[[ "$agent" == "text" || "$agent" == "!" ]] && is_text=true

	# ── capture voice ──
	$is_text || log_info "$(_tr "jinx_cli_commands_voice.listening_through_the_microphone")"
	local raw
	raw="$(termux-dialog speech 2>/dev/null | grep -i "text" | cut -d '"' -f 4)"

	if [[ -z "$raw" ]]; then
		log_error "$(_tr "jinx_cli_commands_voice.no_speech_detected_or_dialog_cancelled")"
		separator
		exit 1
	fi

	# ── edit prompt in nvim (skip if no TTY) ──
	local tmpfile prompt
	tmpfile="$(mktemp)"
	echo "$raw" >"$tmpfile"

	if [[ -t 0 ]] && [[ -t 1 ]]; then
		$is_text || log_info "$(_tr "jinx_cli_commands_voice.review_the_prompt_in_nvim_fix_mistakes")"
		nvim "$tmpfile" </dev/tty >/dev/tty || true
	else
		$is_text || log_warn "$(_tr "jinx_cli_commands_voice.no_tty_available_skipping_editor_usin")"
	fi

	prompt="$(cat "$tmpfile" | xargs)"
	rm -f "$tmpfile"

	if [[ -z "$prompt" ]]; then
		log_error "$(_tr "jinx_cli_commands_voice.prompt_is_empty_after_editing")"
		separator
		exit 1
	fi

	# ── copy to clipboard ──
	if command -v termux-clipboard-set &>/dev/null; then
		echo "$prompt" | termux-clipboard-set
		if [[ "$agent" != "text" && "$agent" != "!" ]]; then
			log_info "$(_tr "jinx_cli_commands_voice.prompt_copied_to_clipboard")"
		fi
	fi

	# ── "text" or "!" → just print ──
	if [[ "$agent" == "text" ]] || [[ "$agent" == "!" ]]; then
		echo "$prompt"
		return
	fi

	# ── dispatch to agent ──
	log_info "Launching ${D_CYAN}$agent${NC} with prompt…"
	echo

	case "$agent" in
	opencode)
		opencode run "$prompt"
		;;
	claude-code)
		claude -p "$prompt"
		;;
	codex)
		codex "$prompt"
		;;
	gemini-cli)
		gemini -p "$prompt"
		;;
	hermes-agent)
		hermes chat -q "$prompt"
		;;
	kilocode-cli)
		kilo run "$prompt"
		;;
	kimi-code)
		kimi -p "$prompt"
		;;
	mimocode)
		mimo run "$prompt"
		;;
	mistral-vibe)
		vibe --prompt "$prompt"
		;;
	openclaude)
		openclaude --bg "$prompt"
		;;
	pi)
		pi -p "$prompt"
		;;
	qoder)
		qodercli -p "$prompt"
		;;
	qwen-code)
		qwen -p "$prompt"
		;;
	*)
		log_error "Unknown agent: $agent"
		echo
		log_info "$(_tr "jinx_cli_commands_voice.supported_agents")"
		echo "  opencode, qoder, claude-code, codex, gemini-cli, hermes-agent,"
		echo "  kilocode-cli, kimi-code, mimocode, mistral-vibe, openclaude, pi, qwen-code"
		separator
		exit 1
		;;
	esac
}
