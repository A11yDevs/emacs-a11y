# Emacs A11y - Estrutura de Pacotes Debian

Estrutura inicial para criação e distribuição de pacotes `.deb` do Emacs A11y para Debian e Ubuntu.

## Visão Geral

Este projeto implementa o fluxo de desenvolvimento e empacotamento descrito em `constitution.txt` e `ideas.md`, criando pacotes modulares que:

✓ Preservam a configuração pessoal do usuário em `~/.emacs.d`  
✓ Instalam configuração centralizada em `/usr/share/a11y-emacs/`  
✓ Permitem customizações opcionais via `~/.config/a11y-emacs/user-init.el`  
✓ Funcionam em Debian, Ubuntu, máquinas físicas, VMs e WSL  
✓ São testados em containers Docker antes do uso real  

## Estrutura de Diretórios

```
.
├── Makefile                          # Automação de build e testes
├── packages/
│   ├── a11y-emacs-config/           # Pacote com configuração principal
│   │   ├── DEBIAN/
│   │   │   ├── control              # Metadados do pacote
│   │   │   └── postinst             # Hook pós-instalação
│   │   └── usr/share/a11y-emacs/
│   │       ├── init.el              # Ponto de entrada
│   │       ├── early-init.el        # Configuração prévia
│   │       └── lisp/                # Módulos específicos
│   │           ├── init-core.el
│   │           ├── init-accessibility.el
│   │           └── init-navigation.el
│   └── a11y-emacs-launchers/        # Pacote com scripts lancadores
│       ├── DEBIAN/
│       │   ├── control
│       │   └── postinst
│       └── usr/share/a11y-emacs/
│           ├── emacs-a11y.sh        # Launcher principal
│           ├── espeakup-stop.sh     # Controle de áudio
│           └── espeakup-start.sh
├── overlay/                         # Arquivos para /etc/skel
│   └── etc/skel/.emacs.d/
│       ├── init.el
│       └── early-init.el
├── scripts/
│   ├── check-package-layout.sh      # Valida estrutura
│   ├── docker-build.sh              # Build em Docker
│   └── docker-test-install.sh       # Teste de instalação
└── dist/                            # Saída (.deb gerados aqui)
```

## Fluxo de Desenvolvimento

### 1. Construir pacotes localmente

Requer `dpkg-deb` instalado no sistema:

```bash
make build
# ou Para pacotes específicos:
make build-config
make build-launchers
```

### 2. Construir em Docker (recomendado)

Sem dependências locais:

```bash
make docker-build
# ou pacotes específicos:
make docker-build-config
make docker-build-launchers
```

### 3. Testar instalação em Docker

```bash
make docker-test
# ou pacotes específicos:
make docker-test-config
make docker-test-launchers
```

### 4. Abrir shell interativo em Docker

Para debugging e exploração:

```bash
make shell
```

## Validação e Verificação

Validar estrutura de pacotes:

```bash
make check
```

Isso verifica:
- Presença de `DEBIAN/control` em cada pacote
- Presença de `DEBIAN/postinst` (se aplicável)
- Permissões de execução

## Conceitos Principais

### Pacote `a11y-emacs-config`

Contém a configuração central do Emacs:
- `init.el`: Ponto de entrada principal
- `early-init.el`: Configurações pré-boot
- `lisp/*`: Módulos de funcionalidade

Instalado em: `/usr/share/a11y-emacs/`

### Pacote `a11y-emacs-launchers`

Depende de `a11y-emacs-config` e fornece:
- `emacs-a11y.sh`: Script para iniciar com a configuração
- `espeakup-stop.sh`: Parar servidor de áudio assistivo
- `espeakup-start.sh`: Reiniciar servidor de áudio

### Overlay `/etc/skel`

Arquivos em `overlay/etc/skel/` são copiados para novos usuários:
- Inicial `.emacs.d/init.el` que carrega a configuração a11y-emacs
- Não interfere com usuários já existentes

### Customização do Usuário

Cada usuário pode customizar em `~/.config/a11y-emacs/user-init.el`:

```elisp
;;; ~/.config/a11y-emacs/user-init.el
;; Minhas customizações pessoais

(defun my-custom-function ()
  (interactive)
  (message "Minha função customizada"))
```

Este arquivo é carregado automaticamente após a configuração principal.

## Regras de Segurança

✓ Nunca sobrepõe automaticamente `~/.emacs.d` de usuários existentes  
✓ Configuração central separada da configuração pessoal  
✓ Integrações com customização pessoal são opcionais  
✓ Foca em segurança, previsibilidade e manutenção  

## Próximas Etapas

1. **Completar módulos Lisp**: Adicionar `init-dired.el`, `init-shell.el`, `init-java.el`, etc
2. **Criar pacote `-docs`**: Documentação do usuário
3. **Testar em VM real**: Debian/Ubuntu real para validar instalação
4. **Distribuição**: Publicar em repositório APT
5. **CI/CD**: Automação com GitHub Actions

## Troubleshooting

**"Pacote não encontrado"**

Certifique-se de construir antes de testar:
```bash
make docker-build
make docker-test
```

**"Arquivo init.el não carregado"**

Verifique permissões:
```bash
ls -la dist/*.deb
dpkg -c dist/*.deb | head -20
```

**Docker não disponível**

Instale Docker ou use `make build` (requer dpkg-deb local)

## Referências

- `constitution.txt` - Diretrizes e objetivos do projeto
- `ideas.md` - Estrutura/arquitetura proposta
- `.draft/` - Exemplos iniciais

## Teste Rápido

```bash
# Constrói ambos os pacotes em Docker
make docker-build

# Testa ambos em um novo container
make docker-test

# Pronto! Os .deb estão em dist/
ls -lh dist/
```
