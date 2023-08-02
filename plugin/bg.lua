local reset = function()
  os.execute('printf "\\033]111\\007" > ' .. tty)
end

local update = function()
  local normal = vim.api.nvim_get_hl_by_name("Normal", true)
  local bg = normal["background"]
  local fg = normal["foreground"]
  if bg == nil then
    return reset()
  end

  local bghex = string.format("#%06x", bg)
  os.execute('printf "\\033]11;' .. bghex .. '\\007" > ' .. tty)

  local fghex = string.format("#%06x", fg)
  os.execute('printf "\\033]12;' .. fghex .. '\\007" > ' .. tty)
end

local setup = function()
  -- 已经处理了背景色问题的终端就不需要运行了
  if vim.fn.match(vim.fn.getenv('TERM_PROGRAM'), "iTerm") == 0 then
    return
  end

  -- 这个IO应该比较快?
  local handle = io.popen("tty")
  tty = handle:read("*a") -- global var
  handle:close()

  vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, { callback = update })
  vim.api.nvim_create_autocmd({ "VimLeavePre" }, { callback = reset })
end

setup()
