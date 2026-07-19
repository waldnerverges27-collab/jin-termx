#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

ZSH_PLUGINS_DIR="$HOME/.zsh-plugins"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
LOG_FILE="$JINX_CACHE/install_shell.log"

install_termux_packages() {
	log_info "$(_tr "jinx_modules_shell.installing_dependencies")"

	if yes | pkg install zsh lsd bat fzf zoxide &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_modules_shell.dependencies_installed_successfully")"
		return 0
	else
		log_error "$(_tr "jinx_modules_shell.failed_to_install_dependencies")"
		return 1
	fi
}

install_oh_my_zsh() {
	if [[ -d "$OH_MY_ZSH_DIR" ]]; then
		log_warn "$(_tr "jinx_modules_shell.oh_my_zsh_already_installed")"
		return 0
	fi

	log_info "$(_tr "jinx_modules_shell.downloading_oh_my_zsh")"
	log_info "$(_tr "jinx_modules_shell.when_prompted_enter_y_n_to_set_zsh_as")"
	echo

	local temp_dir="${PREFIX:-/tmp}/tmp"
	mkdir -p "$temp_dir"
	local temp_file="$temp_dir/omz_install.sh"

	if curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o "$temp_file" &>>"$LOG_FILE"; then
		sed -i '/exec zsh -l/s/^/#/' "$temp_file"
		sh "$temp_file" &>>"$LOG_FILE"
		rm "$temp_file"
		log_success "$(_tr "jinx_modules_shell.oh_my_zsh_installed_successfully")"
		return 0
	else
		log_error "$(_tr "jinx_modules_shell.failed_to_download_oh_my_zsh")"
		return 1
	fi
}

add_to_zshrc() {
	local line="$1"
	if ! grep -qxF "$line" ~/.zshrc 2>/dev/null; then
		echo "$line" >>~/.zshrc
	fi
}

setup_zsh_aliases() {
	log_info "$(_tr "jinx_modules_shell.setting_up_zsh_aliases")"

	add_to_zshrc "alias ls=\"lsd\""
	add_to_zshrc 'alias cat="bat --theme=Dracula --style=plain --paging=never"'
	add_to_zshrc 'eval "$(zoxide init zsh)"'

	log_success "$(_tr "jinx_modules_shell.zsh_aliases_configured")"
}

setup_shell_env() {
	log_info "$(_tr "jinx_modules_shell.setting_up_shell_environment")"

	add_to_zshrc "unalias gga 2>/dev/null"
	add_to_zshrc "export GOPATH=\"\$HOME/.local/go\""
	add_to_zshrc "export GOCACHE=\"\$HOME/.cache/go\""
	add_to_zshrc "export GOMODCACHE=\"\$GOPATH/pkg/mod\""
	add_to_zshrc "export PATH=\$PATH:\$HOME/go/bin"
	add_to_zshrc "export OPENCLAW_DISABLE_BONJOUR=1"

	log_success "$(_tr "jinx_modules_shell.shell_environment_configured")"
}

setupPersistentSession() {
	log_info "$(_tr "jinx_modules_shell.configuring_persistent_session")"

	mkdir -p "$JINX_CACHE" 2>/dev/null || mkdir -p ~/.cache/jin-termx

	echo "$HOME" > ~/.cache/jin-termx/last_dir

	if grep -q "# ===== Persistent Directory =====" ~/.zshrc 2>/dev/null; then
		log_warn "$(_tr "jinx_modules_shell.persistent_session_already_configured")"
		return 0
	fi

	cat >>~/.zshrc <<'EOF'

# ===== Persistent Directory =====
LAST_DIR_FILE="$HOME/.cache/jin-termx/last_dir"
SESSION_TIMESTAMP="$HOME/.cache/jin-termx/.session_time"
SESSION_TIMEOUT=5

save_dir() {
  mkdir -p ~/.cache/jin-termx 2>/dev/null
  pwd > "$LAST_DIR_FILE"
  date +%s > "$SESSION_TIMESTAMP"
}

restore_dir() {
  if [[ -f "$SESSION_TIMESTAMP" ]] && [[ -f "$LAST_DIR_FILE" ]]; then
    local current_time
    local last_time
    current_time=$(date +%s)
    last_time=$(cat "$SESSION_TIMESTAMP" 2>/dev/null || echo 0)
    local diff=$((current_time - last_time))

    if [[ $diff -lt $SESSION_TIMEOUT ]]; then
      local dir
      dir=$(cat "$LAST_DIR_FILE" 2>/dev/null)
      if [[ -d "$dir" ]] && [[ "$dir" != "$HOME" ]]; then
        cd "$dir" 2>/dev/null
      fi
    fi
  fi
  date +%s > "$SESSION_TIMESTAMP"
}

if typeset -f add-zsh-hook &>/dev/null; then
  add-zsh-hook precmd save_dir
  restore_dir
else
  restore_dir
  trap 'save_dir' EXIT
fi
echo
EOF

	log_success "$(_tr "jinx_modules_shell.persistent_session_configured")"
	log_info "$(_tr "jinx_modules_shell.new_sessions_within_termux_will_restore")"
}

