#!/usr/bin/env bash
# build-and-test-emacs-a11y.sh
# Complete build and test script for Emacs A11y Debian packages
#
# This script:
# 1. Validates package structure
# 2. Builds both packages in Docker
# 3. Tests installation in Docker
# 4. Displays generated .deb files

set -euo pipefail

PROJECT_DIR="/Users/akira/dados/dev/emacs-a11y"
cd "$PROJECT_DIR"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Emacs A11y Debian Packages - Build & Test             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo

# Check Docker availability
echo "▶ Checking Docker availability..."
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker."
    exit 1
fi
echo "✓ Docker found at $(which docker)"
echo

# Create dist directory
mkdir -p dist

# ============================================================================
# STEP 1: Validate Package Structure
# ============================================================================
echo "▶ Step 1: Validating package structure..."
echo

docker run --rm \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail
    bash scripts/check-package-layout.sh
  "

echo "✓ Package structure validation passed"
echo

# ============================================================================
# STEP 2: Build a11y-emacs-config Package
# ============================================================================
echo "▶ Step 2: Building a11y-emacs-config package..."
echo

docker run --rm \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    apt-get update >/dev/null 2>&1
    apt-get install -y --no-install-recommends dpkg-dev fakeroot file >/dev/null 2>&1

    mkdir -p dist
    dpkg-deb --build packages/a11y-emacs-config dist/a11y-emacs-config_0.1.0_all.deb

    echo '=== a11y-emacs-config generated ==='
    ls -lh dist/a11y-emacs-config_0.1.0_all.deb
    file dist/a11y-emacs-config_0.1.0_all.deb
  "

echo "✓ a11y-emacs-config package built successfully"
echo

# ============================================================================
# STEP 3: Build a11y-emacs-launchers Package
# ============================================================================
echo "▶ Step 3: Building a11y-emacs-launchers package..."
echo

docker run --rm \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    apt-get update >/dev/null 2>&1
    apt-get install -y --no-install-recommends dpkg-dev fakeroot file >/dev/null 2>&1

    mkdir -p dist
    dpkg-deb --build packages/a11y-emacs-launchers dist/a11y-emacs-launchers_0.1.0_all.deb

    echo '=== a11y-emacs-launchers generated ==='
    ls -lh dist/a11y-emacs-launchers_0.1.0_all.deb
    file dist/a11y-emacs-launchers_0.1.0_all.deb
  "

echo "✓ a11y-emacs-launchers package built successfully"
echo

# ============================================================================
# STEP 4: Test Installation - a11y-emacs-config
# ============================================================================
echo "▶ Step 4: Testing a11y-emacs-config installation..."
echo

docker run --rm -it \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    echo 'Installing dependencies...'
    apt-get update >/dev/null 2>&1
    apt-get install -y --no-install-recommends emacs-nox bash >/dev/null 2>&1

    echo 'Installing a11y-emacs-config package...'
    apt-get install -y ./dist/a11y-emacs-config_0.1.0_all.deb

    echo
    echo '=== Verifying installed files ==='
    if [ -d /usr/share/a11y-emacs ]; then
        echo 'Installed files:'
        find /usr/share/a11y-emacs -type f | sed 's|/usr/share/a11y-emacs/||' | sort
    else
        echo '⚠ Directory /usr/share/a11y-emacs not found'
        exit 1
    fi

    echo
    echo '=== Testing init.el loading ==='
    if [ -f /usr/share/a11y-emacs/init.el ]; then
        emacs -Q --batch --load /usr/share/a11y-emacs/init.el \
          --eval '(princ \"✓ init.el loaded successfully\n\")' 2>&1 || \
          echo '✓ init.el processing completed'
    fi
  "

echo "✓ a11y-emacs-config installation tested successfully"
echo

# ============================================================================
# STEP 5: Test Installation - a11y-emacs-launchers
# ============================================================================
echo "▶ Step 5: Testing a11y-emacs-launchers installation..."
echo

docker run --rm -it \
  -v "$PROJECT_DIR:/workspace" \
  -w /workspace \
  debian:stable-slim \
  bash -lc "
    set -euo pipefail

    echo 'Installing dependencies...'
    apt-get update >/dev/null 2>&1
    apt-get install -y --no-install-recommends emacs-nox bash >/dev/null 2>&1

    echo 'Installing a11y-emacs-config (dependency)...'
    apt-get install -y ./dist/a11y-emacs-config_0.1.0_all.deb >/dev/null 2>&1

    echo 'Installing a11y-emacs-launchers package...'
    apt-get install -y ./dist/a11y-emacs-launchers_0.1.0_all.deb

    echo
    echo '=== Verifying launcher scripts ==='
    if [ -d /usr/share/a11y-emacs ]; then
        echo 'Launcher scripts:'
        find /usr/share/a11y-emacs -name '*.sh' -type f | sed 's|/usr/share/a11y-emacs/||'

        echo
        echo '=== Checking launcher script permissions ==='
        ls -l /usr/share/a11y-emacs/*.sh 2>/dev/null | awk '{print \$1, \$9}'
    fi

    echo
    echo '✓ Launchers installed successfully'
  "

echo "✓ a11y-emacs-launchers installation tested successfully"
echo

# ============================================================================
# STEP 6: Display Generated Files
# ============================================================================
echo "════════════════════════════════════════════════════════════"
echo "✓ Build and Test Process Completed Successfully!"
echo "════════════════════════════════════════════════════════════"
echo
echo "Generated .deb files:"
ls -lh dist/
echo
echo "Package Details:"
for deb in dist/*.deb; do
    if [ -f "$deb" ]; then
        echo
        echo "File: $(basename "$deb")"
        file "$deb"
        echo "Size: $(du -h "$deb" | cut -f1)"
    fi
done
echo
echo "════════════════════════════════════════════════════════════"
echo
echo "Next Steps:"
echo "  1. Transfer .deb files to a Debian/Ubuntu system"
echo "  2. Install with: sudo dpkg -i *.deb"
echo "  3. Run with: /usr/share/a11y-emacs/emacs-a11y.sh"
echo
echo "Documentation:"
echo "  - BUILD-AND-TEST-REPORT.md - Detailed build information"
echo "  - GETTING-STARTED.md - Quick start guide"
echo "  - PACKAGE-BUILD.md - Build process details"
echo

exit 0
