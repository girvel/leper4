#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    system("/bin/busybox --install -s /bin");
    printf("Leper OS, bitches!\n");
    execl("/bin/zsh", "/bin/zsh", NULL);
    return 0;
}
