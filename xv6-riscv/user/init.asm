
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8d250513          	addi	a0,a0,-1838 # 8e0 <malloc+0xe8>
  16:	00000097          	auipc	ra,0x0
  1a:	3cc080e7          	jalr	972(ra) # 3e2 <open>
  1e:	06054863          	bltz	a0,8e <main+0x8e>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3f6080e7          	jalr	1014(ra) # 41a <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3ec080e7          	jalr	1004(ra) # 41a <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	8b290913          	addi	s2,s2,-1870 # 8e8 <malloc+0xf0>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6fa080e7          	jalr	1786(ra) # 73a <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	352080e7          	jalr	850(ra) # 39a <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	06054263          	bltz	a0,b6 <main+0xb6>
      printf("init: fork failed\n");
      exit(1,"");
    }
    if(pid == 0){
  56:	c149                	beqz	a0,d8 <main+0xd8>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0, 0);
  58:	4581                	li	a1,0
  5a:	4501                	li	a0,0
  5c:	00000097          	auipc	ra,0x0
  60:	34e080e7          	jalr	846(ra) # 3aa <wait>
      if(wpid == pid){
  64:	fca48de3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  68:	fe0558e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6c:	00001517          	auipc	a0,0x1
  70:	8d450513          	addi	a0,a0,-1836 # 940 <malloc+0x148>
  74:	00000097          	auipc	ra,0x0
  78:	6c6080e7          	jalr	1734(ra) # 73a <printf>
        exit(1,"");
  7c:	00001597          	auipc	a1,0x1
  80:	89c58593          	addi	a1,a1,-1892 # 918 <malloc+0x120>
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	31c080e7          	jalr	796(ra) # 3a2 <exit>
    mknod("console", CONSOLE, 0);
  8e:	4601                	li	a2,0
  90:	4585                	li	a1,1
  92:	00001517          	auipc	a0,0x1
  96:	84e50513          	addi	a0,a0,-1970 # 8e0 <malloc+0xe8>
  9a:	00000097          	auipc	ra,0x0
  9e:	350080e7          	jalr	848(ra) # 3ea <mknod>
    open("console", O_RDWR);
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	83c50513          	addi	a0,a0,-1988 # 8e0 <malloc+0xe8>
  ac:	00000097          	auipc	ra,0x0
  b0:	336080e7          	jalr	822(ra) # 3e2 <open>
  b4:	b7bd                	j	22 <main+0x22>
      printf("init: fork failed\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	84a50513          	addi	a0,a0,-1974 # 900 <malloc+0x108>
  be:	00000097          	auipc	ra,0x0
  c2:	67c080e7          	jalr	1660(ra) # 73a <printf>
      exit(1,"");
  c6:	00001597          	auipc	a1,0x1
  ca:	85258593          	addi	a1,a1,-1966 # 918 <malloc+0x120>
  ce:	4505                	li	a0,1
  d0:	00000097          	auipc	ra,0x0
  d4:	2d2080e7          	jalr	722(ra) # 3a2 <exit>
      exec("sh", argv);
  d8:	00001597          	auipc	a1,0x1
  dc:	f2858593          	addi	a1,a1,-216 # 1000 <argv>
  e0:	00001517          	auipc	a0,0x1
  e4:	84050513          	addi	a0,a0,-1984 # 920 <malloc+0x128>
  e8:	00000097          	auipc	ra,0x0
  ec:	2f2080e7          	jalr	754(ra) # 3da <exec>
      printf("init: exec sh failed\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	83850513          	addi	a0,a0,-1992 # 928 <malloc+0x130>
  f8:	00000097          	auipc	ra,0x0
  fc:	642080e7          	jalr	1602(ra) # 73a <printf>
      exit(1,"");
 100:	00001597          	auipc	a1,0x1
 104:	81858593          	addi	a1,a1,-2024 # 918 <malloc+0x120>
 108:	4505                	li	a0,1
 10a:	00000097          	auipc	ra,0x0
 10e:	298080e7          	jalr	664(ra) # 3a2 <exit>

0000000000000112 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  extern int main();
  main();
 11a:	00000097          	auipc	ra,0x0
 11e:	ee6080e7          	jalr	-282(ra) # 0 <main>
  exit(0,"");
 122:	00000597          	auipc	a1,0x0
 126:	7f658593          	addi	a1,a1,2038 # 918 <malloc+0x120>
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	276080e7          	jalr	630(ra) # 3a2 <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x1e>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x1e>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strlen>:

uint
strlen(const char *s)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x26>
 188:	0505                	addi	a0,a0,1
 18a:	87aa                	mv	a5,a0
 18c:	4685                	li	a3,1
 18e:	9e89                	subw	a3,a3,a0
 190:	00f6853b          	addw	a0,a3,a5
 194:	0785                	addi	a5,a5,1
 196:	fff7c703          	lbu	a4,-1(a5)
 19a:	fb7d                	bnez	a4,190 <strlen+0x14>
    ;
  return n;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ca19                	beqz	a2,1c2 <memset+0x1c>
 1ae:	87aa                	mv	a5,a0
 1b0:	1602                	slli	a2,a2,0x20
 1b2:	9201                	srli	a2,a2,0x20
 1b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1bc:	0785                	addi	a5,a5,1
 1be:	fee79de3          	bne	a5,a4,1b8 <memset+0x12>
  }
  return dst;
}
 1c2:	6422                	ld	s0,8(sp)
 1c4:	0141                	addi	sp,sp,16
 1c6:	8082                	ret

00000000000001c8 <strchr>:

char*
strchr(const char *s, char c)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	cb99                	beqz	a5,1e8 <strchr+0x20>
    if(*s == c)
 1d4:	00f58763          	beq	a1,a5,1e2 <strchr+0x1a>
  for(; *s; s++)
 1d8:	0505                	addi	a0,a0,1
 1da:	00054783          	lbu	a5,0(a0)
 1de:	fbfd                	bnez	a5,1d4 <strchr+0xc>
      return (char*)s;
  return 0;
 1e0:	4501                	li	a0,0
}
 1e2:	6422                	ld	s0,8(sp)
 1e4:	0141                	addi	sp,sp,16
 1e6:	8082                	ret
  return 0;
 1e8:	4501                	li	a0,0
 1ea:	bfe5                	j	1e2 <strchr+0x1a>

