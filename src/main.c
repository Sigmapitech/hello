#include <stdlib.h>
#include <unistd.h>

#include "sstr_helper.h"

int main(void)
{
    char hello[] = "Hello";
    ssize_t written = write(STDOUT_FILENO, SSTR_UNPACK(hello));

    return (size_t)written == SSTR_LEN(hello)
        ? EXIT_SUCCESS : EXIT_FAILURE;
}
