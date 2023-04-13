
user/_cfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:





int main(){
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	0100                	addi	s0,sp,128

    char msg[32];
    //set process priority to low
    set_cfs_priority(0);  
  12:	4501                	li	a0,0
  14:	00000097          	auipc	ra,0x0
  18:	67e080e7          	jalr	1662(ra) # 692 <set_cfs_priority>
    int pid1 = fork();
  1c:	00000097          	auipc	ra,0x0
  20:	5be080e7          	jalr	1470(ra) # 5da <fork>
    if(pid1 == 0){ 
  24:	ed61                	bnez	a0,fc <main+0xfc>
  26:	84aa                	mv	s1,a0
        long long add_cfs_priority=0;
  28:	f8043023          	sd	zero,-128(s0)
        long long add_rtime=0;
  2c:	f8043423          	sd	zero,-120(s0)
        long long add_stime=0;
  30:	f8043823          	sd	zero,-112(s0)
        long long add_retime=0;
  34:	f8043c23          	sd	zero,-104(s0)
        int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
  38:	69e1                	lui	s3,0x18
  3a:	6a09899b          	addiw	s3,s3,1696
        for(i = 0; i < 1000000; i++){
  3e:	000f4937          	lui	s2,0xf4
  42:	24090913          	addi	s2,s2,576 # f4240 <base+0xf3230>
  46:	a021                	j	4e <main+0x4e>
  48:	2485                	addiw	s1,s1,1
  4a:	01248b63          	beq	s1,s2,60 <main+0x60>
            if(i % 100000 == 0){
  4e:	0334e7bb          	remw	a5,s1,s3
  52:	fbfd                	bnez	a5,48 <main+0x48>
                sleep(1);
  54:	4505                	li	a0,1
  56:	00000097          	auipc	ra,0x0
  5a:	61c080e7          	jalr	1564(ra) # 672 <sleep>
  5e:	b7ed                	j	48 <main+0x48>
            }
        }
        sleep(10*getpid());
  60:	00000097          	auipc	ra,0x0
  64:	602080e7          	jalr	1538(ra) # 662 <getpid>
  68:	0025179b          	slliw	a5,a0,0x2
  6c:	9d3d                	addw	a0,a0,a5
  6e:	0015151b          	slliw	a0,a0,0x1
  72:	00000097          	auipc	ra,0x0
  76:	600080e7          	jalr	1536(ra) # 672 <sleep>
        get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
  7a:	00000097          	auipc	ra,0x0
  7e:	5e8080e7          	jalr	1512(ra) # 662 <getpid>
  82:	f9840713          	addi	a4,s0,-104
  86:	f9040693          	addi	a3,s0,-112
  8a:	f8840613          	addi	a2,s0,-120
  8e:	f8040593          	addi	a1,s0,-128
  92:	00000097          	auipc	ra,0x0
  96:	608080e7          	jalr	1544(ra) # 69a <get_cfs_stats>
        printf("my cfs priority is %d\n", add_cfs_priority);
  9a:	f8043583          	ld	a1,-128(s0)
  9e:	00001517          	auipc	a0,0x1
  a2:	a9250513          	addi	a0,a0,-1390 # b30 <malloc+0xf0>
  a6:	00001097          	auipc	ra,0x1
  aa:	8dc080e7          	jalr	-1828(ra) # 982 <printf>
        printf("my runtime is %d\n", add_rtime);
  ae:	f8843583          	ld	a1,-120(s0)
  b2:	00001517          	auipc	a0,0x1
  b6:	a9650513          	addi	a0,a0,-1386 # b48 <malloc+0x108>
  ba:	00001097          	auipc	ra,0x1
  be:	8c8080e7          	jalr	-1848(ra) # 982 <printf>
        printf("my sleeptime is %d\n", add_stime);
  c2:	f9043583          	ld	a1,-112(s0)
  c6:	00001517          	auipc	a0,0x1
  ca:	a9a50513          	addi	a0,a0,-1382 # b60 <malloc+0x120>
  ce:	00001097          	auipc	ra,0x1
  d2:	8b4080e7          	jalr	-1868(ra) # 982 <printf>
        printf("my runnable time is %d\n", add_retime);
  d6:	f9843583          	ld	a1,-104(s0)
  da:	00001517          	auipc	a0,0x1
  de:	a9e50513          	addi	a0,a0,-1378 # b78 <malloc+0x138>
  e2:	00001097          	auipc	ra,0x1
  e6:	8a0080e7          	jalr	-1888(ra) # 982 <printf>


        

        exit(0,"cfs 1st child exited");
  ea:	00001597          	auipc	a1,0x1
  ee:	aa658593          	addi	a1,a1,-1370 # b90 <malloc+0x150>
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	4ee080e7          	jalr	1262(ra) # 5e2 <exit>
    }
   


    //set process priority to medium
    set_cfs_priority(1);
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	594080e7          	jalr	1428(ra) # 692 <set_cfs_priority>
    int pid2 = fork();
 106:	00000097          	auipc	ra,0x0
 10a:	4d4080e7          	jalr	1236(ra) # 5da <fork>
 10e:	84aa                	mv	s1,a0
    if(pid2 == 0){
 110:	e969                	bnez	a0,1e2 <main+0x1e2>
        long long add_cfs_priority=0;
 112:	f8043023          	sd	zero,-128(s0)
        long long add_rtime=0;
 116:	f8043423          	sd	zero,-120(s0)
        long long add_stime=0;
 11a:	f8043823          	sd	zero,-112(s0)
        long long add_retime=0;
 11e:	f8043c23          	sd	zero,-104(s0)
        int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
 122:	69e1                	lui	s3,0x18
 124:	6a09899b          	addiw	s3,s3,1696
        for(i = 0; i < 1000000; i++){
 128:	000f4937          	lui	s2,0xf4
 12c:	24090913          	addi	s2,s2,576 # f4240 <base+0xf3230>
 130:	a021                	j	138 <main+0x138>
 132:	2485                	addiw	s1,s1,1
 134:	01248b63          	beq	s1,s2,14a <main+0x14a>
            if(i % 100000 == 0){
 138:	0334e7bb          	remw	a5,s1,s3
 13c:	fbfd                	bnez	a5,132 <main+0x132>
                sleep(1);
 13e:	4505                	li	a0,1
 140:	00000097          	auipc	ra,0x0
 144:	532080e7          	jalr	1330(ra) # 672 <sleep>
 148:	b7ed                	j	132 <main+0x132>
            }
        }
        sleep(30*getpid());
 14a:	00000097          	auipc	ra,0x0
 14e:	518080e7          	jalr	1304(ra) # 662 <getpid>
 152:	47f9                	li	a5,30
 154:	02a7853b          	mulw	a0,a5,a0
 158:	00000097          	auipc	ra,0x0
 15c:	51a080e7          	jalr	1306(ra) # 672 <sleep>
        get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
 160:	00000097          	auipc	ra,0x0
 164:	502080e7          	jalr	1282(ra) # 662 <getpid>
 168:	f9840713          	addi	a4,s0,-104
 16c:	f9040693          	addi	a3,s0,-112
 170:	f8840613          	addi	a2,s0,-120
 174:	f8040593          	addi	a1,s0,-128
 178:	00000097          	auipc	ra,0x0
 17c:	522080e7          	jalr	1314(ra) # 69a <get_cfs_stats>
        printf("my cfs priority is %d\n", add_cfs_priority);
 180:	f8043583          	ld	a1,-128(s0)
 184:	00001517          	auipc	a0,0x1
 188:	9ac50513          	addi	a0,a0,-1620 # b30 <malloc+0xf0>
 18c:	00000097          	auipc	ra,0x0
 190:	7f6080e7          	jalr	2038(ra) # 982 <printf>
        printf("my runtime is %d\n", add_rtime);
 194:	f8843583          	ld	a1,-120(s0)
 198:	00001517          	auipc	a0,0x1
 19c:	9b050513          	addi	a0,a0,-1616 # b48 <malloc+0x108>
 1a0:	00000097          	auipc	ra,0x0
 1a4:	7e2080e7          	jalr	2018(ra) # 982 <printf>
        printf("my sleeptime is %d\n", add_stime);
 1a8:	f9043583          	ld	a1,-112(s0)
 1ac:	00001517          	auipc	a0,0x1
 1b0:	9b450513          	addi	a0,a0,-1612 # b60 <malloc+0x120>
 1b4:	00000097          	auipc	ra,0x0
 1b8:	7ce080e7          	jalr	1998(ra) # 982 <printf>
        printf("my runnable time is %d\n", add_retime);
 1bc:	f9843583          	ld	a1,-104(s0)
 1c0:	00001517          	auipc	a0,0x1
 1c4:	9b850513          	addi	a0,a0,-1608 # b78 <malloc+0x138>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	7ba080e7          	jalr	1978(ra) # 982 <printf>

        exit(0,"cfs 2nd child exited");
 1d0:	00001597          	auipc	a1,0x1
 1d4:	9d858593          	addi	a1,a1,-1576 # ba8 <malloc+0x168>
 1d8:	4501                	li	a0,0
 1da:	00000097          	auipc	ra,0x0
 1de:	408080e7          	jalr	1032(ra) # 5e2 <exit>
    }
    

    //set process priority to high
    set_cfs_priority(2);
 1e2:	4509                	li	a0,2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	4ae080e7          	jalr	1198(ra) # 692 <set_cfs_priority>
    int pid3 = fork();
 1ec:	00000097          	auipc	ra,0x0
 1f0:	3ee080e7          	jalr	1006(ra) # 5da <fork>
 1f4:	84aa                	mv	s1,a0
    if(pid3 == 0){    
 1f6:	e175                	bnez	a0,2da <main+0x2da>
    long long add_cfs_priority=0;
 1f8:	f8043023          	sd	zero,-128(s0)
    long long add_rtime=0;
 1fc:	f8043423          	sd	zero,-120(s0)
    long long add_stime=0;
 200:	f8043823          	sd	zero,-112(s0)
    long long add_retime=0;
 204:	f8043c23          	sd	zero,-104(s0)
    int i;
        for(i = 0; i < 1000000; i++){
            if(i % 100000 == 0){
 208:	69e1                	lui	s3,0x18
 20a:	6a09899b          	addiw	s3,s3,1696
                //sleep(1);
                printf("%s\n", "yalla macabi");
 20e:	00001a97          	auipc	s5,0x1
 212:	9b2a8a93          	addi	s5,s5,-1614 # bc0 <malloc+0x180>
 216:	00001a17          	auipc	s4,0x1
 21a:	9baa0a13          	addi	s4,s4,-1606 # bd0 <malloc+0x190>
        for(i = 0; i < 1000000; i++){
 21e:	000f4937          	lui	s2,0xf4
 222:	24090913          	addi	s2,s2,576 # f4240 <base+0xf3230>
 226:	a021                	j	22e <main+0x22e>
 228:	2485                	addiw	s1,s1,1
 22a:	01248c63          	beq	s1,s2,242 <main+0x242>
            if(i % 100000 == 0){
 22e:	0334e7bb          	remw	a5,s1,s3
 232:	fbfd                	bnez	a5,228 <main+0x228>
                printf("%s\n", "yalla macabi");
 234:	85d6                	mv	a1,s5
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	74a080e7          	jalr	1866(ra) # 982 <printf>
 240:	b7e5                	j	228 <main+0x228>
            }
        }
    sleep(10*getpid());
 242:	00000097          	auipc	ra,0x0
 246:	420080e7          	jalr	1056(ra) # 662 <getpid>
 24a:	47a9                	li	a5,10
 24c:	02a7853b          	mulw	a0,a5,a0
 250:	00000097          	auipc	ra,0x0
 254:	422080e7          	jalr	1058(ra) # 672 <sleep>
    get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
 258:	00000097          	auipc	ra,0x0
 25c:	40a080e7          	jalr	1034(ra) # 662 <getpid>
 260:	f9840713          	addi	a4,s0,-104
 264:	f9040693          	addi	a3,s0,-112
 268:	f8840613          	addi	a2,s0,-120
 26c:	f8040593          	addi	a1,s0,-128
 270:	00000097          	auipc	ra,0x0
 274:	42a080e7          	jalr	1066(ra) # 69a <get_cfs_stats>
    printf("my cfs priority is %d\n", add_cfs_priority);
 278:	f8043583          	ld	a1,-128(s0)
 27c:	00001517          	auipc	a0,0x1
 280:	8b450513          	addi	a0,a0,-1868 # b30 <malloc+0xf0>
 284:	00000097          	auipc	ra,0x0
 288:	6fe080e7          	jalr	1790(ra) # 982 <printf>
    printf("my runtime is %d\n", add_rtime);
 28c:	f8843583          	ld	a1,-120(s0)
 290:	00001517          	auipc	a0,0x1
 294:	8b850513          	addi	a0,a0,-1864 # b48 <malloc+0x108>
 298:	00000097          	auipc	ra,0x0
 29c:	6ea080e7          	jalr	1770(ra) # 982 <printf>
    printf("my sleeptime is %d\n", add_stime);
 2a0:	f9043583          	ld	a1,-112(s0)
 2a4:	00001517          	auipc	a0,0x1
 2a8:	8bc50513          	addi	a0,a0,-1860 # b60 <malloc+0x120>
 2ac:	00000097          	auipc	ra,0x0
 2b0:	6d6080e7          	jalr	1750(ra) # 982 <printf>
    printf("my runnable time is %d\n", add_retime);
 2b4:	f9843583          	ld	a1,-104(s0)
 2b8:	00001517          	auipc	a0,0x1
 2bc:	8c050513          	addi	a0,a0,-1856 # b78 <malloc+0x138>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	6c2080e7          	jalr	1730(ra) # 982 <printf>

        exit(0,"cfs 3rd child exited");
 2c8:	00001597          	auipc	a1,0x1
 2cc:	91058593          	addi	a1,a1,-1776 # bd8 <malloc+0x198>
 2d0:	4501                	li	a0,0
 2d2:	00000097          	auipc	ra,0x0
 2d6:	310080e7          	jalr	784(ra) # 5e2 <exit>
    }
   
   
    // wait for the 3 children to finish
     //wait for the first child
    wait(0,msg);
 2da:	fa040593          	addi	a1,s0,-96
 2de:	4501                	li	a0,0
 2e0:	00000097          	auipc	ra,0x0
 2e4:	30a080e7          	jalr	778(ra) # 5ea <wait>
    printf("%s\n",msg);
 2e8:	fa040593          	addi	a1,s0,-96
 2ec:	00001517          	auipc	a0,0x1
 2f0:	8e450513          	addi	a0,a0,-1820 # bd0 <malloc+0x190>
 2f4:	00000097          	auipc	ra,0x0
 2f8:	68e080e7          	jalr	1678(ra) # 982 <printf>
     //wait for the second child
    wait(0,msg);
 2fc:	fa040593          	addi	a1,s0,-96
 300:	4501                	li	a0,0
 302:	00000097          	auipc	ra,0x0
 306:	2e8080e7          	jalr	744(ra) # 5ea <wait>
    printf("%s\n",msg);
 30a:	fa040593          	addi	a1,s0,-96
 30e:	00001517          	auipc	a0,0x1
 312:	8c250513          	addi	a0,a0,-1854 # bd0 <malloc+0x190>
 316:	00000097          	auipc	ra,0x0
 31a:	66c080e7          	jalr	1644(ra) # 982 <printf>
    
   
    // //wait for the third child
    wait(0,msg);
 31e:	fa040593          	addi	a1,s0,-96
 322:	4501                	li	a0,0
 324:	00000097          	auipc	ra,0x0
 328:	2c6080e7          	jalr	710(ra) # 5ea <wait>
    printf("%s\n",msg);
 32c:	fa040593          	addi	a1,s0,-96
 330:	00001517          	auipc	a0,0x1
 334:	8a050513          	addi	a0,a0,-1888 # bd0 <malloc+0x190>
 338:	00000097          	auipc	ra,0x0
 33c:	64a080e7          	jalr	1610(ra) # 982 <printf>
      


    exit(0,"cfs finished");
 340:	00001597          	auipc	a1,0x1
 344:	8b058593          	addi	a1,a1,-1872 # bf0 <malloc+0x1b0>
 348:	4501                	li	a0,0
 34a:	00000097          	auipc	ra,0x0
 34e:	298080e7          	jalr	664(ra) # 5e2 <exit>

0000000000000352 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  extern int main();
  main();
 35a:	00000097          	auipc	ra,0x0
 35e:	ca6080e7          	jalr	-858(ra) # 0 <main>
  exit(0,"");
 362:	00001597          	auipc	a1,0x1
 366:	89e58593          	addi	a1,a1,-1890 # c00 <malloc+0x1c0>
 36a:	4501                	li	a0,0
 36c:	00000097          	auipc	ra,0x0
 370:	276080e7          	jalr	630(ra) # 5e2 <exit>

0000000000000374 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 374:	1141                	addi	sp,sp,-16
 376:	e422                	sd	s0,8(sp)
 378:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 37a:	87aa                	mv	a5,a0
 37c:	0585                	addi	a1,a1,1
 37e:	0785                	addi	a5,a5,1
 380:	fff5c703          	lbu	a4,-1(a1)
 384:	fee78fa3          	sb	a4,-1(a5)
 388:	fb75                	bnez	a4,37c <strcpy+0x8>
    ;
  return os;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 396:	00054783          	lbu	a5,0(a0)
 39a:	cb91                	beqz	a5,3ae <strcmp+0x1e>
 39c:	0005c703          	lbu	a4,0(a1)
 3a0:	00f71763          	bne	a4,a5,3ae <strcmp+0x1e>
    p++, q++;
 3a4:	0505                	addi	a0,a0,1
 3a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3a8:	00054783          	lbu	a5,0(a0)
 3ac:	fbe5                	bnez	a5,39c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3ae:	0005c503          	lbu	a0,0(a1)
}
 3b2:	40a7853b          	subw	a0,a5,a0
 3b6:	6422                	ld	s0,8(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret

00000000000003bc <strlen>:

uint
strlen(const char *s)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3c2:	00054783          	lbu	a5,0(a0)
 3c6:	cf91                	beqz	a5,3e2 <strlen+0x26>
 3c8:	0505                	addi	a0,a0,1
 3ca:	87aa                	mv	a5,a0
 3cc:	4685                	li	a3,1
 3ce:	9e89                	subw	a3,a3,a0
 3d0:	00f6853b          	addw	a0,a3,a5
 3d4:	0785                	addi	a5,a5,1
 3d6:	fff7c703          	lbu	a4,-1(a5)
 3da:	fb7d                	bnez	a4,3d0 <strlen+0x14>
    ;
  return n;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret
  for(n = 0; s[n]; n++)
 3e2:	4501                	li	a0,0
 3e4:	bfe5                	j	3dc <strlen+0x20>

00000000000003e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e422                	sd	s0,8(sp)
 3ea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3ec:	ca19                	beqz	a2,402 <memset+0x1c>
 3ee:	87aa                	mv	a5,a0
 3f0:	1602                	slli	a2,a2,0x20
 3f2:	9201                	srli	a2,a2,0x20
 3f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3f8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3fc:	0785                	addi	a5,a5,1
 3fe:	fee79de3          	bne	a5,a4,3f8 <memset+0x12>
  }
  return dst;
}
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <strchr>:

char*
strchr(const char *s, char c)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 40e:	00054783          	lbu	a5,0(a0)
 412:	cb99                	beqz	a5,428 <strchr+0x20>
    if(*s == c)
 414:	00f58763          	beq	a1,a5,422 <strchr+0x1a>
  for(; *s; s++)
 418:	0505                	addi	a0,a0,1
 41a:	00054783          	lbu	a5,0(a0)
 41e:	fbfd                	bnez	a5,414 <strchr+0xc>
      return (char*)s;
  return 0;
 420:	4501                	li	a0,0
}
 422:	6422                	ld	s0,8(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
  return 0;
 428:	4501                	li	a0,0
 42a:	bfe5                	j	422 <strchr+0x1a>

000000000000042c <gets>:

char*
gets(char *buf, int max)
{
 42c:	711d                	addi	sp,sp,-96
 42e:	ec86                	sd	ra,88(sp)
 430:	e8a2                	sd	s0,80(sp)
 432:	e4a6                	sd	s1,72(sp)
 434:	e0ca                	sd	s2,64(sp)
 436:	fc4e                	sd	s3,56(sp)
 438:	f852                	sd	s4,48(sp)
 43a:	f456                	sd	s5,40(sp)
 43c:	f05a                	sd	s6,32(sp)
 43e:	ec5e                	sd	s7,24(sp)
 440:	1080                	addi	s0,sp,96
 442:	8baa                	mv	s7,a0
 444:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 446:	892a                	mv	s2,a0
 448:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 44a:	4aa9                	li	s5,10
 44c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 44e:	89a6                	mv	s3,s1
 450:	2485                	addiw	s1,s1,1
 452:	0344d863          	bge	s1,s4,482 <gets+0x56>
    cc = read(0, &c, 1);
 456:	4605                	li	a2,1
 458:	faf40593          	addi	a1,s0,-81
 45c:	4501                	li	a0,0
 45e:	00000097          	auipc	ra,0x0
 462:	19c080e7          	jalr	412(ra) # 5fa <read>
    if(cc < 1)
 466:	00a05e63          	blez	a0,482 <gets+0x56>
    buf[i++] = c;
 46a:	faf44783          	lbu	a5,-81(s0)
 46e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 472:	01578763          	beq	a5,s5,480 <gets+0x54>
 476:	0905                	addi	s2,s2,1
 478:	fd679be3          	bne	a5,s6,44e <gets+0x22>
  for(i=0; i+1 < max; ){
 47c:	89a6                	mv	s3,s1
 47e:	a011                	j	482 <gets+0x56>
 480:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 482:	99de                	add	s3,s3,s7
 484:	00098023          	sb	zero,0(s3) # 18000 <base+0x16ff0>
  return buf;
}
 488:	855e                	mv	a0,s7
 48a:	60e6                	ld	ra,88(sp)
 48c:	6446                	ld	s0,80(sp)
 48e:	64a6                	ld	s1,72(sp)
 490:	6906                	ld	s2,64(sp)
 492:	79e2                	ld	s3,56(sp)
 494:	7a42                	ld	s4,48(sp)
 496:	7aa2                	ld	s5,40(sp)
 498:	7b02                	ld	s6,32(sp)
 49a:	6be2                	ld	s7,24(sp)
 49c:	6125                	addi	sp,sp,96
 49e:	8082                	ret

00000000000004a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	e426                	sd	s1,8(sp)
 4a8:	e04a                	sd	s2,0(sp)
 4aa:	1000                	addi	s0,sp,32
 4ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ae:	4581                	li	a1,0
 4b0:	00000097          	auipc	ra,0x0
 4b4:	172080e7          	jalr	370(ra) # 622 <open>
  if(fd < 0)
 4b8:	02054563          	bltz	a0,4e2 <stat+0x42>
 4bc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4be:	85ca                	mv	a1,s2
 4c0:	00000097          	auipc	ra,0x0
 4c4:	17a080e7          	jalr	378(ra) # 63a <fstat>
 4c8:	892a                	mv	s2,a0
  close(fd);
 4ca:	8526                	mv	a0,s1
 4cc:	00000097          	auipc	ra,0x0
 4d0:	13e080e7          	jalr	318(ra) # 60a <close>
  return r;
}
 4d4:	854a                	mv	a0,s2
 4d6:	60e2                	ld	ra,24(sp)
 4d8:	6442                	ld	s0,16(sp)
 4da:	64a2                	ld	s1,8(sp)
 4dc:	6902                	ld	s2,0(sp)
 4de:	6105                	addi	sp,sp,32
 4e0:	8082                	ret
    return -1;
 4e2:	597d                	li	s2,-1
 4e4:	bfc5                	j	4d4 <stat+0x34>

00000000000004e6 <atoi>:

int
atoi(const char *s)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ec:	00054603          	lbu	a2,0(a0)
 4f0:	fd06079b          	addiw	a5,a2,-48
 4f4:	0ff7f793          	andi	a5,a5,255
 4f8:	4725                	li	a4,9
 4fa:	02f76963          	bltu	a4,a5,52c <atoi+0x46>
 4fe:	86aa                	mv	a3,a0
  n = 0;
 500:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 502:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 504:	0685                	addi	a3,a3,1
 506:	0025179b          	slliw	a5,a0,0x2
 50a:	9fa9                	addw	a5,a5,a0
 50c:	0017979b          	slliw	a5,a5,0x1
 510:	9fb1                	addw	a5,a5,a2
 512:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 516:	0006c603          	lbu	a2,0(a3)
 51a:	fd06071b          	addiw	a4,a2,-48
 51e:	0ff77713          	andi	a4,a4,255
 522:	fee5f1e3          	bgeu	a1,a4,504 <atoi+0x1e>
  return n;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret
  n = 0;
 52c:	4501                	li	a0,0
 52e:	bfe5                	j	526 <atoi+0x40>

0000000000000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	1141                	addi	sp,sp,-16
 532:	e422                	sd	s0,8(sp)
 534:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 536:	02b57463          	bgeu	a0,a1,55e <memmove+0x2e>
    while(n-- > 0)
 53a:	00c05f63          	blez	a2,558 <memmove+0x28>
 53e:	1602                	slli	a2,a2,0x20
 540:	9201                	srli	a2,a2,0x20
 542:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 546:	872a                	mv	a4,a0
      *dst++ = *src++;
 548:	0585                	addi	a1,a1,1
 54a:	0705                	addi	a4,a4,1
 54c:	fff5c683          	lbu	a3,-1(a1)
 550:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 554:	fee79ae3          	bne	a5,a4,548 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 558:	6422                	ld	s0,8(sp)
 55a:	0141                	addi	sp,sp,16
 55c:	8082                	ret
    dst += n;
 55e:	00c50733          	add	a4,a0,a2
    src += n;
 562:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 564:	fec05ae3          	blez	a2,558 <memmove+0x28>
 568:	fff6079b          	addiw	a5,a2,-1
 56c:	1782                	slli	a5,a5,0x20
 56e:	9381                	srli	a5,a5,0x20
 570:	fff7c793          	not	a5,a5
 574:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 576:	15fd                	addi	a1,a1,-1
 578:	177d                	addi	a4,a4,-1
 57a:	0005c683          	lbu	a3,0(a1)
 57e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 582:	fee79ae3          	bne	a5,a4,576 <memmove+0x46>
 586:	bfc9                	j	558 <memmove+0x28>

0000000000000588 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 588:	1141                	addi	sp,sp,-16
 58a:	e422                	sd	s0,8(sp)
 58c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 58e:	ca05                	beqz	a2,5be <memcmp+0x36>
 590:	fff6069b          	addiw	a3,a2,-1
 594:	1682                	slli	a3,a3,0x20
 596:	9281                	srli	a3,a3,0x20
 598:	0685                	addi	a3,a3,1
 59a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 59c:	00054783          	lbu	a5,0(a0)
 5a0:	0005c703          	lbu	a4,0(a1)
 5a4:	00e79863          	bne	a5,a4,5b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5a8:	0505                	addi	a0,a0,1
    p2++;
 5aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5ac:	fed518e3          	bne	a0,a3,59c <memcmp+0x14>
  }
  return 0;
 5b0:	4501                	li	a0,0
 5b2:	a019                	j	5b8 <memcmp+0x30>
      return *p1 - *p2;
 5b4:	40e7853b          	subw	a0,a5,a4
}
 5b8:	6422                	ld	s0,8(sp)
 5ba:	0141                	addi	sp,sp,16
 5bc:	8082                	ret
  return 0;
 5be:	4501                	li	a0,0
 5c0:	bfe5                	j	5b8 <memcmp+0x30>

