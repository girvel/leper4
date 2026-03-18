--- @alias log_f fun(fmt: string, ...: any)
--- @class log
--- @field cmd log_f
--- @field info log_f
--- @field error log_f

--- @type log
local log = setmetatable({}, {
  __index = function(self, level)
    return function(fmt, ...)
      print("[" .. level:upper() .. "]", fmt:format(...))
    end
  end
})

return log
