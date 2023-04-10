
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	00090913          	mv	s2,s2
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	3ce080e7          	jalr	974(ra) # 3ee <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05d63          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	3c2080e7          	jalr	962(ra) # 3f6 <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	8c058593          	addi	a1,a1,-1856 # 900 <malloc+0xe4>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	6e6080e7          	jalr	1766(ra) # 730 <fprintf>
      exit(1,"");
  52:	00001597          	auipc	a1,0x1
  56:	8d658593          	addi	a1,a1,-1834 # 928 <malloc+0x10c>
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	37a080e7          	jalr	890(ra) # 3d6 <exit>
    }
  }
  if(n < 0){
  64:	00054963          	bltz	a0,76 <cat+0x76>
    fprintf(2, "cat: read error\n");
    exit(1,"");
  }
}
  68:	70a2                	ld	ra,40(sp)
  6a:	7402                	ld	s0,32(sp)
  6c:	64e2                	ld	s1,24(sp)
  6e:	6942                	ld	s2,16(sp)
  70:	69a2                	ld	s3,8(sp)
  72:	6145                	addi	sp,sp,48
  74:	8082                	ret
    fprintf(2, "cat: read error\n");
  76:	00001597          	auipc	a1,0x1
  7a:	8a258593          	addi	a1,a1,-1886 # 918 <malloc+0xfc>
  7e:	4509                	li	a0,2
  80:	00000097          	auipc	ra,0x0
  84:	6b0080e7          	jalr	1712(ra) # 730 <fprintf>
    exit(1,"");
  88:	00001597          	auipc	a1,0x1
  8c:	8a058593          	addi	a1,a1,-1888 # 928 <malloc+0x10c>
  90:	4505                	li	a0,1
  92:	00000097          	auipc	ra,0x0
  96:	344080e7          	jalr	836(ra) # 3d6 <exit>

000000000000009a <main>:

