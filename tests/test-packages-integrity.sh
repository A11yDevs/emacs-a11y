#!/bin/bash
# tests/test-packages-integrity.sh - Valida integridade e funcionamento dos pacotes .deb

set -euo pipefail

echo "=== Teste de Integridade e Funcionamento dos Pacotes ==="
echo

find_latest_pkg() {
  local pattern="$1"
  local latest

  latest="$(ls -1 dist/${pattern}_*_all.deb 2>/dev/null | sort -V | tail -n 1 || true)"
  if [[ -z "${latest}" ]]; then
    echo ""
    return
  fi

  echo "${latest}"
}

CONFIG_PKG="$(find_latest_pkg emacs-a11y-config)"
LAUNCHERS_PKG="$(find_latest_pkg emacs-a11y-launchers)"

if [[ -z "${CONFIG_PKG}" || -z "${LAUNCHERS_PKG}" ]]; then
  echo "❌ Pacotes .deb não encontrados em dist/."
  echo "   Gere os pacotes antes de testar (ex.: make build VERSION=0.1.0)."
  exit 1
fi

echo "✓ Pacotes encontrados:"
echo "  - ${CONFIG_PKG}"
echo "  - ${LAUNCHERS_PKG}"
echo

echo "◆ Verificando metadados e estrutura dos pacotes..."
for pkg in "${CONFIG_PKG}" "${LAUNCHERS_PKG}"; do
  echo "  > $(basename "${pkg}")"
  dpkg-deb --info "${pkg}" >/dev/null
  dpkg-deb --contents "${pkg}" >/dev/null
done
echo "✓ Metadados e estrutura válidos"
echo

echo "◆ Hash SHA256 dos pacotes:"
sha256sum "${CONFIG_PKG}" "${LAUNCHERS_PKG}" | sed 's/^/  /'
echo

echo "◆ Validando instalação e carregamento em Docker..."
docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -c "
    set -euo pipefail
    apt-get update -qq
    apt-get install -y -qq emacs-nox bash

    apt-get install -y ./$(printf '%q' "${CONFIG_PKG}") ./$(printf '%q' "${LAUNCHERS_PKG}")

    dpkg-query -W emacs-a11y-config emacs-a11y-launchers >/dev/null

    test -f /usr/share/a11y-emacs/init.el
    test -x /usr/share/a11y-emacs/emacs-a11y.sh
    test -x /usr/share/a11y-emacs/espeakup-start.sh
    test -x /usr/share/a11y-emacs/espeakup-stop.sh

    emacs -Q --batch \
      --load /usr/share/a11y-emacs/init.el \
      --eval '(princ "init-ok\n")' >/tmp/emacs-a11y-load.log

    grep -q '^init-ok$' /tmp/emacs-a11y-load.log
    echo '✓ Instalação e carregamento validados no container'
  "

echo
echo "✅ Integridade e funcionamento dos pacotes validados com sucesso"
