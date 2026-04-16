# Idéias para o Emacs-a11y

## Visão geral

O Emacs-a11y é uma distribuição personalizada do Emacs projetada para ser acessível a pessoas com deficiência visual. Ele inclui uma série de pacotes e configurações que melhoram a experiência de uso do Emacs para usuários com necessidades especiais, como leitores de tela, navegação por teclado aprimorada e integração com tecnologias assistivas.

## Possíveis pacotes a serem incluídos

* emacs-a11y-config: Pacote com a configuração do Emacs A11yDevs, incluindo os arquivos lisp da pasta /usr/share/a11y-emacs/.
* emacs-a11y-java: Configurações específicas para desenvolvimento em Java, incluindo integração com LSP e ferramentas úteis de desenvolvimento.
* emacs-a11y-launchers: lançadores para parada do servidor espeakup antes de entrar no Emacs e para reiniciar o servidor espeakup ao sair do Emacs.
* emacs-a11y-docs: documentação e tutoriais para ajudar os usuários a configurar e usar o Emacs-a11y de forma eficaz.

## Estrutura de diretórios

Localização dos arquivos de configuração do Emacs-a11y. O arquivo `init.el` é o ponto de entrada para a configuração do Emacs, enquanto `early-init.el` é carregado antes de `init.el` e pode ser usado para configurações que precisam ser aplicadas cedo no processo de inicialização. A pasta `lisp/` contém arquivos de configuração específicos para diferentes funcionalidades e integrações, como acessibilidade, navegação, dired, shell, Java, GPTel, atividades e layout IDE.

```
/usr/share/a11y-emacs/
├── init.el
├── launchers
|   ├── stop-espeakup.sh
|   ├── restart-espeakup.sh
|   └── emacs-a11y.sh
├── lisp/
│   ├── init-core.el
│   ├── init-accessibility.el
│   ├── init-navigation.el
│   ├── init-dired.el
│   ├── init-shell.el
│   ├── init-java.el
│   ├── init-gptel.el
│   └── init-activities.el
├── templates/
│   └── .emacs.d/
└── docs/
```

## Estrutura do projeto

emacs-a11y/
├── Makefile
├── README.md
├── docs/
│   ├── guia-instalacao.md
│   ├── guia-atualizacao.md
│   └── guia-usuario.md
├── scripts/
│   ├── docker-build.sh
│   ├── docker-test-install.sh
│   └── check-package-layout.sh
├── packages/
│   ├── a11y-emacs-config/
│   │   ├── DEBIAN/
│   │   │   ├── control
│   │   │   └── postinst
│   │   └── usr/
│   │       └── share/
│   │           └── a11y-emacs/
│   │               ├── init.el
│   │               ├── early-init.el
│   │               ├── snippets/
│   │               ├── docs/
│   │               └── lisp/
│   │                   ├── init-core.el
│   │                   ├── init-accessibility.el
│   │                   ├── init-navigation.el
│   │                   ├── init-dired.el
│   │                   ├── init-shell.el
│   │                   ├── init-java.el
│   │                   ├── init-gptel.el
│   │                   ├── init-activities.el
│   │                   └── init-layout-ide.el
│   └── a11y-emacs-launchers/
│       ├── DEBIAN/
│       │   ├── control
│       │   └── postinst
│       └── usr/
│           └── share/
│               └── a11y-emacs/
│                   ├── emacs-a11y.sh
│                   ├── espeakup-start.sh
│                   └── espeakup-stop.sh
└── overlay/
    └── etc/
        └── skel/
            └── .emacs.d/
                ├── init.el
                └── early-init.el

Fluxo recomendado:

1. editar no macOS ou outra máquina de desenvolvimento, usando o layout de arquivos proposto;
2. rodar make docker-build;
3. rodar make docker-test;
4. quando estiver estável, instalar em uma VM Debian/Ubuntu real;
5. só depois empacotar launchers, alias e integração com áudio.