
user/_cfs1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user.h"



int main(int argc, char const *argv[]){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	0880                	addi	s0,sp,80
    long long add_cfs_priority=0;
  10:	fc043423          	sd	zero,-56(s0)
    long long add_rtime=0;
  14:	fc043023          	sd	zero,-64(s0)
    long long add_stime=0;
  18:	fa043c23          	sd	zero,-72(s0)
    long long add_retime=0;
  1c:	fa043823          	sd	zero,-80(s0)

    set_cfs_priority(2);
  20:	4509                	li	a0,2
  22:	00000097          	auipc	ra,0x0
  26:	49a080e7          	jalr	1178(ra) # 4bc <set_cfs_priority>
    int pid=fork();
  2a:	00000097          	auipc	ra,0x0
  2e:	3da080e7          	jalr	986(ra) # 404 <fork>
  32:	84aa                	mv	s1,a0
     printf("%d\n--", 1);
  34:	4585                	li	a1,1
  36:	00001517          	auipc	a0,0x1
  3a:	91a50513          	addi	a0,a0,-1766 # 950 <malloc+0xe6>
  3e:	00000097          	auipc	ra,0x0
  42:	76e080e7          	jalr	1902(ra) # 7ac <printf>
    if(pid==0){
  46:	ec95                	bnez	s1,82 <main+0x82>
        printf("%d\n--", 2);
  48:	4589                	li	a1,2
  4a:	00001517          	auipc	a0,0x1
  4e:	90650513          	addi	a0,a0,-1786 # 950 <malloc+0xe6>
  52:	00000097          	auipc	ra,0x0
  56:	75a080e7          	jalr	1882(ra) # 7ac <printf>
        pid=fork();
  5a:	00000097          	auipc	ra,0x0
  5e:	3aa080e7          	jalr	938(ra) # 404 <fork>
        if(pid!=0){
  62:	c50d                	beqz	a0,8c <main+0x8c>
            printf("%d\n--", 3);
  64:	458d                	li	a1,3
  66:	00001517          	auipc	a0,0x1
  6a:	8ea50513          	addi	a0,a0,-1814 # 950 <malloc+0xe6>
  6e:	00000097          	auipc	ra,0x0
  72:	73e080e7          	jalr	1854(ra) # 7ac <printf>
           set_cfs_priority(1);  
  76:	4505                	li	a0,1
  78:	00000097          	auipc	ra,0x0
  7c:	444080e7          	jalr	1092(ra) # 4bc <set_cfs_priority>
  80:	a031                	j	8c <main+0x8c>
        }
    }
    else{
        set_cfs_priority(0);  
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	438080e7          	jalr	1080(ra) # 4bc <set_cfs_priority>
    }  
    printf("%d\n--", 4);
  8c:	4591                	li	a1,4
  8e:	00001517          	auipc	a0,0x1
  92:	8c250513          	addi	a0,a0,-1854 # 950 <malloc+0xe6>
  96:	00000097          	auipc	ra,0x0
  9a:	716080e7          	jalr	1814(ra) # 7ac <printf>
    int i;
    for(i = 0; i < 1000000; i++){
  9e:	4481                	li	s1,0
            if(i % 100000 == 0){
  a0:	69e1                	lui	s3,0x18
  a2:	6a09899b          	addiw	s3,s3,1696
                printf("%d\n--", 6);
  a6:	00001a17          	auipc	s4,0x1
  aa:	8aaa0a13          	addi	s4,s4,-1878 # 950 <malloc+0xe6>
    for(i = 0; i < 1000000; i++){
  ae:	000f4937          	lui	s2,0xf4
  b2:	24090913          	addi	s2,s2,576 # f4240 <base+0xf3230>
  b6:	a021                	j	be <main+0xbe>
  b8:	2485                	addiw	s1,s1,1
  ba:	03248163          	beq	s1,s2,dc <main+0xdc>
            if(i % 100000 == 0){
  be:	0334e7bb          	remw	a5,s1,s3
  c2:	fbfd                	bnez	a5,b8 <main+0xb8>
                printf("%d\n--", 6);
  c4:	4599                	li	a1,6
  c6:	8552                	mv	a0,s4
  c8:	00000097          	auipc	ra,0x0
  cc:	6e4080e7          	jalr	1764(ra) # 7ac <printf>
                sleep(1);
  d0:	4505                	li	a0,1
  d2:	00000097          	auipc	ra,0x0
  d6:	3ca080e7          	jalr	970(ra) # 49c <sleep>
  da:	bff9                	j	b8 <main+0xb8>
            }
    }
    printf("%d\n--", 5);
  dc:	4595                	li	a1,5
  de:	00001517          	auipc	a0,0x1
  e2:	87250513          	addi	a0,a0,-1934 # 950 <malloc+0xe6>
  e6:	00000097          	auipc	ra,0x0
  ea:	6c6080e7          	jalr	1734(ra) # 7ac <printf>
   get_cfs_stats(getpid(),&add_cfs_priority,&add_rtime,&add_stime,&add_retime);
  ee:	00000097          	auipc	ra,0x0
  f2:	39e080e7          	jalr	926(ra) # 48c <getpid>
  f6:	fb040713          	addi	a4,s0,-80
  fa:	fb840693          	addi	a3,s0,-72
  fe:	fc040613          	addi	a2,s0,-64
 102:	fc840593          	addi	a1,s0,-56
 106:	00000097          	auipc	ra,0x0
 10a:	3be080e7          	jalr	958(ra) # 4c4 <get_cfs_stats>
   wait(0,0);
 10e:	4581                	li	a1,0
 110:	4501                	li	a0,0
 112:	00000097          	auipc	ra,0x0
 116:	302080e7          	jalr	770(ra) # 414 <wait>
        printf("my cfs priority is %d\n", add_cfs_priority);
 11a:	fc843583          	ld	a1,-56(s0)
 11e:	00001517          	auipc	a0,0x1
 122:	83a50513          	addi	a0,a0,-1990 # 958 <malloc+0xee>
 126:	00000097          	auipc	ra,0x0
 12a:	686080e7          	jalr	1670(ra) # 7ac <printf>
        printf("my runtime is %d\n", add_rtime);
 12e:	fc043583          	ld	a1,-64(s0)
 132:	00001517          	auipc	a0,0x1
 136:	83e50513          	addi	a0,a0,-1986 # 970 <malloc+0x106>
 13a:	00000097          	auipc	ra,0x0
 13e:	672080e7          	jalr	1650(ra) # 7ac <printf>
        printf("my sleeptime is %d\n", add_stime);
 142:	fb843583          	ld	a1,-72(s0)
 146:	00001517          	auipc	a0,0x1
 14a:	84250513          	addi	a0,a0,-1982 # 988 <malloc+0x11e>
 14e:	00000097          	auipc	ra,0x0
 152:	65e080e7          	jalr	1630(ra) # 7ac <printf>
        printf("my runnable time is %d\n", add_retime);
 156:	fb043583          	ld	a1,-80(s0)
 15a:	00001517          	auipc	a0,0x1
 15e:	84650513          	addi	a0,a0,-1978 # 9a0 <malloc+0x136>
 162:	00000097          	auipc	ra,0x0
 166:	64a080e7          	jalr	1610(ra) # 7ac <printf>

    
    exit(0,"");
 16a:	00001597          	auipc	a1,0x1
 16e:	84e58593          	addi	a1,a1,-1970 # 9b8 <malloc+0x14e>
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	298080e7          	jalr	664(ra) # 40c <exit>

000000000000017c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e406                	sd	ra,8(sp)
 180:	e022                	sd	s0,0(sp)
 182:	0800                	addi	s0,sp,16
  extern int main();
  main();
 184:	00000097          	auipc	ra,0x0
 188:	e7c080e7          	jalr	-388(ra) # 0 <main>
  exit(0,"");
 18c:	00001597          	auipc	a1,0x1
 190:	82c58593          	addi	a1,a1,-2004 # 9b8 <malloc+0x14e>
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	276080e7          	jalr	630(ra) # 40c <exit>

000000000000019e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a4:	87aa                	mv	a5,a0
 1a6:	0585                	addi	a1,a1,1
 1a8:	0785                	addi	a5,a5,1
 1aa:	fff5c703          	lbu	a4,-1(a1)
 1ae:	fee78fa3          	sb	a4,-1(a5)
 1b2:	fb75                	bnez	a4,1a6 <strcpy+0x8>
    ;
  return os;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb91                	beqz	a5,1d8 <strcmp+0x1e>
 1c6:	0005c703          	lbu	a4,0(a1)
 1ca:	00f71763          	bne	a4,a5,1d8 <strcmp+0x1e>
    p++, q++;
 1ce:	0505                	addi	a0,a0,1
 1d0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	fbe5                	bnez	a5,1c6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d8:	0005c503          	lbu	a0,0(a1)
}
 1dc:	40a7853b          	subw	a0,a5,a0
 1e0:	6422                	ld	s0,8(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret

00000000000001e6 <strlen>:

uint
strlen(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e422                	sd	s0,8(sp)
 1ea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ec:	00054783          	lbu	a5,0(a0)
 1f0:	cf91                	beqz	a5,20c <strlen+0x26>
 1f2:	0505                	addi	a0,a0,1
 1f4:	87aa                	mv	a5,a0
 1f6:	4685                	li	a3,1
 1f8:	9e89                	subw	a3,a3,a0
 1fa:	00f6853b          	addw	a0,a3,a5
 1fe:	0785                	addi	a5,a5,1
 200:	fff7c703          	lbu	a4,-1(a5)
 204:	fb7d                	bnez	a4,1fa <strlen+0x14>
    ;
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  for(n = 0; s[n]; n++)
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <strlen+0x20>

0000000000000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 216:	ca19                	beqz	a2,22c <memset+0x1c>
 218:	87aa                	mv	a5,a0
 21a:	1602                	slli	a2,a2,0x20
 21c:	9201                	srli	a2,a2,0x20
 21e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 222:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 226:	0785                	addi	a5,a5,1
 228:	fee79de3          	bne	a5,a4,222 <memset+0x12>
  }
  return dst;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strchr>:

char*
strchr(const char *s, char c)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  for(; *s; s++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cb99                	beqz	a5,252 <strchr+0x20>
    if(*s == c)
 23e:	00f58763          	beq	a1,a5,24c <strchr+0x1a>
  for(; *s; s++)
 242:	0505                	addi	a0,a0,1
 244:	00054783          	lbu	a5,0(a0)
 248:	fbfd                	bnez	a5,23e <strchr+0xc>
      return (char*)s;
  return 0;
 24a:	4501                	li	a0,0
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  return 0;
 252:	4501                	li	a0,0
 254:	bfe5                	j	24c <strchr+0x1a>

0000000000000256 <gets>:

char*
gets(char *buf, int max)
{
 256:	711d                	addi	sp,sp,-96
 258:	ec86                	sd	ra,88(sp)
 25a:	e8a2                	sd	s0,80(sp)
 25c:	e4a6                	sd	s1,72(sp)
 25e:	e0ca                	sd	s2,64(sp)
 260:	fc4e                	sd	s3,56(sp)
 262:	f852                	sd	s4,48(sp)
 264:	f456                	sd	s5,40(sp)
 266:	f05a                	sd	s6,32(sp)
 268:	ec5e                	sd	s7,24(sp)
 26a:	1080                	addi	s0,sp,96
 26c:	8baa                	mv	s7,a0
 26e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 270:	892a                	mv	s2,a0
 272:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 274:	4aa9                	li	s5,10
 276:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	2485                	addiw	s1,s1,1
 27c:	0344d863          	bge	s1,s4,2ac <gets+0x56>
    cc = read(0, &c, 1);
 280:	4605                	li	a2,1
 282:	faf40593          	addi	a1,s0,-81
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	19c080e7          	jalr	412(ra) # 424 <read>
    if(cc < 1)
 290:	00a05e63          	blez	a0,2ac <gets+0x56>
    buf[i++] = c;
 294:	faf44783          	lbu	a5,-81(s0)
 298:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29c:	01578763          	beq	a5,s5,2aa <gets+0x54>
 2a0:	0905                	addi	s2,s2,1
 2a2:	fd679be3          	bne	a5,s6,278 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a6:	89a6                	mv	s3,s1
 2a8:	a011                	j	2ac <gets+0x56>
 2aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ac:	99de                	add	s3,s3,s7
 2ae:	00098023          	sb	zero,0(s3) # 18000 <base+0x16ff0>
  return buf;
}
 2b2:	855e                	mv	a0,s7
 2b4:	60e6                	ld	ra,88(sp)
 2b6:	6446                	ld	s0,80(sp)
 2b8:	64a6                	ld	s1,72(sp)
 2ba:	6906                	ld	s2,64(sp)
 2bc:	79e2                	ld	s3,56(sp)
 2be:	7a42                	ld	s4,48(sp)
 2c0:	7aa2                	ld	s5,40(sp)
 2c2:	7b02                	ld	s6,32(sp)
 2c4:	6be2                	ld	s7,24(sp)
 2c6:	6125                	addi	sp,sp,96
 2c8:	8082                	ret

00000000000002ca <stat>:

int
stat(const char *n, struct stat *st)
{
 2ca:	1101                	addi	sp,sp,-32
 2cc:	ec06                	sd	ra,24(sp)
 2ce:	e822                	sd	s0,16(sp)
 2d0:	e426                	sd	s1,8(sp)
 2d2:	e04a                	sd	s2,0(sp)
 2d4:	1000                	addi	s0,sp,32
 2d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	4581                	li	a1,0
 2da:	00000097          	auipc	ra,0x0
 2de:	172080e7          	jalr	370(ra) # 44c <open>
  if(fd < 0)
 2e2:	02054563          	bltz	a0,30c <stat+0x42>
 2e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e8:	85ca                	mv	a1,s2
 2ea:	00000097          	auipc	ra,0x0
 2ee:	17a080e7          	jalr	378(ra) # 464 <fstat>
 2f2:	892a                	mv	s2,a0
  close(fd);
 2f4:	8526                	mv	a0,s1
 2f6:	00000097          	auipc	ra,0x0
 2fa:	13e080e7          	jalr	318(ra) # 434 <close>
  return r;
}
 2fe:	854a                	mv	a0,s2
 300:	60e2                	ld	ra,24(sp)
 302:	6442                	ld	s0,16(sp)
 304:	64a2                	ld	s1,8(sp)
 306:	6902                	ld	s2,0(sp)
 308:	6105                	addi	sp,sp,32
 30a:	8082                	ret
    return -1;
 30c:	597d                	li	s2,-1
 30e:	bfc5                	j	2fe <stat+0x34>

0000000000000310 <atoi>:

int
atoi(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 316:	00054603          	lbu	a2,0(a0)
 31a:	fd06079b          	addiw	a5,a2,-48
 31e:	0ff7f793          	andi	a5,a5,255
 322:	4725                	li	a4,9
 324:	02f76963          	bltu	a4,a5,356 <atoi+0x46>
 328:	86aa                	mv	a3,a0
  n = 0;
 32a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 32c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 32e:	0685                	addi	a3,a3,1
 330:	0025179b          	slliw	a5,a0,0x2
 334:	9fa9                	addw	a5,a5,a0
 336:	0017979b          	slliw	a5,a5,0x1
 33a:	9fb1                	addw	a5,a5,a2
 33c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 340:	0006c603          	lbu	a2,0(a3)
 344:	fd06071b          	addiw	a4,a2,-48
 348:	0ff77713          	andi	a4,a4,255
 34c:	fee5f1e3          	bgeu	a1,a4,32e <atoi+0x1e>
  return n;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  n = 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <atoi+0x40>

000000000000035a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 360:	02b57463          	bgeu	a0,a1,388 <memmove+0x2e>
    while(n-- > 0)
 364:	00c05f63          	blez	a2,382 <memmove+0x28>
 368:	1602                	slli	a2,a2,0x20
 36a:	9201                	srli	a2,a2,0x20
 36c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 370:	872a                	mv	a4,a0
      *dst++ = *src++;
 372:	0585                	addi	a1,a1,1
 374:	0705                	addi	a4,a4,1
 376:	fff5c683          	lbu	a3,-1(a1)
 37a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 37e:	fee79ae3          	bne	a5,a4,372 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret
    dst += n;
 388:	00c50733          	add	a4,a0,a2
    src += n;
 38c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 38e:	fec05ae3          	blez	a2,382 <memmove+0x28>
 392:	fff6079b          	addiw	a5,a2,-1
 396:	1782                	slli	a5,a5,0x20
 398:	9381                	srli	a5,a5,0x20
 39a:	fff7c793          	not	a5,a5
 39e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a0:	15fd                	addi	a1,a1,-1
 3a2:	177d                	addi	a4,a4,-1
 3a4:	0005c683          	lbu	a3,0(a1)
 3a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ac:	fee79ae3          	bne	a5,a4,3a0 <memmove+0x46>
 3b0:	bfc9                	j	382 <memmove+0x28>

00000000000003b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3b8:	ca05                	beqz	a2,3e8 <memcmp+0x36>
 3ba:	fff6069b          	addiw	a3,a2,-1
 3be:	1682                	slli	a3,a3,0x20
 3c0:	9281                	srli	a3,a3,0x20
 3c2:	0685                	addi	a3,a3,1
 3c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	0005c703          	lbu	a4,0(a1)
 3ce:	00e79863          	bne	a5,a4,3de <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d2:	0505                	addi	a0,a0,1
    p2++;
 3d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d6:	fed518e3          	bne	a0,a3,3c6 <memcmp+0x14>
  }
  return 0;
 3da:	4501                	li	a0,0
 3dc:	a019                	j	3e2 <memcmp+0x30>
      return *p1 - *p2;
 3de:	40e7853b          	subw	a0,a5,a4
}
 3e2:	6422                	ld	s0,8(sp)
 3e4:	0141                	addi	sp,sp,16
 3e6:	8082                	ret
  return 0;
 3e8:	4501                	li	a0,0
 3ea:	bfe5                	j	3e2 <memcmp+0x30>

00000000000003ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e406                	sd	ra,8(sp)
 3f0:	e022                	sd	s0,0(sp)
 3f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f4:	00000097          	auipc	ra,0x0
 3f8:	f66080e7          	jalr	-154(ra) # 35a <memmove>
}
 3fc:	60a2                	ld	ra,8(sp)
 3fe:	6402                	ld	s0,0(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret

0000000000000404 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 404:	4885                	li	a7,1
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <exit>:
.global exit
exit:
 li a7, SYS_exit
 40c:	4889                	li	a7,2
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <wait>:
.global wait
wait:
 li a7, SYS_wait
 414:	488d                	li	a7,3
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 41c:	4891                	li	a7,4
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <read>:
.global read
read:
 li a7, SYS_read
 424:	4895                	li	a7,5
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <write>:
.global write
write:
 li a7, SYS_write
 42c:	48c1                	li	a7,16
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <close>:
.global close
close:
 li a7, SYS_close
 434:	48d5                	li	a7,21
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <kill>:
.global kill
kill:
 li a7, SYS_kill
 43c:	4899                	li	a7,6
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exec>:
.global exec
exec:
 li a7, SYS_exec
 444:	489d                	li	a7,7
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <open>:
.global open
open:
 li a7, SYS_open
 44c:	48bd                	li	a7,15
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 454:	48c5                	li	a7,17
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 45c:	48c9                	li	a7,18
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 464:	48a1                	li	a7,8
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <link>:
.global link
link:
 li a7, SYS_link
 46c:	48cd                	li	a7,19
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 474:	48d1                	li	a7,20
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 47c:	48a5                	li	a7,9
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <dup>:
.global dup
dup:
 li a7, SYS_dup
 484:	48a9                	li	a7,10
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 48c:	48ad                	li	a7,11
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 494:	48b1                	li	a7,12
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 49c:	48b5                	li	a7,13
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a4:	48b9                	li	a7,14
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 4ac:	48d9                	li	a7,22
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 4b4:	48dd                	li	a7,23
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 4bc:	48e1                	li	a7,24
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 4c4:	48e5                	li	a7,25
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 4cc:	48e9                	li	a7,26
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4d4:	1101                	addi	sp,sp,-32
 4d6:	ec06                	sd	ra,24(sp)
 4d8:	e822                	sd	s0,16(sp)
 4da:	1000                	addi	s0,sp,32
 4dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e0:	4605                	li	a2,1
 4e2:	fef40593          	addi	a1,s0,-17
 4e6:	00000097          	auipc	ra,0x0
 4ea:	f46080e7          	jalr	-186(ra) # 42c <write>
}
 4ee:	60e2                	ld	ra,24(sp)
 4f0:	6442                	ld	s0,16(sp)
 4f2:	6105                	addi	sp,sp,32
 4f4:	8082                	ret

00000000000004f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f6:	7139                	addi	sp,sp,-64
 4f8:	fc06                	sd	ra,56(sp)
 4fa:	f822                	sd	s0,48(sp)
 4fc:	f426                	sd	s1,40(sp)
 4fe:	f04a                	sd	s2,32(sp)
 500:	ec4e                	sd	s3,24(sp)
 502:	0080                	addi	s0,sp,64
 504:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 506:	c299                	beqz	a3,50c <printint+0x16>
 508:	0805c863          	bltz	a1,598 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 50c:	2581                	sext.w	a1,a1
  neg = 0;
 50e:	4881                	li	a7,0
 510:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 514:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 516:	2601                	sext.w	a2,a2
 518:	00000517          	auipc	a0,0x0
 51c:	4b050513          	addi	a0,a0,1200 # 9c8 <digits>
 520:	883a                	mv	a6,a4
 522:	2705                	addiw	a4,a4,1
 524:	02c5f7bb          	remuw	a5,a1,a2
 528:	1782                	slli	a5,a5,0x20
 52a:	9381                	srli	a5,a5,0x20
 52c:	97aa                	add	a5,a5,a0
 52e:	0007c783          	lbu	a5,0(a5)
 532:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 536:	0005879b          	sext.w	a5,a1
 53a:	02c5d5bb          	divuw	a1,a1,a2
 53e:	0685                	addi	a3,a3,1
 540:	fec7f0e3          	bgeu	a5,a2,520 <printint+0x2a>
  if(neg)
 544:	00088b63          	beqz	a7,55a <printint+0x64>
    buf[i++] = '-';
 548:	fd040793          	addi	a5,s0,-48
 54c:	973e                	add	a4,a4,a5
 54e:	02d00793          	li	a5,45
 552:	fef70823          	sb	a5,-16(a4)
 556:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 55a:	02e05863          	blez	a4,58a <printint+0x94>
 55e:	fc040793          	addi	a5,s0,-64
 562:	00e78933          	add	s2,a5,a4
 566:	fff78993          	addi	s3,a5,-1
 56a:	99ba                	add	s3,s3,a4
 56c:	377d                	addiw	a4,a4,-1
 56e:	1702                	slli	a4,a4,0x20
 570:	9301                	srli	a4,a4,0x20
 572:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 576:	fff94583          	lbu	a1,-1(s2)
 57a:	8526                	mv	a0,s1
 57c:	00000097          	auipc	ra,0x0
 580:	f58080e7          	jalr	-168(ra) # 4d4 <putc>
  while(--i >= 0)
 584:	197d                	addi	s2,s2,-1
 586:	ff3918e3          	bne	s2,s3,576 <printint+0x80>
}
 58a:	70e2                	ld	ra,56(sp)
 58c:	7442                	ld	s0,48(sp)
 58e:	74a2                	ld	s1,40(sp)
 590:	7902                	ld	s2,32(sp)
 592:	69e2                	ld	s3,24(sp)
 594:	6121                	addi	sp,sp,64
 596:	8082                	ret
    x = -xx;
 598:	40b005bb          	negw	a1,a1
    neg = 1;
 59c:	4885                	li	a7,1
    x = -xx;
 59e:	bf8d                	j	510 <printint+0x1a>

00000000000005a0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a0:	7119                	addi	sp,sp,-128
 5a2:	fc86                	sd	ra,120(sp)
 5a4:	f8a2                	sd	s0,112(sp)
 5a6:	f4a6                	sd	s1,104(sp)
 5a8:	f0ca                	sd	s2,96(sp)
 5aa:	ecce                	sd	s3,88(sp)
 5ac:	e8d2                	sd	s4,80(sp)
 5ae:	e4d6                	sd	s5,72(sp)
 5b0:	e0da                	sd	s6,64(sp)
 5b2:	fc5e                	sd	s7,56(sp)
 5b4:	f862                	sd	s8,48(sp)
 5b6:	f466                	sd	s9,40(sp)
 5b8:	f06a                	sd	s10,32(sp)
 5ba:	ec6e                	sd	s11,24(sp)
 5bc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5be:	0005c903          	lbu	s2,0(a1)
 5c2:	18090f63          	beqz	s2,760 <vprintf+0x1c0>
 5c6:	8aaa                	mv	s5,a0
 5c8:	8b32                	mv	s6,a2
 5ca:	00158493          	addi	s1,a1,1
  state = 0;
 5ce:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5d0:	02500a13          	li	s4,37
      if(c == 'd'){
 5d4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5d8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5dc:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5e0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5e4:	00000b97          	auipc	s7,0x0
 5e8:	3e4b8b93          	addi	s7,s7,996 # 9c8 <digits>
 5ec:	a839                	j	60a <vprintf+0x6a>
        putc(fd, c);
 5ee:	85ca                	mv	a1,s2
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	ee2080e7          	jalr	-286(ra) # 4d4 <putc>
 5fa:	a019                	j	600 <vprintf+0x60>
    } else if(state == '%'){
 5fc:	01498f63          	beq	s3,s4,61a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 600:	0485                	addi	s1,s1,1
 602:	fff4c903          	lbu	s2,-1(s1)
 606:	14090d63          	beqz	s2,760 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 60a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 60e:	fe0997e3          	bnez	s3,5fc <vprintf+0x5c>
      if(c == '%'){
 612:	fd479ee3          	bne	a5,s4,5ee <vprintf+0x4e>
        state = '%';
 616:	89be                	mv	s3,a5
 618:	b7e5                	j	600 <vprintf+0x60>
      if(c == 'd'){
 61a:	05878063          	beq	a5,s8,65a <vprintf+0xba>
      } else if(c == 'l') {
 61e:	05978c63          	beq	a5,s9,676 <vprintf+0xd6>
      } else if(c == 'x') {
 622:	07a78863          	beq	a5,s10,692 <vprintf+0xf2>
      } else if(c == 'p') {
 626:	09b78463          	beq	a5,s11,6ae <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 62a:	07300713          	li	a4,115
 62e:	0ce78663          	beq	a5,a4,6fa <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 632:	06300713          	li	a4,99
 636:	0ee78e63          	beq	a5,a4,732 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 63a:	11478863          	beq	a5,s4,74a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63e:	85d2                	mv	a1,s4
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e92080e7          	jalr	-366(ra) # 4d4 <putc>
        putc(fd, c);
 64a:	85ca                	mv	a1,s2
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e86080e7          	jalr	-378(ra) # 4d4 <putc>
      }
      state = 0;
 656:	4981                	li	s3,0
 658:	b765                	j	600 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 65a:	008b0913          	addi	s2,s6,8
 65e:	4685                	li	a3,1
 660:	4629                	li	a2,10
 662:	000b2583          	lw	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e8e080e7          	jalr	-370(ra) # 4f6 <printint>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	b771                	j	600 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b0913          	addi	s2,s6,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000b2583          	lw	a1,0(s6)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e72080e7          	jalr	-398(ra) # 4f6 <printint>
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bf85                	j	600 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 692:	008b0913          	addi	s2,s6,8
 696:	4681                	li	a3,0
 698:	4641                	li	a2,16
 69a:	000b2583          	lw	a1,0(s6)
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	e56080e7          	jalr	-426(ra) # 4f6 <printint>
 6a8:	8b4a                	mv	s6,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bf91                	j	600 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6ae:	008b0793          	addi	a5,s6,8
 6b2:	f8f43423          	sd	a5,-120(s0)
 6b6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6ba:	03000593          	li	a1,48
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e14080e7          	jalr	-492(ra) # 4d4 <putc>
  putc(fd, 'x');
 6c8:	85ea                	mv	a1,s10
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	e08080e7          	jalr	-504(ra) # 4d4 <putc>
 6d4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d6:	03c9d793          	srli	a5,s3,0x3c
 6da:	97de                	add	a5,a5,s7
 6dc:	0007c583          	lbu	a1,0(a5)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	df2080e7          	jalr	-526(ra) # 4d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ea:	0992                	slli	s3,s3,0x4
 6ec:	397d                	addiw	s2,s2,-1
 6ee:	fe0914e3          	bnez	s2,6d6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6f2:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b721                	j	600 <vprintf+0x60>
        s = va_arg(ap, char*);
 6fa:	008b0993          	addi	s3,s6,8
 6fe:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 702:	02090163          	beqz	s2,724 <vprintf+0x184>
        while(*s != 0){
 706:	00094583          	lbu	a1,0(s2)
 70a:	c9a1                	beqz	a1,75a <vprintf+0x1ba>
          putc(fd, *s);
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	dc6080e7          	jalr	-570(ra) # 4d4 <putc>
          s++;
 716:	0905                	addi	s2,s2,1
        while(*s != 0){
 718:	00094583          	lbu	a1,0(s2)
 71c:	f9e5                	bnez	a1,70c <vprintf+0x16c>
        s = va_arg(ap, char*);
 71e:	8b4e                	mv	s6,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	bdf9                	j	600 <vprintf+0x60>
          s = "(null)";
 724:	00000917          	auipc	s2,0x0
 728:	29c90913          	addi	s2,s2,668 # 9c0 <malloc+0x156>
        while(*s != 0){
 72c:	02800593          	li	a1,40
 730:	bff1                	j	70c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 732:	008b0913          	addi	s2,s6,8
 736:	000b4583          	lbu	a1,0(s6)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	d98080e7          	jalr	-616(ra) # 4d4 <putc>
 744:	8b4a                	mv	s6,s2
      state = 0;
 746:	4981                	li	s3,0
 748:	bd65                	j	600 <vprintf+0x60>
        putc(fd, c);
 74a:	85d2                	mv	a1,s4
 74c:	8556                	mv	a0,s5
 74e:	00000097          	auipc	ra,0x0
 752:	d86080e7          	jalr	-634(ra) # 4d4 <putc>
      state = 0;
 756:	4981                	li	s3,0
 758:	b565                	j	600 <vprintf+0x60>
        s = va_arg(ap, char*);
 75a:	8b4e                	mv	s6,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b54d                	j	600 <vprintf+0x60>
    }
  }
}
 760:	70e6                	ld	ra,120(sp)
 762:	7446                	ld	s0,112(sp)
 764:	74a6                	ld	s1,104(sp)
 766:	7906                	ld	s2,96(sp)
 768:	69e6                	ld	s3,88(sp)
 76a:	6a46                	ld	s4,80(sp)
 76c:	6aa6                	ld	s5,72(sp)
 76e:	6b06                	ld	s6,64(sp)
 770:	7be2                	ld	s7,56(sp)
 772:	7c42                	ld	s8,48(sp)
 774:	7ca2                	ld	s9,40(sp)
 776:	7d02                	ld	s10,32(sp)
 778:	6de2                	ld	s11,24(sp)
 77a:	6109                	addi	sp,sp,128
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79a:	8622                	mv	a2,s0
 79c:	00000097          	auipc	ra,0x0
 7a0:	e04080e7          	jalr	-508(ra) # 5a0 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	00000097          	auipc	ra,0x0
 7d6:	dce080e7          	jalr	-562(ra) # 5a0 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e422                	sd	s0,8(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	8147b783          	ld	a5,-2028(a5) # 1000 <freep>
 7f4:	a805                	j	824 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f6:	4618                	lw	a4,8(a2)
 7f8:	9db9                	addw	a1,a1,a4
 7fa:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	6398                	ld	a4,0(a5)
 800:	6318                	ld	a4,0(a4)
 802:	fee53823          	sd	a4,-16(a0)
 806:	a091                	j	84a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9e39                	addw	a2,a2,a4
 80e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053703          	ld	a4,-16(a0)
 814:	e398                	sd	a4,0(a5)
 816:	a099                	j	85c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	6398                	ld	a4,0(a5)
 81a:	00e7e463          	bltu	a5,a4,822 <free+0x40>
 81e:	00e6ea63          	bltu	a3,a4,832 <free+0x50>
{
 822:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 824:	fed7fae3          	bgeu	a5,a3,818 <free+0x36>
 828:	6398                	ld	a4,0(a5)
 82a:	00e6e463          	bltu	a3,a4,832 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82e:	fee7eae3          	bltu	a5,a4,822 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 832:	ff852583          	lw	a1,-8(a0)
 836:	6390                	ld	a2,0(a5)
 838:	02059713          	slli	a4,a1,0x20
 83c:	9301                	srli	a4,a4,0x20
 83e:	0712                	slli	a4,a4,0x4
 840:	9736                	add	a4,a4,a3
 842:	fae60ae3          	beq	a2,a4,7f6 <free+0x14>
    bp->s.ptr = p->s.ptr;
 846:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84a:	4790                	lw	a2,8(a5)
 84c:	02061713          	slli	a4,a2,0x20
 850:	9301                	srli	a4,a4,0x20
 852:	0712                	slli	a4,a4,0x4
 854:	973e                	add	a4,a4,a5
 856:	fae689e3          	beq	a3,a4,808 <free+0x26>
  } else
    p->s.ptr = bp;
 85a:	e394                	sd	a3,0(a5)
  freep = p;
 85c:	00000717          	auipc	a4,0x0
 860:	7af73223          	sd	a5,1956(a4) # 1000 <freep>
}
 864:	6422                	ld	s0,8(sp)
 866:	0141                	addi	sp,sp,16
 868:	8082                	ret

000000000000086a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86a:	7139                	addi	sp,sp,-64
 86c:	fc06                	sd	ra,56(sp)
 86e:	f822                	sd	s0,48(sp)
 870:	f426                	sd	s1,40(sp)
 872:	f04a                	sd	s2,32(sp)
 874:	ec4e                	sd	s3,24(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
 87c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87e:	02051493          	slli	s1,a0,0x20
 882:	9081                	srli	s1,s1,0x20
 884:	04bd                	addi	s1,s1,15
 886:	8091                	srli	s1,s1,0x4
 888:	0014899b          	addiw	s3,s1,1
 88c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 88e:	00000517          	auipc	a0,0x0
 892:	77253503          	ld	a0,1906(a0) # 1000 <freep>
 896:	c515                	beqz	a0,8c2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	02977f63          	bgeu	a4,s1,8da <malloc+0x70>
 8a0:	8a4e                	mv	s4,s3
 8a2:	0009871b          	sext.w	a4,s3
 8a6:	6685                	lui	a3,0x1
 8a8:	00d77363          	bgeu	a4,a3,8ae <malloc+0x44>
 8ac:	6a05                	lui	s4,0x1
 8ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b6:	00000917          	auipc	s2,0x0
 8ba:	74a90913          	addi	s2,s2,1866 # 1000 <freep>
  if(p == (char*)-1)
 8be:	5afd                	li	s5,-1
 8c0:	a88d                	j	932 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8c2:	00000797          	auipc	a5,0x0
 8c6:	74e78793          	addi	a5,a5,1870 # 1010 <base>
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
 8d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d8:	b7e1                	j	8a0 <malloc+0x36>
      if(p->s.size == nunits)
 8da:	02e48b63          	beq	s1,a4,910 <malloc+0xa6>
        p->s.size -= nunits;
 8de:	4137073b          	subw	a4,a4,s3
 8e2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e4:	1702                	slli	a4,a4,0x20
 8e6:	9301                	srli	a4,a4,0x20
 8e8:	0712                	slli	a4,a4,0x4
 8ea:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ec:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70a73823          	sd	a0,1808(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f8:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8fc:	70e2                	ld	ra,56(sp)
 8fe:	7442                	ld	s0,48(sp)
 900:	74a2                	ld	s1,40(sp)
 902:	7902                	ld	s2,32(sp)
 904:	69e2                	ld	s3,24(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 910:	6398                	ld	a4,0(a5)
 912:	e118                	sd	a4,0(a0)
 914:	bff1                	j	8f0 <malloc+0x86>
  hp->s.size = nu;
 916:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91a:	0541                	addi	a0,a0,16
 91c:	00000097          	auipc	ra,0x0
 920:	ec6080e7          	jalr	-314(ra) # 7e2 <free>
  return freep;
 924:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 928:	d971                	beqz	a0,8fc <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92c:	4798                	lw	a4,8(a5)
 92e:	fa9776e3          	bgeu	a4,s1,8da <malloc+0x70>
    if(p == freep)
 932:	00093703          	ld	a4,0(s2)
 936:	853e                	mv	a0,a5
 938:	fef719e3          	bne	a4,a5,92a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 93c:	8552                	mv	a0,s4
 93e:	00000097          	auipc	ra,0x0
 942:	b56080e7          	jalr	-1194(ra) # 494 <sbrk>
  if(p == (char*)-1)
 946:	fd5518e3          	bne	a0,s5,916 <malloc+0xac>
        return 0;
 94a:	4501                	li	a0,0
 94c:	bf45                	j	8fc <malloc+0x92>
