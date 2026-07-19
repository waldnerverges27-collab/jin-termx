#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

LOG_FILE="$JINX_CACHE/init_project.log"

init_help() {
	echo
	box "$(_tr "jinx_cli_commands_init.jin_project_initializer")"
	echo
	log_info "$(_tr "jinx_cli_commands_init.usage_jinx_init_template")"
	echo
	log_info "$(_tr "jinx_cli_commands_init.run_this_inside_an_existing_project_to_c")"
	echo
	separator_section "$(_tr "jinx_cli_commands_init.available_templates")"
	echo
	printf "    ${D_CYAN}%-12s${NC} %s\n" "next" "Configure Next.js project"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "react" "Configure React + Vite project"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "nest" "Configure NestJS project"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "express" "Configure Express.js API"
	echo
	separator_section "$(_tr "jinx_cli_commands_init.examples")"
	echo
	printf "    ${D_CYAN}cd my-next-app && jinx init next${NC}\n"
	printf "    ${D_CYAN}cd my-react-app && jinx init react${NC}\n"
	printf "    ${D_CYAN}cd api && jinx init express${NC}\n"
	printf "    ${D_CYAN}cd backend && jinx init nest${NC}\n"
	echo
}

# ===== SHARED UTILITIES =====

check_project_exists() {
	if [[ ! -f "package.json" ]]; then
		log_error "$(_tr "jinx_cli_commands_init.no_project_found_in_current_directory")"
		log_info "$(_tr "jinx_cli_commands_init.make_sure_you_re_inside_a_project_direct")"
		return 1
	fi
	return 0
}

detect_package_manager() {
	if [[ -f "pnpm-lock.yaml" ]]; then
		echo "pnpm"
	elif [[ -f "yarn.lock" ]]; then
		echo "yarn"
	elif [[ -f "bun.lockb" ]]; then
		echo "bun"
	elif [[ -f "package-lock.json" ]]; then
		echo "npm"
	elif command -v pnpm &>/dev/null; then
		echo "pnpm"
	elif command -v yarn &>/dev/null; then
		echo "yarn"
	elif command -v bun &>/dev/null; then
		echo "bun"
	else
		echo "npm"
	fi
}

_install_pkg() {
	local pm="$1"
	shift
	case "$pm" in
	pnpm) pnpm add "$@" ;;
	yarn) yarn add "$@" ;;
	bun) bun add "$@" ;;
	*)
		if [[ -d "/data/data/com.termux" ]]; then
			npm install --force "$@"
		else
			npm install "$@"
		fi
		;;
	esac
}

_install_dev_pkg() {
	local pm="$1"
	shift
	case "$pm" in
	pnpm) pnpm add -D "$@" ;;
	yarn) yarn add -D "$@" ;;
	bun) bun add -D "$@" ;;
	*)
		if [[ -d "/data/data/com.termux" ]]; then
			npm install --force -D "$@"
		else
			npm install -D "$@"
		fi
		;;
	esac
}

_pm_exec() {
	local pm="$1"
	shift
	case "$pm" in
	pnpm) pnpm exec "$@" ;;
	yarn) yarn "$@" ;;
	bun) bun "$@" ;;
	*) npx "$@" ;;
	esac
}

_fix_pnpm_dev_engines() {
	if [[ -f "package.json" ]] && command -v jq &>/dev/null; then
		local temp
		temp=$(mktemp)
		if jq 'if .devEngines.packageManager.version then .devEngines.packageManager.version |= gsub("\\^";"") else . end' package.json >"$temp" && mv "$temp" package.json; then
			log_info "$(_tr "jinx_cli_commands_init.fixed_pnpm_devengines_version_removed_s")"
		fi
	fi
}

_check_turbopack_toolchain() {
	[[ -x "$HOME/.local/share/jin-termx-data/node-glibc/bin/node" ]] && return 0
	return 1
}

_detect_next_version() {
	local v
	v=$(grep -oP '"next":\s*"[^"]*"' package.json 2>/dev/null | grep -oP '\d+\.\d+\.\d+')
	echo "${v:-latest}"
}

