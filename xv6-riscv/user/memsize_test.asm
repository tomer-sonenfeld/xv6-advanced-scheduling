
user/_memsize_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:



//int memsize();

int main(int argc , char* argv[]){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    printf("%d\n" , memsize());    
   a:	00000097          	auipc	ra,0x0
   e:	3a4080e7          	jalr	932(ra) # 3ae <memsize>
  12:	85aa                	mv	a1,a0
  14:	00001517          	auipc	a0,0x1
  18:	83c50513          	addi	a0,a0,-1988 # 850 <malloc+0xec>
  1c:	00000097          	auipc	ra,0x0
  20:	68a080e7          	jalr	1674(ra) # 6a6 <printf>
    char* p = (char*)malloc(20000);
  24:	6515                	lui	a0,0x5
  26:	e2050513          	addi	a0,a0,-480 # 4e20 <base+0x3e10>
  2a:	00000097          	auipc	ra,0x0
  2e:	73a080e7          	jalr	1850(ra) # 764 <malloc>
  32:	84aa                	mv	s1,a0
    printf("%d\n", memsize());
  34:	00000097          	auipc	ra,0x0
  38:	37a080e7          	jalr	890(ra) # 3ae <memsize>
  3c:	85aa                	mv	a1,a0
  3e:	00001517          	auipc	a0,0x1
  42:	81250513          	addi	a0,a0,-2030 # 850 <malloc+0xec>
  46:	00000097          	auipc	ra,0x0
  4a:	660080e7          	jalr	1632(ra) # 6a6 <printf>
    free(p);
  4e:	8526                	mv	a0,s1
  50:	00000097          	auipc	ra,0x0
  54:	68c080e7          	jalr	1676(ra) # 6dc <free>
    printf("%d\n", memsize());
  58:	00000097          	auipc	ra,0x0
  5c:	356080e7          	jalr	854(ra) # 3ae <memsize>
  60:	85aa                	mv	a1,a0
  62:	00000517          	auipc	a0,0x0
  66:	7ee50513          	addi	a0,a0,2030 # 850 <malloc+0xec>
  6a:	00000097          	auipc	ra,0x0
  6e:	63c080e7          	jalr	1596(ra) # 6a6 <printf>
    

    return 0;
    
  72:	4501                	li	a0,0
  74:	60e2                	ld	ra,24(sp)
  76:	6442                	ld	s0,16(sp)
  78:	64a2                	ld	s1,8(sp)
  7a:	6105                	addi	sp,sp,32
  7c:	8082                	ret

000000000000007e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  extern int main();
  main();
  86:	00000097          	auipc	ra,0x0
  8a:	f7a080e7          	jalr	-134(ra) # 0 <main>
  exit(0,"");
  8e:	00000597          	auipc	a1,0x0
  92:	7ca58593          	addi	a1,a1,1994 # 858 <malloc+0xf4>
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	276080e7          	jalr	630(ra) # 30e <exit>

00000000000000a0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e422                	sd	s0,8(sp)
  a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a6:	87aa                	mv	a5,a0
  a8:	0585                	addi	a1,a1,1
  aa:	0785                	addi	a5,a5,1
  ac:	fff5c703          	lbu	a4,-1(a1)
  b0:	fee78fa3          	sb	a4,-1(a5)
  b4:	fb75                	bnez	a4,a8 <strcpy+0x8>
    ;
  return os;
}
  b6:	6422                	ld	s0,8(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cb91                	beqz	a5,da <strcmp+0x1e>
  c8:	0005c703          	lbu	a4,0(a1)
  cc:	00f71763          	bne	a4,a5,da <strcmp+0x1e>
    p++, q++;
  d0:	0505                	addi	a0,a0,1
  d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	fbe5                	bnez	a5,c8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  da:	0005c503          	lbu	a0,0(a1)
}
  de:	40a7853b          	subw	a0,a5,a0
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strlen>:

