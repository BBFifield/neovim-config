local create_keymaps = function(maps)
	for _, v in ipairs(maps) do
		if type(v[1]) == "table" then
			-- m is either normal or visual mode
			for _, m in ipairs(v[1]) do
				vim.keymap.set(m, v[2], v[3], v[4])
			end
		end
		vim.keymap.set(v[1], v[2], v[3], v[4])
	end
end

-- Creates yank and paste keymaps for every char in both normal and visual modes
local create_register_keymaps = function()
	local opts = { silent = true }
	for i = string.byte("a"), string.byte("z") do
		local letterReg = string.char(i)
		local prefix = '"' .. letterReg
		vim.keymap.set("n", prefix .. "y", prefix .. "y", opts)
		vim.keymap.set("v", prefix .. "y", prefix .. "ygv", opts) -- "gv" means return to visual modeafter executing the command
		vim.keymap.set("n", prefix .. "Y", prefix .. "Y", opts)
		create_keymaps({ { { "n", "v" }, prefix .. "p", prefix .. "p", opts } })
	end
	vim.keymap.set("n", "y", '"+y', opts)
	vim.keymap.set("v", "y", '"+ygv', { silent = true })
	vim.keymap.set("n", "Y", '"*y', { silent = true })
	vim.keymap.set("v", "Y", '"*ygv', { silent = true })
	create_keymaps({ { { "n", "v" }, "p", '"+p', opts } })
	create_keymaps({ { { "n", "v" }, "P", '"*P', opts } })
end

local keymaps = {
	{ "n", "n", "nzz", { desc = "Center screen after next search match", silent = true } },
	{ "n", "<S-n>", "<S-n>zz", { desc = "Center screen after previous search match", silent = true } },
	{ "n", "<M-j>", ":m .+1<CR>", { desc = "Swap line down", silent = true } },
	{ "v", "<M-j>", ":m '>+1<CR>gv", { desc = "Swap lines down", silent = true } },
	{ "n", "<M-k>", ":m .-2<CR>", { desc = "Swap line up", silent = true } },
	{ "v", "<M-k>", ":m '<-2<CR>gv", { desc = "Swap lines up", silent = true } },
	{ "n", "<M-h>", "<<", { desc = "Move line left", silent = true } },
	{ "v", "<M-h>", "<gv", { desc = "Move lines left", silent = true } },
	{ "n", "<M-l>", ">>", { desc = "Move line right", silent = true } },
	{ "v", "<M-l>", ">gv", { desc = "Move lines right", silent = true } },
	{ "n", "<leader>bn", ":bn<CR>", { desc = "Next buffer", silent = true } },
	{ "n", "<leader>bb", ":bp<CR>", { desc = "Prev buffer", silent = true } },
	{ "n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer", silent = true } },
	{
		"i",
		"<M-4>",
		function()
			vim.cmd("normal $")
			vim.cmd("startinsert!") -- ! ensures a raw and unaltered switch back to insert mode, which likely preserves the intended cursor position more accurately
		end,
		{ silent = true },
	}, --Move to end of line in insert mode
	{
		"i",
		"<M-5>",
		function()
			vim.cmd("normal %")
			vim.cmd("startinsert!")
		end,
		{ silent = true },
	}, --Jump to matched pair
}

create_keymaps(keymaps)
create_register_keymaps()

-- Map registers to wl-clipboard commands
vim.opt.clipboard:append("unnamed")
if vim.fn.executable("wl-copy") == 1 then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy --foreground --type text/plain",
			["*"] = "wl-copy --foreground --primary --type text/plain",
		},
		paste = {
			["+"] = function()
				return vim.fn.systemlist("wl-paste --no-newline")
			end,
			["*"] = function()
				return vim.fn.systemlist("wl-paste --primary --no-newline")
			end,
		},
		cache_enabled = true,
	}
end
