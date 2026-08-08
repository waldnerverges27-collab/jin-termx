#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_android.log"

install_android() {
	separator
	box "Installing Android Tools"
	separator
	echo

	log_info "Installing Android tools..."

	mkdir -p "$(dirname "$LOG_FILE")"

	_install_android_wrapper
	log_success "Android tools installed successfully"
	separator
	echo
	list_item "Java (OpenJDK 17)"
	list_item "Kotlin"
	list_item "Android SDK 35"
	list_item "Android NDK r29"
	echo
}

_install_android_wrapper() {
	import "@/tools/android/all"
	install_all_android_tools
}

uninstall_android() {
	if ! command -v java &>/dev/null; then
		log_info "Android tools are not installed"
		return 0
	fi
	separator
	box "Uninstalling Android Tools"
	separator
	echo

	log_info "Uninstalling Android tools..."

	_uninstall_android_wrapper
	log_success "Android tools uninstalled"
}

_uninstall_android_wrapper() {
	import "@/tools/android/all"
	uninstall_all_android_tools
}

update_android() {
	separator
	box "Updating Android Tools"
	separator
	echo

	log_info "Updating Android tools..."

	_update_android_wrapper
	log_success "Android tools updated"
}

_update_android_wrapper() {
	import "@/tools/android/all"
	update_all_android_tools
}

reinstall_android() {
	separator
	box "Reinstalling Android Tools"
	separator
	echo

	log_info "Reinstalling Android tools..."

	_reinstall_android_wrapper
	log_success "Android tools reinstalled successfully"
	separator
	echo
	list_item "Java (OpenJDK 17)"
	list_item "Kotlin"
	list_item "Android SDK 35"
	list_item "Android NDK r29"
	echo
}

_reinstall_android_wrapper() {
	import "@/tools/android/all"
	reinstall_all_android_tools
}
