local M = {}

---Start selecting windows. See `:help snipewin#select()`
---@param callback function|nil #optional function that called after confirm selecting.
---@return any|nil #a result of `callback` if it called, otherwise return nil.
function M.select(callback)
  local fn = vim.fn["snipewin#select"]
  local ret = callback and fn(callback) or fn()
  if ret == vim.NIL then
    return nil
  end
  return ret
end

---@type table<string, fun(winid: integer): any>
M.callback = setmetatable({}, {
  __index = function(_, name)
    if name == "default" then
      return function(winid)
        return vim.api.nvim_eval(
          ("g:snipewin#callback#default->call([%d])"):format(winid)
        )
      end
    end
    return vim.fn["snipewin#callback#" .. name]
  end,
})

---@type table<string, function>
M.filter = setmetatable({}, {
  __index = function(_, name)
    return function(arg)
      if type(arg) == "number" then
        local ret = vim.fn["snipewin#filter#" .. name](arg)
        return ret == 1 or ret == true
      end
      return function(winid)
        local ret = vim.api.nvim_eval(
          ("snipewin#filter#%s(%s)->call([%d])"):format(
            name,
            vim.fn.string(arg),
            winid
          )
        )
        return ret == 1 or ret == true
      end
    end
  end,
})

return M
