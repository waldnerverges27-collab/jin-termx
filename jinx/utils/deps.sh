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
	yes | pkg install "${missing[@]}" &>>"$LOG_FILE" || {
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
