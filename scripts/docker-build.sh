#!/usr/bin/env bash
# docker-build.sh - Constrói pacotes .deb em container Docker
#
# Uso: ./scripts/docker-build.sh [PACKAGE_NAME] [VERSION]

set -euo pipefail

PACKAGE_NAME="${1:-emacs-a11y-config}"
VERSION="${2:-0.1.0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Docker Build: $PACKAGE_NAME v$VERSION ==="
echo

docker run --rm \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    echo 'Atualizando índice de pacotes...'
    apt-get update
    apt-get install -y --no-install-recommends dpkg-dev fakeroot file

    echo
    echo 'Validando estrutura do pacote...'
    bash scripts/check-package-layout.sh

    echo
    echo 'Construindo pacote...'
    mkdir -p dist
    dpkg-deb --build packages/$PACKAGE_NAME dist/${PACKAGE_NAME}_${VERSION}_all.deb

    echo
    echo '=== Pacote gerado com sucesso ==='
    ls -lh dist/${PACKAGE_NAME}_${VERSION}_all.deb
    echo
    file dist/${PACKAGE_NAME}_${VERSION}_all.deb
  "
