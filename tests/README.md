# Testes - emacs-a11y

Scripts específicos de teste para validar funcionalidade dos pacotes.

## 📋 Scripts Disponíveis

### test-installation.sh
Testa a instalação básica dos pacotes em um container Docker.

**O que valida:**
- Pacotes .deb existem
- Instalação sem erros
- Diretório `/usr/share/a11y-emacs` criado
- Arquivos extraídos corretamente

**Uso:**
```bash
bash tests/test-installation.sh
```

### test-emacs-loading.sh
Testa se o `init.el` carrega corretamente no Emacs.

**O que valida:**
- Emacs inicia em modo batch
- init.el carrega sem erros
- Versão do Emacs é exibida
- Configuração está no local correto

**Uso:**
```bash
bash tests/test-emacs-loading.sh
```

### test-permissions.sh
Testa se os arquivos têm as permissões corretas.

**O que valida:**
- Scripts são executáveis (755)
- Todos os 3 scripts launcher têm permissões certas
- Estrutura de arquivos está intacta

**Uso:**
```bash
bash tests/test-permissions.sh
```

## 🚀 Executar Todos os Testes

```bash
# Via scripts/ (mais completo)
bash scripts/quick-test.sh

# Ou via make
make docker-test

# Ou testes específicos
bash tests/test-installation.sh
bash tests/test-emacs-loading.sh
bash tests/test-permissions.sh
```

## 🔄 Fluxo de Testes Recomendado

1. **Build:**
   ```bash
   make docker-build
   # ou
   bash scripts/quick-test.sh
   ```

2. **Testes Individuais:**
   ```bash
   bash tests/test-installation.sh
   bash tests/test-emacs-loading.sh
   bash tests/test-permissions.sh
   ```

3. **Teste Completo:**
   ```bash
   bash scripts/build-and-test-full.sh
   ```

## ✅ Checklist de Testes

- [ ] Pacotes .deb existem em `dist/`
- [ ] Instalação sem erros
- [ ] Arquivos extraídos corretamente
- [ ] init.el carrega sem erros
- [ ] Scripts são executáveis
- [ ] Permissões corretas (755)
- [ ] Dependências satisfeitas

## 📊 Testes em Docker

Todos os testes executam em um container Docker `debian:stable-slim`:

- Ambiente limpo e isolado
- Sem dependências do host
- Resultados reproduzíveis
- Fácil validação em CI/CD

## 🐛 Troubleshooting

**"Pacote não encontrado"**
```bash
# Build primeiro
bash scripts/quick-test.sh
```

**"Erro ao carregar init.el"**
```bash
# Verificar sintaxe Elisp
emacs -Q --batch --load packages/emacs-a11y-config/usr/share/a11y-emacs/init.el
```

**"Permissões incorretas"**
```bash
# Verificar permissões localmente
ls -lh packages/emacs-a11y-launchers/usr/share/a11y-emacs/*.sh
```

---

**Próximo passo:** Executar os testes com `bash tests/test-installation.sh`
