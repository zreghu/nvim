local M = {}
local sessions = {}
local api = vim.api

local function comparison_open(comparison)
  return api.nvim_win_is_valid(comparison.win)
    and api.nvim_win_get_buf(comparison.win) == comparison.buf
end

local function restore_source(session)
  if api.nvim_win_is_valid(session.win) and api.nvim_win_get_buf(session.win) == session.buf then
    api.nvim_win_call(session.win, function()
      vim.cmd("diffoff")
    end)
    api.nvim_set_current_win(session.win)
  end
end

function M.toggle_diff()
  local tab = api.nvim_get_current_tabpage()
  local session = sessions[tab]
  if session and session.opening then
    return
  end
  if session then
    local closed = false
    for _, comparison in ipairs(session.comparisons) do
      if comparison_open(comparison) then
        -- Refuse to discard any unsaved edits made to the index buffer.
        local ok, err = pcall(api.nvim_win_close, comparison.win, false)
        if not ok then
          vim.notify(tostring(err), vim.log.levels.WARN)
          return
        end
        closed = true
      end
    end
    restore_source(session)
    sessions[tab] = nil
    if closed then
      return
    end
  end

  session = {
    win = api.nvim_get_current_win(),
    buf = api.nvim_get_current_buf(),
    comparisons = {},
    opening = true,
  }
  sessions[tab] = session
  local previous_windows = {}
  for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
    previous_windows[win] = true
  end
  require("gitsigns").diffthis(nil, { unified = false }, function(err)
    session.opening = false
    if err or not api.nvim_tabpage_is_valid(tab) then
      sessions[tab] = nil
      if err then
        vim.notify(tostring(err), vim.log.levels.ERROR)
      end
      return
    end
    for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
      local buf = api.nvim_win_get_buf(win)
      if not previous_windows[win] and api.nvim_buf_get_name(buf):match("^gitsigns://") then
        table.insert(session.comparisons, { win = win, buf = buf })
        -- Make the same toggle available from the comparison pane immediately.
        vim.keymap.set("n", "<leader>ghd", M.toggle_diff, {
          buffer = buf,
          desc = "Toggle Git diff",
        })
      end
    end
  end)
end

return M
