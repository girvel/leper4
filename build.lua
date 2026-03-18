#!/usr/bin/env luajit
local cmd = require("tech.cmd")
require("tech.string")


cmd("mkdir -p .build")
cmd("rm -rf .build/*")
cmd("cd initramfs; find . | cpio -o -H newc | gzip > ../.build/initramfs.gz")
cmd [[
  qemu-system-x86_64 \
    -kernel vmlinuz \
    -initrd .build/initramfs.gz \
    -nographic \
    -append "console=ttyS0 quiet panic=1" \
    -m 512M \
    -no-reboot
]]
