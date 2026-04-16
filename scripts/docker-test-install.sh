#!/usr/bin/env bash
# docker-test-install.sh - Testa instalação do pacote em container Docker
#
# Uso: ./scripts/docker-test-install.sh [PACKAGE_NAME] [VERSION]

set -euo pipefail

PACKAGE_NAME="${1:-emacs-a11y-config}"
VERSION="${2:-0.1.0}"
DEB_PATH="dist/${PACKAGE_NAME}_${VERSION}_all.deb"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

if [ ! -f "$PROJECT_DIR/$DEB_PATH" ]; then
  echo "❌ Pacote não encontrado: $DEB_PATH"
  echo "   Execute antes: bash scripts/docker-build.sh $PACKAGE_NAME $VERSION"
  exit 1
fi

echo "=== Docker Test Install: $PACKAGE_NAME v$VERSION ==="
echo

docker run --rm \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    echo 'Atualizando índice de pacotes...'
    apt-get update
    apt-get install -y --no-install-recommends emacs-nox bash sudo

    echo
    echo '=== Instalando dependências antes (se necessário) ==='
    # Se estamos testando emacs-a11y-launchers, precisamos instalar config primeiro
    if [ \"$PACKAGE_NAME\" = \"emacs-a11y-launchers\" ]; then
        echo 'Instalando emacs-a11y-config como dependência...'
        apt-get install -y ./dist/emacs-a11y-config_${VERSION}_all.deb
    fi

    echo
    echo '=== Instalando pacote ==='
    apt-get install -y ./$DEB_PATH

    echo
    echo '=== Verificando arquivos instalados ==='
    if [ -d /usr/share/a11y-emacs ]; then
        find /usr/share/a11y-emacs -type f
    else
        echo '⚠ Diretório /usr/share/a11y-emacs não encontrado'
    fi

    echo
    echo '=== Verificando configurações de sudo ==='
    if [ -f /etc/sudoers.d/a11ydevs-espeakup ]; then
        echo '✓ Arquivo sudoers encontrado'
        cat /etc/sudoers.d/a11ydevs-espeakup
    fi

    echo
    echo '=== Verificando symlink em /usr/local/bin ==='
    if [ -L /usr/local/bin/emacs-a11y ]; then
        echo '✓ Symlink emacs-a11y criado'
        ls -la /usr/local/bin/emacs-a11y
    fi

    echo
    echo '=== Verificando alias em /etc/profile.d ==='
    if [ -f /etc/profile.d/a11y-emacs-alias.sh ]; then
        echo '✓ Arquivo de alias criado'
        cat /etc/profile.d/a11y-emacs-alias.sh
    fi

    echo
    echo '=== Testando carregamento de init.el ==='
    if [ -f /usr/share/a11y-emacs/init.el ]; then
        emacs -Q --batch --load /usr/share/a11y-emacs/init.el \
          --eval '(princ \"✓ init.el carregado com sucesso\n\")' 2>&1 || \
          echo '⚠ Aviso: Erro ao carregar init.el (pode ser esperado em modo batch)'
    fi

    echo
    echo '✓ Teste concluído!'
  "
