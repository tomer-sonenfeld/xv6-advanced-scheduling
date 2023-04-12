
user/_cfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

int main(){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    // //wait for the third child
    // wait(0,msg);
    // exit(0,"cfs finished");
    
    //get my pid
    int pid = getpid();
   8:	00000097          	auipc	ra,0x0
   c:	344080e7          	jalr	836(ra) # 34c <getpid>
    printf("my priority stats are %d\n", get_cfs_stats(pid));
  10:	00000097          	auipc	ra,0x0
  14:	374080e7          	jalr	884(ra) # 384 <get_cfs_stats>
  18:	85aa                	mv	a1,a0
  1a:	00000517          	auipc	a0,0x0
  1e:	7f650513          	addi	a0,a0,2038 # 810 <malloc+0xee>
  22:	00000097          	auipc	ra,0x0
  26:	642080e7          	jalr	1602(ra) # 664 <printf>
    exit(0,"cfs finished");
  2a:	00001597          	auipc	a1,0x1
  2e:	80658593          	addi	a1,a1,-2042 # 830 <malloc+0x10e>
  32:	4501                	li	a0,0
  34:	00000097          	auipc	ra,0x0
  38:	298080e7          	jalr	664(ra) # 2cc <exit>

000000000000003c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e406                	sd	ra,8(sp)
  40:	e022                	sd	s0,0(sp)
  42:	0800                	addi	s0,sp,16
  extern int main();
  main();
  44:	00000097          	auipc	ra,0x0
  48:	fbc080e7          	jalr	-68(ra) # 0 <main>
  exit(0,"");
  4c:	00000597          	auipc	a1,0x0
  50:	7f458593          	addi	a1,a1,2036 # 840 <malloc+0x11e>
  54:	4501                	li	a0,0
  56:	00000097          	auipc	ra,0x0
  5a:	276080e7          	jalr	630(ra) # 2cc <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e422                	sd	s0,8(sp)
  62:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	87aa                	mv	a5,a0
  66:	0585                	addi	a1,a1,1
  68:	0785                	addi	a5,a5,1
  6a:	fff5c703          	lbu	a4,-1(a1)
  6e:	fee78fa3          	sb	a4,-1(a5)
  72:	fb75                	bnez	a4,66 <strcpy+0x8>
    ;
  return os;
}
  74:	6422                	ld	s0,8(sp)
  76:	0141                	addi	sp,sp,16
  78:	8082                	ret

000000000000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e422                	sd	s0,8(sp)
  7e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  80:	00054783          	lbu	a5,0(a0)
  84:	cb91                	beqz	a5,98 <strcmp+0x1e>
  86:	0005c703          	lbu	a4,0(a1)
  8a:	00f71763          	bne	a4,a5,98 <strcmp+0x1e>
    p++, q++;
  8e:	0505                	addi	a0,a0,1
  90:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	fbe5                	bnez	a5,86 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  98:	0005c503          	lbu	a0,0(a1)
}
  9c:	40a7853b          	subw	a0,a5,a0
  a0:	6422                	ld	s0,8(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret

00000000000000a6 <strlen>:

uint
strlen(const char *s)
{
  a6:	1141                	addi	sp,sp,-16
  a8:	e422                	sd	s0,8(sp)
  aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cf91                	beqz	a5,cc <strlen+0x26>
  b2:	0505                	addi	a0,a0,1
  b4:	87aa                	mv	a5,a0
  b6:	4685                	li	a3,1
  b8:	9e89                	subw	a3,a3,a0
  ba:	00f6853b          	addw	a0,a3,a5
  be:	0785                	addi	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	fb7d                	bnez	a4,ba <strlen+0x14>
    ;
  return n;
}
  c6:	6422                	ld	s0,8(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret
  for(n = 0; s[n]; n++)
  cc:	4501                	li	a0,0
  ce:	bfe5                	j	c6 <strlen+0x20>

00000000000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d6:	ca19                	beqz	a2,ec <memset+0x1c>
  d8:	87aa                	mv	a5,a0
  da:	1602                	slli	a2,a2,0x20
  dc:	9201                	srli	a2,a2,0x20
  de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e6:	0785                	addi	a5,a5,1
  e8:	fee79de3          	bne	a5,a4,e2 <memset+0x12>
  }
  return dst;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strchr>:

char*
strchr(const char *s, char c)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb99                	beqz	a5,112 <strchr+0x20>
    if(*s == c)
  fe:	00f58763          	beq	a1,a5,10c <strchr+0x1a>
  for(; *s; s++)
 102:	0505                	addi	a0,a0,1
 104:	00054783          	lbu	a5,0(a0)
 108:	fbfd                	bnez	a5,fe <strchr+0xc>
      return (char*)s;
  return 0;
 10a:	4501                	li	a0,0
}
 10c:	6422                	ld	s0,8(sp)
 10e:	0141                	addi	sp,sp,16
 110:	8082                	ret
  return 0;
 112:	4501                	li	a0,0
 114:	bfe5                	j	10c <strchr+0x1a>

