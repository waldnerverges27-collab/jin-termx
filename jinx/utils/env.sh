#!/data/data/com.termux/files/usr/bin/bash

JINX_VERSION="4.11.7"

# -------------------------
# Directorios del usuario
# -------------------------

# configuración
JINX_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/jin-termx"

# cache
JINX_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/jin-termx"

# datos del usuario
JINX_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/jin-termx-data"

# -------------------------
# Rutas internas del CLI
# -------------------------

JINX_BIN="$JINX_PATH/bin"
JINX_MODULES="$JINX_PATH/modules"
JINX_UTILS="$JINX_PATH/utils"
JINX_CLI="$JINX_PATH/cli"

# -------------------------
# Crear directorios
# -------------------------

mkdir -p \
  "$JINX_CONFIG" \
  "$JINX_CACHE" \
  "$JINX_DATA"
