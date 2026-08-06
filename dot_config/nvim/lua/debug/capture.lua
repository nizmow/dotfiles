local M = {}

local defaults = {
  log_file = vim.fn.stdpath("config") .. "/nvim-capture.log",
  verbose = vim.env.NVIM_DEBUG_VERBOSE == "1",
  categories = {
    notify = true,
    snacks = true,
    messages = true,
    lsp = true,
    diagnostics = true,
    lazy = true,
    mason = true,
  },
}

local state = {
  opts = nil,
  installed = false,
  wrapped = setmetatable({}, { __mode = "k" }),
}

local function enabled(category)
  return state.opts and state.opts.categories[category]
end

local function inspect(value)
  return vim.inspect(value, { newline = "\n" })
end

local function append(msg)
  local f = io.open(state.opts.log_file, "a")
  if not f then
    return
  end

  f:write(os.date("%Y-%m-%d %H:%M:%S") .. " " .. tostring(msg) .. "\n")
  f:close()
end

local function level_name(level)
  if type(level) == "string" then
    return level
  end

  for name, value in pairs(vim.log.levels) do
    if value == level then
      return name:lower()
    end
  end

  return tostring(level)
end

local function simplify_notify(msg, level, opts)
  opts = opts or {}
  return {
    title = opts.title,
    level = level_name(level),
    message = tostring(msg),
  }
end

local function wrap_notify()
  if not enabled("notify") or state.wrapped[vim.notify] then
    return
  end

  local notify = vim.notify
  local wrapped = function(msg, level, opts)
    append("NOTIFY " .. inspect(simplify_notify(msg, level, opts)))
    return notify(msg, level, opts)
  end

  state.wrapped[wrapped] = true
  vim.notify = wrapped
end

local function get_snacks_notifier()
  local ok, notifier = pcall(require, "snacks.notifier")
  if ok then
    return notifier
  end
end

local function wrap_snacks_notifier()
  if not enabled("snacks") then
    return
  end

  local notifier = get_snacks_notifier()
  if not notifier or type(notifier.notify) ~= "function" or state.wrapped[notifier.notify] then
    return
  end

  local notify = notifier.notify
  notifier.notify = function(msg, level, opts)
    append("SNACKS_NOTIFY " .. inspect(simplify_notify(msg, level, opts)))
    return notify(msg, level, opts)
  end
  state.wrapped[notifier.notify] = true
end

local function simplify_snacks_history(history)
  local simplified = {}
  for _, notif in ipairs(history or {}) do
    simplified[#simplified + 1] = {
      id = notif.id,
      title = notif.title,
      level = notif.level,
      message = notif.msg,
      shown = notif.shown ~= nil,
    }
  end
  return simplified
end

local function dump_snacks_history()
  if not enabled("snacks") then
    return
  end

  local notifier = get_snacks_notifier()
  if not notifier or type(notifier.get_history) ~= "function" then
    return
  end

  local ok, history = pcall(notifier.get_history)
  if ok then
    append("=== SNACKS NOTIFICATION HISTORY ===\n" .. inspect(simplify_snacks_history(history)))
  end
end

local function dump_messages()
  if not enabled("messages") then
    return
  end

  local ok, messages = pcall(vim.fn.execute, "messages")
  if ok then
    append("=== MESSAGES ===\n" .. messages)
  end
end

local function diagnostic_summary(diagnostics)
  local summary = {}
  for _, diagnostic in ipairs(diagnostics or {}) do
    local source = diagnostic.source or "unknown"
    local severity = diagnostic.severity or "unknown"
    local key = source .. ":" .. tostring(severity)
    summary[key] = (summary[key] or 0) + 1
  end
  return summary
end

