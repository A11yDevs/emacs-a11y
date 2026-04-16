#!/bin/bash
# espeakup-stop.sh - Para o servidor espeakup antes de iniciar o Emacs
#
# Útil quando o leitor de tela espeakup está rodando e você quer
# usar o Emacs com um leitor de tela diferente ou sem feedback auditivo

set -e

# Tenta parar o espeakup
if pgrep -x espeakup > /dev/null; then
    echo "Parando servidor espeakup..."
    sudo systemctl stop espeakup 2>/dev/null || \
    killall espeakup 2>/dev/null || \
    echo "Aviso: Não foi possível parar espeakup. Tente com sudo."
else
    echo "espeakup não está em execução"
fi
