
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	958a0a13          	addi	s4,s4,-1704 # 990 <malloc+0xec>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	226080e7          	jalr	550(ra) # 26c <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
      c++;
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3dc080e7          	jalr	988(ra) # 45e <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1,"");
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	8fa50513          	addi	a0,a0,-1798 # 9b0 <malloc+0x10c>
  be:	00000097          	auipc	ra,0x0
  c2:	728080e7          	jalr	1832(ra) # 7e6 <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	8b450513          	addi	a0,a0,-1868 # 998 <malloc+0xf4>
  ec:	00000097          	auipc	ra,0x0
  f0:	6fa080e7          	jalr	1786(ra) # 7e6 <printf>
    exit(1,"");
  f4:	00001597          	auipc	a1,0x1
  f8:	8b458593          	addi	a1,a1,-1868 # 9a8 <malloc+0x104>
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	348080e7          	jalr	840(ra) # 446 <exit>

0000000000000106 <main>:

int
main(int argc, char *argv[])
{
 106:	7179                	addi	sp,sp,-48
 108:	f406                	sd	ra,40(sp)
 10a:	f022                	sd	s0,32(sp)
 10c:	ec26                	sd	s1,24(sp)
 10e:	e84a                	sd	s2,16(sp)
 110:	e44e                	sd	s3,8(sp)
 112:	e052                	sd	s4,0(sp)
 114:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 116:	4785                	li	a5,1
 118:	04a7db63          	bge	a5,a0,16e <main+0x68>
 11c:	00858493          	addi	s1,a1,8
 120:	ffe5099b          	addiw	s3,a0,-2
 124:	1982                	slli	s3,s3,0x20
 126:	0209d993          	srli	s3,s3,0x20
 12a:	098e                	slli	s3,s3,0x3
 12c:	05c1                	addi	a1,a1,16
 12e:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0,"");
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 130:	4581                	li	a1,0
 132:	6088                	ld	a0,0(s1)
 134:	00000097          	auipc	ra,0x0
 138:	352080e7          	jalr	850(ra) # 486 <open>
 13c:	892a                	mv	s2,a0
 13e:	04054a63          	bltz	a0,192 <main+0x8c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1,"");
    }
    wc(fd, argv[i]);
 142:	608c                	ld	a1,0(s1)
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <wc>
    close(fd);
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	320080e7          	jalr	800(ra) # 46e <close>
  for(i = 1; i < argc; i++){
 156:	04a1                	addi	s1,s1,8
 158:	fd349ce3          	bne	s1,s3,130 <main+0x2a>
  }
  exit(0,"");
 15c:	00001597          	auipc	a1,0x1
 160:	84c58593          	addi	a1,a1,-1972 # 9a8 <malloc+0x104>
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	2e0080e7          	jalr	736(ra) # 446 <exit>
    wc(0, "");
 16e:	00001597          	auipc	a1,0x1
 172:	83a58593          	addi	a1,a1,-1990 # 9a8 <malloc+0x104>
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	e88080e7          	jalr	-376(ra) # 0 <wc>
    exit(0,"");
 180:	00001597          	auipc	a1,0x1
 184:	82858593          	addi	a1,a1,-2008 # 9a8 <malloc+0x104>
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	2bc080e7          	jalr	700(ra) # 446 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 192:	608c                	ld	a1,0(s1)
 194:	00001517          	auipc	a0,0x1
 198:	82c50513          	addi	a0,a0,-2004 # 9c0 <malloc+0x11c>
 19c:	00000097          	auipc	ra,0x0
 1a0:	64a080e7          	jalr	1610(ra) # 7e6 <printf>
      exit(1,"");
 1a4:	00001597          	auipc	a1,0x1
 1a8:	80458593          	addi	a1,a1,-2044 # 9a8 <malloc+0x104>
 1ac:	4505                	li	a0,1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	298080e7          	jalr	664(ra) # 446 <exit>

00000000000001b6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1be:	00000097          	auipc	ra,0x0
 1c2:	f48080e7          	jalr	-184(ra) # 106 <main>
  exit(0,"");
 1c6:	00000597          	auipc	a1,0x0
 1ca:	7e258593          	addi	a1,a1,2018 # 9a8 <malloc+0x104>
 1ce:	4501                	li	a0,0
 1d0:	00000097          	auipc	ra,0x0
 1d4:	276080e7          	jalr	630(ra) # 446 <exit>

