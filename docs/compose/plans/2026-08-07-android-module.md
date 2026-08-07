# Android Module Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use compose:subagent (recommended) or compose:execute to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a new `android` module by moving `java` and `kotlin` tools from `lang`, with all imports, log paths, CLI dispatch, and docs updated.

**Architecture:** Shell-based CLI. A tool is a directory under `jinx/tools/<module>/<tool>/install.sh` exporting `install_<tool>/uninstall_<tool>/update_<tool>/reinstall_<tool>`. A module is `jinx/modules/<module>.sh` wrapping the module's `all.sh` aggregator. CLI commands (`install/update/uninstall/reinstall/list`) dispatch by static `case` blocks per module.

**Tech Stack:** Bash (Termux), git, no build step.

## Global Constraints

- Tool dirs live at `jinx/tools/<module>/<tool>/`; module wrappers at `jinx/modules/<module>.sh`; aggregators at `jinx/tools/<module>/all.sh`.
- Tool functions must be named `install_<tool>`, `uninstall_<tool>`, `update_<tool>`, `reinstall_<tool>`.
- Log file for android tools: `$JINX_CACHE/install_android.log`.
- All touched `.sh` files must pass `bash -n`.
- Working repo: `/data/data/com.termux/files/home/jin-termx` (branch `main`), remote `origin/main`.

---

### Task 1: Move java/kotlin dirs and fix internal references

**Covers:** [S2]

**Files:**
- Move: `jinx/tools/lang/java/` → `jinx/tools/android/java/`
- Move: `jinx/tools/lang/kotlin/` → `jinx/tools/android/kotlin/`
- Modify: `jinx/tools/android/kotlin/install.sh:19`
- Modify: `jinx/tools/android/java/install.sh:6`
- Modify: `jinx/tools/android/kotlin/install.sh:6`

**Interfaces:**
- Produces: `jinx/tools/android/java/install.sh` (exports `install_java`, `uninstall_java`, `update_java`, `reinstall_java`), `jinx/tools/android/kotlin/install.sh` (exports `install_kotlin`, `uninstall_kotlin`, `update_kotlin`, `reinstall_kotlin`, imports `@/tools/android/java/install`)

- [ ] **Step 1: Move directories**

```bash
cd /data/data/com.termux/files/home/jin-termx
mkdir -p jinx/tools/android
git mv jinx/tools/lang/java jinx/tools/android/java
git mv jinx/tools/lang/kotlin jinx/tools/android/kotlin
```

- [ ] **Step 2: Fix kotlin import path**

Edit `jinx/tools/android/kotlin/install.sh` line 19:
```bash
import "@/tools/lang/java/install"   →   import "@/tools/android/java/install"
```

- [ ] **Step 3: Fix LOG_FILE in both install.sh files**

Both `jinx/tools/android/java/install.sh` and `jinx/tools/android/kotlin/install.sh`:
```bash
LOG_FILE="$JINX_CACHE/install_lang.log"   →   LOG_FILE="$JINX_CACHE/install_android.log"
```

- [ ] **Step 4: Verify**