# ===== NEXT.JS =====
configure_next() {
	separator
	box "$(_tr "jinx_cli_commands_init.configuring_next_js_project")"
	separator
	echo

	check_project_exists || return 1

	local PM
	PM=$(detect_package_manager)
	log_info "Package manager detected: ${D_CYAN}$PM${NC}"
	echo

	# ── Dependencies array ──
	local -a DEPS=()
	local -a DEV_DEPS=()
	local USE_TURBOPACK=false
	local SETUP_STRUCTURE=false
	local SETUP_PRETTIER=false
	local SETUP_ENV=false

	# ── Turbopack ──
	if _check_turbopack_toolchain; then
		read_confirm_default "Configure Turbopack (faster dev/build)?" "y" TURBO_ANS
		if [[ "$TURBO_ANS" == "y" ]]; then
			USE_TURBOPACK=true
			DEV_DEPS+=("@next/swc-linux-arm64-gnu" "lightningcss-linux-arm64-gnu" "@tailwindcss/oxide-linux-arm64-gnu" "@unrs/resolver-binding-linux-arm64-gnu")
		fi
	else
		log_info "$(_tr "jinx_cli_commands_init.turbopack_requires_the_glibc_toolchain")"
		read_confirm_default "Install Turbopack toolchain now?" "n" INSTALL_TURBO
		if [[ "$INSTALL_TURBO" == "y" ]]; then
			import "@/tools/npm/turbopack/install"
			if loading "Installing Turbopack toolchain" install_turbopack; then
				USE_TURBOPACK=true
				DEV_DEPS+=("@next/swc-linux-arm64-gnu" "lightningcss-linux-arm64-gnu" "@tailwindcss/oxide-linux-arm64-gnu" "@unrs/resolver-binding-linux-arm64-gnu")
			else
				log_warn "$(_tr "jinx_cli_commands_init.turbopack_toolchain_installation_failed")"
			fi
		fi
	fi

	# ── Optional deps ──
	section_title "Optional dependencies"

	read_confirm_default "Install TypeScript support?" "y" ANS
	# TypeScript comes with Next.js by default, no extra package

	read_confirm_default "Install Tailwind CSS?" "y" ANS
	# Next.js 16 includes Tailwind by default — only add prettier plugin

	read_confirm_default "Install Zustand (state management)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("zustand")

	read_confirm_default "Install React Query (@tanstack/react-query)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("@tanstack/react-query")

	read_confirm_default "Install Zod (schema validation)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("zod")

	read_confirm_default "Install React Hook Form + @hookform/resolvers?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("react-hook-form" "@hookform/resolvers")

	read_confirm_default "Install Axios (HTTP client)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("axios")

	read_confirm_default "Install Framer Motion (animations)?" "n" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("framer-motion")

	read_confirm_default "Install Sonner (toast notifications)?" "n" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("sonner")

	read_confirm_default "Install Lucide React (icons)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("lucide-react")

	# ── Setup options ──
	echo
	section_title "Project setup"

	read_confirm_default "Create modular folder structure?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_STRUCTURE=true

	read_confirm_default "Configure Prettier?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_PRETTIER=true

	read_confirm_default "Create .env.example?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_ENV=true

	# ── Configure pnpm for multi-platform native bindings ──
	if $USE_TURBOPACK && [[ "$PM" == "pnpm" ]]; then
		if [[ ! -f ".npmrc" ]] || ! grep -q "supportedArchitectures" .npmrc 2>/dev/null; then
			cat >>.npmrc <<'NPMRCEOF'
supportedArchitectures[0]=android
supportedArchitectures[1]=linux
NPMRCEOF
			log_info "$(_tr "jinx_cli_commands_init.configured_pnpm_for_multi_platform_nativ")"
		fi
	fi

	[[ "$PM" == "pnpm" ]] && _fix_pnpm_dev_engines

	# ── Install dependencies ──
	if [[ ${#DEPS[@]} -gt 0 ]]; then
		echo
		section_title "Installing dependencies"
		log_info "Packages: ${D_CYAN}${DEPS[*]}${NC}"
		if ! loading "Installing dependencies" _install_pkgs "$PM" "${DEPS[@]}"; then
			log_warn "$(_tr "jinx_cli_commands_init.some_dependencies_failed_to_install")"
		fi
	fi

	if [[ ${#DEV_DEPS[@]} -gt 0 ]]; then
		if ! loading "Installing dev dependencies" _install_dev_pkgs "$PM" "${DEV_DEPS[@]}"; then
			log_warn "$(_tr "jinx_cli_commands_init.some_dev_dependencies_failed_to_install")"
		fi
	fi

	# ── Setup Prettier ──
	if $SETUP_PRETTIER; then
		echo
		section_title "Configuring Prettier"
		_install_dev_pkg "$PM" prettier prettier-plugin-tailwindcss &>>"$LOG_FILE"
		cat >.prettierrc <<'EOF'
{
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOF
		log_success "$(_tr "jinx_cli_commands_init.created_prettierrc")"
	fi

	# ── Setup env ──
	if $SETUP_ENV; then
		echo
		section_title "Creating .env.example"
		if [[ ! -f ".env.example" ]]; then
			cat >.env.example <<'EOF'
# App
NEXT_PUBLIC_API_URL=http://localhost:4000
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Auth (optional)
# AUTH_SECRET=
EOF
			log_success "$(_tr "jinx_cli_commands_init.created_env_example")"
		else
			log_info "$(_tr "jinx_cli_commands_init.env_example_already_exists_skipping")"
		fi
	fi

	# ── Folder structure ──
	if $SETUP_STRUCTURE; then
		echo
		section_title "Creating folder structure"

		local -a DIRS=(
			"src/components/ui"
			"src/components/layout"
			"src/components/shared"
			"src/services"
			"src/lib"
			"src/hooks"
			"src/store"
			"src/types"
			"src/config"
			"src/providers"
		)

		for dir in "${DIRS[@]}"; do
			mkdir -p "$dir" 2>/dev/null
			list_item "Created $dir"
		done

		# Create barrel files for key modules
		_ensure_barrel "src/services" '// API services — add your HTTP calls here'
		_ensure_barrel "src/lib" '// Utilities — add your helpers here'
		_ensure_barrel "src/store" '// Zustand stores — add your stores here'
		_ensure_barrel "src/types" '// Shared TypeScript types'
		_ensure_barrel "src/hooks" '// Custom React hooks'
		_ensure_barrel "src/config" 'export const config = { apiUrl: process.env.NEXT_PUBLIC_API_URL || "http://localhost:4000" }'

		log_success "$(_tr "jinx_cli_commands_init.folder_structure_created")"
	fi

	# ── Done ──
	echo
	separator
	log_success "$(_tr "jinx_cli_commands_init.next_js_configured")"
	separator
	echo
	list_item "Package manager: ${D_CYAN}$PM${NC}"
	$USE_TURBOPACK && list_item "Bundler: ${D_CYAN}Turbopack${NC}" || list_item "$(_tr "jinx_cli_commands_init.bundler_webpack")"
	list_item "Dependencies: ${D_CYAN}${DEPS[*]:-(none selected)}${NC}"
	echo
	log_info "$(_tr "jinx_cli_commands_init.next_steps")"
	echo
	if $USE_TURBOPACK; then
		list_item "Start: ${D_CYAN}next-turbopack dev${NC}"
	else
		list_item "Start: ${D_CYAN}npm run dev${NC} (or ${D_CYAN}$PM run dev${NC})"
	fi
	echo
}

_install_pkgs() {
	local pm="$1"
	shift
	_install_pkg "$pm" "$@" &>>"$LOG_FILE"
}

_install_dev_pkgs() {
	local pm="$1"
	shift
	_install_dev_pkg "$pm" "$@" &>>"$LOG_FILE"
}

_ensure_barrel() {
	local dir="$1"
	local content="$2"
	local barrel="$dir/index.ts"
	if [[ ! -f "$barrel" ]]; then
		echo "$content" >"$barrel"
		list_item "Created $barrel"
	fi
}

_configure_tailwind_vite() {
	local config_file="vite.config.ts"
	if [[ ! -f "$config_file" ]]; then
		log_warn "$(_tr "jinx_cli_commands_init.vite_config_ts_not_found_skipping_tailw")"
		return 1
	fi

	# Add import if not present
	if ! grep -q "@tailwindcss/vite" "$config_file"; then
		local last_import_line
		last_import_line=$(grep -n "^import " "$config_file" | tail -1 | cut -d: -f1)
		if [[ -n "$last_import_line" ]]; then
			sed -i "${last_import_line}a import tailwindcss from '@tailwindcss/vite';" "$config_file"
			log_info "$(_tr "jinx_cli_commands_init.added_tailwindcss_import_to_vite_config")"
		fi
	fi

	# Add tailwindcss() to plugins if not present
	if ! grep -q "tailwindcss()" "$config_file"; then
		local plugins_line
		plugins_line=$(grep -n "plugins:" "$config_file" | head -1 | cut -d: -f1)
		if [[ -n "$plugins_line" ]]; then
			local bracket_line
			bracket_line=$(awk -v start="$plugins_line" 'NR >= start && /\[/ { print NR; exit }' "$config_file")
			if [[ -n "$bracket_line" ]]; then
				sed -i "${bracket_line}a\\  tailwindcss()," "$config_file"
				log_info "$(_tr "jinx_cli_commands_init.added_tailwindcss_plugin_to_vite_confi")"
			fi
		fi
	fi
}

_configure_tailwind_css() {
	local css_file="src/index.css"
	if [[ ! -f "$css_file" ]]; then
		mkdir -p src
		echo '@import "tailwindcss";' >"$css_file"
		log_info "$(_tr "jinx_cli_commands_init.created_src_index_css_with_tailwind_impo")"
		return 0
	fi

	if ! grep -q '@import "tailwindcss"' "$css_file"; then
		sed -i '1i @import "tailwindcss";' "$css_file"
		log_info "$(_tr "jinx_cli_commands_init.added_tailwind_import_to_src_index_css")"
	fi
}

section_title() {
	echo
	separator_section "$1"
}

# ===== REACT + VITE =====
configure_react() {
	separator
	box "$(_tr "jinx_cli_commands_init.configuring_react_vite_project")"
	separator
	echo

	check_project_exists || return 1

	local PM
	PM=$(detect_package_manager)
	log_info "Package manager detected: ${D_CYAN}$PM${NC}"
	echo

	if ! grep -q "vite" package.json 2>/dev/null; then
		log_warn "$(_tr "jinx_cli_commands_init.this_doesn_t_appear_to_be_a_vite_project")"
		read_confirm "Continue anyway?" CONFIRM
		[[ "$CONFIRM" != "y" ]] && { log_warn "$(_tr "jinx_cli_commands_init.cancelled")"; return 0; }
	fi

	local -a DEPS=()
	local -a DEV_DEPS=()
	local SETUP_STRUCTURE=false
	local SETUP_PRETTIER=false
	local SETUP_ENV=false
	local SETUP_TAILWIND=false

	# ── Optional deps ──
	section_title "Optional dependencies"

	read_confirm_default "Install Tailwind CSS?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_TAILWIND=true

	read_confirm_default "Install Zustand (state management)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("zustand")

	read_confirm_default "Install React Query (@tanstack/react-query)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("@tanstack/react-query")

	read_confirm_default "Install Zod (schema validation)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("zod")

	read_confirm_default "Install React Hook Form + @hookform/resolvers?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("react-hook-form" "@hookform/resolvers")

	read_confirm_default "Install Axios (HTTP client)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("axios")

	read_confirm_default "Install Framer Motion (animations)?" "n" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("framer-motion")

	read_confirm_default "Install Sonner (toast notifications)?" "n" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("sonner")

	read_confirm_default "Install Lucide React (icons)?" "y" ANS
	[[ "$ANS" == "y" ]] && DEPS+=("lucide-react")

	# ── Setup options ──
	echo
	section_title "Project setup"

	read_confirm_default "Create modular folder structure?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_STRUCTURE=true

	read_confirm_default "Configure Prettier?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_PRETTIER=true

	read_confirm_default "Create .env.example?" "y" ANS
	[[ "$ANS" == "y" ]] && SETUP_ENV=true

	[[ "$PM" == "pnpm" ]] && _fix_pnpm_dev_engines

	# ── Install ──
	if [[ ${#DEPS[@]} -gt 0 ]]; then
		echo
		section_title "Installing dependencies"
		if ! loading "Installing dependencies" _install_pkgs "$PM" "${DEPS[@]}"; then
			log_warn "$(_tr "jinx_cli_commands_init.some_dependencies_failed_to_install")"
		fi
	fi

	# ── Tailwind CSS ──
	if $SETUP_TAILWIND; then
		DEV_DEPS+=("tailwindcss" "@tailwindcss/vite")
		echo
		section_title "Installing Tailwind CSS"
		if loading "Installing Tailwind CSS" _install_dev_pkgs "$PM" "${DEV_DEPS[@]}"; then
			_configure_tailwind_vite
			_configure_tailwind_css
			log_success "$(_tr "jinx_cli_commands_init.tailwind_css_configured")"
		else
			log_warn "$(_tr "jinx_cli_commands_init.tailwind_css_installation_failed")"
		fi
	fi

	# ── Prettier ──
	if $SETUP_PRETTIER; then
		echo
		section_title "Configuring Prettier"
		_install_dev_pkg "$PM" prettier prettier-plugin-tailwindcss &>>"$LOG_FILE"
		cat >.prettierrc <<'EOF'
{
  "plugins": ["prettier-plugin-tailwindcss"]
}
EOF
		log_success "$(_tr "jinx_cli_commands_init.created_prettierrc")"
	fi

	# ── Env ──
	if $SETUP_ENV && [[ ! -f ".env.example" ]]; then
		echo
		section_title "Creating .env.example"
		cat >.env.example <<'EOF'
VITE_API_URL=http://localhost:4000
EOF
		log_success "$(_tr "jinx_cli_commands_init.created_env_example")"
	fi

	# ── Structure ──
	if $SETUP_STRUCTURE; then
		echo
		section_title "Creating folder structure"

		local -a DIRS=(
			"src/components/ui"
			"src/components/layout"
			"src/components/shared"
			"src/services"
			"src/lib"
			"src/hooks"
			"src/store"
			"src/types"
			"src/config"
			"src/providers"
		)

		for dir in "${DIRS[@]}"; do
			mkdir -p "$dir" 2>/dev/null
			list_item "Created $dir"
		done

		_ensure_barrel "src/services" '// API services — add your HTTP calls here'
		_ensure_barrel "src/lib" '// Utilities — add your helpers here'
		_ensure_barrel "src/store" '// Zustand stores'
		_ensure_barrel "src/types" '// Shared types'
		_ensure_barrel "src/hooks" '// Custom hooks'
		_ensure_barrel "src/config" 'export const config = { apiUrl: import.meta.env.VITE_API_URL || "http://localhost:4000" }'

		log_success "$(_tr "jinx_cli_commands_init.folder_structure_created")"
	fi

	echo
	separator
	log_success "$(_tr "jinx_cli_commands_init.react_vite_configured")"
	separator
	echo
	list_item "Dependencies: ${D_CYAN}${DEPS[*]:-(none selected)}${NC}"
	echo
	list_item "Start: ${D_CYAN}$PM run dev${NC}"
	echo
}

# ===== EXPRESS.JS =====
configure_express() {
	separator
	box "$(_tr "jinx_cli_commands_init.configuring_express_js_project")"
	separator
	echo

	check_project_exists || return 1

	local PM
	PM=$(detect_package_manager)
	log_info "Package manager detected: ${D_CYAN}$PM${NC}"
	echo

	# ── Interactive ──

	read_confirm_default "Install PostgreSQL + TypeORM?" "y" USE_DB
	read_confirm_default "Install authentication (JWT + bcrypt)?" "y" USE_AUTH
	read_confirm_default "Install file upload support (Multer + Cloudinary)?" "n" USE_UPLOAD
	read_confirm_default "Install Zod (request validation)?" "y" USE_ZOD
	read_confirm_default "Configure rate limiting?" "y" USE_RATE
	read_confirm_default "Configure CORS?" "y" USE_CORS

	echo
	section_title "Project setup"
	read_confirm_default "Create folder structure?" "y" SETUP_STRUCTURE
	read_confirm_default "Create .env.example?" "y" SETUP_ENV

	echo
	section_title "Installing dependencies"

	[[ "$PM" == "pnpm" ]] && _fix_pnpm_dev_engines

	# Build dep list
	local -a DEPS=("express")
	local -a DEV_DEPS=()

	[[ "$USE_DB" == "y" ]] && DEPS+=("pg" "typeorm" "reflect-metadata")
	[[ "$USE_AUTH" == "y" ]] && DEPS+=("jsonwebtoken" "bcryptjs")
	[[ "$USE_UPLOAD" == "y" ]] && DEPS+=("multer" "cloudinary")
	[[ "$USE_ZOD" == "y" ]] && DEPS+=("zod")
	[[ "$USE_RATE" == "y" ]] && DEPS+=("express-rate-limit")
	[[ "$USE_CORS" == "y" ]] && DEPS+=("cors")
	DEPS+=("cookie-parser" "morgan" "helmet")

	DEV_DEPS+=("typescript" "ts-node-dev" "tsconfig-paths" "tsc-alias")
	DEV_DEPS+=("@types/node" "@types/express" "@types/cors" "@types/morgan" "@types/cookie-parser")
	[[ "$USE_AUTH" == "y" ]] && DEV_DEPS+=("@types/jsonwebtoken")
	[[ "$USE_UPLOAD" == "y" ]] && DEV_DEPS+=("@types/multer")

	if ! loading "Installing dependencies" _install_pkgs "$PM" "${DEPS[@]}"; then
		log_warn "$(_tr "jinx_cli_commands_init.some_dependencies_failed_to_install")"
	fi

	if ! loading "Installing dev dependencies" _install_dev_pkgs "$PM" "${DEV_DEPS[@]}"; then
		log_warn "$(_tr "jinx_cli_commands_init.some_dev_dependencies_failed_to_install")"
	fi

	# ── Structure ──
	if [[ "$SETUP_STRUCTURE" == "y" ]]; then
		echo
		section_title "Creating folder structure"

		local -a DIRS=(
			"src/controllers"
			"src/middlewares"
			"src/routes"
			"src/services"
			"src/repositories"
			"src/entities"
			"src/schemas"
			"src/types"
			"src/utils"
			"src/config"
			"src/database/migrations"
			"src/database/seeds"
		)

		for dir in "${DIRS[@]}"; do
			mkdir -p "$dir" 2>/dev/null
			list_item "Created $dir"
		done
	fi

	# ── Config files ──
	echo
	section_title "Creating configuration files"

	# tsconfig.json
	cat >tsconfig.json <<'JSONCFG'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "moduleResolution": "node",
    "baseUrl": ".",
    "paths": { "@/*": ["src/*"] },
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "strictPropertyInitialization": false
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
JSONCFG
	log_success "$(_tr "jinx_cli_commands_init.created_tsconfig_json")"

	# .env.example
	if [[ "$SETUP_ENV" == "y" ]]; then
		cat >.env.example <<'ENVEOF'
NODE_ENV=development
PORT=4000
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
DB_NAME=dbname
JWT_SECRET=change-me-to-a-random-string
FRONTEND_URL=http://localhost:3000
ENVEOF
		log_success "$(_tr "jinx_cli_commands_init.created_env_example")"
	fi

	# src/config/env.ts
	mkdir -p src/config
	cat >src/config/env.ts <<'CFGEOF'
export const NODE_ENV = process.env.NODE_ENV || "development";
export const PORT = Number(process.env.PORT) || 4000;
export const DATABASE_URL = process.env.DATABASE_URL || "";
export const DB_NAME = process.env.DATABASE_URL?.split("/").pop() || "dbname";
export const JWT_SECRET = process.env.JWT_SECRET || "change-me";
export const FRONTEND_URL = process.env.FRONTEND_URL || "http://localhost:3000";
CFGEOF
	log_success "$(_tr "jinx_cli_commands_init.created_src_config_env_ts")"

	# src/app.ts
	mkdir -p src
	if [[ ! -f "src/app.ts" ]]; then
		cat >src/app.ts <<'APPEOF'
import express from "express";
import rateLimit from "express-rate-limit";
import helmet from "helmet";
import morgan from "morgan";
import cors from "cors";
import cookieParser from "cookie-parser";
import { FRONTEND_URL } from "@/config/env";
import userRoutes from "@/routes/user.routes";
import productRoutes from "@/routes/product.routes";

const app = express();

// monitorear peticiones HTTP (logger)
app.use(morgan("dev"));

// proteger cabeceras HTTP (seguridad)
app.use(helmet());

// habilitar acceso desde otros orígenes
app.use(
  cors({
    origin: FRONTEND_URL,
    credentials: true,
  }),
);

// limitar número de peticiones
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 200,
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// parsear JSON en el body
app.use(express.json());

// manejar cookies
app.use(cookieParser());

// endpoints
app.use("/api/user", userRoutes);
app.use("/api/product", productRoutes);

export default app;
APPEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_app_ts")"
	fi

	# src/index.ts
	if [[ ! -f "src/index.ts" ]]; then
		cat >src/index.ts <<'INDEXEOF'
import app from "@/app";
import { DB_NAME, PORT } from "@/config/env";
import { AppDataSource } from "@/database/data-source";

async function main() {
  try {
    await AppDataSource.initialize();
    console.log("Connected to:", DB_NAME);
    app.listen(PORT, () => {
      console.log("http://localhost:" + PORT);
    });
  } catch (error) {
    console.error("Internal server error:", error);
  }
}

main();
INDEXEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_index_ts")"
	fi

	# src/database/data-source.ts
	mkdir -p src/database
	if [[ ! -f "src/database/data-source.ts" ]]; then
		cat >src/database/data-source.ts <<'DSEOF'
import "reflect-metadata";
import { DataSource } from "typeorm";
import { DATABASE_URL, NODE_ENV } from "@/config/env";
import { User } from "@/entities/User";
import { Product } from "@/entities/Product";

const isDevelopment = NODE_ENV === "development";
const isProduction = NODE_ENV === "production";

export const AppDataSource = new DataSource({
  type: "postgres",
  url: DATABASE_URL,
  ssl: isDevelopment ? false : { rejectUnauthorized: false },
  synchronize: false,
  logging: isDevelopment ? ["query", "error"] : false,
  entities: [User, Product],
  migrations: isDevelopment
    ? [__dirname + "/migrations/*.ts"]
    : [__dirname + "/migrations/*.js"],
  migrationsRun: isDevelopment,
  extra: {
    max: isProduction ? 10 : 20,
  },
});
DSEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_database_data_source_ts")"
	fi

	# src/entities/User.ts
	mkdir -p src/entities
	if [[ ! -f "src/entities/User.ts" ]]; then
		cat >src/entities/User.ts <<'USEREOF'
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from "typeorm";

@Entity("users")
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: "varchar", length: 100 })
  name: string;

  @Column({ type: "varchar", length: 100, unique: true })
  email: string;

  @Column({ type: "varchar", select: false })
  password: string;

  @Column({ type: "varchar", length: 20, default: "user" })
  role: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
USEREOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_entities_user_ts")"
	fi

	# src/entities/Product.ts
	if [[ ! -f "src/entities/Product.ts" ]]; then
		cat >src/entities/Product.ts <<'PRODEOF'
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from "typeorm";
import { User } from "./User";

@Entity("products")
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: "varchar", length: 200 })
  name: string;

  @Column({ type: "text", nullable: true })
  description: string;

  @Column({ type: "decimal", precision: 10, scale: 2 })
  price: number;

  @Column({ type: "int", default: 0 })
  stock: number;

  @Column({ type: "boolean", default: true })
  isActive: boolean;

  @ManyToOne(() => User)
  @JoinColumn({ name: "userId" })
  user: User;

  @Column()
  userId: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
PRODEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_entities_product_ts")"
	fi

	# src/routes/user.routes.ts
	mkdir -p src/routes
	if [[ ! -f "src/routes/user.routes.ts" ]]; then
		cat >src/routes/user.routes.ts <<'USERRTEOF'
import { Router } from "express";

const router = Router();

router.get("/", (_req, res) => {
  res.json({ message: "Get all users" });
});

router.get("/:id", (req, res) => {
  res.json({ message: `Get user ${req.params.id}` });
});

router.post("/", (req, res) => {
  res.status(201).json({ message: "Create user", data: req.body });
});

export default router;
USERRTEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_routes_user_routes_ts")"
	fi

	# src/routes/product.routes.ts
	if [[ ! -f "src/routes/product.routes.ts" ]]; then
		cat >src/routes/product.routes.ts <<'PRODRTEOF'
import { Router } from "express";

const router = Router();

router.get("/", (_req, res) => {
  res.json({ message: "Get all products" });
});

router.get("/:id", (req, res) => {
  res.json({ message: `Get product ${req.params.id}` });
});

router.post("/", (req, res) => {
  res.status(201).json({ message: "Create product", data: req.body });
});

export default router;
PRODRTEOF
		log_success "$(_tr "jinx_cli_commands_init.created_src_routes_product_routes_ts")"
	fi

	# ── Scripts ──
	if command -v jq &>/dev/null; then
		local temp
		temp=$(mktemp)
		if [[ "$PM" == "pnpm" ]]; then
			jq '.scripts += {
				"dev": "ts-node-dev --require tsconfig-paths/register --env-file=.env --respawn src/index.ts",
				"build": "tsc && tsc-alias -p tsconfig.json",
				"start": "node dist/index.js",
				"typeorm": "ts-node-dev --require tsconfig-paths/register --env-file=.env ./node_modules/typeorm/cli.js",
				"mg:gen": "pnpm typeorm -- migration:generate -d src/database/data-source.ts",
				"mg:create": "pnpm run typeorm -- migration:create",
				"mg:run": "pnpm typeorm -- migration:run -d src/database/data-source.ts",
				"mg:run:prod": "typeorm migration:run -d dist/database/data-source.js",
				"mg:revert": "pnpm typeorm -- migration:revert -d src/database/data-source.ts",
				"mg:show": "pnpm typeorm -- migration:show -d src/database/data-source.ts"
			}' package.json >"$temp" && mv "$temp" package.json
		else
			jq '.scripts += {
				"dev": "ts-node-dev --require tsconfig-paths/register --env-file=.env --respawn src/index.ts",
				"build": "tsc && tsc-alias -p tsconfig.json",
				"start": "node dist/index.js",
				"typeorm": "ts-node-dev --require tsconfig-paths/register --env-file=.env ./node_modules/typeorm/cli.js",
				"mg:gen": "npx typeorm -- migration:generate -d src/database/data-source.ts",
				"mg:create": "npm run typeorm -- migration:create",
				"mg:run": "npx typeorm -- migration:run -d src/database/data-source.ts",
				"mg:run:prod": "typeorm migration:run -d dist/database/data-source.js",
				"mg:revert": "npx typeorm -- migration:revert -d src/database/data-source.ts",
				"mg:show": "npx typeorm -- migration:show -d src/database/data-source.ts"
			}' package.json >"$temp" && mv "$temp" package.json
		fi
		log_success "$(_tr "jinx_cli_commands_init.added_scripts_to_package_json")"
	fi

	echo
	separator
	log_success "$(_tr "jinx_cli_commands_init.express_js_configured")"
	separator
	echo
	list_item "Start: ${D_CYAN}$PM run dev${NC}"
	list_item "Build: ${D_CYAN}$PM run build${NC}"
	echo
}

# ===== NESTJS =====
configure_nest() {
	separator
	box "$(_tr "jinx_cli_commands_init.configuring_nestjs_project")"
	separator
	echo

	check_project_exists || return 1

	local PM
	PM=$(detect_package_manager)
	log_info "Package manager detected: ${D_CYAN}$PM${NC}"
	echo

	if ! grep -q "@nestjs" package.json 2>/dev/null; then
		log_warn "$(_tr "jinx_cli_commands_init.this_doesn_t_appear_to_be_a_nestjs_proje")"
		read_confirm "Continue anyway?" CONFIRM
		[[ "$CONFIRM" != "y" ]] && { log_warn "$(_tr "jinx_cli_commands_init.cancelled")"; return 0; }
	fi

	echo
	section_title "Optional dependencies"

	read_confirm_default "Install PostgreSQL + TypeORM?" "y" USE_DB
	read_confirm_default "Install authentication (JWT + Passport)?" "y" USE_AUTH

	local -a DEPS=()
	local -a DEV_DEPS=()

	[[ "$USE_DB" == "y" ]] && DEPS+=("@nestjs/typeorm" "typeorm" "pg")
	[[ "$USE_AUTH" == "y" ]] && DEPS+=("@nestjs/jwt" "@nestjs/passport" "passport" "passport-jwt" "bcryptjs")
	[[ "$USE_AUTH" == "y" ]] && DEV_DEPS+=("@types/passport-jwt" "@types/bcryptjs")

	[[ "$PM" == "pnpm" ]] && _fix_pnpm_dev_engines

	if [[ ${#DEPS[@]} -gt 0 ]]; then
		echo
		section_title "Installing dependencies"
		if ! loading "Installing dependencies" _install_pkgs "$PM" "${DEPS[@]}"; then
			log_warn "$(_tr "jinx_cli_commands_init.some_dependencies_failed_to_install")"
		fi
	fi

	if [[ ${#DEV_DEPS[@]} -gt 0 ]]; then
		if ! loading "Installing dev dependencies" _install_dev_pkgs "$PM" "${DEV_DEPS[@]}"; then
			log_warn "$(_tr "jinx_cli_commands_init.some_dev_dependencies_failed_to_install")"
		fi
	fi

	echo
	separator
	log_success "$(_tr "jinx_cli_commands_init.nestjs_configured")"
	separator
	echo
	list_item "Start: ${D_CYAN}$PM run start:dev${NC}"
	echo
}

# ===== MAIN =====
init_main() {
	local template="$1"

	case "$template" in
	next | nextjs) configure_next ;;
	react | vite) configure_react ;;
	nest | nestjs) configure_nest ;;
	express | exp) configure_express ;;
	"")
		local detected
		detected=$(detect_project_type)
		if [[ "$detected" != "unknown" ]]; then
			log_info "Detected project type: $detected"
			echo
			case "$detected" in
			next) configure_next ;;
			react) configure_react ;;
			nest) configure_nest ;;
			express) configure_express ;;
			esac
		else
			init_help
		fi
		;;
	*)
		log_error "Unknown template: $template"
		init_help
		exit 1
		;;
	esac
}

detect_project_type() {
	[[ ! -f "package.json" ]] && { echo "unknown"; return; }
	grep -q '"next"' package.json 2>/dev/null && { echo "next"; return; }
	grep -q '"vite"' package.json 2>/dev/null && { echo "react"; return; }
	grep -q '"@nestjs"' package.json 2>/dev/null && { echo "nest"; return; }
	grep -q '"express"' package.json 2>/dev/null && { echo "express"; return; }
	echo "unknown"
}