00000000000005c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5c2:	1141                	addi	sp,sp,-16
 5c4:	e406                	sd	ra,8(sp)
 5c6:	e022                	sd	s0,0(sp)
 5c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5ca:	00000097          	auipc	ra,0x0
 5ce:	f66080e7          	jalr	-154(ra) # 530 <memmove>
}
 5d2:	60a2                	ld	ra,8(sp)
 5d4:	6402                	ld	s0,0(sp)
 5d6:	0141                	addi	sp,sp,16
 5d8:	8082                	ret

00000000000005da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5da:	4885                	li	a7,1
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5e2:	4889                	li	a7,2
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ea:	488d                	li	a7,3
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5f2:	4891                	li	a7,4
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <read>:
.global read
read:
 li a7, SYS_read
 5fa:	4895                	li	a7,5
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <write>:
.global write
write:
 li a7, SYS_write
 602:	48c1                	li	a7,16
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <close>:
.global close
close:
 li a7, SYS_close
 60a:	48d5                	li	a7,21
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <kill>:
.global kill
kill:
 li a7, SYS_kill
 612:	4899                	li	a7,6
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <exec>:
.global exec
exec:
 li a7, SYS_exec
 61a:	489d                	li	a7,7
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <open>:
.global open
open:
 li a7, SYS_open
 622:	48bd                	li	a7,15
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 62a:	48c5                	li	a7,17
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 632:	48c9                	li	a7,18
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 63a:	48a1                	li	a7,8
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <link>:
.global link
link:
 li a7, SYS_link
 642:	48cd                	li	a7,19
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 64a:	48d1                	li	a7,20
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 652:	48a5                	li	a7,9
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <dup>:
.global dup
dup:
 li a7, SYS_dup
 65a:	48a9                	li	a7,10
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 662:	48ad                	li	a7,11
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 66a:	48b1                	li	a7,12
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 672:	48b5                	li	a7,13
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 67a:	48b9                	li	a7,14
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 682:	48d9                	li	a7,22
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 68a:	48dd                	li	a7,23
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 692:	48e1                	li	a7,24
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 69a:	48e5                	li	a7,25
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 6a2:	48e9                	li	a7,26
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6aa:	1101                	addi	sp,sp,-32
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6b6:	4605                	li	a2,1
 6b8:	fef40593          	addi	a1,s0,-17
 6bc:	00000097          	auipc	ra,0x0
 6c0:	f46080e7          	jalr	-186(ra) # 602 <write>
}
 6c4:	60e2                	ld	ra,24(sp)
 6c6:	6442                	ld	s0,16(sp)
 6c8:	6105                	addi	sp,sp,32
 6ca:	8082                	ret

