-- ~/.config/nvim/lua/plugins/dap.lua

return {
	-- Plugin principal de depuración
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI para la depuración
			"rcarriga/nvim-dap-ui",
			-- Texto virtual en el código durante la depuración
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {}, -- Opciones personalizables
			},
			-- Gestión automática de adaptadores de depuración con mason.nvim
			"jay-babu/mason-nvim-dap.nvim",
			-- Mason.nvim para manejar la instalación de adaptadores
			"williamboman/mason.nvim",
		},
		config = function()
			-- Configuración de DAP
			local dap = require("dap")
			local dapui = require("dapui")
			local mason_dap = require("mason-nvim-dap")

			-- Configuración de dap-ui (interfaz gráfica)
			dapui.setup()

			-- Configuración de nvim-dap-virtual-text (texto virtual en el código durante la depuración)
			require("nvim-dap-virtual-text").setup({}) -- Solucionar advertencia, se pasa un objeto vacío como argumento

			-- Integración con mason-nvim-dap para instalar automáticamente adaptadores
			mason_dap.setup({
				-- Instalación automática de adaptadores
				automatic_installation = true,
				-- Asegúrate de que estos adaptadores estén instalados
				ensure_installed = { "js-debug-adapter", "node2" },
			})

			-- Abrir/cerrar UI cuando se inicie/termine la depuración
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Definir signos visuales para breakpoints
			for name, sign in pairs(require("lazyvim.config").icons.dap) do
				local hl = sign[2] or "DiagnosticInfo"
				vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = hl, linehl = sign[3], numhl = sign[3] })
			end

			-- Leer configuraciones de depuración desde launch.json de VSCode
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			-- Esta línea fue comentada para evitar la advertencia de campo duplicado
			-- vscode.json_decode = function(str)
			--   return vim.json.decode(json.json_strip_comments(str))
			-- end

			if vim.fn.filereadable(".vscode/launch.json") then
				vscode.load_launchjs()
			end

			-- Mapear teclas de depuración
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Continue" })
			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>do", function()
				dap.step_over()
			end, { desc = "Step Over" })
			vim.keymap.set("n", "<leader>dO", function()
				dap.step_out()
			end, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.toggle()
			end, { desc = "Toggle REPL" })
			vim.keymap.set("n", "<leader>ds", function()
				dap.session()
			end, { desc = "Session" })
			vim.keymap.set("n", "<leader>dt", function()
				dap.terminate()
			end, { desc = "Terminate" })
			vim.keymap.set("n", "<leader>dw", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Widgets" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "Toggle DAP UI" })
		end,
	},
}
