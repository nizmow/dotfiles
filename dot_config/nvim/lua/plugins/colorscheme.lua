return {
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    opts = {
      options = {
        transparent = false,
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd.colorscheme("github_light")
    end,
  },
}
