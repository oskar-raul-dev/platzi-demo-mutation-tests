[[ -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

# Solo para grabar: prompt corto y el .venv del proyecto ya activado.
PROMPT='%# '
[[ -f "$ZDOTDIR/../.venv/bin/activate" ]] && source "$ZDOTDIR/../.venv/bin/activate"
