
user/_goodbye:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:



//int memsize();

int main(int argc , char* argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    exit(0,"goodbye world xv6\n");
   8:	00000597          	auipc	a1,0x0
   c:	7c858593          	addi	a1,a1,1992 # 7d0 <malloc+0xe8>
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	298080e7          	jalr	664(ra) # 2aa <exit>

000000000000001a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  extern int main();
  main();
  22:	00000097          	auipc	ra,0x0
  26:	fde080e7          	jalr	-34(ra) # 0 <main>
  exit(0,"");
  2a:	00000597          	auipc	a1,0x0
  2e:	7be58593          	addi	a1,a1,1982 # 7e8 <malloc+0x100>
  32:	4501                	li	a0,0
  34:	00000097          	auipc	ra,0x0
  38:	276080e7          	jalr	630(ra) # 2aa <exit>

000000000000003c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  3c:	1141                	addi	sp,sp,-16
  3e:	e422                	sd	s0,8(sp)
  40:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  42:	87aa                	mv	a5,a0
  44:	0585                	addi	a1,a1,1
  46:	0785                	addi	a5,a5,1
  48:	fff5c703          	lbu	a4,-1(a1)
  4c:	fee78fa3          	sb	a4,-1(a5)
  50:	fb75                	bnez	a4,44 <strcpy+0x8>
    ;
  return os;
}
  52:	6422                	ld	s0,8(sp)
  54:	0141                	addi	sp,sp,16
  56:	8082                	ret

0000000000000058 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  58:	1141                	addi	sp,sp,-16
  5a:	e422                	sd	s0,8(sp)
  5c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x1e>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x1e>
    p++, q++;
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  76:	0005c503          	lbu	a0,0(a1)
}
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	6422                	ld	s0,8(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strlen>:

uint
strlen(const char *s)
{
  84:	1141                	addi	sp,sp,-16
  86:	e422                	sd	s0,8(sp)
  88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  8a:	00054783          	lbu	a5,0(a0)
  8e:	cf91                	beqz	a5,aa <strlen+0x26>
  90:	0505                	addi	a0,a0,1
  92:	87aa                	mv	a5,a0
  94:	4685                	li	a3,1
  96:	9e89                	subw	a3,a3,a0
  98:	00f6853b          	addw	a0,a3,a5
  9c:	0785                	addi	a5,a5,1
  9e:	fff7c703          	lbu	a4,-1(a5)
  a2:	fb7d                	bnez	a4,98 <strlen+0x14>
    ;
  return n;
}
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfe5                	j	a4 <strlen+0x20>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b4:	ca19                	beqz	a2,ca <memset+0x1c>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x12>
  }
  return dst;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e422                	sd	s0,8(sp)
  d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d6:	00054783          	lbu	a5,0(a0)
  da:	cb99                	beqz	a5,f0 <strchr+0x20>
    if(*s == c)
  dc:	00f58763          	beq	a1,a5,ea <strchr+0x1a>
  for(; *s; s++)
  e0:	0505                	addi	a0,a0,1
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbfd                	bnez	a5,dc <strchr+0xc>
      return (char*)s;
  return 0;
  e8:	4501                	li	a0,0
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  return 0;
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strchr+0x1a>