0000000000000116 <gets>:

char*
gets(char *buf, int max)
{
 116:	711d                	addi	sp,sp,-96
 118:	ec86                	sd	ra,88(sp)
 11a:	e8a2                	sd	s0,80(sp)
 11c:	e4a6                	sd	s1,72(sp)
 11e:	e0ca                	sd	s2,64(sp)
 120:	fc4e                	sd	s3,56(sp)
 122:	f852                	sd	s4,48(sp)
 124:	f456                	sd	s5,40(sp)
 126:	f05a                	sd	s6,32(sp)
 128:	ec5e                	sd	s7,24(sp)
 12a:	1080                	addi	s0,sp,96
 12c:	8baa                	mv	s7,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 134:	4aa9                	li	s5,10
 136:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 138:	89a6                	mv	s3,s1
 13a:	2485                	addiw	s1,s1,1
 13c:	0344d863          	bge	s1,s4,16c <gets+0x56>
    cc = read(0, &c, 1);
 140:	4605                	li	a2,1
 142:	faf40593          	addi	a1,s0,-81
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	19c080e7          	jalr	412(ra) # 2e4 <read>
    if(cc < 1)
 150:	00a05e63          	blez	a0,16c <gets+0x56>
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	01578763          	beq	a5,s5,16a <gets+0x54>
 160:	0905                	addi	s2,s2,1
 162:	fd679be3          	bne	a5,s6,138 <gets+0x22>
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	a011                	j	16c <gets+0x56>
 16a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16c:	99de                	add	s3,s3,s7
 16e:	00098023          	sb	zero,0(s3)
  return buf;
}
 172:	855e                	mv	a0,s7
 174:	60e6                	ld	ra,88(sp)
 176:	6446                	ld	s0,80(sp)
 178:	64a6                	ld	s1,72(sp)
 17a:	6906                	ld	s2,64(sp)
 17c:	79e2                	ld	s3,56(sp)
 17e:	7a42                	ld	s4,48(sp)
 180:	7aa2                	ld	s5,40(sp)
 182:	7b02                	ld	s6,32(sp)
 184:	6be2                	ld	s7,24(sp)
 186:	6125                	addi	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	e04a                	sd	s2,0(sp)
 194:	1000                	addi	s0,sp,32
 196:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	4581                	li	a1,0
 19a:	00000097          	auipc	ra,0x0
 19e:	172080e7          	jalr	370(ra) # 30c <open>
  if(fd < 0)
 1a2:	02054563          	bltz	a0,1cc <stat+0x42>
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	00000097          	auipc	ra,0x0
 1ae:	17a080e7          	jalr	378(ra) # 324 <fstat>
 1b2:	892a                	mv	s2,a0
  close(fd);
 1b4:	8526                	mv	a0,s1
 1b6:	00000097          	auipc	ra,0x0
 1ba:	13e080e7          	jalr	318(ra) # 2f4 <close>
  return r;
}
 1be:	854a                	mv	a0,s2
 1c0:	60e2                	ld	ra,24(sp)
 1c2:	6442                	ld	s0,16(sp)
 1c4:	64a2                	ld	s1,8(sp)
 1c6:	6902                	ld	s2,0(sp)
 1c8:	6105                	addi	sp,sp,32
 1ca:	8082                	ret
    return -1;
 1cc:	597d                	li	s2,-1
 1ce:	bfc5                	j	1be <stat+0x34>

