return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      menu = {
        auto_show = function()
          -- 1. Always enable in Command Line mode
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          end

          local function is_comment_or_string()
            -- Get current cursor position (0-based)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local line = vim.api.nvim_win_get_cursor(0)[1] - 1

            -- Helper to check a specific position safely
            local function check_node(r, c)
              local ok, node = pcall(vim.treesitter.get_node, { pos = { r, c } })
              if not ok or not node then
                return false
              end
              return vim.tbl_contains({
                "comment",
                "line_comment",
                "block_comment",
                "string",
                "string_fragment",
                "string_content",
              }, node:type())
            end

            -- Check the position BEHIND the cursor (This fixes your issue!)
            if col > 0 and check_node(line, col - 1) then
              return true
            end

            -- Fallback: Check strictly at cursor (for middle-of-text edits)
            if check_node(line, col) then
              return true
            end

            return false
          end

          -- If we are in a comment/string, DISABLE blink (return false)
          return not is_comment_or_string()
        end,

        -- auto_show = function(ctx)
        --   -- 2. Check strict text contexts where we don't want completion
        --   --    This uses Treesitter to check if the cursor is in a comment or string
        --   local node = vim.treesitter.get_node()
        --   if node and vim.tbl_contains({ "comment", "line_comment", "block_comment", "string" }, node:type()) then
        --     return false
        --   end
        --
        --   -- 3. Otherwise, show the menu
        --   return true
        -- end,
      },
    },
  },
}
