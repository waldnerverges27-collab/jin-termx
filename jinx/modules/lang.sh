#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/install_lang.log"

install_lang() {
  separator
  box "$(_tr "jinx_modules_lang.installing_language_packages")"
  separator
  echo

  log_info "$(_tr "jinx_modules_lang.installing_language_packages")"

  mkdir -p "$(dirname "$LOG_FILE")"

  _install_lang_wrapper
  log_success "$(_tr "jinx_modules_lang.language_packages_installed_successfully")"
  separator
  echo
  list_item "$(_tr "jinx_modules_lang.node_js_lts")"
  list_item "$(_tr "jinx_modules_lang.python")"
  list_item "$(_tr "jinx_modules_lang.perl")"
  list_item "PHP"
  list_item "$(_tr "jinx_modules_lang.rust")"
  list_item "$(_tr "jinx_modules_lang.c_c_clang")"
  list_item "$(_tr "jinx_modules_lang.go_golang")"
  list_item "$(_tr "jinx_modules_lang.bun_js_js_runtime")"
  echo
}

_install_lang_wrapper() {
  import "@/tools/lang/all"
  install_all_lang_packages
}

uninstall_lang() {
  if ! command -v node &>/dev/null; then
    log_info "$(_tr "jinx_modules_lang.language_packages_are_not_installed")"
    return 0
  fi
  separator
  box "$(_tr "jinx_modules_lang.uninstalling_language_packages")"
  separator
  echo

  log_info "$(_tr "jinx_modules_lang.uninstalling_language_packages")"

  _uninstall_lang_wrapper
  log_success "$(_tr "jinx_modules_lang.language_packages_uninstalled")"
}

_uninstall_lang_wrapper() {
  import "@/tools/lang/all"
  uninstall_all_lang_packages
}

update_lang() {
  separator
  box "$(_tr "jinx_modules_lang.updating_language_packages")"
  separator
  echo

  log_info "$(_tr "jinx_modules_lang.updating_language_packages")"

  _update_lang_wrapper
  log_success "$(_tr "jinx_modules_lang.language_packages_updated")"
}

_update_lang_wrapper() {
  import "@/tools/lang/all"
  update_all_lang_packages
}

reinstall_lang() {
  separator
  box "$(_tr "jinx_modules_lang.reinstalling_language_packages")"
  separator
  echo

  log_info "$(_tr "jinx_modules_lang.reinstalling_language_packages")"

  _reinstall_lang_wrapper
  log_success "$(_tr "jinx_modules_lang.language_packages_reinstalled_successful")"
  separator
  echo
  list_item "$(_tr "jinx_modules_lang.node_js_lts")"
  list_item "$(_tr "jinx_modules_lang.python")"
  list_item "$(_tr "jinx_modules_lang.perl")"
  list_item "PHP"
  list_item "$(_tr "jinx_modules_lang.rust")"
  list_item "$(_tr "jinx_modules_lang.c_c_clang")"
  list_item "$(_tr "jinx_modules_lang.go_golang")"
  list_item "$(_tr "jinx_modules_lang.bun_js_js_runtime")"
  echo
}

_reinstall_lang_wrapper() {
  import "@/tools/lang/all"
  reinstall_all_lang_packages
}