00000000000001d0 <atoi>:

int
atoi(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d6:	00054603          	lbu	a2,0(a0)
 1da:	fd06079b          	addiw	a5,a2,-48
 1de:	0ff7f793          	andi	a5,a5,255
 1e2:	4725                	li	a4,9
 1e4:	02f76963          	bltu	a4,a5,216 <atoi+0x46>
 1e8:	86aa                	mv	a3,a0
  n = 0;
 1ea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1ee:	0685                	addi	a3,a3,1
 1f0:	0025179b          	slliw	a5,a0,0x2
 1f4:	9fa9                	addw	a5,a5,a0
 1f6:	0017979b          	slliw	a5,a5,0x1
 1fa:	9fb1                	addw	a5,a5,a2
 1fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 200:	0006c603          	lbu	a2,0(a3)
 204:	fd06071b          	addiw	a4,a2,-48
 208:	0ff77713          	andi	a4,a4,255
 20c:	fee5f1e3          	bgeu	a1,a4,1ee <atoi+0x1e>
  return n;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  n = 0;
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <atoi+0x40>

000000000000021a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 220:	02b57463          	bgeu	a0,a1,248 <memmove+0x2e>
    while(n-- > 0)
 224:	00c05f63          	blez	a2,242 <memmove+0x28>
 228:	1602                	slli	a2,a2,0x20
 22a:	9201                	srli	a2,a2,0x20
 22c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 230:	872a                	mv	a4,a0
      *dst++ = *src++;
 232:	0585                	addi	a1,a1,1
 234:	0705                	addi	a4,a4,1
 236:	fff5c683          	lbu	a3,-1(a1)
 23a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23e:	fee79ae3          	bne	a5,a4,232 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
    dst += n;
 248:	00c50733          	add	a4,a0,a2
    src += n;
 24c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24e:	fec05ae3          	blez	a2,242 <memmove+0x28>
 252:	fff6079b          	addiw	a5,a2,-1
 256:	1782                	slli	a5,a5,0x20
 258:	9381                	srli	a5,a5,0x20
 25a:	fff7c793          	not	a5,a5
 25e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 260:	15fd                	addi	a1,a1,-1
 262:	177d                	addi	a4,a4,-1
 264:	0005c683          	lbu	a3,0(a1)
 268:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26c:	fee79ae3          	bne	a5,a4,260 <memmove+0x46>
 270:	bfc9                	j	242 <memmove+0x28>

0000000000000272 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 278:	ca05                	beqz	a2,2a8 <memcmp+0x36>
 27a:	fff6069b          	addiw	a3,a2,-1
 27e:	1682                	slli	a3,a3,0x20
 280:	9281                	srli	a3,a3,0x20
 282:	0685                	addi	a3,a3,1
 284:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 286:	00054783          	lbu	a5,0(a0)
 28a:	0005c703          	lbu	a4,0(a1)
 28e:	00e79863          	bne	a5,a4,29e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 292:	0505                	addi	a0,a0,1
    p2++;
 294:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 296:	fed518e3          	bne	a0,a3,286 <memcmp+0x14>
  }
  return 0;
 29a:	4501                	li	a0,0
 29c:	a019                	j	2a2 <memcmp+0x30>
      return *p1 - *p2;
 29e:	40e7853b          	subw	a0,a5,a4
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	bfe5                	j	2a2 <memcmp+0x30>