00000000000006cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6cc:	7139                	addi	sp,sp,-64
 6ce:	fc06                	sd	ra,56(sp)
 6d0:	f822                	sd	s0,48(sp)
 6d2:	f426                	sd	s1,40(sp)
 6d4:	f04a                	sd	s2,32(sp)
 6d6:	ec4e                	sd	s3,24(sp)
 6d8:	0080                	addi	s0,sp,64
 6da:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6dc:	c299                	beqz	a3,6e2 <printint+0x16>
 6de:	0805c863          	bltz	a1,76e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6e2:	2581                	sext.w	a1,a1
  neg = 0;
 6e4:	4881                	li	a7,0
 6e6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6ec:	2601                	sext.w	a2,a2
 6ee:	00000517          	auipc	a0,0x0
 6f2:	52250513          	addi	a0,a0,1314 # c10 <digits>
 6f6:	883a                	mv	a6,a4
 6f8:	2705                	addiw	a4,a4,1
 6fa:	02c5f7bb          	remuw	a5,a1,a2
 6fe:	1782                	slli	a5,a5,0x20
 700:	9381                	srli	a5,a5,0x20
 702:	97aa                	add	a5,a5,a0
 704:	0007c783          	lbu	a5,0(a5)
 708:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 70c:	0005879b          	sext.w	a5,a1
 710:	02c5d5bb          	divuw	a1,a1,a2
 714:	0685                	addi	a3,a3,1
 716:	fec7f0e3          	bgeu	a5,a2,6f6 <printint+0x2a>
  if(neg)
 71a:	00088b63          	beqz	a7,730 <printint+0x64>
    buf[i++] = '-';
 71e:	fd040793          	addi	a5,s0,-48
 722:	973e                	add	a4,a4,a5
 724:	02d00793          	li	a5,45
 728:	fef70823          	sb	a5,-16(a4)
 72c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 730:	02e05863          	blez	a4,760 <printint+0x94>
 734:	fc040793          	addi	a5,s0,-64
 738:	00e78933          	add	s2,a5,a4
 73c:	fff78993          	addi	s3,a5,-1
 740:	99ba                	add	s3,s3,a4
 742:	377d                	addiw	a4,a4,-1
 744:	1702                	slli	a4,a4,0x20
 746:	9301                	srli	a4,a4,0x20
 748:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 74c:	fff94583          	lbu	a1,-1(s2)
 750:	8526                	mv	a0,s1
 752:	00000097          	auipc	ra,0x0
 756:	f58080e7          	jalr	-168(ra) # 6aa <putc>
  while(--i >= 0)
 75a:	197d                	addi	s2,s2,-1
 75c:	ff3918e3          	bne	s2,s3,74c <printint+0x80>
}
 760:	70e2                	ld	ra,56(sp)
 762:	7442                	ld	s0,48(sp)
 764:	74a2                	ld	s1,40(sp)
 766:	7902                	ld	s2,32(sp)
 768:	69e2                	ld	s3,24(sp)
 76a:	6121                	addi	sp,sp,64
 76c:	8082                	ret
    x = -xx;
 76e:	40b005bb          	negw	a1,a1
    neg = 1;
 772:	4885                	li	a7,1
    x = -xx;
 774:	bf8d                	j	6e6 <printint+0x1a>

