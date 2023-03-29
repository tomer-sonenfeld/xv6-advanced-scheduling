#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"
/*#include <stdio.h>
#include <stdlib.h>
#include "user/user.h"*/



//int memsize();

int main(int argc , char* argv[]){
    printf("%d\n" , memsize());    
    char* p = (char*)malloc(20000);
    printf("%d\n", memsize());
    free(p);
    printf("%d\n", memsize());
    return 0;
    
}