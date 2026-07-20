#!/data/data/com.termux/files/usr/bin/bash

set -e

readonly P_BORDER='\e[38;5;33m'
readonly P_PRIMARY='\e[38;5;39m'
readonly P_DIM='\e[38;5;244m'
readonly P_OK='\e[38;5;42m'
readonly P_FAIL='\e[1;31m'
readonly P_HL='\e[38;5;213m'
readonly P_NC='\e[0m'

REPO="https://github.com/waldnerverges27-collab/jin-termx"
BRANCH="main"
JINX_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/jin-termx"
JINX_TOOL_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/jin-termx-data"
JINX_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/jin-termx"
JINX_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/jin-termx"

TOTAL_STEPS=6
CURRENT_STEP=0

_cols() {
  if command -v tput &>/dev/null; then
    tput cols
  else
    echo 80
  fi
}

progress_bar() {
  local current=$1
  local total=$2
  local width=${3:-40}
  local percentage=$((current * 100 / total))
  local filled=$((current * width / total))
  local empty=$((width - filled))

  printf -v bar "%*s" "$filled" ""
  bar="${bar// /█}"
  printf -v space "%*s" "$empty" ""
  space="${space// /░}"

  printf "\r  ${P_BORDER}│${P_NC}${P_OK}%s${P_NC}${P_DIM}%s${P_NC}${P_BORDER}│${P_NC} ${P_PRIMARY}%3d%%${P_NC}" "${bar}" "${space}" "$percentage"
}

log_step() {
  local step="$1"
  local desc="$2"
  CURRENT_STEP=$((CURRENT_STEP + 1))
  printf "\r%*s\r" "$(_cols)" ""
  echo -e "\n  ${P_BORDER}◆${P_NC}  ${P_PRIMARY}${CURRENT_STEP}/${TOTAL_STEPS}${P_NC}  ${desc}"
}

log_ok() {
  echo -e "  ${P_OK}✔${P_NC}  $1"
}

log_fail() {
  echo -e "  ${P_FAIL}✖${P_NC}  $1" >&2
}

log_info() {
  echo -e "  ${P_BORDER}→${P_NC}  $1"
}

separator() {
  local cols=$(_cols)
  local line=$(printf "%${cols}s")
  echo -e "${P_DIM}${line// /─}${P_NC}"
}

banner() {
  echo
  echo -e "  ${P_BORDER}┌────────────────────────────────────┐${P_NC}"
  echo -e "  ${P_BORDER}│${P_NC}        ${P_PRIMARY}  ◈ JIN-TERMX ◈${P_NC}           ${P_BORDER}│${P_NC}"
  echo -e "  ${P_BORDER}│${P_NC} ${P_DIM}Modular Dev Environment for Termux${P_NC} ${P_BORDER}│${P_NC}"
  echo -e "  ${P_BORDER}└────────────────────────────────────┘${P_NC}"
  echo
}

bootstrap_dependencies() {
  local needed_tput=0
  local needed_git=0
  local needed_glow=0
  local needed_gh=0
  local needed_rg=0
  local needed_jq=0
  local needed_bat=0

  command -v tput &>/dev/null || needed_tput=1
  command -v git &>/dev/null || needed_git=1
  command -v glow &>/dev/null || needed_glow=1
  command -v gh &>/dev/null || needed_gh=1
  command -v rg &>/dev/null || needed_rg=1
  command -v jq &>/dev/null || needed_jq=1
  command -v bat &>/dev/null || needed_bat=1

  if [[ $needed_tput -eq 1 || $needed_git -eq 1 || $needed_glow -eq 1 || $needed_gh -eq 1 || $needed_rg -eq 1 || $needed_jq -eq 1 || $needed_bat -eq 1 ]]; then
    banner
  fi

  if [[ $needed_tput -eq 1 ]]; then
    echo -e "  ${P_BORDER}→${P_NC}  Installing ncurses-utils..."
    yes | pkg install ncurses-utils &>/dev/null
    echo -e "  ${P_OK}✔${P_NC}  ncurses-utils installed"
    echo
  fi

  if [[ $needed_git -eq 1 ]]; then
    log_info "Installing git..."
    progress_bar 0 10
    yes | pkg install git &>/dev/null
    progress_bar 10 10
    echo
    log_ok "git installed"
  fi

  if [[ $needed_glow -eq 1 ]]; then
    log_info "Installing glow..."
    progress_bar 0 10
    yes | pkg install glow &>/dev/null
    progress_bar 10 10
    echo
    log_ok "glow installed"
  fi

  if [[ $needed_gh -eq 1 ]]; then
    log_info "Installing gh (GitHub CLI)..."
    progress_bar 0 10
    yes | pkg install gh &>/dev/null
    progress_bar 10 10
    echo
    log_ok "gh installed"
  fi

  if [[ $needed_rg -eq 1 ]]; then
    log_info "Installing ripgrep..."
    progress_bar 0 10
    yes | pkg install ripgrep &>/dev/null
    progress_bar 10 10
    echo
    log_ok "ripgrep installed"
  fi

  if [[ $needed_jq -eq 1 ]]; then
    log_info "Installing jq..."
    progress_bar 0 10
    yes | pkg install jq &>/dev/null
    progress_bar 10 10
    echo
    log_ok "jq installed"
  fi

  if [[ $needed_bat -eq 1 ]]; then
    log_info "Installing bat..."
    progress_bar 0 10
    yes | pkg install bat &>/dev/null
    progress_bar 10 10
    echo
    log_ok "bat installed"
  fi

  if [[ $needed_tput -eq 1 || $needed_git -eq 1 || $needed_glow -eq 1 || $needed_gh -eq 1 || $needed_rg -eq 1 || $needed_jq -eq 1 || $needed_bat -eq 1 ]]; then
    echo
    clear
  fi
}

