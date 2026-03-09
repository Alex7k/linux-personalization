# Linux Personalization

I use this repository to document configurations that I like to apply on any linux machine I work on.

## Structure

- `10-create-user-with-ssh.sh`: install user/SSH prerequisites (`sudo`, `neovim`, `openssh-server`), create/configure user `alex`, apply sudoers, install SSH authorized keys, and apply sshd hardening drop-in.
- `20-user-configuration.sh`: install packages/tools, configure git, zsh plugins.
- `30-install-docker.sh`: install Docker.
- `40-tailscale.sh`: install/configure Tailscale.
- `configs/ssh/alex_authorized_keys`: pubkeys
- `configs/ssh/99-custom.conf`: sshd settings overrides

## Usage

1. `apt update; apt upgrade; apt install git`
1. `git clone https://github.com/Alex7k/linux-personalization /tmp/linux-personalization && cd /tmp/linux-personalization`
1. Run user and SSH provisioning as root:
   `sudo bash ./10-create-user-with-ssh.sh`
1. Switch to your user: `su - alex`
> [!IMPORTANT]
> If you see the Zsh first-run wizard, press `q` to quit it and continue.
> This repository configures Zsh for you.
1. Run workstation setup as your user:
   `bash ./20-user-configuration.sh`
1. Optional: install Docker:
   `bash ./30-docker.sh`
1. Optional: set up Tailscale:
   `bash ./40-tailscale.sh`

Adjust `packages.txt` and `configs/ssh/alex_authorized_keys` as needed before running.
