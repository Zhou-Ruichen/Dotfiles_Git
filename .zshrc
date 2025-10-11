# ----- Powerlevel10k instant prompt (keep at top) -----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ===== Basic environment =====
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/bin:$HOME/.local/bin:$PATH"
export EDITOR='code'   # 改成你常用的编辑器：code / nvim / vim

# ===== Oh My Zsh & theme =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)  # 其余插件用 brew 版本手动 source（更稳定）
source $ZSH/oh-my-zsh.sh

# ===== Brew-based plugins =====
# 自动建议 & 语法高亮（先安装：brew install zsh-autosuggestions zsh-syntax-highlighting）
[[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# FZF（模糊搜索，先执行：$(brew --prefix)/opt/fzf/install --all）
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# ===== History & options =====
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS SHARE_HISTORY
setopt AUTO_CD AUTO_PUSHD EXTENDED_GLOB CORRECT
autoload -Uz compinit && compinit -C

# ===== Prompt (if not using p10k lean) =====
# autoload -U colors && colors
# setopt prompt_subst
# PROMPT='%{$fg[cyan]%}%n@%m %{$fg[yellow]%}%~ %{$reset_color%}$(git_prompt_info)❯ '

# ===== Aliases =====
alias ls='ls -GF'
alias la='ls -AGF'
alias ll='ls -lAGF'
alias ..='cd ..'
alias ...='cd ../..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias grep='grep --color=auto'
alias c='clear'
alias macver='sw_vers'
alias zshconfig='$EDITOR ~/.zshrc'
alias zshsource='source ~/.zshrc'

# ===== macOS light/dark aware LSCOLORS =====
function set_macos_terminal_colors() {
  if [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]; then
    export LSCOLORS="Gxfxcxdxbxegedabagacad"
  else
    export LSCOLORS="exfxcxdxbxegedabagacad"
  fi
}
set_macos_terminal_colors

# ===== Powerlevel10k (if installed) =====
[[ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] && \
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