```bash
cd /data/data/com.termux/files/home/jin-termx
bash -n jinx/tools/android/java/install.sh && bash -n jinx/tools/android/kotlin/install.sh
grep -n "android/java/install" jinx/tools/android/kotlin/install.sh   # must match new path
grep -c "install_lang.log" jinx/tools/android/java/install.sh jinx/tools/android/kotlin/install.sh  # expect 0
```

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat: move java and kotlin tools from lang to new android module"
```

---

### Task 2: Create android aggregator all.sh

**Covers:** [S2]

**Files:**
- Create: `jinx/tools/android/all.sh`

**Interfaces:**
- Consumes: `install_java`/`uninstall_java`/`update_java`/`reinstall_java`, `install_kotlin`/`uninstall_kotlin`/`update_kotlin`/`reinstall_kotlin`
- Produces: `install_all_android_tools`, `uninstall_all_android_tools`, `update_all_android_tools`, `reinstall_all_android_tools`

- [ ] **Step 1: Create the aggregator**

Write `jinx/tools/android/all.sh`:
```bash
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
```

- [ ] **Step 2: Verify**

```bash
bash -n jinx/tools/android/all.sh
```

- [ ] **Step 3: Commit**

```bash
git add jinx/tools/android/all.sh
git commit -m "feat: add android module aggregator all.sh"
```

---

### Task 3: Create android module wrapper

**Covers:** [S2]

**Files:**
- Create: `jinx/modules/android.sh`

**Interfaces:**
- Consumes: `install_all_android_tools`, `uninstall_all_android_tools`, `update_all_android_tools`, `reinstall_all_android_tools`
- Produces: `install_android`, `uninstall_android`, `update_android`, `reinstall_android`

- [ ] **Step 1: Create the module wrapper**

Write `jinx/modules/android.sh` (modeled on `jinx/modules/db.sh`):
```bash
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
	echo
}

_reinstall_android_wrapper() {
	import "@/tools/android/all"
	reinstall_all_android_tools
}
```

- [ ] **Step 2: Verify**

```bash
bash -n jinx/modules/android.sh
```

- [ ] **Step 3: Commit**

```bash
git add jinx/modules/android.sh
git commit -m "feat: add android module wrapper"
```

---

### Task 4: Clean lang module aggregator

**Covers:** [S2]

**Files:**
- Modify: `jinx/tools/lang/all.sh`

- [ ] **Step 1: Remove java/kotlin from LANGUAGE_PACKAGES array**

In `jinx/tools/lang/all.sh` remove lines `"java"` and `"kotlin"` from the array.

- [ ] **Step 2: Remove source lines**

Remove:
```bash
source "$(dirname "$BASH_SOURCE")/java/install.sh"
source "$(dirname "$BASH_SOURCE")/kotlin/install.sh"
```

- [ ] **Step 3: Remove case blocks**

Remove the `java)` and `kotlin)` case blocks from `install_all_lang_packages`, `uninstall_all_lang_packages`, `update_all_lang_packages`, and `reinstall_all_lang_packages`.

- [ ] **Step 4: Verify**

```bash
bash -n jinx/tools/lang/all.sh
grep -c "java\|kotlin" jinx/tools/lang/all.sh   # expect 0 matches
```

- [ ] **Step 5: Commit**

```bash
git add jinx/tools/lang/all.sh
git commit -m "refactor: remove java and kotlin from lang module"
```

---

### Task 5: Update CLI install.sh

**Covers:** [S2]

**Files:**
- Modify: `jinx/cli/commands/install.sh`

- [ ] **Step 1: Add android to _install_full_module**

In `_install_full_module` (around line 102), add after `lang)`:
```bash
  android)
    import "@/modules/android"
    install_android
    ;;
```

- [ ] **Step 2: Remove java/kotlin from lang specific-tools case**

In `_install_specific_tools` lang case, remove the `java)` (lines ~555-558) and `kotlin)` (lines ~559-562) blocks.

- [ ] **Step 3: Add android to _install_specific_tools**

Add after the `lang)` case in `_install_specific_tools`:
```bash
  android)
    import "@/tools/android/all"
    local installed_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      java)
        install_java
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      kotlin)
        install_kotlin
        case $? in 0) ((installed_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown android tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $installed_count -gt 0 ]]; then
      log_success "$installed_count android tool(s) installed"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count android tool(s) failed to install"
    fi
    echo
    ;;
```

- [ ] **Step 4: Update _interactive_install**

In `_interactive_install` lang case (line ~773-785), remove `java) bin="java";;` and `kotlin) bin="kotlin";;`. Add new android case:
```bash
  android)
    import "@/tools/android/all"
    for tool in "${ANDROID_TOOLS[@]}"; do
      local bin=""
      case "$tool" in
        java) bin="java";; kotlin) bin="kotlin";;
      esac
      _is_cmd_installed "$bin" || { items+=("${tool^}:${tool}"); }
    done
    ;;
