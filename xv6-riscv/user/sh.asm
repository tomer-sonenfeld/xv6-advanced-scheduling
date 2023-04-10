
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
      16:	35e58593          	addi	a1,a1,862 # 1370 <malloc+0xf2>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e3c080e7          	jalr	-452(ra) # e58 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	c12080e7          	jalr	-1006(ra) # c3c <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c4c080e7          	jalr	-948(ra) # c82 <gets>
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
      64:	31858593          	addi	a1,a1,792 # 1378 <malloc+0xfa>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	128080e7          	jalr	296(ra) # 1192 <fprintf>
  exit(1,"");
      72:	00001597          	auipc	a1,0x1
      76:	30e58593          	addi	a1,a1,782 # 1380 <malloc+0x102>
      7a:	4505                	li	a0,1
      7c:	00001097          	auipc	ra,0x1
      80:	dbc080e7          	jalr	-580(ra) # e38 <exit>

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
      90:	da4080e7          	jalr	-604(ra) # e30 <fork>
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
      a6:	2e650513          	addi	a0,a0,742 # 1388 <malloc+0x10a>
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
      d2:	3b670713          	addi	a4,a4,950 # 1484 <malloc+0x206>
      d6:	97ba                	add	a5,a5,a4
      d8:	439c                	lw	a5,0(a5)
      da:	97ba                	add	a5,a5,a4
      dc:	8782                	jr	a5
    exit(1,"");
      de:	00001597          	auipc	a1,0x1
      e2:	2a258593          	addi	a1,a1,674 # 1380 <malloc+0x102>
      e6:	4505                	li	a0,1
      e8:	00001097          	auipc	ra,0x1
      ec:	d50080e7          	jalr	-688(ra) # e38 <exit>
    panic("runcmd");
      f0:	00001517          	auipc	a0,0x1
      f4:	2a050513          	addi	a0,a0,672 # 1390 <malloc+0x112>
      f8:	00000097          	auipc	ra,0x0
      fc:	f5e080e7          	jalr	-162(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
     100:	6508                	ld	a0,8(a0)
     102:	c915                	beqz	a0,136 <runcmd+0x84>
    exec(ecmd->argv[0], ecmd->argv);
     104:	00848593          	addi	a1,s1,8
     108:	00001097          	auipc	ra,0x1
     10c:	d68080e7          	jalr	-664(ra) # e70 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     110:	6490                	ld	a2,8(s1)
     112:	00001597          	auipc	a1,0x1
     116:	28658593          	addi	a1,a1,646 # 1398 <malloc+0x11a>
     11a:	4509                	li	a0,2
     11c:	00001097          	auipc	ra,0x1
     120:	076080e7          	jalr	118(ra) # 1192 <fprintf>
  exit(0,"");
     124:	00001597          	auipc	a1,0x1
     128:	25c58593          	addi	a1,a1,604 # 1380 <malloc+0x102>
     12c:	4501                	li	a0,0
     12e:	00001097          	auipc	ra,0x1
     132:	d0a080e7          	jalr	-758(ra) # e38 <exit>
      exit(1,"");
     136:	00001597          	auipc	a1,0x1
     13a:	24a58593          	addi	a1,a1,586 # 1380 <malloc+0x102>
     13e:	4505                	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	cf8080e7          	jalr	-776(ra) # e38 <exit>
    close(rcmd->fd);
     148:	5148                	lw	a0,36(a0)
     14a:	00001097          	auipc	ra,0x1
     14e:	d16080e7          	jalr	-746(ra) # e60 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     152:	508c                	lw	a1,32(s1)
     154:	6888                	ld	a0,16(s1)
     156:	00001097          	auipc	ra,0x1
     15a:	d22080e7          	jalr	-734(ra) # e78 <open>
     15e:	00054763          	bltz	a0,16c <runcmd+0xba>
    runcmd(rcmd->cmd);
     162:	6488                	ld	a0,8(s1)
     164:	00000097          	auipc	ra,0x0
     168:	f4e080e7          	jalr	-178(ra) # b2 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     16c:	6890                	ld	a2,16(s1)
     16e:	00001597          	auipc	a1,0x1
     172:	23a58593          	addi	a1,a1,570 # 13a8 <malloc+0x12a>
     176:	4509                	li	a0,2
     178:	00001097          	auipc	ra,0x1
     17c:	01a080e7          	jalr	26(ra) # 1192 <fprintf>
      exit(1,"");
     180:	00001597          	auipc	a1,0x1
     184:	20058593          	addi	a1,a1,512 # 1380 <malloc+0x102>
     188:	4505                	li	a0,1
     18a:	00001097          	auipc	ra,0x1
     18e:	cae080e7          	jalr	-850(ra) # e38 <exit>
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
     1ae:	c96080e7          	jalr	-874(ra) # e40 <wait>
    runcmd(lcmd->right);
     1b2:	6888                	ld	a0,16(s1)
     1b4:	00000097          	auipc	ra,0x0
     1b8:	efe080e7          	jalr	-258(ra) # b2 <runcmd>
    if(pipe(p) < 0)
     1bc:	fd840513          	addi	a0,s0,-40
     1c0:	00001097          	auipc	ra,0x1
     1c4:	c88080e7          	jalr	-888(ra) # e48 <pipe>
     1c8:	04054363          	bltz	a0,20e <runcmd+0x15c>
    if(fork1() == 0){
     1cc:	00000097          	auipc	ra,0x0
     1d0:	eb8080e7          	jalr	-328(ra) # 84 <fork1>
     1d4:	e529                	bnez	a0,21e <runcmd+0x16c>
      close(1);
     1d6:	4505                	li	a0,1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	c88080e7          	jalr	-888(ra) # e60 <close>
      dup(p[1]);
     1e0:	fdc42503          	lw	a0,-36(s0)
     1e4:	00001097          	auipc	ra,0x1
     1e8:	ccc080e7          	jalr	-820(ra) # eb0 <dup>
      close(p[0]);
     1ec:	fd842503          	lw	a0,-40(s0)
     1f0:	00001097          	auipc	ra,0x1
     1f4:	c70080e7          	jalr	-912(ra) # e60 <close>
      close(p[1]);
     1f8:	fdc42503          	lw	a0,-36(s0)
     1fc:	00001097          	auipc	ra,0x1
     200:	c64080e7          	jalr	-924(ra) # e60 <close>
      runcmd(pcmd->left);
     204:	6488                	ld	a0,8(s1)
     206:	00000097          	auipc	ra,0x0
     20a:	eac080e7          	jalr	-340(ra) # b2 <runcmd>
      panic("pipe");
     20e:	00001517          	auipc	a0,0x1
     212:	1aa50513          	addi	a0,a0,426 # 13b8 <malloc+0x13a>
     216:	00000097          	auipc	ra,0x0
     21a:	e40080e7          	jalr	-448(ra) # 56 <panic>
    if(fork1() == 0){
     21e:	00000097          	auipc	ra,0x0
     222:	e66080e7          	jalr	-410(ra) # 84 <fork1>
     226:	ed05                	bnez	a0,25e <runcmd+0x1ac>
      close(0);
     228:	00001097          	auipc	ra,0x1
     22c:	c38080e7          	jalr	-968(ra) # e60 <close>
      dup(p[0]);
     230:	fd842503          	lw	a0,-40(s0)
     234:	00001097          	auipc	ra,0x1
     238:	c7c080e7          	jalr	-900(ra) # eb0 <dup>
      close(p[0]);
     23c:	fd842503          	lw	a0,-40(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c20080e7          	jalr	-992(ra) # e60 <close>
      close(p[1]);
     248:	fdc42503          	lw	a0,-36(s0)
     24c:	00001097          	auipc	ra,0x1
     250:	c14080e7          	jalr	-1004(ra) # e60 <close>
      runcmd(pcmd->right);
     254:	6888                	ld	a0,16(s1)
     256:	00000097          	auipc	ra,0x0
     25a:	e5c080e7          	jalr	-420(ra) # b2 <runcmd>
    close(p[0]);
     25e:	fd842503          	lw	a0,-40(s0)
     262:	00001097          	auipc	ra,0x1
     266:	bfe080e7          	jalr	-1026(ra) # e60 <close>
    close(p[1]);
     26a:	fdc42503          	lw	a0,-36(s0)
     26e:	00001097          	auipc	ra,0x1
     272:	bf2080e7          	jalr	-1038(ra) # e60 <close>
    wait(0, 0);
     276:	4581                	li	a1,0
     278:	4501                	li	a0,0
     27a:	00001097          	auipc	ra,0x1
     27e:	bc6080e7          	jalr	-1082(ra) # e40 <wait>
    wait(0, 0);
     282:	4581                	li	a1,0
     284:	4501                	li	a0,0
     286:	00001097          	auipc	ra,0x1
     28a:	bba080e7          	jalr	-1094(ra) # e40 <wait>
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
     2b8:	fca080e7          	jalr	-54(ra) # 127e <malloc>
     2bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2be:	0a800613          	li	a2,168
     2c2:	4581                	li	a1,0
     2c4:	00001097          	auipc	ra,0x1
     2c8:	978080e7          	jalr	-1672(ra) # c3c <memset>
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
     302:	f80080e7          	jalr	-128(ra) # 127e <malloc>
     306:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     308:	02800613          	li	a2,40
     30c:	4581                	li	a1,0
     30e:	00001097          	auipc	ra,0x1
     312:	92e080e7          	jalr	-1746(ra) # c3c <memset>
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
     35c:	f26080e7          	jalr	-218(ra) # 127e <malloc>
     360:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     362:	4661                	li	a2,24
     364:	4581                	li	a1,0
     366:	00001097          	auipc	ra,0x1
     36a:	8d6080e7          	jalr	-1834(ra) # c3c <memset>
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
     3a2:	ee0080e7          	jalr	-288(ra) # 127e <malloc>
     3a6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3a8:	4661                	li	a2,24
     3aa:	4581                	li	a1,0
     3ac:	00001097          	auipc	ra,0x1
     3b0:	890080e7          	jalr	-1904(ra) # c3c <memset>
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
     3e4:	e9e080e7          	jalr	-354(ra) # 127e <malloc>
     3e8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ea:	4641                	li	a2,16
     3ec:	4581                	li	a1,0
     3ee:	00001097          	auipc	ra,0x1
     3f2:	84e080e7          	jalr	-1970(ra) # c3c <memset>
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
     440:	822080e7          	jalr	-2014(ra) # c5e <strchr>
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
     4a4:	7be080e7          	jalr	1982(ra) # c5e <strchr>
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
     516:	74c080e7          	jalr	1868(ra) # c5e <strchr>
     51a:	e505                	bnez	a0,542 <gettoken+0x136>
     51c:	0004c583          	lbu	a1,0(s1)
     520:	8556                	mv	a0,s5
     522:	00000097          	auipc	ra,0x0
     526:	73c080e7          	jalr	1852(ra) # c5e <strchr>
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
     578:	6ea080e7          	jalr	1770(ra) # c5e <strchr>
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
     5a8:	6ba080e7          	jalr	1722(ra) # c5e <strchr>
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
     5d6:	e0eb8b93          	addi	s7,s7,-498 # 13e0 <malloc+0x162>
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
     5e8:	ddc50513          	addi	a0,a0,-548 # 13c0 <malloc+0x142>
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
     6d0:	d1c60613          	addi	a2,a2,-740 # 13e8 <malloc+0x16a>
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
     700:	d0cb0b13          	addi	s6,s6,-756 # 1408 <malloc+0x18a>
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
     73a:	cba50513          	addi	a0,a0,-838 # 13f0 <malloc+0x172>
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
     79c:	c6050513          	addi	a0,a0,-928 # 13f8 <malloc+0x17a>
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
     7d6:	c3e60613          	addi	a2,a2,-962 # 1410 <malloc+0x192>
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
     846:	bd6a0a13          	addi	s4,s4,-1066 # 1418 <malloc+0x19a>
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
     87c:	ba860613          	addi	a2,a2,-1112 # 1420 <malloc+0x1a2>
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
     8e2:	b0a60613          	addi	a2,a2,-1270 # 13e8 <malloc+0x16a>
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
     912:	b2a60613          	addi	a2,a2,-1238 # 1438 <malloc+0x1ba>
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
     954:	ad850513          	addi	a0,a0,-1320 # 1428 <malloc+0x1aa>
     958:	fffff097          	auipc	ra,0xfffff
     95c:	6fe080e7          	jalr	1790(ra) # 56 <panic>
    panic("syntax - missing )");
     960:	00001517          	auipc	a0,0x1
     964:	ae050513          	addi	a0,a0,-1312 # 1440 <malloc+0x1c2>
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
     990:	b1070713          	addi	a4,a4,-1264 # 149c <malloc+0x21e>
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
     a1e:	1f8080e7          	jalr	504(ra) # c12 <strlen>
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
     a3c:	94860613          	addi	a2,a2,-1720 # 1380 <malloc+0x102>
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
     a72:	9ea58593          	addi	a1,a1,-1558 # 1458 <malloc+0x1da>
     a76:	4509                	li	a0,2
     a78:	00000097          	auipc	ra,0x0
     a7c:	71a080e7          	jalr	1818(ra) # 1192 <fprintf>
    panic("syntax");
     a80:	00001517          	auipc	a0,0x1
     a84:	97050513          	addi	a0,a0,-1680 # 13f0 <malloc+0x172>
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
  while((fd = open("console", O_RDWR)) >= 0){
     aa4:	00001497          	auipc	s1,0x1
     aa8:	9c448493          	addi	s1,s1,-1596 # 1468 <malloc+0x1ea>
     aac:	4589                	li	a1,2
     aae:	8526                	mv	a0,s1
     ab0:	00000097          	auipc	ra,0x0
     ab4:	3c8080e7          	jalr	968(ra) # e78 <open>
     ab8:	00054963          	bltz	a0,aca <main+0x3a>
    if(fd >= 3){
     abc:	4789                	li	a5,2
     abe:	fea7d7e3          	bge	a5,a0,aac <main+0x1c>
      close(fd);
     ac2:	00000097          	auipc	ra,0x0
     ac6:	39e080e7          	jalr	926(ra) # e60 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aca:	00001497          	auipc	s1,0x1
     ace:	55648493          	addi	s1,s1,1366 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ad2:	06300913          	li	s2,99
    printf("%s",msg);
     ad6:	00001997          	auipc	s3,0x1
     ada:	9aa98993          	addi	s3,s3,-1622 # 1480 <malloc+0x202>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ade:	02000a13          	li	s4,32
      if(chdir(buf+3) < 0)
     ae2:	00001a97          	auipc	s5,0x1
     ae6:	541a8a93          	addi	s5,s5,1345 # 2023 <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     aea:	00001b17          	auipc	s6,0x1
     aee:	986b0b13          	addi	s6,s6,-1658 # 1470 <malloc+0x1f2>
     af2:	a025                	j	b1a <main+0x8a>
    if(fork1() == 0)
     af4:	fffff097          	auipc	ra,0xfffff
     af8:	590080e7          	jalr	1424(ra) # 84 <fork1>
     afc:	c149                	beqz	a0,b7e <main+0xee>
    wait(0, msg);
     afe:	fa040593          	addi	a1,s0,-96
     b02:	4501                	li	a0,0
     b04:	00000097          	auipc	ra,0x0
     b08:	33c080e7          	jalr	828(ra) # e40 <wait>
    printf("%s",msg);
     b0c:	fa040593          	addi	a1,s0,-96
     b10:	854e                	mv	a0,s3
     b12:	00000097          	auipc	ra,0x0
     b16:	6ae080e7          	jalr	1710(ra) # 11c0 <printf>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b1a:	06400593          	li	a1,100
     b1e:	8526                	mv	a0,s1
     b20:	fffff097          	auipc	ra,0xfffff
     b24:	4e0080e7          	jalr	1248(ra) # 0 <getcmd>
     b28:	06054763          	bltz	a0,b96 <main+0x106>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b2c:	0004c783          	lbu	a5,0(s1)
     b30:	fd2792e3          	bne	a5,s2,af4 <main+0x64>
     b34:	0014c703          	lbu	a4,1(s1)
     b38:	06400793          	li	a5,100
     b3c:	faf71ce3          	bne	a4,a5,af4 <main+0x64>
     b40:	0024c783          	lbu	a5,2(s1)
     b44:	fb4798e3          	bne	a5,s4,af4 <main+0x64>
      buf[strlen(buf)-1] = 0;  // chop \n
     b48:	8526                	mv	a0,s1
     b4a:	00000097          	auipc	ra,0x0
     b4e:	0c8080e7          	jalr	200(ra) # c12 <strlen>
     b52:	fff5079b          	addiw	a5,a0,-1
     b56:	1782                	slli	a5,a5,0x20
     b58:	9381                	srli	a5,a5,0x20
     b5a:	97a6                	add	a5,a5,s1
     b5c:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b60:	8556                	mv	a0,s5
     b62:	00000097          	auipc	ra,0x0
     b66:	346080e7          	jalr	838(ra) # ea8 <chdir>
     b6a:	fa0558e3          	bgez	a0,b1a <main+0x8a>
        fprintf(2, "cannot cd %s\n", buf+3);
     b6e:	8656                	mv	a2,s5
     b70:	85da                	mv	a1,s6
     b72:	4509                	li	a0,2
     b74:	00000097          	auipc	ra,0x0
     b78:	61e080e7          	jalr	1566(ra) # 1192 <fprintf>
      continue;
     b7c:	bf79                	j	b1a <main+0x8a>
      runcmd(parsecmd(buf));
     b7e:	00001517          	auipc	a0,0x1
     b82:	4a250513          	addi	a0,a0,1186 # 2020 <buf.0>
     b86:	00000097          	auipc	ra,0x0
     b8a:	e82080e7          	jalr	-382(ra) # a08 <parsecmd>
     b8e:	fffff097          	auipc	ra,0xfffff
     b92:	524080e7          	jalr	1316(ra) # b2 <runcmd>
  exit(0,"");
     b96:	00000597          	auipc	a1,0x0
     b9a:	7ea58593          	addi	a1,a1,2026 # 1380 <malloc+0x102>
     b9e:	4501                	li	a0,0
     ba0:	00000097          	auipc	ra,0x0
     ba4:	298080e7          	jalr	664(ra) # e38 <exit>

0000000000000ba8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e406                	sd	ra,8(sp)
     bac:	e022                	sd	s0,0(sp)
     bae:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bb0:	00000097          	auipc	ra,0x0
     bb4:	ee0080e7          	jalr	-288(ra) # a90 <main>
  exit(0,"");
     bb8:	00000597          	auipc	a1,0x0
     bbc:	7c858593          	addi	a1,a1,1992 # 1380 <malloc+0x102>
     bc0:	4501                	li	a0,0
     bc2:	00000097          	auipc	ra,0x0
     bc6:	276080e7          	jalr	630(ra) # e38 <exit>

0000000000000bca <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bca:	1141                	addi	sp,sp,-16
     bcc:	e422                	sd	s0,8(sp)
     bce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bd0:	87aa                	mv	a5,a0
     bd2:	0585                	addi	a1,a1,1
     bd4:	0785                	addi	a5,a5,1
     bd6:	fff5c703          	lbu	a4,-1(a1)
     bda:	fee78fa3          	sb	a4,-1(a5)
     bde:	fb75                	bnez	a4,bd2 <strcpy+0x8>
    ;
  return os;
}
     be0:	6422                	ld	s0,8(sp)
     be2:	0141                	addi	sp,sp,16
     be4:	8082                	ret

0000000000000be6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     be6:	1141                	addi	sp,sp,-16
     be8:	e422                	sd	s0,8(sp)
     bea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bec:	00054783          	lbu	a5,0(a0)
     bf0:	cb91                	beqz	a5,c04 <strcmp+0x1e>
     bf2:	0005c703          	lbu	a4,0(a1)
     bf6:	00f71763          	bne	a4,a5,c04 <strcmp+0x1e>
    p++, q++;
     bfa:	0505                	addi	a0,a0,1
     bfc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bfe:	00054783          	lbu	a5,0(a0)
     c02:	fbe5                	bnez	a5,bf2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c04:	0005c503          	lbu	a0,0(a1)
}
     c08:	40a7853b          	subw	a0,a5,a0
     c0c:	6422                	ld	s0,8(sp)
     c0e:	0141                	addi	sp,sp,16
     c10:	8082                	ret

0000000000000c12 <strlen>:

uint
strlen(const char *s)
{
     c12:	1141                	addi	sp,sp,-16
     c14:	e422                	sd	s0,8(sp)
     c16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c18:	00054783          	lbu	a5,0(a0)
     c1c:	cf91                	beqz	a5,c38 <strlen+0x26>
     c1e:	0505                	addi	a0,a0,1
     c20:	87aa                	mv	a5,a0
     c22:	4685                	li	a3,1
     c24:	9e89                	subw	a3,a3,a0
     c26:	00f6853b          	addw	a0,a3,a5
     c2a:	0785                	addi	a5,a5,1
     c2c:	fff7c703          	lbu	a4,-1(a5)
     c30:	fb7d                	bnez	a4,c26 <strlen+0x14>
    ;
  return n;
}
     c32:	6422                	ld	s0,8(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret
  for(n = 0; s[n]; n++)
     c38:	4501                	li	a0,0
     c3a:	bfe5                	j	c32 <strlen+0x20>

0000000000000c3c <memset>:

void*
memset(void *dst, int c, uint n)
{
     c3c:	1141                	addi	sp,sp,-16
     c3e:	e422                	sd	s0,8(sp)
     c40:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c42:	ca19                	beqz	a2,c58 <memset+0x1c>
     c44:	87aa                	mv	a5,a0
     c46:	1602                	slli	a2,a2,0x20
     c48:	9201                	srli	a2,a2,0x20
     c4a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c4e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c52:	0785                	addi	a5,a5,1
     c54:	fee79de3          	bne	a5,a4,c4e <memset+0x12>
  }
  return dst;
}
     c58:	6422                	ld	s0,8(sp)
     c5a:	0141                	addi	sp,sp,16
     c5c:	8082                	ret

0000000000000c5e <strchr>:

char*
strchr(const char *s, char c)
{
     c5e:	1141                	addi	sp,sp,-16
     c60:	e422                	sd	s0,8(sp)
     c62:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c64:	00054783          	lbu	a5,0(a0)
     c68:	cb99                	beqz	a5,c7e <strchr+0x20>
    if(*s == c)
     c6a:	00f58763          	beq	a1,a5,c78 <strchr+0x1a>
  for(; *s; s++)
     c6e:	0505                	addi	a0,a0,1
     c70:	00054783          	lbu	a5,0(a0)
     c74:	fbfd                	bnez	a5,c6a <strchr+0xc>
      return (char*)s;
  return 0;
     c76:	4501                	li	a0,0
}
     c78:	6422                	ld	s0,8(sp)
     c7a:	0141                	addi	sp,sp,16
     c7c:	8082                	ret
  return 0;
     c7e:	4501                	li	a0,0
     c80:	bfe5                	j	c78 <strchr+0x1a>

0000000000000c82 <gets>:

char*
gets(char *buf, int max)
{
     c82:	711d                	addi	sp,sp,-96
     c84:	ec86                	sd	ra,88(sp)
     c86:	e8a2                	sd	s0,80(sp)
     c88:	e4a6                	sd	s1,72(sp)
     c8a:	e0ca                	sd	s2,64(sp)
     c8c:	fc4e                	sd	s3,56(sp)
     c8e:	f852                	sd	s4,48(sp)
     c90:	f456                	sd	s5,40(sp)
     c92:	f05a                	sd	s6,32(sp)
     c94:	ec5e                	sd	s7,24(sp)
     c96:	1080                	addi	s0,sp,96
     c98:	8baa                	mv	s7,a0
     c9a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c9c:	892a                	mv	s2,a0
     c9e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ca0:	4aa9                	li	s5,10
     ca2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ca4:	89a6                	mv	s3,s1
     ca6:	2485                	addiw	s1,s1,1
     ca8:	0344d863          	bge	s1,s4,cd8 <gets+0x56>
    cc = read(0, &c, 1);
     cac:	4605                	li	a2,1
     cae:	faf40593          	addi	a1,s0,-81
     cb2:	4501                	li	a0,0
     cb4:	00000097          	auipc	ra,0x0
     cb8:	19c080e7          	jalr	412(ra) # e50 <read>
    if(cc < 1)
     cbc:	00a05e63          	blez	a0,cd8 <gets+0x56>
    buf[i++] = c;
     cc0:	faf44783          	lbu	a5,-81(s0)
     cc4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cc8:	01578763          	beq	a5,s5,cd6 <gets+0x54>
     ccc:	0905                	addi	s2,s2,1
     cce:	fd679be3          	bne	a5,s6,ca4 <gets+0x22>
  for(i=0; i+1 < max; ){
     cd2:	89a6                	mv	s3,s1
     cd4:	a011                	j	cd8 <gets+0x56>
     cd6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cd8:	99de                	add	s3,s3,s7
     cda:	00098023          	sb	zero,0(s3)
  return buf;
}
     cde:	855e                	mv	a0,s7
     ce0:	60e6                	ld	ra,88(sp)
     ce2:	6446                	ld	s0,80(sp)
     ce4:	64a6                	ld	s1,72(sp)
     ce6:	6906                	ld	s2,64(sp)
     ce8:	79e2                	ld	s3,56(sp)
     cea:	7a42                	ld	s4,48(sp)
     cec:	7aa2                	ld	s5,40(sp)
     cee:	7b02                	ld	s6,32(sp)
     cf0:	6be2                	ld	s7,24(sp)
     cf2:	6125                	addi	sp,sp,96
     cf4:	8082                	ret

0000000000000cf6 <stat>:

int
stat(const char *n, struct stat *st)
{
     cf6:	1101                	addi	sp,sp,-32
     cf8:	ec06                	sd	ra,24(sp)
     cfa:	e822                	sd	s0,16(sp)
     cfc:	e426                	sd	s1,8(sp)
     cfe:	e04a                	sd	s2,0(sp)
     d00:	1000                	addi	s0,sp,32
     d02:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d04:	4581                	li	a1,0
     d06:	00000097          	auipc	ra,0x0
     d0a:	172080e7          	jalr	370(ra) # e78 <open>
  if(fd < 0)
     d0e:	02054563          	bltz	a0,d38 <stat+0x42>
     d12:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d14:	85ca                	mv	a1,s2
     d16:	00000097          	auipc	ra,0x0
     d1a:	17a080e7          	jalr	378(ra) # e90 <fstat>
     d1e:	892a                	mv	s2,a0
  close(fd);
     d20:	8526                	mv	a0,s1
     d22:	00000097          	auipc	ra,0x0
     d26:	13e080e7          	jalr	318(ra) # e60 <close>
  return r;
}
     d2a:	854a                	mv	a0,s2
     d2c:	60e2                	ld	ra,24(sp)
     d2e:	6442                	ld	s0,16(sp)
     d30:	64a2                	ld	s1,8(sp)
     d32:	6902                	ld	s2,0(sp)
     d34:	6105                	addi	sp,sp,32
     d36:	8082                	ret
    return -1;
     d38:	597d                	li	s2,-1
     d3a:	bfc5                	j	d2a <stat+0x34>

0000000000000d3c <atoi>:

int
atoi(const char *s)
{
     d3c:	1141                	addi	sp,sp,-16
     d3e:	e422                	sd	s0,8(sp)
     d40:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d42:	00054603          	lbu	a2,0(a0)
     d46:	fd06079b          	addiw	a5,a2,-48
     d4a:	0ff7f793          	andi	a5,a5,255
     d4e:	4725                	li	a4,9
     d50:	02f76963          	bltu	a4,a5,d82 <atoi+0x46>
     d54:	86aa                	mv	a3,a0
  n = 0;
     d56:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d58:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d5a:	0685                	addi	a3,a3,1
     d5c:	0025179b          	slliw	a5,a0,0x2
     d60:	9fa9                	addw	a5,a5,a0
     d62:	0017979b          	slliw	a5,a5,0x1
     d66:	9fb1                	addw	a5,a5,a2
     d68:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d6c:	0006c603          	lbu	a2,0(a3)
     d70:	fd06071b          	addiw	a4,a2,-48
     d74:	0ff77713          	andi	a4,a4,255
     d78:	fee5f1e3          	bgeu	a1,a4,d5a <atoi+0x1e>
  return n;
}
     d7c:	6422                	ld	s0,8(sp)
     d7e:	0141                	addi	sp,sp,16
     d80:	8082                	ret
  n = 0;
     d82:	4501                	li	a0,0
     d84:	bfe5                	j	d7c <atoi+0x40>

0000000000000d86 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d86:	1141                	addi	sp,sp,-16
     d88:	e422                	sd	s0,8(sp)
     d8a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d8c:	02b57463          	bgeu	a0,a1,db4 <memmove+0x2e>
    while(n-- > 0)
     d90:	00c05f63          	blez	a2,dae <memmove+0x28>
     d94:	1602                	slli	a2,a2,0x20
     d96:	9201                	srli	a2,a2,0x20
     d98:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d9c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d9e:	0585                	addi	a1,a1,1
     da0:	0705                	addi	a4,a4,1
     da2:	fff5c683          	lbu	a3,-1(a1)
     da6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     daa:	fee79ae3          	bne	a5,a4,d9e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     dae:	6422                	ld	s0,8(sp)
     db0:	0141                	addi	sp,sp,16
     db2:	8082                	ret
    dst += n;
     db4:	00c50733          	add	a4,a0,a2
    src += n;
     db8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dba:	fec05ae3          	blez	a2,dae <memmove+0x28>
     dbe:	fff6079b          	addiw	a5,a2,-1
     dc2:	1782                	slli	a5,a5,0x20
     dc4:	9381                	srli	a5,a5,0x20
     dc6:	fff7c793          	not	a5,a5
     dca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dcc:	15fd                	addi	a1,a1,-1
     dce:	177d                	addi	a4,a4,-1
     dd0:	0005c683          	lbu	a3,0(a1)
     dd4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     dd8:	fee79ae3          	bne	a5,a4,dcc <memmove+0x46>
     ddc:	bfc9                	j	dae <memmove+0x28>

0000000000000dde <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dde:	1141                	addi	sp,sp,-16
     de0:	e422                	sd	s0,8(sp)
     de2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     de4:	ca05                	beqz	a2,e14 <memcmp+0x36>
     de6:	fff6069b          	addiw	a3,a2,-1
     dea:	1682                	slli	a3,a3,0x20
     dec:	9281                	srli	a3,a3,0x20
     dee:	0685                	addi	a3,a3,1
     df0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     df2:	00054783          	lbu	a5,0(a0)
     df6:	0005c703          	lbu	a4,0(a1)
     dfa:	00e79863          	bne	a5,a4,e0a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dfe:	0505                	addi	a0,a0,1
    p2++;
     e00:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e02:	fed518e3          	bne	a0,a3,df2 <memcmp+0x14>
  }
  return 0;
     e06:	4501                	li	a0,0
     e08:	a019                	j	e0e <memcmp+0x30>
      return *p1 - *p2;
     e0a:	40e7853b          	subw	a0,a5,a4
}
     e0e:	6422                	ld	s0,8(sp)
     e10:	0141                	addi	sp,sp,16
     e12:	8082                	ret
  return 0;
     e14:	4501                	li	a0,0
     e16:	bfe5                	j	e0e <memcmp+0x30>

0000000000000e18 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e18:	1141                	addi	sp,sp,-16
     e1a:	e406                	sd	ra,8(sp)
     e1c:	e022                	sd	s0,0(sp)
     e1e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e20:	00000097          	auipc	ra,0x0
     e24:	f66080e7          	jalr	-154(ra) # d86 <memmove>
}
     e28:	60a2                	ld	ra,8(sp)
     e2a:	6402                	ld	s0,0(sp)
     e2c:	0141                	addi	sp,sp,16
     e2e:	8082                	ret

0000000000000e30 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e30:	4885                	li	a7,1
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e38:	4889                	li	a7,2
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e40:	488d                	li	a7,3
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e48:	4891                	li	a7,4
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <read>:
.global read
read:
 li a7, SYS_read
     e50:	4895                	li	a7,5
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <write>:
.global write
write:
 li a7, SYS_write
     e58:	48c1                	li	a7,16
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <close>:
.global close
close:
 li a7, SYS_close
     e60:	48d5                	li	a7,21
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e68:	4899                	li	a7,6
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e70:	489d                	li	a7,7
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <open>:
.global open
open:
 li a7, SYS_open
     e78:	48bd                	li	a7,15
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e80:	48c5                	li	a7,17
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e88:	48c9                	li	a7,18
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e90:	48a1                	li	a7,8
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <link>:
.global link
link:
 li a7, SYS_link
     e98:	48cd                	li	a7,19
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ea0:	48d1                	li	a7,20
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ea8:	48a5                	li	a7,9
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     eb0:	48a9                	li	a7,10
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     eb8:	48ad                	li	a7,11
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ec0:	48b1                	li	a7,12
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ec8:	48b5                	li	a7,13
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ed0:	48b9                	li	a7,14
 ecall
     ed2:	00000073          	ecall
 ret
     ed6:	8082                	ret

0000000000000ed8 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
     ed8:	48d9                	li	a7,22
 ecall
     eda:	00000073          	ecall
 ret
     ede:	8082                	ret

0000000000000ee0 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
     ee0:	48dd                	li	a7,23
 ecall
     ee2:	00000073          	ecall
 ret
     ee6:	8082                	ret

0000000000000ee8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ee8:	1101                	addi	sp,sp,-32
     eea:	ec06                	sd	ra,24(sp)
     eec:	e822                	sd	s0,16(sp)
     eee:	1000                	addi	s0,sp,32
     ef0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ef4:	4605                	li	a2,1
     ef6:	fef40593          	addi	a1,s0,-17
     efa:	00000097          	auipc	ra,0x0
     efe:	f5e080e7          	jalr	-162(ra) # e58 <write>
}
     f02:	60e2                	ld	ra,24(sp)
     f04:	6442                	ld	s0,16(sp)
     f06:	6105                	addi	sp,sp,32
     f08:	8082                	ret

0000000000000f0a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f0a:	7139                	addi	sp,sp,-64
     f0c:	fc06                	sd	ra,56(sp)
     f0e:	f822                	sd	s0,48(sp)
     f10:	f426                	sd	s1,40(sp)
     f12:	f04a                	sd	s2,32(sp)
     f14:	ec4e                	sd	s3,24(sp)
     f16:	0080                	addi	s0,sp,64
     f18:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f1a:	c299                	beqz	a3,f20 <printint+0x16>
     f1c:	0805c863          	bltz	a1,fac <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f20:	2581                	sext.w	a1,a1
  neg = 0;
     f22:	4881                	li	a7,0
     f24:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f28:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f2a:	2601                	sext.w	a2,a2
     f2c:	00000517          	auipc	a0,0x0
     f30:	59450513          	addi	a0,a0,1428 # 14c0 <digits>
     f34:	883a                	mv	a6,a4
     f36:	2705                	addiw	a4,a4,1
     f38:	02c5f7bb          	remuw	a5,a1,a2
     f3c:	1782                	slli	a5,a5,0x20
     f3e:	9381                	srli	a5,a5,0x20
     f40:	97aa                	add	a5,a5,a0
     f42:	0007c783          	lbu	a5,0(a5)
     f46:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f4a:	0005879b          	sext.w	a5,a1
     f4e:	02c5d5bb          	divuw	a1,a1,a2
     f52:	0685                	addi	a3,a3,1
     f54:	fec7f0e3          	bgeu	a5,a2,f34 <printint+0x2a>
  if(neg)
     f58:	00088b63          	beqz	a7,f6e <printint+0x64>
    buf[i++] = '-';
     f5c:	fd040793          	addi	a5,s0,-48
     f60:	973e                	add	a4,a4,a5
     f62:	02d00793          	li	a5,45
     f66:	fef70823          	sb	a5,-16(a4)
     f6a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f6e:	02e05863          	blez	a4,f9e <printint+0x94>
     f72:	fc040793          	addi	a5,s0,-64
     f76:	00e78933          	add	s2,a5,a4
     f7a:	fff78993          	addi	s3,a5,-1
     f7e:	99ba                	add	s3,s3,a4
     f80:	377d                	addiw	a4,a4,-1
     f82:	1702                	slli	a4,a4,0x20
     f84:	9301                	srli	a4,a4,0x20
     f86:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f8a:	fff94583          	lbu	a1,-1(s2)
     f8e:	8526                	mv	a0,s1
     f90:	00000097          	auipc	ra,0x0
     f94:	f58080e7          	jalr	-168(ra) # ee8 <putc>
  while(--i >= 0)
     f98:	197d                	addi	s2,s2,-1
     f9a:	ff3918e3          	bne	s2,s3,f8a <printint+0x80>
}
     f9e:	70e2                	ld	ra,56(sp)
     fa0:	7442                	ld	s0,48(sp)
     fa2:	74a2                	ld	s1,40(sp)
     fa4:	7902                	ld	s2,32(sp)
     fa6:	69e2                	ld	s3,24(sp)
     fa8:	6121                	addi	sp,sp,64
     faa:	8082                	ret
    x = -xx;
     fac:	40b005bb          	negw	a1,a1
    neg = 1;
     fb0:	4885                	li	a7,1
    x = -xx;
     fb2:	bf8d                	j	f24 <printint+0x1a>

