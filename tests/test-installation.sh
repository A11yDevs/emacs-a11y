#!/bin/bash
# tests/test-installation.sh - Testa instalação dos pacotes Debian

set -e

echo "=== Teste de Instalação de Pacotes ==="
echo

# Variáveis
CONFIG_PKG="dist/emacs-a11y-config_0.1.0_all.deb"
LAUNCHERS_PKG="dist/emacs-a11y-launchers_0.1.0_all.deb"

# Verificar se pacotes existem
if [ ! -f "$CONFIG_PKG" ]; then
  echo "❌ Pacote não encontrado: $CONFIG_PKG"
  echo "   Execute: scripts/quick-test.sh ou make docker-build"
  exit 1
fi

if [ ! -f "$LAUNCHERS_PKG" ]; then
  echo "❌ Pacote não encontrado: $LAUNCHERS_PKG"
  exit 1
fi

echo "✓ Pacotes encontrados"
echo "  - $CONFIG_PKG"
echo "  - $LAUNCHERS_PKG"
echo

# Teste em Docker
docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -c "
    set -e
    apt-get update -qq
    apt-get install -y -qq dpkg emacs-nox bash

    echo '◆ Instalando emacs-a11y-config...'
    apt-get install -y ./dist/emacs-a11y-config_0.1.0_all.deb

    echo '◆ Verificando instalação...'
    if [ -d /usr/share/a11y-emacs ]; then
      echo '✓ Diretório /usr/share/a11y-emacs criado'
      echo '✓ Arquivos instalados:'
      find /usr/share/a11y-emacs -type f | sed 's/^/  - /'
    else
      echo '❌ Diretório não encontrado!'
      exit 1
    fi

    echo
    echo '◆ Instalando emacs-a11y-launchers...'
    apt-get install -y ./dist/emacs-a11y-launchers_0.1.0_all.deb

    echo '✓ Ambos os pacotes instalados com sucesso'
  "

echo
echo "✅ Teste de instalação concluído com sucesso!"
