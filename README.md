# emacs-a11y

Uma configuração/distribuição acessível do Emacs para pessoas com deficiência visual, com foco em uso prático, portabilidade e preservação da configuração pessoal do usuário.

## 🎯 O que é

**emacs-a11y** fornece:
- ✅ Emacs otimizado para acessibilidade com tecnologias assistivas
- ✅ Compatibilidade com Debian, Ubuntu, WSL, VMs e máquinas físicas
- ✅ Respeito à configuração pessoal do usuário (~/.emacs.d)
- ✅ Pacotes Debian prontos para instalação
- ✅ Modularidade e fácil expansão

## 🚀 Começar Rápido

1. **Leia o guia de início**: [Getting Started](docs/getting-started.md)
2. **Instale os pacotes**: `sudo dpkg -i dist/*.deb`
3. **Inicie o Emacs**: `/usr/share/a11y-emacs/emacs-a11y.sh`

## 📚 Documentação

### Usuários
- **[Getting Started](docs/getting-started.md)** - Guia de início rápido e instalação
- **[Validação na VM Debian (APT)](docs/apt-vm-validation.md)** - Teste ponta a ponta de assinatura, install e upgrade
- **[Estrutura do Projeto](docs/structure.md)** - Resumo técnico e arquitetura

### Desenvolvedores
- **[Build de Pacotes Debian](docs/package-build.md)** - Como construir e distribuir
- **[Como Expandir](docs/expansion.md)** - Adicionar módulos e features

### Referência
- **[constitution.txt](constitution.txt)** - Diretrizes e objetivos do projeto
- **[ideas.md](ideas.md)** - Arquitetura e propostas de design

## 📦 Pacotes

Dois pacotes Debian estão disponíveis em `dist/`:

| Pacote | Tamanho | Descrição |
|--------|---------|-----------|
| `emacs-a11y-config` | 2.7 KB | Configuração principal e módulos |
| `emacs-a11y-launchers` | 2.1 KB | Scripts de execução e integrações |

## ⬇️ Download por Versão (GitHub Releases)

Os pacotes `.deb` são publicados automaticamente no GitHub Releases quando uma tag no formato `vX.Y.Z` é enviada.

Exemplo de publicação:

```bash
git tag v0.2.0
git push origin v0.2.0
```

Arquivos publicados em cada release:
- `emacs-a11y-config_<versao>_all.deb`
- `emacs-a11y-launchers_<versao>_all.deb`
- `SHA256SUMS.txt`

Após a publicação, baixe os arquivos na página de Releases do repositório.

## 🗂️ Repositório APT (GitHub Pages)

Além dos assets de release, o projeto publica automaticamente um repositório APT estático no GitHub Pages (branch `gh-pages`).

URL do repositório APT:
- https://a11ydevs.github.io/emacs-a11y/debian

Chave pública do repositório:
- https://a11ydevs.github.io/emacs-a11y/debian/a11y-emacs-archive-keyring.gpg

Se a URL retornar 404, habilite em GitHub Settings > Pages:
- Source: Deploy from a branch
- Branch: gh-pages
- Folder: /(root)

### Instalação (Debian/Ubuntu)

1. Limpar configuração anterior (opcional, recomendado):

```bash
sudo rm -f /etc/apt/sources.list.d/emacs-a11y.list
sudo rm -f /usr/share/keyrings/emacs-a11y-archive-keyring.gpg
```

2. Instalar o keyring do repositório:

```bash
sudo curl -fsSL https://a11ydevs.github.io/emacs-a11y/debian/a11y-emacs-archive-keyring.gpg -o /usr/share/keyrings/emacs-a11y-archive-keyring.gpg
```

3. Adicionar o repositório APT:

```bash
echo "deb [arch=all signed-by=/usr/share/keyrings/emacs-a11y-archive-keyring.gpg] https://a11ydevs.github.io/emacs-a11y/debian stable main" | sudo tee /etc/apt/sources.list.d/emacs-a11y.list >/dev/null
```

4. Atualizar índice de pacotes:

```bash
sudo apt update
```

5. Instalar pacotes:

```bash
sudo apt install -y emacs-a11y-config emacs-a11y-launchers
```

6. Validar instalação:

```bash
dpkg -l | grep -E "emacs-a11y-config|emacs-a11y-launchers"
```

### Atualização

```bash
sudo apt update
sudo apt upgrade
```

### Troubleshooting rápido

- Erro de assinatura/chave ausente:

