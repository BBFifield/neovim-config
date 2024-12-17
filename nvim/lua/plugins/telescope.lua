local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-telescope/telescope-fzy-native.nvim",
		"jvgrootveld/telescope-zoxide",
	},
	event = "VimEnter",
	opts = {
		defaults = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-h>"] = actions.which_key,
				},
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
			},
			colorscheme = {
				enable_preview = true,
				ignore_builtins = false,
			},
		},
		extensions = {
			zoxide = {
				prompt_title = "[ Frequent Directories ]",
				mappings = {
					default = {
						after_action = function(selection)
							print("Update to (" .. selection.z_score .. ") " .. selection.path)
						end,
					},
					["<C-s>"] = {
						before_action = function(selection)
							print("before C-s")
						end,
						action = function(selection)
							vim.cmd.edit(selection.path)
						end,
					},
				},
			},
		},
	},
	config = function(_, opts)
		telescope.load_extension("fzy_native")
		telescope.load_extension("zoxide")
		local wk = require("which-key")
		wk.add({
			{ "<leader>ff", builtin.find_files, desc = "Files" },
			{ "<leader>fr", builtin.oldfiles, desc = "Recent files" },
			{ "<leader>ft", builtin.filetypes, desc = "Filetypes" },

			{ "<leader>dz", telescope.extensions.zoxide.list, desc = "Zoxide list" },

			{ "<leader>fg", builtin.grep_string, desc = "Grep selection" },
			{ "<leader>fg", builtin.live_grep, desc = "Live grep" },

			{ "<leader>bl", builtin.buffers, desc = "Buffer list" },
			{ "<leader>bf", builtin.current_buffer_fuzzy_find, desc = "Search in Buf" },

			{ "<leader>gf", builtin.git_files, desc = "Git files" },

			{ "<leader>cc", builtin.commands, desc = "Plugin/User commands" },
			{ "<leader>cr", builtin.command_history, desc = "Recent commands" },
			{ "<leader>ca", builtin.autocommands, desc = "Autocmds" },

			{ "<leader>hm", builtin.man_pages, desc = "Man pages" },
			{ "<leader>ht", builtin.help_tags, desc = "Help tags" },

			{ "<leader>uc", builtin.colorscheme, desc = "Color schemes" },
			{ "<leader>uh", builtin.highlights, desc = "Available highlights" },

			{ "<leader>r", builtin.registers, desc = "Registers", icon = "󱍶" },
			{ "<leader>o", builtin.vim_options, desc = "Vim options", icon = "" },
			{ "<leader>q", builtin.quickfix, desc = "Quickfix list" },
			{ "<leader>m", builtin.marks, desc = "Marks" },

			{ "<leader>lr", builtin.lsp_references, desc = "LSP references" },
			{ "<leader>li", builtin.lsp_incoming_calls, desc = "LSP incoming calls" },
			{ "<leader>lo", builtin.lsp_outgoing_calls, desc = "LSP outgoing calls" },
			{ "<leader>ld", builtin.diagnostics, desc = "LSP diagnostics" },
		})
		-- bit of debugging
		local status, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
		if not status then
			print("Failed to load z_utils: " .. z_utils)
		else
			opts.extensions.zoxide.mappings["<C-q>"] = { action = z_utils.create_basic_command("split") }
			telescope.setup(opts) -- Re-setup telescope with the updated opts
		end
	end,
}