00000000000001d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1de:	87aa                	mv	a5,a0
 1e0:	0585                	addi	a1,a1,1
 1e2:	0785                	addi	a5,a5,1
 1e4:	fff5c703          	lbu	a4,-1(a1)
 1e8:	fee78fa3          	sb	a4,-1(a5)
 1ec:	fb75                	bnez	a4,1e0 <strcpy+0x8>
    ;
  return os;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb91                	beqz	a5,212 <strcmp+0x1e>
 200:	0005c703          	lbu	a4,0(a1)
 204:	00f71763          	bne	a4,a5,212 <strcmp+0x1e>
    p++, q++;
 208:	0505                	addi	a0,a0,1
 20a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 20c:	00054783          	lbu	a5,0(a0)
 210:	fbe5                	bnez	a5,200 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 212:	0005c503          	lbu	a0,0(a1)
}
 216:	40a7853b          	subw	a0,a5,a0
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strlen>:

uint
strlen(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cf91                	beqz	a5,246 <strlen+0x26>
 22c:	0505                	addi	a0,a0,1
 22e:	87aa                	mv	a5,a0
 230:	4685                	li	a3,1
 232:	9e89                	subw	a3,a3,a0
 234:	00f6853b          	addw	a0,a3,a5
 238:	0785                	addi	a5,a5,1
 23a:	fff7c703          	lbu	a4,-1(a5)
 23e:	fb7d                	bnez	a4,234 <strlen+0x14>
    ;
  return n;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  for(n = 0; s[n]; n++)
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <strlen+0x20>

000000000000024a <memset>:

void*
memset(void *dst, int c, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 250:	ca19                	beqz	a2,266 <memset+0x1c>
 252:	87aa                	mv	a5,a0
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 25c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 260:	0785                	addi	a5,a5,1
 262:	fee79de3          	bne	a5,a4,25c <memset+0x12>
  }
  return dst;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strchr>:

char*
strchr(const char *s, char c)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  for(; *s; s++)
 272:	00054783          	lbu	a5,0(a0)
 276:	cb99                	beqz	a5,28c <strchr+0x20>
    if(*s == c)
 278:	00f58763          	beq	a1,a5,286 <strchr+0x1a>
  for(; *s; s++)
 27c:	0505                	addi	a0,a0,1
 27e:	00054783          	lbu	a5,0(a0)
 282:	fbfd                	bnez	a5,278 <strchr+0xc>
      return (char*)s;
  return 0;
 284:	4501                	li	a0,0
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strchr+0x1a>

0000000000000290 <gets>:

char*
gets(char *buf, int max)
{
 290:	711d                	addi	sp,sp,-96
 292:	ec86                	sd	ra,88(sp)
 294:	e8a2                	sd	s0,80(sp)
 296:	e4a6                	sd	s1,72(sp)
 298:	e0ca                	sd	s2,64(sp)
 29a:	fc4e                	sd	s3,56(sp)
 29c:	f852                	sd	s4,48(sp)
 29e:	f456                	sd	s5,40(sp)
 2a0:	f05a                	sd	s6,32(sp)
 2a2:	ec5e                	sd	s7,24(sp)
 2a4:	1080                	addi	s0,sp,96
 2a6:	8baa                	mv	s7,a0
 2a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2aa:	892a                	mv	s2,a0
 2ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ae:	4aa9                	li	s5,10
 2b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b2:	89a6                	mv	s3,s1
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0344d863          	bge	s1,s4,2e6 <gets+0x56>
    cc = read(0, &c, 1);
 2ba:	4605                	li	a2,1
 2bc:	faf40593          	addi	a1,s0,-81
 2c0:	4501                	li	a0,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	19c080e7          	jalr	412(ra) # 45e <read>
    if(cc < 1)
 2ca:	00a05e63          	blez	a0,2e6 <gets+0x56>
    buf[i++] = c;
 2ce:	faf44783          	lbu	a5,-81(s0)
 2d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d6:	01578763          	beq	a5,s5,2e4 <gets+0x54>
 2da:	0905                	addi	s2,s2,1
 2dc:	fd679be3          	bne	a5,s6,2b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 2e0:	89a6                	mv	s3,s1
 2e2:	a011                	j	2e6 <gets+0x56>
 2e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e6:	99de                	add	s3,s3,s7
 2e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ec:	855e                	mv	a0,s7
 2ee:	60e6                	ld	ra,88(sp)
 2f0:	6446                	ld	s0,80(sp)
 2f2:	64a6                	ld	s1,72(sp)
 2f4:	6906                	ld	s2,64(sp)
 2f6:	79e2                	ld	s3,56(sp)
 2f8:	7a42                	ld	s4,48(sp)
 2fa:	7aa2                	ld	s5,40(sp)
 2fc:	7b02                	ld	s6,32(sp)
 2fe:	6be2                	ld	s7,24(sp)
 300:	6125                	addi	sp,sp,96
 302:	8082                	ret

0000000000000304 <stat>:

int
stat(const char *n, struct stat *st)
{
 304:	1101                	addi	sp,sp,-32
 306:	ec06                	sd	ra,24(sp)
 308:	e822                	sd	s0,16(sp)
 30a:	e426                	sd	s1,8(sp)
 30c:	e04a                	sd	s2,0(sp)
 30e:	1000                	addi	s0,sp,32
 310:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 312:	4581                	li	a1,0
 314:	00000097          	auipc	ra,0x0
 318:	172080e7          	jalr	370(ra) # 486 <open>
  if(fd < 0)
 31c:	02054563          	bltz	a0,346 <stat+0x42>
 320:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 322:	85ca                	mv	a1,s2
 324:	00000097          	auipc	ra,0x0
 328:	17a080e7          	jalr	378(ra) # 49e <fstat>
 32c:	892a                	mv	s2,a0
  close(fd);
 32e:	8526                	mv	a0,s1
 330:	00000097          	auipc	ra,0x0
 334:	13e080e7          	jalr	318(ra) # 46e <close>
  return r;
}
 338:	854a                	mv	a0,s2
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	64a2                	ld	s1,8(sp)
 340:	6902                	ld	s2,0(sp)
 342:	6105                	addi	sp,sp,32
 344:	8082                	ret
    return -1;
 346:	597d                	li	s2,-1
 348:	bfc5                	j	338 <stat+0x34>

000000000000034a <atoi>:

int
atoi(const char *s)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 350:	00054603          	lbu	a2,0(a0)
 354:	fd06079b          	addiw	a5,a2,-48
 358:	0ff7f793          	andi	a5,a5,255
 35c:	4725                	li	a4,9
 35e:	02f76963          	bltu	a4,a5,390 <atoi+0x46>
 362:	86aa                	mv	a3,a0
  n = 0;
 364:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 366:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 368:	0685                	addi	a3,a3,1
 36a:	0025179b          	slliw	a5,a0,0x2
 36e:	9fa9                	addw	a5,a5,a0
 370:	0017979b          	slliw	a5,a5,0x1
 374:	9fb1                	addw	a5,a5,a2
 376:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37a:	0006c603          	lbu	a2,0(a3)
 37e:	fd06071b          	addiw	a4,a2,-48
 382:	0ff77713          	andi	a4,a4,255
 386:	fee5f1e3          	bgeu	a1,a4,368 <atoi+0x1e>
  return n;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  n = 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <atoi+0x40>

0000000000000394 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39a:	02b57463          	bgeu	a0,a1,3c2 <memmove+0x2e>
    while(n-- > 0)
 39e:	00c05f63          	blez	a2,3bc <memmove+0x28>
 3a2:	1602                	slli	a2,a2,0x20
 3a4:	9201                	srli	a2,a2,0x20
 3a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ac:	0585                	addi	a1,a1,1
 3ae:	0705                	addi	a4,a4,1
 3b0:	fff5c683          	lbu	a3,-1(a1)
 3b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b8:	fee79ae3          	bne	a5,a4,3ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
    dst += n;
 3c2:	00c50733          	add	a4,a0,a2
    src += n;
 3c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec05ae3          	blez	a2,3bc <memmove+0x28>
 3cc:	fff6079b          	addiw	a5,a2,-1
 3d0:	1782                	slli	a5,a5,0x20
 3d2:	9381                	srli	a5,a5,0x20
 3d4:	fff7c793          	not	a5,a5
 3d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3da:	15fd                	addi	a1,a1,-1
 3dc:	177d                	addi	a4,a4,-1
 3de:	0005c683          	lbu	a3,0(a1)
 3e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e6:	fee79ae3          	bne	a5,a4,3da <memmove+0x46>
 3ea:	bfc9                	j	3bc <memmove+0x28>

00000000000003ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f2:	ca05                	beqz	a2,422 <memcmp+0x36>
 3f4:	fff6069b          	addiw	a3,a2,-1
 3f8:	1682                	slli	a3,a3,0x20
 3fa:	9281                	srli	a3,a3,0x20
 3fc:	0685                	addi	a3,a3,1
 3fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 400:	00054783          	lbu	a5,0(a0)
 404:	0005c703          	lbu	a4,0(a1)
 408:	00e79863          	bne	a5,a4,418 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 40c:	0505                	addi	a0,a0,1
    p2++;
 40e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 410:	fed518e3          	bne	a0,a3,400 <memcmp+0x14>
  }
  return 0;
 414:	4501                	li	a0,0
 416:	a019                	j	41c <memcmp+0x30>
      return *p1 - *p2;
 418:	40e7853b          	subw	a0,a5,a4
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
  return 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <memcmp+0x30>

0000000000000426 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 42e:	00000097          	auipc	ra,0x0
 432:	f66080e7          	jalr	-154(ra) # 394 <memmove>
}
 436:	60a2                	ld	ra,8(sp)
 438:	6402                	ld	s0,0(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret

000000000000043e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43e:	4885                	li	a7,1
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <exit>:
.global exit
exit:
 li a7, SYS_exit
 446:	4889                	li	a7,2
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <wait>:
.global wait
wait:
 li a7, SYS_wait
 44e:	488d                	li	a7,3
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 456:	4891                	li	a7,4
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <read>:
.global read
read:
 li a7, SYS_read
 45e:	4895                	li	a7,5
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <write>:
.global write
write:
 li a7, SYS_write
 466:	48c1                	li	a7,16
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <close>:
.global close
close:
 li a7, SYS_close
 46e:	48d5                	li	a7,21
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <kill>:
.global kill
kill:
 li a7, SYS_kill
 476:	4899                	li	a7,6
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exec>:
.global exec
exec:
 li a7, SYS_exec
 47e:	489d                	li	a7,7
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <open>:
.global open
open:
 li a7, SYS_open
 486:	48bd                	li	a7,15
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48e:	48c5                	li	a7,17
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 496:	48c9                	li	a7,18
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49e:	48a1                	li	a7,8
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <link>:
.global link
link:
 li a7, SYS_link
 4a6:	48cd                	li	a7,19
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ae:	48d1                	li	a7,20
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b6:	48a5                	li	a7,9
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <dup>:
.global dup
dup:
 li a7, SYS_dup
 4be:	48a9                	li	a7,10
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c6:	48ad                	li	a7,11
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ce:	48b1                	li	a7,12
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d6:	48b5                	li	a7,13
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4de:	48b9                	li	a7,14
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 4e6:	48d9                	li	a7,22
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 4ee:	48dd                	li	a7,23
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 4f6:	48e1                	li	a7,24
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 4fe:	48e5                	li	a7,25
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 506:	48e9                	li	a7,26
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 50e:	1101                	addi	sp,sp,-32
 510:	ec06                	sd	ra,24(sp)
 512:	e822                	sd	s0,16(sp)
 514:	1000                	addi	s0,sp,32
 516:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 51a:	4605                	li	a2,1
 51c:	fef40593          	addi	a1,s0,-17
 520:	00000097          	auipc	ra,0x0
 524:	f46080e7          	jalr	-186(ra) # 466 <write>
}
 528:	60e2                	ld	ra,24(sp)
 52a:	6442                	ld	s0,16(sp)
 52c:	6105                	addi	sp,sp,32
 52e:	8082                	ret

