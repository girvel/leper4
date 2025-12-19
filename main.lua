local ffi = require("ffi")

ffi.cdef[[
    unsigned int sleep(unsigned int seconds);
    int getpid(void);
]]

print("\n========================================")
print("   Welcome to LeperOS (LuaJIT Powered)   ")
print("========================================")

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
    print("System is alive. Tick: " .. counter)
    counter = counter + 1
    -- Sleep for 1 second so we don't burn 100% CPU
    ffi.C.sleep(1)
end
