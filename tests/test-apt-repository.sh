#!/bin/bash
# tests/test-apt-repository.sh - Valida saúde do repositório APT no GitHub Pages

set -euo pipefail

APT_BASE_URL="${APT_BASE_URL:-https://a11ydevs.github.io/emacs-a11y/debian}"
DIST="${DIST:-stable}"
COMPONENT="${COMPONENT:-main}"
ARCH="${ARCH:-all}"

echo "=== Teste do Repositório APT (GitHub Pages) ==="
echo "APT_BASE_URL=${APT_BASE_URL}"
echo "DIST=${DIST} COMPONENT=${COMPONENT} ARCH=${ARCH}"
echo

if ! command -v docker >/dev/null 2>&1; then
  echo "❌ Docker não encontrado no host"
  exit 1
fi

echo "◆ Executando validações em container Debian limpo..."
docker run --rm \
  -e APT_BASE_URL="${APT_BASE_URL}" \
  -e DIST="${DIST}" \
  -e COMPONENT="${COMPONENT}" \
  -e ARCH="${ARCH}" \
  debian:stable-slim \
  bash -s <<'SCRIPT'
set -euo pipefail

apt-get update -qq
apt-get install -y -qq ca-certificates curl gpg gzip awk

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

must_exist_urls=(
  "${APT_BASE_URL}/dists/${DIST}/InRelease"
  "${APT_BASE_URL}/dists/${DIST}/Release"
  "${APT_BASE_URL}/dists/${DIST}/${COMPONENT}/binary-${ARCH}/Packages.gz"
  "${APT_BASE_URL}/a11y-emacs-archive-keyring.gpg"
)

echo "  > Verificando endpoints essenciais..."
for url in "${must_exist_urls[@]}"; do
  status="$(curl -s -o /dev/null -w '%{http_code}' "${url}")"
  if [[ "${status}" != "200" ]]; then
    echo "❌ Endpoint inválido (${status}): ${url}"
    exit 1
  fi
  echo "✓ ${url}"
done

echo "  > Baixando índice Packages.gz..."
curl -fsSL "${APT_BASE_URL}/dists/${DIST}/${COMPONENT}/binary-${ARCH}/Packages.gz" \
  | gzip -dc > "${TMP_DIR}/Packages"

grep -q '^Package: emacs-a11y-config$' "${TMP_DIR}/Packages" || {
  echo "❌ Pacote emacs-a11y-config não encontrado no índice"
  exit 1
}

grep -q '^Package: emacs-a11y-launchers$' "${TMP_DIR}/Packages" || {
  echo "❌ Pacote emacs-a11y-launchers não encontrado no índice"
  exit 1
}

if grep -q '^Filename: pages/debian/' "${TMP_DIR}/Packages"; then
  echo "❌ Índice com Filename inválido (pages/debian/...)"
  exit 1
fi

echo "  > Verificando URLs dos .deb listados no índice..."
awk -F': ' '/^Filename: /{print $2}' "${TMP_DIR}/Packages" | while IFS= read -r rel_path; do
  [[ -z "${rel_path}" ]] && continue
  deb_url="${APT_BASE_URL}/${rel_path}"
  status="$(curl -s -o /dev/null -w '%{http_code}' "${deb_url}")"
  if [[ "${status}" != "200" ]]; then
    echo "❌ .deb indisponível (${status}): ${deb_url}"
    exit 1
  fi
  echo "✓ ${deb_url}"
done

echo "  > Testando apt update/install..."
curl -fsSL "${APT_BASE_URL}/a11y-emacs-archive-keyring.gpg" \
  -o /usr/share/keyrings/emacs-a11y-archive-keyring.gpg

echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/emacs-a11y-archive-keyring.gpg] ${APT_BASE_URL} ${DIST} ${COMPONENT}" \
  > /etc/apt/sources.list.d/emacs-a11y.list

apt-get update -qq
apt-get install -y -qq emacs-a11y-config emacs-a11y-launchers

dpkg-query -W emacs-a11y-config emacs-a11y-launchers >/dev/null
test -f /usr/share/a11y-emacs/init.el

echo "✓ apt update/install funcionou no container"
SCRIPT

echo
echo "✅ Repositório APT no GitHub Pages validado com sucesso"
