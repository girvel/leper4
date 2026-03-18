#!/usr/bin/env luajit
local cmd = require("tech.cmd")
require("tech.string")


cmd("mkdir -p .build")
cmd("rm -rf .build/*")
cmd("cp -r initramfs .build/")
cmd("cc init.c -o .build/initramfs/init")
cmd("cd .build/initramfs; find . | cpio -o -H newc | gzip > ../initramfs.gz")
cmd [[
  qemu-system-x86_64 \
    -kernel vmlinuz \
    -initrd .build/initramfs.gz \
    -m 512M \
    -no-reboot
]]
