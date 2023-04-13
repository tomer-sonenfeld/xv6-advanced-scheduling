
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
      14:	6cc080e7          	jalr	1740(ra) # 66dc <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	6ba080e7          	jalr	1722(ra) # 66dc <open>
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
      42:	bc250513          	addi	a0,a0,-1086 # 6c00 <malloc+0x106>
      46:	00007097          	auipc	ra,0x7
      4a:	9f6080e7          	jalr	-1546(ra) # 6a3c <printf>
      exit(1,"");
      4e:	00008597          	auipc	a1,0x8
      52:	1ea58593          	addi	a1,a1,490 # 8238 <malloc+0x173e>
      56:	4505                	li	a0,1
      58:	00006097          	auipc	ra,0x6
      5c:	644080e7          	jalr	1604(ra) # 669c <exit>

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
      8c:	b9850513          	addi	a0,a0,-1128 # 6c20 <malloc+0x126>
      90:	00007097          	auipc	ra,0x7
      94:	9ac080e7          	jalr	-1620(ra) # 6a3c <printf>
      exit(1,"");
      98:	00008597          	auipc	a1,0x8
      9c:	1a058593          	addi	a1,a1,416 # 8238 <malloc+0x173e>
      a0:	4505                	li	a0,1
      a2:	00006097          	auipc	ra,0x6
      a6:	5fa080e7          	jalr	1530(ra) # 669c <exit>

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
      bc:	b8050513          	addi	a0,a0,-1152 # 6c38 <malloc+0x13e>
      c0:	00006097          	auipc	ra,0x6
      c4:	61c080e7          	jalr	1564(ra) # 66dc <open>
  if(fd < 0){
      c8:	02054663          	bltz	a0,f4 <opentest+0x4a>
  close(fd);
      cc:	00006097          	auipc	ra,0x6
      d0:	5f8080e7          	jalr	1528(ra) # 66c4 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00007517          	auipc	a0,0x7
      da:	b8250513          	addi	a0,a0,-1150 # 6c58 <malloc+0x15e>
      de:	00006097          	auipc	ra,0x6
      e2:	5fe080e7          	jalr	1534(ra) # 66dc <open>
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
      fa:	b4a50513          	addi	a0,a0,-1206 # 6c40 <malloc+0x146>
      fe:	00007097          	auipc	ra,0x7
     102:	93e080e7          	jalr	-1730(ra) # 6a3c <printf>
    exit(1,"");
     106:	00008597          	auipc	a1,0x8
     10a:	13258593          	addi	a1,a1,306 # 8238 <malloc+0x173e>
     10e:	4505                	li	a0,1
     110:	00006097          	auipc	ra,0x6
     114:	58c080e7          	jalr	1420(ra) # 669c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     118:	85a6                	mv	a1,s1
     11a:	00007517          	auipc	a0,0x7
     11e:	b4e50513          	addi	a0,a0,-1202 # 6c68 <malloc+0x16e>
     122:	00007097          	auipc	ra,0x7
     126:	91a080e7          	jalr	-1766(ra) # 6a3c <printf>
    exit(1,"");
     12a:	00008597          	auipc	a1,0x8
     12e:	10e58593          	addi	a1,a1,270 # 8238 <malloc+0x173e>
     132:	4505                	li	a0,1
     134:	00006097          	auipc	ra,0x6
     138:	568080e7          	jalr	1384(ra) # 669c <exit>

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
     150:	b4450513          	addi	a0,a0,-1212 # 6c90 <malloc+0x196>
     154:	00006097          	auipc	ra,0x6
     158:	598080e7          	jalr	1432(ra) # 66ec <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     15c:	60100593          	li	a1,1537
     160:	00007517          	auipc	a0,0x7
     164:	b3050513          	addi	a0,a0,-1232 # 6c90 <malloc+0x196>
     168:	00006097          	auipc	ra,0x6
     16c:	574080e7          	jalr	1396(ra) # 66dc <open>
     170:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     172:	4611                	li	a2,4
     174:	00007597          	auipc	a1,0x7
     178:	b2c58593          	addi	a1,a1,-1236 # 6ca0 <malloc+0x1a6>
     17c:	00006097          	auipc	ra,0x6
     180:	540080e7          	jalr	1344(ra) # 66bc <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     184:	40100593          	li	a1,1025
     188:	00007517          	auipc	a0,0x7
     18c:	b0850513          	addi	a0,a0,-1272 # 6c90 <malloc+0x196>
     190:	00006097          	auipc	ra,0x6
     194:	54c080e7          	jalr	1356(ra) # 66dc <open>
     198:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     19a:	4605                	li	a2,1
     19c:	00007597          	auipc	a1,0x7
     1a0:	b0c58593          	addi	a1,a1,-1268 # 6ca8 <malloc+0x1ae>
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	516080e7          	jalr	1302(ra) # 66bc <write>
  if(n != -1){
     1ae:	57fd                	li	a5,-1
     1b0:	02f51b63          	bne	a0,a5,1e6 <truncate2+0xaa>
  unlink("truncfile");
     1b4:	00007517          	auipc	a0,0x7
     1b8:	adc50513          	addi	a0,a0,-1316 # 6c90 <malloc+0x196>
     1bc:	00006097          	auipc	ra,0x6
     1c0:	530080e7          	jalr	1328(ra) # 66ec <unlink>
  close(fd1);
     1c4:	8526                	mv	a0,s1
     1c6:	00006097          	auipc	ra,0x6
     1ca:	4fe080e7          	jalr	1278(ra) # 66c4 <close>
  close(fd2);
     1ce:	854a                	mv	a0,s2
     1d0:	00006097          	auipc	ra,0x6
     1d4:	4f4080e7          	jalr	1268(ra) # 66c4 <close>
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
     1ee:	ac650513          	addi	a0,a0,-1338 # 6cb0 <malloc+0x1b6>
     1f2:	00007097          	auipc	ra,0x7
     1f6:	84a080e7          	jalr	-1974(ra) # 6a3c <printf>
    exit(1,"");
     1fa:	00008597          	auipc	a1,0x8
     1fe:	03e58593          	addi	a1,a1,62 # 8238 <malloc+0x173e>
     202:	4505                	li	a0,1
     204:	00006097          	auipc	ra,0x6
     208:	498080e7          	jalr	1176(ra) # 669c <exit>

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
     23c:	4a4080e7          	jalr	1188(ra) # 66dc <open>
    close(fd);
     240:	00006097          	auipc	ra,0x6
     244:	484080e7          	jalr	1156(ra) # 66c4 <close>
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
     272:	47e080e7          	jalr	1150(ra) # 66ec <unlink>
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
     2a8:	a3450513          	addi	a0,a0,-1484 # 6cd8 <malloc+0x1de>
     2ac:	00006097          	auipc	ra,0x6
     2b0:	440080e7          	jalr	1088(ra) # 66ec <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	00007a97          	auipc	s5,0x7
     2bc:	a20a8a93          	addi	s5,s5,-1504 # 6cd8 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     2c0:	0000ea17          	auipc	s4,0xe
     2c4:	9b8a0a13          	addi	s4,s4,-1608 # dc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2c8:	6b0d                	lui	s6,0x3
     2ca:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrkarg+0x31>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ce:	20200593          	li	a1,514
     2d2:	8556                	mv	a0,s5
     2d4:	00006097          	auipc	ra,0x6
     2d8:	408080e7          	jalr	1032(ra) # 66dc <open>
     2dc:	892a                	mv	s2,a0
    if(fd < 0){
     2de:	04054d63          	bltz	a0,338 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2e2:	8626                	mv	a2,s1
     2e4:	85d2                	mv	a1,s4
     2e6:	00006097          	auipc	ra,0x6
     2ea:	3d6080e7          	jalr	982(ra) # 66bc <write>
     2ee:	89aa                	mv	s3,a0
      if(cc != sz){
     2f0:	06a49863          	bne	s1,a0,360 <bigwrite+0xd4>
      int cc = write(fd, buf, sz);
     2f4:	8626                	mv	a2,s1
     2f6:	85d2                	mv	a1,s4
     2f8:	854a                	mv	a0,s2
     2fa:	00006097          	auipc	ra,0x6
     2fe:	3c2080e7          	jalr	962(ra) # 66bc <write>
      if(cc != sz){
     302:	04951d63          	bne	a0,s1,35c <bigwrite+0xd0>
    close(fd);
     306:	854a                	mv	a0,s2
     308:	00006097          	auipc	ra,0x6
     30c:	3bc080e7          	jalr	956(ra) # 66c4 <close>
    unlink("bigwrite");
     310:	8556                	mv	a0,s5
     312:	00006097          	auipc	ra,0x6
     316:	3da080e7          	jalr	986(ra) # 66ec <unlink>
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
     33e:	9ae50513          	addi	a0,a0,-1618 # 6ce8 <malloc+0x1ee>
     342:	00006097          	auipc	ra,0x6
     346:	6fa080e7          	jalr	1786(ra) # 6a3c <printf>
      exit(1,"");
     34a:	00008597          	auipc	a1,0x8
     34e:	eee58593          	addi	a1,a1,-274 # 8238 <malloc+0x173e>
     352:	4505                	li	a0,1
     354:	00006097          	auipc	ra,0x6
     358:	348080e7          	jalr	840(ra) # 669c <exit>
     35c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     35e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     360:	86ce                	mv	a3,s3
     362:	8626                	mv	a2,s1
     364:	85de                	mv	a1,s7
     366:	00007517          	auipc	a0,0x7
     36a:	9a250513          	addi	a0,a0,-1630 # 6d08 <malloc+0x20e>
     36e:	00006097          	auipc	ra,0x6
     372:	6ce080e7          	jalr	1742(ra) # 6a3c <printf>
        exit(1,"");
     376:	00008597          	auipc	a1,0x8
     37a:	ec258593          	addi	a1,a1,-318 # 8238 <malloc+0x173e>
     37e:	4505                	li	a0,1
     380:	00006097          	auipc	ra,0x6
     384:	31c080e7          	jalr	796(ra) # 669c <exit>

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
     39c:	98850513          	addi	a0,a0,-1656 # 6d20 <malloc+0x226>
     3a0:	00006097          	auipc	ra,0x6
     3a4:	34c080e7          	jalr	844(ra) # 66ec <unlink>
     3a8:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ac:	00007997          	auipc	s3,0x7
     3b0:	97498993          	addi	s3,s3,-1676 # 6d20 <malloc+0x226>
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
     3c4:	31c080e7          	jalr	796(ra) # 66dc <open>
     3c8:	84aa                	mv	s1,a0
    if(fd < 0){
     3ca:	06054f63          	bltz	a0,448 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3ce:	4605                	li	a2,1
     3d0:	85d2                	mv	a1,s4
     3d2:	00006097          	auipc	ra,0x6
     3d6:	2ea080e7          	jalr	746(ra) # 66bc <write>
    close(fd);
     3da:	8526                	mv	a0,s1
     3dc:	00006097          	auipc	ra,0x6
     3e0:	2e8080e7          	jalr	744(ra) # 66c4 <close>
    unlink("junk");
     3e4:	854e                	mv	a0,s3
     3e6:	00006097          	auipc	ra,0x6
     3ea:	306080e7          	jalr	774(ra) # 66ec <unlink>
  for(int i = 0; i < assumed_free; i++){
     3ee:	397d                	addiw	s2,s2,-1
     3f0:	fc0915e3          	bnez	s2,3ba <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3f4:	20100593          	li	a1,513
     3f8:	00007517          	auipc	a0,0x7
     3fc:	92850513          	addi	a0,a0,-1752 # 6d20 <malloc+0x226>
     400:	00006097          	auipc	ra,0x6
     404:	2dc080e7          	jalr	732(ra) # 66dc <open>
     408:	84aa                	mv	s1,a0
  if(fd < 0){
     40a:	06054063          	bltz	a0,46a <badwrite+0xe2>
    printf("open junk failed\n");
    exit(1,"");
  }
  if(write(fd, "x", 1) != 1){
     40e:	4605                	li	a2,1
     410:	00007597          	auipc	a1,0x7
     414:	89858593          	addi	a1,a1,-1896 # 6ca8 <malloc+0x1ae>
     418:	00006097          	auipc	ra,0x6
     41c:	2a4080e7          	jalr	676(ra) # 66bc <write>
     420:	4785                	li	a5,1
     422:	06f50563          	beq	a0,a5,48c <badwrite+0x104>
    printf("write failed\n");
     426:	00007517          	auipc	a0,0x7
     42a:	91a50513          	addi	a0,a0,-1766 # 6d40 <malloc+0x246>
     42e:	00006097          	auipc	ra,0x6
     432:	60e080e7          	jalr	1550(ra) # 6a3c <printf>
    exit(1,"");
     436:	00008597          	auipc	a1,0x8
     43a:	e0258593          	addi	a1,a1,-510 # 8238 <malloc+0x173e>
     43e:	4505                	li	a0,1
     440:	00006097          	auipc	ra,0x6
     444:	25c080e7          	jalr	604(ra) # 669c <exit>
      printf("open junk failed\n");
     448:	00007517          	auipc	a0,0x7
     44c:	8e050513          	addi	a0,a0,-1824 # 6d28 <malloc+0x22e>
     450:	00006097          	auipc	ra,0x6
     454:	5ec080e7          	jalr	1516(ra) # 6a3c <printf>
      exit(1,"");
     458:	00008597          	auipc	a1,0x8
     45c:	de058593          	addi	a1,a1,-544 # 8238 <malloc+0x173e>
     460:	4505                	li	a0,1
     462:	00006097          	auipc	ra,0x6
     466:	23a080e7          	jalr	570(ra) # 669c <exit>
    printf("open junk failed\n");
     46a:	00007517          	auipc	a0,0x7
     46e:	8be50513          	addi	a0,a0,-1858 # 6d28 <malloc+0x22e>
     472:	00006097          	auipc	ra,0x6
     476:	5ca080e7          	jalr	1482(ra) # 6a3c <printf>
    exit(1,"");
     47a:	00008597          	auipc	a1,0x8
     47e:	dbe58593          	addi	a1,a1,-578 # 8238 <malloc+0x173e>
     482:	4505                	li	a0,1
     484:	00006097          	auipc	ra,0x6
     488:	218080e7          	jalr	536(ra) # 669c <exit>
  }
  close(fd);
     48c:	8526                	mv	a0,s1
     48e:	00006097          	auipc	ra,0x6
     492:	236080e7          	jalr	566(ra) # 66c4 <close>
  unlink("junk");
     496:	00007517          	auipc	a0,0x7
     49a:	88a50513          	addi	a0,a0,-1910 # 6d20 <malloc+0x226>
     49e:	00006097          	auipc	ra,0x6
     4a2:	24e080e7          	jalr	590(ra) # 66ec <unlink>

  exit(0,"");
     4a6:	00008597          	auipc	a1,0x8
     4aa:	d9258593          	addi	a1,a1,-622 # 8238 <malloc+0x173e>
     4ae:	4501                	li	a0,0
     4b0:	00006097          	auipc	ra,0x6
     4b4:	1ec080e7          	jalr	492(ra) # 669c <exit>

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
     508:	1e8080e7          	jalr	488(ra) # 66ec <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     50c:	60200593          	li	a1,1538
     510:	fb040513          	addi	a0,s0,-80
     514:	00006097          	auipc	ra,0x6
     518:	1c8080e7          	jalr	456(ra) # 66dc <open>
    if(fd < 0){
     51c:	00054963          	bltz	a0,52e <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     520:	00006097          	auipc	ra,0x6
     524:	1a4080e7          	jalr	420(ra) # 66c4 <close>
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
     570:	180080e7          	jalr	384(ra) # 66ec <unlink>
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
     5ae:	7a6a0a13          	addi	s4,s4,1958 # 6d50 <malloc+0x256>
    uint64 addr = addrs[ai];
     5b2:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5b6:	20100593          	li	a1,513
     5ba:	8552                	mv	a0,s4
     5bc:	00006097          	auipc	ra,0x6
     5c0:	120080e7          	jalr	288(ra) # 66dc <open>
     5c4:	84aa                	mv	s1,a0
    if(fd < 0){
     5c6:	08054863          	bltz	a0,656 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     5ca:	6609                	lui	a2,0x2
     5cc:	85ce                	mv	a1,s3
     5ce:	00006097          	auipc	ra,0x6
     5d2:	0ee080e7          	jalr	238(ra) # 66bc <write>
    if(n >= 0){
     5d6:	0a055163          	bgez	a0,678 <copyin+0xf0>
    close(fd);
     5da:	8526                	mv	a0,s1
     5dc:	00006097          	auipc	ra,0x6
     5e0:	0e8080e7          	jalr	232(ra) # 66c4 <close>
    unlink("copyin1");
     5e4:	8552                	mv	a0,s4
     5e6:	00006097          	auipc	ra,0x6
     5ea:	106080e7          	jalr	262(ra) # 66ec <unlink>
    n = write(1, (char*)addr, 8192);
     5ee:	6609                	lui	a2,0x2
     5f0:	85ce                	mv	a1,s3
     5f2:	4505                	li	a0,1
     5f4:	00006097          	auipc	ra,0x6
     5f8:	0c8080e7          	jalr	200(ra) # 66bc <write>
    if(n > 0){
     5fc:	0aa04163          	bgtz	a0,69e <copyin+0x116>
    if(pipe(fds) < 0){
     600:	fb840513          	addi	a0,s0,-72
     604:	00006097          	auipc	ra,0x6
     608:	0a8080e7          	jalr	168(ra) # 66ac <pipe>
     60c:	0a054c63          	bltz	a0,6c4 <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     610:	6609                	lui	a2,0x2
     612:	85ce                	mv	a1,s3
     614:	fbc42503          	lw	a0,-68(s0)
     618:	00006097          	auipc	ra,0x6
     61c:	0a4080e7          	jalr	164(ra) # 66bc <write>
    if(n > 0){
     620:	0ca04363          	bgtz	a0,6e6 <copyin+0x15e>
    close(fds[0]);
     624:	fb842503          	lw	a0,-72(s0)
     628:	00006097          	auipc	ra,0x6
     62c:	09c080e7          	jalr	156(ra) # 66c4 <close>
    close(fds[1]);
     630:	fbc42503          	lw	a0,-68(s0)
     634:	00006097          	auipc	ra,0x6
     638:	090080e7          	jalr	144(ra) # 66c4 <close>
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
     65a:	70250513          	addi	a0,a0,1794 # 6d58 <malloc+0x25e>
     65e:	00006097          	auipc	ra,0x6
     662:	3de080e7          	jalr	990(ra) # 6a3c <printf>
      exit(1,"");
     666:	00008597          	auipc	a1,0x8
     66a:	bd258593          	addi	a1,a1,-1070 # 8238 <malloc+0x173e>
     66e:	4505                	li	a0,1
     670:	00006097          	auipc	ra,0x6
     674:	02c080e7          	jalr	44(ra) # 669c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     678:	862a                	mv	a2,a0
     67a:	85ce                	mv	a1,s3
     67c:	00006517          	auipc	a0,0x6
     680:	6f450513          	addi	a0,a0,1780 # 6d70 <malloc+0x276>
     684:	00006097          	auipc	ra,0x6
     688:	3b8080e7          	jalr	952(ra) # 6a3c <printf>
      exit(1,"");
     68c:	00008597          	auipc	a1,0x8
     690:	bac58593          	addi	a1,a1,-1108 # 8238 <malloc+0x173e>
     694:	4505                	li	a0,1
     696:	00006097          	auipc	ra,0x6
     69a:	006080e7          	jalr	6(ra) # 669c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     69e:	862a                	mv	a2,a0
     6a0:	85ce                	mv	a1,s3
     6a2:	00006517          	auipc	a0,0x6
     6a6:	6fe50513          	addi	a0,a0,1790 # 6da0 <malloc+0x2a6>
     6aa:	00006097          	auipc	ra,0x6
     6ae:	392080e7          	jalr	914(ra) # 6a3c <printf>
      exit(1,"");
     6b2:	00008597          	auipc	a1,0x8
     6b6:	b8658593          	addi	a1,a1,-1146 # 8238 <malloc+0x173e>
     6ba:	4505                	li	a0,1
     6bc:	00006097          	auipc	ra,0x6
     6c0:	fe0080e7          	jalr	-32(ra) # 669c <exit>
      printf("pipe() failed\n");
     6c4:	00006517          	auipc	a0,0x6
     6c8:	70c50513          	addi	a0,a0,1804 # 6dd0 <malloc+0x2d6>
     6cc:	00006097          	auipc	ra,0x6
     6d0:	370080e7          	jalr	880(ra) # 6a3c <printf>
      exit(1,"");
     6d4:	00008597          	auipc	a1,0x8
     6d8:	b6458593          	addi	a1,a1,-1180 # 8238 <malloc+0x173e>
     6dc:	4505                	li	a0,1
     6de:	00006097          	auipc	ra,0x6
     6e2:	fbe080e7          	jalr	-66(ra) # 669c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00006517          	auipc	a0,0x6
     6ee:	6f650513          	addi	a0,a0,1782 # 6de0 <malloc+0x2e6>
     6f2:	00006097          	auipc	ra,0x6
     6f6:	34a080e7          	jalr	842(ra) # 6a3c <printf>
      exit(1,"");
     6fa:	00008597          	auipc	a1,0x8
     6fe:	b3e58593          	addi	a1,a1,-1218 # 8238 <malloc+0x173e>
     702:	4505                	li	a0,1
     704:	00006097          	auipc	ra,0x6
     708:	f98080e7          	jalr	-104(ra) # 669c <exit>

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
     734:	6e0a0a13          	addi	s4,s4,1760 # 6e10 <malloc+0x316>
    n = write(fds[1], "x", 1);
     738:	00006a97          	auipc	s5,0x6
     73c:	570a8a93          	addi	s5,s5,1392 # 6ca8 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     740:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     744:	4581                	li	a1,0
     746:	8552                	mv	a0,s4
     748:	00006097          	auipc	ra,0x6
     74c:	f94080e7          	jalr	-108(ra) # 66dc <open>
     750:	84aa                	mv	s1,a0
    if(fd < 0){
     752:	08054663          	bltz	a0,7de <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     756:	6609                	lui	a2,0x2
     758:	85ce                	mv	a1,s3
     75a:	00006097          	auipc	ra,0x6
     75e:	f5a080e7          	jalr	-166(ra) # 66b4 <read>
    if(n > 0){
     762:	08a04f63          	bgtz	a0,800 <copyout+0xf4>
    close(fd);
     766:	8526                	mv	a0,s1
     768:	00006097          	auipc	ra,0x6
     76c:	f5c080e7          	jalr	-164(ra) # 66c4 <close>
    if(pipe(fds) < 0){
     770:	fa840513          	addi	a0,s0,-88
     774:	00006097          	auipc	ra,0x6
     778:	f38080e7          	jalr	-200(ra) # 66ac <pipe>
     77c:	0a054563          	bltz	a0,826 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     780:	4605                	li	a2,1
     782:	85d6                	mv	a1,s5
     784:	fac42503          	lw	a0,-84(s0)
     788:	00006097          	auipc	ra,0x6
     78c:	f34080e7          	jalr	-204(ra) # 66bc <write>
    if(n != 1){
     790:	4785                	li	a5,1
     792:	0af51b63          	bne	a0,a5,848 <copyout+0x13c>
    n = read(fds[0], (void*)addr, 8192);
     796:	6609                	lui	a2,0x2
     798:	85ce                	mv	a1,s3
     79a:	fa842503          	lw	a0,-88(s0)
     79e:	00006097          	auipc	ra,0x6
     7a2:	f16080e7          	jalr	-234(ra) # 66b4 <read>
    if(n > 0){
     7a6:	0ca04263          	bgtz	a0,86a <copyout+0x15e>
    close(fds[0]);
     7aa:	fa842503          	lw	a0,-88(s0)
     7ae:	00006097          	auipc	ra,0x6
     7b2:	f16080e7          	jalr	-234(ra) # 66c4 <close>
    close(fds[1]);
     7b6:	fac42503          	lw	a0,-84(s0)
     7ba:	00006097          	auipc	ra,0x6
     7be:	f0a080e7          	jalr	-246(ra) # 66c4 <close>
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
     7e2:	63a50513          	addi	a0,a0,1594 # 6e18 <malloc+0x31e>
     7e6:	00006097          	auipc	ra,0x6
     7ea:	256080e7          	jalr	598(ra) # 6a3c <printf>
      exit(1,"");
     7ee:	00008597          	auipc	a1,0x8
     7f2:	a4a58593          	addi	a1,a1,-1462 # 8238 <malloc+0x173e>
     7f6:	4505                	li	a0,1
     7f8:	00006097          	auipc	ra,0x6
     7fc:	ea4080e7          	jalr	-348(ra) # 669c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     800:	862a                	mv	a2,a0
     802:	85ce                	mv	a1,s3
     804:	00006517          	auipc	a0,0x6
     808:	62c50513          	addi	a0,a0,1580 # 6e30 <malloc+0x336>
     80c:	00006097          	auipc	ra,0x6
     810:	230080e7          	jalr	560(ra) # 6a3c <printf>
      exit(1,"");
     814:	00008597          	auipc	a1,0x8
     818:	a2458593          	addi	a1,a1,-1500 # 8238 <malloc+0x173e>
     81c:	4505                	li	a0,1
     81e:	00006097          	auipc	ra,0x6
     822:	e7e080e7          	jalr	-386(ra) # 669c <exit>
      printf("pipe() failed\n");
     826:	00006517          	auipc	a0,0x6
     82a:	5aa50513          	addi	a0,a0,1450 # 6dd0 <malloc+0x2d6>
     82e:	00006097          	auipc	ra,0x6
     832:	20e080e7          	jalr	526(ra) # 6a3c <printf>
      exit(1,"");
     836:	00008597          	auipc	a1,0x8
     83a:	a0258593          	addi	a1,a1,-1534 # 8238 <malloc+0x173e>
     83e:	4505                	li	a0,1
     840:	00006097          	auipc	ra,0x6
     844:	e5c080e7          	jalr	-420(ra) # 669c <exit>
      printf("pipe write failed\n");
     848:	00006517          	auipc	a0,0x6
     84c:	61850513          	addi	a0,a0,1560 # 6e60 <malloc+0x366>
     850:	00006097          	auipc	ra,0x6
     854:	1ec080e7          	jalr	492(ra) # 6a3c <printf>
      exit(1,"");
     858:	00008597          	auipc	a1,0x8
     85c:	9e058593          	addi	a1,a1,-1568 # 8238 <malloc+0x173e>
     860:	4505                	li	a0,1
     862:	00006097          	auipc	ra,0x6
     866:	e3a080e7          	jalr	-454(ra) # 669c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     86a:	862a                	mv	a2,a0
     86c:	85ce                	mv	a1,s3
     86e:	00006517          	auipc	a0,0x6
     872:	60a50513          	addi	a0,a0,1546 # 6e78 <malloc+0x37e>
     876:	00006097          	auipc	ra,0x6
     87a:	1c6080e7          	jalr	454(ra) # 6a3c <printf>
      exit(1,"");
     87e:	00008597          	auipc	a1,0x8
     882:	9ba58593          	addi	a1,a1,-1606 # 8238 <malloc+0x173e>
     886:	4505                	li	a0,1
     888:	00006097          	auipc	ra,0x6
     88c:	e14080e7          	jalr	-492(ra) # 669c <exit>

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
     8a8:	3ec50513          	addi	a0,a0,1004 # 6c90 <malloc+0x196>
     8ac:	00006097          	auipc	ra,0x6
     8b0:	e40080e7          	jalr	-448(ra) # 66ec <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     8b4:	60100593          	li	a1,1537
     8b8:	00006517          	auipc	a0,0x6
     8bc:	3d850513          	addi	a0,a0,984 # 6c90 <malloc+0x196>
     8c0:	00006097          	auipc	ra,0x6
     8c4:	e1c080e7          	jalr	-484(ra) # 66dc <open>
     8c8:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     8ca:	4611                	li	a2,4
     8cc:	00006597          	auipc	a1,0x6
     8d0:	3d458593          	addi	a1,a1,980 # 6ca0 <malloc+0x1a6>
     8d4:	00006097          	auipc	ra,0x6
     8d8:	de8080e7          	jalr	-536(ra) # 66bc <write>
  close(fd1);
     8dc:	8526                	mv	a0,s1
     8de:	00006097          	auipc	ra,0x6
     8e2:	de6080e7          	jalr	-538(ra) # 66c4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     8e6:	4581                	li	a1,0
     8e8:	00006517          	auipc	a0,0x6
     8ec:	3a850513          	addi	a0,a0,936 # 6c90 <malloc+0x196>
     8f0:	00006097          	auipc	ra,0x6
     8f4:	dec080e7          	jalr	-532(ra) # 66dc <open>
     8f8:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	addi	a1,s0,-96
     902:	00006097          	auipc	ra,0x6
     906:	db2080e7          	jalr	-590(ra) # 66b4 <read>
  if(n != 4){
     90a:	4791                	li	a5,4
     90c:	0cf51e63          	bne	a0,a5,9e8 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     910:	40100593          	li	a1,1025
     914:	00006517          	auipc	a0,0x6
     918:	37c50513          	addi	a0,a0,892 # 6c90 <malloc+0x196>
     91c:	00006097          	auipc	ra,0x6
     920:	dc0080e7          	jalr	-576(ra) # 66dc <open>
     924:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     926:	4581                	li	a1,0
     928:	00006517          	auipc	a0,0x6
     92c:	36850513          	addi	a0,a0,872 # 6c90 <malloc+0x196>
     930:	00006097          	auipc	ra,0x6
     934:	dac080e7          	jalr	-596(ra) # 66dc <open>
     938:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     93a:	02000613          	li	a2,32
     93e:	fa040593          	addi	a1,s0,-96
     942:	00006097          	auipc	ra,0x6
     946:	d72080e7          	jalr	-654(ra) # 66b4 <read>
     94a:	8a2a                	mv	s4,a0
  if(n != 0){
     94c:	e169                	bnez	a0,a0e <truncate1+0x17e>
  n = read(fd2, buf, sizeof(buf));
     94e:	02000613          	li	a2,32
     952:	fa040593          	addi	a1,s0,-96
     956:	8526                	mv	a0,s1
     958:	00006097          	auipc	ra,0x6
     95c:	d5c080e7          	jalr	-676(ra) # 66b4 <read>
     960:	8a2a                	mv	s4,a0
  if(n != 0){
     962:	e175                	bnez	a0,a46 <truncate1+0x1b6>
  write(fd1, "abcdef", 6);
     964:	4619                	li	a2,6
     966:	00006597          	auipc	a1,0x6
     96a:	5a258593          	addi	a1,a1,1442 # 6f08 <malloc+0x40e>
     96e:	854e                	mv	a0,s3
     970:	00006097          	auipc	ra,0x6
     974:	d4c080e7          	jalr	-692(ra) # 66bc <write>
  n = read(fd3, buf, sizeof(buf));
     978:	02000613          	li	a2,32
     97c:	fa040593          	addi	a1,s0,-96
     980:	854a                	mv	a0,s2
     982:	00006097          	auipc	ra,0x6
     986:	d32080e7          	jalr	-718(ra) # 66b4 <read>
  if(n != 6){
     98a:	4799                	li	a5,6
     98c:	0ef51963          	bne	a0,a5,a7e <truncate1+0x1ee>
  n = read(fd2, buf, sizeof(buf));
     990:	02000613          	li	a2,32
     994:	fa040593          	addi	a1,s0,-96
     998:	8526                	mv	a0,s1
     99a:	00006097          	auipc	ra,0x6
     99e:	d1a080e7          	jalr	-742(ra) # 66b4 <read>
  if(n != 2){
     9a2:	4789                	li	a5,2
     9a4:	10f51063          	bne	a0,a5,aa4 <truncate1+0x214>
  unlink("truncfile");
     9a8:	00006517          	auipc	a0,0x6
     9ac:	2e850513          	addi	a0,a0,744 # 6c90 <malloc+0x196>
     9b0:	00006097          	auipc	ra,0x6
     9b4:	d3c080e7          	jalr	-708(ra) # 66ec <unlink>
  close(fd1);
     9b8:	854e                	mv	a0,s3
     9ba:	00006097          	auipc	ra,0x6
     9be:	d0a080e7          	jalr	-758(ra) # 66c4 <close>
  close(fd2);
     9c2:	8526                	mv	a0,s1
     9c4:	00006097          	auipc	ra,0x6
     9c8:	d00080e7          	jalr	-768(ra) # 66c4 <close>
  close(fd3);
     9cc:	854a                	mv	a0,s2
     9ce:	00006097          	auipc	ra,0x6
     9d2:	cf6080e7          	jalr	-778(ra) # 66c4 <close>
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
     9f0:	4bc50513          	addi	a0,a0,1212 # 6ea8 <malloc+0x3ae>
     9f4:	00006097          	auipc	ra,0x6
     9f8:	048080e7          	jalr	72(ra) # 6a3c <printf>
    exit(1,"");
     9fc:	00008597          	auipc	a1,0x8
     a00:	83c58593          	addi	a1,a1,-1988 # 8238 <malloc+0x173e>
     a04:	4505                	li	a0,1
     a06:	00006097          	auipc	ra,0x6
     a0a:	c96080e7          	jalr	-874(ra) # 669c <exit>
    printf("aaa fd3=%d\n", fd3);
     a0e:	85ca                	mv	a1,s2
     a10:	00006517          	auipc	a0,0x6
     a14:	4b850513          	addi	a0,a0,1208 # 6ec8 <malloc+0x3ce>
     a18:	00006097          	auipc	ra,0x6
     a1c:	024080e7          	jalr	36(ra) # 6a3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a20:	8652                	mv	a2,s4
     a22:	85d6                	mv	a1,s5
     a24:	00006517          	auipc	a0,0x6
     a28:	4b450513          	addi	a0,a0,1204 # 6ed8 <malloc+0x3de>
     a2c:	00006097          	auipc	ra,0x6
     a30:	010080e7          	jalr	16(ra) # 6a3c <printf>
    exit(1,"");
     a34:	00008597          	auipc	a1,0x8
     a38:	80458593          	addi	a1,a1,-2044 # 8238 <malloc+0x173e>
     a3c:	4505                	li	a0,1
     a3e:	00006097          	auipc	ra,0x6
     a42:	c5e080e7          	jalr	-930(ra) # 669c <exit>
    printf("bbb fd2=%d\n", fd2);
     a46:	85a6                	mv	a1,s1
     a48:	00006517          	auipc	a0,0x6
     a4c:	4b050513          	addi	a0,a0,1200 # 6ef8 <malloc+0x3fe>
     a50:	00006097          	auipc	ra,0x6
     a54:	fec080e7          	jalr	-20(ra) # 6a3c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a58:	8652                	mv	a2,s4
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	47c50513          	addi	a0,a0,1148 # 6ed8 <malloc+0x3de>
     a64:	00006097          	auipc	ra,0x6
     a68:	fd8080e7          	jalr	-40(ra) # 6a3c <printf>
    exit(1,"");
     a6c:	00007597          	auipc	a1,0x7
     a70:	7cc58593          	addi	a1,a1,1996 # 8238 <malloc+0x173e>
     a74:	4505                	li	a0,1
     a76:	00006097          	auipc	ra,0x6
     a7a:	c26080e7          	jalr	-986(ra) # 669c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a7e:	862a                	mv	a2,a0
     a80:	85d6                	mv	a1,s5
     a82:	00006517          	auipc	a0,0x6
     a86:	48e50513          	addi	a0,a0,1166 # 6f10 <malloc+0x416>
     a8a:	00006097          	auipc	ra,0x6
     a8e:	fb2080e7          	jalr	-78(ra) # 6a3c <printf>
    exit(1,"");
     a92:	00007597          	auipc	a1,0x7
     a96:	7a658593          	addi	a1,a1,1958 # 8238 <malloc+0x173e>
     a9a:	4505                	li	a0,1
     a9c:	00006097          	auipc	ra,0x6
     aa0:	c00080e7          	jalr	-1024(ra) # 669c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     aa4:	862a                	mv	a2,a0
     aa6:	85d6                	mv	a1,s5
     aa8:	00006517          	auipc	a0,0x6
     aac:	48850513          	addi	a0,a0,1160 # 6f30 <malloc+0x436>
     ab0:	00006097          	auipc	ra,0x6
     ab4:	f8c080e7          	jalr	-116(ra) # 6a3c <printf>
    exit(1,"");
     ab8:	00007597          	auipc	a1,0x7
     abc:	78058593          	addi	a1,a1,1920 # 8238 <malloc+0x173e>
     ac0:	4505                	li	a0,1
     ac2:	00006097          	auipc	ra,0x6
     ac6:	bda080e7          	jalr	-1062(ra) # 669c <exit>

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
     ae8:	46c50513          	addi	a0,a0,1132 # 6f50 <malloc+0x456>
     aec:	00006097          	auipc	ra,0x6
     af0:	bf0080e7          	jalr	-1040(ra) # 66dc <open>
  if(fd < 0){
     af4:	0a054d63          	bltz	a0,bae <writetest+0xe4>
     af8:	892a                	mv	s2,a0
     afa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     afc:	00006997          	auipc	s3,0x6
     b00:	47c98993          	addi	s3,s3,1148 # 6f78 <malloc+0x47e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b04:	00006a97          	auipc	s5,0x6
     b08:	4aca8a93          	addi	s5,s5,1196 # 6fb0 <malloc+0x4b6>
  for(i = 0; i < N; i++){
     b0c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b10:	4629                	li	a2,10
     b12:	85ce                	mv	a1,s3
     b14:	854a                	mv	a0,s2
     b16:	00006097          	auipc	ra,0x6
     b1a:	ba6080e7          	jalr	-1114(ra) # 66bc <write>
     b1e:	47a9                	li	a5,10
     b20:	0af51963          	bne	a0,a5,bd2 <writetest+0x108>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b24:	4629                	li	a2,10
     b26:	85d6                	mv	a1,s5
     b28:	854a                	mv	a0,s2
     b2a:	00006097          	auipc	ra,0x6
     b2e:	b92080e7          	jalr	-1134(ra) # 66bc <write>
     b32:	47a9                	li	a5,10
     b34:	0cf51263          	bne	a0,a5,bf8 <writetest+0x12e>
  for(i = 0; i < N; i++){
     b38:	2485                	addiw	s1,s1,1
     b3a:	fd449be3          	bne	s1,s4,b10 <writetest+0x46>
  close(fd);
     b3e:	854a                	mv	a0,s2
     b40:	00006097          	auipc	ra,0x6
     b44:	b84080e7          	jalr	-1148(ra) # 66c4 <close>
  fd = open("small", O_RDONLY);
     b48:	4581                	li	a1,0
     b4a:	00006517          	auipc	a0,0x6
     b4e:	40650513          	addi	a0,a0,1030 # 6f50 <malloc+0x456>
     b52:	00006097          	auipc	ra,0x6
     b56:	b8a080e7          	jalr	-1142(ra) # 66dc <open>
     b5a:	84aa                	mv	s1,a0
  if(fd < 0){
     b5c:	0c054163          	bltz	a0,c1e <writetest+0x154>
  i = read(fd, buf, N*SZ*2);
     b60:	7d000613          	li	a2,2000
     b64:	0000d597          	auipc	a1,0xd
     b68:	11458593          	addi	a1,a1,276 # dc78 <buf>
     b6c:	00006097          	auipc	ra,0x6
     b70:	b48080e7          	jalr	-1208(ra) # 66b4 <read>
  if(i != N*SZ*2){
     b74:	7d000793          	li	a5,2000
     b78:	0cf51563          	bne	a0,a5,c42 <writetest+0x178>
  close(fd);
     b7c:	8526                	mv	a0,s1
     b7e:	00006097          	auipc	ra,0x6
     b82:	b46080e7          	jalr	-1210(ra) # 66c4 <close>
  if(unlink("small") < 0){
     b86:	00006517          	auipc	a0,0x6
     b8a:	3ca50513          	addi	a0,a0,970 # 6f50 <malloc+0x456>
     b8e:	00006097          	auipc	ra,0x6
     b92:	b5e080e7          	jalr	-1186(ra) # 66ec <unlink>
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
     bb4:	3a850513          	addi	a0,a0,936 # 6f58 <malloc+0x45e>
     bb8:	00006097          	auipc	ra,0x6
     bbc:	e84080e7          	jalr	-380(ra) # 6a3c <printf>
    exit(1,"");
     bc0:	00007597          	auipc	a1,0x7
     bc4:	67858593          	addi	a1,a1,1656 # 8238 <malloc+0x173e>
     bc8:	4505                	li	a0,1
     bca:	00006097          	auipc	ra,0x6
     bce:	ad2080e7          	jalr	-1326(ra) # 669c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     bd2:	8626                	mv	a2,s1
     bd4:	85da                	mv	a1,s6
     bd6:	00006517          	auipc	a0,0x6
     bda:	3b250513          	addi	a0,a0,946 # 6f88 <malloc+0x48e>
     bde:	00006097          	auipc	ra,0x6
     be2:	e5e080e7          	jalr	-418(ra) # 6a3c <printf>
      exit(1,"");
     be6:	00007597          	auipc	a1,0x7
     bea:	65258593          	addi	a1,a1,1618 # 8238 <malloc+0x173e>
     bee:	4505                	li	a0,1
     bf0:	00006097          	auipc	ra,0x6
     bf4:	aac080e7          	jalr	-1364(ra) # 669c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     bf8:	8626                	mv	a2,s1
     bfa:	85da                	mv	a1,s6
     bfc:	00006517          	auipc	a0,0x6
     c00:	3c450513          	addi	a0,a0,964 # 6fc0 <malloc+0x4c6>
     c04:	00006097          	auipc	ra,0x6
     c08:	e38080e7          	jalr	-456(ra) # 6a3c <printf>
      exit(1,"");
     c0c:	00007597          	auipc	a1,0x7
     c10:	62c58593          	addi	a1,a1,1580 # 8238 <malloc+0x173e>
     c14:	4505                	li	a0,1
     c16:	00006097          	auipc	ra,0x6
     c1a:	a86080e7          	jalr	-1402(ra) # 669c <exit>
    printf("%s: error: open small failed!\n", s);
     c1e:	85da                	mv	a1,s6
     c20:	00006517          	auipc	a0,0x6
     c24:	3c850513          	addi	a0,a0,968 # 6fe8 <malloc+0x4ee>
     c28:	00006097          	auipc	ra,0x6
     c2c:	e14080e7          	jalr	-492(ra) # 6a3c <printf>
    exit(1,"");
     c30:	00007597          	auipc	a1,0x7
     c34:	60858593          	addi	a1,a1,1544 # 8238 <malloc+0x173e>
     c38:	4505                	li	a0,1
     c3a:	00006097          	auipc	ra,0x6
     c3e:	a62080e7          	jalr	-1438(ra) # 669c <exit>
    printf("%s: read failed\n", s);
     c42:	85da                	mv	a1,s6
     c44:	00006517          	auipc	a0,0x6
     c48:	3c450513          	addi	a0,a0,964 # 7008 <malloc+0x50e>
     c4c:	00006097          	auipc	ra,0x6
     c50:	df0080e7          	jalr	-528(ra) # 6a3c <printf>
    exit(1,"");
     c54:	00007597          	auipc	a1,0x7
     c58:	5e458593          	addi	a1,a1,1508 # 8238 <malloc+0x173e>
     c5c:	4505                	li	a0,1
     c5e:	00006097          	auipc	ra,0x6
     c62:	a3e080e7          	jalr	-1474(ra) # 669c <exit>
    printf("%s: unlink small failed\n", s);
     c66:	85da                	mv	a1,s6
     c68:	00006517          	auipc	a0,0x6
     c6c:	3b850513          	addi	a0,a0,952 # 7020 <malloc+0x526>
     c70:	00006097          	auipc	ra,0x6
     c74:	dcc080e7          	jalr	-564(ra) # 6a3c <printf>
    exit(1,"");
     c78:	00007597          	auipc	a1,0x7
     c7c:	5c058593          	addi	a1,a1,1472 # 8238 <malloc+0x173e>
     c80:	4505                	li	a0,1
     c82:	00006097          	auipc	ra,0x6
     c86:	a1a080e7          	jalr	-1510(ra) # 669c <exit>

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
     ca6:	39e50513          	addi	a0,a0,926 # 7040 <malloc+0x546>
     caa:	00006097          	auipc	ra,0x6
     cae:	a32080e7          	jalr	-1486(ra) # 66dc <open>
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
     cd6:	9ea080e7          	jalr	-1558(ra) # 66bc <write>
     cda:	40000793          	li	a5,1024
     cde:	08f51063          	bne	a0,a5,d5e <writebig+0xd4>
  for(i = 0; i < MAXFILE; i++){
     ce2:	2485                	addiw	s1,s1,1
     ce4:	ff4491e3          	bne	s1,s4,cc6 <writebig+0x3c>
  close(fd);
     ce8:	854e                	mv	a0,s3
     cea:	00006097          	auipc	ra,0x6
     cee:	9da080e7          	jalr	-1574(ra) # 66c4 <close>
  fd = open("big", O_RDONLY);
     cf2:	4581                	li	a1,0
     cf4:	00006517          	auipc	a0,0x6
     cf8:	34c50513          	addi	a0,a0,844 # 7040 <malloc+0x546>
     cfc:	00006097          	auipc	ra,0x6
     d00:	9e0080e7          	jalr	-1568(ra) # 66dc <open>
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
     d20:	998080e7          	jalr	-1640(ra) # 66b4 <read>
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
     d40:	30c50513          	addi	a0,a0,780 # 7048 <malloc+0x54e>
     d44:	00006097          	auipc	ra,0x6
     d48:	cf8080e7          	jalr	-776(ra) # 6a3c <printf>
    exit(1,"");
     d4c:	00007597          	auipc	a1,0x7
     d50:	4ec58593          	addi	a1,a1,1260 # 8238 <malloc+0x173e>
     d54:	4505                	li	a0,1
     d56:	00006097          	auipc	ra,0x6
     d5a:	946080e7          	jalr	-1722(ra) # 669c <exit>
      printf("%s: error: write big file failed\n", s, i);
     d5e:	8626                	mv	a2,s1
     d60:	85d6                	mv	a1,s5
     d62:	00006517          	auipc	a0,0x6
     d66:	30650513          	addi	a0,a0,774 # 7068 <malloc+0x56e>
     d6a:	00006097          	auipc	ra,0x6
     d6e:	cd2080e7          	jalr	-814(ra) # 6a3c <printf>
      exit(1,"");
     d72:	00007597          	auipc	a1,0x7
     d76:	4c658593          	addi	a1,a1,1222 # 8238 <malloc+0x173e>
     d7a:	4505                	li	a0,1
     d7c:	00006097          	auipc	ra,0x6
     d80:	920080e7          	jalr	-1760(ra) # 669c <exit>
    printf("%s: error: open big failed!\n", s);
     d84:	85d6                	mv	a1,s5
     d86:	00006517          	auipc	a0,0x6
     d8a:	30a50513          	addi	a0,a0,778 # 7090 <malloc+0x596>
     d8e:	00006097          	auipc	ra,0x6
     d92:	cae080e7          	jalr	-850(ra) # 6a3c <printf>
    exit(1,"");
     d96:	00007597          	auipc	a1,0x7
     d9a:	4a258593          	addi	a1,a1,1186 # 8238 <malloc+0x173e>
     d9e:	4505                	li	a0,1
     da0:	00006097          	auipc	ra,0x6
     da4:	8fc080e7          	jalr	-1796(ra) # 669c <exit>
      if(n == MAXFILE - 1){
     da8:	10b00793          	li	a5,267
     dac:	02f48a63          	beq	s1,a5,de0 <writebig+0x156>
  close(fd);
     db0:	854e                	mv	a0,s3
     db2:	00006097          	auipc	ra,0x6
     db6:	912080e7          	jalr	-1774(ra) # 66c4 <close>
  if(unlink("big") < 0){
     dba:	00006517          	auipc	a0,0x6
     dbe:	28650513          	addi	a0,a0,646 # 7040 <malloc+0x546>
     dc2:	00006097          	auipc	ra,0x6
     dc6:	92a080e7          	jalr	-1750(ra) # 66ec <unlink>
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
     dea:	2ca50513          	addi	a0,a0,714 # 70b0 <malloc+0x5b6>
     dee:	00006097          	auipc	ra,0x6
     df2:	c4e080e7          	jalr	-946(ra) # 6a3c <printf>
        exit(1,"");
     df6:	00007597          	auipc	a1,0x7
     dfa:	44258593          	addi	a1,a1,1090 # 8238 <malloc+0x173e>
     dfe:	4505                	li	a0,1
     e00:	00006097          	auipc	ra,0x6
     e04:	89c080e7          	jalr	-1892(ra) # 669c <exit>
      printf("%s: read failed %d\n", s, i);
     e08:	862a                	mv	a2,a0
     e0a:	85d6                	mv	a1,s5
     e0c:	00006517          	auipc	a0,0x6
     e10:	2cc50513          	addi	a0,a0,716 # 70d8 <malloc+0x5de>
     e14:	00006097          	auipc	ra,0x6
     e18:	c28080e7          	jalr	-984(ra) # 6a3c <printf>
      exit(1,"");
     e1c:	00007597          	auipc	a1,0x7
     e20:	41c58593          	addi	a1,a1,1052 # 8238 <malloc+0x173e>
     e24:	4505                	li	a0,1
     e26:	00006097          	auipc	ra,0x6
     e2a:	876080e7          	jalr	-1930(ra) # 669c <exit>
      printf("%s: read content of block %d is %d\n", s,
     e2e:	8626                	mv	a2,s1
     e30:	85d6                	mv	a1,s5
     e32:	00006517          	auipc	a0,0x6
     e36:	2be50513          	addi	a0,a0,702 # 70f0 <malloc+0x5f6>
     e3a:	00006097          	auipc	ra,0x6
     e3e:	c02080e7          	jalr	-1022(ra) # 6a3c <printf>
      exit(1,"");
     e42:	00007597          	auipc	a1,0x7
     e46:	3f658593          	addi	a1,a1,1014 # 8238 <malloc+0x173e>
     e4a:	4505                	li	a0,1
     e4c:	00006097          	auipc	ra,0x6
     e50:	850080e7          	jalr	-1968(ra) # 669c <exit>
    printf("%s: unlink big failed\n", s);
     e54:	85d6                	mv	a1,s5
     e56:	00006517          	auipc	a0,0x6
     e5a:	2c250513          	addi	a0,a0,706 # 7118 <malloc+0x61e>
     e5e:	00006097          	auipc	ra,0x6
     e62:	bde080e7          	jalr	-1058(ra) # 6a3c <printf>
    exit(1,"");
     e66:	00007597          	auipc	a1,0x7
     e6a:	3d258593          	addi	a1,a1,978 # 8238 <malloc+0x173e>
     e6e:	4505                	li	a0,1
     e70:	00006097          	auipc	ra,0x6
     e74:	82c080e7          	jalr	-2004(ra) # 669c <exit>

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
     e90:	2a450513          	addi	a0,a0,676 # 7130 <malloc+0x636>
     e94:	00006097          	auipc	ra,0x6
     e98:	848080e7          	jalr	-1976(ra) # 66dc <open>
  if(fd < 0){
     e9c:	0e054563          	bltz	a0,f86 <unlinkread+0x10e>
     ea0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ea2:	4615                	li	a2,5
     ea4:	00006597          	auipc	a1,0x6
     ea8:	2bc58593          	addi	a1,a1,700 # 7160 <malloc+0x666>
     eac:	00006097          	auipc	ra,0x6
     eb0:	810080e7          	jalr	-2032(ra) # 66bc <write>
  close(fd);
     eb4:	8526                	mv	a0,s1
     eb6:	00006097          	auipc	ra,0x6
     eba:	80e080e7          	jalr	-2034(ra) # 66c4 <close>
  fd = open("unlinkread", O_RDWR);
     ebe:	4589                	li	a1,2
     ec0:	00006517          	auipc	a0,0x6
     ec4:	27050513          	addi	a0,a0,624 # 7130 <malloc+0x636>
     ec8:	00006097          	auipc	ra,0x6
     ecc:	814080e7          	jalr	-2028(ra) # 66dc <open>
     ed0:	84aa                	mv	s1,a0
  if(fd < 0){
     ed2:	0c054c63          	bltz	a0,faa <unlinkread+0x132>
  if(unlink("unlinkread") != 0){
     ed6:	00006517          	auipc	a0,0x6
     eda:	25a50513          	addi	a0,a0,602 # 7130 <malloc+0x636>
     ede:	00006097          	auipc	ra,0x6
     ee2:	80e080e7          	jalr	-2034(ra) # 66ec <unlink>
     ee6:	e565                	bnez	a0,fce <unlinkread+0x156>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     ee8:	20200593          	li	a1,514
     eec:	00006517          	auipc	a0,0x6
     ef0:	24450513          	addi	a0,a0,580 # 7130 <malloc+0x636>
     ef4:	00005097          	auipc	ra,0x5
     ef8:	7e8080e7          	jalr	2024(ra) # 66dc <open>
     efc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     efe:	460d                	li	a2,3
     f00:	00006597          	auipc	a1,0x6
     f04:	2a858593          	addi	a1,a1,680 # 71a8 <malloc+0x6ae>
     f08:	00005097          	auipc	ra,0x5
     f0c:	7b4080e7          	jalr	1972(ra) # 66bc <write>
  close(fd1);
     f10:	854a                	mv	a0,s2
     f12:	00005097          	auipc	ra,0x5
     f16:	7b2080e7          	jalr	1970(ra) # 66c4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     f1a:	660d                	lui	a2,0x3
     f1c:	0000d597          	auipc	a1,0xd
     f20:	d5c58593          	addi	a1,a1,-676 # dc78 <buf>
     f24:	8526                	mv	a0,s1
     f26:	00005097          	auipc	ra,0x5
     f2a:	78e080e7          	jalr	1934(ra) # 66b4 <read>
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
     f54:	76c080e7          	jalr	1900(ra) # 66bc <write>
     f58:	47a9                	li	a5,10
     f5a:	0ef51063          	bne	a0,a5,103a <unlinkread+0x1c2>
  close(fd);
     f5e:	8526                	mv	a0,s1
     f60:	00005097          	auipc	ra,0x5
     f64:	764080e7          	jalr	1892(ra) # 66c4 <close>
  unlink("unlinkread");
     f68:	00006517          	auipc	a0,0x6
     f6c:	1c850513          	addi	a0,a0,456 # 7130 <malloc+0x636>
     f70:	00005097          	auipc	ra,0x5
     f74:	77c080e7          	jalr	1916(ra) # 66ec <unlink>
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
     f8c:	1b850513          	addi	a0,a0,440 # 7140 <malloc+0x646>
     f90:	00006097          	auipc	ra,0x6
     f94:	aac080e7          	jalr	-1364(ra) # 6a3c <printf>
    exit(1,"");
     f98:	00007597          	auipc	a1,0x7
     f9c:	2a058593          	addi	a1,a1,672 # 8238 <malloc+0x173e>
     fa0:	4505                	li	a0,1
     fa2:	00005097          	auipc	ra,0x5
     fa6:	6fa080e7          	jalr	1786(ra) # 669c <exit>
    printf("%s: open unlinkread failed\n", s);
     faa:	85ce                	mv	a1,s3
     fac:	00006517          	auipc	a0,0x6
     fb0:	1bc50513          	addi	a0,a0,444 # 7168 <malloc+0x66e>
     fb4:	00006097          	auipc	ra,0x6
     fb8:	a88080e7          	jalr	-1400(ra) # 6a3c <printf>
    exit(1,"");
     fbc:	00007597          	auipc	a1,0x7
     fc0:	27c58593          	addi	a1,a1,636 # 8238 <malloc+0x173e>
     fc4:	4505                	li	a0,1
     fc6:	00005097          	auipc	ra,0x5
     fca:	6d6080e7          	jalr	1750(ra) # 669c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     fce:	85ce                	mv	a1,s3
     fd0:	00006517          	auipc	a0,0x6
     fd4:	1b850513          	addi	a0,a0,440 # 7188 <malloc+0x68e>
     fd8:	00006097          	auipc	ra,0x6
     fdc:	a64080e7          	jalr	-1436(ra) # 6a3c <printf>
    exit(1,"");
     fe0:	00007597          	auipc	a1,0x7
     fe4:	25858593          	addi	a1,a1,600 # 8238 <malloc+0x173e>
     fe8:	4505                	li	a0,1
     fea:	00005097          	auipc	ra,0x5
     fee:	6b2080e7          	jalr	1714(ra) # 669c <exit>
    printf("%s: unlinkread read failed", s);
     ff2:	85ce                	mv	a1,s3
     ff4:	00006517          	auipc	a0,0x6
     ff8:	1bc50513          	addi	a0,a0,444 # 71b0 <malloc+0x6b6>
     ffc:	00006097          	auipc	ra,0x6
    1000:	a40080e7          	jalr	-1472(ra) # 6a3c <printf>
    exit(1,"");
    1004:	00007597          	auipc	a1,0x7
    1008:	23458593          	addi	a1,a1,564 # 8238 <malloc+0x173e>
    100c:	4505                	li	a0,1
    100e:	00005097          	auipc	ra,0x5
    1012:	68e080e7          	jalr	1678(ra) # 669c <exit>
    printf("%s: unlinkread wrong data\n", s);
    1016:	85ce                	mv	a1,s3
    1018:	00006517          	auipc	a0,0x6
    101c:	1b850513          	addi	a0,a0,440 # 71d0 <malloc+0x6d6>
    1020:	00006097          	auipc	ra,0x6
    1024:	a1c080e7          	jalr	-1508(ra) # 6a3c <printf>
    exit(1,"");
    1028:	00007597          	auipc	a1,0x7
    102c:	21058593          	addi	a1,a1,528 # 8238 <malloc+0x173e>
    1030:	4505                	li	a0,1
    1032:	00005097          	auipc	ra,0x5
    1036:	66a080e7          	jalr	1642(ra) # 669c <exit>
    printf("%s: unlinkread write failed\n", s);
    103a:	85ce                	mv	a1,s3
    103c:	00006517          	auipc	a0,0x6
    1040:	1b450513          	addi	a0,a0,436 # 71f0 <malloc+0x6f6>
    1044:	00006097          	auipc	ra,0x6
    1048:	9f8080e7          	jalr	-1544(ra) # 6a3c <printf>
    exit(1,"");
    104c:	00007597          	auipc	a1,0x7
    1050:	1ec58593          	addi	a1,a1,492 # 8238 <malloc+0x173e>
    1054:	4505                	li	a0,1
    1056:	00005097          	auipc	ra,0x5
    105a:	646080e7          	jalr	1606(ra) # 669c <exit>

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
    1070:	1a450513          	addi	a0,a0,420 # 7210 <malloc+0x716>
    1074:	00005097          	auipc	ra,0x5
    1078:	678080e7          	jalr	1656(ra) # 66ec <unlink>
  unlink("lf2");
    107c:	00006517          	auipc	a0,0x6
    1080:	19c50513          	addi	a0,a0,412 # 7218 <malloc+0x71e>
    1084:	00005097          	auipc	ra,0x5
    1088:	668080e7          	jalr	1640(ra) # 66ec <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    108c:	20200593          	li	a1,514
    1090:	00006517          	auipc	a0,0x6
    1094:	18050513          	addi	a0,a0,384 # 7210 <malloc+0x716>
    1098:	00005097          	auipc	ra,0x5
    109c:	644080e7          	jalr	1604(ra) # 66dc <open>
  if(fd < 0){
    10a0:	10054763          	bltz	a0,11ae <linktest+0x150>
    10a4:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    10a6:	4615                	li	a2,5
    10a8:	00006597          	auipc	a1,0x6
    10ac:	0b858593          	addi	a1,a1,184 # 7160 <malloc+0x666>
    10b0:	00005097          	auipc	ra,0x5
    10b4:	60c080e7          	jalr	1548(ra) # 66bc <write>
    10b8:	4795                	li	a5,5
    10ba:	10f51c63          	bne	a0,a5,11d2 <linktest+0x174>
  close(fd);
    10be:	8526                	mv	a0,s1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	604080e7          	jalr	1540(ra) # 66c4 <close>
  if(link("lf1", "lf2") < 0){
    10c8:	00006597          	auipc	a1,0x6
    10cc:	15058593          	addi	a1,a1,336 # 7218 <malloc+0x71e>
    10d0:	00006517          	auipc	a0,0x6
    10d4:	14050513          	addi	a0,a0,320 # 7210 <malloc+0x716>
    10d8:	00005097          	auipc	ra,0x5
    10dc:	624080e7          	jalr	1572(ra) # 66fc <link>
    10e0:	10054b63          	bltz	a0,11f6 <linktest+0x198>
  unlink("lf1");
    10e4:	00006517          	auipc	a0,0x6
    10e8:	12c50513          	addi	a0,a0,300 # 7210 <malloc+0x716>
    10ec:	00005097          	auipc	ra,0x5
    10f0:	600080e7          	jalr	1536(ra) # 66ec <unlink>
  if(open("lf1", 0) >= 0){
    10f4:	4581                	li	a1,0
    10f6:	00006517          	auipc	a0,0x6
    10fa:	11a50513          	addi	a0,a0,282 # 7210 <malloc+0x716>
    10fe:	00005097          	auipc	ra,0x5
    1102:	5de080e7          	jalr	1502(ra) # 66dc <open>
    1106:	10055a63          	bgez	a0,121a <linktest+0x1bc>
  fd = open("lf2", 0);
    110a:	4581                	li	a1,0
    110c:	00006517          	auipc	a0,0x6
    1110:	10c50513          	addi	a0,a0,268 # 7218 <malloc+0x71e>
    1114:	00005097          	auipc	ra,0x5
    1118:	5c8080e7          	jalr	1480(ra) # 66dc <open>
    111c:	84aa                	mv	s1,a0
  if(fd < 0){
    111e:	12054063          	bltz	a0,123e <linktest+0x1e0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1122:	660d                	lui	a2,0x3
    1124:	0000d597          	auipc	a1,0xd
    1128:	b5458593          	addi	a1,a1,-1196 # dc78 <buf>
    112c:	00005097          	auipc	ra,0x5
    1130:	588080e7          	jalr	1416(ra) # 66b4 <read>
    1134:	4795                	li	a5,5
    1136:	12f51663          	bne	a0,a5,1262 <linktest+0x204>
  close(fd);
    113a:	8526                	mv	a0,s1
    113c:	00005097          	auipc	ra,0x5
    1140:	588080e7          	jalr	1416(ra) # 66c4 <close>
  if(link("lf2", "lf2") >= 0){
    1144:	00006597          	auipc	a1,0x6
    1148:	0d458593          	addi	a1,a1,212 # 7218 <malloc+0x71e>
    114c:	852e                	mv	a0,a1
    114e:	00005097          	auipc	ra,0x5
    1152:	5ae080e7          	jalr	1454(ra) # 66fc <link>
    1156:	12055863          	bgez	a0,1286 <linktest+0x228>
  unlink("lf2");
    115a:	00006517          	auipc	a0,0x6
    115e:	0be50513          	addi	a0,a0,190 # 7218 <malloc+0x71e>
    1162:	00005097          	auipc	ra,0x5
    1166:	58a080e7          	jalr	1418(ra) # 66ec <unlink>
  if(link("lf2", "lf1") >= 0){
    116a:	00006597          	auipc	a1,0x6
    116e:	0a658593          	addi	a1,a1,166 # 7210 <malloc+0x716>
    1172:	00006517          	auipc	a0,0x6
    1176:	0a650513          	addi	a0,a0,166 # 7218 <malloc+0x71e>
    117a:	00005097          	auipc	ra,0x5
    117e:	582080e7          	jalr	1410(ra) # 66fc <link>
    1182:	12055463          	bgez	a0,12aa <linktest+0x24c>
  if(link(".", "lf1") >= 0){
    1186:	00006597          	auipc	a1,0x6
    118a:	08a58593          	addi	a1,a1,138 # 7210 <malloc+0x716>
    118e:	00006517          	auipc	a0,0x6
    1192:	19250513          	addi	a0,a0,402 # 7320 <malloc+0x826>
    1196:	00005097          	auipc	ra,0x5
    119a:	566080e7          	jalr	1382(ra) # 66fc <link>
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
    11b4:	07050513          	addi	a0,a0,112 # 7220 <malloc+0x726>
    11b8:	00006097          	auipc	ra,0x6
    11bc:	884080e7          	jalr	-1916(ra) # 6a3c <printf>
    exit(1,"");
    11c0:	00007597          	auipc	a1,0x7
    11c4:	07858593          	addi	a1,a1,120 # 8238 <malloc+0x173e>
    11c8:	4505                	li	a0,1
    11ca:	00005097          	auipc	ra,0x5
    11ce:	4d2080e7          	jalr	1234(ra) # 669c <exit>
    printf("%s: write lf1 failed\n", s);
    11d2:	85ca                	mv	a1,s2
    11d4:	00006517          	auipc	a0,0x6
    11d8:	06450513          	addi	a0,a0,100 # 7238 <malloc+0x73e>
    11dc:	00006097          	auipc	ra,0x6
    11e0:	860080e7          	jalr	-1952(ra) # 6a3c <printf>
    exit(1,"");
    11e4:	00007597          	auipc	a1,0x7
    11e8:	05458593          	addi	a1,a1,84 # 8238 <malloc+0x173e>
    11ec:	4505                	li	a0,1
    11ee:	00005097          	auipc	ra,0x5
    11f2:	4ae080e7          	jalr	1198(ra) # 669c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    11f6:	85ca                	mv	a1,s2
    11f8:	00006517          	auipc	a0,0x6
    11fc:	05850513          	addi	a0,a0,88 # 7250 <malloc+0x756>
    1200:	00006097          	auipc	ra,0x6
    1204:	83c080e7          	jalr	-1988(ra) # 6a3c <printf>
    exit(1,"");
    1208:	00007597          	auipc	a1,0x7
    120c:	03058593          	addi	a1,a1,48 # 8238 <malloc+0x173e>
    1210:	4505                	li	a0,1
    1212:	00005097          	auipc	ra,0x5
    1216:	48a080e7          	jalr	1162(ra) # 669c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    121a:	85ca                	mv	a1,s2
    121c:	00006517          	auipc	a0,0x6
    1220:	05450513          	addi	a0,a0,84 # 7270 <malloc+0x776>
    1224:	00006097          	auipc	ra,0x6
    1228:	818080e7          	jalr	-2024(ra) # 6a3c <printf>
    exit(1,"");
    122c:	00007597          	auipc	a1,0x7
    1230:	00c58593          	addi	a1,a1,12 # 8238 <malloc+0x173e>
    1234:	4505                	li	a0,1
    1236:	00005097          	auipc	ra,0x5
    123a:	466080e7          	jalr	1126(ra) # 669c <exit>
    printf("%s: open lf2 failed\n", s);
    123e:	85ca                	mv	a1,s2
    1240:	00006517          	auipc	a0,0x6
    1244:	06050513          	addi	a0,a0,96 # 72a0 <malloc+0x7a6>
    1248:	00005097          	auipc	ra,0x5
    124c:	7f4080e7          	jalr	2036(ra) # 6a3c <printf>
    exit(1,"");
    1250:	00007597          	auipc	a1,0x7
    1254:	fe858593          	addi	a1,a1,-24 # 8238 <malloc+0x173e>
    1258:	4505                	li	a0,1
    125a:	00005097          	auipc	ra,0x5
    125e:	442080e7          	jalr	1090(ra) # 669c <exit>
    printf("%s: read lf2 failed\n", s);
    1262:	85ca                	mv	a1,s2
    1264:	00006517          	auipc	a0,0x6
    1268:	05450513          	addi	a0,a0,84 # 72b8 <malloc+0x7be>
    126c:	00005097          	auipc	ra,0x5
    1270:	7d0080e7          	jalr	2000(ra) # 6a3c <printf>
    exit(1,"");
    1274:	00007597          	auipc	a1,0x7
    1278:	fc458593          	addi	a1,a1,-60 # 8238 <malloc+0x173e>
    127c:	4505                	li	a0,1
    127e:	00005097          	auipc	ra,0x5
    1282:	41e080e7          	jalr	1054(ra) # 669c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1286:	85ca                	mv	a1,s2
    1288:	00006517          	auipc	a0,0x6
    128c:	04850513          	addi	a0,a0,72 # 72d0 <malloc+0x7d6>
    1290:	00005097          	auipc	ra,0x5
    1294:	7ac080e7          	jalr	1964(ra) # 6a3c <printf>
    exit(1,"");
    1298:	00007597          	auipc	a1,0x7
    129c:	fa058593          	addi	a1,a1,-96 # 8238 <malloc+0x173e>
    12a0:	4505                	li	a0,1
    12a2:	00005097          	auipc	ra,0x5
    12a6:	3fa080e7          	jalr	1018(ra) # 669c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    12aa:	85ca                	mv	a1,s2
    12ac:	00006517          	auipc	a0,0x6
    12b0:	04c50513          	addi	a0,a0,76 # 72f8 <malloc+0x7fe>
    12b4:	00005097          	auipc	ra,0x5
    12b8:	788080e7          	jalr	1928(ra) # 6a3c <printf>
    exit(1,"");
    12bc:	00007597          	auipc	a1,0x7
    12c0:	f7c58593          	addi	a1,a1,-132 # 8238 <malloc+0x173e>
    12c4:	4505                	li	a0,1
    12c6:	00005097          	auipc	ra,0x5
    12ca:	3d6080e7          	jalr	982(ra) # 669c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    12ce:	85ca                	mv	a1,s2
    12d0:	00006517          	auipc	a0,0x6
    12d4:	05850513          	addi	a0,a0,88 # 7328 <malloc+0x82e>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	764080e7          	jalr	1892(ra) # 6a3c <printf>
    exit(1,"");
    12e0:	00007597          	auipc	a1,0x7
    12e4:	f5858593          	addi	a1,a1,-168 # 8238 <malloc+0x173e>
    12e8:	4505                	li	a0,1
    12ea:	00005097          	auipc	ra,0x5
    12ee:	3b2080e7          	jalr	946(ra) # 669c <exit>

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
    130e:	03e98993          	addi	s3,s3,62 # 7348 <malloc+0x84e>
    1312:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1314:	6a85                	lui	s5,0x1
    1316:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    131a:	85a6                	mv	a1,s1
    131c:	854e                	mv	a0,s3
    131e:	00005097          	auipc	ra,0x5
    1322:	3de080e7          	jalr	990(ra) # 66fc <link>
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
    134a:	01250513          	addi	a0,a0,18 # 7358 <malloc+0x85e>
    134e:	00005097          	auipc	ra,0x5
    1352:	6ee080e7          	jalr	1774(ra) # 6a3c <printf>
      exit(1,"");
    1356:	00007597          	auipc	a1,0x7
    135a:	ee258593          	addi	a1,a1,-286 # 8238 <malloc+0x173e>
    135e:	4505                	li	a0,1
    1360:	00005097          	auipc	ra,0x5
    1364:	33c080e7          	jalr	828(ra) # 669c <exit>

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
    1382:	ffa50513          	addi	a0,a0,-6 # 7378 <malloc+0x87e>
    1386:	00005097          	auipc	ra,0x5
    138a:	366080e7          	jalr	870(ra) # 66ec <unlink>
  fd = open("bd", O_CREATE);
    138e:	20000593          	li	a1,512
    1392:	00006517          	auipc	a0,0x6
    1396:	fe650513          	addi	a0,a0,-26 # 7378 <malloc+0x87e>
    139a:	00005097          	auipc	ra,0x5
    139e:	342080e7          	jalr	834(ra) # 66dc <open>
  if(fd < 0){
    13a2:	0c054963          	bltz	a0,1474 <bigdir+0x10c>
  close(fd);
    13a6:	00005097          	auipc	ra,0x5
    13aa:	31e080e7          	jalr	798(ra) # 66c4 <close>
  for(i = 0; i < N; i++){
    13ae:	4901                	li	s2,0
    name[0] = 'x';
    13b0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    13b4:	00006a17          	auipc	s4,0x6
    13b8:	fc4a0a13          	addi	s4,s4,-60 # 7378 <malloc+0x87e>
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
    13f8:	308080e7          	jalr	776(ra) # 66fc <link>
    13fc:	84aa                	mv	s1,a0
    13fe:	ed49                	bnez	a0,1498 <bigdir+0x130>
  for(i = 0; i < N; i++){
    1400:	2905                	addiw	s2,s2,1
    1402:	fb691fe3          	bne	s2,s6,13c0 <bigdir+0x58>
  unlink("bd");
    1406:	00006517          	auipc	a0,0x6
    140a:	f7250513          	addi	a0,a0,-142 # 7378 <malloc+0x87e>
    140e:	00005097          	auipc	ra,0x5
    1412:	2de080e7          	jalr	734(ra) # 66ec <unlink>
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
    1454:	29c080e7          	jalr	668(ra) # 66ec <unlink>
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
    147a:	f0a50513          	addi	a0,a0,-246 # 7380 <malloc+0x886>
    147e:	00005097          	auipc	ra,0x5
    1482:	5be080e7          	jalr	1470(ra) # 6a3c <printf>
    exit(1,"");
    1486:	00007597          	auipc	a1,0x7
    148a:	db258593          	addi	a1,a1,-590 # 8238 <malloc+0x173e>
    148e:	4505                	li	a0,1
    1490:	00005097          	auipc	ra,0x5
    1494:	20c080e7          	jalr	524(ra) # 669c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1498:	fb040613          	addi	a2,s0,-80
    149c:	85ce                	mv	a1,s3
    149e:	00006517          	auipc	a0,0x6
    14a2:	f0250513          	addi	a0,a0,-254 # 73a0 <malloc+0x8a6>
    14a6:	00005097          	auipc	ra,0x5
    14aa:	596080e7          	jalr	1430(ra) # 6a3c <printf>
      exit(1,"");
    14ae:	00007597          	auipc	a1,0x7
    14b2:	d8a58593          	addi	a1,a1,-630 # 8238 <malloc+0x173e>
    14b6:	4505                	li	a0,1
    14b8:	00005097          	auipc	ra,0x5
    14bc:	1e4080e7          	jalr	484(ra) # 669c <exit>
      printf("%s: bigdir unlink failed", s);
    14c0:	85ce                	mv	a1,s3
    14c2:	00006517          	auipc	a0,0x6
    14c6:	efe50513          	addi	a0,a0,-258 # 73c0 <malloc+0x8c6>
    14ca:	00005097          	auipc	ra,0x5
    14ce:	572080e7          	jalr	1394(ra) # 6a3c <printf>
      exit(1,"");
    14d2:	00007597          	auipc	a1,0x7
    14d6:	d6658593          	addi	a1,a1,-666 # 8238 <malloc+0x173e>
    14da:	4505                	li	a0,1
    14dc:	00005097          	auipc	ra,0x5
    14e0:	1c0080e7          	jalr	448(ra) # 669c <exit>

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
    1504:	1d4080e7          	jalr	468(ra) # 66d4 <exec>
  pipe(big);
    1508:	6088                	ld	a0,0(s1)
    150a:	00005097          	auipc	ra,0x5
    150e:	1a2080e7          	jalr	418(ra) # 66ac <pipe>
  exit(0,"");
    1512:	00007597          	auipc	a1,0x7
    1516:	d2658593          	addi	a1,a1,-730 # 8238 <malloc+0x173e>
    151a:	4501                	li	a0,0
    151c:	00005097          	auipc	ra,0x5
    1520:	180080e7          	jalr	384(ra) # 669c <exit>

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
    1542:	6fa98993          	addi	s3,s3,1786 # 6c38 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1546:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    154a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    154e:	fc040593          	addi	a1,s0,-64
    1552:	854e                	mv	a0,s3
    1554:	00005097          	auipc	ra,0x5
    1558:	180080e7          	jalr	384(ra) # 66d4 <exec>
  for(int i = 0; i < 50000; i++){
    155c:	34fd                	addiw	s1,s1,-1
    155e:	f4e5                	bnez	s1,1546 <badarg+0x22>
  exit(0,"");
    1560:	00007597          	auipc	a1,0x7
    1564:	cd858593          	addi	a1,a1,-808 # 8238 <malloc+0x173e>
    1568:	4501                	li	a0,0
    156a:	00005097          	auipc	ra,0x5
    156e:	132080e7          	jalr	306(ra) # 669c <exit>

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
    159c:	154080e7          	jalr	340(ra) # 66ec <unlink>
  if(ret != -1){
    15a0:	57fd                	li	a5,-1
    15a2:	0ef51463          	bne	a0,a5,168a <copyinstr2+0x118>
  int fd = open(b, O_CREATE | O_WRONLY);
    15a6:	20100593          	li	a1,513
    15aa:	f6840513          	addi	a0,s0,-152
    15ae:	00005097          	auipc	ra,0x5
    15b2:	12e080e7          	jalr	302(ra) # 66dc <open>
  if(fd != -1){
    15b6:	57fd                	li	a5,-1
    15b8:	0ef51d63          	bne	a0,a5,16b2 <copyinstr2+0x140>
  ret = link(b, b);
    15bc:	f6840593          	addi	a1,s0,-152
    15c0:	852e                	mv	a0,a1
    15c2:	00005097          	auipc	ra,0x5
    15c6:	13a080e7          	jalr	314(ra) # 66fc <link>
  if(ret != -1){
    15ca:	57fd                	li	a5,-1
    15cc:	10f51763          	bne	a0,a5,16da <copyinstr2+0x168>
  char *args[] = { "xx", 0 };
    15d0:	00007797          	auipc	a5,0x7
    15d4:	05878793          	addi	a5,a5,88 # 8628 <malloc+0x1b2e>
    15d8:	f4f43c23          	sd	a5,-168(s0)
    15dc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    15e0:	f5840593          	addi	a1,s0,-168
    15e4:	f6840513          	addi	a0,s0,-152
    15e8:	00005097          	auipc	ra,0x5
    15ec:	0ec080e7          	jalr	236(ra) # 66d4 <exec>
  if(ret != -1){
    15f0:	57fd                	li	a5,-1
    15f2:	10f51963          	bne	a0,a5,1704 <copyinstr2+0x192>
  int pid = fork();
    15f6:	00005097          	auipc	ra,0x5
    15fa:	09e080e7          	jalr	158(ra) # 6694 <fork>
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
    1630:	a1c78793          	addi	a5,a5,-1508 # 9048 <malloc+0x254e>
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
    1654:	5e850513          	addi	a0,a0,1512 # 6c38 <malloc+0x13e>
    1658:	00005097          	auipc	ra,0x5
    165c:	07c080e7          	jalr	124(ra) # 66d4 <exec>
    if(ret != -1){
    1660:	57fd                	li	a5,-1
    1662:	0ef50663          	beq	a0,a5,174e <copyinstr2+0x1dc>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1666:	55fd                	li	a1,-1
    1668:	00006517          	auipc	a0,0x6
    166c:	e0050513          	addi	a0,a0,-512 # 7468 <malloc+0x96e>
    1670:	00005097          	auipc	ra,0x5
    1674:	3cc080e7          	jalr	972(ra) # 6a3c <printf>
      exit(1,"");
    1678:	00007597          	auipc	a1,0x7
    167c:	bc058593          	addi	a1,a1,-1088 # 8238 <malloc+0x173e>
    1680:	4505                	li	a0,1
    1682:	00005097          	auipc	ra,0x5
    1686:	01a080e7          	jalr	26(ra) # 669c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    168a:	862a                	mv	a2,a0
    168c:	f6840593          	addi	a1,s0,-152
    1690:	00006517          	auipc	a0,0x6
    1694:	d5050513          	addi	a0,a0,-688 # 73e0 <malloc+0x8e6>
    1698:	00005097          	auipc	ra,0x5
    169c:	3a4080e7          	jalr	932(ra) # 6a3c <printf>
    exit(1,"");
    16a0:	00007597          	auipc	a1,0x7
    16a4:	b9858593          	addi	a1,a1,-1128 # 8238 <malloc+0x173e>
    16a8:	4505                	li	a0,1
    16aa:	00005097          	auipc	ra,0x5
    16ae:	ff2080e7          	jalr	-14(ra) # 669c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    16b2:	862a                	mv	a2,a0
    16b4:	f6840593          	addi	a1,s0,-152
    16b8:	00006517          	auipc	a0,0x6
    16bc:	d4850513          	addi	a0,a0,-696 # 7400 <malloc+0x906>
    16c0:	00005097          	auipc	ra,0x5
    16c4:	37c080e7          	jalr	892(ra) # 6a3c <printf>
    exit(1,"");
    16c8:	00007597          	auipc	a1,0x7
    16cc:	b7058593          	addi	a1,a1,-1168 # 8238 <malloc+0x173e>
    16d0:	4505                	li	a0,1
    16d2:	00005097          	auipc	ra,0x5
    16d6:	fca080e7          	jalr	-54(ra) # 669c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    16da:	86aa                	mv	a3,a0
    16dc:	f6840613          	addi	a2,s0,-152
    16e0:	85b2                	mv	a1,a2
    16e2:	00006517          	auipc	a0,0x6
    16e6:	d3e50513          	addi	a0,a0,-706 # 7420 <malloc+0x926>
    16ea:	00005097          	auipc	ra,0x5
    16ee:	352080e7          	jalr	850(ra) # 6a3c <printf>
    exit(1,"");
    16f2:	00007597          	auipc	a1,0x7
    16f6:	b4658593          	addi	a1,a1,-1210 # 8238 <malloc+0x173e>
    16fa:	4505                	li	a0,1
    16fc:	00005097          	auipc	ra,0x5
    1700:	fa0080e7          	jalr	-96(ra) # 669c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1704:	567d                	li	a2,-1
    1706:	f6840593          	addi	a1,s0,-152
    170a:	00006517          	auipc	a0,0x6
    170e:	d3e50513          	addi	a0,a0,-706 # 7448 <malloc+0x94e>
    1712:	00005097          	auipc	ra,0x5
    1716:	32a080e7          	jalr	810(ra) # 6a3c <printf>
    exit(1,"");
    171a:	00007597          	auipc	a1,0x7
    171e:	b1e58593          	addi	a1,a1,-1250 # 8238 <malloc+0x173e>
    1722:	4505                	li	a0,1
    1724:	00005097          	auipc	ra,0x5
    1728:	f78080e7          	jalr	-136(ra) # 669c <exit>
    printf("fork failed\n");
    172c:	00006517          	auipc	a0,0x6
    1730:	1ac50513          	addi	a0,a0,428 # 78d8 <malloc+0xdde>
    1734:	00005097          	auipc	ra,0x5
    1738:	308080e7          	jalr	776(ra) # 6a3c <printf>
    exit(1,"");
    173c:	00007597          	auipc	a1,0x7
    1740:	afc58593          	addi	a1,a1,-1284 # 8238 <malloc+0x173e>
    1744:	4505                	li	a0,1
    1746:	00005097          	auipc	ra,0x5
    174a:	f56080e7          	jalr	-170(ra) # 669c <exit>
    exit(747,""); // OK
    174e:	00007597          	auipc	a1,0x7
    1752:	aea58593          	addi	a1,a1,-1302 # 8238 <malloc+0x173e>
    1756:	2eb00513          	li	a0,747
    175a:	00005097          	auipc	ra,0x5
    175e:	f42080e7          	jalr	-190(ra) # 669c <exit>
  int st = 0;
    1762:	f4042a23          	sw	zero,-172(s0)
  wait(&st,0);
    1766:	4581                	li	a1,0
    1768:	f5440513          	addi	a0,s0,-172
    176c:	00005097          	auipc	ra,0x5
    1770:	f38080e7          	jalr	-200(ra) # 66a4 <wait>
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
    178c:	d0850513          	addi	a0,a0,-760 # 7490 <malloc+0x996>
    1790:	00005097          	auipc	ra,0x5
    1794:	2ac080e7          	jalr	684(ra) # 6a3c <printf>
    exit(1,"");
    1798:	00007597          	auipc	a1,0x7
    179c:	aa058593          	addi	a1,a1,-1376 # 8238 <malloc+0x173e>
    17a0:	4505                	li	a0,1
    17a2:	00005097          	auipc	ra,0x5
    17a6:	efa080e7          	jalr	-262(ra) # 669c <exit>

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
    17c6:	4ce50513          	addi	a0,a0,1230 # 6c90 <malloc+0x196>
    17ca:	00005097          	auipc	ra,0x5
    17ce:	f12080e7          	jalr	-238(ra) # 66dc <open>
    17d2:	00005097          	auipc	ra,0x5
    17d6:	ef2080e7          	jalr	-270(ra) # 66c4 <close>
  pid = fork();
    17da:	00005097          	auipc	ra,0x5
    17de:	eba080e7          	jalr	-326(ra) # 6694 <fork>
  if(pid < 0){
    17e2:	08054463          	bltz	a0,186a <truncate3+0xc0>
  if(pid == 0){
    17e6:	e96d                	bnez	a0,18d8 <truncate3+0x12e>
    17e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    17ec:	00005a17          	auipc	s4,0x5
    17f0:	4a4a0a13          	addi	s4,s4,1188 # 6c90 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    17f4:	00006a97          	auipc	s5,0x6
    17f8:	cfca8a93          	addi	s5,s5,-772 # 74f0 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    17fc:	4585                	li	a1,1
    17fe:	8552                	mv	a0,s4
    1800:	00005097          	auipc	ra,0x5
    1804:	edc080e7          	jalr	-292(ra) # 66dc <open>
    1808:	84aa                	mv	s1,a0
      if(fd < 0){
    180a:	08054263          	bltz	a0,188e <truncate3+0xe4>
      int n = write(fd, "1234567890", 10);
    180e:	4629                	li	a2,10
    1810:	85d6                	mv	a1,s5
    1812:	00005097          	auipc	ra,0x5
    1816:	eaa080e7          	jalr	-342(ra) # 66bc <write>
      if(n != 10){
    181a:	47a9                	li	a5,10
    181c:	08f51b63          	bne	a0,a5,18b2 <truncate3+0x108>
      close(fd);
    1820:	8526                	mv	a0,s1
    1822:	00005097          	auipc	ra,0x5
    1826:	ea2080e7          	jalr	-350(ra) # 66c4 <close>
      fd = open("truncfile", O_RDONLY);
    182a:	4581                	li	a1,0
    182c:	8552                	mv	a0,s4
    182e:	00005097          	auipc	ra,0x5
    1832:	eae080e7          	jalr	-338(ra) # 66dc <open>
    1836:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1838:	02000613          	li	a2,32
    183c:	f9840593          	addi	a1,s0,-104
    1840:	00005097          	auipc	ra,0x5
    1844:	e74080e7          	jalr	-396(ra) # 66b4 <read>
      close(fd);
    1848:	8526                	mv	a0,s1
    184a:	00005097          	auipc	ra,0x5
    184e:	e7a080e7          	jalr	-390(ra) # 66c4 <close>
    for(int i = 0; i < 100; i++){
    1852:	39fd                	addiw	s3,s3,-1
    1854:	fa0994e3          	bnez	s3,17fc <truncate3+0x52>
    exit(0,"");
    1858:	00007597          	auipc	a1,0x7
    185c:	9e058593          	addi	a1,a1,-1568 # 8238 <malloc+0x173e>
    1860:	4501                	li	a0,0
    1862:	00005097          	auipc	ra,0x5
    1866:	e3a080e7          	jalr	-454(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00006517          	auipc	a0,0x6
    1870:	c5450513          	addi	a0,a0,-940 # 74c0 <malloc+0x9c6>
    1874:	00005097          	auipc	ra,0x5
    1878:	1c8080e7          	jalr	456(ra) # 6a3c <printf>
    exit(1,"");
    187c:	00007597          	auipc	a1,0x7
    1880:	9bc58593          	addi	a1,a1,-1604 # 8238 <malloc+0x173e>
    1884:	4505                	li	a0,1
    1886:	00005097          	auipc	ra,0x5
    188a:	e16080e7          	jalr	-490(ra) # 669c <exit>
        printf("%s: open failed\n", s);
    188e:	85ca                	mv	a1,s2
    1890:	00006517          	auipc	a0,0x6
    1894:	c4850513          	addi	a0,a0,-952 # 74d8 <malloc+0x9de>
    1898:	00005097          	auipc	ra,0x5
    189c:	1a4080e7          	jalr	420(ra) # 6a3c <printf>
        exit(1,"");
    18a0:	00007597          	auipc	a1,0x7
    18a4:	99858593          	addi	a1,a1,-1640 # 8238 <malloc+0x173e>
    18a8:	4505                	li	a0,1
    18aa:	00005097          	auipc	ra,0x5
    18ae:	df2080e7          	jalr	-526(ra) # 669c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    18b2:	862a                	mv	a2,a0
    18b4:	85ca                	mv	a1,s2
    18b6:	00006517          	auipc	a0,0x6
    18ba:	c4a50513          	addi	a0,a0,-950 # 7500 <malloc+0xa06>
    18be:	00005097          	auipc	ra,0x5
    18c2:	17e080e7          	jalr	382(ra) # 6a3c <printf>
        exit(1,"");
    18c6:	00007597          	auipc	a1,0x7
    18ca:	97258593          	addi	a1,a1,-1678 # 8238 <malloc+0x173e>
    18ce:	4505                	li	a0,1
    18d0:	00005097          	auipc	ra,0x5
    18d4:	dcc080e7          	jalr	-564(ra) # 669c <exit>
    18d8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18dc:	00005a17          	auipc	s4,0x5
    18e0:	3b4a0a13          	addi	s4,s4,948 # 6c90 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    18e4:	00006a97          	auipc	s5,0x6
    18e8:	c3ca8a93          	addi	s5,s5,-964 # 7520 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18ec:	60100593          	li	a1,1537
    18f0:	8552                	mv	a0,s4
    18f2:	00005097          	auipc	ra,0x5
    18f6:	dea080e7          	jalr	-534(ra) # 66dc <open>
    18fa:	84aa                	mv	s1,a0
    if(fd < 0){
    18fc:	04054c63          	bltz	a0,1954 <truncate3+0x1aa>
    int n = write(fd, "xxx", 3);
    1900:	460d                	li	a2,3
    1902:	85d6                	mv	a1,s5
    1904:	00005097          	auipc	ra,0x5
    1908:	db8080e7          	jalr	-584(ra) # 66bc <write>
    if(n != 3){
    190c:	478d                	li	a5,3
    190e:	06f51563          	bne	a0,a5,1978 <truncate3+0x1ce>
    close(fd);
    1912:	8526                	mv	a0,s1
    1914:	00005097          	auipc	ra,0x5
    1918:	db0080e7          	jalr	-592(ra) # 66c4 <close>
  for(int i = 0; i < 150; i++){
    191c:	39fd                	addiw	s3,s3,-1
    191e:	fc0997e3          	bnez	s3,18ec <truncate3+0x142>
  wait(&xstatus ,0);
    1922:	4581                	li	a1,0
    1924:	fbc40513          	addi	a0,s0,-68
    1928:	00005097          	auipc	ra,0x5
    192c:	d7c080e7          	jalr	-644(ra) # 66a4 <wait>
  unlink("truncfile");
    1930:	00005517          	auipc	a0,0x5
    1934:	36050513          	addi	a0,a0,864 # 6c90 <malloc+0x196>
    1938:	00005097          	auipc	ra,0x5
    193c:	db4080e7          	jalr	-588(ra) # 66ec <unlink>
  exit(xstatus,"");
    1940:	00007597          	auipc	a1,0x7
    1944:	8f858593          	addi	a1,a1,-1800 # 8238 <malloc+0x173e>
    1948:	fbc42503          	lw	a0,-68(s0)
    194c:	00005097          	auipc	ra,0x5
    1950:	d50080e7          	jalr	-688(ra) # 669c <exit>
      printf("%s: open failed\n", s);
    1954:	85ca                	mv	a1,s2
    1956:	00006517          	auipc	a0,0x6
    195a:	b8250513          	addi	a0,a0,-1150 # 74d8 <malloc+0x9de>
    195e:	00005097          	auipc	ra,0x5
    1962:	0de080e7          	jalr	222(ra) # 6a3c <printf>
      exit(1,"");
    1966:	00007597          	auipc	a1,0x7
    196a:	8d258593          	addi	a1,a1,-1838 # 8238 <malloc+0x173e>
    196e:	4505                	li	a0,1
    1970:	00005097          	auipc	ra,0x5
    1974:	d2c080e7          	jalr	-724(ra) # 669c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1978:	862a                	mv	a2,a0
    197a:	85ca                	mv	a1,s2
    197c:	00006517          	auipc	a0,0x6
    1980:	bac50513          	addi	a0,a0,-1108 # 7528 <malloc+0xa2e>
    1984:	00005097          	auipc	ra,0x5
    1988:	0b8080e7          	jalr	184(ra) # 6a3c <printf>
      exit(1,"");
    198c:	00007597          	auipc	a1,0x7
    1990:	8ac58593          	addi	a1,a1,-1876 # 8238 <malloc+0x173e>
    1994:	4505                	li	a0,1
    1996:	00005097          	auipc	ra,0x5
    199a:	d06080e7          	jalr	-762(ra) # 669c <exit>

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
    19b0:	28c78793          	addi	a5,a5,652 # 6c38 <malloc+0x13e>
    19b4:	fcf43023          	sd	a5,-64(s0)
    19b8:	00006797          	auipc	a5,0x6
    19bc:	b9078793          	addi	a5,a5,-1136 # 7548 <malloc+0xa4e>
    19c0:	fcf43423          	sd	a5,-56(s0)
    19c4:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    19c8:	00006517          	auipc	a0,0x6
    19cc:	b8850513          	addi	a0,a0,-1144 # 7550 <malloc+0xa56>
    19d0:	00005097          	auipc	ra,0x5
    19d4:	d1c080e7          	jalr	-740(ra) # 66ec <unlink>
  pid = fork();
    19d8:	00005097          	auipc	ra,0x5
    19dc:	cbc080e7          	jalr	-836(ra) # 6694 <fork>
  if(pid < 0) {
    19e0:	04054a63          	bltz	a0,1a34 <exectest+0x96>
    19e4:	84aa                	mv	s1,a0
  if(pid == 0) {
    19e6:	e55d                	bnez	a0,1a94 <exectest+0xf6>
    close(1);
    19e8:	4505                	li	a0,1
    19ea:	00005097          	auipc	ra,0x5
    19ee:	cda080e7          	jalr	-806(ra) # 66c4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    19f2:	20100593          	li	a1,513
    19f6:	00006517          	auipc	a0,0x6
    19fa:	b5a50513          	addi	a0,a0,-1190 # 7550 <malloc+0xa56>
    19fe:	00005097          	auipc	ra,0x5
    1a02:	cde080e7          	jalr	-802(ra) # 66dc <open>
    if(fd < 0) {
    1a06:	04054963          	bltz	a0,1a58 <exectest+0xba>
    if(fd != 1) {
    1a0a:	4785                	li	a5,1
    1a0c:	06f50863          	beq	a0,a5,1a7c <exectest+0xde>
      printf("%s: wrong fd\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00006517          	auipc	a0,0x6
    1a16:	b5e50513          	addi	a0,a0,-1186 # 7570 <malloc+0xa76>
    1a1a:	00005097          	auipc	ra,0x5
    1a1e:	022080e7          	jalr	34(ra) # 6a3c <printf>
      exit(1,"");
    1a22:	00007597          	auipc	a1,0x7
    1a26:	81658593          	addi	a1,a1,-2026 # 8238 <malloc+0x173e>
    1a2a:	4505                	li	a0,1
    1a2c:	00005097          	auipc	ra,0x5
    1a30:	c70080e7          	jalr	-912(ra) # 669c <exit>
     printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00006517          	auipc	a0,0x6
    1a3a:	a8a50513          	addi	a0,a0,-1398 # 74c0 <malloc+0x9c6>
    1a3e:	00005097          	auipc	ra,0x5
    1a42:	ffe080e7          	jalr	-2(ra) # 6a3c <printf>
     exit(1,"");
    1a46:	00006597          	auipc	a1,0x6
    1a4a:	7f258593          	addi	a1,a1,2034 # 8238 <malloc+0x173e>
    1a4e:	4505                	li	a0,1
    1a50:	00005097          	auipc	ra,0x5
    1a54:	c4c080e7          	jalr	-948(ra) # 669c <exit>
      printf("%s: create failed\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00006517          	auipc	a0,0x6
    1a5e:	afe50513          	addi	a0,a0,-1282 # 7558 <malloc+0xa5e>
    1a62:	00005097          	auipc	ra,0x5
    1a66:	fda080e7          	jalr	-38(ra) # 6a3c <printf>
      exit(1,"");
    1a6a:	00006597          	auipc	a1,0x6
    1a6e:	7ce58593          	addi	a1,a1,1998 # 8238 <malloc+0x173e>
    1a72:	4505                	li	a0,1
    1a74:	00005097          	auipc	ra,0x5
    1a78:	c28080e7          	jalr	-984(ra) # 669c <exit>
    if(exec("echo", echoargv) < 0){
    1a7c:	fc040593          	addi	a1,s0,-64
    1a80:	00005517          	auipc	a0,0x5
    1a84:	1b850513          	addi	a0,a0,440 # 6c38 <malloc+0x13e>
    1a88:	00005097          	auipc	ra,0x5
    1a8c:	c4c080e7          	jalr	-948(ra) # 66d4 <exec>
    1a90:	02054663          	bltz	a0,1abc <exectest+0x11e>
  if (wait(&xstatus,0) != pid) {
    1a94:	4581                	li	a1,0
    1a96:	fdc40513          	addi	a0,s0,-36
    1a9a:	00005097          	auipc	ra,0x5
    1a9e:	c0a080e7          	jalr	-1014(ra) # 66a4 <wait>
    1aa2:	02951f63          	bne	a0,s1,1ae0 <exectest+0x142>
  if(xstatus != 0)
    1aa6:	fdc42503          	lw	a0,-36(s0)
    1aaa:	c529                	beqz	a0,1af4 <exectest+0x156>
    exit(xstatus,"");
    1aac:	00006597          	auipc	a1,0x6
    1ab0:	78c58593          	addi	a1,a1,1932 # 8238 <malloc+0x173e>
    1ab4:	00005097          	auipc	ra,0x5
    1ab8:	be8080e7          	jalr	-1048(ra) # 669c <exit>
      printf("%s: exec echo failed\n", s);
    1abc:	85ca                	mv	a1,s2
    1abe:	00006517          	auipc	a0,0x6
    1ac2:	ac250513          	addi	a0,a0,-1342 # 7580 <malloc+0xa86>
    1ac6:	00005097          	auipc	ra,0x5
    1aca:	f76080e7          	jalr	-138(ra) # 6a3c <printf>
      exit(1,"");
    1ace:	00006597          	auipc	a1,0x6
    1ad2:	76a58593          	addi	a1,a1,1898 # 8238 <malloc+0x173e>
    1ad6:	4505                	li	a0,1
    1ad8:	00005097          	auipc	ra,0x5
    1adc:	bc4080e7          	jalr	-1084(ra) # 669c <exit>
    printf("%s: wait failed!\n", s);
    1ae0:	85ca                	mv	a1,s2
    1ae2:	00006517          	auipc	a0,0x6
    1ae6:	ab650513          	addi	a0,a0,-1354 # 7598 <malloc+0xa9e>
    1aea:	00005097          	auipc	ra,0x5
    1aee:	f52080e7          	jalr	-174(ra) # 6a3c <printf>
    1af2:	bf55                	j	1aa6 <exectest+0x108>
  fd = open("echo-ok", O_RDONLY);
    1af4:	4581                	li	a1,0
    1af6:	00006517          	auipc	a0,0x6
    1afa:	a5a50513          	addi	a0,a0,-1446 # 7550 <malloc+0xa56>
    1afe:	00005097          	auipc	ra,0x5
    1b02:	bde080e7          	jalr	-1058(ra) # 66dc <open>
  if(fd < 0) {
    1b06:	02054e63          	bltz	a0,1b42 <exectest+0x1a4>
  if (read(fd, buf, 2) != 2) {
    1b0a:	4609                	li	a2,2
    1b0c:	fb840593          	addi	a1,s0,-72
    1b10:	00005097          	auipc	ra,0x5
    1b14:	ba4080e7          	jalr	-1116(ra) # 66b4 <read>
    1b18:	4789                	li	a5,2
    1b1a:	04f50663          	beq	a0,a5,1b66 <exectest+0x1c8>
    printf("%s: read failed\n", s);
    1b1e:	85ca                	mv	a1,s2
    1b20:	00005517          	auipc	a0,0x5
    1b24:	4e850513          	addi	a0,a0,1256 # 7008 <malloc+0x50e>
    1b28:	00005097          	auipc	ra,0x5
    1b2c:	f14080e7          	jalr	-236(ra) # 6a3c <printf>
    exit(1,"");
    1b30:	00006597          	auipc	a1,0x6
    1b34:	70858593          	addi	a1,a1,1800 # 8238 <malloc+0x173e>
    1b38:	4505                	li	a0,1
    1b3a:	00005097          	auipc	ra,0x5
    1b3e:	b62080e7          	jalr	-1182(ra) # 669c <exit>
    printf("%s: open failed\n", s);
    1b42:	85ca                	mv	a1,s2
    1b44:	00006517          	auipc	a0,0x6
    1b48:	99450513          	addi	a0,a0,-1644 # 74d8 <malloc+0x9de>
    1b4c:	00005097          	auipc	ra,0x5
    1b50:	ef0080e7          	jalr	-272(ra) # 6a3c <printf>
    exit(1,"");
    1b54:	00006597          	auipc	a1,0x6
    1b58:	6e458593          	addi	a1,a1,1764 # 8238 <malloc+0x173e>
    1b5c:	4505                	li	a0,1
    1b5e:	00005097          	auipc	ra,0x5
    1b62:	b3e080e7          	jalr	-1218(ra) # 669c <exit>
  unlink("echo-ok");
    1b66:	00006517          	auipc	a0,0x6
    1b6a:	9ea50513          	addi	a0,a0,-1558 # 7550 <malloc+0xa56>
    1b6e:	00005097          	auipc	ra,0x5
    1b72:	b7e080e7          	jalr	-1154(ra) # 66ec <unlink>
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
    1b94:	a2050513          	addi	a0,a0,-1504 # 75b0 <malloc+0xab6>
    1b98:	00005097          	auipc	ra,0x5
    1b9c:	ea4080e7          	jalr	-348(ra) # 6a3c <printf>
    exit(1,"");
    1ba0:	00006597          	auipc	a1,0x6
    1ba4:	69858593          	addi	a1,a1,1688 # 8238 <malloc+0x173e>
    1ba8:	4505                	li	a0,1
    1baa:	00005097          	auipc	ra,0x5
    1bae:	af2080e7          	jalr	-1294(ra) # 669c <exit>
    exit(0,"");
    1bb2:	00006597          	auipc	a1,0x6
    1bb6:	68658593          	addi	a1,a1,1670 # 8238 <malloc+0x173e>
    1bba:	4501                	li	a0,0
    1bbc:	00005097          	auipc	ra,0x5
    1bc0:	ae0080e7          	jalr	-1312(ra) # 669c <exit>

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
    1be4:	acc080e7          	jalr	-1332(ra) # 66ac <pipe>
    1be8:	ed25                	bnez	a0,1c60 <pipe1+0x9c>
    1bea:	84aa                	mv	s1,a0
  pid = fork();
    1bec:	00005097          	auipc	ra,0x5
    1bf0:	aa8080e7          	jalr	-1368(ra) # 6694 <fork>
    1bf4:	8a2a                	mv	s4,a0
  if(pid == 0){
    1bf6:	c559                	beqz	a0,1c84 <pipe1+0xc0>
  } else if(pid > 0){
    1bf8:	1aa05363          	blez	a0,1d9e <pipe1+0x1da>
    close(fds[1]);
    1bfc:	fac42503          	lw	a0,-84(s0)
    1c00:	00005097          	auipc	ra,0x5
    1c04:	ac4080e7          	jalr	-1340(ra) # 66c4 <close>
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
    1c22:	a96080e7          	jalr	-1386(ra) # 66b4 <read>
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
    1c66:	96650513          	addi	a0,a0,-1690 # 75c8 <malloc+0xace>
    1c6a:	00005097          	auipc	ra,0x5
    1c6e:	dd2080e7          	jalr	-558(ra) # 6a3c <printf>
    exit(1,"");
    1c72:	00006597          	auipc	a1,0x6
    1c76:	5c658593          	addi	a1,a1,1478 # 8238 <malloc+0x173e>
    1c7a:	4505                	li	a0,1
    1c7c:	00005097          	auipc	ra,0x5
    1c80:	a20080e7          	jalr	-1504(ra) # 669c <exit>
    close(fds[0]);
    1c84:	fa842503          	lw	a0,-88(s0)
    1c88:	00005097          	auipc	ra,0x5
    1c8c:	a3c080e7          	jalr	-1476(ra) # 66c4 <close>
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
    1cce:	9f2080e7          	jalr	-1550(ra) # 66bc <write>
    1cd2:	40900793          	li	a5,1033
    1cd6:	02f51063          	bne	a0,a5,1cf6 <pipe1+0x132>
    for(n = 0; n < N; n++){
    1cda:	24a5                	addiw	s1,s1,9
    1cdc:	0ff4f493          	andi	s1,s1,255
    1ce0:	fd5a16e3          	bne	s4,s5,1cac <pipe1+0xe8>
    exit(0,"");
    1ce4:	00006597          	auipc	a1,0x6
    1ce8:	55458593          	addi	a1,a1,1364 # 8238 <malloc+0x173e>
    1cec:	4501                	li	a0,0
    1cee:	00005097          	auipc	ra,0x5
    1cf2:	9ae080e7          	jalr	-1618(ra) # 669c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1cf6:	85ca                	mv	a1,s2
    1cf8:	00006517          	auipc	a0,0x6
    1cfc:	8e850513          	addi	a0,a0,-1816 # 75e0 <malloc+0xae6>
    1d00:	00005097          	auipc	ra,0x5
    1d04:	d3c080e7          	jalr	-708(ra) # 6a3c <printf>
        exit(1,"");
    1d08:	00006597          	auipc	a1,0x6
    1d0c:	53058593          	addi	a1,a1,1328 # 8238 <malloc+0x173e>
    1d10:	4505                	li	a0,1
    1d12:	00005097          	auipc	ra,0x5
    1d16:	98a080e7          	jalr	-1654(ra) # 669c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1d1a:	85ca                	mv	a1,s2
    1d1c:	00006517          	auipc	a0,0x6
    1d20:	8dc50513          	addi	a0,a0,-1828 # 75f8 <malloc+0xafe>
    1d24:	00005097          	auipc	ra,0x5
    1d28:	d18080e7          	jalr	-744(ra) # 6a3c <printf>
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
    1d52:	8c250513          	addi	a0,a0,-1854 # 7610 <malloc+0xb16>
    1d56:	00005097          	auipc	ra,0x5
    1d5a:	ce6080e7          	jalr	-794(ra) # 6a3c <printf>
      exit(1,"");
    1d5e:	00006597          	auipc	a1,0x6
    1d62:	4da58593          	addi	a1,a1,1242 # 8238 <malloc+0x173e>
    1d66:	4505                	li	a0,1
    1d68:	00005097          	auipc	ra,0x5
    1d6c:	934080e7          	jalr	-1740(ra) # 669c <exit>
    close(fds[0]);
    1d70:	fa842503          	lw	a0,-88(s0)
    1d74:	00005097          	auipc	ra,0x5
    1d78:	950080e7          	jalr	-1712(ra) # 66c4 <close>
    wait(&xstatus,0);
    1d7c:	4581                	li	a1,0
    1d7e:	fa440513          	addi	a0,s0,-92
    1d82:	00005097          	auipc	ra,0x5
    1d86:	922080e7          	jalr	-1758(ra) # 66a4 <wait>
    exit(xstatus,"");
    1d8a:	00006597          	auipc	a1,0x6
    1d8e:	4ae58593          	addi	a1,a1,1198 # 8238 <malloc+0x173e>
    1d92:	fa442503          	lw	a0,-92(s0)
    1d96:	00005097          	auipc	ra,0x5
    1d9a:	906080e7          	jalr	-1786(ra) # 669c <exit>
    printf("%s: fork() failed\n", s);
    1d9e:	85ca                	mv	a1,s2
    1da0:	00006517          	auipc	a0,0x6
    1da4:	89050513          	addi	a0,a0,-1904 # 7630 <malloc+0xb36>
    1da8:	00005097          	auipc	ra,0x5
    1dac:	c94080e7          	jalr	-876(ra) # 6a3c <printf>
    exit(1,"");
    1db0:	00006597          	auipc	a1,0x6
    1db4:	48858593          	addi	a1,a1,1160 # 8238 <malloc+0x173e>
    1db8:	4505                	li	a0,1
    1dba:	00005097          	auipc	ra,0x5
    1dbe:	8e2080e7          	jalr	-1822(ra) # 669c <exit>

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
    1dde:	8ba080e7          	jalr	-1862(ra) # 6694 <fork>
    1de2:	84aa                	mv	s1,a0
    if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <exitwait+0x58>
    if(pid){
    1de8:	cd59                	beqz	a0,1e86 <exitwait+0xc4>
      if(wait(&xstate,0) != pid){
    1dea:	4581                	li	a1,0
    1dec:	fcc40513          	addi	a0,s0,-52
    1df0:	00005097          	auipc	ra,0x5
    1df4:	8b4080e7          	jalr	-1868(ra) # 66a4 <wait>
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
    1e20:	6a450513          	addi	a0,a0,1700 # 74c0 <malloc+0x9c6>
    1e24:	00005097          	auipc	ra,0x5
    1e28:	c18080e7          	jalr	-1000(ra) # 6a3c <printf>
      exit(1,"");
    1e2c:	00006597          	auipc	a1,0x6
    1e30:	40c58593          	addi	a1,a1,1036 # 8238 <malloc+0x173e>
    1e34:	4505                	li	a0,1
    1e36:	00005097          	auipc	ra,0x5
    1e3a:	866080e7          	jalr	-1946(ra) # 669c <exit>
        printf("%s: wait wrong pid\n", s);
    1e3e:	85d2                	mv	a1,s4
    1e40:	00006517          	auipc	a0,0x6
    1e44:	80850513          	addi	a0,a0,-2040 # 7648 <malloc+0xb4e>
    1e48:	00005097          	auipc	ra,0x5
    1e4c:	bf4080e7          	jalr	-1036(ra) # 6a3c <printf>
        exit(1,"");
    1e50:	00006597          	auipc	a1,0x6
    1e54:	3e858593          	addi	a1,a1,1000 # 8238 <malloc+0x173e>
    1e58:	4505                	li	a0,1
    1e5a:	00005097          	auipc	ra,0x5
    1e5e:	842080e7          	jalr	-1982(ra) # 669c <exit>
        printf("%s: wait wrong exit status\n", s);
    1e62:	85d2                	mv	a1,s4
    1e64:	00005517          	auipc	a0,0x5
    1e68:	7fc50513          	addi	a0,a0,2044 # 7660 <malloc+0xb66>
    1e6c:	00005097          	auipc	ra,0x5
    1e70:	bd0080e7          	jalr	-1072(ra) # 6a3c <printf>
        exit(1,"");
    1e74:	00006597          	auipc	a1,0x6
    1e78:	3c458593          	addi	a1,a1,964 # 8238 <malloc+0x173e>
    1e7c:	4505                	li	a0,1
    1e7e:	00005097          	auipc	ra,0x5
    1e82:	81e080e7          	jalr	-2018(ra) # 669c <exit>
      exit(i,0);
    1e86:	4581                	li	a1,0
    1e88:	854a                	mv	a0,s2
    1e8a:	00005097          	auipc	ra,0x5
    1e8e:	812080e7          	jalr	-2030(ra) # 669c <exit>

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
    1ea8:	7f0080e7          	jalr	2032(ra) # 6694 <fork>
    if(pid1 < 0){
    1eac:	02054e63          	bltz	a0,1ee8 <twochildren+0x56>
    if(pid1 == 0){
    1eb0:	cd31                	beqz	a0,1f0c <twochildren+0x7a>
      int pid2 = fork();
    1eb2:	00004097          	auipc	ra,0x4
    1eb6:	7e2080e7          	jalr	2018(ra) # 6694 <fork>
      if(pid2 < 0){
    1eba:	06054163          	bltz	a0,1f1c <twochildren+0x8a>
      if(pid2 == 0){
    1ebe:	c149                	beqz	a0,1f40 <twochildren+0xae>
        wait(0,0);
    1ec0:	4581                	li	a1,0
    1ec2:	4501                	li	a0,0
    1ec4:	00004097          	auipc	ra,0x4
    1ec8:	7e0080e7          	jalr	2016(ra) # 66a4 <wait>
        wait(0,0);
    1ecc:	4581                	li	a1,0
    1ece:	4501                	li	a0,0
    1ed0:	00004097          	auipc	ra,0x4
    1ed4:	7d4080e7          	jalr	2004(ra) # 66a4 <wait>
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
    1eee:	5d650513          	addi	a0,a0,1494 # 74c0 <malloc+0x9c6>
    1ef2:	00005097          	auipc	ra,0x5
    1ef6:	b4a080e7          	jalr	-1206(ra) # 6a3c <printf>
      exit(1,"");
    1efa:	00006597          	auipc	a1,0x6
    1efe:	33e58593          	addi	a1,a1,830 # 8238 <malloc+0x173e>
    1f02:	4505                	li	a0,1
    1f04:	00004097          	auipc	ra,0x4
    1f08:	798080e7          	jalr	1944(ra) # 669c <exit>
      exit(0,"");
    1f0c:	00006597          	auipc	a1,0x6
    1f10:	32c58593          	addi	a1,a1,812 # 8238 <malloc+0x173e>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	788080e7          	jalr	1928(ra) # 669c <exit>
        printf("%s: fork failed\n", s);
    1f1c:	85ca                	mv	a1,s2
    1f1e:	00005517          	auipc	a0,0x5
    1f22:	5a250513          	addi	a0,a0,1442 # 74c0 <malloc+0x9c6>
    1f26:	00005097          	auipc	ra,0x5
    1f2a:	b16080e7          	jalr	-1258(ra) # 6a3c <printf>
        exit(1,"");
    1f2e:	00006597          	auipc	a1,0x6
    1f32:	30a58593          	addi	a1,a1,778 # 8238 <malloc+0x173e>
    1f36:	4505                	li	a0,1
    1f38:	00004097          	auipc	ra,0x4
    1f3c:	764080e7          	jalr	1892(ra) # 669c <exit>
        exit(0,"");
    1f40:	00006597          	auipc	a1,0x6
    1f44:	2f858593          	addi	a1,a1,760 # 8238 <malloc+0x173e>
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	754080e7          	jalr	1876(ra) # 669c <exit>

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
    1f60:	738080e7          	jalr	1848(ra) # 6694 <fork>
    if(pid < 0){
    1f64:	04054363          	bltz	a0,1faa <forkfork+0x5a>
    if(pid == 0){
    1f68:	c13d                	beqz	a0,1fce <forkfork+0x7e>
    int pid = fork();
    1f6a:	00004097          	auipc	ra,0x4
    1f6e:	72a080e7          	jalr	1834(ra) # 6694 <fork>
    if(pid < 0){
    1f72:	02054c63          	bltz	a0,1faa <forkfork+0x5a>
    if(pid == 0){
    1f76:	cd21                	beqz	a0,1fce <forkfork+0x7e>
    wait(&xstatus,0);
    1f78:	4581                	li	a1,0
    1f7a:	fdc40513          	addi	a0,s0,-36
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	726080e7          	jalr	1830(ra) # 66a4 <wait>
    if(xstatus != 0) {
    1f86:	fdc42783          	lw	a5,-36(s0)
    1f8a:	efc9                	bnez	a5,2024 <forkfork+0xd4>
    wait(&xstatus,0);
    1f8c:	4581                	li	a1,0
    1f8e:	fdc40513          	addi	a0,s0,-36
    1f92:	00004097          	auipc	ra,0x4
    1f96:	712080e7          	jalr	1810(ra) # 66a4 <wait>
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
    1fb0:	6d450513          	addi	a0,a0,1748 # 7680 <malloc+0xb86>
    1fb4:	00005097          	auipc	ra,0x5
    1fb8:	a88080e7          	jalr	-1400(ra) # 6a3c <printf>
      exit(1,"");
    1fbc:	00006597          	auipc	a1,0x6
    1fc0:	27c58593          	addi	a1,a1,636 # 8238 <malloc+0x173e>
    1fc4:	4505                	li	a0,1
    1fc6:	00004097          	auipc	ra,0x4
    1fca:	6d6080e7          	jalr	1750(ra) # 669c <exit>
{
    1fce:	0c800493          	li	s1,200
        int pid1 = fork();
    1fd2:	00004097          	auipc	ra,0x4
    1fd6:	6c2080e7          	jalr	1730(ra) # 6694 <fork>
        if(pid1 < 0){
    1fda:	02054463          	bltz	a0,2002 <forkfork+0xb2>
        if(pid1 == 0){
    1fde:	c91d                	beqz	a0,2014 <forkfork+0xc4>
        wait(0,0);
    1fe0:	4581                	li	a1,0
    1fe2:	4501                	li	a0,0
    1fe4:	00004097          	auipc	ra,0x4
    1fe8:	6c0080e7          	jalr	1728(ra) # 66a4 <wait>
      for(int j = 0; j < 200; j++){
    1fec:	34fd                	addiw	s1,s1,-1
    1fee:	f0f5                	bnez	s1,1fd2 <forkfork+0x82>
      exit(0,"");
    1ff0:	00006597          	auipc	a1,0x6
    1ff4:	24858593          	addi	a1,a1,584 # 8238 <malloc+0x173e>
    1ff8:	4501                	li	a0,0
    1ffa:	00004097          	auipc	ra,0x4
    1ffe:	6a2080e7          	jalr	1698(ra) # 669c <exit>
          exit(1,"");
    2002:	00006597          	auipc	a1,0x6
    2006:	23658593          	addi	a1,a1,566 # 8238 <malloc+0x173e>
    200a:	4505                	li	a0,1
    200c:	00004097          	auipc	ra,0x4
    2010:	690080e7          	jalr	1680(ra) # 669c <exit>
          exit(0,"");
    2014:	00006597          	auipc	a1,0x6
    2018:	22458593          	addi	a1,a1,548 # 8238 <malloc+0x173e>
    201c:	00004097          	auipc	ra,0x4
    2020:	680080e7          	jalr	1664(ra) # 669c <exit>
      printf("%s: fork in child failed", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	66a50513          	addi	a0,a0,1642 # 7690 <malloc+0xb96>
    202e:	00005097          	auipc	ra,0x5
    2032:	a0e080e7          	jalr	-1522(ra) # 6a3c <printf>
      exit(1,"");
    2036:	00006597          	auipc	a1,0x6
    203a:	20258593          	addi	a1,a1,514 # 8238 <malloc+0x173e>
    203e:	4505                	li	a0,1
    2040:	00004097          	auipc	ra,0x4
    2044:	65c080e7          	jalr	1628(ra) # 669c <exit>

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
    205a:	63e080e7          	jalr	1598(ra) # 6694 <fork>
    if(pid1 < 0){
    205e:	02054463          	bltz	a0,2086 <reparent2+0x3e>
    if(pid1 == 0){
    2062:	c139                	beqz	a0,20a8 <reparent2+0x60>
    wait(0,0);
    2064:	4581                	li	a1,0
    2066:	4501                	li	a0,0
    2068:	00004097          	auipc	ra,0x4
    206c:	63c080e7          	jalr	1596(ra) # 66a4 <wait>
  for(int i = 0; i < 800; i++){
    2070:	34fd                	addiw	s1,s1,-1
    2072:	f0f5                	bnez	s1,2056 <reparent2+0xe>
  exit(0,"");
    2074:	00006597          	auipc	a1,0x6
    2078:	1c458593          	addi	a1,a1,452 # 8238 <malloc+0x173e>
    207c:	4501                	li	a0,0
    207e:	00004097          	auipc	ra,0x4
    2082:	61e080e7          	jalr	1566(ra) # 669c <exit>
      printf("fork failed\n");
    2086:	00006517          	auipc	a0,0x6
    208a:	85250513          	addi	a0,a0,-1966 # 78d8 <malloc+0xdde>
    208e:	00005097          	auipc	ra,0x5
    2092:	9ae080e7          	jalr	-1618(ra) # 6a3c <printf>
      exit(1,"");
    2096:	00006597          	auipc	a1,0x6
    209a:	1a258593          	addi	a1,a1,418 # 8238 <malloc+0x173e>
    209e:	4505                	li	a0,1
    20a0:	00004097          	auipc	ra,0x4
    20a4:	5fc080e7          	jalr	1532(ra) # 669c <exit>
      fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	5ec080e7          	jalr	1516(ra) # 6694 <fork>
      fork();
    20b0:	00004097          	auipc	ra,0x4
    20b4:	5e4080e7          	jalr	1508(ra) # 6694 <fork>
      exit(0,"");
    20b8:	00006597          	auipc	a1,0x6
    20bc:	18058593          	addi	a1,a1,384 # 8238 <malloc+0x173e>
    20c0:	4501                	li	a0,0
    20c2:	00004097          	auipc	ra,0x4
    20c6:	5da080e7          	jalr	1498(ra) # 669c <exit>

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
    20ee:	5aa080e7          	jalr	1450(ra) # 6694 <fork>
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
    210c:	59c080e7          	jalr	1436(ra) # 66a4 <wait>
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
    213a:	7a250513          	addi	a0,a0,1954 # 78d8 <malloc+0xdde>
    213e:	00005097          	auipc	ra,0x5
    2142:	8fe080e7          	jalr	-1794(ra) # 6a3c <printf>
      exit(1,"");
    2146:	00006597          	auipc	a1,0x6
    214a:	0f258593          	addi	a1,a1,242 # 8238 <malloc+0x173e>
    214e:	4505                	li	a0,1
    2150:	00004097          	auipc	ra,0x4
    2154:	54c080e7          	jalr	1356(ra) # 669c <exit>
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
    216e:	3ee50513          	addi	a0,a0,1006 # 7558 <malloc+0xa5e>
    2172:	00005097          	auipc	ra,0x5
    2176:	8ca080e7          	jalr	-1846(ra) # 6a3c <printf>
          exit(1,"");
    217a:	00006597          	auipc	a1,0x6
    217e:	0be58593          	addi	a1,a1,190 # 8238 <malloc+0x173e>
    2182:	4505                	li	a0,1
    2184:	00004097          	auipc	ra,0x4
    2188:	518080e7          	jalr	1304(ra) # 669c <exit>
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
    21a6:	53a080e7          	jalr	1338(ra) # 66dc <open>
        if(fd < 0){
    21aa:	fa054fe3          	bltz	a0,2168 <createdelete+0x9e>
        close(fd);
    21ae:	00004097          	auipc	ra,0x4
    21b2:	516080e7          	jalr	1302(ra) # 66c4 <close>
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
    21da:	516080e7          	jalr	1302(ra) # 66ec <unlink>
    21de:	fa0557e3          	bgez	a0,218c <createdelete+0xc2>
            printf("%s: unlink failed\n", s);
    21e2:	85e6                	mv	a1,s9
    21e4:	00005517          	auipc	a0,0x5
    21e8:	4cc50513          	addi	a0,a0,1228 # 76b0 <malloc+0xbb6>
    21ec:	00005097          	auipc	ra,0x5
    21f0:	850080e7          	jalr	-1968(ra) # 6a3c <printf>
            exit(1,"");
    21f4:	00006597          	auipc	a1,0x6
    21f8:	04458593          	addi	a1,a1,68 # 8238 <malloc+0x173e>
    21fc:	4505                	li	a0,1
    21fe:	00004097          	auipc	ra,0x4
    2202:	49e080e7          	jalr	1182(ra) # 669c <exit>
      exit(0,"");
    2206:	00006597          	auipc	a1,0x6
    220a:	03258593          	addi	a1,a1,50 # 8238 <malloc+0x173e>
    220e:	4501                	li	a0,0
    2210:	00004097          	auipc	ra,0x4
    2214:	48c080e7          	jalr	1164(ra) # 669c <exit>
      exit(1,"");
    2218:	00006597          	auipc	a1,0x6
    221c:	02058593          	addi	a1,a1,32 # 8238 <malloc+0x173e>
    2220:	4505                	li	a0,1
    2222:	00004097          	auipc	ra,0x4
    2226:	47a080e7          	jalr	1146(ra) # 669c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    222a:	f8040613          	addi	a2,s0,-128
    222e:	85e6                	mv	a1,s9
    2230:	00005517          	auipc	a0,0x5
    2234:	49850513          	addi	a0,a0,1176 # 76c8 <malloc+0xbce>
    2238:	00005097          	auipc	ra,0x5
    223c:	804080e7          	jalr	-2044(ra) # 6a3c <printf>
        exit(1,"");
    2240:	00006597          	auipc	a1,0x6
    2244:	ff858593          	addi	a1,a1,-8 # 8238 <malloc+0x173e>
    2248:	4505                	li	a0,1
    224a:	00004097          	auipc	ra,0x4
    224e:	452080e7          	jalr	1106(ra) # 669c <exit>
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
    2276:	46a080e7          	jalr	1130(ra) # 66dc <open>
      if((i == 0 || i >= N/2) && fd < 0){
    227a:	00090463          	beqz	s2,2282 <createdelete+0x1b8>
    227e:	fd2bdae3          	bge	s7,s2,2252 <createdelete+0x188>
    2282:	fa0544e3          	bltz	a0,222a <createdelete+0x160>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2286:	014b7963          	bgeu	s6,s4,2298 <createdelete+0x1ce>
        close(fd);
    228a:	00004097          	auipc	ra,0x4
    228e:	43a080e7          	jalr	1082(ra) # 66c4 <close>
    2292:	b7e1                	j	225a <createdelete+0x190>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2294:	fc0543e3          	bltz	a0,225a <createdelete+0x190>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2298:	f8040613          	addi	a2,s0,-128
    229c:	85e6                	mv	a1,s9
    229e:	00005517          	auipc	a0,0x5
    22a2:	45250513          	addi	a0,a0,1106 # 76f0 <malloc+0xbf6>
    22a6:	00004097          	auipc	ra,0x4
    22aa:	796080e7          	jalr	1942(ra) # 6a3c <printf>
        exit(1,"");
    22ae:	00006597          	auipc	a1,0x6
    22b2:	f8a58593          	addi	a1,a1,-118 # 8238 <malloc+0x173e>
    22b6:	4505                	li	a0,1
    22b8:	00004097          	auipc	ra,0x4
    22bc:	3e4080e7          	jalr	996(ra) # 669c <exit>
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
    22f6:	3fa080e7          	jalr	1018(ra) # 66ec <unlink>
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
    234a:	96250513          	addi	a0,a0,-1694 # 6ca8 <malloc+0x1ae>
    234e:	00004097          	auipc	ra,0x4
    2352:	39e080e7          	jalr	926(ra) # 66ec <unlink>
  pid = fork();
    2356:	00004097          	auipc	ra,0x4
    235a:	33e080e7          	jalr	830(ra) # 6694 <fork>
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
    2386:	926a8a93          	addi	s5,s5,-1754 # 6ca8 <malloc+0x1ae>
      link("cat", "x");
    238a:	00005b97          	auipc	s7,0x5
    238e:	38eb8b93          	addi	s7,s7,910 # 7718 <malloc+0xc1e>
    2392:	a081                	j	23d2 <linkunlink+0xa8>
    printf("%s: fork failed\n", s);
    2394:	85a6                	mv	a1,s1
    2396:	00005517          	auipc	a0,0x5
    239a:	12a50513          	addi	a0,a0,298 # 74c0 <malloc+0x9c6>
    239e:	00004097          	auipc	ra,0x4
    23a2:	69e080e7          	jalr	1694(ra) # 6a3c <printf>
    exit(1,"");
    23a6:	00006597          	auipc	a1,0x6
    23aa:	e9258593          	addi	a1,a1,-366 # 8238 <malloc+0x173e>
    23ae:	4505                	li	a0,1
    23b0:	00004097          	auipc	ra,0x4
    23b4:	2ec080e7          	jalr	748(ra) # 669c <exit>
      close(open("x", O_RDWR | O_CREATE));
    23b8:	20200593          	li	a1,514
    23bc:	8556                	mv	a0,s5
    23be:	00004097          	auipc	ra,0x4
    23c2:	31e080e7          	jalr	798(ra) # 66dc <open>
    23c6:	00004097          	auipc	ra,0x4
    23ca:	2fe080e7          	jalr	766(ra) # 66c4 <close>
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
    23ee:	302080e7          	jalr	770(ra) # 66ec <unlink>
    23f2:	bff1                	j	23ce <linkunlink+0xa4>
      link("cat", "x");
    23f4:	85d6                	mv	a1,s5
    23f6:	855e                	mv	a0,s7
    23f8:	00004097          	auipc	ra,0x4
    23fc:	304080e7          	jalr	772(ra) # 66fc <link>
    2400:	b7f9                	j	23ce <linkunlink+0xa4>
  if(pid)
    2402:	020c0563          	beqz	s8,242c <linkunlink+0x102>
    wait(0,0);
    2406:	4581                	li	a1,0
    2408:	4501                	li	a0,0
    240a:	00004097          	auipc	ra,0x4
    240e:	29a080e7          	jalr	666(ra) # 66a4 <wait>
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
    2430:	e0c58593          	addi	a1,a1,-500 # 8238 <malloc+0x173e>
    2434:	4501                	li	a0,0
    2436:	00004097          	auipc	ra,0x4
    243a:	266080e7          	jalr	614(ra) # 669c <exit>

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
    2458:	240080e7          	jalr	576(ra) # 6694 <fork>
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
    246e:	2ce50513          	addi	a0,a0,718 # 7738 <malloc+0xc3e>
    2472:	00004097          	auipc	ra,0x4
    2476:	5ca080e7          	jalr	1482(ra) # 6a3c <printf>
    exit(1,"");
    247a:	00006597          	auipc	a1,0x6
    247e:	dbe58593          	addi	a1,a1,-578 # 8238 <malloc+0x173e>
    2482:	4505                	li	a0,1
    2484:	00004097          	auipc	ra,0x4
    2488:	218080e7          	jalr	536(ra) # 669c <exit>
      exit(0,"");
    248c:	00006597          	auipc	a1,0x6
    2490:	dac58593          	addi	a1,a1,-596 # 8238 <malloc+0x173e>
    2494:	00004097          	auipc	ra,0x4
    2498:	208080e7          	jalr	520(ra) # 669c <exit>
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
    24b2:	1f6080e7          	jalr	502(ra) # 66a4 <wait>
    24b6:	04054663          	bltz	a0,2502 <forktest+0xc4>
  for(; n > 0; n--){
    24ba:	34fd                	addiw	s1,s1,-1
    24bc:	f4fd                	bnez	s1,24aa <forktest+0x6c>
  if(wait(0,0) != -1){
    24be:	4581                	li	a1,0
    24c0:	4501                	li	a0,0
    24c2:	00004097          	auipc	ra,0x4
    24c6:	1e2080e7          	jalr	482(ra) # 66a4 <wait>
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
    24e4:	24050513          	addi	a0,a0,576 # 7720 <malloc+0xc26>
    24e8:	00004097          	auipc	ra,0x4
    24ec:	554080e7          	jalr	1364(ra) # 6a3c <printf>
    exit(1,"");
    24f0:	00006597          	auipc	a1,0x6
    24f4:	d4858593          	addi	a1,a1,-696 # 8238 <malloc+0x173e>
    24f8:	4505                	li	a0,1
    24fa:	00004097          	auipc	ra,0x4
    24fe:	1a2080e7          	jalr	418(ra) # 669c <exit>
      printf("%s: wait stopped early\n", s);
    2502:	85ce                	mv	a1,s3
    2504:	00005517          	auipc	a0,0x5
    2508:	25c50513          	addi	a0,a0,604 # 7760 <malloc+0xc66>
    250c:	00004097          	auipc	ra,0x4
    2510:	530080e7          	jalr	1328(ra) # 6a3c <printf>
      exit(1,"");
    2514:	00006597          	auipc	a1,0x6
    2518:	d2458593          	addi	a1,a1,-732 # 8238 <malloc+0x173e>
    251c:	4505                	li	a0,1
    251e:	00004097          	auipc	ra,0x4
    2522:	17e080e7          	jalr	382(ra) # 669c <exit>
    printf("%s: wait got too many\n", s);
    2526:	85ce                	mv	a1,s3
    2528:	00005517          	auipc	a0,0x5
    252c:	25050513          	addi	a0,a0,592 # 7778 <malloc+0xc7e>
    2530:	00004097          	auipc	ra,0x4
    2534:	50c080e7          	jalr	1292(ra) # 6a3c <printf>
    exit(1,"");
    2538:	00006597          	auipc	a1,0x6
    253c:	d0058593          	addi	a1,a1,-768 # 8238 <malloc+0x173e>
    2540:	4505                	li	a0,1
    2542:	00004097          	auipc	ra,0x4
    2546:	15a080e7          	jalr	346(ra) # 669c <exit>

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
    255a:	e85a                	sd	s6,16(sp)
    255c:	0880                	addi	s0,sp,80
    255e:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2560:	4485                	li	s1,1
    2562:	04fe                	slli	s1,s1,0x1f
    printf("%s\n","r u here?");
    2564:	00005a97          	auipc	s5,0x5
    2568:	24ca8a93          	addi	s5,s5,588 # 77b0 <malloc+0xcb6>
    256c:	00006a17          	auipc	s4,0x6
    2570:	5c4a0a13          	addi	s4,s4,1476 # 8b30 <malloc+0x2036>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2574:	69b1                	lui	s3,0xc
    2576:	35098993          	addi	s3,s3,848 # c350 <uninit+0xde8>
    257a:	1003d937          	lui	s2,0x1003d
    257e:	090e                	slli	s2,s2,0x3
    2580:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c808>
    pid = fork();
    2584:	00004097          	auipc	ra,0x4
    2588:	110080e7          	jalr	272(ra) # 6694 <fork>
    if(pid < 0){
    258c:	04054263          	bltz	a0,25d0 <kernmem+0x86>
    if(pid == 0){
    2590:	c135                	beqz	a0,25f4 <kernmem+0xaa>
    printf("%s\n","r u here?");
    2592:	85d6                	mv	a1,s5
    2594:	8552                	mv	a0,s4
    2596:	00004097          	auipc	ra,0x4
    259a:	4a6080e7          	jalr	1190(ra) # 6a3c <printf>
    wait(&xstatus,0);
    259e:	4581                	li	a1,0
    25a0:	fbc40513          	addi	a0,s0,-68
    25a4:	00004097          	auipc	ra,0x4
    25a8:	100080e7          	jalr	256(ra) # 66a4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    25ac:	fbc42703          	lw	a4,-68(s0)
    25b0:	57fd                	li	a5,-1
    25b2:	06f71663          	bne	a4,a5,261e <kernmem+0xd4>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    25b6:	94ce                	add	s1,s1,s3
    25b8:	fd2496e3          	bne	s1,s2,2584 <kernmem+0x3a>
}
    25bc:	60a6                	ld	ra,72(sp)
    25be:	6406                	ld	s0,64(sp)
    25c0:	74e2                	ld	s1,56(sp)
    25c2:	7942                	ld	s2,48(sp)
    25c4:	79a2                	ld	s3,40(sp)
    25c6:	7a02                	ld	s4,32(sp)
    25c8:	6ae2                	ld	s5,24(sp)
    25ca:	6b42                	ld	s6,16(sp)
    25cc:	6161                	addi	sp,sp,80
    25ce:	8082                	ret
      printf("%s: fork failed\n", s);
    25d0:	85da                	mv	a1,s6
    25d2:	00005517          	auipc	a0,0x5
    25d6:	eee50513          	addi	a0,a0,-274 # 74c0 <malloc+0x9c6>
    25da:	00004097          	auipc	ra,0x4
    25de:	462080e7          	jalr	1122(ra) # 6a3c <printf>
      exit(1,"");
    25e2:	00006597          	auipc	a1,0x6
    25e6:	c5658593          	addi	a1,a1,-938 # 8238 <malloc+0x173e>
    25ea:	4505                	li	a0,1
    25ec:	00004097          	auipc	ra,0x4
    25f0:	0b0080e7          	jalr	176(ra) # 669c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    25f4:	0004c683          	lbu	a3,0(s1)
    25f8:	8626                	mv	a2,s1
    25fa:	85da                	mv	a1,s6
    25fc:	00005517          	auipc	a0,0x5
    2600:	19450513          	addi	a0,a0,404 # 7790 <malloc+0xc96>
    2604:	00004097          	auipc	ra,0x4
    2608:	438080e7          	jalr	1080(ra) # 6a3c <printf>
      exit(1,"");
    260c:	00006597          	auipc	a1,0x6
    2610:	c2c58593          	addi	a1,a1,-980 # 8238 <malloc+0x173e>
    2614:	4505                	li	a0,1
    2616:	00004097          	auipc	ra,0x4
    261a:	086080e7          	jalr	134(ra) # 669c <exit>
      exit(1,"");
    261e:	00006597          	auipc	a1,0x6
    2622:	c1a58593          	addi	a1,a1,-998 # 8238 <malloc+0x173e>
    2626:	4505                	li	a0,1
    2628:	00004097          	auipc	ra,0x4
    262c:	074080e7          	jalr	116(ra) # 669c <exit>

0000000000002630 <MAXVAplus>:
{
    2630:	7179                	addi	sp,sp,-48
    2632:	f406                	sd	ra,40(sp)
    2634:	f022                	sd	s0,32(sp)
    2636:	ec26                	sd	s1,24(sp)
    2638:	e84a                	sd	s2,16(sp)
    263a:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    263c:	4785                	li	a5,1
    263e:	179a                	slli	a5,a5,0x26
    2640:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2644:	fd843783          	ld	a5,-40(s0)
    2648:	cf8d                	beqz	a5,2682 <MAXVAplus+0x52>
    264a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    264c:	54fd                	li	s1,-1
    pid = fork();
    264e:	00004097          	auipc	ra,0x4
    2652:	046080e7          	jalr	70(ra) # 6694 <fork>
    if(pid < 0){
    2656:	02054c63          	bltz	a0,268e <MAXVAplus+0x5e>
    if(pid == 0){
    265a:	cd21                	beqz	a0,26b2 <MAXVAplus+0x82>
    wait(&xstatus,0);
    265c:	4581                	li	a1,0
    265e:	fd440513          	addi	a0,s0,-44
    2662:	00004097          	auipc	ra,0x4
    2666:	042080e7          	jalr	66(ra) # 66a4 <wait>
    if(xstatus != -1)  // did kernel kill child?
    266a:	fd442783          	lw	a5,-44(s0)
    266e:	06979c63          	bne	a5,s1,26e6 <MAXVAplus+0xb6>
  for( ; a != 0; a <<= 1){
    2672:	fd843783          	ld	a5,-40(s0)
    2676:	0786                	slli	a5,a5,0x1
    2678:	fcf43c23          	sd	a5,-40(s0)
    267c:	fd843783          	ld	a5,-40(s0)
    2680:	f7f9                	bnez	a5,264e <MAXVAplus+0x1e>
}
    2682:	70a2                	ld	ra,40(sp)
    2684:	7402                	ld	s0,32(sp)
    2686:	64e2                	ld	s1,24(sp)
    2688:	6942                	ld	s2,16(sp)
    268a:	6145                	addi	sp,sp,48
    268c:	8082                	ret
      printf("%s: fork failed\n", s);
    268e:	85ca                	mv	a1,s2
    2690:	00005517          	auipc	a0,0x5
    2694:	e3050513          	addi	a0,a0,-464 # 74c0 <malloc+0x9c6>
    2698:	00004097          	auipc	ra,0x4
    269c:	3a4080e7          	jalr	932(ra) # 6a3c <printf>
      exit(1,"");
    26a0:	00006597          	auipc	a1,0x6
    26a4:	b9858593          	addi	a1,a1,-1128 # 8238 <malloc+0x173e>
    26a8:	4505                	li	a0,1
    26aa:	00004097          	auipc	ra,0x4
    26ae:	ff2080e7          	jalr	-14(ra) # 669c <exit>
      *(char*)a = 99;
    26b2:	fd843783          	ld	a5,-40(s0)
    26b6:	06300713          	li	a4,99
    26ba:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    26be:	fd843603          	ld	a2,-40(s0)
    26c2:	85ca                	mv	a1,s2
    26c4:	00005517          	auipc	a0,0x5
    26c8:	0fc50513          	addi	a0,a0,252 # 77c0 <malloc+0xcc6>
    26cc:	00004097          	auipc	ra,0x4
    26d0:	370080e7          	jalr	880(ra) # 6a3c <printf>
      exit(1,"");
    26d4:	00006597          	auipc	a1,0x6
    26d8:	b6458593          	addi	a1,a1,-1180 # 8238 <malloc+0x173e>
    26dc:	4505                	li	a0,1
    26de:	00004097          	auipc	ra,0x4
    26e2:	fbe080e7          	jalr	-66(ra) # 669c <exit>
      exit(1,"");
    26e6:	00006597          	auipc	a1,0x6
    26ea:	b5258593          	addi	a1,a1,-1198 # 8238 <malloc+0x173e>
    26ee:	4505                	li	a0,1
    26f0:	00004097          	auipc	ra,0x4
    26f4:	fac080e7          	jalr	-84(ra) # 669c <exit>

00000000000026f8 <bigargtest>:
{
    26f8:	7179                	addi	sp,sp,-48
    26fa:	f406                	sd	ra,40(sp)
    26fc:	f022                	sd	s0,32(sp)
    26fe:	ec26                	sd	s1,24(sp)
    2700:	1800                	addi	s0,sp,48
    2702:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2704:	00005517          	auipc	a0,0x5
    2708:	0d450513          	addi	a0,a0,212 # 77d8 <malloc+0xcde>
    270c:	00004097          	auipc	ra,0x4
    2710:	fe0080e7          	jalr	-32(ra) # 66ec <unlink>
  pid = fork();
    2714:	00004097          	auipc	ra,0x4
    2718:	f80080e7          	jalr	-128(ra) # 6694 <fork>
  if(pid == 0){
    271c:	c129                	beqz	a0,275e <bigargtest+0x66>
  } else if(pid < 0){
    271e:	0a054563          	bltz	a0,27c8 <bigargtest+0xd0>
  wait(&xstatus,0);
    2722:	4581                	li	a1,0
    2724:	fdc40513          	addi	a0,s0,-36
    2728:	00004097          	auipc	ra,0x4
    272c:	f7c080e7          	jalr	-132(ra) # 66a4 <wait>
  if(xstatus != 0)
    2730:	fdc42503          	lw	a0,-36(s0)
    2734:	ed45                	bnez	a0,27ec <bigargtest+0xf4>
  fd = open("bigarg-ok", 0);
    2736:	4581                	li	a1,0
    2738:	00005517          	auipc	a0,0x5
    273c:	0a050513          	addi	a0,a0,160 # 77d8 <malloc+0xcde>
    2740:	00004097          	auipc	ra,0x4
    2744:	f9c080e7          	jalr	-100(ra) # 66dc <open>
  if(fd < 0){
    2748:	0a054a63          	bltz	a0,27fc <bigargtest+0x104>
  close(fd);
    274c:	00004097          	auipc	ra,0x4
    2750:	f78080e7          	jalr	-136(ra) # 66c4 <close>
}
    2754:	70a2                	ld	ra,40(sp)
    2756:	7402                	ld	s0,32(sp)
    2758:	64e2                	ld	s1,24(sp)
    275a:	6145                	addi	sp,sp,48
    275c:	8082                	ret
    275e:	00008797          	auipc	a5,0x8
    2762:	d0278793          	addi	a5,a5,-766 # a460 <args.1>
    2766:	00008697          	auipc	a3,0x8
    276a:	df268693          	addi	a3,a3,-526 # a558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    276e:	00005717          	auipc	a4,0x5
    2772:	07a70713          	addi	a4,a4,122 # 77e8 <malloc+0xcee>
    2776:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2778:	07a1                	addi	a5,a5,8
    277a:	fed79ee3          	bne	a5,a3,2776 <bigargtest+0x7e>
    args[MAXARG-1] = 0;
    277e:	00008597          	auipc	a1,0x8
    2782:	ce258593          	addi	a1,a1,-798 # a460 <args.1>
    2786:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    278a:	00004517          	auipc	a0,0x4
    278e:	4ae50513          	addi	a0,a0,1198 # 6c38 <malloc+0x13e>
    2792:	00004097          	auipc	ra,0x4
    2796:	f42080e7          	jalr	-190(ra) # 66d4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    279a:	20000593          	li	a1,512
    279e:	00005517          	auipc	a0,0x5
    27a2:	03a50513          	addi	a0,a0,58 # 77d8 <malloc+0xcde>
    27a6:	00004097          	auipc	ra,0x4
    27aa:	f36080e7          	jalr	-202(ra) # 66dc <open>
    close(fd);
    27ae:	00004097          	auipc	ra,0x4
    27b2:	f16080e7          	jalr	-234(ra) # 66c4 <close>
    exit(0,"");
    27b6:	00006597          	auipc	a1,0x6
    27ba:	a8258593          	addi	a1,a1,-1406 # 8238 <malloc+0x173e>
    27be:	4501                	li	a0,0
    27c0:	00004097          	auipc	ra,0x4
    27c4:	edc080e7          	jalr	-292(ra) # 669c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    27c8:	85a6                	mv	a1,s1
    27ca:	00005517          	auipc	a0,0x5
    27ce:	0fe50513          	addi	a0,a0,254 # 78c8 <malloc+0xdce>
    27d2:	00004097          	auipc	ra,0x4
    27d6:	26a080e7          	jalr	618(ra) # 6a3c <printf>
    exit(1,"");
    27da:	00006597          	auipc	a1,0x6
    27de:	a5e58593          	addi	a1,a1,-1442 # 8238 <malloc+0x173e>
    27e2:	4505                	li	a0,1
    27e4:	00004097          	auipc	ra,0x4
    27e8:	eb8080e7          	jalr	-328(ra) # 669c <exit>
    exit(xstatus,"");
    27ec:	00006597          	auipc	a1,0x6
    27f0:	a4c58593          	addi	a1,a1,-1460 # 8238 <malloc+0x173e>
    27f4:	00004097          	auipc	ra,0x4
    27f8:	ea8080e7          	jalr	-344(ra) # 669c <exit>
    printf("%s: bigarg test failed!\n", s);
    27fc:	85a6                	mv	a1,s1
    27fe:	00005517          	auipc	a0,0x5
    2802:	0ea50513          	addi	a0,a0,234 # 78e8 <malloc+0xdee>
    2806:	00004097          	auipc	ra,0x4
    280a:	236080e7          	jalr	566(ra) # 6a3c <printf>
    exit(1,"");
    280e:	00006597          	auipc	a1,0x6
    2812:	a2a58593          	addi	a1,a1,-1494 # 8238 <malloc+0x173e>
    2816:	4505                	li	a0,1
    2818:	00004097          	auipc	ra,0x4
    281c:	e84080e7          	jalr	-380(ra) # 669c <exit>

0000000000002820 <stacktest>:
{
    2820:	7179                	addi	sp,sp,-48
    2822:	f406                	sd	ra,40(sp)
    2824:	f022                	sd	s0,32(sp)
    2826:	ec26                	sd	s1,24(sp)
    2828:	1800                	addi	s0,sp,48
    282a:	84aa                	mv	s1,a0
  pid = fork();
    282c:	00004097          	auipc	ra,0x4
    2830:	e68080e7          	jalr	-408(ra) # 6694 <fork>
  if(pid == 0) {
    2834:	c51d                	beqz	a0,2862 <stacktest+0x42>
  } else if(pid < 0){
    2836:	04054d63          	bltz	a0,2890 <stacktest+0x70>
  wait(&xstatus,0);
    283a:	4581                	li	a1,0
    283c:	fdc40513          	addi	a0,s0,-36
    2840:	00004097          	auipc	ra,0x4
    2844:	e64080e7          	jalr	-412(ra) # 66a4 <wait>
  if(xstatus == -1)  // kernel killed child?
    2848:	fdc42503          	lw	a0,-36(s0)
    284c:	57fd                	li	a5,-1
    284e:	06f50363          	beq	a0,a5,28b4 <stacktest+0x94>
    exit(xstatus,"");
    2852:	00006597          	auipc	a1,0x6
    2856:	9e658593          	addi	a1,a1,-1562 # 8238 <malloc+0x173e>
    285a:	00004097          	auipc	ra,0x4
    285e:	e42080e7          	jalr	-446(ra) # 669c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2862:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2864:	77fd                	lui	a5,0xfffff
    2866:	97ba                	add	a5,a5,a4
    2868:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee388>
    286c:	85a6                	mv	a1,s1
    286e:	00005517          	auipc	a0,0x5
    2872:	09a50513          	addi	a0,a0,154 # 7908 <malloc+0xe0e>
    2876:	00004097          	auipc	ra,0x4
    287a:	1c6080e7          	jalr	454(ra) # 6a3c <printf>
    exit(1,"");
    287e:	00006597          	auipc	a1,0x6
    2882:	9ba58593          	addi	a1,a1,-1606 # 8238 <malloc+0x173e>
    2886:	4505                	li	a0,1
    2888:	00004097          	auipc	ra,0x4
    288c:	e14080e7          	jalr	-492(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    2890:	85a6                	mv	a1,s1
    2892:	00005517          	auipc	a0,0x5
    2896:	c2e50513          	addi	a0,a0,-978 # 74c0 <malloc+0x9c6>
    289a:	00004097          	auipc	ra,0x4
    289e:	1a2080e7          	jalr	418(ra) # 6a3c <printf>
    exit(1,"");
    28a2:	00006597          	auipc	a1,0x6
    28a6:	99658593          	addi	a1,a1,-1642 # 8238 <malloc+0x173e>
    28aa:	4505                	li	a0,1
    28ac:	00004097          	auipc	ra,0x4
    28b0:	df0080e7          	jalr	-528(ra) # 669c <exit>
    exit(0,"");
    28b4:	00006597          	auipc	a1,0x6
    28b8:	98458593          	addi	a1,a1,-1660 # 8238 <malloc+0x173e>
    28bc:	4501                	li	a0,0
    28be:	00004097          	auipc	ra,0x4
    28c2:	dde080e7          	jalr	-546(ra) # 669c <exit>

00000000000028c6 <textwrite>:
{
    28c6:	7179                	addi	sp,sp,-48
    28c8:	f406                	sd	ra,40(sp)
    28ca:	f022                	sd	s0,32(sp)
    28cc:	ec26                	sd	s1,24(sp)
    28ce:	1800                	addi	s0,sp,48
    28d0:	84aa                	mv	s1,a0
  pid = fork();
    28d2:	00004097          	auipc	ra,0x4
    28d6:	dc2080e7          	jalr	-574(ra) # 6694 <fork>
  if(pid == 0) {
    28da:	c51d                	beqz	a0,2908 <textwrite+0x42>
  } else if(pid < 0){
    28dc:	04054263          	bltz	a0,2920 <textwrite+0x5a>
  wait(&xstatus,0);
    28e0:	4581                	li	a1,0
    28e2:	fdc40513          	addi	a0,s0,-36
    28e6:	00004097          	auipc	ra,0x4
    28ea:	dbe080e7          	jalr	-578(ra) # 66a4 <wait>
  if(xstatus == -1)  // kernel killed child?
    28ee:	fdc42503          	lw	a0,-36(s0)
    28f2:	57fd                	li	a5,-1
    28f4:	04f50863          	beq	a0,a5,2944 <textwrite+0x7e>
    exit(xstatus,"");
    28f8:	00006597          	auipc	a1,0x6
    28fc:	94058593          	addi	a1,a1,-1728 # 8238 <malloc+0x173e>
    2900:	00004097          	auipc	ra,0x4
    2904:	d9c080e7          	jalr	-612(ra) # 669c <exit>
    *addr = 10;
    2908:	47a9                	li	a5,10
    290a:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1,"");
    290e:	00006597          	auipc	a1,0x6
    2912:	92a58593          	addi	a1,a1,-1750 # 8238 <malloc+0x173e>
    2916:	4505                	li	a0,1
    2918:	00004097          	auipc	ra,0x4
    291c:	d84080e7          	jalr	-636(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    2920:	85a6                	mv	a1,s1
    2922:	00005517          	auipc	a0,0x5
    2926:	b9e50513          	addi	a0,a0,-1122 # 74c0 <malloc+0x9c6>
    292a:	00004097          	auipc	ra,0x4
    292e:	112080e7          	jalr	274(ra) # 6a3c <printf>
    exit(1,"");
    2932:	00006597          	auipc	a1,0x6
    2936:	90658593          	addi	a1,a1,-1786 # 8238 <malloc+0x173e>
    293a:	4505                	li	a0,1
    293c:	00004097          	auipc	ra,0x4
    2940:	d60080e7          	jalr	-672(ra) # 669c <exit>
    exit(0,"");
    2944:	00006597          	auipc	a1,0x6
    2948:	8f458593          	addi	a1,a1,-1804 # 8238 <malloc+0x173e>
    294c:	4501                	li	a0,0
    294e:	00004097          	auipc	ra,0x4
    2952:	d4e080e7          	jalr	-690(ra) # 669c <exit>

0000000000002956 <manywrites>:
{
    2956:	711d                	addi	sp,sp,-96
    2958:	ec86                	sd	ra,88(sp)
    295a:	e8a2                	sd	s0,80(sp)
    295c:	e4a6                	sd	s1,72(sp)
    295e:	e0ca                	sd	s2,64(sp)
    2960:	fc4e                	sd	s3,56(sp)
    2962:	f852                	sd	s4,48(sp)
    2964:	f456                	sd	s5,40(sp)
    2966:	f05a                	sd	s6,32(sp)
    2968:	ec5e                	sd	s7,24(sp)
    296a:	1080                	addi	s0,sp,96
    296c:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    296e:	4981                	li	s3,0
    2970:	4911                	li	s2,4
    int pid = fork();
    2972:	00004097          	auipc	ra,0x4
    2976:	d22080e7          	jalr	-734(ra) # 6694 <fork>
    297a:	84aa                	mv	s1,a0
    if(pid < 0){
    297c:	02054f63          	bltz	a0,29ba <manywrites+0x64>
    if(pid == 0){
    2980:	cd31                	beqz	a0,29dc <manywrites+0x86>
  for(int ci = 0; ci < nchildren; ci++){
    2982:	2985                	addiw	s3,s3,1
    2984:	ff2997e3          	bne	s3,s2,2972 <manywrites+0x1c>
    2988:	4491                	li	s1,4
    int st = 0;
    298a:	fa042423          	sw	zero,-88(s0)
    wait(&st,0);
    298e:	4581                	li	a1,0
    2990:	fa840513          	addi	a0,s0,-88
    2994:	00004097          	auipc	ra,0x4
    2998:	d10080e7          	jalr	-752(ra) # 66a4 <wait>
    if(st != 0)
    299c:	fa842503          	lw	a0,-88(s0)
    29a0:	12051263          	bnez	a0,2ac4 <manywrites+0x16e>
  for(int ci = 0; ci < nchildren; ci++){
    29a4:	34fd                	addiw	s1,s1,-1
    29a6:	f0f5                	bnez	s1,298a <manywrites+0x34>
  exit(0,"");
    29a8:	00006597          	auipc	a1,0x6
    29ac:	89058593          	addi	a1,a1,-1904 # 8238 <malloc+0x173e>
    29b0:	4501                	li	a0,0
    29b2:	00004097          	auipc	ra,0x4
    29b6:	cea080e7          	jalr	-790(ra) # 669c <exit>
      printf("fork failed\n");
    29ba:	00005517          	auipc	a0,0x5
    29be:	f1e50513          	addi	a0,a0,-226 # 78d8 <malloc+0xdde>
    29c2:	00004097          	auipc	ra,0x4
    29c6:	07a080e7          	jalr	122(ra) # 6a3c <printf>
      exit(1,"");
    29ca:	00006597          	auipc	a1,0x6
    29ce:	86e58593          	addi	a1,a1,-1938 # 8238 <malloc+0x173e>
    29d2:	4505                	li	a0,1
    29d4:	00004097          	auipc	ra,0x4
    29d8:	cc8080e7          	jalr	-824(ra) # 669c <exit>
      name[0] = 'b';
    29dc:	06200793          	li	a5,98
    29e0:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    29e4:	0619879b          	addiw	a5,s3,97
    29e8:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    29ec:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    29f0:	fa840513          	addi	a0,s0,-88
    29f4:	00004097          	auipc	ra,0x4
    29f8:	cf8080e7          	jalr	-776(ra) # 66ec <unlink>
    29fc:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    29fe:	0000bb17          	auipc	s6,0xb
    2a02:	27ab0b13          	addi	s6,s6,634 # dc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2a06:	8a26                	mv	s4,s1
    2a08:	0209ce63          	bltz	s3,2a44 <manywrites+0xee>
          int fd = open(name, O_CREATE | O_RDWR);
    2a0c:	20200593          	li	a1,514
    2a10:	fa840513          	addi	a0,s0,-88
    2a14:	00004097          	auipc	ra,0x4
    2a18:	cc8080e7          	jalr	-824(ra) # 66dc <open>
    2a1c:	892a                	mv	s2,a0
          if(fd < 0){
    2a1e:	04054b63          	bltz	a0,2a74 <manywrites+0x11e>
          int cc = write(fd, buf, sz);
    2a22:	660d                	lui	a2,0x3
    2a24:	85da                	mv	a1,s6
    2a26:	00004097          	auipc	ra,0x4
    2a2a:	c96080e7          	jalr	-874(ra) # 66bc <write>
          if(cc != sz){
    2a2e:	678d                	lui	a5,0x3
    2a30:	06f51663          	bne	a0,a5,2a9c <manywrites+0x146>
          close(fd);
    2a34:	854a                	mv	a0,s2
    2a36:	00004097          	auipc	ra,0x4
    2a3a:	c8e080e7          	jalr	-882(ra) # 66c4 <close>
        for(int i = 0; i < ci+1; i++){
    2a3e:	2a05                	addiw	s4,s4,1
    2a40:	fd49d6e3          	bge	s3,s4,2a0c <manywrites+0xb6>
        unlink(name);
    2a44:	fa840513          	addi	a0,s0,-88
    2a48:	00004097          	auipc	ra,0x4
    2a4c:	ca4080e7          	jalr	-860(ra) # 66ec <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2a50:	3bfd                	addiw	s7,s7,-1
    2a52:	fa0b9ae3          	bnez	s7,2a06 <manywrites+0xb0>
      unlink(name);
    2a56:	fa840513          	addi	a0,s0,-88
    2a5a:	00004097          	auipc	ra,0x4
    2a5e:	c92080e7          	jalr	-878(ra) # 66ec <unlink>
      exit(0,"");
    2a62:	00005597          	auipc	a1,0x5
    2a66:	7d658593          	addi	a1,a1,2006 # 8238 <malloc+0x173e>
    2a6a:	4501                	li	a0,0
    2a6c:	00004097          	auipc	ra,0x4
    2a70:	c30080e7          	jalr	-976(ra) # 669c <exit>
            printf("%s: cannot create %s\n", s, name);
    2a74:	fa840613          	addi	a2,s0,-88
    2a78:	85d6                	mv	a1,s5
    2a7a:	00005517          	auipc	a0,0x5
    2a7e:	eb650513          	addi	a0,a0,-330 # 7930 <malloc+0xe36>
    2a82:	00004097          	auipc	ra,0x4
    2a86:	fba080e7          	jalr	-70(ra) # 6a3c <printf>
            exit(1,"");
    2a8a:	00005597          	auipc	a1,0x5
    2a8e:	7ae58593          	addi	a1,a1,1966 # 8238 <malloc+0x173e>
    2a92:	4505                	li	a0,1
    2a94:	00004097          	auipc	ra,0x4
    2a98:	c08080e7          	jalr	-1016(ra) # 669c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2a9c:	86aa                	mv	a3,a0
    2a9e:	660d                	lui	a2,0x3
    2aa0:	85d6                	mv	a1,s5
    2aa2:	00004517          	auipc	a0,0x4
    2aa6:	26650513          	addi	a0,a0,614 # 6d08 <malloc+0x20e>
    2aaa:	00004097          	auipc	ra,0x4
    2aae:	f92080e7          	jalr	-110(ra) # 6a3c <printf>
            exit(1,"");
    2ab2:	00005597          	auipc	a1,0x5
    2ab6:	78658593          	addi	a1,a1,1926 # 8238 <malloc+0x173e>
    2aba:	4505                	li	a0,1
    2abc:	00004097          	auipc	ra,0x4
    2ac0:	be0080e7          	jalr	-1056(ra) # 669c <exit>
      exit(st,"");
    2ac4:	00005597          	auipc	a1,0x5
    2ac8:	77458593          	addi	a1,a1,1908 # 8238 <malloc+0x173e>
    2acc:	00004097          	auipc	ra,0x4
    2ad0:	bd0080e7          	jalr	-1072(ra) # 669c <exit>

0000000000002ad4 <copyinstr3>:
{
    2ad4:	7179                	addi	sp,sp,-48
    2ad6:	f406                	sd	ra,40(sp)
    2ad8:	f022                	sd	s0,32(sp)
    2ada:	ec26                	sd	s1,24(sp)
    2adc:	1800                	addi	s0,sp,48
  sbrk(8192);
    2ade:	6509                	lui	a0,0x2
    2ae0:	00004097          	auipc	ra,0x4
    2ae4:	c44080e7          	jalr	-956(ra) # 6724 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2ae8:	4501                	li	a0,0
    2aea:	00004097          	auipc	ra,0x4
    2aee:	c3a080e7          	jalr	-966(ra) # 6724 <sbrk>
  if((top % PGSIZE) != 0){
    2af2:	03451793          	slli	a5,a0,0x34
    2af6:	e3c9                	bnez	a5,2b78 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2af8:	4501                	li	a0,0
    2afa:	00004097          	auipc	ra,0x4
    2afe:	c2a080e7          	jalr	-982(ra) # 6724 <sbrk>
  if(top % PGSIZE){
    2b02:	03451793          	slli	a5,a0,0x34
    2b06:	e3d9                	bnez	a5,2b8c <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2b08:	fff50493          	addi	s1,a0,-1 # 1fff <forkfork+0xaf>
  *b = 'x';
    2b0c:	07800793          	li	a5,120
    2b10:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2b14:	8526                	mv	a0,s1
    2b16:	00004097          	auipc	ra,0x4
    2b1a:	bd6080e7          	jalr	-1066(ra) # 66ec <unlink>
  if(ret != -1){
    2b1e:	57fd                	li	a5,-1
    2b20:	08f51763          	bne	a0,a5,2bae <copyinstr3+0xda>
  int fd = open(b, O_CREATE | O_WRONLY);
    2b24:	20100593          	li	a1,513
    2b28:	8526                	mv	a0,s1
    2b2a:	00004097          	auipc	ra,0x4
    2b2e:	bb2080e7          	jalr	-1102(ra) # 66dc <open>
  if(fd != -1){
    2b32:	57fd                	li	a5,-1
    2b34:	0af51063          	bne	a0,a5,2bd4 <copyinstr3+0x100>
  ret = link(b, b);
    2b38:	85a6                	mv	a1,s1
    2b3a:	8526                	mv	a0,s1
    2b3c:	00004097          	auipc	ra,0x4
    2b40:	bc0080e7          	jalr	-1088(ra) # 66fc <link>
  if(ret != -1){
    2b44:	57fd                	li	a5,-1
    2b46:	0af51a63          	bne	a0,a5,2bfa <copyinstr3+0x126>
  char *args[] = { "xx", 0 };
    2b4a:	00006797          	auipc	a5,0x6
    2b4e:	ade78793          	addi	a5,a5,-1314 # 8628 <malloc+0x1b2e>
    2b52:	fcf43823          	sd	a5,-48(s0)
    2b56:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2b5a:	fd040593          	addi	a1,s0,-48
    2b5e:	8526                	mv	a0,s1
    2b60:	00004097          	auipc	ra,0x4
    2b64:	b74080e7          	jalr	-1164(ra) # 66d4 <exec>
  if(ret != -1){
    2b68:	57fd                	li	a5,-1
    2b6a:	0af51c63          	bne	a0,a5,2c22 <copyinstr3+0x14e>
}
    2b6e:	70a2                	ld	ra,40(sp)
    2b70:	7402                	ld	s0,32(sp)
    2b72:	64e2                	ld	s1,24(sp)
    2b74:	6145                	addi	sp,sp,48
    2b76:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2b78:	0347d513          	srli	a0,a5,0x34
    2b7c:	6785                	lui	a5,0x1
    2b7e:	40a7853b          	subw	a0,a5,a0
    2b82:	00004097          	auipc	ra,0x4
    2b86:	ba2080e7          	jalr	-1118(ra) # 6724 <sbrk>
    2b8a:	b7bd                	j	2af8 <copyinstr3+0x24>
    printf("oops\n");
    2b8c:	00005517          	auipc	a0,0x5
    2b90:	dbc50513          	addi	a0,a0,-580 # 7948 <malloc+0xe4e>
    2b94:	00004097          	auipc	ra,0x4
    2b98:	ea8080e7          	jalr	-344(ra) # 6a3c <printf>
    exit(1,"");
    2b9c:	00005597          	auipc	a1,0x5
    2ba0:	69c58593          	addi	a1,a1,1692 # 8238 <malloc+0x173e>
    2ba4:	4505                	li	a0,1
    2ba6:	00004097          	auipc	ra,0x4
    2baa:	af6080e7          	jalr	-1290(ra) # 669c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2bae:	862a                	mv	a2,a0
    2bb0:	85a6                	mv	a1,s1
    2bb2:	00005517          	auipc	a0,0x5
    2bb6:	82e50513          	addi	a0,a0,-2002 # 73e0 <malloc+0x8e6>
    2bba:	00004097          	auipc	ra,0x4
    2bbe:	e82080e7          	jalr	-382(ra) # 6a3c <printf>
    exit(1,"");
    2bc2:	00005597          	auipc	a1,0x5
    2bc6:	67658593          	addi	a1,a1,1654 # 8238 <malloc+0x173e>
    2bca:	4505                	li	a0,1
    2bcc:	00004097          	auipc	ra,0x4
    2bd0:	ad0080e7          	jalr	-1328(ra) # 669c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2bd4:	862a                	mv	a2,a0
    2bd6:	85a6                	mv	a1,s1
    2bd8:	00005517          	auipc	a0,0x5
    2bdc:	82850513          	addi	a0,a0,-2008 # 7400 <malloc+0x906>
    2be0:	00004097          	auipc	ra,0x4
    2be4:	e5c080e7          	jalr	-420(ra) # 6a3c <printf>
    exit(1,"");
    2be8:	00005597          	auipc	a1,0x5
    2bec:	65058593          	addi	a1,a1,1616 # 8238 <malloc+0x173e>
    2bf0:	4505                	li	a0,1
    2bf2:	00004097          	auipc	ra,0x4
    2bf6:	aaa080e7          	jalr	-1366(ra) # 669c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2bfa:	86aa                	mv	a3,a0
    2bfc:	8626                	mv	a2,s1
    2bfe:	85a6                	mv	a1,s1
    2c00:	00005517          	auipc	a0,0x5
    2c04:	82050513          	addi	a0,a0,-2016 # 7420 <malloc+0x926>
    2c08:	00004097          	auipc	ra,0x4
    2c0c:	e34080e7          	jalr	-460(ra) # 6a3c <printf>
    exit(1,"");
    2c10:	00005597          	auipc	a1,0x5
    2c14:	62858593          	addi	a1,a1,1576 # 8238 <malloc+0x173e>
    2c18:	4505                	li	a0,1
    2c1a:	00004097          	auipc	ra,0x4
    2c1e:	a82080e7          	jalr	-1406(ra) # 669c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2c22:	567d                	li	a2,-1
    2c24:	85a6                	mv	a1,s1
    2c26:	00005517          	auipc	a0,0x5
    2c2a:	82250513          	addi	a0,a0,-2014 # 7448 <malloc+0x94e>
    2c2e:	00004097          	auipc	ra,0x4
    2c32:	e0e080e7          	jalr	-498(ra) # 6a3c <printf>
    exit(1,"");
    2c36:	00005597          	auipc	a1,0x5
    2c3a:	60258593          	addi	a1,a1,1538 # 8238 <malloc+0x173e>
    2c3e:	4505                	li	a0,1
    2c40:	00004097          	auipc	ra,0x4
    2c44:	a5c080e7          	jalr	-1444(ra) # 669c <exit>

0000000000002c48 <rwsbrk>:
{
    2c48:	1101                	addi	sp,sp,-32
    2c4a:	ec06                	sd	ra,24(sp)
    2c4c:	e822                	sd	s0,16(sp)
    2c4e:	e426                	sd	s1,8(sp)
    2c50:	e04a                	sd	s2,0(sp)
    2c52:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2c54:	6509                	lui	a0,0x2
    2c56:	00004097          	auipc	ra,0x4
    2c5a:	ace080e7          	jalr	-1330(ra) # 6724 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2c5e:	57fd                	li	a5,-1
    2c60:	06f50763          	beq	a0,a5,2cce <rwsbrk+0x86>
    2c64:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2c66:	7579                	lui	a0,0xffffe
    2c68:	00004097          	auipc	ra,0x4
    2c6c:	abc080e7          	jalr	-1348(ra) # 6724 <sbrk>
    2c70:	57fd                	li	a5,-1
    2c72:	06f50f63          	beq	a0,a5,2cf0 <rwsbrk+0xa8>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2c76:	20100593          	li	a1,513
    2c7a:	00005517          	auipc	a0,0x5
    2c7e:	d0e50513          	addi	a0,a0,-754 # 7988 <malloc+0xe8e>
    2c82:	00004097          	auipc	ra,0x4
    2c86:	a5a080e7          	jalr	-1446(ra) # 66dc <open>
    2c8a:	892a                	mv	s2,a0
  if(fd < 0){
    2c8c:	08054363          	bltz	a0,2d12 <rwsbrk+0xca>
  n = write(fd, (void*)(a+4096), 1024);
    2c90:	6505                	lui	a0,0x1
    2c92:	94aa                	add	s1,s1,a0
    2c94:	40000613          	li	a2,1024
    2c98:	85a6                	mv	a1,s1
    2c9a:	854a                	mv	a0,s2
    2c9c:	00004097          	auipc	ra,0x4
    2ca0:	a20080e7          	jalr	-1504(ra) # 66bc <write>
    2ca4:	862a                	mv	a2,a0
  if(n >= 0){
    2ca6:	08054763          	bltz	a0,2d34 <rwsbrk+0xec>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2caa:	85a6                	mv	a1,s1
    2cac:	00005517          	auipc	a0,0x5
    2cb0:	cfc50513          	addi	a0,a0,-772 # 79a8 <malloc+0xeae>
    2cb4:	00004097          	auipc	ra,0x4
    2cb8:	d88080e7          	jalr	-632(ra) # 6a3c <printf>
    exit(1,"");
    2cbc:	00005597          	auipc	a1,0x5
    2cc0:	57c58593          	addi	a1,a1,1404 # 8238 <malloc+0x173e>
    2cc4:	4505                	li	a0,1
    2cc6:	00004097          	auipc	ra,0x4
    2cca:	9d6080e7          	jalr	-1578(ra) # 669c <exit>
    printf("sbrk(rwsbrk) failed\n");
    2cce:	00005517          	auipc	a0,0x5
    2cd2:	c8250513          	addi	a0,a0,-894 # 7950 <malloc+0xe56>
    2cd6:	00004097          	auipc	ra,0x4
    2cda:	d66080e7          	jalr	-666(ra) # 6a3c <printf>
    exit(1,"");
    2cde:	00005597          	auipc	a1,0x5
    2ce2:	55a58593          	addi	a1,a1,1370 # 8238 <malloc+0x173e>
    2ce6:	4505                	li	a0,1
    2ce8:	00004097          	auipc	ra,0x4
    2cec:	9b4080e7          	jalr	-1612(ra) # 669c <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2cf0:	00005517          	auipc	a0,0x5
    2cf4:	c7850513          	addi	a0,a0,-904 # 7968 <malloc+0xe6e>
    2cf8:	00004097          	auipc	ra,0x4
    2cfc:	d44080e7          	jalr	-700(ra) # 6a3c <printf>
    exit(1,"");
    2d00:	00005597          	auipc	a1,0x5
    2d04:	53858593          	addi	a1,a1,1336 # 8238 <malloc+0x173e>
    2d08:	4505                	li	a0,1
    2d0a:	00004097          	auipc	ra,0x4
    2d0e:	992080e7          	jalr	-1646(ra) # 669c <exit>
    printf("open(rwsbrk) failed\n");
    2d12:	00005517          	auipc	a0,0x5
    2d16:	c7e50513          	addi	a0,a0,-898 # 7990 <malloc+0xe96>
    2d1a:	00004097          	auipc	ra,0x4
    2d1e:	d22080e7          	jalr	-734(ra) # 6a3c <printf>
    exit(1,"");
    2d22:	00005597          	auipc	a1,0x5
    2d26:	51658593          	addi	a1,a1,1302 # 8238 <malloc+0x173e>
    2d2a:	4505                	li	a0,1
    2d2c:	00004097          	auipc	ra,0x4
    2d30:	970080e7          	jalr	-1680(ra) # 669c <exit>
  close(fd);
    2d34:	854a                	mv	a0,s2
    2d36:	00004097          	auipc	ra,0x4
    2d3a:	98e080e7          	jalr	-1650(ra) # 66c4 <close>
  unlink("rwsbrk");
    2d3e:	00005517          	auipc	a0,0x5
    2d42:	c4a50513          	addi	a0,a0,-950 # 7988 <malloc+0xe8e>
    2d46:	00004097          	auipc	ra,0x4
    2d4a:	9a6080e7          	jalr	-1626(ra) # 66ec <unlink>
  fd = open("README", O_RDONLY);
    2d4e:	4581                	li	a1,0
    2d50:	00004517          	auipc	a0,0x4
    2d54:	0c050513          	addi	a0,a0,192 # 6e10 <malloc+0x316>
    2d58:	00004097          	auipc	ra,0x4
    2d5c:	984080e7          	jalr	-1660(ra) # 66dc <open>
    2d60:	892a                	mv	s2,a0
  if(fd < 0){
    2d62:	02054d63          	bltz	a0,2d9c <rwsbrk+0x154>
  n = read(fd, (void*)(a+4096), 10);
    2d66:	4629                	li	a2,10
    2d68:	85a6                	mv	a1,s1
    2d6a:	00004097          	auipc	ra,0x4
    2d6e:	94a080e7          	jalr	-1718(ra) # 66b4 <read>
    2d72:	862a                	mv	a2,a0
  if(n >= 0){
    2d74:	04054563          	bltz	a0,2dbe <rwsbrk+0x176>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2d78:	85a6                	mv	a1,s1
    2d7a:	00005517          	auipc	a0,0x5
    2d7e:	c5e50513          	addi	a0,a0,-930 # 79d8 <malloc+0xede>
    2d82:	00004097          	auipc	ra,0x4
    2d86:	cba080e7          	jalr	-838(ra) # 6a3c <printf>
    exit(1,"");
    2d8a:	00005597          	auipc	a1,0x5
    2d8e:	4ae58593          	addi	a1,a1,1198 # 8238 <malloc+0x173e>
    2d92:	4505                	li	a0,1
    2d94:	00004097          	auipc	ra,0x4
    2d98:	908080e7          	jalr	-1784(ra) # 669c <exit>
    printf("open(rwsbrk) failed\n");
    2d9c:	00005517          	auipc	a0,0x5
    2da0:	bf450513          	addi	a0,a0,-1036 # 7990 <malloc+0xe96>
    2da4:	00004097          	auipc	ra,0x4
    2da8:	c98080e7          	jalr	-872(ra) # 6a3c <printf>
    exit(1,"");
    2dac:	00005597          	auipc	a1,0x5
    2db0:	48c58593          	addi	a1,a1,1164 # 8238 <malloc+0x173e>
    2db4:	4505                	li	a0,1
    2db6:	00004097          	auipc	ra,0x4
    2dba:	8e6080e7          	jalr	-1818(ra) # 669c <exit>
  close(fd);
    2dbe:	854a                	mv	a0,s2
    2dc0:	00004097          	auipc	ra,0x4
    2dc4:	904080e7          	jalr	-1788(ra) # 66c4 <close>
  exit(0,"");
    2dc8:	00005597          	auipc	a1,0x5
    2dcc:	47058593          	addi	a1,a1,1136 # 8238 <malloc+0x173e>
    2dd0:	4501                	li	a0,0
    2dd2:	00004097          	auipc	ra,0x4
    2dd6:	8ca080e7          	jalr	-1846(ra) # 669c <exit>

0000000000002dda <sbrkbasic>:
{
    2dda:	7139                	addi	sp,sp,-64
    2ddc:	fc06                	sd	ra,56(sp)
    2dde:	f822                	sd	s0,48(sp)
    2de0:	f426                	sd	s1,40(sp)
    2de2:	f04a                	sd	s2,32(sp)
    2de4:	ec4e                	sd	s3,24(sp)
    2de6:	e852                	sd	s4,16(sp)
    2de8:	0080                	addi	s0,sp,64
    2dea:	8a2a                	mv	s4,a0
  pid = fork();
    2dec:	00004097          	auipc	ra,0x4
    2df0:	8a8080e7          	jalr	-1880(ra) # 6694 <fork>
  if(pid < 0){
    2df4:	04054063          	bltz	a0,2e34 <sbrkbasic+0x5a>
  if(pid == 0){
    2df8:	e925                	bnez	a0,2e68 <sbrkbasic+0x8e>
    a = sbrk(TOOMUCH);
    2dfa:	40000537          	lui	a0,0x40000
    2dfe:	00004097          	auipc	ra,0x4
    2e02:	926080e7          	jalr	-1754(ra) # 6724 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2e06:	57fd                	li	a5,-1
    2e08:	04f50763          	beq	a0,a5,2e56 <sbrkbasic+0x7c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2e0c:	400007b7          	lui	a5,0x40000
    2e10:	97aa                	add	a5,a5,a0
      *b = 99;
    2e12:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2e16:	6705                	lui	a4,0x1
      *b = 99;
    2e18:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2e1c:	953a                	add	a0,a0,a4
    2e1e:	fef51de3          	bne	a0,a5,2e18 <sbrkbasic+0x3e>
    exit(1,"");
    2e22:	00005597          	auipc	a1,0x5
    2e26:	41658593          	addi	a1,a1,1046 # 8238 <malloc+0x173e>
    2e2a:	4505                	li	a0,1
    2e2c:	00004097          	auipc	ra,0x4
    2e30:	870080e7          	jalr	-1936(ra) # 669c <exit>
    printf("fork failed in sbrkbasic\n");
    2e34:	00005517          	auipc	a0,0x5
    2e38:	bcc50513          	addi	a0,a0,-1076 # 7a00 <malloc+0xf06>
    2e3c:	00004097          	auipc	ra,0x4
    2e40:	c00080e7          	jalr	-1024(ra) # 6a3c <printf>
    exit(1,"");
    2e44:	00005597          	auipc	a1,0x5
    2e48:	3f458593          	addi	a1,a1,1012 # 8238 <malloc+0x173e>
    2e4c:	4505                	li	a0,1
    2e4e:	00004097          	auipc	ra,0x4
    2e52:	84e080e7          	jalr	-1970(ra) # 669c <exit>
      exit(0,"");
    2e56:	00005597          	auipc	a1,0x5
    2e5a:	3e258593          	addi	a1,a1,994 # 8238 <malloc+0x173e>
    2e5e:	4501                	li	a0,0
    2e60:	00004097          	auipc	ra,0x4
    2e64:	83c080e7          	jalr	-1988(ra) # 669c <exit>
  wait(&xstatus,0);
    2e68:	4581                	li	a1,0
    2e6a:	fcc40513          	addi	a0,s0,-52
    2e6e:	00004097          	auipc	ra,0x4
    2e72:	836080e7          	jalr	-1994(ra) # 66a4 <wait>
  if(xstatus == 1){
    2e76:	fcc42703          	lw	a4,-52(s0)
    2e7a:	4785                	li	a5,1
    2e7c:	00f70d63          	beq	a4,a5,2e96 <sbrkbasic+0xbc>
  a = sbrk(0);
    2e80:	4501                	li	a0,0
    2e82:	00004097          	auipc	ra,0x4
    2e86:	8a2080e7          	jalr	-1886(ra) # 6724 <sbrk>
    2e8a:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2e8c:	4901                	li	s2,0
    2e8e:	6985                	lui	s3,0x1
    2e90:	38898993          	addi	s3,s3,904 # 1388 <bigdir+0x20>
    2e94:	a025                	j	2ebc <sbrkbasic+0xe2>
    printf("%s: too much memory allocated!\n", s);
    2e96:	85d2                	mv	a1,s4
    2e98:	00005517          	auipc	a0,0x5
    2e9c:	b8850513          	addi	a0,a0,-1144 # 7a20 <malloc+0xf26>
    2ea0:	00004097          	auipc	ra,0x4
    2ea4:	b9c080e7          	jalr	-1124(ra) # 6a3c <printf>
    exit(1,"");
    2ea8:	00005597          	auipc	a1,0x5
    2eac:	39058593          	addi	a1,a1,912 # 8238 <malloc+0x173e>
    2eb0:	4505                	li	a0,1
    2eb2:	00003097          	auipc	ra,0x3
    2eb6:	7ea080e7          	jalr	2026(ra) # 669c <exit>
    a = b + 1;
    2eba:	84be                	mv	s1,a5
    b = sbrk(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00004097          	auipc	ra,0x4
    2ec2:	866080e7          	jalr	-1946(ra) # 6724 <sbrk>
    if(b != a){
    2ec6:	06951063          	bne	a0,s1,2f26 <sbrkbasic+0x14c>
    *b = 1;
    2eca:	4785                	li	a5,1
    2ecc:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2ed0:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2ed4:	2905                	addiw	s2,s2,1
    2ed6:	ff3912e3          	bne	s2,s3,2eba <sbrkbasic+0xe0>
  pid = fork();
    2eda:	00003097          	auipc	ra,0x3
    2ede:	7ba080e7          	jalr	1978(ra) # 6694 <fork>
    2ee2:	892a                	mv	s2,a0
  if(pid < 0){
    2ee4:	06054663          	bltz	a0,2f50 <sbrkbasic+0x176>
  c = sbrk(1);
    2ee8:	4505                	li	a0,1
    2eea:	00004097          	auipc	ra,0x4
    2eee:	83a080e7          	jalr	-1990(ra) # 6724 <sbrk>
  c = sbrk(1);
    2ef2:	4505                	li	a0,1
    2ef4:	00004097          	auipc	ra,0x4
    2ef8:	830080e7          	jalr	-2000(ra) # 6724 <sbrk>
  if(c != a + 1){
    2efc:	0489                	addi	s1,s1,2
    2efe:	06a48b63          	beq	s1,a0,2f74 <sbrkbasic+0x19a>
    printf("%s: sbrk test failed post-fork\n", s);
    2f02:	85d2                	mv	a1,s4
    2f04:	00005517          	auipc	a0,0x5
    2f08:	b7c50513          	addi	a0,a0,-1156 # 7a80 <malloc+0xf86>
    2f0c:	00004097          	auipc	ra,0x4
    2f10:	b30080e7          	jalr	-1232(ra) # 6a3c <printf>
    exit(1,"");
    2f14:	00005597          	auipc	a1,0x5
    2f18:	32458593          	addi	a1,a1,804 # 8238 <malloc+0x173e>
    2f1c:	4505                	li	a0,1
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	77e080e7          	jalr	1918(ra) # 669c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2f26:	872a                	mv	a4,a0
    2f28:	86a6                	mv	a3,s1
    2f2a:	864a                	mv	a2,s2
    2f2c:	85d2                	mv	a1,s4
    2f2e:	00005517          	auipc	a0,0x5
    2f32:	b1250513          	addi	a0,a0,-1262 # 7a40 <malloc+0xf46>
    2f36:	00004097          	auipc	ra,0x4
    2f3a:	b06080e7          	jalr	-1274(ra) # 6a3c <printf>
      exit(1,"");
    2f3e:	00005597          	auipc	a1,0x5
    2f42:	2fa58593          	addi	a1,a1,762 # 8238 <malloc+0x173e>
    2f46:	4505                	li	a0,1
    2f48:	00003097          	auipc	ra,0x3
    2f4c:	754080e7          	jalr	1876(ra) # 669c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2f50:	85d2                	mv	a1,s4
    2f52:	00005517          	auipc	a0,0x5
    2f56:	b0e50513          	addi	a0,a0,-1266 # 7a60 <malloc+0xf66>
    2f5a:	00004097          	auipc	ra,0x4
    2f5e:	ae2080e7          	jalr	-1310(ra) # 6a3c <printf>
    exit(1,"");
    2f62:	00005597          	auipc	a1,0x5
    2f66:	2d658593          	addi	a1,a1,726 # 8238 <malloc+0x173e>
    2f6a:	4505                	li	a0,1
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	730080e7          	jalr	1840(ra) # 669c <exit>
  if(pid == 0)
    2f74:	00091b63          	bnez	s2,2f8a <sbrkbasic+0x1b0>
    exit(0,"");
    2f78:	00005597          	auipc	a1,0x5
    2f7c:	2c058593          	addi	a1,a1,704 # 8238 <malloc+0x173e>
    2f80:	4501                	li	a0,0
    2f82:	00003097          	auipc	ra,0x3
    2f86:	71a080e7          	jalr	1818(ra) # 669c <exit>
  wait(&xstatus,0);
    2f8a:	4581                	li	a1,0
    2f8c:	fcc40513          	addi	a0,s0,-52
    2f90:	00003097          	auipc	ra,0x3
    2f94:	714080e7          	jalr	1812(ra) # 66a4 <wait>
  exit(xstatus,"");
    2f98:	00005597          	auipc	a1,0x5
    2f9c:	2a058593          	addi	a1,a1,672 # 8238 <malloc+0x173e>
    2fa0:	fcc42503          	lw	a0,-52(s0)
    2fa4:	00003097          	auipc	ra,0x3
    2fa8:	6f8080e7          	jalr	1784(ra) # 669c <exit>

0000000000002fac <sbrkmuch>:
{
    2fac:	7179                	addi	sp,sp,-48
    2fae:	f406                	sd	ra,40(sp)
    2fb0:	f022                	sd	s0,32(sp)
    2fb2:	ec26                	sd	s1,24(sp)
    2fb4:	e84a                	sd	s2,16(sp)
    2fb6:	e44e                	sd	s3,8(sp)
    2fb8:	e052                	sd	s4,0(sp)
    2fba:	1800                	addi	s0,sp,48
    2fbc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2fbe:	4501                	li	a0,0
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	764080e7          	jalr	1892(ra) # 6724 <sbrk>
    2fc8:	892a                	mv	s2,a0
  a = sbrk(0);
    2fca:	4501                	li	a0,0
    2fcc:	00003097          	auipc	ra,0x3
    2fd0:	758080e7          	jalr	1880(ra) # 6724 <sbrk>
    2fd4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2fd6:	06400537          	lui	a0,0x6400
    2fda:	9d05                	subw	a0,a0,s1
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	748080e7          	jalr	1864(ra) # 6724 <sbrk>
  if (p != a) {
    2fe4:	0ca49863          	bne	s1,a0,30b4 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2fe8:	4501                	li	a0,0
    2fea:	00003097          	auipc	ra,0x3
    2fee:	73a080e7          	jalr	1850(ra) # 6724 <sbrk>
    2ff2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2ff4:	00a4f963          	bgeu	s1,a0,3006 <sbrkmuch+0x5a>
    *pp = 1;
    2ff8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ffa:	6705                	lui	a4,0x1
    *pp = 1;
    2ffc:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    3000:	94ba                	add	s1,s1,a4
    3002:	fef4ede3          	bltu	s1,a5,2ffc <sbrkmuch+0x50>
  *lastaddr = 99;
    3006:	064007b7          	lui	a5,0x6400
    300a:	06300713          	li	a4,99
    300e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef387>
  a = sbrk(0);
    3012:	4501                	li	a0,0
    3014:	00003097          	auipc	ra,0x3
    3018:	710080e7          	jalr	1808(ra) # 6724 <sbrk>
    301c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    301e:	757d                	lui	a0,0xfffff
    3020:	00003097          	auipc	ra,0x3
    3024:	704080e7          	jalr	1796(ra) # 6724 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3028:	57fd                	li	a5,-1
    302a:	0af50763          	beq	a0,a5,30d8 <sbrkmuch+0x12c>
  c = sbrk(0);
    302e:	4501                	li	a0,0
    3030:	00003097          	auipc	ra,0x3
    3034:	6f4080e7          	jalr	1780(ra) # 6724 <sbrk>
  if(c != a - PGSIZE){
    3038:	77fd                	lui	a5,0xfffff
    303a:	97a6                	add	a5,a5,s1
    303c:	0cf51063          	bne	a0,a5,30fc <sbrkmuch+0x150>
  a = sbrk(0);
    3040:	4501                	li	a0,0
    3042:	00003097          	auipc	ra,0x3
    3046:	6e2080e7          	jalr	1762(ra) # 6724 <sbrk>
    304a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    304c:	6505                	lui	a0,0x1
    304e:	00003097          	auipc	ra,0x3
    3052:	6d6080e7          	jalr	1750(ra) # 6724 <sbrk>
    3056:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3058:	0ca49663          	bne	s1,a0,3124 <sbrkmuch+0x178>
    305c:	4501                	li	a0,0
    305e:	00003097          	auipc	ra,0x3
    3062:	6c6080e7          	jalr	1734(ra) # 6724 <sbrk>
    3066:	6785                	lui	a5,0x1
    3068:	97a6                	add	a5,a5,s1
    306a:	0af51d63          	bne	a0,a5,3124 <sbrkmuch+0x178>
  if(*lastaddr == 99){
    306e:	064007b7          	lui	a5,0x6400
    3072:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef387>
    3076:	06300793          	li	a5,99
    307a:	0cf70963          	beq	a4,a5,314c <sbrkmuch+0x1a0>
  a = sbrk(0);
    307e:	4501                	li	a0,0
    3080:	00003097          	auipc	ra,0x3
    3084:	6a4080e7          	jalr	1700(ra) # 6724 <sbrk>
    3088:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    308a:	4501                	li	a0,0
    308c:	00003097          	auipc	ra,0x3
    3090:	698080e7          	jalr	1688(ra) # 6724 <sbrk>
    3094:	40a9053b          	subw	a0,s2,a0
    3098:	00003097          	auipc	ra,0x3
    309c:	68c080e7          	jalr	1676(ra) # 6724 <sbrk>
  if(c != a){
    30a0:	0ca49863          	bne	s1,a0,3170 <sbrkmuch+0x1c4>
}
    30a4:	70a2                	ld	ra,40(sp)
    30a6:	7402                	ld	s0,32(sp)
    30a8:	64e2                	ld	s1,24(sp)
    30aa:	6942                	ld	s2,16(sp)
    30ac:	69a2                	ld	s3,8(sp)
    30ae:	6a02                	ld	s4,0(sp)
    30b0:	6145                	addi	sp,sp,48
    30b2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    30b4:	85ce                	mv	a1,s3
    30b6:	00005517          	auipc	a0,0x5
    30ba:	9ea50513          	addi	a0,a0,-1558 # 7aa0 <malloc+0xfa6>
    30be:	00004097          	auipc	ra,0x4
    30c2:	97e080e7          	jalr	-1666(ra) # 6a3c <printf>
    exit(1,"");
    30c6:	00005597          	auipc	a1,0x5
    30ca:	17258593          	addi	a1,a1,370 # 8238 <malloc+0x173e>
    30ce:	4505                	li	a0,1
    30d0:	00003097          	auipc	ra,0x3
    30d4:	5cc080e7          	jalr	1484(ra) # 669c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    30d8:	85ce                	mv	a1,s3
    30da:	00005517          	auipc	a0,0x5
    30de:	a0e50513          	addi	a0,a0,-1522 # 7ae8 <malloc+0xfee>
    30e2:	00004097          	auipc	ra,0x4
    30e6:	95a080e7          	jalr	-1702(ra) # 6a3c <printf>
    exit(1,"");
    30ea:	00005597          	auipc	a1,0x5
    30ee:	14e58593          	addi	a1,a1,334 # 8238 <malloc+0x173e>
    30f2:	4505                	li	a0,1
    30f4:	00003097          	auipc	ra,0x3
    30f8:	5a8080e7          	jalr	1448(ra) # 669c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    30fc:	86aa                	mv	a3,a0
    30fe:	8626                	mv	a2,s1
    3100:	85ce                	mv	a1,s3
    3102:	00005517          	auipc	a0,0x5
    3106:	a0650513          	addi	a0,a0,-1530 # 7b08 <malloc+0x100e>
    310a:	00004097          	auipc	ra,0x4
    310e:	932080e7          	jalr	-1742(ra) # 6a3c <printf>
    exit(1,"");
    3112:	00005597          	auipc	a1,0x5
    3116:	12658593          	addi	a1,a1,294 # 8238 <malloc+0x173e>
    311a:	4505                	li	a0,1
    311c:	00003097          	auipc	ra,0x3
    3120:	580080e7          	jalr	1408(ra) # 669c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    3124:	86d2                	mv	a3,s4
    3126:	8626                	mv	a2,s1
    3128:	85ce                	mv	a1,s3
    312a:	00005517          	auipc	a0,0x5
    312e:	a1e50513          	addi	a0,a0,-1506 # 7b48 <malloc+0x104e>
    3132:	00004097          	auipc	ra,0x4
    3136:	90a080e7          	jalr	-1782(ra) # 6a3c <printf>
    exit(1,"");
    313a:	00005597          	auipc	a1,0x5
    313e:	0fe58593          	addi	a1,a1,254 # 8238 <malloc+0x173e>
    3142:	4505                	li	a0,1
    3144:	00003097          	auipc	ra,0x3
    3148:	558080e7          	jalr	1368(ra) # 669c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    314c:	85ce                	mv	a1,s3
    314e:	00005517          	auipc	a0,0x5
    3152:	a2a50513          	addi	a0,a0,-1494 # 7b78 <malloc+0x107e>
    3156:	00004097          	auipc	ra,0x4
    315a:	8e6080e7          	jalr	-1818(ra) # 6a3c <printf>
    exit(1,"");
    315e:	00005597          	auipc	a1,0x5
    3162:	0da58593          	addi	a1,a1,218 # 8238 <malloc+0x173e>
    3166:	4505                	li	a0,1
    3168:	00003097          	auipc	ra,0x3
    316c:	534080e7          	jalr	1332(ra) # 669c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    3170:	86aa                	mv	a3,a0
    3172:	8626                	mv	a2,s1
    3174:	85ce                	mv	a1,s3
    3176:	00005517          	auipc	a0,0x5
    317a:	a3a50513          	addi	a0,a0,-1478 # 7bb0 <malloc+0x10b6>
    317e:	00004097          	auipc	ra,0x4
    3182:	8be080e7          	jalr	-1858(ra) # 6a3c <printf>
    exit(1,"");
    3186:	00005597          	auipc	a1,0x5
    318a:	0b258593          	addi	a1,a1,178 # 8238 <malloc+0x173e>
    318e:	4505                	li	a0,1
    3190:	00003097          	auipc	ra,0x3
    3194:	50c080e7          	jalr	1292(ra) # 669c <exit>

0000000000003198 <sbrkarg>:
{
    3198:	7179                	addi	sp,sp,-48
    319a:	f406                	sd	ra,40(sp)
    319c:	f022                	sd	s0,32(sp)
    319e:	ec26                	sd	s1,24(sp)
    31a0:	e84a                	sd	s2,16(sp)
    31a2:	e44e                	sd	s3,8(sp)
    31a4:	1800                	addi	s0,sp,48
    31a6:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    31a8:	6505                	lui	a0,0x1
    31aa:	00003097          	auipc	ra,0x3
    31ae:	57a080e7          	jalr	1402(ra) # 6724 <sbrk>
    31b2:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    31b4:	20100593          	li	a1,513
    31b8:	00005517          	auipc	a0,0x5
    31bc:	a2050513          	addi	a0,a0,-1504 # 7bd8 <malloc+0x10de>
    31c0:	00003097          	auipc	ra,0x3
    31c4:	51c080e7          	jalr	1308(ra) # 66dc <open>
    31c8:	84aa                	mv	s1,a0
  unlink("sbrk");
    31ca:	00005517          	auipc	a0,0x5
    31ce:	a0e50513          	addi	a0,a0,-1522 # 7bd8 <malloc+0x10de>
    31d2:	00003097          	auipc	ra,0x3
    31d6:	51a080e7          	jalr	1306(ra) # 66ec <unlink>
  if(fd < 0)  {
    31da:	0404c163          	bltz	s1,321c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    31de:	6605                	lui	a2,0x1
    31e0:	85ca                	mv	a1,s2
    31e2:	8526                	mv	a0,s1
    31e4:	00003097          	auipc	ra,0x3
    31e8:	4d8080e7          	jalr	1240(ra) # 66bc <write>
    31ec:	04054a63          	bltz	a0,3240 <sbrkarg+0xa8>
  close(fd);
    31f0:	8526                	mv	a0,s1
    31f2:	00003097          	auipc	ra,0x3
    31f6:	4d2080e7          	jalr	1234(ra) # 66c4 <close>
  a = sbrk(PGSIZE);
    31fa:	6505                	lui	a0,0x1
    31fc:	00003097          	auipc	ra,0x3
    3200:	528080e7          	jalr	1320(ra) # 6724 <sbrk>
  if(pipe((int *) a) != 0){
    3204:	00003097          	auipc	ra,0x3
    3208:	4a8080e7          	jalr	1192(ra) # 66ac <pipe>
    320c:	ed21                	bnez	a0,3264 <sbrkarg+0xcc>
}
    320e:	70a2                	ld	ra,40(sp)
    3210:	7402                	ld	s0,32(sp)
    3212:	64e2                	ld	s1,24(sp)
    3214:	6942                	ld	s2,16(sp)
    3216:	69a2                	ld	s3,8(sp)
    3218:	6145                	addi	sp,sp,48
    321a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    321c:	85ce                	mv	a1,s3
    321e:	00005517          	auipc	a0,0x5
    3222:	9c250513          	addi	a0,a0,-1598 # 7be0 <malloc+0x10e6>
    3226:	00004097          	auipc	ra,0x4
    322a:	816080e7          	jalr	-2026(ra) # 6a3c <printf>
    exit(1,"");
    322e:	00005597          	auipc	a1,0x5
    3232:	00a58593          	addi	a1,a1,10 # 8238 <malloc+0x173e>
    3236:	4505                	li	a0,1
    3238:	00003097          	auipc	ra,0x3
    323c:	464080e7          	jalr	1124(ra) # 669c <exit>
    printf("%s: write sbrk failed\n", s);
    3240:	85ce                	mv	a1,s3
    3242:	00005517          	auipc	a0,0x5
    3246:	9b650513          	addi	a0,a0,-1610 # 7bf8 <malloc+0x10fe>
    324a:	00003097          	auipc	ra,0x3
    324e:	7f2080e7          	jalr	2034(ra) # 6a3c <printf>
    exit(1,"");
    3252:	00005597          	auipc	a1,0x5
    3256:	fe658593          	addi	a1,a1,-26 # 8238 <malloc+0x173e>
    325a:	4505                	li	a0,1
    325c:	00003097          	auipc	ra,0x3
    3260:	440080e7          	jalr	1088(ra) # 669c <exit>
    printf("%s: pipe() failed\n", s);
    3264:	85ce                	mv	a1,s3
    3266:	00004517          	auipc	a0,0x4
    326a:	36250513          	addi	a0,a0,866 # 75c8 <malloc+0xace>
    326e:	00003097          	auipc	ra,0x3
    3272:	7ce080e7          	jalr	1998(ra) # 6a3c <printf>
    exit(1,"");
    3276:	00005597          	auipc	a1,0x5
    327a:	fc258593          	addi	a1,a1,-62 # 8238 <malloc+0x173e>
    327e:	4505                	li	a0,1
    3280:	00003097          	auipc	ra,0x3
    3284:	41c080e7          	jalr	1052(ra) # 669c <exit>

0000000000003288 <argptest>:
{
    3288:	1101                	addi	sp,sp,-32
    328a:	ec06                	sd	ra,24(sp)
    328c:	e822                	sd	s0,16(sp)
    328e:	e426                	sd	s1,8(sp)
    3290:	e04a                	sd	s2,0(sp)
    3292:	1000                	addi	s0,sp,32
    3294:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3296:	4581                	li	a1,0
    3298:	00005517          	auipc	a0,0x5
    329c:	97850513          	addi	a0,a0,-1672 # 7c10 <malloc+0x1116>
    32a0:	00003097          	auipc	ra,0x3
    32a4:	43c080e7          	jalr	1084(ra) # 66dc <open>
  if (fd < 0) {
    32a8:	02054b63          	bltz	a0,32de <argptest+0x56>
    32ac:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    32ae:	4501                	li	a0,0
    32b0:	00003097          	auipc	ra,0x3
    32b4:	474080e7          	jalr	1140(ra) # 6724 <sbrk>
    32b8:	567d                	li	a2,-1
    32ba:	fff50593          	addi	a1,a0,-1
    32be:	8526                	mv	a0,s1
    32c0:	00003097          	auipc	ra,0x3
    32c4:	3f4080e7          	jalr	1012(ra) # 66b4 <read>
  close(fd);
    32c8:	8526                	mv	a0,s1
    32ca:	00003097          	auipc	ra,0x3
    32ce:	3fa080e7          	jalr	1018(ra) # 66c4 <close>
}
    32d2:	60e2                	ld	ra,24(sp)
    32d4:	6442                	ld	s0,16(sp)
    32d6:	64a2                	ld	s1,8(sp)
    32d8:	6902                	ld	s2,0(sp)
    32da:	6105                	addi	sp,sp,32
    32dc:	8082                	ret
    printf("%s: open failed\n", s);
    32de:	85ca                	mv	a1,s2
    32e0:	00004517          	auipc	a0,0x4
    32e4:	1f850513          	addi	a0,a0,504 # 74d8 <malloc+0x9de>
    32e8:	00003097          	auipc	ra,0x3
    32ec:	754080e7          	jalr	1876(ra) # 6a3c <printf>
    exit(1,"");
    32f0:	00005597          	auipc	a1,0x5
    32f4:	f4858593          	addi	a1,a1,-184 # 8238 <malloc+0x173e>
    32f8:	4505                	li	a0,1
    32fa:	00003097          	auipc	ra,0x3
    32fe:	3a2080e7          	jalr	930(ra) # 669c <exit>

0000000000003302 <sbrkbugs>:
{
    3302:	1141                	addi	sp,sp,-16
    3304:	e406                	sd	ra,8(sp)
    3306:	e022                	sd	s0,0(sp)
    3308:	0800                	addi	s0,sp,16
  int pid = fork();
    330a:	00003097          	auipc	ra,0x3
    330e:	38a080e7          	jalr	906(ra) # 6694 <fork>
  if(pid < 0){
    3312:	02054663          	bltz	a0,333e <sbrkbugs+0x3c>
  if(pid == 0){
    3316:	e529                	bnez	a0,3360 <sbrkbugs+0x5e>
    int sz = (uint64) sbrk(0);
    3318:	00003097          	auipc	ra,0x3
    331c:	40c080e7          	jalr	1036(ra) # 6724 <sbrk>
    sbrk(-sz);
    3320:	40a0053b          	negw	a0,a0
    3324:	00003097          	auipc	ra,0x3
    3328:	400080e7          	jalr	1024(ra) # 6724 <sbrk>
    exit(0,"");
    332c:	00005597          	auipc	a1,0x5
    3330:	f0c58593          	addi	a1,a1,-244 # 8238 <malloc+0x173e>
    3334:	4501                	li	a0,0
    3336:	00003097          	auipc	ra,0x3
    333a:	366080e7          	jalr	870(ra) # 669c <exit>
    printf("fork failed\n");
    333e:	00004517          	auipc	a0,0x4
    3342:	59a50513          	addi	a0,a0,1434 # 78d8 <malloc+0xdde>
    3346:	00003097          	auipc	ra,0x3
    334a:	6f6080e7          	jalr	1782(ra) # 6a3c <printf>
    exit(1,"");
    334e:	00005597          	auipc	a1,0x5
    3352:	eea58593          	addi	a1,a1,-278 # 8238 <malloc+0x173e>
    3356:	4505                	li	a0,1
    3358:	00003097          	auipc	ra,0x3
    335c:	344080e7          	jalr	836(ra) # 669c <exit>
  wait(0,0);
    3360:	4581                	li	a1,0
    3362:	4501                	li	a0,0
    3364:	00003097          	auipc	ra,0x3
    3368:	340080e7          	jalr	832(ra) # 66a4 <wait>
  pid = fork();
    336c:	00003097          	auipc	ra,0x3
    3370:	328080e7          	jalr	808(ra) # 6694 <fork>
  if(pid < 0){
    3374:	02054963          	bltz	a0,33a6 <sbrkbugs+0xa4>
  if(pid == 0){
    3378:	e921                	bnez	a0,33c8 <sbrkbugs+0xc6>
    int sz = (uint64) sbrk(0);
    337a:	00003097          	auipc	ra,0x3
    337e:	3aa080e7          	jalr	938(ra) # 6724 <sbrk>
    sbrk(-(sz - 3500));
    3382:	6785                	lui	a5,0x1
    3384:	dac7879b          	addiw	a5,a5,-596
    3388:	40a7853b          	subw	a0,a5,a0
    338c:	00003097          	auipc	ra,0x3
    3390:	398080e7          	jalr	920(ra) # 6724 <sbrk>
    exit(0,"");
    3394:	00005597          	auipc	a1,0x5
    3398:	ea458593          	addi	a1,a1,-348 # 8238 <malloc+0x173e>
    339c:	4501                	li	a0,0
    339e:	00003097          	auipc	ra,0x3
    33a2:	2fe080e7          	jalr	766(ra) # 669c <exit>
    printf("fork failed\n");
    33a6:	00004517          	auipc	a0,0x4
    33aa:	53250513          	addi	a0,a0,1330 # 78d8 <malloc+0xdde>
    33ae:	00003097          	auipc	ra,0x3
    33b2:	68e080e7          	jalr	1678(ra) # 6a3c <printf>
    exit(1,"");
    33b6:	00005597          	auipc	a1,0x5
    33ba:	e8258593          	addi	a1,a1,-382 # 8238 <malloc+0x173e>
    33be:	4505                	li	a0,1
    33c0:	00003097          	auipc	ra,0x3
    33c4:	2dc080e7          	jalr	732(ra) # 669c <exit>
  wait(0,0);
    33c8:	4581                	li	a1,0
    33ca:	4501                	li	a0,0
    33cc:	00003097          	auipc	ra,0x3
    33d0:	2d8080e7          	jalr	728(ra) # 66a4 <wait>
  pid = fork();
    33d4:	00003097          	auipc	ra,0x3
    33d8:	2c0080e7          	jalr	704(ra) # 6694 <fork>
  if(pid < 0){
    33dc:	02054e63          	bltz	a0,3418 <sbrkbugs+0x116>
  if(pid == 0){
    33e0:	ed29                	bnez	a0,343a <sbrkbugs+0x138>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    33e2:	00003097          	auipc	ra,0x3
    33e6:	342080e7          	jalr	834(ra) # 6724 <sbrk>
    33ea:	67ad                	lui	a5,0xb
    33ec:	8007879b          	addiw	a5,a5,-2048
    33f0:	40a7853b          	subw	a0,a5,a0
    33f4:	00003097          	auipc	ra,0x3
    33f8:	330080e7          	jalr	816(ra) # 6724 <sbrk>
    sbrk(-10);
    33fc:	5559                	li	a0,-10
    33fe:	00003097          	auipc	ra,0x3
    3402:	326080e7          	jalr	806(ra) # 6724 <sbrk>
    exit(0,"");
    3406:	00005597          	auipc	a1,0x5
    340a:	e3258593          	addi	a1,a1,-462 # 8238 <malloc+0x173e>
    340e:	4501                	li	a0,0
    3410:	00003097          	auipc	ra,0x3
    3414:	28c080e7          	jalr	652(ra) # 669c <exit>
    printf("fork failed\n");
    3418:	00004517          	auipc	a0,0x4
    341c:	4c050513          	addi	a0,a0,1216 # 78d8 <malloc+0xdde>
    3420:	00003097          	auipc	ra,0x3
    3424:	61c080e7          	jalr	1564(ra) # 6a3c <printf>
    exit(1,"");
    3428:	00005597          	auipc	a1,0x5
    342c:	e1058593          	addi	a1,a1,-496 # 8238 <malloc+0x173e>
    3430:	4505                	li	a0,1
    3432:	00003097          	auipc	ra,0x3
    3436:	26a080e7          	jalr	618(ra) # 669c <exit>
  wait(0,0);
    343a:	4581                	li	a1,0
    343c:	4501                	li	a0,0
    343e:	00003097          	auipc	ra,0x3
    3442:	266080e7          	jalr	614(ra) # 66a4 <wait>
  exit(0,"");
    3446:	00005597          	auipc	a1,0x5
    344a:	df258593          	addi	a1,a1,-526 # 8238 <malloc+0x173e>
    344e:	4501                	li	a0,0
    3450:	00003097          	auipc	ra,0x3
    3454:	24c080e7          	jalr	588(ra) # 669c <exit>

0000000000003458 <sbrklast>:
{
    3458:	7179                	addi	sp,sp,-48
    345a:	f406                	sd	ra,40(sp)
    345c:	f022                	sd	s0,32(sp)
    345e:	ec26                	sd	s1,24(sp)
    3460:	e84a                	sd	s2,16(sp)
    3462:	e44e                	sd	s3,8(sp)
    3464:	e052                	sd	s4,0(sp)
    3466:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    3468:	4501                	li	a0,0
    346a:	00003097          	auipc	ra,0x3
    346e:	2ba080e7          	jalr	698(ra) # 6724 <sbrk>
  if((top % 4096) != 0)
    3472:	03451793          	slli	a5,a0,0x34
    3476:	ebd9                	bnez	a5,350c <sbrklast+0xb4>
  sbrk(4096);
    3478:	6505                	lui	a0,0x1
    347a:	00003097          	auipc	ra,0x3
    347e:	2aa080e7          	jalr	682(ra) # 6724 <sbrk>
  sbrk(10);
    3482:	4529                	li	a0,10
    3484:	00003097          	auipc	ra,0x3
    3488:	2a0080e7          	jalr	672(ra) # 6724 <sbrk>
  sbrk(-20);
    348c:	5531                	li	a0,-20
    348e:	00003097          	auipc	ra,0x3
    3492:	296080e7          	jalr	662(ra) # 6724 <sbrk>
  top = (uint64) sbrk(0);
    3496:	4501                	li	a0,0
    3498:	00003097          	auipc	ra,0x3
    349c:	28c080e7          	jalr	652(ra) # 6724 <sbrk>
    34a0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    34a2:	fc050913          	addi	s2,a0,-64 # fc0 <unlinkread+0x148>
  p[0] = 'x';
    34a6:	07800a13          	li	s4,120
    34aa:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    34ae:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    34b2:	20200593          	li	a1,514
    34b6:	854a                	mv	a0,s2
    34b8:	00003097          	auipc	ra,0x3
    34bc:	224080e7          	jalr	548(ra) # 66dc <open>
    34c0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    34c2:	4605                	li	a2,1
    34c4:	85ca                	mv	a1,s2
    34c6:	00003097          	auipc	ra,0x3
    34ca:	1f6080e7          	jalr	502(ra) # 66bc <write>
  close(fd);
    34ce:	854e                	mv	a0,s3
    34d0:	00003097          	auipc	ra,0x3
    34d4:	1f4080e7          	jalr	500(ra) # 66c4 <close>
  fd = open(p, O_RDWR);
    34d8:	4589                	li	a1,2
    34da:	854a                	mv	a0,s2
    34dc:	00003097          	auipc	ra,0x3
    34e0:	200080e7          	jalr	512(ra) # 66dc <open>
  p[0] = '\0';
    34e4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    34e8:	4605                	li	a2,1
    34ea:	85ca                	mv	a1,s2
    34ec:	00003097          	auipc	ra,0x3
    34f0:	1c8080e7          	jalr	456(ra) # 66b4 <read>
  if(p[0] != 'x')
    34f4:	fc04c783          	lbu	a5,-64(s1)
    34f8:	03479463          	bne	a5,s4,3520 <sbrklast+0xc8>
}
    34fc:	70a2                	ld	ra,40(sp)
    34fe:	7402                	ld	s0,32(sp)
    3500:	64e2                	ld	s1,24(sp)
    3502:	6942                	ld	s2,16(sp)
    3504:	69a2                	ld	s3,8(sp)
    3506:	6a02                	ld	s4,0(sp)
    3508:	6145                	addi	sp,sp,48
    350a:	8082                	ret
    sbrk(4096 - (top % 4096));
    350c:	0347d513          	srli	a0,a5,0x34
    3510:	6785                	lui	a5,0x1
    3512:	40a7853b          	subw	a0,a5,a0
    3516:	00003097          	auipc	ra,0x3
    351a:	20e080e7          	jalr	526(ra) # 6724 <sbrk>
    351e:	bfa9                	j	3478 <sbrklast+0x20>
    exit(1,"");
    3520:	00005597          	auipc	a1,0x5
    3524:	d1858593          	addi	a1,a1,-744 # 8238 <malloc+0x173e>
    3528:	4505                	li	a0,1
    352a:	00003097          	auipc	ra,0x3
    352e:	172080e7          	jalr	370(ra) # 669c <exit>

0000000000003532 <sbrk8000>:
{
    3532:	1141                	addi	sp,sp,-16
    3534:	e406                	sd	ra,8(sp)
    3536:	e022                	sd	s0,0(sp)
    3538:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    353a:	80000537          	lui	a0,0x80000
    353e:	0511                	addi	a0,a0,4
    3540:	00003097          	auipc	ra,0x3
    3544:	1e4080e7          	jalr	484(ra) # 6724 <sbrk>
  volatile char *top = sbrk(0);
    3548:	4501                	li	a0,0
    354a:	00003097          	auipc	ra,0x3
    354e:	1da080e7          	jalr	474(ra) # 6724 <sbrk>
  *(top-1) = *(top-1) + 1;
    3552:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7ffef387>
    3556:	0785                	addi	a5,a5,1
    3558:	0ff7f793          	andi	a5,a5,255
    355c:	fef50fa3          	sb	a5,-1(a0)
}
    3560:	60a2                	ld	ra,8(sp)
    3562:	6402                	ld	s0,0(sp)
    3564:	0141                	addi	sp,sp,16
    3566:	8082                	ret

0000000000003568 <execout>:
{
    3568:	715d                	addi	sp,sp,-80
    356a:	e486                	sd	ra,72(sp)
    356c:	e0a2                	sd	s0,64(sp)
    356e:	fc26                	sd	s1,56(sp)
    3570:	f84a                	sd	s2,48(sp)
    3572:	f44e                	sd	s3,40(sp)
    3574:	f052                	sd	s4,32(sp)
    3576:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3578:	4901                	li	s2,0
    357a:	49bd                	li	s3,15
    int pid = fork();
    357c:	00003097          	auipc	ra,0x3
    3580:	118080e7          	jalr	280(ra) # 6694 <fork>
    3584:	84aa                	mv	s1,a0
    if(pid < 0){
    3586:	02054563          	bltz	a0,35b0 <execout+0x48>
    } else if(pid == 0){
    358a:	c521                	beqz	a0,35d2 <execout+0x6a>
      wait((int*)0,0);
    358c:	4581                	li	a1,0
    358e:	4501                	li	a0,0
    3590:	00003097          	auipc	ra,0x3
    3594:	114080e7          	jalr	276(ra) # 66a4 <wait>
  for(int avail = 0; avail < 15; avail++){
    3598:	2905                	addiw	s2,s2,1
    359a:	ff3911e3          	bne	s2,s3,357c <execout+0x14>
  exit(0,"");
    359e:	00005597          	auipc	a1,0x5
    35a2:	c9a58593          	addi	a1,a1,-870 # 8238 <malloc+0x173e>
    35a6:	4501                	li	a0,0
    35a8:	00003097          	auipc	ra,0x3
    35ac:	0f4080e7          	jalr	244(ra) # 669c <exit>
      printf("fork failed\n");
    35b0:	00004517          	auipc	a0,0x4
    35b4:	32850513          	addi	a0,a0,808 # 78d8 <malloc+0xdde>
    35b8:	00003097          	auipc	ra,0x3
    35bc:	484080e7          	jalr	1156(ra) # 6a3c <printf>
      exit(1,"");
    35c0:	00005597          	auipc	a1,0x5
    35c4:	c7858593          	addi	a1,a1,-904 # 8238 <malloc+0x173e>
    35c8:	4505                	li	a0,1
    35ca:	00003097          	auipc	ra,0x3
    35ce:	0d2080e7          	jalr	210(ra) # 669c <exit>
        if(a == 0xffffffffffffffffLL)
    35d2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    35d4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    35d6:	6505                	lui	a0,0x1
    35d8:	00003097          	auipc	ra,0x3
    35dc:	14c080e7          	jalr	332(ra) # 6724 <sbrk>
        if(a == 0xffffffffffffffffLL)
    35e0:	01350763          	beq	a0,s3,35ee <execout+0x86>
        *(char*)(a + 4096 - 1) = 1;
    35e4:	6785                	lui	a5,0x1
    35e6:	953e                	add	a0,a0,a5
    35e8:	ff450fa3          	sb	s4,-1(a0) # fff <unlinkread+0x187>
      while(1){
    35ec:	b7ed                	j	35d6 <execout+0x6e>
      for(int i = 0; i < avail; i++)
    35ee:	01205a63          	blez	s2,3602 <execout+0x9a>
        sbrk(-4096);
    35f2:	757d                	lui	a0,0xfffff
    35f4:	00003097          	auipc	ra,0x3
    35f8:	130080e7          	jalr	304(ra) # 6724 <sbrk>
      for(int i = 0; i < avail; i++)
    35fc:	2485                	addiw	s1,s1,1
    35fe:	ff249ae3          	bne	s1,s2,35f2 <execout+0x8a>
      close(1);
    3602:	4505                	li	a0,1
    3604:	00003097          	auipc	ra,0x3
    3608:	0c0080e7          	jalr	192(ra) # 66c4 <close>
      char *args[] = { "echo", "x", 0 };
    360c:	00003517          	auipc	a0,0x3
    3610:	62c50513          	addi	a0,a0,1580 # 6c38 <malloc+0x13e>
    3614:	faa43c23          	sd	a0,-72(s0)
    3618:	00003797          	auipc	a5,0x3
    361c:	69078793          	addi	a5,a5,1680 # 6ca8 <malloc+0x1ae>
    3620:	fcf43023          	sd	a5,-64(s0)
    3624:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3628:	fb840593          	addi	a1,s0,-72
    362c:	00003097          	auipc	ra,0x3
    3630:	0a8080e7          	jalr	168(ra) # 66d4 <exec>
      exit(0,"");
    3634:	00005597          	auipc	a1,0x5
    3638:	c0458593          	addi	a1,a1,-1020 # 8238 <malloc+0x173e>
    363c:	4501                	li	a0,0
    363e:	00003097          	auipc	ra,0x3
    3642:	05e080e7          	jalr	94(ra) # 669c <exit>

0000000000003646 <fourteen>:
{
    3646:	1101                	addi	sp,sp,-32
    3648:	ec06                	sd	ra,24(sp)
    364a:	e822                	sd	s0,16(sp)
    364c:	e426                	sd	s1,8(sp)
    364e:	1000                	addi	s0,sp,32
    3650:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3652:	00004517          	auipc	a0,0x4
    3656:	79650513          	addi	a0,a0,1942 # 7de8 <malloc+0x12ee>
    365a:	00003097          	auipc	ra,0x3
    365e:	0aa080e7          	jalr	170(ra) # 6704 <mkdir>
    3662:	e175                	bnez	a0,3746 <fourteen+0x100>
  if(mkdir("12345678901234/123456789012345") != 0){
    3664:	00004517          	auipc	a0,0x4
    3668:	5dc50513          	addi	a0,a0,1500 # 7c40 <malloc+0x1146>
    366c:	00003097          	auipc	ra,0x3
    3670:	098080e7          	jalr	152(ra) # 6704 <mkdir>
    3674:	e97d                	bnez	a0,376a <fourteen+0x124>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3676:	20000593          	li	a1,512
    367a:	00004517          	auipc	a0,0x4
    367e:	61e50513          	addi	a0,a0,1566 # 7c98 <malloc+0x119e>
    3682:	00003097          	auipc	ra,0x3
    3686:	05a080e7          	jalr	90(ra) # 66dc <open>
  if(fd < 0){
    368a:	10054263          	bltz	a0,378e <fourteen+0x148>
  close(fd);
    368e:	00003097          	auipc	ra,0x3
    3692:	036080e7          	jalr	54(ra) # 66c4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3696:	4581                	li	a1,0
    3698:	00004517          	auipc	a0,0x4
    369c:	67850513          	addi	a0,a0,1656 # 7d10 <malloc+0x1216>
    36a0:	00003097          	auipc	ra,0x3
    36a4:	03c080e7          	jalr	60(ra) # 66dc <open>
  if(fd < 0){
    36a8:	10054563          	bltz	a0,37b2 <fourteen+0x16c>
  close(fd);
    36ac:	00003097          	auipc	ra,0x3
    36b0:	018080e7          	jalr	24(ra) # 66c4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    36b4:	00004517          	auipc	a0,0x4
    36b8:	6cc50513          	addi	a0,a0,1740 # 7d80 <malloc+0x1286>
    36bc:	00003097          	auipc	ra,0x3
    36c0:	048080e7          	jalr	72(ra) # 6704 <mkdir>
    36c4:	10050963          	beqz	a0,37d6 <fourteen+0x190>
  if(mkdir("123456789012345/12345678901234") == 0){
    36c8:	00004517          	auipc	a0,0x4
    36cc:	71050513          	addi	a0,a0,1808 # 7dd8 <malloc+0x12de>
    36d0:	00003097          	auipc	ra,0x3
    36d4:	034080e7          	jalr	52(ra) # 6704 <mkdir>
    36d8:	12050163          	beqz	a0,37fa <fourteen+0x1b4>
  unlink("123456789012345/12345678901234");
    36dc:	00004517          	auipc	a0,0x4
    36e0:	6fc50513          	addi	a0,a0,1788 # 7dd8 <malloc+0x12de>
    36e4:	00003097          	auipc	ra,0x3
    36e8:	008080e7          	jalr	8(ra) # 66ec <unlink>
  unlink("12345678901234/12345678901234");
    36ec:	00004517          	auipc	a0,0x4
    36f0:	69450513          	addi	a0,a0,1684 # 7d80 <malloc+0x1286>
    36f4:	00003097          	auipc	ra,0x3
    36f8:	ff8080e7          	jalr	-8(ra) # 66ec <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    36fc:	00004517          	auipc	a0,0x4
    3700:	61450513          	addi	a0,a0,1556 # 7d10 <malloc+0x1216>
    3704:	00003097          	auipc	ra,0x3
    3708:	fe8080e7          	jalr	-24(ra) # 66ec <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    370c:	00004517          	auipc	a0,0x4
    3710:	58c50513          	addi	a0,a0,1420 # 7c98 <malloc+0x119e>
    3714:	00003097          	auipc	ra,0x3
    3718:	fd8080e7          	jalr	-40(ra) # 66ec <unlink>
  unlink("12345678901234/123456789012345");
    371c:	00004517          	auipc	a0,0x4
    3720:	52450513          	addi	a0,a0,1316 # 7c40 <malloc+0x1146>
    3724:	00003097          	auipc	ra,0x3
    3728:	fc8080e7          	jalr	-56(ra) # 66ec <unlink>
  unlink("12345678901234");
    372c:	00004517          	auipc	a0,0x4
    3730:	6bc50513          	addi	a0,a0,1724 # 7de8 <malloc+0x12ee>
    3734:	00003097          	auipc	ra,0x3
    3738:	fb8080e7          	jalr	-72(ra) # 66ec <unlink>
}
    373c:	60e2                	ld	ra,24(sp)
    373e:	6442                	ld	s0,16(sp)
    3740:	64a2                	ld	s1,8(sp)
    3742:	6105                	addi	sp,sp,32
    3744:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3746:	85a6                	mv	a1,s1
    3748:	00004517          	auipc	a0,0x4
    374c:	4d050513          	addi	a0,a0,1232 # 7c18 <malloc+0x111e>
    3750:	00003097          	auipc	ra,0x3
    3754:	2ec080e7          	jalr	748(ra) # 6a3c <printf>
    exit(1,"");
    3758:	00005597          	auipc	a1,0x5
    375c:	ae058593          	addi	a1,a1,-1312 # 8238 <malloc+0x173e>
    3760:	4505                	li	a0,1
    3762:	00003097          	auipc	ra,0x3
    3766:	f3a080e7          	jalr	-198(ra) # 669c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    376a:	85a6                	mv	a1,s1
    376c:	00004517          	auipc	a0,0x4
    3770:	4f450513          	addi	a0,a0,1268 # 7c60 <malloc+0x1166>
    3774:	00003097          	auipc	ra,0x3
    3778:	2c8080e7          	jalr	712(ra) # 6a3c <printf>
    exit(1,"");
    377c:	00005597          	auipc	a1,0x5
    3780:	abc58593          	addi	a1,a1,-1348 # 8238 <malloc+0x173e>
    3784:	4505                	li	a0,1
    3786:	00003097          	auipc	ra,0x3
    378a:	f16080e7          	jalr	-234(ra) # 669c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    378e:	85a6                	mv	a1,s1
    3790:	00004517          	auipc	a0,0x4
    3794:	53850513          	addi	a0,a0,1336 # 7cc8 <malloc+0x11ce>
    3798:	00003097          	auipc	ra,0x3
    379c:	2a4080e7          	jalr	676(ra) # 6a3c <printf>
    exit(1,"");
    37a0:	00005597          	auipc	a1,0x5
    37a4:	a9858593          	addi	a1,a1,-1384 # 8238 <malloc+0x173e>
    37a8:	4505                	li	a0,1
    37aa:	00003097          	auipc	ra,0x3
    37ae:	ef2080e7          	jalr	-270(ra) # 669c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    37b2:	85a6                	mv	a1,s1
    37b4:	00004517          	auipc	a0,0x4
    37b8:	58c50513          	addi	a0,a0,1420 # 7d40 <malloc+0x1246>
    37bc:	00003097          	auipc	ra,0x3
    37c0:	280080e7          	jalr	640(ra) # 6a3c <printf>
    exit(1,"");
    37c4:	00005597          	auipc	a1,0x5
    37c8:	a7458593          	addi	a1,a1,-1420 # 8238 <malloc+0x173e>
    37cc:	4505                	li	a0,1
    37ce:	00003097          	auipc	ra,0x3
    37d2:	ece080e7          	jalr	-306(ra) # 669c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    37d6:	85a6                	mv	a1,s1
    37d8:	00004517          	auipc	a0,0x4
    37dc:	5c850513          	addi	a0,a0,1480 # 7da0 <malloc+0x12a6>
    37e0:	00003097          	auipc	ra,0x3
    37e4:	25c080e7          	jalr	604(ra) # 6a3c <printf>
    exit(1,"");
    37e8:	00005597          	auipc	a1,0x5
    37ec:	a5058593          	addi	a1,a1,-1456 # 8238 <malloc+0x173e>
    37f0:	4505                	li	a0,1
    37f2:	00003097          	auipc	ra,0x3
    37f6:	eaa080e7          	jalr	-342(ra) # 669c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    37fa:	85a6                	mv	a1,s1
    37fc:	00004517          	auipc	a0,0x4
    3800:	5fc50513          	addi	a0,a0,1532 # 7df8 <malloc+0x12fe>
    3804:	00003097          	auipc	ra,0x3
    3808:	238080e7          	jalr	568(ra) # 6a3c <printf>
    exit(1,"");
    380c:	00005597          	auipc	a1,0x5
    3810:	a2c58593          	addi	a1,a1,-1492 # 8238 <malloc+0x173e>
    3814:	4505                	li	a0,1
    3816:	00003097          	auipc	ra,0x3
    381a:	e86080e7          	jalr	-378(ra) # 669c <exit>

000000000000381e <diskfull>:
{
    381e:	b9010113          	addi	sp,sp,-1136
    3822:	46113423          	sd	ra,1128(sp)
    3826:	46813023          	sd	s0,1120(sp)
    382a:	44913c23          	sd	s1,1112(sp)
    382e:	45213823          	sd	s2,1104(sp)
    3832:	45313423          	sd	s3,1096(sp)
    3836:	45413023          	sd	s4,1088(sp)
    383a:	43513c23          	sd	s5,1080(sp)
    383e:	43613823          	sd	s6,1072(sp)
    3842:	43713423          	sd	s7,1064(sp)
    3846:	43813023          	sd	s8,1056(sp)
    384a:	47010413          	addi	s0,sp,1136
    384e:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3850:	00004517          	auipc	a0,0x4
    3854:	5e050513          	addi	a0,a0,1504 # 7e30 <malloc+0x1336>
    3858:	00003097          	auipc	ra,0x3
    385c:	e94080e7          	jalr	-364(ra) # 66ec <unlink>
  for(fi = 0; done == 0; fi++){
    3860:	4a01                	li	s4,0
    name[0] = 'b';
    3862:	06200b13          	li	s6,98
    name[1] = 'i';
    3866:	06900a93          	li	s5,105
    name[2] = 'g';
    386a:	06700993          	li	s3,103
    386e:	10c00b93          	li	s7,268
    3872:	aabd                	j	39f0 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3874:	b9040613          	addi	a2,s0,-1136
    3878:	85e2                	mv	a1,s8
    387a:	00004517          	auipc	a0,0x4
    387e:	5c650513          	addi	a0,a0,1478 # 7e40 <malloc+0x1346>
    3882:	00003097          	auipc	ra,0x3
    3886:	1ba080e7          	jalr	442(ra) # 6a3c <printf>
      break;
    388a:	a821                	j	38a2 <diskfull+0x84>
        close(fd);
    388c:	854a                	mv	a0,s2
    388e:	00003097          	auipc	ra,0x3
    3892:	e36080e7          	jalr	-458(ra) # 66c4 <close>
    close(fd);
    3896:	854a                	mv	a0,s2
    3898:	00003097          	auipc	ra,0x3
    389c:	e2c080e7          	jalr	-468(ra) # 66c4 <close>
  for(fi = 0; done == 0; fi++){
    38a0:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    38a2:	4481                	li	s1,0
    name[0] = 'z';
    38a4:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    38a8:	08000993          	li	s3,128
    name[0] = 'z';
    38ac:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    38b0:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    38b4:	41f4d79b          	sraiw	a5,s1,0x1f
    38b8:	01b7d71b          	srliw	a4,a5,0x1b
    38bc:	009707bb          	addw	a5,a4,s1
    38c0:	4057d69b          	sraiw	a3,a5,0x5
    38c4:	0306869b          	addiw	a3,a3,48
    38c8:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    38cc:	8bfd                	andi	a5,a5,31
    38ce:	9f99                	subw	a5,a5,a4
    38d0:	0307879b          	addiw	a5,a5,48
    38d4:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    38d8:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    38dc:	bb040513          	addi	a0,s0,-1104
    38e0:	00003097          	auipc	ra,0x3
    38e4:	e0c080e7          	jalr	-500(ra) # 66ec <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    38e8:	60200593          	li	a1,1538
    38ec:	bb040513          	addi	a0,s0,-1104
    38f0:	00003097          	auipc	ra,0x3
    38f4:	dec080e7          	jalr	-532(ra) # 66dc <open>
    if(fd < 0)
    38f8:	00054963          	bltz	a0,390a <diskfull+0xec>
    close(fd);
    38fc:	00003097          	auipc	ra,0x3
    3900:	dc8080e7          	jalr	-568(ra) # 66c4 <close>
  for(int i = 0; i < nzz; i++){
    3904:	2485                	addiw	s1,s1,1
    3906:	fb3493e3          	bne	s1,s3,38ac <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    390a:	00004517          	auipc	a0,0x4
    390e:	52650513          	addi	a0,a0,1318 # 7e30 <malloc+0x1336>
    3912:	00003097          	auipc	ra,0x3
    3916:	df2080e7          	jalr	-526(ra) # 6704 <mkdir>
    391a:	12050963          	beqz	a0,3a4c <diskfull+0x22e>
  unlink("diskfulldir");
    391e:	00004517          	auipc	a0,0x4
    3922:	51250513          	addi	a0,a0,1298 # 7e30 <malloc+0x1336>
    3926:	00003097          	auipc	ra,0x3
    392a:	dc6080e7          	jalr	-570(ra) # 66ec <unlink>
  for(int i = 0; i < nzz; i++){
    392e:	4481                	li	s1,0
    name[0] = 'z';
    3930:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3934:	08000993          	li	s3,128
    name[0] = 'z';
    3938:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    393c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3940:	41f4d79b          	sraiw	a5,s1,0x1f
    3944:	01b7d71b          	srliw	a4,a5,0x1b
    3948:	009707bb          	addw	a5,a4,s1
    394c:	4057d69b          	sraiw	a3,a5,0x5
    3950:	0306869b          	addiw	a3,a3,48
    3954:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3958:	8bfd                	andi	a5,a5,31
    395a:	9f99                	subw	a5,a5,a4
    395c:	0307879b          	addiw	a5,a5,48
    3960:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3964:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3968:	bb040513          	addi	a0,s0,-1104
    396c:	00003097          	auipc	ra,0x3
    3970:	d80080e7          	jalr	-640(ra) # 66ec <unlink>
  for(int i = 0; i < nzz; i++){
    3974:	2485                	addiw	s1,s1,1
    3976:	fd3491e3          	bne	s1,s3,3938 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    397a:	03405e63          	blez	s4,39b6 <diskfull+0x198>
    397e:	4481                	li	s1,0
    name[0] = 'b';
    3980:	06200a93          	li	s5,98
    name[1] = 'i';
    3984:	06900993          	li	s3,105
    name[2] = 'g';
    3988:	06700913          	li	s2,103
    name[0] = 'b';
    398c:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3990:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3994:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3998:	0304879b          	addiw	a5,s1,48
    399c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    39a0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    39a4:	bb040513          	addi	a0,s0,-1104
    39a8:	00003097          	auipc	ra,0x3
    39ac:	d44080e7          	jalr	-700(ra) # 66ec <unlink>
  for(int i = 0; i < fi; i++){
    39b0:	2485                	addiw	s1,s1,1
    39b2:	fd449de3          	bne	s1,s4,398c <diskfull+0x16e>
}
    39b6:	46813083          	ld	ra,1128(sp)
    39ba:	46013403          	ld	s0,1120(sp)
    39be:	45813483          	ld	s1,1112(sp)
    39c2:	45013903          	ld	s2,1104(sp)
    39c6:	44813983          	ld	s3,1096(sp)
    39ca:	44013a03          	ld	s4,1088(sp)
    39ce:	43813a83          	ld	s5,1080(sp)
    39d2:	43013b03          	ld	s6,1072(sp)
    39d6:	42813b83          	ld	s7,1064(sp)
    39da:	42013c03          	ld	s8,1056(sp)
    39de:	47010113          	addi	sp,sp,1136
    39e2:	8082                	ret
    close(fd);
    39e4:	854a                	mv	a0,s2
    39e6:	00003097          	auipc	ra,0x3
    39ea:	cde080e7          	jalr	-802(ra) # 66c4 <close>
  for(fi = 0; done == 0; fi++){
    39ee:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    39f0:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    39f4:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    39f8:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    39fc:	030a079b          	addiw	a5,s4,48
    3a00:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    3a04:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3a08:	b9040513          	addi	a0,s0,-1136
    3a0c:	00003097          	auipc	ra,0x3
    3a10:	ce0080e7          	jalr	-800(ra) # 66ec <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3a14:	60200593          	li	a1,1538
    3a18:	b9040513          	addi	a0,s0,-1136
    3a1c:	00003097          	auipc	ra,0x3
    3a20:	cc0080e7          	jalr	-832(ra) # 66dc <open>
    3a24:	892a                	mv	s2,a0
    if(fd < 0){
    3a26:	e40547e3          	bltz	a0,3874 <diskfull+0x56>
    3a2a:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3a2c:	40000613          	li	a2,1024
    3a30:	bb040593          	addi	a1,s0,-1104
    3a34:	854a                	mv	a0,s2
    3a36:	00003097          	auipc	ra,0x3
    3a3a:	c86080e7          	jalr	-890(ra) # 66bc <write>
    3a3e:	40000793          	li	a5,1024
    3a42:	e4f515e3          	bne	a0,a5,388c <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3a46:	34fd                	addiw	s1,s1,-1
    3a48:	f0f5                	bnez	s1,3a2c <diskfull+0x20e>
    3a4a:	bf69                	j	39e4 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3a4c:	00004517          	auipc	a0,0x4
    3a50:	41450513          	addi	a0,a0,1044 # 7e60 <malloc+0x1366>
    3a54:	00003097          	auipc	ra,0x3
    3a58:	fe8080e7          	jalr	-24(ra) # 6a3c <printf>
    3a5c:	b5c9                	j	391e <diskfull+0x100>

0000000000003a5e <iputtest>:
{
    3a5e:	1101                	addi	sp,sp,-32
    3a60:	ec06                	sd	ra,24(sp)
    3a62:	e822                	sd	s0,16(sp)
    3a64:	e426                	sd	s1,8(sp)
    3a66:	1000                	addi	s0,sp,32
    3a68:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3a6a:	00004517          	auipc	a0,0x4
    3a6e:	42650513          	addi	a0,a0,1062 # 7e90 <malloc+0x1396>
    3a72:	00003097          	auipc	ra,0x3
    3a76:	c92080e7          	jalr	-878(ra) # 6704 <mkdir>
    3a7a:	04054563          	bltz	a0,3ac4 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3a7e:	00004517          	auipc	a0,0x4
    3a82:	41250513          	addi	a0,a0,1042 # 7e90 <malloc+0x1396>
    3a86:	00003097          	auipc	ra,0x3
    3a8a:	c86080e7          	jalr	-890(ra) # 670c <chdir>
    3a8e:	04054d63          	bltz	a0,3ae8 <iputtest+0x8a>
  if(unlink("../iputdir") < 0){
    3a92:	00004517          	auipc	a0,0x4
    3a96:	43e50513          	addi	a0,a0,1086 # 7ed0 <malloc+0x13d6>
    3a9a:	00003097          	auipc	ra,0x3
    3a9e:	c52080e7          	jalr	-942(ra) # 66ec <unlink>
    3aa2:	06054563          	bltz	a0,3b0c <iputtest+0xae>
  if(chdir("/") < 0){
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	45a50513          	addi	a0,a0,1114 # 7f00 <malloc+0x1406>
    3aae:	00003097          	auipc	ra,0x3
    3ab2:	c5e080e7          	jalr	-930(ra) # 670c <chdir>
    3ab6:	06054d63          	bltz	a0,3b30 <iputtest+0xd2>
}
    3aba:	60e2                	ld	ra,24(sp)
    3abc:	6442                	ld	s0,16(sp)
    3abe:	64a2                	ld	s1,8(sp)
    3ac0:	6105                	addi	sp,sp,32
    3ac2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3ac4:	85a6                	mv	a1,s1
    3ac6:	00004517          	auipc	a0,0x4
    3aca:	3d250513          	addi	a0,a0,978 # 7e98 <malloc+0x139e>
    3ace:	00003097          	auipc	ra,0x3
    3ad2:	f6e080e7          	jalr	-146(ra) # 6a3c <printf>
    exit(1,"");
    3ad6:	00004597          	auipc	a1,0x4
    3ada:	76258593          	addi	a1,a1,1890 # 8238 <malloc+0x173e>
    3ade:	4505                	li	a0,1
    3ae0:	00003097          	auipc	ra,0x3
    3ae4:	bbc080e7          	jalr	-1092(ra) # 669c <exit>
    printf("%s: chdir iputdir failed\n", s);
    3ae8:	85a6                	mv	a1,s1
    3aea:	00004517          	auipc	a0,0x4
    3aee:	3c650513          	addi	a0,a0,966 # 7eb0 <malloc+0x13b6>
    3af2:	00003097          	auipc	ra,0x3
    3af6:	f4a080e7          	jalr	-182(ra) # 6a3c <printf>
    exit(1,"");
    3afa:	00004597          	auipc	a1,0x4
    3afe:	73e58593          	addi	a1,a1,1854 # 8238 <malloc+0x173e>
    3b02:	4505                	li	a0,1
    3b04:	00003097          	auipc	ra,0x3
    3b08:	b98080e7          	jalr	-1128(ra) # 669c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3b0c:	85a6                	mv	a1,s1
    3b0e:	00004517          	auipc	a0,0x4
    3b12:	3d250513          	addi	a0,a0,978 # 7ee0 <malloc+0x13e6>
    3b16:	00003097          	auipc	ra,0x3
    3b1a:	f26080e7          	jalr	-218(ra) # 6a3c <printf>
    exit(1,"");
    3b1e:	00004597          	auipc	a1,0x4
    3b22:	71a58593          	addi	a1,a1,1818 # 8238 <malloc+0x173e>
    3b26:	4505                	li	a0,1
    3b28:	00003097          	auipc	ra,0x3
    3b2c:	b74080e7          	jalr	-1164(ra) # 669c <exit>
    printf("%s: chdir / failed\n", s);
    3b30:	85a6                	mv	a1,s1
    3b32:	00004517          	auipc	a0,0x4
    3b36:	3d650513          	addi	a0,a0,982 # 7f08 <malloc+0x140e>
    3b3a:	00003097          	auipc	ra,0x3
    3b3e:	f02080e7          	jalr	-254(ra) # 6a3c <printf>
    exit(1,"");
    3b42:	00004597          	auipc	a1,0x4
    3b46:	6f658593          	addi	a1,a1,1782 # 8238 <malloc+0x173e>
    3b4a:	4505                	li	a0,1
    3b4c:	00003097          	auipc	ra,0x3
    3b50:	b50080e7          	jalr	-1200(ra) # 669c <exit>

0000000000003b54 <exitiputtest>:
{
    3b54:	7179                	addi	sp,sp,-48
    3b56:	f406                	sd	ra,40(sp)
    3b58:	f022                	sd	s0,32(sp)
    3b5a:	ec26                	sd	s1,24(sp)
    3b5c:	1800                	addi	s0,sp,48
    3b5e:	84aa                	mv	s1,a0
  pid = fork();
    3b60:	00003097          	auipc	ra,0x3
    3b64:	b34080e7          	jalr	-1228(ra) # 6694 <fork>
  if(pid < 0){
    3b68:	04054a63          	bltz	a0,3bbc <exitiputtest+0x68>
  if(pid == 0){
    3b6c:	e165                	bnez	a0,3c4c <exitiputtest+0xf8>
    if(mkdir("iputdir") < 0){
    3b6e:	00004517          	auipc	a0,0x4
    3b72:	32250513          	addi	a0,a0,802 # 7e90 <malloc+0x1396>
    3b76:	00003097          	auipc	ra,0x3
    3b7a:	b8e080e7          	jalr	-1138(ra) # 6704 <mkdir>
    3b7e:	06054163          	bltz	a0,3be0 <exitiputtest+0x8c>
    if(chdir("iputdir") < 0){
    3b82:	00004517          	auipc	a0,0x4
    3b86:	30e50513          	addi	a0,a0,782 # 7e90 <malloc+0x1396>
    3b8a:	00003097          	auipc	ra,0x3
    3b8e:	b82080e7          	jalr	-1150(ra) # 670c <chdir>
    3b92:	06054963          	bltz	a0,3c04 <exitiputtest+0xb0>
    if(unlink("../iputdir") < 0){
    3b96:	00004517          	auipc	a0,0x4
    3b9a:	33a50513          	addi	a0,a0,826 # 7ed0 <malloc+0x13d6>
    3b9e:	00003097          	auipc	ra,0x3
    3ba2:	b4e080e7          	jalr	-1202(ra) # 66ec <unlink>
    3ba6:	08054163          	bltz	a0,3c28 <exitiputtest+0xd4>
    exit(0,"");
    3baa:	00004597          	auipc	a1,0x4
    3bae:	68e58593          	addi	a1,a1,1678 # 8238 <malloc+0x173e>
    3bb2:	4501                	li	a0,0
    3bb4:	00003097          	auipc	ra,0x3
    3bb8:	ae8080e7          	jalr	-1304(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    3bbc:	85a6                	mv	a1,s1
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	90250513          	addi	a0,a0,-1790 # 74c0 <malloc+0x9c6>
    3bc6:	00003097          	auipc	ra,0x3
    3bca:	e76080e7          	jalr	-394(ra) # 6a3c <printf>
    exit(1,"");
    3bce:	00004597          	auipc	a1,0x4
    3bd2:	66a58593          	addi	a1,a1,1642 # 8238 <malloc+0x173e>
    3bd6:	4505                	li	a0,1
    3bd8:	00003097          	auipc	ra,0x3
    3bdc:	ac4080e7          	jalr	-1340(ra) # 669c <exit>
      printf("%s: mkdir failed\n", s);
    3be0:	85a6                	mv	a1,s1
    3be2:	00004517          	auipc	a0,0x4
    3be6:	2b650513          	addi	a0,a0,694 # 7e98 <malloc+0x139e>
    3bea:	00003097          	auipc	ra,0x3
    3bee:	e52080e7          	jalr	-430(ra) # 6a3c <printf>
      exit(1,"");
    3bf2:	00004597          	auipc	a1,0x4
    3bf6:	64658593          	addi	a1,a1,1606 # 8238 <malloc+0x173e>
    3bfa:	4505                	li	a0,1
    3bfc:	00003097          	auipc	ra,0x3
    3c00:	aa0080e7          	jalr	-1376(ra) # 669c <exit>
      printf("%s: child chdir failed\n", s);
    3c04:	85a6                	mv	a1,s1
    3c06:	00004517          	auipc	a0,0x4
    3c0a:	31a50513          	addi	a0,a0,794 # 7f20 <malloc+0x1426>
    3c0e:	00003097          	auipc	ra,0x3
    3c12:	e2e080e7          	jalr	-466(ra) # 6a3c <printf>
      exit(1,"");
    3c16:	00004597          	auipc	a1,0x4
    3c1a:	62258593          	addi	a1,a1,1570 # 8238 <malloc+0x173e>
    3c1e:	4505                	li	a0,1
    3c20:	00003097          	auipc	ra,0x3
    3c24:	a7c080e7          	jalr	-1412(ra) # 669c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3c28:	85a6                	mv	a1,s1
    3c2a:	00004517          	auipc	a0,0x4
    3c2e:	2b650513          	addi	a0,a0,694 # 7ee0 <malloc+0x13e6>
    3c32:	00003097          	auipc	ra,0x3
    3c36:	e0a080e7          	jalr	-502(ra) # 6a3c <printf>
      exit(1,"");
    3c3a:	00004597          	auipc	a1,0x4
    3c3e:	5fe58593          	addi	a1,a1,1534 # 8238 <malloc+0x173e>
    3c42:	4505                	li	a0,1
    3c44:	00003097          	auipc	ra,0x3
    3c48:	a58080e7          	jalr	-1448(ra) # 669c <exit>
  wait(&xstatus,0);
    3c4c:	4581                	li	a1,0
    3c4e:	fdc40513          	addi	a0,s0,-36
    3c52:	00003097          	auipc	ra,0x3
    3c56:	a52080e7          	jalr	-1454(ra) # 66a4 <wait>
  exit(xstatus,"");
    3c5a:	00004597          	auipc	a1,0x4
    3c5e:	5de58593          	addi	a1,a1,1502 # 8238 <malloc+0x173e>
    3c62:	fdc42503          	lw	a0,-36(s0)
    3c66:	00003097          	auipc	ra,0x3
    3c6a:	a36080e7          	jalr	-1482(ra) # 669c <exit>

0000000000003c6e <dirtest>:
{
    3c6e:	1101                	addi	sp,sp,-32
    3c70:	ec06                	sd	ra,24(sp)
    3c72:	e822                	sd	s0,16(sp)
    3c74:	e426                	sd	s1,8(sp)
    3c76:	1000                	addi	s0,sp,32
    3c78:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3c7a:	00004517          	auipc	a0,0x4
    3c7e:	2be50513          	addi	a0,a0,702 # 7f38 <malloc+0x143e>
    3c82:	00003097          	auipc	ra,0x3
    3c86:	a82080e7          	jalr	-1406(ra) # 6704 <mkdir>
    3c8a:	04054563          	bltz	a0,3cd4 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3c8e:	00004517          	auipc	a0,0x4
    3c92:	2aa50513          	addi	a0,a0,682 # 7f38 <malloc+0x143e>
    3c96:	00003097          	auipc	ra,0x3
    3c9a:	a76080e7          	jalr	-1418(ra) # 670c <chdir>
    3c9e:	04054d63          	bltz	a0,3cf8 <dirtest+0x8a>
  if(chdir("..") < 0){
    3ca2:	00004517          	auipc	a0,0x4
    3ca6:	2b650513          	addi	a0,a0,694 # 7f58 <malloc+0x145e>
    3caa:	00003097          	auipc	ra,0x3
    3cae:	a62080e7          	jalr	-1438(ra) # 670c <chdir>
    3cb2:	06054563          	bltz	a0,3d1c <dirtest+0xae>
  if(unlink("dir0") < 0){
    3cb6:	00004517          	auipc	a0,0x4
    3cba:	28250513          	addi	a0,a0,642 # 7f38 <malloc+0x143e>
    3cbe:	00003097          	auipc	ra,0x3
    3cc2:	a2e080e7          	jalr	-1490(ra) # 66ec <unlink>
    3cc6:	06054d63          	bltz	a0,3d40 <dirtest+0xd2>
}
    3cca:	60e2                	ld	ra,24(sp)
    3ccc:	6442                	ld	s0,16(sp)
    3cce:	64a2                	ld	s1,8(sp)
    3cd0:	6105                	addi	sp,sp,32
    3cd2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3cd4:	85a6                	mv	a1,s1
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	1c250513          	addi	a0,a0,450 # 7e98 <malloc+0x139e>
    3cde:	00003097          	auipc	ra,0x3
    3ce2:	d5e080e7          	jalr	-674(ra) # 6a3c <printf>
    exit(1,"");
    3ce6:	00004597          	auipc	a1,0x4
    3cea:	55258593          	addi	a1,a1,1362 # 8238 <malloc+0x173e>
    3cee:	4505                	li	a0,1
    3cf0:	00003097          	auipc	ra,0x3
    3cf4:	9ac080e7          	jalr	-1620(ra) # 669c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cf8:	85a6                	mv	a1,s1
    3cfa:	00004517          	auipc	a0,0x4
    3cfe:	24650513          	addi	a0,a0,582 # 7f40 <malloc+0x1446>
    3d02:	00003097          	auipc	ra,0x3
    3d06:	d3a080e7          	jalr	-710(ra) # 6a3c <printf>
    exit(1,"");
    3d0a:	00004597          	auipc	a1,0x4
    3d0e:	52e58593          	addi	a1,a1,1326 # 8238 <malloc+0x173e>
    3d12:	4505                	li	a0,1
    3d14:	00003097          	auipc	ra,0x3
    3d18:	988080e7          	jalr	-1656(ra) # 669c <exit>
    printf("%s: chdir .. failed\n", s);
    3d1c:	85a6                	mv	a1,s1
    3d1e:	00004517          	auipc	a0,0x4
    3d22:	24250513          	addi	a0,a0,578 # 7f60 <malloc+0x1466>
    3d26:	00003097          	auipc	ra,0x3
    3d2a:	d16080e7          	jalr	-746(ra) # 6a3c <printf>
    exit(1,"");
    3d2e:	00004597          	auipc	a1,0x4
    3d32:	50a58593          	addi	a1,a1,1290 # 8238 <malloc+0x173e>
    3d36:	4505                	li	a0,1
    3d38:	00003097          	auipc	ra,0x3
    3d3c:	964080e7          	jalr	-1692(ra) # 669c <exit>
    printf("%s: unlink dir0 failed\n", s);
    3d40:	85a6                	mv	a1,s1
    3d42:	00004517          	auipc	a0,0x4
    3d46:	23650513          	addi	a0,a0,566 # 7f78 <malloc+0x147e>
    3d4a:	00003097          	auipc	ra,0x3
    3d4e:	cf2080e7          	jalr	-782(ra) # 6a3c <printf>
    exit(1,"");
    3d52:	00004597          	auipc	a1,0x4
    3d56:	4e658593          	addi	a1,a1,1254 # 8238 <malloc+0x173e>
    3d5a:	4505                	li	a0,1
    3d5c:	00003097          	auipc	ra,0x3
    3d60:	940080e7          	jalr	-1728(ra) # 669c <exit>

0000000000003d64 <subdir>:
{
    3d64:	1101                	addi	sp,sp,-32
    3d66:	ec06                	sd	ra,24(sp)
    3d68:	e822                	sd	s0,16(sp)
    3d6a:	e426                	sd	s1,8(sp)
    3d6c:	e04a                	sd	s2,0(sp)
    3d6e:	1000                	addi	s0,sp,32
    3d70:	892a                	mv	s2,a0
  unlink("ff");
    3d72:	00004517          	auipc	a0,0x4
    3d76:	34e50513          	addi	a0,a0,846 # 80c0 <malloc+0x15c6>
    3d7a:	00003097          	auipc	ra,0x3
    3d7e:	972080e7          	jalr	-1678(ra) # 66ec <unlink>
  if(mkdir("dd") != 0){
    3d82:	00004517          	auipc	a0,0x4
    3d86:	20e50513          	addi	a0,a0,526 # 7f90 <malloc+0x1496>
    3d8a:	00003097          	auipc	ra,0x3
    3d8e:	97a080e7          	jalr	-1670(ra) # 6704 <mkdir>
    3d92:	38051663          	bnez	a0,411e <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3d96:	20200593          	li	a1,514
    3d9a:	00004517          	auipc	a0,0x4
    3d9e:	21650513          	addi	a0,a0,534 # 7fb0 <malloc+0x14b6>
    3da2:	00003097          	auipc	ra,0x3
    3da6:	93a080e7          	jalr	-1734(ra) # 66dc <open>
    3daa:	84aa                	mv	s1,a0
  if(fd < 0){
    3dac:	38054b63          	bltz	a0,4142 <subdir+0x3de>
  write(fd, "ff", 2);
    3db0:	4609                	li	a2,2
    3db2:	00004597          	auipc	a1,0x4
    3db6:	30e58593          	addi	a1,a1,782 # 80c0 <malloc+0x15c6>
    3dba:	00003097          	auipc	ra,0x3
    3dbe:	902080e7          	jalr	-1790(ra) # 66bc <write>
  close(fd);
    3dc2:	8526                	mv	a0,s1
    3dc4:	00003097          	auipc	ra,0x3
    3dc8:	900080e7          	jalr	-1792(ra) # 66c4 <close>
  if(unlink("dd") >= 0){
    3dcc:	00004517          	auipc	a0,0x4
    3dd0:	1c450513          	addi	a0,a0,452 # 7f90 <malloc+0x1496>
    3dd4:	00003097          	auipc	ra,0x3
    3dd8:	918080e7          	jalr	-1768(ra) # 66ec <unlink>
    3ddc:	38055563          	bgez	a0,4166 <subdir+0x402>
  if(mkdir("/dd/dd") != 0){
    3de0:	00004517          	auipc	a0,0x4
    3de4:	22850513          	addi	a0,a0,552 # 8008 <malloc+0x150e>
    3de8:	00003097          	auipc	ra,0x3
    3dec:	91c080e7          	jalr	-1764(ra) # 6704 <mkdir>
    3df0:	38051d63          	bnez	a0,418a <subdir+0x426>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3df4:	20200593          	li	a1,514
    3df8:	00004517          	auipc	a0,0x4
    3dfc:	23850513          	addi	a0,a0,568 # 8030 <malloc+0x1536>
    3e00:	00003097          	auipc	ra,0x3
    3e04:	8dc080e7          	jalr	-1828(ra) # 66dc <open>
    3e08:	84aa                	mv	s1,a0
  if(fd < 0){
    3e0a:	3a054263          	bltz	a0,41ae <subdir+0x44a>
  write(fd, "FF", 2);
    3e0e:	4609                	li	a2,2
    3e10:	00004597          	auipc	a1,0x4
    3e14:	25058593          	addi	a1,a1,592 # 8060 <malloc+0x1566>
    3e18:	00003097          	auipc	ra,0x3
    3e1c:	8a4080e7          	jalr	-1884(ra) # 66bc <write>
  close(fd);
    3e20:	8526                	mv	a0,s1
    3e22:	00003097          	auipc	ra,0x3
    3e26:	8a2080e7          	jalr	-1886(ra) # 66c4 <close>
  fd = open("dd/dd/../ff", 0);
    3e2a:	4581                	li	a1,0
    3e2c:	00004517          	auipc	a0,0x4
    3e30:	23c50513          	addi	a0,a0,572 # 8068 <malloc+0x156e>
    3e34:	00003097          	auipc	ra,0x3
    3e38:	8a8080e7          	jalr	-1880(ra) # 66dc <open>
    3e3c:	84aa                	mv	s1,a0
  if(fd < 0){
    3e3e:	38054a63          	bltz	a0,41d2 <subdir+0x46e>
  cc = read(fd, buf, sizeof(buf));
    3e42:	660d                	lui	a2,0x3
    3e44:	0000a597          	auipc	a1,0xa
    3e48:	e3458593          	addi	a1,a1,-460 # dc78 <buf>
    3e4c:	00003097          	auipc	ra,0x3
    3e50:	868080e7          	jalr	-1944(ra) # 66b4 <read>
  if(cc != 2 || buf[0] != 'f'){
    3e54:	4789                	li	a5,2
    3e56:	3af51063          	bne	a0,a5,41f6 <subdir+0x492>
    3e5a:	0000a717          	auipc	a4,0xa
    3e5e:	e1e74703          	lbu	a4,-482(a4) # dc78 <buf>
    3e62:	06600793          	li	a5,102
    3e66:	38f71863          	bne	a4,a5,41f6 <subdir+0x492>
  close(fd);
    3e6a:	8526                	mv	a0,s1
    3e6c:	00003097          	auipc	ra,0x3
    3e70:	858080e7          	jalr	-1960(ra) # 66c4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3e74:	00004597          	auipc	a1,0x4
    3e78:	24458593          	addi	a1,a1,580 # 80b8 <malloc+0x15be>
    3e7c:	00004517          	auipc	a0,0x4
    3e80:	1b450513          	addi	a0,a0,436 # 8030 <malloc+0x1536>
    3e84:	00003097          	auipc	ra,0x3
    3e88:	878080e7          	jalr	-1928(ra) # 66fc <link>
    3e8c:	38051763          	bnez	a0,421a <subdir+0x4b6>
  if(unlink("dd/dd/ff") != 0){
    3e90:	00004517          	auipc	a0,0x4
    3e94:	1a050513          	addi	a0,a0,416 # 8030 <malloc+0x1536>
    3e98:	00003097          	auipc	ra,0x3
    3e9c:	854080e7          	jalr	-1964(ra) # 66ec <unlink>
    3ea0:	38051f63          	bnez	a0,423e <subdir+0x4da>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3ea4:	4581                	li	a1,0
    3ea6:	00004517          	auipc	a0,0x4
    3eaa:	18a50513          	addi	a0,a0,394 # 8030 <malloc+0x1536>
    3eae:	00003097          	auipc	ra,0x3
    3eb2:	82e080e7          	jalr	-2002(ra) # 66dc <open>
    3eb6:	3a055663          	bgez	a0,4262 <subdir+0x4fe>
  if(chdir("dd") != 0){
    3eba:	00004517          	auipc	a0,0x4
    3ebe:	0d650513          	addi	a0,a0,214 # 7f90 <malloc+0x1496>
    3ec2:	00003097          	auipc	ra,0x3
    3ec6:	84a080e7          	jalr	-1974(ra) # 670c <chdir>
    3eca:	3a051e63          	bnez	a0,4286 <subdir+0x522>
  if(chdir("dd/../../dd") != 0){
    3ece:	00004517          	auipc	a0,0x4
    3ed2:	28250513          	addi	a0,a0,642 # 8150 <malloc+0x1656>
    3ed6:	00003097          	auipc	ra,0x3
    3eda:	836080e7          	jalr	-1994(ra) # 670c <chdir>
    3ede:	3c051663          	bnez	a0,42aa <subdir+0x546>
  if(chdir("dd/../../../dd") != 0){
    3ee2:	00004517          	auipc	a0,0x4
    3ee6:	29e50513          	addi	a0,a0,670 # 8180 <malloc+0x1686>
    3eea:	00003097          	auipc	ra,0x3
    3eee:	822080e7          	jalr	-2014(ra) # 670c <chdir>
    3ef2:	3c051e63          	bnez	a0,42ce <subdir+0x56a>
  if(chdir("./..") != 0){
    3ef6:	00004517          	auipc	a0,0x4
    3efa:	2ba50513          	addi	a0,a0,698 # 81b0 <malloc+0x16b6>
    3efe:	00003097          	auipc	ra,0x3
    3f02:	80e080e7          	jalr	-2034(ra) # 670c <chdir>
    3f06:	3e051663          	bnez	a0,42f2 <subdir+0x58e>
  fd = open("dd/dd/ffff", 0);
    3f0a:	4581                	li	a1,0
    3f0c:	00004517          	auipc	a0,0x4
    3f10:	1ac50513          	addi	a0,a0,428 # 80b8 <malloc+0x15be>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	7c8080e7          	jalr	1992(ra) # 66dc <open>
    3f1c:	84aa                	mv	s1,a0
  if(fd < 0){
    3f1e:	3e054c63          	bltz	a0,4316 <subdir+0x5b2>
  if(read(fd, buf, sizeof(buf)) != 2){
    3f22:	660d                	lui	a2,0x3
    3f24:	0000a597          	auipc	a1,0xa
    3f28:	d5458593          	addi	a1,a1,-684 # dc78 <buf>
    3f2c:	00002097          	auipc	ra,0x2
    3f30:	788080e7          	jalr	1928(ra) # 66b4 <read>
    3f34:	4789                	li	a5,2
    3f36:	40f51263          	bne	a0,a5,433a <subdir+0x5d6>
  close(fd);
    3f3a:	8526                	mv	a0,s1
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	788080e7          	jalr	1928(ra) # 66c4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3f44:	4581                	li	a1,0
    3f46:	00004517          	auipc	a0,0x4
    3f4a:	0ea50513          	addi	a0,a0,234 # 8030 <malloc+0x1536>
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	78e080e7          	jalr	1934(ra) # 66dc <open>
    3f56:	40055463          	bgez	a0,435e <subdir+0x5fa>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f5a:	20200593          	li	a1,514
    3f5e:	00004517          	auipc	a0,0x4
    3f62:	2e250513          	addi	a0,a0,738 # 8240 <malloc+0x1746>
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	776080e7          	jalr	1910(ra) # 66dc <open>
    3f6e:	40055a63          	bgez	a0,4382 <subdir+0x61e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3f72:	20200593          	li	a1,514
    3f76:	00004517          	auipc	a0,0x4
    3f7a:	2fa50513          	addi	a0,a0,762 # 8270 <malloc+0x1776>
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	75e080e7          	jalr	1886(ra) # 66dc <open>
    3f86:	42055063          	bgez	a0,43a6 <subdir+0x642>
  if(open("dd", O_CREATE) >= 0){
    3f8a:	20000593          	li	a1,512
    3f8e:	00004517          	auipc	a0,0x4
    3f92:	00250513          	addi	a0,a0,2 # 7f90 <malloc+0x1496>
    3f96:	00002097          	auipc	ra,0x2
    3f9a:	746080e7          	jalr	1862(ra) # 66dc <open>
    3f9e:	42055663          	bgez	a0,43ca <subdir+0x666>
  if(open("dd", O_RDWR) >= 0){
    3fa2:	4589                	li	a1,2
    3fa4:	00004517          	auipc	a0,0x4
    3fa8:	fec50513          	addi	a0,a0,-20 # 7f90 <malloc+0x1496>
    3fac:	00002097          	auipc	ra,0x2
    3fb0:	730080e7          	jalr	1840(ra) # 66dc <open>
    3fb4:	42055d63          	bgez	a0,43ee <subdir+0x68a>
  if(open("dd", O_WRONLY) >= 0){
    3fb8:	4585                	li	a1,1
    3fba:	00004517          	auipc	a0,0x4
    3fbe:	fd650513          	addi	a0,a0,-42 # 7f90 <malloc+0x1496>
    3fc2:	00002097          	auipc	ra,0x2
    3fc6:	71a080e7          	jalr	1818(ra) # 66dc <open>
    3fca:	44055463          	bgez	a0,4412 <subdir+0x6ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3fce:	00004597          	auipc	a1,0x4
    3fd2:	33258593          	addi	a1,a1,818 # 8300 <malloc+0x1806>
    3fd6:	00004517          	auipc	a0,0x4
    3fda:	26a50513          	addi	a0,a0,618 # 8240 <malloc+0x1746>
    3fde:	00002097          	auipc	ra,0x2
    3fe2:	71e080e7          	jalr	1822(ra) # 66fc <link>
    3fe6:	44050863          	beqz	a0,4436 <subdir+0x6d2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3fea:	00004597          	auipc	a1,0x4
    3fee:	31658593          	addi	a1,a1,790 # 8300 <malloc+0x1806>
    3ff2:	00004517          	auipc	a0,0x4
    3ff6:	27e50513          	addi	a0,a0,638 # 8270 <malloc+0x1776>
    3ffa:	00002097          	auipc	ra,0x2
    3ffe:	702080e7          	jalr	1794(ra) # 66fc <link>
    4002:	44050c63          	beqz	a0,445a <subdir+0x6f6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    4006:	00004597          	auipc	a1,0x4
    400a:	0b258593          	addi	a1,a1,178 # 80b8 <malloc+0x15be>
    400e:	00004517          	auipc	a0,0x4
    4012:	fa250513          	addi	a0,a0,-94 # 7fb0 <malloc+0x14b6>
    4016:	00002097          	auipc	ra,0x2
    401a:	6e6080e7          	jalr	1766(ra) # 66fc <link>
    401e:	46050063          	beqz	a0,447e <subdir+0x71a>
  if(mkdir("dd/ff/ff") == 0){
    4022:	00004517          	auipc	a0,0x4
    4026:	21e50513          	addi	a0,a0,542 # 8240 <malloc+0x1746>
    402a:	00002097          	auipc	ra,0x2
    402e:	6da080e7          	jalr	1754(ra) # 6704 <mkdir>
    4032:	46050863          	beqz	a0,44a2 <subdir+0x73e>
  if(mkdir("dd/xx/ff") == 0){
    4036:	00004517          	auipc	a0,0x4
    403a:	23a50513          	addi	a0,a0,570 # 8270 <malloc+0x1776>
    403e:	00002097          	auipc	ra,0x2
    4042:	6c6080e7          	jalr	1734(ra) # 6704 <mkdir>
    4046:	48050063          	beqz	a0,44c6 <subdir+0x762>
  if(mkdir("dd/dd/ffff") == 0){
    404a:	00004517          	auipc	a0,0x4
    404e:	06e50513          	addi	a0,a0,110 # 80b8 <malloc+0x15be>
    4052:	00002097          	auipc	ra,0x2
    4056:	6b2080e7          	jalr	1714(ra) # 6704 <mkdir>
    405a:	48050863          	beqz	a0,44ea <subdir+0x786>
  if(unlink("dd/xx/ff") == 0){
    405e:	00004517          	auipc	a0,0x4
    4062:	21250513          	addi	a0,a0,530 # 8270 <malloc+0x1776>
    4066:	00002097          	auipc	ra,0x2
    406a:	686080e7          	jalr	1670(ra) # 66ec <unlink>
    406e:	4a050063          	beqz	a0,450e <subdir+0x7aa>
  if(unlink("dd/ff/ff") == 0){
    4072:	00004517          	auipc	a0,0x4
    4076:	1ce50513          	addi	a0,a0,462 # 8240 <malloc+0x1746>
    407a:	00002097          	auipc	ra,0x2
    407e:	672080e7          	jalr	1650(ra) # 66ec <unlink>
    4082:	4a050863          	beqz	a0,4532 <subdir+0x7ce>
  if(chdir("dd/ff") == 0){
    4086:	00004517          	auipc	a0,0x4
    408a:	f2a50513          	addi	a0,a0,-214 # 7fb0 <malloc+0x14b6>
    408e:	00002097          	auipc	ra,0x2
    4092:	67e080e7          	jalr	1662(ra) # 670c <chdir>
    4096:	4c050063          	beqz	a0,4556 <subdir+0x7f2>
  if(chdir("dd/xx") == 0){
    409a:	00004517          	auipc	a0,0x4
    409e:	3b650513          	addi	a0,a0,950 # 8450 <malloc+0x1956>
    40a2:	00002097          	auipc	ra,0x2
    40a6:	66a080e7          	jalr	1642(ra) # 670c <chdir>
    40aa:	4c050863          	beqz	a0,457a <subdir+0x816>
  if(unlink("dd/dd/ffff") != 0){
    40ae:	00004517          	auipc	a0,0x4
    40b2:	00a50513          	addi	a0,a0,10 # 80b8 <malloc+0x15be>
    40b6:	00002097          	auipc	ra,0x2
    40ba:	636080e7          	jalr	1590(ra) # 66ec <unlink>
    40be:	4e051063          	bnez	a0,459e <subdir+0x83a>
  if(unlink("dd/ff") != 0){
    40c2:	00004517          	auipc	a0,0x4
    40c6:	eee50513          	addi	a0,a0,-274 # 7fb0 <malloc+0x14b6>
    40ca:	00002097          	auipc	ra,0x2
    40ce:	622080e7          	jalr	1570(ra) # 66ec <unlink>
    40d2:	4e051863          	bnez	a0,45c2 <subdir+0x85e>
  if(unlink("dd") == 0){
    40d6:	00004517          	auipc	a0,0x4
    40da:	eba50513          	addi	a0,a0,-326 # 7f90 <malloc+0x1496>
    40de:	00002097          	auipc	ra,0x2
    40e2:	60e080e7          	jalr	1550(ra) # 66ec <unlink>
    40e6:	50050063          	beqz	a0,45e6 <subdir+0x882>
  if(unlink("dd/dd") < 0){
    40ea:	00004517          	auipc	a0,0x4
    40ee:	3d650513          	addi	a0,a0,982 # 84c0 <malloc+0x19c6>
    40f2:	00002097          	auipc	ra,0x2
    40f6:	5fa080e7          	jalr	1530(ra) # 66ec <unlink>
    40fa:	50054863          	bltz	a0,460a <subdir+0x8a6>
  if(unlink("dd") < 0){
    40fe:	00004517          	auipc	a0,0x4
    4102:	e9250513          	addi	a0,a0,-366 # 7f90 <malloc+0x1496>
    4106:	00002097          	auipc	ra,0x2
    410a:	5e6080e7          	jalr	1510(ra) # 66ec <unlink>
    410e:	52054063          	bltz	a0,462e <subdir+0x8ca>
}
    4112:	60e2                	ld	ra,24(sp)
    4114:	6442                	ld	s0,16(sp)
    4116:	64a2                	ld	s1,8(sp)
    4118:	6902                	ld	s2,0(sp)
    411a:	6105                	addi	sp,sp,32
    411c:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    411e:	85ca                	mv	a1,s2
    4120:	00004517          	auipc	a0,0x4
    4124:	e7850513          	addi	a0,a0,-392 # 7f98 <malloc+0x149e>
    4128:	00003097          	auipc	ra,0x3
    412c:	914080e7          	jalr	-1772(ra) # 6a3c <printf>
    exit(1,"");
    4130:	00004597          	auipc	a1,0x4
    4134:	10858593          	addi	a1,a1,264 # 8238 <malloc+0x173e>
    4138:	4505                	li	a0,1
    413a:	00002097          	auipc	ra,0x2
    413e:	562080e7          	jalr	1378(ra) # 669c <exit>
    printf("%s: create dd/ff failed\n", s);
    4142:	85ca                	mv	a1,s2
    4144:	00004517          	auipc	a0,0x4
    4148:	e7450513          	addi	a0,a0,-396 # 7fb8 <malloc+0x14be>
    414c:	00003097          	auipc	ra,0x3
    4150:	8f0080e7          	jalr	-1808(ra) # 6a3c <printf>
    exit(1,"");
    4154:	00004597          	auipc	a1,0x4
    4158:	0e458593          	addi	a1,a1,228 # 8238 <malloc+0x173e>
    415c:	4505                	li	a0,1
    415e:	00002097          	auipc	ra,0x2
    4162:	53e080e7          	jalr	1342(ra) # 669c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    4166:	85ca                	mv	a1,s2
    4168:	00004517          	auipc	a0,0x4
    416c:	e7050513          	addi	a0,a0,-400 # 7fd8 <malloc+0x14de>
    4170:	00003097          	auipc	ra,0x3
    4174:	8cc080e7          	jalr	-1844(ra) # 6a3c <printf>
    exit(1,"");
    4178:	00004597          	auipc	a1,0x4
    417c:	0c058593          	addi	a1,a1,192 # 8238 <malloc+0x173e>
    4180:	4505                	li	a0,1
    4182:	00002097          	auipc	ra,0x2
    4186:	51a080e7          	jalr	1306(ra) # 669c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    418a:	85ca                	mv	a1,s2
    418c:	00004517          	auipc	a0,0x4
    4190:	e8450513          	addi	a0,a0,-380 # 8010 <malloc+0x1516>
    4194:	00003097          	auipc	ra,0x3
    4198:	8a8080e7          	jalr	-1880(ra) # 6a3c <printf>
    exit(1,"");
    419c:	00004597          	auipc	a1,0x4
    41a0:	09c58593          	addi	a1,a1,156 # 8238 <malloc+0x173e>
    41a4:	4505                	li	a0,1
    41a6:	00002097          	auipc	ra,0x2
    41aa:	4f6080e7          	jalr	1270(ra) # 669c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    41ae:	85ca                	mv	a1,s2
    41b0:	00004517          	auipc	a0,0x4
    41b4:	e9050513          	addi	a0,a0,-368 # 8040 <malloc+0x1546>
    41b8:	00003097          	auipc	ra,0x3
    41bc:	884080e7          	jalr	-1916(ra) # 6a3c <printf>
    exit(1,"");
    41c0:	00004597          	auipc	a1,0x4
    41c4:	07858593          	addi	a1,a1,120 # 8238 <malloc+0x173e>
    41c8:	4505                	li	a0,1
    41ca:	00002097          	auipc	ra,0x2
    41ce:	4d2080e7          	jalr	1234(ra) # 669c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    41d2:	85ca                	mv	a1,s2
    41d4:	00004517          	auipc	a0,0x4
    41d8:	ea450513          	addi	a0,a0,-348 # 8078 <malloc+0x157e>
    41dc:	00003097          	auipc	ra,0x3
    41e0:	860080e7          	jalr	-1952(ra) # 6a3c <printf>
    exit(1,"");
    41e4:	00004597          	auipc	a1,0x4
    41e8:	05458593          	addi	a1,a1,84 # 8238 <malloc+0x173e>
    41ec:	4505                	li	a0,1
    41ee:	00002097          	auipc	ra,0x2
    41f2:	4ae080e7          	jalr	1198(ra) # 669c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    41f6:	85ca                	mv	a1,s2
    41f8:	00004517          	auipc	a0,0x4
    41fc:	ea050513          	addi	a0,a0,-352 # 8098 <malloc+0x159e>
    4200:	00003097          	auipc	ra,0x3
    4204:	83c080e7          	jalr	-1988(ra) # 6a3c <printf>
    exit(1,"");
    4208:	00004597          	auipc	a1,0x4
    420c:	03058593          	addi	a1,a1,48 # 8238 <malloc+0x173e>
    4210:	4505                	li	a0,1
    4212:	00002097          	auipc	ra,0x2
    4216:	48a080e7          	jalr	1162(ra) # 669c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    421a:	85ca                	mv	a1,s2
    421c:	00004517          	auipc	a0,0x4
    4220:	eac50513          	addi	a0,a0,-340 # 80c8 <malloc+0x15ce>
    4224:	00003097          	auipc	ra,0x3
    4228:	818080e7          	jalr	-2024(ra) # 6a3c <printf>
    exit(1,"");
    422c:	00004597          	auipc	a1,0x4
    4230:	00c58593          	addi	a1,a1,12 # 8238 <malloc+0x173e>
    4234:	4505                	li	a0,1
    4236:	00002097          	auipc	ra,0x2
    423a:	466080e7          	jalr	1126(ra) # 669c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    423e:	85ca                	mv	a1,s2
    4240:	00004517          	auipc	a0,0x4
    4244:	eb050513          	addi	a0,a0,-336 # 80f0 <malloc+0x15f6>
    4248:	00002097          	auipc	ra,0x2
    424c:	7f4080e7          	jalr	2036(ra) # 6a3c <printf>
    exit(1,"");
    4250:	00004597          	auipc	a1,0x4
    4254:	fe858593          	addi	a1,a1,-24 # 8238 <malloc+0x173e>
    4258:	4505                	li	a0,1
    425a:	00002097          	auipc	ra,0x2
    425e:	442080e7          	jalr	1090(ra) # 669c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    4262:	85ca                	mv	a1,s2
    4264:	00004517          	auipc	a0,0x4
    4268:	eac50513          	addi	a0,a0,-340 # 8110 <malloc+0x1616>
    426c:	00002097          	auipc	ra,0x2
    4270:	7d0080e7          	jalr	2000(ra) # 6a3c <printf>
    exit(1,"");
    4274:	00004597          	auipc	a1,0x4
    4278:	fc458593          	addi	a1,a1,-60 # 8238 <malloc+0x173e>
    427c:	4505                	li	a0,1
    427e:	00002097          	auipc	ra,0x2
    4282:	41e080e7          	jalr	1054(ra) # 669c <exit>
    printf("%s: chdir dd failed\n", s);
    4286:	85ca                	mv	a1,s2
    4288:	00004517          	auipc	a0,0x4
    428c:	eb050513          	addi	a0,a0,-336 # 8138 <malloc+0x163e>
    4290:	00002097          	auipc	ra,0x2
    4294:	7ac080e7          	jalr	1964(ra) # 6a3c <printf>
    exit(1,"");
    4298:	00004597          	auipc	a1,0x4
    429c:	fa058593          	addi	a1,a1,-96 # 8238 <malloc+0x173e>
    42a0:	4505                	li	a0,1
    42a2:	00002097          	auipc	ra,0x2
    42a6:	3fa080e7          	jalr	1018(ra) # 669c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    42aa:	85ca                	mv	a1,s2
    42ac:	00004517          	auipc	a0,0x4
    42b0:	eb450513          	addi	a0,a0,-332 # 8160 <malloc+0x1666>
    42b4:	00002097          	auipc	ra,0x2
    42b8:	788080e7          	jalr	1928(ra) # 6a3c <printf>
    exit(1,"");
    42bc:	00004597          	auipc	a1,0x4
    42c0:	f7c58593          	addi	a1,a1,-132 # 8238 <malloc+0x173e>
    42c4:	4505                	li	a0,1
    42c6:	00002097          	auipc	ra,0x2
    42ca:	3d6080e7          	jalr	982(ra) # 669c <exit>
    printf("chdir dd/../../dd failed\n", s);
    42ce:	85ca                	mv	a1,s2
    42d0:	00004517          	auipc	a0,0x4
    42d4:	ec050513          	addi	a0,a0,-320 # 8190 <malloc+0x1696>
    42d8:	00002097          	auipc	ra,0x2
    42dc:	764080e7          	jalr	1892(ra) # 6a3c <printf>
    exit(1,"");
    42e0:	00004597          	auipc	a1,0x4
    42e4:	f5858593          	addi	a1,a1,-168 # 8238 <malloc+0x173e>
    42e8:	4505                	li	a0,1
    42ea:	00002097          	auipc	ra,0x2
    42ee:	3b2080e7          	jalr	946(ra) # 669c <exit>
    printf("%s: chdir ./.. failed\n", s);
    42f2:	85ca                	mv	a1,s2
    42f4:	00004517          	auipc	a0,0x4
    42f8:	ec450513          	addi	a0,a0,-316 # 81b8 <malloc+0x16be>
    42fc:	00002097          	auipc	ra,0x2
    4300:	740080e7          	jalr	1856(ra) # 6a3c <printf>
    exit(1,"");
    4304:	00004597          	auipc	a1,0x4
    4308:	f3458593          	addi	a1,a1,-204 # 8238 <malloc+0x173e>
    430c:	4505                	li	a0,1
    430e:	00002097          	auipc	ra,0x2
    4312:	38e080e7          	jalr	910(ra) # 669c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    4316:	85ca                	mv	a1,s2
    4318:	00004517          	auipc	a0,0x4
    431c:	eb850513          	addi	a0,a0,-328 # 81d0 <malloc+0x16d6>
    4320:	00002097          	auipc	ra,0x2
    4324:	71c080e7          	jalr	1820(ra) # 6a3c <printf>
    exit(1,"");
    4328:	00004597          	auipc	a1,0x4
    432c:	f1058593          	addi	a1,a1,-240 # 8238 <malloc+0x173e>
    4330:	4505                	li	a0,1
    4332:	00002097          	auipc	ra,0x2
    4336:	36a080e7          	jalr	874(ra) # 669c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    433a:	85ca                	mv	a1,s2
    433c:	00004517          	auipc	a0,0x4
    4340:	eb450513          	addi	a0,a0,-332 # 81f0 <malloc+0x16f6>
    4344:	00002097          	auipc	ra,0x2
    4348:	6f8080e7          	jalr	1784(ra) # 6a3c <printf>
    exit(1,"");
    434c:	00004597          	auipc	a1,0x4
    4350:	eec58593          	addi	a1,a1,-276 # 8238 <malloc+0x173e>
    4354:	4505                	li	a0,1
    4356:	00002097          	auipc	ra,0x2
    435a:	346080e7          	jalr	838(ra) # 669c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    435e:	85ca                	mv	a1,s2
    4360:	00004517          	auipc	a0,0x4
    4364:	eb050513          	addi	a0,a0,-336 # 8210 <malloc+0x1716>
    4368:	00002097          	auipc	ra,0x2
    436c:	6d4080e7          	jalr	1748(ra) # 6a3c <printf>
    exit(1,"");
    4370:	00004597          	auipc	a1,0x4
    4374:	ec858593          	addi	a1,a1,-312 # 8238 <malloc+0x173e>
    4378:	4505                	li	a0,1
    437a:	00002097          	auipc	ra,0x2
    437e:	322080e7          	jalr	802(ra) # 669c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    4382:	85ca                	mv	a1,s2
    4384:	00004517          	auipc	a0,0x4
    4388:	ecc50513          	addi	a0,a0,-308 # 8250 <malloc+0x1756>
    438c:	00002097          	auipc	ra,0x2
    4390:	6b0080e7          	jalr	1712(ra) # 6a3c <printf>
    exit(1,"");
    4394:	00004597          	auipc	a1,0x4
    4398:	ea458593          	addi	a1,a1,-348 # 8238 <malloc+0x173e>
    439c:	4505                	li	a0,1
    439e:	00002097          	auipc	ra,0x2
    43a2:	2fe080e7          	jalr	766(ra) # 669c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    43a6:	85ca                	mv	a1,s2
    43a8:	00004517          	auipc	a0,0x4
    43ac:	ed850513          	addi	a0,a0,-296 # 8280 <malloc+0x1786>
    43b0:	00002097          	auipc	ra,0x2
    43b4:	68c080e7          	jalr	1676(ra) # 6a3c <printf>
    exit(1,"");
    43b8:	00004597          	auipc	a1,0x4
    43bc:	e8058593          	addi	a1,a1,-384 # 8238 <malloc+0x173e>
    43c0:	4505                	li	a0,1
    43c2:	00002097          	auipc	ra,0x2
    43c6:	2da080e7          	jalr	730(ra) # 669c <exit>
    printf("%s: create dd succeeded!\n", s);
    43ca:	85ca                	mv	a1,s2
    43cc:	00004517          	auipc	a0,0x4
    43d0:	ed450513          	addi	a0,a0,-300 # 82a0 <malloc+0x17a6>
    43d4:	00002097          	auipc	ra,0x2
    43d8:	668080e7          	jalr	1640(ra) # 6a3c <printf>
    exit(1,"");
    43dc:	00004597          	auipc	a1,0x4
    43e0:	e5c58593          	addi	a1,a1,-420 # 8238 <malloc+0x173e>
    43e4:	4505                	li	a0,1
    43e6:	00002097          	auipc	ra,0x2
    43ea:	2b6080e7          	jalr	694(ra) # 669c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    43ee:	85ca                	mv	a1,s2
    43f0:	00004517          	auipc	a0,0x4
    43f4:	ed050513          	addi	a0,a0,-304 # 82c0 <malloc+0x17c6>
    43f8:	00002097          	auipc	ra,0x2
    43fc:	644080e7          	jalr	1604(ra) # 6a3c <printf>
    exit(1,"");
    4400:	00004597          	auipc	a1,0x4
    4404:	e3858593          	addi	a1,a1,-456 # 8238 <malloc+0x173e>
    4408:	4505                	li	a0,1
    440a:	00002097          	auipc	ra,0x2
    440e:	292080e7          	jalr	658(ra) # 669c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    4412:	85ca                	mv	a1,s2
    4414:	00004517          	auipc	a0,0x4
    4418:	ecc50513          	addi	a0,a0,-308 # 82e0 <malloc+0x17e6>
    441c:	00002097          	auipc	ra,0x2
    4420:	620080e7          	jalr	1568(ra) # 6a3c <printf>
    exit(1,"");
    4424:	00004597          	auipc	a1,0x4
    4428:	e1458593          	addi	a1,a1,-492 # 8238 <malloc+0x173e>
    442c:	4505                	li	a0,1
    442e:	00002097          	auipc	ra,0x2
    4432:	26e080e7          	jalr	622(ra) # 669c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    4436:	85ca                	mv	a1,s2
    4438:	00004517          	auipc	a0,0x4
    443c:	ed850513          	addi	a0,a0,-296 # 8310 <malloc+0x1816>
    4440:	00002097          	auipc	ra,0x2
    4444:	5fc080e7          	jalr	1532(ra) # 6a3c <printf>
    exit(1,"");
    4448:	00004597          	auipc	a1,0x4
    444c:	df058593          	addi	a1,a1,-528 # 8238 <malloc+0x173e>
    4450:	4505                	li	a0,1
    4452:	00002097          	auipc	ra,0x2
    4456:	24a080e7          	jalr	586(ra) # 669c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    445a:	85ca                	mv	a1,s2
    445c:	00004517          	auipc	a0,0x4
    4460:	edc50513          	addi	a0,a0,-292 # 8338 <malloc+0x183e>
    4464:	00002097          	auipc	ra,0x2
    4468:	5d8080e7          	jalr	1496(ra) # 6a3c <printf>
    exit(1,"");
    446c:	00004597          	auipc	a1,0x4
    4470:	dcc58593          	addi	a1,a1,-564 # 8238 <malloc+0x173e>
    4474:	4505                	li	a0,1
    4476:	00002097          	auipc	ra,0x2
    447a:	226080e7          	jalr	550(ra) # 669c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    447e:	85ca                	mv	a1,s2
    4480:	00004517          	auipc	a0,0x4
    4484:	ee050513          	addi	a0,a0,-288 # 8360 <malloc+0x1866>
    4488:	00002097          	auipc	ra,0x2
    448c:	5b4080e7          	jalr	1460(ra) # 6a3c <printf>
    exit(1,"");
    4490:	00004597          	auipc	a1,0x4
    4494:	da858593          	addi	a1,a1,-600 # 8238 <malloc+0x173e>
    4498:	4505                	li	a0,1
    449a:	00002097          	auipc	ra,0x2
    449e:	202080e7          	jalr	514(ra) # 669c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    44a2:	85ca                	mv	a1,s2
    44a4:	00004517          	auipc	a0,0x4
    44a8:	ee450513          	addi	a0,a0,-284 # 8388 <malloc+0x188e>
    44ac:	00002097          	auipc	ra,0x2
    44b0:	590080e7          	jalr	1424(ra) # 6a3c <printf>
    exit(1,"");
    44b4:	00004597          	auipc	a1,0x4
    44b8:	d8458593          	addi	a1,a1,-636 # 8238 <malloc+0x173e>
    44bc:	4505                	li	a0,1
    44be:	00002097          	auipc	ra,0x2
    44c2:	1de080e7          	jalr	478(ra) # 669c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    44c6:	85ca                	mv	a1,s2
    44c8:	00004517          	auipc	a0,0x4
    44cc:	ee050513          	addi	a0,a0,-288 # 83a8 <malloc+0x18ae>
    44d0:	00002097          	auipc	ra,0x2
    44d4:	56c080e7          	jalr	1388(ra) # 6a3c <printf>
    exit(1,"");
    44d8:	00004597          	auipc	a1,0x4
    44dc:	d6058593          	addi	a1,a1,-672 # 8238 <malloc+0x173e>
    44e0:	4505                	li	a0,1
    44e2:	00002097          	auipc	ra,0x2
    44e6:	1ba080e7          	jalr	442(ra) # 669c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    44ea:	85ca                	mv	a1,s2
    44ec:	00004517          	auipc	a0,0x4
    44f0:	edc50513          	addi	a0,a0,-292 # 83c8 <malloc+0x18ce>
    44f4:	00002097          	auipc	ra,0x2
    44f8:	548080e7          	jalr	1352(ra) # 6a3c <printf>
    exit(1,"");
    44fc:	00004597          	auipc	a1,0x4
    4500:	d3c58593          	addi	a1,a1,-708 # 8238 <malloc+0x173e>
    4504:	4505                	li	a0,1
    4506:	00002097          	auipc	ra,0x2
    450a:	196080e7          	jalr	406(ra) # 669c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    450e:	85ca                	mv	a1,s2
    4510:	00004517          	auipc	a0,0x4
    4514:	ee050513          	addi	a0,a0,-288 # 83f0 <malloc+0x18f6>
    4518:	00002097          	auipc	ra,0x2
    451c:	524080e7          	jalr	1316(ra) # 6a3c <printf>
    exit(1,"");
    4520:	00004597          	auipc	a1,0x4
    4524:	d1858593          	addi	a1,a1,-744 # 8238 <malloc+0x173e>
    4528:	4505                	li	a0,1
    452a:	00002097          	auipc	ra,0x2
    452e:	172080e7          	jalr	370(ra) # 669c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    4532:	85ca                	mv	a1,s2
    4534:	00004517          	auipc	a0,0x4
    4538:	edc50513          	addi	a0,a0,-292 # 8410 <malloc+0x1916>
    453c:	00002097          	auipc	ra,0x2
    4540:	500080e7          	jalr	1280(ra) # 6a3c <printf>
    exit(1,"");
    4544:	00004597          	auipc	a1,0x4
    4548:	cf458593          	addi	a1,a1,-780 # 8238 <malloc+0x173e>
    454c:	4505                	li	a0,1
    454e:	00002097          	auipc	ra,0x2
    4552:	14e080e7          	jalr	334(ra) # 669c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    4556:	85ca                	mv	a1,s2
    4558:	00004517          	auipc	a0,0x4
    455c:	ed850513          	addi	a0,a0,-296 # 8430 <malloc+0x1936>
    4560:	00002097          	auipc	ra,0x2
    4564:	4dc080e7          	jalr	1244(ra) # 6a3c <printf>
    exit(1,"");
    4568:	00004597          	auipc	a1,0x4
    456c:	cd058593          	addi	a1,a1,-816 # 8238 <malloc+0x173e>
    4570:	4505                	li	a0,1
    4572:	00002097          	auipc	ra,0x2
    4576:	12a080e7          	jalr	298(ra) # 669c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    457a:	85ca                	mv	a1,s2
    457c:	00004517          	auipc	a0,0x4
    4580:	edc50513          	addi	a0,a0,-292 # 8458 <malloc+0x195e>
    4584:	00002097          	auipc	ra,0x2
    4588:	4b8080e7          	jalr	1208(ra) # 6a3c <printf>
    exit(1,"");
    458c:	00004597          	auipc	a1,0x4
    4590:	cac58593          	addi	a1,a1,-852 # 8238 <malloc+0x173e>
    4594:	4505                	li	a0,1
    4596:	00002097          	auipc	ra,0x2
    459a:	106080e7          	jalr	262(ra) # 669c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    459e:	85ca                	mv	a1,s2
    45a0:	00004517          	auipc	a0,0x4
    45a4:	b5050513          	addi	a0,a0,-1200 # 80f0 <malloc+0x15f6>
    45a8:	00002097          	auipc	ra,0x2
    45ac:	494080e7          	jalr	1172(ra) # 6a3c <printf>
    exit(1,"");
    45b0:	00004597          	auipc	a1,0x4
    45b4:	c8858593          	addi	a1,a1,-888 # 8238 <malloc+0x173e>
    45b8:	4505                	li	a0,1
    45ba:	00002097          	auipc	ra,0x2
    45be:	0e2080e7          	jalr	226(ra) # 669c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    45c2:	85ca                	mv	a1,s2
    45c4:	00004517          	auipc	a0,0x4
    45c8:	eb450513          	addi	a0,a0,-332 # 8478 <malloc+0x197e>
    45cc:	00002097          	auipc	ra,0x2
    45d0:	470080e7          	jalr	1136(ra) # 6a3c <printf>
    exit(1,"");
    45d4:	00004597          	auipc	a1,0x4
    45d8:	c6458593          	addi	a1,a1,-924 # 8238 <malloc+0x173e>
    45dc:	4505                	li	a0,1
    45de:	00002097          	auipc	ra,0x2
    45e2:	0be080e7          	jalr	190(ra) # 669c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    45e6:	85ca                	mv	a1,s2
    45e8:	00004517          	auipc	a0,0x4
    45ec:	eb050513          	addi	a0,a0,-336 # 8498 <malloc+0x199e>
    45f0:	00002097          	auipc	ra,0x2
    45f4:	44c080e7          	jalr	1100(ra) # 6a3c <printf>
    exit(1,"");
    45f8:	00004597          	auipc	a1,0x4
    45fc:	c4058593          	addi	a1,a1,-960 # 8238 <malloc+0x173e>
    4600:	4505                	li	a0,1
    4602:	00002097          	auipc	ra,0x2
    4606:	09a080e7          	jalr	154(ra) # 669c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    460a:	85ca                	mv	a1,s2
    460c:	00004517          	auipc	a0,0x4
    4610:	ebc50513          	addi	a0,a0,-324 # 84c8 <malloc+0x19ce>
    4614:	00002097          	auipc	ra,0x2
    4618:	428080e7          	jalr	1064(ra) # 6a3c <printf>
    exit(1,"");
    461c:	00004597          	auipc	a1,0x4
    4620:	c1c58593          	addi	a1,a1,-996 # 8238 <malloc+0x173e>
    4624:	4505                	li	a0,1
    4626:	00002097          	auipc	ra,0x2
    462a:	076080e7          	jalr	118(ra) # 669c <exit>
    printf("%s: unlink dd failed\n", s);
    462e:	85ca                	mv	a1,s2
    4630:	00004517          	auipc	a0,0x4
    4634:	eb850513          	addi	a0,a0,-328 # 84e8 <malloc+0x19ee>
    4638:	00002097          	auipc	ra,0x2
    463c:	404080e7          	jalr	1028(ra) # 6a3c <printf>
    exit(1,"");
    4640:	00004597          	auipc	a1,0x4
    4644:	bf858593          	addi	a1,a1,-1032 # 8238 <malloc+0x173e>
    4648:	4505                	li	a0,1
    464a:	00002097          	auipc	ra,0x2
    464e:	052080e7          	jalr	82(ra) # 669c <exit>

0000000000004652 <rmdot>:
{
    4652:	1101                	addi	sp,sp,-32
    4654:	ec06                	sd	ra,24(sp)
    4656:	e822                	sd	s0,16(sp)
    4658:	e426                	sd	s1,8(sp)
    465a:	1000                	addi	s0,sp,32
    465c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    465e:	00004517          	auipc	a0,0x4
    4662:	ea250513          	addi	a0,a0,-350 # 8500 <malloc+0x1a06>
    4666:	00002097          	auipc	ra,0x2
    466a:	09e080e7          	jalr	158(ra) # 6704 <mkdir>
    466e:	e551                	bnez	a0,46fa <rmdot+0xa8>
  if(chdir("dots") != 0){
    4670:	00004517          	auipc	a0,0x4
    4674:	e9050513          	addi	a0,a0,-368 # 8500 <malloc+0x1a06>
    4678:	00002097          	auipc	ra,0x2
    467c:	094080e7          	jalr	148(ra) # 670c <chdir>
    4680:	ed59                	bnez	a0,471e <rmdot+0xcc>
  if(unlink(".") == 0){
    4682:	00003517          	auipc	a0,0x3
    4686:	c9e50513          	addi	a0,a0,-866 # 7320 <malloc+0x826>
    468a:	00002097          	auipc	ra,0x2
    468e:	062080e7          	jalr	98(ra) # 66ec <unlink>
    4692:	c945                	beqz	a0,4742 <rmdot+0xf0>
  if(unlink("..") == 0){
    4694:	00004517          	auipc	a0,0x4
    4698:	8c450513          	addi	a0,a0,-1852 # 7f58 <malloc+0x145e>
    469c:	00002097          	auipc	ra,0x2
    46a0:	050080e7          	jalr	80(ra) # 66ec <unlink>
    46a4:	c169                	beqz	a0,4766 <rmdot+0x114>
  if(chdir("/") != 0){
    46a6:	00004517          	auipc	a0,0x4
    46aa:	85a50513          	addi	a0,a0,-1958 # 7f00 <malloc+0x1406>
    46ae:	00002097          	auipc	ra,0x2
    46b2:	05e080e7          	jalr	94(ra) # 670c <chdir>
    46b6:	e971                	bnez	a0,478a <rmdot+0x138>
  if(unlink("dots/.") == 0){
    46b8:	00004517          	auipc	a0,0x4
    46bc:	eb050513          	addi	a0,a0,-336 # 8568 <malloc+0x1a6e>
    46c0:	00002097          	auipc	ra,0x2
    46c4:	02c080e7          	jalr	44(ra) # 66ec <unlink>
    46c8:	c17d                	beqz	a0,47ae <rmdot+0x15c>
  if(unlink("dots/..") == 0){
    46ca:	00004517          	auipc	a0,0x4
    46ce:	ec650513          	addi	a0,a0,-314 # 8590 <malloc+0x1a96>
    46d2:	00002097          	auipc	ra,0x2
    46d6:	01a080e7          	jalr	26(ra) # 66ec <unlink>
    46da:	cd65                	beqz	a0,47d2 <rmdot+0x180>
  if(unlink("dots") != 0){
    46dc:	00004517          	auipc	a0,0x4
    46e0:	e2450513          	addi	a0,a0,-476 # 8500 <malloc+0x1a06>
    46e4:	00002097          	auipc	ra,0x2
    46e8:	008080e7          	jalr	8(ra) # 66ec <unlink>
    46ec:	10051563          	bnez	a0,47f6 <rmdot+0x1a4>
}
    46f0:	60e2                	ld	ra,24(sp)
    46f2:	6442                	ld	s0,16(sp)
    46f4:	64a2                	ld	s1,8(sp)
    46f6:	6105                	addi	sp,sp,32
    46f8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    46fa:	85a6                	mv	a1,s1
    46fc:	00004517          	auipc	a0,0x4
    4700:	e0c50513          	addi	a0,a0,-500 # 8508 <malloc+0x1a0e>
    4704:	00002097          	auipc	ra,0x2
    4708:	338080e7          	jalr	824(ra) # 6a3c <printf>
    exit(1,"");
    470c:	00004597          	auipc	a1,0x4
    4710:	b2c58593          	addi	a1,a1,-1236 # 8238 <malloc+0x173e>
    4714:	4505                	li	a0,1
    4716:	00002097          	auipc	ra,0x2
    471a:	f86080e7          	jalr	-122(ra) # 669c <exit>
    printf("%s: chdir dots failed\n", s);
    471e:	85a6                	mv	a1,s1
    4720:	00004517          	auipc	a0,0x4
    4724:	e0050513          	addi	a0,a0,-512 # 8520 <malloc+0x1a26>
    4728:	00002097          	auipc	ra,0x2
    472c:	314080e7          	jalr	788(ra) # 6a3c <printf>
    exit(1,"");
    4730:	00004597          	auipc	a1,0x4
    4734:	b0858593          	addi	a1,a1,-1272 # 8238 <malloc+0x173e>
    4738:	4505                	li	a0,1
    473a:	00002097          	auipc	ra,0x2
    473e:	f62080e7          	jalr	-158(ra) # 669c <exit>
    printf("%s: rm . worked!\n", s);
    4742:	85a6                	mv	a1,s1
    4744:	00004517          	auipc	a0,0x4
    4748:	df450513          	addi	a0,a0,-524 # 8538 <malloc+0x1a3e>
    474c:	00002097          	auipc	ra,0x2
    4750:	2f0080e7          	jalr	752(ra) # 6a3c <printf>
    exit(1,"");
    4754:	00004597          	auipc	a1,0x4
    4758:	ae458593          	addi	a1,a1,-1308 # 8238 <malloc+0x173e>
    475c:	4505                	li	a0,1
    475e:	00002097          	auipc	ra,0x2
    4762:	f3e080e7          	jalr	-194(ra) # 669c <exit>
    printf("%s: rm .. worked!\n", s);
    4766:	85a6                	mv	a1,s1
    4768:	00004517          	auipc	a0,0x4
    476c:	de850513          	addi	a0,a0,-536 # 8550 <malloc+0x1a56>
    4770:	00002097          	auipc	ra,0x2
    4774:	2cc080e7          	jalr	716(ra) # 6a3c <printf>
    exit(1,"");
    4778:	00004597          	auipc	a1,0x4
    477c:	ac058593          	addi	a1,a1,-1344 # 8238 <malloc+0x173e>
    4780:	4505                	li	a0,1
    4782:	00002097          	auipc	ra,0x2
    4786:	f1a080e7          	jalr	-230(ra) # 669c <exit>
    printf("%s: chdir / failed\n", s);
    478a:	85a6                	mv	a1,s1
    478c:	00003517          	auipc	a0,0x3
    4790:	77c50513          	addi	a0,a0,1916 # 7f08 <malloc+0x140e>
    4794:	00002097          	auipc	ra,0x2
    4798:	2a8080e7          	jalr	680(ra) # 6a3c <printf>
    exit(1,"");
    479c:	00004597          	auipc	a1,0x4
    47a0:	a9c58593          	addi	a1,a1,-1380 # 8238 <malloc+0x173e>
    47a4:	4505                	li	a0,1
    47a6:	00002097          	auipc	ra,0x2
    47aa:	ef6080e7          	jalr	-266(ra) # 669c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    47ae:	85a6                	mv	a1,s1
    47b0:	00004517          	auipc	a0,0x4
    47b4:	dc050513          	addi	a0,a0,-576 # 8570 <malloc+0x1a76>
    47b8:	00002097          	auipc	ra,0x2
    47bc:	284080e7          	jalr	644(ra) # 6a3c <printf>
    exit(1,"");
    47c0:	00004597          	auipc	a1,0x4
    47c4:	a7858593          	addi	a1,a1,-1416 # 8238 <malloc+0x173e>
    47c8:	4505                	li	a0,1
    47ca:	00002097          	auipc	ra,0x2
    47ce:	ed2080e7          	jalr	-302(ra) # 669c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    47d2:	85a6                	mv	a1,s1
    47d4:	00004517          	auipc	a0,0x4
    47d8:	dc450513          	addi	a0,a0,-572 # 8598 <malloc+0x1a9e>
    47dc:	00002097          	auipc	ra,0x2
    47e0:	260080e7          	jalr	608(ra) # 6a3c <printf>
    exit(1,"");
    47e4:	00004597          	auipc	a1,0x4
    47e8:	a5458593          	addi	a1,a1,-1452 # 8238 <malloc+0x173e>
    47ec:	4505                	li	a0,1
    47ee:	00002097          	auipc	ra,0x2
    47f2:	eae080e7          	jalr	-338(ra) # 669c <exit>
    printf("%s: unlink dots failed!\n", s);
    47f6:	85a6                	mv	a1,s1
    47f8:	00004517          	auipc	a0,0x4
    47fc:	dc050513          	addi	a0,a0,-576 # 85b8 <malloc+0x1abe>
    4800:	00002097          	auipc	ra,0x2
    4804:	23c080e7          	jalr	572(ra) # 6a3c <printf>
    exit(1,"");
    4808:	00004597          	auipc	a1,0x4
    480c:	a3058593          	addi	a1,a1,-1488 # 8238 <malloc+0x173e>
    4810:	4505                	li	a0,1
    4812:	00002097          	auipc	ra,0x2
    4816:	e8a080e7          	jalr	-374(ra) # 669c <exit>

000000000000481a <dirfile>:
{
    481a:	1101                	addi	sp,sp,-32
    481c:	ec06                	sd	ra,24(sp)
    481e:	e822                	sd	s0,16(sp)
    4820:	e426                	sd	s1,8(sp)
    4822:	e04a                	sd	s2,0(sp)
    4824:	1000                	addi	s0,sp,32
    4826:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4828:	20000593          	li	a1,512
    482c:	00004517          	auipc	a0,0x4
    4830:	dac50513          	addi	a0,a0,-596 # 85d8 <malloc+0x1ade>
    4834:	00002097          	auipc	ra,0x2
    4838:	ea8080e7          	jalr	-344(ra) # 66dc <open>
  if(fd < 0){
    483c:	0e054e63          	bltz	a0,4938 <dirfile+0x11e>
  close(fd);
    4840:	00002097          	auipc	ra,0x2
    4844:	e84080e7          	jalr	-380(ra) # 66c4 <close>
  if(chdir("dirfile") == 0){
    4848:	00004517          	auipc	a0,0x4
    484c:	d9050513          	addi	a0,a0,-624 # 85d8 <malloc+0x1ade>
    4850:	00002097          	auipc	ra,0x2
    4854:	ebc080e7          	jalr	-324(ra) # 670c <chdir>
    4858:	10050263          	beqz	a0,495c <dirfile+0x142>
  fd = open("dirfile/xx", 0);
    485c:	4581                	li	a1,0
    485e:	00004517          	auipc	a0,0x4
    4862:	dc250513          	addi	a0,a0,-574 # 8620 <malloc+0x1b26>
    4866:	00002097          	auipc	ra,0x2
    486a:	e76080e7          	jalr	-394(ra) # 66dc <open>
  if(fd >= 0){
    486e:	10055963          	bgez	a0,4980 <dirfile+0x166>
  fd = open("dirfile/xx", O_CREATE);
    4872:	20000593          	li	a1,512
    4876:	00004517          	auipc	a0,0x4
    487a:	daa50513          	addi	a0,a0,-598 # 8620 <malloc+0x1b26>
    487e:	00002097          	auipc	ra,0x2
    4882:	e5e080e7          	jalr	-418(ra) # 66dc <open>
  if(fd >= 0){
    4886:	10055f63          	bgez	a0,49a4 <dirfile+0x18a>
  if(mkdir("dirfile/xx") == 0){
    488a:	00004517          	auipc	a0,0x4
    488e:	d9650513          	addi	a0,a0,-618 # 8620 <malloc+0x1b26>
    4892:	00002097          	auipc	ra,0x2
    4896:	e72080e7          	jalr	-398(ra) # 6704 <mkdir>
    489a:	12050763          	beqz	a0,49c8 <dirfile+0x1ae>
  if(unlink("dirfile/xx") == 0){
    489e:	00004517          	auipc	a0,0x4
    48a2:	d8250513          	addi	a0,a0,-638 # 8620 <malloc+0x1b26>
    48a6:	00002097          	auipc	ra,0x2
    48aa:	e46080e7          	jalr	-442(ra) # 66ec <unlink>
    48ae:	12050f63          	beqz	a0,49ec <dirfile+0x1d2>
  if(link("README", "dirfile/xx") == 0){
    48b2:	00004597          	auipc	a1,0x4
    48b6:	d6e58593          	addi	a1,a1,-658 # 8620 <malloc+0x1b26>
    48ba:	00002517          	auipc	a0,0x2
    48be:	55650513          	addi	a0,a0,1366 # 6e10 <malloc+0x316>
    48c2:	00002097          	auipc	ra,0x2
    48c6:	e3a080e7          	jalr	-454(ra) # 66fc <link>
    48ca:	14050363          	beqz	a0,4a10 <dirfile+0x1f6>
  if(unlink("dirfile") != 0){
    48ce:	00004517          	auipc	a0,0x4
    48d2:	d0a50513          	addi	a0,a0,-758 # 85d8 <malloc+0x1ade>
    48d6:	00002097          	auipc	ra,0x2
    48da:	e16080e7          	jalr	-490(ra) # 66ec <unlink>
    48de:	14051b63          	bnez	a0,4a34 <dirfile+0x21a>
  fd = open(".", O_RDWR);
    48e2:	4589                	li	a1,2
    48e4:	00003517          	auipc	a0,0x3
    48e8:	a3c50513          	addi	a0,a0,-1476 # 7320 <malloc+0x826>
    48ec:	00002097          	auipc	ra,0x2
    48f0:	df0080e7          	jalr	-528(ra) # 66dc <open>
  if(fd >= 0){
    48f4:	16055263          	bgez	a0,4a58 <dirfile+0x23e>
  fd = open(".", 0);
    48f8:	4581                	li	a1,0
    48fa:	00003517          	auipc	a0,0x3
    48fe:	a2650513          	addi	a0,a0,-1498 # 7320 <malloc+0x826>
    4902:	00002097          	auipc	ra,0x2
    4906:	dda080e7          	jalr	-550(ra) # 66dc <open>
    490a:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    490c:	4605                	li	a2,1
    490e:	00002597          	auipc	a1,0x2
    4912:	39a58593          	addi	a1,a1,922 # 6ca8 <malloc+0x1ae>
    4916:	00002097          	auipc	ra,0x2
    491a:	da6080e7          	jalr	-602(ra) # 66bc <write>
    491e:	14a04f63          	bgtz	a0,4a7c <dirfile+0x262>
  close(fd);
    4922:	8526                	mv	a0,s1
    4924:	00002097          	auipc	ra,0x2
    4928:	da0080e7          	jalr	-608(ra) # 66c4 <close>
}
    492c:	60e2                	ld	ra,24(sp)
    492e:	6442                	ld	s0,16(sp)
    4930:	64a2                	ld	s1,8(sp)
    4932:	6902                	ld	s2,0(sp)
    4934:	6105                	addi	sp,sp,32
    4936:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4938:	85ca                	mv	a1,s2
    493a:	00004517          	auipc	a0,0x4
    493e:	ca650513          	addi	a0,a0,-858 # 85e0 <malloc+0x1ae6>
    4942:	00002097          	auipc	ra,0x2
    4946:	0fa080e7          	jalr	250(ra) # 6a3c <printf>
    exit(1,"");
    494a:	00004597          	auipc	a1,0x4
    494e:	8ee58593          	addi	a1,a1,-1810 # 8238 <malloc+0x173e>
    4952:	4505                	li	a0,1
    4954:	00002097          	auipc	ra,0x2
    4958:	d48080e7          	jalr	-696(ra) # 669c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    495c:	85ca                	mv	a1,s2
    495e:	00004517          	auipc	a0,0x4
    4962:	ca250513          	addi	a0,a0,-862 # 8600 <malloc+0x1b06>
    4966:	00002097          	auipc	ra,0x2
    496a:	0d6080e7          	jalr	214(ra) # 6a3c <printf>
    exit(1,"");
    496e:	00004597          	auipc	a1,0x4
    4972:	8ca58593          	addi	a1,a1,-1846 # 8238 <malloc+0x173e>
    4976:	4505                	li	a0,1
    4978:	00002097          	auipc	ra,0x2
    497c:	d24080e7          	jalr	-732(ra) # 669c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4980:	85ca                	mv	a1,s2
    4982:	00004517          	auipc	a0,0x4
    4986:	cae50513          	addi	a0,a0,-850 # 8630 <malloc+0x1b36>
    498a:	00002097          	auipc	ra,0x2
    498e:	0b2080e7          	jalr	178(ra) # 6a3c <printf>
    exit(1,"");
    4992:	00004597          	auipc	a1,0x4
    4996:	8a658593          	addi	a1,a1,-1882 # 8238 <malloc+0x173e>
    499a:	4505                	li	a0,1
    499c:	00002097          	auipc	ra,0x2
    49a0:	d00080e7          	jalr	-768(ra) # 669c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    49a4:	85ca                	mv	a1,s2
    49a6:	00004517          	auipc	a0,0x4
    49aa:	c8a50513          	addi	a0,a0,-886 # 8630 <malloc+0x1b36>
    49ae:	00002097          	auipc	ra,0x2
    49b2:	08e080e7          	jalr	142(ra) # 6a3c <printf>
    exit(1,"");
    49b6:	00004597          	auipc	a1,0x4
    49ba:	88258593          	addi	a1,a1,-1918 # 8238 <malloc+0x173e>
    49be:	4505                	li	a0,1
    49c0:	00002097          	auipc	ra,0x2
    49c4:	cdc080e7          	jalr	-804(ra) # 669c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    49c8:	85ca                	mv	a1,s2
    49ca:	00004517          	auipc	a0,0x4
    49ce:	c8e50513          	addi	a0,a0,-882 # 8658 <malloc+0x1b5e>
    49d2:	00002097          	auipc	ra,0x2
    49d6:	06a080e7          	jalr	106(ra) # 6a3c <printf>
    exit(1,"");
    49da:	00004597          	auipc	a1,0x4
    49de:	85e58593          	addi	a1,a1,-1954 # 8238 <malloc+0x173e>
    49e2:	4505                	li	a0,1
    49e4:	00002097          	auipc	ra,0x2
    49e8:	cb8080e7          	jalr	-840(ra) # 669c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    49ec:	85ca                	mv	a1,s2
    49ee:	00004517          	auipc	a0,0x4
    49f2:	c9250513          	addi	a0,a0,-878 # 8680 <malloc+0x1b86>
    49f6:	00002097          	auipc	ra,0x2
    49fa:	046080e7          	jalr	70(ra) # 6a3c <printf>
    exit(1,"");
    49fe:	00004597          	auipc	a1,0x4
    4a02:	83a58593          	addi	a1,a1,-1990 # 8238 <malloc+0x173e>
    4a06:	4505                	li	a0,1
    4a08:	00002097          	auipc	ra,0x2
    4a0c:	c94080e7          	jalr	-876(ra) # 669c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4a10:	85ca                	mv	a1,s2
    4a12:	00004517          	auipc	a0,0x4
    4a16:	c9650513          	addi	a0,a0,-874 # 86a8 <malloc+0x1bae>
    4a1a:	00002097          	auipc	ra,0x2
    4a1e:	022080e7          	jalr	34(ra) # 6a3c <printf>
    exit(1,"");
    4a22:	00004597          	auipc	a1,0x4
    4a26:	81658593          	addi	a1,a1,-2026 # 8238 <malloc+0x173e>
    4a2a:	4505                	li	a0,1
    4a2c:	00002097          	auipc	ra,0x2
    4a30:	c70080e7          	jalr	-912(ra) # 669c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4a34:	85ca                	mv	a1,s2
    4a36:	00004517          	auipc	a0,0x4
    4a3a:	c9a50513          	addi	a0,a0,-870 # 86d0 <malloc+0x1bd6>
    4a3e:	00002097          	auipc	ra,0x2
    4a42:	ffe080e7          	jalr	-2(ra) # 6a3c <printf>
    exit(1,"");
    4a46:	00003597          	auipc	a1,0x3
    4a4a:	7f258593          	addi	a1,a1,2034 # 8238 <malloc+0x173e>
    4a4e:	4505                	li	a0,1
    4a50:	00002097          	auipc	ra,0x2
    4a54:	c4c080e7          	jalr	-948(ra) # 669c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4a58:	85ca                	mv	a1,s2
    4a5a:	00004517          	auipc	a0,0x4
    4a5e:	c9650513          	addi	a0,a0,-874 # 86f0 <malloc+0x1bf6>
    4a62:	00002097          	auipc	ra,0x2
    4a66:	fda080e7          	jalr	-38(ra) # 6a3c <printf>
    exit(1,"");
    4a6a:	00003597          	auipc	a1,0x3
    4a6e:	7ce58593          	addi	a1,a1,1998 # 8238 <malloc+0x173e>
    4a72:	4505                	li	a0,1
    4a74:	00002097          	auipc	ra,0x2
    4a78:	c28080e7          	jalr	-984(ra) # 669c <exit>
    printf("%s: write . succeeded!\n", s);
    4a7c:	85ca                	mv	a1,s2
    4a7e:	00004517          	auipc	a0,0x4
    4a82:	c9a50513          	addi	a0,a0,-870 # 8718 <malloc+0x1c1e>
    4a86:	00002097          	auipc	ra,0x2
    4a8a:	fb6080e7          	jalr	-74(ra) # 6a3c <printf>
    exit(1,"");
    4a8e:	00003597          	auipc	a1,0x3
    4a92:	7aa58593          	addi	a1,a1,1962 # 8238 <malloc+0x173e>
    4a96:	4505                	li	a0,1
    4a98:	00002097          	auipc	ra,0x2
    4a9c:	c04080e7          	jalr	-1020(ra) # 669c <exit>

0000000000004aa0 <iref>:
{
    4aa0:	7139                	addi	sp,sp,-64
    4aa2:	fc06                	sd	ra,56(sp)
    4aa4:	f822                	sd	s0,48(sp)
    4aa6:	f426                	sd	s1,40(sp)
    4aa8:	f04a                	sd	s2,32(sp)
    4aaa:	ec4e                	sd	s3,24(sp)
    4aac:	e852                	sd	s4,16(sp)
    4aae:	e456                	sd	s5,8(sp)
    4ab0:	e05a                	sd	s6,0(sp)
    4ab2:	0080                	addi	s0,sp,64
    4ab4:	8b2a                	mv	s6,a0
    4ab6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4aba:	00004a17          	auipc	s4,0x4
    4abe:	c76a0a13          	addi	s4,s4,-906 # 8730 <malloc+0x1c36>
    mkdir("");
    4ac2:	00003497          	auipc	s1,0x3
    4ac6:	77648493          	addi	s1,s1,1910 # 8238 <malloc+0x173e>
    link("README", "");
    4aca:	00002a97          	auipc	s5,0x2
    4ace:	346a8a93          	addi	s5,s5,838 # 6e10 <malloc+0x316>
    fd = open("xx", O_CREATE);
    4ad2:	00004997          	auipc	s3,0x4
    4ad6:	b5698993          	addi	s3,s3,-1194 # 8628 <malloc+0x1b2e>
    4ada:	a095                	j	4b3e <iref+0x9e>
      printf("%s: mkdir irefd failed\n", s);
    4adc:	85da                	mv	a1,s6
    4ade:	00004517          	auipc	a0,0x4
    4ae2:	c5a50513          	addi	a0,a0,-934 # 8738 <malloc+0x1c3e>
    4ae6:	00002097          	auipc	ra,0x2
    4aea:	f56080e7          	jalr	-170(ra) # 6a3c <printf>
      exit(1,"");
    4aee:	00003597          	auipc	a1,0x3
    4af2:	74a58593          	addi	a1,a1,1866 # 8238 <malloc+0x173e>
    4af6:	4505                	li	a0,1
    4af8:	00002097          	auipc	ra,0x2
    4afc:	ba4080e7          	jalr	-1116(ra) # 669c <exit>
      printf("%s: chdir irefd failed\n", s);
    4b00:	85da                	mv	a1,s6
    4b02:	00004517          	auipc	a0,0x4
    4b06:	c4e50513          	addi	a0,a0,-946 # 8750 <malloc+0x1c56>
    4b0a:	00002097          	auipc	ra,0x2
    4b0e:	f32080e7          	jalr	-206(ra) # 6a3c <printf>
      exit(1,"");
    4b12:	00003597          	auipc	a1,0x3
    4b16:	72658593          	addi	a1,a1,1830 # 8238 <malloc+0x173e>
    4b1a:	4505                	li	a0,1
    4b1c:	00002097          	auipc	ra,0x2
    4b20:	b80080e7          	jalr	-1152(ra) # 669c <exit>
      close(fd);
    4b24:	00002097          	auipc	ra,0x2
    4b28:	ba0080e7          	jalr	-1120(ra) # 66c4 <close>
    4b2c:	a889                	j	4b7e <iref+0xde>
    unlink("xx");
    4b2e:	854e                	mv	a0,s3
    4b30:	00002097          	auipc	ra,0x2
    4b34:	bbc080e7          	jalr	-1092(ra) # 66ec <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4b38:	397d                	addiw	s2,s2,-1
    4b3a:	06090063          	beqz	s2,4b9a <iref+0xfa>
    if(mkdir("irefd") != 0){
    4b3e:	8552                	mv	a0,s4
    4b40:	00002097          	auipc	ra,0x2
    4b44:	bc4080e7          	jalr	-1084(ra) # 6704 <mkdir>
    4b48:	f951                	bnez	a0,4adc <iref+0x3c>
    if(chdir("irefd") != 0){
    4b4a:	8552                	mv	a0,s4
    4b4c:	00002097          	auipc	ra,0x2
    4b50:	bc0080e7          	jalr	-1088(ra) # 670c <chdir>
    4b54:	f555                	bnez	a0,4b00 <iref+0x60>
    mkdir("");
    4b56:	8526                	mv	a0,s1
    4b58:	00002097          	auipc	ra,0x2
    4b5c:	bac080e7          	jalr	-1108(ra) # 6704 <mkdir>
    link("README", "");
    4b60:	85a6                	mv	a1,s1
    4b62:	8556                	mv	a0,s5
    4b64:	00002097          	auipc	ra,0x2
    4b68:	b98080e7          	jalr	-1128(ra) # 66fc <link>
    fd = open("", O_CREATE);
    4b6c:	20000593          	li	a1,512
    4b70:	8526                	mv	a0,s1
    4b72:	00002097          	auipc	ra,0x2
    4b76:	b6a080e7          	jalr	-1174(ra) # 66dc <open>
    if(fd >= 0)
    4b7a:	fa0555e3          	bgez	a0,4b24 <iref+0x84>
    fd = open("xx", O_CREATE);
    4b7e:	20000593          	li	a1,512
    4b82:	854e                	mv	a0,s3
    4b84:	00002097          	auipc	ra,0x2
    4b88:	b58080e7          	jalr	-1192(ra) # 66dc <open>
    if(fd >= 0)
    4b8c:	fa0541e3          	bltz	a0,4b2e <iref+0x8e>
      close(fd);
    4b90:	00002097          	auipc	ra,0x2
    4b94:	b34080e7          	jalr	-1228(ra) # 66c4 <close>
    4b98:	bf59                	j	4b2e <iref+0x8e>
    4b9a:	03300493          	li	s1,51
    chdir("..");
    4b9e:	00003997          	auipc	s3,0x3
    4ba2:	3ba98993          	addi	s3,s3,954 # 7f58 <malloc+0x145e>
    unlink("irefd");
    4ba6:	00004917          	auipc	s2,0x4
    4baa:	b8a90913          	addi	s2,s2,-1142 # 8730 <malloc+0x1c36>
    chdir("..");
    4bae:	854e                	mv	a0,s3
    4bb0:	00002097          	auipc	ra,0x2
    4bb4:	b5c080e7          	jalr	-1188(ra) # 670c <chdir>
    unlink("irefd");
    4bb8:	854a                	mv	a0,s2
    4bba:	00002097          	auipc	ra,0x2
    4bbe:	b32080e7          	jalr	-1230(ra) # 66ec <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4bc2:	34fd                	addiw	s1,s1,-1
    4bc4:	f4ed                	bnez	s1,4bae <iref+0x10e>
  chdir("/");
    4bc6:	00003517          	auipc	a0,0x3
    4bca:	33a50513          	addi	a0,a0,826 # 7f00 <malloc+0x1406>
    4bce:	00002097          	auipc	ra,0x2
    4bd2:	b3e080e7          	jalr	-1218(ra) # 670c <chdir>
}
    4bd6:	70e2                	ld	ra,56(sp)
    4bd8:	7442                	ld	s0,48(sp)
    4bda:	74a2                	ld	s1,40(sp)
    4bdc:	7902                	ld	s2,32(sp)
    4bde:	69e2                	ld	s3,24(sp)
    4be0:	6a42                	ld	s4,16(sp)
    4be2:	6aa2                	ld	s5,8(sp)
    4be4:	6b02                	ld	s6,0(sp)
    4be6:	6121                	addi	sp,sp,64
    4be8:	8082                	ret

0000000000004bea <openiputtest>:
{
    4bea:	7179                	addi	sp,sp,-48
    4bec:	f406                	sd	ra,40(sp)
    4bee:	f022                	sd	s0,32(sp)
    4bf0:	ec26                	sd	s1,24(sp)
    4bf2:	1800                	addi	s0,sp,48
    4bf4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4bf6:	00004517          	auipc	a0,0x4
    4bfa:	b7250513          	addi	a0,a0,-1166 # 8768 <malloc+0x1c6e>
    4bfe:	00002097          	auipc	ra,0x2
    4c02:	b06080e7          	jalr	-1274(ra) # 6704 <mkdir>
    4c06:	04054663          	bltz	a0,4c52 <openiputtest+0x68>
  pid = fork();
    4c0a:	00002097          	auipc	ra,0x2
    4c0e:	a8a080e7          	jalr	-1398(ra) # 6694 <fork>
  if(pid < 0){
    4c12:	06054263          	bltz	a0,4c76 <openiputtest+0x8c>
  if(pid == 0){
    4c16:	e959                	bnez	a0,4cac <openiputtest+0xc2>
    int fd = open("oidir", O_RDWR);
    4c18:	4589                	li	a1,2
    4c1a:	00004517          	auipc	a0,0x4
    4c1e:	b4e50513          	addi	a0,a0,-1202 # 8768 <malloc+0x1c6e>
    4c22:	00002097          	auipc	ra,0x2
    4c26:	aba080e7          	jalr	-1350(ra) # 66dc <open>
    if(fd >= 0){
    4c2a:	06054863          	bltz	a0,4c9a <openiputtest+0xb0>
      printf("%s: open directory for write succeeded\n", s);
    4c2e:	85a6                	mv	a1,s1
    4c30:	00004517          	auipc	a0,0x4
    4c34:	b5850513          	addi	a0,a0,-1192 # 8788 <malloc+0x1c8e>
    4c38:	00002097          	auipc	ra,0x2
    4c3c:	e04080e7          	jalr	-508(ra) # 6a3c <printf>
      exit(1,"");
    4c40:	00003597          	auipc	a1,0x3
    4c44:	5f858593          	addi	a1,a1,1528 # 8238 <malloc+0x173e>
    4c48:	4505                	li	a0,1
    4c4a:	00002097          	auipc	ra,0x2
    4c4e:	a52080e7          	jalr	-1454(ra) # 669c <exit>
    printf("%s: mkdir oidir failed\n", s);
    4c52:	85a6                	mv	a1,s1
    4c54:	00004517          	auipc	a0,0x4
    4c58:	b1c50513          	addi	a0,a0,-1252 # 8770 <malloc+0x1c76>
    4c5c:	00002097          	auipc	ra,0x2
    4c60:	de0080e7          	jalr	-544(ra) # 6a3c <printf>
    exit(1,"");
    4c64:	00003597          	auipc	a1,0x3
    4c68:	5d458593          	addi	a1,a1,1492 # 8238 <malloc+0x173e>
    4c6c:	4505                	li	a0,1
    4c6e:	00002097          	auipc	ra,0x2
    4c72:	a2e080e7          	jalr	-1490(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    4c76:	85a6                	mv	a1,s1
    4c78:	00003517          	auipc	a0,0x3
    4c7c:	84850513          	addi	a0,a0,-1976 # 74c0 <malloc+0x9c6>
    4c80:	00002097          	auipc	ra,0x2
    4c84:	dbc080e7          	jalr	-580(ra) # 6a3c <printf>
    exit(1,"");
    4c88:	00003597          	auipc	a1,0x3
    4c8c:	5b058593          	addi	a1,a1,1456 # 8238 <malloc+0x173e>
    4c90:	4505                	li	a0,1
    4c92:	00002097          	auipc	ra,0x2
    4c96:	a0a080e7          	jalr	-1526(ra) # 669c <exit>
    exit(0,"");
    4c9a:	00003597          	auipc	a1,0x3
    4c9e:	59e58593          	addi	a1,a1,1438 # 8238 <malloc+0x173e>
    4ca2:	4501                	li	a0,0
    4ca4:	00002097          	auipc	ra,0x2
    4ca8:	9f8080e7          	jalr	-1544(ra) # 669c <exit>
  sleep(1);
    4cac:	4505                	li	a0,1
    4cae:	00002097          	auipc	ra,0x2
    4cb2:	a7e080e7          	jalr	-1410(ra) # 672c <sleep>
  if(unlink("oidir") != 0){
    4cb6:	00004517          	auipc	a0,0x4
    4cba:	ab250513          	addi	a0,a0,-1358 # 8768 <malloc+0x1c6e>
    4cbe:	00002097          	auipc	ra,0x2
    4cc2:	a2e080e7          	jalr	-1490(ra) # 66ec <unlink>
    4cc6:	c11d                	beqz	a0,4cec <openiputtest+0x102>
    printf("%s: unlink failed\n", s);
    4cc8:	85a6                	mv	a1,s1
    4cca:	00003517          	auipc	a0,0x3
    4cce:	9e650513          	addi	a0,a0,-1562 # 76b0 <malloc+0xbb6>
    4cd2:	00002097          	auipc	ra,0x2
    4cd6:	d6a080e7          	jalr	-662(ra) # 6a3c <printf>
    exit(1,"");
    4cda:	00003597          	auipc	a1,0x3
    4cde:	55e58593          	addi	a1,a1,1374 # 8238 <malloc+0x173e>
    4ce2:	4505                	li	a0,1
    4ce4:	00002097          	auipc	ra,0x2
    4ce8:	9b8080e7          	jalr	-1608(ra) # 669c <exit>
  wait(&xstatus,0);
    4cec:	4581                	li	a1,0
    4cee:	fdc40513          	addi	a0,s0,-36
    4cf2:	00002097          	auipc	ra,0x2
    4cf6:	9b2080e7          	jalr	-1614(ra) # 66a4 <wait>
  exit(xstatus,"");
    4cfa:	00003597          	auipc	a1,0x3
    4cfe:	53e58593          	addi	a1,a1,1342 # 8238 <malloc+0x173e>
    4d02:	fdc42503          	lw	a0,-36(s0)
    4d06:	00002097          	auipc	ra,0x2
    4d0a:	996080e7          	jalr	-1642(ra) # 669c <exit>

0000000000004d0e <forkforkfork>:
{
    4d0e:	1101                	addi	sp,sp,-32
    4d10:	ec06                	sd	ra,24(sp)
    4d12:	e822                	sd	s0,16(sp)
    4d14:	e426                	sd	s1,8(sp)
    4d16:	1000                	addi	s0,sp,32
    4d18:	84aa                	mv	s1,a0
  unlink("stopforking");
    4d1a:	00004517          	auipc	a0,0x4
    4d1e:	a9650513          	addi	a0,a0,-1386 # 87b0 <malloc+0x1cb6>
    4d22:	00002097          	auipc	ra,0x2
    4d26:	9ca080e7          	jalr	-1590(ra) # 66ec <unlink>
  int pid = fork();
    4d2a:	00002097          	auipc	ra,0x2
    4d2e:	96a080e7          	jalr	-1686(ra) # 6694 <fork>
  if(pid < 0){
    4d32:	04054663          	bltz	a0,4d7e <forkforkfork+0x70>
  if(pid == 0){
    4d36:	c535                	beqz	a0,4da2 <forkforkfork+0x94>
  sleep(20); // two seconds
    4d38:	4551                	li	a0,20
    4d3a:	00002097          	auipc	ra,0x2
    4d3e:	9f2080e7          	jalr	-1550(ra) # 672c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4d42:	20200593          	li	a1,514
    4d46:	00004517          	auipc	a0,0x4
    4d4a:	a6a50513          	addi	a0,a0,-1430 # 87b0 <malloc+0x1cb6>
    4d4e:	00002097          	auipc	ra,0x2
    4d52:	98e080e7          	jalr	-1650(ra) # 66dc <open>
    4d56:	00002097          	auipc	ra,0x2
    4d5a:	96e080e7          	jalr	-1682(ra) # 66c4 <close>
  wait(0,0);
    4d5e:	4581                	li	a1,0
    4d60:	4501                	li	a0,0
    4d62:	00002097          	auipc	ra,0x2
    4d66:	942080e7          	jalr	-1726(ra) # 66a4 <wait>
  sleep(10); // one second
    4d6a:	4529                	li	a0,10
    4d6c:	00002097          	auipc	ra,0x2
    4d70:	9c0080e7          	jalr	-1600(ra) # 672c <sleep>
}
    4d74:	60e2                	ld	ra,24(sp)
    4d76:	6442                	ld	s0,16(sp)
    4d78:	64a2                	ld	s1,8(sp)
    4d7a:	6105                	addi	sp,sp,32
    4d7c:	8082                	ret
    printf("%s: fork failed", s);
    4d7e:	85a6                	mv	a1,s1
    4d80:	00003517          	auipc	a0,0x3
    4d84:	90050513          	addi	a0,a0,-1792 # 7680 <malloc+0xb86>
    4d88:	00002097          	auipc	ra,0x2
    4d8c:	cb4080e7          	jalr	-844(ra) # 6a3c <printf>
    exit(1,"");
    4d90:	00003597          	auipc	a1,0x3
    4d94:	4a858593          	addi	a1,a1,1192 # 8238 <malloc+0x173e>
    4d98:	4505                	li	a0,1
    4d9a:	00002097          	auipc	ra,0x2
    4d9e:	902080e7          	jalr	-1790(ra) # 669c <exit>
      int fd = open("stopforking", 0);
    4da2:	00004497          	auipc	s1,0x4
    4da6:	a0e48493          	addi	s1,s1,-1522 # 87b0 <malloc+0x1cb6>
    4daa:	4581                	li	a1,0
    4dac:	8526                	mv	a0,s1
    4dae:	00002097          	auipc	ra,0x2
    4db2:	92e080e7          	jalr	-1746(ra) # 66dc <open>
      if(fd >= 0){
    4db6:	02055463          	bgez	a0,4dde <forkforkfork+0xd0>
      if(fork() < 0){
    4dba:	00002097          	auipc	ra,0x2
    4dbe:	8da080e7          	jalr	-1830(ra) # 6694 <fork>
    4dc2:	fe0554e3          	bgez	a0,4daa <forkforkfork+0x9c>
        close(open("stopforking", O_CREATE|O_RDWR));
    4dc6:	20200593          	li	a1,514
    4dca:	8526                	mv	a0,s1
    4dcc:	00002097          	auipc	ra,0x2
    4dd0:	910080e7          	jalr	-1776(ra) # 66dc <open>
    4dd4:	00002097          	auipc	ra,0x2
    4dd8:	8f0080e7          	jalr	-1808(ra) # 66c4 <close>
    4ddc:	b7f9                	j	4daa <forkforkfork+0x9c>
        exit(0,"");
    4dde:	00003597          	auipc	a1,0x3
    4de2:	45a58593          	addi	a1,a1,1114 # 8238 <malloc+0x173e>
    4de6:	4501                	li	a0,0
    4de8:	00002097          	auipc	ra,0x2
    4dec:	8b4080e7          	jalr	-1868(ra) # 669c <exit>

0000000000004df0 <killstatus>:
{
    4df0:	7139                	addi	sp,sp,-64
    4df2:	fc06                	sd	ra,56(sp)
    4df4:	f822                	sd	s0,48(sp)
    4df6:	f426                	sd	s1,40(sp)
    4df8:	f04a                	sd	s2,32(sp)
    4dfa:	ec4e                	sd	s3,24(sp)
    4dfc:	e852                	sd	s4,16(sp)
    4dfe:	0080                	addi	s0,sp,64
    4e00:	8a2a                	mv	s4,a0
    4e02:	06400913          	li	s2,100
    if(xst != -1) {
    4e06:	59fd                	li	s3,-1
    int pid1 = fork();
    4e08:	00002097          	auipc	ra,0x2
    4e0c:	88c080e7          	jalr	-1908(ra) # 6694 <fork>
    4e10:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4e12:	04054463          	bltz	a0,4e5a <killstatus+0x6a>
    if(pid1 == 0){
    4e16:	c525                	beqz	a0,4e7e <killstatus+0x8e>
    sleep(1);
    4e18:	4505                	li	a0,1
    4e1a:	00002097          	auipc	ra,0x2
    4e1e:	912080e7          	jalr	-1774(ra) # 672c <sleep>
    kill(pid1);
    4e22:	8526                	mv	a0,s1
    4e24:	00002097          	auipc	ra,0x2
    4e28:	8a8080e7          	jalr	-1880(ra) # 66cc <kill>
    wait(&xst,0);
    4e2c:	4581                	li	a1,0
    4e2e:	fcc40513          	addi	a0,s0,-52
    4e32:	00002097          	auipc	ra,0x2
    4e36:	872080e7          	jalr	-1934(ra) # 66a4 <wait>
    if(xst != -1) {
    4e3a:	fcc42783          	lw	a5,-52(s0)
    4e3e:	05379563          	bne	a5,s3,4e88 <killstatus+0x98>
  for(int i = 0; i < 100; i++){
    4e42:	397d                	addiw	s2,s2,-1
    4e44:	fc0912e3          	bnez	s2,4e08 <killstatus+0x18>
  exit(0,"");
    4e48:	00003597          	auipc	a1,0x3
    4e4c:	3f058593          	addi	a1,a1,1008 # 8238 <malloc+0x173e>
    4e50:	4501                	li	a0,0
    4e52:	00002097          	auipc	ra,0x2
    4e56:	84a080e7          	jalr	-1974(ra) # 669c <exit>
      printf("%s: fork failed\n", s);
    4e5a:	85d2                	mv	a1,s4
    4e5c:	00002517          	auipc	a0,0x2
    4e60:	66450513          	addi	a0,a0,1636 # 74c0 <malloc+0x9c6>
    4e64:	00002097          	auipc	ra,0x2
    4e68:	bd8080e7          	jalr	-1064(ra) # 6a3c <printf>
      exit(1,"");
    4e6c:	00003597          	auipc	a1,0x3
    4e70:	3cc58593          	addi	a1,a1,972 # 8238 <malloc+0x173e>
    4e74:	4505                	li	a0,1
    4e76:	00002097          	auipc	ra,0x2
    4e7a:	826080e7          	jalr	-2010(ra) # 669c <exit>
        getpid();
    4e7e:	00002097          	auipc	ra,0x2
    4e82:	89e080e7          	jalr	-1890(ra) # 671c <getpid>
      while(1) {
    4e86:	bfe5                	j	4e7e <killstatus+0x8e>
       printf("%s: status should be -1\n", s);
    4e88:	85d2                	mv	a1,s4
    4e8a:	00004517          	auipc	a0,0x4
    4e8e:	93650513          	addi	a0,a0,-1738 # 87c0 <malloc+0x1cc6>
    4e92:	00002097          	auipc	ra,0x2
    4e96:	baa080e7          	jalr	-1110(ra) # 6a3c <printf>
       exit(1,"");
    4e9a:	00003597          	auipc	a1,0x3
    4e9e:	39e58593          	addi	a1,a1,926 # 8238 <malloc+0x173e>
    4ea2:	4505                	li	a0,1
    4ea4:	00001097          	auipc	ra,0x1
    4ea8:	7f8080e7          	jalr	2040(ra) # 669c <exit>

0000000000004eac <preempt>:
{
    4eac:	7139                	addi	sp,sp,-64
    4eae:	fc06                	sd	ra,56(sp)
    4eb0:	f822                	sd	s0,48(sp)
    4eb2:	f426                	sd	s1,40(sp)
    4eb4:	f04a                	sd	s2,32(sp)
    4eb6:	ec4e                	sd	s3,24(sp)
    4eb8:	e852                	sd	s4,16(sp)
    4eba:	0080                	addi	s0,sp,64
    4ebc:	892a                	mv	s2,a0
  pid1 = fork();
    4ebe:	00001097          	auipc	ra,0x1
    4ec2:	7d6080e7          	jalr	2006(ra) # 6694 <fork>
  if(pid1 < 0) {
    4ec6:	00054563          	bltz	a0,4ed0 <preempt+0x24>
    4eca:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4ecc:	e505                	bnez	a0,4ef4 <preempt+0x48>
    for(;;)
    4ece:	a001                	j	4ece <preempt+0x22>
    printf("%s: fork failed", s);
    4ed0:	85ca                	mv	a1,s2
    4ed2:	00002517          	auipc	a0,0x2
    4ed6:	7ae50513          	addi	a0,a0,1966 # 7680 <malloc+0xb86>
    4eda:	00002097          	auipc	ra,0x2
    4ede:	b62080e7          	jalr	-1182(ra) # 6a3c <printf>
    exit(1,"");
    4ee2:	00003597          	auipc	a1,0x3
    4ee6:	35658593          	addi	a1,a1,854 # 8238 <malloc+0x173e>
    4eea:	4505                	li	a0,1
    4eec:	00001097          	auipc	ra,0x1
    4ef0:	7b0080e7          	jalr	1968(ra) # 669c <exit>
  pid2 = fork();
    4ef4:	00001097          	auipc	ra,0x1
    4ef8:	7a0080e7          	jalr	1952(ra) # 6694 <fork>
    4efc:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4efe:	00054463          	bltz	a0,4f06 <preempt+0x5a>
  if(pid2 == 0)
    4f02:	e505                	bnez	a0,4f2a <preempt+0x7e>
    for(;;)
    4f04:	a001                	j	4f04 <preempt+0x58>
    printf("%s: fork failed\n", s);
    4f06:	85ca                	mv	a1,s2
    4f08:	00002517          	auipc	a0,0x2
    4f0c:	5b850513          	addi	a0,a0,1464 # 74c0 <malloc+0x9c6>
    4f10:	00002097          	auipc	ra,0x2
    4f14:	b2c080e7          	jalr	-1236(ra) # 6a3c <printf>
    exit(1,"");
    4f18:	00003597          	auipc	a1,0x3
    4f1c:	32058593          	addi	a1,a1,800 # 8238 <malloc+0x173e>
    4f20:	4505                	li	a0,1
    4f22:	00001097          	auipc	ra,0x1
    4f26:	77a080e7          	jalr	1914(ra) # 669c <exit>
  pipe(pfds);
    4f2a:	fc840513          	addi	a0,s0,-56
    4f2e:	00001097          	auipc	ra,0x1
    4f32:	77e080e7          	jalr	1918(ra) # 66ac <pipe>
  pid3 = fork();
    4f36:	00001097          	auipc	ra,0x1
    4f3a:	75e080e7          	jalr	1886(ra) # 6694 <fork>
    4f3e:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4f40:	02054e63          	bltz	a0,4f7c <preempt+0xd0>
  if(pid3 == 0){
    4f44:	e925                	bnez	a0,4fb4 <preempt+0x108>
    close(pfds[0]);
    4f46:	fc842503          	lw	a0,-56(s0)
    4f4a:	00001097          	auipc	ra,0x1
    4f4e:	77a080e7          	jalr	1914(ra) # 66c4 <close>
    if(write(pfds[1], "x", 1) != 1)
    4f52:	4605                	li	a2,1
    4f54:	00002597          	auipc	a1,0x2
    4f58:	d5458593          	addi	a1,a1,-684 # 6ca8 <malloc+0x1ae>
    4f5c:	fcc42503          	lw	a0,-52(s0)
    4f60:	00001097          	auipc	ra,0x1
    4f64:	75c080e7          	jalr	1884(ra) # 66bc <write>
    4f68:	4785                	li	a5,1
    4f6a:	02f51b63          	bne	a0,a5,4fa0 <preempt+0xf4>
    close(pfds[1]);
    4f6e:	fcc42503          	lw	a0,-52(s0)
    4f72:	00001097          	auipc	ra,0x1
    4f76:	752080e7          	jalr	1874(ra) # 66c4 <close>
    for(;;)
    4f7a:	a001                	j	4f7a <preempt+0xce>
     printf("%s: fork failed\n", s);
    4f7c:	85ca                	mv	a1,s2
    4f7e:	00002517          	auipc	a0,0x2
    4f82:	54250513          	addi	a0,a0,1346 # 74c0 <malloc+0x9c6>
    4f86:	00002097          	auipc	ra,0x2
    4f8a:	ab6080e7          	jalr	-1354(ra) # 6a3c <printf>
     exit(1,"");
    4f8e:	00003597          	auipc	a1,0x3
    4f92:	2aa58593          	addi	a1,a1,682 # 8238 <malloc+0x173e>
    4f96:	4505                	li	a0,1
    4f98:	00001097          	auipc	ra,0x1
    4f9c:	704080e7          	jalr	1796(ra) # 669c <exit>
      printf("%s: preempt write error", s);
    4fa0:	85ca                	mv	a1,s2
    4fa2:	00004517          	auipc	a0,0x4
    4fa6:	83e50513          	addi	a0,a0,-1986 # 87e0 <malloc+0x1ce6>
    4faa:	00002097          	auipc	ra,0x2
    4fae:	a92080e7          	jalr	-1390(ra) # 6a3c <printf>
    4fb2:	bf75                	j	4f6e <preempt+0xc2>
  close(pfds[1]);
    4fb4:	fcc42503          	lw	a0,-52(s0)
    4fb8:	00001097          	auipc	ra,0x1
    4fbc:	70c080e7          	jalr	1804(ra) # 66c4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4fc0:	660d                	lui	a2,0x3
    4fc2:	00009597          	auipc	a1,0x9
    4fc6:	cb658593          	addi	a1,a1,-842 # dc78 <buf>
    4fca:	fc842503          	lw	a0,-56(s0)
    4fce:	00001097          	auipc	ra,0x1
    4fd2:	6e6080e7          	jalr	1766(ra) # 66b4 <read>
    4fd6:	4785                	li	a5,1
    4fd8:	02f50363          	beq	a0,a5,4ffe <preempt+0x152>
    printf("%s: preempt read error", s);
    4fdc:	85ca                	mv	a1,s2
    4fde:	00004517          	auipc	a0,0x4
    4fe2:	81a50513          	addi	a0,a0,-2022 # 87f8 <malloc+0x1cfe>
    4fe6:	00002097          	auipc	ra,0x2
    4fea:	a56080e7          	jalr	-1450(ra) # 6a3c <printf>
}
    4fee:	70e2                	ld	ra,56(sp)
    4ff0:	7442                	ld	s0,48(sp)
    4ff2:	74a2                	ld	s1,40(sp)
    4ff4:	7902                	ld	s2,32(sp)
    4ff6:	69e2                	ld	s3,24(sp)
    4ff8:	6a42                	ld	s4,16(sp)
    4ffa:	6121                	addi	sp,sp,64
    4ffc:	8082                	ret
  close(pfds[0]);
    4ffe:	fc842503          	lw	a0,-56(s0)
    5002:	00001097          	auipc	ra,0x1
    5006:	6c2080e7          	jalr	1730(ra) # 66c4 <close>
  printf("kill... ");
    500a:	00004517          	auipc	a0,0x4
    500e:	80650513          	addi	a0,a0,-2042 # 8810 <malloc+0x1d16>
    5012:	00002097          	auipc	ra,0x2
    5016:	a2a080e7          	jalr	-1494(ra) # 6a3c <printf>
  kill(pid1);
    501a:	8526                	mv	a0,s1
    501c:	00001097          	auipc	ra,0x1
    5020:	6b0080e7          	jalr	1712(ra) # 66cc <kill>
  kill(pid2);
    5024:	854e                	mv	a0,s3
    5026:	00001097          	auipc	ra,0x1
    502a:	6a6080e7          	jalr	1702(ra) # 66cc <kill>
  kill(pid3);
    502e:	8552                	mv	a0,s4
    5030:	00001097          	auipc	ra,0x1
    5034:	69c080e7          	jalr	1692(ra) # 66cc <kill>
  printf("wait... ");
    5038:	00003517          	auipc	a0,0x3
    503c:	7e850513          	addi	a0,a0,2024 # 8820 <malloc+0x1d26>
    5040:	00002097          	auipc	ra,0x2
    5044:	9fc080e7          	jalr	-1540(ra) # 6a3c <printf>
  wait(0,0);
    5048:	4581                	li	a1,0
    504a:	4501                	li	a0,0
    504c:	00001097          	auipc	ra,0x1
    5050:	658080e7          	jalr	1624(ra) # 66a4 <wait>
  wait(0,0);
    5054:	4581                	li	a1,0
    5056:	4501                	li	a0,0
    5058:	00001097          	auipc	ra,0x1
    505c:	64c080e7          	jalr	1612(ra) # 66a4 <wait>
  wait(0,0);
    5060:	4581                	li	a1,0
    5062:	4501                	li	a0,0
    5064:	00001097          	auipc	ra,0x1
    5068:	640080e7          	jalr	1600(ra) # 66a4 <wait>
    506c:	b749                	j	4fee <preempt+0x142>

000000000000506e <reparent>:
{
    506e:	7179                	addi	sp,sp,-48
    5070:	f406                	sd	ra,40(sp)
    5072:	f022                	sd	s0,32(sp)
    5074:	ec26                	sd	s1,24(sp)
    5076:	e84a                	sd	s2,16(sp)
    5078:	e44e                	sd	s3,8(sp)
    507a:	e052                	sd	s4,0(sp)
    507c:	1800                	addi	s0,sp,48
    507e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    5080:	00001097          	auipc	ra,0x1
    5084:	69c080e7          	jalr	1692(ra) # 671c <getpid>
    5088:	8a2a                	mv	s4,a0
    508a:	0c800913          	li	s2,200
    int pid = fork();
    508e:	00001097          	auipc	ra,0x1
    5092:	606080e7          	jalr	1542(ra) # 6694 <fork>
    5096:	84aa                	mv	s1,a0
    if(pid < 0){
    5098:	02054763          	bltz	a0,50c6 <reparent+0x58>
    if(pid){
    509c:	c92d                	beqz	a0,510e <reparent+0xa0>
      if(wait(0,0) != pid){
    509e:	4581                	li	a1,0
    50a0:	4501                	li	a0,0
    50a2:	00001097          	auipc	ra,0x1
    50a6:	602080e7          	jalr	1538(ra) # 66a4 <wait>
    50aa:	04951063          	bne	a0,s1,50ea <reparent+0x7c>
  for(int i = 0; i < 200; i++){
    50ae:	397d                	addiw	s2,s2,-1
    50b0:	fc091fe3          	bnez	s2,508e <reparent+0x20>
  exit(0,"");
    50b4:	00003597          	auipc	a1,0x3
    50b8:	18458593          	addi	a1,a1,388 # 8238 <malloc+0x173e>
    50bc:	4501                	li	a0,0
    50be:	00001097          	auipc	ra,0x1
    50c2:	5de080e7          	jalr	1502(ra) # 669c <exit>
      printf("%s: fork failed\n", s);
    50c6:	85ce                	mv	a1,s3
    50c8:	00002517          	auipc	a0,0x2
    50cc:	3f850513          	addi	a0,a0,1016 # 74c0 <malloc+0x9c6>
    50d0:	00002097          	auipc	ra,0x2
    50d4:	96c080e7          	jalr	-1684(ra) # 6a3c <printf>
      exit(1,"");
    50d8:	00003597          	auipc	a1,0x3
    50dc:	16058593          	addi	a1,a1,352 # 8238 <malloc+0x173e>
    50e0:	4505                	li	a0,1
    50e2:	00001097          	auipc	ra,0x1
    50e6:	5ba080e7          	jalr	1466(ra) # 669c <exit>
        printf("%s: wait wrong pid\n", s);
    50ea:	85ce                	mv	a1,s3
    50ec:	00002517          	auipc	a0,0x2
    50f0:	55c50513          	addi	a0,a0,1372 # 7648 <malloc+0xb4e>
    50f4:	00002097          	auipc	ra,0x2
    50f8:	948080e7          	jalr	-1720(ra) # 6a3c <printf>
        exit(1,"");
    50fc:	00003597          	auipc	a1,0x3
    5100:	13c58593          	addi	a1,a1,316 # 8238 <malloc+0x173e>
    5104:	4505                	li	a0,1
    5106:	00001097          	auipc	ra,0x1
    510a:	596080e7          	jalr	1430(ra) # 669c <exit>
      int pid2 = fork();
    510e:	00001097          	auipc	ra,0x1
    5112:	586080e7          	jalr	1414(ra) # 6694 <fork>
      if(pid2 < 0){
    5116:	00054b63          	bltz	a0,512c <reparent+0xbe>
      exit(0,"");
    511a:	00003597          	auipc	a1,0x3
    511e:	11e58593          	addi	a1,a1,286 # 8238 <malloc+0x173e>
    5122:	4501                	li	a0,0
    5124:	00001097          	auipc	ra,0x1
    5128:	578080e7          	jalr	1400(ra) # 669c <exit>
        kill(master_pid);
    512c:	8552                	mv	a0,s4
    512e:	00001097          	auipc	ra,0x1
    5132:	59e080e7          	jalr	1438(ra) # 66cc <kill>
        exit(1,"");
    5136:	00003597          	auipc	a1,0x3
    513a:	10258593          	addi	a1,a1,258 # 8238 <malloc+0x173e>
    513e:	4505                	li	a0,1
    5140:	00001097          	auipc	ra,0x1
    5144:	55c080e7          	jalr	1372(ra) # 669c <exit>

0000000000005148 <sbrkfail>:
{
    5148:	7119                	addi	sp,sp,-128
    514a:	fc86                	sd	ra,120(sp)
    514c:	f8a2                	sd	s0,112(sp)
    514e:	f4a6                	sd	s1,104(sp)
    5150:	f0ca                	sd	s2,96(sp)
    5152:	ecce                	sd	s3,88(sp)
    5154:	e8d2                	sd	s4,80(sp)
    5156:	e4d6                	sd	s5,72(sp)
    5158:	0100                	addi	s0,sp,128
    515a:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    515c:	fb040513          	addi	a0,s0,-80
    5160:	00001097          	auipc	ra,0x1
    5164:	54c080e7          	jalr	1356(ra) # 66ac <pipe>
    5168:	e901                	bnez	a0,5178 <sbrkfail+0x30>
    516a:	f8040493          	addi	s1,s0,-128
    516e:	fa840993          	addi	s3,s0,-88
    5172:	8926                	mv	s2,s1
    if(pids[i] != -1)
    5174:	5a7d                	li	s4,-1
    5176:	a0a5                	j	51de <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    5178:	85d6                	mv	a1,s5
    517a:	00002517          	auipc	a0,0x2
    517e:	44e50513          	addi	a0,a0,1102 # 75c8 <malloc+0xace>
    5182:	00002097          	auipc	ra,0x2
    5186:	8ba080e7          	jalr	-1862(ra) # 6a3c <printf>
    exit(1,"");
    518a:	00003597          	auipc	a1,0x3
    518e:	0ae58593          	addi	a1,a1,174 # 8238 <malloc+0x173e>
    5192:	4505                	li	a0,1
    5194:	00001097          	auipc	ra,0x1
    5198:	508080e7          	jalr	1288(ra) # 669c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    519c:	00001097          	auipc	ra,0x1
    51a0:	588080e7          	jalr	1416(ra) # 6724 <sbrk>
    51a4:	064007b7          	lui	a5,0x6400
    51a8:	40a7853b          	subw	a0,a5,a0
    51ac:	00001097          	auipc	ra,0x1
    51b0:	578080e7          	jalr	1400(ra) # 6724 <sbrk>
      write(fds[1], "x", 1);
    51b4:	4605                	li	a2,1
    51b6:	00002597          	auipc	a1,0x2
    51ba:	af258593          	addi	a1,a1,-1294 # 6ca8 <malloc+0x1ae>
    51be:	fb442503          	lw	a0,-76(s0)
    51c2:	00001097          	auipc	ra,0x1
    51c6:	4fa080e7          	jalr	1274(ra) # 66bc <write>
      for(;;) sleep(1000);
    51ca:	3e800513          	li	a0,1000
    51ce:	00001097          	auipc	ra,0x1
    51d2:	55e080e7          	jalr	1374(ra) # 672c <sleep>
    51d6:	bfd5                	j	51ca <sbrkfail+0x82>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    51d8:	0911                	addi	s2,s2,4
    51da:	03390563          	beq	s2,s3,5204 <sbrkfail+0xbc>
    if((pids[i] = fork()) == 0){
    51de:	00001097          	auipc	ra,0x1
    51e2:	4b6080e7          	jalr	1206(ra) # 6694 <fork>
    51e6:	00a92023          	sw	a0,0(s2)
    51ea:	d94d                	beqz	a0,519c <sbrkfail+0x54>
    if(pids[i] != -1)
    51ec:	ff4506e3          	beq	a0,s4,51d8 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    51f0:	4605                	li	a2,1
    51f2:	faf40593          	addi	a1,s0,-81
    51f6:	fb042503          	lw	a0,-80(s0)
    51fa:	00001097          	auipc	ra,0x1
    51fe:	4ba080e7          	jalr	1210(ra) # 66b4 <read>
    5202:	bfd9                	j	51d8 <sbrkfail+0x90>
  c = sbrk(PGSIZE);
    5204:	6505                	lui	a0,0x1
    5206:	00001097          	auipc	ra,0x1
    520a:	51e080e7          	jalr	1310(ra) # 6724 <sbrk>
    520e:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    5210:	597d                	li	s2,-1
    5212:	a021                	j	521a <sbrkfail+0xd2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    5214:	0491                	addi	s1,s1,4
    5216:	03348063          	beq	s1,s3,5236 <sbrkfail+0xee>
    if(pids[i] == -1)
    521a:	4088                	lw	a0,0(s1)
    521c:	ff250ce3          	beq	a0,s2,5214 <sbrkfail+0xcc>
    kill(pids[i]);
    5220:	00001097          	auipc	ra,0x1
    5224:	4ac080e7          	jalr	1196(ra) # 66cc <kill>
    wait(0,0);
    5228:	4581                	li	a1,0
    522a:	4501                	li	a0,0
    522c:	00001097          	auipc	ra,0x1
    5230:	478080e7          	jalr	1144(ra) # 66a4 <wait>
    5234:	b7c5                	j	5214 <sbrkfail+0xcc>
  if(c == (char*)0xffffffffffffffffL){
    5236:	57fd                	li	a5,-1
    5238:	04fa0263          	beq	s4,a5,527c <sbrkfail+0x134>
  pid = fork();
    523c:	00001097          	auipc	ra,0x1
    5240:	458080e7          	jalr	1112(ra) # 6694 <fork>
    5244:	84aa                	mv	s1,a0
  if(pid < 0){
    5246:	04054d63          	bltz	a0,52a0 <sbrkfail+0x158>
  if(pid == 0){
    524a:	cd2d                	beqz	a0,52c4 <sbrkfail+0x17c>
  wait(&xstatus,0);
    524c:	4581                	li	a1,0
    524e:	fbc40513          	addi	a0,s0,-68
    5252:	00001097          	auipc	ra,0x1
    5256:	452080e7          	jalr	1106(ra) # 66a4 <wait>
  if(xstatus != -1 && xstatus != 2)
    525a:	fbc42783          	lw	a5,-68(s0)
    525e:	577d                	li	a4,-1
    5260:	00e78563          	beq	a5,a4,526a <sbrkfail+0x122>
    5264:	4709                	li	a4,2
    5266:	0ae79963          	bne	a5,a4,5318 <sbrkfail+0x1d0>
}
    526a:	70e6                	ld	ra,120(sp)
    526c:	7446                	ld	s0,112(sp)
    526e:	74a6                	ld	s1,104(sp)
    5270:	7906                	ld	s2,96(sp)
    5272:	69e6                	ld	s3,88(sp)
    5274:	6a46                	ld	s4,80(sp)
    5276:	6aa6                	ld	s5,72(sp)
    5278:	6109                	addi	sp,sp,128
    527a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    527c:	85d6                	mv	a1,s5
    527e:	00003517          	auipc	a0,0x3
    5282:	5b250513          	addi	a0,a0,1458 # 8830 <malloc+0x1d36>
    5286:	00001097          	auipc	ra,0x1
    528a:	7b6080e7          	jalr	1974(ra) # 6a3c <printf>
    exit(1,"");
    528e:	00003597          	auipc	a1,0x3
    5292:	faa58593          	addi	a1,a1,-86 # 8238 <malloc+0x173e>
    5296:	4505                	li	a0,1
    5298:	00001097          	auipc	ra,0x1
    529c:	404080e7          	jalr	1028(ra) # 669c <exit>
    printf("%s: fork failed\n", s);
    52a0:	85d6                	mv	a1,s5
    52a2:	00002517          	auipc	a0,0x2
    52a6:	21e50513          	addi	a0,a0,542 # 74c0 <malloc+0x9c6>
    52aa:	00001097          	auipc	ra,0x1
    52ae:	792080e7          	jalr	1938(ra) # 6a3c <printf>
    exit(1,"");
    52b2:	00003597          	auipc	a1,0x3
    52b6:	f8658593          	addi	a1,a1,-122 # 8238 <malloc+0x173e>
    52ba:	4505                	li	a0,1
    52bc:	00001097          	auipc	ra,0x1
    52c0:	3e0080e7          	jalr	992(ra) # 669c <exit>
    a = sbrk(0);
    52c4:	4501                	li	a0,0
    52c6:	00001097          	auipc	ra,0x1
    52ca:	45e080e7          	jalr	1118(ra) # 6724 <sbrk>
    52ce:	892a                	mv	s2,a0
    sbrk(10*BIG);
    52d0:	3e800537          	lui	a0,0x3e800
    52d4:	00001097          	auipc	ra,0x1
    52d8:	450080e7          	jalr	1104(ra) # 6724 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52dc:	87ca                	mv	a5,s2
    52de:	3e800737          	lui	a4,0x3e800
    52e2:	993a                	add	s2,s2,a4
    52e4:	6705                	lui	a4,0x1
      n += *(a+i);
    52e6:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63ef388>
    52ea:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52ec:	97ba                	add	a5,a5,a4
    52ee:	ff279ce3          	bne	a5,s2,52e6 <sbrkfail+0x19e>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    52f2:	8626                	mv	a2,s1
    52f4:	85d6                	mv	a1,s5
    52f6:	00003517          	auipc	a0,0x3
    52fa:	55a50513          	addi	a0,a0,1370 # 8850 <malloc+0x1d56>
    52fe:	00001097          	auipc	ra,0x1
    5302:	73e080e7          	jalr	1854(ra) # 6a3c <printf>
    exit(1,"");
    5306:	00003597          	auipc	a1,0x3
    530a:	f3258593          	addi	a1,a1,-206 # 8238 <malloc+0x173e>
    530e:	4505                	li	a0,1
    5310:	00001097          	auipc	ra,0x1
    5314:	38c080e7          	jalr	908(ra) # 669c <exit>
    exit(1,"");
    5318:	00003597          	auipc	a1,0x3
    531c:	f2058593          	addi	a1,a1,-224 # 8238 <malloc+0x173e>
    5320:	4505                	li	a0,1
    5322:	00001097          	auipc	ra,0x1
    5326:	37a080e7          	jalr	890(ra) # 669c <exit>

000000000000532a <mem>:
{
    532a:	7139                	addi	sp,sp,-64
    532c:	fc06                	sd	ra,56(sp)
    532e:	f822                	sd	s0,48(sp)
    5330:	f426                	sd	s1,40(sp)
    5332:	f04a                	sd	s2,32(sp)
    5334:	ec4e                	sd	s3,24(sp)
    5336:	0080                	addi	s0,sp,64
    5338:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    533a:	00001097          	auipc	ra,0x1
    533e:	35a080e7          	jalr	858(ra) # 6694 <fork>
    m1 = 0;
    5342:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    5344:	6909                	lui	s2,0x2
    5346:	71190913          	addi	s2,s2,1809 # 2711 <bigargtest+0x19>
  if((pid = fork()) == 0){
    534a:	c51d                	beqz	a0,5378 <mem+0x4e>
    wait(&xstatus,0);
    534c:	4581                	li	a1,0
    534e:	fcc40513          	addi	a0,s0,-52
    5352:	00001097          	auipc	ra,0x1
    5356:	352080e7          	jalr	850(ra) # 66a4 <wait>
    if(xstatus == -1){
    535a:	fcc42503          	lw	a0,-52(s0)
    535e:	57fd                	li	a5,-1
    5360:	06f50f63          	beq	a0,a5,53de <mem+0xb4>
    exit(xstatus,"");
    5364:	00003597          	auipc	a1,0x3
    5368:	ed458593          	addi	a1,a1,-300 # 8238 <malloc+0x173e>
    536c:	00001097          	auipc	ra,0x1
    5370:	330080e7          	jalr	816(ra) # 669c <exit>
      *(char**)m2 = m1;
    5374:	e104                	sd	s1,0(a0)
      m1 = m2;
    5376:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    5378:	854a                	mv	a0,s2
    537a:	00001097          	auipc	ra,0x1
    537e:	780080e7          	jalr	1920(ra) # 6afa <malloc>
    5382:	f96d                	bnez	a0,5374 <mem+0x4a>
    while(m1){
    5384:	c881                	beqz	s1,5394 <mem+0x6a>
      m2 = *(char**)m1;
    5386:	8526                	mv	a0,s1
    5388:	6084                	ld	s1,0(s1)
      free(m1);
    538a:	00001097          	auipc	ra,0x1
    538e:	6e8080e7          	jalr	1768(ra) # 6a72 <free>
    while(m1){
    5392:	f8f5                	bnez	s1,5386 <mem+0x5c>
    m1 = malloc(1024*20);
    5394:	6515                	lui	a0,0x5
    5396:	00001097          	auipc	ra,0x1
    539a:	764080e7          	jalr	1892(ra) # 6afa <malloc>
    if(m1 == 0){
    539e:	cd11                	beqz	a0,53ba <mem+0x90>
    free(m1);
    53a0:	00001097          	auipc	ra,0x1
    53a4:	6d2080e7          	jalr	1746(ra) # 6a72 <free>
    exit(0,"");
    53a8:	00003597          	auipc	a1,0x3
    53ac:	e9058593          	addi	a1,a1,-368 # 8238 <malloc+0x173e>
    53b0:	4501                	li	a0,0
    53b2:	00001097          	auipc	ra,0x1
    53b6:	2ea080e7          	jalr	746(ra) # 669c <exit>
      printf("couldn't allocate mem?!!\n", s);
    53ba:	85ce                	mv	a1,s3
    53bc:	00003517          	auipc	a0,0x3
    53c0:	4c450513          	addi	a0,a0,1220 # 8880 <malloc+0x1d86>
    53c4:	00001097          	auipc	ra,0x1
    53c8:	678080e7          	jalr	1656(ra) # 6a3c <printf>
      exit(1,"");
    53cc:	00003597          	auipc	a1,0x3
    53d0:	e6c58593          	addi	a1,a1,-404 # 8238 <malloc+0x173e>
    53d4:	4505                	li	a0,1
    53d6:	00001097          	auipc	ra,0x1
    53da:	2c6080e7          	jalr	710(ra) # 669c <exit>
      exit(0,"");
    53de:	00003597          	auipc	a1,0x3
    53e2:	e5a58593          	addi	a1,a1,-422 # 8238 <malloc+0x173e>
    53e6:	4501                	li	a0,0
    53e8:	00001097          	auipc	ra,0x1
    53ec:	2b4080e7          	jalr	692(ra) # 669c <exit>

00000000000053f0 <sharedfd>:
{
    53f0:	7159                	addi	sp,sp,-112
    53f2:	f486                	sd	ra,104(sp)
    53f4:	f0a2                	sd	s0,96(sp)
    53f6:	eca6                	sd	s1,88(sp)
    53f8:	e8ca                	sd	s2,80(sp)
    53fa:	e4ce                	sd	s3,72(sp)
    53fc:	e0d2                	sd	s4,64(sp)
    53fe:	fc56                	sd	s5,56(sp)
    5400:	f85a                	sd	s6,48(sp)
    5402:	f45e                	sd	s7,40(sp)
    5404:	1880                	addi	s0,sp,112
    5406:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    5408:	00003517          	auipc	a0,0x3
    540c:	49850513          	addi	a0,a0,1176 # 88a0 <malloc+0x1da6>
    5410:	00001097          	auipc	ra,0x1
    5414:	2dc080e7          	jalr	732(ra) # 66ec <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    5418:	20200593          	li	a1,514
    541c:	00003517          	auipc	a0,0x3
    5420:	48450513          	addi	a0,a0,1156 # 88a0 <malloc+0x1da6>
    5424:	00001097          	auipc	ra,0x1
    5428:	2b8080e7          	jalr	696(ra) # 66dc <open>
  if(fd < 0){
    542c:	04054e63          	bltz	a0,5488 <sharedfd+0x98>
    5430:	892a                	mv	s2,a0
  pid = fork();
    5432:	00001097          	auipc	ra,0x1
    5436:	262080e7          	jalr	610(ra) # 6694 <fork>
    543a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    543c:	06300593          	li	a1,99
    5440:	c119                	beqz	a0,5446 <sharedfd+0x56>
    5442:	07000593          	li	a1,112
    5446:	4629                	li	a2,10
    5448:	fa040513          	addi	a0,s0,-96
    544c:	00001097          	auipc	ra,0x1
    5450:	054080e7          	jalr	84(ra) # 64a0 <memset>
    5454:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    5458:	4629                	li	a2,10
    545a:	fa040593          	addi	a1,s0,-96
    545e:	854a                	mv	a0,s2
    5460:	00001097          	auipc	ra,0x1
    5464:	25c080e7          	jalr	604(ra) # 66bc <write>
    5468:	47a9                	li	a5,10
    546a:	04f51163          	bne	a0,a5,54ac <sharedfd+0xbc>
  for(i = 0; i < N; i++){
    546e:	34fd                	addiw	s1,s1,-1
    5470:	f4e5                	bnez	s1,5458 <sharedfd+0x68>
  if(pid == 0) {
    5472:	04099f63          	bnez	s3,54d0 <sharedfd+0xe0>
    exit(0,"");
    5476:	00003597          	auipc	a1,0x3
    547a:	dc258593          	addi	a1,a1,-574 # 8238 <malloc+0x173e>
    547e:	4501                	li	a0,0
    5480:	00001097          	auipc	ra,0x1
    5484:	21c080e7          	jalr	540(ra) # 669c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    5488:	85d2                	mv	a1,s4
    548a:	00003517          	auipc	a0,0x3
    548e:	42650513          	addi	a0,a0,1062 # 88b0 <malloc+0x1db6>
    5492:	00001097          	auipc	ra,0x1
    5496:	5aa080e7          	jalr	1450(ra) # 6a3c <printf>
    exit(1,"");
    549a:	00003597          	auipc	a1,0x3
    549e:	d9e58593          	addi	a1,a1,-610 # 8238 <malloc+0x173e>
    54a2:	4505                	li	a0,1
    54a4:	00001097          	auipc	ra,0x1
    54a8:	1f8080e7          	jalr	504(ra) # 669c <exit>
      printf("%s: write sharedfd failed\n", s);
    54ac:	85d2                	mv	a1,s4
    54ae:	00003517          	auipc	a0,0x3
    54b2:	42a50513          	addi	a0,a0,1066 # 88d8 <malloc+0x1dde>
    54b6:	00001097          	auipc	ra,0x1
    54ba:	586080e7          	jalr	1414(ra) # 6a3c <printf>
      exit(1,"");
    54be:	00003597          	auipc	a1,0x3
    54c2:	d7a58593          	addi	a1,a1,-646 # 8238 <malloc+0x173e>
    54c6:	4505                	li	a0,1
    54c8:	00001097          	auipc	ra,0x1
    54cc:	1d4080e7          	jalr	468(ra) # 669c <exit>
    wait(&xstatus,0);
    54d0:	4581                	li	a1,0
    54d2:	f9c40513          	addi	a0,s0,-100
    54d6:	00001097          	auipc	ra,0x1
    54da:	1ce080e7          	jalr	462(ra) # 66a4 <wait>
    if(xstatus != 0)
    54de:	f9c42983          	lw	s3,-100(s0)
    54e2:	00098b63          	beqz	s3,54f8 <sharedfd+0x108>
      exit(xstatus,"");
    54e6:	00003597          	auipc	a1,0x3
    54ea:	d5258593          	addi	a1,a1,-686 # 8238 <malloc+0x173e>
    54ee:	854e                	mv	a0,s3
    54f0:	00001097          	auipc	ra,0x1
    54f4:	1ac080e7          	jalr	428(ra) # 669c <exit>
  close(fd);
    54f8:	854a                	mv	a0,s2
    54fa:	00001097          	auipc	ra,0x1
    54fe:	1ca080e7          	jalr	458(ra) # 66c4 <close>
  fd = open("sharedfd", 0);
    5502:	4581                	li	a1,0
    5504:	00003517          	auipc	a0,0x3
    5508:	39c50513          	addi	a0,a0,924 # 88a0 <malloc+0x1da6>
    550c:	00001097          	auipc	ra,0x1
    5510:	1d0080e7          	jalr	464(ra) # 66dc <open>
    5514:	8baa                	mv	s7,a0
  nc = np = 0;
    5516:	8ace                	mv	s5,s3
  if(fd < 0){
    5518:	02054563          	bltz	a0,5542 <sharedfd+0x152>
    551c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    5520:	06300493          	li	s1,99
      if(buf[i] == 'p')
    5524:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    5528:	4629                	li	a2,10
    552a:	fa040593          	addi	a1,s0,-96
    552e:	855e                	mv	a0,s7
    5530:	00001097          	auipc	ra,0x1
    5534:	184080e7          	jalr	388(ra) # 66b4 <read>
    5538:	04a05363          	blez	a0,557e <sharedfd+0x18e>
    553c:	fa040793          	addi	a5,s0,-96
    5540:	a03d                	j	556e <sharedfd+0x17e>
    printf("%s: cannot open sharedfd for reading\n", s);
    5542:	85d2                	mv	a1,s4
    5544:	00003517          	auipc	a0,0x3
    5548:	3b450513          	addi	a0,a0,948 # 88f8 <malloc+0x1dfe>
    554c:	00001097          	auipc	ra,0x1
    5550:	4f0080e7          	jalr	1264(ra) # 6a3c <printf>
    exit(1,"");
    5554:	00003597          	auipc	a1,0x3
    5558:	ce458593          	addi	a1,a1,-796 # 8238 <malloc+0x173e>
    555c:	4505                	li	a0,1
    555e:	00001097          	auipc	ra,0x1
    5562:	13e080e7          	jalr	318(ra) # 669c <exit>
        nc++;
    5566:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    5568:	0785                	addi	a5,a5,1
    556a:	fb278fe3          	beq	a5,s2,5528 <sharedfd+0x138>
      if(buf[i] == 'c')
    556e:	0007c703          	lbu	a4,0(a5)
    5572:	fe970ae3          	beq	a4,s1,5566 <sharedfd+0x176>
      if(buf[i] == 'p')
    5576:	ff6719e3          	bne	a4,s6,5568 <sharedfd+0x178>
        np++;
    557a:	2a85                	addiw	s5,s5,1
    557c:	b7f5                	j	5568 <sharedfd+0x178>
  close(fd);
    557e:	855e                	mv	a0,s7
    5580:	00001097          	auipc	ra,0x1
    5584:	144080e7          	jalr	324(ra) # 66c4 <close>
  unlink("sharedfd");
    5588:	00003517          	auipc	a0,0x3
    558c:	31850513          	addi	a0,a0,792 # 88a0 <malloc+0x1da6>
    5590:	00001097          	auipc	ra,0x1
    5594:	15c080e7          	jalr	348(ra) # 66ec <unlink>
  if(nc == N*SZ && np == N*SZ){
    5598:	6789                	lui	a5,0x2
    559a:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x18>
    559e:	00f99763          	bne	s3,a5,55ac <sharedfd+0x1bc>
    55a2:	6789                	lui	a5,0x2
    55a4:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x18>
    55a8:	02fa8463          	beq	s5,a5,55d0 <sharedfd+0x1e0>
    printf("%s: nc/np test fails\n", s);
    55ac:	85d2                	mv	a1,s4
    55ae:	00003517          	auipc	a0,0x3
    55b2:	37250513          	addi	a0,a0,882 # 8920 <malloc+0x1e26>
    55b6:	00001097          	auipc	ra,0x1
    55ba:	486080e7          	jalr	1158(ra) # 6a3c <printf>
    exit(1,"");
    55be:	00003597          	auipc	a1,0x3
    55c2:	c7a58593          	addi	a1,a1,-902 # 8238 <malloc+0x173e>
    55c6:	4505                	li	a0,1
    55c8:	00001097          	auipc	ra,0x1
    55cc:	0d4080e7          	jalr	212(ra) # 669c <exit>
    exit(0,"");
    55d0:	00003597          	auipc	a1,0x3
    55d4:	c6858593          	addi	a1,a1,-920 # 8238 <malloc+0x173e>
    55d8:	4501                	li	a0,0
    55da:	00001097          	auipc	ra,0x1
    55de:	0c2080e7          	jalr	194(ra) # 669c <exit>

00000000000055e2 <fourfiles>:
{
    55e2:	7171                	addi	sp,sp,-176
    55e4:	f506                	sd	ra,168(sp)
    55e6:	f122                	sd	s0,160(sp)
    55e8:	ed26                	sd	s1,152(sp)
    55ea:	e94a                	sd	s2,144(sp)
    55ec:	e54e                	sd	s3,136(sp)
    55ee:	e152                	sd	s4,128(sp)
    55f0:	fcd6                	sd	s5,120(sp)
    55f2:	f8da                	sd	s6,112(sp)
    55f4:	f4de                	sd	s7,104(sp)
    55f6:	f0e2                	sd	s8,96(sp)
    55f8:	ece6                	sd	s9,88(sp)
    55fa:	e8ea                	sd	s10,80(sp)
    55fc:	e4ee                	sd	s11,72(sp)
    55fe:	1900                	addi	s0,sp,176
    5600:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    5604:	00001797          	auipc	a5,0x1
    5608:	5dc78793          	addi	a5,a5,1500 # 6be0 <malloc+0xe6>
    560c:	f6f43823          	sd	a5,-144(s0)
    5610:	00001797          	auipc	a5,0x1
    5614:	5d878793          	addi	a5,a5,1496 # 6be8 <malloc+0xee>
    5618:	f6f43c23          	sd	a5,-136(s0)
    561c:	00001797          	auipc	a5,0x1
    5620:	5d478793          	addi	a5,a5,1492 # 6bf0 <malloc+0xf6>
    5624:	f8f43023          	sd	a5,-128(s0)
    5628:	00001797          	auipc	a5,0x1
    562c:	5d078793          	addi	a5,a5,1488 # 6bf8 <malloc+0xfe>
    5630:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    5634:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    5638:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    563a:	4481                	li	s1,0
    563c:	4a11                	li	s4,4
    fname = names[pi];
    563e:	00093983          	ld	s3,0(s2)
    unlink(fname);
    5642:	854e                	mv	a0,s3
    5644:	00001097          	auipc	ra,0x1
    5648:	0a8080e7          	jalr	168(ra) # 66ec <unlink>
    pid = fork();
    564c:	00001097          	auipc	ra,0x1
    5650:	048080e7          	jalr	72(ra) # 6694 <fork>
    if(pid < 0){
    5654:	04054563          	bltz	a0,569e <fourfiles+0xbc>
    if(pid == 0){
    5658:	c535                	beqz	a0,56c4 <fourfiles+0xe2>
  for(pi = 0; pi < NCHILD; pi++){
    565a:	2485                	addiw	s1,s1,1
    565c:	0921                	addi	s2,s2,8
    565e:	ff4490e3          	bne	s1,s4,563e <fourfiles+0x5c>
    5662:	4491                	li	s1,4
    wait(&xstatus,0);
    5664:	4581                	li	a1,0
    5666:	f6c40513          	addi	a0,s0,-148
    566a:	00001097          	auipc	ra,0x1
    566e:	03a080e7          	jalr	58(ra) # 66a4 <wait>
    if(xstatus != 0)
    5672:	f6c42b03          	lw	s6,-148(s0)
    5676:	0e0b1e63          	bnez	s6,5772 <fourfiles+0x190>
  for(pi = 0; pi < NCHILD; pi++){
    567a:	34fd                	addiw	s1,s1,-1
    567c:	f4e5                	bnez	s1,5664 <fourfiles+0x82>
    567e:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5682:	00008a17          	auipc	s4,0x8
    5686:	5f6a0a13          	addi	s4,s4,1526 # dc78 <buf>
    568a:	00008a97          	auipc	s5,0x8
    568e:	5efa8a93          	addi	s5,s5,1519 # dc79 <buf+0x1>
    if(total != N*SZ){
    5692:	6d85                	lui	s11,0x1
    5694:	770d8d93          	addi	s11,s11,1904 # 1770 <copyinstr2+0x1fe>
  for(i = 0; i < NCHILD; i++){
    5698:	03400d13          	li	s10,52
    569c:	a29d                	j	5802 <fourfiles+0x220>
      printf("fork failed\n", s);
    569e:	f5843583          	ld	a1,-168(s0)
    56a2:	00002517          	auipc	a0,0x2
    56a6:	23650513          	addi	a0,a0,566 # 78d8 <malloc+0xdde>
    56aa:	00001097          	auipc	ra,0x1
    56ae:	392080e7          	jalr	914(ra) # 6a3c <printf>
      exit(1,"");
    56b2:	00003597          	auipc	a1,0x3
    56b6:	b8658593          	addi	a1,a1,-1146 # 8238 <malloc+0x173e>
    56ba:	4505                	li	a0,1
    56bc:	00001097          	auipc	ra,0x1
    56c0:	fe0080e7          	jalr	-32(ra) # 669c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    56c4:	20200593          	li	a1,514
    56c8:	854e                	mv	a0,s3
    56ca:	00001097          	auipc	ra,0x1
    56ce:	012080e7          	jalr	18(ra) # 66dc <open>
    56d2:	892a                	mv	s2,a0
      if(fd < 0){
    56d4:	04054b63          	bltz	a0,572a <fourfiles+0x148>
      memset(buf, '0'+pi, SZ);
    56d8:	1f400613          	li	a2,500
    56dc:	0304859b          	addiw	a1,s1,48
    56e0:	00008517          	auipc	a0,0x8
    56e4:	59850513          	addi	a0,a0,1432 # dc78 <buf>
    56e8:	00001097          	auipc	ra,0x1
    56ec:	db8080e7          	jalr	-584(ra) # 64a0 <memset>
    56f0:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    56f2:	00008997          	auipc	s3,0x8
    56f6:	58698993          	addi	s3,s3,1414 # dc78 <buf>
    56fa:	1f400613          	li	a2,500
    56fe:	85ce                	mv	a1,s3
    5700:	854a                	mv	a0,s2
    5702:	00001097          	auipc	ra,0x1
    5706:	fba080e7          	jalr	-70(ra) # 66bc <write>
    570a:	85aa                	mv	a1,a0
    570c:	1f400793          	li	a5,500
    5710:	04f51063          	bne	a0,a5,5750 <fourfiles+0x16e>
      for(i = 0; i < N; i++){
    5714:	34fd                	addiw	s1,s1,-1
    5716:	f0f5                	bnez	s1,56fa <fourfiles+0x118>
      exit(0,"");
    5718:	00003597          	auipc	a1,0x3
    571c:	b2058593          	addi	a1,a1,-1248 # 8238 <malloc+0x173e>
    5720:	4501                	li	a0,0
    5722:	00001097          	auipc	ra,0x1
    5726:	f7a080e7          	jalr	-134(ra) # 669c <exit>
        printf("create failed\n", s);
    572a:	f5843583          	ld	a1,-168(s0)
    572e:	00003517          	auipc	a0,0x3
    5732:	20a50513          	addi	a0,a0,522 # 8938 <malloc+0x1e3e>
    5736:	00001097          	auipc	ra,0x1
    573a:	306080e7          	jalr	774(ra) # 6a3c <printf>
        exit(1,"");
    573e:	00003597          	auipc	a1,0x3
    5742:	afa58593          	addi	a1,a1,-1286 # 8238 <malloc+0x173e>
    5746:	4505                	li	a0,1
    5748:	00001097          	auipc	ra,0x1
    574c:	f54080e7          	jalr	-172(ra) # 669c <exit>
          printf("write failed %d\n", n);
    5750:	00003517          	auipc	a0,0x3
    5754:	1f850513          	addi	a0,a0,504 # 8948 <malloc+0x1e4e>
    5758:	00001097          	auipc	ra,0x1
    575c:	2e4080e7          	jalr	740(ra) # 6a3c <printf>
          exit(1,"");
    5760:	00003597          	auipc	a1,0x3
    5764:	ad858593          	addi	a1,a1,-1320 # 8238 <malloc+0x173e>
    5768:	4505                	li	a0,1
    576a:	00001097          	auipc	ra,0x1
    576e:	f32080e7          	jalr	-206(ra) # 669c <exit>
      exit(xstatus,"");
    5772:	00003597          	auipc	a1,0x3
    5776:	ac658593          	addi	a1,a1,-1338 # 8238 <malloc+0x173e>
    577a:	855a                	mv	a0,s6
    577c:	00001097          	auipc	ra,0x1
    5780:	f20080e7          	jalr	-224(ra) # 669c <exit>
          printf("wrong char\n", s);
    5784:	f5843583          	ld	a1,-168(s0)
    5788:	00003517          	auipc	a0,0x3
    578c:	1d850513          	addi	a0,a0,472 # 8960 <malloc+0x1e66>
    5790:	00001097          	auipc	ra,0x1
    5794:	2ac080e7          	jalr	684(ra) # 6a3c <printf>
          exit(1,"");
    5798:	00003597          	auipc	a1,0x3
    579c:	aa058593          	addi	a1,a1,-1376 # 8238 <malloc+0x173e>
    57a0:	4505                	li	a0,1
    57a2:	00001097          	auipc	ra,0x1
    57a6:	efa080e7          	jalr	-262(ra) # 669c <exit>
      total += n;
    57aa:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    57ae:	660d                	lui	a2,0x3
    57b0:	85d2                	mv	a1,s4
    57b2:	854e                	mv	a0,s3
    57b4:	00001097          	auipc	ra,0x1
    57b8:	f00080e7          	jalr	-256(ra) # 66b4 <read>
    57bc:	02a05363          	blez	a0,57e2 <fourfiles+0x200>
    57c0:	00008797          	auipc	a5,0x8
    57c4:	4b878793          	addi	a5,a5,1208 # dc78 <buf>
    57c8:	fff5069b          	addiw	a3,a0,-1
    57cc:	1682                	slli	a3,a3,0x20
    57ce:	9281                	srli	a3,a3,0x20
    57d0:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    57d2:	0007c703          	lbu	a4,0(a5)
    57d6:	fa9717e3          	bne	a4,s1,5784 <fourfiles+0x1a2>
      for(j = 0; j < n; j++){
    57da:	0785                	addi	a5,a5,1
    57dc:	fed79be3          	bne	a5,a3,57d2 <fourfiles+0x1f0>
    57e0:	b7e9                	j	57aa <fourfiles+0x1c8>
    close(fd);
    57e2:	854e                	mv	a0,s3
    57e4:	00001097          	auipc	ra,0x1
    57e8:	ee0080e7          	jalr	-288(ra) # 66c4 <close>
    if(total != N*SZ){
    57ec:	03b91863          	bne	s2,s11,581c <fourfiles+0x23a>
    unlink(fname);
    57f0:	8566                	mv	a0,s9
    57f2:	00001097          	auipc	ra,0x1
    57f6:	efa080e7          	jalr	-262(ra) # 66ec <unlink>
  for(i = 0; i < NCHILD; i++){
    57fa:	0c21                	addi	s8,s8,8
    57fc:	2b85                	addiw	s7,s7,1
    57fe:	05ab8163          	beq	s7,s10,5840 <fourfiles+0x25e>
    fname = names[i];
    5802:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    5806:	4581                	li	a1,0
    5808:	8566                	mv	a0,s9
    580a:	00001097          	auipc	ra,0x1
    580e:	ed2080e7          	jalr	-302(ra) # 66dc <open>
    5812:	89aa                	mv	s3,a0
    total = 0;
    5814:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    5816:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    581a:	bf51                	j	57ae <fourfiles+0x1cc>
      printf("wrong length %d\n", total);
    581c:	85ca                	mv	a1,s2
    581e:	00003517          	auipc	a0,0x3
    5822:	15250513          	addi	a0,a0,338 # 8970 <malloc+0x1e76>
    5826:	00001097          	auipc	ra,0x1
    582a:	216080e7          	jalr	534(ra) # 6a3c <printf>
      exit(1,"");
    582e:	00003597          	auipc	a1,0x3
    5832:	a0a58593          	addi	a1,a1,-1526 # 8238 <malloc+0x173e>
    5836:	4505                	li	a0,1
    5838:	00001097          	auipc	ra,0x1
    583c:	e64080e7          	jalr	-412(ra) # 669c <exit>
}
    5840:	70aa                	ld	ra,168(sp)
    5842:	740a                	ld	s0,160(sp)
    5844:	64ea                	ld	s1,152(sp)
    5846:	694a                	ld	s2,144(sp)
    5848:	69aa                	ld	s3,136(sp)
    584a:	6a0a                	ld	s4,128(sp)
    584c:	7ae6                	ld	s5,120(sp)
    584e:	7b46                	ld	s6,112(sp)
    5850:	7ba6                	ld	s7,104(sp)
    5852:	7c06                	ld	s8,96(sp)
    5854:	6ce6                	ld	s9,88(sp)
    5856:	6d46                	ld	s10,80(sp)
    5858:	6da6                	ld	s11,72(sp)
    585a:	614d                	addi	sp,sp,176
    585c:	8082                	ret

000000000000585e <concreate>:
{
    585e:	7135                	addi	sp,sp,-160
    5860:	ed06                	sd	ra,152(sp)
    5862:	e922                	sd	s0,144(sp)
    5864:	e526                	sd	s1,136(sp)
    5866:	e14a                	sd	s2,128(sp)
    5868:	fcce                	sd	s3,120(sp)
    586a:	f8d2                	sd	s4,112(sp)
    586c:	f4d6                	sd	s5,104(sp)
    586e:	f0da                	sd	s6,96(sp)
    5870:	ecde                	sd	s7,88(sp)
    5872:	1100                	addi	s0,sp,160
    5874:	89aa                	mv	s3,a0
  file[0] = 'C';
    5876:	04300793          	li	a5,67
    587a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    587e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    5882:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    5884:	4b0d                	li	s6,3
    5886:	4a85                	li	s5,1
      link("C0", file);
    5888:	00003b97          	auipc	s7,0x3
    588c:	100b8b93          	addi	s7,s7,256 # 8988 <malloc+0x1e8e>
  for(i = 0; i < N; i++){
    5890:	02800a13          	li	s4,40
    5894:	ae11                	j	5ba8 <concreate+0x34a>
      link("C0", file);
    5896:	fa840593          	addi	a1,s0,-88
    589a:	855e                	mv	a0,s7
    589c:	00001097          	auipc	ra,0x1
    58a0:	e60080e7          	jalr	-416(ra) # 66fc <link>
    if(pid == 0) {
    58a4:	a4e5                	j	5b8c <concreate+0x32e>
    } else if(pid == 0 && (i % 5) == 1){
    58a6:	4795                	li	a5,5
    58a8:	02f9693b          	remw	s2,s2,a5
    58ac:	4785                	li	a5,1
    58ae:	02f90f63          	beq	s2,a5,58ec <concreate+0x8e>
      fd = open(file, O_CREATE | O_RDWR);
    58b2:	20200593          	li	a1,514
    58b6:	fa840513          	addi	a0,s0,-88
    58ba:	00001097          	auipc	ra,0x1
    58be:	e22080e7          	jalr	-478(ra) # 66dc <open>
      if(fd < 0){
    58c2:	2a055c63          	bgez	a0,5b7a <concreate+0x31c>
        printf("concreate create %s failed\n", file);
    58c6:	fa840593          	addi	a1,s0,-88
    58ca:	00003517          	auipc	a0,0x3
    58ce:	0c650513          	addi	a0,a0,198 # 8990 <malloc+0x1e96>
    58d2:	00001097          	auipc	ra,0x1
    58d6:	16a080e7          	jalr	362(ra) # 6a3c <printf>
        exit(1,"");
    58da:	00003597          	auipc	a1,0x3
    58de:	95e58593          	addi	a1,a1,-1698 # 8238 <malloc+0x173e>
    58e2:	4505                	li	a0,1
    58e4:	00001097          	auipc	ra,0x1
    58e8:	db8080e7          	jalr	-584(ra) # 669c <exit>
      link("C0", file);
    58ec:	fa840593          	addi	a1,s0,-88
    58f0:	00003517          	auipc	a0,0x3
    58f4:	09850513          	addi	a0,a0,152 # 8988 <malloc+0x1e8e>
    58f8:	00001097          	auipc	ra,0x1
    58fc:	e04080e7          	jalr	-508(ra) # 66fc <link>
      exit(0,"");
    5900:	00003597          	auipc	a1,0x3
    5904:	93858593          	addi	a1,a1,-1736 # 8238 <malloc+0x173e>
    5908:	4501                	li	a0,0
    590a:	00001097          	auipc	ra,0x1
    590e:	d92080e7          	jalr	-622(ra) # 669c <exit>
        exit(1,"");
    5912:	00003597          	auipc	a1,0x3
    5916:	92658593          	addi	a1,a1,-1754 # 8238 <malloc+0x173e>
    591a:	4505                	li	a0,1
    591c:	00001097          	auipc	ra,0x1
    5920:	d80080e7          	jalr	-640(ra) # 669c <exit>
  memset(fa, 0, sizeof(fa));
    5924:	02800613          	li	a2,40
    5928:	4581                	li	a1,0
    592a:	f8040513          	addi	a0,s0,-128
    592e:	00001097          	auipc	ra,0x1
    5932:	b72080e7          	jalr	-1166(ra) # 64a0 <memset>
  fd = open(".", 0);
    5936:	4581                	li	a1,0
    5938:	00002517          	auipc	a0,0x2
    593c:	9e850513          	addi	a0,a0,-1560 # 7320 <malloc+0x826>
    5940:	00001097          	auipc	ra,0x1
    5944:	d9c080e7          	jalr	-612(ra) # 66dc <open>
    5948:	892a                	mv	s2,a0
  n = 0;
    594a:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    594c:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    5950:	02700b13          	li	s6,39
      fa[i] = 1;
    5954:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    5956:	4641                	li	a2,16
    5958:	f7040593          	addi	a1,s0,-144
    595c:	854a                	mv	a0,s2
    595e:	00001097          	auipc	ra,0x1
    5962:	d56080e7          	jalr	-682(ra) # 66b4 <read>
    5966:	08a05963          	blez	a0,59f8 <concreate+0x19a>
    if(de.inum == 0)
    596a:	f7045783          	lhu	a5,-144(s0)
    596e:	d7e5                	beqz	a5,5956 <concreate+0xf8>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5970:	f7244783          	lbu	a5,-142(s0)
    5974:	ff4791e3          	bne	a5,s4,5956 <concreate+0xf8>
    5978:	f7444783          	lbu	a5,-140(s0)
    597c:	ffe9                	bnez	a5,5956 <concreate+0xf8>
      i = de.name[1] - '0';
    597e:	f7344783          	lbu	a5,-141(s0)
    5982:	fd07879b          	addiw	a5,a5,-48
    5986:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    598a:	00eb6f63          	bltu	s6,a4,59a8 <concreate+0x14a>
      if(fa[i]){
    598e:	fb040793          	addi	a5,s0,-80
    5992:	97ba                	add	a5,a5,a4
    5994:	fd07c783          	lbu	a5,-48(a5)
    5998:	ef85                	bnez	a5,59d0 <concreate+0x172>
      fa[i] = 1;
    599a:	fb040793          	addi	a5,s0,-80
    599e:	973e                	add	a4,a4,a5
    59a0:	fd770823          	sb	s7,-48(a4) # fd0 <unlinkread+0x158>
      n++;
    59a4:	2a85                	addiw	s5,s5,1
    59a6:	bf45                	j	5956 <concreate+0xf8>
        printf("%s: concreate weird file %s\n", s, de.name);
    59a8:	f7240613          	addi	a2,s0,-142
    59ac:	85ce                	mv	a1,s3
    59ae:	00003517          	auipc	a0,0x3
    59b2:	00250513          	addi	a0,a0,2 # 89b0 <malloc+0x1eb6>
    59b6:	00001097          	auipc	ra,0x1
    59ba:	086080e7          	jalr	134(ra) # 6a3c <printf>
        exit(1,"");
    59be:	00003597          	auipc	a1,0x3
    59c2:	87a58593          	addi	a1,a1,-1926 # 8238 <malloc+0x173e>
    59c6:	4505                	li	a0,1
    59c8:	00001097          	auipc	ra,0x1
    59cc:	cd4080e7          	jalr	-812(ra) # 669c <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    59d0:	f7240613          	addi	a2,s0,-142
    59d4:	85ce                	mv	a1,s3
    59d6:	00003517          	auipc	a0,0x3
    59da:	ffa50513          	addi	a0,a0,-6 # 89d0 <malloc+0x1ed6>
    59de:	00001097          	auipc	ra,0x1
    59e2:	05e080e7          	jalr	94(ra) # 6a3c <printf>
        exit(1,"");
    59e6:	00003597          	auipc	a1,0x3
    59ea:	85258593          	addi	a1,a1,-1966 # 8238 <malloc+0x173e>
    59ee:	4505                	li	a0,1
    59f0:	00001097          	auipc	ra,0x1
    59f4:	cac080e7          	jalr	-852(ra) # 669c <exit>
  close(fd);
    59f8:	854a                	mv	a0,s2
    59fa:	00001097          	auipc	ra,0x1
    59fe:	cca080e7          	jalr	-822(ra) # 66c4 <close>
  if(n != N){
    5a02:	02800793          	li	a5,40
    5a06:	00fa9763          	bne	s5,a5,5a14 <concreate+0x1b6>
    if(((i % 3) == 0 && pid == 0) ||
    5a0a:	4a8d                	li	s5,3
    5a0c:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5a0e:	02800a13          	li	s4,40
    5a12:	a0d5                	j	5af6 <concreate+0x298>
    printf("%s: concreate not enough files in directory listing\n", s);
    5a14:	85ce                	mv	a1,s3
    5a16:	00003517          	auipc	a0,0x3
    5a1a:	fe250513          	addi	a0,a0,-30 # 89f8 <malloc+0x1efe>
    5a1e:	00001097          	auipc	ra,0x1
    5a22:	01e080e7          	jalr	30(ra) # 6a3c <printf>
    exit(1,"");
    5a26:	00003597          	auipc	a1,0x3
    5a2a:	81258593          	addi	a1,a1,-2030 # 8238 <malloc+0x173e>
    5a2e:	4505                	li	a0,1
    5a30:	00001097          	auipc	ra,0x1
    5a34:	c6c080e7          	jalr	-916(ra) # 669c <exit>
      printf("%s: fork failed\n", s);
    5a38:	85ce                	mv	a1,s3
    5a3a:	00002517          	auipc	a0,0x2
    5a3e:	a8650513          	addi	a0,a0,-1402 # 74c0 <malloc+0x9c6>
    5a42:	00001097          	auipc	ra,0x1
    5a46:	ffa080e7          	jalr	-6(ra) # 6a3c <printf>
      exit(1,"");
    5a4a:	00002597          	auipc	a1,0x2
    5a4e:	7ee58593          	addi	a1,a1,2030 # 8238 <malloc+0x173e>
    5a52:	4505                	li	a0,1
    5a54:	00001097          	auipc	ra,0x1
    5a58:	c48080e7          	jalr	-952(ra) # 669c <exit>
      close(open(file, 0));
    5a5c:	4581                	li	a1,0
    5a5e:	fa840513          	addi	a0,s0,-88
    5a62:	00001097          	auipc	ra,0x1
    5a66:	c7a080e7          	jalr	-902(ra) # 66dc <open>
    5a6a:	00001097          	auipc	ra,0x1
    5a6e:	c5a080e7          	jalr	-934(ra) # 66c4 <close>
      close(open(file, 0));
    5a72:	4581                	li	a1,0
    5a74:	fa840513          	addi	a0,s0,-88
    5a78:	00001097          	auipc	ra,0x1
    5a7c:	c64080e7          	jalr	-924(ra) # 66dc <open>
    5a80:	00001097          	auipc	ra,0x1
    5a84:	c44080e7          	jalr	-956(ra) # 66c4 <close>
      close(open(file, 0));
    5a88:	4581                	li	a1,0
    5a8a:	fa840513          	addi	a0,s0,-88
    5a8e:	00001097          	auipc	ra,0x1
    5a92:	c4e080e7          	jalr	-946(ra) # 66dc <open>
    5a96:	00001097          	auipc	ra,0x1
    5a9a:	c2e080e7          	jalr	-978(ra) # 66c4 <close>
      close(open(file, 0));
    5a9e:	4581                	li	a1,0
    5aa0:	fa840513          	addi	a0,s0,-88
    5aa4:	00001097          	auipc	ra,0x1
    5aa8:	c38080e7          	jalr	-968(ra) # 66dc <open>
    5aac:	00001097          	auipc	ra,0x1
    5ab0:	c18080e7          	jalr	-1000(ra) # 66c4 <close>
      close(open(file, 0));
    5ab4:	4581                	li	a1,0
    5ab6:	fa840513          	addi	a0,s0,-88
    5aba:	00001097          	auipc	ra,0x1
    5abe:	c22080e7          	jalr	-990(ra) # 66dc <open>
    5ac2:	00001097          	auipc	ra,0x1
    5ac6:	c02080e7          	jalr	-1022(ra) # 66c4 <close>
      close(open(file, 0));
    5aca:	4581                	li	a1,0
    5acc:	fa840513          	addi	a0,s0,-88
    5ad0:	00001097          	auipc	ra,0x1
    5ad4:	c0c080e7          	jalr	-1012(ra) # 66dc <open>
    5ad8:	00001097          	auipc	ra,0x1
    5adc:	bec080e7          	jalr	-1044(ra) # 66c4 <close>
    if(pid == 0)
    5ae0:	08090463          	beqz	s2,5b68 <concreate+0x30a>
      wait(0,0);
    5ae4:	4581                	li	a1,0
    5ae6:	4501                	li	a0,0
    5ae8:	00001097          	auipc	ra,0x1
    5aec:	bbc080e7          	jalr	-1092(ra) # 66a4 <wait>
  for(i = 0; i < N; i++){
    5af0:	2485                	addiw	s1,s1,1
    5af2:	0f448a63          	beq	s1,s4,5be6 <concreate+0x388>
    file[1] = '0' + i;
    5af6:	0304879b          	addiw	a5,s1,48
    5afa:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5afe:	00001097          	auipc	ra,0x1
    5b02:	b96080e7          	jalr	-1130(ra) # 6694 <fork>
    5b06:	892a                	mv	s2,a0
    if(pid < 0){
    5b08:	f20548e3          	bltz	a0,5a38 <concreate+0x1da>
    if(((i % 3) == 0 && pid == 0) ||
    5b0c:	0354e73b          	remw	a4,s1,s5
    5b10:	00a767b3          	or	a5,a4,a0
    5b14:	2781                	sext.w	a5,a5
    5b16:	d3b9                	beqz	a5,5a5c <concreate+0x1fe>
    5b18:	01671363          	bne	a4,s6,5b1e <concreate+0x2c0>
       ((i % 3) == 1 && pid != 0)){
    5b1c:	f121                	bnez	a0,5a5c <concreate+0x1fe>
      unlink(file);
    5b1e:	fa840513          	addi	a0,s0,-88
    5b22:	00001097          	auipc	ra,0x1
    5b26:	bca080e7          	jalr	-1078(ra) # 66ec <unlink>
      unlink(file);
    5b2a:	fa840513          	addi	a0,s0,-88
    5b2e:	00001097          	auipc	ra,0x1
    5b32:	bbe080e7          	jalr	-1090(ra) # 66ec <unlink>
      unlink(file);
    5b36:	fa840513          	addi	a0,s0,-88
    5b3a:	00001097          	auipc	ra,0x1
    5b3e:	bb2080e7          	jalr	-1102(ra) # 66ec <unlink>
      unlink(file);
    5b42:	fa840513          	addi	a0,s0,-88
    5b46:	00001097          	auipc	ra,0x1
    5b4a:	ba6080e7          	jalr	-1114(ra) # 66ec <unlink>
      unlink(file);
    5b4e:	fa840513          	addi	a0,s0,-88
    5b52:	00001097          	auipc	ra,0x1
    5b56:	b9a080e7          	jalr	-1126(ra) # 66ec <unlink>
      unlink(file);
    5b5a:	fa840513          	addi	a0,s0,-88
    5b5e:	00001097          	auipc	ra,0x1
    5b62:	b8e080e7          	jalr	-1138(ra) # 66ec <unlink>
    5b66:	bfad                	j	5ae0 <concreate+0x282>
      exit(0,"");
    5b68:	00002597          	auipc	a1,0x2
    5b6c:	6d058593          	addi	a1,a1,1744 # 8238 <malloc+0x173e>
    5b70:	4501                	li	a0,0
    5b72:	00001097          	auipc	ra,0x1
    5b76:	b2a080e7          	jalr	-1238(ra) # 669c <exit>
      close(fd);
    5b7a:	00001097          	auipc	ra,0x1
    5b7e:	b4a080e7          	jalr	-1206(ra) # 66c4 <close>
    if(pid == 0) {
    5b82:	bbbd                	j	5900 <concreate+0xa2>
      close(fd);
    5b84:	00001097          	auipc	ra,0x1
    5b88:	b40080e7          	jalr	-1216(ra) # 66c4 <close>
      wait(&xstatus,0);
    5b8c:	4581                	li	a1,0
    5b8e:	f6c40513          	addi	a0,s0,-148
    5b92:	00001097          	auipc	ra,0x1
    5b96:	b12080e7          	jalr	-1262(ra) # 66a4 <wait>
      if(xstatus != 0)
    5b9a:	f6c42483          	lw	s1,-148(s0)
    5b9e:	d6049ae3          	bnez	s1,5912 <concreate+0xb4>
  for(i = 0; i < N; i++){
    5ba2:	2905                	addiw	s2,s2,1
    5ba4:	d94900e3          	beq	s2,s4,5924 <concreate+0xc6>
    file[1] = '0' + i;
    5ba8:	0309079b          	addiw	a5,s2,48
    5bac:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5bb0:	fa840513          	addi	a0,s0,-88
    5bb4:	00001097          	auipc	ra,0x1
    5bb8:	b38080e7          	jalr	-1224(ra) # 66ec <unlink>
    pid = fork();
    5bbc:	00001097          	auipc	ra,0x1
    5bc0:	ad8080e7          	jalr	-1320(ra) # 6694 <fork>
    if(pid && (i % 3) == 1){
    5bc4:	ce0501e3          	beqz	a0,58a6 <concreate+0x48>
    5bc8:	036967bb          	remw	a5,s2,s6
    5bcc:	cd5785e3          	beq	a5,s5,5896 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5bd0:	20200593          	li	a1,514
    5bd4:	fa840513          	addi	a0,s0,-88
    5bd8:	00001097          	auipc	ra,0x1
    5bdc:	b04080e7          	jalr	-1276(ra) # 66dc <open>
      if(fd < 0){
    5be0:	fa0552e3          	bgez	a0,5b84 <concreate+0x326>
    5be4:	b1cd                	j	58c6 <concreate+0x68>
}
    5be6:	60ea                	ld	ra,152(sp)
    5be8:	644a                	ld	s0,144(sp)
    5bea:	64aa                	ld	s1,136(sp)
    5bec:	690a                	ld	s2,128(sp)
    5bee:	79e6                	ld	s3,120(sp)
    5bf0:	7a46                	ld	s4,112(sp)
    5bf2:	7aa6                	ld	s5,104(sp)
    5bf4:	7b06                	ld	s6,96(sp)
    5bf6:	6be6                	ld	s7,88(sp)
    5bf8:	610d                	addi	sp,sp,160
    5bfa:	8082                	ret

0000000000005bfc <bigfile>:
{
    5bfc:	7139                	addi	sp,sp,-64
    5bfe:	fc06                	sd	ra,56(sp)
    5c00:	f822                	sd	s0,48(sp)
    5c02:	f426                	sd	s1,40(sp)
    5c04:	f04a                	sd	s2,32(sp)
    5c06:	ec4e                	sd	s3,24(sp)
    5c08:	e852                	sd	s4,16(sp)
    5c0a:	e456                	sd	s5,8(sp)
    5c0c:	0080                	addi	s0,sp,64
    5c0e:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5c10:	00003517          	auipc	a0,0x3
    5c14:	e2050513          	addi	a0,a0,-480 # 8a30 <malloc+0x1f36>
    5c18:	00001097          	auipc	ra,0x1
    5c1c:	ad4080e7          	jalr	-1324(ra) # 66ec <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5c20:	20200593          	li	a1,514
    5c24:	00003517          	auipc	a0,0x3
    5c28:	e0c50513          	addi	a0,a0,-500 # 8a30 <malloc+0x1f36>
    5c2c:	00001097          	auipc	ra,0x1
    5c30:	ab0080e7          	jalr	-1360(ra) # 66dc <open>
    5c34:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5c36:	4481                	li	s1,0
    memset(buf, i, SZ);
    5c38:	00008917          	auipc	s2,0x8
    5c3c:	04090913          	addi	s2,s2,64 # dc78 <buf>
  for(i = 0; i < N; i++){
    5c40:	4a51                	li	s4,20
  if(fd < 0){
    5c42:	0a054163          	bltz	a0,5ce4 <bigfile+0xe8>
    memset(buf, i, SZ);
    5c46:	25800613          	li	a2,600
    5c4a:	85a6                	mv	a1,s1
    5c4c:	854a                	mv	a0,s2
    5c4e:	00001097          	auipc	ra,0x1
    5c52:	852080e7          	jalr	-1966(ra) # 64a0 <memset>
    if(write(fd, buf, SZ) != SZ){
    5c56:	25800613          	li	a2,600
    5c5a:	85ca                	mv	a1,s2
    5c5c:	854e                	mv	a0,s3
    5c5e:	00001097          	auipc	ra,0x1
    5c62:	a5e080e7          	jalr	-1442(ra) # 66bc <write>
    5c66:	25800793          	li	a5,600
    5c6a:	08f51f63          	bne	a0,a5,5d08 <bigfile+0x10c>
  for(i = 0; i < N; i++){
    5c6e:	2485                	addiw	s1,s1,1
    5c70:	fd449be3          	bne	s1,s4,5c46 <bigfile+0x4a>
  close(fd);
    5c74:	854e                	mv	a0,s3
    5c76:	00001097          	auipc	ra,0x1
    5c7a:	a4e080e7          	jalr	-1458(ra) # 66c4 <close>
  fd = open("bigfile.dat", 0);
    5c7e:	4581                	li	a1,0
    5c80:	00003517          	auipc	a0,0x3
    5c84:	db050513          	addi	a0,a0,-592 # 8a30 <malloc+0x1f36>
    5c88:	00001097          	auipc	ra,0x1
    5c8c:	a54080e7          	jalr	-1452(ra) # 66dc <open>
    5c90:	8a2a                	mv	s4,a0
  total = 0;
    5c92:	4981                	li	s3,0
  for(i = 0; ; i++){
    5c94:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5c96:	00008917          	auipc	s2,0x8
    5c9a:	fe290913          	addi	s2,s2,-30 # dc78 <buf>
  if(fd < 0){
    5c9e:	08054763          	bltz	a0,5d2c <bigfile+0x130>
    cc = read(fd, buf, SZ/2);
    5ca2:	12c00613          	li	a2,300
    5ca6:	85ca                	mv	a1,s2
    5ca8:	8552                	mv	a0,s4
    5caa:	00001097          	auipc	ra,0x1
    5cae:	a0a080e7          	jalr	-1526(ra) # 66b4 <read>
    if(cc < 0){
    5cb2:	08054f63          	bltz	a0,5d50 <bigfile+0x154>
    if(cc == 0)
    5cb6:	10050363          	beqz	a0,5dbc <bigfile+0x1c0>
    if(cc != SZ/2){
    5cba:	12c00793          	li	a5,300
    5cbe:	0af51b63          	bne	a0,a5,5d74 <bigfile+0x178>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5cc2:	01f4d79b          	srliw	a5,s1,0x1f
    5cc6:	9fa5                	addw	a5,a5,s1
    5cc8:	4017d79b          	sraiw	a5,a5,0x1
    5ccc:	00094703          	lbu	a4,0(s2)
    5cd0:	0cf71463          	bne	a4,a5,5d98 <bigfile+0x19c>
    5cd4:	12b94703          	lbu	a4,299(s2)
    5cd8:	0cf71063          	bne	a4,a5,5d98 <bigfile+0x19c>
    total += cc;
    5cdc:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    5ce0:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5ce2:	b7c1                	j	5ca2 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5ce4:	85d6                	mv	a1,s5
    5ce6:	00003517          	auipc	a0,0x3
    5cea:	d5a50513          	addi	a0,a0,-678 # 8a40 <malloc+0x1f46>
    5cee:	00001097          	auipc	ra,0x1
    5cf2:	d4e080e7          	jalr	-690(ra) # 6a3c <printf>
    exit(1,"");
    5cf6:	00002597          	auipc	a1,0x2
    5cfa:	54258593          	addi	a1,a1,1346 # 8238 <malloc+0x173e>
    5cfe:	4505                	li	a0,1
    5d00:	00001097          	auipc	ra,0x1
    5d04:	99c080e7          	jalr	-1636(ra) # 669c <exit>
      printf("%s: write bigfile failed\n", s);
    5d08:	85d6                	mv	a1,s5
    5d0a:	00003517          	auipc	a0,0x3
    5d0e:	d5650513          	addi	a0,a0,-682 # 8a60 <malloc+0x1f66>
    5d12:	00001097          	auipc	ra,0x1
    5d16:	d2a080e7          	jalr	-726(ra) # 6a3c <printf>
      exit(1,"");
    5d1a:	00002597          	auipc	a1,0x2
    5d1e:	51e58593          	addi	a1,a1,1310 # 8238 <malloc+0x173e>
    5d22:	4505                	li	a0,1
    5d24:	00001097          	auipc	ra,0x1
    5d28:	978080e7          	jalr	-1672(ra) # 669c <exit>
    printf("%s: cannot open bigfile\n", s);
    5d2c:	85d6                	mv	a1,s5
    5d2e:	00003517          	auipc	a0,0x3
    5d32:	d5250513          	addi	a0,a0,-686 # 8a80 <malloc+0x1f86>
    5d36:	00001097          	auipc	ra,0x1
    5d3a:	d06080e7          	jalr	-762(ra) # 6a3c <printf>
    exit(1,"");
    5d3e:	00002597          	auipc	a1,0x2
    5d42:	4fa58593          	addi	a1,a1,1274 # 8238 <malloc+0x173e>
    5d46:	4505                	li	a0,1
    5d48:	00001097          	auipc	ra,0x1
    5d4c:	954080e7          	jalr	-1708(ra) # 669c <exit>
      printf("%s: read bigfile failed\n", s);
    5d50:	85d6                	mv	a1,s5
    5d52:	00003517          	auipc	a0,0x3
    5d56:	d4e50513          	addi	a0,a0,-690 # 8aa0 <malloc+0x1fa6>
    5d5a:	00001097          	auipc	ra,0x1
    5d5e:	ce2080e7          	jalr	-798(ra) # 6a3c <printf>
      exit(1,"");
    5d62:	00002597          	auipc	a1,0x2
    5d66:	4d658593          	addi	a1,a1,1238 # 8238 <malloc+0x173e>
    5d6a:	4505                	li	a0,1
    5d6c:	00001097          	auipc	ra,0x1
    5d70:	930080e7          	jalr	-1744(ra) # 669c <exit>
      printf("%s: short read bigfile\n", s);
    5d74:	85d6                	mv	a1,s5
    5d76:	00003517          	auipc	a0,0x3
    5d7a:	d4a50513          	addi	a0,a0,-694 # 8ac0 <malloc+0x1fc6>
    5d7e:	00001097          	auipc	ra,0x1
    5d82:	cbe080e7          	jalr	-834(ra) # 6a3c <printf>
      exit(1,"");
    5d86:	00002597          	auipc	a1,0x2
    5d8a:	4b258593          	addi	a1,a1,1202 # 8238 <malloc+0x173e>
    5d8e:	4505                	li	a0,1
    5d90:	00001097          	auipc	ra,0x1
    5d94:	90c080e7          	jalr	-1780(ra) # 669c <exit>
      printf("%s: read bigfile wrong data\n", s);
    5d98:	85d6                	mv	a1,s5
    5d9a:	00003517          	auipc	a0,0x3
    5d9e:	d3e50513          	addi	a0,a0,-706 # 8ad8 <malloc+0x1fde>
    5da2:	00001097          	auipc	ra,0x1
    5da6:	c9a080e7          	jalr	-870(ra) # 6a3c <printf>
      exit(1,"");
    5daa:	00002597          	auipc	a1,0x2
    5dae:	48e58593          	addi	a1,a1,1166 # 8238 <malloc+0x173e>
    5db2:	4505                	li	a0,1
    5db4:	00001097          	auipc	ra,0x1
    5db8:	8e8080e7          	jalr	-1816(ra) # 669c <exit>
  close(fd);
    5dbc:	8552                	mv	a0,s4
    5dbe:	00001097          	auipc	ra,0x1
    5dc2:	906080e7          	jalr	-1786(ra) # 66c4 <close>
  if(total != N*SZ){
    5dc6:	678d                	lui	a5,0x3
    5dc8:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbasic+0x106>
    5dcc:	02f99363          	bne	s3,a5,5df2 <bigfile+0x1f6>
  unlink("bigfile.dat");
    5dd0:	00003517          	auipc	a0,0x3
    5dd4:	c6050513          	addi	a0,a0,-928 # 8a30 <malloc+0x1f36>
    5dd8:	00001097          	auipc	ra,0x1
    5ddc:	914080e7          	jalr	-1772(ra) # 66ec <unlink>
}
    5de0:	70e2                	ld	ra,56(sp)
    5de2:	7442                	ld	s0,48(sp)
    5de4:	74a2                	ld	s1,40(sp)
    5de6:	7902                	ld	s2,32(sp)
    5de8:	69e2                	ld	s3,24(sp)
    5dea:	6a42                	ld	s4,16(sp)
    5dec:	6aa2                	ld	s5,8(sp)
    5dee:	6121                	addi	sp,sp,64
    5df0:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5df2:	85d6                	mv	a1,s5
    5df4:	00003517          	auipc	a0,0x3
    5df8:	d0450513          	addi	a0,a0,-764 # 8af8 <malloc+0x1ffe>
    5dfc:	00001097          	auipc	ra,0x1
    5e00:	c40080e7          	jalr	-960(ra) # 6a3c <printf>
    exit(1,"");
    5e04:	00002597          	auipc	a1,0x2
    5e08:	43458593          	addi	a1,a1,1076 # 8238 <malloc+0x173e>
    5e0c:	4505                	li	a0,1
    5e0e:	00001097          	auipc	ra,0x1
    5e12:	88e080e7          	jalr	-1906(ra) # 669c <exit>

0000000000005e16 <fsfull>:
{
    5e16:	7171                	addi	sp,sp,-176
    5e18:	f506                	sd	ra,168(sp)
    5e1a:	f122                	sd	s0,160(sp)
    5e1c:	ed26                	sd	s1,152(sp)
    5e1e:	e94a                	sd	s2,144(sp)
    5e20:	e54e                	sd	s3,136(sp)
    5e22:	e152                	sd	s4,128(sp)
    5e24:	fcd6                	sd	s5,120(sp)
    5e26:	f8da                	sd	s6,112(sp)
    5e28:	f4de                	sd	s7,104(sp)
    5e2a:	f0e2                	sd	s8,96(sp)
    5e2c:	ece6                	sd	s9,88(sp)
    5e2e:	e8ea                	sd	s10,80(sp)
    5e30:	e4ee                	sd	s11,72(sp)
    5e32:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    5e34:	00003517          	auipc	a0,0x3
    5e38:	ce450513          	addi	a0,a0,-796 # 8b18 <malloc+0x201e>
    5e3c:	00001097          	auipc	ra,0x1
    5e40:	c00080e7          	jalr	-1024(ra) # 6a3c <printf>
  for(nfiles = 0; ; nfiles++){
    5e44:	4481                	li	s1,0
    name[0] = 'f';
    5e46:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5e4a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5e4e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5e52:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5e54:	00003c97          	auipc	s9,0x3
    5e58:	cd4c8c93          	addi	s9,s9,-812 # 8b28 <malloc+0x202e>
    int total = 0;
    5e5c:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5e5e:	00008a17          	auipc	s4,0x8
    5e62:	e1aa0a13          	addi	s4,s4,-486 # dc78 <buf>
    name[0] = 'f';
    5e66:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5e6a:	0384c7bb          	divw	a5,s1,s8
    5e6e:	0307879b          	addiw	a5,a5,48
    5e72:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5e76:	0384e7bb          	remw	a5,s1,s8
    5e7a:	0377c7bb          	divw	a5,a5,s7
    5e7e:	0307879b          	addiw	a5,a5,48
    5e82:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5e86:	0374e7bb          	remw	a5,s1,s7
    5e8a:	0367c7bb          	divw	a5,a5,s6
    5e8e:	0307879b          	addiw	a5,a5,48
    5e92:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5e96:	0364e7bb          	remw	a5,s1,s6
    5e9a:	0307879b          	addiw	a5,a5,48
    5e9e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5ea2:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5ea6:	f5040593          	addi	a1,s0,-176
    5eaa:	8566                	mv	a0,s9
    5eac:	00001097          	auipc	ra,0x1
    5eb0:	b90080e7          	jalr	-1136(ra) # 6a3c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5eb4:	20200593          	li	a1,514
    5eb8:	f5040513          	addi	a0,s0,-176
    5ebc:	00001097          	auipc	ra,0x1
    5ec0:	820080e7          	jalr	-2016(ra) # 66dc <open>
    5ec4:	892a                	mv	s2,a0
    if(fd < 0){
    5ec6:	0a055663          	bgez	a0,5f72 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5eca:	f5040593          	addi	a1,s0,-176
    5ece:	00003517          	auipc	a0,0x3
    5ed2:	c6a50513          	addi	a0,a0,-918 # 8b38 <malloc+0x203e>
    5ed6:	00001097          	auipc	ra,0x1
    5eda:	b66080e7          	jalr	-1178(ra) # 6a3c <printf>
  while(nfiles >= 0){
    5ede:	0604c363          	bltz	s1,5f44 <fsfull+0x12e>
    name[0] = 'f';
    5ee2:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5ee6:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5eea:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5eee:	4929                	li	s2,10
  while(nfiles >= 0){
    5ef0:	5afd                	li	s5,-1
    name[0] = 'f';
    5ef2:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5ef6:	0344c7bb          	divw	a5,s1,s4
    5efa:	0307879b          	addiw	a5,a5,48
    5efe:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5f02:	0344e7bb          	remw	a5,s1,s4
    5f06:	0337c7bb          	divw	a5,a5,s3
    5f0a:	0307879b          	addiw	a5,a5,48
    5f0e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5f12:	0334e7bb          	remw	a5,s1,s3
    5f16:	0327c7bb          	divw	a5,a5,s2
    5f1a:	0307879b          	addiw	a5,a5,48
    5f1e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5f22:	0324e7bb          	remw	a5,s1,s2
    5f26:	0307879b          	addiw	a5,a5,48
    5f2a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5f2e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5f32:	f5040513          	addi	a0,s0,-176
    5f36:	00000097          	auipc	ra,0x0
    5f3a:	7b6080e7          	jalr	1974(ra) # 66ec <unlink>
    nfiles--;
    5f3e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5f40:	fb5499e3          	bne	s1,s5,5ef2 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5f44:	00003517          	auipc	a0,0x3
    5f48:	c1450513          	addi	a0,a0,-1004 # 8b58 <malloc+0x205e>
    5f4c:	00001097          	auipc	ra,0x1
    5f50:	af0080e7          	jalr	-1296(ra) # 6a3c <printf>
}
    5f54:	70aa                	ld	ra,168(sp)
    5f56:	740a                	ld	s0,160(sp)
    5f58:	64ea                	ld	s1,152(sp)
    5f5a:	694a                	ld	s2,144(sp)
    5f5c:	69aa                	ld	s3,136(sp)
    5f5e:	6a0a                	ld	s4,128(sp)
    5f60:	7ae6                	ld	s5,120(sp)
    5f62:	7b46                	ld	s6,112(sp)
    5f64:	7ba6                	ld	s7,104(sp)
    5f66:	7c06                	ld	s8,96(sp)
    5f68:	6ce6                	ld	s9,88(sp)
    5f6a:	6d46                	ld	s10,80(sp)
    5f6c:	6da6                	ld	s11,72(sp)
    5f6e:	614d                	addi	sp,sp,176
    5f70:	8082                	ret
    int total = 0;
    5f72:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5f74:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5f78:	40000613          	li	a2,1024
    5f7c:	85d2                	mv	a1,s4
    5f7e:	854a                	mv	a0,s2
    5f80:	00000097          	auipc	ra,0x0
    5f84:	73c080e7          	jalr	1852(ra) # 66bc <write>
      if(cc < BSIZE)
    5f88:	00aad563          	bge	s5,a0,5f92 <fsfull+0x17c>
      total += cc;
    5f8c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5f90:	b7e5                	j	5f78 <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5f92:	85ce                	mv	a1,s3
    5f94:	00003517          	auipc	a0,0x3
    5f98:	bb450513          	addi	a0,a0,-1100 # 8b48 <malloc+0x204e>
    5f9c:	00001097          	auipc	ra,0x1
    5fa0:	aa0080e7          	jalr	-1376(ra) # 6a3c <printf>
    close(fd);
    5fa4:	854a                	mv	a0,s2
    5fa6:	00000097          	auipc	ra,0x0
    5faa:	71e080e7          	jalr	1822(ra) # 66c4 <close>
    if(total == 0)
    5fae:	f20988e3          	beqz	s3,5ede <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5fb2:	2485                	addiw	s1,s1,1
    5fb4:	bd4d                	j	5e66 <fsfull+0x50>

0000000000005fb6 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5fb6:	7179                	addi	sp,sp,-48
    5fb8:	f406                	sd	ra,40(sp)
    5fba:	f022                	sd	s0,32(sp)
    5fbc:	ec26                	sd	s1,24(sp)
    5fbe:	e84a                	sd	s2,16(sp)
    5fc0:	1800                	addi	s0,sp,48
    5fc2:	84aa                	mv	s1,a0
    5fc4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5fc6:	00003517          	auipc	a0,0x3
    5fca:	baa50513          	addi	a0,a0,-1110 # 8b70 <malloc+0x2076>
    5fce:	00001097          	auipc	ra,0x1
    5fd2:	a6e080e7          	jalr	-1426(ra) # 6a3c <printf>
  if((pid = fork()) < 0) {
    5fd6:	00000097          	auipc	ra,0x0
    5fda:	6be080e7          	jalr	1726(ra) # 6694 <fork>
    5fde:	02054f63          	bltz	a0,601c <run+0x66>
    printf("runtest: fork error\n");
    exit(1,"");
  }
  if(pid == 0) {
    5fe2:	cd31                	beqz	a0,603e <run+0x88>
    f(s);
    exit(0,"");
  } else {
    wait(&xstatus,0);
    5fe4:	4581                	li	a1,0
    5fe6:	fdc40513          	addi	a0,s0,-36
    5fea:	00000097          	auipc	ra,0x0
    5fee:	6ba080e7          	jalr	1722(ra) # 66a4 <wait>
    if(xstatus != 0) 
    5ff2:	fdc42783          	lw	a5,-36(s0)
    5ff6:	cfb9                	beqz	a5,6054 <run+0x9e>
      printf("FAILED\n");
    5ff8:	00003517          	auipc	a0,0x3
    5ffc:	ba050513          	addi	a0,a0,-1120 # 8b98 <malloc+0x209e>
    6000:	00001097          	auipc	ra,0x1
    6004:	a3c080e7          	jalr	-1476(ra) # 6a3c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    6008:	fdc42503          	lw	a0,-36(s0)
  }
}
    600c:	00153513          	seqz	a0,a0
    6010:	70a2                	ld	ra,40(sp)
    6012:	7402                	ld	s0,32(sp)
    6014:	64e2                	ld	s1,24(sp)
    6016:	6942                	ld	s2,16(sp)
    6018:	6145                	addi	sp,sp,48
    601a:	8082                	ret
    printf("runtest: fork error\n");
    601c:	00003517          	auipc	a0,0x3
    6020:	b6450513          	addi	a0,a0,-1180 # 8b80 <malloc+0x2086>
    6024:	00001097          	auipc	ra,0x1
    6028:	a18080e7          	jalr	-1512(ra) # 6a3c <printf>
    exit(1,"");
    602c:	00002597          	auipc	a1,0x2
    6030:	20c58593          	addi	a1,a1,524 # 8238 <malloc+0x173e>
    6034:	4505                	li	a0,1
    6036:	00000097          	auipc	ra,0x0
    603a:	666080e7          	jalr	1638(ra) # 669c <exit>
    f(s);
    603e:	854a                	mv	a0,s2
    6040:	9482                	jalr	s1
    exit(0,"");
    6042:	00002597          	auipc	a1,0x2
    6046:	1f658593          	addi	a1,a1,502 # 8238 <malloc+0x173e>
    604a:	4501                	li	a0,0
    604c:	00000097          	auipc	ra,0x0
    6050:	650080e7          	jalr	1616(ra) # 669c <exit>
      printf("OK\n");
    6054:	00003517          	auipc	a0,0x3
    6058:	b4c50513          	addi	a0,a0,-1204 # 8ba0 <malloc+0x20a6>
    605c:	00001097          	auipc	ra,0x1
    6060:	9e0080e7          	jalr	-1568(ra) # 6a3c <printf>
    6064:	b755                	j	6008 <run+0x52>

0000000000006066 <runtests>:

int
runtests(struct test *tests, char *justone) {
    6066:	1101                	addi	sp,sp,-32
    6068:	ec06                	sd	ra,24(sp)
    606a:	e822                	sd	s0,16(sp)
    606c:	e426                	sd	s1,8(sp)
    606e:	e04a                	sd	s2,0(sp)
    6070:	1000                	addi	s0,sp,32
    6072:	84aa                	mv	s1,a0
    6074:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    6076:	6508                	ld	a0,8(a0)
    6078:	ed09                	bnez	a0,6092 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    607a:	4501                	li	a0,0
    607c:	a82d                	j	60b6 <runtests+0x50>
      if(!run(t->f, t->s)){
    607e:	648c                	ld	a1,8(s1)
    6080:	6088                	ld	a0,0(s1)
    6082:	00000097          	auipc	ra,0x0
    6086:	f34080e7          	jalr	-204(ra) # 5fb6 <run>
    608a:	cd09                	beqz	a0,60a4 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    608c:	04c1                	addi	s1,s1,16
    608e:	6488                	ld	a0,8(s1)
    6090:	c11d                	beqz	a0,60b6 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6092:	fe0906e3          	beqz	s2,607e <runtests+0x18>
    6096:	85ca                	mv	a1,s2
    6098:	00000097          	auipc	ra,0x0
    609c:	3b2080e7          	jalr	946(ra) # 644a <strcmp>
    60a0:	f575                	bnez	a0,608c <runtests+0x26>
    60a2:	bff1                	j	607e <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    60a4:	00003517          	auipc	a0,0x3
    60a8:	b0450513          	addi	a0,a0,-1276 # 8ba8 <malloc+0x20ae>
    60ac:	00001097          	auipc	ra,0x1
    60b0:	990080e7          	jalr	-1648(ra) # 6a3c <printf>
        return 1;
    60b4:	4505                	li	a0,1
}
    60b6:	60e2                	ld	ra,24(sp)
    60b8:	6442                	ld	s0,16(sp)
    60ba:	64a2                	ld	s1,8(sp)
    60bc:	6902                	ld	s2,0(sp)
    60be:	6105                	addi	sp,sp,32
    60c0:	8082                	ret

00000000000060c2 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    60c2:	7139                	addi	sp,sp,-64
    60c4:	fc06                	sd	ra,56(sp)
    60c6:	f822                	sd	s0,48(sp)
    60c8:	f426                	sd	s1,40(sp)
    60ca:	f04a                	sd	s2,32(sp)
    60cc:	ec4e                	sd	s3,24(sp)
    60ce:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    60d0:	fc840513          	addi	a0,s0,-56
    60d4:	00000097          	auipc	ra,0x0
    60d8:	5d8080e7          	jalr	1496(ra) # 66ac <pipe>
    60dc:	06054b63          	bltz	a0,6152 <countfree+0x90>
    printf("pipe() failed in countfree()\n");
    exit(1,"");
  }
  
  int pid = fork();
    60e0:	00000097          	auipc	ra,0x0
    60e4:	5b4080e7          	jalr	1460(ra) # 6694 <fork>

  if(pid < 0){
    60e8:	08054663          	bltz	a0,6174 <countfree+0xb2>
    printf("fork failed in countfree()\n");
    exit(1,"");
  }

  if(pid == 0){
    60ec:	ed55                	bnez	a0,61a8 <countfree+0xe6>
    close(fds[0]);
    60ee:	fc842503          	lw	a0,-56(s0)
    60f2:	00000097          	auipc	ra,0x0
    60f6:	5d2080e7          	jalr	1490(ra) # 66c4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    60fa:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    60fc:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    60fe:	00001997          	auipc	s3,0x1
    6102:	baa98993          	addi	s3,s3,-1110 # 6ca8 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    6106:	6505                	lui	a0,0x1
    6108:	00000097          	auipc	ra,0x0
    610c:	61c080e7          	jalr	1564(ra) # 6724 <sbrk>
      if(a == 0xffffffffffffffff){
    6110:	09250363          	beq	a0,s2,6196 <countfree+0xd4>
      *(char *)(a + 4096 - 1) = 1;
    6114:	6785                	lui	a5,0x1
    6116:	953e                	add	a0,a0,a5
    6118:	fe950fa3          	sb	s1,-1(a0) # fff <unlinkread+0x187>
      if(write(fds[1], "x", 1) != 1){
    611c:	8626                	mv	a2,s1
    611e:	85ce                	mv	a1,s3
    6120:	fcc42503          	lw	a0,-52(s0)
    6124:	00000097          	auipc	ra,0x0
    6128:	598080e7          	jalr	1432(ra) # 66bc <write>
    612c:	fc950de3          	beq	a0,s1,6106 <countfree+0x44>
        printf("write() failed in countfree()\n");
    6130:	00003517          	auipc	a0,0x3
    6134:	ad050513          	addi	a0,a0,-1328 # 8c00 <malloc+0x2106>
    6138:	00001097          	auipc	ra,0x1
    613c:	904080e7          	jalr	-1788(ra) # 6a3c <printf>
        exit(1,"");
    6140:	00002597          	auipc	a1,0x2
    6144:	0f858593          	addi	a1,a1,248 # 8238 <malloc+0x173e>
    6148:	4505                	li	a0,1
    614a:	00000097          	auipc	ra,0x0
    614e:	552080e7          	jalr	1362(ra) # 669c <exit>
    printf("pipe() failed in countfree()\n");
    6152:	00003517          	auipc	a0,0x3
    6156:	a6e50513          	addi	a0,a0,-1426 # 8bc0 <malloc+0x20c6>
    615a:	00001097          	auipc	ra,0x1
    615e:	8e2080e7          	jalr	-1822(ra) # 6a3c <printf>
    exit(1,"");
    6162:	00002597          	auipc	a1,0x2
    6166:	0d658593          	addi	a1,a1,214 # 8238 <malloc+0x173e>
    616a:	4505                	li	a0,1
    616c:	00000097          	auipc	ra,0x0
    6170:	530080e7          	jalr	1328(ra) # 669c <exit>
    printf("fork failed in countfree()\n");
    6174:	00003517          	auipc	a0,0x3
    6178:	a6c50513          	addi	a0,a0,-1428 # 8be0 <malloc+0x20e6>
    617c:	00001097          	auipc	ra,0x1
    6180:	8c0080e7          	jalr	-1856(ra) # 6a3c <printf>
    exit(1,"");
    6184:	00002597          	auipc	a1,0x2
    6188:	0b458593          	addi	a1,a1,180 # 8238 <malloc+0x173e>
    618c:	4505                	li	a0,1
    618e:	00000097          	auipc	ra,0x0
    6192:	50e080e7          	jalr	1294(ra) # 669c <exit>
      }
    }

    exit(0,"");
    6196:	00002597          	auipc	a1,0x2
    619a:	0a258593          	addi	a1,a1,162 # 8238 <malloc+0x173e>
    619e:	4501                	li	a0,0
    61a0:	00000097          	auipc	ra,0x0
    61a4:	4fc080e7          	jalr	1276(ra) # 669c <exit>
  }

  close(fds[1]);
    61a8:	fcc42503          	lw	a0,-52(s0)
    61ac:	00000097          	auipc	ra,0x0
    61b0:	518080e7          	jalr	1304(ra) # 66c4 <close>

  int n = 0;
    61b4:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    61b6:	4605                	li	a2,1
    61b8:	fc740593          	addi	a1,s0,-57
    61bc:	fc842503          	lw	a0,-56(s0)
    61c0:	00000097          	auipc	ra,0x0
    61c4:	4f4080e7          	jalr	1268(ra) # 66b4 <read>
    if(cc < 0){
    61c8:	00054563          	bltz	a0,61d2 <countfree+0x110>
      printf("read() failed in countfree()\n");
      exit(1,"");
    }
    if(cc == 0)
    61cc:	c505                	beqz	a0,61f4 <countfree+0x132>
      break;
    n += 1;
    61ce:	2485                	addiw	s1,s1,1
  while(1){
    61d0:	b7dd                	j	61b6 <countfree+0xf4>
      printf("read() failed in countfree()\n");
    61d2:	00003517          	auipc	a0,0x3
    61d6:	a4e50513          	addi	a0,a0,-1458 # 8c20 <malloc+0x2126>
    61da:	00001097          	auipc	ra,0x1
    61de:	862080e7          	jalr	-1950(ra) # 6a3c <printf>
      exit(1,"");
    61e2:	00002597          	auipc	a1,0x2
    61e6:	05658593          	addi	a1,a1,86 # 8238 <malloc+0x173e>
    61ea:	4505                	li	a0,1
    61ec:	00000097          	auipc	ra,0x0
    61f0:	4b0080e7          	jalr	1200(ra) # 669c <exit>
  }

  close(fds[0]);
    61f4:	fc842503          	lw	a0,-56(s0)
    61f8:	00000097          	auipc	ra,0x0
    61fc:	4cc080e7          	jalr	1228(ra) # 66c4 <close>
  wait((int*)0,0);
    6200:	4581                	li	a1,0
    6202:	4501                	li	a0,0
    6204:	00000097          	auipc	ra,0x0
    6208:	4a0080e7          	jalr	1184(ra) # 66a4 <wait>
  
  return n;
}
    620c:	8526                	mv	a0,s1
    620e:	70e2                	ld	ra,56(sp)
    6210:	7442                	ld	s0,48(sp)
    6212:	74a2                	ld	s1,40(sp)
    6214:	7902                	ld	s2,32(sp)
    6216:	69e2                	ld	s3,24(sp)
    6218:	6121                	addi	sp,sp,64
    621a:	8082                	ret

000000000000621c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    621c:	711d                	addi	sp,sp,-96
    621e:	ec86                	sd	ra,88(sp)
    6220:	e8a2                	sd	s0,80(sp)
    6222:	e4a6                	sd	s1,72(sp)
    6224:	e0ca                	sd	s2,64(sp)
    6226:	fc4e                	sd	s3,56(sp)
    6228:	f852                	sd	s4,48(sp)
    622a:	f456                	sd	s5,40(sp)
    622c:	f05a                	sd	s6,32(sp)
    622e:	ec5e                	sd	s7,24(sp)
    6230:	e862                	sd	s8,16(sp)
    6232:	e466                	sd	s9,8(sp)
    6234:	e06a                	sd	s10,0(sp)
    6236:	1080                	addi	s0,sp,96
    6238:	8a2a                	mv	s4,a0
    623a:	89ae                	mv	s3,a1
    623c:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    623e:	00003b97          	auipc	s7,0x3
    6242:	a02b8b93          	addi	s7,s7,-1534 # 8c40 <malloc+0x2146>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    6246:	00004b17          	auipc	s6,0x4
    624a:	dcab0b13          	addi	s6,s6,-566 # a010 <quicktests>
      if(continuous != 2) {
    624e:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    6250:	00003c97          	auipc	s9,0x3
    6254:	a28c8c93          	addi	s9,s9,-1496 # 8c78 <malloc+0x217e>
      if (runtests(slowtests, justone)) {
    6258:	00004c17          	auipc	s8,0x4
    625c:	188c0c13          	addi	s8,s8,392 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    6260:	00003d17          	auipc	s10,0x3
    6264:	9f8d0d13          	addi	s10,s10,-1544 # 8c58 <malloc+0x215e>
    6268:	a839                	j	6286 <drivetests+0x6a>
    626a:	856a                	mv	a0,s10
    626c:	00000097          	auipc	ra,0x0
    6270:	7d0080e7          	jalr	2000(ra) # 6a3c <printf>
    6274:	a081                	j	62b4 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    6276:	00000097          	auipc	ra,0x0
    627a:	e4c080e7          	jalr	-436(ra) # 60c2 <countfree>
    627e:	06954263          	blt	a0,s1,62e2 <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    6282:	06098f63          	beqz	s3,6300 <drivetests+0xe4>
    printf("usertests starting\n");
    6286:	855e                	mv	a0,s7
    6288:	00000097          	auipc	ra,0x0
    628c:	7b4080e7          	jalr	1972(ra) # 6a3c <printf>
    int free0 = countfree();
    6290:	00000097          	auipc	ra,0x0
    6294:	e32080e7          	jalr	-462(ra) # 60c2 <countfree>
    6298:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    629a:	85ca                	mv	a1,s2
    629c:	855a                	mv	a0,s6
    629e:	00000097          	auipc	ra,0x0
    62a2:	dc8080e7          	jalr	-568(ra) # 6066 <runtests>
    62a6:	c119                	beqz	a0,62ac <drivetests+0x90>
      if(continuous != 2) {
    62a8:	05599863          	bne	s3,s5,62f8 <drivetests+0xdc>
    if(!quick) {
    62ac:	fc0a15e3          	bnez	s4,6276 <drivetests+0x5a>
      if (justone == 0)
    62b0:	fa090de3          	beqz	s2,626a <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    62b4:	85ca                	mv	a1,s2
    62b6:	8562                	mv	a0,s8
    62b8:	00000097          	auipc	ra,0x0
    62bc:	dae080e7          	jalr	-594(ra) # 6066 <runtests>
    62c0:	d95d                	beqz	a0,6276 <drivetests+0x5a>
        if(continuous != 2) {
    62c2:	03599d63          	bne	s3,s5,62fc <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    62c6:	00000097          	auipc	ra,0x0
    62ca:	dfc080e7          	jalr	-516(ra) # 60c2 <countfree>
    62ce:	fa955ae3          	bge	a0,s1,6282 <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62d2:	8626                	mv	a2,s1
    62d4:	85aa                	mv	a1,a0
    62d6:	8566                	mv	a0,s9
    62d8:	00000097          	auipc	ra,0x0
    62dc:	764080e7          	jalr	1892(ra) # 6a3c <printf>
      if(continuous != 2) {
    62e0:	b75d                	j	6286 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62e2:	8626                	mv	a2,s1
    62e4:	85aa                	mv	a1,a0
    62e6:	8566                	mv	a0,s9
    62e8:	00000097          	auipc	ra,0x0
    62ec:	754080e7          	jalr	1876(ra) # 6a3c <printf>
      if(continuous != 2) {
    62f0:	f9598be3          	beq	s3,s5,6286 <drivetests+0x6a>
        return 1;
    62f4:	4505                	li	a0,1
    62f6:	a031                	j	6302 <drivetests+0xe6>
        return 1;
    62f8:	4505                	li	a0,1
    62fa:	a021                	j	6302 <drivetests+0xe6>
          return 1;
    62fc:	4505                	li	a0,1
    62fe:	a011                	j	6302 <drivetests+0xe6>
  return 0;
    6300:	854e                	mv	a0,s3
}
    6302:	60e6                	ld	ra,88(sp)
    6304:	6446                	ld	s0,80(sp)
    6306:	64a6                	ld	s1,72(sp)
    6308:	6906                	ld	s2,64(sp)
    630a:	79e2                	ld	s3,56(sp)
    630c:	7a42                	ld	s4,48(sp)
    630e:	7aa2                	ld	s5,40(sp)
    6310:	7b02                	ld	s6,32(sp)
    6312:	6be2                	ld	s7,24(sp)
    6314:	6c42                	ld	s8,16(sp)
    6316:	6ca2                	ld	s9,8(sp)
    6318:	6d02                	ld	s10,0(sp)
    631a:	6125                	addi	sp,sp,96
    631c:	8082                	ret

000000000000631e <main>:

int
main(int argc, char *argv[])
{
    631e:	1101                	addi	sp,sp,-32
    6320:	ec06                	sd	ra,24(sp)
    6322:	e822                	sd	s0,16(sp)
    6324:	e426                	sd	s1,8(sp)
    6326:	e04a                	sd	s2,0(sp)
    6328:	1000                	addi	s0,sp,32
    632a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    632c:	4789                	li	a5,2
    632e:	02f50763          	beq	a0,a5,635c <main+0x3e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    6332:	4785                	li	a5,1
    6334:	08a7c163          	blt	a5,a0,63b6 <main+0x98>
  char *justone = 0;
    6338:	4601                	li	a2,0
  int quick = 0;
    633a:	4501                	li	a0,0
  int continuous = 0;
    633c:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1,"");
  }
  if (drivetests(quick, continuous, justone)) {
    633e:	85a6                	mv	a1,s1
    6340:	00000097          	auipc	ra,0x0
    6344:	edc080e7          	jalr	-292(ra) # 621c <drivetests>
    6348:	c14d                	beqz	a0,63ea <main+0xcc>
    exit(1,"");
    634a:	00002597          	auipc	a1,0x2
    634e:	eee58593          	addi	a1,a1,-274 # 8238 <malloc+0x173e>
    6352:	4505                	li	a0,1
    6354:	00000097          	auipc	ra,0x0
    6358:	348080e7          	jalr	840(ra) # 669c <exit>
    635c:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    635e:	00003597          	auipc	a1,0x3
    6362:	94a58593          	addi	a1,a1,-1718 # 8ca8 <malloc+0x21ae>
    6366:	00893503          	ld	a0,8(s2)
    636a:	00000097          	auipc	ra,0x0
    636e:	0e0080e7          	jalr	224(ra) # 644a <strcmp>
    6372:	c13d                	beqz	a0,63d8 <main+0xba>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    6374:	00003597          	auipc	a1,0x3
    6378:	98c58593          	addi	a1,a1,-1652 # 8d00 <malloc+0x2206>
    637c:	00893503          	ld	a0,8(s2)
    6380:	00000097          	auipc	ra,0x0
    6384:	0ca080e7          	jalr	202(ra) # 644a <strcmp>
    6388:	cd31                	beqz	a0,63e4 <main+0xc6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    638a:	00003597          	auipc	a1,0x3
    638e:	96e58593          	addi	a1,a1,-1682 # 8cf8 <malloc+0x21fe>
    6392:	00893503          	ld	a0,8(s2)
    6396:	00000097          	auipc	ra,0x0
    639a:	0b4080e7          	jalr	180(ra) # 644a <strcmp>
    639e:	c129                	beqz	a0,63e0 <main+0xc2>
  } else if(argc == 2 && argv[1][0] != '-'){
    63a0:	00893603          	ld	a2,8(s2)
    63a4:	00064703          	lbu	a4,0(a2) # 3000 <sbrkmuch+0x54>
    63a8:	02d00793          	li	a5,45
    63ac:	00f70563          	beq	a4,a5,63b6 <main+0x98>
  int quick = 0;
    63b0:	4501                	li	a0,0
  int continuous = 0;
    63b2:	4481                	li	s1,0
    63b4:	b769                	j	633e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    63b6:	00003517          	auipc	a0,0x3
    63ba:	8fa50513          	addi	a0,a0,-1798 # 8cb0 <malloc+0x21b6>
    63be:	00000097          	auipc	ra,0x0
    63c2:	67e080e7          	jalr	1662(ra) # 6a3c <printf>
    exit(1,"");
    63c6:	00002597          	auipc	a1,0x2
    63ca:	e7258593          	addi	a1,a1,-398 # 8238 <malloc+0x173e>
    63ce:	4505                	li	a0,1
    63d0:	00000097          	auipc	ra,0x0
    63d4:	2cc080e7          	jalr	716(ra) # 669c <exit>
  int continuous = 0;
    63d8:	84aa                	mv	s1,a0
  char *justone = 0;
    63da:	4601                	li	a2,0
    quick = 1;
    63dc:	4505                	li	a0,1
    63de:	b785                	j	633e <main+0x20>
  char *justone = 0;
    63e0:	4601                	li	a2,0
    63e2:	bfb1                	j	633e <main+0x20>
    63e4:	4601                	li	a2,0
    continuous = 1;
    63e6:	4485                	li	s1,1
    63e8:	bf99                	j	633e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    63ea:	00003517          	auipc	a0,0x3
    63ee:	8f650513          	addi	a0,a0,-1802 # 8ce0 <malloc+0x21e6>
    63f2:	00000097          	auipc	ra,0x0
    63f6:	64a080e7          	jalr	1610(ra) # 6a3c <printf>
  exit(0,"");
    63fa:	00002597          	auipc	a1,0x2
    63fe:	e3e58593          	addi	a1,a1,-450 # 8238 <malloc+0x173e>
    6402:	4501                	li	a0,0
    6404:	00000097          	auipc	ra,0x0
    6408:	298080e7          	jalr	664(ra) # 669c <exit>

000000000000640c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    640c:	1141                	addi	sp,sp,-16
    640e:	e406                	sd	ra,8(sp)
    6410:	e022                	sd	s0,0(sp)
    6412:	0800                	addi	s0,sp,16
  extern int main();
  main();
    6414:	00000097          	auipc	ra,0x0
    6418:	f0a080e7          	jalr	-246(ra) # 631e <main>
  exit(0,"");
    641c:	00002597          	auipc	a1,0x2
    6420:	e1c58593          	addi	a1,a1,-484 # 8238 <malloc+0x173e>
    6424:	4501                	li	a0,0
    6426:	00000097          	auipc	ra,0x0
    642a:	276080e7          	jalr	630(ra) # 669c <exit>

000000000000642e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    642e:	1141                	addi	sp,sp,-16
    6430:	e422                	sd	s0,8(sp)
    6432:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    6434:	87aa                	mv	a5,a0
    6436:	0585                	addi	a1,a1,1
    6438:	0785                	addi	a5,a5,1
    643a:	fff5c703          	lbu	a4,-1(a1)
    643e:	fee78fa3          	sb	a4,-1(a5) # fff <unlinkread+0x187>
    6442:	fb75                	bnez	a4,6436 <strcpy+0x8>
    ;
  return os;
}
    6444:	6422                	ld	s0,8(sp)
    6446:	0141                	addi	sp,sp,16
    6448:	8082                	ret

000000000000644a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    644a:	1141                	addi	sp,sp,-16
    644c:	e422                	sd	s0,8(sp)
    644e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    6450:	00054783          	lbu	a5,0(a0)
    6454:	cb91                	beqz	a5,6468 <strcmp+0x1e>
    6456:	0005c703          	lbu	a4,0(a1)
    645a:	00f71763          	bne	a4,a5,6468 <strcmp+0x1e>
    p++, q++;
    645e:	0505                	addi	a0,a0,1
    6460:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    6462:	00054783          	lbu	a5,0(a0)
    6466:	fbe5                	bnez	a5,6456 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    6468:	0005c503          	lbu	a0,0(a1)
}
    646c:	40a7853b          	subw	a0,a5,a0
    6470:	6422                	ld	s0,8(sp)
    6472:	0141                	addi	sp,sp,16
    6474:	8082                	ret

0000000000006476 <strlen>:

uint
strlen(const char *s)
{
    6476:	1141                	addi	sp,sp,-16
    6478:	e422                	sd	s0,8(sp)
    647a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    647c:	00054783          	lbu	a5,0(a0)
    6480:	cf91                	beqz	a5,649c <strlen+0x26>
    6482:	0505                	addi	a0,a0,1
    6484:	87aa                	mv	a5,a0
    6486:	4685                	li	a3,1
    6488:	9e89                	subw	a3,a3,a0
    648a:	00f6853b          	addw	a0,a3,a5
    648e:	0785                	addi	a5,a5,1
    6490:	fff7c703          	lbu	a4,-1(a5)
    6494:	fb7d                	bnez	a4,648a <strlen+0x14>
    ;
  return n;
}
    6496:	6422                	ld	s0,8(sp)
    6498:	0141                	addi	sp,sp,16
    649a:	8082                	ret
  for(n = 0; s[n]; n++)
    649c:	4501                	li	a0,0
    649e:	bfe5                	j	6496 <strlen+0x20>

00000000000064a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    64a0:	1141                	addi	sp,sp,-16
    64a2:	e422                	sd	s0,8(sp)
    64a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    64a6:	ca19                	beqz	a2,64bc <memset+0x1c>
    64a8:	87aa                	mv	a5,a0
    64aa:	1602                	slli	a2,a2,0x20
    64ac:	9201                	srli	a2,a2,0x20
    64ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    64b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    64b6:	0785                	addi	a5,a5,1
    64b8:	fee79de3          	bne	a5,a4,64b2 <memset+0x12>
  }
  return dst;
}
    64bc:	6422                	ld	s0,8(sp)
    64be:	0141                	addi	sp,sp,16
    64c0:	8082                	ret

00000000000064c2 <strchr>:

char*
strchr(const char *s, char c)
{
    64c2:	1141                	addi	sp,sp,-16
    64c4:	e422                	sd	s0,8(sp)
    64c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    64c8:	00054783          	lbu	a5,0(a0)
    64cc:	cb99                	beqz	a5,64e2 <strchr+0x20>
    if(*s == c)
    64ce:	00f58763          	beq	a1,a5,64dc <strchr+0x1a>
  for(; *s; s++)
    64d2:	0505                	addi	a0,a0,1
    64d4:	00054783          	lbu	a5,0(a0)
    64d8:	fbfd                	bnez	a5,64ce <strchr+0xc>
      return (char*)s;
  return 0;
    64da:	4501                	li	a0,0
}
    64dc:	6422                	ld	s0,8(sp)
    64de:	0141                	addi	sp,sp,16
    64e0:	8082                	ret
  return 0;
    64e2:	4501                	li	a0,0
    64e4:	bfe5                	j	64dc <strchr+0x1a>

00000000000064e6 <gets>:

char*
gets(char *buf, int max)
{
    64e6:	711d                	addi	sp,sp,-96
    64e8:	ec86                	sd	ra,88(sp)
    64ea:	e8a2                	sd	s0,80(sp)
    64ec:	e4a6                	sd	s1,72(sp)
    64ee:	e0ca                	sd	s2,64(sp)
    64f0:	fc4e                	sd	s3,56(sp)
    64f2:	f852                	sd	s4,48(sp)
    64f4:	f456                	sd	s5,40(sp)
    64f6:	f05a                	sd	s6,32(sp)
    64f8:	ec5e                	sd	s7,24(sp)
    64fa:	1080                	addi	s0,sp,96
    64fc:	8baa                	mv	s7,a0
    64fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    6500:	892a                	mv	s2,a0
    6502:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    6504:	4aa9                	li	s5,10
    6506:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    6508:	89a6                	mv	s3,s1
    650a:	2485                	addiw	s1,s1,1
    650c:	0344d863          	bge	s1,s4,653c <gets+0x56>
    cc = read(0, &c, 1);
    6510:	4605                	li	a2,1
    6512:	faf40593          	addi	a1,s0,-81
    6516:	4501                	li	a0,0
    6518:	00000097          	auipc	ra,0x0
    651c:	19c080e7          	jalr	412(ra) # 66b4 <read>
    if(cc < 1)
    6520:	00a05e63          	blez	a0,653c <gets+0x56>
    buf[i++] = c;
    6524:	faf44783          	lbu	a5,-81(s0)
    6528:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    652c:	01578763          	beq	a5,s5,653a <gets+0x54>
    6530:	0905                	addi	s2,s2,1
    6532:	fd679be3          	bne	a5,s6,6508 <gets+0x22>
  for(i=0; i+1 < max; ){
    6536:	89a6                	mv	s3,s1
    6538:	a011                	j	653c <gets+0x56>
    653a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    653c:	99de                	add	s3,s3,s7
    653e:	00098023          	sb	zero,0(s3)
  return buf;
}
    6542:	855e                	mv	a0,s7
    6544:	60e6                	ld	ra,88(sp)
    6546:	6446                	ld	s0,80(sp)
    6548:	64a6                	ld	s1,72(sp)
    654a:	6906                	ld	s2,64(sp)
    654c:	79e2                	ld	s3,56(sp)
    654e:	7a42                	ld	s4,48(sp)
    6550:	7aa2                	ld	s5,40(sp)
    6552:	7b02                	ld	s6,32(sp)
    6554:	6be2                	ld	s7,24(sp)
    6556:	6125                	addi	sp,sp,96
    6558:	8082                	ret

000000000000655a <stat>:

int
stat(const char *n, struct stat *st)
{
    655a:	1101                	addi	sp,sp,-32
    655c:	ec06                	sd	ra,24(sp)
    655e:	e822                	sd	s0,16(sp)
    6560:	e426                	sd	s1,8(sp)
    6562:	e04a                	sd	s2,0(sp)
    6564:	1000                	addi	s0,sp,32
    6566:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    6568:	4581                	li	a1,0
    656a:	00000097          	auipc	ra,0x0
    656e:	172080e7          	jalr	370(ra) # 66dc <open>
  if(fd < 0)
    6572:	02054563          	bltz	a0,659c <stat+0x42>
    6576:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    6578:	85ca                	mv	a1,s2
    657a:	00000097          	auipc	ra,0x0
    657e:	17a080e7          	jalr	378(ra) # 66f4 <fstat>
    6582:	892a                	mv	s2,a0
  close(fd);
    6584:	8526                	mv	a0,s1
    6586:	00000097          	auipc	ra,0x0
    658a:	13e080e7          	jalr	318(ra) # 66c4 <close>
  return r;
}
    658e:	854a                	mv	a0,s2
    6590:	60e2                	ld	ra,24(sp)
    6592:	6442                	ld	s0,16(sp)
    6594:	64a2                	ld	s1,8(sp)
    6596:	6902                	ld	s2,0(sp)
    6598:	6105                	addi	sp,sp,32
    659a:	8082                	ret
    return -1;
    659c:	597d                	li	s2,-1
    659e:	bfc5                	j	658e <stat+0x34>

00000000000065a0 <atoi>:

int
atoi(const char *s)
{
    65a0:	1141                	addi	sp,sp,-16
    65a2:	e422                	sd	s0,8(sp)
    65a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    65a6:	00054603          	lbu	a2,0(a0)
    65aa:	fd06079b          	addiw	a5,a2,-48
    65ae:	0ff7f793          	andi	a5,a5,255
    65b2:	4725                	li	a4,9
    65b4:	02f76963          	bltu	a4,a5,65e6 <atoi+0x46>
    65b8:	86aa                	mv	a3,a0
  n = 0;
    65ba:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    65bc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    65be:	0685                	addi	a3,a3,1
    65c0:	0025179b          	slliw	a5,a0,0x2
    65c4:	9fa9                	addw	a5,a5,a0
    65c6:	0017979b          	slliw	a5,a5,0x1
    65ca:	9fb1                	addw	a5,a5,a2
    65cc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    65d0:	0006c603          	lbu	a2,0(a3)
    65d4:	fd06071b          	addiw	a4,a2,-48
    65d8:	0ff77713          	andi	a4,a4,255
    65dc:	fee5f1e3          	bgeu	a1,a4,65be <atoi+0x1e>
  return n;
}
    65e0:	6422                	ld	s0,8(sp)
    65e2:	0141                	addi	sp,sp,16
    65e4:	8082                	ret
  n = 0;
    65e6:	4501                	li	a0,0
    65e8:	bfe5                	j	65e0 <atoi+0x40>

00000000000065ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    65ea:	1141                	addi	sp,sp,-16
    65ec:	e422                	sd	s0,8(sp)
    65ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    65f0:	02b57463          	bgeu	a0,a1,6618 <memmove+0x2e>
    while(n-- > 0)
    65f4:	00c05f63          	blez	a2,6612 <memmove+0x28>
    65f8:	1602                	slli	a2,a2,0x20
    65fa:	9201                	srli	a2,a2,0x20
    65fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    6600:	872a                	mv	a4,a0
      *dst++ = *src++;
    6602:	0585                	addi	a1,a1,1
    6604:	0705                	addi	a4,a4,1
    6606:	fff5c683          	lbu	a3,-1(a1)
    660a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    660e:	fee79ae3          	bne	a5,a4,6602 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    6612:	6422                	ld	s0,8(sp)
    6614:	0141                	addi	sp,sp,16
    6616:	8082                	ret
    dst += n;
    6618:	00c50733          	add	a4,a0,a2
    src += n;
    661c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    661e:	fec05ae3          	blez	a2,6612 <memmove+0x28>
    6622:	fff6079b          	addiw	a5,a2,-1
    6626:	1782                	slli	a5,a5,0x20
    6628:	9381                	srli	a5,a5,0x20
    662a:	fff7c793          	not	a5,a5
    662e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    6630:	15fd                	addi	a1,a1,-1
    6632:	177d                	addi	a4,a4,-1
    6634:	0005c683          	lbu	a3,0(a1)
    6638:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    663c:	fee79ae3          	bne	a5,a4,6630 <memmove+0x46>
    6640:	bfc9                	j	6612 <memmove+0x28>

0000000000006642 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    6642:	1141                	addi	sp,sp,-16
    6644:	e422                	sd	s0,8(sp)
    6646:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    6648:	ca05                	beqz	a2,6678 <memcmp+0x36>
    664a:	fff6069b          	addiw	a3,a2,-1
    664e:	1682                	slli	a3,a3,0x20
    6650:	9281                	srli	a3,a3,0x20
    6652:	0685                	addi	a3,a3,1
    6654:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    6656:	00054783          	lbu	a5,0(a0)
    665a:	0005c703          	lbu	a4,0(a1)
    665e:	00e79863          	bne	a5,a4,666e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    6662:	0505                	addi	a0,a0,1
    p2++;
    6664:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    6666:	fed518e3          	bne	a0,a3,6656 <memcmp+0x14>
  }
  return 0;
    666a:	4501                	li	a0,0
    666c:	a019                	j	6672 <memcmp+0x30>
      return *p1 - *p2;
    666e:	40e7853b          	subw	a0,a5,a4
}
    6672:	6422                	ld	s0,8(sp)
    6674:	0141                	addi	sp,sp,16
    6676:	8082                	ret
  return 0;
    6678:	4501                	li	a0,0
    667a:	bfe5                	j	6672 <memcmp+0x30>

000000000000667c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    667c:	1141                	addi	sp,sp,-16
    667e:	e406                	sd	ra,8(sp)
    6680:	e022                	sd	s0,0(sp)
    6682:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    6684:	00000097          	auipc	ra,0x0
    6688:	f66080e7          	jalr	-154(ra) # 65ea <memmove>
}
    668c:	60a2                	ld	ra,8(sp)
    668e:	6402                	ld	s0,0(sp)
    6690:	0141                	addi	sp,sp,16
    6692:	8082                	ret

0000000000006694 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    6694:	4885                	li	a7,1
 ecall
    6696:	00000073          	ecall
 ret
    669a:	8082                	ret

000000000000669c <exit>:
.global exit
exit:
 li a7, SYS_exit
    669c:	4889                	li	a7,2
 ecall
    669e:	00000073          	ecall
 ret
    66a2:	8082                	ret

00000000000066a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
    66a4:	488d                	li	a7,3
 ecall
    66a6:	00000073          	ecall
 ret
    66aa:	8082                	ret

00000000000066ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    66ac:	4891                	li	a7,4
 ecall
    66ae:	00000073          	ecall
 ret
    66b2:	8082                	ret

00000000000066b4 <read>:
.global read
read:
 li a7, SYS_read
    66b4:	4895                	li	a7,5
 ecall
    66b6:	00000073          	ecall
 ret
    66ba:	8082                	ret

00000000000066bc <write>:
.global write
write:
 li a7, SYS_write
    66bc:	48c1                	li	a7,16
 ecall
    66be:	00000073          	ecall
 ret
    66c2:	8082                	ret

00000000000066c4 <close>:
.global close
close:
 li a7, SYS_close
    66c4:	48d5                	li	a7,21
 ecall
    66c6:	00000073          	ecall
 ret
    66ca:	8082                	ret

00000000000066cc <kill>:
.global kill
kill:
 li a7, SYS_kill
    66cc:	4899                	li	a7,6
 ecall
    66ce:	00000073          	ecall
 ret
    66d2:	8082                	ret

00000000000066d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    66d4:	489d                	li	a7,7
 ecall
    66d6:	00000073          	ecall
 ret
    66da:	8082                	ret

00000000000066dc <open>:
.global open
open:
 li a7, SYS_open
    66dc:	48bd                	li	a7,15
 ecall
    66de:	00000073          	ecall
 ret
    66e2:	8082                	ret

00000000000066e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    66e4:	48c5                	li	a7,17
 ecall
    66e6:	00000073          	ecall
 ret
    66ea:	8082                	ret

00000000000066ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    66ec:	48c9                	li	a7,18
 ecall
    66ee:	00000073          	ecall
 ret
    66f2:	8082                	ret

00000000000066f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    66f4:	48a1                	li	a7,8
 ecall
    66f6:	00000073          	ecall
 ret
    66fa:	8082                	ret

00000000000066fc <link>:
.global link
link:
 li a7, SYS_link
    66fc:	48cd                	li	a7,19
 ecall
    66fe:	00000073          	ecall
 ret
    6702:	8082                	ret

0000000000006704 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    6704:	48d1                	li	a7,20
 ecall
    6706:	00000073          	ecall
 ret
    670a:	8082                	ret

000000000000670c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    670c:	48a5                	li	a7,9
 ecall
    670e:	00000073          	ecall
 ret
    6712:	8082                	ret

0000000000006714 <dup>:
.global dup
dup:
 li a7, SYS_dup
    6714:	48a9                	li	a7,10
 ecall
    6716:	00000073          	ecall
 ret
    671a:	8082                	ret

000000000000671c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    671c:	48ad                	li	a7,11
 ecall
    671e:	00000073          	ecall
 ret
    6722:	8082                	ret

0000000000006724 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    6724:	48b1                	li	a7,12
 ecall
    6726:	00000073          	ecall
 ret
    672a:	8082                	ret

000000000000672c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    672c:	48b5                	li	a7,13
 ecall
    672e:	00000073          	ecall
 ret
    6732:	8082                	ret

0000000000006734 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    6734:	48b9                	li	a7,14
 ecall
    6736:	00000073          	ecall
 ret
    673a:	8082                	ret

000000000000673c <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
    673c:	48d9                	li	a7,22
 ecall
    673e:	00000073          	ecall
 ret
    6742:	8082                	ret

0000000000006744 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
    6744:	48dd                	li	a7,23
 ecall
    6746:	00000073          	ecall
 ret
    674a:	8082                	ret

000000000000674c <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
    674c:	48e1                	li	a7,24
 ecall
    674e:	00000073          	ecall
 ret
    6752:	8082                	ret

0000000000006754 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
    6754:	48e5                	li	a7,25
 ecall
    6756:	00000073          	ecall
 ret
    675a:	8082                	ret

000000000000675c <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
    675c:	48e9                	li	a7,26
 ecall
    675e:	00000073          	ecall
 ret
    6762:	8082                	ret

0000000000006764 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    6764:	1101                	addi	sp,sp,-32
    6766:	ec06                	sd	ra,24(sp)
    6768:	e822                	sd	s0,16(sp)
    676a:	1000                	addi	s0,sp,32
    676c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6770:	4605                	li	a2,1
    6772:	fef40593          	addi	a1,s0,-17
    6776:	00000097          	auipc	ra,0x0
    677a:	f46080e7          	jalr	-186(ra) # 66bc <write>
}
    677e:	60e2                	ld	ra,24(sp)
    6780:	6442                	ld	s0,16(sp)
    6782:	6105                	addi	sp,sp,32
    6784:	8082                	ret

0000000000006786 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    6786:	7139                	addi	sp,sp,-64
    6788:	fc06                	sd	ra,56(sp)
    678a:	f822                	sd	s0,48(sp)
    678c:	f426                	sd	s1,40(sp)
    678e:	f04a                	sd	s2,32(sp)
    6790:	ec4e                	sd	s3,24(sp)
    6792:	0080                	addi	s0,sp,64
    6794:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    6796:	c299                	beqz	a3,679c <printint+0x16>
    6798:	0805c863          	bltz	a1,6828 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    679c:	2581                	sext.w	a1,a1
  neg = 0;
    679e:	4881                	li	a7,0
    67a0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    67a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    67a6:	2601                	sext.w	a2,a2
    67a8:	00003517          	auipc	a0,0x3
    67ac:	8c850513          	addi	a0,a0,-1848 # 9070 <digits>
    67b0:	883a                	mv	a6,a4
    67b2:	2705                	addiw	a4,a4,1
    67b4:	02c5f7bb          	remuw	a5,a1,a2
    67b8:	1782                	slli	a5,a5,0x20
    67ba:	9381                	srli	a5,a5,0x20
    67bc:	97aa                	add	a5,a5,a0
    67be:	0007c783          	lbu	a5,0(a5)
    67c2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    67c6:	0005879b          	sext.w	a5,a1
    67ca:	02c5d5bb          	divuw	a1,a1,a2
    67ce:	0685                	addi	a3,a3,1
    67d0:	fec7f0e3          	bgeu	a5,a2,67b0 <printint+0x2a>
  if(neg)
    67d4:	00088b63          	beqz	a7,67ea <printint+0x64>
    buf[i++] = '-';
    67d8:	fd040793          	addi	a5,s0,-48
    67dc:	973e                	add	a4,a4,a5
    67de:	02d00793          	li	a5,45
    67e2:	fef70823          	sb	a5,-16(a4)
    67e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    67ea:	02e05863          	blez	a4,681a <printint+0x94>
    67ee:	fc040793          	addi	a5,s0,-64
    67f2:	00e78933          	add	s2,a5,a4
    67f6:	fff78993          	addi	s3,a5,-1
    67fa:	99ba                	add	s3,s3,a4
    67fc:	377d                	addiw	a4,a4,-1
    67fe:	1702                	slli	a4,a4,0x20
    6800:	9301                	srli	a4,a4,0x20
    6802:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    6806:	fff94583          	lbu	a1,-1(s2)
    680a:	8526                	mv	a0,s1
    680c:	00000097          	auipc	ra,0x0
    6810:	f58080e7          	jalr	-168(ra) # 6764 <putc>
  while(--i >= 0)
    6814:	197d                	addi	s2,s2,-1
    6816:	ff3918e3          	bne	s2,s3,6806 <printint+0x80>
}
    681a:	70e2                	ld	ra,56(sp)
    681c:	7442                	ld	s0,48(sp)
    681e:	74a2                	ld	s1,40(sp)
    6820:	7902                	ld	s2,32(sp)
    6822:	69e2                	ld	s3,24(sp)
    6824:	6121                	addi	sp,sp,64
    6826:	8082                	ret
    x = -xx;
    6828:	40b005bb          	negw	a1,a1
    neg = 1;
    682c:	4885                	li	a7,1
    x = -xx;
    682e:	bf8d                	j	67a0 <printint+0x1a>

0000000000006830 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    6830:	7119                	addi	sp,sp,-128
    6832:	fc86                	sd	ra,120(sp)
    6834:	f8a2                	sd	s0,112(sp)
    6836:	f4a6                	sd	s1,104(sp)
    6838:	f0ca                	sd	s2,96(sp)
    683a:	ecce                	sd	s3,88(sp)
    683c:	e8d2                	sd	s4,80(sp)
    683e:	e4d6                	sd	s5,72(sp)
    6840:	e0da                	sd	s6,64(sp)
    6842:	fc5e                	sd	s7,56(sp)
    6844:	f862                	sd	s8,48(sp)
    6846:	f466                	sd	s9,40(sp)
    6848:	f06a                	sd	s10,32(sp)
    684a:	ec6e                	sd	s11,24(sp)
    684c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    684e:	0005c903          	lbu	s2,0(a1)
    6852:	18090f63          	beqz	s2,69f0 <vprintf+0x1c0>
    6856:	8aaa                	mv	s5,a0
    6858:	8b32                	mv	s6,a2
    685a:	00158493          	addi	s1,a1,1
  state = 0;
    685e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    6860:	02500a13          	li	s4,37
      if(c == 'd'){
    6864:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    6868:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    686c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    6870:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6874:	00002b97          	auipc	s7,0x2
    6878:	7fcb8b93          	addi	s7,s7,2044 # 9070 <digits>
    687c:	a839                	j	689a <vprintf+0x6a>
        putc(fd, c);
    687e:	85ca                	mv	a1,s2
    6880:	8556                	mv	a0,s5
    6882:	00000097          	auipc	ra,0x0
    6886:	ee2080e7          	jalr	-286(ra) # 6764 <putc>
    688a:	a019                	j	6890 <vprintf+0x60>
    } else if(state == '%'){
    688c:	01498f63          	beq	s3,s4,68aa <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    6890:	0485                	addi	s1,s1,1
    6892:	fff4c903          	lbu	s2,-1(s1)
    6896:	14090d63          	beqz	s2,69f0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    689a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    689e:	fe0997e3          	bnez	s3,688c <vprintf+0x5c>
      if(c == '%'){
    68a2:	fd479ee3          	bne	a5,s4,687e <vprintf+0x4e>
        state = '%';
    68a6:	89be                	mv	s3,a5
    68a8:	b7e5                	j	6890 <vprintf+0x60>
      if(c == 'd'){
    68aa:	05878063          	beq	a5,s8,68ea <vprintf+0xba>
      } else if(c == 'l') {
    68ae:	05978c63          	beq	a5,s9,6906 <vprintf+0xd6>
      } else if(c == 'x') {
    68b2:	07a78863          	beq	a5,s10,6922 <vprintf+0xf2>
      } else if(c == 'p') {
    68b6:	09b78463          	beq	a5,s11,693e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    68ba:	07300713          	li	a4,115
    68be:	0ce78663          	beq	a5,a4,698a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    68c2:	06300713          	li	a4,99
    68c6:	0ee78e63          	beq	a5,a4,69c2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    68ca:	11478863          	beq	a5,s4,69da <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    68ce:	85d2                	mv	a1,s4
    68d0:	8556                	mv	a0,s5
    68d2:	00000097          	auipc	ra,0x0
    68d6:	e92080e7          	jalr	-366(ra) # 6764 <putc>
        putc(fd, c);
    68da:	85ca                	mv	a1,s2
    68dc:	8556                	mv	a0,s5
    68de:	00000097          	auipc	ra,0x0
    68e2:	e86080e7          	jalr	-378(ra) # 6764 <putc>
      }
      state = 0;
    68e6:	4981                	li	s3,0
    68e8:	b765                	j	6890 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    68ea:	008b0913          	addi	s2,s6,8
    68ee:	4685                	li	a3,1
    68f0:	4629                	li	a2,10
    68f2:	000b2583          	lw	a1,0(s6)
    68f6:	8556                	mv	a0,s5
    68f8:	00000097          	auipc	ra,0x0
    68fc:	e8e080e7          	jalr	-370(ra) # 6786 <printint>
    6900:	8b4a                	mv	s6,s2
      state = 0;
    6902:	4981                	li	s3,0
    6904:	b771                	j	6890 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    6906:	008b0913          	addi	s2,s6,8
    690a:	4681                	li	a3,0
    690c:	4629                	li	a2,10
    690e:	000b2583          	lw	a1,0(s6)
    6912:	8556                	mv	a0,s5
    6914:	00000097          	auipc	ra,0x0
    6918:	e72080e7          	jalr	-398(ra) # 6786 <printint>
    691c:	8b4a                	mv	s6,s2
      state = 0;
    691e:	4981                	li	s3,0
    6920:	bf85                	j	6890 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    6922:	008b0913          	addi	s2,s6,8
    6926:	4681                	li	a3,0
    6928:	4641                	li	a2,16
    692a:	000b2583          	lw	a1,0(s6)
    692e:	8556                	mv	a0,s5
    6930:	00000097          	auipc	ra,0x0
    6934:	e56080e7          	jalr	-426(ra) # 6786 <printint>
    6938:	8b4a                	mv	s6,s2
      state = 0;
    693a:	4981                	li	s3,0
    693c:	bf91                	j	6890 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    693e:	008b0793          	addi	a5,s6,8
    6942:	f8f43423          	sd	a5,-120(s0)
    6946:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    694a:	03000593          	li	a1,48
    694e:	8556                	mv	a0,s5
    6950:	00000097          	auipc	ra,0x0
    6954:	e14080e7          	jalr	-492(ra) # 6764 <putc>
  putc(fd, 'x');
    6958:	85ea                	mv	a1,s10
    695a:	8556                	mv	a0,s5
    695c:	00000097          	auipc	ra,0x0
    6960:	e08080e7          	jalr	-504(ra) # 6764 <putc>
    6964:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6966:	03c9d793          	srli	a5,s3,0x3c
    696a:	97de                	add	a5,a5,s7
    696c:	0007c583          	lbu	a1,0(a5)
    6970:	8556                	mv	a0,s5
    6972:	00000097          	auipc	ra,0x0
    6976:	df2080e7          	jalr	-526(ra) # 6764 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    697a:	0992                	slli	s3,s3,0x4
    697c:	397d                	addiw	s2,s2,-1
    697e:	fe0914e3          	bnez	s2,6966 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    6982:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    6986:	4981                	li	s3,0
    6988:	b721                	j	6890 <vprintf+0x60>
        s = va_arg(ap, char*);
    698a:	008b0993          	addi	s3,s6,8
    698e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    6992:	02090163          	beqz	s2,69b4 <vprintf+0x184>
        while(*s != 0){
    6996:	00094583          	lbu	a1,0(s2)
    699a:	c9a1                	beqz	a1,69ea <vprintf+0x1ba>
          putc(fd, *s);
    699c:	8556                	mv	a0,s5
    699e:	00000097          	auipc	ra,0x0
    69a2:	dc6080e7          	jalr	-570(ra) # 6764 <putc>
          s++;
    69a6:	0905                	addi	s2,s2,1
        while(*s != 0){
    69a8:	00094583          	lbu	a1,0(s2)
    69ac:	f9e5                	bnez	a1,699c <vprintf+0x16c>
        s = va_arg(ap, char*);
    69ae:	8b4e                	mv	s6,s3
      state = 0;
    69b0:	4981                	li	s3,0
    69b2:	bdf9                	j	6890 <vprintf+0x60>
          s = "(null)";
    69b4:	00002917          	auipc	s2,0x2
    69b8:	6b490913          	addi	s2,s2,1716 # 9068 <malloc+0x256e>
        while(*s != 0){
    69bc:	02800593          	li	a1,40
    69c0:	bff1                	j	699c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    69c2:	008b0913          	addi	s2,s6,8
    69c6:	000b4583          	lbu	a1,0(s6)
    69ca:	8556                	mv	a0,s5
    69cc:	00000097          	auipc	ra,0x0
    69d0:	d98080e7          	jalr	-616(ra) # 6764 <putc>
    69d4:	8b4a                	mv	s6,s2
      state = 0;
    69d6:	4981                	li	s3,0
    69d8:	bd65                	j	6890 <vprintf+0x60>
        putc(fd, c);
    69da:	85d2                	mv	a1,s4
    69dc:	8556                	mv	a0,s5
    69de:	00000097          	auipc	ra,0x0
    69e2:	d86080e7          	jalr	-634(ra) # 6764 <putc>
      state = 0;
    69e6:	4981                	li	s3,0
    69e8:	b565                	j	6890 <vprintf+0x60>
        s = va_arg(ap, char*);
    69ea:	8b4e                	mv	s6,s3
      state = 0;
    69ec:	4981                	li	s3,0
    69ee:	b54d                	j	6890 <vprintf+0x60>
    }
  }
}
    69f0:	70e6                	ld	ra,120(sp)
    69f2:	7446                	ld	s0,112(sp)
    69f4:	74a6                	ld	s1,104(sp)
    69f6:	7906                	ld	s2,96(sp)
    69f8:	69e6                	ld	s3,88(sp)
    69fa:	6a46                	ld	s4,80(sp)
    69fc:	6aa6                	ld	s5,72(sp)
    69fe:	6b06                	ld	s6,64(sp)
    6a00:	7be2                	ld	s7,56(sp)
    6a02:	7c42                	ld	s8,48(sp)
    6a04:	7ca2                	ld	s9,40(sp)
    6a06:	7d02                	ld	s10,32(sp)
    6a08:	6de2                	ld	s11,24(sp)
    6a0a:	6109                	addi	sp,sp,128
    6a0c:	8082                	ret

0000000000006a0e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    6a0e:	715d                	addi	sp,sp,-80
    6a10:	ec06                	sd	ra,24(sp)
    6a12:	e822                	sd	s0,16(sp)
    6a14:	1000                	addi	s0,sp,32
    6a16:	e010                	sd	a2,0(s0)
    6a18:	e414                	sd	a3,8(s0)
    6a1a:	e818                	sd	a4,16(s0)
    6a1c:	ec1c                	sd	a5,24(s0)
    6a1e:	03043023          	sd	a6,32(s0)
    6a22:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    6a26:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    6a2a:	8622                	mv	a2,s0
    6a2c:	00000097          	auipc	ra,0x0
    6a30:	e04080e7          	jalr	-508(ra) # 6830 <vprintf>
}
    6a34:	60e2                	ld	ra,24(sp)
    6a36:	6442                	ld	s0,16(sp)
    6a38:	6161                	addi	sp,sp,80
    6a3a:	8082                	ret

0000000000006a3c <printf>:

void
printf(const char *fmt, ...)
{
    6a3c:	711d                	addi	sp,sp,-96
    6a3e:	ec06                	sd	ra,24(sp)
    6a40:	e822                	sd	s0,16(sp)
    6a42:	1000                	addi	s0,sp,32
    6a44:	e40c                	sd	a1,8(s0)
    6a46:	e810                	sd	a2,16(s0)
    6a48:	ec14                	sd	a3,24(s0)
    6a4a:	f018                	sd	a4,32(s0)
    6a4c:	f41c                	sd	a5,40(s0)
    6a4e:	03043823          	sd	a6,48(s0)
    6a52:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    6a56:	00840613          	addi	a2,s0,8
    6a5a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6a5e:	85aa                	mv	a1,a0
    6a60:	4505                	li	a0,1
    6a62:	00000097          	auipc	ra,0x0
    6a66:	dce080e7          	jalr	-562(ra) # 6830 <vprintf>
}
    6a6a:	60e2                	ld	ra,24(sp)
    6a6c:	6442                	ld	s0,16(sp)
    6a6e:	6125                	addi	sp,sp,96
    6a70:	8082                	ret

0000000000006a72 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6a72:	1141                	addi	sp,sp,-16
    6a74:	e422                	sd	s0,8(sp)
    6a76:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6a78:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a7c:	00004797          	auipc	a5,0x4
    6a80:	9d47b783          	ld	a5,-1580(a5) # a450 <freep>
    6a84:	a805                	j	6ab4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6a86:	4618                	lw	a4,8(a2)
    6a88:	9db9                	addw	a1,a1,a4
    6a8a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6a8e:	6398                	ld	a4,0(a5)
    6a90:	6318                	ld	a4,0(a4)
    6a92:	fee53823          	sd	a4,-16(a0)
    6a96:	a091                	j	6ada <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6a98:	ff852703          	lw	a4,-8(a0)
    6a9c:	9e39                	addw	a2,a2,a4
    6a9e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    6aa0:	ff053703          	ld	a4,-16(a0)
    6aa4:	e398                	sd	a4,0(a5)
    6aa6:	a099                	j	6aec <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6aa8:	6398                	ld	a4,0(a5)
    6aaa:	00e7e463          	bltu	a5,a4,6ab2 <free+0x40>
    6aae:	00e6ea63          	bltu	a3,a4,6ac2 <free+0x50>
{
    6ab2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6ab4:	fed7fae3          	bgeu	a5,a3,6aa8 <free+0x36>
    6ab8:	6398                	ld	a4,0(a5)
    6aba:	00e6e463          	bltu	a3,a4,6ac2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6abe:	fee7eae3          	bltu	a5,a4,6ab2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    6ac2:	ff852583          	lw	a1,-8(a0)
    6ac6:	6390                	ld	a2,0(a5)
    6ac8:	02059713          	slli	a4,a1,0x20
    6acc:	9301                	srli	a4,a4,0x20
    6ace:	0712                	slli	a4,a4,0x4
    6ad0:	9736                	add	a4,a4,a3
    6ad2:	fae60ae3          	beq	a2,a4,6a86 <free+0x14>
    bp->s.ptr = p->s.ptr;
    6ad6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6ada:	4790                	lw	a2,8(a5)
    6adc:	02061713          	slli	a4,a2,0x20
    6ae0:	9301                	srli	a4,a4,0x20
    6ae2:	0712                	slli	a4,a4,0x4
    6ae4:	973e                	add	a4,a4,a5
    6ae6:	fae689e3          	beq	a3,a4,6a98 <free+0x26>
  } else
    p->s.ptr = bp;
    6aea:	e394                	sd	a3,0(a5)
  freep = p;
    6aec:	00004717          	auipc	a4,0x4
    6af0:	96f73223          	sd	a5,-1692(a4) # a450 <freep>
}
    6af4:	6422                	ld	s0,8(sp)
    6af6:	0141                	addi	sp,sp,16
    6af8:	8082                	ret

0000000000006afa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6afa:	7139                	addi	sp,sp,-64
    6afc:	fc06                	sd	ra,56(sp)
    6afe:	f822                	sd	s0,48(sp)
    6b00:	f426                	sd	s1,40(sp)
    6b02:	f04a                	sd	s2,32(sp)
    6b04:	ec4e                	sd	s3,24(sp)
    6b06:	e852                	sd	s4,16(sp)
    6b08:	e456                	sd	s5,8(sp)
    6b0a:	e05a                	sd	s6,0(sp)
    6b0c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6b0e:	02051493          	slli	s1,a0,0x20
    6b12:	9081                	srli	s1,s1,0x20
    6b14:	04bd                	addi	s1,s1,15
    6b16:	8091                	srli	s1,s1,0x4
    6b18:	0014899b          	addiw	s3,s1,1
    6b1c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6b1e:	00004517          	auipc	a0,0x4
    6b22:	93253503          	ld	a0,-1742(a0) # a450 <freep>
    6b26:	c515                	beqz	a0,6b52 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6b28:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6b2a:	4798                	lw	a4,8(a5)
    6b2c:	02977f63          	bgeu	a4,s1,6b6a <malloc+0x70>
    6b30:	8a4e                	mv	s4,s3
    6b32:	0009871b          	sext.w	a4,s3
    6b36:	6685                	lui	a3,0x1
    6b38:	00d77363          	bgeu	a4,a3,6b3e <malloc+0x44>
    6b3c:	6a05                	lui	s4,0x1
    6b3e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6b42:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6b46:	00004917          	auipc	s2,0x4
    6b4a:	90a90913          	addi	s2,s2,-1782 # a450 <freep>
  if(p == (char*)-1)
    6b4e:	5afd                	li	s5,-1
    6b50:	a88d                	j	6bc2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6b52:	0000a797          	auipc	a5,0xa
    6b56:	12678793          	addi	a5,a5,294 # 10c78 <base>
    6b5a:	00004717          	auipc	a4,0x4
    6b5e:	8ef73b23          	sd	a5,-1802(a4) # a450 <freep>
    6b62:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6b64:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6b68:	b7e1                	j	6b30 <malloc+0x36>
      if(p->s.size == nunits)
    6b6a:	02e48b63          	beq	s1,a4,6ba0 <malloc+0xa6>
        p->s.size -= nunits;
    6b6e:	4137073b          	subw	a4,a4,s3
    6b72:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6b74:	1702                	slli	a4,a4,0x20
    6b76:	9301                	srli	a4,a4,0x20
    6b78:	0712                	slli	a4,a4,0x4
    6b7a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6b7c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6b80:	00004717          	auipc	a4,0x4
    6b84:	8ca73823          	sd	a0,-1840(a4) # a450 <freep>
      return (void*)(p + 1);
    6b88:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6b8c:	70e2                	ld	ra,56(sp)
    6b8e:	7442                	ld	s0,48(sp)
    6b90:	74a2                	ld	s1,40(sp)
    6b92:	7902                	ld	s2,32(sp)
    6b94:	69e2                	ld	s3,24(sp)
    6b96:	6a42                	ld	s4,16(sp)
    6b98:	6aa2                	ld	s5,8(sp)
    6b9a:	6b02                	ld	s6,0(sp)
    6b9c:	6121                	addi	sp,sp,64
    6b9e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6ba0:	6398                	ld	a4,0(a5)
    6ba2:	e118                	sd	a4,0(a0)
    6ba4:	bff1                	j	6b80 <malloc+0x86>
  hp->s.size = nu;
    6ba6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6baa:	0541                	addi	a0,a0,16
    6bac:	00000097          	auipc	ra,0x0
    6bb0:	ec6080e7          	jalr	-314(ra) # 6a72 <free>
  return freep;
    6bb4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6bb8:	d971                	beqz	a0,6b8c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6bba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6bbc:	4798                	lw	a4,8(a5)
    6bbe:	fa9776e3          	bgeu	a4,s1,6b6a <malloc+0x70>
    if(p == freep)
    6bc2:	00093703          	ld	a4,0(s2)
    6bc6:	853e                	mv	a0,a5
    6bc8:	fef719e3          	bne	a4,a5,6bba <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    6bcc:	8552                	mv	a0,s4
    6bce:	00000097          	auipc	ra,0x0
    6bd2:	b56080e7          	jalr	-1194(ra) # 6724 <sbrk>
  if(p == (char*)-1)
    6bd6:	fd5518e3          	bne	a0,s5,6ba6 <malloc+0xac>
        return 0;
    6bda:	4501                	li	a0,0
    6bdc:	bf45                	j	6b8c <malloc+0x92>
