-- Define a helper that returns a brand new terminal element.
local function new_terminal_element()
	return {
		type = "terminal",
		command = "neo --fps=60 --speed=5 -D -m 'NEO VIM' -d 0.5 -l 1,1 --colormode 16 -c red",
		width = 50,
		height = 10,
		opts = {
			redraw = true,
			window_config = {},
		},
	}
end

-- Define a function that builds your entire Alpha configuration fresh.
local function alpha_config()
	require("alpha.term") -- make sure alpha.term is loaded
	local builtin = "require('telescope.builtin')"

	local function alpha_button(shortcut, label, action)
		return {
			type = "button",
			val = label,
			on_press = function()
				local key = vim.api.nvim_replace_termcodes(action, true, false, true)
				vim.api.nvim_feedkeys(key, "normal", false)
			end,
			opts = {
				keymap = { "n", shortcut, action },
				position = "center",
				hl = "button_label",
				hl_shortcut = "shortcut",
				shortcut = shortcut,
				align_shortcut = "right",
				width = 50,
			},
		}
	end

	local buttons = {
		alpha_button("n", " New file", "<cmd> ene <BAR> startinsert <cr>"),
	}
	if NewfieVim:get_plugin_info("telescope").enabled then
		table.insert(buttons, alpha_button("f", " Find file", "<cmd> lua " .. builtin .. ".find_files() <cr>"))
		table.insert(buttons, alpha_button("r", " Recent files", "<cmd> lua " .. builtin .. ".oldfiles() <cr>"))
		table.insert(buttons, alpha_button("g", " Find text", "<cmd> lua " .. builtin .. ".live_grep() <cr>"))
		table.insert(
			buttons,
			alpha_button("z", " Open Directories", "<cmd> lua require('telescope').extensions.zoxide.list() <cr>")
		)
	end
	table.insert(buttons, alpha_button("p", "󰒲 Lazy", "<cmd> Lazy <cr>"))
	table.insert(buttons, alpha_button("q", " Quit", "<cmd> qa <cr>"))

	local term_padding = { type = "padding", val = 3 }
	local config = {
		layout = {
			term_padding,
			new_terminal_element(), -- Fresh terminal element is created here.
			{ type = "padding", val = 3 },
			{
				type = "group",
				val = buttons,
				opts = { spacing = 1 },
			},
		},
	}
	return config
end

return {
	"goolord/alpha-nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	-- Use the fresh configuration function for initial setup.
	opts = alpha_config,
	config = function(_, config)
		-- Set up alpha with the fresh configuration.
		require("alpha").setup(config)
		require("which-key").add({
			"<leader>a",
			":Alpha<CR>",
			icon = "󰮫",
			desc = "Dashboard",
		})

		-- Define a custom :Alpha command that:
		--  1. Deletes any existing buffers with filetype "alpha".
		--  2. Rebuilds the Alpha config completely using `alpha_config()`.
		--  3. Calls start() so you see the fresh dashboard (with its terminal element).
		vim.api.nvim_create_user_command("Alpha", function()
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_get_option(buf, "filetype") == "alpha" then
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
				end
			end
			local fresh_config = alpha_config()
			require("alpha").setup(fresh_config)
			-- Use vim.schedule to ensure the dashboard starts in the next event loop.
			vim.schedule(function()
				require("alpha").start()
			end)
		end, {})

		-- Patch the reposition function to skip repositioning work when the terminal's window id is invalid.
		vim.schedule(function()
			local status_ok, alpha_term = pcall(require, "alpha.term")
			if not status_ok then
				return
			end
			local orig_reposition = alpha_term.reposition
			alpha_term.reposition = function(self, ...)
				if not (self.win_id and vim.api.nvim_win_is_valid(self.win_id)) then
					return -- Skip repositioning for an invalid window.
				else
					return orig_reposition(self, ...)
				end
			end
		end)
	end,
}
