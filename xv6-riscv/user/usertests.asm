
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	6ac080e7          	jalr	1708(ra) # 66bc <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	69a080e7          	jalr	1690(ra) # 66bc <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1,"");
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00007517          	auipc	a0,0x7
      42:	b9250513          	addi	a0,a0,-1134 # 6bd0 <malloc+0x10e>
      46:	00007097          	auipc	ra,0x7
      4a:	9be080e7          	jalr	-1602(ra) # 6a04 <printf>
      exit(1,"");
      4e:	00008597          	auipc	a1,0x8
      52:	1aa58593          	addi	a1,a1,426 # 81f8 <malloc+0x1736>
      56:	4505                	li	a0,1
      58:	00006097          	auipc	ra,0x6
      5c:	624080e7          	jalr	1572(ra) # 667c <exit>

0000000000000060 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      60:	0000b797          	auipc	a5,0xb
      64:	50878793          	addi	a5,a5,1288 # b568 <uninit>
      68:	0000e697          	auipc	a3,0xe
      6c:	c1068693          	addi	a3,a3,-1008 # dc78 <buf>
    if(uninit[i] != '\0'){
      70:	0007c703          	lbu	a4,0(a5)
      74:	e709                	bnez	a4,7e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      76:	0785                	addi	a5,a5,1
      78:	fed79ce3          	bne	a5,a3,70 <bsstest+0x10>
      7c:	8082                	ret
{
      7e:	1141                	addi	sp,sp,-16
      80:	e406                	sd	ra,8(sp)
      82:	e022                	sd	s0,0(sp)
      84:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      86:	85aa                	mv	a1,a0
      88:	00007517          	auipc	a0,0x7
      8c:	b6850513          	addi	a0,a0,-1176 # 6bf0 <malloc+0x12e>
      90:	00007097          	auipc	ra,0x7
      94:	974080e7          	jalr	-1676(ra) # 6a04 <printf>
      exit(1,"");
      98:	00008597          	auipc	a1,0x8
      9c:	16058593          	addi	a1,a1,352 # 81f8 <malloc+0x1736>
      a0:	4505                	li	a0,1
      a2:	00006097          	auipc	ra,0x6
      a6:	5da080e7          	jalr	1498(ra) # 667c <exit>

00000000000000aa <opentest>:
{
      aa:	1101                	addi	sp,sp,-32
      ac:	ec06                	sd	ra,24(sp)
      ae:	e822                	sd	s0,16(sp)
      b0:	e426                	sd	s1,8(sp)
      b2:	1000                	addi	s0,sp,32
      b4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b6:	4581                	li	a1,0
      b8:	00007517          	auipc	a0,0x7
      bc:	b5050513          	addi	a0,a0,-1200 # 6c08 <malloc+0x146>
      c0:	00006097          	auipc	ra,0x6
      c4:	5fc080e7          	jalr	1532(ra) # 66bc <open>
  if(fd < 0){
      c8:	02054663          	bltz	a0,f4 <opentest+0x4a>
  close(fd);
      cc:	00006097          	auipc	ra,0x6
      d0:	5d8080e7          	jalr	1496(ra) # 66a4 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00007517          	auipc	a0,0x7
      da:	b5250513          	addi	a0,a0,-1198 # 6c28 <malloc+0x166>
      de:	00006097          	auipc	ra,0x6
      e2:	5de080e7          	jalr	1502(ra) # 66bc <open>
  if(fd >= 0){
      e6:	02055963          	bgez	a0,118 <opentest+0x6e>
}
      ea:	60e2                	ld	ra,24(sp)
      ec:	6442                	ld	s0,16(sp)
      ee:	64a2                	ld	s1,8(sp)
      f0:	6105                	addi	sp,sp,32
      f2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f4:	85a6                	mv	a1,s1
      f6:	00007517          	auipc	a0,0x7
      fa:	b1a50513          	addi	a0,a0,-1254 # 6c10 <malloc+0x14e>
      fe:	00007097          	auipc	ra,0x7
     102:	906080e7          	jalr	-1786(ra) # 6a04 <printf>
    exit(1,"");
     106:	00008597          	auipc	a1,0x8
     10a:	0f258593          	addi	a1,a1,242 # 81f8 <malloc+0x1736>
     10e:	4505                	li	a0,1
     110:	00006097          	auipc	ra,0x6
     114:	56c080e7          	jalr	1388(ra) # 667c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     118:	85a6                	mv	a1,s1
     11a:	00007517          	auipc	a0,0x7
     11e:	b1e50513          	addi	a0,a0,-1250 # 6c38 <malloc+0x176>
     122:	00007097          	auipc	ra,0x7
     126:	8e2080e7          	jalr	-1822(ra) # 6a04 <printf>
    exit(1,"");
     12a:	00008597          	auipc	a1,0x8
     12e:	0ce58593          	addi	a1,a1,206 # 81f8 <malloc+0x1736>
     132:	4505                	li	a0,1
     134:	00006097          	auipc	ra,0x6
     138:	548080e7          	jalr	1352(ra) # 667c <exit>

000000000000013c <truncate2>:
{
     13c:	7179                	addi	sp,sp,-48
     13e:	f406                	sd	ra,40(sp)
     140:	f022                	sd	s0,32(sp)
     142:	ec26                	sd	s1,24(sp)
     144:	e84a                	sd	s2,16(sp)
     146:	e44e                	sd	s3,8(sp)
     148:	1800                	addi	s0,sp,48
     14a:	89aa                	mv	s3,a0
  unlink("truncfile");
     14c:	00007517          	auipc	a0,0x7
     150:	b1450513          	addi	a0,a0,-1260 # 6c60 <malloc+0x19e>
     154:	00006097          	auipc	ra,0x6
     158:	578080e7          	jalr	1400(ra) # 66cc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     15c:	60100593          	li	a1,1537
     160:	00007517          	auipc	a0,0x7
     164:	b0050513          	addi	a0,a0,-1280 # 6c60 <malloc+0x19e>
     168:	00006097          	auipc	ra,0x6
     16c:	554080e7          	jalr	1364(ra) # 66bc <open>
     170:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     172:	4611                	li	a2,4
     174:	00007597          	auipc	a1,0x7
     178:	afc58593          	addi	a1,a1,-1284 # 6c70 <malloc+0x1ae>
     17c:	00006097          	auipc	ra,0x6
     180:	520080e7          	jalr	1312(ra) # 669c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     184:	40100593          	li	a1,1025
     188:	00007517          	auipc	a0,0x7
     18c:	ad850513          	addi	a0,a0,-1320 # 6c60 <malloc+0x19e>
     190:	00006097          	auipc	ra,0x6
     194:	52c080e7          	jalr	1324(ra) # 66bc <open>
     198:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     19a:	4605                	li	a2,1
     19c:	00007597          	auipc	a1,0x7
     1a0:	adc58593          	addi	a1,a1,-1316 # 6c78 <malloc+0x1b6>
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	4f6080e7          	jalr	1270(ra) # 669c <write>
  if(n != -1){
     1ae:	57fd                	li	a5,-1
     1b0:	02f51b63          	bne	a0,a5,1e6 <truncate2+0xaa>
  unlink("truncfile");
     1b4:	00007517          	auipc	a0,0x7
     1b8:	aac50513          	addi	a0,a0,-1364 # 6c60 <malloc+0x19e>
     1bc:	00006097          	auipc	ra,0x6
     1c0:	510080e7          	jalr	1296(ra) # 66cc <unlink>
  close(fd1);
     1c4:	8526                	mv	a0,s1
     1c6:	00006097          	auipc	ra,0x6
     1ca:	4de080e7          	jalr	1246(ra) # 66a4 <close>
  close(fd2);
     1ce:	854a                	mv	a0,s2
     1d0:	00006097          	auipc	ra,0x6
     1d4:	4d4080e7          	jalr	1236(ra) # 66a4 <close>
}
     1d8:	70a2                	ld	ra,40(sp)
     1da:	7402                	ld	s0,32(sp)
     1dc:	64e2                	ld	s1,24(sp)
     1de:	6942                	ld	s2,16(sp)
     1e0:	69a2                	ld	s3,8(sp)
     1e2:	6145                	addi	sp,sp,48
     1e4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1e6:	862a                	mv	a2,a0
     1e8:	85ce                	mv	a1,s3
     1ea:	00007517          	auipc	a0,0x7
     1ee:	a9650513          	addi	a0,a0,-1386 # 6c80 <malloc+0x1be>
     1f2:	00007097          	auipc	ra,0x7
     1f6:	812080e7          	jalr	-2030(ra) # 6a04 <printf>
    exit(1,"");
     1fa:	00008597          	auipc	a1,0x8
     1fe:	ffe58593          	addi	a1,a1,-2 # 81f8 <malloc+0x1736>
     202:	4505                	li	a0,1
     204:	00006097          	auipc	ra,0x6
     208:	478080e7          	jalr	1144(ra) # 667c <exit>

000000000000020c <createtest>:
{
     20c:	7179                	addi	sp,sp,-48
     20e:	f406                	sd	ra,40(sp)
     210:	f022                	sd	s0,32(sp)
     212:	ec26                	sd	s1,24(sp)
     214:	e84a                	sd	s2,16(sp)
     216:	1800                	addi	s0,sp,48
  name[0] = 'a';
     218:	06100793          	li	a5,97
     21c:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     220:	fc040d23          	sb	zero,-38(s0)
     224:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     228:	06400913          	li	s2,100
    name[1] = '0' + i;
     22c:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     230:	20200593          	li	a1,514
     234:	fd840513          	addi	a0,s0,-40
     238:	00006097          	auipc	ra,0x6
     23c:	484080e7          	jalr	1156(ra) # 66bc <open>
    close(fd);
     240:	00006097          	auipc	ra,0x6
     244:	464080e7          	jalr	1124(ra) # 66a4 <close>
  for(i = 0; i < N; i++){
     248:	2485                	addiw	s1,s1,1
     24a:	0ff4f493          	andi	s1,s1,255
     24e:	fd249fe3          	bne	s1,s2,22c <createtest+0x20>
  name[0] = 'a';
     252:	06100793          	li	a5,97
     256:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     25a:	fc040d23          	sb	zero,-38(s0)
     25e:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     262:	06400913          	li	s2,100
    name[1] = '0' + i;
     266:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     26a:	fd840513          	addi	a0,s0,-40
     26e:	00006097          	auipc	ra,0x6
     272:	45e080e7          	jalr	1118(ra) # 66cc <unlink>
  for(i = 0; i < N; i++){
     276:	2485                	addiw	s1,s1,1
     278:	0ff4f493          	andi	s1,s1,255
     27c:	ff2495e3          	bne	s1,s2,266 <createtest+0x5a>
}
     280:	70a2                	ld	ra,40(sp)
     282:	7402                	ld	s0,32(sp)
     284:	64e2                	ld	s1,24(sp)
     286:	6942                	ld	s2,16(sp)
     288:	6145                	addi	sp,sp,48
     28a:	8082                	ret

000000000000028c <bigwrite>:
{
     28c:	715d                	addi	sp,sp,-80
     28e:	e486                	sd	ra,72(sp)
     290:	e0a2                	sd	s0,64(sp)
     292:	fc26                	sd	s1,56(sp)
     294:	f84a                	sd	s2,48(sp)
     296:	f44e                	sd	s3,40(sp)
     298:	f052                	sd	s4,32(sp)
     29a:	ec56                	sd	s5,24(sp)
     29c:	e85a                	sd	s6,16(sp)
     29e:	e45e                	sd	s7,8(sp)
     2a0:	0880                	addi	s0,sp,80
     2a2:	8baa                	mv	s7,a0
  unlink("bigwrite");
     2a4:	00007517          	auipc	a0,0x7
     2a8:	a0450513          	addi	a0,a0,-1532 # 6ca8 <malloc+0x1e6>
     2ac:	00006097          	auipc	ra,0x6
     2b0:	420080e7          	jalr	1056(ra) # 66cc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	00007a97          	auipc	s5,0x7
     2bc:	9f0a8a93          	addi	s5,s5,-1552 # 6ca8 <malloc+0x1e6>
      int cc = write(fd, buf, sz);
     2c0:	0000ea17          	auipc	s4,0xe
     2c4:	9b8a0a13          	addi	s4,s4,-1608 # dc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2c8:	6b0d                	lui	s6,0x3
     2ca:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrkarg+0x51>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ce:	20200593          	li	a1,514
     2d2:	8556                	mv	a0,s5
     2d4:	00006097          	auipc	ra,0x6
     2d8:	3e8080e7          	jalr	1000(ra) # 66bc <open>
     2dc:	892a                	mv	s2,a0
    if(fd < 0){
     2de:	04054d63          	bltz	a0,338 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2e2:	8626                	mv	a2,s1
     2e4:	85d2                	mv	a1,s4
     2e6:	00006097          	auipc	ra,0x6
     2ea:	3b6080e7          	jalr	950(ra) # 669c <write>
     2ee:	89aa                	mv	s3,a0
      if(cc != sz){
     2f0:	06a49863          	bne	s1,a0,360 <bigwrite+0xd4>
      int cc = write(fd, buf, sz);
     2f4:	8626                	mv	a2,s1
     2f6:	85d2                	mv	a1,s4
     2f8:	854a                	mv	a0,s2
     2fa:	00006097          	auipc	ra,0x6
     2fe:	3a2080e7          	jalr	930(ra) # 669c <write>
      if(cc != sz){
     302:	04951d63          	bne	a0,s1,35c <bigwrite+0xd0>
    close(fd);
     306:	854a                	mv	a0,s2
     308:	00006097          	auipc	ra,0x6
     30c:	39c080e7          	jalr	924(ra) # 66a4 <close>
    unlink("bigwrite");
     310:	8556                	mv	a0,s5
     312:	00006097          	auipc	ra,0x6
     316:	3ba080e7          	jalr	954(ra) # 66cc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     31a:	1d74849b          	addiw	s1,s1,471
     31e:	fb6498e3          	bne	s1,s6,2ce <bigwrite+0x42>
}
     322:	60a6                	ld	ra,72(sp)
     324:	6406                	ld	s0,64(sp)
     326:	74e2                	ld	s1,56(sp)
     328:	7942                	ld	s2,48(sp)
     32a:	79a2                	ld	s3,40(sp)
     32c:	7a02                	ld	s4,32(sp)
     32e:	6ae2                	ld	s5,24(sp)
     330:	6b42                	ld	s6,16(sp)
     332:	6ba2                	ld	s7,8(sp)
     334:	6161                	addi	sp,sp,80
     336:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     338:	85de                	mv	a1,s7
     33a:	00007517          	auipc	a0,0x7
     33e:	97e50513          	addi	a0,a0,-1666 # 6cb8 <malloc+0x1f6>
     342:	00006097          	auipc	ra,0x6
     346:	6c2080e7          	jalr	1730(ra) # 6a04 <printf>
      exit(1,"");
     34a:	00008597          	auipc	a1,0x8
     34e:	eae58593          	addi	a1,a1,-338 # 81f8 <malloc+0x1736>
     352:	4505                	li	a0,1
     354:	00006097          	auipc	ra,0x6
     358:	328080e7          	jalr	808(ra) # 667c <exit>
     35c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     35e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     360:	86ce                	mv	a3,s3
     362:	8626                	mv	a2,s1
     364:	85de                	mv	a1,s7
     366:	00007517          	auipc	a0,0x7
     36a:	97250513          	addi	a0,a0,-1678 # 6cd8 <malloc+0x216>
     36e:	00006097          	auipc	ra,0x6
     372:	696080e7          	jalr	1686(ra) # 6a04 <printf>
        exit(1,"");
     376:	00008597          	auipc	a1,0x8
     37a:	e8258593          	addi	a1,a1,-382 # 81f8 <malloc+0x1736>
     37e:	4505                	li	a0,1
     380:	00006097          	auipc	ra,0x6
     384:	2fc080e7          	jalr	764(ra) # 667c <exit>

0000000000000388 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     388:	7179                	addi	sp,sp,-48
     38a:	f406                	sd	ra,40(sp)
     38c:	f022                	sd	s0,32(sp)
     38e:	ec26                	sd	s1,24(sp)
     390:	e84a                	sd	s2,16(sp)
     392:	e44e                	sd	s3,8(sp)
     394:	e052                	sd	s4,0(sp)
     396:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     398:	00007517          	auipc	a0,0x7
     39c:	95850513          	addi	a0,a0,-1704 # 6cf0 <malloc+0x22e>
     3a0:	00006097          	auipc	ra,0x6
     3a4:	32c080e7          	jalr	812(ra) # 66cc <unlink>
     3a8:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ac:	00007997          	auipc	s3,0x7
     3b0:	94498993          	addi	s3,s3,-1724 # 6cf0 <malloc+0x22e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1,"");
    }
    write(fd, (char*)0xffffffffffL, 1);
     3b4:	5a7d                	li	s4,-1
     3b6:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	854e                	mv	a0,s3
     3c0:	00006097          	auipc	ra,0x6
     3c4:	2fc080e7          	jalr	764(ra) # 66bc <open>
     3c8:	84aa                	mv	s1,a0
    if(fd < 0){
     3ca:	06054f63          	bltz	a0,448 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3ce:	4605                	li	a2,1
     3d0:	85d2                	mv	a1,s4
     3d2:	00006097          	auipc	ra,0x6
     3d6:	2ca080e7          	jalr	714(ra) # 669c <write>
    close(fd);
     3da:	8526                	mv	a0,s1
     3dc:	00006097          	auipc	ra,0x6
     3e0:	2c8080e7          	jalr	712(ra) # 66a4 <close>
    unlink("junk");
     3e4:	854e                	mv	a0,s3
     3e6:	00006097          	auipc	ra,0x6
     3ea:	2e6080e7          	jalr	742(ra) # 66cc <unlink>
  for(int i = 0; i < assumed_free; i++){
     3ee:	397d                	addiw	s2,s2,-1
     3f0:	fc0915e3          	bnez	s2,3ba <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3f4:	20100593          	li	a1,513
     3f8:	00007517          	auipc	a0,0x7
     3fc:	8f850513          	addi	a0,a0,-1800 # 6cf0 <malloc+0x22e>
     400:	00006097          	auipc	ra,0x6
     404:	2bc080e7          	jalr	700(ra) # 66bc <open>
     408:	84aa                	mv	s1,a0
  if(fd < 0){
     40a:	06054063          	bltz	a0,46a <badwrite+0xe2>
    printf("open junk failed\n");
    exit(1,"");
  }
  if(write(fd, "x", 1) != 1){
     40e:	4605                	li	a2,1
     410:	00007597          	auipc	a1,0x7
     414:	86858593          	addi	a1,a1,-1944 # 6c78 <malloc+0x1b6>
     418:	00006097          	auipc	ra,0x6
     41c:	284080e7          	jalr	644(ra) # 669c <write>
     420:	4785                	li	a5,1
     422:	06f50563          	beq	a0,a5,48c <badwrite+0x104>
    printf("write failed\n");
     426:	00007517          	auipc	a0,0x7
     42a:	8ea50513          	addi	a0,a0,-1814 # 6d10 <malloc+0x24e>
     42e:	00006097          	auipc	ra,0x6
     432:	5d6080e7          	jalr	1494(ra) # 6a04 <printf>
    exit(1,"");
     436:	00008597          	auipc	a1,0x8
     43a:	dc258593          	addi	a1,a1,-574 # 81f8 <malloc+0x1736>
     43e:	4505                	li	a0,1
     440:	00006097          	auipc	ra,0x6
     444:	23c080e7          	jalr	572(ra) # 667c <exit>
      printf("open junk failed\n");
     448:	00007517          	auipc	a0,0x7
     44c:	8b050513          	addi	a0,a0,-1872 # 6cf8 <malloc+0x236>
     450:	00006097          	auipc	ra,0x6
     454:	5b4080e7          	jalr	1460(ra) # 6a04 <printf>
      exit(1,"");
     458:	00008597          	auipc	a1,0x8
     45c:	da058593          	addi	a1,a1,-608 # 81f8 <malloc+0x1736>
     460:	4505                	li	a0,1
     462:	00006097          	auipc	ra,0x6
     466:	21a080e7          	jalr	538(ra) # 667c <exit>
    printf("open junk failed\n");
     46a:	00007517          	auipc	a0,0x7
     46e:	88e50513          	addi	a0,a0,-1906 # 6cf8 <malloc+0x236>
     472:	00006097          	auipc	ra,0x6
     476:	592080e7          	jalr	1426(ra) # 6a04 <printf>
    exit(1,"");
     47a:	00008597          	auipc	a1,0x8
     47e:	d7e58593          	addi	a1,a1,-642 # 81f8 <malloc+0x1736>
     482:	4505                	li	a0,1
     484:	00006097          	auipc	ra,0x6
     488:	1f8080e7          	jalr	504(ra) # 667c <exit>
  }
  close(fd);
     48c:	8526                	mv	a0,s1
     48e:	00006097          	auipc	ra,0x6
     492:	216080e7          	jalr	534(ra) # 66a4 <close>
  unlink("junk");
     496:	00007517          	auipc	a0,0x7
     49a:	85a50513          	addi	a0,a0,-1958 # 6cf0 <malloc+0x22e>
     49e:	00006097          	auipc	ra,0x6
     4a2:	22e080e7          	jalr	558(ra) # 66cc <unlink>

  exit(0,"");
     4a6:	00008597          	auipc	a1,0x8
     4aa:	d5258593          	addi	a1,a1,-686 # 81f8 <malloc+0x1736>
     4ae:	4501                	li	a0,0
     4b0:	00006097          	auipc	ra,0x6
     4b4:	1cc080e7          	jalr	460(ra) # 667c <exit>

00000000000004b8 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     4b8:	715d                	addi	sp,sp,-80
     4ba:	e486                	sd	ra,72(sp)
     4bc:	e0a2                	sd	s0,64(sp)
     4be:	fc26                	sd	s1,56(sp)
     4c0:	f84a                	sd	s2,48(sp)
     4c2:	f44e                	sd	s3,40(sp)
     4c4:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     4c6:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     4c8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4cc:	40000993          	li	s3,1024
    name[0] = 'z';
     4d0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4d4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4d8:	41f4d79b          	sraiw	a5,s1,0x1f
     4dc:	01b7d71b          	srliw	a4,a5,0x1b
     4e0:	009707bb          	addw	a5,a4,s1
     4e4:	4057d69b          	sraiw	a3,a5,0x5
     4e8:	0306869b          	addiw	a3,a3,48
     4ec:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4f0:	8bfd                	andi	a5,a5,31
     4f2:	9f99                	subw	a5,a5,a4
     4f4:	0307879b          	addiw	a5,a5,48
     4f8:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4fc:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     500:	fb040513          	addi	a0,s0,-80
     504:	00006097          	auipc	ra,0x6
     508:	1c8080e7          	jalr	456(ra) # 66cc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     50c:	60200593          	li	a1,1538
     510:	fb040513          	addi	a0,s0,-80
     514:	00006097          	auipc	ra,0x6
     518:	1a8080e7          	jalr	424(ra) # 66bc <open>
    if(fd < 0){
     51c:	00054963          	bltz	a0,52e <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     520:	00006097          	auipc	ra,0x6
     524:	184080e7          	jalr	388(ra) # 66a4 <close>
  for(int i = 0; i < nzz; i++){
     528:	2485                	addiw	s1,s1,1
     52a:	fb3493e3          	bne	s1,s3,4d0 <outofinodes+0x18>
     52e:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     530:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     534:	40000993          	li	s3,1024
    name[0] = 'z';
     538:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     53c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     540:	41f4d79b          	sraiw	a5,s1,0x1f
     544:	01b7d71b          	srliw	a4,a5,0x1b
     548:	009707bb          	addw	a5,a4,s1
     54c:	4057d69b          	sraiw	a3,a5,0x5
     550:	0306869b          	addiw	a3,a3,48
     554:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     558:	8bfd                	andi	a5,a5,31
     55a:	9f99                	subw	a5,a5,a4
     55c:	0307879b          	addiw	a5,a5,48
     560:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     564:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     568:	fb040513          	addi	a0,s0,-80
     56c:	00006097          	auipc	ra,0x6
     570:	160080e7          	jalr	352(ra) # 66cc <unlink>
  for(int i = 0; i < nzz; i++){
     574:	2485                	addiw	s1,s1,1
     576:	fd3491e3          	bne	s1,s3,538 <outofinodes+0x80>
  }
}
     57a:	60a6                	ld	ra,72(sp)
     57c:	6406                	ld	s0,64(sp)
     57e:	74e2                	ld	s1,56(sp)
     580:	7942                	ld	s2,48(sp)
     582:	79a2                	ld	s3,40(sp)
     584:	6161                	addi	sp,sp,80
     586:	8082                	ret

0000000000000588 <copyin>:
{
     588:	715d                	addi	sp,sp,-80
     58a:	e486                	sd	ra,72(sp)
     58c:	e0a2                	sd	s0,64(sp)
     58e:	fc26                	sd	s1,56(sp)
     590:	f84a                	sd	s2,48(sp)
     592:	f44e                	sd	s3,40(sp)
     594:	f052                	sd	s4,32(sp)
     596:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     598:	4785                	li	a5,1
     59a:	07fe                	slli	a5,a5,0x1f
     59c:	fcf43023          	sd	a5,-64(s0)
     5a0:	57fd                	li	a5,-1
     5a2:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     5a6:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5aa:	00006a17          	auipc	s4,0x6
     5ae:	776a0a13          	addi	s4,s4,1910 # 6d20 <malloc+0x25e>
    uint64 addr = addrs[ai];
     5b2:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5b6:	20100593          	li	a1,513
     5ba:	8552                	mv	a0,s4
     5bc:	00006097          	auipc	ra,0x6
     5c0:	100080e7          	jalr	256(ra) # 66bc <open>
     5c4:	84aa                	mv	s1,a0
    if(fd < 0){
     5c6:	08054863          	bltz	a0,656 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     5ca:	6609                	lui	a2,0x2
     5cc:	85ce                	mv	a1,s3
     5ce:	00006097          	auipc	ra,0x6
     5d2:	0ce080e7          	jalr	206(ra) # 669c <write>
    if(n >= 0){
     5d6:	0a055163          	bgez	a0,678 <copyin+0xf0>
    close(fd);
     5da:	8526                	mv	a0,s1
     5dc:	00006097          	auipc	ra,0x6
     5e0:	0c8080e7          	jalr	200(ra) # 66a4 <close>
    unlink("copyin1");
     5e4:	8552                	mv	a0,s4
     5e6:	00006097          	auipc	ra,0x6
     5ea:	0e6080e7          	jalr	230(ra) # 66cc <unlink>
    n = write(1, (char*)addr, 8192);
     5ee:	6609                	lui	a2,0x2
     5f0:	85ce                	mv	a1,s3
     5f2:	4505                	li	a0,1
     5f4:	00006097          	auipc	ra,0x6
     5f8:	0a8080e7          	jalr	168(ra) # 669c <write>
    if(n > 0){
     5fc:	0aa04163          	bgtz	a0,69e <copyin+0x116>
    if(pipe(fds) < 0){
     600:	fb840513          	addi	a0,s0,-72
     604:	00006097          	auipc	ra,0x6
     608:	088080e7          	jalr	136(ra) # 668c <pipe>
     60c:	0a054c63          	bltz	a0,6c4 <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     610:	6609                	lui	a2,0x2
     612:	85ce                	mv	a1,s3
     614:	fbc42503          	lw	a0,-68(s0)
     618:	00006097          	auipc	ra,0x6
     61c:	084080e7          	jalr	132(ra) # 669c <write>
    if(n > 0){
     620:	0ca04363          	bgtz	a0,6e6 <copyin+0x15e>
    close(fds[0]);
     624:	fb842503          	lw	a0,-72(s0)
     628:	00006097          	auipc	ra,0x6
     62c:	07c080e7          	jalr	124(ra) # 66a4 <close>
    close(fds[1]);
     630:	fbc42503          	lw	a0,-68(s0)
     634:	00006097          	auipc	ra,0x6
     638:	070080e7          	jalr	112(ra) # 66a4 <close>
  for(int ai = 0; ai < 2; ai++){
     63c:	0921                	addi	s2,s2,8
     63e:	fd040793          	addi	a5,s0,-48
     642:	f6f918e3          	bne	s2,a5,5b2 <copyin+0x2a>
}
     646:	60a6                	ld	ra,72(sp)
     648:	6406                	ld	s0,64(sp)
     64a:	74e2                	ld	s1,56(sp)
     64c:	7942                	ld	s2,48(sp)
     64e:	79a2                	ld	s3,40(sp)
     650:	7a02                	ld	s4,32(sp)
     652:	6161                	addi	sp,sp,80
     654:	8082                	ret
      printf("open(copyin1) failed\n");
     656:	00006517          	auipc	a0,0x6
     65a:	6d250513          	addi	a0,a0,1746 # 6d28 <malloc+0x266>
     65e:	00006097          	auipc	ra,0x6
     662:	3a6080e7          	jalr	934(ra) # 6a04 <printf>
      exit(1,"");
     666:	00008597          	auipc	a1,0x8
     66a:	b9258593          	addi	a1,a1,-1134 # 81f8 <malloc+0x1736>
     66e:	4505                	li	a0,1
     670:	00006097          	auipc	ra,0x6
     674:	00c080e7          	jalr	12(ra) # 667c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     678:	862a                	mv	a2,a0
     67a:	85ce                	mv	a1,s3
     67c:	00006517          	auipc	a0,0x6
     680:	6c450513          	addi	a0,a0,1732 # 6d40 <malloc+0x27e>
     684:	00006097          	auipc	ra,0x6
     688:	380080e7          	jalr	896(ra) # 6a04 <printf>
      exit(1,"");
     68c:	00008597          	auipc	a1,0x8
     690:	b6c58593          	addi	a1,a1,-1172 # 81f8 <malloc+0x1736>
     694:	4505                	li	a0,1
     696:	00006097          	auipc	ra,0x6
     69a:	fe6080e7          	jalr	-26(ra) # 667c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     69e:	862a                	mv	a2,a0
     6a0:	85ce                	mv	a1,s3
     6a2:	00006517          	auipc	a0,0x6
     6a6:	6ce50513          	addi	a0,a0,1742 # 6d70 <malloc+0x2ae>
     6aa:	00006097          	auipc	ra,0x6
     6ae:	35a080e7          	jalr	858(ra) # 6a04 <printf>
      exit(1,"");
     6b2:	00008597          	auipc	a1,0x8
     6b6:	b4658593          	addi	a1,a1,-1210 # 81f8 <malloc+0x1736>
     6ba:	4505                	li	a0,1
     6bc:	00006097          	auipc	ra,0x6
     6c0:	fc0080e7          	jalr	-64(ra) # 667c <exit>
      printf("pipe() failed\n");
     6c4:	00006517          	auipc	a0,0x6
     6c8:	6dc50513          	addi	a0,a0,1756 # 6da0 <malloc+0x2de>
     6cc:	00006097          	auipc	ra,0x6
     6d0:	338080e7          	jalr	824(ra) # 6a04 <printf>
      exit(1,"");
     6d4:	00008597          	auipc	a1,0x8
     6d8:	b2458593          	addi	a1,a1,-1244 # 81f8 <malloc+0x1736>
     6dc:	4505                	li	a0,1
     6de:	00006097          	auipc	ra,0x6
     6e2:	f9e080e7          	jalr	-98(ra) # 667c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00006517          	auipc	a0,0x6
     6ee:	6c650513          	addi	a0,a0,1734 # 6db0 <malloc+0x2ee>
     6f2:	00006097          	auipc	ra,0x6
     6f6:	312080e7          	jalr	786(ra) # 6a04 <printf>
      exit(1,"");
     6fa:	00008597          	auipc	a1,0x8
     6fe:	afe58593          	addi	a1,a1,-1282 # 81f8 <malloc+0x1736>
     702:	4505                	li	a0,1
     704:	00006097          	auipc	ra,0x6
     708:	f78080e7          	jalr	-136(ra) # 667c <exit>

000000000000070c <copyout>:
{
     70c:	711d                	addi	sp,sp,-96
     70e:	ec86                	sd	ra,88(sp)
     710:	e8a2                	sd	s0,80(sp)
     712:	e4a6                	sd	s1,72(sp)
     714:	e0ca                	sd	s2,64(sp)
     716:	fc4e                	sd	s3,56(sp)
     718:	f852                	sd	s4,48(sp)
     71a:	f456                	sd	s5,40(sp)
     71c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     71e:	4785                	li	a5,1
     720:	07fe                	slli	a5,a5,0x1f
     722:	faf43823          	sd	a5,-80(s0)
     726:	57fd                	li	a5,-1
     728:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     72c:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     730:	00006a17          	auipc	s4,0x6
     734:	6b0a0a13          	addi	s4,s4,1712 # 6de0 <malloc+0x31e>
    n = write(fds[1], "x", 1);
     738:	00006a97          	auipc	s5,0x6
     73c:	540a8a93          	addi	s5,s5,1344 # 6c78 <malloc+0x1b6>
    uint64 addr = addrs[ai];
     740:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     744:	4581                	li	a1,0
     746:	8552                	mv	a0,s4
     748:	00006097          	auipc	ra,0x6
     74c:	f74080e7          	jalr	-140(ra) # 66bc <open>
     750:	84aa                	mv	s1,a0
    if(fd < 0){
     752:	08054663          	bltz	a0,7de <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     756:	6609                	lui	a2,0x2
     758:	85ce                	mv	a1,s3
     75a:	00006097          	auipc	ra,0x6
     75e:	f3a080e7          	jalr	-198(ra) # 6694 <read>
    if(n > 0){
     762:	08a04f63          	bgtz	a0,800 <copyout+0xf4>
    close(fd);
     766:	8526                	mv	a0,s1
     768:	00006097          	auipc	ra,0x6
     76c:	f3c080e7          	jalr	-196(ra) # 66a4 <close>
    if(pipe(fds) < 0){
     770:	fa840513          	addi	a0,s0,-88
     774:	00006097          	auipc	ra,0x6
     778:	f18080e7          	jalr	-232(ra) # 668c <pipe>
     77c:	0a054563          	bltz	a0,826 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     780:	4605                	li	a2,1
     782:	85d6                	mv	a1,s5
     784:	fac42503          	lw	a0,-84(s0)
     788:	00006097          	auipc	ra,0x6
     78c:	f14080e7          	jalr	-236(ra) # 669c <write>
    if(n != 1){
     790:	4785                	li	a5,1
     792:	0af51b63          	bne	a0,a5,848 <copyout+0x13c>
    n = read(fds[0], (void*)addr, 8192);
     796:	6609                	lui	a2,0x2
     798:	85ce                	mv	a1,s3
     79a:	fa842503          	lw	a0,-88(s0)
     79e:	00006097          	auipc	ra,0x6
     7a2:	ef6080e7          	jalr	-266(ra) # 6694 <read>
    if(n > 0){
     7a6:	0ca04263          	bgtz	a0,86a <copyout+0x15e>
    close(fds[0]);
     7aa:	fa842503          	lw	a0,-88(s0)
     7ae:	00006097          	auipc	ra,0x6
     7b2:	ef6080e7          	jalr	-266(ra) # 66a4 <close>
    close(fds[1]);
     7b6:	fac42503          	lw	a0,-84(s0)
     7ba:	00006097          	auipc	ra,0x6
     7be:	eea080e7          	jalr	-278(ra) # 66a4 <close>
  for(int ai = 0; ai < 2; ai++){
     7c2:	0921                	addi	s2,s2,8
     7c4:	fc040793          	addi	a5,s0,-64
     7c8:	f6f91ce3          	bne	s2,a5,740 <copyout+0x34>
}
     7cc:	60e6                	ld	ra,88(sp)
     7ce:	6446                	ld	s0,80(sp)
     7d0:	64a6                	ld	s1,72(sp)
     7d2:	6906                	ld	s2,64(sp)
     7d4:	79e2                	ld	s3,56(sp)
     7d6:	7a42                	ld	s4,48(sp)
     7d8:	7aa2                	ld	s5,40(sp)
     7da:	6125                	addi	sp,sp,96
     7dc:	8082                	ret
      printf("open(README) failed\n");
     7de:	00006517          	auipc	a0,0x6
     7e2:	60a50513          	addi	a0,a0,1546 # 6de8 <malloc+0x326>
     7e6:	00006097          	auipc	ra,0x6
     7ea:	21e080e7          	jalr	542(ra) # 6a04 <printf>
      exit(1,"");
     7ee:	00008597          	auipc	a1,0x8
     7f2:	a0a58593          	addi	a1,a1,-1526 # 81f8 <malloc+0x1736>
     7f6:	4505                	li	a0,1
     7f8:	00006097          	auipc	ra,0x6
     7fc:	e84080e7          	jalr	-380(ra) # 667c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     800:	862a                	mv	a2,a0
     802:	85ce                	mv	a1,s3
     804:	00006517          	auipc	a0,0x6
     808:	5fc50513          	addi	a0,a0,1532 # 6e00 <malloc+0x33e>
     80c:	00006097          	auipc	ra,0x6
     810:	1f8080e7          	jalr	504(ra) # 6a04 <printf>
      exit(1,"");
     814:	00008597          	auipc	a1,0x8
     818:	9e458593          	addi	a1,a1,-1564 # 81f8 <malloc+0x1736>
     81c:	4505                	li	a0,1
     81e:	00006097          	auipc	ra,0x6
     822:	e5e080e7          	jalr	-418(ra) # 667c <exit>
      printf("pipe() failed\n");
     826:	00006517          	auipc	a0,0x6
     82a:	57a50513          	addi	a0,a0,1402 # 6da0 <malloc+0x2de>
     82e:	00006097          	auipc	ra,0x6
     832:	1d6080e7          	jalr	470(ra) # 6a04 <printf>
      exit(1,"");
     836:	00008597          	auipc	a1,0x8
     83a:	9c258593          	addi	a1,a1,-1598 # 81f8 <malloc+0x1736>
     83e:	4505                	li	a0,1
     840:	00006097          	auipc	ra,0x6
     844:	e3c080e7          	jalr	-452(ra) # 667c <exit>
      printf("pipe write failed\n");
     848:	00006517          	auipc	a0,0x6
     84c:	5e850513          	addi	a0,a0,1512 # 6e30 <malloc+0x36e>
     850:	00006097          	auipc	ra,0x6
     854:	1b4080e7          	jalr	436(ra) # 6a04 <printf>
      exit(1,"");
     858:	00008597          	auipc	a1,0x8
     85c:	9a058593          	addi	a1,a1,-1632 # 81f8 <malloc+0x1736>
     860:	4505                	li	a0,1
     862:	00006097          	auipc	ra,0x6
     866:	e1a080e7          	jalr	-486(ra) # 667c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     86a:	862a                	mv	a2,a0
     86c:	85ce                	mv	a1,s3
     86e:	00006517          	auipc	a0,0x6
     872:	5da50513          	addi	a0,a0,1498 # 6e48 <malloc+0x386>
     876:	00006097          	auipc	ra,0x6
     87a:	18e080e7          	jalr	398(ra) # 6a04 <printf>
      exit(1,"");
     87e:	00008597          	auipc	a1,0x8
     882:	97a58593          	addi	a1,a1,-1670 # 81f8 <malloc+0x1736>
     886:	4505                	li	a0,1
     888:	00006097          	auipc	ra,0x6
     88c:	df4080e7          	jalr	-524(ra) # 667c <exit>

0000000000000890 <truncate1>:
{
     890:	711d                	addi	sp,sp,-96
     892:	ec86                	sd	ra,88(sp)
     894:	e8a2                	sd	s0,80(sp)
     896:	e4a6                	sd	s1,72(sp)
     898:	e0ca                	sd	s2,64(sp)
     89a:	fc4e                	sd	s3,56(sp)
     89c:	f852                	sd	s4,48(sp)
     89e:	f456                	sd	s5,40(sp)
     8a0:	1080                	addi	s0,sp,96
     8a2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     8a4:	00006517          	auipc	a0,0x6
     8a8:	3bc50513          	addi	a0,a0,956 # 6c60 <malloc+0x19e>
     8ac:	00006097          	auipc	ra,0x6
     8b0:	e20080e7          	jalr	-480(ra) # 66cc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     8b4:	60100593          	li	a1,1537
     8b8:	00006517          	auipc	a0,0x6
     8bc:	3a850513          	addi	a0,a0,936 # 6c60 <malloc+0x19e>
     8c0:	00006097          	auipc	ra,0x6
     8c4:	dfc080e7          	jalr	-516(ra) # 66bc <open>
     8c8:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     8ca:	4611                	li	a2,4
     8cc:	00006597          	auipc	a1,0x6
     8d0:	3a458593          	addi	a1,a1,932 # 6c70 <malloc+0x1ae>
     8d4:	00006097          	auipc	ra,0x6
     8d8:	dc8080e7          	jalr	-568(ra) # 669c <write>
  close(fd1);
     8dc:	8526                	mv	a0,s1
     8de:	00006097          	auipc	ra,0x6
     8e2:	dc6080e7          	jalr	-570(ra) # 66a4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     8e6:	4581                	li	a1,0
     8e8:	00006517          	auipc	a0,0x6
     8ec:	37850513          	addi	a0,a0,888 # 6c60 <malloc+0x19e>
     8f0:	00006097          	auipc	ra,0x6
     8f4:	dcc080e7          	jalr	-564(ra) # 66bc <open>
     8f8:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	addi	a1,s0,-96
     902:	00006097          	auipc	ra,0x6
     906:	d92080e7          	jalr	-622(ra) # 6694 <read>
  if(n != 4){
     90a:	4791                	li	a5,4
     90c:	0cf51e63          	bne	a0,a5,9e8 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     910:	40100593          	li	a1,1025
     914:	00006517          	auipc	a0,0x6
     918:	34c50513          	addi	a0,a0,844 # 6c60 <malloc+0x19e>
     91c:	00006097          	auipc	ra,0x6
     920:	da0080e7          	jalr	-608(ra) # 66bc <open>
     924:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     926:	4581                	li	a1,0
     928:	00006517          	auipc	a0,0x6
     92c:	33850513          	addi	a0,a0,824 # 6c60 <malloc+0x19e>
     930:	00006097          	auipc	ra,0x6
     934:	d8c080e7          	jalr	-628(ra) # 66bc <open>
     938:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     93a:	02000613          	li	a2,32
     93e:	fa040593          	addi	a1,s0,-96
     942:	00006097          	auipc	ra,0x6
     946:	d52080e7          	jalr	-686(ra) # 6694 <read>
     94a:	8a2a                	mv	s4,a0
  if(n != 0){
     94c:	e169                	bnez	a0,a0e <truncate1+0x17e>
  n = read(fd2, buf, sizeof(buf));
     94e:	02000613          	li	a2,32
     952:	fa040593          	addi	a1,s0,-96
     956:	8526                	mv	a0,s1
     958:	00006097          	auipc	ra,0x6
     95c:	d3c080e7          	jalr	-708(ra) # 6694 <read>
     960:	8a2a                	mv	s4,a0
  if(n != 0){
     962:	e175                	bnez	a0,a46 <truncate1+0x1b6>
  write(fd1, "abcdef", 6);
     964:	4619                	li	a2,6
     966:	00006597          	auipc	a1,0x6
     96a:	57258593          	addi	a1,a1,1394 # 6ed8 <malloc+0x416>
     96e:	854e                	mv	a0,s3
     970:	00006097          	auipc	ra,0x6
     974:	d2c080e7          	jalr	-724(ra) # 669c <write>
  n = read(fd3, buf, sizeof(buf));
     978:	02000613          	li	a2,32
     97c:	fa040593          	addi	a1,s0,-96
     980:	854a                	mv	a0,s2
     982:	00006097          	auipc	ra,0x6
     986:	d12080e7          	jalr	-750(ra) # 6694 <read>
  if(n != 6){
     98a:	4799                	li	a5,6
     98c:	0ef51963          	bne	a0,a5,a7e <truncate1+0x1ee>
  n = read(fd2, buf, sizeof(buf));
     990:	02000613          	li	a2,32
     994:	fa040593          	addi	a1,s0,-96
     998:	8526                	mv	a0,s1
     99a:	00006097          	auipc	ra,0x6
     99e:	cfa080e7          	jalr	-774(ra) # 6694 <read>
  if(n != 2){
     9a2:	4789                	li	a5,2
     9a4:	10f51063          	bne	a0,a5,aa4 <truncate1+0x214>
  unlink("truncfile");
     9a8:	00006517          	auipc	a0,0x6
     9ac:	2b850513          	addi	a0,a0,696 # 6c60 <malloc+0x19e>
     9b0:	00006097          	auipc	ra,0x6
     9b4:	d1c080e7          	jalr	-740(ra) # 66cc <unlink>
  close(fd1);
     9b8:	854e                	mv	a0,s3
     9ba:	00006097          	auipc	ra,0x6
     9be:	cea080e7          	jalr	-790(ra) # 66a4 <close>
  close(fd2);
     9c2:	8526                	mv	a0,s1
     9c4:	00006097          	auipc	ra,0x6
     9c8:	ce0080e7          	jalr	-800(ra) # 66a4 <close>
  close(fd3);
     9cc:	854a                	mv	a0,s2
     9ce:	00006097          	auipc	ra,0x6
     9d2:	cd6080e7          	jalr	-810(ra) # 66a4 <close>
}
     9d6:	60e6                	ld	ra,88(sp)
     9d8:	6446                	ld	s0,80(sp)
     9da:	64a6                	ld	s1,72(sp)
     9dc:	6906                	ld	s2,64(sp)
     9de:	79e2                	ld	s3,56(sp)
     9e0:	7a42                	ld	s4,48(sp)
     9e2:	7aa2                	ld	s5,40(sp)
     9e4:	6125                	addi	sp,sp,96
     9e6:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     9e8:	862a                	mv	a2,a0
     9ea:	85d6                	mv	a1,s5
     9ec:	00006517          	auipc	a0,0x6
     9f0:	48c50513          	addi	a0,a0,1164 # 6e78 <malloc+0x3b6>
     9f4:	00006097          	auipc	ra,0x6
     9f8:	010080e7          	jalr	16(ra) # 6a04 <printf>
    exit(1,"");
     9fc:	00007597          	auipc	a1,0x7
     a00:	7fc58593          	addi	a1,a1,2044 # 81f8 <malloc+0x1736>
     a04:	4505                	li	a0,1
     a06:	00006097          	auipc	ra,0x6
     a0a:	c76080e7          	jalr	-906(ra) # 667c <exit>
    printf("aaa fd3=%d\n", fd3);
     a0e:	85ca                	mv	a1,s2
     a10:	00006517          	auipc	a0,0x6
     a14:	48850513          	addi	a0,a0,1160 # 6e98 <malloc+0x3d6>
     a18:	00006097          	auipc	ra,0x6
     a1c:	fec080e7          	jalr	-20(ra) # 6a04 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a20:	8652                	mv	a2,s4
     a22:	85d6                	mv	a1,s5
     a24:	00006517          	auipc	a0,0x6
     a28:	48450513          	addi	a0,a0,1156 # 6ea8 <malloc+0x3e6>
     a2c:	00006097          	auipc	ra,0x6
     a30:	fd8080e7          	jalr	-40(ra) # 6a04 <printf>
    exit(1,"");
     a34:	00007597          	auipc	a1,0x7
     a38:	7c458593          	addi	a1,a1,1988 # 81f8 <malloc+0x1736>
     a3c:	4505                	li	a0,1
     a3e:	00006097          	auipc	ra,0x6
     a42:	c3e080e7          	jalr	-962(ra) # 667c <exit>
    printf("bbb fd2=%d\n", fd2);
     a46:	85a6                	mv	a1,s1
     a48:	00006517          	auipc	a0,0x6
     a4c:	48050513          	addi	a0,a0,1152 # 6ec8 <malloc+0x406>
     a50:	00006097          	auipc	ra,0x6
     a54:	fb4080e7          	jalr	-76(ra) # 6a04 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a58:	8652                	mv	a2,s4
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	44c50513          	addi	a0,a0,1100 # 6ea8 <malloc+0x3e6>
     a64:	00006097          	auipc	ra,0x6
     a68:	fa0080e7          	jalr	-96(ra) # 6a04 <printf>
    exit(1,"");
     a6c:	00007597          	auipc	a1,0x7
     a70:	78c58593          	addi	a1,a1,1932 # 81f8 <malloc+0x1736>
     a74:	4505                	li	a0,1
     a76:	00006097          	auipc	ra,0x6
     a7a:	c06080e7          	jalr	-1018(ra) # 667c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a7e:	862a                	mv	a2,a0
     a80:	85d6                	mv	a1,s5
     a82:	00006517          	auipc	a0,0x6
     a86:	45e50513          	addi	a0,a0,1118 # 6ee0 <malloc+0x41e>
     a8a:	00006097          	auipc	ra,0x6
     a8e:	f7a080e7          	jalr	-134(ra) # 6a04 <printf>
    exit(1,"");
     a92:	00007597          	auipc	a1,0x7
     a96:	76658593          	addi	a1,a1,1894 # 81f8 <malloc+0x1736>
     a9a:	4505                	li	a0,1
     a9c:	00006097          	auipc	ra,0x6
     aa0:	be0080e7          	jalr	-1056(ra) # 667c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     aa4:	862a                	mv	a2,a0
     aa6:	85d6                	mv	a1,s5
     aa8:	00006517          	auipc	a0,0x6
     aac:	45850513          	addi	a0,a0,1112 # 6f00 <malloc+0x43e>
     ab0:	00006097          	auipc	ra,0x6
     ab4:	f54080e7          	jalr	-172(ra) # 6a04 <printf>
    exit(1,"");
     ab8:	00007597          	auipc	a1,0x7
     abc:	74058593          	addi	a1,a1,1856 # 81f8 <malloc+0x1736>
     ac0:	4505                	li	a0,1
     ac2:	00006097          	auipc	ra,0x6
     ac6:	bba080e7          	jalr	-1094(ra) # 667c <exit>

0000000000000aca <writetest>:
{
     aca:	7139                	addi	sp,sp,-64
     acc:	fc06                	sd	ra,56(sp)
     ace:	f822                	sd	s0,48(sp)
     ad0:	f426                	sd	s1,40(sp)
     ad2:	f04a                	sd	s2,32(sp)
     ad4:	ec4e                	sd	s3,24(sp)
     ad6:	e852                	sd	s4,16(sp)
     ad8:	e456                	sd	s5,8(sp)
     ada:	e05a                	sd	s6,0(sp)
     adc:	0080                	addi	s0,sp,64
     ade:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     ae0:	20200593          	li	a1,514
     ae4:	00006517          	auipc	a0,0x6
     ae8:	43c50513          	addi	a0,a0,1084 # 6f20 <malloc+0x45e>
     aec:	00006097          	auipc	ra,0x6
     af0:	bd0080e7          	jalr	-1072(ra) # 66bc <open>
  if(fd < 0){
     af4:	0a054d63          	bltz	a0,bae <writetest+0xe4>
     af8:	892a                	mv	s2,a0
     afa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     afc:	00006997          	auipc	s3,0x6
     b00:	44c98993          	addi	s3,s3,1100 # 6f48 <malloc+0x486>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b04:	00006a97          	auipc	s5,0x6
     b08:	47ca8a93          	addi	s5,s5,1148 # 6f80 <malloc+0x4be>
  for(i = 0; i < N; i++){
     b0c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b10:	4629                	li	a2,10
     b12:	85ce                	mv	a1,s3
     b14:	854a                	mv	a0,s2
     b16:	00006097          	auipc	ra,0x6
     b1a:	b86080e7          	jalr	-1146(ra) # 669c <write>
     b1e:	47a9                	li	a5,10
     b20:	0af51963          	bne	a0,a5,bd2 <writetest+0x108>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b24:	4629                	li	a2,10
     b26:	85d6                	mv	a1,s5
     b28:	854a                	mv	a0,s2
     b2a:	00006097          	auipc	ra,0x6
     b2e:	b72080e7          	jalr	-1166(ra) # 669c <write>
     b32:	47a9                	li	a5,10
     b34:	0cf51263          	bne	a0,a5,bf8 <writetest+0x12e>
  for(i = 0; i < N; i++){
     b38:	2485                	addiw	s1,s1,1
     b3a:	fd449be3          	bne	s1,s4,b10 <writetest+0x46>
  close(fd);
     b3e:	854a                	mv	a0,s2
     b40:	00006097          	auipc	ra,0x6
     b44:	b64080e7          	jalr	-1180(ra) # 66a4 <close>
  fd = open("small", O_RDONLY);
     b48:	4581                	li	a1,0
     b4a:	00006517          	auipc	a0,0x6
     b4e:	3d650513          	addi	a0,a0,982 # 6f20 <malloc+0x45e>
     b52:	00006097          	auipc	ra,0x6
     b56:	b6a080e7          	jalr	-1174(ra) # 66bc <open>
     b5a:	84aa                	mv	s1,a0
  if(fd < 0){
     b5c:	0c054163          	bltz	a0,c1e <writetest+0x154>
  i = read(fd, buf, N*SZ*2);
     b60:	7d000613          	li	a2,2000
     b64:	0000d597          	auipc	a1,0xd
     b68:	11458593          	addi	a1,a1,276 # dc78 <buf>
     b6c:	00006097          	auipc	ra,0x6
     b70:	b28080e7          	jalr	-1240(ra) # 6694 <read>
  if(i != N*SZ*2){
     b74:	7d000793          	li	a5,2000
     b78:	0cf51563          	bne	a0,a5,c42 <writetest+0x178>
  close(fd);
     b7c:	8526                	mv	a0,s1
     b7e:	00006097          	auipc	ra,0x6
     b82:	b26080e7          	jalr	-1242(ra) # 66a4 <close>
  if(unlink("small") < 0){
     b86:	00006517          	auipc	a0,0x6
     b8a:	39a50513          	addi	a0,a0,922 # 6f20 <malloc+0x45e>
     b8e:	00006097          	auipc	ra,0x6
     b92:	b3e080e7          	jalr	-1218(ra) # 66cc <unlink>
     b96:	0c054863          	bltz	a0,c66 <writetest+0x19c>
}
     b9a:	70e2                	ld	ra,56(sp)
     b9c:	7442                	ld	s0,48(sp)
     b9e:	74a2                	ld	s1,40(sp)
     ba0:	7902                	ld	s2,32(sp)
     ba2:	69e2                	ld	s3,24(sp)
     ba4:	6a42                	ld	s4,16(sp)
     ba6:	6aa2                	ld	s5,8(sp)
     ba8:	6b02                	ld	s6,0(sp)
     baa:	6121                	addi	sp,sp,64
     bac:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     bae:	85da                	mv	a1,s6
     bb0:	00006517          	auipc	a0,0x6
     bb4:	37850513          	addi	a0,a0,888 # 6f28 <malloc+0x466>
     bb8:	00006097          	auipc	ra,0x6
     bbc:	e4c080e7          	jalr	-436(ra) # 6a04 <printf>
    exit(1,"");
     bc0:	00007597          	auipc	a1,0x7
     bc4:	63858593          	addi	a1,a1,1592 # 81f8 <malloc+0x1736>
     bc8:	4505                	li	a0,1
     bca:	00006097          	auipc	ra,0x6
     bce:	ab2080e7          	jalr	-1358(ra) # 667c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     bd2:	8626                	mv	a2,s1
     bd4:	85da                	mv	a1,s6
     bd6:	00006517          	auipc	a0,0x6
     bda:	38250513          	addi	a0,a0,898 # 6f58 <malloc+0x496>
     bde:	00006097          	auipc	ra,0x6
     be2:	e26080e7          	jalr	-474(ra) # 6a04 <printf>
      exit(1,"");
     be6:	00007597          	auipc	a1,0x7
     bea:	61258593          	addi	a1,a1,1554 # 81f8 <malloc+0x1736>
     bee:	4505                	li	a0,1
     bf0:	00006097          	auipc	ra,0x6
     bf4:	a8c080e7          	jalr	-1396(ra) # 667c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     bf8:	8626                	mv	a2,s1
     bfa:	85da                	mv	a1,s6
     bfc:	00006517          	auipc	a0,0x6
     c00:	39450513          	addi	a0,a0,916 # 6f90 <malloc+0x4ce>
     c04:	00006097          	auipc	ra,0x6
     c08:	e00080e7          	jalr	-512(ra) # 6a04 <printf>
      exit(1,"");
     c0c:	00007597          	auipc	a1,0x7
     c10:	5ec58593          	addi	a1,a1,1516 # 81f8 <malloc+0x1736>
     c14:	4505                	li	a0,1
     c16:	00006097          	auipc	ra,0x6
     c1a:	a66080e7          	jalr	-1434(ra) # 667c <exit>
    printf("%s: error: open small failed!\n", s);
     c1e:	85da                	mv	a1,s6
     c20:	00006517          	auipc	a0,0x6
     c24:	39850513          	addi	a0,a0,920 # 6fb8 <malloc+0x4f6>
     c28:	00006097          	auipc	ra,0x6
     c2c:	ddc080e7          	jalr	-548(ra) # 6a04 <printf>
    exit(1,"");
     c30:	00007597          	auipc	a1,0x7
     c34:	5c858593          	addi	a1,a1,1480 # 81f8 <malloc+0x1736>
     c38:	4505                	li	a0,1
     c3a:	00006097          	auipc	ra,0x6
     c3e:	a42080e7          	jalr	-1470(ra) # 667c <exit>
    printf("%s: read failed\n", s);
     c42:	85da                	mv	a1,s6
     c44:	00006517          	auipc	a0,0x6
     c48:	39450513          	addi	a0,a0,916 # 6fd8 <malloc+0x516>
     c4c:	00006097          	auipc	ra,0x6
     c50:	db8080e7          	jalr	-584(ra) # 6a04 <printf>
    exit(1,"");
     c54:	00007597          	auipc	a1,0x7
     c58:	5a458593          	addi	a1,a1,1444 # 81f8 <malloc+0x1736>
     c5c:	4505                	li	a0,1
     c5e:	00006097          	auipc	ra,0x6
     c62:	a1e080e7          	jalr	-1506(ra) # 667c <exit>
    printf("%s: unlink small failed\n", s);
     c66:	85da                	mv	a1,s6
     c68:	00006517          	auipc	a0,0x6
     c6c:	38850513          	addi	a0,a0,904 # 6ff0 <malloc+0x52e>
     c70:	00006097          	auipc	ra,0x6
     c74:	d94080e7          	jalr	-620(ra) # 6a04 <printf>
    exit(1,"");
     c78:	00007597          	auipc	a1,0x7
     c7c:	58058593          	addi	a1,a1,1408 # 81f8 <malloc+0x1736>
     c80:	4505                	li	a0,1
     c82:	00006097          	auipc	ra,0x6
     c86:	9fa080e7          	jalr	-1542(ra) # 667c <exit>

0000000000000c8a <writebig>:
{
     c8a:	7139                	addi	sp,sp,-64
     c8c:	fc06                	sd	ra,56(sp)
     c8e:	f822                	sd	s0,48(sp)
     c90:	f426                	sd	s1,40(sp)
     c92:	f04a                	sd	s2,32(sp)
     c94:	ec4e                	sd	s3,24(sp)
     c96:	e852                	sd	s4,16(sp)
     c98:	e456                	sd	s5,8(sp)
     c9a:	0080                	addi	s0,sp,64
     c9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     c9e:	20200593          	li	a1,514
     ca2:	00006517          	auipc	a0,0x6
     ca6:	36e50513          	addi	a0,a0,878 # 7010 <malloc+0x54e>
     caa:	00006097          	auipc	ra,0x6
     cae:	a12080e7          	jalr	-1518(ra) # 66bc <open>
     cb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     cb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     cb6:	0000d917          	auipc	s2,0xd
     cba:	fc290913          	addi	s2,s2,-62 # dc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     cbe:	10c00a13          	li	s4,268
  if(fd < 0){
     cc2:	06054c63          	bltz	a0,d3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     cc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     cca:	40000613          	li	a2,1024
     cce:	85ca                	mv	a1,s2
     cd0:	854e                	mv	a0,s3
     cd2:	00006097          	auipc	ra,0x6
     cd6:	9ca080e7          	jalr	-1590(ra) # 669c <write>
     cda:	40000793          	li	a5,1024
     cde:	08f51063          	bne	a0,a5,d5e <writebig+0xd4>
  for(i = 0; i < MAXFILE; i++){
     ce2:	2485                	addiw	s1,s1,1
     ce4:	ff4491e3          	bne	s1,s4,cc6 <writebig+0x3c>
  close(fd);
     ce8:	854e                	mv	a0,s3
     cea:	00006097          	auipc	ra,0x6
     cee:	9ba080e7          	jalr	-1606(ra) # 66a4 <close>
  fd = open("big", O_RDONLY);
     cf2:	4581                	li	a1,0
     cf4:	00006517          	auipc	a0,0x6
     cf8:	31c50513          	addi	a0,a0,796 # 7010 <malloc+0x54e>
     cfc:	00006097          	auipc	ra,0x6
     d00:	9c0080e7          	jalr	-1600(ra) # 66bc <open>
     d04:	89aa                	mv	s3,a0
  n = 0;
     d06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     d08:	0000d917          	auipc	s2,0xd
     d0c:	f7090913          	addi	s2,s2,-144 # dc78 <buf>
  if(fd < 0){
     d10:	06054a63          	bltz	a0,d84 <writebig+0xfa>
    i = read(fd, buf, BSIZE);
     d14:	40000613          	li	a2,1024
     d18:	85ca                	mv	a1,s2
     d1a:	854e                	mv	a0,s3
     d1c:	00006097          	auipc	ra,0x6
     d20:	978080e7          	jalr	-1672(ra) # 6694 <read>
    if(i == 0){
     d24:	c151                	beqz	a0,da8 <writebig+0x11e>
    } else if(i != BSIZE){
     d26:	40000793          	li	a5,1024
     d2a:	0cf51f63          	bne	a0,a5,e08 <writebig+0x17e>
    if(((int*)buf)[0] != n){
     d2e:	00092683          	lw	a3,0(s2)
     d32:	0e969e63          	bne	a3,s1,e2e <writebig+0x1a4>
    n++;
     d36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     d38:	bff1                	j	d14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     d3a:	85d6                	mv	a1,s5
     d3c:	00006517          	auipc	a0,0x6
     d40:	2dc50513          	addi	a0,a0,732 # 7018 <malloc+0x556>
     d44:	00006097          	auipc	ra,0x6
     d48:	cc0080e7          	jalr	-832(ra) # 6a04 <printf>
    exit(1,"");
     d4c:	00007597          	auipc	a1,0x7
     d50:	4ac58593          	addi	a1,a1,1196 # 81f8 <malloc+0x1736>
     d54:	4505                	li	a0,1
     d56:	00006097          	auipc	ra,0x6
     d5a:	926080e7          	jalr	-1754(ra) # 667c <exit>
      printf("%s: error: write big file failed\n", s, i);
     d5e:	8626                	mv	a2,s1
     d60:	85d6                	mv	a1,s5
     d62:	00006517          	auipc	a0,0x6
     d66:	2d650513          	addi	a0,a0,726 # 7038 <malloc+0x576>
     d6a:	00006097          	auipc	ra,0x6
     d6e:	c9a080e7          	jalr	-870(ra) # 6a04 <printf>
      exit(1,"");
     d72:	00007597          	auipc	a1,0x7
     d76:	48658593          	addi	a1,a1,1158 # 81f8 <malloc+0x1736>
     d7a:	4505                	li	a0,1
     d7c:	00006097          	auipc	ra,0x6
     d80:	900080e7          	jalr	-1792(ra) # 667c <exit>
    printf("%s: error: open big failed!\n", s);
     d84:	85d6                	mv	a1,s5
     d86:	00006517          	auipc	a0,0x6
     d8a:	2da50513          	addi	a0,a0,730 # 7060 <malloc+0x59e>
     d8e:	00006097          	auipc	ra,0x6
     d92:	c76080e7          	jalr	-906(ra) # 6a04 <printf>
    exit(1,"");
     d96:	00007597          	auipc	a1,0x7
     d9a:	46258593          	addi	a1,a1,1122 # 81f8 <malloc+0x1736>
     d9e:	4505                	li	a0,1
     da0:	00006097          	auipc	ra,0x6
     da4:	8dc080e7          	jalr	-1828(ra) # 667c <exit>
      if(n == MAXFILE - 1){
     da8:	10b00793          	li	a5,267
     dac:	02f48a63          	beq	s1,a5,de0 <writebig+0x156>
  close(fd);
     db0:	854e                	mv	a0,s3
     db2:	00006097          	auipc	ra,0x6
     db6:	8f2080e7          	jalr	-1806(ra) # 66a4 <close>
  if(unlink("big") < 0){
     dba:	00006517          	auipc	a0,0x6
     dbe:	25650513          	addi	a0,a0,598 # 7010 <malloc+0x54e>
     dc2:	00006097          	auipc	ra,0x6
     dc6:	90a080e7          	jalr	-1782(ra) # 66cc <unlink>
     dca:	08054563          	bltz	a0,e54 <writebig+0x1ca>
}
     dce:	70e2                	ld	ra,56(sp)
     dd0:	7442                	ld	s0,48(sp)
     dd2:	74a2                	ld	s1,40(sp)
     dd4:	7902                	ld	s2,32(sp)
     dd6:	69e2                	ld	s3,24(sp)
     dd8:	6a42                	ld	s4,16(sp)
     dda:	6aa2                	ld	s5,8(sp)
     ddc:	6121                	addi	sp,sp,64
     dde:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     de0:	10b00613          	li	a2,267
     de4:	85d6                	mv	a1,s5
     de6:	00006517          	auipc	a0,0x6
     dea:	29a50513          	addi	a0,a0,666 # 7080 <malloc+0x5be>
     dee:	00006097          	auipc	ra,0x6
     df2:	c16080e7          	jalr	-1002(ra) # 6a04 <printf>
        exit(1,"");
     df6:	00007597          	auipc	a1,0x7
     dfa:	40258593          	addi	a1,a1,1026 # 81f8 <malloc+0x1736>
     dfe:	4505                	li	a0,1
     e00:	00006097          	auipc	ra,0x6
     e04:	87c080e7          	jalr	-1924(ra) # 667c <exit>
      printf("%s: read failed %d\n", s, i);
     e08:	862a                	mv	a2,a0
     e0a:	85d6                	mv	a1,s5
     e0c:	00006517          	auipc	a0,0x6
     e10:	29c50513          	addi	a0,a0,668 # 70a8 <malloc+0x5e6>
     e14:	00006097          	auipc	ra,0x6
     e18:	bf0080e7          	jalr	-1040(ra) # 6a04 <printf>
      exit(1,"");
     e1c:	00007597          	auipc	a1,0x7
     e20:	3dc58593          	addi	a1,a1,988 # 81f8 <malloc+0x1736>
     e24:	4505                	li	a0,1
     e26:	00006097          	auipc	ra,0x6
     e2a:	856080e7          	jalr	-1962(ra) # 667c <exit>
      printf("%s: read content of block %d is %d\n", s,
     e2e:	8626                	mv	a2,s1
     e30:	85d6                	mv	a1,s5
     e32:	00006517          	auipc	a0,0x6
     e36:	28e50513          	addi	a0,a0,654 # 70c0 <malloc+0x5fe>
     e3a:	00006097          	auipc	ra,0x6
     e3e:	bca080e7          	jalr	-1078(ra) # 6a04 <printf>
      exit(1,"");
     e42:	00007597          	auipc	a1,0x7
     e46:	3b658593          	addi	a1,a1,950 # 81f8 <malloc+0x1736>
     e4a:	4505                	li	a0,1
     e4c:	00006097          	auipc	ra,0x6
     e50:	830080e7          	jalr	-2000(ra) # 667c <exit>
    printf("%s: unlink big failed\n", s);
     e54:	85d6                	mv	a1,s5
     e56:	00006517          	auipc	a0,0x6
     e5a:	29250513          	addi	a0,a0,658 # 70e8 <malloc+0x626>
     e5e:	00006097          	auipc	ra,0x6
     e62:	ba6080e7          	jalr	-1114(ra) # 6a04 <printf>
    exit(1,"");
     e66:	00007597          	auipc	a1,0x7
     e6a:	39258593          	addi	a1,a1,914 # 81f8 <malloc+0x1736>
     e6e:	4505                	li	a0,1
     e70:	00006097          	auipc	ra,0x6
     e74:	80c080e7          	jalr	-2036(ra) # 667c <exit>

0000000000000e78 <unlinkread>:
{
     e78:	7179                	addi	sp,sp,-48
     e7a:	f406                	sd	ra,40(sp)
     e7c:	f022                	sd	s0,32(sp)
     e7e:	ec26                	sd	s1,24(sp)
     e80:	e84a                	sd	s2,16(sp)
     e82:	e44e                	sd	s3,8(sp)
     e84:	1800                	addi	s0,sp,48
     e86:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     e88:	20200593          	li	a1,514
     e8c:	00006517          	auipc	a0,0x6
     e90:	27450513          	addi	a0,a0,628 # 7100 <malloc+0x63e>
     e94:	00006097          	auipc	ra,0x6
     e98:	828080e7          	jalr	-2008(ra) # 66bc <open>
  if(fd < 0){
     e9c:	0e054563          	bltz	a0,f86 <unlinkread+0x10e>
     ea0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ea2:	4615                	li	a2,5
     ea4:	00006597          	auipc	a1,0x6
     ea8:	28c58593          	addi	a1,a1,652 # 7130 <malloc+0x66e>
     eac:	00005097          	auipc	ra,0x5
     eb0:	7f0080e7          	jalr	2032(ra) # 669c <write>
  close(fd);
     eb4:	8526                	mv	a0,s1
     eb6:	00005097          	auipc	ra,0x5
     eba:	7ee080e7          	jalr	2030(ra) # 66a4 <close>
  fd = open("unlinkread", O_RDWR);
     ebe:	4589                	li	a1,2
     ec0:	00006517          	auipc	a0,0x6
     ec4:	24050513          	addi	a0,a0,576 # 7100 <malloc+0x63e>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	7f4080e7          	jalr	2036(ra) # 66bc <open>
     ed0:	84aa                	mv	s1,a0
  if(fd < 0){
     ed2:	0c054c63          	bltz	a0,faa <unlinkread+0x132>
  if(unlink("unlinkread") != 0){
     ed6:	00006517          	auipc	a0,0x6
     eda:	22a50513          	addi	a0,a0,554 # 7100 <malloc+0x63e>
     ede:	00005097          	auipc	ra,0x5
     ee2:	7ee080e7          	jalr	2030(ra) # 66cc <unlink>
     ee6:	e565                	bnez	a0,fce <unlinkread+0x156>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     ee8:	20200593          	li	a1,514
     eec:	00006517          	auipc	a0,0x6
     ef0:	21450513          	addi	a0,a0,532 # 7100 <malloc+0x63e>
     ef4:	00005097          	auipc	ra,0x5
     ef8:	7c8080e7          	jalr	1992(ra) # 66bc <open>
     efc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     efe:	460d                	li	a2,3
     f00:	00006597          	auipc	a1,0x6
     f04:	27858593          	addi	a1,a1,632 # 7178 <malloc+0x6b6>
     f08:	00005097          	auipc	ra,0x5
     f0c:	794080e7          	jalr	1940(ra) # 669c <write>
  close(fd1);
     f10:	854a                	mv	a0,s2
     f12:	00005097          	auipc	ra,0x5
     f16:	792080e7          	jalr	1938(ra) # 66a4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     f1a:	660d                	lui	a2,0x3
     f1c:	0000d597          	auipc	a1,0xd
     f20:	d5c58593          	addi	a1,a1,-676 # dc78 <buf>
     f24:	8526                	mv	a0,s1
     f26:	00005097          	auipc	ra,0x5
     f2a:	76e080e7          	jalr	1902(ra) # 6694 <read>
     f2e:	4795                	li	a5,5
     f30:	0cf51163          	bne	a0,a5,ff2 <unlinkread+0x17a>
  if(buf[0] != 'h'){
     f34:	0000d717          	auipc	a4,0xd
     f38:	d4474703          	lbu	a4,-700(a4) # dc78 <buf>
     f3c:	06800793          	li	a5,104
     f40:	0cf71b63          	bne	a4,a5,1016 <unlinkread+0x19e>
  if(write(fd, buf, 10) != 10){
     f44:	4629                	li	a2,10
     f46:	0000d597          	auipc	a1,0xd
     f4a:	d3258593          	addi	a1,a1,-718 # dc78 <buf>
     f4e:	8526                	mv	a0,s1
     f50:	00005097          	auipc	ra,0x5
     f54:	74c080e7          	jalr	1868(ra) # 669c <write>
     f58:	47a9                	li	a5,10
     f5a:	0ef51063          	bne	a0,a5,103a <unlinkread+0x1c2>
  close(fd);
     f5e:	8526                	mv	a0,s1
     f60:	00005097          	auipc	ra,0x5
     f64:	744080e7          	jalr	1860(ra) # 66a4 <close>
  unlink("unlinkread");
     f68:	00006517          	auipc	a0,0x6
     f6c:	19850513          	addi	a0,a0,408 # 7100 <malloc+0x63e>
     f70:	00005097          	auipc	ra,0x5
     f74:	75c080e7          	jalr	1884(ra) # 66cc <unlink>
}
     f78:	70a2                	ld	ra,40(sp)
     f7a:	7402                	ld	s0,32(sp)
     f7c:	64e2                	ld	s1,24(sp)
     f7e:	6942                	ld	s2,16(sp)
     f80:	69a2                	ld	s3,8(sp)
     f82:	6145                	addi	sp,sp,48
     f84:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     f86:	85ce                	mv	a1,s3
     f88:	00006517          	auipc	a0,0x6
     f8c:	18850513          	addi	a0,a0,392 # 7110 <malloc+0x64e>
     f90:	00006097          	auipc	ra,0x6
     f94:	a74080e7          	jalr	-1420(ra) # 6a04 <printf>
    exit(1,"");
     f98:	00007597          	auipc	a1,0x7
     f9c:	26058593          	addi	a1,a1,608 # 81f8 <malloc+0x1736>
     fa0:	4505                	li	a0,1
     fa2:	00005097          	auipc	ra,0x5
     fa6:	6da080e7          	jalr	1754(ra) # 667c <exit>
    printf("%s: open unlinkread failed\n", s);
     faa:	85ce                	mv	a1,s3
     fac:	00006517          	auipc	a0,0x6
     fb0:	18c50513          	addi	a0,a0,396 # 7138 <malloc+0x676>
     fb4:	00006097          	auipc	ra,0x6
     fb8:	a50080e7          	jalr	-1456(ra) # 6a04 <printf>
    exit(1,"");
     fbc:	00007597          	auipc	a1,0x7
     fc0:	23c58593          	addi	a1,a1,572 # 81f8 <malloc+0x1736>
     fc4:	4505                	li	a0,1
     fc6:	00005097          	auipc	ra,0x5
     fca:	6b6080e7          	jalr	1718(ra) # 667c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     fce:	85ce                	mv	a1,s3
     fd0:	00006517          	auipc	a0,0x6
     fd4:	18850513          	addi	a0,a0,392 # 7158 <malloc+0x696>
     fd8:	00006097          	auipc	ra,0x6
     fdc:	a2c080e7          	jalr	-1492(ra) # 6a04 <printf>
    exit(1,"");
     fe0:	00007597          	auipc	a1,0x7
     fe4:	21858593          	addi	a1,a1,536 # 81f8 <malloc+0x1736>
     fe8:	4505                	li	a0,1
     fea:	00005097          	auipc	ra,0x5
     fee:	692080e7          	jalr	1682(ra) # 667c <exit>
    printf("%s: unlinkread read failed", s);
     ff2:	85ce                	mv	a1,s3
     ff4:	00006517          	auipc	a0,0x6
     ff8:	18c50513          	addi	a0,a0,396 # 7180 <malloc+0x6be>
     ffc:	00006097          	auipc	ra,0x6
    1000:	a08080e7          	jalr	-1528(ra) # 6a04 <printf>
    exit(1,"");
    1004:	00007597          	auipc	a1,0x7
    1008:	1f458593          	addi	a1,a1,500 # 81f8 <malloc+0x1736>
    100c:	4505                	li	a0,1
    100e:	00005097          	auipc	ra,0x5
    1012:	66e080e7          	jalr	1646(ra) # 667c <exit>
    printf("%s: unlinkread wrong data\n", s);
    1016:	85ce                	mv	a1,s3
    1018:	00006517          	auipc	a0,0x6
    101c:	18850513          	addi	a0,a0,392 # 71a0 <malloc+0x6de>
    1020:	00006097          	auipc	ra,0x6
    1024:	9e4080e7          	jalr	-1564(ra) # 6a04 <printf>
    exit(1,"");
    1028:	00007597          	auipc	a1,0x7
    102c:	1d058593          	addi	a1,a1,464 # 81f8 <malloc+0x1736>
    1030:	4505                	li	a0,1
    1032:	00005097          	auipc	ra,0x5
    1036:	64a080e7          	jalr	1610(ra) # 667c <exit>
    printf("%s: unlinkread write failed\n", s);
    103a:	85ce                	mv	a1,s3
    103c:	00006517          	auipc	a0,0x6
    1040:	18450513          	addi	a0,a0,388 # 71c0 <malloc+0x6fe>
    1044:	00006097          	auipc	ra,0x6
    1048:	9c0080e7          	jalr	-1600(ra) # 6a04 <printf>
    exit(1,"");
    104c:	00007597          	auipc	a1,0x7
    1050:	1ac58593          	addi	a1,a1,428 # 81f8 <malloc+0x1736>
    1054:	4505                	li	a0,1
    1056:	00005097          	auipc	ra,0x5
    105a:	626080e7          	jalr	1574(ra) # 667c <exit>

000000000000105e <linktest>:
{
    105e:	1101                	addi	sp,sp,-32
    1060:	ec06                	sd	ra,24(sp)
    1062:	e822                	sd	s0,16(sp)
    1064:	e426                	sd	s1,8(sp)
    1066:	e04a                	sd	s2,0(sp)
    1068:	1000                	addi	s0,sp,32
    106a:	892a                	mv	s2,a0
  unlink("lf1");
    106c:	00006517          	auipc	a0,0x6
    1070:	17450513          	addi	a0,a0,372 # 71e0 <malloc+0x71e>
    1074:	00005097          	auipc	ra,0x5
    1078:	658080e7          	jalr	1624(ra) # 66cc <unlink>
  unlink("lf2");
    107c:	00006517          	auipc	a0,0x6
    1080:	16c50513          	addi	a0,a0,364 # 71e8 <malloc+0x726>
    1084:	00005097          	auipc	ra,0x5
    1088:	648080e7          	jalr	1608(ra) # 66cc <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    108c:	20200593          	li	a1,514
    1090:	00006517          	auipc	a0,0x6
    1094:	15050513          	addi	a0,a0,336 # 71e0 <malloc+0x71e>
    1098:	00005097          	auipc	ra,0x5
    109c:	624080e7          	jalr	1572(ra) # 66bc <open>
  if(fd < 0){
    10a0:	10054763          	bltz	a0,11ae <linktest+0x150>
    10a4:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    10a6:	4615                	li	a2,5
    10a8:	00006597          	auipc	a1,0x6
    10ac:	08858593          	addi	a1,a1,136 # 7130 <malloc+0x66e>
    10b0:	00005097          	auipc	ra,0x5
    10b4:	5ec080e7          	jalr	1516(ra) # 669c <write>
    10b8:	4795                	li	a5,5
    10ba:	10f51c63          	bne	a0,a5,11d2 <linktest+0x174>
  close(fd);
    10be:	8526                	mv	a0,s1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	5e4080e7          	jalr	1508(ra) # 66a4 <close>
  if(link("lf1", "lf2") < 0){
    10c8:	00006597          	auipc	a1,0x6
    10cc:	12058593          	addi	a1,a1,288 # 71e8 <malloc+0x726>
    10d0:	00006517          	auipc	a0,0x6
    10d4:	11050513          	addi	a0,a0,272 # 71e0 <malloc+0x71e>
    10d8:	00005097          	auipc	ra,0x5
    10dc:	604080e7          	jalr	1540(ra) # 66dc <link>
    10e0:	10054b63          	bltz	a0,11f6 <linktest+0x198>
  unlink("lf1");
    10e4:	00006517          	auipc	a0,0x6
    10e8:	0fc50513          	addi	a0,a0,252 # 71e0 <malloc+0x71e>
    10ec:	00005097          	auipc	ra,0x5
    10f0:	5e0080e7          	jalr	1504(ra) # 66cc <unlink>
  if(open("lf1", 0) >= 0){
    10f4:	4581                	li	a1,0
    10f6:	00006517          	auipc	a0,0x6
    10fa:	0ea50513          	addi	a0,a0,234 # 71e0 <malloc+0x71e>
    10fe:	00005097          	auipc	ra,0x5
    1102:	5be080e7          	jalr	1470(ra) # 66bc <open>
    1106:	10055a63          	bgez	a0,121a <linktest+0x1bc>
  fd = open("lf2", 0);
    110a:	4581                	li	a1,0
    110c:	00006517          	auipc	a0,0x6
    1110:	0dc50513          	addi	a0,a0,220 # 71e8 <malloc+0x726>
    1114:	00005097          	auipc	ra,0x5
    1118:	5a8080e7          	jalr	1448(ra) # 66bc <open>
    111c:	84aa                	mv	s1,a0
  if(fd < 0){
    111e:	12054063          	bltz	a0,123e <linktest+0x1e0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1122:	660d                	lui	a2,0x3
    1124:	0000d597          	auipc	a1,0xd
    1128:	b5458593          	addi	a1,a1,-1196 # dc78 <buf>
    112c:	00005097          	auipc	ra,0x5
    1130:	568080e7          	jalr	1384(ra) # 6694 <read>
    1134:	4795                	li	a5,5
    1136:	12f51663          	bne	a0,a5,1262 <linktest+0x204>
  close(fd);
    113a:	8526                	mv	a0,s1
    113c:	00005097          	auipc	ra,0x5
    1140:	568080e7          	jalr	1384(ra) # 66a4 <close>
  if(link("lf2", "lf2") >= 0){
    1144:	00006597          	auipc	a1,0x6
    1148:	0a458593          	addi	a1,a1,164 # 71e8 <malloc+0x726>
    114c:	852e                	mv	a0,a1
    114e:	00005097          	auipc	ra,0x5
    1152:	58e080e7          	jalr	1422(ra) # 66dc <link>
    1156:	12055863          	bgez	a0,1286 <linktest+0x228>
  unlink("lf2");
    115a:	00006517          	auipc	a0,0x6
    115e:	08e50513          	addi	a0,a0,142 # 71e8 <malloc+0x726>
    1162:	00005097          	auipc	ra,0x5
    1166:	56a080e7          	jalr	1386(ra) # 66cc <unlink>
  if(link("lf2", "lf1") >= 0){
    116a:	00006597          	auipc	a1,0x6
    116e:	07658593          	addi	a1,a1,118 # 71e0 <malloc+0x71e>
    1172:	00006517          	auipc	a0,0x6
    1176:	07650513          	addi	a0,a0,118 # 71e8 <malloc+0x726>
    117a:	00005097          	auipc	ra,0x5
    117e:	562080e7          	jalr	1378(ra) # 66dc <link>
    1182:	12055463          	bgez	a0,12aa <linktest+0x24c>
  if(link(".", "lf1") >= 0){
    1186:	00006597          	auipc	a1,0x6
    118a:	05a58593          	addi	a1,a1,90 # 71e0 <malloc+0x71e>
    118e:	00006517          	auipc	a0,0x6
    1192:	16250513          	addi	a0,a0,354 # 72f0 <malloc+0x82e>
    1196:	00005097          	auipc	ra,0x5
    119a:	546080e7          	jalr	1350(ra) # 66dc <link>
    119e:	12055863          	bgez	a0,12ce <linktest+0x270>
}
    11a2:	60e2                	ld	ra,24(sp)
    11a4:	6442                	ld	s0,16(sp)
    11a6:	64a2                	ld	s1,8(sp)
    11a8:	6902                	ld	s2,0(sp)
    11aa:	6105                	addi	sp,sp,32
    11ac:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    11ae:	85ca                	mv	a1,s2
    11b0:	00006517          	auipc	a0,0x6
    11b4:	04050513          	addi	a0,a0,64 # 71f0 <malloc+0x72e>
    11b8:	00006097          	auipc	ra,0x6
    11bc:	84c080e7          	jalr	-1972(ra) # 6a04 <printf>
    exit(1,"");
    11c0:	00007597          	auipc	a1,0x7
    11c4:	03858593          	addi	a1,a1,56 # 81f8 <malloc+0x1736>
    11c8:	4505                	li	a0,1
    11ca:	00005097          	auipc	ra,0x5
    11ce:	4b2080e7          	jalr	1202(ra) # 667c <exit>
    printf("%s: write lf1 failed\n", s);
    11d2:	85ca                	mv	a1,s2
    11d4:	00006517          	auipc	a0,0x6
    11d8:	03450513          	addi	a0,a0,52 # 7208 <malloc+0x746>
    11dc:	00006097          	auipc	ra,0x6
    11e0:	828080e7          	jalr	-2008(ra) # 6a04 <printf>
    exit(1,"");
    11e4:	00007597          	auipc	a1,0x7
    11e8:	01458593          	addi	a1,a1,20 # 81f8 <malloc+0x1736>
    11ec:	4505                	li	a0,1
    11ee:	00005097          	auipc	ra,0x5
    11f2:	48e080e7          	jalr	1166(ra) # 667c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    11f6:	85ca                	mv	a1,s2
    11f8:	00006517          	auipc	a0,0x6
    11fc:	02850513          	addi	a0,a0,40 # 7220 <malloc+0x75e>
    1200:	00006097          	auipc	ra,0x6
    1204:	804080e7          	jalr	-2044(ra) # 6a04 <printf>
    exit(1,"");
    1208:	00007597          	auipc	a1,0x7
    120c:	ff058593          	addi	a1,a1,-16 # 81f8 <malloc+0x1736>
    1210:	4505                	li	a0,1
    1212:	00005097          	auipc	ra,0x5
    1216:	46a080e7          	jalr	1130(ra) # 667c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    121a:	85ca                	mv	a1,s2
    121c:	00006517          	auipc	a0,0x6
    1220:	02450513          	addi	a0,a0,36 # 7240 <malloc+0x77e>
    1224:	00005097          	auipc	ra,0x5
    1228:	7e0080e7          	jalr	2016(ra) # 6a04 <printf>
    exit(1,"");
    122c:	00007597          	auipc	a1,0x7
    1230:	fcc58593          	addi	a1,a1,-52 # 81f8 <malloc+0x1736>
    1234:	4505                	li	a0,1
    1236:	00005097          	auipc	ra,0x5
    123a:	446080e7          	jalr	1094(ra) # 667c <exit>
    printf("%s: open lf2 failed\n", s);
    123e:	85ca                	mv	a1,s2
    1240:	00006517          	auipc	a0,0x6
    1244:	03050513          	addi	a0,a0,48 # 7270 <malloc+0x7ae>
    1248:	00005097          	auipc	ra,0x5
    124c:	7bc080e7          	jalr	1980(ra) # 6a04 <printf>
    exit(1,"");
    1250:	00007597          	auipc	a1,0x7
    1254:	fa858593          	addi	a1,a1,-88 # 81f8 <malloc+0x1736>
    1258:	4505                	li	a0,1
    125a:	00005097          	auipc	ra,0x5
    125e:	422080e7          	jalr	1058(ra) # 667c <exit>
    printf("%s: read lf2 failed\n", s);
    1262:	85ca                	mv	a1,s2
    1264:	00006517          	auipc	a0,0x6
    1268:	02450513          	addi	a0,a0,36 # 7288 <malloc+0x7c6>
    126c:	00005097          	auipc	ra,0x5
    1270:	798080e7          	jalr	1944(ra) # 6a04 <printf>
    exit(1,"");
    1274:	00007597          	auipc	a1,0x7
    1278:	f8458593          	addi	a1,a1,-124 # 81f8 <malloc+0x1736>
    127c:	4505                	li	a0,1
    127e:	00005097          	auipc	ra,0x5
    1282:	3fe080e7          	jalr	1022(ra) # 667c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1286:	85ca                	mv	a1,s2
    1288:	00006517          	auipc	a0,0x6
    128c:	01850513          	addi	a0,a0,24 # 72a0 <malloc+0x7de>
    1290:	00005097          	auipc	ra,0x5
    1294:	774080e7          	jalr	1908(ra) # 6a04 <printf>
    exit(1,"");
    1298:	00007597          	auipc	a1,0x7
    129c:	f6058593          	addi	a1,a1,-160 # 81f8 <malloc+0x1736>
    12a0:	4505                	li	a0,1
    12a2:	00005097          	auipc	ra,0x5
    12a6:	3da080e7          	jalr	986(ra) # 667c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    12aa:	85ca                	mv	a1,s2
    12ac:	00006517          	auipc	a0,0x6
    12b0:	01c50513          	addi	a0,a0,28 # 72c8 <malloc+0x806>
    12b4:	00005097          	auipc	ra,0x5
    12b8:	750080e7          	jalr	1872(ra) # 6a04 <printf>
    exit(1,"");
    12bc:	00007597          	auipc	a1,0x7
    12c0:	f3c58593          	addi	a1,a1,-196 # 81f8 <malloc+0x1736>
    12c4:	4505                	li	a0,1
    12c6:	00005097          	auipc	ra,0x5
    12ca:	3b6080e7          	jalr	950(ra) # 667c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    12ce:	85ca                	mv	a1,s2
    12d0:	00006517          	auipc	a0,0x6
    12d4:	02850513          	addi	a0,a0,40 # 72f8 <malloc+0x836>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	72c080e7          	jalr	1836(ra) # 6a04 <printf>
    exit(1,"");
    12e0:	00007597          	auipc	a1,0x7
    12e4:	f1858593          	addi	a1,a1,-232 # 81f8 <malloc+0x1736>
    12e8:	4505                	li	a0,1
    12ea:	00005097          	auipc	ra,0x5
    12ee:	392080e7          	jalr	914(ra) # 667c <exit>

00000000000012f2 <validatetest>:
{
    12f2:	7139                	addi	sp,sp,-64
    12f4:	fc06                	sd	ra,56(sp)
    12f6:	f822                	sd	s0,48(sp)
    12f8:	f426                	sd	s1,40(sp)
    12fa:	f04a                	sd	s2,32(sp)
    12fc:	ec4e                	sd	s3,24(sp)
    12fe:	e852                	sd	s4,16(sp)
    1300:	e456                	sd	s5,8(sp)
    1302:	e05a                	sd	s6,0(sp)
    1304:	0080                	addi	s0,sp,64
    1306:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1308:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    130a:	00006997          	auipc	s3,0x6
    130e:	00e98993          	addi	s3,s3,14 # 7318 <malloc+0x856>
    1312:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1314:	6a85                	lui	s5,0x1
    1316:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    131a:	85a6                	mv	a1,s1
    131c:	854e                	mv	a0,s3
    131e:	00005097          	auipc	ra,0x5
    1322:	3be080e7          	jalr	958(ra) # 66dc <link>
    1326:	01251f63          	bne	a0,s2,1344 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    132a:	94d6                	add	s1,s1,s5
    132c:	ff4497e3          	bne	s1,s4,131a <validatetest+0x28>
}
    1330:	70e2                	ld	ra,56(sp)
    1332:	7442                	ld	s0,48(sp)
    1334:	74a2                	ld	s1,40(sp)
    1336:	7902                	ld	s2,32(sp)
    1338:	69e2                	ld	s3,24(sp)
    133a:	6a42                	ld	s4,16(sp)
    133c:	6aa2                	ld	s5,8(sp)
    133e:	6b02                	ld	s6,0(sp)
    1340:	6121                	addi	sp,sp,64
    1342:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1344:	85da                	mv	a1,s6
    1346:	00006517          	auipc	a0,0x6
    134a:	fe250513          	addi	a0,a0,-30 # 7328 <malloc+0x866>
    134e:	00005097          	auipc	ra,0x5
    1352:	6b6080e7          	jalr	1718(ra) # 6a04 <printf>
      exit(1,"");
    1356:	00007597          	auipc	a1,0x7
    135a:	ea258593          	addi	a1,a1,-350 # 81f8 <malloc+0x1736>
    135e:	4505                	li	a0,1
    1360:	00005097          	auipc	ra,0x5
    1364:	31c080e7          	jalr	796(ra) # 667c <exit>

0000000000001368 <bigdir>:
{
    1368:	715d                	addi	sp,sp,-80
    136a:	e486                	sd	ra,72(sp)
    136c:	e0a2                	sd	s0,64(sp)
    136e:	fc26                	sd	s1,56(sp)
    1370:	f84a                	sd	s2,48(sp)
    1372:	f44e                	sd	s3,40(sp)
    1374:	f052                	sd	s4,32(sp)
    1376:	ec56                	sd	s5,24(sp)
    1378:	e85a                	sd	s6,16(sp)
    137a:	0880                	addi	s0,sp,80
    137c:	89aa                	mv	s3,a0
  unlink("bd");
    137e:	00006517          	auipc	a0,0x6
    1382:	fca50513          	addi	a0,a0,-54 # 7348 <malloc+0x886>
    1386:	00005097          	auipc	ra,0x5
    138a:	346080e7          	jalr	838(ra) # 66cc <unlink>
  fd = open("bd", O_CREATE);
    138e:	20000593          	li	a1,512
    1392:	00006517          	auipc	a0,0x6
    1396:	fb650513          	addi	a0,a0,-74 # 7348 <malloc+0x886>
    139a:	00005097          	auipc	ra,0x5
    139e:	322080e7          	jalr	802(ra) # 66bc <open>
  if(fd < 0){
    13a2:	0c054963          	bltz	a0,1474 <bigdir+0x10c>
  close(fd);
    13a6:	00005097          	auipc	ra,0x5
    13aa:	2fe080e7          	jalr	766(ra) # 66a4 <close>
  for(i = 0; i < N; i++){
    13ae:	4901                	li	s2,0
    name[0] = 'x';
    13b0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    13b4:	00006a17          	auipc	s4,0x6
    13b8:	f94a0a13          	addi	s4,s4,-108 # 7348 <malloc+0x886>
  for(i = 0; i < N; i++){
    13bc:	1f400b13          	li	s6,500
    name[0] = 'x';
    13c0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    13c4:	41f9579b          	sraiw	a5,s2,0x1f
    13c8:	01a7d71b          	srliw	a4,a5,0x1a
    13cc:	012707bb          	addw	a5,a4,s2
    13d0:	4067d69b          	sraiw	a3,a5,0x6
    13d4:	0306869b          	addiw	a3,a3,48
    13d8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    13dc:	03f7f793          	andi	a5,a5,63
    13e0:	9f99                	subw	a5,a5,a4
    13e2:	0307879b          	addiw	a5,a5,48
    13e6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    13ea:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    13ee:	fb040593          	addi	a1,s0,-80
    13f2:	8552                	mv	a0,s4
    13f4:	00005097          	auipc	ra,0x5
    13f8:	2e8080e7          	jalr	744(ra) # 66dc <link>
    13fc:	84aa                	mv	s1,a0
    13fe:	ed49                	bnez	a0,1498 <bigdir+0x130>
  for(i = 0; i < N; i++){
    1400:	2905                	addiw	s2,s2,1
    1402:	fb691fe3          	bne	s2,s6,13c0 <bigdir+0x58>
  unlink("bd");
    1406:	00006517          	auipc	a0,0x6
    140a:	f4250513          	addi	a0,a0,-190 # 7348 <malloc+0x886>
    140e:	00005097          	auipc	ra,0x5
    1412:	2be080e7          	jalr	702(ra) # 66cc <unlink>
    name[0] = 'x';
    1416:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    141a:	1f400a13          	li	s4,500
    name[0] = 'x';
    141e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1422:	41f4d79b          	sraiw	a5,s1,0x1f
    1426:	01a7d71b          	srliw	a4,a5,0x1a
    142a:	009707bb          	addw	a5,a4,s1
    142e:	4067d69b          	sraiw	a3,a5,0x6
    1432:	0306869b          	addiw	a3,a3,48
    1436:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    143a:	03f7f793          	andi	a5,a5,63
    143e:	9f99                	subw	a5,a5,a4
    1440:	0307879b          	addiw	a5,a5,48
    1444:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1448:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    144c:	fb040513          	addi	a0,s0,-80
    1450:	00005097          	auipc	ra,0x5
    1454:	27c080e7          	jalr	636(ra) # 66cc <unlink>
    1458:	e525                	bnez	a0,14c0 <bigdir+0x158>
  for(i = 0; i < N; i++){
    145a:	2485                	addiw	s1,s1,1
    145c:	fd4491e3          	bne	s1,s4,141e <bigdir+0xb6>
}
    1460:	60a6                	ld	ra,72(sp)
    1462:	6406                	ld	s0,64(sp)
    1464:	74e2                	ld	s1,56(sp)
    1466:	7942                	ld	s2,48(sp)
    1468:	79a2                	ld	s3,40(sp)
    146a:	7a02                	ld	s4,32(sp)
    146c:	6ae2                	ld	s5,24(sp)
    146e:	6b42                	ld	s6,16(sp)
    1470:	6161                	addi	sp,sp,80
    1472:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1474:	85ce                	mv	a1,s3
    1476:	00006517          	auipc	a0,0x6
    147a:	eda50513          	addi	a0,a0,-294 # 7350 <malloc+0x88e>
    147e:	00005097          	auipc	ra,0x5
    1482:	586080e7          	jalr	1414(ra) # 6a04 <printf>
    exit(1,"");
    1486:	00007597          	auipc	a1,0x7
    148a:	d7258593          	addi	a1,a1,-654 # 81f8 <malloc+0x1736>
    148e:	4505                	li	a0,1
    1490:	00005097          	auipc	ra,0x5
    1494:	1ec080e7          	jalr	492(ra) # 667c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1498:	fb040613          	addi	a2,s0,-80
    149c:	85ce                	mv	a1,s3
    149e:	00006517          	auipc	a0,0x6
    14a2:	ed250513          	addi	a0,a0,-302 # 7370 <malloc+0x8ae>
    14a6:	00005097          	auipc	ra,0x5
    14aa:	55e080e7          	jalr	1374(ra) # 6a04 <printf>
      exit(1,"");
    14ae:	00007597          	auipc	a1,0x7
    14b2:	d4a58593          	addi	a1,a1,-694 # 81f8 <malloc+0x1736>
    14b6:	4505                	li	a0,1
    14b8:	00005097          	auipc	ra,0x5
    14bc:	1c4080e7          	jalr	452(ra) # 667c <exit>
      printf("%s: bigdir unlink failed", s);
    14c0:	85ce                	mv	a1,s3
    14c2:	00006517          	auipc	a0,0x6
    14c6:	ece50513          	addi	a0,a0,-306 # 7390 <malloc+0x8ce>
    14ca:	00005097          	auipc	ra,0x5
    14ce:	53a080e7          	jalr	1338(ra) # 6a04 <printf>
      exit(1,"");
    14d2:	00007597          	auipc	a1,0x7
    14d6:	d2658593          	addi	a1,a1,-730 # 81f8 <malloc+0x1736>
    14da:	4505                	li	a0,1
    14dc:	00005097          	auipc	ra,0x5
    14e0:	1a0080e7          	jalr	416(ra) # 667c <exit>

00000000000014e4 <pgbug>:
{
    14e4:	7179                	addi	sp,sp,-48
    14e6:	f406                	sd	ra,40(sp)
    14e8:	f022                	sd	s0,32(sp)
    14ea:	ec26                	sd	s1,24(sp)
    14ec:	1800                	addi	s0,sp,48
  argv[0] = 0;
    14ee:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    14f2:	00009497          	auipc	s1,0x9
    14f6:	b0e48493          	addi	s1,s1,-1266 # a000 <big>
    14fa:	fd840593          	addi	a1,s0,-40
    14fe:	6088                	ld	a0,0(s1)
    1500:	00005097          	auipc	ra,0x5
    1504:	1b4080e7          	jalr	436(ra) # 66b4 <exec>
  pipe(big);
    1508:	6088                	ld	a0,0(s1)
    150a:	00005097          	auipc	ra,0x5
    150e:	182080e7          	jalr	386(ra) # 668c <pipe>
  exit(0,"");
    1512:	00007597          	auipc	a1,0x7
    1516:	ce658593          	addi	a1,a1,-794 # 81f8 <malloc+0x1736>
    151a:	4501                	li	a0,0
    151c:	00005097          	auipc	ra,0x5
    1520:	160080e7          	jalr	352(ra) # 667c <exit>

0000000000001524 <badarg>:
{
    1524:	7139                	addi	sp,sp,-64
    1526:	fc06                	sd	ra,56(sp)
    1528:	f822                	sd	s0,48(sp)
    152a:	f426                	sd	s1,40(sp)
    152c:	f04a                	sd	s2,32(sp)
    152e:	ec4e                	sd	s3,24(sp)
    1530:	0080                	addi	s0,sp,64
    1532:	64b1                	lui	s1,0xc
    1534:	35048493          	addi	s1,s1,848 # c350 <uninit+0xde8>
    argv[0] = (char*)0xffffffff;
    1538:	597d                	li	s2,-1
    153a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    153e:	00005997          	auipc	s3,0x5
    1542:	6ca98993          	addi	s3,s3,1738 # 6c08 <malloc+0x146>
    argv[0] = (char*)0xffffffff;
    1546:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    154a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    154e:	fc040593          	addi	a1,s0,-64
    1552:	854e                	mv	a0,s3
    1554:	00005097          	auipc	ra,0x5
    1558:	160080e7          	jalr	352(ra) # 66b4 <exec>
  for(int i = 0; i < 50000; i++){
    155c:	34fd                	addiw	s1,s1,-1
    155e:	f4e5                	bnez	s1,1546 <badarg+0x22>
  exit(0,"");
    1560:	00007597          	auipc	a1,0x7
    1564:	c9858593          	addi	a1,a1,-872 # 81f8 <malloc+0x1736>
    1568:	4501                	li	a0,0
    156a:	00005097          	auipc	ra,0x5
    156e:	112080e7          	jalr	274(ra) # 667c <exit>

0000000000001572 <copyinstr2>:
{
    1572:	7155                	addi	sp,sp,-208
    1574:	e586                	sd	ra,200(sp)
    1576:	e1a2                	sd	s0,192(sp)
    1578:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    157a:	f6840793          	addi	a5,s0,-152
    157e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1582:	07800713          	li	a4,120
    1586:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    158a:	0785                	addi	a5,a5,1
    158c:	fed79de3          	bne	a5,a3,1586 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1590:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1594:	f6840513          	addi	a0,s0,-152
    1598:	00005097          	auipc	ra,0x5
    159c:	134080e7          	jalr	308(ra) # 66cc <unlink>
  if(ret != -1){
    15a0:	57fd                	li	a5,-1
    15a2:	0ef51463          	bne	a0,a5,168a <copyinstr2+0x118>
  int fd = open(b, O_CREATE | O_WRONLY);
    15a6:	20100593          	li	a1,513
    15aa:	f6840513          	addi	a0,s0,-152
    15ae:	00005097          	auipc	ra,0x5
    15b2:	10e080e7          	jalr	270(ra) # 66bc <open>
  if(fd != -1){
    15b6:	57fd                	li	a5,-1
    15b8:	0ef51d63          	bne	a0,a5,16b2 <copyinstr2+0x140>
  ret = link(b, b);
    15bc:	f6840593          	addi	a1,s0,-152
    15c0:	852e                	mv	a0,a1
    15c2:	00005097          	auipc	ra,0x5
    15c6:	11a080e7          	jalr	282(ra) # 66dc <link>
  if(ret != -1){
    15ca:	57fd                	li	a5,-1
    15cc:	10f51763          	bne	a0,a5,16da <copyinstr2+0x168>
  char *args[] = { "xx", 0 };
    15d0:	00007797          	auipc	a5,0x7
    15d4:	01878793          	addi	a5,a5,24 # 85e8 <malloc+0x1b26>
    15d8:	f4f43c23          	sd	a5,-168(s0)
    15dc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    15e0:	f5840593          	addi	a1,s0,-168
    15e4:	f6840513          	addi	a0,s0,-152
    15e8:	00005097          	auipc	ra,0x5
    15ec:	0cc080e7          	jalr	204(ra) # 66b4 <exec>
  if(ret != -1){
    15f0:	57fd                	li	a5,-1
    15f2:	10f51963          	bne	a0,a5,1704 <copyinstr2+0x192>
  int pid = fork();
    15f6:	00005097          	auipc	ra,0x5
    15fa:	07e080e7          	jalr	126(ra) # 6674 <fork>
  if(pid < 0){
    15fe:	12054763          	bltz	a0,172c <copyinstr2+0x1ba>
  if(pid == 0){
    1602:	16051063          	bnez	a0,1762 <copyinstr2+0x1f0>
    1606:	00009797          	auipc	a5,0x9
    160a:	f5a78793          	addi	a5,a5,-166 # a560 <big.0>
    160e:	0000a697          	auipc	a3,0xa
    1612:	f5268693          	addi	a3,a3,-174 # b560 <big.0+0x1000>
      big[i] = 'x';
    1616:	07800713          	li	a4,120
    161a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    161e:	0785                	addi	a5,a5,1
    1620:	fed79de3          	bne	a5,a3,161a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1624:	0000a797          	auipc	a5,0xa
    1628:	f2078e23          	sb	zero,-196(a5) # b560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    162c:	00008797          	auipc	a5,0x8
    1630:	9dc78793          	addi	a5,a5,-1572 # 9008 <malloc+0x2546>
    1634:	6390                	ld	a2,0(a5)
    1636:	6794                	ld	a3,8(a5)
    1638:	6b98                	ld	a4,16(a5)
    163a:	6f9c                	ld	a5,24(a5)
    163c:	f2c43823          	sd	a2,-208(s0)
    1640:	f2d43c23          	sd	a3,-200(s0)
    1644:	f4e43023          	sd	a4,-192(s0)
    1648:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    164c:	f3040593          	addi	a1,s0,-208
    1650:	00005517          	auipc	a0,0x5
    1654:	5b850513          	addi	a0,a0,1464 # 6c08 <malloc+0x146>
    1658:	00005097          	auipc	ra,0x5
    165c:	05c080e7          	jalr	92(ra) # 66b4 <exec>
    if(ret != -1){
    1660:	57fd                	li	a5,-1
    1662:	0ef50663          	beq	a0,a5,174e <copyinstr2+0x1dc>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1666:	55fd                	li	a1,-1
    1668:	00006517          	auipc	a0,0x6
    166c:	dd050513          	addi	a0,a0,-560 # 7438 <malloc+0x976>
    1670:	00005097          	auipc	ra,0x5
    1674:	394080e7          	jalr	916(ra) # 6a04 <printf>
      exit(1,"");
    1678:	00007597          	auipc	a1,0x7
    167c:	b8058593          	addi	a1,a1,-1152 # 81f8 <malloc+0x1736>
    1680:	4505                	li	a0,1
    1682:	00005097          	auipc	ra,0x5
    1686:	ffa080e7          	jalr	-6(ra) # 667c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    168a:	862a                	mv	a2,a0
    168c:	f6840593          	addi	a1,s0,-152
    1690:	00006517          	auipc	a0,0x6
    1694:	d2050513          	addi	a0,a0,-736 # 73b0 <malloc+0x8ee>
    1698:	00005097          	auipc	ra,0x5
    169c:	36c080e7          	jalr	876(ra) # 6a04 <printf>
    exit(1,"");
    16a0:	00007597          	auipc	a1,0x7
    16a4:	b5858593          	addi	a1,a1,-1192 # 81f8 <malloc+0x1736>
    16a8:	4505                	li	a0,1
    16aa:	00005097          	auipc	ra,0x5
    16ae:	fd2080e7          	jalr	-46(ra) # 667c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    16b2:	862a                	mv	a2,a0
    16b4:	f6840593          	addi	a1,s0,-152
    16b8:	00006517          	auipc	a0,0x6
    16bc:	d1850513          	addi	a0,a0,-744 # 73d0 <malloc+0x90e>
    16c0:	00005097          	auipc	ra,0x5
    16c4:	344080e7          	jalr	836(ra) # 6a04 <printf>
    exit(1,"");
    16c8:	00007597          	auipc	a1,0x7
    16cc:	b3058593          	addi	a1,a1,-1232 # 81f8 <malloc+0x1736>
    16d0:	4505                	li	a0,1
    16d2:	00005097          	auipc	ra,0x5
    16d6:	faa080e7          	jalr	-86(ra) # 667c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    16da:	86aa                	mv	a3,a0
    16dc:	f6840613          	addi	a2,s0,-152
    16e0:	85b2                	mv	a1,a2
    16e2:	00006517          	auipc	a0,0x6
    16e6:	d0e50513          	addi	a0,a0,-754 # 73f0 <malloc+0x92e>
    16ea:	00005097          	auipc	ra,0x5
    16ee:	31a080e7          	jalr	794(ra) # 6a04 <printf>
    exit(1,"");
    16f2:	00007597          	auipc	a1,0x7
    16f6:	b0658593          	addi	a1,a1,-1274 # 81f8 <malloc+0x1736>
    16fa:	4505                	li	a0,1
    16fc:	00005097          	auipc	ra,0x5
    1700:	f80080e7          	jalr	-128(ra) # 667c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1704:	567d                	li	a2,-1
    1706:	f6840593          	addi	a1,s0,-152
    170a:	00006517          	auipc	a0,0x6
    170e:	d0e50513          	addi	a0,a0,-754 # 7418 <malloc+0x956>
    1712:	00005097          	auipc	ra,0x5
    1716:	2f2080e7          	jalr	754(ra) # 6a04 <printf>
    exit(1,"");
    171a:	00007597          	auipc	a1,0x7
    171e:	ade58593          	addi	a1,a1,-1314 # 81f8 <malloc+0x1736>
    1722:	4505                	li	a0,1
    1724:	00005097          	auipc	ra,0x5
    1728:	f58080e7          	jalr	-168(ra) # 667c <exit>
    printf("fork failed\n");
    172c:	00006517          	auipc	a0,0x6
    1730:	16c50513          	addi	a0,a0,364 # 7898 <malloc+0xdd6>
    1734:	00005097          	auipc	ra,0x5
    1738:	2d0080e7          	jalr	720(ra) # 6a04 <printf>
    exit(1,"");
    173c:	00007597          	auipc	a1,0x7
    1740:	abc58593          	addi	a1,a1,-1348 # 81f8 <malloc+0x1736>
    1744:	4505                	li	a0,1
    1746:	00005097          	auipc	ra,0x5
    174a:	f36080e7          	jalr	-202(ra) # 667c <exit>
    exit(747,""); // OK
    174e:	00007597          	auipc	a1,0x7
    1752:	aaa58593          	addi	a1,a1,-1366 # 81f8 <malloc+0x1736>
    1756:	2eb00513          	li	a0,747
    175a:	00005097          	auipc	ra,0x5
    175e:	f22080e7          	jalr	-222(ra) # 667c <exit>
  int st = 0;
    1762:	f4042a23          	sw	zero,-172(s0)
  wait(&st,0);
    1766:	4581                	li	a1,0
    1768:	f5440513          	addi	a0,s0,-172
    176c:	00005097          	auipc	ra,0x5
    1770:	f18080e7          	jalr	-232(ra) # 6684 <wait>
  if(st != 747){
    1774:	f5442703          	lw	a4,-172(s0)
    1778:	2eb00793          	li	a5,747
    177c:	00f71663          	bne	a4,a5,1788 <copyinstr2+0x216>
}
    1780:	60ae                	ld	ra,200(sp)
    1782:	640e                	ld	s0,192(sp)
    1784:	6169                	addi	sp,sp,208
    1786:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1788:	00006517          	auipc	a0,0x6
    178c:	cd850513          	addi	a0,a0,-808 # 7460 <malloc+0x99e>
    1790:	00005097          	auipc	ra,0x5
    1794:	274080e7          	jalr	628(ra) # 6a04 <printf>
    exit(1,"");
    1798:	00007597          	auipc	a1,0x7
    179c:	a6058593          	addi	a1,a1,-1440 # 81f8 <malloc+0x1736>
    17a0:	4505                	li	a0,1
    17a2:	00005097          	auipc	ra,0x5
    17a6:	eda080e7          	jalr	-294(ra) # 667c <exit>

00000000000017aa <truncate3>:
{
    17aa:	7159                	addi	sp,sp,-112
    17ac:	f486                	sd	ra,104(sp)
    17ae:	f0a2                	sd	s0,96(sp)
    17b0:	eca6                	sd	s1,88(sp)
    17b2:	e8ca                	sd	s2,80(sp)
    17b4:	e4ce                	sd	s3,72(sp)
    17b6:	e0d2                	sd	s4,64(sp)
    17b8:	fc56                	sd	s5,56(sp)
    17ba:	1880                	addi	s0,sp,112
    17bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    17be:	60100593          	li	a1,1537
    17c2:	00005517          	auipc	a0,0x5
    17c6:	49e50513          	addi	a0,a0,1182 # 6c60 <malloc+0x19e>
    17ca:	00005097          	auipc	ra,0x5
    17ce:	ef2080e7          	jalr	-270(ra) # 66bc <open>
    17d2:	00005097          	auipc	ra,0x5
    17d6:	ed2080e7          	jalr	-302(ra) # 66a4 <close>
  pid = fork();
    17da:	00005097          	auipc	ra,0x5
    17de:	e9a080e7          	jalr	-358(ra) # 6674 <fork>
  if(pid < 0){
    17e2:	08054463          	bltz	a0,186a <truncate3+0xc0>
  if(pid == 0){
    17e6:	e96d                	bnez	a0,18d8 <truncate3+0x12e>
    17e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    17ec:	00005a17          	auipc	s4,0x5
    17f0:	474a0a13          	addi	s4,s4,1140 # 6c60 <malloc+0x19e>
      int n = write(fd, "1234567890", 10);
    17f4:	00006a97          	auipc	s5,0x6
    17f8:	ccca8a93          	addi	s5,s5,-820 # 74c0 <malloc+0x9fe>
      int fd = open("truncfile", O_WRONLY);
    17fc:	4585                	li	a1,1
    17fe:	8552                	mv	a0,s4
    1800:	00005097          	auipc	ra,0x5
    1804:	ebc080e7          	jalr	-324(ra) # 66bc <open>
    1808:	84aa                	mv	s1,a0
      if(fd < 0){
    180a:	08054263          	bltz	a0,188e <truncate3+0xe4>
      int n = write(fd, "1234567890", 10);
    180e:	4629                	li	a2,10
    1810:	85d6                	mv	a1,s5
    1812:	00005097          	auipc	ra,0x5
    1816:	e8a080e7          	jalr	-374(ra) # 669c <write>
      if(n != 10){
    181a:	47a9                	li	a5,10
    181c:	08f51b63          	bne	a0,a5,18b2 <truncate3+0x108>
      close(fd);
    1820:	8526                	mv	a0,s1
    1822:	00005097          	auipc	ra,0x5
    1826:	e82080e7          	jalr	-382(ra) # 66a4 <close>
      fd = open("truncfile", O_RDONLY);
    182a:	4581                	li	a1,0
    182c:	8552                	mv	a0,s4
    182e:	00005097          	auipc	ra,0x5
    1832:	e8e080e7          	jalr	-370(ra) # 66bc <open>
    1836:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1838:	02000613          	li	a2,32
    183c:	f9840593          	addi	a1,s0,-104
    1840:	00005097          	auipc	ra,0x5
    1844:	e54080e7          	jalr	-428(ra) # 6694 <read>
      close(fd);
    1848:	8526                	mv	a0,s1
    184a:	00005097          	auipc	ra,0x5
    184e:	e5a080e7          	jalr	-422(ra) # 66a4 <close>
    for(int i = 0; i < 100; i++){
    1852:	39fd                	addiw	s3,s3,-1
    1854:	fa0994e3          	bnez	s3,17fc <truncate3+0x52>
    exit(0,"");
    1858:	00007597          	auipc	a1,0x7
    185c:	9a058593          	addi	a1,a1,-1632 # 81f8 <malloc+0x1736>
    1860:	4501                	li	a0,0
    1862:	00005097          	auipc	ra,0x5
    1866:	e1a080e7          	jalr	-486(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00006517          	auipc	a0,0x6
    1870:	c2450513          	addi	a0,a0,-988 # 7490 <malloc+0x9ce>
    1874:	00005097          	auipc	ra,0x5
    1878:	190080e7          	jalr	400(ra) # 6a04 <printf>
    exit(1,"");
    187c:	00007597          	auipc	a1,0x7
    1880:	97c58593          	addi	a1,a1,-1668 # 81f8 <malloc+0x1736>
    1884:	4505                	li	a0,1
    1886:	00005097          	auipc	ra,0x5
    188a:	df6080e7          	jalr	-522(ra) # 667c <exit>
        printf("%s: open failed\n", s);
    188e:	85ca                	mv	a1,s2
    1890:	00006517          	auipc	a0,0x6
    1894:	c1850513          	addi	a0,a0,-1000 # 74a8 <malloc+0x9e6>
    1898:	00005097          	auipc	ra,0x5
    189c:	16c080e7          	jalr	364(ra) # 6a04 <printf>
        exit(1,"");
    18a0:	00007597          	auipc	a1,0x7
    18a4:	95858593          	addi	a1,a1,-1704 # 81f8 <malloc+0x1736>
    18a8:	4505                	li	a0,1
    18aa:	00005097          	auipc	ra,0x5
    18ae:	dd2080e7          	jalr	-558(ra) # 667c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    18b2:	862a                	mv	a2,a0
    18b4:	85ca                	mv	a1,s2
    18b6:	00006517          	auipc	a0,0x6
    18ba:	c1a50513          	addi	a0,a0,-998 # 74d0 <malloc+0xa0e>
    18be:	00005097          	auipc	ra,0x5
    18c2:	146080e7          	jalr	326(ra) # 6a04 <printf>
        exit(1,"");
    18c6:	00007597          	auipc	a1,0x7
    18ca:	93258593          	addi	a1,a1,-1742 # 81f8 <malloc+0x1736>
    18ce:	4505                	li	a0,1
    18d0:	00005097          	auipc	ra,0x5
    18d4:	dac080e7          	jalr	-596(ra) # 667c <exit>
    18d8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18dc:	00005a17          	auipc	s4,0x5
    18e0:	384a0a13          	addi	s4,s4,900 # 6c60 <malloc+0x19e>
    int n = write(fd, "xxx", 3);
    18e4:	00006a97          	auipc	s5,0x6
    18e8:	c0ca8a93          	addi	s5,s5,-1012 # 74f0 <malloc+0xa2e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18ec:	60100593          	li	a1,1537
    18f0:	8552                	mv	a0,s4
    18f2:	00005097          	auipc	ra,0x5
    18f6:	dca080e7          	jalr	-566(ra) # 66bc <open>
    18fa:	84aa                	mv	s1,a0
    if(fd < 0){
    18fc:	04054c63          	bltz	a0,1954 <truncate3+0x1aa>
    int n = write(fd, "xxx", 3);
    1900:	460d                	li	a2,3
    1902:	85d6                	mv	a1,s5
    1904:	00005097          	auipc	ra,0x5
    1908:	d98080e7          	jalr	-616(ra) # 669c <write>
    if(n != 3){
    190c:	478d                	li	a5,3
    190e:	06f51563          	bne	a0,a5,1978 <truncate3+0x1ce>
    close(fd);
    1912:	8526                	mv	a0,s1
    1914:	00005097          	auipc	ra,0x5
    1918:	d90080e7          	jalr	-624(ra) # 66a4 <close>
  for(int i = 0; i < 150; i++){
    191c:	39fd                	addiw	s3,s3,-1
    191e:	fc0997e3          	bnez	s3,18ec <truncate3+0x142>
  wait(&xstatus ,0);
    1922:	4581                	li	a1,0
    1924:	fbc40513          	addi	a0,s0,-68
    1928:	00005097          	auipc	ra,0x5
    192c:	d5c080e7          	jalr	-676(ra) # 6684 <wait>
  unlink("truncfile");
    1930:	00005517          	auipc	a0,0x5
    1934:	33050513          	addi	a0,a0,816 # 6c60 <malloc+0x19e>
    1938:	00005097          	auipc	ra,0x5
    193c:	d94080e7          	jalr	-620(ra) # 66cc <unlink>
  exit(xstatus,"");
    1940:	00007597          	auipc	a1,0x7
    1944:	8b858593          	addi	a1,a1,-1864 # 81f8 <malloc+0x1736>
    1948:	fbc42503          	lw	a0,-68(s0)
    194c:	00005097          	auipc	ra,0x5
    1950:	d30080e7          	jalr	-720(ra) # 667c <exit>
      printf("%s: open failed\n", s);
    1954:	85ca                	mv	a1,s2
    1956:	00006517          	auipc	a0,0x6
    195a:	b5250513          	addi	a0,a0,-1198 # 74a8 <malloc+0x9e6>
    195e:	00005097          	auipc	ra,0x5
    1962:	0a6080e7          	jalr	166(ra) # 6a04 <printf>
      exit(1,"");
    1966:	00007597          	auipc	a1,0x7
    196a:	89258593          	addi	a1,a1,-1902 # 81f8 <malloc+0x1736>
    196e:	4505                	li	a0,1
    1970:	00005097          	auipc	ra,0x5
    1974:	d0c080e7          	jalr	-756(ra) # 667c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1978:	862a                	mv	a2,a0
    197a:	85ca                	mv	a1,s2
    197c:	00006517          	auipc	a0,0x6
    1980:	b7c50513          	addi	a0,a0,-1156 # 74f8 <malloc+0xa36>
    1984:	00005097          	auipc	ra,0x5
    1988:	080080e7          	jalr	128(ra) # 6a04 <printf>
      exit(1,"");
    198c:	00007597          	auipc	a1,0x7
    1990:	86c58593          	addi	a1,a1,-1940 # 81f8 <malloc+0x1736>
    1994:	4505                	li	a0,1
    1996:	00005097          	auipc	ra,0x5
    199a:	ce6080e7          	jalr	-794(ra) # 667c <exit>

000000000000199e <exectest>:
{
    199e:	715d                	addi	sp,sp,-80
    19a0:	e486                	sd	ra,72(sp)
    19a2:	e0a2                	sd	s0,64(sp)
    19a4:	fc26                	sd	s1,56(sp)
    19a6:	f84a                	sd	s2,48(sp)
    19a8:	0880                	addi	s0,sp,80
    19aa:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    19ac:	00005797          	auipc	a5,0x5
    19b0:	25c78793          	addi	a5,a5,604 # 6c08 <malloc+0x146>
    19b4:	fcf43023          	sd	a5,-64(s0)
    19b8:	00006797          	auipc	a5,0x6
    19bc:	b6078793          	addi	a5,a5,-1184 # 7518 <malloc+0xa56>
    19c0:	fcf43423          	sd	a5,-56(s0)
    19c4:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    19c8:	00006517          	auipc	a0,0x6
    19cc:	b5850513          	addi	a0,a0,-1192 # 7520 <malloc+0xa5e>
    19d0:	00005097          	auipc	ra,0x5
    19d4:	cfc080e7          	jalr	-772(ra) # 66cc <unlink>
  pid = fork();
    19d8:	00005097          	auipc	ra,0x5
    19dc:	c9c080e7          	jalr	-868(ra) # 6674 <fork>
  if(pid < 0) {
    19e0:	04054a63          	bltz	a0,1a34 <exectest+0x96>
    19e4:	84aa                	mv	s1,a0
  if(pid == 0) {
    19e6:	e55d                	bnez	a0,1a94 <exectest+0xf6>
    close(1);
    19e8:	4505                	li	a0,1
    19ea:	00005097          	auipc	ra,0x5
    19ee:	cba080e7          	jalr	-838(ra) # 66a4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    19f2:	20100593          	li	a1,513
    19f6:	00006517          	auipc	a0,0x6
    19fa:	b2a50513          	addi	a0,a0,-1238 # 7520 <malloc+0xa5e>
    19fe:	00005097          	auipc	ra,0x5
    1a02:	cbe080e7          	jalr	-834(ra) # 66bc <open>
    if(fd < 0) {
    1a06:	04054963          	bltz	a0,1a58 <exectest+0xba>
    if(fd != 1) {
    1a0a:	4785                	li	a5,1
    1a0c:	06f50863          	beq	a0,a5,1a7c <exectest+0xde>
      printf("%s: wrong fd\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00006517          	auipc	a0,0x6
    1a16:	b2e50513          	addi	a0,a0,-1234 # 7540 <malloc+0xa7e>
    1a1a:	00005097          	auipc	ra,0x5
    1a1e:	fea080e7          	jalr	-22(ra) # 6a04 <printf>
      exit(1,"");
    1a22:	00006597          	auipc	a1,0x6
    1a26:	7d658593          	addi	a1,a1,2006 # 81f8 <malloc+0x1736>
    1a2a:	4505                	li	a0,1
    1a2c:	00005097          	auipc	ra,0x5
    1a30:	c50080e7          	jalr	-944(ra) # 667c <exit>
     printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00006517          	auipc	a0,0x6
    1a3a:	a5a50513          	addi	a0,a0,-1446 # 7490 <malloc+0x9ce>
    1a3e:	00005097          	auipc	ra,0x5
    1a42:	fc6080e7          	jalr	-58(ra) # 6a04 <printf>
     exit(1,"");
    1a46:	00006597          	auipc	a1,0x6
    1a4a:	7b258593          	addi	a1,a1,1970 # 81f8 <malloc+0x1736>
    1a4e:	4505                	li	a0,1
    1a50:	00005097          	auipc	ra,0x5
    1a54:	c2c080e7          	jalr	-980(ra) # 667c <exit>
      printf("%s: create failed\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00006517          	auipc	a0,0x6
    1a5e:	ace50513          	addi	a0,a0,-1330 # 7528 <malloc+0xa66>
    1a62:	00005097          	auipc	ra,0x5
    1a66:	fa2080e7          	jalr	-94(ra) # 6a04 <printf>
      exit(1,"");
    1a6a:	00006597          	auipc	a1,0x6
    1a6e:	78e58593          	addi	a1,a1,1934 # 81f8 <malloc+0x1736>
    1a72:	4505                	li	a0,1
    1a74:	00005097          	auipc	ra,0x5
    1a78:	c08080e7          	jalr	-1016(ra) # 667c <exit>
    if(exec("echo", echoargv) < 0){
    1a7c:	fc040593          	addi	a1,s0,-64
    1a80:	00005517          	auipc	a0,0x5
    1a84:	18850513          	addi	a0,a0,392 # 6c08 <malloc+0x146>
    1a88:	00005097          	auipc	ra,0x5
    1a8c:	c2c080e7          	jalr	-980(ra) # 66b4 <exec>
    1a90:	02054663          	bltz	a0,1abc <exectest+0x11e>
  if (wait(&xstatus,0) != pid) {
    1a94:	4581                	li	a1,0
    1a96:	fdc40513          	addi	a0,s0,-36
    1a9a:	00005097          	auipc	ra,0x5
    1a9e:	bea080e7          	jalr	-1046(ra) # 6684 <wait>
    1aa2:	02951f63          	bne	a0,s1,1ae0 <exectest+0x142>
  if(xstatus != 0)
    1aa6:	fdc42503          	lw	a0,-36(s0)
    1aaa:	c529                	beqz	a0,1af4 <exectest+0x156>
    exit(xstatus,"");
    1aac:	00006597          	auipc	a1,0x6
    1ab0:	74c58593          	addi	a1,a1,1868 # 81f8 <malloc+0x1736>
    1ab4:	00005097          	auipc	ra,0x5
    1ab8:	bc8080e7          	jalr	-1080(ra) # 667c <exit>
      printf("%s: exec echo failed\n", s);
    1abc:	85ca                	mv	a1,s2
    1abe:	00006517          	auipc	a0,0x6
    1ac2:	a9250513          	addi	a0,a0,-1390 # 7550 <malloc+0xa8e>
    1ac6:	00005097          	auipc	ra,0x5
    1aca:	f3e080e7          	jalr	-194(ra) # 6a04 <printf>
      exit(1,"");
    1ace:	00006597          	auipc	a1,0x6
    1ad2:	72a58593          	addi	a1,a1,1834 # 81f8 <malloc+0x1736>
    1ad6:	4505                	li	a0,1
    1ad8:	00005097          	auipc	ra,0x5
    1adc:	ba4080e7          	jalr	-1116(ra) # 667c <exit>
    printf("%s: wait failed!\n", s);
    1ae0:	85ca                	mv	a1,s2
    1ae2:	00006517          	auipc	a0,0x6
    1ae6:	a8650513          	addi	a0,a0,-1402 # 7568 <malloc+0xaa6>
    1aea:	00005097          	auipc	ra,0x5
    1aee:	f1a080e7          	jalr	-230(ra) # 6a04 <printf>
    1af2:	bf55                	j	1aa6 <exectest+0x108>
  fd = open("echo-ok", O_RDONLY);
    1af4:	4581                	li	a1,0
    1af6:	00006517          	auipc	a0,0x6
    1afa:	a2a50513          	addi	a0,a0,-1494 # 7520 <malloc+0xa5e>
    1afe:	00005097          	auipc	ra,0x5
    1b02:	bbe080e7          	jalr	-1090(ra) # 66bc <open>
  if(fd < 0) {
    1b06:	02054e63          	bltz	a0,1b42 <exectest+0x1a4>
  if (read(fd, buf, 2) != 2) {
    1b0a:	4609                	li	a2,2
    1b0c:	fb840593          	addi	a1,s0,-72
    1b10:	00005097          	auipc	ra,0x5
    1b14:	b84080e7          	jalr	-1148(ra) # 6694 <read>
    1b18:	4789                	li	a5,2
    1b1a:	04f50663          	beq	a0,a5,1b66 <exectest+0x1c8>
    printf("%s: read failed\n", s);
    1b1e:	85ca                	mv	a1,s2
    1b20:	00005517          	auipc	a0,0x5
    1b24:	4b850513          	addi	a0,a0,1208 # 6fd8 <malloc+0x516>
    1b28:	00005097          	auipc	ra,0x5
    1b2c:	edc080e7          	jalr	-292(ra) # 6a04 <printf>
    exit(1,"");
    1b30:	00006597          	auipc	a1,0x6
    1b34:	6c858593          	addi	a1,a1,1736 # 81f8 <malloc+0x1736>
    1b38:	4505                	li	a0,1
    1b3a:	00005097          	auipc	ra,0x5
    1b3e:	b42080e7          	jalr	-1214(ra) # 667c <exit>
    printf("%s: open failed\n", s);
    1b42:	85ca                	mv	a1,s2
    1b44:	00006517          	auipc	a0,0x6
    1b48:	96450513          	addi	a0,a0,-1692 # 74a8 <malloc+0x9e6>
    1b4c:	00005097          	auipc	ra,0x5
    1b50:	eb8080e7          	jalr	-328(ra) # 6a04 <printf>
    exit(1,"");
    1b54:	00006597          	auipc	a1,0x6
    1b58:	6a458593          	addi	a1,a1,1700 # 81f8 <malloc+0x1736>
    1b5c:	4505                	li	a0,1
    1b5e:	00005097          	auipc	ra,0x5
    1b62:	b1e080e7          	jalr	-1250(ra) # 667c <exit>
  unlink("echo-ok");
    1b66:	00006517          	auipc	a0,0x6
    1b6a:	9ba50513          	addi	a0,a0,-1606 # 7520 <malloc+0xa5e>
    1b6e:	00005097          	auipc	ra,0x5
    1b72:	b5e080e7          	jalr	-1186(ra) # 66cc <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1b76:	fb844703          	lbu	a4,-72(s0)
    1b7a:	04f00793          	li	a5,79
    1b7e:	00f71863          	bne	a4,a5,1b8e <exectest+0x1f0>
    1b82:	fb944703          	lbu	a4,-71(s0)
    1b86:	04b00793          	li	a5,75
    1b8a:	02f70463          	beq	a4,a5,1bb2 <exectest+0x214>
    printf("%s: wrong output\n", s);
    1b8e:	85ca                	mv	a1,s2
    1b90:	00006517          	auipc	a0,0x6
    1b94:	9f050513          	addi	a0,a0,-1552 # 7580 <malloc+0xabe>
    1b98:	00005097          	auipc	ra,0x5
    1b9c:	e6c080e7          	jalr	-404(ra) # 6a04 <printf>
    exit(1,"");
    1ba0:	00006597          	auipc	a1,0x6
    1ba4:	65858593          	addi	a1,a1,1624 # 81f8 <malloc+0x1736>
    1ba8:	4505                	li	a0,1
    1baa:	00005097          	auipc	ra,0x5
    1bae:	ad2080e7          	jalr	-1326(ra) # 667c <exit>
    exit(0,"");
    1bb2:	00006597          	auipc	a1,0x6
    1bb6:	64658593          	addi	a1,a1,1606 # 81f8 <malloc+0x1736>
    1bba:	4501                	li	a0,0
    1bbc:	00005097          	auipc	ra,0x5
    1bc0:	ac0080e7          	jalr	-1344(ra) # 667c <exit>

0000000000001bc4 <pipe1>:
{
    1bc4:	711d                	addi	sp,sp,-96
    1bc6:	ec86                	sd	ra,88(sp)
    1bc8:	e8a2                	sd	s0,80(sp)
    1bca:	e4a6                	sd	s1,72(sp)
    1bcc:	e0ca                	sd	s2,64(sp)
    1bce:	fc4e                	sd	s3,56(sp)
    1bd0:	f852                	sd	s4,48(sp)
    1bd2:	f456                	sd	s5,40(sp)
    1bd4:	f05a                	sd	s6,32(sp)
    1bd6:	ec5e                	sd	s7,24(sp)
    1bd8:	1080                	addi	s0,sp,96
    1bda:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1bdc:	fa840513          	addi	a0,s0,-88
    1be0:	00005097          	auipc	ra,0x5
    1be4:	aac080e7          	jalr	-1364(ra) # 668c <pipe>
    1be8:	ed25                	bnez	a0,1c60 <pipe1+0x9c>
    1bea:	84aa                	mv	s1,a0
  pid = fork();
    1bec:	00005097          	auipc	ra,0x5
    1bf0:	a88080e7          	jalr	-1400(ra) # 6674 <fork>
    1bf4:	8a2a                	mv	s4,a0
  if(pid == 0){
    1bf6:	c559                	beqz	a0,1c84 <pipe1+0xc0>
  } else if(pid > 0){
    1bf8:	1aa05363          	blez	a0,1d9e <pipe1+0x1da>
    close(fds[1]);
    1bfc:	fac42503          	lw	a0,-84(s0)
    1c00:	00005097          	auipc	ra,0x5
    1c04:	aa4080e7          	jalr	-1372(ra) # 66a4 <close>
    total = 0;
    1c08:	8a26                	mv	s4,s1
    cc = 1;
    1c0a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1c0c:	0000ca97          	auipc	s5,0xc
    1c10:	06ca8a93          	addi	s5,s5,108 # dc78 <buf>
      if(cc > sizeof(buf))
    1c14:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1c16:	864e                	mv	a2,s3
    1c18:	85d6                	mv	a1,s5
    1c1a:	fa842503          	lw	a0,-88(s0)
    1c1e:	00005097          	auipc	ra,0x5
    1c22:	a76080e7          	jalr	-1418(ra) # 6694 <read>
    1c26:	10a05e63          	blez	a0,1d42 <pipe1+0x17e>
      for(i = 0; i < n; i++){
    1c2a:	0000c717          	auipc	a4,0xc
    1c2e:	04e70713          	addi	a4,a4,78 # dc78 <buf>
    1c32:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c36:	00074683          	lbu	a3,0(a4)
    1c3a:	0ff4f793          	andi	a5,s1,255
    1c3e:	2485                	addiw	s1,s1,1
    1c40:	0cf69d63          	bne	a3,a5,1d1a <pipe1+0x156>
      for(i = 0; i < n; i++){
    1c44:	0705                	addi	a4,a4,1
    1c46:	fec498e3          	bne	s1,a2,1c36 <pipe1+0x72>
      total += n;
    1c4a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1c4e:	0019979b          	slliw	a5,s3,0x1
    1c52:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1c56:	013b7363          	bgeu	s6,s3,1c5c <pipe1+0x98>
        cc = sizeof(buf);
    1c5a:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c5c:	84b2                	mv	s1,a2
    1c5e:	bf65                	j	1c16 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1c60:	85ca                	mv	a1,s2
    1c62:	00006517          	auipc	a0,0x6
    1c66:	93650513          	addi	a0,a0,-1738 # 7598 <malloc+0xad6>
    1c6a:	00005097          	auipc	ra,0x5
    1c6e:	d9a080e7          	jalr	-614(ra) # 6a04 <printf>
    exit(1,"");
    1c72:	00006597          	auipc	a1,0x6
    1c76:	58658593          	addi	a1,a1,1414 # 81f8 <malloc+0x1736>
    1c7a:	4505                	li	a0,1
    1c7c:	00005097          	auipc	ra,0x5
    1c80:	a00080e7          	jalr	-1536(ra) # 667c <exit>
    close(fds[0]);
    1c84:	fa842503          	lw	a0,-88(s0)
    1c88:	00005097          	auipc	ra,0x5
    1c8c:	a1c080e7          	jalr	-1508(ra) # 66a4 <close>
    for(n = 0; n < N; n++){
    1c90:	0000cb17          	auipc	s6,0xc
    1c94:	fe8b0b13          	addi	s6,s6,-24 # dc78 <buf>
    1c98:	416004bb          	negw	s1,s6
    1c9c:	0ff4f493          	andi	s1,s1,255
    1ca0:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1ca4:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1ca6:	6a85                	lui	s5,0x1
    1ca8:	42da8a93          	addi	s5,s5,1069 # 142d <bigdir+0xc5>
{
    1cac:	87da                	mv	a5,s6
        buf[i] = seq++;
    1cae:	0097873b          	addw	a4,a5,s1
    1cb2:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1cb6:	0785                	addi	a5,a5,1
    1cb8:	fef99be3          	bne	s3,a5,1cae <pipe1+0xea>
        buf[i] = seq++;
    1cbc:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1cc0:	40900613          	li	a2,1033
    1cc4:	85de                	mv	a1,s7
    1cc6:	fac42503          	lw	a0,-84(s0)
    1cca:	00005097          	auipc	ra,0x5
    1cce:	9d2080e7          	jalr	-1582(ra) # 669c <write>
    1cd2:	40900793          	li	a5,1033
    1cd6:	02f51063          	bne	a0,a5,1cf6 <pipe1+0x132>
    for(n = 0; n < N; n++){
    1cda:	24a5                	addiw	s1,s1,9
    1cdc:	0ff4f493          	andi	s1,s1,255
    1ce0:	fd5a16e3          	bne	s4,s5,1cac <pipe1+0xe8>
    exit(0,"");
    1ce4:	00006597          	auipc	a1,0x6
    1ce8:	51458593          	addi	a1,a1,1300 # 81f8 <malloc+0x1736>
    1cec:	4501                	li	a0,0
    1cee:	00005097          	auipc	ra,0x5
    1cf2:	98e080e7          	jalr	-1650(ra) # 667c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1cf6:	85ca                	mv	a1,s2
    1cf8:	00006517          	auipc	a0,0x6
    1cfc:	8b850513          	addi	a0,a0,-1864 # 75b0 <malloc+0xaee>
    1d00:	00005097          	auipc	ra,0x5
    1d04:	d04080e7          	jalr	-764(ra) # 6a04 <printf>
        exit(1,"");
    1d08:	00006597          	auipc	a1,0x6
    1d0c:	4f058593          	addi	a1,a1,1264 # 81f8 <malloc+0x1736>
    1d10:	4505                	li	a0,1
    1d12:	00005097          	auipc	ra,0x5
    1d16:	96a080e7          	jalr	-1686(ra) # 667c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1d1a:	85ca                	mv	a1,s2
    1d1c:	00006517          	auipc	a0,0x6
    1d20:	8ac50513          	addi	a0,a0,-1876 # 75c8 <malloc+0xb06>
    1d24:	00005097          	auipc	ra,0x5
    1d28:	ce0080e7          	jalr	-800(ra) # 6a04 <printf>
}
    1d2c:	60e6                	ld	ra,88(sp)
    1d2e:	6446                	ld	s0,80(sp)
    1d30:	64a6                	ld	s1,72(sp)
    1d32:	6906                	ld	s2,64(sp)
    1d34:	79e2                	ld	s3,56(sp)
    1d36:	7a42                	ld	s4,48(sp)
    1d38:	7aa2                	ld	s5,40(sp)
    1d3a:	7b02                	ld	s6,32(sp)
    1d3c:	6be2                	ld	s7,24(sp)
    1d3e:	6125                	addi	sp,sp,96
    1d40:	8082                	ret
    if(total != N * SZ){
    1d42:	6785                	lui	a5,0x1
    1d44:	42d78793          	addi	a5,a5,1069 # 142d <bigdir+0xc5>
    1d48:	02fa0463          	beq	s4,a5,1d70 <pipe1+0x1ac>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1d4c:	85d2                	mv	a1,s4
    1d4e:	00006517          	auipc	a0,0x6
    1d52:	89250513          	addi	a0,a0,-1902 # 75e0 <malloc+0xb1e>
    1d56:	00005097          	auipc	ra,0x5
    1d5a:	cae080e7          	jalr	-850(ra) # 6a04 <printf>
      exit(1,"");
    1d5e:	00006597          	auipc	a1,0x6
    1d62:	49a58593          	addi	a1,a1,1178 # 81f8 <malloc+0x1736>
    1d66:	4505                	li	a0,1
    1d68:	00005097          	auipc	ra,0x5
    1d6c:	914080e7          	jalr	-1772(ra) # 667c <exit>
    close(fds[0]);
    1d70:	fa842503          	lw	a0,-88(s0)
    1d74:	00005097          	auipc	ra,0x5
    1d78:	930080e7          	jalr	-1744(ra) # 66a4 <close>
    wait(&xstatus,0);
    1d7c:	4581                	li	a1,0
    1d7e:	fa440513          	addi	a0,s0,-92
    1d82:	00005097          	auipc	ra,0x5
    1d86:	902080e7          	jalr	-1790(ra) # 6684 <wait>
    exit(xstatus,"");
    1d8a:	00006597          	auipc	a1,0x6
    1d8e:	46e58593          	addi	a1,a1,1134 # 81f8 <malloc+0x1736>
    1d92:	fa442503          	lw	a0,-92(s0)
    1d96:	00005097          	auipc	ra,0x5
    1d9a:	8e6080e7          	jalr	-1818(ra) # 667c <exit>
    printf("%s: fork() failed\n", s);
    1d9e:	85ca                	mv	a1,s2
    1da0:	00006517          	auipc	a0,0x6
    1da4:	86050513          	addi	a0,a0,-1952 # 7600 <malloc+0xb3e>
    1da8:	00005097          	auipc	ra,0x5
    1dac:	c5c080e7          	jalr	-932(ra) # 6a04 <printf>
    exit(1,"");
    1db0:	00006597          	auipc	a1,0x6
    1db4:	44858593          	addi	a1,a1,1096 # 81f8 <malloc+0x1736>
    1db8:	4505                	li	a0,1
    1dba:	00005097          	auipc	ra,0x5
    1dbe:	8c2080e7          	jalr	-1854(ra) # 667c <exit>

0000000000001dc2 <exitwait>:
{
    1dc2:	7139                	addi	sp,sp,-64
    1dc4:	fc06                	sd	ra,56(sp)
    1dc6:	f822                	sd	s0,48(sp)
    1dc8:	f426                	sd	s1,40(sp)
    1dca:	f04a                	sd	s2,32(sp)
    1dcc:	ec4e                	sd	s3,24(sp)
    1dce:	e852                	sd	s4,16(sp)
    1dd0:	0080                	addi	s0,sp,64
    1dd2:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1dd4:	4901                	li	s2,0
    1dd6:	06400993          	li	s3,100
    pid = fork();
    1dda:	00005097          	auipc	ra,0x5
    1dde:	89a080e7          	jalr	-1894(ra) # 6674 <fork>
    1de2:	84aa                	mv	s1,a0
    if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <exitwait+0x58>
    if(pid){
    1de8:	cd59                	beqz	a0,1e86 <exitwait+0xc4>
      if(wait(&xstate,0) != pid){
    1dea:	4581                	li	a1,0
    1dec:	fcc40513          	addi	a0,s0,-52
    1df0:	00005097          	auipc	ra,0x5
    1df4:	894080e7          	jalr	-1900(ra) # 6684 <wait>
    1df8:	04951363          	bne	a0,s1,1e3e <exitwait+0x7c>
      if(i != xstate) {
    1dfc:	fcc42783          	lw	a5,-52(s0)
    1e00:	07279163          	bne	a5,s2,1e62 <exitwait+0xa0>
  for(i = 0; i < 100; i++){
    1e04:	2905                	addiw	s2,s2,1
    1e06:	fd391ae3          	bne	s2,s3,1dda <exitwait+0x18>
}
    1e0a:	70e2                	ld	ra,56(sp)
    1e0c:	7442                	ld	s0,48(sp)
    1e0e:	74a2                	ld	s1,40(sp)
    1e10:	7902                	ld	s2,32(sp)
    1e12:	69e2                	ld	s3,24(sp)
    1e14:	6a42                	ld	s4,16(sp)
    1e16:	6121                	addi	sp,sp,64
    1e18:	8082                	ret
      printf("%s: fork failed\n", s);
    1e1a:	85d2                	mv	a1,s4
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	67450513          	addi	a0,a0,1652 # 7490 <malloc+0x9ce>
    1e24:	00005097          	auipc	ra,0x5
    1e28:	be0080e7          	jalr	-1056(ra) # 6a04 <printf>
      exit(1,"");
    1e2c:	00006597          	auipc	a1,0x6
    1e30:	3cc58593          	addi	a1,a1,972 # 81f8 <malloc+0x1736>
    1e34:	4505                	li	a0,1
    1e36:	00005097          	auipc	ra,0x5
    1e3a:	846080e7          	jalr	-1978(ra) # 667c <exit>
        printf("%s: wait wrong pid\n", s);
    1e3e:	85d2                	mv	a1,s4
    1e40:	00005517          	auipc	a0,0x5
    1e44:	7d850513          	addi	a0,a0,2008 # 7618 <malloc+0xb56>
    1e48:	00005097          	auipc	ra,0x5
    1e4c:	bbc080e7          	jalr	-1092(ra) # 6a04 <printf>
        exit(1,"");
    1e50:	00006597          	auipc	a1,0x6
    1e54:	3a858593          	addi	a1,a1,936 # 81f8 <malloc+0x1736>
    1e58:	4505                	li	a0,1
    1e5a:	00005097          	auipc	ra,0x5
    1e5e:	822080e7          	jalr	-2014(ra) # 667c <exit>
        printf("%s: wait wrong exit status\n", s);
    1e62:	85d2                	mv	a1,s4
    1e64:	00005517          	auipc	a0,0x5
    1e68:	7cc50513          	addi	a0,a0,1996 # 7630 <malloc+0xb6e>
    1e6c:	00005097          	auipc	ra,0x5
    1e70:	b98080e7          	jalr	-1128(ra) # 6a04 <printf>
        exit(1,"");
    1e74:	00006597          	auipc	a1,0x6
    1e78:	38458593          	addi	a1,a1,900 # 81f8 <malloc+0x1736>
    1e7c:	4505                	li	a0,1
    1e7e:	00004097          	auipc	ra,0x4
    1e82:	7fe080e7          	jalr	2046(ra) # 667c <exit>
      exit(i,0);
    1e86:	4581                	li	a1,0
    1e88:	854a                	mv	a0,s2
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	7f2080e7          	jalr	2034(ra) # 667c <exit>

0000000000001e92 <twochildren>:
{
    1e92:	1101                	addi	sp,sp,-32
    1e94:	ec06                	sd	ra,24(sp)
    1e96:	e822                	sd	s0,16(sp)
    1e98:	e426                	sd	s1,8(sp)
    1e9a:	e04a                	sd	s2,0(sp)
    1e9c:	1000                	addi	s0,sp,32
    1e9e:	892a                	mv	s2,a0
    1ea0:	3e800493          	li	s1,1000
    int pid1 = fork();
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	7d0080e7          	jalr	2000(ra) # 6674 <fork>
    if(pid1 < 0){
    1eac:	02054e63          	bltz	a0,1ee8 <twochildren+0x56>
    if(pid1 == 0){
    1eb0:	cd31                	beqz	a0,1f0c <twochildren+0x7a>
      int pid2 = fork();
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	7c2080e7          	jalr	1986(ra) # 6674 <fork>
      if(pid2 < 0){
    1eba:	06054163          	bltz	a0,1f1c <twochildren+0x8a>
      if(pid2 == 0){
    1ebe:	c149                	beqz	a0,1f40 <twochildren+0xae>
        wait(0,0);
    1ec0:	4581                	li	a1,0
    1ec2:	4501                	li	a0,0
    1ec4:	00004097          	auipc	ra,0x4
    1ec8:	7c0080e7          	jalr	1984(ra) # 6684 <wait>
        wait(0,0);
    1ecc:	4581                	li	a1,0
    1ece:	4501                	li	a0,0
    1ed0:	00004097          	auipc	ra,0x4
    1ed4:	7b4080e7          	jalr	1972(ra) # 6684 <wait>
  for(int i = 0; i < 1000; i++){
    1ed8:	34fd                	addiw	s1,s1,-1
    1eda:	f4e9                	bnez	s1,1ea4 <twochildren+0x12>
}
    1edc:	60e2                	ld	ra,24(sp)
    1ede:	6442                	ld	s0,16(sp)
    1ee0:	64a2                	ld	s1,8(sp)
    1ee2:	6902                	ld	s2,0(sp)
    1ee4:	6105                	addi	sp,sp,32
    1ee6:	8082                	ret
      printf("%s: fork failed\n", s);
    1ee8:	85ca                	mv	a1,s2
    1eea:	00005517          	auipc	a0,0x5
    1eee:	5a650513          	addi	a0,a0,1446 # 7490 <malloc+0x9ce>
    1ef2:	00005097          	auipc	ra,0x5
    1ef6:	b12080e7          	jalr	-1262(ra) # 6a04 <printf>
      exit(1,"");
    1efa:	00006597          	auipc	a1,0x6
    1efe:	2fe58593          	addi	a1,a1,766 # 81f8 <malloc+0x1736>
    1f02:	4505                	li	a0,1
    1f04:	00004097          	auipc	ra,0x4
    1f08:	778080e7          	jalr	1912(ra) # 667c <exit>
      exit(0,"");
    1f0c:	00006597          	auipc	a1,0x6
    1f10:	2ec58593          	addi	a1,a1,748 # 81f8 <malloc+0x1736>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	768080e7          	jalr	1896(ra) # 667c <exit>
        printf("%s: fork failed\n", s);
    1f1c:	85ca                	mv	a1,s2
    1f1e:	00005517          	auipc	a0,0x5
    1f22:	57250513          	addi	a0,a0,1394 # 7490 <malloc+0x9ce>
    1f26:	00005097          	auipc	ra,0x5
    1f2a:	ade080e7          	jalr	-1314(ra) # 6a04 <printf>
        exit(1,"");
    1f2e:	00006597          	auipc	a1,0x6
    1f32:	2ca58593          	addi	a1,a1,714 # 81f8 <malloc+0x1736>
    1f36:	4505                	li	a0,1
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	744080e7          	jalr	1860(ra) # 667c <exit>
        exit(0,"");
    1f40:	00006597          	auipc	a1,0x6
    1f44:	2b858593          	addi	a1,a1,696 # 81f8 <malloc+0x1736>
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	734080e7          	jalr	1844(ra) # 667c <exit>

0000000000001f50 <forkfork>:
{
    1f50:	7179                	addi	sp,sp,-48
    1f52:	f406                	sd	ra,40(sp)
    1f54:	f022                	sd	s0,32(sp)
    1f56:	ec26                	sd	s1,24(sp)
    1f58:	1800                	addi	s0,sp,48
    1f5a:	84aa                	mv	s1,a0
    int pid = fork();
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	718080e7          	jalr	1816(ra) # 6674 <fork>
    if(pid < 0){
    1f64:	04054363          	bltz	a0,1faa <forkfork+0x5a>
    if(pid == 0){
    1f68:	c13d                	beqz	a0,1fce <forkfork+0x7e>
    int pid = fork();
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	70a080e7          	jalr	1802(ra) # 6674 <fork>
    if(pid < 0){
    1f72:	02054c63          	bltz	a0,1faa <forkfork+0x5a>
    if(pid == 0){
    1f76:	cd21                	beqz	a0,1fce <forkfork+0x7e>
    wait(&xstatus,0);
    1f78:	4581                	li	a1,0
    1f7a:	fdc40513          	addi	a0,s0,-36
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	706080e7          	jalr	1798(ra) # 6684 <wait>
    if(xstatus != 0) {
    1f86:	fdc42783          	lw	a5,-36(s0)
    1f8a:	efc9                	bnez	a5,2024 <forkfork+0xd4>
    wait(&xstatus,0);
    1f8c:	4581                	li	a1,0
    1f8e:	fdc40513          	addi	a0,s0,-36
    1f92:	00004097          	auipc	ra,0x4
    1f96:	6f2080e7          	jalr	1778(ra) # 6684 <wait>
    if(xstatus != 0) {
    1f9a:	fdc42783          	lw	a5,-36(s0)
    1f9e:	e3d9                	bnez	a5,2024 <forkfork+0xd4>
}
    1fa0:	70a2                	ld	ra,40(sp)
    1fa2:	7402                	ld	s0,32(sp)
    1fa4:	64e2                	ld	s1,24(sp)
    1fa6:	6145                	addi	sp,sp,48
    1fa8:	8082                	ret
      printf("%s: fork failed", s);
    1faa:	85a6                	mv	a1,s1
    1fac:	00005517          	auipc	a0,0x5
    1fb0:	6a450513          	addi	a0,a0,1700 # 7650 <malloc+0xb8e>
    1fb4:	00005097          	auipc	ra,0x5
    1fb8:	a50080e7          	jalr	-1456(ra) # 6a04 <printf>
      exit(1,"");
    1fbc:	00006597          	auipc	a1,0x6
    1fc0:	23c58593          	addi	a1,a1,572 # 81f8 <malloc+0x1736>
    1fc4:	4505                	li	a0,1
    1fc6:	00004097          	auipc	ra,0x4
    1fca:	6b6080e7          	jalr	1718(ra) # 667c <exit>
{
    1fce:	0c800493          	li	s1,200
        int pid1 = fork();
    1fd2:	00004097          	auipc	ra,0x4
    1fd6:	6a2080e7          	jalr	1698(ra) # 6674 <fork>
        if(pid1 < 0){
    1fda:	02054463          	bltz	a0,2002 <forkfork+0xb2>
        if(pid1 == 0){
    1fde:	c91d                	beqz	a0,2014 <forkfork+0xc4>
        wait(0,0);
    1fe0:	4581                	li	a1,0
    1fe2:	4501                	li	a0,0
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	6a0080e7          	jalr	1696(ra) # 6684 <wait>
      for(int j = 0; j < 200; j++){
    1fec:	34fd                	addiw	s1,s1,-1
    1fee:	f0f5                	bnez	s1,1fd2 <forkfork+0x82>
      exit(0,"");
    1ff0:	00006597          	auipc	a1,0x6
    1ff4:	20858593          	addi	a1,a1,520 # 81f8 <malloc+0x1736>
    1ff8:	4501                	li	a0,0
    1ffa:	00004097          	auipc	ra,0x4
    1ffe:	682080e7          	jalr	1666(ra) # 667c <exit>
          exit(1,"");
    2002:	00006597          	auipc	a1,0x6
    2006:	1f658593          	addi	a1,a1,502 # 81f8 <malloc+0x1736>
    200a:	4505                	li	a0,1
    200c:	00004097          	auipc	ra,0x4
    2010:	670080e7          	jalr	1648(ra) # 667c <exit>
          exit(0,"");
    2014:	00006597          	auipc	a1,0x6
    2018:	1e458593          	addi	a1,a1,484 # 81f8 <malloc+0x1736>
    201c:	00004097          	auipc	ra,0x4
    2020:	660080e7          	jalr	1632(ra) # 667c <exit>
      printf("%s: fork in child failed", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	63a50513          	addi	a0,a0,1594 # 7660 <malloc+0xb9e>
    202e:	00005097          	auipc	ra,0x5
    2032:	9d6080e7          	jalr	-1578(ra) # 6a04 <printf>
      exit(1,"");
    2036:	00006597          	auipc	a1,0x6
    203a:	1c258593          	addi	a1,a1,450 # 81f8 <malloc+0x1736>
    203e:	4505                	li	a0,1
    2040:	00004097          	auipc	ra,0x4
    2044:	63c080e7          	jalr	1596(ra) # 667c <exit>

0000000000002048 <reparent2>:
{
    2048:	1101                	addi	sp,sp,-32
    204a:	ec06                	sd	ra,24(sp)
    204c:	e822                	sd	s0,16(sp)
    204e:	e426                	sd	s1,8(sp)
    2050:	1000                	addi	s0,sp,32
    2052:	32000493          	li	s1,800
    int pid1 = fork();
    2056:	00004097          	auipc	ra,0x4
    205a:	61e080e7          	jalr	1566(ra) # 6674 <fork>
    if(pid1 < 0){
    205e:	02054463          	bltz	a0,2086 <reparent2+0x3e>
    if(pid1 == 0){
    2062:	c139                	beqz	a0,20a8 <reparent2+0x60>
    wait(0,0);
    2064:	4581                	li	a1,0
    2066:	4501                	li	a0,0
    2068:	00004097          	auipc	ra,0x4
    206c:	61c080e7          	jalr	1564(ra) # 6684 <wait>
  for(int i = 0; i < 800; i++){
    2070:	34fd                	addiw	s1,s1,-1
    2072:	f0f5                	bnez	s1,2056 <reparent2+0xe>
  exit(0,"");
    2074:	00006597          	auipc	a1,0x6
    2078:	18458593          	addi	a1,a1,388 # 81f8 <malloc+0x1736>
    207c:	4501                	li	a0,0
    207e:	00004097          	auipc	ra,0x4
    2082:	5fe080e7          	jalr	1534(ra) # 667c <exit>
      printf("fork failed\n");
    2086:	00006517          	auipc	a0,0x6
    208a:	81250513          	addi	a0,a0,-2030 # 7898 <malloc+0xdd6>
    208e:	00005097          	auipc	ra,0x5
    2092:	976080e7          	jalr	-1674(ra) # 6a04 <printf>
      exit(1,"");
    2096:	00006597          	auipc	a1,0x6
    209a:	16258593          	addi	a1,a1,354 # 81f8 <malloc+0x1736>
    209e:	4505                	li	a0,1
    20a0:	00004097          	auipc	ra,0x4
    20a4:	5dc080e7          	jalr	1500(ra) # 667c <exit>
      fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	5cc080e7          	jalr	1484(ra) # 6674 <fork>
      fork();
    20b0:	00004097          	auipc	ra,0x4
    20b4:	5c4080e7          	jalr	1476(ra) # 6674 <fork>
      exit(0,"");
    20b8:	00006597          	auipc	a1,0x6
    20bc:	14058593          	addi	a1,a1,320 # 81f8 <malloc+0x1736>
    20c0:	4501                	li	a0,0
    20c2:	00004097          	auipc	ra,0x4
    20c6:	5ba080e7          	jalr	1466(ra) # 667c <exit>

00000000000020ca <createdelete>:
{
    20ca:	7175                	addi	sp,sp,-144
    20cc:	e506                	sd	ra,136(sp)
    20ce:	e122                	sd	s0,128(sp)
    20d0:	fca6                	sd	s1,120(sp)
    20d2:	f8ca                	sd	s2,112(sp)
    20d4:	f4ce                	sd	s3,104(sp)
    20d6:	f0d2                	sd	s4,96(sp)
    20d8:	ecd6                	sd	s5,88(sp)
    20da:	e8da                	sd	s6,80(sp)
    20dc:	e4de                	sd	s7,72(sp)
    20de:	e0e2                	sd	s8,64(sp)
    20e0:	fc66                	sd	s9,56(sp)
    20e2:	0900                	addi	s0,sp,144
    20e4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    20e6:	4901                	li	s2,0
    20e8:	4991                	li	s3,4
    pid = fork();
    20ea:	00004097          	auipc	ra,0x4
    20ee:	58a080e7          	jalr	1418(ra) # 6674 <fork>
    20f2:	84aa                	mv	s1,a0
    if(pid < 0){
    20f4:	04054063          	bltz	a0,2134 <createdelete+0x6a>
    if(pid == 0){
    20f8:	c125                	beqz	a0,2158 <createdelete+0x8e>
  for(pi = 0; pi < NCHILD; pi++){
    20fa:	2905                	addiw	s2,s2,1
    20fc:	ff3917e3          	bne	s2,s3,20ea <createdelete+0x20>
    2100:	4491                	li	s1,4
    wait(&xstatus,0);
    2102:	4581                	li	a1,0
    2104:	f7c40513          	addi	a0,s0,-132
    2108:	00004097          	auipc	ra,0x4
    210c:	57c080e7          	jalr	1404(ra) # 6684 <wait>
    if(xstatus != 0)
    2110:	f7c42903          	lw	s2,-132(s0)
    2114:	10091263          	bnez	s2,2218 <createdelete+0x14e>
  for(pi = 0; pi < NCHILD; pi++){
    2118:	34fd                	addiw	s1,s1,-1
    211a:	f4e5                	bnez	s1,2102 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    211c:	f8040123          	sb	zero,-126(s0)
    2120:	03000993          	li	s3,48
    2124:	5a7d                	li	s4,-1
    2126:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    212a:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    212c:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    212e:	07400a93          	li	s5,116
    2132:	aa79                	j	22d0 <createdelete+0x206>
      printf("fork failed\n", s);
    2134:	85e6                	mv	a1,s9
    2136:	00005517          	auipc	a0,0x5
    213a:	76250513          	addi	a0,a0,1890 # 7898 <malloc+0xdd6>
    213e:	00005097          	auipc	ra,0x5
    2142:	8c6080e7          	jalr	-1850(ra) # 6a04 <printf>
      exit(1,"");
    2146:	00006597          	auipc	a1,0x6
    214a:	0b258593          	addi	a1,a1,178 # 81f8 <malloc+0x1736>
    214e:	4505                	li	a0,1
    2150:	00004097          	auipc	ra,0x4
    2154:	52c080e7          	jalr	1324(ra) # 667c <exit>
      name[0] = 'p' + pi;
    2158:	0709091b          	addiw	s2,s2,112
    215c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    2160:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    2164:	4951                	li	s2,20
    2166:	a035                	j	2192 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    2168:	85e6                	mv	a1,s9
    216a:	00005517          	auipc	a0,0x5
    216e:	3be50513          	addi	a0,a0,958 # 7528 <malloc+0xa66>
    2172:	00005097          	auipc	ra,0x5
    2176:	892080e7          	jalr	-1902(ra) # 6a04 <printf>
          exit(1,"");
    217a:	00006597          	auipc	a1,0x6
    217e:	07e58593          	addi	a1,a1,126 # 81f8 <malloc+0x1736>
    2182:	4505                	li	a0,1
    2184:	00004097          	auipc	ra,0x4
    2188:	4f8080e7          	jalr	1272(ra) # 667c <exit>
      for(i = 0; i < N; i++){
    218c:	2485                	addiw	s1,s1,1
    218e:	07248c63          	beq	s1,s2,2206 <createdelete+0x13c>
        name[1] = '0' + i;
    2192:	0304879b          	addiw	a5,s1,48
    2196:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    219a:	20200593          	li	a1,514
    219e:	f8040513          	addi	a0,s0,-128
    21a2:	00004097          	auipc	ra,0x4
    21a6:	51a080e7          	jalr	1306(ra) # 66bc <open>
        if(fd < 0){
    21aa:	fa054fe3          	bltz	a0,2168 <createdelete+0x9e>
        close(fd);
    21ae:	00004097          	auipc	ra,0x4
    21b2:	4f6080e7          	jalr	1270(ra) # 66a4 <close>
        if(i > 0 && (i % 2 ) == 0){
    21b6:	fc905be3          	blez	s1,218c <createdelete+0xc2>
    21ba:	0014f793          	andi	a5,s1,1
    21be:	f7f9                	bnez	a5,218c <createdelete+0xc2>
          name[1] = '0' + (i / 2);
    21c0:	01f4d79b          	srliw	a5,s1,0x1f
    21c4:	9fa5                	addw	a5,a5,s1
    21c6:	4017d79b          	sraiw	a5,a5,0x1
    21ca:	0307879b          	addiw	a5,a5,48
    21ce:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    21d2:	f8040513          	addi	a0,s0,-128
    21d6:	00004097          	auipc	ra,0x4
    21da:	4f6080e7          	jalr	1270(ra) # 66cc <unlink>
    21de:	fa0557e3          	bgez	a0,218c <createdelete+0xc2>
            printf("%s: unlink failed\n", s);
    21e2:	85e6                	mv	a1,s9
    21e4:	00005517          	auipc	a0,0x5
    21e8:	49c50513          	addi	a0,a0,1180 # 7680 <malloc+0xbbe>
    21ec:	00005097          	auipc	ra,0x5
    21f0:	818080e7          	jalr	-2024(ra) # 6a04 <printf>
            exit(1,"");
    21f4:	00006597          	auipc	a1,0x6
    21f8:	00458593          	addi	a1,a1,4 # 81f8 <malloc+0x1736>
    21fc:	4505                	li	a0,1
    21fe:	00004097          	auipc	ra,0x4
    2202:	47e080e7          	jalr	1150(ra) # 667c <exit>
      exit(0,"");
    2206:	00006597          	auipc	a1,0x6
    220a:	ff258593          	addi	a1,a1,-14 # 81f8 <malloc+0x1736>
    220e:	4501                	li	a0,0
    2210:	00004097          	auipc	ra,0x4
    2214:	46c080e7          	jalr	1132(ra) # 667c <exit>
      exit(1,"");
    2218:	00006597          	auipc	a1,0x6
    221c:	fe058593          	addi	a1,a1,-32 # 81f8 <malloc+0x1736>
    2220:	4505                	li	a0,1
    2222:	00004097          	auipc	ra,0x4
    2226:	45a080e7          	jalr	1114(ra) # 667c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    222a:	f8040613          	addi	a2,s0,-128
    222e:	85e6                	mv	a1,s9
    2230:	00005517          	auipc	a0,0x5
    2234:	46850513          	addi	a0,a0,1128 # 7698 <malloc+0xbd6>
    2238:	00004097          	auipc	ra,0x4
    223c:	7cc080e7          	jalr	1996(ra) # 6a04 <printf>
        exit(1,"");
    2240:	00006597          	auipc	a1,0x6
    2244:	fb858593          	addi	a1,a1,-72 # 81f8 <malloc+0x1736>
    2248:	4505                	li	a0,1
    224a:	00004097          	auipc	ra,0x4
    224e:	432080e7          	jalr	1074(ra) # 667c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2252:	054b7163          	bgeu	s6,s4,2294 <createdelete+0x1ca>
      if(fd >= 0)
    2256:	02055a63          	bgez	a0,228a <createdelete+0x1c0>
    for(pi = 0; pi < NCHILD; pi++){
    225a:	2485                	addiw	s1,s1,1
    225c:	0ff4f493          	andi	s1,s1,255
    2260:	07548063          	beq	s1,s5,22c0 <createdelete+0x1f6>
      name[0] = 'p' + pi;
    2264:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    2268:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    226c:	4581                	li	a1,0
    226e:	f8040513          	addi	a0,s0,-128
    2272:	00004097          	auipc	ra,0x4
    2276:	44a080e7          	jalr	1098(ra) # 66bc <open>
      if((i == 0 || i >= N/2) && fd < 0){
    227a:	00090463          	beqz	s2,2282 <createdelete+0x1b8>
    227e:	fd2bdae3          	bge	s7,s2,2252 <createdelete+0x188>
    2282:	fa0544e3          	bltz	a0,222a <createdelete+0x160>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2286:	014b7963          	bgeu	s6,s4,2298 <createdelete+0x1ce>
        close(fd);
    228a:	00004097          	auipc	ra,0x4
    228e:	41a080e7          	jalr	1050(ra) # 66a4 <close>
    2292:	b7e1                	j	225a <createdelete+0x190>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2294:	fc0543e3          	bltz	a0,225a <createdelete+0x190>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2298:	f8040613          	addi	a2,s0,-128
    229c:	85e6                	mv	a1,s9
    229e:	00005517          	auipc	a0,0x5
    22a2:	42250513          	addi	a0,a0,1058 # 76c0 <malloc+0xbfe>
    22a6:	00004097          	auipc	ra,0x4
    22aa:	75e080e7          	jalr	1886(ra) # 6a04 <printf>
        exit(1,"");
    22ae:	00006597          	auipc	a1,0x6
    22b2:	f4a58593          	addi	a1,a1,-182 # 81f8 <malloc+0x1736>
    22b6:	4505                	li	a0,1
    22b8:	00004097          	auipc	ra,0x4
    22bc:	3c4080e7          	jalr	964(ra) # 667c <exit>
  for(i = 0; i < N; i++){
    22c0:	2905                	addiw	s2,s2,1
    22c2:	2a05                	addiw	s4,s4,1
    22c4:	2985                	addiw	s3,s3,1
    22c6:	0ff9f993          	andi	s3,s3,255
    22ca:	47d1                	li	a5,20
    22cc:	02f90a63          	beq	s2,a5,2300 <createdelete+0x236>
    for(pi = 0; pi < NCHILD; pi++){
    22d0:	84e2                	mv	s1,s8
    22d2:	bf49                	j	2264 <createdelete+0x19a>
  for(i = 0; i < N; i++){
    22d4:	2905                	addiw	s2,s2,1
    22d6:	0ff97913          	andi	s2,s2,255
    22da:	2985                	addiw	s3,s3,1
    22dc:	0ff9f993          	andi	s3,s3,255
    22e0:	03490863          	beq	s2,s4,2310 <createdelete+0x246>
  name[0] = name[1] = name[2] = 0;
    22e4:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    22e6:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    22ea:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    22ee:	f8040513          	addi	a0,s0,-128
    22f2:	00004097          	auipc	ra,0x4
    22f6:	3da080e7          	jalr	986(ra) # 66cc <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    22fa:	34fd                	addiw	s1,s1,-1
    22fc:	f4ed                	bnez	s1,22e6 <createdelete+0x21c>
    22fe:	bfd9                	j	22d4 <createdelete+0x20a>
    2300:	03000993          	li	s3,48
    2304:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    2308:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    230a:	08400a13          	li	s4,132
    230e:	bfd9                	j	22e4 <createdelete+0x21a>
}
    2310:	60aa                	ld	ra,136(sp)
    2312:	640a                	ld	s0,128(sp)
    2314:	74e6                	ld	s1,120(sp)
    2316:	7946                	ld	s2,112(sp)
    2318:	79a6                	ld	s3,104(sp)
    231a:	7a06                	ld	s4,96(sp)
    231c:	6ae6                	ld	s5,88(sp)
    231e:	6b46                	ld	s6,80(sp)
    2320:	6ba6                	ld	s7,72(sp)
    2322:	6c06                	ld	s8,64(sp)
    2324:	7ce2                	ld	s9,56(sp)
    2326:	6149                	addi	sp,sp,144
    2328:	8082                	ret

000000000000232a <linkunlink>:
{
    232a:	711d                	addi	sp,sp,-96
    232c:	ec86                	sd	ra,88(sp)
    232e:	e8a2                	sd	s0,80(sp)
    2330:	e4a6                	sd	s1,72(sp)
    2332:	e0ca                	sd	s2,64(sp)
    2334:	fc4e                	sd	s3,56(sp)
    2336:	f852                	sd	s4,48(sp)
    2338:	f456                	sd	s5,40(sp)
    233a:	f05a                	sd	s6,32(sp)
    233c:	ec5e                	sd	s7,24(sp)
    233e:	e862                	sd	s8,16(sp)
    2340:	e466                	sd	s9,8(sp)
    2342:	1080                	addi	s0,sp,96
    2344:	84aa                	mv	s1,a0
  unlink("x");
    2346:	00005517          	auipc	a0,0x5
    234a:	93250513          	addi	a0,a0,-1742 # 6c78 <malloc+0x1b6>
    234e:	00004097          	auipc	ra,0x4
    2352:	37e080e7          	jalr	894(ra) # 66cc <unlink>
  pid = fork();
    2356:	00004097          	auipc	ra,0x4
    235a:	31e080e7          	jalr	798(ra) # 6674 <fork>
  if(pid < 0){
    235e:	02054b63          	bltz	a0,2394 <linkunlink+0x6a>
    2362:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    2364:	4c85                	li	s9,1
    2366:	e119                	bnez	a0,236c <linkunlink+0x42>
    2368:	06100c93          	li	s9,97
    236c:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2370:	41c659b7          	lui	s3,0x41c65
    2374:	e6d9899b          	addiw	s3,s3,-403
    2378:	690d                	lui	s2,0x3
    237a:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    237e:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    2380:	4b05                	li	s6,1
      unlink("x");
    2382:	00005a97          	auipc	s5,0x5
    2386:	8f6a8a93          	addi	s5,s5,-1802 # 6c78 <malloc+0x1b6>
      link("cat", "x");
    238a:	00005b97          	auipc	s7,0x5
    238e:	35eb8b93          	addi	s7,s7,862 # 76e8 <malloc+0xc26>
    2392:	a081                	j	23d2 <linkunlink+0xa8>
    printf("%s: fork failed\n", s);
    2394:	85a6                	mv	a1,s1
    2396:	00005517          	auipc	a0,0x5
    239a:	0fa50513          	addi	a0,a0,250 # 7490 <malloc+0x9ce>
    239e:	00004097          	auipc	ra,0x4
    23a2:	666080e7          	jalr	1638(ra) # 6a04 <printf>
    exit(1,"");
    23a6:	00006597          	auipc	a1,0x6
    23aa:	e5258593          	addi	a1,a1,-430 # 81f8 <malloc+0x1736>
    23ae:	4505                	li	a0,1
    23b0:	00004097          	auipc	ra,0x4
    23b4:	2cc080e7          	jalr	716(ra) # 667c <exit>
      close(open("x", O_RDWR | O_CREATE));
    23b8:	20200593          	li	a1,514
    23bc:	8556                	mv	a0,s5
    23be:	00004097          	auipc	ra,0x4
    23c2:	2fe080e7          	jalr	766(ra) # 66bc <open>
    23c6:	00004097          	auipc	ra,0x4
    23ca:	2de080e7          	jalr	734(ra) # 66a4 <close>
  for(i = 0; i < 100; i++){
    23ce:	34fd                	addiw	s1,s1,-1
    23d0:	c88d                	beqz	s1,2402 <linkunlink+0xd8>
    x = x * 1103515245 + 12345;
    23d2:	033c87bb          	mulw	a5,s9,s3
    23d6:	012787bb          	addw	a5,a5,s2
    23da:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    23de:	0347f7bb          	remuw	a5,a5,s4
    23e2:	dbf9                	beqz	a5,23b8 <linkunlink+0x8e>
    } else if((x % 3) == 1){
    23e4:	01678863          	beq	a5,s6,23f4 <linkunlink+0xca>
      unlink("x");
    23e8:	8556                	mv	a0,s5
    23ea:	00004097          	auipc	ra,0x4
    23ee:	2e2080e7          	jalr	738(ra) # 66cc <unlink>
    23f2:	bff1                	j	23ce <linkunlink+0xa4>
      link("cat", "x");
    23f4:	85d6                	mv	a1,s5
    23f6:	855e                	mv	a0,s7
    23f8:	00004097          	auipc	ra,0x4
    23fc:	2e4080e7          	jalr	740(ra) # 66dc <link>
    2400:	b7f9                	j	23ce <linkunlink+0xa4>
  if(pid)
    2402:	020c0563          	beqz	s8,242c <linkunlink+0x102>
    wait(0,0);
    2406:	4581                	li	a1,0
    2408:	4501                	li	a0,0
    240a:	00004097          	auipc	ra,0x4
    240e:	27a080e7          	jalr	634(ra) # 6684 <wait>
}
    2412:	60e6                	ld	ra,88(sp)
    2414:	6446                	ld	s0,80(sp)
    2416:	64a6                	ld	s1,72(sp)
    2418:	6906                	ld	s2,64(sp)
    241a:	79e2                	ld	s3,56(sp)
    241c:	7a42                	ld	s4,48(sp)
    241e:	7aa2                	ld	s5,40(sp)
    2420:	7b02                	ld	s6,32(sp)
    2422:	6be2                	ld	s7,24(sp)
    2424:	6c42                	ld	s8,16(sp)
    2426:	6ca2                	ld	s9,8(sp)
    2428:	6125                	addi	sp,sp,96
    242a:	8082                	ret
    exit(0,"");
    242c:	00006597          	auipc	a1,0x6
    2430:	dcc58593          	addi	a1,a1,-564 # 81f8 <malloc+0x1736>
    2434:	4501                	li	a0,0
    2436:	00004097          	auipc	ra,0x4
    243a:	246080e7          	jalr	582(ra) # 667c <exit>

000000000000243e <forktest>:
{
    243e:	7179                	addi	sp,sp,-48
    2440:	f406                	sd	ra,40(sp)
    2442:	f022                	sd	s0,32(sp)
    2444:	ec26                	sd	s1,24(sp)
    2446:	e84a                	sd	s2,16(sp)
    2448:	e44e                	sd	s3,8(sp)
    244a:	1800                	addi	s0,sp,48
    244c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    244e:	4481                	li	s1,0
    2450:	3e800913          	li	s2,1000
    pid = fork();
    2454:	00004097          	auipc	ra,0x4
    2458:	220080e7          	jalr	544(ra) # 6674 <fork>
    if(pid < 0)
    245c:	04054063          	bltz	a0,249c <forktest+0x5e>
    if(pid == 0)
    2460:	c515                	beqz	a0,248c <forktest+0x4e>
  for(n=0; n<N; n++){
    2462:	2485                	addiw	s1,s1,1
    2464:	ff2498e3          	bne	s1,s2,2454 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2468:	85ce                	mv	a1,s3
    246a:	00005517          	auipc	a0,0x5
    246e:	29e50513          	addi	a0,a0,670 # 7708 <malloc+0xc46>
    2472:	00004097          	auipc	ra,0x4
    2476:	592080e7          	jalr	1426(ra) # 6a04 <printf>
    exit(1,"");
    247a:	00006597          	auipc	a1,0x6
    247e:	d7e58593          	addi	a1,a1,-642 # 81f8 <malloc+0x1736>
    2482:	4505                	li	a0,1
    2484:	00004097          	auipc	ra,0x4
    2488:	1f8080e7          	jalr	504(ra) # 667c <exit>
      exit(0,"");
    248c:	00006597          	auipc	a1,0x6
    2490:	d6c58593          	addi	a1,a1,-660 # 81f8 <malloc+0x1736>
    2494:	00004097          	auipc	ra,0x4
    2498:	1e8080e7          	jalr	488(ra) # 667c <exit>
  if (n == 0) {
    249c:	c0a9                	beqz	s1,24de <forktest+0xa0>
  if(n == N){
    249e:	3e800793          	li	a5,1000
    24a2:	fcf483e3          	beq	s1,a5,2468 <forktest+0x2a>
  for(; n > 0; n--){
    24a6:	00905c63          	blez	s1,24be <forktest+0x80>
    if(wait(0,0) < 0){
    24aa:	4581                	li	a1,0
    24ac:	4501                	li	a0,0
    24ae:	00004097          	auipc	ra,0x4
    24b2:	1d6080e7          	jalr	470(ra) # 6684 <wait>
    24b6:	04054663          	bltz	a0,2502 <forktest+0xc4>
  for(; n > 0; n--){
    24ba:	34fd                	addiw	s1,s1,-1
    24bc:	f4fd                	bnez	s1,24aa <forktest+0x6c>
  if(wait(0,0) != -1){
    24be:	4581                	li	a1,0
    24c0:	4501                	li	a0,0
    24c2:	00004097          	auipc	ra,0x4
    24c6:	1c2080e7          	jalr	450(ra) # 6684 <wait>
    24ca:	57fd                	li	a5,-1
    24cc:	04f51d63          	bne	a0,a5,2526 <forktest+0xe8>
}
    24d0:	70a2                	ld	ra,40(sp)
    24d2:	7402                	ld	s0,32(sp)
    24d4:	64e2                	ld	s1,24(sp)
    24d6:	6942                	ld	s2,16(sp)
    24d8:	69a2                	ld	s3,8(sp)
    24da:	6145                	addi	sp,sp,48
    24dc:	8082                	ret
    printf("%s: no fork at all!\n", s);
    24de:	85ce                	mv	a1,s3
    24e0:	00005517          	auipc	a0,0x5
    24e4:	21050513          	addi	a0,a0,528 # 76f0 <malloc+0xc2e>
    24e8:	00004097          	auipc	ra,0x4
    24ec:	51c080e7          	jalr	1308(ra) # 6a04 <printf>
    exit(1,"");
    24f0:	00006597          	auipc	a1,0x6
    24f4:	d0858593          	addi	a1,a1,-760 # 81f8 <malloc+0x1736>
    24f8:	4505                	li	a0,1
    24fa:	00004097          	auipc	ra,0x4
    24fe:	182080e7          	jalr	386(ra) # 667c <exit>
      printf("%s: wait stopped early\n", s);
    2502:	85ce                	mv	a1,s3
    2504:	00005517          	auipc	a0,0x5
    2508:	22c50513          	addi	a0,a0,556 # 7730 <malloc+0xc6e>
    250c:	00004097          	auipc	ra,0x4
    2510:	4f8080e7          	jalr	1272(ra) # 6a04 <printf>
      exit(1,"");
    2514:	00006597          	auipc	a1,0x6
    2518:	ce458593          	addi	a1,a1,-796 # 81f8 <malloc+0x1736>
    251c:	4505                	li	a0,1
    251e:	00004097          	auipc	ra,0x4
    2522:	15e080e7          	jalr	350(ra) # 667c <exit>
    printf("%s: wait got too many\n", s);
    2526:	85ce                	mv	a1,s3
    2528:	00005517          	auipc	a0,0x5
    252c:	22050513          	addi	a0,a0,544 # 7748 <malloc+0xc86>
    2530:	00004097          	auipc	ra,0x4
    2534:	4d4080e7          	jalr	1236(ra) # 6a04 <printf>
    exit(1,"");
    2538:	00006597          	auipc	a1,0x6
    253c:	cc058593          	addi	a1,a1,-832 # 81f8 <malloc+0x1736>
    2540:	4505                	li	a0,1
    2542:	00004097          	auipc	ra,0x4
    2546:	13a080e7          	jalr	314(ra) # 667c <exit>

000000000000254a <kernmem>:
{
    254a:	715d                	addi	sp,sp,-80
    254c:	e486                	sd	ra,72(sp)
    254e:	e0a2                	sd	s0,64(sp)
    2550:	fc26                	sd	s1,56(sp)
    2552:	f84a                	sd	s2,48(sp)
    2554:	f44e                	sd	s3,40(sp)
    2556:	f052                	sd	s4,32(sp)
    2558:	ec56                	sd	s5,24(sp)
    255a:	0880                	addi	s0,sp,80
    255c:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    255e:	4485                	li	s1,1
    2560:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2562:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2564:	69b1                	lui	s3,0xc
    2566:	35098993          	addi	s3,s3,848 # c350 <uninit+0xde8>
    256a:	1003d937          	lui	s2,0x1003d
    256e:	090e                	slli	s2,s2,0x3
    2570:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c808>
    pid = fork();
    2574:	00004097          	auipc	ra,0x4
    2578:	100080e7          	jalr	256(ra) # 6674 <fork>
    if(pid < 0){
    257c:	02054a63          	bltz	a0,25b0 <kernmem+0x66>
    if(pid == 0){
    2580:	c931                	beqz	a0,25d4 <kernmem+0x8a>
    wait(&xstatus,0);
    2582:	4581                	li	a1,0
    2584:	fbc40513          	addi	a0,s0,-68
    2588:	00004097          	auipc	ra,0x4
    258c:	0fc080e7          	jalr	252(ra) # 6684 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2590:	fbc42783          	lw	a5,-68(s0)
    2594:	07579563          	bne	a5,s5,25fe <kernmem+0xb4>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2598:	94ce                	add	s1,s1,s3
    259a:	fd249de3          	bne	s1,s2,2574 <kernmem+0x2a>
}
    259e:	60a6                	ld	ra,72(sp)
    25a0:	6406                	ld	s0,64(sp)
    25a2:	74e2                	ld	s1,56(sp)
    25a4:	7942                	ld	s2,48(sp)
    25a6:	79a2                	ld	s3,40(sp)
    25a8:	7a02                	ld	s4,32(sp)
    25aa:	6ae2                	ld	s5,24(sp)
    25ac:	6161                	addi	sp,sp,80
    25ae:	8082                	ret
      printf("%s: fork failed\n", s);
    25b0:	85d2                	mv	a1,s4
    25b2:	00005517          	auipc	a0,0x5
    25b6:	ede50513          	addi	a0,a0,-290 # 7490 <malloc+0x9ce>
    25ba:	00004097          	auipc	ra,0x4
    25be:	44a080e7          	jalr	1098(ra) # 6a04 <printf>
      exit(1,"");
    25c2:	00006597          	auipc	a1,0x6
    25c6:	c3658593          	addi	a1,a1,-970 # 81f8 <malloc+0x1736>
    25ca:	4505                	li	a0,1
    25cc:	00004097          	auipc	ra,0x4
    25d0:	0b0080e7          	jalr	176(ra) # 667c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    25d4:	0004c683          	lbu	a3,0(s1)
    25d8:	8626                	mv	a2,s1
    25da:	85d2                	mv	a1,s4
    25dc:	00005517          	auipc	a0,0x5
    25e0:	18450513          	addi	a0,a0,388 # 7760 <malloc+0xc9e>
    25e4:	00004097          	auipc	ra,0x4
    25e8:	420080e7          	jalr	1056(ra) # 6a04 <printf>
      exit(1,"");
    25ec:	00006597          	auipc	a1,0x6
    25f0:	c0c58593          	addi	a1,a1,-1012 # 81f8 <malloc+0x1736>
    25f4:	4505                	li	a0,1
    25f6:	00004097          	auipc	ra,0x4
    25fa:	086080e7          	jalr	134(ra) # 667c <exit>
      exit(1,"");
    25fe:	00006597          	auipc	a1,0x6
    2602:	bfa58593          	addi	a1,a1,-1030 # 81f8 <malloc+0x1736>
    2606:	4505                	li	a0,1
    2608:	00004097          	auipc	ra,0x4
    260c:	074080e7          	jalr	116(ra) # 667c <exit>

0000000000002610 <MAXVAplus>:
{
    2610:	7179                	addi	sp,sp,-48
    2612:	f406                	sd	ra,40(sp)
    2614:	f022                	sd	s0,32(sp)
    2616:	ec26                	sd	s1,24(sp)
    2618:	e84a                	sd	s2,16(sp)
    261a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    261c:	4785                	li	a5,1
    261e:	179a                	slli	a5,a5,0x26
    2620:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2624:	fd843783          	ld	a5,-40(s0)
    2628:	cf8d                	beqz	a5,2662 <MAXVAplus+0x52>
    262a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    262c:	54fd                	li	s1,-1
    pid = fork();
    262e:	00004097          	auipc	ra,0x4
    2632:	046080e7          	jalr	70(ra) # 6674 <fork>
    if(pid < 0){
    2636:	02054c63          	bltz	a0,266e <MAXVAplus+0x5e>
    if(pid == 0){
    263a:	cd21                	beqz	a0,2692 <MAXVAplus+0x82>
    wait(&xstatus,0);
    263c:	4581                	li	a1,0
    263e:	fd440513          	addi	a0,s0,-44
    2642:	00004097          	auipc	ra,0x4
    2646:	042080e7          	jalr	66(ra) # 6684 <wait>
    if(xstatus != -1)  // did kernel kill child?
    264a:	fd442783          	lw	a5,-44(s0)
    264e:	06979c63          	bne	a5,s1,26c6 <MAXVAplus+0xb6>
  for( ; a != 0; a <<= 1){
    2652:	fd843783          	ld	a5,-40(s0)
    2656:	0786                	slli	a5,a5,0x1
    2658:	fcf43c23          	sd	a5,-40(s0)
    265c:	fd843783          	ld	a5,-40(s0)
    2660:	f7f9                	bnez	a5,262e <MAXVAplus+0x1e>
}
    2662:	70a2                	ld	ra,40(sp)
    2664:	7402                	ld	s0,32(sp)
    2666:	64e2                	ld	s1,24(sp)
    2668:	6942                	ld	s2,16(sp)
    266a:	6145                	addi	sp,sp,48
    266c:	8082                	ret
      printf("%s: fork failed\n", s);
    266e:	85ca                	mv	a1,s2
    2670:	00005517          	auipc	a0,0x5
    2674:	e2050513          	addi	a0,a0,-480 # 7490 <malloc+0x9ce>
    2678:	00004097          	auipc	ra,0x4
    267c:	38c080e7          	jalr	908(ra) # 6a04 <printf>
      exit(1,"");
    2680:	00006597          	auipc	a1,0x6
    2684:	b7858593          	addi	a1,a1,-1160 # 81f8 <malloc+0x1736>
    2688:	4505                	li	a0,1
    268a:	00004097          	auipc	ra,0x4
    268e:	ff2080e7          	jalr	-14(ra) # 667c <exit>
      *(char*)a = 99;
    2692:	fd843783          	ld	a5,-40(s0)
    2696:	06300713          	li	a4,99
    269a:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    269e:	fd843603          	ld	a2,-40(s0)
    26a2:	85ca                	mv	a1,s2
    26a4:	00005517          	auipc	a0,0x5
    26a8:	0dc50513          	addi	a0,a0,220 # 7780 <malloc+0xcbe>
    26ac:	00004097          	auipc	ra,0x4
    26b0:	358080e7          	jalr	856(ra) # 6a04 <printf>
      exit(1,"");
    26b4:	00006597          	auipc	a1,0x6
    26b8:	b4458593          	addi	a1,a1,-1212 # 81f8 <malloc+0x1736>
    26bc:	4505                	li	a0,1
    26be:	00004097          	auipc	ra,0x4
    26c2:	fbe080e7          	jalr	-66(ra) # 667c <exit>
      exit(1,"");
    26c6:	00006597          	auipc	a1,0x6
    26ca:	b3258593          	addi	a1,a1,-1230 # 81f8 <malloc+0x1736>
    26ce:	4505                	li	a0,1
    26d0:	00004097          	auipc	ra,0x4
    26d4:	fac080e7          	jalr	-84(ra) # 667c <exit>

00000000000026d8 <bigargtest>:
{
    26d8:	7179                	addi	sp,sp,-48
    26da:	f406                	sd	ra,40(sp)
    26dc:	f022                	sd	s0,32(sp)
    26de:	ec26                	sd	s1,24(sp)
    26e0:	1800                	addi	s0,sp,48
    26e2:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    26e4:	00005517          	auipc	a0,0x5
    26e8:	0b450513          	addi	a0,a0,180 # 7798 <malloc+0xcd6>
    26ec:	00004097          	auipc	ra,0x4
    26f0:	fe0080e7          	jalr	-32(ra) # 66cc <unlink>
  pid = fork();
    26f4:	00004097          	auipc	ra,0x4
    26f8:	f80080e7          	jalr	-128(ra) # 6674 <fork>
  if(pid == 0){
    26fc:	c129                	beqz	a0,273e <bigargtest+0x66>
  } else if(pid < 0){
    26fe:	0a054563          	bltz	a0,27a8 <bigargtest+0xd0>
  wait(&xstatus,0);
    2702:	4581                	li	a1,0
    2704:	fdc40513          	addi	a0,s0,-36
    2708:	00004097          	auipc	ra,0x4
    270c:	f7c080e7          	jalr	-132(ra) # 6684 <wait>
  if(xstatus != 0)
    2710:	fdc42503          	lw	a0,-36(s0)
    2714:	ed45                	bnez	a0,27cc <bigargtest+0xf4>
  fd = open("bigarg-ok", 0);
    2716:	4581                	li	a1,0
    2718:	00005517          	auipc	a0,0x5
    271c:	08050513          	addi	a0,a0,128 # 7798 <malloc+0xcd6>
    2720:	00004097          	auipc	ra,0x4
    2724:	f9c080e7          	jalr	-100(ra) # 66bc <open>
  if(fd < 0){
    2728:	0a054a63          	bltz	a0,27dc <bigargtest+0x104>
  close(fd);
    272c:	00004097          	auipc	ra,0x4
    2730:	f78080e7          	jalr	-136(ra) # 66a4 <close>
}
    2734:	70a2                	ld	ra,40(sp)
    2736:	7402                	ld	s0,32(sp)
    2738:	64e2                	ld	s1,24(sp)
    273a:	6145                	addi	sp,sp,48
    273c:	8082                	ret
    273e:	00008797          	auipc	a5,0x8
    2742:	d2278793          	addi	a5,a5,-734 # a460 <args.1>
    2746:	00008697          	auipc	a3,0x8
    274a:	e1268693          	addi	a3,a3,-494 # a558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    274e:	00005717          	auipc	a4,0x5
    2752:	05a70713          	addi	a4,a4,90 # 77a8 <malloc+0xce6>
    2756:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2758:	07a1                	addi	a5,a5,8
    275a:	fed79ee3          	bne	a5,a3,2756 <bigargtest+0x7e>
    args[MAXARG-1] = 0;
    275e:	00008597          	auipc	a1,0x8
    2762:	d0258593          	addi	a1,a1,-766 # a460 <args.1>
    2766:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    276a:	00004517          	auipc	a0,0x4
    276e:	49e50513          	addi	a0,a0,1182 # 6c08 <malloc+0x146>
    2772:	00004097          	auipc	ra,0x4
    2776:	f42080e7          	jalr	-190(ra) # 66b4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    277a:	20000593          	li	a1,512
    277e:	00005517          	auipc	a0,0x5
    2782:	01a50513          	addi	a0,a0,26 # 7798 <malloc+0xcd6>
    2786:	00004097          	auipc	ra,0x4
    278a:	f36080e7          	jalr	-202(ra) # 66bc <open>
    close(fd);
    278e:	00004097          	auipc	ra,0x4
    2792:	f16080e7          	jalr	-234(ra) # 66a4 <close>
    exit(0,"");
    2796:	00006597          	auipc	a1,0x6
    279a:	a6258593          	addi	a1,a1,-1438 # 81f8 <malloc+0x1736>
    279e:	4501                	li	a0,0
    27a0:	00004097          	auipc	ra,0x4
    27a4:	edc080e7          	jalr	-292(ra) # 667c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    27a8:	85a6                	mv	a1,s1
    27aa:	00005517          	auipc	a0,0x5
    27ae:	0de50513          	addi	a0,a0,222 # 7888 <malloc+0xdc6>
    27b2:	00004097          	auipc	ra,0x4
    27b6:	252080e7          	jalr	594(ra) # 6a04 <printf>
    exit(1,"");
    27ba:	00006597          	auipc	a1,0x6
    27be:	a3e58593          	addi	a1,a1,-1474 # 81f8 <malloc+0x1736>
    27c2:	4505                	li	a0,1
    27c4:	00004097          	auipc	ra,0x4
    27c8:	eb8080e7          	jalr	-328(ra) # 667c <exit>
    exit(xstatus,"");
    27cc:	00006597          	auipc	a1,0x6
    27d0:	a2c58593          	addi	a1,a1,-1492 # 81f8 <malloc+0x1736>
    27d4:	00004097          	auipc	ra,0x4
    27d8:	ea8080e7          	jalr	-344(ra) # 667c <exit>
    printf("%s: bigarg test failed!\n", s);
    27dc:	85a6                	mv	a1,s1
    27de:	00005517          	auipc	a0,0x5
    27e2:	0ca50513          	addi	a0,a0,202 # 78a8 <malloc+0xde6>
    27e6:	00004097          	auipc	ra,0x4
    27ea:	21e080e7          	jalr	542(ra) # 6a04 <printf>
    exit(1,"");
    27ee:	00006597          	auipc	a1,0x6
    27f2:	a0a58593          	addi	a1,a1,-1526 # 81f8 <malloc+0x1736>
    27f6:	4505                	li	a0,1
    27f8:	00004097          	auipc	ra,0x4
    27fc:	e84080e7          	jalr	-380(ra) # 667c <exit>

0000000000002800 <stacktest>:
{
    2800:	7179                	addi	sp,sp,-48
    2802:	f406                	sd	ra,40(sp)
    2804:	f022                	sd	s0,32(sp)
    2806:	ec26                	sd	s1,24(sp)
    2808:	1800                	addi	s0,sp,48
    280a:	84aa                	mv	s1,a0
  pid = fork();
    280c:	00004097          	auipc	ra,0x4
    2810:	e68080e7          	jalr	-408(ra) # 6674 <fork>
  if(pid == 0) {
    2814:	c51d                	beqz	a0,2842 <stacktest+0x42>
  } else if(pid < 0){
    2816:	04054d63          	bltz	a0,2870 <stacktest+0x70>
  wait(&xstatus,0);
    281a:	4581                	li	a1,0
    281c:	fdc40513          	addi	a0,s0,-36
    2820:	00004097          	auipc	ra,0x4
    2824:	e64080e7          	jalr	-412(ra) # 6684 <wait>
  if(xstatus == -1)  // kernel killed child?
    2828:	fdc42503          	lw	a0,-36(s0)
    282c:	57fd                	li	a5,-1
    282e:	06f50363          	beq	a0,a5,2894 <stacktest+0x94>
    exit(xstatus,"");
    2832:	00006597          	auipc	a1,0x6
    2836:	9c658593          	addi	a1,a1,-1594 # 81f8 <malloc+0x1736>
    283a:	00004097          	auipc	ra,0x4
    283e:	e42080e7          	jalr	-446(ra) # 667c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2842:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2844:	77fd                	lui	a5,0xfffff
    2846:	97ba                	add	a5,a5,a4
    2848:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee388>
    284c:	85a6                	mv	a1,s1
    284e:	00005517          	auipc	a0,0x5
    2852:	07a50513          	addi	a0,a0,122 # 78c8 <malloc+0xe06>
    2856:	00004097          	auipc	ra,0x4
    285a:	1ae080e7          	jalr	430(ra) # 6a04 <printf>
    exit(1,"");
    285e:	00006597          	auipc	a1,0x6
    2862:	99a58593          	addi	a1,a1,-1638 # 81f8 <malloc+0x1736>
    2866:	4505                	li	a0,1
    2868:	00004097          	auipc	ra,0x4
    286c:	e14080e7          	jalr	-492(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    2870:	85a6                	mv	a1,s1
    2872:	00005517          	auipc	a0,0x5
    2876:	c1e50513          	addi	a0,a0,-994 # 7490 <malloc+0x9ce>
    287a:	00004097          	auipc	ra,0x4
    287e:	18a080e7          	jalr	394(ra) # 6a04 <printf>
    exit(1,"");
    2882:	00006597          	auipc	a1,0x6
    2886:	97658593          	addi	a1,a1,-1674 # 81f8 <malloc+0x1736>
    288a:	4505                	li	a0,1
    288c:	00004097          	auipc	ra,0x4
    2890:	df0080e7          	jalr	-528(ra) # 667c <exit>
    exit(0,"");
    2894:	00006597          	auipc	a1,0x6
    2898:	96458593          	addi	a1,a1,-1692 # 81f8 <malloc+0x1736>
    289c:	4501                	li	a0,0
    289e:	00004097          	auipc	ra,0x4
    28a2:	dde080e7          	jalr	-546(ra) # 667c <exit>

00000000000028a6 <textwrite>:
{
    28a6:	7179                	addi	sp,sp,-48
    28a8:	f406                	sd	ra,40(sp)
    28aa:	f022                	sd	s0,32(sp)
    28ac:	ec26                	sd	s1,24(sp)
    28ae:	1800                	addi	s0,sp,48
    28b0:	84aa                	mv	s1,a0
  pid = fork();
    28b2:	00004097          	auipc	ra,0x4
    28b6:	dc2080e7          	jalr	-574(ra) # 6674 <fork>
  if(pid == 0) {
    28ba:	c51d                	beqz	a0,28e8 <textwrite+0x42>
  } else if(pid < 0){
    28bc:	04054263          	bltz	a0,2900 <textwrite+0x5a>
  wait(&xstatus,0);
    28c0:	4581                	li	a1,0
    28c2:	fdc40513          	addi	a0,s0,-36
    28c6:	00004097          	auipc	ra,0x4
    28ca:	dbe080e7          	jalr	-578(ra) # 6684 <wait>
  if(xstatus == -1)  // kernel killed child?
    28ce:	fdc42503          	lw	a0,-36(s0)
    28d2:	57fd                	li	a5,-1
    28d4:	04f50863          	beq	a0,a5,2924 <textwrite+0x7e>
    exit(xstatus,"");
    28d8:	00006597          	auipc	a1,0x6
    28dc:	92058593          	addi	a1,a1,-1760 # 81f8 <malloc+0x1736>
    28e0:	00004097          	auipc	ra,0x4
    28e4:	d9c080e7          	jalr	-612(ra) # 667c <exit>
    *addr = 10;
    28e8:	47a9                	li	a5,10
    28ea:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1,"");
    28ee:	00006597          	auipc	a1,0x6
    28f2:	90a58593          	addi	a1,a1,-1782 # 81f8 <malloc+0x1736>
    28f6:	4505                	li	a0,1
    28f8:	00004097          	auipc	ra,0x4
    28fc:	d84080e7          	jalr	-636(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    2900:	85a6                	mv	a1,s1
    2902:	00005517          	auipc	a0,0x5
    2906:	b8e50513          	addi	a0,a0,-1138 # 7490 <malloc+0x9ce>
    290a:	00004097          	auipc	ra,0x4
    290e:	0fa080e7          	jalr	250(ra) # 6a04 <printf>
    exit(1,"");
    2912:	00006597          	auipc	a1,0x6
    2916:	8e658593          	addi	a1,a1,-1818 # 81f8 <malloc+0x1736>
    291a:	4505                	li	a0,1
    291c:	00004097          	auipc	ra,0x4
    2920:	d60080e7          	jalr	-672(ra) # 667c <exit>
    exit(0,"");
    2924:	00006597          	auipc	a1,0x6
    2928:	8d458593          	addi	a1,a1,-1836 # 81f8 <malloc+0x1736>
    292c:	4501                	li	a0,0
    292e:	00004097          	auipc	ra,0x4
    2932:	d4e080e7          	jalr	-690(ra) # 667c <exit>

0000000000002936 <manywrites>:
{
    2936:	711d                	addi	sp,sp,-96
    2938:	ec86                	sd	ra,88(sp)
    293a:	e8a2                	sd	s0,80(sp)
    293c:	e4a6                	sd	s1,72(sp)
    293e:	e0ca                	sd	s2,64(sp)
    2940:	fc4e                	sd	s3,56(sp)
    2942:	f852                	sd	s4,48(sp)
    2944:	f456                	sd	s5,40(sp)
    2946:	f05a                	sd	s6,32(sp)
    2948:	ec5e                	sd	s7,24(sp)
    294a:	1080                	addi	s0,sp,96
    294c:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    294e:	4981                	li	s3,0
    2950:	4911                	li	s2,4
    int pid = fork();
    2952:	00004097          	auipc	ra,0x4
    2956:	d22080e7          	jalr	-734(ra) # 6674 <fork>
    295a:	84aa                	mv	s1,a0
    if(pid < 0){
    295c:	02054f63          	bltz	a0,299a <manywrites+0x64>
    if(pid == 0){
    2960:	cd31                	beqz	a0,29bc <manywrites+0x86>
  for(int ci = 0; ci < nchildren; ci++){
    2962:	2985                	addiw	s3,s3,1
    2964:	ff2997e3          	bne	s3,s2,2952 <manywrites+0x1c>
    2968:	4491                	li	s1,4
    int st = 0;
    296a:	fa042423          	sw	zero,-88(s0)
    wait(&st,0);
    296e:	4581                	li	a1,0
    2970:	fa840513          	addi	a0,s0,-88
    2974:	00004097          	auipc	ra,0x4
    2978:	d10080e7          	jalr	-752(ra) # 6684 <wait>
    if(st != 0)
    297c:	fa842503          	lw	a0,-88(s0)
    2980:	12051263          	bnez	a0,2aa4 <manywrites+0x16e>
  for(int ci = 0; ci < nchildren; ci++){
    2984:	34fd                	addiw	s1,s1,-1
    2986:	f0f5                	bnez	s1,296a <manywrites+0x34>
  exit(0,"");
    2988:	00006597          	auipc	a1,0x6
    298c:	87058593          	addi	a1,a1,-1936 # 81f8 <malloc+0x1736>
    2990:	4501                	li	a0,0
    2992:	00004097          	auipc	ra,0x4
    2996:	cea080e7          	jalr	-790(ra) # 667c <exit>
      printf("fork failed\n");
    299a:	00005517          	auipc	a0,0x5
    299e:	efe50513          	addi	a0,a0,-258 # 7898 <malloc+0xdd6>
    29a2:	00004097          	auipc	ra,0x4
    29a6:	062080e7          	jalr	98(ra) # 6a04 <printf>
      exit(1,"");
    29aa:	00006597          	auipc	a1,0x6
    29ae:	84e58593          	addi	a1,a1,-1970 # 81f8 <malloc+0x1736>
    29b2:	4505                	li	a0,1
    29b4:	00004097          	auipc	ra,0x4
    29b8:	cc8080e7          	jalr	-824(ra) # 667c <exit>
      name[0] = 'b';
    29bc:	06200793          	li	a5,98
    29c0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    29c4:	0619879b          	addiw	a5,s3,97
    29c8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    29cc:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    29d0:	fa840513          	addi	a0,s0,-88
    29d4:	00004097          	auipc	ra,0x4
    29d8:	cf8080e7          	jalr	-776(ra) # 66cc <unlink>
    29dc:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    29de:	0000bb17          	auipc	s6,0xb
    29e2:	29ab0b13          	addi	s6,s6,666 # dc78 <buf>
        for(int i = 0; i < ci+1; i++){
    29e6:	8a26                	mv	s4,s1
    29e8:	0209ce63          	bltz	s3,2a24 <manywrites+0xee>
          int fd = open(name, O_CREATE | O_RDWR);
    29ec:	20200593          	li	a1,514
    29f0:	fa840513          	addi	a0,s0,-88
    29f4:	00004097          	auipc	ra,0x4
    29f8:	cc8080e7          	jalr	-824(ra) # 66bc <open>
    29fc:	892a                	mv	s2,a0
          if(fd < 0){
    29fe:	04054b63          	bltz	a0,2a54 <manywrites+0x11e>
          int cc = write(fd, buf, sz);
    2a02:	660d                	lui	a2,0x3
    2a04:	85da                	mv	a1,s6
    2a06:	00004097          	auipc	ra,0x4
    2a0a:	c96080e7          	jalr	-874(ra) # 669c <write>
          if(cc != sz){
    2a0e:	678d                	lui	a5,0x3
    2a10:	06f51663          	bne	a0,a5,2a7c <manywrites+0x146>
          close(fd);
    2a14:	854a                	mv	a0,s2
    2a16:	00004097          	auipc	ra,0x4
    2a1a:	c8e080e7          	jalr	-882(ra) # 66a4 <close>
        for(int i = 0; i < ci+1; i++){
    2a1e:	2a05                	addiw	s4,s4,1
    2a20:	fd49d6e3          	bge	s3,s4,29ec <manywrites+0xb6>
        unlink(name);
    2a24:	fa840513          	addi	a0,s0,-88
    2a28:	00004097          	auipc	ra,0x4
    2a2c:	ca4080e7          	jalr	-860(ra) # 66cc <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2a30:	3bfd                	addiw	s7,s7,-1
    2a32:	fa0b9ae3          	bnez	s7,29e6 <manywrites+0xb0>
      unlink(name);
    2a36:	fa840513          	addi	a0,s0,-88
    2a3a:	00004097          	auipc	ra,0x4
    2a3e:	c92080e7          	jalr	-878(ra) # 66cc <unlink>
      exit(0,"");
    2a42:	00005597          	auipc	a1,0x5
    2a46:	7b658593          	addi	a1,a1,1974 # 81f8 <malloc+0x1736>
    2a4a:	4501                	li	a0,0
    2a4c:	00004097          	auipc	ra,0x4
    2a50:	c30080e7          	jalr	-976(ra) # 667c <exit>
            printf("%s: cannot create %s\n", s, name);
    2a54:	fa840613          	addi	a2,s0,-88
    2a58:	85d6                	mv	a1,s5
    2a5a:	00005517          	auipc	a0,0x5
    2a5e:	e9650513          	addi	a0,a0,-362 # 78f0 <malloc+0xe2e>
    2a62:	00004097          	auipc	ra,0x4
    2a66:	fa2080e7          	jalr	-94(ra) # 6a04 <printf>
            exit(1,"");
    2a6a:	00005597          	auipc	a1,0x5
    2a6e:	78e58593          	addi	a1,a1,1934 # 81f8 <malloc+0x1736>
    2a72:	4505                	li	a0,1
    2a74:	00004097          	auipc	ra,0x4
    2a78:	c08080e7          	jalr	-1016(ra) # 667c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2a7c:	86aa                	mv	a3,a0
    2a7e:	660d                	lui	a2,0x3
    2a80:	85d6                	mv	a1,s5
    2a82:	00004517          	auipc	a0,0x4
    2a86:	25650513          	addi	a0,a0,598 # 6cd8 <malloc+0x216>
    2a8a:	00004097          	auipc	ra,0x4
    2a8e:	f7a080e7          	jalr	-134(ra) # 6a04 <printf>
            exit(1,"");
    2a92:	00005597          	auipc	a1,0x5
    2a96:	76658593          	addi	a1,a1,1894 # 81f8 <malloc+0x1736>
    2a9a:	4505                	li	a0,1
    2a9c:	00004097          	auipc	ra,0x4
    2aa0:	be0080e7          	jalr	-1056(ra) # 667c <exit>
      exit(st,"");
    2aa4:	00005597          	auipc	a1,0x5
    2aa8:	75458593          	addi	a1,a1,1876 # 81f8 <malloc+0x1736>
    2aac:	00004097          	auipc	ra,0x4
    2ab0:	bd0080e7          	jalr	-1072(ra) # 667c <exit>

0000000000002ab4 <copyinstr3>:
{
    2ab4:	7179                	addi	sp,sp,-48
    2ab6:	f406                	sd	ra,40(sp)
    2ab8:	f022                	sd	s0,32(sp)
    2aba:	ec26                	sd	s1,24(sp)
    2abc:	1800                	addi	s0,sp,48
  sbrk(8192);
    2abe:	6509                	lui	a0,0x2
    2ac0:	00004097          	auipc	ra,0x4
    2ac4:	c44080e7          	jalr	-956(ra) # 6704 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2ac8:	4501                	li	a0,0
    2aca:	00004097          	auipc	ra,0x4
    2ace:	c3a080e7          	jalr	-966(ra) # 6704 <sbrk>
  if((top % PGSIZE) != 0){
    2ad2:	03451793          	slli	a5,a0,0x34
    2ad6:	e3c9                	bnez	a5,2b58 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2ad8:	4501                	li	a0,0
    2ada:	00004097          	auipc	ra,0x4
    2ade:	c2a080e7          	jalr	-982(ra) # 6704 <sbrk>
  if(top % PGSIZE){
    2ae2:	03451793          	slli	a5,a0,0x34
    2ae6:	e3d9                	bnez	a5,2b6c <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2ae8:	fff50493          	addi	s1,a0,-1 # 1fff <forkfork+0xaf>
  *b = 'x';
    2aec:	07800793          	li	a5,120
    2af0:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2af4:	8526                	mv	a0,s1
    2af6:	00004097          	auipc	ra,0x4
    2afa:	bd6080e7          	jalr	-1066(ra) # 66cc <unlink>
  if(ret != -1){
    2afe:	57fd                	li	a5,-1
    2b00:	08f51763          	bne	a0,a5,2b8e <copyinstr3+0xda>
  int fd = open(b, O_CREATE | O_WRONLY);
    2b04:	20100593          	li	a1,513
    2b08:	8526                	mv	a0,s1
    2b0a:	00004097          	auipc	ra,0x4
    2b0e:	bb2080e7          	jalr	-1102(ra) # 66bc <open>
  if(fd != -1){
    2b12:	57fd                	li	a5,-1
    2b14:	0af51063          	bne	a0,a5,2bb4 <copyinstr3+0x100>
  ret = link(b, b);
    2b18:	85a6                	mv	a1,s1
    2b1a:	8526                	mv	a0,s1
    2b1c:	00004097          	auipc	ra,0x4
    2b20:	bc0080e7          	jalr	-1088(ra) # 66dc <link>
  if(ret != -1){
    2b24:	57fd                	li	a5,-1
    2b26:	0af51a63          	bne	a0,a5,2bda <copyinstr3+0x126>
  char *args[] = { "xx", 0 };
    2b2a:	00006797          	auipc	a5,0x6
    2b2e:	abe78793          	addi	a5,a5,-1346 # 85e8 <malloc+0x1b26>
    2b32:	fcf43823          	sd	a5,-48(s0)
    2b36:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2b3a:	fd040593          	addi	a1,s0,-48
    2b3e:	8526                	mv	a0,s1
    2b40:	00004097          	auipc	ra,0x4
    2b44:	b74080e7          	jalr	-1164(ra) # 66b4 <exec>
  if(ret != -1){
    2b48:	57fd                	li	a5,-1
    2b4a:	0af51c63          	bne	a0,a5,2c02 <copyinstr3+0x14e>
}
    2b4e:	70a2                	ld	ra,40(sp)
    2b50:	7402                	ld	s0,32(sp)
    2b52:	64e2                	ld	s1,24(sp)
    2b54:	6145                	addi	sp,sp,48
    2b56:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2b58:	0347d513          	srli	a0,a5,0x34
    2b5c:	6785                	lui	a5,0x1
    2b5e:	40a7853b          	subw	a0,a5,a0
    2b62:	00004097          	auipc	ra,0x4
    2b66:	ba2080e7          	jalr	-1118(ra) # 6704 <sbrk>
    2b6a:	b7bd                	j	2ad8 <copyinstr3+0x24>
    printf("oops\n");
    2b6c:	00005517          	auipc	a0,0x5
    2b70:	d9c50513          	addi	a0,a0,-612 # 7908 <malloc+0xe46>
    2b74:	00004097          	auipc	ra,0x4
    2b78:	e90080e7          	jalr	-368(ra) # 6a04 <printf>
    exit(1,"");
    2b7c:	00005597          	auipc	a1,0x5
    2b80:	67c58593          	addi	a1,a1,1660 # 81f8 <malloc+0x1736>
    2b84:	4505                	li	a0,1
    2b86:	00004097          	auipc	ra,0x4
    2b8a:	af6080e7          	jalr	-1290(ra) # 667c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2b8e:	862a                	mv	a2,a0
    2b90:	85a6                	mv	a1,s1
    2b92:	00005517          	auipc	a0,0x5
    2b96:	81e50513          	addi	a0,a0,-2018 # 73b0 <malloc+0x8ee>
    2b9a:	00004097          	auipc	ra,0x4
    2b9e:	e6a080e7          	jalr	-406(ra) # 6a04 <printf>
    exit(1,"");
    2ba2:	00005597          	auipc	a1,0x5
    2ba6:	65658593          	addi	a1,a1,1622 # 81f8 <malloc+0x1736>
    2baa:	4505                	li	a0,1
    2bac:	00004097          	auipc	ra,0x4
    2bb0:	ad0080e7          	jalr	-1328(ra) # 667c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2bb4:	862a                	mv	a2,a0
    2bb6:	85a6                	mv	a1,s1
    2bb8:	00005517          	auipc	a0,0x5
    2bbc:	81850513          	addi	a0,a0,-2024 # 73d0 <malloc+0x90e>
    2bc0:	00004097          	auipc	ra,0x4
    2bc4:	e44080e7          	jalr	-444(ra) # 6a04 <printf>
    exit(1,"");
    2bc8:	00005597          	auipc	a1,0x5
    2bcc:	63058593          	addi	a1,a1,1584 # 81f8 <malloc+0x1736>
    2bd0:	4505                	li	a0,1
    2bd2:	00004097          	auipc	ra,0x4
    2bd6:	aaa080e7          	jalr	-1366(ra) # 667c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2bda:	86aa                	mv	a3,a0
    2bdc:	8626                	mv	a2,s1
    2bde:	85a6                	mv	a1,s1
    2be0:	00005517          	auipc	a0,0x5
    2be4:	81050513          	addi	a0,a0,-2032 # 73f0 <malloc+0x92e>
    2be8:	00004097          	auipc	ra,0x4
    2bec:	e1c080e7          	jalr	-484(ra) # 6a04 <printf>
    exit(1,"");
    2bf0:	00005597          	auipc	a1,0x5
    2bf4:	60858593          	addi	a1,a1,1544 # 81f8 <malloc+0x1736>
    2bf8:	4505                	li	a0,1
    2bfa:	00004097          	auipc	ra,0x4
    2bfe:	a82080e7          	jalr	-1406(ra) # 667c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2c02:	567d                	li	a2,-1
    2c04:	85a6                	mv	a1,s1
    2c06:	00005517          	auipc	a0,0x5
    2c0a:	81250513          	addi	a0,a0,-2030 # 7418 <malloc+0x956>
    2c0e:	00004097          	auipc	ra,0x4
    2c12:	df6080e7          	jalr	-522(ra) # 6a04 <printf>
    exit(1,"");
    2c16:	00005597          	auipc	a1,0x5
    2c1a:	5e258593          	addi	a1,a1,1506 # 81f8 <malloc+0x1736>
    2c1e:	4505                	li	a0,1
    2c20:	00004097          	auipc	ra,0x4
    2c24:	a5c080e7          	jalr	-1444(ra) # 667c <exit>

0000000000002c28 <rwsbrk>:
{
    2c28:	1101                	addi	sp,sp,-32
    2c2a:	ec06                	sd	ra,24(sp)
    2c2c:	e822                	sd	s0,16(sp)
    2c2e:	e426                	sd	s1,8(sp)
    2c30:	e04a                	sd	s2,0(sp)
    2c32:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2c34:	6509                	lui	a0,0x2
    2c36:	00004097          	auipc	ra,0x4
    2c3a:	ace080e7          	jalr	-1330(ra) # 6704 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2c3e:	57fd                	li	a5,-1
    2c40:	06f50763          	beq	a0,a5,2cae <rwsbrk+0x86>
    2c44:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2c46:	7579                	lui	a0,0xffffe
    2c48:	00004097          	auipc	ra,0x4
    2c4c:	abc080e7          	jalr	-1348(ra) # 6704 <sbrk>
    2c50:	57fd                	li	a5,-1
    2c52:	06f50f63          	beq	a0,a5,2cd0 <rwsbrk+0xa8>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2c56:	20100593          	li	a1,513
    2c5a:	00005517          	auipc	a0,0x5
    2c5e:	cee50513          	addi	a0,a0,-786 # 7948 <malloc+0xe86>
    2c62:	00004097          	auipc	ra,0x4
    2c66:	a5a080e7          	jalr	-1446(ra) # 66bc <open>
    2c6a:	892a                	mv	s2,a0
  if(fd < 0){
    2c6c:	08054363          	bltz	a0,2cf2 <rwsbrk+0xca>
  n = write(fd, (void*)(a+4096), 1024);
    2c70:	6505                	lui	a0,0x1
    2c72:	94aa                	add	s1,s1,a0
    2c74:	40000613          	li	a2,1024
    2c78:	85a6                	mv	a1,s1
    2c7a:	854a                	mv	a0,s2
    2c7c:	00004097          	auipc	ra,0x4
    2c80:	a20080e7          	jalr	-1504(ra) # 669c <write>
    2c84:	862a                	mv	a2,a0
  if(n >= 0){
    2c86:	08054763          	bltz	a0,2d14 <rwsbrk+0xec>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2c8a:	85a6                	mv	a1,s1
    2c8c:	00005517          	auipc	a0,0x5
    2c90:	cdc50513          	addi	a0,a0,-804 # 7968 <malloc+0xea6>
    2c94:	00004097          	auipc	ra,0x4
    2c98:	d70080e7          	jalr	-656(ra) # 6a04 <printf>
    exit(1,"");
    2c9c:	00005597          	auipc	a1,0x5
    2ca0:	55c58593          	addi	a1,a1,1372 # 81f8 <malloc+0x1736>
    2ca4:	4505                	li	a0,1
    2ca6:	00004097          	auipc	ra,0x4
    2caa:	9d6080e7          	jalr	-1578(ra) # 667c <exit>
    printf("sbrk(rwsbrk) failed\n");
    2cae:	00005517          	auipc	a0,0x5
    2cb2:	c6250513          	addi	a0,a0,-926 # 7910 <malloc+0xe4e>
    2cb6:	00004097          	auipc	ra,0x4
    2cba:	d4e080e7          	jalr	-690(ra) # 6a04 <printf>
    exit(1,"");
    2cbe:	00005597          	auipc	a1,0x5
    2cc2:	53a58593          	addi	a1,a1,1338 # 81f8 <malloc+0x1736>
    2cc6:	4505                	li	a0,1
    2cc8:	00004097          	auipc	ra,0x4
    2ccc:	9b4080e7          	jalr	-1612(ra) # 667c <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2cd0:	00005517          	auipc	a0,0x5
    2cd4:	c5850513          	addi	a0,a0,-936 # 7928 <malloc+0xe66>
    2cd8:	00004097          	auipc	ra,0x4
    2cdc:	d2c080e7          	jalr	-724(ra) # 6a04 <printf>
    exit(1,"");
    2ce0:	00005597          	auipc	a1,0x5
    2ce4:	51858593          	addi	a1,a1,1304 # 81f8 <malloc+0x1736>
    2ce8:	4505                	li	a0,1
    2cea:	00004097          	auipc	ra,0x4
    2cee:	992080e7          	jalr	-1646(ra) # 667c <exit>
    printf("open(rwsbrk) failed\n");
    2cf2:	00005517          	auipc	a0,0x5
    2cf6:	c5e50513          	addi	a0,a0,-930 # 7950 <malloc+0xe8e>
    2cfa:	00004097          	auipc	ra,0x4
    2cfe:	d0a080e7          	jalr	-758(ra) # 6a04 <printf>
    exit(1,"");
    2d02:	00005597          	auipc	a1,0x5
    2d06:	4f658593          	addi	a1,a1,1270 # 81f8 <malloc+0x1736>
    2d0a:	4505                	li	a0,1
    2d0c:	00004097          	auipc	ra,0x4
    2d10:	970080e7          	jalr	-1680(ra) # 667c <exit>
  close(fd);
    2d14:	854a                	mv	a0,s2
    2d16:	00004097          	auipc	ra,0x4
    2d1a:	98e080e7          	jalr	-1650(ra) # 66a4 <close>
  unlink("rwsbrk");
    2d1e:	00005517          	auipc	a0,0x5
    2d22:	c2a50513          	addi	a0,a0,-982 # 7948 <malloc+0xe86>
    2d26:	00004097          	auipc	ra,0x4
    2d2a:	9a6080e7          	jalr	-1626(ra) # 66cc <unlink>
  fd = open("README", O_RDONLY);
    2d2e:	4581                	li	a1,0
    2d30:	00004517          	auipc	a0,0x4
    2d34:	0b050513          	addi	a0,a0,176 # 6de0 <malloc+0x31e>
    2d38:	00004097          	auipc	ra,0x4
    2d3c:	984080e7          	jalr	-1660(ra) # 66bc <open>
    2d40:	892a                	mv	s2,a0
  if(fd < 0){
    2d42:	02054d63          	bltz	a0,2d7c <rwsbrk+0x154>
  n = read(fd, (void*)(a+4096), 10);
    2d46:	4629                	li	a2,10
    2d48:	85a6                	mv	a1,s1
    2d4a:	00004097          	auipc	ra,0x4
    2d4e:	94a080e7          	jalr	-1718(ra) # 6694 <read>
    2d52:	862a                	mv	a2,a0
  if(n >= 0){
    2d54:	04054563          	bltz	a0,2d9e <rwsbrk+0x176>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2d58:	85a6                	mv	a1,s1
    2d5a:	00005517          	auipc	a0,0x5
    2d5e:	c3e50513          	addi	a0,a0,-962 # 7998 <malloc+0xed6>
    2d62:	00004097          	auipc	ra,0x4
    2d66:	ca2080e7          	jalr	-862(ra) # 6a04 <printf>
    exit(1,"");
    2d6a:	00005597          	auipc	a1,0x5
    2d6e:	48e58593          	addi	a1,a1,1166 # 81f8 <malloc+0x1736>
    2d72:	4505                	li	a0,1
    2d74:	00004097          	auipc	ra,0x4
    2d78:	908080e7          	jalr	-1784(ra) # 667c <exit>
    printf("open(rwsbrk) failed\n");
    2d7c:	00005517          	auipc	a0,0x5
    2d80:	bd450513          	addi	a0,a0,-1068 # 7950 <malloc+0xe8e>
    2d84:	00004097          	auipc	ra,0x4
    2d88:	c80080e7          	jalr	-896(ra) # 6a04 <printf>
    exit(1,"");
    2d8c:	00005597          	auipc	a1,0x5
    2d90:	46c58593          	addi	a1,a1,1132 # 81f8 <malloc+0x1736>
    2d94:	4505                	li	a0,1
    2d96:	00004097          	auipc	ra,0x4
    2d9a:	8e6080e7          	jalr	-1818(ra) # 667c <exit>
  close(fd);
    2d9e:	854a                	mv	a0,s2
    2da0:	00004097          	auipc	ra,0x4
    2da4:	904080e7          	jalr	-1788(ra) # 66a4 <close>
  exit(0,"");
    2da8:	00005597          	auipc	a1,0x5
    2dac:	45058593          	addi	a1,a1,1104 # 81f8 <malloc+0x1736>
    2db0:	4501                	li	a0,0
    2db2:	00004097          	auipc	ra,0x4
    2db6:	8ca080e7          	jalr	-1846(ra) # 667c <exit>

0000000000002dba <sbrkbasic>:
{
    2dba:	7139                	addi	sp,sp,-64
    2dbc:	fc06                	sd	ra,56(sp)
    2dbe:	f822                	sd	s0,48(sp)
    2dc0:	f426                	sd	s1,40(sp)
    2dc2:	f04a                	sd	s2,32(sp)
    2dc4:	ec4e                	sd	s3,24(sp)
    2dc6:	e852                	sd	s4,16(sp)
    2dc8:	0080                	addi	s0,sp,64
    2dca:	8a2a                	mv	s4,a0
  pid = fork();
    2dcc:	00004097          	auipc	ra,0x4
    2dd0:	8a8080e7          	jalr	-1880(ra) # 6674 <fork>
  if(pid < 0){
    2dd4:	04054063          	bltz	a0,2e14 <sbrkbasic+0x5a>
  if(pid == 0){
    2dd8:	e925                	bnez	a0,2e48 <sbrkbasic+0x8e>
    a = sbrk(TOOMUCH);
    2dda:	40000537          	lui	a0,0x40000
    2dde:	00004097          	auipc	ra,0x4
    2de2:	926080e7          	jalr	-1754(ra) # 6704 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2de6:	57fd                	li	a5,-1
    2de8:	04f50763          	beq	a0,a5,2e36 <sbrkbasic+0x7c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2dec:	400007b7          	lui	a5,0x40000
    2df0:	97aa                	add	a5,a5,a0
      *b = 99;
    2df2:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2df6:	6705                	lui	a4,0x1
      *b = 99;
    2df8:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2dfc:	953a                	add	a0,a0,a4
    2dfe:	fef51de3          	bne	a0,a5,2df8 <sbrkbasic+0x3e>
    exit(1,"");
    2e02:	00005597          	auipc	a1,0x5
    2e06:	3f658593          	addi	a1,a1,1014 # 81f8 <malloc+0x1736>
    2e0a:	4505                	li	a0,1
    2e0c:	00004097          	auipc	ra,0x4
    2e10:	870080e7          	jalr	-1936(ra) # 667c <exit>
    printf("fork failed in sbrkbasic\n");
    2e14:	00005517          	auipc	a0,0x5
    2e18:	bac50513          	addi	a0,a0,-1108 # 79c0 <malloc+0xefe>
    2e1c:	00004097          	auipc	ra,0x4
    2e20:	be8080e7          	jalr	-1048(ra) # 6a04 <printf>
    exit(1,"");
    2e24:	00005597          	auipc	a1,0x5
    2e28:	3d458593          	addi	a1,a1,980 # 81f8 <malloc+0x1736>
    2e2c:	4505                	li	a0,1
    2e2e:	00004097          	auipc	ra,0x4
    2e32:	84e080e7          	jalr	-1970(ra) # 667c <exit>
      exit(0,"");
    2e36:	00005597          	auipc	a1,0x5
    2e3a:	3c258593          	addi	a1,a1,962 # 81f8 <malloc+0x1736>
    2e3e:	4501                	li	a0,0
    2e40:	00004097          	auipc	ra,0x4
    2e44:	83c080e7          	jalr	-1988(ra) # 667c <exit>
  wait(&xstatus,0);
    2e48:	4581                	li	a1,0
    2e4a:	fcc40513          	addi	a0,s0,-52
    2e4e:	00004097          	auipc	ra,0x4
    2e52:	836080e7          	jalr	-1994(ra) # 6684 <wait>
  if(xstatus == 1){
    2e56:	fcc42703          	lw	a4,-52(s0)
    2e5a:	4785                	li	a5,1
    2e5c:	00f70d63          	beq	a4,a5,2e76 <sbrkbasic+0xbc>
  a = sbrk(0);
    2e60:	4501                	li	a0,0
    2e62:	00004097          	auipc	ra,0x4
    2e66:	8a2080e7          	jalr	-1886(ra) # 6704 <sbrk>
    2e6a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2e6c:	4901                	li	s2,0
    2e6e:	6985                	lui	s3,0x1
    2e70:	38898993          	addi	s3,s3,904 # 1388 <bigdir+0x20>
    2e74:	a025                	j	2e9c <sbrkbasic+0xe2>
    printf("%s: too much memory allocated!\n", s);
    2e76:	85d2                	mv	a1,s4
    2e78:	00005517          	auipc	a0,0x5
    2e7c:	b6850513          	addi	a0,a0,-1176 # 79e0 <malloc+0xf1e>
    2e80:	00004097          	auipc	ra,0x4
    2e84:	b84080e7          	jalr	-1148(ra) # 6a04 <printf>
    exit(1,"");
    2e88:	00005597          	auipc	a1,0x5
    2e8c:	37058593          	addi	a1,a1,880 # 81f8 <malloc+0x1736>
    2e90:	4505                	li	a0,1
    2e92:	00003097          	auipc	ra,0x3
    2e96:	7ea080e7          	jalr	2026(ra) # 667c <exit>
    a = b + 1;
    2e9a:	84be                	mv	s1,a5
    b = sbrk(1);
    2e9c:	4505                	li	a0,1
    2e9e:	00004097          	auipc	ra,0x4
    2ea2:	866080e7          	jalr	-1946(ra) # 6704 <sbrk>
    if(b != a){
    2ea6:	06951063          	bne	a0,s1,2f06 <sbrkbasic+0x14c>
    *b = 1;
    2eaa:	4785                	li	a5,1
    2eac:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2eb0:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2eb4:	2905                	addiw	s2,s2,1
    2eb6:	ff3912e3          	bne	s2,s3,2e9a <sbrkbasic+0xe0>
  pid = fork();
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	7ba080e7          	jalr	1978(ra) # 6674 <fork>
    2ec2:	892a                	mv	s2,a0
  if(pid < 0){
    2ec4:	06054663          	bltz	a0,2f30 <sbrkbasic+0x176>
  c = sbrk(1);
    2ec8:	4505                	li	a0,1
    2eca:	00004097          	auipc	ra,0x4
    2ece:	83a080e7          	jalr	-1990(ra) # 6704 <sbrk>
  c = sbrk(1);
    2ed2:	4505                	li	a0,1
    2ed4:	00004097          	auipc	ra,0x4
    2ed8:	830080e7          	jalr	-2000(ra) # 6704 <sbrk>
  if(c != a + 1){
    2edc:	0489                	addi	s1,s1,2
    2ede:	06a48b63          	beq	s1,a0,2f54 <sbrkbasic+0x19a>
    printf("%s: sbrk test failed post-fork\n", s);
    2ee2:	85d2                	mv	a1,s4
    2ee4:	00005517          	auipc	a0,0x5
    2ee8:	b5c50513          	addi	a0,a0,-1188 # 7a40 <malloc+0xf7e>
    2eec:	00004097          	auipc	ra,0x4
    2ef0:	b18080e7          	jalr	-1256(ra) # 6a04 <printf>
    exit(1,"");
    2ef4:	00005597          	auipc	a1,0x5
    2ef8:	30458593          	addi	a1,a1,772 # 81f8 <malloc+0x1736>
    2efc:	4505                	li	a0,1
    2efe:	00003097          	auipc	ra,0x3
    2f02:	77e080e7          	jalr	1918(ra) # 667c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2f06:	872a                	mv	a4,a0
    2f08:	86a6                	mv	a3,s1
    2f0a:	864a                	mv	a2,s2
    2f0c:	85d2                	mv	a1,s4
    2f0e:	00005517          	auipc	a0,0x5
    2f12:	af250513          	addi	a0,a0,-1294 # 7a00 <malloc+0xf3e>
    2f16:	00004097          	auipc	ra,0x4
    2f1a:	aee080e7          	jalr	-1298(ra) # 6a04 <printf>
      exit(1,"");
    2f1e:	00005597          	auipc	a1,0x5
    2f22:	2da58593          	addi	a1,a1,730 # 81f8 <malloc+0x1736>
    2f26:	4505                	li	a0,1
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	754080e7          	jalr	1876(ra) # 667c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2f30:	85d2                	mv	a1,s4
    2f32:	00005517          	auipc	a0,0x5
    2f36:	aee50513          	addi	a0,a0,-1298 # 7a20 <malloc+0xf5e>
    2f3a:	00004097          	auipc	ra,0x4
    2f3e:	aca080e7          	jalr	-1334(ra) # 6a04 <printf>
    exit(1,"");
    2f42:	00005597          	auipc	a1,0x5
    2f46:	2b658593          	addi	a1,a1,694 # 81f8 <malloc+0x1736>
    2f4a:	4505                	li	a0,1
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	730080e7          	jalr	1840(ra) # 667c <exit>
  if(pid == 0)
    2f54:	00091b63          	bnez	s2,2f6a <sbrkbasic+0x1b0>
    exit(0,"");
    2f58:	00005597          	auipc	a1,0x5
    2f5c:	2a058593          	addi	a1,a1,672 # 81f8 <malloc+0x1736>
    2f60:	4501                	li	a0,0
    2f62:	00003097          	auipc	ra,0x3
    2f66:	71a080e7          	jalr	1818(ra) # 667c <exit>
  wait(&xstatus,0);
    2f6a:	4581                	li	a1,0
    2f6c:	fcc40513          	addi	a0,s0,-52
    2f70:	00003097          	auipc	ra,0x3
    2f74:	714080e7          	jalr	1812(ra) # 6684 <wait>
  exit(xstatus,"");
    2f78:	00005597          	auipc	a1,0x5
    2f7c:	28058593          	addi	a1,a1,640 # 81f8 <malloc+0x1736>
    2f80:	fcc42503          	lw	a0,-52(s0)
    2f84:	00003097          	auipc	ra,0x3
    2f88:	6f8080e7          	jalr	1784(ra) # 667c <exit>

0000000000002f8c <sbrkmuch>:
{
    2f8c:	7179                	addi	sp,sp,-48
    2f8e:	f406                	sd	ra,40(sp)
    2f90:	f022                	sd	s0,32(sp)
    2f92:	ec26                	sd	s1,24(sp)
    2f94:	e84a                	sd	s2,16(sp)
    2f96:	e44e                	sd	s3,8(sp)
    2f98:	e052                	sd	s4,0(sp)
    2f9a:	1800                	addi	s0,sp,48
    2f9c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2f9e:	4501                	li	a0,0
    2fa0:	00003097          	auipc	ra,0x3
    2fa4:	764080e7          	jalr	1892(ra) # 6704 <sbrk>
    2fa8:	892a                	mv	s2,a0
  a = sbrk(0);
    2faa:	4501                	li	a0,0
    2fac:	00003097          	auipc	ra,0x3
    2fb0:	758080e7          	jalr	1880(ra) # 6704 <sbrk>
    2fb4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2fb6:	06400537          	lui	a0,0x6400
    2fba:	9d05                	subw	a0,a0,s1
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	748080e7          	jalr	1864(ra) # 6704 <sbrk>
  if (p != a) {
    2fc4:	0ca49863          	bne	s1,a0,3094 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2fc8:	4501                	li	a0,0
    2fca:	00003097          	auipc	ra,0x3
    2fce:	73a080e7          	jalr	1850(ra) # 6704 <sbrk>
    2fd2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2fd4:	00a4f963          	bgeu	s1,a0,2fe6 <sbrkmuch+0x5a>
    *pp = 1;
    2fd8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2fda:	6705                	lui	a4,0x1
    *pp = 1;
    2fdc:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2fe0:	94ba                	add	s1,s1,a4
    2fe2:	fef4ede3          	bltu	s1,a5,2fdc <sbrkmuch+0x50>
  *lastaddr = 99;
    2fe6:	064007b7          	lui	a5,0x6400
    2fea:	06300713          	li	a4,99
    2fee:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef387>
  a = sbrk(0);
    2ff2:	4501                	li	a0,0
    2ff4:	00003097          	auipc	ra,0x3
    2ff8:	710080e7          	jalr	1808(ra) # 6704 <sbrk>
    2ffc:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2ffe:	757d                	lui	a0,0xfffff
    3000:	00003097          	auipc	ra,0x3
    3004:	704080e7          	jalr	1796(ra) # 6704 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3008:	57fd                	li	a5,-1
    300a:	0af50763          	beq	a0,a5,30b8 <sbrkmuch+0x12c>
  c = sbrk(0);
    300e:	4501                	li	a0,0
    3010:	00003097          	auipc	ra,0x3
    3014:	6f4080e7          	jalr	1780(ra) # 6704 <sbrk>
  if(c != a - PGSIZE){
    3018:	77fd                	lui	a5,0xfffff
    301a:	97a6                	add	a5,a5,s1
    301c:	0cf51063          	bne	a0,a5,30dc <sbrkmuch+0x150>
  a = sbrk(0);
    3020:	4501                	li	a0,0
    3022:	00003097          	auipc	ra,0x3
    3026:	6e2080e7          	jalr	1762(ra) # 6704 <sbrk>
    302a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    302c:	6505                	lui	a0,0x1
    302e:	00003097          	auipc	ra,0x3
    3032:	6d6080e7          	jalr	1750(ra) # 6704 <sbrk>
    3036:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3038:	0ca49663          	bne	s1,a0,3104 <sbrkmuch+0x178>
    303c:	4501                	li	a0,0
    303e:	00003097          	auipc	ra,0x3
    3042:	6c6080e7          	jalr	1734(ra) # 6704 <sbrk>
    3046:	6785                	lui	a5,0x1
    3048:	97a6                	add	a5,a5,s1
    304a:	0af51d63          	bne	a0,a5,3104 <sbrkmuch+0x178>
  if(*lastaddr == 99){
    304e:	064007b7          	lui	a5,0x6400
    3052:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef387>
    3056:	06300793          	li	a5,99
    305a:	0cf70963          	beq	a4,a5,312c <sbrkmuch+0x1a0>
  a = sbrk(0);
    305e:	4501                	li	a0,0
    3060:	00003097          	auipc	ra,0x3
    3064:	6a4080e7          	jalr	1700(ra) # 6704 <sbrk>
    3068:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    306a:	4501                	li	a0,0
    306c:	00003097          	auipc	ra,0x3
    3070:	698080e7          	jalr	1688(ra) # 6704 <sbrk>
    3074:	40a9053b          	subw	a0,s2,a0
    3078:	00003097          	auipc	ra,0x3
    307c:	68c080e7          	jalr	1676(ra) # 6704 <sbrk>
  if(c != a){
    3080:	0ca49863          	bne	s1,a0,3150 <sbrkmuch+0x1c4>
}
    3084:	70a2                	ld	ra,40(sp)
    3086:	7402                	ld	s0,32(sp)
    3088:	64e2                	ld	s1,24(sp)
    308a:	6942                	ld	s2,16(sp)
    308c:	69a2                	ld	s3,8(sp)
    308e:	6a02                	ld	s4,0(sp)
    3090:	6145                	addi	sp,sp,48
    3092:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3094:	85ce                	mv	a1,s3
    3096:	00005517          	auipc	a0,0x5
    309a:	9ca50513          	addi	a0,a0,-1590 # 7a60 <malloc+0xf9e>
    309e:	00004097          	auipc	ra,0x4
    30a2:	966080e7          	jalr	-1690(ra) # 6a04 <printf>
    exit(1,"");
    30a6:	00005597          	auipc	a1,0x5
    30aa:	15258593          	addi	a1,a1,338 # 81f8 <malloc+0x1736>
    30ae:	4505                	li	a0,1
    30b0:	00003097          	auipc	ra,0x3
    30b4:	5cc080e7          	jalr	1484(ra) # 667c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    30b8:	85ce                	mv	a1,s3
    30ba:	00005517          	auipc	a0,0x5
    30be:	9ee50513          	addi	a0,a0,-1554 # 7aa8 <malloc+0xfe6>
    30c2:	00004097          	auipc	ra,0x4
    30c6:	942080e7          	jalr	-1726(ra) # 6a04 <printf>
    exit(1,"");
    30ca:	00005597          	auipc	a1,0x5
    30ce:	12e58593          	addi	a1,a1,302 # 81f8 <malloc+0x1736>
    30d2:	4505                	li	a0,1
    30d4:	00003097          	auipc	ra,0x3
    30d8:	5a8080e7          	jalr	1448(ra) # 667c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    30dc:	86aa                	mv	a3,a0
    30de:	8626                	mv	a2,s1
    30e0:	85ce                	mv	a1,s3
    30e2:	00005517          	auipc	a0,0x5
    30e6:	9e650513          	addi	a0,a0,-1562 # 7ac8 <malloc+0x1006>
    30ea:	00004097          	auipc	ra,0x4
    30ee:	91a080e7          	jalr	-1766(ra) # 6a04 <printf>
    exit(1,"");
    30f2:	00005597          	auipc	a1,0x5
    30f6:	10658593          	addi	a1,a1,262 # 81f8 <malloc+0x1736>
    30fa:	4505                	li	a0,1
    30fc:	00003097          	auipc	ra,0x3
    3100:	580080e7          	jalr	1408(ra) # 667c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    3104:	86d2                	mv	a3,s4
    3106:	8626                	mv	a2,s1
    3108:	85ce                	mv	a1,s3
    310a:	00005517          	auipc	a0,0x5
    310e:	9fe50513          	addi	a0,a0,-1538 # 7b08 <malloc+0x1046>
    3112:	00004097          	auipc	ra,0x4
    3116:	8f2080e7          	jalr	-1806(ra) # 6a04 <printf>
    exit(1,"");
    311a:	00005597          	auipc	a1,0x5
    311e:	0de58593          	addi	a1,a1,222 # 81f8 <malloc+0x1736>
    3122:	4505                	li	a0,1
    3124:	00003097          	auipc	ra,0x3
    3128:	558080e7          	jalr	1368(ra) # 667c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    312c:	85ce                	mv	a1,s3
    312e:	00005517          	auipc	a0,0x5
    3132:	a0a50513          	addi	a0,a0,-1526 # 7b38 <malloc+0x1076>
    3136:	00004097          	auipc	ra,0x4
    313a:	8ce080e7          	jalr	-1842(ra) # 6a04 <printf>
    exit(1,"");
    313e:	00005597          	auipc	a1,0x5
    3142:	0ba58593          	addi	a1,a1,186 # 81f8 <malloc+0x1736>
    3146:	4505                	li	a0,1
    3148:	00003097          	auipc	ra,0x3
    314c:	534080e7          	jalr	1332(ra) # 667c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    3150:	86aa                	mv	a3,a0
    3152:	8626                	mv	a2,s1
    3154:	85ce                	mv	a1,s3
    3156:	00005517          	auipc	a0,0x5
    315a:	a1a50513          	addi	a0,a0,-1510 # 7b70 <malloc+0x10ae>
    315e:	00004097          	auipc	ra,0x4
    3162:	8a6080e7          	jalr	-1882(ra) # 6a04 <printf>
    exit(1,"");
    3166:	00005597          	auipc	a1,0x5
    316a:	09258593          	addi	a1,a1,146 # 81f8 <malloc+0x1736>
    316e:	4505                	li	a0,1
    3170:	00003097          	auipc	ra,0x3
    3174:	50c080e7          	jalr	1292(ra) # 667c <exit>

0000000000003178 <sbrkarg>:
{
    3178:	7179                	addi	sp,sp,-48
    317a:	f406                	sd	ra,40(sp)
    317c:	f022                	sd	s0,32(sp)
    317e:	ec26                	sd	s1,24(sp)
    3180:	e84a                	sd	s2,16(sp)
    3182:	e44e                	sd	s3,8(sp)
    3184:	1800                	addi	s0,sp,48
    3186:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    3188:	6505                	lui	a0,0x1
    318a:	00003097          	auipc	ra,0x3
    318e:	57a080e7          	jalr	1402(ra) # 6704 <sbrk>
    3192:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3194:	20100593          	li	a1,513
    3198:	00005517          	auipc	a0,0x5
    319c:	a0050513          	addi	a0,a0,-1536 # 7b98 <malloc+0x10d6>
    31a0:	00003097          	auipc	ra,0x3
    31a4:	51c080e7          	jalr	1308(ra) # 66bc <open>
    31a8:	84aa                	mv	s1,a0
  unlink("sbrk");
    31aa:	00005517          	auipc	a0,0x5
    31ae:	9ee50513          	addi	a0,a0,-1554 # 7b98 <malloc+0x10d6>
    31b2:	00003097          	auipc	ra,0x3
    31b6:	51a080e7          	jalr	1306(ra) # 66cc <unlink>
  if(fd < 0)  {
    31ba:	0404c163          	bltz	s1,31fc <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    31be:	6605                	lui	a2,0x1
    31c0:	85ca                	mv	a1,s2
    31c2:	8526                	mv	a0,s1
    31c4:	00003097          	auipc	ra,0x3
    31c8:	4d8080e7          	jalr	1240(ra) # 669c <write>
    31cc:	04054a63          	bltz	a0,3220 <sbrkarg+0xa8>
  close(fd);
    31d0:	8526                	mv	a0,s1
    31d2:	00003097          	auipc	ra,0x3
    31d6:	4d2080e7          	jalr	1234(ra) # 66a4 <close>
  a = sbrk(PGSIZE);
    31da:	6505                	lui	a0,0x1
    31dc:	00003097          	auipc	ra,0x3
    31e0:	528080e7          	jalr	1320(ra) # 6704 <sbrk>
  if(pipe((int *) a) != 0){
    31e4:	00003097          	auipc	ra,0x3
    31e8:	4a8080e7          	jalr	1192(ra) # 668c <pipe>
    31ec:	ed21                	bnez	a0,3244 <sbrkarg+0xcc>
}
    31ee:	70a2                	ld	ra,40(sp)
    31f0:	7402                	ld	s0,32(sp)
    31f2:	64e2                	ld	s1,24(sp)
    31f4:	6942                	ld	s2,16(sp)
    31f6:	69a2                	ld	s3,8(sp)
    31f8:	6145                	addi	sp,sp,48
    31fa:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    31fc:	85ce                	mv	a1,s3
    31fe:	00005517          	auipc	a0,0x5
    3202:	9a250513          	addi	a0,a0,-1630 # 7ba0 <malloc+0x10de>
    3206:	00003097          	auipc	ra,0x3
    320a:	7fe080e7          	jalr	2046(ra) # 6a04 <printf>
    exit(1,"");
    320e:	00005597          	auipc	a1,0x5
    3212:	fea58593          	addi	a1,a1,-22 # 81f8 <malloc+0x1736>
    3216:	4505                	li	a0,1
    3218:	00003097          	auipc	ra,0x3
    321c:	464080e7          	jalr	1124(ra) # 667c <exit>
    printf("%s: write sbrk failed\n", s);
    3220:	85ce                	mv	a1,s3
    3222:	00005517          	auipc	a0,0x5
    3226:	99650513          	addi	a0,a0,-1642 # 7bb8 <malloc+0x10f6>
    322a:	00003097          	auipc	ra,0x3
    322e:	7da080e7          	jalr	2010(ra) # 6a04 <printf>
    exit(1,"");
    3232:	00005597          	auipc	a1,0x5
    3236:	fc658593          	addi	a1,a1,-58 # 81f8 <malloc+0x1736>
    323a:	4505                	li	a0,1
    323c:	00003097          	auipc	ra,0x3
    3240:	440080e7          	jalr	1088(ra) # 667c <exit>
    printf("%s: pipe() failed\n", s);
    3244:	85ce                	mv	a1,s3
    3246:	00004517          	auipc	a0,0x4
    324a:	35250513          	addi	a0,a0,850 # 7598 <malloc+0xad6>
    324e:	00003097          	auipc	ra,0x3
    3252:	7b6080e7          	jalr	1974(ra) # 6a04 <printf>
    exit(1,"");
    3256:	00005597          	auipc	a1,0x5
    325a:	fa258593          	addi	a1,a1,-94 # 81f8 <malloc+0x1736>
    325e:	4505                	li	a0,1
    3260:	00003097          	auipc	ra,0x3
    3264:	41c080e7          	jalr	1052(ra) # 667c <exit>

0000000000003268 <argptest>:
{
    3268:	1101                	addi	sp,sp,-32
    326a:	ec06                	sd	ra,24(sp)
    326c:	e822                	sd	s0,16(sp)
    326e:	e426                	sd	s1,8(sp)
    3270:	e04a                	sd	s2,0(sp)
    3272:	1000                	addi	s0,sp,32
    3274:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3276:	4581                	li	a1,0
    3278:	00005517          	auipc	a0,0x5
    327c:	95850513          	addi	a0,a0,-1704 # 7bd0 <malloc+0x110e>
    3280:	00003097          	auipc	ra,0x3
    3284:	43c080e7          	jalr	1084(ra) # 66bc <open>
  if (fd < 0) {
    3288:	02054b63          	bltz	a0,32be <argptest+0x56>
    328c:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    328e:	4501                	li	a0,0
    3290:	00003097          	auipc	ra,0x3
    3294:	474080e7          	jalr	1140(ra) # 6704 <sbrk>
    3298:	567d                	li	a2,-1
    329a:	fff50593          	addi	a1,a0,-1
    329e:	8526                	mv	a0,s1
    32a0:	00003097          	auipc	ra,0x3
    32a4:	3f4080e7          	jalr	1012(ra) # 6694 <read>
  close(fd);
    32a8:	8526                	mv	a0,s1
    32aa:	00003097          	auipc	ra,0x3
    32ae:	3fa080e7          	jalr	1018(ra) # 66a4 <close>
}
    32b2:	60e2                	ld	ra,24(sp)
    32b4:	6442                	ld	s0,16(sp)
    32b6:	64a2                	ld	s1,8(sp)
    32b8:	6902                	ld	s2,0(sp)
    32ba:	6105                	addi	sp,sp,32
    32bc:	8082                	ret
    printf("%s: open failed\n", s);
    32be:	85ca                	mv	a1,s2
    32c0:	00004517          	auipc	a0,0x4
    32c4:	1e850513          	addi	a0,a0,488 # 74a8 <malloc+0x9e6>
    32c8:	00003097          	auipc	ra,0x3
    32cc:	73c080e7          	jalr	1852(ra) # 6a04 <printf>
    exit(1,"");
    32d0:	00005597          	auipc	a1,0x5
    32d4:	f2858593          	addi	a1,a1,-216 # 81f8 <malloc+0x1736>
    32d8:	4505                	li	a0,1
    32da:	00003097          	auipc	ra,0x3
    32de:	3a2080e7          	jalr	930(ra) # 667c <exit>

00000000000032e2 <sbrkbugs>:
{
    32e2:	1141                	addi	sp,sp,-16
    32e4:	e406                	sd	ra,8(sp)
    32e6:	e022                	sd	s0,0(sp)
    32e8:	0800                	addi	s0,sp,16
  int pid = fork();
    32ea:	00003097          	auipc	ra,0x3
    32ee:	38a080e7          	jalr	906(ra) # 6674 <fork>
  if(pid < 0){
    32f2:	02054663          	bltz	a0,331e <sbrkbugs+0x3c>
  if(pid == 0){
    32f6:	e529                	bnez	a0,3340 <sbrkbugs+0x5e>
    int sz = (uint64) sbrk(0);
    32f8:	00003097          	auipc	ra,0x3
    32fc:	40c080e7          	jalr	1036(ra) # 6704 <sbrk>
    sbrk(-sz);
    3300:	40a0053b          	negw	a0,a0
    3304:	00003097          	auipc	ra,0x3
    3308:	400080e7          	jalr	1024(ra) # 6704 <sbrk>
    exit(0,"");
    330c:	00005597          	auipc	a1,0x5
    3310:	eec58593          	addi	a1,a1,-276 # 81f8 <malloc+0x1736>
    3314:	4501                	li	a0,0
    3316:	00003097          	auipc	ra,0x3
    331a:	366080e7          	jalr	870(ra) # 667c <exit>
    printf("fork failed\n");
    331e:	00004517          	auipc	a0,0x4
    3322:	57a50513          	addi	a0,a0,1402 # 7898 <malloc+0xdd6>
    3326:	00003097          	auipc	ra,0x3
    332a:	6de080e7          	jalr	1758(ra) # 6a04 <printf>
    exit(1,"");
    332e:	00005597          	auipc	a1,0x5
    3332:	eca58593          	addi	a1,a1,-310 # 81f8 <malloc+0x1736>
    3336:	4505                	li	a0,1
    3338:	00003097          	auipc	ra,0x3
    333c:	344080e7          	jalr	836(ra) # 667c <exit>
  wait(0,0);
    3340:	4581                	li	a1,0
    3342:	4501                	li	a0,0
    3344:	00003097          	auipc	ra,0x3
    3348:	340080e7          	jalr	832(ra) # 6684 <wait>
  pid = fork();
    334c:	00003097          	auipc	ra,0x3
    3350:	328080e7          	jalr	808(ra) # 6674 <fork>
  if(pid < 0){
    3354:	02054963          	bltz	a0,3386 <sbrkbugs+0xa4>
  if(pid == 0){
    3358:	e921                	bnez	a0,33a8 <sbrkbugs+0xc6>
    int sz = (uint64) sbrk(0);
    335a:	00003097          	auipc	ra,0x3
    335e:	3aa080e7          	jalr	938(ra) # 6704 <sbrk>
    sbrk(-(sz - 3500));
    3362:	6785                	lui	a5,0x1
    3364:	dac7879b          	addiw	a5,a5,-596
    3368:	40a7853b          	subw	a0,a5,a0
    336c:	00003097          	auipc	ra,0x3
    3370:	398080e7          	jalr	920(ra) # 6704 <sbrk>
    exit(0,"");
    3374:	00005597          	auipc	a1,0x5
    3378:	e8458593          	addi	a1,a1,-380 # 81f8 <malloc+0x1736>
    337c:	4501                	li	a0,0
    337e:	00003097          	auipc	ra,0x3
    3382:	2fe080e7          	jalr	766(ra) # 667c <exit>
    printf("fork failed\n");
    3386:	00004517          	auipc	a0,0x4
    338a:	51250513          	addi	a0,a0,1298 # 7898 <malloc+0xdd6>
    338e:	00003097          	auipc	ra,0x3
    3392:	676080e7          	jalr	1654(ra) # 6a04 <printf>
    exit(1,"");
    3396:	00005597          	auipc	a1,0x5
    339a:	e6258593          	addi	a1,a1,-414 # 81f8 <malloc+0x1736>
    339e:	4505                	li	a0,1
    33a0:	00003097          	auipc	ra,0x3
    33a4:	2dc080e7          	jalr	732(ra) # 667c <exit>
  wait(0,0);
    33a8:	4581                	li	a1,0
    33aa:	4501                	li	a0,0
    33ac:	00003097          	auipc	ra,0x3
    33b0:	2d8080e7          	jalr	728(ra) # 6684 <wait>
  pid = fork();
    33b4:	00003097          	auipc	ra,0x3
    33b8:	2c0080e7          	jalr	704(ra) # 6674 <fork>
  if(pid < 0){
    33bc:	02054e63          	bltz	a0,33f8 <sbrkbugs+0x116>
  if(pid == 0){
    33c0:	ed29                	bnez	a0,341a <sbrkbugs+0x138>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    33c2:	00003097          	auipc	ra,0x3
    33c6:	342080e7          	jalr	834(ra) # 6704 <sbrk>
    33ca:	67ad                	lui	a5,0xb
    33cc:	8007879b          	addiw	a5,a5,-2048
    33d0:	40a7853b          	subw	a0,a5,a0
    33d4:	00003097          	auipc	ra,0x3
    33d8:	330080e7          	jalr	816(ra) # 6704 <sbrk>
    sbrk(-10);
    33dc:	5559                	li	a0,-10
    33de:	00003097          	auipc	ra,0x3
    33e2:	326080e7          	jalr	806(ra) # 6704 <sbrk>
    exit(0,"");
    33e6:	00005597          	auipc	a1,0x5
    33ea:	e1258593          	addi	a1,a1,-494 # 81f8 <malloc+0x1736>
    33ee:	4501                	li	a0,0
    33f0:	00003097          	auipc	ra,0x3
    33f4:	28c080e7          	jalr	652(ra) # 667c <exit>
    printf("fork failed\n");
    33f8:	00004517          	auipc	a0,0x4
    33fc:	4a050513          	addi	a0,a0,1184 # 7898 <malloc+0xdd6>
    3400:	00003097          	auipc	ra,0x3
    3404:	604080e7          	jalr	1540(ra) # 6a04 <printf>
    exit(1,"");
    3408:	00005597          	auipc	a1,0x5
    340c:	df058593          	addi	a1,a1,-528 # 81f8 <malloc+0x1736>
    3410:	4505                	li	a0,1
    3412:	00003097          	auipc	ra,0x3
    3416:	26a080e7          	jalr	618(ra) # 667c <exit>
  wait(0,0);
    341a:	4581                	li	a1,0
    341c:	4501                	li	a0,0
    341e:	00003097          	auipc	ra,0x3
    3422:	266080e7          	jalr	614(ra) # 6684 <wait>
  exit(0,"");
    3426:	00005597          	auipc	a1,0x5
    342a:	dd258593          	addi	a1,a1,-558 # 81f8 <malloc+0x1736>
    342e:	4501                	li	a0,0
    3430:	00003097          	auipc	ra,0x3
    3434:	24c080e7          	jalr	588(ra) # 667c <exit>

0000000000003438 <sbrklast>:
{
    3438:	7179                	addi	sp,sp,-48
    343a:	f406                	sd	ra,40(sp)
    343c:	f022                	sd	s0,32(sp)
    343e:	ec26                	sd	s1,24(sp)
    3440:	e84a                	sd	s2,16(sp)
    3442:	e44e                	sd	s3,8(sp)
    3444:	e052                	sd	s4,0(sp)
    3446:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    3448:	4501                	li	a0,0
    344a:	00003097          	auipc	ra,0x3
    344e:	2ba080e7          	jalr	698(ra) # 6704 <sbrk>
  if((top % 4096) != 0)
    3452:	03451793          	slli	a5,a0,0x34
    3456:	ebd9                	bnez	a5,34ec <sbrklast+0xb4>
  sbrk(4096);
    3458:	6505                	lui	a0,0x1
    345a:	00003097          	auipc	ra,0x3
    345e:	2aa080e7          	jalr	682(ra) # 6704 <sbrk>
  sbrk(10);
    3462:	4529                	li	a0,10
    3464:	00003097          	auipc	ra,0x3
    3468:	2a0080e7          	jalr	672(ra) # 6704 <sbrk>
  sbrk(-20);
    346c:	5531                	li	a0,-20
    346e:	00003097          	auipc	ra,0x3
    3472:	296080e7          	jalr	662(ra) # 6704 <sbrk>
  top = (uint64) sbrk(0);
    3476:	4501                	li	a0,0
    3478:	00003097          	auipc	ra,0x3
    347c:	28c080e7          	jalr	652(ra) # 6704 <sbrk>
    3480:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    3482:	fc050913          	addi	s2,a0,-64 # fc0 <unlinkread+0x148>
  p[0] = 'x';
    3486:	07800a13          	li	s4,120
    348a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    348e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    3492:	20200593          	li	a1,514
    3496:	854a                	mv	a0,s2
    3498:	00003097          	auipc	ra,0x3
    349c:	224080e7          	jalr	548(ra) # 66bc <open>
    34a0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    34a2:	4605                	li	a2,1
    34a4:	85ca                	mv	a1,s2
    34a6:	00003097          	auipc	ra,0x3
    34aa:	1f6080e7          	jalr	502(ra) # 669c <write>
  close(fd);
    34ae:	854e                	mv	a0,s3
    34b0:	00003097          	auipc	ra,0x3
    34b4:	1f4080e7          	jalr	500(ra) # 66a4 <close>
  fd = open(p, O_RDWR);
    34b8:	4589                	li	a1,2
    34ba:	854a                	mv	a0,s2
    34bc:	00003097          	auipc	ra,0x3
    34c0:	200080e7          	jalr	512(ra) # 66bc <open>
  p[0] = '\0';
    34c4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    34c8:	4605                	li	a2,1
    34ca:	85ca                	mv	a1,s2
    34cc:	00003097          	auipc	ra,0x3
    34d0:	1c8080e7          	jalr	456(ra) # 6694 <read>
  if(p[0] != 'x')
    34d4:	fc04c783          	lbu	a5,-64(s1)
    34d8:	03479463          	bne	a5,s4,3500 <sbrklast+0xc8>
}
    34dc:	70a2                	ld	ra,40(sp)
    34de:	7402                	ld	s0,32(sp)
    34e0:	64e2                	ld	s1,24(sp)
    34e2:	6942                	ld	s2,16(sp)
    34e4:	69a2                	ld	s3,8(sp)
    34e6:	6a02                	ld	s4,0(sp)
    34e8:	6145                	addi	sp,sp,48
    34ea:	8082                	ret
    sbrk(4096 - (top % 4096));
    34ec:	0347d513          	srli	a0,a5,0x34
    34f0:	6785                	lui	a5,0x1
    34f2:	40a7853b          	subw	a0,a5,a0
    34f6:	00003097          	auipc	ra,0x3
    34fa:	20e080e7          	jalr	526(ra) # 6704 <sbrk>
    34fe:	bfa9                	j	3458 <sbrklast+0x20>
    exit(1,"");
    3500:	00005597          	auipc	a1,0x5
    3504:	cf858593          	addi	a1,a1,-776 # 81f8 <malloc+0x1736>
    3508:	4505                	li	a0,1
    350a:	00003097          	auipc	ra,0x3
    350e:	172080e7          	jalr	370(ra) # 667c <exit>

0000000000003512 <sbrk8000>:
{
    3512:	1141                	addi	sp,sp,-16
    3514:	e406                	sd	ra,8(sp)
    3516:	e022                	sd	s0,0(sp)
    3518:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    351a:	80000537          	lui	a0,0x80000
    351e:	0511                	addi	a0,a0,4
    3520:	00003097          	auipc	ra,0x3
    3524:	1e4080e7          	jalr	484(ra) # 6704 <sbrk>
  volatile char *top = sbrk(0);
    3528:	4501                	li	a0,0
    352a:	00003097          	auipc	ra,0x3
    352e:	1da080e7          	jalr	474(ra) # 6704 <sbrk>
  *(top-1) = *(top-1) + 1;
    3532:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7ffef387>
    3536:	0785                	addi	a5,a5,1
    3538:	0ff7f793          	andi	a5,a5,255
    353c:	fef50fa3          	sb	a5,-1(a0)
}
    3540:	60a2                	ld	ra,8(sp)
    3542:	6402                	ld	s0,0(sp)
    3544:	0141                	addi	sp,sp,16
    3546:	8082                	ret

0000000000003548 <execout>:
{
    3548:	715d                	addi	sp,sp,-80
    354a:	e486                	sd	ra,72(sp)
    354c:	e0a2                	sd	s0,64(sp)
    354e:	fc26                	sd	s1,56(sp)
    3550:	f84a                	sd	s2,48(sp)
    3552:	f44e                	sd	s3,40(sp)
    3554:	f052                	sd	s4,32(sp)
    3556:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3558:	4901                	li	s2,0
    355a:	49bd                	li	s3,15
    int pid = fork();
    355c:	00003097          	auipc	ra,0x3
    3560:	118080e7          	jalr	280(ra) # 6674 <fork>
    3564:	84aa                	mv	s1,a0
    if(pid < 0){
    3566:	02054563          	bltz	a0,3590 <execout+0x48>
    } else if(pid == 0){
    356a:	c521                	beqz	a0,35b2 <execout+0x6a>
      wait((int*)0,0);
    356c:	4581                	li	a1,0
    356e:	4501                	li	a0,0
    3570:	00003097          	auipc	ra,0x3
    3574:	114080e7          	jalr	276(ra) # 6684 <wait>
  for(int avail = 0; avail < 15; avail++){
    3578:	2905                	addiw	s2,s2,1
    357a:	ff3911e3          	bne	s2,s3,355c <execout+0x14>
  exit(0,"");
    357e:	00005597          	auipc	a1,0x5
    3582:	c7a58593          	addi	a1,a1,-902 # 81f8 <malloc+0x1736>
    3586:	4501                	li	a0,0
    3588:	00003097          	auipc	ra,0x3
    358c:	0f4080e7          	jalr	244(ra) # 667c <exit>
      printf("fork failed\n");
    3590:	00004517          	auipc	a0,0x4
    3594:	30850513          	addi	a0,a0,776 # 7898 <malloc+0xdd6>
    3598:	00003097          	auipc	ra,0x3
    359c:	46c080e7          	jalr	1132(ra) # 6a04 <printf>
      exit(1,"");
    35a0:	00005597          	auipc	a1,0x5
    35a4:	c5858593          	addi	a1,a1,-936 # 81f8 <malloc+0x1736>
    35a8:	4505                	li	a0,1
    35aa:	00003097          	auipc	ra,0x3
    35ae:	0d2080e7          	jalr	210(ra) # 667c <exit>
        if(a == 0xffffffffffffffffLL)
    35b2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    35b4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    35b6:	6505                	lui	a0,0x1
    35b8:	00003097          	auipc	ra,0x3
    35bc:	14c080e7          	jalr	332(ra) # 6704 <sbrk>
        if(a == 0xffffffffffffffffLL)
    35c0:	01350763          	beq	a0,s3,35ce <execout+0x86>
        *(char*)(a + 4096 - 1) = 1;
    35c4:	6785                	lui	a5,0x1
    35c6:	953e                	add	a0,a0,a5
    35c8:	ff450fa3          	sb	s4,-1(a0) # fff <unlinkread+0x187>
      while(1){
    35cc:	b7ed                	j	35b6 <execout+0x6e>
      for(int i = 0; i < avail; i++)
    35ce:	01205a63          	blez	s2,35e2 <execout+0x9a>
        sbrk(-4096);
    35d2:	757d                	lui	a0,0xfffff
    35d4:	00003097          	auipc	ra,0x3
    35d8:	130080e7          	jalr	304(ra) # 6704 <sbrk>
      for(int i = 0; i < avail; i++)
    35dc:	2485                	addiw	s1,s1,1
    35de:	ff249ae3          	bne	s1,s2,35d2 <execout+0x8a>
      close(1);
    35e2:	4505                	li	a0,1
    35e4:	00003097          	auipc	ra,0x3
    35e8:	0c0080e7          	jalr	192(ra) # 66a4 <close>
      char *args[] = { "echo", "x", 0 };
    35ec:	00003517          	auipc	a0,0x3
    35f0:	61c50513          	addi	a0,a0,1564 # 6c08 <malloc+0x146>
    35f4:	faa43c23          	sd	a0,-72(s0)
    35f8:	00003797          	auipc	a5,0x3
    35fc:	68078793          	addi	a5,a5,1664 # 6c78 <malloc+0x1b6>
    3600:	fcf43023          	sd	a5,-64(s0)
    3604:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3608:	fb840593          	addi	a1,s0,-72
    360c:	00003097          	auipc	ra,0x3
    3610:	0a8080e7          	jalr	168(ra) # 66b4 <exec>
      exit(0,"");
    3614:	00005597          	auipc	a1,0x5
    3618:	be458593          	addi	a1,a1,-1052 # 81f8 <malloc+0x1736>
    361c:	4501                	li	a0,0
    361e:	00003097          	auipc	ra,0x3
    3622:	05e080e7          	jalr	94(ra) # 667c <exit>

0000000000003626 <fourteen>:
{
    3626:	1101                	addi	sp,sp,-32
    3628:	ec06                	sd	ra,24(sp)
    362a:	e822                	sd	s0,16(sp)
    362c:	e426                	sd	s1,8(sp)
    362e:	1000                	addi	s0,sp,32
    3630:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3632:	00004517          	auipc	a0,0x4
    3636:	77650513          	addi	a0,a0,1910 # 7da8 <malloc+0x12e6>
    363a:	00003097          	auipc	ra,0x3
    363e:	0aa080e7          	jalr	170(ra) # 66e4 <mkdir>
    3642:	e175                	bnez	a0,3726 <fourteen+0x100>
  if(mkdir("12345678901234/123456789012345") != 0){
    3644:	00004517          	auipc	a0,0x4
    3648:	5bc50513          	addi	a0,a0,1468 # 7c00 <malloc+0x113e>
    364c:	00003097          	auipc	ra,0x3
    3650:	098080e7          	jalr	152(ra) # 66e4 <mkdir>
    3654:	e97d                	bnez	a0,374a <fourteen+0x124>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3656:	20000593          	li	a1,512
    365a:	00004517          	auipc	a0,0x4
    365e:	5fe50513          	addi	a0,a0,1534 # 7c58 <malloc+0x1196>
    3662:	00003097          	auipc	ra,0x3
    3666:	05a080e7          	jalr	90(ra) # 66bc <open>
  if(fd < 0){
    366a:	10054263          	bltz	a0,376e <fourteen+0x148>
  close(fd);
    366e:	00003097          	auipc	ra,0x3
    3672:	036080e7          	jalr	54(ra) # 66a4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3676:	4581                	li	a1,0
    3678:	00004517          	auipc	a0,0x4
    367c:	65850513          	addi	a0,a0,1624 # 7cd0 <malloc+0x120e>
    3680:	00003097          	auipc	ra,0x3
    3684:	03c080e7          	jalr	60(ra) # 66bc <open>
  if(fd < 0){
    3688:	10054563          	bltz	a0,3792 <fourteen+0x16c>
  close(fd);
    368c:	00003097          	auipc	ra,0x3
    3690:	018080e7          	jalr	24(ra) # 66a4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	6ac50513          	addi	a0,a0,1708 # 7d40 <malloc+0x127e>
    369c:	00003097          	auipc	ra,0x3
    36a0:	048080e7          	jalr	72(ra) # 66e4 <mkdir>
    36a4:	10050963          	beqz	a0,37b6 <fourteen+0x190>
  if(mkdir("123456789012345/12345678901234") == 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	6f050513          	addi	a0,a0,1776 # 7d98 <malloc+0x12d6>
    36b0:	00003097          	auipc	ra,0x3
    36b4:	034080e7          	jalr	52(ra) # 66e4 <mkdir>
    36b8:	12050163          	beqz	a0,37da <fourteen+0x1b4>
  unlink("123456789012345/12345678901234");
    36bc:	00004517          	auipc	a0,0x4
    36c0:	6dc50513          	addi	a0,a0,1756 # 7d98 <malloc+0x12d6>
    36c4:	00003097          	auipc	ra,0x3
    36c8:	008080e7          	jalr	8(ra) # 66cc <unlink>
  unlink("12345678901234/12345678901234");
    36cc:	00004517          	auipc	a0,0x4
    36d0:	67450513          	addi	a0,a0,1652 # 7d40 <malloc+0x127e>
    36d4:	00003097          	auipc	ra,0x3
    36d8:	ff8080e7          	jalr	-8(ra) # 66cc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    36dc:	00004517          	auipc	a0,0x4
    36e0:	5f450513          	addi	a0,a0,1524 # 7cd0 <malloc+0x120e>
    36e4:	00003097          	auipc	ra,0x3
    36e8:	fe8080e7          	jalr	-24(ra) # 66cc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    36ec:	00004517          	auipc	a0,0x4
    36f0:	56c50513          	addi	a0,a0,1388 # 7c58 <malloc+0x1196>
    36f4:	00003097          	auipc	ra,0x3
    36f8:	fd8080e7          	jalr	-40(ra) # 66cc <unlink>
  unlink("12345678901234/123456789012345");
    36fc:	00004517          	auipc	a0,0x4
    3700:	50450513          	addi	a0,a0,1284 # 7c00 <malloc+0x113e>
    3704:	00003097          	auipc	ra,0x3
    3708:	fc8080e7          	jalr	-56(ra) # 66cc <unlink>
  unlink("12345678901234");
    370c:	00004517          	auipc	a0,0x4
    3710:	69c50513          	addi	a0,a0,1692 # 7da8 <malloc+0x12e6>
    3714:	00003097          	auipc	ra,0x3
    3718:	fb8080e7          	jalr	-72(ra) # 66cc <unlink>
}
    371c:	60e2                	ld	ra,24(sp)
    371e:	6442                	ld	s0,16(sp)
    3720:	64a2                	ld	s1,8(sp)
    3722:	6105                	addi	sp,sp,32
    3724:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3726:	85a6                	mv	a1,s1
    3728:	00004517          	auipc	a0,0x4
    372c:	4b050513          	addi	a0,a0,1200 # 7bd8 <malloc+0x1116>
    3730:	00003097          	auipc	ra,0x3
    3734:	2d4080e7          	jalr	724(ra) # 6a04 <printf>
    exit(1,"");
    3738:	00005597          	auipc	a1,0x5
    373c:	ac058593          	addi	a1,a1,-1344 # 81f8 <malloc+0x1736>
    3740:	4505                	li	a0,1
    3742:	00003097          	auipc	ra,0x3
    3746:	f3a080e7          	jalr	-198(ra) # 667c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    374a:	85a6                	mv	a1,s1
    374c:	00004517          	auipc	a0,0x4
    3750:	4d450513          	addi	a0,a0,1236 # 7c20 <malloc+0x115e>
    3754:	00003097          	auipc	ra,0x3
    3758:	2b0080e7          	jalr	688(ra) # 6a04 <printf>
    exit(1,"");
    375c:	00005597          	auipc	a1,0x5
    3760:	a9c58593          	addi	a1,a1,-1380 # 81f8 <malloc+0x1736>
    3764:	4505                	li	a0,1
    3766:	00003097          	auipc	ra,0x3
    376a:	f16080e7          	jalr	-234(ra) # 667c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    376e:	85a6                	mv	a1,s1
    3770:	00004517          	auipc	a0,0x4
    3774:	51850513          	addi	a0,a0,1304 # 7c88 <malloc+0x11c6>
    3778:	00003097          	auipc	ra,0x3
    377c:	28c080e7          	jalr	652(ra) # 6a04 <printf>
    exit(1,"");
    3780:	00005597          	auipc	a1,0x5
    3784:	a7858593          	addi	a1,a1,-1416 # 81f8 <malloc+0x1736>
    3788:	4505                	li	a0,1
    378a:	00003097          	auipc	ra,0x3
    378e:	ef2080e7          	jalr	-270(ra) # 667c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3792:	85a6                	mv	a1,s1
    3794:	00004517          	auipc	a0,0x4
    3798:	56c50513          	addi	a0,a0,1388 # 7d00 <malloc+0x123e>
    379c:	00003097          	auipc	ra,0x3
    37a0:	268080e7          	jalr	616(ra) # 6a04 <printf>
    exit(1,"");
    37a4:	00005597          	auipc	a1,0x5
    37a8:	a5458593          	addi	a1,a1,-1452 # 81f8 <malloc+0x1736>
    37ac:	4505                	li	a0,1
    37ae:	00003097          	auipc	ra,0x3
    37b2:	ece080e7          	jalr	-306(ra) # 667c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    37b6:	85a6                	mv	a1,s1
    37b8:	00004517          	auipc	a0,0x4
    37bc:	5a850513          	addi	a0,a0,1448 # 7d60 <malloc+0x129e>
    37c0:	00003097          	auipc	ra,0x3
    37c4:	244080e7          	jalr	580(ra) # 6a04 <printf>
    exit(1,"");
    37c8:	00005597          	auipc	a1,0x5
    37cc:	a3058593          	addi	a1,a1,-1488 # 81f8 <malloc+0x1736>
    37d0:	4505                	li	a0,1
    37d2:	00003097          	auipc	ra,0x3
    37d6:	eaa080e7          	jalr	-342(ra) # 667c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    37da:	85a6                	mv	a1,s1
    37dc:	00004517          	auipc	a0,0x4
    37e0:	5dc50513          	addi	a0,a0,1500 # 7db8 <malloc+0x12f6>
    37e4:	00003097          	auipc	ra,0x3
    37e8:	220080e7          	jalr	544(ra) # 6a04 <printf>
    exit(1,"");
    37ec:	00005597          	auipc	a1,0x5
    37f0:	a0c58593          	addi	a1,a1,-1524 # 81f8 <malloc+0x1736>
    37f4:	4505                	li	a0,1
    37f6:	00003097          	auipc	ra,0x3
    37fa:	e86080e7          	jalr	-378(ra) # 667c <exit>

00000000000037fe <diskfull>:
{
    37fe:	b9010113          	addi	sp,sp,-1136
    3802:	46113423          	sd	ra,1128(sp)
    3806:	46813023          	sd	s0,1120(sp)
    380a:	44913c23          	sd	s1,1112(sp)
    380e:	45213823          	sd	s2,1104(sp)
    3812:	45313423          	sd	s3,1096(sp)
    3816:	45413023          	sd	s4,1088(sp)
    381a:	43513c23          	sd	s5,1080(sp)
    381e:	43613823          	sd	s6,1072(sp)
    3822:	43713423          	sd	s7,1064(sp)
    3826:	43813023          	sd	s8,1056(sp)
    382a:	47010413          	addi	s0,sp,1136
    382e:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3830:	00004517          	auipc	a0,0x4
    3834:	5c050513          	addi	a0,a0,1472 # 7df0 <malloc+0x132e>
    3838:	00003097          	auipc	ra,0x3
    383c:	e94080e7          	jalr	-364(ra) # 66cc <unlink>
  for(fi = 0; done == 0; fi++){
    3840:	4a01                	li	s4,0
    name[0] = 'b';
    3842:	06200b13          	li	s6,98
    name[1] = 'i';
    3846:	06900a93          	li	s5,105
    name[2] = 'g';
    384a:	06700993          	li	s3,103
    384e:	10c00b93          	li	s7,268
    3852:	aabd                	j	39d0 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3854:	b9040613          	addi	a2,s0,-1136
    3858:	85e2                	mv	a1,s8
    385a:	00004517          	auipc	a0,0x4
    385e:	5a650513          	addi	a0,a0,1446 # 7e00 <malloc+0x133e>
    3862:	00003097          	auipc	ra,0x3
    3866:	1a2080e7          	jalr	418(ra) # 6a04 <printf>
      break;
    386a:	a821                	j	3882 <diskfull+0x84>
        close(fd);
    386c:	854a                	mv	a0,s2
    386e:	00003097          	auipc	ra,0x3
    3872:	e36080e7          	jalr	-458(ra) # 66a4 <close>
    close(fd);
    3876:	854a                	mv	a0,s2
    3878:	00003097          	auipc	ra,0x3
    387c:	e2c080e7          	jalr	-468(ra) # 66a4 <close>
  for(fi = 0; done == 0; fi++){
    3880:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    3882:	4481                	li	s1,0
    name[0] = 'z';
    3884:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3888:	08000993          	li	s3,128
    name[0] = 'z';
    388c:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3890:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3894:	41f4d79b          	sraiw	a5,s1,0x1f
    3898:	01b7d71b          	srliw	a4,a5,0x1b
    389c:	009707bb          	addw	a5,a4,s1
    38a0:	4057d69b          	sraiw	a3,a5,0x5
    38a4:	0306869b          	addiw	a3,a3,48
    38a8:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    38ac:	8bfd                	andi	a5,a5,31
    38ae:	9f99                	subw	a5,a5,a4
    38b0:	0307879b          	addiw	a5,a5,48
    38b4:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    38b8:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    38bc:	bb040513          	addi	a0,s0,-1104
    38c0:	00003097          	auipc	ra,0x3
    38c4:	e0c080e7          	jalr	-500(ra) # 66cc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    38c8:	60200593          	li	a1,1538
    38cc:	bb040513          	addi	a0,s0,-1104
    38d0:	00003097          	auipc	ra,0x3
    38d4:	dec080e7          	jalr	-532(ra) # 66bc <open>
    if(fd < 0)
    38d8:	00054963          	bltz	a0,38ea <diskfull+0xec>
    close(fd);
    38dc:	00003097          	auipc	ra,0x3
    38e0:	dc8080e7          	jalr	-568(ra) # 66a4 <close>
  for(int i = 0; i < nzz; i++){
    38e4:	2485                	addiw	s1,s1,1
    38e6:	fb3493e3          	bne	s1,s3,388c <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    38ea:	00004517          	auipc	a0,0x4
    38ee:	50650513          	addi	a0,a0,1286 # 7df0 <malloc+0x132e>
    38f2:	00003097          	auipc	ra,0x3
    38f6:	df2080e7          	jalr	-526(ra) # 66e4 <mkdir>
    38fa:	12050963          	beqz	a0,3a2c <diskfull+0x22e>
  unlink("diskfulldir");
    38fe:	00004517          	auipc	a0,0x4
    3902:	4f250513          	addi	a0,a0,1266 # 7df0 <malloc+0x132e>
    3906:	00003097          	auipc	ra,0x3
    390a:	dc6080e7          	jalr	-570(ra) # 66cc <unlink>
  for(int i = 0; i < nzz; i++){
    390e:	4481                	li	s1,0
    name[0] = 'z';
    3910:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3914:	08000993          	li	s3,128
    name[0] = 'z';
    3918:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    391c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3920:	41f4d79b          	sraiw	a5,s1,0x1f
    3924:	01b7d71b          	srliw	a4,a5,0x1b
    3928:	009707bb          	addw	a5,a4,s1
    392c:	4057d69b          	sraiw	a3,a5,0x5
    3930:	0306869b          	addiw	a3,a3,48
    3934:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3938:	8bfd                	andi	a5,a5,31
    393a:	9f99                	subw	a5,a5,a4
    393c:	0307879b          	addiw	a5,a5,48
    3940:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3944:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3948:	bb040513          	addi	a0,s0,-1104
    394c:	00003097          	auipc	ra,0x3
    3950:	d80080e7          	jalr	-640(ra) # 66cc <unlink>
  for(int i = 0; i < nzz; i++){
    3954:	2485                	addiw	s1,s1,1
    3956:	fd3491e3          	bne	s1,s3,3918 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    395a:	03405e63          	blez	s4,3996 <diskfull+0x198>
    395e:	4481                	li	s1,0
    name[0] = 'b';
    3960:	06200a93          	li	s5,98
    name[1] = 'i';
    3964:	06900993          	li	s3,105
    name[2] = 'g';
    3968:	06700913          	li	s2,103
    name[0] = 'b';
    396c:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3970:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3974:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3978:	0304879b          	addiw	a5,s1,48
    397c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3980:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3984:	bb040513          	addi	a0,s0,-1104
    3988:	00003097          	auipc	ra,0x3
    398c:	d44080e7          	jalr	-700(ra) # 66cc <unlink>
  for(int i = 0; i < fi; i++){
    3990:	2485                	addiw	s1,s1,1
    3992:	fd449de3          	bne	s1,s4,396c <diskfull+0x16e>
}
    3996:	46813083          	ld	ra,1128(sp)
    399a:	46013403          	ld	s0,1120(sp)
    399e:	45813483          	ld	s1,1112(sp)
    39a2:	45013903          	ld	s2,1104(sp)
    39a6:	44813983          	ld	s3,1096(sp)
    39aa:	44013a03          	ld	s4,1088(sp)
    39ae:	43813a83          	ld	s5,1080(sp)
    39b2:	43013b03          	ld	s6,1072(sp)
    39b6:	42813b83          	ld	s7,1064(sp)
    39ba:	42013c03          	ld	s8,1056(sp)
    39be:	47010113          	addi	sp,sp,1136
    39c2:	8082                	ret
    close(fd);
    39c4:	854a                	mv	a0,s2
    39c6:	00003097          	auipc	ra,0x3
    39ca:	cde080e7          	jalr	-802(ra) # 66a4 <close>
  for(fi = 0; done == 0; fi++){
    39ce:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    39d0:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    39d4:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    39d8:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    39dc:	030a079b          	addiw	a5,s4,48
    39e0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    39e4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    39e8:	b9040513          	addi	a0,s0,-1136
    39ec:	00003097          	auipc	ra,0x3
    39f0:	ce0080e7          	jalr	-800(ra) # 66cc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    39f4:	60200593          	li	a1,1538
    39f8:	b9040513          	addi	a0,s0,-1136
    39fc:	00003097          	auipc	ra,0x3
    3a00:	cc0080e7          	jalr	-832(ra) # 66bc <open>
    3a04:	892a                	mv	s2,a0
    if(fd < 0){
    3a06:	e40547e3          	bltz	a0,3854 <diskfull+0x56>
    3a0a:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3a0c:	40000613          	li	a2,1024
    3a10:	bb040593          	addi	a1,s0,-1104
    3a14:	854a                	mv	a0,s2
    3a16:	00003097          	auipc	ra,0x3
    3a1a:	c86080e7          	jalr	-890(ra) # 669c <write>
    3a1e:	40000793          	li	a5,1024
    3a22:	e4f515e3          	bne	a0,a5,386c <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3a26:	34fd                	addiw	s1,s1,-1
    3a28:	f0f5                	bnez	s1,3a0c <diskfull+0x20e>
    3a2a:	bf69                	j	39c4 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3a2c:	00004517          	auipc	a0,0x4
    3a30:	3f450513          	addi	a0,a0,1012 # 7e20 <malloc+0x135e>
    3a34:	00003097          	auipc	ra,0x3
    3a38:	fd0080e7          	jalr	-48(ra) # 6a04 <printf>
    3a3c:	b5c9                	j	38fe <diskfull+0x100>

0000000000003a3e <iputtest>:
{
    3a3e:	1101                	addi	sp,sp,-32
    3a40:	ec06                	sd	ra,24(sp)
    3a42:	e822                	sd	s0,16(sp)
    3a44:	e426                	sd	s1,8(sp)
    3a46:	1000                	addi	s0,sp,32
    3a48:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3a4a:	00004517          	auipc	a0,0x4
    3a4e:	40650513          	addi	a0,a0,1030 # 7e50 <malloc+0x138e>
    3a52:	00003097          	auipc	ra,0x3
    3a56:	c92080e7          	jalr	-878(ra) # 66e4 <mkdir>
    3a5a:	04054563          	bltz	a0,3aa4 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3a5e:	00004517          	auipc	a0,0x4
    3a62:	3f250513          	addi	a0,a0,1010 # 7e50 <malloc+0x138e>
    3a66:	00003097          	auipc	ra,0x3
    3a6a:	c86080e7          	jalr	-890(ra) # 66ec <chdir>
    3a6e:	04054d63          	bltz	a0,3ac8 <iputtest+0x8a>
  if(unlink("../iputdir") < 0){
    3a72:	00004517          	auipc	a0,0x4
    3a76:	41e50513          	addi	a0,a0,1054 # 7e90 <malloc+0x13ce>
    3a7a:	00003097          	auipc	ra,0x3
    3a7e:	c52080e7          	jalr	-942(ra) # 66cc <unlink>
    3a82:	06054563          	bltz	a0,3aec <iputtest+0xae>
  if(chdir("/") < 0){
    3a86:	00004517          	auipc	a0,0x4
    3a8a:	43a50513          	addi	a0,a0,1082 # 7ec0 <malloc+0x13fe>
    3a8e:	00003097          	auipc	ra,0x3
    3a92:	c5e080e7          	jalr	-930(ra) # 66ec <chdir>
    3a96:	06054d63          	bltz	a0,3b10 <iputtest+0xd2>
}
    3a9a:	60e2                	ld	ra,24(sp)
    3a9c:	6442                	ld	s0,16(sp)
    3a9e:	64a2                	ld	s1,8(sp)
    3aa0:	6105                	addi	sp,sp,32
    3aa2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3aa4:	85a6                	mv	a1,s1
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	3b250513          	addi	a0,a0,946 # 7e58 <malloc+0x1396>
    3aae:	00003097          	auipc	ra,0x3
    3ab2:	f56080e7          	jalr	-170(ra) # 6a04 <printf>
    exit(1,"");
    3ab6:	00004597          	auipc	a1,0x4
    3aba:	74258593          	addi	a1,a1,1858 # 81f8 <malloc+0x1736>
    3abe:	4505                	li	a0,1
    3ac0:	00003097          	auipc	ra,0x3
    3ac4:	bbc080e7          	jalr	-1092(ra) # 667c <exit>
    printf("%s: chdir iputdir failed\n", s);
    3ac8:	85a6                	mv	a1,s1
    3aca:	00004517          	auipc	a0,0x4
    3ace:	3a650513          	addi	a0,a0,934 # 7e70 <malloc+0x13ae>
    3ad2:	00003097          	auipc	ra,0x3
    3ad6:	f32080e7          	jalr	-206(ra) # 6a04 <printf>
    exit(1,"");
    3ada:	00004597          	auipc	a1,0x4
    3ade:	71e58593          	addi	a1,a1,1822 # 81f8 <malloc+0x1736>
    3ae2:	4505                	li	a0,1
    3ae4:	00003097          	auipc	ra,0x3
    3ae8:	b98080e7          	jalr	-1128(ra) # 667c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3aec:	85a6                	mv	a1,s1
    3aee:	00004517          	auipc	a0,0x4
    3af2:	3b250513          	addi	a0,a0,946 # 7ea0 <malloc+0x13de>
    3af6:	00003097          	auipc	ra,0x3
    3afa:	f0e080e7          	jalr	-242(ra) # 6a04 <printf>
    exit(1,"");
    3afe:	00004597          	auipc	a1,0x4
    3b02:	6fa58593          	addi	a1,a1,1786 # 81f8 <malloc+0x1736>
    3b06:	4505                	li	a0,1
    3b08:	00003097          	auipc	ra,0x3
    3b0c:	b74080e7          	jalr	-1164(ra) # 667c <exit>
    printf("%s: chdir / failed\n", s);
    3b10:	85a6                	mv	a1,s1
    3b12:	00004517          	auipc	a0,0x4
    3b16:	3b650513          	addi	a0,a0,950 # 7ec8 <malloc+0x1406>
    3b1a:	00003097          	auipc	ra,0x3
    3b1e:	eea080e7          	jalr	-278(ra) # 6a04 <printf>
    exit(1,"");
    3b22:	00004597          	auipc	a1,0x4
    3b26:	6d658593          	addi	a1,a1,1750 # 81f8 <malloc+0x1736>
    3b2a:	4505                	li	a0,1
    3b2c:	00003097          	auipc	ra,0x3
    3b30:	b50080e7          	jalr	-1200(ra) # 667c <exit>

0000000000003b34 <exitiputtest>:
{
    3b34:	7179                	addi	sp,sp,-48
    3b36:	f406                	sd	ra,40(sp)
    3b38:	f022                	sd	s0,32(sp)
    3b3a:	ec26                	sd	s1,24(sp)
    3b3c:	1800                	addi	s0,sp,48
    3b3e:	84aa                	mv	s1,a0
  pid = fork();
    3b40:	00003097          	auipc	ra,0x3
    3b44:	b34080e7          	jalr	-1228(ra) # 6674 <fork>
  if(pid < 0){
    3b48:	04054a63          	bltz	a0,3b9c <exitiputtest+0x68>
  if(pid == 0){
    3b4c:	e165                	bnez	a0,3c2c <exitiputtest+0xf8>
    if(mkdir("iputdir") < 0){
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	30250513          	addi	a0,a0,770 # 7e50 <malloc+0x138e>
    3b56:	00003097          	auipc	ra,0x3
    3b5a:	b8e080e7          	jalr	-1138(ra) # 66e4 <mkdir>
    3b5e:	06054163          	bltz	a0,3bc0 <exitiputtest+0x8c>
    if(chdir("iputdir") < 0){
    3b62:	00004517          	auipc	a0,0x4
    3b66:	2ee50513          	addi	a0,a0,750 # 7e50 <malloc+0x138e>
    3b6a:	00003097          	auipc	ra,0x3
    3b6e:	b82080e7          	jalr	-1150(ra) # 66ec <chdir>
    3b72:	06054963          	bltz	a0,3be4 <exitiputtest+0xb0>
    if(unlink("../iputdir") < 0){
    3b76:	00004517          	auipc	a0,0x4
    3b7a:	31a50513          	addi	a0,a0,794 # 7e90 <malloc+0x13ce>
    3b7e:	00003097          	auipc	ra,0x3
    3b82:	b4e080e7          	jalr	-1202(ra) # 66cc <unlink>
    3b86:	08054163          	bltz	a0,3c08 <exitiputtest+0xd4>
    exit(0,"");
    3b8a:	00004597          	auipc	a1,0x4
    3b8e:	66e58593          	addi	a1,a1,1646 # 81f8 <malloc+0x1736>
    3b92:	4501                	li	a0,0
    3b94:	00003097          	auipc	ra,0x3
    3b98:	ae8080e7          	jalr	-1304(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    3b9c:	85a6                	mv	a1,s1
    3b9e:	00004517          	auipc	a0,0x4
    3ba2:	8f250513          	addi	a0,a0,-1806 # 7490 <malloc+0x9ce>
    3ba6:	00003097          	auipc	ra,0x3
    3baa:	e5e080e7          	jalr	-418(ra) # 6a04 <printf>
    exit(1,"");
    3bae:	00004597          	auipc	a1,0x4
    3bb2:	64a58593          	addi	a1,a1,1610 # 81f8 <malloc+0x1736>
    3bb6:	4505                	li	a0,1
    3bb8:	00003097          	auipc	ra,0x3
    3bbc:	ac4080e7          	jalr	-1340(ra) # 667c <exit>
      printf("%s: mkdir failed\n", s);
    3bc0:	85a6                	mv	a1,s1
    3bc2:	00004517          	auipc	a0,0x4
    3bc6:	29650513          	addi	a0,a0,662 # 7e58 <malloc+0x1396>
    3bca:	00003097          	auipc	ra,0x3
    3bce:	e3a080e7          	jalr	-454(ra) # 6a04 <printf>
      exit(1,"");
    3bd2:	00004597          	auipc	a1,0x4
    3bd6:	62658593          	addi	a1,a1,1574 # 81f8 <malloc+0x1736>
    3bda:	4505                	li	a0,1
    3bdc:	00003097          	auipc	ra,0x3
    3be0:	aa0080e7          	jalr	-1376(ra) # 667c <exit>
      printf("%s: child chdir failed\n", s);
    3be4:	85a6                	mv	a1,s1
    3be6:	00004517          	auipc	a0,0x4
    3bea:	2fa50513          	addi	a0,a0,762 # 7ee0 <malloc+0x141e>
    3bee:	00003097          	auipc	ra,0x3
    3bf2:	e16080e7          	jalr	-490(ra) # 6a04 <printf>
      exit(1,"");
    3bf6:	00004597          	auipc	a1,0x4
    3bfa:	60258593          	addi	a1,a1,1538 # 81f8 <malloc+0x1736>
    3bfe:	4505                	li	a0,1
    3c00:	00003097          	auipc	ra,0x3
    3c04:	a7c080e7          	jalr	-1412(ra) # 667c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3c08:	85a6                	mv	a1,s1
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	29650513          	addi	a0,a0,662 # 7ea0 <malloc+0x13de>
    3c12:	00003097          	auipc	ra,0x3
    3c16:	df2080e7          	jalr	-526(ra) # 6a04 <printf>
      exit(1,"");
    3c1a:	00004597          	auipc	a1,0x4
    3c1e:	5de58593          	addi	a1,a1,1502 # 81f8 <malloc+0x1736>
    3c22:	4505                	li	a0,1
    3c24:	00003097          	auipc	ra,0x3
    3c28:	a58080e7          	jalr	-1448(ra) # 667c <exit>
  wait(&xstatus,0);
    3c2c:	4581                	li	a1,0
    3c2e:	fdc40513          	addi	a0,s0,-36
    3c32:	00003097          	auipc	ra,0x3
    3c36:	a52080e7          	jalr	-1454(ra) # 6684 <wait>
  exit(xstatus,"");
    3c3a:	00004597          	auipc	a1,0x4
    3c3e:	5be58593          	addi	a1,a1,1470 # 81f8 <malloc+0x1736>
    3c42:	fdc42503          	lw	a0,-36(s0)
    3c46:	00003097          	auipc	ra,0x3
    3c4a:	a36080e7          	jalr	-1482(ra) # 667c <exit>

0000000000003c4e <dirtest>:
{
    3c4e:	1101                	addi	sp,sp,-32
    3c50:	ec06                	sd	ra,24(sp)
    3c52:	e822                	sd	s0,16(sp)
    3c54:	e426                	sd	s1,8(sp)
    3c56:	1000                	addi	s0,sp,32
    3c58:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3c5a:	00004517          	auipc	a0,0x4
    3c5e:	29e50513          	addi	a0,a0,670 # 7ef8 <malloc+0x1436>
    3c62:	00003097          	auipc	ra,0x3
    3c66:	a82080e7          	jalr	-1406(ra) # 66e4 <mkdir>
    3c6a:	04054563          	bltz	a0,3cb4 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3c6e:	00004517          	auipc	a0,0x4
    3c72:	28a50513          	addi	a0,a0,650 # 7ef8 <malloc+0x1436>
    3c76:	00003097          	auipc	ra,0x3
    3c7a:	a76080e7          	jalr	-1418(ra) # 66ec <chdir>
    3c7e:	04054d63          	bltz	a0,3cd8 <dirtest+0x8a>
  if(chdir("..") < 0){
    3c82:	00004517          	auipc	a0,0x4
    3c86:	29650513          	addi	a0,a0,662 # 7f18 <malloc+0x1456>
    3c8a:	00003097          	auipc	ra,0x3
    3c8e:	a62080e7          	jalr	-1438(ra) # 66ec <chdir>
    3c92:	06054563          	bltz	a0,3cfc <dirtest+0xae>
  if(unlink("dir0") < 0){
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	26250513          	addi	a0,a0,610 # 7ef8 <malloc+0x1436>
    3c9e:	00003097          	auipc	ra,0x3
    3ca2:	a2e080e7          	jalr	-1490(ra) # 66cc <unlink>
    3ca6:	06054d63          	bltz	a0,3d20 <dirtest+0xd2>
}
    3caa:	60e2                	ld	ra,24(sp)
    3cac:	6442                	ld	s0,16(sp)
    3cae:	64a2                	ld	s1,8(sp)
    3cb0:	6105                	addi	sp,sp,32
    3cb2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3cb4:	85a6                	mv	a1,s1
    3cb6:	00004517          	auipc	a0,0x4
    3cba:	1a250513          	addi	a0,a0,418 # 7e58 <malloc+0x1396>
    3cbe:	00003097          	auipc	ra,0x3
    3cc2:	d46080e7          	jalr	-698(ra) # 6a04 <printf>
    exit(1,"");
    3cc6:	00004597          	auipc	a1,0x4
    3cca:	53258593          	addi	a1,a1,1330 # 81f8 <malloc+0x1736>
    3cce:	4505                	li	a0,1
    3cd0:	00003097          	auipc	ra,0x3
    3cd4:	9ac080e7          	jalr	-1620(ra) # 667c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cd8:	85a6                	mv	a1,s1
    3cda:	00004517          	auipc	a0,0x4
    3cde:	22650513          	addi	a0,a0,550 # 7f00 <malloc+0x143e>
    3ce2:	00003097          	auipc	ra,0x3
    3ce6:	d22080e7          	jalr	-734(ra) # 6a04 <printf>
    exit(1,"");
    3cea:	00004597          	auipc	a1,0x4
    3cee:	50e58593          	addi	a1,a1,1294 # 81f8 <malloc+0x1736>
    3cf2:	4505                	li	a0,1
    3cf4:	00003097          	auipc	ra,0x3
    3cf8:	988080e7          	jalr	-1656(ra) # 667c <exit>
    printf("%s: chdir .. failed\n", s);
    3cfc:	85a6                	mv	a1,s1
    3cfe:	00004517          	auipc	a0,0x4
    3d02:	22250513          	addi	a0,a0,546 # 7f20 <malloc+0x145e>
    3d06:	00003097          	auipc	ra,0x3
    3d0a:	cfe080e7          	jalr	-770(ra) # 6a04 <printf>
    exit(1,"");
    3d0e:	00004597          	auipc	a1,0x4
    3d12:	4ea58593          	addi	a1,a1,1258 # 81f8 <malloc+0x1736>
    3d16:	4505                	li	a0,1
    3d18:	00003097          	auipc	ra,0x3
    3d1c:	964080e7          	jalr	-1692(ra) # 667c <exit>
    printf("%s: unlink dir0 failed\n", s);
    3d20:	85a6                	mv	a1,s1
    3d22:	00004517          	auipc	a0,0x4
    3d26:	21650513          	addi	a0,a0,534 # 7f38 <malloc+0x1476>
    3d2a:	00003097          	auipc	ra,0x3
    3d2e:	cda080e7          	jalr	-806(ra) # 6a04 <printf>
    exit(1,"");
    3d32:	00004597          	auipc	a1,0x4
    3d36:	4c658593          	addi	a1,a1,1222 # 81f8 <malloc+0x1736>
    3d3a:	4505                	li	a0,1
    3d3c:	00003097          	auipc	ra,0x3
    3d40:	940080e7          	jalr	-1728(ra) # 667c <exit>

0000000000003d44 <subdir>:
{
    3d44:	1101                	addi	sp,sp,-32
    3d46:	ec06                	sd	ra,24(sp)
    3d48:	e822                	sd	s0,16(sp)
    3d4a:	e426                	sd	s1,8(sp)
    3d4c:	e04a                	sd	s2,0(sp)
    3d4e:	1000                	addi	s0,sp,32
    3d50:	892a                	mv	s2,a0
  unlink("ff");
    3d52:	00004517          	auipc	a0,0x4
    3d56:	32e50513          	addi	a0,a0,814 # 8080 <malloc+0x15be>
    3d5a:	00003097          	auipc	ra,0x3
    3d5e:	972080e7          	jalr	-1678(ra) # 66cc <unlink>
  if(mkdir("dd") != 0){
    3d62:	00004517          	auipc	a0,0x4
    3d66:	1ee50513          	addi	a0,a0,494 # 7f50 <malloc+0x148e>
    3d6a:	00003097          	auipc	ra,0x3
    3d6e:	97a080e7          	jalr	-1670(ra) # 66e4 <mkdir>
    3d72:	38051663          	bnez	a0,40fe <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3d76:	20200593          	li	a1,514
    3d7a:	00004517          	auipc	a0,0x4
    3d7e:	1f650513          	addi	a0,a0,502 # 7f70 <malloc+0x14ae>
    3d82:	00003097          	auipc	ra,0x3
    3d86:	93a080e7          	jalr	-1734(ra) # 66bc <open>
    3d8a:	84aa                	mv	s1,a0
  if(fd < 0){
    3d8c:	38054b63          	bltz	a0,4122 <subdir+0x3de>
  write(fd, "ff", 2);
    3d90:	4609                	li	a2,2
    3d92:	00004597          	auipc	a1,0x4
    3d96:	2ee58593          	addi	a1,a1,750 # 8080 <malloc+0x15be>
    3d9a:	00003097          	auipc	ra,0x3
    3d9e:	902080e7          	jalr	-1790(ra) # 669c <write>
  close(fd);
    3da2:	8526                	mv	a0,s1
    3da4:	00003097          	auipc	ra,0x3
    3da8:	900080e7          	jalr	-1792(ra) # 66a4 <close>
  if(unlink("dd") >= 0){
    3dac:	00004517          	auipc	a0,0x4
    3db0:	1a450513          	addi	a0,a0,420 # 7f50 <malloc+0x148e>
    3db4:	00003097          	auipc	ra,0x3
    3db8:	918080e7          	jalr	-1768(ra) # 66cc <unlink>
    3dbc:	38055563          	bgez	a0,4146 <subdir+0x402>
  if(mkdir("/dd/dd") != 0){
    3dc0:	00004517          	auipc	a0,0x4
    3dc4:	20850513          	addi	a0,a0,520 # 7fc8 <malloc+0x1506>
    3dc8:	00003097          	auipc	ra,0x3
    3dcc:	91c080e7          	jalr	-1764(ra) # 66e4 <mkdir>
    3dd0:	38051d63          	bnez	a0,416a <subdir+0x426>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3dd4:	20200593          	li	a1,514
    3dd8:	00004517          	auipc	a0,0x4
    3ddc:	21850513          	addi	a0,a0,536 # 7ff0 <malloc+0x152e>
    3de0:	00003097          	auipc	ra,0x3
    3de4:	8dc080e7          	jalr	-1828(ra) # 66bc <open>
    3de8:	84aa                	mv	s1,a0
  if(fd < 0){
    3dea:	3a054263          	bltz	a0,418e <subdir+0x44a>
  write(fd, "FF", 2);
    3dee:	4609                	li	a2,2
    3df0:	00004597          	auipc	a1,0x4
    3df4:	23058593          	addi	a1,a1,560 # 8020 <malloc+0x155e>
    3df8:	00003097          	auipc	ra,0x3
    3dfc:	8a4080e7          	jalr	-1884(ra) # 669c <write>
  close(fd);
    3e00:	8526                	mv	a0,s1
    3e02:	00003097          	auipc	ra,0x3
    3e06:	8a2080e7          	jalr	-1886(ra) # 66a4 <close>
  fd = open("dd/dd/../ff", 0);
    3e0a:	4581                	li	a1,0
    3e0c:	00004517          	auipc	a0,0x4
    3e10:	21c50513          	addi	a0,a0,540 # 8028 <malloc+0x1566>
    3e14:	00003097          	auipc	ra,0x3
    3e18:	8a8080e7          	jalr	-1880(ra) # 66bc <open>
    3e1c:	84aa                	mv	s1,a0
  if(fd < 0){
    3e1e:	38054a63          	bltz	a0,41b2 <subdir+0x46e>
  cc = read(fd, buf, sizeof(buf));
    3e22:	660d                	lui	a2,0x3
    3e24:	0000a597          	auipc	a1,0xa
    3e28:	e5458593          	addi	a1,a1,-428 # dc78 <buf>
    3e2c:	00003097          	auipc	ra,0x3
    3e30:	868080e7          	jalr	-1944(ra) # 6694 <read>
  if(cc != 2 || buf[0] != 'f'){
    3e34:	4789                	li	a5,2
    3e36:	3af51063          	bne	a0,a5,41d6 <subdir+0x492>
    3e3a:	0000a717          	auipc	a4,0xa
    3e3e:	e3e74703          	lbu	a4,-450(a4) # dc78 <buf>
    3e42:	06600793          	li	a5,102
    3e46:	38f71863          	bne	a4,a5,41d6 <subdir+0x492>
  close(fd);
    3e4a:	8526                	mv	a0,s1
    3e4c:	00003097          	auipc	ra,0x3
    3e50:	858080e7          	jalr	-1960(ra) # 66a4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3e54:	00004597          	auipc	a1,0x4
    3e58:	22458593          	addi	a1,a1,548 # 8078 <malloc+0x15b6>
    3e5c:	00004517          	auipc	a0,0x4
    3e60:	19450513          	addi	a0,a0,404 # 7ff0 <malloc+0x152e>
    3e64:	00003097          	auipc	ra,0x3
    3e68:	878080e7          	jalr	-1928(ra) # 66dc <link>
    3e6c:	38051763          	bnez	a0,41fa <subdir+0x4b6>
  if(unlink("dd/dd/ff") != 0){
    3e70:	00004517          	auipc	a0,0x4
    3e74:	18050513          	addi	a0,a0,384 # 7ff0 <malloc+0x152e>
    3e78:	00003097          	auipc	ra,0x3
    3e7c:	854080e7          	jalr	-1964(ra) # 66cc <unlink>
    3e80:	38051f63          	bnez	a0,421e <subdir+0x4da>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3e84:	4581                	li	a1,0
    3e86:	00004517          	auipc	a0,0x4
    3e8a:	16a50513          	addi	a0,a0,362 # 7ff0 <malloc+0x152e>
    3e8e:	00003097          	auipc	ra,0x3
    3e92:	82e080e7          	jalr	-2002(ra) # 66bc <open>
    3e96:	3a055663          	bgez	a0,4242 <subdir+0x4fe>
  if(chdir("dd") != 0){
    3e9a:	00004517          	auipc	a0,0x4
    3e9e:	0b650513          	addi	a0,a0,182 # 7f50 <malloc+0x148e>
    3ea2:	00003097          	auipc	ra,0x3
    3ea6:	84a080e7          	jalr	-1974(ra) # 66ec <chdir>
    3eaa:	3a051e63          	bnez	a0,4266 <subdir+0x522>
  if(chdir("dd/../../dd") != 0){
    3eae:	00004517          	auipc	a0,0x4
    3eb2:	26250513          	addi	a0,a0,610 # 8110 <malloc+0x164e>
    3eb6:	00003097          	auipc	ra,0x3
    3eba:	836080e7          	jalr	-1994(ra) # 66ec <chdir>
    3ebe:	3c051663          	bnez	a0,428a <subdir+0x546>
  if(chdir("dd/../../../dd") != 0){
    3ec2:	00004517          	auipc	a0,0x4
    3ec6:	27e50513          	addi	a0,a0,638 # 8140 <malloc+0x167e>
    3eca:	00003097          	auipc	ra,0x3
    3ece:	822080e7          	jalr	-2014(ra) # 66ec <chdir>
    3ed2:	3c051e63          	bnez	a0,42ae <subdir+0x56a>
  if(chdir("./..") != 0){
    3ed6:	00004517          	auipc	a0,0x4
    3eda:	29a50513          	addi	a0,a0,666 # 8170 <malloc+0x16ae>
    3ede:	00003097          	auipc	ra,0x3
    3ee2:	80e080e7          	jalr	-2034(ra) # 66ec <chdir>
    3ee6:	3e051663          	bnez	a0,42d2 <subdir+0x58e>
  fd = open("dd/dd/ffff", 0);
    3eea:	4581                	li	a1,0
    3eec:	00004517          	auipc	a0,0x4
    3ef0:	18c50513          	addi	a0,a0,396 # 8078 <malloc+0x15b6>
    3ef4:	00002097          	auipc	ra,0x2
    3ef8:	7c8080e7          	jalr	1992(ra) # 66bc <open>
    3efc:	84aa                	mv	s1,a0
  if(fd < 0){
    3efe:	3e054c63          	bltz	a0,42f6 <subdir+0x5b2>
  if(read(fd, buf, sizeof(buf)) != 2){
    3f02:	660d                	lui	a2,0x3
    3f04:	0000a597          	auipc	a1,0xa
    3f08:	d7458593          	addi	a1,a1,-652 # dc78 <buf>
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	788080e7          	jalr	1928(ra) # 6694 <read>
    3f14:	4789                	li	a5,2
    3f16:	40f51263          	bne	a0,a5,431a <subdir+0x5d6>
  close(fd);
    3f1a:	8526                	mv	a0,s1
    3f1c:	00002097          	auipc	ra,0x2
    3f20:	788080e7          	jalr	1928(ra) # 66a4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3f24:	4581                	li	a1,0
    3f26:	00004517          	auipc	a0,0x4
    3f2a:	0ca50513          	addi	a0,a0,202 # 7ff0 <malloc+0x152e>
    3f2e:	00002097          	auipc	ra,0x2
    3f32:	78e080e7          	jalr	1934(ra) # 66bc <open>
    3f36:	40055463          	bgez	a0,433e <subdir+0x5fa>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f3a:	20200593          	li	a1,514
    3f3e:	00004517          	auipc	a0,0x4
    3f42:	2c250513          	addi	a0,a0,706 # 8200 <malloc+0x173e>
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	776080e7          	jalr	1910(ra) # 66bc <open>
    3f4e:	40055a63          	bgez	a0,4362 <subdir+0x61e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3f52:	20200593          	li	a1,514
    3f56:	00004517          	auipc	a0,0x4
    3f5a:	2da50513          	addi	a0,a0,730 # 8230 <malloc+0x176e>
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	75e080e7          	jalr	1886(ra) # 66bc <open>
    3f66:	42055063          	bgez	a0,4386 <subdir+0x642>
  if(open("dd", O_CREATE) >= 0){
    3f6a:	20000593          	li	a1,512
    3f6e:	00004517          	auipc	a0,0x4
    3f72:	fe250513          	addi	a0,a0,-30 # 7f50 <malloc+0x148e>
    3f76:	00002097          	auipc	ra,0x2
    3f7a:	746080e7          	jalr	1862(ra) # 66bc <open>
    3f7e:	42055663          	bgez	a0,43aa <subdir+0x666>
  if(open("dd", O_RDWR) >= 0){
    3f82:	4589                	li	a1,2
    3f84:	00004517          	auipc	a0,0x4
    3f88:	fcc50513          	addi	a0,a0,-52 # 7f50 <malloc+0x148e>
    3f8c:	00002097          	auipc	ra,0x2
    3f90:	730080e7          	jalr	1840(ra) # 66bc <open>
    3f94:	42055d63          	bgez	a0,43ce <subdir+0x68a>
  if(open("dd", O_WRONLY) >= 0){
    3f98:	4585                	li	a1,1
    3f9a:	00004517          	auipc	a0,0x4
    3f9e:	fb650513          	addi	a0,a0,-74 # 7f50 <malloc+0x148e>
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	71a080e7          	jalr	1818(ra) # 66bc <open>
    3faa:	44055463          	bgez	a0,43f2 <subdir+0x6ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3fae:	00004597          	auipc	a1,0x4
    3fb2:	31258593          	addi	a1,a1,786 # 82c0 <malloc+0x17fe>
    3fb6:	00004517          	auipc	a0,0x4
    3fba:	24a50513          	addi	a0,a0,586 # 8200 <malloc+0x173e>
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	71e080e7          	jalr	1822(ra) # 66dc <link>
    3fc6:	44050863          	beqz	a0,4416 <subdir+0x6d2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3fca:	00004597          	auipc	a1,0x4
    3fce:	2f658593          	addi	a1,a1,758 # 82c0 <malloc+0x17fe>
    3fd2:	00004517          	auipc	a0,0x4
    3fd6:	25e50513          	addi	a0,a0,606 # 8230 <malloc+0x176e>
    3fda:	00002097          	auipc	ra,0x2
    3fde:	702080e7          	jalr	1794(ra) # 66dc <link>
    3fe2:	44050c63          	beqz	a0,443a <subdir+0x6f6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3fe6:	00004597          	auipc	a1,0x4
    3fea:	09258593          	addi	a1,a1,146 # 8078 <malloc+0x15b6>
    3fee:	00004517          	auipc	a0,0x4
    3ff2:	f8250513          	addi	a0,a0,-126 # 7f70 <malloc+0x14ae>
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	6e6080e7          	jalr	1766(ra) # 66dc <link>
    3ffe:	46050063          	beqz	a0,445e <subdir+0x71a>
  if(mkdir("dd/ff/ff") == 0){
    4002:	00004517          	auipc	a0,0x4
    4006:	1fe50513          	addi	a0,a0,510 # 8200 <malloc+0x173e>
    400a:	00002097          	auipc	ra,0x2
    400e:	6da080e7          	jalr	1754(ra) # 66e4 <mkdir>
    4012:	46050863          	beqz	a0,4482 <subdir+0x73e>
  if(mkdir("dd/xx/ff") == 0){
    4016:	00004517          	auipc	a0,0x4
    401a:	21a50513          	addi	a0,a0,538 # 8230 <malloc+0x176e>
    401e:	00002097          	auipc	ra,0x2
    4022:	6c6080e7          	jalr	1734(ra) # 66e4 <mkdir>
    4026:	48050063          	beqz	a0,44a6 <subdir+0x762>
  if(mkdir("dd/dd/ffff") == 0){
    402a:	00004517          	auipc	a0,0x4
    402e:	04e50513          	addi	a0,a0,78 # 8078 <malloc+0x15b6>
    4032:	00002097          	auipc	ra,0x2
    4036:	6b2080e7          	jalr	1714(ra) # 66e4 <mkdir>
    403a:	48050863          	beqz	a0,44ca <subdir+0x786>
  if(unlink("dd/xx/ff") == 0){
    403e:	00004517          	auipc	a0,0x4
    4042:	1f250513          	addi	a0,a0,498 # 8230 <malloc+0x176e>
    4046:	00002097          	auipc	ra,0x2
    404a:	686080e7          	jalr	1670(ra) # 66cc <unlink>
    404e:	4a050063          	beqz	a0,44ee <subdir+0x7aa>
  if(unlink("dd/ff/ff") == 0){
    4052:	00004517          	auipc	a0,0x4
    4056:	1ae50513          	addi	a0,a0,430 # 8200 <malloc+0x173e>
    405a:	00002097          	auipc	ra,0x2
    405e:	672080e7          	jalr	1650(ra) # 66cc <unlink>
    4062:	4a050863          	beqz	a0,4512 <subdir+0x7ce>
  if(chdir("dd/ff") == 0){
    4066:	00004517          	auipc	a0,0x4
    406a:	f0a50513          	addi	a0,a0,-246 # 7f70 <malloc+0x14ae>
    406e:	00002097          	auipc	ra,0x2
    4072:	67e080e7          	jalr	1662(ra) # 66ec <chdir>
    4076:	4c050063          	beqz	a0,4536 <subdir+0x7f2>
  if(chdir("dd/xx") == 0){
    407a:	00004517          	auipc	a0,0x4
    407e:	39650513          	addi	a0,a0,918 # 8410 <malloc+0x194e>
    4082:	00002097          	auipc	ra,0x2
    4086:	66a080e7          	jalr	1642(ra) # 66ec <chdir>
    408a:	4c050863          	beqz	a0,455a <subdir+0x816>
  if(unlink("dd/dd/ffff") != 0){
    408e:	00004517          	auipc	a0,0x4
    4092:	fea50513          	addi	a0,a0,-22 # 8078 <malloc+0x15b6>
    4096:	00002097          	auipc	ra,0x2
    409a:	636080e7          	jalr	1590(ra) # 66cc <unlink>
    409e:	4e051063          	bnez	a0,457e <subdir+0x83a>
  if(unlink("dd/ff") != 0){
    40a2:	00004517          	auipc	a0,0x4
    40a6:	ece50513          	addi	a0,a0,-306 # 7f70 <malloc+0x14ae>
    40aa:	00002097          	auipc	ra,0x2
    40ae:	622080e7          	jalr	1570(ra) # 66cc <unlink>
    40b2:	4e051863          	bnez	a0,45a2 <subdir+0x85e>
  if(unlink("dd") == 0){
    40b6:	00004517          	auipc	a0,0x4
    40ba:	e9a50513          	addi	a0,a0,-358 # 7f50 <malloc+0x148e>
    40be:	00002097          	auipc	ra,0x2
    40c2:	60e080e7          	jalr	1550(ra) # 66cc <unlink>
    40c6:	50050063          	beqz	a0,45c6 <subdir+0x882>
  if(unlink("dd/dd") < 0){
    40ca:	00004517          	auipc	a0,0x4
    40ce:	3b650513          	addi	a0,a0,950 # 8480 <malloc+0x19be>
    40d2:	00002097          	auipc	ra,0x2
    40d6:	5fa080e7          	jalr	1530(ra) # 66cc <unlink>
    40da:	50054863          	bltz	a0,45ea <subdir+0x8a6>
  if(unlink("dd") < 0){
    40de:	00004517          	auipc	a0,0x4
    40e2:	e7250513          	addi	a0,a0,-398 # 7f50 <malloc+0x148e>
    40e6:	00002097          	auipc	ra,0x2
    40ea:	5e6080e7          	jalr	1510(ra) # 66cc <unlink>
    40ee:	52054063          	bltz	a0,460e <subdir+0x8ca>
}
    40f2:	60e2                	ld	ra,24(sp)
    40f4:	6442                	ld	s0,16(sp)
    40f6:	64a2                	ld	s1,8(sp)
    40f8:	6902                	ld	s2,0(sp)
    40fa:	6105                	addi	sp,sp,32
    40fc:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    40fe:	85ca                	mv	a1,s2
    4100:	00004517          	auipc	a0,0x4
    4104:	e5850513          	addi	a0,a0,-424 # 7f58 <malloc+0x1496>
    4108:	00003097          	auipc	ra,0x3
    410c:	8fc080e7          	jalr	-1796(ra) # 6a04 <printf>
    exit(1,"");
    4110:	00004597          	auipc	a1,0x4
    4114:	0e858593          	addi	a1,a1,232 # 81f8 <malloc+0x1736>
    4118:	4505                	li	a0,1
    411a:	00002097          	auipc	ra,0x2
    411e:	562080e7          	jalr	1378(ra) # 667c <exit>
    printf("%s: create dd/ff failed\n", s);
    4122:	85ca                	mv	a1,s2
    4124:	00004517          	auipc	a0,0x4
    4128:	e5450513          	addi	a0,a0,-428 # 7f78 <malloc+0x14b6>
    412c:	00003097          	auipc	ra,0x3
    4130:	8d8080e7          	jalr	-1832(ra) # 6a04 <printf>
    exit(1,"");
    4134:	00004597          	auipc	a1,0x4
    4138:	0c458593          	addi	a1,a1,196 # 81f8 <malloc+0x1736>
    413c:	4505                	li	a0,1
    413e:	00002097          	auipc	ra,0x2
    4142:	53e080e7          	jalr	1342(ra) # 667c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    4146:	85ca                	mv	a1,s2
    4148:	00004517          	auipc	a0,0x4
    414c:	e5050513          	addi	a0,a0,-432 # 7f98 <malloc+0x14d6>
    4150:	00003097          	auipc	ra,0x3
    4154:	8b4080e7          	jalr	-1868(ra) # 6a04 <printf>
    exit(1,"");
    4158:	00004597          	auipc	a1,0x4
    415c:	0a058593          	addi	a1,a1,160 # 81f8 <malloc+0x1736>
    4160:	4505                	li	a0,1
    4162:	00002097          	auipc	ra,0x2
    4166:	51a080e7          	jalr	1306(ra) # 667c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    416a:	85ca                	mv	a1,s2
    416c:	00004517          	auipc	a0,0x4
    4170:	e6450513          	addi	a0,a0,-412 # 7fd0 <malloc+0x150e>
    4174:	00003097          	auipc	ra,0x3
    4178:	890080e7          	jalr	-1904(ra) # 6a04 <printf>
    exit(1,"");
    417c:	00004597          	auipc	a1,0x4
    4180:	07c58593          	addi	a1,a1,124 # 81f8 <malloc+0x1736>
    4184:	4505                	li	a0,1
    4186:	00002097          	auipc	ra,0x2
    418a:	4f6080e7          	jalr	1270(ra) # 667c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    418e:	85ca                	mv	a1,s2
    4190:	00004517          	auipc	a0,0x4
    4194:	e7050513          	addi	a0,a0,-400 # 8000 <malloc+0x153e>
    4198:	00003097          	auipc	ra,0x3
    419c:	86c080e7          	jalr	-1940(ra) # 6a04 <printf>
    exit(1,"");
    41a0:	00004597          	auipc	a1,0x4
    41a4:	05858593          	addi	a1,a1,88 # 81f8 <malloc+0x1736>
    41a8:	4505                	li	a0,1
    41aa:	00002097          	auipc	ra,0x2
    41ae:	4d2080e7          	jalr	1234(ra) # 667c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    41b2:	85ca                	mv	a1,s2
    41b4:	00004517          	auipc	a0,0x4
    41b8:	e8450513          	addi	a0,a0,-380 # 8038 <malloc+0x1576>
    41bc:	00003097          	auipc	ra,0x3
    41c0:	848080e7          	jalr	-1976(ra) # 6a04 <printf>
    exit(1,"");
    41c4:	00004597          	auipc	a1,0x4
    41c8:	03458593          	addi	a1,a1,52 # 81f8 <malloc+0x1736>
    41cc:	4505                	li	a0,1
    41ce:	00002097          	auipc	ra,0x2
    41d2:	4ae080e7          	jalr	1198(ra) # 667c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    41d6:	85ca                	mv	a1,s2
    41d8:	00004517          	auipc	a0,0x4
    41dc:	e8050513          	addi	a0,a0,-384 # 8058 <malloc+0x1596>
    41e0:	00003097          	auipc	ra,0x3
    41e4:	824080e7          	jalr	-2012(ra) # 6a04 <printf>
    exit(1,"");
    41e8:	00004597          	auipc	a1,0x4
    41ec:	01058593          	addi	a1,a1,16 # 81f8 <malloc+0x1736>
    41f0:	4505                	li	a0,1
    41f2:	00002097          	auipc	ra,0x2
    41f6:	48a080e7          	jalr	1162(ra) # 667c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    41fa:	85ca                	mv	a1,s2
    41fc:	00004517          	auipc	a0,0x4
    4200:	e8c50513          	addi	a0,a0,-372 # 8088 <malloc+0x15c6>
    4204:	00003097          	auipc	ra,0x3
    4208:	800080e7          	jalr	-2048(ra) # 6a04 <printf>
    exit(1,"");
    420c:	00004597          	auipc	a1,0x4
    4210:	fec58593          	addi	a1,a1,-20 # 81f8 <malloc+0x1736>
    4214:	4505                	li	a0,1
    4216:	00002097          	auipc	ra,0x2
    421a:	466080e7          	jalr	1126(ra) # 667c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    421e:	85ca                	mv	a1,s2
    4220:	00004517          	auipc	a0,0x4
    4224:	e9050513          	addi	a0,a0,-368 # 80b0 <malloc+0x15ee>
    4228:	00002097          	auipc	ra,0x2
    422c:	7dc080e7          	jalr	2012(ra) # 6a04 <printf>
    exit(1,"");
    4230:	00004597          	auipc	a1,0x4
    4234:	fc858593          	addi	a1,a1,-56 # 81f8 <malloc+0x1736>
    4238:	4505                	li	a0,1
    423a:	00002097          	auipc	ra,0x2
    423e:	442080e7          	jalr	1090(ra) # 667c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    4242:	85ca                	mv	a1,s2
    4244:	00004517          	auipc	a0,0x4
    4248:	e8c50513          	addi	a0,a0,-372 # 80d0 <malloc+0x160e>
    424c:	00002097          	auipc	ra,0x2
    4250:	7b8080e7          	jalr	1976(ra) # 6a04 <printf>
    exit(1,"");
    4254:	00004597          	auipc	a1,0x4
    4258:	fa458593          	addi	a1,a1,-92 # 81f8 <malloc+0x1736>
    425c:	4505                	li	a0,1
    425e:	00002097          	auipc	ra,0x2
    4262:	41e080e7          	jalr	1054(ra) # 667c <exit>
    printf("%s: chdir dd failed\n", s);
    4266:	85ca                	mv	a1,s2
    4268:	00004517          	auipc	a0,0x4
    426c:	e9050513          	addi	a0,a0,-368 # 80f8 <malloc+0x1636>
    4270:	00002097          	auipc	ra,0x2
    4274:	794080e7          	jalr	1940(ra) # 6a04 <printf>
    exit(1,"");
    4278:	00004597          	auipc	a1,0x4
    427c:	f8058593          	addi	a1,a1,-128 # 81f8 <malloc+0x1736>
    4280:	4505                	li	a0,1
    4282:	00002097          	auipc	ra,0x2
    4286:	3fa080e7          	jalr	1018(ra) # 667c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    428a:	85ca                	mv	a1,s2
    428c:	00004517          	auipc	a0,0x4
    4290:	e9450513          	addi	a0,a0,-364 # 8120 <malloc+0x165e>
    4294:	00002097          	auipc	ra,0x2
    4298:	770080e7          	jalr	1904(ra) # 6a04 <printf>
    exit(1,"");
    429c:	00004597          	auipc	a1,0x4
    42a0:	f5c58593          	addi	a1,a1,-164 # 81f8 <malloc+0x1736>
    42a4:	4505                	li	a0,1
    42a6:	00002097          	auipc	ra,0x2
    42aa:	3d6080e7          	jalr	982(ra) # 667c <exit>
    printf("chdir dd/../../dd failed\n", s);
    42ae:	85ca                	mv	a1,s2
    42b0:	00004517          	auipc	a0,0x4
    42b4:	ea050513          	addi	a0,a0,-352 # 8150 <malloc+0x168e>
    42b8:	00002097          	auipc	ra,0x2
    42bc:	74c080e7          	jalr	1868(ra) # 6a04 <printf>
    exit(1,"");
    42c0:	00004597          	auipc	a1,0x4
    42c4:	f3858593          	addi	a1,a1,-200 # 81f8 <malloc+0x1736>
    42c8:	4505                	li	a0,1
    42ca:	00002097          	auipc	ra,0x2
    42ce:	3b2080e7          	jalr	946(ra) # 667c <exit>
    printf("%s: chdir ./.. failed\n", s);
    42d2:	85ca                	mv	a1,s2
    42d4:	00004517          	auipc	a0,0x4
    42d8:	ea450513          	addi	a0,a0,-348 # 8178 <malloc+0x16b6>
    42dc:	00002097          	auipc	ra,0x2
    42e0:	728080e7          	jalr	1832(ra) # 6a04 <printf>
    exit(1,"");
    42e4:	00004597          	auipc	a1,0x4
    42e8:	f1458593          	addi	a1,a1,-236 # 81f8 <malloc+0x1736>
    42ec:	4505                	li	a0,1
    42ee:	00002097          	auipc	ra,0x2
    42f2:	38e080e7          	jalr	910(ra) # 667c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    42f6:	85ca                	mv	a1,s2
    42f8:	00004517          	auipc	a0,0x4
    42fc:	e9850513          	addi	a0,a0,-360 # 8190 <malloc+0x16ce>
    4300:	00002097          	auipc	ra,0x2
    4304:	704080e7          	jalr	1796(ra) # 6a04 <printf>
    exit(1,"");
    4308:	00004597          	auipc	a1,0x4
    430c:	ef058593          	addi	a1,a1,-272 # 81f8 <malloc+0x1736>
    4310:	4505                	li	a0,1
    4312:	00002097          	auipc	ra,0x2
    4316:	36a080e7          	jalr	874(ra) # 667c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    431a:	85ca                	mv	a1,s2
    431c:	00004517          	auipc	a0,0x4
    4320:	e9450513          	addi	a0,a0,-364 # 81b0 <malloc+0x16ee>
    4324:	00002097          	auipc	ra,0x2
    4328:	6e0080e7          	jalr	1760(ra) # 6a04 <printf>
    exit(1,"");
    432c:	00004597          	auipc	a1,0x4
    4330:	ecc58593          	addi	a1,a1,-308 # 81f8 <malloc+0x1736>
    4334:	4505                	li	a0,1
    4336:	00002097          	auipc	ra,0x2
    433a:	346080e7          	jalr	838(ra) # 667c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    433e:	85ca                	mv	a1,s2
    4340:	00004517          	auipc	a0,0x4
    4344:	e9050513          	addi	a0,a0,-368 # 81d0 <malloc+0x170e>
    4348:	00002097          	auipc	ra,0x2
    434c:	6bc080e7          	jalr	1724(ra) # 6a04 <printf>
    exit(1,"");
    4350:	00004597          	auipc	a1,0x4
    4354:	ea858593          	addi	a1,a1,-344 # 81f8 <malloc+0x1736>
    4358:	4505                	li	a0,1
    435a:	00002097          	auipc	ra,0x2
    435e:	322080e7          	jalr	802(ra) # 667c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    4362:	85ca                	mv	a1,s2
    4364:	00004517          	auipc	a0,0x4
    4368:	eac50513          	addi	a0,a0,-340 # 8210 <malloc+0x174e>
    436c:	00002097          	auipc	ra,0x2
    4370:	698080e7          	jalr	1688(ra) # 6a04 <printf>
    exit(1,"");
    4374:	00004597          	auipc	a1,0x4
    4378:	e8458593          	addi	a1,a1,-380 # 81f8 <malloc+0x1736>
    437c:	4505                	li	a0,1
    437e:	00002097          	auipc	ra,0x2
    4382:	2fe080e7          	jalr	766(ra) # 667c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    4386:	85ca                	mv	a1,s2
    4388:	00004517          	auipc	a0,0x4
    438c:	eb850513          	addi	a0,a0,-328 # 8240 <malloc+0x177e>
    4390:	00002097          	auipc	ra,0x2
    4394:	674080e7          	jalr	1652(ra) # 6a04 <printf>
    exit(1,"");
    4398:	00004597          	auipc	a1,0x4
    439c:	e6058593          	addi	a1,a1,-416 # 81f8 <malloc+0x1736>
    43a0:	4505                	li	a0,1
    43a2:	00002097          	auipc	ra,0x2
    43a6:	2da080e7          	jalr	730(ra) # 667c <exit>
    printf("%s: create dd succeeded!\n", s);
    43aa:	85ca                	mv	a1,s2
    43ac:	00004517          	auipc	a0,0x4
    43b0:	eb450513          	addi	a0,a0,-332 # 8260 <malloc+0x179e>
    43b4:	00002097          	auipc	ra,0x2
    43b8:	650080e7          	jalr	1616(ra) # 6a04 <printf>
    exit(1,"");
    43bc:	00004597          	auipc	a1,0x4
    43c0:	e3c58593          	addi	a1,a1,-452 # 81f8 <malloc+0x1736>
    43c4:	4505                	li	a0,1
    43c6:	00002097          	auipc	ra,0x2
    43ca:	2b6080e7          	jalr	694(ra) # 667c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    43ce:	85ca                	mv	a1,s2
    43d0:	00004517          	auipc	a0,0x4
    43d4:	eb050513          	addi	a0,a0,-336 # 8280 <malloc+0x17be>
    43d8:	00002097          	auipc	ra,0x2
    43dc:	62c080e7          	jalr	1580(ra) # 6a04 <printf>
    exit(1,"");
    43e0:	00004597          	auipc	a1,0x4
    43e4:	e1858593          	addi	a1,a1,-488 # 81f8 <malloc+0x1736>
    43e8:	4505                	li	a0,1
    43ea:	00002097          	auipc	ra,0x2
    43ee:	292080e7          	jalr	658(ra) # 667c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    43f2:	85ca                	mv	a1,s2
    43f4:	00004517          	auipc	a0,0x4
    43f8:	eac50513          	addi	a0,a0,-340 # 82a0 <malloc+0x17de>
    43fc:	00002097          	auipc	ra,0x2
    4400:	608080e7          	jalr	1544(ra) # 6a04 <printf>
    exit(1,"");
    4404:	00004597          	auipc	a1,0x4
    4408:	df458593          	addi	a1,a1,-524 # 81f8 <malloc+0x1736>
    440c:	4505                	li	a0,1
    440e:	00002097          	auipc	ra,0x2
    4412:	26e080e7          	jalr	622(ra) # 667c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    4416:	85ca                	mv	a1,s2
    4418:	00004517          	auipc	a0,0x4
    441c:	eb850513          	addi	a0,a0,-328 # 82d0 <malloc+0x180e>
    4420:	00002097          	auipc	ra,0x2
    4424:	5e4080e7          	jalr	1508(ra) # 6a04 <printf>
    exit(1,"");
    4428:	00004597          	auipc	a1,0x4
    442c:	dd058593          	addi	a1,a1,-560 # 81f8 <malloc+0x1736>
    4430:	4505                	li	a0,1
    4432:	00002097          	auipc	ra,0x2
    4436:	24a080e7          	jalr	586(ra) # 667c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    443a:	85ca                	mv	a1,s2
    443c:	00004517          	auipc	a0,0x4
    4440:	ebc50513          	addi	a0,a0,-324 # 82f8 <malloc+0x1836>
    4444:	00002097          	auipc	ra,0x2
    4448:	5c0080e7          	jalr	1472(ra) # 6a04 <printf>
    exit(1,"");
    444c:	00004597          	auipc	a1,0x4
    4450:	dac58593          	addi	a1,a1,-596 # 81f8 <malloc+0x1736>
    4454:	4505                	li	a0,1
    4456:	00002097          	auipc	ra,0x2
    445a:	226080e7          	jalr	550(ra) # 667c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    445e:	85ca                	mv	a1,s2
    4460:	00004517          	auipc	a0,0x4
    4464:	ec050513          	addi	a0,a0,-320 # 8320 <malloc+0x185e>
    4468:	00002097          	auipc	ra,0x2
    446c:	59c080e7          	jalr	1436(ra) # 6a04 <printf>
    exit(1,"");
    4470:	00004597          	auipc	a1,0x4
    4474:	d8858593          	addi	a1,a1,-632 # 81f8 <malloc+0x1736>
    4478:	4505                	li	a0,1
    447a:	00002097          	auipc	ra,0x2
    447e:	202080e7          	jalr	514(ra) # 667c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    4482:	85ca                	mv	a1,s2
    4484:	00004517          	auipc	a0,0x4
    4488:	ec450513          	addi	a0,a0,-316 # 8348 <malloc+0x1886>
    448c:	00002097          	auipc	ra,0x2
    4490:	578080e7          	jalr	1400(ra) # 6a04 <printf>
    exit(1,"");
    4494:	00004597          	auipc	a1,0x4
    4498:	d6458593          	addi	a1,a1,-668 # 81f8 <malloc+0x1736>
    449c:	4505                	li	a0,1
    449e:	00002097          	auipc	ra,0x2
    44a2:	1de080e7          	jalr	478(ra) # 667c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    44a6:	85ca                	mv	a1,s2
    44a8:	00004517          	auipc	a0,0x4
    44ac:	ec050513          	addi	a0,a0,-320 # 8368 <malloc+0x18a6>
    44b0:	00002097          	auipc	ra,0x2
    44b4:	554080e7          	jalr	1364(ra) # 6a04 <printf>
    exit(1,"");
    44b8:	00004597          	auipc	a1,0x4
    44bc:	d4058593          	addi	a1,a1,-704 # 81f8 <malloc+0x1736>
    44c0:	4505                	li	a0,1
    44c2:	00002097          	auipc	ra,0x2
    44c6:	1ba080e7          	jalr	442(ra) # 667c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    44ca:	85ca                	mv	a1,s2
    44cc:	00004517          	auipc	a0,0x4
    44d0:	ebc50513          	addi	a0,a0,-324 # 8388 <malloc+0x18c6>
    44d4:	00002097          	auipc	ra,0x2
    44d8:	530080e7          	jalr	1328(ra) # 6a04 <printf>
    exit(1,"");
    44dc:	00004597          	auipc	a1,0x4
    44e0:	d1c58593          	addi	a1,a1,-740 # 81f8 <malloc+0x1736>
    44e4:	4505                	li	a0,1
    44e6:	00002097          	auipc	ra,0x2
    44ea:	196080e7          	jalr	406(ra) # 667c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    44ee:	85ca                	mv	a1,s2
    44f0:	00004517          	auipc	a0,0x4
    44f4:	ec050513          	addi	a0,a0,-320 # 83b0 <malloc+0x18ee>
    44f8:	00002097          	auipc	ra,0x2
    44fc:	50c080e7          	jalr	1292(ra) # 6a04 <printf>
    exit(1,"");
    4500:	00004597          	auipc	a1,0x4
    4504:	cf858593          	addi	a1,a1,-776 # 81f8 <malloc+0x1736>
    4508:	4505                	li	a0,1
    450a:	00002097          	auipc	ra,0x2
    450e:	172080e7          	jalr	370(ra) # 667c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    4512:	85ca                	mv	a1,s2
    4514:	00004517          	auipc	a0,0x4
    4518:	ebc50513          	addi	a0,a0,-324 # 83d0 <malloc+0x190e>
    451c:	00002097          	auipc	ra,0x2
    4520:	4e8080e7          	jalr	1256(ra) # 6a04 <printf>
    exit(1,"");
    4524:	00004597          	auipc	a1,0x4
    4528:	cd458593          	addi	a1,a1,-812 # 81f8 <malloc+0x1736>
    452c:	4505                	li	a0,1
    452e:	00002097          	auipc	ra,0x2
    4532:	14e080e7          	jalr	334(ra) # 667c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    4536:	85ca                	mv	a1,s2
    4538:	00004517          	auipc	a0,0x4
    453c:	eb850513          	addi	a0,a0,-328 # 83f0 <malloc+0x192e>
    4540:	00002097          	auipc	ra,0x2
    4544:	4c4080e7          	jalr	1220(ra) # 6a04 <printf>
    exit(1,"");
    4548:	00004597          	auipc	a1,0x4
    454c:	cb058593          	addi	a1,a1,-848 # 81f8 <malloc+0x1736>
    4550:	4505                	li	a0,1
    4552:	00002097          	auipc	ra,0x2
    4556:	12a080e7          	jalr	298(ra) # 667c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    455a:	85ca                	mv	a1,s2
    455c:	00004517          	auipc	a0,0x4
    4560:	ebc50513          	addi	a0,a0,-324 # 8418 <malloc+0x1956>
    4564:	00002097          	auipc	ra,0x2
    4568:	4a0080e7          	jalr	1184(ra) # 6a04 <printf>
    exit(1,"");
    456c:	00004597          	auipc	a1,0x4
    4570:	c8c58593          	addi	a1,a1,-884 # 81f8 <malloc+0x1736>
    4574:	4505                	li	a0,1
    4576:	00002097          	auipc	ra,0x2
    457a:	106080e7          	jalr	262(ra) # 667c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    457e:	85ca                	mv	a1,s2
    4580:	00004517          	auipc	a0,0x4
    4584:	b3050513          	addi	a0,a0,-1232 # 80b0 <malloc+0x15ee>
    4588:	00002097          	auipc	ra,0x2
    458c:	47c080e7          	jalr	1148(ra) # 6a04 <printf>
    exit(1,"");
    4590:	00004597          	auipc	a1,0x4
    4594:	c6858593          	addi	a1,a1,-920 # 81f8 <malloc+0x1736>
    4598:	4505                	li	a0,1
    459a:	00002097          	auipc	ra,0x2
    459e:	0e2080e7          	jalr	226(ra) # 667c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    45a2:	85ca                	mv	a1,s2
    45a4:	00004517          	auipc	a0,0x4
    45a8:	e9450513          	addi	a0,a0,-364 # 8438 <malloc+0x1976>
    45ac:	00002097          	auipc	ra,0x2
    45b0:	458080e7          	jalr	1112(ra) # 6a04 <printf>
    exit(1,"");
    45b4:	00004597          	auipc	a1,0x4
    45b8:	c4458593          	addi	a1,a1,-956 # 81f8 <malloc+0x1736>
    45bc:	4505                	li	a0,1
    45be:	00002097          	auipc	ra,0x2
    45c2:	0be080e7          	jalr	190(ra) # 667c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    45c6:	85ca                	mv	a1,s2
    45c8:	00004517          	auipc	a0,0x4
    45cc:	e9050513          	addi	a0,a0,-368 # 8458 <malloc+0x1996>
    45d0:	00002097          	auipc	ra,0x2
    45d4:	434080e7          	jalr	1076(ra) # 6a04 <printf>
    exit(1,"");
    45d8:	00004597          	auipc	a1,0x4
    45dc:	c2058593          	addi	a1,a1,-992 # 81f8 <malloc+0x1736>
    45e0:	4505                	li	a0,1
    45e2:	00002097          	auipc	ra,0x2
    45e6:	09a080e7          	jalr	154(ra) # 667c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    45ea:	85ca                	mv	a1,s2
    45ec:	00004517          	auipc	a0,0x4
    45f0:	e9c50513          	addi	a0,a0,-356 # 8488 <malloc+0x19c6>
    45f4:	00002097          	auipc	ra,0x2
    45f8:	410080e7          	jalr	1040(ra) # 6a04 <printf>
    exit(1,"");
    45fc:	00004597          	auipc	a1,0x4
    4600:	bfc58593          	addi	a1,a1,-1028 # 81f8 <malloc+0x1736>
    4604:	4505                	li	a0,1
    4606:	00002097          	auipc	ra,0x2
    460a:	076080e7          	jalr	118(ra) # 667c <exit>
    printf("%s: unlink dd failed\n", s);
    460e:	85ca                	mv	a1,s2
    4610:	00004517          	auipc	a0,0x4
    4614:	e9850513          	addi	a0,a0,-360 # 84a8 <malloc+0x19e6>
    4618:	00002097          	auipc	ra,0x2
    461c:	3ec080e7          	jalr	1004(ra) # 6a04 <printf>
    exit(1,"");
    4620:	00004597          	auipc	a1,0x4
    4624:	bd858593          	addi	a1,a1,-1064 # 81f8 <malloc+0x1736>
    4628:	4505                	li	a0,1
    462a:	00002097          	auipc	ra,0x2
    462e:	052080e7          	jalr	82(ra) # 667c <exit>

0000000000004632 <rmdot>:
{
    4632:	1101                	addi	sp,sp,-32
    4634:	ec06                	sd	ra,24(sp)
    4636:	e822                	sd	s0,16(sp)
    4638:	e426                	sd	s1,8(sp)
    463a:	1000                	addi	s0,sp,32
    463c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    463e:	00004517          	auipc	a0,0x4
    4642:	e8250513          	addi	a0,a0,-382 # 84c0 <malloc+0x19fe>
    4646:	00002097          	auipc	ra,0x2
    464a:	09e080e7          	jalr	158(ra) # 66e4 <mkdir>
    464e:	e551                	bnez	a0,46da <rmdot+0xa8>
  if(chdir("dots") != 0){
    4650:	00004517          	auipc	a0,0x4
    4654:	e7050513          	addi	a0,a0,-400 # 84c0 <malloc+0x19fe>
    4658:	00002097          	auipc	ra,0x2
    465c:	094080e7          	jalr	148(ra) # 66ec <chdir>
    4660:	ed59                	bnez	a0,46fe <rmdot+0xcc>
  if(unlink(".") == 0){
    4662:	00003517          	auipc	a0,0x3
    4666:	c8e50513          	addi	a0,a0,-882 # 72f0 <malloc+0x82e>
    466a:	00002097          	auipc	ra,0x2
    466e:	062080e7          	jalr	98(ra) # 66cc <unlink>
    4672:	c945                	beqz	a0,4722 <rmdot+0xf0>
  if(unlink("..") == 0){
    4674:	00004517          	auipc	a0,0x4
    4678:	8a450513          	addi	a0,a0,-1884 # 7f18 <malloc+0x1456>
    467c:	00002097          	auipc	ra,0x2
    4680:	050080e7          	jalr	80(ra) # 66cc <unlink>
    4684:	c169                	beqz	a0,4746 <rmdot+0x114>
  if(chdir("/") != 0){
    4686:	00004517          	auipc	a0,0x4
    468a:	83a50513          	addi	a0,a0,-1990 # 7ec0 <malloc+0x13fe>
    468e:	00002097          	auipc	ra,0x2
    4692:	05e080e7          	jalr	94(ra) # 66ec <chdir>
    4696:	e971                	bnez	a0,476a <rmdot+0x138>
  if(unlink("dots/.") == 0){
    4698:	00004517          	auipc	a0,0x4
    469c:	e9050513          	addi	a0,a0,-368 # 8528 <malloc+0x1a66>
    46a0:	00002097          	auipc	ra,0x2
    46a4:	02c080e7          	jalr	44(ra) # 66cc <unlink>
    46a8:	c17d                	beqz	a0,478e <rmdot+0x15c>
  if(unlink("dots/..") == 0){
    46aa:	00004517          	auipc	a0,0x4
    46ae:	ea650513          	addi	a0,a0,-346 # 8550 <malloc+0x1a8e>
    46b2:	00002097          	auipc	ra,0x2
    46b6:	01a080e7          	jalr	26(ra) # 66cc <unlink>
    46ba:	cd65                	beqz	a0,47b2 <rmdot+0x180>
  if(unlink("dots") != 0){
    46bc:	00004517          	auipc	a0,0x4
    46c0:	e0450513          	addi	a0,a0,-508 # 84c0 <malloc+0x19fe>
    46c4:	00002097          	auipc	ra,0x2
    46c8:	008080e7          	jalr	8(ra) # 66cc <unlink>
    46cc:	10051563          	bnez	a0,47d6 <rmdot+0x1a4>
}
    46d0:	60e2                	ld	ra,24(sp)
    46d2:	6442                	ld	s0,16(sp)
    46d4:	64a2                	ld	s1,8(sp)
    46d6:	6105                	addi	sp,sp,32
    46d8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    46da:	85a6                	mv	a1,s1
    46dc:	00004517          	auipc	a0,0x4
    46e0:	dec50513          	addi	a0,a0,-532 # 84c8 <malloc+0x1a06>
    46e4:	00002097          	auipc	ra,0x2
    46e8:	320080e7          	jalr	800(ra) # 6a04 <printf>
    exit(1,"");
    46ec:	00004597          	auipc	a1,0x4
    46f0:	b0c58593          	addi	a1,a1,-1268 # 81f8 <malloc+0x1736>
    46f4:	4505                	li	a0,1
    46f6:	00002097          	auipc	ra,0x2
    46fa:	f86080e7          	jalr	-122(ra) # 667c <exit>
    printf("%s: chdir dots failed\n", s);
    46fe:	85a6                	mv	a1,s1
    4700:	00004517          	auipc	a0,0x4
    4704:	de050513          	addi	a0,a0,-544 # 84e0 <malloc+0x1a1e>
    4708:	00002097          	auipc	ra,0x2
    470c:	2fc080e7          	jalr	764(ra) # 6a04 <printf>
    exit(1,"");
    4710:	00004597          	auipc	a1,0x4
    4714:	ae858593          	addi	a1,a1,-1304 # 81f8 <malloc+0x1736>
    4718:	4505                	li	a0,1
    471a:	00002097          	auipc	ra,0x2
    471e:	f62080e7          	jalr	-158(ra) # 667c <exit>
    printf("%s: rm . worked!\n", s);
    4722:	85a6                	mv	a1,s1
    4724:	00004517          	auipc	a0,0x4
    4728:	dd450513          	addi	a0,a0,-556 # 84f8 <malloc+0x1a36>
    472c:	00002097          	auipc	ra,0x2
    4730:	2d8080e7          	jalr	728(ra) # 6a04 <printf>
    exit(1,"");
    4734:	00004597          	auipc	a1,0x4
    4738:	ac458593          	addi	a1,a1,-1340 # 81f8 <malloc+0x1736>
    473c:	4505                	li	a0,1
    473e:	00002097          	auipc	ra,0x2
    4742:	f3e080e7          	jalr	-194(ra) # 667c <exit>
    printf("%s: rm .. worked!\n", s);
    4746:	85a6                	mv	a1,s1
    4748:	00004517          	auipc	a0,0x4
    474c:	dc850513          	addi	a0,a0,-568 # 8510 <malloc+0x1a4e>
    4750:	00002097          	auipc	ra,0x2
    4754:	2b4080e7          	jalr	692(ra) # 6a04 <printf>
    exit(1,"");
    4758:	00004597          	auipc	a1,0x4
    475c:	aa058593          	addi	a1,a1,-1376 # 81f8 <malloc+0x1736>
    4760:	4505                	li	a0,1
    4762:	00002097          	auipc	ra,0x2
    4766:	f1a080e7          	jalr	-230(ra) # 667c <exit>
    printf("%s: chdir / failed\n", s);
    476a:	85a6                	mv	a1,s1
    476c:	00003517          	auipc	a0,0x3
    4770:	75c50513          	addi	a0,a0,1884 # 7ec8 <malloc+0x1406>
    4774:	00002097          	auipc	ra,0x2
    4778:	290080e7          	jalr	656(ra) # 6a04 <printf>
    exit(1,"");
    477c:	00004597          	auipc	a1,0x4
    4780:	a7c58593          	addi	a1,a1,-1412 # 81f8 <malloc+0x1736>
    4784:	4505                	li	a0,1
    4786:	00002097          	auipc	ra,0x2
    478a:	ef6080e7          	jalr	-266(ra) # 667c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    478e:	85a6                	mv	a1,s1
    4790:	00004517          	auipc	a0,0x4
    4794:	da050513          	addi	a0,a0,-608 # 8530 <malloc+0x1a6e>
    4798:	00002097          	auipc	ra,0x2
    479c:	26c080e7          	jalr	620(ra) # 6a04 <printf>
    exit(1,"");
    47a0:	00004597          	auipc	a1,0x4
    47a4:	a5858593          	addi	a1,a1,-1448 # 81f8 <malloc+0x1736>
    47a8:	4505                	li	a0,1
    47aa:	00002097          	auipc	ra,0x2
    47ae:	ed2080e7          	jalr	-302(ra) # 667c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    47b2:	85a6                	mv	a1,s1
    47b4:	00004517          	auipc	a0,0x4
    47b8:	da450513          	addi	a0,a0,-604 # 8558 <malloc+0x1a96>
    47bc:	00002097          	auipc	ra,0x2
    47c0:	248080e7          	jalr	584(ra) # 6a04 <printf>
    exit(1,"");
    47c4:	00004597          	auipc	a1,0x4
    47c8:	a3458593          	addi	a1,a1,-1484 # 81f8 <malloc+0x1736>
    47cc:	4505                	li	a0,1
    47ce:	00002097          	auipc	ra,0x2
    47d2:	eae080e7          	jalr	-338(ra) # 667c <exit>
    printf("%s: unlink dots failed!\n", s);
    47d6:	85a6                	mv	a1,s1
    47d8:	00004517          	auipc	a0,0x4
    47dc:	da050513          	addi	a0,a0,-608 # 8578 <malloc+0x1ab6>
    47e0:	00002097          	auipc	ra,0x2
    47e4:	224080e7          	jalr	548(ra) # 6a04 <printf>
    exit(1,"");
    47e8:	00004597          	auipc	a1,0x4
    47ec:	a1058593          	addi	a1,a1,-1520 # 81f8 <malloc+0x1736>
    47f0:	4505                	li	a0,1
    47f2:	00002097          	auipc	ra,0x2
    47f6:	e8a080e7          	jalr	-374(ra) # 667c <exit>

00000000000047fa <dirfile>:
{
    47fa:	1101                	addi	sp,sp,-32
    47fc:	ec06                	sd	ra,24(sp)
    47fe:	e822                	sd	s0,16(sp)
    4800:	e426                	sd	s1,8(sp)
    4802:	e04a                	sd	s2,0(sp)
    4804:	1000                	addi	s0,sp,32
    4806:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4808:	20000593          	li	a1,512
    480c:	00004517          	auipc	a0,0x4
    4810:	d8c50513          	addi	a0,a0,-628 # 8598 <malloc+0x1ad6>
    4814:	00002097          	auipc	ra,0x2
    4818:	ea8080e7          	jalr	-344(ra) # 66bc <open>
  if(fd < 0){
    481c:	0e054e63          	bltz	a0,4918 <dirfile+0x11e>
  close(fd);
    4820:	00002097          	auipc	ra,0x2
    4824:	e84080e7          	jalr	-380(ra) # 66a4 <close>
  if(chdir("dirfile") == 0){
    4828:	00004517          	auipc	a0,0x4
    482c:	d7050513          	addi	a0,a0,-656 # 8598 <malloc+0x1ad6>
    4830:	00002097          	auipc	ra,0x2
    4834:	ebc080e7          	jalr	-324(ra) # 66ec <chdir>
    4838:	10050263          	beqz	a0,493c <dirfile+0x142>
  fd = open("dirfile/xx", 0);
    483c:	4581                	li	a1,0
    483e:	00004517          	auipc	a0,0x4
    4842:	da250513          	addi	a0,a0,-606 # 85e0 <malloc+0x1b1e>
    4846:	00002097          	auipc	ra,0x2
    484a:	e76080e7          	jalr	-394(ra) # 66bc <open>
  if(fd >= 0){
    484e:	10055963          	bgez	a0,4960 <dirfile+0x166>
  fd = open("dirfile/xx", O_CREATE);
    4852:	20000593          	li	a1,512
    4856:	00004517          	auipc	a0,0x4
    485a:	d8a50513          	addi	a0,a0,-630 # 85e0 <malloc+0x1b1e>
    485e:	00002097          	auipc	ra,0x2
    4862:	e5e080e7          	jalr	-418(ra) # 66bc <open>
  if(fd >= 0){
    4866:	10055f63          	bgez	a0,4984 <dirfile+0x18a>
  if(mkdir("dirfile/xx") == 0){
    486a:	00004517          	auipc	a0,0x4
    486e:	d7650513          	addi	a0,a0,-650 # 85e0 <malloc+0x1b1e>
    4872:	00002097          	auipc	ra,0x2
    4876:	e72080e7          	jalr	-398(ra) # 66e4 <mkdir>
    487a:	12050763          	beqz	a0,49a8 <dirfile+0x1ae>
  if(unlink("dirfile/xx") == 0){
    487e:	00004517          	auipc	a0,0x4
    4882:	d6250513          	addi	a0,a0,-670 # 85e0 <malloc+0x1b1e>
    4886:	00002097          	auipc	ra,0x2
    488a:	e46080e7          	jalr	-442(ra) # 66cc <unlink>
    488e:	12050f63          	beqz	a0,49cc <dirfile+0x1d2>
  if(link("README", "dirfile/xx") == 0){
    4892:	00004597          	auipc	a1,0x4
    4896:	d4e58593          	addi	a1,a1,-690 # 85e0 <malloc+0x1b1e>
    489a:	00002517          	auipc	a0,0x2
    489e:	54650513          	addi	a0,a0,1350 # 6de0 <malloc+0x31e>
    48a2:	00002097          	auipc	ra,0x2
    48a6:	e3a080e7          	jalr	-454(ra) # 66dc <link>
    48aa:	14050363          	beqz	a0,49f0 <dirfile+0x1f6>
  if(unlink("dirfile") != 0){
    48ae:	00004517          	auipc	a0,0x4
    48b2:	cea50513          	addi	a0,a0,-790 # 8598 <malloc+0x1ad6>
    48b6:	00002097          	auipc	ra,0x2
    48ba:	e16080e7          	jalr	-490(ra) # 66cc <unlink>
    48be:	14051b63          	bnez	a0,4a14 <dirfile+0x21a>
  fd = open(".", O_RDWR);
    48c2:	4589                	li	a1,2
    48c4:	00003517          	auipc	a0,0x3
    48c8:	a2c50513          	addi	a0,a0,-1492 # 72f0 <malloc+0x82e>
    48cc:	00002097          	auipc	ra,0x2
    48d0:	df0080e7          	jalr	-528(ra) # 66bc <open>
  if(fd >= 0){
    48d4:	16055263          	bgez	a0,4a38 <dirfile+0x23e>
  fd = open(".", 0);
    48d8:	4581                	li	a1,0
    48da:	00003517          	auipc	a0,0x3
    48de:	a1650513          	addi	a0,a0,-1514 # 72f0 <malloc+0x82e>
    48e2:	00002097          	auipc	ra,0x2
    48e6:	dda080e7          	jalr	-550(ra) # 66bc <open>
    48ea:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    48ec:	4605                	li	a2,1
    48ee:	00002597          	auipc	a1,0x2
    48f2:	38a58593          	addi	a1,a1,906 # 6c78 <malloc+0x1b6>
    48f6:	00002097          	auipc	ra,0x2
    48fa:	da6080e7          	jalr	-602(ra) # 669c <write>
    48fe:	14a04f63          	bgtz	a0,4a5c <dirfile+0x262>
  close(fd);
    4902:	8526                	mv	a0,s1
    4904:	00002097          	auipc	ra,0x2
    4908:	da0080e7          	jalr	-608(ra) # 66a4 <close>
}
    490c:	60e2                	ld	ra,24(sp)
    490e:	6442                	ld	s0,16(sp)
    4910:	64a2                	ld	s1,8(sp)
    4912:	6902                	ld	s2,0(sp)
    4914:	6105                	addi	sp,sp,32
    4916:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4918:	85ca                	mv	a1,s2
    491a:	00004517          	auipc	a0,0x4
    491e:	c8650513          	addi	a0,a0,-890 # 85a0 <malloc+0x1ade>
    4922:	00002097          	auipc	ra,0x2
    4926:	0e2080e7          	jalr	226(ra) # 6a04 <printf>
    exit(1,"");
    492a:	00004597          	auipc	a1,0x4
    492e:	8ce58593          	addi	a1,a1,-1842 # 81f8 <malloc+0x1736>
    4932:	4505                	li	a0,1
    4934:	00002097          	auipc	ra,0x2
    4938:	d48080e7          	jalr	-696(ra) # 667c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    493c:	85ca                	mv	a1,s2
    493e:	00004517          	auipc	a0,0x4
    4942:	c8250513          	addi	a0,a0,-894 # 85c0 <malloc+0x1afe>
    4946:	00002097          	auipc	ra,0x2
    494a:	0be080e7          	jalr	190(ra) # 6a04 <printf>
    exit(1,"");
    494e:	00004597          	auipc	a1,0x4
    4952:	8aa58593          	addi	a1,a1,-1878 # 81f8 <malloc+0x1736>
    4956:	4505                	li	a0,1
    4958:	00002097          	auipc	ra,0x2
    495c:	d24080e7          	jalr	-732(ra) # 667c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4960:	85ca                	mv	a1,s2
    4962:	00004517          	auipc	a0,0x4
    4966:	c8e50513          	addi	a0,a0,-882 # 85f0 <malloc+0x1b2e>
    496a:	00002097          	auipc	ra,0x2
    496e:	09a080e7          	jalr	154(ra) # 6a04 <printf>
    exit(1,"");
    4972:	00004597          	auipc	a1,0x4
    4976:	88658593          	addi	a1,a1,-1914 # 81f8 <malloc+0x1736>
    497a:	4505                	li	a0,1
    497c:	00002097          	auipc	ra,0x2
    4980:	d00080e7          	jalr	-768(ra) # 667c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4984:	85ca                	mv	a1,s2
    4986:	00004517          	auipc	a0,0x4
    498a:	c6a50513          	addi	a0,a0,-918 # 85f0 <malloc+0x1b2e>
    498e:	00002097          	auipc	ra,0x2
    4992:	076080e7          	jalr	118(ra) # 6a04 <printf>
    exit(1,"");
    4996:	00004597          	auipc	a1,0x4
    499a:	86258593          	addi	a1,a1,-1950 # 81f8 <malloc+0x1736>
    499e:	4505                	li	a0,1
    49a0:	00002097          	auipc	ra,0x2
    49a4:	cdc080e7          	jalr	-804(ra) # 667c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    49a8:	85ca                	mv	a1,s2
    49aa:	00004517          	auipc	a0,0x4
    49ae:	c6e50513          	addi	a0,a0,-914 # 8618 <malloc+0x1b56>
    49b2:	00002097          	auipc	ra,0x2
    49b6:	052080e7          	jalr	82(ra) # 6a04 <printf>
    exit(1,"");
    49ba:	00004597          	auipc	a1,0x4
    49be:	83e58593          	addi	a1,a1,-1986 # 81f8 <malloc+0x1736>
    49c2:	4505                	li	a0,1
    49c4:	00002097          	auipc	ra,0x2
    49c8:	cb8080e7          	jalr	-840(ra) # 667c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    49cc:	85ca                	mv	a1,s2
    49ce:	00004517          	auipc	a0,0x4
    49d2:	c7250513          	addi	a0,a0,-910 # 8640 <malloc+0x1b7e>
    49d6:	00002097          	auipc	ra,0x2
    49da:	02e080e7          	jalr	46(ra) # 6a04 <printf>
    exit(1,"");
    49de:	00004597          	auipc	a1,0x4
    49e2:	81a58593          	addi	a1,a1,-2022 # 81f8 <malloc+0x1736>
    49e6:	4505                	li	a0,1
    49e8:	00002097          	auipc	ra,0x2
    49ec:	c94080e7          	jalr	-876(ra) # 667c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    49f0:	85ca                	mv	a1,s2
    49f2:	00004517          	auipc	a0,0x4
    49f6:	c7650513          	addi	a0,a0,-906 # 8668 <malloc+0x1ba6>
    49fa:	00002097          	auipc	ra,0x2
    49fe:	00a080e7          	jalr	10(ra) # 6a04 <printf>
    exit(1,"");
    4a02:	00003597          	auipc	a1,0x3
    4a06:	7f658593          	addi	a1,a1,2038 # 81f8 <malloc+0x1736>
    4a0a:	4505                	li	a0,1
    4a0c:	00002097          	auipc	ra,0x2
    4a10:	c70080e7          	jalr	-912(ra) # 667c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4a14:	85ca                	mv	a1,s2
    4a16:	00004517          	auipc	a0,0x4
    4a1a:	c7a50513          	addi	a0,a0,-902 # 8690 <malloc+0x1bce>
    4a1e:	00002097          	auipc	ra,0x2
    4a22:	fe6080e7          	jalr	-26(ra) # 6a04 <printf>
    exit(1,"");
    4a26:	00003597          	auipc	a1,0x3
    4a2a:	7d258593          	addi	a1,a1,2002 # 81f8 <malloc+0x1736>
    4a2e:	4505                	li	a0,1
    4a30:	00002097          	auipc	ra,0x2
    4a34:	c4c080e7          	jalr	-948(ra) # 667c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4a38:	85ca                	mv	a1,s2
    4a3a:	00004517          	auipc	a0,0x4
    4a3e:	c7650513          	addi	a0,a0,-906 # 86b0 <malloc+0x1bee>
    4a42:	00002097          	auipc	ra,0x2
    4a46:	fc2080e7          	jalr	-62(ra) # 6a04 <printf>
    exit(1,"");
    4a4a:	00003597          	auipc	a1,0x3
    4a4e:	7ae58593          	addi	a1,a1,1966 # 81f8 <malloc+0x1736>
    4a52:	4505                	li	a0,1
    4a54:	00002097          	auipc	ra,0x2
    4a58:	c28080e7          	jalr	-984(ra) # 667c <exit>
    printf("%s: write . succeeded!\n", s);
    4a5c:	85ca                	mv	a1,s2
    4a5e:	00004517          	auipc	a0,0x4
    4a62:	c7a50513          	addi	a0,a0,-902 # 86d8 <malloc+0x1c16>
    4a66:	00002097          	auipc	ra,0x2
    4a6a:	f9e080e7          	jalr	-98(ra) # 6a04 <printf>
    exit(1,"");
    4a6e:	00003597          	auipc	a1,0x3
    4a72:	78a58593          	addi	a1,a1,1930 # 81f8 <malloc+0x1736>
    4a76:	4505                	li	a0,1
    4a78:	00002097          	auipc	ra,0x2
    4a7c:	c04080e7          	jalr	-1020(ra) # 667c <exit>

0000000000004a80 <iref>:
{
    4a80:	7139                	addi	sp,sp,-64
    4a82:	fc06                	sd	ra,56(sp)
    4a84:	f822                	sd	s0,48(sp)
    4a86:	f426                	sd	s1,40(sp)
    4a88:	f04a                	sd	s2,32(sp)
    4a8a:	ec4e                	sd	s3,24(sp)
    4a8c:	e852                	sd	s4,16(sp)
    4a8e:	e456                	sd	s5,8(sp)
    4a90:	e05a                	sd	s6,0(sp)
    4a92:	0080                	addi	s0,sp,64
    4a94:	8b2a                	mv	s6,a0
    4a96:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4a9a:	00004a17          	auipc	s4,0x4
    4a9e:	c56a0a13          	addi	s4,s4,-938 # 86f0 <malloc+0x1c2e>
    mkdir("");
    4aa2:	00003497          	auipc	s1,0x3
    4aa6:	75648493          	addi	s1,s1,1878 # 81f8 <malloc+0x1736>
    link("README", "");
    4aaa:	00002a97          	auipc	s5,0x2
    4aae:	336a8a93          	addi	s5,s5,822 # 6de0 <malloc+0x31e>
    fd = open("xx", O_CREATE);
    4ab2:	00004997          	auipc	s3,0x4
    4ab6:	b3698993          	addi	s3,s3,-1226 # 85e8 <malloc+0x1b26>
    4aba:	a095                	j	4b1e <iref+0x9e>
      printf("%s: mkdir irefd failed\n", s);
    4abc:	85da                	mv	a1,s6
    4abe:	00004517          	auipc	a0,0x4
    4ac2:	c3a50513          	addi	a0,a0,-966 # 86f8 <malloc+0x1c36>
    4ac6:	00002097          	auipc	ra,0x2
    4aca:	f3e080e7          	jalr	-194(ra) # 6a04 <printf>
      exit(1,"");
    4ace:	00003597          	auipc	a1,0x3
    4ad2:	72a58593          	addi	a1,a1,1834 # 81f8 <malloc+0x1736>
    4ad6:	4505                	li	a0,1
    4ad8:	00002097          	auipc	ra,0x2
    4adc:	ba4080e7          	jalr	-1116(ra) # 667c <exit>
      printf("%s: chdir irefd failed\n", s);
    4ae0:	85da                	mv	a1,s6
    4ae2:	00004517          	auipc	a0,0x4
    4ae6:	c2e50513          	addi	a0,a0,-978 # 8710 <malloc+0x1c4e>
    4aea:	00002097          	auipc	ra,0x2
    4aee:	f1a080e7          	jalr	-230(ra) # 6a04 <printf>
      exit(1,"");
    4af2:	00003597          	auipc	a1,0x3
    4af6:	70658593          	addi	a1,a1,1798 # 81f8 <malloc+0x1736>
    4afa:	4505                	li	a0,1
    4afc:	00002097          	auipc	ra,0x2
    4b00:	b80080e7          	jalr	-1152(ra) # 667c <exit>
      close(fd);
    4b04:	00002097          	auipc	ra,0x2
    4b08:	ba0080e7          	jalr	-1120(ra) # 66a4 <close>
    4b0c:	a889                	j	4b5e <iref+0xde>
    unlink("xx");
    4b0e:	854e                	mv	a0,s3
    4b10:	00002097          	auipc	ra,0x2
    4b14:	bbc080e7          	jalr	-1092(ra) # 66cc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4b18:	397d                	addiw	s2,s2,-1
    4b1a:	06090063          	beqz	s2,4b7a <iref+0xfa>
    if(mkdir("irefd") != 0){
    4b1e:	8552                	mv	a0,s4
    4b20:	00002097          	auipc	ra,0x2
    4b24:	bc4080e7          	jalr	-1084(ra) # 66e4 <mkdir>
    4b28:	f951                	bnez	a0,4abc <iref+0x3c>
    if(chdir("irefd") != 0){
    4b2a:	8552                	mv	a0,s4
    4b2c:	00002097          	auipc	ra,0x2
    4b30:	bc0080e7          	jalr	-1088(ra) # 66ec <chdir>
    4b34:	f555                	bnez	a0,4ae0 <iref+0x60>
    mkdir("");
    4b36:	8526                	mv	a0,s1
    4b38:	00002097          	auipc	ra,0x2
    4b3c:	bac080e7          	jalr	-1108(ra) # 66e4 <mkdir>
    link("README", "");
    4b40:	85a6                	mv	a1,s1
    4b42:	8556                	mv	a0,s5
    4b44:	00002097          	auipc	ra,0x2
    4b48:	b98080e7          	jalr	-1128(ra) # 66dc <link>
    fd = open("", O_CREATE);
    4b4c:	20000593          	li	a1,512
    4b50:	8526                	mv	a0,s1
    4b52:	00002097          	auipc	ra,0x2
    4b56:	b6a080e7          	jalr	-1174(ra) # 66bc <open>
    if(fd >= 0)
    4b5a:	fa0555e3          	bgez	a0,4b04 <iref+0x84>
    fd = open("xx", O_CREATE);
    4b5e:	20000593          	li	a1,512
    4b62:	854e                	mv	a0,s3
    4b64:	00002097          	auipc	ra,0x2
    4b68:	b58080e7          	jalr	-1192(ra) # 66bc <open>
    if(fd >= 0)
    4b6c:	fa0541e3          	bltz	a0,4b0e <iref+0x8e>
      close(fd);
    4b70:	00002097          	auipc	ra,0x2
    4b74:	b34080e7          	jalr	-1228(ra) # 66a4 <close>
    4b78:	bf59                	j	4b0e <iref+0x8e>
    4b7a:	03300493          	li	s1,51
    chdir("..");
    4b7e:	00003997          	auipc	s3,0x3
    4b82:	39a98993          	addi	s3,s3,922 # 7f18 <malloc+0x1456>
    unlink("irefd");
    4b86:	00004917          	auipc	s2,0x4
    4b8a:	b6a90913          	addi	s2,s2,-1174 # 86f0 <malloc+0x1c2e>
    chdir("..");
    4b8e:	854e                	mv	a0,s3
    4b90:	00002097          	auipc	ra,0x2
    4b94:	b5c080e7          	jalr	-1188(ra) # 66ec <chdir>
    unlink("irefd");
    4b98:	854a                	mv	a0,s2
    4b9a:	00002097          	auipc	ra,0x2
    4b9e:	b32080e7          	jalr	-1230(ra) # 66cc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4ba2:	34fd                	addiw	s1,s1,-1
    4ba4:	f4ed                	bnez	s1,4b8e <iref+0x10e>
  chdir("/");
    4ba6:	00003517          	auipc	a0,0x3
    4baa:	31a50513          	addi	a0,a0,794 # 7ec0 <malloc+0x13fe>
    4bae:	00002097          	auipc	ra,0x2
    4bb2:	b3e080e7          	jalr	-1218(ra) # 66ec <chdir>
}
    4bb6:	70e2                	ld	ra,56(sp)
    4bb8:	7442                	ld	s0,48(sp)
    4bba:	74a2                	ld	s1,40(sp)
    4bbc:	7902                	ld	s2,32(sp)
    4bbe:	69e2                	ld	s3,24(sp)
    4bc0:	6a42                	ld	s4,16(sp)
    4bc2:	6aa2                	ld	s5,8(sp)
    4bc4:	6b02                	ld	s6,0(sp)
    4bc6:	6121                	addi	sp,sp,64
    4bc8:	8082                	ret

0000000000004bca <openiputtest>:
{
    4bca:	7179                	addi	sp,sp,-48
    4bcc:	f406                	sd	ra,40(sp)
    4bce:	f022                	sd	s0,32(sp)
    4bd0:	ec26                	sd	s1,24(sp)
    4bd2:	1800                	addi	s0,sp,48
    4bd4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4bd6:	00004517          	auipc	a0,0x4
    4bda:	b5250513          	addi	a0,a0,-1198 # 8728 <malloc+0x1c66>
    4bde:	00002097          	auipc	ra,0x2
    4be2:	b06080e7          	jalr	-1274(ra) # 66e4 <mkdir>
    4be6:	04054663          	bltz	a0,4c32 <openiputtest+0x68>
  pid = fork();
    4bea:	00002097          	auipc	ra,0x2
    4bee:	a8a080e7          	jalr	-1398(ra) # 6674 <fork>
  if(pid < 0){
    4bf2:	06054263          	bltz	a0,4c56 <openiputtest+0x8c>
  if(pid == 0){
    4bf6:	e959                	bnez	a0,4c8c <openiputtest+0xc2>
    int fd = open("oidir", O_RDWR);
    4bf8:	4589                	li	a1,2
    4bfa:	00004517          	auipc	a0,0x4
    4bfe:	b2e50513          	addi	a0,a0,-1234 # 8728 <malloc+0x1c66>
    4c02:	00002097          	auipc	ra,0x2
    4c06:	aba080e7          	jalr	-1350(ra) # 66bc <open>
    if(fd >= 0){
    4c0a:	06054863          	bltz	a0,4c7a <openiputtest+0xb0>
      printf("%s: open directory for write succeeded\n", s);
    4c0e:	85a6                	mv	a1,s1
    4c10:	00004517          	auipc	a0,0x4
    4c14:	b3850513          	addi	a0,a0,-1224 # 8748 <malloc+0x1c86>
    4c18:	00002097          	auipc	ra,0x2
    4c1c:	dec080e7          	jalr	-532(ra) # 6a04 <printf>
      exit(1,"");
    4c20:	00003597          	auipc	a1,0x3
    4c24:	5d858593          	addi	a1,a1,1496 # 81f8 <malloc+0x1736>
    4c28:	4505                	li	a0,1
    4c2a:	00002097          	auipc	ra,0x2
    4c2e:	a52080e7          	jalr	-1454(ra) # 667c <exit>
    printf("%s: mkdir oidir failed\n", s);
    4c32:	85a6                	mv	a1,s1
    4c34:	00004517          	auipc	a0,0x4
    4c38:	afc50513          	addi	a0,a0,-1284 # 8730 <malloc+0x1c6e>
    4c3c:	00002097          	auipc	ra,0x2
    4c40:	dc8080e7          	jalr	-568(ra) # 6a04 <printf>
    exit(1,"");
    4c44:	00003597          	auipc	a1,0x3
    4c48:	5b458593          	addi	a1,a1,1460 # 81f8 <malloc+0x1736>
    4c4c:	4505                	li	a0,1
    4c4e:	00002097          	auipc	ra,0x2
    4c52:	a2e080e7          	jalr	-1490(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    4c56:	85a6                	mv	a1,s1
    4c58:	00003517          	auipc	a0,0x3
    4c5c:	83850513          	addi	a0,a0,-1992 # 7490 <malloc+0x9ce>
    4c60:	00002097          	auipc	ra,0x2
    4c64:	da4080e7          	jalr	-604(ra) # 6a04 <printf>
    exit(1,"");
    4c68:	00003597          	auipc	a1,0x3
    4c6c:	59058593          	addi	a1,a1,1424 # 81f8 <malloc+0x1736>
    4c70:	4505                	li	a0,1
    4c72:	00002097          	auipc	ra,0x2
    4c76:	a0a080e7          	jalr	-1526(ra) # 667c <exit>
    exit(0,"");
    4c7a:	00003597          	auipc	a1,0x3
    4c7e:	57e58593          	addi	a1,a1,1406 # 81f8 <malloc+0x1736>
    4c82:	4501                	li	a0,0
    4c84:	00002097          	auipc	ra,0x2
    4c88:	9f8080e7          	jalr	-1544(ra) # 667c <exit>
  sleep(1);
    4c8c:	4505                	li	a0,1
    4c8e:	00002097          	auipc	ra,0x2
    4c92:	a7e080e7          	jalr	-1410(ra) # 670c <sleep>
  if(unlink("oidir") != 0){
    4c96:	00004517          	auipc	a0,0x4
    4c9a:	a9250513          	addi	a0,a0,-1390 # 8728 <malloc+0x1c66>
    4c9e:	00002097          	auipc	ra,0x2
    4ca2:	a2e080e7          	jalr	-1490(ra) # 66cc <unlink>
    4ca6:	c11d                	beqz	a0,4ccc <openiputtest+0x102>
    printf("%s: unlink failed\n", s);
    4ca8:	85a6                	mv	a1,s1
    4caa:	00003517          	auipc	a0,0x3
    4cae:	9d650513          	addi	a0,a0,-1578 # 7680 <malloc+0xbbe>
    4cb2:	00002097          	auipc	ra,0x2
    4cb6:	d52080e7          	jalr	-686(ra) # 6a04 <printf>
    exit(1,"");
    4cba:	00003597          	auipc	a1,0x3
    4cbe:	53e58593          	addi	a1,a1,1342 # 81f8 <malloc+0x1736>
    4cc2:	4505                	li	a0,1
    4cc4:	00002097          	auipc	ra,0x2
    4cc8:	9b8080e7          	jalr	-1608(ra) # 667c <exit>
  wait(&xstatus,0);
    4ccc:	4581                	li	a1,0
    4cce:	fdc40513          	addi	a0,s0,-36
    4cd2:	00002097          	auipc	ra,0x2
    4cd6:	9b2080e7          	jalr	-1614(ra) # 6684 <wait>
  exit(xstatus,"");
    4cda:	00003597          	auipc	a1,0x3
    4cde:	51e58593          	addi	a1,a1,1310 # 81f8 <malloc+0x1736>
    4ce2:	fdc42503          	lw	a0,-36(s0)
    4ce6:	00002097          	auipc	ra,0x2
    4cea:	996080e7          	jalr	-1642(ra) # 667c <exit>

0000000000004cee <forkforkfork>:
{
    4cee:	1101                	addi	sp,sp,-32
    4cf0:	ec06                	sd	ra,24(sp)
    4cf2:	e822                	sd	s0,16(sp)
    4cf4:	e426                	sd	s1,8(sp)
    4cf6:	1000                	addi	s0,sp,32
    4cf8:	84aa                	mv	s1,a0
  unlink("stopforking");
    4cfa:	00004517          	auipc	a0,0x4
    4cfe:	a7650513          	addi	a0,a0,-1418 # 8770 <malloc+0x1cae>
    4d02:	00002097          	auipc	ra,0x2
    4d06:	9ca080e7          	jalr	-1590(ra) # 66cc <unlink>
  int pid = fork();
    4d0a:	00002097          	auipc	ra,0x2
    4d0e:	96a080e7          	jalr	-1686(ra) # 6674 <fork>
  if(pid < 0){
    4d12:	04054663          	bltz	a0,4d5e <forkforkfork+0x70>
  if(pid == 0){
    4d16:	c535                	beqz	a0,4d82 <forkforkfork+0x94>
  sleep(20); // two seconds
    4d18:	4551                	li	a0,20
    4d1a:	00002097          	auipc	ra,0x2
    4d1e:	9f2080e7          	jalr	-1550(ra) # 670c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4d22:	20200593          	li	a1,514
    4d26:	00004517          	auipc	a0,0x4
    4d2a:	a4a50513          	addi	a0,a0,-1462 # 8770 <malloc+0x1cae>
    4d2e:	00002097          	auipc	ra,0x2
    4d32:	98e080e7          	jalr	-1650(ra) # 66bc <open>
    4d36:	00002097          	auipc	ra,0x2
    4d3a:	96e080e7          	jalr	-1682(ra) # 66a4 <close>
  wait(0,0);
    4d3e:	4581                	li	a1,0
    4d40:	4501                	li	a0,0
    4d42:	00002097          	auipc	ra,0x2
    4d46:	942080e7          	jalr	-1726(ra) # 6684 <wait>
  sleep(10); // one second
    4d4a:	4529                	li	a0,10
    4d4c:	00002097          	auipc	ra,0x2
    4d50:	9c0080e7          	jalr	-1600(ra) # 670c <sleep>
}
    4d54:	60e2                	ld	ra,24(sp)
    4d56:	6442                	ld	s0,16(sp)
    4d58:	64a2                	ld	s1,8(sp)
    4d5a:	6105                	addi	sp,sp,32
    4d5c:	8082                	ret
    printf("%s: fork failed", s);
    4d5e:	85a6                	mv	a1,s1
    4d60:	00003517          	auipc	a0,0x3
    4d64:	8f050513          	addi	a0,a0,-1808 # 7650 <malloc+0xb8e>
    4d68:	00002097          	auipc	ra,0x2
    4d6c:	c9c080e7          	jalr	-868(ra) # 6a04 <printf>
    exit(1,"");
    4d70:	00003597          	auipc	a1,0x3
    4d74:	48858593          	addi	a1,a1,1160 # 81f8 <malloc+0x1736>
    4d78:	4505                	li	a0,1
    4d7a:	00002097          	auipc	ra,0x2
    4d7e:	902080e7          	jalr	-1790(ra) # 667c <exit>
      int fd = open("stopforking", 0);
    4d82:	00004497          	auipc	s1,0x4
    4d86:	9ee48493          	addi	s1,s1,-1554 # 8770 <malloc+0x1cae>
    4d8a:	4581                	li	a1,0
    4d8c:	8526                	mv	a0,s1
    4d8e:	00002097          	auipc	ra,0x2
    4d92:	92e080e7          	jalr	-1746(ra) # 66bc <open>
      if(fd >= 0){
    4d96:	02055463          	bgez	a0,4dbe <forkforkfork+0xd0>
      if(fork() < 0){
    4d9a:	00002097          	auipc	ra,0x2
    4d9e:	8da080e7          	jalr	-1830(ra) # 6674 <fork>
    4da2:	fe0554e3          	bgez	a0,4d8a <forkforkfork+0x9c>
        close(open("stopforking", O_CREATE|O_RDWR));
    4da6:	20200593          	li	a1,514
    4daa:	8526                	mv	a0,s1
    4dac:	00002097          	auipc	ra,0x2
    4db0:	910080e7          	jalr	-1776(ra) # 66bc <open>
    4db4:	00002097          	auipc	ra,0x2
    4db8:	8f0080e7          	jalr	-1808(ra) # 66a4 <close>
    4dbc:	b7f9                	j	4d8a <forkforkfork+0x9c>
        exit(0,"");
    4dbe:	00003597          	auipc	a1,0x3
    4dc2:	43a58593          	addi	a1,a1,1082 # 81f8 <malloc+0x1736>
    4dc6:	4501                	li	a0,0
    4dc8:	00002097          	auipc	ra,0x2
    4dcc:	8b4080e7          	jalr	-1868(ra) # 667c <exit>

0000000000004dd0 <killstatus>:
{
    4dd0:	7139                	addi	sp,sp,-64
    4dd2:	fc06                	sd	ra,56(sp)
    4dd4:	f822                	sd	s0,48(sp)
    4dd6:	f426                	sd	s1,40(sp)
    4dd8:	f04a                	sd	s2,32(sp)
    4dda:	ec4e                	sd	s3,24(sp)
    4ddc:	e852                	sd	s4,16(sp)
    4dde:	0080                	addi	s0,sp,64
    4de0:	8a2a                	mv	s4,a0
    4de2:	06400913          	li	s2,100
    if(xst != -1) {
    4de6:	59fd                	li	s3,-1
    int pid1 = fork();
    4de8:	00002097          	auipc	ra,0x2
    4dec:	88c080e7          	jalr	-1908(ra) # 6674 <fork>
    4df0:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4df2:	04054463          	bltz	a0,4e3a <killstatus+0x6a>
    if(pid1 == 0){
    4df6:	c525                	beqz	a0,4e5e <killstatus+0x8e>
    sleep(1);
    4df8:	4505                	li	a0,1
    4dfa:	00002097          	auipc	ra,0x2
    4dfe:	912080e7          	jalr	-1774(ra) # 670c <sleep>
    kill(pid1);
    4e02:	8526                	mv	a0,s1
    4e04:	00002097          	auipc	ra,0x2
    4e08:	8a8080e7          	jalr	-1880(ra) # 66ac <kill>
    wait(&xst,0);
    4e0c:	4581                	li	a1,0
    4e0e:	fcc40513          	addi	a0,s0,-52
    4e12:	00002097          	auipc	ra,0x2
    4e16:	872080e7          	jalr	-1934(ra) # 6684 <wait>
    if(xst != -1) {
    4e1a:	fcc42783          	lw	a5,-52(s0)
    4e1e:	05379563          	bne	a5,s3,4e68 <killstatus+0x98>
  for(int i = 0; i < 100; i++){
    4e22:	397d                	addiw	s2,s2,-1
    4e24:	fc0912e3          	bnez	s2,4de8 <killstatus+0x18>
  exit(0,"");
    4e28:	00003597          	auipc	a1,0x3
    4e2c:	3d058593          	addi	a1,a1,976 # 81f8 <malloc+0x1736>
    4e30:	4501                	li	a0,0
    4e32:	00002097          	auipc	ra,0x2
    4e36:	84a080e7          	jalr	-1974(ra) # 667c <exit>
      printf("%s: fork failed\n", s);
    4e3a:	85d2                	mv	a1,s4
    4e3c:	00002517          	auipc	a0,0x2
    4e40:	65450513          	addi	a0,a0,1620 # 7490 <malloc+0x9ce>
    4e44:	00002097          	auipc	ra,0x2
    4e48:	bc0080e7          	jalr	-1088(ra) # 6a04 <printf>
      exit(1,"");
    4e4c:	00003597          	auipc	a1,0x3
    4e50:	3ac58593          	addi	a1,a1,940 # 81f8 <malloc+0x1736>
    4e54:	4505                	li	a0,1
    4e56:	00002097          	auipc	ra,0x2
    4e5a:	826080e7          	jalr	-2010(ra) # 667c <exit>
        getpid();
    4e5e:	00002097          	auipc	ra,0x2
    4e62:	89e080e7          	jalr	-1890(ra) # 66fc <getpid>
      while(1) {
    4e66:	bfe5                	j	4e5e <killstatus+0x8e>
       printf("%s: status should be -1\n", s);
    4e68:	85d2                	mv	a1,s4
    4e6a:	00004517          	auipc	a0,0x4
    4e6e:	91650513          	addi	a0,a0,-1770 # 8780 <malloc+0x1cbe>
    4e72:	00002097          	auipc	ra,0x2
    4e76:	b92080e7          	jalr	-1134(ra) # 6a04 <printf>
       exit(1,"");
    4e7a:	00003597          	auipc	a1,0x3
    4e7e:	37e58593          	addi	a1,a1,894 # 81f8 <malloc+0x1736>
    4e82:	4505                	li	a0,1
    4e84:	00001097          	auipc	ra,0x1
    4e88:	7f8080e7          	jalr	2040(ra) # 667c <exit>

0000000000004e8c <preempt>:
{
    4e8c:	7139                	addi	sp,sp,-64
    4e8e:	fc06                	sd	ra,56(sp)
    4e90:	f822                	sd	s0,48(sp)
    4e92:	f426                	sd	s1,40(sp)
    4e94:	f04a                	sd	s2,32(sp)
    4e96:	ec4e                	sd	s3,24(sp)
    4e98:	e852                	sd	s4,16(sp)
    4e9a:	0080                	addi	s0,sp,64
    4e9c:	892a                	mv	s2,a0
  pid1 = fork();
    4e9e:	00001097          	auipc	ra,0x1
    4ea2:	7d6080e7          	jalr	2006(ra) # 6674 <fork>
  if(pid1 < 0) {
    4ea6:	00054563          	bltz	a0,4eb0 <preempt+0x24>
    4eaa:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4eac:	e505                	bnez	a0,4ed4 <preempt+0x48>
    for(;;)
    4eae:	a001                	j	4eae <preempt+0x22>
    printf("%s: fork failed", s);
    4eb0:	85ca                	mv	a1,s2
    4eb2:	00002517          	auipc	a0,0x2
    4eb6:	79e50513          	addi	a0,a0,1950 # 7650 <malloc+0xb8e>
    4eba:	00002097          	auipc	ra,0x2
    4ebe:	b4a080e7          	jalr	-1206(ra) # 6a04 <printf>
    exit(1,"");
    4ec2:	00003597          	auipc	a1,0x3
    4ec6:	33658593          	addi	a1,a1,822 # 81f8 <malloc+0x1736>
    4eca:	4505                	li	a0,1
    4ecc:	00001097          	auipc	ra,0x1
    4ed0:	7b0080e7          	jalr	1968(ra) # 667c <exit>
  pid2 = fork();
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	7a0080e7          	jalr	1952(ra) # 6674 <fork>
    4edc:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4ede:	00054463          	bltz	a0,4ee6 <preempt+0x5a>
  if(pid2 == 0)
    4ee2:	e505                	bnez	a0,4f0a <preempt+0x7e>
    for(;;)
    4ee4:	a001                	j	4ee4 <preempt+0x58>
    printf("%s: fork failed\n", s);
    4ee6:	85ca                	mv	a1,s2
    4ee8:	00002517          	auipc	a0,0x2
    4eec:	5a850513          	addi	a0,a0,1448 # 7490 <malloc+0x9ce>
    4ef0:	00002097          	auipc	ra,0x2
    4ef4:	b14080e7          	jalr	-1260(ra) # 6a04 <printf>
    exit(1,"");
    4ef8:	00003597          	auipc	a1,0x3
    4efc:	30058593          	addi	a1,a1,768 # 81f8 <malloc+0x1736>
    4f00:	4505                	li	a0,1
    4f02:	00001097          	auipc	ra,0x1
    4f06:	77a080e7          	jalr	1914(ra) # 667c <exit>
  pipe(pfds);
    4f0a:	fc840513          	addi	a0,s0,-56
    4f0e:	00001097          	auipc	ra,0x1
    4f12:	77e080e7          	jalr	1918(ra) # 668c <pipe>
  pid3 = fork();
    4f16:	00001097          	auipc	ra,0x1
    4f1a:	75e080e7          	jalr	1886(ra) # 6674 <fork>
    4f1e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4f20:	02054e63          	bltz	a0,4f5c <preempt+0xd0>
  if(pid3 == 0){
    4f24:	e925                	bnez	a0,4f94 <preempt+0x108>
    close(pfds[0]);
    4f26:	fc842503          	lw	a0,-56(s0)
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	77a080e7          	jalr	1914(ra) # 66a4 <close>
    if(write(pfds[1], "x", 1) != 1)
    4f32:	4605                	li	a2,1
    4f34:	00002597          	auipc	a1,0x2
    4f38:	d4458593          	addi	a1,a1,-700 # 6c78 <malloc+0x1b6>
    4f3c:	fcc42503          	lw	a0,-52(s0)
    4f40:	00001097          	auipc	ra,0x1
    4f44:	75c080e7          	jalr	1884(ra) # 669c <write>
    4f48:	4785                	li	a5,1
    4f4a:	02f51b63          	bne	a0,a5,4f80 <preempt+0xf4>
    close(pfds[1]);
    4f4e:	fcc42503          	lw	a0,-52(s0)
    4f52:	00001097          	auipc	ra,0x1
    4f56:	752080e7          	jalr	1874(ra) # 66a4 <close>
    for(;;)
    4f5a:	a001                	j	4f5a <preempt+0xce>
     printf("%s: fork failed\n", s);
    4f5c:	85ca                	mv	a1,s2
    4f5e:	00002517          	auipc	a0,0x2
    4f62:	53250513          	addi	a0,a0,1330 # 7490 <malloc+0x9ce>
    4f66:	00002097          	auipc	ra,0x2
    4f6a:	a9e080e7          	jalr	-1378(ra) # 6a04 <printf>
     exit(1,"");
    4f6e:	00003597          	auipc	a1,0x3
    4f72:	28a58593          	addi	a1,a1,650 # 81f8 <malloc+0x1736>
    4f76:	4505                	li	a0,1
    4f78:	00001097          	auipc	ra,0x1
    4f7c:	704080e7          	jalr	1796(ra) # 667c <exit>
      printf("%s: preempt write error", s);
    4f80:	85ca                	mv	a1,s2
    4f82:	00004517          	auipc	a0,0x4
    4f86:	81e50513          	addi	a0,a0,-2018 # 87a0 <malloc+0x1cde>
    4f8a:	00002097          	auipc	ra,0x2
    4f8e:	a7a080e7          	jalr	-1414(ra) # 6a04 <printf>
    4f92:	bf75                	j	4f4e <preempt+0xc2>
  close(pfds[1]);
    4f94:	fcc42503          	lw	a0,-52(s0)
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	70c080e7          	jalr	1804(ra) # 66a4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4fa0:	660d                	lui	a2,0x3
    4fa2:	00009597          	auipc	a1,0x9
    4fa6:	cd658593          	addi	a1,a1,-810 # dc78 <buf>
    4faa:	fc842503          	lw	a0,-56(s0)
    4fae:	00001097          	auipc	ra,0x1
    4fb2:	6e6080e7          	jalr	1766(ra) # 6694 <read>
    4fb6:	4785                	li	a5,1
    4fb8:	02f50363          	beq	a0,a5,4fde <preempt+0x152>
    printf("%s: preempt read error", s);
    4fbc:	85ca                	mv	a1,s2
    4fbe:	00003517          	auipc	a0,0x3
    4fc2:	7fa50513          	addi	a0,a0,2042 # 87b8 <malloc+0x1cf6>
    4fc6:	00002097          	auipc	ra,0x2
    4fca:	a3e080e7          	jalr	-1474(ra) # 6a04 <printf>
}
    4fce:	70e2                	ld	ra,56(sp)
    4fd0:	7442                	ld	s0,48(sp)
    4fd2:	74a2                	ld	s1,40(sp)
    4fd4:	7902                	ld	s2,32(sp)
    4fd6:	69e2                	ld	s3,24(sp)
    4fd8:	6a42                	ld	s4,16(sp)
    4fda:	6121                	addi	sp,sp,64
    4fdc:	8082                	ret
  close(pfds[0]);
    4fde:	fc842503          	lw	a0,-56(s0)
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	6c2080e7          	jalr	1730(ra) # 66a4 <close>
  printf("kill... ");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	7e650513          	addi	a0,a0,2022 # 87d0 <malloc+0x1d0e>
    4ff2:	00002097          	auipc	ra,0x2
    4ff6:	a12080e7          	jalr	-1518(ra) # 6a04 <printf>
  kill(pid1);
    4ffa:	8526                	mv	a0,s1
    4ffc:	00001097          	auipc	ra,0x1
    5000:	6b0080e7          	jalr	1712(ra) # 66ac <kill>
  kill(pid2);
    5004:	854e                	mv	a0,s3
    5006:	00001097          	auipc	ra,0x1
    500a:	6a6080e7          	jalr	1702(ra) # 66ac <kill>
  kill(pid3);
    500e:	8552                	mv	a0,s4
    5010:	00001097          	auipc	ra,0x1
    5014:	69c080e7          	jalr	1692(ra) # 66ac <kill>
  printf("wait... ");
    5018:	00003517          	auipc	a0,0x3
    501c:	7c850513          	addi	a0,a0,1992 # 87e0 <malloc+0x1d1e>
    5020:	00002097          	auipc	ra,0x2
    5024:	9e4080e7          	jalr	-1564(ra) # 6a04 <printf>
  wait(0,0);
    5028:	4581                	li	a1,0
    502a:	4501                	li	a0,0
    502c:	00001097          	auipc	ra,0x1
    5030:	658080e7          	jalr	1624(ra) # 6684 <wait>
  wait(0,0);
    5034:	4581                	li	a1,0
    5036:	4501                	li	a0,0
    5038:	00001097          	auipc	ra,0x1
    503c:	64c080e7          	jalr	1612(ra) # 6684 <wait>
  wait(0,0);
    5040:	4581                	li	a1,0
    5042:	4501                	li	a0,0
    5044:	00001097          	auipc	ra,0x1
    5048:	640080e7          	jalr	1600(ra) # 6684 <wait>
    504c:	b749                	j	4fce <preempt+0x142>

000000000000504e <reparent>:
{
    504e:	7179                	addi	sp,sp,-48
    5050:	f406                	sd	ra,40(sp)
    5052:	f022                	sd	s0,32(sp)
    5054:	ec26                	sd	s1,24(sp)
    5056:	e84a                	sd	s2,16(sp)
    5058:	e44e                	sd	s3,8(sp)
    505a:	e052                	sd	s4,0(sp)
    505c:	1800                	addi	s0,sp,48
    505e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    5060:	00001097          	auipc	ra,0x1
    5064:	69c080e7          	jalr	1692(ra) # 66fc <getpid>
    5068:	8a2a                	mv	s4,a0
    506a:	0c800913          	li	s2,200
    int pid = fork();
    506e:	00001097          	auipc	ra,0x1
    5072:	606080e7          	jalr	1542(ra) # 6674 <fork>
    5076:	84aa                	mv	s1,a0
    if(pid < 0){
    5078:	02054763          	bltz	a0,50a6 <reparent+0x58>
    if(pid){
    507c:	c92d                	beqz	a0,50ee <reparent+0xa0>
      if(wait(0,0) != pid){
    507e:	4581                	li	a1,0
    5080:	4501                	li	a0,0
    5082:	00001097          	auipc	ra,0x1
    5086:	602080e7          	jalr	1538(ra) # 6684 <wait>
    508a:	04951063          	bne	a0,s1,50ca <reparent+0x7c>
  for(int i = 0; i < 200; i++){
    508e:	397d                	addiw	s2,s2,-1
    5090:	fc091fe3          	bnez	s2,506e <reparent+0x20>
  exit(0,"");
    5094:	00003597          	auipc	a1,0x3
    5098:	16458593          	addi	a1,a1,356 # 81f8 <malloc+0x1736>
    509c:	4501                	li	a0,0
    509e:	00001097          	auipc	ra,0x1
    50a2:	5de080e7          	jalr	1502(ra) # 667c <exit>
      printf("%s: fork failed\n", s);
    50a6:	85ce                	mv	a1,s3
    50a8:	00002517          	auipc	a0,0x2
    50ac:	3e850513          	addi	a0,a0,1000 # 7490 <malloc+0x9ce>
    50b0:	00002097          	auipc	ra,0x2
    50b4:	954080e7          	jalr	-1708(ra) # 6a04 <printf>
      exit(1,"");
    50b8:	00003597          	auipc	a1,0x3
    50bc:	14058593          	addi	a1,a1,320 # 81f8 <malloc+0x1736>
    50c0:	4505                	li	a0,1
    50c2:	00001097          	auipc	ra,0x1
    50c6:	5ba080e7          	jalr	1466(ra) # 667c <exit>
        printf("%s: wait wrong pid\n", s);
    50ca:	85ce                	mv	a1,s3
    50cc:	00002517          	auipc	a0,0x2
    50d0:	54c50513          	addi	a0,a0,1356 # 7618 <malloc+0xb56>
    50d4:	00002097          	auipc	ra,0x2
    50d8:	930080e7          	jalr	-1744(ra) # 6a04 <printf>
        exit(1,"");
    50dc:	00003597          	auipc	a1,0x3
    50e0:	11c58593          	addi	a1,a1,284 # 81f8 <malloc+0x1736>
    50e4:	4505                	li	a0,1
    50e6:	00001097          	auipc	ra,0x1
    50ea:	596080e7          	jalr	1430(ra) # 667c <exit>
      int pid2 = fork();
    50ee:	00001097          	auipc	ra,0x1
    50f2:	586080e7          	jalr	1414(ra) # 6674 <fork>
      if(pid2 < 0){
    50f6:	00054b63          	bltz	a0,510c <reparent+0xbe>
      exit(0,"");
    50fa:	00003597          	auipc	a1,0x3
    50fe:	0fe58593          	addi	a1,a1,254 # 81f8 <malloc+0x1736>
    5102:	4501                	li	a0,0
    5104:	00001097          	auipc	ra,0x1
    5108:	578080e7          	jalr	1400(ra) # 667c <exit>
        kill(master_pid);
    510c:	8552                	mv	a0,s4
    510e:	00001097          	auipc	ra,0x1
    5112:	59e080e7          	jalr	1438(ra) # 66ac <kill>
        exit(1,"");
    5116:	00003597          	auipc	a1,0x3
    511a:	0e258593          	addi	a1,a1,226 # 81f8 <malloc+0x1736>
    511e:	4505                	li	a0,1
    5120:	00001097          	auipc	ra,0x1
    5124:	55c080e7          	jalr	1372(ra) # 667c <exit>

0000000000005128 <sbrkfail>:
{
    5128:	7119                	addi	sp,sp,-128
    512a:	fc86                	sd	ra,120(sp)
    512c:	f8a2                	sd	s0,112(sp)
    512e:	f4a6                	sd	s1,104(sp)
    5130:	f0ca                	sd	s2,96(sp)
    5132:	ecce                	sd	s3,88(sp)
    5134:	e8d2                	sd	s4,80(sp)
    5136:	e4d6                	sd	s5,72(sp)
    5138:	0100                	addi	s0,sp,128
    513a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    513c:	fb040513          	addi	a0,s0,-80
    5140:	00001097          	auipc	ra,0x1
    5144:	54c080e7          	jalr	1356(ra) # 668c <pipe>
    5148:	e901                	bnez	a0,5158 <sbrkfail+0x30>
    514a:	f8040493          	addi	s1,s0,-128
    514e:	fa840993          	addi	s3,s0,-88
    5152:	8926                	mv	s2,s1
    if(pids[i] != -1)
    5154:	5a7d                	li	s4,-1
    5156:	a0a5                	j	51be <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    5158:	85d6                	mv	a1,s5
    515a:	00002517          	auipc	a0,0x2
    515e:	43e50513          	addi	a0,a0,1086 # 7598 <malloc+0xad6>
    5162:	00002097          	auipc	ra,0x2
    5166:	8a2080e7          	jalr	-1886(ra) # 6a04 <printf>
    exit(1,"");
    516a:	00003597          	auipc	a1,0x3
    516e:	08e58593          	addi	a1,a1,142 # 81f8 <malloc+0x1736>
    5172:	4505                	li	a0,1
    5174:	00001097          	auipc	ra,0x1
    5178:	508080e7          	jalr	1288(ra) # 667c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    517c:	00001097          	auipc	ra,0x1
    5180:	588080e7          	jalr	1416(ra) # 6704 <sbrk>
    5184:	064007b7          	lui	a5,0x6400
    5188:	40a7853b          	subw	a0,a5,a0
    518c:	00001097          	auipc	ra,0x1
    5190:	578080e7          	jalr	1400(ra) # 6704 <sbrk>
      write(fds[1], "x", 1);
    5194:	4605                	li	a2,1
    5196:	00002597          	auipc	a1,0x2
    519a:	ae258593          	addi	a1,a1,-1310 # 6c78 <malloc+0x1b6>
    519e:	fb442503          	lw	a0,-76(s0)
    51a2:	00001097          	auipc	ra,0x1
    51a6:	4fa080e7          	jalr	1274(ra) # 669c <write>
      for(;;) sleep(1000);
    51aa:	3e800513          	li	a0,1000
    51ae:	00001097          	auipc	ra,0x1
    51b2:	55e080e7          	jalr	1374(ra) # 670c <sleep>
    51b6:	bfd5                	j	51aa <sbrkfail+0x82>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    51b8:	0911                	addi	s2,s2,4
    51ba:	03390563          	beq	s2,s3,51e4 <sbrkfail+0xbc>
    if((pids[i] = fork()) == 0){
    51be:	00001097          	auipc	ra,0x1
    51c2:	4b6080e7          	jalr	1206(ra) # 6674 <fork>
    51c6:	00a92023          	sw	a0,0(s2)
    51ca:	d94d                	beqz	a0,517c <sbrkfail+0x54>
    if(pids[i] != -1)
    51cc:	ff4506e3          	beq	a0,s4,51b8 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    51d0:	4605                	li	a2,1
    51d2:	faf40593          	addi	a1,s0,-81
    51d6:	fb042503          	lw	a0,-80(s0)
    51da:	00001097          	auipc	ra,0x1
    51de:	4ba080e7          	jalr	1210(ra) # 6694 <read>
    51e2:	bfd9                	j	51b8 <sbrkfail+0x90>
  c = sbrk(PGSIZE);
    51e4:	6505                	lui	a0,0x1
    51e6:	00001097          	auipc	ra,0x1
    51ea:	51e080e7          	jalr	1310(ra) # 6704 <sbrk>
    51ee:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    51f0:	597d                	li	s2,-1
    51f2:	a021                	j	51fa <sbrkfail+0xd2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    51f4:	0491                	addi	s1,s1,4
    51f6:	03348063          	beq	s1,s3,5216 <sbrkfail+0xee>
    if(pids[i] == -1)
    51fa:	4088                	lw	a0,0(s1)
    51fc:	ff250ce3          	beq	a0,s2,51f4 <sbrkfail+0xcc>
    kill(pids[i]);
    5200:	00001097          	auipc	ra,0x1
    5204:	4ac080e7          	jalr	1196(ra) # 66ac <kill>
    wait(0,0);
    5208:	4581                	li	a1,0
    520a:	4501                	li	a0,0
    520c:	00001097          	auipc	ra,0x1
    5210:	478080e7          	jalr	1144(ra) # 6684 <wait>
    5214:	b7c5                	j	51f4 <sbrkfail+0xcc>
  if(c == (char*)0xffffffffffffffffL){
    5216:	57fd                	li	a5,-1
    5218:	04fa0263          	beq	s4,a5,525c <sbrkfail+0x134>
  pid = fork();
    521c:	00001097          	auipc	ra,0x1
    5220:	458080e7          	jalr	1112(ra) # 6674 <fork>
    5224:	84aa                	mv	s1,a0
  if(pid < 0){
    5226:	04054d63          	bltz	a0,5280 <sbrkfail+0x158>
  if(pid == 0){
    522a:	cd2d                	beqz	a0,52a4 <sbrkfail+0x17c>
  wait(&xstatus,0);
    522c:	4581                	li	a1,0
    522e:	fbc40513          	addi	a0,s0,-68
    5232:	00001097          	auipc	ra,0x1
    5236:	452080e7          	jalr	1106(ra) # 6684 <wait>
  if(xstatus != -1 && xstatus != 2)
    523a:	fbc42783          	lw	a5,-68(s0)
    523e:	577d                	li	a4,-1
    5240:	00e78563          	beq	a5,a4,524a <sbrkfail+0x122>
    5244:	4709                	li	a4,2
    5246:	0ae79963          	bne	a5,a4,52f8 <sbrkfail+0x1d0>
}
    524a:	70e6                	ld	ra,120(sp)
    524c:	7446                	ld	s0,112(sp)
    524e:	74a6                	ld	s1,104(sp)
    5250:	7906                	ld	s2,96(sp)
    5252:	69e6                	ld	s3,88(sp)
    5254:	6a46                	ld	s4,80(sp)
    5256:	6aa6                	ld	s5,72(sp)
    5258:	6109                	addi	sp,sp,128
    525a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    525c:	85d6                	mv	a1,s5
    525e:	00003517          	auipc	a0,0x3
    5262:	59250513          	addi	a0,a0,1426 # 87f0 <malloc+0x1d2e>
    5266:	00001097          	auipc	ra,0x1
    526a:	79e080e7          	jalr	1950(ra) # 6a04 <printf>
    exit(1,"");
    526e:	00003597          	auipc	a1,0x3
    5272:	f8a58593          	addi	a1,a1,-118 # 81f8 <malloc+0x1736>
    5276:	4505                	li	a0,1
    5278:	00001097          	auipc	ra,0x1
    527c:	404080e7          	jalr	1028(ra) # 667c <exit>
    printf("%s: fork failed\n", s);
    5280:	85d6                	mv	a1,s5
    5282:	00002517          	auipc	a0,0x2
    5286:	20e50513          	addi	a0,a0,526 # 7490 <malloc+0x9ce>
    528a:	00001097          	auipc	ra,0x1
    528e:	77a080e7          	jalr	1914(ra) # 6a04 <printf>
    exit(1,"");
    5292:	00003597          	auipc	a1,0x3
    5296:	f6658593          	addi	a1,a1,-154 # 81f8 <malloc+0x1736>
    529a:	4505                	li	a0,1
    529c:	00001097          	auipc	ra,0x1
    52a0:	3e0080e7          	jalr	992(ra) # 667c <exit>
    a = sbrk(0);
    52a4:	4501                	li	a0,0
    52a6:	00001097          	auipc	ra,0x1
    52aa:	45e080e7          	jalr	1118(ra) # 6704 <sbrk>
    52ae:	892a                	mv	s2,a0
    sbrk(10*BIG);
    52b0:	3e800537          	lui	a0,0x3e800
    52b4:	00001097          	auipc	ra,0x1
    52b8:	450080e7          	jalr	1104(ra) # 6704 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52bc:	87ca                	mv	a5,s2
    52be:	3e800737          	lui	a4,0x3e800
    52c2:	993a                	add	s2,s2,a4
    52c4:	6705                	lui	a4,0x1
      n += *(a+i);
    52c6:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63ef388>
    52ca:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52cc:	97ba                	add	a5,a5,a4
    52ce:	ff279ce3          	bne	a5,s2,52c6 <sbrkfail+0x19e>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    52d2:	8626                	mv	a2,s1
    52d4:	85d6                	mv	a1,s5
    52d6:	00003517          	auipc	a0,0x3
    52da:	53a50513          	addi	a0,a0,1338 # 8810 <malloc+0x1d4e>
    52de:	00001097          	auipc	ra,0x1
    52e2:	726080e7          	jalr	1830(ra) # 6a04 <printf>
    exit(1,"");
    52e6:	00003597          	auipc	a1,0x3
    52ea:	f1258593          	addi	a1,a1,-238 # 81f8 <malloc+0x1736>
    52ee:	4505                	li	a0,1
    52f0:	00001097          	auipc	ra,0x1
    52f4:	38c080e7          	jalr	908(ra) # 667c <exit>
    exit(1,"");
    52f8:	00003597          	auipc	a1,0x3
    52fc:	f0058593          	addi	a1,a1,-256 # 81f8 <malloc+0x1736>
    5300:	4505                	li	a0,1
    5302:	00001097          	auipc	ra,0x1
    5306:	37a080e7          	jalr	890(ra) # 667c <exit>

000000000000530a <mem>:
{
    530a:	7139                	addi	sp,sp,-64
    530c:	fc06                	sd	ra,56(sp)
    530e:	f822                	sd	s0,48(sp)
    5310:	f426                	sd	s1,40(sp)
    5312:	f04a                	sd	s2,32(sp)
    5314:	ec4e                	sd	s3,24(sp)
    5316:	0080                	addi	s0,sp,64
    5318:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    531a:	00001097          	auipc	ra,0x1
    531e:	35a080e7          	jalr	858(ra) # 6674 <fork>
    m1 = 0;
    5322:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    5324:	6909                	lui	s2,0x2
    5326:	71190913          	addi	s2,s2,1809 # 2711 <bigargtest+0x39>
  if((pid = fork()) == 0){
    532a:	c51d                	beqz	a0,5358 <mem+0x4e>
    wait(&xstatus,0);
    532c:	4581                	li	a1,0
    532e:	fcc40513          	addi	a0,s0,-52
    5332:	00001097          	auipc	ra,0x1
    5336:	352080e7          	jalr	850(ra) # 6684 <wait>
    if(xstatus == -1){
    533a:	fcc42503          	lw	a0,-52(s0)
    533e:	57fd                	li	a5,-1
    5340:	06f50f63          	beq	a0,a5,53be <mem+0xb4>
    exit(xstatus,"");
    5344:	00003597          	auipc	a1,0x3
    5348:	eb458593          	addi	a1,a1,-332 # 81f8 <malloc+0x1736>
    534c:	00001097          	auipc	ra,0x1
    5350:	330080e7          	jalr	816(ra) # 667c <exit>
      *(char**)m2 = m1;
    5354:	e104                	sd	s1,0(a0)
      m1 = m2;
    5356:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    5358:	854a                	mv	a0,s2
    535a:	00001097          	auipc	ra,0x1
    535e:	768080e7          	jalr	1896(ra) # 6ac2 <malloc>
    5362:	f96d                	bnez	a0,5354 <mem+0x4a>
    while(m1){
    5364:	c881                	beqz	s1,5374 <mem+0x6a>
      m2 = *(char**)m1;
    5366:	8526                	mv	a0,s1
    5368:	6084                	ld	s1,0(s1)
      free(m1);
    536a:	00001097          	auipc	ra,0x1
    536e:	6d0080e7          	jalr	1744(ra) # 6a3a <free>
    while(m1){
    5372:	f8f5                	bnez	s1,5366 <mem+0x5c>
    m1 = malloc(1024*20);
    5374:	6515                	lui	a0,0x5
    5376:	00001097          	auipc	ra,0x1
    537a:	74c080e7          	jalr	1868(ra) # 6ac2 <malloc>
    if(m1 == 0){
    537e:	cd11                	beqz	a0,539a <mem+0x90>
    free(m1);
    5380:	00001097          	auipc	ra,0x1
    5384:	6ba080e7          	jalr	1722(ra) # 6a3a <free>
    exit(0,"");
    5388:	00003597          	auipc	a1,0x3
    538c:	e7058593          	addi	a1,a1,-400 # 81f8 <malloc+0x1736>
    5390:	4501                	li	a0,0
    5392:	00001097          	auipc	ra,0x1
    5396:	2ea080e7          	jalr	746(ra) # 667c <exit>
      printf("couldn't allocate mem?!!\n", s);
    539a:	85ce                	mv	a1,s3
    539c:	00003517          	auipc	a0,0x3
    53a0:	4a450513          	addi	a0,a0,1188 # 8840 <malloc+0x1d7e>
    53a4:	00001097          	auipc	ra,0x1
    53a8:	660080e7          	jalr	1632(ra) # 6a04 <printf>
      exit(1,"");
    53ac:	00003597          	auipc	a1,0x3
    53b0:	e4c58593          	addi	a1,a1,-436 # 81f8 <malloc+0x1736>
    53b4:	4505                	li	a0,1
    53b6:	00001097          	auipc	ra,0x1
    53ba:	2c6080e7          	jalr	710(ra) # 667c <exit>
      exit(0,"");
    53be:	00003597          	auipc	a1,0x3
    53c2:	e3a58593          	addi	a1,a1,-454 # 81f8 <malloc+0x1736>
    53c6:	4501                	li	a0,0
    53c8:	00001097          	auipc	ra,0x1
    53cc:	2b4080e7          	jalr	692(ra) # 667c <exit>

00000000000053d0 <sharedfd>:
{
    53d0:	7159                	addi	sp,sp,-112
    53d2:	f486                	sd	ra,104(sp)
    53d4:	f0a2                	sd	s0,96(sp)
    53d6:	eca6                	sd	s1,88(sp)
    53d8:	e8ca                	sd	s2,80(sp)
    53da:	e4ce                	sd	s3,72(sp)
    53dc:	e0d2                	sd	s4,64(sp)
    53de:	fc56                	sd	s5,56(sp)
    53e0:	f85a                	sd	s6,48(sp)
    53e2:	f45e                	sd	s7,40(sp)
    53e4:	1880                	addi	s0,sp,112
    53e6:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    53e8:	00003517          	auipc	a0,0x3
    53ec:	47850513          	addi	a0,a0,1144 # 8860 <malloc+0x1d9e>
    53f0:	00001097          	auipc	ra,0x1
    53f4:	2dc080e7          	jalr	732(ra) # 66cc <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    53f8:	20200593          	li	a1,514
    53fc:	00003517          	auipc	a0,0x3
    5400:	46450513          	addi	a0,a0,1124 # 8860 <malloc+0x1d9e>
    5404:	00001097          	auipc	ra,0x1
    5408:	2b8080e7          	jalr	696(ra) # 66bc <open>
  if(fd < 0){
    540c:	04054e63          	bltz	a0,5468 <sharedfd+0x98>
    5410:	892a                	mv	s2,a0
  pid = fork();
    5412:	00001097          	auipc	ra,0x1
    5416:	262080e7          	jalr	610(ra) # 6674 <fork>
    541a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    541c:	06300593          	li	a1,99
    5420:	c119                	beqz	a0,5426 <sharedfd+0x56>
    5422:	07000593          	li	a1,112
    5426:	4629                	li	a2,10
    5428:	fa040513          	addi	a0,s0,-96
    542c:	00001097          	auipc	ra,0x1
    5430:	054080e7          	jalr	84(ra) # 6480 <memset>
    5434:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    5438:	4629                	li	a2,10
    543a:	fa040593          	addi	a1,s0,-96
    543e:	854a                	mv	a0,s2
    5440:	00001097          	auipc	ra,0x1
    5444:	25c080e7          	jalr	604(ra) # 669c <write>
    5448:	47a9                	li	a5,10
    544a:	04f51163          	bne	a0,a5,548c <sharedfd+0xbc>
  for(i = 0; i < N; i++){
    544e:	34fd                	addiw	s1,s1,-1
    5450:	f4e5                	bnez	s1,5438 <sharedfd+0x68>
  if(pid == 0) {
    5452:	04099f63          	bnez	s3,54b0 <sharedfd+0xe0>
    exit(0,"");
    5456:	00003597          	auipc	a1,0x3
    545a:	da258593          	addi	a1,a1,-606 # 81f8 <malloc+0x1736>
    545e:	4501                	li	a0,0
    5460:	00001097          	auipc	ra,0x1
    5464:	21c080e7          	jalr	540(ra) # 667c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    5468:	85d2                	mv	a1,s4
    546a:	00003517          	auipc	a0,0x3
    546e:	40650513          	addi	a0,a0,1030 # 8870 <malloc+0x1dae>
    5472:	00001097          	auipc	ra,0x1
    5476:	592080e7          	jalr	1426(ra) # 6a04 <printf>
    exit(1,"");
    547a:	00003597          	auipc	a1,0x3
    547e:	d7e58593          	addi	a1,a1,-642 # 81f8 <malloc+0x1736>
    5482:	4505                	li	a0,1
    5484:	00001097          	auipc	ra,0x1
    5488:	1f8080e7          	jalr	504(ra) # 667c <exit>
      printf("%s: write sharedfd failed\n", s);
    548c:	85d2                	mv	a1,s4
    548e:	00003517          	auipc	a0,0x3
    5492:	40a50513          	addi	a0,a0,1034 # 8898 <malloc+0x1dd6>
    5496:	00001097          	auipc	ra,0x1
    549a:	56e080e7          	jalr	1390(ra) # 6a04 <printf>
      exit(1,"");
    549e:	00003597          	auipc	a1,0x3
    54a2:	d5a58593          	addi	a1,a1,-678 # 81f8 <malloc+0x1736>
    54a6:	4505                	li	a0,1
    54a8:	00001097          	auipc	ra,0x1
    54ac:	1d4080e7          	jalr	468(ra) # 667c <exit>
    wait(&xstatus,0);
    54b0:	4581                	li	a1,0
    54b2:	f9c40513          	addi	a0,s0,-100
    54b6:	00001097          	auipc	ra,0x1
    54ba:	1ce080e7          	jalr	462(ra) # 6684 <wait>
    if(xstatus != 0)
    54be:	f9c42983          	lw	s3,-100(s0)
    54c2:	00098b63          	beqz	s3,54d8 <sharedfd+0x108>
      exit(xstatus,"");
    54c6:	00003597          	auipc	a1,0x3
    54ca:	d3258593          	addi	a1,a1,-718 # 81f8 <malloc+0x1736>
    54ce:	854e                	mv	a0,s3
    54d0:	00001097          	auipc	ra,0x1
    54d4:	1ac080e7          	jalr	428(ra) # 667c <exit>
  close(fd);
    54d8:	854a                	mv	a0,s2
    54da:	00001097          	auipc	ra,0x1
    54de:	1ca080e7          	jalr	458(ra) # 66a4 <close>
  fd = open("sharedfd", 0);
    54e2:	4581                	li	a1,0
    54e4:	00003517          	auipc	a0,0x3
    54e8:	37c50513          	addi	a0,a0,892 # 8860 <malloc+0x1d9e>
    54ec:	00001097          	auipc	ra,0x1
    54f0:	1d0080e7          	jalr	464(ra) # 66bc <open>
    54f4:	8baa                	mv	s7,a0
  nc = np = 0;
    54f6:	8ace                	mv	s5,s3
  if(fd < 0){
    54f8:	02054563          	bltz	a0,5522 <sharedfd+0x152>
    54fc:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    5500:	06300493          	li	s1,99
      if(buf[i] == 'p')
    5504:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    5508:	4629                	li	a2,10
    550a:	fa040593          	addi	a1,s0,-96
    550e:	855e                	mv	a0,s7
    5510:	00001097          	auipc	ra,0x1
    5514:	184080e7          	jalr	388(ra) # 6694 <read>
    5518:	04a05363          	blez	a0,555e <sharedfd+0x18e>
    551c:	fa040793          	addi	a5,s0,-96
    5520:	a03d                	j	554e <sharedfd+0x17e>
    printf("%s: cannot open sharedfd for reading\n", s);
    5522:	85d2                	mv	a1,s4
    5524:	00003517          	auipc	a0,0x3
    5528:	39450513          	addi	a0,a0,916 # 88b8 <malloc+0x1df6>
    552c:	00001097          	auipc	ra,0x1
    5530:	4d8080e7          	jalr	1240(ra) # 6a04 <printf>
    exit(1,"");
    5534:	00003597          	auipc	a1,0x3
    5538:	cc458593          	addi	a1,a1,-828 # 81f8 <malloc+0x1736>
    553c:	4505                	li	a0,1
    553e:	00001097          	auipc	ra,0x1
    5542:	13e080e7          	jalr	318(ra) # 667c <exit>
        nc++;
    5546:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    5548:	0785                	addi	a5,a5,1
    554a:	fb278fe3          	beq	a5,s2,5508 <sharedfd+0x138>
      if(buf[i] == 'c')
    554e:	0007c703          	lbu	a4,0(a5)
    5552:	fe970ae3          	beq	a4,s1,5546 <sharedfd+0x176>
      if(buf[i] == 'p')
    5556:	ff6719e3          	bne	a4,s6,5548 <sharedfd+0x178>
        np++;
    555a:	2a85                	addiw	s5,s5,1
    555c:	b7f5                	j	5548 <sharedfd+0x178>
  close(fd);
    555e:	855e                	mv	a0,s7
    5560:	00001097          	auipc	ra,0x1
    5564:	144080e7          	jalr	324(ra) # 66a4 <close>
  unlink("sharedfd");
    5568:	00003517          	auipc	a0,0x3
    556c:	2f850513          	addi	a0,a0,760 # 8860 <malloc+0x1d9e>
    5570:	00001097          	auipc	ra,0x1
    5574:	15c080e7          	jalr	348(ra) # 66cc <unlink>
  if(nc == N*SZ && np == N*SZ){
    5578:	6789                	lui	a5,0x2
    557a:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x38>
    557e:	00f99763          	bne	s3,a5,558c <sharedfd+0x1bc>
    5582:	6789                	lui	a5,0x2
    5584:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x38>
    5588:	02fa8463          	beq	s5,a5,55b0 <sharedfd+0x1e0>
    printf("%s: nc/np test fails\n", s);
    558c:	85d2                	mv	a1,s4
    558e:	00003517          	auipc	a0,0x3
    5592:	35250513          	addi	a0,a0,850 # 88e0 <malloc+0x1e1e>
    5596:	00001097          	auipc	ra,0x1
    559a:	46e080e7          	jalr	1134(ra) # 6a04 <printf>
    exit(1,"");
    559e:	00003597          	auipc	a1,0x3
    55a2:	c5a58593          	addi	a1,a1,-934 # 81f8 <malloc+0x1736>
    55a6:	4505                	li	a0,1
    55a8:	00001097          	auipc	ra,0x1
    55ac:	0d4080e7          	jalr	212(ra) # 667c <exit>
    exit(0,"");
    55b0:	00003597          	auipc	a1,0x3
    55b4:	c4858593          	addi	a1,a1,-952 # 81f8 <malloc+0x1736>
    55b8:	4501                	li	a0,0
    55ba:	00001097          	auipc	ra,0x1
    55be:	0c2080e7          	jalr	194(ra) # 667c <exit>

00000000000055c2 <fourfiles>:
{
    55c2:	7171                	addi	sp,sp,-176
    55c4:	f506                	sd	ra,168(sp)
    55c6:	f122                	sd	s0,160(sp)
    55c8:	ed26                	sd	s1,152(sp)
    55ca:	e94a                	sd	s2,144(sp)
    55cc:	e54e                	sd	s3,136(sp)
    55ce:	e152                	sd	s4,128(sp)
    55d0:	fcd6                	sd	s5,120(sp)
    55d2:	f8da                	sd	s6,112(sp)
    55d4:	f4de                	sd	s7,104(sp)
    55d6:	f0e2                	sd	s8,96(sp)
    55d8:	ece6                	sd	s9,88(sp)
    55da:	e8ea                	sd	s10,80(sp)
    55dc:	e4ee                	sd	s11,72(sp)
    55de:	1900                	addi	s0,sp,176
    55e0:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    55e4:	00001797          	auipc	a5,0x1
    55e8:	5cc78793          	addi	a5,a5,1484 # 6bb0 <malloc+0xee>
    55ec:	f6f43823          	sd	a5,-144(s0)
    55f0:	00001797          	auipc	a5,0x1
    55f4:	5c878793          	addi	a5,a5,1480 # 6bb8 <malloc+0xf6>
    55f8:	f6f43c23          	sd	a5,-136(s0)
    55fc:	00001797          	auipc	a5,0x1
    5600:	5c478793          	addi	a5,a5,1476 # 6bc0 <malloc+0xfe>
    5604:	f8f43023          	sd	a5,-128(s0)
    5608:	00001797          	auipc	a5,0x1
    560c:	5c078793          	addi	a5,a5,1472 # 6bc8 <malloc+0x106>
    5610:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    5614:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    5618:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    561a:	4481                	li	s1,0
    561c:	4a11                	li	s4,4
    fname = names[pi];
    561e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    5622:	854e                	mv	a0,s3
    5624:	00001097          	auipc	ra,0x1
    5628:	0a8080e7          	jalr	168(ra) # 66cc <unlink>
    pid = fork();
    562c:	00001097          	auipc	ra,0x1
    5630:	048080e7          	jalr	72(ra) # 6674 <fork>
    if(pid < 0){
    5634:	04054563          	bltz	a0,567e <fourfiles+0xbc>
    if(pid == 0){
    5638:	c535                	beqz	a0,56a4 <fourfiles+0xe2>
  for(pi = 0; pi < NCHILD; pi++){
    563a:	2485                	addiw	s1,s1,1
    563c:	0921                	addi	s2,s2,8
    563e:	ff4490e3          	bne	s1,s4,561e <fourfiles+0x5c>
    5642:	4491                	li	s1,4
    wait(&xstatus,0);
    5644:	4581                	li	a1,0
    5646:	f6c40513          	addi	a0,s0,-148
    564a:	00001097          	auipc	ra,0x1
    564e:	03a080e7          	jalr	58(ra) # 6684 <wait>
    if(xstatus != 0)
    5652:	f6c42b03          	lw	s6,-148(s0)
    5656:	0e0b1e63          	bnez	s6,5752 <fourfiles+0x190>
  for(pi = 0; pi < NCHILD; pi++){
    565a:	34fd                	addiw	s1,s1,-1
    565c:	f4e5                	bnez	s1,5644 <fourfiles+0x82>
    565e:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5662:	00008a17          	auipc	s4,0x8
    5666:	616a0a13          	addi	s4,s4,1558 # dc78 <buf>
    566a:	00008a97          	auipc	s5,0x8
    566e:	60fa8a93          	addi	s5,s5,1551 # dc79 <buf+0x1>
    if(total != N*SZ){
    5672:	6d85                	lui	s11,0x1
    5674:	770d8d93          	addi	s11,s11,1904 # 1770 <copyinstr2+0x1fe>
  for(i = 0; i < NCHILD; i++){
    5678:	03400d13          	li	s10,52
    567c:	a29d                	j	57e2 <fourfiles+0x220>
      printf("fork failed\n", s);
    567e:	f5843583          	ld	a1,-168(s0)
    5682:	00002517          	auipc	a0,0x2
    5686:	21650513          	addi	a0,a0,534 # 7898 <malloc+0xdd6>
    568a:	00001097          	auipc	ra,0x1
    568e:	37a080e7          	jalr	890(ra) # 6a04 <printf>
      exit(1,"");
    5692:	00003597          	auipc	a1,0x3
    5696:	b6658593          	addi	a1,a1,-1178 # 81f8 <malloc+0x1736>
    569a:	4505                	li	a0,1
    569c:	00001097          	auipc	ra,0x1
    56a0:	fe0080e7          	jalr	-32(ra) # 667c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    56a4:	20200593          	li	a1,514
    56a8:	854e                	mv	a0,s3
    56aa:	00001097          	auipc	ra,0x1
    56ae:	012080e7          	jalr	18(ra) # 66bc <open>
    56b2:	892a                	mv	s2,a0
      if(fd < 0){
    56b4:	04054b63          	bltz	a0,570a <fourfiles+0x148>
      memset(buf, '0'+pi, SZ);
    56b8:	1f400613          	li	a2,500
    56bc:	0304859b          	addiw	a1,s1,48
    56c0:	00008517          	auipc	a0,0x8
    56c4:	5b850513          	addi	a0,a0,1464 # dc78 <buf>
    56c8:	00001097          	auipc	ra,0x1
    56cc:	db8080e7          	jalr	-584(ra) # 6480 <memset>
    56d0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    56d2:	00008997          	auipc	s3,0x8
    56d6:	5a698993          	addi	s3,s3,1446 # dc78 <buf>
    56da:	1f400613          	li	a2,500
    56de:	85ce                	mv	a1,s3
    56e0:	854a                	mv	a0,s2
    56e2:	00001097          	auipc	ra,0x1
    56e6:	fba080e7          	jalr	-70(ra) # 669c <write>
    56ea:	85aa                	mv	a1,a0
    56ec:	1f400793          	li	a5,500
    56f0:	04f51063          	bne	a0,a5,5730 <fourfiles+0x16e>
      for(i = 0; i < N; i++){
    56f4:	34fd                	addiw	s1,s1,-1
    56f6:	f0f5                	bnez	s1,56da <fourfiles+0x118>
      exit(0,"");
    56f8:	00003597          	auipc	a1,0x3
    56fc:	b0058593          	addi	a1,a1,-1280 # 81f8 <malloc+0x1736>
    5700:	4501                	li	a0,0
    5702:	00001097          	auipc	ra,0x1
    5706:	f7a080e7          	jalr	-134(ra) # 667c <exit>
        printf("create failed\n", s);
    570a:	f5843583          	ld	a1,-168(s0)
    570e:	00003517          	auipc	a0,0x3
    5712:	1ea50513          	addi	a0,a0,490 # 88f8 <malloc+0x1e36>
    5716:	00001097          	auipc	ra,0x1
    571a:	2ee080e7          	jalr	750(ra) # 6a04 <printf>
        exit(1,"");
    571e:	00003597          	auipc	a1,0x3
    5722:	ada58593          	addi	a1,a1,-1318 # 81f8 <malloc+0x1736>
    5726:	4505                	li	a0,1
    5728:	00001097          	auipc	ra,0x1
    572c:	f54080e7          	jalr	-172(ra) # 667c <exit>
          printf("write failed %d\n", n);
    5730:	00003517          	auipc	a0,0x3
    5734:	1d850513          	addi	a0,a0,472 # 8908 <malloc+0x1e46>
    5738:	00001097          	auipc	ra,0x1
    573c:	2cc080e7          	jalr	716(ra) # 6a04 <printf>
          exit(1,"");
    5740:	00003597          	auipc	a1,0x3
    5744:	ab858593          	addi	a1,a1,-1352 # 81f8 <malloc+0x1736>
    5748:	4505                	li	a0,1
    574a:	00001097          	auipc	ra,0x1
    574e:	f32080e7          	jalr	-206(ra) # 667c <exit>
      exit(xstatus,"");
    5752:	00003597          	auipc	a1,0x3
    5756:	aa658593          	addi	a1,a1,-1370 # 81f8 <malloc+0x1736>
    575a:	855a                	mv	a0,s6
    575c:	00001097          	auipc	ra,0x1
    5760:	f20080e7          	jalr	-224(ra) # 667c <exit>
          printf("wrong char\n", s);
    5764:	f5843583          	ld	a1,-168(s0)
    5768:	00003517          	auipc	a0,0x3
    576c:	1b850513          	addi	a0,a0,440 # 8920 <malloc+0x1e5e>
    5770:	00001097          	auipc	ra,0x1
    5774:	294080e7          	jalr	660(ra) # 6a04 <printf>
          exit(1,"");
    5778:	00003597          	auipc	a1,0x3
    577c:	a8058593          	addi	a1,a1,-1408 # 81f8 <malloc+0x1736>
    5780:	4505                	li	a0,1
    5782:	00001097          	auipc	ra,0x1
    5786:	efa080e7          	jalr	-262(ra) # 667c <exit>
      total += n;
    578a:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    578e:	660d                	lui	a2,0x3
    5790:	85d2                	mv	a1,s4
    5792:	854e                	mv	a0,s3
    5794:	00001097          	auipc	ra,0x1
    5798:	f00080e7          	jalr	-256(ra) # 6694 <read>
    579c:	02a05363          	blez	a0,57c2 <fourfiles+0x200>
    57a0:	00008797          	auipc	a5,0x8
    57a4:	4d878793          	addi	a5,a5,1240 # dc78 <buf>
    57a8:	fff5069b          	addiw	a3,a0,-1
    57ac:	1682                	slli	a3,a3,0x20
    57ae:	9281                	srli	a3,a3,0x20
    57b0:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    57b2:	0007c703          	lbu	a4,0(a5)
    57b6:	fa9717e3          	bne	a4,s1,5764 <fourfiles+0x1a2>
      for(j = 0; j < n; j++){
    57ba:	0785                	addi	a5,a5,1
    57bc:	fed79be3          	bne	a5,a3,57b2 <fourfiles+0x1f0>
    57c0:	b7e9                	j	578a <fourfiles+0x1c8>
    close(fd);
    57c2:	854e                	mv	a0,s3
    57c4:	00001097          	auipc	ra,0x1
    57c8:	ee0080e7          	jalr	-288(ra) # 66a4 <close>
    if(total != N*SZ){
    57cc:	03b91863          	bne	s2,s11,57fc <fourfiles+0x23a>
    unlink(fname);
    57d0:	8566                	mv	a0,s9
    57d2:	00001097          	auipc	ra,0x1
    57d6:	efa080e7          	jalr	-262(ra) # 66cc <unlink>
  for(i = 0; i < NCHILD; i++){
    57da:	0c21                	addi	s8,s8,8
    57dc:	2b85                	addiw	s7,s7,1
    57de:	05ab8163          	beq	s7,s10,5820 <fourfiles+0x25e>
    fname = names[i];
    57e2:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    57e6:	4581                	li	a1,0
    57e8:	8566                	mv	a0,s9
    57ea:	00001097          	auipc	ra,0x1
    57ee:	ed2080e7          	jalr	-302(ra) # 66bc <open>
    57f2:	89aa                	mv	s3,a0
    total = 0;
    57f4:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    57f6:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    57fa:	bf51                	j	578e <fourfiles+0x1cc>
      printf("wrong length %d\n", total);
    57fc:	85ca                	mv	a1,s2
    57fe:	00003517          	auipc	a0,0x3
    5802:	13250513          	addi	a0,a0,306 # 8930 <malloc+0x1e6e>
    5806:	00001097          	auipc	ra,0x1
    580a:	1fe080e7          	jalr	510(ra) # 6a04 <printf>
      exit(1,"");
    580e:	00003597          	auipc	a1,0x3
    5812:	9ea58593          	addi	a1,a1,-1558 # 81f8 <malloc+0x1736>
    5816:	4505                	li	a0,1
    5818:	00001097          	auipc	ra,0x1
    581c:	e64080e7          	jalr	-412(ra) # 667c <exit>
}
    5820:	70aa                	ld	ra,168(sp)
    5822:	740a                	ld	s0,160(sp)
    5824:	64ea                	ld	s1,152(sp)
    5826:	694a                	ld	s2,144(sp)
    5828:	69aa                	ld	s3,136(sp)
    582a:	6a0a                	ld	s4,128(sp)
    582c:	7ae6                	ld	s5,120(sp)
    582e:	7b46                	ld	s6,112(sp)
    5830:	7ba6                	ld	s7,104(sp)
    5832:	7c06                	ld	s8,96(sp)
    5834:	6ce6                	ld	s9,88(sp)
    5836:	6d46                	ld	s10,80(sp)
    5838:	6da6                	ld	s11,72(sp)
    583a:	614d                	addi	sp,sp,176
    583c:	8082                	ret

000000000000583e <concreate>:
{
    583e:	7135                	addi	sp,sp,-160
    5840:	ed06                	sd	ra,152(sp)
    5842:	e922                	sd	s0,144(sp)
    5844:	e526                	sd	s1,136(sp)
    5846:	e14a                	sd	s2,128(sp)
    5848:	fcce                	sd	s3,120(sp)
    584a:	f8d2                	sd	s4,112(sp)
    584c:	f4d6                	sd	s5,104(sp)
    584e:	f0da                	sd	s6,96(sp)
    5850:	ecde                	sd	s7,88(sp)
    5852:	1100                	addi	s0,sp,160
    5854:	89aa                	mv	s3,a0
  file[0] = 'C';
    5856:	04300793          	li	a5,67
    585a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    585e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    5862:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    5864:	4b0d                	li	s6,3
    5866:	4a85                	li	s5,1
      link("C0", file);
    5868:	00003b97          	auipc	s7,0x3
    586c:	0e0b8b93          	addi	s7,s7,224 # 8948 <malloc+0x1e86>
  for(i = 0; i < N; i++){
    5870:	02800a13          	li	s4,40
    5874:	ae11                	j	5b88 <concreate+0x34a>
      link("C0", file);
    5876:	fa840593          	addi	a1,s0,-88
    587a:	855e                	mv	a0,s7
    587c:	00001097          	auipc	ra,0x1
    5880:	e60080e7          	jalr	-416(ra) # 66dc <link>
    if(pid == 0) {
    5884:	a4e5                	j	5b6c <concreate+0x32e>
    } else if(pid == 0 && (i % 5) == 1){
    5886:	4795                	li	a5,5
    5888:	02f9693b          	remw	s2,s2,a5
    588c:	4785                	li	a5,1
    588e:	02f90f63          	beq	s2,a5,58cc <concreate+0x8e>
      fd = open(file, O_CREATE | O_RDWR);
    5892:	20200593          	li	a1,514
    5896:	fa840513          	addi	a0,s0,-88
    589a:	00001097          	auipc	ra,0x1
    589e:	e22080e7          	jalr	-478(ra) # 66bc <open>
      if(fd < 0){
    58a2:	2a055c63          	bgez	a0,5b5a <concreate+0x31c>
        printf("concreate create %s failed\n", file);
    58a6:	fa840593          	addi	a1,s0,-88
    58aa:	00003517          	auipc	a0,0x3
    58ae:	0a650513          	addi	a0,a0,166 # 8950 <malloc+0x1e8e>
    58b2:	00001097          	auipc	ra,0x1
    58b6:	152080e7          	jalr	338(ra) # 6a04 <printf>
        exit(1,"");
    58ba:	00003597          	auipc	a1,0x3
    58be:	93e58593          	addi	a1,a1,-1730 # 81f8 <malloc+0x1736>
    58c2:	4505                	li	a0,1
    58c4:	00001097          	auipc	ra,0x1
    58c8:	db8080e7          	jalr	-584(ra) # 667c <exit>
      link("C0", file);
    58cc:	fa840593          	addi	a1,s0,-88
    58d0:	00003517          	auipc	a0,0x3
    58d4:	07850513          	addi	a0,a0,120 # 8948 <malloc+0x1e86>
    58d8:	00001097          	auipc	ra,0x1
    58dc:	e04080e7          	jalr	-508(ra) # 66dc <link>
      exit(0,"");
    58e0:	00003597          	auipc	a1,0x3
    58e4:	91858593          	addi	a1,a1,-1768 # 81f8 <malloc+0x1736>
    58e8:	4501                	li	a0,0
    58ea:	00001097          	auipc	ra,0x1
    58ee:	d92080e7          	jalr	-622(ra) # 667c <exit>
        exit(1,"");
    58f2:	00003597          	auipc	a1,0x3
    58f6:	90658593          	addi	a1,a1,-1786 # 81f8 <malloc+0x1736>
    58fa:	4505                	li	a0,1
    58fc:	00001097          	auipc	ra,0x1
    5900:	d80080e7          	jalr	-640(ra) # 667c <exit>
  memset(fa, 0, sizeof(fa));
    5904:	02800613          	li	a2,40
    5908:	4581                	li	a1,0
    590a:	f8040513          	addi	a0,s0,-128
    590e:	00001097          	auipc	ra,0x1
    5912:	b72080e7          	jalr	-1166(ra) # 6480 <memset>
  fd = open(".", 0);
    5916:	4581                	li	a1,0
    5918:	00002517          	auipc	a0,0x2
    591c:	9d850513          	addi	a0,a0,-1576 # 72f0 <malloc+0x82e>
    5920:	00001097          	auipc	ra,0x1
    5924:	d9c080e7          	jalr	-612(ra) # 66bc <open>
    5928:	892a                	mv	s2,a0
  n = 0;
    592a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    592c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    5930:	02700b13          	li	s6,39
      fa[i] = 1;
    5934:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    5936:	4641                	li	a2,16
    5938:	f7040593          	addi	a1,s0,-144
    593c:	854a                	mv	a0,s2
    593e:	00001097          	auipc	ra,0x1
    5942:	d56080e7          	jalr	-682(ra) # 6694 <read>
    5946:	08a05963          	blez	a0,59d8 <concreate+0x19a>
    if(de.inum == 0)
    594a:	f7045783          	lhu	a5,-144(s0)
    594e:	d7e5                	beqz	a5,5936 <concreate+0xf8>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5950:	f7244783          	lbu	a5,-142(s0)
    5954:	ff4791e3          	bne	a5,s4,5936 <concreate+0xf8>
    5958:	f7444783          	lbu	a5,-140(s0)
    595c:	ffe9                	bnez	a5,5936 <concreate+0xf8>
      i = de.name[1] - '0';
    595e:	f7344783          	lbu	a5,-141(s0)
    5962:	fd07879b          	addiw	a5,a5,-48
    5966:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    596a:	00eb6f63          	bltu	s6,a4,5988 <concreate+0x14a>
      if(fa[i]){
    596e:	fb040793          	addi	a5,s0,-80
    5972:	97ba                	add	a5,a5,a4
    5974:	fd07c783          	lbu	a5,-48(a5)
    5978:	ef85                	bnez	a5,59b0 <concreate+0x172>
      fa[i] = 1;
    597a:	fb040793          	addi	a5,s0,-80
    597e:	973e                	add	a4,a4,a5
    5980:	fd770823          	sb	s7,-48(a4) # fd0 <unlinkread+0x158>
      n++;
    5984:	2a85                	addiw	s5,s5,1
    5986:	bf45                	j	5936 <concreate+0xf8>
        printf("%s: concreate weird file %s\n", s, de.name);
    5988:	f7240613          	addi	a2,s0,-142
    598c:	85ce                	mv	a1,s3
    598e:	00003517          	auipc	a0,0x3
    5992:	fe250513          	addi	a0,a0,-30 # 8970 <malloc+0x1eae>
    5996:	00001097          	auipc	ra,0x1
    599a:	06e080e7          	jalr	110(ra) # 6a04 <printf>
        exit(1,"");
    599e:	00003597          	auipc	a1,0x3
    59a2:	85a58593          	addi	a1,a1,-1958 # 81f8 <malloc+0x1736>
    59a6:	4505                	li	a0,1
    59a8:	00001097          	auipc	ra,0x1
    59ac:	cd4080e7          	jalr	-812(ra) # 667c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    59b0:	f7240613          	addi	a2,s0,-142
    59b4:	85ce                	mv	a1,s3
    59b6:	00003517          	auipc	a0,0x3
    59ba:	fda50513          	addi	a0,a0,-38 # 8990 <malloc+0x1ece>
    59be:	00001097          	auipc	ra,0x1
    59c2:	046080e7          	jalr	70(ra) # 6a04 <printf>
        exit(1,"");
    59c6:	00003597          	auipc	a1,0x3
    59ca:	83258593          	addi	a1,a1,-1998 # 81f8 <malloc+0x1736>
    59ce:	4505                	li	a0,1
    59d0:	00001097          	auipc	ra,0x1
    59d4:	cac080e7          	jalr	-852(ra) # 667c <exit>
  close(fd);
    59d8:	854a                	mv	a0,s2
    59da:	00001097          	auipc	ra,0x1
    59de:	cca080e7          	jalr	-822(ra) # 66a4 <close>
  if(n != N){
    59e2:	02800793          	li	a5,40
    59e6:	00fa9763          	bne	s5,a5,59f4 <concreate+0x1b6>
    if(((i % 3) == 0 && pid == 0) ||
    59ea:	4a8d                	li	s5,3
    59ec:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    59ee:	02800a13          	li	s4,40
    59f2:	a0d5                	j	5ad6 <concreate+0x298>
    printf("%s: concreate not enough files in directory listing\n", s);
    59f4:	85ce                	mv	a1,s3
    59f6:	00003517          	auipc	a0,0x3
    59fa:	fc250513          	addi	a0,a0,-62 # 89b8 <malloc+0x1ef6>
    59fe:	00001097          	auipc	ra,0x1
    5a02:	006080e7          	jalr	6(ra) # 6a04 <printf>
    exit(1,"");
    5a06:	00002597          	auipc	a1,0x2
    5a0a:	7f258593          	addi	a1,a1,2034 # 81f8 <malloc+0x1736>
    5a0e:	4505                	li	a0,1
    5a10:	00001097          	auipc	ra,0x1
    5a14:	c6c080e7          	jalr	-916(ra) # 667c <exit>
      printf("%s: fork failed\n", s);
    5a18:	85ce                	mv	a1,s3
    5a1a:	00002517          	auipc	a0,0x2
    5a1e:	a7650513          	addi	a0,a0,-1418 # 7490 <malloc+0x9ce>
    5a22:	00001097          	auipc	ra,0x1
    5a26:	fe2080e7          	jalr	-30(ra) # 6a04 <printf>
      exit(1,"");
    5a2a:	00002597          	auipc	a1,0x2
    5a2e:	7ce58593          	addi	a1,a1,1998 # 81f8 <malloc+0x1736>
    5a32:	4505                	li	a0,1
    5a34:	00001097          	auipc	ra,0x1
    5a38:	c48080e7          	jalr	-952(ra) # 667c <exit>
      close(open(file, 0));
    5a3c:	4581                	li	a1,0
    5a3e:	fa840513          	addi	a0,s0,-88
    5a42:	00001097          	auipc	ra,0x1
    5a46:	c7a080e7          	jalr	-902(ra) # 66bc <open>
    5a4a:	00001097          	auipc	ra,0x1
    5a4e:	c5a080e7          	jalr	-934(ra) # 66a4 <close>
      close(open(file, 0));
    5a52:	4581                	li	a1,0
    5a54:	fa840513          	addi	a0,s0,-88
    5a58:	00001097          	auipc	ra,0x1
    5a5c:	c64080e7          	jalr	-924(ra) # 66bc <open>
    5a60:	00001097          	auipc	ra,0x1
    5a64:	c44080e7          	jalr	-956(ra) # 66a4 <close>
      close(open(file, 0));
    5a68:	4581                	li	a1,0
    5a6a:	fa840513          	addi	a0,s0,-88
    5a6e:	00001097          	auipc	ra,0x1
    5a72:	c4e080e7          	jalr	-946(ra) # 66bc <open>
    5a76:	00001097          	auipc	ra,0x1
    5a7a:	c2e080e7          	jalr	-978(ra) # 66a4 <close>
      close(open(file, 0));
    5a7e:	4581                	li	a1,0
    5a80:	fa840513          	addi	a0,s0,-88
    5a84:	00001097          	auipc	ra,0x1
    5a88:	c38080e7          	jalr	-968(ra) # 66bc <open>
    5a8c:	00001097          	auipc	ra,0x1
    5a90:	c18080e7          	jalr	-1000(ra) # 66a4 <close>
      close(open(file, 0));
    5a94:	4581                	li	a1,0
    5a96:	fa840513          	addi	a0,s0,-88
    5a9a:	00001097          	auipc	ra,0x1
    5a9e:	c22080e7          	jalr	-990(ra) # 66bc <open>
    5aa2:	00001097          	auipc	ra,0x1
    5aa6:	c02080e7          	jalr	-1022(ra) # 66a4 <close>
      close(open(file, 0));
    5aaa:	4581                	li	a1,0
    5aac:	fa840513          	addi	a0,s0,-88
    5ab0:	00001097          	auipc	ra,0x1
    5ab4:	c0c080e7          	jalr	-1012(ra) # 66bc <open>
    5ab8:	00001097          	auipc	ra,0x1
    5abc:	bec080e7          	jalr	-1044(ra) # 66a4 <close>
    if(pid == 0)
    5ac0:	08090463          	beqz	s2,5b48 <concreate+0x30a>
      wait(0,0);
    5ac4:	4581                	li	a1,0
    5ac6:	4501                	li	a0,0
    5ac8:	00001097          	auipc	ra,0x1
    5acc:	bbc080e7          	jalr	-1092(ra) # 6684 <wait>
  for(i = 0; i < N; i++){
    5ad0:	2485                	addiw	s1,s1,1
    5ad2:	0f448a63          	beq	s1,s4,5bc6 <concreate+0x388>
    file[1] = '0' + i;
    5ad6:	0304879b          	addiw	a5,s1,48
    5ada:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5ade:	00001097          	auipc	ra,0x1
    5ae2:	b96080e7          	jalr	-1130(ra) # 6674 <fork>
    5ae6:	892a                	mv	s2,a0
    if(pid < 0){
    5ae8:	f20548e3          	bltz	a0,5a18 <concreate+0x1da>
    if(((i % 3) == 0 && pid == 0) ||
    5aec:	0354e73b          	remw	a4,s1,s5
    5af0:	00a767b3          	or	a5,a4,a0
    5af4:	2781                	sext.w	a5,a5
    5af6:	d3b9                	beqz	a5,5a3c <concreate+0x1fe>
    5af8:	01671363          	bne	a4,s6,5afe <concreate+0x2c0>
       ((i % 3) == 1 && pid != 0)){
    5afc:	f121                	bnez	a0,5a3c <concreate+0x1fe>
      unlink(file);
    5afe:	fa840513          	addi	a0,s0,-88
    5b02:	00001097          	auipc	ra,0x1
    5b06:	bca080e7          	jalr	-1078(ra) # 66cc <unlink>
      unlink(file);
    5b0a:	fa840513          	addi	a0,s0,-88
    5b0e:	00001097          	auipc	ra,0x1
    5b12:	bbe080e7          	jalr	-1090(ra) # 66cc <unlink>
      unlink(file);
    5b16:	fa840513          	addi	a0,s0,-88
    5b1a:	00001097          	auipc	ra,0x1
    5b1e:	bb2080e7          	jalr	-1102(ra) # 66cc <unlink>
      unlink(file);
    5b22:	fa840513          	addi	a0,s0,-88
    5b26:	00001097          	auipc	ra,0x1
    5b2a:	ba6080e7          	jalr	-1114(ra) # 66cc <unlink>
      unlink(file);
    5b2e:	fa840513          	addi	a0,s0,-88
    5b32:	00001097          	auipc	ra,0x1
    5b36:	b9a080e7          	jalr	-1126(ra) # 66cc <unlink>
      unlink(file);
    5b3a:	fa840513          	addi	a0,s0,-88
    5b3e:	00001097          	auipc	ra,0x1
    5b42:	b8e080e7          	jalr	-1138(ra) # 66cc <unlink>
    5b46:	bfad                	j	5ac0 <concreate+0x282>
      exit(0,"");
    5b48:	00002597          	auipc	a1,0x2
    5b4c:	6b058593          	addi	a1,a1,1712 # 81f8 <malloc+0x1736>
    5b50:	4501                	li	a0,0
    5b52:	00001097          	auipc	ra,0x1
    5b56:	b2a080e7          	jalr	-1238(ra) # 667c <exit>
      close(fd);
    5b5a:	00001097          	auipc	ra,0x1
    5b5e:	b4a080e7          	jalr	-1206(ra) # 66a4 <close>
    if(pid == 0) {
    5b62:	bbbd                	j	58e0 <concreate+0xa2>
      close(fd);
    5b64:	00001097          	auipc	ra,0x1
    5b68:	b40080e7          	jalr	-1216(ra) # 66a4 <close>
      wait(&xstatus,0);
    5b6c:	4581                	li	a1,0
    5b6e:	f6c40513          	addi	a0,s0,-148
    5b72:	00001097          	auipc	ra,0x1
    5b76:	b12080e7          	jalr	-1262(ra) # 6684 <wait>
      if(xstatus != 0)
    5b7a:	f6c42483          	lw	s1,-148(s0)
    5b7e:	d6049ae3          	bnez	s1,58f2 <concreate+0xb4>
  for(i = 0; i < N; i++){
    5b82:	2905                	addiw	s2,s2,1
    5b84:	d94900e3          	beq	s2,s4,5904 <concreate+0xc6>
    file[1] = '0' + i;
    5b88:	0309079b          	addiw	a5,s2,48
    5b8c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5b90:	fa840513          	addi	a0,s0,-88
    5b94:	00001097          	auipc	ra,0x1
    5b98:	b38080e7          	jalr	-1224(ra) # 66cc <unlink>
    pid = fork();
    5b9c:	00001097          	auipc	ra,0x1
    5ba0:	ad8080e7          	jalr	-1320(ra) # 6674 <fork>
    if(pid && (i % 3) == 1){
    5ba4:	ce0501e3          	beqz	a0,5886 <concreate+0x48>
    5ba8:	036967bb          	remw	a5,s2,s6
    5bac:	cd5785e3          	beq	a5,s5,5876 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5bb0:	20200593          	li	a1,514
    5bb4:	fa840513          	addi	a0,s0,-88
    5bb8:	00001097          	auipc	ra,0x1
    5bbc:	b04080e7          	jalr	-1276(ra) # 66bc <open>
      if(fd < 0){
    5bc0:	fa0552e3          	bgez	a0,5b64 <concreate+0x326>
    5bc4:	b1cd                	j	58a6 <concreate+0x68>
}
    5bc6:	60ea                	ld	ra,152(sp)
    5bc8:	644a                	ld	s0,144(sp)
    5bca:	64aa                	ld	s1,136(sp)
    5bcc:	690a                	ld	s2,128(sp)
    5bce:	79e6                	ld	s3,120(sp)
    5bd0:	7a46                	ld	s4,112(sp)
    5bd2:	7aa6                	ld	s5,104(sp)
    5bd4:	7b06                	ld	s6,96(sp)
    5bd6:	6be6                	ld	s7,88(sp)
    5bd8:	610d                	addi	sp,sp,160
    5bda:	8082                	ret

0000000000005bdc <bigfile>:
{
    5bdc:	7139                	addi	sp,sp,-64
    5bde:	fc06                	sd	ra,56(sp)
    5be0:	f822                	sd	s0,48(sp)
    5be2:	f426                	sd	s1,40(sp)
    5be4:	f04a                	sd	s2,32(sp)
    5be6:	ec4e                	sd	s3,24(sp)
    5be8:	e852                	sd	s4,16(sp)
    5bea:	e456                	sd	s5,8(sp)
    5bec:	0080                	addi	s0,sp,64
    5bee:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5bf0:	00003517          	auipc	a0,0x3
    5bf4:	e0050513          	addi	a0,a0,-512 # 89f0 <malloc+0x1f2e>
    5bf8:	00001097          	auipc	ra,0x1
    5bfc:	ad4080e7          	jalr	-1324(ra) # 66cc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5c00:	20200593          	li	a1,514
    5c04:	00003517          	auipc	a0,0x3
    5c08:	dec50513          	addi	a0,a0,-532 # 89f0 <malloc+0x1f2e>
    5c0c:	00001097          	auipc	ra,0x1
    5c10:	ab0080e7          	jalr	-1360(ra) # 66bc <open>
    5c14:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5c16:	4481                	li	s1,0
    memset(buf, i, SZ);
    5c18:	00008917          	auipc	s2,0x8
    5c1c:	06090913          	addi	s2,s2,96 # dc78 <buf>
  for(i = 0; i < N; i++){
    5c20:	4a51                	li	s4,20
  if(fd < 0){
    5c22:	0a054163          	bltz	a0,5cc4 <bigfile+0xe8>
    memset(buf, i, SZ);
    5c26:	25800613          	li	a2,600
    5c2a:	85a6                	mv	a1,s1
    5c2c:	854a                	mv	a0,s2
    5c2e:	00001097          	auipc	ra,0x1
    5c32:	852080e7          	jalr	-1966(ra) # 6480 <memset>
    if(write(fd, buf, SZ) != SZ){
    5c36:	25800613          	li	a2,600
    5c3a:	85ca                	mv	a1,s2
    5c3c:	854e                	mv	a0,s3
    5c3e:	00001097          	auipc	ra,0x1
    5c42:	a5e080e7          	jalr	-1442(ra) # 669c <write>
    5c46:	25800793          	li	a5,600
    5c4a:	08f51f63          	bne	a0,a5,5ce8 <bigfile+0x10c>
  for(i = 0; i < N; i++){
    5c4e:	2485                	addiw	s1,s1,1
    5c50:	fd449be3          	bne	s1,s4,5c26 <bigfile+0x4a>
  close(fd);
    5c54:	854e                	mv	a0,s3
    5c56:	00001097          	auipc	ra,0x1
    5c5a:	a4e080e7          	jalr	-1458(ra) # 66a4 <close>
  fd = open("bigfile.dat", 0);
    5c5e:	4581                	li	a1,0
    5c60:	00003517          	auipc	a0,0x3
    5c64:	d9050513          	addi	a0,a0,-624 # 89f0 <malloc+0x1f2e>
    5c68:	00001097          	auipc	ra,0x1
    5c6c:	a54080e7          	jalr	-1452(ra) # 66bc <open>
    5c70:	8a2a                	mv	s4,a0
  total = 0;
    5c72:	4981                	li	s3,0
  for(i = 0; ; i++){
    5c74:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5c76:	00008917          	auipc	s2,0x8
    5c7a:	00290913          	addi	s2,s2,2 # dc78 <buf>
  if(fd < 0){
    5c7e:	08054763          	bltz	a0,5d0c <bigfile+0x130>
    cc = read(fd, buf, SZ/2);
    5c82:	12c00613          	li	a2,300
    5c86:	85ca                	mv	a1,s2
    5c88:	8552                	mv	a0,s4
    5c8a:	00001097          	auipc	ra,0x1
    5c8e:	a0a080e7          	jalr	-1526(ra) # 6694 <read>
    if(cc < 0){
    5c92:	08054f63          	bltz	a0,5d30 <bigfile+0x154>
    if(cc == 0)
    5c96:	10050363          	beqz	a0,5d9c <bigfile+0x1c0>
    if(cc != SZ/2){
    5c9a:	12c00793          	li	a5,300
    5c9e:	0af51b63          	bne	a0,a5,5d54 <bigfile+0x178>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5ca2:	01f4d79b          	srliw	a5,s1,0x1f
    5ca6:	9fa5                	addw	a5,a5,s1
    5ca8:	4017d79b          	sraiw	a5,a5,0x1
    5cac:	00094703          	lbu	a4,0(s2)
    5cb0:	0cf71463          	bne	a4,a5,5d78 <bigfile+0x19c>
    5cb4:	12b94703          	lbu	a4,299(s2)
    5cb8:	0cf71063          	bne	a4,a5,5d78 <bigfile+0x19c>
    total += cc;
    5cbc:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    5cc0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5cc2:	b7c1                	j	5c82 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5cc4:	85d6                	mv	a1,s5
    5cc6:	00003517          	auipc	a0,0x3
    5cca:	d3a50513          	addi	a0,a0,-710 # 8a00 <malloc+0x1f3e>
    5cce:	00001097          	auipc	ra,0x1
    5cd2:	d36080e7          	jalr	-714(ra) # 6a04 <printf>
    exit(1,"");
    5cd6:	00002597          	auipc	a1,0x2
    5cda:	52258593          	addi	a1,a1,1314 # 81f8 <malloc+0x1736>
    5cde:	4505                	li	a0,1
    5ce0:	00001097          	auipc	ra,0x1
    5ce4:	99c080e7          	jalr	-1636(ra) # 667c <exit>
      printf("%s: write bigfile failed\n", s);
    5ce8:	85d6                	mv	a1,s5
    5cea:	00003517          	auipc	a0,0x3
    5cee:	d3650513          	addi	a0,a0,-714 # 8a20 <malloc+0x1f5e>
    5cf2:	00001097          	auipc	ra,0x1
    5cf6:	d12080e7          	jalr	-750(ra) # 6a04 <printf>
      exit(1,"");
    5cfa:	00002597          	auipc	a1,0x2
    5cfe:	4fe58593          	addi	a1,a1,1278 # 81f8 <malloc+0x1736>
    5d02:	4505                	li	a0,1
    5d04:	00001097          	auipc	ra,0x1
    5d08:	978080e7          	jalr	-1672(ra) # 667c <exit>
    printf("%s: cannot open bigfile\n", s);
    5d0c:	85d6                	mv	a1,s5
    5d0e:	00003517          	auipc	a0,0x3
    5d12:	d3250513          	addi	a0,a0,-718 # 8a40 <malloc+0x1f7e>
    5d16:	00001097          	auipc	ra,0x1
    5d1a:	cee080e7          	jalr	-786(ra) # 6a04 <printf>
    exit(1,"");
    5d1e:	00002597          	auipc	a1,0x2
    5d22:	4da58593          	addi	a1,a1,1242 # 81f8 <malloc+0x1736>
    5d26:	4505                	li	a0,1
    5d28:	00001097          	auipc	ra,0x1
    5d2c:	954080e7          	jalr	-1708(ra) # 667c <exit>
      printf("%s: read bigfile failed\n", s);
    5d30:	85d6                	mv	a1,s5
    5d32:	00003517          	auipc	a0,0x3
    5d36:	d2e50513          	addi	a0,a0,-722 # 8a60 <malloc+0x1f9e>
    5d3a:	00001097          	auipc	ra,0x1
    5d3e:	cca080e7          	jalr	-822(ra) # 6a04 <printf>
      exit(1,"");
    5d42:	00002597          	auipc	a1,0x2
    5d46:	4b658593          	addi	a1,a1,1206 # 81f8 <malloc+0x1736>
    5d4a:	4505                	li	a0,1
    5d4c:	00001097          	auipc	ra,0x1
    5d50:	930080e7          	jalr	-1744(ra) # 667c <exit>
      printf("%s: short read bigfile\n", s);
    5d54:	85d6                	mv	a1,s5
    5d56:	00003517          	auipc	a0,0x3
    5d5a:	d2a50513          	addi	a0,a0,-726 # 8a80 <malloc+0x1fbe>
    5d5e:	00001097          	auipc	ra,0x1
    5d62:	ca6080e7          	jalr	-858(ra) # 6a04 <printf>
      exit(1,"");
    5d66:	00002597          	auipc	a1,0x2
    5d6a:	49258593          	addi	a1,a1,1170 # 81f8 <malloc+0x1736>
    5d6e:	4505                	li	a0,1
    5d70:	00001097          	auipc	ra,0x1
    5d74:	90c080e7          	jalr	-1780(ra) # 667c <exit>
      printf("%s: read bigfile wrong data\n", s);
    5d78:	85d6                	mv	a1,s5
    5d7a:	00003517          	auipc	a0,0x3
    5d7e:	d1e50513          	addi	a0,a0,-738 # 8a98 <malloc+0x1fd6>
    5d82:	00001097          	auipc	ra,0x1
    5d86:	c82080e7          	jalr	-894(ra) # 6a04 <printf>
      exit(1,"");
    5d8a:	00002597          	auipc	a1,0x2
    5d8e:	46e58593          	addi	a1,a1,1134 # 81f8 <malloc+0x1736>
    5d92:	4505                	li	a0,1
    5d94:	00001097          	auipc	ra,0x1
    5d98:	8e8080e7          	jalr	-1816(ra) # 667c <exit>
  close(fd);
    5d9c:	8552                	mv	a0,s4
    5d9e:	00001097          	auipc	ra,0x1
    5da2:	906080e7          	jalr	-1786(ra) # 66a4 <close>
  if(total != N*SZ){
    5da6:	678d                	lui	a5,0x3
    5da8:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbasic+0x126>
    5dac:	02f99363          	bne	s3,a5,5dd2 <bigfile+0x1f6>
  unlink("bigfile.dat");
    5db0:	00003517          	auipc	a0,0x3
    5db4:	c4050513          	addi	a0,a0,-960 # 89f0 <malloc+0x1f2e>
    5db8:	00001097          	auipc	ra,0x1
    5dbc:	914080e7          	jalr	-1772(ra) # 66cc <unlink>
}
    5dc0:	70e2                	ld	ra,56(sp)
    5dc2:	7442                	ld	s0,48(sp)
    5dc4:	74a2                	ld	s1,40(sp)
    5dc6:	7902                	ld	s2,32(sp)
    5dc8:	69e2                	ld	s3,24(sp)
    5dca:	6a42                	ld	s4,16(sp)
    5dcc:	6aa2                	ld	s5,8(sp)
    5dce:	6121                	addi	sp,sp,64
    5dd0:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5dd2:	85d6                	mv	a1,s5
    5dd4:	00003517          	auipc	a0,0x3
    5dd8:	ce450513          	addi	a0,a0,-796 # 8ab8 <malloc+0x1ff6>
    5ddc:	00001097          	auipc	ra,0x1
    5de0:	c28080e7          	jalr	-984(ra) # 6a04 <printf>
    exit(1,"");
    5de4:	00002597          	auipc	a1,0x2
    5de8:	41458593          	addi	a1,a1,1044 # 81f8 <malloc+0x1736>
    5dec:	4505                	li	a0,1
    5dee:	00001097          	auipc	ra,0x1
    5df2:	88e080e7          	jalr	-1906(ra) # 667c <exit>

0000000000005df6 <fsfull>:
{
    5df6:	7171                	addi	sp,sp,-176
    5df8:	f506                	sd	ra,168(sp)
    5dfa:	f122                	sd	s0,160(sp)
    5dfc:	ed26                	sd	s1,152(sp)
    5dfe:	e94a                	sd	s2,144(sp)
    5e00:	e54e                	sd	s3,136(sp)
    5e02:	e152                	sd	s4,128(sp)
    5e04:	fcd6                	sd	s5,120(sp)
    5e06:	f8da                	sd	s6,112(sp)
    5e08:	f4de                	sd	s7,104(sp)
    5e0a:	f0e2                	sd	s8,96(sp)
    5e0c:	ece6                	sd	s9,88(sp)
    5e0e:	e8ea                	sd	s10,80(sp)
    5e10:	e4ee                	sd	s11,72(sp)
    5e12:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    5e14:	00003517          	auipc	a0,0x3
    5e18:	cc450513          	addi	a0,a0,-828 # 8ad8 <malloc+0x2016>
    5e1c:	00001097          	auipc	ra,0x1
    5e20:	be8080e7          	jalr	-1048(ra) # 6a04 <printf>
  for(nfiles = 0; ; nfiles++){
    5e24:	4481                	li	s1,0
    name[0] = 'f';
    5e26:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5e2a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5e2e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5e32:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5e34:	00003c97          	auipc	s9,0x3
    5e38:	cb4c8c93          	addi	s9,s9,-844 # 8ae8 <malloc+0x2026>
    int total = 0;
    5e3c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5e3e:	00008a17          	auipc	s4,0x8
    5e42:	e3aa0a13          	addi	s4,s4,-454 # dc78 <buf>
    name[0] = 'f';
    5e46:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5e4a:	0384c7bb          	divw	a5,s1,s8
    5e4e:	0307879b          	addiw	a5,a5,48
    5e52:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5e56:	0384e7bb          	remw	a5,s1,s8
    5e5a:	0377c7bb          	divw	a5,a5,s7
    5e5e:	0307879b          	addiw	a5,a5,48
    5e62:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5e66:	0374e7bb          	remw	a5,s1,s7
    5e6a:	0367c7bb          	divw	a5,a5,s6
    5e6e:	0307879b          	addiw	a5,a5,48
    5e72:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5e76:	0364e7bb          	remw	a5,s1,s6
    5e7a:	0307879b          	addiw	a5,a5,48
    5e7e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5e82:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5e86:	f5040593          	addi	a1,s0,-176
    5e8a:	8566                	mv	a0,s9
    5e8c:	00001097          	auipc	ra,0x1
    5e90:	b78080e7          	jalr	-1160(ra) # 6a04 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5e94:	20200593          	li	a1,514
    5e98:	f5040513          	addi	a0,s0,-176
    5e9c:	00001097          	auipc	ra,0x1
    5ea0:	820080e7          	jalr	-2016(ra) # 66bc <open>
    5ea4:	892a                	mv	s2,a0
    if(fd < 0){
    5ea6:	0a055663          	bgez	a0,5f52 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5eaa:	f5040593          	addi	a1,s0,-176
    5eae:	00003517          	auipc	a0,0x3
    5eb2:	c4a50513          	addi	a0,a0,-950 # 8af8 <malloc+0x2036>
    5eb6:	00001097          	auipc	ra,0x1
    5eba:	b4e080e7          	jalr	-1202(ra) # 6a04 <printf>
  while(nfiles >= 0){
    5ebe:	0604c363          	bltz	s1,5f24 <fsfull+0x12e>
    name[0] = 'f';
    5ec2:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5ec6:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5eca:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5ece:	4929                	li	s2,10
  while(nfiles >= 0){
    5ed0:	5afd                	li	s5,-1
    name[0] = 'f';
    5ed2:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5ed6:	0344c7bb          	divw	a5,s1,s4
    5eda:	0307879b          	addiw	a5,a5,48
    5ede:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5ee2:	0344e7bb          	remw	a5,s1,s4
    5ee6:	0337c7bb          	divw	a5,a5,s3
    5eea:	0307879b          	addiw	a5,a5,48
    5eee:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5ef2:	0334e7bb          	remw	a5,s1,s3
    5ef6:	0327c7bb          	divw	a5,a5,s2
    5efa:	0307879b          	addiw	a5,a5,48
    5efe:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5f02:	0324e7bb          	remw	a5,s1,s2
    5f06:	0307879b          	addiw	a5,a5,48
    5f0a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5f0e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5f12:	f5040513          	addi	a0,s0,-176
    5f16:	00000097          	auipc	ra,0x0
    5f1a:	7b6080e7          	jalr	1974(ra) # 66cc <unlink>
    nfiles--;
    5f1e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5f20:	fb5499e3          	bne	s1,s5,5ed2 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5f24:	00003517          	auipc	a0,0x3
    5f28:	bf450513          	addi	a0,a0,-1036 # 8b18 <malloc+0x2056>
    5f2c:	00001097          	auipc	ra,0x1
    5f30:	ad8080e7          	jalr	-1320(ra) # 6a04 <printf>
}
    5f34:	70aa                	ld	ra,168(sp)
    5f36:	740a                	ld	s0,160(sp)
    5f38:	64ea                	ld	s1,152(sp)
    5f3a:	694a                	ld	s2,144(sp)
    5f3c:	69aa                	ld	s3,136(sp)
    5f3e:	6a0a                	ld	s4,128(sp)
    5f40:	7ae6                	ld	s5,120(sp)
    5f42:	7b46                	ld	s6,112(sp)
    5f44:	7ba6                	ld	s7,104(sp)
    5f46:	7c06                	ld	s8,96(sp)
    5f48:	6ce6                	ld	s9,88(sp)
    5f4a:	6d46                	ld	s10,80(sp)
    5f4c:	6da6                	ld	s11,72(sp)
    5f4e:	614d                	addi	sp,sp,176
    5f50:	8082                	ret
    int total = 0;
    5f52:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5f54:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5f58:	40000613          	li	a2,1024
    5f5c:	85d2                	mv	a1,s4
    5f5e:	854a                	mv	a0,s2
    5f60:	00000097          	auipc	ra,0x0
    5f64:	73c080e7          	jalr	1852(ra) # 669c <write>
      if(cc < BSIZE)
    5f68:	00aad563          	bge	s5,a0,5f72 <fsfull+0x17c>
      total += cc;
    5f6c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5f70:	b7e5                	j	5f58 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5f72:	85ce                	mv	a1,s3
    5f74:	00003517          	auipc	a0,0x3
    5f78:	b9450513          	addi	a0,a0,-1132 # 8b08 <malloc+0x2046>
    5f7c:	00001097          	auipc	ra,0x1
    5f80:	a88080e7          	jalr	-1400(ra) # 6a04 <printf>
    close(fd);
    5f84:	854a                	mv	a0,s2
    5f86:	00000097          	auipc	ra,0x0
    5f8a:	71e080e7          	jalr	1822(ra) # 66a4 <close>
    if(total == 0)
    5f8e:	f20988e3          	beqz	s3,5ebe <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5f92:	2485                	addiw	s1,s1,1
    5f94:	bd4d                	j	5e46 <fsfull+0x50>

0000000000005f96 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5f96:	7179                	addi	sp,sp,-48
    5f98:	f406                	sd	ra,40(sp)
    5f9a:	f022                	sd	s0,32(sp)
    5f9c:	ec26                	sd	s1,24(sp)
    5f9e:	e84a                	sd	s2,16(sp)
    5fa0:	1800                	addi	s0,sp,48
    5fa2:	84aa                	mv	s1,a0
    5fa4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5fa6:	00003517          	auipc	a0,0x3
    5faa:	b8a50513          	addi	a0,a0,-1142 # 8b30 <malloc+0x206e>
    5fae:	00001097          	auipc	ra,0x1
    5fb2:	a56080e7          	jalr	-1450(ra) # 6a04 <printf>
  if((pid = fork()) < 0) {
    5fb6:	00000097          	auipc	ra,0x0
    5fba:	6be080e7          	jalr	1726(ra) # 6674 <fork>
    5fbe:	02054f63          	bltz	a0,5ffc <run+0x66>
    printf("runtest: fork error\n");
    exit(1,"");
  }
  if(pid == 0) {
    5fc2:	cd31                	beqz	a0,601e <run+0x88>
    f(s);
    exit(0,"");
  } else {
    wait(&xstatus,0);
    5fc4:	4581                	li	a1,0
    5fc6:	fdc40513          	addi	a0,s0,-36
    5fca:	00000097          	auipc	ra,0x0
    5fce:	6ba080e7          	jalr	1722(ra) # 6684 <wait>
    if(xstatus != 0) 
    5fd2:	fdc42783          	lw	a5,-36(s0)
    5fd6:	cfb9                	beqz	a5,6034 <run+0x9e>
      printf("FAILED\n");
    5fd8:	00003517          	auipc	a0,0x3
    5fdc:	b8050513          	addi	a0,a0,-1152 # 8b58 <malloc+0x2096>
    5fe0:	00001097          	auipc	ra,0x1
    5fe4:	a24080e7          	jalr	-1500(ra) # 6a04 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5fe8:	fdc42503          	lw	a0,-36(s0)
  }
}
    5fec:	00153513          	seqz	a0,a0
    5ff0:	70a2                	ld	ra,40(sp)
    5ff2:	7402                	ld	s0,32(sp)
    5ff4:	64e2                	ld	s1,24(sp)
    5ff6:	6942                	ld	s2,16(sp)
    5ff8:	6145                	addi	sp,sp,48
    5ffa:	8082                	ret
    printf("runtest: fork error\n");
    5ffc:	00003517          	auipc	a0,0x3
    6000:	b4450513          	addi	a0,a0,-1212 # 8b40 <malloc+0x207e>
    6004:	00001097          	auipc	ra,0x1
    6008:	a00080e7          	jalr	-1536(ra) # 6a04 <printf>
    exit(1,"");
    600c:	00002597          	auipc	a1,0x2
    6010:	1ec58593          	addi	a1,a1,492 # 81f8 <malloc+0x1736>
    6014:	4505                	li	a0,1
    6016:	00000097          	auipc	ra,0x0
    601a:	666080e7          	jalr	1638(ra) # 667c <exit>
    f(s);
    601e:	854a                	mv	a0,s2
    6020:	9482                	jalr	s1
    exit(0,"");
    6022:	00002597          	auipc	a1,0x2
    6026:	1d658593          	addi	a1,a1,470 # 81f8 <malloc+0x1736>
    602a:	4501                	li	a0,0
    602c:	00000097          	auipc	ra,0x0
    6030:	650080e7          	jalr	1616(ra) # 667c <exit>
      printf("OK\n");
    6034:	00003517          	auipc	a0,0x3
    6038:	b2c50513          	addi	a0,a0,-1236 # 8b60 <malloc+0x209e>
    603c:	00001097          	auipc	ra,0x1
    6040:	9c8080e7          	jalr	-1592(ra) # 6a04 <printf>
    6044:	b755                	j	5fe8 <run+0x52>

0000000000006046 <runtests>:

int
runtests(struct test *tests, char *justone) {
    6046:	1101                	addi	sp,sp,-32
    6048:	ec06                	sd	ra,24(sp)
    604a:	e822                	sd	s0,16(sp)
    604c:	e426                	sd	s1,8(sp)
    604e:	e04a                	sd	s2,0(sp)
    6050:	1000                	addi	s0,sp,32
    6052:	84aa                	mv	s1,a0
    6054:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    6056:	6508                	ld	a0,8(a0)
    6058:	ed09                	bnez	a0,6072 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    605a:	4501                	li	a0,0
    605c:	a82d                	j	6096 <runtests+0x50>
      if(!run(t->f, t->s)){
    605e:	648c                	ld	a1,8(s1)
    6060:	6088                	ld	a0,0(s1)
    6062:	00000097          	auipc	ra,0x0
    6066:	f34080e7          	jalr	-204(ra) # 5f96 <run>
    606a:	cd09                	beqz	a0,6084 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    606c:	04c1                	addi	s1,s1,16
    606e:	6488                	ld	a0,8(s1)
    6070:	c11d                	beqz	a0,6096 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6072:	fe0906e3          	beqz	s2,605e <runtests+0x18>
    6076:	85ca                	mv	a1,s2
    6078:	00000097          	auipc	ra,0x0
    607c:	3b2080e7          	jalr	946(ra) # 642a <strcmp>
    6080:	f575                	bnez	a0,606c <runtests+0x26>
    6082:	bff1                	j	605e <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    6084:	00003517          	auipc	a0,0x3
    6088:	ae450513          	addi	a0,a0,-1308 # 8b68 <malloc+0x20a6>
    608c:	00001097          	auipc	ra,0x1
    6090:	978080e7          	jalr	-1672(ra) # 6a04 <printf>
        return 1;
    6094:	4505                	li	a0,1
}
    6096:	60e2                	ld	ra,24(sp)
    6098:	6442                	ld	s0,16(sp)
    609a:	64a2                	ld	s1,8(sp)
    609c:	6902                	ld	s2,0(sp)
    609e:	6105                	addi	sp,sp,32
    60a0:	8082                	ret

00000000000060a2 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    60a2:	7139                	addi	sp,sp,-64
    60a4:	fc06                	sd	ra,56(sp)
    60a6:	f822                	sd	s0,48(sp)
    60a8:	f426                	sd	s1,40(sp)
    60aa:	f04a                	sd	s2,32(sp)
    60ac:	ec4e                	sd	s3,24(sp)
    60ae:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    60b0:	fc840513          	addi	a0,s0,-56
    60b4:	00000097          	auipc	ra,0x0
    60b8:	5d8080e7          	jalr	1496(ra) # 668c <pipe>
    60bc:	06054b63          	bltz	a0,6132 <countfree+0x90>
    printf("pipe() failed in countfree()\n");
    exit(1,"");
  }
  
  int pid = fork();
    60c0:	00000097          	auipc	ra,0x0
    60c4:	5b4080e7          	jalr	1460(ra) # 6674 <fork>

  if(pid < 0){
    60c8:	08054663          	bltz	a0,6154 <countfree+0xb2>
    printf("fork failed in countfree()\n");
    exit(1,"");
  }

  if(pid == 0){
    60cc:	ed55                	bnez	a0,6188 <countfree+0xe6>
    close(fds[0]);
    60ce:	fc842503          	lw	a0,-56(s0)
    60d2:	00000097          	auipc	ra,0x0
    60d6:	5d2080e7          	jalr	1490(ra) # 66a4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    60da:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    60dc:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    60de:	00001997          	auipc	s3,0x1
    60e2:	b9a98993          	addi	s3,s3,-1126 # 6c78 <malloc+0x1b6>
      uint64 a = (uint64) sbrk(4096);
    60e6:	6505                	lui	a0,0x1
    60e8:	00000097          	auipc	ra,0x0
    60ec:	61c080e7          	jalr	1564(ra) # 6704 <sbrk>
      if(a == 0xffffffffffffffff){
    60f0:	09250363          	beq	a0,s2,6176 <countfree+0xd4>
      *(char *)(a + 4096 - 1) = 1;
    60f4:	6785                	lui	a5,0x1
    60f6:	953e                	add	a0,a0,a5
    60f8:	fe950fa3          	sb	s1,-1(a0) # fff <unlinkread+0x187>
      if(write(fds[1], "x", 1) != 1){
    60fc:	8626                	mv	a2,s1
    60fe:	85ce                	mv	a1,s3
    6100:	fcc42503          	lw	a0,-52(s0)
    6104:	00000097          	auipc	ra,0x0
    6108:	598080e7          	jalr	1432(ra) # 669c <write>
    610c:	fc950de3          	beq	a0,s1,60e6 <countfree+0x44>
        printf("write() failed in countfree()\n");
    6110:	00003517          	auipc	a0,0x3
    6114:	ab050513          	addi	a0,a0,-1360 # 8bc0 <malloc+0x20fe>
    6118:	00001097          	auipc	ra,0x1
    611c:	8ec080e7          	jalr	-1812(ra) # 6a04 <printf>
        exit(1,"");
    6120:	00002597          	auipc	a1,0x2
    6124:	0d858593          	addi	a1,a1,216 # 81f8 <malloc+0x1736>
    6128:	4505                	li	a0,1
    612a:	00000097          	auipc	ra,0x0
    612e:	552080e7          	jalr	1362(ra) # 667c <exit>
    printf("pipe() failed in countfree()\n");
    6132:	00003517          	auipc	a0,0x3
    6136:	a4e50513          	addi	a0,a0,-1458 # 8b80 <malloc+0x20be>
    613a:	00001097          	auipc	ra,0x1
    613e:	8ca080e7          	jalr	-1846(ra) # 6a04 <printf>
    exit(1,"");
    6142:	00002597          	auipc	a1,0x2
    6146:	0b658593          	addi	a1,a1,182 # 81f8 <malloc+0x1736>
    614a:	4505                	li	a0,1
    614c:	00000097          	auipc	ra,0x0
    6150:	530080e7          	jalr	1328(ra) # 667c <exit>
    printf("fork failed in countfree()\n");
    6154:	00003517          	auipc	a0,0x3
    6158:	a4c50513          	addi	a0,a0,-1460 # 8ba0 <malloc+0x20de>
    615c:	00001097          	auipc	ra,0x1
    6160:	8a8080e7          	jalr	-1880(ra) # 6a04 <printf>
    exit(1,"");
    6164:	00002597          	auipc	a1,0x2
    6168:	09458593          	addi	a1,a1,148 # 81f8 <malloc+0x1736>
    616c:	4505                	li	a0,1
    616e:	00000097          	auipc	ra,0x0
    6172:	50e080e7          	jalr	1294(ra) # 667c <exit>
      }
    }

    exit(0,"");
    6176:	00002597          	auipc	a1,0x2
    617a:	08258593          	addi	a1,a1,130 # 81f8 <malloc+0x1736>
    617e:	4501                	li	a0,0
    6180:	00000097          	auipc	ra,0x0
    6184:	4fc080e7          	jalr	1276(ra) # 667c <exit>
  }

  close(fds[1]);
    6188:	fcc42503          	lw	a0,-52(s0)
    618c:	00000097          	auipc	ra,0x0
    6190:	518080e7          	jalr	1304(ra) # 66a4 <close>

  int n = 0;
    6194:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    6196:	4605                	li	a2,1
    6198:	fc740593          	addi	a1,s0,-57
    619c:	fc842503          	lw	a0,-56(s0)
    61a0:	00000097          	auipc	ra,0x0
    61a4:	4f4080e7          	jalr	1268(ra) # 6694 <read>
    if(cc < 0){
    61a8:	00054563          	bltz	a0,61b2 <countfree+0x110>
      printf("read() failed in countfree()\n");
      exit(1,"");
    }
    if(cc == 0)
    61ac:	c505                	beqz	a0,61d4 <countfree+0x132>
      break;
    n += 1;
    61ae:	2485                	addiw	s1,s1,1
  while(1){
    61b0:	b7dd                	j	6196 <countfree+0xf4>
      printf("read() failed in countfree()\n");
    61b2:	00003517          	auipc	a0,0x3
    61b6:	a2e50513          	addi	a0,a0,-1490 # 8be0 <malloc+0x211e>
    61ba:	00001097          	auipc	ra,0x1
    61be:	84a080e7          	jalr	-1974(ra) # 6a04 <printf>
      exit(1,"");
    61c2:	00002597          	auipc	a1,0x2
    61c6:	03658593          	addi	a1,a1,54 # 81f8 <malloc+0x1736>
    61ca:	4505                	li	a0,1
    61cc:	00000097          	auipc	ra,0x0
    61d0:	4b0080e7          	jalr	1200(ra) # 667c <exit>
  }

  close(fds[0]);
    61d4:	fc842503          	lw	a0,-56(s0)
    61d8:	00000097          	auipc	ra,0x0
    61dc:	4cc080e7          	jalr	1228(ra) # 66a4 <close>
  wait((int*)0,0);
    61e0:	4581                	li	a1,0
    61e2:	4501                	li	a0,0
    61e4:	00000097          	auipc	ra,0x0
    61e8:	4a0080e7          	jalr	1184(ra) # 6684 <wait>
  
  return n;
}
    61ec:	8526                	mv	a0,s1
    61ee:	70e2                	ld	ra,56(sp)
    61f0:	7442                	ld	s0,48(sp)
    61f2:	74a2                	ld	s1,40(sp)
    61f4:	7902                	ld	s2,32(sp)
    61f6:	69e2                	ld	s3,24(sp)
    61f8:	6121                	addi	sp,sp,64
    61fa:	8082                	ret

00000000000061fc <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    61fc:	711d                	addi	sp,sp,-96
    61fe:	ec86                	sd	ra,88(sp)
    6200:	e8a2                	sd	s0,80(sp)
    6202:	e4a6                	sd	s1,72(sp)
    6204:	e0ca                	sd	s2,64(sp)
    6206:	fc4e                	sd	s3,56(sp)
    6208:	f852                	sd	s4,48(sp)
    620a:	f456                	sd	s5,40(sp)
    620c:	f05a                	sd	s6,32(sp)
    620e:	ec5e                	sd	s7,24(sp)
    6210:	e862                	sd	s8,16(sp)
    6212:	e466                	sd	s9,8(sp)
    6214:	e06a                	sd	s10,0(sp)
    6216:	1080                	addi	s0,sp,96
    6218:	8a2a                	mv	s4,a0
    621a:	89ae                	mv	s3,a1
    621c:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    621e:	00003b97          	auipc	s7,0x3
    6222:	9e2b8b93          	addi	s7,s7,-1566 # 8c00 <malloc+0x213e>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    6226:	00004b17          	auipc	s6,0x4
    622a:	deab0b13          	addi	s6,s6,-534 # a010 <quicktests>
      if(continuous != 2) {
    622e:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    6230:	00003c97          	auipc	s9,0x3
    6234:	a08c8c93          	addi	s9,s9,-1528 # 8c38 <malloc+0x2176>
      if (runtests(slowtests, justone)) {
    6238:	00004c17          	auipc	s8,0x4
    623c:	1a8c0c13          	addi	s8,s8,424 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    6240:	00003d17          	auipc	s10,0x3
    6244:	9d8d0d13          	addi	s10,s10,-1576 # 8c18 <malloc+0x2156>
    6248:	a839                	j	6266 <drivetests+0x6a>
    624a:	856a                	mv	a0,s10
    624c:	00000097          	auipc	ra,0x0
    6250:	7b8080e7          	jalr	1976(ra) # 6a04 <printf>
    6254:	a081                	j	6294 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    6256:	00000097          	auipc	ra,0x0
    625a:	e4c080e7          	jalr	-436(ra) # 60a2 <countfree>
    625e:	06954263          	blt	a0,s1,62c2 <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    6262:	06098f63          	beqz	s3,62e0 <drivetests+0xe4>
    printf("usertests starting\n");
    6266:	855e                	mv	a0,s7
    6268:	00000097          	auipc	ra,0x0
    626c:	79c080e7          	jalr	1948(ra) # 6a04 <printf>
    int free0 = countfree();
    6270:	00000097          	auipc	ra,0x0
    6274:	e32080e7          	jalr	-462(ra) # 60a2 <countfree>
    6278:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    627a:	85ca                	mv	a1,s2
    627c:	855a                	mv	a0,s6
    627e:	00000097          	auipc	ra,0x0
    6282:	dc8080e7          	jalr	-568(ra) # 6046 <runtests>
    6286:	c119                	beqz	a0,628c <drivetests+0x90>
      if(continuous != 2) {
    6288:	05599863          	bne	s3,s5,62d8 <drivetests+0xdc>
    if(!quick) {
    628c:	fc0a15e3          	bnez	s4,6256 <drivetests+0x5a>
      if (justone == 0)
    6290:	fa090de3          	beqz	s2,624a <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    6294:	85ca                	mv	a1,s2
    6296:	8562                	mv	a0,s8
    6298:	00000097          	auipc	ra,0x0
    629c:	dae080e7          	jalr	-594(ra) # 6046 <runtests>
    62a0:	d95d                	beqz	a0,6256 <drivetests+0x5a>
        if(continuous != 2) {
    62a2:	03599d63          	bne	s3,s5,62dc <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    62a6:	00000097          	auipc	ra,0x0
    62aa:	dfc080e7          	jalr	-516(ra) # 60a2 <countfree>
    62ae:	fa955ae3          	bge	a0,s1,6262 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62b2:	8626                	mv	a2,s1
    62b4:	85aa                	mv	a1,a0
    62b6:	8566                	mv	a0,s9
    62b8:	00000097          	auipc	ra,0x0
    62bc:	74c080e7          	jalr	1868(ra) # 6a04 <printf>
      if(continuous != 2) {
    62c0:	b75d                	j	6266 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62c2:	8626                	mv	a2,s1
    62c4:	85aa                	mv	a1,a0
    62c6:	8566                	mv	a0,s9
    62c8:	00000097          	auipc	ra,0x0
    62cc:	73c080e7          	jalr	1852(ra) # 6a04 <printf>
      if(continuous != 2) {
    62d0:	f9598be3          	beq	s3,s5,6266 <drivetests+0x6a>
        return 1;
    62d4:	4505                	li	a0,1
    62d6:	a031                	j	62e2 <drivetests+0xe6>
        return 1;
    62d8:	4505                	li	a0,1
    62da:	a021                	j	62e2 <drivetests+0xe6>
          return 1;
    62dc:	4505                	li	a0,1
    62de:	a011                	j	62e2 <drivetests+0xe6>
  return 0;
    62e0:	854e                	mv	a0,s3
}
    62e2:	60e6                	ld	ra,88(sp)
    62e4:	6446                	ld	s0,80(sp)
    62e6:	64a6                	ld	s1,72(sp)
    62e8:	6906                	ld	s2,64(sp)
    62ea:	79e2                	ld	s3,56(sp)
    62ec:	7a42                	ld	s4,48(sp)
    62ee:	7aa2                	ld	s5,40(sp)
    62f0:	7b02                	ld	s6,32(sp)
    62f2:	6be2                	ld	s7,24(sp)
    62f4:	6c42                	ld	s8,16(sp)
    62f6:	6ca2                	ld	s9,8(sp)
    62f8:	6d02                	ld	s10,0(sp)
    62fa:	6125                	addi	sp,sp,96
    62fc:	8082                	ret

00000000000062fe <main>:

int
main(int argc, char *argv[])
{
    62fe:	1101                	addi	sp,sp,-32
    6300:	ec06                	sd	ra,24(sp)
    6302:	e822                	sd	s0,16(sp)
    6304:	e426                	sd	s1,8(sp)
    6306:	e04a                	sd	s2,0(sp)
    6308:	1000                	addi	s0,sp,32
    630a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    630c:	4789                	li	a5,2
    630e:	02f50763          	beq	a0,a5,633c <main+0x3e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    6312:	4785                	li	a5,1
    6314:	08a7c163          	blt	a5,a0,6396 <main+0x98>
  char *justone = 0;
    6318:	4601                	li	a2,0
  int quick = 0;
    631a:	4501                	li	a0,0
  int continuous = 0;
    631c:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1,"");
  }
  if (drivetests(quick, continuous, justone)) {
    631e:	85a6                	mv	a1,s1
    6320:	00000097          	auipc	ra,0x0
    6324:	edc080e7          	jalr	-292(ra) # 61fc <drivetests>
    6328:	c14d                	beqz	a0,63ca <main+0xcc>
    exit(1,"");
    632a:	00002597          	auipc	a1,0x2
    632e:	ece58593          	addi	a1,a1,-306 # 81f8 <malloc+0x1736>
    6332:	4505                	li	a0,1
    6334:	00000097          	auipc	ra,0x0
    6338:	348080e7          	jalr	840(ra) # 667c <exit>
    633c:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    633e:	00003597          	auipc	a1,0x3
    6342:	92a58593          	addi	a1,a1,-1750 # 8c68 <malloc+0x21a6>
    6346:	00893503          	ld	a0,8(s2)
    634a:	00000097          	auipc	ra,0x0
    634e:	0e0080e7          	jalr	224(ra) # 642a <strcmp>
    6352:	c13d                	beqz	a0,63b8 <main+0xba>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    6354:	00003597          	auipc	a1,0x3
    6358:	96c58593          	addi	a1,a1,-1684 # 8cc0 <malloc+0x21fe>
    635c:	00893503          	ld	a0,8(s2)
    6360:	00000097          	auipc	ra,0x0
    6364:	0ca080e7          	jalr	202(ra) # 642a <strcmp>
    6368:	cd31                	beqz	a0,63c4 <main+0xc6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    636a:	00003597          	auipc	a1,0x3
    636e:	94e58593          	addi	a1,a1,-1714 # 8cb8 <malloc+0x21f6>
    6372:	00893503          	ld	a0,8(s2)
    6376:	00000097          	auipc	ra,0x0
    637a:	0b4080e7          	jalr	180(ra) # 642a <strcmp>
    637e:	c129                	beqz	a0,63c0 <main+0xc2>
  } else if(argc == 2 && argv[1][0] != '-'){
    6380:	00893603          	ld	a2,8(s2)
    6384:	00064703          	lbu	a4,0(a2) # 3000 <sbrkmuch+0x74>
    6388:	02d00793          	li	a5,45
    638c:	00f70563          	beq	a4,a5,6396 <main+0x98>
  int quick = 0;
    6390:	4501                	li	a0,0
  int continuous = 0;
    6392:	4481                	li	s1,0
    6394:	b769                	j	631e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    6396:	00003517          	auipc	a0,0x3
    639a:	8da50513          	addi	a0,a0,-1830 # 8c70 <malloc+0x21ae>
    639e:	00000097          	auipc	ra,0x0
    63a2:	666080e7          	jalr	1638(ra) # 6a04 <printf>
    exit(1,"");
    63a6:	00002597          	auipc	a1,0x2
    63aa:	e5258593          	addi	a1,a1,-430 # 81f8 <malloc+0x1736>
    63ae:	4505                	li	a0,1
    63b0:	00000097          	auipc	ra,0x0
    63b4:	2cc080e7          	jalr	716(ra) # 667c <exit>
  int continuous = 0;
    63b8:	84aa                	mv	s1,a0
  char *justone = 0;
    63ba:	4601                	li	a2,0
    quick = 1;
    63bc:	4505                	li	a0,1
    63be:	b785                	j	631e <main+0x20>
  char *justone = 0;
    63c0:	4601                	li	a2,0
    63c2:	bfb1                	j	631e <main+0x20>
    63c4:	4601                	li	a2,0
    continuous = 1;
    63c6:	4485                	li	s1,1
    63c8:	bf99                	j	631e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    63ca:	00003517          	auipc	a0,0x3
    63ce:	8d650513          	addi	a0,a0,-1834 # 8ca0 <malloc+0x21de>
    63d2:	00000097          	auipc	ra,0x0
    63d6:	632080e7          	jalr	1586(ra) # 6a04 <printf>
  exit(0,"");
    63da:	00002597          	auipc	a1,0x2
    63de:	e1e58593          	addi	a1,a1,-482 # 81f8 <malloc+0x1736>
    63e2:	4501                	li	a0,0
    63e4:	00000097          	auipc	ra,0x0
    63e8:	298080e7          	jalr	664(ra) # 667c <exit>

00000000000063ec <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    63ec:	1141                	addi	sp,sp,-16
    63ee:	e406                	sd	ra,8(sp)
    63f0:	e022                	sd	s0,0(sp)
    63f2:	0800                	addi	s0,sp,16
  extern int main();
  main();
    63f4:	00000097          	auipc	ra,0x0
    63f8:	f0a080e7          	jalr	-246(ra) # 62fe <main>
  exit(0,"");
    63fc:	00002597          	auipc	a1,0x2
    6400:	dfc58593          	addi	a1,a1,-516 # 81f8 <malloc+0x1736>
    6404:	4501                	li	a0,0
    6406:	00000097          	auipc	ra,0x0
    640a:	276080e7          	jalr	630(ra) # 667c <exit>

000000000000640e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    640e:	1141                	addi	sp,sp,-16
    6410:	e422                	sd	s0,8(sp)
    6412:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    6414:	87aa                	mv	a5,a0
    6416:	0585                	addi	a1,a1,1
    6418:	0785                	addi	a5,a5,1
    641a:	fff5c703          	lbu	a4,-1(a1)
    641e:	fee78fa3          	sb	a4,-1(a5) # fff <unlinkread+0x187>
    6422:	fb75                	bnez	a4,6416 <strcpy+0x8>
    ;
  return os;
}
    6424:	6422                	ld	s0,8(sp)
    6426:	0141                	addi	sp,sp,16
    6428:	8082                	ret

000000000000642a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    642a:	1141                	addi	sp,sp,-16
    642c:	e422                	sd	s0,8(sp)
    642e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    6430:	00054783          	lbu	a5,0(a0)
    6434:	cb91                	beqz	a5,6448 <strcmp+0x1e>
    6436:	0005c703          	lbu	a4,0(a1)
    643a:	00f71763          	bne	a4,a5,6448 <strcmp+0x1e>
    p++, q++;
    643e:	0505                	addi	a0,a0,1
    6440:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    6442:	00054783          	lbu	a5,0(a0)
    6446:	fbe5                	bnez	a5,6436 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    6448:	0005c503          	lbu	a0,0(a1)
}
    644c:	40a7853b          	subw	a0,a5,a0
    6450:	6422                	ld	s0,8(sp)
    6452:	0141                	addi	sp,sp,16
    6454:	8082                	ret

0000000000006456 <strlen>:

uint
strlen(const char *s)
{
    6456:	1141                	addi	sp,sp,-16
    6458:	e422                	sd	s0,8(sp)
    645a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    645c:	00054783          	lbu	a5,0(a0)
    6460:	cf91                	beqz	a5,647c <strlen+0x26>
    6462:	0505                	addi	a0,a0,1
    6464:	87aa                	mv	a5,a0
    6466:	4685                	li	a3,1
    6468:	9e89                	subw	a3,a3,a0
    646a:	00f6853b          	addw	a0,a3,a5
    646e:	0785                	addi	a5,a5,1
    6470:	fff7c703          	lbu	a4,-1(a5)
    6474:	fb7d                	bnez	a4,646a <strlen+0x14>
    ;
  return n;
}
    6476:	6422                	ld	s0,8(sp)
    6478:	0141                	addi	sp,sp,16
    647a:	8082                	ret
  for(n = 0; s[n]; n++)
    647c:	4501                	li	a0,0
    647e:	bfe5                	j	6476 <strlen+0x20>

0000000000006480 <memset>:

void*
memset(void *dst, int c, uint n)
{
    6480:	1141                	addi	sp,sp,-16
    6482:	e422                	sd	s0,8(sp)
    6484:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    6486:	ca19                	beqz	a2,649c <memset+0x1c>
    6488:	87aa                	mv	a5,a0
    648a:	1602                	slli	a2,a2,0x20
    648c:	9201                	srli	a2,a2,0x20
    648e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    6492:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    6496:	0785                	addi	a5,a5,1
    6498:	fee79de3          	bne	a5,a4,6492 <memset+0x12>
  }
  return dst;
}
    649c:	6422                	ld	s0,8(sp)
    649e:	0141                	addi	sp,sp,16
    64a0:	8082                	ret

00000000000064a2 <strchr>:

char*
strchr(const char *s, char c)
{
    64a2:	1141                	addi	sp,sp,-16
    64a4:	e422                	sd	s0,8(sp)
    64a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    64a8:	00054783          	lbu	a5,0(a0)
    64ac:	cb99                	beqz	a5,64c2 <strchr+0x20>
    if(*s == c)
    64ae:	00f58763          	beq	a1,a5,64bc <strchr+0x1a>
  for(; *s; s++)
    64b2:	0505                	addi	a0,a0,1
    64b4:	00054783          	lbu	a5,0(a0)
    64b8:	fbfd                	bnez	a5,64ae <strchr+0xc>
      return (char*)s;
  return 0;
    64ba:	4501                	li	a0,0
}
    64bc:	6422                	ld	s0,8(sp)
    64be:	0141                	addi	sp,sp,16
    64c0:	8082                	ret
  return 0;
    64c2:	4501                	li	a0,0
    64c4:	bfe5                	j	64bc <strchr+0x1a>

00000000000064c6 <gets>:

char*
gets(char *buf, int max)
{
    64c6:	711d                	addi	sp,sp,-96
    64c8:	ec86                	sd	ra,88(sp)
    64ca:	e8a2                	sd	s0,80(sp)
    64cc:	e4a6                	sd	s1,72(sp)
    64ce:	e0ca                	sd	s2,64(sp)
    64d0:	fc4e                	sd	s3,56(sp)
    64d2:	f852                	sd	s4,48(sp)
    64d4:	f456                	sd	s5,40(sp)
    64d6:	f05a                	sd	s6,32(sp)
    64d8:	ec5e                	sd	s7,24(sp)
    64da:	1080                	addi	s0,sp,96
    64dc:	8baa                	mv	s7,a0
    64de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    64e0:	892a                	mv	s2,a0
    64e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    64e4:	4aa9                	li	s5,10
    64e6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    64e8:	89a6                	mv	s3,s1
    64ea:	2485                	addiw	s1,s1,1
    64ec:	0344d863          	bge	s1,s4,651c <gets+0x56>
    cc = read(0, &c, 1);
    64f0:	4605                	li	a2,1
    64f2:	faf40593          	addi	a1,s0,-81
    64f6:	4501                	li	a0,0
    64f8:	00000097          	auipc	ra,0x0
    64fc:	19c080e7          	jalr	412(ra) # 6694 <read>
    if(cc < 1)
    6500:	00a05e63          	blez	a0,651c <gets+0x56>
    buf[i++] = c;
    6504:	faf44783          	lbu	a5,-81(s0)
    6508:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    650c:	01578763          	beq	a5,s5,651a <gets+0x54>
    6510:	0905                	addi	s2,s2,1
    6512:	fd679be3          	bne	a5,s6,64e8 <gets+0x22>
  for(i=0; i+1 < max; ){
    6516:	89a6                	mv	s3,s1
    6518:	a011                	j	651c <gets+0x56>
    651a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    651c:	99de                	add	s3,s3,s7
    651e:	00098023          	sb	zero,0(s3)
  return buf;
}
    6522:	855e                	mv	a0,s7
    6524:	60e6                	ld	ra,88(sp)
    6526:	6446                	ld	s0,80(sp)
    6528:	64a6                	ld	s1,72(sp)
    652a:	6906                	ld	s2,64(sp)
    652c:	79e2                	ld	s3,56(sp)
    652e:	7a42                	ld	s4,48(sp)
    6530:	7aa2                	ld	s5,40(sp)
    6532:	7b02                	ld	s6,32(sp)
    6534:	6be2                	ld	s7,24(sp)
    6536:	6125                	addi	sp,sp,96
    6538:	8082                	ret

000000000000653a <stat>:

int
stat(const char *n, struct stat *st)
{
    653a:	1101                	addi	sp,sp,-32
    653c:	ec06                	sd	ra,24(sp)
    653e:	e822                	sd	s0,16(sp)
    6540:	e426                	sd	s1,8(sp)
    6542:	e04a                	sd	s2,0(sp)
    6544:	1000                	addi	s0,sp,32
    6546:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    6548:	4581                	li	a1,0
    654a:	00000097          	auipc	ra,0x0
    654e:	172080e7          	jalr	370(ra) # 66bc <open>
  if(fd < 0)
    6552:	02054563          	bltz	a0,657c <stat+0x42>
    6556:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    6558:	85ca                	mv	a1,s2
    655a:	00000097          	auipc	ra,0x0
    655e:	17a080e7          	jalr	378(ra) # 66d4 <fstat>
    6562:	892a                	mv	s2,a0
  close(fd);
    6564:	8526                	mv	a0,s1
    6566:	00000097          	auipc	ra,0x0
    656a:	13e080e7          	jalr	318(ra) # 66a4 <close>
  return r;
}
    656e:	854a                	mv	a0,s2
    6570:	60e2                	ld	ra,24(sp)
    6572:	6442                	ld	s0,16(sp)
    6574:	64a2                	ld	s1,8(sp)
    6576:	6902                	ld	s2,0(sp)
    6578:	6105                	addi	sp,sp,32
    657a:	8082                	ret
    return -1;
    657c:	597d                	li	s2,-1
    657e:	bfc5                	j	656e <stat+0x34>

0000000000006580 <atoi>:

int
atoi(const char *s)
{
    6580:	1141                	addi	sp,sp,-16
    6582:	e422                	sd	s0,8(sp)
    6584:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    6586:	00054603          	lbu	a2,0(a0)
    658a:	fd06079b          	addiw	a5,a2,-48
    658e:	0ff7f793          	andi	a5,a5,255
    6592:	4725                	li	a4,9
    6594:	02f76963          	bltu	a4,a5,65c6 <atoi+0x46>
    6598:	86aa                	mv	a3,a0
  n = 0;
    659a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    659c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    659e:	0685                	addi	a3,a3,1
    65a0:	0025179b          	slliw	a5,a0,0x2
    65a4:	9fa9                	addw	a5,a5,a0
    65a6:	0017979b          	slliw	a5,a5,0x1
    65aa:	9fb1                	addw	a5,a5,a2
    65ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    65b0:	0006c603          	lbu	a2,0(a3)
    65b4:	fd06071b          	addiw	a4,a2,-48
    65b8:	0ff77713          	andi	a4,a4,255
    65bc:	fee5f1e3          	bgeu	a1,a4,659e <atoi+0x1e>
  return n;
}
    65c0:	6422                	ld	s0,8(sp)
    65c2:	0141                	addi	sp,sp,16
    65c4:	8082                	ret
  n = 0;
    65c6:	4501                	li	a0,0
    65c8:	bfe5                	j	65c0 <atoi+0x40>

00000000000065ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    65ca:	1141                	addi	sp,sp,-16
    65cc:	e422                	sd	s0,8(sp)
    65ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    65d0:	02b57463          	bgeu	a0,a1,65f8 <memmove+0x2e>
    while(n-- > 0)
    65d4:	00c05f63          	blez	a2,65f2 <memmove+0x28>
    65d8:	1602                	slli	a2,a2,0x20
    65da:	9201                	srli	a2,a2,0x20
    65dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    65e0:	872a                	mv	a4,a0
      *dst++ = *src++;
    65e2:	0585                	addi	a1,a1,1
    65e4:	0705                	addi	a4,a4,1
    65e6:	fff5c683          	lbu	a3,-1(a1)
    65ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    65ee:	fee79ae3          	bne	a5,a4,65e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    65f2:	6422                	ld	s0,8(sp)
    65f4:	0141                	addi	sp,sp,16
    65f6:	8082                	ret
    dst += n;
    65f8:	00c50733          	add	a4,a0,a2
    src += n;
    65fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    65fe:	fec05ae3          	blez	a2,65f2 <memmove+0x28>
    6602:	fff6079b          	addiw	a5,a2,-1
    6606:	1782                	slli	a5,a5,0x20
    6608:	9381                	srli	a5,a5,0x20
    660a:	fff7c793          	not	a5,a5
    660e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    6610:	15fd                	addi	a1,a1,-1
    6612:	177d                	addi	a4,a4,-1
    6614:	0005c683          	lbu	a3,0(a1)
    6618:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    661c:	fee79ae3          	bne	a5,a4,6610 <memmove+0x46>
    6620:	bfc9                	j	65f2 <memmove+0x28>

0000000000006622 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    6622:	1141                	addi	sp,sp,-16
    6624:	e422                	sd	s0,8(sp)
    6626:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    6628:	ca05                	beqz	a2,6658 <memcmp+0x36>
    662a:	fff6069b          	addiw	a3,a2,-1
    662e:	1682                	slli	a3,a3,0x20
    6630:	9281                	srli	a3,a3,0x20
    6632:	0685                	addi	a3,a3,1
    6634:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    6636:	00054783          	lbu	a5,0(a0)
    663a:	0005c703          	lbu	a4,0(a1)
    663e:	00e79863          	bne	a5,a4,664e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    6642:	0505                	addi	a0,a0,1
    p2++;
    6644:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    6646:	fed518e3          	bne	a0,a3,6636 <memcmp+0x14>
  }
  return 0;
    664a:	4501                	li	a0,0
    664c:	a019                	j	6652 <memcmp+0x30>
      return *p1 - *p2;
    664e:	40e7853b          	subw	a0,a5,a4
}
    6652:	6422                	ld	s0,8(sp)
    6654:	0141                	addi	sp,sp,16
    6656:	8082                	ret
  return 0;
    6658:	4501                	li	a0,0
    665a:	bfe5                	j	6652 <memcmp+0x30>

000000000000665c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    665c:	1141                	addi	sp,sp,-16
    665e:	e406                	sd	ra,8(sp)
    6660:	e022                	sd	s0,0(sp)
    6662:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    6664:	00000097          	auipc	ra,0x0
    6668:	f66080e7          	jalr	-154(ra) # 65ca <memmove>
}
    666c:	60a2                	ld	ra,8(sp)
    666e:	6402                	ld	s0,0(sp)
    6670:	0141                	addi	sp,sp,16
    6672:	8082                	ret

0000000000006674 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    6674:	4885                	li	a7,1
 ecall
    6676:	00000073          	ecall
 ret
    667a:	8082                	ret

000000000000667c <exit>:
.global exit
exit:
 li a7, SYS_exit
    667c:	4889                	li	a7,2
 ecall
    667e:	00000073          	ecall
 ret
    6682:	8082                	ret

0000000000006684 <wait>:
.global wait
wait:
 li a7, SYS_wait
    6684:	488d                	li	a7,3
 ecall
    6686:	00000073          	ecall
 ret
    668a:	8082                	ret

000000000000668c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    668c:	4891                	li	a7,4
 ecall
    668e:	00000073          	ecall
 ret
    6692:	8082                	ret

0000000000006694 <read>:
.global read
read:
 li a7, SYS_read
    6694:	4895                	li	a7,5
 ecall
    6696:	00000073          	ecall
 ret
    669a:	8082                	ret

000000000000669c <write>:
.global write
write:
 li a7, SYS_write
    669c:	48c1                	li	a7,16
 ecall
    669e:	00000073          	ecall
 ret
    66a2:	8082                	ret

00000000000066a4 <close>:
.global close
close:
 li a7, SYS_close
    66a4:	48d5                	li	a7,21
 ecall
    66a6:	00000073          	ecall
 ret
    66aa:	8082                	ret

00000000000066ac <kill>:
.global kill
kill:
 li a7, SYS_kill
    66ac:	4899                	li	a7,6
 ecall
    66ae:	00000073          	ecall
 ret
    66b2:	8082                	ret

00000000000066b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    66b4:	489d                	li	a7,7
 ecall
    66b6:	00000073          	ecall
 ret
    66ba:	8082                	ret

00000000000066bc <open>:
.global open
open:
 li a7, SYS_open
    66bc:	48bd                	li	a7,15
 ecall
    66be:	00000073          	ecall
 ret
    66c2:	8082                	ret

00000000000066c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    66c4:	48c5                	li	a7,17
 ecall
    66c6:	00000073          	ecall
 ret
    66ca:	8082                	ret

00000000000066cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    66cc:	48c9                	li	a7,18
 ecall
    66ce:	00000073          	ecall
 ret
    66d2:	8082                	ret

00000000000066d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    66d4:	48a1                	li	a7,8
 ecall
    66d6:	00000073          	ecall
 ret
    66da:	8082                	ret

00000000000066dc <link>:
.global link
link:
 li a7, SYS_link
    66dc:	48cd                	li	a7,19
 ecall
    66de:	00000073          	ecall
 ret
    66e2:	8082                	ret

00000000000066e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    66e4:	48d1                	li	a7,20
 ecall
    66e6:	00000073          	ecall
 ret
    66ea:	8082                	ret

00000000000066ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    66ec:	48a5                	li	a7,9
 ecall
    66ee:	00000073          	ecall
 ret
    66f2:	8082                	ret

00000000000066f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    66f4:	48a9                	li	a7,10
 ecall
    66f6:	00000073          	ecall
 ret
    66fa:	8082                	ret

00000000000066fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    66fc:	48ad                	li	a7,11
 ecall
    66fe:	00000073          	ecall
 ret
    6702:	8082                	ret

0000000000006704 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    6704:	48b1                	li	a7,12
 ecall
    6706:	00000073          	ecall
 ret
    670a:	8082                	ret

000000000000670c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    670c:	48b5                	li	a7,13
 ecall
    670e:	00000073          	ecall
 ret
    6712:	8082                	ret

0000000000006714 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    6714:	48b9                	li	a7,14
 ecall
    6716:	00000073          	ecall
 ret
    671a:	8082                	ret

000000000000671c <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
    671c:	48d9                	li	a7,22
 ecall
    671e:	00000073          	ecall
 ret
    6722:	8082                	ret

0000000000006724 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
    6724:	48dd                	li	a7,23
 ecall
    6726:	00000073          	ecall
 ret
    672a:	8082                	ret

000000000000672c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    672c:	1101                	addi	sp,sp,-32
    672e:	ec06                	sd	ra,24(sp)
    6730:	e822                	sd	s0,16(sp)
    6732:	1000                	addi	s0,sp,32
    6734:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6738:	4605                	li	a2,1
    673a:	fef40593          	addi	a1,s0,-17
    673e:	00000097          	auipc	ra,0x0
    6742:	f5e080e7          	jalr	-162(ra) # 669c <write>
}
    6746:	60e2                	ld	ra,24(sp)
    6748:	6442                	ld	s0,16(sp)
    674a:	6105                	addi	sp,sp,32
    674c:	8082                	ret

000000000000674e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    674e:	7139                	addi	sp,sp,-64
    6750:	fc06                	sd	ra,56(sp)
    6752:	f822                	sd	s0,48(sp)
    6754:	f426                	sd	s1,40(sp)
    6756:	f04a                	sd	s2,32(sp)
    6758:	ec4e                	sd	s3,24(sp)
    675a:	0080                	addi	s0,sp,64
    675c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    675e:	c299                	beqz	a3,6764 <printint+0x16>
    6760:	0805c863          	bltz	a1,67f0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    6764:	2581                	sext.w	a1,a1
  neg = 0;
    6766:	4881                	li	a7,0
    6768:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    676c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    676e:	2601                	sext.w	a2,a2
    6770:	00003517          	auipc	a0,0x3
    6774:	8c050513          	addi	a0,a0,-1856 # 9030 <digits>
    6778:	883a                	mv	a6,a4
    677a:	2705                	addiw	a4,a4,1
    677c:	02c5f7bb          	remuw	a5,a1,a2
    6780:	1782                	slli	a5,a5,0x20
    6782:	9381                	srli	a5,a5,0x20
    6784:	97aa                	add	a5,a5,a0
    6786:	0007c783          	lbu	a5,0(a5)
    678a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    678e:	0005879b          	sext.w	a5,a1
    6792:	02c5d5bb          	divuw	a1,a1,a2
    6796:	0685                	addi	a3,a3,1
    6798:	fec7f0e3          	bgeu	a5,a2,6778 <printint+0x2a>
  if(neg)
    679c:	00088b63          	beqz	a7,67b2 <printint+0x64>
    buf[i++] = '-';
    67a0:	fd040793          	addi	a5,s0,-48
    67a4:	973e                	add	a4,a4,a5
    67a6:	02d00793          	li	a5,45
    67aa:	fef70823          	sb	a5,-16(a4)
    67ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    67b2:	02e05863          	blez	a4,67e2 <printint+0x94>
    67b6:	fc040793          	addi	a5,s0,-64
    67ba:	00e78933          	add	s2,a5,a4
    67be:	fff78993          	addi	s3,a5,-1
    67c2:	99ba                	add	s3,s3,a4
    67c4:	377d                	addiw	a4,a4,-1
    67c6:	1702                	slli	a4,a4,0x20
    67c8:	9301                	srli	a4,a4,0x20
    67ca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    67ce:	fff94583          	lbu	a1,-1(s2)
    67d2:	8526                	mv	a0,s1
    67d4:	00000097          	auipc	ra,0x0
    67d8:	f58080e7          	jalr	-168(ra) # 672c <putc>
  while(--i >= 0)
    67dc:	197d                	addi	s2,s2,-1
    67de:	ff3918e3          	bne	s2,s3,67ce <printint+0x80>
}
    67e2:	70e2                	ld	ra,56(sp)
    67e4:	7442                	ld	s0,48(sp)
    67e6:	74a2                	ld	s1,40(sp)
    67e8:	7902                	ld	s2,32(sp)
    67ea:	69e2                	ld	s3,24(sp)
    67ec:	6121                	addi	sp,sp,64
    67ee:	8082                	ret
    x = -xx;
    67f0:	40b005bb          	negw	a1,a1
    neg = 1;
    67f4:	4885                	li	a7,1
    x = -xx;
    67f6:	bf8d                	j	6768 <printint+0x1a>

00000000000067f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    67f8:	7119                	addi	sp,sp,-128
    67fa:	fc86                	sd	ra,120(sp)
    67fc:	f8a2                	sd	s0,112(sp)
    67fe:	f4a6                	sd	s1,104(sp)
    6800:	f0ca                	sd	s2,96(sp)
    6802:	ecce                	sd	s3,88(sp)
    6804:	e8d2                	sd	s4,80(sp)
    6806:	e4d6                	sd	s5,72(sp)
    6808:	e0da                	sd	s6,64(sp)
    680a:	fc5e                	sd	s7,56(sp)
    680c:	f862                	sd	s8,48(sp)
    680e:	f466                	sd	s9,40(sp)
    6810:	f06a                	sd	s10,32(sp)
    6812:	ec6e                	sd	s11,24(sp)
    6814:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    6816:	0005c903          	lbu	s2,0(a1)
    681a:	18090f63          	beqz	s2,69b8 <vprintf+0x1c0>
    681e:	8aaa                	mv	s5,a0
    6820:	8b32                	mv	s6,a2
    6822:	00158493          	addi	s1,a1,1
  state = 0;
    6826:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    6828:	02500a13          	li	s4,37
      if(c == 'd'){
    682c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    6830:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    6834:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    6838:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    683c:	00002b97          	auipc	s7,0x2
    6840:	7f4b8b93          	addi	s7,s7,2036 # 9030 <digits>
    6844:	a839                	j	6862 <vprintf+0x6a>
        putc(fd, c);
    6846:	85ca                	mv	a1,s2
    6848:	8556                	mv	a0,s5
    684a:	00000097          	auipc	ra,0x0
    684e:	ee2080e7          	jalr	-286(ra) # 672c <putc>
    6852:	a019                	j	6858 <vprintf+0x60>
    } else if(state == '%'){
    6854:	01498f63          	beq	s3,s4,6872 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    6858:	0485                	addi	s1,s1,1
    685a:	fff4c903          	lbu	s2,-1(s1)
    685e:	14090d63          	beqz	s2,69b8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    6862:	0009079b          	sext.w	a5,s2
    if(state == 0){
    6866:	fe0997e3          	bnez	s3,6854 <vprintf+0x5c>
      if(c == '%'){
    686a:	fd479ee3          	bne	a5,s4,6846 <vprintf+0x4e>
        state = '%';
    686e:	89be                	mv	s3,a5
    6870:	b7e5                	j	6858 <vprintf+0x60>
      if(c == 'd'){
    6872:	05878063          	beq	a5,s8,68b2 <vprintf+0xba>
      } else if(c == 'l') {
    6876:	05978c63          	beq	a5,s9,68ce <vprintf+0xd6>
      } else if(c == 'x') {
    687a:	07a78863          	beq	a5,s10,68ea <vprintf+0xf2>
      } else if(c == 'p') {
    687e:	09b78463          	beq	a5,s11,6906 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    6882:	07300713          	li	a4,115
    6886:	0ce78663          	beq	a5,a4,6952 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    688a:	06300713          	li	a4,99
    688e:	0ee78e63          	beq	a5,a4,698a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    6892:	11478863          	beq	a5,s4,69a2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    6896:	85d2                	mv	a1,s4
    6898:	8556                	mv	a0,s5
    689a:	00000097          	auipc	ra,0x0
    689e:	e92080e7          	jalr	-366(ra) # 672c <putc>
        putc(fd, c);
    68a2:	85ca                	mv	a1,s2
    68a4:	8556                	mv	a0,s5
    68a6:	00000097          	auipc	ra,0x0
    68aa:	e86080e7          	jalr	-378(ra) # 672c <putc>
      }
      state = 0;
    68ae:	4981                	li	s3,0
    68b0:	b765                	j	6858 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    68b2:	008b0913          	addi	s2,s6,8
    68b6:	4685                	li	a3,1
    68b8:	4629                	li	a2,10
    68ba:	000b2583          	lw	a1,0(s6)
    68be:	8556                	mv	a0,s5
    68c0:	00000097          	auipc	ra,0x0
    68c4:	e8e080e7          	jalr	-370(ra) # 674e <printint>
    68c8:	8b4a                	mv	s6,s2
      state = 0;
    68ca:	4981                	li	s3,0
    68cc:	b771                	j	6858 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    68ce:	008b0913          	addi	s2,s6,8
    68d2:	4681                	li	a3,0
    68d4:	4629                	li	a2,10
    68d6:	000b2583          	lw	a1,0(s6)
    68da:	8556                	mv	a0,s5
    68dc:	00000097          	auipc	ra,0x0
    68e0:	e72080e7          	jalr	-398(ra) # 674e <printint>
    68e4:	8b4a                	mv	s6,s2
      state = 0;
    68e6:	4981                	li	s3,0
    68e8:	bf85                	j	6858 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    68ea:	008b0913          	addi	s2,s6,8
    68ee:	4681                	li	a3,0
    68f0:	4641                	li	a2,16
    68f2:	000b2583          	lw	a1,0(s6)
    68f6:	8556                	mv	a0,s5
    68f8:	00000097          	auipc	ra,0x0
    68fc:	e56080e7          	jalr	-426(ra) # 674e <printint>
    6900:	8b4a                	mv	s6,s2
      state = 0;
    6902:	4981                	li	s3,0
    6904:	bf91                	j	6858 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    6906:	008b0793          	addi	a5,s6,8
    690a:	f8f43423          	sd	a5,-120(s0)
    690e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    6912:	03000593          	li	a1,48
    6916:	8556                	mv	a0,s5
    6918:	00000097          	auipc	ra,0x0
    691c:	e14080e7          	jalr	-492(ra) # 672c <putc>
  putc(fd, 'x');
    6920:	85ea                	mv	a1,s10
    6922:	8556                	mv	a0,s5
    6924:	00000097          	auipc	ra,0x0
    6928:	e08080e7          	jalr	-504(ra) # 672c <putc>
    692c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    692e:	03c9d793          	srli	a5,s3,0x3c
    6932:	97de                	add	a5,a5,s7
    6934:	0007c583          	lbu	a1,0(a5)
    6938:	8556                	mv	a0,s5
    693a:	00000097          	auipc	ra,0x0
    693e:	df2080e7          	jalr	-526(ra) # 672c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    6942:	0992                	slli	s3,s3,0x4
    6944:	397d                	addiw	s2,s2,-1
    6946:	fe0914e3          	bnez	s2,692e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    694a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    694e:	4981                	li	s3,0
    6950:	b721                	j	6858 <vprintf+0x60>
        s = va_arg(ap, char*);
    6952:	008b0993          	addi	s3,s6,8
    6956:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    695a:	02090163          	beqz	s2,697c <vprintf+0x184>
        while(*s != 0){
    695e:	00094583          	lbu	a1,0(s2)
    6962:	c9a1                	beqz	a1,69b2 <vprintf+0x1ba>
          putc(fd, *s);
    6964:	8556                	mv	a0,s5
    6966:	00000097          	auipc	ra,0x0
    696a:	dc6080e7          	jalr	-570(ra) # 672c <putc>
          s++;
    696e:	0905                	addi	s2,s2,1
        while(*s != 0){
    6970:	00094583          	lbu	a1,0(s2)
    6974:	f9e5                	bnez	a1,6964 <vprintf+0x16c>
        s = va_arg(ap, char*);
    6976:	8b4e                	mv	s6,s3
      state = 0;
    6978:	4981                	li	s3,0
    697a:	bdf9                	j	6858 <vprintf+0x60>
          s = "(null)";
    697c:	00002917          	auipc	s2,0x2
    6980:	6ac90913          	addi	s2,s2,1708 # 9028 <malloc+0x2566>
        while(*s != 0){
    6984:	02800593          	li	a1,40
    6988:	bff1                	j	6964 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    698a:	008b0913          	addi	s2,s6,8
    698e:	000b4583          	lbu	a1,0(s6)
    6992:	8556                	mv	a0,s5
    6994:	00000097          	auipc	ra,0x0
    6998:	d98080e7          	jalr	-616(ra) # 672c <putc>
    699c:	8b4a                	mv	s6,s2
      state = 0;
    699e:	4981                	li	s3,0
    69a0:	bd65                	j	6858 <vprintf+0x60>
        putc(fd, c);
    69a2:	85d2                	mv	a1,s4
    69a4:	8556                	mv	a0,s5
    69a6:	00000097          	auipc	ra,0x0
    69aa:	d86080e7          	jalr	-634(ra) # 672c <putc>
      state = 0;
    69ae:	4981                	li	s3,0
    69b0:	b565                	j	6858 <vprintf+0x60>
        s = va_arg(ap, char*);
    69b2:	8b4e                	mv	s6,s3
      state = 0;
    69b4:	4981                	li	s3,0
    69b6:	b54d                	j	6858 <vprintf+0x60>
    }
  }
}
    69b8:	70e6                	ld	ra,120(sp)
    69ba:	7446                	ld	s0,112(sp)
    69bc:	74a6                	ld	s1,104(sp)
    69be:	7906                	ld	s2,96(sp)
    69c0:	69e6                	ld	s3,88(sp)
    69c2:	6a46                	ld	s4,80(sp)
    69c4:	6aa6                	ld	s5,72(sp)
    69c6:	6b06                	ld	s6,64(sp)
    69c8:	7be2                	ld	s7,56(sp)
    69ca:	7c42                	ld	s8,48(sp)
    69cc:	7ca2                	ld	s9,40(sp)
    69ce:	7d02                	ld	s10,32(sp)
    69d0:	6de2                	ld	s11,24(sp)
    69d2:	6109                	addi	sp,sp,128
    69d4:	8082                	ret

00000000000069d6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    69d6:	715d                	addi	sp,sp,-80
    69d8:	ec06                	sd	ra,24(sp)
    69da:	e822                	sd	s0,16(sp)
    69dc:	1000                	addi	s0,sp,32
    69de:	e010                	sd	a2,0(s0)
    69e0:	e414                	sd	a3,8(s0)
    69e2:	e818                	sd	a4,16(s0)
    69e4:	ec1c                	sd	a5,24(s0)
    69e6:	03043023          	sd	a6,32(s0)
    69ea:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    69ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    69f2:	8622                	mv	a2,s0
    69f4:	00000097          	auipc	ra,0x0
    69f8:	e04080e7          	jalr	-508(ra) # 67f8 <vprintf>
}
    69fc:	60e2                	ld	ra,24(sp)
    69fe:	6442                	ld	s0,16(sp)
    6a00:	6161                	addi	sp,sp,80
    6a02:	8082                	ret

0000000000006a04 <printf>:

void
printf(const char *fmt, ...)
{
    6a04:	711d                	addi	sp,sp,-96
    6a06:	ec06                	sd	ra,24(sp)
    6a08:	e822                	sd	s0,16(sp)
    6a0a:	1000                	addi	s0,sp,32
    6a0c:	e40c                	sd	a1,8(s0)
    6a0e:	e810                	sd	a2,16(s0)
    6a10:	ec14                	sd	a3,24(s0)
    6a12:	f018                	sd	a4,32(s0)
    6a14:	f41c                	sd	a5,40(s0)
    6a16:	03043823          	sd	a6,48(s0)
    6a1a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    6a1e:	00840613          	addi	a2,s0,8
    6a22:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6a26:	85aa                	mv	a1,a0
    6a28:	4505                	li	a0,1
    6a2a:	00000097          	auipc	ra,0x0
    6a2e:	dce080e7          	jalr	-562(ra) # 67f8 <vprintf>
}
    6a32:	60e2                	ld	ra,24(sp)
    6a34:	6442                	ld	s0,16(sp)
    6a36:	6125                	addi	sp,sp,96
    6a38:	8082                	ret

0000000000006a3a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6a3a:	1141                	addi	sp,sp,-16
    6a3c:	e422                	sd	s0,8(sp)
    6a3e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6a40:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a44:	00004797          	auipc	a5,0x4
    6a48:	a0c7b783          	ld	a5,-1524(a5) # a450 <freep>
    6a4c:	a805                	j	6a7c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6a4e:	4618                	lw	a4,8(a2)
    6a50:	9db9                	addw	a1,a1,a4
    6a52:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6a56:	6398                	ld	a4,0(a5)
    6a58:	6318                	ld	a4,0(a4)
    6a5a:	fee53823          	sd	a4,-16(a0)
    6a5e:	a091                	j	6aa2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6a60:	ff852703          	lw	a4,-8(a0)
    6a64:	9e39                	addw	a2,a2,a4
    6a66:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    6a68:	ff053703          	ld	a4,-16(a0)
    6a6c:	e398                	sd	a4,0(a5)
    6a6e:	a099                	j	6ab4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a70:	6398                	ld	a4,0(a5)
    6a72:	00e7e463          	bltu	a5,a4,6a7a <free+0x40>
    6a76:	00e6ea63          	bltu	a3,a4,6a8a <free+0x50>
{
    6a7a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a7c:	fed7fae3          	bgeu	a5,a3,6a70 <free+0x36>
    6a80:	6398                	ld	a4,0(a5)
    6a82:	00e6e463          	bltu	a3,a4,6a8a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a86:	fee7eae3          	bltu	a5,a4,6a7a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    6a8a:	ff852583          	lw	a1,-8(a0)
    6a8e:	6390                	ld	a2,0(a5)
    6a90:	02059713          	slli	a4,a1,0x20
    6a94:	9301                	srli	a4,a4,0x20
    6a96:	0712                	slli	a4,a4,0x4
    6a98:	9736                	add	a4,a4,a3
    6a9a:	fae60ae3          	beq	a2,a4,6a4e <free+0x14>
    bp->s.ptr = p->s.ptr;
    6a9e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6aa2:	4790                	lw	a2,8(a5)
    6aa4:	02061713          	slli	a4,a2,0x20
    6aa8:	9301                	srli	a4,a4,0x20
    6aaa:	0712                	slli	a4,a4,0x4
    6aac:	973e                	add	a4,a4,a5
    6aae:	fae689e3          	beq	a3,a4,6a60 <free+0x26>
  } else
    p->s.ptr = bp;
    6ab2:	e394                	sd	a3,0(a5)
  freep = p;
    6ab4:	00004717          	auipc	a4,0x4
    6ab8:	98f73e23          	sd	a5,-1636(a4) # a450 <freep>
}
    6abc:	6422                	ld	s0,8(sp)
    6abe:	0141                	addi	sp,sp,16
    6ac0:	8082                	ret

0000000000006ac2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6ac2:	7139                	addi	sp,sp,-64
    6ac4:	fc06                	sd	ra,56(sp)
    6ac6:	f822                	sd	s0,48(sp)
    6ac8:	f426                	sd	s1,40(sp)
    6aca:	f04a                	sd	s2,32(sp)
    6acc:	ec4e                	sd	s3,24(sp)
    6ace:	e852                	sd	s4,16(sp)
    6ad0:	e456                	sd	s5,8(sp)
    6ad2:	e05a                	sd	s6,0(sp)
    6ad4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6ad6:	02051493          	slli	s1,a0,0x20
    6ada:	9081                	srli	s1,s1,0x20
    6adc:	04bd                	addi	s1,s1,15
    6ade:	8091                	srli	s1,s1,0x4
    6ae0:	0014899b          	addiw	s3,s1,1
    6ae4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6ae6:	00004517          	auipc	a0,0x4
    6aea:	96a53503          	ld	a0,-1686(a0) # a450 <freep>
    6aee:	c515                	beqz	a0,6b1a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6af0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6af2:	4798                	lw	a4,8(a5)
    6af4:	02977f63          	bgeu	a4,s1,6b32 <malloc+0x70>
    6af8:	8a4e                	mv	s4,s3
    6afa:	0009871b          	sext.w	a4,s3
    6afe:	6685                	lui	a3,0x1
    6b00:	00d77363          	bgeu	a4,a3,6b06 <malloc+0x44>
    6b04:	6a05                	lui	s4,0x1
    6b06:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6b0a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6b0e:	00004917          	auipc	s2,0x4
    6b12:	94290913          	addi	s2,s2,-1726 # a450 <freep>
  if(p == (char*)-1)
    6b16:	5afd                	li	s5,-1
    6b18:	a88d                	j	6b8a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6b1a:	0000a797          	auipc	a5,0xa
    6b1e:	15e78793          	addi	a5,a5,350 # 10c78 <base>
    6b22:	00004717          	auipc	a4,0x4
    6b26:	92f73723          	sd	a5,-1746(a4) # a450 <freep>
    6b2a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6b2c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6b30:	b7e1                	j	6af8 <malloc+0x36>
      if(p->s.size == nunits)
    6b32:	02e48b63          	beq	s1,a4,6b68 <malloc+0xa6>
        p->s.size -= nunits;
    6b36:	4137073b          	subw	a4,a4,s3
    6b3a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6b3c:	1702                	slli	a4,a4,0x20
    6b3e:	9301                	srli	a4,a4,0x20
    6b40:	0712                	slli	a4,a4,0x4
    6b42:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6b44:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6b48:	00004717          	auipc	a4,0x4
    6b4c:	90a73423          	sd	a0,-1784(a4) # a450 <freep>
      return (void*)(p + 1);
    6b50:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6b54:	70e2                	ld	ra,56(sp)
    6b56:	7442                	ld	s0,48(sp)
    6b58:	74a2                	ld	s1,40(sp)
    6b5a:	7902                	ld	s2,32(sp)
    6b5c:	69e2                	ld	s3,24(sp)
    6b5e:	6a42                	ld	s4,16(sp)
    6b60:	6aa2                	ld	s5,8(sp)
    6b62:	6b02                	ld	s6,0(sp)
    6b64:	6121                	addi	sp,sp,64
    6b66:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6b68:	6398                	ld	a4,0(a5)
    6b6a:	e118                	sd	a4,0(a0)
    6b6c:	bff1                	j	6b48 <malloc+0x86>
  hp->s.size = nu;
    6b6e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6b72:	0541                	addi	a0,a0,16
    6b74:	00000097          	auipc	ra,0x0
    6b78:	ec6080e7          	jalr	-314(ra) # 6a3a <free>
  return freep;
    6b7c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6b80:	d971                	beqz	a0,6b54 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6b82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6b84:	4798                	lw	a4,8(a5)
    6b86:	fa9776e3          	bgeu	a4,s1,6b32 <malloc+0x70>
    if(p == freep)
    6b8a:	00093703          	ld	a4,0(s2)
    6b8e:	853e                	mv	a0,a5
    6b90:	fef719e3          	bne	a4,a5,6b82 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    6b94:	8552                	mv	a0,s4
    6b96:	00000097          	auipc	ra,0x0
    6b9a:	b6e080e7          	jalr	-1170(ra) # 6704 <sbrk>
  if(p == (char*)-1)
    6b9e:	fd5518e3          	bne	a0,s5,6b6e <malloc+0xac>
        return 0;
    6ba2:	4501                	li	a0,0
    6ba4:	bf45                	j	6b54 <malloc+0x92>