install_dependencies() {
  log_step 1 "Verifying dependencies"
  progress_bar 5 10
  progress_bar 10 10
  echo
  log_ok "Dependencies ready (git, ncurses-utils, glow, gh, ripgrep, jq, bat)"
}

setup_directories() {
  log_step 2 "Setting up directories"

  mkdir -p "$JINX_DATA" "$JINX_TOOL_DATA" "$JINX_CACHE" "$JINX_CONFIG"

  log_info "Repo    $JINX_DATA"
  log_info "Data    $JINX_TOOL_DATA"
  log_info "Cache   $JINX_CACHE"
  log_info "Config  $JINX_CONFIG"
  log_ok "Directories created"
}

clone_repo() {
  log_step 3 "Cloning repository"

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local is_dev_install=0

  if [[ -d "$script_dir/.git" ]] && [[ "$script_dir" != "$JINX_DATA" ]]; then
    is_dev_install=1
  fi

  if [[ $is_dev_install -eq 1 ]]; then
    JINX_DATA="$script_dir"
    log_info "Instalación de desarrollador detectada"
    log_ok "Using local repository"
  elif [[ -d "$JINX_DATA/.git" ]]; then
    progress_bar 3 10
    git -C "$JINX_DATA" pull origin "$BRANCH" &>/dev/null
    progress_bar 10 10
    echo
    log_ok "Repository updated"
  else
    if [[ -d "$JINX_DATA" ]]; then
      rm -rf "$JINX_DATA"
    fi
    progress_bar 0 10
    git clone --depth=1 -b "$BRANCH" "$REPO" "$JINX_DATA" &>/dev/null &
    local pid=$!
    while kill -0 "$pid" 2>/dev/null; do
      for i in $(seq 0 10); do
        progress_bar $i 10
        sleep 0.1
      done
    done
    wait "$pid"
    progress_bar 10 10
    echo
    log_ok "Repository cloned"
  fi

  export JINX_DATA
}

create_symlink() {
  log_step 4 "Creating jinx command"

  rm -f "$PREFIX/bin/jinx"
  ln -sf "$JINX_DATA/jinx/bin/jinx" "$PREFIX/bin/jinx"

  if [[ -L "$PREFIX/bin/jinx" ]]; then
    log_ok "Symlink created: jinx → ${JINX_DATA}/jinx/bin/jinx"
  else
    log_fail "Failed to create symlink"
    return 1
  fi
}

save_config() {
  log_step 5 "saving_config"

  cat >"$JINX_CONFIG/config" <<EOF
jinx_data='$JINX_DATA'
jinx_cache='$JINX_CACHE'
jinx_config='$JINX_CONFIG'
jinx_source='$JINX_DATA'
jinx_tool_data='$JINX_TOOL_DATA'
EOF

  log_ok "config_saved"
}

show_final_message() {
  echo
  separator
  echo -e "  ${P_OK}◆${P_NC}  ${P_PRIMARY}complete${P_NC}"
  separator
  echo
  echo -e "  ${P_DIM}run_start${P_NC}  ${P_HL}jinx${P_NC}  ${P_DIM}to_start${P_NC}"
  echo
  echo -e "  ${P_DIM}install_modules${P_NC}"
  echo
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install lang" "lang"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install db" "db"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install ai" "ai"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install editor" "editor"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install dev" "dev"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install npm" "npm"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install shell" "shell"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install ui" "ui"
  printf "    ${P_PRIMARY}%-20s${P_NC} ${P_DIM}%s${P_NC}\n" "jinx install auto" "auto"
  echo
}

main() {
  bootstrap_dependencies
  banner
  install_dependencies
  setup_directories
  clone_repo
  create_symlink
  save_config
  show_final_message
}

main
