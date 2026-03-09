#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  echo "Do not run this script as root. Run it as your normal user."
  exit 1
fi

curl -fsSL https://get.docker.com | sudo sh
