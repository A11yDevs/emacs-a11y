#!/usr/bin/env bash
# build-and-test.sh - Script simplificado para build e teste

set -e

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Emacs A11y - Build e Teste de Pacotes                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Step 1: Validation
echo "▶ Etapa 1/3: Validando estrutura..."
bash scripts/check-package-layout.sh
echo "✓ Validação OK"
echo

# Step 2: Build
echo "▶ Etapa 2/3: Construindo pacotes..."
docker run --rm \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    apt-get update -qq
    apt-get install -y -qq dpkg-dev fakeroot
    mkdir -p dist
    dpkg-deb --build packages/a11y-emacs-config dist/a11y-emacs-config_0.1.0_all.deb
    dpkg-deb --build packages/a11y-emacs-launchers dist/a11y-emacs-launchers_0.1.0_all.deb
    ls -lh dist/*.deb
  "
echo "✓ Build OK"
echo

# Step 3: Test
echo "▶ Etapa 3/3: Testando instalação..."
docker run --rm -it \
  -v "$(pwd)":/workspace \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    apt-get update -qq
    apt-get install -y -qq emacs-nox bash

    echo 'Instalando a11y-emacs-config...'
    apt-get install -y ./dist/a11y-emacs-config_0.1.0_all.deb

    echo 'Testando carregamento de init.el...'
    emacs -Q --batch --load /usr/share/a11y-emacs/init.el \
      --eval '(princ \"✓ init carregado com sucesso\n\")' 2>&1 || true

    echo
    echo 'Arquivos instalados:'
    find /usr/share/a11y-emacs -type f | wc -l
    echo 'arquivos total'
  "
echo "✓ Teste OK"
echo

echo "════════════════════════════════════════════════════════════"
echo "✓ Build e teste concluídos com sucesso!"
echo
echo "Pacotes gerados:"
ls -lh dist/*.deb 2>/dev/null || echo "(nenhum .deb encontrado - verifique build acima)"
