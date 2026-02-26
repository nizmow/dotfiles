return {
  {
    "yetone/avante.nvim",
    opts = {
      -- 1. Tell Avante to use your custom provider name
      provider = "gemini-acp",

      -- 2. Define the ACP provider
      acp_providers = {
        ["gemini-acp"] = {
          command = "gemini", -- The CLI command
          args = { "--experimental-acp" }, -- REQUIRED flag for Agent mode
          env = {
            -- The CLI still needs this key to talk to Google's servers
            GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
          },
        },
      },
    },
  },
}
