#!/usr/bin/env bash
set -euo pipefail

# Align Framework Installer
# Installs align directory structure and Claude commands into a project.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALIGN_BASE="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="$(pwd)"

COMMANDS_ONLY=false

usage() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Install Align framework into the current project directory."
    echo ""
    echo "Options:"
    echo "  --commands-only  Only update commands (skip directory creation)"
    echo "  -h, --help       Show this help message"
}

for arg in "$@"; do
    case "$arg" in
        --commands-only) COMMANDS_ONLY=true ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $arg"; usage; exit 1 ;;
    esac
done

# Safety: don't install into the align repo itself
if [ "$TARGET_DIR" = "$ALIGN_BASE" ]; then
    echo "Error: Cannot install Align into its own repository."
    echo "Run this script from your project directory instead:"
    echo "  cd /path/to/your/project"
    echo "  $0"
    exit 1
fi

# Verify the align repo has what we need
if [ ! -d "$ALIGN_BASE/commands" ]; then
    echo "Error: commands/ directory not found in $ALIGN_BASE"
    exit 1
fi

install_commands() {
    mkdir -p "$TARGET_DIR/.claude/commands"
    local count=0
    for cmd in "$ALIGN_BASE/commands"/*.md; do
        [ -f "$cmd" ] || continue
        cp "$cmd" "$TARGET_DIR/.claude/commands/"
        count=$((count + 1))
    done
    echo "  Copied $count commands to .claude/commands/"
}

install_directories() {
    local dirs=(
        "align/product"
        "align/standards"
        "align/features"
        "align/support/guides"
        "align/support/troubleshooting"
        "align/support/runbooks"
    )

    local created=0
    for dir in "${dirs[@]}"; do
        if [ ! -d "$TARGET_DIR/$dir" ]; then
            mkdir -p "$TARGET_DIR/$dir"
            created=$((created + 1))
        fi
    done

    if [ $created -gt 0 ]; then
        echo "  Created $created directories under align/"
    else
        echo "  All align/ directories already exist"
    fi
}

echo "Installing Align into: $TARGET_DIR"
echo ""

if [ "$COMMANDS_ONLY" = true ]; then
    install_commands
else
    if [ -d "$TARGET_DIR/align" ]; then
        echo "align/ directory already exists. Existing content will not be overwritten."
        read -r -p "Continue? [Y/n] " response
        case "$response" in
            [nN]*) echo "Aborted."; exit 0 ;;
        esac
        echo ""
    fi
    install_directories
    install_commands
fi

echo ""
echo "Done! Next steps:"
echo "  1. Follow the Quick Start for your scenario in the Align README"
echo "  2. Run /align-status to check alignment state"