00000000000002ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b4:	00000097          	auipc	ra,0x0
 2b8:	f66080e7          	jalr	-154(ra) # 21a <memmove>
}
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c4:	4885                	li	a7,1
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2cc:	4889                	li	a7,2
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d4:	488d                	li	a7,3
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2dc:	4891                	li	a7,4
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <read>:
.global read
read:
 li a7, SYS_read
 2e4:	4895                	li	a7,5
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <write>:
.global write
write:
 li a7, SYS_write
 2ec:	48c1                	li	a7,16
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <close>:
.global close
close:
 li a7, SYS_close
 2f4:	48d5                	li	a7,21
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fc:	4899                	li	a7,6
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exec>:
.global exec
exec:
 li a7, SYS_exec
 304:	489d                	li	a7,7
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <open>:
.global open
open:
 li a7, SYS_open
 30c:	48bd                	li	a7,15
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 314:	48c5                	li	a7,17
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31c:	48c9                	li	a7,18
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 324:	48a1                	li	a7,8
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <link>:
.global link
link:
 li a7, SYS_link
 32c:	48cd                	li	a7,19
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 334:	48d1                	li	a7,20
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33c:	48a5                	li	a7,9
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <dup>:
.global dup
dup:
 li a7, SYS_dup
 344:	48a9                	li	a7,10
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34c:	48ad                	li	a7,11
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 354:	48b1                	li	a7,12
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 35c:	48b5                	li	a7,13
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 364:	48b9                	li	a7,14
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 36c:	48d9                	li	a7,22
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 374:	48dd                	li	a7,23
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 37c:	48e1                	li	a7,24
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 384:	48e5                	li	a7,25
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	00000097          	auipc	ra,0x0
 3a2:	f4e080e7          	jalr	-178(ra) # 2ec <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	7139                	addi	sp,sp,-64
 3b0:	fc06                	sd	ra,56(sp)
 3b2:	f822                	sd	s0,48(sp)
 3b4:	f426                	sd	s1,40(sp)
 3b6:	f04a                	sd	s2,32(sp)
 3b8:	ec4e                	sd	s3,24(sp)
 3ba:	0080                	addi	s0,sp,64
 3bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	c299                	beqz	a3,3c4 <printint+0x16>
 3c0:	0805c863          	bltz	a1,450 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c4:	2581                	sext.w	a1,a1
  neg = 0;
 3c6:	4881                	li	a7,0
 3c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ce:	2601                	sext.w	a2,a2
 3d0:	00000517          	auipc	a0,0x0
 3d4:	48050513          	addi	a0,a0,1152 # 850 <digits>
 3d8:	883a                	mv	a6,a4
 3da:	2705                	addiw	a4,a4,1
 3dc:	02c5f7bb          	remuw	a5,a1,a2
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	97aa                	add	a5,a5,a0
 3e6:	0007c783          	lbu	a5,0(a5)
 3ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ee:	0005879b          	sext.w	a5,a1
 3f2:	02c5d5bb          	divuw	a1,a1,a2
 3f6:	0685                	addi	a3,a3,1
 3f8:	fec7f0e3          	bgeu	a5,a2,3d8 <printint+0x2a>
  if(neg)
 3fc:	00088b63          	beqz	a7,412 <printint+0x64>
    buf[i++] = '-';
 400:	fd040793          	addi	a5,s0,-48
 404:	973e                	add	a4,a4,a5
 406:	02d00793          	li	a5,45
 40a:	fef70823          	sb	a5,-16(a4)
 40e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 412:	02e05863          	blez	a4,442 <printint+0x94>
 416:	fc040793          	addi	a5,s0,-64
 41a:	00e78933          	add	s2,a5,a4
 41e:	fff78993          	addi	s3,a5,-1
 422:	99ba                	add	s3,s3,a4
 424:	377d                	addiw	a4,a4,-1
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	fff94583          	lbu	a1,-1(s2)
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	f58080e7          	jalr	-168(ra) # 38c <putc>
  while(--i >= 0)
 43c:	197d                	addi	s2,s2,-1
 43e:	ff3918e3          	bne	s2,s3,42e <printint+0x80>
}
 442:	70e2                	ld	ra,56(sp)
 444:	7442                	ld	s0,48(sp)
 446:	74a2                	ld	s1,40(sp)
 448:	7902                	ld	s2,32(sp)
 44a:	69e2                	ld	s3,24(sp)
 44c:	6121                	addi	sp,sp,64
 44e:	8082                	ret
    x = -xx;
 450:	40b005bb          	negw	a1,a1
    neg = 1;
 454:	4885                	li	a7,1
    x = -xx;
 456:	bf8d                	j	3c8 <printint+0x1a>