0000000000000fb4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fb4:	7119                	addi	sp,sp,-128
     fb6:	fc86                	sd	ra,120(sp)
     fb8:	f8a2                	sd	s0,112(sp)
     fba:	f4a6                	sd	s1,104(sp)
     fbc:	f0ca                	sd	s2,96(sp)
     fbe:	ecce                	sd	s3,88(sp)
     fc0:	e8d2                	sd	s4,80(sp)
     fc2:	e4d6                	sd	s5,72(sp)
     fc4:	e0da                	sd	s6,64(sp)
     fc6:	fc5e                	sd	s7,56(sp)
     fc8:	f862                	sd	s8,48(sp)
     fca:	f466                	sd	s9,40(sp)
     fcc:	f06a                	sd	s10,32(sp)
     fce:	ec6e                	sd	s11,24(sp)
     fd0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fd2:	0005c903          	lbu	s2,0(a1)
     fd6:	18090f63          	beqz	s2,1174 <vprintf+0x1c0>
     fda:	8aaa                	mv	s5,a0
     fdc:	8b32                	mv	s6,a2
     fde:	00158493          	addi	s1,a1,1
  state = 0;
     fe2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fe4:	02500a13          	li	s4,37
      if(c == 'd'){
     fe8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     fec:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     ff0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     ff4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ff8:	00000b97          	auipc	s7,0x0
     ffc:	4c8b8b93          	addi	s7,s7,1224 # 14c0 <digits>
    1000:	a839                	j	101e <vprintf+0x6a>
        putc(fd, c);
    1002:	85ca                	mv	a1,s2
    1004:	8556                	mv	a0,s5
    1006:	00000097          	auipc	ra,0x0
    100a:	ee2080e7          	jalr	-286(ra) # ee8 <putc>
    100e:	a019                	j	1014 <vprintf+0x60>
    } else if(state == '%'){
    1010:	01498f63          	beq	s3,s4,102e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1014:	0485                	addi	s1,s1,1
    1016:	fff4c903          	lbu	s2,-1(s1)
    101a:	14090d63          	beqz	s2,1174 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    101e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1022:	fe0997e3          	bnez	s3,1010 <vprintf+0x5c>
      if(c == '%'){
    1026:	fd479ee3          	bne	a5,s4,1002 <vprintf+0x4e>
        state = '%';
    102a:	89be                	mv	s3,a5
    102c:	b7e5                	j	1014 <vprintf+0x60>
      if(c == 'd'){
    102e:	05878063          	beq	a5,s8,106e <vprintf+0xba>
      } else if(c == 'l') {
    1032:	05978c63          	beq	a5,s9,108a <vprintf+0xd6>
      } else if(c == 'x') {
    1036:	07a78863          	beq	a5,s10,10a6 <vprintf+0xf2>
      } else if(c == 'p') {
    103a:	09b78463          	beq	a5,s11,10c2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    103e:	07300713          	li	a4,115
    1042:	0ce78663          	beq	a5,a4,110e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1046:	06300713          	li	a4,99
    104a:	0ee78e63          	beq	a5,a4,1146 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    104e:	11478863          	beq	a5,s4,115e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1052:	85d2                	mv	a1,s4
    1054:	8556                	mv	a0,s5
    1056:	00000097          	auipc	ra,0x0
    105a:	e92080e7          	jalr	-366(ra) # ee8 <putc>
        putc(fd, c);
    105e:	85ca                	mv	a1,s2
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e86080e7          	jalr	-378(ra) # ee8 <putc>
      }
      state = 0;
    106a:	4981                	li	s3,0
    106c:	b765                	j	1014 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    106e:	008b0913          	addi	s2,s6,8
    1072:	4685                	li	a3,1
    1074:	4629                	li	a2,10
    1076:	000b2583          	lw	a1,0(s6)
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	e8e080e7          	jalr	-370(ra) # f0a <printint>
    1084:	8b4a                	mv	s6,s2
      state = 0;
    1086:	4981                	li	s3,0
    1088:	b771                	j	1014 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    108a:	008b0913          	addi	s2,s6,8
    108e:	4681                	li	a3,0
    1090:	4629                	li	a2,10
    1092:	000b2583          	lw	a1,0(s6)
    1096:	8556                	mv	a0,s5
    1098:	00000097          	auipc	ra,0x0
    109c:	e72080e7          	jalr	-398(ra) # f0a <printint>
    10a0:	8b4a                	mv	s6,s2
      state = 0;
    10a2:	4981                	li	s3,0
    10a4:	bf85                	j	1014 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10a6:	008b0913          	addi	s2,s6,8
    10aa:	4681                	li	a3,0
    10ac:	4641                	li	a2,16
    10ae:	000b2583          	lw	a1,0(s6)
    10b2:	8556                	mv	a0,s5
    10b4:	00000097          	auipc	ra,0x0
    10b8:	e56080e7          	jalr	-426(ra) # f0a <printint>
    10bc:	8b4a                	mv	s6,s2
      state = 0;
    10be:	4981                	li	s3,0
    10c0:	bf91                	j	1014 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    10c2:	008b0793          	addi	a5,s6,8
    10c6:	f8f43423          	sd	a5,-120(s0)
    10ca:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    10ce:	03000593          	li	a1,48
    10d2:	8556                	mv	a0,s5
    10d4:	00000097          	auipc	ra,0x0
    10d8:	e14080e7          	jalr	-492(ra) # ee8 <putc>
  putc(fd, 'x');
    10dc:	85ea                	mv	a1,s10
    10de:	8556                	mv	a0,s5
    10e0:	00000097          	auipc	ra,0x0
    10e4:	e08080e7          	jalr	-504(ra) # ee8 <putc>
    10e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10ea:	03c9d793          	srli	a5,s3,0x3c
    10ee:	97de                	add	a5,a5,s7
    10f0:	0007c583          	lbu	a1,0(a5)
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	df2080e7          	jalr	-526(ra) # ee8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10fe:	0992                	slli	s3,s3,0x4
    1100:	397d                	addiw	s2,s2,-1
    1102:	fe0914e3          	bnez	s2,10ea <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1106:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    110a:	4981                	li	s3,0
    110c:	b721                	j	1014 <vprintf+0x60>
        s = va_arg(ap, char*);
    110e:	008b0993          	addi	s3,s6,8
    1112:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1116:	02090163          	beqz	s2,1138 <vprintf+0x184>
        while(*s != 0){
    111a:	00094583          	lbu	a1,0(s2)
    111e:	c9a1                	beqz	a1,116e <vprintf+0x1ba>
          putc(fd, *s);
    1120:	8556                	mv	a0,s5
    1122:	00000097          	auipc	ra,0x0
    1126:	dc6080e7          	jalr	-570(ra) # ee8 <putc>
          s++;
    112a:	0905                	addi	s2,s2,1
        while(*s != 0){
    112c:	00094583          	lbu	a1,0(s2)
    1130:	f9e5                	bnez	a1,1120 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1132:	8b4e                	mv	s6,s3
      state = 0;
    1134:	4981                	li	s3,0
    1136:	bdf9                	j	1014 <vprintf+0x60>
          s = "(null)";
    1138:	00000917          	auipc	s2,0x0
    113c:	38090913          	addi	s2,s2,896 # 14b8 <malloc+0x23a>
        while(*s != 0){
    1140:	02800593          	li	a1,40
    1144:	bff1                	j	1120 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1146:	008b0913          	addi	s2,s6,8
    114a:	000b4583          	lbu	a1,0(s6)
    114e:	8556                	mv	a0,s5
    1150:	00000097          	auipc	ra,0x0
    1154:	d98080e7          	jalr	-616(ra) # ee8 <putc>
    1158:	8b4a                	mv	s6,s2
      state = 0;
    115a:	4981                	li	s3,0
    115c:	bd65                	j	1014 <vprintf+0x60>
        putc(fd, c);
    115e:	85d2                	mv	a1,s4
    1160:	8556                	mv	a0,s5
    1162:	00000097          	auipc	ra,0x0
    1166:	d86080e7          	jalr	-634(ra) # ee8 <putc>
      state = 0;
    116a:	4981                	li	s3,0
    116c:	b565                	j	1014 <vprintf+0x60>
        s = va_arg(ap, char*);
    116e:	8b4e                	mv	s6,s3
      state = 0;
    1170:	4981                	li	s3,0
    1172:	b54d                	j	1014 <vprintf+0x60>
    }
  }
}
    1174:	70e6                	ld	ra,120(sp)
    1176:	7446                	ld	s0,112(sp)
    1178:	74a6                	ld	s1,104(sp)
    117a:	7906                	ld	s2,96(sp)
    117c:	69e6                	ld	s3,88(sp)
    117e:	6a46                	ld	s4,80(sp)
    1180:	6aa6                	ld	s5,72(sp)
    1182:	6b06                	ld	s6,64(sp)
    1184:	7be2                	ld	s7,56(sp)
    1186:	7c42                	ld	s8,48(sp)
    1188:	7ca2                	ld	s9,40(sp)
    118a:	7d02                	ld	s10,32(sp)
    118c:	6de2                	ld	s11,24(sp)
    118e:	6109                	addi	sp,sp,128
    1190:	8082                	ret

0000000000001192 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1192:	715d                	addi	sp,sp,-80
    1194:	ec06                	sd	ra,24(sp)
    1196:	e822                	sd	s0,16(sp)
    1198:	1000                	addi	s0,sp,32
    119a:	e010                	sd	a2,0(s0)
    119c:	e414                	sd	a3,8(s0)
    119e:	e818                	sd	a4,16(s0)
    11a0:	ec1c                	sd	a5,24(s0)
    11a2:	03043023          	sd	a6,32(s0)
    11a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11ae:	8622                	mv	a2,s0
    11b0:	00000097          	auipc	ra,0x0
    11b4:	e04080e7          	jalr	-508(ra) # fb4 <vprintf>
}
    11b8:	60e2                	ld	ra,24(sp)
    11ba:	6442                	ld	s0,16(sp)
    11bc:	6161                	addi	sp,sp,80
    11be:	8082                	ret

00000000000011c0 <printf>:

void
printf(const char *fmt, ...)
{
    11c0:	711d                	addi	sp,sp,-96
    11c2:	ec06                	sd	ra,24(sp)
    11c4:	e822                	sd	s0,16(sp)
    11c6:	1000                	addi	s0,sp,32
    11c8:	e40c                	sd	a1,8(s0)
    11ca:	e810                	sd	a2,16(s0)
    11cc:	ec14                	sd	a3,24(s0)
    11ce:	f018                	sd	a4,32(s0)
    11d0:	f41c                	sd	a5,40(s0)
    11d2:	03043823          	sd	a6,48(s0)
    11d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11da:	00840613          	addi	a2,s0,8
    11de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11e2:	85aa                	mv	a1,a0
    11e4:	4505                	li	a0,1
    11e6:	00000097          	auipc	ra,0x0
    11ea:	dce080e7          	jalr	-562(ra) # fb4 <vprintf>
}
    11ee:	60e2                	ld	ra,24(sp)
    11f0:	6442                	ld	s0,16(sp)
    11f2:	6125                	addi	sp,sp,96
    11f4:	8082                	ret

00000000000011f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11f6:	1141                	addi	sp,sp,-16
    11f8:	e422                	sd	s0,8(sp)
    11fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1200:	00001797          	auipc	a5,0x1
    1204:	e107b783          	ld	a5,-496(a5) # 2010 <freep>
    1208:	a805                	j	1238 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    120a:	4618                	lw	a4,8(a2)
    120c:	9db9                	addw	a1,a1,a4
    120e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1212:	6398                	ld	a4,0(a5)
    1214:	6318                	ld	a4,0(a4)
    1216:	fee53823          	sd	a4,-16(a0)
    121a:	a091                	j	125e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    121c:	ff852703          	lw	a4,-8(a0)
    1220:	9e39                	addw	a2,a2,a4
    1222:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1224:	ff053703          	ld	a4,-16(a0)
    1228:	e398                	sd	a4,0(a5)
    122a:	a099                	j	1270 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    122c:	6398                	ld	a4,0(a5)
    122e:	00e7e463          	bltu	a5,a4,1236 <free+0x40>
    1232:	00e6ea63          	bltu	a3,a4,1246 <free+0x50>
{
    1236:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1238:	fed7fae3          	bgeu	a5,a3,122c <free+0x36>
    123c:	6398                	ld	a4,0(a5)
    123e:	00e6e463          	bltu	a3,a4,1246 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1242:	fee7eae3          	bltu	a5,a4,1236 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1246:	ff852583          	lw	a1,-8(a0)
    124a:	6390                	ld	a2,0(a5)
    124c:	02059713          	slli	a4,a1,0x20
    1250:	9301                	srli	a4,a4,0x20
    1252:	0712                	slli	a4,a4,0x4
    1254:	9736                	add	a4,a4,a3
    1256:	fae60ae3          	beq	a2,a4,120a <free+0x14>
    bp->s.ptr = p->s.ptr;
    125a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    125e:	4790                	lw	a2,8(a5)
    1260:	02061713          	slli	a4,a2,0x20
    1264:	9301                	srli	a4,a4,0x20
    1266:	0712                	slli	a4,a4,0x4
    1268:	973e                	add	a4,a4,a5
    126a:	fae689e3          	beq	a3,a4,121c <free+0x26>
  } else
    p->s.ptr = bp;
    126e:	e394                	sd	a3,0(a5)
  freep = p;
    1270:	00001717          	auipc	a4,0x1
    1274:	daf73023          	sd	a5,-608(a4) # 2010 <freep>
}
    1278:	6422                	ld	s0,8(sp)
    127a:	0141                	addi	sp,sp,16
    127c:	8082                	ret

