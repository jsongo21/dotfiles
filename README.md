# Dotfiles

Personal configuration files for macOS and Linux development environments.

## What's Included

- **Shell**: Zsh with oh-my-zsh, custom aliases and functions
- **Terminal**: Alacritty configuration
- **Editor**: Neovim with Lua-based configuration
- **Multiplexer**: tmux with plugins via tpm
- **Claude**: Claude Code settings and custom skills
- **Browser**: Firefox user.js preferences

## Installation

### macOS

```bash
./install/macos.sh
```

Installs Homebrew, packages from Brewfile, and oh-my-zsh.

### Ubuntu

```bash
./install/ubuntu.sh
```

Installs core packages, Neovim, zsh plugins, and development tools.

### Arch Linux

```bash
./install/arch-linux.sh
```

Installs packages from pacman-packages list and sets up the environment.

## Setup

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) for managing symlinks.

```bash
cd ~/dotfiles

# Core configs (cross-platform)
stow home

# Platform-specific configs
stow mac    # macOS only
stow linux  # Linux only
```

This creates symlinks from the package directories to `~/`. For example, `stow home` links `~/dotfiles/home/.zshrc` to `~/.zshrc`.

## Structure

```
.
├── home/              # Cross-platform dotfiles
│   ├── .config/
│   │   └── nvim/     # Neovim configuration
│   ├── .zshrc
│   ├── .tmux.conf
│   └── .alacritty.toml
├── mac/               # macOS-specific
│   ├── Brewfile
│   └── .config/
├── linux/             # Linux-specific
└── install/           # Installation scripts
    ├── macos.sh
    ├── ubuntu.sh
    └── arch-linux.sh
```

## Key Packages

See `mac/Brewfile` for macOS packages or `install/pacman-packages` for Arch Linux.

Core tools:
- neovim
- tmux
- ripgrep
- fzf
- asdf (version manager)
- docker + colima

### Installing from Brewfile

To install all packages, casks, and VS Code extensions listed in the Brewfile:

```bash
brew bundle install --file=~/dotfiles/mac/Brewfile
```

This installs all taps, formulae, casks, and VS Code extensions. To check what would be installed without making changes:

```bash
brew bundle check --file=~/dotfiles/mac/Brewfile
```

To list any installed packages not in the Brewfile (orphans):

```bash
brew bundle cleanup --file=~/dotfiles/mac/Brewfile
```

### Updating Brewfile

After installing new packages with Homebrew, update the Brewfile:

```bash
cd ~/dotfiles/mac
brew bundle dump --force
```

This overwrites the Brewfile with all currently installed formulae, casks, and taps

## Post-Installation

1. Set zsh as default shell: `chsh -s $(which zsh)`
2. Install tmux plugins: Open tmux and press `prefix + I`
3. Install Neovim plugins: Open nvim and run `:Lazy sync`

## Notes

- The `.stow-local-ignore` file prevents git metadata and README from being symlinked
- Firefox `user.js` needs to be manually copied to your Firefox profile directory
- Claude Code settings in `home/.claude/` include custom skills and global instructions

