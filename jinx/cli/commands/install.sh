#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

install_main() {
  local all_mode=false

  # Detectar flag --all / -a
  for arg in "$@"; do
    if [[ "$arg" == "-a" || "$arg" == "--all" ]]; then
      all_mode=true
      break
    fi
  done

  if [[ $# -eq 0 ]]; then
    echo
    box "Core Install"
    echo
    log_info "Uso: jinx install <target> [opciones]"
    log_info "Uso: jinx install <target> --tool1 --tool2"
    echo
    log_info "Opciones:"
    list_item "${D_CYAN}--all, -a${NC}  - Instalar todo sin interactivo"
    list_item "${D_CYAN}--tool1${NC}    - Instalar herramientas específicas"
    echo
    log_info "Por defecto: muestra checklist interactivo"
    echo
    list_item "lang       - Language packages (Node.js, Python, Perl, PHP, Rust, C, C++, Go)"
    list_item "db         - Bases de datos (PostgreSQL, MariaDB, SQLite, MongoDB)"
    list_item "ai         - Herramientas AI (OpenCode, Gentle AI, Claude Code, etc.)"
    list_item "editor     - Editor de código (Neovim + NvChad)"
    list_item "dev        - Development tools"
    list_item "npm        - Node.js global modules (npm packages)"
    list_item "shell      - ZSH + Oh My Zsh + plugins"
    list_item "ui         - Interfaz Termux (font, cursor, extra-keys, banner)"
    list_item "auto       - Automatización (n8n)"

    echo
    log_info "Instala herramientas específicas con banderas:"
    echo
    list_item "jinx install ai --qwen-code --ollama"
    list_item "jinx install db --postgresql --sqlite"
    list_item "jinx install dev --gh --fzf --jq"
    list_item "Ejecuta ${D_CYAN}jinx list <target>${NC} to see all available tools"
    echo
    return
  fi

  # Separate module target from tool flags
  local module_target=""
  local -a tool_flags=()

  for arg in "$@"; do
    if [[ "$arg" == "--all" || "$arg" == "-a" ]]; then
      continue
    elif [[ "$arg" == --* ]]; then
      # Remove -- prefix and convert to lowercase
      local flag="${arg#--}"
      tool_flags+=("$flag")
    elif [[ -z "$module_target" ]]; then
      module_target="$arg"
    fi
  done

  # If no module target specified, show error
  if [[ -z "$module_target" ]]; then
    log_error "No se especificó objetivo"
    echo "Ejecuta 'jinx install' to see available targets"
    return 1
  fi

  # Modo interactivo por defecto (si no hay flags específicos ni --all)
  if $all_mode; then
    _install_full_module "$module_target"
  elif [[ ${#tool_flags[@]} -gt 0 ]]; then
    # Install specific tools
    _install_specific_tools "$module_target" "${tool_flags[@]}"
  else
    _interactive_install "$module_target"
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
    log_warn "Objetivo de instalación desconocido: $target"
    echo "Ejecuta 'jinx install' to see available targets"
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
      9router)
        install_9router
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown AI tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count AI herramienta(s) instalada(s)"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count herramienta(s) fallaron"
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
        log_warn "Herramienta desconocida: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count herramienta(s) instalada(s)"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count herramienta(s) fallaron"
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
      java)
        install_java
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      kotlin)
        install_kotlin
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
      starship)
        install_starship
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      ble)
        install_ble
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
      log_success "$installed_count automation herramienta(s) instalada(s)"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count herramienta(s) fallaron"
    fi
    echo
    ;;
  *)
    log_warn "Objetivo de instalación desconocido: $module"
    echo "Ejecuta 'jinx install' to see available targets"
    ;;
  esac
}

# ── Instalación interactiva con checklist ──────────────────────────
_interactive_install() {
  local module="$1"
  local -a items=()

  case "$module" in
  ai)
    import "@/tools/ai/all"
    for tool in "${AI_TOOLS[@]}"; do items+=("${tool^}:${tool}"); done
    ;;
  lang)
    import "@/tools/lang/all"
    for tool in "${LANGUAGE_PACKAGES[@]}"; do items+=("${tool^}:${tool}"); done
    ;;
  db)
    items=("PostgreSQL:postgresql" "MariaDB:mariadb" "SQLite:sqlite" "MongoDB:mongodb" "Redis:redis")
    ;;
  dev)
    items=("GitHub CLI:gh" "Wget:wget" "Curl:curl" "LSD:lsd" "Bat:bat" "Proot:proot" "Ncurses:ncurses" "Tmate:tmate" "Tmux:tmux" "OpenSSH:openssh" "Cloudflared:cloudflared" "Translate:translate" "Html2text:html2text" "JQ:jq" "BC:bc" "Tree:tree" "Fzf:fzf" "ImageMagick:imagemagick" "Shfmt:shfmt" "Make:make" "UDocker:udocker")
    ;;
  shell)
    import "@/tools/shell/all"
    for plugin in "${SHELL_PLUGINS[@]}"; do items+=("${plugin^}:${plugin}"); done
    ;;
  npm)
    items=("TypeScript:typescript" "NestJS:nestjs" "Prettier:prettier" "Live Server:live-server" "Localtunnel:localtunnel" "Vercel:vercel" "Markserv:markserv" "PSQL Format:psqlformat" "NCU:ncu" "Ngrok:ngrok" "Turbopack:turbopack")
    ;;
  editor)
    items=("Neovim:neovim" "NvChad:nvchad")
    ;;
  ui)
    items=("Font:font" "Cursor:cursor" "Extra Keys:extra-keys" "Banner:banner")
    ;;
  auto)
    items=("n8n:n8n")
    ;;
  *)
    log_warn "Módulo '$module' no soporta instalación interactiva"
    _install_full_module "$module"
    return
    ;;
  esac

  # Preparar arrays
  local -a display_opts=() flag_map=()
  for item in "${items[@]}"; do
    display_opts+=("${item%%:*}")
    flag_map+=("${item##*:}")
  done

  echo
  read_checklist "Selecciona herramientas a instalar en $module:" raw_selected "${display_opts[@]}"

  if [[ -z "$raw_selected" ]]; then
    log_info "No se seleccionó ninguna herramienta"
    return
  fi

  # Convertir selección a flags
  local -a selected_flags=()
  local IFS=' '; for sel in $raw_selected; do
    for i in "${!display_opts[@]}"; do
      if [[ "${display_opts[$i]}" == "$sel" ]]; then
        selected_flags+=("${flag_map[$i]}")
        break
      fi
    done
  done

  echo
  log_info "Instalando herramientas seleccionadas..."
  _install_specific_tools "$module" "${selected_flags[@]}"
}
