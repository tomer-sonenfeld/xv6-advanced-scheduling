// a program that forks 3 procceses with low, medium and high cfs priority
// each child performs a simple loop of 1000000 iterations
// sleeping for 1 second every 100000 iterations
// each child then calls the get_cfs_stats system call

#include "types.h"
#include "stat.h"
#include "user.h"

int main(){
    // //set process priority to low
    // set_cfs_priority(0);
    // int pid1 = fork();
    // if(pid1 == 0){
    //     int i;
    //     for(i = 0; i < 1000000; i++){
    //         if(i % 100000 == 0){
    //             sleep(1);
    //         }
    //     }
    //     get_cfs_stats();
    //     exit(0,"cfs 1st child exited");
    // }
    // //set process priority to medium
    // set_cfs_priority(1);
    // int pid2 = fork();
    // if(pid2 == 0){
    //     int i;
    //     for(i = 0; i < 1000000; i++){
    //         if(i % 100000 == 0){
    //             sleep(1);
    //         }
    //     }
    //     get_cfs_stats();
    //     exit(0,"cfs 2nd child exited");
    // }
    // //set process priority to high
    // set_cfs_priority(2);
    // int pid3 = fork();
    // if(pid3 == 0){
    //     int i;
    //     for(i = 0; i < 1000000; i++){
    //         if(i % 100000 == 0){
    //             sleep(1);
    //         }
    //     }
    //     get_cfs_stats();
    //     exit(0,"cfs 3rd child exited");
    // }

    // char msg[32];
    // // wait for the 3 children to finish
    // //wait for the first child
    // wait(0,msg);
    // printf(1,"%s\n",msg);
    // //wait for the second child
    // wait(0,msg);
    // //wait for the third child
    // wait(0,msg);
    // exit(0,"cfs finished");

    print("my priority is %d\n",get_cfs_priority());
    exit(0,"cfs finished");
}