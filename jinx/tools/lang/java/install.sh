#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_lang.log"
JDK_DATA_DIR="$HOME/.local/share/jin-termx-data/jdk-17"
JDK_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.19%2B10/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.19_10.tar.gz"
GLIBC_LINKER="$PREFIX/glibc/lib/ld-linux-aarch64.so.1"

_install_glibc() {
	if [[ ! -f "$GLIBC_LINKER" ]]; then
		loading "Instalando glibc" _install_glibc_impl
	else
		log_info "glibc ya instalado"
	fi
}

_install_glibc_impl() {
	if [[ ! -f $PREFIX/etc/apt/sources.list.d/glibc.list ]]; then
		if ! yes | pkg install glibc-repo &>>"$LOG_FILE"; then
			log_error "Error al instalar glibc-repo"
			return 1
		fi
	fi
	if ! yes | pkg install glibc &>>"$LOG_FILE"; then
		log_error "Error al instalar glibc"
		return 1
	fi
	return 0
}

_download_jdk() {
	loading "Descargando JDK 17" _download_jdk_impl
}

_download_jdk_impl() {
	mkdir -p "$JDK_DATA_DIR"
	local tmpfile="$PREFIX/tmp/jdk17.tar.gz"

	if ! curl -fsSL -o "$tmpfile" "$JDK_URL" &>>"$LOG_FILE"; then
		log_error "Error al descargar JDK 17"
		return 1
	fi

	if ! tar -xzf "$tmpfile" -C "$JDK_DATA_DIR" --strip-components=1 &>>"$LOG_FILE"; then
		log_error "Error al extraer JDK 17"
		rm -f "$tmpfile"
		return 1
	fi

	rm -f "$tmpfile"
	return 0
}

_create_wrappers() {
	local bins=("java" "javac" "jar" "javadoc" "jlink" "jmod" "jpackage" "jshell" "jhsdb" "jcmd" "jconsole" "jdb" "jdeprscan" "jdeps" "jfr" "jinfo" "jmap" "jps" "jrunscript" "jshell" "jstack" "jstat" "jstatd" "keytool" "rmiregistry" "serialver")
	local jdk_bin="$JDK_DATA_DIR/bin"

	for bin in "${bins[@]}"; do
		if [[ -f "$jdk_bin/$bin" ]]; then
			cat >"$PREFIX/bin/$bin" <<WRAPPER
#!/data/data/com.termux/files/usr/bin/bash
exec "$GLIBC_LINKER" "$jdk_bin/$bin" "\$@"
WRAPPER
			chmod +x "$PREFIX/bin/$bin"
		fi
	done

	log_success "Wrappers creados para JDK 17 en $PREFIX/bin/"
}

install_java() {
	if command -v java &>/dev/null && java -version 2>&1 | grep -q "17"; then
		log_info "JDK 17 ya está instalado"
		return 2
	fi

	log_info "Instalando JDK 17 (OpenJDK Temurin) con glibc..."
	mkdir -p "$(dirname "$LOG_FILE")" "$PREFIX/tmp"

	_install_glibc || return 1
	_download_jdk || return 1
	_create_wrappers

	log_success "JDK 17 instalado correctamente"
	return 0
}

uninstall_java() {
	if [[ ! -d "$JDK_DATA_DIR" ]]; then
		log_info "JDK 17 no está instalado"
		return 2
	fi

	log_info "Desinstalando JDK 17..."

	local bins=("java" "javac" "jar" "javadoc" "jlink" "jmod" "jpackage" "jshell" "jhsdb" "jcmd" "jconsole" "jdb" "jdeprscan" "jdeps" "jfr" "jinfo" "jmap" "jps" "jrunscript" "jshell" "jstack" "jstat" "jstatd" "keytool" "rmiregistry" "serialver")
	for bin in "${bins[@]}"; do
		rm -f "$PREFIX/bin/$bin"
	done

	rm -rf "$JDK_DATA_DIR"
	log_success "JDK 17 desinstalado"
	return 0
}

update_java() {
	if [[ ! -d "$JDK_DATA_DIR" ]]; then
		log_info "JDK 17 no está instalado"
		return 2
	fi

	log_info "Verificando actualización de JDK 17..."
	# Re-descargar e instalar sobre la versión actual
	_download_jdk || return 1
	_create_wrappers
	log_success "JDK 17 actualizado"
	return 0
}

reinstall_java() {
	uninstall_java
	install_java
}
