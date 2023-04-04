
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0,"");
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	36e58593          	addi	a1,a1,878 # 1380 <malloc+0xf2>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e54080e7          	jalr	-428(ra) # e70 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	c2a080e7          	jalr	-982(ra) # c54 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c64080e7          	jalr	-924(ra) # c9a <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0,"");
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	32858593          	addi	a1,a1,808 # 1388 <malloc+0xfa>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	138080e7          	jalr	312(ra) # 11a2 <fprintf>
  exit(1,"");
      72:	00001597          	auipc	a1,0x1
      76:	31e58593          	addi	a1,a1,798 # 1390 <malloc+0x102>
      7a:	4505                	li	a0,1
      7c:	00001097          	auipc	ra,0x1
      80:	dd4080e7          	jalr	-556(ra) # e50 <exit>

0000000000000084 <fork1>:
}

int
fork1(void)
{
      84:	1141                	addi	sp,sp,-16
      86:	e406                	sd	ra,8(sp)
      88:	e022                	sd	s0,0(sp)
      8a:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      8c:	00001097          	auipc	ra,0x1
      90:	dbc080e7          	jalr	-580(ra) # e48 <fork>
  if(pid == -1)
      94:	57fd                	li	a5,-1
      96:	00f50663          	beq	a0,a5,a2 <fork1+0x1e>
    panic("fork");
  return pid;
}
      9a:	60a2                	ld	ra,8(sp)
      9c:	6402                	ld	s0,0(sp)
      9e:	0141                	addi	sp,sp,16
      a0:	8082                	ret
    panic("fork");
      a2:	00001517          	auipc	a0,0x1
      a6:	2f650513          	addi	a0,a0,758 # 1398 <malloc+0x10a>
      aa:	00000097          	auipc	ra,0x0
      ae:	fac080e7          	jalr	-84(ra) # 56 <panic>

