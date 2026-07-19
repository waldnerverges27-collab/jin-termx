#!/data/data/com.termux/files/usr/bin/bash

import "@/utils/log"
import "@/utils/colors"

# Variables de PostgreSQL
PG_DATA="$PREFIX/var/lib/postgresql"
PG_LOG="$JINX_CACHE/postgresql.log"
PG_USER="postgres"

# Mostrar ayuda
pg_help() {
	echo
	box "$(_tr "jinx_cli_commands_pg.core_postgresql_manager")"
	echo
	log_info "$(_tr "jinx_cli_commands_pg.usage_jinx_pg_command_options")"
	echo
	separator_section "$(_tr "jinx_cli_commands_pg.available_commands")"
	echo
	printf "    ${D_CYAN}%-12s${NC} %s\n" "start" "Start PostgreSQL server"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "stop" "Stop PostgreSQL server"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "restart" "Restart PostgreSQL server"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "status" "Check PostgreSQL status"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "init" "Initialize PostgreSQL database"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "create" "Create a new database"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "drop" "Drop a database"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "list" "List all databases"
	printf "    ${D_CYAN}%-12s${NC} %s\n" "shell" "Open psql shell"
	echo
	separator_section "$(_tr "jinx_cli_commands_pg.examples")"
	echo
	printf "    ${D_CYAN}jinx pg start${NC}              # Start PostgreSQL\n"
	printf "    ${D_CYAN}jinx pg stop${NC}               # Stop PostgreSQL\n"
	printf "    ${D_CYAN}jinx pg create mydb${NC}        # Create database 'mydb'\n"
	printf "    ${D_CYAN}jinx pg shell${NC}              # Open psql shell\n"
	echo
}

# Verificar si PostgreSQL está instalado
check_pg_installed() {
	if ! command -v pg_ctl &>/dev/null; then
		log_error "$(_tr "jinx_cli_commands_pg.postgresql_is_not_installed")"
		log_info "Run: ${D_CYAN}jinx install db${NC}"
		return 1
	fi
	return 0
}

# Verificar si está inicializado (solo informativo)
check_pg_initialized() {
	# Verificar múltiples rutas posibles
	local data_dirs=(
		"$PREFIX/var/lib/postgresql/data"
		"$PG_DATA/data"
		"$HOME/.termux/postgresql/data"
		"/data/data/com.termux/files/usr/var/lib/postgresql/data"
	)

	for dir in "${data_dirs[@]}"; do
		if [[ -d "$dir" ]] && [[ -f "$dir/PG_VERSION" ]]; then
			# Actualizar PG_DATA a la ruta correcta
			PG_DATA="$(dirname "$dir")"
			return 0
		fi
	done

	# También verificar si el servicio está corriendo
	if pg_ctl status &>/dev/null; then
		return 0
	fi

	return 1
}

# Inicializar PostgreSQL
pg_init() {
	separator
	box "$(_tr "jinx_cli_commands_pg.initializing_postgresql")"
	separator
	echo

	check_pg_installed || return 1

	# Verificar si ya está inicializado
	if check_pg_initialized; then
		log_warn "$(_tr "jinx_cli_commands_pg.postgresql_is_already_initialized")"
		echo
		list_item "Data directory: $PG_DATA"
		list_item "Run: ${D_CYAN}jinx pg start${NC}"
		echo
		return 0
	fi

	mkdir -p "$PG_DATA"

	log_info "$(_tr "jinx_cli_commands_pg.initializing_postgresql_database")"

	if loading "Initializing database" _pg_init_db; then
		log_success "$(_tr "jinx_cli_commands_pg.postgresql_initialized_successfully")"
		echo
		list_item "Data directory: $PG_DATA"
		list_item "Default user: $PG_USER"
		echo
		log_info "Start PostgreSQL with: ${D_CYAN}jinx pg start${NC}"
	else
		log_error "$(_tr "jinx_cli_commands_pg.failed_to_initialize_postgresql")"
		log_warn "Check log: $PG_LOG"
		return 1
	fi

	echo
}

_pg_init_db() {
	initdb -D "$PG_DATA" &>"$PG_LOG"
}