```

- [ ] **Step 5: Update help text**

In `install_main` help (around line 30-38), add:
```bash
    list_item "android    - Android tools (Java, Kotlin)"
```

- [ ] **Step 6: Verify**

```bash
bash -n jinx/cli/commands/install.sh
grep -c "android)" jinx/cli/commands/install.sh   # expect >= 3
grep -c "java)" jinx/cli/commands/install.sh      # expect only in android case
```

- [ ] **Step 7: Commit**

```bash
git add jinx/cli/commands/install.sh
git commit -m "feat: register android module in install command"
```

---

### Task 6: Update CLI update/uninstall/reinstall.sh

**Covers:** [S2]

**Files:**
- Modify: `jinx/cli/commands/update.sh`
- Modify: `jinx/cli/commands/uninstall.sh`
- Modify: `jinx/cli/commands/reinstall.sh`

- [ ] **Step 1: Add android case to each command**

In each of the three files, add an `android)` case next to `lang)` in the specific-tools dispatcher:
```bash
  android)
    import "@/tools/android/all"
    # use update_/uninstall_/reinstall_ prefixes matching the file's counters
    ...
    ;;
```

**update.sh** case body:
```bash
  android)
    import "@/tools/android/all"
    local updated_count=0
    local failed_count=0

    for tool in "${tools[@]}"; do
      case "$tool" in
      java)
        update_java
        case $? in 0) ((updated_count++));; 1) ((failed_count++));; esac
        ;;
      kotlin)
        update_kotlin
        case $? in 0) ((updated_count++));; 1) ((failed_count++));; esac
        ;;
      *)
        log_warn "Unknown android tool: --$tool"
        ;;
      esac
    done

    echo
    if [[ $updated_count -gt 0 ]]; then
      log_success "$updated_count android tool(s) updated"
    fi
    if [[ $failed_count -gt 0 ]]; then
      log_warn "$failed_count android tool(s) failed to update"
    fi
    echo
    ;;
```

**uninstall.sh** case body: same shape with `uninstall_java`/`uninstall_kotlin`, `uninstalled_count`, message `uninstalled`.

**reinstall.sh** case body: same shape with `reinstall_java`/`reinstall_kotlin`, `reinstalled_count`, message `reinstalled`.

- [ ] **Step 2: Verify**

```bash
bash -n jinx/cli/commands/update.sh && bash -n jinx/cli/commands/uninstall.sh && bash -n jinx/cli/commands/reinstall.sh
grep -c "android)" jinx/cli/commands/update.sh jinx/cli/commands/uninstall.sh jinx/cli/commands/reinstall.sh
```

- [ ] **Step 3: Commit**

```bash
git add jinx/cli/commands/update.sh jinx/cli/commands/uninstall.sh jinx/cli/commands/reinstall.sh
git commit -m "feat: register android module in update/uninstall/reinstall commands"
```

---

### Task 7: Update list.sh and cli/jinx.sh

**Covers:** [S2]

**Files:**
- Modify: `jinx/cli/commands/list.sh`
- Modify: `jinx/cli/jinx.sh`

- [ ] **Step 1: Remove java/kotlin rows from _list_lang**

In `jinx/cli/commands/list.sh`, remove lines 83-84 (Java and Kotlin rows) from `_list_lang`.

- [ ] **Step 2: Add _list_android function**

Add after `_list_lang`:
```bash
# ===== LIST ANDROID =====
_list_android() {
  echo
  box "Android Tools"
  echo
  log_info "Available packages, versions and install commands:"
  echo

  table_start "Package" "Install Flag" "Version" "Status"
  table_row "Java (OpenJDK 17)" "--java" "$(_get_ver java)" "$(_check_cmd "java")"
  table_row "Kotlin" "--kotlin" "$(_get_ver kotlin)" "$(_check_cmd "kotlin")"
  table_end

  echo
  log_info "Install specific: ${D_CYAN}jinx install android --java --kotlin${NC}"
  log_info "Install all: ${D_CYAN}jinx install android${NC}"
  echo
}
```

- [ ] **Step 3: Register android in list_main**

Add to the module dispatch in `list_main`:
```bash
    android)
      _list_android
      ;;
