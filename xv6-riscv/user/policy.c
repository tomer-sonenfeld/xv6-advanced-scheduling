
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/syscall.h"
#include "kernel/memlayout.h"
#include "kernel/riscv.h"

int main(int argc, char *argv[]) {
    // Check that an argument was passed
    if (argc != 2) {
        printf("Usage: %s <0|1|2>\n", argv[0]);
        return -1;
    }

    // Parse the argument as an integer
    int value = atoi(argv[1]);

    // Check that the value is valid
    if (value < 0 || value > 2) {
        printf("Invalid argument: %s. Must be 0, 1, or 2\n", argv[1]);
        return -1;
    }

    // Update the global variable
    int sched_policy = value;

    // Print the updated value
    set_policy(sched_policy);
    printf("my_global_variable = %d\n",sched_policy);

    return 0;
}