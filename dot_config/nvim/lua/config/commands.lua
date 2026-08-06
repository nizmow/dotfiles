local M = {}

local function list(values)
  if not values or vim.tbl_isempty(values) then
    return { "- none" }
  end

  local lines = {}
  for _, value in ipairs(values) do
    lines[#lines + 1] = "- `" .. value .. "`"
  end
  return lines
end

local function map_list(map)
  if not map or vim.tbl_isempty(map) then
    return { "- none" }
  end

  local keys = vim.tbl_keys(map)
  table.sort(keys)

  local lines = {}
  for _, key in ipairs(keys) do
    lines[#lines + 1] = "- `" .. key .. "`: `" .. table.concat(map[key], "`, `") .. "`"
  end
  return lines
end

local function section(lines, title, body)
  lines[#lines + 1] = ""
  lines[#lines + 1] = "## " .. title
  vim.list_extend(lines, body)
end

local function current_lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end
  table.sort(names)
  return names
end

function M.config_info()
  local languages = require("config.languages")
  local lines = {
    "# Neovim Config Info",
    "",
    "- Current filetype: `" .. (vim.bo.filetype ~= "" and vim.bo.filetype or "none") .. "`",
  }

  section(lines, "Active LSP clients for current buffer", list(current_lsp_clients()))
  section(lines, "Configured LSP servers", list(languages.lsp_servers()))
  section(lines, "Mason tools", list(languages.mason_tools()))
  section(lines, "Treesitter parsers", list(languages.treesitter_parsers()))
  section(lines, "Formatters by filetype", map_list(languages.formatters_by_ft()))
  section(lines, "Linters by filetype", map_list(languages.linters_by_ft()))

  vim.cmd("vnew")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "markdown"
  vim.api.nvim_buf_set_name(bufnr, "nvim-config-info")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].modifiable = false
end

function M.setup()
  vim.api.nvim_create_user_command("ConfigInfo", M.config_info, {
    desc = "Show configured LSP, Mason, Treesitter, formatter, and linter setup",
  })
end

return M