# Iniciar PostgreSQL
pg_start() {
	separator
	box "$(_tr "jinx_cli_commands_pg.starting_postgresql")"
	separator
	echo

	check_pg_installed || return 1

	# Intentar detectar la ruta de datos antes de iniciar
	local found_dir=""
	local data_dirs=(
		"$PREFIX/var/lib/postgresql"
		"$PREFIX/var/lib/postgresql/data"
		"$PG_DATA"
		"$PG_DATA/data"
		"$HOME/.termux/postgresql"
		"$HOME/.termux/postgresql/data"
	)

	for dir in "${data_dirs[@]}"; do
		if [[ -d "$dir" ]] && [[ -f "$dir/PG_VERSION" ]]; then
			PG_DATA="$dir"
			found_dir="$dir"
			break
		fi
	done

	log_info "$(_tr "jinx_cli_commands_pg.starting_postgresql_server")"

	if loading "Starting PostgreSQL" _pg_start_server; then
		log_success "$(_tr "jinx_cli_commands_pg.postgresql_started_successfully")"
		echo
		list_item "$(_tr "jinx_cli_commands_pg.listening_on_localhost_5432")"
		list_item "User: $PG_USER"
		echo
	else
		log_error "$(_tr "jinx_cli_commands_pg.failed_to_start_postgresql")"
		log_warn "$(_tr "jinx_cli_commands_pg.postgresql_may_not_be_initialized_run")"
		return 1
	fi

	echo
}

_pg_start_server() {
	pg_ctl -D "$PG_DATA" -l "$PG_LOG" start &>/dev/null
	sleep 1
}

# Detener PostgreSQL
pg_stop() {
	separator
	box "$(_tr "jinx_cli_commands_pg.stopping_postgresql")"
	separator
	echo

	check_pg_installed || return 1

	# Intentar detectar la ruta de datos
	local found_dir=""
	local data_dirs=(
		"$PREFIX/var/lib/postgresql"
		"$PREFIX/var/lib/postgresql/data"
		"$PG_DATA"
		"$PG_DATA/data"
		"$HOME/.termux/postgresql"
		"$HOME/.termux/postgresql/data"
	)

	for dir in "${data_dirs[@]}"; do
		if [[ -d "$dir" ]] && [[ -f "$dir/PG_VERSION" ]]; then
			PG_DATA="$dir"
			found_dir="$dir"
			break
		fi
	done

	log_info "$(_tr "jinx_cli_commands_pg.stopping_postgresql_server")"

	if loading "Stopping PostgreSQL" _pg_stop_server; then
		log_success "$(_tr "jinx_cli_commands_pg.postgresql_stopped_successfully")"
	else
		log_error "$(_tr "jinx_cli_commands_pg.failed_to_stop_postgresql")"
		log_warn "$(_tr "jinx_cli_commands_pg.postgresql_may_not_be_running")"
		return 1
	fi

	echo
}

_pg_stop_server() {
	pg_ctl -D "$PG_DATA" stop &>/dev/null
}

# Reiniciar PostgreSQL
pg_restart() {
	separator
	box "$(_tr "jinx_cli_commands_pg.restarting_postgresql")"
	separator
	echo

	check_pg_installed || return 1
	check_pg_initialized || return 1

	pg_stop
	sleep 1
	pg_start

	echo
	separator
	log_success "$(_tr "jinx_cli_commands_pg.postgresql_restarted")"
	separator
	echo
}

# Estado de PostgreSQL
pg_status() {
	separator
	box "$(_tr "jinx_cli_commands_pg.postgresql_status")"
	separator
	echo

	check_pg_installed || return 1

	# Intentar detectar la ruta de datos
	local found_dir=""
	# En Termux, los datos pueden estar directamente en el directorio o en /data
	local data_dirs=(
		"$PREFIX/var/lib/postgresql"
		"$PREFIX/var/lib/postgresql/data"
		"$PG_DATA"
		"$PG_DATA/data"
		"$HOME/.termux/postgresql"
		"$HOME/.termux/postgresql/data"
	)

	for dir in "${data_dirs[@]}"; do
		if [[ -d "$dir" ]] && [[ -f "$dir/PG_VERSION" ]]; then
			PG_DATA="$dir"
			found_dir="$dir"
			break
		fi
	done

	log_info "$(_tr "jinx_cli_commands_pg.checking_postgresql_status")"
	echo

	# Verificar estado
	if [[ -n "$found_dir" ]]; then
		if pg_ctl -D "$found_dir" status &>/dev/null; then
			log_success "$(_tr "jinx_cli_commands_pg.postgresql_is_running")"
			echo
			list_item "Data directory: $PG_DATA"
			list_item "$(_tr "jinx_cli_commands_pg.port_5432")"
			list_item "User: $PG_USER"
		else
			log_warn "$(_tr "jinx_cli_commands_pg.postgresql_is_stopped")"
			echo
			list_item "Data directory: $PG_DATA"
			list_item "Run: ${D_CYAN}jinx pg start${NC}"
		fi
	else
		log_info "$(_tr "jinx_cli_commands_pg.postgresql_data_directory_not_found")"
		echo
		list_item "Run: ${D_CYAN}jinx pg init${NC}"
	fi

	echo
}

