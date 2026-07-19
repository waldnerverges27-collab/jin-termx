#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/version"

LOG_FILE="$JINX_CACHE/install_db.log"

_install_redis_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if yes | pkg install redis &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_redis_install.redis_installed")"
		return 0
	else
		return 1
	fi
}

install_redis() {
	if command -v redis-cli &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_redis_install.redis_is_already_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_redis_install.installing_redis")"
	loading "Installing Redis" _install_redis_impl
}

_uninstall_redis_impl() {
	mkdir -p "$(dirname "$LOG_FILE")"
	if pkg uninstall redis -y &>>"$LOG_FILE"; then
		log_success "$(_tr "jinx_tools_db_redis_install.redis_uninstalled")"
		return 0
	else
		log_error "$(_tr "jinx_tools_db_redis_install.failed_to_uninstall_redis")"
		return 1
	fi
}

uninstall_redis() {
	if ! command -v redis-cli &>/dev/null; then
		log_info "$(_tr "jinx_tools_db_redis_install.redis_is_not_installed")"
		return 2
	fi
	log_info "$(_tr "jinx_tools_db_redis_install.uninstalling_redis")"
	loading "Uninstalling Redis" _uninstall_redis_impl
}

_update_redis_impl() {
	loading "Updating Redis" _do_redis_update
}

_do_redis_update() {
	mkdir -p "$(dirname "$LOG_FILE")"
	pkg upgrade redis -y &>>"$LOG_FILE"
}

update_redis() {
  mkdir -p "$(dirname "$LOG_FILE")"
  _check_update_needed "Redis" "$(_get_installed_pkg_version redis "Redis")" "$(_get_remote_pkg_version redis)" _update_redis_impl
}

reinstall_redis() {
	uninstall_redis
	install_redis
}
