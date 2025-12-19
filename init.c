#include <stdio.h>
#include <unistd.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>

int main() {
    // Can we do that in luajit?
    mkdir("/proc", 0755);
    mkdir("/sys", 0755);
    mount("proc", "/proc", "proc", 0, NULL);
    mount("sysfs", "/sys", "sysfs", 0, NULL);

    printf("\n[INIT] Kernel handed control to C wrapper.\n");

    char *argv[] = { "luajit", "/os/main.lua", NULL };

    char *envp[] = { 
        "PATH=/bin", 
        "LUA_PATH=/os/?.lua;/usr/share/lua/5.1/?.lua", 
        "LUA_CPATH=/usr/lib/lua/5.1/?.so",
        NULL 
    };

    printf("[INIT] Launching LuaJIT...\n");

    if (execve("/bin/luajit", argv, envp) == -1) {
        perror("[INIT] CRITICAL ERROR: Failed to start LuaJIT");
        return 1;
    }

    return 0;
}
