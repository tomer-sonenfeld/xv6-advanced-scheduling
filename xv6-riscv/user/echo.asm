
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  int i;

  for(i = 1; i < argc; i++){
  10:	4785                	li	a5,1
  12:	06a7d463          	bge	a5,a0,7a <main+0x7a>
  16:	00858493          	addi	s1,a1,8
  1a:	ffe5099b          	addiw	s3,a0,-2
  1e:	1982                	slli	s3,s3,0x20
  20:	0209d993          	srli	s3,s3,0x20
  24:	098e                	slli	s3,s3,0x3
  26:	05c1                	addi	a1,a1,16
  28:	99ae                	add	s3,s3,a1
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  2a:	00001a17          	auipc	s4,0x1
  2e:	826a0a13          	addi	s4,s4,-2010 # 850 <malloc+0xee>
    write(1, argv[i], strlen(argv[i]));
  32:	0004b903          	ld	s2,0(s1)
  36:	854a                	mv	a0,s2
  38:	00000097          	auipc	ra,0x0
  3c:	0be080e7          	jalr	190(ra) # f6 <strlen>
  40:	0005061b          	sext.w	a2,a0
  44:	85ca                	mv	a1,s2
  46:	4505                	li	a0,1
  48:	00000097          	auipc	ra,0x0
  4c:	2f4080e7          	jalr	756(ra) # 33c <write>
    if(i + 1 < argc){
  50:	04a1                	addi	s1,s1,8
  52:	01348a63          	beq	s1,s3,66 <main+0x66>
      write(1, " ", 1);
  56:	4605                	li	a2,1
  58:	85d2                	mv	a1,s4
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	2e0080e7          	jalr	736(ra) # 33c <write>
  for(i = 1; i < argc; i++){
  64:	b7f9                	j	32 <main+0x32>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00000597          	auipc	a1,0x0
  6c:	7f058593          	addi	a1,a1,2032 # 858 <malloc+0xf6>
  70:	4505                	li	a0,1
  72:	00000097          	auipc	ra,0x0
  76:	2ca080e7          	jalr	714(ra) # 33c <write>
    }
  }
  exit(0,"");
  7a:	00000597          	auipc	a1,0x0
  7e:	7e658593          	addi	a1,a1,2022 # 860 <malloc+0xfe>
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	298080e7          	jalr	664(ra) # 31c <exit>

000000000000008c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  extern int main();
  main();
  94:	00000097          	auipc	ra,0x0
  98:	f6c080e7          	jalr	-148(ra) # 0 <main>
  exit(0,"");
  9c:	00000597          	auipc	a1,0x0
  a0:	7c458593          	addi	a1,a1,1988 # 860 <malloc+0xfe>
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	276080e7          	jalr	630(ra) # 31c <exit>

00000000000000ae <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b4:	87aa                	mv	a5,a0
  b6:	0585                	addi	a1,a1,1
  b8:	0785                	addi	a5,a5,1
  ba:	fff5c703          	lbu	a4,-1(a1)
  be:	fee78fa3          	sb	a4,-1(a5)
  c2:	fb75                	bnez	a4,b6 <strcpy+0x8>
    ;
  return os;
}
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cb91                	beqz	a5,e8 <strcmp+0x1e>
  d6:	0005c703          	lbu	a4,0(a1)
  da:	00f71763          	bne	a4,a5,e8 <strcmp+0x1e>
    p++, q++;
  de:	0505                	addi	a0,a0,1
  e0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	fbe5                	bnez	a5,d6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e8:	0005c503          	lbu	a0,0(a1)
}
  ec:	40a7853b          	subw	a0,a5,a0
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strlen>:

