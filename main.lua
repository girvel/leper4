local ffi = require("ffi")

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

print("My Process ID is: " .. ffi.C.getpid())
print("Entering main loop...\n")

local counter = 0
while true do
  io.write(".")
  io.flush()
  counter = counter + 1
  ffi.C.sleep(1)
end
