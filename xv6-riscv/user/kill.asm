
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   c:	4785                	li	a5,1
   e:	04a7d163          	bge	a5,a0,50 <main+0x50>
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	1902                	slli	s2,s2,0x20
  1c:	02095913          	srli	s2,s2,0x20
  20:	090e                	slli	s2,s2,0x3
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1,"");
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1e0080e7          	jalr	480(ra) # 208 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	304080e7          	jalr	772(ra) # 334 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	addi	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0,"");
  3e:	00001597          	auipc	a1,0x1
  42:	82a58593          	addi	a1,a1,-2006 # 868 <malloc+0x106>
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	2bc080e7          	jalr	700(ra) # 304 <exit>
    fprintf(2, "usage: kill pid...\n");
  50:	00001597          	auipc	a1,0x1
  54:	80058593          	addi	a1,a1,-2048 # 850 <malloc+0xee>
  58:	4509                	li	a0,2
  5a:	00000097          	auipc	ra,0x0
  5e:	61c080e7          	jalr	1564(ra) # 676 <fprintf>
    exit(1,"");
  62:	00001597          	auipc	a1,0x1
  66:	80658593          	addi	a1,a1,-2042 # 868 <malloc+0x106>
  6a:	4505                	li	a0,1
  6c:	00000097          	auipc	ra,0x0
  70:	298080e7          	jalr	664(ra) # 304 <exit>

0000000000000074 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  7c:	00000097          	auipc	ra,0x0
  80:	f84080e7          	jalr	-124(ra) # 0 <main>
  exit(0,"");
  84:	00000597          	auipc	a1,0x0
  88:	7e458593          	addi	a1,a1,2020 # 868 <malloc+0x106>
  8c:	4501                	li	a0,0
  8e:	00000097          	auipc	ra,0x0
  92:	276080e7          	jalr	630(ra) # 304 <exit>

0000000000000096 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  96:	1141                	addi	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9c:	87aa                	mv	a5,a0
  9e:	0585                	addi	a1,a1,1
  a0:	0785                	addi	a5,a5,1
  a2:	fff5c703          	lbu	a4,-1(a1)
  a6:	fee78fa3          	sb	a4,-1(a5)
  aa:	fb75                	bnez	a4,9e <strcpy+0x8>
    ;
  return os;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret

00000000000000b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e422                	sd	s0,8(sp)
  b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cb91                	beqz	a5,d0 <strcmp+0x1e>
  be:	0005c703          	lbu	a4,0(a1)
  c2:	00f71763          	bne	a4,a5,d0 <strcmp+0x1e>
    p++, q++;
  c6:	0505                	addi	a0,a0,1
  c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	fbe5                	bnez	a5,be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d0:	0005c503          	lbu	a0,0(a1)
}
  d4:	40a7853b          	subw	a0,a5,a0
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x26>
  ea:	0505                	addi	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	4685                	li	a3,1
  f0:	9e89                	subw	a3,a3,a0
  f2:	00f6853b          	addw	a0,a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	fb7d                	bnez	a4,f2 <strlen+0x14>
    ;
  return n;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for(n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfe5                	j	fe <strlen+0x20>

0000000000000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10e:	ca19                	beqz	a2,124 <memset+0x1c>
 110:	87aa                	mv	a5,a0
 112:	1602                	slli	a2,a2,0x20
 114:	9201                	srli	a2,a2,0x20
 116:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11e:	0785                	addi	a5,a5,1
 120:	fee79de3          	bne	a5,a4,11a <memset+0x12>
  }
  return dst;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strchr>:

