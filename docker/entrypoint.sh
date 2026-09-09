#!/usr/bin/env bash
set -e

# Initialize conda in non-interactive / login environments
if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    . "/opt/conda/etc/profile.d/conda.sh"
    conda activate base 2>/dev/null || true
fi

# Link or initialize dotfiles if mounted into /root/.dotfiles
if [ -d "/root/.dotfiles" ]; then
    export DOTFILES_HOME="/root/.dotfiles"

    # If dotfiles not yet linked to ~/.zshrc or ~/.bashrc in this container
    if [ -f "/root/.dotfiles/bin/install" ] && ! grep -q "dotfiles" /root/.zshrc 2>/dev/null; then
        NONINTERACTIVE_DOTFILES=1 bash /root/.dotfiles/bin/install >/dev/null 2>&1 || true
    fi
fi

# Execute passed command (default: /bin/zsh)
exec "$@"
