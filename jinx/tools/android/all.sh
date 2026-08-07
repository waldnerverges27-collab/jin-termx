#!/bin/bash

import "@/utils/log"

LOG_FILE="$JINX_CACHE/install_android.log"

ANDROID_TOOLS=(
	"java"
	"kotlin"
)

source "$(dirname "$BASH_SOURCE")/java/install.sh"
source "$(dirname "$BASH_SOURCE")/kotlin/install.sh"

install_all_android_tools() {
	local installed_count=0
	local failed_count=0

	for tool in "${ANDROID_TOOLS[@]}"; do
		case "$tool" in
		java)
			loading "Installing Java" install_java
			case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
			;;
		kotlin)
			loading "Installing Kotlin" install_kotlin
			case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
			;;
		esac
	done

	return 0
}

uninstall_all_android_tools() {
	local uninstalled_count=0
	local failed_count=0

	for tool in "${ANDROID_TOOLS[@]}"; do
		case "$tool" in
		java)
			loading "Uninstalling Java" uninstall_java
			case $? in 0) ((uninstalled_count++));; 1) ((failed_count++));; esac
			;;
		kotlin)
			loading "Uninstalling Kotlin" uninstall_kotlin
			case $? in 0) ((uninstalled_count++));; 1) ((failed_count++));; esac
			;;
		esac
	done

	return 0
}

update_all_android_tools() {
	for tool in "${ANDROID_TOOLS[@]}"; do
		case "$tool" in
		java)
			update_java
			;;
		kotlin)
			update_kotlin
			;;
		esac
	done
	echo
}

reinstall_all_android_tools() {
	local reinstalled_count=0
	local failed_count=0

	for tool in "${ANDROID_TOOLS[@]}"; do
		case "$tool" in
		java)
			loading "Reinstalling Java" reinstall_java
			case $? in 0) ((reinstalled_count++));; 1) ((failed_count++));; esac
			;;
		kotlin)
			loading "Reinstalling Kotlin" reinstall_kotlin
			case $? in 0) ((reinstalled_count++));; 1) ((failed_count++));; esac
			;;
		esac
	done

	return 0
}
