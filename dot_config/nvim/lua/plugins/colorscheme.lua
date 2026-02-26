return {
  { "p00f/alabaster.nvim", name = "alabaster", priority = 1000 },
  { "uloco/bluloco.nvim", name = "bluloco", priority = 1000, dependencies = { "rktjmp/lush.nvim" } },
  {
    "oskarnurm/koda.nvim",
    name = "koda",
    priority = 1000,
    opts = {
      on_highlights = function(hl, c)
        local koda = require("koda")

        -- raise contrast globally (fixes Snacks, notifications, etc)
        hl.NonText = { fg = koda.blend(c.fg, c.bg, 0.45) }

        -- keep these here for later so I remember, in case things get noisy here
        -- hl.EndOfBuffer = { fg = koda.blend(c.bg, c.fg, 0.06) }
        -- hl.Whitespace  = { fg = koda.blend(c.bg, c.fg, 0.10) }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "koda",
    },
  },
}
