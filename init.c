#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    const char hostname[] = "lepervm";
    sethostname(hostname, sizeof(hostname)/sizeof(*hostname));

    system("/bin/busybox --install -s /bin");
    printf("Leper OS, bitches!\n");

    {
        char *const argv[] = {"/bin/zsh", NULL};
        char *const envp[] = {
            "TERM=linux",
            "PROMPT=\n %B%F{red}%n%b%F{white}@%m %~ %# ",
            NULL
        };
        execve("/bin/zsh", argv, envp);
    }
    return 0;
}
