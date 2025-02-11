local builtin = "require('telescope.builtin')"
if NewfieVim:get_plugin_info("base16_nvim").enabled then
	local update_highlights = function(colors)
		vim.api.nvim_set_hl(0, "button_label", { fg = colors.base0D, bg = nil })
		vim.api.nvim_set_hl(0, "shortcut", { fg = colors.base0E, bg = nil })
	end
	vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
		callback = function()
			update_highlights(require("base16-colorscheme").colors)
		end,
	})
end

return {
	"goolord/alpha-nvim",
	dependencies = {
		"echasnovski/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	opts = function()
		require("alpha.term")
		local alpha_button = function(shortcut, label, action)
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
		local buttons = { alpha_button("n", " " .. " New file", "<cmd> ene <BAR> startinsert <cr>") }
		if NewfieVim:get_plugin_info("telescope").enabled then
			table.insert(buttons, alpha_button("f", " " .. " Find file", builtin .. "find_files() <cr>"))
			table.insert(buttons, alpha_button("r", " " .. " Recent files", builtin .. "oldfiles() <cr>"))
			table.insert(buttons, alpha_button("g", " " .. " Find text", builtin .. "live_grep() <cr>"))
			table.insert(
				buttons,
				alpha_button(
					"z",
					" " .. " Open Directories",
					"<cmd> lua require('telescope').extensions.zoxide.list() <cr>"
				)
			)
		end
		table.insert(buttons, alpha_button("p", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"))
		table.insert(buttons, alpha_button("q", " " .. " Quit", "<cmd> qa <cr>"))
		local term_height = 10
		local term = nil
		local term_padding = nil
		local ret = os.execute("command -v neo &>/dev/null")
		if ret == 0 then
			term = {
				type = "terminal",
				command = "neo --fps=60 --speed=5 -D -m 'NEO VIM' -d 0.5 -l 1,1 --colormode 16 -c red",
				width = 50,
				height = term_height,
				opts = {
					redraw = true,
					window_config = {},
				},
			}
			term_padding = { type = "padding", val = 3 }
		end
		local config = {
			layout = {
				term_padding,
				term,
				{ type = "padding", val = 3 },
				{
					type = "group",
					val = buttons,
					opts = { spacing = 1 },
				},
			},
		}
		return config
	end,
	config = function(_, config)
		require("alpha").setup(config)
		require("which-key").add({ "<leader>a", ":Alpha<CR>", icon = "󰮫", desc = "Dashboard" })
	end,
}
