/* C playground — treesitter highlighting only (no clangd LSP configured).
   Install clangd via `:Mason` for full LSP features. */
#include <stdio.h>

typedef struct {
    const char *name;
    int age;
} User;

void greet(User u) {
    printf("Hello, %s! You are %d.\n", u.name, u.age);
}

int main(void) {
    User u = {.name = "Luke", .age = 30};
    greet(u);
    return 0;
}
