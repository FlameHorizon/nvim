-- 1. Configure native completion behavior
vim.opt.completeopt = { "fuzzy", "menuone", "noselect" }

-- Define number of items in the pop up menu
vim.opt.pumheight = 7

-- 'complete' sources:
-- '.' = current buffer, 'w' = other windows, 'b' = loaded buffers, 'o' = LSP (omnifunc)
vim.opt.complete = ".,w,b,o"

-- Enable native automatic completion popup as you type (Neovim 0.11+)
vim.opt.autocomplete = false

-- 2. Enable LSP completion whenever an LSP attaches to a file
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--vim.g.mapleader = ' '
--vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
--  See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Use ripgrep for search
vim.opt.grepprg =
"rg --vimgrep --smart-case --hidden --no-ignore " ..
"--glob !node_modules " ..
"--glob !.git " ..
"--glob !dist " ..
"--glob !build"

-- Define output format of the search result
vim.opt.grepformat = "%f:%l:%c:%m"

-- Add recursive search with 'find'
vim.opt.path:append("**")

-- Ignore large folder when searching for files.
vim.opt.wildignore:append({
	"*/node_modules/*",
	"*/dist/*",
	"*/build/*",
	"*/target/*",
	"*/.git/*",
})

-- Better menu completion: popup menu + fuzzy matching
vim.opt.wildmenu = true
vim.opt.wildoptions = { "pum", "fuzzy" }
vim.opt.wildmode = "noselect:full"

-- Live-narrowing list: open the popup as you type for file/buffer commands
vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = ":",
	callback = function()
		local cmd = vim.fn.getcmdline():match("^%s*(%a+)!?%s")
		local picker_cmds = { find = 1, fin = 1, buffer = 1, buf = 1, b = 1, edit = 1, e = 1 }
		if cmd and picker_cmds[cmd] then
			vim.fn.wildtrigger()
		end
	end,
})

-- Fast fuzzy :find backed by ripgrep
local file_cache
function _G.RgFindFiles(cmdarg, _)
	if not file_cache then
		file_cache = vim.fn.systemlist("rg --files --hidden --glob !.git --glob !node_modules")
	end
	return cmdarg == "" and file_cache or vim.fn.matchfuzzy(file_cache, cmdarg)
end
vim.o.findfunc = "v:lua.RgFindFiles"

-- Rebuild the file list when you change directory or save a file
vim.api.nvim_create_autocmd({ "DirChanged", "BufWritePost" }, {
	callback = function() file_cache = nil end,
})

-- Leader must be set before the mappings below (options.lua loads before lazy.lua)
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ff", ":find ")
vim.keymap.set("n", "<leader>fb", ":buffer ")
vim.keymap.set("n", "<leader>fr", ":browse oldfiles<CR>")

-- Search text across files with ripgrep, results land in the quickfix list
local function grep(pattern)
	if not pattern or pattern == "" then return end
	vim.cmd("silent grep! " .. vim.fn.shellescape(pattern))
	if #vim.fn.getqflist() == 0 then
		vim.notify("No matches for: " .. pattern)
	else
		vim.cmd("copen")
	end
end
vim.keymap.set("n", "<leader>fg", function()
	vim.ui.input({ prompt = "Grep: " }, grep)
end, { desc = "Grep in files" })
vim.keymap.set("n", "<leader>fw", function()
	grep(vim.fn.expand("<cword>"))
end, { desc = "Grep word under cursor" })
vim.keymap.set("x", "<leader>fg", function()
	vim.cmd('noautocmd normal! "zy')
	grep(vim.fn.getreg("z"))
end, { desc = "Grep selection" })

-- Others
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
