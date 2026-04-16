#!/bin/bash
# tests/test-permissions.sh - Testa permissões dos arquivos instalados

set -e

echo "=== Teste de Permissões ==="
echo

CONFIG_PKG="dist/emacs-a11y-config_0.1.0_all.deb"
LAUNCHERS_PKG="dist/emacs-a11y-launchers_0.1.0_all.deb"

if [ ! -f "$CONFIG_PKG" ] || [ ! -f "$LAUNCHERS_PKG" ]; then
  echo "❌ Pacotes não encontrados"
  exit 1
fi

echo "✓ Testando permissões em Docker..."
echo

docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -c "
    set -e
    apt-get update -qq
    apt-get install -y -qq emacs-nox bash

    echo 'Instalando pacotes...'
    apt-get install -y ./dist/emacs-a11y-config_0.1.0_all.deb > /dev/null 2>&1
    apt-get install -y ./dist/emacs-a11y-launchers_0.1.0_all.deb > /dev/null 2>&1

    echo 'Verificando permissões dos scripts...'

    # Teste de executabilidade
    if [ -x /usr/share/a11y-emacs/emacs-a11y.sh ]; then
      echo '✓ emacs-a11y.sh é executável'
    else
      echo '❌ emacs-a11y.sh não é executável'
      exit 1
    fi

    if [ -x /usr/share/a11y-emacs/espeakup-start.sh ]; then
      echo '✓ espeakup-start.sh é executável'
    else
      echo '❌ espeakup-start.sh não é executável'
      exit 1
    fi

    if [ -x /usr/share/a11y-emacs/espeakup-stop.sh ]; then
      echo '✓ espeakup-stop.sh é executável'
    else
      echo '❌ espeakup-stop.sh não é executável'
      exit 1
    fi

    echo
    echo 'Permissões dos arquivos:'
    ls -lh /usr/share/a11y-emacs/ | tail -n +2

    echo
    echo '✓ Todas as permissões estão corretas!'
  "

echo
echo "✅ Teste de permissões concluído com sucesso!"
