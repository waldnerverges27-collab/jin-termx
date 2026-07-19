#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

install_main() {

  if [[ $# -eq 0 ]]; then
    echo
    box "$(_tr "jinx_cli_commands_install.core_install")"
    echo
    log_info "$(_tr "jinx_cli_commands_install.usage_jinx_install_target")"
    log_info "$(_tr "jinx_cli_commands_install.usage_jinx_install_target_tool1_t")"
    echo
    log_info "$(_tr "jinx_cli_commands_install.available_targets")"
    echo
    list_item "$(_tr "jinx_cli_commands_install.lang_language_packages_node_js")"
    list_item "$(_tr "jinx_cli_commands_install.db_databases_postgresql_mari")"
    list_item "$(_tr "jinx_cli_commands_install.ai_ai_tools_opencode_gentle")"
    list_item "$(_tr "jinx_cli_commands_install.editor_code_editor_neovim_nvcha")"
    list_item "$(_tr "jinx_cli_commands_install.dev_development_tools")"
    list_item "$(_tr "jinx_cli_commands_install.npm_node_js_global_modules_npm")"
    list_item "$(_tr "jinx_cli_commands_install.shell_zsh_oh_my_zsh_plugins")"
    list_item "$(_tr "jinx_cli_commands_install.ui_termux_ui_font_cursor_ex")"
    list_item "$(_tr "jinx_cli_commands_install.auto_automation_tools_n8n")"

    echo
    log_info "$(_tr "jinx_cli_commands_install.install_specific_tools_with_flags")"
    echo
    list_item "$(_tr "jinx_cli_commands_install.jinx_install_ai_qwen_code_ollama")"
    list_item "$(_tr "jinx_cli_commands_install.jinx_install_db_postgresql_sqlite")"
    list_item "$(_tr "jinx_cli_commands_install.jinx_install_dev_gh_fzf_jq")"
    list_item "Run ${D_CYAN}jinx list <target>${NC} to see all available tools"
    echo
    return
  fi

  # Separate module target from tool flags
  local module_target=""
  local -a tool_flags=()

  for arg in "$@"; do
    if [[ "$arg" == --* ]]; then
      # Remove -- prefix and convert to lowercase
      local flag="${arg#--}"
      tool_flags+=("$flag")
    elif [[ -z "$module_target" ]]; then
      module_target="$arg"
    fi
  done

  # If no module target specified, show error
  if [[ -z "$module_target" ]]; then
    log_error "$(_tr "jinx_cli_commands_install.no_target_specified")"
    echo "Run 'jinx install' to see available targets"
    return 1
  fi

  # If no tool flags, install entire module (original behavior)
  if [[ ${#tool_flags[@]} -eq 0 ]]; then
    _install_full_module "$module_target"
  else
    # Install specific tools
    _install_specific_tools "$module_target" "${tool_flags[@]}"
  fi
}

# Install entire module (original behavior)
_install_full_module() {
  local target="$1"

  case "$target" in
  db)
    import "@/modules/db"
    install_db
    ;;
  ai)
    import "@/modules/ai"
    install_ai
    ;;
  editor)
    import "@/modules/editor"
    install_editor
    ;;
  lang)
    import "@/modules/lang"
    install_lang
    ;;
  dev)
    import "@/modules/dev"
    install_dev
    ;;
  npm)
    import "@/modules/npm"
    install_npm
    ;;
  shell)
    import "@/modules/shell"
    install_shell
    ;;
  ui)
    import "@/modules/ui"
    setup_ui
    ;;
  auto)
    import "@/modules/auto"
    install_auto
    ;;
  *)
    log_warn "Unknown install target: $target"
    echo "Run 'jinx install' to see available targets"
    ;;
  esac
}

