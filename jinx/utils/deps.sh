#!/data/data/com.termux/files/usr/bin/bash
# Dependency checker and installer — shared utility for all tools
# Usage: _ensure_deps pkg1:cmd1 pkg2:cmd2 ...

LOG_FILE="${LOG_FILE:-$JINX_CACHE/deps.log}"

_ensure_deps() {
	local dep entry pkg cmd missing=()
	
	for entry in "$@"; do
		pkg="${entry%%:*}"
		cmd="${entry##*:}"
		[[ "$pkg" == "$cmd" ]] && cmd="$pkg"
		
		if ! command -v "$cmd" &>/dev/null; then
			missing+=("$pkg")
		fi
	done
	
	if [[ ${#missing[@]} -eq 0 ]]; then
		return 0
	fi
	
	log_info "Instalando dependencias faltantes: ${missing[*]}"
	pkg install -y "${missing[@]}" &>>"$LOG_FILE" || {
		log_error "Error al instalar dependencias: ${missing[*]}"
		return 1
	}
	
	# Verificar que se instalaron correctamente
	for entry in "$@"; do
		cmd="${entry##*:}"
		[[ "${entry%%:*}" == "$cmd" ]] && cmd="${entry%%:*}"
		if ! command -v "$cmd" &>/dev/null; then
			log_error "Fallo al instalar: $cmd"
			return 1
		fi
	done
	
	return 0
}

_ensure_node_deps() {
	local pkg
	for pkg in "$@"; do
		if ! npm list -g "$pkg" &>/dev/null; then
			log_info "Instalando npm global: $pkg"
			npm install -g "$pkg" &>>"$LOG_FILE" || {
				log_error "Error al instalar npm: $pkg"
				return 1
			}
		fi
	done
	return 0
}

_ensure_pip_deps() {
	local pkg
	for pkg in "$@"; do
		if ! pip show "$pkg" &>/dev/null 2>&1; then
			log_info "Instalando pip: $pkg"
			pip install "$pkg" &>>"$LOG_FILE" || {
				log_error "Error al instalar pip: $pkg"
				return 1
			}
		fi
	done
	return 0
}

# ── Limpieza completa de desinstalación ────────────────────────────
# Elimina data, configs, logs, binarios y cualquier rastro del tool
# Uso: _uninstall_cleanup "toolname" "bin1" "bin2" ...
_uninstall_cleanup() {
	local tool="$1"
	shift
	local -a bins=("$@")

	# 1. Binarios en $PREFIX/bin
	for bin in "${bins[@]}"; do
		rm -f "$PREFIX/bin/$bin" 2>/dev/null
	done

	# 2. Data del tool en directorio de datos
	rm -rf "$HOME/.local/share/jin-termx-data/$tool" 2>/dev/null

	# 3. Configuraciones específicas del tool en .config
	rm -rf "$HOME/.config/$tool" 2>/dev/null

	# 4. Logs de instalación
	rm -f "$JINX_CACHE/install_$tool"* 2>/dev/null

	# 5. Caché del tool en .cache si existe
	rm -rf "$HOME/.cache/jin-termx/$tool" 2>/dev/null

	# 6. Dotfiles en $HOME/.<tool> (ej: ~/.npm, ~/.cargo, ~/.oh-my-zsh)
	rm -rf "$HOME/.$tool" 2>/dev/null

	# Mapa de dotfiles cuyo nombre no coincide con el tool
	case "$tool" in
		nodejs)   rm -rf "$HOME/.npm" "$HOME/.node_repl_history" 2>/dev/null ;;
		python)   rm -rf "$HOME/.python_history" 2>/dev/null ;;
		bun)      rm -rf "$HOME/.bun" 2>/dev/null ;;
		rust)     rm -rf "$HOME/.rustup" "$HOME/.cargo" 2>/dev/null ;;
		oh-my-zsh) rm -rf "$HOME/.oh-my-zsh" 2>/dev/null ;;
	esac

	# 7. Directorio temporal si la instalación usa $PREFIX/tmp
	rm -f "$PREFIX/tmp/${tool}"* 2>/dev/null

	return 0
}
