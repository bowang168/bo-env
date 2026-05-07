# ============================================================================
# .zshrc — interactive zsh sessions
# Requires: oh-my-zsh, zsh-syntax-highlighting, zsh-autosuggestions
# ============================================================================

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
#ZSH_THEME=""  # Using starship prompt instead
ZSH_THEME="bira"  # Using starship prompt instead
zstyle ':omz:update' mode disabled
HIST_STAMPS="yyyy-mm-dd"

plugins=(
    git
    colored-man-pages
#    fzf
    colorize
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source "$ZSH/oh-my-zsh.sh"

# --- Catppuccin colors for zsh-syntax-highlighting ---
# Use command cat to bypass any bat alias
if [[ "$(command cat ~/.theme_mode 2>/dev/null)" == "light" ]]; then
    source "$HOME/.zsh/catppuccin/latte.zsh"
else
    source "$HOME/.zsh/catppuccin/mocha.zsh"
fi

# --- Private env vars (API keys, secrets) ---
[ -f "$HOME/.bashrc_private" ] && source "$HOME/.bashrc_private"

# --- Shared aliases and functions ---
[ -f "$HOME/.shell_common" ] && source "$HOME/.shell_common"

# --- zsh-only config ---
PROJECT_PATHS=($HOME/Desktop/Projects ~/c)

# --- Optional tool integrations (macOS only) ---
if [[ "$(uname)" == "Darwin" ]]; then
    [ -f "$HOME/.openclaw/completions/openclaw.zsh" ] && source "$HOME/.openclaw/completions/openclaw.zsh"
    export WHISPER_CPP_MODEL=/opt/homebrew/share/whisper-cpp/ggml-large-v3-turbo.bin
fi
export OLLAMA_ORIGINS="app://obsidian.md*"

# --- Default working directory ---
[[ "$PWD" == "$HOME" ]] && builtin cd ~/dev

# Override oh-my-zsh 'l' alias
alias l='\ls'

# --- Starship prompt (must be at end) ---
#eval "$(starship init zsh)"

if [[ "$(uname)" == "Linux" && -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi
# Keep local policy wrappers ahead of npm-installed command shims.
path=("$HOME/.local/bin" "$HOME/.npm-global/bin" ${path:#$HOME/.local/bin} ${path:#$HOME/.npm-global/bin})
export PATH

# Python user-installed scripts (ipython, etc.)
export PATH="$HOME/Library/Python/3.13/bin:$PATH"

# --- Codex ---
# `codex` resolves via PATH to ~/.npm-global/bin/codex (the real npm binary).
# For policy-compliant max access + VPN/proxy auto-detection, run `codex-fast`
# explicitly. `codex-subagent` for non-interactive workers, `codex-debug` for
# diagnosis.
