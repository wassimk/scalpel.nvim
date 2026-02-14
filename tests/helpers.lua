local M = {}

-- Tracked values
M.feedkeys_calls = {}
M.notifications = {}
M.last_setreg_name = nil
M.last_setreg_value = nil

-- Original functions
local originals = {}

function M.setup_mocks()
  M.feedkeys_calls = {}
  M.notifications = {}
  M.last_setreg_name = nil
  M.last_setreg_value = nil

  originals.mode = vim.fn.mode
  originals.expand = vim.fn.expand
  originals.setreg = vim.fn.setreg
  originals.feedkeys = vim.api.nvim_feedkeys
  originals.replace_termcodes = vim.api.nvim_replace_termcodes
  originals.buf_get_mark = vim.api.nvim_buf_get_mark
  originals.buf_get_lines = vim.api.nvim_buf_get_lines
  originals.notify = vim.notify

  -- Default mock: normal mode
  vim.fn.mode = function()
    return 'n'
  end

  vim.fn.expand = function()
    return 'word'
  end

  vim.fn.setreg = function(name, value)
    M.last_setreg_name = name
    M.last_setreg_value = value
  end

  vim.api.nvim_feedkeys = function(keys, mode, escape_ks)
    table.insert(M.feedkeys_calls, { keys = keys, mode = mode, escape_ks = escape_ks })
  end

  vim.api.nvim_replace_termcodes = function(str, from_part, do_lt, special)
    return str
  end

  vim.api.nvim_buf_get_mark = function(buf, mark)
    return { 1, 0 }
  end

  vim.api.nvim_buf_get_lines = function(buf, start_line, end_line, strict)
    return { 'some text here' }
  end

  vim.notify = function(msg, level)
    table.insert(M.notifications, { msg = msg, level = level })
  end
end

function M.set_mode(mode)
  vim.fn.mode = function()
    return mode
  end
end

function M.set_expand(result)
  vim.fn.expand = function()
    return result
  end
end

function M.set_visual_marks(start_pos, end_pos)
  vim.api.nvim_buf_get_mark = function(buf, mark)
    if mark == '<' then
      return start_pos
    elseif mark == '>' then
      return end_pos
    end
  end
end

function M.set_buffer_lines(lines)
  vim.api.nvim_buf_get_lines = function(buf, start_line, end_line, strict)
    return lines
  end
end

function M.teardown_mocks()
  vim.fn.mode = originals.mode
  vim.fn.expand = originals.expand
  vim.fn.setreg = originals.setreg
  vim.api.nvim_feedkeys = originals.feedkeys
  vim.api.nvim_replace_termcodes = originals.replace_termcodes
  vim.api.nvim_buf_get_mark = originals.buf_get_mark
  vim.api.nvim_buf_get_lines = originals.buf_get_lines
  vim.notify = originals.notify
end

return M
