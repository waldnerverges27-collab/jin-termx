#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"
import "@/utils/version"

DOCTOR_LOG="$JINX_CACHE/doctor.log"
DOCTOR_ISSUES=()

doctor_main() {
	local fix_mode=false
	local args=()

	for arg in "$@"; do
		case "$arg" in
		--fix | -f) fix_mode=true ;;
		--help | -h) doctor_help; return ;;
		*) args+=("$arg") ;;
		esac
	done

	separator
	box "Jin-TermX Doctor"
	echo
	log_info "Ejecutando diagnóstico del sistema..."
	echo

	mkdir -p "$(dirname "$DOCTOR_LOG")"
	: >"$DOCTOR_LOG"

	_doctor_check_network
	_doctor_check_disk
	_doctor_check_shell_config
	_doctor_check_tools
	_doctor_check_updates
	_doctor_check_env

	echo
	separator

	if [[ ${#DOCTOR_ISSUES[@]} -eq 0 ]]; then
		log_success "Todo en orden — no se encontraron problemas"
	else
		log_warn "Se encontraron ${#DOCTOR_ISSUES[@]} problema(s):"
		for issue in "${DOCTOR_ISSUES[@]}"; do
			list_item "${D_YELLOW}⚠${NC} $issue"
		done
		echo
		if $fix_mode; then
			log_info "Modo --fix activado. Intentando resolver..."
			_doctor_fix_all
		else
			list_item "Ejecuta ${D_CYAN}jinx doctor --fix${NC} para intentar resolverlos automáticamente"
		fi
	fi

	echo
}

doctor_help() {
	echo
	box "Jin Doctor — Diagnóstico del sistema"
	echo
	log_info "Uso: jinx doctor [opciones]"
	echo
	log_info "Opciones:"
	printf "    ${D_CYAN}%-20s${NC} %s\n" "--fix" "Intenta resolver problemas automáticamente"
	printf "    ${D_CYAN}%-20s${NC} %s\n} " "--help" "Muestra esta ayuda"
	echo
}

_doctor_fix_all() {
	local fixed=0
	for issue in "${DOCTOR_ISSUES[@]}"; do
		case "$issue" in
		*"config"*)
			log_info "Respaldando y limpiando config..."
			_doctor_fix_shell_config && ((fixed++))
			;;
		*"herramienta"* | *"tool"*)
			log_info "Reinstalando herramienta con problemas..."
			_doctor_fix_tools && ((fixed++))
			;;
		*"variable"*)
			log_info "Configurando variables de entorno..."
			_doctor_fix_env && ((fixed++))
			;;
		*"plugins"*)
			log_info "Actualizando plugins shell..."
			_doctor_fix_plugins && ((fixed++))
			;;
		esac
	done
	log_success "$fixed problema(s) resuelto(s)"
}

_doctor_check_network() {
	log_info "Verificando conexión a internet..."
	
	if command -v curl &>/dev/null; then
		if curl -fsSL --connect-timeout 5 https://github.com &>/dev/null; then
			log_success "Conexión a internet: OK"
		else
			DOCTOR_ISSUES+=("Sin conexión a internet — verifica tu red")
			log_warn "Sin acceso a internet"
		fi
	else
		DOCTOR_ISSUES+=("curl no instalado — no se puede verificar red")
		log_warn "curl no disponible"
	fi
}

_doctor_check_disk() {
	log_info "Verificando espacio en disco..."
	
	local space
	space=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $4}')
	local used_pct
	used_pct=$(df "$HOME" 2>/dev/null | awk 'NR==2{print $5}' | tr -d '%')
	
	if [[ -n "$space" ]]; then
		log_success "Espacio libre: $space"
		if [[ -n "$used_pct" && "$used_pct" -gt 90 ]]; then
			DOCTOR_ISSUES+=("Disco casi lleno ($used_pct%) — libera espacio")
			log_warn "Disco al $used_pct% de capacidad"
		fi
	else
		DOCTOR_ISSUES+=("No se pudo verificar espacio en disco")
		log_warn "No se pudo verificar disco"
	fi
}

