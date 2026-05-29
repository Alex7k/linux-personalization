#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  TARGET_USER="${USER_NAME:-$(id -un)}"
  exec sudo env USER_NAME="${TARGET_USER}" bash "$0" "$@"
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}"

USER_NAME="${USER_NAME:-node}"
KEYS_FILE="${REPO_ROOT}/configs/ssh/alex_authorized_keys"
SSHD_DROPIN_SRC="${REPO_ROOT}/configs/ssh/99-custom.conf"
SSHD_DROPIN_DST="/etc/ssh/sshd_config.d/99-custom.conf"

apt update
apt upgrade -y
apt install -y sudo neovim openssh-server zsh

if ! id -u "${USER_NAME}" >/dev/null 2>&1; then
  # Non-interactive user creation; access is provided via SSH keys.
  adduser --disabled-password --gecos "" "${USER_NAME}"
fi

USER_HOME="$(getent passwd "${USER_NAME}" | cut -d: -f6)"
usermod -aG sudo "${USER_NAME}"
usermod -s "$(command -v zsh)" "${USER_NAME}"
if [[ ! -e "${USER_HOME}/.zshrc" ]]; then
  install -m 644 -o "${USER_NAME}" -g "${USER_NAME}" /dev/null "${USER_HOME}/.zshrc"
fi
PASSWORD_STATUS="$(passwd -S "${USER_NAME}" | awk '{print $2}')"
if [[ "${PASSWORD_STATUS}" != "P" ]]; then
  echo "Set a password for ${USER_NAME}:"
  passwd "${USER_NAME}"
fi
echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER_NAME}"
chmod 0440 "/etc/sudoers.d/${USER_NAME}"
visudo -cf "/etc/sudoers.d/${USER_NAME}"

install -d -m 700 -o "${USER_NAME}" -g "${USER_NAME}" "${USER_HOME}/.ssh"
AUTHORIZED_KEYS="${USER_HOME}/.ssh/authorized_keys"
touch "${AUTHORIZED_KEYS}"
chown "${USER_NAME}:${USER_NAME}" "${AUTHORIZED_KEYS}"
chmod 600 "${AUTHORIZED_KEYS}"
while IFS= read -r key || [[ -n "${key}" ]]; do
  [[ -z "${key}" ]] && continue
  if ! grep -Fxq -- "${key}" "${AUTHORIZED_KEYS}"; then
    printf '%s\n' "${key}" >> "${AUTHORIZED_KEYS}"
  fi
done < "${KEYS_FILE}"
chown "${USER_NAME}:${USER_NAME}" "${AUTHORIZED_KEYS}"
chmod 600 "${AUTHORIZED_KEYS}"

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