00000000000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	711d                	addi	sp,sp,-96
  f6:	ec86                	sd	ra,88(sp)
  f8:	e8a2                	sd	s0,80(sp)
  fa:	e4a6                	sd	s1,72(sp)
  fc:	e0ca                	sd	s2,64(sp)
  fe:	fc4e                	sd	s3,56(sp)
 100:	f852                	sd	s4,48(sp)
 102:	f456                	sd	s5,40(sp)
 104:	f05a                	sd	s6,32(sp)
 106:	ec5e                	sd	s7,24(sp)
 108:	1080                	addi	s0,sp,96
 10a:	8baa                	mv	s7,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 112:	4aa9                	li	s5,10
 114:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 116:	89a6                	mv	s3,s1
 118:	2485                	addiw	s1,s1,1
 11a:	0344d863          	bge	s1,s4,14a <gets+0x56>
    cc = read(0, &c, 1);
 11e:	4605                	li	a2,1
 120:	faf40593          	addi	a1,s0,-81
 124:	4501                	li	a0,0
 126:	00000097          	auipc	ra,0x0
 12a:	19c080e7          	jalr	412(ra) # 2c2 <read>
    if(cc < 1)
 12e:	00a05e63          	blez	a0,14a <gets+0x56>
    buf[i++] = c;
 132:	faf44783          	lbu	a5,-81(s0)
 136:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 13a:	01578763          	beq	a5,s5,148 <gets+0x54>
 13e:	0905                	addi	s2,s2,1
 140:	fd679be3          	bne	a5,s6,116 <gets+0x22>
  for(i=0; i+1 < max; ){
 144:	89a6                	mv	s3,s1
 146:	a011                	j	14a <gets+0x56>
 148:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 14a:	99de                	add	s3,s3,s7
 14c:	00098023          	sb	zero,0(s3)
  return buf;
}
 150:	855e                	mv	a0,s7
 152:	60e6                	ld	ra,88(sp)
 154:	6446                	ld	s0,80(sp)
 156:	64a6                	ld	s1,72(sp)
 158:	6906                	ld	s2,64(sp)
 15a:	79e2                	ld	s3,56(sp)
 15c:	7a42                	ld	s4,48(sp)
 15e:	7aa2                	ld	s5,40(sp)
 160:	7b02                	ld	s6,32(sp)
 162:	6be2                	ld	s7,24(sp)
 164:	6125                	addi	sp,sp,96
 166:	8082                	ret

0000000000000168 <stat>:

int
stat(const char *n, struct stat *st)
{
 168:	1101                	addi	sp,sp,-32
 16a:	ec06                	sd	ra,24(sp)
 16c:	e822                	sd	s0,16(sp)
 16e:	e426                	sd	s1,8(sp)
 170:	e04a                	sd	s2,0(sp)
 172:	1000                	addi	s0,sp,32
 174:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	4581                	li	a1,0
 178:	00000097          	auipc	ra,0x0
 17c:	172080e7          	jalr	370(ra) # 2ea <open>
  if(fd < 0)
 180:	02054563          	bltz	a0,1aa <stat+0x42>
 184:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 186:	85ca                	mv	a1,s2
 188:	00000097          	auipc	ra,0x0
 18c:	17a080e7          	jalr	378(ra) # 302 <fstat>
 190:	892a                	mv	s2,a0
  close(fd);
 192:	8526                	mv	a0,s1
 194:	00000097          	auipc	ra,0x0
 198:	13e080e7          	jalr	318(ra) # 2d2 <close>
  return r;
}
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	64a2                	ld	s1,8(sp)
 1a4:	6902                	ld	s2,0(sp)
 1a6:	6105                	addi	sp,sp,32
 1a8:	8082                	ret
    return -1;
 1aa:	597d                	li	s2,-1
 1ac:	bfc5                	j	19c <stat+0x34>

00000000000001ae <atoi>:

