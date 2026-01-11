# ----- Powerlevel10k instant prompt (keep at top) -----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ruichen/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ruichen/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/ruichen/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ruichen/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/ruichen/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/ruichen/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# ===== Basic environment =====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='nano'  # 在服务器上建议使用 nano 或 vim

# --- 智能添加 PATH ---
# Linux server path
if [[ "$(uname)" == "Linux" ]]; then
  export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
fi
# macOS Homebrew path
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

# ===== Oh My Zsh & theme =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# ===== Cross-platform plugins =====
# FZF (模糊搜索)
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# --- OS-specific plugins ---
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS (Homebrew) specific plugins
  # zsh-autosuggestions & zsh-syntax-highlighting
  [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$(uname)" == "Linux" ]]; then
  # Linux (apt/dnf) specific plugins
  # 提示: 在 Debian/Ubuntu 上, 请先执行: sudo apt install zsh-autosuggestions zsh-syntax-highlighting
  [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ===== History & options =====
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS SHARE_HISTORY
setopt AUTO_CD AUTO_PUSHD EXTENDED_GLOB CORRECT
autoload -Uz compinit && compinit -C

# ===== Aliases (通用部分) =====
alias ls='ls -GF --color=auto'
alias la='ls -AGF --color=auto'
alias ll='ls -lAGF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias c='clear'
alias zshconfig='$EDITOR ~/.zshrc'
alias zshsource='source ~/.zshrc'
if command -v wezterm >/dev/null 2>&1 && [[ -r "$HOME/Dotfiles/transparent.lua" ]]; then
  alias ghost='wezterm --config-file "$HOME/Dotfiles/transparent.lua" start'
fi

# --- OS-specific Aliases & Functions ---
if [[ "$(uname)" == "Darwin" ]]; then
  alias macver='sw_vers'
  # macOS light/dark aware LSCOLORS
  function set_macos_terminal_colors() {
    if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
      export LSCOLORS="Gxfxcxdxbxegedabagacad"
    else
      export LSCOLORS="exfxcxdxbxegedabagacad"
    fi
  }
  set_macos_terminal_colors
fi

# ===== Powerlevel10k (if installed) =====
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ----- Optional: Antigravity (only if installed) -----
if [[ -d "$HOME/.antigravity/antigravity/bin" ]]; then
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

# Optional: Homebrew Ruby (mac only, only if exists)
if [[ "$(uname)" == "Darwin" && -d "/opt/homebrew/opt/ruby/bin" ]]; then
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
fi

# Local machine overrides (NOT committed)
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