000000000000127e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    127e:	7139                	addi	sp,sp,-64
    1280:	fc06                	sd	ra,56(sp)
    1282:	f822                	sd	s0,48(sp)
    1284:	f426                	sd	s1,40(sp)
    1286:	f04a                	sd	s2,32(sp)
    1288:	ec4e                	sd	s3,24(sp)
    128a:	e852                	sd	s4,16(sp)
    128c:	e456                	sd	s5,8(sp)
    128e:	e05a                	sd	s6,0(sp)
    1290:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1292:	02051493          	slli	s1,a0,0x20
    1296:	9081                	srli	s1,s1,0x20
    1298:	04bd                	addi	s1,s1,15
    129a:	8091                	srli	s1,s1,0x4
    129c:	0014899b          	addiw	s3,s1,1
    12a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12a2:	00001517          	auipc	a0,0x1
    12a6:	d6e53503          	ld	a0,-658(a0) # 2010 <freep>
    12aa:	c515                	beqz	a0,12d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ae:	4798                	lw	a4,8(a5)
    12b0:	02977f63          	bgeu	a4,s1,12ee <malloc+0x70>
    12b4:	8a4e                	mv	s4,s3
    12b6:	0009871b          	sext.w	a4,s3
    12ba:	6685                	lui	a3,0x1
    12bc:	00d77363          	bgeu	a4,a3,12c2 <malloc+0x44>
    12c0:	6a05                	lui	s4,0x1
    12c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12ca:	00001917          	auipc	s2,0x1
    12ce:	d4690913          	addi	s2,s2,-698 # 2010 <freep>
  if(p == (char*)-1)
    12d2:	5afd                	li	s5,-1
    12d4:	a88d                	j	1346 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    12d6:	00001797          	auipc	a5,0x1
    12da:	db278793          	addi	a5,a5,-590 # 2088 <base>
    12de:	00001717          	auipc	a4,0x1
    12e2:	d2f73923          	sd	a5,-718(a4) # 2010 <freep>
    12e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12ec:	b7e1                	j	12b4 <malloc+0x36>
      if(p->s.size == nunits)
    12ee:	02e48b63          	beq	s1,a4,1324 <malloc+0xa6>
        p->s.size -= nunits;
    12f2:	4137073b          	subw	a4,a4,s3
    12f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12f8:	1702                	slli	a4,a4,0x20
    12fa:	9301                	srli	a4,a4,0x20
    12fc:	0712                	slli	a4,a4,0x4
    12fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1300:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1304:	00001717          	auipc	a4,0x1
    1308:	d0a73623          	sd	a0,-756(a4) # 2010 <freep>
      return (void*)(p + 1);
    130c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1310:	70e2                	ld	ra,56(sp)
    1312:	7442                	ld	s0,48(sp)
    1314:	74a2                	ld	s1,40(sp)
    1316:	7902                	ld	s2,32(sp)
    1318:	69e2                	ld	s3,24(sp)
    131a:	6a42                	ld	s4,16(sp)
    131c:	6aa2                	ld	s5,8(sp)
    131e:	6b02                	ld	s6,0(sp)
    1320:	6121                	addi	sp,sp,64
    1322:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1324:	6398                	ld	a4,0(a5)
    1326:	e118                	sd	a4,0(a0)
    1328:	bff1                	j	1304 <malloc+0x86>
  hp->s.size = nu;
    132a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    132e:	0541                	addi	a0,a0,16
    1330:	00000097          	auipc	ra,0x0
    1334:	ec6080e7          	jalr	-314(ra) # 11f6 <free>
  return freep;
    1338:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    133c:	d971                	beqz	a0,1310 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    133e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1340:	4798                	lw	a4,8(a5)
    1342:	fa9776e3          	bgeu	a4,s1,12ee <malloc+0x70>
    if(p == freep)
    1346:	00093703          	ld	a4,0(s2)
    134a:	853e                	mv	a0,a5
    134c:	fef719e3          	bne	a4,a5,133e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1350:	8552                	mv	a0,s4
    1352:	00000097          	auipc	ra,0x0
    1356:	b6e080e7          	jalr	-1170(ra) # ec0 <sbrk>
  if(p == (char*)-1)
    135a:	fd5518e3          	bne	a0,s5,132a <malloc+0xac>
        return 0;
    135e:	4501                	li	a0,0
    1360:	bf45                	j	1310 <malloc+0x92>
