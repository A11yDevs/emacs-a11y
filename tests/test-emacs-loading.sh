#!/bin/bash
# tests/test-emacs-loading.sh - Testa carregamento do init.el no Emacs

set -e

echo "=== Teste de Carregamento do Emacs ==="
echo

CONFIG_PKG="dist/emacs-a11y-config_0.1.0_all.deb"

if [ ! -f "$CONFIG_PKG" ]; then
  echo "❌ Pacote não encontrado: $CONFIG_PKG"
  exit 1
fi

echo "✓ Testando carregamento de init.el em Docker..."
echo

docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -c "
    set -e
    apt-get update -qq
    apt-get install -y -qq emacs-nox bash

    echo 'Instalando pacote...'
    apt-get install -y ./dist/emacs-a11y-config_0.1.0_all.deb > /dev/null 2>&1

    echo 'Testando carregamento de init.el...'
    emacs -Q --batch \
      --load /usr/share/a11y-emacs/init.el \
      --eval '(princ \"✓ init.el carregado com sucesso\n\")' \
      --eval '(princ (format \"  Emacs version: %s\n\" emacs-version))' \
      --eval '(princ (format \"  Configuração em: /usr/share/a11y-emacs\n\"))'

    echo
    echo '✓ Teste concluído!'
  "

echo
echo "✅ Carregamento de init.el funcionando corretamente!"
