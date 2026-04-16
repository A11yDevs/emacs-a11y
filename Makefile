#!/usr/bin/env make
# Makefile - Automação para build e testes de pacotes Debian

.PHONY: help check build clean docker-build docker-test-config docker-test-launchers shell bash-docker

# Variáveis
CONFIG_PACKAGE := emacs-a11y-config
LAUNCHERS_PACKAGE := emacs-a11y-launchers
VERSION := 0.1.0
DIST_DIR := dist

help:
	@echo "=== Emacs A11y - Construção de Pacotes Debian ==="
	@echo
	@echo "BUILD:"
	@echo "  make check                 - valida estrutura básica dos pacotes"
	@echo "  make build-config          - gera .deb do pacote config (requer dpkg-deb local)"
	@echo "  make build-launchers       - gera .deb do pacote launchers"
	@echo "  make build                 - gera ambos os pacotes localmente"
	@echo "  make docker-build-config   - constrói config em container Docker"
	@echo "  make docker-build-launchers- constrói launchers em container Docker"
	@echo "  make docker-build          - constrói ambos em Docker"
	@echo
	@echo "TESTES:"
	@echo "  make docker-test-config    - instala/testa config em Docker"
	@echo "  make docker-test-launchers - instala/testa launchers em Docker"
	@echo "  make docker-test           - testa ambos em Docker"
	@echo "  make test-install          - testa instalação (tests/test-installation.sh)"
	@echo "  make test-emacs            - testa carregamento do Emacs"
	@echo "  make test-permissions      - testa permissões dos arquivos"
	@echo
	@echo "UTILITÁRIOS:"
	@echo "  make clean                 - remove artefatos (.deb)"
	@echo "  make shell                 - abre shell bash em container Docker"
	@echo

check:
	@echo "=== Validando estrutura de pacotes ==="
	@bash scripts/check-package-layout.sh

build-config: check
	@echo "=== Construindo $(CONFIG_PACKAGE) localmente ==="
	@mkdir -p $(DIST_DIR)
	@dpkg-deb --build packages/$(CONFIG_PACKAGE) $(DIST_DIR)/$(CONFIG_PACKAGE)_$(VERSION)_all.deb
	@echo "✓ Pacote gerado: $(DIST_DIR)/$(CONFIG_PACKAGE)_$(VERSION)_all.deb"

build-launchers: check
	@echo "=== Construindo $(LAUNCHERS_PACKAGE) localmente ==="
	@mkdir -p $(DIST_DIR)
	@dpkg-deb --build packages/$(LAUNCHERS_PACKAGE) $(DIST_DIR)/$(LAUNCHERS_PACKAGE)_$(VERSION)_all.deb
	@echo "✓ Pacote gerado: $(DIST_DIR)/$(LAUNCHERS_PACKAGE)_$(VERSION)_all.deb"

build: build-config build-launchers
	@echo "✓ Todos os pacotes foram construídos"

clean:
	@echo "Limpando artefatos..."
	@rm -rf $(DIST_DIR)/*.deb
	@echo "✓ Limpeza concluída"

docker-build-config:
	@bash scripts/docker-build.sh $(CONFIG_PACKAGE) $(VERSION)

docker-build-launchers:
	@bash scripts/docker-build.sh $(LAUNCHERS_PACKAGE) $(VERSION)

docker-build: docker-build-config docker-build-launchers
	@echo "✓ Todos os pacotes foram construídos em Docker"

docker-test-config: docker-build-config
	@bash scripts/docker-test-install.sh $(CONFIG_PACKAGE) $(VERSION)

docker-test-launchers: docker-build-launchers docker-test-config
	@bash scripts/docker-test-install.sh $(LAUNCHERS_PACKAGE) $(VERSION)

docker-test: docker-test-config docker-test-launchers
	@echo "✓ Testes concluídos"

shell:
	@docker run --rm -it \
		-v "$$(pwd)":/workspace \
		-w /workspace \
		debian:stable-slim bash

bash-docker: shell

test-install:
	@bash tests/test-installation.sh

test-emacs:
	@bash tests/test-emacs-loading.sh

test-permissions:
	@bash tests/test-permissions.sh

test-all: test-install test-emacs test-permissions
	@echo "✓ Todos os testes concluídos com sucesso!"