```
And to the help listing: `list_item "android    - List Android tools"`.

- [ ] **Step 4: Update cli/jinx.sh help**

In `jinx/cli/jinx.sh`, update the lang line and add android:
```bash
  printf "    ${D_GREEN}%-10s${NC} %s\n" "lang" "Node, Bun, Python, Rust, C/C++, Go, etc."
  printf "    ${D_GREEN}%-10s${NC} %s\n" "android" "Java (OpenJDK), Kotlin"
```

- [ ] **Step 5: Verify**

```bash
bash -n jinx/cli/commands/list.sh && bash -n jinx/cli/jinx.sh
grep -c "android" jinx/cli/commands/list.sh jinx/cli/jinx.sh
```

- [ ] **Step 6: Commit**

```bash
git add jinx/cli/commands/list.sh jinx/cli/jinx.sh
git commit -m "feat: register android module in list and help"
```

---

### Task 8: Update README

**Covers:** [S2]

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update Common Modules table (line ~63)**

```markdown
| `lang` | Language packages (Node.js, Python, Perl, PHP, Rust, C/C++, Go, Bun) |
| `android` | Android toolchains (Java/JDK 17, Kotlin) |
```

- [ ] **Step 2: Remove Java/Kotlin from Language Packages table (lines 753-754)**

Remove the Java and Kotlin rows from the lang table.

- [ ] **Step 3: Add Android section**

Add a new section after Language Packages:
```markdown
## Android Toolchains

The `android` module installs Android-related toolchains:

```bash
jinx install android
```

| Tool | Flag | Description |
|------|------|-------------|
| **Java** | `--java` | Java 17 (Temurin JDK via glibc) |
| **Kotlin** | `--kotlin` | Kotlin programming language |
```

- [ ] **Step 4: Verify**

```bash
grep -n "android" README.md
grep -n "Java" README.md | head
```

- [ ] **Step 5: Commit**

```bash
git add README.md
git commit -m "docs: document android module in README"
```

---

### Task 9: Final verification

**Covers:** [S2]

**Files:**
- All touched files

- [ ] **Step 1: Syntax check every touched shell file**

```bash
cd /data/data/com.termux/files/home/jin-termx
for f in jinx/tools/android/all.sh jinx/tools/android/java/install.sh jinx/tools/android/kotlin/install.sh jinx/modules/android.sh jinx/tools/lang/all.sh jinx/cli/commands/install.sh jinx/cli/commands/update.sh jinx/cli/commands/uninstall.sh jinx/cli/commands/reinstall.sh jinx/cli/commands/list.sh jinx/cli/jinx.sh; do bash -n "$f" && echo "OK: $f" || echo "FAIL: $f"; done
```

- [ ] **Step 2: Cross-check dispatch consistency**

```bash
# android case must exist in all 4 commands + list
grep -l "android)" jinx/cli/commands/*.sh
# java/kotlin must NOT be in lang dispatchers anymore
grep -rn "install_java\|install_kotlin" jinx/cli/commands/install.sh | grep -v android || echo "clean"
# every tool function referenced must be defined
for fn in install_java install_kotlin uninstall_java uninstall_kotlin update_java update_kotlin reinstall_java reinstall_kotlin; do
  grep -rq "^$fn()" jinx/tools/android/ && echo "OK $fn" || echo "MISSING $fn"
done
```

- [ ] **Step 3: Check git log is clean and push**

```bash
git status --short
git push origin main
```

- [ ] **Step 4: Finalize spec**

Edit `docs/compose/spec/android-module.md`: set `status: delivered`, fill `commits: <base>..<head>`, check off completed tasks, write Report section, commit.
