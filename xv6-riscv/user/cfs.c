// a program that forks 3 procceses with low, medium and high cfs priority
// each child performs a simple loop of 1000000 iterations
// sleeping for 1 second every 100000 iterations
// each child then calls the get_cfs_stats system call

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"





int main(){

    char msg[32];
    //set process priority to low
    set_cfs_priority(0);  
    int pid1 = fork();
    if(pid1 == 0){ 
        long long add_cfs_priority=0;
        long long add_rtime=0;
        long long add_stime=0;
        long long add_retime=0;
        int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
                sleep(1);
            }
        }
        sleep(10*getpid());
        get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
        printf("my cfs priority is %d\n", add_cfs_priority);
        printf("my runtime is %d\n", add_rtime);
        printf("my sleeptime is %d\n", add_stime);
        printf("my runnable time is %d\n", add_retime);


        

        exit(0,"cfs 1st child exited");
    }
   


    //set process priority to medium
    set_cfs_priority(1);
    int pid2 = fork();
    if(pid2 == 0){
        long long add_cfs_priority=0;
        long long add_rtime=0;
        long long add_stime=0;
        long long add_retime=0;
        int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
                sleep(1);
            }
        }
        sleep(30*getpid());
        get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
        printf("my cfs priority is %d\n", add_cfs_priority);
        printf("my runtime is %d\n", add_rtime);
        printf("my sleeptime is %d\n", add_stime);
        printf("my runnable time is %d\n", add_retime);

        exit(0,"cfs 2nd child exited");
    }
    

    //set process priority to high
    set_cfs_priority(2);
    int pid3 = fork();
    if(pid3 == 0){    
    long long add_cfs_priority=0;
    long long add_rtime=0;
    long long add_stime=0;
    long long add_retime=0;
    int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
                //sleep(1);
                printf("%s\n", "yalla macabi");
            }
        }
    sleep(10*getpid());
    get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
    printf("my cfs priority is %d\n", add_cfs_priority);
    printf("my runtime is %d\n", add_rtime);
    printf("my sleeptime is %d\n", add_stime);
    printf("my runnable time is %d\n", add_retime);

        exit(0,"cfs 3rd child exited");
    }
   
   
    // wait for the 3 children to finish
     //wait for the first child
    wait(0,msg);
    printf("%s\n",msg);
     //wait for the second child
    wait(0,msg);
    printf("%s\n",msg);
    
   
    // //wait for the third child
    wait(0,msg);
    printf("%s\n",msg);
      


    exit(0,"cfs finished");
    
    //get my pid


   /*******************************************************/
    // long long add1=0;
    // long long add2=0;
    // long long add3=0;
    // long long add4=0;
    // int pid = getpid();
    // int i;
    // for(i = 0; i < 1000000; i++){
    //     printf("%d",4);
    //     if(i % 100000 == 0){
    //         sleep(1);
    //     }
    // }
    // get_cfs_stats(pid ,&add1 ,&add2, &add3, &add4 );    
    
    // printf("my cfs priority is %d\n", add1);
    // printf("my runtime is %d\n", add2);
    // printf("my sleeptime is %d\n", add3);
    // printf("my runnable time is %d\n", add4);
    // exit(0,"cfs finished");
    /**************************************************************/
}