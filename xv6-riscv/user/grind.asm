
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	e8ca                	sd	s2,80(sp)
      82:	e4ce                	sd	s3,72(sp)
      84:	e0d2                	sd	s4,64(sp)
      86:	fc56                	sd	s5,56(sp)
      88:	f85a                	sd	s6,48(sp)
      8a:	1880                	addi	s0,sp,112
      8c:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	fba080e7          	jalr	-70(ra) # 104a <sbrk>
      98:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      9a:	00001517          	auipc	a0,0x1
      9e:	46650513          	addi	a0,a0,1126 # 1500 <malloc+0xe8>
      a2:	00001097          	auipc	ra,0x1
      a6:	f88080e7          	jalr	-120(ra) # 102a <mkdir>
  if(chdir("grindir") != 0){
      aa:	00001517          	auipc	a0,0x1
      ae:	45650513          	addi	a0,a0,1110 # 1500 <malloc+0xe8>
      b2:	00001097          	auipc	ra,0x1
      b6:	f80080e7          	jalr	-128(ra) # 1032 <chdir>
      ba:	c115                	beqz	a0,de <go+0x66>
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	44c50513          	addi	a0,a0,1100 # 1508 <malloc+0xf0>
      c4:	00001097          	auipc	ra,0x1
      c8:	296080e7          	jalr	662(ra) # 135a <printf>
    exit(1,"");
      cc:	00001597          	auipc	a1,0x1
      d0:	5cc58593          	addi	a1,a1,1484 # 1698 <malloc+0x280>
      d4:	4505                	li	a0,1
      d6:	00001097          	auipc	ra,0x1
      da:	eec080e7          	jalr	-276(ra) # fc2 <exit>
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	44a50513          	addi	a0,a0,1098 # 1528 <malloc+0x110>
      e6:	00001097          	auipc	ra,0x1
      ea:	f4c080e7          	jalr	-180(ra) # 1032 <chdir>
  
  while(1){
    iters++;
    if((iters % 500) == 0)
      ee:	00001997          	auipc	s3,0x1
      f2:	44a98993          	addi	s3,s3,1098 # 1538 <malloc+0x120>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	43898993          	addi	s3,s3,1080 # 1530 <malloc+0x118>
    iters++;
     100:	4485                	li	s1,1
  int fd = -1;
     102:	597d                	li	s2,-1
      close(fd);
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     104:	00002a17          	auipc	s4,0x2
     108:	f1ca0a13          	addi	s4,s4,-228 # 2020 <buf.0>
     10c:	a825                	j	144 <go+0xcc>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	42e50513          	addi	a0,a0,1070 # 1540 <malloc+0x128>
     11a:	00001097          	auipc	ra,0x1
     11e:	ee8080e7          	jalr	-280(ra) # 1002 <open>
     122:	00001097          	auipc	ra,0x1
     126:	ec8080e7          	jalr	-312(ra) # fea <close>
    iters++;
     12a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	ea6080e7          	jalr	-346(ra) # fe2 <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
    if(what == 1){
     152:	4785                	li	a5,1
     154:	faf50de3          	beq	a0,a5,10e <go+0x96>
    } else if(what == 2){
     158:	4789                	li	a5,2
     15a:	18f50b63          	beq	a0,a5,2f0 <go+0x278>
    } else if(what == 3){
     15e:	478d                	li	a5,3
     160:	1af50763          	beq	a0,a5,30e <go+0x296>
    } else if(what == 4){
     164:	4791                	li	a5,4
     166:	1af50d63          	beq	a0,a5,320 <go+0x2a8>
    } else if(what == 5){
     16a:	4795                	li	a5,5
     16c:	20f50563          	beq	a0,a5,376 <go+0x2fe>
    } else if(what == 6){
     170:	4799                	li	a5,6
     172:	22f50363          	beq	a0,a5,398 <go+0x320>
    } else if(what == 7){
     176:	479d                	li	a5,7
     178:	24f50163          	beq	a0,a5,3ba <go+0x342>
    } else if(what == 8){
     17c:	47a1                	li	a5,8
     17e:	24f50763          	beq	a0,a5,3cc <go+0x354>
    } else if(what == 9){
     182:	47a5                	li	a5,9
     184:	24f50d63          	beq	a0,a5,3de <go+0x366>
      mkdir("grindir/../a");
      close(open("a/../a/./a", O_CREATE|O_RDWR));
      unlink("a/a");
    } else if(what == 10){
     188:	47a9                	li	a5,10
     18a:	28f50963          	beq	a0,a5,41c <go+0x3a4>
      mkdir("/../b");
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
      unlink("b/b");
    } else if(what == 11){
     18e:	47ad                	li	a5,11
     190:	2cf50563          	beq	a0,a5,45a <go+0x3e2>
      unlink("b");
      link("../grindir/./../a", "../b");
    } else if(what == 12){
     194:	47b1                	li	a5,12
     196:	2ef50763          	beq	a0,a5,484 <go+0x40c>
      unlink("../grindir/../a");
      link(".././b", "/grindir/../a");
    } else if(what == 13){
     19a:	47b5                	li	a5,13
     19c:	30f50963          	beq	a0,a5,4ae <go+0x436>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1,"");
      }
      wait(0,0);
    } else if(what == 14){
     1a0:	47b9                	li	a5,14
     1a2:	34f50d63          	beq	a0,a5,4fc <go+0x484>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1,"");
      }
      wait(0,0);
    } else if(what == 15){
     1a6:	47bd                	li	a5,15
     1a8:	3af50a63          	beq	a0,a5,55c <go+0x4e4>
      sbrk(6011);
    } else if(what == 16){
     1ac:	47c1                	li	a5,16
     1ae:	3af50f63          	beq	a0,a5,56c <go+0x4f4>
      if(sbrk(0) > break0)
        sbrk(-(sbrk(0) - break0));
    } else if(what == 17){
     1b2:	47c5                	li	a5,17
     1b4:	3cf50f63          	beq	a0,a5,592 <go+0x51a>
        printf("grind: chdir failed\n");
        exit(1,"");
      }
      kill(pid);
      wait(0,0);
    } else if(what == 18){
     1b8:	47c9                	li	a5,18
     1ba:	48f50263          	beq	a0,a5,63e <go+0x5c6>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1,"");
      }
      wait(0,0);
    } else if(what == 19){
     1be:	47cd                	li	a5,19
     1c0:	4cf50f63          	beq	a0,a5,69e <go+0x626>
        exit(1,"");
      }
      close(fds[0]);
      close(fds[1]);
      wait(0,0);
    } else if(what == 20){
     1c4:	47d1                	li	a5,20
     1c6:	5cf50d63          	beq	a0,a5,7a0 <go+0x728>
      } else if(pid < 0){
        printf("grind: fork failed\n");
        exit(1,"");
      }
      wait(0,0);
    } else if(what == 21){
     1ca:	47d5                	li	a5,21
     1cc:	68f50463          	beq	a0,a5,854 <go+0x7dc>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1,"");
      }
      close(fd1);
      unlink("c");
    } else if(what == 22){
     1d0:	47d9                	li	a5,22
     1d2:	f4f51ce3          	bne	a0,a5,12a <go+0xb2>
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     1d6:	f9840513          	addi	a0,s0,-104
     1da:	00001097          	auipc	ra,0x1
     1de:	df8080e7          	jalr	-520(ra) # fd2 <pipe>
     1e2:	7a054163          	bltz	a0,984 <go+0x90c>
        fprintf(2, "grind: pipe failed\n");
        exit(1,"");
      }
      if(pipe(bb) < 0){
     1e6:	fa040513          	addi	a0,s0,-96
     1ea:	00001097          	auipc	ra,0x1
     1ee:	de8080e7          	jalr	-536(ra) # fd2 <pipe>
     1f2:	7a054b63          	bltz	a0,9a8 <go+0x930>
        fprintf(2, "grind: pipe failed\n");
        exit(1,"");
      }
      int pid1 = fork();
     1f6:	00001097          	auipc	ra,0x1
     1fa:	dc4080e7          	jalr	-572(ra) # fba <fork>
      if(pid1 == 0){
     1fe:	7c050763          	beqz	a0,9cc <go+0x954>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2,"");
      } else if(pid1 < 0){
     202:	080547e3          	bltz	a0,a90 <go+0xa18>
        fprintf(2, "grind: fork failed\n");
        exit(3,"");
      }
      int pid2 = fork();
     206:	00001097          	auipc	ra,0x1
     20a:	db4080e7          	jalr	-588(ra) # fba <fork>
      if(pid2 == 0){
     20e:	0a0503e3          	beqz	a0,ab4 <go+0xa3c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6,"");
      } else if(pid2 < 0){
     212:	18054be3          	bltz	a0,ba8 <go+0xb30>
        fprintf(2, "grind: fork failed\n");
        exit(7,"");
      }
      close(aa[0]);
     216:	f9842503          	lw	a0,-104(s0)
     21a:	00001097          	auipc	ra,0x1
     21e:	dd0080e7          	jalr	-560(ra) # fea <close>
      close(aa[1]);
     222:	f9c42503          	lw	a0,-100(s0)
     226:	00001097          	auipc	ra,0x1
     22a:	dc4080e7          	jalr	-572(ra) # fea <close>
      close(bb[1]);
     22e:	fa442503          	lw	a0,-92(s0)
     232:	00001097          	auipc	ra,0x1
     236:	db8080e7          	jalr	-584(ra) # fea <close>
      char buf[4] = { 0, 0, 0, 0 };
     23a:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     23e:	4605                	li	a2,1
     240:	f9040593          	addi	a1,s0,-112
     244:	fa042503          	lw	a0,-96(s0)
     248:	00001097          	auipc	ra,0x1
     24c:	d92080e7          	jalr	-622(ra) # fda <read>
      read(bb[0], buf+1, 1);
     250:	4605                	li	a2,1
     252:	f9140593          	addi	a1,s0,-111
     256:	fa042503          	lw	a0,-96(s0)
     25a:	00001097          	auipc	ra,0x1
     25e:	d80080e7          	jalr	-640(ra) # fda <read>
      read(bb[0], buf+2, 1);
     262:	4605                	li	a2,1
     264:	f9240593          	addi	a1,s0,-110
     268:	fa042503          	lw	a0,-96(s0)
     26c:	00001097          	auipc	ra,0x1
     270:	d6e080e7          	jalr	-658(ra) # fda <read>
      close(bb[0]);
     274:	fa042503          	lw	a0,-96(s0)
     278:	00001097          	auipc	ra,0x1
     27c:	d72080e7          	jalr	-654(ra) # fea <close>
      int st1, st2;
      wait(&st1,0);
     280:	4581                	li	a1,0
     282:	f9440513          	addi	a0,s0,-108
     286:	00001097          	auipc	ra,0x1
     28a:	d44080e7          	jalr	-700(ra) # fca <wait>
      wait(&st2,0);
     28e:	4581                	li	a1,0
     290:	fa840513          	addi	a0,s0,-88
     294:	00001097          	auipc	ra,0x1
     298:	d36080e7          	jalr	-714(ra) # fca <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     29c:	f9442783          	lw	a5,-108(s0)
     2a0:	fa842703          	lw	a4,-88(s0)
     2a4:	8fd9                	or	a5,a5,a4
     2a6:	2781                	sext.w	a5,a5
     2a8:	ef89                	bnez	a5,2c2 <go+0x24a>
     2aa:	00001597          	auipc	a1,0x1
     2ae:	50e58593          	addi	a1,a1,1294 # 17b8 <malloc+0x3a0>
     2b2:	f9040513          	addi	a0,s0,-112
     2b6:	00001097          	auipc	ra,0x1
     2ba:	aba080e7          	jalr	-1350(ra) # d70 <strcmp>
     2be:	e60506e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     2c2:	f9040693          	addi	a3,s0,-112
     2c6:	fa842603          	lw	a2,-88(s0)
     2ca:	f9442583          	lw	a1,-108(s0)
     2ce:	00001517          	auipc	a0,0x1
     2d2:	4f250513          	addi	a0,a0,1266 # 17c0 <malloc+0x3a8>
     2d6:	00001097          	auipc	ra,0x1
     2da:	084080e7          	jalr	132(ra) # 135a <printf>
        exit(1,"");
     2de:	00001597          	auipc	a1,0x1
     2e2:	3ba58593          	addi	a1,a1,954 # 1698 <malloc+0x280>
     2e6:	4505                	li	a0,1
     2e8:	00001097          	auipc	ra,0x1
     2ec:	cda080e7          	jalr	-806(ra) # fc2 <exit>
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     2f0:	20200593          	li	a1,514
     2f4:	00001517          	auipc	a0,0x1
     2f8:	25c50513          	addi	a0,a0,604 # 1550 <malloc+0x138>
     2fc:	00001097          	auipc	ra,0x1
     300:	d06080e7          	jalr	-762(ra) # 1002 <open>
     304:	00001097          	auipc	ra,0x1
     308:	ce6080e7          	jalr	-794(ra) # fea <close>
     30c:	bd39                	j	12a <go+0xb2>
      unlink("grindir/../a");
     30e:	00001517          	auipc	a0,0x1
     312:	23250513          	addi	a0,a0,562 # 1540 <malloc+0x128>
     316:	00001097          	auipc	ra,0x1
     31a:	cfc080e7          	jalr	-772(ra) # 1012 <unlink>
     31e:	b531                	j	12a <go+0xb2>
      if(chdir("grindir") != 0){
     320:	00001517          	auipc	a0,0x1
     324:	1e050513          	addi	a0,a0,480 # 1500 <malloc+0xe8>
     328:	00001097          	auipc	ra,0x1
     32c:	d0a080e7          	jalr	-758(ra) # 1032 <chdir>
     330:	e115                	bnez	a0,354 <go+0x2dc>
      unlink("../b");
     332:	00001517          	auipc	a0,0x1
     336:	23650513          	addi	a0,a0,566 # 1568 <malloc+0x150>
     33a:	00001097          	auipc	ra,0x1
     33e:	cd8080e7          	jalr	-808(ra) # 1012 <unlink>
      chdir("/");
     342:	00001517          	auipc	a0,0x1
     346:	1e650513          	addi	a0,a0,486 # 1528 <malloc+0x110>
     34a:	00001097          	auipc	ra,0x1
     34e:	ce8080e7          	jalr	-792(ra) # 1032 <chdir>
     352:	bbe1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     354:	00001517          	auipc	a0,0x1
     358:	1b450513          	addi	a0,a0,436 # 1508 <malloc+0xf0>
     35c:	00001097          	auipc	ra,0x1
     360:	ffe080e7          	jalr	-2(ra) # 135a <printf>
        exit(1,"");
     364:	00001597          	auipc	a1,0x1
     368:	33458593          	addi	a1,a1,820 # 1698 <malloc+0x280>
     36c:	4505                	li	a0,1
     36e:	00001097          	auipc	ra,0x1
     372:	c54080e7          	jalr	-940(ra) # fc2 <exit>
      close(fd);
     376:	854a                	mv	a0,s2
     378:	00001097          	auipc	ra,0x1
     37c:	c72080e7          	jalr	-910(ra) # fea <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     380:	20200593          	li	a1,514
     384:	00001517          	auipc	a0,0x1
     388:	1ec50513          	addi	a0,a0,492 # 1570 <malloc+0x158>
     38c:	00001097          	auipc	ra,0x1
     390:	c76080e7          	jalr	-906(ra) # 1002 <open>
     394:	892a                	mv	s2,a0
     396:	bb51                	j	12a <go+0xb2>
      close(fd);
     398:	854a                	mv	a0,s2
     39a:	00001097          	auipc	ra,0x1
     39e:	c50080e7          	jalr	-944(ra) # fea <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     3a2:	20200593          	li	a1,514
     3a6:	00001517          	auipc	a0,0x1
     3aa:	1da50513          	addi	a0,a0,474 # 1580 <malloc+0x168>
     3ae:	00001097          	auipc	ra,0x1
     3b2:	c54080e7          	jalr	-940(ra) # 1002 <open>
     3b6:	892a                	mv	s2,a0
     3b8:	bb8d                	j	12a <go+0xb2>
      write(fd, buf, sizeof(buf));
     3ba:	3e700613          	li	a2,999
     3be:	85d2                	mv	a1,s4
     3c0:	854a                	mv	a0,s2
     3c2:	00001097          	auipc	ra,0x1
     3c6:	c20080e7          	jalr	-992(ra) # fe2 <write>
     3ca:	b385                	j	12a <go+0xb2>
      read(fd, buf, sizeof(buf));
     3cc:	3e700613          	li	a2,999
     3d0:	85d2                	mv	a1,s4
     3d2:	854a                	mv	a0,s2
     3d4:	00001097          	auipc	ra,0x1
     3d8:	c06080e7          	jalr	-1018(ra) # fda <read>
     3dc:	b3b9                	j	12a <go+0xb2>
      mkdir("grindir/../a");
     3de:	00001517          	auipc	a0,0x1
     3e2:	16250513          	addi	a0,a0,354 # 1540 <malloc+0x128>
     3e6:	00001097          	auipc	ra,0x1
     3ea:	c44080e7          	jalr	-956(ra) # 102a <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     3ee:	20200593          	li	a1,514
     3f2:	00001517          	auipc	a0,0x1
     3f6:	1a650513          	addi	a0,a0,422 # 1598 <malloc+0x180>
     3fa:	00001097          	auipc	ra,0x1
     3fe:	c08080e7          	jalr	-1016(ra) # 1002 <open>
     402:	00001097          	auipc	ra,0x1
     406:	be8080e7          	jalr	-1048(ra) # fea <close>
      unlink("a/a");
     40a:	00001517          	auipc	a0,0x1
     40e:	19e50513          	addi	a0,a0,414 # 15a8 <malloc+0x190>
     412:	00001097          	auipc	ra,0x1
     416:	c00080e7          	jalr	-1024(ra) # 1012 <unlink>
     41a:	bb01                	j	12a <go+0xb2>
      mkdir("/../b");
     41c:	00001517          	auipc	a0,0x1
     420:	19450513          	addi	a0,a0,404 # 15b0 <malloc+0x198>
     424:	00001097          	auipc	ra,0x1
     428:	c06080e7          	jalr	-1018(ra) # 102a <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     42c:	20200593          	li	a1,514
     430:	00001517          	auipc	a0,0x1
     434:	18850513          	addi	a0,a0,392 # 15b8 <malloc+0x1a0>
     438:	00001097          	auipc	ra,0x1
     43c:	bca080e7          	jalr	-1078(ra) # 1002 <open>
     440:	00001097          	auipc	ra,0x1
     444:	baa080e7          	jalr	-1110(ra) # fea <close>
      unlink("b/b");
     448:	00001517          	auipc	a0,0x1
     44c:	18050513          	addi	a0,a0,384 # 15c8 <malloc+0x1b0>
     450:	00001097          	auipc	ra,0x1
     454:	bc2080e7          	jalr	-1086(ra) # 1012 <unlink>
     458:	b9c9                	j	12a <go+0xb2>
      unlink("b");
     45a:	00001517          	auipc	a0,0x1
     45e:	13650513          	addi	a0,a0,310 # 1590 <malloc+0x178>
     462:	00001097          	auipc	ra,0x1
     466:	bb0080e7          	jalr	-1104(ra) # 1012 <unlink>
      link("../grindir/./../a", "../b");
     46a:	00001597          	auipc	a1,0x1
     46e:	0fe58593          	addi	a1,a1,254 # 1568 <malloc+0x150>
     472:	00001517          	auipc	a0,0x1
     476:	15e50513          	addi	a0,a0,350 # 15d0 <malloc+0x1b8>
     47a:	00001097          	auipc	ra,0x1
     47e:	ba8080e7          	jalr	-1112(ra) # 1022 <link>
     482:	b165                	j	12a <go+0xb2>
      unlink("../grindir/../a");
     484:	00001517          	auipc	a0,0x1
     488:	16450513          	addi	a0,a0,356 # 15e8 <malloc+0x1d0>
     48c:	00001097          	auipc	ra,0x1
     490:	b86080e7          	jalr	-1146(ra) # 1012 <unlink>
      link(".././b", "/grindir/../a");
     494:	00001597          	auipc	a1,0x1
     498:	0dc58593          	addi	a1,a1,220 # 1570 <malloc+0x158>
     49c:	00001517          	auipc	a0,0x1
     4a0:	15c50513          	addi	a0,a0,348 # 15f8 <malloc+0x1e0>
     4a4:	00001097          	auipc	ra,0x1
     4a8:	b7e080e7          	jalr	-1154(ra) # 1022 <link>
     4ac:	b9bd                	j	12a <go+0xb2>
      int pid = fork();
     4ae:	00001097          	auipc	ra,0x1
     4b2:	b0c080e7          	jalr	-1268(ra) # fba <fork>
      if(pid == 0){
     4b6:	c911                	beqz	a0,4ca <go+0x452>
      } else if(pid < 0){
     4b8:	02054163          	bltz	a0,4da <go+0x462>
      wait(0,0);
     4bc:	4581                	li	a1,0
     4be:	4501                	li	a0,0
     4c0:	00001097          	auipc	ra,0x1
     4c4:	b0a080e7          	jalr	-1270(ra) # fca <wait>
     4c8:	b18d                	j	12a <go+0xb2>
        exit(0,"");
     4ca:	00001597          	auipc	a1,0x1
     4ce:	1ce58593          	addi	a1,a1,462 # 1698 <malloc+0x280>
     4d2:	00001097          	auipc	ra,0x1
     4d6:	af0080e7          	jalr	-1296(ra) # fc2 <exit>
        printf("grind: fork failed\n");
     4da:	00001517          	auipc	a0,0x1
     4de:	12650513          	addi	a0,a0,294 # 1600 <malloc+0x1e8>
     4e2:	00001097          	auipc	ra,0x1
     4e6:	e78080e7          	jalr	-392(ra) # 135a <printf>
        exit(1,"");
     4ea:	00001597          	auipc	a1,0x1
     4ee:	1ae58593          	addi	a1,a1,430 # 1698 <malloc+0x280>
     4f2:	4505                	li	a0,1
     4f4:	00001097          	auipc	ra,0x1
     4f8:	ace080e7          	jalr	-1330(ra) # fc2 <exit>
      int pid = fork();
     4fc:	00001097          	auipc	ra,0x1
     500:	abe080e7          	jalr	-1346(ra) # fba <fork>
      if(pid == 0){
     504:	c911                	beqz	a0,518 <go+0x4a0>
      } else if(pid < 0){
     506:	02054a63          	bltz	a0,53a <go+0x4c2>
      wait(0,0);
     50a:	4581                	li	a1,0
     50c:	4501                	li	a0,0
     50e:	00001097          	auipc	ra,0x1
     512:	abc080e7          	jalr	-1348(ra) # fca <wait>
     516:	b911                	j	12a <go+0xb2>
        fork();
     518:	00001097          	auipc	ra,0x1
     51c:	aa2080e7          	jalr	-1374(ra) # fba <fork>
        fork();
     520:	00001097          	auipc	ra,0x1
     524:	a9a080e7          	jalr	-1382(ra) # fba <fork>
        exit(0,"");
     528:	00001597          	auipc	a1,0x1
     52c:	17058593          	addi	a1,a1,368 # 1698 <malloc+0x280>
     530:	4501                	li	a0,0
     532:	00001097          	auipc	ra,0x1
     536:	a90080e7          	jalr	-1392(ra) # fc2 <exit>
        printf("grind: fork failed\n");
     53a:	00001517          	auipc	a0,0x1
     53e:	0c650513          	addi	a0,a0,198 # 1600 <malloc+0x1e8>
     542:	00001097          	auipc	ra,0x1
     546:	e18080e7          	jalr	-488(ra) # 135a <printf>
        exit(1,"");
     54a:	00001597          	auipc	a1,0x1
     54e:	14e58593          	addi	a1,a1,334 # 1698 <malloc+0x280>
     552:	4505                	li	a0,1
     554:	00001097          	auipc	ra,0x1
     558:	a6e080e7          	jalr	-1426(ra) # fc2 <exit>
      sbrk(6011);
     55c:	6505                	lui	a0,0x1
     55e:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x363>
     562:	00001097          	auipc	ra,0x1
     566:	ae8080e7          	jalr	-1304(ra) # 104a <sbrk>
     56a:	b6c1                	j	12a <go+0xb2>
      if(sbrk(0) > break0)
     56c:	4501                	li	a0,0
     56e:	00001097          	auipc	ra,0x1
     572:	adc080e7          	jalr	-1316(ra) # 104a <sbrk>
     576:	baaafae3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     57a:	4501                	li	a0,0
     57c:	00001097          	auipc	ra,0x1
     580:	ace080e7          	jalr	-1330(ra) # 104a <sbrk>
     584:	40aa853b          	subw	a0,s5,a0
     588:	00001097          	auipc	ra,0x1
     58c:	ac2080e7          	jalr	-1342(ra) # 104a <sbrk>
     590:	be69                	j	12a <go+0xb2>
      int pid = fork();
     592:	00001097          	auipc	ra,0x1
     596:	a28080e7          	jalr	-1496(ra) # fba <fork>
     59a:	8b2a                	mv	s6,a0
      if(pid == 0){
     59c:	c905                	beqz	a0,5cc <go+0x554>
      } else if(pid < 0){
     59e:	04054e63          	bltz	a0,5fa <go+0x582>
      if(chdir("../grindir/..") != 0){
     5a2:	00001517          	auipc	a0,0x1
     5a6:	07650513          	addi	a0,a0,118 # 1618 <malloc+0x200>
     5aa:	00001097          	auipc	ra,0x1
     5ae:	a88080e7          	jalr	-1400(ra) # 1032 <chdir>
     5b2:	e52d                	bnez	a0,61c <go+0x5a4>
      kill(pid);
     5b4:	855a                	mv	a0,s6
     5b6:	00001097          	auipc	ra,0x1
     5ba:	a3c080e7          	jalr	-1476(ra) # ff2 <kill>
      wait(0,0);
     5be:	4581                	li	a1,0
     5c0:	4501                	li	a0,0
     5c2:	00001097          	auipc	ra,0x1
     5c6:	a08080e7          	jalr	-1528(ra) # fca <wait>
     5ca:	b685                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     5cc:	20200593          	li	a1,514
     5d0:	00001517          	auipc	a0,0x1
     5d4:	01050513          	addi	a0,a0,16 # 15e0 <malloc+0x1c8>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	a2a080e7          	jalr	-1494(ra) # 1002 <open>
     5e0:	00001097          	auipc	ra,0x1
     5e4:	a0a080e7          	jalr	-1526(ra) # fea <close>
        exit(0,"");
     5e8:	00001597          	auipc	a1,0x1
     5ec:	0b058593          	addi	a1,a1,176 # 1698 <malloc+0x280>
     5f0:	4501                	li	a0,0
     5f2:	00001097          	auipc	ra,0x1
     5f6:	9d0080e7          	jalr	-1584(ra) # fc2 <exit>
        printf("grind: fork failed\n");
     5fa:	00001517          	auipc	a0,0x1
     5fe:	00650513          	addi	a0,a0,6 # 1600 <malloc+0x1e8>
     602:	00001097          	auipc	ra,0x1
     606:	d58080e7          	jalr	-680(ra) # 135a <printf>
        exit(1,"");
     60a:	00001597          	auipc	a1,0x1
     60e:	08e58593          	addi	a1,a1,142 # 1698 <malloc+0x280>
     612:	4505                	li	a0,1
     614:	00001097          	auipc	ra,0x1
     618:	9ae080e7          	jalr	-1618(ra) # fc2 <exit>
        printf("grind: chdir failed\n");
     61c:	00001517          	auipc	a0,0x1
     620:	00c50513          	addi	a0,a0,12 # 1628 <malloc+0x210>
     624:	00001097          	auipc	ra,0x1
     628:	d36080e7          	jalr	-714(ra) # 135a <printf>
        exit(1,"");
     62c:	00001597          	auipc	a1,0x1
     630:	06c58593          	addi	a1,a1,108 # 1698 <malloc+0x280>
     634:	4505                	li	a0,1
     636:	00001097          	auipc	ra,0x1
     63a:	98c080e7          	jalr	-1652(ra) # fc2 <exit>
      int pid = fork();
     63e:	00001097          	auipc	ra,0x1
     642:	97c080e7          	jalr	-1668(ra) # fba <fork>
      if(pid == 0){
     646:	c911                	beqz	a0,65a <go+0x5e2>
      } else if(pid < 0){
     648:	02054a63          	bltz	a0,67c <go+0x604>
      wait(0,0);
     64c:	4581                	li	a1,0
     64e:	4501                	li	a0,0
     650:	00001097          	auipc	ra,0x1
     654:	97a080e7          	jalr	-1670(ra) # fca <wait>
     658:	bcc9                	j	12a <go+0xb2>
        kill(getpid());
     65a:	00001097          	auipc	ra,0x1
     65e:	9e8080e7          	jalr	-1560(ra) # 1042 <getpid>
     662:	00001097          	auipc	ra,0x1
     666:	990080e7          	jalr	-1648(ra) # ff2 <kill>
        exit(0,"");
     66a:	00001597          	auipc	a1,0x1
     66e:	02e58593          	addi	a1,a1,46 # 1698 <malloc+0x280>
     672:	4501                	li	a0,0
     674:	00001097          	auipc	ra,0x1
     678:	94e080e7          	jalr	-1714(ra) # fc2 <exit>
        printf("grind: fork failed\n");
     67c:	00001517          	auipc	a0,0x1
     680:	f8450513          	addi	a0,a0,-124 # 1600 <malloc+0x1e8>
     684:	00001097          	auipc	ra,0x1
     688:	cd6080e7          	jalr	-810(ra) # 135a <printf>
        exit(1,"");
     68c:	00001597          	auipc	a1,0x1
     690:	00c58593          	addi	a1,a1,12 # 1698 <malloc+0x280>
     694:	4505                	li	a0,1
     696:	00001097          	auipc	ra,0x1
     69a:	92c080e7          	jalr	-1748(ra) # fc2 <exit>
      if(pipe(fds) < 0){
     69e:	fa840513          	addi	a0,s0,-88
     6a2:	00001097          	auipc	ra,0x1
     6a6:	930080e7          	jalr	-1744(ra) # fd2 <pipe>
     6aa:	02054c63          	bltz	a0,6e2 <go+0x66a>
      int pid = fork();
     6ae:	00001097          	auipc	ra,0x1
     6b2:	90c080e7          	jalr	-1780(ra) # fba <fork>
      if(pid == 0){
     6b6:	c539                	beqz	a0,704 <go+0x68c>
      } else if(pid < 0){
     6b8:	0c054363          	bltz	a0,77e <go+0x706>
      close(fds[0]);
     6bc:	fa842503          	lw	a0,-88(s0)
     6c0:	00001097          	auipc	ra,0x1
     6c4:	92a080e7          	jalr	-1750(ra) # fea <close>
      close(fds[1]);
     6c8:	fac42503          	lw	a0,-84(s0)
     6cc:	00001097          	auipc	ra,0x1
     6d0:	91e080e7          	jalr	-1762(ra) # fea <close>
      wait(0,0);
     6d4:	4581                	li	a1,0
     6d6:	4501                	li	a0,0
     6d8:	00001097          	auipc	ra,0x1
     6dc:	8f2080e7          	jalr	-1806(ra) # fca <wait>
     6e0:	b4a9                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	f5e50513          	addi	a0,a0,-162 # 1640 <malloc+0x228>
     6ea:	00001097          	auipc	ra,0x1
     6ee:	c70080e7          	jalr	-912(ra) # 135a <printf>
        exit(1,"");
     6f2:	00001597          	auipc	a1,0x1
     6f6:	fa658593          	addi	a1,a1,-90 # 1698 <malloc+0x280>
     6fa:	4505                	li	a0,1
     6fc:	00001097          	auipc	ra,0x1
     700:	8c6080e7          	jalr	-1850(ra) # fc2 <exit>
        fork();
     704:	00001097          	auipc	ra,0x1
     708:	8b6080e7          	jalr	-1866(ra) # fba <fork>
        fork();
     70c:	00001097          	auipc	ra,0x1
     710:	8ae080e7          	jalr	-1874(ra) # fba <fork>
        if(write(fds[1], "x", 1) != 1)
     714:	4605                	li	a2,1
     716:	00001597          	auipc	a1,0x1
     71a:	f4258593          	addi	a1,a1,-190 # 1658 <malloc+0x240>
     71e:	fac42503          	lw	a0,-84(s0)
     722:	00001097          	auipc	ra,0x1
     726:	8c0080e7          	jalr	-1856(ra) # fe2 <write>
     72a:	4785                	li	a5,1
     72c:	02f51763          	bne	a0,a5,75a <go+0x6e2>
        if(read(fds[0], &c, 1) != 1)
     730:	4605                	li	a2,1
     732:	fa040593          	addi	a1,s0,-96
     736:	fa842503          	lw	a0,-88(s0)
     73a:	00001097          	auipc	ra,0x1
     73e:	8a0080e7          	jalr	-1888(ra) # fda <read>
     742:	4785                	li	a5,1
     744:	02f51463          	bne	a0,a5,76c <go+0x6f4>
        exit(0,"");
     748:	00001597          	auipc	a1,0x1
     74c:	f5058593          	addi	a1,a1,-176 # 1698 <malloc+0x280>
     750:	4501                	li	a0,0
     752:	00001097          	auipc	ra,0x1
     756:	870080e7          	jalr	-1936(ra) # fc2 <exit>
          printf("grind: pipe write failed\n");
     75a:	00001517          	auipc	a0,0x1
     75e:	f0650513          	addi	a0,a0,-250 # 1660 <malloc+0x248>
     762:	00001097          	auipc	ra,0x1
     766:	bf8080e7          	jalr	-1032(ra) # 135a <printf>
     76a:	b7d9                	j	730 <go+0x6b8>
          printf("grind: pipe read failed\n");
     76c:	00001517          	auipc	a0,0x1
     770:	f1450513          	addi	a0,a0,-236 # 1680 <malloc+0x268>
     774:	00001097          	auipc	ra,0x1
     778:	be6080e7          	jalr	-1050(ra) # 135a <printf>
     77c:	b7f1                	j	748 <go+0x6d0>
        printf("grind: fork failed\n");
     77e:	00001517          	auipc	a0,0x1
     782:	e8250513          	addi	a0,a0,-382 # 1600 <malloc+0x1e8>
     786:	00001097          	auipc	ra,0x1
     78a:	bd4080e7          	jalr	-1068(ra) # 135a <printf>
        exit(1,"");
     78e:	00001597          	auipc	a1,0x1
     792:	f0a58593          	addi	a1,a1,-246 # 1698 <malloc+0x280>
     796:	4505                	li	a0,1
     798:	00001097          	auipc	ra,0x1
     79c:	82a080e7          	jalr	-2006(ra) # fc2 <exit>
      int pid = fork();
     7a0:	00001097          	auipc	ra,0x1
     7a4:	81a080e7          	jalr	-2022(ra) # fba <fork>
      if(pid == 0){
     7a8:	c911                	beqz	a0,7bc <go+0x744>
      } else if(pid < 0){
     7aa:	08054463          	bltz	a0,832 <go+0x7ba>
      wait(0,0);
     7ae:	4581                	li	a1,0
     7b0:	4501                	li	a0,0
     7b2:	00001097          	auipc	ra,0x1
     7b6:	818080e7          	jalr	-2024(ra) # fca <wait>
     7ba:	ba85                	j	12a <go+0xb2>
        unlink("a");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	e2450513          	addi	a0,a0,-476 # 15e0 <malloc+0x1c8>
     7c4:	00001097          	auipc	ra,0x1
     7c8:	84e080e7          	jalr	-1970(ra) # 1012 <unlink>
        mkdir("a");
     7cc:	00001517          	auipc	a0,0x1
     7d0:	e1450513          	addi	a0,a0,-492 # 15e0 <malloc+0x1c8>
     7d4:	00001097          	auipc	ra,0x1
     7d8:	856080e7          	jalr	-1962(ra) # 102a <mkdir>
        chdir("a");
     7dc:	00001517          	auipc	a0,0x1
     7e0:	e0450513          	addi	a0,a0,-508 # 15e0 <malloc+0x1c8>
     7e4:	00001097          	auipc	ra,0x1
     7e8:	84e080e7          	jalr	-1970(ra) # 1032 <chdir>
        unlink("../a");
     7ec:	00001517          	auipc	a0,0x1
     7f0:	d5c50513          	addi	a0,a0,-676 # 1548 <malloc+0x130>
     7f4:	00001097          	auipc	ra,0x1
     7f8:	81e080e7          	jalr	-2018(ra) # 1012 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     7fc:	20200593          	li	a1,514
     800:	00001517          	auipc	a0,0x1
     804:	e5850513          	addi	a0,a0,-424 # 1658 <malloc+0x240>
     808:	00000097          	auipc	ra,0x0
     80c:	7fa080e7          	jalr	2042(ra) # 1002 <open>
        unlink("x");
     810:	00001517          	auipc	a0,0x1
     814:	e4850513          	addi	a0,a0,-440 # 1658 <malloc+0x240>
     818:	00000097          	auipc	ra,0x0
     81c:	7fa080e7          	jalr	2042(ra) # 1012 <unlink>
        exit(0,"");
     820:	00001597          	auipc	a1,0x1
     824:	e7858593          	addi	a1,a1,-392 # 1698 <malloc+0x280>
     828:	4501                	li	a0,0
     82a:	00000097          	auipc	ra,0x0
     82e:	798080e7          	jalr	1944(ra) # fc2 <exit>
        printf("grind: fork failed\n");
     832:	00001517          	auipc	a0,0x1
     836:	dce50513          	addi	a0,a0,-562 # 1600 <malloc+0x1e8>
     83a:	00001097          	auipc	ra,0x1
     83e:	b20080e7          	jalr	-1248(ra) # 135a <printf>
        exit(1,"");
     842:	00001597          	auipc	a1,0x1
     846:	e5658593          	addi	a1,a1,-426 # 1698 <malloc+0x280>
     84a:	4505                	li	a0,1
     84c:	00000097          	auipc	ra,0x0
     850:	776080e7          	jalr	1910(ra) # fc2 <exit>
      unlink("c");
     854:	00001517          	auipc	a0,0x1
     858:	e4c50513          	addi	a0,a0,-436 # 16a0 <malloc+0x288>
     85c:	00000097          	auipc	ra,0x0
     860:	7b6080e7          	jalr	1974(ra) # 1012 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     864:	20200593          	li	a1,514
     868:	00001517          	auipc	a0,0x1
     86c:	e3850513          	addi	a0,a0,-456 # 16a0 <malloc+0x288>
     870:	00000097          	auipc	ra,0x0
     874:	792080e7          	jalr	1938(ra) # 1002 <open>
     878:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     87a:	04054f63          	bltz	a0,8d8 <go+0x860>
      if(write(fd1, "x", 1) != 1){
     87e:	4605                	li	a2,1
     880:	00001597          	auipc	a1,0x1
     884:	dd858593          	addi	a1,a1,-552 # 1658 <malloc+0x240>
     888:	00000097          	auipc	ra,0x0
     88c:	75a080e7          	jalr	1882(ra) # fe2 <write>
     890:	4785                	li	a5,1
     892:	06f51463          	bne	a0,a5,8fa <go+0x882>
      if(fstat(fd1, &st) != 0){
     896:	fa840593          	addi	a1,s0,-88
     89a:	855a                	mv	a0,s6
     89c:	00000097          	auipc	ra,0x0
     8a0:	77e080e7          	jalr	1918(ra) # 101a <fstat>
     8a4:	ed25                	bnez	a0,91c <go+0x8a4>
      if(st.size != 1){
     8a6:	fb843583          	ld	a1,-72(s0)
     8aa:	4785                	li	a5,1
     8ac:	08f59963          	bne	a1,a5,93e <go+0x8c6>
      if(st.ino > 200){
     8b0:	fac42583          	lw	a1,-84(s0)
     8b4:	0c800793          	li	a5,200
     8b8:	0ab7e563          	bltu	a5,a1,962 <go+0x8ea>
      close(fd1);
     8bc:	855a                	mv	a0,s6
     8be:	00000097          	auipc	ra,0x0
     8c2:	72c080e7          	jalr	1836(ra) # fea <close>
      unlink("c");
     8c6:	00001517          	auipc	a0,0x1
     8ca:	dda50513          	addi	a0,a0,-550 # 16a0 <malloc+0x288>
     8ce:	00000097          	auipc	ra,0x0
     8d2:	744080e7          	jalr	1860(ra) # 1012 <unlink>
     8d6:	b891                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     8d8:	00001517          	auipc	a0,0x1
     8dc:	dd050513          	addi	a0,a0,-560 # 16a8 <malloc+0x290>
     8e0:	00001097          	auipc	ra,0x1
     8e4:	a7a080e7          	jalr	-1414(ra) # 135a <printf>
        exit(1,"");
     8e8:	00001597          	auipc	a1,0x1
     8ec:	db058593          	addi	a1,a1,-592 # 1698 <malloc+0x280>
     8f0:	4505                	li	a0,1
     8f2:	00000097          	auipc	ra,0x0
     8f6:	6d0080e7          	jalr	1744(ra) # fc2 <exit>
        printf("grind: write c failed\n");
     8fa:	00001517          	auipc	a0,0x1
     8fe:	dc650513          	addi	a0,a0,-570 # 16c0 <malloc+0x2a8>
     902:	00001097          	auipc	ra,0x1
     906:	a58080e7          	jalr	-1448(ra) # 135a <printf>
        exit(1,"");
     90a:	00001597          	auipc	a1,0x1
     90e:	d8e58593          	addi	a1,a1,-626 # 1698 <malloc+0x280>
     912:	4505                	li	a0,1
     914:	00000097          	auipc	ra,0x0
     918:	6ae080e7          	jalr	1710(ra) # fc2 <exit>
        printf("grind: fstat failed\n");
     91c:	00001517          	auipc	a0,0x1
     920:	dbc50513          	addi	a0,a0,-580 # 16d8 <malloc+0x2c0>
     924:	00001097          	auipc	ra,0x1
     928:	a36080e7          	jalr	-1482(ra) # 135a <printf>
        exit(1,"");
     92c:	00001597          	auipc	a1,0x1
     930:	d6c58593          	addi	a1,a1,-660 # 1698 <malloc+0x280>
     934:	4505                	li	a0,1
     936:	00000097          	auipc	ra,0x0
     93a:	68c080e7          	jalr	1676(ra) # fc2 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     93e:	2581                	sext.w	a1,a1
     940:	00001517          	auipc	a0,0x1
     944:	db050513          	addi	a0,a0,-592 # 16f0 <malloc+0x2d8>
     948:	00001097          	auipc	ra,0x1
     94c:	a12080e7          	jalr	-1518(ra) # 135a <printf>
        exit(1,"");
     950:	00001597          	auipc	a1,0x1
     954:	d4858593          	addi	a1,a1,-696 # 1698 <malloc+0x280>
     958:	4505                	li	a0,1
     95a:	00000097          	auipc	ra,0x0
     95e:	668080e7          	jalr	1640(ra) # fc2 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     962:	00001517          	auipc	a0,0x1
     966:	db650513          	addi	a0,a0,-586 # 1718 <malloc+0x300>
     96a:	00001097          	auipc	ra,0x1
     96e:	9f0080e7          	jalr	-1552(ra) # 135a <printf>
        exit(1,"");
     972:	00001597          	auipc	a1,0x1
     976:	d2658593          	addi	a1,a1,-730 # 1698 <malloc+0x280>
     97a:	4505                	li	a0,1
     97c:	00000097          	auipc	ra,0x0
     980:	646080e7          	jalr	1606(ra) # fc2 <exit>
        fprintf(2, "grind: pipe failed\n");
     984:	00001597          	auipc	a1,0x1
     988:	cbc58593          	addi	a1,a1,-836 # 1640 <malloc+0x228>
     98c:	4509                	li	a0,2
     98e:	00001097          	auipc	ra,0x1
     992:	99e080e7          	jalr	-1634(ra) # 132c <fprintf>
        exit(1,"");
     996:	00001597          	auipc	a1,0x1
     99a:	d0258593          	addi	a1,a1,-766 # 1698 <malloc+0x280>
     99e:	4505                	li	a0,1
     9a0:	00000097          	auipc	ra,0x0
     9a4:	622080e7          	jalr	1570(ra) # fc2 <exit>
        fprintf(2, "grind: pipe failed\n");
     9a8:	00001597          	auipc	a1,0x1
     9ac:	c9858593          	addi	a1,a1,-872 # 1640 <malloc+0x228>
     9b0:	4509                	li	a0,2
     9b2:	00001097          	auipc	ra,0x1
     9b6:	97a080e7          	jalr	-1670(ra) # 132c <fprintf>
        exit(1,"");
     9ba:	00001597          	auipc	a1,0x1
     9be:	cde58593          	addi	a1,a1,-802 # 1698 <malloc+0x280>
     9c2:	4505                	li	a0,1
     9c4:	00000097          	auipc	ra,0x0
     9c8:	5fe080e7          	jalr	1534(ra) # fc2 <exit>
        close(bb[0]);
     9cc:	fa042503          	lw	a0,-96(s0)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	61a080e7          	jalr	1562(ra) # fea <close>
        close(bb[1]);
     9d8:	fa442503          	lw	a0,-92(s0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	60e080e7          	jalr	1550(ra) # fea <close>
        close(aa[0]);
     9e4:	f9842503          	lw	a0,-104(s0)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	602080e7          	jalr	1538(ra) # fea <close>
        close(1);
     9f0:	4505                	li	a0,1
     9f2:	00000097          	auipc	ra,0x0
     9f6:	5f8080e7          	jalr	1528(ra) # fea <close>
        if(dup(aa[1]) != 1){
     9fa:	f9c42503          	lw	a0,-100(s0)
     9fe:	00000097          	auipc	ra,0x0
     a02:	63c080e7          	jalr	1596(ra) # 103a <dup>
     a06:	4785                	li	a5,1
     a08:	02f50463          	beq	a0,a5,a30 <go+0x9b8>
          fprintf(2, "grind: dup failed\n");
     a0c:	00001597          	auipc	a1,0x1
     a10:	d3458593          	addi	a1,a1,-716 # 1740 <malloc+0x328>
     a14:	4509                	li	a0,2
     a16:	00001097          	auipc	ra,0x1
     a1a:	916080e7          	jalr	-1770(ra) # 132c <fprintf>
          exit(1,"");
     a1e:	00001597          	auipc	a1,0x1
     a22:	c7a58593          	addi	a1,a1,-902 # 1698 <malloc+0x280>
     a26:	4505                	li	a0,1
     a28:	00000097          	auipc	ra,0x0
     a2c:	59a080e7          	jalr	1434(ra) # fc2 <exit>
        close(aa[1]);
     a30:	f9c42503          	lw	a0,-100(s0)
     a34:	00000097          	auipc	ra,0x0
     a38:	5b6080e7          	jalr	1462(ra) # fea <close>
        char *args[3] = { "echo", "hi", 0 };
     a3c:	00001797          	auipc	a5,0x1
     a40:	d1c78793          	addi	a5,a5,-740 # 1758 <malloc+0x340>
     a44:	faf43423          	sd	a5,-88(s0)
     a48:	00001797          	auipc	a5,0x1
     a4c:	d1878793          	addi	a5,a5,-744 # 1760 <malloc+0x348>
     a50:	faf43823          	sd	a5,-80(s0)
     a54:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     a58:	fa840593          	addi	a1,s0,-88
     a5c:	00001517          	auipc	a0,0x1
     a60:	d0c50513          	addi	a0,a0,-756 # 1768 <malloc+0x350>
     a64:	00000097          	auipc	ra,0x0
     a68:	596080e7          	jalr	1430(ra) # ffa <exec>
        fprintf(2, "grind: echo: not found\n");
     a6c:	00001597          	auipc	a1,0x1
     a70:	d0c58593          	addi	a1,a1,-756 # 1778 <malloc+0x360>
     a74:	4509                	li	a0,2
     a76:	00001097          	auipc	ra,0x1
     a7a:	8b6080e7          	jalr	-1866(ra) # 132c <fprintf>
        exit(2,"");
     a7e:	00001597          	auipc	a1,0x1
     a82:	c1a58593          	addi	a1,a1,-998 # 1698 <malloc+0x280>
     a86:	4509                	li	a0,2
     a88:	00000097          	auipc	ra,0x0
     a8c:	53a080e7          	jalr	1338(ra) # fc2 <exit>
        fprintf(2, "grind: fork failed\n");
     a90:	00001597          	auipc	a1,0x1
     a94:	b7058593          	addi	a1,a1,-1168 # 1600 <malloc+0x1e8>
     a98:	4509                	li	a0,2
     a9a:	00001097          	auipc	ra,0x1
     a9e:	892080e7          	jalr	-1902(ra) # 132c <fprintf>
        exit(3,"");
     aa2:	00001597          	auipc	a1,0x1
     aa6:	bf658593          	addi	a1,a1,-1034 # 1698 <malloc+0x280>
     aaa:	450d                	li	a0,3
     aac:	00000097          	auipc	ra,0x0
     ab0:	516080e7          	jalr	1302(ra) # fc2 <exit>
        close(aa[1]);
     ab4:	f9c42503          	lw	a0,-100(s0)
     ab8:	00000097          	auipc	ra,0x0
     abc:	532080e7          	jalr	1330(ra) # fea <close>
        close(bb[0]);
     ac0:	fa042503          	lw	a0,-96(s0)
     ac4:	00000097          	auipc	ra,0x0
     ac8:	526080e7          	jalr	1318(ra) # fea <close>
        close(0);
     acc:	4501                	li	a0,0
     ace:	00000097          	auipc	ra,0x0
     ad2:	51c080e7          	jalr	1308(ra) # fea <close>
        if(dup(aa[0]) != 0){
     ad6:	f9842503          	lw	a0,-104(s0)
     ada:	00000097          	auipc	ra,0x0
     ade:	560080e7          	jalr	1376(ra) # 103a <dup>
     ae2:	c11d                	beqz	a0,b08 <go+0xa90>
          fprintf(2, "grind: dup failed\n");
     ae4:	00001597          	auipc	a1,0x1
     ae8:	c5c58593          	addi	a1,a1,-932 # 1740 <malloc+0x328>
     aec:	4509                	li	a0,2
     aee:	00001097          	auipc	ra,0x1
     af2:	83e080e7          	jalr	-1986(ra) # 132c <fprintf>
          exit(4,"");
     af6:	00001597          	auipc	a1,0x1
     afa:	ba258593          	addi	a1,a1,-1118 # 1698 <malloc+0x280>
     afe:	4511                	li	a0,4
     b00:	00000097          	auipc	ra,0x0
     b04:	4c2080e7          	jalr	1218(ra) # fc2 <exit>
        close(aa[0]);
     b08:	f9842503          	lw	a0,-104(s0)
     b0c:	00000097          	auipc	ra,0x0
     b10:	4de080e7          	jalr	1246(ra) # fea <close>
        close(1);
     b14:	4505                	li	a0,1
     b16:	00000097          	auipc	ra,0x0
     b1a:	4d4080e7          	jalr	1236(ra) # fea <close>
        if(dup(bb[1]) != 1){
     b1e:	fa442503          	lw	a0,-92(s0)
     b22:	00000097          	auipc	ra,0x0
     b26:	518080e7          	jalr	1304(ra) # 103a <dup>
     b2a:	4785                	li	a5,1
     b2c:	02f50463          	beq	a0,a5,b54 <go+0xadc>
          fprintf(2, "grind: dup failed\n");
     b30:	00001597          	auipc	a1,0x1
     b34:	c1058593          	addi	a1,a1,-1008 # 1740 <malloc+0x328>
     b38:	4509                	li	a0,2
     b3a:	00000097          	auipc	ra,0x0
     b3e:	7f2080e7          	jalr	2034(ra) # 132c <fprintf>
          exit(5,"");
     b42:	00001597          	auipc	a1,0x1
     b46:	b5658593          	addi	a1,a1,-1194 # 1698 <malloc+0x280>
     b4a:	4515                	li	a0,5
     b4c:	00000097          	auipc	ra,0x0
     b50:	476080e7          	jalr	1142(ra) # fc2 <exit>
        close(bb[1]);
     b54:	fa442503          	lw	a0,-92(s0)
     b58:	00000097          	auipc	ra,0x0
     b5c:	492080e7          	jalr	1170(ra) # fea <close>
        char *args[2] = { "cat", 0 };
     b60:	00001797          	auipc	a5,0x1
     b64:	c3078793          	addi	a5,a5,-976 # 1790 <malloc+0x378>
     b68:	faf43423          	sd	a5,-88(s0)
     b6c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     b70:	fa840593          	addi	a1,s0,-88
     b74:	00001517          	auipc	a0,0x1
     b78:	c2450513          	addi	a0,a0,-988 # 1798 <malloc+0x380>
     b7c:	00000097          	auipc	ra,0x0
     b80:	47e080e7          	jalr	1150(ra) # ffa <exec>
        fprintf(2, "grind: cat: not found\n");
     b84:	00001597          	auipc	a1,0x1
     b88:	c1c58593          	addi	a1,a1,-996 # 17a0 <malloc+0x388>
     b8c:	4509                	li	a0,2
     b8e:	00000097          	auipc	ra,0x0
     b92:	79e080e7          	jalr	1950(ra) # 132c <fprintf>
        exit(6,"");
     b96:	00001597          	auipc	a1,0x1
     b9a:	b0258593          	addi	a1,a1,-1278 # 1698 <malloc+0x280>
     b9e:	4519                	li	a0,6
     ba0:	00000097          	auipc	ra,0x0
     ba4:	422080e7          	jalr	1058(ra) # fc2 <exit>
        fprintf(2, "grind: fork failed\n");
     ba8:	00001597          	auipc	a1,0x1
     bac:	a5858593          	addi	a1,a1,-1448 # 1600 <malloc+0x1e8>
     bb0:	4509                	li	a0,2
     bb2:	00000097          	auipc	ra,0x0
     bb6:	77a080e7          	jalr	1914(ra) # 132c <fprintf>
        exit(7,"");
     bba:	00001597          	auipc	a1,0x1
     bbe:	ade58593          	addi	a1,a1,-1314 # 1698 <malloc+0x280>
     bc2:	451d                	li	a0,7
     bc4:	00000097          	auipc	ra,0x0
     bc8:	3fe080e7          	jalr	1022(ra) # fc2 <exit>

0000000000000bcc <iter>:
  }
}

void
iter()
{
     bcc:	7179                	addi	sp,sp,-48
     bce:	f406                	sd	ra,40(sp)
     bd0:	f022                	sd	s0,32(sp)
     bd2:	ec26                	sd	s1,24(sp)
     bd4:	e84a                	sd	s2,16(sp)
     bd6:	1800                	addi	s0,sp,48
  unlink("a");
     bd8:	00001517          	auipc	a0,0x1
     bdc:	a0850513          	addi	a0,a0,-1528 # 15e0 <malloc+0x1c8>
     be0:	00000097          	auipc	ra,0x0
     be4:	432080e7          	jalr	1074(ra) # 1012 <unlink>
  unlink("b");
     be8:	00001517          	auipc	a0,0x1
     bec:	9a850513          	addi	a0,a0,-1624 # 1590 <malloc+0x178>
     bf0:	00000097          	auipc	ra,0x0
     bf4:	422080e7          	jalr	1058(ra) # 1012 <unlink>
  
  int pid1 = fork();
     bf8:	00000097          	auipc	ra,0x0
     bfc:	3c2080e7          	jalr	962(ra) # fba <fork>
  if(pid1 < 0){
     c00:	02054163          	bltz	a0,c22 <iter+0x56>
     c04:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1,"");
  }
  if(pid1 == 0){
     c06:	ed1d                	bnez	a0,c44 <iter+0x78>
    rand_next ^= 31;
     c08:	00001717          	auipc	a4,0x1
     c0c:	3f870713          	addi	a4,a4,1016 # 2000 <rand_next>
     c10:	631c                	ld	a5,0(a4)
     c12:	01f7c793          	xori	a5,a5,31
     c16:	e31c                	sd	a5,0(a4)
    go(0);
     c18:	4501                	li	a0,0
     c1a:	fffff097          	auipc	ra,0xfffff
     c1e:	45e080e7          	jalr	1118(ra) # 78 <go>
    printf("grind: fork failed\n");
     c22:	00001517          	auipc	a0,0x1
     c26:	9de50513          	addi	a0,a0,-1570 # 1600 <malloc+0x1e8>
     c2a:	00000097          	auipc	ra,0x0
     c2e:	730080e7          	jalr	1840(ra) # 135a <printf>
    exit(1,"");
     c32:	00001597          	auipc	a1,0x1
     c36:	a6658593          	addi	a1,a1,-1434 # 1698 <malloc+0x280>
     c3a:	4505                	li	a0,1
     c3c:	00000097          	auipc	ra,0x0
     c40:	386080e7          	jalr	902(ra) # fc2 <exit>
    exit(0,"");
  }

  int pid2 = fork();
     c44:	00000097          	auipc	ra,0x0
     c48:	376080e7          	jalr	886(ra) # fba <fork>
     c4c:	892a                	mv	s2,a0
  if(pid2 < 0){
     c4e:	02054263          	bltz	a0,c72 <iter+0xa6>
    printf("grind: fork failed\n");
    exit(1,"");
  }
  if(pid2 == 0){
     c52:	e129                	bnez	a0,c94 <iter+0xc8>
    rand_next ^= 7177;
     c54:	00001697          	auipc	a3,0x1
     c58:	3ac68693          	addi	a3,a3,940 # 2000 <rand_next>
     c5c:	629c                	ld	a5,0(a3)
     c5e:	6709                	lui	a4,0x2
     c60:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x419>
     c64:	8fb9                	xor	a5,a5,a4
     c66:	e29c                	sd	a5,0(a3)
    go(1);
     c68:	4505                	li	a0,1
     c6a:	fffff097          	auipc	ra,0xfffff
     c6e:	40e080e7          	jalr	1038(ra) # 78 <go>
    printf("grind: fork failed\n");
     c72:	00001517          	auipc	a0,0x1
     c76:	98e50513          	addi	a0,a0,-1650 # 1600 <malloc+0x1e8>
     c7a:	00000097          	auipc	ra,0x0
     c7e:	6e0080e7          	jalr	1760(ra) # 135a <printf>
    exit(1,"");
     c82:	00001597          	auipc	a1,0x1
     c86:	a1658593          	addi	a1,a1,-1514 # 1698 <malloc+0x280>
     c8a:	4505                	li	a0,1
     c8c:	00000097          	auipc	ra,0x0
     c90:	336080e7          	jalr	822(ra) # fc2 <exit>
    exit(0,"");
  }

  int st1 = -1;
     c94:	57fd                	li	a5,-1
     c96:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1,0);
     c9a:	4581                	li	a1,0
     c9c:	fdc40513          	addi	a0,s0,-36
     ca0:	00000097          	auipc	ra,0x0
     ca4:	32a080e7          	jalr	810(ra) # fca <wait>
  if(st1 != 0){
     ca8:	fdc42783          	lw	a5,-36(s0)
     cac:	e785                	bnez	a5,cd4 <iter+0x108>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     cae:	57fd                	li	a5,-1
     cb0:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2,0);
     cb4:	4581                	li	a1,0
     cb6:	fd840513          	addi	a0,s0,-40
     cba:	00000097          	auipc	ra,0x0
     cbe:	310080e7          	jalr	784(ra) # fca <wait>

  exit(0,"");
     cc2:	00001597          	auipc	a1,0x1
     cc6:	9d658593          	addi	a1,a1,-1578 # 1698 <malloc+0x280>
     cca:	4501                	li	a0,0
     ccc:	00000097          	auipc	ra,0x0
     cd0:	2f6080e7          	jalr	758(ra) # fc2 <exit>
    kill(pid1);
     cd4:	8526                	mv	a0,s1
     cd6:	00000097          	auipc	ra,0x0
     cda:	31c080e7          	jalr	796(ra) # ff2 <kill>
    kill(pid2);
     cde:	854a                	mv	a0,s2
     ce0:	00000097          	auipc	ra,0x0
     ce4:	312080e7          	jalr	786(ra) # ff2 <kill>
     ce8:	b7d9                	j	cae <iter+0xe2>

0000000000000cea <main>:
}

int
main()
{
     cea:	1101                	addi	sp,sp,-32
     cec:	ec06                	sd	ra,24(sp)
     cee:	e822                	sd	s0,16(sp)
     cf0:	e426                	sd	s1,8(sp)
     cf2:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0,0);
    }
    sleep(20);
    rand_next += 1;
     cf4:	00001497          	auipc	s1,0x1
     cf8:	30c48493          	addi	s1,s1,780 # 2000 <rand_next>
     cfc:	a829                	j	d16 <main+0x2c>
      iter();
     cfe:	00000097          	auipc	ra,0x0
     d02:	ece080e7          	jalr	-306(ra) # bcc <iter>
    sleep(20);
     d06:	4551                	li	a0,20
     d08:	00000097          	auipc	ra,0x0
     d0c:	34a080e7          	jalr	842(ra) # 1052 <sleep>
    rand_next += 1;
     d10:	609c                	ld	a5,0(s1)
     d12:	0785                	addi	a5,a5,1
     d14:	e09c                	sd	a5,0(s1)
    int pid = fork();
     d16:	00000097          	auipc	ra,0x0
     d1a:	2a4080e7          	jalr	676(ra) # fba <fork>
    if(pid == 0){
     d1e:	d165                	beqz	a0,cfe <main+0x14>
    if(pid > 0){
     d20:	fea053e3          	blez	a0,d06 <main+0x1c>
      wait(0,0);
     d24:	4581                	li	a1,0
     d26:	4501                	li	a0,0
     d28:	00000097          	auipc	ra,0x0
     d2c:	2a2080e7          	jalr	674(ra) # fca <wait>
     d30:	bfd9                	j	d06 <main+0x1c>

0000000000000d32 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     d32:	1141                	addi	sp,sp,-16
     d34:	e406                	sd	ra,8(sp)
     d36:	e022                	sd	s0,0(sp)
     d38:	0800                	addi	s0,sp,16
  extern int main();
  main();
     d3a:	00000097          	auipc	ra,0x0
     d3e:	fb0080e7          	jalr	-80(ra) # cea <main>
  exit(0,"");
     d42:	00001597          	auipc	a1,0x1
     d46:	95658593          	addi	a1,a1,-1706 # 1698 <malloc+0x280>
     d4a:	4501                	li	a0,0
     d4c:	00000097          	auipc	ra,0x0
     d50:	276080e7          	jalr	630(ra) # fc2 <exit>

0000000000000d54 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     d54:	1141                	addi	sp,sp,-16
     d56:	e422                	sd	s0,8(sp)
     d58:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     d5a:	87aa                	mv	a5,a0
     d5c:	0585                	addi	a1,a1,1
     d5e:	0785                	addi	a5,a5,1
     d60:	fff5c703          	lbu	a4,-1(a1)
     d64:	fee78fa3          	sb	a4,-1(a5)
     d68:	fb75                	bnez	a4,d5c <strcpy+0x8>
    ;
  return os;
}
     d6a:	6422                	ld	s0,8(sp)
     d6c:	0141                	addi	sp,sp,16
     d6e:	8082                	ret

0000000000000d70 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d70:	1141                	addi	sp,sp,-16
     d72:	e422                	sd	s0,8(sp)
     d74:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     d76:	00054783          	lbu	a5,0(a0)
     d7a:	cb91                	beqz	a5,d8e <strcmp+0x1e>
     d7c:	0005c703          	lbu	a4,0(a1)
     d80:	00f71763          	bne	a4,a5,d8e <strcmp+0x1e>
    p++, q++;
     d84:	0505                	addi	a0,a0,1
     d86:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     d88:	00054783          	lbu	a5,0(a0)
     d8c:	fbe5                	bnez	a5,d7c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     d8e:	0005c503          	lbu	a0,0(a1)
}
     d92:	40a7853b          	subw	a0,a5,a0
     d96:	6422                	ld	s0,8(sp)
     d98:	0141                	addi	sp,sp,16
     d9a:	8082                	ret

0000000000000d9c <strlen>:

uint
strlen(const char *s)
{
     d9c:	1141                	addi	sp,sp,-16
     d9e:	e422                	sd	s0,8(sp)
     da0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     da2:	00054783          	lbu	a5,0(a0)
     da6:	cf91                	beqz	a5,dc2 <strlen+0x26>
     da8:	0505                	addi	a0,a0,1
     daa:	87aa                	mv	a5,a0
     dac:	4685                	li	a3,1
     dae:	9e89                	subw	a3,a3,a0
     db0:	00f6853b          	addw	a0,a3,a5
     db4:	0785                	addi	a5,a5,1
     db6:	fff7c703          	lbu	a4,-1(a5)
     dba:	fb7d                	bnez	a4,db0 <strlen+0x14>
    ;
  return n;
}
     dbc:	6422                	ld	s0,8(sp)
     dbe:	0141                	addi	sp,sp,16
     dc0:	8082                	ret
  for(n = 0; s[n]; n++)
     dc2:	4501                	li	a0,0
     dc4:	bfe5                	j	dbc <strlen+0x20>

0000000000000dc6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     dc6:	1141                	addi	sp,sp,-16
     dc8:	e422                	sd	s0,8(sp)
     dca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     dcc:	ca19                	beqz	a2,de2 <memset+0x1c>
     dce:	87aa                	mv	a5,a0
     dd0:	1602                	slli	a2,a2,0x20
     dd2:	9201                	srli	a2,a2,0x20
     dd4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     dd8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     ddc:	0785                	addi	a5,a5,1
     dde:	fee79de3          	bne	a5,a4,dd8 <memset+0x12>
  }
  return dst;
}
     de2:	6422                	ld	s0,8(sp)
     de4:	0141                	addi	sp,sp,16
     de6:	8082                	ret

0000000000000de8 <strchr>:

char*
strchr(const char *s, char c)
{
     de8:	1141                	addi	sp,sp,-16
     dea:	e422                	sd	s0,8(sp)
     dec:	0800                	addi	s0,sp,16
  for(; *s; s++)
     dee:	00054783          	lbu	a5,0(a0)
     df2:	cb99                	beqz	a5,e08 <strchr+0x20>
    if(*s == c)
     df4:	00f58763          	beq	a1,a5,e02 <strchr+0x1a>
  for(; *s; s++)
     df8:	0505                	addi	a0,a0,1
     dfa:	00054783          	lbu	a5,0(a0)
     dfe:	fbfd                	bnez	a5,df4 <strchr+0xc>
      return (char*)s;
  return 0;
     e00:	4501                	li	a0,0
}
     e02:	6422                	ld	s0,8(sp)
     e04:	0141                	addi	sp,sp,16
     e06:	8082                	ret
  return 0;
     e08:	4501                	li	a0,0
     e0a:	bfe5                	j	e02 <strchr+0x1a>

0000000000000e0c <gets>:

char*
gets(char *buf, int max)
{
     e0c:	711d                	addi	sp,sp,-96
     e0e:	ec86                	sd	ra,88(sp)
     e10:	e8a2                	sd	s0,80(sp)
     e12:	e4a6                	sd	s1,72(sp)
     e14:	e0ca                	sd	s2,64(sp)
     e16:	fc4e                	sd	s3,56(sp)
     e18:	f852                	sd	s4,48(sp)
     e1a:	f456                	sd	s5,40(sp)
     e1c:	f05a                	sd	s6,32(sp)
     e1e:	ec5e                	sd	s7,24(sp)
     e20:	1080                	addi	s0,sp,96
     e22:	8baa                	mv	s7,a0
     e24:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e26:	892a                	mv	s2,a0
     e28:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     e2a:	4aa9                	li	s5,10
     e2c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     e2e:	89a6                	mv	s3,s1
     e30:	2485                	addiw	s1,s1,1
     e32:	0344d863          	bge	s1,s4,e62 <gets+0x56>
    cc = read(0, &c, 1);
     e36:	4605                	li	a2,1
     e38:	faf40593          	addi	a1,s0,-81
     e3c:	4501                	li	a0,0
     e3e:	00000097          	auipc	ra,0x0
     e42:	19c080e7          	jalr	412(ra) # fda <read>
    if(cc < 1)
     e46:	00a05e63          	blez	a0,e62 <gets+0x56>
    buf[i++] = c;
     e4a:	faf44783          	lbu	a5,-81(s0)
     e4e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     e52:	01578763          	beq	a5,s5,e60 <gets+0x54>
     e56:	0905                	addi	s2,s2,1
     e58:	fd679be3          	bne	a5,s6,e2e <gets+0x22>
  for(i=0; i+1 < max; ){
     e5c:	89a6                	mv	s3,s1
     e5e:	a011                	j	e62 <gets+0x56>
     e60:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     e62:	99de                	add	s3,s3,s7
     e64:	00098023          	sb	zero,0(s3)
  return buf;
}
     e68:	855e                	mv	a0,s7
     e6a:	60e6                	ld	ra,88(sp)
     e6c:	6446                	ld	s0,80(sp)
     e6e:	64a6                	ld	s1,72(sp)
     e70:	6906                	ld	s2,64(sp)
     e72:	79e2                	ld	s3,56(sp)
     e74:	7a42                	ld	s4,48(sp)
     e76:	7aa2                	ld	s5,40(sp)
     e78:	7b02                	ld	s6,32(sp)
     e7a:	6be2                	ld	s7,24(sp)
     e7c:	6125                	addi	sp,sp,96
     e7e:	8082                	ret

0000000000000e80 <stat>:

int
stat(const char *n, struct stat *st)
{
     e80:	1101                	addi	sp,sp,-32
     e82:	ec06                	sd	ra,24(sp)
     e84:	e822                	sd	s0,16(sp)
     e86:	e426                	sd	s1,8(sp)
     e88:	e04a                	sd	s2,0(sp)
     e8a:	1000                	addi	s0,sp,32
     e8c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e8e:	4581                	li	a1,0
     e90:	00000097          	auipc	ra,0x0
     e94:	172080e7          	jalr	370(ra) # 1002 <open>
  if(fd < 0)
     e98:	02054563          	bltz	a0,ec2 <stat+0x42>
     e9c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e9e:	85ca                	mv	a1,s2
     ea0:	00000097          	auipc	ra,0x0
     ea4:	17a080e7          	jalr	378(ra) # 101a <fstat>
     ea8:	892a                	mv	s2,a0
  close(fd);
     eaa:	8526                	mv	a0,s1
     eac:	00000097          	auipc	ra,0x0
     eb0:	13e080e7          	jalr	318(ra) # fea <close>
  return r;
}
     eb4:	854a                	mv	a0,s2
     eb6:	60e2                	ld	ra,24(sp)
     eb8:	6442                	ld	s0,16(sp)
     eba:	64a2                	ld	s1,8(sp)
     ebc:	6902                	ld	s2,0(sp)
     ebe:	6105                	addi	sp,sp,32
     ec0:	8082                	ret
    return -1;
     ec2:	597d                	li	s2,-1
     ec4:	bfc5                	j	eb4 <stat+0x34>

0000000000000ec6 <atoi>:

int
atoi(const char *s)
{
     ec6:	1141                	addi	sp,sp,-16
     ec8:	e422                	sd	s0,8(sp)
     eca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ecc:	00054603          	lbu	a2,0(a0)
     ed0:	fd06079b          	addiw	a5,a2,-48
     ed4:	0ff7f793          	andi	a5,a5,255
     ed8:	4725                	li	a4,9
     eda:	02f76963          	bltu	a4,a5,f0c <atoi+0x46>
     ede:	86aa                	mv	a3,a0
  n = 0;
     ee0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     ee2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     ee4:	0685                	addi	a3,a3,1
     ee6:	0025179b          	slliw	a5,a0,0x2
     eea:	9fa9                	addw	a5,a5,a0
     eec:	0017979b          	slliw	a5,a5,0x1
     ef0:	9fb1                	addw	a5,a5,a2
     ef2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ef6:	0006c603          	lbu	a2,0(a3)
     efa:	fd06071b          	addiw	a4,a2,-48
     efe:	0ff77713          	andi	a4,a4,255
     f02:	fee5f1e3          	bgeu	a1,a4,ee4 <atoi+0x1e>
  return n;
}
     f06:	6422                	ld	s0,8(sp)
     f08:	0141                	addi	sp,sp,16
     f0a:	8082                	ret
  n = 0;
     f0c:	4501                	li	a0,0
     f0e:	bfe5                	j	f06 <atoi+0x40>

0000000000000f10 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     f10:	1141                	addi	sp,sp,-16
     f12:	e422                	sd	s0,8(sp)
     f14:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     f16:	02b57463          	bgeu	a0,a1,f3e <memmove+0x2e>
    while(n-- > 0)
     f1a:	00c05f63          	blez	a2,f38 <memmove+0x28>
     f1e:	1602                	slli	a2,a2,0x20
     f20:	9201                	srli	a2,a2,0x20
     f22:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     f26:	872a                	mv	a4,a0
      *dst++ = *src++;
     f28:	0585                	addi	a1,a1,1
     f2a:	0705                	addi	a4,a4,1
     f2c:	fff5c683          	lbu	a3,-1(a1)
     f30:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     f34:	fee79ae3          	bne	a5,a4,f28 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     f38:	6422                	ld	s0,8(sp)
     f3a:	0141                	addi	sp,sp,16
     f3c:	8082                	ret
    dst += n;
     f3e:	00c50733          	add	a4,a0,a2
    src += n;
     f42:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     f44:	fec05ae3          	blez	a2,f38 <memmove+0x28>
     f48:	fff6079b          	addiw	a5,a2,-1
     f4c:	1782                	slli	a5,a5,0x20
     f4e:	9381                	srli	a5,a5,0x20
     f50:	fff7c793          	not	a5,a5
     f54:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     f56:	15fd                	addi	a1,a1,-1
     f58:	177d                	addi	a4,a4,-1
     f5a:	0005c683          	lbu	a3,0(a1)
     f5e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     f62:	fee79ae3          	bne	a5,a4,f56 <memmove+0x46>
     f66:	bfc9                	j	f38 <memmove+0x28>

0000000000000f68 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     f68:	1141                	addi	sp,sp,-16
     f6a:	e422                	sd	s0,8(sp)
     f6c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     f6e:	ca05                	beqz	a2,f9e <memcmp+0x36>
     f70:	fff6069b          	addiw	a3,a2,-1
     f74:	1682                	slli	a3,a3,0x20
     f76:	9281                	srli	a3,a3,0x20
     f78:	0685                	addi	a3,a3,1
     f7a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     f7c:	00054783          	lbu	a5,0(a0)
     f80:	0005c703          	lbu	a4,0(a1)
     f84:	00e79863          	bne	a5,a4,f94 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     f88:	0505                	addi	a0,a0,1
    p2++;
     f8a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     f8c:	fed518e3          	bne	a0,a3,f7c <memcmp+0x14>
  }
  return 0;
     f90:	4501                	li	a0,0
     f92:	a019                	j	f98 <memcmp+0x30>
      return *p1 - *p2;
     f94:	40e7853b          	subw	a0,a5,a4
}
     f98:	6422                	ld	s0,8(sp)
     f9a:	0141                	addi	sp,sp,16
     f9c:	8082                	ret
  return 0;
     f9e:	4501                	li	a0,0
     fa0:	bfe5                	j	f98 <memcmp+0x30>

0000000000000fa2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     fa2:	1141                	addi	sp,sp,-16
     fa4:	e406                	sd	ra,8(sp)
     fa6:	e022                	sd	s0,0(sp)
     fa8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     faa:	00000097          	auipc	ra,0x0
     fae:	f66080e7          	jalr	-154(ra) # f10 <memmove>
}
     fb2:	60a2                	ld	ra,8(sp)
     fb4:	6402                	ld	s0,0(sp)
     fb6:	0141                	addi	sp,sp,16
     fb8:	8082                	ret

0000000000000fba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     fba:	4885                	li	a7,1
 ecall
     fbc:	00000073          	ecall
 ret
     fc0:	8082                	ret

0000000000000fc2 <exit>:
.global exit
exit:
 li a7, SYS_exit
     fc2:	4889                	li	a7,2
 ecall
     fc4:	00000073          	ecall
 ret
     fc8:	8082                	ret

0000000000000fca <wait>:
.global wait
wait:
 li a7, SYS_wait
     fca:	488d                	li	a7,3
 ecall
     fcc:	00000073          	ecall
 ret
     fd0:	8082                	ret

0000000000000fd2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     fd2:	4891                	li	a7,4
 ecall
     fd4:	00000073          	ecall
 ret
     fd8:	8082                	ret

0000000000000fda <read>:
.global read
read:
 li a7, SYS_read
     fda:	4895                	li	a7,5
 ecall
     fdc:	00000073          	ecall
 ret
     fe0:	8082                	ret

0000000000000fe2 <write>:
.global write
write:
 li a7, SYS_write
     fe2:	48c1                	li	a7,16
 ecall
     fe4:	00000073          	ecall
 ret
     fe8:	8082                	ret

0000000000000fea <close>:
.global close
close:
 li a7, SYS_close
     fea:	48d5                	li	a7,21
 ecall
     fec:	00000073          	ecall
 ret
     ff0:	8082                	ret

0000000000000ff2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ff2:	4899                	li	a7,6
 ecall
     ff4:	00000073          	ecall
 ret
     ff8:	8082                	ret

0000000000000ffa <exec>:
.global exec
exec:
 li a7, SYS_exec
     ffa:	489d                	li	a7,7
 ecall
     ffc:	00000073          	ecall
 ret
    1000:	8082                	ret

0000000000001002 <open>:
.global open
open:
 li a7, SYS_open
    1002:	48bd                	li	a7,15
 ecall
    1004:	00000073          	ecall
 ret
    1008:	8082                	ret

000000000000100a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    100a:	48c5                	li	a7,17
 ecall
    100c:	00000073          	ecall
 ret
    1010:	8082                	ret

0000000000001012 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1012:	48c9                	li	a7,18
 ecall
    1014:	00000073          	ecall
 ret
    1018:	8082                	ret

000000000000101a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    101a:	48a1                	li	a7,8
 ecall
    101c:	00000073          	ecall
 ret
    1020:	8082                	ret

0000000000001022 <link>:
.global link
link:
 li a7, SYS_link
    1022:	48cd                	li	a7,19
 ecall
    1024:	00000073          	ecall
 ret
    1028:	8082                	ret

000000000000102a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    102a:	48d1                	li	a7,20
 ecall
    102c:	00000073          	ecall
 ret
    1030:	8082                	ret

0000000000001032 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1032:	48a5                	li	a7,9
 ecall
    1034:	00000073          	ecall
 ret
    1038:	8082                	ret

000000000000103a <dup>:
.global dup
dup:
 li a7, SYS_dup
    103a:	48a9                	li	a7,10
 ecall
    103c:	00000073          	ecall
 ret
    1040:	8082                	ret

0000000000001042 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1042:	48ad                	li	a7,11
 ecall
    1044:	00000073          	ecall
 ret
    1048:	8082                	ret

000000000000104a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    104a:	48b1                	li	a7,12
 ecall
    104c:	00000073          	ecall
 ret
    1050:	8082                	ret

0000000000001052 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1052:	48b5                	li	a7,13
 ecall
    1054:	00000073          	ecall
 ret
    1058:	8082                	ret

000000000000105a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    105a:	48b9                	li	a7,14
 ecall
    105c:	00000073          	ecall
 ret
    1060:	8082                	ret

0000000000001062 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
    1062:	48d9                	li	a7,22
 ecall
    1064:	00000073          	ecall
 ret
    1068:	8082                	ret

000000000000106a <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
    106a:	48dd                	li	a7,23
 ecall
    106c:	00000073          	ecall
 ret
    1070:	8082                	ret

0000000000001072 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
    1072:	48e1                	li	a7,24
 ecall
    1074:	00000073          	ecall
 ret
    1078:	8082                	ret

000000000000107a <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
    107a:	48e5                	li	a7,25
 ecall
    107c:	00000073          	ecall
 ret
    1080:	8082                	ret

0000000000001082 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1082:	1101                	addi	sp,sp,-32
    1084:	ec06                	sd	ra,24(sp)
    1086:	e822                	sd	s0,16(sp)
    1088:	1000                	addi	s0,sp,32
    108a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    108e:	4605                	li	a2,1
    1090:	fef40593          	addi	a1,s0,-17
    1094:	00000097          	auipc	ra,0x0
    1098:	f4e080e7          	jalr	-178(ra) # fe2 <write>
}
    109c:	60e2                	ld	ra,24(sp)
    109e:	6442                	ld	s0,16(sp)
    10a0:	6105                	addi	sp,sp,32
    10a2:	8082                	ret

00000000000010a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    10a4:	7139                	addi	sp,sp,-64
    10a6:	fc06                	sd	ra,56(sp)
    10a8:	f822                	sd	s0,48(sp)
    10aa:	f426                	sd	s1,40(sp)
    10ac:	f04a                	sd	s2,32(sp)
    10ae:	ec4e                	sd	s3,24(sp)
    10b0:	0080                	addi	s0,sp,64
    10b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    10b4:	c299                	beqz	a3,10ba <printint+0x16>
    10b6:	0805c863          	bltz	a1,1146 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    10ba:	2581                	sext.w	a1,a1
  neg = 0;
    10bc:	4881                	li	a7,0
    10be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    10c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    10c4:	2601                	sext.w	a2,a2
    10c6:	00000517          	auipc	a0,0x0
    10ca:	72a50513          	addi	a0,a0,1834 # 17f0 <digits>
    10ce:	883a                	mv	a6,a4
    10d0:	2705                	addiw	a4,a4,1
    10d2:	02c5f7bb          	remuw	a5,a1,a2
    10d6:	1782                	slli	a5,a5,0x20
    10d8:	9381                	srli	a5,a5,0x20
    10da:	97aa                	add	a5,a5,a0
    10dc:	0007c783          	lbu	a5,0(a5)
    10e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    10e4:	0005879b          	sext.w	a5,a1
    10e8:	02c5d5bb          	divuw	a1,a1,a2
    10ec:	0685                	addi	a3,a3,1
    10ee:	fec7f0e3          	bgeu	a5,a2,10ce <printint+0x2a>
  if(neg)
    10f2:	00088b63          	beqz	a7,1108 <printint+0x64>
    buf[i++] = '-';
    10f6:	fd040793          	addi	a5,s0,-48
    10fa:	973e                	add	a4,a4,a5
    10fc:	02d00793          	li	a5,45
    1100:	fef70823          	sb	a5,-16(a4)
    1104:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1108:	02e05863          	blez	a4,1138 <printint+0x94>
    110c:	fc040793          	addi	a5,s0,-64
    1110:	00e78933          	add	s2,a5,a4
    1114:	fff78993          	addi	s3,a5,-1
    1118:	99ba                	add	s3,s3,a4
    111a:	377d                	addiw	a4,a4,-1
    111c:	1702                	slli	a4,a4,0x20
    111e:	9301                	srli	a4,a4,0x20
    1120:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1124:	fff94583          	lbu	a1,-1(s2)
    1128:	8526                	mv	a0,s1
    112a:	00000097          	auipc	ra,0x0
    112e:	f58080e7          	jalr	-168(ra) # 1082 <putc>
  while(--i >= 0)
    1132:	197d                	addi	s2,s2,-1
    1134:	ff3918e3          	bne	s2,s3,1124 <printint+0x80>
}
    1138:	70e2                	ld	ra,56(sp)
    113a:	7442                	ld	s0,48(sp)
    113c:	74a2                	ld	s1,40(sp)
    113e:	7902                	ld	s2,32(sp)
    1140:	69e2                	ld	s3,24(sp)
    1142:	6121                	addi	sp,sp,64
    1144:	8082                	ret
    x = -xx;
    1146:	40b005bb          	negw	a1,a1
    neg = 1;
    114a:	4885                	li	a7,1
    x = -xx;
    114c:	bf8d                	j	10be <printint+0x1a>

000000000000114e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    114e:	7119                	addi	sp,sp,-128
    1150:	fc86                	sd	ra,120(sp)
    1152:	f8a2                	sd	s0,112(sp)
    1154:	f4a6                	sd	s1,104(sp)
    1156:	f0ca                	sd	s2,96(sp)
    1158:	ecce                	sd	s3,88(sp)
    115a:	e8d2                	sd	s4,80(sp)
    115c:	e4d6                	sd	s5,72(sp)
    115e:	e0da                	sd	s6,64(sp)
    1160:	fc5e                	sd	s7,56(sp)
    1162:	f862                	sd	s8,48(sp)
    1164:	f466                	sd	s9,40(sp)
    1166:	f06a                	sd	s10,32(sp)
    1168:	ec6e                	sd	s11,24(sp)
    116a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    116c:	0005c903          	lbu	s2,0(a1)
    1170:	18090f63          	beqz	s2,130e <vprintf+0x1c0>
    1174:	8aaa                	mv	s5,a0
    1176:	8b32                	mv	s6,a2
    1178:	00158493          	addi	s1,a1,1
  state = 0;
    117c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    117e:	02500a13          	li	s4,37
      if(c == 'd'){
    1182:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1186:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    118a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    118e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1192:	00000b97          	auipc	s7,0x0
    1196:	65eb8b93          	addi	s7,s7,1630 # 17f0 <digits>
    119a:	a839                	j	11b8 <vprintf+0x6a>
        putc(fd, c);
    119c:	85ca                	mv	a1,s2
    119e:	8556                	mv	a0,s5
    11a0:	00000097          	auipc	ra,0x0
    11a4:	ee2080e7          	jalr	-286(ra) # 1082 <putc>
    11a8:	a019                	j	11ae <vprintf+0x60>
    } else if(state == '%'){
    11aa:	01498f63          	beq	s3,s4,11c8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    11ae:	0485                	addi	s1,s1,1
    11b0:	fff4c903          	lbu	s2,-1(s1)
    11b4:	14090d63          	beqz	s2,130e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    11b8:	0009079b          	sext.w	a5,s2
    if(state == 0){
    11bc:	fe0997e3          	bnez	s3,11aa <vprintf+0x5c>
      if(c == '%'){
    11c0:	fd479ee3          	bne	a5,s4,119c <vprintf+0x4e>
        state = '%';
    11c4:	89be                	mv	s3,a5
    11c6:	b7e5                	j	11ae <vprintf+0x60>
      if(c == 'd'){
    11c8:	05878063          	beq	a5,s8,1208 <vprintf+0xba>
      } else if(c == 'l') {
    11cc:	05978c63          	beq	a5,s9,1224 <vprintf+0xd6>
      } else if(c == 'x') {
    11d0:	07a78863          	beq	a5,s10,1240 <vprintf+0xf2>
      } else if(c == 'p') {
    11d4:	09b78463          	beq	a5,s11,125c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    11d8:	07300713          	li	a4,115
    11dc:	0ce78663          	beq	a5,a4,12a8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    11e0:	06300713          	li	a4,99
    11e4:	0ee78e63          	beq	a5,a4,12e0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    11e8:	11478863          	beq	a5,s4,12f8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11ec:	85d2                	mv	a1,s4
    11ee:	8556                	mv	a0,s5
    11f0:	00000097          	auipc	ra,0x0
    11f4:	e92080e7          	jalr	-366(ra) # 1082 <putc>
        putc(fd, c);
    11f8:	85ca                	mv	a1,s2
    11fa:	8556                	mv	a0,s5
    11fc:	00000097          	auipc	ra,0x0
    1200:	e86080e7          	jalr	-378(ra) # 1082 <putc>
      }
      state = 0;
    1204:	4981                	li	s3,0
    1206:	b765                	j	11ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    1208:	008b0913          	addi	s2,s6,8
    120c:	4685                	li	a3,1
    120e:	4629                	li	a2,10
    1210:	000b2583          	lw	a1,0(s6)
    1214:	8556                	mv	a0,s5
    1216:	00000097          	auipc	ra,0x0
    121a:	e8e080e7          	jalr	-370(ra) # 10a4 <printint>
    121e:	8b4a                	mv	s6,s2
      state = 0;
    1220:	4981                	li	s3,0
    1222:	b771                	j	11ae <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1224:	008b0913          	addi	s2,s6,8
    1228:	4681                	li	a3,0
    122a:	4629                	li	a2,10
    122c:	000b2583          	lw	a1,0(s6)
    1230:	8556                	mv	a0,s5
    1232:	00000097          	auipc	ra,0x0
    1236:	e72080e7          	jalr	-398(ra) # 10a4 <printint>
    123a:	8b4a                	mv	s6,s2
      state = 0;
    123c:	4981                	li	s3,0
    123e:	bf85                	j	11ae <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1240:	008b0913          	addi	s2,s6,8
    1244:	4681                	li	a3,0
    1246:	4641                	li	a2,16
    1248:	000b2583          	lw	a1,0(s6)
    124c:	8556                	mv	a0,s5
    124e:	00000097          	auipc	ra,0x0
    1252:	e56080e7          	jalr	-426(ra) # 10a4 <printint>
    1256:	8b4a                	mv	s6,s2
      state = 0;
    1258:	4981                	li	s3,0
    125a:	bf91                	j	11ae <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    125c:	008b0793          	addi	a5,s6,8
    1260:	f8f43423          	sd	a5,-120(s0)
    1264:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1268:	03000593          	li	a1,48
    126c:	8556                	mv	a0,s5
    126e:	00000097          	auipc	ra,0x0
    1272:	e14080e7          	jalr	-492(ra) # 1082 <putc>
  putc(fd, 'x');
    1276:	85ea                	mv	a1,s10
    1278:	8556                	mv	a0,s5
    127a:	00000097          	auipc	ra,0x0
    127e:	e08080e7          	jalr	-504(ra) # 1082 <putc>
    1282:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1284:	03c9d793          	srli	a5,s3,0x3c
    1288:	97de                	add	a5,a5,s7
    128a:	0007c583          	lbu	a1,0(a5)
    128e:	8556                	mv	a0,s5
    1290:	00000097          	auipc	ra,0x0
    1294:	df2080e7          	jalr	-526(ra) # 1082 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1298:	0992                	slli	s3,s3,0x4
    129a:	397d                	addiw	s2,s2,-1
    129c:	fe0914e3          	bnez	s2,1284 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    12a0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    12a4:	4981                	li	s3,0
    12a6:	b721                	j	11ae <vprintf+0x60>
        s = va_arg(ap, char*);
    12a8:	008b0993          	addi	s3,s6,8
    12ac:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    12b0:	02090163          	beqz	s2,12d2 <vprintf+0x184>
        while(*s != 0){
    12b4:	00094583          	lbu	a1,0(s2)
    12b8:	c9a1                	beqz	a1,1308 <vprintf+0x1ba>
          putc(fd, *s);
    12ba:	8556                	mv	a0,s5
    12bc:	00000097          	auipc	ra,0x0
    12c0:	dc6080e7          	jalr	-570(ra) # 1082 <putc>
          s++;
    12c4:	0905                	addi	s2,s2,1
        while(*s != 0){
    12c6:	00094583          	lbu	a1,0(s2)
    12ca:	f9e5                	bnez	a1,12ba <vprintf+0x16c>
        s = va_arg(ap, char*);
    12cc:	8b4e                	mv	s6,s3
      state = 0;
    12ce:	4981                	li	s3,0
    12d0:	bdf9                	j	11ae <vprintf+0x60>
          s = "(null)";
    12d2:	00000917          	auipc	s2,0x0
    12d6:	51690913          	addi	s2,s2,1302 # 17e8 <malloc+0x3d0>
        while(*s != 0){
    12da:	02800593          	li	a1,40
    12de:	bff1                	j	12ba <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    12e0:	008b0913          	addi	s2,s6,8
    12e4:	000b4583          	lbu	a1,0(s6)
    12e8:	8556                	mv	a0,s5
    12ea:	00000097          	auipc	ra,0x0
    12ee:	d98080e7          	jalr	-616(ra) # 1082 <putc>
    12f2:	8b4a                	mv	s6,s2
      state = 0;
    12f4:	4981                	li	s3,0
    12f6:	bd65                	j	11ae <vprintf+0x60>
        putc(fd, c);
    12f8:	85d2                	mv	a1,s4
    12fa:	8556                	mv	a0,s5
    12fc:	00000097          	auipc	ra,0x0
    1300:	d86080e7          	jalr	-634(ra) # 1082 <putc>
      state = 0;
    1304:	4981                	li	s3,0
    1306:	b565                	j	11ae <vprintf+0x60>
        s = va_arg(ap, char*);
    1308:	8b4e                	mv	s6,s3
      state = 0;
    130a:	4981                	li	s3,0
    130c:	b54d                	j	11ae <vprintf+0x60>
    }
  }
}
    130e:	70e6                	ld	ra,120(sp)
    1310:	7446                	ld	s0,112(sp)
    1312:	74a6                	ld	s1,104(sp)
    1314:	7906                	ld	s2,96(sp)
    1316:	69e6                	ld	s3,88(sp)
    1318:	6a46                	ld	s4,80(sp)
    131a:	6aa6                	ld	s5,72(sp)
    131c:	6b06                	ld	s6,64(sp)
    131e:	7be2                	ld	s7,56(sp)
    1320:	7c42                	ld	s8,48(sp)
    1322:	7ca2                	ld	s9,40(sp)
    1324:	7d02                	ld	s10,32(sp)
    1326:	6de2                	ld	s11,24(sp)
    1328:	6109                	addi	sp,sp,128
    132a:	8082                	ret

000000000000132c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    132c:	715d                	addi	sp,sp,-80
    132e:	ec06                	sd	ra,24(sp)
    1330:	e822                	sd	s0,16(sp)
    1332:	1000                	addi	s0,sp,32
    1334:	e010                	sd	a2,0(s0)
    1336:	e414                	sd	a3,8(s0)
    1338:	e818                	sd	a4,16(s0)
    133a:	ec1c                	sd	a5,24(s0)
    133c:	03043023          	sd	a6,32(s0)
    1340:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1344:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1348:	8622                	mv	a2,s0
    134a:	00000097          	auipc	ra,0x0
    134e:	e04080e7          	jalr	-508(ra) # 114e <vprintf>
}
    1352:	60e2                	ld	ra,24(sp)
    1354:	6442                	ld	s0,16(sp)
    1356:	6161                	addi	sp,sp,80
    1358:	8082                	ret

000000000000135a <printf>:

void
printf(const char *fmt, ...)
{
    135a:	711d                	addi	sp,sp,-96
    135c:	ec06                	sd	ra,24(sp)
    135e:	e822                	sd	s0,16(sp)
    1360:	1000                	addi	s0,sp,32
    1362:	e40c                	sd	a1,8(s0)
    1364:	e810                	sd	a2,16(s0)
    1366:	ec14                	sd	a3,24(s0)
    1368:	f018                	sd	a4,32(s0)
    136a:	f41c                	sd	a5,40(s0)
    136c:	03043823          	sd	a6,48(s0)
    1370:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1374:	00840613          	addi	a2,s0,8
    1378:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    137c:	85aa                	mv	a1,a0
    137e:	4505                	li	a0,1
    1380:	00000097          	auipc	ra,0x0
    1384:	dce080e7          	jalr	-562(ra) # 114e <vprintf>
}
    1388:	60e2                	ld	ra,24(sp)
    138a:	6442                	ld	s0,16(sp)
    138c:	6125                	addi	sp,sp,96
    138e:	8082                	ret

0000000000001390 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1390:	1141                	addi	sp,sp,-16
    1392:	e422                	sd	s0,8(sp)
    1394:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1396:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    139a:	00001797          	auipc	a5,0x1
    139e:	c767b783          	ld	a5,-906(a5) # 2010 <freep>
    13a2:	a805                	j	13d2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    13a4:	4618                	lw	a4,8(a2)
    13a6:	9db9                	addw	a1,a1,a4
    13a8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    13ac:	6398                	ld	a4,0(a5)
    13ae:	6318                	ld	a4,0(a4)
    13b0:	fee53823          	sd	a4,-16(a0)
    13b4:	a091                	j	13f8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    13b6:	ff852703          	lw	a4,-8(a0)
    13ba:	9e39                	addw	a2,a2,a4
    13bc:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    13be:	ff053703          	ld	a4,-16(a0)
    13c2:	e398                	sd	a4,0(a5)
    13c4:	a099                	j	140a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13c6:	6398                	ld	a4,0(a5)
    13c8:	00e7e463          	bltu	a5,a4,13d0 <free+0x40>
    13cc:	00e6ea63          	bltu	a3,a4,13e0 <free+0x50>
{
    13d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13d2:	fed7fae3          	bgeu	a5,a3,13c6 <free+0x36>
    13d6:	6398                	ld	a4,0(a5)
    13d8:	00e6e463          	bltu	a3,a4,13e0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13dc:	fee7eae3          	bltu	a5,a4,13d0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    13e0:	ff852583          	lw	a1,-8(a0)
    13e4:	6390                	ld	a2,0(a5)
    13e6:	02059713          	slli	a4,a1,0x20
    13ea:	9301                	srli	a4,a4,0x20
    13ec:	0712                	slli	a4,a4,0x4
    13ee:	9736                	add	a4,a4,a3
    13f0:	fae60ae3          	beq	a2,a4,13a4 <free+0x14>
    bp->s.ptr = p->s.ptr;
    13f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    13f8:	4790                	lw	a2,8(a5)
    13fa:	02061713          	slli	a4,a2,0x20
    13fe:	9301                	srli	a4,a4,0x20
    1400:	0712                	slli	a4,a4,0x4
    1402:	973e                	add	a4,a4,a5
    1404:	fae689e3          	beq	a3,a4,13b6 <free+0x26>
  } else
    p->s.ptr = bp;
    1408:	e394                	sd	a3,0(a5)
  freep = p;
    140a:	00001717          	auipc	a4,0x1
    140e:	c0f73323          	sd	a5,-1018(a4) # 2010 <freep>
}
    1412:	6422                	ld	s0,8(sp)
    1414:	0141                	addi	sp,sp,16
    1416:	8082                	ret

0000000000001418 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1418:	7139                	addi	sp,sp,-64
    141a:	fc06                	sd	ra,56(sp)
    141c:	f822                	sd	s0,48(sp)
    141e:	f426                	sd	s1,40(sp)
    1420:	f04a                	sd	s2,32(sp)
    1422:	ec4e                	sd	s3,24(sp)
    1424:	e852                	sd	s4,16(sp)
    1426:	e456                	sd	s5,8(sp)
    1428:	e05a                	sd	s6,0(sp)
    142a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    142c:	02051493          	slli	s1,a0,0x20
    1430:	9081                	srli	s1,s1,0x20
    1432:	04bd                	addi	s1,s1,15
    1434:	8091                	srli	s1,s1,0x4
    1436:	0014899b          	addiw	s3,s1,1
    143a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    143c:	00001517          	auipc	a0,0x1
    1440:	bd453503          	ld	a0,-1068(a0) # 2010 <freep>
    1444:	c515                	beqz	a0,1470 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1446:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1448:	4798                	lw	a4,8(a5)
    144a:	02977f63          	bgeu	a4,s1,1488 <malloc+0x70>
    144e:	8a4e                	mv	s4,s3
    1450:	0009871b          	sext.w	a4,s3
    1454:	6685                	lui	a3,0x1
    1456:	00d77363          	bgeu	a4,a3,145c <malloc+0x44>
    145a:	6a05                	lui	s4,0x1
    145c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1460:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1464:	00001917          	auipc	s2,0x1
    1468:	bac90913          	addi	s2,s2,-1108 # 2010 <freep>
  if(p == (char*)-1)
    146c:	5afd                	li	s5,-1
    146e:	a88d                	j	14e0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1470:	00001797          	auipc	a5,0x1
    1474:	f9878793          	addi	a5,a5,-104 # 2408 <base>
    1478:	00001717          	auipc	a4,0x1
    147c:	b8f73c23          	sd	a5,-1128(a4) # 2010 <freep>
    1480:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1482:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1486:	b7e1                	j	144e <malloc+0x36>
      if(p->s.size == nunits)
    1488:	02e48b63          	beq	s1,a4,14be <malloc+0xa6>
        p->s.size -= nunits;
    148c:	4137073b          	subw	a4,a4,s3
    1490:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1492:	1702                	slli	a4,a4,0x20
    1494:	9301                	srli	a4,a4,0x20
    1496:	0712                	slli	a4,a4,0x4
    1498:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    149a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    149e:	00001717          	auipc	a4,0x1
    14a2:	b6a73923          	sd	a0,-1166(a4) # 2010 <freep>
      return (void*)(p + 1);
    14a6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    14aa:	70e2                	ld	ra,56(sp)
    14ac:	7442                	ld	s0,48(sp)
    14ae:	74a2                	ld	s1,40(sp)
    14b0:	7902                	ld	s2,32(sp)
    14b2:	69e2                	ld	s3,24(sp)
    14b4:	6a42                	ld	s4,16(sp)
    14b6:	6aa2                	ld	s5,8(sp)
    14b8:	6b02                	ld	s6,0(sp)
    14ba:	6121                	addi	sp,sp,64
    14bc:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    14be:	6398                	ld	a4,0(a5)
    14c0:	e118                	sd	a4,0(a0)
    14c2:	bff1                	j	149e <malloc+0x86>
  hp->s.size = nu;
    14c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    14c8:	0541                	addi	a0,a0,16
    14ca:	00000097          	auipc	ra,0x0
    14ce:	ec6080e7          	jalr	-314(ra) # 1390 <free>
  return freep;
    14d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    14d6:	d971                	beqz	a0,14aa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14da:	4798                	lw	a4,8(a5)
    14dc:	fa9776e3          	bgeu	a4,s1,1488 <malloc+0x70>
    if(p == freep)
    14e0:	00093703          	ld	a4,0(s2)
    14e4:	853e                	mv	a0,a5
    14e6:	fef719e3          	bne	a4,a5,14d8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    14ea:	8552                	mv	a0,s4
    14ec:	00000097          	auipc	ra,0x0
    14f0:	b5e080e7          	jalr	-1186(ra) # 104a <sbrk>
  if(p == (char*)-1)
    14f4:	fd5518e3          	bne	a0,s5,14c4 <malloc+0xac>
        return 0;
    14f8:	4501                	li	a0,0
    14fa:	bf45                	j	14aa <malloc+0x92>