int
main(int argc, char *argv[])
{
  9a:	7179                	addi	sp,sp,-48
  9c:	f406                	sd	ra,40(sp)
  9e:	f022                	sd	s0,32(sp)
  a0:	ec26                	sd	s1,24(sp)
  a2:	e84a                	sd	s2,16(sp)
  a4:	e44e                	sd	s3,8(sp)
  a6:	e052                	sd	s4,0(sp)
  a8:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  aa:	4785                	li	a5,1
  ac:	04a7db63          	bge	a5,a0,102 <main+0x68>
  b0:	00858913          	addi	s2,a1,8
  b4:	ffe5099b          	addiw	s3,a0,-2
  b8:	1982                	slli	s3,s3,0x20
  ba:	0209d993          	srli	s3,s3,0x20
  be:	098e                	slli	s3,s3,0x3
  c0:	05c1                	addi	a1,a1,16
  c2:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0,"");
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  c4:	4581                	li	a1,0
  c6:	00093503          	ld	a0,0(s2) # 1010 <buf>
  ca:	00000097          	auipc	ra,0x0
  ce:	34c080e7          	jalr	844(ra) # 416 <open>
  d2:	84aa                	mv	s1,a0
  d4:	04054563          	bltz	a0,11e <main+0x84>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1,"");
    }
    cat(fd);
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <cat>
    close(fd);
  e0:	8526                	mv	a0,s1
  e2:	00000097          	auipc	ra,0x0
  e6:	31c080e7          	jalr	796(ra) # 3fe <close>
  for(i = 1; i < argc; i++){
  ea:	0921                	addi	s2,s2,8
  ec:	fd391ce3          	bne	s2,s3,c4 <main+0x2a>
  }
  exit(0,"");
  f0:	00001597          	auipc	a1,0x1
  f4:	83858593          	addi	a1,a1,-1992 # 928 <malloc+0x10c>
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2dc080e7          	jalr	732(ra) # 3d6 <exit>
    cat(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	efc080e7          	jalr	-260(ra) # 0 <cat>
    exit(0,"");
 10c:	00001597          	auipc	a1,0x1
 110:	81c58593          	addi	a1,a1,-2020 # 928 <malloc+0x10c>
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	2c0080e7          	jalr	704(ra) # 3d6 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 11e:	00093603          	ld	a2,0(s2)
 122:	00001597          	auipc	a1,0x1
 126:	80e58593          	addi	a1,a1,-2034 # 930 <malloc+0x114>
 12a:	4509                	li	a0,2
 12c:	00000097          	auipc	ra,0x0
 130:	604080e7          	jalr	1540(ra) # 730 <fprintf>
      exit(1,"");
 134:	00000597          	auipc	a1,0x0
 138:	7f458593          	addi	a1,a1,2036 # 928 <malloc+0x10c>
 13c:	4505                	li	a0,1
 13e:	00000097          	auipc	ra,0x0
 142:	298080e7          	jalr	664(ra) # 3d6 <exit>

0000000000000146 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 146:	1141                	addi	sp,sp,-16
 148:	e406                	sd	ra,8(sp)
 14a:	e022                	sd	s0,0(sp)
 14c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 14e:	00000097          	auipc	ra,0x0
 152:	f4c080e7          	jalr	-180(ra) # 9a <main>
  exit(0,"");
 156:	00000597          	auipc	a1,0x0
 15a:	7d258593          	addi	a1,a1,2002 # 928 <malloc+0x10c>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	276080e7          	jalr	630(ra) # 3d6 <exit>

0000000000000168 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e422                	sd	s0,8(sp)
 16c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16e:	87aa                	mv	a5,a0
 170:	0585                	addi	a1,a1,1
 172:	0785                	addi	a5,a5,1
 174:	fff5c703          	lbu	a4,-1(a1)
 178:	fee78fa3          	sb	a4,-1(a5)
 17c:	fb75                	bnez	a4,170 <strcpy+0x8>
    ;
  return os;
}
 17e:	6422                	ld	s0,8(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cb91                	beqz	a5,1a2 <strcmp+0x1e>
 190:	0005c703          	lbu	a4,0(a1)
 194:	00f71763          	bne	a4,a5,1a2 <strcmp+0x1e>
    p++, q++;
 198:	0505                	addi	a0,a0,1
 19a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 19c:	00054783          	lbu	a5,0(a0)
 1a0:	fbe5                	bnez	a5,190 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a2:	0005c503          	lbu	a0,0(a1)
}
 1a6:	40a7853b          	subw	a0,a5,a0
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cf91                	beqz	a5,1d6 <strlen+0x26>
 1bc:	0505                	addi	a0,a0,1
 1be:	87aa                	mv	a5,a0
 1c0:	4685                	li	a3,1
 1c2:	9e89                	subw	a3,a3,a0
 1c4:	00f6853b          	addw	a0,a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	fb7d                	bnez	a4,1c4 <strlen+0x14>
    ;
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  for(n = 0; s[n]; n++)
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strlen+0x20>

