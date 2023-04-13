
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000056:	8de70713          	addi	a4,a4,-1826 # 80008930 <timer_scratch>
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
    80000068:	18c78793          	addi	a5,a5,396 # 800061f0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb45f>
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
    80000130:	610080e7          	jalr	1552(ra) # 8000273c <either_copyin>
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
    8000018e:	8e650513          	addi	a0,a0,-1818 # 80010a70 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8d648493          	addi	s1,s1,-1834 # 80010a70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	96690913          	addi	s2,s2,-1690 # 80010b08 <cons+0x98>
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
    800001cc:	37c080e7          	jalr	892(ra) # 80002544 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	046080e7          	jalr	70(ra) # 8000221c <sleep>
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
    80000216:	4d4080e7          	jalr	1236(ra) # 800026e6 <either_copyout>
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
    8000022a:	84a50513          	addi	a0,a0,-1974 # 80010a70 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	83450513          	addi	a0,a0,-1996 # 80010a70 <cons>
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
    80000276:	88f72b23          	sw	a5,-1898(a4) # 80010b08 <cons+0x98>
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
    800002d0:	7a450513          	addi	a0,a0,1956 # 80010a70 <cons>
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
    800002f6:	4a0080e7          	jalr	1184(ra) # 80002792 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	77650513          	addi	a0,a0,1910 # 80010a70 <cons>
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
    80000322:	75270713          	addi	a4,a4,1874 # 80010a70 <cons>
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
    8000034c:	72878793          	addi	a5,a5,1832 # 80010a70 <cons>
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
    8000037a:	7927a783          	lw	a5,1938(a5) # 80010b08 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6e670713          	addi	a4,a4,1766 # 80010a70 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6d648493          	addi	s1,s1,1750 # 80010a70 <cons>
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
    800003da:	69a70713          	addi	a4,a4,1690 # 80010a70 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	72f72223          	sw	a5,1828(a4) # 80010b10 <cons+0xa0>
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
    80000416:	65e78793          	addi	a5,a5,1630 # 80010a70 <cons>
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
    8000043a:	6cc7ab23          	sw	a2,1750(a5) # 80010b0c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6ca50513          	addi	a0,a0,1738 # 80010b08 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	e3a080e7          	jalr	-454(ra) # 80002280 <wakeup>
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
    80000464:	61050513          	addi	a0,a0,1552 # 80010a70 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00022797          	auipc	a5,0x22
    8000047c:	d9078793          	addi	a5,a5,-624 # 80022208 <devsw>
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
    8000054e:	5e07a323          	sw	zero,1510(a5) # 80010b30 <pr+0x18>
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
    80000582:	36f72923          	sw	a5,882(a4) # 800088f0 <panicked>
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
    800005be:	576dad83          	lw	s11,1398(s11) # 80010b30 <pr+0x18>
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
    800005fc:	52050513          	addi	a0,a0,1312 # 80010b18 <pr>
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
    8000075a:	3c250513          	addi	a0,a0,962 # 80010b18 <pr>
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
    80000776:	3a648493          	addi	s1,s1,934 # 80010b18 <pr>
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
    800007d6:	36650513          	addi	a0,a0,870 # 80010b38 <uart_tx_lock>
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
    80000802:	0f27a783          	lw	a5,242(a5) # 800088f0 <panicked>
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
    8000083a:	0c27b783          	ld	a5,194(a5) # 800088f8 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0c273703          	ld	a4,194(a4) # 80008900 <uart_tx_w>
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
    80000864:	2d8a0a13          	addi	s4,s4,728 # 80010b38 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	09048493          	addi	s1,s1,144 # 800088f8 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	09098993          	addi	s3,s3,144 # 80008900 <uart_tx_w>
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
    80000896:	9ee080e7          	jalr	-1554(ra) # 80002280 <wakeup>
    
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
    800008d2:	26a50513          	addi	a0,a0,618 # 80010b38 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0127a783          	lw	a5,18(a5) # 800088f0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	01873703          	ld	a4,24(a4) # 80008900 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0087b783          	ld	a5,8(a5) # 800088f8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	23c98993          	addi	s3,s3,572 # 80010b38 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	ff448493          	addi	s1,s1,-12 # 800088f8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	ff490913          	addi	s2,s2,-12 # 80008900 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	900080e7          	jalr	-1792(ra) # 8000221c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	20648493          	addi	s1,s1,518 # 80010b38 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	fae7bd23          	sd	a4,-70(a5) # 80008900 <uart_tx_w>
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
    800009c0:	17c48493          	addi	s1,s1,380 # 80010b38 <uart_tx_lock>
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
    800009fe:	00023797          	auipc	a5,0x23
    80000a02:	9a278793          	addi	a5,a5,-1630 # 800233a0 <end>
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
    80000a22:	15290913          	addi	s2,s2,338 # 80010b70 <kmem>
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
    80000abe:	0b650513          	addi	a0,a0,182 # 80010b70 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00023517          	auipc	a0,0x23
    80000ad2:	8d250513          	addi	a0,a0,-1838 # 800233a0 <end>
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
    80000af4:	08048493          	addi	s1,s1,128 # 80010b70 <kmem>
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
    80000b0c:	06850513          	addi	a0,a0,104 # 80010b70 <kmem>
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
    80000b38:	03c50513          	addi	a0,a0,60 # 80010b70 <kmem>
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
    80000e8c:	a8070713          	addi	a4,a4,-1408 # 80008908 <started>
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
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	c94080e7          	jalr	-876(ra) # 80002b52 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	36a080e7          	jalr	874(ra) # 80006230 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	074080e7          	jalr	116(ra) # 80001f42 <scheduler>
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
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	bf4080e7          	jalr	-1036(ra) # 80002b2a <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	c14080e7          	jalr	-1004(ra) # 80002b52 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	2d4080e7          	jalr	724(ra) # 8000621a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	2e2080e7          	jalr	738(ra) # 80006230 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	488080e7          	jalr	1160(ra) # 800033de <binit>
    iinit();         // inode table
    80000f5e:	00003097          	auipc	ra,0x3
    80000f62:	b2c080e7          	jalr	-1236(ra) # 80003a8a <iinit>
    fileinit();      // file table
    80000f66:	00004097          	auipc	ra,0x4
    80000f6a:	aca080e7          	jalr	-1334(ra) # 80004a30 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	3ca080e7          	jalr	970(ra) # 80006338 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	da6080e7          	jalr	-602(ra) # 80001d1c <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	98f72223          	sw	a5,-1660(a4) # 80008908 <started>
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
    80000f9c:	9787b783          	ld	a5,-1672(a5) # 80008910 <kernel_pagetable>
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
    80001258:	6aa7be23          	sd	a0,1724(a5) # 80008910 <kernel_pagetable>
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
    80001850:	77448493          	addi	s1,s1,1908 # 80010fc0 <proc>
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
    8000186a:	75aa0a13          	addi	s4,s4,1882 # 80017fc0 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if(pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	8599                	srai	a1,a1,0x6
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
    800018a0:	1c048493          	addi	s1,s1,448
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
    800018ec:	2a850513          	addi	a0,a0,680 # 80010b90 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	2a850513          	addi	a0,a0,680 # 80010ba8 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	6b048493          	addi	s1,s1,1712 # 80010fc0 <proc>
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
    80001936:	68e98993          	addi	s3,s3,1678 # 80017fc0 <tickslock>
      initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
      p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	8799                	srai	a5,a5,0x6
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	f4bc                	sd	a5,104(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	1c048493          	addi	s1,s1,448
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
    800019a0:	22450513          	addi	a0,a0,548 # 80010bc0 <cpus>
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
    800019c8:	1cc70713          	addi	a4,a4,460 # 80010b90 <pid_lock>
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
    80001a00:	e847a783          	lw	a5,-380(a5) # 80008880 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	164080e7          	jalr	356(ra) # 80002b6a <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	e607a523          	sw	zero,-406(a5) # 80008880 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	fea080e7          	jalr	-22(ra) # 80003a0a <fsinit>
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
    80001a3a:	15a90913          	addi	s2,s2,346 # 80010b90 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	e3c78793          	addi	a5,a5,-452 # 80008884 <nextpid>
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
    80001aac:	08093683          	ld	a3,128(s2)
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
    80001b6a:	6148                	ld	a0,128(a0)
    80001b6c:	c509                	beqz	a0,80001b76 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	e7c080e7          	jalr	-388(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b76:	0804b023          	sd	zero,128(s1)
  if(p->pagetable)
    80001b7a:	7ca8                	ld	a0,120(s1)
    80001b7c:	c511                	beqz	a0,80001b88 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7e:	78ac                	ld	a1,112(s1)
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	f8c080e7          	jalr	-116(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b88:	0604bc23          	sd	zero,120(s1)
  p->sz = 0;
    80001b8c:	0604b823          	sd	zero,112(s1)
  p->pid = 0;
    80001b90:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b94:	0604b023          	sd	zero,96(s1)
  p->name[0] = 0;
    80001b98:	18048023          	sb	zero,384(s1)
  p->chan = 0;
    80001b9c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ba0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ba4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba8:	0004ac23          	sw	zero,24(s1)
  p->ps_priority=5;
    80001bac:	4795                	li	a5,5
    80001bae:	18f4a823          	sw	a5,400(s1)
  p->cfs_priority=100;
    80001bb2:	06400793          	li	a5,100
    80001bb6:	18f4aa23          	sw	a5,404(s1)
  p->rtime=0;
    80001bba:	1804bc23          	sd	zero,408(s1)
  p->stime=0;
    80001bbe:	1a04b023          	sd	zero,416(s1)
  p->retime=0;
    80001bc2:	1a04b423          	sd	zero,424(s1)
  p->vruntime = 0;
    80001bc6:	1a04b823          	sd	zero,432(s1)
  p->init_ticks=ticks;
    80001bca:	00007797          	auipc	a5,0x7
    80001bce:	d5e7e783          	lwu	a5,-674(a5) # 80008928 <ticks>
    80001bd2:	1af4bc23          	sd	a5,440(s1)
    long long min=LLONG_MAX;
    80001bd6:	55fd                	li	a1,-1
    80001bd8:	8185                	srli	a1,a1,0x1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001bda:	0000f797          	auipc	a5,0xf
    80001bde:	3e678793          	addi	a5,a5,998 # 80010fc0 <proc>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001be2:	4605                	li	a2,1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001be4:	00016697          	auipc	a3,0x16
    80001be8:	3dc68693          	addi	a3,a3,988 # 80017fc0 <tickslock>
    80001bec:	a029                	j	80001bf6 <freeproc+0x98>
    80001bee:	1c078793          	addi	a5,a5,448
    80001bf2:	00d78d63          	beq	a5,a3,80001c0c <freeproc+0xae>
        if(other_p != p){
    80001bf6:	fef48ce3          	beq	s1,a5,80001bee <freeproc+0x90>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001bfa:	4f98                	lw	a4,24(a5)
    80001bfc:	3775                	addiw	a4,a4,-3
    80001bfe:	fee668e3          	bltu	a2,a4,80001bee <freeproc+0x90>
              if(min>other_p->accumulator)
    80001c02:	6fb8                	ld	a4,88(a5)
    80001c04:	feb755e3          	bge	a4,a1,80001bee <freeproc+0x90>
    80001c08:	85ba                	mv	a1,a4
    80001c0a:	b7d5                	j	80001bee <freeproc+0x90>
    if(min==LLONG_MAX){
    80001c0c:	57fd                	li	a5,-1
    80001c0e:	8385                	srli	a5,a5,0x1
    80001c10:	00f58863          	beq	a1,a5,80001c20 <freeproc+0xc2>
    80001c14:	ecac                	sd	a1,88(s1)
}
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6105                	addi	sp,sp,32
    80001c1e:	8082                	ret
      p->accumulator=0;
    80001c20:	4581                	li	a1,0
    80001c22:	bfcd                	j	80001c14 <freeproc+0xb6>

0000000080001c24 <allocproc>:
{
    80001c24:	1101                	addi	sp,sp,-32
    80001c26:	ec06                	sd	ra,24(sp)
    80001c28:	e822                	sd	s0,16(sp)
    80001c2a:	e426                	sd	s1,8(sp)
    80001c2c:	e04a                	sd	s2,0(sp)
    80001c2e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c30:	0000f497          	auipc	s1,0xf
    80001c34:	39048493          	addi	s1,s1,912 # 80010fc0 <proc>
    80001c38:	00016917          	auipc	s2,0x16
    80001c3c:	38890913          	addi	s2,s2,904 # 80017fc0 <tickslock>
    acquire(&p->lock);
    80001c40:	8526                	mv	a0,s1
    80001c42:	fffff097          	auipc	ra,0xfffff
    80001c46:	f94080e7          	jalr	-108(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001c4a:	4c9c                	lw	a5,24(s1)
    80001c4c:	cf81                	beqz	a5,80001c64 <allocproc+0x40>
      release(&p->lock);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	03a080e7          	jalr	58(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c58:	1c048493          	addi	s1,s1,448
    80001c5c:	ff2492e3          	bne	s1,s2,80001c40 <allocproc+0x1c>
  return 0;
    80001c60:	4481                	li	s1,0
    80001c62:	a8b5                	j	80001cde <allocproc+0xba>
  p->pid = allocpid();
    80001c64:	00000097          	auipc	ra,0x0
    80001c68:	dc6080e7          	jalr	-570(ra) # 80001a2a <allocpid>
    80001c6c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c6e:	4785                	li	a5,1
    80001c70:	cc9c                	sw	a5,24(s1)
  p->ps_priority=5;
    80001c72:	4795                	li	a5,5
    80001c74:	18f4a823          	sw	a5,400(s1)
  p->cfs_priority=100;
    80001c78:	06400793          	li	a5,100
    80001c7c:	18f4aa23          	sw	a5,404(s1)
  p->rtime=0;
    80001c80:	1804bc23          	sd	zero,408(s1)
  p->stime=0;
    80001c84:	1a04b023          	sd	zero,416(s1)
  p->retime=0;
    80001c88:	1a04b423          	sd	zero,424(s1)
  p->vruntime = 0;
    80001c8c:	1a04b823          	sd	zero,432(s1)
  p->init_ticks=ticks;
    80001c90:	00007797          	auipc	a5,0x7
    80001c94:	c987e783          	lwu	a5,-872(a5) # 80008928 <ticks>
    80001c98:	1af4bc23          	sd	a5,440(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	e4a080e7          	jalr	-438(ra) # 80000ae6 <kalloc>
    80001ca4:	892a                	mv	s2,a0
    80001ca6:	e0c8                	sd	a0,128(s1)
    80001ca8:	c131                	beqz	a0,80001cec <allocproc+0xc8>
  p->pagetable = proc_pagetable(p);
    80001caa:	8526                	mv	a0,s1
    80001cac:	00000097          	auipc	ra,0x0
    80001cb0:	dc4080e7          	jalr	-572(ra) # 80001a70 <proc_pagetable>
    80001cb4:	892a                	mv	s2,a0
    80001cb6:	fca8                	sd	a0,120(s1)
  if(p->pagetable == 0){
    80001cb8:	c531                	beqz	a0,80001d04 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001cba:	07000613          	li	a2,112
    80001cbe:	4581                	li	a1,0
    80001cc0:	08848513          	addi	a0,s1,136
    80001cc4:	fffff097          	auipc	ra,0xfffff
    80001cc8:	00e080e7          	jalr	14(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001ccc:	00000797          	auipc	a5,0x0
    80001cd0:	d1878793          	addi	a5,a5,-744 # 800019e4 <forkret>
    80001cd4:	e4dc                	sd	a5,136(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cd6:	74bc                	ld	a5,104(s1)
    80001cd8:	6705                	lui	a4,0x1
    80001cda:	97ba                	add	a5,a5,a4
    80001cdc:	e8dc                	sd	a5,144(s1)
}
    80001cde:	8526                	mv	a0,s1
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6902                	ld	s2,0(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret
    freeproc(p);
    80001cec:	8526                	mv	a0,s1
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	e70080e7          	jalr	-400(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001cf6:	8526                	mv	a0,s1
    80001cf8:	fffff097          	auipc	ra,0xfffff
    80001cfc:	f92080e7          	jalr	-110(ra) # 80000c8a <release>
    return 0;
    80001d00:	84ca                	mv	s1,s2
    80001d02:	bff1                	j	80001cde <allocproc+0xba>
    freeproc(p);
    80001d04:	8526                	mv	a0,s1
    80001d06:	00000097          	auipc	ra,0x0
    80001d0a:	e58080e7          	jalr	-424(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001d0e:	8526                	mv	a0,s1
    80001d10:	fffff097          	auipc	ra,0xfffff
    80001d14:	f7a080e7          	jalr	-134(ra) # 80000c8a <release>
    return 0;
    80001d18:	84ca                	mv	s1,s2
    80001d1a:	b7d1                	j	80001cde <allocproc+0xba>

0000000080001d1c <userinit>:
{
    80001d1c:	1101                	addi	sp,sp,-32
    80001d1e:	ec06                	sd	ra,24(sp)
    80001d20:	e822                	sd	s0,16(sp)
    80001d22:	e426                	sd	s1,8(sp)
    80001d24:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d26:	00000097          	auipc	ra,0x0
    80001d2a:	efe080e7          	jalr	-258(ra) # 80001c24 <allocproc>
    80001d2e:	84aa                	mv	s1,a0
  initproc = p;
    80001d30:	00007797          	auipc	a5,0x7
    80001d34:	bea7b823          	sd	a0,-1040(a5) # 80008920 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d38:	03400613          	li	a2,52
    80001d3c:	00007597          	auipc	a1,0x7
    80001d40:	b5458593          	addi	a1,a1,-1196 # 80008890 <initcode>
    80001d44:	7d28                	ld	a0,120(a0)
    80001d46:	fffff097          	auipc	ra,0xfffff
    80001d4a:	610080e7          	jalr	1552(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001d4e:	6785                	lui	a5,0x1
    80001d50:	f8bc                	sd	a5,112(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d52:	60d8                	ld	a4,128(s1)
    80001d54:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d58:	60d8                	ld	a4,128(s1)
    80001d5a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d5c:	4641                	li	a2,16
    80001d5e:	00006597          	auipc	a1,0x6
    80001d62:	4a258593          	addi	a1,a1,1186 # 80008200 <digits+0x1c0>
    80001d66:	18048513          	addi	a0,s1,384
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	0b2080e7          	jalr	178(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001d72:	00006517          	auipc	a0,0x6
    80001d76:	49e50513          	addi	a0,a0,1182 # 80008210 <digits+0x1d0>
    80001d7a:	00002097          	auipc	ra,0x2
    80001d7e:	6b2080e7          	jalr	1714(ra) # 8000442c <namei>
    80001d82:	16a4bc23          	sd	a0,376(s1)
  p->state = RUNNABLE;
    80001d86:	478d                	li	a5,3
    80001d88:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	fffff097          	auipc	ra,0xfffff
    80001d90:	efe080e7          	jalr	-258(ra) # 80000c8a <release>
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6105                	addi	sp,sp,32
    80001d9c:	8082                	ret

0000000080001d9e <growproc>:
{
    80001d9e:	1101                	addi	sp,sp,-32
    80001da0:	ec06                	sd	ra,24(sp)
    80001da2:	e822                	sd	s0,16(sp)
    80001da4:	e426                	sd	s1,8(sp)
    80001da6:	e04a                	sd	s2,0(sp)
    80001da8:	1000                	addi	s0,sp,32
    80001daa:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	c00080e7          	jalr	-1024(ra) # 800019ac <myproc>
    80001db4:	84aa                	mv	s1,a0
  sz = p->sz;
    80001db6:	792c                	ld	a1,112(a0)
  if(n > 0){
    80001db8:	01204c63          	bgtz	s2,80001dd0 <growproc+0x32>
  } else if(n < 0){
    80001dbc:	02094663          	bltz	s2,80001de8 <growproc+0x4a>
  p->sz = sz;
    80001dc0:	f8ac                	sd	a1,112(s1)
  return 0;
    80001dc2:	4501                	li	a0,0
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6902                	ld	s2,0(sp)
    80001dcc:	6105                	addi	sp,sp,32
    80001dce:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dd0:	4691                	li	a3,4
    80001dd2:	00b90633          	add	a2,s2,a1
    80001dd6:	7d28                	ld	a0,120(a0)
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	638080e7          	jalr	1592(ra) # 80001410 <uvmalloc>
    80001de0:	85aa                	mv	a1,a0
    80001de2:	fd79                	bnez	a0,80001dc0 <growproc+0x22>
      return -1;
    80001de4:	557d                	li	a0,-1
    80001de6:	bff9                	j	80001dc4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001de8:	00b90633          	add	a2,s2,a1
    80001dec:	7d28                	ld	a0,120(a0)
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	5da080e7          	jalr	1498(ra) # 800013c8 <uvmdealloc>
    80001df6:	85aa                	mv	a1,a0
    80001df8:	b7e1                	j	80001dc0 <growproc+0x22>

0000000080001dfa <fork>:
{
    80001dfa:	7139                	addi	sp,sp,-64
    80001dfc:	fc06                	sd	ra,56(sp)
    80001dfe:	f822                	sd	s0,48(sp)
    80001e00:	f426                	sd	s1,40(sp)
    80001e02:	f04a                	sd	s2,32(sp)
    80001e04:	ec4e                	sd	s3,24(sp)
    80001e06:	e852                	sd	s4,16(sp)
    80001e08:	e456                	sd	s5,8(sp)
    80001e0a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	ba0080e7          	jalr	-1120(ra) # 800019ac <myproc>
    80001e14:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e16:	00000097          	auipc	ra,0x0
    80001e1a:	e0e080e7          	jalr	-498(ra) # 80001c24 <allocproc>
    80001e1e:	12050063          	beqz	a0,80001f3e <fork+0x144>
    80001e22:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e24:	070ab603          	ld	a2,112(s5)
    80001e28:	7d2c                	ld	a1,120(a0)
    80001e2a:	078ab503          	ld	a0,120(s5)
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	736080e7          	jalr	1846(ra) # 80001564 <uvmcopy>
    80001e36:	04054863          	bltz	a0,80001e86 <fork+0x8c>
  np->sz = p->sz;
    80001e3a:	070ab783          	ld	a5,112(s5)
    80001e3e:	06f9b823          	sd	a5,112(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e42:	080ab683          	ld	a3,128(s5)
    80001e46:	87b6                	mv	a5,a3
    80001e48:	0809b703          	ld	a4,128(s3)
    80001e4c:	12068693          	addi	a3,a3,288
    80001e50:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e54:	6788                	ld	a0,8(a5)
    80001e56:	6b8c                	ld	a1,16(a5)
    80001e58:	6f90                	ld	a2,24(a5)
    80001e5a:	01073023          	sd	a6,0(a4)
    80001e5e:	e708                	sd	a0,8(a4)
    80001e60:	eb0c                	sd	a1,16(a4)
    80001e62:	ef10                	sd	a2,24(a4)
    80001e64:	02078793          	addi	a5,a5,32
    80001e68:	02070713          	addi	a4,a4,32
    80001e6c:	fed792e3          	bne	a5,a3,80001e50 <fork+0x56>
  np->trapframe->a0 = 0;
    80001e70:	0809b783          	ld	a5,128(s3)
    80001e74:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e78:	0f8a8493          	addi	s1,s5,248
    80001e7c:	0f898913          	addi	s2,s3,248
    80001e80:	178a8a13          	addi	s4,s5,376
    80001e84:	a00d                	j	80001ea6 <fork+0xac>
    freeproc(np);
    80001e86:	854e                	mv	a0,s3
    80001e88:	00000097          	auipc	ra,0x0
    80001e8c:	cd6080e7          	jalr	-810(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001e90:	854e                	mv	a0,s3
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	df8080e7          	jalr	-520(ra) # 80000c8a <release>
    return -1;
    80001e9a:	597d                	li	s2,-1
    80001e9c:	a079                	j	80001f2a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001e9e:	04a1                	addi	s1,s1,8
    80001ea0:	0921                	addi	s2,s2,8
    80001ea2:	01448b63          	beq	s1,s4,80001eb8 <fork+0xbe>
    if(p->ofile[i])
    80001ea6:	6088                	ld	a0,0(s1)
    80001ea8:	d97d                	beqz	a0,80001e9e <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eaa:	00003097          	auipc	ra,0x3
    80001eae:	c18080e7          	jalr	-1000(ra) # 80004ac2 <filedup>
    80001eb2:	00a93023          	sd	a0,0(s2)
    80001eb6:	b7e5                	j	80001e9e <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001eb8:	178ab503          	ld	a0,376(s5)
    80001ebc:	00002097          	auipc	ra,0x2
    80001ec0:	d8c080e7          	jalr	-628(ra) # 80003c48 <idup>
    80001ec4:	16a9bc23          	sd	a0,376(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ec8:	4641                	li	a2,16
    80001eca:	180a8593          	addi	a1,s5,384
    80001ece:	18098513          	addi	a0,s3,384
    80001ed2:	fffff097          	auipc	ra,0xfffff
    80001ed6:	f4a080e7          	jalr	-182(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001eda:	0309a903          	lw	s2,48(s3)
  np->cfs_priority=p->cfs_priority;
    80001ede:	194aa783          	lw	a5,404(s5)
    80001ee2:	18f9aa23          	sw	a5,404(s3)
  release(&np->lock);
    80001ee6:	854e                	mv	a0,s3
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	da2080e7          	jalr	-606(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001ef0:	0000f497          	auipc	s1,0xf
    80001ef4:	cb848493          	addi	s1,s1,-840 # 80010ba8 <wait_lock>
    80001ef8:	8526                	mv	a0,s1
    80001efa:	fffff097          	auipc	ra,0xfffff
    80001efe:	cdc080e7          	jalr	-804(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001f02:	0759b023          	sd	s5,96(s3)
  release(&wait_lock);
    80001f06:	8526                	mv	a0,s1
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	d82080e7          	jalr	-638(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001f10:	854e                	mv	a0,s3
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	cc4080e7          	jalr	-828(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001f1a:	478d                	li	a5,3
    80001f1c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f20:	854e                	mv	a0,s3
    80001f22:	fffff097          	auipc	ra,0xfffff
    80001f26:	d68080e7          	jalr	-664(ra) # 80000c8a <release>
}
    80001f2a:	854a                	mv	a0,s2
    80001f2c:	70e2                	ld	ra,56(sp)
    80001f2e:	7442                	ld	s0,48(sp)
    80001f30:	74a2                	ld	s1,40(sp)
    80001f32:	7902                	ld	s2,32(sp)
    80001f34:	69e2                	ld	s3,24(sp)
    80001f36:	6a42                	ld	s4,16(sp)
    80001f38:	6aa2                	ld	s5,8(sp)
    80001f3a:	6121                	addi	sp,sp,64
    80001f3c:	8082                	ret
    return -1;
    80001f3e:	597d                	li	s2,-1
    80001f40:	b7ed                	j	80001f2a <fork+0x130>

0000000080001f42 <scheduler>:
{
    80001f42:	715d                	addi	sp,sp,-80
    80001f44:	e486                	sd	ra,72(sp)
    80001f46:	e0a2                	sd	s0,64(sp)
    80001f48:	fc26                	sd	s1,56(sp)
    80001f4a:	f84a                	sd	s2,48(sp)
    80001f4c:	f44e                	sd	s3,40(sp)
    80001f4e:	f052                	sd	s4,32(sp)
    80001f50:	ec56                	sd	s5,24(sp)
    80001f52:	e85a                	sd	s6,16(sp)
    80001f54:	e45e                	sd	s7,8(sp)
    80001f56:	e062                	sd	s8,0(sp)
    80001f58:	0880                	addi	s0,sp,80
    80001f5a:	8792                	mv	a5,tp
  int id = r_tp();
    80001f5c:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001f5e:	00779a93          	slli	s5,a5,0x7
    80001f62:	0000f717          	auipc	a4,0xf
    80001f66:	c2e70713          	addi	a4,a4,-978 # 80010b90 <pid_lock>
    80001f6a:	9756                	add	a4,a4,s5
    80001f6c:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &min_vruntime_proc->context);
    80001f70:	0000f717          	auipc	a4,0xf
    80001f74:	c5870713          	addi	a4,a4,-936 # 80010bc8 <cpus+0x8>
    80001f78:	9aba                	add	s5,s5,a4
      if(sched_policy==0){//original       
    80001f7a:	00007b97          	auipc	s7,0x7
    80001f7e:	99eb8b93          	addi	s7,s7,-1634 # 80008918 <sched_policy>
        for(p = proc; p < &proc[NPROC]; p++){
    80001f82:	00016917          	auipc	s2,0x16
    80001f86:	03e90913          	addi	s2,s2,62 # 80017fc0 <tickslock>
          min_vruntime_proc->state = RUNNING;
    80001f8a:	4b11                	li	s6,4
          c->proc = min_vruntime_proc;
    80001f8c:	079e                	slli	a5,a5,0x7
    80001f8e:	0000fa17          	auipc	s4,0xf
    80001f92:	c02a0a13          	addi	s4,s4,-1022 # 80010b90 <pid_lock>
    80001f96:	9a3e                	add	s4,s4,a5
    80001f98:	aa89                	j	800020ea <scheduler+0x1a8>
          release(&p->lock);
    80001f9a:	8526                	mv	a0,s1
    80001f9c:	fffff097          	auipc	ra,0xfffff
    80001fa0:	cee080e7          	jalr	-786(ra) # 80000c8a <release>
        for(p = proc; p < &proc[NPROC]; p++) {
    80001fa4:	1c048493          	addi	s1,s1,448
    80001fa8:	15248163          	beq	s1,s2,800020ea <scheduler+0x1a8>
          acquire(&p->lock);
    80001fac:	8526                	mv	a0,s1
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	c28080e7          	jalr	-984(ra) # 80000bd6 <acquire>
          if(p->state == RUNNABLE) {
    80001fb6:	4c9c                	lw	a5,24(s1)
    80001fb8:	ff3791e3          	bne	a5,s3,80001f9a <scheduler+0x58>
            p->state = RUNNING;
    80001fbc:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001fc0:	029a3823          	sd	s1,48(s4)
            swtch(&c->context, &p->context);
    80001fc4:	08848593          	addi	a1,s1,136
    80001fc8:	8556                	mv	a0,s5
    80001fca:	00001097          	auipc	ra,0x1
    80001fce:	af6080e7          	jalr	-1290(ra) # 80002ac0 <swtch>
            c->proc = 0;
    80001fd2:	020a3823          	sd	zero,48(s4)
    80001fd6:	b7d1                	j	80001f9a <scheduler+0x58>
      else if(sched_policy==1){//task 5
    80001fd8:	4705                	li	a4,1
    80001fda:	00e78f63          	beq	a5,a4,80001ff8 <scheduler+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fe2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe6:	10079073          	csrw	sstatus,a5
        struct proc * min_vruntime_proc = 0;
    80001fea:	4981                	li	s3,0
        for(p = proc; p < &proc[NPROC]; p++){
    80001fec:	0000f497          	auipc	s1,0xf
    80001ff0:	fd448493          	addi	s1,s1,-44 # 80010fc0 <proc>
          if(p->state == RUNNABLE){
    80001ff4:	4c0d                	li	s8,3
    80001ff6:	a879                	j	80002094 <scheduler+0x152>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ffc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002000:	10079073          	csrw	sstatus,a5
        struct proc * min_acc_proc = 0;
    80002004:	4981                	li	s3,0
        for(p = proc; p < &proc[NPROC]; p++){
    80002006:	0000f497          	auipc	s1,0xf
    8000200a:	fba48493          	addi	s1,s1,-70 # 80010fc0 <proc>
          if(p->state == RUNNABLE){
    8000200e:	4c0d                	li	s8,3
    80002010:	a821                	j	80002028 <scheduler+0xe6>
            if(min_acc_proc == 0) {min_acc_proc = p;}
    80002012:	89a6                	mv	s3,s1
    80002014:	a025                	j	8000203c <scheduler+0xfa>
          else {release(&p->lock);}
    80002016:	8526                	mv	a0,s1
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	c72080e7          	jalr	-910(ra) # 80000c8a <release>
        for(p = proc; p < &proc[NPROC]; p++){
    80002020:	1c048493          	addi	s1,s1,448
    80002024:	03248863          	beq	s1,s2,80002054 <scheduler+0x112>
          acquire(&p->lock);
    80002028:	8526                	mv	a0,s1
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	bac080e7          	jalr	-1108(ra) # 80000bd6 <acquire>
          if(p->state == RUNNABLE){
    80002032:	4c9c                	lw	a5,24(s1)
    80002034:	ff8791e3          	bne	a5,s8,80002016 <scheduler+0xd4>
            if(min_acc_proc == 0) {min_acc_proc = p;}
    80002038:	fc098de3          	beqz	s3,80002012 <scheduler+0xd0>
            if(min_acc_proc->accumulator > p->accumulator){
    8000203c:	0589b703          	ld	a4,88(s3)
    80002040:	6cbc                	ld	a5,88(s1)
    80002042:	fce7dfe3          	bge	a5,a4,80002020 <scheduler+0xde>
              release(&min_acc_proc->lock);
    80002046:	854e                	mv	a0,s3
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	c42080e7          	jalr	-958(ra) # 80000c8a <release>
    80002050:	89a6                	mv	s3,s1
    80002052:	b7f9                	j	80002020 <scheduler+0xde>
        if(min_acc_proc != 0){
    80002054:	08098b63          	beqz	s3,800020ea <scheduler+0x1a8>
          min_acc_proc->state = RUNNING;
    80002058:	0169ac23          	sw	s6,24(s3)
          c->proc = min_acc_proc;
    8000205c:	033a3823          	sd	s3,48(s4)
          swtch(&c->context, &min_acc_proc->context);
    80002060:	08898593          	addi	a1,s3,136
    80002064:	8556                	mv	a0,s5
    80002066:	00001097          	auipc	ra,0x1
    8000206a:	a5a080e7          	jalr	-1446(ra) # 80002ac0 <swtch>
          c->proc = 0;
    8000206e:	020a3823          	sd	zero,48(s4)
          release(&min_acc_proc->lock);
    80002072:	854e                	mv	a0,s3
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	c16080e7          	jalr	-1002(ra) # 80000c8a <release>
    8000207c:	a0bd                	j	800020ea <scheduler+0x1a8>
            if(min_vruntime_proc == 0) {min_vruntime_proc = p;}
    8000207e:	89a6                	mv	s3,s1
    80002080:	a025                	j	800020a8 <scheduler+0x166>
          else {release(&p->lock);}
    80002082:	8526                	mv	a0,s1
    80002084:	fffff097          	auipc	ra,0xfffff
    80002088:	c06080e7          	jalr	-1018(ra) # 80000c8a <release>
        for(p = proc; p < &proc[NPROC]; p++){
    8000208c:	1c048493          	addi	s1,s1,448
    80002090:	03248963          	beq	s1,s2,800020c2 <scheduler+0x180>
          acquire(&p->lock);
    80002094:	8526                	mv	a0,s1
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	b40080e7          	jalr	-1216(ra) # 80000bd6 <acquire>
          if(p->state == RUNNABLE){
    8000209e:	4c9c                	lw	a5,24(s1)
    800020a0:	ff8791e3          	bne	a5,s8,80002082 <scheduler+0x140>
            if(min_vruntime_proc == 0) {min_vruntime_proc = p;}
    800020a4:	fc098de3          	beqz	s3,8000207e <scheduler+0x13c>
            if(min_vruntime_proc->vruntime > p->vruntime){
    800020a8:	1b09b703          	ld	a4,432(s3)
    800020ac:	1b04b783          	ld	a5,432(s1)
    800020b0:	fce7dee3          	bge	a5,a4,8000208c <scheduler+0x14a>
              release(&min_vruntime_proc->lock);
    800020b4:	854e                	mv	a0,s3
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	bd4080e7          	jalr	-1068(ra) # 80000c8a <release>
    800020be:	89a6                	mv	s3,s1
    800020c0:	b7f1                	j	8000208c <scheduler+0x14a>
        if(min_vruntime_proc != 0){
    800020c2:	02098463          	beqz	s3,800020ea <scheduler+0x1a8>
          min_vruntime_proc->state = RUNNING;
    800020c6:	0169ac23          	sw	s6,24(s3)
          c->proc = min_vruntime_proc;
    800020ca:	033a3823          	sd	s3,48(s4)
          swtch(&c->context, &min_vruntime_proc->context);
    800020ce:	08898593          	addi	a1,s3,136
    800020d2:	8556                	mv	a0,s5
    800020d4:	00001097          	auipc	ra,0x1
    800020d8:	9ec080e7          	jalr	-1556(ra) # 80002ac0 <swtch>
          c->proc = 0;
    800020dc:	020a3823          	sd	zero,48(s4)
          release(&min_vruntime_proc->lock);
    800020e0:	854e                	mv	a0,s3
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	ba8080e7          	jalr	-1112(ra) # 80000c8a <release>
      if(sched_policy==0){//original       
    800020ea:	000ba783          	lw	a5,0(s7)
    800020ee:	ee0795e3          	bnez	a5,80001fd8 <scheduler+0x96>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020fa:	10079073          	csrw	sstatus,a5
        for(p = proc; p < &proc[NPROC]; p++) {
    800020fe:	0000f497          	auipc	s1,0xf
    80002102:	ec248493          	addi	s1,s1,-318 # 80010fc0 <proc>
          if(p->state == RUNNABLE) {
    80002106:	498d                	li	s3,3
    80002108:	b555                	j	80001fac <scheduler+0x6a>

000000008000210a <sched>:
{
    8000210a:	7179                	addi	sp,sp,-48
    8000210c:	f406                	sd	ra,40(sp)
    8000210e:	f022                	sd	s0,32(sp)
    80002110:	ec26                	sd	s1,24(sp)
    80002112:	e84a                	sd	s2,16(sp)
    80002114:	e44e                	sd	s3,8(sp)
    80002116:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	894080e7          	jalr	-1900(ra) # 800019ac <myproc>
    80002120:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	a3a080e7          	jalr	-1478(ra) # 80000b5c <holding>
    8000212a:	c93d                	beqz	a0,800021a0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000212c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000212e:	2781                	sext.w	a5,a5
    80002130:	079e                	slli	a5,a5,0x7
    80002132:	0000f717          	auipc	a4,0xf
    80002136:	a5e70713          	addi	a4,a4,-1442 # 80010b90 <pid_lock>
    8000213a:	97ba                	add	a5,a5,a4
    8000213c:	0a87a703          	lw	a4,168(a5)
    80002140:	4785                	li	a5,1
    80002142:	06f71763          	bne	a4,a5,800021b0 <sched+0xa6>
  if(p->state == RUNNING)
    80002146:	4c98                	lw	a4,24(s1)
    80002148:	4791                	li	a5,4
    8000214a:	06f70b63          	beq	a4,a5,800021c0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000214e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002152:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002154:	efb5                	bnez	a5,800021d0 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002156:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002158:	0000f917          	auipc	s2,0xf
    8000215c:	a3890913          	addi	s2,s2,-1480 # 80010b90 <pid_lock>
    80002160:	2781                	sext.w	a5,a5
    80002162:	079e                	slli	a5,a5,0x7
    80002164:	97ca                	add	a5,a5,s2
    80002166:	0ac7a983          	lw	s3,172(a5)
    8000216a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000216c:	2781                	sext.w	a5,a5
    8000216e:	079e                	slli	a5,a5,0x7
    80002170:	0000f597          	auipc	a1,0xf
    80002174:	a5858593          	addi	a1,a1,-1448 # 80010bc8 <cpus+0x8>
    80002178:	95be                	add	a1,a1,a5
    8000217a:	08848513          	addi	a0,s1,136
    8000217e:	00001097          	auipc	ra,0x1
    80002182:	942080e7          	jalr	-1726(ra) # 80002ac0 <swtch>
    80002186:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002188:	2781                	sext.w	a5,a5
    8000218a:	079e                	slli	a5,a5,0x7
    8000218c:	97ca                	add	a5,a5,s2
    8000218e:	0b37a623          	sw	s3,172(a5)
}
    80002192:	70a2                	ld	ra,40(sp)
    80002194:	7402                	ld	s0,32(sp)
    80002196:	64e2                	ld	s1,24(sp)
    80002198:	6942                	ld	s2,16(sp)
    8000219a:	69a2                	ld	s3,8(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret
    panic("sched p->lock");
    800021a0:	00006517          	auipc	a0,0x6
    800021a4:	07850513          	addi	a0,a0,120 # 80008218 <digits+0x1d8>
    800021a8:	ffffe097          	auipc	ra,0xffffe
    800021ac:	396080e7          	jalr	918(ra) # 8000053e <panic>
    panic("sched locks");
    800021b0:	00006517          	auipc	a0,0x6
    800021b4:	07850513          	addi	a0,a0,120 # 80008228 <digits+0x1e8>
    800021b8:	ffffe097          	auipc	ra,0xffffe
    800021bc:	386080e7          	jalr	902(ra) # 8000053e <panic>
    panic("sched running");
    800021c0:	00006517          	auipc	a0,0x6
    800021c4:	07850513          	addi	a0,a0,120 # 80008238 <digits+0x1f8>
    800021c8:	ffffe097          	auipc	ra,0xffffe
    800021cc:	376080e7          	jalr	886(ra) # 8000053e <panic>
    panic("sched interruptible");
    800021d0:	00006517          	auipc	a0,0x6
    800021d4:	07850513          	addi	a0,a0,120 # 80008248 <digits+0x208>
    800021d8:	ffffe097          	auipc	ra,0xffffe
    800021dc:	366080e7          	jalr	870(ra) # 8000053e <panic>

00000000800021e0 <yield>:
{
    800021e0:	1101                	addi	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	e426                	sd	s1,8(sp)
    800021e8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	7c2080e7          	jalr	1986(ra) # 800019ac <myproc>
    800021f2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021f4:	fffff097          	auipc	ra,0xfffff
    800021f8:	9e2080e7          	jalr	-1566(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    800021fc:	478d                	li	a5,3
    800021fe:	cc9c                	sw	a5,24(s1)
  sched();
    80002200:	00000097          	auipc	ra,0x0
    80002204:	f0a080e7          	jalr	-246(ra) # 8000210a <sched>
  release(&p->lock);
    80002208:	8526                	mv	a0,s1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	a80080e7          	jalr	-1408(ra) # 80000c8a <release>
}
    80002212:	60e2                	ld	ra,24(sp)
    80002214:	6442                	ld	s0,16(sp)
    80002216:	64a2                	ld	s1,8(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000221c:	7179                	addi	sp,sp,-48
    8000221e:	f406                	sd	ra,40(sp)
    80002220:	f022                	sd	s0,32(sp)
    80002222:	ec26                	sd	s1,24(sp)
    80002224:	e84a                	sd	s2,16(sp)
    80002226:	e44e                	sd	s3,8(sp)
    80002228:	1800                	addi	s0,sp,48
    8000222a:	89aa                	mv	s3,a0
    8000222c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	77e080e7          	jalr	1918(ra) # 800019ac <myproc>
    80002236:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	99e080e7          	jalr	-1634(ra) # 80000bd6 <acquire>
  release(lk);
    80002240:	854a                	mv	a0,s2
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	a48080e7          	jalr	-1464(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    8000224a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000224e:	4789                	li	a5,2
    80002250:	cc9c                	sw	a5,24(s1)

  sched();
    80002252:	00000097          	auipc	ra,0x0
    80002256:	eb8080e7          	jalr	-328(ra) # 8000210a <sched>

  // Tidy up.
  p->chan = 0;
    8000225a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000225e:	8526                	mv	a0,s1
    80002260:	fffff097          	auipc	ra,0xfffff
    80002264:	a2a080e7          	jalr	-1494(ra) # 80000c8a <release>
  acquire(lk);
    80002268:	854a                	mv	a0,s2
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	96c080e7          	jalr	-1684(ra) # 80000bd6 <acquire>
}
    80002272:	70a2                	ld	ra,40(sp)
    80002274:	7402                	ld	s0,32(sp)
    80002276:	64e2                	ld	s1,24(sp)
    80002278:	6942                	ld	s2,16(sp)
    8000227a:	69a2                	ld	s3,8(sp)
    8000227c:	6145                	addi	sp,sp,48
    8000227e:	8082                	ret

0000000080002280 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002280:	711d                	addi	sp,sp,-96
    80002282:	ec86                	sd	ra,88(sp)
    80002284:	e8a2                	sd	s0,80(sp)
    80002286:	e4a6                	sd	s1,72(sp)
    80002288:	e0ca                	sd	s2,64(sp)
    8000228a:	fc4e                	sd	s3,56(sp)
    8000228c:	f852                	sd	s4,48(sp)
    8000228e:	f456                	sd	s5,40(sp)
    80002290:	f05a                	sd	s6,32(sp)
    80002292:	ec5e                	sd	s7,24(sp)
    80002294:	e862                	sd	s8,16(sp)
    80002296:	e466                	sd	s9,8(sp)
    80002298:	e06a                	sd	s10,0(sp)
    8000229a:	1080                	addi	s0,sp,96
    8000229c:	8baa                	mv	s7,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000229e:	0000f917          	auipc	s2,0xf
    800022a2:	d2290913          	addi	s2,s2,-734 # 80010fc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800022a6:	4b09                	li	s6,2


            struct proc *other_p;
            long long min=LLONG_MAX;
    800022a8:	5c7d                	li	s8,-1
    800022aa:	001c5c13          	srli	s8,s8,0x1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
                if(other_p != p){
                  acquire(&other_p->lock);
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    800022ae:	4a05                	li	s4,1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800022b0:	00016997          	auipc	s3,0x16
    800022b4:	d1098993          	addi	s3,s3,-752 # 80017fc0 <tickslock>
          
      



        p->state = RUNNABLE;
    800022b8:	4c8d                	li	s9,3
            p->accumulator=0;
    800022ba:	4d01                	li	s10,0
    800022bc:	a889                	j	8000230e <wakeup+0x8e>
                release(&other_p->lock);
    800022be:	8526                	mv	a0,s1
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	9ca080e7          	jalr	-1590(ra) # 80000c8a <release>
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800022c8:	1c048493          	addi	s1,s1,448
    800022cc:	03348263          	beq	s1,s3,800022f0 <wakeup+0x70>
                if(other_p != p){
    800022d0:	fe990ce3          	beq	s2,s1,800022c8 <wakeup+0x48>
                  acquire(&other_p->lock);
    800022d4:	8526                	mv	a0,s1
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	900080e7          	jalr	-1792(ra) # 80000bd6 <acquire>
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    800022de:	4c9c                	lw	a5,24(s1)
    800022e0:	37f5                	addiw	a5,a5,-3
    800022e2:	fcfa6ee3          	bltu	s4,a5,800022be <wakeup+0x3e>
                      if(min>other_p->accumulator)
    800022e6:	6cbc                	ld	a5,88(s1)
    800022e8:	fd57dbe3          	bge	a5,s5,800022be <wakeup+0x3e>
    800022ec:	8abe                	mv	s5,a5
    800022ee:	bfc1                	j	800022be <wakeup+0x3e>
          if(min==LLONG_MAX){
    800022f0:	058a8863          	beq	s5,s8,80002340 <wakeup+0xc0>
    800022f4:	05593c23          	sd	s5,88(s2)
        p->state = RUNNABLE;
    800022f8:	01992c23          	sw	s9,24(s2)
      }
      release(&p->lock);
    800022fc:	854a                	mv	a0,s2
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	98c080e7          	jalr	-1652(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002306:	1c090913          	addi	s2,s2,448
    8000230a:	03390d63          	beq	s2,s3,80002344 <wakeup+0xc4>
    if(p != myproc()){
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	69e080e7          	jalr	1694(ra) # 800019ac <myproc>
    80002316:	fea908e3          	beq	s2,a0,80002306 <wakeup+0x86>
      acquire(&p->lock);
    8000231a:	854a                	mv	a0,s2
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	8ba080e7          	jalr	-1862(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002324:	01892783          	lw	a5,24(s2)
    80002328:	fd679ae3          	bne	a5,s6,800022fc <wakeup+0x7c>
    8000232c:	02093783          	ld	a5,32(s2)
    80002330:	fd7796e3          	bne	a5,s7,800022fc <wakeup+0x7c>
            long long min=LLONG_MAX;
    80002334:	8ae2                	mv	s5,s8
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80002336:	0000f497          	auipc	s1,0xf
    8000233a:	c8a48493          	addi	s1,s1,-886 # 80010fc0 <proc>
    8000233e:	bf49                	j	800022d0 <wakeup+0x50>
            p->accumulator=0;
    80002340:	8aea                	mv	s5,s10
    80002342:	bf4d                	j	800022f4 <wakeup+0x74>
    }
  }
}
    80002344:	60e6                	ld	ra,88(sp)
    80002346:	6446                	ld	s0,80(sp)
    80002348:	64a6                	ld	s1,72(sp)
    8000234a:	6906                	ld	s2,64(sp)
    8000234c:	79e2                	ld	s3,56(sp)
    8000234e:	7a42                	ld	s4,48(sp)
    80002350:	7aa2                	ld	s5,40(sp)
    80002352:	7b02                	ld	s6,32(sp)
    80002354:	6be2                	ld	s7,24(sp)
    80002356:	6c42                	ld	s8,16(sp)
    80002358:	6ca2                	ld	s9,8(sp)
    8000235a:	6d02                	ld	s10,0(sp)
    8000235c:	6125                	addi	sp,sp,96
    8000235e:	8082                	ret

0000000080002360 <reparent>:
{
    80002360:	7179                	addi	sp,sp,-48
    80002362:	f406                	sd	ra,40(sp)
    80002364:	f022                	sd	s0,32(sp)
    80002366:	ec26                	sd	s1,24(sp)
    80002368:	e84a                	sd	s2,16(sp)
    8000236a:	e44e                	sd	s3,8(sp)
    8000236c:	e052                	sd	s4,0(sp)
    8000236e:	1800                	addi	s0,sp,48
    80002370:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002372:	0000f497          	auipc	s1,0xf
    80002376:	c4e48493          	addi	s1,s1,-946 # 80010fc0 <proc>
      pp->parent = initproc;
    8000237a:	00006a17          	auipc	s4,0x6
    8000237e:	5a6a0a13          	addi	s4,s4,1446 # 80008920 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002382:	00016997          	auipc	s3,0x16
    80002386:	c3e98993          	addi	s3,s3,-962 # 80017fc0 <tickslock>
    8000238a:	a029                	j	80002394 <reparent+0x34>
    8000238c:	1c048493          	addi	s1,s1,448
    80002390:	01348d63          	beq	s1,s3,800023aa <reparent+0x4a>
    if(pp->parent == p){
    80002394:	70bc                	ld	a5,96(s1)
    80002396:	ff279be3          	bne	a5,s2,8000238c <reparent+0x2c>
      pp->parent = initproc;
    8000239a:	000a3503          	ld	a0,0(s4)
    8000239e:	f0a8                	sd	a0,96(s1)
      wakeup(initproc);
    800023a0:	00000097          	auipc	ra,0x0
    800023a4:	ee0080e7          	jalr	-288(ra) # 80002280 <wakeup>
    800023a8:	b7d5                	j	8000238c <reparent+0x2c>
}
    800023aa:	70a2                	ld	ra,40(sp)
    800023ac:	7402                	ld	s0,32(sp)
    800023ae:	64e2                	ld	s1,24(sp)
    800023b0:	6942                	ld	s2,16(sp)
    800023b2:	69a2                	ld	s3,8(sp)
    800023b4:	6a02                	ld	s4,0(sp)
    800023b6:	6145                	addi	sp,sp,48
    800023b8:	8082                	ret

00000000800023ba <exit>:
{
    800023ba:	7139                	addi	sp,sp,-64
    800023bc:	fc06                	sd	ra,56(sp)
    800023be:	f822                	sd	s0,48(sp)
    800023c0:	f426                	sd	s1,40(sp)
    800023c2:	f04a                	sd	s2,32(sp)
    800023c4:	ec4e                	sd	s3,24(sp)
    800023c6:	e852                	sd	s4,16(sp)
    800023c8:	e456                	sd	s5,8(sp)
    800023ca:	0080                	addi	s0,sp,64
    800023cc:	8aaa                	mv	s5,a0
    800023ce:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800023d0:	fffff097          	auipc	ra,0xfffff
    800023d4:	5dc080e7          	jalr	1500(ra) # 800019ac <myproc>
    800023d8:	89aa                	mv	s3,a0
  if(p == initproc)
    800023da:	00006797          	auipc	a5,0x6
    800023de:	5467b783          	ld	a5,1350(a5) # 80008920 <initproc>
    800023e2:	0f850493          	addi	s1,a0,248
    800023e6:	17850913          	addi	s2,a0,376
    800023ea:	02a79363          	bne	a5,a0,80002410 <exit+0x56>
    panic("init exiting");
    800023ee:	00006517          	auipc	a0,0x6
    800023f2:	e7250513          	addi	a0,a0,-398 # 80008260 <digits+0x220>
    800023f6:	ffffe097          	auipc	ra,0xffffe
    800023fa:	148080e7          	jalr	328(ra) # 8000053e <panic>
      fileclose(f);
    800023fe:	00002097          	auipc	ra,0x2
    80002402:	716080e7          	jalr	1814(ra) # 80004b14 <fileclose>
      p->ofile[fd] = 0;
    80002406:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000240a:	04a1                	addi	s1,s1,8
    8000240c:	01248563          	beq	s1,s2,80002416 <exit+0x5c>
    if(p->ofile[fd]){
    80002410:	6088                	ld	a0,0(s1)
    80002412:	f575                	bnez	a0,800023fe <exit+0x44>
    80002414:	bfdd                	j	8000240a <exit+0x50>
  begin_op();
    80002416:	00002097          	auipc	ra,0x2
    8000241a:	232080e7          	jalr	562(ra) # 80004648 <begin_op>
  iput(p->cwd);
    8000241e:	1789b503          	ld	a0,376(s3)
    80002422:	00002097          	auipc	ra,0x2
    80002426:	a1e080e7          	jalr	-1506(ra) # 80003e40 <iput>
  end_op();
    8000242a:	00002097          	auipc	ra,0x2
    8000242e:	29e080e7          	jalr	670(ra) # 800046c8 <end_op>
  p->cwd = 0;
    80002432:	1609bc23          	sd	zero,376(s3)
  acquire(&wait_lock);
    80002436:	0000e497          	auipc	s1,0xe
    8000243a:	77248493          	addi	s1,s1,1906 # 80010ba8 <wait_lock>
    8000243e:	8526                	mv	a0,s1
    80002440:	ffffe097          	auipc	ra,0xffffe
    80002444:	796080e7          	jalr	1942(ra) # 80000bd6 <acquire>
  reparent(p);
    80002448:	854e                	mv	a0,s3
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	f16080e7          	jalr	-234(ra) # 80002360 <reparent>
  wakeup(p->parent);
    80002452:	0609b503          	ld	a0,96(s3)
    80002456:	00000097          	auipc	ra,0x0
    8000245a:	e2a080e7          	jalr	-470(ra) # 80002280 <wakeup>
  acquire(&p->lock);
    8000245e:	854e                	mv	a0,s3
    80002460:	ffffe097          	auipc	ra,0xffffe
    80002464:	776080e7          	jalr	1910(ra) # 80000bd6 <acquire>
  p->xstate = status;
    80002468:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, sizeof(p->exit_msg));
    8000246c:	02000613          	li	a2,32
    80002470:	85d2                	mv	a1,s4
    80002472:	03498513          	addi	a0,s3,52
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	9a6080e7          	jalr	-1626(ra) # 80000e1c <safestrcpy>
  p->state = ZOMBIE;
    8000247e:	4795                	li	a5,5
    80002480:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002484:	8526                	mv	a0,s1
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	804080e7          	jalr	-2044(ra) # 80000c8a <release>
  sched();
    8000248e:	00000097          	auipc	ra,0x0
    80002492:	c7c080e7          	jalr	-900(ra) # 8000210a <sched>
  panic("zombie exit");
    80002496:	00006517          	auipc	a0,0x6
    8000249a:	dda50513          	addi	a0,a0,-550 # 80008270 <digits+0x230>
    8000249e:	ffffe097          	auipc	ra,0xffffe
    800024a2:	0a0080e7          	jalr	160(ra) # 8000053e <panic>

00000000800024a6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024a6:	7179                	addi	sp,sp,-48
    800024a8:	f406                	sd	ra,40(sp)
    800024aa:	f022                	sd	s0,32(sp)
    800024ac:	ec26                	sd	s1,24(sp)
    800024ae:	e84a                	sd	s2,16(sp)
    800024b0:	e44e                	sd	s3,8(sp)
    800024b2:	1800                	addi	s0,sp,48
    800024b4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024b6:	0000f497          	auipc	s1,0xf
    800024ba:	b0a48493          	addi	s1,s1,-1270 # 80010fc0 <proc>
    800024be:	00016997          	auipc	s3,0x16
    800024c2:	b0298993          	addi	s3,s3,-1278 # 80017fc0 <tickslock>
    acquire(&p->lock);
    800024c6:	8526                	mv	a0,s1
    800024c8:	ffffe097          	auipc	ra,0xffffe
    800024cc:	70e080e7          	jalr	1806(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800024d0:	589c                	lw	a5,48(s1)
    800024d2:	01278d63          	beq	a5,s2,800024ec <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800024d6:	8526                	mv	a0,s1
    800024d8:	ffffe097          	auipc	ra,0xffffe
    800024dc:	7b2080e7          	jalr	1970(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800024e0:	1c048493          	addi	s1,s1,448
    800024e4:	ff3491e3          	bne	s1,s3,800024c6 <kill+0x20>
  }
  return -1;
    800024e8:	557d                	li	a0,-1
    800024ea:	a829                	j	80002504 <kill+0x5e>
      p->killed = 1;
    800024ec:	4785                	li	a5,1
    800024ee:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800024f0:	4c98                	lw	a4,24(s1)
    800024f2:	4789                	li	a5,2
    800024f4:	00f70f63          	beq	a4,a5,80002512 <kill+0x6c>
      release(&p->lock);
    800024f8:	8526                	mv	a0,s1
    800024fa:	ffffe097          	auipc	ra,0xffffe
    800024fe:	790080e7          	jalr	1936(ra) # 80000c8a <release>
      return 0;
    80002502:	4501                	li	a0,0
}
    80002504:	70a2                	ld	ra,40(sp)
    80002506:	7402                	ld	s0,32(sp)
    80002508:	64e2                	ld	s1,24(sp)
    8000250a:	6942                	ld	s2,16(sp)
    8000250c:	69a2                	ld	s3,8(sp)
    8000250e:	6145                	addi	sp,sp,48
    80002510:	8082                	ret
        p->state = RUNNABLE;
    80002512:	478d                	li	a5,3
    80002514:	cc9c                	sw	a5,24(s1)
    80002516:	b7cd                	j	800024f8 <kill+0x52>

0000000080002518 <setkilled>:

void
setkilled(struct proc *p)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	1000                	addi	s0,sp,32
    80002522:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002524:	ffffe097          	auipc	ra,0xffffe
    80002528:	6b2080e7          	jalr	1714(ra) # 80000bd6 <acquire>
  p->killed = 1;
    8000252c:	4785                	li	a5,1
    8000252e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002530:	8526                	mv	a0,s1
    80002532:	ffffe097          	auipc	ra,0xffffe
    80002536:	758080e7          	jalr	1880(ra) # 80000c8a <release>
}
    8000253a:	60e2                	ld	ra,24(sp)
    8000253c:	6442                	ld	s0,16(sp)
    8000253e:	64a2                	ld	s1,8(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret

0000000080002544 <killed>:

int
killed(struct proc *p)
{
    80002544:	1101                	addi	sp,sp,-32
    80002546:	ec06                	sd	ra,24(sp)
    80002548:	e822                	sd	s0,16(sp)
    8000254a:	e426                	sd	s1,8(sp)
    8000254c:	e04a                	sd	s2,0(sp)
    8000254e:	1000                	addi	s0,sp,32
    80002550:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002552:	ffffe097          	auipc	ra,0xffffe
    80002556:	684080e7          	jalr	1668(ra) # 80000bd6 <acquire>
  k = p->killed;
    8000255a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000255e:	8526                	mv	a0,s1
    80002560:	ffffe097          	auipc	ra,0xffffe
    80002564:	72a080e7          	jalr	1834(ra) # 80000c8a <release>
  return k;
}
    80002568:	854a                	mv	a0,s2
    8000256a:	60e2                	ld	ra,24(sp)
    8000256c:	6442                	ld	s0,16(sp)
    8000256e:	64a2                	ld	s1,8(sp)
    80002570:	6902                	ld	s2,0(sp)
    80002572:	6105                	addi	sp,sp,32
    80002574:	8082                	ret

0000000080002576 <wait>:
{
    80002576:	711d                	addi	sp,sp,-96
    80002578:	ec86                	sd	ra,88(sp)
    8000257a:	e8a2                	sd	s0,80(sp)
    8000257c:	e4a6                	sd	s1,72(sp)
    8000257e:	e0ca                	sd	s2,64(sp)
    80002580:	fc4e                	sd	s3,56(sp)
    80002582:	f852                	sd	s4,48(sp)
    80002584:	f456                	sd	s5,40(sp)
    80002586:	f05a                	sd	s6,32(sp)
    80002588:	ec5e                	sd	s7,24(sp)
    8000258a:	e862                	sd	s8,16(sp)
    8000258c:	e466                	sd	s9,8(sp)
    8000258e:	1080                	addi	s0,sp,96
    80002590:	8baa                	mv	s7,a0
    80002592:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002594:	fffff097          	auipc	ra,0xfffff
    80002598:	418080e7          	jalr	1048(ra) # 800019ac <myproc>
    8000259c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000259e:	0000e517          	auipc	a0,0xe
    800025a2:	60a50513          	addi	a0,a0,1546 # 80010ba8 <wait_lock>
    800025a6:	ffffe097          	auipc	ra,0xffffe
    800025aa:	630080e7          	jalr	1584(ra) # 80000bd6 <acquire>
    havekids = 0;
    800025ae:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800025b0:	4a15                	li	s4,5
        havekids = 1;
    800025b2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025b4:	00016997          	auipc	s3,0x16
    800025b8:	a0c98993          	addi	s3,s3,-1524 # 80017fc0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025bc:	0000ec97          	auipc	s9,0xe
    800025c0:	5ecc8c93          	addi	s9,s9,1516 # 80010ba8 <wait_lock>
    havekids = 0;
    800025c4:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800025c6:	0000f497          	auipc	s1,0xf
    800025ca:	9fa48493          	addi	s1,s1,-1542 # 80010fc0 <proc>
    800025ce:	a06d                	j	80002678 <wait+0x102>
          pid = pp->pid;
    800025d0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800025d4:	040b9463          	bnez	s7,8000261c <wait+0xa6>
          if(addr_exitmsg != 0 && copyout(p->pagetable, addr_exitmsg, (char *)&pp->exit_msg,
    800025d8:	000b0f63          	beqz	s6,800025f6 <wait+0x80>
    800025dc:	02000693          	li	a3,32
    800025e0:	03448613          	addi	a2,s1,52
    800025e4:	85da                	mv	a1,s6
    800025e6:	07893503          	ld	a0,120(s2)
    800025ea:	fffff097          	auipc	ra,0xfffff
    800025ee:	07e080e7          	jalr	126(ra) # 80001668 <copyout>
    800025f2:	06054063          	bltz	a0,80002652 <wait+0xdc>
          freeproc(pp);
    800025f6:	8526                	mv	a0,s1
    800025f8:	fffff097          	auipc	ra,0xfffff
    800025fc:	566080e7          	jalr	1382(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    80002600:	8526                	mv	a0,s1
    80002602:	ffffe097          	auipc	ra,0xffffe
    80002606:	688080e7          	jalr	1672(ra) # 80000c8a <release>
          release(&wait_lock);
    8000260a:	0000e517          	auipc	a0,0xe
    8000260e:	59e50513          	addi	a0,a0,1438 # 80010ba8 <wait_lock>
    80002612:	ffffe097          	auipc	ra,0xffffe
    80002616:	678080e7          	jalr	1656(ra) # 80000c8a <release>
          return pid;
    8000261a:	a04d                	j	800026bc <wait+0x146>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000261c:	4691                	li	a3,4
    8000261e:	02c48613          	addi	a2,s1,44
    80002622:	85de                	mv	a1,s7
    80002624:	07893503          	ld	a0,120(s2)
    80002628:	fffff097          	auipc	ra,0xfffff
    8000262c:	040080e7          	jalr	64(ra) # 80001668 <copyout>
    80002630:	fa0554e3          	bgez	a0,800025d8 <wait+0x62>
            release(&pp->lock);
    80002634:	8526                	mv	a0,s1
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	654080e7          	jalr	1620(ra) # 80000c8a <release>
            release(&wait_lock);
    8000263e:	0000e517          	auipc	a0,0xe
    80002642:	56a50513          	addi	a0,a0,1386 # 80010ba8 <wait_lock>
    80002646:	ffffe097          	auipc	ra,0xffffe
    8000264a:	644080e7          	jalr	1604(ra) # 80000c8a <release>
            return -1;
    8000264e:	59fd                	li	s3,-1
    80002650:	a0b5                	j	800026bc <wait+0x146>
            release(&pp->lock);
    80002652:	8526                	mv	a0,s1
    80002654:	ffffe097          	auipc	ra,0xffffe
    80002658:	636080e7          	jalr	1590(ra) # 80000c8a <release>
            release(&wait_lock);
    8000265c:	0000e517          	auipc	a0,0xe
    80002660:	54c50513          	addi	a0,a0,1356 # 80010ba8 <wait_lock>
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	626080e7          	jalr	1574(ra) # 80000c8a <release>
            return -1;
    8000266c:	59fd                	li	s3,-1
    8000266e:	a0b9                	j	800026bc <wait+0x146>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002670:	1c048493          	addi	s1,s1,448
    80002674:	03348463          	beq	s1,s3,8000269c <wait+0x126>
      if(pp->parent == p){
    80002678:	70bc                	ld	a5,96(s1)
    8000267a:	ff279be3          	bne	a5,s2,80002670 <wait+0xfa>
        acquire(&pp->lock);
    8000267e:	8526                	mv	a0,s1
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	556080e7          	jalr	1366(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    80002688:	4c9c                	lw	a5,24(s1)
    8000268a:	f54783e3          	beq	a5,s4,800025d0 <wait+0x5a>
        release(&pp->lock);
    8000268e:	8526                	mv	a0,s1
    80002690:	ffffe097          	auipc	ra,0xffffe
    80002694:	5fa080e7          	jalr	1530(ra) # 80000c8a <release>
        havekids = 1;
    80002698:	8756                	mv	a4,s5
    8000269a:	bfd9                	j	80002670 <wait+0xfa>
    if(!havekids || killed(p)){
    8000269c:	c719                	beqz	a4,800026aa <wait+0x134>
    8000269e:	854a                	mv	a0,s2
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	ea4080e7          	jalr	-348(ra) # 80002544 <killed>
    800026a8:	c905                	beqz	a0,800026d8 <wait+0x162>
      release(&wait_lock);
    800026aa:	0000e517          	auipc	a0,0xe
    800026ae:	4fe50513          	addi	a0,a0,1278 # 80010ba8 <wait_lock>
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	5d8080e7          	jalr	1496(ra) # 80000c8a <release>
      return -1;
    800026ba:	59fd                	li	s3,-1
}
    800026bc:	854e                	mv	a0,s3
    800026be:	60e6                	ld	ra,88(sp)
    800026c0:	6446                	ld	s0,80(sp)
    800026c2:	64a6                	ld	s1,72(sp)
    800026c4:	6906                	ld	s2,64(sp)
    800026c6:	79e2                	ld	s3,56(sp)
    800026c8:	7a42                	ld	s4,48(sp)
    800026ca:	7aa2                	ld	s5,40(sp)
    800026cc:	7b02                	ld	s6,32(sp)
    800026ce:	6be2                	ld	s7,24(sp)
    800026d0:	6c42                	ld	s8,16(sp)
    800026d2:	6ca2                	ld	s9,8(sp)
    800026d4:	6125                	addi	sp,sp,96
    800026d6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800026d8:	85e6                	mv	a1,s9
    800026da:	854a                	mv	a0,s2
    800026dc:	00000097          	auipc	ra,0x0
    800026e0:	b40080e7          	jalr	-1216(ra) # 8000221c <sleep>
    havekids = 0;
    800026e4:	b5c5                	j	800025c4 <wait+0x4e>

00000000800026e6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800026e6:	7179                	addi	sp,sp,-48
    800026e8:	f406                	sd	ra,40(sp)
    800026ea:	f022                	sd	s0,32(sp)
    800026ec:	ec26                	sd	s1,24(sp)
    800026ee:	e84a                	sd	s2,16(sp)
    800026f0:	e44e                	sd	s3,8(sp)
    800026f2:	e052                	sd	s4,0(sp)
    800026f4:	1800                	addi	s0,sp,48
    800026f6:	84aa                	mv	s1,a0
    800026f8:	892e                	mv	s2,a1
    800026fa:	89b2                	mv	s3,a2
    800026fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800026fe:	fffff097          	auipc	ra,0xfffff
    80002702:	2ae080e7          	jalr	686(ra) # 800019ac <myproc>
  if(user_dst){
    80002706:	c08d                	beqz	s1,80002728 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002708:	86d2                	mv	a3,s4
    8000270a:	864e                	mv	a2,s3
    8000270c:	85ca                	mv	a1,s2
    8000270e:	7d28                	ld	a0,120(a0)
    80002710:	fffff097          	auipc	ra,0xfffff
    80002714:	f58080e7          	jalr	-168(ra) # 80001668 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6a02                	ld	s4,0(sp)
    80002724:	6145                	addi	sp,sp,48
    80002726:	8082                	ret
    memmove((char *)dst, src, len);
    80002728:	000a061b          	sext.w	a2,s4
    8000272c:	85ce                	mv	a1,s3
    8000272e:	854a                	mv	a0,s2
    80002730:	ffffe097          	auipc	ra,0xffffe
    80002734:	5fe080e7          	jalr	1534(ra) # 80000d2e <memmove>
    return 0;
    80002738:	8526                	mv	a0,s1
    8000273a:	bff9                	j	80002718 <either_copyout+0x32>

000000008000273c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000273c:	7179                	addi	sp,sp,-48
    8000273e:	f406                	sd	ra,40(sp)
    80002740:	f022                	sd	s0,32(sp)
    80002742:	ec26                	sd	s1,24(sp)
    80002744:	e84a                	sd	s2,16(sp)
    80002746:	e44e                	sd	s3,8(sp)
    80002748:	e052                	sd	s4,0(sp)
    8000274a:	1800                	addi	s0,sp,48
    8000274c:	892a                	mv	s2,a0
    8000274e:	84ae                	mv	s1,a1
    80002750:	89b2                	mv	s3,a2
    80002752:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002754:	fffff097          	auipc	ra,0xfffff
    80002758:	258080e7          	jalr	600(ra) # 800019ac <myproc>
  if(user_src){
    8000275c:	c08d                	beqz	s1,8000277e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000275e:	86d2                	mv	a3,s4
    80002760:	864e                	mv	a2,s3
    80002762:	85ca                	mv	a1,s2
    80002764:	7d28                	ld	a0,120(a0)
    80002766:	fffff097          	auipc	ra,0xfffff
    8000276a:	f8e080e7          	jalr	-114(ra) # 800016f4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000276e:	70a2                	ld	ra,40(sp)
    80002770:	7402                	ld	s0,32(sp)
    80002772:	64e2                	ld	s1,24(sp)
    80002774:	6942                	ld	s2,16(sp)
    80002776:	69a2                	ld	s3,8(sp)
    80002778:	6a02                	ld	s4,0(sp)
    8000277a:	6145                	addi	sp,sp,48
    8000277c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000277e:	000a061b          	sext.w	a2,s4
    80002782:	85ce                	mv	a1,s3
    80002784:	854a                	mv	a0,s2
    80002786:	ffffe097          	auipc	ra,0xffffe
    8000278a:	5a8080e7          	jalr	1448(ra) # 80000d2e <memmove>
    return 0;
    8000278e:	8526                	mv	a0,s1
    80002790:	bff9                	j	8000276e <either_copyin+0x32>

0000000080002792 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002792:	715d                	addi	sp,sp,-80
    80002794:	e486                	sd	ra,72(sp)
    80002796:	e0a2                	sd	s0,64(sp)
    80002798:	fc26                	sd	s1,56(sp)
    8000279a:	f84a                	sd	s2,48(sp)
    8000279c:	f44e                	sd	s3,40(sp)
    8000279e:	f052                	sd	s4,32(sp)
    800027a0:	ec56                	sd	s5,24(sp)
    800027a2:	e85a                	sd	s6,16(sp)
    800027a4:	e45e                	sd	s7,8(sp)
    800027a6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800027a8:	00006517          	auipc	a0,0x6
    800027ac:	92050513          	addi	a0,a0,-1760 # 800080c8 <digits+0x88>
    800027b0:	ffffe097          	auipc	ra,0xffffe
    800027b4:	dd8080e7          	jalr	-552(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800027b8:	0000f497          	auipc	s1,0xf
    800027bc:	98848493          	addi	s1,s1,-1656 # 80011140 <proc+0x180>
    800027c0:	00016917          	auipc	s2,0x16
    800027c4:	98090913          	addi	s2,s2,-1664 # 80018140 <bcache+0x168>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800027ca:	00006997          	auipc	s3,0x6
    800027ce:	ab698993          	addi	s3,s3,-1354 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800027d2:	00006a97          	auipc	s5,0x6
    800027d6:	ab6a8a93          	addi	s5,s5,-1354 # 80008288 <digits+0x248>
    printf("\n");
    800027da:	00006a17          	auipc	s4,0x6
    800027de:	8eea0a13          	addi	s4,s4,-1810 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800027e2:	00006b97          	auipc	s7,0x6
    800027e6:	ae6b8b93          	addi	s7,s7,-1306 # 800082c8 <states.0>
    800027ea:	a00d                	j	8000280c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800027ec:	eb06a583          	lw	a1,-336(a3)
    800027f0:	8556                	mv	a0,s5
    800027f2:	ffffe097          	auipc	ra,0xffffe
    800027f6:	d96080e7          	jalr	-618(ra) # 80000588 <printf>
    printf("\n");
    800027fa:	8552                	mv	a0,s4
    800027fc:	ffffe097          	auipc	ra,0xffffe
    80002800:	d8c080e7          	jalr	-628(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002804:	1c048493          	addi	s1,s1,448
    80002808:	03248163          	beq	s1,s2,8000282a <procdump+0x98>
    if(p->state == UNUSED)
    8000280c:	86a6                	mv	a3,s1
    8000280e:	e984a783          	lw	a5,-360(s1)
    80002812:	dbed                	beqz	a5,80002804 <procdump+0x72>
      state = "???";
    80002814:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002816:	fcfb6be3          	bltu	s6,a5,800027ec <procdump+0x5a>
    8000281a:	1782                	slli	a5,a5,0x20
    8000281c:	9381                	srli	a5,a5,0x20
    8000281e:	078e                	slli	a5,a5,0x3
    80002820:	97de                	add	a5,a5,s7
    80002822:	6390                	ld	a2,0(a5)
    80002824:	f661                	bnez	a2,800027ec <procdump+0x5a>
      state = "???";
    80002826:	864e                	mv	a2,s3
    80002828:	b7d1                	j	800027ec <procdump+0x5a>
  }
}
    8000282a:	60a6                	ld	ra,72(sp)
    8000282c:	6406                	ld	s0,64(sp)
    8000282e:	74e2                	ld	s1,56(sp)
    80002830:	7942                	ld	s2,48(sp)
    80002832:	79a2                	ld	s3,40(sp)
    80002834:	7a02                	ld	s4,32(sp)
    80002836:	6ae2                	ld	s5,24(sp)
    80002838:	6b42                	ld	s6,16(sp)
    8000283a:	6ba2                	ld	s7,8(sp)
    8000283c:	6161                	addi	sp,sp,80
    8000283e:	8082                	ret

0000000080002840 <set_ps_priority>:


int
set_ps_priority(int new_ps)
{
    80002840:	1101                	addi	sp,sp,-32
    80002842:	ec06                	sd	ra,24(sp)
    80002844:	e822                	sd	s0,16(sp)
    80002846:	e426                	sd	s1,8(sp)
    80002848:	1000                	addi	s0,sp,32
    8000284a:	84aa                	mv	s1,a0
  struct proc *p = myproc(); 
    8000284c:	fffff097          	auipc	ra,0xfffff
    80002850:	160080e7          	jalr	352(ra) # 800019ac <myproc>
  p->ps_priority = new_ps;
    80002854:	18952823          	sw	s1,400(a0)
   
  return 0;
}
    80002858:	4501                	li	a0,0
    8000285a:	60e2                	ld	ra,24(sp)
    8000285c:	6442                	ld	s0,16(sp)
    8000285e:	64a2                	ld	s1,8(sp)
    80002860:	6105                	addi	sp,sp,32
    80002862:	8082                	ret

0000000080002864 <set_cfs_priority>:

// task6
int
set_cfs_priority(int new_cfs)
{
    80002864:	1101                	addi	sp,sp,-32
    80002866:	ec06                	sd	ra,24(sp)
    80002868:	e822                	sd	s0,16(sp)
    8000286a:	e426                	sd	s1,8(sp)
    8000286c:	1000                	addi	s0,sp,32
    8000286e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002870:	fffff097          	auipc	ra,0xfffff
    80002874:	13c080e7          	jalr	316(ra) # 800019ac <myproc>
  //acquire(&p->lock);
  if(new_cfs==0){
    80002878:	c08d                	beqz	s1,8000289a <set_cfs_priority+0x36>
    p->cfs_priority=75;
    return 0;
  }

  if(new_cfs==1){
    8000287a:	4785                	li	a5,1
    8000287c:	02f48563          	beq	s1,a5,800028a6 <set_cfs_priority+0x42>
    p->cfs_priority=100;
    return 0;
  }

  if(new_cfs==2){
    80002880:	4789                	li	a5,2
    80002882:	02f49863          	bne	s1,a5,800028b2 <set_cfs_priority+0x4e>
    p->cfs_priority=125;
    80002886:	07d00793          	li	a5,125
    8000288a:	18f52a23          	sw	a5,404(a0)
    return 0;
    8000288e:	4501                	li	a0,0
  }
  //release(&p->lock);
   
  return -1;
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	64a2                	ld	s1,8(sp)
    80002896:	6105                	addi	sp,sp,32
    80002898:	8082                	ret
    p->cfs_priority=75;
    8000289a:	04b00793          	li	a5,75
    8000289e:	18f52a23          	sw	a5,404(a0)
    return 0;
    800028a2:	8526                	mv	a0,s1
    800028a4:	b7f5                	j	80002890 <set_cfs_priority+0x2c>
    p->cfs_priority=100;
    800028a6:	06400793          	li	a5,100
    800028aa:	18f52a23          	sw	a5,404(a0)
    return 0;
    800028ae:	4501                	li	a0,0
    800028b0:	b7c5                	j	80002890 <set_cfs_priority+0x2c>
  return -1;
    800028b2:	557d                	li	a0,-1
    800028b4:	bff1                	j	80002890 <set_cfs_priority+0x2c>

00000000800028b6 <get_cfs_stats>:



int
get_cfs_stats(int pid , uint64 add_cfs_priority ,uint64 add_rtime,uint64 add_stime, uint64 add_retime )
{
    800028b6:	715d                	addi	sp,sp,-80
    800028b8:	e486                	sd	ra,72(sp)
    800028ba:	e0a2                	sd	s0,64(sp)
    800028bc:	fc26                	sd	s1,56(sp)
    800028be:	f84a                	sd	s2,48(sp)
    800028c0:	f44e                	sd	s3,40(sp)
    800028c2:	f052                	sd	s4,32(sp)
    800028c4:	ec56                	sd	s5,24(sp)
    800028c6:	e85a                	sd	s6,16(sp)
    800028c8:	e45e                	sd	s7,8(sp)
    800028ca:	0880                	addi	s0,sp,80
    800028cc:	892a                	mv	s2,a0
    800028ce:	8bae                	mv	s7,a1
    800028d0:	8b32                	mv	s6,a2
    800028d2:	8ab6                	mv	s5,a3
    800028d4:	8a3a                	mv	s4,a4
 struct proc *p;
 for(p = proc; p < &proc[NPROC]; p++){
    800028d6:	0000e497          	auipc	s1,0xe
    800028da:	6ea48493          	addi	s1,s1,1770 # 80010fc0 <proc>
    800028de:	00015997          	auipc	s3,0x15
    800028e2:	6e298993          	addi	s3,s3,1762 # 80017fc0 <tickslock>
    800028e6:	a811                	j	800028fa <get_cfs_stats+0x44>
      copyout(myproc()->pagetable, add_cfs_priority, (char *)&p->cfs_priority,sizeof(p->cfs_priority));
      copyout(myproc()->pagetable, add_rtime, (char *)&p->rtime,sizeof(p->rtime));
      copyout(myproc()->pagetable, add_stime, (char *)&p->stime,sizeof(p->stime));
      copyout(myproc()->pagetable, add_retime, (char *)&p->retime,sizeof(p->retime));      
    }
    release(&p->lock);
    800028e8:	8526                	mv	a0,s1
    800028ea:	ffffe097          	auipc	ra,0xffffe
    800028ee:	3a0080e7          	jalr	928(ra) # 80000c8a <release>
 for(p = proc; p < &proc[NPROC]; p++){
    800028f2:	1c048493          	addi	s1,s1,448
    800028f6:	07348f63          	beq	s1,s3,80002974 <get_cfs_stats+0xbe>
    acquire(&p->lock);
    800028fa:	8526                	mv	a0,s1
    800028fc:	ffffe097          	auipc	ra,0xffffe
    80002900:	2da080e7          	jalr	730(ra) # 80000bd6 <acquire>
    if(p->pid == pid){      
    80002904:	589c                	lw	a5,48(s1)
    80002906:	ff2791e3          	bne	a5,s2,800028e8 <get_cfs_stats+0x32>
      copyout(myproc()->pagetable, add_cfs_priority, (char *)&p->cfs_priority,sizeof(p->cfs_priority));
    8000290a:	fffff097          	auipc	ra,0xfffff
    8000290e:	0a2080e7          	jalr	162(ra) # 800019ac <myproc>
    80002912:	4691                	li	a3,4
    80002914:	19448613          	addi	a2,s1,404
    80002918:	85de                	mv	a1,s7
    8000291a:	7d28                	ld	a0,120(a0)
    8000291c:	fffff097          	auipc	ra,0xfffff
    80002920:	d4c080e7          	jalr	-692(ra) # 80001668 <copyout>
      copyout(myproc()->pagetable, add_rtime, (char *)&p->rtime,sizeof(p->rtime));
    80002924:	fffff097          	auipc	ra,0xfffff
    80002928:	088080e7          	jalr	136(ra) # 800019ac <myproc>
    8000292c:	46a1                	li	a3,8
    8000292e:	19848613          	addi	a2,s1,408
    80002932:	85da                	mv	a1,s6
    80002934:	7d28                	ld	a0,120(a0)
    80002936:	fffff097          	auipc	ra,0xfffff
    8000293a:	d32080e7          	jalr	-718(ra) # 80001668 <copyout>
      copyout(myproc()->pagetable, add_stime, (char *)&p->stime,sizeof(p->stime));
    8000293e:	fffff097          	auipc	ra,0xfffff
    80002942:	06e080e7          	jalr	110(ra) # 800019ac <myproc>
    80002946:	46a1                	li	a3,8
    80002948:	1a048613          	addi	a2,s1,416
    8000294c:	85d6                	mv	a1,s5
    8000294e:	7d28                	ld	a0,120(a0)
    80002950:	fffff097          	auipc	ra,0xfffff
    80002954:	d18080e7          	jalr	-744(ra) # 80001668 <copyout>
      copyout(myproc()->pagetable, add_retime, (char *)&p->retime,sizeof(p->retime));      
    80002958:	fffff097          	auipc	ra,0xfffff
    8000295c:	054080e7          	jalr	84(ra) # 800019ac <myproc>
    80002960:	46a1                	li	a3,8
    80002962:	1a848613          	addi	a2,s1,424
    80002966:	85d2                	mv	a1,s4
    80002968:	7d28                	ld	a0,120(a0)
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	cfe080e7          	jalr	-770(ra) # 80001668 <copyout>
    80002972:	bf9d                	j	800028e8 <get_cfs_stats+0x32>
    
  }
  return -1; 
}
    80002974:	557d                	li	a0,-1
    80002976:	60a6                	ld	ra,72(sp)
    80002978:	6406                	ld	s0,64(sp)
    8000297a:	74e2                	ld	s1,56(sp)
    8000297c:	7942                	ld	s2,48(sp)
    8000297e:	79a2                	ld	s3,40(sp)
    80002980:	7a02                	ld	s4,32(sp)
    80002982:	6ae2                	ld	s5,24(sp)
    80002984:	6b42                	ld	s6,16(sp)
    80002986:	6ba2                	ld	s7,8(sp)
    80002988:	6161                	addi	sp,sp,80
    8000298a:	8082                	ret

000000008000298c <update_cfs_vars>:


void
update_cfs_vars(void){
    8000298c:	7139                	addi	sp,sp,-64
    8000298e:	fc06                	sd	ra,56(sp)
    80002990:	f822                	sd	s0,48(sp)
    80002992:	f426                	sd	s1,40(sp)
    80002994:	f04a                	sd	s2,32(sp)
    80002996:	ec4e                	sd	s3,24(sp)
    80002998:	e852                	sd	s4,16(sp)
    8000299a:	e456                	sd	s5,8(sp)
    8000299c:	0080                	addi	s0,sp,64
  ///////////////////////////
  //update run time
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++){
    8000299e:	0000e497          	auipc	s1,0xe
    800029a2:	62248493          	addi	s1,s1,1570 # 80010fc0 <proc>
    
    if(p!=myproc()){
      acquire(&p->lock); 
    }       
      if(p->state == RUNNING){
    800029a6:	4991                	li	s3,4
        p->rtime++;    
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
      }

      if(p->state == SLEEPING){
    800029a8:	4a09                	li	s4,2
        p->stime++;     
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
      }

      if(p->state == RUNNABLE){
    800029aa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++){
    800029ac:	00015917          	auipc	s2,0x15
    800029b0:	61490913          	addi	s2,s2,1556 # 80017fc0 <tickslock>
    800029b4:	a099                	j	800029fa <update_cfs_vars+0x6e>
        p->rtime++;    
    800029b6:	1984b783          	ld	a5,408(s1)
    800029ba:	0785                	addi	a5,a5,1
    800029bc:	18f4bc23          	sd	a5,408(s1)
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    800029c0:	1a04b703          	ld	a4,416(s1)
    800029c4:	973e                	add	a4,a4,a5
    800029c6:	1a84b683          	ld	a3,424(s1)
    800029ca:	9736                	add	a4,a4,a3
    800029cc:	02e7c7b3          	div	a5,a5,a4
    800029d0:	1944a703          	lw	a4,404(s1)
    800029d4:	02e787b3          	mul	a5,a5,a4
    800029d8:	1af4b823          	sd	a5,432(s1)
        p->retime++;    
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));

      }
    if(p!=myproc()){
    800029dc:	fffff097          	auipc	ra,0xfffff
    800029e0:	fd0080e7          	jalr	-48(ra) # 800019ac <myproc>
    800029e4:	00a48763          	beq	s1,a0,800029f2 <update_cfs_vars+0x66>
      release(&p->lock); 
    800029e8:	8526                	mv	a0,s1
    800029ea:	ffffe097          	auipc	ra,0xffffe
    800029ee:	2a0080e7          	jalr	672(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800029f2:	1c048493          	addi	s1,s1,448
    800029f6:	07248d63          	beq	s1,s2,80002a70 <update_cfs_vars+0xe4>
    if(p!=myproc()){
    800029fa:	fffff097          	auipc	ra,0xfffff
    800029fe:	fb2080e7          	jalr	-78(ra) # 800019ac <myproc>
    80002a02:	00a48763          	beq	s1,a0,80002a10 <update_cfs_vars+0x84>
      acquire(&p->lock); 
    80002a06:	8526                	mv	a0,s1
    80002a08:	ffffe097          	auipc	ra,0xffffe
    80002a0c:	1ce080e7          	jalr	462(ra) # 80000bd6 <acquire>
      if(p->state == RUNNING){
    80002a10:	4c9c                	lw	a5,24(s1)
    80002a12:	fb3782e3          	beq	a5,s3,800029b6 <update_cfs_vars+0x2a>
      if(p->state == SLEEPING){
    80002a16:	03479663          	bne	a5,s4,80002a42 <update_cfs_vars+0xb6>
        p->stime++;     
    80002a1a:	1a04b783          	ld	a5,416(s1)
    80002a1e:	0785                	addi	a5,a5,1
    80002a20:	1af4b023          	sd	a5,416(s1)
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    80002a24:	1984b703          	ld	a4,408(s1)
    80002a28:	97ba                	add	a5,a5,a4
    80002a2a:	1a84b683          	ld	a3,424(s1)
    80002a2e:	97b6                	add	a5,a5,a3
    80002a30:	02f747b3          	div	a5,a4,a5
    80002a34:	1944a703          	lw	a4,404(s1)
    80002a38:	02e787b3          	mul	a5,a5,a4
    80002a3c:	1af4b823          	sd	a5,432(s1)
      if(p->state == RUNNABLE){
    80002a40:	bf71                	j	800029dc <update_cfs_vars+0x50>
    80002a42:	f9579de3          	bne	a5,s5,800029dc <update_cfs_vars+0x50>
        p->retime++;    
    80002a46:	1a84b703          	ld	a4,424(s1)
    80002a4a:	00170693          	addi	a3,a4,1
    80002a4e:	1ad4b423          	sd	a3,424(s1)
        p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    80002a52:	1984b783          	ld	a5,408(s1)
    80002a56:	1a04b703          	ld	a4,416(s1)
    80002a5a:	973e                	add	a4,a4,a5
    80002a5c:	9736                	add	a4,a4,a3
    80002a5e:	02e7c7b3          	div	a5,a5,a4
    80002a62:	1944a703          	lw	a4,404(s1)
    80002a66:	02e787b3          	mul	a5,a5,a4
    80002a6a:	1af4b823          	sd	a5,432(s1)
    80002a6e:	b7bd                	j	800029dc <update_cfs_vars+0x50>
    } 
   
  }
  
  ///////////////////////////
}
    80002a70:	70e2                	ld	ra,56(sp)
    80002a72:	7442                	ld	s0,48(sp)
    80002a74:	74a2                	ld	s1,40(sp)
    80002a76:	7902                	ld	s2,32(sp)
    80002a78:	69e2                	ld	s3,24(sp)
    80002a7a:	6a42                	ld	s4,16(sp)
    80002a7c:	6aa2                	ld	s5,8(sp)
    80002a7e:	6121                	addi	sp,sp,64
    80002a80:	8082                	ret

0000000080002a82 <set_policy>:

int
set_policy(int policy){
    80002a82:	1141                	addi	sp,sp,-16
    80002a84:	e422                	sd	s0,8(sp)
    80002a86:	0800                	addi	s0,sp,16
  if(policy==0){
    80002a88:	cd19                	beqz	a0,80002aa6 <set_policy+0x24>
    sched_policy=0;    
    return 0;
  }
  if(policy==1){
    80002a8a:	4785                	li	a5,1
    80002a8c:	02f50263          	beq	a0,a5,80002ab0 <set_policy+0x2e>
    sched_policy=1;
    return 0;
  }
  if(policy==2){
    80002a90:	4789                	li	a5,2
    80002a92:	02f51563          	bne	a0,a5,80002abc <set_policy+0x3a>
    sched_policy=2;
    80002a96:	00006717          	auipc	a4,0x6
    80002a9a:	e8f72123          	sw	a5,-382(a4) # 80008918 <sched_policy>
    return 0;
    80002a9e:	4501                	li	a0,0
  }

  return -1;
}
    80002aa0:	6422                	ld	s0,8(sp)
    80002aa2:	0141                	addi	sp,sp,16
    80002aa4:	8082                	ret
    sched_policy=0;    
    80002aa6:	00006797          	auipc	a5,0x6
    80002aaa:	e607a923          	sw	zero,-398(a5) # 80008918 <sched_policy>
    return 0;
    80002aae:	bfcd                	j	80002aa0 <set_policy+0x1e>
    sched_policy=1;
    80002ab0:	00006717          	auipc	a4,0x6
    80002ab4:	e6f72423          	sw	a5,-408(a4) # 80008918 <sched_policy>
    return 0;
    80002ab8:	4501                	li	a0,0
    80002aba:	b7dd                	j	80002aa0 <set_policy+0x1e>
  return -1;
    80002abc:	557d                	li	a0,-1
    80002abe:	b7cd                	j	80002aa0 <set_policy+0x1e>

0000000080002ac0 <swtch>:
    80002ac0:	00153023          	sd	ra,0(a0)
    80002ac4:	00253423          	sd	sp,8(a0)
    80002ac8:	e900                	sd	s0,16(a0)
    80002aca:	ed04                	sd	s1,24(a0)
    80002acc:	03253023          	sd	s2,32(a0)
    80002ad0:	03353423          	sd	s3,40(a0)
    80002ad4:	03453823          	sd	s4,48(a0)
    80002ad8:	03553c23          	sd	s5,56(a0)
    80002adc:	05653023          	sd	s6,64(a0)
    80002ae0:	05753423          	sd	s7,72(a0)
    80002ae4:	05853823          	sd	s8,80(a0)
    80002ae8:	05953c23          	sd	s9,88(a0)
    80002aec:	07a53023          	sd	s10,96(a0)
    80002af0:	07b53423          	sd	s11,104(a0)
    80002af4:	0005b083          	ld	ra,0(a1)
    80002af8:	0085b103          	ld	sp,8(a1)
    80002afc:	6980                	ld	s0,16(a1)
    80002afe:	6d84                	ld	s1,24(a1)
    80002b00:	0205b903          	ld	s2,32(a1)
    80002b04:	0285b983          	ld	s3,40(a1)
    80002b08:	0305ba03          	ld	s4,48(a1)
    80002b0c:	0385ba83          	ld	s5,56(a1)
    80002b10:	0405bb03          	ld	s6,64(a1)
    80002b14:	0485bb83          	ld	s7,72(a1)
    80002b18:	0505bc03          	ld	s8,80(a1)
    80002b1c:	0585bc83          	ld	s9,88(a1)
    80002b20:	0605bd03          	ld	s10,96(a1)
    80002b24:	0685bd83          	ld	s11,104(a1)
    80002b28:	8082                	ret

0000000080002b2a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b2a:	1141                	addi	sp,sp,-16
    80002b2c:	e406                	sd	ra,8(sp)
    80002b2e:	e022                	sd	s0,0(sp)
    80002b30:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b32:	00005597          	auipc	a1,0x5
    80002b36:	7c658593          	addi	a1,a1,1990 # 800082f8 <states.0+0x30>
    80002b3a:	00015517          	auipc	a0,0x15
    80002b3e:	48650513          	addi	a0,a0,1158 # 80017fc0 <tickslock>
    80002b42:	ffffe097          	auipc	ra,0xffffe
    80002b46:	004080e7          	jalr	4(ra) # 80000b46 <initlock>
}
    80002b4a:	60a2                	ld	ra,8(sp)
    80002b4c:	6402                	ld	s0,0(sp)
    80002b4e:	0141                	addi	sp,sp,16
    80002b50:	8082                	ret

0000000080002b52 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b52:	1141                	addi	sp,sp,-16
    80002b54:	e422                	sd	s0,8(sp)
    80002b56:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b58:	00003797          	auipc	a5,0x3
    80002b5c:	60878793          	addi	a5,a5,1544 # 80006160 <kernelvec>
    80002b60:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b64:	6422                	ld	s0,8(sp)
    80002b66:	0141                	addi	sp,sp,16
    80002b68:	8082                	ret

0000000080002b6a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002b6a:	1141                	addi	sp,sp,-16
    80002b6c:	e406                	sd	ra,8(sp)
    80002b6e:	e022                	sd	s0,0(sp)
    80002b70:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b72:	fffff097          	auipc	ra,0xfffff
    80002b76:	e3a080e7          	jalr	-454(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b80:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b84:	00004617          	auipc	a2,0x4
    80002b88:	47c60613          	addi	a2,a2,1148 # 80007000 <_trampoline>
    80002b8c:	00004697          	auipc	a3,0x4
    80002b90:	47468693          	addi	a3,a3,1140 # 80007000 <_trampoline>
    80002b94:	8e91                	sub	a3,a3,a2
    80002b96:	040007b7          	lui	a5,0x4000
    80002b9a:	17fd                	addi	a5,a5,-1
    80002b9c:	07b2                	slli	a5,a5,0xc
    80002b9e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ba0:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ba4:	6158                	ld	a4,128(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ba6:	180026f3          	csrr	a3,satp
    80002baa:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002bac:	6158                	ld	a4,128(a0)
    80002bae:	7534                	ld	a3,104(a0)
    80002bb0:	6585                	lui	a1,0x1
    80002bb2:	96ae                	add	a3,a3,a1
    80002bb4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002bb6:	6158                	ld	a4,128(a0)
    80002bb8:	00000697          	auipc	a3,0x0
    80002bbc:	13e68693          	addi	a3,a3,318 # 80002cf6 <usertrap>
    80002bc0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002bc2:	6158                	ld	a4,128(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002bc4:	8692                	mv	a3,tp
    80002bc6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bc8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002bcc:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002bd0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bd4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bd8:	6158                	ld	a4,128(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bda:	6f18                	ld	a4,24(a4)
    80002bdc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002be0:	7d28                	ld	a0,120(a0)
    80002be2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002be4:	00004717          	auipc	a4,0x4
    80002be8:	4b870713          	addi	a4,a4,1208 # 8000709c <userret>
    80002bec:	8f11                	sub	a4,a4,a2
    80002bee:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002bf0:	577d                	li	a4,-1
    80002bf2:	177e                	slli	a4,a4,0x3f
    80002bf4:	8d59                	or	a0,a0,a4
    80002bf6:	9782                	jalr	a5
}
    80002bf8:	60a2                	ld	ra,8(sp)
    80002bfa:	6402                	ld	s0,0(sp)
    80002bfc:	0141                	addi	sp,sp,16
    80002bfe:	8082                	ret

0000000080002c00 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002c00:	1101                	addi	sp,sp,-32
    80002c02:	ec06                	sd	ra,24(sp)
    80002c04:	e822                	sd	s0,16(sp)
    80002c06:	e426                	sd	s1,8(sp)
    80002c08:	e04a                	sd	s2,0(sp)
    80002c0a:	1000                	addi	s0,sp,32
  
  acquire(&tickslock);
    80002c0c:	00015917          	auipc	s2,0x15
    80002c10:	3b490913          	addi	s2,s2,948 # 80017fc0 <tickslock>
    80002c14:	854a                	mv	a0,s2
    80002c16:	ffffe097          	auipc	ra,0xffffe
    80002c1a:	fc0080e7          	jalr	-64(ra) # 80000bd6 <acquire>
  ticks++;
    80002c1e:	00006497          	auipc	s1,0x6
    80002c22:	d0a48493          	addi	s1,s1,-758 # 80008928 <ticks>
    80002c26:	409c                	lw	a5,0(s1)
    80002c28:	2785                	addiw	a5,a5,1
    80002c2a:	c09c                	sw	a5,0(s1)

  update_cfs_vars();
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	d60080e7          	jalr	-672(ra) # 8000298c <update_cfs_vars>

  wakeup(&ticks);
    80002c34:	8526                	mv	a0,s1
    80002c36:	fffff097          	auipc	ra,0xfffff
    80002c3a:	64a080e7          	jalr	1610(ra) # 80002280 <wakeup>
  release(&tickslock);
    80002c3e:	854a                	mv	a0,s2
    80002c40:	ffffe097          	auipc	ra,0xffffe
    80002c44:	04a080e7          	jalr	74(ra) # 80000c8a <release>
}
    80002c48:	60e2                	ld	ra,24(sp)
    80002c4a:	6442                	ld	s0,16(sp)
    80002c4c:	64a2                	ld	s1,8(sp)
    80002c4e:	6902                	ld	s2,0(sp)
    80002c50:	6105                	addi	sp,sp,32
    80002c52:	8082                	ret

0000000080002c54 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002c54:	1101                	addi	sp,sp,-32
    80002c56:	ec06                	sd	ra,24(sp)
    80002c58:	e822                	sd	s0,16(sp)
    80002c5a:	e426                	sd	s1,8(sp)
    80002c5c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c5e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002c62:	00074d63          	bltz	a4,80002c7c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002c66:	57fd                	li	a5,-1
    80002c68:	17fe                	slli	a5,a5,0x3f
    80002c6a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c6c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002c6e:	06f70363          	beq	a4,a5,80002cd4 <devintr+0x80>
  }
}
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6105                	addi	sp,sp,32
    80002c7a:	8082                	ret
     (scause & 0xff) == 9){
    80002c7c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002c80:	46a5                	li	a3,9
    80002c82:	fed792e3          	bne	a5,a3,80002c66 <devintr+0x12>
    int irq = plic_claim();
    80002c86:	00003097          	auipc	ra,0x3
    80002c8a:	5e2080e7          	jalr	1506(ra) # 80006268 <plic_claim>
    80002c8e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c90:	47a9                	li	a5,10
    80002c92:	02f50763          	beq	a0,a5,80002cc0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002c96:	4785                	li	a5,1
    80002c98:	02f50963          	beq	a0,a5,80002cca <devintr+0x76>
    return 1;
    80002c9c:	4505                	li	a0,1
    } else if(irq){
    80002c9e:	d8f1                	beqz	s1,80002c72 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002ca0:	85a6                	mv	a1,s1
    80002ca2:	00005517          	auipc	a0,0x5
    80002ca6:	65e50513          	addi	a0,a0,1630 # 80008300 <states.0+0x38>
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	8de080e7          	jalr	-1826(ra) # 80000588 <printf>
      plic_complete(irq);
    80002cb2:	8526                	mv	a0,s1
    80002cb4:	00003097          	auipc	ra,0x3
    80002cb8:	5d8080e7          	jalr	1496(ra) # 8000628c <plic_complete>
    return 1;
    80002cbc:	4505                	li	a0,1
    80002cbe:	bf55                	j	80002c72 <devintr+0x1e>
      uartintr();
    80002cc0:	ffffe097          	auipc	ra,0xffffe
    80002cc4:	cda080e7          	jalr	-806(ra) # 8000099a <uartintr>
    80002cc8:	b7ed                	j	80002cb2 <devintr+0x5e>
      virtio_disk_intr();
    80002cca:	00004097          	auipc	ra,0x4
    80002cce:	a8e080e7          	jalr	-1394(ra) # 80006758 <virtio_disk_intr>
    80002cd2:	b7c5                	j	80002cb2 <devintr+0x5e>
    if(cpuid() == 0){
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	cac080e7          	jalr	-852(ra) # 80001980 <cpuid>
    80002cdc:	c901                	beqz	a0,80002cec <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cde:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002ce2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002ce4:	14479073          	csrw	sip,a5
    return 2;
    80002ce8:	4509                	li	a0,2
    80002cea:	b761                	j	80002c72 <devintr+0x1e>
      clockintr();
    80002cec:	00000097          	auipc	ra,0x0
    80002cf0:	f14080e7          	jalr	-236(ra) # 80002c00 <clockintr>
    80002cf4:	b7ed                	j	80002cde <devintr+0x8a>

0000000080002cf6 <usertrap>:
{
    80002cf6:	1101                	addi	sp,sp,-32
    80002cf8:	ec06                	sd	ra,24(sp)
    80002cfa:	e822                	sd	s0,16(sp)
    80002cfc:	e426                	sd	s1,8(sp)
    80002cfe:	e04a                	sd	s2,0(sp)
    80002d00:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d02:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002d06:	1007f793          	andi	a5,a5,256
    80002d0a:	e3b1                	bnez	a5,80002d4e <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d0c:	00003797          	auipc	a5,0x3
    80002d10:	45478793          	addi	a5,a5,1108 # 80006160 <kernelvec>
    80002d14:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	c94080e7          	jalr	-876(ra) # 800019ac <myproc>
    80002d20:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d22:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d24:	14102773          	csrr	a4,sepc
    80002d28:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d2a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d2e:	47a1                	li	a5,8
    80002d30:	02f70763          	beq	a4,a5,80002d5e <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002d34:	00000097          	auipc	ra,0x0
    80002d38:	f20080e7          	jalr	-224(ra) # 80002c54 <devintr>
    80002d3c:	892a                	mv	s2,a0
    80002d3e:	c951                	beqz	a0,80002dd2 <usertrap+0xdc>
  if(killed(p))
    80002d40:	8526                	mv	a0,s1
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	802080e7          	jalr	-2046(ra) # 80002544 <killed>
    80002d4a:	cd29                	beqz	a0,80002da4 <usertrap+0xae>
    80002d4c:	a099                	j	80002d92 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002d4e:	00005517          	auipc	a0,0x5
    80002d52:	5d250513          	addi	a0,a0,1490 # 80008320 <states.0+0x58>
    80002d56:	ffffd097          	auipc	ra,0xffffd
    80002d5a:	7e8080e7          	jalr	2024(ra) # 8000053e <panic>
    if(killed(p))
    80002d5e:	fffff097          	auipc	ra,0xfffff
    80002d62:	7e6080e7          	jalr	2022(ra) # 80002544 <killed>
    80002d66:	ed21                	bnez	a0,80002dbe <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002d68:	60d8                	ld	a4,128(s1)
    80002d6a:	6f1c                	ld	a5,24(a4)
    80002d6c:	0791                	addi	a5,a5,4
    80002d6e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d74:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d78:	10079073          	csrw	sstatus,a5
    syscall();
    80002d7c:	00000097          	auipc	ra,0x0
    80002d80:	2e4080e7          	jalr	740(ra) # 80003060 <syscall>
  if(killed(p))
    80002d84:	8526                	mv	a0,s1
    80002d86:	fffff097          	auipc	ra,0xfffff
    80002d8a:	7be080e7          	jalr	1982(ra) # 80002544 <killed>
    80002d8e:	cd11                	beqz	a0,80002daa <usertrap+0xb4>
    80002d90:	4901                	li	s2,0
    exit(-1, "killed");
    80002d92:	00005597          	auipc	a1,0x5
    80002d96:	60658593          	addi	a1,a1,1542 # 80008398 <states.0+0xd0>
    80002d9a:	557d                	li	a0,-1
    80002d9c:	fffff097          	auipc	ra,0xfffff
    80002da0:	61e080e7          	jalr	1566(ra) # 800023ba <exit>
  if(which_dev == 2)
    80002da4:	4789                	li	a5,2
    80002da6:	06f90363          	beq	s2,a5,80002e0c <usertrap+0x116>
  usertrapret();
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	dc0080e7          	jalr	-576(ra) # 80002b6a <usertrapret>
}
    80002db2:	60e2                	ld	ra,24(sp)
    80002db4:	6442                	ld	s0,16(sp)
    80002db6:	64a2                	ld	s1,8(sp)
    80002db8:	6902                	ld	s2,0(sp)
    80002dba:	6105                	addi	sp,sp,32
    80002dbc:	8082                	ret
      exit(-1 , "killed ");
    80002dbe:	00005597          	auipc	a1,0x5
    80002dc2:	58258593          	addi	a1,a1,1410 # 80008340 <states.0+0x78>
    80002dc6:	557d                	li	a0,-1
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	5f2080e7          	jalr	1522(ra) # 800023ba <exit>
    80002dd0:	bf61                	j	80002d68 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002dd2:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002dd6:	5890                	lw	a2,48(s1)
    80002dd8:	00005517          	auipc	a0,0x5
    80002ddc:	57050513          	addi	a0,a0,1392 # 80008348 <states.0+0x80>
    80002de0:	ffffd097          	auipc	ra,0xffffd
    80002de4:	7a8080e7          	jalr	1960(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002de8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dec:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002df0:	00005517          	auipc	a0,0x5
    80002df4:	58850513          	addi	a0,a0,1416 # 80008378 <states.0+0xb0>
    80002df8:	ffffd097          	auipc	ra,0xffffd
    80002dfc:	790080e7          	jalr	1936(ra) # 80000588 <printf>
    setkilled(p);
    80002e00:	8526                	mv	a0,s1
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	716080e7          	jalr	1814(ra) # 80002518 <setkilled>
    80002e0a:	bfad                	j	80002d84 <usertrap+0x8e>
    yield();
    80002e0c:	fffff097          	auipc	ra,0xfffff
    80002e10:	3d4080e7          	jalr	980(ra) # 800021e0 <yield>
    80002e14:	bf59                	j	80002daa <usertrap+0xb4>

0000000080002e16 <kerneltrap>:
{
    80002e16:	7179                	addi	sp,sp,-48
    80002e18:	f406                	sd	ra,40(sp)
    80002e1a:	f022                	sd	s0,32(sp)
    80002e1c:	ec26                	sd	s1,24(sp)
    80002e1e:	e84a                	sd	s2,16(sp)
    80002e20:	e44e                	sd	s3,8(sp)
    80002e22:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e24:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e28:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e2c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002e30:	1004f793          	andi	a5,s1,256
    80002e34:	cb85                	beqz	a5,80002e64 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e36:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e3a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002e3c:	ef85                	bnez	a5,80002e74 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	e16080e7          	jalr	-490(ra) # 80002c54 <devintr>
    80002e46:	cd1d                	beqz	a0,80002e84 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002e48:	4789                	li	a5,2
    80002e4a:	06f50a63          	beq	a0,a5,80002ebe <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e4e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e52:	10049073          	csrw	sstatus,s1
}
    80002e56:	70a2                	ld	ra,40(sp)
    80002e58:	7402                	ld	s0,32(sp)
    80002e5a:	64e2                	ld	s1,24(sp)
    80002e5c:	6942                	ld	s2,16(sp)
    80002e5e:	69a2                	ld	s3,8(sp)
    80002e60:	6145                	addi	sp,sp,48
    80002e62:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e64:	00005517          	auipc	a0,0x5
    80002e68:	53c50513          	addi	a0,a0,1340 # 800083a0 <states.0+0xd8>
    80002e6c:	ffffd097          	auipc	ra,0xffffd
    80002e70:	6d2080e7          	jalr	1746(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002e74:	00005517          	auipc	a0,0x5
    80002e78:	55450513          	addi	a0,a0,1364 # 800083c8 <states.0+0x100>
    80002e7c:	ffffd097          	auipc	ra,0xffffd
    80002e80:	6c2080e7          	jalr	1730(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002e84:	85ce                	mv	a1,s3
    80002e86:	00005517          	auipc	a0,0x5
    80002e8a:	56250513          	addi	a0,a0,1378 # 800083e8 <states.0+0x120>
    80002e8e:	ffffd097          	auipc	ra,0xffffd
    80002e92:	6fa080e7          	jalr	1786(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e96:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e9a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e9e:	00005517          	auipc	a0,0x5
    80002ea2:	55a50513          	addi	a0,a0,1370 # 800083f8 <states.0+0x130>
    80002ea6:	ffffd097          	auipc	ra,0xffffd
    80002eaa:	6e2080e7          	jalr	1762(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002eae:	00005517          	auipc	a0,0x5
    80002eb2:	56250513          	addi	a0,a0,1378 # 80008410 <states.0+0x148>
    80002eb6:	ffffd097          	auipc	ra,0xffffd
    80002eba:	688080e7          	jalr	1672(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ebe:	fffff097          	auipc	ra,0xfffff
    80002ec2:	aee080e7          	jalr	-1298(ra) # 800019ac <myproc>
    80002ec6:	d541                	beqz	a0,80002e4e <kerneltrap+0x38>
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	ae4080e7          	jalr	-1308(ra) # 800019ac <myproc>
    80002ed0:	4d18                	lw	a4,24(a0)
    80002ed2:	4791                	li	a5,4
    80002ed4:	f6f71de3          	bne	a4,a5,80002e4e <kerneltrap+0x38>
    yield();
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	308080e7          	jalr	776(ra) # 800021e0 <yield>
    80002ee0:	b7bd                	j	80002e4e <kerneltrap+0x38>

0000000080002ee2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	1000                	addi	s0,sp,32
    80002eec:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	abe080e7          	jalr	-1346(ra) # 800019ac <myproc>
  switch (n) {
    80002ef6:	4795                	li	a5,5
    80002ef8:	0497e163          	bltu	a5,s1,80002f3a <argraw+0x58>
    80002efc:	048a                	slli	s1,s1,0x2
    80002efe:	00005717          	auipc	a4,0x5
    80002f02:	54a70713          	addi	a4,a4,1354 # 80008448 <states.0+0x180>
    80002f06:	94ba                	add	s1,s1,a4
    80002f08:	409c                	lw	a5,0(s1)
    80002f0a:	97ba                	add	a5,a5,a4
    80002f0c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f0e:	615c                	ld	a5,128(a0)
    80002f10:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f12:	60e2                	ld	ra,24(sp)
    80002f14:	6442                	ld	s0,16(sp)
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	6105                	addi	sp,sp,32
    80002f1a:	8082                	ret
    return p->trapframe->a1;
    80002f1c:	615c                	ld	a5,128(a0)
    80002f1e:	7fa8                	ld	a0,120(a5)
    80002f20:	bfcd                	j	80002f12 <argraw+0x30>
    return p->trapframe->a2;
    80002f22:	615c                	ld	a5,128(a0)
    80002f24:	63c8                	ld	a0,128(a5)
    80002f26:	b7f5                	j	80002f12 <argraw+0x30>
    return p->trapframe->a3;
    80002f28:	615c                	ld	a5,128(a0)
    80002f2a:	67c8                	ld	a0,136(a5)
    80002f2c:	b7dd                	j	80002f12 <argraw+0x30>
    return p->trapframe->a4;
    80002f2e:	615c                	ld	a5,128(a0)
    80002f30:	6bc8                	ld	a0,144(a5)
    80002f32:	b7c5                	j	80002f12 <argraw+0x30>
    return p->trapframe->a5;
    80002f34:	615c                	ld	a5,128(a0)
    80002f36:	6fc8                	ld	a0,152(a5)
    80002f38:	bfe9                	j	80002f12 <argraw+0x30>
  panic("argraw");
    80002f3a:	00005517          	auipc	a0,0x5
    80002f3e:	4e650513          	addi	a0,a0,1254 # 80008420 <states.0+0x158>
    80002f42:	ffffd097          	auipc	ra,0xffffd
    80002f46:	5fc080e7          	jalr	1532(ra) # 8000053e <panic>

0000000080002f4a <fetchaddr>:
{
    80002f4a:	1101                	addi	sp,sp,-32
    80002f4c:	ec06                	sd	ra,24(sp)
    80002f4e:	e822                	sd	s0,16(sp)
    80002f50:	e426                	sd	s1,8(sp)
    80002f52:	e04a                	sd	s2,0(sp)
    80002f54:	1000                	addi	s0,sp,32
    80002f56:	84aa                	mv	s1,a0
    80002f58:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f5a:	fffff097          	auipc	ra,0xfffff
    80002f5e:	a52080e7          	jalr	-1454(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f62:	793c                	ld	a5,112(a0)
    80002f64:	02f4f863          	bgeu	s1,a5,80002f94 <fetchaddr+0x4a>
    80002f68:	00848713          	addi	a4,s1,8
    80002f6c:	02e7e663          	bltu	a5,a4,80002f98 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f70:	46a1                	li	a3,8
    80002f72:	8626                	mv	a2,s1
    80002f74:	85ca                	mv	a1,s2
    80002f76:	7d28                	ld	a0,120(a0)
    80002f78:	ffffe097          	auipc	ra,0xffffe
    80002f7c:	77c080e7          	jalr	1916(ra) # 800016f4 <copyin>
    80002f80:	00a03533          	snez	a0,a0
    80002f84:	40a00533          	neg	a0,a0
}
    80002f88:	60e2                	ld	ra,24(sp)
    80002f8a:	6442                	ld	s0,16(sp)
    80002f8c:	64a2                	ld	s1,8(sp)
    80002f8e:	6902                	ld	s2,0(sp)
    80002f90:	6105                	addi	sp,sp,32
    80002f92:	8082                	ret
    return -1;
    80002f94:	557d                	li	a0,-1
    80002f96:	bfcd                	j	80002f88 <fetchaddr+0x3e>
    80002f98:	557d                	li	a0,-1
    80002f9a:	b7fd                	j	80002f88 <fetchaddr+0x3e>

0000000080002f9c <fetchstr>:
{
    80002f9c:	7179                	addi	sp,sp,-48
    80002f9e:	f406                	sd	ra,40(sp)
    80002fa0:	f022                	sd	s0,32(sp)
    80002fa2:	ec26                	sd	s1,24(sp)
    80002fa4:	e84a                	sd	s2,16(sp)
    80002fa6:	e44e                	sd	s3,8(sp)
    80002fa8:	1800                	addi	s0,sp,48
    80002faa:	892a                	mv	s2,a0
    80002fac:	84ae                	mv	s1,a1
    80002fae:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	9fc080e7          	jalr	-1540(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002fb8:	86ce                	mv	a3,s3
    80002fba:	864a                	mv	a2,s2
    80002fbc:	85a6                	mv	a1,s1
    80002fbe:	7d28                	ld	a0,120(a0)
    80002fc0:	ffffe097          	auipc	ra,0xffffe
    80002fc4:	7c2080e7          	jalr	1986(ra) # 80001782 <copyinstr>
    80002fc8:	00054e63          	bltz	a0,80002fe4 <fetchstr+0x48>
  return strlen(buf);
    80002fcc:	8526                	mv	a0,s1
    80002fce:	ffffe097          	auipc	ra,0xffffe
    80002fd2:	e80080e7          	jalr	-384(ra) # 80000e4e <strlen>
}
    80002fd6:	70a2                	ld	ra,40(sp)
    80002fd8:	7402                	ld	s0,32(sp)
    80002fda:	64e2                	ld	s1,24(sp)
    80002fdc:	6942                	ld	s2,16(sp)
    80002fde:	69a2                	ld	s3,8(sp)
    80002fe0:	6145                	addi	sp,sp,48
    80002fe2:	8082                	ret
    return -1;
    80002fe4:	557d                	li	a0,-1
    80002fe6:	bfc5                	j	80002fd6 <fetchstr+0x3a>

0000000080002fe8 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002fe8:	1101                	addi	sp,sp,-32
    80002fea:	ec06                	sd	ra,24(sp)
    80002fec:	e822                	sd	s0,16(sp)
    80002fee:	e426                	sd	s1,8(sp)
    80002ff0:	1000                	addi	s0,sp,32
    80002ff2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	eee080e7          	jalr	-274(ra) # 80002ee2 <argraw>
    80002ffc:	c088                	sw	a0,0(s1)
}
    80002ffe:	60e2                	ld	ra,24(sp)
    80003000:	6442                	ld	s0,16(sp)
    80003002:	64a2                	ld	s1,8(sp)
    80003004:	6105                	addi	sp,sp,32
    80003006:	8082                	ret

0000000080003008 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	e426                	sd	s1,8(sp)
    80003010:	1000                	addi	s0,sp,32
    80003012:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003014:	00000097          	auipc	ra,0x0
    80003018:	ece080e7          	jalr	-306(ra) # 80002ee2 <argraw>
    8000301c:	e088                	sd	a0,0(s1)
}
    8000301e:	60e2                	ld	ra,24(sp)
    80003020:	6442                	ld	s0,16(sp)
    80003022:	64a2                	ld	s1,8(sp)
    80003024:	6105                	addi	sp,sp,32
    80003026:	8082                	ret

0000000080003028 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003028:	7179                	addi	sp,sp,-48
    8000302a:	f406                	sd	ra,40(sp)
    8000302c:	f022                	sd	s0,32(sp)
    8000302e:	ec26                	sd	s1,24(sp)
    80003030:	e84a                	sd	s2,16(sp)
    80003032:	1800                	addi	s0,sp,48
    80003034:	84ae                	mv	s1,a1
    80003036:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003038:	fd840593          	addi	a1,s0,-40
    8000303c:	00000097          	auipc	ra,0x0
    80003040:	fcc080e7          	jalr	-52(ra) # 80003008 <argaddr>
  return fetchstr(addr, buf, max);
    80003044:	864a                	mv	a2,s2
    80003046:	85a6                	mv	a1,s1
    80003048:	fd843503          	ld	a0,-40(s0)
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	f50080e7          	jalr	-176(ra) # 80002f9c <fetchstr>
}
    80003054:	70a2                	ld	ra,40(sp)
    80003056:	7402                	ld	s0,32(sp)
    80003058:	64e2                	ld	s1,24(sp)
    8000305a:	6942                	ld	s2,16(sp)
    8000305c:	6145                	addi	sp,sp,48
    8000305e:	8082                	ret

0000000080003060 <syscall>:

};

void
syscall(void)
{
    80003060:	1101                	addi	sp,sp,-32
    80003062:	ec06                	sd	ra,24(sp)
    80003064:	e822                	sd	s0,16(sp)
    80003066:	e426                	sd	s1,8(sp)
    80003068:	e04a                	sd	s2,0(sp)
    8000306a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	940080e7          	jalr	-1728(ra) # 800019ac <myproc>
    80003074:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003076:	08053903          	ld	s2,128(a0)
    8000307a:	0a893783          	ld	a5,168(s2)
    8000307e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003082:	37fd                	addiw	a5,a5,-1
    80003084:	4765                	li	a4,25
    80003086:	00f76f63          	bltu	a4,a5,800030a4 <syscall+0x44>
    8000308a:	00369713          	slli	a4,a3,0x3
    8000308e:	00005797          	auipc	a5,0x5
    80003092:	3d278793          	addi	a5,a5,978 # 80008460 <syscalls>
    80003096:	97ba                	add	a5,a5,a4
    80003098:	639c                	ld	a5,0(a5)
    8000309a:	c789                	beqz	a5,800030a4 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000309c:	9782                	jalr	a5
    8000309e:	06a93823          	sd	a0,112(s2)
    800030a2:	a839                	j	800030c0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800030a4:	18048613          	addi	a2,s1,384
    800030a8:	588c                	lw	a1,48(s1)
    800030aa:	00005517          	auipc	a0,0x5
    800030ae:	37e50513          	addi	a0,a0,894 # 80008428 <states.0+0x160>
    800030b2:	ffffd097          	auipc	ra,0xffffd
    800030b6:	4d6080e7          	jalr	1238(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800030ba:	60dc                	ld	a5,128(s1)
    800030bc:	577d                	li	a4,-1
    800030be:	fbb8                	sd	a4,112(a5)
  }
}
    800030c0:	60e2                	ld	ra,24(sp)
    800030c2:	6442                	ld	s0,16(sp)
    800030c4:	64a2                	ld	s1,8(sp)
    800030c6:	6902                	ld	s2,0(sp)
    800030c8:	6105                	addi	sp,sp,32
    800030ca:	8082                	ret

00000000800030cc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800030cc:	7139                	addi	sp,sp,-64
    800030ce:	fc06                	sd	ra,56(sp)
    800030d0:	f822                	sd	s0,48(sp)
    800030d2:	0080                	addi	s0,sp,64
  int n;
  char exit_msg[32];
  argint(0, &n);
    800030d4:	fec40593          	addi	a1,s0,-20
    800030d8:	4501                	li	a0,0
    800030da:	00000097          	auipc	ra,0x0
    800030de:	f0e080e7          	jalr	-242(ra) # 80002fe8 <argint>
  argstr(1, exit_msg, MAXARG);
    800030e2:	02000613          	li	a2,32
    800030e6:	fc840593          	addi	a1,s0,-56
    800030ea:	4505                	li	a0,1
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	f3c080e7          	jalr	-196(ra) # 80003028 <argstr>
  exit(n,exit_msg);
    800030f4:	fc840593          	addi	a1,s0,-56
    800030f8:	fec42503          	lw	a0,-20(s0)
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	2be080e7          	jalr	702(ra) # 800023ba <exit>
  return 0;  // not reached
}
    80003104:	4501                	li	a0,0
    80003106:	70e2                	ld	ra,56(sp)
    80003108:	7442                	ld	s0,48(sp)
    8000310a:	6121                	addi	sp,sp,64
    8000310c:	8082                	ret

000000008000310e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000310e:	1141                	addi	sp,sp,-16
    80003110:	e406                	sd	ra,8(sp)
    80003112:	e022                	sd	s0,0(sp)
    80003114:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	896080e7          	jalr	-1898(ra) # 800019ac <myproc>
}
    8000311e:	5908                	lw	a0,48(a0)
    80003120:	60a2                	ld	ra,8(sp)
    80003122:	6402                	ld	s0,0(sp)
    80003124:	0141                	addi	sp,sp,16
    80003126:	8082                	ret

0000000080003128 <sys_fork>:

uint64
sys_fork(void)
{
    80003128:	1141                	addi	sp,sp,-16
    8000312a:	e406                	sd	ra,8(sp)
    8000312c:	e022                	sd	s0,0(sp)
    8000312e:	0800                	addi	s0,sp,16
  return fork();
    80003130:	fffff097          	auipc	ra,0xfffff
    80003134:	cca080e7          	jalr	-822(ra) # 80001dfa <fork>
}
    80003138:	60a2                	ld	ra,8(sp)
    8000313a:	6402                	ld	s0,0(sp)
    8000313c:	0141                	addi	sp,sp,16
    8000313e:	8082                	ret

0000000080003140 <sys_wait>:

uint64
sys_wait(void)
{
    80003140:	1101                	addi	sp,sp,-32
    80003142:	ec06                	sd	ra,24(sp)
    80003144:	e822                	sd	s0,16(sp)
    80003146:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 exit_msg;
  
  argaddr(0, &p);
    80003148:	fe840593          	addi	a1,s0,-24
    8000314c:	4501                	li	a0,0
    8000314e:	00000097          	auipc	ra,0x0
    80003152:	eba080e7          	jalr	-326(ra) # 80003008 <argaddr>
  argaddr(1, &exit_msg);
    80003156:	fe040593          	addi	a1,s0,-32
    8000315a:	4505                	li	a0,1
    8000315c:	00000097          	auipc	ra,0x0
    80003160:	eac080e7          	jalr	-340(ra) # 80003008 <argaddr>
  return wait(p,exit_msg);
    80003164:	fe043583          	ld	a1,-32(s0)
    80003168:	fe843503          	ld	a0,-24(s0)
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	40a080e7          	jalr	1034(ra) # 80002576 <wait>
}
    80003174:	60e2                	ld	ra,24(sp)
    80003176:	6442                	ld	s0,16(sp)
    80003178:	6105                	addi	sp,sp,32
    8000317a:	8082                	ret

000000008000317c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000317c:	7179                	addi	sp,sp,-48
    8000317e:	f406                	sd	ra,40(sp)
    80003180:	f022                	sd	s0,32(sp)
    80003182:	ec26                	sd	s1,24(sp)
    80003184:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003186:	fdc40593          	addi	a1,s0,-36
    8000318a:	4501                	li	a0,0
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	e5c080e7          	jalr	-420(ra) # 80002fe8 <argint>
  addr = myproc()->sz;
    80003194:	fffff097          	auipc	ra,0xfffff
    80003198:	818080e7          	jalr	-2024(ra) # 800019ac <myproc>
    8000319c:	7924                	ld	s1,112(a0)
  if(growproc(n) < 0)
    8000319e:	fdc42503          	lw	a0,-36(s0)
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	bfc080e7          	jalr	-1028(ra) # 80001d9e <growproc>
    800031aa:	00054863          	bltz	a0,800031ba <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800031ae:	8526                	mv	a0,s1
    800031b0:	70a2                	ld	ra,40(sp)
    800031b2:	7402                	ld	s0,32(sp)
    800031b4:	64e2                	ld	s1,24(sp)
    800031b6:	6145                	addi	sp,sp,48
    800031b8:	8082                	ret
    return -1;
    800031ba:	54fd                	li	s1,-1
    800031bc:	bfcd                	j	800031ae <sys_sbrk+0x32>

00000000800031be <sys_sleep>:

uint64
sys_sleep(void)
{
    800031be:	7139                	addi	sp,sp,-64
    800031c0:	fc06                	sd	ra,56(sp)
    800031c2:	f822                	sd	s0,48(sp)
    800031c4:	f426                	sd	s1,40(sp)
    800031c6:	f04a                	sd	s2,32(sp)
    800031c8:	ec4e                	sd	s3,24(sp)
    800031ca:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800031cc:	fcc40593          	addi	a1,s0,-52
    800031d0:	4501                	li	a0,0
    800031d2:	00000097          	auipc	ra,0x0
    800031d6:	e16080e7          	jalr	-490(ra) # 80002fe8 <argint>
  acquire(&tickslock);
    800031da:	00015517          	auipc	a0,0x15
    800031de:	de650513          	addi	a0,a0,-538 # 80017fc0 <tickslock>
    800031e2:	ffffe097          	auipc	ra,0xffffe
    800031e6:	9f4080e7          	jalr	-1548(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    800031ea:	00005917          	auipc	s2,0x5
    800031ee:	73e92903          	lw	s2,1854(s2) # 80008928 <ticks>
  while(ticks - ticks0 < n){
    800031f2:	fcc42783          	lw	a5,-52(s0)
    800031f6:	cf9d                	beqz	a5,80003234 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800031f8:	00015997          	auipc	s3,0x15
    800031fc:	dc898993          	addi	s3,s3,-568 # 80017fc0 <tickslock>
    80003200:	00005497          	auipc	s1,0x5
    80003204:	72848493          	addi	s1,s1,1832 # 80008928 <ticks>
    if(killed(myproc())){
    80003208:	ffffe097          	auipc	ra,0xffffe
    8000320c:	7a4080e7          	jalr	1956(ra) # 800019ac <myproc>
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	334080e7          	jalr	820(ra) # 80002544 <killed>
    80003218:	ed15                	bnez	a0,80003254 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000321a:	85ce                	mv	a1,s3
    8000321c:	8526                	mv	a0,s1
    8000321e:	fffff097          	auipc	ra,0xfffff
    80003222:	ffe080e7          	jalr	-2(ra) # 8000221c <sleep>
  while(ticks - ticks0 < n){
    80003226:	409c                	lw	a5,0(s1)
    80003228:	412787bb          	subw	a5,a5,s2
    8000322c:	fcc42703          	lw	a4,-52(s0)
    80003230:	fce7ece3          	bltu	a5,a4,80003208 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003234:	00015517          	auipc	a0,0x15
    80003238:	d8c50513          	addi	a0,a0,-628 # 80017fc0 <tickslock>
    8000323c:	ffffe097          	auipc	ra,0xffffe
    80003240:	a4e080e7          	jalr	-1458(ra) # 80000c8a <release>
  return 0;
    80003244:	4501                	li	a0,0
}
    80003246:	70e2                	ld	ra,56(sp)
    80003248:	7442                	ld	s0,48(sp)
    8000324a:	74a2                	ld	s1,40(sp)
    8000324c:	7902                	ld	s2,32(sp)
    8000324e:	69e2                	ld	s3,24(sp)
    80003250:	6121                	addi	sp,sp,64
    80003252:	8082                	ret
      release(&tickslock);
    80003254:	00015517          	auipc	a0,0x15
    80003258:	d6c50513          	addi	a0,a0,-660 # 80017fc0 <tickslock>
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	a2e080e7          	jalr	-1490(ra) # 80000c8a <release>
      return -1;
    80003264:	557d                	li	a0,-1
    80003266:	b7c5                	j	80003246 <sys_sleep+0x88>

0000000080003268 <sys_kill>:

uint64
sys_kill(void)
{
    80003268:	1101                	addi	sp,sp,-32
    8000326a:	ec06                	sd	ra,24(sp)
    8000326c:	e822                	sd	s0,16(sp)
    8000326e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003270:	fec40593          	addi	a1,s0,-20
    80003274:	4501                	li	a0,0
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	d72080e7          	jalr	-654(ra) # 80002fe8 <argint>
  return kill(pid);
    8000327e:	fec42503          	lw	a0,-20(s0)
    80003282:	fffff097          	auipc	ra,0xfffff
    80003286:	224080e7          	jalr	548(ra) # 800024a6 <kill>
}
    8000328a:	60e2                	ld	ra,24(sp)
    8000328c:	6442                	ld	s0,16(sp)
    8000328e:	6105                	addi	sp,sp,32
    80003290:	8082                	ret

0000000080003292 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	e426                	sd	s1,8(sp)
    8000329a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000329c:	00015517          	auipc	a0,0x15
    800032a0:	d2450513          	addi	a0,a0,-732 # 80017fc0 <tickslock>
    800032a4:	ffffe097          	auipc	ra,0xffffe
    800032a8:	932080e7          	jalr	-1742(ra) # 80000bd6 <acquire>
  xticks = ticks;
    800032ac:	00005497          	auipc	s1,0x5
    800032b0:	67c4a483          	lw	s1,1660(s1) # 80008928 <ticks>
  release(&tickslock);
    800032b4:	00015517          	auipc	a0,0x15
    800032b8:	d0c50513          	addi	a0,a0,-756 # 80017fc0 <tickslock>
    800032bc:	ffffe097          	auipc	ra,0xffffe
    800032c0:	9ce080e7          	jalr	-1586(ra) # 80000c8a <release>
  return xticks;
}
    800032c4:	02049513          	slli	a0,s1,0x20
    800032c8:	9101                	srli	a0,a0,0x20
    800032ca:	60e2                	ld	ra,24(sp)
    800032cc:	6442                	ld	s0,16(sp)
    800032ce:	64a2                	ld	s1,8(sp)
    800032d0:	6105                	addi	sp,sp,32
    800032d2:	8082                	ret

00000000800032d4 <sys_memsize>:

uint64
sys_memsize(void)
{
    800032d4:	1141                	addi	sp,sp,-16
    800032d6:	e406                	sd	ra,8(sp)
    800032d8:	e022                	sd	s0,0(sp)
    800032da:	0800                	addi	s0,sp,16
  return myproc()->sz;  
    800032dc:	ffffe097          	auipc	ra,0xffffe
    800032e0:	6d0080e7          	jalr	1744(ra) # 800019ac <myproc>
}
    800032e4:	7928                	ld	a0,112(a0)
    800032e6:	60a2                	ld	ra,8(sp)
    800032e8:	6402                	ld	s0,0(sp)
    800032ea:	0141                	addi	sp,sp,16
    800032ec:	8082                	ret

00000000800032ee <sys_set_ps_priority>:

uint64
sys_set_ps_priority(void)
{
    800032ee:	1101                	addi	sp,sp,-32
    800032f0:	ec06                	sd	ra,24(sp)
    800032f2:	e822                	sd	s0,16(sp)
    800032f4:	1000                	addi	s0,sp,32
  int new_priority;
  argint(0, &new_priority);
    800032f6:	fec40593          	addi	a1,s0,-20
    800032fa:	4501                	li	a0,0
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	cec080e7          	jalr	-788(ra) # 80002fe8 <argint>
  return set_ps_priority(new_priority);
    80003304:	fec42503          	lw	a0,-20(s0)
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	538080e7          	jalr	1336(ra) # 80002840 <set_ps_priority>
}
    80003310:	60e2                	ld	ra,24(sp)
    80003312:	6442                	ld	s0,16(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret

0000000080003318 <sys_set_cfs_priority>:

//task6
uint64
sys_set_cfs_priority(void)
{
    80003318:	1101                	addi	sp,sp,-32
    8000331a:	ec06                	sd	ra,24(sp)
    8000331c:	e822                	sd	s0,16(sp)
    8000331e:	1000                	addi	s0,sp,32
  int new_priority;
  argint(0, &new_priority);
    80003320:	fec40593          	addi	a1,s0,-20
    80003324:	4501                	li	a0,0
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	cc2080e7          	jalr	-830(ra) # 80002fe8 <argint>
  return set_cfs_priority(new_priority);
    8000332e:	fec42503          	lw	a0,-20(s0)
    80003332:	fffff097          	auipc	ra,0xfffff
    80003336:	532080e7          	jalr	1330(ra) # 80002864 <set_cfs_priority>
}
    8000333a:	60e2                	ld	ra,24(sp)
    8000333c:	6442                	ld	s0,16(sp)
    8000333e:	6105                	addi	sp,sp,32
    80003340:	8082                	ret

0000000080003342 <sys_get_cfs_stats>:

uint64
sys_get_cfs_stats(void)
{
    80003342:	7179                	addi	sp,sp,-48
    80003344:	f406                	sd	ra,40(sp)
    80003346:	f022                	sd	s0,32(sp)
    80003348:	1800                	addi	s0,sp,48
  int p;
  argint(0, &p);
    8000334a:	fec40593          	addi	a1,s0,-20
    8000334e:	4501                	li	a0,0
    80003350:	00000097          	auipc	ra,0x0
    80003354:	c98080e7          	jalr	-872(ra) # 80002fe8 <argint>

  int add1;
  argint(1, &add1);
    80003358:	fe840593          	addi	a1,s0,-24
    8000335c:	4505                	li	a0,1
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	c8a080e7          	jalr	-886(ra) # 80002fe8 <argint>

  int add2;
  argint(2, &add2);
    80003366:	fe440593          	addi	a1,s0,-28
    8000336a:	4509                	li	a0,2
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	c7c080e7          	jalr	-900(ra) # 80002fe8 <argint>

  int add3;
  argint(3, &add3);
    80003374:	fe040593          	addi	a1,s0,-32
    80003378:	450d                	li	a0,3
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	c6e080e7          	jalr	-914(ra) # 80002fe8 <argint>

 int add4;
  argint(4, &add4);
    80003382:	fdc40593          	addi	a1,s0,-36
    80003386:	4511                	li	a0,4
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	c60080e7          	jalr	-928(ra) # 80002fe8 <argint>

  return get_cfs_stats(p ,add1,add2,add3,add4);
    80003390:	fdc42703          	lw	a4,-36(s0)
    80003394:	fe042683          	lw	a3,-32(s0)
    80003398:	fe442603          	lw	a2,-28(s0)
    8000339c:	fe842583          	lw	a1,-24(s0)
    800033a0:	fec42503          	lw	a0,-20(s0)
    800033a4:	fffff097          	auipc	ra,0xfffff
    800033a8:	512080e7          	jalr	1298(ra) # 800028b6 <get_cfs_stats>
}
    800033ac:	70a2                	ld	ra,40(sp)
    800033ae:	7402                	ld	s0,32(sp)
    800033b0:	6145                	addi	sp,sp,48
    800033b2:	8082                	ret

00000000800033b4 <sys_set_policy>:

uint64
sys_set_policy(void)
{
    800033b4:	1101                	addi	sp,sp,-32
    800033b6:	ec06                	sd	ra,24(sp)
    800033b8:	e822                	sd	s0,16(sp)
    800033ba:	1000                	addi	s0,sp,32
  int new_policy;
  argint(0, &new_policy);  
    800033bc:	fec40593          	addi	a1,s0,-20
    800033c0:	4501                	li	a0,0
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	c26080e7          	jalr	-986(ra) # 80002fe8 <argint>
  return set_policy(new_policy);
    800033ca:	fec42503          	lw	a0,-20(s0)
    800033ce:	fffff097          	auipc	ra,0xfffff
    800033d2:	6b4080e7          	jalr	1716(ra) # 80002a82 <set_policy>
}
    800033d6:	60e2                	ld	ra,24(sp)
    800033d8:	6442                	ld	s0,16(sp)
    800033da:	6105                	addi	sp,sp,32
    800033dc:	8082                	ret

00000000800033de <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033de:	7179                	addi	sp,sp,-48
    800033e0:	f406                	sd	ra,40(sp)
    800033e2:	f022                	sd	s0,32(sp)
    800033e4:	ec26                	sd	s1,24(sp)
    800033e6:	e84a                	sd	s2,16(sp)
    800033e8:	e44e                	sd	s3,8(sp)
    800033ea:	e052                	sd	s4,0(sp)
    800033ec:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800033ee:	00005597          	auipc	a1,0x5
    800033f2:	14a58593          	addi	a1,a1,330 # 80008538 <syscalls+0xd8>
    800033f6:	00015517          	auipc	a0,0x15
    800033fa:	be250513          	addi	a0,a0,-1054 # 80017fd8 <bcache>
    800033fe:	ffffd097          	auipc	ra,0xffffd
    80003402:	748080e7          	jalr	1864(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003406:	0001d797          	auipc	a5,0x1d
    8000340a:	bd278793          	addi	a5,a5,-1070 # 8001ffd8 <bcache+0x8000>
    8000340e:	0001d717          	auipc	a4,0x1d
    80003412:	e3270713          	addi	a4,a4,-462 # 80020240 <bcache+0x8268>
    80003416:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000341a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000341e:	00015497          	auipc	s1,0x15
    80003422:	bd248493          	addi	s1,s1,-1070 # 80017ff0 <bcache+0x18>
    b->next = bcache.head.next;
    80003426:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003428:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000342a:	00005a17          	auipc	s4,0x5
    8000342e:	116a0a13          	addi	s4,s4,278 # 80008540 <syscalls+0xe0>
    b->next = bcache.head.next;
    80003432:	2b893783          	ld	a5,696(s2)
    80003436:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003438:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000343c:	85d2                	mv	a1,s4
    8000343e:	01048513          	addi	a0,s1,16
    80003442:	00001097          	auipc	ra,0x1
    80003446:	4c4080e7          	jalr	1220(ra) # 80004906 <initsleeplock>
    bcache.head.next->prev = b;
    8000344a:	2b893783          	ld	a5,696(s2)
    8000344e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003450:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003454:	45848493          	addi	s1,s1,1112
    80003458:	fd349de3          	bne	s1,s3,80003432 <binit+0x54>
  }
}
    8000345c:	70a2                	ld	ra,40(sp)
    8000345e:	7402                	ld	s0,32(sp)
    80003460:	64e2                	ld	s1,24(sp)
    80003462:	6942                	ld	s2,16(sp)
    80003464:	69a2                	ld	s3,8(sp)
    80003466:	6a02                	ld	s4,0(sp)
    80003468:	6145                	addi	sp,sp,48
    8000346a:	8082                	ret

000000008000346c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000346c:	7179                	addi	sp,sp,-48
    8000346e:	f406                	sd	ra,40(sp)
    80003470:	f022                	sd	s0,32(sp)
    80003472:	ec26                	sd	s1,24(sp)
    80003474:	e84a                	sd	s2,16(sp)
    80003476:	e44e                	sd	s3,8(sp)
    80003478:	1800                	addi	s0,sp,48
    8000347a:	892a                	mv	s2,a0
    8000347c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000347e:	00015517          	auipc	a0,0x15
    80003482:	b5a50513          	addi	a0,a0,-1190 # 80017fd8 <bcache>
    80003486:	ffffd097          	auipc	ra,0xffffd
    8000348a:	750080e7          	jalr	1872(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000348e:	0001d497          	auipc	s1,0x1d
    80003492:	e024b483          	ld	s1,-510(s1) # 80020290 <bcache+0x82b8>
    80003496:	0001d797          	auipc	a5,0x1d
    8000349a:	daa78793          	addi	a5,a5,-598 # 80020240 <bcache+0x8268>
    8000349e:	02f48f63          	beq	s1,a5,800034dc <bread+0x70>
    800034a2:	873e                	mv	a4,a5
    800034a4:	a021                	j	800034ac <bread+0x40>
    800034a6:	68a4                	ld	s1,80(s1)
    800034a8:	02e48a63          	beq	s1,a4,800034dc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800034ac:	449c                	lw	a5,8(s1)
    800034ae:	ff279ce3          	bne	a5,s2,800034a6 <bread+0x3a>
    800034b2:	44dc                	lw	a5,12(s1)
    800034b4:	ff3799e3          	bne	a5,s3,800034a6 <bread+0x3a>
      b->refcnt++;
    800034b8:	40bc                	lw	a5,64(s1)
    800034ba:	2785                	addiw	a5,a5,1
    800034bc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034be:	00015517          	auipc	a0,0x15
    800034c2:	b1a50513          	addi	a0,a0,-1254 # 80017fd8 <bcache>
    800034c6:	ffffd097          	auipc	ra,0xffffd
    800034ca:	7c4080e7          	jalr	1988(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800034ce:	01048513          	addi	a0,s1,16
    800034d2:	00001097          	auipc	ra,0x1
    800034d6:	46e080e7          	jalr	1134(ra) # 80004940 <acquiresleep>
      return b;
    800034da:	a8b9                	j	80003538 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034dc:	0001d497          	auipc	s1,0x1d
    800034e0:	dac4b483          	ld	s1,-596(s1) # 80020288 <bcache+0x82b0>
    800034e4:	0001d797          	auipc	a5,0x1d
    800034e8:	d5c78793          	addi	a5,a5,-676 # 80020240 <bcache+0x8268>
    800034ec:	00f48863          	beq	s1,a5,800034fc <bread+0x90>
    800034f0:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800034f2:	40bc                	lw	a5,64(s1)
    800034f4:	cf81                	beqz	a5,8000350c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034f6:	64a4                	ld	s1,72(s1)
    800034f8:	fee49de3          	bne	s1,a4,800034f2 <bread+0x86>
  panic("bget: no buffers");
    800034fc:	00005517          	auipc	a0,0x5
    80003500:	04c50513          	addi	a0,a0,76 # 80008548 <syscalls+0xe8>
    80003504:	ffffd097          	auipc	ra,0xffffd
    80003508:	03a080e7          	jalr	58(ra) # 8000053e <panic>
      b->dev = dev;
    8000350c:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003510:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003514:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003518:	4785                	li	a5,1
    8000351a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000351c:	00015517          	auipc	a0,0x15
    80003520:	abc50513          	addi	a0,a0,-1348 # 80017fd8 <bcache>
    80003524:	ffffd097          	auipc	ra,0xffffd
    80003528:	766080e7          	jalr	1894(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    8000352c:	01048513          	addi	a0,s1,16
    80003530:	00001097          	auipc	ra,0x1
    80003534:	410080e7          	jalr	1040(ra) # 80004940 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003538:	409c                	lw	a5,0(s1)
    8000353a:	cb89                	beqz	a5,8000354c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000353c:	8526                	mv	a0,s1
    8000353e:	70a2                	ld	ra,40(sp)
    80003540:	7402                	ld	s0,32(sp)
    80003542:	64e2                	ld	s1,24(sp)
    80003544:	6942                	ld	s2,16(sp)
    80003546:	69a2                	ld	s3,8(sp)
    80003548:	6145                	addi	sp,sp,48
    8000354a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000354c:	4581                	li	a1,0
    8000354e:	8526                	mv	a0,s1
    80003550:	00003097          	auipc	ra,0x3
    80003554:	fd4080e7          	jalr	-44(ra) # 80006524 <virtio_disk_rw>
    b->valid = 1;
    80003558:	4785                	li	a5,1
    8000355a:	c09c                	sw	a5,0(s1)
  return b;
    8000355c:	b7c5                	j	8000353c <bread+0xd0>

000000008000355e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000355e:	1101                	addi	sp,sp,-32
    80003560:	ec06                	sd	ra,24(sp)
    80003562:	e822                	sd	s0,16(sp)
    80003564:	e426                	sd	s1,8(sp)
    80003566:	1000                	addi	s0,sp,32
    80003568:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000356a:	0541                	addi	a0,a0,16
    8000356c:	00001097          	auipc	ra,0x1
    80003570:	46e080e7          	jalr	1134(ra) # 800049da <holdingsleep>
    80003574:	cd01                	beqz	a0,8000358c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003576:	4585                	li	a1,1
    80003578:	8526                	mv	a0,s1
    8000357a:	00003097          	auipc	ra,0x3
    8000357e:	faa080e7          	jalr	-86(ra) # 80006524 <virtio_disk_rw>
}
    80003582:	60e2                	ld	ra,24(sp)
    80003584:	6442                	ld	s0,16(sp)
    80003586:	64a2                	ld	s1,8(sp)
    80003588:	6105                	addi	sp,sp,32
    8000358a:	8082                	ret
    panic("bwrite");
    8000358c:	00005517          	auipc	a0,0x5
    80003590:	fd450513          	addi	a0,a0,-44 # 80008560 <syscalls+0x100>
    80003594:	ffffd097          	auipc	ra,0xffffd
    80003598:	faa080e7          	jalr	-86(ra) # 8000053e <panic>

000000008000359c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000359c:	1101                	addi	sp,sp,-32
    8000359e:	ec06                	sd	ra,24(sp)
    800035a0:	e822                	sd	s0,16(sp)
    800035a2:	e426                	sd	s1,8(sp)
    800035a4:	e04a                	sd	s2,0(sp)
    800035a6:	1000                	addi	s0,sp,32
    800035a8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035aa:	01050913          	addi	s2,a0,16
    800035ae:	854a                	mv	a0,s2
    800035b0:	00001097          	auipc	ra,0x1
    800035b4:	42a080e7          	jalr	1066(ra) # 800049da <holdingsleep>
    800035b8:	c92d                	beqz	a0,8000362a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800035ba:	854a                	mv	a0,s2
    800035bc:	00001097          	auipc	ra,0x1
    800035c0:	3da080e7          	jalr	986(ra) # 80004996 <releasesleep>

  acquire(&bcache.lock);
    800035c4:	00015517          	auipc	a0,0x15
    800035c8:	a1450513          	addi	a0,a0,-1516 # 80017fd8 <bcache>
    800035cc:	ffffd097          	auipc	ra,0xffffd
    800035d0:	60a080e7          	jalr	1546(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800035d4:	40bc                	lw	a5,64(s1)
    800035d6:	37fd                	addiw	a5,a5,-1
    800035d8:	0007871b          	sext.w	a4,a5
    800035dc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035de:	eb05                	bnez	a4,8000360e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035e0:	68bc                	ld	a5,80(s1)
    800035e2:	64b8                	ld	a4,72(s1)
    800035e4:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800035e6:	64bc                	ld	a5,72(s1)
    800035e8:	68b8                	ld	a4,80(s1)
    800035ea:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800035ec:	0001d797          	auipc	a5,0x1d
    800035f0:	9ec78793          	addi	a5,a5,-1556 # 8001ffd8 <bcache+0x8000>
    800035f4:	2b87b703          	ld	a4,696(a5)
    800035f8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800035fa:	0001d717          	auipc	a4,0x1d
    800035fe:	c4670713          	addi	a4,a4,-954 # 80020240 <bcache+0x8268>
    80003602:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003604:	2b87b703          	ld	a4,696(a5)
    80003608:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000360a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000360e:	00015517          	auipc	a0,0x15
    80003612:	9ca50513          	addi	a0,a0,-1590 # 80017fd8 <bcache>
    80003616:	ffffd097          	auipc	ra,0xffffd
    8000361a:	674080e7          	jalr	1652(ra) # 80000c8a <release>
}
    8000361e:	60e2                	ld	ra,24(sp)
    80003620:	6442                	ld	s0,16(sp)
    80003622:	64a2                	ld	s1,8(sp)
    80003624:	6902                	ld	s2,0(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret
    panic("brelse");
    8000362a:	00005517          	auipc	a0,0x5
    8000362e:	f3e50513          	addi	a0,a0,-194 # 80008568 <syscalls+0x108>
    80003632:	ffffd097          	auipc	ra,0xffffd
    80003636:	f0c080e7          	jalr	-244(ra) # 8000053e <panic>

000000008000363a <bpin>:

void
bpin(struct buf *b) {
    8000363a:	1101                	addi	sp,sp,-32
    8000363c:	ec06                	sd	ra,24(sp)
    8000363e:	e822                	sd	s0,16(sp)
    80003640:	e426                	sd	s1,8(sp)
    80003642:	1000                	addi	s0,sp,32
    80003644:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003646:	00015517          	auipc	a0,0x15
    8000364a:	99250513          	addi	a0,a0,-1646 # 80017fd8 <bcache>
    8000364e:	ffffd097          	auipc	ra,0xffffd
    80003652:	588080e7          	jalr	1416(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003656:	40bc                	lw	a5,64(s1)
    80003658:	2785                	addiw	a5,a5,1
    8000365a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000365c:	00015517          	auipc	a0,0x15
    80003660:	97c50513          	addi	a0,a0,-1668 # 80017fd8 <bcache>
    80003664:	ffffd097          	auipc	ra,0xffffd
    80003668:	626080e7          	jalr	1574(ra) # 80000c8a <release>
}
    8000366c:	60e2                	ld	ra,24(sp)
    8000366e:	6442                	ld	s0,16(sp)
    80003670:	64a2                	ld	s1,8(sp)
    80003672:	6105                	addi	sp,sp,32
    80003674:	8082                	ret

0000000080003676 <bunpin>:

void
bunpin(struct buf *b) {
    80003676:	1101                	addi	sp,sp,-32
    80003678:	ec06                	sd	ra,24(sp)
    8000367a:	e822                	sd	s0,16(sp)
    8000367c:	e426                	sd	s1,8(sp)
    8000367e:	1000                	addi	s0,sp,32
    80003680:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003682:	00015517          	auipc	a0,0x15
    80003686:	95650513          	addi	a0,a0,-1706 # 80017fd8 <bcache>
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	54c080e7          	jalr	1356(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003692:	40bc                	lw	a5,64(s1)
    80003694:	37fd                	addiw	a5,a5,-1
    80003696:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003698:	00015517          	auipc	a0,0x15
    8000369c:	94050513          	addi	a0,a0,-1728 # 80017fd8 <bcache>
    800036a0:	ffffd097          	auipc	ra,0xffffd
    800036a4:	5ea080e7          	jalr	1514(ra) # 80000c8a <release>
}
    800036a8:	60e2                	ld	ra,24(sp)
    800036aa:	6442                	ld	s0,16(sp)
    800036ac:	64a2                	ld	s1,8(sp)
    800036ae:	6105                	addi	sp,sp,32
    800036b0:	8082                	ret

00000000800036b2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036b2:	1101                	addi	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	e426                	sd	s1,8(sp)
    800036ba:	e04a                	sd	s2,0(sp)
    800036bc:	1000                	addi	s0,sp,32
    800036be:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800036c0:	00d5d59b          	srliw	a1,a1,0xd
    800036c4:	0001d797          	auipc	a5,0x1d
    800036c8:	ff07a783          	lw	a5,-16(a5) # 800206b4 <sb+0x1c>
    800036cc:	9dbd                	addw	a1,a1,a5
    800036ce:	00000097          	auipc	ra,0x0
    800036d2:	d9e080e7          	jalr	-610(ra) # 8000346c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800036d6:	0074f713          	andi	a4,s1,7
    800036da:	4785                	li	a5,1
    800036dc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800036e0:	14ce                	slli	s1,s1,0x33
    800036e2:	90d9                	srli	s1,s1,0x36
    800036e4:	00950733          	add	a4,a0,s1
    800036e8:	05874703          	lbu	a4,88(a4)
    800036ec:	00e7f6b3          	and	a3,a5,a4
    800036f0:	c69d                	beqz	a3,8000371e <bfree+0x6c>
    800036f2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800036f4:	94aa                	add	s1,s1,a0
    800036f6:	fff7c793          	not	a5,a5
    800036fa:	8ff9                	and	a5,a5,a4
    800036fc:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003700:	00001097          	auipc	ra,0x1
    80003704:	120080e7          	jalr	288(ra) # 80004820 <log_write>
  brelse(bp);
    80003708:	854a                	mv	a0,s2
    8000370a:	00000097          	auipc	ra,0x0
    8000370e:	e92080e7          	jalr	-366(ra) # 8000359c <brelse>
}
    80003712:	60e2                	ld	ra,24(sp)
    80003714:	6442                	ld	s0,16(sp)
    80003716:	64a2                	ld	s1,8(sp)
    80003718:	6902                	ld	s2,0(sp)
    8000371a:	6105                	addi	sp,sp,32
    8000371c:	8082                	ret
    panic("freeing free block");
    8000371e:	00005517          	auipc	a0,0x5
    80003722:	e5250513          	addi	a0,a0,-430 # 80008570 <syscalls+0x110>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	e18080e7          	jalr	-488(ra) # 8000053e <panic>

000000008000372e <balloc>:
{
    8000372e:	711d                	addi	sp,sp,-96
    80003730:	ec86                	sd	ra,88(sp)
    80003732:	e8a2                	sd	s0,80(sp)
    80003734:	e4a6                	sd	s1,72(sp)
    80003736:	e0ca                	sd	s2,64(sp)
    80003738:	fc4e                	sd	s3,56(sp)
    8000373a:	f852                	sd	s4,48(sp)
    8000373c:	f456                	sd	s5,40(sp)
    8000373e:	f05a                	sd	s6,32(sp)
    80003740:	ec5e                	sd	s7,24(sp)
    80003742:	e862                	sd	s8,16(sp)
    80003744:	e466                	sd	s9,8(sp)
    80003746:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003748:	0001d797          	auipc	a5,0x1d
    8000374c:	f547a783          	lw	a5,-172(a5) # 8002069c <sb+0x4>
    80003750:	10078163          	beqz	a5,80003852 <balloc+0x124>
    80003754:	8baa                	mv	s7,a0
    80003756:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003758:	0001db17          	auipc	s6,0x1d
    8000375c:	f40b0b13          	addi	s6,s6,-192 # 80020698 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003760:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003762:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003764:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003766:	6c89                	lui	s9,0x2
    80003768:	a061                	j	800037f0 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000376a:	974a                	add	a4,a4,s2
    8000376c:	8fd5                	or	a5,a5,a3
    8000376e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003772:	854a                	mv	a0,s2
    80003774:	00001097          	auipc	ra,0x1
    80003778:	0ac080e7          	jalr	172(ra) # 80004820 <log_write>
        brelse(bp);
    8000377c:	854a                	mv	a0,s2
    8000377e:	00000097          	auipc	ra,0x0
    80003782:	e1e080e7          	jalr	-482(ra) # 8000359c <brelse>
  bp = bread(dev, bno);
    80003786:	85a6                	mv	a1,s1
    80003788:	855e                	mv	a0,s7
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	ce2080e7          	jalr	-798(ra) # 8000346c <bread>
    80003792:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003794:	40000613          	li	a2,1024
    80003798:	4581                	li	a1,0
    8000379a:	05850513          	addi	a0,a0,88
    8000379e:	ffffd097          	auipc	ra,0xffffd
    800037a2:	534080e7          	jalr	1332(ra) # 80000cd2 <memset>
  log_write(bp);
    800037a6:	854a                	mv	a0,s2
    800037a8:	00001097          	auipc	ra,0x1
    800037ac:	078080e7          	jalr	120(ra) # 80004820 <log_write>
  brelse(bp);
    800037b0:	854a                	mv	a0,s2
    800037b2:	00000097          	auipc	ra,0x0
    800037b6:	dea080e7          	jalr	-534(ra) # 8000359c <brelse>
}
    800037ba:	8526                	mv	a0,s1
    800037bc:	60e6                	ld	ra,88(sp)
    800037be:	6446                	ld	s0,80(sp)
    800037c0:	64a6                	ld	s1,72(sp)
    800037c2:	6906                	ld	s2,64(sp)
    800037c4:	79e2                	ld	s3,56(sp)
    800037c6:	7a42                	ld	s4,48(sp)
    800037c8:	7aa2                	ld	s5,40(sp)
    800037ca:	7b02                	ld	s6,32(sp)
    800037cc:	6be2                	ld	s7,24(sp)
    800037ce:	6c42                	ld	s8,16(sp)
    800037d0:	6ca2                	ld	s9,8(sp)
    800037d2:	6125                	addi	sp,sp,96
    800037d4:	8082                	ret
    brelse(bp);
    800037d6:	854a                	mv	a0,s2
    800037d8:	00000097          	auipc	ra,0x0
    800037dc:	dc4080e7          	jalr	-572(ra) # 8000359c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037e0:	015c87bb          	addw	a5,s9,s5
    800037e4:	00078a9b          	sext.w	s5,a5
    800037e8:	004b2703          	lw	a4,4(s6)
    800037ec:	06eaf363          	bgeu	s5,a4,80003852 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800037f0:	41fad79b          	sraiw	a5,s5,0x1f
    800037f4:	0137d79b          	srliw	a5,a5,0x13
    800037f8:	015787bb          	addw	a5,a5,s5
    800037fc:	40d7d79b          	sraiw	a5,a5,0xd
    80003800:	01cb2583          	lw	a1,28(s6)
    80003804:	9dbd                	addw	a1,a1,a5
    80003806:	855e                	mv	a0,s7
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	c64080e7          	jalr	-924(ra) # 8000346c <bread>
    80003810:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003812:	004b2503          	lw	a0,4(s6)
    80003816:	000a849b          	sext.w	s1,s5
    8000381a:	8662                	mv	a2,s8
    8000381c:	faa4fde3          	bgeu	s1,a0,800037d6 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003820:	41f6579b          	sraiw	a5,a2,0x1f
    80003824:	01d7d69b          	srliw	a3,a5,0x1d
    80003828:	00c6873b          	addw	a4,a3,a2
    8000382c:	00777793          	andi	a5,a4,7
    80003830:	9f95                	subw	a5,a5,a3
    80003832:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003836:	4037571b          	sraiw	a4,a4,0x3
    8000383a:	00e906b3          	add	a3,s2,a4
    8000383e:	0586c683          	lbu	a3,88(a3)
    80003842:	00d7f5b3          	and	a1,a5,a3
    80003846:	d195                	beqz	a1,8000376a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003848:	2605                	addiw	a2,a2,1
    8000384a:	2485                	addiw	s1,s1,1
    8000384c:	fd4618e3          	bne	a2,s4,8000381c <balloc+0xee>
    80003850:	b759                	j	800037d6 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003852:	00005517          	auipc	a0,0x5
    80003856:	d3650513          	addi	a0,a0,-714 # 80008588 <syscalls+0x128>
    8000385a:	ffffd097          	auipc	ra,0xffffd
    8000385e:	d2e080e7          	jalr	-722(ra) # 80000588 <printf>
  return 0;
    80003862:	4481                	li	s1,0
    80003864:	bf99                	j	800037ba <balloc+0x8c>

0000000080003866 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003866:	7179                	addi	sp,sp,-48
    80003868:	f406                	sd	ra,40(sp)
    8000386a:	f022                	sd	s0,32(sp)
    8000386c:	ec26                	sd	s1,24(sp)
    8000386e:	e84a                	sd	s2,16(sp)
    80003870:	e44e                	sd	s3,8(sp)
    80003872:	e052                	sd	s4,0(sp)
    80003874:	1800                	addi	s0,sp,48
    80003876:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003878:	47ad                	li	a5,11
    8000387a:	02b7e763          	bltu	a5,a1,800038a8 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000387e:	02059493          	slli	s1,a1,0x20
    80003882:	9081                	srli	s1,s1,0x20
    80003884:	048a                	slli	s1,s1,0x2
    80003886:	94aa                	add	s1,s1,a0
    80003888:	0504a903          	lw	s2,80(s1)
    8000388c:	06091e63          	bnez	s2,80003908 <bmap+0xa2>
      addr = balloc(ip->dev);
    80003890:	4108                	lw	a0,0(a0)
    80003892:	00000097          	auipc	ra,0x0
    80003896:	e9c080e7          	jalr	-356(ra) # 8000372e <balloc>
    8000389a:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000389e:	06090563          	beqz	s2,80003908 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800038a2:	0524a823          	sw	s2,80(s1)
    800038a6:	a08d                	j	80003908 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038a8:	ff45849b          	addiw	s1,a1,-12
    800038ac:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800038b0:	0ff00793          	li	a5,255
    800038b4:	08e7e563          	bltu	a5,a4,8000393e <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800038b8:	08052903          	lw	s2,128(a0)
    800038bc:	00091d63          	bnez	s2,800038d6 <bmap+0x70>
      addr = balloc(ip->dev);
    800038c0:	4108                	lw	a0,0(a0)
    800038c2:	00000097          	auipc	ra,0x0
    800038c6:	e6c080e7          	jalr	-404(ra) # 8000372e <balloc>
    800038ca:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800038ce:	02090d63          	beqz	s2,80003908 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800038d2:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800038d6:	85ca                	mv	a1,s2
    800038d8:	0009a503          	lw	a0,0(s3)
    800038dc:	00000097          	auipc	ra,0x0
    800038e0:	b90080e7          	jalr	-1136(ra) # 8000346c <bread>
    800038e4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038e6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800038ea:	02049593          	slli	a1,s1,0x20
    800038ee:	9181                	srli	a1,a1,0x20
    800038f0:	058a                	slli	a1,a1,0x2
    800038f2:	00b784b3          	add	s1,a5,a1
    800038f6:	0004a903          	lw	s2,0(s1)
    800038fa:	02090063          	beqz	s2,8000391a <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800038fe:	8552                	mv	a0,s4
    80003900:	00000097          	auipc	ra,0x0
    80003904:	c9c080e7          	jalr	-868(ra) # 8000359c <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003908:	854a                	mv	a0,s2
    8000390a:	70a2                	ld	ra,40(sp)
    8000390c:	7402                	ld	s0,32(sp)
    8000390e:	64e2                	ld	s1,24(sp)
    80003910:	6942                	ld	s2,16(sp)
    80003912:	69a2                	ld	s3,8(sp)
    80003914:	6a02                	ld	s4,0(sp)
    80003916:	6145                	addi	sp,sp,48
    80003918:	8082                	ret
      addr = balloc(ip->dev);
    8000391a:	0009a503          	lw	a0,0(s3)
    8000391e:	00000097          	auipc	ra,0x0
    80003922:	e10080e7          	jalr	-496(ra) # 8000372e <balloc>
    80003926:	0005091b          	sext.w	s2,a0
      if(addr){
    8000392a:	fc090ae3          	beqz	s2,800038fe <bmap+0x98>
        a[bn] = addr;
    8000392e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003932:	8552                	mv	a0,s4
    80003934:	00001097          	auipc	ra,0x1
    80003938:	eec080e7          	jalr	-276(ra) # 80004820 <log_write>
    8000393c:	b7c9                	j	800038fe <bmap+0x98>
  panic("bmap: out of range");
    8000393e:	00005517          	auipc	a0,0x5
    80003942:	c6250513          	addi	a0,a0,-926 # 800085a0 <syscalls+0x140>
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	bf8080e7          	jalr	-1032(ra) # 8000053e <panic>

000000008000394e <iget>:
{
    8000394e:	7179                	addi	sp,sp,-48
    80003950:	f406                	sd	ra,40(sp)
    80003952:	f022                	sd	s0,32(sp)
    80003954:	ec26                	sd	s1,24(sp)
    80003956:	e84a                	sd	s2,16(sp)
    80003958:	e44e                	sd	s3,8(sp)
    8000395a:	e052                	sd	s4,0(sp)
    8000395c:	1800                	addi	s0,sp,48
    8000395e:	89aa                	mv	s3,a0
    80003960:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003962:	0001d517          	auipc	a0,0x1d
    80003966:	d5650513          	addi	a0,a0,-682 # 800206b8 <itable>
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	26c080e7          	jalr	620(ra) # 80000bd6 <acquire>
  empty = 0;
    80003972:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003974:	0001d497          	auipc	s1,0x1d
    80003978:	d5c48493          	addi	s1,s1,-676 # 800206d0 <itable+0x18>
    8000397c:	0001e697          	auipc	a3,0x1e
    80003980:	7e468693          	addi	a3,a3,2020 # 80022160 <log>
    80003984:	a039                	j	80003992 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003986:	02090b63          	beqz	s2,800039bc <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000398a:	08848493          	addi	s1,s1,136
    8000398e:	02d48a63          	beq	s1,a3,800039c2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003992:	449c                	lw	a5,8(s1)
    80003994:	fef059e3          	blez	a5,80003986 <iget+0x38>
    80003998:	4098                	lw	a4,0(s1)
    8000399a:	ff3716e3          	bne	a4,s3,80003986 <iget+0x38>
    8000399e:	40d8                	lw	a4,4(s1)
    800039a0:	ff4713e3          	bne	a4,s4,80003986 <iget+0x38>
      ip->ref++;
    800039a4:	2785                	addiw	a5,a5,1
    800039a6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039a8:	0001d517          	auipc	a0,0x1d
    800039ac:	d1050513          	addi	a0,a0,-752 # 800206b8 <itable>
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	2da080e7          	jalr	730(ra) # 80000c8a <release>
      return ip;
    800039b8:	8926                	mv	s2,s1
    800039ba:	a03d                	j	800039e8 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039bc:	f7f9                	bnez	a5,8000398a <iget+0x3c>
    800039be:	8926                	mv	s2,s1
    800039c0:	b7e9                	j	8000398a <iget+0x3c>
  if(empty == 0)
    800039c2:	02090c63          	beqz	s2,800039fa <iget+0xac>
  ip->dev = dev;
    800039c6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800039ca:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800039ce:	4785                	li	a5,1
    800039d0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800039d4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800039d8:	0001d517          	auipc	a0,0x1d
    800039dc:	ce050513          	addi	a0,a0,-800 # 800206b8 <itable>
    800039e0:	ffffd097          	auipc	ra,0xffffd
    800039e4:	2aa080e7          	jalr	682(ra) # 80000c8a <release>
}
    800039e8:	854a                	mv	a0,s2
    800039ea:	70a2                	ld	ra,40(sp)
    800039ec:	7402                	ld	s0,32(sp)
    800039ee:	64e2                	ld	s1,24(sp)
    800039f0:	6942                	ld	s2,16(sp)
    800039f2:	69a2                	ld	s3,8(sp)
    800039f4:	6a02                	ld	s4,0(sp)
    800039f6:	6145                	addi	sp,sp,48
    800039f8:	8082                	ret
    panic("iget: no inodes");
    800039fa:	00005517          	auipc	a0,0x5
    800039fe:	bbe50513          	addi	a0,a0,-1090 # 800085b8 <syscalls+0x158>
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	b3c080e7          	jalr	-1220(ra) # 8000053e <panic>

0000000080003a0a <fsinit>:
fsinit(int dev) {
    80003a0a:	7179                	addi	sp,sp,-48
    80003a0c:	f406                	sd	ra,40(sp)
    80003a0e:	f022                	sd	s0,32(sp)
    80003a10:	ec26                	sd	s1,24(sp)
    80003a12:	e84a                	sd	s2,16(sp)
    80003a14:	e44e                	sd	s3,8(sp)
    80003a16:	1800                	addi	s0,sp,48
    80003a18:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a1a:	4585                	li	a1,1
    80003a1c:	00000097          	auipc	ra,0x0
    80003a20:	a50080e7          	jalr	-1456(ra) # 8000346c <bread>
    80003a24:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a26:	0001d997          	auipc	s3,0x1d
    80003a2a:	c7298993          	addi	s3,s3,-910 # 80020698 <sb>
    80003a2e:	02000613          	li	a2,32
    80003a32:	05850593          	addi	a1,a0,88
    80003a36:	854e                	mv	a0,s3
    80003a38:	ffffd097          	auipc	ra,0xffffd
    80003a3c:	2f6080e7          	jalr	758(ra) # 80000d2e <memmove>
  brelse(bp);
    80003a40:	8526                	mv	a0,s1
    80003a42:	00000097          	auipc	ra,0x0
    80003a46:	b5a080e7          	jalr	-1190(ra) # 8000359c <brelse>
  if(sb.magic != FSMAGIC)
    80003a4a:	0009a703          	lw	a4,0(s3)
    80003a4e:	102037b7          	lui	a5,0x10203
    80003a52:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a56:	02f71263          	bne	a4,a5,80003a7a <fsinit+0x70>
  initlog(dev, &sb);
    80003a5a:	0001d597          	auipc	a1,0x1d
    80003a5e:	c3e58593          	addi	a1,a1,-962 # 80020698 <sb>
    80003a62:	854a                	mv	a0,s2
    80003a64:	00001097          	auipc	ra,0x1
    80003a68:	b40080e7          	jalr	-1216(ra) # 800045a4 <initlog>
}
    80003a6c:	70a2                	ld	ra,40(sp)
    80003a6e:	7402                	ld	s0,32(sp)
    80003a70:	64e2                	ld	s1,24(sp)
    80003a72:	6942                	ld	s2,16(sp)
    80003a74:	69a2                	ld	s3,8(sp)
    80003a76:	6145                	addi	sp,sp,48
    80003a78:	8082                	ret
    panic("invalid file system");
    80003a7a:	00005517          	auipc	a0,0x5
    80003a7e:	b4e50513          	addi	a0,a0,-1202 # 800085c8 <syscalls+0x168>
    80003a82:	ffffd097          	auipc	ra,0xffffd
    80003a86:	abc080e7          	jalr	-1348(ra) # 8000053e <panic>

0000000080003a8a <iinit>:
{
    80003a8a:	7179                	addi	sp,sp,-48
    80003a8c:	f406                	sd	ra,40(sp)
    80003a8e:	f022                	sd	s0,32(sp)
    80003a90:	ec26                	sd	s1,24(sp)
    80003a92:	e84a                	sd	s2,16(sp)
    80003a94:	e44e                	sd	s3,8(sp)
    80003a96:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003a98:	00005597          	auipc	a1,0x5
    80003a9c:	b4858593          	addi	a1,a1,-1208 # 800085e0 <syscalls+0x180>
    80003aa0:	0001d517          	auipc	a0,0x1d
    80003aa4:	c1850513          	addi	a0,a0,-1000 # 800206b8 <itable>
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	09e080e7          	jalr	158(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ab0:	0001d497          	auipc	s1,0x1d
    80003ab4:	c3048493          	addi	s1,s1,-976 # 800206e0 <itable+0x28>
    80003ab8:	0001e997          	auipc	s3,0x1e
    80003abc:	6b898993          	addi	s3,s3,1720 # 80022170 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ac0:	00005917          	auipc	s2,0x5
    80003ac4:	b2890913          	addi	s2,s2,-1240 # 800085e8 <syscalls+0x188>
    80003ac8:	85ca                	mv	a1,s2
    80003aca:	8526                	mv	a0,s1
    80003acc:	00001097          	auipc	ra,0x1
    80003ad0:	e3a080e7          	jalr	-454(ra) # 80004906 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003ad4:	08848493          	addi	s1,s1,136
    80003ad8:	ff3498e3          	bne	s1,s3,80003ac8 <iinit+0x3e>
}
    80003adc:	70a2                	ld	ra,40(sp)
    80003ade:	7402                	ld	s0,32(sp)
    80003ae0:	64e2                	ld	s1,24(sp)
    80003ae2:	6942                	ld	s2,16(sp)
    80003ae4:	69a2                	ld	s3,8(sp)
    80003ae6:	6145                	addi	sp,sp,48
    80003ae8:	8082                	ret

0000000080003aea <ialloc>:
{
    80003aea:	715d                	addi	sp,sp,-80
    80003aec:	e486                	sd	ra,72(sp)
    80003aee:	e0a2                	sd	s0,64(sp)
    80003af0:	fc26                	sd	s1,56(sp)
    80003af2:	f84a                	sd	s2,48(sp)
    80003af4:	f44e                	sd	s3,40(sp)
    80003af6:	f052                	sd	s4,32(sp)
    80003af8:	ec56                	sd	s5,24(sp)
    80003afa:	e85a                	sd	s6,16(sp)
    80003afc:	e45e                	sd	s7,8(sp)
    80003afe:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b00:	0001d717          	auipc	a4,0x1d
    80003b04:	ba472703          	lw	a4,-1116(a4) # 800206a4 <sb+0xc>
    80003b08:	4785                	li	a5,1
    80003b0a:	04e7fa63          	bgeu	a5,a4,80003b5e <ialloc+0x74>
    80003b0e:	8aaa                	mv	s5,a0
    80003b10:	8bae                	mv	s7,a1
    80003b12:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b14:	0001da17          	auipc	s4,0x1d
    80003b18:	b84a0a13          	addi	s4,s4,-1148 # 80020698 <sb>
    80003b1c:	00048b1b          	sext.w	s6,s1
    80003b20:	0044d793          	srli	a5,s1,0x4
    80003b24:	018a2583          	lw	a1,24(s4)
    80003b28:	9dbd                	addw	a1,a1,a5
    80003b2a:	8556                	mv	a0,s5
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	940080e7          	jalr	-1728(ra) # 8000346c <bread>
    80003b34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b36:	05850993          	addi	s3,a0,88
    80003b3a:	00f4f793          	andi	a5,s1,15
    80003b3e:	079a                	slli	a5,a5,0x6
    80003b40:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b42:	00099783          	lh	a5,0(s3)
    80003b46:	c3a1                	beqz	a5,80003b86 <ialloc+0x9c>
    brelse(bp);
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	a54080e7          	jalr	-1452(ra) # 8000359c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b50:	0485                	addi	s1,s1,1
    80003b52:	00ca2703          	lw	a4,12(s4)
    80003b56:	0004879b          	sext.w	a5,s1
    80003b5a:	fce7e1e3          	bltu	a5,a4,80003b1c <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003b5e:	00005517          	auipc	a0,0x5
    80003b62:	a9250513          	addi	a0,a0,-1390 # 800085f0 <syscalls+0x190>
    80003b66:	ffffd097          	auipc	ra,0xffffd
    80003b6a:	a22080e7          	jalr	-1502(ra) # 80000588 <printf>
  return 0;
    80003b6e:	4501                	li	a0,0
}
    80003b70:	60a6                	ld	ra,72(sp)
    80003b72:	6406                	ld	s0,64(sp)
    80003b74:	74e2                	ld	s1,56(sp)
    80003b76:	7942                	ld	s2,48(sp)
    80003b78:	79a2                	ld	s3,40(sp)
    80003b7a:	7a02                	ld	s4,32(sp)
    80003b7c:	6ae2                	ld	s5,24(sp)
    80003b7e:	6b42                	ld	s6,16(sp)
    80003b80:	6ba2                	ld	s7,8(sp)
    80003b82:	6161                	addi	sp,sp,80
    80003b84:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b86:	04000613          	li	a2,64
    80003b8a:	4581                	li	a1,0
    80003b8c:	854e                	mv	a0,s3
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	144080e7          	jalr	324(ra) # 80000cd2 <memset>
      dip->type = type;
    80003b96:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003b9a:	854a                	mv	a0,s2
    80003b9c:	00001097          	auipc	ra,0x1
    80003ba0:	c84080e7          	jalr	-892(ra) # 80004820 <log_write>
      brelse(bp);
    80003ba4:	854a                	mv	a0,s2
    80003ba6:	00000097          	auipc	ra,0x0
    80003baa:	9f6080e7          	jalr	-1546(ra) # 8000359c <brelse>
      return iget(dev, inum);
    80003bae:	85da                	mv	a1,s6
    80003bb0:	8556                	mv	a0,s5
    80003bb2:	00000097          	auipc	ra,0x0
    80003bb6:	d9c080e7          	jalr	-612(ra) # 8000394e <iget>
    80003bba:	bf5d                	j	80003b70 <ialloc+0x86>

0000000080003bbc <iupdate>:
{
    80003bbc:	1101                	addi	sp,sp,-32
    80003bbe:	ec06                	sd	ra,24(sp)
    80003bc0:	e822                	sd	s0,16(sp)
    80003bc2:	e426                	sd	s1,8(sp)
    80003bc4:	e04a                	sd	s2,0(sp)
    80003bc6:	1000                	addi	s0,sp,32
    80003bc8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003bca:	415c                	lw	a5,4(a0)
    80003bcc:	0047d79b          	srliw	a5,a5,0x4
    80003bd0:	0001d597          	auipc	a1,0x1d
    80003bd4:	ae05a583          	lw	a1,-1312(a1) # 800206b0 <sb+0x18>
    80003bd8:	9dbd                	addw	a1,a1,a5
    80003bda:	4108                	lw	a0,0(a0)
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	890080e7          	jalr	-1904(ra) # 8000346c <bread>
    80003be4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003be6:	05850793          	addi	a5,a0,88
    80003bea:	40c8                	lw	a0,4(s1)
    80003bec:	893d                	andi	a0,a0,15
    80003bee:	051a                	slli	a0,a0,0x6
    80003bf0:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003bf2:	04449703          	lh	a4,68(s1)
    80003bf6:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003bfa:	04649703          	lh	a4,70(s1)
    80003bfe:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003c02:	04849703          	lh	a4,72(s1)
    80003c06:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003c0a:	04a49703          	lh	a4,74(s1)
    80003c0e:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003c12:	44f8                	lw	a4,76(s1)
    80003c14:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c16:	03400613          	li	a2,52
    80003c1a:	05048593          	addi	a1,s1,80
    80003c1e:	0531                	addi	a0,a0,12
    80003c20:	ffffd097          	auipc	ra,0xffffd
    80003c24:	10e080e7          	jalr	270(ra) # 80000d2e <memmove>
  log_write(bp);
    80003c28:	854a                	mv	a0,s2
    80003c2a:	00001097          	auipc	ra,0x1
    80003c2e:	bf6080e7          	jalr	-1034(ra) # 80004820 <log_write>
  brelse(bp);
    80003c32:	854a                	mv	a0,s2
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	968080e7          	jalr	-1688(ra) # 8000359c <brelse>
}
    80003c3c:	60e2                	ld	ra,24(sp)
    80003c3e:	6442                	ld	s0,16(sp)
    80003c40:	64a2                	ld	s1,8(sp)
    80003c42:	6902                	ld	s2,0(sp)
    80003c44:	6105                	addi	sp,sp,32
    80003c46:	8082                	ret

0000000080003c48 <idup>:
{
    80003c48:	1101                	addi	sp,sp,-32
    80003c4a:	ec06                	sd	ra,24(sp)
    80003c4c:	e822                	sd	s0,16(sp)
    80003c4e:	e426                	sd	s1,8(sp)
    80003c50:	1000                	addi	s0,sp,32
    80003c52:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c54:	0001d517          	auipc	a0,0x1d
    80003c58:	a6450513          	addi	a0,a0,-1436 # 800206b8 <itable>
    80003c5c:	ffffd097          	auipc	ra,0xffffd
    80003c60:	f7a080e7          	jalr	-134(ra) # 80000bd6 <acquire>
  ip->ref++;
    80003c64:	449c                	lw	a5,8(s1)
    80003c66:	2785                	addiw	a5,a5,1
    80003c68:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c6a:	0001d517          	auipc	a0,0x1d
    80003c6e:	a4e50513          	addi	a0,a0,-1458 # 800206b8 <itable>
    80003c72:	ffffd097          	auipc	ra,0xffffd
    80003c76:	018080e7          	jalr	24(ra) # 80000c8a <release>
}
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	60e2                	ld	ra,24(sp)
    80003c7e:	6442                	ld	s0,16(sp)
    80003c80:	64a2                	ld	s1,8(sp)
    80003c82:	6105                	addi	sp,sp,32
    80003c84:	8082                	ret

0000000080003c86 <ilock>:
{
    80003c86:	1101                	addi	sp,sp,-32
    80003c88:	ec06                	sd	ra,24(sp)
    80003c8a:	e822                	sd	s0,16(sp)
    80003c8c:	e426                	sd	s1,8(sp)
    80003c8e:	e04a                	sd	s2,0(sp)
    80003c90:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003c92:	c115                	beqz	a0,80003cb6 <ilock+0x30>
    80003c94:	84aa                	mv	s1,a0
    80003c96:	451c                	lw	a5,8(a0)
    80003c98:	00f05f63          	blez	a5,80003cb6 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003c9c:	0541                	addi	a0,a0,16
    80003c9e:	00001097          	auipc	ra,0x1
    80003ca2:	ca2080e7          	jalr	-862(ra) # 80004940 <acquiresleep>
  if(ip->valid == 0){
    80003ca6:	40bc                	lw	a5,64(s1)
    80003ca8:	cf99                	beqz	a5,80003cc6 <ilock+0x40>
}
    80003caa:	60e2                	ld	ra,24(sp)
    80003cac:	6442                	ld	s0,16(sp)
    80003cae:	64a2                	ld	s1,8(sp)
    80003cb0:	6902                	ld	s2,0(sp)
    80003cb2:	6105                	addi	sp,sp,32
    80003cb4:	8082                	ret
    panic("ilock");
    80003cb6:	00005517          	auipc	a0,0x5
    80003cba:	95250513          	addi	a0,a0,-1710 # 80008608 <syscalls+0x1a8>
    80003cbe:	ffffd097          	auipc	ra,0xffffd
    80003cc2:	880080e7          	jalr	-1920(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cc6:	40dc                	lw	a5,4(s1)
    80003cc8:	0047d79b          	srliw	a5,a5,0x4
    80003ccc:	0001d597          	auipc	a1,0x1d
    80003cd0:	9e45a583          	lw	a1,-1564(a1) # 800206b0 <sb+0x18>
    80003cd4:	9dbd                	addw	a1,a1,a5
    80003cd6:	4088                	lw	a0,0(s1)
    80003cd8:	fffff097          	auipc	ra,0xfffff
    80003cdc:	794080e7          	jalr	1940(ra) # 8000346c <bread>
    80003ce0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ce2:	05850593          	addi	a1,a0,88
    80003ce6:	40dc                	lw	a5,4(s1)
    80003ce8:	8bbd                	andi	a5,a5,15
    80003cea:	079a                	slli	a5,a5,0x6
    80003cec:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003cee:	00059783          	lh	a5,0(a1)
    80003cf2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003cf6:	00259783          	lh	a5,2(a1)
    80003cfa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003cfe:	00459783          	lh	a5,4(a1)
    80003d02:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d06:	00659783          	lh	a5,6(a1)
    80003d0a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d0e:	459c                	lw	a5,8(a1)
    80003d10:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d12:	03400613          	li	a2,52
    80003d16:	05b1                	addi	a1,a1,12
    80003d18:	05048513          	addi	a0,s1,80
    80003d1c:	ffffd097          	auipc	ra,0xffffd
    80003d20:	012080e7          	jalr	18(ra) # 80000d2e <memmove>
    brelse(bp);
    80003d24:	854a                	mv	a0,s2
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	876080e7          	jalr	-1930(ra) # 8000359c <brelse>
    ip->valid = 1;
    80003d2e:	4785                	li	a5,1
    80003d30:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d32:	04449783          	lh	a5,68(s1)
    80003d36:	fbb5                	bnez	a5,80003caa <ilock+0x24>
      panic("ilock: no type");
    80003d38:	00005517          	auipc	a0,0x5
    80003d3c:	8d850513          	addi	a0,a0,-1832 # 80008610 <syscalls+0x1b0>
    80003d40:	ffffc097          	auipc	ra,0xffffc
    80003d44:	7fe080e7          	jalr	2046(ra) # 8000053e <panic>

0000000080003d48 <iunlock>:
{
    80003d48:	1101                	addi	sp,sp,-32
    80003d4a:	ec06                	sd	ra,24(sp)
    80003d4c:	e822                	sd	s0,16(sp)
    80003d4e:	e426                	sd	s1,8(sp)
    80003d50:	e04a                	sd	s2,0(sp)
    80003d52:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d54:	c905                	beqz	a0,80003d84 <iunlock+0x3c>
    80003d56:	84aa                	mv	s1,a0
    80003d58:	01050913          	addi	s2,a0,16
    80003d5c:	854a                	mv	a0,s2
    80003d5e:	00001097          	auipc	ra,0x1
    80003d62:	c7c080e7          	jalr	-900(ra) # 800049da <holdingsleep>
    80003d66:	cd19                	beqz	a0,80003d84 <iunlock+0x3c>
    80003d68:	449c                	lw	a5,8(s1)
    80003d6a:	00f05d63          	blez	a5,80003d84 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d6e:	854a                	mv	a0,s2
    80003d70:	00001097          	auipc	ra,0x1
    80003d74:	c26080e7          	jalr	-986(ra) # 80004996 <releasesleep>
}
    80003d78:	60e2                	ld	ra,24(sp)
    80003d7a:	6442                	ld	s0,16(sp)
    80003d7c:	64a2                	ld	s1,8(sp)
    80003d7e:	6902                	ld	s2,0(sp)
    80003d80:	6105                	addi	sp,sp,32
    80003d82:	8082                	ret
    panic("iunlock");
    80003d84:	00005517          	auipc	a0,0x5
    80003d88:	89c50513          	addi	a0,a0,-1892 # 80008620 <syscalls+0x1c0>
    80003d8c:	ffffc097          	auipc	ra,0xffffc
    80003d90:	7b2080e7          	jalr	1970(ra) # 8000053e <panic>

0000000080003d94 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003d94:	7179                	addi	sp,sp,-48
    80003d96:	f406                	sd	ra,40(sp)
    80003d98:	f022                	sd	s0,32(sp)
    80003d9a:	ec26                	sd	s1,24(sp)
    80003d9c:	e84a                	sd	s2,16(sp)
    80003d9e:	e44e                	sd	s3,8(sp)
    80003da0:	e052                	sd	s4,0(sp)
    80003da2:	1800                	addi	s0,sp,48
    80003da4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003da6:	05050493          	addi	s1,a0,80
    80003daa:	08050913          	addi	s2,a0,128
    80003dae:	a021                	j	80003db6 <itrunc+0x22>
    80003db0:	0491                	addi	s1,s1,4
    80003db2:	01248d63          	beq	s1,s2,80003dcc <itrunc+0x38>
    if(ip->addrs[i]){
    80003db6:	408c                	lw	a1,0(s1)
    80003db8:	dde5                	beqz	a1,80003db0 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003dba:	0009a503          	lw	a0,0(s3)
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	8f4080e7          	jalr	-1804(ra) # 800036b2 <bfree>
      ip->addrs[i] = 0;
    80003dc6:	0004a023          	sw	zero,0(s1)
    80003dca:	b7dd                	j	80003db0 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003dcc:	0809a583          	lw	a1,128(s3)
    80003dd0:	e185                	bnez	a1,80003df0 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003dd2:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003dd6:	854e                	mv	a0,s3
    80003dd8:	00000097          	auipc	ra,0x0
    80003ddc:	de4080e7          	jalr	-540(ra) # 80003bbc <iupdate>
}
    80003de0:	70a2                	ld	ra,40(sp)
    80003de2:	7402                	ld	s0,32(sp)
    80003de4:	64e2                	ld	s1,24(sp)
    80003de6:	6942                	ld	s2,16(sp)
    80003de8:	69a2                	ld	s3,8(sp)
    80003dea:	6a02                	ld	s4,0(sp)
    80003dec:	6145                	addi	sp,sp,48
    80003dee:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003df0:	0009a503          	lw	a0,0(s3)
    80003df4:	fffff097          	auipc	ra,0xfffff
    80003df8:	678080e7          	jalr	1656(ra) # 8000346c <bread>
    80003dfc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003dfe:	05850493          	addi	s1,a0,88
    80003e02:	45850913          	addi	s2,a0,1112
    80003e06:	a021                	j	80003e0e <itrunc+0x7a>
    80003e08:	0491                	addi	s1,s1,4
    80003e0a:	01248b63          	beq	s1,s2,80003e20 <itrunc+0x8c>
      if(a[j])
    80003e0e:	408c                	lw	a1,0(s1)
    80003e10:	dde5                	beqz	a1,80003e08 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003e12:	0009a503          	lw	a0,0(s3)
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	89c080e7          	jalr	-1892(ra) # 800036b2 <bfree>
    80003e1e:	b7ed                	j	80003e08 <itrunc+0x74>
    brelse(bp);
    80003e20:	8552                	mv	a0,s4
    80003e22:	fffff097          	auipc	ra,0xfffff
    80003e26:	77a080e7          	jalr	1914(ra) # 8000359c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e2a:	0809a583          	lw	a1,128(s3)
    80003e2e:	0009a503          	lw	a0,0(s3)
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	880080e7          	jalr	-1920(ra) # 800036b2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e3a:	0809a023          	sw	zero,128(s3)
    80003e3e:	bf51                	j	80003dd2 <itrunc+0x3e>

0000000080003e40 <iput>:
{
    80003e40:	1101                	addi	sp,sp,-32
    80003e42:	ec06                	sd	ra,24(sp)
    80003e44:	e822                	sd	s0,16(sp)
    80003e46:	e426                	sd	s1,8(sp)
    80003e48:	e04a                	sd	s2,0(sp)
    80003e4a:	1000                	addi	s0,sp,32
    80003e4c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e4e:	0001d517          	auipc	a0,0x1d
    80003e52:	86a50513          	addi	a0,a0,-1942 # 800206b8 <itable>
    80003e56:	ffffd097          	auipc	ra,0xffffd
    80003e5a:	d80080e7          	jalr	-640(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e5e:	4498                	lw	a4,8(s1)
    80003e60:	4785                	li	a5,1
    80003e62:	02f70363          	beq	a4,a5,80003e88 <iput+0x48>
  ip->ref--;
    80003e66:	449c                	lw	a5,8(s1)
    80003e68:	37fd                	addiw	a5,a5,-1
    80003e6a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e6c:	0001d517          	auipc	a0,0x1d
    80003e70:	84c50513          	addi	a0,a0,-1972 # 800206b8 <itable>
    80003e74:	ffffd097          	auipc	ra,0xffffd
    80003e78:	e16080e7          	jalr	-490(ra) # 80000c8a <release>
}
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6902                	ld	s2,0(sp)
    80003e84:	6105                	addi	sp,sp,32
    80003e86:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e88:	40bc                	lw	a5,64(s1)
    80003e8a:	dff1                	beqz	a5,80003e66 <iput+0x26>
    80003e8c:	04a49783          	lh	a5,74(s1)
    80003e90:	fbf9                	bnez	a5,80003e66 <iput+0x26>
    acquiresleep(&ip->lock);
    80003e92:	01048913          	addi	s2,s1,16
    80003e96:	854a                	mv	a0,s2
    80003e98:	00001097          	auipc	ra,0x1
    80003e9c:	aa8080e7          	jalr	-1368(ra) # 80004940 <acquiresleep>
    release(&itable.lock);
    80003ea0:	0001d517          	auipc	a0,0x1d
    80003ea4:	81850513          	addi	a0,a0,-2024 # 800206b8 <itable>
    80003ea8:	ffffd097          	auipc	ra,0xffffd
    80003eac:	de2080e7          	jalr	-542(ra) # 80000c8a <release>
    itrunc(ip);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	ee2080e7          	jalr	-286(ra) # 80003d94 <itrunc>
    ip->type = 0;
    80003eba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	00000097          	auipc	ra,0x0
    80003ec4:	cfc080e7          	jalr	-772(ra) # 80003bbc <iupdate>
    ip->valid = 0;
    80003ec8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ecc:	854a                	mv	a0,s2
    80003ece:	00001097          	auipc	ra,0x1
    80003ed2:	ac8080e7          	jalr	-1336(ra) # 80004996 <releasesleep>
    acquire(&itable.lock);
    80003ed6:	0001c517          	auipc	a0,0x1c
    80003eda:	7e250513          	addi	a0,a0,2018 # 800206b8 <itable>
    80003ede:	ffffd097          	auipc	ra,0xffffd
    80003ee2:	cf8080e7          	jalr	-776(ra) # 80000bd6 <acquire>
    80003ee6:	b741                	j	80003e66 <iput+0x26>

0000000080003ee8 <iunlockput>:
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	1000                	addi	s0,sp,32
    80003ef2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	e54080e7          	jalr	-428(ra) # 80003d48 <iunlock>
  iput(ip);
    80003efc:	8526                	mv	a0,s1
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	f42080e7          	jalr	-190(ra) # 80003e40 <iput>
}
    80003f06:	60e2                	ld	ra,24(sp)
    80003f08:	6442                	ld	s0,16(sp)
    80003f0a:	64a2                	ld	s1,8(sp)
    80003f0c:	6105                	addi	sp,sp,32
    80003f0e:	8082                	ret

0000000080003f10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f10:	1141                	addi	sp,sp,-16
    80003f12:	e422                	sd	s0,8(sp)
    80003f14:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f16:	411c                	lw	a5,0(a0)
    80003f18:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f1a:	415c                	lw	a5,4(a0)
    80003f1c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f1e:	04451783          	lh	a5,68(a0)
    80003f22:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f26:	04a51783          	lh	a5,74(a0)
    80003f2a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f2e:	04c56783          	lwu	a5,76(a0)
    80003f32:	e99c                	sd	a5,16(a1)
}
    80003f34:	6422                	ld	s0,8(sp)
    80003f36:	0141                	addi	sp,sp,16
    80003f38:	8082                	ret

0000000080003f3a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f3a:	457c                	lw	a5,76(a0)
    80003f3c:	0ed7e963          	bltu	a5,a3,8000402e <readi+0xf4>
{
    80003f40:	7159                	addi	sp,sp,-112
    80003f42:	f486                	sd	ra,104(sp)
    80003f44:	f0a2                	sd	s0,96(sp)
    80003f46:	eca6                	sd	s1,88(sp)
    80003f48:	e8ca                	sd	s2,80(sp)
    80003f4a:	e4ce                	sd	s3,72(sp)
    80003f4c:	e0d2                	sd	s4,64(sp)
    80003f4e:	fc56                	sd	s5,56(sp)
    80003f50:	f85a                	sd	s6,48(sp)
    80003f52:	f45e                	sd	s7,40(sp)
    80003f54:	f062                	sd	s8,32(sp)
    80003f56:	ec66                	sd	s9,24(sp)
    80003f58:	e86a                	sd	s10,16(sp)
    80003f5a:	e46e                	sd	s11,8(sp)
    80003f5c:	1880                	addi	s0,sp,112
    80003f5e:	8b2a                	mv	s6,a0
    80003f60:	8bae                	mv	s7,a1
    80003f62:	8a32                	mv	s4,a2
    80003f64:	84b6                	mv	s1,a3
    80003f66:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f68:	9f35                	addw	a4,a4,a3
    return 0;
    80003f6a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f6c:	0ad76063          	bltu	a4,a3,8000400c <readi+0xd2>
  if(off + n > ip->size)
    80003f70:	00e7f463          	bgeu	a5,a4,80003f78 <readi+0x3e>
    n = ip->size - off;
    80003f74:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f78:	0a0a8963          	beqz	s5,8000402a <readi+0xf0>
    80003f7c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f7e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f82:	5c7d                	li	s8,-1
    80003f84:	a82d                	j	80003fbe <readi+0x84>
    80003f86:	020d1d93          	slli	s11,s10,0x20
    80003f8a:	020ddd93          	srli	s11,s11,0x20
    80003f8e:	05890793          	addi	a5,s2,88
    80003f92:	86ee                	mv	a3,s11
    80003f94:	963e                	add	a2,a2,a5
    80003f96:	85d2                	mv	a1,s4
    80003f98:	855e                	mv	a0,s7
    80003f9a:	ffffe097          	auipc	ra,0xffffe
    80003f9e:	74c080e7          	jalr	1868(ra) # 800026e6 <either_copyout>
    80003fa2:	05850d63          	beq	a0,s8,80003ffc <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fa6:	854a                	mv	a0,s2
    80003fa8:	fffff097          	auipc	ra,0xfffff
    80003fac:	5f4080e7          	jalr	1524(ra) # 8000359c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fb0:	013d09bb          	addw	s3,s10,s3
    80003fb4:	009d04bb          	addw	s1,s10,s1
    80003fb8:	9a6e                	add	s4,s4,s11
    80003fba:	0559f763          	bgeu	s3,s5,80004008 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003fbe:	00a4d59b          	srliw	a1,s1,0xa
    80003fc2:	855a                	mv	a0,s6
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	8a2080e7          	jalr	-1886(ra) # 80003866 <bmap>
    80003fcc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003fd0:	cd85                	beqz	a1,80004008 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003fd2:	000b2503          	lw	a0,0(s6)
    80003fd6:	fffff097          	auipc	ra,0xfffff
    80003fda:	496080e7          	jalr	1174(ra) # 8000346c <bread>
    80003fde:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fe0:	3ff4f613          	andi	a2,s1,1023
    80003fe4:	40cc87bb          	subw	a5,s9,a2
    80003fe8:	413a873b          	subw	a4,s5,s3
    80003fec:	8d3e                	mv	s10,a5
    80003fee:	2781                	sext.w	a5,a5
    80003ff0:	0007069b          	sext.w	a3,a4
    80003ff4:	f8f6f9e3          	bgeu	a3,a5,80003f86 <readi+0x4c>
    80003ff8:	8d3a                	mv	s10,a4
    80003ffa:	b771                	j	80003f86 <readi+0x4c>
      brelse(bp);
    80003ffc:	854a                	mv	a0,s2
    80003ffe:	fffff097          	auipc	ra,0xfffff
    80004002:	59e080e7          	jalr	1438(ra) # 8000359c <brelse>
      tot = -1;
    80004006:	59fd                	li	s3,-1
  }
  return tot;
    80004008:	0009851b          	sext.w	a0,s3
}
    8000400c:	70a6                	ld	ra,104(sp)
    8000400e:	7406                	ld	s0,96(sp)
    80004010:	64e6                	ld	s1,88(sp)
    80004012:	6946                	ld	s2,80(sp)
    80004014:	69a6                	ld	s3,72(sp)
    80004016:	6a06                	ld	s4,64(sp)
    80004018:	7ae2                	ld	s5,56(sp)
    8000401a:	7b42                	ld	s6,48(sp)
    8000401c:	7ba2                	ld	s7,40(sp)
    8000401e:	7c02                	ld	s8,32(sp)
    80004020:	6ce2                	ld	s9,24(sp)
    80004022:	6d42                	ld	s10,16(sp)
    80004024:	6da2                	ld	s11,8(sp)
    80004026:	6165                	addi	sp,sp,112
    80004028:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000402a:	89d6                	mv	s3,s5
    8000402c:	bff1                	j	80004008 <readi+0xce>
    return 0;
    8000402e:	4501                	li	a0,0
}
    80004030:	8082                	ret

0000000080004032 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004032:	457c                	lw	a5,76(a0)
    80004034:	10d7e863          	bltu	a5,a3,80004144 <writei+0x112>
{
    80004038:	7159                	addi	sp,sp,-112
    8000403a:	f486                	sd	ra,104(sp)
    8000403c:	f0a2                	sd	s0,96(sp)
    8000403e:	eca6                	sd	s1,88(sp)
    80004040:	e8ca                	sd	s2,80(sp)
    80004042:	e4ce                	sd	s3,72(sp)
    80004044:	e0d2                	sd	s4,64(sp)
    80004046:	fc56                	sd	s5,56(sp)
    80004048:	f85a                	sd	s6,48(sp)
    8000404a:	f45e                	sd	s7,40(sp)
    8000404c:	f062                	sd	s8,32(sp)
    8000404e:	ec66                	sd	s9,24(sp)
    80004050:	e86a                	sd	s10,16(sp)
    80004052:	e46e                	sd	s11,8(sp)
    80004054:	1880                	addi	s0,sp,112
    80004056:	8aaa                	mv	s5,a0
    80004058:	8bae                	mv	s7,a1
    8000405a:	8a32                	mv	s4,a2
    8000405c:	8936                	mv	s2,a3
    8000405e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004060:	00e687bb          	addw	a5,a3,a4
    80004064:	0ed7e263          	bltu	a5,a3,80004148 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004068:	00043737          	lui	a4,0x43
    8000406c:	0ef76063          	bltu	a4,a5,8000414c <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004070:	0c0b0863          	beqz	s6,80004140 <writei+0x10e>
    80004074:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004076:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000407a:	5c7d                	li	s8,-1
    8000407c:	a091                	j	800040c0 <writei+0x8e>
    8000407e:	020d1d93          	slli	s11,s10,0x20
    80004082:	020ddd93          	srli	s11,s11,0x20
    80004086:	05848793          	addi	a5,s1,88
    8000408a:	86ee                	mv	a3,s11
    8000408c:	8652                	mv	a2,s4
    8000408e:	85de                	mv	a1,s7
    80004090:	953e                	add	a0,a0,a5
    80004092:	ffffe097          	auipc	ra,0xffffe
    80004096:	6aa080e7          	jalr	1706(ra) # 8000273c <either_copyin>
    8000409a:	07850263          	beq	a0,s8,800040fe <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000409e:	8526                	mv	a0,s1
    800040a0:	00000097          	auipc	ra,0x0
    800040a4:	780080e7          	jalr	1920(ra) # 80004820 <log_write>
    brelse(bp);
    800040a8:	8526                	mv	a0,s1
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	4f2080e7          	jalr	1266(ra) # 8000359c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040b2:	013d09bb          	addw	s3,s10,s3
    800040b6:	012d093b          	addw	s2,s10,s2
    800040ba:	9a6e                	add	s4,s4,s11
    800040bc:	0569f663          	bgeu	s3,s6,80004108 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800040c0:	00a9559b          	srliw	a1,s2,0xa
    800040c4:	8556                	mv	a0,s5
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	7a0080e7          	jalr	1952(ra) # 80003866 <bmap>
    800040ce:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800040d2:	c99d                	beqz	a1,80004108 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800040d4:	000aa503          	lw	a0,0(s5)
    800040d8:	fffff097          	auipc	ra,0xfffff
    800040dc:	394080e7          	jalr	916(ra) # 8000346c <bread>
    800040e0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040e2:	3ff97513          	andi	a0,s2,1023
    800040e6:	40ac87bb          	subw	a5,s9,a0
    800040ea:	413b073b          	subw	a4,s6,s3
    800040ee:	8d3e                	mv	s10,a5
    800040f0:	2781                	sext.w	a5,a5
    800040f2:	0007069b          	sext.w	a3,a4
    800040f6:	f8f6f4e3          	bgeu	a3,a5,8000407e <writei+0x4c>
    800040fa:	8d3a                	mv	s10,a4
    800040fc:	b749                	j	8000407e <writei+0x4c>
      brelse(bp);
    800040fe:	8526                	mv	a0,s1
    80004100:	fffff097          	auipc	ra,0xfffff
    80004104:	49c080e7          	jalr	1180(ra) # 8000359c <brelse>
  }

  if(off > ip->size)
    80004108:	04caa783          	lw	a5,76(s5)
    8000410c:	0127f463          	bgeu	a5,s2,80004114 <writei+0xe2>
    ip->size = off;
    80004110:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004114:	8556                	mv	a0,s5
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	aa6080e7          	jalr	-1370(ra) # 80003bbc <iupdate>

  return tot;
    8000411e:	0009851b          	sext.w	a0,s3
}
    80004122:	70a6                	ld	ra,104(sp)
    80004124:	7406                	ld	s0,96(sp)
    80004126:	64e6                	ld	s1,88(sp)
    80004128:	6946                	ld	s2,80(sp)
    8000412a:	69a6                	ld	s3,72(sp)
    8000412c:	6a06                	ld	s4,64(sp)
    8000412e:	7ae2                	ld	s5,56(sp)
    80004130:	7b42                	ld	s6,48(sp)
    80004132:	7ba2                	ld	s7,40(sp)
    80004134:	7c02                	ld	s8,32(sp)
    80004136:	6ce2                	ld	s9,24(sp)
    80004138:	6d42                	ld	s10,16(sp)
    8000413a:	6da2                	ld	s11,8(sp)
    8000413c:	6165                	addi	sp,sp,112
    8000413e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004140:	89da                	mv	s3,s6
    80004142:	bfc9                	j	80004114 <writei+0xe2>
    return -1;
    80004144:	557d                	li	a0,-1
}
    80004146:	8082                	ret
    return -1;
    80004148:	557d                	li	a0,-1
    8000414a:	bfe1                	j	80004122 <writei+0xf0>
    return -1;
    8000414c:	557d                	li	a0,-1
    8000414e:	bfd1                	j	80004122 <writei+0xf0>

0000000080004150 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004150:	1141                	addi	sp,sp,-16
    80004152:	e406                	sd	ra,8(sp)
    80004154:	e022                	sd	s0,0(sp)
    80004156:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004158:	4639                	li	a2,14
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	c48080e7          	jalr	-952(ra) # 80000da2 <strncmp>
}
    80004162:	60a2                	ld	ra,8(sp)
    80004164:	6402                	ld	s0,0(sp)
    80004166:	0141                	addi	sp,sp,16
    80004168:	8082                	ret

000000008000416a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000416a:	7139                	addi	sp,sp,-64
    8000416c:	fc06                	sd	ra,56(sp)
    8000416e:	f822                	sd	s0,48(sp)
    80004170:	f426                	sd	s1,40(sp)
    80004172:	f04a                	sd	s2,32(sp)
    80004174:	ec4e                	sd	s3,24(sp)
    80004176:	e852                	sd	s4,16(sp)
    80004178:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000417a:	04451703          	lh	a4,68(a0)
    8000417e:	4785                	li	a5,1
    80004180:	00f71a63          	bne	a4,a5,80004194 <dirlookup+0x2a>
    80004184:	892a                	mv	s2,a0
    80004186:	89ae                	mv	s3,a1
    80004188:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000418a:	457c                	lw	a5,76(a0)
    8000418c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000418e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004190:	e79d                	bnez	a5,800041be <dirlookup+0x54>
    80004192:	a8a5                	j	8000420a <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004194:	00004517          	auipc	a0,0x4
    80004198:	49450513          	addi	a0,a0,1172 # 80008628 <syscalls+0x1c8>
    8000419c:	ffffc097          	auipc	ra,0xffffc
    800041a0:	3a2080e7          	jalr	930(ra) # 8000053e <panic>
      panic("dirlookup read");
    800041a4:	00004517          	auipc	a0,0x4
    800041a8:	49c50513          	addi	a0,a0,1180 # 80008640 <syscalls+0x1e0>
    800041ac:	ffffc097          	auipc	ra,0xffffc
    800041b0:	392080e7          	jalr	914(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041b4:	24c1                	addiw	s1,s1,16
    800041b6:	04c92783          	lw	a5,76(s2)
    800041ba:	04f4f763          	bgeu	s1,a5,80004208 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041be:	4741                	li	a4,16
    800041c0:	86a6                	mv	a3,s1
    800041c2:	fc040613          	addi	a2,s0,-64
    800041c6:	4581                	li	a1,0
    800041c8:	854a                	mv	a0,s2
    800041ca:	00000097          	auipc	ra,0x0
    800041ce:	d70080e7          	jalr	-656(ra) # 80003f3a <readi>
    800041d2:	47c1                	li	a5,16
    800041d4:	fcf518e3          	bne	a0,a5,800041a4 <dirlookup+0x3a>
    if(de.inum == 0)
    800041d8:	fc045783          	lhu	a5,-64(s0)
    800041dc:	dfe1                	beqz	a5,800041b4 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800041de:	fc240593          	addi	a1,s0,-62
    800041e2:	854e                	mv	a0,s3
    800041e4:	00000097          	auipc	ra,0x0
    800041e8:	f6c080e7          	jalr	-148(ra) # 80004150 <namecmp>
    800041ec:	f561                	bnez	a0,800041b4 <dirlookup+0x4a>
      if(poff)
    800041ee:	000a0463          	beqz	s4,800041f6 <dirlookup+0x8c>
        *poff = off;
    800041f2:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800041f6:	fc045583          	lhu	a1,-64(s0)
    800041fa:	00092503          	lw	a0,0(s2)
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	750080e7          	jalr	1872(ra) # 8000394e <iget>
    80004206:	a011                	j	8000420a <dirlookup+0xa0>
  return 0;
    80004208:	4501                	li	a0,0
}
    8000420a:	70e2                	ld	ra,56(sp)
    8000420c:	7442                	ld	s0,48(sp)
    8000420e:	74a2                	ld	s1,40(sp)
    80004210:	7902                	ld	s2,32(sp)
    80004212:	69e2                	ld	s3,24(sp)
    80004214:	6a42                	ld	s4,16(sp)
    80004216:	6121                	addi	sp,sp,64
    80004218:	8082                	ret

000000008000421a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000421a:	711d                	addi	sp,sp,-96
    8000421c:	ec86                	sd	ra,88(sp)
    8000421e:	e8a2                	sd	s0,80(sp)
    80004220:	e4a6                	sd	s1,72(sp)
    80004222:	e0ca                	sd	s2,64(sp)
    80004224:	fc4e                	sd	s3,56(sp)
    80004226:	f852                	sd	s4,48(sp)
    80004228:	f456                	sd	s5,40(sp)
    8000422a:	f05a                	sd	s6,32(sp)
    8000422c:	ec5e                	sd	s7,24(sp)
    8000422e:	e862                	sd	s8,16(sp)
    80004230:	e466                	sd	s9,8(sp)
    80004232:	1080                	addi	s0,sp,96
    80004234:	84aa                	mv	s1,a0
    80004236:	8aae                	mv	s5,a1
    80004238:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000423a:	00054703          	lbu	a4,0(a0)
    8000423e:	02f00793          	li	a5,47
    80004242:	02f70363          	beq	a4,a5,80004268 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	766080e7          	jalr	1894(ra) # 800019ac <myproc>
    8000424e:	17853503          	ld	a0,376(a0)
    80004252:	00000097          	auipc	ra,0x0
    80004256:	9f6080e7          	jalr	-1546(ra) # 80003c48 <idup>
    8000425a:	89aa                	mv	s3,a0
  while(*path == '/')
    8000425c:	02f00913          	li	s2,47
  len = path - s;
    80004260:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004262:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004264:	4b85                	li	s7,1
    80004266:	a865                	j	8000431e <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004268:	4585                	li	a1,1
    8000426a:	4505                	li	a0,1
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	6e2080e7          	jalr	1762(ra) # 8000394e <iget>
    80004274:	89aa                	mv	s3,a0
    80004276:	b7dd                	j	8000425c <namex+0x42>
      iunlockput(ip);
    80004278:	854e                	mv	a0,s3
    8000427a:	00000097          	auipc	ra,0x0
    8000427e:	c6e080e7          	jalr	-914(ra) # 80003ee8 <iunlockput>
      return 0;
    80004282:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004284:	854e                	mv	a0,s3
    80004286:	60e6                	ld	ra,88(sp)
    80004288:	6446                	ld	s0,80(sp)
    8000428a:	64a6                	ld	s1,72(sp)
    8000428c:	6906                	ld	s2,64(sp)
    8000428e:	79e2                	ld	s3,56(sp)
    80004290:	7a42                	ld	s4,48(sp)
    80004292:	7aa2                	ld	s5,40(sp)
    80004294:	7b02                	ld	s6,32(sp)
    80004296:	6be2                	ld	s7,24(sp)
    80004298:	6c42                	ld	s8,16(sp)
    8000429a:	6ca2                	ld	s9,8(sp)
    8000429c:	6125                	addi	sp,sp,96
    8000429e:	8082                	ret
      iunlock(ip);
    800042a0:	854e                	mv	a0,s3
    800042a2:	00000097          	auipc	ra,0x0
    800042a6:	aa6080e7          	jalr	-1370(ra) # 80003d48 <iunlock>
      return ip;
    800042aa:	bfe9                	j	80004284 <namex+0x6a>
      iunlockput(ip);
    800042ac:	854e                	mv	a0,s3
    800042ae:	00000097          	auipc	ra,0x0
    800042b2:	c3a080e7          	jalr	-966(ra) # 80003ee8 <iunlockput>
      return 0;
    800042b6:	89e6                	mv	s3,s9
    800042b8:	b7f1                	j	80004284 <namex+0x6a>
  len = path - s;
    800042ba:	40b48633          	sub	a2,s1,a1
    800042be:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800042c2:	099c5463          	bge	s8,s9,8000434a <namex+0x130>
    memmove(name, s, DIRSIZ);
    800042c6:	4639                	li	a2,14
    800042c8:	8552                	mv	a0,s4
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	a64080e7          	jalr	-1436(ra) # 80000d2e <memmove>
  while(*path == '/')
    800042d2:	0004c783          	lbu	a5,0(s1)
    800042d6:	01279763          	bne	a5,s2,800042e4 <namex+0xca>
    path++;
    800042da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042dc:	0004c783          	lbu	a5,0(s1)
    800042e0:	ff278de3          	beq	a5,s2,800042da <namex+0xc0>
    ilock(ip);
    800042e4:	854e                	mv	a0,s3
    800042e6:	00000097          	auipc	ra,0x0
    800042ea:	9a0080e7          	jalr	-1632(ra) # 80003c86 <ilock>
    if(ip->type != T_DIR){
    800042ee:	04499783          	lh	a5,68(s3)
    800042f2:	f97793e3          	bne	a5,s7,80004278 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800042f6:	000a8563          	beqz	s5,80004300 <namex+0xe6>
    800042fa:	0004c783          	lbu	a5,0(s1)
    800042fe:	d3cd                	beqz	a5,800042a0 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004300:	865a                	mv	a2,s6
    80004302:	85d2                	mv	a1,s4
    80004304:	854e                	mv	a0,s3
    80004306:	00000097          	auipc	ra,0x0
    8000430a:	e64080e7          	jalr	-412(ra) # 8000416a <dirlookup>
    8000430e:	8caa                	mv	s9,a0
    80004310:	dd51                	beqz	a0,800042ac <namex+0x92>
    iunlockput(ip);
    80004312:	854e                	mv	a0,s3
    80004314:	00000097          	auipc	ra,0x0
    80004318:	bd4080e7          	jalr	-1068(ra) # 80003ee8 <iunlockput>
    ip = next;
    8000431c:	89e6                	mv	s3,s9
  while(*path == '/')
    8000431e:	0004c783          	lbu	a5,0(s1)
    80004322:	05279763          	bne	a5,s2,80004370 <namex+0x156>
    path++;
    80004326:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004328:	0004c783          	lbu	a5,0(s1)
    8000432c:	ff278de3          	beq	a5,s2,80004326 <namex+0x10c>
  if(*path == 0)
    80004330:	c79d                	beqz	a5,8000435e <namex+0x144>
    path++;
    80004332:	85a6                	mv	a1,s1
  len = path - s;
    80004334:	8cda                	mv	s9,s6
    80004336:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004338:	01278963          	beq	a5,s2,8000434a <namex+0x130>
    8000433c:	dfbd                	beqz	a5,800042ba <namex+0xa0>
    path++;
    8000433e:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004340:	0004c783          	lbu	a5,0(s1)
    80004344:	ff279ce3          	bne	a5,s2,8000433c <namex+0x122>
    80004348:	bf8d                	j	800042ba <namex+0xa0>
    memmove(name, s, len);
    8000434a:	2601                	sext.w	a2,a2
    8000434c:	8552                	mv	a0,s4
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	9e0080e7          	jalr	-1568(ra) # 80000d2e <memmove>
    name[len] = 0;
    80004356:	9cd2                	add	s9,s9,s4
    80004358:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000435c:	bf9d                	j	800042d2 <namex+0xb8>
  if(nameiparent){
    8000435e:	f20a83e3          	beqz	s5,80004284 <namex+0x6a>
    iput(ip);
    80004362:	854e                	mv	a0,s3
    80004364:	00000097          	auipc	ra,0x0
    80004368:	adc080e7          	jalr	-1316(ra) # 80003e40 <iput>
    return 0;
    8000436c:	4981                	li	s3,0
    8000436e:	bf19                	j	80004284 <namex+0x6a>
  if(*path == 0)
    80004370:	d7fd                	beqz	a5,8000435e <namex+0x144>
  while(*path != '/' && *path != 0)
    80004372:	0004c783          	lbu	a5,0(s1)
    80004376:	85a6                	mv	a1,s1
    80004378:	b7d1                	j	8000433c <namex+0x122>

000000008000437a <dirlink>:
{
    8000437a:	7139                	addi	sp,sp,-64
    8000437c:	fc06                	sd	ra,56(sp)
    8000437e:	f822                	sd	s0,48(sp)
    80004380:	f426                	sd	s1,40(sp)
    80004382:	f04a                	sd	s2,32(sp)
    80004384:	ec4e                	sd	s3,24(sp)
    80004386:	e852                	sd	s4,16(sp)
    80004388:	0080                	addi	s0,sp,64
    8000438a:	892a                	mv	s2,a0
    8000438c:	8a2e                	mv	s4,a1
    8000438e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004390:	4601                	li	a2,0
    80004392:	00000097          	auipc	ra,0x0
    80004396:	dd8080e7          	jalr	-552(ra) # 8000416a <dirlookup>
    8000439a:	e93d                	bnez	a0,80004410 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000439c:	04c92483          	lw	s1,76(s2)
    800043a0:	c49d                	beqz	s1,800043ce <dirlink+0x54>
    800043a2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043a4:	4741                	li	a4,16
    800043a6:	86a6                	mv	a3,s1
    800043a8:	fc040613          	addi	a2,s0,-64
    800043ac:	4581                	li	a1,0
    800043ae:	854a                	mv	a0,s2
    800043b0:	00000097          	auipc	ra,0x0
    800043b4:	b8a080e7          	jalr	-1142(ra) # 80003f3a <readi>
    800043b8:	47c1                	li	a5,16
    800043ba:	06f51163          	bne	a0,a5,8000441c <dirlink+0xa2>
    if(de.inum == 0)
    800043be:	fc045783          	lhu	a5,-64(s0)
    800043c2:	c791                	beqz	a5,800043ce <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043c4:	24c1                	addiw	s1,s1,16
    800043c6:	04c92783          	lw	a5,76(s2)
    800043ca:	fcf4ede3          	bltu	s1,a5,800043a4 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800043ce:	4639                	li	a2,14
    800043d0:	85d2                	mv	a1,s4
    800043d2:	fc240513          	addi	a0,s0,-62
    800043d6:	ffffd097          	auipc	ra,0xffffd
    800043da:	a08080e7          	jalr	-1528(ra) # 80000dde <strncpy>
  de.inum = inum;
    800043de:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043e2:	4741                	li	a4,16
    800043e4:	86a6                	mv	a3,s1
    800043e6:	fc040613          	addi	a2,s0,-64
    800043ea:	4581                	li	a1,0
    800043ec:	854a                	mv	a0,s2
    800043ee:	00000097          	auipc	ra,0x0
    800043f2:	c44080e7          	jalr	-956(ra) # 80004032 <writei>
    800043f6:	1541                	addi	a0,a0,-16
    800043f8:	00a03533          	snez	a0,a0
    800043fc:	40a00533          	neg	a0,a0
}
    80004400:	70e2                	ld	ra,56(sp)
    80004402:	7442                	ld	s0,48(sp)
    80004404:	74a2                	ld	s1,40(sp)
    80004406:	7902                	ld	s2,32(sp)
    80004408:	69e2                	ld	s3,24(sp)
    8000440a:	6a42                	ld	s4,16(sp)
    8000440c:	6121                	addi	sp,sp,64
    8000440e:	8082                	ret
    iput(ip);
    80004410:	00000097          	auipc	ra,0x0
    80004414:	a30080e7          	jalr	-1488(ra) # 80003e40 <iput>
    return -1;
    80004418:	557d                	li	a0,-1
    8000441a:	b7dd                	j	80004400 <dirlink+0x86>
      panic("dirlink read");
    8000441c:	00004517          	auipc	a0,0x4
    80004420:	23450513          	addi	a0,a0,564 # 80008650 <syscalls+0x1f0>
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	11a080e7          	jalr	282(ra) # 8000053e <panic>

000000008000442c <namei>:

struct inode*
namei(char *path)
{
    8000442c:	1101                	addi	sp,sp,-32
    8000442e:	ec06                	sd	ra,24(sp)
    80004430:	e822                	sd	s0,16(sp)
    80004432:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004434:	fe040613          	addi	a2,s0,-32
    80004438:	4581                	li	a1,0
    8000443a:	00000097          	auipc	ra,0x0
    8000443e:	de0080e7          	jalr	-544(ra) # 8000421a <namex>
}
    80004442:	60e2                	ld	ra,24(sp)
    80004444:	6442                	ld	s0,16(sp)
    80004446:	6105                	addi	sp,sp,32
    80004448:	8082                	ret

000000008000444a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000444a:	1141                	addi	sp,sp,-16
    8000444c:	e406                	sd	ra,8(sp)
    8000444e:	e022                	sd	s0,0(sp)
    80004450:	0800                	addi	s0,sp,16
    80004452:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004454:	4585                	li	a1,1
    80004456:	00000097          	auipc	ra,0x0
    8000445a:	dc4080e7          	jalr	-572(ra) # 8000421a <namex>
}
    8000445e:	60a2                	ld	ra,8(sp)
    80004460:	6402                	ld	s0,0(sp)
    80004462:	0141                	addi	sp,sp,16
    80004464:	8082                	ret

0000000080004466 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004466:	1101                	addi	sp,sp,-32
    80004468:	ec06                	sd	ra,24(sp)
    8000446a:	e822                	sd	s0,16(sp)
    8000446c:	e426                	sd	s1,8(sp)
    8000446e:	e04a                	sd	s2,0(sp)
    80004470:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004472:	0001e917          	auipc	s2,0x1e
    80004476:	cee90913          	addi	s2,s2,-786 # 80022160 <log>
    8000447a:	01892583          	lw	a1,24(s2)
    8000447e:	02892503          	lw	a0,40(s2)
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	fea080e7          	jalr	-22(ra) # 8000346c <bread>
    8000448a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000448c:	02c92683          	lw	a3,44(s2)
    80004490:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004492:	02d05763          	blez	a3,800044c0 <write_head+0x5a>
    80004496:	0001e797          	auipc	a5,0x1e
    8000449a:	cfa78793          	addi	a5,a5,-774 # 80022190 <log+0x30>
    8000449e:	05c50713          	addi	a4,a0,92
    800044a2:	36fd                	addiw	a3,a3,-1
    800044a4:	1682                	slli	a3,a3,0x20
    800044a6:	9281                	srli	a3,a3,0x20
    800044a8:	068a                	slli	a3,a3,0x2
    800044aa:	0001e617          	auipc	a2,0x1e
    800044ae:	cea60613          	addi	a2,a2,-790 # 80022194 <log+0x34>
    800044b2:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800044b4:	4390                	lw	a2,0(a5)
    800044b6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800044b8:	0791                	addi	a5,a5,4
    800044ba:	0711                	addi	a4,a4,4
    800044bc:	fed79ce3          	bne	a5,a3,800044b4 <write_head+0x4e>
  }
  bwrite(buf);
    800044c0:	8526                	mv	a0,s1
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	09c080e7          	jalr	156(ra) # 8000355e <bwrite>
  brelse(buf);
    800044ca:	8526                	mv	a0,s1
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	0d0080e7          	jalr	208(ra) # 8000359c <brelse>
}
    800044d4:	60e2                	ld	ra,24(sp)
    800044d6:	6442                	ld	s0,16(sp)
    800044d8:	64a2                	ld	s1,8(sp)
    800044da:	6902                	ld	s2,0(sp)
    800044dc:	6105                	addi	sp,sp,32
    800044de:	8082                	ret

00000000800044e0 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044e0:	0001e797          	auipc	a5,0x1e
    800044e4:	cac7a783          	lw	a5,-852(a5) # 8002218c <log+0x2c>
    800044e8:	0af05d63          	blez	a5,800045a2 <install_trans+0xc2>
{
    800044ec:	7139                	addi	sp,sp,-64
    800044ee:	fc06                	sd	ra,56(sp)
    800044f0:	f822                	sd	s0,48(sp)
    800044f2:	f426                	sd	s1,40(sp)
    800044f4:	f04a                	sd	s2,32(sp)
    800044f6:	ec4e                	sd	s3,24(sp)
    800044f8:	e852                	sd	s4,16(sp)
    800044fa:	e456                	sd	s5,8(sp)
    800044fc:	e05a                	sd	s6,0(sp)
    800044fe:	0080                	addi	s0,sp,64
    80004500:	8b2a                	mv	s6,a0
    80004502:	0001ea97          	auipc	s5,0x1e
    80004506:	c8ea8a93          	addi	s5,s5,-882 # 80022190 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000450a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000450c:	0001e997          	auipc	s3,0x1e
    80004510:	c5498993          	addi	s3,s3,-940 # 80022160 <log>
    80004514:	a00d                	j	80004536 <install_trans+0x56>
    brelse(lbuf);
    80004516:	854a                	mv	a0,s2
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	084080e7          	jalr	132(ra) # 8000359c <brelse>
    brelse(dbuf);
    80004520:	8526                	mv	a0,s1
    80004522:	fffff097          	auipc	ra,0xfffff
    80004526:	07a080e7          	jalr	122(ra) # 8000359c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000452a:	2a05                	addiw	s4,s4,1
    8000452c:	0a91                	addi	s5,s5,4
    8000452e:	02c9a783          	lw	a5,44(s3)
    80004532:	04fa5e63          	bge	s4,a5,8000458e <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004536:	0189a583          	lw	a1,24(s3)
    8000453a:	014585bb          	addw	a1,a1,s4
    8000453e:	2585                	addiw	a1,a1,1
    80004540:	0289a503          	lw	a0,40(s3)
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	f28080e7          	jalr	-216(ra) # 8000346c <bread>
    8000454c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000454e:	000aa583          	lw	a1,0(s5)
    80004552:	0289a503          	lw	a0,40(s3)
    80004556:	fffff097          	auipc	ra,0xfffff
    8000455a:	f16080e7          	jalr	-234(ra) # 8000346c <bread>
    8000455e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004560:	40000613          	li	a2,1024
    80004564:	05890593          	addi	a1,s2,88
    80004568:	05850513          	addi	a0,a0,88
    8000456c:	ffffc097          	auipc	ra,0xffffc
    80004570:	7c2080e7          	jalr	1986(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004574:	8526                	mv	a0,s1
    80004576:	fffff097          	auipc	ra,0xfffff
    8000457a:	fe8080e7          	jalr	-24(ra) # 8000355e <bwrite>
    if(recovering == 0)
    8000457e:	f80b1ce3          	bnez	s6,80004516 <install_trans+0x36>
      bunpin(dbuf);
    80004582:	8526                	mv	a0,s1
    80004584:	fffff097          	auipc	ra,0xfffff
    80004588:	0f2080e7          	jalr	242(ra) # 80003676 <bunpin>
    8000458c:	b769                	j	80004516 <install_trans+0x36>
}
    8000458e:	70e2                	ld	ra,56(sp)
    80004590:	7442                	ld	s0,48(sp)
    80004592:	74a2                	ld	s1,40(sp)
    80004594:	7902                	ld	s2,32(sp)
    80004596:	69e2                	ld	s3,24(sp)
    80004598:	6a42                	ld	s4,16(sp)
    8000459a:	6aa2                	ld	s5,8(sp)
    8000459c:	6b02                	ld	s6,0(sp)
    8000459e:	6121                	addi	sp,sp,64
    800045a0:	8082                	ret
    800045a2:	8082                	ret

00000000800045a4 <initlog>:
{
    800045a4:	7179                	addi	sp,sp,-48
    800045a6:	f406                	sd	ra,40(sp)
    800045a8:	f022                	sd	s0,32(sp)
    800045aa:	ec26                	sd	s1,24(sp)
    800045ac:	e84a                	sd	s2,16(sp)
    800045ae:	e44e                	sd	s3,8(sp)
    800045b0:	1800                	addi	s0,sp,48
    800045b2:	892a                	mv	s2,a0
    800045b4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045b6:	0001e497          	auipc	s1,0x1e
    800045ba:	baa48493          	addi	s1,s1,-1110 # 80022160 <log>
    800045be:	00004597          	auipc	a1,0x4
    800045c2:	0a258593          	addi	a1,a1,162 # 80008660 <syscalls+0x200>
    800045c6:	8526                	mv	a0,s1
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	57e080e7          	jalr	1406(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    800045d0:	0149a583          	lw	a1,20(s3)
    800045d4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045d6:	0109a783          	lw	a5,16(s3)
    800045da:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045dc:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045e0:	854a                	mv	a0,s2
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	e8a080e7          	jalr	-374(ra) # 8000346c <bread>
  log.lh.n = lh->n;
    800045ea:	4d34                	lw	a3,88(a0)
    800045ec:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045ee:	02d05563          	blez	a3,80004618 <initlog+0x74>
    800045f2:	05c50793          	addi	a5,a0,92
    800045f6:	0001e717          	auipc	a4,0x1e
    800045fa:	b9a70713          	addi	a4,a4,-1126 # 80022190 <log+0x30>
    800045fe:	36fd                	addiw	a3,a3,-1
    80004600:	1682                	slli	a3,a3,0x20
    80004602:	9281                	srli	a3,a3,0x20
    80004604:	068a                	slli	a3,a3,0x2
    80004606:	06050613          	addi	a2,a0,96
    8000460a:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    8000460c:	4390                	lw	a2,0(a5)
    8000460e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004610:	0791                	addi	a5,a5,4
    80004612:	0711                	addi	a4,a4,4
    80004614:	fed79ce3          	bne	a5,a3,8000460c <initlog+0x68>
  brelse(buf);
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	f84080e7          	jalr	-124(ra) # 8000359c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004620:	4505                	li	a0,1
    80004622:	00000097          	auipc	ra,0x0
    80004626:	ebe080e7          	jalr	-322(ra) # 800044e0 <install_trans>
  log.lh.n = 0;
    8000462a:	0001e797          	auipc	a5,0x1e
    8000462e:	b607a123          	sw	zero,-1182(a5) # 8002218c <log+0x2c>
  write_head(); // clear the log
    80004632:	00000097          	auipc	ra,0x0
    80004636:	e34080e7          	jalr	-460(ra) # 80004466 <write_head>
}
    8000463a:	70a2                	ld	ra,40(sp)
    8000463c:	7402                	ld	s0,32(sp)
    8000463e:	64e2                	ld	s1,24(sp)
    80004640:	6942                	ld	s2,16(sp)
    80004642:	69a2                	ld	s3,8(sp)
    80004644:	6145                	addi	sp,sp,48
    80004646:	8082                	ret

0000000080004648 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004648:	1101                	addi	sp,sp,-32
    8000464a:	ec06                	sd	ra,24(sp)
    8000464c:	e822                	sd	s0,16(sp)
    8000464e:	e426                	sd	s1,8(sp)
    80004650:	e04a                	sd	s2,0(sp)
    80004652:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004654:	0001e517          	auipc	a0,0x1e
    80004658:	b0c50513          	addi	a0,a0,-1268 # 80022160 <log>
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	57a080e7          	jalr	1402(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    80004664:	0001e497          	auipc	s1,0x1e
    80004668:	afc48493          	addi	s1,s1,-1284 # 80022160 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000466c:	4979                	li	s2,30
    8000466e:	a039                	j	8000467c <begin_op+0x34>
      sleep(&log, &log.lock);
    80004670:	85a6                	mv	a1,s1
    80004672:	8526                	mv	a0,s1
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	ba8080e7          	jalr	-1112(ra) # 8000221c <sleep>
    if(log.committing){
    8000467c:	50dc                	lw	a5,36(s1)
    8000467e:	fbed                	bnez	a5,80004670 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004680:	509c                	lw	a5,32(s1)
    80004682:	0017871b          	addiw	a4,a5,1
    80004686:	0007069b          	sext.w	a3,a4
    8000468a:	0027179b          	slliw	a5,a4,0x2
    8000468e:	9fb9                	addw	a5,a5,a4
    80004690:	0017979b          	slliw	a5,a5,0x1
    80004694:	54d8                	lw	a4,44(s1)
    80004696:	9fb9                	addw	a5,a5,a4
    80004698:	00f95963          	bge	s2,a5,800046aa <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000469c:	85a6                	mv	a1,s1
    8000469e:	8526                	mv	a0,s1
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	b7c080e7          	jalr	-1156(ra) # 8000221c <sleep>
    800046a8:	bfd1                	j	8000467c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800046aa:	0001e517          	auipc	a0,0x1e
    800046ae:	ab650513          	addi	a0,a0,-1354 # 80022160 <log>
    800046b2:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	5d6080e7          	jalr	1494(ra) # 80000c8a <release>
      break;
    }
  }
}
    800046bc:	60e2                	ld	ra,24(sp)
    800046be:	6442                	ld	s0,16(sp)
    800046c0:	64a2                	ld	s1,8(sp)
    800046c2:	6902                	ld	s2,0(sp)
    800046c4:	6105                	addi	sp,sp,32
    800046c6:	8082                	ret

00000000800046c8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800046c8:	7139                	addi	sp,sp,-64
    800046ca:	fc06                	sd	ra,56(sp)
    800046cc:	f822                	sd	s0,48(sp)
    800046ce:	f426                	sd	s1,40(sp)
    800046d0:	f04a                	sd	s2,32(sp)
    800046d2:	ec4e                	sd	s3,24(sp)
    800046d4:	e852                	sd	s4,16(sp)
    800046d6:	e456                	sd	s5,8(sp)
    800046d8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800046da:	0001e497          	auipc	s1,0x1e
    800046de:	a8648493          	addi	s1,s1,-1402 # 80022160 <log>
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffc097          	auipc	ra,0xffffc
    800046e8:	4f2080e7          	jalr	1266(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    800046ec:	509c                	lw	a5,32(s1)
    800046ee:	37fd                	addiw	a5,a5,-1
    800046f0:	0007891b          	sext.w	s2,a5
    800046f4:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800046f6:	50dc                	lw	a5,36(s1)
    800046f8:	e7b9                	bnez	a5,80004746 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800046fa:	04091e63          	bnez	s2,80004756 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800046fe:	0001e497          	auipc	s1,0x1e
    80004702:	a6248493          	addi	s1,s1,-1438 # 80022160 <log>
    80004706:	4785                	li	a5,1
    80004708:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000470a:	8526                	mv	a0,s1
    8000470c:	ffffc097          	auipc	ra,0xffffc
    80004710:	57e080e7          	jalr	1406(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004714:	54dc                	lw	a5,44(s1)
    80004716:	06f04763          	bgtz	a5,80004784 <end_op+0xbc>
    acquire(&log.lock);
    8000471a:	0001e497          	auipc	s1,0x1e
    8000471e:	a4648493          	addi	s1,s1,-1466 # 80022160 <log>
    80004722:	8526                	mv	a0,s1
    80004724:	ffffc097          	auipc	ra,0xffffc
    80004728:	4b2080e7          	jalr	1202(ra) # 80000bd6 <acquire>
    log.committing = 0;
    8000472c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	b4e080e7          	jalr	-1202(ra) # 80002280 <wakeup>
    release(&log.lock);
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffc097          	auipc	ra,0xffffc
    80004740:	54e080e7          	jalr	1358(ra) # 80000c8a <release>
}
    80004744:	a03d                	j	80004772 <end_op+0xaa>
    panic("log.committing");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	f2250513          	addi	a0,a0,-222 # 80008668 <syscalls+0x208>
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	df0080e7          	jalr	-528(ra) # 8000053e <panic>
    wakeup(&log);
    80004756:	0001e497          	auipc	s1,0x1e
    8000475a:	a0a48493          	addi	s1,s1,-1526 # 80022160 <log>
    8000475e:	8526                	mv	a0,s1
    80004760:	ffffe097          	auipc	ra,0xffffe
    80004764:	b20080e7          	jalr	-1248(ra) # 80002280 <wakeup>
  release(&log.lock);
    80004768:	8526                	mv	a0,s1
    8000476a:	ffffc097          	auipc	ra,0xffffc
    8000476e:	520080e7          	jalr	1312(ra) # 80000c8a <release>
}
    80004772:	70e2                	ld	ra,56(sp)
    80004774:	7442                	ld	s0,48(sp)
    80004776:	74a2                	ld	s1,40(sp)
    80004778:	7902                	ld	s2,32(sp)
    8000477a:	69e2                	ld	s3,24(sp)
    8000477c:	6a42                	ld	s4,16(sp)
    8000477e:	6aa2                	ld	s5,8(sp)
    80004780:	6121                	addi	sp,sp,64
    80004782:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004784:	0001ea97          	auipc	s5,0x1e
    80004788:	a0ca8a93          	addi	s5,s5,-1524 # 80022190 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000478c:	0001ea17          	auipc	s4,0x1e
    80004790:	9d4a0a13          	addi	s4,s4,-1580 # 80022160 <log>
    80004794:	018a2583          	lw	a1,24(s4)
    80004798:	012585bb          	addw	a1,a1,s2
    8000479c:	2585                	addiw	a1,a1,1
    8000479e:	028a2503          	lw	a0,40(s4)
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	cca080e7          	jalr	-822(ra) # 8000346c <bread>
    800047aa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800047ac:	000aa583          	lw	a1,0(s5)
    800047b0:	028a2503          	lw	a0,40(s4)
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	cb8080e7          	jalr	-840(ra) # 8000346c <bread>
    800047bc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800047be:	40000613          	li	a2,1024
    800047c2:	05850593          	addi	a1,a0,88
    800047c6:	05848513          	addi	a0,s1,88
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	564080e7          	jalr	1380(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    800047d2:	8526                	mv	a0,s1
    800047d4:	fffff097          	auipc	ra,0xfffff
    800047d8:	d8a080e7          	jalr	-630(ra) # 8000355e <bwrite>
    brelse(from);
    800047dc:	854e                	mv	a0,s3
    800047de:	fffff097          	auipc	ra,0xfffff
    800047e2:	dbe080e7          	jalr	-578(ra) # 8000359c <brelse>
    brelse(to);
    800047e6:	8526                	mv	a0,s1
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	db4080e7          	jalr	-588(ra) # 8000359c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047f0:	2905                	addiw	s2,s2,1
    800047f2:	0a91                	addi	s5,s5,4
    800047f4:	02ca2783          	lw	a5,44(s4)
    800047f8:	f8f94ee3          	blt	s2,a5,80004794 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	c6a080e7          	jalr	-918(ra) # 80004466 <write_head>
    install_trans(0); // Now install writes to home locations
    80004804:	4501                	li	a0,0
    80004806:	00000097          	auipc	ra,0x0
    8000480a:	cda080e7          	jalr	-806(ra) # 800044e0 <install_trans>
    log.lh.n = 0;
    8000480e:	0001e797          	auipc	a5,0x1e
    80004812:	9607af23          	sw	zero,-1666(a5) # 8002218c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004816:	00000097          	auipc	ra,0x0
    8000481a:	c50080e7          	jalr	-944(ra) # 80004466 <write_head>
    8000481e:	bdf5                	j	8000471a <end_op+0x52>

0000000080004820 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004820:	1101                	addi	sp,sp,-32
    80004822:	ec06                	sd	ra,24(sp)
    80004824:	e822                	sd	s0,16(sp)
    80004826:	e426                	sd	s1,8(sp)
    80004828:	e04a                	sd	s2,0(sp)
    8000482a:	1000                	addi	s0,sp,32
    8000482c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000482e:	0001e917          	auipc	s2,0x1e
    80004832:	93290913          	addi	s2,s2,-1742 # 80022160 <log>
    80004836:	854a                	mv	a0,s2
    80004838:	ffffc097          	auipc	ra,0xffffc
    8000483c:	39e080e7          	jalr	926(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004840:	02c92603          	lw	a2,44(s2)
    80004844:	47f5                	li	a5,29
    80004846:	06c7c563          	blt	a5,a2,800048b0 <log_write+0x90>
    8000484a:	0001e797          	auipc	a5,0x1e
    8000484e:	9327a783          	lw	a5,-1742(a5) # 8002217c <log+0x1c>
    80004852:	37fd                	addiw	a5,a5,-1
    80004854:	04f65e63          	bge	a2,a5,800048b0 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004858:	0001e797          	auipc	a5,0x1e
    8000485c:	9287a783          	lw	a5,-1752(a5) # 80022180 <log+0x20>
    80004860:	06f05063          	blez	a5,800048c0 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004864:	4781                	li	a5,0
    80004866:	06c05563          	blez	a2,800048d0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000486a:	44cc                	lw	a1,12(s1)
    8000486c:	0001e717          	auipc	a4,0x1e
    80004870:	92470713          	addi	a4,a4,-1756 # 80022190 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004874:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004876:	4314                	lw	a3,0(a4)
    80004878:	04b68c63          	beq	a3,a1,800048d0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000487c:	2785                	addiw	a5,a5,1
    8000487e:	0711                	addi	a4,a4,4
    80004880:	fef61be3          	bne	a2,a5,80004876 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004884:	0621                	addi	a2,a2,8
    80004886:	060a                	slli	a2,a2,0x2
    80004888:	0001e797          	auipc	a5,0x1e
    8000488c:	8d878793          	addi	a5,a5,-1832 # 80022160 <log>
    80004890:	963e                	add	a2,a2,a5
    80004892:	44dc                	lw	a5,12(s1)
    80004894:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004896:	8526                	mv	a0,s1
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	da2080e7          	jalr	-606(ra) # 8000363a <bpin>
    log.lh.n++;
    800048a0:	0001e717          	auipc	a4,0x1e
    800048a4:	8c070713          	addi	a4,a4,-1856 # 80022160 <log>
    800048a8:	575c                	lw	a5,44(a4)
    800048aa:	2785                	addiw	a5,a5,1
    800048ac:	d75c                	sw	a5,44(a4)
    800048ae:	a835                	j	800048ea <log_write+0xca>
    panic("too big a transaction");
    800048b0:	00004517          	auipc	a0,0x4
    800048b4:	dc850513          	addi	a0,a0,-568 # 80008678 <syscalls+0x218>
    800048b8:	ffffc097          	auipc	ra,0xffffc
    800048bc:	c86080e7          	jalr	-890(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    800048c0:	00004517          	auipc	a0,0x4
    800048c4:	dd050513          	addi	a0,a0,-560 # 80008690 <syscalls+0x230>
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	c76080e7          	jalr	-906(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    800048d0:	00878713          	addi	a4,a5,8
    800048d4:	00271693          	slli	a3,a4,0x2
    800048d8:	0001e717          	auipc	a4,0x1e
    800048dc:	88870713          	addi	a4,a4,-1912 # 80022160 <log>
    800048e0:	9736                	add	a4,a4,a3
    800048e2:	44d4                	lw	a3,12(s1)
    800048e4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048e6:	faf608e3          	beq	a2,a5,80004896 <log_write+0x76>
  }
  release(&log.lock);
    800048ea:	0001e517          	auipc	a0,0x1e
    800048ee:	87650513          	addi	a0,a0,-1930 # 80022160 <log>
    800048f2:	ffffc097          	auipc	ra,0xffffc
    800048f6:	398080e7          	jalr	920(ra) # 80000c8a <release>
}
    800048fa:	60e2                	ld	ra,24(sp)
    800048fc:	6442                	ld	s0,16(sp)
    800048fe:	64a2                	ld	s1,8(sp)
    80004900:	6902                	ld	s2,0(sp)
    80004902:	6105                	addi	sp,sp,32
    80004904:	8082                	ret

0000000080004906 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004906:	1101                	addi	sp,sp,-32
    80004908:	ec06                	sd	ra,24(sp)
    8000490a:	e822                	sd	s0,16(sp)
    8000490c:	e426                	sd	s1,8(sp)
    8000490e:	e04a                	sd	s2,0(sp)
    80004910:	1000                	addi	s0,sp,32
    80004912:	84aa                	mv	s1,a0
    80004914:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004916:	00004597          	auipc	a1,0x4
    8000491a:	d9a58593          	addi	a1,a1,-614 # 800086b0 <syscalls+0x250>
    8000491e:	0521                	addi	a0,a0,8
    80004920:	ffffc097          	auipc	ra,0xffffc
    80004924:	226080e7          	jalr	550(ra) # 80000b46 <initlock>
  lk->name = name;
    80004928:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000492c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004930:	0204a423          	sw	zero,40(s1)
}
    80004934:	60e2                	ld	ra,24(sp)
    80004936:	6442                	ld	s0,16(sp)
    80004938:	64a2                	ld	s1,8(sp)
    8000493a:	6902                	ld	s2,0(sp)
    8000493c:	6105                	addi	sp,sp,32
    8000493e:	8082                	ret

0000000080004940 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004940:	1101                	addi	sp,sp,-32
    80004942:	ec06                	sd	ra,24(sp)
    80004944:	e822                	sd	s0,16(sp)
    80004946:	e426                	sd	s1,8(sp)
    80004948:	e04a                	sd	s2,0(sp)
    8000494a:	1000                	addi	s0,sp,32
    8000494c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000494e:	00850913          	addi	s2,a0,8
    80004952:	854a                	mv	a0,s2
    80004954:	ffffc097          	auipc	ra,0xffffc
    80004958:	282080e7          	jalr	642(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    8000495c:	409c                	lw	a5,0(s1)
    8000495e:	cb89                	beqz	a5,80004970 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004960:	85ca                	mv	a1,s2
    80004962:	8526                	mv	a0,s1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	8b8080e7          	jalr	-1864(ra) # 8000221c <sleep>
  while (lk->locked) {
    8000496c:	409c                	lw	a5,0(s1)
    8000496e:	fbed                	bnez	a5,80004960 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004970:	4785                	li	a5,1
    80004972:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004974:	ffffd097          	auipc	ra,0xffffd
    80004978:	038080e7          	jalr	56(ra) # 800019ac <myproc>
    8000497c:	591c                	lw	a5,48(a0)
    8000497e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004980:	854a                	mv	a0,s2
    80004982:	ffffc097          	auipc	ra,0xffffc
    80004986:	308080e7          	jalr	776(ra) # 80000c8a <release>
}
    8000498a:	60e2                	ld	ra,24(sp)
    8000498c:	6442                	ld	s0,16(sp)
    8000498e:	64a2                	ld	s1,8(sp)
    80004990:	6902                	ld	s2,0(sp)
    80004992:	6105                	addi	sp,sp,32
    80004994:	8082                	ret

0000000080004996 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004996:	1101                	addi	sp,sp,-32
    80004998:	ec06                	sd	ra,24(sp)
    8000499a:	e822                	sd	s0,16(sp)
    8000499c:	e426                	sd	s1,8(sp)
    8000499e:	e04a                	sd	s2,0(sp)
    800049a0:	1000                	addi	s0,sp,32
    800049a2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049a4:	00850913          	addi	s2,a0,8
    800049a8:	854a                	mv	a0,s2
    800049aa:	ffffc097          	auipc	ra,0xffffc
    800049ae:	22c080e7          	jalr	556(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    800049b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049b6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	8c4080e7          	jalr	-1852(ra) # 80002280 <wakeup>
  release(&lk->lk);
    800049c4:	854a                	mv	a0,s2
    800049c6:	ffffc097          	auipc	ra,0xffffc
    800049ca:	2c4080e7          	jalr	708(ra) # 80000c8a <release>
}
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	64a2                	ld	s1,8(sp)
    800049d4:	6902                	ld	s2,0(sp)
    800049d6:	6105                	addi	sp,sp,32
    800049d8:	8082                	ret

00000000800049da <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800049da:	7179                	addi	sp,sp,-48
    800049dc:	f406                	sd	ra,40(sp)
    800049de:	f022                	sd	s0,32(sp)
    800049e0:	ec26                	sd	s1,24(sp)
    800049e2:	e84a                	sd	s2,16(sp)
    800049e4:	e44e                	sd	s3,8(sp)
    800049e6:	1800                	addi	s0,sp,48
    800049e8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800049ea:	00850913          	addi	s2,a0,8
    800049ee:	854a                	mv	a0,s2
    800049f0:	ffffc097          	auipc	ra,0xffffc
    800049f4:	1e6080e7          	jalr	486(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800049f8:	409c                	lw	a5,0(s1)
    800049fa:	ef99                	bnez	a5,80004a18 <holdingsleep+0x3e>
    800049fc:	4481                	li	s1,0
  release(&lk->lk);
    800049fe:	854a                	mv	a0,s2
    80004a00:	ffffc097          	auipc	ra,0xffffc
    80004a04:	28a080e7          	jalr	650(ra) # 80000c8a <release>
  return r;
}
    80004a08:	8526                	mv	a0,s1
    80004a0a:	70a2                	ld	ra,40(sp)
    80004a0c:	7402                	ld	s0,32(sp)
    80004a0e:	64e2                	ld	s1,24(sp)
    80004a10:	6942                	ld	s2,16(sp)
    80004a12:	69a2                	ld	s3,8(sp)
    80004a14:	6145                	addi	sp,sp,48
    80004a16:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a18:	0284a983          	lw	s3,40(s1)
    80004a1c:	ffffd097          	auipc	ra,0xffffd
    80004a20:	f90080e7          	jalr	-112(ra) # 800019ac <myproc>
    80004a24:	5904                	lw	s1,48(a0)
    80004a26:	413484b3          	sub	s1,s1,s3
    80004a2a:	0014b493          	seqz	s1,s1
    80004a2e:	bfc1                	j	800049fe <holdingsleep+0x24>

0000000080004a30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a30:	1141                	addi	sp,sp,-16
    80004a32:	e406                	sd	ra,8(sp)
    80004a34:	e022                	sd	s0,0(sp)
    80004a36:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a38:	00004597          	auipc	a1,0x4
    80004a3c:	c8858593          	addi	a1,a1,-888 # 800086c0 <syscalls+0x260>
    80004a40:	0001e517          	auipc	a0,0x1e
    80004a44:	86850513          	addi	a0,a0,-1944 # 800222a8 <ftable>
    80004a48:	ffffc097          	auipc	ra,0xffffc
    80004a4c:	0fe080e7          	jalr	254(ra) # 80000b46 <initlock>
}
    80004a50:	60a2                	ld	ra,8(sp)
    80004a52:	6402                	ld	s0,0(sp)
    80004a54:	0141                	addi	sp,sp,16
    80004a56:	8082                	ret

0000000080004a58 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a58:	1101                	addi	sp,sp,-32
    80004a5a:	ec06                	sd	ra,24(sp)
    80004a5c:	e822                	sd	s0,16(sp)
    80004a5e:	e426                	sd	s1,8(sp)
    80004a60:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a62:	0001e517          	auipc	a0,0x1e
    80004a66:	84650513          	addi	a0,a0,-1978 # 800222a8 <ftable>
    80004a6a:	ffffc097          	auipc	ra,0xffffc
    80004a6e:	16c080e7          	jalr	364(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a72:	0001e497          	auipc	s1,0x1e
    80004a76:	84e48493          	addi	s1,s1,-1970 # 800222c0 <ftable+0x18>
    80004a7a:	0001e717          	auipc	a4,0x1e
    80004a7e:	7e670713          	addi	a4,a4,2022 # 80023260 <disk>
    if(f->ref == 0){
    80004a82:	40dc                	lw	a5,4(s1)
    80004a84:	cf99                	beqz	a5,80004aa2 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a86:	02848493          	addi	s1,s1,40
    80004a8a:	fee49ce3          	bne	s1,a4,80004a82 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a8e:	0001e517          	auipc	a0,0x1e
    80004a92:	81a50513          	addi	a0,a0,-2022 # 800222a8 <ftable>
    80004a96:	ffffc097          	auipc	ra,0xffffc
    80004a9a:	1f4080e7          	jalr	500(ra) # 80000c8a <release>
  return 0;
    80004a9e:	4481                	li	s1,0
    80004aa0:	a819                	j	80004ab6 <filealloc+0x5e>
      f->ref = 1;
    80004aa2:	4785                	li	a5,1
    80004aa4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004aa6:	0001e517          	auipc	a0,0x1e
    80004aaa:	80250513          	addi	a0,a0,-2046 # 800222a8 <ftable>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	1dc080e7          	jalr	476(ra) # 80000c8a <release>
}
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	60e2                	ld	ra,24(sp)
    80004aba:	6442                	ld	s0,16(sp)
    80004abc:	64a2                	ld	s1,8(sp)
    80004abe:	6105                	addi	sp,sp,32
    80004ac0:	8082                	ret

0000000080004ac2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ac2:	1101                	addi	sp,sp,-32
    80004ac4:	ec06                	sd	ra,24(sp)
    80004ac6:	e822                	sd	s0,16(sp)
    80004ac8:	e426                	sd	s1,8(sp)
    80004aca:	1000                	addi	s0,sp,32
    80004acc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004ace:	0001d517          	auipc	a0,0x1d
    80004ad2:	7da50513          	addi	a0,a0,2010 # 800222a8 <ftable>
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	100080e7          	jalr	256(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004ade:	40dc                	lw	a5,4(s1)
    80004ae0:	02f05263          	blez	a5,80004b04 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ae4:	2785                	addiw	a5,a5,1
    80004ae6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ae8:	0001d517          	auipc	a0,0x1d
    80004aec:	7c050513          	addi	a0,a0,1984 # 800222a8 <ftable>
    80004af0:	ffffc097          	auipc	ra,0xffffc
    80004af4:	19a080e7          	jalr	410(ra) # 80000c8a <release>
  return f;
}
    80004af8:	8526                	mv	a0,s1
    80004afa:	60e2                	ld	ra,24(sp)
    80004afc:	6442                	ld	s0,16(sp)
    80004afe:	64a2                	ld	s1,8(sp)
    80004b00:	6105                	addi	sp,sp,32
    80004b02:	8082                	ret
    panic("filedup");
    80004b04:	00004517          	auipc	a0,0x4
    80004b08:	bc450513          	addi	a0,a0,-1084 # 800086c8 <syscalls+0x268>
    80004b0c:	ffffc097          	auipc	ra,0xffffc
    80004b10:	a32080e7          	jalr	-1486(ra) # 8000053e <panic>

0000000080004b14 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b14:	7139                	addi	sp,sp,-64
    80004b16:	fc06                	sd	ra,56(sp)
    80004b18:	f822                	sd	s0,48(sp)
    80004b1a:	f426                	sd	s1,40(sp)
    80004b1c:	f04a                	sd	s2,32(sp)
    80004b1e:	ec4e                	sd	s3,24(sp)
    80004b20:	e852                	sd	s4,16(sp)
    80004b22:	e456                	sd	s5,8(sp)
    80004b24:	0080                	addi	s0,sp,64
    80004b26:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b28:	0001d517          	auipc	a0,0x1d
    80004b2c:	78050513          	addi	a0,a0,1920 # 800222a8 <ftable>
    80004b30:	ffffc097          	auipc	ra,0xffffc
    80004b34:	0a6080e7          	jalr	166(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004b38:	40dc                	lw	a5,4(s1)
    80004b3a:	06f05163          	blez	a5,80004b9c <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004b3e:	37fd                	addiw	a5,a5,-1
    80004b40:	0007871b          	sext.w	a4,a5
    80004b44:	c0dc                	sw	a5,4(s1)
    80004b46:	06e04363          	bgtz	a4,80004bac <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b4a:	0004a903          	lw	s2,0(s1)
    80004b4e:	0094ca83          	lbu	s5,9(s1)
    80004b52:	0104ba03          	ld	s4,16(s1)
    80004b56:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b5a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b5e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b62:	0001d517          	auipc	a0,0x1d
    80004b66:	74650513          	addi	a0,a0,1862 # 800222a8 <ftable>
    80004b6a:	ffffc097          	auipc	ra,0xffffc
    80004b6e:	120080e7          	jalr	288(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    80004b72:	4785                	li	a5,1
    80004b74:	04f90d63          	beq	s2,a5,80004bce <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b78:	3979                	addiw	s2,s2,-2
    80004b7a:	4785                	li	a5,1
    80004b7c:	0527e063          	bltu	a5,s2,80004bbc <fileclose+0xa8>
    begin_op();
    80004b80:	00000097          	auipc	ra,0x0
    80004b84:	ac8080e7          	jalr	-1336(ra) # 80004648 <begin_op>
    iput(ff.ip);
    80004b88:	854e                	mv	a0,s3
    80004b8a:	fffff097          	auipc	ra,0xfffff
    80004b8e:	2b6080e7          	jalr	694(ra) # 80003e40 <iput>
    end_op();
    80004b92:	00000097          	auipc	ra,0x0
    80004b96:	b36080e7          	jalr	-1226(ra) # 800046c8 <end_op>
    80004b9a:	a00d                	j	80004bbc <fileclose+0xa8>
    panic("fileclose");
    80004b9c:	00004517          	auipc	a0,0x4
    80004ba0:	b3450513          	addi	a0,a0,-1228 # 800086d0 <syscalls+0x270>
    80004ba4:	ffffc097          	auipc	ra,0xffffc
    80004ba8:	99a080e7          	jalr	-1638(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004bac:	0001d517          	auipc	a0,0x1d
    80004bb0:	6fc50513          	addi	a0,a0,1788 # 800222a8 <ftable>
    80004bb4:	ffffc097          	auipc	ra,0xffffc
    80004bb8:	0d6080e7          	jalr	214(ra) # 80000c8a <release>
  }
}
    80004bbc:	70e2                	ld	ra,56(sp)
    80004bbe:	7442                	ld	s0,48(sp)
    80004bc0:	74a2                	ld	s1,40(sp)
    80004bc2:	7902                	ld	s2,32(sp)
    80004bc4:	69e2                	ld	s3,24(sp)
    80004bc6:	6a42                	ld	s4,16(sp)
    80004bc8:	6aa2                	ld	s5,8(sp)
    80004bca:	6121                	addi	sp,sp,64
    80004bcc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004bce:	85d6                	mv	a1,s5
    80004bd0:	8552                	mv	a0,s4
    80004bd2:	00000097          	auipc	ra,0x0
    80004bd6:	34c080e7          	jalr	844(ra) # 80004f1e <pipeclose>
    80004bda:	b7cd                	j	80004bbc <fileclose+0xa8>

0000000080004bdc <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004bdc:	715d                	addi	sp,sp,-80
    80004bde:	e486                	sd	ra,72(sp)
    80004be0:	e0a2                	sd	s0,64(sp)
    80004be2:	fc26                	sd	s1,56(sp)
    80004be4:	f84a                	sd	s2,48(sp)
    80004be6:	f44e                	sd	s3,40(sp)
    80004be8:	0880                	addi	s0,sp,80
    80004bea:	84aa                	mv	s1,a0
    80004bec:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004bee:	ffffd097          	auipc	ra,0xffffd
    80004bf2:	dbe080e7          	jalr	-578(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004bf6:	409c                	lw	a5,0(s1)
    80004bf8:	37f9                	addiw	a5,a5,-2
    80004bfa:	4705                	li	a4,1
    80004bfc:	04f76763          	bltu	a4,a5,80004c4a <filestat+0x6e>
    80004c00:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c02:	6c88                	ld	a0,24(s1)
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	082080e7          	jalr	130(ra) # 80003c86 <ilock>
    stati(f->ip, &st);
    80004c0c:	fb840593          	addi	a1,s0,-72
    80004c10:	6c88                	ld	a0,24(s1)
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	2fe080e7          	jalr	766(ra) # 80003f10 <stati>
    iunlock(f->ip);
    80004c1a:	6c88                	ld	a0,24(s1)
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	12c080e7          	jalr	300(ra) # 80003d48 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c24:	46e1                	li	a3,24
    80004c26:	fb840613          	addi	a2,s0,-72
    80004c2a:	85ce                	mv	a1,s3
    80004c2c:	07893503          	ld	a0,120(s2)
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	a38080e7          	jalr	-1480(ra) # 80001668 <copyout>
    80004c38:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004c3c:	60a6                	ld	ra,72(sp)
    80004c3e:	6406                	ld	s0,64(sp)
    80004c40:	74e2                	ld	s1,56(sp)
    80004c42:	7942                	ld	s2,48(sp)
    80004c44:	79a2                	ld	s3,40(sp)
    80004c46:	6161                	addi	sp,sp,80
    80004c48:	8082                	ret
  return -1;
    80004c4a:	557d                	li	a0,-1
    80004c4c:	bfc5                	j	80004c3c <filestat+0x60>

0000000080004c4e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c4e:	7179                	addi	sp,sp,-48
    80004c50:	f406                	sd	ra,40(sp)
    80004c52:	f022                	sd	s0,32(sp)
    80004c54:	ec26                	sd	s1,24(sp)
    80004c56:	e84a                	sd	s2,16(sp)
    80004c58:	e44e                	sd	s3,8(sp)
    80004c5a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c5c:	00854783          	lbu	a5,8(a0)
    80004c60:	c3d5                	beqz	a5,80004d04 <fileread+0xb6>
    80004c62:	84aa                	mv	s1,a0
    80004c64:	89ae                	mv	s3,a1
    80004c66:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c68:	411c                	lw	a5,0(a0)
    80004c6a:	4705                	li	a4,1
    80004c6c:	04e78963          	beq	a5,a4,80004cbe <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c70:	470d                	li	a4,3
    80004c72:	04e78d63          	beq	a5,a4,80004ccc <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c76:	4709                	li	a4,2
    80004c78:	06e79e63          	bne	a5,a4,80004cf4 <fileread+0xa6>
    ilock(f->ip);
    80004c7c:	6d08                	ld	a0,24(a0)
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	008080e7          	jalr	8(ra) # 80003c86 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c86:	874a                	mv	a4,s2
    80004c88:	5094                	lw	a3,32(s1)
    80004c8a:	864e                	mv	a2,s3
    80004c8c:	4585                	li	a1,1
    80004c8e:	6c88                	ld	a0,24(s1)
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	2aa080e7          	jalr	682(ra) # 80003f3a <readi>
    80004c98:	892a                	mv	s2,a0
    80004c9a:	00a05563          	blez	a0,80004ca4 <fileread+0x56>
      f->off += r;
    80004c9e:	509c                	lw	a5,32(s1)
    80004ca0:	9fa9                	addw	a5,a5,a0
    80004ca2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004ca4:	6c88                	ld	a0,24(s1)
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	0a2080e7          	jalr	162(ra) # 80003d48 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004cae:	854a                	mv	a0,s2
    80004cb0:	70a2                	ld	ra,40(sp)
    80004cb2:	7402                	ld	s0,32(sp)
    80004cb4:	64e2                	ld	s1,24(sp)
    80004cb6:	6942                	ld	s2,16(sp)
    80004cb8:	69a2                	ld	s3,8(sp)
    80004cba:	6145                	addi	sp,sp,48
    80004cbc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004cbe:	6908                	ld	a0,16(a0)
    80004cc0:	00000097          	auipc	ra,0x0
    80004cc4:	3c6080e7          	jalr	966(ra) # 80005086 <piperead>
    80004cc8:	892a                	mv	s2,a0
    80004cca:	b7d5                	j	80004cae <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004ccc:	02451783          	lh	a5,36(a0)
    80004cd0:	03079693          	slli	a3,a5,0x30
    80004cd4:	92c1                	srli	a3,a3,0x30
    80004cd6:	4725                	li	a4,9
    80004cd8:	02d76863          	bltu	a4,a3,80004d08 <fileread+0xba>
    80004cdc:	0792                	slli	a5,a5,0x4
    80004cde:	0001d717          	auipc	a4,0x1d
    80004ce2:	52a70713          	addi	a4,a4,1322 # 80022208 <devsw>
    80004ce6:	97ba                	add	a5,a5,a4
    80004ce8:	639c                	ld	a5,0(a5)
    80004cea:	c38d                	beqz	a5,80004d0c <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004cec:	4505                	li	a0,1
    80004cee:	9782                	jalr	a5
    80004cf0:	892a                	mv	s2,a0
    80004cf2:	bf75                	j	80004cae <fileread+0x60>
    panic("fileread");
    80004cf4:	00004517          	auipc	a0,0x4
    80004cf8:	9ec50513          	addi	a0,a0,-1556 # 800086e0 <syscalls+0x280>
    80004cfc:	ffffc097          	auipc	ra,0xffffc
    80004d00:	842080e7          	jalr	-1982(ra) # 8000053e <panic>
    return -1;
    80004d04:	597d                	li	s2,-1
    80004d06:	b765                	j	80004cae <fileread+0x60>
      return -1;
    80004d08:	597d                	li	s2,-1
    80004d0a:	b755                	j	80004cae <fileread+0x60>
    80004d0c:	597d                	li	s2,-1
    80004d0e:	b745                	j	80004cae <fileread+0x60>

0000000080004d10 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004d10:	715d                	addi	sp,sp,-80
    80004d12:	e486                	sd	ra,72(sp)
    80004d14:	e0a2                	sd	s0,64(sp)
    80004d16:	fc26                	sd	s1,56(sp)
    80004d18:	f84a                	sd	s2,48(sp)
    80004d1a:	f44e                	sd	s3,40(sp)
    80004d1c:	f052                	sd	s4,32(sp)
    80004d1e:	ec56                	sd	s5,24(sp)
    80004d20:	e85a                	sd	s6,16(sp)
    80004d22:	e45e                	sd	s7,8(sp)
    80004d24:	e062                	sd	s8,0(sp)
    80004d26:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004d28:	00954783          	lbu	a5,9(a0)
    80004d2c:	10078663          	beqz	a5,80004e38 <filewrite+0x128>
    80004d30:	892a                	mv	s2,a0
    80004d32:	8aae                	mv	s5,a1
    80004d34:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d36:	411c                	lw	a5,0(a0)
    80004d38:	4705                	li	a4,1
    80004d3a:	02e78263          	beq	a5,a4,80004d5e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d3e:	470d                	li	a4,3
    80004d40:	02e78663          	beq	a5,a4,80004d6c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d44:	4709                	li	a4,2
    80004d46:	0ee79163          	bne	a5,a4,80004e28 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d4a:	0ac05d63          	blez	a2,80004e04 <filewrite+0xf4>
    int i = 0;
    80004d4e:	4981                	li	s3,0
    80004d50:	6b05                	lui	s6,0x1
    80004d52:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d56:	6b85                	lui	s7,0x1
    80004d58:	c00b8b9b          	addiw	s7,s7,-1024
    80004d5c:	a861                	j	80004df4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004d5e:	6908                	ld	a0,16(a0)
    80004d60:	00000097          	auipc	ra,0x0
    80004d64:	22e080e7          	jalr	558(ra) # 80004f8e <pipewrite>
    80004d68:	8a2a                	mv	s4,a0
    80004d6a:	a045                	j	80004e0a <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d6c:	02451783          	lh	a5,36(a0)
    80004d70:	03079693          	slli	a3,a5,0x30
    80004d74:	92c1                	srli	a3,a3,0x30
    80004d76:	4725                	li	a4,9
    80004d78:	0cd76263          	bltu	a4,a3,80004e3c <filewrite+0x12c>
    80004d7c:	0792                	slli	a5,a5,0x4
    80004d7e:	0001d717          	auipc	a4,0x1d
    80004d82:	48a70713          	addi	a4,a4,1162 # 80022208 <devsw>
    80004d86:	97ba                	add	a5,a5,a4
    80004d88:	679c                	ld	a5,8(a5)
    80004d8a:	cbdd                	beqz	a5,80004e40 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004d8c:	4505                	li	a0,1
    80004d8e:	9782                	jalr	a5
    80004d90:	8a2a                	mv	s4,a0
    80004d92:	a8a5                	j	80004e0a <filewrite+0xfa>
    80004d94:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004d98:	00000097          	auipc	ra,0x0
    80004d9c:	8b0080e7          	jalr	-1872(ra) # 80004648 <begin_op>
      ilock(f->ip);
    80004da0:	01893503          	ld	a0,24(s2)
    80004da4:	fffff097          	auipc	ra,0xfffff
    80004da8:	ee2080e7          	jalr	-286(ra) # 80003c86 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dac:	8762                	mv	a4,s8
    80004dae:	02092683          	lw	a3,32(s2)
    80004db2:	01598633          	add	a2,s3,s5
    80004db6:	4585                	li	a1,1
    80004db8:	01893503          	ld	a0,24(s2)
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	276080e7          	jalr	630(ra) # 80004032 <writei>
    80004dc4:	84aa                	mv	s1,a0
    80004dc6:	00a05763          	blez	a0,80004dd4 <filewrite+0xc4>
        f->off += r;
    80004dca:	02092783          	lw	a5,32(s2)
    80004dce:	9fa9                	addw	a5,a5,a0
    80004dd0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004dd4:	01893503          	ld	a0,24(s2)
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	f70080e7          	jalr	-144(ra) # 80003d48 <iunlock>
      end_op();
    80004de0:	00000097          	auipc	ra,0x0
    80004de4:	8e8080e7          	jalr	-1816(ra) # 800046c8 <end_op>

      if(r != n1){
    80004de8:	009c1f63          	bne	s8,s1,80004e06 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004dec:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004df0:	0149db63          	bge	s3,s4,80004e06 <filewrite+0xf6>
      int n1 = n - i;
    80004df4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004df8:	84be                	mv	s1,a5
    80004dfa:	2781                	sext.w	a5,a5
    80004dfc:	f8fb5ce3          	bge	s6,a5,80004d94 <filewrite+0x84>
    80004e00:	84de                	mv	s1,s7
    80004e02:	bf49                	j	80004d94 <filewrite+0x84>
    int i = 0;
    80004e04:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004e06:	013a1f63          	bne	s4,s3,80004e24 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e0a:	8552                	mv	a0,s4
    80004e0c:	60a6                	ld	ra,72(sp)
    80004e0e:	6406                	ld	s0,64(sp)
    80004e10:	74e2                	ld	s1,56(sp)
    80004e12:	7942                	ld	s2,48(sp)
    80004e14:	79a2                	ld	s3,40(sp)
    80004e16:	7a02                	ld	s4,32(sp)
    80004e18:	6ae2                	ld	s5,24(sp)
    80004e1a:	6b42                	ld	s6,16(sp)
    80004e1c:	6ba2                	ld	s7,8(sp)
    80004e1e:	6c02                	ld	s8,0(sp)
    80004e20:	6161                	addi	sp,sp,80
    80004e22:	8082                	ret
    ret = (i == n ? n : -1);
    80004e24:	5a7d                	li	s4,-1
    80004e26:	b7d5                	j	80004e0a <filewrite+0xfa>
    panic("filewrite");
    80004e28:	00004517          	auipc	a0,0x4
    80004e2c:	8c850513          	addi	a0,a0,-1848 # 800086f0 <syscalls+0x290>
    80004e30:	ffffb097          	auipc	ra,0xffffb
    80004e34:	70e080e7          	jalr	1806(ra) # 8000053e <panic>
    return -1;
    80004e38:	5a7d                	li	s4,-1
    80004e3a:	bfc1                	j	80004e0a <filewrite+0xfa>
      return -1;
    80004e3c:	5a7d                	li	s4,-1
    80004e3e:	b7f1                	j	80004e0a <filewrite+0xfa>
    80004e40:	5a7d                	li	s4,-1
    80004e42:	b7e1                	j	80004e0a <filewrite+0xfa>

0000000080004e44 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e44:	7179                	addi	sp,sp,-48
    80004e46:	f406                	sd	ra,40(sp)
    80004e48:	f022                	sd	s0,32(sp)
    80004e4a:	ec26                	sd	s1,24(sp)
    80004e4c:	e84a                	sd	s2,16(sp)
    80004e4e:	e44e                	sd	s3,8(sp)
    80004e50:	e052                	sd	s4,0(sp)
    80004e52:	1800                	addi	s0,sp,48
    80004e54:	84aa                	mv	s1,a0
    80004e56:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e58:	0005b023          	sd	zero,0(a1)
    80004e5c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e60:	00000097          	auipc	ra,0x0
    80004e64:	bf8080e7          	jalr	-1032(ra) # 80004a58 <filealloc>
    80004e68:	e088                	sd	a0,0(s1)
    80004e6a:	c551                	beqz	a0,80004ef6 <pipealloc+0xb2>
    80004e6c:	00000097          	auipc	ra,0x0
    80004e70:	bec080e7          	jalr	-1044(ra) # 80004a58 <filealloc>
    80004e74:	00aa3023          	sd	a0,0(s4)
    80004e78:	c92d                	beqz	a0,80004eea <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e7a:	ffffc097          	auipc	ra,0xffffc
    80004e7e:	c6c080e7          	jalr	-916(ra) # 80000ae6 <kalloc>
    80004e82:	892a                	mv	s2,a0
    80004e84:	c125                	beqz	a0,80004ee4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004e86:	4985                	li	s3,1
    80004e88:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e8c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e90:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e94:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e98:	00004597          	auipc	a1,0x4
    80004e9c:	86858593          	addi	a1,a1,-1944 # 80008700 <syscalls+0x2a0>
    80004ea0:	ffffc097          	auipc	ra,0xffffc
    80004ea4:	ca6080e7          	jalr	-858(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004ea8:	609c                	ld	a5,0(s1)
    80004eaa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004eae:	609c                	ld	a5,0(s1)
    80004eb0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004eb4:	609c                	ld	a5,0(s1)
    80004eb6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004eba:	609c                	ld	a5,0(s1)
    80004ebc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ec0:	000a3783          	ld	a5,0(s4)
    80004ec4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004ec8:	000a3783          	ld	a5,0(s4)
    80004ecc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ed0:	000a3783          	ld	a5,0(s4)
    80004ed4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ed8:	000a3783          	ld	a5,0(s4)
    80004edc:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ee0:	4501                	li	a0,0
    80004ee2:	a025                	j	80004f0a <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ee4:	6088                	ld	a0,0(s1)
    80004ee6:	e501                	bnez	a0,80004eee <pipealloc+0xaa>
    80004ee8:	a039                	j	80004ef6 <pipealloc+0xb2>
    80004eea:	6088                	ld	a0,0(s1)
    80004eec:	c51d                	beqz	a0,80004f1a <pipealloc+0xd6>
    fileclose(*f0);
    80004eee:	00000097          	auipc	ra,0x0
    80004ef2:	c26080e7          	jalr	-986(ra) # 80004b14 <fileclose>
  if(*f1)
    80004ef6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004efa:	557d                	li	a0,-1
  if(*f1)
    80004efc:	c799                	beqz	a5,80004f0a <pipealloc+0xc6>
    fileclose(*f1);
    80004efe:	853e                	mv	a0,a5
    80004f00:	00000097          	auipc	ra,0x0
    80004f04:	c14080e7          	jalr	-1004(ra) # 80004b14 <fileclose>
  return -1;
    80004f08:	557d                	li	a0,-1
}
    80004f0a:	70a2                	ld	ra,40(sp)
    80004f0c:	7402                	ld	s0,32(sp)
    80004f0e:	64e2                	ld	s1,24(sp)
    80004f10:	6942                	ld	s2,16(sp)
    80004f12:	69a2                	ld	s3,8(sp)
    80004f14:	6a02                	ld	s4,0(sp)
    80004f16:	6145                	addi	sp,sp,48
    80004f18:	8082                	ret
  return -1;
    80004f1a:	557d                	li	a0,-1
    80004f1c:	b7fd                	j	80004f0a <pipealloc+0xc6>

0000000080004f1e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f1e:	1101                	addi	sp,sp,-32
    80004f20:	ec06                	sd	ra,24(sp)
    80004f22:	e822                	sd	s0,16(sp)
    80004f24:	e426                	sd	s1,8(sp)
    80004f26:	e04a                	sd	s2,0(sp)
    80004f28:	1000                	addi	s0,sp,32
    80004f2a:	84aa                	mv	s1,a0
    80004f2c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f2e:	ffffc097          	auipc	ra,0xffffc
    80004f32:	ca8080e7          	jalr	-856(ra) # 80000bd6 <acquire>
  if(writable){
    80004f36:	02090d63          	beqz	s2,80004f70 <pipeclose+0x52>
    pi->writeopen = 0;
    80004f3a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f3e:	21848513          	addi	a0,s1,536
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	33e080e7          	jalr	830(ra) # 80002280 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f4a:	2204b783          	ld	a5,544(s1)
    80004f4e:	eb95                	bnez	a5,80004f82 <pipeclose+0x64>
    release(&pi->lock);
    80004f50:	8526                	mv	a0,s1
    80004f52:	ffffc097          	auipc	ra,0xffffc
    80004f56:	d38080e7          	jalr	-712(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004f5a:	8526                	mv	a0,s1
    80004f5c:	ffffc097          	auipc	ra,0xffffc
    80004f60:	a8e080e7          	jalr	-1394(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    80004f64:	60e2                	ld	ra,24(sp)
    80004f66:	6442                	ld	s0,16(sp)
    80004f68:	64a2                	ld	s1,8(sp)
    80004f6a:	6902                	ld	s2,0(sp)
    80004f6c:	6105                	addi	sp,sp,32
    80004f6e:	8082                	ret
    pi->readopen = 0;
    80004f70:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f74:	21c48513          	addi	a0,s1,540
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	308080e7          	jalr	776(ra) # 80002280 <wakeup>
    80004f80:	b7e9                	j	80004f4a <pipeclose+0x2c>
    release(&pi->lock);
    80004f82:	8526                	mv	a0,s1
    80004f84:	ffffc097          	auipc	ra,0xffffc
    80004f88:	d06080e7          	jalr	-762(ra) # 80000c8a <release>
}
    80004f8c:	bfe1                	j	80004f64 <pipeclose+0x46>

0000000080004f8e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f8e:	711d                	addi	sp,sp,-96
    80004f90:	ec86                	sd	ra,88(sp)
    80004f92:	e8a2                	sd	s0,80(sp)
    80004f94:	e4a6                	sd	s1,72(sp)
    80004f96:	e0ca                	sd	s2,64(sp)
    80004f98:	fc4e                	sd	s3,56(sp)
    80004f9a:	f852                	sd	s4,48(sp)
    80004f9c:	f456                	sd	s5,40(sp)
    80004f9e:	f05a                	sd	s6,32(sp)
    80004fa0:	ec5e                	sd	s7,24(sp)
    80004fa2:	e862                	sd	s8,16(sp)
    80004fa4:	1080                	addi	s0,sp,96
    80004fa6:	84aa                	mv	s1,a0
    80004fa8:	8aae                	mv	s5,a1
    80004faa:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	a00080e7          	jalr	-1536(ra) # 800019ac <myproc>
    80004fb4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004fb6:	8526                	mv	a0,s1
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	c1e080e7          	jalr	-994(ra) # 80000bd6 <acquire>
  while(i < n){
    80004fc0:	0b405663          	blez	s4,8000506c <pipewrite+0xde>
  int i = 0;
    80004fc4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004fc6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004fc8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004fcc:	21c48b93          	addi	s7,s1,540
    80004fd0:	a089                	j	80005012 <pipewrite+0x84>
      release(&pi->lock);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	ffffc097          	auipc	ra,0xffffc
    80004fd8:	cb6080e7          	jalr	-842(ra) # 80000c8a <release>
      return -1;
    80004fdc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004fde:	854a                	mv	a0,s2
    80004fe0:	60e6                	ld	ra,88(sp)
    80004fe2:	6446                	ld	s0,80(sp)
    80004fe4:	64a6                	ld	s1,72(sp)
    80004fe6:	6906                	ld	s2,64(sp)
    80004fe8:	79e2                	ld	s3,56(sp)
    80004fea:	7a42                	ld	s4,48(sp)
    80004fec:	7aa2                	ld	s5,40(sp)
    80004fee:	7b02                	ld	s6,32(sp)
    80004ff0:	6be2                	ld	s7,24(sp)
    80004ff2:	6c42                	ld	s8,16(sp)
    80004ff4:	6125                	addi	sp,sp,96
    80004ff6:	8082                	ret
      wakeup(&pi->nread);
    80004ff8:	8562                	mv	a0,s8
    80004ffa:	ffffd097          	auipc	ra,0xffffd
    80004ffe:	286080e7          	jalr	646(ra) # 80002280 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005002:	85a6                	mv	a1,s1
    80005004:	855e                	mv	a0,s7
    80005006:	ffffd097          	auipc	ra,0xffffd
    8000500a:	216080e7          	jalr	534(ra) # 8000221c <sleep>
  while(i < n){
    8000500e:	07495063          	bge	s2,s4,8000506e <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005012:	2204a783          	lw	a5,544(s1)
    80005016:	dfd5                	beqz	a5,80004fd2 <pipewrite+0x44>
    80005018:	854e                	mv	a0,s3
    8000501a:	ffffd097          	auipc	ra,0xffffd
    8000501e:	52a080e7          	jalr	1322(ra) # 80002544 <killed>
    80005022:	f945                	bnez	a0,80004fd2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005024:	2184a783          	lw	a5,536(s1)
    80005028:	21c4a703          	lw	a4,540(s1)
    8000502c:	2007879b          	addiw	a5,a5,512
    80005030:	fcf704e3          	beq	a4,a5,80004ff8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005034:	4685                	li	a3,1
    80005036:	01590633          	add	a2,s2,s5
    8000503a:	faf40593          	addi	a1,s0,-81
    8000503e:	0789b503          	ld	a0,120(s3)
    80005042:	ffffc097          	auipc	ra,0xffffc
    80005046:	6b2080e7          	jalr	1714(ra) # 800016f4 <copyin>
    8000504a:	03650263          	beq	a0,s6,8000506e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000504e:	21c4a783          	lw	a5,540(s1)
    80005052:	0017871b          	addiw	a4,a5,1
    80005056:	20e4ae23          	sw	a4,540(s1)
    8000505a:	1ff7f793          	andi	a5,a5,511
    8000505e:	97a6                	add	a5,a5,s1
    80005060:	faf44703          	lbu	a4,-81(s0)
    80005064:	00e78c23          	sb	a4,24(a5)
      i++;
    80005068:	2905                	addiw	s2,s2,1
    8000506a:	b755                	j	8000500e <pipewrite+0x80>
  int i = 0;
    8000506c:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000506e:	21848513          	addi	a0,s1,536
    80005072:	ffffd097          	auipc	ra,0xffffd
    80005076:	20e080e7          	jalr	526(ra) # 80002280 <wakeup>
  release(&pi->lock);
    8000507a:	8526                	mv	a0,s1
    8000507c:	ffffc097          	auipc	ra,0xffffc
    80005080:	c0e080e7          	jalr	-1010(ra) # 80000c8a <release>
  return i;
    80005084:	bfa9                	j	80004fde <pipewrite+0x50>

0000000080005086 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005086:	715d                	addi	sp,sp,-80
    80005088:	e486                	sd	ra,72(sp)
    8000508a:	e0a2                	sd	s0,64(sp)
    8000508c:	fc26                	sd	s1,56(sp)
    8000508e:	f84a                	sd	s2,48(sp)
    80005090:	f44e                	sd	s3,40(sp)
    80005092:	f052                	sd	s4,32(sp)
    80005094:	ec56                	sd	s5,24(sp)
    80005096:	e85a                	sd	s6,16(sp)
    80005098:	0880                	addi	s0,sp,80
    8000509a:	84aa                	mv	s1,a0
    8000509c:	892e                	mv	s2,a1
    8000509e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	90c080e7          	jalr	-1780(ra) # 800019ac <myproc>
    800050a8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050aa:	8526                	mv	a0,s1
    800050ac:	ffffc097          	auipc	ra,0xffffc
    800050b0:	b2a080e7          	jalr	-1238(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050b4:	2184a703          	lw	a4,536(s1)
    800050b8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050bc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050c0:	02f71763          	bne	a4,a5,800050ee <piperead+0x68>
    800050c4:	2244a783          	lw	a5,548(s1)
    800050c8:	c39d                	beqz	a5,800050ee <piperead+0x68>
    if(killed(pr)){
    800050ca:	8552                	mv	a0,s4
    800050cc:	ffffd097          	auipc	ra,0xffffd
    800050d0:	478080e7          	jalr	1144(ra) # 80002544 <killed>
    800050d4:	e941                	bnez	a0,80005164 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050d6:	85a6                	mv	a1,s1
    800050d8:	854e                	mv	a0,s3
    800050da:	ffffd097          	auipc	ra,0xffffd
    800050de:	142080e7          	jalr	322(ra) # 8000221c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050e2:	2184a703          	lw	a4,536(s1)
    800050e6:	21c4a783          	lw	a5,540(s1)
    800050ea:	fcf70de3          	beq	a4,a5,800050c4 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050ee:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800050f0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050f2:	05505363          	blez	s5,80005138 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800050f6:	2184a783          	lw	a5,536(s1)
    800050fa:	21c4a703          	lw	a4,540(s1)
    800050fe:	02f70d63          	beq	a4,a5,80005138 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005102:	0017871b          	addiw	a4,a5,1
    80005106:	20e4ac23          	sw	a4,536(s1)
    8000510a:	1ff7f793          	andi	a5,a5,511
    8000510e:	97a6                	add	a5,a5,s1
    80005110:	0187c783          	lbu	a5,24(a5)
    80005114:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005118:	4685                	li	a3,1
    8000511a:	fbf40613          	addi	a2,s0,-65
    8000511e:	85ca                	mv	a1,s2
    80005120:	078a3503          	ld	a0,120(s4)
    80005124:	ffffc097          	auipc	ra,0xffffc
    80005128:	544080e7          	jalr	1348(ra) # 80001668 <copyout>
    8000512c:	01650663          	beq	a0,s6,80005138 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005130:	2985                	addiw	s3,s3,1
    80005132:	0905                	addi	s2,s2,1
    80005134:	fd3a91e3          	bne	s5,s3,800050f6 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005138:	21c48513          	addi	a0,s1,540
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	144080e7          	jalr	324(ra) # 80002280 <wakeup>
  release(&pi->lock);
    80005144:	8526                	mv	a0,s1
    80005146:	ffffc097          	auipc	ra,0xffffc
    8000514a:	b44080e7          	jalr	-1212(ra) # 80000c8a <release>
  return i;
}
    8000514e:	854e                	mv	a0,s3
    80005150:	60a6                	ld	ra,72(sp)
    80005152:	6406                	ld	s0,64(sp)
    80005154:	74e2                	ld	s1,56(sp)
    80005156:	7942                	ld	s2,48(sp)
    80005158:	79a2                	ld	s3,40(sp)
    8000515a:	7a02                	ld	s4,32(sp)
    8000515c:	6ae2                	ld	s5,24(sp)
    8000515e:	6b42                	ld	s6,16(sp)
    80005160:	6161                	addi	sp,sp,80
    80005162:	8082                	ret
      release(&pi->lock);
    80005164:	8526                	mv	a0,s1
    80005166:	ffffc097          	auipc	ra,0xffffc
    8000516a:	b24080e7          	jalr	-1244(ra) # 80000c8a <release>
      return -1;
    8000516e:	59fd                	li	s3,-1
    80005170:	bff9                	j	8000514e <piperead+0xc8>

0000000080005172 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005172:	1141                	addi	sp,sp,-16
    80005174:	e422                	sd	s0,8(sp)
    80005176:	0800                	addi	s0,sp,16
    80005178:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000517a:	8905                	andi	a0,a0,1
    8000517c:	c111                	beqz	a0,80005180 <flags2perm+0xe>
      perm = PTE_X;
    8000517e:	4521                	li	a0,8
    if(flags & 0x2)
    80005180:	8b89                	andi	a5,a5,2
    80005182:	c399                	beqz	a5,80005188 <flags2perm+0x16>
      perm |= PTE_W;
    80005184:	00456513          	ori	a0,a0,4
    return perm;
}
    80005188:	6422                	ld	s0,8(sp)
    8000518a:	0141                	addi	sp,sp,16
    8000518c:	8082                	ret

000000008000518e <exec>:

int
exec(char *path, char **argv)
{
    8000518e:	de010113          	addi	sp,sp,-544
    80005192:	20113c23          	sd	ra,536(sp)
    80005196:	20813823          	sd	s0,528(sp)
    8000519a:	20913423          	sd	s1,520(sp)
    8000519e:	21213023          	sd	s2,512(sp)
    800051a2:	ffce                	sd	s3,504(sp)
    800051a4:	fbd2                	sd	s4,496(sp)
    800051a6:	f7d6                	sd	s5,488(sp)
    800051a8:	f3da                	sd	s6,480(sp)
    800051aa:	efde                	sd	s7,472(sp)
    800051ac:	ebe2                	sd	s8,464(sp)
    800051ae:	e7e6                	sd	s9,456(sp)
    800051b0:	e3ea                	sd	s10,448(sp)
    800051b2:	ff6e                	sd	s11,440(sp)
    800051b4:	1400                	addi	s0,sp,544
    800051b6:	892a                	mv	s2,a0
    800051b8:	dea43423          	sd	a0,-536(s0)
    800051bc:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800051c0:	ffffc097          	auipc	ra,0xffffc
    800051c4:	7ec080e7          	jalr	2028(ra) # 800019ac <myproc>
    800051c8:	84aa                	mv	s1,a0

  begin_op();
    800051ca:	fffff097          	auipc	ra,0xfffff
    800051ce:	47e080e7          	jalr	1150(ra) # 80004648 <begin_op>

  if((ip = namei(path)) == 0){
    800051d2:	854a                	mv	a0,s2
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	258080e7          	jalr	600(ra) # 8000442c <namei>
    800051dc:	c93d                	beqz	a0,80005252 <exec+0xc4>
    800051de:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	aa6080e7          	jalr	-1370(ra) # 80003c86 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800051e8:	04000713          	li	a4,64
    800051ec:	4681                	li	a3,0
    800051ee:	e5040613          	addi	a2,s0,-432
    800051f2:	4581                	li	a1,0
    800051f4:	8556                	mv	a0,s5
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	d44080e7          	jalr	-700(ra) # 80003f3a <readi>
    800051fe:	04000793          	li	a5,64
    80005202:	00f51a63          	bne	a0,a5,80005216 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005206:	e5042703          	lw	a4,-432(s0)
    8000520a:	464c47b7          	lui	a5,0x464c4
    8000520e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005212:	04f70663          	beq	a4,a5,8000525e <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005216:	8556                	mv	a0,s5
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	cd0080e7          	jalr	-816(ra) # 80003ee8 <iunlockput>
    end_op();
    80005220:	fffff097          	auipc	ra,0xfffff
    80005224:	4a8080e7          	jalr	1192(ra) # 800046c8 <end_op>
  }
  return -1;
    80005228:	557d                	li	a0,-1
}
    8000522a:	21813083          	ld	ra,536(sp)
    8000522e:	21013403          	ld	s0,528(sp)
    80005232:	20813483          	ld	s1,520(sp)
    80005236:	20013903          	ld	s2,512(sp)
    8000523a:	79fe                	ld	s3,504(sp)
    8000523c:	7a5e                	ld	s4,496(sp)
    8000523e:	7abe                	ld	s5,488(sp)
    80005240:	7b1e                	ld	s6,480(sp)
    80005242:	6bfe                	ld	s7,472(sp)
    80005244:	6c5e                	ld	s8,464(sp)
    80005246:	6cbe                	ld	s9,456(sp)
    80005248:	6d1e                	ld	s10,448(sp)
    8000524a:	7dfa                	ld	s11,440(sp)
    8000524c:	22010113          	addi	sp,sp,544
    80005250:	8082                	ret
    end_op();
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	476080e7          	jalr	1142(ra) # 800046c8 <end_op>
    return -1;
    8000525a:	557d                	li	a0,-1
    8000525c:	b7f9                	j	8000522a <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000525e:	8526                	mv	a0,s1
    80005260:	ffffd097          	auipc	ra,0xffffd
    80005264:	810080e7          	jalr	-2032(ra) # 80001a70 <proc_pagetable>
    80005268:	8b2a                	mv	s6,a0
    8000526a:	d555                	beqz	a0,80005216 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000526c:	e7042783          	lw	a5,-400(s0)
    80005270:	e8845703          	lhu	a4,-376(s0)
    80005274:	c735                	beqz	a4,800052e0 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005276:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005278:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000527c:	6a05                	lui	s4,0x1
    8000527e:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005282:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80005286:	6d85                	lui	s11,0x1
    80005288:	7d7d                	lui	s10,0xfffff
    8000528a:	a481                	j	800054ca <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000528c:	00003517          	auipc	a0,0x3
    80005290:	47c50513          	addi	a0,a0,1148 # 80008708 <syscalls+0x2a8>
    80005294:	ffffb097          	auipc	ra,0xffffb
    80005298:	2aa080e7          	jalr	682(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000529c:	874a                	mv	a4,s2
    8000529e:	009c86bb          	addw	a3,s9,s1
    800052a2:	4581                	li	a1,0
    800052a4:	8556                	mv	a0,s5
    800052a6:	fffff097          	auipc	ra,0xfffff
    800052aa:	c94080e7          	jalr	-876(ra) # 80003f3a <readi>
    800052ae:	2501                	sext.w	a0,a0
    800052b0:	1aa91a63          	bne	s2,a0,80005464 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800052b4:	009d84bb          	addw	s1,s11,s1
    800052b8:	013d09bb          	addw	s3,s10,s3
    800052bc:	1f74f763          	bgeu	s1,s7,800054aa <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800052c0:	02049593          	slli	a1,s1,0x20
    800052c4:	9181                	srli	a1,a1,0x20
    800052c6:	95e2                	add	a1,a1,s8
    800052c8:	855a                	mv	a0,s6
    800052ca:	ffffc097          	auipc	ra,0xffffc
    800052ce:	d92080e7          	jalr	-622(ra) # 8000105c <walkaddr>
    800052d2:	862a                	mv	a2,a0
    if(pa == 0)
    800052d4:	dd45                	beqz	a0,8000528c <exec+0xfe>
      n = PGSIZE;
    800052d6:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800052d8:	fd49f2e3          	bgeu	s3,s4,8000529c <exec+0x10e>
      n = sz - i;
    800052dc:	894e                	mv	s2,s3
    800052de:	bf7d                	j	8000529c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052e0:	4901                	li	s2,0
  iunlockput(ip);
    800052e2:	8556                	mv	a0,s5
    800052e4:	fffff097          	auipc	ra,0xfffff
    800052e8:	c04080e7          	jalr	-1020(ra) # 80003ee8 <iunlockput>
  end_op();
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	3dc080e7          	jalr	988(ra) # 800046c8 <end_op>
  p = myproc();
    800052f4:	ffffc097          	auipc	ra,0xffffc
    800052f8:	6b8080e7          	jalr	1720(ra) # 800019ac <myproc>
    800052fc:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800052fe:	07053d03          	ld	s10,112(a0)
  sz = PGROUNDUP(sz);
    80005302:	6785                	lui	a5,0x1
    80005304:	17fd                	addi	a5,a5,-1
    80005306:	993e                	add	s2,s2,a5
    80005308:	77fd                	lui	a5,0xfffff
    8000530a:	00f977b3          	and	a5,s2,a5
    8000530e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005312:	4691                	li	a3,4
    80005314:	6609                	lui	a2,0x2
    80005316:	963e                	add	a2,a2,a5
    80005318:	85be                	mv	a1,a5
    8000531a:	855a                	mv	a0,s6
    8000531c:	ffffc097          	auipc	ra,0xffffc
    80005320:	0f4080e7          	jalr	244(ra) # 80001410 <uvmalloc>
    80005324:	8c2a                	mv	s8,a0
  ip = 0;
    80005326:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005328:	12050e63          	beqz	a0,80005464 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000532c:	75f9                	lui	a1,0xffffe
    8000532e:	95aa                	add	a1,a1,a0
    80005330:	855a                	mv	a0,s6
    80005332:	ffffc097          	auipc	ra,0xffffc
    80005336:	304080e7          	jalr	772(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    8000533a:	7afd                	lui	s5,0xfffff
    8000533c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000533e:	df043783          	ld	a5,-528(s0)
    80005342:	6388                	ld	a0,0(a5)
    80005344:	c925                	beqz	a0,800053b4 <exec+0x226>
    80005346:	e9040993          	addi	s3,s0,-368
    8000534a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000534e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80005350:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	afc080e7          	jalr	-1284(ra) # 80000e4e <strlen>
    8000535a:	0015079b          	addiw	a5,a0,1
    8000535e:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005362:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005366:	13596663          	bltu	s2,s5,80005492 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000536a:	df043d83          	ld	s11,-528(s0)
    8000536e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005372:	8552                	mv	a0,s4
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	ada080e7          	jalr	-1318(ra) # 80000e4e <strlen>
    8000537c:	0015069b          	addiw	a3,a0,1
    80005380:	8652                	mv	a2,s4
    80005382:	85ca                	mv	a1,s2
    80005384:	855a                	mv	a0,s6
    80005386:	ffffc097          	auipc	ra,0xffffc
    8000538a:	2e2080e7          	jalr	738(ra) # 80001668 <copyout>
    8000538e:	10054663          	bltz	a0,8000549a <exec+0x30c>
    ustack[argc] = sp;
    80005392:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005396:	0485                	addi	s1,s1,1
    80005398:	008d8793          	addi	a5,s11,8
    8000539c:	def43823          	sd	a5,-528(s0)
    800053a0:	008db503          	ld	a0,8(s11)
    800053a4:	c911                	beqz	a0,800053b8 <exec+0x22a>
    if(argc >= MAXARG)
    800053a6:	09a1                	addi	s3,s3,8
    800053a8:	fb3c95e3          	bne	s9,s3,80005352 <exec+0x1c4>
  sz = sz1;
    800053ac:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053b0:	4a81                	li	s5,0
    800053b2:	a84d                	j	80005464 <exec+0x2d6>
  sp = sz;
    800053b4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800053b6:	4481                	li	s1,0
  ustack[argc] = 0;
    800053b8:	00349793          	slli	a5,s1,0x3
    800053bc:	f9040713          	addi	a4,s0,-112
    800053c0:	97ba                	add	a5,a5,a4
    800053c2:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdbb60>
  sp -= (argc+1) * sizeof(uint64);
    800053c6:	00148693          	addi	a3,s1,1
    800053ca:	068e                	slli	a3,a3,0x3
    800053cc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800053d0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800053d4:	01597663          	bgeu	s2,s5,800053e0 <exec+0x252>
  sz = sz1;
    800053d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800053dc:	4a81                	li	s5,0
    800053de:	a059                	j	80005464 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800053e0:	e9040613          	addi	a2,s0,-368
    800053e4:	85ca                	mv	a1,s2
    800053e6:	855a                	mv	a0,s6
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	280080e7          	jalr	640(ra) # 80001668 <copyout>
    800053f0:	0a054963          	bltz	a0,800054a2 <exec+0x314>
  p->trapframe->a1 = sp;
    800053f4:	080bb783          	ld	a5,128(s7) # 1080 <_entry-0x7fffef80>
    800053f8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800053fc:	de843783          	ld	a5,-536(s0)
    80005400:	0007c703          	lbu	a4,0(a5)
    80005404:	cf11                	beqz	a4,80005420 <exec+0x292>
    80005406:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005408:	02f00693          	li	a3,47
    8000540c:	a039                	j	8000541a <exec+0x28c>
      last = s+1;
    8000540e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005412:	0785                	addi	a5,a5,1
    80005414:	fff7c703          	lbu	a4,-1(a5)
    80005418:	c701                	beqz	a4,80005420 <exec+0x292>
    if(*s == '/')
    8000541a:	fed71ce3          	bne	a4,a3,80005412 <exec+0x284>
    8000541e:	bfc5                	j	8000540e <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80005420:	4641                	li	a2,16
    80005422:	de843583          	ld	a1,-536(s0)
    80005426:	180b8513          	addi	a0,s7,384
    8000542a:	ffffc097          	auipc	ra,0xffffc
    8000542e:	9f2080e7          	jalr	-1550(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80005432:	078bb503          	ld	a0,120(s7)
  p->pagetable = pagetable;
    80005436:	076bbc23          	sd	s6,120(s7)
  p->sz = sz;
    8000543a:	078bb823          	sd	s8,112(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000543e:	080bb783          	ld	a5,128(s7)
    80005442:	e6843703          	ld	a4,-408(s0)
    80005446:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005448:	080bb783          	ld	a5,128(s7)
    8000544c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005450:	85ea                	mv	a1,s10
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	6ba080e7          	jalr	1722(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000545a:	0004851b          	sext.w	a0,s1
    8000545e:	b3f1                	j	8000522a <exec+0x9c>
    80005460:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005464:	df843583          	ld	a1,-520(s0)
    80005468:	855a                	mv	a0,s6
    8000546a:	ffffc097          	auipc	ra,0xffffc
    8000546e:	6a2080e7          	jalr	1698(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80005472:	da0a92e3          	bnez	s5,80005216 <exec+0x88>
  return -1;
    80005476:	557d                	li	a0,-1
    80005478:	bb4d                	j	8000522a <exec+0x9c>
    8000547a:	df243c23          	sd	s2,-520(s0)
    8000547e:	b7dd                	j	80005464 <exec+0x2d6>
    80005480:	df243c23          	sd	s2,-520(s0)
    80005484:	b7c5                	j	80005464 <exec+0x2d6>
    80005486:	df243c23          	sd	s2,-520(s0)
    8000548a:	bfe9                	j	80005464 <exec+0x2d6>
    8000548c:	df243c23          	sd	s2,-520(s0)
    80005490:	bfd1                	j	80005464 <exec+0x2d6>
  sz = sz1;
    80005492:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005496:	4a81                	li	s5,0
    80005498:	b7f1                	j	80005464 <exec+0x2d6>
  sz = sz1;
    8000549a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000549e:	4a81                	li	s5,0
    800054a0:	b7d1                	j	80005464 <exec+0x2d6>
  sz = sz1;
    800054a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800054a6:	4a81                	li	s5,0
    800054a8:	bf75                	j	80005464 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800054aa:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054ae:	e0843783          	ld	a5,-504(s0)
    800054b2:	0017869b          	addiw	a3,a5,1
    800054b6:	e0d43423          	sd	a3,-504(s0)
    800054ba:	e0043783          	ld	a5,-512(s0)
    800054be:	0387879b          	addiw	a5,a5,56
    800054c2:	e8845703          	lhu	a4,-376(s0)
    800054c6:	e0e6dee3          	bge	a3,a4,800052e2 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054ca:	2781                	sext.w	a5,a5
    800054cc:	e0f43023          	sd	a5,-512(s0)
    800054d0:	03800713          	li	a4,56
    800054d4:	86be                	mv	a3,a5
    800054d6:	e1840613          	addi	a2,s0,-488
    800054da:	4581                	li	a1,0
    800054dc:	8556                	mv	a0,s5
    800054de:	fffff097          	auipc	ra,0xfffff
    800054e2:	a5c080e7          	jalr	-1444(ra) # 80003f3a <readi>
    800054e6:	03800793          	li	a5,56
    800054ea:	f6f51be3          	bne	a0,a5,80005460 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800054ee:	e1842783          	lw	a5,-488(s0)
    800054f2:	4705                	li	a4,1
    800054f4:	fae79de3          	bne	a5,a4,800054ae <exec+0x320>
    if(ph.memsz < ph.filesz)
    800054f8:	e4043483          	ld	s1,-448(s0)
    800054fc:	e3843783          	ld	a5,-456(s0)
    80005500:	f6f4ede3          	bltu	s1,a5,8000547a <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005504:	e2843783          	ld	a5,-472(s0)
    80005508:	94be                	add	s1,s1,a5
    8000550a:	f6f4ebe3          	bltu	s1,a5,80005480 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    8000550e:	de043703          	ld	a4,-544(s0)
    80005512:	8ff9                	and	a5,a5,a4
    80005514:	fbad                	bnez	a5,80005486 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005516:	e1c42503          	lw	a0,-484(s0)
    8000551a:	00000097          	auipc	ra,0x0
    8000551e:	c58080e7          	jalr	-936(ra) # 80005172 <flags2perm>
    80005522:	86aa                	mv	a3,a0
    80005524:	8626                	mv	a2,s1
    80005526:	85ca                	mv	a1,s2
    80005528:	855a                	mv	a0,s6
    8000552a:	ffffc097          	auipc	ra,0xffffc
    8000552e:	ee6080e7          	jalr	-282(ra) # 80001410 <uvmalloc>
    80005532:	dea43c23          	sd	a0,-520(s0)
    80005536:	d939                	beqz	a0,8000548c <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005538:	e2843c03          	ld	s8,-472(s0)
    8000553c:	e2042c83          	lw	s9,-480(s0)
    80005540:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005544:	f60b83e3          	beqz	s7,800054aa <exec+0x31c>
    80005548:	89de                	mv	s3,s7
    8000554a:	4481                	li	s1,0
    8000554c:	bb95                	j	800052c0 <exec+0x132>

000000008000554e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000554e:	7179                	addi	sp,sp,-48
    80005550:	f406                	sd	ra,40(sp)
    80005552:	f022                	sd	s0,32(sp)
    80005554:	ec26                	sd	s1,24(sp)
    80005556:	e84a                	sd	s2,16(sp)
    80005558:	1800                	addi	s0,sp,48
    8000555a:	892e                	mv	s2,a1
    8000555c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000555e:	fdc40593          	addi	a1,s0,-36
    80005562:	ffffe097          	auipc	ra,0xffffe
    80005566:	a86080e7          	jalr	-1402(ra) # 80002fe8 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000556a:	fdc42703          	lw	a4,-36(s0)
    8000556e:	47bd                	li	a5,15
    80005570:	02e7eb63          	bltu	a5,a4,800055a6 <argfd+0x58>
    80005574:	ffffc097          	auipc	ra,0xffffc
    80005578:	438080e7          	jalr	1080(ra) # 800019ac <myproc>
    8000557c:	fdc42703          	lw	a4,-36(s0)
    80005580:	01e70793          	addi	a5,a4,30
    80005584:	078e                	slli	a5,a5,0x3
    80005586:	953e                	add	a0,a0,a5
    80005588:	651c                	ld	a5,8(a0)
    8000558a:	c385                	beqz	a5,800055aa <argfd+0x5c>
    return -1;
  if(pfd)
    8000558c:	00090463          	beqz	s2,80005594 <argfd+0x46>
    *pfd = fd;
    80005590:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005594:	4501                	li	a0,0
  if(pf)
    80005596:	c091                	beqz	s1,8000559a <argfd+0x4c>
    *pf = f;
    80005598:	e09c                	sd	a5,0(s1)
}
    8000559a:	70a2                	ld	ra,40(sp)
    8000559c:	7402                	ld	s0,32(sp)
    8000559e:	64e2                	ld	s1,24(sp)
    800055a0:	6942                	ld	s2,16(sp)
    800055a2:	6145                	addi	sp,sp,48
    800055a4:	8082                	ret
    return -1;
    800055a6:	557d                	li	a0,-1
    800055a8:	bfcd                	j	8000559a <argfd+0x4c>
    800055aa:	557d                	li	a0,-1
    800055ac:	b7fd                	j	8000559a <argfd+0x4c>

00000000800055ae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055ae:	1101                	addi	sp,sp,-32
    800055b0:	ec06                	sd	ra,24(sp)
    800055b2:	e822                	sd	s0,16(sp)
    800055b4:	e426                	sd	s1,8(sp)
    800055b6:	1000                	addi	s0,sp,32
    800055b8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055ba:	ffffc097          	auipc	ra,0xffffc
    800055be:	3f2080e7          	jalr	1010(ra) # 800019ac <myproc>
    800055c2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800055c4:	0f850793          	addi	a5,a0,248
    800055c8:	4501                	li	a0,0
    800055ca:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800055cc:	6398                	ld	a4,0(a5)
    800055ce:	cb19                	beqz	a4,800055e4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800055d0:	2505                	addiw	a0,a0,1
    800055d2:	07a1                	addi	a5,a5,8
    800055d4:	fed51ce3          	bne	a0,a3,800055cc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055d8:	557d                	li	a0,-1
}
    800055da:	60e2                	ld	ra,24(sp)
    800055dc:	6442                	ld	s0,16(sp)
    800055de:	64a2                	ld	s1,8(sp)
    800055e0:	6105                	addi	sp,sp,32
    800055e2:	8082                	ret
      p->ofile[fd] = f;
    800055e4:	01e50793          	addi	a5,a0,30
    800055e8:	078e                	slli	a5,a5,0x3
    800055ea:	963e                	add	a2,a2,a5
    800055ec:	e604                	sd	s1,8(a2)
      return fd;
    800055ee:	b7f5                	j	800055da <fdalloc+0x2c>

00000000800055f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800055f0:	715d                	addi	sp,sp,-80
    800055f2:	e486                	sd	ra,72(sp)
    800055f4:	e0a2                	sd	s0,64(sp)
    800055f6:	fc26                	sd	s1,56(sp)
    800055f8:	f84a                	sd	s2,48(sp)
    800055fa:	f44e                	sd	s3,40(sp)
    800055fc:	f052                	sd	s4,32(sp)
    800055fe:	ec56                	sd	s5,24(sp)
    80005600:	e85a                	sd	s6,16(sp)
    80005602:	0880                	addi	s0,sp,80
    80005604:	8b2e                	mv	s6,a1
    80005606:	89b2                	mv	s3,a2
    80005608:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000560a:	fb040593          	addi	a1,s0,-80
    8000560e:	fffff097          	auipc	ra,0xfffff
    80005612:	e3c080e7          	jalr	-452(ra) # 8000444a <nameiparent>
    80005616:	84aa                	mv	s1,a0
    80005618:	14050f63          	beqz	a0,80005776 <create+0x186>
    return 0;

  ilock(dp);
    8000561c:	ffffe097          	auipc	ra,0xffffe
    80005620:	66a080e7          	jalr	1642(ra) # 80003c86 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005624:	4601                	li	a2,0
    80005626:	fb040593          	addi	a1,s0,-80
    8000562a:	8526                	mv	a0,s1
    8000562c:	fffff097          	auipc	ra,0xfffff
    80005630:	b3e080e7          	jalr	-1218(ra) # 8000416a <dirlookup>
    80005634:	8aaa                	mv	s5,a0
    80005636:	c931                	beqz	a0,8000568a <create+0x9a>
    iunlockput(dp);
    80005638:	8526                	mv	a0,s1
    8000563a:	fffff097          	auipc	ra,0xfffff
    8000563e:	8ae080e7          	jalr	-1874(ra) # 80003ee8 <iunlockput>
    ilock(ip);
    80005642:	8556                	mv	a0,s5
    80005644:	ffffe097          	auipc	ra,0xffffe
    80005648:	642080e7          	jalr	1602(ra) # 80003c86 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000564c:	000b059b          	sext.w	a1,s6
    80005650:	4789                	li	a5,2
    80005652:	02f59563          	bne	a1,a5,8000567c <create+0x8c>
    80005656:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdbca4>
    8000565a:	37f9                	addiw	a5,a5,-2
    8000565c:	17c2                	slli	a5,a5,0x30
    8000565e:	93c1                	srli	a5,a5,0x30
    80005660:	4705                	li	a4,1
    80005662:	00f76d63          	bltu	a4,a5,8000567c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005666:	8556                	mv	a0,s5
    80005668:	60a6                	ld	ra,72(sp)
    8000566a:	6406                	ld	s0,64(sp)
    8000566c:	74e2                	ld	s1,56(sp)
    8000566e:	7942                	ld	s2,48(sp)
    80005670:	79a2                	ld	s3,40(sp)
    80005672:	7a02                	ld	s4,32(sp)
    80005674:	6ae2                	ld	s5,24(sp)
    80005676:	6b42                	ld	s6,16(sp)
    80005678:	6161                	addi	sp,sp,80
    8000567a:	8082                	ret
    iunlockput(ip);
    8000567c:	8556                	mv	a0,s5
    8000567e:	fffff097          	auipc	ra,0xfffff
    80005682:	86a080e7          	jalr	-1942(ra) # 80003ee8 <iunlockput>
    return 0;
    80005686:	4a81                	li	s5,0
    80005688:	bff9                	j	80005666 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000568a:	85da                	mv	a1,s6
    8000568c:	4088                	lw	a0,0(s1)
    8000568e:	ffffe097          	auipc	ra,0xffffe
    80005692:	45c080e7          	jalr	1116(ra) # 80003aea <ialloc>
    80005696:	8a2a                	mv	s4,a0
    80005698:	c539                	beqz	a0,800056e6 <create+0xf6>
  ilock(ip);
    8000569a:	ffffe097          	auipc	ra,0xffffe
    8000569e:	5ec080e7          	jalr	1516(ra) # 80003c86 <ilock>
  ip->major = major;
    800056a2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056a6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056aa:	4905                	li	s2,1
    800056ac:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800056b0:	8552                	mv	a0,s4
    800056b2:	ffffe097          	auipc	ra,0xffffe
    800056b6:	50a080e7          	jalr	1290(ra) # 80003bbc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056ba:	000b059b          	sext.w	a1,s6
    800056be:	03258b63          	beq	a1,s2,800056f4 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800056c2:	004a2603          	lw	a2,4(s4)
    800056c6:	fb040593          	addi	a1,s0,-80
    800056ca:	8526                	mv	a0,s1
    800056cc:	fffff097          	auipc	ra,0xfffff
    800056d0:	cae080e7          	jalr	-850(ra) # 8000437a <dirlink>
    800056d4:	06054f63          	bltz	a0,80005752 <create+0x162>
  iunlockput(dp);
    800056d8:	8526                	mv	a0,s1
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	80e080e7          	jalr	-2034(ra) # 80003ee8 <iunlockput>
  return ip;
    800056e2:	8ad2                	mv	s5,s4
    800056e4:	b749                	j	80005666 <create+0x76>
    iunlockput(dp);
    800056e6:	8526                	mv	a0,s1
    800056e8:	fffff097          	auipc	ra,0xfffff
    800056ec:	800080e7          	jalr	-2048(ra) # 80003ee8 <iunlockput>
    return 0;
    800056f0:	8ad2                	mv	s5,s4
    800056f2:	bf95                	j	80005666 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056f4:	004a2603          	lw	a2,4(s4)
    800056f8:	00003597          	auipc	a1,0x3
    800056fc:	03058593          	addi	a1,a1,48 # 80008728 <syscalls+0x2c8>
    80005700:	8552                	mv	a0,s4
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	c78080e7          	jalr	-904(ra) # 8000437a <dirlink>
    8000570a:	04054463          	bltz	a0,80005752 <create+0x162>
    8000570e:	40d0                	lw	a2,4(s1)
    80005710:	00003597          	auipc	a1,0x3
    80005714:	02058593          	addi	a1,a1,32 # 80008730 <syscalls+0x2d0>
    80005718:	8552                	mv	a0,s4
    8000571a:	fffff097          	auipc	ra,0xfffff
    8000571e:	c60080e7          	jalr	-928(ra) # 8000437a <dirlink>
    80005722:	02054863          	bltz	a0,80005752 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80005726:	004a2603          	lw	a2,4(s4)
    8000572a:	fb040593          	addi	a1,s0,-80
    8000572e:	8526                	mv	a0,s1
    80005730:	fffff097          	auipc	ra,0xfffff
    80005734:	c4a080e7          	jalr	-950(ra) # 8000437a <dirlink>
    80005738:	00054d63          	bltz	a0,80005752 <create+0x162>
    dp->nlink++;  // for ".."
    8000573c:	04a4d783          	lhu	a5,74(s1)
    80005740:	2785                	addiw	a5,a5,1
    80005742:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005746:	8526                	mv	a0,s1
    80005748:	ffffe097          	auipc	ra,0xffffe
    8000574c:	474080e7          	jalr	1140(ra) # 80003bbc <iupdate>
    80005750:	b761                	j	800056d8 <create+0xe8>
  ip->nlink = 0;
    80005752:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005756:	8552                	mv	a0,s4
    80005758:	ffffe097          	auipc	ra,0xffffe
    8000575c:	464080e7          	jalr	1124(ra) # 80003bbc <iupdate>
  iunlockput(ip);
    80005760:	8552                	mv	a0,s4
    80005762:	ffffe097          	auipc	ra,0xffffe
    80005766:	786080e7          	jalr	1926(ra) # 80003ee8 <iunlockput>
  iunlockput(dp);
    8000576a:	8526                	mv	a0,s1
    8000576c:	ffffe097          	auipc	ra,0xffffe
    80005770:	77c080e7          	jalr	1916(ra) # 80003ee8 <iunlockput>
  return 0;
    80005774:	bdcd                	j	80005666 <create+0x76>
    return 0;
    80005776:	8aaa                	mv	s5,a0
    80005778:	b5fd                	j	80005666 <create+0x76>

000000008000577a <sys_dup>:
{
    8000577a:	7179                	addi	sp,sp,-48
    8000577c:	f406                	sd	ra,40(sp)
    8000577e:	f022                	sd	s0,32(sp)
    80005780:	ec26                	sd	s1,24(sp)
    80005782:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005784:	fd840613          	addi	a2,s0,-40
    80005788:	4581                	li	a1,0
    8000578a:	4501                	li	a0,0
    8000578c:	00000097          	auipc	ra,0x0
    80005790:	dc2080e7          	jalr	-574(ra) # 8000554e <argfd>
    return -1;
    80005794:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005796:	02054363          	bltz	a0,800057bc <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000579a:	fd843503          	ld	a0,-40(s0)
    8000579e:	00000097          	auipc	ra,0x0
    800057a2:	e10080e7          	jalr	-496(ra) # 800055ae <fdalloc>
    800057a6:	84aa                	mv	s1,a0
    return -1;
    800057a8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057aa:	00054963          	bltz	a0,800057bc <sys_dup+0x42>
  filedup(f);
    800057ae:	fd843503          	ld	a0,-40(s0)
    800057b2:	fffff097          	auipc	ra,0xfffff
    800057b6:	310080e7          	jalr	784(ra) # 80004ac2 <filedup>
  return fd;
    800057ba:	87a6                	mv	a5,s1
}
    800057bc:	853e                	mv	a0,a5
    800057be:	70a2                	ld	ra,40(sp)
    800057c0:	7402                	ld	s0,32(sp)
    800057c2:	64e2                	ld	s1,24(sp)
    800057c4:	6145                	addi	sp,sp,48
    800057c6:	8082                	ret

00000000800057c8 <sys_read>:
{
    800057c8:	7179                	addi	sp,sp,-48
    800057ca:	f406                	sd	ra,40(sp)
    800057cc:	f022                	sd	s0,32(sp)
    800057ce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057d0:	fd840593          	addi	a1,s0,-40
    800057d4:	4505                	li	a0,1
    800057d6:	ffffe097          	auipc	ra,0xffffe
    800057da:	832080e7          	jalr	-1998(ra) # 80003008 <argaddr>
  argint(2, &n);
    800057de:	fe440593          	addi	a1,s0,-28
    800057e2:	4509                	li	a0,2
    800057e4:	ffffe097          	auipc	ra,0xffffe
    800057e8:	804080e7          	jalr	-2044(ra) # 80002fe8 <argint>
  if(argfd(0, 0, &f) < 0)
    800057ec:	fe840613          	addi	a2,s0,-24
    800057f0:	4581                	li	a1,0
    800057f2:	4501                	li	a0,0
    800057f4:	00000097          	auipc	ra,0x0
    800057f8:	d5a080e7          	jalr	-678(ra) # 8000554e <argfd>
    800057fc:	87aa                	mv	a5,a0
    return -1;
    800057fe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005800:	0007cc63          	bltz	a5,80005818 <sys_read+0x50>
  return fileread(f, p, n);
    80005804:	fe442603          	lw	a2,-28(s0)
    80005808:	fd843583          	ld	a1,-40(s0)
    8000580c:	fe843503          	ld	a0,-24(s0)
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	43e080e7          	jalr	1086(ra) # 80004c4e <fileread>
}
    80005818:	70a2                	ld	ra,40(sp)
    8000581a:	7402                	ld	s0,32(sp)
    8000581c:	6145                	addi	sp,sp,48
    8000581e:	8082                	ret

0000000080005820 <sys_write>:
{
    80005820:	7179                	addi	sp,sp,-48
    80005822:	f406                	sd	ra,40(sp)
    80005824:	f022                	sd	s0,32(sp)
    80005826:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005828:	fd840593          	addi	a1,s0,-40
    8000582c:	4505                	li	a0,1
    8000582e:	ffffd097          	auipc	ra,0xffffd
    80005832:	7da080e7          	jalr	2010(ra) # 80003008 <argaddr>
  argint(2, &n);
    80005836:	fe440593          	addi	a1,s0,-28
    8000583a:	4509                	li	a0,2
    8000583c:	ffffd097          	auipc	ra,0xffffd
    80005840:	7ac080e7          	jalr	1964(ra) # 80002fe8 <argint>
  if(argfd(0, 0, &f) < 0)
    80005844:	fe840613          	addi	a2,s0,-24
    80005848:	4581                	li	a1,0
    8000584a:	4501                	li	a0,0
    8000584c:	00000097          	auipc	ra,0x0
    80005850:	d02080e7          	jalr	-766(ra) # 8000554e <argfd>
    80005854:	87aa                	mv	a5,a0
    return -1;
    80005856:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005858:	0007cc63          	bltz	a5,80005870 <sys_write+0x50>
  return filewrite(f, p, n);
    8000585c:	fe442603          	lw	a2,-28(s0)
    80005860:	fd843583          	ld	a1,-40(s0)
    80005864:	fe843503          	ld	a0,-24(s0)
    80005868:	fffff097          	auipc	ra,0xfffff
    8000586c:	4a8080e7          	jalr	1192(ra) # 80004d10 <filewrite>
}
    80005870:	70a2                	ld	ra,40(sp)
    80005872:	7402                	ld	s0,32(sp)
    80005874:	6145                	addi	sp,sp,48
    80005876:	8082                	ret

0000000080005878 <sys_close>:
{
    80005878:	1101                	addi	sp,sp,-32
    8000587a:	ec06                	sd	ra,24(sp)
    8000587c:	e822                	sd	s0,16(sp)
    8000587e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005880:	fe040613          	addi	a2,s0,-32
    80005884:	fec40593          	addi	a1,s0,-20
    80005888:	4501                	li	a0,0
    8000588a:	00000097          	auipc	ra,0x0
    8000588e:	cc4080e7          	jalr	-828(ra) # 8000554e <argfd>
    return -1;
    80005892:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005894:	02054463          	bltz	a0,800058bc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005898:	ffffc097          	auipc	ra,0xffffc
    8000589c:	114080e7          	jalr	276(ra) # 800019ac <myproc>
    800058a0:	fec42783          	lw	a5,-20(s0)
    800058a4:	07f9                	addi	a5,a5,30
    800058a6:	078e                	slli	a5,a5,0x3
    800058a8:	97aa                	add	a5,a5,a0
    800058aa:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800058ae:	fe043503          	ld	a0,-32(s0)
    800058b2:	fffff097          	auipc	ra,0xfffff
    800058b6:	262080e7          	jalr	610(ra) # 80004b14 <fileclose>
  return 0;
    800058ba:	4781                	li	a5,0
}
    800058bc:	853e                	mv	a0,a5
    800058be:	60e2                	ld	ra,24(sp)
    800058c0:	6442                	ld	s0,16(sp)
    800058c2:	6105                	addi	sp,sp,32
    800058c4:	8082                	ret

00000000800058c6 <sys_fstat>:
{
    800058c6:	1101                	addi	sp,sp,-32
    800058c8:	ec06                	sd	ra,24(sp)
    800058ca:	e822                	sd	s0,16(sp)
    800058cc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058ce:	fe040593          	addi	a1,s0,-32
    800058d2:	4505                	li	a0,1
    800058d4:	ffffd097          	auipc	ra,0xffffd
    800058d8:	734080e7          	jalr	1844(ra) # 80003008 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058dc:	fe840613          	addi	a2,s0,-24
    800058e0:	4581                	li	a1,0
    800058e2:	4501                	li	a0,0
    800058e4:	00000097          	auipc	ra,0x0
    800058e8:	c6a080e7          	jalr	-918(ra) # 8000554e <argfd>
    800058ec:	87aa                	mv	a5,a0
    return -1;
    800058ee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058f0:	0007ca63          	bltz	a5,80005904 <sys_fstat+0x3e>
  return filestat(f, st);
    800058f4:	fe043583          	ld	a1,-32(s0)
    800058f8:	fe843503          	ld	a0,-24(s0)
    800058fc:	fffff097          	auipc	ra,0xfffff
    80005900:	2e0080e7          	jalr	736(ra) # 80004bdc <filestat>
}
    80005904:	60e2                	ld	ra,24(sp)
    80005906:	6442                	ld	s0,16(sp)
    80005908:	6105                	addi	sp,sp,32
    8000590a:	8082                	ret

000000008000590c <sys_link>:
{
    8000590c:	7169                	addi	sp,sp,-304
    8000590e:	f606                	sd	ra,296(sp)
    80005910:	f222                	sd	s0,288(sp)
    80005912:	ee26                	sd	s1,280(sp)
    80005914:	ea4a                	sd	s2,272(sp)
    80005916:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005918:	08000613          	li	a2,128
    8000591c:	ed040593          	addi	a1,s0,-304
    80005920:	4501                	li	a0,0
    80005922:	ffffd097          	auipc	ra,0xffffd
    80005926:	706080e7          	jalr	1798(ra) # 80003028 <argstr>
    return -1;
    8000592a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000592c:	10054e63          	bltz	a0,80005a48 <sys_link+0x13c>
    80005930:	08000613          	li	a2,128
    80005934:	f5040593          	addi	a1,s0,-176
    80005938:	4505                	li	a0,1
    8000593a:	ffffd097          	auipc	ra,0xffffd
    8000593e:	6ee080e7          	jalr	1774(ra) # 80003028 <argstr>
    return -1;
    80005942:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005944:	10054263          	bltz	a0,80005a48 <sys_link+0x13c>
  begin_op();
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	d00080e7          	jalr	-768(ra) # 80004648 <begin_op>
  if((ip = namei(old)) == 0){
    80005950:	ed040513          	addi	a0,s0,-304
    80005954:	fffff097          	auipc	ra,0xfffff
    80005958:	ad8080e7          	jalr	-1320(ra) # 8000442c <namei>
    8000595c:	84aa                	mv	s1,a0
    8000595e:	c551                	beqz	a0,800059ea <sys_link+0xde>
  ilock(ip);
    80005960:	ffffe097          	auipc	ra,0xffffe
    80005964:	326080e7          	jalr	806(ra) # 80003c86 <ilock>
  if(ip->type == T_DIR){
    80005968:	04449703          	lh	a4,68(s1)
    8000596c:	4785                	li	a5,1
    8000596e:	08f70463          	beq	a4,a5,800059f6 <sys_link+0xea>
  ip->nlink++;
    80005972:	04a4d783          	lhu	a5,74(s1)
    80005976:	2785                	addiw	a5,a5,1
    80005978:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000597c:	8526                	mv	a0,s1
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	23e080e7          	jalr	574(ra) # 80003bbc <iupdate>
  iunlock(ip);
    80005986:	8526                	mv	a0,s1
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	3c0080e7          	jalr	960(ra) # 80003d48 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005990:	fd040593          	addi	a1,s0,-48
    80005994:	f5040513          	addi	a0,s0,-176
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	ab2080e7          	jalr	-1358(ra) # 8000444a <nameiparent>
    800059a0:	892a                	mv	s2,a0
    800059a2:	c935                	beqz	a0,80005a16 <sys_link+0x10a>
  ilock(dp);
    800059a4:	ffffe097          	auipc	ra,0xffffe
    800059a8:	2e2080e7          	jalr	738(ra) # 80003c86 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059ac:	00092703          	lw	a4,0(s2)
    800059b0:	409c                	lw	a5,0(s1)
    800059b2:	04f71d63          	bne	a4,a5,80005a0c <sys_link+0x100>
    800059b6:	40d0                	lw	a2,4(s1)
    800059b8:	fd040593          	addi	a1,s0,-48
    800059bc:	854a                	mv	a0,s2
    800059be:	fffff097          	auipc	ra,0xfffff
    800059c2:	9bc080e7          	jalr	-1604(ra) # 8000437a <dirlink>
    800059c6:	04054363          	bltz	a0,80005a0c <sys_link+0x100>
  iunlockput(dp);
    800059ca:	854a                	mv	a0,s2
    800059cc:	ffffe097          	auipc	ra,0xffffe
    800059d0:	51c080e7          	jalr	1308(ra) # 80003ee8 <iunlockput>
  iput(ip);
    800059d4:	8526                	mv	a0,s1
    800059d6:	ffffe097          	auipc	ra,0xffffe
    800059da:	46a080e7          	jalr	1130(ra) # 80003e40 <iput>
  end_op();
    800059de:	fffff097          	auipc	ra,0xfffff
    800059e2:	cea080e7          	jalr	-790(ra) # 800046c8 <end_op>
  return 0;
    800059e6:	4781                	li	a5,0
    800059e8:	a085                	j	80005a48 <sys_link+0x13c>
    end_op();
    800059ea:	fffff097          	auipc	ra,0xfffff
    800059ee:	cde080e7          	jalr	-802(ra) # 800046c8 <end_op>
    return -1;
    800059f2:	57fd                	li	a5,-1
    800059f4:	a891                	j	80005a48 <sys_link+0x13c>
    iunlockput(ip);
    800059f6:	8526                	mv	a0,s1
    800059f8:	ffffe097          	auipc	ra,0xffffe
    800059fc:	4f0080e7          	jalr	1264(ra) # 80003ee8 <iunlockput>
    end_op();
    80005a00:	fffff097          	auipc	ra,0xfffff
    80005a04:	cc8080e7          	jalr	-824(ra) # 800046c8 <end_op>
    return -1;
    80005a08:	57fd                	li	a5,-1
    80005a0a:	a83d                	j	80005a48 <sys_link+0x13c>
    iunlockput(dp);
    80005a0c:	854a                	mv	a0,s2
    80005a0e:	ffffe097          	auipc	ra,0xffffe
    80005a12:	4da080e7          	jalr	1242(ra) # 80003ee8 <iunlockput>
  ilock(ip);
    80005a16:	8526                	mv	a0,s1
    80005a18:	ffffe097          	auipc	ra,0xffffe
    80005a1c:	26e080e7          	jalr	622(ra) # 80003c86 <ilock>
  ip->nlink--;
    80005a20:	04a4d783          	lhu	a5,74(s1)
    80005a24:	37fd                	addiw	a5,a5,-1
    80005a26:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a2a:	8526                	mv	a0,s1
    80005a2c:	ffffe097          	auipc	ra,0xffffe
    80005a30:	190080e7          	jalr	400(ra) # 80003bbc <iupdate>
  iunlockput(ip);
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	4b2080e7          	jalr	1202(ra) # 80003ee8 <iunlockput>
  end_op();
    80005a3e:	fffff097          	auipc	ra,0xfffff
    80005a42:	c8a080e7          	jalr	-886(ra) # 800046c8 <end_op>
  return -1;
    80005a46:	57fd                	li	a5,-1
}
    80005a48:	853e                	mv	a0,a5
    80005a4a:	70b2                	ld	ra,296(sp)
    80005a4c:	7412                	ld	s0,288(sp)
    80005a4e:	64f2                	ld	s1,280(sp)
    80005a50:	6952                	ld	s2,272(sp)
    80005a52:	6155                	addi	sp,sp,304
    80005a54:	8082                	ret

0000000080005a56 <sys_unlink>:
{
    80005a56:	7151                	addi	sp,sp,-240
    80005a58:	f586                	sd	ra,232(sp)
    80005a5a:	f1a2                	sd	s0,224(sp)
    80005a5c:	eda6                	sd	s1,216(sp)
    80005a5e:	e9ca                	sd	s2,208(sp)
    80005a60:	e5ce                	sd	s3,200(sp)
    80005a62:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a64:	08000613          	li	a2,128
    80005a68:	f3040593          	addi	a1,s0,-208
    80005a6c:	4501                	li	a0,0
    80005a6e:	ffffd097          	auipc	ra,0xffffd
    80005a72:	5ba080e7          	jalr	1466(ra) # 80003028 <argstr>
    80005a76:	18054163          	bltz	a0,80005bf8 <sys_unlink+0x1a2>
  begin_op();
    80005a7a:	fffff097          	auipc	ra,0xfffff
    80005a7e:	bce080e7          	jalr	-1074(ra) # 80004648 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a82:	fb040593          	addi	a1,s0,-80
    80005a86:	f3040513          	addi	a0,s0,-208
    80005a8a:	fffff097          	auipc	ra,0xfffff
    80005a8e:	9c0080e7          	jalr	-1600(ra) # 8000444a <nameiparent>
    80005a92:	84aa                	mv	s1,a0
    80005a94:	c979                	beqz	a0,80005b6a <sys_unlink+0x114>
  ilock(dp);
    80005a96:	ffffe097          	auipc	ra,0xffffe
    80005a9a:	1f0080e7          	jalr	496(ra) # 80003c86 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005a9e:	00003597          	auipc	a1,0x3
    80005aa2:	c8a58593          	addi	a1,a1,-886 # 80008728 <syscalls+0x2c8>
    80005aa6:	fb040513          	addi	a0,s0,-80
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	6a6080e7          	jalr	1702(ra) # 80004150 <namecmp>
    80005ab2:	14050a63          	beqz	a0,80005c06 <sys_unlink+0x1b0>
    80005ab6:	00003597          	auipc	a1,0x3
    80005aba:	c7a58593          	addi	a1,a1,-902 # 80008730 <syscalls+0x2d0>
    80005abe:	fb040513          	addi	a0,s0,-80
    80005ac2:	ffffe097          	auipc	ra,0xffffe
    80005ac6:	68e080e7          	jalr	1678(ra) # 80004150 <namecmp>
    80005aca:	12050e63          	beqz	a0,80005c06 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ace:	f2c40613          	addi	a2,s0,-212
    80005ad2:	fb040593          	addi	a1,s0,-80
    80005ad6:	8526                	mv	a0,s1
    80005ad8:	ffffe097          	auipc	ra,0xffffe
    80005adc:	692080e7          	jalr	1682(ra) # 8000416a <dirlookup>
    80005ae0:	892a                	mv	s2,a0
    80005ae2:	12050263          	beqz	a0,80005c06 <sys_unlink+0x1b0>
  ilock(ip);
    80005ae6:	ffffe097          	auipc	ra,0xffffe
    80005aea:	1a0080e7          	jalr	416(ra) # 80003c86 <ilock>
  if(ip->nlink < 1)
    80005aee:	04a91783          	lh	a5,74(s2)
    80005af2:	08f05263          	blez	a5,80005b76 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005af6:	04491703          	lh	a4,68(s2)
    80005afa:	4785                	li	a5,1
    80005afc:	08f70563          	beq	a4,a5,80005b86 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b00:	4641                	li	a2,16
    80005b02:	4581                	li	a1,0
    80005b04:	fc040513          	addi	a0,s0,-64
    80005b08:	ffffb097          	auipc	ra,0xffffb
    80005b0c:	1ca080e7          	jalr	458(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b10:	4741                	li	a4,16
    80005b12:	f2c42683          	lw	a3,-212(s0)
    80005b16:	fc040613          	addi	a2,s0,-64
    80005b1a:	4581                	li	a1,0
    80005b1c:	8526                	mv	a0,s1
    80005b1e:	ffffe097          	auipc	ra,0xffffe
    80005b22:	514080e7          	jalr	1300(ra) # 80004032 <writei>
    80005b26:	47c1                	li	a5,16
    80005b28:	0af51563          	bne	a0,a5,80005bd2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005b2c:	04491703          	lh	a4,68(s2)
    80005b30:	4785                	li	a5,1
    80005b32:	0af70863          	beq	a4,a5,80005be2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005b36:	8526                	mv	a0,s1
    80005b38:	ffffe097          	auipc	ra,0xffffe
    80005b3c:	3b0080e7          	jalr	944(ra) # 80003ee8 <iunlockput>
  ip->nlink--;
    80005b40:	04a95783          	lhu	a5,74(s2)
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b4a:	854a                	mv	a0,s2
    80005b4c:	ffffe097          	auipc	ra,0xffffe
    80005b50:	070080e7          	jalr	112(ra) # 80003bbc <iupdate>
  iunlockput(ip);
    80005b54:	854a                	mv	a0,s2
    80005b56:	ffffe097          	auipc	ra,0xffffe
    80005b5a:	392080e7          	jalr	914(ra) # 80003ee8 <iunlockput>
  end_op();
    80005b5e:	fffff097          	auipc	ra,0xfffff
    80005b62:	b6a080e7          	jalr	-1174(ra) # 800046c8 <end_op>
  return 0;
    80005b66:	4501                	li	a0,0
    80005b68:	a84d                	j	80005c1a <sys_unlink+0x1c4>
    end_op();
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	b5e080e7          	jalr	-1186(ra) # 800046c8 <end_op>
    return -1;
    80005b72:	557d                	li	a0,-1
    80005b74:	a05d                	j	80005c1a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005b76:	00003517          	auipc	a0,0x3
    80005b7a:	bc250513          	addi	a0,a0,-1086 # 80008738 <syscalls+0x2d8>
    80005b7e:	ffffb097          	auipc	ra,0xffffb
    80005b82:	9c0080e7          	jalr	-1600(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b86:	04c92703          	lw	a4,76(s2)
    80005b8a:	02000793          	li	a5,32
    80005b8e:	f6e7f9e3          	bgeu	a5,a4,80005b00 <sys_unlink+0xaa>
    80005b92:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b96:	4741                	li	a4,16
    80005b98:	86ce                	mv	a3,s3
    80005b9a:	f1840613          	addi	a2,s0,-232
    80005b9e:	4581                	li	a1,0
    80005ba0:	854a                	mv	a0,s2
    80005ba2:	ffffe097          	auipc	ra,0xffffe
    80005ba6:	398080e7          	jalr	920(ra) # 80003f3a <readi>
    80005baa:	47c1                	li	a5,16
    80005bac:	00f51b63          	bne	a0,a5,80005bc2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005bb0:	f1845783          	lhu	a5,-232(s0)
    80005bb4:	e7a1                	bnez	a5,80005bfc <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bb6:	29c1                	addiw	s3,s3,16
    80005bb8:	04c92783          	lw	a5,76(s2)
    80005bbc:	fcf9ede3          	bltu	s3,a5,80005b96 <sys_unlink+0x140>
    80005bc0:	b781                	j	80005b00 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005bc2:	00003517          	auipc	a0,0x3
    80005bc6:	b8e50513          	addi	a0,a0,-1138 # 80008750 <syscalls+0x2f0>
    80005bca:	ffffb097          	auipc	ra,0xffffb
    80005bce:	974080e7          	jalr	-1676(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005bd2:	00003517          	auipc	a0,0x3
    80005bd6:	b9650513          	addi	a0,a0,-1130 # 80008768 <syscalls+0x308>
    80005bda:	ffffb097          	auipc	ra,0xffffb
    80005bde:	964080e7          	jalr	-1692(ra) # 8000053e <panic>
    dp->nlink--;
    80005be2:	04a4d783          	lhu	a5,74(s1)
    80005be6:	37fd                	addiw	a5,a5,-1
    80005be8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bec:	8526                	mv	a0,s1
    80005bee:	ffffe097          	auipc	ra,0xffffe
    80005bf2:	fce080e7          	jalr	-50(ra) # 80003bbc <iupdate>
    80005bf6:	b781                	j	80005b36 <sys_unlink+0xe0>
    return -1;
    80005bf8:	557d                	li	a0,-1
    80005bfa:	a005                	j	80005c1a <sys_unlink+0x1c4>
    iunlockput(ip);
    80005bfc:	854a                	mv	a0,s2
    80005bfe:	ffffe097          	auipc	ra,0xffffe
    80005c02:	2ea080e7          	jalr	746(ra) # 80003ee8 <iunlockput>
  iunlockput(dp);
    80005c06:	8526                	mv	a0,s1
    80005c08:	ffffe097          	auipc	ra,0xffffe
    80005c0c:	2e0080e7          	jalr	736(ra) # 80003ee8 <iunlockput>
  end_op();
    80005c10:	fffff097          	auipc	ra,0xfffff
    80005c14:	ab8080e7          	jalr	-1352(ra) # 800046c8 <end_op>
  return -1;
    80005c18:	557d                	li	a0,-1
}
    80005c1a:	70ae                	ld	ra,232(sp)
    80005c1c:	740e                	ld	s0,224(sp)
    80005c1e:	64ee                	ld	s1,216(sp)
    80005c20:	694e                	ld	s2,208(sp)
    80005c22:	69ae                	ld	s3,200(sp)
    80005c24:	616d                	addi	sp,sp,240
    80005c26:	8082                	ret

0000000080005c28 <sys_open>:

uint64
sys_open(void)
{
    80005c28:	7131                	addi	sp,sp,-192
    80005c2a:	fd06                	sd	ra,184(sp)
    80005c2c:	f922                	sd	s0,176(sp)
    80005c2e:	f526                	sd	s1,168(sp)
    80005c30:	f14a                	sd	s2,160(sp)
    80005c32:	ed4e                	sd	s3,152(sp)
    80005c34:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005c36:	f4c40593          	addi	a1,s0,-180
    80005c3a:	4505                	li	a0,1
    80005c3c:	ffffd097          	auipc	ra,0xffffd
    80005c40:	3ac080e7          	jalr	940(ra) # 80002fe8 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c44:	08000613          	li	a2,128
    80005c48:	f5040593          	addi	a1,s0,-176
    80005c4c:	4501                	li	a0,0
    80005c4e:	ffffd097          	auipc	ra,0xffffd
    80005c52:	3da080e7          	jalr	986(ra) # 80003028 <argstr>
    80005c56:	87aa                	mv	a5,a0
    return -1;
    80005c58:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c5a:	0a07c963          	bltz	a5,80005d0c <sys_open+0xe4>

  begin_op();
    80005c5e:	fffff097          	auipc	ra,0xfffff
    80005c62:	9ea080e7          	jalr	-1558(ra) # 80004648 <begin_op>

  if(omode & O_CREATE){
    80005c66:	f4c42783          	lw	a5,-180(s0)
    80005c6a:	2007f793          	andi	a5,a5,512
    80005c6e:	cfc5                	beqz	a5,80005d26 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c70:	4681                	li	a3,0
    80005c72:	4601                	li	a2,0
    80005c74:	4589                	li	a1,2
    80005c76:	f5040513          	addi	a0,s0,-176
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	976080e7          	jalr	-1674(ra) # 800055f0 <create>
    80005c82:	84aa                	mv	s1,a0
    if(ip == 0){
    80005c84:	c959                	beqz	a0,80005d1a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005c86:	04449703          	lh	a4,68(s1)
    80005c8a:	478d                	li	a5,3
    80005c8c:	00f71763          	bne	a4,a5,80005c9a <sys_open+0x72>
    80005c90:	0464d703          	lhu	a4,70(s1)
    80005c94:	47a5                	li	a5,9
    80005c96:	0ce7ed63          	bltu	a5,a4,80005d70 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005c9a:	fffff097          	auipc	ra,0xfffff
    80005c9e:	dbe080e7          	jalr	-578(ra) # 80004a58 <filealloc>
    80005ca2:	89aa                	mv	s3,a0
    80005ca4:	10050363          	beqz	a0,80005daa <sys_open+0x182>
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	906080e7          	jalr	-1786(ra) # 800055ae <fdalloc>
    80005cb0:	892a                	mv	s2,a0
    80005cb2:	0e054763          	bltz	a0,80005da0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005cb6:	04449703          	lh	a4,68(s1)
    80005cba:	478d                	li	a5,3
    80005cbc:	0cf70563          	beq	a4,a5,80005d86 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005cc0:	4789                	li	a5,2
    80005cc2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005cc6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005cca:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005cce:	f4c42783          	lw	a5,-180(s0)
    80005cd2:	0017c713          	xori	a4,a5,1
    80005cd6:	8b05                	andi	a4,a4,1
    80005cd8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005cdc:	0037f713          	andi	a4,a5,3
    80005ce0:	00e03733          	snez	a4,a4
    80005ce4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ce8:	4007f793          	andi	a5,a5,1024
    80005cec:	c791                	beqz	a5,80005cf8 <sys_open+0xd0>
    80005cee:	04449703          	lh	a4,68(s1)
    80005cf2:	4789                	li	a5,2
    80005cf4:	0af70063          	beq	a4,a5,80005d94 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005cf8:	8526                	mv	a0,s1
    80005cfa:	ffffe097          	auipc	ra,0xffffe
    80005cfe:	04e080e7          	jalr	78(ra) # 80003d48 <iunlock>
  end_op();
    80005d02:	fffff097          	auipc	ra,0xfffff
    80005d06:	9c6080e7          	jalr	-1594(ra) # 800046c8 <end_op>

  return fd;
    80005d0a:	854a                	mv	a0,s2
}
    80005d0c:	70ea                	ld	ra,184(sp)
    80005d0e:	744a                	ld	s0,176(sp)
    80005d10:	74aa                	ld	s1,168(sp)
    80005d12:	790a                	ld	s2,160(sp)
    80005d14:	69ea                	ld	s3,152(sp)
    80005d16:	6129                	addi	sp,sp,192
    80005d18:	8082                	ret
      end_op();
    80005d1a:	fffff097          	auipc	ra,0xfffff
    80005d1e:	9ae080e7          	jalr	-1618(ra) # 800046c8 <end_op>
      return -1;
    80005d22:	557d                	li	a0,-1
    80005d24:	b7e5                	j	80005d0c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005d26:	f5040513          	addi	a0,s0,-176
    80005d2a:	ffffe097          	auipc	ra,0xffffe
    80005d2e:	702080e7          	jalr	1794(ra) # 8000442c <namei>
    80005d32:	84aa                	mv	s1,a0
    80005d34:	c905                	beqz	a0,80005d64 <sys_open+0x13c>
    ilock(ip);
    80005d36:	ffffe097          	auipc	ra,0xffffe
    80005d3a:	f50080e7          	jalr	-176(ra) # 80003c86 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d3e:	04449703          	lh	a4,68(s1)
    80005d42:	4785                	li	a5,1
    80005d44:	f4f711e3          	bne	a4,a5,80005c86 <sys_open+0x5e>
    80005d48:	f4c42783          	lw	a5,-180(s0)
    80005d4c:	d7b9                	beqz	a5,80005c9a <sys_open+0x72>
      iunlockput(ip);
    80005d4e:	8526                	mv	a0,s1
    80005d50:	ffffe097          	auipc	ra,0xffffe
    80005d54:	198080e7          	jalr	408(ra) # 80003ee8 <iunlockput>
      end_op();
    80005d58:	fffff097          	auipc	ra,0xfffff
    80005d5c:	970080e7          	jalr	-1680(ra) # 800046c8 <end_op>
      return -1;
    80005d60:	557d                	li	a0,-1
    80005d62:	b76d                	j	80005d0c <sys_open+0xe4>
      end_op();
    80005d64:	fffff097          	auipc	ra,0xfffff
    80005d68:	964080e7          	jalr	-1692(ra) # 800046c8 <end_op>
      return -1;
    80005d6c:	557d                	li	a0,-1
    80005d6e:	bf79                	j	80005d0c <sys_open+0xe4>
    iunlockput(ip);
    80005d70:	8526                	mv	a0,s1
    80005d72:	ffffe097          	auipc	ra,0xffffe
    80005d76:	176080e7          	jalr	374(ra) # 80003ee8 <iunlockput>
    end_op();
    80005d7a:	fffff097          	auipc	ra,0xfffff
    80005d7e:	94e080e7          	jalr	-1714(ra) # 800046c8 <end_op>
    return -1;
    80005d82:	557d                	li	a0,-1
    80005d84:	b761                	j	80005d0c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005d86:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005d8a:	04649783          	lh	a5,70(s1)
    80005d8e:	02f99223          	sh	a5,36(s3)
    80005d92:	bf25                	j	80005cca <sys_open+0xa2>
    itrunc(ip);
    80005d94:	8526                	mv	a0,s1
    80005d96:	ffffe097          	auipc	ra,0xffffe
    80005d9a:	ffe080e7          	jalr	-2(ra) # 80003d94 <itrunc>
    80005d9e:	bfa9                	j	80005cf8 <sys_open+0xd0>
      fileclose(f);
    80005da0:	854e                	mv	a0,s3
    80005da2:	fffff097          	auipc	ra,0xfffff
    80005da6:	d72080e7          	jalr	-654(ra) # 80004b14 <fileclose>
    iunlockput(ip);
    80005daa:	8526                	mv	a0,s1
    80005dac:	ffffe097          	auipc	ra,0xffffe
    80005db0:	13c080e7          	jalr	316(ra) # 80003ee8 <iunlockput>
    end_op();
    80005db4:	fffff097          	auipc	ra,0xfffff
    80005db8:	914080e7          	jalr	-1772(ra) # 800046c8 <end_op>
    return -1;
    80005dbc:	557d                	li	a0,-1
    80005dbe:	b7b9                	j	80005d0c <sys_open+0xe4>

0000000080005dc0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dc0:	7175                	addi	sp,sp,-144
    80005dc2:	e506                	sd	ra,136(sp)
    80005dc4:	e122                	sd	s0,128(sp)
    80005dc6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005dc8:	fffff097          	auipc	ra,0xfffff
    80005dcc:	880080e7          	jalr	-1920(ra) # 80004648 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005dd0:	08000613          	li	a2,128
    80005dd4:	f7040593          	addi	a1,s0,-144
    80005dd8:	4501                	li	a0,0
    80005dda:	ffffd097          	auipc	ra,0xffffd
    80005dde:	24e080e7          	jalr	590(ra) # 80003028 <argstr>
    80005de2:	02054963          	bltz	a0,80005e14 <sys_mkdir+0x54>
    80005de6:	4681                	li	a3,0
    80005de8:	4601                	li	a2,0
    80005dea:	4585                	li	a1,1
    80005dec:	f7040513          	addi	a0,s0,-144
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	800080e7          	jalr	-2048(ra) # 800055f0 <create>
    80005df8:	cd11                	beqz	a0,80005e14 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005dfa:	ffffe097          	auipc	ra,0xffffe
    80005dfe:	0ee080e7          	jalr	238(ra) # 80003ee8 <iunlockput>
  end_op();
    80005e02:	fffff097          	auipc	ra,0xfffff
    80005e06:	8c6080e7          	jalr	-1850(ra) # 800046c8 <end_op>
  return 0;
    80005e0a:	4501                	li	a0,0
}
    80005e0c:	60aa                	ld	ra,136(sp)
    80005e0e:	640a                	ld	s0,128(sp)
    80005e10:	6149                	addi	sp,sp,144
    80005e12:	8082                	ret
    end_op();
    80005e14:	fffff097          	auipc	ra,0xfffff
    80005e18:	8b4080e7          	jalr	-1868(ra) # 800046c8 <end_op>
    return -1;
    80005e1c:	557d                	li	a0,-1
    80005e1e:	b7fd                	j	80005e0c <sys_mkdir+0x4c>

0000000080005e20 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e20:	7135                	addi	sp,sp,-160
    80005e22:	ed06                	sd	ra,152(sp)
    80005e24:	e922                	sd	s0,144(sp)
    80005e26:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e28:	fffff097          	auipc	ra,0xfffff
    80005e2c:	820080e7          	jalr	-2016(ra) # 80004648 <begin_op>
  argint(1, &major);
    80005e30:	f6c40593          	addi	a1,s0,-148
    80005e34:	4505                	li	a0,1
    80005e36:	ffffd097          	auipc	ra,0xffffd
    80005e3a:	1b2080e7          	jalr	434(ra) # 80002fe8 <argint>
  argint(2, &minor);
    80005e3e:	f6840593          	addi	a1,s0,-152
    80005e42:	4509                	li	a0,2
    80005e44:	ffffd097          	auipc	ra,0xffffd
    80005e48:	1a4080e7          	jalr	420(ra) # 80002fe8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e4c:	08000613          	li	a2,128
    80005e50:	f7040593          	addi	a1,s0,-144
    80005e54:	4501                	li	a0,0
    80005e56:	ffffd097          	auipc	ra,0xffffd
    80005e5a:	1d2080e7          	jalr	466(ra) # 80003028 <argstr>
    80005e5e:	02054b63          	bltz	a0,80005e94 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e62:	f6841683          	lh	a3,-152(s0)
    80005e66:	f6c41603          	lh	a2,-148(s0)
    80005e6a:	458d                	li	a1,3
    80005e6c:	f7040513          	addi	a0,s0,-144
    80005e70:	fffff097          	auipc	ra,0xfffff
    80005e74:	780080e7          	jalr	1920(ra) # 800055f0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e78:	cd11                	beqz	a0,80005e94 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e7a:	ffffe097          	auipc	ra,0xffffe
    80005e7e:	06e080e7          	jalr	110(ra) # 80003ee8 <iunlockput>
  end_op();
    80005e82:	fffff097          	auipc	ra,0xfffff
    80005e86:	846080e7          	jalr	-1978(ra) # 800046c8 <end_op>
  return 0;
    80005e8a:	4501                	li	a0,0
}
    80005e8c:	60ea                	ld	ra,152(sp)
    80005e8e:	644a                	ld	s0,144(sp)
    80005e90:	610d                	addi	sp,sp,160
    80005e92:	8082                	ret
    end_op();
    80005e94:	fffff097          	auipc	ra,0xfffff
    80005e98:	834080e7          	jalr	-1996(ra) # 800046c8 <end_op>
    return -1;
    80005e9c:	557d                	li	a0,-1
    80005e9e:	b7fd                	j	80005e8c <sys_mknod+0x6c>

0000000080005ea0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ea0:	7135                	addi	sp,sp,-160
    80005ea2:	ed06                	sd	ra,152(sp)
    80005ea4:	e922                	sd	s0,144(sp)
    80005ea6:	e526                	sd	s1,136(sp)
    80005ea8:	e14a                	sd	s2,128(sp)
    80005eaa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005eac:	ffffc097          	auipc	ra,0xffffc
    80005eb0:	b00080e7          	jalr	-1280(ra) # 800019ac <myproc>
    80005eb4:	892a                	mv	s2,a0
  
  begin_op();
    80005eb6:	ffffe097          	auipc	ra,0xffffe
    80005eba:	792080e7          	jalr	1938(ra) # 80004648 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ebe:	08000613          	li	a2,128
    80005ec2:	f6040593          	addi	a1,s0,-160
    80005ec6:	4501                	li	a0,0
    80005ec8:	ffffd097          	auipc	ra,0xffffd
    80005ecc:	160080e7          	jalr	352(ra) # 80003028 <argstr>
    80005ed0:	04054b63          	bltz	a0,80005f26 <sys_chdir+0x86>
    80005ed4:	f6040513          	addi	a0,s0,-160
    80005ed8:	ffffe097          	auipc	ra,0xffffe
    80005edc:	554080e7          	jalr	1364(ra) # 8000442c <namei>
    80005ee0:	84aa                	mv	s1,a0
    80005ee2:	c131                	beqz	a0,80005f26 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ee4:	ffffe097          	auipc	ra,0xffffe
    80005ee8:	da2080e7          	jalr	-606(ra) # 80003c86 <ilock>
  if(ip->type != T_DIR){
    80005eec:	04449703          	lh	a4,68(s1)
    80005ef0:	4785                	li	a5,1
    80005ef2:	04f71063          	bne	a4,a5,80005f32 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ef6:	8526                	mv	a0,s1
    80005ef8:	ffffe097          	auipc	ra,0xffffe
    80005efc:	e50080e7          	jalr	-432(ra) # 80003d48 <iunlock>
  iput(p->cwd);
    80005f00:	17893503          	ld	a0,376(s2)
    80005f04:	ffffe097          	auipc	ra,0xffffe
    80005f08:	f3c080e7          	jalr	-196(ra) # 80003e40 <iput>
  end_op();
    80005f0c:	ffffe097          	auipc	ra,0xffffe
    80005f10:	7bc080e7          	jalr	1980(ra) # 800046c8 <end_op>
  p->cwd = ip;
    80005f14:	16993c23          	sd	s1,376(s2)
  return 0;
    80005f18:	4501                	li	a0,0
}
    80005f1a:	60ea                	ld	ra,152(sp)
    80005f1c:	644a                	ld	s0,144(sp)
    80005f1e:	64aa                	ld	s1,136(sp)
    80005f20:	690a                	ld	s2,128(sp)
    80005f22:	610d                	addi	sp,sp,160
    80005f24:	8082                	ret
    end_op();
    80005f26:	ffffe097          	auipc	ra,0xffffe
    80005f2a:	7a2080e7          	jalr	1954(ra) # 800046c8 <end_op>
    return -1;
    80005f2e:	557d                	li	a0,-1
    80005f30:	b7ed                	j	80005f1a <sys_chdir+0x7a>
    iunlockput(ip);
    80005f32:	8526                	mv	a0,s1
    80005f34:	ffffe097          	auipc	ra,0xffffe
    80005f38:	fb4080e7          	jalr	-76(ra) # 80003ee8 <iunlockput>
    end_op();
    80005f3c:	ffffe097          	auipc	ra,0xffffe
    80005f40:	78c080e7          	jalr	1932(ra) # 800046c8 <end_op>
    return -1;
    80005f44:	557d                	li	a0,-1
    80005f46:	bfd1                	j	80005f1a <sys_chdir+0x7a>

0000000080005f48 <sys_exec>:

uint64
sys_exec(void)
{
    80005f48:	7145                	addi	sp,sp,-464
    80005f4a:	e786                	sd	ra,456(sp)
    80005f4c:	e3a2                	sd	s0,448(sp)
    80005f4e:	ff26                	sd	s1,440(sp)
    80005f50:	fb4a                	sd	s2,432(sp)
    80005f52:	f74e                	sd	s3,424(sp)
    80005f54:	f352                	sd	s4,416(sp)
    80005f56:	ef56                	sd	s5,408(sp)
    80005f58:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f5a:	e3840593          	addi	a1,s0,-456
    80005f5e:	4505                	li	a0,1
    80005f60:	ffffd097          	auipc	ra,0xffffd
    80005f64:	0a8080e7          	jalr	168(ra) # 80003008 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f68:	08000613          	li	a2,128
    80005f6c:	f4040593          	addi	a1,s0,-192
    80005f70:	4501                	li	a0,0
    80005f72:	ffffd097          	auipc	ra,0xffffd
    80005f76:	0b6080e7          	jalr	182(ra) # 80003028 <argstr>
    80005f7a:	87aa                	mv	a5,a0
    return -1;
    80005f7c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005f7e:	0c07c263          	bltz	a5,80006042 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005f82:	10000613          	li	a2,256
    80005f86:	4581                	li	a1,0
    80005f88:	e4040513          	addi	a0,s0,-448
    80005f8c:	ffffb097          	auipc	ra,0xffffb
    80005f90:	d46080e7          	jalr	-698(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005f94:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005f98:	89a6                	mv	s3,s1
    80005f9a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005f9c:	02000a13          	li	s4,32
    80005fa0:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fa4:	00391793          	slli	a5,s2,0x3
    80005fa8:	e3040593          	addi	a1,s0,-464
    80005fac:	e3843503          	ld	a0,-456(s0)
    80005fb0:	953e                	add	a0,a0,a5
    80005fb2:	ffffd097          	auipc	ra,0xffffd
    80005fb6:	f98080e7          	jalr	-104(ra) # 80002f4a <fetchaddr>
    80005fba:	02054a63          	bltz	a0,80005fee <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005fbe:	e3043783          	ld	a5,-464(s0)
    80005fc2:	c3b9                	beqz	a5,80006008 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005fc4:	ffffb097          	auipc	ra,0xffffb
    80005fc8:	b22080e7          	jalr	-1246(ra) # 80000ae6 <kalloc>
    80005fcc:	85aa                	mv	a1,a0
    80005fce:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005fd2:	cd11                	beqz	a0,80005fee <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005fd4:	6605                	lui	a2,0x1
    80005fd6:	e3043503          	ld	a0,-464(s0)
    80005fda:	ffffd097          	auipc	ra,0xffffd
    80005fde:	fc2080e7          	jalr	-62(ra) # 80002f9c <fetchstr>
    80005fe2:	00054663          	bltz	a0,80005fee <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005fe6:	0905                	addi	s2,s2,1
    80005fe8:	09a1                	addi	s3,s3,8
    80005fea:	fb491be3          	bne	s2,s4,80005fa0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005fee:	10048913          	addi	s2,s1,256
    80005ff2:	6088                	ld	a0,0(s1)
    80005ff4:	c531                	beqz	a0,80006040 <sys_exec+0xf8>
    kfree(argv[i]);
    80005ff6:	ffffb097          	auipc	ra,0xffffb
    80005ffa:	9f4080e7          	jalr	-1548(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ffe:	04a1                	addi	s1,s1,8
    80006000:	ff2499e3          	bne	s1,s2,80005ff2 <sys_exec+0xaa>
  return -1;
    80006004:	557d                	li	a0,-1
    80006006:	a835                	j	80006042 <sys_exec+0xfa>
      argv[i] = 0;
    80006008:	0a8e                	slli	s5,s5,0x3
    8000600a:	fc040793          	addi	a5,s0,-64
    8000600e:	9abe                	add	s5,s5,a5
    80006010:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006014:	e4040593          	addi	a1,s0,-448
    80006018:	f4040513          	addi	a0,s0,-192
    8000601c:	fffff097          	auipc	ra,0xfffff
    80006020:	172080e7          	jalr	370(ra) # 8000518e <exec>
    80006024:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006026:	10048993          	addi	s3,s1,256
    8000602a:	6088                	ld	a0,0(s1)
    8000602c:	c901                	beqz	a0,8000603c <sys_exec+0xf4>
    kfree(argv[i]);
    8000602e:	ffffb097          	auipc	ra,0xffffb
    80006032:	9bc080e7          	jalr	-1604(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006036:	04a1                	addi	s1,s1,8
    80006038:	ff3499e3          	bne	s1,s3,8000602a <sys_exec+0xe2>
  return ret;
    8000603c:	854a                	mv	a0,s2
    8000603e:	a011                	j	80006042 <sys_exec+0xfa>
  return -1;
    80006040:	557d                	li	a0,-1
}
    80006042:	60be                	ld	ra,456(sp)
    80006044:	641e                	ld	s0,448(sp)
    80006046:	74fa                	ld	s1,440(sp)
    80006048:	795a                	ld	s2,432(sp)
    8000604a:	79ba                	ld	s3,424(sp)
    8000604c:	7a1a                	ld	s4,416(sp)
    8000604e:	6afa                	ld	s5,408(sp)
    80006050:	6179                	addi	sp,sp,464
    80006052:	8082                	ret

0000000080006054 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006054:	7139                	addi	sp,sp,-64
    80006056:	fc06                	sd	ra,56(sp)
    80006058:	f822                	sd	s0,48(sp)
    8000605a:	f426                	sd	s1,40(sp)
    8000605c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000605e:	ffffc097          	auipc	ra,0xffffc
    80006062:	94e080e7          	jalr	-1714(ra) # 800019ac <myproc>
    80006066:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006068:	fd840593          	addi	a1,s0,-40
    8000606c:	4501                	li	a0,0
    8000606e:	ffffd097          	auipc	ra,0xffffd
    80006072:	f9a080e7          	jalr	-102(ra) # 80003008 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006076:	fc840593          	addi	a1,s0,-56
    8000607a:	fd040513          	addi	a0,s0,-48
    8000607e:	fffff097          	auipc	ra,0xfffff
    80006082:	dc6080e7          	jalr	-570(ra) # 80004e44 <pipealloc>
    return -1;
    80006086:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006088:	0c054463          	bltz	a0,80006150 <sys_pipe+0xfc>
  fd0 = -1;
    8000608c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006090:	fd043503          	ld	a0,-48(s0)
    80006094:	fffff097          	auipc	ra,0xfffff
    80006098:	51a080e7          	jalr	1306(ra) # 800055ae <fdalloc>
    8000609c:	fca42223          	sw	a0,-60(s0)
    800060a0:	08054b63          	bltz	a0,80006136 <sys_pipe+0xe2>
    800060a4:	fc843503          	ld	a0,-56(s0)
    800060a8:	fffff097          	auipc	ra,0xfffff
    800060ac:	506080e7          	jalr	1286(ra) # 800055ae <fdalloc>
    800060b0:	fca42023          	sw	a0,-64(s0)
    800060b4:	06054863          	bltz	a0,80006124 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060b8:	4691                	li	a3,4
    800060ba:	fc440613          	addi	a2,s0,-60
    800060be:	fd843583          	ld	a1,-40(s0)
    800060c2:	7ca8                	ld	a0,120(s1)
    800060c4:	ffffb097          	auipc	ra,0xffffb
    800060c8:	5a4080e7          	jalr	1444(ra) # 80001668 <copyout>
    800060cc:	02054063          	bltz	a0,800060ec <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800060d0:	4691                	li	a3,4
    800060d2:	fc040613          	addi	a2,s0,-64
    800060d6:	fd843583          	ld	a1,-40(s0)
    800060da:	0591                	addi	a1,a1,4
    800060dc:	7ca8                	ld	a0,120(s1)
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	58a080e7          	jalr	1418(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800060e6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060e8:	06055463          	bgez	a0,80006150 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800060ec:	fc442783          	lw	a5,-60(s0)
    800060f0:	07f9                	addi	a5,a5,30
    800060f2:	078e                	slli	a5,a5,0x3
    800060f4:	97a6                	add	a5,a5,s1
    800060f6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800060fa:	fc042503          	lw	a0,-64(s0)
    800060fe:	0579                	addi	a0,a0,30
    80006100:	050e                	slli	a0,a0,0x3
    80006102:	94aa                	add	s1,s1,a0
    80006104:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006108:	fd043503          	ld	a0,-48(s0)
    8000610c:	fffff097          	auipc	ra,0xfffff
    80006110:	a08080e7          	jalr	-1528(ra) # 80004b14 <fileclose>
    fileclose(wf);
    80006114:	fc843503          	ld	a0,-56(s0)
    80006118:	fffff097          	auipc	ra,0xfffff
    8000611c:	9fc080e7          	jalr	-1540(ra) # 80004b14 <fileclose>
    return -1;
    80006120:	57fd                	li	a5,-1
    80006122:	a03d                	j	80006150 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80006124:	fc442783          	lw	a5,-60(s0)
    80006128:	0007c763          	bltz	a5,80006136 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000612c:	07f9                	addi	a5,a5,30
    8000612e:	078e                	slli	a5,a5,0x3
    80006130:	94be                	add	s1,s1,a5
    80006132:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006136:	fd043503          	ld	a0,-48(s0)
    8000613a:	fffff097          	auipc	ra,0xfffff
    8000613e:	9da080e7          	jalr	-1574(ra) # 80004b14 <fileclose>
    fileclose(wf);
    80006142:	fc843503          	ld	a0,-56(s0)
    80006146:	fffff097          	auipc	ra,0xfffff
    8000614a:	9ce080e7          	jalr	-1586(ra) # 80004b14 <fileclose>
    return -1;
    8000614e:	57fd                	li	a5,-1
}
    80006150:	853e                	mv	a0,a5
    80006152:	70e2                	ld	ra,56(sp)
    80006154:	7442                	ld	s0,48(sp)
    80006156:	74a2                	ld	s1,40(sp)
    80006158:	6121                	addi	sp,sp,64
    8000615a:	8082                	ret
    8000615c:	0000                	unimp
	...

0000000080006160 <kernelvec>:
    80006160:	7111                	addi	sp,sp,-256
    80006162:	e006                	sd	ra,0(sp)
    80006164:	e40a                	sd	sp,8(sp)
    80006166:	e80e                	sd	gp,16(sp)
    80006168:	ec12                	sd	tp,24(sp)
    8000616a:	f016                	sd	t0,32(sp)
    8000616c:	f41a                	sd	t1,40(sp)
    8000616e:	f81e                	sd	t2,48(sp)
    80006170:	fc22                	sd	s0,56(sp)
    80006172:	e0a6                	sd	s1,64(sp)
    80006174:	e4aa                	sd	a0,72(sp)
    80006176:	e8ae                	sd	a1,80(sp)
    80006178:	ecb2                	sd	a2,88(sp)
    8000617a:	f0b6                	sd	a3,96(sp)
    8000617c:	f4ba                	sd	a4,104(sp)
    8000617e:	f8be                	sd	a5,112(sp)
    80006180:	fcc2                	sd	a6,120(sp)
    80006182:	e146                	sd	a7,128(sp)
    80006184:	e54a                	sd	s2,136(sp)
    80006186:	e94e                	sd	s3,144(sp)
    80006188:	ed52                	sd	s4,152(sp)
    8000618a:	f156                	sd	s5,160(sp)
    8000618c:	f55a                	sd	s6,168(sp)
    8000618e:	f95e                	sd	s7,176(sp)
    80006190:	fd62                	sd	s8,184(sp)
    80006192:	e1e6                	sd	s9,192(sp)
    80006194:	e5ea                	sd	s10,200(sp)
    80006196:	e9ee                	sd	s11,208(sp)
    80006198:	edf2                	sd	t3,216(sp)
    8000619a:	f1f6                	sd	t4,224(sp)
    8000619c:	f5fa                	sd	t5,232(sp)
    8000619e:	f9fe                	sd	t6,240(sp)
    800061a0:	c77fc0ef          	jal	ra,80002e16 <kerneltrap>
    800061a4:	6082                	ld	ra,0(sp)
    800061a6:	6122                	ld	sp,8(sp)
    800061a8:	61c2                	ld	gp,16(sp)
    800061aa:	7282                	ld	t0,32(sp)
    800061ac:	7322                	ld	t1,40(sp)
    800061ae:	73c2                	ld	t2,48(sp)
    800061b0:	7462                	ld	s0,56(sp)
    800061b2:	6486                	ld	s1,64(sp)
    800061b4:	6526                	ld	a0,72(sp)
    800061b6:	65c6                	ld	a1,80(sp)
    800061b8:	6666                	ld	a2,88(sp)
    800061ba:	7686                	ld	a3,96(sp)
    800061bc:	7726                	ld	a4,104(sp)
    800061be:	77c6                	ld	a5,112(sp)
    800061c0:	7866                	ld	a6,120(sp)
    800061c2:	688a                	ld	a7,128(sp)
    800061c4:	692a                	ld	s2,136(sp)
    800061c6:	69ca                	ld	s3,144(sp)
    800061c8:	6a6a                	ld	s4,152(sp)
    800061ca:	7a8a                	ld	s5,160(sp)
    800061cc:	7b2a                	ld	s6,168(sp)
    800061ce:	7bca                	ld	s7,176(sp)
    800061d0:	7c6a                	ld	s8,184(sp)
    800061d2:	6c8e                	ld	s9,192(sp)
    800061d4:	6d2e                	ld	s10,200(sp)
    800061d6:	6dce                	ld	s11,208(sp)
    800061d8:	6e6e                	ld	t3,216(sp)
    800061da:	7e8e                	ld	t4,224(sp)
    800061dc:	7f2e                	ld	t5,232(sp)
    800061de:	7fce                	ld	t6,240(sp)
    800061e0:	6111                	addi	sp,sp,256
    800061e2:	10200073          	sret
    800061e6:	00000013          	nop
    800061ea:	00000013          	nop
    800061ee:	0001                	nop

00000000800061f0 <timervec>:
    800061f0:	34051573          	csrrw	a0,mscratch,a0
    800061f4:	e10c                	sd	a1,0(a0)
    800061f6:	e510                	sd	a2,8(a0)
    800061f8:	e914                	sd	a3,16(a0)
    800061fa:	6d0c                	ld	a1,24(a0)
    800061fc:	7110                	ld	a2,32(a0)
    800061fe:	6194                	ld	a3,0(a1)
    80006200:	96b2                	add	a3,a3,a2
    80006202:	e194                	sd	a3,0(a1)
    80006204:	4589                	li	a1,2
    80006206:	14459073          	csrw	sip,a1
    8000620a:	6914                	ld	a3,16(a0)
    8000620c:	6510                	ld	a2,8(a0)
    8000620e:	610c                	ld	a1,0(a0)
    80006210:	34051573          	csrrw	a0,mscratch,a0
    80006214:	30200073          	mret
	...

000000008000621a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000621a:	1141                	addi	sp,sp,-16
    8000621c:	e422                	sd	s0,8(sp)
    8000621e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006220:	0c0007b7          	lui	a5,0xc000
    80006224:	4705                	li	a4,1
    80006226:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006228:	c3d8                	sw	a4,4(a5)
}
    8000622a:	6422                	ld	s0,8(sp)
    8000622c:	0141                	addi	sp,sp,16
    8000622e:	8082                	ret

0000000080006230 <plicinithart>:

void
plicinithart(void)
{
    80006230:	1141                	addi	sp,sp,-16
    80006232:	e406                	sd	ra,8(sp)
    80006234:	e022                	sd	s0,0(sp)
    80006236:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006238:	ffffb097          	auipc	ra,0xffffb
    8000623c:	748080e7          	jalr	1864(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006240:	0085171b          	slliw	a4,a0,0x8
    80006244:	0c0027b7          	lui	a5,0xc002
    80006248:	97ba                	add	a5,a5,a4
    8000624a:	40200713          	li	a4,1026
    8000624e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006252:	00d5151b          	slliw	a0,a0,0xd
    80006256:	0c2017b7          	lui	a5,0xc201
    8000625a:	953e                	add	a0,a0,a5
    8000625c:	00052023          	sw	zero,0(a0)
}
    80006260:	60a2                	ld	ra,8(sp)
    80006262:	6402                	ld	s0,0(sp)
    80006264:	0141                	addi	sp,sp,16
    80006266:	8082                	ret

0000000080006268 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006268:	1141                	addi	sp,sp,-16
    8000626a:	e406                	sd	ra,8(sp)
    8000626c:	e022                	sd	s0,0(sp)
    8000626e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006270:	ffffb097          	auipc	ra,0xffffb
    80006274:	710080e7          	jalr	1808(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006278:	00d5179b          	slliw	a5,a0,0xd
    8000627c:	0c201537          	lui	a0,0xc201
    80006280:	953e                	add	a0,a0,a5
  return irq;
}
    80006282:	4148                	lw	a0,4(a0)
    80006284:	60a2                	ld	ra,8(sp)
    80006286:	6402                	ld	s0,0(sp)
    80006288:	0141                	addi	sp,sp,16
    8000628a:	8082                	ret

000000008000628c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000628c:	1101                	addi	sp,sp,-32
    8000628e:	ec06                	sd	ra,24(sp)
    80006290:	e822                	sd	s0,16(sp)
    80006292:	e426                	sd	s1,8(sp)
    80006294:	1000                	addi	s0,sp,32
    80006296:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	6e8080e7          	jalr	1768(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062a0:	00d5151b          	slliw	a0,a0,0xd
    800062a4:	0c2017b7          	lui	a5,0xc201
    800062a8:	97aa                	add	a5,a5,a0
    800062aa:	c3c4                	sw	s1,4(a5)
}
    800062ac:	60e2                	ld	ra,24(sp)
    800062ae:	6442                	ld	s0,16(sp)
    800062b0:	64a2                	ld	s1,8(sp)
    800062b2:	6105                	addi	sp,sp,32
    800062b4:	8082                	ret

00000000800062b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800062b6:	1141                	addi	sp,sp,-16
    800062b8:	e406                	sd	ra,8(sp)
    800062ba:	e022                	sd	s0,0(sp)
    800062bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800062be:	479d                	li	a5,7
    800062c0:	04a7cc63          	blt	a5,a0,80006318 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800062c4:	0001d797          	auipc	a5,0x1d
    800062c8:	f9c78793          	addi	a5,a5,-100 # 80023260 <disk>
    800062cc:	97aa                	add	a5,a5,a0
    800062ce:	0187c783          	lbu	a5,24(a5)
    800062d2:	ebb9                	bnez	a5,80006328 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062d4:	00451613          	slli	a2,a0,0x4
    800062d8:	0001d797          	auipc	a5,0x1d
    800062dc:	f8878793          	addi	a5,a5,-120 # 80023260 <disk>
    800062e0:	6394                	ld	a3,0(a5)
    800062e2:	96b2                	add	a3,a3,a2
    800062e4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800062e8:	6398                	ld	a4,0(a5)
    800062ea:	9732                	add	a4,a4,a2
    800062ec:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800062f0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800062f4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800062f8:	953e                	add	a0,a0,a5
    800062fa:	4785                	li	a5,1
    800062fc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006300:	0001d517          	auipc	a0,0x1d
    80006304:	f7850513          	addi	a0,a0,-136 # 80023278 <disk+0x18>
    80006308:	ffffc097          	auipc	ra,0xffffc
    8000630c:	f78080e7          	jalr	-136(ra) # 80002280 <wakeup>
}
    80006310:	60a2                	ld	ra,8(sp)
    80006312:	6402                	ld	s0,0(sp)
    80006314:	0141                	addi	sp,sp,16
    80006316:	8082                	ret
    panic("free_desc 1");
    80006318:	00002517          	auipc	a0,0x2
    8000631c:	46050513          	addi	a0,a0,1120 # 80008778 <syscalls+0x318>
    80006320:	ffffa097          	auipc	ra,0xffffa
    80006324:	21e080e7          	jalr	542(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006328:	00002517          	auipc	a0,0x2
    8000632c:	46050513          	addi	a0,a0,1120 # 80008788 <syscalls+0x328>
    80006330:	ffffa097          	auipc	ra,0xffffa
    80006334:	20e080e7          	jalr	526(ra) # 8000053e <panic>

0000000080006338 <virtio_disk_init>:
{
    80006338:	1101                	addi	sp,sp,-32
    8000633a:	ec06                	sd	ra,24(sp)
    8000633c:	e822                	sd	s0,16(sp)
    8000633e:	e426                	sd	s1,8(sp)
    80006340:	e04a                	sd	s2,0(sp)
    80006342:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006344:	00002597          	auipc	a1,0x2
    80006348:	45458593          	addi	a1,a1,1108 # 80008798 <syscalls+0x338>
    8000634c:	0001d517          	auipc	a0,0x1d
    80006350:	03c50513          	addi	a0,a0,60 # 80023388 <disk+0x128>
    80006354:	ffffa097          	auipc	ra,0xffffa
    80006358:	7f2080e7          	jalr	2034(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000635c:	100017b7          	lui	a5,0x10001
    80006360:	4398                	lw	a4,0(a5)
    80006362:	2701                	sext.w	a4,a4
    80006364:	747277b7          	lui	a5,0x74727
    80006368:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000636c:	14f71c63          	bne	a4,a5,800064c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006370:	100017b7          	lui	a5,0x10001
    80006374:	43dc                	lw	a5,4(a5)
    80006376:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006378:	4709                	li	a4,2
    8000637a:	14e79563          	bne	a5,a4,800064c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000637e:	100017b7          	lui	a5,0x10001
    80006382:	479c                	lw	a5,8(a5)
    80006384:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006386:	12e79f63          	bne	a5,a4,800064c4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000638a:	100017b7          	lui	a5,0x10001
    8000638e:	47d8                	lw	a4,12(a5)
    80006390:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006392:	554d47b7          	lui	a5,0x554d4
    80006396:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000639a:	12f71563          	bne	a4,a5,800064c4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000639e:	100017b7          	lui	a5,0x10001
    800063a2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a6:	4705                	li	a4,1
    800063a8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063aa:	470d                	li	a4,3
    800063ac:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063ae:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063b0:	c7ffe737          	lui	a4,0xc7ffe
    800063b4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb3bf>
    800063b8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063ba:	2701                	sext.w	a4,a4
    800063bc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063be:	472d                	li	a4,11
    800063c0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800063c2:	5bbc                	lw	a5,112(a5)
    800063c4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800063c8:	8ba1                	andi	a5,a5,8
    800063ca:	10078563          	beqz	a5,800064d4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063ce:	100017b7          	lui	a5,0x10001
    800063d2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800063d6:	43fc                	lw	a5,68(a5)
    800063d8:	2781                	sext.w	a5,a5
    800063da:	10079563          	bnez	a5,800064e4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063de:	100017b7          	lui	a5,0x10001
    800063e2:	5bdc                	lw	a5,52(a5)
    800063e4:	2781                	sext.w	a5,a5
  if(max == 0)
    800063e6:	10078763          	beqz	a5,800064f4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    800063ea:	471d                	li	a4,7
    800063ec:	10f77c63          	bgeu	a4,a5,80006504 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    800063f0:	ffffa097          	auipc	ra,0xffffa
    800063f4:	6f6080e7          	jalr	1782(ra) # 80000ae6 <kalloc>
    800063f8:	0001d497          	auipc	s1,0x1d
    800063fc:	e6848493          	addi	s1,s1,-408 # 80023260 <disk>
    80006400:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006402:	ffffa097          	auipc	ra,0xffffa
    80006406:	6e4080e7          	jalr	1764(ra) # 80000ae6 <kalloc>
    8000640a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000640c:	ffffa097          	auipc	ra,0xffffa
    80006410:	6da080e7          	jalr	1754(ra) # 80000ae6 <kalloc>
    80006414:	87aa                	mv	a5,a0
    80006416:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006418:	6088                	ld	a0,0(s1)
    8000641a:	cd6d                	beqz	a0,80006514 <virtio_disk_init+0x1dc>
    8000641c:	0001d717          	auipc	a4,0x1d
    80006420:	e4c73703          	ld	a4,-436(a4) # 80023268 <disk+0x8>
    80006424:	cb65                	beqz	a4,80006514 <virtio_disk_init+0x1dc>
    80006426:	c7fd                	beqz	a5,80006514 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006428:	6605                	lui	a2,0x1
    8000642a:	4581                	li	a1,0
    8000642c:	ffffb097          	auipc	ra,0xffffb
    80006430:	8a6080e7          	jalr	-1882(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006434:	0001d497          	auipc	s1,0x1d
    80006438:	e2c48493          	addi	s1,s1,-468 # 80023260 <disk>
    8000643c:	6605                	lui	a2,0x1
    8000643e:	4581                	li	a1,0
    80006440:	6488                	ld	a0,8(s1)
    80006442:	ffffb097          	auipc	ra,0xffffb
    80006446:	890080e7          	jalr	-1904(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000644a:	6605                	lui	a2,0x1
    8000644c:	4581                	li	a1,0
    8000644e:	6888                	ld	a0,16(s1)
    80006450:	ffffb097          	auipc	ra,0xffffb
    80006454:	882080e7          	jalr	-1918(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006458:	100017b7          	lui	a5,0x10001
    8000645c:	4721                	li	a4,8
    8000645e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006460:	4098                	lw	a4,0(s1)
    80006462:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006466:	40d8                	lw	a4,4(s1)
    80006468:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000646c:	6498                	ld	a4,8(s1)
    8000646e:	0007069b          	sext.w	a3,a4
    80006472:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006476:	9701                	srai	a4,a4,0x20
    80006478:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000647c:	6898                	ld	a4,16(s1)
    8000647e:	0007069b          	sext.w	a3,a4
    80006482:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006486:	9701                	srai	a4,a4,0x20
    80006488:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000648c:	4705                	li	a4,1
    8000648e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006490:	00e48c23          	sb	a4,24(s1)
    80006494:	00e48ca3          	sb	a4,25(s1)
    80006498:	00e48d23          	sb	a4,26(s1)
    8000649c:	00e48da3          	sb	a4,27(s1)
    800064a0:	00e48e23          	sb	a4,28(s1)
    800064a4:	00e48ea3          	sb	a4,29(s1)
    800064a8:	00e48f23          	sb	a4,30(s1)
    800064ac:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800064b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800064b4:	0727a823          	sw	s2,112(a5)
}
    800064b8:	60e2                	ld	ra,24(sp)
    800064ba:	6442                	ld	s0,16(sp)
    800064bc:	64a2                	ld	s1,8(sp)
    800064be:	6902                	ld	s2,0(sp)
    800064c0:	6105                	addi	sp,sp,32
    800064c2:	8082                	ret
    panic("could not find virtio disk");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	2e450513          	addi	a0,a0,740 # 800087a8 <syscalls+0x348>
    800064cc:	ffffa097          	auipc	ra,0xffffa
    800064d0:	072080e7          	jalr	114(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    800064d4:	00002517          	auipc	a0,0x2
    800064d8:	2f450513          	addi	a0,a0,756 # 800087c8 <syscalls+0x368>
    800064dc:	ffffa097          	auipc	ra,0xffffa
    800064e0:	062080e7          	jalr	98(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    800064e4:	00002517          	auipc	a0,0x2
    800064e8:	30450513          	addi	a0,a0,772 # 800087e8 <syscalls+0x388>
    800064ec:	ffffa097          	auipc	ra,0xffffa
    800064f0:	052080e7          	jalr	82(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    800064f4:	00002517          	auipc	a0,0x2
    800064f8:	31450513          	addi	a0,a0,788 # 80008808 <syscalls+0x3a8>
    800064fc:	ffffa097          	auipc	ra,0xffffa
    80006500:	042080e7          	jalr	66(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006504:	00002517          	auipc	a0,0x2
    80006508:	32450513          	addi	a0,a0,804 # 80008828 <syscalls+0x3c8>
    8000650c:	ffffa097          	auipc	ra,0xffffa
    80006510:	032080e7          	jalr	50(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006514:	00002517          	auipc	a0,0x2
    80006518:	33450513          	addi	a0,a0,820 # 80008848 <syscalls+0x3e8>
    8000651c:	ffffa097          	auipc	ra,0xffffa
    80006520:	022080e7          	jalr	34(ra) # 8000053e <panic>

0000000080006524 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006524:	7119                	addi	sp,sp,-128
    80006526:	fc86                	sd	ra,120(sp)
    80006528:	f8a2                	sd	s0,112(sp)
    8000652a:	f4a6                	sd	s1,104(sp)
    8000652c:	f0ca                	sd	s2,96(sp)
    8000652e:	ecce                	sd	s3,88(sp)
    80006530:	e8d2                	sd	s4,80(sp)
    80006532:	e4d6                	sd	s5,72(sp)
    80006534:	e0da                	sd	s6,64(sp)
    80006536:	fc5e                	sd	s7,56(sp)
    80006538:	f862                	sd	s8,48(sp)
    8000653a:	f466                	sd	s9,40(sp)
    8000653c:	f06a                	sd	s10,32(sp)
    8000653e:	ec6e                	sd	s11,24(sp)
    80006540:	0100                	addi	s0,sp,128
    80006542:	8aaa                	mv	s5,a0
    80006544:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006546:	00c52d03          	lw	s10,12(a0)
    8000654a:	001d1d1b          	slliw	s10,s10,0x1
    8000654e:	1d02                	slli	s10,s10,0x20
    80006550:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006554:	0001d517          	auipc	a0,0x1d
    80006558:	e3450513          	addi	a0,a0,-460 # 80023388 <disk+0x128>
    8000655c:	ffffa097          	auipc	ra,0xffffa
    80006560:	67a080e7          	jalr	1658(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006564:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006566:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006568:	0001db97          	auipc	s7,0x1d
    8000656c:	cf8b8b93          	addi	s7,s7,-776 # 80023260 <disk>
  for(int i = 0; i < 3; i++){
    80006570:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006572:	0001dc97          	auipc	s9,0x1d
    80006576:	e16c8c93          	addi	s9,s9,-490 # 80023388 <disk+0x128>
    8000657a:	a08d                	j	800065dc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000657c:	00fb8733          	add	a4,s7,a5
    80006580:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006584:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006586:	0207c563          	bltz	a5,800065b0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000658a:	2905                	addiw	s2,s2,1
    8000658c:	0611                	addi	a2,a2,4
    8000658e:	05690c63          	beq	s2,s6,800065e6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006592:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006594:	0001d717          	auipc	a4,0x1d
    80006598:	ccc70713          	addi	a4,a4,-820 # 80023260 <disk>
    8000659c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000659e:	01874683          	lbu	a3,24(a4)
    800065a2:	fee9                	bnez	a3,8000657c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800065a4:	2785                	addiw	a5,a5,1
    800065a6:	0705                	addi	a4,a4,1
    800065a8:	fe979be3          	bne	a5,s1,8000659e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800065ac:	57fd                	li	a5,-1
    800065ae:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800065b0:	01205d63          	blez	s2,800065ca <virtio_disk_rw+0xa6>
    800065b4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800065b6:	000a2503          	lw	a0,0(s4)
    800065ba:	00000097          	auipc	ra,0x0
    800065be:	cfc080e7          	jalr	-772(ra) # 800062b6 <free_desc>
      for(int j = 0; j < i; j++)
    800065c2:	2d85                	addiw	s11,s11,1
    800065c4:	0a11                	addi	s4,s4,4
    800065c6:	ffb918e3          	bne	s2,s11,800065b6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800065ca:	85e6                	mv	a1,s9
    800065cc:	0001d517          	auipc	a0,0x1d
    800065d0:	cac50513          	addi	a0,a0,-852 # 80023278 <disk+0x18>
    800065d4:	ffffc097          	auipc	ra,0xffffc
    800065d8:	c48080e7          	jalr	-952(ra) # 8000221c <sleep>
  for(int i = 0; i < 3; i++){
    800065dc:	f8040a13          	addi	s4,s0,-128
{
    800065e0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800065e2:	894e                	mv	s2,s3
    800065e4:	b77d                	j	80006592 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065e6:	f8042583          	lw	a1,-128(s0)
    800065ea:	00a58793          	addi	a5,a1,10
    800065ee:	0792                	slli	a5,a5,0x4

  if(write)
    800065f0:	0001d617          	auipc	a2,0x1d
    800065f4:	c7060613          	addi	a2,a2,-912 # 80023260 <disk>
    800065f8:	00f60733          	add	a4,a2,a5
    800065fc:	018036b3          	snez	a3,s8
    80006600:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006602:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006606:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000660a:	f6078693          	addi	a3,a5,-160
    8000660e:	6218                	ld	a4,0(a2)
    80006610:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006612:	00878513          	addi	a0,a5,8
    80006616:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006618:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000661a:	6208                	ld	a0,0(a2)
    8000661c:	96aa                	add	a3,a3,a0
    8000661e:	4741                	li	a4,16
    80006620:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006622:	4705                	li	a4,1
    80006624:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006628:	f8442703          	lw	a4,-124(s0)
    8000662c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006630:	0712                	slli	a4,a4,0x4
    80006632:	953a                	add	a0,a0,a4
    80006634:	058a8693          	addi	a3,s5,88
    80006638:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000663a:	6208                	ld	a0,0(a2)
    8000663c:	972a                	add	a4,a4,a0
    8000663e:	40000693          	li	a3,1024
    80006642:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006644:	001c3c13          	seqz	s8,s8
    80006648:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000664a:	001c6c13          	ori	s8,s8,1
    8000664e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006652:	f8842603          	lw	a2,-120(s0)
    80006656:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000665a:	0001d697          	auipc	a3,0x1d
    8000665e:	c0668693          	addi	a3,a3,-1018 # 80023260 <disk>
    80006662:	00258713          	addi	a4,a1,2
    80006666:	0712                	slli	a4,a4,0x4
    80006668:	9736                	add	a4,a4,a3
    8000666a:	587d                	li	a6,-1
    8000666c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006670:	0612                	slli	a2,a2,0x4
    80006672:	9532                	add	a0,a0,a2
    80006674:	f9078793          	addi	a5,a5,-112
    80006678:	97b6                	add	a5,a5,a3
    8000667a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000667c:	629c                	ld	a5,0(a3)
    8000667e:	97b2                	add	a5,a5,a2
    80006680:	4605                	li	a2,1
    80006682:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006684:	4509                	li	a0,2
    80006686:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000668a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000668e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006692:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006696:	6698                	ld	a4,8(a3)
    80006698:	00275783          	lhu	a5,2(a4)
    8000669c:	8b9d                	andi	a5,a5,7
    8000669e:	0786                	slli	a5,a5,0x1
    800066a0:	97ba                	add	a5,a5,a4
    800066a2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800066a6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800066aa:	6698                	ld	a4,8(a3)
    800066ac:	00275783          	lhu	a5,2(a4)
    800066b0:	2785                	addiw	a5,a5,1
    800066b2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800066b6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800066ba:	100017b7          	lui	a5,0x10001
    800066be:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800066c2:	004aa783          	lw	a5,4(s5)
    800066c6:	02c79163          	bne	a5,a2,800066e8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800066ca:	0001d917          	auipc	s2,0x1d
    800066ce:	cbe90913          	addi	s2,s2,-834 # 80023388 <disk+0x128>
  while(b->disk == 1) {
    800066d2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800066d4:	85ca                	mv	a1,s2
    800066d6:	8556                	mv	a0,s5
    800066d8:	ffffc097          	auipc	ra,0xffffc
    800066dc:	b44080e7          	jalr	-1212(ra) # 8000221c <sleep>
  while(b->disk == 1) {
    800066e0:	004aa783          	lw	a5,4(s5)
    800066e4:	fe9788e3          	beq	a5,s1,800066d4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800066e8:	f8042903          	lw	s2,-128(s0)
    800066ec:	00290793          	addi	a5,s2,2
    800066f0:	00479713          	slli	a4,a5,0x4
    800066f4:	0001d797          	auipc	a5,0x1d
    800066f8:	b6c78793          	addi	a5,a5,-1172 # 80023260 <disk>
    800066fc:	97ba                	add	a5,a5,a4
    800066fe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006702:	0001d997          	auipc	s3,0x1d
    80006706:	b5e98993          	addi	s3,s3,-1186 # 80023260 <disk>
    8000670a:	00491713          	slli	a4,s2,0x4
    8000670e:	0009b783          	ld	a5,0(s3)
    80006712:	97ba                	add	a5,a5,a4
    80006714:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006718:	854a                	mv	a0,s2
    8000671a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000671e:	00000097          	auipc	ra,0x0
    80006722:	b98080e7          	jalr	-1128(ra) # 800062b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006726:	8885                	andi	s1,s1,1
    80006728:	f0ed                	bnez	s1,8000670a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000672a:	0001d517          	auipc	a0,0x1d
    8000672e:	c5e50513          	addi	a0,a0,-930 # 80023388 <disk+0x128>
    80006732:	ffffa097          	auipc	ra,0xffffa
    80006736:	558080e7          	jalr	1368(ra) # 80000c8a <release>
}
    8000673a:	70e6                	ld	ra,120(sp)
    8000673c:	7446                	ld	s0,112(sp)
    8000673e:	74a6                	ld	s1,104(sp)
    80006740:	7906                	ld	s2,96(sp)
    80006742:	69e6                	ld	s3,88(sp)
    80006744:	6a46                	ld	s4,80(sp)
    80006746:	6aa6                	ld	s5,72(sp)
    80006748:	6b06                	ld	s6,64(sp)
    8000674a:	7be2                	ld	s7,56(sp)
    8000674c:	7c42                	ld	s8,48(sp)
    8000674e:	7ca2                	ld	s9,40(sp)
    80006750:	7d02                	ld	s10,32(sp)
    80006752:	6de2                	ld	s11,24(sp)
    80006754:	6109                	addi	sp,sp,128
    80006756:	8082                	ret

0000000080006758 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006758:	1101                	addi	sp,sp,-32
    8000675a:	ec06                	sd	ra,24(sp)
    8000675c:	e822                	sd	s0,16(sp)
    8000675e:	e426                	sd	s1,8(sp)
    80006760:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006762:	0001d497          	auipc	s1,0x1d
    80006766:	afe48493          	addi	s1,s1,-1282 # 80023260 <disk>
    8000676a:	0001d517          	auipc	a0,0x1d
    8000676e:	c1e50513          	addi	a0,a0,-994 # 80023388 <disk+0x128>
    80006772:	ffffa097          	auipc	ra,0xffffa
    80006776:	464080e7          	jalr	1124(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000677a:	10001737          	lui	a4,0x10001
    8000677e:	533c                	lw	a5,96(a4)
    80006780:	8b8d                	andi	a5,a5,3
    80006782:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006784:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006788:	689c                	ld	a5,16(s1)
    8000678a:	0204d703          	lhu	a4,32(s1)
    8000678e:	0027d783          	lhu	a5,2(a5)
    80006792:	04f70863          	beq	a4,a5,800067e2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006796:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000679a:	6898                	ld	a4,16(s1)
    8000679c:	0204d783          	lhu	a5,32(s1)
    800067a0:	8b9d                	andi	a5,a5,7
    800067a2:	078e                	slli	a5,a5,0x3
    800067a4:	97ba                	add	a5,a5,a4
    800067a6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800067a8:	00278713          	addi	a4,a5,2
    800067ac:	0712                	slli	a4,a4,0x4
    800067ae:	9726                	add	a4,a4,s1
    800067b0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800067b4:	e721                	bnez	a4,800067fc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800067b6:	0789                	addi	a5,a5,2
    800067b8:	0792                	slli	a5,a5,0x4
    800067ba:	97a6                	add	a5,a5,s1
    800067bc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800067be:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800067c2:	ffffc097          	auipc	ra,0xffffc
    800067c6:	abe080e7          	jalr	-1346(ra) # 80002280 <wakeup>

    disk.used_idx += 1;
    800067ca:	0204d783          	lhu	a5,32(s1)
    800067ce:	2785                	addiw	a5,a5,1
    800067d0:	17c2                	slli	a5,a5,0x30
    800067d2:	93c1                	srli	a5,a5,0x30
    800067d4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800067d8:	6898                	ld	a4,16(s1)
    800067da:	00275703          	lhu	a4,2(a4)
    800067de:	faf71ce3          	bne	a4,a5,80006796 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800067e2:	0001d517          	auipc	a0,0x1d
    800067e6:	ba650513          	addi	a0,a0,-1114 # 80023388 <disk+0x128>
    800067ea:	ffffa097          	auipc	ra,0xffffa
    800067ee:	4a0080e7          	jalr	1184(ra) # 80000c8a <release>
}
    800067f2:	60e2                	ld	ra,24(sp)
    800067f4:	6442                	ld	s0,16(sp)
    800067f6:	64a2                	ld	s1,8(sp)
    800067f8:	6105                	addi	sp,sp,32
    800067fa:	8082                	ret
      panic("virtio_disk_intr status");
    800067fc:	00002517          	auipc	a0,0x2
    80006800:	06450513          	addi	a0,a0,100 # 80008860 <syscalls+0x400>
    80006804:	ffffa097          	auipc	ra,0xffffa
    80006808:	d3a080e7          	jalr	-710(ra) # 8000053e <panic>
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
