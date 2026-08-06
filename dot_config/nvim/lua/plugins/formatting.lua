local languages = require("config.languages")

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = languages.formatters_by_ft(),
    },
  },
}