char*
strchr(const char *s, char c)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb99                	beqz	a5,14a <strchr+0x20>
    if(*s == c)
 136:	00f58763          	beq	a1,a5,144 <strchr+0x1a>
  for(; *s; s++)
 13a:	0505                	addi	a0,a0,1
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbfd                	bnez	a5,136 <strchr+0xc>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfe5                	j	144 <strchr+0x1a>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	addi	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	1080                	addi	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4aa9                	li	s5,10
 16e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	2485                	addiw	s1,s1,1
 174:	0344d863          	bge	s1,s4,1a4 <gets+0x56>
    cc = read(0, &c, 1);
 178:	4605                	li	a2,1
 17a:	faf40593          	addi	a1,s0,-81
 17e:	4501                	li	a0,0
 180:	00000097          	auipc	ra,0x0
 184:	19c080e7          	jalr	412(ra) # 31c <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x56>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x54>
 198:	0905                	addi	s2,s2,1
 19a:	fd679be3          	bne	a5,s6,170 <gets+0x22>
  for(i=0; i+1 < max; ){
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x56>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	addi	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c2:	1101                	addi	sp,sp,-32
 1c4:	ec06                	sd	ra,24(sp)
 1c6:	e822                	sd	s0,16(sp)
 1c8:	e426                	sd	s1,8(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	00000097          	auipc	ra,0x0
 1d6:	172080e7          	jalr	370(ra) # 344 <open>
  if(fd < 0)
 1da:	02054563          	bltz	a0,204 <stat+0x42>
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	00000097          	auipc	ra,0x0
 1e6:	17a080e7          	jalr	378(ra) # 35c <fstat>
 1ea:	892a                	mv	s2,a0
  close(fd);
 1ec:	8526                	mv	a0,s1
 1ee:	00000097          	auipc	ra,0x0
 1f2:	13e080e7          	jalr	318(ra) # 32c <close>
  return r;
}
 1f6:	854a                	mv	a0,s2
 1f8:	60e2                	ld	ra,24(sp)
 1fa:	6442                	ld	s0,16(sp)
 1fc:	64a2                	ld	s1,8(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	597d                	li	s2,-1
 206:	bfc5                	j	1f6 <stat+0x34>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20e:	00054603          	lbu	a2,0(a0)
 212:	fd06079b          	addiw	a5,a2,-48
 216:	0ff7f793          	andi	a5,a5,255
 21a:	4725                	li	a4,9
 21c:	02f76963          	bltu	a4,a5,24e <atoi+0x46>
 220:	86aa                	mv	a3,a0
  n = 0;
 222:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 224:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 226:	0685                	addi	a3,a3,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb1                	addw	a5,a5,a2
 234:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 238:	0006c603          	lbu	a2,0(a3)
 23c:	fd06071b          	addiw	a4,a2,-48
 240:	0ff77713          	andi	a4,a4,255
 244:	fee5f1e3          	bgeu	a1,a4,226 <atoi+0x1e>
  return n;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
  n = 0;
 24e:	4501                	li	a0,0
 250:	bfe5                	j	248 <atoi+0x40>

0000000000000252 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e422                	sd	s0,8(sp)
 256:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 258:	02b57463          	bgeu	a0,a1,280 <memmove+0x2e>
    while(n-- > 0)
 25c:	00c05f63          	blez	a2,27a <memmove+0x28>
 260:	1602                	slli	a2,a2,0x20
 262:	9201                	srli	a2,a2,0x20
 264:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 268:	872a                	mv	a4,a0
      *dst++ = *src++;
 26a:	0585                	addi	a1,a1,1
 26c:	0705                	addi	a4,a4,1
 26e:	fff5c683          	lbu	a3,-1(a1)
 272:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 276:	fee79ae3          	bne	a5,a4,26a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret
    dst += n;
 280:	00c50733          	add	a4,a0,a2
    src += n;
 284:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 286:	fec05ae3          	blez	a2,27a <memmove+0x28>
 28a:	fff6079b          	addiw	a5,a2,-1
 28e:	1782                	slli	a5,a5,0x20
 290:	9381                	srli	a5,a5,0x20
 292:	fff7c793          	not	a5,a5
 296:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 298:	15fd                	addi	a1,a1,-1
 29a:	177d                	addi	a4,a4,-1
 29c:	0005c683          	lbu	a3,0(a1)
 2a0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a4:	fee79ae3          	bne	a5,a4,298 <memmove+0x46>
 2a8:	bfc9                	j	27a <memmove+0x28>

00000000000002aa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca05                	beqz	a2,2e0 <memcmp+0x36>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x14>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x30>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  return 0;
 2e0:	4501                	li	a0,0
 2e2:	bfe5                	j	2da <memcmp+0x30>

00000000000002e4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ec:	00000097          	auipc	ra,0x0
 2f0:	f66080e7          	jalr	-154(ra) # 252 <memmove>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	00000097          	auipc	ra,0x0
 3e2:	f46080e7          	jalr	-186(ra) # 324 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ee:	7139                	addi	sp,sp,-64
 3f0:	fc06                	sd	ra,56(sp)
 3f2:	f822                	sd	s0,48(sp)
 3f4:	f426                	sd	s1,40(sp)
 3f6:	f04a                	sd	s2,32(sp)
 3f8:	ec4e                	sd	s3,24(sp)
 3fa:	0080                	addi	s0,sp,64
 3fc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fe:	c299                	beqz	a3,404 <printint+0x16>
 400:	0805c863          	bltz	a1,490 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 404:	2581                	sext.w	a1,a1
  neg = 0;
 406:	4881                	li	a7,0
 408:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40e:	2601                	sext.w	a2,a2
 410:	00000517          	auipc	a0,0x0
 414:	46850513          	addi	a0,a0,1128 # 878 <digits>
 418:	883a                	mv	a6,a4
 41a:	2705                	addiw	a4,a4,1
 41c:	02c5f7bb          	remuw	a5,a1,a2
 420:	1782                	slli	a5,a5,0x20
 422:	9381                	srli	a5,a5,0x20
 424:	97aa                	add	a5,a5,a0
 426:	0007c783          	lbu	a5,0(a5)
 42a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42e:	0005879b          	sext.w	a5,a1
 432:	02c5d5bb          	divuw	a1,a1,a2
 436:	0685                	addi	a3,a3,1
 438:	fec7f0e3          	bgeu	a5,a2,418 <printint+0x2a>
  if(neg)
 43c:	00088b63          	beqz	a7,452 <printint+0x64>
    buf[i++] = '-';
 440:	fd040793          	addi	a5,s0,-48
 444:	973e                	add	a4,a4,a5
 446:	02d00793          	li	a5,45
 44a:	fef70823          	sb	a5,-16(a4)
 44e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 452:	02e05863          	blez	a4,482 <printint+0x94>
 456:	fc040793          	addi	a5,s0,-64
 45a:	00e78933          	add	s2,a5,a4
 45e:	fff78993          	addi	s3,a5,-1
 462:	99ba                	add	s3,s3,a4
 464:	377d                	addiw	a4,a4,-1
 466:	1702                	slli	a4,a4,0x20
 468:	9301                	srli	a4,a4,0x20
 46a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46e:	fff94583          	lbu	a1,-1(s2)
 472:	8526                	mv	a0,s1
 474:	00000097          	auipc	ra,0x0
 478:	f58080e7          	jalr	-168(ra) # 3cc <putc>
  while(--i >= 0)
 47c:	197d                	addi	s2,s2,-1
 47e:	ff3918e3          	bne	s2,s3,46e <printint+0x80>
}
 482:	70e2                	ld	ra,56(sp)
 484:	7442                	ld	s0,48(sp)
 486:	74a2                	ld	s1,40(sp)
 488:	7902                	ld	s2,32(sp)
 48a:	69e2                	ld	s3,24(sp)
 48c:	6121                	addi	sp,sp,64
 48e:	8082                	ret
    x = -xx;
 490:	40b005bb          	negw	a1,a1
    neg = 1;
 494:	4885                	li	a7,1
    x = -xx;
 496:	bf8d                	j	408 <printint+0x1a>

0000000000000498 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 498:	7119                	addi	sp,sp,-128
 49a:	fc86                	sd	ra,120(sp)
 49c:	f8a2                	sd	s0,112(sp)
 49e:	f4a6                	sd	s1,104(sp)
 4a0:	f0ca                	sd	s2,96(sp)
 4a2:	ecce                	sd	s3,88(sp)
 4a4:	e8d2                	sd	s4,80(sp)
 4a6:	e4d6                	sd	s5,72(sp)
 4a8:	e0da                	sd	s6,64(sp)
 4aa:	fc5e                	sd	s7,56(sp)
 4ac:	f862                	sd	s8,48(sp)
 4ae:	f466                	sd	s9,40(sp)
 4b0:	f06a                	sd	s10,32(sp)
 4b2:	ec6e                	sd	s11,24(sp)
 4b4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b6:	0005c903          	lbu	s2,0(a1)
 4ba:	18090f63          	beqz	s2,658 <vprintf+0x1c0>
 4be:	8aaa                	mv	s5,a0
 4c0:	8b32                	mv	s6,a2
 4c2:	00158493          	addi	s1,a1,1
  state = 0;
 4c6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4c8:	02500a13          	li	s4,37
      if(c == 'd'){
 4cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4d0:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4d4:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4d8:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4dc:	00000b97          	auipc	s7,0x0
 4e0:	39cb8b93          	addi	s7,s7,924 # 878 <digits>
 4e4:	a839                	j	502 <vprintf+0x6a>
        putc(fd, c);
 4e6:	85ca                	mv	a1,s2
 4e8:	8556                	mv	a0,s5
 4ea:	00000097          	auipc	ra,0x0
 4ee:	ee2080e7          	jalr	-286(ra) # 3cc <putc>
 4f2:	a019                	j	4f8 <vprintf+0x60>
    } else if(state == '%'){
 4f4:	01498f63          	beq	s3,s4,512 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4f8:	0485                	addi	s1,s1,1
 4fa:	fff4c903          	lbu	s2,-1(s1)
 4fe:	14090d63          	beqz	s2,658 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 502:	0009079b          	sext.w	a5,s2
    if(state == 0){
 506:	fe0997e3          	bnez	s3,4f4 <vprintf+0x5c>
      if(c == '%'){
 50a:	fd479ee3          	bne	a5,s4,4e6 <vprintf+0x4e>
        state = '%';
 50e:	89be                	mv	s3,a5
 510:	b7e5                	j	4f8 <vprintf+0x60>
      if(c == 'd'){
 512:	05878063          	beq	a5,s8,552 <vprintf+0xba>
      } else if(c == 'l') {
 516:	05978c63          	beq	a5,s9,56e <vprintf+0xd6>
      } else if(c == 'x') {
 51a:	07a78863          	beq	a5,s10,58a <vprintf+0xf2>
      } else if(c == 'p') {
 51e:	09b78463          	beq	a5,s11,5a6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 522:	07300713          	li	a4,115
 526:	0ce78663          	beq	a5,a4,5f2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52a:	06300713          	li	a4,99
 52e:	0ee78e63          	beq	a5,a4,62a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 532:	11478863          	beq	a5,s4,642 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 536:	85d2                	mv	a1,s4
 538:	8556                	mv	a0,s5
 53a:	00000097          	auipc	ra,0x0
 53e:	e92080e7          	jalr	-366(ra) # 3cc <putc>
        putc(fd, c);
 542:	85ca                	mv	a1,s2
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e86080e7          	jalr	-378(ra) # 3cc <putc>
      }
      state = 0;
 54e:	4981                	li	s3,0
 550:	b765                	j	4f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 552:	008b0913          	addi	s2,s6,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000b2583          	lw	a1,0(s6)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e8e080e7          	jalr	-370(ra) # 3ee <printint>
 568:	8b4a                	mv	s6,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b771                	j	4f8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	008b0913          	addi	s2,s6,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000b2583          	lw	a1,0(s6)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e72080e7          	jalr	-398(ra) # 3ee <printint>
 584:	8b4a                	mv	s6,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	bf85                	j	4f8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 58a:	008b0913          	addi	s2,s6,8
 58e:	4681                	li	a3,0
 590:	4641                	li	a2,16
 592:	000b2583          	lw	a1,0(s6)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e56080e7          	jalr	-426(ra) # 3ee <printint>
 5a0:	8b4a                	mv	s6,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bf91                	j	4f8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a6:	008b0793          	addi	a5,s6,8
 5aa:	f8f43423          	sd	a5,-120(s0)
 5ae:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b2:	03000593          	li	a1,48
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e14080e7          	jalr	-492(ra) # 3cc <putc>
  putc(fd, 'x');
 5c0:	85ea                	mv	a1,s10
 5c2:	8556                	mv	a0,s5
 5c4:	00000097          	auipc	ra,0x0
 5c8:	e08080e7          	jalr	-504(ra) # 3cc <putc>
 5cc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ce:	03c9d793          	srli	a5,s3,0x3c
 5d2:	97de                	add	a5,a5,s7
 5d4:	0007c583          	lbu	a1,0(a5)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	df2080e7          	jalr	-526(ra) # 3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e2:	0992                	slli	s3,s3,0x4
 5e4:	397d                	addiw	s2,s2,-1
 5e6:	fe0914e3          	bnez	s2,5ce <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ea:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b721                	j	4f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 5f2:	008b0993          	addi	s3,s6,8
 5f6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5fa:	02090163          	beqz	s2,61c <vprintf+0x184>
        while(*s != 0){
 5fe:	00094583          	lbu	a1,0(s2)
 602:	c9a1                	beqz	a1,652 <vprintf+0x1ba>
          putc(fd, *s);
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	dc6080e7          	jalr	-570(ra) # 3cc <putc>
          s++;
 60e:	0905                	addi	s2,s2,1
        while(*s != 0){
 610:	00094583          	lbu	a1,0(s2)
 614:	f9e5                	bnez	a1,604 <vprintf+0x16c>
        s = va_arg(ap, char*);
 616:	8b4e                	mv	s6,s3
      state = 0;
 618:	4981                	li	s3,0
 61a:	bdf9                	j	4f8 <vprintf+0x60>
          s = "(null)";
 61c:	00000917          	auipc	s2,0x0
 620:	25490913          	addi	s2,s2,596 # 870 <malloc+0x10e>
        while(*s != 0){
 624:	02800593          	li	a1,40
 628:	bff1                	j	604 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 62a:	008b0913          	addi	s2,s6,8
 62e:	000b4583          	lbu	a1,0(s6)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	d98080e7          	jalr	-616(ra) # 3cc <putc>
 63c:	8b4a                	mv	s6,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	bd65                	j	4f8 <vprintf+0x60>
        putc(fd, c);
 642:	85d2                	mv	a1,s4
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	d86080e7          	jalr	-634(ra) # 3cc <putc>
      state = 0;
 64e:	4981                	li	s3,0
 650:	b565                	j	4f8 <vprintf+0x60>
        s = va_arg(ap, char*);
 652:	8b4e                	mv	s6,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	b54d                	j	4f8 <vprintf+0x60>
    }
  }
}
 658:	70e6                	ld	ra,120(sp)
 65a:	7446                	ld	s0,112(sp)
 65c:	74a6                	ld	s1,104(sp)
 65e:	7906                	ld	s2,96(sp)
 660:	69e6                	ld	s3,88(sp)
 662:	6a46                	ld	s4,80(sp)
 664:	6aa6                	ld	s5,72(sp)
 666:	6b06                	ld	s6,64(sp)
 668:	7be2                	ld	s7,56(sp)
 66a:	7c42                	ld	s8,48(sp)
 66c:	7ca2                	ld	s9,40(sp)
 66e:	7d02                	ld	s10,32(sp)
 670:	6de2                	ld	s11,24(sp)
 672:	6109                	addi	sp,sp,128
 674:	8082                	ret

0000000000000676 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 676:	715d                	addi	sp,sp,-80
 678:	ec06                	sd	ra,24(sp)
 67a:	e822                	sd	s0,16(sp)
 67c:	1000                	addi	s0,sp,32
 67e:	e010                	sd	a2,0(s0)
 680:	e414                	sd	a3,8(s0)
 682:	e818                	sd	a4,16(s0)
 684:	ec1c                	sd	a5,24(s0)
 686:	03043023          	sd	a6,32(s0)
 68a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 692:	8622                	mv	a2,s0
 694:	00000097          	auipc	ra,0x0
 698:	e04080e7          	jalr	-508(ra) # 498 <vprintf>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret

00000000000006a4 <printf>:

void
printf(const char *fmt, ...)
{
 6a4:	711d                	addi	sp,sp,-96
 6a6:	ec06                	sd	ra,24(sp)
 6a8:	e822                	sd	s0,16(sp)
 6aa:	1000                	addi	s0,sp,32
 6ac:	e40c                	sd	a1,8(s0)
 6ae:	e810                	sd	a2,16(s0)
 6b0:	ec14                	sd	a3,24(s0)
 6b2:	f018                	sd	a4,32(s0)
 6b4:	f41c                	sd	a5,40(s0)
 6b6:	03043823          	sd	a6,48(s0)
 6ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6be:	00840613          	addi	a2,s0,8
 6c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c6:	85aa                	mv	a1,a0
 6c8:	4505                	li	a0,1
 6ca:	00000097          	auipc	ra,0x0
 6ce:	dce080e7          	jalr	-562(ra) # 498 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	addi	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00001797          	auipc	a5,0x1
 6e8:	91c7b783          	ld	a5,-1764(a5) # 1000 <freep>
 6ec:	a805                	j	71c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ee:	4618                	lw	a4,8(a2)
 6f0:	9db9                	addw	a1,a1,a4
 6f2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	6398                	ld	a4,0(a5)
 6f8:	6318                	ld	a4,0(a4)
 6fa:	fee53823          	sd	a4,-16(a0)
 6fe:	a091                	j	742 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 700:	ff852703          	lw	a4,-8(a0)
 704:	9e39                	addw	a2,a2,a4
 706:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 708:	ff053703          	ld	a4,-16(a0)
 70c:	e398                	sd	a4,0(a5)
 70e:	a099                	j	754 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 710:	6398                	ld	a4,0(a5)
 712:	00e7e463          	bltu	a5,a4,71a <free+0x40>
 716:	00e6ea63          	bltu	a3,a4,72a <free+0x50>
{
 71a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71c:	fed7fae3          	bgeu	a5,a3,710 <free+0x36>
 720:	6398                	ld	a4,0(a5)
 722:	00e6e463          	bltu	a3,a4,72a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 726:	fee7eae3          	bltu	a5,a4,71a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 72a:	ff852583          	lw	a1,-8(a0)
 72e:	6390                	ld	a2,0(a5)
 730:	02059713          	slli	a4,a1,0x20
 734:	9301                	srli	a4,a4,0x20
 736:	0712                	slli	a4,a4,0x4
 738:	9736                	add	a4,a4,a3
 73a:	fae60ae3          	beq	a2,a4,6ee <free+0x14>
    bp->s.ptr = p->s.ptr;
 73e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 742:	4790                	lw	a2,8(a5)
 744:	02061713          	slli	a4,a2,0x20
 748:	9301                	srli	a4,a4,0x20
 74a:	0712                	slli	a4,a4,0x4
 74c:	973e                	add	a4,a4,a5
 74e:	fae689e3          	beq	a3,a4,700 <free+0x26>
  } else
    p->s.ptr = bp;
 752:	e394                	sd	a3,0(a5)
  freep = p;
 754:	00001717          	auipc	a4,0x1
 758:	8af73623          	sd	a5,-1876(a4) # 1000 <freep>
}
 75c:	6422                	ld	s0,8(sp)
 75e:	0141                	addi	sp,sp,16
 760:	8082                	ret

0000000000000762 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 762:	7139                	addi	sp,sp,-64
 764:	fc06                	sd	ra,56(sp)
 766:	f822                	sd	s0,48(sp)
 768:	f426                	sd	s1,40(sp)
 76a:	f04a                	sd	s2,32(sp)
 76c:	ec4e                	sd	s3,24(sp)
 76e:	e852                	sd	s4,16(sp)
 770:	e456                	sd	s5,8(sp)
 772:	e05a                	sd	s6,0(sp)
 774:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 776:	02051493          	slli	s1,a0,0x20
 77a:	9081                	srli	s1,s1,0x20
 77c:	04bd                	addi	s1,s1,15
 77e:	8091                	srli	s1,s1,0x4
 780:	0014899b          	addiw	s3,s1,1
 784:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 786:	00001517          	auipc	a0,0x1
 78a:	87a53503          	ld	a0,-1926(a0) # 1000 <freep>
 78e:	c515                	beqz	a0,7ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 790:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 792:	4798                	lw	a4,8(a5)
 794:	02977f63          	bgeu	a4,s1,7d2 <malloc+0x70>
 798:	8a4e                	mv	s4,s3
 79a:	0009871b          	sext.w	a4,s3
 79e:	6685                	lui	a3,0x1
 7a0:	00d77363          	bgeu	a4,a3,7a6 <malloc+0x44>
 7a4:	6a05                	lui	s4,0x1
 7a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ae:	00001917          	auipc	s2,0x1
 7b2:	85290913          	addi	s2,s2,-1966 # 1000 <freep>
  if(p == (char*)-1)
 7b6:	5afd                	li	s5,-1
 7b8:	a88d                	j	82a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7ba:	00001797          	auipc	a5,0x1
 7be:	85678793          	addi	a5,a5,-1962 # 1010 <base>
 7c2:	00001717          	auipc	a4,0x1
 7c6:	82f73f23          	sd	a5,-1986(a4) # 1000 <freep>
 7ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7cc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d0:	b7e1                	j	798 <malloc+0x36>
      if(p->s.size == nunits)
 7d2:	02e48b63          	beq	s1,a4,808 <malloc+0xa6>
        p->s.size -= nunits;
 7d6:	4137073b          	subw	a4,a4,s3
 7da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7dc:	1702                	slli	a4,a4,0x20
 7de:	9301                	srli	a4,a4,0x20
 7e0:	0712                	slli	a4,a4,0x4
 7e2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e8:	00001717          	auipc	a4,0x1
 7ec:	80a73c23          	sd	a0,-2024(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f4:	70e2                	ld	ra,56(sp)
 7f6:	7442                	ld	s0,48(sp)
 7f8:	74a2                	ld	s1,40(sp)
 7fa:	7902                	ld	s2,32(sp)
 7fc:	69e2                	ld	s3,24(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
 804:	6121                	addi	sp,sp,64
 806:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	e118                	sd	a4,0(a0)
 80c:	bff1                	j	7e8 <malloc+0x86>
  hp->s.size = nu;
 80e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 812:	0541                	addi	a0,a0,16
 814:	00000097          	auipc	ra,0x0
 818:	ec6080e7          	jalr	-314(ra) # 6da <free>
  return freep;
 81c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 820:	d971                	beqz	a0,7f4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 824:	4798                	lw	a4,8(a5)
 826:	fa9776e3          	bgeu	a4,s1,7d2 <malloc+0x70>
    if(p == freep)
 82a:	00093703          	ld	a4,0(s2)
 82e:	853e                	mv	a0,a5
 830:	fef719e3          	bne	a4,a5,822 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 834:	8552                	mv	a0,s4
 836:	00000097          	auipc	ra,0x0
 83a:	b56080e7          	jalr	-1194(ra) # 38c <sbrk>
  if(p == (char*)-1)
 83e:	fd5518e3          	bne	a0,s5,80e <malloc+0xac>
        return 0;
 842:	4501                	li	a0,0
 844:	bf45                	j	7f4 <malloc+0x92>