0000000000000458 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 458:	7119                	addi	sp,sp,-128
 45a:	fc86                	sd	ra,120(sp)
 45c:	f8a2                	sd	s0,112(sp)
 45e:	f4a6                	sd	s1,104(sp)
 460:	f0ca                	sd	s2,96(sp)
 462:	ecce                	sd	s3,88(sp)
 464:	e8d2                	sd	s4,80(sp)
 466:	e4d6                	sd	s5,72(sp)
 468:	e0da                	sd	s6,64(sp)
 46a:	fc5e                	sd	s7,56(sp)
 46c:	f862                	sd	s8,48(sp)
 46e:	f466                	sd	s9,40(sp)
 470:	f06a                	sd	s10,32(sp)
 472:	ec6e                	sd	s11,24(sp)
 474:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 476:	0005c903          	lbu	s2,0(a1)
 47a:	18090f63          	beqz	s2,618 <vprintf+0x1c0>
 47e:	8aaa                	mv	s5,a0
 480:	8b32                	mv	s6,a2
 482:	00158493          	addi	s1,a1,1
  state = 0;
 486:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 488:	02500a13          	li	s4,37
      if(c == 'd'){
 48c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 490:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 494:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 498:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 49c:	00000b97          	auipc	s7,0x0
 4a0:	3b4b8b93          	addi	s7,s7,948 # 850 <digits>
 4a4:	a839                	j	4c2 <vprintf+0x6a>
        putc(fd, c);
 4a6:	85ca                	mv	a1,s2
 4a8:	8556                	mv	a0,s5
 4aa:	00000097          	auipc	ra,0x0
 4ae:	ee2080e7          	jalr	-286(ra) # 38c <putc>
 4b2:	a019                	j	4b8 <vprintf+0x60>
    } else if(state == '%'){
 4b4:	01498f63          	beq	s3,s4,4d2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4b8:	0485                	addi	s1,s1,1
 4ba:	fff4c903          	lbu	s2,-1(s1)
 4be:	14090d63          	beqz	s2,618 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4c2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c6:	fe0997e3          	bnez	s3,4b4 <vprintf+0x5c>
      if(c == '%'){
 4ca:	fd479ee3          	bne	a5,s4,4a6 <vprintf+0x4e>
        state = '%';
 4ce:	89be                	mv	s3,a5
 4d0:	b7e5                	j	4b8 <vprintf+0x60>
      if(c == 'd'){
 4d2:	05878063          	beq	a5,s8,512 <vprintf+0xba>
      } else if(c == 'l') {
 4d6:	05978c63          	beq	a5,s9,52e <vprintf+0xd6>
      } else if(c == 'x') {
 4da:	07a78863          	beq	a5,s10,54a <vprintf+0xf2>
      } else if(c == 'p') {
 4de:	09b78463          	beq	a5,s11,566 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4e2:	07300713          	li	a4,115
 4e6:	0ce78663          	beq	a5,a4,5b2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ea:	06300713          	li	a4,99
 4ee:	0ee78e63          	beq	a5,a4,5ea <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4f2:	11478863          	beq	a5,s4,602 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f6:	85d2                	mv	a1,s4
 4f8:	8556                	mv	a0,s5
 4fa:	00000097          	auipc	ra,0x0
 4fe:	e92080e7          	jalr	-366(ra) # 38c <putc>
        putc(fd, c);
 502:	85ca                	mv	a1,s2
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	e86080e7          	jalr	-378(ra) # 38c <putc>
      }
      state = 0;
 50e:	4981                	li	s3,0
 510:	b765                	j	4b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 512:	008b0913          	addi	s2,s6,8
 516:	4685                	li	a3,1
 518:	4629                	li	a2,10
 51a:	000b2583          	lw	a1,0(s6)
 51e:	8556                	mv	a0,s5
 520:	00000097          	auipc	ra,0x0
 524:	e8e080e7          	jalr	-370(ra) # 3ae <printint>
 528:	8b4a                	mv	s6,s2
      state = 0;
 52a:	4981                	li	s3,0
 52c:	b771                	j	4b8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 52e:	008b0913          	addi	s2,s6,8
 532:	4681                	li	a3,0
 534:	4629                	li	a2,10
 536:	000b2583          	lw	a1,0(s6)
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e72080e7          	jalr	-398(ra) # 3ae <printint>
 544:	8b4a                	mv	s6,s2
      state = 0;
 546:	4981                	li	s3,0
 548:	bf85                	j	4b8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 54a:	008b0913          	addi	s2,s6,8
 54e:	4681                	li	a3,0
 550:	4641                	li	a2,16
 552:	000b2583          	lw	a1,0(s6)
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	e56080e7          	jalr	-426(ra) # 3ae <printint>
 560:	8b4a                	mv	s6,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	bf91                	j	4b8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 566:	008b0793          	addi	a5,s6,8
 56a:	f8f43423          	sd	a5,-120(s0)
 56e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 572:	03000593          	li	a1,48
 576:	8556                	mv	a0,s5
 578:	00000097          	auipc	ra,0x0
 57c:	e14080e7          	jalr	-492(ra) # 38c <putc>
  putc(fd, 'x');
 580:	85ea                	mv	a1,s10
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e08080e7          	jalr	-504(ra) # 38c <putc>
 58c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58e:	03c9d793          	srli	a5,s3,0x3c
 592:	97de                	add	a5,a5,s7
 594:	0007c583          	lbu	a1,0(a5)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	df2080e7          	jalr	-526(ra) # 38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5a2:	0992                	slli	s3,s3,0x4
 5a4:	397d                	addiw	s2,s2,-1
 5a6:	fe0914e3          	bnez	s2,58e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5aa:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b721                	j	4b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 5b2:	008b0993          	addi	s3,s6,8
 5b6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5ba:	02090163          	beqz	s2,5dc <vprintf+0x184>
        while(*s != 0){
 5be:	00094583          	lbu	a1,0(s2)
 5c2:	c9a1                	beqz	a1,612 <vprintf+0x1ba>
          putc(fd, *s);
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	dc6080e7          	jalr	-570(ra) # 38c <putc>
          s++;
 5ce:	0905                	addi	s2,s2,1
        while(*s != 0){
 5d0:	00094583          	lbu	a1,0(s2)
 5d4:	f9e5                	bnez	a1,5c4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5d6:	8b4e                	mv	s6,s3
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bdf9                	j	4b8 <vprintf+0x60>
          s = "(null)";
 5dc:	00000917          	auipc	s2,0x0
 5e0:	26c90913          	addi	s2,s2,620 # 848 <malloc+0x126>
        while(*s != 0){
 5e4:	02800593          	li	a1,40
 5e8:	bff1                	j	5c4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5ea:	008b0913          	addi	s2,s6,8
 5ee:	000b4583          	lbu	a1,0(s6)
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	d98080e7          	jalr	-616(ra) # 38c <putc>
 5fc:	8b4a                	mv	s6,s2
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bd65                	j	4b8 <vprintf+0x60>
        putc(fd, c);
 602:	85d2                	mv	a1,s4
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	d86080e7          	jalr	-634(ra) # 38c <putc>
      state = 0;
 60e:	4981                	li	s3,0
 610:	b565                	j	4b8 <vprintf+0x60>
        s = va_arg(ap, char*);
 612:	8b4e                	mv	s6,s3
      state = 0;
 614:	4981                	li	s3,0
 616:	b54d                	j	4b8 <vprintf+0x60>
    }
  }
}
 618:	70e6                	ld	ra,120(sp)
 61a:	7446                	ld	s0,112(sp)
 61c:	74a6                	ld	s1,104(sp)
 61e:	7906                	ld	s2,96(sp)
 620:	69e6                	ld	s3,88(sp)
 622:	6a46                	ld	s4,80(sp)
 624:	6aa6                	ld	s5,72(sp)
 626:	6b06                	ld	s6,64(sp)
 628:	7be2                	ld	s7,56(sp)
 62a:	7c42                	ld	s8,48(sp)
 62c:	7ca2                	ld	s9,40(sp)
 62e:	7d02                	ld	s10,32(sp)
 630:	6de2                	ld	s11,24(sp)
 632:	6109                	addi	sp,sp,128
 634:	8082                	ret

0000000000000636 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 636:	715d                	addi	sp,sp,-80
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	e010                	sd	a2,0(s0)
 640:	e414                	sd	a3,8(s0)
 642:	e818                	sd	a4,16(s0)
 644:	ec1c                	sd	a5,24(s0)
 646:	03043023          	sd	a6,32(s0)
 64a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 64e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 652:	8622                	mv	a2,s0
 654:	00000097          	auipc	ra,0x0
 658:	e04080e7          	jalr	-508(ra) # 458 <vprintf>
}
 65c:	60e2                	ld	ra,24(sp)
 65e:	6442                	ld	s0,16(sp)
 660:	6161                	addi	sp,sp,80
 662:	8082                	ret

0000000000000664 <printf>:

void
printf(const char *fmt, ...)
{
 664:	711d                	addi	sp,sp,-96
 666:	ec06                	sd	ra,24(sp)
 668:	e822                	sd	s0,16(sp)
 66a:	1000                	addi	s0,sp,32
 66c:	e40c                	sd	a1,8(s0)
 66e:	e810                	sd	a2,16(s0)
 670:	ec14                	sd	a3,24(s0)
 672:	f018                	sd	a4,32(s0)
 674:	f41c                	sd	a5,40(s0)
 676:	03043823          	sd	a6,48(s0)
 67a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 67e:	00840613          	addi	a2,s0,8
 682:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 686:	85aa                	mv	a1,a0
 688:	4505                	li	a0,1
 68a:	00000097          	auipc	ra,0x0
 68e:	dce080e7          	jalr	-562(ra) # 458 <vprintf>
}
 692:	60e2                	ld	ra,24(sp)
 694:	6442                	ld	s0,16(sp)
 696:	6125                	addi	sp,sp,96
 698:	8082                	ret

000000000000069a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69a:	1141                	addi	sp,sp,-16
 69c:	e422                	sd	s0,8(sp)
 69e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a4:	00001797          	auipc	a5,0x1
 6a8:	95c7b783          	ld	a5,-1700(a5) # 1000 <freep>
 6ac:	a805                	j	6dc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ae:	4618                	lw	a4,8(a2)
 6b0:	9db9                	addw	a1,a1,a4
 6b2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b6:	6398                	ld	a4,0(a5)
 6b8:	6318                	ld	a4,0(a4)
 6ba:	fee53823          	sd	a4,-16(a0)
 6be:	a091                	j	702 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c0:	ff852703          	lw	a4,-8(a0)
 6c4:	9e39                	addw	a2,a2,a4
 6c6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6c8:	ff053703          	ld	a4,-16(a0)
 6cc:	e398                	sd	a4,0(a5)
 6ce:	a099                	j	714 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	6398                	ld	a4,0(a5)
 6d2:	00e7e463          	bltu	a5,a4,6da <free+0x40>
 6d6:	00e6ea63          	bltu	a3,a4,6ea <free+0x50>
{
 6da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6dc:	fed7fae3          	bgeu	a5,a3,6d0 <free+0x36>
 6e0:	6398                	ld	a4,0(a5)
 6e2:	00e6e463          	bltu	a3,a4,6ea <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e6:	fee7eae3          	bltu	a5,a4,6da <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6ea:	ff852583          	lw	a1,-8(a0)
 6ee:	6390                	ld	a2,0(a5)
 6f0:	02059713          	slli	a4,a1,0x20
 6f4:	9301                	srli	a4,a4,0x20
 6f6:	0712                	slli	a4,a4,0x4
 6f8:	9736                	add	a4,a4,a3
 6fa:	fae60ae3          	beq	a2,a4,6ae <free+0x14>
    bp->s.ptr = p->s.ptr;
 6fe:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 702:	4790                	lw	a2,8(a5)
 704:	02061713          	slli	a4,a2,0x20
 708:	9301                	srli	a4,a4,0x20
 70a:	0712                	slli	a4,a4,0x4
 70c:	973e                	add	a4,a4,a5
 70e:	fae689e3          	beq	a3,a4,6c0 <free+0x26>
  } else
    p->s.ptr = bp;
 712:	e394                	sd	a3,0(a5)
  freep = p;
 714:	00001717          	auipc	a4,0x1
 718:	8ef73623          	sd	a5,-1812(a4) # 1000 <freep>
}
 71c:	6422                	ld	s0,8(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret

0000000000000722 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 722:	7139                	addi	sp,sp,-64
 724:	fc06                	sd	ra,56(sp)
 726:	f822                	sd	s0,48(sp)
 728:	f426                	sd	s1,40(sp)
 72a:	f04a                	sd	s2,32(sp)
 72c:	ec4e                	sd	s3,24(sp)
 72e:	e852                	sd	s4,16(sp)
 730:	e456                	sd	s5,8(sp)
 732:	e05a                	sd	s6,0(sp)
 734:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	02051493          	slli	s1,a0,0x20
 73a:	9081                	srli	s1,s1,0x20
 73c:	04bd                	addi	s1,s1,15
 73e:	8091                	srli	s1,s1,0x4
 740:	0014899b          	addiw	s3,s1,1
 744:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 746:	00001517          	auipc	a0,0x1
 74a:	8ba53503          	ld	a0,-1862(a0) # 1000 <freep>
 74e:	c515                	beqz	a0,77a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 750:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 752:	4798                	lw	a4,8(a5)
 754:	02977f63          	bgeu	a4,s1,792 <malloc+0x70>
 758:	8a4e                	mv	s4,s3
 75a:	0009871b          	sext.w	a4,s3
 75e:	6685                	lui	a3,0x1
 760:	00d77363          	bgeu	a4,a3,766 <malloc+0x44>
 764:	6a05                	lui	s4,0x1
 766:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 76a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 76e:	00001917          	auipc	s2,0x1
 772:	89290913          	addi	s2,s2,-1902 # 1000 <freep>
  if(p == (char*)-1)
 776:	5afd                	li	s5,-1
 778:	a88d                	j	7ea <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 77a:	00001797          	auipc	a5,0x1
 77e:	89678793          	addi	a5,a5,-1898 # 1010 <base>
 782:	00001717          	auipc	a4,0x1
 786:	86f73f23          	sd	a5,-1922(a4) # 1000 <freep>
 78a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 78c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 790:	b7e1                	j	758 <malloc+0x36>
      if(p->s.size == nunits)
 792:	02e48b63          	beq	s1,a4,7c8 <malloc+0xa6>
        p->s.size -= nunits;
 796:	4137073b          	subw	a4,a4,s3
 79a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 79c:	1702                	slli	a4,a4,0x20
 79e:	9301                	srli	a4,a4,0x20
 7a0:	0712                	slli	a4,a4,0x4
 7a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a8:	00001717          	auipc	a4,0x1
 7ac:	84a73c23          	sd	a0,-1960(a4) # 1000 <freep>
      return (void*)(p + 1);
 7b0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b4:	70e2                	ld	ra,56(sp)
 7b6:	7442                	ld	s0,48(sp)
 7b8:	74a2                	ld	s1,40(sp)
 7ba:	7902                	ld	s2,32(sp)
 7bc:	69e2                	ld	s3,24(sp)
 7be:	6a42                	ld	s4,16(sp)
 7c0:	6aa2                	ld	s5,8(sp)
 7c2:	6b02                	ld	s6,0(sp)
 7c4:	6121                	addi	sp,sp,64
 7c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	e118                	sd	a4,0(a0)
 7cc:	bff1                	j	7a8 <malloc+0x86>
  hp->s.size = nu;
 7ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d2:	0541                	addi	a0,a0,16
 7d4:	00000097          	auipc	ra,0x0
 7d8:	ec6080e7          	jalr	-314(ra) # 69a <free>
  return freep;
 7dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e0:	d971                	beqz	a0,7b4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e4:	4798                	lw	a4,8(a5)
 7e6:	fa9776e3          	bgeu	a4,s1,792 <malloc+0x70>
    if(p == freep)
 7ea:	00093703          	ld	a4,0(s2)
 7ee:	853e                	mv	a0,a5
 7f0:	fef719e3          	bne	a4,a5,7e2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7f4:	8552                	mv	a0,s4
 7f6:	00000097          	auipc	ra,0x0
 7fa:	b5e080e7          	jalr	-1186(ra) # 354 <sbrk>
  if(p == (char*)-1)
 7fe:	fd5518e3          	bne	a0,s5,7ce <malloc+0xac>
        return 0;
 802:	4501                	li	a0,0
 804:	bf45                	j	7b4 <malloc+0x92>