00000000000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e0:	ca19                	beqz	a2,1f6 <memset+0x1c>
 1e2:	87aa                	mv	a5,a0
 1e4:	1602                	slli	a2,a2,0x20
 1e6:	9201                	srli	a2,a2,0x20
 1e8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f0:	0785                	addi	a5,a5,1
 1f2:	fee79de3          	bne	a5,a4,1ec <memset+0x12>
  }
  return dst;
}
 1f6:	6422                	ld	s0,8(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strchr>:

char*
strchr(const char *s, char c)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e422                	sd	s0,8(sp)
 200:	0800                	addi	s0,sp,16
  for(; *s; s++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cb99                	beqz	a5,21c <strchr+0x20>
    if(*s == c)
 208:	00f58763          	beq	a1,a5,216 <strchr+0x1a>
  for(; *s; s++)
 20c:	0505                	addi	a0,a0,1
 20e:	00054783          	lbu	a5,0(a0)
 212:	fbfd                	bnez	a5,208 <strchr+0xc>
      return (char*)s;
  return 0;
 214:	4501                	li	a0,0
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
  return 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <strchr+0x1a>

0000000000000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	711d                	addi	sp,sp,-96
 222:	ec86                	sd	ra,88(sp)
 224:	e8a2                	sd	s0,80(sp)
 226:	e4a6                	sd	s1,72(sp)
 228:	e0ca                	sd	s2,64(sp)
 22a:	fc4e                	sd	s3,56(sp)
 22c:	f852                	sd	s4,48(sp)
 22e:	f456                	sd	s5,40(sp)
 230:	f05a                	sd	s6,32(sp)
 232:	ec5e                	sd	s7,24(sp)
 234:	1080                	addi	s0,sp,96
 236:	8baa                	mv	s7,a0
 238:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23a:	892a                	mv	s2,a0
 23c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4aa9                	li	s5,10
 240:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 242:	89a6                	mv	s3,s1
 244:	2485                	addiw	s1,s1,1
 246:	0344d863          	bge	s1,s4,276 <gets+0x56>
    cc = read(0, &c, 1);
 24a:	4605                	li	a2,1
 24c:	faf40593          	addi	a1,s0,-81
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	19c080e7          	jalr	412(ra) # 3ee <read>
    if(cc < 1)
 25a:	00a05e63          	blez	a0,276 <gets+0x56>
    buf[i++] = c;
 25e:	faf44783          	lbu	a5,-81(s0)
 262:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 266:	01578763          	beq	a5,s5,274 <gets+0x54>
 26a:	0905                	addi	s2,s2,1
 26c:	fd679be3          	bne	a5,s6,242 <gets+0x22>
  for(i=0; i+1 < max; ){
 270:	89a6                	mv	s3,s1
 272:	a011                	j	276 <gets+0x56>
 274:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 276:	99de                	add	s3,s3,s7
 278:	00098023          	sb	zero,0(s3)
  return buf;
}
 27c:	855e                	mv	a0,s7
 27e:	60e6                	ld	ra,88(sp)
 280:	6446                	ld	s0,80(sp)
 282:	64a6                	ld	s1,72(sp)
 284:	6906                	ld	s2,64(sp)
 286:	79e2                	ld	s3,56(sp)
 288:	7a42                	ld	s4,48(sp)
 28a:	7aa2                	ld	s5,40(sp)
 28c:	7b02                	ld	s6,32(sp)
 28e:	6be2                	ld	s7,24(sp)
 290:	6125                	addi	sp,sp,96
 292:	8082                	ret

0000000000000294 <stat>:

int
stat(const char *n, struct stat *st)
{
 294:	1101                	addi	sp,sp,-32
 296:	ec06                	sd	ra,24(sp)
 298:	e822                	sd	s0,16(sp)
 29a:	e426                	sd	s1,8(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	00000097          	auipc	ra,0x0
 2a8:	172080e7          	jalr	370(ra) # 416 <open>
  if(fd < 0)
 2ac:	02054563          	bltz	a0,2d6 <stat+0x42>
 2b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b2:	85ca                	mv	a1,s2
 2b4:	00000097          	auipc	ra,0x0
 2b8:	17a080e7          	jalr	378(ra) # 42e <fstat>
 2bc:	892a                	mv	s2,a0
  close(fd);
 2be:	8526                	mv	a0,s1
 2c0:	00000097          	auipc	ra,0x0
 2c4:	13e080e7          	jalr	318(ra) # 3fe <close>
  return r;
}
 2c8:	854a                	mv	a0,s2
 2ca:	60e2                	ld	ra,24(sp)
 2cc:	6442                	ld	s0,16(sp)
 2ce:	64a2                	ld	s1,8(sp)
 2d0:	6902                	ld	s2,0(sp)
 2d2:	6105                	addi	sp,sp,32
 2d4:	8082                	ret
    return -1;
 2d6:	597d                	li	s2,-1
 2d8:	bfc5                	j	2c8 <stat+0x34>

00000000000002da <atoi>:

int
atoi(const char *s)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e0:	00054603          	lbu	a2,0(a0)
 2e4:	fd06079b          	addiw	a5,a2,-48
 2e8:	0ff7f793          	andi	a5,a5,255
 2ec:	4725                	li	a4,9
 2ee:	02f76963          	bltu	a4,a5,320 <atoi+0x46>
 2f2:	86aa                	mv	a3,a0
  n = 0;
 2f4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2f6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2f8:	0685                	addi	a3,a3,1
 2fa:	0025179b          	slliw	a5,a0,0x2
 2fe:	9fa9                	addw	a5,a5,a0
 300:	0017979b          	slliw	a5,a5,0x1
 304:	9fb1                	addw	a5,a5,a2
 306:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 30a:	0006c603          	lbu	a2,0(a3)
 30e:	fd06071b          	addiw	a4,a2,-48
 312:	0ff77713          	andi	a4,a4,255
 316:	fee5f1e3          	bgeu	a1,a4,2f8 <atoi+0x1e>
  return n;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  n = 0;
 320:	4501                	li	a0,0
 322:	bfe5                	j	31a <atoi+0x40>

0000000000000324 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 32a:	02b57463          	bgeu	a0,a1,352 <memmove+0x2e>
    while(n-- > 0)
 32e:	00c05f63          	blez	a2,34c <memmove+0x28>
 332:	1602                	slli	a2,a2,0x20
 334:	9201                	srli	a2,a2,0x20
 336:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 33a:	872a                	mv	a4,a0
      *dst++ = *src++;
 33c:	0585                	addi	a1,a1,1
 33e:	0705                	addi	a4,a4,1
 340:	fff5c683          	lbu	a3,-1(a1)
 344:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 348:	fee79ae3          	bne	a5,a4,33c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    dst += n;
 352:	00c50733          	add	a4,a0,a2
    src += n;
 356:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 358:	fec05ae3          	blez	a2,34c <memmove+0x28>
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fee79ae3          	bne	a5,a4,36a <memmove+0x46>
 37a:	bfc9                	j	34c <memmove+0x28>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 382:	ca05                	beqz	a2,3b2 <memcmp+0x36>
 384:	fff6069b          	addiw	a3,a2,-1
 388:	1682                	slli	a3,a3,0x20
 38a:	9281                	srli	a3,a3,0x20
 38c:	0685                	addi	a3,a3,1
 38e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 390:	00054783          	lbu	a5,0(a0)
 394:	0005c703          	lbu	a4,0(a1)
 398:	00e79863          	bne	a5,a4,3a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 39c:	0505                	addi	a0,a0,1
    p2++;
 39e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3a0:	fed518e3          	bne	a0,a3,390 <memcmp+0x14>
  }
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	a019                	j	3ac <memcmp+0x30>
      return *p1 - *p2;
 3a8:	40e7853b          	subw	a0,a5,a4
}
 3ac:	6422                	ld	s0,8(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfe5                	j	3ac <memcmp+0x30>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f66080e7          	jalr	-154(ra) # 324 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 476:	48d9                	li	a7,22
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 47e:	48dd                	li	a7,23
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	1000                	addi	s0,sp,32
 48e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 492:	4605                	li	a2,1
 494:	fef40593          	addi	a1,s0,-17
 498:	00000097          	auipc	ra,0x0
 49c:	f5e080e7          	jalr	-162(ra) # 3f6 <write>
}
 4a0:	60e2                	ld	ra,24(sp)
 4a2:	6442                	ld	s0,16(sp)
 4a4:	6105                	addi	sp,sp,32
 4a6:	8082                	ret

00000000000004a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	7139                	addi	sp,sp,-64
 4aa:	fc06                	sd	ra,56(sp)
 4ac:	f822                	sd	s0,48(sp)
 4ae:	f426                	sd	s1,40(sp)
 4b0:	f04a                	sd	s2,32(sp)
 4b2:	ec4e                	sd	s3,24(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	c299                	beqz	a3,4be <printint+0x16>
 4ba:	0805c863          	bltz	a1,54a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4be:	2581                	sext.w	a1,a1
  neg = 0;
 4c0:	4881                	li	a7,0
 4c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c8:	2601                	sext.w	a2,a2
 4ca:	00000517          	auipc	a0,0x0
 4ce:	48650513          	addi	a0,a0,1158 # 950 <digits>
 4d2:	883a                	mv	a6,a4
 4d4:	2705                	addiw	a4,a4,1
 4d6:	02c5f7bb          	remuw	a5,a1,a2
 4da:	1782                	slli	a5,a5,0x20
 4dc:	9381                	srli	a5,a5,0x20
 4de:	97aa                	add	a5,a5,a0
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e8:	0005879b          	sext.w	a5,a1
 4ec:	02c5d5bb          	divuw	a1,a1,a2
 4f0:	0685                	addi	a3,a3,1
 4f2:	fec7f0e3          	bgeu	a5,a2,4d2 <printint+0x2a>
  if(neg)
 4f6:	00088b63          	beqz	a7,50c <printint+0x64>
    buf[i++] = '-';
 4fa:	fd040793          	addi	a5,s0,-48
 4fe:	973e                	add	a4,a4,a5
 500:	02d00793          	li	a5,45
 504:	fef70823          	sb	a5,-16(a4)
 508:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 50c:	02e05863          	blez	a4,53c <printint+0x94>
 510:	fc040793          	addi	a5,s0,-64
 514:	00e78933          	add	s2,a5,a4
 518:	fff78993          	addi	s3,a5,-1
 51c:	99ba                	add	s3,s3,a4
 51e:	377d                	addiw	a4,a4,-1
 520:	1702                	slli	a4,a4,0x20
 522:	9301                	srli	a4,a4,0x20
 524:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 528:	fff94583          	lbu	a1,-1(s2)
 52c:	8526                	mv	a0,s1
 52e:	00000097          	auipc	ra,0x0
 532:	f58080e7          	jalr	-168(ra) # 486 <putc>
  while(--i >= 0)
 536:	197d                	addi	s2,s2,-1
 538:	ff3918e3          	bne	s2,s3,528 <printint+0x80>
}
 53c:	70e2                	ld	ra,56(sp)
 53e:	7442                	ld	s0,48(sp)
 540:	74a2                	ld	s1,40(sp)
 542:	7902                	ld	s2,32(sp)
 544:	69e2                	ld	s3,24(sp)
 546:	6121                	addi	sp,sp,64
 548:	8082                	ret
    x = -xx;
 54a:	40b005bb          	negw	a1,a1
    neg = 1;
 54e:	4885                	li	a7,1
    x = -xx;
 550:	bf8d                	j	4c2 <printint+0x1a>

0000000000000552 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 552:	7119                	addi	sp,sp,-128
 554:	fc86                	sd	ra,120(sp)
 556:	f8a2                	sd	s0,112(sp)
 558:	f4a6                	sd	s1,104(sp)
 55a:	f0ca                	sd	s2,96(sp)
 55c:	ecce                	sd	s3,88(sp)
 55e:	e8d2                	sd	s4,80(sp)
 560:	e4d6                	sd	s5,72(sp)
 562:	e0da                	sd	s6,64(sp)
 564:	fc5e                	sd	s7,56(sp)
 566:	f862                	sd	s8,48(sp)
 568:	f466                	sd	s9,40(sp)
 56a:	f06a                	sd	s10,32(sp)
 56c:	ec6e                	sd	s11,24(sp)
 56e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 570:	0005c903          	lbu	s2,0(a1)
 574:	18090f63          	beqz	s2,712 <vprintf+0x1c0>
 578:	8aaa                	mv	s5,a0
 57a:	8b32                	mv	s6,a2
 57c:	00158493          	addi	s1,a1,1
  state = 0;
 580:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 582:	02500a13          	li	s4,37
      if(c == 'd'){
 586:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 58a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 58e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 592:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 596:	00000b97          	auipc	s7,0x0
 59a:	3bab8b93          	addi	s7,s7,954 # 950 <digits>
 59e:	a839                	j	5bc <vprintf+0x6a>
        putc(fd, c);
 5a0:	85ca                	mv	a1,s2
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	ee2080e7          	jalr	-286(ra) # 486 <putc>
 5ac:	a019                	j	5b2 <vprintf+0x60>
    } else if(state == '%'){
 5ae:	01498f63          	beq	s3,s4,5cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5b2:	0485                	addi	s1,s1,1
 5b4:	fff4c903          	lbu	s2,-1(s1)
 5b8:	14090d63          	beqz	s2,712 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5c0:	fe0997e3          	bnez	s3,5ae <vprintf+0x5c>
      if(c == '%'){
 5c4:	fd479ee3          	bne	a5,s4,5a0 <vprintf+0x4e>
        state = '%';
 5c8:	89be                	mv	s3,a5
 5ca:	b7e5                	j	5b2 <vprintf+0x60>
      if(c == 'd'){
 5cc:	05878063          	beq	a5,s8,60c <vprintf+0xba>
      } else if(c == 'l') {
 5d0:	05978c63          	beq	a5,s9,628 <vprintf+0xd6>
      } else if(c == 'x') {
 5d4:	07a78863          	beq	a5,s10,644 <vprintf+0xf2>
      } else if(c == 'p') {
 5d8:	09b78463          	beq	a5,s11,660 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5dc:	07300713          	li	a4,115
 5e0:	0ce78663          	beq	a5,a4,6ac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e4:	06300713          	li	a4,99
 5e8:	0ee78e63          	beq	a5,a4,6e4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5ec:	11478863          	beq	a5,s4,6fc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f0:	85d2                	mv	a1,s4
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e92080e7          	jalr	-366(ra) # 486 <putc>
        putc(fd, c);
 5fc:	85ca                	mv	a1,s2
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e86080e7          	jalr	-378(ra) # 486 <putc>
      }
      state = 0;
 608:	4981                	li	s3,0
 60a:	b765                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 60c:	008b0913          	addi	s2,s6,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000b2583          	lw	a1,0(s6)
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	e8e080e7          	jalr	-370(ra) # 4a8 <printint>
 622:	8b4a                	mv	s6,s2
      state = 0;
 624:	4981                	li	s3,0
 626:	b771                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b0913          	addi	s2,s6,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000b2583          	lw	a1,0(s6)
 634:	8556                	mv	a0,s5
 636:	00000097          	auipc	ra,0x0
 63a:	e72080e7          	jalr	-398(ra) # 4a8 <printint>
 63e:	8b4a                	mv	s6,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bf85                	j	5b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 644:	008b0913          	addi	s2,s6,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000b2583          	lw	a1,0(s6)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e56080e7          	jalr	-426(ra) # 4a8 <printint>
 65a:	8b4a                	mv	s6,s2
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bf91                	j	5b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 660:	008b0793          	addi	a5,s6,8
 664:	f8f43423          	sd	a5,-120(s0)
 668:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 66c:	03000593          	li	a1,48
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e14080e7          	jalr	-492(ra) # 486 <putc>
  putc(fd, 'x');
 67a:	85ea                	mv	a1,s10
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e08080e7          	jalr	-504(ra) # 486 <putc>
 686:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97de                	add	a5,a5,s7
 68e:	0007c583          	lbu	a1,0(a5)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	df2080e7          	jalr	-526(ra) # 486 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69c:	0992                	slli	s3,s3,0x4
 69e:	397d                	addiw	s2,s2,-1
 6a0:	fe0914e3          	bnez	s2,688 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b721                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 6ac:	008b0993          	addi	s3,s6,8
 6b0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6b4:	02090163          	beqz	s2,6d6 <vprintf+0x184>
        while(*s != 0){
 6b8:	00094583          	lbu	a1,0(s2)
 6bc:	c9a1                	beqz	a1,70c <vprintf+0x1ba>
          putc(fd, *s);
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	dc6080e7          	jalr	-570(ra) # 486 <putc>
          s++;
 6c8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9e5                	bnez	a1,6be <vprintf+0x16c>
        s = va_arg(ap, char*);
 6d0:	8b4e                	mv	s6,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bdf9                	j	5b2 <vprintf+0x60>
          s = "(null)";
 6d6:	00000917          	auipc	s2,0x0
 6da:	27290913          	addi	s2,s2,626 # 948 <malloc+0x12c>
        while(*s != 0){
 6de:	02800593          	li	a1,40
 6e2:	bff1                	j	6be <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6e4:	008b0913          	addi	s2,s6,8
 6e8:	000b4583          	lbu	a1,0(s6)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d98080e7          	jalr	-616(ra) # 486 <putc>
 6f6:	8b4a                	mv	s6,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bd65                	j	5b2 <vprintf+0x60>
        putc(fd, c);
 6fc:	85d2                	mv	a1,s4
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	d86080e7          	jalr	-634(ra) # 486 <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	b565                	j	5b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 70c:	8b4e                	mv	s6,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	b54d                	j	5b2 <vprintf+0x60>
    }
  }
}
 712:	70e6                	ld	ra,120(sp)
 714:	7446                	ld	s0,112(sp)
 716:	74a6                	ld	s1,104(sp)
 718:	7906                	ld	s2,96(sp)
 71a:	69e6                	ld	s3,88(sp)
 71c:	6a46                	ld	s4,80(sp)
 71e:	6aa6                	ld	s5,72(sp)
 720:	6b06                	ld	s6,64(sp)
 722:	7be2                	ld	s7,56(sp)
 724:	7c42                	ld	s8,48(sp)
 726:	7ca2                	ld	s9,40(sp)
 728:	7d02                	ld	s10,32(sp)
 72a:	6de2                	ld	s11,24(sp)
 72c:	6109                	addi	sp,sp,128
 72e:	8082                	ret

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	addi	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74c:	8622                	mv	a2,s0
 74e:	00000097          	auipc	ra,0x0
 752:	e04080e7          	jalr	-508(ra) # 552 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	addi	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	addi	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	addi	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	00000097          	auipc	ra,0x0
 788:	dce080e7          	jalr	-562(ra) # 552 <vprintf>
}
 78c:	60e2                	ld	ra,24(sp)
 78e:	6442                	ld	s0,16(sp)
 790:	6125                	addi	sp,sp,96
 792:	8082                	ret

0000000000000794 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 794:	1141                	addi	sp,sp,-16
 796:	e422                	sd	s0,8(sp)
 798:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79e:	00001797          	auipc	a5,0x1
 7a2:	8627b783          	ld	a5,-1950(a5) # 1000 <freep>
 7a6:	a805                	j	7d6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a8:	4618                	lw	a4,8(a2)
 7aa:	9db9                	addw	a1,a1,a4
 7ac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	6398                	ld	a4,0(a5)
 7b2:	6318                	ld	a4,0(a4)
 7b4:	fee53823          	sd	a4,-16(a0)
 7b8:	a091                	j	7fc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ba:	ff852703          	lw	a4,-8(a0)
 7be:	9e39                	addw	a2,a2,a4
 7c0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7c2:	ff053703          	ld	a4,-16(a0)
 7c6:	e398                	sd	a4,0(a5)
 7c8:	a099                	j	80e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e7e463          	bltu	a5,a4,7d4 <free+0x40>
 7d0:	00e6ea63          	bltu	a3,a4,7e4 <free+0x50>
{
 7d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	fed7fae3          	bgeu	a5,a3,7ca <free+0x36>
 7da:	6398                	ld	a4,0(a5)
 7dc:	00e6e463          	bltu	a3,a4,7e4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	fee7eae3          	bltu	a5,a4,7d4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7e4:	ff852583          	lw	a1,-8(a0)
 7e8:	6390                	ld	a2,0(a5)
 7ea:	02059713          	slli	a4,a1,0x20
 7ee:	9301                	srli	a4,a4,0x20
 7f0:	0712                	slli	a4,a4,0x4
 7f2:	9736                	add	a4,a4,a3
 7f4:	fae60ae3          	beq	a2,a4,7a8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7fc:	4790                	lw	a2,8(a5)
 7fe:	02061713          	slli	a4,a2,0x20
 802:	9301                	srli	a4,a4,0x20
 804:	0712                	slli	a4,a4,0x4
 806:	973e                	add	a4,a4,a5
 808:	fae689e3          	beq	a3,a4,7ba <free+0x26>
  } else
    p->s.ptr = bp;
 80c:	e394                	sd	a3,0(a5)
  freep = p;
 80e:	00000717          	auipc	a4,0x0
 812:	7ef73923          	sd	a5,2034(a4) # 1000 <freep>
}
 816:	6422                	ld	s0,8(sp)
 818:	0141                	addi	sp,sp,16
 81a:	8082                	ret

