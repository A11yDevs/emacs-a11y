#!/bin/bash
# emacs-a11y.sh - Lançador principal para Emacs A11y
#
# Este script:
#   1. Para o servidor espeakup (se rodando)
#   2. Inicia o Emacs com a configuração acessível do a11y-emacs
#   3. Reinicia o servidor espeakup após o Emacs fechar

set -e

# Diretório base da configuração
A11Y_EMACS_HOME="/usr/share/a11y-emacs"
A11Y_EMACS_INIT="${A11Y_EMACS_HOME}/init.el"

# Garante que o arquivo init.el existe
if [ ! -f "${A11Y_EMACS_INIT}" ]; then
    echo "Erro: Configuração do a11y-emacs não encontrada em ${A11Y_EMACS_INIT}"
    exit 1
fi

# Função para parar espeakup antes de iniciar emacs
stop_espeakup() {
    if pgrep -x espeakup > /dev/null 2>&1; then
        echo "Parando servidor espeakup..."
        sudo systemctl stop espeakup 2>/dev/null || \
        killall espeakup 2>/dev/null || \
        echo "Aviso: Não foi possível parar espeakup"
    fi
}

# Função para reiniciar espeakup após fechar emacs
start_espeakup() {
    echo "Reiniciando servidor espeakup..."
    if sudo systemctl start espeakup 2>/dev/null; then
        echo "espeakup reiniciado com sucesso"
    else
        espeakup &
        echo "espeakup iniciado em background"
    fi
}

# Trap para reiniciar espeakup quando o script terminar (qualquer motivo)
trap start_espeakup EXIT

# Para o espeakup antes de iniciar emacs
stop_espeakup

# Argumentos padrão
# Usa emacs-nox se disponível (sem suporte a GUI)
EMACS_CMD="emacs"
if command -v emacs-nox &> /dev/null; then
    EMACS_CMD="emacs-nox"
fi

# Passa os argumentos do usuário para o Emacs
# O init.el será carregado automaticamente via ~/.emacs.d/init.el ou -l
"${EMACS_CMD}" -l "${A11Y_EMACS_INIT}" "$@"