local function setup_diagnostics()
  if not enabled("diagnostics") then
    return
  end

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = vim.api.nvim_create_augroup("debug-capture-diagnostics", { clear = true }),
    callback = function(args)
      if state.opts.verbose then
        append("DIAGNOSTICS " .. inspect(args.data))
        return
      end

      append("DIAGNOSTICS " .. inspect({
        bufnr = args.buf,
        file = vim.api.nvim_buf_get_name(args.buf),
        count = #(args.data.diagnostics or {}),
        summary = diagnostic_summary(args.data.diagnostics),
      }))
    end,
  })
end

local function setup_lsp()
  if not enabled("lsp") then
    return
  end

  vim.lsp.log.set_level(state.opts.verbose and "debug" or "info")

  for method, handler in pairs(vim.lsp.handlers) do
    if type(handler) == "function" and not state.wrapped[handler] then
      local original = handler
      vim.lsp.handlers[method] = function(err, result, ctx, config)
        local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
        append("LSP_HANDLER " .. inspect({
          method = method,
          client = client and client.name or nil,
          error = err,
          result = state.opts.verbose and result or type(result),
        }))
        return original(err, result, ctx, config)
      end
      state.wrapped[vim.lsp.handlers[method]] = true
    end
  end

  local group = vim.api.nvim_create_augroup("debug-capture-lsp", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      append("LSP_ATTACH " .. inspect({
        bufnr = args.buf,
        file = vim.api.nvim_buf_get_name(args.buf),
        client = client and client.name or nil,
        root_dir = client and client.config and client.config.root_dir or nil,
        cmd = client and client.config and client.config.cmd or nil,
      }))
    end,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      append("LSP_DETACH " .. inspect({
        bufnr = args.buf,
        file = vim.api.nvim_buf_get_name(args.buf),
        client = client and client.name or args.data.client_id,
      }))
    end,
  })
end

local function dump_lsp_clients()
  if not enabled("lsp") then
    return
  end

  local clients = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    clients[#clients + 1] = {
      id = client.id,
      name = client.name,
      root_dir = client.config and client.config.root_dir or nil,
      cmd = client.config and client.config.cmd or nil,
    }
  end
  append("=== LSP CLIENTS ===\n" .. inspect(clients))
end

local function dump_lazy_state()
  if not enabled("lazy") then
    return
  end

  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return
  end

  local plugins = {}
  for name, plugin in pairs(lazy_config.plugins or {}) do
    if plugin._.loaded or plugin._.error then
      plugins[#plugins + 1] = {
        name = name,
        loaded = plugin._.loaded ~= nil,
        error = plugin._.error,
      }
    end
  end

  append("=== LAZY PLUGINS ===\n" .. inspect(plugins))
end

local function dump_mason_state()
  if not enabled("mason") then
    return
  end

  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    return
  end

  local packages = {}
  for _, package in ipairs(registry.get_installed_packages()) do
    packages[#packages + 1] = package.name
  end
  table.sort(packages)

  append("=== MASON INSTALLED ===\n" .. inspect(packages))
end

function M.dump()
  wrap_notify()
  wrap_snacks_notifier()
  dump_messages()
  dump_snacks_history()
  dump_lsp_clients()
  dump_lazy_state()
  dump_mason_state()
end

function M.setup(opts)
  if state.installed then
    return M
  end

  state.opts = vim.tbl_deep_extend("force", defaults, opts or {})
  state.installed = true

  vim.fn.delete(state.opts.log_file)
  append("DEBUG_CAPTURE_START " .. inspect({
    log_file = state.opts.log_file,
    verbose = state.opts.verbose,
    nvim = vim.version(),
  }))

  wrap_notify()
  setup_lsp()
  setup_diagnostics()

  vim.api.nvim_create_user_command("DebugCaptureDump", M.dump, {})

  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("debug-capture-startup", { clear = true }),
    callback = function()
      wrap_notify()
      wrap_snacks_notifier()
      dump_messages()
      vim.notify("Debug capture active -> " .. state.opts.log_file, vim.log.levels.INFO)
    end,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("debug-capture-exit", { clear = true }),
    callback = M.dump,
  })

  return M
end

return M
