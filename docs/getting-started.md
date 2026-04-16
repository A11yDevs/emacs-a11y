# Guia de Início Rápido

## 0️⃣ Prerequisitos

- **Docker** (recomendado para isolamento) - ou `dpkg-deb` localmente
- **bash** 4.0+
- git (opcional, para controle de versão)

## 1️⃣ Validação Inicial

Verifica se a estrutura de pacotes está correta:

```bash
make check
```

**Esperado:**
```
✓ packages/a11y-emacs-config/DEBIAN/control
✓ packages/a11y-emacs-config/DEBIAN/postinst
✓ packages/a11y-emacs-launchers/DEBIAN/control
✓ packages/a11y-emacs-launchers/DEBIAN/postinst
✓ Todos os pacotes estão válidos!
```

---

## 2️⃣ Construir Pacotes

### Opção A: Em Docker (recomendado)

Sem dependências locais, isolado:

```bash
make docker-build-config
```

**Saída esperada:**
```
=== Docker Build: a11y-emacs-config v0.1.0 ===
...
✓ Pacote gerado: dist/a11y-emacs-config_0.1.0_all.deb
```

### Opção B: Localmente

Requer `dpkg-deb` instalado:

```bash
make build-config
```

---

## 3️⃣ Testar Instalação

Testa o pacote em um container Debian limpo:

```bash
make docker-test-config
```

**Valida:**
- Arquivo extraído corretamente
- `init.el` carrega sem erros
- Hooks executados corretamente

---

## 4️⃣ Arquivos Gerados

Os pacotes `.deb` ficam em:

```bash
ls -lh dist/
# dist/a11y-emacs-config_0.1.0_all.deb
# dist/a11y-emacs-launchers_0.1.0_all.deb
```

---

## Fluxo Completo (Um Comando)

```bash
bash quick-test.sh
```

Executa sequencialmente:
1. Validação
2. Build em Docker
3. Testes em Docker

---

## 📝 Editar Configurações

### Adicionar um novo módulo Lisp

Exemplo: `init-shell.el`

1. **Criar arquivo:**
```bash
cat > packages/a11y-emacs-config/usr/share/a11y-emacs/lisp/init-shell.el << 'EOF'
;;; init-shell.el --- Shell e terminal

(provide 'init-shell)

;; Suas configurações aqui
EOF
```

2. **Carregar no init.el:**

Edite `packages/a11y-emacs-config/usr/share/a11y-emacs/init.el`:

```elisp
(require 'init-navigation nil t)
(require 'init-shell nil t)  ;; ← Adicione esta linha
```

3. **Rebuild:**
```bash
make docker-build
```

---

## 🐛 Troubleshooting

### "Pacote não encontrado"
```bash
# Certifique-se de ter buildado:
make docker-build
make docker-test
```

### "Comando docker não encontrado"
Instale Docker ou use `make build` em vez de `make docker-build`

### "Erro de permissão em postinst"
```bash
chmod +x packages/*/DEBIAN/postinst
```

### "init.el não carrega"
Valide sintaxe:
```bash
emacs -Q --batch --load packages/a11y-emacs-config/usr/share/a11y-emacs/init.el
```

---

## 📚 Recursos

| Documento | Propósito |
|-----------|-----------|
| `PACKAGE-BUILD.md` | Guia completo de build |
| `STRUCTURE-SUMMARY.md` | Resumo da estrutura criada |
| `constitution.txt` | Diretrizes do projeto |
| `ideas.md` | Arquitetura proposta |

---

## ✅ Próximo Passo

Após ter sucesso com build e teste:

1. **Testar em VM real:**
   ```bash
   # Cria VM Debian/Ubuntu
   # Instala: sudo dpkg -i dist/*.deb
   # Testa: emacs-a11y
   ```

2. **Adicionar mais módulos:**
   - `init-dired.el` - File browser
   - `init-java.el` - Desenvolvimento
   - etc...

3. **Criar repositório APT** (depois)

---

✓ **Você está pronto para começar a desenvolver!**