0000000000000530 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	7139                	addi	sp,sp,-64
 532:	fc06                	sd	ra,56(sp)
 534:	f822                	sd	s0,48(sp)
 536:	f426                	sd	s1,40(sp)
 538:	f04a                	sd	s2,32(sp)
 53a:	ec4e                	sd	s3,24(sp)
 53c:	0080                	addi	s0,sp,64
 53e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 540:	c299                	beqz	a3,546 <printint+0x16>
 542:	0805c863          	bltz	a1,5d2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 546:	2581                	sext.w	a1,a1
  neg = 0;
 548:	4881                	li	a7,0
 54a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 54e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 550:	2601                	sext.w	a2,a2
 552:	00000517          	auipc	a0,0x0
 556:	48e50513          	addi	a0,a0,1166 # 9e0 <digits>
 55a:	883a                	mv	a6,a4
 55c:	2705                	addiw	a4,a4,1
 55e:	02c5f7bb          	remuw	a5,a1,a2
 562:	1782                	slli	a5,a5,0x20
 564:	9381                	srli	a5,a5,0x20
 566:	97aa                	add	a5,a5,a0
 568:	0007c783          	lbu	a5,0(a5)
 56c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 570:	0005879b          	sext.w	a5,a1
 574:	02c5d5bb          	divuw	a1,a1,a2
 578:	0685                	addi	a3,a3,1
 57a:	fec7f0e3          	bgeu	a5,a2,55a <printint+0x2a>
  if(neg)
 57e:	00088b63          	beqz	a7,594 <printint+0x64>
    buf[i++] = '-';
 582:	fd040793          	addi	a5,s0,-48
 586:	973e                	add	a4,a4,a5
 588:	02d00793          	li	a5,45
 58c:	fef70823          	sb	a5,-16(a4)
 590:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 594:	02e05863          	blez	a4,5c4 <printint+0x94>
 598:	fc040793          	addi	a5,s0,-64
 59c:	00e78933          	add	s2,a5,a4
 5a0:	fff78993          	addi	s3,a5,-1
 5a4:	99ba                	add	s3,s3,a4
 5a6:	377d                	addiw	a4,a4,-1
 5a8:	1702                	slli	a4,a4,0x20
 5aa:	9301                	srli	a4,a4,0x20
 5ac:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b0:	fff94583          	lbu	a1,-1(s2)
 5b4:	8526                	mv	a0,s1
 5b6:	00000097          	auipc	ra,0x0
 5ba:	f58080e7          	jalr	-168(ra) # 50e <putc>
  while(--i >= 0)
 5be:	197d                	addi	s2,s2,-1
 5c0:	ff3918e3          	bne	s2,s3,5b0 <printint+0x80>
}
 5c4:	70e2                	ld	ra,56(sp)
 5c6:	7442                	ld	s0,48(sp)
 5c8:	74a2                	ld	s1,40(sp)
 5ca:	7902                	ld	s2,32(sp)
 5cc:	69e2                	ld	s3,24(sp)
 5ce:	6121                	addi	sp,sp,64
 5d0:	8082                	ret
    x = -xx;
 5d2:	40b005bb          	negw	a1,a1
    neg = 1;
 5d6:	4885                	li	a7,1
    x = -xx;
 5d8:	bf8d                	j	54a <printint+0x1a>

