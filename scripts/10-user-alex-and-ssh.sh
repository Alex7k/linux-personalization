#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script as root."
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"

USER_NAME="alex"
KEYS_FILE="${REPO_ROOT}/configs/ssh/alex_authorized_keys"
SSHD_DROPIN_SRC="${REPO_ROOT}/configs/ssh/99-custom.conf"
SSHD_DROPIN_DST="/etc/ssh/sshd_config.d/99-custom.conf"

apt update
apt upgrade -y
apt install -y sudo neovim openssh-server zsh

if ! id -u "${USER_NAME}" >/dev/null 2>&1; then
  adduser --gecos "" "${USER_NAME}"
fi

usermod -aG sudo "${USER_NAME}"
usermod -s "$(command -v zsh)" "${USER_NAME}"
echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_NAME}"
chmod 0440 "/etc/sudoers.d/${USER_NAME}"
visudo -cf "/etc/sudoers.d/${USER_NAME}"

install -d -m 700 -o "${USER_NAME}" -g "${USER_NAME}" "/home/${USER_NAME}/.ssh"
install -m 600 -o "${USER_NAME}" -g "${USER_NAME}" "${KEYS_FILE}" "/home/${USER_NAME}/.ssh/authorized_keys"

install -d -m 755 /etc/ssh/sshd_config.d
install -m 644 "${SSHD_DROPIN_SRC}" "${SSHD_DROPIN_DST}"

if systemctl list-unit-files | grep -q '^sshd\.service'; then
  SSH_SERVICE="sshd"
else
  SSH_SERVICE="ssh"
fi

systemctl enable --now "${SSH_SERVICE}"
sshd -t
systemctl reload "${SSH_SERVICE}"
