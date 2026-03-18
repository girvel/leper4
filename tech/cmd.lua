local log = require("tech.log")


local cmd_mt = {}
--- @overload fun(command: string, ...: any)
local cmd = setmetatable({}, cmd_mt)

--- @param command string
--- @param ... any
cmd_mt.__call = function(_, command, ...)
  if select("#", ...) then
    command = command:format(...)
  end

  log.cmd(command)
  local code = os.execute(command)

  if code ~= 0 then
    log.error("Exited with code %s", code)
    os.exit(1)
  end
end

--- @param command string
--- @param ... any
--- @return string
cmd.read = function(command, ...)
  local f = assert(io.popen("zsh -c '" .. command:format(...) .. "'"))
  local result = f:read("*a")
  f:close()

  if result:sub(-1, -1) == "\n" then
    result = result:sub(1, -2)
  end
  return result
end

return cmd
