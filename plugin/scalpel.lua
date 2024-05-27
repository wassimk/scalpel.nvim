--
-- scalpel.lua
--

local function is_selection_one_line(start_pos, end_pos)
  return start_pos[1] == end_pos[1]
end

local function get_visual_range()
  -- Exit visual mode to set the marks for visual range
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', false, true, true), 'nx', false)

  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')

  return start_pos, end_pos
end

local function get_substitution_from_normal_mode()
  return vim.fn.expand('<cword>')
end

local function get_substitution_from_visual_selection()
  local start_pos, end_pos = get_visual_range()

  if not is_selection_one_line(start_pos, end_pos) then
    vim.notify('Visual range spans more than one line, cannot substitute', vim.log.levels.WARN)
    return nil
  end

  local line = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
  return line:sub(start_pos[2] + 1, end_pos[2] + 1)
end

local mode_to_substitution_function = {
  n = get_substitution_from_normal_mode,
  v = get_substitution_from_visual_selection,
}

local function get_substitution_word()
  local mode = vim.fn.mode()
  local substitution_function = mode_to_substitution_function[mode]
  return substitution_function and substitution_function()
end

local function is_blank(s)
  return s == nil or s:match('^%s*$') ~= nil
end

local function substitute_current_word()
  local word = get_substitution_word()

  if is_blank(word) then
    vim.notify('Word is blank, cannot substitute', vim.log.levels.INFO)
    return
  end

  local pattern = ':%s/\\v(' .. word .. ')//gc'
  local cursor_move = vim.api.nvim_replace_termcodes('<Left><Left><Left>', true, false, true)
  vim.api.nvim_feedkeys(pattern .. cursor_move, 'n', true)
end

vim.keymap.set({ 'n', 'v' }, '<leader>e', substitute_current_word, { desc = 'Substitute current word in file' })
