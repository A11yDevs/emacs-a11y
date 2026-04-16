#!/usr/bin/env bash
# check-package-layout.sh - Valida estrutura de pacotes Debian

set -euo pipefail

ERRORS=0

check_package() {
    local pkg_dir="$1"

    if [ ! -d "$pkg_dir" ]; then
        echo "❌ Diretório não encontrado: $pkg_dir"
        ((ERRORS++))
        return 1
    fi

    # Verifica DEBIAN/control
    if [ ! -f "$pkg_dir/DEBIAN/control" ]; then
        echo "❌ Falta DEBIAN/control em $pkg_dir"
        ((ERRORS++))
    else
        echo "✓ $pkg_dir/DEBIAN/control"
    fi

    # Verifica DEBIAN/postinst
    if [ ! -f "$pkg_dir/DEBIAN/postinst" ]; then
        echo "⚠ Sem DEBIAN/postinst em $pkg_dir (opcional)"
    else
        echo "✓ $pkg_dir/DEBIAN/postinst"

        # Verifica permissões de execução
        if [ ! -x "$pkg_dir/DEBIAN/postinst" ]; then
            echo "  ⚠ postinst não tem permissão de execução"
        fi
    fi

    return $((ERRORS > 0 ? 1 : 0))
}

echo "=== Validando estrutura de pacotes ==="
echo

check_package "packages/emacs-a11y-config"
echo
check_package "packages/emacs-a11y-launchers"
echo

if [ $ERRORS -eq 0 ]; then
    echo "✓ Todos os pacotes estão válidos!"
    exit 0
else
    echo "❌ Encontrados $ERRORS erro(s)"
    exit 1
fi