0000000000000776 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 776:	7119                	addi	sp,sp,-128
 778:	fc86                	sd	ra,120(sp)
 77a:	f8a2                	sd	s0,112(sp)
 77c:	f4a6                	sd	s1,104(sp)
 77e:	f0ca                	sd	s2,96(sp)
 780:	ecce                	sd	s3,88(sp)
 782:	e8d2                	sd	s4,80(sp)
 784:	e4d6                	sd	s5,72(sp)
 786:	e0da                	sd	s6,64(sp)
 788:	fc5e                	sd	s7,56(sp)
 78a:	f862                	sd	s8,48(sp)
 78c:	f466                	sd	s9,40(sp)
 78e:	f06a                	sd	s10,32(sp)
 790:	ec6e                	sd	s11,24(sp)
 792:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 794:	0005c903          	lbu	s2,0(a1)
 798:	18090f63          	beqz	s2,936 <vprintf+0x1c0>
 79c:	8aaa                	mv	s5,a0
 79e:	8b32                	mv	s6,a2
 7a0:	00158493          	addi	s1,a1,1
  state = 0;
 7a4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7a6:	02500a13          	li	s4,37
      if(c == 'd'){
 7aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 7ae:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 7b2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 7b6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ba:	00000b97          	auipc	s7,0x0
 7be:	456b8b93          	addi	s7,s7,1110 # c10 <digits>
 7c2:	a839                	j	7e0 <vprintf+0x6a>
        putc(fd, c);
 7c4:	85ca                	mv	a1,s2
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	ee2080e7          	jalr	-286(ra) # 6aa <putc>
 7d0:	a019                	j	7d6 <vprintf+0x60>
    } else if(state == '%'){
 7d2:	01498f63          	beq	s3,s4,7f0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 7d6:	0485                	addi	s1,s1,1
 7d8:	fff4c903          	lbu	s2,-1(s1)
 7dc:	14090d63          	beqz	s2,936 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 7e0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7e4:	fe0997e3          	bnez	s3,7d2 <vprintf+0x5c>
      if(c == '%'){
 7e8:	fd479ee3          	bne	a5,s4,7c4 <vprintf+0x4e>
        state = '%';
 7ec:	89be                	mv	s3,a5
 7ee:	b7e5                	j	7d6 <vprintf+0x60>
      if(c == 'd'){
 7f0:	05878063          	beq	a5,s8,830 <vprintf+0xba>
      } else if(c == 'l') {
 7f4:	05978c63          	beq	a5,s9,84c <vprintf+0xd6>
      } else if(c == 'x') {
 7f8:	07a78863          	beq	a5,s10,868 <vprintf+0xf2>
      } else if(c == 'p') {
 7fc:	09b78463          	beq	a5,s11,884 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 800:	07300713          	li	a4,115
 804:	0ce78663          	beq	a5,a4,8d0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 808:	06300713          	li	a4,99
 80c:	0ee78e63          	beq	a5,a4,908 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 810:	11478863          	beq	a5,s4,920 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 814:	85d2                	mv	a1,s4
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	e92080e7          	jalr	-366(ra) # 6aa <putc>
        putc(fd, c);
 820:	85ca                	mv	a1,s2
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	e86080e7          	jalr	-378(ra) # 6aa <putc>
      }
      state = 0;
 82c:	4981                	li	s3,0
 82e:	b765                	j	7d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 830:	008b0913          	addi	s2,s6,8
 834:	4685                	li	a3,1
 836:	4629                	li	a2,10
 838:	000b2583          	lw	a1,0(s6)
 83c:	8556                	mv	a0,s5
 83e:	00000097          	auipc	ra,0x0
 842:	e8e080e7          	jalr	-370(ra) # 6cc <printint>
 846:	8b4a                	mv	s6,s2
      state = 0;
 848:	4981                	li	s3,0
 84a:	b771                	j	7d6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 84c:	008b0913          	addi	s2,s6,8
 850:	4681                	li	a3,0
 852:	4629                	li	a2,10
 854:	000b2583          	lw	a1,0(s6)
 858:	8556                	mv	a0,s5
 85a:	00000097          	auipc	ra,0x0
 85e:	e72080e7          	jalr	-398(ra) # 6cc <printint>
 862:	8b4a                	mv	s6,s2
      state = 0;
 864:	4981                	li	s3,0
 866:	bf85                	j	7d6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 868:	008b0913          	addi	s2,s6,8
 86c:	4681                	li	a3,0
 86e:	4641                	li	a2,16
 870:	000b2583          	lw	a1,0(s6)
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	e56080e7          	jalr	-426(ra) # 6cc <printint>
 87e:	8b4a                	mv	s6,s2
      state = 0;
 880:	4981                	li	s3,0
 882:	bf91                	j	7d6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 884:	008b0793          	addi	a5,s6,8
 888:	f8f43423          	sd	a5,-120(s0)
 88c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 890:	03000593          	li	a1,48
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	e14080e7          	jalr	-492(ra) # 6aa <putc>
  putc(fd, 'x');
 89e:	85ea                	mv	a1,s10
 8a0:	8556                	mv	a0,s5
 8a2:	00000097          	auipc	ra,0x0
 8a6:	e08080e7          	jalr	-504(ra) # 6aa <putc>
 8aa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ac:	03c9d793          	srli	a5,s3,0x3c
 8b0:	97de                	add	a5,a5,s7
 8b2:	0007c583          	lbu	a1,0(a5)
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	df2080e7          	jalr	-526(ra) # 6aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8c0:	0992                	slli	s3,s3,0x4
 8c2:	397d                	addiw	s2,s2,-1
 8c4:	fe0914e3          	bnez	s2,8ac <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 8c8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b721                	j	7d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 8d0:	008b0993          	addi	s3,s6,8
 8d4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 8d8:	02090163          	beqz	s2,8fa <vprintf+0x184>
        while(*s != 0){
 8dc:	00094583          	lbu	a1,0(s2)
 8e0:	c9a1                	beqz	a1,930 <vprintf+0x1ba>
          putc(fd, *s);
 8e2:	8556                	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	dc6080e7          	jalr	-570(ra) # 6aa <putc>
          s++;
 8ec:	0905                	addi	s2,s2,1
        while(*s != 0){
 8ee:	00094583          	lbu	a1,0(s2)
 8f2:	f9e5                	bnez	a1,8e2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 8f4:	8b4e                	mv	s6,s3
      state = 0;
 8f6:	4981                	li	s3,0
 8f8:	bdf9                	j	7d6 <vprintf+0x60>
          s = "(null)";
 8fa:	00000917          	auipc	s2,0x0
 8fe:	30e90913          	addi	s2,s2,782 # c08 <malloc+0x1c8>
        while(*s != 0){
 902:	02800593          	li	a1,40
 906:	bff1                	j	8e2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 908:	008b0913          	addi	s2,s6,8
 90c:	000b4583          	lbu	a1,0(s6)
 910:	8556                	mv	a0,s5
 912:	00000097          	auipc	ra,0x0
 916:	d98080e7          	jalr	-616(ra) # 6aa <putc>
 91a:	8b4a                	mv	s6,s2
      state = 0;
 91c:	4981                	li	s3,0
 91e:	bd65                	j	7d6 <vprintf+0x60>
        putc(fd, c);
 920:	85d2                	mv	a1,s4
 922:	8556                	mv	a0,s5
 924:	00000097          	auipc	ra,0x0
 928:	d86080e7          	jalr	-634(ra) # 6aa <putc>
      state = 0;
 92c:	4981                	li	s3,0
 92e:	b565                	j	7d6 <vprintf+0x60>
        s = va_arg(ap, char*);
 930:	8b4e                	mv	s6,s3
      state = 0;
 932:	4981                	li	s3,0
 934:	b54d                	j	7d6 <vprintf+0x60>
    }
  }
}
 936:	70e6                	ld	ra,120(sp)
 938:	7446                	ld	s0,112(sp)
 93a:	74a6                	ld	s1,104(sp)
 93c:	7906                	ld	s2,96(sp)
 93e:	69e6                	ld	s3,88(sp)
 940:	6a46                	ld	s4,80(sp)
 942:	6aa6                	ld	s5,72(sp)
 944:	6b06                	ld	s6,64(sp)
 946:	7be2                	ld	s7,56(sp)
 948:	7c42                	ld	s8,48(sp)
 94a:	7ca2                	ld	s9,40(sp)
 94c:	7d02                	ld	s10,32(sp)
 94e:	6de2                	ld	s11,24(sp)
 950:	6109                	addi	sp,sp,128
 952:	8082                	ret

0000000000000954 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 954:	715d                	addi	sp,sp,-80
 956:	ec06                	sd	ra,24(sp)
 958:	e822                	sd	s0,16(sp)
 95a:	1000                	addi	s0,sp,32
 95c:	e010                	sd	a2,0(s0)
 95e:	e414                	sd	a3,8(s0)
 960:	e818                	sd	a4,16(s0)
 962:	ec1c                	sd	a5,24(s0)
 964:	03043023          	sd	a6,32(s0)
 968:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 96c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 970:	8622                	mv	a2,s0
 972:	00000097          	auipc	ra,0x0
 976:	e04080e7          	jalr	-508(ra) # 776 <vprintf>
}
 97a:	60e2                	ld	ra,24(sp)
 97c:	6442                	ld	s0,16(sp)
 97e:	6161                	addi	sp,sp,80
 980:	8082                	ret

0000000000000982 <printf>:

void
printf(const char *fmt, ...)
{
 982:	711d                	addi	sp,sp,-96
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	1000                	addi	s0,sp,32
 98a:	e40c                	sd	a1,8(s0)
 98c:	e810                	sd	a2,16(s0)
 98e:	ec14                	sd	a3,24(s0)
 990:	f018                	sd	a4,32(s0)
 992:	f41c                	sd	a5,40(s0)
 994:	03043823          	sd	a6,48(s0)
 998:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 99c:	00840613          	addi	a2,s0,8
 9a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9a4:	85aa                	mv	a1,a0
 9a6:	4505                	li	a0,1
 9a8:	00000097          	auipc	ra,0x0
 9ac:	dce080e7          	jalr	-562(ra) # 776 <vprintf>
}
 9b0:	60e2                	ld	ra,24(sp)
 9b2:	6442                	ld	s0,16(sp)
 9b4:	6125                	addi	sp,sp,96
 9b6:	8082                	ret

00000000000009b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9b8:	1141                	addi	sp,sp,-16
 9ba:	e422                	sd	s0,8(sp)
 9bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c2:	00000797          	auipc	a5,0x0
 9c6:	63e7b783          	ld	a5,1598(a5) # 1000 <freep>
 9ca:	a805                	j	9fa <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9cc:	4618                	lw	a4,8(a2)
 9ce:	9db9                	addw	a1,a1,a4
 9d0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d4:	6398                	ld	a4,0(a5)
 9d6:	6318                	ld	a4,0(a4)
 9d8:	fee53823          	sd	a4,-16(a0)
 9dc:	a091                	j	a20 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9de:	ff852703          	lw	a4,-8(a0)
 9e2:	9e39                	addw	a2,a2,a4
 9e4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 9e6:	ff053703          	ld	a4,-16(a0)
 9ea:	e398                	sd	a4,0(a5)
 9ec:	a099                	j	a32 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ee:	6398                	ld	a4,0(a5)
 9f0:	00e7e463          	bltu	a5,a4,9f8 <free+0x40>
 9f4:	00e6ea63          	bltu	a3,a4,a08 <free+0x50>
{
 9f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fa:	fed7fae3          	bgeu	a5,a3,9ee <free+0x36>
 9fe:	6398                	ld	a4,0(a5)
 a00:	00e6e463          	bltu	a3,a4,a08 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a04:	fee7eae3          	bltu	a5,a4,9f8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 a08:	ff852583          	lw	a1,-8(a0)
 a0c:	6390                	ld	a2,0(a5)
 a0e:	02059713          	slli	a4,a1,0x20
 a12:	9301                	srli	a4,a4,0x20
 a14:	0712                	slli	a4,a4,0x4
 a16:	9736                	add	a4,a4,a3
 a18:	fae60ae3          	beq	a2,a4,9cc <free+0x14>
    bp->s.ptr = p->s.ptr;
 a1c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a20:	4790                	lw	a2,8(a5)
 a22:	02061713          	slli	a4,a2,0x20
 a26:	9301                	srli	a4,a4,0x20
 a28:	0712                	slli	a4,a4,0x4
 a2a:	973e                	add	a4,a4,a5
 a2c:	fae689e3          	beq	a3,a4,9de <free+0x26>
  } else
    p->s.ptr = bp;
 a30:	e394                	sd	a3,0(a5)
  freep = p;
 a32:	00000717          	auipc	a4,0x0
 a36:	5cf73723          	sd	a5,1486(a4) # 1000 <freep>
}
 a3a:	6422                	ld	s0,8(sp)
 a3c:	0141                	addi	sp,sp,16
 a3e:	8082                	ret