00000000000000b2 <runcmd>:
{
      b2:	7179                	addi	sp,sp,-48
      b4:	f406                	sd	ra,40(sp)
      b6:	f022                	sd	s0,32(sp)
      b8:	ec26                	sd	s1,24(sp)
      ba:	1800                	addi	s0,sp,48
  if(cmd == 0)
      bc:	c10d                	beqz	a0,de <runcmd+0x2c>
      be:	84aa                	mv	s1,a0
  switch(cmd->type){
      c0:	4118                	lw	a4,0(a0)
      c2:	4795                	li	a5,5
      c4:	02e7e663          	bltu	a5,a4,f0 <runcmd+0x3e>
      c8:	00056783          	lwu	a5,0(a0)
      cc:	078a                	slli	a5,a5,0x2
      ce:	00001717          	auipc	a4,0x1
      d2:	3ce70713          	addi	a4,a4,974 # 149c <malloc+0x20e>
      d6:	97ba                	add	a5,a5,a4
      d8:	439c                	lw	a5,0(a5)
      da:	97ba                	add	a5,a5,a4
      dc:	8782                	jr	a5
    exit(1,"");
      de:	00001597          	auipc	a1,0x1
      e2:	2b258593          	addi	a1,a1,690 # 1390 <malloc+0x102>
      e6:	4505                	li	a0,1
      e8:	00001097          	auipc	ra,0x1
      ec:	d68080e7          	jalr	-664(ra) # e50 <exit>
    panic("runcmd");
      f0:	00001517          	auipc	a0,0x1
      f4:	2b050513          	addi	a0,a0,688 # 13a0 <malloc+0x112>
      f8:	00000097          	auipc	ra,0x0
      fc:	f5e080e7          	jalr	-162(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
     100:	6508                	ld	a0,8(a0)
     102:	c915                	beqz	a0,136 <runcmd+0x84>
    exec(ecmd->argv[0], ecmd->argv);
     104:	00848593          	addi	a1,s1,8
     108:	00001097          	auipc	ra,0x1
     10c:	d80080e7          	jalr	-640(ra) # e88 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     110:	6490                	ld	a2,8(s1)
     112:	00001597          	auipc	a1,0x1
     116:	29658593          	addi	a1,a1,662 # 13a8 <malloc+0x11a>
     11a:	4509                	li	a0,2
     11c:	00001097          	auipc	ra,0x1
     120:	086080e7          	jalr	134(ra) # 11a2 <fprintf>
  exit(0,"");
     124:	00001597          	auipc	a1,0x1
     128:	26c58593          	addi	a1,a1,620 # 1390 <malloc+0x102>
     12c:	4501                	li	a0,0
     12e:	00001097          	auipc	ra,0x1
     132:	d22080e7          	jalr	-734(ra) # e50 <exit>
      exit(1,"");
     136:	00001597          	auipc	a1,0x1
     13a:	25a58593          	addi	a1,a1,602 # 1390 <malloc+0x102>
     13e:	4505                	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	d10080e7          	jalr	-752(ra) # e50 <exit>
    close(rcmd->fd);
     148:	5148                	lw	a0,36(a0)
     14a:	00001097          	auipc	ra,0x1
     14e:	d2e080e7          	jalr	-722(ra) # e78 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     152:	508c                	lw	a1,32(s1)
     154:	6888                	ld	a0,16(s1)
     156:	00001097          	auipc	ra,0x1
     15a:	d3a080e7          	jalr	-710(ra) # e90 <open>
     15e:	00054763          	bltz	a0,16c <runcmd+0xba>
    runcmd(rcmd->cmd);
     162:	6488                	ld	a0,8(s1)
     164:	00000097          	auipc	ra,0x0
     168:	f4e080e7          	jalr	-178(ra) # b2 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     16c:	6890                	ld	a2,16(s1)
     16e:	00001597          	auipc	a1,0x1
     172:	24a58593          	addi	a1,a1,586 # 13b8 <malloc+0x12a>
     176:	4509                	li	a0,2
     178:	00001097          	auipc	ra,0x1
     17c:	02a080e7          	jalr	42(ra) # 11a2 <fprintf>
      exit(1,"");
     180:	00001597          	auipc	a1,0x1
     184:	21058593          	addi	a1,a1,528 # 1390 <malloc+0x102>
     188:	4505                	li	a0,1
     18a:	00001097          	auipc	ra,0x1
     18e:	cc6080e7          	jalr	-826(ra) # e50 <exit>
    if(fork1() == 0)
     192:	00000097          	auipc	ra,0x0
     196:	ef2080e7          	jalr	-270(ra) # 84 <fork1>
     19a:	e511                	bnez	a0,1a6 <runcmd+0xf4>
      runcmd(lcmd->left);
     19c:	6488                	ld	a0,8(s1)
     19e:	00000097          	auipc	ra,0x0
     1a2:	f14080e7          	jalr	-236(ra) # b2 <runcmd>
    wait(0, 0);
     1a6:	4581                	li	a1,0
     1a8:	4501                	li	a0,0
     1aa:	00001097          	auipc	ra,0x1
     1ae:	cae080e7          	jalr	-850(ra) # e58 <wait>
    runcmd(lcmd->right);
     1b2:	6888                	ld	a0,16(s1)
     1b4:	00000097          	auipc	ra,0x0
     1b8:	efe080e7          	jalr	-258(ra) # b2 <runcmd>
    if(pipe(p) < 0)
     1bc:	fd840513          	addi	a0,s0,-40
     1c0:	00001097          	auipc	ra,0x1
     1c4:	ca0080e7          	jalr	-864(ra) # e60 <pipe>
     1c8:	04054363          	bltz	a0,20e <runcmd+0x15c>
    if(fork1() == 0){
     1cc:	00000097          	auipc	ra,0x0
     1d0:	eb8080e7          	jalr	-328(ra) # 84 <fork1>
     1d4:	e529                	bnez	a0,21e <runcmd+0x16c>
      close(1);
     1d6:	4505                	li	a0,1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	ca0080e7          	jalr	-864(ra) # e78 <close>
      dup(p[1]);
     1e0:	fdc42503          	lw	a0,-36(s0)
     1e4:	00001097          	auipc	ra,0x1
     1e8:	ce4080e7          	jalr	-796(ra) # ec8 <dup>
      close(p[0]);
     1ec:	fd842503          	lw	a0,-40(s0)
     1f0:	00001097          	auipc	ra,0x1
     1f4:	c88080e7          	jalr	-888(ra) # e78 <close>
      close(p[1]);
     1f8:	fdc42503          	lw	a0,-36(s0)
     1fc:	00001097          	auipc	ra,0x1
     200:	c7c080e7          	jalr	-900(ra) # e78 <close>
      runcmd(pcmd->left);
     204:	6488                	ld	a0,8(s1)
     206:	00000097          	auipc	ra,0x0
     20a:	eac080e7          	jalr	-340(ra) # b2 <runcmd>
      panic("pipe");
     20e:	00001517          	auipc	a0,0x1
     212:	1ba50513          	addi	a0,a0,442 # 13c8 <malloc+0x13a>
     216:	00000097          	auipc	ra,0x0
     21a:	e40080e7          	jalr	-448(ra) # 56 <panic>
    if(fork1() == 0){
     21e:	00000097          	auipc	ra,0x0
     222:	e66080e7          	jalr	-410(ra) # 84 <fork1>
     226:	ed05                	bnez	a0,25e <runcmd+0x1ac>
      close(0);
     228:	00001097          	auipc	ra,0x1
     22c:	c50080e7          	jalr	-944(ra) # e78 <close>
      dup(p[0]);
     230:	fd842503          	lw	a0,-40(s0)
     234:	00001097          	auipc	ra,0x1
     238:	c94080e7          	jalr	-876(ra) # ec8 <dup>
      close(p[0]);
     23c:	fd842503          	lw	a0,-40(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c38080e7          	jalr	-968(ra) # e78 <close>
      close(p[1]);
     248:	fdc42503          	lw	a0,-36(s0)
     24c:	00001097          	auipc	ra,0x1
     250:	c2c080e7          	jalr	-980(ra) # e78 <close>
      runcmd(pcmd->right);
     254:	6888                	ld	a0,16(s1)
     256:	00000097          	auipc	ra,0x0
     25a:	e5c080e7          	jalr	-420(ra) # b2 <runcmd>
    close(p[0]);
     25e:	fd842503          	lw	a0,-40(s0)
     262:	00001097          	auipc	ra,0x1
     266:	c16080e7          	jalr	-1002(ra) # e78 <close>
    close(p[1]);
     26a:	fdc42503          	lw	a0,-36(s0)
     26e:	00001097          	auipc	ra,0x1
     272:	c0a080e7          	jalr	-1014(ra) # e78 <close>
    wait(0, 0);
     276:	4581                	li	a1,0
     278:	4501                	li	a0,0
     27a:	00001097          	auipc	ra,0x1
     27e:	bde080e7          	jalr	-1058(ra) # e58 <wait>
    wait(0, 0);
     282:	4581                	li	a1,0
     284:	4501                	li	a0,0
     286:	00001097          	auipc	ra,0x1
     28a:	bd2080e7          	jalr	-1070(ra) # e58 <wait>
    break;
     28e:	bd59                	j	124 <runcmd+0x72>
    if(fork1() == 0)
     290:	00000097          	auipc	ra,0x0
     294:	df4080e7          	jalr	-524(ra) # 84 <fork1>
     298:	e80516e3          	bnez	a0,124 <runcmd+0x72>
      runcmd(bcmd->cmd);
     29c:	6488                	ld	a0,8(s1)
     29e:	00000097          	auipc	ra,0x0
     2a2:	e14080e7          	jalr	-492(ra) # b2 <runcmd>

00000000000002a6 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     2a6:	1101                	addi	sp,sp,-32
     2a8:	ec06                	sd	ra,24(sp)
     2aa:	e822                	sd	s0,16(sp)
     2ac:	e426                	sd	s1,8(sp)
     2ae:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	0a800513          	li	a0,168
     2b4:	00001097          	auipc	ra,0x1
     2b8:	fda080e7          	jalr	-38(ra) # 128e <malloc>
     2bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2be:	0a800613          	li	a2,168
     2c2:	4581                	li	a1,0
     2c4:	00001097          	auipc	ra,0x1
     2c8:	990080e7          	jalr	-1648(ra) # c54 <memset>
  cmd->type = EXEC;
     2cc:	4785                	li	a5,1
     2ce:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2d0:	8526                	mv	a0,s1
     2d2:	60e2                	ld	ra,24(sp)
     2d4:	6442                	ld	s0,16(sp)
     2d6:	64a2                	ld	s1,8(sp)
     2d8:	6105                	addi	sp,sp,32
     2da:	8082                	ret

00000000000002dc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2dc:	7139                	addi	sp,sp,-64
     2de:	fc06                	sd	ra,56(sp)
     2e0:	f822                	sd	s0,48(sp)
     2e2:	f426                	sd	s1,40(sp)
     2e4:	f04a                	sd	s2,32(sp)
     2e6:	ec4e                	sd	s3,24(sp)
     2e8:	e852                	sd	s4,16(sp)
     2ea:	e456                	sd	s5,8(sp)
     2ec:	e05a                	sd	s6,0(sp)
     2ee:	0080                	addi	s0,sp,64
     2f0:	8b2a                	mv	s6,a0
     2f2:	8aae                	mv	s5,a1
     2f4:	8a32                	mv	s4,a2
     2f6:	89b6                	mv	s3,a3
     2f8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2fa:	02800513          	li	a0,40
     2fe:	00001097          	auipc	ra,0x1
     302:	f90080e7          	jalr	-112(ra) # 128e <malloc>
     306:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     308:	02800613          	li	a2,40
     30c:	4581                	li	a1,0
     30e:	00001097          	auipc	ra,0x1
     312:	946080e7          	jalr	-1722(ra) # c54 <memset>
  cmd->type = REDIR;
     316:	4789                	li	a5,2
     318:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     31a:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     31e:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     322:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     326:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     32a:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     32e:	8526                	mv	a0,s1
     330:	70e2                	ld	ra,56(sp)
     332:	7442                	ld	s0,48(sp)
     334:	74a2                	ld	s1,40(sp)
     336:	7902                	ld	s2,32(sp)
     338:	69e2                	ld	s3,24(sp)
     33a:	6a42                	ld	s4,16(sp)
     33c:	6aa2                	ld	s5,8(sp)
     33e:	6b02                	ld	s6,0(sp)
     340:	6121                	addi	sp,sp,64
     342:	8082                	ret

0000000000000344 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     344:	7179                	addi	sp,sp,-48
     346:	f406                	sd	ra,40(sp)
     348:	f022                	sd	s0,32(sp)
     34a:	ec26                	sd	s1,24(sp)
     34c:	e84a                	sd	s2,16(sp)
     34e:	e44e                	sd	s3,8(sp)
     350:	1800                	addi	s0,sp,48
     352:	89aa                	mv	s3,a0
     354:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     356:	4561                	li	a0,24
     358:	00001097          	auipc	ra,0x1
     35c:	f36080e7          	jalr	-202(ra) # 128e <malloc>
     360:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     362:	4661                	li	a2,24
     364:	4581                	li	a1,0
     366:	00001097          	auipc	ra,0x1
     36a:	8ee080e7          	jalr	-1810(ra) # c54 <memset>
  cmd->type = PIPE;
     36e:	478d                	li	a5,3
     370:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     372:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     376:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     37a:	8526                	mv	a0,s1
     37c:	70a2                	ld	ra,40(sp)
     37e:	7402                	ld	s0,32(sp)
     380:	64e2                	ld	s1,24(sp)
     382:	6942                	ld	s2,16(sp)
     384:	69a2                	ld	s3,8(sp)
     386:	6145                	addi	sp,sp,48
     388:	8082                	ret

000000000000038a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     38a:	7179                	addi	sp,sp,-48
     38c:	f406                	sd	ra,40(sp)
     38e:	f022                	sd	s0,32(sp)
     390:	ec26                	sd	s1,24(sp)
     392:	e84a                	sd	s2,16(sp)
     394:	e44e                	sd	s3,8(sp)
     396:	1800                	addi	s0,sp,48
     398:	89aa                	mv	s3,a0
     39a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     39c:	4561                	li	a0,24
     39e:	00001097          	auipc	ra,0x1
     3a2:	ef0080e7          	jalr	-272(ra) # 128e <malloc>
     3a6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3a8:	4661                	li	a2,24
     3aa:	4581                	li	a1,0
     3ac:	00001097          	auipc	ra,0x1
     3b0:	8a8080e7          	jalr	-1880(ra) # c54 <memset>
  cmd->type = LIST;
     3b4:	4791                	li	a5,4
     3b6:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3b8:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3bc:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3c0:	8526                	mv	a0,s1
     3c2:	70a2                	ld	ra,40(sp)
     3c4:	7402                	ld	s0,32(sp)
     3c6:	64e2                	ld	s1,24(sp)
     3c8:	6942                	ld	s2,16(sp)
     3ca:	69a2                	ld	s3,8(sp)
     3cc:	6145                	addi	sp,sp,48
     3ce:	8082                	ret

00000000000003d0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3d0:	1101                	addi	sp,sp,-32
     3d2:	ec06                	sd	ra,24(sp)
     3d4:	e822                	sd	s0,16(sp)
     3d6:	e426                	sd	s1,8(sp)
     3d8:	e04a                	sd	s2,0(sp)
     3da:	1000                	addi	s0,sp,32
     3dc:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3de:	4541                	li	a0,16
     3e0:	00001097          	auipc	ra,0x1
     3e4:	eae080e7          	jalr	-338(ra) # 128e <malloc>
     3e8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ea:	4641                	li	a2,16
     3ec:	4581                	li	a1,0
     3ee:	00001097          	auipc	ra,0x1
     3f2:	866080e7          	jalr	-1946(ra) # c54 <memset>
  cmd->type = BACK;
     3f6:	4795                	li	a5,5
     3f8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3fa:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3fe:	8526                	mv	a0,s1
     400:	60e2                	ld	ra,24(sp)
     402:	6442                	ld	s0,16(sp)
     404:	64a2                	ld	s1,8(sp)
     406:	6902                	ld	s2,0(sp)
     408:	6105                	addi	sp,sp,32
     40a:	8082                	ret

000000000000040c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     40c:	7139                	addi	sp,sp,-64
     40e:	fc06                	sd	ra,56(sp)
     410:	f822                	sd	s0,48(sp)
     412:	f426                	sd	s1,40(sp)
     414:	f04a                	sd	s2,32(sp)
     416:	ec4e                	sd	s3,24(sp)
     418:	e852                	sd	s4,16(sp)
     41a:	e456                	sd	s5,8(sp)
     41c:	e05a                	sd	s6,0(sp)
     41e:	0080                	addi	s0,sp,64
     420:	8a2a                	mv	s4,a0
     422:	892e                	mv	s2,a1
     424:	8ab2                	mv	s5,a2
     426:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     428:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     42a:	00002997          	auipc	s3,0x2
     42e:	bde98993          	addi	s3,s3,-1058 # 2008 <whitespace>
     432:	00b4fd63          	bgeu	s1,a1,44c <gettoken+0x40>
     436:	0004c583          	lbu	a1,0(s1)
     43a:	854e                	mv	a0,s3
     43c:	00001097          	auipc	ra,0x1
     440:	83a080e7          	jalr	-1990(ra) # c76 <strchr>
     444:	c501                	beqz	a0,44c <gettoken+0x40>
    s++;
     446:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     448:	fe9917e3          	bne	s2,s1,436 <gettoken+0x2a>
  if(q)
     44c:	000a8463          	beqz	s5,454 <gettoken+0x48>
    *q = s;
     450:	009ab023          	sd	s1,0(s5)
  ret = *s;
     454:	0004c783          	lbu	a5,0(s1)
     458:	00078a9b          	sext.w	s5,a5
  switch(*s){
     45c:	03c00713          	li	a4,60
     460:	06f76563          	bltu	a4,a5,4ca <gettoken+0xbe>
     464:	03a00713          	li	a4,58
     468:	00f76e63          	bltu	a4,a5,484 <gettoken+0x78>
     46c:	cf89                	beqz	a5,486 <gettoken+0x7a>
     46e:	02600713          	li	a4,38
     472:	00e78963          	beq	a5,a4,484 <gettoken+0x78>
     476:	fd87879b          	addiw	a5,a5,-40
     47a:	0ff7f793          	andi	a5,a5,255
     47e:	4705                	li	a4,1
     480:	06f76c63          	bltu	a4,a5,4f8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     484:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     486:	000b0463          	beqz	s6,48e <gettoken+0x82>
    *eq = s;
     48a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     48e:	00002997          	auipc	s3,0x2
     492:	b7a98993          	addi	s3,s3,-1158 # 2008 <whitespace>
     496:	0124fd63          	bgeu	s1,s2,4b0 <gettoken+0xa4>
     49a:	0004c583          	lbu	a1,0(s1)
     49e:	854e                	mv	a0,s3
     4a0:	00000097          	auipc	ra,0x0
     4a4:	7d6080e7          	jalr	2006(ra) # c76 <strchr>
     4a8:	c501                	beqz	a0,4b0 <gettoken+0xa4>
    s++;
     4aa:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4ac:	fe9917e3          	bne	s2,s1,49a <gettoken+0x8e>
  *ps = s;
     4b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     4b4:	8556                	mv	a0,s5
     4b6:	70e2                	ld	ra,56(sp)
     4b8:	7442                	ld	s0,48(sp)
     4ba:	74a2                	ld	s1,40(sp)
     4bc:	7902                	ld	s2,32(sp)
     4be:	69e2                	ld	s3,24(sp)
     4c0:	6a42                	ld	s4,16(sp)
     4c2:	6aa2                	ld	s5,8(sp)
     4c4:	6b02                	ld	s6,0(sp)
     4c6:	6121                	addi	sp,sp,64
     4c8:	8082                	ret
  switch(*s){
     4ca:	03e00713          	li	a4,62
     4ce:	02e79163          	bne	a5,a4,4f0 <gettoken+0xe4>
    s++;
     4d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4d6:	0014c703          	lbu	a4,1(s1)
     4da:	03e00793          	li	a5,62
      s++;
     4de:	0489                	addi	s1,s1,2
      ret = '+';
     4e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4e4:	faf701e3          	beq	a4,a5,486 <gettoken+0x7a>
    s++;
     4e8:	84b6                	mv	s1,a3
  ret = *s;
     4ea:	03e00a93          	li	s5,62
     4ee:	bf61                	j	486 <gettoken+0x7a>
  switch(*s){
     4f0:	07c00713          	li	a4,124
     4f4:	f8e788e3          	beq	a5,a4,484 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4f8:	00002997          	auipc	s3,0x2
     4fc:	b1098993          	addi	s3,s3,-1264 # 2008 <whitespace>
     500:	00002a97          	auipc	s5,0x2
     504:	b00a8a93          	addi	s5,s5,-1280 # 2000 <symbols>
     508:	0324f563          	bgeu	s1,s2,532 <gettoken+0x126>
     50c:	0004c583          	lbu	a1,0(s1)
     510:	854e                	mv	a0,s3
     512:	00000097          	auipc	ra,0x0
     516:	764080e7          	jalr	1892(ra) # c76 <strchr>
     51a:	e505                	bnez	a0,542 <gettoken+0x136>
     51c:	0004c583          	lbu	a1,0(s1)
     520:	8556                	mv	a0,s5
     522:	00000097          	auipc	ra,0x0
     526:	754080e7          	jalr	1876(ra) # c76 <strchr>
     52a:	e909                	bnez	a0,53c <gettoken+0x130>
      s++;
     52c:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     52e:	fc991fe3          	bne	s2,s1,50c <gettoken+0x100>
  if(eq)
     532:	06100a93          	li	s5,97
     536:	f40b1ae3          	bnez	s6,48a <gettoken+0x7e>
     53a:	bf9d                	j	4b0 <gettoken+0xa4>
    ret = 'a';
     53c:	06100a93          	li	s5,97
     540:	b799                	j	486 <gettoken+0x7a>
     542:	06100a93          	li	s5,97
     546:	b781                	j	486 <gettoken+0x7a>

0000000000000548 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     548:	7139                	addi	sp,sp,-64
     54a:	fc06                	sd	ra,56(sp)
     54c:	f822                	sd	s0,48(sp)
     54e:	f426                	sd	s1,40(sp)
     550:	f04a                	sd	s2,32(sp)
     552:	ec4e                	sd	s3,24(sp)
     554:	e852                	sd	s4,16(sp)
     556:	e456                	sd	s5,8(sp)
     558:	0080                	addi	s0,sp,64
     55a:	8a2a                	mv	s4,a0
     55c:	892e                	mv	s2,a1
     55e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     560:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     562:	00002997          	auipc	s3,0x2
     566:	aa698993          	addi	s3,s3,-1370 # 2008 <whitespace>
     56a:	00b4fd63          	bgeu	s1,a1,584 <peek+0x3c>
     56e:	0004c583          	lbu	a1,0(s1)
     572:	854e                	mv	a0,s3
     574:	00000097          	auipc	ra,0x0
     578:	702080e7          	jalr	1794(ra) # c76 <strchr>
     57c:	c501                	beqz	a0,584 <peek+0x3c>
    s++;
     57e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     580:	fe9917e3          	bne	s2,s1,56e <peek+0x26>
  *ps = s;
     584:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     588:	0004c583          	lbu	a1,0(s1)
     58c:	4501                	li	a0,0
     58e:	e991                	bnez	a1,5a2 <peek+0x5a>
}
     590:	70e2                	ld	ra,56(sp)
     592:	7442                	ld	s0,48(sp)
     594:	74a2                	ld	s1,40(sp)
     596:	7902                	ld	s2,32(sp)
     598:	69e2                	ld	s3,24(sp)
     59a:	6a42                	ld	s4,16(sp)
     59c:	6aa2                	ld	s5,8(sp)
     59e:	6121                	addi	sp,sp,64
     5a0:	8082                	ret
  return *s && strchr(toks, *s);
     5a2:	8556                	mv	a0,s5
     5a4:	00000097          	auipc	ra,0x0
     5a8:	6d2080e7          	jalr	1746(ra) # c76 <strchr>
     5ac:	00a03533          	snez	a0,a0
     5b0:	b7c5                	j	590 <peek+0x48>

00000000000005b2 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     5b2:	7159                	addi	sp,sp,-112
     5b4:	f486                	sd	ra,104(sp)
     5b6:	f0a2                	sd	s0,96(sp)
     5b8:	eca6                	sd	s1,88(sp)
     5ba:	e8ca                	sd	s2,80(sp)
     5bc:	e4ce                	sd	s3,72(sp)
     5be:	e0d2                	sd	s4,64(sp)
     5c0:	fc56                	sd	s5,56(sp)
     5c2:	f85a                	sd	s6,48(sp)
     5c4:	f45e                	sd	s7,40(sp)
     5c6:	f062                	sd	s8,32(sp)
     5c8:	ec66                	sd	s9,24(sp)
     5ca:	1880                	addi	s0,sp,112
     5cc:	8a2a                	mv	s4,a0
     5ce:	89ae                	mv	s3,a1
     5d0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5d2:	00001b97          	auipc	s7,0x1
     5d6:	e1eb8b93          	addi	s7,s7,-482 # 13f0 <malloc+0x162>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5da:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5de:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5e2:	a02d                	j	60c <parseredirs+0x5a>
      panic("missing file for redirection");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	dec50513          	addi	a0,a0,-532 # 13d0 <malloc+0x142>
     5ec:	00000097          	auipc	ra,0x0
     5f0:	a6a080e7          	jalr	-1430(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5f4:	4701                	li	a4,0
     5f6:	4681                	li	a3,0
     5f8:	f9043603          	ld	a2,-112(s0)
     5fc:	f9843583          	ld	a1,-104(s0)
     600:	8552                	mv	a0,s4
     602:	00000097          	auipc	ra,0x0
     606:	cda080e7          	jalr	-806(ra) # 2dc <redircmd>
     60a:	8a2a                	mv	s4,a0
    switch(tok){
     60c:	03e00b13          	li	s6,62
     610:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     614:	865e                	mv	a2,s7
     616:	85ca                	mv	a1,s2
     618:	854e                	mv	a0,s3
     61a:	00000097          	auipc	ra,0x0
     61e:	f2e080e7          	jalr	-210(ra) # 548 <peek>
     622:	c925                	beqz	a0,692 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     624:	4681                	li	a3,0
     626:	4601                	li	a2,0
     628:	85ca                	mv	a1,s2
     62a:	854e                	mv	a0,s3
     62c:	00000097          	auipc	ra,0x0
     630:	de0080e7          	jalr	-544(ra) # 40c <gettoken>
     634:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     636:	f9040693          	addi	a3,s0,-112
     63a:	f9840613          	addi	a2,s0,-104
     63e:	85ca                	mv	a1,s2
     640:	854e                	mv	a0,s3
     642:	00000097          	auipc	ra,0x0
     646:	dca080e7          	jalr	-566(ra) # 40c <gettoken>
     64a:	f9851de3          	bne	a0,s8,5e4 <parseredirs+0x32>
    switch(tok){
     64e:	fb9483e3          	beq	s1,s9,5f4 <parseredirs+0x42>
     652:	03648263          	beq	s1,s6,676 <parseredirs+0xc4>
     656:	fb549fe3          	bne	s1,s5,614 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     65a:	4705                	li	a4,1
     65c:	20100693          	li	a3,513
     660:	f9043603          	ld	a2,-112(s0)
     664:	f9843583          	ld	a1,-104(s0)
     668:	8552                	mv	a0,s4
     66a:	00000097          	auipc	ra,0x0
     66e:	c72080e7          	jalr	-910(ra) # 2dc <redircmd>
     672:	8a2a                	mv	s4,a0
      break;
     674:	bf61                	j	60c <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     676:	4705                	li	a4,1
     678:	60100693          	li	a3,1537
     67c:	f9043603          	ld	a2,-112(s0)
     680:	f9843583          	ld	a1,-104(s0)
     684:	8552                	mv	a0,s4
     686:	00000097          	auipc	ra,0x0
     68a:	c56080e7          	jalr	-938(ra) # 2dc <redircmd>
     68e:	8a2a                	mv	s4,a0
      break;
     690:	bfb5                	j	60c <parseredirs+0x5a>
    }
  }
  return cmd;
}
     692:	8552                	mv	a0,s4
     694:	70a6                	ld	ra,104(sp)
     696:	7406                	ld	s0,96(sp)
     698:	64e6                	ld	s1,88(sp)
     69a:	6946                	ld	s2,80(sp)
     69c:	69a6                	ld	s3,72(sp)
     69e:	6a06                	ld	s4,64(sp)
     6a0:	7ae2                	ld	s5,56(sp)
     6a2:	7b42                	ld	s6,48(sp)
     6a4:	7ba2                	ld	s7,40(sp)
     6a6:	7c02                	ld	s8,32(sp)
     6a8:	6ce2                	ld	s9,24(sp)
     6aa:	6165                	addi	sp,sp,112
     6ac:	8082                	ret

00000000000006ae <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     6ae:	7159                	addi	sp,sp,-112
     6b0:	f486                	sd	ra,104(sp)
     6b2:	f0a2                	sd	s0,96(sp)
     6b4:	eca6                	sd	s1,88(sp)
     6b6:	e8ca                	sd	s2,80(sp)
     6b8:	e4ce                	sd	s3,72(sp)
     6ba:	e0d2                	sd	s4,64(sp)
     6bc:	fc56                	sd	s5,56(sp)
     6be:	f85a                	sd	s6,48(sp)
     6c0:	f45e                	sd	s7,40(sp)
     6c2:	f062                	sd	s8,32(sp)
     6c4:	ec66                	sd	s9,24(sp)
     6c6:	1880                	addi	s0,sp,112
     6c8:	8a2a                	mv	s4,a0
     6ca:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6cc:	00001617          	auipc	a2,0x1
     6d0:	d2c60613          	addi	a2,a2,-724 # 13f8 <malloc+0x16a>
     6d4:	00000097          	auipc	ra,0x0
     6d8:	e74080e7          	jalr	-396(ra) # 548 <peek>
     6dc:	e905                	bnez	a0,70c <parseexec+0x5e>
     6de:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6e0:	00000097          	auipc	ra,0x0
     6e4:	bc6080e7          	jalr	-1082(ra) # 2a6 <execcmd>
     6e8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ea:	8656                	mv	a2,s5
     6ec:	85d2                	mv	a1,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	ec4080e7          	jalr	-316(ra) # 5b2 <parseredirs>
     6f6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6f8:	008c0913          	addi	s2,s8,8
     6fc:	00001b17          	auipc	s6,0x1
     700:	d1cb0b13          	addi	s6,s6,-740 # 1418 <malloc+0x18a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     704:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     708:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     70a:	a0b1                	j	756 <parseexec+0xa8>
    return parseblock(ps, es);
     70c:	85d6                	mv	a1,s5
     70e:	8552                	mv	a0,s4
     710:	00000097          	auipc	ra,0x0
     714:	1bc080e7          	jalr	444(ra) # 8cc <parseblock>
     718:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     71a:	8526                	mv	a0,s1
     71c:	70a6                	ld	ra,104(sp)
     71e:	7406                	ld	s0,96(sp)
     720:	64e6                	ld	s1,88(sp)
     722:	6946                	ld	s2,80(sp)
     724:	69a6                	ld	s3,72(sp)
     726:	6a06                	ld	s4,64(sp)
     728:	7ae2                	ld	s5,56(sp)
     72a:	7b42                	ld	s6,48(sp)
     72c:	7ba2                	ld	s7,40(sp)
     72e:	7c02                	ld	s8,32(sp)
     730:	6ce2                	ld	s9,24(sp)
     732:	6165                	addi	sp,sp,112
     734:	8082                	ret
      panic("syntax");
     736:	00001517          	auipc	a0,0x1
     73a:	cca50513          	addi	a0,a0,-822 # 1400 <malloc+0x172>
     73e:	00000097          	auipc	ra,0x0
     742:	918080e7          	jalr	-1768(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     746:	8656                	mv	a2,s5
     748:	85d2                	mv	a1,s4
     74a:	8526                	mv	a0,s1
     74c:	00000097          	auipc	ra,0x0
     750:	e66080e7          	jalr	-410(ra) # 5b2 <parseredirs>
     754:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     756:	865a                	mv	a2,s6
     758:	85d6                	mv	a1,s5
     75a:	8552                	mv	a0,s4
     75c:	00000097          	auipc	ra,0x0
     760:	dec080e7          	jalr	-532(ra) # 548 <peek>
     764:	e131                	bnez	a0,7a8 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     766:	f9040693          	addi	a3,s0,-112
     76a:	f9840613          	addi	a2,s0,-104
     76e:	85d6                	mv	a1,s5
     770:	8552                	mv	a0,s4
     772:	00000097          	auipc	ra,0x0
     776:	c9a080e7          	jalr	-870(ra) # 40c <gettoken>
     77a:	c51d                	beqz	a0,7a8 <parseexec+0xfa>
    if(tok != 'a')
     77c:	fb951de3          	bne	a0,s9,736 <parseexec+0x88>
    cmd->argv[argc] = q;
     780:	f9843783          	ld	a5,-104(s0)
     784:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     788:	f9043783          	ld	a5,-112(s0)
     78c:	04f93823          	sd	a5,80(s2)
    argc++;
     790:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     792:	0921                	addi	s2,s2,8
     794:	fb7999e3          	bne	s3,s7,746 <parseexec+0x98>
      panic("too many args");
     798:	00001517          	auipc	a0,0x1
     79c:	c7050513          	addi	a0,a0,-912 # 1408 <malloc+0x17a>
     7a0:	00000097          	auipc	ra,0x0
     7a4:	8b6080e7          	jalr	-1866(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     7a8:	098e                	slli	s3,s3,0x3
     7aa:	99e2                	add	s3,s3,s8
     7ac:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     7b0:	0409bc23          	sd	zero,88(s3)
  return ret;
     7b4:	b79d                	j	71a <parseexec+0x6c>

00000000000007b6 <parsepipe>:
{
     7b6:	7179                	addi	sp,sp,-48
     7b8:	f406                	sd	ra,40(sp)
     7ba:	f022                	sd	s0,32(sp)
     7bc:	ec26                	sd	s1,24(sp)
     7be:	e84a                	sd	s2,16(sp)
     7c0:	e44e                	sd	s3,8(sp)
     7c2:	1800                	addi	s0,sp,48
     7c4:	892a                	mv	s2,a0
     7c6:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7c8:	00000097          	auipc	ra,0x0
     7cc:	ee6080e7          	jalr	-282(ra) # 6ae <parseexec>
     7d0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7d2:	00001617          	auipc	a2,0x1
     7d6:	c4e60613          	addi	a2,a2,-946 # 1420 <malloc+0x192>
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	d6a080e7          	jalr	-662(ra) # 548 <peek>
     7e6:	e909                	bnez	a0,7f8 <parsepipe+0x42>
}
     7e8:	8526                	mv	a0,s1
     7ea:	70a2                	ld	ra,40(sp)
     7ec:	7402                	ld	s0,32(sp)
     7ee:	64e2                	ld	s1,24(sp)
     7f0:	6942                	ld	s2,16(sp)
     7f2:	69a2                	ld	s3,8(sp)
     7f4:	6145                	addi	sp,sp,48
     7f6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7f8:	4681                	li	a3,0
     7fa:	4601                	li	a2,0
     7fc:	85ce                	mv	a1,s3
     7fe:	854a                	mv	a0,s2
     800:	00000097          	auipc	ra,0x0
     804:	c0c080e7          	jalr	-1012(ra) # 40c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     808:	85ce                	mv	a1,s3
     80a:	854a                	mv	a0,s2
     80c:	00000097          	auipc	ra,0x0
     810:	faa080e7          	jalr	-86(ra) # 7b6 <parsepipe>
     814:	85aa                	mv	a1,a0
     816:	8526                	mv	a0,s1
     818:	00000097          	auipc	ra,0x0
     81c:	b2c080e7          	jalr	-1236(ra) # 344 <pipecmd>
     820:	84aa                	mv	s1,a0
  return cmd;
     822:	b7d9                	j	7e8 <parsepipe+0x32>

0000000000000824 <parseline>:
{
     824:	7179                	addi	sp,sp,-48
     826:	f406                	sd	ra,40(sp)
     828:	f022                	sd	s0,32(sp)
     82a:	ec26                	sd	s1,24(sp)
     82c:	e84a                	sd	s2,16(sp)
     82e:	e44e                	sd	s3,8(sp)
     830:	e052                	sd	s4,0(sp)
     832:	1800                	addi	s0,sp,48
     834:	892a                	mv	s2,a0
     836:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     838:	00000097          	auipc	ra,0x0
     83c:	f7e080e7          	jalr	-130(ra) # 7b6 <parsepipe>
     840:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     842:	00001a17          	auipc	s4,0x1
     846:	be6a0a13          	addi	s4,s4,-1050 # 1428 <malloc+0x19a>
     84a:	a839                	j	868 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     84c:	4681                	li	a3,0
     84e:	4601                	li	a2,0
     850:	85ce                	mv	a1,s3
     852:	854a                	mv	a0,s2
     854:	00000097          	auipc	ra,0x0
     858:	bb8080e7          	jalr	-1096(ra) # 40c <gettoken>
    cmd = backcmd(cmd);
     85c:	8526                	mv	a0,s1
     85e:	00000097          	auipc	ra,0x0
     862:	b72080e7          	jalr	-1166(ra) # 3d0 <backcmd>
     866:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     868:	8652                	mv	a2,s4
     86a:	85ce                	mv	a1,s3
     86c:	854a                	mv	a0,s2
     86e:	00000097          	auipc	ra,0x0
     872:	cda080e7          	jalr	-806(ra) # 548 <peek>
     876:	f979                	bnez	a0,84c <parseline+0x28>
  if(peek(ps, es, ";")){
     878:	00001617          	auipc	a2,0x1
     87c:	bb860613          	addi	a2,a2,-1096 # 1430 <malloc+0x1a2>
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	cc4080e7          	jalr	-828(ra) # 548 <peek>
     88c:	e911                	bnez	a0,8a0 <parseline+0x7c>
}
     88e:	8526                	mv	a0,s1
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	69a2                	ld	s3,8(sp)
     89a:	6a02                	ld	s4,0(sp)
     89c:	6145                	addi	sp,sp,48
     89e:	8082                	ret
    gettoken(ps, es, 0, 0);
     8a0:	4681                	li	a3,0
     8a2:	4601                	li	a2,0
     8a4:	85ce                	mv	a1,s3
     8a6:	854a                	mv	a0,s2
     8a8:	00000097          	auipc	ra,0x0
     8ac:	b64080e7          	jalr	-1180(ra) # 40c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8b0:	85ce                	mv	a1,s3
     8b2:	854a                	mv	a0,s2
     8b4:	00000097          	auipc	ra,0x0
     8b8:	f70080e7          	jalr	-144(ra) # 824 <parseline>
     8bc:	85aa                	mv	a1,a0
     8be:	8526                	mv	a0,s1
     8c0:	00000097          	auipc	ra,0x0
     8c4:	aca080e7          	jalr	-1334(ra) # 38a <listcmd>
     8c8:	84aa                	mv	s1,a0
  return cmd;
     8ca:	b7d1                	j	88e <parseline+0x6a>

00000000000008cc <parseblock>:
{
     8cc:	7179                	addi	sp,sp,-48
     8ce:	f406                	sd	ra,40(sp)
     8d0:	f022                	sd	s0,32(sp)
     8d2:	ec26                	sd	s1,24(sp)
     8d4:	e84a                	sd	s2,16(sp)
     8d6:	e44e                	sd	s3,8(sp)
     8d8:	1800                	addi	s0,sp,48
     8da:	84aa                	mv	s1,a0
     8dc:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8de:	00001617          	auipc	a2,0x1
     8e2:	b1a60613          	addi	a2,a2,-1254 # 13f8 <malloc+0x16a>
     8e6:	00000097          	auipc	ra,0x0
     8ea:	c62080e7          	jalr	-926(ra) # 548 <peek>
     8ee:	c12d                	beqz	a0,950 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8f0:	4681                	li	a3,0
     8f2:	4601                	li	a2,0
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	b14080e7          	jalr	-1260(ra) # 40c <gettoken>
  cmd = parseline(ps, es);
     900:	85ca                	mv	a1,s2
     902:	8526                	mv	a0,s1
     904:	00000097          	auipc	ra,0x0
     908:	f20080e7          	jalr	-224(ra) # 824 <parseline>
     90c:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     90e:	00001617          	auipc	a2,0x1
     912:	b3a60613          	addi	a2,a2,-1222 # 1448 <malloc+0x1ba>
     916:	85ca                	mv	a1,s2
     918:	8526                	mv	a0,s1
     91a:	00000097          	auipc	ra,0x0
     91e:	c2e080e7          	jalr	-978(ra) # 548 <peek>
     922:	cd1d                	beqz	a0,960 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     924:	4681                	li	a3,0
     926:	4601                	li	a2,0
     928:	85ca                	mv	a1,s2
     92a:	8526                	mv	a0,s1
     92c:	00000097          	auipc	ra,0x0
     930:	ae0080e7          	jalr	-1312(ra) # 40c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     934:	864a                	mv	a2,s2
     936:	85a6                	mv	a1,s1
     938:	854e                	mv	a0,s3
     93a:	00000097          	auipc	ra,0x0
     93e:	c78080e7          	jalr	-904(ra) # 5b2 <parseredirs>
}
     942:	70a2                	ld	ra,40(sp)
     944:	7402                	ld	s0,32(sp)
     946:	64e2                	ld	s1,24(sp)
     948:	6942                	ld	s2,16(sp)
     94a:	69a2                	ld	s3,8(sp)
     94c:	6145                	addi	sp,sp,48
     94e:	8082                	ret
    panic("parseblock");
     950:	00001517          	auipc	a0,0x1
     954:	ae850513          	addi	a0,a0,-1304 # 1438 <malloc+0x1aa>
     958:	fffff097          	auipc	ra,0xfffff
     95c:	6fe080e7          	jalr	1790(ra) # 56 <panic>
    panic("syntax - missing )");
     960:	00001517          	auipc	a0,0x1
     964:	af050513          	addi	a0,a0,-1296 # 1450 <malloc+0x1c2>
     968:	fffff097          	auipc	ra,0xfffff
     96c:	6ee080e7          	jalr	1774(ra) # 56 <panic>

0000000000000970 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     970:	1101                	addi	sp,sp,-32
     972:	ec06                	sd	ra,24(sp)
     974:	e822                	sd	s0,16(sp)
     976:	e426                	sd	s1,8(sp)
     978:	1000                	addi	s0,sp,32
     97a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     97c:	c521                	beqz	a0,9c4 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     97e:	4118                	lw	a4,0(a0)
     980:	4795                	li	a5,5
     982:	04e7e163          	bltu	a5,a4,9c4 <nulterminate+0x54>
     986:	00056783          	lwu	a5,0(a0)
     98a:	078a                	slli	a5,a5,0x2
     98c:	00001717          	auipc	a4,0x1
     990:	b2870713          	addi	a4,a4,-1240 # 14b4 <malloc+0x226>
     994:	97ba                	add	a5,a5,a4
     996:	439c                	lw	a5,0(a5)
     998:	97ba                	add	a5,a5,a4
     99a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     99c:	651c                	ld	a5,8(a0)
     99e:	c39d                	beqz	a5,9c4 <nulterminate+0x54>
     9a0:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     9a4:	67b8                	ld	a4,72(a5)
     9a6:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     9aa:	07a1                	addi	a5,a5,8
     9ac:	ff87b703          	ld	a4,-8(a5)
     9b0:	fb75                	bnez	a4,9a4 <nulterminate+0x34>
     9b2:	a809                	j	9c4 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9b4:	6508                	ld	a0,8(a0)
     9b6:	00000097          	auipc	ra,0x0
     9ba:	fba080e7          	jalr	-70(ra) # 970 <nulterminate>
    *rcmd->efile = 0;
     9be:	6c9c                	ld	a5,24(s1)
     9c0:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9c4:	8526                	mv	a0,s1
     9c6:	60e2                	ld	ra,24(sp)
     9c8:	6442                	ld	s0,16(sp)
     9ca:	64a2                	ld	s1,8(sp)
     9cc:	6105                	addi	sp,sp,32
     9ce:	8082                	ret
    nulterminate(pcmd->left);
     9d0:	6508                	ld	a0,8(a0)
     9d2:	00000097          	auipc	ra,0x0
     9d6:	f9e080e7          	jalr	-98(ra) # 970 <nulterminate>
    nulterminate(pcmd->right);
     9da:	6888                	ld	a0,16(s1)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f94080e7          	jalr	-108(ra) # 970 <nulterminate>
    break;
     9e4:	b7c5                	j	9c4 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9e6:	6508                	ld	a0,8(a0)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	f88080e7          	jalr	-120(ra) # 970 <nulterminate>
    nulterminate(lcmd->right);
     9f0:	6888                	ld	a0,16(s1)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	f7e080e7          	jalr	-130(ra) # 970 <nulterminate>
    break;
     9fa:	b7e9                	j	9c4 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9fc:	6508                	ld	a0,8(a0)
     9fe:	00000097          	auipc	ra,0x0
     a02:	f72080e7          	jalr	-142(ra) # 970 <nulterminate>
    break;
     a06:	bf7d                	j	9c4 <nulterminate+0x54>

0000000000000a08 <parsecmd>:
{
     a08:	7179                	addi	sp,sp,-48
     a0a:	f406                	sd	ra,40(sp)
     a0c:	f022                	sd	s0,32(sp)
     a0e:	ec26                	sd	s1,24(sp)
     a10:	e84a                	sd	s2,16(sp)
     a12:	1800                	addi	s0,sp,48
     a14:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a18:	84aa                	mv	s1,a0
     a1a:	00000097          	auipc	ra,0x0
     a1e:	210080e7          	jalr	528(ra) # c2a <strlen>
     a22:	1502                	slli	a0,a0,0x20
     a24:	9101                	srli	a0,a0,0x20
     a26:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a28:	85a6                	mv	a1,s1
     a2a:	fd840513          	addi	a0,s0,-40
     a2e:	00000097          	auipc	ra,0x0
     a32:	df6080e7          	jalr	-522(ra) # 824 <parseline>
     a36:	892a                	mv	s2,a0
  peek(&s, es, "");
     a38:	00001617          	auipc	a2,0x1
     a3c:	95860613          	addi	a2,a2,-1704 # 1390 <malloc+0x102>
     a40:	85a6                	mv	a1,s1
     a42:	fd840513          	addi	a0,s0,-40
     a46:	00000097          	auipc	ra,0x0
     a4a:	b02080e7          	jalr	-1278(ra) # 548 <peek>
  if(s != es){
     a4e:	fd843603          	ld	a2,-40(s0)
     a52:	00961e63          	bne	a2,s1,a6e <parsecmd+0x66>
  nulterminate(cmd);
     a56:	854a                	mv	a0,s2
     a58:	00000097          	auipc	ra,0x0
     a5c:	f18080e7          	jalr	-232(ra) # 970 <nulterminate>
}
     a60:	854a                	mv	a0,s2
     a62:	70a2                	ld	ra,40(sp)
     a64:	7402                	ld	s0,32(sp)
     a66:	64e2                	ld	s1,24(sp)
     a68:	6942                	ld	s2,16(sp)
     a6a:	6145                	addi	sp,sp,48
     a6c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a6e:	00001597          	auipc	a1,0x1
     a72:	9fa58593          	addi	a1,a1,-1542 # 1468 <malloc+0x1da>
     a76:	4509                	li	a0,2
     a78:	00000097          	auipc	ra,0x0
     a7c:	72a080e7          	jalr	1834(ra) # 11a2 <fprintf>
    panic("syntax");
     a80:	00001517          	auipc	a0,0x1
     a84:	98050513          	addi	a0,a0,-1664 # 1400 <malloc+0x172>
     a88:	fffff097          	auipc	ra,0xfffff
     a8c:	5ce080e7          	jalr	1486(ra) # 56 <panic>

0000000000000a90 <main>:
{
     a90:	711d                	addi	sp,sp,-96
     a92:	ec86                	sd	ra,88(sp)
     a94:	e8a2                	sd	s0,80(sp)
     a96:	e4a6                	sd	s1,72(sp)
     a98:	e0ca                	sd	s2,64(sp)
     a9a:	fc4e                	sd	s3,56(sp)
     a9c:	f852                	sd	s4,48(sp)
     a9e:	f456                	sd	s5,40(sp)
     aa0:	f05a                	sd	s6,32(sp)
     aa2:	1080                	addi	s0,sp,96
  printf("%s\n", "MAIN");
     aa4:	00001597          	auipc	a1,0x1
     aa8:	9d458593          	addi	a1,a1,-1580 # 1478 <malloc+0x1ea>
     aac:	00001517          	auipc	a0,0x1
     ab0:	8dc50513          	addi	a0,a0,-1828 # 1388 <malloc+0xfa>
     ab4:	00000097          	auipc	ra,0x0
     ab8:	71c080e7          	jalr	1820(ra) # 11d0 <printf>
  while((fd = open("console", O_RDWR)) >= 0){
     abc:	00001497          	auipc	s1,0x1
     ac0:	9c448493          	addi	s1,s1,-1596 # 1480 <malloc+0x1f2>
     ac4:	4589                	li	a1,2
     ac6:	8526                	mv	a0,s1
     ac8:	00000097          	auipc	ra,0x0
     acc:	3c8080e7          	jalr	968(ra) # e90 <open>
     ad0:	00054963          	bltz	a0,ae2 <main+0x52>
    if(fd >= 3){
     ad4:	4789                	li	a5,2
     ad6:	fea7d7e3          	bge	a5,a0,ac4 <main+0x34>
      close(fd);
     ada:	00000097          	auipc	ra,0x0
     ade:	39e080e7          	jalr	926(ra) # e78 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ae2:	00001497          	auipc	s1,0x1
     ae6:	53e48493          	addi	s1,s1,1342 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aea:	06300913          	li	s2,99
    printf("%s",msg);
     aee:	00001997          	auipc	s3,0x1
     af2:	9aa98993          	addi	s3,s3,-1622 # 1498 <malloc+0x20a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     af6:	02000a13          	li	s4,32
      if(chdir(buf+3) < 0)
     afa:	00001a97          	auipc	s5,0x1
     afe:	529a8a93          	addi	s5,s5,1321 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     b02:	00001b17          	auipc	s6,0x1
     b06:	986b0b13          	addi	s6,s6,-1658 # 1488 <malloc+0x1fa>
     b0a:	a025                	j	b32 <main+0xa2>
    if(fork1() == 0)
     b0c:	fffff097          	auipc	ra,0xfffff
     b10:	578080e7          	jalr	1400(ra) # 84 <fork1>
     b14:	c149                	beqz	a0,b96 <main+0x106>
    wait(0, msg);
     b16:	fa040593          	addi	a1,s0,-96
     b1a:	4501                	li	a0,0
     b1c:	00000097          	auipc	ra,0x0
     b20:	33c080e7          	jalr	828(ra) # e58 <wait>
    printf("%s",msg);
     b24:	fa040593          	addi	a1,s0,-96
     b28:	854e                	mv	a0,s3
     b2a:	00000097          	auipc	ra,0x0
     b2e:	6a6080e7          	jalr	1702(ra) # 11d0 <printf>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b32:	06400593          	li	a1,100
     b36:	8526                	mv	a0,s1
     b38:	fffff097          	auipc	ra,0xfffff
     b3c:	4c8080e7          	jalr	1224(ra) # 0 <getcmd>
     b40:	06054763          	bltz	a0,bae <main+0x11e>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b44:	0004c783          	lbu	a5,0(s1)
     b48:	fd2792e3          	bne	a5,s2,b0c <main+0x7c>
     b4c:	0014c703          	lbu	a4,1(s1)
     b50:	06400793          	li	a5,100
     b54:	faf71ce3          	bne	a4,a5,b0c <main+0x7c>
     b58:	0024c783          	lbu	a5,2(s1)
     b5c:	fb4798e3          	bne	a5,s4,b0c <main+0x7c>
      buf[strlen(buf)-1] = 0;  // chop \n
     b60:	8526                	mv	a0,s1
     b62:	00000097          	auipc	ra,0x0
     b66:	0c8080e7          	jalr	200(ra) # c2a <strlen>
     b6a:	fff5079b          	addiw	a5,a0,-1
     b6e:	1782                	slli	a5,a5,0x20
     b70:	9381                	srli	a5,a5,0x20
     b72:	97a6                	add	a5,a5,s1
     b74:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b78:	8556                	mv	a0,s5
     b7a:	00000097          	auipc	ra,0x0
     b7e:	346080e7          	jalr	838(ra) # ec0 <chdir>
     b82:	fa0558e3          	bgez	a0,b32 <main+0xa2>
        fprintf(2, "cannot cd %s\n", buf+3);
     b86:	8656                	mv	a2,s5
     b88:	85da                	mv	a1,s6
     b8a:	4509                	li	a0,2
     b8c:	00000097          	auipc	ra,0x0
     b90:	616080e7          	jalr	1558(ra) # 11a2 <fprintf>
      continue;
     b94:	bf79                	j	b32 <main+0xa2>
      runcmd(parsecmd(buf));
     b96:	00001517          	auipc	a0,0x1
     b9a:	48a50513          	addi	a0,a0,1162 # 2020 <buf.0>
     b9e:	00000097          	auipc	ra,0x0
     ba2:	e6a080e7          	jalr	-406(ra) # a08 <parsecmd>
     ba6:	fffff097          	auipc	ra,0xfffff
     baa:	50c080e7          	jalr	1292(ra) # b2 <runcmd>
  exit(0,"");
     bae:	00000597          	auipc	a1,0x0
     bb2:	7e258593          	addi	a1,a1,2018 # 1390 <malloc+0x102>
     bb6:	4501                	li	a0,0
     bb8:	00000097          	auipc	ra,0x0
     bbc:	298080e7          	jalr	664(ra) # e50 <exit>

0000000000000bc0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     bc0:	1141                	addi	sp,sp,-16
     bc2:	e406                	sd	ra,8(sp)
     bc4:	e022                	sd	s0,0(sp)
     bc6:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bc8:	00000097          	auipc	ra,0x0
     bcc:	ec8080e7          	jalr	-312(ra) # a90 <main>
  exit(0,"");
     bd0:	00000597          	auipc	a1,0x0
     bd4:	7c058593          	addi	a1,a1,1984 # 1390 <malloc+0x102>
     bd8:	4501                	li	a0,0
     bda:	00000097          	auipc	ra,0x0
     bde:	276080e7          	jalr	630(ra) # e50 <exit>

0000000000000be2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     be2:	1141                	addi	sp,sp,-16
     be4:	e422                	sd	s0,8(sp)
     be6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     be8:	87aa                	mv	a5,a0
     bea:	0585                	addi	a1,a1,1
     bec:	0785                	addi	a5,a5,1
     bee:	fff5c703          	lbu	a4,-1(a1)
     bf2:	fee78fa3          	sb	a4,-1(a5)
     bf6:	fb75                	bnez	a4,bea <strcpy+0x8>
    ;
  return os;
}
     bf8:	6422                	ld	s0,8(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret

0000000000000bfe <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c04:	00054783          	lbu	a5,0(a0)
     c08:	cb91                	beqz	a5,c1c <strcmp+0x1e>
     c0a:	0005c703          	lbu	a4,0(a1)
     c0e:	00f71763          	bne	a4,a5,c1c <strcmp+0x1e>
    p++, q++;
     c12:	0505                	addi	a0,a0,1
     c14:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c16:	00054783          	lbu	a5,0(a0)
     c1a:	fbe5                	bnez	a5,c0a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c1c:	0005c503          	lbu	a0,0(a1)
}
     c20:	40a7853b          	subw	a0,a5,a0
     c24:	6422                	ld	s0,8(sp)
     c26:	0141                	addi	sp,sp,16
     c28:	8082                	ret

0000000000000c2a <strlen>:

uint
strlen(const char *s)
{
     c2a:	1141                	addi	sp,sp,-16
     c2c:	e422                	sd	s0,8(sp)
     c2e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c30:	00054783          	lbu	a5,0(a0)
     c34:	cf91                	beqz	a5,c50 <strlen+0x26>
     c36:	0505                	addi	a0,a0,1
     c38:	87aa                	mv	a5,a0
     c3a:	4685                	li	a3,1
     c3c:	9e89                	subw	a3,a3,a0
     c3e:	00f6853b          	addw	a0,a3,a5
     c42:	0785                	addi	a5,a5,1
     c44:	fff7c703          	lbu	a4,-1(a5)
     c48:	fb7d                	bnez	a4,c3e <strlen+0x14>
    ;
  return n;
}
     c4a:	6422                	ld	s0,8(sp)
     c4c:	0141                	addi	sp,sp,16
     c4e:	8082                	ret
  for(n = 0; s[n]; n++)
     c50:	4501                	li	a0,0
     c52:	bfe5                	j	c4a <strlen+0x20>

0000000000000c54 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c54:	1141                	addi	sp,sp,-16
     c56:	e422                	sd	s0,8(sp)
     c58:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c5a:	ca19                	beqz	a2,c70 <memset+0x1c>
     c5c:	87aa                	mv	a5,a0
     c5e:	1602                	slli	a2,a2,0x20
     c60:	9201                	srli	a2,a2,0x20
     c62:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c66:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c6a:	0785                	addi	a5,a5,1
     c6c:	fee79de3          	bne	a5,a4,c66 <memset+0x12>
  }
  return dst;
}
     c70:	6422                	ld	s0,8(sp)
     c72:	0141                	addi	sp,sp,16
     c74:	8082                	ret

0000000000000c76 <strchr>:

char*
strchr(const char *s, char c)
{
     c76:	1141                	addi	sp,sp,-16
     c78:	e422                	sd	s0,8(sp)
     c7a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c7c:	00054783          	lbu	a5,0(a0)
     c80:	cb99                	beqz	a5,c96 <strchr+0x20>
    if(*s == c)
     c82:	00f58763          	beq	a1,a5,c90 <strchr+0x1a>
  for(; *s; s++)
     c86:	0505                	addi	a0,a0,1
     c88:	00054783          	lbu	a5,0(a0)
     c8c:	fbfd                	bnez	a5,c82 <strchr+0xc>
      return (char*)s;
  return 0;
     c8e:	4501                	li	a0,0
}
     c90:	6422                	ld	s0,8(sp)
     c92:	0141                	addi	sp,sp,16
     c94:	8082                	ret
  return 0;
     c96:	4501                	li	a0,0
     c98:	bfe5                	j	c90 <strchr+0x1a>

0000000000000c9a <gets>:

char*
gets(char *buf, int max)
{
     c9a:	711d                	addi	sp,sp,-96
     c9c:	ec86                	sd	ra,88(sp)
     c9e:	e8a2                	sd	s0,80(sp)
     ca0:	e4a6                	sd	s1,72(sp)
     ca2:	e0ca                	sd	s2,64(sp)
     ca4:	fc4e                	sd	s3,56(sp)
     ca6:	f852                	sd	s4,48(sp)
     ca8:	f456                	sd	s5,40(sp)
     caa:	f05a                	sd	s6,32(sp)
     cac:	ec5e                	sd	s7,24(sp)
     cae:	1080                	addi	s0,sp,96
     cb0:	8baa                	mv	s7,a0
     cb2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cb4:	892a                	mv	s2,a0
     cb6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cb8:	4aa9                	li	s5,10
     cba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cbc:	89a6                	mv	s3,s1
     cbe:	2485                	addiw	s1,s1,1
     cc0:	0344d863          	bge	s1,s4,cf0 <gets+0x56>
    cc = read(0, &c, 1);
     cc4:	4605                	li	a2,1
     cc6:	faf40593          	addi	a1,s0,-81
     cca:	4501                	li	a0,0
     ccc:	00000097          	auipc	ra,0x0
     cd0:	19c080e7          	jalr	412(ra) # e68 <read>
    if(cc < 1)
     cd4:	00a05e63          	blez	a0,cf0 <gets+0x56>
    buf[i++] = c;
     cd8:	faf44783          	lbu	a5,-81(s0)
     cdc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     ce0:	01578763          	beq	a5,s5,cee <gets+0x54>
     ce4:	0905                	addi	s2,s2,1
     ce6:	fd679be3          	bne	a5,s6,cbc <gets+0x22>
  for(i=0; i+1 < max; ){
     cea:	89a6                	mv	s3,s1
     cec:	a011                	j	cf0 <gets+0x56>
     cee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cf0:	99de                	add	s3,s3,s7
     cf2:	00098023          	sb	zero,0(s3)
  return buf;
}
     cf6:	855e                	mv	a0,s7
     cf8:	60e6                	ld	ra,88(sp)
     cfa:	6446                	ld	s0,80(sp)
     cfc:	64a6                	ld	s1,72(sp)
     cfe:	6906                	ld	s2,64(sp)
     d00:	79e2                	ld	s3,56(sp)
     d02:	7a42                	ld	s4,48(sp)
     d04:	7aa2                	ld	s5,40(sp)
     d06:	7b02                	ld	s6,32(sp)
     d08:	6be2                	ld	s7,24(sp)
     d0a:	6125                	addi	sp,sp,96
     d0c:	8082                	ret

0000000000000d0e <stat>:

int
stat(const char *n, struct stat *st)
{
     d0e:	1101                	addi	sp,sp,-32
     d10:	ec06                	sd	ra,24(sp)
     d12:	e822                	sd	s0,16(sp)
     d14:	e426                	sd	s1,8(sp)
     d16:	e04a                	sd	s2,0(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d1c:	4581                	li	a1,0
     d1e:	00000097          	auipc	ra,0x0
     d22:	172080e7          	jalr	370(ra) # e90 <open>
  if(fd < 0)
     d26:	02054563          	bltz	a0,d50 <stat+0x42>
     d2a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d2c:	85ca                	mv	a1,s2
     d2e:	00000097          	auipc	ra,0x0
     d32:	17a080e7          	jalr	378(ra) # ea8 <fstat>
     d36:	892a                	mv	s2,a0
  close(fd);
     d38:	8526                	mv	a0,s1
     d3a:	00000097          	auipc	ra,0x0
     d3e:	13e080e7          	jalr	318(ra) # e78 <close>
  return r;
}
     d42:	854a                	mv	a0,s2
     d44:	60e2                	ld	ra,24(sp)
     d46:	6442                	ld	s0,16(sp)
     d48:	64a2                	ld	s1,8(sp)
     d4a:	6902                	ld	s2,0(sp)
     d4c:	6105                	addi	sp,sp,32
     d4e:	8082                	ret
    return -1;
     d50:	597d                	li	s2,-1
     d52:	bfc5                	j	d42 <stat+0x34>

0000000000000d54 <atoi>:

int
atoi(const char *s)
{
     d54:	1141                	addi	sp,sp,-16
     d56:	e422                	sd	s0,8(sp)
     d58:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d5a:	00054603          	lbu	a2,0(a0)
     d5e:	fd06079b          	addiw	a5,a2,-48
     d62:	0ff7f793          	andi	a5,a5,255
     d66:	4725                	li	a4,9
     d68:	02f76963          	bltu	a4,a5,d9a <atoi+0x46>
     d6c:	86aa                	mv	a3,a0
  n = 0;
     d6e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d70:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d72:	0685                	addi	a3,a3,1
     d74:	0025179b          	slliw	a5,a0,0x2
     d78:	9fa9                	addw	a5,a5,a0
     d7a:	0017979b          	slliw	a5,a5,0x1
     d7e:	9fb1                	addw	a5,a5,a2
     d80:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d84:	0006c603          	lbu	a2,0(a3)
     d88:	fd06071b          	addiw	a4,a2,-48
     d8c:	0ff77713          	andi	a4,a4,255
     d90:	fee5f1e3          	bgeu	a1,a4,d72 <atoi+0x1e>
  return n;
}
     d94:	6422                	ld	s0,8(sp)
     d96:	0141                	addi	sp,sp,16
     d98:	8082                	ret
  n = 0;
     d9a:	4501                	li	a0,0
     d9c:	bfe5                	j	d94 <atoi+0x40>

0000000000000d9e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d9e:	1141                	addi	sp,sp,-16
     da0:	e422                	sd	s0,8(sp)
     da2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     da4:	02b57463          	bgeu	a0,a1,dcc <memmove+0x2e>
    while(n-- > 0)
     da8:	00c05f63          	blez	a2,dc6 <memmove+0x28>
     dac:	1602                	slli	a2,a2,0x20
     dae:	9201                	srli	a2,a2,0x20
     db0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     db4:	872a                	mv	a4,a0
      *dst++ = *src++;
     db6:	0585                	addi	a1,a1,1
     db8:	0705                	addi	a4,a4,1
     dba:	fff5c683          	lbu	a3,-1(a1)
     dbe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dc2:	fee79ae3          	bne	a5,a4,db6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     dc6:	6422                	ld	s0,8(sp)
     dc8:	0141                	addi	sp,sp,16
     dca:	8082                	ret
    dst += n;
     dcc:	00c50733          	add	a4,a0,a2
    src += n;
     dd0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dd2:	fec05ae3          	blez	a2,dc6 <memmove+0x28>
     dd6:	fff6079b          	addiw	a5,a2,-1
     dda:	1782                	slli	a5,a5,0x20
     ddc:	9381                	srli	a5,a5,0x20
     dde:	fff7c793          	not	a5,a5
     de2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     de4:	15fd                	addi	a1,a1,-1
     de6:	177d                	addi	a4,a4,-1
     de8:	0005c683          	lbu	a3,0(a1)
     dec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     df0:	fee79ae3          	bne	a5,a4,de4 <memmove+0x46>
     df4:	bfc9                	j	dc6 <memmove+0x28>

0000000000000df6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     df6:	1141                	addi	sp,sp,-16
     df8:	e422                	sd	s0,8(sp)
     dfa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     dfc:	ca05                	beqz	a2,e2c <memcmp+0x36>
     dfe:	fff6069b          	addiw	a3,a2,-1
     e02:	1682                	slli	a3,a3,0x20
     e04:	9281                	srli	a3,a3,0x20
     e06:	0685                	addi	a3,a3,1
     e08:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e0a:	00054783          	lbu	a5,0(a0)
     e0e:	0005c703          	lbu	a4,0(a1)
     e12:	00e79863          	bne	a5,a4,e22 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e16:	0505                	addi	a0,a0,1
    p2++;
     e18:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e1a:	fed518e3          	bne	a0,a3,e0a <memcmp+0x14>
  }
  return 0;
     e1e:	4501                	li	a0,0
     e20:	a019                	j	e26 <memcmp+0x30>
      return *p1 - *p2;
     e22:	40e7853b          	subw	a0,a5,a4
}
     e26:	6422                	ld	s0,8(sp)
     e28:	0141                	addi	sp,sp,16
     e2a:	8082                	ret
  return 0;
     e2c:	4501                	li	a0,0
     e2e:	bfe5                	j	e26 <memcmp+0x30>

0000000000000e30 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e30:	1141                	addi	sp,sp,-16
     e32:	e406                	sd	ra,8(sp)
     e34:	e022                	sd	s0,0(sp)
     e36:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e38:	00000097          	auipc	ra,0x0
     e3c:	f66080e7          	jalr	-154(ra) # d9e <memmove>
}
     e40:	60a2                	ld	ra,8(sp)
     e42:	6402                	ld	s0,0(sp)
     e44:	0141                	addi	sp,sp,16
     e46:	8082                	ret

0000000000000e48 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e48:	4885                	li	a7,1
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e50:	4889                	li	a7,2
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e58:	488d                	li	a7,3
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e60:	4891                	li	a7,4
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <read>:
.global read
read:
 li a7, SYS_read
     e68:	4895                	li	a7,5
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <write>:
.global write
write:
 li a7, SYS_write
     e70:	48c1                	li	a7,16
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <close>:
.global close
close:
 li a7, SYS_close
     e78:	48d5                	li	a7,21
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e80:	4899                	li	a7,6
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e88:	489d                	li	a7,7
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <open>:
.global open
open:
 li a7, SYS_open
     e90:	48bd                	li	a7,15
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e98:	48c5                	li	a7,17
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ea0:	48c9                	li	a7,18
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ea8:	48a1                	li	a7,8
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <link>:
.global link
link:
 li a7, SYS_link
     eb0:	48cd                	li	a7,19
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     eb8:	48d1                	li	a7,20
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ec0:	48a5                	li	a7,9
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ec8:	48a9                	li	a7,10
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ed0:	48ad                	li	a7,11
 ecall
     ed2:	00000073          	ecall
 ret
     ed6:	8082                	ret

0000000000000ed8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ed8:	48b1                	li	a7,12
 ecall
     eda:	00000073          	ecall
 ret
     ede:	8082                	ret

0000000000000ee0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ee0:	48b5                	li	a7,13
 ecall
     ee2:	00000073          	ecall
 ret
     ee6:	8082                	ret

0000000000000ee8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ee8:	48b9                	li	a7,14
 ecall
     eea:	00000073          	ecall
 ret
     eee:	8082                	ret

0000000000000ef0 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
     ef0:	48d9                	li	a7,22
 ecall
     ef2:	00000073          	ecall
 ret
     ef6:	8082                	ret

0000000000000ef8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ef8:	1101                	addi	sp,sp,-32
     efa:	ec06                	sd	ra,24(sp)
     efc:	e822                	sd	s0,16(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f04:	4605                	li	a2,1
     f06:	fef40593          	addi	a1,s0,-17
     f0a:	00000097          	auipc	ra,0x0
     f0e:	f66080e7          	jalr	-154(ra) # e70 <write>
}
     f12:	60e2                	ld	ra,24(sp)
     f14:	6442                	ld	s0,16(sp)
     f16:	6105                	addi	sp,sp,32
     f18:	8082                	ret

0000000000000f1a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f1a:	7139                	addi	sp,sp,-64
     f1c:	fc06                	sd	ra,56(sp)
     f1e:	f822                	sd	s0,48(sp)
     f20:	f426                	sd	s1,40(sp)
     f22:	f04a                	sd	s2,32(sp)
     f24:	ec4e                	sd	s3,24(sp)
     f26:	0080                	addi	s0,sp,64
     f28:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f2a:	c299                	beqz	a3,f30 <printint+0x16>
     f2c:	0805c863          	bltz	a1,fbc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f30:	2581                	sext.w	a1,a1
  neg = 0;
     f32:	4881                	li	a7,0
     f34:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f38:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f3a:	2601                	sext.w	a2,a2
     f3c:	00000517          	auipc	a0,0x0
     f40:	59c50513          	addi	a0,a0,1436 # 14d8 <digits>
     f44:	883a                	mv	a6,a4
     f46:	2705                	addiw	a4,a4,1
     f48:	02c5f7bb          	remuw	a5,a1,a2
     f4c:	1782                	slli	a5,a5,0x20
     f4e:	9381                	srli	a5,a5,0x20
     f50:	97aa                	add	a5,a5,a0
     f52:	0007c783          	lbu	a5,0(a5)
     f56:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f5a:	0005879b          	sext.w	a5,a1
     f5e:	02c5d5bb          	divuw	a1,a1,a2
     f62:	0685                	addi	a3,a3,1
     f64:	fec7f0e3          	bgeu	a5,a2,f44 <printint+0x2a>
  if(neg)
     f68:	00088b63          	beqz	a7,f7e <printint+0x64>
    buf[i++] = '-';
     f6c:	fd040793          	addi	a5,s0,-48
     f70:	973e                	add	a4,a4,a5
     f72:	02d00793          	li	a5,45
     f76:	fef70823          	sb	a5,-16(a4)
     f7a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f7e:	02e05863          	blez	a4,fae <printint+0x94>
     f82:	fc040793          	addi	a5,s0,-64
     f86:	00e78933          	add	s2,a5,a4
     f8a:	fff78993          	addi	s3,a5,-1
     f8e:	99ba                	add	s3,s3,a4
     f90:	377d                	addiw	a4,a4,-1
     f92:	1702                	slli	a4,a4,0x20
     f94:	9301                	srli	a4,a4,0x20
     f96:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f9a:	fff94583          	lbu	a1,-1(s2)
     f9e:	8526                	mv	a0,s1
     fa0:	00000097          	auipc	ra,0x0
     fa4:	f58080e7          	jalr	-168(ra) # ef8 <putc>
  while(--i >= 0)
     fa8:	197d                	addi	s2,s2,-1
     faa:	ff3918e3          	bne	s2,s3,f9a <printint+0x80>
}
     fae:	70e2                	ld	ra,56(sp)
     fb0:	7442                	ld	s0,48(sp)
     fb2:	74a2                	ld	s1,40(sp)
     fb4:	7902                	ld	s2,32(sp)
     fb6:	69e2                	ld	s3,24(sp)
     fb8:	6121                	addi	sp,sp,64
     fba:	8082                	ret
    x = -xx;
     fbc:	40b005bb          	negw	a1,a1
    neg = 1;
     fc0:	4885                	li	a7,1
    x = -xx;
     fc2:	bf8d                	j	f34 <printint+0x1a>

0000000000000fc4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fc4:	7119                	addi	sp,sp,-128
     fc6:	fc86                	sd	ra,120(sp)
     fc8:	f8a2                	sd	s0,112(sp)
     fca:	f4a6                	sd	s1,104(sp)
     fcc:	f0ca                	sd	s2,96(sp)
     fce:	ecce                	sd	s3,88(sp)
     fd0:	e8d2                	sd	s4,80(sp)
     fd2:	e4d6                	sd	s5,72(sp)
     fd4:	e0da                	sd	s6,64(sp)
     fd6:	fc5e                	sd	s7,56(sp)
     fd8:	f862                	sd	s8,48(sp)
     fda:	f466                	sd	s9,40(sp)
     fdc:	f06a                	sd	s10,32(sp)
     fde:	ec6e                	sd	s11,24(sp)
     fe0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fe2:	0005c903          	lbu	s2,0(a1)
     fe6:	18090f63          	beqz	s2,1184 <vprintf+0x1c0>
     fea:	8aaa                	mv	s5,a0
     fec:	8b32                	mv	s6,a2
     fee:	00158493          	addi	s1,a1,1
  state = 0;
     ff2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ff4:	02500a13          	li	s4,37
      if(c == 'd'){
     ff8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     ffc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1000:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1004:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1008:	00000b97          	auipc	s7,0x0
    100c:	4d0b8b93          	addi	s7,s7,1232 # 14d8 <digits>
    1010:	a839                	j	102e <vprintf+0x6a>
        putc(fd, c);
    1012:	85ca                	mv	a1,s2
    1014:	8556                	mv	a0,s5
    1016:	00000097          	auipc	ra,0x0
    101a:	ee2080e7          	jalr	-286(ra) # ef8 <putc>
    101e:	a019                	j	1024 <vprintf+0x60>
    } else if(state == '%'){
    1020:	01498f63          	beq	s3,s4,103e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1024:	0485                	addi	s1,s1,1
    1026:	fff4c903          	lbu	s2,-1(s1)
    102a:	14090d63          	beqz	s2,1184 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    102e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1032:	fe0997e3          	bnez	s3,1020 <vprintf+0x5c>
      if(c == '%'){
    1036:	fd479ee3          	bne	a5,s4,1012 <vprintf+0x4e>
        state = '%';
    103a:	89be                	mv	s3,a5
    103c:	b7e5                	j	1024 <vprintf+0x60>
      if(c == 'd'){
    103e:	05878063          	beq	a5,s8,107e <vprintf+0xba>
      } else if(c == 'l') {
    1042:	05978c63          	beq	a5,s9,109a <vprintf+0xd6>
      } else if(c == 'x') {
    1046:	07a78863          	beq	a5,s10,10b6 <vprintf+0xf2>
      } else if(c == 'p') {
    104a:	09b78463          	beq	a5,s11,10d2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    104e:	07300713          	li	a4,115
    1052:	0ce78663          	beq	a5,a4,111e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1056:	06300713          	li	a4,99
    105a:	0ee78e63          	beq	a5,a4,1156 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    105e:	11478863          	beq	a5,s4,116e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1062:	85d2                	mv	a1,s4
    1064:	8556                	mv	a0,s5
    1066:	00000097          	auipc	ra,0x0
    106a:	e92080e7          	jalr	-366(ra) # ef8 <putc>
        putc(fd, c);
    106e:	85ca                	mv	a1,s2
    1070:	8556                	mv	a0,s5
    1072:	00000097          	auipc	ra,0x0
    1076:	e86080e7          	jalr	-378(ra) # ef8 <putc>
      }
      state = 0;
    107a:	4981                	li	s3,0
    107c:	b765                	j	1024 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    107e:	008b0913          	addi	s2,s6,8
    1082:	4685                	li	a3,1
    1084:	4629                	li	a2,10
    1086:	000b2583          	lw	a1,0(s6)
    108a:	8556                	mv	a0,s5
    108c:	00000097          	auipc	ra,0x0
    1090:	e8e080e7          	jalr	-370(ra) # f1a <printint>
    1094:	8b4a                	mv	s6,s2
      state = 0;
    1096:	4981                	li	s3,0
    1098:	b771                	j	1024 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    109a:	008b0913          	addi	s2,s6,8
    109e:	4681                	li	a3,0
    10a0:	4629                	li	a2,10
    10a2:	000b2583          	lw	a1,0(s6)
    10a6:	8556                	mv	a0,s5
    10a8:	00000097          	auipc	ra,0x0
    10ac:	e72080e7          	jalr	-398(ra) # f1a <printint>
    10b0:	8b4a                	mv	s6,s2
      state = 0;
    10b2:	4981                	li	s3,0
    10b4:	bf85                	j	1024 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10b6:	008b0913          	addi	s2,s6,8
    10ba:	4681                	li	a3,0
    10bc:	4641                	li	a2,16
    10be:	000b2583          	lw	a1,0(s6)
    10c2:	8556                	mv	a0,s5
    10c4:	00000097          	auipc	ra,0x0
    10c8:	e56080e7          	jalr	-426(ra) # f1a <printint>
    10cc:	8b4a                	mv	s6,s2
      state = 0;
    10ce:	4981                	li	s3,0
    10d0:	bf91                	j	1024 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10d2:	008b0793          	addi	a5,s6,8
    10d6:	f8f43423          	sd	a5,-120(s0)
    10da:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10de:	03000593          	li	a1,48
    10e2:	8556                	mv	a0,s5
    10e4:	00000097          	auipc	ra,0x0
    10e8:	e14080e7          	jalr	-492(ra) # ef8 <putc>
  putc(fd, 'x');
    10ec:	85ea                	mv	a1,s10
    10ee:	8556                	mv	a0,s5
    10f0:	00000097          	auipc	ra,0x0
    10f4:	e08080e7          	jalr	-504(ra) # ef8 <putc>
    10f8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10fa:	03c9d793          	srli	a5,s3,0x3c
    10fe:	97de                	add	a5,a5,s7
    1100:	0007c583          	lbu	a1,0(a5)
    1104:	8556                	mv	a0,s5
    1106:	00000097          	auipc	ra,0x0
    110a:	df2080e7          	jalr	-526(ra) # ef8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    110e:	0992                	slli	s3,s3,0x4
    1110:	397d                	addiw	s2,s2,-1
    1112:	fe0914e3          	bnez	s2,10fa <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1116:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    111a:	4981                	li	s3,0
    111c:	b721                	j	1024 <vprintf+0x60>
        s = va_arg(ap, char*);
    111e:	008b0993          	addi	s3,s6,8
    1122:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1126:	02090163          	beqz	s2,1148 <vprintf+0x184>
        while(*s != 0){
    112a:	00094583          	lbu	a1,0(s2)
    112e:	c9a1                	beqz	a1,117e <vprintf+0x1ba>
          putc(fd, *s);
    1130:	8556                	mv	a0,s5
    1132:	00000097          	auipc	ra,0x0
    1136:	dc6080e7          	jalr	-570(ra) # ef8 <putc>
          s++;
    113a:	0905                	addi	s2,s2,1
        while(*s != 0){
    113c:	00094583          	lbu	a1,0(s2)
    1140:	f9e5                	bnez	a1,1130 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1142:	8b4e                	mv	s6,s3
      state = 0;
    1144:	4981                	li	s3,0
    1146:	bdf9                	j	1024 <vprintf+0x60>
          s = "(null)";
    1148:	00000917          	auipc	s2,0x0
    114c:	38890913          	addi	s2,s2,904 # 14d0 <malloc+0x242>
        while(*s != 0){
    1150:	02800593          	li	a1,40
    1154:	bff1                	j	1130 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1156:	008b0913          	addi	s2,s6,8
    115a:	000b4583          	lbu	a1,0(s6)
    115e:	8556                	mv	a0,s5
    1160:	00000097          	auipc	ra,0x0
    1164:	d98080e7          	jalr	-616(ra) # ef8 <putc>
    1168:	8b4a                	mv	s6,s2
      state = 0;
    116a:	4981                	li	s3,0
    116c:	bd65                	j	1024 <vprintf+0x60>
        putc(fd, c);
    116e:	85d2                	mv	a1,s4
    1170:	8556                	mv	a0,s5
    1172:	00000097          	auipc	ra,0x0
    1176:	d86080e7          	jalr	-634(ra) # ef8 <putc>
      state = 0;
    117a:	4981                	li	s3,0
    117c:	b565                	j	1024 <vprintf+0x60>
        s = va_arg(ap, char*);
    117e:	8b4e                	mv	s6,s3
      state = 0;
    1180:	4981                	li	s3,0
    1182:	b54d                	j	1024 <vprintf+0x60>
    }
  }
}
    1184:	70e6                	ld	ra,120(sp)
    1186:	7446                	ld	s0,112(sp)
    1188:	74a6                	ld	s1,104(sp)
    118a:	7906                	ld	s2,96(sp)
    118c:	69e6                	ld	s3,88(sp)
    118e:	6a46                	ld	s4,80(sp)
    1190:	6aa6                	ld	s5,72(sp)
    1192:	6b06                	ld	s6,64(sp)
    1194:	7be2                	ld	s7,56(sp)
    1196:	7c42                	ld	s8,48(sp)
    1198:	7ca2                	ld	s9,40(sp)
    119a:	7d02                	ld	s10,32(sp)
    119c:	6de2                	ld	s11,24(sp)
    119e:	6109                	addi	sp,sp,128
    11a0:	8082                	ret

00000000000011a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11a2:	715d                	addi	sp,sp,-80
    11a4:	ec06                	sd	ra,24(sp)
    11a6:	e822                	sd	s0,16(sp)
    11a8:	1000                	addi	s0,sp,32
    11aa:	e010                	sd	a2,0(s0)
    11ac:	e414                	sd	a3,8(s0)
    11ae:	e818                	sd	a4,16(s0)
    11b0:	ec1c                	sd	a5,24(s0)
    11b2:	03043023          	sd	a6,32(s0)
    11b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11be:	8622                	mv	a2,s0
    11c0:	00000097          	auipc	ra,0x0
    11c4:	e04080e7          	jalr	-508(ra) # fc4 <vprintf>
}
    11c8:	60e2                	ld	ra,24(sp)
    11ca:	6442                	ld	s0,16(sp)
    11cc:	6161                	addi	sp,sp,80
    11ce:	8082                	ret

00000000000011d0 <printf>:

void
printf(const char *fmt, ...)
{
    11d0:	711d                	addi	sp,sp,-96
    11d2:	ec06                	sd	ra,24(sp)
    11d4:	e822                	sd	s0,16(sp)
    11d6:	1000                	addi	s0,sp,32
    11d8:	e40c                	sd	a1,8(s0)
    11da:	e810                	sd	a2,16(s0)
    11dc:	ec14                	sd	a3,24(s0)
    11de:	f018                	sd	a4,32(s0)
    11e0:	f41c                	sd	a5,40(s0)
    11e2:	03043823          	sd	a6,48(s0)
    11e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11ea:	00840613          	addi	a2,s0,8
    11ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11f2:	85aa                	mv	a1,a0
    11f4:	4505                	li	a0,1
    11f6:	00000097          	auipc	ra,0x0
    11fa:	dce080e7          	jalr	-562(ra) # fc4 <vprintf>
}
    11fe:	60e2                	ld	ra,24(sp)
    1200:	6442                	ld	s0,16(sp)
    1202:	6125                	addi	sp,sp,96
    1204:	8082                	ret

0000000000001206 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1206:	1141                	addi	sp,sp,-16
    1208:	e422                	sd	s0,8(sp)
    120a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    120c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1210:	00001797          	auipc	a5,0x1
    1214:	e007b783          	ld	a5,-512(a5) # 2010 <freep>
    1218:	a805                	j	1248 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    121a:	4618                	lw	a4,8(a2)
    121c:	9db9                	addw	a1,a1,a4
    121e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1222:	6398                	ld	a4,0(a5)
    1224:	6318                	ld	a4,0(a4)
    1226:	fee53823          	sd	a4,-16(a0)
    122a:	a091                	j	126e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    122c:	ff852703          	lw	a4,-8(a0)
    1230:	9e39                	addw	a2,a2,a4
    1232:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1234:	ff053703          	ld	a4,-16(a0)
    1238:	e398                	sd	a4,0(a5)
    123a:	a099                	j	1280 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    123c:	6398                	ld	a4,0(a5)
    123e:	00e7e463          	bltu	a5,a4,1246 <free+0x40>
    1242:	00e6ea63          	bltu	a3,a4,1256 <free+0x50>
{
    1246:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1248:	fed7fae3          	bgeu	a5,a3,123c <free+0x36>
    124c:	6398                	ld	a4,0(a5)
    124e:	00e6e463          	bltu	a3,a4,1256 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1252:	fee7eae3          	bltu	a5,a4,1246 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1256:	ff852583          	lw	a1,-8(a0)
    125a:	6390                	ld	a2,0(a5)
    125c:	02059713          	slli	a4,a1,0x20
    1260:	9301                	srli	a4,a4,0x20
    1262:	0712                	slli	a4,a4,0x4
    1264:	9736                	add	a4,a4,a3
    1266:	fae60ae3          	beq	a2,a4,121a <free+0x14>
    bp->s.ptr = p->s.ptr;
    126a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    126e:	4790                	lw	a2,8(a5)
    1270:	02061713          	slli	a4,a2,0x20
    1274:	9301                	srli	a4,a4,0x20
    1276:	0712                	slli	a4,a4,0x4
    1278:	973e                	add	a4,a4,a5
    127a:	fae689e3          	beq	a3,a4,122c <free+0x26>
  } else
    p->s.ptr = bp;
    127e:	e394                	sd	a3,0(a5)
  freep = p;
    1280:	00001717          	auipc	a4,0x1
    1284:	d8f73823          	sd	a5,-624(a4) # 2010 <freep>
}
    1288:	6422                	ld	s0,8(sp)
    128a:	0141                	addi	sp,sp,16
    128c:	8082                	ret

000000000000128e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    128e:	7139                	addi	sp,sp,-64
    1290:	fc06                	sd	ra,56(sp)
    1292:	f822                	sd	s0,48(sp)
    1294:	f426                	sd	s1,40(sp)
    1296:	f04a                	sd	s2,32(sp)
    1298:	ec4e                	sd	s3,24(sp)
    129a:	e852                	sd	s4,16(sp)
    129c:	e456                	sd	s5,8(sp)
    129e:	e05a                	sd	s6,0(sp)
    12a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12a2:	02051493          	slli	s1,a0,0x20
    12a6:	9081                	srli	s1,s1,0x20
    12a8:	04bd                	addi	s1,s1,15
    12aa:	8091                	srli	s1,s1,0x4
    12ac:	0014899b          	addiw	s3,s1,1
    12b0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12b2:	00001517          	auipc	a0,0x1
    12b6:	d5e53503          	ld	a0,-674(a0) # 2010 <freep>
    12ba:	c515                	beqz	a0,12e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12bc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12be:	4798                	lw	a4,8(a5)
    12c0:	02977f63          	bgeu	a4,s1,12fe <malloc+0x70>
    12c4:	8a4e                	mv	s4,s3
    12c6:	0009871b          	sext.w	a4,s3
    12ca:	6685                	lui	a3,0x1
    12cc:	00d77363          	bgeu	a4,a3,12d2 <malloc+0x44>
    12d0:	6a05                	lui	s4,0x1
    12d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12da:	00001917          	auipc	s2,0x1
    12de:	d3690913          	addi	s2,s2,-714 # 2010 <freep>
  if(p == (char*)-1)
    12e2:	5afd                	li	s5,-1
    12e4:	a88d                	j	1356 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    12e6:	00001797          	auipc	a5,0x1
    12ea:	da278793          	addi	a5,a5,-606 # 2088 <base>
    12ee:	00001717          	auipc	a4,0x1
    12f2:	d2f73123          	sd	a5,-734(a4) # 2010 <freep>
    12f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12fc:	b7e1                	j	12c4 <malloc+0x36>
      if(p->s.size == nunits)
    12fe:	02e48b63          	beq	s1,a4,1334 <malloc+0xa6>
        p->s.size -= nunits;
    1302:	4137073b          	subw	a4,a4,s3
    1306:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1308:	1702                	slli	a4,a4,0x20
    130a:	9301                	srli	a4,a4,0x20
    130c:	0712                	slli	a4,a4,0x4
    130e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1310:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1314:	00001717          	auipc	a4,0x1
    1318:	cea73e23          	sd	a0,-772(a4) # 2010 <freep>
      return (void*)(p + 1);
    131c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1320:	70e2                	ld	ra,56(sp)
    1322:	7442                	ld	s0,48(sp)
    1324:	74a2                	ld	s1,40(sp)
    1326:	7902                	ld	s2,32(sp)
    1328:	69e2                	ld	s3,24(sp)
    132a:	6a42                	ld	s4,16(sp)
    132c:	6aa2                	ld	s5,8(sp)
    132e:	6b02                	ld	s6,0(sp)
    1330:	6121                	addi	sp,sp,64
    1332:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1334:	6398                	ld	a4,0(a5)
    1336:	e118                	sd	a4,0(a0)
    1338:	bff1                	j	1314 <malloc+0x86>
  hp->s.size = nu;
    133a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    133e:	0541                	addi	a0,a0,16
    1340:	00000097          	auipc	ra,0x0
    1344:	ec6080e7          	jalr	-314(ra) # 1206 <free>
  return freep;
    1348:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    134c:	d971                	beqz	a0,1320 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    134e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1350:	4798                	lw	a4,8(a5)
    1352:	fa9776e3          	bgeu	a4,s1,12fe <malloc+0x70>
    if(p == freep)
    1356:	00093703          	ld	a4,0(s2)
    135a:	853e                	mv	a0,a5
    135c:	fef719e3          	bne	a4,a5,134e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1360:	8552                	mv	a0,s4
    1362:	00000097          	auipc	ra,0x0
    1366:	b76080e7          	jalr	-1162(ra) # ed8 <sbrk>
  if(p == (char*)-1)
    136a:	fd5518e3          	bne	a0,s5,133a <malloc+0xac>
        return 0;
    136e:	4501                	li	a0,0
    1370:	bf45                	j	1320 <malloc+0x92>
