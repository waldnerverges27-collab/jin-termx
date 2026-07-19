#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

show_main() {
	if [[ $# -eq 0 ]]; then
		echo
		box "$(_tr "jinx_cli_commands_show.core_show")"
		echo
		log_info "$(_tr "jinx_cli_commands_show.usage_jinx_show_module_tool")"
		echo
		log_info "$(_tr "jinx_cli_commands_show.display_help_information_for_a_specific")"
		echo
		log_info "$(_tr "jinx_cli_commands_show.available_targets")"
		echo
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_ai_opencode")"
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_ai_ollama")"
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_db_postgresql")"
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_dev_gh")"
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_npm_typescript")"
		list_item "$(_tr "jinx_cli_commands_show.jinx_show_all_tool")"
		echo
		log_info "Run ${D_CYAN}jinx list <module>${NC} to see available tools"
		echo
		return
	fi

	local module=""
	local tool=""

	for arg in "$@"; do
		if [[ "$arg" == --* ]]; then
			tool="${arg#--}"
		elif [[ -z "$module" ]]; then
			module="$arg"
		fi
	done

	if [[ -z "$module" ]]; then
		log_error "$(_tr "jinx_cli_commands_show.usage_jinx_show_module_tool")"
		return 1
	fi

	if [[ -z "$tool" ]]; then
		separator_section "$module - Available Tools"
		echo
		local tool_dir="$JINX_PATH/tools/$module"
		if [[ ! -d "$tool_dir" ]]; then
			log_error "Unknown module: $module"
			return 1
		fi
		for t in "$tool_dir"/*/; do
			local name="${t%/}"
			name="${name##*/}"
			if [[ -f "$tool_dir/$name/README.md" ]]; then
				local first_line
				first_line=$(head -1 "$tool_dir/$name/README.md" 2>/dev/null)
				printf "    ${D_CYAN}%-16s${NC} %s\n" "$name" "${first_line#\# }"
			fi
		done
		echo
		log_info "Run ${D_CYAN}jinx show $module --<tool>${NC} for details"
		echo
		return
	fi

	local readme_path="$JINX_PATH/tools/$module/$tool/README.md"

	if [[ ! -f "$readme_path" ]]; then
		log_error "No documentation found for $module/$tool"
		return 1
	fi

	separator_section "$tool ($module)"

	if command -v glow &>/dev/null; then
		glow "$readme_path"
	elif command -v pygmentize &>/dev/null; then
		pygmentize -l markdown "$readme_path" 2>/dev/null | less -R
	else
		log_info "Showing documentation for $module/$tool:"
		echo
		cat "$readme_path"
	fi

	echo
	separator
	echo
}
