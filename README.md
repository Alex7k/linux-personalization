# Linux Personalization

I use this repository to document configurations that I like to apply on any linux machine I work on.

## Structure

- `scripts/10-user-alex-and-ssh.sh`: install user/SSH prerequisites (`sudo`, `neovim`, `openssh-server`), create/configure user `alex`, apply sudoers, install SSH authorized keys, and apply sshd hardening drop-in.
- `scripts/20-workstation-setup.sh`: install packages/tools, configure git, Docker, zsh plugins.
- `configs/ssh/alex_authorized_keys`: pubkeys
- `configs/ssh/99-custom.conf`: sshd settings overrides

## Backward-Compatible Entrypoints

- `./setup-user-alex-and-ssh` -> wraps `scripts/10-user-alex-and-ssh.sh`
- `./setup` -> wraps `scripts/20-workstation-setup.sh`

## Usage

1. Run user and SSH provisioning as root:
   `sudo bash ./setup-user-alex-and-ssh`
2. Run workstation setup as your user:
   `bash ./setup`

Adjust `packages.txt` and `configs/ssh/alex_authorized_keys` as needed before running.
