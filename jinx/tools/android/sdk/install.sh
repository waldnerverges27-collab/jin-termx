#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_android.log"
SDK_DIR="$HOME/android-sdk"
SDK_TARBALL="$PREFIX/tmp/android-sdk-35.0.0.tar.gz"
SDK_URL="https://github.com/woaiyuzi/android-sdk-tools/releases/download/35.0.0/android-sdk-35.0.0.tar.gz"
# Fallback: SDK base + build/platform tools por arquitectura desde androidide-tools manifest
SDK_MANIFEST="https://raw.githubusercontent.com/AndroidIDEOfficial/androidide-tools/main/manifest.json"

_android_sdk_check_arch() {
	local arch
	arch="$(uname -m)"
	if [[ "$arch" != "aarch64" && "$arch" != "arm64" ]]; then
		log_error "El Android SDK solo está soportado en aarch64 (detectado: $arch)"
		return 1
	fi
	return 0
}

_android_sdk_install_deps() {
	loading "Instalando dependencias" _android_sdk_install_deps_impl
}

_android_sdk_install_deps_impl() {
	declare -A DEPS=(
		["curl"]="curl"
		["jq"]="jq"
		["tar"]="tar"
		["7z"]="7z"
	)

	local pkg_name bin_name
	for pkg_name in "${!DEPS[@]}"; do
		bin_name="${DEPS[$pkg_name]}"
		if ! command -v "$bin_name" &>/dev/null; then
			if ! yes | pkg install "$pkg_name" &>>"$LOG_FILE"; then
				log_error "Failed to install $pkg_name"
				return 1
			fi
		fi
	done

	if ! command -v java &>/dev/null; then
		import "@/tools/android/java/install"
		install_java || return 1
	fi

	return 0
}

_download_android_sdk() {
	loading "Descargando Android SDK (320 MB)" _download_android_sdk_impl
}

_download_android_sdk_impl() {
	mkdir -p "$(dirname "$SDK_TARBALL")" "$SDK_DIR"

	if ! curl -fsSL -o "$SDK_TARBALL" "$SDK_URL" &>>"$LOG_FILE"; then
		log_error "Error al descargar Android SDK"
		return 1
	fi

	return 0
}

_extract_android_sdk_tarball() {
	loading "Extrayendo Android SDK" _extract_android_sdk_tarball_impl
}

_extract_android_sdk_tarball_impl() {
	local tmp_dir="$PREFIX/tmp/android-sdk-setup"
	rm -rf "$tmp_dir"
	mkdir -p "$tmp_dir"

	if ! tar -xzf "$SDK_TARBALL" -C "$tmp_dir" &>>"$LOG_FILE"; then
		log_error "Error al extraer Android SDK tarball"
		return 1
	fi

	rm -f "$SDK_TARBALL"

	# El tarball contiene un directorio con setup.sh que instala el SDK en ~/android-sdk
	local setup
	setup="$(find "$tmp_dir" -maxdepth 2 -name "setup.sh" 2>/dev/null | head -1)"

	if [[ -n "$setup" ]]; then
		(
			cd "$(dirname "$setup")" || return 1
			yes | bash setup.sh &>>"$LOG_FILE"
		) || {
			log_error "setup.sh falló"
			return 1
		}
	elif [ -d "$tmp_dir/android-sdk" ]; then
		# Paquete descomprimido directamente: mover a destino
		cp -a "$tmp_dir/android-sdk/." "$SDK_DIR/" &>>"$LOG_FILE"
	else
		# Algunos paquetes despliegan el contenido directamente
		cp -a "$tmp_dir/." "$SDK_DIR/" &>>"$LOG_FILE"
	fi

	rm -rf "$tmp_dir"

	if [ ! -d "$SDK_DIR/platform-tools" ] && [ ! -d "$SDK_DIR/cmdline-tools" ]; then
		log_error "Android SDK no válido: falta platform-tools/cmdline-tools"
		return 1
	fi

	return 0
}

_setup_sdk_env() {
	local rc_line
	for rc in ~/.zshrc ~/.bashrc; do
		[ -f "$rc" ] || continue
		{
			rc_line='export ANDROID_HOME=$HOME/android-sdk'
			[ -f "$rc" ] && ! grep -qxF "export ANDROID_HOME=$HOME/android-sdk" "$rc" && echo "$rc_line" >>"$rc"
			rc_line='export ANDROID_SDK_ROOT=$HOME/android-sdk'
			[ -f "$rc" ] && ! grep -qxF "export ANDROID_SDK_ROOT=$HOME/android-sdk" "$rc" && echo "$rc_line" >>"$rc"
			[ -f "$rc" ] && ! grep -qxF 'export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH' "$rc" && echo 'export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH' >>"$rc"
		}
	done
}

install_android_sdk() {
	if [ -d "$SDK_DIR/platform-tools" ] || command -v adb &>/dev/null; then
		log_info "Android SDK ya está instalado"
		return 2
	fi

	_android_sdk_check_arch || return 1

	log_info "Instalando Android SDK 35 (jb de ~320 MB + ~1 GB de disco)..."
	mkdir -p "$(dirname "$LOG_FILE")"

	if ! _android_sdk_install_deps; then
		return 1
	fi
	if ! _download_android_sdk; then
		return 1
	fi
	if ! _extract_android_sdk_tarball; then
		return 1
	fi

	_setup_sdk_env

	yes | "$SDK_DIR/cmdline-tools/latest/bin/sdkmanager" --licenses &>>"$LOG_FILE" 2>/dev/null || true

	log_success "Android SDK 35 instalado en $SDK_DIR"
	log_info "Reiniciá Termux o ejecuta: source ~/.zshrc"
	return 0
}

uninstall_android_sdk() {
	if [ ! -d "$SDK_DIR" ]; then
		log_info "Android SDK no está instalado"
		return 2
	fi

	confirm_remove_configs "Android SDK" "$SDK_DIR"

	loading "Desinstalando Android SDK" _uninstall_android_sdk_impl
}

_uninstall_android_sdk_impl() {
	for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
		[ -f "$rc" ] || continue
		sed -i '/export ANDROID_HOME=/d; /export ANDROID_SDK_ROOT=/d; /cmdline-tools\/latest\/bin/d' "$rc"
	done

	rm -rf "$SDK_DIR"
	log_success "Android SDK desinstalado"
	return 0
}

update_android_sdk() {
	if [ ! -d "$SDK_DIR" ]; then
		log_info "Android SDK no está instalado"
		return 2
	fi

	log_info "Actualizando Android SDK..."
	_download_android_sdk || return 1
	_extract_android_sdk_tarball || return 1
	log_success "Android SDK actualizado"
	return 0
}

reinstall_android_sdk() {
	uninstall_android_sdk
	install_android_sdk
}