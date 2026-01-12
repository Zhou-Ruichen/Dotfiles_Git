# Dotfiles

A small, cross-platform dotfiles setup for **macOS / Linux / Windows** (PowerShell + symlinks).  
Goal: keep **one shared config** in this repo, and put **machine-specific / auto-generated** stuff into `*.local` files that are **NOT committed**.

---

## Repo structure

- `.zshrc` / `.zprofile`  
  Shared Zsh configs (cross-platform).
- `.wezterm.lua`  
  Shared WezTerm base config.
- `transparent.lua`  
  A "stealth/transparent" WezTerm profile that **inherits** `.wezterm.lua`.
- `.gitignore`  
  Ignores `*.local` and backup files.

---

## Philosophy

✅ **Shared in Git**: stable, cross-platform logic  
❌ **Not shared in Git**: machine-specific paths, conda init blocks, CLI tools that auto-modify shell configs, tokens, proxies, etc.

Use:

- `~/.zshrc.local`
- `~/.zprofile.local`

These files are sourced by `.zshrc/.zprofile` (repo-managed) and should be ignored by Git.

---

## Quick start

### 1) Clone the repo

```bash
cd ~
git clone git@github.com:Zhou-Ruichen/Dotfiles_Git.git Dotfiles
cd ~/Dotfiles
````

### 2) Create symlinks (recommended)

> If files already exist, back them up first.

#### macOS / Linux

```bash
# Backup (optional)
mv ~/.zshrc ~/.zshrc.bak 2>/dev/null || true
mv ~/.zprofile ~/.zprofile.bak 2>/dev/null || true
mv ~/.wezterm.lua ~/.wezterm.lua.bak 2>/dev/null || true

# Symlink
ln -sf ~/Dotfiles/.zshrc ~/.zshrc
ln -sf ~/Dotfiles/.zprofile ~/.zprofile
ln -sf ~/Dotfiles/.wezterm.lua ~/.wezterm.lua
```

#### Windows (PowerShell)

Run PowerShell **as Administrator** if needed for symlinks:

```powershell
# Backup (optional)
Move-Item $HOME\.zshrc $HOME\.zshrc.bak -ErrorAction SilentlyContinue
Move-Item $HOME\.zprofile $HOME\.zprofile.bak -ErrorAction SilentlyContinue
Move-Item $HOME\.wezterm.lua $HOME\.wezterm.lua.bak -ErrorAction SilentlyContinue

# Symlink
New-Item -ItemType SymbolicLink -Path $HOME\.zshrc -Target $HOME\Dotfiles\.zshrc
New-Item -ItemType SymbolicLink -Path $HOME\.zprofile -Target $HOME\Dotfiles\.zprofile
New-Item -ItemType SymbolicLink -Path $HOME\.wezterm.lua -Target $HOME\Dotfiles\.wezterm.lua
```

### 3) Reload shell

```bash
source ~/.zshrc
```

---

## Local overrides (IMPORTANT)

Create machine-specific overrides:

```bash
nano ~/.zshrc.local
nano ~/.zprofile.local
```

Common examples:

### Linux: PATH de-dup + LM Studio

```zsh
# ~/.zshrc.local (Linux)
typeset -U path PATH

function add_path_if_exists() {
  [[ -d "$1" ]] && path+=("$1")
}

add_path_if_exists "$HOME/.lmstudio/bin"
unset -f add_path_if_exists
```

### macOS: Homebrew init (recommended in ~/.zprofile.local)

```zsh
# ~/.zprofile.local (macOS)
if [[ "$(uname)" == "Darwin" && -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
```

### Conda / Mamba

Do **NOT** commit `conda init` blocks into `.zshrc`.
Put them in `~/.zshrc.local` (preferred) or `~/.zprofile.local` depending on your setup.

---

## WezTerm

### Base config

The shared base config lives in:

* `~/Dotfiles/.wezterm.lua`

### Stealth/transparent profile

`transparent.lua` inherits the base config and overrides opacity/colors.

Start it using the `ghost` alias:

```bash
type ghost
ghost
```

> `ghost` is only defined if `wezterm` exists and `~/Dotfiles/transparent.lua` is readable.

---

## Notes for Linux packages

If you want zsh plugins available via system packages:

* `fzf`
* `zsh-autosuggestions`
* `zsh-syntax-highlighting`

On Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y fzf zsh-autosuggestions zsh-syntax-highlighting
```

---

## Updating dotfiles

On any machine:

```bash
cd ~/Dotfiles
git pull
source ~/.zshrc
```

---

## Troubleshooting

### PATH contains duplicates

* Prefer `typeset -U path PATH` in `~/.zshrc.local` on zsh.
* Restart the terminal to clear inherited environment from old sessions.

### WezTerm config errors

Check logs printed on startup. Validate base config:

```bash
wezterm --config-file ~/Dotfiles/.wezterm.lua start
```

Validate transparent profile:

```bash
wezterm --config-file ~/Dotfiles/transparent.lua start
```

---

## Security

Never commit:

* tokens / API keys
* SSH private keys
* proxy credentials
* `NODE_TLS_REJECT_UNAUTHORIZED=0` (keep it in `~/.zshrc.local` only if you really need it)

---

## License

Personal use. Modify as needed.
