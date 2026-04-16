# Guia de Expansão e Customização

Este documento descreve como expandir a estrutura para adicionar novos módulos, pacotes e funcionalidades.

## 1. Adicionar Módulos Lisp

Os módulos Lisp ficam em `packages/a11y-emacs-config/usr/share/a11y-emacs/lisp/`.

### Exemplo: Criar `init-dired.el`

**1. Criar arquivo:**
```bash
cat > packages/a11y-emacs-config/usr/share/a11y-emacs/lisp/init-dired.el << 'EOF'
;;; init-dired.el --- Configurações para Dired (file browser)
;;;
;;; Otimizações para acessibilidade e navegação em diretórios

(provide 'init-dired)

;; Habilita o-dired para output amigável
(add-hook 'dired-mode-hook
  (lambda ()
    (dired-hide-details-mode 1)))

;; Atalhos melhorados para navegação
(define-key dired-mode-map (kbd "C-c u") 'dired-up-directory)
(define-key dired-mode-map (kbd "C-c d") 'dired-find-file)

;; Preview de arquivos
(setq dired-listing-switches "-lhS")
EOF
```

**2. Registrar no `init.el`:**

Edite `packages/a11y-emacs-config/usr/share/a11y-emacs/init.el`:

```elisp
(require 'init-navigation nil t)
(require 'init-dired nil t)  ;; ← Adicione aqui
```

**3. Rebuild:**
```bash
make docker-build
make docker-test
```

---

## 2. Adicionar Novo Pacote `.deb`

Exemplo: Pacote `a11y-emacs-java` para desenvolvimento Java.

### Estrutura

```
packages/a11y-emacs-java/
├── DEBIAN/
│   ├── control
│   └── postinst
└── usr/share/a11y-emacs/
    └── lisp/
        ├── init-java.el
        └── init-java-lsp.el
```

### DEBIAN/control

```
Package: a11y-emacs-java
Version: 0.1.0
Architecture: all
Depends: a11y-emacs-config
Maintainer: Seu Nome <seu.email@example.com>
Description: Configurações de desenvolvimento Java para Emacs A11y
 Inclui integração com LSP (Language Server Protocol),
 formatação código, debugging e ferramentas úteis.
```

### DEBIAN/postinst

```bash
#!/bin/bash
set -e

case "$1" in
    configure)
        echo "Configurando a11y-emacs-java..."
        ;; 
esac

exit 0
```

### Registrar no Makefile

Edite `Makefile`:

```makefile
JAVA_PACKAGE := a11y-emacs-java

# Adicione targets:
docker-build-java:
	@bash scripts/docker-build.sh $(JAVA_PACKAGE) $(VERSION)

docker-test-java: docker-build-java
	@bash scripts/docker-test-install.sh $(JAVA_PACKAGE) $(VERSION)
```

---

## 3. Adicionar Configurações de Usuário

Usuários podem customizar em `~/.config/a11y-emacs/user-init.el`:

```elisp
;;; ~/.config/a11y-emacs/user-init.el

;; Tema customizado
(setq custom-theme "modus-vivendi")

;; Atalhos pessoais
(global-set-key (kbd "C-x C-j") 'my-jump-to-project)

;; Função customizada
(defun my-jump-to-project ()
  (interactive)
  (dired "~/projects/"))
```

Este arquivo é carregado automaticamente após a configuração principal.

---

## 4. Adicionar Documentação de Usuário

Crie pacote `a11y-emacs-docs`:

```
packages/a11y-emacs-docs/
├── DEBIAN/
│   └── control
└── usr/share/doc/a11y-emacs/
    ├── guia-instalacao.md
    ├── guia-uso.md
    ├── guia-atualizacao.md
    └── exemplos/
```

**Adicione ao DEBIAN/control:**
```
Suggests: a11y-emacs-config
```

---

## 5. Atualizar Versão

Ao fazer mudanças, atualize a versão:

### Incrementar versão do projeto

Edite `Makefile`:
```makefile
VERSION := 0.2.0  # ← Aumente de 0.1.0 para 0.2.0
```

### Incrementar versão de pacote individual

Edite `/DEBIAN/control`:
```
Version: 0.2.0    # ← Aumente aqui também
```

---

## 6. Validação e Testes

### Validar antes de build

```bash
make check
```

### Testar novo módulo

```bash
bash scripts/docker-test-install.sh a11y-emacs-config 0.2.0
```

### Teste manual em shell Docker

```bash
make shell
# Dentro do container:
cd /workspace
make check
make docker-build
```

---

## 7. Adicionar Overlay Adicional

Adicione arquivos que você quer provisionar para novos usuários em `overlay/`:

```
overlay/
├── etc/skel/.emacs.d/
│   ├── init.el
│   └── early-init.el
└── etc/
    └── profile.d/
        └── a11y-emacs.sh  ;; ← Novo arquivo
```

Ele será instalado em `/etc/profile.d/` para scripts de inicialização.

---

## 8. Configurar CI/CD (GitHub Actions)

Crie `.github/workflows/build.yml`:

```yaml
name: Build Packages

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: bash quick-test.sh
```

---

## 9. Publicar Repositório APT

### Criar repositório local

```bash
mkdir -p repo/pool/main

# Copiar .deb
cp dist/*.deb repo/pool/main/

# Gerar índice
cd repo
apt-ftparchive packages pool > Packages
apt-ftparchive sources . > Sources
```

### Usar em VM

```bash
echo "deb file:///path/to/repo /" | sudo tee /etc/apt/sources.list.d/a11y-emacs.list
sudo apt update
sudo apt install a11y-emacs-config
```

---

## 10. Processo de Desenvolvimento Recomendado

```
1. Editar módulos localmente              (macOS/Linux)
2. make docker-build                      (Validar em Debian)
3. make docker-test                       (Testar em Debian)
4. Commit e push to git                   (Version control)
5. Testar em VM Debian/Ubuntu real        (Final validation)
6. Publicar em repositório APT            (Distribution)
7. Atualizar versão para próximo release  (Prepare next)
```

---

## Checklist de Expansão

- [ ] Novo módulo criado em `lisp/`
- [ ] Registrado em `init.el` com `(require ...)`
- [ ] Testado com `make docker-test`
- [ ] Versão atualizada em `Makefile` e `DEBIAN/control`
- [ ] Commit com mensagem clara
- [ ] Documentado em `PACKAGE-BUILD.md`

---

## Referências

- Emacs Lisp: https://www.gnu.org/software/emacs/manual/
- Debian Packaging: https://www.debian.org/doc/debian-policy/
- Docker: https://docs.docker.com/

---

**Pronto para expandir! 🚀**