000000000000081c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81c:	7139                	addi	sp,sp,-64
 81e:	fc06                	sd	ra,56(sp)
 820:	f822                	sd	s0,48(sp)
 822:	f426                	sd	s1,40(sp)
 824:	f04a                	sd	s2,32(sp)
 826:	ec4e                	sd	s3,24(sp)
 828:	e852                	sd	s4,16(sp)
 82a:	e456                	sd	s5,8(sp)
 82c:	e05a                	sd	s6,0(sp)
 82e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 830:	02051493          	slli	s1,a0,0x20
 834:	9081                	srli	s1,s1,0x20
 836:	04bd                	addi	s1,s1,15
 838:	8091                	srli	s1,s1,0x4
 83a:	0014899b          	addiw	s3,s1,1
 83e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 840:	00000517          	auipc	a0,0x0
 844:	7c053503          	ld	a0,1984(a0) # 1000 <freep>
 848:	c515                	beqz	a0,874 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	02977f63          	bgeu	a4,s1,88c <malloc+0x70>
 852:	8a4e                	mv	s4,s3
 854:	0009871b          	sext.w	a4,s3
 858:	6685                	lui	a3,0x1
 85a:	00d77363          	bgeu	a4,a3,860 <malloc+0x44>
 85e:	6a05                	lui	s4,0x1
 860:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 864:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 868:	00000917          	auipc	s2,0x0
 86c:	79890913          	addi	s2,s2,1944 # 1000 <freep>
  if(p == (char*)-1)
 870:	5afd                	li	s5,-1
 872:	a88d                	j	8e4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 874:	00001797          	auipc	a5,0x1
 878:	99c78793          	addi	a5,a5,-1636 # 1210 <base>
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
 884:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 886:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88a:	b7e1                	j	852 <malloc+0x36>
      if(p->s.size == nunits)
 88c:	02e48b63          	beq	s1,a4,8c2 <malloc+0xa6>
        p->s.size -= nunits;
 890:	4137073b          	subw	a4,a4,s3
 894:	c798                	sw	a4,8(a5)
        p += p->s.size;
 896:	1702                	slli	a4,a4,0x20
 898:	9301                	srli	a4,a4,0x20
 89a:	0712                	slli	a4,a4,0x4
 89c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a2:	00000717          	auipc	a4,0x0
 8a6:	74a73f23          	sd	a0,1886(a4) # 1000 <freep>
      return (void*)(p + 1);
 8aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	74a2                	ld	s1,40(sp)
 8b4:	7902                	ld	s2,32(sp)
 8b6:	69e2                	ld	s3,24(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	6121                	addi	sp,sp,64
 8c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8c2:	6398                	ld	a4,0(a5)
 8c4:	e118                	sd	a4,0(a0)
 8c6:	bff1                	j	8a2 <malloc+0x86>
  hp->s.size = nu;
 8c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8cc:	0541                	addi	a0,a0,16
 8ce:	00000097          	auipc	ra,0x0
 8d2:	ec6080e7          	jalr	-314(ra) # 794 <free>
  return freep;
 8d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8da:	d971                	beqz	a0,8ae <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	fa9776e3          	bgeu	a4,s1,88c <malloc+0x70>
    if(p == freep)
 8e4:	00093703          	ld	a4,0(s2)
 8e8:	853e                	mv	a0,a5
 8ea:	fef719e3          	bne	a4,a5,8dc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8ee:	8552                	mv	a0,s4
 8f0:	00000097          	auipc	ra,0x0
 8f4:	b6e080e7          	jalr	-1170(ra) # 45e <sbrk>
  if(p == (char*)-1)
 8f8:	fd5518e3          	bne	a0,s5,8c8 <malloc+0xac>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	bf45                	j	8ae <malloc+0x92>
