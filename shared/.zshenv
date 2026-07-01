# Only PATH and non-secret env vars here — runs for ALL zsh processes
typeset -U path PATH
export PATH="$HOME/.local/bin:$PATH"

# NLTK data cache (used by whisperx alignment & TTS tools) — XDG location
# instead of the default ~/nltk_data clutter.
export NLTK_DATA="$HOME/.local/share/nltk_data"
