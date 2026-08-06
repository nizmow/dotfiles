vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>")
vim.keymap.set("n", "<Leader>c", "<Cmd>bd!<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<Leader>h", "<Cmd>nohlsearch<CR>", { desc = "Clear highlights" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, { desc = "Line diagnostic" })

-- Command palette: commands + keymaps. Use <C-S-p> if your terminal supports it,
-- otherwise fall back to <Leader>sC.
vim.keymap.set("n", "<C-S-p>", function()
  Snacks.picker({
    title = "Commands & Keymaps",
    multi = { { source = "commands" }, { source = "keymaps" } },
  })
end, { desc = "Command palette" })