0000000000000a40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a40:	7139                	addi	sp,sp,-64
 a42:	fc06                	sd	ra,56(sp)
 a44:	f822                	sd	s0,48(sp)
 a46:	f426                	sd	s1,40(sp)
 a48:	f04a                	sd	s2,32(sp)
 a4a:	ec4e                	sd	s3,24(sp)
 a4c:	e852                	sd	s4,16(sp)
 a4e:	e456                	sd	s5,8(sp)
 a50:	e05a                	sd	s6,0(sp)
 a52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a54:	02051493          	slli	s1,a0,0x20
 a58:	9081                	srli	s1,s1,0x20
 a5a:	04bd                	addi	s1,s1,15
 a5c:	8091                	srli	s1,s1,0x4
 a5e:	0014899b          	addiw	s3,s1,1
 a62:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a64:	00000517          	auipc	a0,0x0
 a68:	59c53503          	ld	a0,1436(a0) # 1000 <freep>
 a6c:	c515                	beqz	a0,a98 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a70:	4798                	lw	a4,8(a5)
 a72:	02977f63          	bgeu	a4,s1,ab0 <malloc+0x70>
 a76:	8a4e                	mv	s4,s3
 a78:	0009871b          	sext.w	a4,s3
 a7c:	6685                	lui	a3,0x1
 a7e:	00d77363          	bgeu	a4,a3,a84 <malloc+0x44>
 a82:	6a05                	lui	s4,0x1
 a84:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a88:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a8c:	00000917          	auipc	s2,0x0
 a90:	57490913          	addi	s2,s2,1396 # 1000 <freep>
  if(p == (char*)-1)
 a94:	5afd                	li	s5,-1
 a96:	a88d                	j	b08 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a98:	00000797          	auipc	a5,0x0
 a9c:	57878793          	addi	a5,a5,1400 # 1010 <base>
 aa0:	00000717          	auipc	a4,0x0
 aa4:	56f73023          	sd	a5,1376(a4) # 1000 <freep>
 aa8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 aaa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 aae:	b7e1                	j	a76 <malloc+0x36>
      if(p->s.size == nunits)
 ab0:	02e48b63          	beq	s1,a4,ae6 <malloc+0xa6>
        p->s.size -= nunits;
 ab4:	4137073b          	subw	a4,a4,s3
 ab8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aba:	1702                	slli	a4,a4,0x20
 abc:	9301                	srli	a4,a4,0x20
 abe:	0712                	slli	a4,a4,0x4
 ac0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ac2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ac6:	00000717          	auipc	a4,0x0
 aca:	52a73d23          	sd	a0,1338(a4) # 1000 <freep>
      return (void*)(p + 1);
 ace:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 ad2:	70e2                	ld	ra,56(sp)
 ad4:	7442                	ld	s0,48(sp)
 ad6:	74a2                	ld	s1,40(sp)
 ad8:	7902                	ld	s2,32(sp)
 ada:	69e2                	ld	s3,24(sp)
 adc:	6a42                	ld	s4,16(sp)
 ade:	6aa2                	ld	s5,8(sp)
 ae0:	6b02                	ld	s6,0(sp)
 ae2:	6121                	addi	sp,sp,64
 ae4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 ae6:	6398                	ld	a4,0(a5)
 ae8:	e118                	sd	a4,0(a0)
 aea:	bff1                	j	ac6 <malloc+0x86>
  hp->s.size = nu;
 aec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 af0:	0541                	addi	a0,a0,16
 af2:	00000097          	auipc	ra,0x0
 af6:	ec6080e7          	jalr	-314(ra) # 9b8 <free>
  return freep;
 afa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 afe:	d971                	beqz	a0,ad2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b00:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b02:	4798                	lw	a4,8(a5)
 b04:	fa9776e3          	bgeu	a4,s1,ab0 <malloc+0x70>
    if(p == freep)
 b08:	00093703          	ld	a4,0(s2)
 b0c:	853e                	mv	a0,a5
 b0e:	fef719e3          	bne	a4,a5,b00 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 b12:	8552                	mv	a0,s4
 b14:	00000097          	auipc	ra,0x0
 b18:	b56080e7          	jalr	-1194(ra) # 66a <sbrk>
  if(p == (char*)-1)
 b1c:	fd5518e3          	bne	a0,s5,aec <malloc+0xac>
        return 0;
 b20:	4501                	li	a0,0
 b22:	bf45                	j	ad2 <malloc+0x92>