uint
strlen(const char *s)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cf91                	beqz	a5,10e <strlen+0x26>
  f4:	0505                	addi	a0,a0,1
  f6:	87aa                	mv	a5,a0
  f8:	4685                	li	a3,1
  fa:	9e89                	subw	a3,a3,a0
  fc:	00f6853b          	addw	a0,a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	fb7d                	bnez	a4,fc <strlen+0x14>
    ;
  return n;
}
 108:	6422                	ld	s0,8(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret
  for(n = 0; s[n]; n++)
 10e:	4501                	li	a0,0
 110:	bfe5                	j	108 <strlen+0x20>

0000000000000112 <memset>:

void*
memset(void *dst, int c, uint n)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 118:	ca19                	beqz	a2,12e <memset+0x1c>
 11a:	87aa                	mv	a5,a0
 11c:	1602                	slli	a2,a2,0x20
 11e:	9201                	srli	a2,a2,0x20
 120:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 124:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 128:	0785                	addi	a5,a5,1
 12a:	fee79de3          	bne	a5,a4,124 <memset+0x12>
  }
  return dst;
}
 12e:	6422                	ld	s0,8(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb99                	beqz	a5,154 <strchr+0x20>
    if(*s == c)
 140:	00f58763          	beq	a1,a5,14e <strchr+0x1a>
  for(; *s; s++)
 144:	0505                	addi	a0,a0,1
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbfd                	bnez	a5,140 <strchr+0xc>
      return (char*)s;
  return 0;
 14c:	4501                	li	a0,0
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfe5                	j	14e <strchr+0x1a>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	1080                	addi	s0,sp,96
 16e:	8baa                	mv	s7,a0
 170:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	892a                	mv	s2,a0
 174:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 176:	4aa9                	li	s5,10
 178:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 17a:	89a6                	mv	s3,s1
 17c:	2485                	addiw	s1,s1,1
 17e:	0344d863          	bge	s1,s4,1ae <gets+0x56>
    cc = read(0, &c, 1);
 182:	4605                	li	a2,1
 184:	faf40593          	addi	a1,s0,-81
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	19c080e7          	jalr	412(ra) # 326 <read>
    if(cc < 1)
 192:	00a05e63          	blez	a0,1ae <gets+0x56>
    buf[i++] = c;
 196:	faf44783          	lbu	a5,-81(s0)
 19a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 19e:	01578763          	beq	a5,s5,1ac <gets+0x54>
 1a2:	0905                	addi	s2,s2,1
 1a4:	fd679be3          	bne	a5,s6,17a <gets+0x22>
  for(i=0; i+1 < max; ){
 1a8:	89a6                	mv	s3,s1
 1aa:	a011                	j	1ae <gets+0x56>
 1ac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ae:	99de                	add	s3,s3,s7
 1b0:	00098023          	sb	zero,0(s3)
  return buf;
}
 1b4:	855e                	mv	a0,s7
 1b6:	60e6                	ld	ra,88(sp)
 1b8:	6446                	ld	s0,80(sp)
 1ba:	64a6                	ld	s1,72(sp)
 1bc:	6906                	ld	s2,64(sp)
 1be:	79e2                	ld	s3,56(sp)
 1c0:	7a42                	ld	s4,48(sp)
 1c2:	7aa2                	ld	s5,40(sp)
 1c4:	7b02                	ld	s6,32(sp)
 1c6:	6be2                	ld	s7,24(sp)
 1c8:	6125                	addi	sp,sp,96
 1ca:	8082                	ret

00000000000001cc <stat>:

int
stat(const char *n, struct stat *st)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e426                	sd	s1,8(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	4581                	li	a1,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	172080e7          	jalr	370(ra) # 34e <open>
  if(fd < 0)
 1e4:	02054563          	bltz	a0,20e <stat+0x42>
 1e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ea:	85ca                	mv	a1,s2
 1ec:	00000097          	auipc	ra,0x0
 1f0:	17a080e7          	jalr	378(ra) # 366 <fstat>
 1f4:	892a                	mv	s2,a0
  close(fd);
 1f6:	8526                	mv	a0,s1
 1f8:	00000097          	auipc	ra,0x0
 1fc:	13e080e7          	jalr	318(ra) # 336 <close>
  return r;
}
 200:	854a                	mv	a0,s2
 202:	60e2                	ld	ra,24(sp)
 204:	6442                	ld	s0,16(sp)
 206:	64a2                	ld	s1,8(sp)
 208:	6902                	ld	s2,0(sp)
 20a:	6105                	addi	sp,sp,32
 20c:	8082                	ret
    return -1;
 20e:	597d                	li	s2,-1
 210:	bfc5                	j	200 <stat+0x34>

0000000000000212 <atoi>:

int
atoi(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e422                	sd	s0,8(sp)
 216:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 218:	00054603          	lbu	a2,0(a0)
 21c:	fd06079b          	addiw	a5,a2,-48
 220:	0ff7f793          	andi	a5,a5,255
 224:	4725                	li	a4,9
 226:	02f76963          	bltu	a4,a5,258 <atoi+0x46>
 22a:	86aa                	mv	a3,a0
  n = 0;
 22c:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 22e:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 230:	0685                	addi	a3,a3,1
 232:	0025179b          	slliw	a5,a0,0x2
 236:	9fa9                	addw	a5,a5,a0
 238:	0017979b          	slliw	a5,a5,0x1
 23c:	9fb1                	addw	a5,a5,a2
 23e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 242:	0006c603          	lbu	a2,0(a3)
 246:	fd06071b          	addiw	a4,a2,-48
 24a:	0ff77713          	andi	a4,a4,255
 24e:	fee5f1e3          	bgeu	a1,a4,230 <atoi+0x1e>
  return n;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
  n = 0;
 258:	4501                	li	a0,0
 25a:	bfe5                	j	252 <atoi+0x40>

000000000000025c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e422                	sd	s0,8(sp)
 260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 262:	02b57463          	bgeu	a0,a1,28a <memmove+0x2e>
    while(n-- > 0)
 266:	00c05f63          	blez	a2,284 <memmove+0x28>
 26a:	1602                	slli	a2,a2,0x20
 26c:	9201                	srli	a2,a2,0x20
 26e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 272:	872a                	mv	a4,a0
      *dst++ = *src++;
 274:	0585                	addi	a1,a1,1
 276:	0705                	addi	a4,a4,1
 278:	fff5c683          	lbu	a3,-1(a1)
 27c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
    dst += n;
 28a:	00c50733          	add	a4,a0,a2
    src += n;
 28e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 290:	fec05ae3          	blez	a2,284 <memmove+0x28>
 294:	fff6079b          	addiw	a5,a2,-1
 298:	1782                	slli	a5,a5,0x20
 29a:	9381                	srli	a5,a5,0x20
 29c:	fff7c793          	not	a5,a5
 2a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a2:	15fd                	addi	a1,a1,-1
 2a4:	177d                	addi	a4,a4,-1
 2a6:	0005c683          	lbu	a3,0(a1)
 2aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ae:	fee79ae3          	bne	a5,a4,2a2 <memmove+0x46>
 2b2:	bfc9                	j	284 <memmove+0x28>

00000000000002b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ba:	ca05                	beqz	a2,2ea <memcmp+0x36>
 2bc:	fff6069b          	addiw	a3,a2,-1
 2c0:	1682                	slli	a3,a3,0x20
 2c2:	9281                	srli	a3,a3,0x20
 2c4:	0685                	addi	a3,a3,1
 2c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00e79863          	bne	a5,a4,2e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d4:	0505                	addi	a0,a0,1
    p2++;
 2d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d8:	fed518e3          	bne	a0,a3,2c8 <memcmp+0x14>
  }
  return 0;
 2dc:	4501                	li	a0,0
 2de:	a019                	j	2e4 <memcmp+0x30>
      return *p1 - *p2;
 2e0:	40e7853b          	subw	a0,a5,a4
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	bfe5                	j	2e4 <memcmp+0x30>

00000000000002ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f6:	00000097          	auipc	ra,0x0
 2fa:	f66080e7          	jalr	-154(ra) # 25c <memmove>
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 306:	4885                	li	a7,1
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exit>:
.global exit
exit:
 li a7, SYS_exit
 30e:	4889                	li	a7,2
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <wait>:
.global wait
wait:
 li a7, SYS_wait
 316:	488d                	li	a7,3
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31e:	4891                	li	a7,4
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <read>:
.global read
read:
 li a7, SYS_read
 326:	4895                	li	a7,5
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <write>:
.global write
write:
 li a7, SYS_write
 32e:	48c1                	li	a7,16
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <close>:
.global close
close:
 li a7, SYS_close
 336:	48d5                	li	a7,21
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <kill>:
.global kill
kill:
 li a7, SYS_kill
 33e:	4899                	li	a7,6
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <exec>:
.global exec
exec:
 li a7, SYS_exec
 346:	489d                	li	a7,7
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <open>:
.global open
open:
 li a7, SYS_open
 34e:	48bd                	li	a7,15
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 356:	48c5                	li	a7,17
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35e:	48c9                	li	a7,18
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 366:	48a1                	li	a7,8
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <link>:
.global link
link:
 li a7, SYS_link
 36e:	48cd                	li	a7,19
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 376:	48d1                	li	a7,20
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37e:	48a5                	li	a7,9
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <dup>:
.global dup
dup:
 li a7, SYS_dup
 386:	48a9                	li	a7,10
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38e:	48ad                	li	a7,11
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 396:	48b1                	li	a7,12
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39e:	48b5                	li	a7,13
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a6:	48b9                	li	a7,14
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 3ae:	48d9                	li	a7,22
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 3b6:	48dd                	li	a7,23
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 3be:	48e1                	li	a7,24
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 3c6:	48e5                	li	a7,25
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ce:	1101                	addi	sp,sp,-32
 3d0:	ec06                	sd	ra,24(sp)
 3d2:	e822                	sd	s0,16(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3da:	4605                	li	a2,1
 3dc:	fef40593          	addi	a1,s0,-17
 3e0:	00000097          	auipc	ra,0x0
 3e4:	f4e080e7          	jalr	-178(ra) # 32e <write>
}
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	6105                	addi	sp,sp,32
 3ee:	8082                	ret

00000000000003f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	7139                	addi	sp,sp,-64
 3f2:	fc06                	sd	ra,56(sp)
 3f4:	f822                	sd	s0,48(sp)
 3f6:	f426                	sd	s1,40(sp)
 3f8:	f04a                	sd	s2,32(sp)
 3fa:	ec4e                	sd	s3,24(sp)
 3fc:	0080                	addi	s0,sp,64
 3fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 400:	c299                	beqz	a3,406 <printint+0x16>
 402:	0805c863          	bltz	a1,492 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 406:	2581                	sext.w	a1,a1
  neg = 0;
 408:	4881                	li	a7,0
 40a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 410:	2601                	sext.w	a2,a2
 412:	00000517          	auipc	a0,0x0
 416:	45650513          	addi	a0,a0,1110 # 868 <digits>
 41a:	883a                	mv	a6,a4
 41c:	2705                	addiw	a4,a4,1
 41e:	02c5f7bb          	remuw	a5,a1,a2
 422:	1782                	slli	a5,a5,0x20
 424:	9381                	srli	a5,a5,0x20
 426:	97aa                	add	a5,a5,a0
 428:	0007c783          	lbu	a5,0(a5)
 42c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 430:	0005879b          	sext.w	a5,a1
 434:	02c5d5bb          	divuw	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fec7f0e3          	bgeu	a5,a2,41a <printint+0x2a>
  if(neg)
 43e:	00088b63          	beqz	a7,454 <printint+0x64>
    buf[i++] = '-';
 442:	fd040793          	addi	a5,s0,-48
 446:	973e                	add	a4,a4,a5
 448:	02d00793          	li	a5,45
 44c:	fef70823          	sb	a5,-16(a4)
 450:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 454:	02e05863          	blez	a4,484 <printint+0x94>
 458:	fc040793          	addi	a5,s0,-64
 45c:	00e78933          	add	s2,a5,a4
 460:	fff78993          	addi	s3,a5,-1
 464:	99ba                	add	s3,s3,a4
 466:	377d                	addiw	a4,a4,-1
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 470:	fff94583          	lbu	a1,-1(s2)
 474:	8526                	mv	a0,s1
 476:	00000097          	auipc	ra,0x0
 47a:	f58080e7          	jalr	-168(ra) # 3ce <putc>
  while(--i >= 0)
 47e:	197d                	addi	s2,s2,-1
 480:	ff3918e3          	bne	s2,s3,470 <printint+0x80>
}
 484:	70e2                	ld	ra,56(sp)
 486:	7442                	ld	s0,48(sp)
 488:	74a2                	ld	s1,40(sp)
 48a:	7902                	ld	s2,32(sp)
 48c:	69e2                	ld	s3,24(sp)
 48e:	6121                	addi	sp,sp,64
 490:	8082                	ret
    x = -xx;
 492:	40b005bb          	negw	a1,a1
    neg = 1;
 496:	4885                	li	a7,1
    x = -xx;
 498:	bf8d                	j	40a <printint+0x1a>

