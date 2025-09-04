require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

-- Esto es opcional, solo si lo necesitas para preparar el esquema antes de nvim
os.execute("python ~/.config/nvim/pywal/chadwal.py &> /dev/null &")

-- ~/.config/nvim/init.lua (fragmento final recomendado)

require "plugins"

-- Asegurar que se carga al inicio
local ok, pywal = pcall(require, "pywal")
if ok and pywal.setup then
  pywal.setup()
end

-- Recibir señal SIGUSR1
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    local ok2, pywal2 = pcall(require, "pywal")
    if ok2 and pywal2.setup then
      pywal2.setup()
    end
  end
})

vim.api.nvim_create_user_command("ReloadPywal", function()
  local lazy_loaded = require("lazy.core.config").plugins["pywal"]
  if lazy_loaded and not lazy_loaded._.loaded then
    require("lazy").load({ plugins = { "pywal" } })
  end

  local ok, pywal = pcall(require, "pywal")
  if ok and pywal.setup then
    pywal.setup()
  else
    vim.notify("pywal.setup() no disponible", vim.log.levels.ERROR)
  end
end, {})


