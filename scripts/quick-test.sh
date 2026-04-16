#!/usr/bin/env bash
# quick-test.sh - Teste rápido da estrutura de pacotes
#
# Valida, constrói e testa pacotes em sequência

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Teste Rápido - Emacs A11y Packaging                      ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# 1. Validação
echo "▶ Passo 1: Validando estrutura de pacotes..."
bash scripts/check-package-layout.sh
echo "✓ Validação concluída"
echo

# 2. Build
echo "▶ Passo 2: Construindo pacotes em Docker..."
make docker-build
echo

# 3. Teste
echo "▶ Passo 3: Testando instalação em Docker..."
make docker-test
echo

echo "════════════════════════════════════════════════════════════"
echo "✓ Teste rápido concluído com sucesso!"
echo
echo "Artefatos gerados:"
ls -lh dist/
echo
echo "Próximas etapas:"
echo "  - Editar configurações em packages/*/usr/share/a11y-emacs/"
echo "  - Executar 'make docker-build' novamente"
echo "  - Testar em VM Debian/Ubuntu real"