int
atoi(const char *s)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e422                	sd	s0,8(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b4:	00054603          	lbu	a2,0(a0)
 1b8:	fd06079b          	addiw	a5,a2,-48
 1bc:	0ff7f793          	andi	a5,a5,255
 1c0:	4725                	li	a4,9
 1c2:	02f76963          	bltu	a4,a5,1f4 <atoi+0x46>
 1c6:	86aa                	mv	a3,a0
  n = 0;
 1c8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1ca:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1cc:	0685                	addi	a3,a3,1
 1ce:	0025179b          	slliw	a5,a0,0x2
 1d2:	9fa9                	addw	a5,a5,a0
 1d4:	0017979b          	slliw	a5,a5,0x1
 1d8:	9fb1                	addw	a5,a5,a2
 1da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1de:	0006c603          	lbu	a2,0(a3)
 1e2:	fd06071b          	addiw	a4,a2,-48
 1e6:	0ff77713          	andi	a4,a4,255
 1ea:	fee5f1e3          	bgeu	a1,a4,1cc <atoi+0x1e>
  return n;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfe5                	j	1ee <atoi+0x40>

00000000000001f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e422                	sd	s0,8(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57463          	bgeu	a0,a1,226 <memmove+0x2e>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x28>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
    dst += n;
 226:	00c50733          	add	a4,a0,a2
    src += n;
 22a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 22c:	fec05ae3          	blez	a2,220 <memmove+0x28>
 230:	fff6079b          	addiw	a5,a2,-1
 234:	1782                	slli	a5,a5,0x20
 236:	9381                	srli	a5,a5,0x20
 238:	fff7c793          	not	a5,a5
 23c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 23e:	15fd                	addi	a1,a1,-1
 240:	177d                	addi	a4,a4,-1
 242:	0005c683          	lbu	a3,0(a1)
 246:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24a:	fee79ae3          	bne	a5,a4,23e <memmove+0x46>
 24e:	bfc9                	j	220 <memmove+0x28>

0000000000000250 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 256:	ca05                	beqz	a2,286 <memcmp+0x36>
 258:	fff6069b          	addiw	a3,a2,-1
 25c:	1682                	slli	a3,a3,0x20
 25e:	9281                	srli	a3,a3,0x20
 260:	0685                	addi	a3,a3,1
 262:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x14>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x30>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
  return 0;
 286:	4501                	li	a0,0
 288:	bfe5                	j	280 <memcmp+0x30>

000000000000028a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28a:	1141                	addi	sp,sp,-16
 28c:	e406                	sd	ra,8(sp)
 28e:	e022                	sd	s0,0(sp)
 290:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 292:	00000097          	auipc	ra,0x0
 296:	f66080e7          	jalr	-154(ra) # 1f8 <memmove>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2a2:	4885                	li	a7,1
 ecall
 2a4:	00000073          	ecall
 ret
 2a8:	8082                	ret

00000000000002aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2aa:	4889                	li	a7,2
 ecall
 2ac:	00000073          	ecall
 ret
 2b0:	8082                	ret

00000000000002b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2b2:	488d                	li	a7,3
 ecall
 2b4:	00000073          	ecall
 ret
 2b8:	8082                	ret

00000000000002ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ba:	4891                	li	a7,4
 ecall
 2bc:	00000073          	ecall
 ret
 2c0:	8082                	ret

00000000000002c2 <read>:
.global read
read:
 li a7, SYS_read
 2c2:	4895                	li	a7,5
 ecall
 2c4:	00000073          	ecall
 ret
 2c8:	8082                	ret

00000000000002ca <write>:
.global write
write:
 li a7, SYS_write
 2ca:	48c1                	li	a7,16
 ecall
 2cc:	00000073          	ecall
 ret
 2d0:	8082                	ret

00000000000002d2 <close>:
.global close
close:
 li a7, SYS_close
 2d2:	48d5                	li	a7,21
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <kill>:
.global kill
kill:
 li a7, SYS_kill
 2da:	4899                	li	a7,6
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2e2:	489d                	li	a7,7
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <open>:
.global open
open:
 li a7, SYS_open
 2ea:	48bd                	li	a7,15
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2f2:	48c5                	li	a7,17
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2fa:	48c9                	li	a7,18
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 302:	48a1                	li	a7,8
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <link>:
.global link
link:
 li a7, SYS_link
 30a:	48cd                	li	a7,19
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 312:	48d1                	li	a7,20
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 31a:	48a5                	li	a7,9
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <dup>:
.global dup
dup:
 li a7, SYS_dup
 322:	48a9                	li	a7,10
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 32a:	48ad                	li	a7,11
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 332:	48b1                	li	a7,12
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 33a:	48b5                	li	a7,13
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 342:	48b9                	li	a7,14
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 34a:	48d9                	li	a7,22
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	1000                	addi	s0,sp,32
 35a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 35e:	4605                	li	a2,1
 360:	fef40593          	addi	a1,s0,-17
 364:	00000097          	auipc	ra,0x0
 368:	f66080e7          	jalr	-154(ra) # 2ca <write>
}
 36c:	60e2                	ld	ra,24(sp)
 36e:	6442                	ld	s0,16(sp)
 370:	6105                	addi	sp,sp,32
 372:	8082                	ret

0000000000000374 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	7139                	addi	sp,sp,-64
 376:	fc06                	sd	ra,56(sp)
 378:	f822                	sd	s0,48(sp)
 37a:	f426                	sd	s1,40(sp)
 37c:	f04a                	sd	s2,32(sp)
 37e:	ec4e                	sd	s3,24(sp)
 380:	0080                	addi	s0,sp,64
 382:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 384:	c299                	beqz	a3,38a <printint+0x16>
 386:	0805c863          	bltz	a1,416 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 38a:	2581                	sext.w	a1,a1
  neg = 0;
 38c:	4881                	li	a7,0
 38e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 392:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 394:	2601                	sext.w	a2,a2
 396:	00000517          	auipc	a0,0x0
 39a:	46250513          	addi	a0,a0,1122 # 7f8 <digits>
 39e:	883a                	mv	a6,a4
 3a0:	2705                	addiw	a4,a4,1
 3a2:	02c5f7bb          	remuw	a5,a1,a2
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	97aa                	add	a5,a5,a0
 3ac:	0007c783          	lbu	a5,0(a5)
 3b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3b4:	0005879b          	sext.w	a5,a1
 3b8:	02c5d5bb          	divuw	a1,a1,a2
 3bc:	0685                	addi	a3,a3,1
 3be:	fec7f0e3          	bgeu	a5,a2,39e <printint+0x2a>
  if(neg)
 3c2:	00088b63          	beqz	a7,3d8 <printint+0x64>
    buf[i++] = '-';
 3c6:	fd040793          	addi	a5,s0,-48
 3ca:	973e                	add	a4,a4,a5
 3cc:	02d00793          	li	a5,45
 3d0:	fef70823          	sb	a5,-16(a4)
 3d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3d8:	02e05863          	blez	a4,408 <printint+0x94>
 3dc:	fc040793          	addi	a5,s0,-64
 3e0:	00e78933          	add	s2,a5,a4
 3e4:	fff78993          	addi	s3,a5,-1
 3e8:	99ba                	add	s3,s3,a4
 3ea:	377d                	addiw	a4,a4,-1
 3ec:	1702                	slli	a4,a4,0x20
 3ee:	9301                	srli	a4,a4,0x20
 3f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3f4:	fff94583          	lbu	a1,-1(s2)
 3f8:	8526                	mv	a0,s1
 3fa:	00000097          	auipc	ra,0x0
 3fe:	f58080e7          	jalr	-168(ra) # 352 <putc>
  while(--i >= 0)
 402:	197d                	addi	s2,s2,-1
 404:	ff3918e3          	bne	s2,s3,3f4 <printint+0x80>
}
 408:	70e2                	ld	ra,56(sp)
 40a:	7442                	ld	s0,48(sp)
 40c:	74a2                	ld	s1,40(sp)
 40e:	7902                	ld	s2,32(sp)
 410:	69e2                	ld	s3,24(sp)
 412:	6121                	addi	sp,sp,64
 414:	8082                	ret
    x = -xx;
 416:	40b005bb          	negw	a1,a1
    neg = 1;
 41a:	4885                	li	a7,1
    x = -xx;
 41c:	bf8d                	j	38e <printint+0x1a>

