-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      omnisharp = { enabled = false }, -- Ensure OmniSharp is dead
      csharp_ls = {
        mason = false,
        cmd = { "mise", "x", "--", "csharp-ls" },
        -- cmd = { vim.fn.expand("~/.dotnet/tools/csharp-ls") },
      }, -- Enable the better server
    },
  },
}
