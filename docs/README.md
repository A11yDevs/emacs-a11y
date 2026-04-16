# Documentação do emacs-a11y

Esta pasta contém toda a documentação detalhada do projeto.

## 📚 Guias Principais

### Para Usuários
- **[getting-started.md](getting-started.md)** - Comece aqui!
  - Instalação e setup
  - Primeiro uso
  - Troubleshooting básico

- **[structure.md](structure.md)** - Entenda a estrutura
  - Arquitetura do projeto
  - Componentes principais
  - Como tudo se conecta

### Para Desenvolvedores
- **[package-build.md](package-build.md)** - Build Debian
  - Como construir pacotes
  - Scripts de automação
  - Processo de build detalhado

- **[expansion.md](expansion.md)** - Como expandir
  - Adicionar novos módulos
  - Criar pacotes adicionais
  - Customizações avançadas

## 🔗 Atalhos Rápidos

| Objetivo | Documentação |
|----------|--------------|
| Instalar emacs-a11y | [getting-started.md](getting-started.md) |
| Entender estrutura | [structure.md](structure.md) |
| Construir pacotes | [package-build.md](package-build.md) |
| Adicionar features | [expansion.md](expansion.md) |
| Ver diretrizes | [../constitution.txt](../constitution.txt) |

## 📖 Fluxo Recomendado

1. **Novo usuário?**
   - Leia: [getting-started.md](getting-started.md)
   - Ação: Instale os pacotes
   - Teste: `/usr/share/a11y-emacs/emacs-a11y.sh`

2. **Deseja entender como funciona?**
   - Leia: [structure.md](structure.md)
   - Explore: O código em `packages/`

3. **Quer contribuir?**
   - Leia: [expansion.md](expansion.md)
   - Estude: [package-build.md](package-build.md)
   - Comece: Criar novo módulo

## 🎯 Referência Rápida

### Comandos Importantes

```bash
# Ver ajuda
make help

# Validar estrutura
make check

# Build em Docker (recomendado)
make docker-build

# Testar instalação
make docker-test

# Instalar pacotes
sudo dpkg -i ../dist/*.deb

# Iniciar emacs-a11y
/usr/share/a11y-emacs/emacs-a11y.sh
```

### Arquivos Importantes

- **constitution.txt** - Diretrizes do projeto
- **ideas.md** - Propostas de arquitetura
- **Makefile** - Automação de build
- **packages/** - Código-fonte dos pacotes

## ❓ Perguntas Frequentes

**P: Por onde começo?**  
R: Leia [getting-started.md](getting-started.md)

**P: Como instalo?**  
R: Veja a seção de instalação em [getting-started.md](getting-started.md)

**P: Como construo pacotes?**  
R: Leia [package-build.md](package-build.md)

**P: Como adiciono novos módulos?**  
R: Leia [expansion.md](expansion.md)

**P: Onde estão os pacotes compilados?**  
R: Em `../dist/` (no raiz do repositório)

## 📞 Suporte

- 🐛 Report bugs em [GitHub Issues]
- 💬 Discussões em [GitHub Discussions]
- 📖 Mais documentação: veja links acima

---

**Organização da Documentação:**
- Root `README.md`: Visão geral e início rápido
- `docs/`: Documentação detalhada
- `.reports/`: Histórico de builds e testes (não versionado)
