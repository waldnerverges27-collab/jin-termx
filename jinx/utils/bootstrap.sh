#!/data/data/com.termux/files/usr/bin/bash

# evitar redeclaraciones
[[ -n "${__JINX_BOOTSTRAP_LOADED:-}" ]] && return
__JINX_BOOTSTRAP_LOADED=1

# registro de imports
declare -A __JINX_IMPORTED

import() {
	local path="${1//@/$JINX_PATH}.sh"

	if [[ -n "${__JINX_IMPORTED[$path]}" ]]; then
		return
	fi

	if [[ ! -f "$path" ]]; then
		echo "jinx: import error: $path not found" >&2
		exit 1
	fi

	__JINX_IMPORTED[$path]=1
	source "$path"
}
