--
-- scalpel.lua
--

local function selection_is_one_line(start_pos, end_pos)
  return start_pos[1] == end_pos[1]
end

local function selection()
  -- Exit visual mode to set the marks for visual range
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', false, true, true), 'nx', false)

  local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  local end_pos = vim.api.nvim_buf_get_mark(0, '>')

  return start_pos, end_pos
end

local function get_normal_substitution()
  local word = vim.fn.expand('<cword>')
  return word
end

local function get_visual_substitution()
  local start_pos, end_pos = selection()

  if selection_is_one_line(start_pos, end_pos) then
    local line = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, start_pos[1], false)[1]
    local word = line:sub(start_pos[2] + 1, end_pos[2] + 1)
    return word
  else
    vim.notify('Visual range spans more than one line, cannot substitute', vim.log.levels.WARN)
    return nil
  end
end

local get_substitution_word = function()
  local word
  if vim.fn.mode() == 'n' then
    word = get_normal_substitution()
  elseif vim.fn.mode() == 'v' then
    word = get_visual_substitution()
  end

  return word
end

local function is_blank(s)
  if s == nil then
    return true
  end

  return s:match('^%s*$') ~= nil
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

vim.keymap.set({ 'n', 'v' }, '<leader>e', substitute_current_word, { desc = 'Substite current word in file' })
