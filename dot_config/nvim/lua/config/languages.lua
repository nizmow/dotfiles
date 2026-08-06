local M = {}

M.languages = {
  bash = {
    filetypes = { "bash", "sh", "zsh" },
    formatter = "shfmt",
    treesitter = "bash",
    mason = { "shfmt" },
  },
  csharp = {
    filetypes = { "cs" },
    lsp = "roslyn_ls",
    formatter = "csharpier",
    treesitter = "c_sharp",
    mason = { "csharpier" },
  },
  go = {
    filetypes = { "go" },
    formatter = "gofmt",
    linter = "golangcilint",
    treesitter = "go",
    mason = { "golangci-lint" },
  },
  json = {
    filetypes = { "json" },
    treesitter = "json",
  },
  lua = {
    filetypes = { "lua" },
    lsp = "lua_ls",
    formatter = "stylua",
    treesitter = { "lua", "luadoc" },
    mason = { "stylua" },
  },
  markdown = {
    filetypes = { "markdown" },
    linter = "markdownlint-cli2",
    treesitter = { "markdown", "markdown_inline" },
    mason = { "markdownlint-cli2", "markdown-toc" },
  },
  python = {
    filetypes = { "python" },
    lsp = "pyright",
    treesitter = "python",
  },
  rust = {
    filetypes = { "rust" },
    lsp = "rust_analyzer",
    treesitter = "rust",
  },
  toml = {
    filetypes = { "toml" },
    treesitter = "toml",
    mason = { "taplo" },
  },
  typescript = {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    lsp = "ts_ls",
    treesitter = { "tsx", "typescript" },
  },
  vim = {
    filetypes = { "vim" },
    treesitter = { "vim", "vimdoc" },
  },
  yaml = {
    filetypes = { "yaml" },
    treesitter = "yaml",
  },
}

M.extra_mason_tools = {
  "netcoredbg",
  "tree-sitter-cli",
}

local function add_unique(list, seen, value)
  if value and not seen[value] then
    seen[value] = true
    list[#list + 1] = value
  end
end

local function values(value)
  if not value then
    return {}
  end
  if type(value) == "table" then
    return value
  end
  return { value }
end

function M.lsp_servers()
  local list, seen = {}, {}
  for _, lang in pairs(M.languages) do
    for _, server in ipairs(values(lang.lsp)) do
      add_unique(list, seen, server)
    end
  end
  table.sort(list)
  return list
end

function M.mason_tools()
  local list, seen = {}, {}
  for _, tool in ipairs(M.extra_mason_tools) do
    add_unique(list, seen, tool)
  end
  for _, lang in pairs(M.languages) do
    for _, tool in ipairs(values(lang.mason)) do
      add_unique(list, seen, tool)
    end
  end
  table.sort(list)
  return list
end

function M.treesitter_parsers()
  local list, seen = {}, {}
  for _, lang in pairs(M.languages) do
    for _, parser in ipairs(values(lang.treesitter)) do
      add_unique(list, seen, parser)
    end
  end
  table.sort(list)
  return list
end

function M.formatters_by_ft()
  local by_ft = {}
  for _, lang in pairs(M.languages) do
    if lang.formatter then
      for _, ft in ipairs(values(lang.filetypes)) do
        by_ft[ft] = values(lang.formatter)
      end
    end
  end
  return by_ft
end

function M.linters_by_ft()
  local by_ft = {}
  for _, lang in pairs(M.languages) do
    if lang.linter then
      for _, ft in ipairs(values(lang.filetypes)) do
        by_ft[ft] = values(lang.linter)
      end
    end
  end
  return by_ft
end

return M
