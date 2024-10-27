if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

vim.opt.wrap = true -- Aquí activas el wrap

require("config.lazy")

--Hola mundo.
--

-- Cargar la configuración de DAP
require("plugins.dap")
