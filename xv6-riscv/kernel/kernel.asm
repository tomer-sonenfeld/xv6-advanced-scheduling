
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8f013103          	ld	sp,-1808(sp) # 800088f0 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    80000056:	8fe70713          	addi	a4,a4,-1794 # 80008950 <timer_scratch>
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
    80000068:	01c78793          	addi	a5,a5,28 # 80006080 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb43f>
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
    80000130:	53e080e7          	jalr	1342(ra) # 8000266a <either_copyin>
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
    8000018e:	90650513          	addi	a0,a0,-1786 # 80010a90 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8f648493          	addi	s1,s1,-1802 # 80010a90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	98690913          	addi	s2,s2,-1658 # 80010b28 <cons+0x98>
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
    800001cc:	2aa080e7          	jalr	682(ra) # 80002472 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	f74080e7          	jalr	-140(ra) # 8000214a <sleep>
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
    80000216:	402080e7          	jalr	1026(ra) # 80002614 <either_copyout>
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
    8000022a:	86a50513          	addi	a0,a0,-1942 # 80010a90 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	85450513          	addi	a0,a0,-1964 # 80010a90 <cons>
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
    80000276:	8af72b23          	sw	a5,-1866(a4) # 80010b28 <cons+0x98>
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
    800002d0:	7c450513          	addi	a0,a0,1988 # 80010a90 <cons>
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
    800002f6:	3ce080e7          	jalr	974(ra) # 800026c0 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	79650513          	addi	a0,a0,1942 # 80010a90 <cons>
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
    80000322:	77270713          	addi	a4,a4,1906 # 80010a90 <cons>
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
    8000034c:	74878793          	addi	a5,a5,1864 # 80010a90 <cons>
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
    8000037a:	7b27a783          	lw	a5,1970(a5) # 80010b28 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	70670713          	addi	a4,a4,1798 # 80010a90 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6f648493          	addi	s1,s1,1782 # 80010a90 <cons>
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
    800003da:	6ba70713          	addi	a4,a4,1722 # 80010a90 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	74f72223          	sw	a5,1860(a4) # 80010b30 <cons+0xa0>
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
    80000416:	67e78793          	addi	a5,a5,1662 # 80010a90 <cons>
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
    8000043a:	6ec7ab23          	sw	a2,1782(a5) # 80010b2c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	6ea50513          	addi	a0,a0,1770 # 80010b28 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	d68080e7          	jalr	-664(ra) # 800021ae <wakeup>
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
    80000464:	63050513          	addi	a0,a0,1584 # 80010a90 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00022797          	auipc	a5,0x22
    8000047c:	db078793          	addi	a5,a5,-592 # 80022228 <devsw>
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
    8000054e:	6007a323          	sw	zero,1542(a5) # 80010b50 <pr+0x18>
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
    80000582:	38f72923          	sw	a5,914(a4) # 80008910 <panicked>
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
    800005be:	596dad83          	lw	s11,1430(s11) # 80010b50 <pr+0x18>
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
    800005fc:	54050513          	addi	a0,a0,1344 # 80010b38 <pr>
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
    8000075a:	3e250513          	addi	a0,a0,994 # 80010b38 <pr>
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
    80000776:	3c648493          	addi	s1,s1,966 # 80010b38 <pr>
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
    800007d6:	38650513          	addi	a0,a0,902 # 80010b58 <uart_tx_lock>
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
    80000802:	1127a783          	lw	a5,274(a5) # 80008910 <panicked>
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
    8000083a:	0e27b783          	ld	a5,226(a5) # 80008918 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	0e273703          	ld	a4,226(a4) # 80008920 <uart_tx_w>
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
    80000864:	2f8a0a13          	addi	s4,s4,760 # 80010b58 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	0b048493          	addi	s1,s1,176 # 80008918 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	0b098993          	addi	s3,s3,176 # 80008920 <uart_tx_w>
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
    80000896:	91c080e7          	jalr	-1764(ra) # 800021ae <wakeup>
    
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
    800008d2:	28a50513          	addi	a0,a0,650 # 80010b58 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0327a783          	lw	a5,50(a5) # 80008910 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	03873703          	ld	a4,56(a4) # 80008920 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0287b783          	ld	a5,40(a5) # 80008918 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	25c98993          	addi	s3,s3,604 # 80010b58 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	01448493          	addi	s1,s1,20 # 80008918 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	01490913          	addi	s2,s2,20 # 80008920 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	82e080e7          	jalr	-2002(ra) # 8000214a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	22648493          	addi	s1,s1,550 # 80010b58 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	fce7bd23          	sd	a4,-38(a5) # 80008920 <uart_tx_w>
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
    800009c0:	19c48493          	addi	s1,s1,412 # 80010b58 <uart_tx_lock>
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
    80000a02:	9c278793          	addi	a5,a5,-1598 # 800233c0 <end>
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
    80000a22:	17290913          	addi	s2,s2,370 # 80010b90 <kmem>
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
    80000abe:	0d650513          	addi	a0,a0,214 # 80010b90 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00023517          	auipc	a0,0x23
    80000ad2:	8f250513          	addi	a0,a0,-1806 # 800233c0 <end>
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
    80000af4:	0a048493          	addi	s1,s1,160 # 80010b90 <kmem>
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
    80000b0c:	08850513          	addi	a0,a0,136 # 80010b90 <kmem>
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
    80000b38:	05c50513          	addi	a0,a0,92 # 80010b90 <kmem>
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
    80000e8c:	aa070713          	addi	a4,a4,-1376 # 80008928 <started>
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
    80000ec2:	b8c080e7          	jalr	-1140(ra) # 80002a4a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	1fa080e7          	jalr	506(ra) # 800060c0 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	076080e7          	jalr	118(ra) # 80001f44 <scheduler>
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
    80000f3a:	aec080e7          	jalr	-1300(ra) # 80002a22 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	b0c080e7          	jalr	-1268(ra) # 80002a4a <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	164080e7          	jalr	356(ra) # 800060aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	172080e7          	jalr	370(ra) # 800060c0 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	30e080e7          	jalr	782(ra) # 80003264 <binit>
    iinit();         // inode table
    80000f5e:	00003097          	auipc	ra,0x3
    80000f62:	9b2080e7          	jalr	-1614(ra) # 80003910 <iinit>
    fileinit();      // file table
    80000f66:	00004097          	auipc	ra,0x4
    80000f6a:	950080e7          	jalr	-1712(ra) # 800048b6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	25a080e7          	jalr	602(ra) # 800061c8 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	da8080e7          	jalr	-600(ra) # 80001d1e <userinit>
    __sync_synchronize();
    80000f7e:	0ff0000f          	fence
    started = 1;
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	9af72223          	sw	a5,-1628(a4) # 80008928 <started>
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
    80000f9c:	9987b783          	ld	a5,-1640(a5) # 80008930 <kernel_pagetable>
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
    80001258:	6ca7be23          	sd	a0,1756(a5) # 80008930 <kernel_pagetable>
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
    80001850:	79448493          	addi	s1,s1,1940 # 80010fe0 <proc>
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
    8000186a:	77aa0a13          	addi	s4,s4,1914 # 80017fe0 <tickslock>
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
    800018ec:	2c850513          	addi	a0,a0,712 # 80010bb0 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	2c850513          	addi	a0,a0,712 # 80010bc8 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	6d048493          	addi	s1,s1,1744 # 80010fe0 <proc>
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
    80001936:	6ae98993          	addi	s3,s3,1710 # 80017fe0 <tickslock>
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
    800019a0:	24450513          	addi	a0,a0,580 # 80010be0 <cpus>
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
    800019c8:	1ec70713          	addi	a4,a4,492 # 80010bb0 <pid_lock>
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
    80001a00:	ea47a783          	lw	a5,-348(a5) # 800088a0 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	05c080e7          	jalr	92(ra) # 80002a62 <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	e807a523          	sw	zero,-374(a5) # 800088a0 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	e70080e7          	jalr	-400(ra) # 80003890 <fsinit>
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
    80001a3a:	17a90913          	addi	s2,s2,378 # 80010bb0 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	e5c78793          	addi	a5,a5,-420 # 800088a4 <nextpid>
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
    80001b5e:	7139                	addi	sp,sp,-64
    80001b60:	fc06                	sd	ra,56(sp)
    80001b62:	f822                	sd	s0,48(sp)
    80001b64:	f426                	sd	s1,40(sp)
    80001b66:	f04a                	sd	s2,32(sp)
    80001b68:	ec4e                	sd	s3,24(sp)
    80001b6a:	e852                	sd	s4,16(sp)
    80001b6c:	e456                	sd	s5,8(sp)
    80001b6e:	0080                	addi	s0,sp,64
    80001b70:	892a                	mv	s2,a0
  if(p->trapframe)
    80001b72:	6148                	ld	a0,128(a0)
    80001b74:	c509                	beqz	a0,80001b7e <freeproc+0x20>
    kfree((void*)p->trapframe);
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	e74080e7          	jalr	-396(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b7e:	08093023          	sd	zero,128(s2)
  if(p->pagetable)
    80001b82:	07893503          	ld	a0,120(s2)
    80001b86:	c519                	beqz	a0,80001b94 <freeproc+0x36>
    proc_freepagetable(p->pagetable, p->sz);
    80001b88:	07093583          	ld	a1,112(s2)
    80001b8c:	00000097          	auipc	ra,0x0
    80001b90:	f80080e7          	jalr	-128(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b94:	06093c23          	sd	zero,120(s2)
  p->sz = 0;
    80001b98:	06093823          	sd	zero,112(s2)
  p->pid = 0;
    80001b9c:	02092823          	sw	zero,48(s2)
  p->parent = 0;
    80001ba0:	06093023          	sd	zero,96(s2)
  p->name[0] = 0;
    80001ba4:	18090023          	sb	zero,384(s2)
  p->chan = 0;
    80001ba8:	02093023          	sd	zero,32(s2)
  p->killed = 0;
    80001bac:	02092423          	sw	zero,40(s2)
  p->xstate = 0;
    80001bb0:	02092623          	sw	zero,44(s2)
  p->state = UNUSED;
    80001bb4:	00092c23          	sw	zero,24(s2)
  p->ps_priority=5;
    80001bb8:	4795                	li	a5,5
    80001bba:	18f92823          	sw	a5,400(s2)
  p->cfs_priority=100;
    80001bbe:	06400793          	li	a5,100
    80001bc2:	18f92a23          	sw	a5,404(s2)
  p->rtime=0;
    80001bc6:	18093c23          	sd	zero,408(s2)
  p->stime=0;
    80001bca:	1a093023          	sd	zero,416(s2)
  p->retime=0;
    80001bce:	1a093423          	sd	zero,424(s2)
  p->vruntime = 0;
    80001bd2:	1a093823          	sd	zero,432(s2)
  p->init_ticks=ticks;
    80001bd6:	00007797          	auipc	a5,0x7
    80001bda:	d6a7e783          	lwu	a5,-662(a5) # 80008940 <ticks>
    80001bde:	1af93c23          	sd	a5,440(s2)
    long long min=LLONG_MAX;
    80001be2:	5afd                	li	s5,-1
    80001be4:	001ada93          	srli	s5,s5,0x1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001be8:	0000f497          	auipc	s1,0xf
    80001bec:	3f848493          	addi	s1,s1,1016 # 80010fe0 <proc>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001bf0:	4a05                	li	s4,1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001bf2:	00016997          	auipc	s3,0x16
    80001bf6:	3ee98993          	addi	s3,s3,1006 # 80017fe0 <tickslock>
    80001bfa:	a811                	j	80001c0e <freeproc+0xb0>
        release(&other_p->lock);
    80001bfc:	8526                	mv	a0,s1
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	08c080e7          	jalr	140(ra) # 80000c8a <release>
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001c06:	1c048493          	addi	s1,s1,448
    80001c0a:	03348263          	beq	s1,s3,80001c2e <freeproc+0xd0>
        if(other_p != p){
    80001c0e:	fe990ce3          	beq	s2,s1,80001c06 <freeproc+0xa8>
           acquire(&other_p->lock);
    80001c12:	8526                	mv	a0,s1
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	fc2080e7          	jalr	-62(ra) # 80000bd6 <acquire>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001c1c:	4c9c                	lw	a5,24(s1)
    80001c1e:	37f5                	addiw	a5,a5,-3
    80001c20:	fcfa6ee3          	bltu	s4,a5,80001bfc <freeproc+0x9e>
              if(min>other_p->accumulator)
    80001c24:	6cbc                	ld	a5,88(s1)
    80001c26:	fd57dbe3          	bge	a5,s5,80001bfc <freeproc+0x9e>
    80001c2a:	8abe                	mv	s5,a5
    80001c2c:	bfc1                	j	80001bfc <freeproc+0x9e>
    if(min==LLONG_MAX){
    80001c2e:	57fd                	li	a5,-1
    80001c30:	8385                	srli	a5,a5,0x1
    80001c32:	00fa8d63          	beq	s5,a5,80001c4c <freeproc+0xee>
    80001c36:	05593c23          	sd	s5,88(s2)
}
    80001c3a:	70e2                	ld	ra,56(sp)
    80001c3c:	7442                	ld	s0,48(sp)
    80001c3e:	74a2                	ld	s1,40(sp)
    80001c40:	7902                	ld	s2,32(sp)
    80001c42:	69e2                	ld	s3,24(sp)
    80001c44:	6a42                	ld	s4,16(sp)
    80001c46:	6aa2                	ld	s5,8(sp)
    80001c48:	6121                	addi	sp,sp,64
    80001c4a:	8082                	ret
      p->accumulator=0;
    80001c4c:	4a81                	li	s5,0
    80001c4e:	b7e5                	j	80001c36 <freeproc+0xd8>

0000000080001c50 <allocproc>:
{
    80001c50:	1101                	addi	sp,sp,-32
    80001c52:	ec06                	sd	ra,24(sp)
    80001c54:	e822                	sd	s0,16(sp)
    80001c56:	e426                	sd	s1,8(sp)
    80001c58:	e04a                	sd	s2,0(sp)
    80001c5a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c5c:	0000f497          	auipc	s1,0xf
    80001c60:	38448493          	addi	s1,s1,900 # 80010fe0 <proc>
    80001c64:	00016917          	auipc	s2,0x16
    80001c68:	37c90913          	addi	s2,s2,892 # 80017fe0 <tickslock>
    acquire(&p->lock);
    80001c6c:	8526                	mv	a0,s1
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	f68080e7          	jalr	-152(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001c76:	4c9c                	lw	a5,24(s1)
    80001c78:	cf81                	beqz	a5,80001c90 <allocproc+0x40>
      release(&p->lock);
    80001c7a:	8526                	mv	a0,s1
    80001c7c:	fffff097          	auipc	ra,0xfffff
    80001c80:	00e080e7          	jalr	14(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c84:	1c048493          	addi	s1,s1,448
    80001c88:	ff2492e3          	bne	s1,s2,80001c6c <allocproc+0x1c>
  return 0;
    80001c8c:	4481                	li	s1,0
    80001c8e:	a889                	j	80001ce0 <allocproc+0x90>
  p->pid = allocpid();
    80001c90:	00000097          	auipc	ra,0x0
    80001c94:	d9a080e7          	jalr	-614(ra) # 80001a2a <allocpid>
    80001c98:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c9a:	4785                	li	a5,1
    80001c9c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c9e:	fffff097          	auipc	ra,0xfffff
    80001ca2:	e48080e7          	jalr	-440(ra) # 80000ae6 <kalloc>
    80001ca6:	892a                	mv	s2,a0
    80001ca8:	e0c8                	sd	a0,128(s1)
    80001caa:	c131                	beqz	a0,80001cee <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001cac:	8526                	mv	a0,s1
    80001cae:	00000097          	auipc	ra,0x0
    80001cb2:	dc2080e7          	jalr	-574(ra) # 80001a70 <proc_pagetable>
    80001cb6:	892a                	mv	s2,a0
    80001cb8:	fca8                	sd	a0,120(s1)
  if(p->pagetable == 0){
    80001cba:	c531                	beqz	a0,80001d06 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001cbc:	07000613          	li	a2,112
    80001cc0:	4581                	li	a1,0
    80001cc2:	08848513          	addi	a0,s1,136
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	00c080e7          	jalr	12(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001cce:	00000797          	auipc	a5,0x0
    80001cd2:	d1678793          	addi	a5,a5,-746 # 800019e4 <forkret>
    80001cd6:	e4dc                	sd	a5,136(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cd8:	74bc                	ld	a5,104(s1)
    80001cda:	6705                	lui	a4,0x1
    80001cdc:	97ba                	add	a5,a5,a4
    80001cde:	e8dc                	sd	a5,144(s1)
}
    80001ce0:	8526                	mv	a0,s1
    80001ce2:	60e2                	ld	ra,24(sp)
    80001ce4:	6442                	ld	s0,16(sp)
    80001ce6:	64a2                	ld	s1,8(sp)
    80001ce8:	6902                	ld	s2,0(sp)
    80001cea:	6105                	addi	sp,sp,32
    80001cec:	8082                	ret
    freeproc(p);
    80001cee:	8526                	mv	a0,s1
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	e6e080e7          	jalr	-402(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	f90080e7          	jalr	-112(ra) # 80000c8a <release>
    return 0;
    80001d02:	84ca                	mv	s1,s2
    80001d04:	bff1                	j	80001ce0 <allocproc+0x90>
    freeproc(p);
    80001d06:	8526                	mv	a0,s1
    80001d08:	00000097          	auipc	ra,0x0
    80001d0c:	e56080e7          	jalr	-426(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001d10:	8526                	mv	a0,s1
    80001d12:	fffff097          	auipc	ra,0xfffff
    80001d16:	f78080e7          	jalr	-136(ra) # 80000c8a <release>
    return 0;
    80001d1a:	84ca                	mv	s1,s2
    80001d1c:	b7d1                	j	80001ce0 <allocproc+0x90>

0000000080001d1e <userinit>:
{
    80001d1e:	1101                	addi	sp,sp,-32
    80001d20:	ec06                	sd	ra,24(sp)
    80001d22:	e822                	sd	s0,16(sp)
    80001d24:	e426                	sd	s1,8(sp)
    80001d26:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	f28080e7          	jalr	-216(ra) # 80001c50 <allocproc>
    80001d30:	84aa                	mv	s1,a0
  initproc = p;
    80001d32:	00007797          	auipc	a5,0x7
    80001d36:	c0a7b323          	sd	a0,-1018(a5) # 80008938 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d3a:	03400613          	li	a2,52
    80001d3e:	00007597          	auipc	a1,0x7
    80001d42:	b7258593          	addi	a1,a1,-1166 # 800088b0 <initcode>
    80001d46:	7d28                	ld	a0,120(a0)
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	60e080e7          	jalr	1550(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001d50:	6785                	lui	a5,0x1
    80001d52:	f8bc                	sd	a5,112(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d54:	60d8                	ld	a4,128(s1)
    80001d56:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d5a:	60d8                	ld	a4,128(s1)
    80001d5c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d5e:	4641                	li	a2,16
    80001d60:	00006597          	auipc	a1,0x6
    80001d64:	4a058593          	addi	a1,a1,1184 # 80008200 <digits+0x1c0>
    80001d68:	18048513          	addi	a0,s1,384
    80001d6c:	fffff097          	auipc	ra,0xfffff
    80001d70:	0b0080e7          	jalr	176(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	49c50513          	addi	a0,a0,1180 # 80008210 <digits+0x1d0>
    80001d7c:	00002097          	auipc	ra,0x2
    80001d80:	536080e7          	jalr	1334(ra) # 800042b2 <namei>
    80001d84:	16a4bc23          	sd	a0,376(s1)
  p->state = RUNNABLE;
    80001d88:	478d                	li	a5,3
    80001d8a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	efc080e7          	jalr	-260(ra) # 80000c8a <release>
}
    80001d96:	60e2                	ld	ra,24(sp)
    80001d98:	6442                	ld	s0,16(sp)
    80001d9a:	64a2                	ld	s1,8(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret

0000000080001da0 <growproc>:
{
    80001da0:	1101                	addi	sp,sp,-32
    80001da2:	ec06                	sd	ra,24(sp)
    80001da4:	e822                	sd	s0,16(sp)
    80001da6:	e426                	sd	s1,8(sp)
    80001da8:	e04a                	sd	s2,0(sp)
    80001daa:	1000                	addi	s0,sp,32
    80001dac:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	bfe080e7          	jalr	-1026(ra) # 800019ac <myproc>
    80001db6:	84aa                	mv	s1,a0
  sz = p->sz;
    80001db8:	792c                	ld	a1,112(a0)
  if(n > 0){
    80001dba:	01204c63          	bgtz	s2,80001dd2 <growproc+0x32>
  } else if(n < 0){
    80001dbe:	02094663          	bltz	s2,80001dea <growproc+0x4a>
  p->sz = sz;
    80001dc2:	f8ac                	sd	a1,112(s1)
  return 0;
    80001dc4:	4501                	li	a0,0
}
    80001dc6:	60e2                	ld	ra,24(sp)
    80001dc8:	6442                	ld	s0,16(sp)
    80001dca:	64a2                	ld	s1,8(sp)
    80001dcc:	6902                	ld	s2,0(sp)
    80001dce:	6105                	addi	sp,sp,32
    80001dd0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dd2:	4691                	li	a3,4
    80001dd4:	00b90633          	add	a2,s2,a1
    80001dd8:	7d28                	ld	a0,120(a0)
    80001dda:	fffff097          	auipc	ra,0xfffff
    80001dde:	636080e7          	jalr	1590(ra) # 80001410 <uvmalloc>
    80001de2:	85aa                	mv	a1,a0
    80001de4:	fd79                	bnez	a0,80001dc2 <growproc+0x22>
      return -1;
    80001de6:	557d                	li	a0,-1
    80001de8:	bff9                	j	80001dc6 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dea:	00b90633          	add	a2,s2,a1
    80001dee:	7d28                	ld	a0,120(a0)
    80001df0:	fffff097          	auipc	ra,0xfffff
    80001df4:	5d8080e7          	jalr	1496(ra) # 800013c8 <uvmdealloc>
    80001df8:	85aa                	mv	a1,a0
    80001dfa:	b7e1                	j	80001dc2 <growproc+0x22>

0000000080001dfc <fork>:
{
    80001dfc:	7139                	addi	sp,sp,-64
    80001dfe:	fc06                	sd	ra,56(sp)
    80001e00:	f822                	sd	s0,48(sp)
    80001e02:	f426                	sd	s1,40(sp)
    80001e04:	f04a                	sd	s2,32(sp)
    80001e06:	ec4e                	sd	s3,24(sp)
    80001e08:	e852                	sd	s4,16(sp)
    80001e0a:	e456                	sd	s5,8(sp)
    80001e0c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	b9e080e7          	jalr	-1122(ra) # 800019ac <myproc>
    80001e16:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	e38080e7          	jalr	-456(ra) # 80001c50 <allocproc>
    80001e20:	12050063          	beqz	a0,80001f40 <fork+0x144>
    80001e24:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e26:	070ab603          	ld	a2,112(s5)
    80001e2a:	7d2c                	ld	a1,120(a0)
    80001e2c:	078ab503          	ld	a0,120(s5)
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	734080e7          	jalr	1844(ra) # 80001564 <uvmcopy>
    80001e38:	04054863          	bltz	a0,80001e88 <fork+0x8c>
  np->sz = p->sz;
    80001e3c:	070ab783          	ld	a5,112(s5)
    80001e40:	06f9b823          	sd	a5,112(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e44:	080ab683          	ld	a3,128(s5)
    80001e48:	87b6                	mv	a5,a3
    80001e4a:	0809b703          	ld	a4,128(s3)
    80001e4e:	12068693          	addi	a3,a3,288
    80001e52:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e56:	6788                	ld	a0,8(a5)
    80001e58:	6b8c                	ld	a1,16(a5)
    80001e5a:	6f90                	ld	a2,24(a5)
    80001e5c:	01073023          	sd	a6,0(a4)
    80001e60:	e708                	sd	a0,8(a4)
    80001e62:	eb0c                	sd	a1,16(a4)
    80001e64:	ef10                	sd	a2,24(a4)
    80001e66:	02078793          	addi	a5,a5,32
    80001e6a:	02070713          	addi	a4,a4,32
    80001e6e:	fed792e3          	bne	a5,a3,80001e52 <fork+0x56>
  np->trapframe->a0 = 0;
    80001e72:	0809b783          	ld	a5,128(s3)
    80001e76:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e7a:	0f8a8493          	addi	s1,s5,248
    80001e7e:	0f898913          	addi	s2,s3,248
    80001e82:	178a8a13          	addi	s4,s5,376
    80001e86:	a00d                	j	80001ea8 <fork+0xac>
    freeproc(np);
    80001e88:	854e                	mv	a0,s3
    80001e8a:	00000097          	auipc	ra,0x0
    80001e8e:	cd4080e7          	jalr	-812(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001e92:	854e                	mv	a0,s3
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	df6080e7          	jalr	-522(ra) # 80000c8a <release>
    return -1;
    80001e9c:	597d                	li	s2,-1
    80001e9e:	a079                	j	80001f2c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001ea0:	04a1                	addi	s1,s1,8
    80001ea2:	0921                	addi	s2,s2,8
    80001ea4:	01448b63          	beq	s1,s4,80001eba <fork+0xbe>
    if(p->ofile[i])
    80001ea8:	6088                	ld	a0,0(s1)
    80001eaa:	d97d                	beqz	a0,80001ea0 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001eac:	00003097          	auipc	ra,0x3
    80001eb0:	a9c080e7          	jalr	-1380(ra) # 80004948 <filedup>
    80001eb4:	00a93023          	sd	a0,0(s2)
    80001eb8:	b7e5                	j	80001ea0 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001eba:	178ab503          	ld	a0,376(s5)
    80001ebe:	00002097          	auipc	ra,0x2
    80001ec2:	c10080e7          	jalr	-1008(ra) # 80003ace <idup>
    80001ec6:	16a9bc23          	sd	a0,376(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001eca:	4641                	li	a2,16
    80001ecc:	180a8593          	addi	a1,s5,384
    80001ed0:	18098513          	addi	a0,s3,384
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	f48080e7          	jalr	-184(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001edc:	0309a903          	lw	s2,48(s3)
  np->cfs_priority=p->cfs_priority;
    80001ee0:	194aa783          	lw	a5,404(s5)
    80001ee4:	18f9aa23          	sw	a5,404(s3)
  release(&np->lock);
    80001ee8:	854e                	mv	a0,s3
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	da0080e7          	jalr	-608(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001ef2:	0000f497          	auipc	s1,0xf
    80001ef6:	cd648493          	addi	s1,s1,-810 # 80010bc8 <wait_lock>
    80001efa:	8526                	mv	a0,s1
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	cda080e7          	jalr	-806(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001f04:	0759b023          	sd	s5,96(s3)
  release(&wait_lock);
    80001f08:	8526                	mv	a0,s1
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	d80080e7          	jalr	-640(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001f12:	854e                	mv	a0,s3
    80001f14:	fffff097          	auipc	ra,0xfffff
    80001f18:	cc2080e7          	jalr	-830(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001f1c:	478d                	li	a5,3
    80001f1e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001f22:	854e                	mv	a0,s3
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	d66080e7          	jalr	-666(ra) # 80000c8a <release>
}
    80001f2c:	854a                	mv	a0,s2
    80001f2e:	70e2                	ld	ra,56(sp)
    80001f30:	7442                	ld	s0,48(sp)
    80001f32:	74a2                	ld	s1,40(sp)
    80001f34:	7902                	ld	s2,32(sp)
    80001f36:	69e2                	ld	s3,24(sp)
    80001f38:	6a42                	ld	s4,16(sp)
    80001f3a:	6aa2                	ld	s5,8(sp)
    80001f3c:	6121                	addi	sp,sp,64
    80001f3e:	8082                	ret
    return -1;
    80001f40:	597d                	li	s2,-1
    80001f42:	b7ed                	j	80001f2c <fork+0x130>

0000000080001f44 <scheduler>:
{
    80001f44:	7159                	addi	sp,sp,-112
    80001f46:	f486                	sd	ra,104(sp)
    80001f48:	f0a2                	sd	s0,96(sp)
    80001f4a:	eca6                	sd	s1,88(sp)
    80001f4c:	e8ca                	sd	s2,80(sp)
    80001f4e:	e4ce                	sd	s3,72(sp)
    80001f50:	e0d2                	sd	s4,64(sp)
    80001f52:	fc56                	sd	s5,56(sp)
    80001f54:	f85a                	sd	s6,48(sp)
    80001f56:	f45e                	sd	s7,40(sp)
    80001f58:	f062                	sd	s8,32(sp)
    80001f5a:	ec66                	sd	s9,24(sp)
    80001f5c:	e86a                	sd	s10,16(sp)
    80001f5e:	e46e                	sd	s11,8(sp)
    80001f60:	1880                	addi	s0,sp,112
    80001f62:	8792                	mv	a5,tp
  int id = r_tp();
    80001f64:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f66:	00779d13          	slli	s10,a5,0x7
    80001f6a:	0000f717          	auipc	a4,0xf
    80001f6e:	c4670713          	addi	a4,a4,-954 # 80010bb0 <pid_lock>
    80001f72:	976a                	add	a4,a4,s10
    80001f74:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &min_vruntime_proc->context);
    80001f78:	0000f717          	auipc	a4,0xf
    80001f7c:	c7070713          	addi	a4,a4,-912 # 80010be8 <cpus+0x8>
    80001f80:	9d3a                	add	s10,s10,a4
    struct proc * min_vruntime_proc = 0;
    80001f82:	4c81                	li	s9,0
      if(p->state == RUNNABLE){
    80001f84:	4b8d                	li	s7,3
    for(p = proc; p < &proc[NPROC]; p++){
    80001f86:	00016b17          	auipc	s6,0x16
    80001f8a:	05ab0b13          	addi	s6,s6,90 # 80017fe0 <tickslock>
      min_vruntime_proc->state = RUNNING;
    80001f8e:	4d91                	li	s11,4
      c->proc = min_vruntime_proc;
    80001f90:	079e                	slli	a5,a5,0x7
    80001f92:	0000fc17          	auipc	s8,0xf
    80001f96:	c1ec0c13          	addi	s8,s8,-994 # 80010bb0 <pid_lock>
    80001f9a:	9c3e                	add	s8,s8,a5
    80001f9c:	a835                	j	80001fd8 <scheduler+0x94>
        if(min_vruntime_proc == 0) {min_vruntime_proc = p;}
    80001f9e:	8a26                	mv	s4,s1
    80001fa0:	a8bd                	j	8000201e <scheduler+0xda>
      else {release(&p->lock);}
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	ce6080e7          	jalr	-794(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001fac:	05696863          	bltu	s2,s6,80001ffc <scheduler+0xb8>
    if(min_vruntime_proc != 0){
    80001fb0:	020a0463          	beqz	s4,80001fd8 <scheduler+0x94>
      min_vruntime_proc->state = RUNNING;
    80001fb4:	01ba2c23          	sw	s11,24(s4)
      c->proc = min_vruntime_proc;
    80001fb8:	034c3823          	sd	s4,48(s8)
      swtch(&c->context, &min_vruntime_proc->context);
    80001fbc:	088a0593          	addi	a1,s4,136
    80001fc0:	856a                	mv	a0,s10
    80001fc2:	00001097          	auipc	ra,0x1
    80001fc6:	9f6080e7          	jalr	-1546(ra) # 800029b8 <swtch>
      c->proc = 0;
    80001fca:	020c3823          	sd	zero,48(s8)
      release(&min_vruntime_proc->lock);
    80001fce:	8552                	mv	a0,s4
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	cba080e7          	jalr	-838(ra) # 80000c8a <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fdc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fe0:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++){
    80001fe4:	0000f497          	auipc	s1,0xf
    80001fe8:	ffc48493          	addi	s1,s1,-4 # 80010fe0 <proc>
    80001fec:	0000f917          	auipc	s2,0xf
    80001ff0:	1b490913          	addi	s2,s2,436 # 800111a0 <proc+0x1c0>
    struct proc * min_vruntime_proc = 0;
    80001ff4:	8a66                	mv	s4,s9
    80001ff6:	a039                	j	80002004 <scheduler+0xc0>
    for(p = proc; p < &proc[NPROC]; p++){
    80001ff8:	fb69fee3          	bgeu	s3,s6,80001fb4 <scheduler+0x70>
    80001ffc:	1c048493          	addi	s1,s1,448
    80002000:	1c090913          	addi	s2,s2,448
    80002004:	8aa6                	mv	s5,s1
      acquire(&p->lock);
    80002006:	8526                	mv	a0,s1
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	bce080e7          	jalr	-1074(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE){
    80002010:	89ca                	mv	s3,s2
    80002012:	e5892783          	lw	a5,-424(s2)
    80002016:	f97796e3          	bne	a5,s7,80001fa2 <scheduler+0x5e>
        if(min_vruntime_proc == 0) {min_vruntime_proc = p;}
    8000201a:	f80a02e3          	beqz	s4,80001f9e <scheduler+0x5a>
        if(min_vruntime_proc->vruntime > p->vruntime){
    8000201e:	1b0a3703          	ld	a4,432(s4)
    80002022:	ff09b783          	ld	a5,-16(s3)
    80002026:	fce7d9e3          	bge	a5,a4,80001ff8 <scheduler+0xb4>
          release(&min_vruntime_proc->lock);
    8000202a:	8552                	mv	a0,s4
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	c5e080e7          	jalr	-930(ra) # 80000c8a <release>
    80002034:	8a56                	mv	s4,s5
    80002036:	b7c9                	j	80001ff8 <scheduler+0xb4>

0000000080002038 <sched>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	966080e7          	jalr	-1690(ra) # 800019ac <myproc>
    8000204e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	b0c080e7          	jalr	-1268(ra) # 80000b5c <holding>
    80002058:	c93d                	beqz	a0,800020ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000205a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000205c:	2781                	sext.w	a5,a5
    8000205e:	079e                	slli	a5,a5,0x7
    80002060:	0000f717          	auipc	a4,0xf
    80002064:	b5070713          	addi	a4,a4,-1200 # 80010bb0 <pid_lock>
    80002068:	97ba                	add	a5,a5,a4
    8000206a:	0a87a703          	lw	a4,168(a5)
    8000206e:	4785                	li	a5,1
    80002070:	06f71763          	bne	a4,a5,800020de <sched+0xa6>
  if(p->state == RUNNING)
    80002074:	4c98                	lw	a4,24(s1)
    80002076:	4791                	li	a5,4
    80002078:	06f70b63          	beq	a4,a5,800020ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000207c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002080:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002082:	efb5                	bnez	a5,800020fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002084:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002086:	0000f917          	auipc	s2,0xf
    8000208a:	b2a90913          	addi	s2,s2,-1238 # 80010bb0 <pid_lock>
    8000208e:	2781                	sext.w	a5,a5
    80002090:	079e                	slli	a5,a5,0x7
    80002092:	97ca                	add	a5,a5,s2
    80002094:	0ac7a983          	lw	s3,172(a5)
    80002098:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000209a:	2781                	sext.w	a5,a5
    8000209c:	079e                	slli	a5,a5,0x7
    8000209e:	0000f597          	auipc	a1,0xf
    800020a2:	b4a58593          	addi	a1,a1,-1206 # 80010be8 <cpus+0x8>
    800020a6:	95be                	add	a1,a1,a5
    800020a8:	08848513          	addi	a0,s1,136
    800020ac:	00001097          	auipc	ra,0x1
    800020b0:	90c080e7          	jalr	-1780(ra) # 800029b8 <swtch>
    800020b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800020b6:	2781                	sext.w	a5,a5
    800020b8:	079e                	slli	a5,a5,0x7
    800020ba:	97ca                	add	a5,a5,s2
    800020bc:	0b37a623          	sw	s3,172(a5)
}
    800020c0:	70a2                	ld	ra,40(sp)
    800020c2:	7402                	ld	s0,32(sp)
    800020c4:	64e2                	ld	s1,24(sp)
    800020c6:	6942                	ld	s2,16(sp)
    800020c8:	69a2                	ld	s3,8(sp)
    800020ca:	6145                	addi	sp,sp,48
    800020cc:	8082                	ret
    panic("sched p->lock");
    800020ce:	00006517          	auipc	a0,0x6
    800020d2:	14a50513          	addi	a0,a0,330 # 80008218 <digits+0x1d8>
    800020d6:	ffffe097          	auipc	ra,0xffffe
    800020da:	468080e7          	jalr	1128(ra) # 8000053e <panic>
    panic("sched locks");
    800020de:	00006517          	auipc	a0,0x6
    800020e2:	14a50513          	addi	a0,a0,330 # 80008228 <digits+0x1e8>
    800020e6:	ffffe097          	auipc	ra,0xffffe
    800020ea:	458080e7          	jalr	1112(ra) # 8000053e <panic>
    panic("sched running");
    800020ee:	00006517          	auipc	a0,0x6
    800020f2:	14a50513          	addi	a0,a0,330 # 80008238 <digits+0x1f8>
    800020f6:	ffffe097          	auipc	ra,0xffffe
    800020fa:	448080e7          	jalr	1096(ra) # 8000053e <panic>
    panic("sched interruptible");
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	14a50513          	addi	a0,a0,330 # 80008248 <digits+0x208>
    80002106:	ffffe097          	auipc	ra,0xffffe
    8000210a:	438080e7          	jalr	1080(ra) # 8000053e <panic>

000000008000210e <yield>:
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	894080e7          	jalr	-1900(ra) # 800019ac <myproc>
    80002120:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	ab4080e7          	jalr	-1356(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    8000212a:	478d                	li	a5,3
    8000212c:	cc9c                	sw	a5,24(s1)
  sched();
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	f0a080e7          	jalr	-246(ra) # 80002038 <sched>
  release(&p->lock);
    80002136:	8526                	mv	a0,s1
    80002138:	fffff097          	auipc	ra,0xfffff
    8000213c:	b52080e7          	jalr	-1198(ra) # 80000c8a <release>
}
    80002140:	60e2                	ld	ra,24(sp)
    80002142:	6442                	ld	s0,16(sp)
    80002144:	64a2                	ld	s1,8(sp)
    80002146:	6105                	addi	sp,sp,32
    80002148:	8082                	ret

000000008000214a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	e84a                	sd	s2,16(sp)
    80002154:	e44e                	sd	s3,8(sp)
    80002156:	1800                	addi	s0,sp,48
    80002158:	89aa                	mv	s3,a0
    8000215a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	850080e7          	jalr	-1968(ra) # 800019ac <myproc>
    80002164:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	a70080e7          	jalr	-1424(ra) # 80000bd6 <acquire>
  release(lk);
    8000216e:	854a                	mv	a0,s2
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	b1a080e7          	jalr	-1254(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    80002178:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000217c:	4789                	li	a5,2
    8000217e:	cc9c                	sw	a5,24(s1)

  sched();
    80002180:	00000097          	auipc	ra,0x0
    80002184:	eb8080e7          	jalr	-328(ra) # 80002038 <sched>

  // Tidy up.
  p->chan = 0;
    80002188:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000218c:	8526                	mv	a0,s1
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	afc080e7          	jalr	-1284(ra) # 80000c8a <release>
  acquire(lk);
    80002196:	854a                	mv	a0,s2
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	a3e080e7          	jalr	-1474(ra) # 80000bd6 <acquire>
}
    800021a0:	70a2                	ld	ra,40(sp)
    800021a2:	7402                	ld	s0,32(sp)
    800021a4:	64e2                	ld	s1,24(sp)
    800021a6:	6942                	ld	s2,16(sp)
    800021a8:	69a2                	ld	s3,8(sp)
    800021aa:	6145                	addi	sp,sp,48
    800021ac:	8082                	ret

00000000800021ae <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021ae:	711d                	addi	sp,sp,-96
    800021b0:	ec86                	sd	ra,88(sp)
    800021b2:	e8a2                	sd	s0,80(sp)
    800021b4:	e4a6                	sd	s1,72(sp)
    800021b6:	e0ca                	sd	s2,64(sp)
    800021b8:	fc4e                	sd	s3,56(sp)
    800021ba:	f852                	sd	s4,48(sp)
    800021bc:	f456                	sd	s5,40(sp)
    800021be:	f05a                	sd	s6,32(sp)
    800021c0:	ec5e                	sd	s7,24(sp)
    800021c2:	e862                	sd	s8,16(sp)
    800021c4:	e466                	sd	s9,8(sp)
    800021c6:	e06a                	sd	s10,0(sp)
    800021c8:	1080                	addi	s0,sp,96
    800021ca:	8baa                	mv	s7,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021cc:	0000f917          	auipc	s2,0xf
    800021d0:	e1490913          	addi	s2,s2,-492 # 80010fe0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800021d4:	4b09                	li	s6,2


            struct proc *other_p;
            long long min=LLONG_MAX;
    800021d6:	5c7d                	li	s8,-1
    800021d8:	001c5c13          	srli	s8,s8,0x1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
                if(other_p != p){
                  acquire(&other_p->lock);
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    800021dc:	4a05                	li	s4,1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800021de:	00016997          	auipc	s3,0x16
    800021e2:	e0298993          	addi	s3,s3,-510 # 80017fe0 <tickslock>
          
      



        p->state = RUNNABLE;
    800021e6:	4c8d                	li	s9,3
            p->accumulator=0;
    800021e8:	4d01                	li	s10,0
    800021ea:	a889                	j	8000223c <wakeup+0x8e>
                release(&other_p->lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	a9c080e7          	jalr	-1380(ra) # 80000c8a <release>
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800021f6:	1c048493          	addi	s1,s1,448
    800021fa:	03348263          	beq	s1,s3,8000221e <wakeup+0x70>
                if(other_p != p){
    800021fe:	fe990ce3          	beq	s2,s1,800021f6 <wakeup+0x48>
                  acquire(&other_p->lock);
    80002202:	8526                	mv	a0,s1
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	9d2080e7          	jalr	-1582(ra) # 80000bd6 <acquire>
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    8000220c:	4c9c                	lw	a5,24(s1)
    8000220e:	37f5                	addiw	a5,a5,-3
    80002210:	fcfa6ee3          	bltu	s4,a5,800021ec <wakeup+0x3e>
                      if(min>other_p->accumulator)
    80002214:	6cbc                	ld	a5,88(s1)
    80002216:	fd57dbe3          	bge	a5,s5,800021ec <wakeup+0x3e>
    8000221a:	8abe                	mv	s5,a5
    8000221c:	bfc1                	j	800021ec <wakeup+0x3e>
          if(min==LLONG_MAX){
    8000221e:	058a8863          	beq	s5,s8,8000226e <wakeup+0xc0>
    80002222:	05593c23          	sd	s5,88(s2)
        p->state = RUNNABLE;
    80002226:	01992c23          	sw	s9,24(s2)
      }
      release(&p->lock);
    8000222a:	854a                	mv	a0,s2
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	a5e080e7          	jalr	-1442(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002234:	1c090913          	addi	s2,s2,448
    80002238:	03390d63          	beq	s2,s3,80002272 <wakeup+0xc4>
    if(p != myproc()){
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	770080e7          	jalr	1904(ra) # 800019ac <myproc>
    80002244:	fea908e3          	beq	s2,a0,80002234 <wakeup+0x86>
      acquire(&p->lock);
    80002248:	854a                	mv	a0,s2
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	98c080e7          	jalr	-1652(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002252:	01892783          	lw	a5,24(s2)
    80002256:	fd679ae3          	bne	a5,s6,8000222a <wakeup+0x7c>
    8000225a:	02093783          	ld	a5,32(s2)
    8000225e:	fd7796e3          	bne	a5,s7,8000222a <wakeup+0x7c>
            long long min=LLONG_MAX;
    80002262:	8ae2                	mv	s5,s8
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80002264:	0000f497          	auipc	s1,0xf
    80002268:	d7c48493          	addi	s1,s1,-644 # 80010fe0 <proc>
    8000226c:	bf49                	j	800021fe <wakeup+0x50>
            p->accumulator=0;
    8000226e:	8aea                	mv	s5,s10
    80002270:	bf4d                	j	80002222 <wakeup+0x74>
    }
  }
}
    80002272:	60e6                	ld	ra,88(sp)
    80002274:	6446                	ld	s0,80(sp)
    80002276:	64a6                	ld	s1,72(sp)
    80002278:	6906                	ld	s2,64(sp)
    8000227a:	79e2                	ld	s3,56(sp)
    8000227c:	7a42                	ld	s4,48(sp)
    8000227e:	7aa2                	ld	s5,40(sp)
    80002280:	7b02                	ld	s6,32(sp)
    80002282:	6be2                	ld	s7,24(sp)
    80002284:	6c42                	ld	s8,16(sp)
    80002286:	6ca2                	ld	s9,8(sp)
    80002288:	6d02                	ld	s10,0(sp)
    8000228a:	6125                	addi	sp,sp,96
    8000228c:	8082                	ret

000000008000228e <reparent>:
{
    8000228e:	7179                	addi	sp,sp,-48
    80002290:	f406                	sd	ra,40(sp)
    80002292:	f022                	sd	s0,32(sp)
    80002294:	ec26                	sd	s1,24(sp)
    80002296:	e84a                	sd	s2,16(sp)
    80002298:	e44e                	sd	s3,8(sp)
    8000229a:	e052                	sd	s4,0(sp)
    8000229c:	1800                	addi	s0,sp,48
    8000229e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022a0:	0000f497          	auipc	s1,0xf
    800022a4:	d4048493          	addi	s1,s1,-704 # 80010fe0 <proc>
      pp->parent = initproc;
    800022a8:	00006a17          	auipc	s4,0x6
    800022ac:	690a0a13          	addi	s4,s4,1680 # 80008938 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800022b0:	00016997          	auipc	s3,0x16
    800022b4:	d3098993          	addi	s3,s3,-720 # 80017fe0 <tickslock>
    800022b8:	a029                	j	800022c2 <reparent+0x34>
    800022ba:	1c048493          	addi	s1,s1,448
    800022be:	01348d63          	beq	s1,s3,800022d8 <reparent+0x4a>
    if(pp->parent == p){
    800022c2:	70bc                	ld	a5,96(s1)
    800022c4:	ff279be3          	bne	a5,s2,800022ba <reparent+0x2c>
      pp->parent = initproc;
    800022c8:	000a3503          	ld	a0,0(s4)
    800022cc:	f0a8                	sd	a0,96(s1)
      wakeup(initproc);
    800022ce:	00000097          	auipc	ra,0x0
    800022d2:	ee0080e7          	jalr	-288(ra) # 800021ae <wakeup>
    800022d6:	b7d5                	j	800022ba <reparent+0x2c>
}
    800022d8:	70a2                	ld	ra,40(sp)
    800022da:	7402                	ld	s0,32(sp)
    800022dc:	64e2                	ld	s1,24(sp)
    800022de:	6942                	ld	s2,16(sp)
    800022e0:	69a2                	ld	s3,8(sp)
    800022e2:	6a02                	ld	s4,0(sp)
    800022e4:	6145                	addi	sp,sp,48
    800022e6:	8082                	ret

00000000800022e8 <exit>:
{
    800022e8:	7139                	addi	sp,sp,-64
    800022ea:	fc06                	sd	ra,56(sp)
    800022ec:	f822                	sd	s0,48(sp)
    800022ee:	f426                	sd	s1,40(sp)
    800022f0:	f04a                	sd	s2,32(sp)
    800022f2:	ec4e                	sd	s3,24(sp)
    800022f4:	e852                	sd	s4,16(sp)
    800022f6:	e456                	sd	s5,8(sp)
    800022f8:	0080                	addi	s0,sp,64
    800022fa:	8aaa                	mv	s5,a0
    800022fc:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	6ae080e7          	jalr	1710(ra) # 800019ac <myproc>
    80002306:	89aa                	mv	s3,a0
  if(p == initproc)
    80002308:	00006797          	auipc	a5,0x6
    8000230c:	6307b783          	ld	a5,1584(a5) # 80008938 <initproc>
    80002310:	0f850493          	addi	s1,a0,248
    80002314:	17850913          	addi	s2,a0,376
    80002318:	02a79363          	bne	a5,a0,8000233e <exit+0x56>
    panic("init exiting");
    8000231c:	00006517          	auipc	a0,0x6
    80002320:	f4450513          	addi	a0,a0,-188 # 80008260 <digits+0x220>
    80002324:	ffffe097          	auipc	ra,0xffffe
    80002328:	21a080e7          	jalr	538(ra) # 8000053e <panic>
      fileclose(f);
    8000232c:	00002097          	auipc	ra,0x2
    80002330:	66e080e7          	jalr	1646(ra) # 8000499a <fileclose>
      p->ofile[fd] = 0;
    80002334:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002338:	04a1                	addi	s1,s1,8
    8000233a:	01248563          	beq	s1,s2,80002344 <exit+0x5c>
    if(p->ofile[fd]){
    8000233e:	6088                	ld	a0,0(s1)
    80002340:	f575                	bnez	a0,8000232c <exit+0x44>
    80002342:	bfdd                	j	80002338 <exit+0x50>
  begin_op();
    80002344:	00002097          	auipc	ra,0x2
    80002348:	18a080e7          	jalr	394(ra) # 800044ce <begin_op>
  iput(p->cwd);
    8000234c:	1789b503          	ld	a0,376(s3)
    80002350:	00002097          	auipc	ra,0x2
    80002354:	976080e7          	jalr	-1674(ra) # 80003cc6 <iput>
  end_op();
    80002358:	00002097          	auipc	ra,0x2
    8000235c:	1f6080e7          	jalr	502(ra) # 8000454e <end_op>
  p->cwd = 0;
    80002360:	1609bc23          	sd	zero,376(s3)
  acquire(&wait_lock);
    80002364:	0000f497          	auipc	s1,0xf
    80002368:	86448493          	addi	s1,s1,-1948 # 80010bc8 <wait_lock>
    8000236c:	8526                	mv	a0,s1
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	868080e7          	jalr	-1944(ra) # 80000bd6 <acquire>
  reparent(p);
    80002376:	854e                	mv	a0,s3
    80002378:	00000097          	auipc	ra,0x0
    8000237c:	f16080e7          	jalr	-234(ra) # 8000228e <reparent>
  wakeup(p->parent);
    80002380:	0609b503          	ld	a0,96(s3)
    80002384:	00000097          	auipc	ra,0x0
    80002388:	e2a080e7          	jalr	-470(ra) # 800021ae <wakeup>
  acquire(&p->lock);
    8000238c:	854e                	mv	a0,s3
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	848080e7          	jalr	-1976(ra) # 80000bd6 <acquire>
  p->xstate = status;
    80002396:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, sizeof(p->exit_msg));
    8000239a:	02000613          	li	a2,32
    8000239e:	85d2                	mv	a1,s4
    800023a0:	03498513          	addi	a0,s3,52
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	a78080e7          	jalr	-1416(ra) # 80000e1c <safestrcpy>
  p->state = ZOMBIE;
    800023ac:	4795                	li	a5,5
    800023ae:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800023b2:	8526                	mv	a0,s1
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	8d6080e7          	jalr	-1834(ra) # 80000c8a <release>
  sched();
    800023bc:	00000097          	auipc	ra,0x0
    800023c0:	c7c080e7          	jalr	-900(ra) # 80002038 <sched>
  panic("zombie exit");
    800023c4:	00006517          	auipc	a0,0x6
    800023c8:	eac50513          	addi	a0,a0,-340 # 80008270 <digits+0x230>
    800023cc:	ffffe097          	auipc	ra,0xffffe
    800023d0:	172080e7          	jalr	370(ra) # 8000053e <panic>

00000000800023d4 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023d4:	7179                	addi	sp,sp,-48
    800023d6:	f406                	sd	ra,40(sp)
    800023d8:	f022                	sd	s0,32(sp)
    800023da:	ec26                	sd	s1,24(sp)
    800023dc:	e84a                	sd	s2,16(sp)
    800023de:	e44e                	sd	s3,8(sp)
    800023e0:	1800                	addi	s0,sp,48
    800023e2:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023e4:	0000f497          	auipc	s1,0xf
    800023e8:	bfc48493          	addi	s1,s1,-1028 # 80010fe0 <proc>
    800023ec:	00016997          	auipc	s3,0x16
    800023f0:	bf498993          	addi	s3,s3,-1036 # 80017fe0 <tickslock>
    acquire(&p->lock);
    800023f4:	8526                	mv	a0,s1
    800023f6:	ffffe097          	auipc	ra,0xffffe
    800023fa:	7e0080e7          	jalr	2016(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800023fe:	589c                	lw	a5,48(s1)
    80002400:	01278d63          	beq	a5,s2,8000241a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002404:	8526                	mv	a0,s1
    80002406:	fffff097          	auipc	ra,0xfffff
    8000240a:	884080e7          	jalr	-1916(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000240e:	1c048493          	addi	s1,s1,448
    80002412:	ff3491e3          	bne	s1,s3,800023f4 <kill+0x20>
  }
  return -1;
    80002416:	557d                	li	a0,-1
    80002418:	a829                	j	80002432 <kill+0x5e>
      p->killed = 1;
    8000241a:	4785                	li	a5,1
    8000241c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000241e:	4c98                	lw	a4,24(s1)
    80002420:	4789                	li	a5,2
    80002422:	00f70f63          	beq	a4,a5,80002440 <kill+0x6c>
      release(&p->lock);
    80002426:	8526                	mv	a0,s1
    80002428:	fffff097          	auipc	ra,0xfffff
    8000242c:	862080e7          	jalr	-1950(ra) # 80000c8a <release>
      return 0;
    80002430:	4501                	li	a0,0
}
    80002432:	70a2                	ld	ra,40(sp)
    80002434:	7402                	ld	s0,32(sp)
    80002436:	64e2                	ld	s1,24(sp)
    80002438:	6942                	ld	s2,16(sp)
    8000243a:	69a2                	ld	s3,8(sp)
    8000243c:	6145                	addi	sp,sp,48
    8000243e:	8082                	ret
        p->state = RUNNABLE;
    80002440:	478d                	li	a5,3
    80002442:	cc9c                	sw	a5,24(s1)
    80002444:	b7cd                	j	80002426 <kill+0x52>

0000000080002446 <setkilled>:

void
setkilled(struct proc *p)
{
    80002446:	1101                	addi	sp,sp,-32
    80002448:	ec06                	sd	ra,24(sp)
    8000244a:	e822                	sd	s0,16(sp)
    8000244c:	e426                	sd	s1,8(sp)
    8000244e:	1000                	addi	s0,sp,32
    80002450:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002452:	ffffe097          	auipc	ra,0xffffe
    80002456:	784080e7          	jalr	1924(ra) # 80000bd6 <acquire>
  p->killed = 1;
    8000245a:	4785                	li	a5,1
    8000245c:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000245e:	8526                	mv	a0,s1
    80002460:	fffff097          	auipc	ra,0xfffff
    80002464:	82a080e7          	jalr	-2006(ra) # 80000c8a <release>
}
    80002468:	60e2                	ld	ra,24(sp)
    8000246a:	6442                	ld	s0,16(sp)
    8000246c:	64a2                	ld	s1,8(sp)
    8000246e:	6105                	addi	sp,sp,32
    80002470:	8082                	ret

0000000080002472 <killed>:

int
killed(struct proc *p)
{
    80002472:	1101                	addi	sp,sp,-32
    80002474:	ec06                	sd	ra,24(sp)
    80002476:	e822                	sd	s0,16(sp)
    80002478:	e426                	sd	s1,8(sp)
    8000247a:	e04a                	sd	s2,0(sp)
    8000247c:	1000                	addi	s0,sp,32
    8000247e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	756080e7          	jalr	1878(ra) # 80000bd6 <acquire>
  k = p->killed;
    80002488:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000248c:	8526                	mv	a0,s1
    8000248e:	ffffe097          	auipc	ra,0xffffe
    80002492:	7fc080e7          	jalr	2044(ra) # 80000c8a <release>
  return k;
}
    80002496:	854a                	mv	a0,s2
    80002498:	60e2                	ld	ra,24(sp)
    8000249a:	6442                	ld	s0,16(sp)
    8000249c:	64a2                	ld	s1,8(sp)
    8000249e:	6902                	ld	s2,0(sp)
    800024a0:	6105                	addi	sp,sp,32
    800024a2:	8082                	ret

00000000800024a4 <wait>:
{
    800024a4:	711d                	addi	sp,sp,-96
    800024a6:	ec86                	sd	ra,88(sp)
    800024a8:	e8a2                	sd	s0,80(sp)
    800024aa:	e4a6                	sd	s1,72(sp)
    800024ac:	e0ca                	sd	s2,64(sp)
    800024ae:	fc4e                	sd	s3,56(sp)
    800024b0:	f852                	sd	s4,48(sp)
    800024b2:	f456                	sd	s5,40(sp)
    800024b4:	f05a                	sd	s6,32(sp)
    800024b6:	ec5e                	sd	s7,24(sp)
    800024b8:	e862                	sd	s8,16(sp)
    800024ba:	e466                	sd	s9,8(sp)
    800024bc:	1080                	addi	s0,sp,96
    800024be:	8baa                	mv	s7,a0
    800024c0:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    800024c2:	fffff097          	auipc	ra,0xfffff
    800024c6:	4ea080e7          	jalr	1258(ra) # 800019ac <myproc>
    800024ca:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024cc:	0000e517          	auipc	a0,0xe
    800024d0:	6fc50513          	addi	a0,a0,1788 # 80010bc8 <wait_lock>
    800024d4:	ffffe097          	auipc	ra,0xffffe
    800024d8:	702080e7          	jalr	1794(ra) # 80000bd6 <acquire>
    havekids = 0;
    800024dc:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800024de:	4a15                	li	s4,5
        havekids = 1;
    800024e0:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024e2:	00016997          	auipc	s3,0x16
    800024e6:	afe98993          	addi	s3,s3,-1282 # 80017fe0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024ea:	0000ec97          	auipc	s9,0xe
    800024ee:	6dec8c93          	addi	s9,s9,1758 # 80010bc8 <wait_lock>
    havekids = 0;
    800024f2:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024f4:	0000f497          	auipc	s1,0xf
    800024f8:	aec48493          	addi	s1,s1,-1300 # 80010fe0 <proc>
    800024fc:	a06d                	j	800025a6 <wait+0x102>
          pid = pp->pid;
    800024fe:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002502:	040b9463          	bnez	s7,8000254a <wait+0xa6>
          if(addr_exitmsg != 0 && copyout(p->pagetable, addr_exitmsg, (char *)&pp->exit_msg,
    80002506:	000b0f63          	beqz	s6,80002524 <wait+0x80>
    8000250a:	02000693          	li	a3,32
    8000250e:	03448613          	addi	a2,s1,52
    80002512:	85da                	mv	a1,s6
    80002514:	07893503          	ld	a0,120(s2)
    80002518:	fffff097          	auipc	ra,0xfffff
    8000251c:	150080e7          	jalr	336(ra) # 80001668 <copyout>
    80002520:	06054063          	bltz	a0,80002580 <wait+0xdc>
          freeproc(pp);
    80002524:	8526                	mv	a0,s1
    80002526:	fffff097          	auipc	ra,0xfffff
    8000252a:	638080e7          	jalr	1592(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    8000252e:	8526                	mv	a0,s1
    80002530:	ffffe097          	auipc	ra,0xffffe
    80002534:	75a080e7          	jalr	1882(ra) # 80000c8a <release>
          release(&wait_lock);
    80002538:	0000e517          	auipc	a0,0xe
    8000253c:	69050513          	addi	a0,a0,1680 # 80010bc8 <wait_lock>
    80002540:	ffffe097          	auipc	ra,0xffffe
    80002544:	74a080e7          	jalr	1866(ra) # 80000c8a <release>
          return pid;
    80002548:	a04d                	j	800025ea <wait+0x146>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000254a:	4691                	li	a3,4
    8000254c:	02c48613          	addi	a2,s1,44
    80002550:	85de                	mv	a1,s7
    80002552:	07893503          	ld	a0,120(s2)
    80002556:	fffff097          	auipc	ra,0xfffff
    8000255a:	112080e7          	jalr	274(ra) # 80001668 <copyout>
    8000255e:	fa0554e3          	bgez	a0,80002506 <wait+0x62>
            release(&pp->lock);
    80002562:	8526                	mv	a0,s1
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	726080e7          	jalr	1830(ra) # 80000c8a <release>
            release(&wait_lock);
    8000256c:	0000e517          	auipc	a0,0xe
    80002570:	65c50513          	addi	a0,a0,1628 # 80010bc8 <wait_lock>
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	716080e7          	jalr	1814(ra) # 80000c8a <release>
            return -1;
    8000257c:	59fd                	li	s3,-1
    8000257e:	a0b5                	j	800025ea <wait+0x146>
            release(&pp->lock);
    80002580:	8526                	mv	a0,s1
    80002582:	ffffe097          	auipc	ra,0xffffe
    80002586:	708080e7          	jalr	1800(ra) # 80000c8a <release>
            release(&wait_lock);
    8000258a:	0000e517          	auipc	a0,0xe
    8000258e:	63e50513          	addi	a0,a0,1598 # 80010bc8 <wait_lock>
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	6f8080e7          	jalr	1784(ra) # 80000c8a <release>
            return -1;
    8000259a:	59fd                	li	s3,-1
    8000259c:	a0b9                	j	800025ea <wait+0x146>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000259e:	1c048493          	addi	s1,s1,448
    800025a2:	03348463          	beq	s1,s3,800025ca <wait+0x126>
      if(pp->parent == p){
    800025a6:	70bc                	ld	a5,96(s1)
    800025a8:	ff279be3          	bne	a5,s2,8000259e <wait+0xfa>
        acquire(&pp->lock);
    800025ac:	8526                	mv	a0,s1
    800025ae:	ffffe097          	auipc	ra,0xffffe
    800025b2:	628080e7          	jalr	1576(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    800025b6:	4c9c                	lw	a5,24(s1)
    800025b8:	f54783e3          	beq	a5,s4,800024fe <wait+0x5a>
        release(&pp->lock);
    800025bc:	8526                	mv	a0,s1
    800025be:	ffffe097          	auipc	ra,0xffffe
    800025c2:	6cc080e7          	jalr	1740(ra) # 80000c8a <release>
        havekids = 1;
    800025c6:	8756                	mv	a4,s5
    800025c8:	bfd9                	j	8000259e <wait+0xfa>
    if(!havekids || killed(p)){
    800025ca:	c719                	beqz	a4,800025d8 <wait+0x134>
    800025cc:	854a                	mv	a0,s2
    800025ce:	00000097          	auipc	ra,0x0
    800025d2:	ea4080e7          	jalr	-348(ra) # 80002472 <killed>
    800025d6:	c905                	beqz	a0,80002606 <wait+0x162>
      release(&wait_lock);
    800025d8:	0000e517          	auipc	a0,0xe
    800025dc:	5f050513          	addi	a0,a0,1520 # 80010bc8 <wait_lock>
    800025e0:	ffffe097          	auipc	ra,0xffffe
    800025e4:	6aa080e7          	jalr	1706(ra) # 80000c8a <release>
      return -1;
    800025e8:	59fd                	li	s3,-1
}
    800025ea:	854e                	mv	a0,s3
    800025ec:	60e6                	ld	ra,88(sp)
    800025ee:	6446                	ld	s0,80(sp)
    800025f0:	64a6                	ld	s1,72(sp)
    800025f2:	6906                	ld	s2,64(sp)
    800025f4:	79e2                	ld	s3,56(sp)
    800025f6:	7a42                	ld	s4,48(sp)
    800025f8:	7aa2                	ld	s5,40(sp)
    800025fa:	7b02                	ld	s6,32(sp)
    800025fc:	6be2                	ld	s7,24(sp)
    800025fe:	6c42                	ld	s8,16(sp)
    80002600:	6ca2                	ld	s9,8(sp)
    80002602:	6125                	addi	sp,sp,96
    80002604:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002606:	85e6                	mv	a1,s9
    80002608:	854a                	mv	a0,s2
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	b40080e7          	jalr	-1216(ra) # 8000214a <sleep>
    havekids = 0;
    80002612:	b5c5                	j	800024f2 <wait+0x4e>

0000000080002614 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002614:	7179                	addi	sp,sp,-48
    80002616:	f406                	sd	ra,40(sp)
    80002618:	f022                	sd	s0,32(sp)
    8000261a:	ec26                	sd	s1,24(sp)
    8000261c:	e84a                	sd	s2,16(sp)
    8000261e:	e44e                	sd	s3,8(sp)
    80002620:	e052                	sd	s4,0(sp)
    80002622:	1800                	addi	s0,sp,48
    80002624:	84aa                	mv	s1,a0
    80002626:	892e                	mv	s2,a1
    80002628:	89b2                	mv	s3,a2
    8000262a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000262c:	fffff097          	auipc	ra,0xfffff
    80002630:	380080e7          	jalr	896(ra) # 800019ac <myproc>
  if(user_dst){
    80002634:	c08d                	beqz	s1,80002656 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002636:	86d2                	mv	a3,s4
    80002638:	864e                	mv	a2,s3
    8000263a:	85ca                	mv	a1,s2
    8000263c:	7d28                	ld	a0,120(a0)
    8000263e:	fffff097          	auipc	ra,0xfffff
    80002642:	02a080e7          	jalr	42(ra) # 80001668 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002646:	70a2                	ld	ra,40(sp)
    80002648:	7402                	ld	s0,32(sp)
    8000264a:	64e2                	ld	s1,24(sp)
    8000264c:	6942                	ld	s2,16(sp)
    8000264e:	69a2                	ld	s3,8(sp)
    80002650:	6a02                	ld	s4,0(sp)
    80002652:	6145                	addi	sp,sp,48
    80002654:	8082                	ret
    memmove((char *)dst, src, len);
    80002656:	000a061b          	sext.w	a2,s4
    8000265a:	85ce                	mv	a1,s3
    8000265c:	854a                	mv	a0,s2
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	6d0080e7          	jalr	1744(ra) # 80000d2e <memmove>
    return 0;
    80002666:	8526                	mv	a0,s1
    80002668:	bff9                	j	80002646 <either_copyout+0x32>

000000008000266a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000266a:	7179                	addi	sp,sp,-48
    8000266c:	f406                	sd	ra,40(sp)
    8000266e:	f022                	sd	s0,32(sp)
    80002670:	ec26                	sd	s1,24(sp)
    80002672:	e84a                	sd	s2,16(sp)
    80002674:	e44e                	sd	s3,8(sp)
    80002676:	e052                	sd	s4,0(sp)
    80002678:	1800                	addi	s0,sp,48
    8000267a:	892a                	mv	s2,a0
    8000267c:	84ae                	mv	s1,a1
    8000267e:	89b2                	mv	s3,a2
    80002680:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002682:	fffff097          	auipc	ra,0xfffff
    80002686:	32a080e7          	jalr	810(ra) # 800019ac <myproc>
  if(user_src){
    8000268a:	c08d                	beqz	s1,800026ac <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000268c:	86d2                	mv	a3,s4
    8000268e:	864e                	mv	a2,s3
    80002690:	85ca                	mv	a1,s2
    80002692:	7d28                	ld	a0,120(a0)
    80002694:	fffff097          	auipc	ra,0xfffff
    80002698:	060080e7          	jalr	96(ra) # 800016f4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000269c:	70a2                	ld	ra,40(sp)
    8000269e:	7402                	ld	s0,32(sp)
    800026a0:	64e2                	ld	s1,24(sp)
    800026a2:	6942                	ld	s2,16(sp)
    800026a4:	69a2                	ld	s3,8(sp)
    800026a6:	6a02                	ld	s4,0(sp)
    800026a8:	6145                	addi	sp,sp,48
    800026aa:	8082                	ret
    memmove(dst, (char*)src, len);
    800026ac:	000a061b          	sext.w	a2,s4
    800026b0:	85ce                	mv	a1,s3
    800026b2:	854a                	mv	a0,s2
    800026b4:	ffffe097          	auipc	ra,0xffffe
    800026b8:	67a080e7          	jalr	1658(ra) # 80000d2e <memmove>
    return 0;
    800026bc:	8526                	mv	a0,s1
    800026be:	bff9                	j	8000269c <either_copyin+0x32>

00000000800026c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800026c0:	715d                	addi	sp,sp,-80
    800026c2:	e486                	sd	ra,72(sp)
    800026c4:	e0a2                	sd	s0,64(sp)
    800026c6:	fc26                	sd	s1,56(sp)
    800026c8:	f84a                	sd	s2,48(sp)
    800026ca:	f44e                	sd	s3,40(sp)
    800026cc:	f052                	sd	s4,32(sp)
    800026ce:	ec56                	sd	s5,24(sp)
    800026d0:	e85a                	sd	s6,16(sp)
    800026d2:	e45e                	sd	s7,8(sp)
    800026d4:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800026d6:	00006517          	auipc	a0,0x6
    800026da:	9f250513          	addi	a0,a0,-1550 # 800080c8 <digits+0x88>
    800026de:	ffffe097          	auipc	ra,0xffffe
    800026e2:	eaa080e7          	jalr	-342(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026e6:	0000f497          	auipc	s1,0xf
    800026ea:	a7a48493          	addi	s1,s1,-1414 # 80011160 <proc+0x180>
    800026ee:	00016917          	auipc	s2,0x16
    800026f2:	a7290913          	addi	s2,s2,-1422 # 80018160 <bcache+0x168>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026f6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026f8:	00006997          	auipc	s3,0x6
    800026fc:	b8898993          	addi	s3,s3,-1144 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80002700:	00006a97          	auipc	s5,0x6
    80002704:	b88a8a93          	addi	s5,s5,-1144 # 80008288 <digits+0x248>
    printf("\n");
    80002708:	00006a17          	auipc	s4,0x6
    8000270c:	9c0a0a13          	addi	s4,s4,-1600 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002710:	00006b97          	auipc	s7,0x6
    80002714:	be8b8b93          	addi	s7,s7,-1048 # 800082f8 <states.0>
    80002718:	a00d                	j	8000273a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    8000271a:	eb06a583          	lw	a1,-336(a3)
    8000271e:	8556                	mv	a0,s5
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	e68080e7          	jalr	-408(ra) # 80000588 <printf>
    printf("\n");
    80002728:	8552                	mv	a0,s4
    8000272a:	ffffe097          	auipc	ra,0xffffe
    8000272e:	e5e080e7          	jalr	-418(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002732:	1c048493          	addi	s1,s1,448
    80002736:	03248163          	beq	s1,s2,80002758 <procdump+0x98>
    if(p->state == UNUSED)
    8000273a:	86a6                	mv	a3,s1
    8000273c:	e984a783          	lw	a5,-360(s1)
    80002740:	dbed                	beqz	a5,80002732 <procdump+0x72>
      state = "???";
    80002742:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002744:	fcfb6be3          	bltu	s6,a5,8000271a <procdump+0x5a>
    80002748:	1782                	slli	a5,a5,0x20
    8000274a:	9381                	srli	a5,a5,0x20
    8000274c:	078e                	slli	a5,a5,0x3
    8000274e:	97de                	add	a5,a5,s7
    80002750:	6390                	ld	a2,0(a5)
    80002752:	f661                	bnez	a2,8000271a <procdump+0x5a>
      state = "???";
    80002754:	864e                	mv	a2,s3
    80002756:	b7d1                	j	8000271a <procdump+0x5a>
  }
}
    80002758:	60a6                	ld	ra,72(sp)
    8000275a:	6406                	ld	s0,64(sp)
    8000275c:	74e2                	ld	s1,56(sp)
    8000275e:	7942                	ld	s2,48(sp)
    80002760:	79a2                	ld	s3,40(sp)
    80002762:	7a02                	ld	s4,32(sp)
    80002764:	6ae2                	ld	s5,24(sp)
    80002766:	6b42                	ld	s6,16(sp)
    80002768:	6ba2                	ld	s7,8(sp)
    8000276a:	6161                	addi	sp,sp,80
    8000276c:	8082                	ret

000000008000276e <set_ps_priority>:


int
set_ps_priority(int new_ps)
{
    8000276e:	1101                	addi	sp,sp,-32
    80002770:	ec06                	sd	ra,24(sp)
    80002772:	e822                	sd	s0,16(sp)
    80002774:	e426                	sd	s1,8(sp)
    80002776:	1000                	addi	s0,sp,32
    80002778:	84aa                	mv	s1,a0
  struct proc *p = myproc(); 
    8000277a:	fffff097          	auipc	ra,0xfffff
    8000277e:	232080e7          	jalr	562(ra) # 800019ac <myproc>
  p->ps_priority = new_ps;
    80002782:	18952823          	sw	s1,400(a0)
   
  return 0;
}
    80002786:	4501                	li	a0,0
    80002788:	60e2                	ld	ra,24(sp)
    8000278a:	6442                	ld	s0,16(sp)
    8000278c:	64a2                	ld	s1,8(sp)
    8000278e:	6105                	addi	sp,sp,32
    80002790:	8082                	ret

0000000080002792 <set_cfs_priority>:

// task6
int
set_cfs_priority(int new_cfs)
{
    80002792:	1101                	addi	sp,sp,-32
    80002794:	ec06                	sd	ra,24(sp)
    80002796:	e822                	sd	s0,16(sp)
    80002798:	e426                	sd	s1,8(sp)
    8000279a:	1000                	addi	s0,sp,32
    8000279c:	84aa                	mv	s1,a0
  struct proc *p = myproc(); 
    8000279e:	fffff097          	auipc	ra,0xfffff
    800027a2:	20e080e7          	jalr	526(ra) # 800019ac <myproc>
  if(new_cfs==0){
    800027a6:	c08d                	beqz	s1,800027c8 <set_cfs_priority+0x36>
    p->cfs_priority=75;
    return 0;
  }

  if(new_cfs==1){
    800027a8:	4785                	li	a5,1
    800027aa:	02f48563          	beq	s1,a5,800027d4 <set_cfs_priority+0x42>
    p->cfs_priority=100;
    return 0;
  }

  if(new_cfs==2){
    800027ae:	4789                	li	a5,2
    800027b0:	02f49863          	bne	s1,a5,800027e0 <set_cfs_priority+0x4e>
    p->cfs_priority=125;
    800027b4:	07d00793          	li	a5,125
    800027b8:	18f52a23          	sw	a5,404(a0)
    return 0;
    800027bc:	4501                	li	a0,0
  }
   
  return -1;
}
    800027be:	60e2                	ld	ra,24(sp)
    800027c0:	6442                	ld	s0,16(sp)
    800027c2:	64a2                	ld	s1,8(sp)
    800027c4:	6105                	addi	sp,sp,32
    800027c6:	8082                	ret
    p->cfs_priority=75;
    800027c8:	04b00793          	li	a5,75
    800027cc:	18f52a23          	sw	a5,404(a0)
    return 0;
    800027d0:	8526                	mv	a0,s1
    800027d2:	b7f5                	j	800027be <set_cfs_priority+0x2c>
    p->cfs_priority=100;
    800027d4:	06400793          	li	a5,100
    800027d8:	18f52a23          	sw	a5,404(a0)
    return 0;
    800027dc:	4501                	li	a0,0
    800027de:	b7c5                	j	800027be <set_cfs_priority+0x2c>
  return -1;
    800027e0:	557d                	li	a0,-1
    800027e2:	bff1                	j	800027be <set_cfs_priority+0x2c>

00000000800027e4 <get_cfs_stats>:

char*
get_cfs_stats(int pid)
{
    800027e4:	715d                	addi	sp,sp,-80
    800027e6:	e486                	sd	ra,72(sp)
    800027e8:	e0a2                	sd	s0,64(sp)
    800027ea:	fc26                	sd	s1,56(sp)
    800027ec:	f84a                	sd	s2,48(sp)
    800027ee:	f44e                	sd	s3,40(sp)
    800027f0:	0880                	addi	s0,sp,80
    800027f2:	892a                	mv	s2,a0
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++) {
    800027f4:	0000e497          	auipc	s1,0xe
    800027f8:	7ec48493          	addi	s1,s1,2028 # 80010fe0 <proc>
    800027fc:	00015997          	auipc	s3,0x15
    80002800:	7e498993          	addi	s3,s3,2020 # 80017fe0 <tickslock>
    acquire(&p->lock);
    80002804:	8526                	mv	a0,s1
    80002806:	ffffe097          	auipc	ra,0xffffe
    8000280a:	3d0080e7          	jalr	976(ra) # 80000bd6 <acquire>
    if (p->pid == pid) {
    8000280e:	589c                	lw	a5,48(s1)
    80002810:	03278063          	beq	a5,s2,80002830 <get_cfs_stats+0x4c>
      stats += sizeof(uint64);
      either_copyin(stats, 0, (uint64)&retime, sizeof(uint64));
      release(&p->lock);
      return stats - (sizeof(int) + 3 * sizeof(uint64));
    }
    release(&p->lock);
    80002814:	8526                	mv	a0,s1
    80002816:	ffffe097          	auipc	ra,0xffffe
    8000281a:	474080e7          	jalr	1140(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000281e:	1c048493          	addi	s1,s1,448
    80002822:	ff3491e3          	bne	s1,s3,80002804 <get_cfs_stats+0x20>
  }
  return "Error: No such process.";
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	a8a50513          	addi	a0,a0,-1398 # 800082b0 <digits+0x270>
    8000282e:	a061                	j	800028b6 <get_cfs_stats+0xd2>
      char* stats = (char*)kalloc();
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	2b6080e7          	jalr	694(ra) # 80000ae6 <kalloc>
    80002838:	892a                	mv	s2,a0
      if (!stats) {
    8000283a:	c549                	beqz	a0,800028c4 <get_cfs_stats+0xe0>
      int cfs_priority = p->cfs_priority;
    8000283c:	1944a783          	lw	a5,404(s1)
    80002840:	faf42a23          	sw	a5,-76(s0)
      uint64 rtime = p->rtime;
    80002844:	1984b783          	ld	a5,408(s1)
    80002848:	faf43c23          	sd	a5,-72(s0)
      uint64 stime = p->stime;
    8000284c:	1a04b783          	ld	a5,416(s1)
    80002850:	fcf43023          	sd	a5,-64(s0)
      uint64 retime = p->retime;
    80002854:	1a84b783          	ld	a5,424(s1)
    80002858:	fcf43423          	sd	a5,-56(s0)
      either_copyin(stats, 0, (uint64)&cfs_priority, sizeof(int));
    8000285c:	4691                	li	a3,4
    8000285e:	fb440613          	addi	a2,s0,-76
    80002862:	4581                	li	a1,0
    80002864:	00000097          	auipc	ra,0x0
    80002868:	e06080e7          	jalr	-506(ra) # 8000266a <either_copyin>
      either_copyin(stats, 0, (uint64)&rtime, sizeof(uint64));
    8000286c:	46a1                	li	a3,8
    8000286e:	fb840613          	addi	a2,s0,-72
    80002872:	4581                	li	a1,0
    80002874:	00490513          	addi	a0,s2,4
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	df2080e7          	jalr	-526(ra) # 8000266a <either_copyin>
      either_copyin(stats, 0, (uint64)&stime, sizeof(uint64));
    80002880:	46a1                	li	a3,8
    80002882:	fc040613          	addi	a2,s0,-64
    80002886:	4581                	li	a1,0
    80002888:	00c90513          	addi	a0,s2,12
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	dde080e7          	jalr	-546(ra) # 8000266a <either_copyin>
      either_copyin(stats, 0, (uint64)&retime, sizeof(uint64));
    80002894:	46a1                	li	a3,8
    80002896:	fc840613          	addi	a2,s0,-56
    8000289a:	4581                	li	a1,0
    8000289c:	01490513          	addi	a0,s2,20
    800028a0:	00000097          	auipc	ra,0x0
    800028a4:	dca080e7          	jalr	-566(ra) # 8000266a <either_copyin>
      release(&p->lock);
    800028a8:	8526                	mv	a0,s1
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	3e0080e7          	jalr	992(ra) # 80000c8a <release>
      return stats - (sizeof(int) + 3 * sizeof(uint64));
    800028b2:	ff890513          	addi	a0,s2,-8
}
    800028b6:	60a6                	ld	ra,72(sp)
    800028b8:	6406                	ld	s0,64(sp)
    800028ba:	74e2                	ld	s1,56(sp)
    800028bc:	7942                	ld	s2,48(sp)
    800028be:	79a2                	ld	s3,40(sp)
    800028c0:	6161                	addi	sp,sp,80
    800028c2:	8082                	ret
        release(&p->lock);
    800028c4:	8526                	mv	a0,s1
    800028c6:	ffffe097          	auipc	ra,0xffffe
    800028ca:	3c4080e7          	jalr	964(ra) # 80000c8a <release>
        return "Error: Out of memory.";
    800028ce:	00006517          	auipc	a0,0x6
    800028d2:	9ca50513          	addi	a0,a0,-1590 # 80008298 <digits+0x258>
    800028d6:	b7c5                	j	800028b6 <get_cfs_stats+0xd2>

00000000800028d8 <update_cfs_vars>:


void
update_cfs_vars(void){
    800028d8:	1141                	addi	sp,sp,-16
    800028da:	e406                	sd	ra,8(sp)
    800028dc:	e022                	sd	s0,0(sp)
    800028de:	0800                	addi	s0,sp,16
  ///////////////////////////
  //update run time
  struct proc *p= myproc();
    800028e0:	fffff097          	auipc	ra,0xfffff
    800028e4:	0cc080e7          	jalr	204(ra) # 800019ac <myproc>
  if(p!=0 && p->state ==RUNNING){
    800028e8:	c509                	beqz	a0,800028f2 <update_cfs_vars+0x1a>
    800028ea:	4d18                	lw	a4,24(a0)
    800028ec:	4791                	li	a5,4
    800028ee:	00f70c63          	beq	a4,a5,80002906 <update_cfs_vars+0x2e>
update_cfs_vars(void){
    800028f2:	0000e797          	auipc	a5,0xe
    800028f6:	6ee78793          	addi	a5,a5,1774 # 80010fe0 <proc>
    p->rtime++;
    p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
  }
  //update sleep time
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == SLEEPING){
    800028fa:	4589                	li	a1,2
  for(p = proc; p < &proc[NPROC]; p++){
    800028fc:	00015617          	auipc	a2,0x15
    80002900:	6e460613          	addi	a2,a2,1764 # 80017fe0 <tickslock>
    80002904:	a80d                	j	80002936 <update_cfs_vars+0x5e>
    p->rtime++;
    80002906:	19853783          	ld	a5,408(a0)
    8000290a:	0785                	addi	a5,a5,1
    8000290c:	18f53c23          	sd	a5,408(a0)
    p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    80002910:	1a053703          	ld	a4,416(a0)
    80002914:	973e                	add	a4,a4,a5
    80002916:	1a853683          	ld	a3,424(a0)
    8000291a:	9736                	add	a4,a4,a3
    8000291c:	02e7c7b3          	div	a5,a5,a4
    80002920:	19452703          	lw	a4,404(a0)
    80002924:	02e787b3          	mul	a5,a5,a4
    80002928:	1af53823          	sd	a5,432(a0)
    8000292c:	b7d9                	j	800028f2 <update_cfs_vars+0x1a>
  for(p = proc; p < &proc[NPROC]; p++){
    8000292e:	1c078793          	addi	a5,a5,448
    80002932:	02c78963          	beq	a5,a2,80002964 <update_cfs_vars+0x8c>
    if(p->state == SLEEPING){
    80002936:	4f98                	lw	a4,24(a5)
    80002938:	feb71be3          	bne	a4,a1,8000292e <update_cfs_vars+0x56>
      p->stime++;
    8000293c:	1a07b703          	ld	a4,416(a5)
    80002940:	0705                	addi	a4,a4,1
    80002942:	1ae7b023          	sd	a4,416(a5)
      p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    80002946:	1987b683          	ld	a3,408(a5)
    8000294a:	9736                	add	a4,a4,a3
    8000294c:	1a87b503          	ld	a0,424(a5)
    80002950:	972a                	add	a4,a4,a0
    80002952:	02e6c733          	div	a4,a3,a4
    80002956:	1947a683          	lw	a3,404(a5)
    8000295a:	02d70733          	mul	a4,a4,a3
    8000295e:	1ae7b823          	sd	a4,432(a5)
    80002962:	b7f1                	j	8000292e <update_cfs_vars+0x56>
    }
  }
  //update ready time
  for(p = proc; p < &proc[NPROC]; p++){
    80002964:	0000e797          	auipc	a5,0xe
    80002968:	67c78793          	addi	a5,a5,1660 # 80010fe0 <proc>
    if(p->state == RUNNABLE){
    8000296c:	450d                	li	a0,3
  for(p = proc; p < &proc[NPROC]; p++){
    8000296e:	00015597          	auipc	a1,0x15
    80002972:	67258593          	addi	a1,a1,1650 # 80017fe0 <tickslock>
    80002976:	a029                	j	80002980 <update_cfs_vars+0xa8>
    80002978:	1c078793          	addi	a5,a5,448
    8000297c:	02b78a63          	beq	a5,a1,800029b0 <update_cfs_vars+0xd8>
    if(p->state == RUNNABLE){
    80002980:	4f98                	lw	a4,24(a5)
    80002982:	fea71be3          	bne	a4,a0,80002978 <update_cfs_vars+0xa0>
      p->retime++;
    80002986:	1a87b683          	ld	a3,424(a5)
    8000298a:	00168613          	addi	a2,a3,1
    8000298e:	1ac7b423          	sd	a2,424(a5)
      p->vruntime= p->cfs_priority*(p->rtime/(p->rtime + p->stime+p->retime));
    80002992:	1987b703          	ld	a4,408(a5)
    80002996:	1a07b683          	ld	a3,416(a5)
    8000299a:	96ba                	add	a3,a3,a4
    8000299c:	96b2                	add	a3,a3,a2
    8000299e:	02d74733          	div	a4,a4,a3
    800029a2:	1947a683          	lw	a3,404(a5)
    800029a6:	02d70733          	mul	a4,a4,a3
    800029aa:	1ae7b823          	sd	a4,432(a5)
    800029ae:	b7e9                	j	80002978 <update_cfs_vars+0xa0>
    }
  }
  
  ///////////////////////////
}
    800029b0:	60a2                	ld	ra,8(sp)
    800029b2:	6402                	ld	s0,0(sp)
    800029b4:	0141                	addi	sp,sp,16
    800029b6:	8082                	ret

00000000800029b8 <swtch>:
    800029b8:	00153023          	sd	ra,0(a0)
    800029bc:	00253423          	sd	sp,8(a0)
    800029c0:	e900                	sd	s0,16(a0)
    800029c2:	ed04                	sd	s1,24(a0)
    800029c4:	03253023          	sd	s2,32(a0)
    800029c8:	03353423          	sd	s3,40(a0)
    800029cc:	03453823          	sd	s4,48(a0)
    800029d0:	03553c23          	sd	s5,56(a0)
    800029d4:	05653023          	sd	s6,64(a0)
    800029d8:	05753423          	sd	s7,72(a0)
    800029dc:	05853823          	sd	s8,80(a0)
    800029e0:	05953c23          	sd	s9,88(a0)
    800029e4:	07a53023          	sd	s10,96(a0)
    800029e8:	07b53423          	sd	s11,104(a0)
    800029ec:	0005b083          	ld	ra,0(a1)
    800029f0:	0085b103          	ld	sp,8(a1)
    800029f4:	6980                	ld	s0,16(a1)
    800029f6:	6d84                	ld	s1,24(a1)
    800029f8:	0205b903          	ld	s2,32(a1)
    800029fc:	0285b983          	ld	s3,40(a1)
    80002a00:	0305ba03          	ld	s4,48(a1)
    80002a04:	0385ba83          	ld	s5,56(a1)
    80002a08:	0405bb03          	ld	s6,64(a1)
    80002a0c:	0485bb83          	ld	s7,72(a1)
    80002a10:	0505bc03          	ld	s8,80(a1)
    80002a14:	0585bc83          	ld	s9,88(a1)
    80002a18:	0605bd03          	ld	s10,96(a1)
    80002a1c:	0685bd83          	ld	s11,104(a1)
    80002a20:	8082                	ret

0000000080002a22 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002a22:	1141                	addi	sp,sp,-16
    80002a24:	e406                	sd	ra,8(sp)
    80002a26:	e022                	sd	s0,0(sp)
    80002a28:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002a2a:	00006597          	auipc	a1,0x6
    80002a2e:	8fe58593          	addi	a1,a1,-1794 # 80008328 <states.0+0x30>
    80002a32:	00015517          	auipc	a0,0x15
    80002a36:	5ae50513          	addi	a0,a0,1454 # 80017fe0 <tickslock>
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	10c080e7          	jalr	268(ra) # 80000b46 <initlock>
}
    80002a42:	60a2                	ld	ra,8(sp)
    80002a44:	6402                	ld	s0,0(sp)
    80002a46:	0141                	addi	sp,sp,16
    80002a48:	8082                	ret

0000000080002a4a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002a4a:	1141                	addi	sp,sp,-16
    80002a4c:	e422                	sd	s0,8(sp)
    80002a4e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a50:	00003797          	auipc	a5,0x3
    80002a54:	5a078793          	addi	a5,a5,1440 # 80005ff0 <kernelvec>
    80002a58:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002a5c:	6422                	ld	s0,8(sp)
    80002a5e:	0141                	addi	sp,sp,16
    80002a60:	8082                	ret

0000000080002a62 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002a62:	1141                	addi	sp,sp,-16
    80002a64:	e406                	sd	ra,8(sp)
    80002a66:	e022                	sd	s0,0(sp)
    80002a68:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002a6a:	fffff097          	auipc	ra,0xfffff
    80002a6e:	f42080e7          	jalr	-190(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002a76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a78:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002a7c:	00004617          	auipc	a2,0x4
    80002a80:	58460613          	addi	a2,a2,1412 # 80007000 <_trampoline>
    80002a84:	00004697          	auipc	a3,0x4
    80002a88:	57c68693          	addi	a3,a3,1404 # 80007000 <_trampoline>
    80002a8c:	8e91                	sub	a3,a3,a2
    80002a8e:	040007b7          	lui	a5,0x4000
    80002a92:	17fd                	addi	a5,a5,-1
    80002a94:	07b2                	slli	a5,a5,0xc
    80002a96:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002a98:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002a9c:	6158                	ld	a4,128(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002a9e:	180026f3          	csrr	a3,satp
    80002aa2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002aa4:	6158                	ld	a4,128(a0)
    80002aa6:	7534                	ld	a3,104(a0)
    80002aa8:	6585                	lui	a1,0x1
    80002aaa:	96ae                	add	a3,a3,a1
    80002aac:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002aae:	6158                	ld	a4,128(a0)
    80002ab0:	00000697          	auipc	a3,0x0
    80002ab4:	13e68693          	addi	a3,a3,318 # 80002bee <usertrap>
    80002ab8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002aba:	6158                	ld	a4,128(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002abc:	8692                	mv	a3,tp
    80002abe:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ac0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ac4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ac8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002acc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002ad0:	6158                	ld	a4,128(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ad2:	6f18                	ld	a4,24(a4)
    80002ad4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002ad8:	7d28                	ld	a0,120(a0)
    80002ada:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002adc:	00004717          	auipc	a4,0x4
    80002ae0:	5c070713          	addi	a4,a4,1472 # 8000709c <userret>
    80002ae4:	8f11                	sub	a4,a4,a2
    80002ae6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ae8:	577d                	li	a4,-1
    80002aea:	177e                	slli	a4,a4,0x3f
    80002aec:	8d59                	or	a0,a0,a4
    80002aee:	9782                	jalr	a5
}
    80002af0:	60a2                	ld	ra,8(sp)
    80002af2:	6402                	ld	s0,0(sp)
    80002af4:	0141                	addi	sp,sp,16
    80002af6:	8082                	ret

0000000080002af8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002af8:	1101                	addi	sp,sp,-32
    80002afa:	ec06                	sd	ra,24(sp)
    80002afc:	e822                	sd	s0,16(sp)
    80002afe:	e426                	sd	s1,8(sp)
    80002b00:	e04a                	sd	s2,0(sp)
    80002b02:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002b04:	00015917          	auipc	s2,0x15
    80002b08:	4dc90913          	addi	s2,s2,1244 # 80017fe0 <tickslock>
    80002b0c:	854a                	mv	a0,s2
    80002b0e:	ffffe097          	auipc	ra,0xffffe
    80002b12:	0c8080e7          	jalr	200(ra) # 80000bd6 <acquire>
  ticks++;
    80002b16:	00006497          	auipc	s1,0x6
    80002b1a:	e2a48493          	addi	s1,s1,-470 # 80008940 <ticks>
    80002b1e:	409c                	lw	a5,0(s1)
    80002b20:	2785                	addiw	a5,a5,1
    80002b22:	c09c                	sw	a5,0(s1)

  update_cfs_vars();
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	db4080e7          	jalr	-588(ra) # 800028d8 <update_cfs_vars>

  wakeup(&ticks);
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	fffff097          	auipc	ra,0xfffff
    80002b32:	680080e7          	jalr	1664(ra) # 800021ae <wakeup>
  release(&tickslock);
    80002b36:	854a                	mv	a0,s2
    80002b38:	ffffe097          	auipc	ra,0xffffe
    80002b3c:	152080e7          	jalr	338(ra) # 80000c8a <release>
}
    80002b40:	60e2                	ld	ra,24(sp)
    80002b42:	6442                	ld	s0,16(sp)
    80002b44:	64a2                	ld	s1,8(sp)
    80002b46:	6902                	ld	s2,0(sp)
    80002b48:	6105                	addi	sp,sp,32
    80002b4a:	8082                	ret

0000000080002b4c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002b4c:	1101                	addi	sp,sp,-32
    80002b4e:	ec06                	sd	ra,24(sp)
    80002b50:	e822                	sd	s0,16(sp)
    80002b52:	e426                	sd	s1,8(sp)
    80002b54:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b56:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002b5a:	00074d63          	bltz	a4,80002b74 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002b5e:	57fd                	li	a5,-1
    80002b60:	17fe                	slli	a5,a5,0x3f
    80002b62:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002b64:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002b66:	06f70363          	beq	a4,a5,80002bcc <devintr+0x80>
  }
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6105                	addi	sp,sp,32
    80002b72:	8082                	ret
     (scause & 0xff) == 9){
    80002b74:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002b78:	46a5                	li	a3,9
    80002b7a:	fed792e3          	bne	a5,a3,80002b5e <devintr+0x12>
    int irq = plic_claim();
    80002b7e:	00003097          	auipc	ra,0x3
    80002b82:	57a080e7          	jalr	1402(ra) # 800060f8 <plic_claim>
    80002b86:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002b88:	47a9                	li	a5,10
    80002b8a:	02f50763          	beq	a0,a5,80002bb8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002b8e:	4785                	li	a5,1
    80002b90:	02f50963          	beq	a0,a5,80002bc2 <devintr+0x76>
    return 1;
    80002b94:	4505                	li	a0,1
    } else if(irq){
    80002b96:	d8f1                	beqz	s1,80002b6a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002b98:	85a6                	mv	a1,s1
    80002b9a:	00005517          	auipc	a0,0x5
    80002b9e:	79650513          	addi	a0,a0,1942 # 80008330 <states.0+0x38>
    80002ba2:	ffffe097          	auipc	ra,0xffffe
    80002ba6:	9e6080e7          	jalr	-1562(ra) # 80000588 <printf>
      plic_complete(irq);
    80002baa:	8526                	mv	a0,s1
    80002bac:	00003097          	auipc	ra,0x3
    80002bb0:	570080e7          	jalr	1392(ra) # 8000611c <plic_complete>
    return 1;
    80002bb4:	4505                	li	a0,1
    80002bb6:	bf55                	j	80002b6a <devintr+0x1e>
      uartintr();
    80002bb8:	ffffe097          	auipc	ra,0xffffe
    80002bbc:	de2080e7          	jalr	-542(ra) # 8000099a <uartintr>
    80002bc0:	b7ed                	j	80002baa <devintr+0x5e>
      virtio_disk_intr();
    80002bc2:	00004097          	auipc	ra,0x4
    80002bc6:	a26080e7          	jalr	-1498(ra) # 800065e8 <virtio_disk_intr>
    80002bca:	b7c5                	j	80002baa <devintr+0x5e>
    if(cpuid() == 0){
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	db4080e7          	jalr	-588(ra) # 80001980 <cpuid>
    80002bd4:	c901                	beqz	a0,80002be4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002bd6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002bda:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002bdc:	14479073          	csrw	sip,a5
    return 2;
    80002be0:	4509                	li	a0,2
    80002be2:	b761                	j	80002b6a <devintr+0x1e>
      clockintr();
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	f14080e7          	jalr	-236(ra) # 80002af8 <clockintr>
    80002bec:	b7ed                	j	80002bd6 <devintr+0x8a>

0000000080002bee <usertrap>:
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002bfa:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002bfe:	1007f793          	andi	a5,a5,256
    80002c02:	e3b1                	bnez	a5,80002c46 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c04:	00003797          	auipc	a5,0x3
    80002c08:	3ec78793          	addi	a5,a5,1004 # 80005ff0 <kernelvec>
    80002c0c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c10:	fffff097          	auipc	ra,0xfffff
    80002c14:	d9c080e7          	jalr	-612(ra) # 800019ac <myproc>
    80002c18:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c1a:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002c1c:	14102773          	csrr	a4,sepc
    80002c20:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c22:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002c26:	47a1                	li	a5,8
    80002c28:	02f70763          	beq	a4,a5,80002c56 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	f20080e7          	jalr	-224(ra) # 80002b4c <devintr>
    80002c34:	892a                	mv	s2,a0
    80002c36:	c951                	beqz	a0,80002cca <usertrap+0xdc>
  if(killed(p))
    80002c38:	8526                	mv	a0,s1
    80002c3a:	00000097          	auipc	ra,0x0
    80002c3e:	838080e7          	jalr	-1992(ra) # 80002472 <killed>
    80002c42:	cd29                	beqz	a0,80002c9c <usertrap+0xae>
    80002c44:	a099                	j	80002c8a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002c46:	00005517          	auipc	a0,0x5
    80002c4a:	70a50513          	addi	a0,a0,1802 # 80008350 <states.0+0x58>
    80002c4e:	ffffe097          	auipc	ra,0xffffe
    80002c52:	8f0080e7          	jalr	-1808(ra) # 8000053e <panic>
    if(killed(p))
    80002c56:	00000097          	auipc	ra,0x0
    80002c5a:	81c080e7          	jalr	-2020(ra) # 80002472 <killed>
    80002c5e:	ed21                	bnez	a0,80002cb6 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002c60:	60d8                	ld	a4,128(s1)
    80002c62:	6f1c                	ld	a5,24(a4)
    80002c64:	0791                	addi	a5,a5,4
    80002c66:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002c6c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c70:	10079073          	csrw	sstatus,a5
    syscall();
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	2e4080e7          	jalr	740(ra) # 80002f58 <syscall>
  if(killed(p))
    80002c7c:	8526                	mv	a0,s1
    80002c7e:	fffff097          	auipc	ra,0xfffff
    80002c82:	7f4080e7          	jalr	2036(ra) # 80002472 <killed>
    80002c86:	cd11                	beqz	a0,80002ca2 <usertrap+0xb4>
    80002c88:	4901                	li	s2,0
    exit(-1, "killed");
    80002c8a:	00005597          	auipc	a1,0x5
    80002c8e:	73e58593          	addi	a1,a1,1854 # 800083c8 <states.0+0xd0>
    80002c92:	557d                	li	a0,-1
    80002c94:	fffff097          	auipc	ra,0xfffff
    80002c98:	654080e7          	jalr	1620(ra) # 800022e8 <exit>
  if(which_dev == 2)
    80002c9c:	4789                	li	a5,2
    80002c9e:	06f90363          	beq	s2,a5,80002d04 <usertrap+0x116>
  usertrapret();
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	dc0080e7          	jalr	-576(ra) # 80002a62 <usertrapret>
}
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	64a2                	ld	s1,8(sp)
    80002cb0:	6902                	ld	s2,0(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret
      exit(-1 , "killed ");
    80002cb6:	00005597          	auipc	a1,0x5
    80002cba:	6ba58593          	addi	a1,a1,1722 # 80008370 <states.0+0x78>
    80002cbe:	557d                	li	a0,-1
    80002cc0:	fffff097          	auipc	ra,0xfffff
    80002cc4:	628080e7          	jalr	1576(ra) # 800022e8 <exit>
    80002cc8:	bf61                	j	80002c60 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cca:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002cce:	5890                	lw	a2,48(s1)
    80002cd0:	00005517          	auipc	a0,0x5
    80002cd4:	6a850513          	addi	a0,a0,1704 # 80008378 <states.0+0x80>
    80002cd8:	ffffe097          	auipc	ra,0xffffe
    80002cdc:	8b0080e7          	jalr	-1872(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ce0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ce4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	6c050513          	addi	a0,a0,1728 # 800083a8 <states.0+0xb0>
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	898080e7          	jalr	-1896(ra) # 80000588 <printf>
    setkilled(p);
    80002cf8:	8526                	mv	a0,s1
    80002cfa:	fffff097          	auipc	ra,0xfffff
    80002cfe:	74c080e7          	jalr	1868(ra) # 80002446 <setkilled>
    80002d02:	bfad                	j	80002c7c <usertrap+0x8e>
    yield();
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	40a080e7          	jalr	1034(ra) # 8000210e <yield>
    80002d0c:	bf59                	j	80002ca2 <usertrap+0xb4>

0000000080002d0e <kerneltrap>:
{
    80002d0e:	7179                	addi	sp,sp,-48
    80002d10:	f406                	sd	ra,40(sp)
    80002d12:	f022                	sd	s0,32(sp)
    80002d14:	ec26                	sd	s1,24(sp)
    80002d16:	e84a                	sd	s2,16(sp)
    80002d18:	e44e                	sd	s3,8(sp)
    80002d1a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d1c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d20:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d24:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002d28:	1004f793          	andi	a5,s1,256
    80002d2c:	cb85                	beqz	a5,80002d5c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002d32:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002d34:	ef85                	bnez	a5,80002d6c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002d36:	00000097          	auipc	ra,0x0
    80002d3a:	e16080e7          	jalr	-490(ra) # 80002b4c <devintr>
    80002d3e:	cd1d                	beqz	a0,80002d7c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002d40:	4789                	li	a5,2
    80002d42:	06f50a63          	beq	a0,a5,80002db6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002d46:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d4a:	10049073          	csrw	sstatus,s1
}
    80002d4e:	70a2                	ld	ra,40(sp)
    80002d50:	7402                	ld	s0,32(sp)
    80002d52:	64e2                	ld	s1,24(sp)
    80002d54:	6942                	ld	s2,16(sp)
    80002d56:	69a2                	ld	s3,8(sp)
    80002d58:	6145                	addi	sp,sp,48
    80002d5a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002d5c:	00005517          	auipc	a0,0x5
    80002d60:	67450513          	addi	a0,a0,1652 # 800083d0 <states.0+0xd8>
    80002d64:	ffffd097          	auipc	ra,0xffffd
    80002d68:	7da080e7          	jalr	2010(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002d6c:	00005517          	auipc	a0,0x5
    80002d70:	68c50513          	addi	a0,a0,1676 # 800083f8 <states.0+0x100>
    80002d74:	ffffd097          	auipc	ra,0xffffd
    80002d78:	7ca080e7          	jalr	1994(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002d7c:	85ce                	mv	a1,s3
    80002d7e:	00005517          	auipc	a0,0x5
    80002d82:	69a50513          	addi	a0,a0,1690 # 80008418 <states.0+0x120>
    80002d86:	ffffe097          	auipc	ra,0xffffe
    80002d8a:	802080e7          	jalr	-2046(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d8e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d92:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002d96:	00005517          	auipc	a0,0x5
    80002d9a:	69250513          	addi	a0,a0,1682 # 80008428 <states.0+0x130>
    80002d9e:	ffffd097          	auipc	ra,0xffffd
    80002da2:	7ea080e7          	jalr	2026(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002da6:	00005517          	auipc	a0,0x5
    80002daa:	69a50513          	addi	a0,a0,1690 # 80008440 <states.0+0x148>
    80002dae:	ffffd097          	auipc	ra,0xffffd
    80002db2:	790080e7          	jalr	1936(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	bf6080e7          	jalr	-1034(ra) # 800019ac <myproc>
    80002dbe:	d541                	beqz	a0,80002d46 <kerneltrap+0x38>
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	bec080e7          	jalr	-1044(ra) # 800019ac <myproc>
    80002dc8:	4d18                	lw	a4,24(a0)
    80002dca:	4791                	li	a5,4
    80002dcc:	f6f71de3          	bne	a4,a5,80002d46 <kerneltrap+0x38>
    yield();
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	33e080e7          	jalr	830(ra) # 8000210e <yield>
    80002dd8:	b7bd                	j	80002d46 <kerneltrap+0x38>

0000000080002dda <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	1000                	addi	s0,sp,32
    80002de4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	bc6080e7          	jalr	-1082(ra) # 800019ac <myproc>
  switch (n) {
    80002dee:	4795                	li	a5,5
    80002df0:	0497e163          	bltu	a5,s1,80002e32 <argraw+0x58>
    80002df4:	048a                	slli	s1,s1,0x2
    80002df6:	00005717          	auipc	a4,0x5
    80002dfa:	68270713          	addi	a4,a4,1666 # 80008478 <states.0+0x180>
    80002dfe:	94ba                	add	s1,s1,a4
    80002e00:	409c                	lw	a5,0(s1)
    80002e02:	97ba                	add	a5,a5,a4
    80002e04:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e06:	615c                	ld	a5,128(a0)
    80002e08:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e0a:	60e2                	ld	ra,24(sp)
    80002e0c:	6442                	ld	s0,16(sp)
    80002e0e:	64a2                	ld	s1,8(sp)
    80002e10:	6105                	addi	sp,sp,32
    80002e12:	8082                	ret
    return p->trapframe->a1;
    80002e14:	615c                	ld	a5,128(a0)
    80002e16:	7fa8                	ld	a0,120(a5)
    80002e18:	bfcd                	j	80002e0a <argraw+0x30>
    return p->trapframe->a2;
    80002e1a:	615c                	ld	a5,128(a0)
    80002e1c:	63c8                	ld	a0,128(a5)
    80002e1e:	b7f5                	j	80002e0a <argraw+0x30>
    return p->trapframe->a3;
    80002e20:	615c                	ld	a5,128(a0)
    80002e22:	67c8                	ld	a0,136(a5)
    80002e24:	b7dd                	j	80002e0a <argraw+0x30>
    return p->trapframe->a4;
    80002e26:	615c                	ld	a5,128(a0)
    80002e28:	6bc8                	ld	a0,144(a5)
    80002e2a:	b7c5                	j	80002e0a <argraw+0x30>
    return p->trapframe->a5;
    80002e2c:	615c                	ld	a5,128(a0)
    80002e2e:	6fc8                	ld	a0,152(a5)
    80002e30:	bfe9                	j	80002e0a <argraw+0x30>
  panic("argraw");
    80002e32:	00005517          	auipc	a0,0x5
    80002e36:	61e50513          	addi	a0,a0,1566 # 80008450 <states.0+0x158>
    80002e3a:	ffffd097          	auipc	ra,0xffffd
    80002e3e:	704080e7          	jalr	1796(ra) # 8000053e <panic>

0000000080002e42 <fetchaddr>:
{
    80002e42:	1101                	addi	sp,sp,-32
    80002e44:	ec06                	sd	ra,24(sp)
    80002e46:	e822                	sd	s0,16(sp)
    80002e48:	e426                	sd	s1,8(sp)
    80002e4a:	e04a                	sd	s2,0(sp)
    80002e4c:	1000                	addi	s0,sp,32
    80002e4e:	84aa                	mv	s1,a0
    80002e50:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002e52:	fffff097          	auipc	ra,0xfffff
    80002e56:	b5a080e7          	jalr	-1190(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002e5a:	793c                	ld	a5,112(a0)
    80002e5c:	02f4f863          	bgeu	s1,a5,80002e8c <fetchaddr+0x4a>
    80002e60:	00848713          	addi	a4,s1,8
    80002e64:	02e7e663          	bltu	a5,a4,80002e90 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002e68:	46a1                	li	a3,8
    80002e6a:	8626                	mv	a2,s1
    80002e6c:	85ca                	mv	a1,s2
    80002e6e:	7d28                	ld	a0,120(a0)
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	884080e7          	jalr	-1916(ra) # 800016f4 <copyin>
    80002e78:	00a03533          	snez	a0,a0
    80002e7c:	40a00533          	neg	a0,a0
}
    80002e80:	60e2                	ld	ra,24(sp)
    80002e82:	6442                	ld	s0,16(sp)
    80002e84:	64a2                	ld	s1,8(sp)
    80002e86:	6902                	ld	s2,0(sp)
    80002e88:	6105                	addi	sp,sp,32
    80002e8a:	8082                	ret
    return -1;
    80002e8c:	557d                	li	a0,-1
    80002e8e:	bfcd                	j	80002e80 <fetchaddr+0x3e>
    80002e90:	557d                	li	a0,-1
    80002e92:	b7fd                	j	80002e80 <fetchaddr+0x3e>

0000000080002e94 <fetchstr>:
{
    80002e94:	7179                	addi	sp,sp,-48
    80002e96:	f406                	sd	ra,40(sp)
    80002e98:	f022                	sd	s0,32(sp)
    80002e9a:	ec26                	sd	s1,24(sp)
    80002e9c:	e84a                	sd	s2,16(sp)
    80002e9e:	e44e                	sd	s3,8(sp)
    80002ea0:	1800                	addi	s0,sp,48
    80002ea2:	892a                	mv	s2,a0
    80002ea4:	84ae                	mv	s1,a1
    80002ea6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	b04080e7          	jalr	-1276(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002eb0:	86ce                	mv	a3,s3
    80002eb2:	864a                	mv	a2,s2
    80002eb4:	85a6                	mv	a1,s1
    80002eb6:	7d28                	ld	a0,120(a0)
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	8ca080e7          	jalr	-1846(ra) # 80001782 <copyinstr>
    80002ec0:	00054e63          	bltz	a0,80002edc <fetchstr+0x48>
  return strlen(buf);
    80002ec4:	8526                	mv	a0,s1
    80002ec6:	ffffe097          	auipc	ra,0xffffe
    80002eca:	f88080e7          	jalr	-120(ra) # 80000e4e <strlen>
}
    80002ece:	70a2                	ld	ra,40(sp)
    80002ed0:	7402                	ld	s0,32(sp)
    80002ed2:	64e2                	ld	s1,24(sp)
    80002ed4:	6942                	ld	s2,16(sp)
    80002ed6:	69a2                	ld	s3,8(sp)
    80002ed8:	6145                	addi	sp,sp,48
    80002eda:	8082                	ret
    return -1;
    80002edc:	557d                	li	a0,-1
    80002ede:	bfc5                	j	80002ece <fetchstr+0x3a>

0000000080002ee0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002ee0:	1101                	addi	sp,sp,-32
    80002ee2:	ec06                	sd	ra,24(sp)
    80002ee4:	e822                	sd	s0,16(sp)
    80002ee6:	e426                	sd	s1,8(sp)
    80002ee8:	1000                	addi	s0,sp,32
    80002eea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	eee080e7          	jalr	-274(ra) # 80002dda <argraw>
    80002ef4:	c088                	sw	a0,0(s1)
}
    80002ef6:	60e2                	ld	ra,24(sp)
    80002ef8:	6442                	ld	s0,16(sp)
    80002efa:	64a2                	ld	s1,8(sp)
    80002efc:	6105                	addi	sp,sp,32
    80002efe:	8082                	ret

0000000080002f00 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002f00:	1101                	addi	sp,sp,-32
    80002f02:	ec06                	sd	ra,24(sp)
    80002f04:	e822                	sd	s0,16(sp)
    80002f06:	e426                	sd	s1,8(sp)
    80002f08:	1000                	addi	s0,sp,32
    80002f0a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	ece080e7          	jalr	-306(ra) # 80002dda <argraw>
    80002f14:	e088                	sd	a0,0(s1)
}
    80002f16:	60e2                	ld	ra,24(sp)
    80002f18:	6442                	ld	s0,16(sp)
    80002f1a:	64a2                	ld	s1,8(sp)
    80002f1c:	6105                	addi	sp,sp,32
    80002f1e:	8082                	ret

0000000080002f20 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f20:	7179                	addi	sp,sp,-48
    80002f22:	f406                	sd	ra,40(sp)
    80002f24:	f022                	sd	s0,32(sp)
    80002f26:	ec26                	sd	s1,24(sp)
    80002f28:	e84a                	sd	s2,16(sp)
    80002f2a:	1800                	addi	s0,sp,48
    80002f2c:	84ae                	mv	s1,a1
    80002f2e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002f30:	fd840593          	addi	a1,s0,-40
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	fcc080e7          	jalr	-52(ra) # 80002f00 <argaddr>
  return fetchstr(addr, buf, max);
    80002f3c:	864a                	mv	a2,s2
    80002f3e:	85a6                	mv	a1,s1
    80002f40:	fd843503          	ld	a0,-40(s0)
    80002f44:	00000097          	auipc	ra,0x0
    80002f48:	f50080e7          	jalr	-176(ra) # 80002e94 <fetchstr>
}
    80002f4c:	70a2                	ld	ra,40(sp)
    80002f4e:	7402                	ld	s0,32(sp)
    80002f50:	64e2                	ld	s1,24(sp)
    80002f52:	6942                	ld	s2,16(sp)
    80002f54:	6145                	addi	sp,sp,48
    80002f56:	8082                	ret

0000000080002f58 <syscall>:

};

void
syscall(void)
{
    80002f58:	1101                	addi	sp,sp,-32
    80002f5a:	ec06                	sd	ra,24(sp)
    80002f5c:	e822                	sd	s0,16(sp)
    80002f5e:	e426                	sd	s1,8(sp)
    80002f60:	e04a                	sd	s2,0(sp)
    80002f62:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002f64:	fffff097          	auipc	ra,0xfffff
    80002f68:	a48080e7          	jalr	-1464(ra) # 800019ac <myproc>
    80002f6c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002f6e:	08053903          	ld	s2,128(a0)
    80002f72:	0a893783          	ld	a5,168(s2)
    80002f76:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002f7a:	37fd                	addiw	a5,a5,-1
    80002f7c:	4761                	li	a4,24
    80002f7e:	00f76f63          	bltu	a4,a5,80002f9c <syscall+0x44>
    80002f82:	00369713          	slli	a4,a3,0x3
    80002f86:	00005797          	auipc	a5,0x5
    80002f8a:	50a78793          	addi	a5,a5,1290 # 80008490 <syscalls>
    80002f8e:	97ba                	add	a5,a5,a4
    80002f90:	639c                	ld	a5,0(a5)
    80002f92:	c789                	beqz	a5,80002f9c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002f94:	9782                	jalr	a5
    80002f96:	06a93823          	sd	a0,112(s2)
    80002f9a:	a839                	j	80002fb8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002f9c:	18048613          	addi	a2,s1,384
    80002fa0:	588c                	lw	a1,48(s1)
    80002fa2:	00005517          	auipc	a0,0x5
    80002fa6:	4b650513          	addi	a0,a0,1206 # 80008458 <states.0+0x160>
    80002faa:	ffffd097          	auipc	ra,0xffffd
    80002fae:	5de080e7          	jalr	1502(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002fb2:	60dc                	ld	a5,128(s1)
    80002fb4:	577d                	li	a4,-1
    80002fb6:	fbb8                	sd	a4,112(a5)
  }
}
    80002fb8:	60e2                	ld	ra,24(sp)
    80002fba:	6442                	ld	s0,16(sp)
    80002fbc:	64a2                	ld	s1,8(sp)
    80002fbe:	6902                	ld	s2,0(sp)
    80002fc0:	6105                	addi	sp,sp,32
    80002fc2:	8082                	ret

0000000080002fc4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002fc4:	7139                	addi	sp,sp,-64
    80002fc6:	fc06                	sd	ra,56(sp)
    80002fc8:	f822                	sd	s0,48(sp)
    80002fca:	0080                	addi	s0,sp,64
  int n;
  char exit_msg[32];
  argint(0, &n);
    80002fcc:	fec40593          	addi	a1,s0,-20
    80002fd0:	4501                	li	a0,0
    80002fd2:	00000097          	auipc	ra,0x0
    80002fd6:	f0e080e7          	jalr	-242(ra) # 80002ee0 <argint>
  argstr(1, exit_msg, MAXARG);
    80002fda:	02000613          	li	a2,32
    80002fde:	fc840593          	addi	a1,s0,-56
    80002fe2:	4505                	li	a0,1
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	f3c080e7          	jalr	-196(ra) # 80002f20 <argstr>
  exit(n,exit_msg);
    80002fec:	fc840593          	addi	a1,s0,-56
    80002ff0:	fec42503          	lw	a0,-20(s0)
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	2f4080e7          	jalr	756(ra) # 800022e8 <exit>
  return 0;  // not reached
}
    80002ffc:	4501                	li	a0,0
    80002ffe:	70e2                	ld	ra,56(sp)
    80003000:	7442                	ld	s0,48(sp)
    80003002:	6121                	addi	sp,sp,64
    80003004:	8082                	ret

0000000080003006 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003006:	1141                	addi	sp,sp,-16
    80003008:	e406                	sd	ra,8(sp)
    8000300a:	e022                	sd	s0,0(sp)
    8000300c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	99e080e7          	jalr	-1634(ra) # 800019ac <myproc>
}
    80003016:	5908                	lw	a0,48(a0)
    80003018:	60a2                	ld	ra,8(sp)
    8000301a:	6402                	ld	s0,0(sp)
    8000301c:	0141                	addi	sp,sp,16
    8000301e:	8082                	ret

0000000080003020 <sys_fork>:

uint64
sys_fork(void)
{
    80003020:	1141                	addi	sp,sp,-16
    80003022:	e406                	sd	ra,8(sp)
    80003024:	e022                	sd	s0,0(sp)
    80003026:	0800                	addi	s0,sp,16
  return fork();
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	dd4080e7          	jalr	-556(ra) # 80001dfc <fork>
}
    80003030:	60a2                	ld	ra,8(sp)
    80003032:	6402                	ld	s0,0(sp)
    80003034:	0141                	addi	sp,sp,16
    80003036:	8082                	ret

0000000080003038 <sys_wait>:

uint64
sys_wait(void)
{
    80003038:	1101                	addi	sp,sp,-32
    8000303a:	ec06                	sd	ra,24(sp)
    8000303c:	e822                	sd	s0,16(sp)
    8000303e:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 exit_msg;
  
  argaddr(0, &p);
    80003040:	fe840593          	addi	a1,s0,-24
    80003044:	4501                	li	a0,0
    80003046:	00000097          	auipc	ra,0x0
    8000304a:	eba080e7          	jalr	-326(ra) # 80002f00 <argaddr>
  argaddr(1, &exit_msg);
    8000304e:	fe040593          	addi	a1,s0,-32
    80003052:	4505                	li	a0,1
    80003054:	00000097          	auipc	ra,0x0
    80003058:	eac080e7          	jalr	-340(ra) # 80002f00 <argaddr>
  return wait(p,exit_msg);
    8000305c:	fe043583          	ld	a1,-32(s0)
    80003060:	fe843503          	ld	a0,-24(s0)
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	440080e7          	jalr	1088(ra) # 800024a4 <wait>
}
    8000306c:	60e2                	ld	ra,24(sp)
    8000306e:	6442                	ld	s0,16(sp)
    80003070:	6105                	addi	sp,sp,32
    80003072:	8082                	ret

0000000080003074 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003074:	7179                	addi	sp,sp,-48
    80003076:	f406                	sd	ra,40(sp)
    80003078:	f022                	sd	s0,32(sp)
    8000307a:	ec26                	sd	s1,24(sp)
    8000307c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000307e:	fdc40593          	addi	a1,s0,-36
    80003082:	4501                	li	a0,0
    80003084:	00000097          	auipc	ra,0x0
    80003088:	e5c080e7          	jalr	-420(ra) # 80002ee0 <argint>
  addr = myproc()->sz;
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	920080e7          	jalr	-1760(ra) # 800019ac <myproc>
    80003094:	7924                	ld	s1,112(a0)
  if(growproc(n) < 0)
    80003096:	fdc42503          	lw	a0,-36(s0)
    8000309a:	fffff097          	auipc	ra,0xfffff
    8000309e:	d06080e7          	jalr	-762(ra) # 80001da0 <growproc>
    800030a2:	00054863          	bltz	a0,800030b2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800030a6:	8526                	mv	a0,s1
    800030a8:	70a2                	ld	ra,40(sp)
    800030aa:	7402                	ld	s0,32(sp)
    800030ac:	64e2                	ld	s1,24(sp)
    800030ae:	6145                	addi	sp,sp,48
    800030b0:	8082                	ret
    return -1;
    800030b2:	54fd                	li	s1,-1
    800030b4:	bfcd                	j	800030a6 <sys_sbrk+0x32>

00000000800030b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800030b6:	7139                	addi	sp,sp,-64
    800030b8:	fc06                	sd	ra,56(sp)
    800030ba:	f822                	sd	s0,48(sp)
    800030bc:	f426                	sd	s1,40(sp)
    800030be:	f04a                	sd	s2,32(sp)
    800030c0:	ec4e                	sd	s3,24(sp)
    800030c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800030c4:	fcc40593          	addi	a1,s0,-52
    800030c8:	4501                	li	a0,0
    800030ca:	00000097          	auipc	ra,0x0
    800030ce:	e16080e7          	jalr	-490(ra) # 80002ee0 <argint>
  acquire(&tickslock);
    800030d2:	00015517          	auipc	a0,0x15
    800030d6:	f0e50513          	addi	a0,a0,-242 # 80017fe0 <tickslock>
    800030da:	ffffe097          	auipc	ra,0xffffe
    800030de:	afc080e7          	jalr	-1284(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    800030e2:	00006917          	auipc	s2,0x6
    800030e6:	85e92903          	lw	s2,-1954(s2) # 80008940 <ticks>
  while(ticks - ticks0 < n){
    800030ea:	fcc42783          	lw	a5,-52(s0)
    800030ee:	cf9d                	beqz	a5,8000312c <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800030f0:	00015997          	auipc	s3,0x15
    800030f4:	ef098993          	addi	s3,s3,-272 # 80017fe0 <tickslock>
    800030f8:	00006497          	auipc	s1,0x6
    800030fc:	84848493          	addi	s1,s1,-1976 # 80008940 <ticks>
    if(killed(myproc())){
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	8ac080e7          	jalr	-1876(ra) # 800019ac <myproc>
    80003108:	fffff097          	auipc	ra,0xfffff
    8000310c:	36a080e7          	jalr	874(ra) # 80002472 <killed>
    80003110:	ed15                	bnez	a0,8000314c <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003112:	85ce                	mv	a1,s3
    80003114:	8526                	mv	a0,s1
    80003116:	fffff097          	auipc	ra,0xfffff
    8000311a:	034080e7          	jalr	52(ra) # 8000214a <sleep>
  while(ticks - ticks0 < n){
    8000311e:	409c                	lw	a5,0(s1)
    80003120:	412787bb          	subw	a5,a5,s2
    80003124:	fcc42703          	lw	a4,-52(s0)
    80003128:	fce7ece3          	bltu	a5,a4,80003100 <sys_sleep+0x4a>
  }
  release(&tickslock);
    8000312c:	00015517          	auipc	a0,0x15
    80003130:	eb450513          	addi	a0,a0,-332 # 80017fe0 <tickslock>
    80003134:	ffffe097          	auipc	ra,0xffffe
    80003138:	b56080e7          	jalr	-1194(ra) # 80000c8a <release>
  return 0;
    8000313c:	4501                	li	a0,0
}
    8000313e:	70e2                	ld	ra,56(sp)
    80003140:	7442                	ld	s0,48(sp)
    80003142:	74a2                	ld	s1,40(sp)
    80003144:	7902                	ld	s2,32(sp)
    80003146:	69e2                	ld	s3,24(sp)
    80003148:	6121                	addi	sp,sp,64
    8000314a:	8082                	ret
      release(&tickslock);
    8000314c:	00015517          	auipc	a0,0x15
    80003150:	e9450513          	addi	a0,a0,-364 # 80017fe0 <tickslock>
    80003154:	ffffe097          	auipc	ra,0xffffe
    80003158:	b36080e7          	jalr	-1226(ra) # 80000c8a <release>
      return -1;
    8000315c:	557d                	li	a0,-1
    8000315e:	b7c5                	j	8000313e <sys_sleep+0x88>

0000000080003160 <sys_kill>:

uint64
sys_kill(void)
{
    80003160:	1101                	addi	sp,sp,-32
    80003162:	ec06                	sd	ra,24(sp)
    80003164:	e822                	sd	s0,16(sp)
    80003166:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003168:	fec40593          	addi	a1,s0,-20
    8000316c:	4501                	li	a0,0
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	d72080e7          	jalr	-654(ra) # 80002ee0 <argint>
  return kill(pid);
    80003176:	fec42503          	lw	a0,-20(s0)
    8000317a:	fffff097          	auipc	ra,0xfffff
    8000317e:	25a080e7          	jalr	602(ra) # 800023d4 <kill>
}
    80003182:	60e2                	ld	ra,24(sp)
    80003184:	6442                	ld	s0,16(sp)
    80003186:	6105                	addi	sp,sp,32
    80003188:	8082                	ret

000000008000318a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000318a:	1101                	addi	sp,sp,-32
    8000318c:	ec06                	sd	ra,24(sp)
    8000318e:	e822                	sd	s0,16(sp)
    80003190:	e426                	sd	s1,8(sp)
    80003192:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003194:	00015517          	auipc	a0,0x15
    80003198:	e4c50513          	addi	a0,a0,-436 # 80017fe0 <tickslock>
    8000319c:	ffffe097          	auipc	ra,0xffffe
    800031a0:	a3a080e7          	jalr	-1478(ra) # 80000bd6 <acquire>
  xticks = ticks;
    800031a4:	00005497          	auipc	s1,0x5
    800031a8:	79c4a483          	lw	s1,1948(s1) # 80008940 <ticks>
  release(&tickslock);
    800031ac:	00015517          	auipc	a0,0x15
    800031b0:	e3450513          	addi	a0,a0,-460 # 80017fe0 <tickslock>
    800031b4:	ffffe097          	auipc	ra,0xffffe
    800031b8:	ad6080e7          	jalr	-1322(ra) # 80000c8a <release>
  return xticks;
}
    800031bc:	02049513          	slli	a0,s1,0x20
    800031c0:	9101                	srli	a0,a0,0x20
    800031c2:	60e2                	ld	ra,24(sp)
    800031c4:	6442                	ld	s0,16(sp)
    800031c6:	64a2                	ld	s1,8(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret

00000000800031cc <sys_memsize>:

uint64
sys_memsize(void)
{
    800031cc:	1141                	addi	sp,sp,-16
    800031ce:	e406                	sd	ra,8(sp)
    800031d0:	e022                	sd	s0,0(sp)
    800031d2:	0800                	addi	s0,sp,16
  return myproc()->sz;  
    800031d4:	ffffe097          	auipc	ra,0xffffe
    800031d8:	7d8080e7          	jalr	2008(ra) # 800019ac <myproc>
}
    800031dc:	7928                	ld	a0,112(a0)
    800031de:	60a2                	ld	ra,8(sp)
    800031e0:	6402                	ld	s0,0(sp)
    800031e2:	0141                	addi	sp,sp,16
    800031e4:	8082                	ret

00000000800031e6 <sys_set_ps_priority>:

uint64
sys_set_ps_priority(void)
{
    800031e6:	1101                	addi	sp,sp,-32
    800031e8:	ec06                	sd	ra,24(sp)
    800031ea:	e822                	sd	s0,16(sp)
    800031ec:	1000                	addi	s0,sp,32
  int new_priority;
  argint(0, &new_priority);
    800031ee:	fec40593          	addi	a1,s0,-20
    800031f2:	4501                	li	a0,0
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	cec080e7          	jalr	-788(ra) # 80002ee0 <argint>
  return set_ps_priority(new_priority);
    800031fc:	fec42503          	lw	a0,-20(s0)
    80003200:	fffff097          	auipc	ra,0xfffff
    80003204:	56e080e7          	jalr	1390(ra) # 8000276e <set_ps_priority>
}
    80003208:	60e2                	ld	ra,24(sp)
    8000320a:	6442                	ld	s0,16(sp)
    8000320c:	6105                	addi	sp,sp,32
    8000320e:	8082                	ret

0000000080003210 <sys_set_cfs_priority>:

//task6
uint64
sys_set_cfs_priority(void)
{
    80003210:	1101                	addi	sp,sp,-32
    80003212:	ec06                	sd	ra,24(sp)
    80003214:	e822                	sd	s0,16(sp)
    80003216:	1000                	addi	s0,sp,32
  int new_priority;
  argint(0, &new_priority);
    80003218:	fec40593          	addi	a1,s0,-20
    8000321c:	4501                	li	a0,0
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	cc2080e7          	jalr	-830(ra) # 80002ee0 <argint>
  return set_cfs_priority(new_priority);
    80003226:	fec42503          	lw	a0,-20(s0)
    8000322a:	fffff097          	auipc	ra,0xfffff
    8000322e:	568080e7          	jalr	1384(ra) # 80002792 <set_cfs_priority>
}
    80003232:	60e2                	ld	ra,24(sp)
    80003234:	6442                	ld	s0,16(sp)
    80003236:	6105                	addi	sp,sp,32
    80003238:	8082                	ret

000000008000323a <sys_get_cfs_stats>:

char*
sys_get_cfs_stats(void)
{
    8000323a:	1101                	addi	sp,sp,-32
    8000323c:	ec06                	sd	ra,24(sp)
    8000323e:	e822                	sd	s0,16(sp)
    80003240:	1000                	addi	s0,sp,32
  int p;
  argint(0, &p);
    80003242:	fec40593          	addi	a1,s0,-20
    80003246:	4501                	li	a0,0
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	c98080e7          	jalr	-872(ra) # 80002ee0 <argint>
  return get_cfs_stats(p);
    80003250:	fec42503          	lw	a0,-20(s0)
    80003254:	fffff097          	auipc	ra,0xfffff
    80003258:	590080e7          	jalr	1424(ra) # 800027e4 <get_cfs_stats>
}
    8000325c:	60e2                	ld	ra,24(sp)
    8000325e:	6442                	ld	s0,16(sp)
    80003260:	6105                	addi	sp,sp,32
    80003262:	8082                	ret

0000000080003264 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003264:	7179                	addi	sp,sp,-48
    80003266:	f406                	sd	ra,40(sp)
    80003268:	f022                	sd	s0,32(sp)
    8000326a:	ec26                	sd	s1,24(sp)
    8000326c:	e84a                	sd	s2,16(sp)
    8000326e:	e44e                	sd	s3,8(sp)
    80003270:	e052                	sd	s4,0(sp)
    80003272:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003274:	00005597          	auipc	a1,0x5
    80003278:	2ec58593          	addi	a1,a1,748 # 80008560 <syscalls+0xd0>
    8000327c:	00015517          	auipc	a0,0x15
    80003280:	d7c50513          	addi	a0,a0,-644 # 80017ff8 <bcache>
    80003284:	ffffe097          	auipc	ra,0xffffe
    80003288:	8c2080e7          	jalr	-1854(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000328c:	0001d797          	auipc	a5,0x1d
    80003290:	d6c78793          	addi	a5,a5,-660 # 8001fff8 <bcache+0x8000>
    80003294:	0001d717          	auipc	a4,0x1d
    80003298:	fcc70713          	addi	a4,a4,-52 # 80020260 <bcache+0x8268>
    8000329c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800032a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032a4:	00015497          	auipc	s1,0x15
    800032a8:	d6c48493          	addi	s1,s1,-660 # 80018010 <bcache+0x18>
    b->next = bcache.head.next;
    800032ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800032ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800032b0:	00005a17          	auipc	s4,0x5
    800032b4:	2b8a0a13          	addi	s4,s4,696 # 80008568 <syscalls+0xd8>
    b->next = bcache.head.next;
    800032b8:	2b893783          	ld	a5,696(s2)
    800032bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800032be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800032c2:	85d2                	mv	a1,s4
    800032c4:	01048513          	addi	a0,s1,16
    800032c8:	00001097          	auipc	ra,0x1
    800032cc:	4c4080e7          	jalr	1220(ra) # 8000478c <initsleeplock>
    bcache.head.next->prev = b;
    800032d0:	2b893783          	ld	a5,696(s2)
    800032d4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800032d6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800032da:	45848493          	addi	s1,s1,1112
    800032de:	fd349de3          	bne	s1,s3,800032b8 <binit+0x54>
  }
}
    800032e2:	70a2                	ld	ra,40(sp)
    800032e4:	7402                	ld	s0,32(sp)
    800032e6:	64e2                	ld	s1,24(sp)
    800032e8:	6942                	ld	s2,16(sp)
    800032ea:	69a2                	ld	s3,8(sp)
    800032ec:	6a02                	ld	s4,0(sp)
    800032ee:	6145                	addi	sp,sp,48
    800032f0:	8082                	ret

00000000800032f2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800032f2:	7179                	addi	sp,sp,-48
    800032f4:	f406                	sd	ra,40(sp)
    800032f6:	f022                	sd	s0,32(sp)
    800032f8:	ec26                	sd	s1,24(sp)
    800032fa:	e84a                	sd	s2,16(sp)
    800032fc:	e44e                	sd	s3,8(sp)
    800032fe:	1800                	addi	s0,sp,48
    80003300:	892a                	mv	s2,a0
    80003302:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003304:	00015517          	auipc	a0,0x15
    80003308:	cf450513          	addi	a0,a0,-780 # 80017ff8 <bcache>
    8000330c:	ffffe097          	auipc	ra,0xffffe
    80003310:	8ca080e7          	jalr	-1846(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003314:	0001d497          	auipc	s1,0x1d
    80003318:	f9c4b483          	ld	s1,-100(s1) # 800202b0 <bcache+0x82b8>
    8000331c:	0001d797          	auipc	a5,0x1d
    80003320:	f4478793          	addi	a5,a5,-188 # 80020260 <bcache+0x8268>
    80003324:	02f48f63          	beq	s1,a5,80003362 <bread+0x70>
    80003328:	873e                	mv	a4,a5
    8000332a:	a021                	j	80003332 <bread+0x40>
    8000332c:	68a4                	ld	s1,80(s1)
    8000332e:	02e48a63          	beq	s1,a4,80003362 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003332:	449c                	lw	a5,8(s1)
    80003334:	ff279ce3          	bne	a5,s2,8000332c <bread+0x3a>
    80003338:	44dc                	lw	a5,12(s1)
    8000333a:	ff3799e3          	bne	a5,s3,8000332c <bread+0x3a>
      b->refcnt++;
    8000333e:	40bc                	lw	a5,64(s1)
    80003340:	2785                	addiw	a5,a5,1
    80003342:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003344:	00015517          	auipc	a0,0x15
    80003348:	cb450513          	addi	a0,a0,-844 # 80017ff8 <bcache>
    8000334c:	ffffe097          	auipc	ra,0xffffe
    80003350:	93e080e7          	jalr	-1730(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80003354:	01048513          	addi	a0,s1,16
    80003358:	00001097          	auipc	ra,0x1
    8000335c:	46e080e7          	jalr	1134(ra) # 800047c6 <acquiresleep>
      return b;
    80003360:	a8b9                	j	800033be <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003362:	0001d497          	auipc	s1,0x1d
    80003366:	f464b483          	ld	s1,-186(s1) # 800202a8 <bcache+0x82b0>
    8000336a:	0001d797          	auipc	a5,0x1d
    8000336e:	ef678793          	addi	a5,a5,-266 # 80020260 <bcache+0x8268>
    80003372:	00f48863          	beq	s1,a5,80003382 <bread+0x90>
    80003376:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003378:	40bc                	lw	a5,64(s1)
    8000337a:	cf81                	beqz	a5,80003392 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000337c:	64a4                	ld	s1,72(s1)
    8000337e:	fee49de3          	bne	s1,a4,80003378 <bread+0x86>
  panic("bget: no buffers");
    80003382:	00005517          	auipc	a0,0x5
    80003386:	1ee50513          	addi	a0,a0,494 # 80008570 <syscalls+0xe0>
    8000338a:	ffffd097          	auipc	ra,0xffffd
    8000338e:	1b4080e7          	jalr	436(ra) # 8000053e <panic>
      b->dev = dev;
    80003392:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003396:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000339a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000339e:	4785                	li	a5,1
    800033a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800033a2:	00015517          	auipc	a0,0x15
    800033a6:	c5650513          	addi	a0,a0,-938 # 80017ff8 <bcache>
    800033aa:	ffffe097          	auipc	ra,0xffffe
    800033ae:	8e0080e7          	jalr	-1824(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800033b2:	01048513          	addi	a0,s1,16
    800033b6:	00001097          	auipc	ra,0x1
    800033ba:	410080e7          	jalr	1040(ra) # 800047c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800033be:	409c                	lw	a5,0(s1)
    800033c0:	cb89                	beqz	a5,800033d2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800033c2:	8526                	mv	a0,s1
    800033c4:	70a2                	ld	ra,40(sp)
    800033c6:	7402                	ld	s0,32(sp)
    800033c8:	64e2                	ld	s1,24(sp)
    800033ca:	6942                	ld	s2,16(sp)
    800033cc:	69a2                	ld	s3,8(sp)
    800033ce:	6145                	addi	sp,sp,48
    800033d0:	8082                	ret
    virtio_disk_rw(b, 0);
    800033d2:	4581                	li	a1,0
    800033d4:	8526                	mv	a0,s1
    800033d6:	00003097          	auipc	ra,0x3
    800033da:	fde080e7          	jalr	-34(ra) # 800063b4 <virtio_disk_rw>
    b->valid = 1;
    800033de:	4785                	li	a5,1
    800033e0:	c09c                	sw	a5,0(s1)
  return b;
    800033e2:	b7c5                	j	800033c2 <bread+0xd0>

00000000800033e4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800033e4:	1101                	addi	sp,sp,-32
    800033e6:	ec06                	sd	ra,24(sp)
    800033e8:	e822                	sd	s0,16(sp)
    800033ea:	e426                	sd	s1,8(sp)
    800033ec:	1000                	addi	s0,sp,32
    800033ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800033f0:	0541                	addi	a0,a0,16
    800033f2:	00001097          	auipc	ra,0x1
    800033f6:	46e080e7          	jalr	1134(ra) # 80004860 <holdingsleep>
    800033fa:	cd01                	beqz	a0,80003412 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800033fc:	4585                	li	a1,1
    800033fe:	8526                	mv	a0,s1
    80003400:	00003097          	auipc	ra,0x3
    80003404:	fb4080e7          	jalr	-76(ra) # 800063b4 <virtio_disk_rw>
}
    80003408:	60e2                	ld	ra,24(sp)
    8000340a:	6442                	ld	s0,16(sp)
    8000340c:	64a2                	ld	s1,8(sp)
    8000340e:	6105                	addi	sp,sp,32
    80003410:	8082                	ret
    panic("bwrite");
    80003412:	00005517          	auipc	a0,0x5
    80003416:	17650513          	addi	a0,a0,374 # 80008588 <syscalls+0xf8>
    8000341a:	ffffd097          	auipc	ra,0xffffd
    8000341e:	124080e7          	jalr	292(ra) # 8000053e <panic>

0000000080003422 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003422:	1101                	addi	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	e426                	sd	s1,8(sp)
    8000342a:	e04a                	sd	s2,0(sp)
    8000342c:	1000                	addi	s0,sp,32
    8000342e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003430:	01050913          	addi	s2,a0,16
    80003434:	854a                	mv	a0,s2
    80003436:	00001097          	auipc	ra,0x1
    8000343a:	42a080e7          	jalr	1066(ra) # 80004860 <holdingsleep>
    8000343e:	c92d                	beqz	a0,800034b0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003440:	854a                	mv	a0,s2
    80003442:	00001097          	auipc	ra,0x1
    80003446:	3da080e7          	jalr	986(ra) # 8000481c <releasesleep>

  acquire(&bcache.lock);
    8000344a:	00015517          	auipc	a0,0x15
    8000344e:	bae50513          	addi	a0,a0,-1106 # 80017ff8 <bcache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	784080e7          	jalr	1924(ra) # 80000bd6 <acquire>
  b->refcnt--;
    8000345a:	40bc                	lw	a5,64(s1)
    8000345c:	37fd                	addiw	a5,a5,-1
    8000345e:	0007871b          	sext.w	a4,a5
    80003462:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003464:	eb05                	bnez	a4,80003494 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003466:	68bc                	ld	a5,80(s1)
    80003468:	64b8                	ld	a4,72(s1)
    8000346a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000346c:	64bc                	ld	a5,72(s1)
    8000346e:	68b8                	ld	a4,80(s1)
    80003470:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003472:	0001d797          	auipc	a5,0x1d
    80003476:	b8678793          	addi	a5,a5,-1146 # 8001fff8 <bcache+0x8000>
    8000347a:	2b87b703          	ld	a4,696(a5)
    8000347e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003480:	0001d717          	auipc	a4,0x1d
    80003484:	de070713          	addi	a4,a4,-544 # 80020260 <bcache+0x8268>
    80003488:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000348a:	2b87b703          	ld	a4,696(a5)
    8000348e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003490:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003494:	00015517          	auipc	a0,0x15
    80003498:	b6450513          	addi	a0,a0,-1180 # 80017ff8 <bcache>
    8000349c:	ffffd097          	auipc	ra,0xffffd
    800034a0:	7ee080e7          	jalr	2030(ra) # 80000c8a <release>
}
    800034a4:	60e2                	ld	ra,24(sp)
    800034a6:	6442                	ld	s0,16(sp)
    800034a8:	64a2                	ld	s1,8(sp)
    800034aa:	6902                	ld	s2,0(sp)
    800034ac:	6105                	addi	sp,sp,32
    800034ae:	8082                	ret
    panic("brelse");
    800034b0:	00005517          	auipc	a0,0x5
    800034b4:	0e050513          	addi	a0,a0,224 # 80008590 <syscalls+0x100>
    800034b8:	ffffd097          	auipc	ra,0xffffd
    800034bc:	086080e7          	jalr	134(ra) # 8000053e <panic>

00000000800034c0 <bpin>:

void
bpin(struct buf *b) {
    800034c0:	1101                	addi	sp,sp,-32
    800034c2:	ec06                	sd	ra,24(sp)
    800034c4:	e822                	sd	s0,16(sp)
    800034c6:	e426                	sd	s1,8(sp)
    800034c8:	1000                	addi	s0,sp,32
    800034ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800034cc:	00015517          	auipc	a0,0x15
    800034d0:	b2c50513          	addi	a0,a0,-1236 # 80017ff8 <bcache>
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	702080e7          	jalr	1794(ra) # 80000bd6 <acquire>
  b->refcnt++;
    800034dc:	40bc                	lw	a5,64(s1)
    800034de:	2785                	addiw	a5,a5,1
    800034e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800034e2:	00015517          	auipc	a0,0x15
    800034e6:	b1650513          	addi	a0,a0,-1258 # 80017ff8 <bcache>
    800034ea:	ffffd097          	auipc	ra,0xffffd
    800034ee:	7a0080e7          	jalr	1952(ra) # 80000c8a <release>
}
    800034f2:	60e2                	ld	ra,24(sp)
    800034f4:	6442                	ld	s0,16(sp)
    800034f6:	64a2                	ld	s1,8(sp)
    800034f8:	6105                	addi	sp,sp,32
    800034fa:	8082                	ret

00000000800034fc <bunpin>:

void
bunpin(struct buf *b) {
    800034fc:	1101                	addi	sp,sp,-32
    800034fe:	ec06                	sd	ra,24(sp)
    80003500:	e822                	sd	s0,16(sp)
    80003502:	e426                	sd	s1,8(sp)
    80003504:	1000                	addi	s0,sp,32
    80003506:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003508:	00015517          	auipc	a0,0x15
    8000350c:	af050513          	addi	a0,a0,-1296 # 80017ff8 <bcache>
    80003510:	ffffd097          	auipc	ra,0xffffd
    80003514:	6c6080e7          	jalr	1734(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003518:	40bc                	lw	a5,64(s1)
    8000351a:	37fd                	addiw	a5,a5,-1
    8000351c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000351e:	00015517          	auipc	a0,0x15
    80003522:	ada50513          	addi	a0,a0,-1318 # 80017ff8 <bcache>
    80003526:	ffffd097          	auipc	ra,0xffffd
    8000352a:	764080e7          	jalr	1892(ra) # 80000c8a <release>
}
    8000352e:	60e2                	ld	ra,24(sp)
    80003530:	6442                	ld	s0,16(sp)
    80003532:	64a2                	ld	s1,8(sp)
    80003534:	6105                	addi	sp,sp,32
    80003536:	8082                	ret

0000000080003538 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003538:	1101                	addi	sp,sp,-32
    8000353a:	ec06                	sd	ra,24(sp)
    8000353c:	e822                	sd	s0,16(sp)
    8000353e:	e426                	sd	s1,8(sp)
    80003540:	e04a                	sd	s2,0(sp)
    80003542:	1000                	addi	s0,sp,32
    80003544:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003546:	00d5d59b          	srliw	a1,a1,0xd
    8000354a:	0001d797          	auipc	a5,0x1d
    8000354e:	18a7a783          	lw	a5,394(a5) # 800206d4 <sb+0x1c>
    80003552:	9dbd                	addw	a1,a1,a5
    80003554:	00000097          	auipc	ra,0x0
    80003558:	d9e080e7          	jalr	-610(ra) # 800032f2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000355c:	0074f713          	andi	a4,s1,7
    80003560:	4785                	li	a5,1
    80003562:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003566:	14ce                	slli	s1,s1,0x33
    80003568:	90d9                	srli	s1,s1,0x36
    8000356a:	00950733          	add	a4,a0,s1
    8000356e:	05874703          	lbu	a4,88(a4)
    80003572:	00e7f6b3          	and	a3,a5,a4
    80003576:	c69d                	beqz	a3,800035a4 <bfree+0x6c>
    80003578:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000357a:	94aa                	add	s1,s1,a0
    8000357c:	fff7c793          	not	a5,a5
    80003580:	8ff9                	and	a5,a5,a4
    80003582:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003586:	00001097          	auipc	ra,0x1
    8000358a:	120080e7          	jalr	288(ra) # 800046a6 <log_write>
  brelse(bp);
    8000358e:	854a                	mv	a0,s2
    80003590:	00000097          	auipc	ra,0x0
    80003594:	e92080e7          	jalr	-366(ra) # 80003422 <brelse>
}
    80003598:	60e2                	ld	ra,24(sp)
    8000359a:	6442                	ld	s0,16(sp)
    8000359c:	64a2                	ld	s1,8(sp)
    8000359e:	6902                	ld	s2,0(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret
    panic("freeing free block");
    800035a4:	00005517          	auipc	a0,0x5
    800035a8:	ff450513          	addi	a0,a0,-12 # 80008598 <syscalls+0x108>
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	f92080e7          	jalr	-110(ra) # 8000053e <panic>

00000000800035b4 <balloc>:
{
    800035b4:	711d                	addi	sp,sp,-96
    800035b6:	ec86                	sd	ra,88(sp)
    800035b8:	e8a2                	sd	s0,80(sp)
    800035ba:	e4a6                	sd	s1,72(sp)
    800035bc:	e0ca                	sd	s2,64(sp)
    800035be:	fc4e                	sd	s3,56(sp)
    800035c0:	f852                	sd	s4,48(sp)
    800035c2:	f456                	sd	s5,40(sp)
    800035c4:	f05a                	sd	s6,32(sp)
    800035c6:	ec5e                	sd	s7,24(sp)
    800035c8:	e862                	sd	s8,16(sp)
    800035ca:	e466                	sd	s9,8(sp)
    800035cc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800035ce:	0001d797          	auipc	a5,0x1d
    800035d2:	0ee7a783          	lw	a5,238(a5) # 800206bc <sb+0x4>
    800035d6:	10078163          	beqz	a5,800036d8 <balloc+0x124>
    800035da:	8baa                	mv	s7,a0
    800035dc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800035de:	0001db17          	auipc	s6,0x1d
    800035e2:	0dab0b13          	addi	s6,s6,218 # 800206b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035e6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800035e8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800035ea:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800035ec:	6c89                	lui	s9,0x2
    800035ee:	a061                	j	80003676 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800035f0:	974a                	add	a4,a4,s2
    800035f2:	8fd5                	or	a5,a5,a3
    800035f4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800035f8:	854a                	mv	a0,s2
    800035fa:	00001097          	auipc	ra,0x1
    800035fe:	0ac080e7          	jalr	172(ra) # 800046a6 <log_write>
        brelse(bp);
    80003602:	854a                	mv	a0,s2
    80003604:	00000097          	auipc	ra,0x0
    80003608:	e1e080e7          	jalr	-482(ra) # 80003422 <brelse>
  bp = bread(dev, bno);
    8000360c:	85a6                	mv	a1,s1
    8000360e:	855e                	mv	a0,s7
    80003610:	00000097          	auipc	ra,0x0
    80003614:	ce2080e7          	jalr	-798(ra) # 800032f2 <bread>
    80003618:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000361a:	40000613          	li	a2,1024
    8000361e:	4581                	li	a1,0
    80003620:	05850513          	addi	a0,a0,88
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	6ae080e7          	jalr	1710(ra) # 80000cd2 <memset>
  log_write(bp);
    8000362c:	854a                	mv	a0,s2
    8000362e:	00001097          	auipc	ra,0x1
    80003632:	078080e7          	jalr	120(ra) # 800046a6 <log_write>
  brelse(bp);
    80003636:	854a                	mv	a0,s2
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	dea080e7          	jalr	-534(ra) # 80003422 <brelse>
}
    80003640:	8526                	mv	a0,s1
    80003642:	60e6                	ld	ra,88(sp)
    80003644:	6446                	ld	s0,80(sp)
    80003646:	64a6                	ld	s1,72(sp)
    80003648:	6906                	ld	s2,64(sp)
    8000364a:	79e2                	ld	s3,56(sp)
    8000364c:	7a42                	ld	s4,48(sp)
    8000364e:	7aa2                	ld	s5,40(sp)
    80003650:	7b02                	ld	s6,32(sp)
    80003652:	6be2                	ld	s7,24(sp)
    80003654:	6c42                	ld	s8,16(sp)
    80003656:	6ca2                	ld	s9,8(sp)
    80003658:	6125                	addi	sp,sp,96
    8000365a:	8082                	ret
    brelse(bp);
    8000365c:	854a                	mv	a0,s2
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	dc4080e7          	jalr	-572(ra) # 80003422 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003666:	015c87bb          	addw	a5,s9,s5
    8000366a:	00078a9b          	sext.w	s5,a5
    8000366e:	004b2703          	lw	a4,4(s6)
    80003672:	06eaf363          	bgeu	s5,a4,800036d8 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003676:	41fad79b          	sraiw	a5,s5,0x1f
    8000367a:	0137d79b          	srliw	a5,a5,0x13
    8000367e:	015787bb          	addw	a5,a5,s5
    80003682:	40d7d79b          	sraiw	a5,a5,0xd
    80003686:	01cb2583          	lw	a1,28(s6)
    8000368a:	9dbd                	addw	a1,a1,a5
    8000368c:	855e                	mv	a0,s7
    8000368e:	00000097          	auipc	ra,0x0
    80003692:	c64080e7          	jalr	-924(ra) # 800032f2 <bread>
    80003696:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003698:	004b2503          	lw	a0,4(s6)
    8000369c:	000a849b          	sext.w	s1,s5
    800036a0:	8662                	mv	a2,s8
    800036a2:	faa4fde3          	bgeu	s1,a0,8000365c <balloc+0xa8>
      m = 1 << (bi % 8);
    800036a6:	41f6579b          	sraiw	a5,a2,0x1f
    800036aa:	01d7d69b          	srliw	a3,a5,0x1d
    800036ae:	00c6873b          	addw	a4,a3,a2
    800036b2:	00777793          	andi	a5,a4,7
    800036b6:	9f95                	subw	a5,a5,a3
    800036b8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800036bc:	4037571b          	sraiw	a4,a4,0x3
    800036c0:	00e906b3          	add	a3,s2,a4
    800036c4:	0586c683          	lbu	a3,88(a3)
    800036c8:	00d7f5b3          	and	a1,a5,a3
    800036cc:	d195                	beqz	a1,800035f0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800036ce:	2605                	addiw	a2,a2,1
    800036d0:	2485                	addiw	s1,s1,1
    800036d2:	fd4618e3          	bne	a2,s4,800036a2 <balloc+0xee>
    800036d6:	b759                	j	8000365c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800036d8:	00005517          	auipc	a0,0x5
    800036dc:	ed850513          	addi	a0,a0,-296 # 800085b0 <syscalls+0x120>
    800036e0:	ffffd097          	auipc	ra,0xffffd
    800036e4:	ea8080e7          	jalr	-344(ra) # 80000588 <printf>
  return 0;
    800036e8:	4481                	li	s1,0
    800036ea:	bf99                	j	80003640 <balloc+0x8c>

00000000800036ec <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800036ec:	7179                	addi	sp,sp,-48
    800036ee:	f406                	sd	ra,40(sp)
    800036f0:	f022                	sd	s0,32(sp)
    800036f2:	ec26                	sd	s1,24(sp)
    800036f4:	e84a                	sd	s2,16(sp)
    800036f6:	e44e                	sd	s3,8(sp)
    800036f8:	e052                	sd	s4,0(sp)
    800036fa:	1800                	addi	s0,sp,48
    800036fc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800036fe:	47ad                	li	a5,11
    80003700:	02b7e763          	bltu	a5,a1,8000372e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003704:	02059493          	slli	s1,a1,0x20
    80003708:	9081                	srli	s1,s1,0x20
    8000370a:	048a                	slli	s1,s1,0x2
    8000370c:	94aa                	add	s1,s1,a0
    8000370e:	0504a903          	lw	s2,80(s1)
    80003712:	06091e63          	bnez	s2,8000378e <bmap+0xa2>
      addr = balloc(ip->dev);
    80003716:	4108                	lw	a0,0(a0)
    80003718:	00000097          	auipc	ra,0x0
    8000371c:	e9c080e7          	jalr	-356(ra) # 800035b4 <balloc>
    80003720:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003724:	06090563          	beqz	s2,8000378e <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003728:	0524a823          	sw	s2,80(s1)
    8000372c:	a08d                	j	8000378e <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000372e:	ff45849b          	addiw	s1,a1,-12
    80003732:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003736:	0ff00793          	li	a5,255
    8000373a:	08e7e563          	bltu	a5,a4,800037c4 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000373e:	08052903          	lw	s2,128(a0)
    80003742:	00091d63          	bnez	s2,8000375c <bmap+0x70>
      addr = balloc(ip->dev);
    80003746:	4108                	lw	a0,0(a0)
    80003748:	00000097          	auipc	ra,0x0
    8000374c:	e6c080e7          	jalr	-404(ra) # 800035b4 <balloc>
    80003750:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003754:	02090d63          	beqz	s2,8000378e <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003758:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000375c:	85ca                	mv	a1,s2
    8000375e:	0009a503          	lw	a0,0(s3)
    80003762:	00000097          	auipc	ra,0x0
    80003766:	b90080e7          	jalr	-1136(ra) # 800032f2 <bread>
    8000376a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000376c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003770:	02049593          	slli	a1,s1,0x20
    80003774:	9181                	srli	a1,a1,0x20
    80003776:	058a                	slli	a1,a1,0x2
    80003778:	00b784b3          	add	s1,a5,a1
    8000377c:	0004a903          	lw	s2,0(s1)
    80003780:	02090063          	beqz	s2,800037a0 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003784:	8552                	mv	a0,s4
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	c9c080e7          	jalr	-868(ra) # 80003422 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000378e:	854a                	mv	a0,s2
    80003790:	70a2                	ld	ra,40(sp)
    80003792:	7402                	ld	s0,32(sp)
    80003794:	64e2                	ld	s1,24(sp)
    80003796:	6942                	ld	s2,16(sp)
    80003798:	69a2                	ld	s3,8(sp)
    8000379a:	6a02                	ld	s4,0(sp)
    8000379c:	6145                	addi	sp,sp,48
    8000379e:	8082                	ret
      addr = balloc(ip->dev);
    800037a0:	0009a503          	lw	a0,0(s3)
    800037a4:	00000097          	auipc	ra,0x0
    800037a8:	e10080e7          	jalr	-496(ra) # 800035b4 <balloc>
    800037ac:	0005091b          	sext.w	s2,a0
      if(addr){
    800037b0:	fc090ae3          	beqz	s2,80003784 <bmap+0x98>
        a[bn] = addr;
    800037b4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800037b8:	8552                	mv	a0,s4
    800037ba:	00001097          	auipc	ra,0x1
    800037be:	eec080e7          	jalr	-276(ra) # 800046a6 <log_write>
    800037c2:	b7c9                	j	80003784 <bmap+0x98>
  panic("bmap: out of range");
    800037c4:	00005517          	auipc	a0,0x5
    800037c8:	e0450513          	addi	a0,a0,-508 # 800085c8 <syscalls+0x138>
    800037cc:	ffffd097          	auipc	ra,0xffffd
    800037d0:	d72080e7          	jalr	-654(ra) # 8000053e <panic>

00000000800037d4 <iget>:
{
    800037d4:	7179                	addi	sp,sp,-48
    800037d6:	f406                	sd	ra,40(sp)
    800037d8:	f022                	sd	s0,32(sp)
    800037da:	ec26                	sd	s1,24(sp)
    800037dc:	e84a                	sd	s2,16(sp)
    800037de:	e44e                	sd	s3,8(sp)
    800037e0:	e052                	sd	s4,0(sp)
    800037e2:	1800                	addi	s0,sp,48
    800037e4:	89aa                	mv	s3,a0
    800037e6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800037e8:	0001d517          	auipc	a0,0x1d
    800037ec:	ef050513          	addi	a0,a0,-272 # 800206d8 <itable>
    800037f0:	ffffd097          	auipc	ra,0xffffd
    800037f4:	3e6080e7          	jalr	998(ra) # 80000bd6 <acquire>
  empty = 0;
    800037f8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800037fa:	0001d497          	auipc	s1,0x1d
    800037fe:	ef648493          	addi	s1,s1,-266 # 800206f0 <itable+0x18>
    80003802:	0001f697          	auipc	a3,0x1f
    80003806:	97e68693          	addi	a3,a3,-1666 # 80022180 <log>
    8000380a:	a039                	j	80003818 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000380c:	02090b63          	beqz	s2,80003842 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003810:	08848493          	addi	s1,s1,136
    80003814:	02d48a63          	beq	s1,a3,80003848 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003818:	449c                	lw	a5,8(s1)
    8000381a:	fef059e3          	blez	a5,8000380c <iget+0x38>
    8000381e:	4098                	lw	a4,0(s1)
    80003820:	ff3716e3          	bne	a4,s3,8000380c <iget+0x38>
    80003824:	40d8                	lw	a4,4(s1)
    80003826:	ff4713e3          	bne	a4,s4,8000380c <iget+0x38>
      ip->ref++;
    8000382a:	2785                	addiw	a5,a5,1
    8000382c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000382e:	0001d517          	auipc	a0,0x1d
    80003832:	eaa50513          	addi	a0,a0,-342 # 800206d8 <itable>
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	454080e7          	jalr	1108(ra) # 80000c8a <release>
      return ip;
    8000383e:	8926                	mv	s2,s1
    80003840:	a03d                	j	8000386e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003842:	f7f9                	bnez	a5,80003810 <iget+0x3c>
    80003844:	8926                	mv	s2,s1
    80003846:	b7e9                	j	80003810 <iget+0x3c>
  if(empty == 0)
    80003848:	02090c63          	beqz	s2,80003880 <iget+0xac>
  ip->dev = dev;
    8000384c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003850:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003854:	4785                	li	a5,1
    80003856:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000385a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000385e:	0001d517          	auipc	a0,0x1d
    80003862:	e7a50513          	addi	a0,a0,-390 # 800206d8 <itable>
    80003866:	ffffd097          	auipc	ra,0xffffd
    8000386a:	424080e7          	jalr	1060(ra) # 80000c8a <release>
}
    8000386e:	854a                	mv	a0,s2
    80003870:	70a2                	ld	ra,40(sp)
    80003872:	7402                	ld	s0,32(sp)
    80003874:	64e2                	ld	s1,24(sp)
    80003876:	6942                	ld	s2,16(sp)
    80003878:	69a2                	ld	s3,8(sp)
    8000387a:	6a02                	ld	s4,0(sp)
    8000387c:	6145                	addi	sp,sp,48
    8000387e:	8082                	ret
    panic("iget: no inodes");
    80003880:	00005517          	auipc	a0,0x5
    80003884:	d6050513          	addi	a0,a0,-672 # 800085e0 <syscalls+0x150>
    80003888:	ffffd097          	auipc	ra,0xffffd
    8000388c:	cb6080e7          	jalr	-842(ra) # 8000053e <panic>

0000000080003890 <fsinit>:
fsinit(int dev) {
    80003890:	7179                	addi	sp,sp,-48
    80003892:	f406                	sd	ra,40(sp)
    80003894:	f022                	sd	s0,32(sp)
    80003896:	ec26                	sd	s1,24(sp)
    80003898:	e84a                	sd	s2,16(sp)
    8000389a:	e44e                	sd	s3,8(sp)
    8000389c:	1800                	addi	s0,sp,48
    8000389e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800038a0:	4585                	li	a1,1
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	a50080e7          	jalr	-1456(ra) # 800032f2 <bread>
    800038aa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800038ac:	0001d997          	auipc	s3,0x1d
    800038b0:	e0c98993          	addi	s3,s3,-500 # 800206b8 <sb>
    800038b4:	02000613          	li	a2,32
    800038b8:	05850593          	addi	a1,a0,88
    800038bc:	854e                	mv	a0,s3
    800038be:	ffffd097          	auipc	ra,0xffffd
    800038c2:	470080e7          	jalr	1136(ra) # 80000d2e <memmove>
  brelse(bp);
    800038c6:	8526                	mv	a0,s1
    800038c8:	00000097          	auipc	ra,0x0
    800038cc:	b5a080e7          	jalr	-1190(ra) # 80003422 <brelse>
  if(sb.magic != FSMAGIC)
    800038d0:	0009a703          	lw	a4,0(s3)
    800038d4:	102037b7          	lui	a5,0x10203
    800038d8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800038dc:	02f71263          	bne	a4,a5,80003900 <fsinit+0x70>
  initlog(dev, &sb);
    800038e0:	0001d597          	auipc	a1,0x1d
    800038e4:	dd858593          	addi	a1,a1,-552 # 800206b8 <sb>
    800038e8:	854a                	mv	a0,s2
    800038ea:	00001097          	auipc	ra,0x1
    800038ee:	b40080e7          	jalr	-1216(ra) # 8000442a <initlog>
}
    800038f2:	70a2                	ld	ra,40(sp)
    800038f4:	7402                	ld	s0,32(sp)
    800038f6:	64e2                	ld	s1,24(sp)
    800038f8:	6942                	ld	s2,16(sp)
    800038fa:	69a2                	ld	s3,8(sp)
    800038fc:	6145                	addi	sp,sp,48
    800038fe:	8082                	ret
    panic("invalid file system");
    80003900:	00005517          	auipc	a0,0x5
    80003904:	cf050513          	addi	a0,a0,-784 # 800085f0 <syscalls+0x160>
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	c36080e7          	jalr	-970(ra) # 8000053e <panic>

0000000080003910 <iinit>:
{
    80003910:	7179                	addi	sp,sp,-48
    80003912:	f406                	sd	ra,40(sp)
    80003914:	f022                	sd	s0,32(sp)
    80003916:	ec26                	sd	s1,24(sp)
    80003918:	e84a                	sd	s2,16(sp)
    8000391a:	e44e                	sd	s3,8(sp)
    8000391c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000391e:	00005597          	auipc	a1,0x5
    80003922:	cea58593          	addi	a1,a1,-790 # 80008608 <syscalls+0x178>
    80003926:	0001d517          	auipc	a0,0x1d
    8000392a:	db250513          	addi	a0,a0,-590 # 800206d8 <itable>
    8000392e:	ffffd097          	auipc	ra,0xffffd
    80003932:	218080e7          	jalr	536(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003936:	0001d497          	auipc	s1,0x1d
    8000393a:	dca48493          	addi	s1,s1,-566 # 80020700 <itable+0x28>
    8000393e:	0001f997          	auipc	s3,0x1f
    80003942:	85298993          	addi	s3,s3,-1966 # 80022190 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003946:	00005917          	auipc	s2,0x5
    8000394a:	cca90913          	addi	s2,s2,-822 # 80008610 <syscalls+0x180>
    8000394e:	85ca                	mv	a1,s2
    80003950:	8526                	mv	a0,s1
    80003952:	00001097          	auipc	ra,0x1
    80003956:	e3a080e7          	jalr	-454(ra) # 8000478c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000395a:	08848493          	addi	s1,s1,136
    8000395e:	ff3498e3          	bne	s1,s3,8000394e <iinit+0x3e>
}
    80003962:	70a2                	ld	ra,40(sp)
    80003964:	7402                	ld	s0,32(sp)
    80003966:	64e2                	ld	s1,24(sp)
    80003968:	6942                	ld	s2,16(sp)
    8000396a:	69a2                	ld	s3,8(sp)
    8000396c:	6145                	addi	sp,sp,48
    8000396e:	8082                	ret

0000000080003970 <ialloc>:
{
    80003970:	715d                	addi	sp,sp,-80
    80003972:	e486                	sd	ra,72(sp)
    80003974:	e0a2                	sd	s0,64(sp)
    80003976:	fc26                	sd	s1,56(sp)
    80003978:	f84a                	sd	s2,48(sp)
    8000397a:	f44e                	sd	s3,40(sp)
    8000397c:	f052                	sd	s4,32(sp)
    8000397e:	ec56                	sd	s5,24(sp)
    80003980:	e85a                	sd	s6,16(sp)
    80003982:	e45e                	sd	s7,8(sp)
    80003984:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003986:	0001d717          	auipc	a4,0x1d
    8000398a:	d3e72703          	lw	a4,-706(a4) # 800206c4 <sb+0xc>
    8000398e:	4785                	li	a5,1
    80003990:	04e7fa63          	bgeu	a5,a4,800039e4 <ialloc+0x74>
    80003994:	8aaa                	mv	s5,a0
    80003996:	8bae                	mv	s7,a1
    80003998:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000399a:	0001da17          	auipc	s4,0x1d
    8000399e:	d1ea0a13          	addi	s4,s4,-738 # 800206b8 <sb>
    800039a2:	00048b1b          	sext.w	s6,s1
    800039a6:	0044d793          	srli	a5,s1,0x4
    800039aa:	018a2583          	lw	a1,24(s4)
    800039ae:	9dbd                	addw	a1,a1,a5
    800039b0:	8556                	mv	a0,s5
    800039b2:	00000097          	auipc	ra,0x0
    800039b6:	940080e7          	jalr	-1728(ra) # 800032f2 <bread>
    800039ba:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800039bc:	05850993          	addi	s3,a0,88
    800039c0:	00f4f793          	andi	a5,s1,15
    800039c4:	079a                	slli	a5,a5,0x6
    800039c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800039c8:	00099783          	lh	a5,0(s3)
    800039cc:	c3a1                	beqz	a5,80003a0c <ialloc+0x9c>
    brelse(bp);
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	a54080e7          	jalr	-1452(ra) # 80003422 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800039d6:	0485                	addi	s1,s1,1
    800039d8:	00ca2703          	lw	a4,12(s4)
    800039dc:	0004879b          	sext.w	a5,s1
    800039e0:	fce7e1e3          	bltu	a5,a4,800039a2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    800039e4:	00005517          	auipc	a0,0x5
    800039e8:	c3450513          	addi	a0,a0,-972 # 80008618 <syscalls+0x188>
    800039ec:	ffffd097          	auipc	ra,0xffffd
    800039f0:	b9c080e7          	jalr	-1124(ra) # 80000588 <printf>
  return 0;
    800039f4:	4501                	li	a0,0
}
    800039f6:	60a6                	ld	ra,72(sp)
    800039f8:	6406                	ld	s0,64(sp)
    800039fa:	74e2                	ld	s1,56(sp)
    800039fc:	7942                	ld	s2,48(sp)
    800039fe:	79a2                	ld	s3,40(sp)
    80003a00:	7a02                	ld	s4,32(sp)
    80003a02:	6ae2                	ld	s5,24(sp)
    80003a04:	6b42                	ld	s6,16(sp)
    80003a06:	6ba2                	ld	s7,8(sp)
    80003a08:	6161                	addi	sp,sp,80
    80003a0a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003a0c:	04000613          	li	a2,64
    80003a10:	4581                	li	a1,0
    80003a12:	854e                	mv	a0,s3
    80003a14:	ffffd097          	auipc	ra,0xffffd
    80003a18:	2be080e7          	jalr	702(ra) # 80000cd2 <memset>
      dip->type = type;
    80003a1c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003a20:	854a                	mv	a0,s2
    80003a22:	00001097          	auipc	ra,0x1
    80003a26:	c84080e7          	jalr	-892(ra) # 800046a6 <log_write>
      brelse(bp);
    80003a2a:	854a                	mv	a0,s2
    80003a2c:	00000097          	auipc	ra,0x0
    80003a30:	9f6080e7          	jalr	-1546(ra) # 80003422 <brelse>
      return iget(dev, inum);
    80003a34:	85da                	mv	a1,s6
    80003a36:	8556                	mv	a0,s5
    80003a38:	00000097          	auipc	ra,0x0
    80003a3c:	d9c080e7          	jalr	-612(ra) # 800037d4 <iget>
    80003a40:	bf5d                	j	800039f6 <ialloc+0x86>

0000000080003a42 <iupdate>:
{
    80003a42:	1101                	addi	sp,sp,-32
    80003a44:	ec06                	sd	ra,24(sp)
    80003a46:	e822                	sd	s0,16(sp)
    80003a48:	e426                	sd	s1,8(sp)
    80003a4a:	e04a                	sd	s2,0(sp)
    80003a4c:	1000                	addi	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003a50:	415c                	lw	a5,4(a0)
    80003a52:	0047d79b          	srliw	a5,a5,0x4
    80003a56:	0001d597          	auipc	a1,0x1d
    80003a5a:	c7a5a583          	lw	a1,-902(a1) # 800206d0 <sb+0x18>
    80003a5e:	9dbd                	addw	a1,a1,a5
    80003a60:	4108                	lw	a0,0(a0)
    80003a62:	00000097          	auipc	ra,0x0
    80003a66:	890080e7          	jalr	-1904(ra) # 800032f2 <bread>
    80003a6a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a6c:	05850793          	addi	a5,a0,88
    80003a70:	40c8                	lw	a0,4(s1)
    80003a72:	893d                	andi	a0,a0,15
    80003a74:	051a                	slli	a0,a0,0x6
    80003a76:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003a78:	04449703          	lh	a4,68(s1)
    80003a7c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003a80:	04649703          	lh	a4,70(s1)
    80003a84:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003a88:	04849703          	lh	a4,72(s1)
    80003a8c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003a90:	04a49703          	lh	a4,74(s1)
    80003a94:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003a98:	44f8                	lw	a4,76(s1)
    80003a9a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a9c:	03400613          	li	a2,52
    80003aa0:	05048593          	addi	a1,s1,80
    80003aa4:	0531                	addi	a0,a0,12
    80003aa6:	ffffd097          	auipc	ra,0xffffd
    80003aaa:	288080e7          	jalr	648(ra) # 80000d2e <memmove>
  log_write(bp);
    80003aae:	854a                	mv	a0,s2
    80003ab0:	00001097          	auipc	ra,0x1
    80003ab4:	bf6080e7          	jalr	-1034(ra) # 800046a6 <log_write>
  brelse(bp);
    80003ab8:	854a                	mv	a0,s2
    80003aba:	00000097          	auipc	ra,0x0
    80003abe:	968080e7          	jalr	-1688(ra) # 80003422 <brelse>
}
    80003ac2:	60e2                	ld	ra,24(sp)
    80003ac4:	6442                	ld	s0,16(sp)
    80003ac6:	64a2                	ld	s1,8(sp)
    80003ac8:	6902                	ld	s2,0(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret

0000000080003ace <idup>:
{
    80003ace:	1101                	addi	sp,sp,-32
    80003ad0:	ec06                	sd	ra,24(sp)
    80003ad2:	e822                	sd	s0,16(sp)
    80003ad4:	e426                	sd	s1,8(sp)
    80003ad6:	1000                	addi	s0,sp,32
    80003ad8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003ada:	0001d517          	auipc	a0,0x1d
    80003ade:	bfe50513          	addi	a0,a0,-1026 # 800206d8 <itable>
    80003ae2:	ffffd097          	auipc	ra,0xffffd
    80003ae6:	0f4080e7          	jalr	244(ra) # 80000bd6 <acquire>
  ip->ref++;
    80003aea:	449c                	lw	a5,8(s1)
    80003aec:	2785                	addiw	a5,a5,1
    80003aee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003af0:	0001d517          	auipc	a0,0x1d
    80003af4:	be850513          	addi	a0,a0,-1048 # 800206d8 <itable>
    80003af8:	ffffd097          	auipc	ra,0xffffd
    80003afc:	192080e7          	jalr	402(ra) # 80000c8a <release>
}
    80003b00:	8526                	mv	a0,s1
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6105                	addi	sp,sp,32
    80003b0a:	8082                	ret

0000000080003b0c <ilock>:
{
    80003b0c:	1101                	addi	sp,sp,-32
    80003b0e:	ec06                	sd	ra,24(sp)
    80003b10:	e822                	sd	s0,16(sp)
    80003b12:	e426                	sd	s1,8(sp)
    80003b14:	e04a                	sd	s2,0(sp)
    80003b16:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003b18:	c115                	beqz	a0,80003b3c <ilock+0x30>
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	451c                	lw	a5,8(a0)
    80003b1e:	00f05f63          	blez	a5,80003b3c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003b22:	0541                	addi	a0,a0,16
    80003b24:	00001097          	auipc	ra,0x1
    80003b28:	ca2080e7          	jalr	-862(ra) # 800047c6 <acquiresleep>
  if(ip->valid == 0){
    80003b2c:	40bc                	lw	a5,64(s1)
    80003b2e:	cf99                	beqz	a5,80003b4c <ilock+0x40>
}
    80003b30:	60e2                	ld	ra,24(sp)
    80003b32:	6442                	ld	s0,16(sp)
    80003b34:	64a2                	ld	s1,8(sp)
    80003b36:	6902                	ld	s2,0(sp)
    80003b38:	6105                	addi	sp,sp,32
    80003b3a:	8082                	ret
    panic("ilock");
    80003b3c:	00005517          	auipc	a0,0x5
    80003b40:	af450513          	addi	a0,a0,-1292 # 80008630 <syscalls+0x1a0>
    80003b44:	ffffd097          	auipc	ra,0xffffd
    80003b48:	9fa080e7          	jalr	-1542(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b4c:	40dc                	lw	a5,4(s1)
    80003b4e:	0047d79b          	srliw	a5,a5,0x4
    80003b52:	0001d597          	auipc	a1,0x1d
    80003b56:	b7e5a583          	lw	a1,-1154(a1) # 800206d0 <sb+0x18>
    80003b5a:	9dbd                	addw	a1,a1,a5
    80003b5c:	4088                	lw	a0,0(s1)
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	794080e7          	jalr	1940(ra) # 800032f2 <bread>
    80003b66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003b68:	05850593          	addi	a1,a0,88
    80003b6c:	40dc                	lw	a5,4(s1)
    80003b6e:	8bbd                	andi	a5,a5,15
    80003b70:	079a                	slli	a5,a5,0x6
    80003b72:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003b74:	00059783          	lh	a5,0(a1)
    80003b78:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003b7c:	00259783          	lh	a5,2(a1)
    80003b80:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b84:	00459783          	lh	a5,4(a1)
    80003b88:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b8c:	00659783          	lh	a5,6(a1)
    80003b90:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b94:	459c                	lw	a5,8(a1)
    80003b96:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b98:	03400613          	li	a2,52
    80003b9c:	05b1                	addi	a1,a1,12
    80003b9e:	05048513          	addi	a0,s1,80
    80003ba2:	ffffd097          	auipc	ra,0xffffd
    80003ba6:	18c080e7          	jalr	396(ra) # 80000d2e <memmove>
    brelse(bp);
    80003baa:	854a                	mv	a0,s2
    80003bac:	00000097          	auipc	ra,0x0
    80003bb0:	876080e7          	jalr	-1930(ra) # 80003422 <brelse>
    ip->valid = 1;
    80003bb4:	4785                	li	a5,1
    80003bb6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003bb8:	04449783          	lh	a5,68(s1)
    80003bbc:	fbb5                	bnez	a5,80003b30 <ilock+0x24>
      panic("ilock: no type");
    80003bbe:	00005517          	auipc	a0,0x5
    80003bc2:	a7a50513          	addi	a0,a0,-1414 # 80008638 <syscalls+0x1a8>
    80003bc6:	ffffd097          	auipc	ra,0xffffd
    80003bca:	978080e7          	jalr	-1672(ra) # 8000053e <panic>

0000000080003bce <iunlock>:
{
    80003bce:	1101                	addi	sp,sp,-32
    80003bd0:	ec06                	sd	ra,24(sp)
    80003bd2:	e822                	sd	s0,16(sp)
    80003bd4:	e426                	sd	s1,8(sp)
    80003bd6:	e04a                	sd	s2,0(sp)
    80003bd8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003bda:	c905                	beqz	a0,80003c0a <iunlock+0x3c>
    80003bdc:	84aa                	mv	s1,a0
    80003bde:	01050913          	addi	s2,a0,16
    80003be2:	854a                	mv	a0,s2
    80003be4:	00001097          	auipc	ra,0x1
    80003be8:	c7c080e7          	jalr	-900(ra) # 80004860 <holdingsleep>
    80003bec:	cd19                	beqz	a0,80003c0a <iunlock+0x3c>
    80003bee:	449c                	lw	a5,8(s1)
    80003bf0:	00f05d63          	blez	a5,80003c0a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003bf4:	854a                	mv	a0,s2
    80003bf6:	00001097          	auipc	ra,0x1
    80003bfa:	c26080e7          	jalr	-986(ra) # 8000481c <releasesleep>
}
    80003bfe:	60e2                	ld	ra,24(sp)
    80003c00:	6442                	ld	s0,16(sp)
    80003c02:	64a2                	ld	s1,8(sp)
    80003c04:	6902                	ld	s2,0(sp)
    80003c06:	6105                	addi	sp,sp,32
    80003c08:	8082                	ret
    panic("iunlock");
    80003c0a:	00005517          	auipc	a0,0x5
    80003c0e:	a3e50513          	addi	a0,a0,-1474 # 80008648 <syscalls+0x1b8>
    80003c12:	ffffd097          	auipc	ra,0xffffd
    80003c16:	92c080e7          	jalr	-1748(ra) # 8000053e <panic>

0000000080003c1a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003c1a:	7179                	addi	sp,sp,-48
    80003c1c:	f406                	sd	ra,40(sp)
    80003c1e:	f022                	sd	s0,32(sp)
    80003c20:	ec26                	sd	s1,24(sp)
    80003c22:	e84a                	sd	s2,16(sp)
    80003c24:	e44e                	sd	s3,8(sp)
    80003c26:	e052                	sd	s4,0(sp)
    80003c28:	1800                	addi	s0,sp,48
    80003c2a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003c2c:	05050493          	addi	s1,a0,80
    80003c30:	08050913          	addi	s2,a0,128
    80003c34:	a021                	j	80003c3c <itrunc+0x22>
    80003c36:	0491                	addi	s1,s1,4
    80003c38:	01248d63          	beq	s1,s2,80003c52 <itrunc+0x38>
    if(ip->addrs[i]){
    80003c3c:	408c                	lw	a1,0(s1)
    80003c3e:	dde5                	beqz	a1,80003c36 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003c40:	0009a503          	lw	a0,0(s3)
    80003c44:	00000097          	auipc	ra,0x0
    80003c48:	8f4080e7          	jalr	-1804(ra) # 80003538 <bfree>
      ip->addrs[i] = 0;
    80003c4c:	0004a023          	sw	zero,0(s1)
    80003c50:	b7dd                	j	80003c36 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003c52:	0809a583          	lw	a1,128(s3)
    80003c56:	e185                	bnez	a1,80003c76 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c58:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c5c:	854e                	mv	a0,s3
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	de4080e7          	jalr	-540(ra) # 80003a42 <iupdate>
}
    80003c66:	70a2                	ld	ra,40(sp)
    80003c68:	7402                	ld	s0,32(sp)
    80003c6a:	64e2                	ld	s1,24(sp)
    80003c6c:	6942                	ld	s2,16(sp)
    80003c6e:	69a2                	ld	s3,8(sp)
    80003c70:	6a02                	ld	s4,0(sp)
    80003c72:	6145                	addi	sp,sp,48
    80003c74:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003c76:	0009a503          	lw	a0,0(s3)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	678080e7          	jalr	1656(ra) # 800032f2 <bread>
    80003c82:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003c84:	05850493          	addi	s1,a0,88
    80003c88:	45850913          	addi	s2,a0,1112
    80003c8c:	a021                	j	80003c94 <itrunc+0x7a>
    80003c8e:	0491                	addi	s1,s1,4
    80003c90:	01248b63          	beq	s1,s2,80003ca6 <itrunc+0x8c>
      if(a[j])
    80003c94:	408c                	lw	a1,0(s1)
    80003c96:	dde5                	beqz	a1,80003c8e <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003c98:	0009a503          	lw	a0,0(s3)
    80003c9c:	00000097          	auipc	ra,0x0
    80003ca0:	89c080e7          	jalr	-1892(ra) # 80003538 <bfree>
    80003ca4:	b7ed                	j	80003c8e <itrunc+0x74>
    brelse(bp);
    80003ca6:	8552                	mv	a0,s4
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	77a080e7          	jalr	1914(ra) # 80003422 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003cb0:	0809a583          	lw	a1,128(s3)
    80003cb4:	0009a503          	lw	a0,0(s3)
    80003cb8:	00000097          	auipc	ra,0x0
    80003cbc:	880080e7          	jalr	-1920(ra) # 80003538 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003cc0:	0809a023          	sw	zero,128(s3)
    80003cc4:	bf51                	j	80003c58 <itrunc+0x3e>

0000000080003cc6 <iput>:
{
    80003cc6:	1101                	addi	sp,sp,-32
    80003cc8:	ec06                	sd	ra,24(sp)
    80003cca:	e822                	sd	s0,16(sp)
    80003ccc:	e426                	sd	s1,8(sp)
    80003cce:	e04a                	sd	s2,0(sp)
    80003cd0:	1000                	addi	s0,sp,32
    80003cd2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cd4:	0001d517          	auipc	a0,0x1d
    80003cd8:	a0450513          	addi	a0,a0,-1532 # 800206d8 <itable>
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	efa080e7          	jalr	-262(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ce4:	4498                	lw	a4,8(s1)
    80003ce6:	4785                	li	a5,1
    80003ce8:	02f70363          	beq	a4,a5,80003d0e <iput+0x48>
  ip->ref--;
    80003cec:	449c                	lw	a5,8(s1)
    80003cee:	37fd                	addiw	a5,a5,-1
    80003cf0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cf2:	0001d517          	auipc	a0,0x1d
    80003cf6:	9e650513          	addi	a0,a0,-1562 # 800206d8 <itable>
    80003cfa:	ffffd097          	auipc	ra,0xffffd
    80003cfe:	f90080e7          	jalr	-112(ra) # 80000c8a <release>
}
    80003d02:	60e2                	ld	ra,24(sp)
    80003d04:	6442                	ld	s0,16(sp)
    80003d06:	64a2                	ld	s1,8(sp)
    80003d08:	6902                	ld	s2,0(sp)
    80003d0a:	6105                	addi	sp,sp,32
    80003d0c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003d0e:	40bc                	lw	a5,64(s1)
    80003d10:	dff1                	beqz	a5,80003cec <iput+0x26>
    80003d12:	04a49783          	lh	a5,74(s1)
    80003d16:	fbf9                	bnez	a5,80003cec <iput+0x26>
    acquiresleep(&ip->lock);
    80003d18:	01048913          	addi	s2,s1,16
    80003d1c:	854a                	mv	a0,s2
    80003d1e:	00001097          	auipc	ra,0x1
    80003d22:	aa8080e7          	jalr	-1368(ra) # 800047c6 <acquiresleep>
    release(&itable.lock);
    80003d26:	0001d517          	auipc	a0,0x1d
    80003d2a:	9b250513          	addi	a0,a0,-1614 # 800206d8 <itable>
    80003d2e:	ffffd097          	auipc	ra,0xffffd
    80003d32:	f5c080e7          	jalr	-164(ra) # 80000c8a <release>
    itrunc(ip);
    80003d36:	8526                	mv	a0,s1
    80003d38:	00000097          	auipc	ra,0x0
    80003d3c:	ee2080e7          	jalr	-286(ra) # 80003c1a <itrunc>
    ip->type = 0;
    80003d40:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003d44:	8526                	mv	a0,s1
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	cfc080e7          	jalr	-772(ra) # 80003a42 <iupdate>
    ip->valid = 0;
    80003d4e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d52:	854a                	mv	a0,s2
    80003d54:	00001097          	auipc	ra,0x1
    80003d58:	ac8080e7          	jalr	-1336(ra) # 8000481c <releasesleep>
    acquire(&itable.lock);
    80003d5c:	0001d517          	auipc	a0,0x1d
    80003d60:	97c50513          	addi	a0,a0,-1668 # 800206d8 <itable>
    80003d64:	ffffd097          	auipc	ra,0xffffd
    80003d68:	e72080e7          	jalr	-398(ra) # 80000bd6 <acquire>
    80003d6c:	b741                	j	80003cec <iput+0x26>

0000000080003d6e <iunlockput>:
{
    80003d6e:	1101                	addi	sp,sp,-32
    80003d70:	ec06                	sd	ra,24(sp)
    80003d72:	e822                	sd	s0,16(sp)
    80003d74:	e426                	sd	s1,8(sp)
    80003d76:	1000                	addi	s0,sp,32
    80003d78:	84aa                	mv	s1,a0
  iunlock(ip);
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	e54080e7          	jalr	-428(ra) # 80003bce <iunlock>
  iput(ip);
    80003d82:	8526                	mv	a0,s1
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	f42080e7          	jalr	-190(ra) # 80003cc6 <iput>
}
    80003d8c:	60e2                	ld	ra,24(sp)
    80003d8e:	6442                	ld	s0,16(sp)
    80003d90:	64a2                	ld	s1,8(sp)
    80003d92:	6105                	addi	sp,sp,32
    80003d94:	8082                	ret

0000000080003d96 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003d96:	1141                	addi	sp,sp,-16
    80003d98:	e422                	sd	s0,8(sp)
    80003d9a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003d9c:	411c                	lw	a5,0(a0)
    80003d9e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003da0:	415c                	lw	a5,4(a0)
    80003da2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003da4:	04451783          	lh	a5,68(a0)
    80003da8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003dac:	04a51783          	lh	a5,74(a0)
    80003db0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003db4:	04c56783          	lwu	a5,76(a0)
    80003db8:	e99c                	sd	a5,16(a1)
}
    80003dba:	6422                	ld	s0,8(sp)
    80003dbc:	0141                	addi	sp,sp,16
    80003dbe:	8082                	ret

0000000080003dc0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003dc0:	457c                	lw	a5,76(a0)
    80003dc2:	0ed7e963          	bltu	a5,a3,80003eb4 <readi+0xf4>
{
    80003dc6:	7159                	addi	sp,sp,-112
    80003dc8:	f486                	sd	ra,104(sp)
    80003dca:	f0a2                	sd	s0,96(sp)
    80003dcc:	eca6                	sd	s1,88(sp)
    80003dce:	e8ca                	sd	s2,80(sp)
    80003dd0:	e4ce                	sd	s3,72(sp)
    80003dd2:	e0d2                	sd	s4,64(sp)
    80003dd4:	fc56                	sd	s5,56(sp)
    80003dd6:	f85a                	sd	s6,48(sp)
    80003dd8:	f45e                	sd	s7,40(sp)
    80003dda:	f062                	sd	s8,32(sp)
    80003ddc:	ec66                	sd	s9,24(sp)
    80003dde:	e86a                	sd	s10,16(sp)
    80003de0:	e46e                	sd	s11,8(sp)
    80003de2:	1880                	addi	s0,sp,112
    80003de4:	8b2a                	mv	s6,a0
    80003de6:	8bae                	mv	s7,a1
    80003de8:	8a32                	mv	s4,a2
    80003dea:	84b6                	mv	s1,a3
    80003dec:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003dee:	9f35                	addw	a4,a4,a3
    return 0;
    80003df0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003df2:	0ad76063          	bltu	a4,a3,80003e92 <readi+0xd2>
  if(off + n > ip->size)
    80003df6:	00e7f463          	bgeu	a5,a4,80003dfe <readi+0x3e>
    n = ip->size - off;
    80003dfa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003dfe:	0a0a8963          	beqz	s5,80003eb0 <readi+0xf0>
    80003e02:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e04:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e08:	5c7d                	li	s8,-1
    80003e0a:	a82d                	j	80003e44 <readi+0x84>
    80003e0c:	020d1d93          	slli	s11,s10,0x20
    80003e10:	020ddd93          	srli	s11,s11,0x20
    80003e14:	05890793          	addi	a5,s2,88
    80003e18:	86ee                	mv	a3,s11
    80003e1a:	963e                	add	a2,a2,a5
    80003e1c:	85d2                	mv	a1,s4
    80003e1e:	855e                	mv	a0,s7
    80003e20:	ffffe097          	auipc	ra,0xffffe
    80003e24:	7f4080e7          	jalr	2036(ra) # 80002614 <either_copyout>
    80003e28:	05850d63          	beq	a0,s8,80003e82 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e2c:	854a                	mv	a0,s2
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	5f4080e7          	jalr	1524(ra) # 80003422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e36:	013d09bb          	addw	s3,s10,s3
    80003e3a:	009d04bb          	addw	s1,s10,s1
    80003e3e:	9a6e                	add	s4,s4,s11
    80003e40:	0559f763          	bgeu	s3,s5,80003e8e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003e44:	00a4d59b          	srliw	a1,s1,0xa
    80003e48:	855a                	mv	a0,s6
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	8a2080e7          	jalr	-1886(ra) # 800036ec <bmap>
    80003e52:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003e56:	cd85                	beqz	a1,80003e8e <readi+0xce>
    bp = bread(ip->dev, addr);
    80003e58:	000b2503          	lw	a0,0(s6)
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	496080e7          	jalr	1174(ra) # 800032f2 <bread>
    80003e64:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e66:	3ff4f613          	andi	a2,s1,1023
    80003e6a:	40cc87bb          	subw	a5,s9,a2
    80003e6e:	413a873b          	subw	a4,s5,s3
    80003e72:	8d3e                	mv	s10,a5
    80003e74:	2781                	sext.w	a5,a5
    80003e76:	0007069b          	sext.w	a3,a4
    80003e7a:	f8f6f9e3          	bgeu	a3,a5,80003e0c <readi+0x4c>
    80003e7e:	8d3a                	mv	s10,a4
    80003e80:	b771                	j	80003e0c <readi+0x4c>
      brelse(bp);
    80003e82:	854a                	mv	a0,s2
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	59e080e7          	jalr	1438(ra) # 80003422 <brelse>
      tot = -1;
    80003e8c:	59fd                	li	s3,-1
  }
  return tot;
    80003e8e:	0009851b          	sext.w	a0,s3
}
    80003e92:	70a6                	ld	ra,104(sp)
    80003e94:	7406                	ld	s0,96(sp)
    80003e96:	64e6                	ld	s1,88(sp)
    80003e98:	6946                	ld	s2,80(sp)
    80003e9a:	69a6                	ld	s3,72(sp)
    80003e9c:	6a06                	ld	s4,64(sp)
    80003e9e:	7ae2                	ld	s5,56(sp)
    80003ea0:	7b42                	ld	s6,48(sp)
    80003ea2:	7ba2                	ld	s7,40(sp)
    80003ea4:	7c02                	ld	s8,32(sp)
    80003ea6:	6ce2                	ld	s9,24(sp)
    80003ea8:	6d42                	ld	s10,16(sp)
    80003eaa:	6da2                	ld	s11,8(sp)
    80003eac:	6165                	addi	sp,sp,112
    80003eae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003eb0:	89d6                	mv	s3,s5
    80003eb2:	bff1                	j	80003e8e <readi+0xce>
    return 0;
    80003eb4:	4501                	li	a0,0
}
    80003eb6:	8082                	ret

0000000080003eb8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003eb8:	457c                	lw	a5,76(a0)
    80003eba:	10d7e863          	bltu	a5,a3,80003fca <writei+0x112>
{
    80003ebe:	7159                	addi	sp,sp,-112
    80003ec0:	f486                	sd	ra,104(sp)
    80003ec2:	f0a2                	sd	s0,96(sp)
    80003ec4:	eca6                	sd	s1,88(sp)
    80003ec6:	e8ca                	sd	s2,80(sp)
    80003ec8:	e4ce                	sd	s3,72(sp)
    80003eca:	e0d2                	sd	s4,64(sp)
    80003ecc:	fc56                	sd	s5,56(sp)
    80003ece:	f85a                	sd	s6,48(sp)
    80003ed0:	f45e                	sd	s7,40(sp)
    80003ed2:	f062                	sd	s8,32(sp)
    80003ed4:	ec66                	sd	s9,24(sp)
    80003ed6:	e86a                	sd	s10,16(sp)
    80003ed8:	e46e                	sd	s11,8(sp)
    80003eda:	1880                	addi	s0,sp,112
    80003edc:	8aaa                	mv	s5,a0
    80003ede:	8bae                	mv	s7,a1
    80003ee0:	8a32                	mv	s4,a2
    80003ee2:	8936                	mv	s2,a3
    80003ee4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003ee6:	00e687bb          	addw	a5,a3,a4
    80003eea:	0ed7e263          	bltu	a5,a3,80003fce <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003eee:	00043737          	lui	a4,0x43
    80003ef2:	0ef76063          	bltu	a4,a5,80003fd2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003ef6:	0c0b0863          	beqz	s6,80003fc6 <writei+0x10e>
    80003efa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003efc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f00:	5c7d                	li	s8,-1
    80003f02:	a091                	j	80003f46 <writei+0x8e>
    80003f04:	020d1d93          	slli	s11,s10,0x20
    80003f08:	020ddd93          	srli	s11,s11,0x20
    80003f0c:	05848793          	addi	a5,s1,88
    80003f10:	86ee                	mv	a3,s11
    80003f12:	8652                	mv	a2,s4
    80003f14:	85de                	mv	a1,s7
    80003f16:	953e                	add	a0,a0,a5
    80003f18:	ffffe097          	auipc	ra,0xffffe
    80003f1c:	752080e7          	jalr	1874(ra) # 8000266a <either_copyin>
    80003f20:	07850263          	beq	a0,s8,80003f84 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f24:	8526                	mv	a0,s1
    80003f26:	00000097          	auipc	ra,0x0
    80003f2a:	780080e7          	jalr	1920(ra) # 800046a6 <log_write>
    brelse(bp);
    80003f2e:	8526                	mv	a0,s1
    80003f30:	fffff097          	auipc	ra,0xfffff
    80003f34:	4f2080e7          	jalr	1266(ra) # 80003422 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f38:	013d09bb          	addw	s3,s10,s3
    80003f3c:	012d093b          	addw	s2,s10,s2
    80003f40:	9a6e                	add	s4,s4,s11
    80003f42:	0569f663          	bgeu	s3,s6,80003f8e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003f46:	00a9559b          	srliw	a1,s2,0xa
    80003f4a:	8556                	mv	a0,s5
    80003f4c:	fffff097          	auipc	ra,0xfffff
    80003f50:	7a0080e7          	jalr	1952(ra) # 800036ec <bmap>
    80003f54:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003f58:	c99d                	beqz	a1,80003f8e <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003f5a:	000aa503          	lw	a0,0(s5)
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	394080e7          	jalr	916(ra) # 800032f2 <bread>
    80003f66:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f68:	3ff97513          	andi	a0,s2,1023
    80003f6c:	40ac87bb          	subw	a5,s9,a0
    80003f70:	413b073b          	subw	a4,s6,s3
    80003f74:	8d3e                	mv	s10,a5
    80003f76:	2781                	sext.w	a5,a5
    80003f78:	0007069b          	sext.w	a3,a4
    80003f7c:	f8f6f4e3          	bgeu	a3,a5,80003f04 <writei+0x4c>
    80003f80:	8d3a                	mv	s10,a4
    80003f82:	b749                	j	80003f04 <writei+0x4c>
      brelse(bp);
    80003f84:	8526                	mv	a0,s1
    80003f86:	fffff097          	auipc	ra,0xfffff
    80003f8a:	49c080e7          	jalr	1180(ra) # 80003422 <brelse>
  }

  if(off > ip->size)
    80003f8e:	04caa783          	lw	a5,76(s5)
    80003f92:	0127f463          	bgeu	a5,s2,80003f9a <writei+0xe2>
    ip->size = off;
    80003f96:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003f9a:	8556                	mv	a0,s5
    80003f9c:	00000097          	auipc	ra,0x0
    80003fa0:	aa6080e7          	jalr	-1370(ra) # 80003a42 <iupdate>

  return tot;
    80003fa4:	0009851b          	sext.w	a0,s3
}
    80003fa8:	70a6                	ld	ra,104(sp)
    80003faa:	7406                	ld	s0,96(sp)
    80003fac:	64e6                	ld	s1,88(sp)
    80003fae:	6946                	ld	s2,80(sp)
    80003fb0:	69a6                	ld	s3,72(sp)
    80003fb2:	6a06                	ld	s4,64(sp)
    80003fb4:	7ae2                	ld	s5,56(sp)
    80003fb6:	7b42                	ld	s6,48(sp)
    80003fb8:	7ba2                	ld	s7,40(sp)
    80003fba:	7c02                	ld	s8,32(sp)
    80003fbc:	6ce2                	ld	s9,24(sp)
    80003fbe:	6d42                	ld	s10,16(sp)
    80003fc0:	6da2                	ld	s11,8(sp)
    80003fc2:	6165                	addi	sp,sp,112
    80003fc4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003fc6:	89da                	mv	s3,s6
    80003fc8:	bfc9                	j	80003f9a <writei+0xe2>
    return -1;
    80003fca:	557d                	li	a0,-1
}
    80003fcc:	8082                	ret
    return -1;
    80003fce:	557d                	li	a0,-1
    80003fd0:	bfe1                	j	80003fa8 <writei+0xf0>
    return -1;
    80003fd2:	557d                	li	a0,-1
    80003fd4:	bfd1                	j	80003fa8 <writei+0xf0>

0000000080003fd6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003fd6:	1141                	addi	sp,sp,-16
    80003fd8:	e406                	sd	ra,8(sp)
    80003fda:	e022                	sd	s0,0(sp)
    80003fdc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003fde:	4639                	li	a2,14
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	dc2080e7          	jalr	-574(ra) # 80000da2 <strncmp>
}
    80003fe8:	60a2                	ld	ra,8(sp)
    80003fea:	6402                	ld	s0,0(sp)
    80003fec:	0141                	addi	sp,sp,16
    80003fee:	8082                	ret

0000000080003ff0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ff0:	7139                	addi	sp,sp,-64
    80003ff2:	fc06                	sd	ra,56(sp)
    80003ff4:	f822                	sd	s0,48(sp)
    80003ff6:	f426                	sd	s1,40(sp)
    80003ff8:	f04a                	sd	s2,32(sp)
    80003ffa:	ec4e                	sd	s3,24(sp)
    80003ffc:	e852                	sd	s4,16(sp)
    80003ffe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004000:	04451703          	lh	a4,68(a0)
    80004004:	4785                	li	a5,1
    80004006:	00f71a63          	bne	a4,a5,8000401a <dirlookup+0x2a>
    8000400a:	892a                	mv	s2,a0
    8000400c:	89ae                	mv	s3,a1
    8000400e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004010:	457c                	lw	a5,76(a0)
    80004012:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004014:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004016:	e79d                	bnez	a5,80004044 <dirlookup+0x54>
    80004018:	a8a5                	j	80004090 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000401a:	00004517          	auipc	a0,0x4
    8000401e:	63650513          	addi	a0,a0,1590 # 80008650 <syscalls+0x1c0>
    80004022:	ffffc097          	auipc	ra,0xffffc
    80004026:	51c080e7          	jalr	1308(ra) # 8000053e <panic>
      panic("dirlookup read");
    8000402a:	00004517          	auipc	a0,0x4
    8000402e:	63e50513          	addi	a0,a0,1598 # 80008668 <syscalls+0x1d8>
    80004032:	ffffc097          	auipc	ra,0xffffc
    80004036:	50c080e7          	jalr	1292(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000403a:	24c1                	addiw	s1,s1,16
    8000403c:	04c92783          	lw	a5,76(s2)
    80004040:	04f4f763          	bgeu	s1,a5,8000408e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004044:	4741                	li	a4,16
    80004046:	86a6                	mv	a3,s1
    80004048:	fc040613          	addi	a2,s0,-64
    8000404c:	4581                	li	a1,0
    8000404e:	854a                	mv	a0,s2
    80004050:	00000097          	auipc	ra,0x0
    80004054:	d70080e7          	jalr	-656(ra) # 80003dc0 <readi>
    80004058:	47c1                	li	a5,16
    8000405a:	fcf518e3          	bne	a0,a5,8000402a <dirlookup+0x3a>
    if(de.inum == 0)
    8000405e:	fc045783          	lhu	a5,-64(s0)
    80004062:	dfe1                	beqz	a5,8000403a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80004064:	fc240593          	addi	a1,s0,-62
    80004068:	854e                	mv	a0,s3
    8000406a:	00000097          	auipc	ra,0x0
    8000406e:	f6c080e7          	jalr	-148(ra) # 80003fd6 <namecmp>
    80004072:	f561                	bnez	a0,8000403a <dirlookup+0x4a>
      if(poff)
    80004074:	000a0463          	beqz	s4,8000407c <dirlookup+0x8c>
        *poff = off;
    80004078:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000407c:	fc045583          	lhu	a1,-64(s0)
    80004080:	00092503          	lw	a0,0(s2)
    80004084:	fffff097          	auipc	ra,0xfffff
    80004088:	750080e7          	jalr	1872(ra) # 800037d4 <iget>
    8000408c:	a011                	j	80004090 <dirlookup+0xa0>
  return 0;
    8000408e:	4501                	li	a0,0
}
    80004090:	70e2                	ld	ra,56(sp)
    80004092:	7442                	ld	s0,48(sp)
    80004094:	74a2                	ld	s1,40(sp)
    80004096:	7902                	ld	s2,32(sp)
    80004098:	69e2                	ld	s3,24(sp)
    8000409a:	6a42                	ld	s4,16(sp)
    8000409c:	6121                	addi	sp,sp,64
    8000409e:	8082                	ret

00000000800040a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040a0:	711d                	addi	sp,sp,-96
    800040a2:	ec86                	sd	ra,88(sp)
    800040a4:	e8a2                	sd	s0,80(sp)
    800040a6:	e4a6                	sd	s1,72(sp)
    800040a8:	e0ca                	sd	s2,64(sp)
    800040aa:	fc4e                	sd	s3,56(sp)
    800040ac:	f852                	sd	s4,48(sp)
    800040ae:	f456                	sd	s5,40(sp)
    800040b0:	f05a                	sd	s6,32(sp)
    800040b2:	ec5e                	sd	s7,24(sp)
    800040b4:	e862                	sd	s8,16(sp)
    800040b6:	e466                	sd	s9,8(sp)
    800040b8:	1080                	addi	s0,sp,96
    800040ba:	84aa                	mv	s1,a0
    800040bc:	8aae                	mv	s5,a1
    800040be:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    800040c0:	00054703          	lbu	a4,0(a0)
    800040c4:	02f00793          	li	a5,47
    800040c8:	02f70363          	beq	a4,a5,800040ee <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800040cc:	ffffe097          	auipc	ra,0xffffe
    800040d0:	8e0080e7          	jalr	-1824(ra) # 800019ac <myproc>
    800040d4:	17853503          	ld	a0,376(a0)
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	9f6080e7          	jalr	-1546(ra) # 80003ace <idup>
    800040e0:	89aa                	mv	s3,a0
  while(*path == '/')
    800040e2:	02f00913          	li	s2,47
  len = path - s;
    800040e6:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    800040e8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800040ea:	4b85                	li	s7,1
    800040ec:	a865                	j	800041a4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800040ee:	4585                	li	a1,1
    800040f0:	4505                	li	a0,1
    800040f2:	fffff097          	auipc	ra,0xfffff
    800040f6:	6e2080e7          	jalr	1762(ra) # 800037d4 <iget>
    800040fa:	89aa                	mv	s3,a0
    800040fc:	b7dd                	j	800040e2 <namex+0x42>
      iunlockput(ip);
    800040fe:	854e                	mv	a0,s3
    80004100:	00000097          	auipc	ra,0x0
    80004104:	c6e080e7          	jalr	-914(ra) # 80003d6e <iunlockput>
      return 0;
    80004108:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000410a:	854e                	mv	a0,s3
    8000410c:	60e6                	ld	ra,88(sp)
    8000410e:	6446                	ld	s0,80(sp)
    80004110:	64a6                	ld	s1,72(sp)
    80004112:	6906                	ld	s2,64(sp)
    80004114:	79e2                	ld	s3,56(sp)
    80004116:	7a42                	ld	s4,48(sp)
    80004118:	7aa2                	ld	s5,40(sp)
    8000411a:	7b02                	ld	s6,32(sp)
    8000411c:	6be2                	ld	s7,24(sp)
    8000411e:	6c42                	ld	s8,16(sp)
    80004120:	6ca2                	ld	s9,8(sp)
    80004122:	6125                	addi	sp,sp,96
    80004124:	8082                	ret
      iunlock(ip);
    80004126:	854e                	mv	a0,s3
    80004128:	00000097          	auipc	ra,0x0
    8000412c:	aa6080e7          	jalr	-1370(ra) # 80003bce <iunlock>
      return ip;
    80004130:	bfe9                	j	8000410a <namex+0x6a>
      iunlockput(ip);
    80004132:	854e                	mv	a0,s3
    80004134:	00000097          	auipc	ra,0x0
    80004138:	c3a080e7          	jalr	-966(ra) # 80003d6e <iunlockput>
      return 0;
    8000413c:	89e6                	mv	s3,s9
    8000413e:	b7f1                	j	8000410a <namex+0x6a>
  len = path - s;
    80004140:	40b48633          	sub	a2,s1,a1
    80004144:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004148:	099c5463          	bge	s8,s9,800041d0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000414c:	4639                	li	a2,14
    8000414e:	8552                	mv	a0,s4
    80004150:	ffffd097          	auipc	ra,0xffffd
    80004154:	bde080e7          	jalr	-1058(ra) # 80000d2e <memmove>
  while(*path == '/')
    80004158:	0004c783          	lbu	a5,0(s1)
    8000415c:	01279763          	bne	a5,s2,8000416a <namex+0xca>
    path++;
    80004160:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004162:	0004c783          	lbu	a5,0(s1)
    80004166:	ff278de3          	beq	a5,s2,80004160 <namex+0xc0>
    ilock(ip);
    8000416a:	854e                	mv	a0,s3
    8000416c:	00000097          	auipc	ra,0x0
    80004170:	9a0080e7          	jalr	-1632(ra) # 80003b0c <ilock>
    if(ip->type != T_DIR){
    80004174:	04499783          	lh	a5,68(s3)
    80004178:	f97793e3          	bne	a5,s7,800040fe <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000417c:	000a8563          	beqz	s5,80004186 <namex+0xe6>
    80004180:	0004c783          	lbu	a5,0(s1)
    80004184:	d3cd                	beqz	a5,80004126 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004186:	865a                	mv	a2,s6
    80004188:	85d2                	mv	a1,s4
    8000418a:	854e                	mv	a0,s3
    8000418c:	00000097          	auipc	ra,0x0
    80004190:	e64080e7          	jalr	-412(ra) # 80003ff0 <dirlookup>
    80004194:	8caa                	mv	s9,a0
    80004196:	dd51                	beqz	a0,80004132 <namex+0x92>
    iunlockput(ip);
    80004198:	854e                	mv	a0,s3
    8000419a:	00000097          	auipc	ra,0x0
    8000419e:	bd4080e7          	jalr	-1068(ra) # 80003d6e <iunlockput>
    ip = next;
    800041a2:	89e6                	mv	s3,s9
  while(*path == '/')
    800041a4:	0004c783          	lbu	a5,0(s1)
    800041a8:	05279763          	bne	a5,s2,800041f6 <namex+0x156>
    path++;
    800041ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041ae:	0004c783          	lbu	a5,0(s1)
    800041b2:	ff278de3          	beq	a5,s2,800041ac <namex+0x10c>
  if(*path == 0)
    800041b6:	c79d                	beqz	a5,800041e4 <namex+0x144>
    path++;
    800041b8:	85a6                	mv	a1,s1
  len = path - s;
    800041ba:	8cda                	mv	s9,s6
    800041bc:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    800041be:	01278963          	beq	a5,s2,800041d0 <namex+0x130>
    800041c2:	dfbd                	beqz	a5,80004140 <namex+0xa0>
    path++;
    800041c4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800041c6:	0004c783          	lbu	a5,0(s1)
    800041ca:	ff279ce3          	bne	a5,s2,800041c2 <namex+0x122>
    800041ce:	bf8d                	j	80004140 <namex+0xa0>
    memmove(name, s, len);
    800041d0:	2601                	sext.w	a2,a2
    800041d2:	8552                	mv	a0,s4
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	b5a080e7          	jalr	-1190(ra) # 80000d2e <memmove>
    name[len] = 0;
    800041dc:	9cd2                	add	s9,s9,s4
    800041de:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800041e2:	bf9d                	j	80004158 <namex+0xb8>
  if(nameiparent){
    800041e4:	f20a83e3          	beqz	s5,8000410a <namex+0x6a>
    iput(ip);
    800041e8:	854e                	mv	a0,s3
    800041ea:	00000097          	auipc	ra,0x0
    800041ee:	adc080e7          	jalr	-1316(ra) # 80003cc6 <iput>
    return 0;
    800041f2:	4981                	li	s3,0
    800041f4:	bf19                	j	8000410a <namex+0x6a>
  if(*path == 0)
    800041f6:	d7fd                	beqz	a5,800041e4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800041f8:	0004c783          	lbu	a5,0(s1)
    800041fc:	85a6                	mv	a1,s1
    800041fe:	b7d1                	j	800041c2 <namex+0x122>

0000000080004200 <dirlink>:
{
    80004200:	7139                	addi	sp,sp,-64
    80004202:	fc06                	sd	ra,56(sp)
    80004204:	f822                	sd	s0,48(sp)
    80004206:	f426                	sd	s1,40(sp)
    80004208:	f04a                	sd	s2,32(sp)
    8000420a:	ec4e                	sd	s3,24(sp)
    8000420c:	e852                	sd	s4,16(sp)
    8000420e:	0080                	addi	s0,sp,64
    80004210:	892a                	mv	s2,a0
    80004212:	8a2e                	mv	s4,a1
    80004214:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004216:	4601                	li	a2,0
    80004218:	00000097          	auipc	ra,0x0
    8000421c:	dd8080e7          	jalr	-552(ra) # 80003ff0 <dirlookup>
    80004220:	e93d                	bnez	a0,80004296 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004222:	04c92483          	lw	s1,76(s2)
    80004226:	c49d                	beqz	s1,80004254 <dirlink+0x54>
    80004228:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000422a:	4741                	li	a4,16
    8000422c:	86a6                	mv	a3,s1
    8000422e:	fc040613          	addi	a2,s0,-64
    80004232:	4581                	li	a1,0
    80004234:	854a                	mv	a0,s2
    80004236:	00000097          	auipc	ra,0x0
    8000423a:	b8a080e7          	jalr	-1142(ra) # 80003dc0 <readi>
    8000423e:	47c1                	li	a5,16
    80004240:	06f51163          	bne	a0,a5,800042a2 <dirlink+0xa2>
    if(de.inum == 0)
    80004244:	fc045783          	lhu	a5,-64(s0)
    80004248:	c791                	beqz	a5,80004254 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000424a:	24c1                	addiw	s1,s1,16
    8000424c:	04c92783          	lw	a5,76(s2)
    80004250:	fcf4ede3          	bltu	s1,a5,8000422a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80004254:	4639                	li	a2,14
    80004256:	85d2                	mv	a1,s4
    80004258:	fc240513          	addi	a0,s0,-62
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	b82080e7          	jalr	-1150(ra) # 80000dde <strncpy>
  de.inum = inum;
    80004264:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004268:	4741                	li	a4,16
    8000426a:	86a6                	mv	a3,s1
    8000426c:	fc040613          	addi	a2,s0,-64
    80004270:	4581                	li	a1,0
    80004272:	854a                	mv	a0,s2
    80004274:	00000097          	auipc	ra,0x0
    80004278:	c44080e7          	jalr	-956(ra) # 80003eb8 <writei>
    8000427c:	1541                	addi	a0,a0,-16
    8000427e:	00a03533          	snez	a0,a0
    80004282:	40a00533          	neg	a0,a0
}
    80004286:	70e2                	ld	ra,56(sp)
    80004288:	7442                	ld	s0,48(sp)
    8000428a:	74a2                	ld	s1,40(sp)
    8000428c:	7902                	ld	s2,32(sp)
    8000428e:	69e2                	ld	s3,24(sp)
    80004290:	6a42                	ld	s4,16(sp)
    80004292:	6121                	addi	sp,sp,64
    80004294:	8082                	ret
    iput(ip);
    80004296:	00000097          	auipc	ra,0x0
    8000429a:	a30080e7          	jalr	-1488(ra) # 80003cc6 <iput>
    return -1;
    8000429e:	557d                	li	a0,-1
    800042a0:	b7dd                	j	80004286 <dirlink+0x86>
      panic("dirlink read");
    800042a2:	00004517          	auipc	a0,0x4
    800042a6:	3d650513          	addi	a0,a0,982 # 80008678 <syscalls+0x1e8>
    800042aa:	ffffc097          	auipc	ra,0xffffc
    800042ae:	294080e7          	jalr	660(ra) # 8000053e <panic>

00000000800042b2 <namei>:

struct inode*
namei(char *path)
{
    800042b2:	1101                	addi	sp,sp,-32
    800042b4:	ec06                	sd	ra,24(sp)
    800042b6:	e822                	sd	s0,16(sp)
    800042b8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800042ba:	fe040613          	addi	a2,s0,-32
    800042be:	4581                	li	a1,0
    800042c0:	00000097          	auipc	ra,0x0
    800042c4:	de0080e7          	jalr	-544(ra) # 800040a0 <namex>
}
    800042c8:	60e2                	ld	ra,24(sp)
    800042ca:	6442                	ld	s0,16(sp)
    800042cc:	6105                	addi	sp,sp,32
    800042ce:	8082                	ret

00000000800042d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800042d0:	1141                	addi	sp,sp,-16
    800042d2:	e406                	sd	ra,8(sp)
    800042d4:	e022                	sd	s0,0(sp)
    800042d6:	0800                	addi	s0,sp,16
    800042d8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800042da:	4585                	li	a1,1
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	dc4080e7          	jalr	-572(ra) # 800040a0 <namex>
}
    800042e4:	60a2                	ld	ra,8(sp)
    800042e6:	6402                	ld	s0,0(sp)
    800042e8:	0141                	addi	sp,sp,16
    800042ea:	8082                	ret

00000000800042ec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800042ec:	1101                	addi	sp,sp,-32
    800042ee:	ec06                	sd	ra,24(sp)
    800042f0:	e822                	sd	s0,16(sp)
    800042f2:	e426                	sd	s1,8(sp)
    800042f4:	e04a                	sd	s2,0(sp)
    800042f6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800042f8:	0001e917          	auipc	s2,0x1e
    800042fc:	e8890913          	addi	s2,s2,-376 # 80022180 <log>
    80004300:	01892583          	lw	a1,24(s2)
    80004304:	02892503          	lw	a0,40(s2)
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	fea080e7          	jalr	-22(ra) # 800032f2 <bread>
    80004310:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004312:	02c92683          	lw	a3,44(s2)
    80004316:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004318:	02d05763          	blez	a3,80004346 <write_head+0x5a>
    8000431c:	0001e797          	auipc	a5,0x1e
    80004320:	e9478793          	addi	a5,a5,-364 # 800221b0 <log+0x30>
    80004324:	05c50713          	addi	a4,a0,92
    80004328:	36fd                	addiw	a3,a3,-1
    8000432a:	1682                	slli	a3,a3,0x20
    8000432c:	9281                	srli	a3,a3,0x20
    8000432e:	068a                	slli	a3,a3,0x2
    80004330:	0001e617          	auipc	a2,0x1e
    80004334:	e8460613          	addi	a2,a2,-380 # 800221b4 <log+0x34>
    80004338:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000433a:	4390                	lw	a2,0(a5)
    8000433c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000433e:	0791                	addi	a5,a5,4
    80004340:	0711                	addi	a4,a4,4
    80004342:	fed79ce3          	bne	a5,a3,8000433a <write_head+0x4e>
  }
  bwrite(buf);
    80004346:	8526                	mv	a0,s1
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	09c080e7          	jalr	156(ra) # 800033e4 <bwrite>
  brelse(buf);
    80004350:	8526                	mv	a0,s1
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	0d0080e7          	jalr	208(ra) # 80003422 <brelse>
}
    8000435a:	60e2                	ld	ra,24(sp)
    8000435c:	6442                	ld	s0,16(sp)
    8000435e:	64a2                	ld	s1,8(sp)
    80004360:	6902                	ld	s2,0(sp)
    80004362:	6105                	addi	sp,sp,32
    80004364:	8082                	ret

0000000080004366 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004366:	0001e797          	auipc	a5,0x1e
    8000436a:	e467a783          	lw	a5,-442(a5) # 800221ac <log+0x2c>
    8000436e:	0af05d63          	blez	a5,80004428 <install_trans+0xc2>
{
    80004372:	7139                	addi	sp,sp,-64
    80004374:	fc06                	sd	ra,56(sp)
    80004376:	f822                	sd	s0,48(sp)
    80004378:	f426                	sd	s1,40(sp)
    8000437a:	f04a                	sd	s2,32(sp)
    8000437c:	ec4e                	sd	s3,24(sp)
    8000437e:	e852                	sd	s4,16(sp)
    80004380:	e456                	sd	s5,8(sp)
    80004382:	e05a                	sd	s6,0(sp)
    80004384:	0080                	addi	s0,sp,64
    80004386:	8b2a                	mv	s6,a0
    80004388:	0001ea97          	auipc	s5,0x1e
    8000438c:	e28a8a93          	addi	s5,s5,-472 # 800221b0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004390:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004392:	0001e997          	auipc	s3,0x1e
    80004396:	dee98993          	addi	s3,s3,-530 # 80022180 <log>
    8000439a:	a00d                	j	800043bc <install_trans+0x56>
    brelse(lbuf);
    8000439c:	854a                	mv	a0,s2
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	084080e7          	jalr	132(ra) # 80003422 <brelse>
    brelse(dbuf);
    800043a6:	8526                	mv	a0,s1
    800043a8:	fffff097          	auipc	ra,0xfffff
    800043ac:	07a080e7          	jalr	122(ra) # 80003422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043b0:	2a05                	addiw	s4,s4,1
    800043b2:	0a91                	addi	s5,s5,4
    800043b4:	02c9a783          	lw	a5,44(s3)
    800043b8:	04fa5e63          	bge	s4,a5,80004414 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043bc:	0189a583          	lw	a1,24(s3)
    800043c0:	014585bb          	addw	a1,a1,s4
    800043c4:	2585                	addiw	a1,a1,1
    800043c6:	0289a503          	lw	a0,40(s3)
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	f28080e7          	jalr	-216(ra) # 800032f2 <bread>
    800043d2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800043d4:	000aa583          	lw	a1,0(s5)
    800043d8:	0289a503          	lw	a0,40(s3)
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	f16080e7          	jalr	-234(ra) # 800032f2 <bread>
    800043e4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043e6:	40000613          	li	a2,1024
    800043ea:	05890593          	addi	a1,s2,88
    800043ee:	05850513          	addi	a0,a0,88
    800043f2:	ffffd097          	auipc	ra,0xffffd
    800043f6:	93c080e7          	jalr	-1732(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    800043fa:	8526                	mv	a0,s1
    800043fc:	fffff097          	auipc	ra,0xfffff
    80004400:	fe8080e7          	jalr	-24(ra) # 800033e4 <bwrite>
    if(recovering == 0)
    80004404:	f80b1ce3          	bnez	s6,8000439c <install_trans+0x36>
      bunpin(dbuf);
    80004408:	8526                	mv	a0,s1
    8000440a:	fffff097          	auipc	ra,0xfffff
    8000440e:	0f2080e7          	jalr	242(ra) # 800034fc <bunpin>
    80004412:	b769                	j	8000439c <install_trans+0x36>
}
    80004414:	70e2                	ld	ra,56(sp)
    80004416:	7442                	ld	s0,48(sp)
    80004418:	74a2                	ld	s1,40(sp)
    8000441a:	7902                	ld	s2,32(sp)
    8000441c:	69e2                	ld	s3,24(sp)
    8000441e:	6a42                	ld	s4,16(sp)
    80004420:	6aa2                	ld	s5,8(sp)
    80004422:	6b02                	ld	s6,0(sp)
    80004424:	6121                	addi	sp,sp,64
    80004426:	8082                	ret
    80004428:	8082                	ret

000000008000442a <initlog>:
{
    8000442a:	7179                	addi	sp,sp,-48
    8000442c:	f406                	sd	ra,40(sp)
    8000442e:	f022                	sd	s0,32(sp)
    80004430:	ec26                	sd	s1,24(sp)
    80004432:	e84a                	sd	s2,16(sp)
    80004434:	e44e                	sd	s3,8(sp)
    80004436:	1800                	addi	s0,sp,48
    80004438:	892a                	mv	s2,a0
    8000443a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000443c:	0001e497          	auipc	s1,0x1e
    80004440:	d4448493          	addi	s1,s1,-700 # 80022180 <log>
    80004444:	00004597          	auipc	a1,0x4
    80004448:	24458593          	addi	a1,a1,580 # 80008688 <syscalls+0x1f8>
    8000444c:	8526                	mv	a0,s1
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	6f8080e7          	jalr	1784(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004456:	0149a583          	lw	a1,20(s3)
    8000445a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000445c:	0109a783          	lw	a5,16(s3)
    80004460:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004462:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004466:	854a                	mv	a0,s2
    80004468:	fffff097          	auipc	ra,0xfffff
    8000446c:	e8a080e7          	jalr	-374(ra) # 800032f2 <bread>
  log.lh.n = lh->n;
    80004470:	4d34                	lw	a3,88(a0)
    80004472:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004474:	02d05563          	blez	a3,8000449e <initlog+0x74>
    80004478:	05c50793          	addi	a5,a0,92
    8000447c:	0001e717          	auipc	a4,0x1e
    80004480:	d3470713          	addi	a4,a4,-716 # 800221b0 <log+0x30>
    80004484:	36fd                	addiw	a3,a3,-1
    80004486:	1682                	slli	a3,a3,0x20
    80004488:	9281                	srli	a3,a3,0x20
    8000448a:	068a                	slli	a3,a3,0x2
    8000448c:	06050613          	addi	a2,a0,96
    80004490:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80004492:	4390                	lw	a2,0(a5)
    80004494:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004496:	0791                	addi	a5,a5,4
    80004498:	0711                	addi	a4,a4,4
    8000449a:	fed79ce3          	bne	a5,a3,80004492 <initlog+0x68>
  brelse(buf);
    8000449e:	fffff097          	auipc	ra,0xfffff
    800044a2:	f84080e7          	jalr	-124(ra) # 80003422 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800044a6:	4505                	li	a0,1
    800044a8:	00000097          	auipc	ra,0x0
    800044ac:	ebe080e7          	jalr	-322(ra) # 80004366 <install_trans>
  log.lh.n = 0;
    800044b0:	0001e797          	auipc	a5,0x1e
    800044b4:	ce07ae23          	sw	zero,-772(a5) # 800221ac <log+0x2c>
  write_head(); // clear the log
    800044b8:	00000097          	auipc	ra,0x0
    800044bc:	e34080e7          	jalr	-460(ra) # 800042ec <write_head>
}
    800044c0:	70a2                	ld	ra,40(sp)
    800044c2:	7402                	ld	s0,32(sp)
    800044c4:	64e2                	ld	s1,24(sp)
    800044c6:	6942                	ld	s2,16(sp)
    800044c8:	69a2                	ld	s3,8(sp)
    800044ca:	6145                	addi	sp,sp,48
    800044cc:	8082                	ret

00000000800044ce <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800044ce:	1101                	addi	sp,sp,-32
    800044d0:	ec06                	sd	ra,24(sp)
    800044d2:	e822                	sd	s0,16(sp)
    800044d4:	e426                	sd	s1,8(sp)
    800044d6:	e04a                	sd	s2,0(sp)
    800044d8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800044da:	0001e517          	auipc	a0,0x1e
    800044de:	ca650513          	addi	a0,a0,-858 # 80022180 <log>
    800044e2:	ffffc097          	auipc	ra,0xffffc
    800044e6:	6f4080e7          	jalr	1780(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    800044ea:	0001e497          	auipc	s1,0x1e
    800044ee:	c9648493          	addi	s1,s1,-874 # 80022180 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800044f2:	4979                	li	s2,30
    800044f4:	a039                	j	80004502 <begin_op+0x34>
      sleep(&log, &log.lock);
    800044f6:	85a6                	mv	a1,s1
    800044f8:	8526                	mv	a0,s1
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	c50080e7          	jalr	-944(ra) # 8000214a <sleep>
    if(log.committing){
    80004502:	50dc                	lw	a5,36(s1)
    80004504:	fbed                	bnez	a5,800044f6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004506:	509c                	lw	a5,32(s1)
    80004508:	0017871b          	addiw	a4,a5,1
    8000450c:	0007069b          	sext.w	a3,a4
    80004510:	0027179b          	slliw	a5,a4,0x2
    80004514:	9fb9                	addw	a5,a5,a4
    80004516:	0017979b          	slliw	a5,a5,0x1
    8000451a:	54d8                	lw	a4,44(s1)
    8000451c:	9fb9                	addw	a5,a5,a4
    8000451e:	00f95963          	bge	s2,a5,80004530 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004522:	85a6                	mv	a1,s1
    80004524:	8526                	mv	a0,s1
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	c24080e7          	jalr	-988(ra) # 8000214a <sleep>
    8000452e:	bfd1                	j	80004502 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004530:	0001e517          	auipc	a0,0x1e
    80004534:	c5050513          	addi	a0,a0,-944 # 80022180 <log>
    80004538:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000453a:	ffffc097          	auipc	ra,0xffffc
    8000453e:	750080e7          	jalr	1872(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004542:	60e2                	ld	ra,24(sp)
    80004544:	6442                	ld	s0,16(sp)
    80004546:	64a2                	ld	s1,8(sp)
    80004548:	6902                	ld	s2,0(sp)
    8000454a:	6105                	addi	sp,sp,32
    8000454c:	8082                	ret

000000008000454e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000454e:	7139                	addi	sp,sp,-64
    80004550:	fc06                	sd	ra,56(sp)
    80004552:	f822                	sd	s0,48(sp)
    80004554:	f426                	sd	s1,40(sp)
    80004556:	f04a                	sd	s2,32(sp)
    80004558:	ec4e                	sd	s3,24(sp)
    8000455a:	e852                	sd	s4,16(sp)
    8000455c:	e456                	sd	s5,8(sp)
    8000455e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004560:	0001e497          	auipc	s1,0x1e
    80004564:	c2048493          	addi	s1,s1,-992 # 80022180 <log>
    80004568:	8526                	mv	a0,s1
    8000456a:	ffffc097          	auipc	ra,0xffffc
    8000456e:	66c080e7          	jalr	1644(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    80004572:	509c                	lw	a5,32(s1)
    80004574:	37fd                	addiw	a5,a5,-1
    80004576:	0007891b          	sext.w	s2,a5
    8000457a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000457c:	50dc                	lw	a5,36(s1)
    8000457e:	e7b9                	bnez	a5,800045cc <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004580:	04091e63          	bnez	s2,800045dc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004584:	0001e497          	auipc	s1,0x1e
    80004588:	bfc48493          	addi	s1,s1,-1028 # 80022180 <log>
    8000458c:	4785                	li	a5,1
    8000458e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004590:	8526                	mv	a0,s1
    80004592:	ffffc097          	auipc	ra,0xffffc
    80004596:	6f8080e7          	jalr	1784(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000459a:	54dc                	lw	a5,44(s1)
    8000459c:	06f04763          	bgtz	a5,8000460a <end_op+0xbc>
    acquire(&log.lock);
    800045a0:	0001e497          	auipc	s1,0x1e
    800045a4:	be048493          	addi	s1,s1,-1056 # 80022180 <log>
    800045a8:	8526                	mv	a0,s1
    800045aa:	ffffc097          	auipc	ra,0xffffc
    800045ae:	62c080e7          	jalr	1580(ra) # 80000bd6 <acquire>
    log.committing = 0;
    800045b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800045b6:	8526                	mv	a0,s1
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	bf6080e7          	jalr	-1034(ra) # 800021ae <wakeup>
    release(&log.lock);
    800045c0:	8526                	mv	a0,s1
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	6c8080e7          	jalr	1736(ra) # 80000c8a <release>
}
    800045ca:	a03d                	j	800045f8 <end_op+0xaa>
    panic("log.committing");
    800045cc:	00004517          	auipc	a0,0x4
    800045d0:	0c450513          	addi	a0,a0,196 # 80008690 <syscalls+0x200>
    800045d4:	ffffc097          	auipc	ra,0xffffc
    800045d8:	f6a080e7          	jalr	-150(ra) # 8000053e <panic>
    wakeup(&log);
    800045dc:	0001e497          	auipc	s1,0x1e
    800045e0:	ba448493          	addi	s1,s1,-1116 # 80022180 <log>
    800045e4:	8526                	mv	a0,s1
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	bc8080e7          	jalr	-1080(ra) # 800021ae <wakeup>
  release(&log.lock);
    800045ee:	8526                	mv	a0,s1
    800045f0:	ffffc097          	auipc	ra,0xffffc
    800045f4:	69a080e7          	jalr	1690(ra) # 80000c8a <release>
}
    800045f8:	70e2                	ld	ra,56(sp)
    800045fa:	7442                	ld	s0,48(sp)
    800045fc:	74a2                	ld	s1,40(sp)
    800045fe:	7902                	ld	s2,32(sp)
    80004600:	69e2                	ld	s3,24(sp)
    80004602:	6a42                	ld	s4,16(sp)
    80004604:	6aa2                	ld	s5,8(sp)
    80004606:	6121                	addi	sp,sp,64
    80004608:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000460a:	0001ea97          	auipc	s5,0x1e
    8000460e:	ba6a8a93          	addi	s5,s5,-1114 # 800221b0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004612:	0001ea17          	auipc	s4,0x1e
    80004616:	b6ea0a13          	addi	s4,s4,-1170 # 80022180 <log>
    8000461a:	018a2583          	lw	a1,24(s4)
    8000461e:	012585bb          	addw	a1,a1,s2
    80004622:	2585                	addiw	a1,a1,1
    80004624:	028a2503          	lw	a0,40(s4)
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	cca080e7          	jalr	-822(ra) # 800032f2 <bread>
    80004630:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004632:	000aa583          	lw	a1,0(s5)
    80004636:	028a2503          	lw	a0,40(s4)
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	cb8080e7          	jalr	-840(ra) # 800032f2 <bread>
    80004642:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004644:	40000613          	li	a2,1024
    80004648:	05850593          	addi	a1,a0,88
    8000464c:	05848513          	addi	a0,s1,88
    80004650:	ffffc097          	auipc	ra,0xffffc
    80004654:	6de080e7          	jalr	1758(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004658:	8526                	mv	a0,s1
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	d8a080e7          	jalr	-630(ra) # 800033e4 <bwrite>
    brelse(from);
    80004662:	854e                	mv	a0,s3
    80004664:	fffff097          	auipc	ra,0xfffff
    80004668:	dbe080e7          	jalr	-578(ra) # 80003422 <brelse>
    brelse(to);
    8000466c:	8526                	mv	a0,s1
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	db4080e7          	jalr	-588(ra) # 80003422 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004676:	2905                	addiw	s2,s2,1
    80004678:	0a91                	addi	s5,s5,4
    8000467a:	02ca2783          	lw	a5,44(s4)
    8000467e:	f8f94ee3          	blt	s2,a5,8000461a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004682:	00000097          	auipc	ra,0x0
    80004686:	c6a080e7          	jalr	-918(ra) # 800042ec <write_head>
    install_trans(0); // Now install writes to home locations
    8000468a:	4501                	li	a0,0
    8000468c:	00000097          	auipc	ra,0x0
    80004690:	cda080e7          	jalr	-806(ra) # 80004366 <install_trans>
    log.lh.n = 0;
    80004694:	0001e797          	auipc	a5,0x1e
    80004698:	b007ac23          	sw	zero,-1256(a5) # 800221ac <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	c50080e7          	jalr	-944(ra) # 800042ec <write_head>
    800046a4:	bdf5                	j	800045a0 <end_op+0x52>

00000000800046a6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800046a6:	1101                	addi	sp,sp,-32
    800046a8:	ec06                	sd	ra,24(sp)
    800046aa:	e822                	sd	s0,16(sp)
    800046ac:	e426                	sd	s1,8(sp)
    800046ae:	e04a                	sd	s2,0(sp)
    800046b0:	1000                	addi	s0,sp,32
    800046b2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800046b4:	0001e917          	auipc	s2,0x1e
    800046b8:	acc90913          	addi	s2,s2,-1332 # 80022180 <log>
    800046bc:	854a                	mv	a0,s2
    800046be:	ffffc097          	auipc	ra,0xffffc
    800046c2:	518080e7          	jalr	1304(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800046c6:	02c92603          	lw	a2,44(s2)
    800046ca:	47f5                	li	a5,29
    800046cc:	06c7c563          	blt	a5,a2,80004736 <log_write+0x90>
    800046d0:	0001e797          	auipc	a5,0x1e
    800046d4:	acc7a783          	lw	a5,-1332(a5) # 8002219c <log+0x1c>
    800046d8:	37fd                	addiw	a5,a5,-1
    800046da:	04f65e63          	bge	a2,a5,80004736 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800046de:	0001e797          	auipc	a5,0x1e
    800046e2:	ac27a783          	lw	a5,-1342(a5) # 800221a0 <log+0x20>
    800046e6:	06f05063          	blez	a5,80004746 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800046ea:	4781                	li	a5,0
    800046ec:	06c05563          	blez	a2,80004756 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800046f0:	44cc                	lw	a1,12(s1)
    800046f2:	0001e717          	auipc	a4,0x1e
    800046f6:	abe70713          	addi	a4,a4,-1346 # 800221b0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800046fa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800046fc:	4314                	lw	a3,0(a4)
    800046fe:	04b68c63          	beq	a3,a1,80004756 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004702:	2785                	addiw	a5,a5,1
    80004704:	0711                	addi	a4,a4,4
    80004706:	fef61be3          	bne	a2,a5,800046fc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000470a:	0621                	addi	a2,a2,8
    8000470c:	060a                	slli	a2,a2,0x2
    8000470e:	0001e797          	auipc	a5,0x1e
    80004712:	a7278793          	addi	a5,a5,-1422 # 80022180 <log>
    80004716:	963e                	add	a2,a2,a5
    80004718:	44dc                	lw	a5,12(s1)
    8000471a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000471c:	8526                	mv	a0,s1
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	da2080e7          	jalr	-606(ra) # 800034c0 <bpin>
    log.lh.n++;
    80004726:	0001e717          	auipc	a4,0x1e
    8000472a:	a5a70713          	addi	a4,a4,-1446 # 80022180 <log>
    8000472e:	575c                	lw	a5,44(a4)
    80004730:	2785                	addiw	a5,a5,1
    80004732:	d75c                	sw	a5,44(a4)
    80004734:	a835                	j	80004770 <log_write+0xca>
    panic("too big a transaction");
    80004736:	00004517          	auipc	a0,0x4
    8000473a:	f6a50513          	addi	a0,a0,-150 # 800086a0 <syscalls+0x210>
    8000473e:	ffffc097          	auipc	ra,0xffffc
    80004742:	e00080e7          	jalr	-512(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004746:	00004517          	auipc	a0,0x4
    8000474a:	f7250513          	addi	a0,a0,-142 # 800086b8 <syscalls+0x228>
    8000474e:	ffffc097          	auipc	ra,0xffffc
    80004752:	df0080e7          	jalr	-528(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004756:	00878713          	addi	a4,a5,8
    8000475a:	00271693          	slli	a3,a4,0x2
    8000475e:	0001e717          	auipc	a4,0x1e
    80004762:	a2270713          	addi	a4,a4,-1502 # 80022180 <log>
    80004766:	9736                	add	a4,a4,a3
    80004768:	44d4                	lw	a3,12(s1)
    8000476a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000476c:	faf608e3          	beq	a2,a5,8000471c <log_write+0x76>
  }
  release(&log.lock);
    80004770:	0001e517          	auipc	a0,0x1e
    80004774:	a1050513          	addi	a0,a0,-1520 # 80022180 <log>
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	512080e7          	jalr	1298(ra) # 80000c8a <release>
}
    80004780:	60e2                	ld	ra,24(sp)
    80004782:	6442                	ld	s0,16(sp)
    80004784:	64a2                	ld	s1,8(sp)
    80004786:	6902                	ld	s2,0(sp)
    80004788:	6105                	addi	sp,sp,32
    8000478a:	8082                	ret

000000008000478c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000478c:	1101                	addi	sp,sp,-32
    8000478e:	ec06                	sd	ra,24(sp)
    80004790:	e822                	sd	s0,16(sp)
    80004792:	e426                	sd	s1,8(sp)
    80004794:	e04a                	sd	s2,0(sp)
    80004796:	1000                	addi	s0,sp,32
    80004798:	84aa                	mv	s1,a0
    8000479a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000479c:	00004597          	auipc	a1,0x4
    800047a0:	f3c58593          	addi	a1,a1,-196 # 800086d8 <syscalls+0x248>
    800047a4:	0521                	addi	a0,a0,8
    800047a6:	ffffc097          	auipc	ra,0xffffc
    800047aa:	3a0080e7          	jalr	928(ra) # 80000b46 <initlock>
  lk->name = name;
    800047ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800047b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800047b6:	0204a423          	sw	zero,40(s1)
}
    800047ba:	60e2                	ld	ra,24(sp)
    800047bc:	6442                	ld	s0,16(sp)
    800047be:	64a2                	ld	s1,8(sp)
    800047c0:	6902                	ld	s2,0(sp)
    800047c2:	6105                	addi	sp,sp,32
    800047c4:	8082                	ret

00000000800047c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800047c6:	1101                	addi	sp,sp,-32
    800047c8:	ec06                	sd	ra,24(sp)
    800047ca:	e822                	sd	s0,16(sp)
    800047cc:	e426                	sd	s1,8(sp)
    800047ce:	e04a                	sd	s2,0(sp)
    800047d0:	1000                	addi	s0,sp,32
    800047d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800047d4:	00850913          	addi	s2,a0,8
    800047d8:	854a                	mv	a0,s2
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	3fc080e7          	jalr	1020(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    800047e2:	409c                	lw	a5,0(s1)
    800047e4:	cb89                	beqz	a5,800047f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800047e6:	85ca                	mv	a1,s2
    800047e8:	8526                	mv	a0,s1
    800047ea:	ffffe097          	auipc	ra,0xffffe
    800047ee:	960080e7          	jalr	-1696(ra) # 8000214a <sleep>
  while (lk->locked) {
    800047f2:	409c                	lw	a5,0(s1)
    800047f4:	fbed                	bnez	a5,800047e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800047f6:	4785                	li	a5,1
    800047f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800047fa:	ffffd097          	auipc	ra,0xffffd
    800047fe:	1b2080e7          	jalr	434(ra) # 800019ac <myproc>
    80004802:	591c                	lw	a5,48(a0)
    80004804:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004806:	854a                	mv	a0,s2
    80004808:	ffffc097          	auipc	ra,0xffffc
    8000480c:	482080e7          	jalr	1154(ra) # 80000c8a <release>
}
    80004810:	60e2                	ld	ra,24(sp)
    80004812:	6442                	ld	s0,16(sp)
    80004814:	64a2                	ld	s1,8(sp)
    80004816:	6902                	ld	s2,0(sp)
    80004818:	6105                	addi	sp,sp,32
    8000481a:	8082                	ret

000000008000481c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000481c:	1101                	addi	sp,sp,-32
    8000481e:	ec06                	sd	ra,24(sp)
    80004820:	e822                	sd	s0,16(sp)
    80004822:	e426                	sd	s1,8(sp)
    80004824:	e04a                	sd	s2,0(sp)
    80004826:	1000                	addi	s0,sp,32
    80004828:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000482a:	00850913          	addi	s2,a0,8
    8000482e:	854a                	mv	a0,s2
    80004830:	ffffc097          	auipc	ra,0xffffc
    80004834:	3a6080e7          	jalr	934(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004838:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000483c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004840:	8526                	mv	a0,s1
    80004842:	ffffe097          	auipc	ra,0xffffe
    80004846:	96c080e7          	jalr	-1684(ra) # 800021ae <wakeup>
  release(&lk->lk);
    8000484a:	854a                	mv	a0,s2
    8000484c:	ffffc097          	auipc	ra,0xffffc
    80004850:	43e080e7          	jalr	1086(ra) # 80000c8a <release>
}
    80004854:	60e2                	ld	ra,24(sp)
    80004856:	6442                	ld	s0,16(sp)
    80004858:	64a2                	ld	s1,8(sp)
    8000485a:	6902                	ld	s2,0(sp)
    8000485c:	6105                	addi	sp,sp,32
    8000485e:	8082                	ret

0000000080004860 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004860:	7179                	addi	sp,sp,-48
    80004862:	f406                	sd	ra,40(sp)
    80004864:	f022                	sd	s0,32(sp)
    80004866:	ec26                	sd	s1,24(sp)
    80004868:	e84a                	sd	s2,16(sp)
    8000486a:	e44e                	sd	s3,8(sp)
    8000486c:	1800                	addi	s0,sp,48
    8000486e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004870:	00850913          	addi	s2,a0,8
    80004874:	854a                	mv	a0,s2
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	360080e7          	jalr	864(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000487e:	409c                	lw	a5,0(s1)
    80004880:	ef99                	bnez	a5,8000489e <holdingsleep+0x3e>
    80004882:	4481                	li	s1,0
  release(&lk->lk);
    80004884:	854a                	mv	a0,s2
    80004886:	ffffc097          	auipc	ra,0xffffc
    8000488a:	404080e7          	jalr	1028(ra) # 80000c8a <release>
  return r;
}
    8000488e:	8526                	mv	a0,s1
    80004890:	70a2                	ld	ra,40(sp)
    80004892:	7402                	ld	s0,32(sp)
    80004894:	64e2                	ld	s1,24(sp)
    80004896:	6942                	ld	s2,16(sp)
    80004898:	69a2                	ld	s3,8(sp)
    8000489a:	6145                	addi	sp,sp,48
    8000489c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000489e:	0284a983          	lw	s3,40(s1)
    800048a2:	ffffd097          	auipc	ra,0xffffd
    800048a6:	10a080e7          	jalr	266(ra) # 800019ac <myproc>
    800048aa:	5904                	lw	s1,48(a0)
    800048ac:	413484b3          	sub	s1,s1,s3
    800048b0:	0014b493          	seqz	s1,s1
    800048b4:	bfc1                	j	80004884 <holdingsleep+0x24>

00000000800048b6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800048b6:	1141                	addi	sp,sp,-16
    800048b8:	e406                	sd	ra,8(sp)
    800048ba:	e022                	sd	s0,0(sp)
    800048bc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800048be:	00004597          	auipc	a1,0x4
    800048c2:	e2a58593          	addi	a1,a1,-470 # 800086e8 <syscalls+0x258>
    800048c6:	0001e517          	auipc	a0,0x1e
    800048ca:	a0250513          	addi	a0,a0,-1534 # 800222c8 <ftable>
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	278080e7          	jalr	632(ra) # 80000b46 <initlock>
}
    800048d6:	60a2                	ld	ra,8(sp)
    800048d8:	6402                	ld	s0,0(sp)
    800048da:	0141                	addi	sp,sp,16
    800048dc:	8082                	ret

00000000800048de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800048de:	1101                	addi	sp,sp,-32
    800048e0:	ec06                	sd	ra,24(sp)
    800048e2:	e822                	sd	s0,16(sp)
    800048e4:	e426                	sd	s1,8(sp)
    800048e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800048e8:	0001e517          	auipc	a0,0x1e
    800048ec:	9e050513          	addi	a0,a0,-1568 # 800222c8 <ftable>
    800048f0:	ffffc097          	auipc	ra,0xffffc
    800048f4:	2e6080e7          	jalr	742(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800048f8:	0001e497          	auipc	s1,0x1e
    800048fc:	9e848493          	addi	s1,s1,-1560 # 800222e0 <ftable+0x18>
    80004900:	0001f717          	auipc	a4,0x1f
    80004904:	98070713          	addi	a4,a4,-1664 # 80023280 <disk>
    if(f->ref == 0){
    80004908:	40dc                	lw	a5,4(s1)
    8000490a:	cf99                	beqz	a5,80004928 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000490c:	02848493          	addi	s1,s1,40
    80004910:	fee49ce3          	bne	s1,a4,80004908 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004914:	0001e517          	auipc	a0,0x1e
    80004918:	9b450513          	addi	a0,a0,-1612 # 800222c8 <ftable>
    8000491c:	ffffc097          	auipc	ra,0xffffc
    80004920:	36e080e7          	jalr	878(ra) # 80000c8a <release>
  return 0;
    80004924:	4481                	li	s1,0
    80004926:	a819                	j	8000493c <filealloc+0x5e>
      f->ref = 1;
    80004928:	4785                	li	a5,1
    8000492a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000492c:	0001e517          	auipc	a0,0x1e
    80004930:	99c50513          	addi	a0,a0,-1636 # 800222c8 <ftable>
    80004934:	ffffc097          	auipc	ra,0xffffc
    80004938:	356080e7          	jalr	854(ra) # 80000c8a <release>
}
    8000493c:	8526                	mv	a0,s1
    8000493e:	60e2                	ld	ra,24(sp)
    80004940:	6442                	ld	s0,16(sp)
    80004942:	64a2                	ld	s1,8(sp)
    80004944:	6105                	addi	sp,sp,32
    80004946:	8082                	ret

0000000080004948 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004948:	1101                	addi	sp,sp,-32
    8000494a:	ec06                	sd	ra,24(sp)
    8000494c:	e822                	sd	s0,16(sp)
    8000494e:	e426                	sd	s1,8(sp)
    80004950:	1000                	addi	s0,sp,32
    80004952:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004954:	0001e517          	auipc	a0,0x1e
    80004958:	97450513          	addi	a0,a0,-1676 # 800222c8 <ftable>
    8000495c:	ffffc097          	auipc	ra,0xffffc
    80004960:	27a080e7          	jalr	634(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    80004964:	40dc                	lw	a5,4(s1)
    80004966:	02f05263          	blez	a5,8000498a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000496a:	2785                	addiw	a5,a5,1
    8000496c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000496e:	0001e517          	auipc	a0,0x1e
    80004972:	95a50513          	addi	a0,a0,-1702 # 800222c8 <ftable>
    80004976:	ffffc097          	auipc	ra,0xffffc
    8000497a:	314080e7          	jalr	788(ra) # 80000c8a <release>
  return f;
}
    8000497e:	8526                	mv	a0,s1
    80004980:	60e2                	ld	ra,24(sp)
    80004982:	6442                	ld	s0,16(sp)
    80004984:	64a2                	ld	s1,8(sp)
    80004986:	6105                	addi	sp,sp,32
    80004988:	8082                	ret
    panic("filedup");
    8000498a:	00004517          	auipc	a0,0x4
    8000498e:	d6650513          	addi	a0,a0,-666 # 800086f0 <syscalls+0x260>
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	bac080e7          	jalr	-1108(ra) # 8000053e <panic>

000000008000499a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000499a:	7139                	addi	sp,sp,-64
    8000499c:	fc06                	sd	ra,56(sp)
    8000499e:	f822                	sd	s0,48(sp)
    800049a0:	f426                	sd	s1,40(sp)
    800049a2:	f04a                	sd	s2,32(sp)
    800049a4:	ec4e                	sd	s3,24(sp)
    800049a6:	e852                	sd	s4,16(sp)
    800049a8:	e456                	sd	s5,8(sp)
    800049aa:	0080                	addi	s0,sp,64
    800049ac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800049ae:	0001e517          	auipc	a0,0x1e
    800049b2:	91a50513          	addi	a0,a0,-1766 # 800222c8 <ftable>
    800049b6:	ffffc097          	auipc	ra,0xffffc
    800049ba:	220080e7          	jalr	544(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800049be:	40dc                	lw	a5,4(s1)
    800049c0:	06f05163          	blez	a5,80004a22 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800049c4:	37fd                	addiw	a5,a5,-1
    800049c6:	0007871b          	sext.w	a4,a5
    800049ca:	c0dc                	sw	a5,4(s1)
    800049cc:	06e04363          	bgtz	a4,80004a32 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800049d0:	0004a903          	lw	s2,0(s1)
    800049d4:	0094ca83          	lbu	s5,9(s1)
    800049d8:	0104ba03          	ld	s4,16(s1)
    800049dc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800049e0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800049e4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800049e8:	0001e517          	auipc	a0,0x1e
    800049ec:	8e050513          	addi	a0,a0,-1824 # 800222c8 <ftable>
    800049f0:	ffffc097          	auipc	ra,0xffffc
    800049f4:	29a080e7          	jalr	666(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    800049f8:	4785                	li	a5,1
    800049fa:	04f90d63          	beq	s2,a5,80004a54 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800049fe:	3979                	addiw	s2,s2,-2
    80004a00:	4785                	li	a5,1
    80004a02:	0527e063          	bltu	a5,s2,80004a42 <fileclose+0xa8>
    begin_op();
    80004a06:	00000097          	auipc	ra,0x0
    80004a0a:	ac8080e7          	jalr	-1336(ra) # 800044ce <begin_op>
    iput(ff.ip);
    80004a0e:	854e                	mv	a0,s3
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	2b6080e7          	jalr	694(ra) # 80003cc6 <iput>
    end_op();
    80004a18:	00000097          	auipc	ra,0x0
    80004a1c:	b36080e7          	jalr	-1226(ra) # 8000454e <end_op>
    80004a20:	a00d                	j	80004a42 <fileclose+0xa8>
    panic("fileclose");
    80004a22:	00004517          	auipc	a0,0x4
    80004a26:	cd650513          	addi	a0,a0,-810 # 800086f8 <syscalls+0x268>
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	b14080e7          	jalr	-1260(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004a32:	0001e517          	auipc	a0,0x1e
    80004a36:	89650513          	addi	a0,a0,-1898 # 800222c8 <ftable>
    80004a3a:	ffffc097          	auipc	ra,0xffffc
    80004a3e:	250080e7          	jalr	592(ra) # 80000c8a <release>
  }
}
    80004a42:	70e2                	ld	ra,56(sp)
    80004a44:	7442                	ld	s0,48(sp)
    80004a46:	74a2                	ld	s1,40(sp)
    80004a48:	7902                	ld	s2,32(sp)
    80004a4a:	69e2                	ld	s3,24(sp)
    80004a4c:	6a42                	ld	s4,16(sp)
    80004a4e:	6aa2                	ld	s5,8(sp)
    80004a50:	6121                	addi	sp,sp,64
    80004a52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004a54:	85d6                	mv	a1,s5
    80004a56:	8552                	mv	a0,s4
    80004a58:	00000097          	auipc	ra,0x0
    80004a5c:	34c080e7          	jalr	844(ra) # 80004da4 <pipeclose>
    80004a60:	b7cd                	j	80004a42 <fileclose+0xa8>

0000000080004a62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004a62:	715d                	addi	sp,sp,-80
    80004a64:	e486                	sd	ra,72(sp)
    80004a66:	e0a2                	sd	s0,64(sp)
    80004a68:	fc26                	sd	s1,56(sp)
    80004a6a:	f84a                	sd	s2,48(sp)
    80004a6c:	f44e                	sd	s3,40(sp)
    80004a6e:	0880                	addi	s0,sp,80
    80004a70:	84aa                	mv	s1,a0
    80004a72:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	f38080e7          	jalr	-200(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004a7c:	409c                	lw	a5,0(s1)
    80004a7e:	37f9                	addiw	a5,a5,-2
    80004a80:	4705                	li	a4,1
    80004a82:	04f76763          	bltu	a4,a5,80004ad0 <filestat+0x6e>
    80004a86:	892a                	mv	s2,a0
    ilock(f->ip);
    80004a88:	6c88                	ld	a0,24(s1)
    80004a8a:	fffff097          	auipc	ra,0xfffff
    80004a8e:	082080e7          	jalr	130(ra) # 80003b0c <ilock>
    stati(f->ip, &st);
    80004a92:	fb840593          	addi	a1,s0,-72
    80004a96:	6c88                	ld	a0,24(s1)
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	2fe080e7          	jalr	766(ra) # 80003d96 <stati>
    iunlock(f->ip);
    80004aa0:	6c88                	ld	a0,24(s1)
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	12c080e7          	jalr	300(ra) # 80003bce <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004aaa:	46e1                	li	a3,24
    80004aac:	fb840613          	addi	a2,s0,-72
    80004ab0:	85ce                	mv	a1,s3
    80004ab2:	07893503          	ld	a0,120(s2)
    80004ab6:	ffffd097          	auipc	ra,0xffffd
    80004aba:	bb2080e7          	jalr	-1102(ra) # 80001668 <copyout>
    80004abe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004ac2:	60a6                	ld	ra,72(sp)
    80004ac4:	6406                	ld	s0,64(sp)
    80004ac6:	74e2                	ld	s1,56(sp)
    80004ac8:	7942                	ld	s2,48(sp)
    80004aca:	79a2                	ld	s3,40(sp)
    80004acc:	6161                	addi	sp,sp,80
    80004ace:	8082                	ret
  return -1;
    80004ad0:	557d                	li	a0,-1
    80004ad2:	bfc5                	j	80004ac2 <filestat+0x60>

0000000080004ad4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ad4:	7179                	addi	sp,sp,-48
    80004ad6:	f406                	sd	ra,40(sp)
    80004ad8:	f022                	sd	s0,32(sp)
    80004ada:	ec26                	sd	s1,24(sp)
    80004adc:	e84a                	sd	s2,16(sp)
    80004ade:	e44e                	sd	s3,8(sp)
    80004ae0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ae2:	00854783          	lbu	a5,8(a0)
    80004ae6:	c3d5                	beqz	a5,80004b8a <fileread+0xb6>
    80004ae8:	84aa                	mv	s1,a0
    80004aea:	89ae                	mv	s3,a1
    80004aec:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004aee:	411c                	lw	a5,0(a0)
    80004af0:	4705                	li	a4,1
    80004af2:	04e78963          	beq	a5,a4,80004b44 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004af6:	470d                	li	a4,3
    80004af8:	04e78d63          	beq	a5,a4,80004b52 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004afc:	4709                	li	a4,2
    80004afe:	06e79e63          	bne	a5,a4,80004b7a <fileread+0xa6>
    ilock(f->ip);
    80004b02:	6d08                	ld	a0,24(a0)
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	008080e7          	jalr	8(ra) # 80003b0c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b0c:	874a                	mv	a4,s2
    80004b0e:	5094                	lw	a3,32(s1)
    80004b10:	864e                	mv	a2,s3
    80004b12:	4585                	li	a1,1
    80004b14:	6c88                	ld	a0,24(s1)
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	2aa080e7          	jalr	682(ra) # 80003dc0 <readi>
    80004b1e:	892a                	mv	s2,a0
    80004b20:	00a05563          	blez	a0,80004b2a <fileread+0x56>
      f->off += r;
    80004b24:	509c                	lw	a5,32(s1)
    80004b26:	9fa9                	addw	a5,a5,a0
    80004b28:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004b2a:	6c88                	ld	a0,24(s1)
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	0a2080e7          	jalr	162(ra) # 80003bce <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004b34:	854a                	mv	a0,s2
    80004b36:	70a2                	ld	ra,40(sp)
    80004b38:	7402                	ld	s0,32(sp)
    80004b3a:	64e2                	ld	s1,24(sp)
    80004b3c:	6942                	ld	s2,16(sp)
    80004b3e:	69a2                	ld	s3,8(sp)
    80004b40:	6145                	addi	sp,sp,48
    80004b42:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004b44:	6908                	ld	a0,16(a0)
    80004b46:	00000097          	auipc	ra,0x0
    80004b4a:	3c6080e7          	jalr	966(ra) # 80004f0c <piperead>
    80004b4e:	892a                	mv	s2,a0
    80004b50:	b7d5                	j	80004b34 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004b52:	02451783          	lh	a5,36(a0)
    80004b56:	03079693          	slli	a3,a5,0x30
    80004b5a:	92c1                	srli	a3,a3,0x30
    80004b5c:	4725                	li	a4,9
    80004b5e:	02d76863          	bltu	a4,a3,80004b8e <fileread+0xba>
    80004b62:	0792                	slli	a5,a5,0x4
    80004b64:	0001d717          	auipc	a4,0x1d
    80004b68:	6c470713          	addi	a4,a4,1732 # 80022228 <devsw>
    80004b6c:	97ba                	add	a5,a5,a4
    80004b6e:	639c                	ld	a5,0(a5)
    80004b70:	c38d                	beqz	a5,80004b92 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004b72:	4505                	li	a0,1
    80004b74:	9782                	jalr	a5
    80004b76:	892a                	mv	s2,a0
    80004b78:	bf75                	j	80004b34 <fileread+0x60>
    panic("fileread");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	b8e50513          	addi	a0,a0,-1138 # 80008708 <syscalls+0x278>
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	9bc080e7          	jalr	-1604(ra) # 8000053e <panic>
    return -1;
    80004b8a:	597d                	li	s2,-1
    80004b8c:	b765                	j	80004b34 <fileread+0x60>
      return -1;
    80004b8e:	597d                	li	s2,-1
    80004b90:	b755                	j	80004b34 <fileread+0x60>
    80004b92:	597d                	li	s2,-1
    80004b94:	b745                	j	80004b34 <fileread+0x60>

0000000080004b96 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004b96:	715d                	addi	sp,sp,-80
    80004b98:	e486                	sd	ra,72(sp)
    80004b9a:	e0a2                	sd	s0,64(sp)
    80004b9c:	fc26                	sd	s1,56(sp)
    80004b9e:	f84a                	sd	s2,48(sp)
    80004ba0:	f44e                	sd	s3,40(sp)
    80004ba2:	f052                	sd	s4,32(sp)
    80004ba4:	ec56                	sd	s5,24(sp)
    80004ba6:	e85a                	sd	s6,16(sp)
    80004ba8:	e45e                	sd	s7,8(sp)
    80004baa:	e062                	sd	s8,0(sp)
    80004bac:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004bae:	00954783          	lbu	a5,9(a0)
    80004bb2:	10078663          	beqz	a5,80004cbe <filewrite+0x128>
    80004bb6:	892a                	mv	s2,a0
    80004bb8:	8aae                	mv	s5,a1
    80004bba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004bbc:	411c                	lw	a5,0(a0)
    80004bbe:	4705                	li	a4,1
    80004bc0:	02e78263          	beq	a5,a4,80004be4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004bc4:	470d                	li	a4,3
    80004bc6:	02e78663          	beq	a5,a4,80004bf2 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004bca:	4709                	li	a4,2
    80004bcc:	0ee79163          	bne	a5,a4,80004cae <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004bd0:	0ac05d63          	blez	a2,80004c8a <filewrite+0xf4>
    int i = 0;
    80004bd4:	4981                	li	s3,0
    80004bd6:	6b05                	lui	s6,0x1
    80004bd8:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004bdc:	6b85                	lui	s7,0x1
    80004bde:	c00b8b9b          	addiw	s7,s7,-1024
    80004be2:	a861                	j	80004c7a <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004be4:	6908                	ld	a0,16(a0)
    80004be6:	00000097          	auipc	ra,0x0
    80004bea:	22e080e7          	jalr	558(ra) # 80004e14 <pipewrite>
    80004bee:	8a2a                	mv	s4,a0
    80004bf0:	a045                	j	80004c90 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004bf2:	02451783          	lh	a5,36(a0)
    80004bf6:	03079693          	slli	a3,a5,0x30
    80004bfa:	92c1                	srli	a3,a3,0x30
    80004bfc:	4725                	li	a4,9
    80004bfe:	0cd76263          	bltu	a4,a3,80004cc2 <filewrite+0x12c>
    80004c02:	0792                	slli	a5,a5,0x4
    80004c04:	0001d717          	auipc	a4,0x1d
    80004c08:	62470713          	addi	a4,a4,1572 # 80022228 <devsw>
    80004c0c:	97ba                	add	a5,a5,a4
    80004c0e:	679c                	ld	a5,8(a5)
    80004c10:	cbdd                	beqz	a5,80004cc6 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004c12:	4505                	li	a0,1
    80004c14:	9782                	jalr	a5
    80004c16:	8a2a                	mv	s4,a0
    80004c18:	a8a5                	j	80004c90 <filewrite+0xfa>
    80004c1a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004c1e:	00000097          	auipc	ra,0x0
    80004c22:	8b0080e7          	jalr	-1872(ra) # 800044ce <begin_op>
      ilock(f->ip);
    80004c26:	01893503          	ld	a0,24(s2)
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	ee2080e7          	jalr	-286(ra) # 80003b0c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c32:	8762                	mv	a4,s8
    80004c34:	02092683          	lw	a3,32(s2)
    80004c38:	01598633          	add	a2,s3,s5
    80004c3c:	4585                	li	a1,1
    80004c3e:	01893503          	ld	a0,24(s2)
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	276080e7          	jalr	630(ra) # 80003eb8 <writei>
    80004c4a:	84aa                	mv	s1,a0
    80004c4c:	00a05763          	blez	a0,80004c5a <filewrite+0xc4>
        f->off += r;
    80004c50:	02092783          	lw	a5,32(s2)
    80004c54:	9fa9                	addw	a5,a5,a0
    80004c56:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004c5a:	01893503          	ld	a0,24(s2)
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	f70080e7          	jalr	-144(ra) # 80003bce <iunlock>
      end_op();
    80004c66:	00000097          	auipc	ra,0x0
    80004c6a:	8e8080e7          	jalr	-1816(ra) # 8000454e <end_op>

      if(r != n1){
    80004c6e:	009c1f63          	bne	s8,s1,80004c8c <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004c72:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004c76:	0149db63          	bge	s3,s4,80004c8c <filewrite+0xf6>
      int n1 = n - i;
    80004c7a:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004c7e:	84be                	mv	s1,a5
    80004c80:	2781                	sext.w	a5,a5
    80004c82:	f8fb5ce3          	bge	s6,a5,80004c1a <filewrite+0x84>
    80004c86:	84de                	mv	s1,s7
    80004c88:	bf49                	j	80004c1a <filewrite+0x84>
    int i = 0;
    80004c8a:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004c8c:	013a1f63          	bne	s4,s3,80004caa <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004c90:	8552                	mv	a0,s4
    80004c92:	60a6                	ld	ra,72(sp)
    80004c94:	6406                	ld	s0,64(sp)
    80004c96:	74e2                	ld	s1,56(sp)
    80004c98:	7942                	ld	s2,48(sp)
    80004c9a:	79a2                	ld	s3,40(sp)
    80004c9c:	7a02                	ld	s4,32(sp)
    80004c9e:	6ae2                	ld	s5,24(sp)
    80004ca0:	6b42                	ld	s6,16(sp)
    80004ca2:	6ba2                	ld	s7,8(sp)
    80004ca4:	6c02                	ld	s8,0(sp)
    80004ca6:	6161                	addi	sp,sp,80
    80004ca8:	8082                	ret
    ret = (i == n ? n : -1);
    80004caa:	5a7d                	li	s4,-1
    80004cac:	b7d5                	j	80004c90 <filewrite+0xfa>
    panic("filewrite");
    80004cae:	00004517          	auipc	a0,0x4
    80004cb2:	a6a50513          	addi	a0,a0,-1430 # 80008718 <syscalls+0x288>
    80004cb6:	ffffc097          	auipc	ra,0xffffc
    80004cba:	888080e7          	jalr	-1912(ra) # 8000053e <panic>
    return -1;
    80004cbe:	5a7d                	li	s4,-1
    80004cc0:	bfc1                	j	80004c90 <filewrite+0xfa>
      return -1;
    80004cc2:	5a7d                	li	s4,-1
    80004cc4:	b7f1                	j	80004c90 <filewrite+0xfa>
    80004cc6:	5a7d                	li	s4,-1
    80004cc8:	b7e1                	j	80004c90 <filewrite+0xfa>

0000000080004cca <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004cca:	7179                	addi	sp,sp,-48
    80004ccc:	f406                	sd	ra,40(sp)
    80004cce:	f022                	sd	s0,32(sp)
    80004cd0:	ec26                	sd	s1,24(sp)
    80004cd2:	e84a                	sd	s2,16(sp)
    80004cd4:	e44e                	sd	s3,8(sp)
    80004cd6:	e052                	sd	s4,0(sp)
    80004cd8:	1800                	addi	s0,sp,48
    80004cda:	84aa                	mv	s1,a0
    80004cdc:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004cde:	0005b023          	sd	zero,0(a1)
    80004ce2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004ce6:	00000097          	auipc	ra,0x0
    80004cea:	bf8080e7          	jalr	-1032(ra) # 800048de <filealloc>
    80004cee:	e088                	sd	a0,0(s1)
    80004cf0:	c551                	beqz	a0,80004d7c <pipealloc+0xb2>
    80004cf2:	00000097          	auipc	ra,0x0
    80004cf6:	bec080e7          	jalr	-1044(ra) # 800048de <filealloc>
    80004cfa:	00aa3023          	sd	a0,0(s4)
    80004cfe:	c92d                	beqz	a0,80004d70 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d00:	ffffc097          	auipc	ra,0xffffc
    80004d04:	de6080e7          	jalr	-538(ra) # 80000ae6 <kalloc>
    80004d08:	892a                	mv	s2,a0
    80004d0a:	c125                	beqz	a0,80004d6a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004d0c:	4985                	li	s3,1
    80004d0e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d12:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d16:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d1a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d1e:	00004597          	auipc	a1,0x4
    80004d22:	a0a58593          	addi	a1,a1,-1526 # 80008728 <syscalls+0x298>
    80004d26:	ffffc097          	auipc	ra,0xffffc
    80004d2a:	e20080e7          	jalr	-480(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004d2e:	609c                	ld	a5,0(s1)
    80004d30:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004d34:	609c                	ld	a5,0(s1)
    80004d36:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004d3a:	609c                	ld	a5,0(s1)
    80004d3c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d40:	609c                	ld	a5,0(s1)
    80004d42:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d46:	000a3783          	ld	a5,0(s4)
    80004d4a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d4e:	000a3783          	ld	a5,0(s4)
    80004d52:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004d56:	000a3783          	ld	a5,0(s4)
    80004d5a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004d5e:	000a3783          	ld	a5,0(s4)
    80004d62:	0127b823          	sd	s2,16(a5)
  return 0;
    80004d66:	4501                	li	a0,0
    80004d68:	a025                	j	80004d90 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004d6a:	6088                	ld	a0,0(s1)
    80004d6c:	e501                	bnez	a0,80004d74 <pipealloc+0xaa>
    80004d6e:	a039                	j	80004d7c <pipealloc+0xb2>
    80004d70:	6088                	ld	a0,0(s1)
    80004d72:	c51d                	beqz	a0,80004da0 <pipealloc+0xd6>
    fileclose(*f0);
    80004d74:	00000097          	auipc	ra,0x0
    80004d78:	c26080e7          	jalr	-986(ra) # 8000499a <fileclose>
  if(*f1)
    80004d7c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004d80:	557d                	li	a0,-1
  if(*f1)
    80004d82:	c799                	beqz	a5,80004d90 <pipealloc+0xc6>
    fileclose(*f1);
    80004d84:	853e                	mv	a0,a5
    80004d86:	00000097          	auipc	ra,0x0
    80004d8a:	c14080e7          	jalr	-1004(ra) # 8000499a <fileclose>
  return -1;
    80004d8e:	557d                	li	a0,-1
}
    80004d90:	70a2                	ld	ra,40(sp)
    80004d92:	7402                	ld	s0,32(sp)
    80004d94:	64e2                	ld	s1,24(sp)
    80004d96:	6942                	ld	s2,16(sp)
    80004d98:	69a2                	ld	s3,8(sp)
    80004d9a:	6a02                	ld	s4,0(sp)
    80004d9c:	6145                	addi	sp,sp,48
    80004d9e:	8082                	ret
  return -1;
    80004da0:	557d                	li	a0,-1
    80004da2:	b7fd                	j	80004d90 <pipealloc+0xc6>

0000000080004da4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004da4:	1101                	addi	sp,sp,-32
    80004da6:	ec06                	sd	ra,24(sp)
    80004da8:	e822                	sd	s0,16(sp)
    80004daa:	e426                	sd	s1,8(sp)
    80004dac:	e04a                	sd	s2,0(sp)
    80004dae:	1000                	addi	s0,sp,32
    80004db0:	84aa                	mv	s1,a0
    80004db2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	e22080e7          	jalr	-478(ra) # 80000bd6 <acquire>
  if(writable){
    80004dbc:	02090d63          	beqz	s2,80004df6 <pipeclose+0x52>
    pi->writeopen = 0;
    80004dc0:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004dc4:	21848513          	addi	a0,s1,536
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	3e6080e7          	jalr	998(ra) # 800021ae <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004dd0:	2204b783          	ld	a5,544(s1)
    80004dd4:	eb95                	bnez	a5,80004e08 <pipeclose+0x64>
    release(&pi->lock);
    80004dd6:	8526                	mv	a0,s1
    80004dd8:	ffffc097          	auipc	ra,0xffffc
    80004ddc:	eb2080e7          	jalr	-334(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004de0:	8526                	mv	a0,s1
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	c08080e7          	jalr	-1016(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    80004dea:	60e2                	ld	ra,24(sp)
    80004dec:	6442                	ld	s0,16(sp)
    80004dee:	64a2                	ld	s1,8(sp)
    80004df0:	6902                	ld	s2,0(sp)
    80004df2:	6105                	addi	sp,sp,32
    80004df4:	8082                	ret
    pi->readopen = 0;
    80004df6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004dfa:	21c48513          	addi	a0,s1,540
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	3b0080e7          	jalr	944(ra) # 800021ae <wakeup>
    80004e06:	b7e9                	j	80004dd0 <pipeclose+0x2c>
    release(&pi->lock);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	ffffc097          	auipc	ra,0xffffc
    80004e0e:	e80080e7          	jalr	-384(ra) # 80000c8a <release>
}
    80004e12:	bfe1                	j	80004dea <pipeclose+0x46>

0000000080004e14 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e14:	711d                	addi	sp,sp,-96
    80004e16:	ec86                	sd	ra,88(sp)
    80004e18:	e8a2                	sd	s0,80(sp)
    80004e1a:	e4a6                	sd	s1,72(sp)
    80004e1c:	e0ca                	sd	s2,64(sp)
    80004e1e:	fc4e                	sd	s3,56(sp)
    80004e20:	f852                	sd	s4,48(sp)
    80004e22:	f456                	sd	s5,40(sp)
    80004e24:	f05a                	sd	s6,32(sp)
    80004e26:	ec5e                	sd	s7,24(sp)
    80004e28:	e862                	sd	s8,16(sp)
    80004e2a:	1080                	addi	s0,sp,96
    80004e2c:	84aa                	mv	s1,a0
    80004e2e:	8aae                	mv	s5,a1
    80004e30:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	b7a080e7          	jalr	-1158(ra) # 800019ac <myproc>
    80004e3a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	ffffc097          	auipc	ra,0xffffc
    80004e42:	d98080e7          	jalr	-616(ra) # 80000bd6 <acquire>
  while(i < n){
    80004e46:	0b405663          	blez	s4,80004ef2 <pipewrite+0xde>
  int i = 0;
    80004e4a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e4c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e4e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e52:	21c48b93          	addi	s7,s1,540
    80004e56:	a089                	j	80004e98 <pipewrite+0x84>
      release(&pi->lock);
    80004e58:	8526                	mv	a0,s1
    80004e5a:	ffffc097          	auipc	ra,0xffffc
    80004e5e:	e30080e7          	jalr	-464(ra) # 80000c8a <release>
      return -1;
    80004e62:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e64:	854a                	mv	a0,s2
    80004e66:	60e6                	ld	ra,88(sp)
    80004e68:	6446                	ld	s0,80(sp)
    80004e6a:	64a6                	ld	s1,72(sp)
    80004e6c:	6906                	ld	s2,64(sp)
    80004e6e:	79e2                	ld	s3,56(sp)
    80004e70:	7a42                	ld	s4,48(sp)
    80004e72:	7aa2                	ld	s5,40(sp)
    80004e74:	7b02                	ld	s6,32(sp)
    80004e76:	6be2                	ld	s7,24(sp)
    80004e78:	6c42                	ld	s8,16(sp)
    80004e7a:	6125                	addi	sp,sp,96
    80004e7c:	8082                	ret
      wakeup(&pi->nread);
    80004e7e:	8562                	mv	a0,s8
    80004e80:	ffffd097          	auipc	ra,0xffffd
    80004e84:	32e080e7          	jalr	814(ra) # 800021ae <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004e88:	85a6                	mv	a1,s1
    80004e8a:	855e                	mv	a0,s7
    80004e8c:	ffffd097          	auipc	ra,0xffffd
    80004e90:	2be080e7          	jalr	702(ra) # 8000214a <sleep>
  while(i < n){
    80004e94:	07495063          	bge	s2,s4,80004ef4 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004e98:	2204a783          	lw	a5,544(s1)
    80004e9c:	dfd5                	beqz	a5,80004e58 <pipewrite+0x44>
    80004e9e:	854e                	mv	a0,s3
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	5d2080e7          	jalr	1490(ra) # 80002472 <killed>
    80004ea8:	f945                	bnez	a0,80004e58 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004eaa:	2184a783          	lw	a5,536(s1)
    80004eae:	21c4a703          	lw	a4,540(s1)
    80004eb2:	2007879b          	addiw	a5,a5,512
    80004eb6:	fcf704e3          	beq	a4,a5,80004e7e <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004eba:	4685                	li	a3,1
    80004ebc:	01590633          	add	a2,s2,s5
    80004ec0:	faf40593          	addi	a1,s0,-81
    80004ec4:	0789b503          	ld	a0,120(s3)
    80004ec8:	ffffd097          	auipc	ra,0xffffd
    80004ecc:	82c080e7          	jalr	-2004(ra) # 800016f4 <copyin>
    80004ed0:	03650263          	beq	a0,s6,80004ef4 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ed4:	21c4a783          	lw	a5,540(s1)
    80004ed8:	0017871b          	addiw	a4,a5,1
    80004edc:	20e4ae23          	sw	a4,540(s1)
    80004ee0:	1ff7f793          	andi	a5,a5,511
    80004ee4:	97a6                	add	a5,a5,s1
    80004ee6:	faf44703          	lbu	a4,-81(s0)
    80004eea:	00e78c23          	sb	a4,24(a5)
      i++;
    80004eee:	2905                	addiw	s2,s2,1
    80004ef0:	b755                	j	80004e94 <pipewrite+0x80>
  int i = 0;
    80004ef2:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004ef4:	21848513          	addi	a0,s1,536
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	2b6080e7          	jalr	694(ra) # 800021ae <wakeup>
  release(&pi->lock);
    80004f00:	8526                	mv	a0,s1
    80004f02:	ffffc097          	auipc	ra,0xffffc
    80004f06:	d88080e7          	jalr	-632(ra) # 80000c8a <release>
  return i;
    80004f0a:	bfa9                	j	80004e64 <pipewrite+0x50>

0000000080004f0c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f0c:	715d                	addi	sp,sp,-80
    80004f0e:	e486                	sd	ra,72(sp)
    80004f10:	e0a2                	sd	s0,64(sp)
    80004f12:	fc26                	sd	s1,56(sp)
    80004f14:	f84a                	sd	s2,48(sp)
    80004f16:	f44e                	sd	s3,40(sp)
    80004f18:	f052                	sd	s4,32(sp)
    80004f1a:	ec56                	sd	s5,24(sp)
    80004f1c:	e85a                	sd	s6,16(sp)
    80004f1e:	0880                	addi	s0,sp,80
    80004f20:	84aa                	mv	s1,a0
    80004f22:	892e                	mv	s2,a1
    80004f24:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	a86080e7          	jalr	-1402(ra) # 800019ac <myproc>
    80004f2e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004f30:	8526                	mv	a0,s1
    80004f32:	ffffc097          	auipc	ra,0xffffc
    80004f36:	ca4080e7          	jalr	-860(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f3a:	2184a703          	lw	a4,536(s1)
    80004f3e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f42:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f46:	02f71763          	bne	a4,a5,80004f74 <piperead+0x68>
    80004f4a:	2244a783          	lw	a5,548(s1)
    80004f4e:	c39d                	beqz	a5,80004f74 <piperead+0x68>
    if(killed(pr)){
    80004f50:	8552                	mv	a0,s4
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	520080e7          	jalr	1312(ra) # 80002472 <killed>
    80004f5a:	e941                	bnez	a0,80004fea <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f5c:	85a6                	mv	a1,s1
    80004f5e:	854e                	mv	a0,s3
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	1ea080e7          	jalr	490(ra) # 8000214a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f68:	2184a703          	lw	a4,536(s1)
    80004f6c:	21c4a783          	lw	a5,540(s1)
    80004f70:	fcf70de3          	beq	a4,a5,80004f4a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f74:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f76:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f78:	05505363          	blez	s5,80004fbe <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004f7c:	2184a783          	lw	a5,536(s1)
    80004f80:	21c4a703          	lw	a4,540(s1)
    80004f84:	02f70d63          	beq	a4,a5,80004fbe <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004f88:	0017871b          	addiw	a4,a5,1
    80004f8c:	20e4ac23          	sw	a4,536(s1)
    80004f90:	1ff7f793          	andi	a5,a5,511
    80004f94:	97a6                	add	a5,a5,s1
    80004f96:	0187c783          	lbu	a5,24(a5)
    80004f9a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f9e:	4685                	li	a3,1
    80004fa0:	fbf40613          	addi	a2,s0,-65
    80004fa4:	85ca                	mv	a1,s2
    80004fa6:	078a3503          	ld	a0,120(s4)
    80004faa:	ffffc097          	auipc	ra,0xffffc
    80004fae:	6be080e7          	jalr	1726(ra) # 80001668 <copyout>
    80004fb2:	01650663          	beq	a0,s6,80004fbe <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fb6:	2985                	addiw	s3,s3,1
    80004fb8:	0905                	addi	s2,s2,1
    80004fba:	fd3a91e3          	bne	s5,s3,80004f7c <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004fbe:	21c48513          	addi	a0,s1,540
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	1ec080e7          	jalr	492(ra) # 800021ae <wakeup>
  release(&pi->lock);
    80004fca:	8526                	mv	a0,s1
    80004fcc:	ffffc097          	auipc	ra,0xffffc
    80004fd0:	cbe080e7          	jalr	-834(ra) # 80000c8a <release>
  return i;
}
    80004fd4:	854e                	mv	a0,s3
    80004fd6:	60a6                	ld	ra,72(sp)
    80004fd8:	6406                	ld	s0,64(sp)
    80004fda:	74e2                	ld	s1,56(sp)
    80004fdc:	7942                	ld	s2,48(sp)
    80004fde:	79a2                	ld	s3,40(sp)
    80004fe0:	7a02                	ld	s4,32(sp)
    80004fe2:	6ae2                	ld	s5,24(sp)
    80004fe4:	6b42                	ld	s6,16(sp)
    80004fe6:	6161                	addi	sp,sp,80
    80004fe8:	8082                	ret
      release(&pi->lock);
    80004fea:	8526                	mv	a0,s1
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	c9e080e7          	jalr	-866(ra) # 80000c8a <release>
      return -1;
    80004ff4:	59fd                	li	s3,-1
    80004ff6:	bff9                	j	80004fd4 <piperead+0xc8>

0000000080004ff8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004ff8:	1141                	addi	sp,sp,-16
    80004ffa:	e422                	sd	s0,8(sp)
    80004ffc:	0800                	addi	s0,sp,16
    80004ffe:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005000:	8905                	andi	a0,a0,1
    80005002:	c111                	beqz	a0,80005006 <flags2perm+0xe>
      perm = PTE_X;
    80005004:	4521                	li	a0,8
    if(flags & 0x2)
    80005006:	8b89                	andi	a5,a5,2
    80005008:	c399                	beqz	a5,8000500e <flags2perm+0x16>
      perm |= PTE_W;
    8000500a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000500e:	6422                	ld	s0,8(sp)
    80005010:	0141                	addi	sp,sp,16
    80005012:	8082                	ret

0000000080005014 <exec>:

int
exec(char *path, char **argv)
{
    80005014:	de010113          	addi	sp,sp,-544
    80005018:	20113c23          	sd	ra,536(sp)
    8000501c:	20813823          	sd	s0,528(sp)
    80005020:	20913423          	sd	s1,520(sp)
    80005024:	21213023          	sd	s2,512(sp)
    80005028:	ffce                	sd	s3,504(sp)
    8000502a:	fbd2                	sd	s4,496(sp)
    8000502c:	f7d6                	sd	s5,488(sp)
    8000502e:	f3da                	sd	s6,480(sp)
    80005030:	efde                	sd	s7,472(sp)
    80005032:	ebe2                	sd	s8,464(sp)
    80005034:	e7e6                	sd	s9,456(sp)
    80005036:	e3ea                	sd	s10,448(sp)
    80005038:	ff6e                	sd	s11,440(sp)
    8000503a:	1400                	addi	s0,sp,544
    8000503c:	892a                	mv	s2,a0
    8000503e:	dea43423          	sd	a0,-536(s0)
    80005042:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	966080e7          	jalr	-1690(ra) # 800019ac <myproc>
    8000504e:	84aa                	mv	s1,a0

  begin_op();
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	47e080e7          	jalr	1150(ra) # 800044ce <begin_op>

  if((ip = namei(path)) == 0){
    80005058:	854a                	mv	a0,s2
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	258080e7          	jalr	600(ra) # 800042b2 <namei>
    80005062:	c93d                	beqz	a0,800050d8 <exec+0xc4>
    80005064:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	aa6080e7          	jalr	-1370(ra) # 80003b0c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000506e:	04000713          	li	a4,64
    80005072:	4681                	li	a3,0
    80005074:	e5040613          	addi	a2,s0,-432
    80005078:	4581                	li	a1,0
    8000507a:	8556                	mv	a0,s5
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	d44080e7          	jalr	-700(ra) # 80003dc0 <readi>
    80005084:	04000793          	li	a5,64
    80005088:	00f51a63          	bne	a0,a5,8000509c <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000508c:	e5042703          	lw	a4,-432(s0)
    80005090:	464c47b7          	lui	a5,0x464c4
    80005094:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005098:	04f70663          	beq	a4,a5,800050e4 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000509c:	8556                	mv	a0,s5
    8000509e:	fffff097          	auipc	ra,0xfffff
    800050a2:	cd0080e7          	jalr	-816(ra) # 80003d6e <iunlockput>
    end_op();
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	4a8080e7          	jalr	1192(ra) # 8000454e <end_op>
  }
  return -1;
    800050ae:	557d                	li	a0,-1
}
    800050b0:	21813083          	ld	ra,536(sp)
    800050b4:	21013403          	ld	s0,528(sp)
    800050b8:	20813483          	ld	s1,520(sp)
    800050bc:	20013903          	ld	s2,512(sp)
    800050c0:	79fe                	ld	s3,504(sp)
    800050c2:	7a5e                	ld	s4,496(sp)
    800050c4:	7abe                	ld	s5,488(sp)
    800050c6:	7b1e                	ld	s6,480(sp)
    800050c8:	6bfe                	ld	s7,472(sp)
    800050ca:	6c5e                	ld	s8,464(sp)
    800050cc:	6cbe                	ld	s9,456(sp)
    800050ce:	6d1e                	ld	s10,448(sp)
    800050d0:	7dfa                	ld	s11,440(sp)
    800050d2:	22010113          	addi	sp,sp,544
    800050d6:	8082                	ret
    end_op();
    800050d8:	fffff097          	auipc	ra,0xfffff
    800050dc:	476080e7          	jalr	1142(ra) # 8000454e <end_op>
    return -1;
    800050e0:	557d                	li	a0,-1
    800050e2:	b7f9                	j	800050b0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    800050e4:	8526                	mv	a0,s1
    800050e6:	ffffd097          	auipc	ra,0xffffd
    800050ea:	98a080e7          	jalr	-1654(ra) # 80001a70 <proc_pagetable>
    800050ee:	8b2a                	mv	s6,a0
    800050f0:	d555                	beqz	a0,8000509c <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050f2:	e7042783          	lw	a5,-400(s0)
    800050f6:	e8845703          	lhu	a4,-376(s0)
    800050fa:	c735                	beqz	a4,80005166 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800050fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050fe:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80005102:	6a05                	lui	s4,0x1
    80005104:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005108:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    8000510c:	6d85                	lui	s11,0x1
    8000510e:	7d7d                	lui	s10,0xfffff
    80005110:	a481                	j	80005350 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80005112:	00003517          	auipc	a0,0x3
    80005116:	61e50513          	addi	a0,a0,1566 # 80008730 <syscalls+0x2a0>
    8000511a:	ffffb097          	auipc	ra,0xffffb
    8000511e:	424080e7          	jalr	1060(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005122:	874a                	mv	a4,s2
    80005124:	009c86bb          	addw	a3,s9,s1
    80005128:	4581                	li	a1,0
    8000512a:	8556                	mv	a0,s5
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	c94080e7          	jalr	-876(ra) # 80003dc0 <readi>
    80005134:	2501                	sext.w	a0,a0
    80005136:	1aa91a63          	bne	s2,a0,800052ea <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    8000513a:	009d84bb          	addw	s1,s11,s1
    8000513e:	013d09bb          	addw	s3,s10,s3
    80005142:	1f74f763          	bgeu	s1,s7,80005330 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80005146:	02049593          	slli	a1,s1,0x20
    8000514a:	9181                	srli	a1,a1,0x20
    8000514c:	95e2                	add	a1,a1,s8
    8000514e:	855a                	mv	a0,s6
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	f0c080e7          	jalr	-244(ra) # 8000105c <walkaddr>
    80005158:	862a                	mv	a2,a0
    if(pa == 0)
    8000515a:	dd45                	beqz	a0,80005112 <exec+0xfe>
      n = PGSIZE;
    8000515c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    8000515e:	fd49f2e3          	bgeu	s3,s4,80005122 <exec+0x10e>
      n = sz - i;
    80005162:	894e                	mv	s2,s3
    80005164:	bf7d                	j	80005122 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005166:	4901                	li	s2,0
  iunlockput(ip);
    80005168:	8556                	mv	a0,s5
    8000516a:	fffff097          	auipc	ra,0xfffff
    8000516e:	c04080e7          	jalr	-1020(ra) # 80003d6e <iunlockput>
  end_op();
    80005172:	fffff097          	auipc	ra,0xfffff
    80005176:	3dc080e7          	jalr	988(ra) # 8000454e <end_op>
  p = myproc();
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	832080e7          	jalr	-1998(ra) # 800019ac <myproc>
    80005182:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80005184:	07053d03          	ld	s10,112(a0)
  sz = PGROUNDUP(sz);
    80005188:	6785                	lui	a5,0x1
    8000518a:	17fd                	addi	a5,a5,-1
    8000518c:	993e                	add	s2,s2,a5
    8000518e:	77fd                	lui	a5,0xfffff
    80005190:	00f977b3          	and	a5,s2,a5
    80005194:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005198:	4691                	li	a3,4
    8000519a:	6609                	lui	a2,0x2
    8000519c:	963e                	add	a2,a2,a5
    8000519e:	85be                	mv	a1,a5
    800051a0:	855a                	mv	a0,s6
    800051a2:	ffffc097          	auipc	ra,0xffffc
    800051a6:	26e080e7          	jalr	622(ra) # 80001410 <uvmalloc>
    800051aa:	8c2a                	mv	s8,a0
  ip = 0;
    800051ac:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800051ae:	12050e63          	beqz	a0,800052ea <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800051b2:	75f9                	lui	a1,0xffffe
    800051b4:	95aa                	add	a1,a1,a0
    800051b6:	855a                	mv	a0,s6
    800051b8:	ffffc097          	auipc	ra,0xffffc
    800051bc:	47e080e7          	jalr	1150(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    800051c0:	7afd                	lui	s5,0xfffff
    800051c2:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800051c4:	df043783          	ld	a5,-528(s0)
    800051c8:	6388                	ld	a0,0(a5)
    800051ca:	c925                	beqz	a0,8000523a <exec+0x226>
    800051cc:	e9040993          	addi	s3,s0,-368
    800051d0:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800051d4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800051d6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c76080e7          	jalr	-906(ra) # 80000e4e <strlen>
    800051e0:	0015079b          	addiw	a5,a0,1
    800051e4:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800051e8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800051ec:	13596663          	bltu	s2,s5,80005318 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800051f0:	df043d83          	ld	s11,-528(s0)
    800051f4:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    800051f8:	8552                	mv	a0,s4
    800051fa:	ffffc097          	auipc	ra,0xffffc
    800051fe:	c54080e7          	jalr	-940(ra) # 80000e4e <strlen>
    80005202:	0015069b          	addiw	a3,a0,1
    80005206:	8652                	mv	a2,s4
    80005208:	85ca                	mv	a1,s2
    8000520a:	855a                	mv	a0,s6
    8000520c:	ffffc097          	auipc	ra,0xffffc
    80005210:	45c080e7          	jalr	1116(ra) # 80001668 <copyout>
    80005214:	10054663          	bltz	a0,80005320 <exec+0x30c>
    ustack[argc] = sp;
    80005218:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000521c:	0485                	addi	s1,s1,1
    8000521e:	008d8793          	addi	a5,s11,8
    80005222:	def43823          	sd	a5,-528(s0)
    80005226:	008db503          	ld	a0,8(s11)
    8000522a:	c911                	beqz	a0,8000523e <exec+0x22a>
    if(argc >= MAXARG)
    8000522c:	09a1                	addi	s3,s3,8
    8000522e:	fb3c95e3          	bne	s9,s3,800051d8 <exec+0x1c4>
  sz = sz1;
    80005232:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005236:	4a81                	li	s5,0
    80005238:	a84d                	j	800052ea <exec+0x2d6>
  sp = sz;
    8000523a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000523c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000523e:	00349793          	slli	a5,s1,0x3
    80005242:	f9040713          	addi	a4,s0,-112
    80005246:	97ba                	add	a5,a5,a4
    80005248:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdbb40>
  sp -= (argc+1) * sizeof(uint64);
    8000524c:	00148693          	addi	a3,s1,1
    80005250:	068e                	slli	a3,a3,0x3
    80005252:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005256:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000525a:	01597663          	bgeu	s2,s5,80005266 <exec+0x252>
  sz = sz1;
    8000525e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005262:	4a81                	li	s5,0
    80005264:	a059                	j	800052ea <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005266:	e9040613          	addi	a2,s0,-368
    8000526a:	85ca                	mv	a1,s2
    8000526c:	855a                	mv	a0,s6
    8000526e:	ffffc097          	auipc	ra,0xffffc
    80005272:	3fa080e7          	jalr	1018(ra) # 80001668 <copyout>
    80005276:	0a054963          	bltz	a0,80005328 <exec+0x314>
  p->trapframe->a1 = sp;
    8000527a:	080bb783          	ld	a5,128(s7) # 1080 <_entry-0x7fffef80>
    8000527e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005282:	de843783          	ld	a5,-536(s0)
    80005286:	0007c703          	lbu	a4,0(a5)
    8000528a:	cf11                	beqz	a4,800052a6 <exec+0x292>
    8000528c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000528e:	02f00693          	li	a3,47
    80005292:	a039                	j	800052a0 <exec+0x28c>
      last = s+1;
    80005294:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005298:	0785                	addi	a5,a5,1
    8000529a:	fff7c703          	lbu	a4,-1(a5)
    8000529e:	c701                	beqz	a4,800052a6 <exec+0x292>
    if(*s == '/')
    800052a0:	fed71ce3          	bne	a4,a3,80005298 <exec+0x284>
    800052a4:	bfc5                	j	80005294 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    800052a6:	4641                	li	a2,16
    800052a8:	de843583          	ld	a1,-536(s0)
    800052ac:	180b8513          	addi	a0,s7,384
    800052b0:	ffffc097          	auipc	ra,0xffffc
    800052b4:	b6c080e7          	jalr	-1172(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    800052b8:	078bb503          	ld	a0,120(s7)
  p->pagetable = pagetable;
    800052bc:	076bbc23          	sd	s6,120(s7)
  p->sz = sz;
    800052c0:	078bb823          	sd	s8,112(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800052c4:	080bb783          	ld	a5,128(s7)
    800052c8:	e6843703          	ld	a4,-408(s0)
    800052cc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800052ce:	080bb783          	ld	a5,128(s7)
    800052d2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800052d6:	85ea                	mv	a1,s10
    800052d8:	ffffd097          	auipc	ra,0xffffd
    800052dc:	834080e7          	jalr	-1996(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800052e0:	0004851b          	sext.w	a0,s1
    800052e4:	b3f1                	j	800050b0 <exec+0x9c>
    800052e6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800052ea:	df843583          	ld	a1,-520(s0)
    800052ee:	855a                	mv	a0,s6
    800052f0:	ffffd097          	auipc	ra,0xffffd
    800052f4:	81c080e7          	jalr	-2020(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    800052f8:	da0a92e3          	bnez	s5,8000509c <exec+0x88>
  return -1;
    800052fc:	557d                	li	a0,-1
    800052fe:	bb4d                	j	800050b0 <exec+0x9c>
    80005300:	df243c23          	sd	s2,-520(s0)
    80005304:	b7dd                	j	800052ea <exec+0x2d6>
    80005306:	df243c23          	sd	s2,-520(s0)
    8000530a:	b7c5                	j	800052ea <exec+0x2d6>
    8000530c:	df243c23          	sd	s2,-520(s0)
    80005310:	bfe9                	j	800052ea <exec+0x2d6>
    80005312:	df243c23          	sd	s2,-520(s0)
    80005316:	bfd1                	j	800052ea <exec+0x2d6>
  sz = sz1;
    80005318:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000531c:	4a81                	li	s5,0
    8000531e:	b7f1                	j	800052ea <exec+0x2d6>
  sz = sz1;
    80005320:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005324:	4a81                	li	s5,0
    80005326:	b7d1                	j	800052ea <exec+0x2d6>
  sz = sz1;
    80005328:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000532c:	4a81                	li	s5,0
    8000532e:	bf75                	j	800052ea <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005330:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005334:	e0843783          	ld	a5,-504(s0)
    80005338:	0017869b          	addiw	a3,a5,1
    8000533c:	e0d43423          	sd	a3,-504(s0)
    80005340:	e0043783          	ld	a5,-512(s0)
    80005344:	0387879b          	addiw	a5,a5,56
    80005348:	e8845703          	lhu	a4,-376(s0)
    8000534c:	e0e6dee3          	bge	a3,a4,80005168 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005350:	2781                	sext.w	a5,a5
    80005352:	e0f43023          	sd	a5,-512(s0)
    80005356:	03800713          	li	a4,56
    8000535a:	86be                	mv	a3,a5
    8000535c:	e1840613          	addi	a2,s0,-488
    80005360:	4581                	li	a1,0
    80005362:	8556                	mv	a0,s5
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	a5c080e7          	jalr	-1444(ra) # 80003dc0 <readi>
    8000536c:	03800793          	li	a5,56
    80005370:	f6f51be3          	bne	a0,a5,800052e6 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80005374:	e1842783          	lw	a5,-488(s0)
    80005378:	4705                	li	a4,1
    8000537a:	fae79de3          	bne	a5,a4,80005334 <exec+0x320>
    if(ph.memsz < ph.filesz)
    8000537e:	e4043483          	ld	s1,-448(s0)
    80005382:	e3843783          	ld	a5,-456(s0)
    80005386:	f6f4ede3          	bltu	s1,a5,80005300 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000538a:	e2843783          	ld	a5,-472(s0)
    8000538e:	94be                	add	s1,s1,a5
    80005390:	f6f4ebe3          	bltu	s1,a5,80005306 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80005394:	de043703          	ld	a4,-544(s0)
    80005398:	8ff9                	and	a5,a5,a4
    8000539a:	fbad                	bnez	a5,8000530c <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000539c:	e1c42503          	lw	a0,-484(s0)
    800053a0:	00000097          	auipc	ra,0x0
    800053a4:	c58080e7          	jalr	-936(ra) # 80004ff8 <flags2perm>
    800053a8:	86aa                	mv	a3,a0
    800053aa:	8626                	mv	a2,s1
    800053ac:	85ca                	mv	a1,s2
    800053ae:	855a                	mv	a0,s6
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	060080e7          	jalr	96(ra) # 80001410 <uvmalloc>
    800053b8:	dea43c23          	sd	a0,-520(s0)
    800053bc:	d939                	beqz	a0,80005312 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800053be:	e2843c03          	ld	s8,-472(s0)
    800053c2:	e2042c83          	lw	s9,-480(s0)
    800053c6:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800053ca:	f60b83e3          	beqz	s7,80005330 <exec+0x31c>
    800053ce:	89de                	mv	s3,s7
    800053d0:	4481                	li	s1,0
    800053d2:	bb95                	j	80005146 <exec+0x132>

00000000800053d4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800053d4:	7179                	addi	sp,sp,-48
    800053d6:	f406                	sd	ra,40(sp)
    800053d8:	f022                	sd	s0,32(sp)
    800053da:	ec26                	sd	s1,24(sp)
    800053dc:	e84a                	sd	s2,16(sp)
    800053de:	1800                	addi	s0,sp,48
    800053e0:	892e                	mv	s2,a1
    800053e2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800053e4:	fdc40593          	addi	a1,s0,-36
    800053e8:	ffffe097          	auipc	ra,0xffffe
    800053ec:	af8080e7          	jalr	-1288(ra) # 80002ee0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800053f0:	fdc42703          	lw	a4,-36(s0)
    800053f4:	47bd                	li	a5,15
    800053f6:	02e7eb63          	bltu	a5,a4,8000542c <argfd+0x58>
    800053fa:	ffffc097          	auipc	ra,0xffffc
    800053fe:	5b2080e7          	jalr	1458(ra) # 800019ac <myproc>
    80005402:	fdc42703          	lw	a4,-36(s0)
    80005406:	01e70793          	addi	a5,a4,30
    8000540a:	078e                	slli	a5,a5,0x3
    8000540c:	953e                	add	a0,a0,a5
    8000540e:	651c                	ld	a5,8(a0)
    80005410:	c385                	beqz	a5,80005430 <argfd+0x5c>
    return -1;
  if(pfd)
    80005412:	00090463          	beqz	s2,8000541a <argfd+0x46>
    *pfd = fd;
    80005416:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000541a:	4501                	li	a0,0
  if(pf)
    8000541c:	c091                	beqz	s1,80005420 <argfd+0x4c>
    *pf = f;
    8000541e:	e09c                	sd	a5,0(s1)
}
    80005420:	70a2                	ld	ra,40(sp)
    80005422:	7402                	ld	s0,32(sp)
    80005424:	64e2                	ld	s1,24(sp)
    80005426:	6942                	ld	s2,16(sp)
    80005428:	6145                	addi	sp,sp,48
    8000542a:	8082                	ret
    return -1;
    8000542c:	557d                	li	a0,-1
    8000542e:	bfcd                	j	80005420 <argfd+0x4c>
    80005430:	557d                	li	a0,-1
    80005432:	b7fd                	j	80005420 <argfd+0x4c>

0000000080005434 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005434:	1101                	addi	sp,sp,-32
    80005436:	ec06                	sd	ra,24(sp)
    80005438:	e822                	sd	s0,16(sp)
    8000543a:	e426                	sd	s1,8(sp)
    8000543c:	1000                	addi	s0,sp,32
    8000543e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005440:	ffffc097          	auipc	ra,0xffffc
    80005444:	56c080e7          	jalr	1388(ra) # 800019ac <myproc>
    80005448:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000544a:	0f850793          	addi	a5,a0,248
    8000544e:	4501                	li	a0,0
    80005450:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005452:	6398                	ld	a4,0(a5)
    80005454:	cb19                	beqz	a4,8000546a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005456:	2505                	addiw	a0,a0,1
    80005458:	07a1                	addi	a5,a5,8
    8000545a:	fed51ce3          	bne	a0,a3,80005452 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000545e:	557d                	li	a0,-1
}
    80005460:	60e2                	ld	ra,24(sp)
    80005462:	6442                	ld	s0,16(sp)
    80005464:	64a2                	ld	s1,8(sp)
    80005466:	6105                	addi	sp,sp,32
    80005468:	8082                	ret
      p->ofile[fd] = f;
    8000546a:	01e50793          	addi	a5,a0,30
    8000546e:	078e                	slli	a5,a5,0x3
    80005470:	963e                	add	a2,a2,a5
    80005472:	e604                	sd	s1,8(a2)
      return fd;
    80005474:	b7f5                	j	80005460 <fdalloc+0x2c>

0000000080005476 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005476:	715d                	addi	sp,sp,-80
    80005478:	e486                	sd	ra,72(sp)
    8000547a:	e0a2                	sd	s0,64(sp)
    8000547c:	fc26                	sd	s1,56(sp)
    8000547e:	f84a                	sd	s2,48(sp)
    80005480:	f44e                	sd	s3,40(sp)
    80005482:	f052                	sd	s4,32(sp)
    80005484:	ec56                	sd	s5,24(sp)
    80005486:	e85a                	sd	s6,16(sp)
    80005488:	0880                	addi	s0,sp,80
    8000548a:	8b2e                	mv	s6,a1
    8000548c:	89b2                	mv	s3,a2
    8000548e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005490:	fb040593          	addi	a1,s0,-80
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	e3c080e7          	jalr	-452(ra) # 800042d0 <nameiparent>
    8000549c:	84aa                	mv	s1,a0
    8000549e:	14050f63          	beqz	a0,800055fc <create+0x186>
    return 0;

  ilock(dp);
    800054a2:	ffffe097          	auipc	ra,0xffffe
    800054a6:	66a080e7          	jalr	1642(ra) # 80003b0c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800054aa:	4601                	li	a2,0
    800054ac:	fb040593          	addi	a1,s0,-80
    800054b0:	8526                	mv	a0,s1
    800054b2:	fffff097          	auipc	ra,0xfffff
    800054b6:	b3e080e7          	jalr	-1218(ra) # 80003ff0 <dirlookup>
    800054ba:	8aaa                	mv	s5,a0
    800054bc:	c931                	beqz	a0,80005510 <create+0x9a>
    iunlockput(dp);
    800054be:	8526                	mv	a0,s1
    800054c0:	fffff097          	auipc	ra,0xfffff
    800054c4:	8ae080e7          	jalr	-1874(ra) # 80003d6e <iunlockput>
    ilock(ip);
    800054c8:	8556                	mv	a0,s5
    800054ca:	ffffe097          	auipc	ra,0xffffe
    800054ce:	642080e7          	jalr	1602(ra) # 80003b0c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800054d2:	000b059b          	sext.w	a1,s6
    800054d6:	4789                	li	a5,2
    800054d8:	02f59563          	bne	a1,a5,80005502 <create+0x8c>
    800054dc:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdbc84>
    800054e0:	37f9                	addiw	a5,a5,-2
    800054e2:	17c2                	slli	a5,a5,0x30
    800054e4:	93c1                	srli	a5,a5,0x30
    800054e6:	4705                	li	a4,1
    800054e8:	00f76d63          	bltu	a4,a5,80005502 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800054ec:	8556                	mv	a0,s5
    800054ee:	60a6                	ld	ra,72(sp)
    800054f0:	6406                	ld	s0,64(sp)
    800054f2:	74e2                	ld	s1,56(sp)
    800054f4:	7942                	ld	s2,48(sp)
    800054f6:	79a2                	ld	s3,40(sp)
    800054f8:	7a02                	ld	s4,32(sp)
    800054fa:	6ae2                	ld	s5,24(sp)
    800054fc:	6b42                	ld	s6,16(sp)
    800054fe:	6161                	addi	sp,sp,80
    80005500:	8082                	ret
    iunlockput(ip);
    80005502:	8556                	mv	a0,s5
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	86a080e7          	jalr	-1942(ra) # 80003d6e <iunlockput>
    return 0;
    8000550c:	4a81                	li	s5,0
    8000550e:	bff9                	j	800054ec <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005510:	85da                	mv	a1,s6
    80005512:	4088                	lw	a0,0(s1)
    80005514:	ffffe097          	auipc	ra,0xffffe
    80005518:	45c080e7          	jalr	1116(ra) # 80003970 <ialloc>
    8000551c:	8a2a                	mv	s4,a0
    8000551e:	c539                	beqz	a0,8000556c <create+0xf6>
  ilock(ip);
    80005520:	ffffe097          	auipc	ra,0xffffe
    80005524:	5ec080e7          	jalr	1516(ra) # 80003b0c <ilock>
  ip->major = major;
    80005528:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000552c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005530:	4905                	li	s2,1
    80005532:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005536:	8552                	mv	a0,s4
    80005538:	ffffe097          	auipc	ra,0xffffe
    8000553c:	50a080e7          	jalr	1290(ra) # 80003a42 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005540:	000b059b          	sext.w	a1,s6
    80005544:	03258b63          	beq	a1,s2,8000557a <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005548:	004a2603          	lw	a2,4(s4)
    8000554c:	fb040593          	addi	a1,s0,-80
    80005550:	8526                	mv	a0,s1
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	cae080e7          	jalr	-850(ra) # 80004200 <dirlink>
    8000555a:	06054f63          	bltz	a0,800055d8 <create+0x162>
  iunlockput(dp);
    8000555e:	8526                	mv	a0,s1
    80005560:	fffff097          	auipc	ra,0xfffff
    80005564:	80e080e7          	jalr	-2034(ra) # 80003d6e <iunlockput>
  return ip;
    80005568:	8ad2                	mv	s5,s4
    8000556a:	b749                	j	800054ec <create+0x76>
    iunlockput(dp);
    8000556c:	8526                	mv	a0,s1
    8000556e:	fffff097          	auipc	ra,0xfffff
    80005572:	800080e7          	jalr	-2048(ra) # 80003d6e <iunlockput>
    return 0;
    80005576:	8ad2                	mv	s5,s4
    80005578:	bf95                	j	800054ec <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000557a:	004a2603          	lw	a2,4(s4)
    8000557e:	00003597          	auipc	a1,0x3
    80005582:	1d258593          	addi	a1,a1,466 # 80008750 <syscalls+0x2c0>
    80005586:	8552                	mv	a0,s4
    80005588:	fffff097          	auipc	ra,0xfffff
    8000558c:	c78080e7          	jalr	-904(ra) # 80004200 <dirlink>
    80005590:	04054463          	bltz	a0,800055d8 <create+0x162>
    80005594:	40d0                	lw	a2,4(s1)
    80005596:	00003597          	auipc	a1,0x3
    8000559a:	1c258593          	addi	a1,a1,450 # 80008758 <syscalls+0x2c8>
    8000559e:	8552                	mv	a0,s4
    800055a0:	fffff097          	auipc	ra,0xfffff
    800055a4:	c60080e7          	jalr	-928(ra) # 80004200 <dirlink>
    800055a8:	02054863          	bltz	a0,800055d8 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800055ac:	004a2603          	lw	a2,4(s4)
    800055b0:	fb040593          	addi	a1,s0,-80
    800055b4:	8526                	mv	a0,s1
    800055b6:	fffff097          	auipc	ra,0xfffff
    800055ba:	c4a080e7          	jalr	-950(ra) # 80004200 <dirlink>
    800055be:	00054d63          	bltz	a0,800055d8 <create+0x162>
    dp->nlink++;  // for ".."
    800055c2:	04a4d783          	lhu	a5,74(s1)
    800055c6:	2785                	addiw	a5,a5,1
    800055c8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800055cc:	8526                	mv	a0,s1
    800055ce:	ffffe097          	auipc	ra,0xffffe
    800055d2:	474080e7          	jalr	1140(ra) # 80003a42 <iupdate>
    800055d6:	b761                	j	8000555e <create+0xe8>
  ip->nlink = 0;
    800055d8:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800055dc:	8552                	mv	a0,s4
    800055de:	ffffe097          	auipc	ra,0xffffe
    800055e2:	464080e7          	jalr	1124(ra) # 80003a42 <iupdate>
  iunlockput(ip);
    800055e6:	8552                	mv	a0,s4
    800055e8:	ffffe097          	auipc	ra,0xffffe
    800055ec:	786080e7          	jalr	1926(ra) # 80003d6e <iunlockput>
  iunlockput(dp);
    800055f0:	8526                	mv	a0,s1
    800055f2:	ffffe097          	auipc	ra,0xffffe
    800055f6:	77c080e7          	jalr	1916(ra) # 80003d6e <iunlockput>
  return 0;
    800055fa:	bdcd                	j	800054ec <create+0x76>
    return 0;
    800055fc:	8aaa                	mv	s5,a0
    800055fe:	b5fd                	j	800054ec <create+0x76>

0000000080005600 <sys_dup>:
{
    80005600:	7179                	addi	sp,sp,-48
    80005602:	f406                	sd	ra,40(sp)
    80005604:	f022                	sd	s0,32(sp)
    80005606:	ec26                	sd	s1,24(sp)
    80005608:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000560a:	fd840613          	addi	a2,s0,-40
    8000560e:	4581                	li	a1,0
    80005610:	4501                	li	a0,0
    80005612:	00000097          	auipc	ra,0x0
    80005616:	dc2080e7          	jalr	-574(ra) # 800053d4 <argfd>
    return -1;
    8000561a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000561c:	02054363          	bltz	a0,80005642 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005620:	fd843503          	ld	a0,-40(s0)
    80005624:	00000097          	auipc	ra,0x0
    80005628:	e10080e7          	jalr	-496(ra) # 80005434 <fdalloc>
    8000562c:	84aa                	mv	s1,a0
    return -1;
    8000562e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005630:	00054963          	bltz	a0,80005642 <sys_dup+0x42>
  filedup(f);
    80005634:	fd843503          	ld	a0,-40(s0)
    80005638:	fffff097          	auipc	ra,0xfffff
    8000563c:	310080e7          	jalr	784(ra) # 80004948 <filedup>
  return fd;
    80005640:	87a6                	mv	a5,s1
}
    80005642:	853e                	mv	a0,a5
    80005644:	70a2                	ld	ra,40(sp)
    80005646:	7402                	ld	s0,32(sp)
    80005648:	64e2                	ld	s1,24(sp)
    8000564a:	6145                	addi	sp,sp,48
    8000564c:	8082                	ret

000000008000564e <sys_read>:
{
    8000564e:	7179                	addi	sp,sp,-48
    80005650:	f406                	sd	ra,40(sp)
    80005652:	f022                	sd	s0,32(sp)
    80005654:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005656:	fd840593          	addi	a1,s0,-40
    8000565a:	4505                	li	a0,1
    8000565c:	ffffe097          	auipc	ra,0xffffe
    80005660:	8a4080e7          	jalr	-1884(ra) # 80002f00 <argaddr>
  argint(2, &n);
    80005664:	fe440593          	addi	a1,s0,-28
    80005668:	4509                	li	a0,2
    8000566a:	ffffe097          	auipc	ra,0xffffe
    8000566e:	876080e7          	jalr	-1930(ra) # 80002ee0 <argint>
  if(argfd(0, 0, &f) < 0)
    80005672:	fe840613          	addi	a2,s0,-24
    80005676:	4581                	li	a1,0
    80005678:	4501                	li	a0,0
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	d5a080e7          	jalr	-678(ra) # 800053d4 <argfd>
    80005682:	87aa                	mv	a5,a0
    return -1;
    80005684:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005686:	0007cc63          	bltz	a5,8000569e <sys_read+0x50>
  return fileread(f, p, n);
    8000568a:	fe442603          	lw	a2,-28(s0)
    8000568e:	fd843583          	ld	a1,-40(s0)
    80005692:	fe843503          	ld	a0,-24(s0)
    80005696:	fffff097          	auipc	ra,0xfffff
    8000569a:	43e080e7          	jalr	1086(ra) # 80004ad4 <fileread>
}
    8000569e:	70a2                	ld	ra,40(sp)
    800056a0:	7402                	ld	s0,32(sp)
    800056a2:	6145                	addi	sp,sp,48
    800056a4:	8082                	ret

00000000800056a6 <sys_write>:
{
    800056a6:	7179                	addi	sp,sp,-48
    800056a8:	f406                	sd	ra,40(sp)
    800056aa:	f022                	sd	s0,32(sp)
    800056ac:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056ae:	fd840593          	addi	a1,s0,-40
    800056b2:	4505                	li	a0,1
    800056b4:	ffffe097          	auipc	ra,0xffffe
    800056b8:	84c080e7          	jalr	-1972(ra) # 80002f00 <argaddr>
  argint(2, &n);
    800056bc:	fe440593          	addi	a1,s0,-28
    800056c0:	4509                	li	a0,2
    800056c2:	ffffe097          	auipc	ra,0xffffe
    800056c6:	81e080e7          	jalr	-2018(ra) # 80002ee0 <argint>
  if(argfd(0, 0, &f) < 0)
    800056ca:	fe840613          	addi	a2,s0,-24
    800056ce:	4581                	li	a1,0
    800056d0:	4501                	li	a0,0
    800056d2:	00000097          	auipc	ra,0x0
    800056d6:	d02080e7          	jalr	-766(ra) # 800053d4 <argfd>
    800056da:	87aa                	mv	a5,a0
    return -1;
    800056dc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056de:	0007cc63          	bltz	a5,800056f6 <sys_write+0x50>
  return filewrite(f, p, n);
    800056e2:	fe442603          	lw	a2,-28(s0)
    800056e6:	fd843583          	ld	a1,-40(s0)
    800056ea:	fe843503          	ld	a0,-24(s0)
    800056ee:	fffff097          	auipc	ra,0xfffff
    800056f2:	4a8080e7          	jalr	1192(ra) # 80004b96 <filewrite>
}
    800056f6:	70a2                	ld	ra,40(sp)
    800056f8:	7402                	ld	s0,32(sp)
    800056fa:	6145                	addi	sp,sp,48
    800056fc:	8082                	ret

00000000800056fe <sys_close>:
{
    800056fe:	1101                	addi	sp,sp,-32
    80005700:	ec06                	sd	ra,24(sp)
    80005702:	e822                	sd	s0,16(sp)
    80005704:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005706:	fe040613          	addi	a2,s0,-32
    8000570a:	fec40593          	addi	a1,s0,-20
    8000570e:	4501                	li	a0,0
    80005710:	00000097          	auipc	ra,0x0
    80005714:	cc4080e7          	jalr	-828(ra) # 800053d4 <argfd>
    return -1;
    80005718:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000571a:	02054463          	bltz	a0,80005742 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000571e:	ffffc097          	auipc	ra,0xffffc
    80005722:	28e080e7          	jalr	654(ra) # 800019ac <myproc>
    80005726:	fec42783          	lw	a5,-20(s0)
    8000572a:	07f9                	addi	a5,a5,30
    8000572c:	078e                	slli	a5,a5,0x3
    8000572e:	97aa                	add	a5,a5,a0
    80005730:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005734:	fe043503          	ld	a0,-32(s0)
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	262080e7          	jalr	610(ra) # 8000499a <fileclose>
  return 0;
    80005740:	4781                	li	a5,0
}
    80005742:	853e                	mv	a0,a5
    80005744:	60e2                	ld	ra,24(sp)
    80005746:	6442                	ld	s0,16(sp)
    80005748:	6105                	addi	sp,sp,32
    8000574a:	8082                	ret

000000008000574c <sys_fstat>:
{
    8000574c:	1101                	addi	sp,sp,-32
    8000574e:	ec06                	sd	ra,24(sp)
    80005750:	e822                	sd	s0,16(sp)
    80005752:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005754:	fe040593          	addi	a1,s0,-32
    80005758:	4505                	li	a0,1
    8000575a:	ffffd097          	auipc	ra,0xffffd
    8000575e:	7a6080e7          	jalr	1958(ra) # 80002f00 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005762:	fe840613          	addi	a2,s0,-24
    80005766:	4581                	li	a1,0
    80005768:	4501                	li	a0,0
    8000576a:	00000097          	auipc	ra,0x0
    8000576e:	c6a080e7          	jalr	-918(ra) # 800053d4 <argfd>
    80005772:	87aa                	mv	a5,a0
    return -1;
    80005774:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005776:	0007ca63          	bltz	a5,8000578a <sys_fstat+0x3e>
  return filestat(f, st);
    8000577a:	fe043583          	ld	a1,-32(s0)
    8000577e:	fe843503          	ld	a0,-24(s0)
    80005782:	fffff097          	auipc	ra,0xfffff
    80005786:	2e0080e7          	jalr	736(ra) # 80004a62 <filestat>
}
    8000578a:	60e2                	ld	ra,24(sp)
    8000578c:	6442                	ld	s0,16(sp)
    8000578e:	6105                	addi	sp,sp,32
    80005790:	8082                	ret

0000000080005792 <sys_link>:
{
    80005792:	7169                	addi	sp,sp,-304
    80005794:	f606                	sd	ra,296(sp)
    80005796:	f222                	sd	s0,288(sp)
    80005798:	ee26                	sd	s1,280(sp)
    8000579a:	ea4a                	sd	s2,272(sp)
    8000579c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000579e:	08000613          	li	a2,128
    800057a2:	ed040593          	addi	a1,s0,-304
    800057a6:	4501                	li	a0,0
    800057a8:	ffffd097          	auipc	ra,0xffffd
    800057ac:	778080e7          	jalr	1912(ra) # 80002f20 <argstr>
    return -1;
    800057b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057b2:	10054e63          	bltz	a0,800058ce <sys_link+0x13c>
    800057b6:	08000613          	li	a2,128
    800057ba:	f5040593          	addi	a1,s0,-176
    800057be:	4505                	li	a0,1
    800057c0:	ffffd097          	auipc	ra,0xffffd
    800057c4:	760080e7          	jalr	1888(ra) # 80002f20 <argstr>
    return -1;
    800057c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057ca:	10054263          	bltz	a0,800058ce <sys_link+0x13c>
  begin_op();
    800057ce:	fffff097          	auipc	ra,0xfffff
    800057d2:	d00080e7          	jalr	-768(ra) # 800044ce <begin_op>
  if((ip = namei(old)) == 0){
    800057d6:	ed040513          	addi	a0,s0,-304
    800057da:	fffff097          	auipc	ra,0xfffff
    800057de:	ad8080e7          	jalr	-1320(ra) # 800042b2 <namei>
    800057e2:	84aa                	mv	s1,a0
    800057e4:	c551                	beqz	a0,80005870 <sys_link+0xde>
  ilock(ip);
    800057e6:	ffffe097          	auipc	ra,0xffffe
    800057ea:	326080e7          	jalr	806(ra) # 80003b0c <ilock>
  if(ip->type == T_DIR){
    800057ee:	04449703          	lh	a4,68(s1)
    800057f2:	4785                	li	a5,1
    800057f4:	08f70463          	beq	a4,a5,8000587c <sys_link+0xea>
  ip->nlink++;
    800057f8:	04a4d783          	lhu	a5,74(s1)
    800057fc:	2785                	addiw	a5,a5,1
    800057fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005802:	8526                	mv	a0,s1
    80005804:	ffffe097          	auipc	ra,0xffffe
    80005808:	23e080e7          	jalr	574(ra) # 80003a42 <iupdate>
  iunlock(ip);
    8000580c:	8526                	mv	a0,s1
    8000580e:	ffffe097          	auipc	ra,0xffffe
    80005812:	3c0080e7          	jalr	960(ra) # 80003bce <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005816:	fd040593          	addi	a1,s0,-48
    8000581a:	f5040513          	addi	a0,s0,-176
    8000581e:	fffff097          	auipc	ra,0xfffff
    80005822:	ab2080e7          	jalr	-1358(ra) # 800042d0 <nameiparent>
    80005826:	892a                	mv	s2,a0
    80005828:	c935                	beqz	a0,8000589c <sys_link+0x10a>
  ilock(dp);
    8000582a:	ffffe097          	auipc	ra,0xffffe
    8000582e:	2e2080e7          	jalr	738(ra) # 80003b0c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005832:	00092703          	lw	a4,0(s2)
    80005836:	409c                	lw	a5,0(s1)
    80005838:	04f71d63          	bne	a4,a5,80005892 <sys_link+0x100>
    8000583c:	40d0                	lw	a2,4(s1)
    8000583e:	fd040593          	addi	a1,s0,-48
    80005842:	854a                	mv	a0,s2
    80005844:	fffff097          	auipc	ra,0xfffff
    80005848:	9bc080e7          	jalr	-1604(ra) # 80004200 <dirlink>
    8000584c:	04054363          	bltz	a0,80005892 <sys_link+0x100>
  iunlockput(dp);
    80005850:	854a                	mv	a0,s2
    80005852:	ffffe097          	auipc	ra,0xffffe
    80005856:	51c080e7          	jalr	1308(ra) # 80003d6e <iunlockput>
  iput(ip);
    8000585a:	8526                	mv	a0,s1
    8000585c:	ffffe097          	auipc	ra,0xffffe
    80005860:	46a080e7          	jalr	1130(ra) # 80003cc6 <iput>
  end_op();
    80005864:	fffff097          	auipc	ra,0xfffff
    80005868:	cea080e7          	jalr	-790(ra) # 8000454e <end_op>
  return 0;
    8000586c:	4781                	li	a5,0
    8000586e:	a085                	j	800058ce <sys_link+0x13c>
    end_op();
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	cde080e7          	jalr	-802(ra) # 8000454e <end_op>
    return -1;
    80005878:	57fd                	li	a5,-1
    8000587a:	a891                	j	800058ce <sys_link+0x13c>
    iunlockput(ip);
    8000587c:	8526                	mv	a0,s1
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	4f0080e7          	jalr	1264(ra) # 80003d6e <iunlockput>
    end_op();
    80005886:	fffff097          	auipc	ra,0xfffff
    8000588a:	cc8080e7          	jalr	-824(ra) # 8000454e <end_op>
    return -1;
    8000588e:	57fd                	li	a5,-1
    80005890:	a83d                	j	800058ce <sys_link+0x13c>
    iunlockput(dp);
    80005892:	854a                	mv	a0,s2
    80005894:	ffffe097          	auipc	ra,0xffffe
    80005898:	4da080e7          	jalr	1242(ra) # 80003d6e <iunlockput>
  ilock(ip);
    8000589c:	8526                	mv	a0,s1
    8000589e:	ffffe097          	auipc	ra,0xffffe
    800058a2:	26e080e7          	jalr	622(ra) # 80003b0c <ilock>
  ip->nlink--;
    800058a6:	04a4d783          	lhu	a5,74(s1)
    800058aa:	37fd                	addiw	a5,a5,-1
    800058ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058b0:	8526                	mv	a0,s1
    800058b2:	ffffe097          	auipc	ra,0xffffe
    800058b6:	190080e7          	jalr	400(ra) # 80003a42 <iupdate>
  iunlockput(ip);
    800058ba:	8526                	mv	a0,s1
    800058bc:	ffffe097          	auipc	ra,0xffffe
    800058c0:	4b2080e7          	jalr	1202(ra) # 80003d6e <iunlockput>
  end_op();
    800058c4:	fffff097          	auipc	ra,0xfffff
    800058c8:	c8a080e7          	jalr	-886(ra) # 8000454e <end_op>
  return -1;
    800058cc:	57fd                	li	a5,-1
}
    800058ce:	853e                	mv	a0,a5
    800058d0:	70b2                	ld	ra,296(sp)
    800058d2:	7412                	ld	s0,288(sp)
    800058d4:	64f2                	ld	s1,280(sp)
    800058d6:	6952                	ld	s2,272(sp)
    800058d8:	6155                	addi	sp,sp,304
    800058da:	8082                	ret

00000000800058dc <sys_unlink>:
{
    800058dc:	7151                	addi	sp,sp,-240
    800058de:	f586                	sd	ra,232(sp)
    800058e0:	f1a2                	sd	s0,224(sp)
    800058e2:	eda6                	sd	s1,216(sp)
    800058e4:	e9ca                	sd	s2,208(sp)
    800058e6:	e5ce                	sd	s3,200(sp)
    800058e8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800058ea:	08000613          	li	a2,128
    800058ee:	f3040593          	addi	a1,s0,-208
    800058f2:	4501                	li	a0,0
    800058f4:	ffffd097          	auipc	ra,0xffffd
    800058f8:	62c080e7          	jalr	1580(ra) # 80002f20 <argstr>
    800058fc:	18054163          	bltz	a0,80005a7e <sys_unlink+0x1a2>
  begin_op();
    80005900:	fffff097          	auipc	ra,0xfffff
    80005904:	bce080e7          	jalr	-1074(ra) # 800044ce <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005908:	fb040593          	addi	a1,s0,-80
    8000590c:	f3040513          	addi	a0,s0,-208
    80005910:	fffff097          	auipc	ra,0xfffff
    80005914:	9c0080e7          	jalr	-1600(ra) # 800042d0 <nameiparent>
    80005918:	84aa                	mv	s1,a0
    8000591a:	c979                	beqz	a0,800059f0 <sys_unlink+0x114>
  ilock(dp);
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	1f0080e7          	jalr	496(ra) # 80003b0c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005924:	00003597          	auipc	a1,0x3
    80005928:	e2c58593          	addi	a1,a1,-468 # 80008750 <syscalls+0x2c0>
    8000592c:	fb040513          	addi	a0,s0,-80
    80005930:	ffffe097          	auipc	ra,0xffffe
    80005934:	6a6080e7          	jalr	1702(ra) # 80003fd6 <namecmp>
    80005938:	14050a63          	beqz	a0,80005a8c <sys_unlink+0x1b0>
    8000593c:	00003597          	auipc	a1,0x3
    80005940:	e1c58593          	addi	a1,a1,-484 # 80008758 <syscalls+0x2c8>
    80005944:	fb040513          	addi	a0,s0,-80
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	68e080e7          	jalr	1678(ra) # 80003fd6 <namecmp>
    80005950:	12050e63          	beqz	a0,80005a8c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005954:	f2c40613          	addi	a2,s0,-212
    80005958:	fb040593          	addi	a1,s0,-80
    8000595c:	8526                	mv	a0,s1
    8000595e:	ffffe097          	auipc	ra,0xffffe
    80005962:	692080e7          	jalr	1682(ra) # 80003ff0 <dirlookup>
    80005966:	892a                	mv	s2,a0
    80005968:	12050263          	beqz	a0,80005a8c <sys_unlink+0x1b0>
  ilock(ip);
    8000596c:	ffffe097          	auipc	ra,0xffffe
    80005970:	1a0080e7          	jalr	416(ra) # 80003b0c <ilock>
  if(ip->nlink < 1)
    80005974:	04a91783          	lh	a5,74(s2)
    80005978:	08f05263          	blez	a5,800059fc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000597c:	04491703          	lh	a4,68(s2)
    80005980:	4785                	li	a5,1
    80005982:	08f70563          	beq	a4,a5,80005a0c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005986:	4641                	li	a2,16
    80005988:	4581                	li	a1,0
    8000598a:	fc040513          	addi	a0,s0,-64
    8000598e:	ffffb097          	auipc	ra,0xffffb
    80005992:	344080e7          	jalr	836(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005996:	4741                	li	a4,16
    80005998:	f2c42683          	lw	a3,-212(s0)
    8000599c:	fc040613          	addi	a2,s0,-64
    800059a0:	4581                	li	a1,0
    800059a2:	8526                	mv	a0,s1
    800059a4:	ffffe097          	auipc	ra,0xffffe
    800059a8:	514080e7          	jalr	1300(ra) # 80003eb8 <writei>
    800059ac:	47c1                	li	a5,16
    800059ae:	0af51563          	bne	a0,a5,80005a58 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800059b2:	04491703          	lh	a4,68(s2)
    800059b6:	4785                	li	a5,1
    800059b8:	0af70863          	beq	a4,a5,80005a68 <sys_unlink+0x18c>
  iunlockput(dp);
    800059bc:	8526                	mv	a0,s1
    800059be:	ffffe097          	auipc	ra,0xffffe
    800059c2:	3b0080e7          	jalr	944(ra) # 80003d6e <iunlockput>
  ip->nlink--;
    800059c6:	04a95783          	lhu	a5,74(s2)
    800059ca:	37fd                	addiw	a5,a5,-1
    800059cc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059d0:	854a                	mv	a0,s2
    800059d2:	ffffe097          	auipc	ra,0xffffe
    800059d6:	070080e7          	jalr	112(ra) # 80003a42 <iupdate>
  iunlockput(ip);
    800059da:	854a                	mv	a0,s2
    800059dc:	ffffe097          	auipc	ra,0xffffe
    800059e0:	392080e7          	jalr	914(ra) # 80003d6e <iunlockput>
  end_op();
    800059e4:	fffff097          	auipc	ra,0xfffff
    800059e8:	b6a080e7          	jalr	-1174(ra) # 8000454e <end_op>
  return 0;
    800059ec:	4501                	li	a0,0
    800059ee:	a84d                	j	80005aa0 <sys_unlink+0x1c4>
    end_op();
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	b5e080e7          	jalr	-1186(ra) # 8000454e <end_op>
    return -1;
    800059f8:	557d                	li	a0,-1
    800059fa:	a05d                	j	80005aa0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800059fc:	00003517          	auipc	a0,0x3
    80005a00:	d6450513          	addi	a0,a0,-668 # 80008760 <syscalls+0x2d0>
    80005a04:	ffffb097          	auipc	ra,0xffffb
    80005a08:	b3a080e7          	jalr	-1222(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a0c:	04c92703          	lw	a4,76(s2)
    80005a10:	02000793          	li	a5,32
    80005a14:	f6e7f9e3          	bgeu	a5,a4,80005986 <sys_unlink+0xaa>
    80005a18:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a1c:	4741                	li	a4,16
    80005a1e:	86ce                	mv	a3,s3
    80005a20:	f1840613          	addi	a2,s0,-232
    80005a24:	4581                	li	a1,0
    80005a26:	854a                	mv	a0,s2
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	398080e7          	jalr	920(ra) # 80003dc0 <readi>
    80005a30:	47c1                	li	a5,16
    80005a32:	00f51b63          	bne	a0,a5,80005a48 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005a36:	f1845783          	lhu	a5,-232(s0)
    80005a3a:	e7a1                	bnez	a5,80005a82 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005a3c:	29c1                	addiw	s3,s3,16
    80005a3e:	04c92783          	lw	a5,76(s2)
    80005a42:	fcf9ede3          	bltu	s3,a5,80005a1c <sys_unlink+0x140>
    80005a46:	b781                	j	80005986 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005a48:	00003517          	auipc	a0,0x3
    80005a4c:	d3050513          	addi	a0,a0,-720 # 80008778 <syscalls+0x2e8>
    80005a50:	ffffb097          	auipc	ra,0xffffb
    80005a54:	aee080e7          	jalr	-1298(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005a58:	00003517          	auipc	a0,0x3
    80005a5c:	d3850513          	addi	a0,a0,-712 # 80008790 <syscalls+0x300>
    80005a60:	ffffb097          	auipc	ra,0xffffb
    80005a64:	ade080e7          	jalr	-1314(ra) # 8000053e <panic>
    dp->nlink--;
    80005a68:	04a4d783          	lhu	a5,74(s1)
    80005a6c:	37fd                	addiw	a5,a5,-1
    80005a6e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a72:	8526                	mv	a0,s1
    80005a74:	ffffe097          	auipc	ra,0xffffe
    80005a78:	fce080e7          	jalr	-50(ra) # 80003a42 <iupdate>
    80005a7c:	b781                	j	800059bc <sys_unlink+0xe0>
    return -1;
    80005a7e:	557d                	li	a0,-1
    80005a80:	a005                	j	80005aa0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005a82:	854a                	mv	a0,s2
    80005a84:	ffffe097          	auipc	ra,0xffffe
    80005a88:	2ea080e7          	jalr	746(ra) # 80003d6e <iunlockput>
  iunlockput(dp);
    80005a8c:	8526                	mv	a0,s1
    80005a8e:	ffffe097          	auipc	ra,0xffffe
    80005a92:	2e0080e7          	jalr	736(ra) # 80003d6e <iunlockput>
  end_op();
    80005a96:	fffff097          	auipc	ra,0xfffff
    80005a9a:	ab8080e7          	jalr	-1352(ra) # 8000454e <end_op>
  return -1;
    80005a9e:	557d                	li	a0,-1
}
    80005aa0:	70ae                	ld	ra,232(sp)
    80005aa2:	740e                	ld	s0,224(sp)
    80005aa4:	64ee                	ld	s1,216(sp)
    80005aa6:	694e                	ld	s2,208(sp)
    80005aa8:	69ae                	ld	s3,200(sp)
    80005aaa:	616d                	addi	sp,sp,240
    80005aac:	8082                	ret

0000000080005aae <sys_open>:

uint64
sys_open(void)
{
    80005aae:	7131                	addi	sp,sp,-192
    80005ab0:	fd06                	sd	ra,184(sp)
    80005ab2:	f922                	sd	s0,176(sp)
    80005ab4:	f526                	sd	s1,168(sp)
    80005ab6:	f14a                	sd	s2,160(sp)
    80005ab8:	ed4e                	sd	s3,152(sp)
    80005aba:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005abc:	f4c40593          	addi	a1,s0,-180
    80005ac0:	4505                	li	a0,1
    80005ac2:	ffffd097          	auipc	ra,0xffffd
    80005ac6:	41e080e7          	jalr	1054(ra) # 80002ee0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005aca:	08000613          	li	a2,128
    80005ace:	f5040593          	addi	a1,s0,-176
    80005ad2:	4501                	li	a0,0
    80005ad4:	ffffd097          	auipc	ra,0xffffd
    80005ad8:	44c080e7          	jalr	1100(ra) # 80002f20 <argstr>
    80005adc:	87aa                	mv	a5,a0
    return -1;
    80005ade:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ae0:	0a07c963          	bltz	a5,80005b92 <sys_open+0xe4>

  begin_op();
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	9ea080e7          	jalr	-1558(ra) # 800044ce <begin_op>

  if(omode & O_CREATE){
    80005aec:	f4c42783          	lw	a5,-180(s0)
    80005af0:	2007f793          	andi	a5,a5,512
    80005af4:	cfc5                	beqz	a5,80005bac <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005af6:	4681                	li	a3,0
    80005af8:	4601                	li	a2,0
    80005afa:	4589                	li	a1,2
    80005afc:	f5040513          	addi	a0,s0,-176
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	976080e7          	jalr	-1674(ra) # 80005476 <create>
    80005b08:	84aa                	mv	s1,a0
    if(ip == 0){
    80005b0a:	c959                	beqz	a0,80005ba0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005b0c:	04449703          	lh	a4,68(s1)
    80005b10:	478d                	li	a5,3
    80005b12:	00f71763          	bne	a4,a5,80005b20 <sys_open+0x72>
    80005b16:	0464d703          	lhu	a4,70(s1)
    80005b1a:	47a5                	li	a5,9
    80005b1c:	0ce7ed63          	bltu	a5,a4,80005bf6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	dbe080e7          	jalr	-578(ra) # 800048de <filealloc>
    80005b28:	89aa                	mv	s3,a0
    80005b2a:	10050363          	beqz	a0,80005c30 <sys_open+0x182>
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	906080e7          	jalr	-1786(ra) # 80005434 <fdalloc>
    80005b36:	892a                	mv	s2,a0
    80005b38:	0e054763          	bltz	a0,80005c26 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b3c:	04449703          	lh	a4,68(s1)
    80005b40:	478d                	li	a5,3
    80005b42:	0cf70563          	beq	a4,a5,80005c0c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b46:	4789                	li	a5,2
    80005b48:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005b4c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005b50:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005b54:	f4c42783          	lw	a5,-180(s0)
    80005b58:	0017c713          	xori	a4,a5,1
    80005b5c:	8b05                	andi	a4,a4,1
    80005b5e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b62:	0037f713          	andi	a4,a5,3
    80005b66:	00e03733          	snez	a4,a4
    80005b6a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b6e:	4007f793          	andi	a5,a5,1024
    80005b72:	c791                	beqz	a5,80005b7e <sys_open+0xd0>
    80005b74:	04449703          	lh	a4,68(s1)
    80005b78:	4789                	li	a5,2
    80005b7a:	0af70063          	beq	a4,a5,80005c1a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005b7e:	8526                	mv	a0,s1
    80005b80:	ffffe097          	auipc	ra,0xffffe
    80005b84:	04e080e7          	jalr	78(ra) # 80003bce <iunlock>
  end_op();
    80005b88:	fffff097          	auipc	ra,0xfffff
    80005b8c:	9c6080e7          	jalr	-1594(ra) # 8000454e <end_op>

  return fd;
    80005b90:	854a                	mv	a0,s2
}
    80005b92:	70ea                	ld	ra,184(sp)
    80005b94:	744a                	ld	s0,176(sp)
    80005b96:	74aa                	ld	s1,168(sp)
    80005b98:	790a                	ld	s2,160(sp)
    80005b9a:	69ea                	ld	s3,152(sp)
    80005b9c:	6129                	addi	sp,sp,192
    80005b9e:	8082                	ret
      end_op();
    80005ba0:	fffff097          	auipc	ra,0xfffff
    80005ba4:	9ae080e7          	jalr	-1618(ra) # 8000454e <end_op>
      return -1;
    80005ba8:	557d                	li	a0,-1
    80005baa:	b7e5                	j	80005b92 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005bac:	f5040513          	addi	a0,s0,-176
    80005bb0:	ffffe097          	auipc	ra,0xffffe
    80005bb4:	702080e7          	jalr	1794(ra) # 800042b2 <namei>
    80005bb8:	84aa                	mv	s1,a0
    80005bba:	c905                	beqz	a0,80005bea <sys_open+0x13c>
    ilock(ip);
    80005bbc:	ffffe097          	auipc	ra,0xffffe
    80005bc0:	f50080e7          	jalr	-176(ra) # 80003b0c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005bc4:	04449703          	lh	a4,68(s1)
    80005bc8:	4785                	li	a5,1
    80005bca:	f4f711e3          	bne	a4,a5,80005b0c <sys_open+0x5e>
    80005bce:	f4c42783          	lw	a5,-180(s0)
    80005bd2:	d7b9                	beqz	a5,80005b20 <sys_open+0x72>
      iunlockput(ip);
    80005bd4:	8526                	mv	a0,s1
    80005bd6:	ffffe097          	auipc	ra,0xffffe
    80005bda:	198080e7          	jalr	408(ra) # 80003d6e <iunlockput>
      end_op();
    80005bde:	fffff097          	auipc	ra,0xfffff
    80005be2:	970080e7          	jalr	-1680(ra) # 8000454e <end_op>
      return -1;
    80005be6:	557d                	li	a0,-1
    80005be8:	b76d                	j	80005b92 <sys_open+0xe4>
      end_op();
    80005bea:	fffff097          	auipc	ra,0xfffff
    80005bee:	964080e7          	jalr	-1692(ra) # 8000454e <end_op>
      return -1;
    80005bf2:	557d                	li	a0,-1
    80005bf4:	bf79                	j	80005b92 <sys_open+0xe4>
    iunlockput(ip);
    80005bf6:	8526                	mv	a0,s1
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	176080e7          	jalr	374(ra) # 80003d6e <iunlockput>
    end_op();
    80005c00:	fffff097          	auipc	ra,0xfffff
    80005c04:	94e080e7          	jalr	-1714(ra) # 8000454e <end_op>
    return -1;
    80005c08:	557d                	li	a0,-1
    80005c0a:	b761                	j	80005b92 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005c0c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005c10:	04649783          	lh	a5,70(s1)
    80005c14:	02f99223          	sh	a5,36(s3)
    80005c18:	bf25                	j	80005b50 <sys_open+0xa2>
    itrunc(ip);
    80005c1a:	8526                	mv	a0,s1
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	ffe080e7          	jalr	-2(ra) # 80003c1a <itrunc>
    80005c24:	bfa9                	j	80005b7e <sys_open+0xd0>
      fileclose(f);
    80005c26:	854e                	mv	a0,s3
    80005c28:	fffff097          	auipc	ra,0xfffff
    80005c2c:	d72080e7          	jalr	-654(ra) # 8000499a <fileclose>
    iunlockput(ip);
    80005c30:	8526                	mv	a0,s1
    80005c32:	ffffe097          	auipc	ra,0xffffe
    80005c36:	13c080e7          	jalr	316(ra) # 80003d6e <iunlockput>
    end_op();
    80005c3a:	fffff097          	auipc	ra,0xfffff
    80005c3e:	914080e7          	jalr	-1772(ra) # 8000454e <end_op>
    return -1;
    80005c42:	557d                	li	a0,-1
    80005c44:	b7b9                	j	80005b92 <sys_open+0xe4>

0000000080005c46 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005c46:	7175                	addi	sp,sp,-144
    80005c48:	e506                	sd	ra,136(sp)
    80005c4a:	e122                	sd	s0,128(sp)
    80005c4c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005c4e:	fffff097          	auipc	ra,0xfffff
    80005c52:	880080e7          	jalr	-1920(ra) # 800044ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005c56:	08000613          	li	a2,128
    80005c5a:	f7040593          	addi	a1,s0,-144
    80005c5e:	4501                	li	a0,0
    80005c60:	ffffd097          	auipc	ra,0xffffd
    80005c64:	2c0080e7          	jalr	704(ra) # 80002f20 <argstr>
    80005c68:	02054963          	bltz	a0,80005c9a <sys_mkdir+0x54>
    80005c6c:	4681                	li	a3,0
    80005c6e:	4601                	li	a2,0
    80005c70:	4585                	li	a1,1
    80005c72:	f7040513          	addi	a0,s0,-144
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	800080e7          	jalr	-2048(ra) # 80005476 <create>
    80005c7e:	cd11                	beqz	a0,80005c9a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c80:	ffffe097          	auipc	ra,0xffffe
    80005c84:	0ee080e7          	jalr	238(ra) # 80003d6e <iunlockput>
  end_op();
    80005c88:	fffff097          	auipc	ra,0xfffff
    80005c8c:	8c6080e7          	jalr	-1850(ra) # 8000454e <end_op>
  return 0;
    80005c90:	4501                	li	a0,0
}
    80005c92:	60aa                	ld	ra,136(sp)
    80005c94:	640a                	ld	s0,128(sp)
    80005c96:	6149                	addi	sp,sp,144
    80005c98:	8082                	ret
    end_op();
    80005c9a:	fffff097          	auipc	ra,0xfffff
    80005c9e:	8b4080e7          	jalr	-1868(ra) # 8000454e <end_op>
    return -1;
    80005ca2:	557d                	li	a0,-1
    80005ca4:	b7fd                	j	80005c92 <sys_mkdir+0x4c>

0000000080005ca6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ca6:	7135                	addi	sp,sp,-160
    80005ca8:	ed06                	sd	ra,152(sp)
    80005caa:	e922                	sd	s0,144(sp)
    80005cac:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005cae:	fffff097          	auipc	ra,0xfffff
    80005cb2:	820080e7          	jalr	-2016(ra) # 800044ce <begin_op>
  argint(1, &major);
    80005cb6:	f6c40593          	addi	a1,s0,-148
    80005cba:	4505                	li	a0,1
    80005cbc:	ffffd097          	auipc	ra,0xffffd
    80005cc0:	224080e7          	jalr	548(ra) # 80002ee0 <argint>
  argint(2, &minor);
    80005cc4:	f6840593          	addi	a1,s0,-152
    80005cc8:	4509                	li	a0,2
    80005cca:	ffffd097          	auipc	ra,0xffffd
    80005cce:	216080e7          	jalr	534(ra) # 80002ee0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005cd2:	08000613          	li	a2,128
    80005cd6:	f7040593          	addi	a1,s0,-144
    80005cda:	4501                	li	a0,0
    80005cdc:	ffffd097          	auipc	ra,0xffffd
    80005ce0:	244080e7          	jalr	580(ra) # 80002f20 <argstr>
    80005ce4:	02054b63          	bltz	a0,80005d1a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005ce8:	f6841683          	lh	a3,-152(s0)
    80005cec:	f6c41603          	lh	a2,-148(s0)
    80005cf0:	458d                	li	a1,3
    80005cf2:	f7040513          	addi	a0,s0,-144
    80005cf6:	fffff097          	auipc	ra,0xfffff
    80005cfa:	780080e7          	jalr	1920(ra) # 80005476 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005cfe:	cd11                	beqz	a0,80005d1a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d00:	ffffe097          	auipc	ra,0xffffe
    80005d04:	06e080e7          	jalr	110(ra) # 80003d6e <iunlockput>
  end_op();
    80005d08:	fffff097          	auipc	ra,0xfffff
    80005d0c:	846080e7          	jalr	-1978(ra) # 8000454e <end_op>
  return 0;
    80005d10:	4501                	li	a0,0
}
    80005d12:	60ea                	ld	ra,152(sp)
    80005d14:	644a                	ld	s0,144(sp)
    80005d16:	610d                	addi	sp,sp,160
    80005d18:	8082                	ret
    end_op();
    80005d1a:	fffff097          	auipc	ra,0xfffff
    80005d1e:	834080e7          	jalr	-1996(ra) # 8000454e <end_op>
    return -1;
    80005d22:	557d                	li	a0,-1
    80005d24:	b7fd                	j	80005d12 <sys_mknod+0x6c>

0000000080005d26 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d26:	7135                	addi	sp,sp,-160
    80005d28:	ed06                	sd	ra,152(sp)
    80005d2a:	e922                	sd	s0,144(sp)
    80005d2c:	e526                	sd	s1,136(sp)
    80005d2e:	e14a                	sd	s2,128(sp)
    80005d30:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005d32:	ffffc097          	auipc	ra,0xffffc
    80005d36:	c7a080e7          	jalr	-902(ra) # 800019ac <myproc>
    80005d3a:	892a                	mv	s2,a0
  
  begin_op();
    80005d3c:	ffffe097          	auipc	ra,0xffffe
    80005d40:	792080e7          	jalr	1938(ra) # 800044ce <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005d44:	08000613          	li	a2,128
    80005d48:	f6040593          	addi	a1,s0,-160
    80005d4c:	4501                	li	a0,0
    80005d4e:	ffffd097          	auipc	ra,0xffffd
    80005d52:	1d2080e7          	jalr	466(ra) # 80002f20 <argstr>
    80005d56:	04054b63          	bltz	a0,80005dac <sys_chdir+0x86>
    80005d5a:	f6040513          	addi	a0,s0,-160
    80005d5e:	ffffe097          	auipc	ra,0xffffe
    80005d62:	554080e7          	jalr	1364(ra) # 800042b2 <namei>
    80005d66:	84aa                	mv	s1,a0
    80005d68:	c131                	beqz	a0,80005dac <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d6a:	ffffe097          	auipc	ra,0xffffe
    80005d6e:	da2080e7          	jalr	-606(ra) # 80003b0c <ilock>
  if(ip->type != T_DIR){
    80005d72:	04449703          	lh	a4,68(s1)
    80005d76:	4785                	li	a5,1
    80005d78:	04f71063          	bne	a4,a5,80005db8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	ffffe097          	auipc	ra,0xffffe
    80005d82:	e50080e7          	jalr	-432(ra) # 80003bce <iunlock>
  iput(p->cwd);
    80005d86:	17893503          	ld	a0,376(s2)
    80005d8a:	ffffe097          	auipc	ra,0xffffe
    80005d8e:	f3c080e7          	jalr	-196(ra) # 80003cc6 <iput>
  end_op();
    80005d92:	ffffe097          	auipc	ra,0xffffe
    80005d96:	7bc080e7          	jalr	1980(ra) # 8000454e <end_op>
  p->cwd = ip;
    80005d9a:	16993c23          	sd	s1,376(s2)
  return 0;
    80005d9e:	4501                	li	a0,0
}
    80005da0:	60ea                	ld	ra,152(sp)
    80005da2:	644a                	ld	s0,144(sp)
    80005da4:	64aa                	ld	s1,136(sp)
    80005da6:	690a                	ld	s2,128(sp)
    80005da8:	610d                	addi	sp,sp,160
    80005daa:	8082                	ret
    end_op();
    80005dac:	ffffe097          	auipc	ra,0xffffe
    80005db0:	7a2080e7          	jalr	1954(ra) # 8000454e <end_op>
    return -1;
    80005db4:	557d                	li	a0,-1
    80005db6:	b7ed                	j	80005da0 <sys_chdir+0x7a>
    iunlockput(ip);
    80005db8:	8526                	mv	a0,s1
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	fb4080e7          	jalr	-76(ra) # 80003d6e <iunlockput>
    end_op();
    80005dc2:	ffffe097          	auipc	ra,0xffffe
    80005dc6:	78c080e7          	jalr	1932(ra) # 8000454e <end_op>
    return -1;
    80005dca:	557d                	li	a0,-1
    80005dcc:	bfd1                	j	80005da0 <sys_chdir+0x7a>

0000000080005dce <sys_exec>:

uint64
sys_exec(void)
{
    80005dce:	7145                	addi	sp,sp,-464
    80005dd0:	e786                	sd	ra,456(sp)
    80005dd2:	e3a2                	sd	s0,448(sp)
    80005dd4:	ff26                	sd	s1,440(sp)
    80005dd6:	fb4a                	sd	s2,432(sp)
    80005dd8:	f74e                	sd	s3,424(sp)
    80005dda:	f352                	sd	s4,416(sp)
    80005ddc:	ef56                	sd	s5,408(sp)
    80005dde:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005de0:	e3840593          	addi	a1,s0,-456
    80005de4:	4505                	li	a0,1
    80005de6:	ffffd097          	auipc	ra,0xffffd
    80005dea:	11a080e7          	jalr	282(ra) # 80002f00 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005dee:	08000613          	li	a2,128
    80005df2:	f4040593          	addi	a1,s0,-192
    80005df6:	4501                	li	a0,0
    80005df8:	ffffd097          	auipc	ra,0xffffd
    80005dfc:	128080e7          	jalr	296(ra) # 80002f20 <argstr>
    80005e00:	87aa                	mv	a5,a0
    return -1;
    80005e02:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005e04:	0c07c263          	bltz	a5,80005ec8 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005e08:	10000613          	li	a2,256
    80005e0c:	4581                	li	a1,0
    80005e0e:	e4040513          	addi	a0,s0,-448
    80005e12:	ffffb097          	auipc	ra,0xffffb
    80005e16:	ec0080e7          	jalr	-320(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e1a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005e1e:	89a6                	mv	s3,s1
    80005e20:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e22:	02000a13          	li	s4,32
    80005e26:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e2a:	00391793          	slli	a5,s2,0x3
    80005e2e:	e3040593          	addi	a1,s0,-464
    80005e32:	e3843503          	ld	a0,-456(s0)
    80005e36:	953e                	add	a0,a0,a5
    80005e38:	ffffd097          	auipc	ra,0xffffd
    80005e3c:	00a080e7          	jalr	10(ra) # 80002e42 <fetchaddr>
    80005e40:	02054a63          	bltz	a0,80005e74 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005e44:	e3043783          	ld	a5,-464(s0)
    80005e48:	c3b9                	beqz	a5,80005e8e <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e4a:	ffffb097          	auipc	ra,0xffffb
    80005e4e:	c9c080e7          	jalr	-868(ra) # 80000ae6 <kalloc>
    80005e52:	85aa                	mv	a1,a0
    80005e54:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e58:	cd11                	beqz	a0,80005e74 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e5a:	6605                	lui	a2,0x1
    80005e5c:	e3043503          	ld	a0,-464(s0)
    80005e60:	ffffd097          	auipc	ra,0xffffd
    80005e64:	034080e7          	jalr	52(ra) # 80002e94 <fetchstr>
    80005e68:	00054663          	bltz	a0,80005e74 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005e6c:	0905                	addi	s2,s2,1
    80005e6e:	09a1                	addi	s3,s3,8
    80005e70:	fb491be3          	bne	s2,s4,80005e26 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e74:	10048913          	addi	s2,s1,256
    80005e78:	6088                	ld	a0,0(s1)
    80005e7a:	c531                	beqz	a0,80005ec6 <sys_exec+0xf8>
    kfree(argv[i]);
    80005e7c:	ffffb097          	auipc	ra,0xffffb
    80005e80:	b6e080e7          	jalr	-1170(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e84:	04a1                	addi	s1,s1,8
    80005e86:	ff2499e3          	bne	s1,s2,80005e78 <sys_exec+0xaa>
  return -1;
    80005e8a:	557d                	li	a0,-1
    80005e8c:	a835                	j	80005ec8 <sys_exec+0xfa>
      argv[i] = 0;
    80005e8e:	0a8e                	slli	s5,s5,0x3
    80005e90:	fc040793          	addi	a5,s0,-64
    80005e94:	9abe                	add	s5,s5,a5
    80005e96:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005e9a:	e4040593          	addi	a1,s0,-448
    80005e9e:	f4040513          	addi	a0,s0,-192
    80005ea2:	fffff097          	auipc	ra,0xfffff
    80005ea6:	172080e7          	jalr	370(ra) # 80005014 <exec>
    80005eaa:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eac:	10048993          	addi	s3,s1,256
    80005eb0:	6088                	ld	a0,0(s1)
    80005eb2:	c901                	beqz	a0,80005ec2 <sys_exec+0xf4>
    kfree(argv[i]);
    80005eb4:	ffffb097          	auipc	ra,0xffffb
    80005eb8:	b36080e7          	jalr	-1226(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ebc:	04a1                	addi	s1,s1,8
    80005ebe:	ff3499e3          	bne	s1,s3,80005eb0 <sys_exec+0xe2>
  return ret;
    80005ec2:	854a                	mv	a0,s2
    80005ec4:	a011                	j	80005ec8 <sys_exec+0xfa>
  return -1;
    80005ec6:	557d                	li	a0,-1
}
    80005ec8:	60be                	ld	ra,456(sp)
    80005eca:	641e                	ld	s0,448(sp)
    80005ecc:	74fa                	ld	s1,440(sp)
    80005ece:	795a                	ld	s2,432(sp)
    80005ed0:	79ba                	ld	s3,424(sp)
    80005ed2:	7a1a                	ld	s4,416(sp)
    80005ed4:	6afa                	ld	s5,408(sp)
    80005ed6:	6179                	addi	sp,sp,464
    80005ed8:	8082                	ret

0000000080005eda <sys_pipe>:

uint64
sys_pipe(void)
{
    80005eda:	7139                	addi	sp,sp,-64
    80005edc:	fc06                	sd	ra,56(sp)
    80005ede:	f822                	sd	s0,48(sp)
    80005ee0:	f426                	sd	s1,40(sp)
    80005ee2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ee4:	ffffc097          	auipc	ra,0xffffc
    80005ee8:	ac8080e7          	jalr	-1336(ra) # 800019ac <myproc>
    80005eec:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005eee:	fd840593          	addi	a1,s0,-40
    80005ef2:	4501                	li	a0,0
    80005ef4:	ffffd097          	auipc	ra,0xffffd
    80005ef8:	00c080e7          	jalr	12(ra) # 80002f00 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005efc:	fc840593          	addi	a1,s0,-56
    80005f00:	fd040513          	addi	a0,s0,-48
    80005f04:	fffff097          	auipc	ra,0xfffff
    80005f08:	dc6080e7          	jalr	-570(ra) # 80004cca <pipealloc>
    return -1;
    80005f0c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005f0e:	0c054463          	bltz	a0,80005fd6 <sys_pipe+0xfc>
  fd0 = -1;
    80005f12:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f16:	fd043503          	ld	a0,-48(s0)
    80005f1a:	fffff097          	auipc	ra,0xfffff
    80005f1e:	51a080e7          	jalr	1306(ra) # 80005434 <fdalloc>
    80005f22:	fca42223          	sw	a0,-60(s0)
    80005f26:	08054b63          	bltz	a0,80005fbc <sys_pipe+0xe2>
    80005f2a:	fc843503          	ld	a0,-56(s0)
    80005f2e:	fffff097          	auipc	ra,0xfffff
    80005f32:	506080e7          	jalr	1286(ra) # 80005434 <fdalloc>
    80005f36:	fca42023          	sw	a0,-64(s0)
    80005f3a:	06054863          	bltz	a0,80005faa <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f3e:	4691                	li	a3,4
    80005f40:	fc440613          	addi	a2,s0,-60
    80005f44:	fd843583          	ld	a1,-40(s0)
    80005f48:	7ca8                	ld	a0,120(s1)
    80005f4a:	ffffb097          	auipc	ra,0xffffb
    80005f4e:	71e080e7          	jalr	1822(ra) # 80001668 <copyout>
    80005f52:	02054063          	bltz	a0,80005f72 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f56:	4691                	li	a3,4
    80005f58:	fc040613          	addi	a2,s0,-64
    80005f5c:	fd843583          	ld	a1,-40(s0)
    80005f60:	0591                	addi	a1,a1,4
    80005f62:	7ca8                	ld	a0,120(s1)
    80005f64:	ffffb097          	auipc	ra,0xffffb
    80005f68:	704080e7          	jalr	1796(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f6c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f6e:	06055463          	bgez	a0,80005fd6 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005f72:	fc442783          	lw	a5,-60(s0)
    80005f76:	07f9                	addi	a5,a5,30
    80005f78:	078e                	slli	a5,a5,0x3
    80005f7a:	97a6                	add	a5,a5,s1
    80005f7c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005f80:	fc042503          	lw	a0,-64(s0)
    80005f84:	0579                	addi	a0,a0,30
    80005f86:	050e                	slli	a0,a0,0x3
    80005f88:	94aa                	add	s1,s1,a0
    80005f8a:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005f8e:	fd043503          	ld	a0,-48(s0)
    80005f92:	fffff097          	auipc	ra,0xfffff
    80005f96:	a08080e7          	jalr	-1528(ra) # 8000499a <fileclose>
    fileclose(wf);
    80005f9a:	fc843503          	ld	a0,-56(s0)
    80005f9e:	fffff097          	auipc	ra,0xfffff
    80005fa2:	9fc080e7          	jalr	-1540(ra) # 8000499a <fileclose>
    return -1;
    80005fa6:	57fd                	li	a5,-1
    80005fa8:	a03d                	j	80005fd6 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005faa:	fc442783          	lw	a5,-60(s0)
    80005fae:	0007c763          	bltz	a5,80005fbc <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005fb2:	07f9                	addi	a5,a5,30
    80005fb4:	078e                	slli	a5,a5,0x3
    80005fb6:	94be                	add	s1,s1,a5
    80005fb8:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005fbc:	fd043503          	ld	a0,-48(s0)
    80005fc0:	fffff097          	auipc	ra,0xfffff
    80005fc4:	9da080e7          	jalr	-1574(ra) # 8000499a <fileclose>
    fileclose(wf);
    80005fc8:	fc843503          	ld	a0,-56(s0)
    80005fcc:	fffff097          	auipc	ra,0xfffff
    80005fd0:	9ce080e7          	jalr	-1586(ra) # 8000499a <fileclose>
    return -1;
    80005fd4:	57fd                	li	a5,-1
}
    80005fd6:	853e                	mv	a0,a5
    80005fd8:	70e2                	ld	ra,56(sp)
    80005fda:	7442                	ld	s0,48(sp)
    80005fdc:	74a2                	ld	s1,40(sp)
    80005fde:	6121                	addi	sp,sp,64
    80005fe0:	8082                	ret
	...

0000000080005ff0 <kernelvec>:
    80005ff0:	7111                	addi	sp,sp,-256
    80005ff2:	e006                	sd	ra,0(sp)
    80005ff4:	e40a                	sd	sp,8(sp)
    80005ff6:	e80e                	sd	gp,16(sp)
    80005ff8:	ec12                	sd	tp,24(sp)
    80005ffa:	f016                	sd	t0,32(sp)
    80005ffc:	f41a                	sd	t1,40(sp)
    80005ffe:	f81e                	sd	t2,48(sp)
    80006000:	fc22                	sd	s0,56(sp)
    80006002:	e0a6                	sd	s1,64(sp)
    80006004:	e4aa                	sd	a0,72(sp)
    80006006:	e8ae                	sd	a1,80(sp)
    80006008:	ecb2                	sd	a2,88(sp)
    8000600a:	f0b6                	sd	a3,96(sp)
    8000600c:	f4ba                	sd	a4,104(sp)
    8000600e:	f8be                	sd	a5,112(sp)
    80006010:	fcc2                	sd	a6,120(sp)
    80006012:	e146                	sd	a7,128(sp)
    80006014:	e54a                	sd	s2,136(sp)
    80006016:	e94e                	sd	s3,144(sp)
    80006018:	ed52                	sd	s4,152(sp)
    8000601a:	f156                	sd	s5,160(sp)
    8000601c:	f55a                	sd	s6,168(sp)
    8000601e:	f95e                	sd	s7,176(sp)
    80006020:	fd62                	sd	s8,184(sp)
    80006022:	e1e6                	sd	s9,192(sp)
    80006024:	e5ea                	sd	s10,200(sp)
    80006026:	e9ee                	sd	s11,208(sp)
    80006028:	edf2                	sd	t3,216(sp)
    8000602a:	f1f6                	sd	t4,224(sp)
    8000602c:	f5fa                	sd	t5,232(sp)
    8000602e:	f9fe                	sd	t6,240(sp)
    80006030:	cdffc0ef          	jal	ra,80002d0e <kerneltrap>
    80006034:	6082                	ld	ra,0(sp)
    80006036:	6122                	ld	sp,8(sp)
    80006038:	61c2                	ld	gp,16(sp)
    8000603a:	7282                	ld	t0,32(sp)
    8000603c:	7322                	ld	t1,40(sp)
    8000603e:	73c2                	ld	t2,48(sp)
    80006040:	7462                	ld	s0,56(sp)
    80006042:	6486                	ld	s1,64(sp)
    80006044:	6526                	ld	a0,72(sp)
    80006046:	65c6                	ld	a1,80(sp)
    80006048:	6666                	ld	a2,88(sp)
    8000604a:	7686                	ld	a3,96(sp)
    8000604c:	7726                	ld	a4,104(sp)
    8000604e:	77c6                	ld	a5,112(sp)
    80006050:	7866                	ld	a6,120(sp)
    80006052:	688a                	ld	a7,128(sp)
    80006054:	692a                	ld	s2,136(sp)
    80006056:	69ca                	ld	s3,144(sp)
    80006058:	6a6a                	ld	s4,152(sp)
    8000605a:	7a8a                	ld	s5,160(sp)
    8000605c:	7b2a                	ld	s6,168(sp)
    8000605e:	7bca                	ld	s7,176(sp)
    80006060:	7c6a                	ld	s8,184(sp)
    80006062:	6c8e                	ld	s9,192(sp)
    80006064:	6d2e                	ld	s10,200(sp)
    80006066:	6dce                	ld	s11,208(sp)
    80006068:	6e6e                	ld	t3,216(sp)
    8000606a:	7e8e                	ld	t4,224(sp)
    8000606c:	7f2e                	ld	t5,232(sp)
    8000606e:	7fce                	ld	t6,240(sp)
    80006070:	6111                	addi	sp,sp,256
    80006072:	10200073          	sret
    80006076:	00000013          	nop
    8000607a:	00000013          	nop
    8000607e:	0001                	nop

0000000080006080 <timervec>:
    80006080:	34051573          	csrrw	a0,mscratch,a0
    80006084:	e10c                	sd	a1,0(a0)
    80006086:	e510                	sd	a2,8(a0)
    80006088:	e914                	sd	a3,16(a0)
    8000608a:	6d0c                	ld	a1,24(a0)
    8000608c:	7110                	ld	a2,32(a0)
    8000608e:	6194                	ld	a3,0(a1)
    80006090:	96b2                	add	a3,a3,a2
    80006092:	e194                	sd	a3,0(a1)
    80006094:	4589                	li	a1,2
    80006096:	14459073          	csrw	sip,a1
    8000609a:	6914                	ld	a3,16(a0)
    8000609c:	6510                	ld	a2,8(a0)
    8000609e:	610c                	ld	a1,0(a0)
    800060a0:	34051573          	csrrw	a0,mscratch,a0
    800060a4:	30200073          	mret
	...

00000000800060aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800060aa:	1141                	addi	sp,sp,-16
    800060ac:	e422                	sd	s0,8(sp)
    800060ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800060b0:	0c0007b7          	lui	a5,0xc000
    800060b4:	4705                	li	a4,1
    800060b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800060b8:	c3d8                	sw	a4,4(a5)
}
    800060ba:	6422                	ld	s0,8(sp)
    800060bc:	0141                	addi	sp,sp,16
    800060be:	8082                	ret

00000000800060c0 <plicinithart>:

void
plicinithart(void)
{
    800060c0:	1141                	addi	sp,sp,-16
    800060c2:	e406                	sd	ra,8(sp)
    800060c4:	e022                	sd	s0,0(sp)
    800060c6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800060c8:	ffffc097          	auipc	ra,0xffffc
    800060cc:	8b8080e7          	jalr	-1864(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800060d0:	0085171b          	slliw	a4,a0,0x8
    800060d4:	0c0027b7          	lui	a5,0xc002
    800060d8:	97ba                	add	a5,a5,a4
    800060da:	40200713          	li	a4,1026
    800060de:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800060e2:	00d5151b          	slliw	a0,a0,0xd
    800060e6:	0c2017b7          	lui	a5,0xc201
    800060ea:	953e                	add	a0,a0,a5
    800060ec:	00052023          	sw	zero,0(a0)
}
    800060f0:	60a2                	ld	ra,8(sp)
    800060f2:	6402                	ld	s0,0(sp)
    800060f4:	0141                	addi	sp,sp,16
    800060f6:	8082                	ret

00000000800060f8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800060f8:	1141                	addi	sp,sp,-16
    800060fa:	e406                	sd	ra,8(sp)
    800060fc:	e022                	sd	s0,0(sp)
    800060fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006100:	ffffc097          	auipc	ra,0xffffc
    80006104:	880080e7          	jalr	-1920(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006108:	00d5179b          	slliw	a5,a0,0xd
    8000610c:	0c201537          	lui	a0,0xc201
    80006110:	953e                	add	a0,a0,a5
  return irq;
}
    80006112:	4148                	lw	a0,4(a0)
    80006114:	60a2                	ld	ra,8(sp)
    80006116:	6402                	ld	s0,0(sp)
    80006118:	0141                	addi	sp,sp,16
    8000611a:	8082                	ret

000000008000611c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000611c:	1101                	addi	sp,sp,-32
    8000611e:	ec06                	sd	ra,24(sp)
    80006120:	e822                	sd	s0,16(sp)
    80006122:	e426                	sd	s1,8(sp)
    80006124:	1000                	addi	s0,sp,32
    80006126:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006128:	ffffc097          	auipc	ra,0xffffc
    8000612c:	858080e7          	jalr	-1960(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006130:	00d5151b          	slliw	a0,a0,0xd
    80006134:	0c2017b7          	lui	a5,0xc201
    80006138:	97aa                	add	a5,a5,a0
    8000613a:	c3c4                	sw	s1,4(a5)
}
    8000613c:	60e2                	ld	ra,24(sp)
    8000613e:	6442                	ld	s0,16(sp)
    80006140:	64a2                	ld	s1,8(sp)
    80006142:	6105                	addi	sp,sp,32
    80006144:	8082                	ret

0000000080006146 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006146:	1141                	addi	sp,sp,-16
    80006148:	e406                	sd	ra,8(sp)
    8000614a:	e022                	sd	s0,0(sp)
    8000614c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000614e:	479d                	li	a5,7
    80006150:	04a7cc63          	blt	a5,a0,800061a8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006154:	0001d797          	auipc	a5,0x1d
    80006158:	12c78793          	addi	a5,a5,300 # 80023280 <disk>
    8000615c:	97aa                	add	a5,a5,a0
    8000615e:	0187c783          	lbu	a5,24(a5)
    80006162:	ebb9                	bnez	a5,800061b8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006164:	00451613          	slli	a2,a0,0x4
    80006168:	0001d797          	auipc	a5,0x1d
    8000616c:	11878793          	addi	a5,a5,280 # 80023280 <disk>
    80006170:	6394                	ld	a3,0(a5)
    80006172:	96b2                	add	a3,a3,a2
    80006174:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006178:	6398                	ld	a4,0(a5)
    8000617a:	9732                	add	a4,a4,a2
    8000617c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006180:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006184:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006188:	953e                	add	a0,a0,a5
    8000618a:	4785                	li	a5,1
    8000618c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006190:	0001d517          	auipc	a0,0x1d
    80006194:	10850513          	addi	a0,a0,264 # 80023298 <disk+0x18>
    80006198:	ffffc097          	auipc	ra,0xffffc
    8000619c:	016080e7          	jalr	22(ra) # 800021ae <wakeup>
}
    800061a0:	60a2                	ld	ra,8(sp)
    800061a2:	6402                	ld	s0,0(sp)
    800061a4:	0141                	addi	sp,sp,16
    800061a6:	8082                	ret
    panic("free_desc 1");
    800061a8:	00002517          	auipc	a0,0x2
    800061ac:	5f850513          	addi	a0,a0,1528 # 800087a0 <syscalls+0x310>
    800061b0:	ffffa097          	auipc	ra,0xffffa
    800061b4:	38e080e7          	jalr	910(ra) # 8000053e <panic>
    panic("free_desc 2");
    800061b8:	00002517          	auipc	a0,0x2
    800061bc:	5f850513          	addi	a0,a0,1528 # 800087b0 <syscalls+0x320>
    800061c0:	ffffa097          	auipc	ra,0xffffa
    800061c4:	37e080e7          	jalr	894(ra) # 8000053e <panic>

00000000800061c8 <virtio_disk_init>:
{
    800061c8:	1101                	addi	sp,sp,-32
    800061ca:	ec06                	sd	ra,24(sp)
    800061cc:	e822                	sd	s0,16(sp)
    800061ce:	e426                	sd	s1,8(sp)
    800061d0:	e04a                	sd	s2,0(sp)
    800061d2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800061d4:	00002597          	auipc	a1,0x2
    800061d8:	5ec58593          	addi	a1,a1,1516 # 800087c0 <syscalls+0x330>
    800061dc:	0001d517          	auipc	a0,0x1d
    800061e0:	1cc50513          	addi	a0,a0,460 # 800233a8 <disk+0x128>
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	962080e7          	jalr	-1694(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800061ec:	100017b7          	lui	a5,0x10001
    800061f0:	4398                	lw	a4,0(a5)
    800061f2:	2701                	sext.w	a4,a4
    800061f4:	747277b7          	lui	a5,0x74727
    800061f8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800061fc:	14f71c63          	bne	a4,a5,80006354 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006200:	100017b7          	lui	a5,0x10001
    80006204:	43dc                	lw	a5,4(a5)
    80006206:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006208:	4709                	li	a4,2
    8000620a:	14e79563          	bne	a5,a4,80006354 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000620e:	100017b7          	lui	a5,0x10001
    80006212:	479c                	lw	a5,8(a5)
    80006214:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006216:	12e79f63          	bne	a5,a4,80006354 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000621a:	100017b7          	lui	a5,0x10001
    8000621e:	47d8                	lw	a4,12(a5)
    80006220:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006222:	554d47b7          	lui	a5,0x554d4
    80006226:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000622a:	12f71563          	bne	a4,a5,80006354 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000622e:	100017b7          	lui	a5,0x10001
    80006232:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006236:	4705                	li	a4,1
    80006238:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000623a:	470d                	li	a4,3
    8000623c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000623e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006240:	c7ffe737          	lui	a4,0xc7ffe
    80006244:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb39f>
    80006248:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000624a:	2701                	sext.w	a4,a4
    8000624c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000624e:	472d                	li	a4,11
    80006250:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80006252:	5bbc                	lw	a5,112(a5)
    80006254:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006258:	8ba1                	andi	a5,a5,8
    8000625a:	10078563          	beqz	a5,80006364 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000625e:	100017b7          	lui	a5,0x10001
    80006262:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006266:	43fc                	lw	a5,68(a5)
    80006268:	2781                	sext.w	a5,a5
    8000626a:	10079563          	bnez	a5,80006374 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000626e:	100017b7          	lui	a5,0x10001
    80006272:	5bdc                	lw	a5,52(a5)
    80006274:	2781                	sext.w	a5,a5
  if(max == 0)
    80006276:	10078763          	beqz	a5,80006384 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000627a:	471d                	li	a4,7
    8000627c:	10f77c63          	bgeu	a4,a5,80006394 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	866080e7          	jalr	-1946(ra) # 80000ae6 <kalloc>
    80006288:	0001d497          	auipc	s1,0x1d
    8000628c:	ff848493          	addi	s1,s1,-8 # 80023280 <disk>
    80006290:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006292:	ffffb097          	auipc	ra,0xffffb
    80006296:	854080e7          	jalr	-1964(ra) # 80000ae6 <kalloc>
    8000629a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	84a080e7          	jalr	-1974(ra) # 80000ae6 <kalloc>
    800062a4:	87aa                	mv	a5,a0
    800062a6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800062a8:	6088                	ld	a0,0(s1)
    800062aa:	cd6d                	beqz	a0,800063a4 <virtio_disk_init+0x1dc>
    800062ac:	0001d717          	auipc	a4,0x1d
    800062b0:	fdc73703          	ld	a4,-36(a4) # 80023288 <disk+0x8>
    800062b4:	cb65                	beqz	a4,800063a4 <virtio_disk_init+0x1dc>
    800062b6:	c7fd                	beqz	a5,800063a4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    800062b8:	6605                	lui	a2,0x1
    800062ba:	4581                	li	a1,0
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	a16080e7          	jalr	-1514(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    800062c4:	0001d497          	auipc	s1,0x1d
    800062c8:	fbc48493          	addi	s1,s1,-68 # 80023280 <disk>
    800062cc:	6605                	lui	a2,0x1
    800062ce:	4581                	li	a1,0
    800062d0:	6488                	ld	a0,8(s1)
    800062d2:	ffffb097          	auipc	ra,0xffffb
    800062d6:	a00080e7          	jalr	-1536(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    800062da:	6605                	lui	a2,0x1
    800062dc:	4581                	li	a1,0
    800062de:	6888                	ld	a0,16(s1)
    800062e0:	ffffb097          	auipc	ra,0xffffb
    800062e4:	9f2080e7          	jalr	-1550(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800062e8:	100017b7          	lui	a5,0x10001
    800062ec:	4721                	li	a4,8
    800062ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800062f0:	4098                	lw	a4,0(s1)
    800062f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800062f6:	40d8                	lw	a4,4(s1)
    800062f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800062fc:	6498                	ld	a4,8(s1)
    800062fe:	0007069b          	sext.w	a3,a4
    80006302:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006306:	9701                	srai	a4,a4,0x20
    80006308:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000630c:	6898                	ld	a4,16(s1)
    8000630e:	0007069b          	sext.w	a3,a4
    80006312:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006316:	9701                	srai	a4,a4,0x20
    80006318:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000631c:	4705                	li	a4,1
    8000631e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006320:	00e48c23          	sb	a4,24(s1)
    80006324:	00e48ca3          	sb	a4,25(s1)
    80006328:	00e48d23          	sb	a4,26(s1)
    8000632c:	00e48da3          	sb	a4,27(s1)
    80006330:	00e48e23          	sb	a4,28(s1)
    80006334:	00e48ea3          	sb	a4,29(s1)
    80006338:	00e48f23          	sb	a4,30(s1)
    8000633c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006340:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006344:	0727a823          	sw	s2,112(a5)
}
    80006348:	60e2                	ld	ra,24(sp)
    8000634a:	6442                	ld	s0,16(sp)
    8000634c:	64a2                	ld	s1,8(sp)
    8000634e:	6902                	ld	s2,0(sp)
    80006350:	6105                	addi	sp,sp,32
    80006352:	8082                	ret
    panic("could not find virtio disk");
    80006354:	00002517          	auipc	a0,0x2
    80006358:	47c50513          	addi	a0,a0,1148 # 800087d0 <syscalls+0x340>
    8000635c:	ffffa097          	auipc	ra,0xffffa
    80006360:	1e2080e7          	jalr	482(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006364:	00002517          	auipc	a0,0x2
    80006368:	48c50513          	addi	a0,a0,1164 # 800087f0 <syscalls+0x360>
    8000636c:	ffffa097          	auipc	ra,0xffffa
    80006370:	1d2080e7          	jalr	466(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006374:	00002517          	auipc	a0,0x2
    80006378:	49c50513          	addi	a0,a0,1180 # 80008810 <syscalls+0x380>
    8000637c:	ffffa097          	auipc	ra,0xffffa
    80006380:	1c2080e7          	jalr	450(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006384:	00002517          	auipc	a0,0x2
    80006388:	4ac50513          	addi	a0,a0,1196 # 80008830 <syscalls+0x3a0>
    8000638c:	ffffa097          	auipc	ra,0xffffa
    80006390:	1b2080e7          	jalr	434(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006394:	00002517          	auipc	a0,0x2
    80006398:	4bc50513          	addi	a0,a0,1212 # 80008850 <syscalls+0x3c0>
    8000639c:	ffffa097          	auipc	ra,0xffffa
    800063a0:	1a2080e7          	jalr	418(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	4cc50513          	addi	a0,a0,1228 # 80008870 <syscalls+0x3e0>
    800063ac:	ffffa097          	auipc	ra,0xffffa
    800063b0:	192080e7          	jalr	402(ra) # 8000053e <panic>

00000000800063b4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800063b4:	7119                	addi	sp,sp,-128
    800063b6:	fc86                	sd	ra,120(sp)
    800063b8:	f8a2                	sd	s0,112(sp)
    800063ba:	f4a6                	sd	s1,104(sp)
    800063bc:	f0ca                	sd	s2,96(sp)
    800063be:	ecce                	sd	s3,88(sp)
    800063c0:	e8d2                	sd	s4,80(sp)
    800063c2:	e4d6                	sd	s5,72(sp)
    800063c4:	e0da                	sd	s6,64(sp)
    800063c6:	fc5e                	sd	s7,56(sp)
    800063c8:	f862                	sd	s8,48(sp)
    800063ca:	f466                	sd	s9,40(sp)
    800063cc:	f06a                	sd	s10,32(sp)
    800063ce:	ec6e                	sd	s11,24(sp)
    800063d0:	0100                	addi	s0,sp,128
    800063d2:	8aaa                	mv	s5,a0
    800063d4:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800063d6:	00c52d03          	lw	s10,12(a0)
    800063da:	001d1d1b          	slliw	s10,s10,0x1
    800063de:	1d02                	slli	s10,s10,0x20
    800063e0:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    800063e4:	0001d517          	auipc	a0,0x1d
    800063e8:	fc450513          	addi	a0,a0,-60 # 800233a8 <disk+0x128>
    800063ec:	ffffa097          	auipc	ra,0xffffa
    800063f0:	7ea080e7          	jalr	2026(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    800063f4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800063f6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800063f8:	0001db97          	auipc	s7,0x1d
    800063fc:	e88b8b93          	addi	s7,s7,-376 # 80023280 <disk>
  for(int i = 0; i < 3; i++){
    80006400:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006402:	0001dc97          	auipc	s9,0x1d
    80006406:	fa6c8c93          	addi	s9,s9,-90 # 800233a8 <disk+0x128>
    8000640a:	a08d                	j	8000646c <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000640c:	00fb8733          	add	a4,s7,a5
    80006410:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006414:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006416:	0207c563          	bltz	a5,80006440 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000641a:	2905                	addiw	s2,s2,1
    8000641c:	0611                	addi	a2,a2,4
    8000641e:	05690c63          	beq	s2,s6,80006476 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006422:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006424:	0001d717          	auipc	a4,0x1d
    80006428:	e5c70713          	addi	a4,a4,-420 # 80023280 <disk>
    8000642c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000642e:	01874683          	lbu	a3,24(a4)
    80006432:	fee9                	bnez	a3,8000640c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006434:	2785                	addiw	a5,a5,1
    80006436:	0705                	addi	a4,a4,1
    80006438:	fe979be3          	bne	a5,s1,8000642e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000643c:	57fd                	li	a5,-1
    8000643e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006440:	01205d63          	blez	s2,8000645a <virtio_disk_rw+0xa6>
    80006444:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006446:	000a2503          	lw	a0,0(s4)
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	cfc080e7          	jalr	-772(ra) # 80006146 <free_desc>
      for(int j = 0; j < i; j++)
    80006452:	2d85                	addiw	s11,s11,1
    80006454:	0a11                	addi	s4,s4,4
    80006456:	ffb918e3          	bne	s2,s11,80006446 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000645a:	85e6                	mv	a1,s9
    8000645c:	0001d517          	auipc	a0,0x1d
    80006460:	e3c50513          	addi	a0,a0,-452 # 80023298 <disk+0x18>
    80006464:	ffffc097          	auipc	ra,0xffffc
    80006468:	ce6080e7          	jalr	-794(ra) # 8000214a <sleep>
  for(int i = 0; i < 3; i++){
    8000646c:	f8040a13          	addi	s4,s0,-128
{
    80006470:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006472:	894e                	mv	s2,s3
    80006474:	b77d                	j	80006422 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006476:	f8042583          	lw	a1,-128(s0)
    8000647a:	00a58793          	addi	a5,a1,10
    8000647e:	0792                	slli	a5,a5,0x4

  if(write)
    80006480:	0001d617          	auipc	a2,0x1d
    80006484:	e0060613          	addi	a2,a2,-512 # 80023280 <disk>
    80006488:	00f60733          	add	a4,a2,a5
    8000648c:	018036b3          	snez	a3,s8
    80006490:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006492:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006496:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000649a:	f6078693          	addi	a3,a5,-160
    8000649e:	6218                	ld	a4,0(a2)
    800064a0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800064a2:	00878513          	addi	a0,a5,8
    800064a6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800064a8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800064aa:	6208                	ld	a0,0(a2)
    800064ac:	96aa                	add	a3,a3,a0
    800064ae:	4741                	li	a4,16
    800064b0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800064b2:	4705                	li	a4,1
    800064b4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800064b8:	f8442703          	lw	a4,-124(s0)
    800064bc:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800064c0:	0712                	slli	a4,a4,0x4
    800064c2:	953a                	add	a0,a0,a4
    800064c4:	058a8693          	addi	a3,s5,88
    800064c8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800064ca:	6208                	ld	a0,0(a2)
    800064cc:	972a                	add	a4,a4,a0
    800064ce:	40000693          	li	a3,1024
    800064d2:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800064d4:	001c3c13          	seqz	s8,s8
    800064d8:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800064da:	001c6c13          	ori	s8,s8,1
    800064de:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800064e2:	f8842603          	lw	a2,-120(s0)
    800064e6:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800064ea:	0001d697          	auipc	a3,0x1d
    800064ee:	d9668693          	addi	a3,a3,-618 # 80023280 <disk>
    800064f2:	00258713          	addi	a4,a1,2
    800064f6:	0712                	slli	a4,a4,0x4
    800064f8:	9736                	add	a4,a4,a3
    800064fa:	587d                	li	a6,-1
    800064fc:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006500:	0612                	slli	a2,a2,0x4
    80006502:	9532                	add	a0,a0,a2
    80006504:	f9078793          	addi	a5,a5,-112
    80006508:	97b6                	add	a5,a5,a3
    8000650a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000650c:	629c                	ld	a5,0(a3)
    8000650e:	97b2                	add	a5,a5,a2
    80006510:	4605                	li	a2,1
    80006512:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006514:	4509                	li	a0,2
    80006516:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000651a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000651e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006522:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006526:	6698                	ld	a4,8(a3)
    80006528:	00275783          	lhu	a5,2(a4)
    8000652c:	8b9d                	andi	a5,a5,7
    8000652e:	0786                	slli	a5,a5,0x1
    80006530:	97ba                	add	a5,a5,a4
    80006532:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006536:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000653a:	6698                	ld	a4,8(a3)
    8000653c:	00275783          	lhu	a5,2(a4)
    80006540:	2785                	addiw	a5,a5,1
    80006542:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006546:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000654a:	100017b7          	lui	a5,0x10001
    8000654e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006552:	004aa783          	lw	a5,4(s5)
    80006556:	02c79163          	bne	a5,a2,80006578 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000655a:	0001d917          	auipc	s2,0x1d
    8000655e:	e4e90913          	addi	s2,s2,-434 # 800233a8 <disk+0x128>
  while(b->disk == 1) {
    80006562:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006564:	85ca                	mv	a1,s2
    80006566:	8556                	mv	a0,s5
    80006568:	ffffc097          	auipc	ra,0xffffc
    8000656c:	be2080e7          	jalr	-1054(ra) # 8000214a <sleep>
  while(b->disk == 1) {
    80006570:	004aa783          	lw	a5,4(s5)
    80006574:	fe9788e3          	beq	a5,s1,80006564 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006578:	f8042903          	lw	s2,-128(s0)
    8000657c:	00290793          	addi	a5,s2,2
    80006580:	00479713          	slli	a4,a5,0x4
    80006584:	0001d797          	auipc	a5,0x1d
    80006588:	cfc78793          	addi	a5,a5,-772 # 80023280 <disk>
    8000658c:	97ba                	add	a5,a5,a4
    8000658e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006592:	0001d997          	auipc	s3,0x1d
    80006596:	cee98993          	addi	s3,s3,-786 # 80023280 <disk>
    8000659a:	00491713          	slli	a4,s2,0x4
    8000659e:	0009b783          	ld	a5,0(s3)
    800065a2:	97ba                	add	a5,a5,a4
    800065a4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800065a8:	854a                	mv	a0,s2
    800065aa:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	b98080e7          	jalr	-1128(ra) # 80006146 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800065b6:	8885                	andi	s1,s1,1
    800065b8:	f0ed                	bnez	s1,8000659a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800065ba:	0001d517          	auipc	a0,0x1d
    800065be:	dee50513          	addi	a0,a0,-530 # 800233a8 <disk+0x128>
    800065c2:	ffffa097          	auipc	ra,0xffffa
    800065c6:	6c8080e7          	jalr	1736(ra) # 80000c8a <release>
}
    800065ca:	70e6                	ld	ra,120(sp)
    800065cc:	7446                	ld	s0,112(sp)
    800065ce:	74a6                	ld	s1,104(sp)
    800065d0:	7906                	ld	s2,96(sp)
    800065d2:	69e6                	ld	s3,88(sp)
    800065d4:	6a46                	ld	s4,80(sp)
    800065d6:	6aa6                	ld	s5,72(sp)
    800065d8:	6b06                	ld	s6,64(sp)
    800065da:	7be2                	ld	s7,56(sp)
    800065dc:	7c42                	ld	s8,48(sp)
    800065de:	7ca2                	ld	s9,40(sp)
    800065e0:	7d02                	ld	s10,32(sp)
    800065e2:	6de2                	ld	s11,24(sp)
    800065e4:	6109                	addi	sp,sp,128
    800065e6:	8082                	ret

00000000800065e8 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800065e8:	1101                	addi	sp,sp,-32
    800065ea:	ec06                	sd	ra,24(sp)
    800065ec:	e822                	sd	s0,16(sp)
    800065ee:	e426                	sd	s1,8(sp)
    800065f0:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800065f2:	0001d497          	auipc	s1,0x1d
    800065f6:	c8e48493          	addi	s1,s1,-882 # 80023280 <disk>
    800065fa:	0001d517          	auipc	a0,0x1d
    800065fe:	dae50513          	addi	a0,a0,-594 # 800233a8 <disk+0x128>
    80006602:	ffffa097          	auipc	ra,0xffffa
    80006606:	5d4080e7          	jalr	1492(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000660a:	10001737          	lui	a4,0x10001
    8000660e:	533c                	lw	a5,96(a4)
    80006610:	8b8d                	andi	a5,a5,3
    80006612:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006614:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006618:	689c                	ld	a5,16(s1)
    8000661a:	0204d703          	lhu	a4,32(s1)
    8000661e:	0027d783          	lhu	a5,2(a5)
    80006622:	04f70863          	beq	a4,a5,80006672 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006626:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000662a:	6898                	ld	a4,16(s1)
    8000662c:	0204d783          	lhu	a5,32(s1)
    80006630:	8b9d                	andi	a5,a5,7
    80006632:	078e                	slli	a5,a5,0x3
    80006634:	97ba                	add	a5,a5,a4
    80006636:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006638:	00278713          	addi	a4,a5,2
    8000663c:	0712                	slli	a4,a4,0x4
    8000663e:	9726                	add	a4,a4,s1
    80006640:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006644:	e721                	bnez	a4,8000668c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006646:	0789                	addi	a5,a5,2
    80006648:	0792                	slli	a5,a5,0x4
    8000664a:	97a6                	add	a5,a5,s1
    8000664c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000664e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006652:	ffffc097          	auipc	ra,0xffffc
    80006656:	b5c080e7          	jalr	-1188(ra) # 800021ae <wakeup>

    disk.used_idx += 1;
    8000665a:	0204d783          	lhu	a5,32(s1)
    8000665e:	2785                	addiw	a5,a5,1
    80006660:	17c2                	slli	a5,a5,0x30
    80006662:	93c1                	srli	a5,a5,0x30
    80006664:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006668:	6898                	ld	a4,16(s1)
    8000666a:	00275703          	lhu	a4,2(a4)
    8000666e:	faf71ce3          	bne	a4,a5,80006626 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006672:	0001d517          	auipc	a0,0x1d
    80006676:	d3650513          	addi	a0,a0,-714 # 800233a8 <disk+0x128>
    8000667a:	ffffa097          	auipc	ra,0xffffa
    8000667e:	610080e7          	jalr	1552(ra) # 80000c8a <release>
}
    80006682:	60e2                	ld	ra,24(sp)
    80006684:	6442                	ld	s0,16(sp)
    80006686:	64a2                	ld	s1,8(sp)
    80006688:	6105                	addi	sp,sp,32
    8000668a:	8082                	ret
      panic("virtio_disk_intr status");
    8000668c:	00002517          	auipc	a0,0x2
    80006690:	1fc50513          	addi	a0,a0,508 # 80008888 <syscalls+0x3f8>
    80006694:	ffffa097          	auipc	ra,0xffffa
    80006698:	eaa080e7          	jalr	-342(ra) # 8000053e <panic>
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
