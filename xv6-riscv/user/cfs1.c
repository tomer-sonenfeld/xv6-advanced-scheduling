

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"



int main(int argc, char const *argv[]){
    long long add_cfs_priority=0;
    long long add_rtime=0;
    long long add_stime=0;
    long long add_retime=0;

    set_cfs_priority(2);
    int pid=fork();
     printf("%d\n--", 1);
    if(pid==0){
        printf("%d\n--", 2);
        pid=fork();
        if(pid!=0){
            printf("%d\n--", 3);
           set_cfs_priority(1);  
        }
    }
    else{
        set_cfs_priority(0);  
    }  
    printf("%d\n--", 4);
    int i;
    for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
                printf("%d\n--", 6);
                sleep(1);
            }
    }
    printf("%d\n--", 5);
   get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
   wait(0,0);
        printf("my cfs priority is %d\n", add_cfs_priority);
        printf("my runtime is %d\n", add_rtime);
        printf("my sleeptime is %d\n", add_stime);
        printf("my runnable time is %d\n", add_retime);

    
    exit(0,"");


        


}