000000000000041e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 41e:	7119                	addi	sp,sp,-128
 420:	fc86                	sd	ra,120(sp)
 422:	f8a2                	sd	s0,112(sp)
 424:	f4a6                	sd	s1,104(sp)
 426:	f0ca                	sd	s2,96(sp)
 428:	ecce                	sd	s3,88(sp)
 42a:	e8d2                	sd	s4,80(sp)
 42c:	e4d6                	sd	s5,72(sp)
 42e:	e0da                	sd	s6,64(sp)
 430:	fc5e                	sd	s7,56(sp)
 432:	f862                	sd	s8,48(sp)
 434:	f466                	sd	s9,40(sp)
 436:	f06a                	sd	s10,32(sp)
 438:	ec6e                	sd	s11,24(sp)
 43a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43c:	0005c903          	lbu	s2,0(a1)
 440:	18090f63          	beqz	s2,5de <vprintf+0x1c0>
 444:	8aaa                	mv	s5,a0
 446:	8b32                	mv	s6,a2
 448:	00158493          	addi	s1,a1,1
  state = 0;
 44c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44e:	02500a13          	li	s4,37
      if(c == 'd'){
 452:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 456:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 45a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 45e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 462:	00000b97          	auipc	s7,0x0
 466:	396b8b93          	addi	s7,s7,918 # 7f8 <digits>
 46a:	a839                	j	488 <vprintf+0x6a>
        putc(fd, c);
 46c:	85ca                	mv	a1,s2
 46e:	8556                	mv	a0,s5
 470:	00000097          	auipc	ra,0x0
 474:	ee2080e7          	jalr	-286(ra) # 352 <putc>
 478:	a019                	j	47e <vprintf+0x60>
    } else if(state == '%'){
 47a:	01498f63          	beq	s3,s4,498 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 47e:	0485                	addi	s1,s1,1
 480:	fff4c903          	lbu	s2,-1(s1)
 484:	14090d63          	beqz	s2,5de <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 488:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48c:	fe0997e3          	bnez	s3,47a <vprintf+0x5c>
      if(c == '%'){
 490:	fd479ee3          	bne	a5,s4,46c <vprintf+0x4e>
        state = '%';
 494:	89be                	mv	s3,a5
 496:	b7e5                	j	47e <vprintf+0x60>
      if(c == 'd'){
 498:	05878063          	beq	a5,s8,4d8 <vprintf+0xba>
      } else if(c == 'l') {
 49c:	05978c63          	beq	a5,s9,4f4 <vprintf+0xd6>
      } else if(c == 'x') {
 4a0:	07a78863          	beq	a5,s10,510 <vprintf+0xf2>
      } else if(c == 'p') {
 4a4:	09b78463          	beq	a5,s11,52c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4a8:	07300713          	li	a4,115
 4ac:	0ce78663          	beq	a5,a4,578 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b0:	06300713          	li	a4,99
 4b4:	0ee78e63          	beq	a5,a4,5b0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4b8:	11478863          	beq	a5,s4,5c8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4bc:	85d2                	mv	a1,s4
 4be:	8556                	mv	a0,s5
 4c0:	00000097          	auipc	ra,0x0
 4c4:	e92080e7          	jalr	-366(ra) # 352 <putc>
        putc(fd, c);
 4c8:	85ca                	mv	a1,s2
 4ca:	8556                	mv	a0,s5
 4cc:	00000097          	auipc	ra,0x0
 4d0:	e86080e7          	jalr	-378(ra) # 352 <putc>
      }
      state = 0;
 4d4:	4981                	li	s3,0
 4d6:	b765                	j	47e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4d8:	008b0913          	addi	s2,s6,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000b2583          	lw	a1,0(s6)
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e8e080e7          	jalr	-370(ra) # 374 <printint>
 4ee:	8b4a                	mv	s6,s2
      state = 0;
 4f0:	4981                	li	s3,0
 4f2:	b771                	j	47e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4f4:	008b0913          	addi	s2,s6,8
 4f8:	4681                	li	a3,0
 4fa:	4629                	li	a2,10
 4fc:	000b2583          	lw	a1,0(s6)
 500:	8556                	mv	a0,s5
 502:	00000097          	auipc	ra,0x0
 506:	e72080e7          	jalr	-398(ra) # 374 <printint>
 50a:	8b4a                	mv	s6,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	bf85                	j	47e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 510:	008b0913          	addi	s2,s6,8
 514:	4681                	li	a3,0
 516:	4641                	li	a2,16
 518:	000b2583          	lw	a1,0(s6)
 51c:	8556                	mv	a0,s5
 51e:	00000097          	auipc	ra,0x0
 522:	e56080e7          	jalr	-426(ra) # 374 <printint>
 526:	8b4a                	mv	s6,s2
      state = 0;
 528:	4981                	li	s3,0
 52a:	bf91                	j	47e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 52c:	008b0793          	addi	a5,s6,8
 530:	f8f43423          	sd	a5,-120(s0)
 534:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 538:	03000593          	li	a1,48
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	e14080e7          	jalr	-492(ra) # 352 <putc>
  putc(fd, 'x');
 546:	85ea                	mv	a1,s10
 548:	8556                	mv	a0,s5
 54a:	00000097          	auipc	ra,0x0
 54e:	e08080e7          	jalr	-504(ra) # 352 <putc>
 552:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 554:	03c9d793          	srli	a5,s3,0x3c
 558:	97de                	add	a5,a5,s7
 55a:	0007c583          	lbu	a1,0(a5)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	df2080e7          	jalr	-526(ra) # 352 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 568:	0992                	slli	s3,s3,0x4
 56a:	397d                	addiw	s2,s2,-1
 56c:	fe0914e3          	bnez	s2,554 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 570:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 574:	4981                	li	s3,0
 576:	b721                	j	47e <vprintf+0x60>
        s = va_arg(ap, char*);
 578:	008b0993          	addi	s3,s6,8
 57c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 580:	02090163          	beqz	s2,5a2 <vprintf+0x184>
        while(*s != 0){
 584:	00094583          	lbu	a1,0(s2)
 588:	c9a1                	beqz	a1,5d8 <vprintf+0x1ba>
          putc(fd, *s);
 58a:	8556                	mv	a0,s5
 58c:	00000097          	auipc	ra,0x0
 590:	dc6080e7          	jalr	-570(ra) # 352 <putc>
          s++;
 594:	0905                	addi	s2,s2,1
        while(*s != 0){
 596:	00094583          	lbu	a1,0(s2)
 59a:	f9e5                	bnez	a1,58a <vprintf+0x16c>
        s = va_arg(ap, char*);
 59c:	8b4e                	mv	s6,s3
      state = 0;
 59e:	4981                	li	s3,0
 5a0:	bdf9                	j	47e <vprintf+0x60>
          s = "(null)";
 5a2:	00000917          	auipc	s2,0x0
 5a6:	24e90913          	addi	s2,s2,590 # 7f0 <malloc+0x108>
        while(*s != 0){
 5aa:	02800593          	li	a1,40
 5ae:	bff1                	j	58a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5b0:	008b0913          	addi	s2,s6,8
 5b4:	000b4583          	lbu	a1,0(s6)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	d98080e7          	jalr	-616(ra) # 352 <putc>
 5c2:	8b4a                	mv	s6,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bd65                	j	47e <vprintf+0x60>
        putc(fd, c);
 5c8:	85d2                	mv	a1,s4
 5ca:	8556                	mv	a0,s5
 5cc:	00000097          	auipc	ra,0x0
 5d0:	d86080e7          	jalr	-634(ra) # 352 <putc>
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b565                	j	47e <vprintf+0x60>
        s = va_arg(ap, char*);
 5d8:	8b4e                	mv	s6,s3
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b54d                	j	47e <vprintf+0x60>
    }
  }
}
 5de:	70e6                	ld	ra,120(sp)
 5e0:	7446                	ld	s0,112(sp)
 5e2:	74a6                	ld	s1,104(sp)
 5e4:	7906                	ld	s2,96(sp)
 5e6:	69e6                	ld	s3,88(sp)
 5e8:	6a46                	ld	s4,80(sp)
 5ea:	6aa6                	ld	s5,72(sp)
 5ec:	6b06                	ld	s6,64(sp)
 5ee:	7be2                	ld	s7,56(sp)
 5f0:	7c42                	ld	s8,48(sp)
 5f2:	7ca2                	ld	s9,40(sp)
 5f4:	7d02                	ld	s10,32(sp)
 5f6:	6de2                	ld	s11,24(sp)
 5f8:	6109                	addi	sp,sp,128
 5fa:	8082                	ret

00000000000005fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5fc:	715d                	addi	sp,sp,-80
 5fe:	ec06                	sd	ra,24(sp)
 600:	e822                	sd	s0,16(sp)
 602:	1000                	addi	s0,sp,32
 604:	e010                	sd	a2,0(s0)
 606:	e414                	sd	a3,8(s0)
 608:	e818                	sd	a4,16(s0)
 60a:	ec1c                	sd	a5,24(s0)
 60c:	03043023          	sd	a6,32(s0)
 610:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 614:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 618:	8622                	mv	a2,s0
 61a:	00000097          	auipc	ra,0x0
 61e:	e04080e7          	jalr	-508(ra) # 41e <vprintf>
}
 622:	60e2                	ld	ra,24(sp)
 624:	6442                	ld	s0,16(sp)
 626:	6161                	addi	sp,sp,80
 628:	8082                	ret

000000000000062a <printf>:

void
printf(const char *fmt, ...)
{
 62a:	711d                	addi	sp,sp,-96
 62c:	ec06                	sd	ra,24(sp)
 62e:	e822                	sd	s0,16(sp)
 630:	1000                	addi	s0,sp,32
 632:	e40c                	sd	a1,8(s0)
 634:	e810                	sd	a2,16(s0)
 636:	ec14                	sd	a3,24(s0)
 638:	f018                	sd	a4,32(s0)
 63a:	f41c                	sd	a5,40(s0)
 63c:	03043823          	sd	a6,48(s0)
 640:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 644:	00840613          	addi	a2,s0,8
 648:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 64c:	85aa                	mv	a1,a0
 64e:	4505                	li	a0,1
 650:	00000097          	auipc	ra,0x0
 654:	dce080e7          	jalr	-562(ra) # 41e <vprintf>
}
 658:	60e2                	ld	ra,24(sp)
 65a:	6442                	ld	s0,16(sp)
 65c:	6125                	addi	sp,sp,96
 65e:	8082                	ret

0000000000000660 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 660:	1141                	addi	sp,sp,-16
 662:	e422                	sd	s0,8(sp)
 664:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 666:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	00001797          	auipc	a5,0x1
 66e:	9967b783          	ld	a5,-1642(a5) # 1000 <freep>
 672:	a805                	j	6a2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 674:	4618                	lw	a4,8(a2)
 676:	9db9                	addw	a1,a1,a4
 678:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 67c:	6398                	ld	a4,0(a5)
 67e:	6318                	ld	a4,0(a4)
 680:	fee53823          	sd	a4,-16(a0)
 684:	a091                	j	6c8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 686:	ff852703          	lw	a4,-8(a0)
 68a:	9e39                	addw	a2,a2,a4
 68c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 68e:	ff053703          	ld	a4,-16(a0)
 692:	e398                	sd	a4,0(a5)
 694:	a099                	j	6da <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 696:	6398                	ld	a4,0(a5)
 698:	00e7e463          	bltu	a5,a4,6a0 <free+0x40>
 69c:	00e6ea63          	bltu	a3,a4,6b0 <free+0x50>
{
 6a0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	fed7fae3          	bgeu	a5,a3,696 <free+0x36>
 6a6:	6398                	ld	a4,0(a5)
 6a8:	00e6e463          	bltu	a3,a4,6b0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	fee7eae3          	bltu	a5,a4,6a0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6b0:	ff852583          	lw	a1,-8(a0)
 6b4:	6390                	ld	a2,0(a5)
 6b6:	02059713          	slli	a4,a1,0x20
 6ba:	9301                	srli	a4,a4,0x20
 6bc:	0712                	slli	a4,a4,0x4
 6be:	9736                	add	a4,a4,a3
 6c0:	fae60ae3          	beq	a2,a4,674 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6c4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6c8:	4790                	lw	a2,8(a5)
 6ca:	02061713          	slli	a4,a2,0x20
 6ce:	9301                	srli	a4,a4,0x20
 6d0:	0712                	slli	a4,a4,0x4
 6d2:	973e                	add	a4,a4,a5
 6d4:	fae689e3          	beq	a3,a4,686 <free+0x26>
  } else
    p->s.ptr = bp;
 6d8:	e394                	sd	a3,0(a5)
  freep = p;
 6da:	00001717          	auipc	a4,0x1
 6de:	92f73323          	sd	a5,-1754(a4) # 1000 <freep>
}
 6e2:	6422                	ld	s0,8(sp)
 6e4:	0141                	addi	sp,sp,16
 6e6:	8082                	ret

