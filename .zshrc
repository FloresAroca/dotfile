# --- 1. HISTORIAL ---
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt appendhistory       # Comparte el historial entre pestañas
setopt sharehistory        # Actualiza el historial en tiempo real

# --- 2. EL MENÚ DEL TABULADOR ---
autoload -Uz compinit && compinit
zstyle ':completion:*' rehash true
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Ignora mayúsculas/minúsculas
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- 3. BÚSQUEDA INTELIGENTE CON LAS FLECHAS (Corregido) ---
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search # Flecha Arriba
bindkey '^[[B' down-line-or-beginning-search # Flecha Abajo

# --- 4. PLUGINS ---
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8" 

# --- 5. PROMPT (STARSHIP) ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

alias ls="eza --icons --group-directories-first --color=always"
alias ll="eza -lh --icons --group-directories-first"
