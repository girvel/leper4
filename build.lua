#!/usr/bin/env luajit
require("lib.string")


----------------------------------------------------------------------------------------------------
-- [SECTION] Tools
----------------------------------------------------------------------------------------------------

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

--- @param command string
--- @param ... any
local cmd = function(command, ...)
  command = command:format(...)

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
local cmd_read = function(command, ...)
  local f = assert(io.popen("zsh -c '" .. command:format(...) .. "'"))
  local result = f:read("*a")
  f:close()

  if result:sub(-1, -1) == "\n" then
    result = result:sub(1, -2)
  end
  return result
end

--- @param path string
--- @return string
local read_file = function(path)
  local f = assert(io.open(path, "r"))
  local result = f:read("*a"):gsub("\n", " ")
  f:close()
  return result
end

----------------------------------------------------------------------------------------------------
-- [SECTION] Main
----------------------------------------------------------------------------------------------------

cmd("mkdir -p .build")
cmd("rm -rf .build/*")

cmd("make -C LuaJIT -j$(nproc)")
cmd("make -C LuaJIT install DESTDIR=$PWD/.build PREFIX=/usr")

local dirs = "bin,lib64,lib/x86_64-linux-gnu,proc,sys,os,usr/share,usr/lib"
for _, folder in ipairs(dirs:split(",")) do
  cmd("mkdir -p .build/initramfs/%s", folder)
end

cmd("cc -static -o .build/initramfs/init init.c")
cmd("cp .build/usr/bin/luajit-* .build/initramfs/bin/luajit")
cmd("cp -r .build/usr/share/luajit-* .build/initramfs/usr/share")
cmd("cp main.lua .build/initramfs/os/")
cmd("cp -r lib .build/initramfs/os/")
cmd("cp /lib64/ld-linux-x86-64.so.2 .build/initramfs/lib64/")
cmd("cp -t .build/initramfs/lib/x86_64-linux-gnu /lib/x86_64-linux-gnu/libm.so.6")
cmd("cp -t .build/initramfs/lib/x86_64-linux-gnu /lib/x86_64-linux-gnu/libgcc_s.so.1")
cmd("cp -t .build/initramfs/lib/x86_64-linux-gnu /lib/x86_64-linux-gnu/libc.so.6")
cmd("cd .build/initramfs; find . | cpio -o -H newc | gzip > ../initramfs.gz; cd ../..")
-- TODO figure out if cd persists
cmd [[
  qemu-system-x86_64 \
    -kernel vmlinuz-6.14.0-37-generic \
    -initrd .build/initramfs.gz \
    -nographic \
    -append "console=ttyS0 quiet panic=1" \
    -m 512M
    -no-reboot
]]
