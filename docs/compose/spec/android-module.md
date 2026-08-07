---
feature: android-module
status: delivered
updated: 2026-08-07
branch: feature/android-module
commits: fa515a6..ac221e1
---

# New Android Module: Move Java + Kotlin from lang

## Report

**What was built** — A new `android` module was extracted by moving the `java` and `kotlin` tools out of `lang`. The tools now live at `jinx/tools/android/{java,kotlin}/`, with a new aggregator `jinx/tools/android/all.sh` and module wrapper `jinx/modules/android.sh`. The kotlin import was repointed to `@/tools/android/java/install`, both tools log to `install_android.log`, and the `android` module is fully registered across `install/update/uninstall/reinstall/list` commands plus the CLI help. `lang` was cleaned of java/kotlin everywhere.

**Verification** — `bash -n` passed on all 11 touched `.sh` files. `android)` case present in all 4 commands (full-module + specific-tools dispatch). `grep` confirmed 0 stale references to `tools/lang/java`/`tools/lang/kotlin` and 0 java/kotlin entries in `tools/lang/all.sh`. All 8 tool functions defined. Independent reviewer confirmed spec compliance, correctness, and consistency with the `db.sh` module pattern; no regressions.

**Journey log** — Found that `update.sh`/`uninstall.sh`/`reinstall.sh` never had java/kotlin cases in their lang dispatchers (only install.sh did); the new android module registers java/kotlin in all 4 commands, fixing that inconsistency. The static dispatch system (multiple registration points) is the source of this class of issue; a unifying refactor was designed but explicitly rejected by the user to keep current functionality untouched.

## [S1] Problem
Jin-TermX has a `lang` module containing programming languages. Java and Kotlin are Android-oriented toolchains (JDK via glibc, Kotlin for Android) that conceptually belong in a dedicated `android` module. They must move from `lang` to a new `android` module with all references updated to avoid import errors and broken CLI dispatch.

## [S2] Design
Create a new `android` module and move `java` and `kotlin` tools from `lang`:

1. Move dirs: `jinx/tools/lang/java/` and `jinx/tools/lang/kotlin/` → `jinx/tools/android/`
2. Fix critical import in `kotlin/install.sh`: `import "@/tools/lang/java/install"` → `import "@/tools/android/java/install"`
3. Change `LOG_FILE` in both install.sh files from `install_lang.log` → `install_android.log`
4. Create `jinx/tools/android/all.sh` aggregator (array + source + install/uninstall/update/reinstall all-functions)
5. Create `jinx/modules/android.sh` module wrapper
6. Clean `jinx/tools/lang/all.sh`: remove java/kotlin from array, sources, and all 4 case blocks
7. Update CLI commands: `install.sh`, `update.sh`, `uninstall.sh`, `reinstall.sh`, `list.sh`, `cli/jinx.sh`
8. Update README

## [S3] Out of Scope
- Adding new Android tools beyond java/kotlin
- Refactoring the static dispatch system (discussed, rejected)
- Version bump

## Tasks
- [x] T1: Move tool dirs and fix kotlin import + LOG_FILE paths — acceptance: `jinx/tools/android/{java,kotlin}/install.sh` exist, kotlin imports `@/tools/android/java/install`, both use `install_android.log` (covers: S2)
- [x] T2: Create `jinx/tools/android/all.sh` — acceptance: array has java+kotlin, all 4 all-functions dispatch correctly (covers: S2; depends: T1)
- [x] T3: Create `jinx/modules/android.sh` — acceptance: install/uninstall/update/reinstall wrappers import tools/android/all (covers: S2; depends: T2)
- [x] T4: Clean `jinx/tools/lang/all.sh` — acceptance: java/kotlin removed from array, sources, and 4 case blocks; `bash -n` passes (covers: S2)
- [x] T5: Update CLI install.sh — acceptance: android registered in full-module, specific-tools, and interactive cases; java/kotlin removed from lang case (covers: S2; depends: T4)
- [x] T6: Update CLI update/uninstall/reinstall.sh — acceptance: android registered in each, java/kotlin absent from lang (covers: S2)
- [x] T7: Update list.sh and cli/jinx.sh — acceptance: `_list_android` exists, `jinx list android` works, help shows android (covers: S2)
- [x] T8: Update README — acceptance: lang table has no java/kotlin, android section lists both (covers: S2)
- [x] T9: Verify all commands — acceptance: `bash -n` on all touched files, cross-check dispatch tables (covers: S2; depends: T5, T6, T7)
