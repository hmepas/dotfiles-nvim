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

##### Treesitter on Neovim 0.12+
This config pins `nvim-treesitter` to the `main` branch (required for Neovim 0.12+).
The new branch compiles parsers on the fly and requires the `tree-sitter` CLI binary,
which on Arch ships as a **separate package** from the `tree-sitter` library:
```bash
sudo pacman -S --needed tree-sitter-cli
```
Without it `:TSUpdate` / `require('nvim-treesitter').install(...)` fails with
`ENOENT: no such file or directory (cmd): 'tree-sitter'`.

If you upgraded and parsers look broken, wipe the old install and let Lazy rebuild:
```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter
nvim --headless "+Lazy! sync" +qa
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

## AI Agents & Usage

This configuration includes three AI assistants: two for real-time completion (inline) and one for interactive chat.

### 1. Real-time Completion (Inline)
Only one provider is active at a time to avoid conflicts. You can toggle between them using these keymaps:

*   `<leader>pas`: **[P]**lugins **[A]**I **[S]**upermaven toggle.
*   `<leader>paw`: **[P]**lugins **[A]**I **[W]**indsurf (Codeium) toggle.
*   `:AIOff`: Disable all inline AI completion.

The statusline shows the active provider: `AI:SM` (Supermaven), `AI:CI` (Codeium/Windsurf), or `AI:OFF`.

### 2. Interactive Chat (ChatGPT)
ChatGPT is always available regardless of the completion provider. It does not provide inline suggestions but offers a dedicated interface:

*   `:ChatGPT`: Open the main chat window.
*   `:ChatGPTEditWithInstructions`: Edit selected code with natural language.

### Configuration
Secrets are read from local files in your home directory (to keep them out of the repo):

| Provider | Secret File | Source (Bitwarden) |
|---|---|---|
| **Codeium / Windsurf** | `~/.codeium/config.json` | `windsurf-api-token` |
| **ChatGPT** | `~/.neovim-chatgpt-api-key` | `neovim-chatgpt` |
| **Supermaven** | (Handled internally by plugin) | - |

To set them up manually:
```bash
# Codeium / Windsurf
mkdir -p ~/.codeium
echo '{"apiKey": "your-sk-ws-token-here"}' > ~/.codeium/config.json

# ChatGPT
echo "your-openai-key-here" > ~/.neovim-chatgpt-api-key
chmod 600 ~/.neovim-chatgpt-api-key
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
