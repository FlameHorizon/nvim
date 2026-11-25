-- Use Tab and Shift-Tab to navigate native completion popup
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

-- Confirm item with Enter if popup is visible
vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true })

-- Calling search function
vim.keymap.set("n", "<leader>g", function()
    vim.cmd("silent grep! " .. vim.fn.input("Grep > "))
    vim.cmd("copen")
end)

-- Jump backward with Alt+h (or Alt+Left)
vim.keymap.set("n", "<M-h>", "<C-o>", { noremap = true, silent = true, desc = "Jump backward" })
vim.keymap.set("n", "<M-Left>", "<C-o>", { noremap = true, silent = true, desc = "Jump backward" })

-- Jump forward with Alt+l (or Alt+Right)
vim.keymap.set("n", "<M-l>", "<C-i>", { noremap = true, silent = true, desc = "Jump forward" })
vim.keymap.set("n", "<M-Right>", "<C-i>", { noremap = true, silent = true, desc = "Jump forward" })