000000000000049a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49a:	7119                	addi	sp,sp,-128
 49c:	fc86                	sd	ra,120(sp)
 49e:	f8a2                	sd	s0,112(sp)
 4a0:	f4a6                	sd	s1,104(sp)
 4a2:	f0ca                	sd	s2,96(sp)
 4a4:	ecce                	sd	s3,88(sp)
 4a6:	e8d2                	sd	s4,80(sp)
 4a8:	e4d6                	sd	s5,72(sp)
 4aa:	e0da                	sd	s6,64(sp)
 4ac:	fc5e                	sd	s7,56(sp)
 4ae:	f862                	sd	s8,48(sp)
 4b0:	f466                	sd	s9,40(sp)
 4b2:	f06a                	sd	s10,32(sp)
 4b4:	ec6e                	sd	s11,24(sp)
 4b6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b8:	0005c903          	lbu	s2,0(a1)
 4bc:	18090f63          	beqz	s2,65a <vprintf+0x1c0>
 4c0:	8aaa                	mv	s5,a0
 4c2:	8b32                	mv	s6,a2
 4c4:	00158493          	addi	s1,a1,1
  state = 0;
 4c8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ca:	02500a13          	li	s4,37
      if(c == 'd'){
 4ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4d2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4d6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4da:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4de:	00000b97          	auipc	s7,0x0
 4e2:	38ab8b93          	addi	s7,s7,906 # 868 <digits>
 4e6:	a839                	j	504 <vprintf+0x6a>
        putc(fd, c);
 4e8:	85ca                	mv	a1,s2
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	ee2080e7          	jalr	-286(ra) # 3ce <putc>
 4f4:	a019                	j	4fa <vprintf+0x60>
    } else if(state == '%'){
 4f6:	01498f63          	beq	s3,s4,514 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4fa:	0485                	addi	s1,s1,1
 4fc:	fff4c903          	lbu	s2,-1(s1)
 500:	14090d63          	beqz	s2,65a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 504:	0009079b          	sext.w	a5,s2
    if(state == 0){
 508:	fe0997e3          	bnez	s3,4f6 <vprintf+0x5c>
      if(c == '%'){
 50c:	fd479ee3          	bne	a5,s4,4e8 <vprintf+0x4e>
        state = '%';
 510:	89be                	mv	s3,a5
 512:	b7e5                	j	4fa <vprintf+0x60>
      if(c == 'd'){
 514:	05878063          	beq	a5,s8,554 <vprintf+0xba>
      } else if(c == 'l') {
 518:	05978c63          	beq	a5,s9,570 <vprintf+0xd6>
      } else if(c == 'x') {
 51c:	07a78863          	beq	a5,s10,58c <vprintf+0xf2>
      } else if(c == 'p') {
 520:	09b78463          	beq	a5,s11,5a8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 524:	07300713          	li	a4,115
 528:	0ce78663          	beq	a5,a4,5f4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52c:	06300713          	li	a4,99
 530:	0ee78e63          	beq	a5,a4,62c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 534:	11478863          	beq	a5,s4,644 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 538:	85d2                	mv	a1,s4
 53a:	8556                	mv	a0,s5
 53c:	00000097          	auipc	ra,0x0
 540:	e92080e7          	jalr	-366(ra) # 3ce <putc>
        putc(fd, c);
 544:	85ca                	mv	a1,s2
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	e86080e7          	jalr	-378(ra) # 3ce <putc>
      }
      state = 0;
 550:	4981                	li	s3,0
 552:	b765                	j	4fa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 554:	008b0913          	addi	s2,s6,8
 558:	4685                	li	a3,1
 55a:	4629                	li	a2,10
 55c:	000b2583          	lw	a1,0(s6)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e8e080e7          	jalr	-370(ra) # 3f0 <printint>
 56a:	8b4a                	mv	s6,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b771                	j	4fa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 570:	008b0913          	addi	s2,s6,8
 574:	4681                	li	a3,0
 576:	4629                	li	a2,10
 578:	000b2583          	lw	a1,0(s6)
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e72080e7          	jalr	-398(ra) # 3f0 <printint>
 586:	8b4a                	mv	s6,s2
      state = 0;
 588:	4981                	li	s3,0
 58a:	bf85                	j	4fa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 58c:	008b0913          	addi	s2,s6,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000b2583          	lw	a1,0(s6)
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	e56080e7          	jalr	-426(ra) # 3f0 <printint>
 5a2:	8b4a                	mv	s6,s2
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bf91                	j	4fa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5a8:	008b0793          	addi	a5,s6,8
 5ac:	f8f43423          	sd	a5,-120(s0)
 5b0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b4:	03000593          	li	a1,48
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	e14080e7          	jalr	-492(ra) # 3ce <putc>
  putc(fd, 'x');
 5c2:	85ea                	mv	a1,s10
 5c4:	8556                	mv	a0,s5
 5c6:	00000097          	auipc	ra,0x0
 5ca:	e08080e7          	jalr	-504(ra) # 3ce <putc>
 5ce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d0:	03c9d793          	srli	a5,s3,0x3c
 5d4:	97de                	add	a5,a5,s7
 5d6:	0007c583          	lbu	a1,0(a5)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	df2080e7          	jalr	-526(ra) # 3ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e4:	0992                	slli	s3,s3,0x4
 5e6:	397d                	addiw	s2,s2,-1
 5e8:	fe0914e3          	bnez	s2,5d0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5ec:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b721                	j	4fa <vprintf+0x60>
        s = va_arg(ap, char*);
 5f4:	008b0993          	addi	s3,s6,8
 5f8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5fc:	02090163          	beqz	s2,61e <vprintf+0x184>
        while(*s != 0){
 600:	00094583          	lbu	a1,0(s2)
 604:	c9a1                	beqz	a1,654 <vprintf+0x1ba>
          putc(fd, *s);
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	dc6080e7          	jalr	-570(ra) # 3ce <putc>
          s++;
 610:	0905                	addi	s2,s2,1
        while(*s != 0){
 612:	00094583          	lbu	a1,0(s2)
 616:	f9e5                	bnez	a1,606 <vprintf+0x16c>
        s = va_arg(ap, char*);
 618:	8b4e                	mv	s6,s3
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bdf9                	j	4fa <vprintf+0x60>
          s = "(null)";
 61e:	00000917          	auipc	s2,0x0
 622:	24290913          	addi	s2,s2,578 # 860 <malloc+0xfc>
        while(*s != 0){
 626:	02800593          	li	a1,40
 62a:	bff1                	j	606 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 62c:	008b0913          	addi	s2,s6,8
 630:	000b4583          	lbu	a1,0(s6)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	d98080e7          	jalr	-616(ra) # 3ce <putc>
 63e:	8b4a                	mv	s6,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bd65                	j	4fa <vprintf+0x60>
        putc(fd, c);
 644:	85d2                	mv	a1,s4
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	d86080e7          	jalr	-634(ra) # 3ce <putc>
      state = 0;
 650:	4981                	li	s3,0
 652:	b565                	j	4fa <vprintf+0x60>
        s = va_arg(ap, char*);
 654:	8b4e                	mv	s6,s3
      state = 0;
 656:	4981                	li	s3,0
 658:	b54d                	j	4fa <vprintf+0x60>
    }
  }
}
 65a:	70e6                	ld	ra,120(sp)
 65c:	7446                	ld	s0,112(sp)
 65e:	74a6                	ld	s1,104(sp)
 660:	7906                	ld	s2,96(sp)
 662:	69e6                	ld	s3,88(sp)
 664:	6a46                	ld	s4,80(sp)
 666:	6aa6                	ld	s5,72(sp)
 668:	6b06                	ld	s6,64(sp)
 66a:	7be2                	ld	s7,56(sp)
 66c:	7c42                	ld	s8,48(sp)
 66e:	7ca2                	ld	s9,40(sp)
 670:	7d02                	ld	s10,32(sp)
 672:	6de2                	ld	s11,24(sp)
 674:	6109                	addi	sp,sp,128
 676:	8082                	ret

0000000000000678 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 678:	715d                	addi	sp,sp,-80
 67a:	ec06                	sd	ra,24(sp)
 67c:	e822                	sd	s0,16(sp)
 67e:	1000                	addi	s0,sp,32
 680:	e010                	sd	a2,0(s0)
 682:	e414                	sd	a3,8(s0)
 684:	e818                	sd	a4,16(s0)
 686:	ec1c                	sd	a5,24(s0)
 688:	03043023          	sd	a6,32(s0)
 68c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 690:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 694:	8622                	mv	a2,s0
 696:	00000097          	auipc	ra,0x0
 69a:	e04080e7          	jalr	-508(ra) # 49a <vprintf>
}
 69e:	60e2                	ld	ra,24(sp)
 6a0:	6442                	ld	s0,16(sp)
 6a2:	6161                	addi	sp,sp,80
 6a4:	8082                	ret

00000000000006a6 <printf>:

void
printf(const char *fmt, ...)
{
 6a6:	711d                	addi	sp,sp,-96
 6a8:	ec06                	sd	ra,24(sp)
 6aa:	e822                	sd	s0,16(sp)
 6ac:	1000                	addi	s0,sp,32
 6ae:	e40c                	sd	a1,8(s0)
 6b0:	e810                	sd	a2,16(s0)
 6b2:	ec14                	sd	a3,24(s0)
 6b4:	f018                	sd	a4,32(s0)
 6b6:	f41c                	sd	a5,40(s0)
 6b8:	03043823          	sd	a6,48(s0)
 6bc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c0:	00840613          	addi	a2,s0,8
 6c4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6c8:	85aa                	mv	a1,a0
 6ca:	4505                	li	a0,1
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dce080e7          	jalr	-562(ra) # 49a <vprintf>
}
 6d4:	60e2                	ld	ra,24(sp)
 6d6:	6442                	ld	s0,16(sp)
 6d8:	6125                	addi	sp,sp,96
 6da:	8082                	ret

00000000000006dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6dc:	1141                	addi	sp,sp,-16
 6de:	e422                	sd	s0,8(sp)
 6e0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	00001797          	auipc	a5,0x1
 6ea:	91a7b783          	ld	a5,-1766(a5) # 1000 <freep>
 6ee:	a805                	j	71e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f0:	4618                	lw	a4,8(a2)
 6f2:	9db9                	addw	a1,a1,a4
 6f4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f8:	6398                	ld	a4,0(a5)
 6fa:	6318                	ld	a4,0(a4)
 6fc:	fee53823          	sd	a4,-16(a0)
 700:	a091                	j	744 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 702:	ff852703          	lw	a4,-8(a0)
 706:	9e39                	addw	a2,a2,a4
 708:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 70a:	ff053703          	ld	a4,-16(a0)
 70e:	e398                	sd	a4,0(a5)
 710:	a099                	j	756 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x40>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x50>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x36>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059713          	slli	a4,a1,0x20
 736:	9301                	srli	a4,a4,0x20
 738:	0712                	slli	a4,a4,0x4
 73a:	9736                	add	a4,a4,a3
 73c:	fae60ae3          	beq	a2,a4,6f0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061713          	slli	a4,a2,0x20
 74a:	9301                	srli	a4,a4,0x20
 74c:	0712                	slli	a4,a4,0x4
 74e:	973e                	add	a4,a4,a5
 750:	fae689e3          	beq	a3,a4,702 <free+0x26>
  } else
    p->s.ptr = bp;
 754:	e394                	sd	a3,0(a5)
  freep = p;
 756:	00001717          	auipc	a4,0x1
 75a:	8af73523          	sd	a5,-1878(a4) # 1000 <freep>
}
 75e:	6422                	ld	s0,8(sp)
 760:	0141                	addi	sp,sp,16
 762:	8082                	ret

