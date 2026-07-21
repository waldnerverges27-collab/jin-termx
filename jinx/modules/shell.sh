#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

ZSH_PLUGINS_DIR="$HOME/.zsh-plugins"
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
LOG_FILE="$JINX_CACHE/install_shell.log"

install_termux_packages() {
	log_info "Installing dependencies..."

	if pkg install -y zsh lsd bat fzf zoxide &>>"$LOG_FILE"; then
		log_success "Dependencies installed successfully"
		return 0
	else
		log_error "Failed to install dependencies"
		return 1
	fi
}

install_oh_my_zsh() {
	if [[ -d "$OH_MY_ZSH_DIR" ]]; then
		log_warn "Oh My Zsh already installed"
		return 0
	fi

	log_info "Downloading Oh My Zsh..."
	log_info "When prompted, enter (Y/n) to set ZSH as your default shell"
	echo

	local temp_dir="${PREFIX:-/tmp}/tmp"
	mkdir -p "$temp_dir"
	local temp_file="$temp_dir/omz_install.sh"

	if curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o "$temp_file" &>>"$LOG_FILE"; then
		sed -i '/exec zsh -l/s/^/#/' "$temp_file"
		sh "$temp_file" &>>"$LOG_FILE"
		rm "$temp_file"
		log_success "Oh My Zsh installed successfully"
		return 0
	else
		log_error "Failed to download Oh My Zsh"
		return 1
	fi
}

add_to_zshrc() {
	local line="$1"
	if ! grep -qxF "$line" ~/.zshrc 2>/dev/null; then
		echo "$line" >>~/.zshrc
	fi
}

add_to_bashrc() {
	local line="$1"
	if ! grep -qxF "$line" ~/.bashrc 2>/dev/null; then
		echo "$line" >>~/.bashrc
	fi
}

add_to_both_shells() {
	add_to_zshrc "$1"
	add_to_bashrc "$1"
}

setup_shell_aliases() {
	log_info "Configurando alias para ambos shells..."

	local alias_ls='alias ls="lsd"'
	local alias_cat='alias cat="bat --theme=Dracula --style=plain --paging=never"'
	local alias_eb='alias eb="exec bash"'
	local alias_ez='alias ez="exec zsh"'
	local zoxide_zsh='eval "$(zoxide init zsh)"'
	local zoxide_bash='eval "$(zoxide init bash)"'

	add_to_zshrc "$alias_ls"
	add_to_zshrc "$alias_cat"
	add_to_zshrc "$alias_eb"
	add_to_zshrc "$alias_ez"
	add_to_zshrc "$zoxide_zsh"
	add_to_bashrc "$alias_ls"
	add_to_bashrc "$alias_cat"
	add_to_bashrc "$alias_eb"
	add_to_bashrc "$alias_ez"
	add_to_bashrc "$zoxide_bash"

	log_success "Alias activados: eb → exec bash, ez → exec zsh, ls → lsd, cat → bat, zoxide"
}

setup_shell_env() {
	log_info "Configurando variables de entorno para ambos shells..."

	local env_vars=(
		"unalias gga 2>/dev/null"
		"export LC_ALL=C.UTF-8"
		"export LANG=C.UTF-8"
		"export GOPATH=\"\$HOME/.local/go\""
		"export GOCACHE=\"\$HOME/.cache/go\""
		"export GOMODCACHE=\"\$GOPATH/pkg/mod\""
		"export PATH=\$PATH:\$HOME/go/bin:\$HOME/.local/bin"
		"export OPENCLAW_DISABLE_BONJOUR=1"
	)

	for var in "${env_vars[@]}"; do
		add_to_both_shells "$var"
	done

	log_success "Variables de entorno configuradas para ambos shells"
}

setupPersistentSession() {
	log_info "Configurando sesión persistente para ambos shells..."

	mkdir -p "$JINX_CACHE" 2>/dev/null || mkdir -p ~/.cache/jin-termx

	echo "$HOME" > ~/.cache/jin-termx/last_dir

	# ZSH
	if ! grep -q "# ===== Persistent Directory =====" ~/.zshrc 2>/dev/null; then
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
	fi

	# Bash
	if ! grep -q "# ===== Persistent Directory =====" ~/.bashrc 2>/dev/null; then
		cat >>~/.bashrc <<'EOF'

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

restore_dir
trap 'save_dir' EXIT
echo
EOF
	fi

	log_success "Sesión persistente configurada para ZSH y Bash"
}

install_shell() {
	separator
	box "Instalando Entorno Shell"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	loading "Instalando paquetes base" install_termux_packages
	log_success "Paquetes base instalados"
	echo

	install_oh_my_zsh
	echo

	_install_shell_plugins_wrapper
	log_success "Plugins instalados"
	echo

	_setup_ble_for_bash
	echo

	setup_shell_aliases
	echo

	setup_shell_env
	echo

	setupPersistentSession
	echo

	_setup_starship_for_both_shells
	echo

	separator
	log_success "Entorno shell configurado correctamente"
	log_info "Reinicia Termux o ejecuta: ${D_CYAN}exec zsh${NC} (${D_CYAN}ez${NC}) o ${D_CYAN}exec bash${NC} (${D_CYAN}eb${NC})"
	separator
	echo
}

_setup_starship_for_both_shells() {
	if ! command -v starship &>/dev/null; then
		log_warn "Starship no instalado, se salta configuración de prompt"
		return 0
	fi

	# ZSH
	if ! grep -q "starship init zsh" ~/.zshrc 2>/dev/null; then
		echo "" >>~/.zshrc
		echo "# Starship prompt" >>~/.zshrc
		echo 'eval "$(starship init zsh)"' >>~/.zshrc
	fi

	# Bash
	if ! grep -q "starship init bash" ~/.bashrc 2>/dev/null; then
		echo "" >>~/.bashrc
		echo "# Starship prompt" >>~/.bashrc
		echo 'eval "$(starship init bash)"' >>~/.bashrc
	fi

	log_success "Starship configurado para ZSH y Bash"
}