_doctor_check_shell_config() {
	log_info "Verificando configuración de shell..."
	
	# Verificar .zshrc
	if [[ -f ~/.zshrc ]]; then
		if grep -q "oh-my-zsh.sh" ~/.zshrc 2>/dev/null; then
			log_success ".zshrc: Oh My Zsh configurado"
		else
			DOCTOR_ISSUES+=(".zshrc no carga Oh My Zsh")
			log_warn ".zshrc: falta Oh My Zsh"
		fi
		if grep -q "compinit" ~/.zshrc 2>/dev/null; then
			log_success ".zshrc: compinit presente"
		else
			DOCTOR_ISSUES+=(".zshrc falta compinit — plugins pueden fallar")
			log_warn ".zshrc: falta compinit"
		fi
	else
		DOCTOR_ISSUES+=(".zshrc no existe")
		log_warn ".zshrc no encontrado"
	fi
	
	# Verificar .bashrc
	if [[ -f ~/.bashrc ]]; then
		if grep -q "blesh\|ble.sh" ~/.bashrc 2>/dev/null; then
			log_success ".bashrc: BLE configurado"
		fi
		if grep -q "starship" ~/.bashrc 2>/dev/null; then
			log_success ".bashrc: Starship configurado"
		fi
	else
		DOCTOR_ISSUES+=(".bashrc no existe — el prompt puede no funcionar en bash")
		log_warn ".bashrc no encontrado"
	fi
}

_doctor_check_tools() {
	log_info "Verificando herramientas instaladas..."
	
	local tools=("git" "curl" "node" "python3" "zsh" "bash" "starship" "lsd" "bat" "fzf" "zoxide" "gh" "glow" "jq" "rg")
	local missing=0
	
	for tool in "${tools[@]}"; do
		if command -v "$tool" &>/dev/null 2>&1; then
			:
		else
			((missing++))
		fi
	done
	
	if [[ "$missing" -eq 0 ]]; then
		log_success "Todas las herramientas base están instaladas"
	else
		DOCTOR_ISSUES+=("$missing herramienta(s) base faltan — ejecuta 'jinx doctor --fix'")
		log_warn "$missing herramienta(s) base no instaladas"
	fi
}

_doctor_check_updates() {
	log_info "Verificando actualizaciones del framework..."
	
	if [[ -d "$JINX_PATH/../.git" ]]; then
		local behind
		behind=$(git -C "$JINX_PATH/.." rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
		if [[ "$behind" -gt 0 ]]; then
			DOCTOR_ISSUES+=("Jin-TermX está $behind commit(s) detrás — ejecuta 'jinx update jinx'")
			log_warn "Jin-TermX desactualizado ($behind commits atrás)"
		else
			log_success "Jin-TermX actualizado"
		fi
	else
		log_warn "No es un repositorio git — no se puede verificar actualizaciones"
	fi
}

_doctor_check_env() {
	log_info "Verificando variables de entorno..."
	
	if grep -q "GOPATH\|GOCACHE\|GOMODCACHE" ~/.zshrc 2>/dev/null; then
		log_success "Variables Go configuradas"
	else
		DOCTOR_ISSUES+=("Variables de entorno Go no configuradas")
		log_warn "Faltan variables Go"
	fi
	
	if grep -q "LC_ALL.*UTF.*\|LANG.*UTF" ~/.zshrc 2>/dev/null; then
		log_success "Locale UTF-8 configurado"
	else
		DOCTOR_ISSUES+=("Locale no configurado — BLE puede mostrar advertencias")
		log_warn "Locale UTF-8 no configurado"
	fi
}

_doctor_fix_shell_config() {
	import "@/modules/shell"
	_install_shell_plugins_wrapper 2>/dev/null
	_setup_starship_for_both_shells 2>/dev/null
	log_success "Configuración de shell reparada"
	return 0
}

_doctor_fix_tools() {
	local tools=("git" "curl" "nodejs-lts" "python" "zsh" "bash" "starship" "lsd" "bat" "fzf" "zoxide" "gh" "glow" "jq" "ripgrep")
	local to_install=()
	for tool in "${tools[@]}"; do
		if ! command -v "$tool" &>/dev/null 2>&1; then
			to_install+=("$tool")
		fi
	done
	
	if [[ ${#to_install[@]} -gt 0 ]]; then
		log_info "Instalando: ${to_install[*]}"
		yes | pkg install "${to_install[@]}" &>>"$DOCTOR_LOG" || true
	fi
	log_success "Herramientas base verificadas"
	return 0
}

_doctor_fix_env() {
	import "@/modules/shell"
	setup_shell_env 2>/dev/null
	log_success "Variables de entorno configuradas"
	return 0
}

_doctor_fix_plugins() {
	import "@/tools/shell/all"
	for plugin in "${SHELL_PLUGINS[@]}"; do
		local dir="$ZSH_PLUGINS_DIR/$plugin"
		if [[ -d "$dir/.git" ]]; then
			git -C "$dir" pull --ff-only &>>"$DOCTOR_LOG" || true
			log_info "Actualizado: $plugin"
		fi
	done
	log_success "Plugins shell actualizados"
	return 0
}
