local M = {}

local function validate_mason_lspconfig()
  local ok_settings, settings = pcall(require, "mason-lspconfig.settings")
  local ok_mappings, mappings = pcall(require, "mason-lspconfig.mappings")
  local ok_package, Package = pcall(require, "mason-core.package")

  if not (ok_settings and ok_mappings and ok_package) then
    return
  end

  local map = mappings.get_mason_map()
  local invalid = {}

  for _, server_identifier in ipairs(settings.current.ensure_installed or {}) do
    local server_name = Package.Parse(server_identifier)
    if not map.lspconfig_to_package[server_name] then
      invalid[#invalid + 1] = server_identifier
    end
  end

  if #invalid > 0 then
    error(
      "Invalid mason-lspconfig ensure_installed entries. Use lspconfig server names, not Mason package names: "
        .. table.concat(invalid, ", "),
      0
    )
  end
end

function M.run()
  validate_mason_lspconfig()
end

return M