# Install specific tools within a module
_install_specific_tools() {
  local module="$1"
  shift
  local -a tools=("$@")

  case "$module" in
  ai)
    import "@/tools/ai/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      qwen-code)
        install_qwen_code
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      gemini-cli)
        install_gemini_cli
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      claude-code)
        install_claude_code
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      mistral-vibe)
        install_mistral_vibe
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      openclaude)
        install_openclaude
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      openclaw)
        install_openclaw
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ollama)
        install_ollama
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      codex)
        install_codex
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      opencode)
        install_opencode
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      qoder)
        install_qoder
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      kilocode-cli)
        install_kilocode_cli
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      kimchi)
        install_kimchi
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      mimocode)
        install_mimocode
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      engram)
        install_engram
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      codegraph)
        install_codegraph
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      pi)
        install_pi
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      antigravity-cli)
        install_antigravity_cli
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      minimax-cli)
        install_minimax_cli
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      gentle-ai)
        install_gentle_ai
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      gga)
        install_gga
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      hermes-agent)
        install_hermes_agent
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      kimi-code)
        install_kimi_code
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      command-code)
        install_command_code
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      freebuff)
        install_freebuff
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ctx7)
        install_ctx7
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      openspec)
        install_openspec
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown AI tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count AI tool(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count tool(s) failed to install"
    fi
    echo
    ;;
  db)
    import "@/tools/db/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      postgresql)
        install_postgresql
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      mariadb)
        install_mariadb
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      sqlite)
        install_sqlite
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      mongodb)
        install_mongodb
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      redis)
        install_redis
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown database: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count database(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count database(s) failed to install"
    fi
    echo
    ;;
  dev)
    import "@/tools/dev/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      gh)
        install_gh
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      wget)
        install_wget
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      curl)
        install_curl
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      lsd)
        install_lsd
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      bat)
        install_bat
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      proot)
        install_proot
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ncurses)
        install_ncurses
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      tmate)
        install_tmate
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      tmux)
        install_tmux
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      openssh)
        install_openssh
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      cloudflared)
        install_cloudflared
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      translate)
        install_translate
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      html2text)
        install_html2text
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      jq)
        install_jq
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      bc)
        install_bc
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      tree)
        install_tree
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      fzf)
        install_fzf
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      imagemagick)
        install_imagemagick
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      shfmt)
        install_shfmt
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      make)
        install_make
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      udocker)
        install_udocker
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count tool(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count tool(s) failed to install"
    fi
    echo
    ;;
  npm)
    import "@/tools/npm/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      typescript)
        install_typescript
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      nestjs)
        install_nestjs
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      prettier)
        install_prettier
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      live-server)
        install_live_server
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      localtunnel)
        install_localtunnel
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      vercel)
        install_vercel
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      markserv)
        install_markserv
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      psqlformat)
        install_psqlformat
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ncu)
        install_ncu
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ngrok)
        install_ngrok
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      turbopack)
        install_turbopack
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown node module: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count Node.js module(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count module(s) failed to install"
    fi
    echo
    ;;
  lang)
    import "@/tools/lang/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      nodejs)
        install_npmjs
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      python)
        install_python
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      perl)
        install_perl
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      php)
        install_php
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      rust)
        install_rust
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      clang)
        install_clang
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      golang)
        install_golang
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      bun)
        install_bun
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown language: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count language(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count language(s) failed to install"
    fi
    echo
    ;;
  shell)
    import "@/tools/shell/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      powerlevel10k)
        install_powerlevel10k
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      zsh-defer)
        install_zsh_defer
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      zsh-autosuggestions)
        install_zsh_autosuggestions
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      zsh-syntax-highlighting)
        install_zsh_syntax_highlighting
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      history-substring)
        install_history_substring
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      zsh-completions)
        install_zsh_completions
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      fzf-tab)
        install_fzf_tab
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      you-should-use)
        install_you_should_use
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      zsh-autopair)
        install_zsh_autopair
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      better-npm)
        install_better_npm
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown plugin: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count plugin(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count plugin(s) failed to install"
    fi
    echo
    ;;
  editor)
    import "@/tools/editor/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      neovim)
        install_neovim
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      nvchad)
        install_nvchad
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown editor component: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count editor component(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count component(s) failed to install"
    fi
    echo
    ;;
  ui)
    import "@/tools/ui/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      font)
        install_font
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      extra-keys)
        install_extra_keys
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      cursor)
        install_cursor
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      banner)
        install_banner
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown UI component: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count UI component(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count component(s) failed to install"
    fi
    echo
    ;;
  auto)
    import "@/tools/auto/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      n8n)
        install_n8n
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown automation tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count automation tool(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count tool(s) failed to install"
    fi
    echo
    ;;
  *)
    log_warn "Unknown install target: $module"
    echo "Run 'jinx install' to see available targets"
    ;;
  esac
}