uint
strlen(const char *s)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cf91                	beqz	a5,11c <strlen+0x26>
 102:	0505                	addi	a0,a0,1
 104:	87aa                	mv	a5,a0
 106:	4685                	li	a3,1
 108:	9e89                	subw	a3,a3,a0
 10a:	00f6853b          	addw	a0,a3,a5
 10e:	0785                	addi	a5,a5,1
 110:	fff7c703          	lbu	a4,-1(a5)
 114:	fb7d                	bnez	a4,10a <strlen+0x14>
    ;
  return n;
}
 116:	6422                	ld	s0,8(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret
  for(n = 0; s[n]; n++)
 11c:	4501                	li	a0,0
 11e:	bfe5                	j	116 <strlen+0x20>

0000000000000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 126:	ca19                	beqz	a2,13c <memset+0x1c>
 128:	87aa                	mv	a5,a0
 12a:	1602                	slli	a2,a2,0x20
 12c:	9201                	srli	a2,a2,0x20
 12e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x12>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	19c080e7          	jalr	412(ra) # 334 <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	172080e7          	jalr	370(ra) # 35c <open>
  if(fd < 0)
 1f2:	02054563          	bltz	a0,21c <stat+0x42>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	17a080e7          	jalr	378(ra) # 374 <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	13e080e7          	jalr	318(ra) # 344 <close>
  return r;
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	64a2                	ld	s1,8(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfc5                	j	20e <stat+0x34>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054603          	lbu	a2,0(a0)
 22a:	fd06079b          	addiw	a5,a2,-48
 22e:	0ff7f793          	andi	a5,a5,255
 232:	4725                	li	a4,9
 234:	02f76963          	bltu	a4,a5,266 <atoi+0x46>
 238:	86aa                	mv	a3,a0
  n = 0;
 23a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 23c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 23e:	0685                	addi	a3,a3,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb1                	addw	a5,a5,a2
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	0006c603          	lbu	a2,0(a3)
 254:	fd06071b          	addiw	a4,a2,-48
 258:	0ff77713          	andi	a4,a4,255
 25c:	fee5f1e3          	bgeu	a1,a4,23e <atoi+0x1e>
  return n;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  n = 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <atoi+0x40>

000000000000026a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57463          	bgeu	a0,a1,298 <memmove+0x2e>
    while(n-- > 0)
 274:	00c05f63          	blez	a2,292 <memmove+0x28>
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 280:	872a                	mv	a4,a0
      *dst++ = *src++;
 282:	0585                	addi	a1,a1,1
 284:	0705                	addi	a4,a4,1
 286:	fff5c683          	lbu	a3,-1(a1)
 28a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
    dst += n;
 298:	00c50733          	add	a4,a0,a2
    src += n;
 29c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 29e:	fec05ae3          	blez	a2,292 <memmove+0x28>
 2a2:	fff6079b          	addiw	a5,a2,-1
 2a6:	1782                	slli	a5,a5,0x20
 2a8:	9381                	srli	a5,a5,0x20
 2aa:	fff7c793          	not	a5,a5
 2ae:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b0:	15fd                	addi	a1,a1,-1
 2b2:	177d                	addi	a4,a4,-1
 2b4:	0005c683          	lbu	a3,0(a1)
 2b8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2bc:	fee79ae3          	bne	a5,a4,2b0 <memmove+0x46>
 2c0:	bfc9                	j	292 <memmove+0x28>

00000000000002c2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c8:	ca05                	beqz	a2,2f8 <memcmp+0x36>
 2ca:	fff6069b          	addiw	a3,a2,-1
 2ce:	1682                	slli	a3,a3,0x20
 2d0:	9281                	srli	a3,a3,0x20
 2d2:	0685                	addi	a3,a3,1
 2d4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	0005c703          	lbu	a4,0(a1)
 2de:	00e79863          	bne	a5,a4,2ee <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e2:	0505                	addi	a0,a0,1
    p2++;
 2e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e6:	fed518e3          	bne	a0,a3,2d6 <memcmp+0x14>
  }
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	a019                	j	2f2 <memcmp+0x30>
      return *p1 - *p2;
 2ee:	40e7853b          	subw	a0,a5,a4
}
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	bfe5                	j	2f2 <memcmp+0x30>

00000000000002fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 304:	00000097          	auipc	ra,0x0
 308:	f66080e7          	jalr	-154(ra) # 26a <memmove>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 3c4:	48dd                	li	a7,23
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
 3e2:	f5e080e7          	jalr	-162(ra) # 33c <write>
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
 414:	46050513          	addi	a0,a0,1120 # 870 <digits>
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
 4e0:	394b8b93          	addi	s7,s7,916 # 870 <digits>
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
 620:	24c90913          	addi	s2,s2,588 # 868 <malloc+0x106>
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
 83a:	b6e080e7          	jalr	-1170(ra) # 3a4 <sbrk>
  if(p == (char*)-1)
 83e:	fd5518e3          	bne	a0,s5,80e <malloc+0xac>
        return 0;
 842:	4501                	li	a0,0
 844:	bf45                	j	7f4 <malloc+0x92>
