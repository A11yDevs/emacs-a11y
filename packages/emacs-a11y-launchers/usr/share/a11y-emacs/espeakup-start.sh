#!/bin/bash
# espeakup-start.sh - Reinicia o servidor espeakup após sair do Emacs
#
# Complemento para espeakup-stop.sh

set -e

# Tenta reiniciar o espeakup
echo "Reiniciando servidor espeakup..."
if sudo systemctl start espeakup 2>/dev/null; then
    echo "espeakup reiniciado com sucesso"
else
    killall -9 espeakup 2>/dev/null && sleep 1
    espeakup &
    echo "espeakup iniciado"
fi