install_shell() {
	separator
	box "$(_tr "jinx_modules_shell.installing_zsh_shell_environment")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	loading "Installing base packages" install_termux_packages
	log_success "$(_tr "jinx_modules_shell.base_packages_installed")"
	echo

	install_oh_my_zsh
	echo

	_install_shell_plugins_wrapper
	log_success "$(_tr "jinx_modules_shell.zsh_plugins_installed")"
	echo

	setup_zsh_aliases
	echo

	setup_shell_env
	echo

	setupPersistentSession
	echo

	separator
	log_success "$(_tr "jinx_modules_shell.zsh_shell_environment_setup_completed")"
	separator
	echo
	log_warn "$(_tr "jinx_modules_shell.please_restart_termux_or_run_exec_zsh")"
	echo
}

_install_shell_plugins_wrapper() {
	import "@/tools/shell/all"
	install_all_shell_plugins

	if [[ -d "$ZSH_PLUGINS_DIR/powerlevel10k" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/powerlevel10k/powerlevel10k.zsh-theme'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-defer" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-defer/zsh-defer.plugin.zsh'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-history-substring-search" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh'
		add_to_zshrc "bindkey '^[[A' history-substring-search-up"
		add_to_zshrc "bindkey '^[[B' history-substring-search-down"
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-completions" ]]; then
		add_to_zshrc 'fpath+=~/.zsh-plugins/zsh-completions'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/fzf-tab" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh'
		add_to_zshrc "zstyle ':completion:*' menu-select yes"
		add_to_zshrc "zstyle ':fzf-tab:*' switch-word yes"
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-you-should-use" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-you-should-use/you-should-use.plugin.zsh'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-autopair" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-autopair/autopair.zsh'
	fi
	if [[ -d "$ZSH_PLUGINS_DIR/zsh-better-npm-completion" ]]; then
		add_to_zshrc 'source ~/.zsh-plugins/zsh-better-npm-completion/zsh-better-npm-completion.plugin.zsh'
	fi
}

uninstall_oh_my_zsh() {
	if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
		log_warn "$(_tr "jinx_modules_shell.oh_my_zsh_not_installed")"
		return 0
	fi

	log_info "$(_tr "jinx_modules_shell.uninstalling_oh_my_zsh")"

	if rm -rf "$OH_MY_ZSH_DIR" &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_modules_shell.oh_my_zsh_uninstalled")"
	else
		log_error "$(_tr "jinx_modules_shell.failed_to_uninstall_oh_my_zsh")"
		return 1
	fi
}

uninstall_shell() {
	if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
		log_info "$(_tr "jinx_modules_shell.zsh_shell_environment_is_not_installed")"
		return 0
	fi
	separator
	box "$(_tr "jinx_modules_shell.uninstalling_zsh_shell_environment")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_shell_plugins_wrapper
	loading "Removing Oh My Zsh" uninstall_oh_my_zsh

	echo
	separator
	log_success "$(_tr "jinx_modules_shell.zsh_shell_environment_uninstalled")"
	separator
	echo
}

_uninstall_shell_plugins_wrapper() {
	import "@/tools/shell/all"
	uninstall_all_shell_plugins
}

update_shell() {
	separator
	box "$(_tr "jinx_modules_shell.updating_zsh_shell_environment")"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_update_shell_plugins_wrapper
	log_success "$(_tr "jinx_modules_shell.zsh_shell_environment_updated")"

	setup_shell_env
	echo

	separator
	log_success "$(_tr "jinx_modules_shell.zsh_update_completed")"
	separator
	echo
}

_update_shell_plugins_wrapper() {
  import "@/tools/shell/all"
  update_all_shell_plugins
}

reinstall_shell() {
  separator
  box "$(_tr "jinx_modules_shell.reinstalling_zsh_shell_environment")"
  separator
  echo

  mkdir -p "$(dirname "$LOG_FILE")"

  _reinstall_shell_plugins_wrapper
  log_success "$(_tr "jinx_modules_shell.zsh_plugins_reinstalled")"
  echo

  setup_zsh_aliases
  echo

  setup_shell_env
  echo

  setupPersistentSession
  echo

  separator
  log_success "$(_tr "jinx_modules_shell.zsh_shell_environment_reinstallation_com")"
  separator
  echo
  log_warn "$(_tr "jinx_modules_shell.please_restart_termux_or_run_exec_zsh")"
  echo
}

_reinstall_shell_plugins_wrapper() {
  import "@/tools/shell/all"
  reinstall_all_shell_plugins
}
