local ffi = require("ffi")
require("lib.string")

ffi.cdef[[
    unsigned int sleep(unsigned int seconds);
    int getpid(void);

    typedef struct DIR DIR;
    DIR *opendir(const char *name);

    typedef struct {
      unsigned long d_ino;
      unsigned long d_off;
      unsigned short d_reclend;
      unsigned char d_type;
      char d_name[256];
    } dirent;
    dirent *readdir(DIR *dirp);

    int closedir(DIR *dirp);
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

commands.ls = function(_, path)
  path = path or "."
  local stream = ffi.C.opendir(path)
  local names = {}

  while true do
    local entry = ffi.C.readdir(stream);
    if entry == nil then break end
    local name = ffi.string(entry.d_name)
    if entry.d_type == 4 then
      name = name .. "/"
    end
    table.insert(names, name)
  end

  table.sort(names)
  for _, name in ipairs(names) do
    print(name)
  end

  ffi.C.closedir(stream);
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