00000000000001ec <gets>:

char*
gets(char *buf, int max)
{
 1ec:	711d                	addi	sp,sp,-96
 1ee:	ec86                	sd	ra,88(sp)
 1f0:	e8a2                	sd	s0,80(sp)
 1f2:	e4a6                	sd	s1,72(sp)
 1f4:	e0ca                	sd	s2,64(sp)
 1f6:	fc4e                	sd	s3,56(sp)
 1f8:	f852                	sd	s4,48(sp)
 1fa:	f456                	sd	s5,40(sp)
 1fc:	f05a                	sd	s6,32(sp)
 1fe:	ec5e                	sd	s7,24(sp)
 200:	1080                	addi	s0,sp,96
 202:	8baa                	mv	s7,a0
 204:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	892a                	mv	s2,a0
 208:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20a:	4aa9                	li	s5,10
 20c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20e:	89a6                	mv	s3,s1
 210:	2485                	addiw	s1,s1,1
 212:	0344d863          	bge	s1,s4,242 <gets+0x56>
    cc = read(0, &c, 1);
 216:	4605                	li	a2,1
 218:	faf40593          	addi	a1,s0,-81
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	19c080e7          	jalr	412(ra) # 3ba <read>
    if(cc < 1)
 226:	00a05e63          	blez	a0,242 <gets+0x56>
    buf[i++] = c;
 22a:	faf44783          	lbu	a5,-81(s0)
 22e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 232:	01578763          	beq	a5,s5,240 <gets+0x54>
 236:	0905                	addi	s2,s2,1
 238:	fd679be3          	bne	a5,s6,20e <gets+0x22>
  for(i=0; i+1 < max; ){
 23c:	89a6                	mv	s3,s1
 23e:	a011                	j	242 <gets+0x56>
 240:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 242:	99de                	add	s3,s3,s7
 244:	00098023          	sb	zero,0(s3)
  return buf;
}
 248:	855e                	mv	a0,s7
 24a:	60e6                	ld	ra,88(sp)
 24c:	6446                	ld	s0,80(sp)
 24e:	64a6                	ld	s1,72(sp)
 250:	6906                	ld	s2,64(sp)
 252:	79e2                	ld	s3,56(sp)
 254:	7a42                	ld	s4,48(sp)
 256:	7aa2                	ld	s5,40(sp)
 258:	7b02                	ld	s6,32(sp)
 25a:	6be2                	ld	s7,24(sp)
 25c:	6125                	addi	sp,sp,96
 25e:	8082                	ret

0000000000000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	1101                	addi	sp,sp,-32
 262:	ec06                	sd	ra,24(sp)
 264:	e822                	sd	s0,16(sp)
 266:	e426                	sd	s1,8(sp)
 268:	e04a                	sd	s2,0(sp)
 26a:	1000                	addi	s0,sp,32
 26c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26e:	4581                	li	a1,0
 270:	00000097          	auipc	ra,0x0
 274:	172080e7          	jalr	370(ra) # 3e2 <open>
  if(fd < 0)
 278:	02054563          	bltz	a0,2a2 <stat+0x42>
 27c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27e:	85ca                	mv	a1,s2
 280:	00000097          	auipc	ra,0x0
 284:	17a080e7          	jalr	378(ra) # 3fa <fstat>
 288:	892a                	mv	s2,a0
  close(fd);
 28a:	8526                	mv	a0,s1
 28c:	00000097          	auipc	ra,0x0
 290:	13e080e7          	jalr	318(ra) # 3ca <close>
  return r;
}
 294:	854a                	mv	a0,s2
 296:	60e2                	ld	ra,24(sp)
 298:	6442                	ld	s0,16(sp)
 29a:	64a2                	ld	s1,8(sp)
 29c:	6902                	ld	s2,0(sp)
 29e:	6105                	addi	sp,sp,32
 2a0:	8082                	ret
    return -1;
 2a2:	597d                	li	s2,-1
 2a4:	bfc5                	j	294 <stat+0x34>