0000000000000764 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 764:	7139                	addi	sp,sp,-64
 766:	fc06                	sd	ra,56(sp)
 768:	f822                	sd	s0,48(sp)
 76a:	f426                	sd	s1,40(sp)
 76c:	f04a                	sd	s2,32(sp)
 76e:	ec4e                	sd	s3,24(sp)
 770:	e852                	sd	s4,16(sp)
 772:	e456                	sd	s5,8(sp)
 774:	e05a                	sd	s6,0(sp)
 776:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051493          	slli	s1,a0,0x20
 77c:	9081                	srli	s1,s1,0x20
 77e:	04bd                	addi	s1,s1,15
 780:	8091                	srli	s1,s1,0x4
 782:	0014899b          	addiw	s3,s1,1
 786:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 788:	00001517          	auipc	a0,0x1
 78c:	87853503          	ld	a0,-1928(a0) # 1000 <freep>
 790:	c515                	beqz	a0,7bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	02977f63          	bgeu	a4,s1,7d4 <malloc+0x70>
 79a:	8a4e                	mv	s4,s3
 79c:	0009871b          	sext.w	a4,s3
 7a0:	6685                	lui	a3,0x1
 7a2:	00d77363          	bgeu	a4,a3,7a8 <malloc+0x44>
 7a6:	6a05                	lui	s4,0x1
 7a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b0:	00001917          	auipc	s2,0x1
 7b4:	85090913          	addi	s2,s2,-1968 # 1000 <freep>
  if(p == (char*)-1)
 7b8:	5afd                	li	s5,-1
 7ba:	a88d                	j	82c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7bc:	00001797          	auipc	a5,0x1
 7c0:	85478793          	addi	a5,a5,-1964 # 1010 <base>
 7c4:	00001717          	auipc	a4,0x1
 7c8:	82f73e23          	sd	a5,-1988(a4) # 1000 <freep>
 7cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d2:	b7e1                	j	79a <malloc+0x36>
      if(p->s.size == nunits)
 7d4:	02e48b63          	beq	s1,a4,80a <malloc+0xa6>
        p->s.size -= nunits;
 7d8:	4137073b          	subw	a4,a4,s3
 7dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7de:	1702                	slli	a4,a4,0x20
 7e0:	9301                	srli	a4,a4,0x20
 7e2:	0712                	slli	a4,a4,0x4
 7e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ea:	00001717          	auipc	a4,0x1
 7ee:	80a73b23          	sd	a0,-2026(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7f6:	70e2                	ld	ra,56(sp)
 7f8:	7442                	ld	s0,48(sp)
 7fa:	74a2                	ld	s1,40(sp)
 7fc:	7902                	ld	s2,32(sp)
 7fe:	69e2                	ld	s3,24(sp)
 800:	6a42                	ld	s4,16(sp)
 802:	6aa2                	ld	s5,8(sp)
 804:	6b02                	ld	s6,0(sp)
 806:	6121                	addi	sp,sp,64
 808:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 80a:	6398                	ld	a4,0(a5)
 80c:	e118                	sd	a4,0(a0)
 80e:	bff1                	j	7ea <malloc+0x86>
  hp->s.size = nu;
 810:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 814:	0541                	addi	a0,a0,16
 816:	00000097          	auipc	ra,0x0
 81a:	ec6080e7          	jalr	-314(ra) # 6dc <free>
  return freep;
 81e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 822:	d971                	beqz	a0,7f6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 824:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 826:	4798                	lw	a4,8(a5)
 828:	fa9776e3          	bgeu	a4,s1,7d4 <malloc+0x70>
    if(p == freep)
 82c:	00093703          	ld	a4,0(s2)
 830:	853e                	mv	a0,a5
 832:	fef719e3          	bne	a4,a5,824 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 836:	8552                	mv	a0,s4
 838:	00000097          	auipc	ra,0x0
 83c:	b5e080e7          	jalr	-1186(ra) # 396 <sbrk>
  if(p == (char*)-1)
 840:	fd5518e3          	bne	a0,s5,810 <malloc+0xac>
        return 0;
 844:	4501                	li	a0,0
 846:	bf45                	j	7f6 <malloc+0x92>
