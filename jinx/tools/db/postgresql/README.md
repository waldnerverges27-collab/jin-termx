# PostgreSQL

Advanced open-source relational database

**Package:** postgresql  
**Author:** DevCoreX  
**Repository:** https://github.com/waldnerverges27-collab/jin-termx  
**Official:** https://www.postgresql.org  
**Type:** Database (pkg)  
**License:** PostgreSQL License

## Description

PostgreSQL is a powerful, open-source object-relational database system with over 30 years of active development. It has a strong reputation for reliability, feature robustness, and performance. Jin-TermX includes a dedicated manager (`jinx pg`) for starting, stopping, and managing PostgreSQL instances.

## Dependencies

- Installed via pkg
- Data directory managed by `jinx pg`

## Install

```bash
jinx install db --postgresql
```

## Uninstall

```bash
jinx uninstall db --postgresql
```

## Update

```bash
jinx update db --postgresql
```

## Notes

- Managed via `jinx pg` commands (start, stop, restart, status, init, create, drop, list, shell)
- Logs: `~/.cache/jin-termx/postgresql.log`
- Automatic data directory detection
- Support for existing installations