_setup_ble_for_bash() {
	local ble_script
	# Buscar ble.sh en las ubicaciones posibles de instalación
	for path in \
		"${XDG_DATA_HOME:-$HOME/.local/share}/blesh/ble.sh" \
		"${PREFIX:-/data/data/com.termux/files/usr}/share/blesh/ble.sh" \
		"$HOME/.local/share/blesh/out/ble.sh"; do
		if [[ -f "$path" ]]; then
			ble_script="$path"
			break
		fi
	done

	if [[ -n "$ble_script" ]]; then
		if ! grep -q "ble.sh" ~/.bashrc 2>/dev/null; then
			echo "" >>~/.bashrc
			echo "# BLE - Bash Line Editor" >>~/.bashrc
			echo '[[ $- == *i* ]] && source "'"$ble_script"'" --attach=none' >>~/.bashrc
			echo '[[ ${BLE_VERSION-} ]] && ble-attach' >>~/.bashrc
			log_info "BLE configurado en .bashrc ($ble_script)"
		fi
	else
		log_warn "BLE no encontrado. Intentá: find ~ -name ble.sh 2>/dev/null"
	fi
}

_install_shell_plugins_wrapper() {
	import "@/tools/shell/all"
	install_all_shell_plugins

	# Asegurar que Oh My Zsh se cargue al inicio de .zshrc
	if [[ -d "$OH_MY_ZSH_DIR" ]] && ! grep -q "^source.*oh-my-zsh.sh" ~/.zshrc 2>/dev/null; then
		_TMPFILE="${PREFIX:-/data/data/com.termux/files/usr}/tmp/.jinx_zshrc_$$"
		echo 'export ZSH="$HOME/.oh-my-zsh"' > "$_TMPFILE"
		echo 'source $ZSH/oh-my-zsh.sh' >> "$_TMPFILE"
		echo '' >> "$_TMPFILE"
		cat ~/.zshrc >> "$_TMPFILE"
		mv "$_TMPFILE" ~/.zshrc
		log_info "Oh My Zsh agregado a .zshrc"
	fi

	# compinit SIEMPRE al inicio (antes de plugins que usan compdef)
	if ! head -5 ~/.zshrc | grep -q "compinit" 2>/dev/null; then
		if grep -q "^source.*oh-my-zsh.sh" ~/.zshrc 2>/dev/null; then
			sed -i '/^source.*oh-my-zsh\.sh/a\\nautoload -Uz compinit \&\& compinit' ~/.zshrc 2>/dev/null
		else
			_TMPFILE="${PREFIX:-/data/data/com.termux/files/usr}/tmp/.jinx_zshrc_$$"
			echo 'autoload -Uz compinit && compinit' > "$_TMPFILE"
			cat ~/.zshrc >> "$_TMPFILE"
			mv "$_TMPFILE" ~/.zshrc
		fi
		log_info "compinit agregado al inicio de .zshrc"
	fi

	if command -v starship &>/dev/null; then
		log_info "Starship listo como prompt"
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
		log_warn "Oh My Zsh not installed"
		return 0
	fi

	log_info "Uninstalling Oh My Zsh..."

	if rm -rf "$OH_MY_ZSH_DIR" &>>"$LOG_FILE"; then
		log_success "Oh My Zsh uninstalled"
	else
		log_error "Failed to uninstall Oh My Zsh"
		return 1
	fi
}

uninstall_shell() {
	if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
		log_info "El entorno Shell no está instalado"
		return 0
	fi
	separator
	box "Desinstalando Entorno Shell"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_uninstall_shell_plugins_wrapper
	loading "Eliminando Oh My Zsh" uninstall_oh_my_zsh

	echo
	separator
	log_success "Entorno shell desinstalado"
	separator
	echo
}

_uninstall_shell_plugins_wrapper() {
	import "@/tools/shell/all"
	uninstall_all_shell_plugins
}

update_shell() {
	separator
	box "Actualizando Entorno Shell"
	separator
	echo

	mkdir -p "$(dirname "$LOG_FILE")"

	_update_shell_plugins_wrapper
	log_success "Entorno shell actualizado"

	_setup_ble_for_bash
	_setup_starship_for_both_shells
	setup_shell_env
	echo

	separator
	log_success "Actualización de shell completada"
	separator
	echo
}

_update_shell_plugins_wrapper() {
  import "@/tools/shell/all"
  update_all_shell_plugins
  _install_shell_plugins_wrapper
}

reinstall_shell() {
  separator
  box "Reinstalando Entorno Shell"
  separator
  echo

  mkdir -p "$(dirname "$LOG_FILE")"

  _reinstall_shell_plugins_wrapper
  log_success "Plugins reinstalados"
  echo

  _setup_ble_for_bash
  echo

  setup_shell_aliases
  echo

  setup_shell_env
  echo

  setupPersistentSession
  echo

  _setup_starship_for_both_shells
  echo

  separator
  log_success "Reinstalación de shell completada"
  separator
  echo
  log_warn "Reinicia Termux o ejecuta: exec zsh (ez) o exec bash (eb)"
  echo
}

_reinstall_shell_plugins_wrapper() {
  import "@/tools/shell/all"
  reinstall_all_shell_plugins
  # Aplicar configuración de .zshrc (Oh My Zsh, compinit, etc.)
  _install_shell_plugins_wrapper
}