00000000000002a6 <atoi>:

int
atoi(const char *s)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ac:	00054603          	lbu	a2,0(a0)
 2b0:	fd06079b          	addiw	a5,a2,-48
 2b4:	0ff7f793          	andi	a5,a5,255
 2b8:	4725                	li	a4,9
 2ba:	02f76963          	bltu	a4,a5,2ec <atoi+0x46>
 2be:	86aa                	mv	a3,a0
  n = 0;
 2c0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2c2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2c4:	0685                	addi	a3,a3,1
 2c6:	0025179b          	slliw	a5,a0,0x2
 2ca:	9fa9                	addw	a5,a5,a0
 2cc:	0017979b          	slliw	a5,a5,0x1
 2d0:	9fb1                	addw	a5,a5,a2
 2d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d6:	0006c603          	lbu	a2,0(a3)
 2da:	fd06071b          	addiw	a4,a2,-48
 2de:	0ff77713          	andi	a4,a4,255
 2e2:	fee5f1e3          	bgeu	a1,a4,2c4 <atoi+0x1e>
  return n;
}
 2e6:	6422                	ld	s0,8(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  n = 0;
 2ec:	4501                	li	a0,0
 2ee:	bfe5                	j	2e6 <atoi+0x40>

00000000000002f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f6:	02b57463          	bgeu	a0,a1,31e <memmove+0x2e>
    while(n-- > 0)
 2fa:	00c05f63          	blez	a2,318 <memmove+0x28>
 2fe:	1602                	slli	a2,a2,0x20
 300:	9201                	srli	a2,a2,0x20
 302:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 306:	872a                	mv	a4,a0
      *dst++ = *src++;
 308:	0585                	addi	a1,a1,1
 30a:	0705                	addi	a4,a4,1
 30c:	fff5c683          	lbu	a3,-1(a1)
 310:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 314:	fee79ae3          	bne	a5,a4,308 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 318:	6422                	ld	s0,8(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
    dst += n;
 31e:	00c50733          	add	a4,a0,a2
    src += n;
 322:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 324:	fec05ae3          	blez	a2,318 <memmove+0x28>
 328:	fff6079b          	addiw	a5,a2,-1
 32c:	1782                	slli	a5,a5,0x20
 32e:	9381                	srli	a5,a5,0x20
 330:	fff7c793          	not	a5,a5
 334:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 336:	15fd                	addi	a1,a1,-1
 338:	177d                	addi	a4,a4,-1
 33a:	0005c683          	lbu	a3,0(a1)
 33e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 342:	fee79ae3          	bne	a5,a4,336 <memmove+0x46>
 346:	bfc9                	j	318 <memmove+0x28>

0000000000000348 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34e:	ca05                	beqz	a2,37e <memcmp+0x36>
 350:	fff6069b          	addiw	a3,a2,-1
 354:	1682                	slli	a3,a3,0x20
 356:	9281                	srli	a3,a3,0x20
 358:	0685                	addi	a3,a3,1
 35a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35c:	00054783          	lbu	a5,0(a0)
 360:	0005c703          	lbu	a4,0(a1)
 364:	00e79863          	bne	a5,a4,374 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 368:	0505                	addi	a0,a0,1
    p2++;
 36a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36c:	fed518e3          	bne	a0,a3,35c <memcmp+0x14>
  }
  return 0;
 370:	4501                	li	a0,0
 372:	a019                	j	378 <memcmp+0x30>
      return *p1 - *p2;
 374:	40e7853b          	subw	a0,a5,a4
}
 378:	6422                	ld	s0,8(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  return 0;
 37e:	4501                	li	a0,0
 380:	bfe5                	j	378 <memcmp+0x30>

0000000000000382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38a:	00000097          	auipc	ra,0x0
 38e:	f66080e7          	jalr	-154(ra) # 2f0 <memmove>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39a:	4885                	li	a7,1
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a2:	4889                	li	a7,2
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3aa:	488d                	li	a7,3
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b2:	4891                	li	a7,4
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <read>:
.global read
read:
 li a7, SYS_read
 3ba:	4895                	li	a7,5
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <write>:
.global write
write:
 li a7, SYS_write
 3c2:	48c1                	li	a7,16
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <close>:
.global close
close:
 li a7, SYS_close
 3ca:	48d5                	li	a7,21
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d2:	4899                	li	a7,6
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <exec>:
.global exec
exec:
 li a7, SYS_exec
 3da:	489d                	li	a7,7
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <open>:
.global open
open:
 li a7, SYS_open
 3e2:	48bd                	li	a7,15
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ea:	48c5                	li	a7,17
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f2:	48c9                	li	a7,18
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fa:	48a1                	li	a7,8
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <link>:
.global link
link:
 li a7, SYS_link
 402:	48cd                	li	a7,19
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40a:	48d1                	li	a7,20
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 412:	48a5                	li	a7,9
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <dup>:
.global dup
dup:
 li a7, SYS_dup
 41a:	48a9                	li	a7,10
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 422:	48ad                	li	a7,11
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42a:	48b1                	li	a7,12
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 432:	48b5                	li	a7,13
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43a:	48b9                	li	a7,14
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 442:	48d9                	li	a7,22
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 44a:	48dd                	li	a7,23
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 452:	48e1                	li	a7,24
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 45a:	48e5                	li	a7,25
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 462:	1101                	addi	sp,sp,-32
 464:	ec06                	sd	ra,24(sp)
 466:	e822                	sd	s0,16(sp)
 468:	1000                	addi	s0,sp,32
 46a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46e:	4605                	li	a2,1
 470:	fef40593          	addi	a1,s0,-17
 474:	00000097          	auipc	ra,0x0
 478:	f4e080e7          	jalr	-178(ra) # 3c2 <write>
}
 47c:	60e2                	ld	ra,24(sp)
 47e:	6442                	ld	s0,16(sp)
 480:	6105                	addi	sp,sp,32
 482:	8082                	ret

