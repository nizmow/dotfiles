# Neovim Config

- **Plugin manager:** lazy.nvim
- **LSP:** built-in LSP (`vim.lsp.*`), with `mason.nvim` for installing servers
- **Keybinding style:** Lazyvim style (leader key = `<Space>`, modal/prefix-based) pull https://www.lazyvim.org/keymaps
- **Base:** kickstart.nvim structure (`init.lua` entry, modular `lua/` dir)
- **Language:** Lua throughout

## Conventions

- Add plugin specs under `lua/plugins/`.
- Add/edit language tooling in `lua/config/languages.lua`.
- Add general options in `lua/config/options.lua`.
- Add global keymaps in `lua/config/keymaps.lua`.
- Prefer small, focused modules over large inline config blocks.

## Verification

After making any changes, verify the config loads without errors:
`nvim --headless -c "qa!"` (exit code 0 = clean). Report and fix any errors found.

For non-fatal startup/plugin warnings shown as notifications, run:
`./nvim_test.sh`

This enables `NVIM_DEBUG=1`, performs standard plugin initialization headlessly, validates `mason-lspconfig.nvim` `ensure_installed` entries, and writes captured messages, Snacks notifications, LSP state, Lazy state, and Mason state to `nvim-capture.log`. Use `NVIM_DEBUG_VERBOSE=1 ./nvim_test.sh` when full LSP/diagnostic payloads are needed.

Headless verification is a smoke test, not a full interactive startup check. Some plugins intentionally skip interactive side effects in headless mode. When changing Mason/LSP config, explicitly verify that `vim.lsp.enable()` server names use lspconfig server names, not Mason package names.
