# Neovim Configuration (dotfiles-nvim)

This is a customized Neovim configuration based on `kickstart.nvim`, tailored for a productive development environment on macOS and Arch Linux.

## Installation

### 1. Install Neovim
Ensure you have the latest stable or nightly version of Neovim.

### 2. Install Dependencies

#### macOS
```bash
brew install neovim git make unzip gcc ripgrep fd go
# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font font-iosevka-nerd-font
```

#### Arch Linux
```bash
sudo pacman -S --needed neovim git make unzip gcc ripgrep fd go
# Fonts
sudo pacman -S ttf-hack-nerd ttf-iosevka-nerd
```

### 3. Clone this repository
Cloning directly to `~/.config/nvim` is the recommended way as this repository is standalone:
```bash
git clone https://github.com/hmepas/dotfiles-nvim.git ~/.config/nvim
```

### 4. Bootstrap
Start Neovim:
```bash
nvim
```
Lazy.nvim will automatically download and install all plugins. You can also run it headlessly:
```bash
nvim --headless "+Lazy! sync" +qa
```

## AI Agents & Secrets

This config supports multiple AI providers (Supermaven, Codeium/Windsurf, ChatGPT). By default, they are toggled via keymaps and require API keys/tokens.

### Configuration
Secrets are read from local files in your home directory (to keep them out of the repo):

| Provider | Secret File | Source (Bitwarden) |
|---|---|---|
| **Codeium / Windsurf** | `~/.windsurf-api-token` | `windsurf-api-token` |
| **ChatGPT** | `~/.neovim-chatgpt-api-key` | `neovim-chatgpt` |
| **Supermaven** | (Handled internally by plugin) | - |

To set them up manually:
```bash
echo "your-token-here" > ~/.windsurf-api-token
echo "your-openai-key-here" > ~/.neovim-chatgpt-api-key
chmod 600 ~/.windsurf-api-token ~/.neovim-chatgpt-api-key
```

## Key Features

- **Package Manager:** `lazy.nvim`
- **LSP/Formatters:** Managed via `mason.nvim` and `conform.nvim`
- **Completion:** `blink.cmp`
- **AI Toggles:**
    - `<leader>paw`: Toggle Windsurf (Codeium)
    - `<leader>pas`: Toggle Supermaven
    - `:AIOff`: Disable all AI providers
- **File Explorers:** `neo-tree` (toggle with `\`) and `oil.nvim` (open with `-`)

See [CUSTOM.md](./CUSTOM.md) for a full list of customizations.