0000000000000484 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 484:	7139                	addi	sp,sp,-64
 486:	fc06                	sd	ra,56(sp)
 488:	f822                	sd	s0,48(sp)
 48a:	f426                	sd	s1,40(sp)
 48c:	f04a                	sd	s2,32(sp)
 48e:	ec4e                	sd	s3,24(sp)
 490:	0080                	addi	s0,sp,64
 492:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 494:	c299                	beqz	a3,49a <printint+0x16>
 496:	0805c863          	bltz	a1,526 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49a:	2581                	sext.w	a1,a1
  neg = 0;
 49c:	4881                	li	a7,0
 49e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a4:	2601                	sext.w	a2,a2
 4a6:	00000517          	auipc	a0,0x0
 4aa:	4c250513          	addi	a0,a0,1218 # 968 <digits>
 4ae:	883a                	mv	a6,a4
 4b0:	2705                	addiw	a4,a4,1
 4b2:	02c5f7bb          	remuw	a5,a1,a2
 4b6:	1782                	slli	a5,a5,0x20
 4b8:	9381                	srli	a5,a5,0x20
 4ba:	97aa                	add	a5,a5,a0
 4bc:	0007c783          	lbu	a5,0(a5)
 4c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c4:	0005879b          	sext.w	a5,a1
 4c8:	02c5d5bb          	divuw	a1,a1,a2
 4cc:	0685                	addi	a3,a3,1
 4ce:	fec7f0e3          	bgeu	a5,a2,4ae <printint+0x2a>
  if(neg)
 4d2:	00088b63          	beqz	a7,4e8 <printint+0x64>
    buf[i++] = '-';
 4d6:	fd040793          	addi	a5,s0,-48
 4da:	973e                	add	a4,a4,a5
 4dc:	02d00793          	li	a5,45
 4e0:	fef70823          	sb	a5,-16(a4)
 4e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e8:	02e05863          	blez	a4,518 <printint+0x94>
 4ec:	fc040793          	addi	a5,s0,-64
 4f0:	00e78933          	add	s2,a5,a4
 4f4:	fff78993          	addi	s3,a5,-1
 4f8:	99ba                	add	s3,s3,a4
 4fa:	377d                	addiw	a4,a4,-1
 4fc:	1702                	slli	a4,a4,0x20
 4fe:	9301                	srli	a4,a4,0x20
 500:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 504:	fff94583          	lbu	a1,-1(s2)
 508:	8526                	mv	a0,s1
 50a:	00000097          	auipc	ra,0x0
 50e:	f58080e7          	jalr	-168(ra) # 462 <putc>
  while(--i >= 0)
 512:	197d                	addi	s2,s2,-1
 514:	ff3918e3          	bne	s2,s3,504 <printint+0x80>
}
 518:	70e2                	ld	ra,56(sp)
 51a:	7442                	ld	s0,48(sp)
 51c:	74a2                	ld	s1,40(sp)
 51e:	7902                	ld	s2,32(sp)
 520:	69e2                	ld	s3,24(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret
    x = -xx;
 526:	40b005bb          	negw	a1,a1
    neg = 1;
 52a:	4885                	li	a7,1
    x = -xx;
 52c:	bf8d                	j	49e <printint+0x1a>

000000000000052e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52e:	7119                	addi	sp,sp,-128
 530:	fc86                	sd	ra,120(sp)
 532:	f8a2                	sd	s0,112(sp)
 534:	f4a6                	sd	s1,104(sp)
 536:	f0ca                	sd	s2,96(sp)
 538:	ecce                	sd	s3,88(sp)
 53a:	e8d2                	sd	s4,80(sp)
 53c:	e4d6                	sd	s5,72(sp)
 53e:	e0da                	sd	s6,64(sp)
 540:	fc5e                	sd	s7,56(sp)
 542:	f862                	sd	s8,48(sp)
 544:	f466                	sd	s9,40(sp)
 546:	f06a                	sd	s10,32(sp)
 548:	ec6e                	sd	s11,24(sp)
 54a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54c:	0005c903          	lbu	s2,0(a1)
 550:	18090f63          	beqz	s2,6ee <vprintf+0x1c0>
 554:	8aaa                	mv	s5,a0
 556:	8b32                	mv	s6,a2
 558:	00158493          	addi	s1,a1,1
  state = 0;
 55c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 55e:	02500a13          	li	s4,37
      if(c == 'd'){
 562:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 566:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 56a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 56e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 572:	00000b97          	auipc	s7,0x0
 576:	3f6b8b93          	addi	s7,s7,1014 # 968 <digits>
 57a:	a839                	j	598 <vprintf+0x6a>
        putc(fd, c);
 57c:	85ca                	mv	a1,s2
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	ee2080e7          	jalr	-286(ra) # 462 <putc>
 588:	a019                	j	58e <vprintf+0x60>
    } else if(state == '%'){
 58a:	01498f63          	beq	s3,s4,5a8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 58e:	0485                	addi	s1,s1,1
 590:	fff4c903          	lbu	s2,-1(s1)
 594:	14090d63          	beqz	s2,6ee <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 598:	0009079b          	sext.w	a5,s2
    if(state == 0){
 59c:	fe0997e3          	bnez	s3,58a <vprintf+0x5c>
      if(c == '%'){
 5a0:	fd479ee3          	bne	a5,s4,57c <vprintf+0x4e>
        state = '%';
 5a4:	89be                	mv	s3,a5
 5a6:	b7e5                	j	58e <vprintf+0x60>
      if(c == 'd'){
 5a8:	05878063          	beq	a5,s8,5e8 <vprintf+0xba>
      } else if(c == 'l') {
 5ac:	05978c63          	beq	a5,s9,604 <vprintf+0xd6>
      } else if(c == 'x') {
 5b0:	07a78863          	beq	a5,s10,620 <vprintf+0xf2>
      } else if(c == 'p') {
 5b4:	09b78463          	beq	a5,s11,63c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5b8:	07300713          	li	a4,115
 5bc:	0ce78663          	beq	a5,a4,688 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c0:	06300713          	li	a4,99
 5c4:	0ee78e63          	beq	a5,a4,6c0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5c8:	11478863          	beq	a5,s4,6d8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cc:	85d2                	mv	a1,s4
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e92080e7          	jalr	-366(ra) # 462 <putc>
        putc(fd, c);
 5d8:	85ca                	mv	a1,s2
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	e86080e7          	jalr	-378(ra) # 462 <putc>
      }
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b765                	j	58e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b0913          	addi	s2,s6,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000b2583          	lw	a1,0(s6)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e8e080e7          	jalr	-370(ra) # 484 <printint>
 5fe:	8b4a                	mv	s6,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b771                	j	58e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b0913          	addi	s2,s6,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000b2583          	lw	a1,0(s6)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	e72080e7          	jalr	-398(ra) # 484 <printint>
 61a:	8b4a                	mv	s6,s2
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bf85                	j	58e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 620:	008b0913          	addi	s2,s6,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000b2583          	lw	a1,0(s6)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e56080e7          	jalr	-426(ra) # 484 <printint>
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	bf91                	j	58e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 63c:	008b0793          	addi	a5,s6,8
 640:	f8f43423          	sd	a5,-120(s0)
 644:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e14080e7          	jalr	-492(ra) # 462 <putc>
  putc(fd, 'x');
 656:	85ea                	mv	a1,s10
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	e08080e7          	jalr	-504(ra) # 462 <putc>
 662:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 664:	03c9d793          	srli	a5,s3,0x3c
 668:	97de                	add	a5,a5,s7
 66a:	0007c583          	lbu	a1,0(a5)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	df2080e7          	jalr	-526(ra) # 462 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 678:	0992                	slli	s3,s3,0x4
 67a:	397d                	addiw	s2,s2,-1
 67c:	fe0914e3          	bnez	s2,664 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 680:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 684:	4981                	li	s3,0
 686:	b721                	j	58e <vprintf+0x60>
        s = va_arg(ap, char*);
 688:	008b0993          	addi	s3,s6,8
 68c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 690:	02090163          	beqz	s2,6b2 <vprintf+0x184>
        while(*s != 0){
 694:	00094583          	lbu	a1,0(s2)
 698:	c9a1                	beqz	a1,6e8 <vprintf+0x1ba>
          putc(fd, *s);
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	dc6080e7          	jalr	-570(ra) # 462 <putc>
          s++;
 6a4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a6:	00094583          	lbu	a1,0(s2)
 6aa:	f9e5                	bnez	a1,69a <vprintf+0x16c>
        s = va_arg(ap, char*);
 6ac:	8b4e                	mv	s6,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bdf9                	j	58e <vprintf+0x60>
          s = "(null)";
 6b2:	00000917          	auipc	s2,0x0
 6b6:	2ae90913          	addi	s2,s2,686 # 960 <malloc+0x168>
        while(*s != 0){
 6ba:	02800593          	li	a1,40
 6be:	bff1                	j	69a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6c0:	008b0913          	addi	s2,s6,8
 6c4:	000b4583          	lbu	a1,0(s6)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	d98080e7          	jalr	-616(ra) # 462 <putc>
 6d2:	8b4a                	mv	s6,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bd65                	j	58e <vprintf+0x60>
        putc(fd, c);
 6d8:	85d2                	mv	a1,s4
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	d86080e7          	jalr	-634(ra) # 462 <putc>
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b565                	j	58e <vprintf+0x60>
        s = va_arg(ap, char*);
 6e8:	8b4e                	mv	s6,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b54d                	j	58e <vprintf+0x60>
    }
  }
}
 6ee:	70e6                	ld	ra,120(sp)
 6f0:	7446                	ld	s0,112(sp)
 6f2:	74a6                	ld	s1,104(sp)
 6f4:	7906                	ld	s2,96(sp)
 6f6:	69e6                	ld	s3,88(sp)
 6f8:	6a46                	ld	s4,80(sp)
 6fa:	6aa6                	ld	s5,72(sp)
 6fc:	6b06                	ld	s6,64(sp)
 6fe:	7be2                	ld	s7,56(sp)
 700:	7c42                	ld	s8,48(sp)
 702:	7ca2                	ld	s9,40(sp)
 704:	7d02                	ld	s10,32(sp)
 706:	6de2                	ld	s11,24(sp)
 708:	6109                	addi	sp,sp,128
 70a:	8082                	ret

000000000000070c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70c:	715d                	addi	sp,sp,-80
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	e010                	sd	a2,0(s0)
 716:	e414                	sd	a3,8(s0)
 718:	e818                	sd	a4,16(s0)
 71a:	ec1c                	sd	a5,24(s0)
 71c:	03043023          	sd	a6,32(s0)
 720:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 724:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 728:	8622                	mv	a2,s0
 72a:	00000097          	auipc	ra,0x0
 72e:	e04080e7          	jalr	-508(ra) # 52e <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <printf>:

void
printf(const char *fmt, ...)
{
 73a:	711d                	addi	sp,sp,-96
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e40c                	sd	a1,8(s0)
 744:	e810                	sd	a2,16(s0)
 746:	ec14                	sd	a3,24(s0)
 748:	f018                	sd	a4,32(s0)
 74a:	f41c                	sd	a5,40(s0)
 74c:	03043823          	sd	a6,48(s0)
 750:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	00840613          	addi	a2,s0,8
 758:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75c:	85aa                	mv	a1,a0
 75e:	4505                	li	a0,1
 760:	00000097          	auipc	ra,0x0
 764:	dce080e7          	jalr	-562(ra) # 52e <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6125                	addi	sp,sp,96
 76e:	8082                	ret

0000000000000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	1141                	addi	sp,sp,-16
 772:	e422                	sd	s0,8(sp)
 774:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 776:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	00001797          	auipc	a5,0x1
 77e:	8967b783          	ld	a5,-1898(a5) # 1010 <freep>
 782:	a805                	j	7b2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 784:	4618                	lw	a4,8(a2)
 786:	9db9                	addw	a1,a1,a4
 788:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78c:	6398                	ld	a4,0(a5)
 78e:	6318                	ld	a4,0(a4)
 790:	fee53823          	sd	a4,-16(a0)
 794:	a091                	j	7d8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 796:	ff852703          	lw	a4,-8(a0)
 79a:	9e39                	addw	a2,a2,a4
 79c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 79e:	ff053703          	ld	a4,-16(a0)
 7a2:	e398                	sd	a4,0(a5)
 7a4:	a099                	j	7ea <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	6398                	ld	a4,0(a5)
 7a8:	00e7e463          	bltu	a5,a4,7b0 <free+0x40>
 7ac:	00e6ea63          	bltu	a3,a4,7c0 <free+0x50>
{
 7b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	fed7fae3          	bgeu	a5,a3,7a6 <free+0x36>
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e6e463          	bltu	a3,a4,7c0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bc:	fee7eae3          	bltu	a5,a4,7b0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7c0:	ff852583          	lw	a1,-8(a0)
 7c4:	6390                	ld	a2,0(a5)
 7c6:	02059713          	slli	a4,a1,0x20
 7ca:	9301                	srli	a4,a4,0x20
 7cc:	0712                	slli	a4,a4,0x4
 7ce:	9736                	add	a4,a4,a3
 7d0:	fae60ae3          	beq	a2,a4,784 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d8:	4790                	lw	a2,8(a5)
 7da:	02061713          	slli	a4,a2,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	973e                	add	a4,a4,a5
 7e4:	fae689e3          	beq	a3,a4,796 <free+0x26>
  } else
    p->s.ptr = bp;
 7e8:	e394                	sd	a3,0(a5)
  freep = p;
 7ea:	00001717          	auipc	a4,0x1
 7ee:	82f73323          	sd	a5,-2010(a4) # 1010 <freep>
}
 7f2:	6422                	ld	s0,8(sp)
 7f4:	0141                	addi	sp,sp,16
 7f6:	8082                	ret

00000000000007f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f426                	sd	s1,40(sp)
 800:	f04a                	sd	s2,32(sp)
 802:	ec4e                	sd	s3,24(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
 80a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80c:	02051493          	slli	s1,a0,0x20
 810:	9081                	srli	s1,s1,0x20
 812:	04bd                	addi	s1,s1,15
 814:	8091                	srli	s1,s1,0x4
 816:	0014899b          	addiw	s3,s1,1
 81a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81c:	00000517          	auipc	a0,0x0
 820:	7f453503          	ld	a0,2036(a0) # 1010 <freep>
 824:	c515                	beqz	a0,850 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 826:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 828:	4798                	lw	a4,8(a5)
 82a:	02977f63          	bgeu	a4,s1,868 <malloc+0x70>
 82e:	8a4e                	mv	s4,s3
 830:	0009871b          	sext.w	a4,s3
 834:	6685                	lui	a3,0x1
 836:	00d77363          	bgeu	a4,a3,83c <malloc+0x44>
 83a:	6a05                	lui	s4,0x1
 83c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 840:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 844:	00000917          	auipc	s2,0x0
 848:	7cc90913          	addi	s2,s2,1996 # 1010 <freep>
  if(p == (char*)-1)
 84c:	5afd                	li	s5,-1
 84e:	a88d                	j	8c0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 850:	00000797          	auipc	a5,0x0
 854:	7d078793          	addi	a5,a5,2000 # 1020 <base>
 858:	00000717          	auipc	a4,0x0
 85c:	7af73c23          	sd	a5,1976(a4) # 1010 <freep>
 860:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 862:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 866:	b7e1                	j	82e <malloc+0x36>
      if(p->s.size == nunits)
 868:	02e48b63          	beq	s1,a4,89e <malloc+0xa6>
        p->s.size -= nunits;
 86c:	4137073b          	subw	a4,a4,s3
 870:	c798                	sw	a4,8(a5)
        p += p->s.size;
 872:	1702                	slli	a4,a4,0x20
 874:	9301                	srli	a4,a4,0x20
 876:	0712                	slli	a4,a4,0x4
 878:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87e:	00000717          	auipc	a4,0x0
 882:	78a73923          	sd	a0,1938(a4) # 1010 <freep>
      return (void*)(p + 1);
 886:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 88a:	70e2                	ld	ra,56(sp)
 88c:	7442                	ld	s0,48(sp)
 88e:	74a2                	ld	s1,40(sp)
 890:	7902                	ld	s2,32(sp)
 892:	69e2                	ld	s3,24(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	6121                	addi	sp,sp,64
 89c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	e118                	sd	a4,0(a0)
 8a2:	bff1                	j	87e <malloc+0x86>
  hp->s.size = nu;
 8a4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a8:	0541                	addi	a0,a0,16
 8aa:	00000097          	auipc	ra,0x0
 8ae:	ec6080e7          	jalr	-314(ra) # 770 <free>
  return freep;
 8b2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b6:	d971                	beqz	a0,88a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ba:	4798                	lw	a4,8(a5)
 8bc:	fa9776e3          	bgeu	a4,s1,868 <malloc+0x70>
    if(p == freep)
 8c0:	00093703          	ld	a4,0(s2)
 8c4:	853e                	mv	a0,a5
 8c6:	fef719e3          	bne	a4,a5,8b8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ca:	8552                	mv	a0,s4
 8cc:	00000097          	auipc	ra,0x0
 8d0:	b5e080e7          	jalr	-1186(ra) # 42a <sbrk>
  if(p == (char*)-1)
 8d4:	fd5518e3          	bne	a0,s5,8a4 <malloc+0xac>
        return 0;
 8d8:	4501                	li	a0,0
 8da:	bf45                	j	88a <malloc+0x92>
