# Validação na VM Debian (Repositório APT)

Este guia valida o fluxo completo de instalação e atualização via APT usando o repositório publicado no GitHub Pages.

## Objetivo

Confirmar que:
- a assinatura do repositório está válida;
- os pacotes são instaláveis via `apt install`;
- o fluxo de atualização funciona com `apt update` e `apt upgrade`.

## 1. Limpar configuração anterior

```bash
sudo rm -f /etc/apt/sources.list.d/emacs-a11y.list
sudo rm -f /usr/share/keyrings/emacs-a11y-archive-keyring.gpg
```

## 2. Configurar keyring e source list assinados

```bash
curl -fsSL https://a11ydevs.github.io/emacs-a11y/debian/a11y-emacs-archive-keyring.gpg \
  | sudo tee /usr/share/keyrings/emacs-a11y-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/emacs-a11y-archive-keyring.gpg] https://a11ydevs.github.io/emacs-a11y/debian stable main" \
  | sudo tee /etc/apt/sources.list.d/emacs-a11y.list
```

## 3. Atualizar índices e validar assinatura

```bash
sudo apt update
```

Esperado:
- sem erro `NO_PUBKEY`;
- sem erro `The repository is not signed`;
- presença do repositório `https://a11ydevs.github.io/emacs-a11y/debian` no update.

## 4. Instalar pacotes

```bash
sudo apt install -y emacs-a11y-config emacs-a11y-launchers
```

## 5. Verificar instalação

```bash
dpkg -l | grep -E 'emacs-a11y-config|emacs-a11y-launchers'
ls -l /usr/share/a11y-emacs
```

## 6. Validar atualização

```bash
sudo apt update
sudo apt list --upgradable | grep emacs-a11y || true
sudo apt upgrade --dry-run
```

## 7. Teste opcional de execução

```bash
/usr/share/a11y-emacs/emacs-a11y.sh --version || true
```

## Troubleshooting Rápido

### Erro de assinatura (`NO_PUBKEY`)

1. Reimporte o keyring:

```bash
curl -fsSL https://a11ydevs.github.io/emacs-a11y/debian/a11y-emacs-archive-keyring.gpg \
  | sudo tee /usr/share/keyrings/emacs-a11y-archive-keyring.gpg >/dev/null
```

2. Confirme o `signed-by` no arquivo:

```bash
cat /etc/apt/sources.list.d/emacs-a11y.list
```

### Repositório não encontrado (404)

- Verifique se o GitHub Pages está habilitado com branch `gh-pages` e pasta `/(root)`.

### Pacote não encontrado

- Rode `sudo apt update` novamente;
- confirme se o workflow de publicação APT concluiu com sucesso.
