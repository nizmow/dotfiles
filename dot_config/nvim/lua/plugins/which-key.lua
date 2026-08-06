return {
  "folke/which-key.nvim",
  opts = {
    preset = "helix",
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<Leader><Space>", function() Snacks.picker.smart() end, desc = "Find files (smart)" },
      { "<Leader>f", group = "File" },
      { "<Leader>f/", function() Snacks.picker.lines() end, desc = "Lines" },
      { "<Leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<Leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<Leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<Leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<Leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<Leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<Leader>fR", function() Snacks.picker.projects() end, desc = "Projects" },

      { "<Leader>s", group = "Search" },
      { "<Leader>sC", function()
        Snacks.picker({
          title = "Commands & Keymaps",
          multi = { { source = "commands" }, { source = "keymaps" } },
        })
      end, desc = "Command palette" },
      { "<Leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<Leader>sl", function() Snacks.picker.loclist() end, desc = "Location list" },
      { "<Leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      { "<Leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<Leader>sn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<Leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },

      { "<Leader>b", group = "Buffer" },
      { "<Leader>bb", function() Snacks.picker.buffers() end, desc = "Switch buffer" },
      { "<Leader>bd", "<Cmd>bdelete<CR>", desc = "Delete buffer" },

      { "<Leader>g", group = "Git" },

      { "<Leader>w", group = "Window" },
      { "<Leader>wh", "<C-w>h", desc = "Left" },
      { "<Leader>wj", "<C-w>j", desc = "Down" },
      { "<Leader>wk", "<C-w>k", desc = "Up" },
      { "<Leader>wl", "<C-w>l", desc = "Right" },
      { "<Leader>wv", "<C-w>v", desc = "Split right" },
      { "<Leader>ws", "<C-w>s", desc = "Split down" },
      { "<Leader>wc", "<C-w>c", desc = "Close" },
      { "<Leader>wo", "<C-w>o", desc = "Only" },

      { "<Leader>t", group = "Toggle" },
      { "<Leader>tl", "<Cmd>set list!<CR>", desc = "Show whitespace" },
      { "<Leader>tn", "<Cmd>set relativenumber!<CR>", desc = "Relative numbers" },
      { "<Leader>tw", "<Cmd>set wrap!<CR>", desc = "Wrap" },

      { "<Leader>q", "<Cmd>confirm q<CR>", desc = "Quit" },
    })
  end,
}