# Crear base de datos
pg_create() {
	local db_name="$1"

	if [[ -z "$db_name" ]]; then
		log_error "$(_tr "jinx_cli_commands_pg.database_name_required")"
		log_info "$(_tr "jinx_cli_commands_pg.usage_jinx_pg_create_database_name")"
		return 1
	fi

	check_pg_installed || return 1

	# Detectar ruta de datos
	_detect_pg_data

	log_info "Creating database: $db_name..."

	if su - "$PG_USER" -c "createdb $db_name" &>/dev/null; then
		log_success "Database '$db_name' created successfully"
	else
		log_error "Failed to create database '$db_name'"
		log_warn "$(_tr "jinx_cli_commands_pg.postgresql_may_not_be_running_or_initial")"
		return 1
	fi
}

# Eliminar base de datos
pg_drop() {
	local db_name="$1"

	if [[ -z "$db_name" ]]; then
		log_error "$(_tr "jinx_cli_commands_pg.database_name_required")"
		log_info "$(_tr "jinx_cli_commands_pg.usage_jinx_pg_drop_database_name")"
		return 1
	fi

	check_pg_installed || return 1

	log_warn "This will permanently delete database: $db_name"

	read_confirm "Are you sure?" CONFIRM
	if [[ "$CONFIRM" != "y" ]]; then
		log_warn "$(_tr "jinx_cli_commands_pg.operation_cancelled")"
		return 0
	fi

	# Detectar ruta de datos
	_detect_pg_data

	log_info "Dropping database: $db_name..."

	if su - "$PG_USER" -c "dropdb $db_name" &>/dev/null; then
		log_success "Database '$db_name' dropped successfully"
	else
		log_error "Failed to drop database '$db_name'"
		return 1
	fi
}

# Listar bases de datos
pg_list() {
	separator
	box "$(_tr "jinx_cli_commands_pg.postgresql_databases")"
	separator
	echo

	check_pg_installed || return 1

	# Detectar ruta de datos
	_detect_pg_data

	log_info "$(_tr "jinx_cli_commands_pg.listing_databases")"
	echo

	su - "$PG_USER" -c "psql -c '\l'" 2>/dev/null || {
		log_error "$(_tr "jinx_cli_commands_pg.failed_to_list_databases")"
		log_warn "$(_tr "jinx_cli_commands_pg.postgresql_may_not_be_running")"
		return 1
	}

	echo
}

# Abrir shell psql
pg_shell() {
	check_pg_installed || return 1

	# Detectar ruta de datos
	_detect_pg_data

	log_info "$(_tr "jinx_cli_commands_pg.opening_psql_shell")"
	echo

	su - "$PG_USER" -c "psql" 2>/dev/null
}

# Función auxiliar para detectar ruta de datos
_detect_pg_data() {
	local data_dirs=(
		"$PREFIX/var/lib/postgresql"
		"$PREFIX/var/lib/postgresql/data"
		"$PG_DATA"
		"$PG_DATA/data"
		"$HOME/.termux/postgresql"
		"$HOME/.termux/postgresql/data"
	)

	for dir in "${data_dirs[@]}"; do
		if [[ -d "$dir" ]] && [[ -f "$dir/PG_VERSION" ]]; then
			PG_DATA="$dir"
			return 0
		fi
	done

	return 1
}

# Función principal
pg_main() {
	local cmd="$1"
	shift || true

	case "$cmd" in
	start)
		pg_start
		;;
	stop)
		pg_stop
		;;
	restart)
		pg_restart
		;;
	status)
		pg_status
		;;
	init)
		pg_init
		;;
	create)
		pg_create "$2"
		;;
	drop)
		pg_drop "$2"
		;;
	list | ls)
		pg_list
		;;
	shell | psql)
		pg_shell
		;;
	"")
		pg_help
		;;
	*)
		log_error "Unknown command: $cmd"
		pg_help
		exit 1
		;;
	esac
}
