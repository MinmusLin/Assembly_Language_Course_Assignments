#include <stdio.h>

int main() {
    for (int i = 0; i < 26; i++) {
        printf("%c", 'a' + i);
        if ((i + 1) % 13 == 0) {
            printf("\n");
        }
    }

    return 0;
}
