# Customizations & Architecture

This configuration started as a fork of `kickstart.nvim` but has been significantly expanded and modularized.

## Modular Structure

The configuration is split into several parts to keep `init.lua` clean:

- `init.lua`: Core entry point, plugin manager setup (`lazy.nvim`), and integrated statusline.
- `lua/custom/options.lua`: General Neovim settings (indentation, UI tweaks, etc.).
- `lua/custom/map.lua`: Global keybindings and AI provider management.
- `lua/custom/ai.lua`: Logic for switching between AI completion providers.
- `lua/custom/plugins/*.lua`: Individual plugin configurations.

## Added Plugins

Beyond the standard kickstart plugins, the following have been added:

- **AI Assistants:**
    - `llama.vim`: Local FIM code completion via `llama-server` (Qwen2.5-Coder 1.5B on macOS, 7B on Linux).
    - `ChatGPT.nvim`: Interactive chat interface.
- **File Management:**
    - `oil.nvim`: Edit directories as text buffers.
    - `neo-tree.nvim`: Sidebar file explorer.
- **UI & UX:**
    - `langmapper.nvim`: Seamlessly handles keymaps for non-Latin layouts.
    - `blink.cmp`: Modern, fast completion engine replacing nvim-cmp.
    - `mini.statusline`: Customized with a dedicated AI status indicator.
    - `obsidian.nvim`: Integration for Obsidian notes.
    - `outline.nvim`: A code outline sidebar.
    - `hlslens.nvim` & `nvim-scrollbar`: Improved search visibility and navigation.

## Key Differences from Kickstart

1. **Local AI Completion:** `llama.vim` talks to a local `llama-server`; nvim auto-starts the server (`lua/custom/plugins/llama.lua`).
2. **Modern Completion:** Shifted from `nvim-cmp` to `blink.cmp` for better performance and easier configuration.
3. **Enhanced Statusline:** The statusline is reactive and displays which AI provider is currently active (`AI:LL` for llama.vim, `AI:OFF` when disabled).
4. **Layout Independence:** Thanks to `langmapper`, all commands work regardless of your active keyboard layout.