00000000000006e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e8:	7139                	addi	sp,sp,-64
 6ea:	fc06                	sd	ra,56(sp)
 6ec:	f822                	sd	s0,48(sp)
 6ee:	f426                	sd	s1,40(sp)
 6f0:	f04a                	sd	s2,32(sp)
 6f2:	ec4e                	sd	s3,24(sp)
 6f4:	e852                	sd	s4,16(sp)
 6f6:	e456                	sd	s5,8(sp)
 6f8:	e05a                	sd	s6,0(sp)
 6fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fc:	02051493          	slli	s1,a0,0x20
 700:	9081                	srli	s1,s1,0x20
 702:	04bd                	addi	s1,s1,15
 704:	8091                	srli	s1,s1,0x4
 706:	0014899b          	addiw	s3,s1,1
 70a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 70c:	00001517          	auipc	a0,0x1
 710:	8f453503          	ld	a0,-1804(a0) # 1000 <freep>
 714:	c515                	beqz	a0,740 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 716:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 718:	4798                	lw	a4,8(a5)
 71a:	02977f63          	bgeu	a4,s1,758 <malloc+0x70>
 71e:	8a4e                	mv	s4,s3
 720:	0009871b          	sext.w	a4,s3
 724:	6685                	lui	a3,0x1
 726:	00d77363          	bgeu	a4,a3,72c <malloc+0x44>
 72a:	6a05                	lui	s4,0x1
 72c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 730:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 734:	00001917          	auipc	s2,0x1
 738:	8cc90913          	addi	s2,s2,-1844 # 1000 <freep>
  if(p == (char*)-1)
 73c:	5afd                	li	s5,-1
 73e:	a88d                	j	7b0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 740:	00001797          	auipc	a5,0x1
 744:	8d078793          	addi	a5,a5,-1840 # 1010 <base>
 748:	00001717          	auipc	a4,0x1
 74c:	8af73c23          	sd	a5,-1864(a4) # 1000 <freep>
 750:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 752:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 756:	b7e1                	j	71e <malloc+0x36>
      if(p->s.size == nunits)
 758:	02e48b63          	beq	s1,a4,78e <malloc+0xa6>
        p->s.size -= nunits;
 75c:	4137073b          	subw	a4,a4,s3
 760:	c798                	sw	a4,8(a5)
        p += p->s.size;
 762:	1702                	slli	a4,a4,0x20
 764:	9301                	srli	a4,a4,0x20
 766:	0712                	slli	a4,a4,0x4
 768:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 76a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 76e:	00001717          	auipc	a4,0x1
 772:	88a73923          	sd	a0,-1902(a4) # 1000 <freep>
      return (void*)(p + 1);
 776:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 77a:	70e2                	ld	ra,56(sp)
 77c:	7442                	ld	s0,48(sp)
 77e:	74a2                	ld	s1,40(sp)
 780:	7902                	ld	s2,32(sp)
 782:	69e2                	ld	s3,24(sp)
 784:	6a42                	ld	s4,16(sp)
 786:	6aa2                	ld	s5,8(sp)
 788:	6b02                	ld	s6,0(sp)
 78a:	6121                	addi	sp,sp,64
 78c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 78e:	6398                	ld	a4,0(a5)
 790:	e118                	sd	a4,0(a0)
 792:	bff1                	j	76e <malloc+0x86>
  hp->s.size = nu;
 794:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 798:	0541                	addi	a0,a0,16
 79a:	00000097          	auipc	ra,0x0
 79e:	ec6080e7          	jalr	-314(ra) # 660 <free>
  return freep;
 7a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7a6:	d971                	beqz	a0,77a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7aa:	4798                	lw	a4,8(a5)
 7ac:	fa9776e3          	bgeu	a4,s1,758 <malloc+0x70>
    if(p == freep)
 7b0:	00093703          	ld	a4,0(s2)
 7b4:	853e                	mv	a0,a5
 7b6:	fef719e3          	bne	a4,a5,7a8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7ba:	8552                	mv	a0,s4
 7bc:	00000097          	auipc	ra,0x0
 7c0:	b76080e7          	jalr	-1162(ra) # 332 <sbrk>
  if(p == (char*)-1)
 7c4:	fd5518e3          	bne	a0,s5,794 <malloc+0xac>
        return 0;
 7c8:	4501                	li	a0,0
 7ca:	bf45                	j	77a <malloc+0x92>
