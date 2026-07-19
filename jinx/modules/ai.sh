#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_ai.log"

install_ai() {
  separator
  box "$(_tr "jinx_modules_ai.installing_ai_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_ai.installing_ai_tools")"
  echo
  log_info "$(_tr "jinx_modules_ai.grab_a_coffee_this_process_typically")"
  log_info "   Don't worry, it's normal for this to take a while..."
  echo

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_ai_tools_wrapper
  log_success "$(_tr "jinx_modules_ai.ai_tools_installed_successfully")"
  separator
  echo
  list_item "Qwen Code ${GRAY}(${D_GREEN}qwen${GRAY})"
  list_item "Gemini CLI ${GRAY}(${D_GREEN}gemini${GRAY})"
  list_item "Mistral Vibe ${GRAY}(${D_GREEN}vibe${GRAY})"
  list_item "OpenClaude ${GRAY}(${D_GREEN}openclaude${GRAY})"
  list_item "Claude Code ${GRAY}(${D_GREEN}claude${GRAY})"
  list_item "OpenClaw ${GRAY}(${D_GREEN}openclaw${GRAY})"
  list_item "Ollama ${GRAY}(${D_GREEN}ollama${GRAY})"
  list_item "Codex ${GRAY}(${D_GREEN}codex${GRAY})"
  list_item "OpenCode ${GRAY}(${D_GREEN}opencode${GRAY})"
  list_item "Qoder ${GRAY}(${D_GREEN}qoder${GRAY})"
  list_item "Kilo Code CLI ${GRAY}(${D_GREEN}kilo${GRAY})"
  list_item "Kimchi ${GRAY}(${D_GREEN}kimchi${GRAY})"
  list_item "MiMoCode ${GRAY}(${D_GREEN}mimocode${GRAY})"
  list_item "Engram ${GRAY}(${D_GREEN}engram${GRAY})"
  list_item "CodeGraph ${GRAY}(${D_GREEN}codegraph${GRAY})"
  list_item "Pi ${GRAY}(${D_GREEN}pi${GRAY})"
  list_item "Antigravity CLI ${GRAY}(${D_GREEN}agy${GRAY})"
  list_item "Minimax CLI ${GRAY}(${D_GREEN}mmx${GRAY})"
  list_item "Gentle AI ${GRAY}(${D_GREEN}gentle-ai${GRAY})"
  list_item "GGA ${GRAY}(${D_GREEN}gga${GRAY})"
  list_item "Hermes Agent ${GRAY}(${D_GREEN}hermes${GRAY})"
  list_item "Kimi Code ${GRAY}(${D_GREEN}kimi${GRAY})"
  list_item "Command Code ${GRAY}(${D_GREEN}cmdc${GRAY})"
  list_item "Freebuff ${GRAY}(${D_GREEN}freebuff${GRAY})"
  list_item "Context7 ${GRAY}(${D_GREEN}ctx7${GRAY})"
  list_item "OpenSpec ${GRAY}(${D_GREEN}openspec${GRAY})"
  echo
}

_install_ai_tools_wrapper() {
  import "@/tools/ai/all"
  install_all_ai_tools
}

uninstall_ai() {
  if ! command -v opencode &>/dev/null && ! command -v freebuff &>/dev/null; then
    log_info "$(_tr "jinx_modules_ai.ai_tools_are_not_installed")"
    return 0
  fi
  separator
  box "$(_tr "jinx_modules_ai.uninstalling_ai_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_ai.uninstalling_ai_tools")"

  _uninstall_ai_tools_wrapper
  log_success "$(_tr "jinx_modules_ai.ai_tools_uninstalled")"
}

_uninstall_ai_tools_wrapper() {
  import "@/tools/ai/all"
  uninstall_all_ai_tools
}

update_ai() {
  separator
  box "$(_tr "jinx_modules_ai.updating_ai_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_ai.updating_ai_tools")"

  _update_ai_tools_wrapper
  log_success "$(_tr "jinx_modules_ai.ai_tools_updated")"
}

_update_ai_tools_wrapper() {
  import "@/tools/ai/all"
  update_all_ai_tools
}

reinstall_ai() {
  separator
  box "$(_tr "jinx_modules_ai.reinstalling_ai_tools")"
  separator
  echo

  log_info "$(_tr "jinx_modules_ai.reinstalling_ai_tools")"
  echo

  _reinstall_ai_tools_wrapper
  log_success "$(_tr "jinx_modules_ai.ai_tools_reinstalled_successfully")"
  separator
  echo
  list_item "$(_tr "jinx_modules_ai.qwen_code")"
  list_item "$(_tr "jinx_modules_ai.gemini_cli")"
  list_item "$(_tr "jinx_modules_ai.mistral_vibe")"
  list_item "$(_tr "jinx_modules_ai.openclaude")"
  list_item "$(_tr "jinx_modules_ai.claude_code")"
  list_item "$(_tr "jinx_modules_ai.openclaw")"
  list_item "$(_tr "jinx_modules_ai.ollama")"
  list_item "$(_tr "jinx_modules_ai.codex")"
  list_item "$(_tr "jinx_modules_ai.opencode")"
  list_item "$(_tr "jinx_modules_ai.qoder")"
  list_item "$(_tr "jinx_modules_ai.kilo_code_cli")"
  list_item "$(_tr "jinx_modules_ai.kimchi")"
  list_item "$(_tr "jinx_modules_ai.mimocode")"
  list_item "$(_tr "jinx_modules_ai.engram")"
  list_item "$(_tr "jinx_modules_ai.codegraph")"
  list_item "Pi"
  list_item "$(_tr "jinx_modules_ai.antigravity_cli")"
  list_item "$(_tr "jinx_modules_ai.minimax_cli")"
  list_item "$(_tr "jinx_modules_ai.gentle_ai")"
  list_item "GGA"
  list_item "$(_tr "jinx_modules_ai.hermes_agent")"
  list_item "$(_tr "jinx_modules_ai.kimi_code")"
  list_item "$(_tr "jinx_modules_ai.command_code")"
  list_item "$(_tr "jinx_modules_ai.freebuff")"
  list_item "$(_tr "jinx_modules_ai.context7")"
  list_item "$(_tr "jinx_modules_ai.openspec")"
  echo
}

_reinstall_ai_tools_wrapper() {
  import "@/tools/ai/all"
  reinstall_all_ai_tools
}
