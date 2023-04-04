
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8b013103          	ld	sp,-1872(sp) # 800088b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	8be70713          	addi	a4,a4,-1858 # 80008910 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	bdc78793          	addi	a5,a5,-1060 # 80005c40 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc27f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dca78793          	addi	a5,a5,-566 # 80000e78 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	3de080e7          	jalr	990(ra) # 8000250a <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8c650513          	addi	a0,a0,-1850 # 80010a50 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8b648493          	addi	s1,s1,-1866 # 80010a50 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	94690913          	addi	s2,s2,-1722 # 80010ae8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7ec080e7          	jalr	2028(ra) # 800019ac <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	14a080e7          	jalr	330(ra) # 80002312 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	e7e080e7          	jalr	-386(ra) # 80002054 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	2a2080e7          	jalr	674(ra) # 800024b4 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	82a50513          	addi	a0,a0,-2006 # 80010a50 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	81450513          	addi	a0,a0,-2028 # 80010a50 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	86f72b23          	sw	a5,-1930(a4) # 80010ae8 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	78450513          	addi	a0,a0,1924 # 80010a50 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	26e080e7          	jalr	622(ra) # 80002560 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	75650513          	addi	a0,a0,1878 # 80010a50 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	73270713          	addi	a4,a4,1842 # 80010a50 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	70878793          	addi	a5,a5,1800 # 80010a50 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7727a783          	lw	a5,1906(a5) # 80010ae8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6c670713          	addi	a4,a4,1734 # 80010a50 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6b648493          	addi	s1,s1,1718 # 80010a50 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	67a70713          	addi	a4,a4,1658 # 80010a50 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	70f72223          	sw	a5,1796(a4) # 80010af0 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	63e78793          	addi	a5,a5,1598 # 80010a50 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6ac7ab23          	sw	a2,1718(a5) # 80010aec <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6aa50513          	addi	a0,a0,1706 # 80010ae8 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	c72080e7          	jalr	-910(ra) # 800020b8 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	5f050513          	addi	a0,a0,1520 # 80010a50 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00021797          	auipc	a5,0x21
    8000047c:	f7078793          	addi	a5,a5,-144 # 800213e8 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	5c07a323          	sw	zero,1478(a5) # 80010b10 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	b5c50513          	addi	a0,a0,-1188 # 800080c8 <digits+0x88>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	34f72923          	sw	a5,850(a4) # 800088d0 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	556dad83          	lw	s11,1366(s11) # 80010b10 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80008040 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	50050513          	addi	a0,a0,1280 # 80010af8 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	5d6080e7          	jalr	1494(ra) # 80000bd6 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80008028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	91c48493          	addi	s1,s1,-1764 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	3a250513          	addi	a0,a0,930 # 80010af8 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	52c080e7          	jalr	1324(ra) # 80000c8a <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	38648493          	addi	s1,s1,902 # 80010af8 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80008038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	3c2080e7          	jalr	962(ra) # 80000b46 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80008058 <digits+0x18>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	34650513          	addi	a0,a0,838 # 80010b18 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	36c080e7          	jalr	876(ra) # 80000b46 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	394080e7          	jalr	916(ra) # 80000b8a <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	0d27a783          	lw	a5,210(a5) # 800088d0 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	andi	a0,s1,255
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	406080e7          	jalr	1030(ra) # 80000c2a <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	0a27b783          	ld	a5,162(a5) # 800088d8 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0a273703          	ld	a4,162(a4) # 800088e0 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	2b8a0a13          	addi	s4,s4,696 # 80010b18 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	07048493          	addi	s1,s1,112 # 800088d8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	07098993          	addi	s3,s3,112 # 800088e0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	826080e7          	jalr	-2010(ra) # 800020b8 <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	24a50513          	addi	a0,a0,586 # 80010b18 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	ff27a783          	lw	a5,-14(a5) # 800088d0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	ff873703          	ld	a4,-8(a4) # 800088e0 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	fe87b783          	ld	a5,-24(a5) # 800088d8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	21c98993          	addi	s3,s3,540 # 80010b18 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	fd448493          	addi	s1,s1,-44 # 800088d8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	fd490913          	addi	s2,s2,-44 # 800088e0 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00001097          	auipc	ra,0x1
    80000920:	738080e7          	jalr	1848(ra) # 80002054 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	1e648493          	addi	s1,s1,486 # 80010b18 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	f8e7bd23          	sd	a4,-102(a5) # 800088e0 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	332080e7          	jalr	818(ra) # 80000c8a <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	15c48493          	addi	s1,s1,348 # 80010b18 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	210080e7          	jalr	528(ra) # 80000bd6 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	2b2080e7          	jalr	690(ra) # 80000c8a <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	ebb9                	bnez	a5,80000a50 <kfree+0x66>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00022797          	auipc	a5,0x22
    80000a02:	b8278793          	addi	a5,a5,-1150 # 80022580 <end>
    80000a06:	04f56563          	bltu	a0,a5,80000a50 <kfree+0x66>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	04f57163          	bgeu	a0,a5,80000a50 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	2bc080e7          	jalr	700(ra) # 80000cd2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a1e:	00010917          	auipc	s2,0x10
    80000a22:	13290913          	addi	s2,s2,306 # 80010b50 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
  r->next = kmem.freelist;
    80000a30:	01893783          	ld	a5,24(s2)
    80000a34:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a36:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a3a:	854a                	mv	a0,s2
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	24e080e7          	jalr	590(ra) # 80000c8a <release>
}
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6902                	ld	s2,0(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret
    panic("kfree");
    80000a50:	00007517          	auipc	a0,0x7
    80000a54:	61050513          	addi	a0,a0,1552 # 80008060 <digits+0x20>
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	ae6080e7          	jalr	-1306(ra) # 8000053e <panic>

0000000080000a60 <freerange>:
{
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	e84a                	sd	s2,16(sp)
    80000a6a:	e44e                	sd	s3,8(sp)
    80000a6c:	e052                	sd	s4,0(sp)
    80000a6e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a70:	6785                	lui	a5,0x1
    80000a72:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a76:	94aa                	add	s1,s1,a0
    80000a78:	757d                	lui	a0,0xfffff
    80000a7a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3a>
    80000a82:	892e                	mv	s2,a1
    kfree(p);
    80000a84:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a86:	6985                	lui	s3,0x1
    kfree(p);
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5e080e7          	jalr	-162(ra) # 800009ea <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x28>
}
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
{
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	09650513          	addi	a0,a0,150 # 80010b50 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00022517          	auipc	a0,0x22
    80000ad2:	ab250513          	addi	a0,a0,-1358 # 80022580 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f8a080e7          	jalr	-118(ra) # 80000a60 <freerange>
}
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	06048493          	addi	s1,s1,96 # 80010b50 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
  r = kmem.freelist;
    80000b02:	6c84                	ld	s1,24(s1)
  if(r)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	04850513          	addi	a0,a0,72 # 80010b50 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
  return (void*)r;
}
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
  release(&kmem.lock);
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	01c50513          	addi	a0,a0,28 # 80010b50 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
  if(r)
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b4c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b4e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b52:	00053823          	sd	zero,16(a0)
}
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
  return r;
}
    80000b62:	8082                	ret
{
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e20080e7          	jalr	-480(ra) # 80001990 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
}
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b9c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b9e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	dee080e7          	jalr	-530(ra) # 80001990 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	de2080e7          	jalr	-542(ra) # 80001990 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
}
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    mycpu()->intena = old;
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	dca080e7          	jalr	-566(ra) # 80001990 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
{
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
  if(holding(lk))
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf4:	4705                	li	a4,1
  if(holding(lk))
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
  __sync_synchronize();
    80000c02:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d8a080e7          	jalr	-630(ra) # 80001990 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    panic("acquire");
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91c080e7          	jalr	-1764(ra) # 8000053e <panic>

0000000080000c2a <pop_off>:

void
pop_off(void)
{
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d5e080e7          	jalr	-674(ra) # 80001990 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c3e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c5e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    panic("pop_off - interruptible");
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8cc080e7          	jalr	-1844(ra) # 8000053e <panic>
    panic("pop_off");
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8bc080e7          	jalr	-1860(ra) # 8000053e <panic>

0000000080000c8a <release>:
{
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
  lk->cpu = 0;
    80000ca0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
}
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    panic("release");
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	874080e7          	jalr	-1932(ra) # 8000053e <panic>

0000000080000cd2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
  }
  return dst;
}
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
  }

  return 0;
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
      return *s1 - *s2;
    80000d20:	40e7853b          	subw	a0,a5,a4
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  return 0;
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
{
    80000d42:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>

  return dst;
}
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
  if(s < d && s + n > d){
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    d += n;
    80000d68:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
  if(n == 0)
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    *s++ = 0;
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e08:	fff6c793          	not	a5,a3
    80000e0c:	9fb9                	addw	a5,a5,a4
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
  return os;
}
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e44:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:

int
strlen(const char *s)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e54:	00054783          	lbu	a5,0(a0)
    80000e58:	cf91                	beqz	a5,80000e74 <strlen+0x26>
    80000e5a:	0505                	addi	a0,a0,1
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	4685                	li	a3,1
    80000e60:	9e89                	subw	a3,a3,a0
    80000e62:	00f6853b          	addw	a0,a3,a5
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff7c703          	lbu	a4,-1(a5)
    80000e6c:	fb7d                	bnez	a4,80000e62 <strlen+0x14>
    ;
  return n;
}
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b00080e7          	jalr	-1280(ra) # 80001980 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	a6070713          	addi	a4,a4,-1440 # 800088e8 <started>
  if(cpuid() == 0){
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    while(started == 0)
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
      ;
    __sync_synchronize();
    80000e98:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	ae4080e7          	jalr	-1308(ra) # 80001980 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	21250513          	addi	a0,a0,530 # 800080b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6da080e7          	jalr	1754(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ebe:	00001097          	auipc	ra,0x1
    80000ec2:	7e2080e7          	jalr	2018(ra) # 800026a0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	dba080e7          	jalr	-582(ra) # 80005c80 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	fd4080e7          	jalr	-44(ra) # 80001ea2 <scheduler>
    consoleinit();
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    printfinit();
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88a080e7          	jalr	-1910(ra) # 80000768 <printfinit>
    printf("\n");
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	1e250513          	addi	a0,a0,482 # 800080c8 <digits+0x88>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69a080e7          	jalr	1690(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	1aa50513          	addi	a0,a0,426 # 800080a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68a080e7          	jalr	1674(ra) # 80000588 <printf>
    printf("\n");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	1c250513          	addi	a0,a0,450 # 800080c8 <digits+0x88>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67a080e7          	jalr	1658(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    kvminit();       // create kernel page table
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    kvminithart();   // turn on paging
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    procinit();      // process table
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    trapinit();      // trap vectors
    80000f36:	00001097          	auipc	ra,0x1
    80000f3a:	742080e7          	jalr	1858(ra) # 80002678 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00001097          	auipc	ra,0x1
    80000f42:	762080e7          	jalr	1890(ra) # 800026a0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	d24080e7          	jalr	-732(ra) # 80005c6a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	d32080e7          	jalr	-718(ra) # 80005c80 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	ed8080e7          	jalr	-296(ra) # 80002e2e <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	57c080e7          	jalr	1404(ra) # 800034da <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	51a080e7          	jalr	1306(ra) # 80004480 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	e1a080e7          	jalr	-486(ra) # 80005d88 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d0e080e7          	jalr	-754(ra) # 80001c84 <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	96f72223          	sw	a5,-1692(a4) # 800088e8 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f94:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9587b783          	ld	a5,-1704(a5) # 800088f0 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fa8:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fac:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fb6:	7139                	addi	sp,sp,-64
    80000fb8:	fc06                	sd	ra,56(sp)
    80000fba:	f822                	sd	s0,48(sp)
    80000fbc:	f426                	sd	s1,40(sp)
    80000fbe:	f04a                	sd	s2,32(sp)
    80000fc0:	ec4e                	sd	s3,24(sp)
    80000fc2:	e852                	sd	s4,16(sp)
    80000fc4:	e456                	sd	s5,8(sp)
    80000fc6:	e05a                	sd	s6,0(sp)
    80000fc8:	0080                	addi	s0,sp,64
    80000fca:	84aa                	mv	s1,a0
    80000fcc:	89ae                	mv	s3,a1
    80000fce:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fd6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    panic("walk");
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0f450513          	addi	a0,a0,244 # 800080d0 <digits+0x90>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55a080e7          	jalr	1370(ra) # 8000053e <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001016:	3a5d                	addiw	s4,s4,-9
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
}
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
        return 0;
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    return 0;
    80001064:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001066:	8082                	ret
{
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
  if(pte == 0)
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000107c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    return 0;
    80001084:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
  pa = PTE2PA(*pte);
    80001092:	00a7d513          	srli	a0,a5,0xa
    80001096:	0532                	slli	a0,a0,0xc
  return pa;
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000109e:	715d                	addi	sp,sp,-80
    800010a0:	e486                	sd	ra,72(sp)
    800010a2:	e0a2                	sd	s0,64(sp)
    800010a4:	fc26                	sd	s1,56(sp)
    800010a6:	f84a                	sd	s2,48(sp)
    800010a8:	f44e                	sd	s3,40(sp)
    800010aa:	f052                	sd	s4,32(sp)
    800010ac:	ec56                	sd	s5,24(sp)
    800010ae:	e85a                	sd	s6,16(sp)
    800010b0:	e45e                	sd	s7,8(sp)
    800010b2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010ba:	77fd                	lui	a5,0xfffff
    800010bc:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800010c0:	15fd                	addi	a1,a1,-1
    800010c2:	00c589b3          	add	s3,a1,a2
    800010c6:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800010ca:	8952                	mv	s2,s4
    800010cc:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    if(*pte & PTE_V)
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    if(a == last)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    a += PGSIZE;
    800010fe:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    panic("mappages: size");
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fd650513          	addi	a0,a0,-42 # 800080d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	434080e7          	jalr	1076(ra) # 8000053e <panic>
      panic("mappages: remap");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fd650513          	addi	a0,a0,-42 # 800080e8 <digits+0xa8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	424080e7          	jalr	1060(ra) # 8000053e <panic>
      return -1;
    80001122:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001124:	60a6                	ld	ra,72(sp)
    80001126:	6406                	ld	s0,64(sp)
    80001128:	74e2                	ld	s1,56(sp)
    8000112a:	7942                	ld	s2,48(sp)
    8000112c:	79a2                	ld	s3,40(sp)
    8000112e:	7a02                	ld	s4,32(sp)
    80001130:	6ae2                	ld	s5,24(sp)
    80001132:	6b42                	ld	s6,16(sp)
    80001134:	6ba2                	ld	s7,8(sp)
    80001136:	6161                	addi	sp,sp,80
    80001138:	8082                	ret
  return 0;
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
{
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
}
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    panic("kvmmap");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f9a50513          	addi	a0,a0,-102 # 800080f8 <digits+0xb8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3d8080e7          	jalr	984(ra) # 8000053e <panic>

000000008000116e <kvmmake>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011d4:	00007917          	auipc	s2,0x7
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80008000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80007697          	auipc	a3,0x80007
    800011e2:	e2268693          	addi	a3,a3,-478 # 8000 <_entry-0x7fff8000>
    800011e6:	4605                	li	a2,1
    800011e8:	067e                	slli	a2,a2,0x1f
    800011ea:	85b2                	mv	a1,a2
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f50080e7          	jalr	-176(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000120e:	4729                	li	a4,10
    80001210:	6685                	lui	a3,0x1
    80001212:	00006617          	auipc	a2,0x6
    80001216:	dee60613          	addi	a2,a2,-530 # 80007000 <_trampoline>
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f1a080e7          	jalr	-230(ra) # 8000113e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
}
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
{
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	68a7be23          	sd	a0,1692(a5) # 800088f0 <kernel_pagetable>
}
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001264:	715d                	addi	sp,sp,-80
    80001266:	e486                	sd	ra,72(sp)
    80001268:	e0a2                	sd	s0,64(sp)
    8000126a:	fc26                	sd	s1,56(sp)
    8000126c:	f84a                	sd	s2,48(sp)
    8000126e:	f44e                	sd	s3,40(sp)
    80001270:	f052                	sd	s4,32(sp)
    80001272:	ec56                	sd	s5,24(sp)
    80001274:	e85a                	sd	s6,16(sp)
    80001276:	e45e                	sd	s7,8(sp)
    80001278:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000128c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6161                	addi	sp,sp,80
    800012a8:	8082                	ret
    panic("uvmunmap: not aligned");
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e5650513          	addi	a0,a0,-426 # 80008100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28c080e7          	jalr	652(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e5e50513          	addi	a0,a0,-418 # 80008118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27c080e7          	jalr	636(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80008128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26c080e7          	jalr	620(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e6650513          	addi	a0,a0,-410 # 80008140 <digits+0x100>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25c080e7          	jalr	604(ra) # 8000053e <panic>
    *pte = 0;
    800012ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    if(do_free){
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000131a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6cc080e7          	jalr	1740(ra) # 800009ea <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
  return pagetable;
}
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
  memmove(mem, src, sz);
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
}
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    panic("uvmfirst: more than a page");
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	da050513          	addi	a0,a0,-608 # 80008158 <digits+0x118>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	17e080e7          	jalr	382(ra) # 8000053e <panic>

00000000800013c8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013d2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	767d                	lui	a2,0xfffff
    800013e4:	8f71                	and	a4,a4,a2
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff1                	and	a5,a5,a2
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
  if(newsz < oldsz)
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
{
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
    80001428:	8aaa                	mv	s5,a0
    8000142a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000142c:	6985                	lui	s3,0x1
    8000142e:	19fd                	addi	s3,s3,-1
    80001430:	95ce                	add	a1,a1,s3
    80001432:	79fd                	lui	s3,0xfffff
    80001434:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000143e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
  return newsz;
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
      return 0;
    80001488:	4501                	li	a0,0
}
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6b02                	ld	s6,0(sp)
    8000149a:	6121                	addi	sp,sp,64
    8000149c:	8082                	ret
      kfree(mem);
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	54a080e7          	jalr	1354(ra) # 800009ea <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
      return 0;
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    return oldsz;
    800014ba:	852e                	mv	a0,a1
}
    800014bc:	8082                	ret
  return newsz;
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014da:	4985                	li	s3,1
    800014dc:	a821                	j	800014f4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014de:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014e0:	0532                	slli	a0,a0,0xc
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	fe0080e7          	jalr	-32(ra) # 800014c2 <freewalk>
      pagetable[i] = 0;
    800014ea:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014ee:	04a1                	addi	s1,s1,8
    800014f0:	03248163          	beq	s1,s2,80001512 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014f4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f6:	00f57793          	andi	a5,a0,15
    800014fa:	ff3782e3          	beq	a5,s3,800014de <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014fe:	8905                	andi	a0,a0,1
    80001500:	d57d                	beqz	a0,800014ee <freewalk+0x2c>
      panic("freewalk: leaf");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	c7650513          	addi	a0,a0,-906 # 80008178 <digits+0x138>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	034080e7          	jalr	52(ra) # 8000053e <panic>
    }
  }
  kfree((void*)pagetable);
    80001512:	8552                	mv	a0,s4
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	4d6080e7          	jalr	1238(ra) # 800009ea <kfree>
}
    8000151c:	70a2                	ld	ra,40(sp)
    8000151e:	7402                	ld	s0,32(sp)
    80001520:	64e2                	ld	s1,24(sp)
    80001522:	6942                	ld	s2,16(sp)
    80001524:	69a2                	ld	s3,8(sp)
    80001526:	6a02                	ld	s4,0(sp)
    80001528:	6145                	addi	sp,sp,48
    8000152a:	8082                	ret

000000008000152c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    80001536:	84aa                	mv	s1,a0
  if(sz > 0)
    80001538:	e999                	bnez	a1,8000154e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000153a:	8526                	mv	a0,s1
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f86080e7          	jalr	-122(ra) # 800014c2 <freewalk>
}
    80001544:	60e2                	ld	ra,24(sp)
    80001546:	6442                	ld	s0,16(sp)
    80001548:	64a2                	ld	s1,8(sp)
    8000154a:	6105                	addi	sp,sp,32
    8000154c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000154e:	6605                	lui	a2,0x1
    80001550:	167d                	addi	a2,a2,-1
    80001552:	962e                	add	a2,a2,a1
    80001554:	4685                	li	a3,1
    80001556:	8231                	srli	a2,a2,0xc
    80001558:	4581                	li	a1,0
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	d0a080e7          	jalr	-758(ra) # 80001264 <uvmunmap>
    80001562:	bfe1                	j	8000153a <uvmfree+0xe>

0000000080001564 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001564:	c679                	beqz	a2,80001632 <uvmcopy+0xce>
{
    80001566:	715d                	addi	sp,sp,-80
    80001568:	e486                	sd	ra,72(sp)
    8000156a:	e0a2                	sd	s0,64(sp)
    8000156c:	fc26                	sd	s1,56(sp)
    8000156e:	f84a                	sd	s2,48(sp)
    80001570:	f44e                	sd	s3,40(sp)
    80001572:	f052                	sd	s4,32(sp)
    80001574:	ec56                	sd	s5,24(sp)
    80001576:	e85a                	sd	s6,16(sp)
    80001578:	e45e                	sd	s7,8(sp)
    8000157a:	0880                	addi	s0,sp,80
    8000157c:	8b2a                	mv	s6,a0
    8000157e:	8aae                	mv	s5,a1
    80001580:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001582:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001584:	4601                	li	a2,0
    80001586:	85ce                	mv	a1,s3
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	a2c080e7          	jalr	-1492(ra) # 80000fb6 <walk>
    80001592:	c531                	beqz	a0,800015de <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001594:	6118                	ld	a4,0(a0)
    80001596:	00177793          	andi	a5,a4,1
    8000159a:	cbb1                	beqz	a5,800015ee <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    8000159c:	00a75593          	srli	a1,a4,0xa
    800015a0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015a4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015a8:	fffff097          	auipc	ra,0xfffff
    800015ac:	53e080e7          	jalr	1342(ra) # 80000ae6 <kalloc>
    800015b0:	892a                	mv	s2,a0
    800015b2:	c939                	beqz	a0,80001608 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015b4:	6605                	lui	a2,0x1
    800015b6:	85de                	mv	a1,s7
    800015b8:	fffff097          	auipc	ra,0xfffff
    800015bc:	776080e7          	jalr	1910(ra) # 80000d2e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015c0:	8726                	mv	a4,s1
    800015c2:	86ca                	mv	a3,s2
    800015c4:	6605                	lui	a2,0x1
    800015c6:	85ce                	mv	a1,s3
    800015c8:	8556                	mv	a0,s5
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	ad4080e7          	jalr	-1324(ra) # 8000109e <mappages>
    800015d2:	e515                	bnez	a0,800015fe <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015d4:	6785                	lui	a5,0x1
    800015d6:	99be                	add	s3,s3,a5
    800015d8:	fb49e6e3          	bltu	s3,s4,80001584 <uvmcopy+0x20>
    800015dc:	a081                	j	8000161c <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015de:	00007517          	auipc	a0,0x7
    800015e2:	baa50513          	addi	a0,a0,-1110 # 80008188 <digits+0x148>
    800015e6:	fffff097          	auipc	ra,0xfffff
    800015ea:	f58080e7          	jalr	-168(ra) # 8000053e <panic>
      panic("uvmcopy: page not present");
    800015ee:	00007517          	auipc	a0,0x7
    800015f2:	bba50513          	addi	a0,a0,-1094 # 800081a8 <digits+0x168>
    800015f6:	fffff097          	auipc	ra,0xfffff
    800015fa:	f48080e7          	jalr	-184(ra) # 8000053e <panic>
      kfree(mem);
    800015fe:	854a                	mv	a0,s2
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	3ea080e7          	jalr	1002(ra) # 800009ea <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001608:	4685                	li	a3,1
    8000160a:	00c9d613          	srli	a2,s3,0xc
    8000160e:	4581                	li	a1,0
    80001610:	8556                	mv	a0,s5
    80001612:	00000097          	auipc	ra,0x0
    80001616:	c52080e7          	jalr	-942(ra) # 80001264 <uvmunmap>
  return -1;
    8000161a:	557d                	li	a0,-1
}
    8000161c:	60a6                	ld	ra,72(sp)
    8000161e:	6406                	ld	s0,64(sp)
    80001620:	74e2                	ld	s1,56(sp)
    80001622:	7942                	ld	s2,48(sp)
    80001624:	79a2                	ld	s3,40(sp)
    80001626:	7a02                	ld	s4,32(sp)
    80001628:	6ae2                	ld	s5,24(sp)
    8000162a:	6b42                	ld	s6,16(sp)
    8000162c:	6ba2                	ld	s7,8(sp)
    8000162e:	6161                	addi	sp,sp,80
    80001630:	8082                	ret
  return 0;
    80001632:	4501                	li	a0,0
}
    80001634:	8082                	ret

0000000080001636 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001636:	1141                	addi	sp,sp,-16
    80001638:	e406                	sd	ra,8(sp)
    8000163a:	e022                	sd	s0,0(sp)
    8000163c:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000163e:	4601                	li	a2,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	976080e7          	jalr	-1674(ra) # 80000fb6 <walk>
  if(pte == 0)
    80001648:	c901                	beqz	a0,80001658 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000164a:	611c                	ld	a5,0(a0)
    8000164c:	9bbd                	andi	a5,a5,-17
    8000164e:	e11c                	sd	a5,0(a0)
}
    80001650:	60a2                	ld	ra,8(sp)
    80001652:	6402                	ld	s0,0(sp)
    80001654:	0141                	addi	sp,sp,16
    80001656:	8082                	ret
    panic("uvmclear");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b7050513          	addi	a0,a0,-1168 # 800081c8 <digits+0x188>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	ede080e7          	jalr	-290(ra) # 8000053e <panic>

0000000080001668 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001668:	c6bd                	beqz	a3,800016d6 <copyout+0x6e>
{
    8000166a:	715d                	addi	sp,sp,-80
    8000166c:	e486                	sd	ra,72(sp)
    8000166e:	e0a2                	sd	s0,64(sp)
    80001670:	fc26                	sd	s1,56(sp)
    80001672:	f84a                	sd	s2,48(sp)
    80001674:	f44e                	sd	s3,40(sp)
    80001676:	f052                	sd	s4,32(sp)
    80001678:	ec56                	sd	s5,24(sp)
    8000167a:	e85a                	sd	s6,16(sp)
    8000167c:	e45e                	sd	s7,8(sp)
    8000167e:	e062                	sd	s8,0(sp)
    80001680:	0880                	addi	s0,sp,80
    80001682:	8b2a                	mv	s6,a0
    80001684:	8c2e                	mv	s8,a1
    80001686:	8a32                	mv	s4,a2
    80001688:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000168a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000168c:	6a85                	lui	s5,0x1
    8000168e:	a015                	j	800016b2 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001690:	9562                	add	a0,a0,s8
    80001692:	0004861b          	sext.w	a2,s1
    80001696:	85d2                	mv	a1,s4
    80001698:	41250533          	sub	a0,a0,s2
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	692080e7          	jalr	1682(ra) # 80000d2e <memmove>

    len -= n;
    800016a4:	409989b3          	sub	s3,s3,s1
    src += n;
    800016a8:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016aa:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016ae:	02098263          	beqz	s3,800016d2 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016b2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016b6:	85ca                	mv	a1,s2
    800016b8:	855a                	mv	a0,s6
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	9a2080e7          	jalr	-1630(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800016c2:	cd01                	beqz	a0,800016da <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016c4:	418904b3          	sub	s1,s2,s8
    800016c8:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ca:	fc99f3e3          	bgeu	s3,s1,80001690 <copyout+0x28>
    800016ce:	84ce                	mv	s1,s3
    800016d0:	b7c1                	j	80001690 <copyout+0x28>
  }
  return 0;
    800016d2:	4501                	li	a0,0
    800016d4:	a021                	j	800016dc <copyout+0x74>
    800016d6:	4501                	li	a0,0
}
    800016d8:	8082                	ret
      return -1;
    800016da:	557d                	li	a0,-1
}
    800016dc:	60a6                	ld	ra,72(sp)
    800016de:	6406                	ld	s0,64(sp)
    800016e0:	74e2                	ld	s1,56(sp)
    800016e2:	7942                	ld	s2,48(sp)
    800016e4:	79a2                	ld	s3,40(sp)
    800016e6:	7a02                	ld	s4,32(sp)
    800016e8:	6ae2                	ld	s5,24(sp)
    800016ea:	6b42                	ld	s6,16(sp)
    800016ec:	6ba2                	ld	s7,8(sp)
    800016ee:	6c02                	ld	s8,0(sp)
    800016f0:	6161                	addi	sp,sp,80
    800016f2:	8082                	ret

00000000800016f4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016f4:	caa5                	beqz	a3,80001764 <copyin+0x70>
{
    800016f6:	715d                	addi	sp,sp,-80
    800016f8:	e486                	sd	ra,72(sp)
    800016fa:	e0a2                	sd	s0,64(sp)
    800016fc:	fc26                	sd	s1,56(sp)
    800016fe:	f84a                	sd	s2,48(sp)
    80001700:	f44e                	sd	s3,40(sp)
    80001702:	f052                	sd	s4,32(sp)
    80001704:	ec56                	sd	s5,24(sp)
    80001706:	e85a                	sd	s6,16(sp)
    80001708:	e45e                	sd	s7,8(sp)
    8000170a:	e062                	sd	s8,0(sp)
    8000170c:	0880                	addi	s0,sp,80
    8000170e:	8b2a                	mv	s6,a0
    80001710:	8a2e                	mv	s4,a1
    80001712:	8c32                	mv	s8,a2
    80001714:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001716:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001718:	6a85                	lui	s5,0x1
    8000171a:	a01d                	j	80001740 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171c:	018505b3          	add	a1,a0,s8
    80001720:	0004861b          	sext.w	a2,s1
    80001724:	412585b3          	sub	a1,a1,s2
    80001728:	8552                	mv	a0,s4
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	604080e7          	jalr	1540(ra) # 80000d2e <memmove>

    len -= n;
    80001732:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001736:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001738:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000173c:	02098263          	beqz	s3,80001760 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001740:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001744:	85ca                	mv	a1,s2
    80001746:	855a                	mv	a0,s6
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	914080e7          	jalr	-1772(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    80001750:	cd01                	beqz	a0,80001768 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001752:	418904b3          	sub	s1,s2,s8
    80001756:	94d6                	add	s1,s1,s5
    if(n > len)
    80001758:	fc99f2e3          	bgeu	s3,s1,8000171c <copyin+0x28>
    8000175c:	84ce                	mv	s1,s3
    8000175e:	bf7d                	j	8000171c <copyin+0x28>
  }
  return 0;
    80001760:	4501                	li	a0,0
    80001762:	a021                	j	8000176a <copyin+0x76>
    80001764:	4501                	li	a0,0
}
    80001766:	8082                	ret
      return -1;
    80001768:	557d                	li	a0,-1
}
    8000176a:	60a6                	ld	ra,72(sp)
    8000176c:	6406                	ld	s0,64(sp)
    8000176e:	74e2                	ld	s1,56(sp)
    80001770:	7942                	ld	s2,48(sp)
    80001772:	79a2                	ld	s3,40(sp)
    80001774:	7a02                	ld	s4,32(sp)
    80001776:	6ae2                	ld	s5,24(sp)
    80001778:	6b42                	ld	s6,16(sp)
    8000177a:	6ba2                	ld	s7,8(sp)
    8000177c:	6c02                	ld	s8,0(sp)
    8000177e:	6161                	addi	sp,sp,80
    80001780:	8082                	ret

0000000080001782 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001782:	c6c5                	beqz	a3,8000182a <copyinstr+0xa8>
{
    80001784:	715d                	addi	sp,sp,-80
    80001786:	e486                	sd	ra,72(sp)
    80001788:	e0a2                	sd	s0,64(sp)
    8000178a:	fc26                	sd	s1,56(sp)
    8000178c:	f84a                	sd	s2,48(sp)
    8000178e:	f44e                	sd	s3,40(sp)
    80001790:	f052                	sd	s4,32(sp)
    80001792:	ec56                	sd	s5,24(sp)
    80001794:	e85a                	sd	s6,16(sp)
    80001796:	e45e                	sd	s7,8(sp)
    80001798:	0880                	addi	s0,sp,80
    8000179a:	8a2a                	mv	s4,a0
    8000179c:	8b2e                	mv	s6,a1
    8000179e:	8bb2                	mv	s7,a2
    800017a0:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017a2:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017a4:	6985                	lui	s3,0x1
    800017a6:	a035                	j	800017d2 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017a8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ac:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017ae:	0017b793          	seqz	a5,a5
    800017b2:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017b6:	60a6                	ld	ra,72(sp)
    800017b8:	6406                	ld	s0,64(sp)
    800017ba:	74e2                	ld	s1,56(sp)
    800017bc:	7942                	ld	s2,48(sp)
    800017be:	79a2                	ld	s3,40(sp)
    800017c0:	7a02                	ld	s4,32(sp)
    800017c2:	6ae2                	ld	s5,24(sp)
    800017c4:	6b42                	ld	s6,16(sp)
    800017c6:	6ba2                	ld	s7,8(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret
    srcva = va0 + PGSIZE;
    800017cc:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017d0:	c8a9                	beqz	s1,80001822 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017d2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017d6:	85ca                	mv	a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	00000097          	auipc	ra,0x0
    800017de:	882080e7          	jalr	-1918(ra) # 8000105c <walkaddr>
    if(pa0 == 0)
    800017e2:	c131                	beqz	a0,80001826 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017e4:	41790833          	sub	a6,s2,s7
    800017e8:	984e                	add	a6,a6,s3
    if(n > max)
    800017ea:	0104f363          	bgeu	s1,a6,800017f0 <copyinstr+0x6e>
    800017ee:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017f0:	955e                	add	a0,a0,s7
    800017f2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017f6:	fc080be3          	beqz	a6,800017cc <copyinstr+0x4a>
    800017fa:	985a                	add	a6,a6,s6
    800017fc:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017fe:	41650633          	sub	a2,a0,s6
    80001802:	14fd                	addi	s1,s1,-1
    80001804:	9b26                	add	s6,s6,s1
    80001806:	00f60733          	add	a4,a2,a5
    8000180a:	00074703          	lbu	a4,0(a4)
    8000180e:	df49                	beqz	a4,800017a8 <copyinstr+0x26>
        *dst = *p;
    80001810:	00e78023          	sb	a4,0(a5)
      --max;
    80001814:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001818:	0785                	addi	a5,a5,1
    while(n > 0){
    8000181a:	ff0796e3          	bne	a5,a6,80001806 <copyinstr+0x84>
      dst++;
    8000181e:	8b42                	mv	s6,a6
    80001820:	b775                	j	800017cc <copyinstr+0x4a>
    80001822:	4781                	li	a5,0
    80001824:	b769                	j	800017ae <copyinstr+0x2c>
      return -1;
    80001826:	557d                	li	a0,-1
    80001828:	b779                	j	800017b6 <copyinstr+0x34>
  int got_null = 0;
    8000182a:	4781                	li	a5,0
  if(got_null){
    8000182c:	0017b793          	seqz	a5,a5
    80001830:	40f00533          	neg	a0,a5
}
    80001834:	8082                	ret

0000000080001836 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000184c:	0000f497          	auipc	s1,0xf
    80001850:	75448493          	addi	s1,s1,1876 # 80010fa0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00006a97          	auipc	s5,0x6
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80008000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1
    80001864:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001866:	00016a17          	auipc	s4,0x16
    8000186a:	93aa0a13          	addi	s4,s4,-1734 # 800171a0 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if(pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	858d                	srai	a1,a1,0x3
    80001880:	000ab783          	ld	a5,0(s5)
    80001884:	02f585b3          	mul	a1,a1,a5
    80001888:	2585                	addiw	a1,a1,1
    8000188a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188e:	4719                	li	a4,6
    80001890:	6685                	lui	a3,0x1
    80001892:	40b905b3          	sub	a1,s2,a1
    80001896:	854e                	mv	a0,s3
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8a6080e7          	jalr	-1882(ra) # 8000113e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	18848493          	addi	s1,s1,392
    800018a4:	fd4495e3          	bne	s1,s4,8000186e <proc_mapstacks+0x38>
  }
}
    800018a8:	70e2                	ld	ra,56(sp)
    800018aa:	7442                	ld	s0,48(sp)
    800018ac:	74a2                	ld	s1,40(sp)
    800018ae:	7902                	ld	s2,32(sp)
    800018b0:	69e2                	ld	s3,24(sp)
    800018b2:	6a42                	ld	s4,16(sp)
    800018b4:	6aa2                	ld	s5,8(sp)
    800018b6:	6b02                	ld	s6,0(sp)
    800018b8:	6121                	addi	sp,sp,64
    800018ba:	8082                	ret
      panic("kalloc");
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	91c50513          	addi	a0,a0,-1764 # 800081d8 <digits+0x198>
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	c7a080e7          	jalr	-902(ra) # 8000053e <panic>

00000000800018cc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018cc:	7139                	addi	sp,sp,-64
    800018ce:	fc06                	sd	ra,56(sp)
    800018d0:	f822                	sd	s0,48(sp)
    800018d2:	f426                	sd	s1,40(sp)
    800018d4:	f04a                	sd	s2,32(sp)
    800018d6:	ec4e                	sd	s3,24(sp)
    800018d8:	e852                	sd	s4,16(sp)
    800018da:	e456                	sd	s5,8(sp)
    800018dc:	e05a                	sd	s6,0(sp)
    800018de:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018e0:	00007597          	auipc	a1,0x7
    800018e4:	90058593          	addi	a1,a1,-1792 # 800081e0 <digits+0x1a0>
    800018e8:	0000f517          	auipc	a0,0xf
    800018ec:	28850513          	addi	a0,a0,648 # 80010b70 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	28850513          	addi	a0,a0,648 # 80010b88 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	69048493          	addi	s1,s1,1680 # 80010fa0 <proc>
      initlock(&p->lock, "proc");
    80001918:	00007b17          	auipc	s6,0x7
    8000191c:	8e0b0b13          	addi	s6,s6,-1824 # 800081f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001920:	8aa6                	mv	s5,s1
    80001922:	00006a17          	auipc	s4,0x6
    80001926:	6dea0a13          	addi	s4,s4,1758 # 80008000 <etext>
    8000192a:	04000937          	lui	s2,0x4000
    8000192e:	197d                	addi	s2,s2,-1
    80001930:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001932:	00016997          	auipc	s3,0x16
    80001936:	86e98993          	addi	s3,s3,-1938 # 800171a0 <tickslock>
      initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
      p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	878d                	srai	a5,a5,0x3
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	f0bc                	sd	a5,96(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	18848493          	addi	s1,s1,392
    80001968:	fd3499e3          	bne	s1,s3,8000193a <procinit+0x6e>
  }
}
    8000196c:	70e2                	ld	ra,56(sp)
    8000196e:	7442                	ld	s0,48(sp)
    80001970:	74a2                	ld	s1,40(sp)
    80001972:	7902                	ld	s2,32(sp)
    80001974:	69e2                	ld	s3,24(sp)
    80001976:	6a42                	ld	s4,16(sp)
    80001978:	6aa2                	ld	s5,8(sp)
    8000197a:	6b02                	ld	s6,0(sp)
    8000197c:	6121                	addi	sp,sp,64
    8000197e:	8082                	ret

0000000080001980 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001980:	1141                	addi	sp,sp,-16
    80001982:	e422                	sd	s0,8(sp)
    80001984:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001986:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001988:	2501                	sext.w	a0,a0
    8000198a:	6422                	ld	s0,8(sp)
    8000198c:	0141                	addi	sp,sp,16
    8000198e:	8082                	ret

0000000080001990 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001990:	1141                	addi	sp,sp,-16
    80001992:	e422                	sd	s0,8(sp)
    80001994:	0800                	addi	s0,sp,16
    80001996:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001998:	2781                	sext.w	a5,a5
    8000199a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000199c:	0000f517          	auipc	a0,0xf
    800019a0:	20450513          	addi	a0,a0,516 # 80010ba0 <cpus>
    800019a4:	953e                	add	a0,a0,a5
    800019a6:	6422                	ld	s0,8(sp)
    800019a8:	0141                	addi	sp,sp,16
    800019aa:	8082                	ret

00000000800019ac <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019ac:	1101                	addi	sp,sp,-32
    800019ae:	ec06                	sd	ra,24(sp)
    800019b0:	e822                	sd	s0,16(sp)
    800019b2:	e426                	sd	s1,8(sp)
    800019b4:	1000                	addi	s0,sp,32
  push_off();
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1d4080e7          	jalr	468(ra) # 80000b8a <push_off>
    800019be:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019c0:	2781                	sext.w	a5,a5
    800019c2:	079e                	slli	a5,a5,0x7
    800019c4:	0000f717          	auipc	a4,0xf
    800019c8:	1ac70713          	addi	a4,a4,428 # 80010b70 <pid_lock>
    800019cc:	97ba                	add	a5,a5,a4
    800019ce:	7b84                	ld	s1,48(a5)
  pop_off();
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	25a080e7          	jalr	602(ra) # 80000c2a <pop_off>
  return p;
}
    800019d8:	8526                	mv	a0,s1
    800019da:	60e2                	ld	ra,24(sp)
    800019dc:	6442                	ld	s0,16(sp)
    800019de:	64a2                	ld	s1,8(sp)
    800019e0:	6105                	addi	sp,sp,32
    800019e2:	8082                	ret

00000000800019e4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019e4:	1141                	addi	sp,sp,-16
    800019e6:	e406                	sd	ra,8(sp)
    800019e8:	e022                	sd	s0,0(sp)
    800019ea:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019ec:	00000097          	auipc	ra,0x0
    800019f0:	fc0080e7          	jalr	-64(ra) # 800019ac <myproc>
    800019f4:	fffff097          	auipc	ra,0xfffff
    800019f8:	296080e7          	jalr	662(ra) # 80000c8a <release>

  if (first) {
    800019fc:	00007797          	auipc	a5,0x7
    80001a00:	e647a783          	lw	a5,-412(a5) # 80008860 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	cb2080e7          	jalr	-846(ra) # 800026b8 <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	e407a523          	sw	zero,-438(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	a3a080e7          	jalr	-1478(ra) # 8000345a <fsinit>
    80001a28:	bff9                	j	80001a06 <forkret+0x22>

0000000080001a2a <allocpid>:
{
    80001a2a:	1101                	addi	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a36:	0000f917          	auipc	s2,0xf
    80001a3a:	13a90913          	addi	s2,s2,314 # 80010b70 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	e1c78793          	addi	a5,a5,-484 # 80008864 <nextpid>
    80001a50:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a52:	0014871b          	addiw	a4,s1,1
    80001a56:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a58:	854a                	mv	a0,s2
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	230080e7          	jalr	560(ra) # 80000c8a <release>
}
    80001a62:	8526                	mv	a0,s1
    80001a64:	60e2                	ld	ra,24(sp)
    80001a66:	6442                	ld	s0,16(sp)
    80001a68:	64a2                	ld	s1,8(sp)
    80001a6a:	6902                	ld	s2,0(sp)
    80001a6c:	6105                	addi	sp,sp,32
    80001a6e:	8082                	ret

0000000080001a70 <proc_pagetable>:
{
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	e04a                	sd	s2,0(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a7e:	00000097          	auipc	ra,0x0
    80001a82:	8aa080e7          	jalr	-1878(ra) # 80001328 <uvmcreate>
    80001a86:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a88:	c121                	beqz	a0,80001ac8 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a8a:	4729                	li	a4,10
    80001a8c:	00005697          	auipc	a3,0x5
    80001a90:	57468693          	addi	a3,a3,1396 # 80007000 <_trampoline>
    80001a94:	6605                	lui	a2,0x1
    80001a96:	040005b7          	lui	a1,0x4000
    80001a9a:	15fd                	addi	a1,a1,-1
    80001a9c:	05b2                	slli	a1,a1,0xc
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	600080e7          	jalr	1536(ra) # 8000109e <mappages>
    80001aa6:	02054863          	bltz	a0,80001ad6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aaa:	4719                	li	a4,6
    80001aac:	07893683          	ld	a3,120(s2)
    80001ab0:	6605                	lui	a2,0x1
    80001ab2:	020005b7          	lui	a1,0x2000
    80001ab6:	15fd                	addi	a1,a1,-1
    80001ab8:	05b6                	slli	a1,a1,0xd
    80001aba:	8526                	mv	a0,s1
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	5e2080e7          	jalr	1506(ra) # 8000109e <mappages>
    80001ac4:	02054163          	bltz	a0,80001ae6 <proc_pagetable+0x76>
}
    80001ac8:	8526                	mv	a0,s1
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6902                	ld	s2,0(sp)
    80001ad2:	6105                	addi	sp,sp,32
    80001ad4:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad6:	4581                	li	a1,0
    80001ad8:	8526                	mv	a0,s1
    80001ada:	00000097          	auipc	ra,0x0
    80001ade:	a52080e7          	jalr	-1454(ra) # 8000152c <uvmfree>
    return 0;
    80001ae2:	4481                	li	s1,0
    80001ae4:	b7d5                	j	80001ac8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae6:	4681                	li	a3,0
    80001ae8:	4605                	li	a2,1
    80001aea:	040005b7          	lui	a1,0x4000
    80001aee:	15fd                	addi	a1,a1,-1
    80001af0:	05b2                	slli	a1,a1,0xc
    80001af2:	8526                	mv	a0,s1
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	770080e7          	jalr	1904(ra) # 80001264 <uvmunmap>
    uvmfree(pagetable, 0);
    80001afc:	4581                	li	a1,0
    80001afe:	8526                	mv	a0,s1
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	a2c080e7          	jalr	-1492(ra) # 8000152c <uvmfree>
    return 0;
    80001b08:	4481                	li	s1,0
    80001b0a:	bf7d                	j	80001ac8 <proc_pagetable+0x58>

0000000080001b0c <proc_freepagetable>:
{
    80001b0c:	1101                	addi	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	e04a                	sd	s2,0(sp)
    80001b16:	1000                	addi	s0,sp,32
    80001b18:	84aa                	mv	s1,a0
    80001b1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1c:	4681                	li	a3,0
    80001b1e:	4605                	li	a2,1
    80001b20:	040005b7          	lui	a1,0x4000
    80001b24:	15fd                	addi	a1,a1,-1
    80001b26:	05b2                	slli	a1,a1,0xc
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	73c080e7          	jalr	1852(ra) # 80001264 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b30:	4681                	li	a3,0
    80001b32:	4605                	li	a2,1
    80001b34:	020005b7          	lui	a1,0x2000
    80001b38:	15fd                	addi	a1,a1,-1
    80001b3a:	05b6                	slli	a1,a1,0xd
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	726080e7          	jalr	1830(ra) # 80001264 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b46:	85ca                	mv	a1,s2
    80001b48:	8526                	mv	a0,s1
    80001b4a:	00000097          	auipc	ra,0x0
    80001b4e:	9e2080e7          	jalr	-1566(ra) # 8000152c <uvmfree>
}
    80001b52:	60e2                	ld	ra,24(sp)
    80001b54:	6442                	ld	s0,16(sp)
    80001b56:	64a2                	ld	s1,8(sp)
    80001b58:	6902                	ld	s2,0(sp)
    80001b5a:	6105                	addi	sp,sp,32
    80001b5c:	8082                	ret

0000000080001b5e <freeproc>:
{
    80001b5e:	1101                	addi	sp,sp,-32
    80001b60:	ec06                	sd	ra,24(sp)
    80001b62:	e822                	sd	s0,16(sp)
    80001b64:	e426                	sd	s1,8(sp)
    80001b66:	1000                	addi	s0,sp,32
    80001b68:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b6a:	7d28                	ld	a0,120(a0)
    80001b6c:	c509                	beqz	a0,80001b76 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	e7c080e7          	jalr	-388(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b76:	0604bc23          	sd	zero,120(s1)
  if(p->pagetable)
    80001b7a:	78a8                	ld	a0,112(s1)
    80001b7c:	c511                	beqz	a0,80001b88 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7e:	74ac                	ld	a1,104(s1)
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	f8c080e7          	jalr	-116(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b88:	0604b823          	sd	zero,112(s1)
  p->sz = 0;
    80001b8c:	0604b423          	sd	zero,104(s1)
  p->pid = 0;
    80001b90:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b94:	0404bc23          	sd	zero,88(s1)
  p->name[0] = 0;
    80001b98:	16048c23          	sb	zero,376(s1)
  p->chan = 0;
    80001b9c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ba0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ba4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba8:	0004ac23          	sw	zero,24(s1)
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret

0000000080001bb6 <allocproc>:
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	e04a                	sd	s2,0(sp)
    80001bc0:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bc2:	0000f497          	auipc	s1,0xf
    80001bc6:	3de48493          	addi	s1,s1,990 # 80010fa0 <proc>
    80001bca:	00015917          	auipc	s2,0x15
    80001bce:	5d690913          	addi	s2,s2,1494 # 800171a0 <tickslock>
    acquire(&p->lock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	002080e7          	jalr	2(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001bdc:	4c9c                	lw	a5,24(s1)
    80001bde:	cf81                	beqz	a5,80001bf6 <allocproc+0x40>
      release(&p->lock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	0a8080e7          	jalr	168(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bea:	18848493          	addi	s1,s1,392
    80001bee:	ff2492e3          	bne	s1,s2,80001bd2 <allocproc+0x1c>
  return 0;
    80001bf2:	4481                	li	s1,0
    80001bf4:	a889                	j	80001c46 <allocproc+0x90>
  p->pid = allocpid();
    80001bf6:	00000097          	auipc	ra,0x0
    80001bfa:	e34080e7          	jalr	-460(ra) # 80001a2a <allocpid>
    80001bfe:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c00:	4785                	li	a5,1
    80001c02:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	ee2080e7          	jalr	-286(ra) # 80000ae6 <kalloc>
    80001c0c:	892a                	mv	s2,a0
    80001c0e:	fca8                	sd	a0,120(s1)
    80001c10:	c131                	beqz	a0,80001c54 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c12:	8526                	mv	a0,s1
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e5c080e7          	jalr	-420(ra) # 80001a70 <proc_pagetable>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	f8a8                	sd	a0,112(s1)
  if(p->pagetable == 0){
    80001c20:	c531                	beqz	a0,80001c6c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c22:	07000613          	li	a2,112
    80001c26:	4581                	li	a1,0
    80001c28:	08048513          	addi	a0,s1,128
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	0a6080e7          	jalr	166(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c34:	00000797          	auipc	a5,0x0
    80001c38:	db078793          	addi	a5,a5,-592 # 800019e4 <forkret>
    80001c3c:	e0dc                	sd	a5,128(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c3e:	70bc                	ld	a5,96(s1)
    80001c40:	6705                	lui	a4,0x1
    80001c42:	97ba                	add	a5,a5,a4
    80001c44:	e4dc                	sd	a5,136(s1)
}
    80001c46:	8526                	mv	a0,s1
    80001c48:	60e2                	ld	ra,24(sp)
    80001c4a:	6442                	ld	s0,16(sp)
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	6902                	ld	s2,0(sp)
    80001c50:	6105                	addi	sp,sp,32
    80001c52:	8082                	ret
    freeproc(p);
    80001c54:	8526                	mv	a0,s1
    80001c56:	00000097          	auipc	ra,0x0
    80001c5a:	f08080e7          	jalr	-248(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	fffff097          	auipc	ra,0xfffff
    80001c64:	02a080e7          	jalr	42(ra) # 80000c8a <release>
    return 0;
    80001c68:	84ca                	mv	s1,s2
    80001c6a:	bff1                	j	80001c46 <allocproc+0x90>
    freeproc(p);
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	ef0080e7          	jalr	-272(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c76:	8526                	mv	a0,s1
    80001c78:	fffff097          	auipc	ra,0xfffff
    80001c7c:	012080e7          	jalr	18(ra) # 80000c8a <release>
    return 0;
    80001c80:	84ca                	mv	s1,s2
    80001c82:	b7d1                	j	80001c46 <allocproc+0x90>

0000000080001c84 <userinit>:
{
    80001c84:	1101                	addi	sp,sp,-32
    80001c86:	ec06                	sd	ra,24(sp)
    80001c88:	e822                	sd	s0,16(sp)
    80001c8a:	e426                	sd	s1,8(sp)
    80001c8c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	f28080e7          	jalr	-216(ra) # 80001bb6 <allocproc>
    80001c96:	84aa                	mv	s1,a0
  initproc = p;
    80001c98:	00007797          	auipc	a5,0x7
    80001c9c:	c6a7b023          	sd	a0,-928(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ca0:	03400613          	li	a2,52
    80001ca4:	00007597          	auipc	a1,0x7
    80001ca8:	bcc58593          	addi	a1,a1,-1076 # 80008870 <initcode>
    80001cac:	7928                	ld	a0,112(a0)
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	6a8080e7          	jalr	1704(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001cb6:	6785                	lui	a5,0x1
    80001cb8:	f4bc                	sd	a5,104(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cba:	7cb8                	ld	a4,120(s1)
    80001cbc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001cc0:	7cb8                	ld	a4,120(s1)
    80001cc2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cc4:	4641                	li	a2,16
    80001cc6:	00006597          	auipc	a1,0x6
    80001cca:	53a58593          	addi	a1,a1,1338 # 80008200 <digits+0x1c0>
    80001cce:	17848513          	addi	a0,s1,376
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	14a080e7          	jalr	330(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001cda:	00006517          	auipc	a0,0x6
    80001cde:	53650513          	addi	a0,a0,1334 # 80008210 <digits+0x1d0>
    80001ce2:	00002097          	auipc	ra,0x2
    80001ce6:	19a080e7          	jalr	410(ra) # 80003e7c <namei>
    80001cea:	16a4b823          	sd	a0,368(s1)
  p->state = RUNNABLE;
    80001cee:	478d                	li	a5,3
    80001cf0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	f96080e7          	jalr	-106(ra) # 80000c8a <release>
}
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	64a2                	ld	s1,8(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret

0000000080001d06 <growproc>:
{
    80001d06:	1101                	addi	sp,sp,-32
    80001d08:	ec06                	sd	ra,24(sp)
    80001d0a:	e822                	sd	s0,16(sp)
    80001d0c:	e426                	sd	s1,8(sp)
    80001d0e:	e04a                	sd	s2,0(sp)
    80001d10:	1000                	addi	s0,sp,32
    80001d12:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	c98080e7          	jalr	-872(ra) # 800019ac <myproc>
    80001d1c:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d1e:	752c                	ld	a1,104(a0)
  if(n > 0){
    80001d20:	01204c63          	bgtz	s2,80001d38 <growproc+0x32>
  } else if(n < 0){
    80001d24:	02094663          	bltz	s2,80001d50 <growproc+0x4a>
  p->sz = sz;
    80001d28:	f4ac                	sd	a1,104(s1)
  return 0;
    80001d2a:	4501                	li	a0,0
}
    80001d2c:	60e2                	ld	ra,24(sp)
    80001d2e:	6442                	ld	s0,16(sp)
    80001d30:	64a2                	ld	s1,8(sp)
    80001d32:	6902                	ld	s2,0(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001d38:	4691                	li	a3,4
    80001d3a:	00b90633          	add	a2,s2,a1
    80001d3e:	7928                	ld	a0,112(a0)
    80001d40:	fffff097          	auipc	ra,0xfffff
    80001d44:	6d0080e7          	jalr	1744(ra) # 80001410 <uvmalloc>
    80001d48:	85aa                	mv	a1,a0
    80001d4a:	fd79                	bnez	a0,80001d28 <growproc+0x22>
      return -1;
    80001d4c:	557d                	li	a0,-1
    80001d4e:	bff9                	j	80001d2c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d50:	00b90633          	add	a2,s2,a1
    80001d54:	7928                	ld	a0,112(a0)
    80001d56:	fffff097          	auipc	ra,0xfffff
    80001d5a:	672080e7          	jalr	1650(ra) # 800013c8 <uvmdealloc>
    80001d5e:	85aa                	mv	a1,a0
    80001d60:	b7e1                	j	80001d28 <growproc+0x22>

0000000080001d62 <fork>:
{
    80001d62:	7139                	addi	sp,sp,-64
    80001d64:	fc06                	sd	ra,56(sp)
    80001d66:	f822                	sd	s0,48(sp)
    80001d68:	f426                	sd	s1,40(sp)
    80001d6a:	f04a                	sd	s2,32(sp)
    80001d6c:	ec4e                	sd	s3,24(sp)
    80001d6e:	e852                	sd	s4,16(sp)
    80001d70:	e456                	sd	s5,8(sp)
    80001d72:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	c38080e7          	jalr	-968(ra) # 800019ac <myproc>
    80001d7c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	e38080e7          	jalr	-456(ra) # 80001bb6 <allocproc>
    80001d86:	10050c63          	beqz	a0,80001e9e <fork+0x13c>
    80001d8a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d8c:	068ab603          	ld	a2,104(s5)
    80001d90:	792c                	ld	a1,112(a0)
    80001d92:	070ab503          	ld	a0,112(s5)
    80001d96:	fffff097          	auipc	ra,0xfffff
    80001d9a:	7ce080e7          	jalr	1998(ra) # 80001564 <uvmcopy>
    80001d9e:	04054863          	bltz	a0,80001dee <fork+0x8c>
  np->sz = p->sz;
    80001da2:	068ab783          	ld	a5,104(s5)
    80001da6:	06fa3423          	sd	a5,104(s4)
  *(np->trapframe) = *(p->trapframe);
    80001daa:	078ab683          	ld	a3,120(s5)
    80001dae:	87b6                	mv	a5,a3
    80001db0:	078a3703          	ld	a4,120(s4)
    80001db4:	12068693          	addi	a3,a3,288
    80001db8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dbc:	6788                	ld	a0,8(a5)
    80001dbe:	6b8c                	ld	a1,16(a5)
    80001dc0:	6f90                	ld	a2,24(a5)
    80001dc2:	01073023          	sd	a6,0(a4)
    80001dc6:	e708                	sd	a0,8(a4)
    80001dc8:	eb0c                	sd	a1,16(a4)
    80001dca:	ef10                	sd	a2,24(a4)
    80001dcc:	02078793          	addi	a5,a5,32
    80001dd0:	02070713          	addi	a4,a4,32
    80001dd4:	fed792e3          	bne	a5,a3,80001db8 <fork+0x56>
  np->trapframe->a0 = 0;
    80001dd8:	078a3783          	ld	a5,120(s4)
    80001ddc:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001de0:	0f0a8493          	addi	s1,s5,240
    80001de4:	0f0a0913          	addi	s2,s4,240
    80001de8:	170a8993          	addi	s3,s5,368
    80001dec:	a00d                	j	80001e0e <fork+0xac>
    freeproc(np);
    80001dee:	8552                	mv	a0,s4
    80001df0:	00000097          	auipc	ra,0x0
    80001df4:	d6e080e7          	jalr	-658(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001df8:	8552                	mv	a0,s4
    80001dfa:	fffff097          	auipc	ra,0xfffff
    80001dfe:	e90080e7          	jalr	-368(ra) # 80000c8a <release>
    return -1;
    80001e02:	597d                	li	s2,-1
    80001e04:	a059                	j	80001e8a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e06:	04a1                	addi	s1,s1,8
    80001e08:	0921                	addi	s2,s2,8
    80001e0a:	01348b63          	beq	s1,s3,80001e20 <fork+0xbe>
    if(p->ofile[i])
    80001e0e:	6088                	ld	a0,0(s1)
    80001e10:	d97d                	beqz	a0,80001e06 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e12:	00002097          	auipc	ra,0x2
    80001e16:	700080e7          	jalr	1792(ra) # 80004512 <filedup>
    80001e1a:	00a93023          	sd	a0,0(s2)
    80001e1e:	b7e5                	j	80001e06 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e20:	170ab503          	ld	a0,368(s5)
    80001e24:	00002097          	auipc	ra,0x2
    80001e28:	874080e7          	jalr	-1932(ra) # 80003698 <idup>
    80001e2c:	16aa3823          	sd	a0,368(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e30:	4641                	li	a2,16
    80001e32:	178a8593          	addi	a1,s5,376
    80001e36:	178a0513          	addi	a0,s4,376
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	fe2080e7          	jalr	-30(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001e42:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e46:	8552                	mv	a0,s4
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	e42080e7          	jalr	-446(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001e50:	0000f497          	auipc	s1,0xf
    80001e54:	d3848493          	addi	s1,s1,-712 # 80010b88 <wait_lock>
    80001e58:	8526                	mv	a0,s1
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	d7c080e7          	jalr	-644(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001e62:	055a3c23          	sd	s5,88(s4)
  release(&wait_lock);
    80001e66:	8526                	mv	a0,s1
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	e22080e7          	jalr	-478(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001e70:	8552                	mv	a0,s4
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	d64080e7          	jalr	-668(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001e7a:	478d                	li	a5,3
    80001e7c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001e80:	8552                	mv	a0,s4
    80001e82:	fffff097          	auipc	ra,0xfffff
    80001e86:	e08080e7          	jalr	-504(ra) # 80000c8a <release>
}
    80001e8a:	854a                	mv	a0,s2
    80001e8c:	70e2                	ld	ra,56(sp)
    80001e8e:	7442                	ld	s0,48(sp)
    80001e90:	74a2                	ld	s1,40(sp)
    80001e92:	7902                	ld	s2,32(sp)
    80001e94:	69e2                	ld	s3,24(sp)
    80001e96:	6a42                	ld	s4,16(sp)
    80001e98:	6aa2                	ld	s5,8(sp)
    80001e9a:	6121                	addi	sp,sp,64
    80001e9c:	8082                	ret
    return -1;
    80001e9e:	597d                	li	s2,-1
    80001ea0:	b7ed                	j	80001e8a <fork+0x128>

0000000080001ea2 <scheduler>:
{
    80001ea2:	7139                	addi	sp,sp,-64
    80001ea4:	fc06                	sd	ra,56(sp)
    80001ea6:	f822                	sd	s0,48(sp)
    80001ea8:	f426                	sd	s1,40(sp)
    80001eaa:	f04a                	sd	s2,32(sp)
    80001eac:	ec4e                	sd	s3,24(sp)
    80001eae:	e852                	sd	s4,16(sp)
    80001eb0:	e456                	sd	s5,8(sp)
    80001eb2:	e05a                	sd	s6,0(sp)
    80001eb4:	0080                	addi	s0,sp,64
    80001eb6:	8792                	mv	a5,tp
  int id = r_tp();
    80001eb8:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eba:	00779a93          	slli	s5,a5,0x7
    80001ebe:	0000f717          	auipc	a4,0xf
    80001ec2:	cb270713          	addi	a4,a4,-846 # 80010b70 <pid_lock>
    80001ec6:	9756                	add	a4,a4,s5
    80001ec8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ecc:	0000f717          	auipc	a4,0xf
    80001ed0:	cdc70713          	addi	a4,a4,-804 # 80010ba8 <cpus+0x8>
    80001ed4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ed6:	498d                	li	s3,3
        p->state = RUNNING;
    80001ed8:	4b11                	li	s6,4
        c->proc = p;
    80001eda:	079e                	slli	a5,a5,0x7
    80001edc:	0000fa17          	auipc	s4,0xf
    80001ee0:	c94a0a13          	addi	s4,s4,-876 # 80010b70 <pid_lock>
    80001ee4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	00015917          	auipc	s2,0x15
    80001eea:	2ba90913          	addi	s2,s2,698 # 800171a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ef2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ef6:	10079073          	csrw	sstatus,a5
    80001efa:	0000f497          	auipc	s1,0xf
    80001efe:	0a648493          	addi	s1,s1,166 # 80010fa0 <proc>
    80001f02:	a811                	j	80001f16 <scheduler+0x74>
      release(&p->lock);
    80001f04:	8526                	mv	a0,s1
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	d84080e7          	jalr	-636(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f0e:	18848493          	addi	s1,s1,392
    80001f12:	fd248ee3          	beq	s1,s2,80001eee <scheduler+0x4c>
      acquire(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	cbe080e7          	jalr	-834(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE) {
    80001f20:	4c9c                	lw	a5,24(s1)
    80001f22:	ff3791e3          	bne	a5,s3,80001f04 <scheduler+0x62>
        p->state = RUNNING;
    80001f26:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f2a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f2e:	08048593          	addi	a1,s1,128
    80001f32:	8556                	mv	a0,s5
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	6da080e7          	jalr	1754(ra) # 8000260e <swtch>
        c->proc = 0;
    80001f3c:	020a3823          	sd	zero,48(s4)
    80001f40:	b7d1                	j	80001f04 <scheduler+0x62>

0000000080001f42 <sched>:
{
    80001f42:	7179                	addi	sp,sp,-48
    80001f44:	f406                	sd	ra,40(sp)
    80001f46:	f022                	sd	s0,32(sp)
    80001f48:	ec26                	sd	s1,24(sp)
    80001f4a:	e84a                	sd	s2,16(sp)
    80001f4c:	e44e                	sd	s3,8(sp)
    80001f4e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	a5c080e7          	jalr	-1444(ra) # 800019ac <myproc>
    80001f58:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f5a:	fffff097          	auipc	ra,0xfffff
    80001f5e:	c02080e7          	jalr	-1022(ra) # 80000b5c <holding>
    80001f62:	c93d                	beqz	a0,80001fd8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f64:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f66:	2781                	sext.w	a5,a5
    80001f68:	079e                	slli	a5,a5,0x7
    80001f6a:	0000f717          	auipc	a4,0xf
    80001f6e:	c0670713          	addi	a4,a4,-1018 # 80010b70 <pid_lock>
    80001f72:	97ba                	add	a5,a5,a4
    80001f74:	0a87a703          	lw	a4,168(a5)
    80001f78:	4785                	li	a5,1
    80001f7a:	06f71763          	bne	a4,a5,80001fe8 <sched+0xa6>
  if(p->state == RUNNING)
    80001f7e:	4c98                	lw	a4,24(s1)
    80001f80:	4791                	li	a5,4
    80001f82:	06f70b63          	beq	a4,a5,80001ff8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f86:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f8a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f8c:	efb5                	bnez	a5,80002008 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f8e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f90:	0000f917          	auipc	s2,0xf
    80001f94:	be090913          	addi	s2,s2,-1056 # 80010b70 <pid_lock>
    80001f98:	2781                	sext.w	a5,a5
    80001f9a:	079e                	slli	a5,a5,0x7
    80001f9c:	97ca                	add	a5,a5,s2
    80001f9e:	0ac7a983          	lw	s3,172(a5)
    80001fa2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001fa4:	2781                	sext.w	a5,a5
    80001fa6:	079e                	slli	a5,a5,0x7
    80001fa8:	0000f597          	auipc	a1,0xf
    80001fac:	c0058593          	addi	a1,a1,-1024 # 80010ba8 <cpus+0x8>
    80001fb0:	95be                	add	a1,a1,a5
    80001fb2:	08048513          	addi	a0,s1,128
    80001fb6:	00000097          	auipc	ra,0x0
    80001fba:	658080e7          	jalr	1624(ra) # 8000260e <swtch>
    80001fbe:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fc0:	2781                	sext.w	a5,a5
    80001fc2:	079e                	slli	a5,a5,0x7
    80001fc4:	97ca                	add	a5,a5,s2
    80001fc6:	0b37a623          	sw	s3,172(a5)
}
    80001fca:	70a2                	ld	ra,40(sp)
    80001fcc:	7402                	ld	s0,32(sp)
    80001fce:	64e2                	ld	s1,24(sp)
    80001fd0:	6942                	ld	s2,16(sp)
    80001fd2:	69a2                	ld	s3,8(sp)
    80001fd4:	6145                	addi	sp,sp,48
    80001fd6:	8082                	ret
    panic("sched p->lock");
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	24050513          	addi	a0,a0,576 # 80008218 <digits+0x1d8>
    80001fe0:	ffffe097          	auipc	ra,0xffffe
    80001fe4:	55e080e7          	jalr	1374(ra) # 8000053e <panic>
    panic("sched locks");
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	24050513          	addi	a0,a0,576 # 80008228 <digits+0x1e8>
    80001ff0:	ffffe097          	auipc	ra,0xffffe
    80001ff4:	54e080e7          	jalr	1358(ra) # 8000053e <panic>
    panic("sched running");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	24050513          	addi	a0,a0,576 # 80008238 <digits+0x1f8>
    80002000:	ffffe097          	auipc	ra,0xffffe
    80002004:	53e080e7          	jalr	1342(ra) # 8000053e <panic>
    panic("sched interruptible");
    80002008:	00006517          	auipc	a0,0x6
    8000200c:	24050513          	addi	a0,a0,576 # 80008248 <digits+0x208>
    80002010:	ffffe097          	auipc	ra,0xffffe
    80002014:	52e080e7          	jalr	1326(ra) # 8000053e <panic>

0000000080002018 <yield>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002022:	00000097          	auipc	ra,0x0
    80002026:	98a080e7          	jalr	-1654(ra) # 800019ac <myproc>
    8000202a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	baa080e7          	jalr	-1110(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    80002034:	478d                	li	a5,3
    80002036:	cc9c                	sw	a5,24(s1)
  sched();
    80002038:	00000097          	auipc	ra,0x0
    8000203c:	f0a080e7          	jalr	-246(ra) # 80001f42 <sched>
  release(&p->lock);
    80002040:	8526                	mv	a0,s1
    80002042:	fffff097          	auipc	ra,0xfffff
    80002046:	c48080e7          	jalr	-952(ra) # 80000c8a <release>
}
    8000204a:	60e2                	ld	ra,24(sp)
    8000204c:	6442                	ld	s0,16(sp)
    8000204e:	64a2                	ld	s1,8(sp)
    80002050:	6105                	addi	sp,sp,32
    80002052:	8082                	ret

0000000080002054 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	addi	s0,sp,48
    80002062:	89aa                	mv	s3,a0
    80002064:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002066:	00000097          	auipc	ra,0x0
    8000206a:	946080e7          	jalr	-1722(ra) # 800019ac <myproc>
    8000206e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	b66080e7          	jalr	-1178(ra) # 80000bd6 <acquire>
  release(lk);
    80002078:	854a                	mv	a0,s2
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	c10080e7          	jalr	-1008(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80002082:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002086:	4789                	li	a5,2
    80002088:	cc9c                	sw	a5,24(s1)

  sched();
    8000208a:	00000097          	auipc	ra,0x0
    8000208e:	eb8080e7          	jalr	-328(ra) # 80001f42 <sched>

  // Tidy up.
  p->chan = 0;
    80002092:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002096:	8526                	mv	a0,s1
    80002098:	fffff097          	auipc	ra,0xfffff
    8000209c:	bf2080e7          	jalr	-1038(ra) # 80000c8a <release>
  acquire(lk);
    800020a0:	854a                	mv	a0,s2
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	b34080e7          	jalr	-1228(ra) # 80000bd6 <acquire>
}
    800020aa:	70a2                	ld	ra,40(sp)
    800020ac:	7402                	ld	s0,32(sp)
    800020ae:	64e2                	ld	s1,24(sp)
    800020b0:	6942                	ld	s2,16(sp)
    800020b2:	69a2                	ld	s3,8(sp)
    800020b4:	6145                	addi	sp,sp,48
    800020b6:	8082                	ret

00000000800020b8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020b8:	7139                	addi	sp,sp,-64
    800020ba:	fc06                	sd	ra,56(sp)
    800020bc:	f822                	sd	s0,48(sp)
    800020be:	f426                	sd	s1,40(sp)
    800020c0:	f04a                	sd	s2,32(sp)
    800020c2:	ec4e                	sd	s3,24(sp)
    800020c4:	e852                	sd	s4,16(sp)
    800020c6:	e456                	sd	s5,8(sp)
    800020c8:	0080                	addi	s0,sp,64
    800020ca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020cc:	0000f497          	auipc	s1,0xf
    800020d0:	ed448493          	addi	s1,s1,-300 # 80010fa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020d4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020d6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800020d8:	00015917          	auipc	s2,0x15
    800020dc:	0c890913          	addi	s2,s2,200 # 800171a0 <tickslock>
    800020e0:	a811                	j	800020f4 <wakeup+0x3c>
      }
      release(&p->lock);
    800020e2:	8526                	mv	a0,s1
    800020e4:	fffff097          	auipc	ra,0xfffff
    800020e8:	ba6080e7          	jalr	-1114(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800020ec:	18848493          	addi	s1,s1,392
    800020f0:	03248663          	beq	s1,s2,8000211c <wakeup+0x64>
    if(p != myproc()){
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	8b8080e7          	jalr	-1864(ra) # 800019ac <myproc>
    800020fc:	fea488e3          	beq	s1,a0,800020ec <wakeup+0x34>
      acquire(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	ad4080e7          	jalr	-1324(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000210a:	4c9c                	lw	a5,24(s1)
    8000210c:	fd379be3          	bne	a5,s3,800020e2 <wakeup+0x2a>
    80002110:	709c                	ld	a5,32(s1)
    80002112:	fd4798e3          	bne	a5,s4,800020e2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002116:	0154ac23          	sw	s5,24(s1)
    8000211a:	b7e1                	j	800020e2 <wakeup+0x2a>
    }
  }
}
    8000211c:	70e2                	ld	ra,56(sp)
    8000211e:	7442                	ld	s0,48(sp)
    80002120:	74a2                	ld	s1,40(sp)
    80002122:	7902                	ld	s2,32(sp)
    80002124:	69e2                	ld	s3,24(sp)
    80002126:	6a42                	ld	s4,16(sp)
    80002128:	6aa2                	ld	s5,8(sp)
    8000212a:	6121                	addi	sp,sp,64
    8000212c:	8082                	ret

000000008000212e <reparent>:
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	e84a                	sd	s2,16(sp)
    80002138:	e44e                	sd	s3,8(sp)
    8000213a:	e052                	sd	s4,0(sp)
    8000213c:	1800                	addi	s0,sp,48
    8000213e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002140:	0000f497          	auipc	s1,0xf
    80002144:	e6048493          	addi	s1,s1,-416 # 80010fa0 <proc>
      pp->parent = initproc;
    80002148:	00006a17          	auipc	s4,0x6
    8000214c:	7b0a0a13          	addi	s4,s4,1968 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002150:	00015997          	auipc	s3,0x15
    80002154:	05098993          	addi	s3,s3,80 # 800171a0 <tickslock>
    80002158:	a029                	j	80002162 <reparent+0x34>
    8000215a:	18848493          	addi	s1,s1,392
    8000215e:	01348d63          	beq	s1,s3,80002178 <reparent+0x4a>
    if(pp->parent == p){
    80002162:	6cbc                	ld	a5,88(s1)
    80002164:	ff279be3          	bne	a5,s2,8000215a <reparent+0x2c>
      pp->parent = initproc;
    80002168:	000a3503          	ld	a0,0(s4)
    8000216c:	eca8                	sd	a0,88(s1)
      wakeup(initproc);
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	f4a080e7          	jalr	-182(ra) # 800020b8 <wakeup>
    80002176:	b7d5                	j	8000215a <reparent+0x2c>
}
    80002178:	70a2                	ld	ra,40(sp)
    8000217a:	7402                	ld	s0,32(sp)
    8000217c:	64e2                	ld	s1,24(sp)
    8000217e:	6942                	ld	s2,16(sp)
    80002180:	69a2                	ld	s3,8(sp)
    80002182:	6a02                	ld	s4,0(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret

0000000080002188 <exit>:
{
    80002188:	7139                	addi	sp,sp,-64
    8000218a:	fc06                	sd	ra,56(sp)
    8000218c:	f822                	sd	s0,48(sp)
    8000218e:	f426                	sd	s1,40(sp)
    80002190:	f04a                	sd	s2,32(sp)
    80002192:	ec4e                	sd	s3,24(sp)
    80002194:	e852                	sd	s4,16(sp)
    80002196:	e456                	sd	s5,8(sp)
    80002198:	0080                	addi	s0,sp,64
    8000219a:	8aaa                	mv	s5,a0
    8000219c:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	80e080e7          	jalr	-2034(ra) # 800019ac <myproc>
    800021a6:	89aa                	mv	s3,a0
  if(p == initproc)
    800021a8:	00006797          	auipc	a5,0x6
    800021ac:	7507b783          	ld	a5,1872(a5) # 800088f8 <initproc>
    800021b0:	0f050493          	addi	s1,a0,240
    800021b4:	17050913          	addi	s2,a0,368
    800021b8:	02a79363          	bne	a5,a0,800021de <exit+0x56>
    panic("init exiting");
    800021bc:	00006517          	auipc	a0,0x6
    800021c0:	0a450513          	addi	a0,a0,164 # 80008260 <digits+0x220>
    800021c4:	ffffe097          	auipc	ra,0xffffe
    800021c8:	37a080e7          	jalr	890(ra) # 8000053e <panic>
      fileclose(f);
    800021cc:	00002097          	auipc	ra,0x2
    800021d0:	398080e7          	jalr	920(ra) # 80004564 <fileclose>
      p->ofile[fd] = 0;
    800021d4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021d8:	04a1                	addi	s1,s1,8
    800021da:	01248563          	beq	s1,s2,800021e4 <exit+0x5c>
    if(p->ofile[fd]){
    800021de:	6088                	ld	a0,0(s1)
    800021e0:	f575                	bnez	a0,800021cc <exit+0x44>
    800021e2:	bfdd                	j	800021d8 <exit+0x50>
  begin_op();
    800021e4:	00002097          	auipc	ra,0x2
    800021e8:	eb4080e7          	jalr	-332(ra) # 80004098 <begin_op>
  iput(p->cwd);
    800021ec:	1709b503          	ld	a0,368(s3)
    800021f0:	00001097          	auipc	ra,0x1
    800021f4:	6a0080e7          	jalr	1696(ra) # 80003890 <iput>
  end_op();
    800021f8:	00002097          	auipc	ra,0x2
    800021fc:	f20080e7          	jalr	-224(ra) # 80004118 <end_op>
  p->cwd = 0;
    80002200:	1609b823          	sd	zero,368(s3)
  acquire(&wait_lock);
    80002204:	0000f497          	auipc	s1,0xf
    80002208:	98448493          	addi	s1,s1,-1660 # 80010b88 <wait_lock>
    8000220c:	8526                	mv	a0,s1
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	9c8080e7          	jalr	-1592(ra) # 80000bd6 <acquire>
  reparent(p);
    80002216:	854e                	mv	a0,s3
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	f16080e7          	jalr	-234(ra) # 8000212e <reparent>
  wakeup(p->parent);
    80002220:	0589b503          	ld	a0,88(s3)
    80002224:	00000097          	auipc	ra,0x0
    80002228:	e94080e7          	jalr	-364(ra) # 800020b8 <wakeup>
  acquire(&p->lock);
    8000222c:	854e                	mv	a0,s3
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	9a8080e7          	jalr	-1624(ra) # 80000bd6 <acquire>
  p->xstate = status;
    80002236:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, sizeof(p->exit_msg));
    8000223a:	02000613          	li	a2,32
    8000223e:	85d2                	mv	a1,s4
    80002240:	03498513          	addi	a0,s3,52
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	bd8080e7          	jalr	-1064(ra) # 80000e1c <safestrcpy>
  p->state = ZOMBIE;
    8000224c:	4795                	li	a5,5
    8000224e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002252:	8526                	mv	a0,s1
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	a36080e7          	jalr	-1482(ra) # 80000c8a <release>
  sched();
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	ce6080e7          	jalr	-794(ra) # 80001f42 <sched>
  panic("zombie exit");
    80002264:	00006517          	auipc	a0,0x6
    80002268:	00c50513          	addi	a0,a0,12 # 80008270 <digits+0x230>
    8000226c:	ffffe097          	auipc	ra,0xffffe
    80002270:	2d2080e7          	jalr	722(ra) # 8000053e <panic>

0000000080002274 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002274:	7179                	addi	sp,sp,-48
    80002276:	f406                	sd	ra,40(sp)
    80002278:	f022                	sd	s0,32(sp)
    8000227a:	ec26                	sd	s1,24(sp)
    8000227c:	e84a                	sd	s2,16(sp)
    8000227e:	e44e                	sd	s3,8(sp)
    80002280:	1800                	addi	s0,sp,48
    80002282:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002284:	0000f497          	auipc	s1,0xf
    80002288:	d1c48493          	addi	s1,s1,-740 # 80010fa0 <proc>
    8000228c:	00015997          	auipc	s3,0x15
    80002290:	f1498993          	addi	s3,s3,-236 # 800171a0 <tickslock>
    acquire(&p->lock);
    80002294:	8526                	mv	a0,s1
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	940080e7          	jalr	-1728(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    8000229e:	589c                	lw	a5,48(s1)
    800022a0:	01278d63          	beq	a5,s2,800022ba <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	9e4080e7          	jalr	-1564(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800022ae:	18848493          	addi	s1,s1,392
    800022b2:	ff3491e3          	bne	s1,s3,80002294 <kill+0x20>
  }
  return -1;
    800022b6:	557d                	li	a0,-1
    800022b8:	a829                	j	800022d2 <kill+0x5e>
      p->killed = 1;
    800022ba:	4785                	li	a5,1
    800022bc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800022be:	4c98                	lw	a4,24(s1)
    800022c0:	4789                	li	a5,2
    800022c2:	00f70f63          	beq	a4,a5,800022e0 <kill+0x6c>
      release(&p->lock);
    800022c6:	8526                	mv	a0,s1
    800022c8:	fffff097          	auipc	ra,0xfffff
    800022cc:	9c2080e7          	jalr	-1598(ra) # 80000c8a <release>
      return 0;
    800022d0:	4501                	li	a0,0
}
    800022d2:	70a2                	ld	ra,40(sp)
    800022d4:	7402                	ld	s0,32(sp)
    800022d6:	64e2                	ld	s1,24(sp)
    800022d8:	6942                	ld	s2,16(sp)
    800022da:	69a2                	ld	s3,8(sp)
    800022dc:	6145                	addi	sp,sp,48
    800022de:	8082                	ret
        p->state = RUNNABLE;
    800022e0:	478d                	li	a5,3
    800022e2:	cc9c                	sw	a5,24(s1)
    800022e4:	b7cd                	j	800022c6 <kill+0x52>

00000000800022e6 <setkilled>:

void
setkilled(struct proc *p)
{
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	e426                	sd	s1,8(sp)
    800022ee:	1000                	addi	s0,sp,32
    800022f0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	8e4080e7          	jalr	-1820(ra) # 80000bd6 <acquire>
  p->killed = 1;
    800022fa:	4785                	li	a5,1
    800022fc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022fe:	8526                	mv	a0,s1
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	98a080e7          	jalr	-1654(ra) # 80000c8a <release>
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <killed>:

int
killed(struct proc *p)
{
    80002312:	1101                	addi	sp,sp,-32
    80002314:	ec06                	sd	ra,24(sp)
    80002316:	e822                	sd	s0,16(sp)
    80002318:	e426                	sd	s1,8(sp)
    8000231a:	e04a                	sd	s2,0(sp)
    8000231c:	1000                	addi	s0,sp,32
    8000231e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	8b6080e7          	jalr	-1866(ra) # 80000bd6 <acquire>
  k = p->killed;
    80002328:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000232c:	8526                	mv	a0,s1
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	95c080e7          	jalr	-1700(ra) # 80000c8a <release>
  return k;
}
    80002336:	854a                	mv	a0,s2
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	64a2                	ld	s1,8(sp)
    8000233e:	6902                	ld	s2,0(sp)
    80002340:	6105                	addi	sp,sp,32
    80002342:	8082                	ret

0000000080002344 <wait>:
{
    80002344:	711d                	addi	sp,sp,-96
    80002346:	ec86                	sd	ra,88(sp)
    80002348:	e8a2                	sd	s0,80(sp)
    8000234a:	e4a6                	sd	s1,72(sp)
    8000234c:	e0ca                	sd	s2,64(sp)
    8000234e:	fc4e                	sd	s3,56(sp)
    80002350:	f852                	sd	s4,48(sp)
    80002352:	f456                	sd	s5,40(sp)
    80002354:	f05a                	sd	s6,32(sp)
    80002356:	ec5e                	sd	s7,24(sp)
    80002358:	e862                	sd	s8,16(sp)
    8000235a:	e466                	sd	s9,8(sp)
    8000235c:	1080                	addi	s0,sp,96
    8000235e:	8baa                	mv	s7,a0
    80002360:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	64a080e7          	jalr	1610(ra) # 800019ac <myproc>
    8000236a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000236c:	0000f517          	auipc	a0,0xf
    80002370:	81c50513          	addi	a0,a0,-2020 # 80010b88 <wait_lock>
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	862080e7          	jalr	-1950(ra) # 80000bd6 <acquire>
    havekids = 0;
    8000237c:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    8000237e:	4a15                	li	s4,5
        havekids = 1;
    80002380:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002382:	00015997          	auipc	s3,0x15
    80002386:	e1e98993          	addi	s3,s3,-482 # 800171a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000238a:	0000ec97          	auipc	s9,0xe
    8000238e:	7fec8c93          	addi	s9,s9,2046 # 80010b88 <wait_lock>
    havekids = 0;
    80002392:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002394:	0000f497          	auipc	s1,0xf
    80002398:	c0c48493          	addi	s1,s1,-1012 # 80010fa0 <proc>
    8000239c:	a06d                	j	80002446 <wait+0x102>
          pid = pp->pid;
    8000239e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023a2:	040b9463          	bnez	s7,800023ea <wait+0xa6>
          if(addr_exitmsg != 0 && copyout(p->pagetable, addr_exitmsg, (char *)&pp->exit_msg,
    800023a6:	000b0f63          	beqz	s6,800023c4 <wait+0x80>
    800023aa:	02000693          	li	a3,32
    800023ae:	03448613          	addi	a2,s1,52
    800023b2:	85da                	mv	a1,s6
    800023b4:	07093503          	ld	a0,112(s2)
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	2b0080e7          	jalr	688(ra) # 80001668 <copyout>
    800023c0:	06054063          	bltz	a0,80002420 <wait+0xdc>
          freeproc(pp);
    800023c4:	8526                	mv	a0,s1
    800023c6:	fffff097          	auipc	ra,0xfffff
    800023ca:	798080e7          	jalr	1944(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    800023ce:	8526                	mv	a0,s1
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	8ba080e7          	jalr	-1862(ra) # 80000c8a <release>
          release(&wait_lock);
    800023d8:	0000e517          	auipc	a0,0xe
    800023dc:	7b050513          	addi	a0,a0,1968 # 80010b88 <wait_lock>
    800023e0:	fffff097          	auipc	ra,0xfffff
    800023e4:	8aa080e7          	jalr	-1878(ra) # 80000c8a <release>
          return pid;
    800023e8:	a04d                	j	8000248a <wait+0x146>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800023ea:	4691                	li	a3,4
    800023ec:	02c48613          	addi	a2,s1,44
    800023f0:	85de                	mv	a1,s7
    800023f2:	07093503          	ld	a0,112(s2)
    800023f6:	fffff097          	auipc	ra,0xfffff
    800023fa:	272080e7          	jalr	626(ra) # 80001668 <copyout>
    800023fe:	fa0554e3          	bgez	a0,800023a6 <wait+0x62>
            release(&pp->lock);
    80002402:	8526                	mv	a0,s1
    80002404:	fffff097          	auipc	ra,0xfffff
    80002408:	886080e7          	jalr	-1914(ra) # 80000c8a <release>
            release(&wait_lock);
    8000240c:	0000e517          	auipc	a0,0xe
    80002410:	77c50513          	addi	a0,a0,1916 # 80010b88 <wait_lock>
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	876080e7          	jalr	-1930(ra) # 80000c8a <release>
            return -1;
    8000241c:	59fd                	li	s3,-1
    8000241e:	a0b5                	j	8000248a <wait+0x146>
            release(&pp->lock);
    80002420:	8526                	mv	a0,s1
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	868080e7          	jalr	-1944(ra) # 80000c8a <release>
            release(&wait_lock);
    8000242a:	0000e517          	auipc	a0,0xe
    8000242e:	75e50513          	addi	a0,a0,1886 # 80010b88 <wait_lock>
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	858080e7          	jalr	-1960(ra) # 80000c8a <release>
            return -1;
    8000243a:	59fd                	li	s3,-1
    8000243c:	a0b9                	j	8000248a <wait+0x146>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000243e:	18848493          	addi	s1,s1,392
    80002442:	03348463          	beq	s1,s3,8000246a <wait+0x126>
      if(pp->parent == p){
    80002446:	6cbc                	ld	a5,88(s1)
    80002448:	ff279be3          	bne	a5,s2,8000243e <wait+0xfa>
        acquire(&pp->lock);
    8000244c:	8526                	mv	a0,s1
    8000244e:	ffffe097          	auipc	ra,0xffffe
    80002452:	788080e7          	jalr	1928(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    80002456:	4c9c                	lw	a5,24(s1)
    80002458:	f54783e3          	beq	a5,s4,8000239e <wait+0x5a>
        release(&pp->lock);
    8000245c:	8526                	mv	a0,s1
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	82c080e7          	jalr	-2004(ra) # 80000c8a <release>
        havekids = 1;
    80002466:	8756                	mv	a4,s5
    80002468:	bfd9                	j	8000243e <wait+0xfa>
    if(!havekids || killed(p)){
    8000246a:	c719                	beqz	a4,80002478 <wait+0x134>
    8000246c:	854a                	mv	a0,s2
    8000246e:	00000097          	auipc	ra,0x0
    80002472:	ea4080e7          	jalr	-348(ra) # 80002312 <killed>
    80002476:	c905                	beqz	a0,800024a6 <wait+0x162>
      release(&wait_lock);
    80002478:	0000e517          	auipc	a0,0xe
    8000247c:	71050513          	addi	a0,a0,1808 # 80010b88 <wait_lock>
    80002480:	fffff097          	auipc	ra,0xfffff
    80002484:	80a080e7          	jalr	-2038(ra) # 80000c8a <release>
      return -1;
    80002488:	59fd                	li	s3,-1
}
    8000248a:	854e                	mv	a0,s3
    8000248c:	60e6                	ld	ra,88(sp)
    8000248e:	6446                	ld	s0,80(sp)
    80002490:	64a6                	ld	s1,72(sp)
    80002492:	6906                	ld	s2,64(sp)
    80002494:	79e2                	ld	s3,56(sp)
    80002496:	7a42                	ld	s4,48(sp)
    80002498:	7aa2                	ld	s5,40(sp)
    8000249a:	7b02                	ld	s6,32(sp)
    8000249c:	6be2                	ld	s7,24(sp)
    8000249e:	6c42                	ld	s8,16(sp)
    800024a0:	6ca2                	ld	s9,8(sp)
    800024a2:	6125                	addi	sp,sp,96
    800024a4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024a6:	85e6                	mv	a1,s9
    800024a8:	854a                	mv	a0,s2
    800024aa:	00000097          	auipc	ra,0x0
    800024ae:	baa080e7          	jalr	-1110(ra) # 80002054 <sleep>
    havekids = 0;
    800024b2:	b5c5                	j	80002392 <wait+0x4e>

00000000800024b4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024b4:	7179                	addi	sp,sp,-48
    800024b6:	f406                	sd	ra,40(sp)
    800024b8:	f022                	sd	s0,32(sp)
    800024ba:	ec26                	sd	s1,24(sp)
    800024bc:	e84a                	sd	s2,16(sp)
    800024be:	e44e                	sd	s3,8(sp)
    800024c0:	e052                	sd	s4,0(sp)
    800024c2:	1800                	addi	s0,sp,48
    800024c4:	84aa                	mv	s1,a0
    800024c6:	892e                	mv	s2,a1
    800024c8:	89b2                	mv	s3,a2
    800024ca:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024cc:	fffff097          	auipc	ra,0xfffff
    800024d0:	4e0080e7          	jalr	1248(ra) # 800019ac <myproc>
  if(user_dst){
    800024d4:	c08d                	beqz	s1,800024f6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024d6:	86d2                	mv	a3,s4
    800024d8:	864e                	mv	a2,s3
    800024da:	85ca                	mv	a1,s2
    800024dc:	7928                	ld	a0,112(a0)
    800024de:	fffff097          	auipc	ra,0xfffff
    800024e2:	18a080e7          	jalr	394(ra) # 80001668 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024e6:	70a2                	ld	ra,40(sp)
    800024e8:	7402                	ld	s0,32(sp)
    800024ea:	64e2                	ld	s1,24(sp)
    800024ec:	6942                	ld	s2,16(sp)
    800024ee:	69a2                	ld	s3,8(sp)
    800024f0:	6a02                	ld	s4,0(sp)
    800024f2:	6145                	addi	sp,sp,48
    800024f4:	8082                	ret
    memmove((char *)dst, src, len);
    800024f6:	000a061b          	sext.w	a2,s4
    800024fa:	85ce                	mv	a1,s3
    800024fc:	854a                	mv	a0,s2
    800024fe:	fffff097          	auipc	ra,0xfffff
    80002502:	830080e7          	jalr	-2000(ra) # 80000d2e <memmove>
    return 0;
    80002506:	8526                	mv	a0,s1
    80002508:	bff9                	j	800024e6 <either_copyout+0x32>

000000008000250a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000250a:	7179                	addi	sp,sp,-48
    8000250c:	f406                	sd	ra,40(sp)
    8000250e:	f022                	sd	s0,32(sp)
    80002510:	ec26                	sd	s1,24(sp)
    80002512:	e84a                	sd	s2,16(sp)
    80002514:	e44e                	sd	s3,8(sp)
    80002516:	e052                	sd	s4,0(sp)
    80002518:	1800                	addi	s0,sp,48
    8000251a:	892a                	mv	s2,a0
    8000251c:	84ae                	mv	s1,a1
    8000251e:	89b2                	mv	s3,a2
    80002520:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002522:	fffff097          	auipc	ra,0xfffff
    80002526:	48a080e7          	jalr	1162(ra) # 800019ac <myproc>
  if(user_src){
    8000252a:	c08d                	beqz	s1,8000254c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000252c:	86d2                	mv	a3,s4
    8000252e:	864e                	mv	a2,s3
    80002530:	85ca                	mv	a1,s2
    80002532:	7928                	ld	a0,112(a0)
    80002534:	fffff097          	auipc	ra,0xfffff
    80002538:	1c0080e7          	jalr	448(ra) # 800016f4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6a02                	ld	s4,0(sp)
    80002548:	6145                	addi	sp,sp,48
    8000254a:	8082                	ret
    memmove(dst, (char*)src, len);
    8000254c:	000a061b          	sext.w	a2,s4
    80002550:	85ce                	mv	a1,s3
    80002552:	854a                	mv	a0,s2
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	7da080e7          	jalr	2010(ra) # 80000d2e <memmove>
    return 0;
    8000255c:	8526                	mv	a0,s1
    8000255e:	bff9                	j	8000253c <either_copyin+0x32>

0000000080002560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002560:	715d                	addi	sp,sp,-80
    80002562:	e486                	sd	ra,72(sp)
    80002564:	e0a2                	sd	s0,64(sp)
    80002566:	fc26                	sd	s1,56(sp)
    80002568:	f84a                	sd	s2,48(sp)
    8000256a:	f44e                	sd	s3,40(sp)
    8000256c:	f052                	sd	s4,32(sp)
    8000256e:	ec56                	sd	s5,24(sp)
    80002570:	e85a                	sd	s6,16(sp)
    80002572:	e45e                	sd	s7,8(sp)
    80002574:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002576:	00006517          	auipc	a0,0x6
    8000257a:	b5250513          	addi	a0,a0,-1198 # 800080c8 <digits+0x88>
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	00a080e7          	jalr	10(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002586:	0000f497          	auipc	s1,0xf
    8000258a:	b9248493          	addi	s1,s1,-1134 # 80011118 <proc+0x178>
    8000258e:	00015917          	auipc	s2,0x15
    80002592:	d8a90913          	addi	s2,s2,-630 # 80017318 <bcache+0x160>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002596:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002598:	00006997          	auipc	s3,0x6
    8000259c:	ce898993          	addi	s3,s3,-792 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800025a0:	00006a97          	auipc	s5,0x6
    800025a4:	ce8a8a93          	addi	s5,s5,-792 # 80008288 <digits+0x248>
    printf("\n");
    800025a8:	00006a17          	auipc	s4,0x6
    800025ac:	b20a0a13          	addi	s4,s4,-1248 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025b0:	00006b97          	auipc	s7,0x6
    800025b4:	d18b8b93          	addi	s7,s7,-744 # 800082c8 <states.0>
    800025b8:	a00d                	j	800025da <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800025ba:	eb86a583          	lw	a1,-328(a3)
    800025be:	8556                	mv	a0,s5
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	fc8080e7          	jalr	-56(ra) # 80000588 <printf>
    printf("\n");
    800025c8:	8552                	mv	a0,s4
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	fbe080e7          	jalr	-66(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025d2:	18848493          	addi	s1,s1,392
    800025d6:	03248163          	beq	s1,s2,800025f8 <procdump+0x98>
    if(p->state == UNUSED)
    800025da:	86a6                	mv	a3,s1
    800025dc:	ea04a783          	lw	a5,-352(s1)
    800025e0:	dbed                	beqz	a5,800025d2 <procdump+0x72>
      state = "???";
    800025e2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025e4:	fcfb6be3          	bltu	s6,a5,800025ba <procdump+0x5a>
    800025e8:	1782                	slli	a5,a5,0x20
    800025ea:	9381                	srli	a5,a5,0x20
    800025ec:	078e                	slli	a5,a5,0x3
    800025ee:	97de                	add	a5,a5,s7
    800025f0:	6390                	ld	a2,0(a5)
    800025f2:	f661                	bnez	a2,800025ba <procdump+0x5a>
      state = "???";
    800025f4:	864e                	mv	a2,s3
    800025f6:	b7d1                	j	800025ba <procdump+0x5a>
  }
}
    800025f8:	60a6                	ld	ra,72(sp)
    800025fa:	6406                	ld	s0,64(sp)
    800025fc:	74e2                	ld	s1,56(sp)
    800025fe:	7942                	ld	s2,48(sp)
    80002600:	79a2                	ld	s3,40(sp)
    80002602:	7a02                	ld	s4,32(sp)
    80002604:	6ae2                	ld	s5,24(sp)
    80002606:	6b42                	ld	s6,16(sp)
    80002608:	6ba2                	ld	s7,8(sp)
    8000260a:	6161                	addi	sp,sp,80
    8000260c:	8082                	ret

000000008000260e <swtch>:
    8000260e:	00153023          	sd	ra,0(a0)
    80002612:	00253423          	sd	sp,8(a0)
    80002616:	e900                	sd	s0,16(a0)
    80002618:	ed04                	sd	s1,24(a0)
    8000261a:	03253023          	sd	s2,32(a0)
    8000261e:	03353423          	sd	s3,40(a0)
    80002622:	03453823          	sd	s4,48(a0)
    80002626:	03553c23          	sd	s5,56(a0)
    8000262a:	05653023          	sd	s6,64(a0)
    8000262e:	05753423          	sd	s7,72(a0)
    80002632:	05853823          	sd	s8,80(a0)
    80002636:	05953c23          	sd	s9,88(a0)
    8000263a:	07a53023          	sd	s10,96(a0)
    8000263e:	07b53423          	sd	s11,104(a0)
    80002642:	0005b083          	ld	ra,0(a1)
    80002646:	0085b103          	ld	sp,8(a1)
    8000264a:	6980                	ld	s0,16(a1)
    8000264c:	6d84                	ld	s1,24(a1)
    8000264e:	0205b903          	ld	s2,32(a1)
    80002652:	0285b983          	ld	s3,40(a1)
    80002656:	0305ba03          	ld	s4,48(a1)
    8000265a:	0385ba83          	ld	s5,56(a1)
    8000265e:	0405bb03          	ld	s6,64(a1)
    80002662:	0485bb83          	ld	s7,72(a1)
    80002666:	0505bc03          	ld	s8,80(a1)
    8000266a:	0585bc83          	ld	s9,88(a1)
    8000266e:	0605bd03          	ld	s10,96(a1)
    80002672:	0685bd83          	ld	s11,104(a1)
    80002676:	8082                	ret

0000000080002678 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002678:	1141                	addi	sp,sp,-16
    8000267a:	e406                	sd	ra,8(sp)
    8000267c:	e022                	sd	s0,0(sp)
    8000267e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002680:	00006597          	auipc	a1,0x6
    80002684:	c7858593          	addi	a1,a1,-904 # 800082f8 <states.0+0x30>
    80002688:	00015517          	auipc	a0,0x15
    8000268c:	b1850513          	addi	a0,a0,-1256 # 800171a0 <tickslock>
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	4b6080e7          	jalr	1206(ra) # 80000b46 <initlock>
}
    80002698:	60a2                	ld	ra,8(sp)
    8000269a:	6402                	ld	s0,0(sp)
    8000269c:	0141                	addi	sp,sp,16
    8000269e:	8082                	ret

00000000800026a0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026a0:	1141                	addi	sp,sp,-16
    800026a2:	e422                	sd	s0,8(sp)
    800026a4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026a6:	00003797          	auipc	a5,0x3
    800026aa:	50a78793          	addi	a5,a5,1290 # 80005bb0 <kernelvec>
    800026ae:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026b2:	6422                	ld	s0,8(sp)
    800026b4:	0141                	addi	sp,sp,16
    800026b6:	8082                	ret

00000000800026b8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026b8:	1141                	addi	sp,sp,-16
    800026ba:	e406                	sd	ra,8(sp)
    800026bc:	e022                	sd	s0,0(sp)
    800026be:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026c0:	fffff097          	auipc	ra,0xfffff
    800026c4:	2ec080e7          	jalr	748(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026ce:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800026d2:	00005617          	auipc	a2,0x5
    800026d6:	92e60613          	addi	a2,a2,-1746 # 80007000 <_trampoline>
    800026da:	00005697          	auipc	a3,0x5
    800026de:	92668693          	addi	a3,a3,-1754 # 80007000 <_trampoline>
    800026e2:	8e91                	sub	a3,a3,a2
    800026e4:	040007b7          	lui	a5,0x4000
    800026e8:	17fd                	addi	a5,a5,-1
    800026ea:	07b2                	slli	a5,a5,0xc
    800026ec:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026ee:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800026f2:	7d38                	ld	a4,120(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800026f4:	180026f3          	csrr	a3,satp
    800026f8:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800026fa:	7d38                	ld	a4,120(a0)
    800026fc:	7134                	ld	a3,96(a0)
    800026fe:	6585                	lui	a1,0x1
    80002700:	96ae                	add	a3,a3,a1
    80002702:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002704:	7d38                	ld	a4,120(a0)
    80002706:	00000697          	auipc	a3,0x0
    8000270a:	13068693          	addi	a3,a3,304 # 80002836 <usertrap>
    8000270e:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002710:	7d38                	ld	a4,120(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002712:	8692                	mv	a3,tp
    80002714:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002716:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000271a:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000271e:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002722:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002726:	7d38                	ld	a4,120(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002728:	6f18                	ld	a4,24(a4)
    8000272a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    8000272e:	7928                	ld	a0,112(a0)
    80002730:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002732:	00005717          	auipc	a4,0x5
    80002736:	96a70713          	addi	a4,a4,-1686 # 8000709c <userret>
    8000273a:	8f11                	sub	a4,a4,a2
    8000273c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000273e:	577d                	li	a4,-1
    80002740:	177e                	slli	a4,a4,0x3f
    80002742:	8d59                	or	a0,a0,a4
    80002744:	9782                	jalr	a5
}
    80002746:	60a2                	ld	ra,8(sp)
    80002748:	6402                	ld	s0,0(sp)
    8000274a:	0141                	addi	sp,sp,16
    8000274c:	8082                	ret

000000008000274e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002758:	00015497          	auipc	s1,0x15
    8000275c:	a4848493          	addi	s1,s1,-1464 # 800171a0 <tickslock>
    80002760:	8526                	mv	a0,s1
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	474080e7          	jalr	1140(ra) # 80000bd6 <acquire>
  ticks++;
    8000276a:	00006517          	auipc	a0,0x6
    8000276e:	19650513          	addi	a0,a0,406 # 80008900 <ticks>
    80002772:	411c                	lw	a5,0(a0)
    80002774:	2785                	addiw	a5,a5,1
    80002776:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	940080e7          	jalr	-1728(ra) # 800020b8 <wakeup>
  release(&tickslock);
    80002780:	8526                	mv	a0,s1
    80002782:	ffffe097          	auipc	ra,0xffffe
    80002786:	508080e7          	jalr	1288(ra) # 80000c8a <release>
}
    8000278a:	60e2                	ld	ra,24(sp)
    8000278c:	6442                	ld	s0,16(sp)
    8000278e:	64a2                	ld	s1,8(sp)
    80002790:	6105                	addi	sp,sp,32
    80002792:	8082                	ret

0000000080002794 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002794:	1101                	addi	sp,sp,-32
    80002796:	ec06                	sd	ra,24(sp)
    80002798:	e822                	sd	s0,16(sp)
    8000279a:	e426                	sd	s1,8(sp)
    8000279c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000279e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027a2:	00074d63          	bltz	a4,800027bc <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027a6:	57fd                	li	a5,-1
    800027a8:	17fe                	slli	a5,a5,0x3f
    800027aa:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027ac:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027ae:	06f70363          	beq	a4,a5,80002814 <devintr+0x80>
  }
}
    800027b2:	60e2                	ld	ra,24(sp)
    800027b4:	6442                	ld	s0,16(sp)
    800027b6:	64a2                	ld	s1,8(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
     (scause & 0xff) == 9){
    800027bc:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027c0:	46a5                	li	a3,9
    800027c2:	fed792e3          	bne	a5,a3,800027a6 <devintr+0x12>
    int irq = plic_claim();
    800027c6:	00003097          	auipc	ra,0x3
    800027ca:	4f2080e7          	jalr	1266(ra) # 80005cb8 <plic_claim>
    800027ce:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027d0:	47a9                	li	a5,10
    800027d2:	02f50763          	beq	a0,a5,80002800 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027d6:	4785                	li	a5,1
    800027d8:	02f50963          	beq	a0,a5,8000280a <devintr+0x76>
    return 1;
    800027dc:	4505                	li	a0,1
    } else if(irq){
    800027de:	d8f1                	beqz	s1,800027b2 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800027e0:	85a6                	mv	a1,s1
    800027e2:	00006517          	auipc	a0,0x6
    800027e6:	b1e50513          	addi	a0,a0,-1250 # 80008300 <states.0+0x38>
    800027ea:	ffffe097          	auipc	ra,0xffffe
    800027ee:	d9e080e7          	jalr	-610(ra) # 80000588 <printf>
      plic_complete(irq);
    800027f2:	8526                	mv	a0,s1
    800027f4:	00003097          	auipc	ra,0x3
    800027f8:	4e8080e7          	jalr	1256(ra) # 80005cdc <plic_complete>
    return 1;
    800027fc:	4505                	li	a0,1
    800027fe:	bf55                	j	800027b2 <devintr+0x1e>
      uartintr();
    80002800:	ffffe097          	auipc	ra,0xffffe
    80002804:	19a080e7          	jalr	410(ra) # 8000099a <uartintr>
    80002808:	b7ed                	j	800027f2 <devintr+0x5e>
      virtio_disk_intr();
    8000280a:	00004097          	auipc	ra,0x4
    8000280e:	99e080e7          	jalr	-1634(ra) # 800061a8 <virtio_disk_intr>
    80002812:	b7c5                	j	800027f2 <devintr+0x5e>
    if(cpuid() == 0){
    80002814:	fffff097          	auipc	ra,0xfffff
    80002818:	16c080e7          	jalr	364(ra) # 80001980 <cpuid>
    8000281c:	c901                	beqz	a0,8000282c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000281e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002822:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002824:	14479073          	csrw	sip,a5
    return 2;
    80002828:	4509                	li	a0,2
    8000282a:	b761                	j	800027b2 <devintr+0x1e>
      clockintr();
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	f22080e7          	jalr	-222(ra) # 8000274e <clockintr>
    80002834:	b7ed                	j	8000281e <devintr+0x8a>

0000000080002836 <usertrap>:
{
    80002836:	1101                	addi	sp,sp,-32
    80002838:	ec06                	sd	ra,24(sp)
    8000283a:	e822                	sd	s0,16(sp)
    8000283c:	e426                	sd	s1,8(sp)
    8000283e:	e04a                	sd	s2,0(sp)
    80002840:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002842:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002846:	1007f793          	andi	a5,a5,256
    8000284a:	e3b1                	bnez	a5,8000288e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000284c:	00003797          	auipc	a5,0x3
    80002850:	36478793          	addi	a5,a5,868 # 80005bb0 <kernelvec>
    80002854:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002858:	fffff097          	auipc	ra,0xfffff
    8000285c:	154080e7          	jalr	340(ra) # 800019ac <myproc>
    80002860:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002862:	7d3c                	ld	a5,120(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002864:	14102773          	csrr	a4,sepc
    80002868:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000286a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000286e:	47a1                	li	a5,8
    80002870:	02f70763          	beq	a4,a5,8000289e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002874:	00000097          	auipc	ra,0x0
    80002878:	f20080e7          	jalr	-224(ra) # 80002794 <devintr>
    8000287c:	892a                	mv	s2,a0
    8000287e:	c951                	beqz	a0,80002912 <usertrap+0xdc>
  if(killed(p))
    80002880:	8526                	mv	a0,s1
    80002882:	00000097          	auipc	ra,0x0
    80002886:	a90080e7          	jalr	-1392(ra) # 80002312 <killed>
    8000288a:	cd29                	beqz	a0,800028e4 <usertrap+0xae>
    8000288c:	a099                	j	800028d2 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	a9250513          	addi	a0,a0,-1390 # 80008320 <states.0+0x58>
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	ca8080e7          	jalr	-856(ra) # 8000053e <panic>
    if(killed(p))
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	a74080e7          	jalr	-1420(ra) # 80002312 <killed>
    800028a6:	ed21                	bnez	a0,800028fe <usertrap+0xc8>
    p->trapframe->epc += 4;
    800028a8:	7cb8                	ld	a4,120(s1)
    800028aa:	6f1c                	ld	a5,24(a4)
    800028ac:	0791                	addi	a5,a5,4
    800028ae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028b4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028b8:	10079073          	csrw	sstatus,a5
    syscall();
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	2e4080e7          	jalr	740(ra) # 80002ba0 <syscall>
  if(killed(p))
    800028c4:	8526                	mv	a0,s1
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	a4c080e7          	jalr	-1460(ra) # 80002312 <killed>
    800028ce:	cd11                	beqz	a0,800028ea <usertrap+0xb4>
    800028d0:	4901                	li	s2,0
    exit(-1, "killed");
    800028d2:	00006597          	auipc	a1,0x6
    800028d6:	ac658593          	addi	a1,a1,-1338 # 80008398 <states.0+0xd0>
    800028da:	557d                	li	a0,-1
    800028dc:	00000097          	auipc	ra,0x0
    800028e0:	8ac080e7          	jalr	-1876(ra) # 80002188 <exit>
  if(which_dev == 2)
    800028e4:	4789                	li	a5,2
    800028e6:	06f90363          	beq	s2,a5,8000294c <usertrap+0x116>
  usertrapret();
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	dce080e7          	jalr	-562(ra) # 800026b8 <usertrapret>
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	64a2                	ld	s1,8(sp)
    800028f8:	6902                	ld	s2,0(sp)
    800028fa:	6105                	addi	sp,sp,32
    800028fc:	8082                	ret
      exit(-1 , "killed ");
    800028fe:	00006597          	auipc	a1,0x6
    80002902:	a4258593          	addi	a1,a1,-1470 # 80008340 <states.0+0x78>
    80002906:	557d                	li	a0,-1
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	880080e7          	jalr	-1920(ra) # 80002188 <exit>
    80002910:	bf61                	j	800028a8 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002912:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002916:	5890                	lw	a2,48(s1)
    80002918:	00006517          	auipc	a0,0x6
    8000291c:	a3050513          	addi	a0,a0,-1488 # 80008348 <states.0+0x80>
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	c68080e7          	jalr	-920(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002928:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000292c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002930:	00006517          	auipc	a0,0x6
    80002934:	a4850513          	addi	a0,a0,-1464 # 80008378 <states.0+0xb0>
    80002938:	ffffe097          	auipc	ra,0xffffe
    8000293c:	c50080e7          	jalr	-944(ra) # 80000588 <printf>
    setkilled(p);
    80002940:	8526                	mv	a0,s1
    80002942:	00000097          	auipc	ra,0x0
    80002946:	9a4080e7          	jalr	-1628(ra) # 800022e6 <setkilled>
    8000294a:	bfad                	j	800028c4 <usertrap+0x8e>
    yield();
    8000294c:	fffff097          	auipc	ra,0xfffff
    80002950:	6cc080e7          	jalr	1740(ra) # 80002018 <yield>
    80002954:	bf59                	j	800028ea <usertrap+0xb4>

0000000080002956 <kerneltrap>:
{
    80002956:	7179                	addi	sp,sp,-48
    80002958:	f406                	sd	ra,40(sp)
    8000295a:	f022                	sd	s0,32(sp)
    8000295c:	ec26                	sd	s1,24(sp)
    8000295e:	e84a                	sd	s2,16(sp)
    80002960:	e44e                	sd	s3,8(sp)
    80002962:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002964:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002968:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000296c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002970:	1004f793          	andi	a5,s1,256
    80002974:	cb85                	beqz	a5,800029a4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002976:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000297a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000297c:	ef85                	bnez	a5,800029b4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	e16080e7          	jalr	-490(ra) # 80002794 <devintr>
    80002986:	cd1d                	beqz	a0,800029c4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002988:	4789                	li	a5,2
    8000298a:	06f50a63          	beq	a0,a5,800029fe <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000298e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002992:	10049073          	csrw	sstatus,s1
}
    80002996:	70a2                	ld	ra,40(sp)
    80002998:	7402                	ld	s0,32(sp)
    8000299a:	64e2                	ld	s1,24(sp)
    8000299c:	6942                	ld	s2,16(sp)
    8000299e:	69a2                	ld	s3,8(sp)
    800029a0:	6145                	addi	sp,sp,48
    800029a2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800029a4:	00006517          	auipc	a0,0x6
    800029a8:	9fc50513          	addi	a0,a0,-1540 # 800083a0 <states.0+0xd8>
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	b92080e7          	jalr	-1134(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    800029b4:	00006517          	auipc	a0,0x6
    800029b8:	a1450513          	addi	a0,a0,-1516 # 800083c8 <states.0+0x100>
    800029bc:	ffffe097          	auipc	ra,0xffffe
    800029c0:	b82080e7          	jalr	-1150(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    800029c4:	85ce                	mv	a1,s3
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	a2250513          	addi	a0,a0,-1502 # 800083e8 <states.0+0x120>
    800029ce:	ffffe097          	auipc	ra,0xffffe
    800029d2:	bba080e7          	jalr	-1094(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029d6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029da:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029de:	00006517          	auipc	a0,0x6
    800029e2:	a1a50513          	addi	a0,a0,-1510 # 800083f8 <states.0+0x130>
    800029e6:	ffffe097          	auipc	ra,0xffffe
    800029ea:	ba2080e7          	jalr	-1118(ra) # 80000588 <printf>
    panic("kerneltrap");
    800029ee:	00006517          	auipc	a0,0x6
    800029f2:	a2250513          	addi	a0,a0,-1502 # 80008410 <states.0+0x148>
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	b48080e7          	jalr	-1208(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029fe:	fffff097          	auipc	ra,0xfffff
    80002a02:	fae080e7          	jalr	-82(ra) # 800019ac <myproc>
    80002a06:	d541                	beqz	a0,8000298e <kerneltrap+0x38>
    80002a08:	fffff097          	auipc	ra,0xfffff
    80002a0c:	fa4080e7          	jalr	-92(ra) # 800019ac <myproc>
    80002a10:	4d18                	lw	a4,24(a0)
    80002a12:	4791                	li	a5,4
    80002a14:	f6f71de3          	bne	a4,a5,8000298e <kerneltrap+0x38>
    yield();
    80002a18:	fffff097          	auipc	ra,0xfffff
    80002a1c:	600080e7          	jalr	1536(ra) # 80002018 <yield>
    80002a20:	b7bd                	j	8000298e <kerneltrap+0x38>

0000000080002a22 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a22:	1101                	addi	sp,sp,-32
    80002a24:	ec06                	sd	ra,24(sp)
    80002a26:	e822                	sd	s0,16(sp)
    80002a28:	e426                	sd	s1,8(sp)
    80002a2a:	1000                	addi	s0,sp,32
    80002a2c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a2e:	fffff097          	auipc	ra,0xfffff
    80002a32:	f7e080e7          	jalr	-130(ra) # 800019ac <myproc>
  switch (n) {
    80002a36:	4795                	li	a5,5
    80002a38:	0497e163          	bltu	a5,s1,80002a7a <argraw+0x58>
    80002a3c:	048a                	slli	s1,s1,0x2
    80002a3e:	00006717          	auipc	a4,0x6
    80002a42:	a0a70713          	addi	a4,a4,-1526 # 80008448 <states.0+0x180>
    80002a46:	94ba                	add	s1,s1,a4
    80002a48:	409c                	lw	a5,0(s1)
    80002a4a:	97ba                	add	a5,a5,a4
    80002a4c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a4e:	7d3c                	ld	a5,120(a0)
    80002a50:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a52:	60e2                	ld	ra,24(sp)
    80002a54:	6442                	ld	s0,16(sp)
    80002a56:	64a2                	ld	s1,8(sp)
    80002a58:	6105                	addi	sp,sp,32
    80002a5a:	8082                	ret
    return p->trapframe->a1;
    80002a5c:	7d3c                	ld	a5,120(a0)
    80002a5e:	7fa8                	ld	a0,120(a5)
    80002a60:	bfcd                	j	80002a52 <argraw+0x30>
    return p->trapframe->a2;
    80002a62:	7d3c                	ld	a5,120(a0)
    80002a64:	63c8                	ld	a0,128(a5)
    80002a66:	b7f5                	j	80002a52 <argraw+0x30>
    return p->trapframe->a3;
    80002a68:	7d3c                	ld	a5,120(a0)
    80002a6a:	67c8                	ld	a0,136(a5)
    80002a6c:	b7dd                	j	80002a52 <argraw+0x30>
    return p->trapframe->a4;
    80002a6e:	7d3c                	ld	a5,120(a0)
    80002a70:	6bc8                	ld	a0,144(a5)
    80002a72:	b7c5                	j	80002a52 <argraw+0x30>
    return p->trapframe->a5;
    80002a74:	7d3c                	ld	a5,120(a0)
    80002a76:	6fc8                	ld	a0,152(a5)
    80002a78:	bfe9                	j	80002a52 <argraw+0x30>
  panic("argraw");
    80002a7a:	00006517          	auipc	a0,0x6
    80002a7e:	9a650513          	addi	a0,a0,-1626 # 80008420 <states.0+0x158>
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	abc080e7          	jalr	-1348(ra) # 8000053e <panic>

0000000080002a8a <fetchaddr>:
{
    80002a8a:	1101                	addi	sp,sp,-32
    80002a8c:	ec06                	sd	ra,24(sp)
    80002a8e:	e822                	sd	s0,16(sp)
    80002a90:	e426                	sd	s1,8(sp)
    80002a92:	e04a                	sd	s2,0(sp)
    80002a94:	1000                	addi	s0,sp,32
    80002a96:	84aa                	mv	s1,a0
    80002a98:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a9a:	fffff097          	auipc	ra,0xfffff
    80002a9e:	f12080e7          	jalr	-238(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002aa2:	753c                	ld	a5,104(a0)
    80002aa4:	02f4f863          	bgeu	s1,a5,80002ad4 <fetchaddr+0x4a>
    80002aa8:	00848713          	addi	a4,s1,8
    80002aac:	02e7e663          	bltu	a5,a4,80002ad8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ab0:	46a1                	li	a3,8
    80002ab2:	8626                	mv	a2,s1
    80002ab4:	85ca                	mv	a1,s2
    80002ab6:	7928                	ld	a0,112(a0)
    80002ab8:	fffff097          	auipc	ra,0xfffff
    80002abc:	c3c080e7          	jalr	-964(ra) # 800016f4 <copyin>
    80002ac0:	00a03533          	snez	a0,a0
    80002ac4:	40a00533          	neg	a0,a0
}
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6902                	ld	s2,0(sp)
    80002ad0:	6105                	addi	sp,sp,32
    80002ad2:	8082                	ret
    return -1;
    80002ad4:	557d                	li	a0,-1
    80002ad6:	bfcd                	j	80002ac8 <fetchaddr+0x3e>
    80002ad8:	557d                	li	a0,-1
    80002ada:	b7fd                	j	80002ac8 <fetchaddr+0x3e>

0000000080002adc <fetchstr>:
{
    80002adc:	7179                	addi	sp,sp,-48
    80002ade:	f406                	sd	ra,40(sp)
    80002ae0:	f022                	sd	s0,32(sp)
    80002ae2:	ec26                	sd	s1,24(sp)
    80002ae4:	e84a                	sd	s2,16(sp)
    80002ae6:	e44e                	sd	s3,8(sp)
    80002ae8:	1800                	addi	s0,sp,48
    80002aea:	892a                	mv	s2,a0
    80002aec:	84ae                	mv	s1,a1
    80002aee:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002af0:	fffff097          	auipc	ra,0xfffff
    80002af4:	ebc080e7          	jalr	-324(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002af8:	86ce                	mv	a3,s3
    80002afa:	864a                	mv	a2,s2
    80002afc:	85a6                	mv	a1,s1
    80002afe:	7928                	ld	a0,112(a0)
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	c82080e7          	jalr	-894(ra) # 80001782 <copyinstr>
    80002b08:	00054e63          	bltz	a0,80002b24 <fetchstr+0x48>
  return strlen(buf);
    80002b0c:	8526                	mv	a0,s1
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	340080e7          	jalr	832(ra) # 80000e4e <strlen>
}
    80002b16:	70a2                	ld	ra,40(sp)
    80002b18:	7402                	ld	s0,32(sp)
    80002b1a:	64e2                	ld	s1,24(sp)
    80002b1c:	6942                	ld	s2,16(sp)
    80002b1e:	69a2                	ld	s3,8(sp)
    80002b20:	6145                	addi	sp,sp,48
    80002b22:	8082                	ret
    return -1;
    80002b24:	557d                	li	a0,-1
    80002b26:	bfc5                	j	80002b16 <fetchstr+0x3a>

0000000080002b28 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	1000                	addi	s0,sp,32
    80002b32:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b34:	00000097          	auipc	ra,0x0
    80002b38:	eee080e7          	jalr	-274(ra) # 80002a22 <argraw>
    80002b3c:	c088                	sw	a0,0(s1)
}
    80002b3e:	60e2                	ld	ra,24(sp)
    80002b40:	6442                	ld	s0,16(sp)
    80002b42:	64a2                	ld	s1,8(sp)
    80002b44:	6105                	addi	sp,sp,32
    80002b46:	8082                	ret

0000000080002b48 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002b48:	1101                	addi	sp,sp,-32
    80002b4a:	ec06                	sd	ra,24(sp)
    80002b4c:	e822                	sd	s0,16(sp)
    80002b4e:	e426                	sd	s1,8(sp)
    80002b50:	1000                	addi	s0,sp,32
    80002b52:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	ece080e7          	jalr	-306(ra) # 80002a22 <argraw>
    80002b5c:	e088                	sd	a0,0(s1)
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret

0000000080002b68 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b68:	7179                	addi	sp,sp,-48
    80002b6a:	f406                	sd	ra,40(sp)
    80002b6c:	f022                	sd	s0,32(sp)
    80002b6e:	ec26                	sd	s1,24(sp)
    80002b70:	e84a                	sd	s2,16(sp)
    80002b72:	1800                	addi	s0,sp,48
    80002b74:	84ae                	mv	s1,a1
    80002b76:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002b78:	fd840593          	addi	a1,s0,-40
    80002b7c:	00000097          	auipc	ra,0x0
    80002b80:	fcc080e7          	jalr	-52(ra) # 80002b48 <argaddr>
  return fetchstr(addr, buf, max);
    80002b84:	864a                	mv	a2,s2
    80002b86:	85a6                	mv	a1,s1
    80002b88:	fd843503          	ld	a0,-40(s0)
    80002b8c:	00000097          	auipc	ra,0x0
    80002b90:	f50080e7          	jalr	-176(ra) # 80002adc <fetchstr>
}
    80002b94:	70a2                	ld	ra,40(sp)
    80002b96:	7402                	ld	s0,32(sp)
    80002b98:	64e2                	ld	s1,24(sp)
    80002b9a:	6942                	ld	s2,16(sp)
    80002b9c:	6145                	addi	sp,sp,48
    80002b9e:	8082                	ret

0000000080002ba0 <syscall>:

};

void
syscall(void)
{
    80002ba0:	1101                	addi	sp,sp,-32
    80002ba2:	ec06                	sd	ra,24(sp)
    80002ba4:	e822                	sd	s0,16(sp)
    80002ba6:	e426                	sd	s1,8(sp)
    80002ba8:	e04a                	sd	s2,0(sp)
    80002baa:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bac:	fffff097          	auipc	ra,0xfffff
    80002bb0:	e00080e7          	jalr	-512(ra) # 800019ac <myproc>
    80002bb4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bb6:	07853903          	ld	s2,120(a0)
    80002bba:	0a893783          	ld	a5,168(s2)
    80002bbe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002bc2:	37fd                	addiw	a5,a5,-1
    80002bc4:	4755                	li	a4,21
    80002bc6:	00f76f63          	bltu	a4,a5,80002be4 <syscall+0x44>
    80002bca:	00369713          	slli	a4,a3,0x3
    80002bce:	00006797          	auipc	a5,0x6
    80002bd2:	89278793          	addi	a5,a5,-1902 # 80008460 <syscalls>
    80002bd6:	97ba                	add	a5,a5,a4
    80002bd8:	639c                	ld	a5,0(a5)
    80002bda:	c789                	beqz	a5,80002be4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002bdc:	9782                	jalr	a5
    80002bde:	06a93823          	sd	a0,112(s2)
    80002be2:	a839                	j	80002c00 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002be4:	17848613          	addi	a2,s1,376
    80002be8:	588c                	lw	a1,48(s1)
    80002bea:	00006517          	auipc	a0,0x6
    80002bee:	83e50513          	addi	a0,a0,-1986 # 80008428 <states.0+0x160>
    80002bf2:	ffffe097          	auipc	ra,0xffffe
    80002bf6:	996080e7          	jalr	-1642(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002bfa:	7cbc                	ld	a5,120(s1)
    80002bfc:	577d                	li	a4,-1
    80002bfe:	fbb8                	sd	a4,112(a5)
  }
}
    80002c00:	60e2                	ld	ra,24(sp)
    80002c02:	6442                	ld	s0,16(sp)
    80002c04:	64a2                	ld	s1,8(sp)
    80002c06:	6902                	ld	s2,0(sp)
    80002c08:	6105                	addi	sp,sp,32
    80002c0a:	8082                	ret

0000000080002c0c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c0c:	7139                	addi	sp,sp,-64
    80002c0e:	fc06                	sd	ra,56(sp)
    80002c10:	f822                	sd	s0,48(sp)
    80002c12:	0080                	addi	s0,sp,64
  int n;
  char exit_msg[32];
  argint(0, &n);
    80002c14:	fec40593          	addi	a1,s0,-20
    80002c18:	4501                	li	a0,0
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	f0e080e7          	jalr	-242(ra) # 80002b28 <argint>
  argstr(1, exit_msg, MAXARG);
    80002c22:	02000613          	li	a2,32
    80002c26:	fc840593          	addi	a1,s0,-56
    80002c2a:	4505                	li	a0,1
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	f3c080e7          	jalr	-196(ra) # 80002b68 <argstr>
  exit(n,exit_msg);
    80002c34:	fc840593          	addi	a1,s0,-56
    80002c38:	fec42503          	lw	a0,-20(s0)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	54c080e7          	jalr	1356(ra) # 80002188 <exit>
  return 0;  // not reached
}
    80002c44:	4501                	li	a0,0
    80002c46:	70e2                	ld	ra,56(sp)
    80002c48:	7442                	ld	s0,48(sp)
    80002c4a:	6121                	addi	sp,sp,64
    80002c4c:	8082                	ret

0000000080002c4e <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c4e:	1141                	addi	sp,sp,-16
    80002c50:	e406                	sd	ra,8(sp)
    80002c52:	e022                	sd	s0,0(sp)
    80002c54:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c56:	fffff097          	auipc	ra,0xfffff
    80002c5a:	d56080e7          	jalr	-682(ra) # 800019ac <myproc>
}
    80002c5e:	5908                	lw	a0,48(a0)
    80002c60:	60a2                	ld	ra,8(sp)
    80002c62:	6402                	ld	s0,0(sp)
    80002c64:	0141                	addi	sp,sp,16
    80002c66:	8082                	ret

0000000080002c68 <sys_fork>:

uint64
sys_fork(void)
{
    80002c68:	1141                	addi	sp,sp,-16
    80002c6a:	e406                	sd	ra,8(sp)
    80002c6c:	e022                	sd	s0,0(sp)
    80002c6e:	0800                	addi	s0,sp,16
  return fork();
    80002c70:	fffff097          	auipc	ra,0xfffff
    80002c74:	0f2080e7          	jalr	242(ra) # 80001d62 <fork>
}
    80002c78:	60a2                	ld	ra,8(sp)
    80002c7a:	6402                	ld	s0,0(sp)
    80002c7c:	0141                	addi	sp,sp,16
    80002c7e:	8082                	ret

0000000080002c80 <sys_wait>:

uint64
sys_wait(void)
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 exit_msg;
  
  argaddr(0, &p);
    80002c88:	fe840593          	addi	a1,s0,-24
    80002c8c:	4501                	li	a0,0
    80002c8e:	00000097          	auipc	ra,0x0
    80002c92:	eba080e7          	jalr	-326(ra) # 80002b48 <argaddr>
  argaddr(1, &exit_msg);
    80002c96:	fe040593          	addi	a1,s0,-32
    80002c9a:	4505                	li	a0,1
    80002c9c:	00000097          	auipc	ra,0x0
    80002ca0:	eac080e7          	jalr	-340(ra) # 80002b48 <argaddr>
  return wait(p,exit_msg);
    80002ca4:	fe043583          	ld	a1,-32(s0)
    80002ca8:	fe843503          	ld	a0,-24(s0)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	698080e7          	jalr	1688(ra) # 80002344 <wait>
}
    80002cb4:	60e2                	ld	ra,24(sp)
    80002cb6:	6442                	ld	s0,16(sp)
    80002cb8:	6105                	addi	sp,sp,32
    80002cba:	8082                	ret

0000000080002cbc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cbc:	7179                	addi	sp,sp,-48
    80002cbe:	f406                	sd	ra,40(sp)
    80002cc0:	f022                	sd	s0,32(sp)
    80002cc2:	ec26                	sd	s1,24(sp)
    80002cc4:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002cc6:	fdc40593          	addi	a1,s0,-36
    80002cca:	4501                	li	a0,0
    80002ccc:	00000097          	auipc	ra,0x0
    80002cd0:	e5c080e7          	jalr	-420(ra) # 80002b28 <argint>
  addr = myproc()->sz;
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	cd8080e7          	jalr	-808(ra) # 800019ac <myproc>
    80002cdc:	7524                	ld	s1,104(a0)
  if(growproc(n) < 0)
    80002cde:	fdc42503          	lw	a0,-36(s0)
    80002ce2:	fffff097          	auipc	ra,0xfffff
    80002ce6:	024080e7          	jalr	36(ra) # 80001d06 <growproc>
    80002cea:	00054863          	bltz	a0,80002cfa <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002cee:	8526                	mv	a0,s1
    80002cf0:	70a2                	ld	ra,40(sp)
    80002cf2:	7402                	ld	s0,32(sp)
    80002cf4:	64e2                	ld	s1,24(sp)
    80002cf6:	6145                	addi	sp,sp,48
    80002cf8:	8082                	ret
    return -1;
    80002cfa:	54fd                	li	s1,-1
    80002cfc:	bfcd                	j	80002cee <sys_sbrk+0x32>

0000000080002cfe <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cfe:	7139                	addi	sp,sp,-64
    80002d00:	fc06                	sd	ra,56(sp)
    80002d02:	f822                	sd	s0,48(sp)
    80002d04:	f426                	sd	s1,40(sp)
    80002d06:	f04a                	sd	s2,32(sp)
    80002d08:	ec4e                	sd	s3,24(sp)
    80002d0a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d0c:	fcc40593          	addi	a1,s0,-52
    80002d10:	4501                	li	a0,0
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	e16080e7          	jalr	-490(ra) # 80002b28 <argint>
  acquire(&tickslock);
    80002d1a:	00014517          	auipc	a0,0x14
    80002d1e:	48650513          	addi	a0,a0,1158 # 800171a0 <tickslock>
    80002d22:	ffffe097          	auipc	ra,0xffffe
    80002d26:	eb4080e7          	jalr	-332(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002d2a:	00006917          	auipc	s2,0x6
    80002d2e:	bd692903          	lw	s2,-1066(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002d32:	fcc42783          	lw	a5,-52(s0)
    80002d36:	cf9d                	beqz	a5,80002d74 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d38:	00014997          	auipc	s3,0x14
    80002d3c:	46898993          	addi	s3,s3,1128 # 800171a0 <tickslock>
    80002d40:	00006497          	auipc	s1,0x6
    80002d44:	bc048493          	addi	s1,s1,-1088 # 80008900 <ticks>
    if(killed(myproc())){
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	c64080e7          	jalr	-924(ra) # 800019ac <myproc>
    80002d50:	fffff097          	auipc	ra,0xfffff
    80002d54:	5c2080e7          	jalr	1474(ra) # 80002312 <killed>
    80002d58:	ed15                	bnez	a0,80002d94 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002d5a:	85ce                	mv	a1,s3
    80002d5c:	8526                	mv	a0,s1
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	2f6080e7          	jalr	758(ra) # 80002054 <sleep>
  while(ticks - ticks0 < n){
    80002d66:	409c                	lw	a5,0(s1)
    80002d68:	412787bb          	subw	a5,a5,s2
    80002d6c:	fcc42703          	lw	a4,-52(s0)
    80002d70:	fce7ece3          	bltu	a5,a4,80002d48 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002d74:	00014517          	auipc	a0,0x14
    80002d78:	42c50513          	addi	a0,a0,1068 # 800171a0 <tickslock>
    80002d7c:	ffffe097          	auipc	ra,0xffffe
    80002d80:	f0e080e7          	jalr	-242(ra) # 80000c8a <release>
  return 0;
    80002d84:	4501                	li	a0,0
}
    80002d86:	70e2                	ld	ra,56(sp)
    80002d88:	7442                	ld	s0,48(sp)
    80002d8a:	74a2                	ld	s1,40(sp)
    80002d8c:	7902                	ld	s2,32(sp)
    80002d8e:	69e2                	ld	s3,24(sp)
    80002d90:	6121                	addi	sp,sp,64
    80002d92:	8082                	ret
      release(&tickslock);
    80002d94:	00014517          	auipc	a0,0x14
    80002d98:	40c50513          	addi	a0,a0,1036 # 800171a0 <tickslock>
    80002d9c:	ffffe097          	auipc	ra,0xffffe
    80002da0:	eee080e7          	jalr	-274(ra) # 80000c8a <release>
      return -1;
    80002da4:	557d                	li	a0,-1
    80002da6:	b7c5                	j	80002d86 <sys_sleep+0x88>

0000000080002da8 <sys_kill>:

uint64
sys_kill(void)
{
    80002da8:	1101                	addi	sp,sp,-32
    80002daa:	ec06                	sd	ra,24(sp)
    80002dac:	e822                	sd	s0,16(sp)
    80002dae:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002db0:	fec40593          	addi	a1,s0,-20
    80002db4:	4501                	li	a0,0
    80002db6:	00000097          	auipc	ra,0x0
    80002dba:	d72080e7          	jalr	-654(ra) # 80002b28 <argint>
  return kill(pid);
    80002dbe:	fec42503          	lw	a0,-20(s0)
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	4b2080e7          	jalr	1202(ra) # 80002274 <kill>
}
    80002dca:	60e2                	ld	ra,24(sp)
    80002dcc:	6442                	ld	s0,16(sp)
    80002dce:	6105                	addi	sp,sp,32
    80002dd0:	8082                	ret

0000000080002dd2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dd2:	1101                	addi	sp,sp,-32
    80002dd4:	ec06                	sd	ra,24(sp)
    80002dd6:	e822                	sd	s0,16(sp)
    80002dd8:	e426                	sd	s1,8(sp)
    80002dda:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ddc:	00014517          	auipc	a0,0x14
    80002de0:	3c450513          	addi	a0,a0,964 # 800171a0 <tickslock>
    80002de4:	ffffe097          	auipc	ra,0xffffe
    80002de8:	df2080e7          	jalr	-526(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002dec:	00006497          	auipc	s1,0x6
    80002df0:	b144a483          	lw	s1,-1260(s1) # 80008900 <ticks>
  release(&tickslock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	3ac50513          	addi	a0,a0,940 # 800171a0 <tickslock>
    80002dfc:	ffffe097          	auipc	ra,0xffffe
    80002e00:	e8e080e7          	jalr	-370(ra) # 80000c8a <release>
  return xticks;
}
    80002e04:	02049513          	slli	a0,s1,0x20
    80002e08:	9101                	srli	a0,a0,0x20
    80002e0a:	60e2                	ld	ra,24(sp)
    80002e0c:	6442                	ld	s0,16(sp)
    80002e0e:	64a2                	ld	s1,8(sp)
    80002e10:	6105                	addi	sp,sp,32
    80002e12:	8082                	ret

0000000080002e14 <sys_memsize>:

uint64
sys_memsize(void)
{
    80002e14:	1141                	addi	sp,sp,-16
    80002e16:	e406                	sd	ra,8(sp)
    80002e18:	e022                	sd	s0,0(sp)
    80002e1a:	0800                	addi	s0,sp,16
  return myproc()->sz;
    80002e1c:	fffff097          	auipc	ra,0xfffff
    80002e20:	b90080e7          	jalr	-1136(ra) # 800019ac <myproc>
}
    80002e24:	7528                	ld	a0,104(a0)
    80002e26:	60a2                	ld	ra,8(sp)
    80002e28:	6402                	ld	s0,0(sp)
    80002e2a:	0141                	addi	sp,sp,16
    80002e2c:	8082                	ret

0000000080002e2e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e2e:	7179                	addi	sp,sp,-48
    80002e30:	f406                	sd	ra,40(sp)
    80002e32:	f022                	sd	s0,32(sp)
    80002e34:	ec26                	sd	s1,24(sp)
    80002e36:	e84a                	sd	s2,16(sp)
    80002e38:	e44e                	sd	s3,8(sp)
    80002e3a:	e052                	sd	s4,0(sp)
    80002e3c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e3e:	00005597          	auipc	a1,0x5
    80002e42:	6da58593          	addi	a1,a1,1754 # 80008518 <syscalls+0xb8>
    80002e46:	00014517          	auipc	a0,0x14
    80002e4a:	37250513          	addi	a0,a0,882 # 800171b8 <bcache>
    80002e4e:	ffffe097          	auipc	ra,0xffffe
    80002e52:	cf8080e7          	jalr	-776(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e56:	0001c797          	auipc	a5,0x1c
    80002e5a:	36278793          	addi	a5,a5,866 # 8001f1b8 <bcache+0x8000>
    80002e5e:	0001c717          	auipc	a4,0x1c
    80002e62:	5c270713          	addi	a4,a4,1474 # 8001f420 <bcache+0x8268>
    80002e66:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e6a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e6e:	00014497          	auipc	s1,0x14
    80002e72:	36248493          	addi	s1,s1,866 # 800171d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002e76:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e78:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e7a:	00005a17          	auipc	s4,0x5
    80002e7e:	6a6a0a13          	addi	s4,s4,1702 # 80008520 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002e82:	2b893783          	ld	a5,696(s2)
    80002e86:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002e88:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002e8c:	85d2                	mv	a1,s4
    80002e8e:	01048513          	addi	a0,s1,16
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	4c4080e7          	jalr	1220(ra) # 80004356 <initsleeplock>
    bcache.head.next->prev = b;
    80002e9a:	2b893783          	ld	a5,696(s2)
    80002e9e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ea0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ea4:	45848493          	addi	s1,s1,1112
    80002ea8:	fd349de3          	bne	s1,s3,80002e82 <binit+0x54>
  }
}
    80002eac:	70a2                	ld	ra,40(sp)
    80002eae:	7402                	ld	s0,32(sp)
    80002eb0:	64e2                	ld	s1,24(sp)
    80002eb2:	6942                	ld	s2,16(sp)
    80002eb4:	69a2                	ld	s3,8(sp)
    80002eb6:	6a02                	ld	s4,0(sp)
    80002eb8:	6145                	addi	sp,sp,48
    80002eba:	8082                	ret

0000000080002ebc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002ebc:	7179                	addi	sp,sp,-48
    80002ebe:	f406                	sd	ra,40(sp)
    80002ec0:	f022                	sd	s0,32(sp)
    80002ec2:	ec26                	sd	s1,24(sp)
    80002ec4:	e84a                	sd	s2,16(sp)
    80002ec6:	e44e                	sd	s3,8(sp)
    80002ec8:	1800                	addi	s0,sp,48
    80002eca:	892a                	mv	s2,a0
    80002ecc:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002ece:	00014517          	auipc	a0,0x14
    80002ed2:	2ea50513          	addi	a0,a0,746 # 800171b8 <bcache>
    80002ed6:	ffffe097          	auipc	ra,0xffffe
    80002eda:	d00080e7          	jalr	-768(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ede:	0001c497          	auipc	s1,0x1c
    80002ee2:	5924b483          	ld	s1,1426(s1) # 8001f470 <bcache+0x82b8>
    80002ee6:	0001c797          	auipc	a5,0x1c
    80002eea:	53a78793          	addi	a5,a5,1338 # 8001f420 <bcache+0x8268>
    80002eee:	02f48f63          	beq	s1,a5,80002f2c <bread+0x70>
    80002ef2:	873e                	mv	a4,a5
    80002ef4:	a021                	j	80002efc <bread+0x40>
    80002ef6:	68a4                	ld	s1,80(s1)
    80002ef8:	02e48a63          	beq	s1,a4,80002f2c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002efc:	449c                	lw	a5,8(s1)
    80002efe:	ff279ce3          	bne	a5,s2,80002ef6 <bread+0x3a>
    80002f02:	44dc                	lw	a5,12(s1)
    80002f04:	ff3799e3          	bne	a5,s3,80002ef6 <bread+0x3a>
      b->refcnt++;
    80002f08:	40bc                	lw	a5,64(s1)
    80002f0a:	2785                	addiw	a5,a5,1
    80002f0c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f0e:	00014517          	auipc	a0,0x14
    80002f12:	2aa50513          	addi	a0,a0,682 # 800171b8 <bcache>
    80002f16:	ffffe097          	auipc	ra,0xffffe
    80002f1a:	d74080e7          	jalr	-652(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002f1e:	01048513          	addi	a0,s1,16
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	46e080e7          	jalr	1134(ra) # 80004390 <acquiresleep>
      return b;
    80002f2a:	a8b9                	j	80002f88 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f2c:	0001c497          	auipc	s1,0x1c
    80002f30:	53c4b483          	ld	s1,1340(s1) # 8001f468 <bcache+0x82b0>
    80002f34:	0001c797          	auipc	a5,0x1c
    80002f38:	4ec78793          	addi	a5,a5,1260 # 8001f420 <bcache+0x8268>
    80002f3c:	00f48863          	beq	s1,a5,80002f4c <bread+0x90>
    80002f40:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f42:	40bc                	lw	a5,64(s1)
    80002f44:	cf81                	beqz	a5,80002f5c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f46:	64a4                	ld	s1,72(s1)
    80002f48:	fee49de3          	bne	s1,a4,80002f42 <bread+0x86>
  panic("bget: no buffers");
    80002f4c:	00005517          	auipc	a0,0x5
    80002f50:	5dc50513          	addi	a0,a0,1500 # 80008528 <syscalls+0xc8>
    80002f54:	ffffd097          	auipc	ra,0xffffd
    80002f58:	5ea080e7          	jalr	1514(ra) # 8000053e <panic>
      b->dev = dev;
    80002f5c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f60:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f64:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f68:	4785                	li	a5,1
    80002f6a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f6c:	00014517          	auipc	a0,0x14
    80002f70:	24c50513          	addi	a0,a0,588 # 800171b8 <bcache>
    80002f74:	ffffe097          	auipc	ra,0xffffe
    80002f78:	d16080e7          	jalr	-746(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002f7c:	01048513          	addi	a0,s1,16
    80002f80:	00001097          	auipc	ra,0x1
    80002f84:	410080e7          	jalr	1040(ra) # 80004390 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f88:	409c                	lw	a5,0(s1)
    80002f8a:	cb89                	beqz	a5,80002f9c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f8c:	8526                	mv	a0,s1
    80002f8e:	70a2                	ld	ra,40(sp)
    80002f90:	7402                	ld	s0,32(sp)
    80002f92:	64e2                	ld	s1,24(sp)
    80002f94:	6942                	ld	s2,16(sp)
    80002f96:	69a2                	ld	s3,8(sp)
    80002f98:	6145                	addi	sp,sp,48
    80002f9a:	8082                	ret
    virtio_disk_rw(b, 0);
    80002f9c:	4581                	li	a1,0
    80002f9e:	8526                	mv	a0,s1
    80002fa0:	00003097          	auipc	ra,0x3
    80002fa4:	fd4080e7          	jalr	-44(ra) # 80005f74 <virtio_disk_rw>
    b->valid = 1;
    80002fa8:	4785                	li	a5,1
    80002faa:	c09c                	sw	a5,0(s1)
  return b;
    80002fac:	b7c5                	j	80002f8c <bread+0xd0>

0000000080002fae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fae:	1101                	addi	sp,sp,-32
    80002fb0:	ec06                	sd	ra,24(sp)
    80002fb2:	e822                	sd	s0,16(sp)
    80002fb4:	e426                	sd	s1,8(sp)
    80002fb6:	1000                	addi	s0,sp,32
    80002fb8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fba:	0541                	addi	a0,a0,16
    80002fbc:	00001097          	auipc	ra,0x1
    80002fc0:	46e080e7          	jalr	1134(ra) # 8000442a <holdingsleep>
    80002fc4:	cd01                	beqz	a0,80002fdc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fc6:	4585                	li	a1,1
    80002fc8:	8526                	mv	a0,s1
    80002fca:	00003097          	auipc	ra,0x3
    80002fce:	faa080e7          	jalr	-86(ra) # 80005f74 <virtio_disk_rw>
}
    80002fd2:	60e2                	ld	ra,24(sp)
    80002fd4:	6442                	ld	s0,16(sp)
    80002fd6:	64a2                	ld	s1,8(sp)
    80002fd8:	6105                	addi	sp,sp,32
    80002fda:	8082                	ret
    panic("bwrite");
    80002fdc:	00005517          	auipc	a0,0x5
    80002fe0:	56450513          	addi	a0,a0,1380 # 80008540 <syscalls+0xe0>
    80002fe4:	ffffd097          	auipc	ra,0xffffd
    80002fe8:	55a080e7          	jalr	1370(ra) # 8000053e <panic>

0000000080002fec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002fec:	1101                	addi	sp,sp,-32
    80002fee:	ec06                	sd	ra,24(sp)
    80002ff0:	e822                	sd	s0,16(sp)
    80002ff2:	e426                	sd	s1,8(sp)
    80002ff4:	e04a                	sd	s2,0(sp)
    80002ff6:	1000                	addi	s0,sp,32
    80002ff8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ffa:	01050913          	addi	s2,a0,16
    80002ffe:	854a                	mv	a0,s2
    80003000:	00001097          	auipc	ra,0x1
    80003004:	42a080e7          	jalr	1066(ra) # 8000442a <holdingsleep>
    80003008:	c92d                	beqz	a0,8000307a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000300a:	854a                	mv	a0,s2
    8000300c:	00001097          	auipc	ra,0x1
    80003010:	3da080e7          	jalr	986(ra) # 800043e6 <releasesleep>

  acquire(&bcache.lock);
    80003014:	00014517          	auipc	a0,0x14
    80003018:	1a450513          	addi	a0,a0,420 # 800171b8 <bcache>
    8000301c:	ffffe097          	auipc	ra,0xffffe
    80003020:	bba080e7          	jalr	-1094(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003024:	40bc                	lw	a5,64(s1)
    80003026:	37fd                	addiw	a5,a5,-1
    80003028:	0007871b          	sext.w	a4,a5
    8000302c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000302e:	eb05                	bnez	a4,8000305e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003030:	68bc                	ld	a5,80(s1)
    80003032:	64b8                	ld	a4,72(s1)
    80003034:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003036:	64bc                	ld	a5,72(s1)
    80003038:	68b8                	ld	a4,80(s1)
    8000303a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000303c:	0001c797          	auipc	a5,0x1c
    80003040:	17c78793          	addi	a5,a5,380 # 8001f1b8 <bcache+0x8000>
    80003044:	2b87b703          	ld	a4,696(a5)
    80003048:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000304a:	0001c717          	auipc	a4,0x1c
    8000304e:	3d670713          	addi	a4,a4,982 # 8001f420 <bcache+0x8268>
    80003052:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003054:	2b87b703          	ld	a4,696(a5)
    80003058:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000305a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000305e:	00014517          	auipc	a0,0x14
    80003062:	15a50513          	addi	a0,a0,346 # 800171b8 <bcache>
    80003066:	ffffe097          	auipc	ra,0xffffe
    8000306a:	c24080e7          	jalr	-988(ra) # 80000c8a <release>
}
    8000306e:	60e2                	ld	ra,24(sp)
    80003070:	6442                	ld	s0,16(sp)
    80003072:	64a2                	ld	s1,8(sp)
    80003074:	6902                	ld	s2,0(sp)
    80003076:	6105                	addi	sp,sp,32
    80003078:	8082                	ret
    panic("brelse");
    8000307a:	00005517          	auipc	a0,0x5
    8000307e:	4ce50513          	addi	a0,a0,1230 # 80008548 <syscalls+0xe8>
    80003082:	ffffd097          	auipc	ra,0xffffd
    80003086:	4bc080e7          	jalr	1212(ra) # 8000053e <panic>

000000008000308a <bpin>:

void
bpin(struct buf *b) {
    8000308a:	1101                	addi	sp,sp,-32
    8000308c:	ec06                	sd	ra,24(sp)
    8000308e:	e822                	sd	s0,16(sp)
    80003090:	e426                	sd	s1,8(sp)
    80003092:	1000                	addi	s0,sp,32
    80003094:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003096:	00014517          	auipc	a0,0x14
    8000309a:	12250513          	addi	a0,a0,290 # 800171b8 <bcache>
    8000309e:	ffffe097          	auipc	ra,0xffffe
    800030a2:	b38080e7          	jalr	-1224(ra) # 80000bd6 <acquire>
  b->refcnt++;
    800030a6:	40bc                	lw	a5,64(s1)
    800030a8:	2785                	addiw	a5,a5,1
    800030aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030ac:	00014517          	auipc	a0,0x14
    800030b0:	10c50513          	addi	a0,a0,268 # 800171b8 <bcache>
    800030b4:	ffffe097          	auipc	ra,0xffffe
    800030b8:	bd6080e7          	jalr	-1066(ra) # 80000c8a <release>
}
    800030bc:	60e2                	ld	ra,24(sp)
    800030be:	6442                	ld	s0,16(sp)
    800030c0:	64a2                	ld	s1,8(sp)
    800030c2:	6105                	addi	sp,sp,32
    800030c4:	8082                	ret

00000000800030c6 <bunpin>:

void
bunpin(struct buf *b) {
    800030c6:	1101                	addi	sp,sp,-32
    800030c8:	ec06                	sd	ra,24(sp)
    800030ca:	e822                	sd	s0,16(sp)
    800030cc:	e426                	sd	s1,8(sp)
    800030ce:	1000                	addi	s0,sp,32
    800030d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030d2:	00014517          	auipc	a0,0x14
    800030d6:	0e650513          	addi	a0,a0,230 # 800171b8 <bcache>
    800030da:	ffffe097          	auipc	ra,0xffffe
    800030de:	afc080e7          	jalr	-1284(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800030e2:	40bc                	lw	a5,64(s1)
    800030e4:	37fd                	addiw	a5,a5,-1
    800030e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030e8:	00014517          	auipc	a0,0x14
    800030ec:	0d050513          	addi	a0,a0,208 # 800171b8 <bcache>
    800030f0:	ffffe097          	auipc	ra,0xffffe
    800030f4:	b9a080e7          	jalr	-1126(ra) # 80000c8a <release>
}
    800030f8:	60e2                	ld	ra,24(sp)
    800030fa:	6442                	ld	s0,16(sp)
    800030fc:	64a2                	ld	s1,8(sp)
    800030fe:	6105                	addi	sp,sp,32
    80003100:	8082                	ret

0000000080003102 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003102:	1101                	addi	sp,sp,-32
    80003104:	ec06                	sd	ra,24(sp)
    80003106:	e822                	sd	s0,16(sp)
    80003108:	e426                	sd	s1,8(sp)
    8000310a:	e04a                	sd	s2,0(sp)
    8000310c:	1000                	addi	s0,sp,32
    8000310e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003110:	00d5d59b          	srliw	a1,a1,0xd
    80003114:	0001c797          	auipc	a5,0x1c
    80003118:	7807a783          	lw	a5,1920(a5) # 8001f894 <sb+0x1c>
    8000311c:	9dbd                	addw	a1,a1,a5
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	d9e080e7          	jalr	-610(ra) # 80002ebc <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003126:	0074f713          	andi	a4,s1,7
    8000312a:	4785                	li	a5,1
    8000312c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003130:	14ce                	slli	s1,s1,0x33
    80003132:	90d9                	srli	s1,s1,0x36
    80003134:	00950733          	add	a4,a0,s1
    80003138:	05874703          	lbu	a4,88(a4)
    8000313c:	00e7f6b3          	and	a3,a5,a4
    80003140:	c69d                	beqz	a3,8000316e <bfree+0x6c>
    80003142:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003144:	94aa                	add	s1,s1,a0
    80003146:	fff7c793          	not	a5,a5
    8000314a:	8ff9                	and	a5,a5,a4
    8000314c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003150:	00001097          	auipc	ra,0x1
    80003154:	120080e7          	jalr	288(ra) # 80004270 <log_write>
  brelse(bp);
    80003158:	854a                	mv	a0,s2
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	e92080e7          	jalr	-366(ra) # 80002fec <brelse>
}
    80003162:	60e2                	ld	ra,24(sp)
    80003164:	6442                	ld	s0,16(sp)
    80003166:	64a2                	ld	s1,8(sp)
    80003168:	6902                	ld	s2,0(sp)
    8000316a:	6105                	addi	sp,sp,32
    8000316c:	8082                	ret
    panic("freeing free block");
    8000316e:	00005517          	auipc	a0,0x5
    80003172:	3e250513          	addi	a0,a0,994 # 80008550 <syscalls+0xf0>
    80003176:	ffffd097          	auipc	ra,0xffffd
    8000317a:	3c8080e7          	jalr	968(ra) # 8000053e <panic>

000000008000317e <balloc>:
{
    8000317e:	711d                	addi	sp,sp,-96
    80003180:	ec86                	sd	ra,88(sp)
    80003182:	e8a2                	sd	s0,80(sp)
    80003184:	e4a6                	sd	s1,72(sp)
    80003186:	e0ca                	sd	s2,64(sp)
    80003188:	fc4e                	sd	s3,56(sp)
    8000318a:	f852                	sd	s4,48(sp)
    8000318c:	f456                	sd	s5,40(sp)
    8000318e:	f05a                	sd	s6,32(sp)
    80003190:	ec5e                	sd	s7,24(sp)
    80003192:	e862                	sd	s8,16(sp)
    80003194:	e466                	sd	s9,8(sp)
    80003196:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003198:	0001c797          	auipc	a5,0x1c
    8000319c:	6e47a783          	lw	a5,1764(a5) # 8001f87c <sb+0x4>
    800031a0:	10078163          	beqz	a5,800032a2 <balloc+0x124>
    800031a4:	8baa                	mv	s7,a0
    800031a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800031a8:	0001cb17          	auipc	s6,0x1c
    800031ac:	6d0b0b13          	addi	s6,s6,1744 # 8001f878 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031b0:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800031b2:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800031b4:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800031b6:	6c89                	lui	s9,0x2
    800031b8:	a061                	j	80003240 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800031ba:	974a                	add	a4,a4,s2
    800031bc:	8fd5                	or	a5,a5,a3
    800031be:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800031c2:	854a                	mv	a0,s2
    800031c4:	00001097          	auipc	ra,0x1
    800031c8:	0ac080e7          	jalr	172(ra) # 80004270 <log_write>
        brelse(bp);
    800031cc:	854a                	mv	a0,s2
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	e1e080e7          	jalr	-482(ra) # 80002fec <brelse>
  bp = bread(dev, bno);
    800031d6:	85a6                	mv	a1,s1
    800031d8:	855e                	mv	a0,s7
    800031da:	00000097          	auipc	ra,0x0
    800031de:	ce2080e7          	jalr	-798(ra) # 80002ebc <bread>
    800031e2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031e4:	40000613          	li	a2,1024
    800031e8:	4581                	li	a1,0
    800031ea:	05850513          	addi	a0,a0,88
    800031ee:	ffffe097          	auipc	ra,0xffffe
    800031f2:	ae4080e7          	jalr	-1308(ra) # 80000cd2 <memset>
  log_write(bp);
    800031f6:	854a                	mv	a0,s2
    800031f8:	00001097          	auipc	ra,0x1
    800031fc:	078080e7          	jalr	120(ra) # 80004270 <log_write>
  brelse(bp);
    80003200:	854a                	mv	a0,s2
    80003202:	00000097          	auipc	ra,0x0
    80003206:	dea080e7          	jalr	-534(ra) # 80002fec <brelse>
}
    8000320a:	8526                	mv	a0,s1
    8000320c:	60e6                	ld	ra,88(sp)
    8000320e:	6446                	ld	s0,80(sp)
    80003210:	64a6                	ld	s1,72(sp)
    80003212:	6906                	ld	s2,64(sp)
    80003214:	79e2                	ld	s3,56(sp)
    80003216:	7a42                	ld	s4,48(sp)
    80003218:	7aa2                	ld	s5,40(sp)
    8000321a:	7b02                	ld	s6,32(sp)
    8000321c:	6be2                	ld	s7,24(sp)
    8000321e:	6c42                	ld	s8,16(sp)
    80003220:	6ca2                	ld	s9,8(sp)
    80003222:	6125                	addi	sp,sp,96
    80003224:	8082                	ret
    brelse(bp);
    80003226:	854a                	mv	a0,s2
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	dc4080e7          	jalr	-572(ra) # 80002fec <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003230:	015c87bb          	addw	a5,s9,s5
    80003234:	00078a9b          	sext.w	s5,a5
    80003238:	004b2703          	lw	a4,4(s6)
    8000323c:	06eaf363          	bgeu	s5,a4,800032a2 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003240:	41fad79b          	sraiw	a5,s5,0x1f
    80003244:	0137d79b          	srliw	a5,a5,0x13
    80003248:	015787bb          	addw	a5,a5,s5
    8000324c:	40d7d79b          	sraiw	a5,a5,0xd
    80003250:	01cb2583          	lw	a1,28(s6)
    80003254:	9dbd                	addw	a1,a1,a5
    80003256:	855e                	mv	a0,s7
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	c64080e7          	jalr	-924(ra) # 80002ebc <bread>
    80003260:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003262:	004b2503          	lw	a0,4(s6)
    80003266:	000a849b          	sext.w	s1,s5
    8000326a:	8662                	mv	a2,s8
    8000326c:	faa4fde3          	bgeu	s1,a0,80003226 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003270:	41f6579b          	sraiw	a5,a2,0x1f
    80003274:	01d7d69b          	srliw	a3,a5,0x1d
    80003278:	00c6873b          	addw	a4,a3,a2
    8000327c:	00777793          	andi	a5,a4,7
    80003280:	9f95                	subw	a5,a5,a3
    80003282:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003286:	4037571b          	sraiw	a4,a4,0x3
    8000328a:	00e906b3          	add	a3,s2,a4
    8000328e:	0586c683          	lbu	a3,88(a3)
    80003292:	00d7f5b3          	and	a1,a5,a3
    80003296:	d195                	beqz	a1,800031ba <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003298:	2605                	addiw	a2,a2,1
    8000329a:	2485                	addiw	s1,s1,1
    8000329c:	fd4618e3          	bne	a2,s4,8000326c <balloc+0xee>
    800032a0:	b759                	j	80003226 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800032a2:	00005517          	auipc	a0,0x5
    800032a6:	2c650513          	addi	a0,a0,710 # 80008568 <syscalls+0x108>
    800032aa:	ffffd097          	auipc	ra,0xffffd
    800032ae:	2de080e7          	jalr	734(ra) # 80000588 <printf>
  return 0;
    800032b2:	4481                	li	s1,0
    800032b4:	bf99                	j	8000320a <balloc+0x8c>

00000000800032b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800032b6:	7179                	addi	sp,sp,-48
    800032b8:	f406                	sd	ra,40(sp)
    800032ba:	f022                	sd	s0,32(sp)
    800032bc:	ec26                	sd	s1,24(sp)
    800032be:	e84a                	sd	s2,16(sp)
    800032c0:	e44e                	sd	s3,8(sp)
    800032c2:	e052                	sd	s4,0(sp)
    800032c4:	1800                	addi	s0,sp,48
    800032c6:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800032c8:	47ad                	li	a5,11
    800032ca:	02b7e763          	bltu	a5,a1,800032f8 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800032ce:	02059493          	slli	s1,a1,0x20
    800032d2:	9081                	srli	s1,s1,0x20
    800032d4:	048a                	slli	s1,s1,0x2
    800032d6:	94aa                	add	s1,s1,a0
    800032d8:	0504a903          	lw	s2,80(s1)
    800032dc:	06091e63          	bnez	s2,80003358 <bmap+0xa2>
      addr = balloc(ip->dev);
    800032e0:	4108                	lw	a0,0(a0)
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	e9c080e7          	jalr	-356(ra) # 8000317e <balloc>
    800032ea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032ee:	06090563          	beqz	s2,80003358 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800032f2:	0524a823          	sw	s2,80(s1)
    800032f6:	a08d                	j	80003358 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800032f8:	ff45849b          	addiw	s1,a1,-12
    800032fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003300:	0ff00793          	li	a5,255
    80003304:	08e7e563          	bltu	a5,a4,8000338e <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003308:	08052903          	lw	s2,128(a0)
    8000330c:	00091d63          	bnez	s2,80003326 <bmap+0x70>
      addr = balloc(ip->dev);
    80003310:	4108                	lw	a0,0(a0)
    80003312:	00000097          	auipc	ra,0x0
    80003316:	e6c080e7          	jalr	-404(ra) # 8000317e <balloc>
    8000331a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000331e:	02090d63          	beqz	s2,80003358 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003322:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003326:	85ca                	mv	a1,s2
    80003328:	0009a503          	lw	a0,0(s3)
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	b90080e7          	jalr	-1136(ra) # 80002ebc <bread>
    80003334:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003336:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000333a:	02049593          	slli	a1,s1,0x20
    8000333e:	9181                	srli	a1,a1,0x20
    80003340:	058a                	slli	a1,a1,0x2
    80003342:	00b784b3          	add	s1,a5,a1
    80003346:	0004a903          	lw	s2,0(s1)
    8000334a:	02090063          	beqz	s2,8000336a <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000334e:	8552                	mv	a0,s4
    80003350:	00000097          	auipc	ra,0x0
    80003354:	c9c080e7          	jalr	-868(ra) # 80002fec <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003358:	854a                	mv	a0,s2
    8000335a:	70a2                	ld	ra,40(sp)
    8000335c:	7402                	ld	s0,32(sp)
    8000335e:	64e2                	ld	s1,24(sp)
    80003360:	6942                	ld	s2,16(sp)
    80003362:	69a2                	ld	s3,8(sp)
    80003364:	6a02                	ld	s4,0(sp)
    80003366:	6145                	addi	sp,sp,48
    80003368:	8082                	ret
      addr = balloc(ip->dev);
    8000336a:	0009a503          	lw	a0,0(s3)
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	e10080e7          	jalr	-496(ra) # 8000317e <balloc>
    80003376:	0005091b          	sext.w	s2,a0
      if(addr){
    8000337a:	fc090ae3          	beqz	s2,8000334e <bmap+0x98>
        a[bn] = addr;
    8000337e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003382:	8552                	mv	a0,s4
    80003384:	00001097          	auipc	ra,0x1
    80003388:	eec080e7          	jalr	-276(ra) # 80004270 <log_write>
    8000338c:	b7c9                	j	8000334e <bmap+0x98>
  panic("bmap: out of range");
    8000338e:	00005517          	auipc	a0,0x5
    80003392:	1f250513          	addi	a0,a0,498 # 80008580 <syscalls+0x120>
    80003396:	ffffd097          	auipc	ra,0xffffd
    8000339a:	1a8080e7          	jalr	424(ra) # 8000053e <panic>

000000008000339e <iget>:
{
    8000339e:	7179                	addi	sp,sp,-48
    800033a0:	f406                	sd	ra,40(sp)
    800033a2:	f022                	sd	s0,32(sp)
    800033a4:	ec26                	sd	s1,24(sp)
    800033a6:	e84a                	sd	s2,16(sp)
    800033a8:	e44e                	sd	s3,8(sp)
    800033aa:	e052                	sd	s4,0(sp)
    800033ac:	1800                	addi	s0,sp,48
    800033ae:	89aa                	mv	s3,a0
    800033b0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800033b2:	0001c517          	auipc	a0,0x1c
    800033b6:	4e650513          	addi	a0,a0,1254 # 8001f898 <itable>
    800033ba:	ffffe097          	auipc	ra,0xffffe
    800033be:	81c080e7          	jalr	-2020(ra) # 80000bd6 <acquire>
  empty = 0;
    800033c2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800033c4:	0001c497          	auipc	s1,0x1c
    800033c8:	4ec48493          	addi	s1,s1,1260 # 8001f8b0 <itable+0x18>
    800033cc:	0001e697          	auipc	a3,0x1e
    800033d0:	f7468693          	addi	a3,a3,-140 # 80021340 <log>
    800033d4:	a039                	j	800033e2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800033d6:	02090b63          	beqz	s2,8000340c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800033da:	08848493          	addi	s1,s1,136
    800033de:	02d48a63          	beq	s1,a3,80003412 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800033e2:	449c                	lw	a5,8(s1)
    800033e4:	fef059e3          	blez	a5,800033d6 <iget+0x38>
    800033e8:	4098                	lw	a4,0(s1)
    800033ea:	ff3716e3          	bne	a4,s3,800033d6 <iget+0x38>
    800033ee:	40d8                	lw	a4,4(s1)
    800033f0:	ff4713e3          	bne	a4,s4,800033d6 <iget+0x38>
      ip->ref++;
    800033f4:	2785                	addiw	a5,a5,1
    800033f6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800033f8:	0001c517          	auipc	a0,0x1c
    800033fc:	4a050513          	addi	a0,a0,1184 # 8001f898 <itable>
    80003400:	ffffe097          	auipc	ra,0xffffe
    80003404:	88a080e7          	jalr	-1910(ra) # 80000c8a <release>
      return ip;
    80003408:	8926                	mv	s2,s1
    8000340a:	a03d                	j	80003438 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000340c:	f7f9                	bnez	a5,800033da <iget+0x3c>
    8000340e:	8926                	mv	s2,s1
    80003410:	b7e9                	j	800033da <iget+0x3c>
  if(empty == 0)
    80003412:	02090c63          	beqz	s2,8000344a <iget+0xac>
  ip->dev = dev;
    80003416:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000341a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000341e:	4785                	li	a5,1
    80003420:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003424:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003428:	0001c517          	auipc	a0,0x1c
    8000342c:	47050513          	addi	a0,a0,1136 # 8001f898 <itable>
    80003430:	ffffe097          	auipc	ra,0xffffe
    80003434:	85a080e7          	jalr	-1958(ra) # 80000c8a <release>
}
    80003438:	854a                	mv	a0,s2
    8000343a:	70a2                	ld	ra,40(sp)
    8000343c:	7402                	ld	s0,32(sp)
    8000343e:	64e2                	ld	s1,24(sp)
    80003440:	6942                	ld	s2,16(sp)
    80003442:	69a2                	ld	s3,8(sp)
    80003444:	6a02                	ld	s4,0(sp)
    80003446:	6145                	addi	sp,sp,48
    80003448:	8082                	ret
    panic("iget: no inodes");
    8000344a:	00005517          	auipc	a0,0x5
    8000344e:	14e50513          	addi	a0,a0,334 # 80008598 <syscalls+0x138>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	0ec080e7          	jalr	236(ra) # 8000053e <panic>

000000008000345a <fsinit>:
fsinit(int dev) {
    8000345a:	7179                	addi	sp,sp,-48
    8000345c:	f406                	sd	ra,40(sp)
    8000345e:	f022                	sd	s0,32(sp)
    80003460:	ec26                	sd	s1,24(sp)
    80003462:	e84a                	sd	s2,16(sp)
    80003464:	e44e                	sd	s3,8(sp)
    80003466:	1800                	addi	s0,sp,48
    80003468:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000346a:	4585                	li	a1,1
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	a50080e7          	jalr	-1456(ra) # 80002ebc <bread>
    80003474:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003476:	0001c997          	auipc	s3,0x1c
    8000347a:	40298993          	addi	s3,s3,1026 # 8001f878 <sb>
    8000347e:	02000613          	li	a2,32
    80003482:	05850593          	addi	a1,a0,88
    80003486:	854e                	mv	a0,s3
    80003488:	ffffe097          	auipc	ra,0xffffe
    8000348c:	8a6080e7          	jalr	-1882(ra) # 80000d2e <memmove>
  brelse(bp);
    80003490:	8526                	mv	a0,s1
    80003492:	00000097          	auipc	ra,0x0
    80003496:	b5a080e7          	jalr	-1190(ra) # 80002fec <brelse>
  if(sb.magic != FSMAGIC)
    8000349a:	0009a703          	lw	a4,0(s3)
    8000349e:	102037b7          	lui	a5,0x10203
    800034a2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034a6:	02f71263          	bne	a4,a5,800034ca <fsinit+0x70>
  initlog(dev, &sb);
    800034aa:	0001c597          	auipc	a1,0x1c
    800034ae:	3ce58593          	addi	a1,a1,974 # 8001f878 <sb>
    800034b2:	854a                	mv	a0,s2
    800034b4:	00001097          	auipc	ra,0x1
    800034b8:	b40080e7          	jalr	-1216(ra) # 80003ff4 <initlog>
}
    800034bc:	70a2                	ld	ra,40(sp)
    800034be:	7402                	ld	s0,32(sp)
    800034c0:	64e2                	ld	s1,24(sp)
    800034c2:	6942                	ld	s2,16(sp)
    800034c4:	69a2                	ld	s3,8(sp)
    800034c6:	6145                	addi	sp,sp,48
    800034c8:	8082                	ret
    panic("invalid file system");
    800034ca:	00005517          	auipc	a0,0x5
    800034ce:	0de50513          	addi	a0,a0,222 # 800085a8 <syscalls+0x148>
    800034d2:	ffffd097          	auipc	ra,0xffffd
    800034d6:	06c080e7          	jalr	108(ra) # 8000053e <panic>

00000000800034da <iinit>:
{
    800034da:	7179                	addi	sp,sp,-48
    800034dc:	f406                	sd	ra,40(sp)
    800034de:	f022                	sd	s0,32(sp)
    800034e0:	ec26                	sd	s1,24(sp)
    800034e2:	e84a                	sd	s2,16(sp)
    800034e4:	e44e                	sd	s3,8(sp)
    800034e6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800034e8:	00005597          	auipc	a1,0x5
    800034ec:	0d858593          	addi	a1,a1,216 # 800085c0 <syscalls+0x160>
    800034f0:	0001c517          	auipc	a0,0x1c
    800034f4:	3a850513          	addi	a0,a0,936 # 8001f898 <itable>
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	64e080e7          	jalr	1614(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003500:	0001c497          	auipc	s1,0x1c
    80003504:	3c048493          	addi	s1,s1,960 # 8001f8c0 <itable+0x28>
    80003508:	0001e997          	auipc	s3,0x1e
    8000350c:	e4898993          	addi	s3,s3,-440 # 80021350 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003510:	00005917          	auipc	s2,0x5
    80003514:	0b890913          	addi	s2,s2,184 # 800085c8 <syscalls+0x168>
    80003518:	85ca                	mv	a1,s2
    8000351a:	8526                	mv	a0,s1
    8000351c:	00001097          	auipc	ra,0x1
    80003520:	e3a080e7          	jalr	-454(ra) # 80004356 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003524:	08848493          	addi	s1,s1,136
    80003528:	ff3498e3          	bne	s1,s3,80003518 <iinit+0x3e>
}
    8000352c:	70a2                	ld	ra,40(sp)
    8000352e:	7402                	ld	s0,32(sp)
    80003530:	64e2                	ld	s1,24(sp)
    80003532:	6942                	ld	s2,16(sp)
    80003534:	69a2                	ld	s3,8(sp)
    80003536:	6145                	addi	sp,sp,48
    80003538:	8082                	ret

000000008000353a <ialloc>:
{
    8000353a:	715d                	addi	sp,sp,-80
    8000353c:	e486                	sd	ra,72(sp)
    8000353e:	e0a2                	sd	s0,64(sp)
    80003540:	fc26                	sd	s1,56(sp)
    80003542:	f84a                	sd	s2,48(sp)
    80003544:	f44e                	sd	s3,40(sp)
    80003546:	f052                	sd	s4,32(sp)
    80003548:	ec56                	sd	s5,24(sp)
    8000354a:	e85a                	sd	s6,16(sp)
    8000354c:	e45e                	sd	s7,8(sp)
    8000354e:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003550:	0001c717          	auipc	a4,0x1c
    80003554:	33472703          	lw	a4,820(a4) # 8001f884 <sb+0xc>
    80003558:	4785                	li	a5,1
    8000355a:	04e7fa63          	bgeu	a5,a4,800035ae <ialloc+0x74>
    8000355e:	8aaa                	mv	s5,a0
    80003560:	8bae                	mv	s7,a1
    80003562:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003564:	0001ca17          	auipc	s4,0x1c
    80003568:	314a0a13          	addi	s4,s4,788 # 8001f878 <sb>
    8000356c:	00048b1b          	sext.w	s6,s1
    80003570:	0044d793          	srli	a5,s1,0x4
    80003574:	018a2583          	lw	a1,24(s4)
    80003578:	9dbd                	addw	a1,a1,a5
    8000357a:	8556                	mv	a0,s5
    8000357c:	00000097          	auipc	ra,0x0
    80003580:	940080e7          	jalr	-1728(ra) # 80002ebc <bread>
    80003584:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003586:	05850993          	addi	s3,a0,88
    8000358a:	00f4f793          	andi	a5,s1,15
    8000358e:	079a                	slli	a5,a5,0x6
    80003590:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003592:	00099783          	lh	a5,0(s3)
    80003596:	c3a1                	beqz	a5,800035d6 <ialloc+0x9c>
    brelse(bp);
    80003598:	00000097          	auipc	ra,0x0
    8000359c:	a54080e7          	jalr	-1452(ra) # 80002fec <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035a0:	0485                	addi	s1,s1,1
    800035a2:	00ca2703          	lw	a4,12(s4)
    800035a6:	0004879b          	sext.w	a5,s1
    800035aa:	fce7e1e3          	bltu	a5,a4,8000356c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800035ae:	00005517          	auipc	a0,0x5
    800035b2:	02250513          	addi	a0,a0,34 # 800085d0 <syscalls+0x170>
    800035b6:	ffffd097          	auipc	ra,0xffffd
    800035ba:	fd2080e7          	jalr	-46(ra) # 80000588 <printf>
  return 0;
    800035be:	4501                	li	a0,0
}
    800035c0:	60a6                	ld	ra,72(sp)
    800035c2:	6406                	ld	s0,64(sp)
    800035c4:	74e2                	ld	s1,56(sp)
    800035c6:	7942                	ld	s2,48(sp)
    800035c8:	79a2                	ld	s3,40(sp)
    800035ca:	7a02                	ld	s4,32(sp)
    800035cc:	6ae2                	ld	s5,24(sp)
    800035ce:	6b42                	ld	s6,16(sp)
    800035d0:	6ba2                	ld	s7,8(sp)
    800035d2:	6161                	addi	sp,sp,80
    800035d4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800035d6:	04000613          	li	a2,64
    800035da:	4581                	li	a1,0
    800035dc:	854e                	mv	a0,s3
    800035de:	ffffd097          	auipc	ra,0xffffd
    800035e2:	6f4080e7          	jalr	1780(ra) # 80000cd2 <memset>
      dip->type = type;
    800035e6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800035ea:	854a                	mv	a0,s2
    800035ec:	00001097          	auipc	ra,0x1
    800035f0:	c84080e7          	jalr	-892(ra) # 80004270 <log_write>
      brelse(bp);
    800035f4:	854a                	mv	a0,s2
    800035f6:	00000097          	auipc	ra,0x0
    800035fa:	9f6080e7          	jalr	-1546(ra) # 80002fec <brelse>
      return iget(dev, inum);
    800035fe:	85da                	mv	a1,s6
    80003600:	8556                	mv	a0,s5
    80003602:	00000097          	auipc	ra,0x0
    80003606:	d9c080e7          	jalr	-612(ra) # 8000339e <iget>
    8000360a:	bf5d                	j	800035c0 <ialloc+0x86>

000000008000360c <iupdate>:
{
    8000360c:	1101                	addi	sp,sp,-32
    8000360e:	ec06                	sd	ra,24(sp)
    80003610:	e822                	sd	s0,16(sp)
    80003612:	e426                	sd	s1,8(sp)
    80003614:	e04a                	sd	s2,0(sp)
    80003616:	1000                	addi	s0,sp,32
    80003618:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000361a:	415c                	lw	a5,4(a0)
    8000361c:	0047d79b          	srliw	a5,a5,0x4
    80003620:	0001c597          	auipc	a1,0x1c
    80003624:	2705a583          	lw	a1,624(a1) # 8001f890 <sb+0x18>
    80003628:	9dbd                	addw	a1,a1,a5
    8000362a:	4108                	lw	a0,0(a0)
    8000362c:	00000097          	auipc	ra,0x0
    80003630:	890080e7          	jalr	-1904(ra) # 80002ebc <bread>
    80003634:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003636:	05850793          	addi	a5,a0,88
    8000363a:	40c8                	lw	a0,4(s1)
    8000363c:	893d                	andi	a0,a0,15
    8000363e:	051a                	slli	a0,a0,0x6
    80003640:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003642:	04449703          	lh	a4,68(s1)
    80003646:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000364a:	04649703          	lh	a4,70(s1)
    8000364e:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003652:	04849703          	lh	a4,72(s1)
    80003656:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000365a:	04a49703          	lh	a4,74(s1)
    8000365e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003662:	44f8                	lw	a4,76(s1)
    80003664:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003666:	03400613          	li	a2,52
    8000366a:	05048593          	addi	a1,s1,80
    8000366e:	0531                	addi	a0,a0,12
    80003670:	ffffd097          	auipc	ra,0xffffd
    80003674:	6be080e7          	jalr	1726(ra) # 80000d2e <memmove>
  log_write(bp);
    80003678:	854a                	mv	a0,s2
    8000367a:	00001097          	auipc	ra,0x1
    8000367e:	bf6080e7          	jalr	-1034(ra) # 80004270 <log_write>
  brelse(bp);
    80003682:	854a                	mv	a0,s2
    80003684:	00000097          	auipc	ra,0x0
    80003688:	968080e7          	jalr	-1688(ra) # 80002fec <brelse>
}
    8000368c:	60e2                	ld	ra,24(sp)
    8000368e:	6442                	ld	s0,16(sp)
    80003690:	64a2                	ld	s1,8(sp)
    80003692:	6902                	ld	s2,0(sp)
    80003694:	6105                	addi	sp,sp,32
    80003696:	8082                	ret

0000000080003698 <idup>:
{
    80003698:	1101                	addi	sp,sp,-32
    8000369a:	ec06                	sd	ra,24(sp)
    8000369c:	e822                	sd	s0,16(sp)
    8000369e:	e426                	sd	s1,8(sp)
    800036a0:	1000                	addi	s0,sp,32
    800036a2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036a4:	0001c517          	auipc	a0,0x1c
    800036a8:	1f450513          	addi	a0,a0,500 # 8001f898 <itable>
    800036ac:	ffffd097          	auipc	ra,0xffffd
    800036b0:	52a080e7          	jalr	1322(ra) # 80000bd6 <acquire>
  ip->ref++;
    800036b4:	449c                	lw	a5,8(s1)
    800036b6:	2785                	addiw	a5,a5,1
    800036b8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036ba:	0001c517          	auipc	a0,0x1c
    800036be:	1de50513          	addi	a0,a0,478 # 8001f898 <itable>
    800036c2:	ffffd097          	auipc	ra,0xffffd
    800036c6:	5c8080e7          	jalr	1480(ra) # 80000c8a <release>
}
    800036ca:	8526                	mv	a0,s1
    800036cc:	60e2                	ld	ra,24(sp)
    800036ce:	6442                	ld	s0,16(sp)
    800036d0:	64a2                	ld	s1,8(sp)
    800036d2:	6105                	addi	sp,sp,32
    800036d4:	8082                	ret

00000000800036d6 <ilock>:
{
    800036d6:	1101                	addi	sp,sp,-32
    800036d8:	ec06                	sd	ra,24(sp)
    800036da:	e822                	sd	s0,16(sp)
    800036dc:	e426                	sd	s1,8(sp)
    800036de:	e04a                	sd	s2,0(sp)
    800036e0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800036e2:	c115                	beqz	a0,80003706 <ilock+0x30>
    800036e4:	84aa                	mv	s1,a0
    800036e6:	451c                	lw	a5,8(a0)
    800036e8:	00f05f63          	blez	a5,80003706 <ilock+0x30>
  acquiresleep(&ip->lock);
    800036ec:	0541                	addi	a0,a0,16
    800036ee:	00001097          	auipc	ra,0x1
    800036f2:	ca2080e7          	jalr	-862(ra) # 80004390 <acquiresleep>
  if(ip->valid == 0){
    800036f6:	40bc                	lw	a5,64(s1)
    800036f8:	cf99                	beqz	a5,80003716 <ilock+0x40>
}
    800036fa:	60e2                	ld	ra,24(sp)
    800036fc:	6442                	ld	s0,16(sp)
    800036fe:	64a2                	ld	s1,8(sp)
    80003700:	6902                	ld	s2,0(sp)
    80003702:	6105                	addi	sp,sp,32
    80003704:	8082                	ret
    panic("ilock");
    80003706:	00005517          	auipc	a0,0x5
    8000370a:	ee250513          	addi	a0,a0,-286 # 800085e8 <syscalls+0x188>
    8000370e:	ffffd097          	auipc	ra,0xffffd
    80003712:	e30080e7          	jalr	-464(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003716:	40dc                	lw	a5,4(s1)
    80003718:	0047d79b          	srliw	a5,a5,0x4
    8000371c:	0001c597          	auipc	a1,0x1c
    80003720:	1745a583          	lw	a1,372(a1) # 8001f890 <sb+0x18>
    80003724:	9dbd                	addw	a1,a1,a5
    80003726:	4088                	lw	a0,0(s1)
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	794080e7          	jalr	1940(ra) # 80002ebc <bread>
    80003730:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003732:	05850593          	addi	a1,a0,88
    80003736:	40dc                	lw	a5,4(s1)
    80003738:	8bbd                	andi	a5,a5,15
    8000373a:	079a                	slli	a5,a5,0x6
    8000373c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000373e:	00059783          	lh	a5,0(a1)
    80003742:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003746:	00259783          	lh	a5,2(a1)
    8000374a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000374e:	00459783          	lh	a5,4(a1)
    80003752:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003756:	00659783          	lh	a5,6(a1)
    8000375a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000375e:	459c                	lw	a5,8(a1)
    80003760:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003762:	03400613          	li	a2,52
    80003766:	05b1                	addi	a1,a1,12
    80003768:	05048513          	addi	a0,s1,80
    8000376c:	ffffd097          	auipc	ra,0xffffd
    80003770:	5c2080e7          	jalr	1474(ra) # 80000d2e <memmove>
    brelse(bp);
    80003774:	854a                	mv	a0,s2
    80003776:	00000097          	auipc	ra,0x0
    8000377a:	876080e7          	jalr	-1930(ra) # 80002fec <brelse>
    ip->valid = 1;
    8000377e:	4785                	li	a5,1
    80003780:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003782:	04449783          	lh	a5,68(s1)
    80003786:	fbb5                	bnez	a5,800036fa <ilock+0x24>
      panic("ilock: no type");
    80003788:	00005517          	auipc	a0,0x5
    8000378c:	e6850513          	addi	a0,a0,-408 # 800085f0 <syscalls+0x190>
    80003790:	ffffd097          	auipc	ra,0xffffd
    80003794:	dae080e7          	jalr	-594(ra) # 8000053e <panic>

0000000080003798 <iunlock>:
{
    80003798:	1101                	addi	sp,sp,-32
    8000379a:	ec06                	sd	ra,24(sp)
    8000379c:	e822                	sd	s0,16(sp)
    8000379e:	e426                	sd	s1,8(sp)
    800037a0:	e04a                	sd	s2,0(sp)
    800037a2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037a4:	c905                	beqz	a0,800037d4 <iunlock+0x3c>
    800037a6:	84aa                	mv	s1,a0
    800037a8:	01050913          	addi	s2,a0,16
    800037ac:	854a                	mv	a0,s2
    800037ae:	00001097          	auipc	ra,0x1
    800037b2:	c7c080e7          	jalr	-900(ra) # 8000442a <holdingsleep>
    800037b6:	cd19                	beqz	a0,800037d4 <iunlock+0x3c>
    800037b8:	449c                	lw	a5,8(s1)
    800037ba:	00f05d63          	blez	a5,800037d4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800037be:	854a                	mv	a0,s2
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	c26080e7          	jalr	-986(ra) # 800043e6 <releasesleep>
}
    800037c8:	60e2                	ld	ra,24(sp)
    800037ca:	6442                	ld	s0,16(sp)
    800037cc:	64a2                	ld	s1,8(sp)
    800037ce:	6902                	ld	s2,0(sp)
    800037d0:	6105                	addi	sp,sp,32
    800037d2:	8082                	ret
    panic("iunlock");
    800037d4:	00005517          	auipc	a0,0x5
    800037d8:	e2c50513          	addi	a0,a0,-468 # 80008600 <syscalls+0x1a0>
    800037dc:	ffffd097          	auipc	ra,0xffffd
    800037e0:	d62080e7          	jalr	-670(ra) # 8000053e <panic>

00000000800037e4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800037e4:	7179                	addi	sp,sp,-48
    800037e6:	f406                	sd	ra,40(sp)
    800037e8:	f022                	sd	s0,32(sp)
    800037ea:	ec26                	sd	s1,24(sp)
    800037ec:	e84a                	sd	s2,16(sp)
    800037ee:	e44e                	sd	s3,8(sp)
    800037f0:	e052                	sd	s4,0(sp)
    800037f2:	1800                	addi	s0,sp,48
    800037f4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800037f6:	05050493          	addi	s1,a0,80
    800037fa:	08050913          	addi	s2,a0,128
    800037fe:	a021                	j	80003806 <itrunc+0x22>
    80003800:	0491                	addi	s1,s1,4
    80003802:	01248d63          	beq	s1,s2,8000381c <itrunc+0x38>
    if(ip->addrs[i]){
    80003806:	408c                	lw	a1,0(s1)
    80003808:	dde5                	beqz	a1,80003800 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000380a:	0009a503          	lw	a0,0(s3)
    8000380e:	00000097          	auipc	ra,0x0
    80003812:	8f4080e7          	jalr	-1804(ra) # 80003102 <bfree>
      ip->addrs[i] = 0;
    80003816:	0004a023          	sw	zero,0(s1)
    8000381a:	b7dd                	j	80003800 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000381c:	0809a583          	lw	a1,128(s3)
    80003820:	e185                	bnez	a1,80003840 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003822:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003826:	854e                	mv	a0,s3
    80003828:	00000097          	auipc	ra,0x0
    8000382c:	de4080e7          	jalr	-540(ra) # 8000360c <iupdate>
}
    80003830:	70a2                	ld	ra,40(sp)
    80003832:	7402                	ld	s0,32(sp)
    80003834:	64e2                	ld	s1,24(sp)
    80003836:	6942                	ld	s2,16(sp)
    80003838:	69a2                	ld	s3,8(sp)
    8000383a:	6a02                	ld	s4,0(sp)
    8000383c:	6145                	addi	sp,sp,48
    8000383e:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003840:	0009a503          	lw	a0,0(s3)
    80003844:	fffff097          	auipc	ra,0xfffff
    80003848:	678080e7          	jalr	1656(ra) # 80002ebc <bread>
    8000384c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000384e:	05850493          	addi	s1,a0,88
    80003852:	45850913          	addi	s2,a0,1112
    80003856:	a021                	j	8000385e <itrunc+0x7a>
    80003858:	0491                	addi	s1,s1,4
    8000385a:	01248b63          	beq	s1,s2,80003870 <itrunc+0x8c>
      if(a[j])
    8000385e:	408c                	lw	a1,0(s1)
    80003860:	dde5                	beqz	a1,80003858 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003862:	0009a503          	lw	a0,0(s3)
    80003866:	00000097          	auipc	ra,0x0
    8000386a:	89c080e7          	jalr	-1892(ra) # 80003102 <bfree>
    8000386e:	b7ed                	j	80003858 <itrunc+0x74>
    brelse(bp);
    80003870:	8552                	mv	a0,s4
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	77a080e7          	jalr	1914(ra) # 80002fec <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000387a:	0809a583          	lw	a1,128(s3)
    8000387e:	0009a503          	lw	a0,0(s3)
    80003882:	00000097          	auipc	ra,0x0
    80003886:	880080e7          	jalr	-1920(ra) # 80003102 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000388a:	0809a023          	sw	zero,128(s3)
    8000388e:	bf51                	j	80003822 <itrunc+0x3e>

0000000080003890 <iput>:
{
    80003890:	1101                	addi	sp,sp,-32
    80003892:	ec06                	sd	ra,24(sp)
    80003894:	e822                	sd	s0,16(sp)
    80003896:	e426                	sd	s1,8(sp)
    80003898:	e04a                	sd	s2,0(sp)
    8000389a:	1000                	addi	s0,sp,32
    8000389c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000389e:	0001c517          	auipc	a0,0x1c
    800038a2:	ffa50513          	addi	a0,a0,-6 # 8001f898 <itable>
    800038a6:	ffffd097          	auipc	ra,0xffffd
    800038aa:	330080e7          	jalr	816(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038ae:	4498                	lw	a4,8(s1)
    800038b0:	4785                	li	a5,1
    800038b2:	02f70363          	beq	a4,a5,800038d8 <iput+0x48>
  ip->ref--;
    800038b6:	449c                	lw	a5,8(s1)
    800038b8:	37fd                	addiw	a5,a5,-1
    800038ba:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800038bc:	0001c517          	auipc	a0,0x1c
    800038c0:	fdc50513          	addi	a0,a0,-36 # 8001f898 <itable>
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	3c6080e7          	jalr	966(ra) # 80000c8a <release>
}
    800038cc:	60e2                	ld	ra,24(sp)
    800038ce:	6442                	ld	s0,16(sp)
    800038d0:	64a2                	ld	s1,8(sp)
    800038d2:	6902                	ld	s2,0(sp)
    800038d4:	6105                	addi	sp,sp,32
    800038d6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038d8:	40bc                	lw	a5,64(s1)
    800038da:	dff1                	beqz	a5,800038b6 <iput+0x26>
    800038dc:	04a49783          	lh	a5,74(s1)
    800038e0:	fbf9                	bnez	a5,800038b6 <iput+0x26>
    acquiresleep(&ip->lock);
    800038e2:	01048913          	addi	s2,s1,16
    800038e6:	854a                	mv	a0,s2
    800038e8:	00001097          	auipc	ra,0x1
    800038ec:	aa8080e7          	jalr	-1368(ra) # 80004390 <acquiresleep>
    release(&itable.lock);
    800038f0:	0001c517          	auipc	a0,0x1c
    800038f4:	fa850513          	addi	a0,a0,-88 # 8001f898 <itable>
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	392080e7          	jalr	914(ra) # 80000c8a <release>
    itrunc(ip);
    80003900:	8526                	mv	a0,s1
    80003902:	00000097          	auipc	ra,0x0
    80003906:	ee2080e7          	jalr	-286(ra) # 800037e4 <itrunc>
    ip->type = 0;
    8000390a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000390e:	8526                	mv	a0,s1
    80003910:	00000097          	auipc	ra,0x0
    80003914:	cfc080e7          	jalr	-772(ra) # 8000360c <iupdate>
    ip->valid = 0;
    80003918:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000391c:	854a                	mv	a0,s2
    8000391e:	00001097          	auipc	ra,0x1
    80003922:	ac8080e7          	jalr	-1336(ra) # 800043e6 <releasesleep>
    acquire(&itable.lock);
    80003926:	0001c517          	auipc	a0,0x1c
    8000392a:	f7250513          	addi	a0,a0,-142 # 8001f898 <itable>
    8000392e:	ffffd097          	auipc	ra,0xffffd
    80003932:	2a8080e7          	jalr	680(ra) # 80000bd6 <acquire>
    80003936:	b741                	j	800038b6 <iput+0x26>

0000000080003938 <iunlockput>:
{
    80003938:	1101                	addi	sp,sp,-32
    8000393a:	ec06                	sd	ra,24(sp)
    8000393c:	e822                	sd	s0,16(sp)
    8000393e:	e426                	sd	s1,8(sp)
    80003940:	1000                	addi	s0,sp,32
    80003942:	84aa                	mv	s1,a0
  iunlock(ip);
    80003944:	00000097          	auipc	ra,0x0
    80003948:	e54080e7          	jalr	-428(ra) # 80003798 <iunlock>
  iput(ip);
    8000394c:	8526                	mv	a0,s1
    8000394e:	00000097          	auipc	ra,0x0
    80003952:	f42080e7          	jalr	-190(ra) # 80003890 <iput>
}
    80003956:	60e2                	ld	ra,24(sp)
    80003958:	6442                	ld	s0,16(sp)
    8000395a:	64a2                	ld	s1,8(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003960:	1141                	addi	sp,sp,-16
    80003962:	e422                	sd	s0,8(sp)
    80003964:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003966:	411c                	lw	a5,0(a0)
    80003968:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000396a:	415c                	lw	a5,4(a0)
    8000396c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000396e:	04451783          	lh	a5,68(a0)
    80003972:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003976:	04a51783          	lh	a5,74(a0)
    8000397a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000397e:	04c56783          	lwu	a5,76(a0)
    80003982:	e99c                	sd	a5,16(a1)
}
    80003984:	6422                	ld	s0,8(sp)
    80003986:	0141                	addi	sp,sp,16
    80003988:	8082                	ret

000000008000398a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000398a:	457c                	lw	a5,76(a0)
    8000398c:	0ed7e963          	bltu	a5,a3,80003a7e <readi+0xf4>
{
    80003990:	7159                	addi	sp,sp,-112
    80003992:	f486                	sd	ra,104(sp)
    80003994:	f0a2                	sd	s0,96(sp)
    80003996:	eca6                	sd	s1,88(sp)
    80003998:	e8ca                	sd	s2,80(sp)
    8000399a:	e4ce                	sd	s3,72(sp)
    8000399c:	e0d2                	sd	s4,64(sp)
    8000399e:	fc56                	sd	s5,56(sp)
    800039a0:	f85a                	sd	s6,48(sp)
    800039a2:	f45e                	sd	s7,40(sp)
    800039a4:	f062                	sd	s8,32(sp)
    800039a6:	ec66                	sd	s9,24(sp)
    800039a8:	e86a                	sd	s10,16(sp)
    800039aa:	e46e                	sd	s11,8(sp)
    800039ac:	1880                	addi	s0,sp,112
    800039ae:	8b2a                	mv	s6,a0
    800039b0:	8bae                	mv	s7,a1
    800039b2:	8a32                	mv	s4,a2
    800039b4:	84b6                	mv	s1,a3
    800039b6:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800039b8:	9f35                	addw	a4,a4,a3
    return 0;
    800039ba:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800039bc:	0ad76063          	bltu	a4,a3,80003a5c <readi+0xd2>
  if(off + n > ip->size)
    800039c0:	00e7f463          	bgeu	a5,a4,800039c8 <readi+0x3e>
    n = ip->size - off;
    800039c4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039c8:	0a0a8963          	beqz	s5,80003a7a <readi+0xf0>
    800039cc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039ce:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800039d2:	5c7d                	li	s8,-1
    800039d4:	a82d                	j	80003a0e <readi+0x84>
    800039d6:	020d1d93          	slli	s11,s10,0x20
    800039da:	020ddd93          	srli	s11,s11,0x20
    800039de:	05890793          	addi	a5,s2,88
    800039e2:	86ee                	mv	a3,s11
    800039e4:	963e                	add	a2,a2,a5
    800039e6:	85d2                	mv	a1,s4
    800039e8:	855e                	mv	a0,s7
    800039ea:	fffff097          	auipc	ra,0xfffff
    800039ee:	aca080e7          	jalr	-1334(ra) # 800024b4 <either_copyout>
    800039f2:	05850d63          	beq	a0,s8,80003a4c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800039f6:	854a                	mv	a0,s2
    800039f8:	fffff097          	auipc	ra,0xfffff
    800039fc:	5f4080e7          	jalr	1524(ra) # 80002fec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a00:	013d09bb          	addw	s3,s10,s3
    80003a04:	009d04bb          	addw	s1,s10,s1
    80003a08:	9a6e                	add	s4,s4,s11
    80003a0a:	0559f763          	bgeu	s3,s5,80003a58 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003a0e:	00a4d59b          	srliw	a1,s1,0xa
    80003a12:	855a                	mv	a0,s6
    80003a14:	00000097          	auipc	ra,0x0
    80003a18:	8a2080e7          	jalr	-1886(ra) # 800032b6 <bmap>
    80003a1c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a20:	cd85                	beqz	a1,80003a58 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003a22:	000b2503          	lw	a0,0(s6)
    80003a26:	fffff097          	auipc	ra,0xfffff
    80003a2a:	496080e7          	jalr	1174(ra) # 80002ebc <bread>
    80003a2e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a30:	3ff4f613          	andi	a2,s1,1023
    80003a34:	40cc87bb          	subw	a5,s9,a2
    80003a38:	413a873b          	subw	a4,s5,s3
    80003a3c:	8d3e                	mv	s10,a5
    80003a3e:	2781                	sext.w	a5,a5
    80003a40:	0007069b          	sext.w	a3,a4
    80003a44:	f8f6f9e3          	bgeu	a3,a5,800039d6 <readi+0x4c>
    80003a48:	8d3a                	mv	s10,a4
    80003a4a:	b771                	j	800039d6 <readi+0x4c>
      brelse(bp);
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	fffff097          	auipc	ra,0xfffff
    80003a52:	59e080e7          	jalr	1438(ra) # 80002fec <brelse>
      tot = -1;
    80003a56:	59fd                	li	s3,-1
  }
  return tot;
    80003a58:	0009851b          	sext.w	a0,s3
}
    80003a5c:	70a6                	ld	ra,104(sp)
    80003a5e:	7406                	ld	s0,96(sp)
    80003a60:	64e6                	ld	s1,88(sp)
    80003a62:	6946                	ld	s2,80(sp)
    80003a64:	69a6                	ld	s3,72(sp)
    80003a66:	6a06                	ld	s4,64(sp)
    80003a68:	7ae2                	ld	s5,56(sp)
    80003a6a:	7b42                	ld	s6,48(sp)
    80003a6c:	7ba2                	ld	s7,40(sp)
    80003a6e:	7c02                	ld	s8,32(sp)
    80003a70:	6ce2                	ld	s9,24(sp)
    80003a72:	6d42                	ld	s10,16(sp)
    80003a74:	6da2                	ld	s11,8(sp)
    80003a76:	6165                	addi	sp,sp,112
    80003a78:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a7a:	89d6                	mv	s3,s5
    80003a7c:	bff1                	j	80003a58 <readi+0xce>
    return 0;
    80003a7e:	4501                	li	a0,0
}
    80003a80:	8082                	ret

0000000080003a82 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a82:	457c                	lw	a5,76(a0)
    80003a84:	10d7e863          	bltu	a5,a3,80003b94 <writei+0x112>
{
    80003a88:	7159                	addi	sp,sp,-112
    80003a8a:	f486                	sd	ra,104(sp)
    80003a8c:	f0a2                	sd	s0,96(sp)
    80003a8e:	eca6                	sd	s1,88(sp)
    80003a90:	e8ca                	sd	s2,80(sp)
    80003a92:	e4ce                	sd	s3,72(sp)
    80003a94:	e0d2                	sd	s4,64(sp)
    80003a96:	fc56                	sd	s5,56(sp)
    80003a98:	f85a                	sd	s6,48(sp)
    80003a9a:	f45e                	sd	s7,40(sp)
    80003a9c:	f062                	sd	s8,32(sp)
    80003a9e:	ec66                	sd	s9,24(sp)
    80003aa0:	e86a                	sd	s10,16(sp)
    80003aa2:	e46e                	sd	s11,8(sp)
    80003aa4:	1880                	addi	s0,sp,112
    80003aa6:	8aaa                	mv	s5,a0
    80003aa8:	8bae                	mv	s7,a1
    80003aaa:	8a32                	mv	s4,a2
    80003aac:	8936                	mv	s2,a3
    80003aae:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ab0:	00e687bb          	addw	a5,a3,a4
    80003ab4:	0ed7e263          	bltu	a5,a3,80003b98 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003ab8:	00043737          	lui	a4,0x43
    80003abc:	0ef76063          	bltu	a4,a5,80003b9c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ac0:	0c0b0863          	beqz	s6,80003b90 <writei+0x10e>
    80003ac4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ac6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003aca:	5c7d                	li	s8,-1
    80003acc:	a091                	j	80003b10 <writei+0x8e>
    80003ace:	020d1d93          	slli	s11,s10,0x20
    80003ad2:	020ddd93          	srli	s11,s11,0x20
    80003ad6:	05848793          	addi	a5,s1,88
    80003ada:	86ee                	mv	a3,s11
    80003adc:	8652                	mv	a2,s4
    80003ade:	85de                	mv	a1,s7
    80003ae0:	953e                	add	a0,a0,a5
    80003ae2:	fffff097          	auipc	ra,0xfffff
    80003ae6:	a28080e7          	jalr	-1496(ra) # 8000250a <either_copyin>
    80003aea:	07850263          	beq	a0,s8,80003b4e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003aee:	8526                	mv	a0,s1
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	780080e7          	jalr	1920(ra) # 80004270 <log_write>
    brelse(bp);
    80003af8:	8526                	mv	a0,s1
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	4f2080e7          	jalr	1266(ra) # 80002fec <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b02:	013d09bb          	addw	s3,s10,s3
    80003b06:	012d093b          	addw	s2,s10,s2
    80003b0a:	9a6e                	add	s4,s4,s11
    80003b0c:	0569f663          	bgeu	s3,s6,80003b58 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003b10:	00a9559b          	srliw	a1,s2,0xa
    80003b14:	8556                	mv	a0,s5
    80003b16:	fffff097          	auipc	ra,0xfffff
    80003b1a:	7a0080e7          	jalr	1952(ra) # 800032b6 <bmap>
    80003b1e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b22:	c99d                	beqz	a1,80003b58 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003b24:	000aa503          	lw	a0,0(s5)
    80003b28:	fffff097          	auipc	ra,0xfffff
    80003b2c:	394080e7          	jalr	916(ra) # 80002ebc <bread>
    80003b30:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b32:	3ff97513          	andi	a0,s2,1023
    80003b36:	40ac87bb          	subw	a5,s9,a0
    80003b3a:	413b073b          	subw	a4,s6,s3
    80003b3e:	8d3e                	mv	s10,a5
    80003b40:	2781                	sext.w	a5,a5
    80003b42:	0007069b          	sext.w	a3,a4
    80003b46:	f8f6f4e3          	bgeu	a3,a5,80003ace <writei+0x4c>
    80003b4a:	8d3a                	mv	s10,a4
    80003b4c:	b749                	j	80003ace <writei+0x4c>
      brelse(bp);
    80003b4e:	8526                	mv	a0,s1
    80003b50:	fffff097          	auipc	ra,0xfffff
    80003b54:	49c080e7          	jalr	1180(ra) # 80002fec <brelse>
  }

  if(off > ip->size)
    80003b58:	04caa783          	lw	a5,76(s5)
    80003b5c:	0127f463          	bgeu	a5,s2,80003b64 <writei+0xe2>
    ip->size = off;
    80003b60:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003b64:	8556                	mv	a0,s5
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	aa6080e7          	jalr	-1370(ra) # 8000360c <iupdate>

  return tot;
    80003b6e:	0009851b          	sext.w	a0,s3
}
    80003b72:	70a6                	ld	ra,104(sp)
    80003b74:	7406                	ld	s0,96(sp)
    80003b76:	64e6                	ld	s1,88(sp)
    80003b78:	6946                	ld	s2,80(sp)
    80003b7a:	69a6                	ld	s3,72(sp)
    80003b7c:	6a06                	ld	s4,64(sp)
    80003b7e:	7ae2                	ld	s5,56(sp)
    80003b80:	7b42                	ld	s6,48(sp)
    80003b82:	7ba2                	ld	s7,40(sp)
    80003b84:	7c02                	ld	s8,32(sp)
    80003b86:	6ce2                	ld	s9,24(sp)
    80003b88:	6d42                	ld	s10,16(sp)
    80003b8a:	6da2                	ld	s11,8(sp)
    80003b8c:	6165                	addi	sp,sp,112
    80003b8e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b90:	89da                	mv	s3,s6
    80003b92:	bfc9                	j	80003b64 <writei+0xe2>
    return -1;
    80003b94:	557d                	li	a0,-1
}
    80003b96:	8082                	ret
    return -1;
    80003b98:	557d                	li	a0,-1
    80003b9a:	bfe1                	j	80003b72 <writei+0xf0>
    return -1;
    80003b9c:	557d                	li	a0,-1
    80003b9e:	bfd1                	j	80003b72 <writei+0xf0>

0000000080003ba0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003ba0:	1141                	addi	sp,sp,-16
    80003ba2:	e406                	sd	ra,8(sp)
    80003ba4:	e022                	sd	s0,0(sp)
    80003ba6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ba8:	4639                	li	a2,14
    80003baa:	ffffd097          	auipc	ra,0xffffd
    80003bae:	1f8080e7          	jalr	504(ra) # 80000da2 <strncmp>
}
    80003bb2:	60a2                	ld	ra,8(sp)
    80003bb4:	6402                	ld	s0,0(sp)
    80003bb6:	0141                	addi	sp,sp,16
    80003bb8:	8082                	ret

0000000080003bba <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bba:	7139                	addi	sp,sp,-64
    80003bbc:	fc06                	sd	ra,56(sp)
    80003bbe:	f822                	sd	s0,48(sp)
    80003bc0:	f426                	sd	s1,40(sp)
    80003bc2:	f04a                	sd	s2,32(sp)
    80003bc4:	ec4e                	sd	s3,24(sp)
    80003bc6:	e852                	sd	s4,16(sp)
    80003bc8:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003bca:	04451703          	lh	a4,68(a0)
    80003bce:	4785                	li	a5,1
    80003bd0:	00f71a63          	bne	a4,a5,80003be4 <dirlookup+0x2a>
    80003bd4:	892a                	mv	s2,a0
    80003bd6:	89ae                	mv	s3,a1
    80003bd8:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003bda:	457c                	lw	a5,76(a0)
    80003bdc:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003bde:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003be0:	e79d                	bnez	a5,80003c0e <dirlookup+0x54>
    80003be2:	a8a5                	j	80003c5a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003be4:	00005517          	auipc	a0,0x5
    80003be8:	a2450513          	addi	a0,a0,-1500 # 80008608 <syscalls+0x1a8>
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	952080e7          	jalr	-1710(ra) # 8000053e <panic>
      panic("dirlookup read");
    80003bf4:	00005517          	auipc	a0,0x5
    80003bf8:	a2c50513          	addi	a0,a0,-1492 # 80008620 <syscalls+0x1c0>
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	942080e7          	jalr	-1726(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c04:	24c1                	addiw	s1,s1,16
    80003c06:	04c92783          	lw	a5,76(s2)
    80003c0a:	04f4f763          	bgeu	s1,a5,80003c58 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c0e:	4741                	li	a4,16
    80003c10:	86a6                	mv	a3,s1
    80003c12:	fc040613          	addi	a2,s0,-64
    80003c16:	4581                	li	a1,0
    80003c18:	854a                	mv	a0,s2
    80003c1a:	00000097          	auipc	ra,0x0
    80003c1e:	d70080e7          	jalr	-656(ra) # 8000398a <readi>
    80003c22:	47c1                	li	a5,16
    80003c24:	fcf518e3          	bne	a0,a5,80003bf4 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c28:	fc045783          	lhu	a5,-64(s0)
    80003c2c:	dfe1                	beqz	a5,80003c04 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c2e:	fc240593          	addi	a1,s0,-62
    80003c32:	854e                	mv	a0,s3
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	f6c080e7          	jalr	-148(ra) # 80003ba0 <namecmp>
    80003c3c:	f561                	bnez	a0,80003c04 <dirlookup+0x4a>
      if(poff)
    80003c3e:	000a0463          	beqz	s4,80003c46 <dirlookup+0x8c>
        *poff = off;
    80003c42:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c46:	fc045583          	lhu	a1,-64(s0)
    80003c4a:	00092503          	lw	a0,0(s2)
    80003c4e:	fffff097          	auipc	ra,0xfffff
    80003c52:	750080e7          	jalr	1872(ra) # 8000339e <iget>
    80003c56:	a011                	j	80003c5a <dirlookup+0xa0>
  return 0;
    80003c58:	4501                	li	a0,0
}
    80003c5a:	70e2                	ld	ra,56(sp)
    80003c5c:	7442                	ld	s0,48(sp)
    80003c5e:	74a2                	ld	s1,40(sp)
    80003c60:	7902                	ld	s2,32(sp)
    80003c62:	69e2                	ld	s3,24(sp)
    80003c64:	6a42                	ld	s4,16(sp)
    80003c66:	6121                	addi	sp,sp,64
    80003c68:	8082                	ret

0000000080003c6a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003c6a:	711d                	addi	sp,sp,-96
    80003c6c:	ec86                	sd	ra,88(sp)
    80003c6e:	e8a2                	sd	s0,80(sp)
    80003c70:	e4a6                	sd	s1,72(sp)
    80003c72:	e0ca                	sd	s2,64(sp)
    80003c74:	fc4e                	sd	s3,56(sp)
    80003c76:	f852                	sd	s4,48(sp)
    80003c78:	f456                	sd	s5,40(sp)
    80003c7a:	f05a                	sd	s6,32(sp)
    80003c7c:	ec5e                	sd	s7,24(sp)
    80003c7e:	e862                	sd	s8,16(sp)
    80003c80:	e466                	sd	s9,8(sp)
    80003c82:	1080                	addi	s0,sp,96
    80003c84:	84aa                	mv	s1,a0
    80003c86:	8aae                	mv	s5,a1
    80003c88:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003c8a:	00054703          	lbu	a4,0(a0)
    80003c8e:	02f00793          	li	a5,47
    80003c92:	02f70363          	beq	a4,a5,80003cb8 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003c96:	ffffe097          	auipc	ra,0xffffe
    80003c9a:	d16080e7          	jalr	-746(ra) # 800019ac <myproc>
    80003c9e:	17053503          	ld	a0,368(a0)
    80003ca2:	00000097          	auipc	ra,0x0
    80003ca6:	9f6080e7          	jalr	-1546(ra) # 80003698 <idup>
    80003caa:	89aa                	mv	s3,a0
  while(*path == '/')
    80003cac:	02f00913          	li	s2,47
  len = path - s;
    80003cb0:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003cb2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003cb4:	4b85                	li	s7,1
    80003cb6:	a865                	j	80003d6e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003cb8:	4585                	li	a1,1
    80003cba:	4505                	li	a0,1
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	6e2080e7          	jalr	1762(ra) # 8000339e <iget>
    80003cc4:	89aa                	mv	s3,a0
    80003cc6:	b7dd                	j	80003cac <namex+0x42>
      iunlockput(ip);
    80003cc8:	854e                	mv	a0,s3
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	c6e080e7          	jalr	-914(ra) # 80003938 <iunlockput>
      return 0;
    80003cd2:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003cd4:	854e                	mv	a0,s3
    80003cd6:	60e6                	ld	ra,88(sp)
    80003cd8:	6446                	ld	s0,80(sp)
    80003cda:	64a6                	ld	s1,72(sp)
    80003cdc:	6906                	ld	s2,64(sp)
    80003cde:	79e2                	ld	s3,56(sp)
    80003ce0:	7a42                	ld	s4,48(sp)
    80003ce2:	7aa2                	ld	s5,40(sp)
    80003ce4:	7b02                	ld	s6,32(sp)
    80003ce6:	6be2                	ld	s7,24(sp)
    80003ce8:	6c42                	ld	s8,16(sp)
    80003cea:	6ca2                	ld	s9,8(sp)
    80003cec:	6125                	addi	sp,sp,96
    80003cee:	8082                	ret
      iunlock(ip);
    80003cf0:	854e                	mv	a0,s3
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	aa6080e7          	jalr	-1370(ra) # 80003798 <iunlock>
      return ip;
    80003cfa:	bfe9                	j	80003cd4 <namex+0x6a>
      iunlockput(ip);
    80003cfc:	854e                	mv	a0,s3
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	c3a080e7          	jalr	-966(ra) # 80003938 <iunlockput>
      return 0;
    80003d06:	89e6                	mv	s3,s9
    80003d08:	b7f1                	j	80003cd4 <namex+0x6a>
  len = path - s;
    80003d0a:	40b48633          	sub	a2,s1,a1
    80003d0e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d12:	099c5463          	bge	s8,s9,80003d9a <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d16:	4639                	li	a2,14
    80003d18:	8552                	mv	a0,s4
    80003d1a:	ffffd097          	auipc	ra,0xffffd
    80003d1e:	014080e7          	jalr	20(ra) # 80000d2e <memmove>
  while(*path == '/')
    80003d22:	0004c783          	lbu	a5,0(s1)
    80003d26:	01279763          	bne	a5,s2,80003d34 <namex+0xca>
    path++;
    80003d2a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d2c:	0004c783          	lbu	a5,0(s1)
    80003d30:	ff278de3          	beq	a5,s2,80003d2a <namex+0xc0>
    ilock(ip);
    80003d34:	854e                	mv	a0,s3
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	9a0080e7          	jalr	-1632(ra) # 800036d6 <ilock>
    if(ip->type != T_DIR){
    80003d3e:	04499783          	lh	a5,68(s3)
    80003d42:	f97793e3          	bne	a5,s7,80003cc8 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d46:	000a8563          	beqz	s5,80003d50 <namex+0xe6>
    80003d4a:	0004c783          	lbu	a5,0(s1)
    80003d4e:	d3cd                	beqz	a5,80003cf0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d50:	865a                	mv	a2,s6
    80003d52:	85d2                	mv	a1,s4
    80003d54:	854e                	mv	a0,s3
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	e64080e7          	jalr	-412(ra) # 80003bba <dirlookup>
    80003d5e:	8caa                	mv	s9,a0
    80003d60:	dd51                	beqz	a0,80003cfc <namex+0x92>
    iunlockput(ip);
    80003d62:	854e                	mv	a0,s3
    80003d64:	00000097          	auipc	ra,0x0
    80003d68:	bd4080e7          	jalr	-1068(ra) # 80003938 <iunlockput>
    ip = next;
    80003d6c:	89e6                	mv	s3,s9
  while(*path == '/')
    80003d6e:	0004c783          	lbu	a5,0(s1)
    80003d72:	05279763          	bne	a5,s2,80003dc0 <namex+0x156>
    path++;
    80003d76:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d78:	0004c783          	lbu	a5,0(s1)
    80003d7c:	ff278de3          	beq	a5,s2,80003d76 <namex+0x10c>
  if(*path == 0)
    80003d80:	c79d                	beqz	a5,80003dae <namex+0x144>
    path++;
    80003d82:	85a6                	mv	a1,s1
  len = path - s;
    80003d84:	8cda                	mv	s9,s6
    80003d86:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003d88:	01278963          	beq	a5,s2,80003d9a <namex+0x130>
    80003d8c:	dfbd                	beqz	a5,80003d0a <namex+0xa0>
    path++;
    80003d8e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003d90:	0004c783          	lbu	a5,0(s1)
    80003d94:	ff279ce3          	bne	a5,s2,80003d8c <namex+0x122>
    80003d98:	bf8d                	j	80003d0a <namex+0xa0>
    memmove(name, s, len);
    80003d9a:	2601                	sext.w	a2,a2
    80003d9c:	8552                	mv	a0,s4
    80003d9e:	ffffd097          	auipc	ra,0xffffd
    80003da2:	f90080e7          	jalr	-112(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003da6:	9cd2                	add	s9,s9,s4
    80003da8:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003dac:	bf9d                	j	80003d22 <namex+0xb8>
  if(nameiparent){
    80003dae:	f20a83e3          	beqz	s5,80003cd4 <namex+0x6a>
    iput(ip);
    80003db2:	854e                	mv	a0,s3
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	adc080e7          	jalr	-1316(ra) # 80003890 <iput>
    return 0;
    80003dbc:	4981                	li	s3,0
    80003dbe:	bf19                	j	80003cd4 <namex+0x6a>
  if(*path == 0)
    80003dc0:	d7fd                	beqz	a5,80003dae <namex+0x144>
  while(*path != '/' && *path != 0)
    80003dc2:	0004c783          	lbu	a5,0(s1)
    80003dc6:	85a6                	mv	a1,s1
    80003dc8:	b7d1                	j	80003d8c <namex+0x122>

0000000080003dca <dirlink>:
{
    80003dca:	7139                	addi	sp,sp,-64
    80003dcc:	fc06                	sd	ra,56(sp)
    80003dce:	f822                	sd	s0,48(sp)
    80003dd0:	f426                	sd	s1,40(sp)
    80003dd2:	f04a                	sd	s2,32(sp)
    80003dd4:	ec4e                	sd	s3,24(sp)
    80003dd6:	e852                	sd	s4,16(sp)
    80003dd8:	0080                	addi	s0,sp,64
    80003dda:	892a                	mv	s2,a0
    80003ddc:	8a2e                	mv	s4,a1
    80003dde:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003de0:	4601                	li	a2,0
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	dd8080e7          	jalr	-552(ra) # 80003bba <dirlookup>
    80003dea:	e93d                	bnez	a0,80003e60 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003dec:	04c92483          	lw	s1,76(s2)
    80003df0:	c49d                	beqz	s1,80003e1e <dirlink+0x54>
    80003df2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003df4:	4741                	li	a4,16
    80003df6:	86a6                	mv	a3,s1
    80003df8:	fc040613          	addi	a2,s0,-64
    80003dfc:	4581                	li	a1,0
    80003dfe:	854a                	mv	a0,s2
    80003e00:	00000097          	auipc	ra,0x0
    80003e04:	b8a080e7          	jalr	-1142(ra) # 8000398a <readi>
    80003e08:	47c1                	li	a5,16
    80003e0a:	06f51163          	bne	a0,a5,80003e6c <dirlink+0xa2>
    if(de.inum == 0)
    80003e0e:	fc045783          	lhu	a5,-64(s0)
    80003e12:	c791                	beqz	a5,80003e1e <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e14:	24c1                	addiw	s1,s1,16
    80003e16:	04c92783          	lw	a5,76(s2)
    80003e1a:	fcf4ede3          	bltu	s1,a5,80003df4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e1e:	4639                	li	a2,14
    80003e20:	85d2                	mv	a1,s4
    80003e22:	fc240513          	addi	a0,s0,-62
    80003e26:	ffffd097          	auipc	ra,0xffffd
    80003e2a:	fb8080e7          	jalr	-72(ra) # 80000dde <strncpy>
  de.inum = inum;
    80003e2e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e32:	4741                	li	a4,16
    80003e34:	86a6                	mv	a3,s1
    80003e36:	fc040613          	addi	a2,s0,-64
    80003e3a:	4581                	li	a1,0
    80003e3c:	854a                	mv	a0,s2
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	c44080e7          	jalr	-956(ra) # 80003a82 <writei>
    80003e46:	1541                	addi	a0,a0,-16
    80003e48:	00a03533          	snez	a0,a0
    80003e4c:	40a00533          	neg	a0,a0
}
    80003e50:	70e2                	ld	ra,56(sp)
    80003e52:	7442                	ld	s0,48(sp)
    80003e54:	74a2                	ld	s1,40(sp)
    80003e56:	7902                	ld	s2,32(sp)
    80003e58:	69e2                	ld	s3,24(sp)
    80003e5a:	6a42                	ld	s4,16(sp)
    80003e5c:	6121                	addi	sp,sp,64
    80003e5e:	8082                	ret
    iput(ip);
    80003e60:	00000097          	auipc	ra,0x0
    80003e64:	a30080e7          	jalr	-1488(ra) # 80003890 <iput>
    return -1;
    80003e68:	557d                	li	a0,-1
    80003e6a:	b7dd                	j	80003e50 <dirlink+0x86>
      panic("dirlink read");
    80003e6c:	00004517          	auipc	a0,0x4
    80003e70:	7c450513          	addi	a0,a0,1988 # 80008630 <syscalls+0x1d0>
    80003e74:	ffffc097          	auipc	ra,0xffffc
    80003e78:	6ca080e7          	jalr	1738(ra) # 8000053e <panic>

0000000080003e7c <namei>:

struct inode*
namei(char *path)
{
    80003e7c:	1101                	addi	sp,sp,-32
    80003e7e:	ec06                	sd	ra,24(sp)
    80003e80:	e822                	sd	s0,16(sp)
    80003e82:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003e84:	fe040613          	addi	a2,s0,-32
    80003e88:	4581                	li	a1,0
    80003e8a:	00000097          	auipc	ra,0x0
    80003e8e:	de0080e7          	jalr	-544(ra) # 80003c6a <namex>
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	6105                	addi	sp,sp,32
    80003e98:	8082                	ret

0000000080003e9a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003e9a:	1141                	addi	sp,sp,-16
    80003e9c:	e406                	sd	ra,8(sp)
    80003e9e:	e022                	sd	s0,0(sp)
    80003ea0:	0800                	addi	s0,sp,16
    80003ea2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ea4:	4585                	li	a1,1
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	dc4080e7          	jalr	-572(ra) # 80003c6a <namex>
}
    80003eae:	60a2                	ld	ra,8(sp)
    80003eb0:	6402                	ld	s0,0(sp)
    80003eb2:	0141                	addi	sp,sp,16
    80003eb4:	8082                	ret

0000000080003eb6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003eb6:	1101                	addi	sp,sp,-32
    80003eb8:	ec06                	sd	ra,24(sp)
    80003eba:	e822                	sd	s0,16(sp)
    80003ebc:	e426                	sd	s1,8(sp)
    80003ebe:	e04a                	sd	s2,0(sp)
    80003ec0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003ec2:	0001d917          	auipc	s2,0x1d
    80003ec6:	47e90913          	addi	s2,s2,1150 # 80021340 <log>
    80003eca:	01892583          	lw	a1,24(s2)
    80003ece:	02892503          	lw	a0,40(s2)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	fea080e7          	jalr	-22(ra) # 80002ebc <bread>
    80003eda:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003edc:	02c92683          	lw	a3,44(s2)
    80003ee0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ee2:	02d05763          	blez	a3,80003f10 <write_head+0x5a>
    80003ee6:	0001d797          	auipc	a5,0x1d
    80003eea:	48a78793          	addi	a5,a5,1162 # 80021370 <log+0x30>
    80003eee:	05c50713          	addi	a4,a0,92
    80003ef2:	36fd                	addiw	a3,a3,-1
    80003ef4:	1682                	slli	a3,a3,0x20
    80003ef6:	9281                	srli	a3,a3,0x20
    80003ef8:	068a                	slli	a3,a3,0x2
    80003efa:	0001d617          	auipc	a2,0x1d
    80003efe:	47a60613          	addi	a2,a2,1146 # 80021374 <log+0x34>
    80003f02:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f04:	4390                	lw	a2,0(a5)
    80003f06:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f08:	0791                	addi	a5,a5,4
    80003f0a:	0711                	addi	a4,a4,4
    80003f0c:	fed79ce3          	bne	a5,a3,80003f04 <write_head+0x4e>
  }
  bwrite(buf);
    80003f10:	8526                	mv	a0,s1
    80003f12:	fffff097          	auipc	ra,0xfffff
    80003f16:	09c080e7          	jalr	156(ra) # 80002fae <bwrite>
  brelse(buf);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	fffff097          	auipc	ra,0xfffff
    80003f20:	0d0080e7          	jalr	208(ra) # 80002fec <brelse>
}
    80003f24:	60e2                	ld	ra,24(sp)
    80003f26:	6442                	ld	s0,16(sp)
    80003f28:	64a2                	ld	s1,8(sp)
    80003f2a:	6902                	ld	s2,0(sp)
    80003f2c:	6105                	addi	sp,sp,32
    80003f2e:	8082                	ret

0000000080003f30 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f30:	0001d797          	auipc	a5,0x1d
    80003f34:	43c7a783          	lw	a5,1084(a5) # 8002136c <log+0x2c>
    80003f38:	0af05d63          	blez	a5,80003ff2 <install_trans+0xc2>
{
    80003f3c:	7139                	addi	sp,sp,-64
    80003f3e:	fc06                	sd	ra,56(sp)
    80003f40:	f822                	sd	s0,48(sp)
    80003f42:	f426                	sd	s1,40(sp)
    80003f44:	f04a                	sd	s2,32(sp)
    80003f46:	ec4e                	sd	s3,24(sp)
    80003f48:	e852                	sd	s4,16(sp)
    80003f4a:	e456                	sd	s5,8(sp)
    80003f4c:	e05a                	sd	s6,0(sp)
    80003f4e:	0080                	addi	s0,sp,64
    80003f50:	8b2a                	mv	s6,a0
    80003f52:	0001da97          	auipc	s5,0x1d
    80003f56:	41ea8a93          	addi	s5,s5,1054 # 80021370 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f5a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f5c:	0001d997          	auipc	s3,0x1d
    80003f60:	3e498993          	addi	s3,s3,996 # 80021340 <log>
    80003f64:	a00d                	j	80003f86 <install_trans+0x56>
    brelse(lbuf);
    80003f66:	854a                	mv	a0,s2
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	084080e7          	jalr	132(ra) # 80002fec <brelse>
    brelse(dbuf);
    80003f70:	8526                	mv	a0,s1
    80003f72:	fffff097          	auipc	ra,0xfffff
    80003f76:	07a080e7          	jalr	122(ra) # 80002fec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f7a:	2a05                	addiw	s4,s4,1
    80003f7c:	0a91                	addi	s5,s5,4
    80003f7e:	02c9a783          	lw	a5,44(s3)
    80003f82:	04fa5e63          	bge	s4,a5,80003fde <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003f86:	0189a583          	lw	a1,24(s3)
    80003f8a:	014585bb          	addw	a1,a1,s4
    80003f8e:	2585                	addiw	a1,a1,1
    80003f90:	0289a503          	lw	a0,40(s3)
    80003f94:	fffff097          	auipc	ra,0xfffff
    80003f98:	f28080e7          	jalr	-216(ra) # 80002ebc <bread>
    80003f9c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003f9e:	000aa583          	lw	a1,0(s5)
    80003fa2:	0289a503          	lw	a0,40(s3)
    80003fa6:	fffff097          	auipc	ra,0xfffff
    80003faa:	f16080e7          	jalr	-234(ra) # 80002ebc <bread>
    80003fae:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003fb0:	40000613          	li	a2,1024
    80003fb4:	05890593          	addi	a1,s2,88
    80003fb8:	05850513          	addi	a0,a0,88
    80003fbc:	ffffd097          	auipc	ra,0xffffd
    80003fc0:	d72080e7          	jalr	-654(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	fe8080e7          	jalr	-24(ra) # 80002fae <bwrite>
    if(recovering == 0)
    80003fce:	f80b1ce3          	bnez	s6,80003f66 <install_trans+0x36>
      bunpin(dbuf);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	fffff097          	auipc	ra,0xfffff
    80003fd8:	0f2080e7          	jalr	242(ra) # 800030c6 <bunpin>
    80003fdc:	b769                	j	80003f66 <install_trans+0x36>
}
    80003fde:	70e2                	ld	ra,56(sp)
    80003fe0:	7442                	ld	s0,48(sp)
    80003fe2:	74a2                	ld	s1,40(sp)
    80003fe4:	7902                	ld	s2,32(sp)
    80003fe6:	69e2                	ld	s3,24(sp)
    80003fe8:	6a42                	ld	s4,16(sp)
    80003fea:	6aa2                	ld	s5,8(sp)
    80003fec:	6b02                	ld	s6,0(sp)
    80003fee:	6121                	addi	sp,sp,64
    80003ff0:	8082                	ret
    80003ff2:	8082                	ret

0000000080003ff4 <initlog>:
{
    80003ff4:	7179                	addi	sp,sp,-48
    80003ff6:	f406                	sd	ra,40(sp)
    80003ff8:	f022                	sd	s0,32(sp)
    80003ffa:	ec26                	sd	s1,24(sp)
    80003ffc:	e84a                	sd	s2,16(sp)
    80003ffe:	e44e                	sd	s3,8(sp)
    80004000:	1800                	addi	s0,sp,48
    80004002:	892a                	mv	s2,a0
    80004004:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004006:	0001d497          	auipc	s1,0x1d
    8000400a:	33a48493          	addi	s1,s1,826 # 80021340 <log>
    8000400e:	00004597          	auipc	a1,0x4
    80004012:	63258593          	addi	a1,a1,1586 # 80008640 <syscalls+0x1e0>
    80004016:	8526                	mv	a0,s1
    80004018:	ffffd097          	auipc	ra,0xffffd
    8000401c:	b2e080e7          	jalr	-1234(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004020:	0149a583          	lw	a1,20(s3)
    80004024:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004026:	0109a783          	lw	a5,16(s3)
    8000402a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000402c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004030:	854a                	mv	a0,s2
    80004032:	fffff097          	auipc	ra,0xfffff
    80004036:	e8a080e7          	jalr	-374(ra) # 80002ebc <bread>
  log.lh.n = lh->n;
    8000403a:	4d34                	lw	a3,88(a0)
    8000403c:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000403e:	02d05563          	blez	a3,80004068 <initlog+0x74>
    80004042:	05c50793          	addi	a5,a0,92
    80004046:	0001d717          	auipc	a4,0x1d
    8000404a:	32a70713          	addi	a4,a4,810 # 80021370 <log+0x30>
    8000404e:	36fd                	addiw	a3,a3,-1
    80004050:	1682                	slli	a3,a3,0x20
    80004052:	9281                	srli	a3,a3,0x20
    80004054:	068a                	slli	a3,a3,0x2
    80004056:	06050613          	addi	a2,a0,96
    8000405a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000405c:	4390                	lw	a2,0(a5)
    8000405e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004060:	0791                	addi	a5,a5,4
    80004062:	0711                	addi	a4,a4,4
    80004064:	fed79ce3          	bne	a5,a3,8000405c <initlog+0x68>
  brelse(buf);
    80004068:	fffff097          	auipc	ra,0xfffff
    8000406c:	f84080e7          	jalr	-124(ra) # 80002fec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004070:	4505                	li	a0,1
    80004072:	00000097          	auipc	ra,0x0
    80004076:	ebe080e7          	jalr	-322(ra) # 80003f30 <install_trans>
  log.lh.n = 0;
    8000407a:	0001d797          	auipc	a5,0x1d
    8000407e:	2e07a923          	sw	zero,754(a5) # 8002136c <log+0x2c>
  write_head(); // clear the log
    80004082:	00000097          	auipc	ra,0x0
    80004086:	e34080e7          	jalr	-460(ra) # 80003eb6 <write_head>
}
    8000408a:	70a2                	ld	ra,40(sp)
    8000408c:	7402                	ld	s0,32(sp)
    8000408e:	64e2                	ld	s1,24(sp)
    80004090:	6942                	ld	s2,16(sp)
    80004092:	69a2                	ld	s3,8(sp)
    80004094:	6145                	addi	sp,sp,48
    80004096:	8082                	ret

0000000080004098 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004098:	1101                	addi	sp,sp,-32
    8000409a:	ec06                	sd	ra,24(sp)
    8000409c:	e822                	sd	s0,16(sp)
    8000409e:	e426                	sd	s1,8(sp)
    800040a0:	e04a                	sd	s2,0(sp)
    800040a2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040a4:	0001d517          	auipc	a0,0x1d
    800040a8:	29c50513          	addi	a0,a0,668 # 80021340 <log>
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	b2a080e7          	jalr	-1238(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    800040b4:	0001d497          	auipc	s1,0x1d
    800040b8:	28c48493          	addi	s1,s1,652 # 80021340 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040bc:	4979                	li	s2,30
    800040be:	a039                	j	800040cc <begin_op+0x34>
      sleep(&log, &log.lock);
    800040c0:	85a6                	mv	a1,s1
    800040c2:	8526                	mv	a0,s1
    800040c4:	ffffe097          	auipc	ra,0xffffe
    800040c8:	f90080e7          	jalr	-112(ra) # 80002054 <sleep>
    if(log.committing){
    800040cc:	50dc                	lw	a5,36(s1)
    800040ce:	fbed                	bnez	a5,800040c0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040d0:	509c                	lw	a5,32(s1)
    800040d2:	0017871b          	addiw	a4,a5,1
    800040d6:	0007069b          	sext.w	a3,a4
    800040da:	0027179b          	slliw	a5,a4,0x2
    800040de:	9fb9                	addw	a5,a5,a4
    800040e0:	0017979b          	slliw	a5,a5,0x1
    800040e4:	54d8                	lw	a4,44(s1)
    800040e6:	9fb9                	addw	a5,a5,a4
    800040e8:	00f95963          	bge	s2,a5,800040fa <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040ec:	85a6                	mv	a1,s1
    800040ee:	8526                	mv	a0,s1
    800040f0:	ffffe097          	auipc	ra,0xffffe
    800040f4:	f64080e7          	jalr	-156(ra) # 80002054 <sleep>
    800040f8:	bfd1                	j	800040cc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800040fa:	0001d517          	auipc	a0,0x1d
    800040fe:	24650513          	addi	a0,a0,582 # 80021340 <log>
    80004102:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	b86080e7          	jalr	-1146(ra) # 80000c8a <release>
      break;
    }
  }
}
    8000410c:	60e2                	ld	ra,24(sp)
    8000410e:	6442                	ld	s0,16(sp)
    80004110:	64a2                	ld	s1,8(sp)
    80004112:	6902                	ld	s2,0(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret

0000000080004118 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004118:	7139                	addi	sp,sp,-64
    8000411a:	fc06                	sd	ra,56(sp)
    8000411c:	f822                	sd	s0,48(sp)
    8000411e:	f426                	sd	s1,40(sp)
    80004120:	f04a                	sd	s2,32(sp)
    80004122:	ec4e                	sd	s3,24(sp)
    80004124:	e852                	sd	s4,16(sp)
    80004126:	e456                	sd	s5,8(sp)
    80004128:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000412a:	0001d497          	auipc	s1,0x1d
    8000412e:	21648493          	addi	s1,s1,534 # 80021340 <log>
    80004132:	8526                	mv	a0,s1
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	aa2080e7          	jalr	-1374(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    8000413c:	509c                	lw	a5,32(s1)
    8000413e:	37fd                	addiw	a5,a5,-1
    80004140:	0007891b          	sext.w	s2,a5
    80004144:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004146:	50dc                	lw	a5,36(s1)
    80004148:	e7b9                	bnez	a5,80004196 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000414a:	04091e63          	bnez	s2,800041a6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000414e:	0001d497          	auipc	s1,0x1d
    80004152:	1f248493          	addi	s1,s1,498 # 80021340 <log>
    80004156:	4785                	li	a5,1
    80004158:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000415a:	8526                	mv	a0,s1
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	b2e080e7          	jalr	-1234(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004164:	54dc                	lw	a5,44(s1)
    80004166:	06f04763          	bgtz	a5,800041d4 <end_op+0xbc>
    acquire(&log.lock);
    8000416a:	0001d497          	auipc	s1,0x1d
    8000416e:	1d648493          	addi	s1,s1,470 # 80021340 <log>
    80004172:	8526                	mv	a0,s1
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	a62080e7          	jalr	-1438(ra) # 80000bd6 <acquire>
    log.committing = 0;
    8000417c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004180:	8526                	mv	a0,s1
    80004182:	ffffe097          	auipc	ra,0xffffe
    80004186:	f36080e7          	jalr	-202(ra) # 800020b8 <wakeup>
    release(&log.lock);
    8000418a:	8526                	mv	a0,s1
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	afe080e7          	jalr	-1282(ra) # 80000c8a <release>
}
    80004194:	a03d                	j	800041c2 <end_op+0xaa>
    panic("log.committing");
    80004196:	00004517          	auipc	a0,0x4
    8000419a:	4b250513          	addi	a0,a0,1202 # 80008648 <syscalls+0x1e8>
    8000419e:	ffffc097          	auipc	ra,0xffffc
    800041a2:	3a0080e7          	jalr	928(ra) # 8000053e <panic>
    wakeup(&log);
    800041a6:	0001d497          	auipc	s1,0x1d
    800041aa:	19a48493          	addi	s1,s1,410 # 80021340 <log>
    800041ae:	8526                	mv	a0,s1
    800041b0:	ffffe097          	auipc	ra,0xffffe
    800041b4:	f08080e7          	jalr	-248(ra) # 800020b8 <wakeup>
  release(&log.lock);
    800041b8:	8526                	mv	a0,s1
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	ad0080e7          	jalr	-1328(ra) # 80000c8a <release>
}
    800041c2:	70e2                	ld	ra,56(sp)
    800041c4:	7442                	ld	s0,48(sp)
    800041c6:	74a2                	ld	s1,40(sp)
    800041c8:	7902                	ld	s2,32(sp)
    800041ca:	69e2                	ld	s3,24(sp)
    800041cc:	6a42                	ld	s4,16(sp)
    800041ce:	6aa2                	ld	s5,8(sp)
    800041d0:	6121                	addi	sp,sp,64
    800041d2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800041d4:	0001da97          	auipc	s5,0x1d
    800041d8:	19ca8a93          	addi	s5,s5,412 # 80021370 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041dc:	0001da17          	auipc	s4,0x1d
    800041e0:	164a0a13          	addi	s4,s4,356 # 80021340 <log>
    800041e4:	018a2583          	lw	a1,24(s4)
    800041e8:	012585bb          	addw	a1,a1,s2
    800041ec:	2585                	addiw	a1,a1,1
    800041ee:	028a2503          	lw	a0,40(s4)
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	cca080e7          	jalr	-822(ra) # 80002ebc <bread>
    800041fa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041fc:	000aa583          	lw	a1,0(s5)
    80004200:	028a2503          	lw	a0,40(s4)
    80004204:	fffff097          	auipc	ra,0xfffff
    80004208:	cb8080e7          	jalr	-840(ra) # 80002ebc <bread>
    8000420c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000420e:	40000613          	li	a2,1024
    80004212:	05850593          	addi	a1,a0,88
    80004216:	05848513          	addi	a0,s1,88
    8000421a:	ffffd097          	auipc	ra,0xffffd
    8000421e:	b14080e7          	jalr	-1260(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004222:	8526                	mv	a0,s1
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	d8a080e7          	jalr	-630(ra) # 80002fae <bwrite>
    brelse(from);
    8000422c:	854e                	mv	a0,s3
    8000422e:	fffff097          	auipc	ra,0xfffff
    80004232:	dbe080e7          	jalr	-578(ra) # 80002fec <brelse>
    brelse(to);
    80004236:	8526                	mv	a0,s1
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	db4080e7          	jalr	-588(ra) # 80002fec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004240:	2905                	addiw	s2,s2,1
    80004242:	0a91                	addi	s5,s5,4
    80004244:	02ca2783          	lw	a5,44(s4)
    80004248:	f8f94ee3          	blt	s2,a5,800041e4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000424c:	00000097          	auipc	ra,0x0
    80004250:	c6a080e7          	jalr	-918(ra) # 80003eb6 <write_head>
    install_trans(0); // Now install writes to home locations
    80004254:	4501                	li	a0,0
    80004256:	00000097          	auipc	ra,0x0
    8000425a:	cda080e7          	jalr	-806(ra) # 80003f30 <install_trans>
    log.lh.n = 0;
    8000425e:	0001d797          	auipc	a5,0x1d
    80004262:	1007a723          	sw	zero,270(a5) # 8002136c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004266:	00000097          	auipc	ra,0x0
    8000426a:	c50080e7          	jalr	-944(ra) # 80003eb6 <write_head>
    8000426e:	bdf5                	j	8000416a <end_op+0x52>

0000000080004270 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004270:	1101                	addi	sp,sp,-32
    80004272:	ec06                	sd	ra,24(sp)
    80004274:	e822                	sd	s0,16(sp)
    80004276:	e426                	sd	s1,8(sp)
    80004278:	e04a                	sd	s2,0(sp)
    8000427a:	1000                	addi	s0,sp,32
    8000427c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000427e:	0001d917          	auipc	s2,0x1d
    80004282:	0c290913          	addi	s2,s2,194 # 80021340 <log>
    80004286:	854a                	mv	a0,s2
    80004288:	ffffd097          	auipc	ra,0xffffd
    8000428c:	94e080e7          	jalr	-1714(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004290:	02c92603          	lw	a2,44(s2)
    80004294:	47f5                	li	a5,29
    80004296:	06c7c563          	blt	a5,a2,80004300 <log_write+0x90>
    8000429a:	0001d797          	auipc	a5,0x1d
    8000429e:	0c27a783          	lw	a5,194(a5) # 8002135c <log+0x1c>
    800042a2:	37fd                	addiw	a5,a5,-1
    800042a4:	04f65e63          	bge	a2,a5,80004300 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800042a8:	0001d797          	auipc	a5,0x1d
    800042ac:	0b87a783          	lw	a5,184(a5) # 80021360 <log+0x20>
    800042b0:	06f05063          	blez	a5,80004310 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800042b4:	4781                	li	a5,0
    800042b6:	06c05563          	blez	a2,80004320 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042ba:	44cc                	lw	a1,12(s1)
    800042bc:	0001d717          	auipc	a4,0x1d
    800042c0:	0b470713          	addi	a4,a4,180 # 80021370 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800042c4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800042c6:	4314                	lw	a3,0(a4)
    800042c8:	04b68c63          	beq	a3,a1,80004320 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800042cc:	2785                	addiw	a5,a5,1
    800042ce:	0711                	addi	a4,a4,4
    800042d0:	fef61be3          	bne	a2,a5,800042c6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800042d4:	0621                	addi	a2,a2,8
    800042d6:	060a                	slli	a2,a2,0x2
    800042d8:	0001d797          	auipc	a5,0x1d
    800042dc:	06878793          	addi	a5,a5,104 # 80021340 <log>
    800042e0:	963e                	add	a2,a2,a5
    800042e2:	44dc                	lw	a5,12(s1)
    800042e4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042e6:	8526                	mv	a0,s1
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	da2080e7          	jalr	-606(ra) # 8000308a <bpin>
    log.lh.n++;
    800042f0:	0001d717          	auipc	a4,0x1d
    800042f4:	05070713          	addi	a4,a4,80 # 80021340 <log>
    800042f8:	575c                	lw	a5,44(a4)
    800042fa:	2785                	addiw	a5,a5,1
    800042fc:	d75c                	sw	a5,44(a4)
    800042fe:	a835                	j	8000433a <log_write+0xca>
    panic("too big a transaction");
    80004300:	00004517          	auipc	a0,0x4
    80004304:	35850513          	addi	a0,a0,856 # 80008658 <syscalls+0x1f8>
    80004308:	ffffc097          	auipc	ra,0xffffc
    8000430c:	236080e7          	jalr	566(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004310:	00004517          	auipc	a0,0x4
    80004314:	36050513          	addi	a0,a0,864 # 80008670 <syscalls+0x210>
    80004318:	ffffc097          	auipc	ra,0xffffc
    8000431c:	226080e7          	jalr	550(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004320:	00878713          	addi	a4,a5,8
    80004324:	00271693          	slli	a3,a4,0x2
    80004328:	0001d717          	auipc	a4,0x1d
    8000432c:	01870713          	addi	a4,a4,24 # 80021340 <log>
    80004330:	9736                	add	a4,a4,a3
    80004332:	44d4                	lw	a3,12(s1)
    80004334:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004336:	faf608e3          	beq	a2,a5,800042e6 <log_write+0x76>
  }
  release(&log.lock);
    8000433a:	0001d517          	auipc	a0,0x1d
    8000433e:	00650513          	addi	a0,a0,6 # 80021340 <log>
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	948080e7          	jalr	-1720(ra) # 80000c8a <release>
}
    8000434a:	60e2                	ld	ra,24(sp)
    8000434c:	6442                	ld	s0,16(sp)
    8000434e:	64a2                	ld	s1,8(sp)
    80004350:	6902                	ld	s2,0(sp)
    80004352:	6105                	addi	sp,sp,32
    80004354:	8082                	ret

0000000080004356 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004356:	1101                	addi	sp,sp,-32
    80004358:	ec06                	sd	ra,24(sp)
    8000435a:	e822                	sd	s0,16(sp)
    8000435c:	e426                	sd	s1,8(sp)
    8000435e:	e04a                	sd	s2,0(sp)
    80004360:	1000                	addi	s0,sp,32
    80004362:	84aa                	mv	s1,a0
    80004364:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004366:	00004597          	auipc	a1,0x4
    8000436a:	32a58593          	addi	a1,a1,810 # 80008690 <syscalls+0x230>
    8000436e:	0521                	addi	a0,a0,8
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	7d6080e7          	jalr	2006(ra) # 80000b46 <initlock>
  lk->name = name;
    80004378:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000437c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004380:	0204a423          	sw	zero,40(s1)
}
    80004384:	60e2                	ld	ra,24(sp)
    80004386:	6442                	ld	s0,16(sp)
    80004388:	64a2                	ld	s1,8(sp)
    8000438a:	6902                	ld	s2,0(sp)
    8000438c:	6105                	addi	sp,sp,32
    8000438e:	8082                	ret

0000000080004390 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004390:	1101                	addi	sp,sp,-32
    80004392:	ec06                	sd	ra,24(sp)
    80004394:	e822                	sd	s0,16(sp)
    80004396:	e426                	sd	s1,8(sp)
    80004398:	e04a                	sd	s2,0(sp)
    8000439a:	1000                	addi	s0,sp,32
    8000439c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000439e:	00850913          	addi	s2,a0,8
    800043a2:	854a                	mv	a0,s2
    800043a4:	ffffd097          	auipc	ra,0xffffd
    800043a8:	832080e7          	jalr	-1998(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    800043ac:	409c                	lw	a5,0(s1)
    800043ae:	cb89                	beqz	a5,800043c0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800043b0:	85ca                	mv	a1,s2
    800043b2:	8526                	mv	a0,s1
    800043b4:	ffffe097          	auipc	ra,0xffffe
    800043b8:	ca0080e7          	jalr	-864(ra) # 80002054 <sleep>
  while (lk->locked) {
    800043bc:	409c                	lw	a5,0(s1)
    800043be:	fbed                	bnez	a5,800043b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800043c0:	4785                	li	a5,1
    800043c2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800043c4:	ffffd097          	auipc	ra,0xffffd
    800043c8:	5e8080e7          	jalr	1512(ra) # 800019ac <myproc>
    800043cc:	591c                	lw	a5,48(a0)
    800043ce:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800043d0:	854a                	mv	a0,s2
    800043d2:	ffffd097          	auipc	ra,0xffffd
    800043d6:	8b8080e7          	jalr	-1864(ra) # 80000c8a <release>
}
    800043da:	60e2                	ld	ra,24(sp)
    800043dc:	6442                	ld	s0,16(sp)
    800043de:	64a2                	ld	s1,8(sp)
    800043e0:	6902                	ld	s2,0(sp)
    800043e2:	6105                	addi	sp,sp,32
    800043e4:	8082                	ret

00000000800043e6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800043e6:	1101                	addi	sp,sp,-32
    800043e8:	ec06                	sd	ra,24(sp)
    800043ea:	e822                	sd	s0,16(sp)
    800043ec:	e426                	sd	s1,8(sp)
    800043ee:	e04a                	sd	s2,0(sp)
    800043f0:	1000                	addi	s0,sp,32
    800043f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043f4:	00850913          	addi	s2,a0,8
    800043f8:	854a                	mv	a0,s2
    800043fa:	ffffc097          	auipc	ra,0xffffc
    800043fe:	7dc080e7          	jalr	2012(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004402:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004406:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000440a:	8526                	mv	a0,s1
    8000440c:	ffffe097          	auipc	ra,0xffffe
    80004410:	cac080e7          	jalr	-852(ra) # 800020b8 <wakeup>
  release(&lk->lk);
    80004414:	854a                	mv	a0,s2
    80004416:	ffffd097          	auipc	ra,0xffffd
    8000441a:	874080e7          	jalr	-1932(ra) # 80000c8a <release>
}
    8000441e:	60e2                	ld	ra,24(sp)
    80004420:	6442                	ld	s0,16(sp)
    80004422:	64a2                	ld	s1,8(sp)
    80004424:	6902                	ld	s2,0(sp)
    80004426:	6105                	addi	sp,sp,32
    80004428:	8082                	ret

000000008000442a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000442a:	7179                	addi	sp,sp,-48
    8000442c:	f406                	sd	ra,40(sp)
    8000442e:	f022                	sd	s0,32(sp)
    80004430:	ec26                	sd	s1,24(sp)
    80004432:	e84a                	sd	s2,16(sp)
    80004434:	e44e                	sd	s3,8(sp)
    80004436:	1800                	addi	s0,sp,48
    80004438:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000443a:	00850913          	addi	s2,a0,8
    8000443e:	854a                	mv	a0,s2
    80004440:	ffffc097          	auipc	ra,0xffffc
    80004444:	796080e7          	jalr	1942(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004448:	409c                	lw	a5,0(s1)
    8000444a:	ef99                	bnez	a5,80004468 <holdingsleep+0x3e>
    8000444c:	4481                	li	s1,0
  release(&lk->lk);
    8000444e:	854a                	mv	a0,s2
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	83a080e7          	jalr	-1990(ra) # 80000c8a <release>
  return r;
}
    80004458:	8526                	mv	a0,s1
    8000445a:	70a2                	ld	ra,40(sp)
    8000445c:	7402                	ld	s0,32(sp)
    8000445e:	64e2                	ld	s1,24(sp)
    80004460:	6942                	ld	s2,16(sp)
    80004462:	69a2                	ld	s3,8(sp)
    80004464:	6145                	addi	sp,sp,48
    80004466:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004468:	0284a983          	lw	s3,40(s1)
    8000446c:	ffffd097          	auipc	ra,0xffffd
    80004470:	540080e7          	jalr	1344(ra) # 800019ac <myproc>
    80004474:	5904                	lw	s1,48(a0)
    80004476:	413484b3          	sub	s1,s1,s3
    8000447a:	0014b493          	seqz	s1,s1
    8000447e:	bfc1                	j	8000444e <holdingsleep+0x24>

0000000080004480 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004480:	1141                	addi	sp,sp,-16
    80004482:	e406                	sd	ra,8(sp)
    80004484:	e022                	sd	s0,0(sp)
    80004486:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004488:	00004597          	auipc	a1,0x4
    8000448c:	21858593          	addi	a1,a1,536 # 800086a0 <syscalls+0x240>
    80004490:	0001d517          	auipc	a0,0x1d
    80004494:	ff850513          	addi	a0,a0,-8 # 80021488 <ftable>
    80004498:	ffffc097          	auipc	ra,0xffffc
    8000449c:	6ae080e7          	jalr	1710(ra) # 80000b46 <initlock>
}
    800044a0:	60a2                	ld	ra,8(sp)
    800044a2:	6402                	ld	s0,0(sp)
    800044a4:	0141                	addi	sp,sp,16
    800044a6:	8082                	ret

00000000800044a8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800044a8:	1101                	addi	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	e426                	sd	s1,8(sp)
    800044b0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800044b2:	0001d517          	auipc	a0,0x1d
    800044b6:	fd650513          	addi	a0,a0,-42 # 80021488 <ftable>
    800044ba:	ffffc097          	auipc	ra,0xffffc
    800044be:	71c080e7          	jalr	1820(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044c2:	0001d497          	auipc	s1,0x1d
    800044c6:	fde48493          	addi	s1,s1,-34 # 800214a0 <ftable+0x18>
    800044ca:	0001e717          	auipc	a4,0x1e
    800044ce:	f7670713          	addi	a4,a4,-138 # 80022440 <disk>
    if(f->ref == 0){
    800044d2:	40dc                	lw	a5,4(s1)
    800044d4:	cf99                	beqz	a5,800044f2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800044d6:	02848493          	addi	s1,s1,40
    800044da:	fee49ce3          	bne	s1,a4,800044d2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800044de:	0001d517          	auipc	a0,0x1d
    800044e2:	faa50513          	addi	a0,a0,-86 # 80021488 <ftable>
    800044e6:	ffffc097          	auipc	ra,0xffffc
    800044ea:	7a4080e7          	jalr	1956(ra) # 80000c8a <release>
  return 0;
    800044ee:	4481                	li	s1,0
    800044f0:	a819                	j	80004506 <filealloc+0x5e>
      f->ref = 1;
    800044f2:	4785                	li	a5,1
    800044f4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800044f6:	0001d517          	auipc	a0,0x1d
    800044fa:	f9250513          	addi	a0,a0,-110 # 80021488 <ftable>
    800044fe:	ffffc097          	auipc	ra,0xffffc
    80004502:	78c080e7          	jalr	1932(ra) # 80000c8a <release>
}
    80004506:	8526                	mv	a0,s1
    80004508:	60e2                	ld	ra,24(sp)
    8000450a:	6442                	ld	s0,16(sp)
    8000450c:	64a2                	ld	s1,8(sp)
    8000450e:	6105                	addi	sp,sp,32
    80004510:	8082                	ret

0000000080004512 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004512:	1101                	addi	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	e426                	sd	s1,8(sp)
    8000451a:	1000                	addi	s0,sp,32
    8000451c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000451e:	0001d517          	auipc	a0,0x1d
    80004522:	f6a50513          	addi	a0,a0,-150 # 80021488 <ftable>
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	6b0080e7          	jalr	1712(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000452e:	40dc                	lw	a5,4(s1)
    80004530:	02f05263          	blez	a5,80004554 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004534:	2785                	addiw	a5,a5,1
    80004536:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004538:	0001d517          	auipc	a0,0x1d
    8000453c:	f5050513          	addi	a0,a0,-176 # 80021488 <ftable>
    80004540:	ffffc097          	auipc	ra,0xffffc
    80004544:	74a080e7          	jalr	1866(ra) # 80000c8a <release>
  return f;
}
    80004548:	8526                	mv	a0,s1
    8000454a:	60e2                	ld	ra,24(sp)
    8000454c:	6442                	ld	s0,16(sp)
    8000454e:	64a2                	ld	s1,8(sp)
    80004550:	6105                	addi	sp,sp,32
    80004552:	8082                	ret
    panic("filedup");
    80004554:	00004517          	auipc	a0,0x4
    80004558:	15450513          	addi	a0,a0,340 # 800086a8 <syscalls+0x248>
    8000455c:	ffffc097          	auipc	ra,0xffffc
    80004560:	fe2080e7          	jalr	-30(ra) # 8000053e <panic>

0000000080004564 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004564:	7139                	addi	sp,sp,-64
    80004566:	fc06                	sd	ra,56(sp)
    80004568:	f822                	sd	s0,48(sp)
    8000456a:	f426                	sd	s1,40(sp)
    8000456c:	f04a                	sd	s2,32(sp)
    8000456e:	ec4e                	sd	s3,24(sp)
    80004570:	e852                	sd	s4,16(sp)
    80004572:	e456                	sd	s5,8(sp)
    80004574:	0080                	addi	s0,sp,64
    80004576:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004578:	0001d517          	auipc	a0,0x1d
    8000457c:	f1050513          	addi	a0,a0,-240 # 80021488 <ftable>
    80004580:	ffffc097          	auipc	ra,0xffffc
    80004584:	656080e7          	jalr	1622(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004588:	40dc                	lw	a5,4(s1)
    8000458a:	06f05163          	blez	a5,800045ec <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000458e:	37fd                	addiw	a5,a5,-1
    80004590:	0007871b          	sext.w	a4,a5
    80004594:	c0dc                	sw	a5,4(s1)
    80004596:	06e04363          	bgtz	a4,800045fc <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000459a:	0004a903          	lw	s2,0(s1)
    8000459e:	0094ca83          	lbu	s5,9(s1)
    800045a2:	0104ba03          	ld	s4,16(s1)
    800045a6:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800045aa:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800045ae:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800045b2:	0001d517          	auipc	a0,0x1d
    800045b6:	ed650513          	addi	a0,a0,-298 # 80021488 <ftable>
    800045ba:	ffffc097          	auipc	ra,0xffffc
    800045be:	6d0080e7          	jalr	1744(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800045c2:	4785                	li	a5,1
    800045c4:	04f90d63          	beq	s2,a5,8000461e <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800045c8:	3979                	addiw	s2,s2,-2
    800045ca:	4785                	li	a5,1
    800045cc:	0527e063          	bltu	a5,s2,8000460c <fileclose+0xa8>
    begin_op();
    800045d0:	00000097          	auipc	ra,0x0
    800045d4:	ac8080e7          	jalr	-1336(ra) # 80004098 <begin_op>
    iput(ff.ip);
    800045d8:	854e                	mv	a0,s3
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	2b6080e7          	jalr	694(ra) # 80003890 <iput>
    end_op();
    800045e2:	00000097          	auipc	ra,0x0
    800045e6:	b36080e7          	jalr	-1226(ra) # 80004118 <end_op>
    800045ea:	a00d                	j	8000460c <fileclose+0xa8>
    panic("fileclose");
    800045ec:	00004517          	auipc	a0,0x4
    800045f0:	0c450513          	addi	a0,a0,196 # 800086b0 <syscalls+0x250>
    800045f4:	ffffc097          	auipc	ra,0xffffc
    800045f8:	f4a080e7          	jalr	-182(ra) # 8000053e <panic>
    release(&ftable.lock);
    800045fc:	0001d517          	auipc	a0,0x1d
    80004600:	e8c50513          	addi	a0,a0,-372 # 80021488 <ftable>
    80004604:	ffffc097          	auipc	ra,0xffffc
    80004608:	686080e7          	jalr	1670(ra) # 80000c8a <release>
  }
}
    8000460c:	70e2                	ld	ra,56(sp)
    8000460e:	7442                	ld	s0,48(sp)
    80004610:	74a2                	ld	s1,40(sp)
    80004612:	7902                	ld	s2,32(sp)
    80004614:	69e2                	ld	s3,24(sp)
    80004616:	6a42                	ld	s4,16(sp)
    80004618:	6aa2                	ld	s5,8(sp)
    8000461a:	6121                	addi	sp,sp,64
    8000461c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000461e:	85d6                	mv	a1,s5
    80004620:	8552                	mv	a0,s4
    80004622:	00000097          	auipc	ra,0x0
    80004626:	34c080e7          	jalr	844(ra) # 8000496e <pipeclose>
    8000462a:	b7cd                	j	8000460c <fileclose+0xa8>

000000008000462c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000462c:	715d                	addi	sp,sp,-80
    8000462e:	e486                	sd	ra,72(sp)
    80004630:	e0a2                	sd	s0,64(sp)
    80004632:	fc26                	sd	s1,56(sp)
    80004634:	f84a                	sd	s2,48(sp)
    80004636:	f44e                	sd	s3,40(sp)
    80004638:	0880                	addi	s0,sp,80
    8000463a:	84aa                	mv	s1,a0
    8000463c:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000463e:	ffffd097          	auipc	ra,0xffffd
    80004642:	36e080e7          	jalr	878(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004646:	409c                	lw	a5,0(s1)
    80004648:	37f9                	addiw	a5,a5,-2
    8000464a:	4705                	li	a4,1
    8000464c:	04f76763          	bltu	a4,a5,8000469a <filestat+0x6e>
    80004650:	892a                	mv	s2,a0
    ilock(f->ip);
    80004652:	6c88                	ld	a0,24(s1)
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	082080e7          	jalr	130(ra) # 800036d6 <ilock>
    stati(f->ip, &st);
    8000465c:	fb840593          	addi	a1,s0,-72
    80004660:	6c88                	ld	a0,24(s1)
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	2fe080e7          	jalr	766(ra) # 80003960 <stati>
    iunlock(f->ip);
    8000466a:	6c88                	ld	a0,24(s1)
    8000466c:	fffff097          	auipc	ra,0xfffff
    80004670:	12c080e7          	jalr	300(ra) # 80003798 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004674:	46e1                	li	a3,24
    80004676:	fb840613          	addi	a2,s0,-72
    8000467a:	85ce                	mv	a1,s3
    8000467c:	07093503          	ld	a0,112(s2)
    80004680:	ffffd097          	auipc	ra,0xffffd
    80004684:	fe8080e7          	jalr	-24(ra) # 80001668 <copyout>
    80004688:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000468c:	60a6                	ld	ra,72(sp)
    8000468e:	6406                	ld	s0,64(sp)
    80004690:	74e2                	ld	s1,56(sp)
    80004692:	7942                	ld	s2,48(sp)
    80004694:	79a2                	ld	s3,40(sp)
    80004696:	6161                	addi	sp,sp,80
    80004698:	8082                	ret
  return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	bfc5                	j	8000468c <filestat+0x60>

000000008000469e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000469e:	7179                	addi	sp,sp,-48
    800046a0:	f406                	sd	ra,40(sp)
    800046a2:	f022                	sd	s0,32(sp)
    800046a4:	ec26                	sd	s1,24(sp)
    800046a6:	e84a                	sd	s2,16(sp)
    800046a8:	e44e                	sd	s3,8(sp)
    800046aa:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800046ac:	00854783          	lbu	a5,8(a0)
    800046b0:	c3d5                	beqz	a5,80004754 <fileread+0xb6>
    800046b2:	84aa                	mv	s1,a0
    800046b4:	89ae                	mv	s3,a1
    800046b6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800046b8:	411c                	lw	a5,0(a0)
    800046ba:	4705                	li	a4,1
    800046bc:	04e78963          	beq	a5,a4,8000470e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c0:	470d                	li	a4,3
    800046c2:	04e78d63          	beq	a5,a4,8000471c <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800046c6:	4709                	li	a4,2
    800046c8:	06e79e63          	bne	a5,a4,80004744 <fileread+0xa6>
    ilock(f->ip);
    800046cc:	6d08                	ld	a0,24(a0)
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	008080e7          	jalr	8(ra) # 800036d6 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800046d6:	874a                	mv	a4,s2
    800046d8:	5094                	lw	a3,32(s1)
    800046da:	864e                	mv	a2,s3
    800046dc:	4585                	li	a1,1
    800046de:	6c88                	ld	a0,24(s1)
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	2aa080e7          	jalr	682(ra) # 8000398a <readi>
    800046e8:	892a                	mv	s2,a0
    800046ea:	00a05563          	blez	a0,800046f4 <fileread+0x56>
      f->off += r;
    800046ee:	509c                	lw	a5,32(s1)
    800046f0:	9fa9                	addw	a5,a5,a0
    800046f2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800046f4:	6c88                	ld	a0,24(s1)
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	0a2080e7          	jalr	162(ra) # 80003798 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800046fe:	854a                	mv	a0,s2
    80004700:	70a2                	ld	ra,40(sp)
    80004702:	7402                	ld	s0,32(sp)
    80004704:	64e2                	ld	s1,24(sp)
    80004706:	6942                	ld	s2,16(sp)
    80004708:	69a2                	ld	s3,8(sp)
    8000470a:	6145                	addi	sp,sp,48
    8000470c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000470e:	6908                	ld	a0,16(a0)
    80004710:	00000097          	auipc	ra,0x0
    80004714:	3c6080e7          	jalr	966(ra) # 80004ad6 <piperead>
    80004718:	892a                	mv	s2,a0
    8000471a:	b7d5                	j	800046fe <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000471c:	02451783          	lh	a5,36(a0)
    80004720:	03079693          	slli	a3,a5,0x30
    80004724:	92c1                	srli	a3,a3,0x30
    80004726:	4725                	li	a4,9
    80004728:	02d76863          	bltu	a4,a3,80004758 <fileread+0xba>
    8000472c:	0792                	slli	a5,a5,0x4
    8000472e:	0001d717          	auipc	a4,0x1d
    80004732:	cba70713          	addi	a4,a4,-838 # 800213e8 <devsw>
    80004736:	97ba                	add	a5,a5,a4
    80004738:	639c                	ld	a5,0(a5)
    8000473a:	c38d                	beqz	a5,8000475c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000473c:	4505                	li	a0,1
    8000473e:	9782                	jalr	a5
    80004740:	892a                	mv	s2,a0
    80004742:	bf75                	j	800046fe <fileread+0x60>
    panic("fileread");
    80004744:	00004517          	auipc	a0,0x4
    80004748:	f7c50513          	addi	a0,a0,-132 # 800086c0 <syscalls+0x260>
    8000474c:	ffffc097          	auipc	ra,0xffffc
    80004750:	df2080e7          	jalr	-526(ra) # 8000053e <panic>
    return -1;
    80004754:	597d                	li	s2,-1
    80004756:	b765                	j	800046fe <fileread+0x60>
      return -1;
    80004758:	597d                	li	s2,-1
    8000475a:	b755                	j	800046fe <fileread+0x60>
    8000475c:	597d                	li	s2,-1
    8000475e:	b745                	j	800046fe <fileread+0x60>

0000000080004760 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004760:	715d                	addi	sp,sp,-80
    80004762:	e486                	sd	ra,72(sp)
    80004764:	e0a2                	sd	s0,64(sp)
    80004766:	fc26                	sd	s1,56(sp)
    80004768:	f84a                	sd	s2,48(sp)
    8000476a:	f44e                	sd	s3,40(sp)
    8000476c:	f052                	sd	s4,32(sp)
    8000476e:	ec56                	sd	s5,24(sp)
    80004770:	e85a                	sd	s6,16(sp)
    80004772:	e45e                	sd	s7,8(sp)
    80004774:	e062                	sd	s8,0(sp)
    80004776:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004778:	00954783          	lbu	a5,9(a0)
    8000477c:	10078663          	beqz	a5,80004888 <filewrite+0x128>
    80004780:	892a                	mv	s2,a0
    80004782:	8aae                	mv	s5,a1
    80004784:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004786:	411c                	lw	a5,0(a0)
    80004788:	4705                	li	a4,1
    8000478a:	02e78263          	beq	a5,a4,800047ae <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000478e:	470d                	li	a4,3
    80004790:	02e78663          	beq	a5,a4,800047bc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004794:	4709                	li	a4,2
    80004796:	0ee79163          	bne	a5,a4,80004878 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000479a:	0ac05d63          	blez	a2,80004854 <filewrite+0xf4>
    int i = 0;
    8000479e:	4981                	li	s3,0
    800047a0:	6b05                	lui	s6,0x1
    800047a2:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800047a6:	6b85                	lui	s7,0x1
    800047a8:	c00b8b9b          	addiw	s7,s7,-1024
    800047ac:	a861                	j	80004844 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    800047ae:	6908                	ld	a0,16(a0)
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	22e080e7          	jalr	558(ra) # 800049de <pipewrite>
    800047b8:	8a2a                	mv	s4,a0
    800047ba:	a045                	j	8000485a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800047bc:	02451783          	lh	a5,36(a0)
    800047c0:	03079693          	slli	a3,a5,0x30
    800047c4:	92c1                	srli	a3,a3,0x30
    800047c6:	4725                	li	a4,9
    800047c8:	0cd76263          	bltu	a4,a3,8000488c <filewrite+0x12c>
    800047cc:	0792                	slli	a5,a5,0x4
    800047ce:	0001d717          	auipc	a4,0x1d
    800047d2:	c1a70713          	addi	a4,a4,-998 # 800213e8 <devsw>
    800047d6:	97ba                	add	a5,a5,a4
    800047d8:	679c                	ld	a5,8(a5)
    800047da:	cbdd                	beqz	a5,80004890 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    800047dc:	4505                	li	a0,1
    800047de:	9782                	jalr	a5
    800047e0:	8a2a                	mv	s4,a0
    800047e2:	a8a5                	j	8000485a <filewrite+0xfa>
    800047e4:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	8b0080e7          	jalr	-1872(ra) # 80004098 <begin_op>
      ilock(f->ip);
    800047f0:	01893503          	ld	a0,24(s2)
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	ee2080e7          	jalr	-286(ra) # 800036d6 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800047fc:	8762                	mv	a4,s8
    800047fe:	02092683          	lw	a3,32(s2)
    80004802:	01598633          	add	a2,s3,s5
    80004806:	4585                	li	a1,1
    80004808:	01893503          	ld	a0,24(s2)
    8000480c:	fffff097          	auipc	ra,0xfffff
    80004810:	276080e7          	jalr	630(ra) # 80003a82 <writei>
    80004814:	84aa                	mv	s1,a0
    80004816:	00a05763          	blez	a0,80004824 <filewrite+0xc4>
        f->off += r;
    8000481a:	02092783          	lw	a5,32(s2)
    8000481e:	9fa9                	addw	a5,a5,a0
    80004820:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004824:	01893503          	ld	a0,24(s2)
    80004828:	fffff097          	auipc	ra,0xfffff
    8000482c:	f70080e7          	jalr	-144(ra) # 80003798 <iunlock>
      end_op();
    80004830:	00000097          	auipc	ra,0x0
    80004834:	8e8080e7          	jalr	-1816(ra) # 80004118 <end_op>

      if(r != n1){
    80004838:	009c1f63          	bne	s8,s1,80004856 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000483c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004840:	0149db63          	bge	s3,s4,80004856 <filewrite+0xf6>
      int n1 = n - i;
    80004844:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004848:	84be                	mv	s1,a5
    8000484a:	2781                	sext.w	a5,a5
    8000484c:	f8fb5ce3          	bge	s6,a5,800047e4 <filewrite+0x84>
    80004850:	84de                	mv	s1,s7
    80004852:	bf49                	j	800047e4 <filewrite+0x84>
    int i = 0;
    80004854:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004856:	013a1f63          	bne	s4,s3,80004874 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000485a:	8552                	mv	a0,s4
    8000485c:	60a6                	ld	ra,72(sp)
    8000485e:	6406                	ld	s0,64(sp)
    80004860:	74e2                	ld	s1,56(sp)
    80004862:	7942                	ld	s2,48(sp)
    80004864:	79a2                	ld	s3,40(sp)
    80004866:	7a02                	ld	s4,32(sp)
    80004868:	6ae2                	ld	s5,24(sp)
    8000486a:	6b42                	ld	s6,16(sp)
    8000486c:	6ba2                	ld	s7,8(sp)
    8000486e:	6c02                	ld	s8,0(sp)
    80004870:	6161                	addi	sp,sp,80
    80004872:	8082                	ret
    ret = (i == n ? n : -1);
    80004874:	5a7d                	li	s4,-1
    80004876:	b7d5                	j	8000485a <filewrite+0xfa>
    panic("filewrite");
    80004878:	00004517          	auipc	a0,0x4
    8000487c:	e5850513          	addi	a0,a0,-424 # 800086d0 <syscalls+0x270>
    80004880:	ffffc097          	auipc	ra,0xffffc
    80004884:	cbe080e7          	jalr	-834(ra) # 8000053e <panic>
    return -1;
    80004888:	5a7d                	li	s4,-1
    8000488a:	bfc1                	j	8000485a <filewrite+0xfa>
      return -1;
    8000488c:	5a7d                	li	s4,-1
    8000488e:	b7f1                	j	8000485a <filewrite+0xfa>
    80004890:	5a7d                	li	s4,-1
    80004892:	b7e1                	j	8000485a <filewrite+0xfa>

0000000080004894 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004894:	7179                	addi	sp,sp,-48
    80004896:	f406                	sd	ra,40(sp)
    80004898:	f022                	sd	s0,32(sp)
    8000489a:	ec26                	sd	s1,24(sp)
    8000489c:	e84a                	sd	s2,16(sp)
    8000489e:	e44e                	sd	s3,8(sp)
    800048a0:	e052                	sd	s4,0(sp)
    800048a2:	1800                	addi	s0,sp,48
    800048a4:	84aa                	mv	s1,a0
    800048a6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800048a8:	0005b023          	sd	zero,0(a1)
    800048ac:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800048b0:	00000097          	auipc	ra,0x0
    800048b4:	bf8080e7          	jalr	-1032(ra) # 800044a8 <filealloc>
    800048b8:	e088                	sd	a0,0(s1)
    800048ba:	c551                	beqz	a0,80004946 <pipealloc+0xb2>
    800048bc:	00000097          	auipc	ra,0x0
    800048c0:	bec080e7          	jalr	-1044(ra) # 800044a8 <filealloc>
    800048c4:	00aa3023          	sd	a0,0(s4)
    800048c8:	c92d                	beqz	a0,8000493a <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800048ca:	ffffc097          	auipc	ra,0xffffc
    800048ce:	21c080e7          	jalr	540(ra) # 80000ae6 <kalloc>
    800048d2:	892a                	mv	s2,a0
    800048d4:	c125                	beqz	a0,80004934 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800048d6:	4985                	li	s3,1
    800048d8:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800048dc:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800048e0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800048e4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800048e8:	00004597          	auipc	a1,0x4
    800048ec:	df858593          	addi	a1,a1,-520 # 800086e0 <syscalls+0x280>
    800048f0:	ffffc097          	auipc	ra,0xffffc
    800048f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    800048f8:	609c                	ld	a5,0(s1)
    800048fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800048fe:	609c                	ld	a5,0(s1)
    80004900:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004904:	609c                	ld	a5,0(s1)
    80004906:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000490a:	609c                	ld	a5,0(s1)
    8000490c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004910:	000a3783          	ld	a5,0(s4)
    80004914:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004918:	000a3783          	ld	a5,0(s4)
    8000491c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004920:	000a3783          	ld	a5,0(s4)
    80004924:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004928:	000a3783          	ld	a5,0(s4)
    8000492c:	0127b823          	sd	s2,16(a5)
  return 0;
    80004930:	4501                	li	a0,0
    80004932:	a025                	j	8000495a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004934:	6088                	ld	a0,0(s1)
    80004936:	e501                	bnez	a0,8000493e <pipealloc+0xaa>
    80004938:	a039                	j	80004946 <pipealloc+0xb2>
    8000493a:	6088                	ld	a0,0(s1)
    8000493c:	c51d                	beqz	a0,8000496a <pipealloc+0xd6>
    fileclose(*f0);
    8000493e:	00000097          	auipc	ra,0x0
    80004942:	c26080e7          	jalr	-986(ra) # 80004564 <fileclose>
  if(*f1)
    80004946:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000494a:	557d                	li	a0,-1
  if(*f1)
    8000494c:	c799                	beqz	a5,8000495a <pipealloc+0xc6>
    fileclose(*f1);
    8000494e:	853e                	mv	a0,a5
    80004950:	00000097          	auipc	ra,0x0
    80004954:	c14080e7          	jalr	-1004(ra) # 80004564 <fileclose>
  return -1;
    80004958:	557d                	li	a0,-1
}
    8000495a:	70a2                	ld	ra,40(sp)
    8000495c:	7402                	ld	s0,32(sp)
    8000495e:	64e2                	ld	s1,24(sp)
    80004960:	6942                	ld	s2,16(sp)
    80004962:	69a2                	ld	s3,8(sp)
    80004964:	6a02                	ld	s4,0(sp)
    80004966:	6145                	addi	sp,sp,48
    80004968:	8082                	ret
  return -1;
    8000496a:	557d                	li	a0,-1
    8000496c:	b7fd                	j	8000495a <pipealloc+0xc6>

000000008000496e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000496e:	1101                	addi	sp,sp,-32
    80004970:	ec06                	sd	ra,24(sp)
    80004972:	e822                	sd	s0,16(sp)
    80004974:	e426                	sd	s1,8(sp)
    80004976:	e04a                	sd	s2,0(sp)
    80004978:	1000                	addi	s0,sp,32
    8000497a:	84aa                	mv	s1,a0
    8000497c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000497e:	ffffc097          	auipc	ra,0xffffc
    80004982:	258080e7          	jalr	600(ra) # 80000bd6 <acquire>
  if(writable){
    80004986:	02090d63          	beqz	s2,800049c0 <pipeclose+0x52>
    pi->writeopen = 0;
    8000498a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000498e:	21848513          	addi	a0,s1,536
    80004992:	ffffd097          	auipc	ra,0xffffd
    80004996:	726080e7          	jalr	1830(ra) # 800020b8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000499a:	2204b783          	ld	a5,544(s1)
    8000499e:	eb95                	bnez	a5,800049d2 <pipeclose+0x64>
    release(&pi->lock);
    800049a0:	8526                	mv	a0,s1
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	2e8080e7          	jalr	744(ra) # 80000c8a <release>
    kfree((char*)pi);
    800049aa:	8526                	mv	a0,s1
    800049ac:	ffffc097          	auipc	ra,0xffffc
    800049b0:	03e080e7          	jalr	62(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    800049b4:	60e2                	ld	ra,24(sp)
    800049b6:	6442                	ld	s0,16(sp)
    800049b8:	64a2                	ld	s1,8(sp)
    800049ba:	6902                	ld	s2,0(sp)
    800049bc:	6105                	addi	sp,sp,32
    800049be:	8082                	ret
    pi->readopen = 0;
    800049c0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800049c4:	21c48513          	addi	a0,s1,540
    800049c8:	ffffd097          	auipc	ra,0xffffd
    800049cc:	6f0080e7          	jalr	1776(ra) # 800020b8 <wakeup>
    800049d0:	b7e9                	j	8000499a <pipeclose+0x2c>
    release(&pi->lock);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffc097          	auipc	ra,0xffffc
    800049d8:	2b6080e7          	jalr	694(ra) # 80000c8a <release>
}
    800049dc:	bfe1                	j	800049b4 <pipeclose+0x46>

00000000800049de <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800049de:	711d                	addi	sp,sp,-96
    800049e0:	ec86                	sd	ra,88(sp)
    800049e2:	e8a2                	sd	s0,80(sp)
    800049e4:	e4a6                	sd	s1,72(sp)
    800049e6:	e0ca                	sd	s2,64(sp)
    800049e8:	fc4e                	sd	s3,56(sp)
    800049ea:	f852                	sd	s4,48(sp)
    800049ec:	f456                	sd	s5,40(sp)
    800049ee:	f05a                	sd	s6,32(sp)
    800049f0:	ec5e                	sd	s7,24(sp)
    800049f2:	e862                	sd	s8,16(sp)
    800049f4:	1080                	addi	s0,sp,96
    800049f6:	84aa                	mv	s1,a0
    800049f8:	8aae                	mv	s5,a1
    800049fa:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800049fc:	ffffd097          	auipc	ra,0xffffd
    80004a00:	fb0080e7          	jalr	-80(ra) # 800019ac <myproc>
    80004a04:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a06:	8526                	mv	a0,s1
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	1ce080e7          	jalr	462(ra) # 80000bd6 <acquire>
  while(i < n){
    80004a10:	0b405663          	blez	s4,80004abc <pipewrite+0xde>
  int i = 0;
    80004a14:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a16:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004a18:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a1c:	21c48b93          	addi	s7,s1,540
    80004a20:	a089                	j	80004a62 <pipewrite+0x84>
      release(&pi->lock);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffc097          	auipc	ra,0xffffc
    80004a28:	266080e7          	jalr	614(ra) # 80000c8a <release>
      return -1;
    80004a2c:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004a2e:	854a                	mv	a0,s2
    80004a30:	60e6                	ld	ra,88(sp)
    80004a32:	6446                	ld	s0,80(sp)
    80004a34:	64a6                	ld	s1,72(sp)
    80004a36:	6906                	ld	s2,64(sp)
    80004a38:	79e2                	ld	s3,56(sp)
    80004a3a:	7a42                	ld	s4,48(sp)
    80004a3c:	7aa2                	ld	s5,40(sp)
    80004a3e:	7b02                	ld	s6,32(sp)
    80004a40:	6be2                	ld	s7,24(sp)
    80004a42:	6c42                	ld	s8,16(sp)
    80004a44:	6125                	addi	sp,sp,96
    80004a46:	8082                	ret
      wakeup(&pi->nread);
    80004a48:	8562                	mv	a0,s8
    80004a4a:	ffffd097          	auipc	ra,0xffffd
    80004a4e:	66e080e7          	jalr	1646(ra) # 800020b8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004a52:	85a6                	mv	a1,s1
    80004a54:	855e                	mv	a0,s7
    80004a56:	ffffd097          	auipc	ra,0xffffd
    80004a5a:	5fe080e7          	jalr	1534(ra) # 80002054 <sleep>
  while(i < n){
    80004a5e:	07495063          	bge	s2,s4,80004abe <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004a62:	2204a783          	lw	a5,544(s1)
    80004a66:	dfd5                	beqz	a5,80004a22 <pipewrite+0x44>
    80004a68:	854e                	mv	a0,s3
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	8a8080e7          	jalr	-1880(ra) # 80002312 <killed>
    80004a72:	f945                	bnez	a0,80004a22 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004a74:	2184a783          	lw	a5,536(s1)
    80004a78:	21c4a703          	lw	a4,540(s1)
    80004a7c:	2007879b          	addiw	a5,a5,512
    80004a80:	fcf704e3          	beq	a4,a5,80004a48 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a84:	4685                	li	a3,1
    80004a86:	01590633          	add	a2,s2,s5
    80004a8a:	faf40593          	addi	a1,s0,-81
    80004a8e:	0709b503          	ld	a0,112(s3)
    80004a92:	ffffd097          	auipc	ra,0xffffd
    80004a96:	c62080e7          	jalr	-926(ra) # 800016f4 <copyin>
    80004a9a:	03650263          	beq	a0,s6,80004abe <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004a9e:	21c4a783          	lw	a5,540(s1)
    80004aa2:	0017871b          	addiw	a4,a5,1
    80004aa6:	20e4ae23          	sw	a4,540(s1)
    80004aaa:	1ff7f793          	andi	a5,a5,511
    80004aae:	97a6                	add	a5,a5,s1
    80004ab0:	faf44703          	lbu	a4,-81(s0)
    80004ab4:	00e78c23          	sb	a4,24(a5)
      i++;
    80004ab8:	2905                	addiw	s2,s2,1
    80004aba:	b755                	j	80004a5e <pipewrite+0x80>
  int i = 0;
    80004abc:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004abe:	21848513          	addi	a0,s1,536
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	5f6080e7          	jalr	1526(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffc097          	auipc	ra,0xffffc
    80004ad0:	1be080e7          	jalr	446(ra) # 80000c8a <release>
  return i;
    80004ad4:	bfa9                	j	80004a2e <pipewrite+0x50>

0000000080004ad6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ad6:	715d                	addi	sp,sp,-80
    80004ad8:	e486                	sd	ra,72(sp)
    80004ada:	e0a2                	sd	s0,64(sp)
    80004adc:	fc26                	sd	s1,56(sp)
    80004ade:	f84a                	sd	s2,48(sp)
    80004ae0:	f44e                	sd	s3,40(sp)
    80004ae2:	f052                	sd	s4,32(sp)
    80004ae4:	ec56                	sd	s5,24(sp)
    80004ae6:	e85a                	sd	s6,16(sp)
    80004ae8:	0880                	addi	s0,sp,80
    80004aea:	84aa                	mv	s1,a0
    80004aec:	892e                	mv	s2,a1
    80004aee:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004af0:	ffffd097          	auipc	ra,0xffffd
    80004af4:	ebc080e7          	jalr	-324(ra) # 800019ac <myproc>
    80004af8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffc097          	auipc	ra,0xffffc
    80004b00:	0da080e7          	jalr	218(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b04:	2184a703          	lw	a4,536(s1)
    80004b08:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b0c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b10:	02f71763          	bne	a4,a5,80004b3e <piperead+0x68>
    80004b14:	2244a783          	lw	a5,548(s1)
    80004b18:	c39d                	beqz	a5,80004b3e <piperead+0x68>
    if(killed(pr)){
    80004b1a:	8552                	mv	a0,s4
    80004b1c:	ffffd097          	auipc	ra,0xffffd
    80004b20:	7f6080e7          	jalr	2038(ra) # 80002312 <killed>
    80004b24:	e941                	bnez	a0,80004bb4 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b26:	85a6                	mv	a1,s1
    80004b28:	854e                	mv	a0,s3
    80004b2a:	ffffd097          	auipc	ra,0xffffd
    80004b2e:	52a080e7          	jalr	1322(ra) # 80002054 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b32:	2184a703          	lw	a4,536(s1)
    80004b36:	21c4a783          	lw	a5,540(s1)
    80004b3a:	fcf70de3          	beq	a4,a5,80004b14 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b3e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b40:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b42:	05505363          	blez	s5,80004b88 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004b46:	2184a783          	lw	a5,536(s1)
    80004b4a:	21c4a703          	lw	a4,540(s1)
    80004b4e:	02f70d63          	beq	a4,a5,80004b88 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b52:	0017871b          	addiw	a4,a5,1
    80004b56:	20e4ac23          	sw	a4,536(s1)
    80004b5a:	1ff7f793          	andi	a5,a5,511
    80004b5e:	97a6                	add	a5,a5,s1
    80004b60:	0187c783          	lbu	a5,24(a5)
    80004b64:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b68:	4685                	li	a3,1
    80004b6a:	fbf40613          	addi	a2,s0,-65
    80004b6e:	85ca                	mv	a1,s2
    80004b70:	070a3503          	ld	a0,112(s4)
    80004b74:	ffffd097          	auipc	ra,0xffffd
    80004b78:	af4080e7          	jalr	-1292(ra) # 80001668 <copyout>
    80004b7c:	01650663          	beq	a0,s6,80004b88 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b80:	2985                	addiw	s3,s3,1
    80004b82:	0905                	addi	s2,s2,1
    80004b84:	fd3a91e3          	bne	s5,s3,80004b46 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004b88:	21c48513          	addi	a0,s1,540
    80004b8c:	ffffd097          	auipc	ra,0xffffd
    80004b90:	52c080e7          	jalr	1324(ra) # 800020b8 <wakeup>
  release(&pi->lock);
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffc097          	auipc	ra,0xffffc
    80004b9a:	0f4080e7          	jalr	244(ra) # 80000c8a <release>
  return i;
}
    80004b9e:	854e                	mv	a0,s3
    80004ba0:	60a6                	ld	ra,72(sp)
    80004ba2:	6406                	ld	s0,64(sp)
    80004ba4:	74e2                	ld	s1,56(sp)
    80004ba6:	7942                	ld	s2,48(sp)
    80004ba8:	79a2                	ld	s3,40(sp)
    80004baa:	7a02                	ld	s4,32(sp)
    80004bac:	6ae2                	ld	s5,24(sp)
    80004bae:	6b42                	ld	s6,16(sp)
    80004bb0:	6161                	addi	sp,sp,80
    80004bb2:	8082                	ret
      release(&pi->lock);
    80004bb4:	8526                	mv	a0,s1
    80004bb6:	ffffc097          	auipc	ra,0xffffc
    80004bba:	0d4080e7          	jalr	212(ra) # 80000c8a <release>
      return -1;
    80004bbe:	59fd                	li	s3,-1
    80004bc0:	bff9                	j	80004b9e <piperead+0xc8>

0000000080004bc2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004bc2:	1141                	addi	sp,sp,-16
    80004bc4:	e422                	sd	s0,8(sp)
    80004bc6:	0800                	addi	s0,sp,16
    80004bc8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004bca:	8905                	andi	a0,a0,1
    80004bcc:	c111                	beqz	a0,80004bd0 <flags2perm+0xe>
      perm = PTE_X;
    80004bce:	4521                	li	a0,8
    if(flags & 0x2)
    80004bd0:	8b89                	andi	a5,a5,2
    80004bd2:	c399                	beqz	a5,80004bd8 <flags2perm+0x16>
      perm |= PTE_W;
    80004bd4:	00456513          	ori	a0,a0,4
    return perm;
}
    80004bd8:	6422                	ld	s0,8(sp)
    80004bda:	0141                	addi	sp,sp,16
    80004bdc:	8082                	ret

0000000080004bde <exec>:

int
exec(char *path, char **argv)
{
    80004bde:	de010113          	addi	sp,sp,-544
    80004be2:	20113c23          	sd	ra,536(sp)
    80004be6:	20813823          	sd	s0,528(sp)
    80004bea:	20913423          	sd	s1,520(sp)
    80004bee:	21213023          	sd	s2,512(sp)
    80004bf2:	ffce                	sd	s3,504(sp)
    80004bf4:	fbd2                	sd	s4,496(sp)
    80004bf6:	f7d6                	sd	s5,488(sp)
    80004bf8:	f3da                	sd	s6,480(sp)
    80004bfa:	efde                	sd	s7,472(sp)
    80004bfc:	ebe2                	sd	s8,464(sp)
    80004bfe:	e7e6                	sd	s9,456(sp)
    80004c00:	e3ea                	sd	s10,448(sp)
    80004c02:	ff6e                	sd	s11,440(sp)
    80004c04:	1400                	addi	s0,sp,544
    80004c06:	892a                	mv	s2,a0
    80004c08:	dea43423          	sd	a0,-536(s0)
    80004c0c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c10:	ffffd097          	auipc	ra,0xffffd
    80004c14:	d9c080e7          	jalr	-612(ra) # 800019ac <myproc>
    80004c18:	84aa                	mv	s1,a0

  begin_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	47e080e7          	jalr	1150(ra) # 80004098 <begin_op>

  if((ip = namei(path)) == 0){
    80004c22:	854a                	mv	a0,s2
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	258080e7          	jalr	600(ra) # 80003e7c <namei>
    80004c2c:	c93d                	beqz	a0,80004ca2 <exec+0xc4>
    80004c2e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	aa6080e7          	jalr	-1370(ra) # 800036d6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c38:	04000713          	li	a4,64
    80004c3c:	4681                	li	a3,0
    80004c3e:	e5040613          	addi	a2,s0,-432
    80004c42:	4581                	li	a1,0
    80004c44:	8556                	mv	a0,s5
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	d44080e7          	jalr	-700(ra) # 8000398a <readi>
    80004c4e:	04000793          	li	a5,64
    80004c52:	00f51a63          	bne	a0,a5,80004c66 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004c56:	e5042703          	lw	a4,-432(s0)
    80004c5a:	464c47b7          	lui	a5,0x464c4
    80004c5e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c62:	04f70663          	beq	a4,a5,80004cae <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c66:	8556                	mv	a0,s5
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	cd0080e7          	jalr	-816(ra) # 80003938 <iunlockput>
    end_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	4a8080e7          	jalr	1192(ra) # 80004118 <end_op>
  }
  return -1;
    80004c78:	557d                	li	a0,-1
}
    80004c7a:	21813083          	ld	ra,536(sp)
    80004c7e:	21013403          	ld	s0,528(sp)
    80004c82:	20813483          	ld	s1,520(sp)
    80004c86:	20013903          	ld	s2,512(sp)
    80004c8a:	79fe                	ld	s3,504(sp)
    80004c8c:	7a5e                	ld	s4,496(sp)
    80004c8e:	7abe                	ld	s5,488(sp)
    80004c90:	7b1e                	ld	s6,480(sp)
    80004c92:	6bfe                	ld	s7,472(sp)
    80004c94:	6c5e                	ld	s8,464(sp)
    80004c96:	6cbe                	ld	s9,456(sp)
    80004c98:	6d1e                	ld	s10,448(sp)
    80004c9a:	7dfa                	ld	s11,440(sp)
    80004c9c:	22010113          	addi	sp,sp,544
    80004ca0:	8082                	ret
    end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	476080e7          	jalr	1142(ra) # 80004118 <end_op>
    return -1;
    80004caa:	557d                	li	a0,-1
    80004cac:	b7f9                	j	80004c7a <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004cae:	8526                	mv	a0,s1
    80004cb0:	ffffd097          	auipc	ra,0xffffd
    80004cb4:	dc0080e7          	jalr	-576(ra) # 80001a70 <proc_pagetable>
    80004cb8:	8b2a                	mv	s6,a0
    80004cba:	d555                	beqz	a0,80004c66 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cbc:	e7042783          	lw	a5,-400(s0)
    80004cc0:	e8845703          	lhu	a4,-376(s0)
    80004cc4:	c735                	beqz	a4,80004d30 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004cc6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cc8:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004ccc:	6a05                	lui	s4,0x1
    80004cce:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004cd2:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004cd6:	6d85                	lui	s11,0x1
    80004cd8:	7d7d                	lui	s10,0xfffff
    80004cda:	a481                	j	80004f1a <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004cdc:	00004517          	auipc	a0,0x4
    80004ce0:	a0c50513          	addi	a0,a0,-1524 # 800086e8 <syscalls+0x288>
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	85a080e7          	jalr	-1958(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004cec:	874a                	mv	a4,s2
    80004cee:	009c86bb          	addw	a3,s9,s1
    80004cf2:	4581                	li	a1,0
    80004cf4:	8556                	mv	a0,s5
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	c94080e7          	jalr	-876(ra) # 8000398a <readi>
    80004cfe:	2501                	sext.w	a0,a0
    80004d00:	1aa91a63          	bne	s2,a0,80004eb4 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004d04:	009d84bb          	addw	s1,s11,s1
    80004d08:	013d09bb          	addw	s3,s10,s3
    80004d0c:	1f74f763          	bgeu	s1,s7,80004efa <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004d10:	02049593          	slli	a1,s1,0x20
    80004d14:	9181                	srli	a1,a1,0x20
    80004d16:	95e2                	add	a1,a1,s8
    80004d18:	855a                	mv	a0,s6
    80004d1a:	ffffc097          	auipc	ra,0xffffc
    80004d1e:	342080e7          	jalr	834(ra) # 8000105c <walkaddr>
    80004d22:	862a                	mv	a2,a0
    if(pa == 0)
    80004d24:	dd45                	beqz	a0,80004cdc <exec+0xfe>
      n = PGSIZE;
    80004d26:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d28:	fd49f2e3          	bgeu	s3,s4,80004cec <exec+0x10e>
      n = sz - i;
    80004d2c:	894e                	mv	s2,s3
    80004d2e:	bf7d                	j	80004cec <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d30:	4901                	li	s2,0
  iunlockput(ip);
    80004d32:	8556                	mv	a0,s5
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	c04080e7          	jalr	-1020(ra) # 80003938 <iunlockput>
  end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	3dc080e7          	jalr	988(ra) # 80004118 <end_op>
  p = myproc();
    80004d44:	ffffd097          	auipc	ra,0xffffd
    80004d48:	c68080e7          	jalr	-920(ra) # 800019ac <myproc>
    80004d4c:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004d4e:	06853d03          	ld	s10,104(a0)
  sz = PGROUNDUP(sz);
    80004d52:	6785                	lui	a5,0x1
    80004d54:	17fd                	addi	a5,a5,-1
    80004d56:	993e                	add	s2,s2,a5
    80004d58:	77fd                	lui	a5,0xfffff
    80004d5a:	00f977b3          	and	a5,s2,a5
    80004d5e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004d62:	4691                	li	a3,4
    80004d64:	6609                	lui	a2,0x2
    80004d66:	963e                	add	a2,a2,a5
    80004d68:	85be                	mv	a1,a5
    80004d6a:	855a                	mv	a0,s6
    80004d6c:	ffffc097          	auipc	ra,0xffffc
    80004d70:	6a4080e7          	jalr	1700(ra) # 80001410 <uvmalloc>
    80004d74:	8c2a                	mv	s8,a0
  ip = 0;
    80004d76:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004d78:	12050e63          	beqz	a0,80004eb4 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004d7c:	75f9                	lui	a1,0xffffe
    80004d7e:	95aa                	add	a1,a1,a0
    80004d80:	855a                	mv	a0,s6
    80004d82:	ffffd097          	auipc	ra,0xffffd
    80004d86:	8b4080e7          	jalr	-1868(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    80004d8a:	7afd                	lui	s5,0xfffff
    80004d8c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004d8e:	df043783          	ld	a5,-528(s0)
    80004d92:	6388                	ld	a0,0(a5)
    80004d94:	c925                	beqz	a0,80004e04 <exec+0x226>
    80004d96:	e9040993          	addi	s3,s0,-368
    80004d9a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004d9e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004da0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004da2:	ffffc097          	auipc	ra,0xffffc
    80004da6:	0ac080e7          	jalr	172(ra) # 80000e4e <strlen>
    80004daa:	0015079b          	addiw	a5,a0,1
    80004dae:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004db2:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004db6:	13596663          	bltu	s2,s5,80004ee2 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004dba:	df043d83          	ld	s11,-528(s0)
    80004dbe:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004dc2:	8552                	mv	a0,s4
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	08a080e7          	jalr	138(ra) # 80000e4e <strlen>
    80004dcc:	0015069b          	addiw	a3,a0,1
    80004dd0:	8652                	mv	a2,s4
    80004dd2:	85ca                	mv	a1,s2
    80004dd4:	855a                	mv	a0,s6
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	892080e7          	jalr	-1902(ra) # 80001668 <copyout>
    80004dde:	10054663          	bltz	a0,80004eea <exec+0x30c>
    ustack[argc] = sp;
    80004de2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004de6:	0485                	addi	s1,s1,1
    80004de8:	008d8793          	addi	a5,s11,8
    80004dec:	def43823          	sd	a5,-528(s0)
    80004df0:	008db503          	ld	a0,8(s11)
    80004df4:	c911                	beqz	a0,80004e08 <exec+0x22a>
    if(argc >= MAXARG)
    80004df6:	09a1                	addi	s3,s3,8
    80004df8:	fb3c95e3          	bne	s9,s3,80004da2 <exec+0x1c4>
  sz = sz1;
    80004dfc:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e00:	4a81                	li	s5,0
    80004e02:	a84d                	j	80004eb4 <exec+0x2d6>
  sp = sz;
    80004e04:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e06:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e08:	00349793          	slli	a5,s1,0x3
    80004e0c:	f9040713          	addi	a4,s0,-112
    80004e10:	97ba                	add	a5,a5,a4
    80004e12:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdc980>
  sp -= (argc+1) * sizeof(uint64);
    80004e16:	00148693          	addi	a3,s1,1
    80004e1a:	068e                	slli	a3,a3,0x3
    80004e1c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e20:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e24:	01597663          	bgeu	s2,s5,80004e30 <exec+0x252>
  sz = sz1;
    80004e28:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e2c:	4a81                	li	s5,0
    80004e2e:	a059                	j	80004eb4 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e30:	e9040613          	addi	a2,s0,-368
    80004e34:	85ca                	mv	a1,s2
    80004e36:	855a                	mv	a0,s6
    80004e38:	ffffd097          	auipc	ra,0xffffd
    80004e3c:	830080e7          	jalr	-2000(ra) # 80001668 <copyout>
    80004e40:	0a054963          	bltz	a0,80004ef2 <exec+0x314>
  p->trapframe->a1 = sp;
    80004e44:	078bb783          	ld	a5,120(s7) # 1078 <_entry-0x7fffef88>
    80004e48:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e4c:	de843783          	ld	a5,-536(s0)
    80004e50:	0007c703          	lbu	a4,0(a5)
    80004e54:	cf11                	beqz	a4,80004e70 <exec+0x292>
    80004e56:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e58:	02f00693          	li	a3,47
    80004e5c:	a039                	j	80004e6a <exec+0x28c>
      last = s+1;
    80004e5e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004e62:	0785                	addi	a5,a5,1
    80004e64:	fff7c703          	lbu	a4,-1(a5)
    80004e68:	c701                	beqz	a4,80004e70 <exec+0x292>
    if(*s == '/')
    80004e6a:	fed71ce3          	bne	a4,a3,80004e62 <exec+0x284>
    80004e6e:	bfc5                	j	80004e5e <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e70:	4641                	li	a2,16
    80004e72:	de843583          	ld	a1,-536(s0)
    80004e76:	178b8513          	addi	a0,s7,376
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	fa2080e7          	jalr	-94(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80004e82:	070bb503          	ld	a0,112(s7)
  p->pagetable = pagetable;
    80004e86:	076bb823          	sd	s6,112(s7)
  p->sz = sz;
    80004e8a:	078bb423          	sd	s8,104(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004e8e:	078bb783          	ld	a5,120(s7)
    80004e92:	e6843703          	ld	a4,-408(s0)
    80004e96:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004e98:	078bb783          	ld	a5,120(s7)
    80004e9c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ea0:	85ea                	mv	a1,s10
    80004ea2:	ffffd097          	auipc	ra,0xffffd
    80004ea6:	c6a080e7          	jalr	-918(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004eaa:	0004851b          	sext.w	a0,s1
    80004eae:	b3f1                	j	80004c7a <exec+0x9c>
    80004eb0:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004eb4:	df843583          	ld	a1,-520(s0)
    80004eb8:	855a                	mv	a0,s6
    80004eba:	ffffd097          	auipc	ra,0xffffd
    80004ebe:	c52080e7          	jalr	-942(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80004ec2:	da0a92e3          	bnez	s5,80004c66 <exec+0x88>
  return -1;
    80004ec6:	557d                	li	a0,-1
    80004ec8:	bb4d                	j	80004c7a <exec+0x9c>
    80004eca:	df243c23          	sd	s2,-520(s0)
    80004ece:	b7dd                	j	80004eb4 <exec+0x2d6>
    80004ed0:	df243c23          	sd	s2,-520(s0)
    80004ed4:	b7c5                	j	80004eb4 <exec+0x2d6>
    80004ed6:	df243c23          	sd	s2,-520(s0)
    80004eda:	bfe9                	j	80004eb4 <exec+0x2d6>
    80004edc:	df243c23          	sd	s2,-520(s0)
    80004ee0:	bfd1                	j	80004eb4 <exec+0x2d6>
  sz = sz1;
    80004ee2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004ee6:	4a81                	li	s5,0
    80004ee8:	b7f1                	j	80004eb4 <exec+0x2d6>
  sz = sz1;
    80004eea:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004eee:	4a81                	li	s5,0
    80004ef0:	b7d1                	j	80004eb4 <exec+0x2d6>
  sz = sz1;
    80004ef2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004ef6:	4a81                	li	s5,0
    80004ef8:	bf75                	j	80004eb4 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004efa:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004efe:	e0843783          	ld	a5,-504(s0)
    80004f02:	0017869b          	addiw	a3,a5,1
    80004f06:	e0d43423          	sd	a3,-504(s0)
    80004f0a:	e0043783          	ld	a5,-512(s0)
    80004f0e:	0387879b          	addiw	a5,a5,56
    80004f12:	e8845703          	lhu	a4,-376(s0)
    80004f16:	e0e6dee3          	bge	a3,a4,80004d32 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f1a:	2781                	sext.w	a5,a5
    80004f1c:	e0f43023          	sd	a5,-512(s0)
    80004f20:	03800713          	li	a4,56
    80004f24:	86be                	mv	a3,a5
    80004f26:	e1840613          	addi	a2,s0,-488
    80004f2a:	4581                	li	a1,0
    80004f2c:	8556                	mv	a0,s5
    80004f2e:	fffff097          	auipc	ra,0xfffff
    80004f32:	a5c080e7          	jalr	-1444(ra) # 8000398a <readi>
    80004f36:	03800793          	li	a5,56
    80004f3a:	f6f51be3          	bne	a0,a5,80004eb0 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004f3e:	e1842783          	lw	a5,-488(s0)
    80004f42:	4705                	li	a4,1
    80004f44:	fae79de3          	bne	a5,a4,80004efe <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004f48:	e4043483          	ld	s1,-448(s0)
    80004f4c:	e3843783          	ld	a5,-456(s0)
    80004f50:	f6f4ede3          	bltu	s1,a5,80004eca <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f54:	e2843783          	ld	a5,-472(s0)
    80004f58:	94be                	add	s1,s1,a5
    80004f5a:	f6f4ebe3          	bltu	s1,a5,80004ed0 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004f5e:	de043703          	ld	a4,-544(s0)
    80004f62:	8ff9                	and	a5,a5,a4
    80004f64:	fbad                	bnez	a5,80004ed6 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f66:	e1c42503          	lw	a0,-484(s0)
    80004f6a:	00000097          	auipc	ra,0x0
    80004f6e:	c58080e7          	jalr	-936(ra) # 80004bc2 <flags2perm>
    80004f72:	86aa                	mv	a3,a0
    80004f74:	8626                	mv	a2,s1
    80004f76:	85ca                	mv	a1,s2
    80004f78:	855a                	mv	a0,s6
    80004f7a:	ffffc097          	auipc	ra,0xffffc
    80004f7e:	496080e7          	jalr	1174(ra) # 80001410 <uvmalloc>
    80004f82:	dea43c23          	sd	a0,-520(s0)
    80004f86:	d939                	beqz	a0,80004edc <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004f88:	e2843c03          	ld	s8,-472(s0)
    80004f8c:	e2042c83          	lw	s9,-480(s0)
    80004f90:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004f94:	f60b83e3          	beqz	s7,80004efa <exec+0x31c>
    80004f98:	89de                	mv	s3,s7
    80004f9a:	4481                	li	s1,0
    80004f9c:	bb95                	j	80004d10 <exec+0x132>

0000000080004f9e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004f9e:	7179                	addi	sp,sp,-48
    80004fa0:	f406                	sd	ra,40(sp)
    80004fa2:	f022                	sd	s0,32(sp)
    80004fa4:	ec26                	sd	s1,24(sp)
    80004fa6:	e84a                	sd	s2,16(sp)
    80004fa8:	1800                	addi	s0,sp,48
    80004faa:	892e                	mv	s2,a1
    80004fac:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004fae:	fdc40593          	addi	a1,s0,-36
    80004fb2:	ffffe097          	auipc	ra,0xffffe
    80004fb6:	b76080e7          	jalr	-1162(ra) # 80002b28 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fba:	fdc42703          	lw	a4,-36(s0)
    80004fbe:	47bd                	li	a5,15
    80004fc0:	02e7eb63          	bltu	a5,a4,80004ff6 <argfd+0x58>
    80004fc4:	ffffd097          	auipc	ra,0xffffd
    80004fc8:	9e8080e7          	jalr	-1560(ra) # 800019ac <myproc>
    80004fcc:	fdc42703          	lw	a4,-36(s0)
    80004fd0:	01e70793          	addi	a5,a4,30
    80004fd4:	078e                	slli	a5,a5,0x3
    80004fd6:	953e                	add	a0,a0,a5
    80004fd8:	611c                	ld	a5,0(a0)
    80004fda:	c385                	beqz	a5,80004ffa <argfd+0x5c>
    return -1;
  if(pfd)
    80004fdc:	00090463          	beqz	s2,80004fe4 <argfd+0x46>
    *pfd = fd;
    80004fe0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004fe4:	4501                	li	a0,0
  if(pf)
    80004fe6:	c091                	beqz	s1,80004fea <argfd+0x4c>
    *pf = f;
    80004fe8:	e09c                	sd	a5,0(s1)
}
    80004fea:	70a2                	ld	ra,40(sp)
    80004fec:	7402                	ld	s0,32(sp)
    80004fee:	64e2                	ld	s1,24(sp)
    80004ff0:	6942                	ld	s2,16(sp)
    80004ff2:	6145                	addi	sp,sp,48
    80004ff4:	8082                	ret
    return -1;
    80004ff6:	557d                	li	a0,-1
    80004ff8:	bfcd                	j	80004fea <argfd+0x4c>
    80004ffa:	557d                	li	a0,-1
    80004ffc:	b7fd                	j	80004fea <argfd+0x4c>

0000000080004ffe <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ffe:	1101                	addi	sp,sp,-32
    80005000:	ec06                	sd	ra,24(sp)
    80005002:	e822                	sd	s0,16(sp)
    80005004:	e426                	sd	s1,8(sp)
    80005006:	1000                	addi	s0,sp,32
    80005008:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000500a:	ffffd097          	auipc	ra,0xffffd
    8000500e:	9a2080e7          	jalr	-1630(ra) # 800019ac <myproc>
    80005012:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005014:	0f050793          	addi	a5,a0,240
    80005018:	4501                	li	a0,0
    8000501a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000501c:	6398                	ld	a4,0(a5)
    8000501e:	cb19                	beqz	a4,80005034 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005020:	2505                	addiw	a0,a0,1
    80005022:	07a1                	addi	a5,a5,8
    80005024:	fed51ce3          	bne	a0,a3,8000501c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005028:	557d                	li	a0,-1
}
    8000502a:	60e2                	ld	ra,24(sp)
    8000502c:	6442                	ld	s0,16(sp)
    8000502e:	64a2                	ld	s1,8(sp)
    80005030:	6105                	addi	sp,sp,32
    80005032:	8082                	ret
      p->ofile[fd] = f;
    80005034:	01e50793          	addi	a5,a0,30
    80005038:	078e                	slli	a5,a5,0x3
    8000503a:	963e                	add	a2,a2,a5
    8000503c:	e204                	sd	s1,0(a2)
      return fd;
    8000503e:	b7f5                	j	8000502a <fdalloc+0x2c>

0000000080005040 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005040:	715d                	addi	sp,sp,-80
    80005042:	e486                	sd	ra,72(sp)
    80005044:	e0a2                	sd	s0,64(sp)
    80005046:	fc26                	sd	s1,56(sp)
    80005048:	f84a                	sd	s2,48(sp)
    8000504a:	f44e                	sd	s3,40(sp)
    8000504c:	f052                	sd	s4,32(sp)
    8000504e:	ec56                	sd	s5,24(sp)
    80005050:	e85a                	sd	s6,16(sp)
    80005052:	0880                	addi	s0,sp,80
    80005054:	8b2e                	mv	s6,a1
    80005056:	89b2                	mv	s3,a2
    80005058:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000505a:	fb040593          	addi	a1,s0,-80
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	e3c080e7          	jalr	-452(ra) # 80003e9a <nameiparent>
    80005066:	84aa                	mv	s1,a0
    80005068:	14050f63          	beqz	a0,800051c6 <create+0x186>
    return 0;

  ilock(dp);
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	66a080e7          	jalr	1642(ra) # 800036d6 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005074:	4601                	li	a2,0
    80005076:	fb040593          	addi	a1,s0,-80
    8000507a:	8526                	mv	a0,s1
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	b3e080e7          	jalr	-1218(ra) # 80003bba <dirlookup>
    80005084:	8aaa                	mv	s5,a0
    80005086:	c931                	beqz	a0,800050da <create+0x9a>
    iunlockput(dp);
    80005088:	8526                	mv	a0,s1
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	8ae080e7          	jalr	-1874(ra) # 80003938 <iunlockput>
    ilock(ip);
    80005092:	8556                	mv	a0,s5
    80005094:	ffffe097          	auipc	ra,0xffffe
    80005098:	642080e7          	jalr	1602(ra) # 800036d6 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000509c:	000b059b          	sext.w	a1,s6
    800050a0:	4789                	li	a5,2
    800050a2:	02f59563          	bne	a1,a5,800050cc <create+0x8c>
    800050a6:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdcac4>
    800050aa:	37f9                	addiw	a5,a5,-2
    800050ac:	17c2                	slli	a5,a5,0x30
    800050ae:	93c1                	srli	a5,a5,0x30
    800050b0:	4705                	li	a4,1
    800050b2:	00f76d63          	bltu	a4,a5,800050cc <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800050b6:	8556                	mv	a0,s5
    800050b8:	60a6                	ld	ra,72(sp)
    800050ba:	6406                	ld	s0,64(sp)
    800050bc:	74e2                	ld	s1,56(sp)
    800050be:	7942                	ld	s2,48(sp)
    800050c0:	79a2                	ld	s3,40(sp)
    800050c2:	7a02                	ld	s4,32(sp)
    800050c4:	6ae2                	ld	s5,24(sp)
    800050c6:	6b42                	ld	s6,16(sp)
    800050c8:	6161                	addi	sp,sp,80
    800050ca:	8082                	ret
    iunlockput(ip);
    800050cc:	8556                	mv	a0,s5
    800050ce:	fffff097          	auipc	ra,0xfffff
    800050d2:	86a080e7          	jalr	-1942(ra) # 80003938 <iunlockput>
    return 0;
    800050d6:	4a81                	li	s5,0
    800050d8:	bff9                	j	800050b6 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800050da:	85da                	mv	a1,s6
    800050dc:	4088                	lw	a0,0(s1)
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	45c080e7          	jalr	1116(ra) # 8000353a <ialloc>
    800050e6:	8a2a                	mv	s4,a0
    800050e8:	c539                	beqz	a0,80005136 <create+0xf6>
  ilock(ip);
    800050ea:	ffffe097          	auipc	ra,0xffffe
    800050ee:	5ec080e7          	jalr	1516(ra) # 800036d6 <ilock>
  ip->major = major;
    800050f2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800050f6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800050fa:	4905                	li	s2,1
    800050fc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005100:	8552                	mv	a0,s4
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	50a080e7          	jalr	1290(ra) # 8000360c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000510a:	000b059b          	sext.w	a1,s6
    8000510e:	03258b63          	beq	a1,s2,80005144 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005112:	004a2603          	lw	a2,4(s4)
    80005116:	fb040593          	addi	a1,s0,-80
    8000511a:	8526                	mv	a0,s1
    8000511c:	fffff097          	auipc	ra,0xfffff
    80005120:	cae080e7          	jalr	-850(ra) # 80003dca <dirlink>
    80005124:	06054f63          	bltz	a0,800051a2 <create+0x162>
  iunlockput(dp);
    80005128:	8526                	mv	a0,s1
    8000512a:	fffff097          	auipc	ra,0xfffff
    8000512e:	80e080e7          	jalr	-2034(ra) # 80003938 <iunlockput>
  return ip;
    80005132:	8ad2                	mv	s5,s4
    80005134:	b749                	j	800050b6 <create+0x76>
    iunlockput(dp);
    80005136:	8526                	mv	a0,s1
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	800080e7          	jalr	-2048(ra) # 80003938 <iunlockput>
    return 0;
    80005140:	8ad2                	mv	s5,s4
    80005142:	bf95                	j	800050b6 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005144:	004a2603          	lw	a2,4(s4)
    80005148:	00003597          	auipc	a1,0x3
    8000514c:	5c058593          	addi	a1,a1,1472 # 80008708 <syscalls+0x2a8>
    80005150:	8552                	mv	a0,s4
    80005152:	fffff097          	auipc	ra,0xfffff
    80005156:	c78080e7          	jalr	-904(ra) # 80003dca <dirlink>
    8000515a:	04054463          	bltz	a0,800051a2 <create+0x162>
    8000515e:	40d0                	lw	a2,4(s1)
    80005160:	00003597          	auipc	a1,0x3
    80005164:	5b058593          	addi	a1,a1,1456 # 80008710 <syscalls+0x2b0>
    80005168:	8552                	mv	a0,s4
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	c60080e7          	jalr	-928(ra) # 80003dca <dirlink>
    80005172:	02054863          	bltz	a0,800051a2 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005176:	004a2603          	lw	a2,4(s4)
    8000517a:	fb040593          	addi	a1,s0,-80
    8000517e:	8526                	mv	a0,s1
    80005180:	fffff097          	auipc	ra,0xfffff
    80005184:	c4a080e7          	jalr	-950(ra) # 80003dca <dirlink>
    80005188:	00054d63          	bltz	a0,800051a2 <create+0x162>
    dp->nlink++;  // for ".."
    8000518c:	04a4d783          	lhu	a5,74(s1)
    80005190:	2785                	addiw	a5,a5,1
    80005192:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005196:	8526                	mv	a0,s1
    80005198:	ffffe097          	auipc	ra,0xffffe
    8000519c:	474080e7          	jalr	1140(ra) # 8000360c <iupdate>
    800051a0:	b761                	j	80005128 <create+0xe8>
  ip->nlink = 0;
    800051a2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800051a6:	8552                	mv	a0,s4
    800051a8:	ffffe097          	auipc	ra,0xffffe
    800051ac:	464080e7          	jalr	1124(ra) # 8000360c <iupdate>
  iunlockput(ip);
    800051b0:	8552                	mv	a0,s4
    800051b2:	ffffe097          	auipc	ra,0xffffe
    800051b6:	786080e7          	jalr	1926(ra) # 80003938 <iunlockput>
  iunlockput(dp);
    800051ba:	8526                	mv	a0,s1
    800051bc:	ffffe097          	auipc	ra,0xffffe
    800051c0:	77c080e7          	jalr	1916(ra) # 80003938 <iunlockput>
  return 0;
    800051c4:	bdcd                	j	800050b6 <create+0x76>
    return 0;
    800051c6:	8aaa                	mv	s5,a0
    800051c8:	b5fd                	j	800050b6 <create+0x76>

00000000800051ca <sys_dup>:
{
    800051ca:	7179                	addi	sp,sp,-48
    800051cc:	f406                	sd	ra,40(sp)
    800051ce:	f022                	sd	s0,32(sp)
    800051d0:	ec26                	sd	s1,24(sp)
    800051d2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051d4:	fd840613          	addi	a2,s0,-40
    800051d8:	4581                	li	a1,0
    800051da:	4501                	li	a0,0
    800051dc:	00000097          	auipc	ra,0x0
    800051e0:	dc2080e7          	jalr	-574(ra) # 80004f9e <argfd>
    return -1;
    800051e4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051e6:	02054363          	bltz	a0,8000520c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800051ea:	fd843503          	ld	a0,-40(s0)
    800051ee:	00000097          	auipc	ra,0x0
    800051f2:	e10080e7          	jalr	-496(ra) # 80004ffe <fdalloc>
    800051f6:	84aa                	mv	s1,a0
    return -1;
    800051f8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051fa:	00054963          	bltz	a0,8000520c <sys_dup+0x42>
  filedup(f);
    800051fe:	fd843503          	ld	a0,-40(s0)
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	310080e7          	jalr	784(ra) # 80004512 <filedup>
  return fd;
    8000520a:	87a6                	mv	a5,s1
}
    8000520c:	853e                	mv	a0,a5
    8000520e:	70a2                	ld	ra,40(sp)
    80005210:	7402                	ld	s0,32(sp)
    80005212:	64e2                	ld	s1,24(sp)
    80005214:	6145                	addi	sp,sp,48
    80005216:	8082                	ret

0000000080005218 <sys_read>:
{
    80005218:	7179                	addi	sp,sp,-48
    8000521a:	f406                	sd	ra,40(sp)
    8000521c:	f022                	sd	s0,32(sp)
    8000521e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005220:	fd840593          	addi	a1,s0,-40
    80005224:	4505                	li	a0,1
    80005226:	ffffe097          	auipc	ra,0xffffe
    8000522a:	922080e7          	jalr	-1758(ra) # 80002b48 <argaddr>
  argint(2, &n);
    8000522e:	fe440593          	addi	a1,s0,-28
    80005232:	4509                	li	a0,2
    80005234:	ffffe097          	auipc	ra,0xffffe
    80005238:	8f4080e7          	jalr	-1804(ra) # 80002b28 <argint>
  if(argfd(0, 0, &f) < 0)
    8000523c:	fe840613          	addi	a2,s0,-24
    80005240:	4581                	li	a1,0
    80005242:	4501                	li	a0,0
    80005244:	00000097          	auipc	ra,0x0
    80005248:	d5a080e7          	jalr	-678(ra) # 80004f9e <argfd>
    8000524c:	87aa                	mv	a5,a0
    return -1;
    8000524e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005250:	0007cc63          	bltz	a5,80005268 <sys_read+0x50>
  return fileread(f, p, n);
    80005254:	fe442603          	lw	a2,-28(s0)
    80005258:	fd843583          	ld	a1,-40(s0)
    8000525c:	fe843503          	ld	a0,-24(s0)
    80005260:	fffff097          	auipc	ra,0xfffff
    80005264:	43e080e7          	jalr	1086(ra) # 8000469e <fileread>
}
    80005268:	70a2                	ld	ra,40(sp)
    8000526a:	7402                	ld	s0,32(sp)
    8000526c:	6145                	addi	sp,sp,48
    8000526e:	8082                	ret

0000000080005270 <sys_write>:
{
    80005270:	7179                	addi	sp,sp,-48
    80005272:	f406                	sd	ra,40(sp)
    80005274:	f022                	sd	s0,32(sp)
    80005276:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005278:	fd840593          	addi	a1,s0,-40
    8000527c:	4505                	li	a0,1
    8000527e:	ffffe097          	auipc	ra,0xffffe
    80005282:	8ca080e7          	jalr	-1846(ra) # 80002b48 <argaddr>
  argint(2, &n);
    80005286:	fe440593          	addi	a1,s0,-28
    8000528a:	4509                	li	a0,2
    8000528c:	ffffe097          	auipc	ra,0xffffe
    80005290:	89c080e7          	jalr	-1892(ra) # 80002b28 <argint>
  if(argfd(0, 0, &f) < 0)
    80005294:	fe840613          	addi	a2,s0,-24
    80005298:	4581                	li	a1,0
    8000529a:	4501                	li	a0,0
    8000529c:	00000097          	auipc	ra,0x0
    800052a0:	d02080e7          	jalr	-766(ra) # 80004f9e <argfd>
    800052a4:	87aa                	mv	a5,a0
    return -1;
    800052a6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052a8:	0007cc63          	bltz	a5,800052c0 <sys_write+0x50>
  return filewrite(f, p, n);
    800052ac:	fe442603          	lw	a2,-28(s0)
    800052b0:	fd843583          	ld	a1,-40(s0)
    800052b4:	fe843503          	ld	a0,-24(s0)
    800052b8:	fffff097          	auipc	ra,0xfffff
    800052bc:	4a8080e7          	jalr	1192(ra) # 80004760 <filewrite>
}
    800052c0:	70a2                	ld	ra,40(sp)
    800052c2:	7402                	ld	s0,32(sp)
    800052c4:	6145                	addi	sp,sp,48
    800052c6:	8082                	ret

00000000800052c8 <sys_close>:
{
    800052c8:	1101                	addi	sp,sp,-32
    800052ca:	ec06                	sd	ra,24(sp)
    800052cc:	e822                	sd	s0,16(sp)
    800052ce:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052d0:	fe040613          	addi	a2,s0,-32
    800052d4:	fec40593          	addi	a1,s0,-20
    800052d8:	4501                	li	a0,0
    800052da:	00000097          	auipc	ra,0x0
    800052de:	cc4080e7          	jalr	-828(ra) # 80004f9e <argfd>
    return -1;
    800052e2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052e4:	02054463          	bltz	a0,8000530c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	6c4080e7          	jalr	1732(ra) # 800019ac <myproc>
    800052f0:	fec42783          	lw	a5,-20(s0)
    800052f4:	07f9                	addi	a5,a5,30
    800052f6:	078e                	slli	a5,a5,0x3
    800052f8:	97aa                	add	a5,a5,a0
    800052fa:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800052fe:	fe043503          	ld	a0,-32(s0)
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	262080e7          	jalr	610(ra) # 80004564 <fileclose>
  return 0;
    8000530a:	4781                	li	a5,0
}
    8000530c:	853e                	mv	a0,a5
    8000530e:	60e2                	ld	ra,24(sp)
    80005310:	6442                	ld	s0,16(sp)
    80005312:	6105                	addi	sp,sp,32
    80005314:	8082                	ret

0000000080005316 <sys_fstat>:
{
    80005316:	1101                	addi	sp,sp,-32
    80005318:	ec06                	sd	ra,24(sp)
    8000531a:	e822                	sd	s0,16(sp)
    8000531c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000531e:	fe040593          	addi	a1,s0,-32
    80005322:	4505                	li	a0,1
    80005324:	ffffe097          	auipc	ra,0xffffe
    80005328:	824080e7          	jalr	-2012(ra) # 80002b48 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000532c:	fe840613          	addi	a2,s0,-24
    80005330:	4581                	li	a1,0
    80005332:	4501                	li	a0,0
    80005334:	00000097          	auipc	ra,0x0
    80005338:	c6a080e7          	jalr	-918(ra) # 80004f9e <argfd>
    8000533c:	87aa                	mv	a5,a0
    return -1;
    8000533e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005340:	0007ca63          	bltz	a5,80005354 <sys_fstat+0x3e>
  return filestat(f, st);
    80005344:	fe043583          	ld	a1,-32(s0)
    80005348:	fe843503          	ld	a0,-24(s0)
    8000534c:	fffff097          	auipc	ra,0xfffff
    80005350:	2e0080e7          	jalr	736(ra) # 8000462c <filestat>
}
    80005354:	60e2                	ld	ra,24(sp)
    80005356:	6442                	ld	s0,16(sp)
    80005358:	6105                	addi	sp,sp,32
    8000535a:	8082                	ret

000000008000535c <sys_link>:
{
    8000535c:	7169                	addi	sp,sp,-304
    8000535e:	f606                	sd	ra,296(sp)
    80005360:	f222                	sd	s0,288(sp)
    80005362:	ee26                	sd	s1,280(sp)
    80005364:	ea4a                	sd	s2,272(sp)
    80005366:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005368:	08000613          	li	a2,128
    8000536c:	ed040593          	addi	a1,s0,-304
    80005370:	4501                	li	a0,0
    80005372:	ffffd097          	auipc	ra,0xffffd
    80005376:	7f6080e7          	jalr	2038(ra) # 80002b68 <argstr>
    return -1;
    8000537a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000537c:	10054e63          	bltz	a0,80005498 <sys_link+0x13c>
    80005380:	08000613          	li	a2,128
    80005384:	f5040593          	addi	a1,s0,-176
    80005388:	4505                	li	a0,1
    8000538a:	ffffd097          	auipc	ra,0xffffd
    8000538e:	7de080e7          	jalr	2014(ra) # 80002b68 <argstr>
    return -1;
    80005392:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005394:	10054263          	bltz	a0,80005498 <sys_link+0x13c>
  begin_op();
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	d00080e7          	jalr	-768(ra) # 80004098 <begin_op>
  if((ip = namei(old)) == 0){
    800053a0:	ed040513          	addi	a0,s0,-304
    800053a4:	fffff097          	auipc	ra,0xfffff
    800053a8:	ad8080e7          	jalr	-1320(ra) # 80003e7c <namei>
    800053ac:	84aa                	mv	s1,a0
    800053ae:	c551                	beqz	a0,8000543a <sys_link+0xde>
  ilock(ip);
    800053b0:	ffffe097          	auipc	ra,0xffffe
    800053b4:	326080e7          	jalr	806(ra) # 800036d6 <ilock>
  if(ip->type == T_DIR){
    800053b8:	04449703          	lh	a4,68(s1)
    800053bc:	4785                	li	a5,1
    800053be:	08f70463          	beq	a4,a5,80005446 <sys_link+0xea>
  ip->nlink++;
    800053c2:	04a4d783          	lhu	a5,74(s1)
    800053c6:	2785                	addiw	a5,a5,1
    800053c8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053cc:	8526                	mv	a0,s1
    800053ce:	ffffe097          	auipc	ra,0xffffe
    800053d2:	23e080e7          	jalr	574(ra) # 8000360c <iupdate>
  iunlock(ip);
    800053d6:	8526                	mv	a0,s1
    800053d8:	ffffe097          	auipc	ra,0xffffe
    800053dc:	3c0080e7          	jalr	960(ra) # 80003798 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800053e0:	fd040593          	addi	a1,s0,-48
    800053e4:	f5040513          	addi	a0,s0,-176
    800053e8:	fffff097          	auipc	ra,0xfffff
    800053ec:	ab2080e7          	jalr	-1358(ra) # 80003e9a <nameiparent>
    800053f0:	892a                	mv	s2,a0
    800053f2:	c935                	beqz	a0,80005466 <sys_link+0x10a>
  ilock(dp);
    800053f4:	ffffe097          	auipc	ra,0xffffe
    800053f8:	2e2080e7          	jalr	738(ra) # 800036d6 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800053fc:	00092703          	lw	a4,0(s2)
    80005400:	409c                	lw	a5,0(s1)
    80005402:	04f71d63          	bne	a4,a5,8000545c <sys_link+0x100>
    80005406:	40d0                	lw	a2,4(s1)
    80005408:	fd040593          	addi	a1,s0,-48
    8000540c:	854a                	mv	a0,s2
    8000540e:	fffff097          	auipc	ra,0xfffff
    80005412:	9bc080e7          	jalr	-1604(ra) # 80003dca <dirlink>
    80005416:	04054363          	bltz	a0,8000545c <sys_link+0x100>
  iunlockput(dp);
    8000541a:	854a                	mv	a0,s2
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	51c080e7          	jalr	1308(ra) # 80003938 <iunlockput>
  iput(ip);
    80005424:	8526                	mv	a0,s1
    80005426:	ffffe097          	auipc	ra,0xffffe
    8000542a:	46a080e7          	jalr	1130(ra) # 80003890 <iput>
  end_op();
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	cea080e7          	jalr	-790(ra) # 80004118 <end_op>
  return 0;
    80005436:	4781                	li	a5,0
    80005438:	a085                	j	80005498 <sys_link+0x13c>
    end_op();
    8000543a:	fffff097          	auipc	ra,0xfffff
    8000543e:	cde080e7          	jalr	-802(ra) # 80004118 <end_op>
    return -1;
    80005442:	57fd                	li	a5,-1
    80005444:	a891                	j	80005498 <sys_link+0x13c>
    iunlockput(ip);
    80005446:	8526                	mv	a0,s1
    80005448:	ffffe097          	auipc	ra,0xffffe
    8000544c:	4f0080e7          	jalr	1264(ra) # 80003938 <iunlockput>
    end_op();
    80005450:	fffff097          	auipc	ra,0xfffff
    80005454:	cc8080e7          	jalr	-824(ra) # 80004118 <end_op>
    return -1;
    80005458:	57fd                	li	a5,-1
    8000545a:	a83d                	j	80005498 <sys_link+0x13c>
    iunlockput(dp);
    8000545c:	854a                	mv	a0,s2
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	4da080e7          	jalr	1242(ra) # 80003938 <iunlockput>
  ilock(ip);
    80005466:	8526                	mv	a0,s1
    80005468:	ffffe097          	auipc	ra,0xffffe
    8000546c:	26e080e7          	jalr	622(ra) # 800036d6 <ilock>
  ip->nlink--;
    80005470:	04a4d783          	lhu	a5,74(s1)
    80005474:	37fd                	addiw	a5,a5,-1
    80005476:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000547a:	8526                	mv	a0,s1
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	190080e7          	jalr	400(ra) # 8000360c <iupdate>
  iunlockput(ip);
    80005484:	8526                	mv	a0,s1
    80005486:	ffffe097          	auipc	ra,0xffffe
    8000548a:	4b2080e7          	jalr	1202(ra) # 80003938 <iunlockput>
  end_op();
    8000548e:	fffff097          	auipc	ra,0xfffff
    80005492:	c8a080e7          	jalr	-886(ra) # 80004118 <end_op>
  return -1;
    80005496:	57fd                	li	a5,-1
}
    80005498:	853e                	mv	a0,a5
    8000549a:	70b2                	ld	ra,296(sp)
    8000549c:	7412                	ld	s0,288(sp)
    8000549e:	64f2                	ld	s1,280(sp)
    800054a0:	6952                	ld	s2,272(sp)
    800054a2:	6155                	addi	sp,sp,304
    800054a4:	8082                	ret

00000000800054a6 <sys_unlink>:
{
    800054a6:	7151                	addi	sp,sp,-240
    800054a8:	f586                	sd	ra,232(sp)
    800054aa:	f1a2                	sd	s0,224(sp)
    800054ac:	eda6                	sd	s1,216(sp)
    800054ae:	e9ca                	sd	s2,208(sp)
    800054b0:	e5ce                	sd	s3,200(sp)
    800054b2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800054b4:	08000613          	li	a2,128
    800054b8:	f3040593          	addi	a1,s0,-208
    800054bc:	4501                	li	a0,0
    800054be:	ffffd097          	auipc	ra,0xffffd
    800054c2:	6aa080e7          	jalr	1706(ra) # 80002b68 <argstr>
    800054c6:	18054163          	bltz	a0,80005648 <sys_unlink+0x1a2>
  begin_op();
    800054ca:	fffff097          	auipc	ra,0xfffff
    800054ce:	bce080e7          	jalr	-1074(ra) # 80004098 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054d2:	fb040593          	addi	a1,s0,-80
    800054d6:	f3040513          	addi	a0,s0,-208
    800054da:	fffff097          	auipc	ra,0xfffff
    800054de:	9c0080e7          	jalr	-1600(ra) # 80003e9a <nameiparent>
    800054e2:	84aa                	mv	s1,a0
    800054e4:	c979                	beqz	a0,800055ba <sys_unlink+0x114>
  ilock(dp);
    800054e6:	ffffe097          	auipc	ra,0xffffe
    800054ea:	1f0080e7          	jalr	496(ra) # 800036d6 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800054ee:	00003597          	auipc	a1,0x3
    800054f2:	21a58593          	addi	a1,a1,538 # 80008708 <syscalls+0x2a8>
    800054f6:	fb040513          	addi	a0,s0,-80
    800054fa:	ffffe097          	auipc	ra,0xffffe
    800054fe:	6a6080e7          	jalr	1702(ra) # 80003ba0 <namecmp>
    80005502:	14050a63          	beqz	a0,80005656 <sys_unlink+0x1b0>
    80005506:	00003597          	auipc	a1,0x3
    8000550a:	20a58593          	addi	a1,a1,522 # 80008710 <syscalls+0x2b0>
    8000550e:	fb040513          	addi	a0,s0,-80
    80005512:	ffffe097          	auipc	ra,0xffffe
    80005516:	68e080e7          	jalr	1678(ra) # 80003ba0 <namecmp>
    8000551a:	12050e63          	beqz	a0,80005656 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000551e:	f2c40613          	addi	a2,s0,-212
    80005522:	fb040593          	addi	a1,s0,-80
    80005526:	8526                	mv	a0,s1
    80005528:	ffffe097          	auipc	ra,0xffffe
    8000552c:	692080e7          	jalr	1682(ra) # 80003bba <dirlookup>
    80005530:	892a                	mv	s2,a0
    80005532:	12050263          	beqz	a0,80005656 <sys_unlink+0x1b0>
  ilock(ip);
    80005536:	ffffe097          	auipc	ra,0xffffe
    8000553a:	1a0080e7          	jalr	416(ra) # 800036d6 <ilock>
  if(ip->nlink < 1)
    8000553e:	04a91783          	lh	a5,74(s2)
    80005542:	08f05263          	blez	a5,800055c6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005546:	04491703          	lh	a4,68(s2)
    8000554a:	4785                	li	a5,1
    8000554c:	08f70563          	beq	a4,a5,800055d6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005550:	4641                	li	a2,16
    80005552:	4581                	li	a1,0
    80005554:	fc040513          	addi	a0,s0,-64
    80005558:	ffffb097          	auipc	ra,0xffffb
    8000555c:	77a080e7          	jalr	1914(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005560:	4741                	li	a4,16
    80005562:	f2c42683          	lw	a3,-212(s0)
    80005566:	fc040613          	addi	a2,s0,-64
    8000556a:	4581                	li	a1,0
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	514080e7          	jalr	1300(ra) # 80003a82 <writei>
    80005576:	47c1                	li	a5,16
    80005578:	0af51563          	bne	a0,a5,80005622 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000557c:	04491703          	lh	a4,68(s2)
    80005580:	4785                	li	a5,1
    80005582:	0af70863          	beq	a4,a5,80005632 <sys_unlink+0x18c>
  iunlockput(dp);
    80005586:	8526                	mv	a0,s1
    80005588:	ffffe097          	auipc	ra,0xffffe
    8000558c:	3b0080e7          	jalr	944(ra) # 80003938 <iunlockput>
  ip->nlink--;
    80005590:	04a95783          	lhu	a5,74(s2)
    80005594:	37fd                	addiw	a5,a5,-1
    80005596:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000559a:	854a                	mv	a0,s2
    8000559c:	ffffe097          	auipc	ra,0xffffe
    800055a0:	070080e7          	jalr	112(ra) # 8000360c <iupdate>
  iunlockput(ip);
    800055a4:	854a                	mv	a0,s2
    800055a6:	ffffe097          	auipc	ra,0xffffe
    800055aa:	392080e7          	jalr	914(ra) # 80003938 <iunlockput>
  end_op();
    800055ae:	fffff097          	auipc	ra,0xfffff
    800055b2:	b6a080e7          	jalr	-1174(ra) # 80004118 <end_op>
  return 0;
    800055b6:	4501                	li	a0,0
    800055b8:	a84d                	j	8000566a <sys_unlink+0x1c4>
    end_op();
    800055ba:	fffff097          	auipc	ra,0xfffff
    800055be:	b5e080e7          	jalr	-1186(ra) # 80004118 <end_op>
    return -1;
    800055c2:	557d                	li	a0,-1
    800055c4:	a05d                	j	8000566a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055c6:	00003517          	auipc	a0,0x3
    800055ca:	15250513          	addi	a0,a0,338 # 80008718 <syscalls+0x2b8>
    800055ce:	ffffb097          	auipc	ra,0xffffb
    800055d2:	f70080e7          	jalr	-144(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055d6:	04c92703          	lw	a4,76(s2)
    800055da:	02000793          	li	a5,32
    800055de:	f6e7f9e3          	bgeu	a5,a4,80005550 <sys_unlink+0xaa>
    800055e2:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055e6:	4741                	li	a4,16
    800055e8:	86ce                	mv	a3,s3
    800055ea:	f1840613          	addi	a2,s0,-232
    800055ee:	4581                	li	a1,0
    800055f0:	854a                	mv	a0,s2
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	398080e7          	jalr	920(ra) # 8000398a <readi>
    800055fa:	47c1                	li	a5,16
    800055fc:	00f51b63          	bne	a0,a5,80005612 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005600:	f1845783          	lhu	a5,-232(s0)
    80005604:	e7a1                	bnez	a5,8000564c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005606:	29c1                	addiw	s3,s3,16
    80005608:	04c92783          	lw	a5,76(s2)
    8000560c:	fcf9ede3          	bltu	s3,a5,800055e6 <sys_unlink+0x140>
    80005610:	b781                	j	80005550 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	11e50513          	addi	a0,a0,286 # 80008730 <syscalls+0x2d0>
    8000561a:	ffffb097          	auipc	ra,0xffffb
    8000561e:	f24080e7          	jalr	-220(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	12650513          	addi	a0,a0,294 # 80008748 <syscalls+0x2e8>
    8000562a:	ffffb097          	auipc	ra,0xffffb
    8000562e:	f14080e7          	jalr	-236(ra) # 8000053e <panic>
    dp->nlink--;
    80005632:	04a4d783          	lhu	a5,74(s1)
    80005636:	37fd                	addiw	a5,a5,-1
    80005638:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000563c:	8526                	mv	a0,s1
    8000563e:	ffffe097          	auipc	ra,0xffffe
    80005642:	fce080e7          	jalr	-50(ra) # 8000360c <iupdate>
    80005646:	b781                	j	80005586 <sys_unlink+0xe0>
    return -1;
    80005648:	557d                	li	a0,-1
    8000564a:	a005                	j	8000566a <sys_unlink+0x1c4>
    iunlockput(ip);
    8000564c:	854a                	mv	a0,s2
    8000564e:	ffffe097          	auipc	ra,0xffffe
    80005652:	2ea080e7          	jalr	746(ra) # 80003938 <iunlockput>
  iunlockput(dp);
    80005656:	8526                	mv	a0,s1
    80005658:	ffffe097          	auipc	ra,0xffffe
    8000565c:	2e0080e7          	jalr	736(ra) # 80003938 <iunlockput>
  end_op();
    80005660:	fffff097          	auipc	ra,0xfffff
    80005664:	ab8080e7          	jalr	-1352(ra) # 80004118 <end_op>
  return -1;
    80005668:	557d                	li	a0,-1
}
    8000566a:	70ae                	ld	ra,232(sp)
    8000566c:	740e                	ld	s0,224(sp)
    8000566e:	64ee                	ld	s1,216(sp)
    80005670:	694e                	ld	s2,208(sp)
    80005672:	69ae                	ld	s3,200(sp)
    80005674:	616d                	addi	sp,sp,240
    80005676:	8082                	ret

0000000080005678 <sys_open>:

uint64
sys_open(void)
{
    80005678:	7131                	addi	sp,sp,-192
    8000567a:	fd06                	sd	ra,184(sp)
    8000567c:	f922                	sd	s0,176(sp)
    8000567e:	f526                	sd	s1,168(sp)
    80005680:	f14a                	sd	s2,160(sp)
    80005682:	ed4e                	sd	s3,152(sp)
    80005684:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005686:	f4c40593          	addi	a1,s0,-180
    8000568a:	4505                	li	a0,1
    8000568c:	ffffd097          	auipc	ra,0xffffd
    80005690:	49c080e7          	jalr	1180(ra) # 80002b28 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005694:	08000613          	li	a2,128
    80005698:	f5040593          	addi	a1,s0,-176
    8000569c:	4501                	li	a0,0
    8000569e:	ffffd097          	auipc	ra,0xffffd
    800056a2:	4ca080e7          	jalr	1226(ra) # 80002b68 <argstr>
    800056a6:	87aa                	mv	a5,a0
    return -1;
    800056a8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800056aa:	0a07c963          	bltz	a5,8000575c <sys_open+0xe4>

  begin_op();
    800056ae:	fffff097          	auipc	ra,0xfffff
    800056b2:	9ea080e7          	jalr	-1558(ra) # 80004098 <begin_op>

  if(omode & O_CREATE){
    800056b6:	f4c42783          	lw	a5,-180(s0)
    800056ba:	2007f793          	andi	a5,a5,512
    800056be:	cfc5                	beqz	a5,80005776 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800056c0:	4681                	li	a3,0
    800056c2:	4601                	li	a2,0
    800056c4:	4589                	li	a1,2
    800056c6:	f5040513          	addi	a0,s0,-176
    800056ca:	00000097          	auipc	ra,0x0
    800056ce:	976080e7          	jalr	-1674(ra) # 80005040 <create>
    800056d2:	84aa                	mv	s1,a0
    if(ip == 0){
    800056d4:	c959                	beqz	a0,8000576a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056d6:	04449703          	lh	a4,68(s1)
    800056da:	478d                	li	a5,3
    800056dc:	00f71763          	bne	a4,a5,800056ea <sys_open+0x72>
    800056e0:	0464d703          	lhu	a4,70(s1)
    800056e4:	47a5                	li	a5,9
    800056e6:	0ce7ed63          	bltu	a5,a4,800057c0 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800056ea:	fffff097          	auipc	ra,0xfffff
    800056ee:	dbe080e7          	jalr	-578(ra) # 800044a8 <filealloc>
    800056f2:	89aa                	mv	s3,a0
    800056f4:	10050363          	beqz	a0,800057fa <sys_open+0x182>
    800056f8:	00000097          	auipc	ra,0x0
    800056fc:	906080e7          	jalr	-1786(ra) # 80004ffe <fdalloc>
    80005700:	892a                	mv	s2,a0
    80005702:	0e054763          	bltz	a0,800057f0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005706:	04449703          	lh	a4,68(s1)
    8000570a:	478d                	li	a5,3
    8000570c:	0cf70563          	beq	a4,a5,800057d6 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005710:	4789                	li	a5,2
    80005712:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005716:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000571a:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    8000571e:	f4c42783          	lw	a5,-180(s0)
    80005722:	0017c713          	xori	a4,a5,1
    80005726:	8b05                	andi	a4,a4,1
    80005728:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000572c:	0037f713          	andi	a4,a5,3
    80005730:	00e03733          	snez	a4,a4
    80005734:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005738:	4007f793          	andi	a5,a5,1024
    8000573c:	c791                	beqz	a5,80005748 <sys_open+0xd0>
    8000573e:	04449703          	lh	a4,68(s1)
    80005742:	4789                	li	a5,2
    80005744:	0af70063          	beq	a4,a5,800057e4 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005748:	8526                	mv	a0,s1
    8000574a:	ffffe097          	auipc	ra,0xffffe
    8000574e:	04e080e7          	jalr	78(ra) # 80003798 <iunlock>
  end_op();
    80005752:	fffff097          	auipc	ra,0xfffff
    80005756:	9c6080e7          	jalr	-1594(ra) # 80004118 <end_op>

  return fd;
    8000575a:	854a                	mv	a0,s2
}
    8000575c:	70ea                	ld	ra,184(sp)
    8000575e:	744a                	ld	s0,176(sp)
    80005760:	74aa                	ld	s1,168(sp)
    80005762:	790a                	ld	s2,160(sp)
    80005764:	69ea                	ld	s3,152(sp)
    80005766:	6129                	addi	sp,sp,192
    80005768:	8082                	ret
      end_op();
    8000576a:	fffff097          	auipc	ra,0xfffff
    8000576e:	9ae080e7          	jalr	-1618(ra) # 80004118 <end_op>
      return -1;
    80005772:	557d                	li	a0,-1
    80005774:	b7e5                	j	8000575c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005776:	f5040513          	addi	a0,s0,-176
    8000577a:	ffffe097          	auipc	ra,0xffffe
    8000577e:	702080e7          	jalr	1794(ra) # 80003e7c <namei>
    80005782:	84aa                	mv	s1,a0
    80005784:	c905                	beqz	a0,800057b4 <sys_open+0x13c>
    ilock(ip);
    80005786:	ffffe097          	auipc	ra,0xffffe
    8000578a:	f50080e7          	jalr	-176(ra) # 800036d6 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000578e:	04449703          	lh	a4,68(s1)
    80005792:	4785                	li	a5,1
    80005794:	f4f711e3          	bne	a4,a5,800056d6 <sys_open+0x5e>
    80005798:	f4c42783          	lw	a5,-180(s0)
    8000579c:	d7b9                	beqz	a5,800056ea <sys_open+0x72>
      iunlockput(ip);
    8000579e:	8526                	mv	a0,s1
    800057a0:	ffffe097          	auipc	ra,0xffffe
    800057a4:	198080e7          	jalr	408(ra) # 80003938 <iunlockput>
      end_op();
    800057a8:	fffff097          	auipc	ra,0xfffff
    800057ac:	970080e7          	jalr	-1680(ra) # 80004118 <end_op>
      return -1;
    800057b0:	557d                	li	a0,-1
    800057b2:	b76d                	j	8000575c <sys_open+0xe4>
      end_op();
    800057b4:	fffff097          	auipc	ra,0xfffff
    800057b8:	964080e7          	jalr	-1692(ra) # 80004118 <end_op>
      return -1;
    800057bc:	557d                	li	a0,-1
    800057be:	bf79                	j	8000575c <sys_open+0xe4>
    iunlockput(ip);
    800057c0:	8526                	mv	a0,s1
    800057c2:	ffffe097          	auipc	ra,0xffffe
    800057c6:	176080e7          	jalr	374(ra) # 80003938 <iunlockput>
    end_op();
    800057ca:	fffff097          	auipc	ra,0xfffff
    800057ce:	94e080e7          	jalr	-1714(ra) # 80004118 <end_op>
    return -1;
    800057d2:	557d                	li	a0,-1
    800057d4:	b761                	j	8000575c <sys_open+0xe4>
    f->type = FD_DEVICE;
    800057d6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800057da:	04649783          	lh	a5,70(s1)
    800057de:	02f99223          	sh	a5,36(s3)
    800057e2:	bf25                	j	8000571a <sys_open+0xa2>
    itrunc(ip);
    800057e4:	8526                	mv	a0,s1
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	ffe080e7          	jalr	-2(ra) # 800037e4 <itrunc>
    800057ee:	bfa9                	j	80005748 <sys_open+0xd0>
      fileclose(f);
    800057f0:	854e                	mv	a0,s3
    800057f2:	fffff097          	auipc	ra,0xfffff
    800057f6:	d72080e7          	jalr	-654(ra) # 80004564 <fileclose>
    iunlockput(ip);
    800057fa:	8526                	mv	a0,s1
    800057fc:	ffffe097          	auipc	ra,0xffffe
    80005800:	13c080e7          	jalr	316(ra) # 80003938 <iunlockput>
    end_op();
    80005804:	fffff097          	auipc	ra,0xfffff
    80005808:	914080e7          	jalr	-1772(ra) # 80004118 <end_op>
    return -1;
    8000580c:	557d                	li	a0,-1
    8000580e:	b7b9                	j	8000575c <sys_open+0xe4>

0000000080005810 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005810:	7175                	addi	sp,sp,-144
    80005812:	e506                	sd	ra,136(sp)
    80005814:	e122                	sd	s0,128(sp)
    80005816:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005818:	fffff097          	auipc	ra,0xfffff
    8000581c:	880080e7          	jalr	-1920(ra) # 80004098 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005820:	08000613          	li	a2,128
    80005824:	f7040593          	addi	a1,s0,-144
    80005828:	4501                	li	a0,0
    8000582a:	ffffd097          	auipc	ra,0xffffd
    8000582e:	33e080e7          	jalr	830(ra) # 80002b68 <argstr>
    80005832:	02054963          	bltz	a0,80005864 <sys_mkdir+0x54>
    80005836:	4681                	li	a3,0
    80005838:	4601                	li	a2,0
    8000583a:	4585                	li	a1,1
    8000583c:	f7040513          	addi	a0,s0,-144
    80005840:	00000097          	auipc	ra,0x0
    80005844:	800080e7          	jalr	-2048(ra) # 80005040 <create>
    80005848:	cd11                	beqz	a0,80005864 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	0ee080e7          	jalr	238(ra) # 80003938 <iunlockput>
  end_op();
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	8c6080e7          	jalr	-1850(ra) # 80004118 <end_op>
  return 0;
    8000585a:	4501                	li	a0,0
}
    8000585c:	60aa                	ld	ra,136(sp)
    8000585e:	640a                	ld	s0,128(sp)
    80005860:	6149                	addi	sp,sp,144
    80005862:	8082                	ret
    end_op();
    80005864:	fffff097          	auipc	ra,0xfffff
    80005868:	8b4080e7          	jalr	-1868(ra) # 80004118 <end_op>
    return -1;
    8000586c:	557d                	li	a0,-1
    8000586e:	b7fd                	j	8000585c <sys_mkdir+0x4c>

0000000080005870 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005870:	7135                	addi	sp,sp,-160
    80005872:	ed06                	sd	ra,152(sp)
    80005874:	e922                	sd	s0,144(sp)
    80005876:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005878:	fffff097          	auipc	ra,0xfffff
    8000587c:	820080e7          	jalr	-2016(ra) # 80004098 <begin_op>
  argint(1, &major);
    80005880:	f6c40593          	addi	a1,s0,-148
    80005884:	4505                	li	a0,1
    80005886:	ffffd097          	auipc	ra,0xffffd
    8000588a:	2a2080e7          	jalr	674(ra) # 80002b28 <argint>
  argint(2, &minor);
    8000588e:	f6840593          	addi	a1,s0,-152
    80005892:	4509                	li	a0,2
    80005894:	ffffd097          	auipc	ra,0xffffd
    80005898:	294080e7          	jalr	660(ra) # 80002b28 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000589c:	08000613          	li	a2,128
    800058a0:	f7040593          	addi	a1,s0,-144
    800058a4:	4501                	li	a0,0
    800058a6:	ffffd097          	auipc	ra,0xffffd
    800058aa:	2c2080e7          	jalr	706(ra) # 80002b68 <argstr>
    800058ae:	02054b63          	bltz	a0,800058e4 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800058b2:	f6841683          	lh	a3,-152(s0)
    800058b6:	f6c41603          	lh	a2,-148(s0)
    800058ba:	458d                	li	a1,3
    800058bc:	f7040513          	addi	a0,s0,-144
    800058c0:	fffff097          	auipc	ra,0xfffff
    800058c4:	780080e7          	jalr	1920(ra) # 80005040 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058c8:	cd11                	beqz	a0,800058e4 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058ca:	ffffe097          	auipc	ra,0xffffe
    800058ce:	06e080e7          	jalr	110(ra) # 80003938 <iunlockput>
  end_op();
    800058d2:	fffff097          	auipc	ra,0xfffff
    800058d6:	846080e7          	jalr	-1978(ra) # 80004118 <end_op>
  return 0;
    800058da:	4501                	li	a0,0
}
    800058dc:	60ea                	ld	ra,152(sp)
    800058de:	644a                	ld	s0,144(sp)
    800058e0:	610d                	addi	sp,sp,160
    800058e2:	8082                	ret
    end_op();
    800058e4:	fffff097          	auipc	ra,0xfffff
    800058e8:	834080e7          	jalr	-1996(ra) # 80004118 <end_op>
    return -1;
    800058ec:	557d                	li	a0,-1
    800058ee:	b7fd                	j	800058dc <sys_mknod+0x6c>

00000000800058f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800058f0:	7135                	addi	sp,sp,-160
    800058f2:	ed06                	sd	ra,152(sp)
    800058f4:	e922                	sd	s0,144(sp)
    800058f6:	e526                	sd	s1,136(sp)
    800058f8:	e14a                	sd	s2,128(sp)
    800058fa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800058fc:	ffffc097          	auipc	ra,0xffffc
    80005900:	0b0080e7          	jalr	176(ra) # 800019ac <myproc>
    80005904:	892a                	mv	s2,a0
  
  begin_op();
    80005906:	ffffe097          	auipc	ra,0xffffe
    8000590a:	792080e7          	jalr	1938(ra) # 80004098 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000590e:	08000613          	li	a2,128
    80005912:	f6040593          	addi	a1,s0,-160
    80005916:	4501                	li	a0,0
    80005918:	ffffd097          	auipc	ra,0xffffd
    8000591c:	250080e7          	jalr	592(ra) # 80002b68 <argstr>
    80005920:	04054b63          	bltz	a0,80005976 <sys_chdir+0x86>
    80005924:	f6040513          	addi	a0,s0,-160
    80005928:	ffffe097          	auipc	ra,0xffffe
    8000592c:	554080e7          	jalr	1364(ra) # 80003e7c <namei>
    80005930:	84aa                	mv	s1,a0
    80005932:	c131                	beqz	a0,80005976 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005934:	ffffe097          	auipc	ra,0xffffe
    80005938:	da2080e7          	jalr	-606(ra) # 800036d6 <ilock>
  if(ip->type != T_DIR){
    8000593c:	04449703          	lh	a4,68(s1)
    80005940:	4785                	li	a5,1
    80005942:	04f71063          	bne	a4,a5,80005982 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005946:	8526                	mv	a0,s1
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	e50080e7          	jalr	-432(ra) # 80003798 <iunlock>
  iput(p->cwd);
    80005950:	17093503          	ld	a0,368(s2)
    80005954:	ffffe097          	auipc	ra,0xffffe
    80005958:	f3c080e7          	jalr	-196(ra) # 80003890 <iput>
  end_op();
    8000595c:	ffffe097          	auipc	ra,0xffffe
    80005960:	7bc080e7          	jalr	1980(ra) # 80004118 <end_op>
  p->cwd = ip;
    80005964:	16993823          	sd	s1,368(s2)
  return 0;
    80005968:	4501                	li	a0,0
}
    8000596a:	60ea                	ld	ra,152(sp)
    8000596c:	644a                	ld	s0,144(sp)
    8000596e:	64aa                	ld	s1,136(sp)
    80005970:	690a                	ld	s2,128(sp)
    80005972:	610d                	addi	sp,sp,160
    80005974:	8082                	ret
    end_op();
    80005976:	ffffe097          	auipc	ra,0xffffe
    8000597a:	7a2080e7          	jalr	1954(ra) # 80004118 <end_op>
    return -1;
    8000597e:	557d                	li	a0,-1
    80005980:	b7ed                	j	8000596a <sys_chdir+0x7a>
    iunlockput(ip);
    80005982:	8526                	mv	a0,s1
    80005984:	ffffe097          	auipc	ra,0xffffe
    80005988:	fb4080e7          	jalr	-76(ra) # 80003938 <iunlockput>
    end_op();
    8000598c:	ffffe097          	auipc	ra,0xffffe
    80005990:	78c080e7          	jalr	1932(ra) # 80004118 <end_op>
    return -1;
    80005994:	557d                	li	a0,-1
    80005996:	bfd1                	j	8000596a <sys_chdir+0x7a>

0000000080005998 <sys_exec>:

uint64
sys_exec(void)
{
    80005998:	7145                	addi	sp,sp,-464
    8000599a:	e786                	sd	ra,456(sp)
    8000599c:	e3a2                	sd	s0,448(sp)
    8000599e:	ff26                	sd	s1,440(sp)
    800059a0:	fb4a                	sd	s2,432(sp)
    800059a2:	f74e                	sd	s3,424(sp)
    800059a4:	f352                	sd	s4,416(sp)
    800059a6:	ef56                	sd	s5,408(sp)
    800059a8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800059aa:	e3840593          	addi	a1,s0,-456
    800059ae:	4505                	li	a0,1
    800059b0:	ffffd097          	auipc	ra,0xffffd
    800059b4:	198080e7          	jalr	408(ra) # 80002b48 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800059b8:	08000613          	li	a2,128
    800059bc:	f4040593          	addi	a1,s0,-192
    800059c0:	4501                	li	a0,0
    800059c2:	ffffd097          	auipc	ra,0xffffd
    800059c6:	1a6080e7          	jalr	422(ra) # 80002b68 <argstr>
    800059ca:	87aa                	mv	a5,a0
    return -1;
    800059cc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800059ce:	0c07c263          	bltz	a5,80005a92 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800059d2:	10000613          	li	a2,256
    800059d6:	4581                	li	a1,0
    800059d8:	e4040513          	addi	a0,s0,-448
    800059dc:	ffffb097          	auipc	ra,0xffffb
    800059e0:	2f6080e7          	jalr	758(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800059e4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800059e8:	89a6                	mv	s3,s1
    800059ea:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800059ec:	02000a13          	li	s4,32
    800059f0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800059f4:	00391793          	slli	a5,s2,0x3
    800059f8:	e3040593          	addi	a1,s0,-464
    800059fc:	e3843503          	ld	a0,-456(s0)
    80005a00:	953e                	add	a0,a0,a5
    80005a02:	ffffd097          	auipc	ra,0xffffd
    80005a06:	088080e7          	jalr	136(ra) # 80002a8a <fetchaddr>
    80005a0a:	02054a63          	bltz	a0,80005a3e <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005a0e:	e3043783          	ld	a5,-464(s0)
    80005a12:	c3b9                	beqz	a5,80005a58 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a14:	ffffb097          	auipc	ra,0xffffb
    80005a18:	0d2080e7          	jalr	210(ra) # 80000ae6 <kalloc>
    80005a1c:	85aa                	mv	a1,a0
    80005a1e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a22:	cd11                	beqz	a0,80005a3e <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a24:	6605                	lui	a2,0x1
    80005a26:	e3043503          	ld	a0,-464(s0)
    80005a2a:	ffffd097          	auipc	ra,0xffffd
    80005a2e:	0b2080e7          	jalr	178(ra) # 80002adc <fetchstr>
    80005a32:	00054663          	bltz	a0,80005a3e <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005a36:	0905                	addi	s2,s2,1
    80005a38:	09a1                	addi	s3,s3,8
    80005a3a:	fb491be3          	bne	s2,s4,800059f0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a3e:	10048913          	addi	s2,s1,256
    80005a42:	6088                	ld	a0,0(s1)
    80005a44:	c531                	beqz	a0,80005a90 <sys_exec+0xf8>
    kfree(argv[i]);
    80005a46:	ffffb097          	auipc	ra,0xffffb
    80005a4a:	fa4080e7          	jalr	-92(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a4e:	04a1                	addi	s1,s1,8
    80005a50:	ff2499e3          	bne	s1,s2,80005a42 <sys_exec+0xaa>
  return -1;
    80005a54:	557d                	li	a0,-1
    80005a56:	a835                	j	80005a92 <sys_exec+0xfa>
      argv[i] = 0;
    80005a58:	0a8e                	slli	s5,s5,0x3
    80005a5a:	fc040793          	addi	a5,s0,-64
    80005a5e:	9abe                	add	s5,s5,a5
    80005a60:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005a64:	e4040593          	addi	a1,s0,-448
    80005a68:	f4040513          	addi	a0,s0,-192
    80005a6c:	fffff097          	auipc	ra,0xfffff
    80005a70:	172080e7          	jalr	370(ra) # 80004bde <exec>
    80005a74:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a76:	10048993          	addi	s3,s1,256
    80005a7a:	6088                	ld	a0,0(s1)
    80005a7c:	c901                	beqz	a0,80005a8c <sys_exec+0xf4>
    kfree(argv[i]);
    80005a7e:	ffffb097          	auipc	ra,0xffffb
    80005a82:	f6c080e7          	jalr	-148(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a86:	04a1                	addi	s1,s1,8
    80005a88:	ff3499e3          	bne	s1,s3,80005a7a <sys_exec+0xe2>
  return ret;
    80005a8c:	854a                	mv	a0,s2
    80005a8e:	a011                	j	80005a92 <sys_exec+0xfa>
  return -1;
    80005a90:	557d                	li	a0,-1
}
    80005a92:	60be                	ld	ra,456(sp)
    80005a94:	641e                	ld	s0,448(sp)
    80005a96:	74fa                	ld	s1,440(sp)
    80005a98:	795a                	ld	s2,432(sp)
    80005a9a:	79ba                	ld	s3,424(sp)
    80005a9c:	7a1a                	ld	s4,416(sp)
    80005a9e:	6afa                	ld	s5,408(sp)
    80005aa0:	6179                	addi	sp,sp,464
    80005aa2:	8082                	ret

0000000080005aa4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005aa4:	7139                	addi	sp,sp,-64
    80005aa6:	fc06                	sd	ra,56(sp)
    80005aa8:	f822                	sd	s0,48(sp)
    80005aaa:	f426                	sd	s1,40(sp)
    80005aac:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005aae:	ffffc097          	auipc	ra,0xffffc
    80005ab2:	efe080e7          	jalr	-258(ra) # 800019ac <myproc>
    80005ab6:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005ab8:	fd840593          	addi	a1,s0,-40
    80005abc:	4501                	li	a0,0
    80005abe:	ffffd097          	auipc	ra,0xffffd
    80005ac2:	08a080e7          	jalr	138(ra) # 80002b48 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005ac6:	fc840593          	addi	a1,s0,-56
    80005aca:	fd040513          	addi	a0,s0,-48
    80005ace:	fffff097          	auipc	ra,0xfffff
    80005ad2:	dc6080e7          	jalr	-570(ra) # 80004894 <pipealloc>
    return -1;
    80005ad6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ad8:	0c054463          	bltz	a0,80005ba0 <sys_pipe+0xfc>
  fd0 = -1;
    80005adc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005ae0:	fd043503          	ld	a0,-48(s0)
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	51a080e7          	jalr	1306(ra) # 80004ffe <fdalloc>
    80005aec:	fca42223          	sw	a0,-60(s0)
    80005af0:	08054b63          	bltz	a0,80005b86 <sys_pipe+0xe2>
    80005af4:	fc843503          	ld	a0,-56(s0)
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	506080e7          	jalr	1286(ra) # 80004ffe <fdalloc>
    80005b00:	fca42023          	sw	a0,-64(s0)
    80005b04:	06054863          	bltz	a0,80005b74 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b08:	4691                	li	a3,4
    80005b0a:	fc440613          	addi	a2,s0,-60
    80005b0e:	fd843583          	ld	a1,-40(s0)
    80005b12:	78a8                	ld	a0,112(s1)
    80005b14:	ffffc097          	auipc	ra,0xffffc
    80005b18:	b54080e7          	jalr	-1196(ra) # 80001668 <copyout>
    80005b1c:	02054063          	bltz	a0,80005b3c <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b20:	4691                	li	a3,4
    80005b22:	fc040613          	addi	a2,s0,-64
    80005b26:	fd843583          	ld	a1,-40(s0)
    80005b2a:	0591                	addi	a1,a1,4
    80005b2c:	78a8                	ld	a0,112(s1)
    80005b2e:	ffffc097          	auipc	ra,0xffffc
    80005b32:	b3a080e7          	jalr	-1222(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b36:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b38:	06055463          	bgez	a0,80005ba0 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005b3c:	fc442783          	lw	a5,-60(s0)
    80005b40:	07f9                	addi	a5,a5,30
    80005b42:	078e                	slli	a5,a5,0x3
    80005b44:	97a6                	add	a5,a5,s1
    80005b46:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b4a:	fc042503          	lw	a0,-64(s0)
    80005b4e:	0579                	addi	a0,a0,30
    80005b50:	050e                	slli	a0,a0,0x3
    80005b52:	94aa                	add	s1,s1,a0
    80005b54:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005b58:	fd043503          	ld	a0,-48(s0)
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	a08080e7          	jalr	-1528(ra) # 80004564 <fileclose>
    fileclose(wf);
    80005b64:	fc843503          	ld	a0,-56(s0)
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	9fc080e7          	jalr	-1540(ra) # 80004564 <fileclose>
    return -1;
    80005b70:	57fd                	li	a5,-1
    80005b72:	a03d                	j	80005ba0 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005b74:	fc442783          	lw	a5,-60(s0)
    80005b78:	0007c763          	bltz	a5,80005b86 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005b7c:	07f9                	addi	a5,a5,30
    80005b7e:	078e                	slli	a5,a5,0x3
    80005b80:	94be                	add	s1,s1,a5
    80005b82:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005b86:	fd043503          	ld	a0,-48(s0)
    80005b8a:	fffff097          	auipc	ra,0xfffff
    80005b8e:	9da080e7          	jalr	-1574(ra) # 80004564 <fileclose>
    fileclose(wf);
    80005b92:	fc843503          	ld	a0,-56(s0)
    80005b96:	fffff097          	auipc	ra,0xfffff
    80005b9a:	9ce080e7          	jalr	-1586(ra) # 80004564 <fileclose>
    return -1;
    80005b9e:	57fd                	li	a5,-1
}
    80005ba0:	853e                	mv	a0,a5
    80005ba2:	70e2                	ld	ra,56(sp)
    80005ba4:	7442                	ld	s0,48(sp)
    80005ba6:	74a2                	ld	s1,40(sp)
    80005ba8:	6121                	addi	sp,sp,64
    80005baa:	8082                	ret
    80005bac:	0000                	unimp
	...

0000000080005bb0 <kernelvec>:
    80005bb0:	7111                	addi	sp,sp,-256
    80005bb2:	e006                	sd	ra,0(sp)
    80005bb4:	e40a                	sd	sp,8(sp)
    80005bb6:	e80e                	sd	gp,16(sp)
    80005bb8:	ec12                	sd	tp,24(sp)
    80005bba:	f016                	sd	t0,32(sp)
    80005bbc:	f41a                	sd	t1,40(sp)
    80005bbe:	f81e                	sd	t2,48(sp)
    80005bc0:	fc22                	sd	s0,56(sp)
    80005bc2:	e0a6                	sd	s1,64(sp)
    80005bc4:	e4aa                	sd	a0,72(sp)
    80005bc6:	e8ae                	sd	a1,80(sp)
    80005bc8:	ecb2                	sd	a2,88(sp)
    80005bca:	f0b6                	sd	a3,96(sp)
    80005bcc:	f4ba                	sd	a4,104(sp)
    80005bce:	f8be                	sd	a5,112(sp)
    80005bd0:	fcc2                	sd	a6,120(sp)
    80005bd2:	e146                	sd	a7,128(sp)
    80005bd4:	e54a                	sd	s2,136(sp)
    80005bd6:	e94e                	sd	s3,144(sp)
    80005bd8:	ed52                	sd	s4,152(sp)
    80005bda:	f156                	sd	s5,160(sp)
    80005bdc:	f55a                	sd	s6,168(sp)
    80005bde:	f95e                	sd	s7,176(sp)
    80005be0:	fd62                	sd	s8,184(sp)
    80005be2:	e1e6                	sd	s9,192(sp)
    80005be4:	e5ea                	sd	s10,200(sp)
    80005be6:	e9ee                	sd	s11,208(sp)
    80005be8:	edf2                	sd	t3,216(sp)
    80005bea:	f1f6                	sd	t4,224(sp)
    80005bec:	f5fa                	sd	t5,232(sp)
    80005bee:	f9fe                	sd	t6,240(sp)
    80005bf0:	d67fc0ef          	jal	ra,80002956 <kerneltrap>
    80005bf4:	6082                	ld	ra,0(sp)
    80005bf6:	6122                	ld	sp,8(sp)
    80005bf8:	61c2                	ld	gp,16(sp)
    80005bfa:	7282                	ld	t0,32(sp)
    80005bfc:	7322                	ld	t1,40(sp)
    80005bfe:	73c2                	ld	t2,48(sp)
    80005c00:	7462                	ld	s0,56(sp)
    80005c02:	6486                	ld	s1,64(sp)
    80005c04:	6526                	ld	a0,72(sp)
    80005c06:	65c6                	ld	a1,80(sp)
    80005c08:	6666                	ld	a2,88(sp)
    80005c0a:	7686                	ld	a3,96(sp)
    80005c0c:	7726                	ld	a4,104(sp)
    80005c0e:	77c6                	ld	a5,112(sp)
    80005c10:	7866                	ld	a6,120(sp)
    80005c12:	688a                	ld	a7,128(sp)
    80005c14:	692a                	ld	s2,136(sp)
    80005c16:	69ca                	ld	s3,144(sp)
    80005c18:	6a6a                	ld	s4,152(sp)
    80005c1a:	7a8a                	ld	s5,160(sp)
    80005c1c:	7b2a                	ld	s6,168(sp)
    80005c1e:	7bca                	ld	s7,176(sp)
    80005c20:	7c6a                	ld	s8,184(sp)
    80005c22:	6c8e                	ld	s9,192(sp)
    80005c24:	6d2e                	ld	s10,200(sp)
    80005c26:	6dce                	ld	s11,208(sp)
    80005c28:	6e6e                	ld	t3,216(sp)
    80005c2a:	7e8e                	ld	t4,224(sp)
    80005c2c:	7f2e                	ld	t5,232(sp)
    80005c2e:	7fce                	ld	t6,240(sp)
    80005c30:	6111                	addi	sp,sp,256
    80005c32:	10200073          	sret
    80005c36:	00000013          	nop
    80005c3a:	00000013          	nop
    80005c3e:	0001                	nop

0000000080005c40 <timervec>:
    80005c40:	34051573          	csrrw	a0,mscratch,a0
    80005c44:	e10c                	sd	a1,0(a0)
    80005c46:	e510                	sd	a2,8(a0)
    80005c48:	e914                	sd	a3,16(a0)
    80005c4a:	6d0c                	ld	a1,24(a0)
    80005c4c:	7110                	ld	a2,32(a0)
    80005c4e:	6194                	ld	a3,0(a1)
    80005c50:	96b2                	add	a3,a3,a2
    80005c52:	e194                	sd	a3,0(a1)
    80005c54:	4589                	li	a1,2
    80005c56:	14459073          	csrw	sip,a1
    80005c5a:	6914                	ld	a3,16(a0)
    80005c5c:	6510                	ld	a2,8(a0)
    80005c5e:	610c                	ld	a1,0(a0)
    80005c60:	34051573          	csrrw	a0,mscratch,a0
    80005c64:	30200073          	mret
	...

0000000080005c6a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c6a:	1141                	addi	sp,sp,-16
    80005c6c:	e422                	sd	s0,8(sp)
    80005c6e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005c70:	0c0007b7          	lui	a5,0xc000
    80005c74:	4705                	li	a4,1
    80005c76:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005c78:	c3d8                	sw	a4,4(a5)
}
    80005c7a:	6422                	ld	s0,8(sp)
    80005c7c:	0141                	addi	sp,sp,16
    80005c7e:	8082                	ret

0000000080005c80 <plicinithart>:

void
plicinithart(void)
{
    80005c80:	1141                	addi	sp,sp,-16
    80005c82:	e406                	sd	ra,8(sp)
    80005c84:	e022                	sd	s0,0(sp)
    80005c86:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c88:	ffffc097          	auipc	ra,0xffffc
    80005c8c:	cf8080e7          	jalr	-776(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005c90:	0085171b          	slliw	a4,a0,0x8
    80005c94:	0c0027b7          	lui	a5,0xc002
    80005c98:	97ba                	add	a5,a5,a4
    80005c9a:	40200713          	li	a4,1026
    80005c9e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005ca2:	00d5151b          	slliw	a0,a0,0xd
    80005ca6:	0c2017b7          	lui	a5,0xc201
    80005caa:	953e                	add	a0,a0,a5
    80005cac:	00052023          	sw	zero,0(a0)
}
    80005cb0:	60a2                	ld	ra,8(sp)
    80005cb2:	6402                	ld	s0,0(sp)
    80005cb4:	0141                	addi	sp,sp,16
    80005cb6:	8082                	ret

0000000080005cb8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005cb8:	1141                	addi	sp,sp,-16
    80005cba:	e406                	sd	ra,8(sp)
    80005cbc:	e022                	sd	s0,0(sp)
    80005cbe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cc0:	ffffc097          	auipc	ra,0xffffc
    80005cc4:	cc0080e7          	jalr	-832(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cc8:	00d5179b          	slliw	a5,a0,0xd
    80005ccc:	0c201537          	lui	a0,0xc201
    80005cd0:	953e                	add	a0,a0,a5
  return irq;
}
    80005cd2:	4148                	lw	a0,4(a0)
    80005cd4:	60a2                	ld	ra,8(sp)
    80005cd6:	6402                	ld	s0,0(sp)
    80005cd8:	0141                	addi	sp,sp,16
    80005cda:	8082                	ret

0000000080005cdc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005cdc:	1101                	addi	sp,sp,-32
    80005cde:	ec06                	sd	ra,24(sp)
    80005ce0:	e822                	sd	s0,16(sp)
    80005ce2:	e426                	sd	s1,8(sp)
    80005ce4:	1000                	addi	s0,sp,32
    80005ce6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005ce8:	ffffc097          	auipc	ra,0xffffc
    80005cec:	c98080e7          	jalr	-872(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005cf0:	00d5151b          	slliw	a0,a0,0xd
    80005cf4:	0c2017b7          	lui	a5,0xc201
    80005cf8:	97aa                	add	a5,a5,a0
    80005cfa:	c3c4                	sw	s1,4(a5)
}
    80005cfc:	60e2                	ld	ra,24(sp)
    80005cfe:	6442                	ld	s0,16(sp)
    80005d00:	64a2                	ld	s1,8(sp)
    80005d02:	6105                	addi	sp,sp,32
    80005d04:	8082                	ret

0000000080005d06 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d06:	1141                	addi	sp,sp,-16
    80005d08:	e406                	sd	ra,8(sp)
    80005d0a:	e022                	sd	s0,0(sp)
    80005d0c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d0e:	479d                	li	a5,7
    80005d10:	04a7cc63          	blt	a5,a0,80005d68 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d14:	0001c797          	auipc	a5,0x1c
    80005d18:	72c78793          	addi	a5,a5,1836 # 80022440 <disk>
    80005d1c:	97aa                	add	a5,a5,a0
    80005d1e:	0187c783          	lbu	a5,24(a5)
    80005d22:	ebb9                	bnez	a5,80005d78 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d24:	00451613          	slli	a2,a0,0x4
    80005d28:	0001c797          	auipc	a5,0x1c
    80005d2c:	71878793          	addi	a5,a5,1816 # 80022440 <disk>
    80005d30:	6394                	ld	a3,0(a5)
    80005d32:	96b2                	add	a3,a3,a2
    80005d34:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005d38:	6398                	ld	a4,0(a5)
    80005d3a:	9732                	add	a4,a4,a2
    80005d3c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005d40:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005d44:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005d48:	953e                	add	a0,a0,a5
    80005d4a:	4785                	li	a5,1
    80005d4c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005d50:	0001c517          	auipc	a0,0x1c
    80005d54:	70850513          	addi	a0,a0,1800 # 80022458 <disk+0x18>
    80005d58:	ffffc097          	auipc	ra,0xffffc
    80005d5c:	360080e7          	jalr	864(ra) # 800020b8 <wakeup>
}
    80005d60:	60a2                	ld	ra,8(sp)
    80005d62:	6402                	ld	s0,0(sp)
    80005d64:	0141                	addi	sp,sp,16
    80005d66:	8082                	ret
    panic("free_desc 1");
    80005d68:	00003517          	auipc	a0,0x3
    80005d6c:	9f050513          	addi	a0,a0,-1552 # 80008758 <syscalls+0x2f8>
    80005d70:	ffffa097          	auipc	ra,0xffffa
    80005d74:	7ce080e7          	jalr	1998(ra) # 8000053e <panic>
    panic("free_desc 2");
    80005d78:	00003517          	auipc	a0,0x3
    80005d7c:	9f050513          	addi	a0,a0,-1552 # 80008768 <syscalls+0x308>
    80005d80:	ffffa097          	auipc	ra,0xffffa
    80005d84:	7be080e7          	jalr	1982(ra) # 8000053e <panic>

0000000080005d88 <virtio_disk_init>:
{
    80005d88:	1101                	addi	sp,sp,-32
    80005d8a:	ec06                	sd	ra,24(sp)
    80005d8c:	e822                	sd	s0,16(sp)
    80005d8e:	e426                	sd	s1,8(sp)
    80005d90:	e04a                	sd	s2,0(sp)
    80005d92:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005d94:	00003597          	auipc	a1,0x3
    80005d98:	9e458593          	addi	a1,a1,-1564 # 80008778 <syscalls+0x318>
    80005d9c:	0001c517          	auipc	a0,0x1c
    80005da0:	7cc50513          	addi	a0,a0,1996 # 80022568 <disk+0x128>
    80005da4:	ffffb097          	auipc	ra,0xffffb
    80005da8:	da2080e7          	jalr	-606(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dac:	100017b7          	lui	a5,0x10001
    80005db0:	4398                	lw	a4,0(a5)
    80005db2:	2701                	sext.w	a4,a4
    80005db4:	747277b7          	lui	a5,0x74727
    80005db8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005dbc:	14f71c63          	bne	a4,a5,80005f14 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dc0:	100017b7          	lui	a5,0x10001
    80005dc4:	43dc                	lw	a5,4(a5)
    80005dc6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005dc8:	4709                	li	a4,2
    80005dca:	14e79563          	bne	a5,a4,80005f14 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005dce:	100017b7          	lui	a5,0x10001
    80005dd2:	479c                	lw	a5,8(a5)
    80005dd4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005dd6:	12e79f63          	bne	a5,a4,80005f14 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005dda:	100017b7          	lui	a5,0x10001
    80005dde:	47d8                	lw	a4,12(a5)
    80005de0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005de2:	554d47b7          	lui	a5,0x554d4
    80005de6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005dea:	12f71563          	bne	a4,a5,80005f14 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dee:	100017b7          	lui	a5,0x10001
    80005df2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005df6:	4705                	li	a4,1
    80005df8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005dfa:	470d                	li	a4,3
    80005dfc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005dfe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e00:	c7ffe737          	lui	a4,0xc7ffe
    80005e04:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc1df>
    80005e08:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e0a:	2701                	sext.w	a4,a4
    80005e0c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e0e:	472d                	li	a4,11
    80005e10:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e12:	5bbc                	lw	a5,112(a5)
    80005e14:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e18:	8ba1                	andi	a5,a5,8
    80005e1a:	10078563          	beqz	a5,80005f24 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e1e:	100017b7          	lui	a5,0x10001
    80005e22:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005e26:	43fc                	lw	a5,68(a5)
    80005e28:	2781                	sext.w	a5,a5
    80005e2a:	10079563          	bnez	a5,80005f34 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e2e:	100017b7          	lui	a5,0x10001
    80005e32:	5bdc                	lw	a5,52(a5)
    80005e34:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e36:	10078763          	beqz	a5,80005f44 <virtio_disk_init+0x1bc>
  if(max < NUM)
    80005e3a:	471d                	li	a4,7
    80005e3c:	10f77c63          	bgeu	a4,a5,80005f54 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005e40:	ffffb097          	auipc	ra,0xffffb
    80005e44:	ca6080e7          	jalr	-858(ra) # 80000ae6 <kalloc>
    80005e48:	0001c497          	auipc	s1,0x1c
    80005e4c:	5f848493          	addi	s1,s1,1528 # 80022440 <disk>
    80005e50:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005e52:	ffffb097          	auipc	ra,0xffffb
    80005e56:	c94080e7          	jalr	-876(ra) # 80000ae6 <kalloc>
    80005e5a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005e5c:	ffffb097          	auipc	ra,0xffffb
    80005e60:	c8a080e7          	jalr	-886(ra) # 80000ae6 <kalloc>
    80005e64:	87aa                	mv	a5,a0
    80005e66:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005e68:	6088                	ld	a0,0(s1)
    80005e6a:	cd6d                	beqz	a0,80005f64 <virtio_disk_init+0x1dc>
    80005e6c:	0001c717          	auipc	a4,0x1c
    80005e70:	5dc73703          	ld	a4,1500(a4) # 80022448 <disk+0x8>
    80005e74:	cb65                	beqz	a4,80005f64 <virtio_disk_init+0x1dc>
    80005e76:	c7fd                	beqz	a5,80005f64 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005e78:	6605                	lui	a2,0x1
    80005e7a:	4581                	li	a1,0
    80005e7c:	ffffb097          	auipc	ra,0xffffb
    80005e80:	e56080e7          	jalr	-426(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005e84:	0001c497          	auipc	s1,0x1c
    80005e88:	5bc48493          	addi	s1,s1,1468 # 80022440 <disk>
    80005e8c:	6605                	lui	a2,0x1
    80005e8e:	4581                	li	a1,0
    80005e90:	6488                	ld	a0,8(s1)
    80005e92:	ffffb097          	auipc	ra,0xffffb
    80005e96:	e40080e7          	jalr	-448(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005e9a:	6605                	lui	a2,0x1
    80005e9c:	4581                	li	a1,0
    80005e9e:	6888                	ld	a0,16(s1)
    80005ea0:	ffffb097          	auipc	ra,0xffffb
    80005ea4:	e32080e7          	jalr	-462(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005ea8:	100017b7          	lui	a5,0x10001
    80005eac:	4721                	li	a4,8
    80005eae:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005eb0:	4098                	lw	a4,0(s1)
    80005eb2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005eb6:	40d8                	lw	a4,4(s1)
    80005eb8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005ebc:	6498                	ld	a4,8(s1)
    80005ebe:	0007069b          	sext.w	a3,a4
    80005ec2:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ec6:	9701                	srai	a4,a4,0x20
    80005ec8:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005ecc:	6898                	ld	a4,16(s1)
    80005ece:	0007069b          	sext.w	a3,a4
    80005ed2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005ed6:	9701                	srai	a4,a4,0x20
    80005ed8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005edc:	4705                	li	a4,1
    80005ede:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005ee0:	00e48c23          	sb	a4,24(s1)
    80005ee4:	00e48ca3          	sb	a4,25(s1)
    80005ee8:	00e48d23          	sb	a4,26(s1)
    80005eec:	00e48da3          	sb	a4,27(s1)
    80005ef0:	00e48e23          	sb	a4,28(s1)
    80005ef4:	00e48ea3          	sb	a4,29(s1)
    80005ef8:	00e48f23          	sb	a4,30(s1)
    80005efc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f00:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f04:	0727a823          	sw	s2,112(a5)
}
    80005f08:	60e2                	ld	ra,24(sp)
    80005f0a:	6442                	ld	s0,16(sp)
    80005f0c:	64a2                	ld	s1,8(sp)
    80005f0e:	6902                	ld	s2,0(sp)
    80005f10:	6105                	addi	sp,sp,32
    80005f12:	8082                	ret
    panic("could not find virtio disk");
    80005f14:	00003517          	auipc	a0,0x3
    80005f18:	87450513          	addi	a0,a0,-1932 # 80008788 <syscalls+0x328>
    80005f1c:	ffffa097          	auipc	ra,0xffffa
    80005f20:	622080e7          	jalr	1570(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005f24:	00003517          	auipc	a0,0x3
    80005f28:	88450513          	addi	a0,a0,-1916 # 800087a8 <syscalls+0x348>
    80005f2c:	ffffa097          	auipc	ra,0xffffa
    80005f30:	612080e7          	jalr	1554(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80005f34:	00003517          	auipc	a0,0x3
    80005f38:	89450513          	addi	a0,a0,-1900 # 800087c8 <syscalls+0x368>
    80005f3c:	ffffa097          	auipc	ra,0xffffa
    80005f40:	602080e7          	jalr	1538(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80005f44:	00003517          	auipc	a0,0x3
    80005f48:	8a450513          	addi	a0,a0,-1884 # 800087e8 <syscalls+0x388>
    80005f4c:	ffffa097          	auipc	ra,0xffffa
    80005f50:	5f2080e7          	jalr	1522(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80005f54:	00003517          	auipc	a0,0x3
    80005f58:	8b450513          	addi	a0,a0,-1868 # 80008808 <syscalls+0x3a8>
    80005f5c:	ffffa097          	auipc	ra,0xffffa
    80005f60:	5e2080e7          	jalr	1506(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80005f64:	00003517          	auipc	a0,0x3
    80005f68:	8c450513          	addi	a0,a0,-1852 # 80008828 <syscalls+0x3c8>
    80005f6c:	ffffa097          	auipc	ra,0xffffa
    80005f70:	5d2080e7          	jalr	1490(ra) # 8000053e <panic>

0000000080005f74 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f74:	7119                	addi	sp,sp,-128
    80005f76:	fc86                	sd	ra,120(sp)
    80005f78:	f8a2                	sd	s0,112(sp)
    80005f7a:	f4a6                	sd	s1,104(sp)
    80005f7c:	f0ca                	sd	s2,96(sp)
    80005f7e:	ecce                	sd	s3,88(sp)
    80005f80:	e8d2                	sd	s4,80(sp)
    80005f82:	e4d6                	sd	s5,72(sp)
    80005f84:	e0da                	sd	s6,64(sp)
    80005f86:	fc5e                	sd	s7,56(sp)
    80005f88:	f862                	sd	s8,48(sp)
    80005f8a:	f466                	sd	s9,40(sp)
    80005f8c:	f06a                	sd	s10,32(sp)
    80005f8e:	ec6e                	sd	s11,24(sp)
    80005f90:	0100                	addi	s0,sp,128
    80005f92:	8aaa                	mv	s5,a0
    80005f94:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f96:	00c52d03          	lw	s10,12(a0)
    80005f9a:	001d1d1b          	slliw	s10,s10,0x1
    80005f9e:	1d02                	slli	s10,s10,0x20
    80005fa0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005fa4:	0001c517          	auipc	a0,0x1c
    80005fa8:	5c450513          	addi	a0,a0,1476 # 80022568 <disk+0x128>
    80005fac:	ffffb097          	auipc	ra,0xffffb
    80005fb0:	c2a080e7          	jalr	-982(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80005fb4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005fb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005fb8:	0001cb97          	auipc	s7,0x1c
    80005fbc:	488b8b93          	addi	s7,s7,1160 # 80022440 <disk>
  for(int i = 0; i < 3; i++){
    80005fc0:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fc2:	0001cc97          	auipc	s9,0x1c
    80005fc6:	5a6c8c93          	addi	s9,s9,1446 # 80022568 <disk+0x128>
    80005fca:	a08d                	j	8000602c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80005fcc:	00fb8733          	add	a4,s7,a5
    80005fd0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005fd4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005fd6:	0207c563          	bltz	a5,80006000 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005fda:	2905                	addiw	s2,s2,1
    80005fdc:	0611                	addi	a2,a2,4
    80005fde:	05690c63          	beq	s2,s6,80006036 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005fe2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005fe4:	0001c717          	auipc	a4,0x1c
    80005fe8:	45c70713          	addi	a4,a4,1116 # 80022440 <disk>
    80005fec:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005fee:	01874683          	lbu	a3,24(a4)
    80005ff2:	fee9                	bnez	a3,80005fcc <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005ff4:	2785                	addiw	a5,a5,1
    80005ff6:	0705                	addi	a4,a4,1
    80005ff8:	fe979be3          	bne	a5,s1,80005fee <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005ffc:	57fd                	li	a5,-1
    80005ffe:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006000:	01205d63          	blez	s2,8000601a <virtio_disk_rw+0xa6>
    80006004:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006006:	000a2503          	lw	a0,0(s4)
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	cfc080e7          	jalr	-772(ra) # 80005d06 <free_desc>
      for(int j = 0; j < i; j++)
    80006012:	2d85                	addiw	s11,s11,1
    80006014:	0a11                	addi	s4,s4,4
    80006016:	ffb918e3          	bne	s2,s11,80006006 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000601a:	85e6                	mv	a1,s9
    8000601c:	0001c517          	auipc	a0,0x1c
    80006020:	43c50513          	addi	a0,a0,1084 # 80022458 <disk+0x18>
    80006024:	ffffc097          	auipc	ra,0xffffc
    80006028:	030080e7          	jalr	48(ra) # 80002054 <sleep>
  for(int i = 0; i < 3; i++){
    8000602c:	f8040a13          	addi	s4,s0,-128
{
    80006030:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006032:	894e                	mv	s2,s3
    80006034:	b77d                	j	80005fe2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006036:	f8042583          	lw	a1,-128(s0)
    8000603a:	00a58793          	addi	a5,a1,10
    8000603e:	0792                	slli	a5,a5,0x4

  if(write)
    80006040:	0001c617          	auipc	a2,0x1c
    80006044:	40060613          	addi	a2,a2,1024 # 80022440 <disk>
    80006048:	00f60733          	add	a4,a2,a5
    8000604c:	018036b3          	snez	a3,s8
    80006050:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006052:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006056:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000605a:	f6078693          	addi	a3,a5,-160
    8000605e:	6218                	ld	a4,0(a2)
    80006060:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006062:	00878513          	addi	a0,a5,8
    80006066:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006068:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000606a:	6208                	ld	a0,0(a2)
    8000606c:	96aa                	add	a3,a3,a0
    8000606e:	4741                	li	a4,16
    80006070:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006072:	4705                	li	a4,1
    80006074:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006078:	f8442703          	lw	a4,-124(s0)
    8000607c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006080:	0712                	slli	a4,a4,0x4
    80006082:	953a                	add	a0,a0,a4
    80006084:	058a8693          	addi	a3,s5,88
    80006088:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000608a:	6208                	ld	a0,0(a2)
    8000608c:	972a                	add	a4,a4,a0
    8000608e:	40000693          	li	a3,1024
    80006092:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006094:	001c3c13          	seqz	s8,s8
    80006098:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000609a:	001c6c13          	ori	s8,s8,1
    8000609e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800060a2:	f8842603          	lw	a2,-120(s0)
    800060a6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800060aa:	0001c697          	auipc	a3,0x1c
    800060ae:	39668693          	addi	a3,a3,918 # 80022440 <disk>
    800060b2:	00258713          	addi	a4,a1,2
    800060b6:	0712                	slli	a4,a4,0x4
    800060b8:	9736                	add	a4,a4,a3
    800060ba:	587d                	li	a6,-1
    800060bc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800060c0:	0612                	slli	a2,a2,0x4
    800060c2:	9532                	add	a0,a0,a2
    800060c4:	f9078793          	addi	a5,a5,-112
    800060c8:	97b6                	add	a5,a5,a3
    800060ca:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    800060cc:	629c                	ld	a5,0(a3)
    800060ce:	97b2                	add	a5,a5,a2
    800060d0:	4605                	li	a2,1
    800060d2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800060d4:	4509                	li	a0,2
    800060d6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    800060da:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800060de:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800060e2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800060e6:	6698                	ld	a4,8(a3)
    800060e8:	00275783          	lhu	a5,2(a4)
    800060ec:	8b9d                	andi	a5,a5,7
    800060ee:	0786                	slli	a5,a5,0x1
    800060f0:	97ba                	add	a5,a5,a4
    800060f2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800060f6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800060fa:	6698                	ld	a4,8(a3)
    800060fc:	00275783          	lhu	a5,2(a4)
    80006100:	2785                	addiw	a5,a5,1
    80006102:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006106:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000610a:	100017b7          	lui	a5,0x10001
    8000610e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006112:	004aa783          	lw	a5,4(s5)
    80006116:	02c79163          	bne	a5,a2,80006138 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000611a:	0001c917          	auipc	s2,0x1c
    8000611e:	44e90913          	addi	s2,s2,1102 # 80022568 <disk+0x128>
  while(b->disk == 1) {
    80006122:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006124:	85ca                	mv	a1,s2
    80006126:	8556                	mv	a0,s5
    80006128:	ffffc097          	auipc	ra,0xffffc
    8000612c:	f2c080e7          	jalr	-212(ra) # 80002054 <sleep>
  while(b->disk == 1) {
    80006130:	004aa783          	lw	a5,4(s5)
    80006134:	fe9788e3          	beq	a5,s1,80006124 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006138:	f8042903          	lw	s2,-128(s0)
    8000613c:	00290793          	addi	a5,s2,2
    80006140:	00479713          	slli	a4,a5,0x4
    80006144:	0001c797          	auipc	a5,0x1c
    80006148:	2fc78793          	addi	a5,a5,764 # 80022440 <disk>
    8000614c:	97ba                	add	a5,a5,a4
    8000614e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006152:	0001c997          	auipc	s3,0x1c
    80006156:	2ee98993          	addi	s3,s3,750 # 80022440 <disk>
    8000615a:	00491713          	slli	a4,s2,0x4
    8000615e:	0009b783          	ld	a5,0(s3)
    80006162:	97ba                	add	a5,a5,a4
    80006164:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006168:	854a                	mv	a0,s2
    8000616a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	b98080e7          	jalr	-1128(ra) # 80005d06 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006176:	8885                	andi	s1,s1,1
    80006178:	f0ed                	bnez	s1,8000615a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000617a:	0001c517          	auipc	a0,0x1c
    8000617e:	3ee50513          	addi	a0,a0,1006 # 80022568 <disk+0x128>
    80006182:	ffffb097          	auipc	ra,0xffffb
    80006186:	b08080e7          	jalr	-1272(ra) # 80000c8a <release>
}
    8000618a:	70e6                	ld	ra,120(sp)
    8000618c:	7446                	ld	s0,112(sp)
    8000618e:	74a6                	ld	s1,104(sp)
    80006190:	7906                	ld	s2,96(sp)
    80006192:	69e6                	ld	s3,88(sp)
    80006194:	6a46                	ld	s4,80(sp)
    80006196:	6aa6                	ld	s5,72(sp)
    80006198:	6b06                	ld	s6,64(sp)
    8000619a:	7be2                	ld	s7,56(sp)
    8000619c:	7c42                	ld	s8,48(sp)
    8000619e:	7ca2                	ld	s9,40(sp)
    800061a0:	7d02                	ld	s10,32(sp)
    800061a2:	6de2                	ld	s11,24(sp)
    800061a4:	6109                	addi	sp,sp,128
    800061a6:	8082                	ret

00000000800061a8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800061a8:	1101                	addi	sp,sp,-32
    800061aa:	ec06                	sd	ra,24(sp)
    800061ac:	e822                	sd	s0,16(sp)
    800061ae:	e426                	sd	s1,8(sp)
    800061b0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061b2:	0001c497          	auipc	s1,0x1c
    800061b6:	28e48493          	addi	s1,s1,654 # 80022440 <disk>
    800061ba:	0001c517          	auipc	a0,0x1c
    800061be:	3ae50513          	addi	a0,a0,942 # 80022568 <disk+0x128>
    800061c2:	ffffb097          	auipc	ra,0xffffb
    800061c6:	a14080e7          	jalr	-1516(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800061ca:	10001737          	lui	a4,0x10001
    800061ce:	533c                	lw	a5,96(a4)
    800061d0:	8b8d                	andi	a5,a5,3
    800061d2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800061d4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800061d8:	689c                	ld	a5,16(s1)
    800061da:	0204d703          	lhu	a4,32(s1)
    800061de:	0027d783          	lhu	a5,2(a5)
    800061e2:	04f70863          	beq	a4,a5,80006232 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800061e6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061ea:	6898                	ld	a4,16(s1)
    800061ec:	0204d783          	lhu	a5,32(s1)
    800061f0:	8b9d                	andi	a5,a5,7
    800061f2:	078e                	slli	a5,a5,0x3
    800061f4:	97ba                	add	a5,a5,a4
    800061f6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800061f8:	00278713          	addi	a4,a5,2
    800061fc:	0712                	slli	a4,a4,0x4
    800061fe:	9726                	add	a4,a4,s1
    80006200:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006204:	e721                	bnez	a4,8000624c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006206:	0789                	addi	a5,a5,2
    80006208:	0792                	slli	a5,a5,0x4
    8000620a:	97a6                	add	a5,a5,s1
    8000620c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000620e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006212:	ffffc097          	auipc	ra,0xffffc
    80006216:	ea6080e7          	jalr	-346(ra) # 800020b8 <wakeup>

    disk.used_idx += 1;
    8000621a:	0204d783          	lhu	a5,32(s1)
    8000621e:	2785                	addiw	a5,a5,1
    80006220:	17c2                	slli	a5,a5,0x30
    80006222:	93c1                	srli	a5,a5,0x30
    80006224:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006228:	6898                	ld	a4,16(s1)
    8000622a:	00275703          	lhu	a4,2(a4)
    8000622e:	faf71ce3          	bne	a4,a5,800061e6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006232:	0001c517          	auipc	a0,0x1c
    80006236:	33650513          	addi	a0,a0,822 # 80022568 <disk+0x128>
    8000623a:	ffffb097          	auipc	ra,0xffffb
    8000623e:	a50080e7          	jalr	-1456(ra) # 80000c8a <release>
}
    80006242:	60e2                	ld	ra,24(sp)
    80006244:	6442                	ld	s0,16(sp)
    80006246:	64a2                	ld	s1,8(sp)
    80006248:	6105                	addi	sp,sp,32
    8000624a:	8082                	ret
      panic("virtio_disk_intr status");
    8000624c:	00002517          	auipc	a0,0x2
    80006250:	5f450513          	addi	a0,a0,1524 # 80008840 <syscalls+0x3e0>
    80006254:	ffffa097          	auipc	ra,0xffffa
    80006258:	2ea080e7          	jalr	746(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
