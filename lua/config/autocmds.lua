local function qf_navigate(direction)
  local qf_win = vim.api.nvim_get_current_win()
  local cur_line = vim.api.nvim_win_get_cursor(qf_win)[1]
  local max_line = vim.api.nvim_buf_line_count(0)
  local target_line = cur_line + direction

  if target_line < 1 or target_line > max_line then
    return
  end

  -- Move cursor within quickfix window
  vim.api.nvim_win_set_cursor(qf_win, { target_line, 0 })

  -- Fetch quickfix item details
  local qf_items = vim.fn.getqflist()
  local item = qf_items[target_line]
  if not item or item.bufnr == 0 then
    return
  end

  -- Find the main (non-quickfix) editor window in the current tab
  local main_win = nil
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "qf" then
      main_win = win
      break
    end
  end

  if not main_win then
    return
  end

  -- Update main window buffer and position without stealing window focus
  if not vim.api.nvim_buf_is_loaded(item.bufnr) then
    vim.fn.bufload(item.bufnr)
  end
  vim.api.nvim_win_set_buf(main_win, item.bufnr)
  
  local lnum = math.max(1, item.lnum)
  local col = math.max(0, item.col - 1)
  pcall(vim.api.nvim_win_set_cursor, main_win, { lnum, col })
end

-- Attach keymaps whenever a Quickfix window opens
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    -- Navigate quickfix items with Down/j and Up/k without leaving quickfix
    vim.keymap.set("n", "<Down>", function() qf_navigate(1) end, opts)
    vim.keymap.set("n", "j", function() qf_navigate(1) end, opts)

    vim.keymap.set("n", "<Up>", function() qf_navigate(-1) end, opts)
    vim.keymap.set("n", "k", function() qf_navigate(-1) end, opts)

    -- Close quickfix window on Esc
    vim.keymap.set("n", "<Esc>", "<cmd>cclose<CR>", opts)

    -- Enter opens the match and focuses the main window
    vim.keymap.set("n", "<CR>", "<CR><cmd>cclose<CR>", opts)
  end,
})
