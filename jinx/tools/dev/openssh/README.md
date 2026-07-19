# OpenSSH

SSH server and client for secure remote access

**Package:** openssh  
**Author:** JinDev  
**Repository:** https://github.com/waldnerverges27-collab/jin-termx  
**Official:** https://www.openssh.com  
**Type:** Development tool (pkg)  
**License:** BSD

## Description

OpenSSH provides both SSH client (`ssh`) and server (`sshd`) for encrypted remote connections, file transfers, and port forwarding. On Termux, it enables connecting to remote servers and running an SSH server locally.

## Dependencies

- Installed via pkg

## Install

```bash
jinx install dev --openssh
```

## Uninstall

```bash
jinx uninstall dev --openssh
```

## Update

```bash
jinx update dev --openssh
```

## Notes

- SSH client: `ssh`
- SSH server: `sshd` (start with `sshd -D`)
- Config: `$PREFIX/etc/ssh/`
- Default port: 8022 (non-privileged, avoids conflicts)
