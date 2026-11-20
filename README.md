# Neovim Configuration (dotfiles-nvim)

This is a customized Neovim configuration based on `kickstart.nvim`, tailored for a productive development environment on macOS and Arch Linux.

## Installation

### 1. Install Neovim
Ensure you have the latest stable or nightly version of Neovim.

### 2. Install Dependencies

#### macOS
```bash
brew install neovim git make unzip gcc ripgrep fd go
# Local AI completion (llama-server)
brew install llama.cpp
# Fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font font-iosevka-nerd-font
```

#### Arch Linux
```bash
sudo pacman -S --needed neovim git make unzip gcc ripgrep fd go
# Local AI completion (llama-server), AUR (NVIDIA CUDA)
paru -S llama.cpp-cuda-git
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

### 5. Download the completion model (optional)
nvim starts `llama-server` itself, but on the very first start the model is downloaded and completion is unavailable until it finishes (~1.6GB on macOS, ~8.1GB on Linux). To pre-download it, run once and stop with `Ctrl-C` after `listening on http://127.0.0.1:8012`:
```bash
# macOS
llama-server --fim-qwen-1.5b-default --port 8012
# Linux (GPU)
llama-server --fim-qwen-7b-default --port 8012
```

## AI Agents & Usage

This configuration includes two AI assistants: a local model for real-time completion (inline) and ChatGPT for interactive chat.

### 1. Real-time Completion (Inline, local)
[llama.vim](https://github.com/ggml-org/llama.vim) + `llama-server` with Qwen2.5-Coder (1.5B on macOS, 7B on Linux, FIM). Runs fully on the machine, no code leaves it.

*   Requires `llama.cpp` (`brew install llama.cpp` on macOS, `paru -S llama.cpp-cuda-git` on Arch). nvim starts `llama-server` on port 8012 in the background if it is not running (model is downloaded on first start).
*   `<C-g>`: accept suggestion, `<C-;>`: accept word.
*   `<leader>pal`: **[P]**lugins **[A]**I **[L]**lama toggle (`:LlamaToggle`, `:LlamaDisable`, `:LlamaEnable`).

The statusline shows `AI:LL` (enabled) or `AI:OFF`.

### 2. Interactive Chat (ChatGPT)
ChatGPT is always available regardless of the completion provider. It does not provide inline suggestions but offers a dedicated interface:

*   `:ChatGPT`: Open the main chat window.
*   `:ChatGPTEditWithInstructions`: Edit selected code with natural language.

### Configuration
Secrets are read from local files in your home directory (to keep them out of the repo):

| Provider | Secret File | Source (Bitwarden) |
|---|---|---|
| **ChatGPT** | `~/.neovim-chatgpt-api-key` | `neovim-chatgpt` |

To set them up manually:
```bash
# ChatGPT
echo "your-openai-key-here" > ~/.neovim-chatgpt-api-key
chmod 600 ~/.neovim-chatgpt-api-key
```

## Key Features

- **Package Manager:** `lazy.nvim`
- **LSP/Formatters:** Managed via `mason.nvim` and `conform.nvim`
- **Completion:** `blink.cmp`
- **AI Toggles:**
    - `<leader>pal`: Toggle local llama.vim completion
- **File Explorers:** `neo-tree` (toggle with `\`) and `oil.nvim` (open with `-`)

See [CUSTOM.md](./CUSTOM.md) for a full list of customizations.
