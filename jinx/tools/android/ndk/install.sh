#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_android.log"
NDK_DIR="$HOME/android-ndk-r29"
NDK_ARCHIVE="$PREFIX/tmp/android-ndk-r29-aarch64.7z"
NDK_URL="https://github.com/lzhiyong/termux-ndk/releases/download/android-ndk/android-ndk-r29-aarch64.7z"
SDK_DIR="$HOME/android-sdk"

_android_ndk_check_arch() {
	local arch
	arch="$(uname -m)"
	if [[ "$arch" != "aarch64" && "$arch" != "arm64" ]]; then
		log_error "El Android NDK solo está soportado en aarch64 (detectado: $arch)"
		return 1
	fi
	return 0
}

_android_ndk_install_deps() {
	loading "Instalando dependencias" _android_ndk_install_deps_impl
}

_android_ndk_install_deps_impl() {
	declare -A DEPS=(
		["curl"]="curl"
		["7z"]="7z"
		["gradle"]="gradle"
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

_download_android_ndk() {
	loading "Descargando Android NDK r29 (332 MB)" _download_android_ndk_impl
}

_download_android_ndk_impl() {
	mkdir -p "$(dirname "$NDK_ARCHIVE")"

	if ! curl -fsSL -o "$NDK_ARCHIVE" "$NDK_URL" &>>"$LOG_FILE"; then
		log_error "Error al descargar Android NDK"
		return 1
	fi

	return 0
}

_extract_android_ndk() {
	loading "Extrayendo Android NDK r29" _extract_android_ndk_impl
}

_extract_android_ndk_impl() {
	rm -rf "$NDK_DIR"
	mkdir -p "$(dirname "$NDK_DIR")"

	if ! 7z x -y "$NDK_ARCHIVE" -o"$(dirname "$NDK_DIR")" &>>"$LOG_FILE"; then
		log_error "Error al extraer Android NDK"
		return 1
	fi

	rm -f "$NDK_ARCHIVE"

	if [ ! -f "$NDK_DIR/build/cmake/android.toolchain.cmake" ] && [ ! -d "$NDK_DIR/toolchains" ]; then
		log_error "Android NDK no válido: falta toolchains"
		return 1
	fi

	return 0
}

_setup_ndk_env() {
	for rc in ~/.zshrc ~/.bashrc; do
		[ -f "$rc" ] || continue
		{
			[ -f "$rc" ] && ! grep -qxF "export ANDROID_NDK_HOME=$NDK_DIR" "$rc" && echo "export ANDROID_NDK_HOME=$NDK_DIR" >>"$rc"
			[ -f "$rc" ] && ! grep -qxF "export NDK_ROOT=$NDK_DIR" "$rc" && echo "export NDK_ROOT=$NDK_DIR" >>"$rc"
		}
	done
}

install_android_ndk() {
	if [ -d "$NDK_DIR/toolchains" ]; then
		log_info "Android NDK ya está instalado"
		return 2
	fi

	_android_ndk_check_arch || return 1

	log_info "Instalando Android NDK r29 (jb de ~332 MB + ~1 GB de disco)..."
	mkdir -p "$(dirname "$LOG_FILE")"

	if ! _android_ndk_install_deps; then
		return 1
	fi
	if ! _download_android_ndk; then
		return 1
	fi
	if ! _extract_android_ndk; then
		return 1
	fi

	_setup_ndk_env

	log_success "Android NDK r29 instalado en $NDK_DIR"
	log_info "Reiniciá Termux o ejecuta: source ~/.zshrc"
	return 0
}

uninstall_android_ndk() {
	if [ ! -d "$NDK_DIR" ]; then
		log_info "Android NDK no está instalado"
		return 2
	fi

	confirm_remove_configs "Android NDK" "$NDK_DIR"

	loading "Desinstalando Android NDK" _uninstall_android_ndk_impl
}

_uninstall_android_ndk_impl() {
	for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
		[ -f "$rc" ] || continue
		sed -i '/export ANDROID_NDK_HOME=/d; /export NDK_ROOT=/d' "$rc"
	done

	rm -rf "$NDK_DIR"
	log_success "Android NDK desinstalado"
	return 0
}

update_android_ndk() {
	if [ ! -d "$NDK_DIR" ]; then
		log_info "Android NDK no está instalado"
		return 2
	fi

	log_info "Actualizando Android NDK..."
	_download_android_ndk || return 1
	_extract_android_ndk || return 1
	log_success "Android NDK actualizado"
	return 0
}

reinstall_android_ndk() {
	uninstall_android_ndk
	install_android_ndk
}