```bash
sudo curl -fsSL https://a11ydevs.github.io/emacs-a11y/debian/a11y-emacs-archive-keyring.gpg -o /usr/share/keyrings/emacs-a11y-archive-keyring.gpg
sudo apt update
```

- Erro "Release file not found":
    - Aguarde o workflow de publicação do APT finalizar em GitHub Actions e execute `sudo apt update` novamente.

- Erro 404 ao baixar `.deb`:
    - Normalmente indica metadados em cache local. Execute:

```bash
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt update
```

### Segredos Necessários no GitHub

Para assinar o repositório APT no workflow, configure em Settings > Secrets and variables > Actions:
- `APT_GPG_PRIVATE_KEY_B64`: chave privada GPG em Base64
- `APT_GPG_PASSPHRASE`: passphrase da chave (use vazio se a chave não tiver senha)

### Instalação

```bash
sudo dpkg -i dist/emacs-a11y-config_0.1.0_all.deb
sudo dpkg -i dist/emacs-a11y-launchers_0.1.0_all.deb
```

### Uso

```bash
# Iniciar com configuração a11y
/usr/share/a11y-emacs/emacs-a11y.sh

# Ou usar normalmente (se emacs-a11y estiver no PATH)
emacs-a11y
```

## 🔧 Estrutura do Repositório

```
emacs-a11y/
├── README.md                    ← Você está aqui
├── constitution.txt             ← Diretrizes do projeto
├── ideas.md                     ← Proposals de arquitetura
│
├── docs/                        ← Documentação detalhada
│   ├── getting-started.md
│   ├── package-build.md
│   ├── structure.md
│   └── expansion.md
│
├── packages/                    ← Código-fonte dos pacotes
│   ├── emacs-a11y-config/
│   └── emacs-a11y-launchers/
│
├── dist/                        ← Pacotes compilados (.deb)
│   ├── emacs-a11y-config_0.1.0_all.deb
│   └── emacs-a11y-launchers_0.1.0_all.deb
│
├── overlay/                     ← Overlay para /etc/skel
│   └── etc/skel/.emacs.d/
│
├── scripts/                     ← Automação de build e testes
│   ├── check-package-layout.sh
│   ├── docker-build.sh
│   ├── docker-test-install.sh
│   └── ...
│
├── Makefile                     ← Automação de build
│
└── .reports/                    ← Relatórios (não versionados)
    └── (histórico de builds/testes)
```

## 🛠️ Automação

Use `make` para automação:

```bash
make help                   # Lista todos os targets
make check                  # Valida estrutura
make docker-build           # Build em Docker
make docker-test            # Testa instalação
make shell                  # Shell interativo em Docker
```

## 🎯 Objetivos

1. ✅ Fornecer Emacs acessível para pessoas com deficiência visual
2. ✅ Garantir portabilidade para Debian, Ubuntu, WSL
3. ✅ Distribuir via pacotes Debian
4. ✅ Respeitar configuração pessoal do usuário
5. ✅ Facilitar extensão e customização

## 📖 Guia por Tipo de Usuário

**Sou novo no emacs-a11y:**
→ Leia [Getting Started](docs/getting-started.md)

**Quero entender como funciona:**
→ Leia [Estrutura do Projeto](docs/structure.md)

**Quero construir pacotes:**
→ Leia [Build de Pacotes Debian](docs/package-build.md)

**Quero adicionar features:**
→ Leia [Como Expandir](docs/expansion.md)

**Quero entender o design:**
→ Leia [constitution.txt](constitution.txt) e [ideas.md](ideas.md)

## 💡 Personalizações

Usuários podem customizar em `~/.config/a11y-emacs/user-init.el`:

```elisp
;;; ~/.config/a11y-emacs/user-init.el
;; Suas customizações aqui

(global-set-key (kbd "C-x C-j") 'my-custom-command)
```

## 🔐 Segurança e Privacidade

- ✅ Nunca sobrepõe automaticamente `~/.emacs.d`
- ✅ Respeita configuração pessoal do usuário
- ✅ Sem coleta de dados
- ✅ Código aberto e auditável

## 🤝 Contribuições

Contribuições são bem-vindas! Veja [Como Expandir](docs/expansion.md) para começar.

## 📝 Licença

[Especificar licença aqui]

## 📞 Suporte

- 📖 Documentação: Veja links acima
- 🐛 Bugs: [GitHub Issues](link-para-issues)
- 💬 Discussões: [GitHub Discussions](link-para-discussions)

---

**Versão**: 0.1.0  
**Status**: Em desenvolvimento  
**Última atualização**: 2026-04-15