00000000000005da <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5da:	7119                	addi	sp,sp,-128
 5dc:	fc86                	sd	ra,120(sp)
 5de:	f8a2                	sd	s0,112(sp)
 5e0:	f4a6                	sd	s1,104(sp)
 5e2:	f0ca                	sd	s2,96(sp)
 5e4:	ecce                	sd	s3,88(sp)
 5e6:	e8d2                	sd	s4,80(sp)
 5e8:	e4d6                	sd	s5,72(sp)
 5ea:	e0da                	sd	s6,64(sp)
 5ec:	fc5e                	sd	s7,56(sp)
 5ee:	f862                	sd	s8,48(sp)
 5f0:	f466                	sd	s9,40(sp)
 5f2:	f06a                	sd	s10,32(sp)
 5f4:	ec6e                	sd	s11,24(sp)
 5f6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f8:	0005c903          	lbu	s2,0(a1)
 5fc:	18090f63          	beqz	s2,79a <vprintf+0x1c0>
 600:	8aaa                	mv	s5,a0
 602:	8b32                	mv	s6,a2
 604:	00158493          	addi	s1,a1,1
  state = 0;
 608:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60a:	02500a13          	li	s4,37
      if(c == 'd'){
 60e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 612:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 616:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 61a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61e:	00000b97          	auipc	s7,0x0
 622:	3c2b8b93          	addi	s7,s7,962 # 9e0 <digits>
 626:	a839                	j	644 <vprintf+0x6a>
        putc(fd, c);
 628:	85ca                	mv	a1,s2
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	ee2080e7          	jalr	-286(ra) # 50e <putc>
 634:	a019                	j	63a <vprintf+0x60>
    } else if(state == '%'){
 636:	01498f63          	beq	s3,s4,654 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 63a:	0485                	addi	s1,s1,1
 63c:	fff4c903          	lbu	s2,-1(s1)
 640:	14090d63          	beqz	s2,79a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 644:	0009079b          	sext.w	a5,s2
    if(state == 0){
 648:	fe0997e3          	bnez	s3,636 <vprintf+0x5c>
      if(c == '%'){
 64c:	fd479ee3          	bne	a5,s4,628 <vprintf+0x4e>
        state = '%';
 650:	89be                	mv	s3,a5
 652:	b7e5                	j	63a <vprintf+0x60>
      if(c == 'd'){
 654:	05878063          	beq	a5,s8,694 <vprintf+0xba>
      } else if(c == 'l') {
 658:	05978c63          	beq	a5,s9,6b0 <vprintf+0xd6>
      } else if(c == 'x') {
 65c:	07a78863          	beq	a5,s10,6cc <vprintf+0xf2>
      } else if(c == 'p') {
 660:	09b78463          	beq	a5,s11,6e8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 664:	07300713          	li	a4,115
 668:	0ce78663          	beq	a5,a4,734 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66c:	06300713          	li	a4,99
 670:	0ee78e63          	beq	a5,a4,76c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 674:	11478863          	beq	a5,s4,784 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 678:	85d2                	mv	a1,s4
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e92080e7          	jalr	-366(ra) # 50e <putc>
        putc(fd, c);
 684:	85ca                	mv	a1,s2
 686:	8556                	mv	a0,s5
 688:	00000097          	auipc	ra,0x0
 68c:	e86080e7          	jalr	-378(ra) # 50e <putc>
      }
      state = 0;
 690:	4981                	li	s3,0
 692:	b765                	j	63a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 694:	008b0913          	addi	s2,s6,8
 698:	4685                	li	a3,1
 69a:	4629                	li	a2,10
 69c:	000b2583          	lw	a1,0(s6)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e8e080e7          	jalr	-370(ra) # 530 <printint>
 6aa:	8b4a                	mv	s6,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b771                	j	63a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	008b0913          	addi	s2,s6,8
 6b4:	4681                	li	a3,0
 6b6:	4629                	li	a2,10
 6b8:	000b2583          	lw	a1,0(s6)
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e72080e7          	jalr	-398(ra) # 530 <printint>
 6c6:	8b4a                	mv	s6,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bf85                	j	63a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6cc:	008b0913          	addi	s2,s6,8
 6d0:	4681                	li	a3,0
 6d2:	4641                	li	a2,16
 6d4:	000b2583          	lw	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e56080e7          	jalr	-426(ra) # 530 <printint>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bf91                	j	63a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6e8:	008b0793          	addi	a5,s6,8
 6ec:	f8f43423          	sd	a5,-120(s0)
 6f0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6f4:	03000593          	li	a1,48
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	e14080e7          	jalr	-492(ra) # 50e <putc>
  putc(fd, 'x');
 702:	85ea                	mv	a1,s10
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e08080e7          	jalr	-504(ra) # 50e <putc>
 70e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	03c9d793          	srli	a5,s3,0x3c
 714:	97de                	add	a5,a5,s7
 716:	0007c583          	lbu	a1,0(a5)
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	df2080e7          	jalr	-526(ra) # 50e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 724:	0992                	slli	s3,s3,0x4
 726:	397d                	addiw	s2,s2,-1
 728:	fe0914e3          	bnez	s2,710 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 72c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 730:	4981                	li	s3,0
 732:	b721                	j	63a <vprintf+0x60>
        s = va_arg(ap, char*);
 734:	008b0993          	addi	s3,s6,8
 738:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 73c:	02090163          	beqz	s2,75e <vprintf+0x184>
        while(*s != 0){
 740:	00094583          	lbu	a1,0(s2)
 744:	c9a1                	beqz	a1,794 <vprintf+0x1ba>
          putc(fd, *s);
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	dc6080e7          	jalr	-570(ra) # 50e <putc>
          s++;
 750:	0905                	addi	s2,s2,1
        while(*s != 0){
 752:	00094583          	lbu	a1,0(s2)
 756:	f9e5                	bnez	a1,746 <vprintf+0x16c>
        s = va_arg(ap, char*);
 758:	8b4e                	mv	s6,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bdf9                	j	63a <vprintf+0x60>
          s = "(null)";
 75e:	00000917          	auipc	s2,0x0
 762:	27a90913          	addi	s2,s2,634 # 9d8 <malloc+0x134>
        while(*s != 0){
 766:	02800593          	li	a1,40
 76a:	bff1                	j	746 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 76c:	008b0913          	addi	s2,s6,8
 770:	000b4583          	lbu	a1,0(s6)
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	d98080e7          	jalr	-616(ra) # 50e <putc>
 77e:	8b4a                	mv	s6,s2
      state = 0;
 780:	4981                	li	s3,0
 782:	bd65                	j	63a <vprintf+0x60>
        putc(fd, c);
 784:	85d2                	mv	a1,s4
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	d86080e7          	jalr	-634(ra) # 50e <putc>
      state = 0;
 790:	4981                	li	s3,0
 792:	b565                	j	63a <vprintf+0x60>
        s = va_arg(ap, char*);
 794:	8b4e                	mv	s6,s3
      state = 0;
 796:	4981                	li	s3,0
 798:	b54d                	j	63a <vprintf+0x60>
    }
  }
}
 79a:	70e6                	ld	ra,120(sp)
 79c:	7446                	ld	s0,112(sp)
 79e:	74a6                	ld	s1,104(sp)
 7a0:	7906                	ld	s2,96(sp)
 7a2:	69e6                	ld	s3,88(sp)
 7a4:	6a46                	ld	s4,80(sp)
 7a6:	6aa6                	ld	s5,72(sp)
 7a8:	6b06                	ld	s6,64(sp)
 7aa:	7be2                	ld	s7,56(sp)
 7ac:	7c42                	ld	s8,48(sp)
 7ae:	7ca2                	ld	s9,40(sp)
 7b0:	7d02                	ld	s10,32(sp)
 7b2:	6de2                	ld	s11,24(sp)
 7b4:	6109                	addi	sp,sp,128
 7b6:	8082                	ret

00000000000007b8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b8:	715d                	addi	sp,sp,-80
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e010                	sd	a2,0(s0)
 7c2:	e414                	sd	a3,8(s0)
 7c4:	e818                	sd	a4,16(s0)
 7c6:	ec1c                	sd	a5,24(s0)
 7c8:	03043023          	sd	a6,32(s0)
 7cc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d4:	8622                	mv	a2,s0
 7d6:	00000097          	auipc	ra,0x0
 7da:	e04080e7          	jalr	-508(ra) # 5da <vprintf>
}
 7de:	60e2                	ld	ra,24(sp)
 7e0:	6442                	ld	s0,16(sp)
 7e2:	6161                	addi	sp,sp,80
 7e4:	8082                	ret

00000000000007e6 <printf>:

void
printf(const char *fmt, ...)
{
 7e6:	711d                	addi	sp,sp,-96
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	1000                	addi	s0,sp,32
 7ee:	e40c                	sd	a1,8(s0)
 7f0:	e810                	sd	a2,16(s0)
 7f2:	ec14                	sd	a3,24(s0)
 7f4:	f018                	sd	a4,32(s0)
 7f6:	f41c                	sd	a5,40(s0)
 7f8:	03043823          	sd	a6,48(s0)
 7fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 800:	00840613          	addi	a2,s0,8
 804:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 808:	85aa                	mv	a1,a0
 80a:	4505                	li	a0,1
 80c:	00000097          	auipc	ra,0x0
 810:	dce080e7          	jalr	-562(ra) # 5da <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81c:	1141                	addi	sp,sp,-16
 81e:	e422                	sd	s0,8(sp)
 820:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 822:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	00000797          	auipc	a5,0x0
 82a:	7da7b783          	ld	a5,2010(a5) # 1000 <freep>
 82e:	a805                	j	85e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 830:	4618                	lw	a4,8(a2)
 832:	9db9                	addw	a1,a1,a4
 834:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 838:	6398                	ld	a4,0(a5)
 83a:	6318                	ld	a4,0(a4)
 83c:	fee53823          	sd	a4,-16(a0)
 840:	a091                	j	884 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 842:	ff852703          	lw	a4,-8(a0)
 846:	9e39                	addw	a2,a2,a4
 848:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 84a:	ff053703          	ld	a4,-16(a0)
 84e:	e398                	sd	a4,0(a5)
 850:	a099                	j	896 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	6398                	ld	a4,0(a5)
 854:	00e7e463          	bltu	a5,a4,85c <free+0x40>
 858:	00e6ea63          	bltu	a3,a4,86c <free+0x50>
{
 85c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	fed7fae3          	bgeu	a5,a3,852 <free+0x36>
 862:	6398                	ld	a4,0(a5)
 864:	00e6e463          	bltu	a3,a4,86c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	fee7eae3          	bltu	a5,a4,85c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 86c:	ff852583          	lw	a1,-8(a0)
 870:	6390                	ld	a2,0(a5)
 872:	02059713          	slli	a4,a1,0x20
 876:	9301                	srli	a4,a4,0x20
 878:	0712                	slli	a4,a4,0x4
 87a:	9736                	add	a4,a4,a3
 87c:	fae60ae3          	beq	a2,a4,830 <free+0x14>
    bp->s.ptr = p->s.ptr;
 880:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 884:	4790                	lw	a2,8(a5)
 886:	02061713          	slli	a4,a2,0x20
 88a:	9301                	srli	a4,a4,0x20
 88c:	0712                	slli	a4,a4,0x4
 88e:	973e                	add	a4,a4,a5
 890:	fae689e3          	beq	a3,a4,842 <free+0x26>
  } else
    p->s.ptr = bp;
 894:	e394                	sd	a3,0(a5)
  freep = p;
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
}
 89e:	6422                	ld	s0,8(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret

00000000000008a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a4:	7139                	addi	sp,sp,-64
 8a6:	fc06                	sd	ra,56(sp)
 8a8:	f822                	sd	s0,48(sp)
 8aa:	f426                	sd	s1,40(sp)
 8ac:	f04a                	sd	s2,32(sp)
 8ae:	ec4e                	sd	s3,24(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
 8b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	02051493          	slli	s1,a0,0x20
 8bc:	9081                	srli	s1,s1,0x20
 8be:	04bd                	addi	s1,s1,15
 8c0:	8091                	srli	s1,s1,0x4
 8c2:	0014899b          	addiw	s3,s1,1
 8c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c8:	00000517          	auipc	a0,0x0
 8cc:	73853503          	ld	a0,1848(a0) # 1000 <freep>
 8d0:	c515                	beqz	a0,8fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	02977f63          	bgeu	a4,s1,914 <malloc+0x70>
 8da:	8a4e                	mv	s4,s3
 8dc:	0009871b          	sext.w	a4,s3
 8e0:	6685                	lui	a3,0x1
 8e2:	00d77363          	bgeu	a4,a3,8e8 <malloc+0x44>
 8e6:	6a05                	lui	s4,0x1
 8e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f0:	00000917          	auipc	s2,0x0
 8f4:	71090913          	addi	s2,s2,1808 # 1000 <freep>
  if(p == (char*)-1)
 8f8:	5afd                	li	s5,-1
 8fa:	a88d                	j	96c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8fc:	00001797          	auipc	a5,0x1
 900:	91478793          	addi	a5,a5,-1772 # 1210 <base>
 904:	00000717          	auipc	a4,0x0
 908:	6ef73e23          	sd	a5,1788(a4) # 1000 <freep>
 90c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 912:	b7e1                	j	8da <malloc+0x36>
      if(p->s.size == nunits)
 914:	02e48b63          	beq	s1,a4,94a <malloc+0xa6>
        p->s.size -= nunits;
 918:	4137073b          	subw	a4,a4,s3
 91c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91e:	1702                	slli	a4,a4,0x20
 920:	9301                	srli	a4,a4,0x20
 922:	0712                	slli	a4,a4,0x4
 924:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 926:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92a:	00000717          	auipc	a4,0x0
 92e:	6ca73b23          	sd	a0,1750(a4) # 1000 <freep>
      return (void*)(p + 1);
 932:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	74a2                	ld	s1,40(sp)
 93c:	7902                	ld	s2,32(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	6121                	addi	sp,sp,64
 948:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94a:	6398                	ld	a4,0(a5)
 94c:	e118                	sd	a4,0(a0)
 94e:	bff1                	j	92a <malloc+0x86>
  hp->s.size = nu;
 950:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 954:	0541                	addi	a0,a0,16
 956:	00000097          	auipc	ra,0x0
 95a:	ec6080e7          	jalr	-314(ra) # 81c <free>
  return freep;
 95e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 962:	d971                	beqz	a0,936 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 964:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 966:	4798                	lw	a4,8(a5)
 968:	fa9776e3          	bgeu	a4,s1,914 <malloc+0x70>
    if(p == freep)
 96c:	00093703          	ld	a4,0(s2)
 970:	853e                	mv	a0,a5
 972:	fef719e3          	bne	a4,a5,964 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 976:	8552                	mv	a0,s4
 978:	00000097          	auipc	ra,0x0
 97c:	b56080e7          	jalr	-1194(ra) # 4ce <sbrk>
  if(p == (char*)-1)
 980:	fd5518e3          	bne	a0,s5,950 <malloc+0xac>
        return 0;
 984:	4501                	li	a0,0
 986:	bf45                	j	936 <malloc+0x92>
