local ffi = require("ffi")
require("lib.string")

ffi.cdef[[
    unsigned int sleep(unsigned int seconds);
    int getpid(void);
]]

print("\nLeper OS 4 (LuaJIT)")

-- Read some kernel info
local f = io.open("/proc/version", "r")
if f then
    print("Kernel: " .. f:read("*a"))
    f:close()
end

print("Process ID is: " .. ffi.C.getpid())
print("Entering main loop...\n")

local commands = {}

commands.echo = function(_, ...)
  print(...)
end

while true do
  io.write("\ngirvel@lepervm1 # ")
  local cmd_args = io.read("*l"):strip():split("%s+")
  local cmd = commands[cmd_args[1]]
  if cmd then
    cmd(unpack(cmd_args))
  else
    print("Unknown command", cmd_args[1])
  end
end
