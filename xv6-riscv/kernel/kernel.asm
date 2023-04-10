
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
    80000068:	c5c78793          	addi	a5,a5,-932 # 80005cc0 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdbe7f>
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
    80000130:	454080e7          	jalr	1108(ra) # 80002580 <either_copyin>
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
    800001cc:	1c0080e7          	jalr	448(ra) # 80002388 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	ef4080e7          	jalr	-268(ra) # 800020ca <sleep>
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
    80000216:	318080e7          	jalr	792(ra) # 8000252a <either_copyout>
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
    800002f6:	2e4080e7          	jalr	740(ra) # 800025d6 <procdump>
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
    8000044a:	ce8080e7          	jalr	-792(ra) # 8000212e <wakeup>
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
    8000047c:	37078793          	addi	a5,a5,880 # 800217e8 <devsw>
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
    80000896:	89c080e7          	jalr	-1892(ra) # 8000212e <wakeup>
    
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
    80000920:	7ae080e7          	jalr	1966(ra) # 800020ca <sleep>
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
    80000a02:	f8278793          	addi	a5,a5,-126 # 80022980 <end>
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
    80000ad2:	eb250513          	addi	a0,a0,-334 # 80022980 <end>
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
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	858080e7          	jalr	-1960(ra) # 80002716 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	e3a080e7          	jalr	-454(ra) # 80005d00 <plicinithart>
  }

  scheduler();        
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	04a080e7          	jalr	74(ra) # 80001f18 <scheduler>
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
    80000f3a:	7b8080e7          	jalr	1976(ra) # 800026ee <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00001097          	auipc	ra,0x1
    80000f42:	7d8080e7          	jalr	2008(ra) # 80002716 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	da4080e7          	jalr	-604(ra) # 80005cea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	db2080e7          	jalr	-590(ra) # 80005d00 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	f4e080e7          	jalr	-178(ra) # 80002ea4 <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	5f2080e7          	jalr	1522(ra) # 80003550 <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	590080e7          	jalr	1424(ra) # 800044f6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	e9a080e7          	jalr	-358(ra) # 80005e08 <virtio_disk_init>
    userinit();      // first user process
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d84080e7          	jalr	-636(ra) # 80001cfa <userinit>
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
    8000186a:	d3aa0a13          	addi	s4,s4,-710 # 800175a0 <tickslock>
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
    800018a0:	19848493          	addi	s1,s1,408
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
    80001936:	c6e98993          	addi	s3,s3,-914 # 800175a0 <tickslock>
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
    80001962:	f8bc                	sd	a5,112(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001964:	19848493          	addi	s1,s1,408
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
    80001a0a:	d28080e7          	jalr	-728(ra) # 8000272e <usertrapret>
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
    80001a24:	ab0080e7          	jalr	-1360(ra) # 800034d0 <fsinit>
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
    80001aac:	08893683          	ld	a3,136(s2)
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
    80001b72:	6548                	ld	a0,136(a0)
    80001b74:	c509                	beqz	a0,80001b7e <freeproc+0x20>
    kfree((void*)p->trapframe);
    80001b76:	fffff097          	auipc	ra,0xfffff
    80001b7a:	e74080e7          	jalr	-396(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b7e:	08093423          	sd	zero,136(s2)
  if(p->pagetable)
    80001b82:	08093503          	ld	a0,128(s2)
    80001b86:	c519                	beqz	a0,80001b94 <freeproc+0x36>
    proc_freepagetable(p->pagetable, p->sz);
    80001b88:	07893583          	ld	a1,120(s2)
    80001b8c:	00000097          	auipc	ra,0x0
    80001b90:	f80080e7          	jalr	-128(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b94:	08093023          	sd	zero,128(s2)
  p->sz = 0;
    80001b98:	06093c23          	sd	zero,120(s2)
  p->pid = 0;
    80001b9c:	02092823          	sw	zero,48(s2)
  p->parent = 0;
    80001ba0:	06093423          	sd	zero,104(s2)
  p->name[0] = 0;
    80001ba4:	18090423          	sb	zero,392(s2)
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
    80001bba:	06f92023          	sw	a5,96(s2)
    long long min=LLONG_MAX;
    80001bbe:	5afd                	li	s5,-1
    80001bc0:	001ada93          	srli	s5,s5,0x1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001bc4:	0000f497          	auipc	s1,0xf
    80001bc8:	3dc48493          	addi	s1,s1,988 # 80010fa0 <proc>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001bcc:	4a05                	li	s4,1
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001bce:	00016997          	auipc	s3,0x16
    80001bd2:	9d298993          	addi	s3,s3,-1582 # 800175a0 <tickslock>
    80001bd6:	a811                	j	80001bea <freeproc+0x8c>
        release(&other_p->lock);
    80001bd8:	8526                	mv	a0,s1
    80001bda:	fffff097          	auipc	ra,0xfffff
    80001bde:	0b0080e7          	jalr	176(ra) # 80000c8a <release>
    for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80001be2:	19848493          	addi	s1,s1,408
    80001be6:	03348263          	beq	s1,s3,80001c0a <freeproc+0xac>
        if(other_p != p){
    80001bea:	fe990ce3          	beq	s2,s1,80001be2 <freeproc+0x84>
           acquire(&other_p->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	fffff097          	auipc	ra,0xfffff
    80001bf4:	fe6080e7          	jalr	-26(ra) # 80000bd6 <acquire>
            if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    80001bf8:	4c9c                	lw	a5,24(s1)
    80001bfa:	37f5                	addiw	a5,a5,-3
    80001bfc:	fcfa6ee3          	bltu	s4,a5,80001bd8 <freeproc+0x7a>
              if(min>other_p->accumulator)
    80001c00:	6cbc                	ld	a5,88(s1)
    80001c02:	fd57dbe3          	bge	a5,s5,80001bd8 <freeproc+0x7a>
    80001c06:	8abe                	mv	s5,a5
    80001c08:	bfc1                	j	80001bd8 <freeproc+0x7a>
    if(min==LLONG_MAX){
    80001c0a:	57fd                	li	a5,-1
    80001c0c:	8385                	srli	a5,a5,0x1
    80001c0e:	00fa8d63          	beq	s5,a5,80001c28 <freeproc+0xca>
    80001c12:	05593c23          	sd	s5,88(s2)
}
    80001c16:	70e2                	ld	ra,56(sp)
    80001c18:	7442                	ld	s0,48(sp)
    80001c1a:	74a2                	ld	s1,40(sp)
    80001c1c:	7902                	ld	s2,32(sp)
    80001c1e:	69e2                	ld	s3,24(sp)
    80001c20:	6a42                	ld	s4,16(sp)
    80001c22:	6aa2                	ld	s5,8(sp)
    80001c24:	6121                	addi	sp,sp,64
    80001c26:	8082                	ret
      p->accumulator=0;
    80001c28:	4a81                	li	s5,0
    80001c2a:	b7e5                	j	80001c12 <freeproc+0xb4>

0000000080001c2c <allocproc>:
{
    80001c2c:	1101                	addi	sp,sp,-32
    80001c2e:	ec06                	sd	ra,24(sp)
    80001c30:	e822                	sd	s0,16(sp)
    80001c32:	e426                	sd	s1,8(sp)
    80001c34:	e04a                	sd	s2,0(sp)
    80001c36:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c38:	0000f497          	auipc	s1,0xf
    80001c3c:	36848493          	addi	s1,s1,872 # 80010fa0 <proc>
    80001c40:	00016917          	auipc	s2,0x16
    80001c44:	96090913          	addi	s2,s2,-1696 # 800175a0 <tickslock>
    acquire(&p->lock);
    80001c48:	8526                	mv	a0,s1
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	f8c080e7          	jalr	-116(ra) # 80000bd6 <acquire>
    if(p->state == UNUSED) {
    80001c52:	4c9c                	lw	a5,24(s1)
    80001c54:	cf81                	beqz	a5,80001c6c <allocproc+0x40>
      release(&p->lock);
    80001c56:	8526                	mv	a0,s1
    80001c58:	fffff097          	auipc	ra,0xfffff
    80001c5c:	032080e7          	jalr	50(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c60:	19848493          	addi	s1,s1,408
    80001c64:	ff2492e3          	bne	s1,s2,80001c48 <allocproc+0x1c>
  return 0;
    80001c68:	4481                	li	s1,0
    80001c6a:	a889                	j	80001cbc <allocproc+0x90>
  p->pid = allocpid();
    80001c6c:	00000097          	auipc	ra,0x0
    80001c70:	dbe080e7          	jalr	-578(ra) # 80001a2a <allocpid>
    80001c74:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c76:	4785                	li	a5,1
    80001c78:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	e6c080e7          	jalr	-404(ra) # 80000ae6 <kalloc>
    80001c82:	892a                	mv	s2,a0
    80001c84:	e4c8                	sd	a0,136(s1)
    80001c86:	c131                	beqz	a0,80001cca <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	de6080e7          	jalr	-538(ra) # 80001a70 <proc_pagetable>
    80001c92:	892a                	mv	s2,a0
    80001c94:	e0c8                	sd	a0,128(s1)
  if(p->pagetable == 0){
    80001c96:	c531                	beqz	a0,80001ce2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c98:	07000613          	li	a2,112
    80001c9c:	4581                	li	a1,0
    80001c9e:	09048513          	addi	a0,s1,144
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	030080e7          	jalr	48(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001caa:	00000797          	auipc	a5,0x0
    80001cae:	d3a78793          	addi	a5,a5,-710 # 800019e4 <forkret>
    80001cb2:	e8dc                	sd	a5,144(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cb4:	78bc                	ld	a5,112(s1)
    80001cb6:	6705                	lui	a4,0x1
    80001cb8:	97ba                	add	a5,a5,a4
    80001cba:	ecdc                	sd	a5,152(s1)
}
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	60e2                	ld	ra,24(sp)
    80001cc0:	6442                	ld	s0,16(sp)
    80001cc2:	64a2                	ld	s1,8(sp)
    80001cc4:	6902                	ld	s2,0(sp)
    80001cc6:	6105                	addi	sp,sp,32
    80001cc8:	8082                	ret
    freeproc(p);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	e92080e7          	jalr	-366(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	fb4080e7          	jalr	-76(ra) # 80000c8a <release>
    return 0;
    80001cde:	84ca                	mv	s1,s2
    80001ce0:	bff1                	j	80001cbc <allocproc+0x90>
    freeproc(p);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	e7a080e7          	jalr	-390(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	f9c080e7          	jalr	-100(ra) # 80000c8a <release>
    return 0;
    80001cf6:	84ca                	mv	s1,s2
    80001cf8:	b7d1                	j	80001cbc <allocproc+0x90>

0000000080001cfa <userinit>:
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d04:	00000097          	auipc	ra,0x0
    80001d08:	f28080e7          	jalr	-216(ra) # 80001c2c <allocproc>
    80001d0c:	84aa                	mv	s1,a0
  initproc = p;
    80001d0e:	00007797          	auipc	a5,0x7
    80001d12:	bea7b523          	sd	a0,-1046(a5) # 800088f8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d16:	03400613          	li	a2,52
    80001d1a:	00007597          	auipc	a1,0x7
    80001d1e:	b5658593          	addi	a1,a1,-1194 # 80008870 <initcode>
    80001d22:	6148                	ld	a0,128(a0)
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	632080e7          	jalr	1586(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001d2c:	6785                	lui	a5,0x1
    80001d2e:	fcbc                	sd	a5,120(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d30:	64d8                	ld	a4,136(s1)
    80001d32:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d36:	64d8                	ld	a4,136(s1)
    80001d38:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d3a:	4641                	li	a2,16
    80001d3c:	00006597          	auipc	a1,0x6
    80001d40:	4c458593          	addi	a1,a1,1220 # 80008200 <digits+0x1c0>
    80001d44:	18848513          	addi	a0,s1,392
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	0d4080e7          	jalr	212(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	4c050513          	addi	a0,a0,1216 # 80008210 <digits+0x1d0>
    80001d58:	00002097          	auipc	ra,0x2
    80001d5c:	19a080e7          	jalr	410(ra) # 80003ef2 <namei>
    80001d60:	18a4b023          	sd	a0,384(s1)
  p->state = RUNNABLE;
    80001d64:	478d                	li	a5,3
    80001d66:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d68:	8526                	mv	a0,s1
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	f20080e7          	jalr	-224(ra) # 80000c8a <release>
}
    80001d72:	60e2                	ld	ra,24(sp)
    80001d74:	6442                	ld	s0,16(sp)
    80001d76:	64a2                	ld	s1,8(sp)
    80001d78:	6105                	addi	sp,sp,32
    80001d7a:	8082                	ret

0000000080001d7c <growproc>:
{
    80001d7c:	1101                	addi	sp,sp,-32
    80001d7e:	ec06                	sd	ra,24(sp)
    80001d80:	e822                	sd	s0,16(sp)
    80001d82:	e426                	sd	s1,8(sp)
    80001d84:	e04a                	sd	s2,0(sp)
    80001d86:	1000                	addi	s0,sp,32
    80001d88:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	c22080e7          	jalr	-990(ra) # 800019ac <myproc>
    80001d92:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d94:	7d2c                	ld	a1,120(a0)
  if(n > 0){
    80001d96:	01204c63          	bgtz	s2,80001dae <growproc+0x32>
  } else if(n < 0){
    80001d9a:	02094663          	bltz	s2,80001dc6 <growproc+0x4a>
  p->sz = sz;
    80001d9e:	fcac                	sd	a1,120(s1)
  return 0;
    80001da0:	4501                	li	a0,0
}
    80001da2:	60e2                	ld	ra,24(sp)
    80001da4:	6442                	ld	s0,16(sp)
    80001da6:	64a2                	ld	s1,8(sp)
    80001da8:	6902                	ld	s2,0(sp)
    80001daa:	6105                	addi	sp,sp,32
    80001dac:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dae:	4691                	li	a3,4
    80001db0:	00b90633          	add	a2,s2,a1
    80001db4:	6148                	ld	a0,128(a0)
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	65a080e7          	jalr	1626(ra) # 80001410 <uvmalloc>
    80001dbe:	85aa                	mv	a1,a0
    80001dc0:	fd79                	bnez	a0,80001d9e <growproc+0x22>
      return -1;
    80001dc2:	557d                	li	a0,-1
    80001dc4:	bff9                	j	80001da2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dc6:	00b90633          	add	a2,s2,a1
    80001dca:	6148                	ld	a0,128(a0)
    80001dcc:	fffff097          	auipc	ra,0xfffff
    80001dd0:	5fc080e7          	jalr	1532(ra) # 800013c8 <uvmdealloc>
    80001dd4:	85aa                	mv	a1,a0
    80001dd6:	b7e1                	j	80001d9e <growproc+0x22>

0000000080001dd8 <fork>:
{
    80001dd8:	7139                	addi	sp,sp,-64
    80001dda:	fc06                	sd	ra,56(sp)
    80001ddc:	f822                	sd	s0,48(sp)
    80001dde:	f426                	sd	s1,40(sp)
    80001de0:	f04a                	sd	s2,32(sp)
    80001de2:	ec4e                	sd	s3,24(sp)
    80001de4:	e852                	sd	s4,16(sp)
    80001de6:	e456                	sd	s5,8(sp)
    80001de8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	bc2080e7          	jalr	-1086(ra) # 800019ac <myproc>
    80001df2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	e38080e7          	jalr	-456(ra) # 80001c2c <allocproc>
    80001dfc:	10050c63          	beqz	a0,80001f14 <fork+0x13c>
    80001e00:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e02:	078ab603          	ld	a2,120(s5)
    80001e06:	614c                	ld	a1,128(a0)
    80001e08:	080ab503          	ld	a0,128(s5)
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	758080e7          	jalr	1880(ra) # 80001564 <uvmcopy>
    80001e14:	04054863          	bltz	a0,80001e64 <fork+0x8c>
  np->sz = p->sz;
    80001e18:	078ab783          	ld	a5,120(s5)
    80001e1c:	06fa3c23          	sd	a5,120(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e20:	088ab683          	ld	a3,136(s5)
    80001e24:	87b6                	mv	a5,a3
    80001e26:	088a3703          	ld	a4,136(s4)
    80001e2a:	12068693          	addi	a3,a3,288
    80001e2e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e32:	6788                	ld	a0,8(a5)
    80001e34:	6b8c                	ld	a1,16(a5)
    80001e36:	6f90                	ld	a2,24(a5)
    80001e38:	01073023          	sd	a6,0(a4)
    80001e3c:	e708                	sd	a0,8(a4)
    80001e3e:	eb0c                	sd	a1,16(a4)
    80001e40:	ef10                	sd	a2,24(a4)
    80001e42:	02078793          	addi	a5,a5,32
    80001e46:	02070713          	addi	a4,a4,32
    80001e4a:	fed792e3          	bne	a5,a3,80001e2e <fork+0x56>
  np->trapframe->a0 = 0;
    80001e4e:	088a3783          	ld	a5,136(s4)
    80001e52:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e56:	100a8493          	addi	s1,s5,256
    80001e5a:	100a0913          	addi	s2,s4,256
    80001e5e:	180a8993          	addi	s3,s5,384
    80001e62:	a00d                	j	80001e84 <fork+0xac>
    freeproc(np);
    80001e64:	8552                	mv	a0,s4
    80001e66:	00000097          	auipc	ra,0x0
    80001e6a:	cf8080e7          	jalr	-776(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001e6e:	8552                	mv	a0,s4
    80001e70:	fffff097          	auipc	ra,0xfffff
    80001e74:	e1a080e7          	jalr	-486(ra) # 80000c8a <release>
    return -1;
    80001e78:	597d                	li	s2,-1
    80001e7a:	a059                	j	80001f00 <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001e7c:	04a1                	addi	s1,s1,8
    80001e7e:	0921                	addi	s2,s2,8
    80001e80:	01348b63          	beq	s1,s3,80001e96 <fork+0xbe>
    if(p->ofile[i])
    80001e84:	6088                	ld	a0,0(s1)
    80001e86:	d97d                	beqz	a0,80001e7c <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e88:	00002097          	auipc	ra,0x2
    80001e8c:	700080e7          	jalr	1792(ra) # 80004588 <filedup>
    80001e90:	00a93023          	sd	a0,0(s2)
    80001e94:	b7e5                	j	80001e7c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e96:	180ab503          	ld	a0,384(s5)
    80001e9a:	00002097          	auipc	ra,0x2
    80001e9e:	874080e7          	jalr	-1932(ra) # 8000370e <idup>
    80001ea2:	18aa3023          	sd	a0,384(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea6:	4641                	li	a2,16
    80001ea8:	188a8593          	addi	a1,s5,392
    80001eac:	188a0513          	addi	a0,s4,392
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	f6c080e7          	jalr	-148(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001eb8:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001ebc:	8552                	mv	a0,s4
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	dcc080e7          	jalr	-564(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001ec6:	0000f497          	auipc	s1,0xf
    80001eca:	cc248493          	addi	s1,s1,-830 # 80010b88 <wait_lock>
    80001ece:	8526                	mv	a0,s1
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	d06080e7          	jalr	-762(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001ed8:	075a3423          	sd	s5,104(s4)
  release(&wait_lock);
    80001edc:	8526                	mv	a0,s1
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	dac080e7          	jalr	-596(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001ee6:	8552                	mv	a0,s4
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	cee080e7          	jalr	-786(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001ef0:	478d                	li	a5,3
    80001ef2:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001ef6:	8552                	mv	a0,s4
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	d92080e7          	jalr	-622(ra) # 80000c8a <release>
}
    80001f00:	854a                	mv	a0,s2
    80001f02:	70e2                	ld	ra,56(sp)
    80001f04:	7442                	ld	s0,48(sp)
    80001f06:	74a2                	ld	s1,40(sp)
    80001f08:	7902                	ld	s2,32(sp)
    80001f0a:	69e2                	ld	s3,24(sp)
    80001f0c:	6a42                	ld	s4,16(sp)
    80001f0e:	6aa2                	ld	s5,8(sp)
    80001f10:	6121                	addi	sp,sp,64
    80001f12:	8082                	ret
    return -1;
    80001f14:	597d                	li	s2,-1
    80001f16:	b7ed                	j	80001f00 <fork+0x128>

0000000080001f18 <scheduler>:
{
    80001f18:	7139                	addi	sp,sp,-64
    80001f1a:	fc06                	sd	ra,56(sp)
    80001f1c:	f822                	sd	s0,48(sp)
    80001f1e:	f426                	sd	s1,40(sp)
    80001f20:	f04a                	sd	s2,32(sp)
    80001f22:	ec4e                	sd	s3,24(sp)
    80001f24:	e852                	sd	s4,16(sp)
    80001f26:	e456                	sd	s5,8(sp)
    80001f28:	e05a                	sd	s6,0(sp)
    80001f2a:	0080                	addi	s0,sp,64
    80001f2c:	8792                	mv	a5,tp
  int id = r_tp();
    80001f2e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f30:	00779a93          	slli	s5,a5,0x7
    80001f34:	0000f717          	auipc	a4,0xf
    80001f38:	c3c70713          	addi	a4,a4,-964 # 80010b70 <pid_lock>
    80001f3c:	9756                	add	a4,a4,s5
    80001f3e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f42:	0000f717          	auipc	a4,0xf
    80001f46:	c6670713          	addi	a4,a4,-922 # 80010ba8 <cpus+0x8>
    80001f4a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001f4c:	498d                	li	s3,3
        p->state = RUNNING;
    80001f4e:	4b11                	li	s6,4
        c->proc = p;
    80001f50:	079e                	slli	a5,a5,0x7
    80001f52:	0000fa17          	auipc	s4,0xf
    80001f56:	c1ea0a13          	addi	s4,s4,-994 # 80010b70 <pid_lock>
    80001f5a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f5c:	00015917          	auipc	s2,0x15
    80001f60:	64490913          	addi	s2,s2,1604 # 800175a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f64:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f68:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f6c:	10079073          	csrw	sstatus,a5
    80001f70:	0000f497          	auipc	s1,0xf
    80001f74:	03048493          	addi	s1,s1,48 # 80010fa0 <proc>
    80001f78:	a811                	j	80001f8c <scheduler+0x74>
      release(&p->lock);
    80001f7a:	8526                	mv	a0,s1
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	d0e080e7          	jalr	-754(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f84:	19848493          	addi	s1,s1,408
    80001f88:	fd248ee3          	beq	s1,s2,80001f64 <scheduler+0x4c>
      acquire(&p->lock);
    80001f8c:	8526                	mv	a0,s1
    80001f8e:	fffff097          	auipc	ra,0xfffff
    80001f92:	c48080e7          	jalr	-952(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE) {
    80001f96:	4c9c                	lw	a5,24(s1)
    80001f98:	ff3791e3          	bne	a5,s3,80001f7a <scheduler+0x62>
        p->state = RUNNING;
    80001f9c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001fa0:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001fa4:	09048593          	addi	a1,s1,144
    80001fa8:	8556                	mv	a0,s5
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	6da080e7          	jalr	1754(ra) # 80002684 <swtch>
        c->proc = 0;
    80001fb2:	020a3823          	sd	zero,48(s4)
    80001fb6:	b7d1                	j	80001f7a <scheduler+0x62>

0000000080001fb8 <sched>:
{
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	9e6080e7          	jalr	-1562(ra) # 800019ac <myproc>
    80001fce:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	b8c080e7          	jalr	-1140(ra) # 80000b5c <holding>
    80001fd8:	c93d                	beqz	a0,8000204e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fda:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fdc:	2781                	sext.w	a5,a5
    80001fde:	079e                	slli	a5,a5,0x7
    80001fe0:	0000f717          	auipc	a4,0xf
    80001fe4:	b9070713          	addi	a4,a4,-1136 # 80010b70 <pid_lock>
    80001fe8:	97ba                	add	a5,a5,a4
    80001fea:	0a87a703          	lw	a4,168(a5)
    80001fee:	4785                	li	a5,1
    80001ff0:	06f71763          	bne	a4,a5,8000205e <sched+0xa6>
  if(p->state == RUNNING)
    80001ff4:	4c98                	lw	a4,24(s1)
    80001ff6:	4791                	li	a5,4
    80001ff8:	06f70b63          	beq	a4,a5,8000206e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ffc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002000:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002002:	efb5                	bnez	a5,8000207e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002004:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002006:	0000f917          	auipc	s2,0xf
    8000200a:	b6a90913          	addi	s2,s2,-1174 # 80010b70 <pid_lock>
    8000200e:	2781                	sext.w	a5,a5
    80002010:	079e                	slli	a5,a5,0x7
    80002012:	97ca                	add	a5,a5,s2
    80002014:	0ac7a983          	lw	s3,172(a5)
    80002018:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000201a:	2781                	sext.w	a5,a5
    8000201c:	079e                	slli	a5,a5,0x7
    8000201e:	0000f597          	auipc	a1,0xf
    80002022:	b8a58593          	addi	a1,a1,-1142 # 80010ba8 <cpus+0x8>
    80002026:	95be                	add	a1,a1,a5
    80002028:	09048513          	addi	a0,s1,144
    8000202c:	00000097          	auipc	ra,0x0
    80002030:	658080e7          	jalr	1624(ra) # 80002684 <swtch>
    80002034:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002036:	2781                	sext.w	a5,a5
    80002038:	079e                	slli	a5,a5,0x7
    8000203a:	97ca                	add	a5,a5,s2
    8000203c:	0b37a623          	sw	s3,172(a5)
}
    80002040:	70a2                	ld	ra,40(sp)
    80002042:	7402                	ld	s0,32(sp)
    80002044:	64e2                	ld	s1,24(sp)
    80002046:	6942                	ld	s2,16(sp)
    80002048:	69a2                	ld	s3,8(sp)
    8000204a:	6145                	addi	sp,sp,48
    8000204c:	8082                	ret
    panic("sched p->lock");
    8000204e:	00006517          	auipc	a0,0x6
    80002052:	1ca50513          	addi	a0,a0,458 # 80008218 <digits+0x1d8>
    80002056:	ffffe097          	auipc	ra,0xffffe
    8000205a:	4e8080e7          	jalr	1256(ra) # 8000053e <panic>
    panic("sched locks");
    8000205e:	00006517          	auipc	a0,0x6
    80002062:	1ca50513          	addi	a0,a0,458 # 80008228 <digits+0x1e8>
    80002066:	ffffe097          	auipc	ra,0xffffe
    8000206a:	4d8080e7          	jalr	1240(ra) # 8000053e <panic>
    panic("sched running");
    8000206e:	00006517          	auipc	a0,0x6
    80002072:	1ca50513          	addi	a0,a0,458 # 80008238 <digits+0x1f8>
    80002076:	ffffe097          	auipc	ra,0xffffe
    8000207a:	4c8080e7          	jalr	1224(ra) # 8000053e <panic>
    panic("sched interruptible");
    8000207e:	00006517          	auipc	a0,0x6
    80002082:	1ca50513          	addi	a0,a0,458 # 80008248 <digits+0x208>
    80002086:	ffffe097          	auipc	ra,0xffffe
    8000208a:	4b8080e7          	jalr	1208(ra) # 8000053e <panic>

000000008000208e <yield>:
{
    8000208e:	1101                	addi	sp,sp,-32
    80002090:	ec06                	sd	ra,24(sp)
    80002092:	e822                	sd	s0,16(sp)
    80002094:	e426                	sd	s1,8(sp)
    80002096:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002098:	00000097          	auipc	ra,0x0
    8000209c:	914080e7          	jalr	-1772(ra) # 800019ac <myproc>
    800020a0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020a2:	fffff097          	auipc	ra,0xfffff
    800020a6:	b34080e7          	jalr	-1228(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    800020aa:	478d                	li	a5,3
    800020ac:	cc9c                	sw	a5,24(s1)
  sched();
    800020ae:	00000097          	auipc	ra,0x0
    800020b2:	f0a080e7          	jalr	-246(ra) # 80001fb8 <sched>
  release(&p->lock);
    800020b6:	8526                	mv	a0,s1
    800020b8:	fffff097          	auipc	ra,0xfffff
    800020bc:	bd2080e7          	jalr	-1070(ra) # 80000c8a <release>
}
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	64a2                	ld	s1,8(sp)
    800020c6:	6105                	addi	sp,sp,32
    800020c8:	8082                	ret

00000000800020ca <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020ca:	7179                	addi	sp,sp,-48
    800020cc:	f406                	sd	ra,40(sp)
    800020ce:	f022                	sd	s0,32(sp)
    800020d0:	ec26                	sd	s1,24(sp)
    800020d2:	e84a                	sd	s2,16(sp)
    800020d4:	e44e                	sd	s3,8(sp)
    800020d6:	1800                	addi	s0,sp,48
    800020d8:	89aa                	mv	s3,a0
    800020da:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	8d0080e7          	jalr	-1840(ra) # 800019ac <myproc>
    800020e4:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020e6:	fffff097          	auipc	ra,0xfffff
    800020ea:	af0080e7          	jalr	-1296(ra) # 80000bd6 <acquire>
  release(lk);
    800020ee:	854a                	mv	a0,s2
    800020f0:	fffff097          	auipc	ra,0xfffff
    800020f4:	b9a080e7          	jalr	-1126(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    800020f8:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020fc:	4789                	li	a5,2
    800020fe:	cc9c                	sw	a5,24(s1)

  sched();
    80002100:	00000097          	auipc	ra,0x0
    80002104:	eb8080e7          	jalr	-328(ra) # 80001fb8 <sched>

  // Tidy up.
  p->chan = 0;
    80002108:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000210c:	8526                	mv	a0,s1
    8000210e:	fffff097          	auipc	ra,0xfffff
    80002112:	b7c080e7          	jalr	-1156(ra) # 80000c8a <release>
  acquire(lk);
    80002116:	854a                	mv	a0,s2
    80002118:	fffff097          	auipc	ra,0xfffff
    8000211c:	abe080e7          	jalr	-1346(ra) # 80000bd6 <acquire>
}
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	64e2                	ld	s1,24(sp)
    80002126:	6942                	ld	s2,16(sp)
    80002128:	69a2                	ld	s3,8(sp)
    8000212a:	6145                	addi	sp,sp,48
    8000212c:	8082                	ret

000000008000212e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000212e:	7139                	addi	sp,sp,-64
    80002130:	fc06                	sd	ra,56(sp)
    80002132:	f822                	sd	s0,48(sp)
    80002134:	f426                	sd	s1,40(sp)
    80002136:	f04a                	sd	s2,32(sp)
    80002138:	ec4e                	sd	s3,24(sp)
    8000213a:	e852                	sd	s4,16(sp)
    8000213c:	e456                	sd	s5,8(sp)
    8000213e:	0080                	addi	s0,sp,64
    80002140:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002142:	0000f497          	auipc	s1,0xf
    80002146:	e5e48493          	addi	s1,s1,-418 # 80010fa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000214a:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000214c:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000214e:	00015917          	auipc	s2,0x15
    80002152:	45290913          	addi	s2,s2,1106 # 800175a0 <tickslock>
    80002156:	a811                	j	8000216a <wakeup+0x3c>
      }
      release(&p->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	b30080e7          	jalr	-1232(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002162:	19848493          	addi	s1,s1,408
    80002166:	03248663          	beq	s1,s2,80002192 <wakeup+0x64>
    if(p != myproc()){
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	842080e7          	jalr	-1982(ra) # 800019ac <myproc>
    80002172:	fea488e3          	beq	s1,a0,80002162 <wakeup+0x34>
      acquire(&p->lock);
    80002176:	8526                	mv	a0,s1
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	a5e080e7          	jalr	-1442(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002180:	4c9c                	lw	a5,24(s1)
    80002182:	fd379be3          	bne	a5,s3,80002158 <wakeup+0x2a>
    80002186:	709c                	ld	a5,32(s1)
    80002188:	fd4798e3          	bne	a5,s4,80002158 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000218c:	0154ac23          	sw	s5,24(s1)
    80002190:	b7e1                	j	80002158 <wakeup+0x2a>
    }
  }
}
    80002192:	70e2                	ld	ra,56(sp)
    80002194:	7442                	ld	s0,48(sp)
    80002196:	74a2                	ld	s1,40(sp)
    80002198:	7902                	ld	s2,32(sp)
    8000219a:	69e2                	ld	s3,24(sp)
    8000219c:	6a42                	ld	s4,16(sp)
    8000219e:	6aa2                	ld	s5,8(sp)
    800021a0:	6121                	addi	sp,sp,64
    800021a2:	8082                	ret

00000000800021a4 <reparent>:
{
    800021a4:	7179                	addi	sp,sp,-48
    800021a6:	f406                	sd	ra,40(sp)
    800021a8:	f022                	sd	s0,32(sp)
    800021aa:	ec26                	sd	s1,24(sp)
    800021ac:	e84a                	sd	s2,16(sp)
    800021ae:	e44e                	sd	s3,8(sp)
    800021b0:	e052                	sd	s4,0(sp)
    800021b2:	1800                	addi	s0,sp,48
    800021b4:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021b6:	0000f497          	auipc	s1,0xf
    800021ba:	dea48493          	addi	s1,s1,-534 # 80010fa0 <proc>
      pp->parent = initproc;
    800021be:	00006a17          	auipc	s4,0x6
    800021c2:	73aa0a13          	addi	s4,s4,1850 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021c6:	00015997          	auipc	s3,0x15
    800021ca:	3da98993          	addi	s3,s3,986 # 800175a0 <tickslock>
    800021ce:	a029                	j	800021d8 <reparent+0x34>
    800021d0:	19848493          	addi	s1,s1,408
    800021d4:	01348d63          	beq	s1,s3,800021ee <reparent+0x4a>
    if(pp->parent == p){
    800021d8:	74bc                	ld	a5,104(s1)
    800021da:	ff279be3          	bne	a5,s2,800021d0 <reparent+0x2c>
      pp->parent = initproc;
    800021de:	000a3503          	ld	a0,0(s4)
    800021e2:	f4a8                	sd	a0,104(s1)
      wakeup(initproc);
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	f4a080e7          	jalr	-182(ra) # 8000212e <wakeup>
    800021ec:	b7d5                	j	800021d0 <reparent+0x2c>
}
    800021ee:	70a2                	ld	ra,40(sp)
    800021f0:	7402                	ld	s0,32(sp)
    800021f2:	64e2                	ld	s1,24(sp)
    800021f4:	6942                	ld	s2,16(sp)
    800021f6:	69a2                	ld	s3,8(sp)
    800021f8:	6a02                	ld	s4,0(sp)
    800021fa:	6145                	addi	sp,sp,48
    800021fc:	8082                	ret

00000000800021fe <exit>:
{
    800021fe:	7139                	addi	sp,sp,-64
    80002200:	fc06                	sd	ra,56(sp)
    80002202:	f822                	sd	s0,48(sp)
    80002204:	f426                	sd	s1,40(sp)
    80002206:	f04a                	sd	s2,32(sp)
    80002208:	ec4e                	sd	s3,24(sp)
    8000220a:	e852                	sd	s4,16(sp)
    8000220c:	e456                	sd	s5,8(sp)
    8000220e:	0080                	addi	s0,sp,64
    80002210:	8aaa                	mv	s5,a0
    80002212:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	798080e7          	jalr	1944(ra) # 800019ac <myproc>
    8000221c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000221e:	00006797          	auipc	a5,0x6
    80002222:	6da7b783          	ld	a5,1754(a5) # 800088f8 <initproc>
    80002226:	10050493          	addi	s1,a0,256
    8000222a:	18050913          	addi	s2,a0,384
    8000222e:	02a79363          	bne	a5,a0,80002254 <exit+0x56>
    panic("init exiting");
    80002232:	00006517          	auipc	a0,0x6
    80002236:	02e50513          	addi	a0,a0,46 # 80008260 <digits+0x220>
    8000223a:	ffffe097          	auipc	ra,0xffffe
    8000223e:	304080e7          	jalr	772(ra) # 8000053e <panic>
      fileclose(f);
    80002242:	00002097          	auipc	ra,0x2
    80002246:	398080e7          	jalr	920(ra) # 800045da <fileclose>
      p->ofile[fd] = 0;
    8000224a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000224e:	04a1                	addi	s1,s1,8
    80002250:	01248563          	beq	s1,s2,8000225a <exit+0x5c>
    if(p->ofile[fd]){
    80002254:	6088                	ld	a0,0(s1)
    80002256:	f575                	bnez	a0,80002242 <exit+0x44>
    80002258:	bfdd                	j	8000224e <exit+0x50>
  begin_op();
    8000225a:	00002097          	auipc	ra,0x2
    8000225e:	eb4080e7          	jalr	-332(ra) # 8000410e <begin_op>
  iput(p->cwd);
    80002262:	1809b503          	ld	a0,384(s3)
    80002266:	00001097          	auipc	ra,0x1
    8000226a:	6a0080e7          	jalr	1696(ra) # 80003906 <iput>
  end_op();
    8000226e:	00002097          	auipc	ra,0x2
    80002272:	f20080e7          	jalr	-224(ra) # 8000418e <end_op>
  p->cwd = 0;
    80002276:	1809b023          	sd	zero,384(s3)
  acquire(&wait_lock);
    8000227a:	0000f497          	auipc	s1,0xf
    8000227e:	90e48493          	addi	s1,s1,-1778 # 80010b88 <wait_lock>
    80002282:	8526                	mv	a0,s1
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	952080e7          	jalr	-1710(ra) # 80000bd6 <acquire>
  reparent(p);
    8000228c:	854e                	mv	a0,s3
    8000228e:	00000097          	auipc	ra,0x0
    80002292:	f16080e7          	jalr	-234(ra) # 800021a4 <reparent>
  wakeup(p->parent);
    80002296:	0689b503          	ld	a0,104(s3)
    8000229a:	00000097          	auipc	ra,0x0
    8000229e:	e94080e7          	jalr	-364(ra) # 8000212e <wakeup>
  acquire(&p->lock);
    800022a2:	854e                	mv	a0,s3
    800022a4:	fffff097          	auipc	ra,0xfffff
    800022a8:	932080e7          	jalr	-1742(ra) # 80000bd6 <acquire>
  p->xstate = status;
    800022ac:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, sizeof(p->exit_msg));
    800022b0:	02000613          	li	a2,32
    800022b4:	85d2                	mv	a1,s4
    800022b6:	03498513          	addi	a0,s3,52
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	b62080e7          	jalr	-1182(ra) # 80000e1c <safestrcpy>
  p->state = ZOMBIE;
    800022c2:	4795                	li	a5,5
    800022c4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022c8:	8526                	mv	a0,s1
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	9c0080e7          	jalr	-1600(ra) # 80000c8a <release>
  sched();
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	ce6080e7          	jalr	-794(ra) # 80001fb8 <sched>
  panic("zombie exit");
    800022da:	00006517          	auipc	a0,0x6
    800022de:	f9650513          	addi	a0,a0,-106 # 80008270 <digits+0x230>
    800022e2:	ffffe097          	auipc	ra,0xffffe
    800022e6:	25c080e7          	jalr	604(ra) # 8000053e <panic>

00000000800022ea <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800022ea:	7179                	addi	sp,sp,-48
    800022ec:	f406                	sd	ra,40(sp)
    800022ee:	f022                	sd	s0,32(sp)
    800022f0:	ec26                	sd	s1,24(sp)
    800022f2:	e84a                	sd	s2,16(sp)
    800022f4:	e44e                	sd	s3,8(sp)
    800022f6:	1800                	addi	s0,sp,48
    800022f8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800022fa:	0000f497          	auipc	s1,0xf
    800022fe:	ca648493          	addi	s1,s1,-858 # 80010fa0 <proc>
    80002302:	00015997          	auipc	s3,0x15
    80002306:	29e98993          	addi	s3,s3,670 # 800175a0 <tickslock>
    acquire(&p->lock);
    8000230a:	8526                	mv	a0,s1
    8000230c:	fffff097          	auipc	ra,0xfffff
    80002310:	8ca080e7          	jalr	-1846(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    80002314:	589c                	lw	a5,48(s1)
    80002316:	01278d63          	beq	a5,s2,80002330 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000231a:	8526                	mv	a0,s1
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	96e080e7          	jalr	-1682(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002324:	19848493          	addi	s1,s1,408
    80002328:	ff3491e3          	bne	s1,s3,8000230a <kill+0x20>
  }
  return -1;
    8000232c:	557d                	li	a0,-1
    8000232e:	a829                	j	80002348 <kill+0x5e>
      p->killed = 1;
    80002330:	4785                	li	a5,1
    80002332:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002334:	4c98                	lw	a4,24(s1)
    80002336:	4789                	li	a5,2
    80002338:	00f70f63          	beq	a4,a5,80002356 <kill+0x6c>
      release(&p->lock);
    8000233c:	8526                	mv	a0,s1
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	94c080e7          	jalr	-1716(ra) # 80000c8a <release>
      return 0;
    80002346:	4501                	li	a0,0
}
    80002348:	70a2                	ld	ra,40(sp)
    8000234a:	7402                	ld	s0,32(sp)
    8000234c:	64e2                	ld	s1,24(sp)
    8000234e:	6942                	ld	s2,16(sp)
    80002350:	69a2                	ld	s3,8(sp)
    80002352:	6145                	addi	sp,sp,48
    80002354:	8082                	ret
        p->state = RUNNABLE;
    80002356:	478d                	li	a5,3
    80002358:	cc9c                	sw	a5,24(s1)
    8000235a:	b7cd                	j	8000233c <kill+0x52>

000000008000235c <setkilled>:

void
setkilled(struct proc *p)
{
    8000235c:	1101                	addi	sp,sp,-32
    8000235e:	ec06                	sd	ra,24(sp)
    80002360:	e822                	sd	s0,16(sp)
    80002362:	e426                	sd	s1,8(sp)
    80002364:	1000                	addi	s0,sp,32
    80002366:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	86e080e7          	jalr	-1938(ra) # 80000bd6 <acquire>
  p->killed = 1;
    80002370:	4785                	li	a5,1
    80002372:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002374:	8526                	mv	a0,s1
    80002376:	fffff097          	auipc	ra,0xfffff
    8000237a:	914080e7          	jalr	-1772(ra) # 80000c8a <release>
}
    8000237e:	60e2                	ld	ra,24(sp)
    80002380:	6442                	ld	s0,16(sp)
    80002382:	64a2                	ld	s1,8(sp)
    80002384:	6105                	addi	sp,sp,32
    80002386:	8082                	ret

0000000080002388 <killed>:

int
killed(struct proc *p)
{
    80002388:	1101                	addi	sp,sp,-32
    8000238a:	ec06                	sd	ra,24(sp)
    8000238c:	e822                	sd	s0,16(sp)
    8000238e:	e426                	sd	s1,8(sp)
    80002390:	e04a                	sd	s2,0(sp)
    80002392:	1000                	addi	s0,sp,32
    80002394:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002396:	fffff097          	auipc	ra,0xfffff
    8000239a:	840080e7          	jalr	-1984(ra) # 80000bd6 <acquire>
  k = p->killed;
    8000239e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023a2:	8526                	mv	a0,s1
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	8e6080e7          	jalr	-1818(ra) # 80000c8a <release>
  return k;
}
    800023ac:	854a                	mv	a0,s2
    800023ae:	60e2                	ld	ra,24(sp)
    800023b0:	6442                	ld	s0,16(sp)
    800023b2:	64a2                	ld	s1,8(sp)
    800023b4:	6902                	ld	s2,0(sp)
    800023b6:	6105                	addi	sp,sp,32
    800023b8:	8082                	ret

00000000800023ba <wait>:
{
    800023ba:	711d                	addi	sp,sp,-96
    800023bc:	ec86                	sd	ra,88(sp)
    800023be:	e8a2                	sd	s0,80(sp)
    800023c0:	e4a6                	sd	s1,72(sp)
    800023c2:	e0ca                	sd	s2,64(sp)
    800023c4:	fc4e                	sd	s3,56(sp)
    800023c6:	f852                	sd	s4,48(sp)
    800023c8:	f456                	sd	s5,40(sp)
    800023ca:	f05a                	sd	s6,32(sp)
    800023cc:	ec5e                	sd	s7,24(sp)
    800023ce:	e862                	sd	s8,16(sp)
    800023d0:	e466                	sd	s9,8(sp)
    800023d2:	1080                	addi	s0,sp,96
    800023d4:	8baa                	mv	s7,a0
    800023d6:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	5d4080e7          	jalr	1492(ra) # 800019ac <myproc>
    800023e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800023e2:	0000e517          	auipc	a0,0xe
    800023e6:	7a650513          	addi	a0,a0,1958 # 80010b88 <wait_lock>
    800023ea:	ffffe097          	auipc	ra,0xffffe
    800023ee:	7ec080e7          	jalr	2028(ra) # 80000bd6 <acquire>
    havekids = 0;
    800023f2:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800023f4:	4a15                	li	s4,5
        havekids = 1;
    800023f6:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023f8:	00015997          	auipc	s3,0x15
    800023fc:	1a898993          	addi	s3,s3,424 # 800175a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002400:	0000ec97          	auipc	s9,0xe
    80002404:	788c8c93          	addi	s9,s9,1928 # 80010b88 <wait_lock>
    havekids = 0;
    80002408:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000240a:	0000f497          	auipc	s1,0xf
    8000240e:	b9648493          	addi	s1,s1,-1130 # 80010fa0 <proc>
    80002412:	a06d                	j	800024bc <wait+0x102>
          pid = pp->pid;
    80002414:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002418:	040b9463          	bnez	s7,80002460 <wait+0xa6>
          if(addr_exitmsg != 0 && copyout(p->pagetable, addr_exitmsg, (char *)&pp->exit_msg,
    8000241c:	000b0f63          	beqz	s6,8000243a <wait+0x80>
    80002420:	02000693          	li	a3,32
    80002424:	03448613          	addi	a2,s1,52
    80002428:	85da                	mv	a1,s6
    8000242a:	08093503          	ld	a0,128(s2)
    8000242e:	fffff097          	auipc	ra,0xfffff
    80002432:	23a080e7          	jalr	570(ra) # 80001668 <copyout>
    80002436:	06054063          	bltz	a0,80002496 <wait+0xdc>
          freeproc(pp);
    8000243a:	8526                	mv	a0,s1
    8000243c:	fffff097          	auipc	ra,0xfffff
    80002440:	722080e7          	jalr	1826(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    80002444:	8526                	mv	a0,s1
    80002446:	fffff097          	auipc	ra,0xfffff
    8000244a:	844080e7          	jalr	-1980(ra) # 80000c8a <release>
          release(&wait_lock);
    8000244e:	0000e517          	auipc	a0,0xe
    80002452:	73a50513          	addi	a0,a0,1850 # 80010b88 <wait_lock>
    80002456:	fffff097          	auipc	ra,0xfffff
    8000245a:	834080e7          	jalr	-1996(ra) # 80000c8a <release>
          return pid;
    8000245e:	a04d                	j	80002500 <wait+0x146>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002460:	4691                	li	a3,4
    80002462:	02c48613          	addi	a2,s1,44
    80002466:	85de                	mv	a1,s7
    80002468:	08093503          	ld	a0,128(s2)
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	1fc080e7          	jalr	508(ra) # 80001668 <copyout>
    80002474:	fa0554e3          	bgez	a0,8000241c <wait+0x62>
            release(&pp->lock);
    80002478:	8526                	mv	a0,s1
    8000247a:	fffff097          	auipc	ra,0xfffff
    8000247e:	810080e7          	jalr	-2032(ra) # 80000c8a <release>
            release(&wait_lock);
    80002482:	0000e517          	auipc	a0,0xe
    80002486:	70650513          	addi	a0,a0,1798 # 80010b88 <wait_lock>
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	800080e7          	jalr	-2048(ra) # 80000c8a <release>
            return -1;
    80002492:	59fd                	li	s3,-1
    80002494:	a0b5                	j	80002500 <wait+0x146>
            release(&pp->lock);
    80002496:	8526                	mv	a0,s1
    80002498:	ffffe097          	auipc	ra,0xffffe
    8000249c:	7f2080e7          	jalr	2034(ra) # 80000c8a <release>
            release(&wait_lock);
    800024a0:	0000e517          	auipc	a0,0xe
    800024a4:	6e850513          	addi	a0,a0,1768 # 80010b88 <wait_lock>
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	7e2080e7          	jalr	2018(ra) # 80000c8a <release>
            return -1;
    800024b0:	59fd                	li	s3,-1
    800024b2:	a0b9                	j	80002500 <wait+0x146>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024b4:	19848493          	addi	s1,s1,408
    800024b8:	03348463          	beq	s1,s3,800024e0 <wait+0x126>
      if(pp->parent == p){
    800024bc:	74bc                	ld	a5,104(s1)
    800024be:	ff279be3          	bne	a5,s2,800024b4 <wait+0xfa>
        acquire(&pp->lock);
    800024c2:	8526                	mv	a0,s1
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	712080e7          	jalr	1810(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    800024cc:	4c9c                	lw	a5,24(s1)
    800024ce:	f54783e3          	beq	a5,s4,80002414 <wait+0x5a>
        release(&pp->lock);
    800024d2:	8526                	mv	a0,s1
    800024d4:	ffffe097          	auipc	ra,0xffffe
    800024d8:	7b6080e7          	jalr	1974(ra) # 80000c8a <release>
        havekids = 1;
    800024dc:	8756                	mv	a4,s5
    800024de:	bfd9                	j	800024b4 <wait+0xfa>
    if(!havekids || killed(p)){
    800024e0:	c719                	beqz	a4,800024ee <wait+0x134>
    800024e2:	854a                	mv	a0,s2
    800024e4:	00000097          	auipc	ra,0x0
    800024e8:	ea4080e7          	jalr	-348(ra) # 80002388 <killed>
    800024ec:	c905                	beqz	a0,8000251c <wait+0x162>
      release(&wait_lock);
    800024ee:	0000e517          	auipc	a0,0xe
    800024f2:	69a50513          	addi	a0,a0,1690 # 80010b88 <wait_lock>
    800024f6:	ffffe097          	auipc	ra,0xffffe
    800024fa:	794080e7          	jalr	1940(ra) # 80000c8a <release>
      return -1;
    800024fe:	59fd                	li	s3,-1
}
    80002500:	854e                	mv	a0,s3
    80002502:	60e6                	ld	ra,88(sp)
    80002504:	6446                	ld	s0,80(sp)
    80002506:	64a6                	ld	s1,72(sp)
    80002508:	6906                	ld	s2,64(sp)
    8000250a:	79e2                	ld	s3,56(sp)
    8000250c:	7a42                	ld	s4,48(sp)
    8000250e:	7aa2                	ld	s5,40(sp)
    80002510:	7b02                	ld	s6,32(sp)
    80002512:	6be2                	ld	s7,24(sp)
    80002514:	6c42                	ld	s8,16(sp)
    80002516:	6ca2                	ld	s9,8(sp)
    80002518:	6125                	addi	sp,sp,96
    8000251a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000251c:	85e6                	mv	a1,s9
    8000251e:	854a                	mv	a0,s2
    80002520:	00000097          	auipc	ra,0x0
    80002524:	baa080e7          	jalr	-1110(ra) # 800020ca <sleep>
    havekids = 0;
    80002528:	b5c5                	j	80002408 <wait+0x4e>

000000008000252a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000252a:	7179                	addi	sp,sp,-48
    8000252c:	f406                	sd	ra,40(sp)
    8000252e:	f022                	sd	s0,32(sp)
    80002530:	ec26                	sd	s1,24(sp)
    80002532:	e84a                	sd	s2,16(sp)
    80002534:	e44e                	sd	s3,8(sp)
    80002536:	e052                	sd	s4,0(sp)
    80002538:	1800                	addi	s0,sp,48
    8000253a:	84aa                	mv	s1,a0
    8000253c:	892e                	mv	s2,a1
    8000253e:	89b2                	mv	s3,a2
    80002540:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002542:	fffff097          	auipc	ra,0xfffff
    80002546:	46a080e7          	jalr	1130(ra) # 800019ac <myproc>
  if(user_dst){
    8000254a:	c08d                	beqz	s1,8000256c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000254c:	86d2                	mv	a3,s4
    8000254e:	864e                	mv	a2,s3
    80002550:	85ca                	mv	a1,s2
    80002552:	6148                	ld	a0,128(a0)
    80002554:	fffff097          	auipc	ra,0xfffff
    80002558:	114080e7          	jalr	276(ra) # 80001668 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000255c:	70a2                	ld	ra,40(sp)
    8000255e:	7402                	ld	s0,32(sp)
    80002560:	64e2                	ld	s1,24(sp)
    80002562:	6942                	ld	s2,16(sp)
    80002564:	69a2                	ld	s3,8(sp)
    80002566:	6a02                	ld	s4,0(sp)
    80002568:	6145                	addi	sp,sp,48
    8000256a:	8082                	ret
    memmove((char *)dst, src, len);
    8000256c:	000a061b          	sext.w	a2,s4
    80002570:	85ce                	mv	a1,s3
    80002572:	854a                	mv	a0,s2
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	7ba080e7          	jalr	1978(ra) # 80000d2e <memmove>
    return 0;
    8000257c:	8526                	mv	a0,s1
    8000257e:	bff9                	j	8000255c <either_copyout+0x32>

0000000080002580 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002580:	7179                	addi	sp,sp,-48
    80002582:	f406                	sd	ra,40(sp)
    80002584:	f022                	sd	s0,32(sp)
    80002586:	ec26                	sd	s1,24(sp)
    80002588:	e84a                	sd	s2,16(sp)
    8000258a:	e44e                	sd	s3,8(sp)
    8000258c:	e052                	sd	s4,0(sp)
    8000258e:	1800                	addi	s0,sp,48
    80002590:	892a                	mv	s2,a0
    80002592:	84ae                	mv	s1,a1
    80002594:	89b2                	mv	s3,a2
    80002596:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002598:	fffff097          	auipc	ra,0xfffff
    8000259c:	414080e7          	jalr	1044(ra) # 800019ac <myproc>
  if(user_src){
    800025a0:	c08d                	beqz	s1,800025c2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800025a2:	86d2                	mv	a3,s4
    800025a4:	864e                	mv	a2,s3
    800025a6:	85ca                	mv	a1,s2
    800025a8:	6148                	ld	a0,128(a0)
    800025aa:	fffff097          	auipc	ra,0xfffff
    800025ae:	14a080e7          	jalr	330(ra) # 800016f4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025b2:	70a2                	ld	ra,40(sp)
    800025b4:	7402                	ld	s0,32(sp)
    800025b6:	64e2                	ld	s1,24(sp)
    800025b8:	6942                	ld	s2,16(sp)
    800025ba:	69a2                	ld	s3,8(sp)
    800025bc:	6a02                	ld	s4,0(sp)
    800025be:	6145                	addi	sp,sp,48
    800025c0:	8082                	ret
    memmove(dst, (char*)src, len);
    800025c2:	000a061b          	sext.w	a2,s4
    800025c6:	85ce                	mv	a1,s3
    800025c8:	854a                	mv	a0,s2
    800025ca:	ffffe097          	auipc	ra,0xffffe
    800025ce:	764080e7          	jalr	1892(ra) # 80000d2e <memmove>
    return 0;
    800025d2:	8526                	mv	a0,s1
    800025d4:	bff9                	j	800025b2 <either_copyin+0x32>

00000000800025d6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025d6:	715d                	addi	sp,sp,-80
    800025d8:	e486                	sd	ra,72(sp)
    800025da:	e0a2                	sd	s0,64(sp)
    800025dc:	fc26                	sd	s1,56(sp)
    800025de:	f84a                	sd	s2,48(sp)
    800025e0:	f44e                	sd	s3,40(sp)
    800025e2:	f052                	sd	s4,32(sp)
    800025e4:	ec56                	sd	s5,24(sp)
    800025e6:	e85a                	sd	s6,16(sp)
    800025e8:	e45e                	sd	s7,8(sp)
    800025ea:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800025ec:	00006517          	auipc	a0,0x6
    800025f0:	adc50513          	addi	a0,a0,-1316 # 800080c8 <digits+0x88>
    800025f4:	ffffe097          	auipc	ra,0xffffe
    800025f8:	f94080e7          	jalr	-108(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025fc:	0000f497          	auipc	s1,0xf
    80002600:	b2c48493          	addi	s1,s1,-1236 # 80011128 <proc+0x188>
    80002604:	00015917          	auipc	s2,0x15
    80002608:	12490913          	addi	s2,s2,292 # 80017728 <bcache+0x170>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000260c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000260e:	00006997          	auipc	s3,0x6
    80002612:	c7298993          	addi	s3,s3,-910 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80002616:	00006a97          	auipc	s5,0x6
    8000261a:	c72a8a93          	addi	s5,s5,-910 # 80008288 <digits+0x248>
    printf("\n");
    8000261e:	00006a17          	auipc	s4,0x6
    80002622:	aaaa0a13          	addi	s4,s4,-1366 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002626:	00006b97          	auipc	s7,0x6
    8000262a:	ca2b8b93          	addi	s7,s7,-862 # 800082c8 <states.0>
    8000262e:	a00d                	j	80002650 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002630:	ea86a583          	lw	a1,-344(a3)
    80002634:	8556                	mv	a0,s5
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	f52080e7          	jalr	-174(ra) # 80000588 <printf>
    printf("\n");
    8000263e:	8552                	mv	a0,s4
    80002640:	ffffe097          	auipc	ra,0xffffe
    80002644:	f48080e7          	jalr	-184(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002648:	19848493          	addi	s1,s1,408
    8000264c:	03248163          	beq	s1,s2,8000266e <procdump+0x98>
    if(p->state == UNUSED)
    80002650:	86a6                	mv	a3,s1
    80002652:	e904a783          	lw	a5,-368(s1)
    80002656:	dbed                	beqz	a5,80002648 <procdump+0x72>
      state = "???";
    80002658:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000265a:	fcfb6be3          	bltu	s6,a5,80002630 <procdump+0x5a>
    8000265e:	1782                	slli	a5,a5,0x20
    80002660:	9381                	srli	a5,a5,0x20
    80002662:	078e                	slli	a5,a5,0x3
    80002664:	97de                	add	a5,a5,s7
    80002666:	6390                	ld	a2,0(a5)
    80002668:	f661                	bnez	a2,80002630 <procdump+0x5a>
      state = "???";
    8000266a:	864e                	mv	a2,s3
    8000266c:	b7d1                	j	80002630 <procdump+0x5a>
  }
}
    8000266e:	60a6                	ld	ra,72(sp)
    80002670:	6406                	ld	s0,64(sp)
    80002672:	74e2                	ld	s1,56(sp)
    80002674:	7942                	ld	s2,48(sp)
    80002676:	79a2                	ld	s3,40(sp)
    80002678:	7a02                	ld	s4,32(sp)
    8000267a:	6ae2                	ld	s5,24(sp)
    8000267c:	6b42                	ld	s6,16(sp)
    8000267e:	6ba2                	ld	s7,8(sp)
    80002680:	6161                	addi	sp,sp,80
    80002682:	8082                	ret

0000000080002684 <swtch>:
    80002684:	00153023          	sd	ra,0(a0)
    80002688:	00253423          	sd	sp,8(a0)
    8000268c:	e900                	sd	s0,16(a0)
    8000268e:	ed04                	sd	s1,24(a0)
    80002690:	03253023          	sd	s2,32(a0)
    80002694:	03353423          	sd	s3,40(a0)
    80002698:	03453823          	sd	s4,48(a0)
    8000269c:	03553c23          	sd	s5,56(a0)
    800026a0:	05653023          	sd	s6,64(a0)
    800026a4:	05753423          	sd	s7,72(a0)
    800026a8:	05853823          	sd	s8,80(a0)
    800026ac:	05953c23          	sd	s9,88(a0)
    800026b0:	07a53023          	sd	s10,96(a0)
    800026b4:	07b53423          	sd	s11,104(a0)
    800026b8:	0005b083          	ld	ra,0(a1)
    800026bc:	0085b103          	ld	sp,8(a1)
    800026c0:	6980                	ld	s0,16(a1)
    800026c2:	6d84                	ld	s1,24(a1)
    800026c4:	0205b903          	ld	s2,32(a1)
    800026c8:	0285b983          	ld	s3,40(a1)
    800026cc:	0305ba03          	ld	s4,48(a1)
    800026d0:	0385ba83          	ld	s5,56(a1)
    800026d4:	0405bb03          	ld	s6,64(a1)
    800026d8:	0485bb83          	ld	s7,72(a1)
    800026dc:	0505bc03          	ld	s8,80(a1)
    800026e0:	0585bc83          	ld	s9,88(a1)
    800026e4:	0605bd03          	ld	s10,96(a1)
    800026e8:	0685bd83          	ld	s11,104(a1)
    800026ec:	8082                	ret

00000000800026ee <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800026ee:	1141                	addi	sp,sp,-16
    800026f0:	e406                	sd	ra,8(sp)
    800026f2:	e022                	sd	s0,0(sp)
    800026f4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800026f6:	00006597          	auipc	a1,0x6
    800026fa:	c0258593          	addi	a1,a1,-1022 # 800082f8 <states.0+0x30>
    800026fe:	00015517          	auipc	a0,0x15
    80002702:	ea250513          	addi	a0,a0,-350 # 800175a0 <tickslock>
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	440080e7          	jalr	1088(ra) # 80000b46 <initlock>
}
    8000270e:	60a2                	ld	ra,8(sp)
    80002710:	6402                	ld	s0,0(sp)
    80002712:	0141                	addi	sp,sp,16
    80002714:	8082                	ret

0000000080002716 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002716:	1141                	addi	sp,sp,-16
    80002718:	e422                	sd	s0,8(sp)
    8000271a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000271c:	00003797          	auipc	a5,0x3
    80002720:	51478793          	addi	a5,a5,1300 # 80005c30 <kernelvec>
    80002724:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002728:	6422                	ld	s0,8(sp)
    8000272a:	0141                	addi	sp,sp,16
    8000272c:	8082                	ret

000000008000272e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000272e:	1141                	addi	sp,sp,-16
    80002730:	e406                	sd	ra,8(sp)
    80002732:	e022                	sd	s0,0(sp)
    80002734:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002736:	fffff097          	auipc	ra,0xfffff
    8000273a:	276080e7          	jalr	630(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000273e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002742:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002744:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002748:	00005617          	auipc	a2,0x5
    8000274c:	8b860613          	addi	a2,a2,-1864 # 80007000 <_trampoline>
    80002750:	00005697          	auipc	a3,0x5
    80002754:	8b068693          	addi	a3,a3,-1872 # 80007000 <_trampoline>
    80002758:	8e91                	sub	a3,a3,a2
    8000275a:	040007b7          	lui	a5,0x4000
    8000275e:	17fd                	addi	a5,a5,-1
    80002760:	07b2                	slli	a5,a5,0xc
    80002762:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002764:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002768:	6558                	ld	a4,136(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000276a:	180026f3          	csrr	a3,satp
    8000276e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002770:	6558                	ld	a4,136(a0)
    80002772:	7934                	ld	a3,112(a0)
    80002774:	6585                	lui	a1,0x1
    80002776:	96ae                	add	a3,a3,a1
    80002778:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000277a:	6558                	ld	a4,136(a0)
    8000277c:	00000697          	auipc	a3,0x0
    80002780:	13068693          	addi	a3,a3,304 # 800028ac <usertrap>
    80002784:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002786:	6558                	ld	a4,136(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002788:	8692                	mv	a3,tp
    8000278a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000278c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002790:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002794:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002798:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000279c:	6558                	ld	a4,136(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000279e:	6f18                	ld	a4,24(a4)
    800027a0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800027a4:	6148                	ld	a0,128(a0)
    800027a6:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800027a8:	00005717          	auipc	a4,0x5
    800027ac:	8f470713          	addi	a4,a4,-1804 # 8000709c <userret>
    800027b0:	8f11                	sub	a4,a4,a2
    800027b2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800027b4:	577d                	li	a4,-1
    800027b6:	177e                	slli	a4,a4,0x3f
    800027b8:	8d59                	or	a0,a0,a4
    800027ba:	9782                	jalr	a5
}
    800027bc:	60a2                	ld	ra,8(sp)
    800027be:	6402                	ld	s0,0(sp)
    800027c0:	0141                	addi	sp,sp,16
    800027c2:	8082                	ret

00000000800027c4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800027c4:	1101                	addi	sp,sp,-32
    800027c6:	ec06                	sd	ra,24(sp)
    800027c8:	e822                	sd	s0,16(sp)
    800027ca:	e426                	sd	s1,8(sp)
    800027cc:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800027ce:	00015497          	auipc	s1,0x15
    800027d2:	dd248493          	addi	s1,s1,-558 # 800175a0 <tickslock>
    800027d6:	8526                	mv	a0,s1
    800027d8:	ffffe097          	auipc	ra,0xffffe
    800027dc:	3fe080e7          	jalr	1022(ra) # 80000bd6 <acquire>
  ticks++;
    800027e0:	00006517          	auipc	a0,0x6
    800027e4:	12050513          	addi	a0,a0,288 # 80008900 <ticks>
    800027e8:	411c                	lw	a5,0(a0)
    800027ea:	2785                	addiw	a5,a5,1
    800027ec:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800027ee:	00000097          	auipc	ra,0x0
    800027f2:	940080e7          	jalr	-1728(ra) # 8000212e <wakeup>
  release(&tickslock);
    800027f6:	8526                	mv	a0,s1
    800027f8:	ffffe097          	auipc	ra,0xffffe
    800027fc:	492080e7          	jalr	1170(ra) # 80000c8a <release>
}
    80002800:	60e2                	ld	ra,24(sp)
    80002802:	6442                	ld	s0,16(sp)
    80002804:	64a2                	ld	s1,8(sp)
    80002806:	6105                	addi	sp,sp,32
    80002808:	8082                	ret

000000008000280a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002814:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002818:	00074d63          	bltz	a4,80002832 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    8000281c:	57fd                	li	a5,-1
    8000281e:	17fe                	slli	a5,a5,0x3f
    80002820:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002822:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002824:	06f70363          	beq	a4,a5,8000288a <devintr+0x80>
  }
}
    80002828:	60e2                	ld	ra,24(sp)
    8000282a:	6442                	ld	s0,16(sp)
    8000282c:	64a2                	ld	s1,8(sp)
    8000282e:	6105                	addi	sp,sp,32
    80002830:	8082                	ret
     (scause & 0xff) == 9){
    80002832:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002836:	46a5                	li	a3,9
    80002838:	fed792e3          	bne	a5,a3,8000281c <devintr+0x12>
    int irq = plic_claim();
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	4fc080e7          	jalr	1276(ra) # 80005d38 <plic_claim>
    80002844:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002846:	47a9                	li	a5,10
    80002848:	02f50763          	beq	a0,a5,80002876 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000284c:	4785                	li	a5,1
    8000284e:	02f50963          	beq	a0,a5,80002880 <devintr+0x76>
    return 1;
    80002852:	4505                	li	a0,1
    } else if(irq){
    80002854:	d8f1                	beqz	s1,80002828 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002856:	85a6                	mv	a1,s1
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	aa850513          	addi	a0,a0,-1368 # 80008300 <states.0+0x38>
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	d28080e7          	jalr	-728(ra) # 80000588 <printf>
      plic_complete(irq);
    80002868:	8526                	mv	a0,s1
    8000286a:	00003097          	auipc	ra,0x3
    8000286e:	4f2080e7          	jalr	1266(ra) # 80005d5c <plic_complete>
    return 1;
    80002872:	4505                	li	a0,1
    80002874:	bf55                	j	80002828 <devintr+0x1e>
      uartintr();
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	124080e7          	jalr	292(ra) # 8000099a <uartintr>
    8000287e:	b7ed                	j	80002868 <devintr+0x5e>
      virtio_disk_intr();
    80002880:	00004097          	auipc	ra,0x4
    80002884:	9a8080e7          	jalr	-1624(ra) # 80006228 <virtio_disk_intr>
    80002888:	b7c5                	j	80002868 <devintr+0x5e>
    if(cpuid() == 0){
    8000288a:	fffff097          	auipc	ra,0xfffff
    8000288e:	0f6080e7          	jalr	246(ra) # 80001980 <cpuid>
    80002892:	c901                	beqz	a0,800028a2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002894:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002898:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000289a:	14479073          	csrw	sip,a5
    return 2;
    8000289e:	4509                	li	a0,2
    800028a0:	b761                	j	80002828 <devintr+0x1e>
      clockintr();
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	f22080e7          	jalr	-222(ra) # 800027c4 <clockintr>
    800028aa:	b7ed                	j	80002894 <devintr+0x8a>

00000000800028ac <usertrap>:
{
    800028ac:	1101                	addi	sp,sp,-32
    800028ae:	ec06                	sd	ra,24(sp)
    800028b0:	e822                	sd	s0,16(sp)
    800028b2:	e426                	sd	s1,8(sp)
    800028b4:	e04a                	sd	s2,0(sp)
    800028b6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028b8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800028bc:	1007f793          	andi	a5,a5,256
    800028c0:	e3b1                	bnez	a5,80002904 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028c2:	00003797          	auipc	a5,0x3
    800028c6:	36e78793          	addi	a5,a5,878 # 80005c30 <kernelvec>
    800028ca:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800028ce:	fffff097          	auipc	ra,0xfffff
    800028d2:	0de080e7          	jalr	222(ra) # 800019ac <myproc>
    800028d6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800028d8:	655c                	ld	a5,136(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028da:	14102773          	csrr	a4,sepc
    800028de:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028e0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800028e4:	47a1                	li	a5,8
    800028e6:	02f70763          	beq	a4,a5,80002914 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	f20080e7          	jalr	-224(ra) # 8000280a <devintr>
    800028f2:	892a                	mv	s2,a0
    800028f4:	c951                	beqz	a0,80002988 <usertrap+0xdc>
  if(killed(p))
    800028f6:	8526                	mv	a0,s1
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	a90080e7          	jalr	-1392(ra) # 80002388 <killed>
    80002900:	cd29                	beqz	a0,8000295a <usertrap+0xae>
    80002902:	a099                	j	80002948 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002904:	00006517          	auipc	a0,0x6
    80002908:	a1c50513          	addi	a0,a0,-1508 # 80008320 <states.0+0x58>
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	c32080e7          	jalr	-974(ra) # 8000053e <panic>
    if(killed(p))
    80002914:	00000097          	auipc	ra,0x0
    80002918:	a74080e7          	jalr	-1420(ra) # 80002388 <killed>
    8000291c:	ed21                	bnez	a0,80002974 <usertrap+0xc8>
    p->trapframe->epc += 4;
    8000291e:	64d8                	ld	a4,136(s1)
    80002920:	6f1c                	ld	a5,24(a4)
    80002922:	0791                	addi	a5,a5,4
    80002924:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002926:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000292a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000292e:	10079073          	csrw	sstatus,a5
    syscall();
    80002932:	00000097          	auipc	ra,0x0
    80002936:	2e4080e7          	jalr	740(ra) # 80002c16 <syscall>
  if(killed(p))
    8000293a:	8526                	mv	a0,s1
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	a4c080e7          	jalr	-1460(ra) # 80002388 <killed>
    80002944:	cd11                	beqz	a0,80002960 <usertrap+0xb4>
    80002946:	4901                	li	s2,0
    exit(-1, "killed");
    80002948:	00006597          	auipc	a1,0x6
    8000294c:	a5058593          	addi	a1,a1,-1456 # 80008398 <states.0+0xd0>
    80002950:	557d                	li	a0,-1
    80002952:	00000097          	auipc	ra,0x0
    80002956:	8ac080e7          	jalr	-1876(ra) # 800021fe <exit>
  if(which_dev == 2)
    8000295a:	4789                	li	a5,2
    8000295c:	06f90363          	beq	s2,a5,800029c2 <usertrap+0x116>
  usertrapret();
    80002960:	00000097          	auipc	ra,0x0
    80002964:	dce080e7          	jalr	-562(ra) # 8000272e <usertrapret>
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	64a2                	ld	s1,8(sp)
    8000296e:	6902                	ld	s2,0(sp)
    80002970:	6105                	addi	sp,sp,32
    80002972:	8082                	ret
      exit(-1 , "killed ");
    80002974:	00006597          	auipc	a1,0x6
    80002978:	9cc58593          	addi	a1,a1,-1588 # 80008340 <states.0+0x78>
    8000297c:	557d                	li	a0,-1
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	880080e7          	jalr	-1920(ra) # 800021fe <exit>
    80002986:	bf61                	j	8000291e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002988:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000298c:	5890                	lw	a2,48(s1)
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	9ba50513          	addi	a0,a0,-1606 # 80008348 <states.0+0x80>
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	bf2080e7          	jalr	-1038(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000299e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029a2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029a6:	00006517          	auipc	a0,0x6
    800029aa:	9d250513          	addi	a0,a0,-1582 # 80008378 <states.0+0xb0>
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	bda080e7          	jalr	-1062(ra) # 80000588 <printf>
    setkilled(p);
    800029b6:	8526                	mv	a0,s1
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	9a4080e7          	jalr	-1628(ra) # 8000235c <setkilled>
    800029c0:	bfad                	j	8000293a <usertrap+0x8e>
    yield();
    800029c2:	fffff097          	auipc	ra,0xfffff
    800029c6:	6cc080e7          	jalr	1740(ra) # 8000208e <yield>
    800029ca:	bf59                	j	80002960 <usertrap+0xb4>

00000000800029cc <kerneltrap>:
{
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029da:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029de:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029e2:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029e6:	1004f793          	andi	a5,s1,256
    800029ea:	cb85                	beqz	a5,80002a1a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ec:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029f0:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029f2:	ef85                	bnez	a5,80002a2a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	e16080e7          	jalr	-490(ra) # 8000280a <devintr>
    800029fc:	cd1d                	beqz	a0,80002a3a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800029fe:	4789                	li	a5,2
    80002a00:	06f50a63          	beq	a0,a5,80002a74 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a04:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a08:	10049073          	csrw	sstatus,s1
}
    80002a0c:	70a2                	ld	ra,40(sp)
    80002a0e:	7402                	ld	s0,32(sp)
    80002a10:	64e2                	ld	s1,24(sp)
    80002a12:	6942                	ld	s2,16(sp)
    80002a14:	69a2                	ld	s3,8(sp)
    80002a16:	6145                	addi	sp,sp,48
    80002a18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a1a:	00006517          	auipc	a0,0x6
    80002a1e:	98650513          	addi	a0,a0,-1658 # 800083a0 <states.0+0xd8>
    80002a22:	ffffe097          	auipc	ra,0xffffe
    80002a26:	b1c080e7          	jalr	-1252(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	99e50513          	addi	a0,a0,-1634 # 800083c8 <states.0+0x100>
    80002a32:	ffffe097          	auipc	ra,0xffffe
    80002a36:	b0c080e7          	jalr	-1268(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002a3a:	85ce                	mv	a1,s3
    80002a3c:	00006517          	auipc	a0,0x6
    80002a40:	9ac50513          	addi	a0,a0,-1620 # 800083e8 <states.0+0x120>
    80002a44:	ffffe097          	auipc	ra,0xffffe
    80002a48:	b44080e7          	jalr	-1212(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a50:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a54:	00006517          	auipc	a0,0x6
    80002a58:	9a450513          	addi	a0,a0,-1628 # 800083f8 <states.0+0x130>
    80002a5c:	ffffe097          	auipc	ra,0xffffe
    80002a60:	b2c080e7          	jalr	-1236(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002a64:	00006517          	auipc	a0,0x6
    80002a68:	9ac50513          	addi	a0,a0,-1620 # 80008410 <states.0+0x148>
    80002a6c:	ffffe097          	auipc	ra,0xffffe
    80002a70:	ad2080e7          	jalr	-1326(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a74:	fffff097          	auipc	ra,0xfffff
    80002a78:	f38080e7          	jalr	-200(ra) # 800019ac <myproc>
    80002a7c:	d541                	beqz	a0,80002a04 <kerneltrap+0x38>
    80002a7e:	fffff097          	auipc	ra,0xfffff
    80002a82:	f2e080e7          	jalr	-210(ra) # 800019ac <myproc>
    80002a86:	4d18                	lw	a4,24(a0)
    80002a88:	4791                	li	a5,4
    80002a8a:	f6f71de3          	bne	a4,a5,80002a04 <kerneltrap+0x38>
    yield();
    80002a8e:	fffff097          	auipc	ra,0xfffff
    80002a92:	600080e7          	jalr	1536(ra) # 8000208e <yield>
    80002a96:	b7bd                	j	80002a04 <kerneltrap+0x38>

0000000080002a98 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a98:	1101                	addi	sp,sp,-32
    80002a9a:	ec06                	sd	ra,24(sp)
    80002a9c:	e822                	sd	s0,16(sp)
    80002a9e:	e426                	sd	s1,8(sp)
    80002aa0:	1000                	addi	s0,sp,32
    80002aa2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002aa4:	fffff097          	auipc	ra,0xfffff
    80002aa8:	f08080e7          	jalr	-248(ra) # 800019ac <myproc>
  switch (n) {
    80002aac:	4795                	li	a5,5
    80002aae:	0497e163          	bltu	a5,s1,80002af0 <argraw+0x58>
    80002ab2:	048a                	slli	s1,s1,0x2
    80002ab4:	00006717          	auipc	a4,0x6
    80002ab8:	99470713          	addi	a4,a4,-1644 # 80008448 <states.0+0x180>
    80002abc:	94ba                	add	s1,s1,a4
    80002abe:	409c                	lw	a5,0(s1)
    80002ac0:	97ba                	add	a5,a5,a4
    80002ac2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ac4:	655c                	ld	a5,136(a0)
    80002ac6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6105                	addi	sp,sp,32
    80002ad0:	8082                	ret
    return p->trapframe->a1;
    80002ad2:	655c                	ld	a5,136(a0)
    80002ad4:	7fa8                	ld	a0,120(a5)
    80002ad6:	bfcd                	j	80002ac8 <argraw+0x30>
    return p->trapframe->a2;
    80002ad8:	655c                	ld	a5,136(a0)
    80002ada:	63c8                	ld	a0,128(a5)
    80002adc:	b7f5                	j	80002ac8 <argraw+0x30>
    return p->trapframe->a3;
    80002ade:	655c                	ld	a5,136(a0)
    80002ae0:	67c8                	ld	a0,136(a5)
    80002ae2:	b7dd                	j	80002ac8 <argraw+0x30>
    return p->trapframe->a4;
    80002ae4:	655c                	ld	a5,136(a0)
    80002ae6:	6bc8                	ld	a0,144(a5)
    80002ae8:	b7c5                	j	80002ac8 <argraw+0x30>
    return p->trapframe->a5;
    80002aea:	655c                	ld	a5,136(a0)
    80002aec:	6fc8                	ld	a0,152(a5)
    80002aee:	bfe9                	j	80002ac8 <argraw+0x30>
  panic("argraw");
    80002af0:	00006517          	auipc	a0,0x6
    80002af4:	93050513          	addi	a0,a0,-1744 # 80008420 <states.0+0x158>
    80002af8:	ffffe097          	auipc	ra,0xffffe
    80002afc:	a46080e7          	jalr	-1466(ra) # 8000053e <panic>

0000000080002b00 <fetchaddr>:
{
    80002b00:	1101                	addi	sp,sp,-32
    80002b02:	ec06                	sd	ra,24(sp)
    80002b04:	e822                	sd	s0,16(sp)
    80002b06:	e426                	sd	s1,8(sp)
    80002b08:	e04a                	sd	s2,0(sp)
    80002b0a:	1000                	addi	s0,sp,32
    80002b0c:	84aa                	mv	s1,a0
    80002b0e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b10:	fffff097          	auipc	ra,0xfffff
    80002b14:	e9c080e7          	jalr	-356(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b18:	7d3c                	ld	a5,120(a0)
    80002b1a:	02f4f863          	bgeu	s1,a5,80002b4a <fetchaddr+0x4a>
    80002b1e:	00848713          	addi	a4,s1,8
    80002b22:	02e7e663          	bltu	a5,a4,80002b4e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b26:	46a1                	li	a3,8
    80002b28:	8626                	mv	a2,s1
    80002b2a:	85ca                	mv	a1,s2
    80002b2c:	6148                	ld	a0,128(a0)
    80002b2e:	fffff097          	auipc	ra,0xfffff
    80002b32:	bc6080e7          	jalr	-1082(ra) # 800016f4 <copyin>
    80002b36:	00a03533          	snez	a0,a0
    80002b3a:	40a00533          	neg	a0,a0
}
    80002b3e:	60e2                	ld	ra,24(sp)
    80002b40:	6442                	ld	s0,16(sp)
    80002b42:	64a2                	ld	s1,8(sp)
    80002b44:	6902                	ld	s2,0(sp)
    80002b46:	6105                	addi	sp,sp,32
    80002b48:	8082                	ret
    return -1;
    80002b4a:	557d                	li	a0,-1
    80002b4c:	bfcd                	j	80002b3e <fetchaddr+0x3e>
    80002b4e:	557d                	li	a0,-1
    80002b50:	b7fd                	j	80002b3e <fetchaddr+0x3e>

0000000080002b52 <fetchstr>:
{
    80002b52:	7179                	addi	sp,sp,-48
    80002b54:	f406                	sd	ra,40(sp)
    80002b56:	f022                	sd	s0,32(sp)
    80002b58:	ec26                	sd	s1,24(sp)
    80002b5a:	e84a                	sd	s2,16(sp)
    80002b5c:	e44e                	sd	s3,8(sp)
    80002b5e:	1800                	addi	s0,sp,48
    80002b60:	892a                	mv	s2,a0
    80002b62:	84ae                	mv	s1,a1
    80002b64:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b66:	fffff097          	auipc	ra,0xfffff
    80002b6a:	e46080e7          	jalr	-442(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b6e:	86ce                	mv	a3,s3
    80002b70:	864a                	mv	a2,s2
    80002b72:	85a6                	mv	a1,s1
    80002b74:	6148                	ld	a0,128(a0)
    80002b76:	fffff097          	auipc	ra,0xfffff
    80002b7a:	c0c080e7          	jalr	-1012(ra) # 80001782 <copyinstr>
    80002b7e:	00054e63          	bltz	a0,80002b9a <fetchstr+0x48>
  return strlen(buf);
    80002b82:	8526                	mv	a0,s1
    80002b84:	ffffe097          	auipc	ra,0xffffe
    80002b88:	2ca080e7          	jalr	714(ra) # 80000e4e <strlen>
}
    80002b8c:	70a2                	ld	ra,40(sp)
    80002b8e:	7402                	ld	s0,32(sp)
    80002b90:	64e2                	ld	s1,24(sp)
    80002b92:	6942                	ld	s2,16(sp)
    80002b94:	69a2                	ld	s3,8(sp)
    80002b96:	6145                	addi	sp,sp,48
    80002b98:	8082                	ret
    return -1;
    80002b9a:	557d                	li	a0,-1
    80002b9c:	bfc5                	j	80002b8c <fetchstr+0x3a>

0000000080002b9e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	1000                	addi	s0,sp,32
    80002ba8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002baa:	00000097          	auipc	ra,0x0
    80002bae:	eee080e7          	jalr	-274(ra) # 80002a98 <argraw>
    80002bb2:	c088                	sw	a0,0(s1)
}
    80002bb4:	60e2                	ld	ra,24(sp)
    80002bb6:	6442                	ld	s0,16(sp)
    80002bb8:	64a2                	ld	s1,8(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret

0000000080002bbe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bbe:	1101                	addi	sp,sp,-32
    80002bc0:	ec06                	sd	ra,24(sp)
    80002bc2:	e822                	sd	s0,16(sp)
    80002bc4:	e426                	sd	s1,8(sp)
    80002bc6:	1000                	addi	s0,sp,32
    80002bc8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bca:	00000097          	auipc	ra,0x0
    80002bce:	ece080e7          	jalr	-306(ra) # 80002a98 <argraw>
    80002bd2:	e088                	sd	a0,0(s1)
}
    80002bd4:	60e2                	ld	ra,24(sp)
    80002bd6:	6442                	ld	s0,16(sp)
    80002bd8:	64a2                	ld	s1,8(sp)
    80002bda:	6105                	addi	sp,sp,32
    80002bdc:	8082                	ret

0000000080002bde <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bde:	7179                	addi	sp,sp,-48
    80002be0:	f406                	sd	ra,40(sp)
    80002be2:	f022                	sd	s0,32(sp)
    80002be4:	ec26                	sd	s1,24(sp)
    80002be6:	e84a                	sd	s2,16(sp)
    80002be8:	1800                	addi	s0,sp,48
    80002bea:	84ae                	mv	s1,a1
    80002bec:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bee:	fd840593          	addi	a1,s0,-40
    80002bf2:	00000097          	auipc	ra,0x0
    80002bf6:	fcc080e7          	jalr	-52(ra) # 80002bbe <argaddr>
  return fetchstr(addr, buf, max);
    80002bfa:	864a                	mv	a2,s2
    80002bfc:	85a6                	mv	a1,s1
    80002bfe:	fd843503          	ld	a0,-40(s0)
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	f50080e7          	jalr	-176(ra) # 80002b52 <fetchstr>
}
    80002c0a:	70a2                	ld	ra,40(sp)
    80002c0c:	7402                	ld	s0,32(sp)
    80002c0e:	64e2                	ld	s1,24(sp)
    80002c10:	6942                	ld	s2,16(sp)
    80002c12:	6145                	addi	sp,sp,48
    80002c14:	8082                	ret

0000000080002c16 <syscall>:

};

void
syscall(void)
{
    80002c16:	1101                	addi	sp,sp,-32
    80002c18:	ec06                	sd	ra,24(sp)
    80002c1a:	e822                	sd	s0,16(sp)
    80002c1c:	e426                	sd	s1,8(sp)
    80002c1e:	e04a                	sd	s2,0(sp)
    80002c20:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c22:	fffff097          	auipc	ra,0xfffff
    80002c26:	d8a080e7          	jalr	-630(ra) # 800019ac <myproc>
    80002c2a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c2c:	08853903          	ld	s2,136(a0)
    80002c30:	0a893783          	ld	a5,168(s2)
    80002c34:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c38:	37fd                	addiw	a5,a5,-1
    80002c3a:	4755                	li	a4,21
    80002c3c:	00f76f63          	bltu	a4,a5,80002c5a <syscall+0x44>
    80002c40:	00369713          	slli	a4,a3,0x3
    80002c44:	00006797          	auipc	a5,0x6
    80002c48:	81c78793          	addi	a5,a5,-2020 # 80008460 <syscalls>
    80002c4c:	97ba                	add	a5,a5,a4
    80002c4e:	639c                	ld	a5,0(a5)
    80002c50:	c789                	beqz	a5,80002c5a <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c52:	9782                	jalr	a5
    80002c54:	06a93823          	sd	a0,112(s2)
    80002c58:	a839                	j	80002c76 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c5a:	18848613          	addi	a2,s1,392
    80002c5e:	588c                	lw	a1,48(s1)
    80002c60:	00005517          	auipc	a0,0x5
    80002c64:	7c850513          	addi	a0,a0,1992 # 80008428 <states.0+0x160>
    80002c68:	ffffe097          	auipc	ra,0xffffe
    80002c6c:	920080e7          	jalr	-1760(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c70:	64dc                	ld	a5,136(s1)
    80002c72:	577d                	li	a4,-1
    80002c74:	fbb8                	sd	a4,112(a5)
  }
}
    80002c76:	60e2                	ld	ra,24(sp)
    80002c78:	6442                	ld	s0,16(sp)
    80002c7a:	64a2                	ld	s1,8(sp)
    80002c7c:	6902                	ld	s2,0(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c82:	7139                	addi	sp,sp,-64
    80002c84:	fc06                	sd	ra,56(sp)
    80002c86:	f822                	sd	s0,48(sp)
    80002c88:	0080                	addi	s0,sp,64
  int n;
  char exit_msg[32];
  argint(0, &n);
    80002c8a:	fec40593          	addi	a1,s0,-20
    80002c8e:	4501                	li	a0,0
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	f0e080e7          	jalr	-242(ra) # 80002b9e <argint>
  argstr(1, exit_msg, MAXARG);
    80002c98:	02000613          	li	a2,32
    80002c9c:	fc840593          	addi	a1,s0,-56
    80002ca0:	4505                	li	a0,1
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	f3c080e7          	jalr	-196(ra) # 80002bde <argstr>
  exit(n,exit_msg);
    80002caa:	fc840593          	addi	a1,s0,-56
    80002cae:	fec42503          	lw	a0,-20(s0)
    80002cb2:	fffff097          	auipc	ra,0xfffff
    80002cb6:	54c080e7          	jalr	1356(ra) # 800021fe <exit>
  return 0;  // not reached
}
    80002cba:	4501                	li	a0,0
    80002cbc:	70e2                	ld	ra,56(sp)
    80002cbe:	7442                	ld	s0,48(sp)
    80002cc0:	6121                	addi	sp,sp,64
    80002cc2:	8082                	ret

0000000080002cc4 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002cc4:	1141                	addi	sp,sp,-16
    80002cc6:	e406                	sd	ra,8(sp)
    80002cc8:	e022                	sd	s0,0(sp)
    80002cca:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002ccc:	fffff097          	auipc	ra,0xfffff
    80002cd0:	ce0080e7          	jalr	-800(ra) # 800019ac <myproc>
}
    80002cd4:	5908                	lw	a0,48(a0)
    80002cd6:	60a2                	ld	ra,8(sp)
    80002cd8:	6402                	ld	s0,0(sp)
    80002cda:	0141                	addi	sp,sp,16
    80002cdc:	8082                	ret

0000000080002cde <sys_fork>:

uint64
sys_fork(void)
{
    80002cde:	1141                	addi	sp,sp,-16
    80002ce0:	e406                	sd	ra,8(sp)
    80002ce2:	e022                	sd	s0,0(sp)
    80002ce4:	0800                	addi	s0,sp,16
  return fork();
    80002ce6:	fffff097          	auipc	ra,0xfffff
    80002cea:	0f2080e7          	jalr	242(ra) # 80001dd8 <fork>
}
    80002cee:	60a2                	ld	ra,8(sp)
    80002cf0:	6402                	ld	s0,0(sp)
    80002cf2:	0141                	addi	sp,sp,16
    80002cf4:	8082                	ret

0000000080002cf6 <sys_wait>:

uint64
sys_wait(void)
{
    80002cf6:	1101                	addi	sp,sp,-32
    80002cf8:	ec06                	sd	ra,24(sp)
    80002cfa:	e822                	sd	s0,16(sp)
    80002cfc:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 exit_msg;
  
  argaddr(0, &p);
    80002cfe:	fe840593          	addi	a1,s0,-24
    80002d02:	4501                	li	a0,0
    80002d04:	00000097          	auipc	ra,0x0
    80002d08:	eba080e7          	jalr	-326(ra) # 80002bbe <argaddr>
  argaddr(1, &exit_msg);
    80002d0c:	fe040593          	addi	a1,s0,-32
    80002d10:	4505                	li	a0,1
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	eac080e7          	jalr	-340(ra) # 80002bbe <argaddr>
  return wait(p,exit_msg);
    80002d1a:	fe043583          	ld	a1,-32(s0)
    80002d1e:	fe843503          	ld	a0,-24(s0)
    80002d22:	fffff097          	auipc	ra,0xfffff
    80002d26:	698080e7          	jalr	1688(ra) # 800023ba <wait>
}
    80002d2a:	60e2                	ld	ra,24(sp)
    80002d2c:	6442                	ld	s0,16(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret

0000000080002d32 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d32:	7179                	addi	sp,sp,-48
    80002d34:	f406                	sd	ra,40(sp)
    80002d36:	f022                	sd	s0,32(sp)
    80002d38:	ec26                	sd	s1,24(sp)
    80002d3a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002d3c:	fdc40593          	addi	a1,s0,-36
    80002d40:	4501                	li	a0,0
    80002d42:	00000097          	auipc	ra,0x0
    80002d46:	e5c080e7          	jalr	-420(ra) # 80002b9e <argint>
  addr = myproc()->sz;
    80002d4a:	fffff097          	auipc	ra,0xfffff
    80002d4e:	c62080e7          	jalr	-926(ra) # 800019ac <myproc>
    80002d52:	7d24                	ld	s1,120(a0)
  if(growproc(n) < 0)
    80002d54:	fdc42503          	lw	a0,-36(s0)
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	024080e7          	jalr	36(ra) # 80001d7c <growproc>
    80002d60:	00054863          	bltz	a0,80002d70 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002d64:	8526                	mv	a0,s1
    80002d66:	70a2                	ld	ra,40(sp)
    80002d68:	7402                	ld	s0,32(sp)
    80002d6a:	64e2                	ld	s1,24(sp)
    80002d6c:	6145                	addi	sp,sp,48
    80002d6e:	8082                	ret
    return -1;
    80002d70:	54fd                	li	s1,-1
    80002d72:	bfcd                	j	80002d64 <sys_sbrk+0x32>

0000000080002d74 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d74:	7139                	addi	sp,sp,-64
    80002d76:	fc06                	sd	ra,56(sp)
    80002d78:	f822                	sd	s0,48(sp)
    80002d7a:	f426                	sd	s1,40(sp)
    80002d7c:	f04a                	sd	s2,32(sp)
    80002d7e:	ec4e                	sd	s3,24(sp)
    80002d80:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d82:	fcc40593          	addi	a1,s0,-52
    80002d86:	4501                	li	a0,0
    80002d88:	00000097          	auipc	ra,0x0
    80002d8c:	e16080e7          	jalr	-490(ra) # 80002b9e <argint>
  acquire(&tickslock);
    80002d90:	00015517          	auipc	a0,0x15
    80002d94:	81050513          	addi	a0,a0,-2032 # 800175a0 <tickslock>
    80002d98:	ffffe097          	auipc	ra,0xffffe
    80002d9c:	e3e080e7          	jalr	-450(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002da0:	00006917          	auipc	s2,0x6
    80002da4:	b6092903          	lw	s2,-1184(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002da8:	fcc42783          	lw	a5,-52(s0)
    80002dac:	cf9d                	beqz	a5,80002dea <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002dae:	00014997          	auipc	s3,0x14
    80002db2:	7f298993          	addi	s3,s3,2034 # 800175a0 <tickslock>
    80002db6:	00006497          	auipc	s1,0x6
    80002dba:	b4a48493          	addi	s1,s1,-1206 # 80008900 <ticks>
    if(killed(myproc())){
    80002dbe:	fffff097          	auipc	ra,0xfffff
    80002dc2:	bee080e7          	jalr	-1042(ra) # 800019ac <myproc>
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	5c2080e7          	jalr	1474(ra) # 80002388 <killed>
    80002dce:	ed15                	bnez	a0,80002e0a <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002dd0:	85ce                	mv	a1,s3
    80002dd2:	8526                	mv	a0,s1
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	2f6080e7          	jalr	758(ra) # 800020ca <sleep>
  while(ticks - ticks0 < n){
    80002ddc:	409c                	lw	a5,0(s1)
    80002dde:	412787bb          	subw	a5,a5,s2
    80002de2:	fcc42703          	lw	a4,-52(s0)
    80002de6:	fce7ece3          	bltu	a5,a4,80002dbe <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002dea:	00014517          	auipc	a0,0x14
    80002dee:	7b650513          	addi	a0,a0,1974 # 800175a0 <tickslock>
    80002df2:	ffffe097          	auipc	ra,0xffffe
    80002df6:	e98080e7          	jalr	-360(ra) # 80000c8a <release>
  return 0;
    80002dfa:	4501                	li	a0,0
}
    80002dfc:	70e2                	ld	ra,56(sp)
    80002dfe:	7442                	ld	s0,48(sp)
    80002e00:	74a2                	ld	s1,40(sp)
    80002e02:	7902                	ld	s2,32(sp)
    80002e04:	69e2                	ld	s3,24(sp)
    80002e06:	6121                	addi	sp,sp,64
    80002e08:	8082                	ret
      release(&tickslock);
    80002e0a:	00014517          	auipc	a0,0x14
    80002e0e:	79650513          	addi	a0,a0,1942 # 800175a0 <tickslock>
    80002e12:	ffffe097          	auipc	ra,0xffffe
    80002e16:	e78080e7          	jalr	-392(ra) # 80000c8a <release>
      return -1;
    80002e1a:	557d                	li	a0,-1
    80002e1c:	b7c5                	j	80002dfc <sys_sleep+0x88>

0000000080002e1e <sys_kill>:

uint64
sys_kill(void)
{
    80002e1e:	1101                	addi	sp,sp,-32
    80002e20:	ec06                	sd	ra,24(sp)
    80002e22:	e822                	sd	s0,16(sp)
    80002e24:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002e26:	fec40593          	addi	a1,s0,-20
    80002e2a:	4501                	li	a0,0
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	d72080e7          	jalr	-654(ra) # 80002b9e <argint>
  return kill(pid);
    80002e34:	fec42503          	lw	a0,-20(s0)
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	4b2080e7          	jalr	1202(ra) # 800022ea <kill>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret

0000000080002e48 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e48:	1101                	addi	sp,sp,-32
    80002e4a:	ec06                	sd	ra,24(sp)
    80002e4c:	e822                	sd	s0,16(sp)
    80002e4e:	e426                	sd	s1,8(sp)
    80002e50:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e52:	00014517          	auipc	a0,0x14
    80002e56:	74e50513          	addi	a0,a0,1870 # 800175a0 <tickslock>
    80002e5a:	ffffe097          	auipc	ra,0xffffe
    80002e5e:	d7c080e7          	jalr	-644(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002e62:	00006497          	auipc	s1,0x6
    80002e66:	a9e4a483          	lw	s1,-1378(s1) # 80008900 <ticks>
  release(&tickslock);
    80002e6a:	00014517          	auipc	a0,0x14
    80002e6e:	73650513          	addi	a0,a0,1846 # 800175a0 <tickslock>
    80002e72:	ffffe097          	auipc	ra,0xffffe
    80002e76:	e18080e7          	jalr	-488(ra) # 80000c8a <release>
  return xticks;
}
    80002e7a:	02049513          	slli	a0,s1,0x20
    80002e7e:	9101                	srli	a0,a0,0x20
    80002e80:	60e2                	ld	ra,24(sp)
    80002e82:	6442                	ld	s0,16(sp)
    80002e84:	64a2                	ld	s1,8(sp)
    80002e86:	6105                	addi	sp,sp,32
    80002e88:	8082                	ret

0000000080002e8a <sys_memsize>:

uint64
sys_memsize(void)
{
    80002e8a:	1141                	addi	sp,sp,-16
    80002e8c:	e406                	sd	ra,8(sp)
    80002e8e:	e022                	sd	s0,0(sp)
    80002e90:	0800                	addi	s0,sp,16
  //return myproc()->sz;
  return myproc()->accumulator;
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	b1a080e7          	jalr	-1254(ra) # 800019ac <myproc>
}
    80002e9a:	6d28                	ld	a0,88(a0)
    80002e9c:	60a2                	ld	ra,8(sp)
    80002e9e:	6402                	ld	s0,0(sp)
    80002ea0:	0141                	addi	sp,sp,16
    80002ea2:	8082                	ret

0000000080002ea4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ea4:	7179                	addi	sp,sp,-48
    80002ea6:	f406                	sd	ra,40(sp)
    80002ea8:	f022                	sd	s0,32(sp)
    80002eaa:	ec26                	sd	s1,24(sp)
    80002eac:	e84a                	sd	s2,16(sp)
    80002eae:	e44e                	sd	s3,8(sp)
    80002eb0:	e052                	sd	s4,0(sp)
    80002eb2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002eb4:	00005597          	auipc	a1,0x5
    80002eb8:	66458593          	addi	a1,a1,1636 # 80008518 <syscalls+0xb8>
    80002ebc:	00014517          	auipc	a0,0x14
    80002ec0:	6fc50513          	addi	a0,a0,1788 # 800175b8 <bcache>
    80002ec4:	ffffe097          	auipc	ra,0xffffe
    80002ec8:	c82080e7          	jalr	-894(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ecc:	0001c797          	auipc	a5,0x1c
    80002ed0:	6ec78793          	addi	a5,a5,1772 # 8001f5b8 <bcache+0x8000>
    80002ed4:	0001d717          	auipc	a4,0x1d
    80002ed8:	94c70713          	addi	a4,a4,-1716 # 8001f820 <bcache+0x8268>
    80002edc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ee0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ee4:	00014497          	auipc	s1,0x14
    80002ee8:	6ec48493          	addi	s1,s1,1772 # 800175d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002eec:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002eee:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ef0:	00005a17          	auipc	s4,0x5
    80002ef4:	630a0a13          	addi	s4,s4,1584 # 80008520 <syscalls+0xc0>
    b->next = bcache.head.next;
    80002ef8:	2b893783          	ld	a5,696(s2)
    80002efc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002efe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f02:	85d2                	mv	a1,s4
    80002f04:	01048513          	addi	a0,s1,16
    80002f08:	00001097          	auipc	ra,0x1
    80002f0c:	4c4080e7          	jalr	1220(ra) # 800043cc <initsleeplock>
    bcache.head.next->prev = b;
    80002f10:	2b893783          	ld	a5,696(s2)
    80002f14:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f16:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f1a:	45848493          	addi	s1,s1,1112
    80002f1e:	fd349de3          	bne	s1,s3,80002ef8 <binit+0x54>
  }
}
    80002f22:	70a2                	ld	ra,40(sp)
    80002f24:	7402                	ld	s0,32(sp)
    80002f26:	64e2                	ld	s1,24(sp)
    80002f28:	6942                	ld	s2,16(sp)
    80002f2a:	69a2                	ld	s3,8(sp)
    80002f2c:	6a02                	ld	s4,0(sp)
    80002f2e:	6145                	addi	sp,sp,48
    80002f30:	8082                	ret

0000000080002f32 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f32:	7179                	addi	sp,sp,-48
    80002f34:	f406                	sd	ra,40(sp)
    80002f36:	f022                	sd	s0,32(sp)
    80002f38:	ec26                	sd	s1,24(sp)
    80002f3a:	e84a                	sd	s2,16(sp)
    80002f3c:	e44e                	sd	s3,8(sp)
    80002f3e:	1800                	addi	s0,sp,48
    80002f40:	892a                	mv	s2,a0
    80002f42:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f44:	00014517          	auipc	a0,0x14
    80002f48:	67450513          	addi	a0,a0,1652 # 800175b8 <bcache>
    80002f4c:	ffffe097          	auipc	ra,0xffffe
    80002f50:	c8a080e7          	jalr	-886(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f54:	0001d497          	auipc	s1,0x1d
    80002f58:	91c4b483          	ld	s1,-1764(s1) # 8001f870 <bcache+0x82b8>
    80002f5c:	0001d797          	auipc	a5,0x1d
    80002f60:	8c478793          	addi	a5,a5,-1852 # 8001f820 <bcache+0x8268>
    80002f64:	02f48f63          	beq	s1,a5,80002fa2 <bread+0x70>
    80002f68:	873e                	mv	a4,a5
    80002f6a:	a021                	j	80002f72 <bread+0x40>
    80002f6c:	68a4                	ld	s1,80(s1)
    80002f6e:	02e48a63          	beq	s1,a4,80002fa2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f72:	449c                	lw	a5,8(s1)
    80002f74:	ff279ce3          	bne	a5,s2,80002f6c <bread+0x3a>
    80002f78:	44dc                	lw	a5,12(s1)
    80002f7a:	ff3799e3          	bne	a5,s3,80002f6c <bread+0x3a>
      b->refcnt++;
    80002f7e:	40bc                	lw	a5,64(s1)
    80002f80:	2785                	addiw	a5,a5,1
    80002f82:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f84:	00014517          	auipc	a0,0x14
    80002f88:	63450513          	addi	a0,a0,1588 # 800175b8 <bcache>
    80002f8c:	ffffe097          	auipc	ra,0xffffe
    80002f90:	cfe080e7          	jalr	-770(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002f94:	01048513          	addi	a0,s1,16
    80002f98:	00001097          	auipc	ra,0x1
    80002f9c:	46e080e7          	jalr	1134(ra) # 80004406 <acquiresleep>
      return b;
    80002fa0:	a8b9                	j	80002ffe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fa2:	0001d497          	auipc	s1,0x1d
    80002fa6:	8c64b483          	ld	s1,-1850(s1) # 8001f868 <bcache+0x82b0>
    80002faa:	0001d797          	auipc	a5,0x1d
    80002fae:	87678793          	addi	a5,a5,-1930 # 8001f820 <bcache+0x8268>
    80002fb2:	00f48863          	beq	s1,a5,80002fc2 <bread+0x90>
    80002fb6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fb8:	40bc                	lw	a5,64(s1)
    80002fba:	cf81                	beqz	a5,80002fd2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fbc:	64a4                	ld	s1,72(s1)
    80002fbe:	fee49de3          	bne	s1,a4,80002fb8 <bread+0x86>
  panic("bget: no buffers");
    80002fc2:	00005517          	auipc	a0,0x5
    80002fc6:	56650513          	addi	a0,a0,1382 # 80008528 <syscalls+0xc8>
    80002fca:	ffffd097          	auipc	ra,0xffffd
    80002fce:	574080e7          	jalr	1396(ra) # 8000053e <panic>
      b->dev = dev;
    80002fd2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fd6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fda:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fde:	4785                	li	a5,1
    80002fe0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fe2:	00014517          	auipc	a0,0x14
    80002fe6:	5d650513          	addi	a0,a0,1494 # 800175b8 <bcache>
    80002fea:	ffffe097          	auipc	ra,0xffffe
    80002fee:	ca0080e7          	jalr	-864(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    80002ff2:	01048513          	addi	a0,s1,16
    80002ff6:	00001097          	auipc	ra,0x1
    80002ffa:	410080e7          	jalr	1040(ra) # 80004406 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ffe:	409c                	lw	a5,0(s1)
    80003000:	cb89                	beqz	a5,80003012 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003002:	8526                	mv	a0,s1
    80003004:	70a2                	ld	ra,40(sp)
    80003006:	7402                	ld	s0,32(sp)
    80003008:	64e2                	ld	s1,24(sp)
    8000300a:	6942                	ld	s2,16(sp)
    8000300c:	69a2                	ld	s3,8(sp)
    8000300e:	6145                	addi	sp,sp,48
    80003010:	8082                	ret
    virtio_disk_rw(b, 0);
    80003012:	4581                	li	a1,0
    80003014:	8526                	mv	a0,s1
    80003016:	00003097          	auipc	ra,0x3
    8000301a:	fde080e7          	jalr	-34(ra) # 80005ff4 <virtio_disk_rw>
    b->valid = 1;
    8000301e:	4785                	li	a5,1
    80003020:	c09c                	sw	a5,0(s1)
  return b;
    80003022:	b7c5                	j	80003002 <bread+0xd0>

0000000080003024 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	1000                	addi	s0,sp,32
    8000302e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003030:	0541                	addi	a0,a0,16
    80003032:	00001097          	auipc	ra,0x1
    80003036:	46e080e7          	jalr	1134(ra) # 800044a0 <holdingsleep>
    8000303a:	cd01                	beqz	a0,80003052 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000303c:	4585                	li	a1,1
    8000303e:	8526                	mv	a0,s1
    80003040:	00003097          	auipc	ra,0x3
    80003044:	fb4080e7          	jalr	-76(ra) # 80005ff4 <virtio_disk_rw>
}
    80003048:	60e2                	ld	ra,24(sp)
    8000304a:	6442                	ld	s0,16(sp)
    8000304c:	64a2                	ld	s1,8(sp)
    8000304e:	6105                	addi	sp,sp,32
    80003050:	8082                	ret
    panic("bwrite");
    80003052:	00005517          	auipc	a0,0x5
    80003056:	4ee50513          	addi	a0,a0,1262 # 80008540 <syscalls+0xe0>
    8000305a:	ffffd097          	auipc	ra,0xffffd
    8000305e:	4e4080e7          	jalr	1252(ra) # 8000053e <panic>

0000000080003062 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003062:	1101                	addi	sp,sp,-32
    80003064:	ec06                	sd	ra,24(sp)
    80003066:	e822                	sd	s0,16(sp)
    80003068:	e426                	sd	s1,8(sp)
    8000306a:	e04a                	sd	s2,0(sp)
    8000306c:	1000                	addi	s0,sp,32
    8000306e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003070:	01050913          	addi	s2,a0,16
    80003074:	854a                	mv	a0,s2
    80003076:	00001097          	auipc	ra,0x1
    8000307a:	42a080e7          	jalr	1066(ra) # 800044a0 <holdingsleep>
    8000307e:	c92d                	beqz	a0,800030f0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003080:	854a                	mv	a0,s2
    80003082:	00001097          	auipc	ra,0x1
    80003086:	3da080e7          	jalr	986(ra) # 8000445c <releasesleep>

  acquire(&bcache.lock);
    8000308a:	00014517          	auipc	a0,0x14
    8000308e:	52e50513          	addi	a0,a0,1326 # 800175b8 <bcache>
    80003092:	ffffe097          	auipc	ra,0xffffe
    80003096:	b44080e7          	jalr	-1212(ra) # 80000bd6 <acquire>
  b->refcnt--;
    8000309a:	40bc                	lw	a5,64(s1)
    8000309c:	37fd                	addiw	a5,a5,-1
    8000309e:	0007871b          	sext.w	a4,a5
    800030a2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030a4:	eb05                	bnez	a4,800030d4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030a6:	68bc                	ld	a5,80(s1)
    800030a8:	64b8                	ld	a4,72(s1)
    800030aa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800030ac:	64bc                	ld	a5,72(s1)
    800030ae:	68b8                	ld	a4,80(s1)
    800030b0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030b2:	0001c797          	auipc	a5,0x1c
    800030b6:	50678793          	addi	a5,a5,1286 # 8001f5b8 <bcache+0x8000>
    800030ba:	2b87b703          	ld	a4,696(a5)
    800030be:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030c0:	0001c717          	auipc	a4,0x1c
    800030c4:	76070713          	addi	a4,a4,1888 # 8001f820 <bcache+0x8268>
    800030c8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030ca:	2b87b703          	ld	a4,696(a5)
    800030ce:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030d0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030d4:	00014517          	auipc	a0,0x14
    800030d8:	4e450513          	addi	a0,a0,1252 # 800175b8 <bcache>
    800030dc:	ffffe097          	auipc	ra,0xffffe
    800030e0:	bae080e7          	jalr	-1106(ra) # 80000c8a <release>
}
    800030e4:	60e2                	ld	ra,24(sp)
    800030e6:	6442                	ld	s0,16(sp)
    800030e8:	64a2                	ld	s1,8(sp)
    800030ea:	6902                	ld	s2,0(sp)
    800030ec:	6105                	addi	sp,sp,32
    800030ee:	8082                	ret
    panic("brelse");
    800030f0:	00005517          	auipc	a0,0x5
    800030f4:	45850513          	addi	a0,a0,1112 # 80008548 <syscalls+0xe8>
    800030f8:	ffffd097          	auipc	ra,0xffffd
    800030fc:	446080e7          	jalr	1094(ra) # 8000053e <panic>

0000000080003100 <bpin>:

void
bpin(struct buf *b) {
    80003100:	1101                	addi	sp,sp,-32
    80003102:	ec06                	sd	ra,24(sp)
    80003104:	e822                	sd	s0,16(sp)
    80003106:	e426                	sd	s1,8(sp)
    80003108:	1000                	addi	s0,sp,32
    8000310a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000310c:	00014517          	auipc	a0,0x14
    80003110:	4ac50513          	addi	a0,a0,1196 # 800175b8 <bcache>
    80003114:	ffffe097          	auipc	ra,0xffffe
    80003118:	ac2080e7          	jalr	-1342(ra) # 80000bd6 <acquire>
  b->refcnt++;
    8000311c:	40bc                	lw	a5,64(s1)
    8000311e:	2785                	addiw	a5,a5,1
    80003120:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003122:	00014517          	auipc	a0,0x14
    80003126:	49650513          	addi	a0,a0,1174 # 800175b8 <bcache>
    8000312a:	ffffe097          	auipc	ra,0xffffe
    8000312e:	b60080e7          	jalr	-1184(ra) # 80000c8a <release>
}
    80003132:	60e2                	ld	ra,24(sp)
    80003134:	6442                	ld	s0,16(sp)
    80003136:	64a2                	ld	s1,8(sp)
    80003138:	6105                	addi	sp,sp,32
    8000313a:	8082                	ret

000000008000313c <bunpin>:

void
bunpin(struct buf *b) {
    8000313c:	1101                	addi	sp,sp,-32
    8000313e:	ec06                	sd	ra,24(sp)
    80003140:	e822                	sd	s0,16(sp)
    80003142:	e426                	sd	s1,8(sp)
    80003144:	1000                	addi	s0,sp,32
    80003146:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003148:	00014517          	auipc	a0,0x14
    8000314c:	47050513          	addi	a0,a0,1136 # 800175b8 <bcache>
    80003150:	ffffe097          	auipc	ra,0xffffe
    80003154:	a86080e7          	jalr	-1402(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003158:	40bc                	lw	a5,64(s1)
    8000315a:	37fd                	addiw	a5,a5,-1
    8000315c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000315e:	00014517          	auipc	a0,0x14
    80003162:	45a50513          	addi	a0,a0,1114 # 800175b8 <bcache>
    80003166:	ffffe097          	auipc	ra,0xffffe
    8000316a:	b24080e7          	jalr	-1244(ra) # 80000c8a <release>
}
    8000316e:	60e2                	ld	ra,24(sp)
    80003170:	6442                	ld	s0,16(sp)
    80003172:	64a2                	ld	s1,8(sp)
    80003174:	6105                	addi	sp,sp,32
    80003176:	8082                	ret

0000000080003178 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003178:	1101                	addi	sp,sp,-32
    8000317a:	ec06                	sd	ra,24(sp)
    8000317c:	e822                	sd	s0,16(sp)
    8000317e:	e426                	sd	s1,8(sp)
    80003180:	e04a                	sd	s2,0(sp)
    80003182:	1000                	addi	s0,sp,32
    80003184:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003186:	00d5d59b          	srliw	a1,a1,0xd
    8000318a:	0001d797          	auipc	a5,0x1d
    8000318e:	b0a7a783          	lw	a5,-1270(a5) # 8001fc94 <sb+0x1c>
    80003192:	9dbd                	addw	a1,a1,a5
    80003194:	00000097          	auipc	ra,0x0
    80003198:	d9e080e7          	jalr	-610(ra) # 80002f32 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000319c:	0074f713          	andi	a4,s1,7
    800031a0:	4785                	li	a5,1
    800031a2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031a6:	14ce                	slli	s1,s1,0x33
    800031a8:	90d9                	srli	s1,s1,0x36
    800031aa:	00950733          	add	a4,a0,s1
    800031ae:	05874703          	lbu	a4,88(a4)
    800031b2:	00e7f6b3          	and	a3,a5,a4
    800031b6:	c69d                	beqz	a3,800031e4 <bfree+0x6c>
    800031b8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031ba:	94aa                	add	s1,s1,a0
    800031bc:	fff7c793          	not	a5,a5
    800031c0:	8ff9                	and	a5,a5,a4
    800031c2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800031c6:	00001097          	auipc	ra,0x1
    800031ca:	120080e7          	jalr	288(ra) # 800042e6 <log_write>
  brelse(bp);
    800031ce:	854a                	mv	a0,s2
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	e92080e7          	jalr	-366(ra) # 80003062 <brelse>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6902                	ld	s2,0(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret
    panic("freeing free block");
    800031e4:	00005517          	auipc	a0,0x5
    800031e8:	36c50513          	addi	a0,a0,876 # 80008550 <syscalls+0xf0>
    800031ec:	ffffd097          	auipc	ra,0xffffd
    800031f0:	352080e7          	jalr	850(ra) # 8000053e <panic>

00000000800031f4 <balloc>:
{
    800031f4:	711d                	addi	sp,sp,-96
    800031f6:	ec86                	sd	ra,88(sp)
    800031f8:	e8a2                	sd	s0,80(sp)
    800031fa:	e4a6                	sd	s1,72(sp)
    800031fc:	e0ca                	sd	s2,64(sp)
    800031fe:	fc4e                	sd	s3,56(sp)
    80003200:	f852                	sd	s4,48(sp)
    80003202:	f456                	sd	s5,40(sp)
    80003204:	f05a                	sd	s6,32(sp)
    80003206:	ec5e                	sd	s7,24(sp)
    80003208:	e862                	sd	s8,16(sp)
    8000320a:	e466                	sd	s9,8(sp)
    8000320c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000320e:	0001d797          	auipc	a5,0x1d
    80003212:	a6e7a783          	lw	a5,-1426(a5) # 8001fc7c <sb+0x4>
    80003216:	10078163          	beqz	a5,80003318 <balloc+0x124>
    8000321a:	8baa                	mv	s7,a0
    8000321c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000321e:	0001db17          	auipc	s6,0x1d
    80003222:	a5ab0b13          	addi	s6,s6,-1446 # 8001fc78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003226:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003228:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000322a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000322c:	6c89                	lui	s9,0x2
    8000322e:	a061                	j	800032b6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003230:	974a                	add	a4,a4,s2
    80003232:	8fd5                	or	a5,a5,a3
    80003234:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003238:	854a                	mv	a0,s2
    8000323a:	00001097          	auipc	ra,0x1
    8000323e:	0ac080e7          	jalr	172(ra) # 800042e6 <log_write>
        brelse(bp);
    80003242:	854a                	mv	a0,s2
    80003244:	00000097          	auipc	ra,0x0
    80003248:	e1e080e7          	jalr	-482(ra) # 80003062 <brelse>
  bp = bread(dev, bno);
    8000324c:	85a6                	mv	a1,s1
    8000324e:	855e                	mv	a0,s7
    80003250:	00000097          	auipc	ra,0x0
    80003254:	ce2080e7          	jalr	-798(ra) # 80002f32 <bread>
    80003258:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000325a:	40000613          	li	a2,1024
    8000325e:	4581                	li	a1,0
    80003260:	05850513          	addi	a0,a0,88
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	a6e080e7          	jalr	-1426(ra) # 80000cd2 <memset>
  log_write(bp);
    8000326c:	854a                	mv	a0,s2
    8000326e:	00001097          	auipc	ra,0x1
    80003272:	078080e7          	jalr	120(ra) # 800042e6 <log_write>
  brelse(bp);
    80003276:	854a                	mv	a0,s2
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	dea080e7          	jalr	-534(ra) # 80003062 <brelse>
}
    80003280:	8526                	mv	a0,s1
    80003282:	60e6                	ld	ra,88(sp)
    80003284:	6446                	ld	s0,80(sp)
    80003286:	64a6                	ld	s1,72(sp)
    80003288:	6906                	ld	s2,64(sp)
    8000328a:	79e2                	ld	s3,56(sp)
    8000328c:	7a42                	ld	s4,48(sp)
    8000328e:	7aa2                	ld	s5,40(sp)
    80003290:	7b02                	ld	s6,32(sp)
    80003292:	6be2                	ld	s7,24(sp)
    80003294:	6c42                	ld	s8,16(sp)
    80003296:	6ca2                	ld	s9,8(sp)
    80003298:	6125                	addi	sp,sp,96
    8000329a:	8082                	ret
    brelse(bp);
    8000329c:	854a                	mv	a0,s2
    8000329e:	00000097          	auipc	ra,0x0
    800032a2:	dc4080e7          	jalr	-572(ra) # 80003062 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800032a6:	015c87bb          	addw	a5,s9,s5
    800032aa:	00078a9b          	sext.w	s5,a5
    800032ae:	004b2703          	lw	a4,4(s6)
    800032b2:	06eaf363          	bgeu	s5,a4,80003318 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800032b6:	41fad79b          	sraiw	a5,s5,0x1f
    800032ba:	0137d79b          	srliw	a5,a5,0x13
    800032be:	015787bb          	addw	a5,a5,s5
    800032c2:	40d7d79b          	sraiw	a5,a5,0xd
    800032c6:	01cb2583          	lw	a1,28(s6)
    800032ca:	9dbd                	addw	a1,a1,a5
    800032cc:	855e                	mv	a0,s7
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	c64080e7          	jalr	-924(ra) # 80002f32 <bread>
    800032d6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032d8:	004b2503          	lw	a0,4(s6)
    800032dc:	000a849b          	sext.w	s1,s5
    800032e0:	8662                	mv	a2,s8
    800032e2:	faa4fde3          	bgeu	s1,a0,8000329c <balloc+0xa8>
      m = 1 << (bi % 8);
    800032e6:	41f6579b          	sraiw	a5,a2,0x1f
    800032ea:	01d7d69b          	srliw	a3,a5,0x1d
    800032ee:	00c6873b          	addw	a4,a3,a2
    800032f2:	00777793          	andi	a5,a4,7
    800032f6:	9f95                	subw	a5,a5,a3
    800032f8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032fc:	4037571b          	sraiw	a4,a4,0x3
    80003300:	00e906b3          	add	a3,s2,a4
    80003304:	0586c683          	lbu	a3,88(a3)
    80003308:	00d7f5b3          	and	a1,a5,a3
    8000330c:	d195                	beqz	a1,80003230 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000330e:	2605                	addiw	a2,a2,1
    80003310:	2485                	addiw	s1,s1,1
    80003312:	fd4618e3          	bne	a2,s4,800032e2 <balloc+0xee>
    80003316:	b759                	j	8000329c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003318:	00005517          	auipc	a0,0x5
    8000331c:	25050513          	addi	a0,a0,592 # 80008568 <syscalls+0x108>
    80003320:	ffffd097          	auipc	ra,0xffffd
    80003324:	268080e7          	jalr	616(ra) # 80000588 <printf>
  return 0;
    80003328:	4481                	li	s1,0
    8000332a:	bf99                	j	80003280 <balloc+0x8c>

000000008000332c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000332c:	7179                	addi	sp,sp,-48
    8000332e:	f406                	sd	ra,40(sp)
    80003330:	f022                	sd	s0,32(sp)
    80003332:	ec26                	sd	s1,24(sp)
    80003334:	e84a                	sd	s2,16(sp)
    80003336:	e44e                	sd	s3,8(sp)
    80003338:	e052                	sd	s4,0(sp)
    8000333a:	1800                	addi	s0,sp,48
    8000333c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000333e:	47ad                	li	a5,11
    80003340:	02b7e763          	bltu	a5,a1,8000336e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003344:	02059493          	slli	s1,a1,0x20
    80003348:	9081                	srli	s1,s1,0x20
    8000334a:	048a                	slli	s1,s1,0x2
    8000334c:	94aa                	add	s1,s1,a0
    8000334e:	0504a903          	lw	s2,80(s1)
    80003352:	06091e63          	bnez	s2,800033ce <bmap+0xa2>
      addr = balloc(ip->dev);
    80003356:	4108                	lw	a0,0(a0)
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	e9c080e7          	jalr	-356(ra) # 800031f4 <balloc>
    80003360:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003364:	06090563          	beqz	s2,800033ce <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003368:	0524a823          	sw	s2,80(s1)
    8000336c:	a08d                	j	800033ce <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000336e:	ff45849b          	addiw	s1,a1,-12
    80003372:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003376:	0ff00793          	li	a5,255
    8000337a:	08e7e563          	bltu	a5,a4,80003404 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000337e:	08052903          	lw	s2,128(a0)
    80003382:	00091d63          	bnez	s2,8000339c <bmap+0x70>
      addr = balloc(ip->dev);
    80003386:	4108                	lw	a0,0(a0)
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	e6c080e7          	jalr	-404(ra) # 800031f4 <balloc>
    80003390:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003394:	02090d63          	beqz	s2,800033ce <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003398:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000339c:	85ca                	mv	a1,s2
    8000339e:	0009a503          	lw	a0,0(s3)
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	b90080e7          	jalr	-1136(ra) # 80002f32 <bread>
    800033aa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800033ac:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800033b0:	02049593          	slli	a1,s1,0x20
    800033b4:	9181                	srli	a1,a1,0x20
    800033b6:	058a                	slli	a1,a1,0x2
    800033b8:	00b784b3          	add	s1,a5,a1
    800033bc:	0004a903          	lw	s2,0(s1)
    800033c0:	02090063          	beqz	s2,800033e0 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800033c4:	8552                	mv	a0,s4
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	c9c080e7          	jalr	-868(ra) # 80003062 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800033ce:	854a                	mv	a0,s2
    800033d0:	70a2                	ld	ra,40(sp)
    800033d2:	7402                	ld	s0,32(sp)
    800033d4:	64e2                	ld	s1,24(sp)
    800033d6:	6942                	ld	s2,16(sp)
    800033d8:	69a2                	ld	s3,8(sp)
    800033da:	6a02                	ld	s4,0(sp)
    800033dc:	6145                	addi	sp,sp,48
    800033de:	8082                	ret
      addr = balloc(ip->dev);
    800033e0:	0009a503          	lw	a0,0(s3)
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	e10080e7          	jalr	-496(ra) # 800031f4 <balloc>
    800033ec:	0005091b          	sext.w	s2,a0
      if(addr){
    800033f0:	fc090ae3          	beqz	s2,800033c4 <bmap+0x98>
        a[bn] = addr;
    800033f4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800033f8:	8552                	mv	a0,s4
    800033fa:	00001097          	auipc	ra,0x1
    800033fe:	eec080e7          	jalr	-276(ra) # 800042e6 <log_write>
    80003402:	b7c9                	j	800033c4 <bmap+0x98>
  panic("bmap: out of range");
    80003404:	00005517          	auipc	a0,0x5
    80003408:	17c50513          	addi	a0,a0,380 # 80008580 <syscalls+0x120>
    8000340c:	ffffd097          	auipc	ra,0xffffd
    80003410:	132080e7          	jalr	306(ra) # 8000053e <panic>

0000000080003414 <iget>:
{
    80003414:	7179                	addi	sp,sp,-48
    80003416:	f406                	sd	ra,40(sp)
    80003418:	f022                	sd	s0,32(sp)
    8000341a:	ec26                	sd	s1,24(sp)
    8000341c:	e84a                	sd	s2,16(sp)
    8000341e:	e44e                	sd	s3,8(sp)
    80003420:	e052                	sd	s4,0(sp)
    80003422:	1800                	addi	s0,sp,48
    80003424:	89aa                	mv	s3,a0
    80003426:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003428:	0001d517          	auipc	a0,0x1d
    8000342c:	87050513          	addi	a0,a0,-1936 # 8001fc98 <itable>
    80003430:	ffffd097          	auipc	ra,0xffffd
    80003434:	7a6080e7          	jalr	1958(ra) # 80000bd6 <acquire>
  empty = 0;
    80003438:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000343a:	0001d497          	auipc	s1,0x1d
    8000343e:	87648493          	addi	s1,s1,-1930 # 8001fcb0 <itable+0x18>
    80003442:	0001e697          	auipc	a3,0x1e
    80003446:	2fe68693          	addi	a3,a3,766 # 80021740 <log>
    8000344a:	a039                	j	80003458 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000344c:	02090b63          	beqz	s2,80003482 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003450:	08848493          	addi	s1,s1,136
    80003454:	02d48a63          	beq	s1,a3,80003488 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003458:	449c                	lw	a5,8(s1)
    8000345a:	fef059e3          	blez	a5,8000344c <iget+0x38>
    8000345e:	4098                	lw	a4,0(s1)
    80003460:	ff3716e3          	bne	a4,s3,8000344c <iget+0x38>
    80003464:	40d8                	lw	a4,4(s1)
    80003466:	ff4713e3          	bne	a4,s4,8000344c <iget+0x38>
      ip->ref++;
    8000346a:	2785                	addiw	a5,a5,1
    8000346c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000346e:	0001d517          	auipc	a0,0x1d
    80003472:	82a50513          	addi	a0,a0,-2006 # 8001fc98 <itable>
    80003476:	ffffe097          	auipc	ra,0xffffe
    8000347a:	814080e7          	jalr	-2028(ra) # 80000c8a <release>
      return ip;
    8000347e:	8926                	mv	s2,s1
    80003480:	a03d                	j	800034ae <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003482:	f7f9                	bnez	a5,80003450 <iget+0x3c>
    80003484:	8926                	mv	s2,s1
    80003486:	b7e9                	j	80003450 <iget+0x3c>
  if(empty == 0)
    80003488:	02090c63          	beqz	s2,800034c0 <iget+0xac>
  ip->dev = dev;
    8000348c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003490:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003494:	4785                	li	a5,1
    80003496:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000349a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000349e:	0001c517          	auipc	a0,0x1c
    800034a2:	7fa50513          	addi	a0,a0,2042 # 8001fc98 <itable>
    800034a6:	ffffd097          	auipc	ra,0xffffd
    800034aa:	7e4080e7          	jalr	2020(ra) # 80000c8a <release>
}
    800034ae:	854a                	mv	a0,s2
    800034b0:	70a2                	ld	ra,40(sp)
    800034b2:	7402                	ld	s0,32(sp)
    800034b4:	64e2                	ld	s1,24(sp)
    800034b6:	6942                	ld	s2,16(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	6a02                	ld	s4,0(sp)
    800034bc:	6145                	addi	sp,sp,48
    800034be:	8082                	ret
    panic("iget: no inodes");
    800034c0:	00005517          	auipc	a0,0x5
    800034c4:	0d850513          	addi	a0,a0,216 # 80008598 <syscalls+0x138>
    800034c8:	ffffd097          	auipc	ra,0xffffd
    800034cc:	076080e7          	jalr	118(ra) # 8000053e <panic>

00000000800034d0 <fsinit>:
fsinit(int dev) {
    800034d0:	7179                	addi	sp,sp,-48
    800034d2:	f406                	sd	ra,40(sp)
    800034d4:	f022                	sd	s0,32(sp)
    800034d6:	ec26                	sd	s1,24(sp)
    800034d8:	e84a                	sd	s2,16(sp)
    800034da:	e44e                	sd	s3,8(sp)
    800034dc:	1800                	addi	s0,sp,48
    800034de:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034e0:	4585                	li	a1,1
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	a50080e7          	jalr	-1456(ra) # 80002f32 <bread>
    800034ea:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034ec:	0001c997          	auipc	s3,0x1c
    800034f0:	78c98993          	addi	s3,s3,1932 # 8001fc78 <sb>
    800034f4:	02000613          	li	a2,32
    800034f8:	05850593          	addi	a1,a0,88
    800034fc:	854e                	mv	a0,s3
    800034fe:	ffffe097          	auipc	ra,0xffffe
    80003502:	830080e7          	jalr	-2000(ra) # 80000d2e <memmove>
  brelse(bp);
    80003506:	8526                	mv	a0,s1
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	b5a080e7          	jalr	-1190(ra) # 80003062 <brelse>
  if(sb.magic != FSMAGIC)
    80003510:	0009a703          	lw	a4,0(s3)
    80003514:	102037b7          	lui	a5,0x10203
    80003518:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000351c:	02f71263          	bne	a4,a5,80003540 <fsinit+0x70>
  initlog(dev, &sb);
    80003520:	0001c597          	auipc	a1,0x1c
    80003524:	75858593          	addi	a1,a1,1880 # 8001fc78 <sb>
    80003528:	854a                	mv	a0,s2
    8000352a:	00001097          	auipc	ra,0x1
    8000352e:	b40080e7          	jalr	-1216(ra) # 8000406a <initlog>
}
    80003532:	70a2                	ld	ra,40(sp)
    80003534:	7402                	ld	s0,32(sp)
    80003536:	64e2                	ld	s1,24(sp)
    80003538:	6942                	ld	s2,16(sp)
    8000353a:	69a2                	ld	s3,8(sp)
    8000353c:	6145                	addi	sp,sp,48
    8000353e:	8082                	ret
    panic("invalid file system");
    80003540:	00005517          	auipc	a0,0x5
    80003544:	06850513          	addi	a0,a0,104 # 800085a8 <syscalls+0x148>
    80003548:	ffffd097          	auipc	ra,0xffffd
    8000354c:	ff6080e7          	jalr	-10(ra) # 8000053e <panic>

0000000080003550 <iinit>:
{
    80003550:	7179                	addi	sp,sp,-48
    80003552:	f406                	sd	ra,40(sp)
    80003554:	f022                	sd	s0,32(sp)
    80003556:	ec26                	sd	s1,24(sp)
    80003558:	e84a                	sd	s2,16(sp)
    8000355a:	e44e                	sd	s3,8(sp)
    8000355c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000355e:	00005597          	auipc	a1,0x5
    80003562:	06258593          	addi	a1,a1,98 # 800085c0 <syscalls+0x160>
    80003566:	0001c517          	auipc	a0,0x1c
    8000356a:	73250513          	addi	a0,a0,1842 # 8001fc98 <itable>
    8000356e:	ffffd097          	auipc	ra,0xffffd
    80003572:	5d8080e7          	jalr	1496(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003576:	0001c497          	auipc	s1,0x1c
    8000357a:	74a48493          	addi	s1,s1,1866 # 8001fcc0 <itable+0x28>
    8000357e:	0001e997          	auipc	s3,0x1e
    80003582:	1d298993          	addi	s3,s3,466 # 80021750 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003586:	00005917          	auipc	s2,0x5
    8000358a:	04290913          	addi	s2,s2,66 # 800085c8 <syscalls+0x168>
    8000358e:	85ca                	mv	a1,s2
    80003590:	8526                	mv	a0,s1
    80003592:	00001097          	auipc	ra,0x1
    80003596:	e3a080e7          	jalr	-454(ra) # 800043cc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000359a:	08848493          	addi	s1,s1,136
    8000359e:	ff3498e3          	bne	s1,s3,8000358e <iinit+0x3e>
}
    800035a2:	70a2                	ld	ra,40(sp)
    800035a4:	7402                	ld	s0,32(sp)
    800035a6:	64e2                	ld	s1,24(sp)
    800035a8:	6942                	ld	s2,16(sp)
    800035aa:	69a2                	ld	s3,8(sp)
    800035ac:	6145                	addi	sp,sp,48
    800035ae:	8082                	ret

00000000800035b0 <ialloc>:
{
    800035b0:	715d                	addi	sp,sp,-80
    800035b2:	e486                	sd	ra,72(sp)
    800035b4:	e0a2                	sd	s0,64(sp)
    800035b6:	fc26                	sd	s1,56(sp)
    800035b8:	f84a                	sd	s2,48(sp)
    800035ba:	f44e                	sd	s3,40(sp)
    800035bc:	f052                	sd	s4,32(sp)
    800035be:	ec56                	sd	s5,24(sp)
    800035c0:	e85a                	sd	s6,16(sp)
    800035c2:	e45e                	sd	s7,8(sp)
    800035c4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800035c6:	0001c717          	auipc	a4,0x1c
    800035ca:	6be72703          	lw	a4,1726(a4) # 8001fc84 <sb+0xc>
    800035ce:	4785                	li	a5,1
    800035d0:	04e7fa63          	bgeu	a5,a4,80003624 <ialloc+0x74>
    800035d4:	8aaa                	mv	s5,a0
    800035d6:	8bae                	mv	s7,a1
    800035d8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035da:	0001ca17          	auipc	s4,0x1c
    800035de:	69ea0a13          	addi	s4,s4,1694 # 8001fc78 <sb>
    800035e2:	00048b1b          	sext.w	s6,s1
    800035e6:	0044d793          	srli	a5,s1,0x4
    800035ea:	018a2583          	lw	a1,24(s4)
    800035ee:	9dbd                	addw	a1,a1,a5
    800035f0:	8556                	mv	a0,s5
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	940080e7          	jalr	-1728(ra) # 80002f32 <bread>
    800035fa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035fc:	05850993          	addi	s3,a0,88
    80003600:	00f4f793          	andi	a5,s1,15
    80003604:	079a                	slli	a5,a5,0x6
    80003606:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003608:	00099783          	lh	a5,0(s3)
    8000360c:	c3a1                	beqz	a5,8000364c <ialloc+0x9c>
    brelse(bp);
    8000360e:	00000097          	auipc	ra,0x0
    80003612:	a54080e7          	jalr	-1452(ra) # 80003062 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003616:	0485                	addi	s1,s1,1
    80003618:	00ca2703          	lw	a4,12(s4)
    8000361c:	0004879b          	sext.w	a5,s1
    80003620:	fce7e1e3          	bltu	a5,a4,800035e2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003624:	00005517          	auipc	a0,0x5
    80003628:	fac50513          	addi	a0,a0,-84 # 800085d0 <syscalls+0x170>
    8000362c:	ffffd097          	auipc	ra,0xffffd
    80003630:	f5c080e7          	jalr	-164(ra) # 80000588 <printf>
  return 0;
    80003634:	4501                	li	a0,0
}
    80003636:	60a6                	ld	ra,72(sp)
    80003638:	6406                	ld	s0,64(sp)
    8000363a:	74e2                	ld	s1,56(sp)
    8000363c:	7942                	ld	s2,48(sp)
    8000363e:	79a2                	ld	s3,40(sp)
    80003640:	7a02                	ld	s4,32(sp)
    80003642:	6ae2                	ld	s5,24(sp)
    80003644:	6b42                	ld	s6,16(sp)
    80003646:	6ba2                	ld	s7,8(sp)
    80003648:	6161                	addi	sp,sp,80
    8000364a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000364c:	04000613          	li	a2,64
    80003650:	4581                	li	a1,0
    80003652:	854e                	mv	a0,s3
    80003654:	ffffd097          	auipc	ra,0xffffd
    80003658:	67e080e7          	jalr	1662(ra) # 80000cd2 <memset>
      dip->type = type;
    8000365c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003660:	854a                	mv	a0,s2
    80003662:	00001097          	auipc	ra,0x1
    80003666:	c84080e7          	jalr	-892(ra) # 800042e6 <log_write>
      brelse(bp);
    8000366a:	854a                	mv	a0,s2
    8000366c:	00000097          	auipc	ra,0x0
    80003670:	9f6080e7          	jalr	-1546(ra) # 80003062 <brelse>
      return iget(dev, inum);
    80003674:	85da                	mv	a1,s6
    80003676:	8556                	mv	a0,s5
    80003678:	00000097          	auipc	ra,0x0
    8000367c:	d9c080e7          	jalr	-612(ra) # 80003414 <iget>
    80003680:	bf5d                	j	80003636 <ialloc+0x86>

0000000080003682 <iupdate>:
{
    80003682:	1101                	addi	sp,sp,-32
    80003684:	ec06                	sd	ra,24(sp)
    80003686:	e822                	sd	s0,16(sp)
    80003688:	e426                	sd	s1,8(sp)
    8000368a:	e04a                	sd	s2,0(sp)
    8000368c:	1000                	addi	s0,sp,32
    8000368e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003690:	415c                	lw	a5,4(a0)
    80003692:	0047d79b          	srliw	a5,a5,0x4
    80003696:	0001c597          	auipc	a1,0x1c
    8000369a:	5fa5a583          	lw	a1,1530(a1) # 8001fc90 <sb+0x18>
    8000369e:	9dbd                	addw	a1,a1,a5
    800036a0:	4108                	lw	a0,0(a0)
    800036a2:	00000097          	auipc	ra,0x0
    800036a6:	890080e7          	jalr	-1904(ra) # 80002f32 <bread>
    800036aa:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036ac:	05850793          	addi	a5,a0,88
    800036b0:	40c8                	lw	a0,4(s1)
    800036b2:	893d                	andi	a0,a0,15
    800036b4:	051a                	slli	a0,a0,0x6
    800036b6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800036b8:	04449703          	lh	a4,68(s1)
    800036bc:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800036c0:	04649703          	lh	a4,70(s1)
    800036c4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800036c8:	04849703          	lh	a4,72(s1)
    800036cc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800036d0:	04a49703          	lh	a4,74(s1)
    800036d4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800036d8:	44f8                	lw	a4,76(s1)
    800036da:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036dc:	03400613          	li	a2,52
    800036e0:	05048593          	addi	a1,s1,80
    800036e4:	0531                	addi	a0,a0,12
    800036e6:	ffffd097          	auipc	ra,0xffffd
    800036ea:	648080e7          	jalr	1608(ra) # 80000d2e <memmove>
  log_write(bp);
    800036ee:	854a                	mv	a0,s2
    800036f0:	00001097          	auipc	ra,0x1
    800036f4:	bf6080e7          	jalr	-1034(ra) # 800042e6 <log_write>
  brelse(bp);
    800036f8:	854a                	mv	a0,s2
    800036fa:	00000097          	auipc	ra,0x0
    800036fe:	968080e7          	jalr	-1688(ra) # 80003062 <brelse>
}
    80003702:	60e2                	ld	ra,24(sp)
    80003704:	6442                	ld	s0,16(sp)
    80003706:	64a2                	ld	s1,8(sp)
    80003708:	6902                	ld	s2,0(sp)
    8000370a:	6105                	addi	sp,sp,32
    8000370c:	8082                	ret

000000008000370e <idup>:
{
    8000370e:	1101                	addi	sp,sp,-32
    80003710:	ec06                	sd	ra,24(sp)
    80003712:	e822                	sd	s0,16(sp)
    80003714:	e426                	sd	s1,8(sp)
    80003716:	1000                	addi	s0,sp,32
    80003718:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000371a:	0001c517          	auipc	a0,0x1c
    8000371e:	57e50513          	addi	a0,a0,1406 # 8001fc98 <itable>
    80003722:	ffffd097          	auipc	ra,0xffffd
    80003726:	4b4080e7          	jalr	1204(ra) # 80000bd6 <acquire>
  ip->ref++;
    8000372a:	449c                	lw	a5,8(s1)
    8000372c:	2785                	addiw	a5,a5,1
    8000372e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003730:	0001c517          	auipc	a0,0x1c
    80003734:	56850513          	addi	a0,a0,1384 # 8001fc98 <itable>
    80003738:	ffffd097          	auipc	ra,0xffffd
    8000373c:	552080e7          	jalr	1362(ra) # 80000c8a <release>
}
    80003740:	8526                	mv	a0,s1
    80003742:	60e2                	ld	ra,24(sp)
    80003744:	6442                	ld	s0,16(sp)
    80003746:	64a2                	ld	s1,8(sp)
    80003748:	6105                	addi	sp,sp,32
    8000374a:	8082                	ret

000000008000374c <ilock>:
{
    8000374c:	1101                	addi	sp,sp,-32
    8000374e:	ec06                	sd	ra,24(sp)
    80003750:	e822                	sd	s0,16(sp)
    80003752:	e426                	sd	s1,8(sp)
    80003754:	e04a                	sd	s2,0(sp)
    80003756:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003758:	c115                	beqz	a0,8000377c <ilock+0x30>
    8000375a:	84aa                	mv	s1,a0
    8000375c:	451c                	lw	a5,8(a0)
    8000375e:	00f05f63          	blez	a5,8000377c <ilock+0x30>
  acquiresleep(&ip->lock);
    80003762:	0541                	addi	a0,a0,16
    80003764:	00001097          	auipc	ra,0x1
    80003768:	ca2080e7          	jalr	-862(ra) # 80004406 <acquiresleep>
  if(ip->valid == 0){
    8000376c:	40bc                	lw	a5,64(s1)
    8000376e:	cf99                	beqz	a5,8000378c <ilock+0x40>
}
    80003770:	60e2                	ld	ra,24(sp)
    80003772:	6442                	ld	s0,16(sp)
    80003774:	64a2                	ld	s1,8(sp)
    80003776:	6902                	ld	s2,0(sp)
    80003778:	6105                	addi	sp,sp,32
    8000377a:	8082                	ret
    panic("ilock");
    8000377c:	00005517          	auipc	a0,0x5
    80003780:	e6c50513          	addi	a0,a0,-404 # 800085e8 <syscalls+0x188>
    80003784:	ffffd097          	auipc	ra,0xffffd
    80003788:	dba080e7          	jalr	-582(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000378c:	40dc                	lw	a5,4(s1)
    8000378e:	0047d79b          	srliw	a5,a5,0x4
    80003792:	0001c597          	auipc	a1,0x1c
    80003796:	4fe5a583          	lw	a1,1278(a1) # 8001fc90 <sb+0x18>
    8000379a:	9dbd                	addw	a1,a1,a5
    8000379c:	4088                	lw	a0,0(s1)
    8000379e:	fffff097          	auipc	ra,0xfffff
    800037a2:	794080e7          	jalr	1940(ra) # 80002f32 <bread>
    800037a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037a8:	05850593          	addi	a1,a0,88
    800037ac:	40dc                	lw	a5,4(s1)
    800037ae:	8bbd                	andi	a5,a5,15
    800037b0:	079a                	slli	a5,a5,0x6
    800037b2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037b4:	00059783          	lh	a5,0(a1)
    800037b8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037bc:	00259783          	lh	a5,2(a1)
    800037c0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037c4:	00459783          	lh	a5,4(a1)
    800037c8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037cc:	00659783          	lh	a5,6(a1)
    800037d0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037d4:	459c                	lw	a5,8(a1)
    800037d6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037d8:	03400613          	li	a2,52
    800037dc:	05b1                	addi	a1,a1,12
    800037de:	05048513          	addi	a0,s1,80
    800037e2:	ffffd097          	auipc	ra,0xffffd
    800037e6:	54c080e7          	jalr	1356(ra) # 80000d2e <memmove>
    brelse(bp);
    800037ea:	854a                	mv	a0,s2
    800037ec:	00000097          	auipc	ra,0x0
    800037f0:	876080e7          	jalr	-1930(ra) # 80003062 <brelse>
    ip->valid = 1;
    800037f4:	4785                	li	a5,1
    800037f6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037f8:	04449783          	lh	a5,68(s1)
    800037fc:	fbb5                	bnez	a5,80003770 <ilock+0x24>
      panic("ilock: no type");
    800037fe:	00005517          	auipc	a0,0x5
    80003802:	df250513          	addi	a0,a0,-526 # 800085f0 <syscalls+0x190>
    80003806:	ffffd097          	auipc	ra,0xffffd
    8000380a:	d38080e7          	jalr	-712(ra) # 8000053e <panic>

000000008000380e <iunlock>:
{
    8000380e:	1101                	addi	sp,sp,-32
    80003810:	ec06                	sd	ra,24(sp)
    80003812:	e822                	sd	s0,16(sp)
    80003814:	e426                	sd	s1,8(sp)
    80003816:	e04a                	sd	s2,0(sp)
    80003818:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000381a:	c905                	beqz	a0,8000384a <iunlock+0x3c>
    8000381c:	84aa                	mv	s1,a0
    8000381e:	01050913          	addi	s2,a0,16
    80003822:	854a                	mv	a0,s2
    80003824:	00001097          	auipc	ra,0x1
    80003828:	c7c080e7          	jalr	-900(ra) # 800044a0 <holdingsleep>
    8000382c:	cd19                	beqz	a0,8000384a <iunlock+0x3c>
    8000382e:	449c                	lw	a5,8(s1)
    80003830:	00f05d63          	blez	a5,8000384a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003834:	854a                	mv	a0,s2
    80003836:	00001097          	auipc	ra,0x1
    8000383a:	c26080e7          	jalr	-986(ra) # 8000445c <releasesleep>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret
    panic("iunlock");
    8000384a:	00005517          	auipc	a0,0x5
    8000384e:	db650513          	addi	a0,a0,-586 # 80008600 <syscalls+0x1a0>
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	cec080e7          	jalr	-788(ra) # 8000053e <panic>

000000008000385a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000385a:	7179                	addi	sp,sp,-48
    8000385c:	f406                	sd	ra,40(sp)
    8000385e:	f022                	sd	s0,32(sp)
    80003860:	ec26                	sd	s1,24(sp)
    80003862:	e84a                	sd	s2,16(sp)
    80003864:	e44e                	sd	s3,8(sp)
    80003866:	e052                	sd	s4,0(sp)
    80003868:	1800                	addi	s0,sp,48
    8000386a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000386c:	05050493          	addi	s1,a0,80
    80003870:	08050913          	addi	s2,a0,128
    80003874:	a021                	j	8000387c <itrunc+0x22>
    80003876:	0491                	addi	s1,s1,4
    80003878:	01248d63          	beq	s1,s2,80003892 <itrunc+0x38>
    if(ip->addrs[i]){
    8000387c:	408c                	lw	a1,0(s1)
    8000387e:	dde5                	beqz	a1,80003876 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003880:	0009a503          	lw	a0,0(s3)
    80003884:	00000097          	auipc	ra,0x0
    80003888:	8f4080e7          	jalr	-1804(ra) # 80003178 <bfree>
      ip->addrs[i] = 0;
    8000388c:	0004a023          	sw	zero,0(s1)
    80003890:	b7dd                	j	80003876 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003892:	0809a583          	lw	a1,128(s3)
    80003896:	e185                	bnez	a1,800038b6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003898:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000389c:	854e                	mv	a0,s3
    8000389e:	00000097          	auipc	ra,0x0
    800038a2:	de4080e7          	jalr	-540(ra) # 80003682 <iupdate>
}
    800038a6:	70a2                	ld	ra,40(sp)
    800038a8:	7402                	ld	s0,32(sp)
    800038aa:	64e2                	ld	s1,24(sp)
    800038ac:	6942                	ld	s2,16(sp)
    800038ae:	69a2                	ld	s3,8(sp)
    800038b0:	6a02                	ld	s4,0(sp)
    800038b2:	6145                	addi	sp,sp,48
    800038b4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038b6:	0009a503          	lw	a0,0(s3)
    800038ba:	fffff097          	auipc	ra,0xfffff
    800038be:	678080e7          	jalr	1656(ra) # 80002f32 <bread>
    800038c2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038c4:	05850493          	addi	s1,a0,88
    800038c8:	45850913          	addi	s2,a0,1112
    800038cc:	a021                	j	800038d4 <itrunc+0x7a>
    800038ce:	0491                	addi	s1,s1,4
    800038d0:	01248b63          	beq	s1,s2,800038e6 <itrunc+0x8c>
      if(a[j])
    800038d4:	408c                	lw	a1,0(s1)
    800038d6:	dde5                	beqz	a1,800038ce <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800038d8:	0009a503          	lw	a0,0(s3)
    800038dc:	00000097          	auipc	ra,0x0
    800038e0:	89c080e7          	jalr	-1892(ra) # 80003178 <bfree>
    800038e4:	b7ed                	j	800038ce <itrunc+0x74>
    brelse(bp);
    800038e6:	8552                	mv	a0,s4
    800038e8:	fffff097          	auipc	ra,0xfffff
    800038ec:	77a080e7          	jalr	1914(ra) # 80003062 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038f0:	0809a583          	lw	a1,128(s3)
    800038f4:	0009a503          	lw	a0,0(s3)
    800038f8:	00000097          	auipc	ra,0x0
    800038fc:	880080e7          	jalr	-1920(ra) # 80003178 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003900:	0809a023          	sw	zero,128(s3)
    80003904:	bf51                	j	80003898 <itrunc+0x3e>

0000000080003906 <iput>:
{
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
    80003912:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003914:	0001c517          	auipc	a0,0x1c
    80003918:	38450513          	addi	a0,a0,900 # 8001fc98 <itable>
    8000391c:	ffffd097          	auipc	ra,0xffffd
    80003920:	2ba080e7          	jalr	698(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003924:	4498                	lw	a4,8(s1)
    80003926:	4785                	li	a5,1
    80003928:	02f70363          	beq	a4,a5,8000394e <iput+0x48>
  ip->ref--;
    8000392c:	449c                	lw	a5,8(s1)
    8000392e:	37fd                	addiw	a5,a5,-1
    80003930:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003932:	0001c517          	auipc	a0,0x1c
    80003936:	36650513          	addi	a0,a0,870 # 8001fc98 <itable>
    8000393a:	ffffd097          	auipc	ra,0xffffd
    8000393e:	350080e7          	jalr	848(ra) # 80000c8a <release>
}
    80003942:	60e2                	ld	ra,24(sp)
    80003944:	6442                	ld	s0,16(sp)
    80003946:	64a2                	ld	s1,8(sp)
    80003948:	6902                	ld	s2,0(sp)
    8000394a:	6105                	addi	sp,sp,32
    8000394c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000394e:	40bc                	lw	a5,64(s1)
    80003950:	dff1                	beqz	a5,8000392c <iput+0x26>
    80003952:	04a49783          	lh	a5,74(s1)
    80003956:	fbf9                	bnez	a5,8000392c <iput+0x26>
    acquiresleep(&ip->lock);
    80003958:	01048913          	addi	s2,s1,16
    8000395c:	854a                	mv	a0,s2
    8000395e:	00001097          	auipc	ra,0x1
    80003962:	aa8080e7          	jalr	-1368(ra) # 80004406 <acquiresleep>
    release(&itable.lock);
    80003966:	0001c517          	auipc	a0,0x1c
    8000396a:	33250513          	addi	a0,a0,818 # 8001fc98 <itable>
    8000396e:	ffffd097          	auipc	ra,0xffffd
    80003972:	31c080e7          	jalr	796(ra) # 80000c8a <release>
    itrunc(ip);
    80003976:	8526                	mv	a0,s1
    80003978:	00000097          	auipc	ra,0x0
    8000397c:	ee2080e7          	jalr	-286(ra) # 8000385a <itrunc>
    ip->type = 0;
    80003980:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003984:	8526                	mv	a0,s1
    80003986:	00000097          	auipc	ra,0x0
    8000398a:	cfc080e7          	jalr	-772(ra) # 80003682 <iupdate>
    ip->valid = 0;
    8000398e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003992:	854a                	mv	a0,s2
    80003994:	00001097          	auipc	ra,0x1
    80003998:	ac8080e7          	jalr	-1336(ra) # 8000445c <releasesleep>
    acquire(&itable.lock);
    8000399c:	0001c517          	auipc	a0,0x1c
    800039a0:	2fc50513          	addi	a0,a0,764 # 8001fc98 <itable>
    800039a4:	ffffd097          	auipc	ra,0xffffd
    800039a8:	232080e7          	jalr	562(ra) # 80000bd6 <acquire>
    800039ac:	b741                	j	8000392c <iput+0x26>

00000000800039ae <iunlockput>:
{
    800039ae:	1101                	addi	sp,sp,-32
    800039b0:	ec06                	sd	ra,24(sp)
    800039b2:	e822                	sd	s0,16(sp)
    800039b4:	e426                	sd	s1,8(sp)
    800039b6:	1000                	addi	s0,sp,32
    800039b8:	84aa                	mv	s1,a0
  iunlock(ip);
    800039ba:	00000097          	auipc	ra,0x0
    800039be:	e54080e7          	jalr	-428(ra) # 8000380e <iunlock>
  iput(ip);
    800039c2:	8526                	mv	a0,s1
    800039c4:	00000097          	auipc	ra,0x0
    800039c8:	f42080e7          	jalr	-190(ra) # 80003906 <iput>
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret

00000000800039d6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039d6:	1141                	addi	sp,sp,-16
    800039d8:	e422                	sd	s0,8(sp)
    800039da:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039dc:	411c                	lw	a5,0(a0)
    800039de:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039e0:	415c                	lw	a5,4(a0)
    800039e2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039e4:	04451783          	lh	a5,68(a0)
    800039e8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039ec:	04a51783          	lh	a5,74(a0)
    800039f0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039f4:	04c56783          	lwu	a5,76(a0)
    800039f8:	e99c                	sd	a5,16(a1)
}
    800039fa:	6422                	ld	s0,8(sp)
    800039fc:	0141                	addi	sp,sp,16
    800039fe:	8082                	ret

0000000080003a00 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a00:	457c                	lw	a5,76(a0)
    80003a02:	0ed7e963          	bltu	a5,a3,80003af4 <readi+0xf4>
{
    80003a06:	7159                	addi	sp,sp,-112
    80003a08:	f486                	sd	ra,104(sp)
    80003a0a:	f0a2                	sd	s0,96(sp)
    80003a0c:	eca6                	sd	s1,88(sp)
    80003a0e:	e8ca                	sd	s2,80(sp)
    80003a10:	e4ce                	sd	s3,72(sp)
    80003a12:	e0d2                	sd	s4,64(sp)
    80003a14:	fc56                	sd	s5,56(sp)
    80003a16:	f85a                	sd	s6,48(sp)
    80003a18:	f45e                	sd	s7,40(sp)
    80003a1a:	f062                	sd	s8,32(sp)
    80003a1c:	ec66                	sd	s9,24(sp)
    80003a1e:	e86a                	sd	s10,16(sp)
    80003a20:	e46e                	sd	s11,8(sp)
    80003a22:	1880                	addi	s0,sp,112
    80003a24:	8b2a                	mv	s6,a0
    80003a26:	8bae                	mv	s7,a1
    80003a28:	8a32                	mv	s4,a2
    80003a2a:	84b6                	mv	s1,a3
    80003a2c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a2e:	9f35                	addw	a4,a4,a3
    return 0;
    80003a30:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a32:	0ad76063          	bltu	a4,a3,80003ad2 <readi+0xd2>
  if(off + n > ip->size)
    80003a36:	00e7f463          	bgeu	a5,a4,80003a3e <readi+0x3e>
    n = ip->size - off;
    80003a3a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a3e:	0a0a8963          	beqz	s5,80003af0 <readi+0xf0>
    80003a42:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a44:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a48:	5c7d                	li	s8,-1
    80003a4a:	a82d                	j	80003a84 <readi+0x84>
    80003a4c:	020d1d93          	slli	s11,s10,0x20
    80003a50:	020ddd93          	srli	s11,s11,0x20
    80003a54:	05890793          	addi	a5,s2,88
    80003a58:	86ee                	mv	a3,s11
    80003a5a:	963e                	add	a2,a2,a5
    80003a5c:	85d2                	mv	a1,s4
    80003a5e:	855e                	mv	a0,s7
    80003a60:	fffff097          	auipc	ra,0xfffff
    80003a64:	aca080e7          	jalr	-1334(ra) # 8000252a <either_copyout>
    80003a68:	05850d63          	beq	a0,s8,80003ac2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	fffff097          	auipc	ra,0xfffff
    80003a72:	5f4080e7          	jalr	1524(ra) # 80003062 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a76:	013d09bb          	addw	s3,s10,s3
    80003a7a:	009d04bb          	addw	s1,s10,s1
    80003a7e:	9a6e                	add	s4,s4,s11
    80003a80:	0559f763          	bgeu	s3,s5,80003ace <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003a84:	00a4d59b          	srliw	a1,s1,0xa
    80003a88:	855a                	mv	a0,s6
    80003a8a:	00000097          	auipc	ra,0x0
    80003a8e:	8a2080e7          	jalr	-1886(ra) # 8000332c <bmap>
    80003a92:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003a96:	cd85                	beqz	a1,80003ace <readi+0xce>
    bp = bread(ip->dev, addr);
    80003a98:	000b2503          	lw	a0,0(s6)
    80003a9c:	fffff097          	auipc	ra,0xfffff
    80003aa0:	496080e7          	jalr	1174(ra) # 80002f32 <bread>
    80003aa4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aa6:	3ff4f613          	andi	a2,s1,1023
    80003aaa:	40cc87bb          	subw	a5,s9,a2
    80003aae:	413a873b          	subw	a4,s5,s3
    80003ab2:	8d3e                	mv	s10,a5
    80003ab4:	2781                	sext.w	a5,a5
    80003ab6:	0007069b          	sext.w	a3,a4
    80003aba:	f8f6f9e3          	bgeu	a3,a5,80003a4c <readi+0x4c>
    80003abe:	8d3a                	mv	s10,a4
    80003ac0:	b771                	j	80003a4c <readi+0x4c>
      brelse(bp);
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	fffff097          	auipc	ra,0xfffff
    80003ac8:	59e080e7          	jalr	1438(ra) # 80003062 <brelse>
      tot = -1;
    80003acc:	59fd                	li	s3,-1
  }
  return tot;
    80003ace:	0009851b          	sext.w	a0,s3
}
    80003ad2:	70a6                	ld	ra,104(sp)
    80003ad4:	7406                	ld	s0,96(sp)
    80003ad6:	64e6                	ld	s1,88(sp)
    80003ad8:	6946                	ld	s2,80(sp)
    80003ada:	69a6                	ld	s3,72(sp)
    80003adc:	6a06                	ld	s4,64(sp)
    80003ade:	7ae2                	ld	s5,56(sp)
    80003ae0:	7b42                	ld	s6,48(sp)
    80003ae2:	7ba2                	ld	s7,40(sp)
    80003ae4:	7c02                	ld	s8,32(sp)
    80003ae6:	6ce2                	ld	s9,24(sp)
    80003ae8:	6d42                	ld	s10,16(sp)
    80003aea:	6da2                	ld	s11,8(sp)
    80003aec:	6165                	addi	sp,sp,112
    80003aee:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003af0:	89d6                	mv	s3,s5
    80003af2:	bff1                	j	80003ace <readi+0xce>
    return 0;
    80003af4:	4501                	li	a0,0
}
    80003af6:	8082                	ret

0000000080003af8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003af8:	457c                	lw	a5,76(a0)
    80003afa:	10d7e863          	bltu	a5,a3,80003c0a <writei+0x112>
{
    80003afe:	7159                	addi	sp,sp,-112
    80003b00:	f486                	sd	ra,104(sp)
    80003b02:	f0a2                	sd	s0,96(sp)
    80003b04:	eca6                	sd	s1,88(sp)
    80003b06:	e8ca                	sd	s2,80(sp)
    80003b08:	e4ce                	sd	s3,72(sp)
    80003b0a:	e0d2                	sd	s4,64(sp)
    80003b0c:	fc56                	sd	s5,56(sp)
    80003b0e:	f85a                	sd	s6,48(sp)
    80003b10:	f45e                	sd	s7,40(sp)
    80003b12:	f062                	sd	s8,32(sp)
    80003b14:	ec66                	sd	s9,24(sp)
    80003b16:	e86a                	sd	s10,16(sp)
    80003b18:	e46e                	sd	s11,8(sp)
    80003b1a:	1880                	addi	s0,sp,112
    80003b1c:	8aaa                	mv	s5,a0
    80003b1e:	8bae                	mv	s7,a1
    80003b20:	8a32                	mv	s4,a2
    80003b22:	8936                	mv	s2,a3
    80003b24:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b26:	00e687bb          	addw	a5,a3,a4
    80003b2a:	0ed7e263          	bltu	a5,a3,80003c0e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b2e:	00043737          	lui	a4,0x43
    80003b32:	0ef76063          	bltu	a4,a5,80003c12 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b36:	0c0b0863          	beqz	s6,80003c06 <writei+0x10e>
    80003b3a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b3c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b40:	5c7d                	li	s8,-1
    80003b42:	a091                	j	80003b86 <writei+0x8e>
    80003b44:	020d1d93          	slli	s11,s10,0x20
    80003b48:	020ddd93          	srli	s11,s11,0x20
    80003b4c:	05848793          	addi	a5,s1,88
    80003b50:	86ee                	mv	a3,s11
    80003b52:	8652                	mv	a2,s4
    80003b54:	85de                	mv	a1,s7
    80003b56:	953e                	add	a0,a0,a5
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	a28080e7          	jalr	-1496(ra) # 80002580 <either_copyin>
    80003b60:	07850263          	beq	a0,s8,80003bc4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b64:	8526                	mv	a0,s1
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	780080e7          	jalr	1920(ra) # 800042e6 <log_write>
    brelse(bp);
    80003b6e:	8526                	mv	a0,s1
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	4f2080e7          	jalr	1266(ra) # 80003062 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b78:	013d09bb          	addw	s3,s10,s3
    80003b7c:	012d093b          	addw	s2,s10,s2
    80003b80:	9a6e                	add	s4,s4,s11
    80003b82:	0569f663          	bgeu	s3,s6,80003bce <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003b86:	00a9559b          	srliw	a1,s2,0xa
    80003b8a:	8556                	mv	a0,s5
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	7a0080e7          	jalr	1952(ra) # 8000332c <bmap>
    80003b94:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003b98:	c99d                	beqz	a1,80003bce <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003b9a:	000aa503          	lw	a0,0(s5)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	394080e7          	jalr	916(ra) # 80002f32 <bread>
    80003ba6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ba8:	3ff97513          	andi	a0,s2,1023
    80003bac:	40ac87bb          	subw	a5,s9,a0
    80003bb0:	413b073b          	subw	a4,s6,s3
    80003bb4:	8d3e                	mv	s10,a5
    80003bb6:	2781                	sext.w	a5,a5
    80003bb8:	0007069b          	sext.w	a3,a4
    80003bbc:	f8f6f4e3          	bgeu	a3,a5,80003b44 <writei+0x4c>
    80003bc0:	8d3a                	mv	s10,a4
    80003bc2:	b749                	j	80003b44 <writei+0x4c>
      brelse(bp);
    80003bc4:	8526                	mv	a0,s1
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	49c080e7          	jalr	1180(ra) # 80003062 <brelse>
  }

  if(off > ip->size)
    80003bce:	04caa783          	lw	a5,76(s5)
    80003bd2:	0127f463          	bgeu	a5,s2,80003bda <writei+0xe2>
    ip->size = off;
    80003bd6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003bda:	8556                	mv	a0,s5
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	aa6080e7          	jalr	-1370(ra) # 80003682 <iupdate>

  return tot;
    80003be4:	0009851b          	sext.w	a0,s3
}
    80003be8:	70a6                	ld	ra,104(sp)
    80003bea:	7406                	ld	s0,96(sp)
    80003bec:	64e6                	ld	s1,88(sp)
    80003bee:	6946                	ld	s2,80(sp)
    80003bf0:	69a6                	ld	s3,72(sp)
    80003bf2:	6a06                	ld	s4,64(sp)
    80003bf4:	7ae2                	ld	s5,56(sp)
    80003bf6:	7b42                	ld	s6,48(sp)
    80003bf8:	7ba2                	ld	s7,40(sp)
    80003bfa:	7c02                	ld	s8,32(sp)
    80003bfc:	6ce2                	ld	s9,24(sp)
    80003bfe:	6d42                	ld	s10,16(sp)
    80003c00:	6da2                	ld	s11,8(sp)
    80003c02:	6165                	addi	sp,sp,112
    80003c04:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c06:	89da                	mv	s3,s6
    80003c08:	bfc9                	j	80003bda <writei+0xe2>
    return -1;
    80003c0a:	557d                	li	a0,-1
}
    80003c0c:	8082                	ret
    return -1;
    80003c0e:	557d                	li	a0,-1
    80003c10:	bfe1                	j	80003be8 <writei+0xf0>
    return -1;
    80003c12:	557d                	li	a0,-1
    80003c14:	bfd1                	j	80003be8 <writei+0xf0>

0000000080003c16 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c16:	1141                	addi	sp,sp,-16
    80003c18:	e406                	sd	ra,8(sp)
    80003c1a:	e022                	sd	s0,0(sp)
    80003c1c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c1e:	4639                	li	a2,14
    80003c20:	ffffd097          	auipc	ra,0xffffd
    80003c24:	182080e7          	jalr	386(ra) # 80000da2 <strncmp>
}
    80003c28:	60a2                	ld	ra,8(sp)
    80003c2a:	6402                	ld	s0,0(sp)
    80003c2c:	0141                	addi	sp,sp,16
    80003c2e:	8082                	ret

0000000080003c30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c30:	7139                	addi	sp,sp,-64
    80003c32:	fc06                	sd	ra,56(sp)
    80003c34:	f822                	sd	s0,48(sp)
    80003c36:	f426                	sd	s1,40(sp)
    80003c38:	f04a                	sd	s2,32(sp)
    80003c3a:	ec4e                	sd	s3,24(sp)
    80003c3c:	e852                	sd	s4,16(sp)
    80003c3e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c40:	04451703          	lh	a4,68(a0)
    80003c44:	4785                	li	a5,1
    80003c46:	00f71a63          	bne	a4,a5,80003c5a <dirlookup+0x2a>
    80003c4a:	892a                	mv	s2,a0
    80003c4c:	89ae                	mv	s3,a1
    80003c4e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c50:	457c                	lw	a5,76(a0)
    80003c52:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c54:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c56:	e79d                	bnez	a5,80003c84 <dirlookup+0x54>
    80003c58:	a8a5                	j	80003cd0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c5a:	00005517          	auipc	a0,0x5
    80003c5e:	9ae50513          	addi	a0,a0,-1618 # 80008608 <syscalls+0x1a8>
    80003c62:	ffffd097          	auipc	ra,0xffffd
    80003c66:	8dc080e7          	jalr	-1828(ra) # 8000053e <panic>
      panic("dirlookup read");
    80003c6a:	00005517          	auipc	a0,0x5
    80003c6e:	9b650513          	addi	a0,a0,-1610 # 80008620 <syscalls+0x1c0>
    80003c72:	ffffd097          	auipc	ra,0xffffd
    80003c76:	8cc080e7          	jalr	-1844(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c7a:	24c1                	addiw	s1,s1,16
    80003c7c:	04c92783          	lw	a5,76(s2)
    80003c80:	04f4f763          	bgeu	s1,a5,80003cce <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c84:	4741                	li	a4,16
    80003c86:	86a6                	mv	a3,s1
    80003c88:	fc040613          	addi	a2,s0,-64
    80003c8c:	4581                	li	a1,0
    80003c8e:	854a                	mv	a0,s2
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	d70080e7          	jalr	-656(ra) # 80003a00 <readi>
    80003c98:	47c1                	li	a5,16
    80003c9a:	fcf518e3          	bne	a0,a5,80003c6a <dirlookup+0x3a>
    if(de.inum == 0)
    80003c9e:	fc045783          	lhu	a5,-64(s0)
    80003ca2:	dfe1                	beqz	a5,80003c7a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003ca4:	fc240593          	addi	a1,s0,-62
    80003ca8:	854e                	mv	a0,s3
    80003caa:	00000097          	auipc	ra,0x0
    80003cae:	f6c080e7          	jalr	-148(ra) # 80003c16 <namecmp>
    80003cb2:	f561                	bnez	a0,80003c7a <dirlookup+0x4a>
      if(poff)
    80003cb4:	000a0463          	beqz	s4,80003cbc <dirlookup+0x8c>
        *poff = off;
    80003cb8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cbc:	fc045583          	lhu	a1,-64(s0)
    80003cc0:	00092503          	lw	a0,0(s2)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	750080e7          	jalr	1872(ra) # 80003414 <iget>
    80003ccc:	a011                	j	80003cd0 <dirlookup+0xa0>
  return 0;
    80003cce:	4501                	li	a0,0
}
    80003cd0:	70e2                	ld	ra,56(sp)
    80003cd2:	7442                	ld	s0,48(sp)
    80003cd4:	74a2                	ld	s1,40(sp)
    80003cd6:	7902                	ld	s2,32(sp)
    80003cd8:	69e2                	ld	s3,24(sp)
    80003cda:	6a42                	ld	s4,16(sp)
    80003cdc:	6121                	addi	sp,sp,64
    80003cde:	8082                	ret

0000000080003ce0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ce0:	711d                	addi	sp,sp,-96
    80003ce2:	ec86                	sd	ra,88(sp)
    80003ce4:	e8a2                	sd	s0,80(sp)
    80003ce6:	e4a6                	sd	s1,72(sp)
    80003ce8:	e0ca                	sd	s2,64(sp)
    80003cea:	fc4e                	sd	s3,56(sp)
    80003cec:	f852                	sd	s4,48(sp)
    80003cee:	f456                	sd	s5,40(sp)
    80003cf0:	f05a                	sd	s6,32(sp)
    80003cf2:	ec5e                	sd	s7,24(sp)
    80003cf4:	e862                	sd	s8,16(sp)
    80003cf6:	e466                	sd	s9,8(sp)
    80003cf8:	1080                	addi	s0,sp,96
    80003cfa:	84aa                	mv	s1,a0
    80003cfc:	8aae                	mv	s5,a1
    80003cfe:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d00:	00054703          	lbu	a4,0(a0)
    80003d04:	02f00793          	li	a5,47
    80003d08:	02f70363          	beq	a4,a5,80003d2e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d0c:	ffffe097          	auipc	ra,0xffffe
    80003d10:	ca0080e7          	jalr	-864(ra) # 800019ac <myproc>
    80003d14:	18053503          	ld	a0,384(a0)
    80003d18:	00000097          	auipc	ra,0x0
    80003d1c:	9f6080e7          	jalr	-1546(ra) # 8000370e <idup>
    80003d20:	89aa                	mv	s3,a0
  while(*path == '/')
    80003d22:	02f00913          	li	s2,47
  len = path - s;
    80003d26:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003d28:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d2a:	4b85                	li	s7,1
    80003d2c:	a865                	j	80003de4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003d2e:	4585                	li	a1,1
    80003d30:	4505                	li	a0,1
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	6e2080e7          	jalr	1762(ra) # 80003414 <iget>
    80003d3a:	89aa                	mv	s3,a0
    80003d3c:	b7dd                	j	80003d22 <namex+0x42>
      iunlockput(ip);
    80003d3e:	854e                	mv	a0,s3
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	c6e080e7          	jalr	-914(ra) # 800039ae <iunlockput>
      return 0;
    80003d48:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d4a:	854e                	mv	a0,s3
    80003d4c:	60e6                	ld	ra,88(sp)
    80003d4e:	6446                	ld	s0,80(sp)
    80003d50:	64a6                	ld	s1,72(sp)
    80003d52:	6906                	ld	s2,64(sp)
    80003d54:	79e2                	ld	s3,56(sp)
    80003d56:	7a42                	ld	s4,48(sp)
    80003d58:	7aa2                	ld	s5,40(sp)
    80003d5a:	7b02                	ld	s6,32(sp)
    80003d5c:	6be2                	ld	s7,24(sp)
    80003d5e:	6c42                	ld	s8,16(sp)
    80003d60:	6ca2                	ld	s9,8(sp)
    80003d62:	6125                	addi	sp,sp,96
    80003d64:	8082                	ret
      iunlock(ip);
    80003d66:	854e                	mv	a0,s3
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	aa6080e7          	jalr	-1370(ra) # 8000380e <iunlock>
      return ip;
    80003d70:	bfe9                	j	80003d4a <namex+0x6a>
      iunlockput(ip);
    80003d72:	854e                	mv	a0,s3
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	c3a080e7          	jalr	-966(ra) # 800039ae <iunlockput>
      return 0;
    80003d7c:	89e6                	mv	s3,s9
    80003d7e:	b7f1                	j	80003d4a <namex+0x6a>
  len = path - s;
    80003d80:	40b48633          	sub	a2,s1,a1
    80003d84:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d88:	099c5463          	bge	s8,s9,80003e10 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d8c:	4639                	li	a2,14
    80003d8e:	8552                	mv	a0,s4
    80003d90:	ffffd097          	auipc	ra,0xffffd
    80003d94:	f9e080e7          	jalr	-98(ra) # 80000d2e <memmove>
  while(*path == '/')
    80003d98:	0004c783          	lbu	a5,0(s1)
    80003d9c:	01279763          	bne	a5,s2,80003daa <namex+0xca>
    path++;
    80003da0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003da2:	0004c783          	lbu	a5,0(s1)
    80003da6:	ff278de3          	beq	a5,s2,80003da0 <namex+0xc0>
    ilock(ip);
    80003daa:	854e                	mv	a0,s3
    80003dac:	00000097          	auipc	ra,0x0
    80003db0:	9a0080e7          	jalr	-1632(ra) # 8000374c <ilock>
    if(ip->type != T_DIR){
    80003db4:	04499783          	lh	a5,68(s3)
    80003db8:	f97793e3          	bne	a5,s7,80003d3e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003dbc:	000a8563          	beqz	s5,80003dc6 <namex+0xe6>
    80003dc0:	0004c783          	lbu	a5,0(s1)
    80003dc4:	d3cd                	beqz	a5,80003d66 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dc6:	865a                	mv	a2,s6
    80003dc8:	85d2                	mv	a1,s4
    80003dca:	854e                	mv	a0,s3
    80003dcc:	00000097          	auipc	ra,0x0
    80003dd0:	e64080e7          	jalr	-412(ra) # 80003c30 <dirlookup>
    80003dd4:	8caa                	mv	s9,a0
    80003dd6:	dd51                	beqz	a0,80003d72 <namex+0x92>
    iunlockput(ip);
    80003dd8:	854e                	mv	a0,s3
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	bd4080e7          	jalr	-1068(ra) # 800039ae <iunlockput>
    ip = next;
    80003de2:	89e6                	mv	s3,s9
  while(*path == '/')
    80003de4:	0004c783          	lbu	a5,0(s1)
    80003de8:	05279763          	bne	a5,s2,80003e36 <namex+0x156>
    path++;
    80003dec:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dee:	0004c783          	lbu	a5,0(s1)
    80003df2:	ff278de3          	beq	a5,s2,80003dec <namex+0x10c>
  if(*path == 0)
    80003df6:	c79d                	beqz	a5,80003e24 <namex+0x144>
    path++;
    80003df8:	85a6                	mv	a1,s1
  len = path - s;
    80003dfa:	8cda                	mv	s9,s6
    80003dfc:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003dfe:	01278963          	beq	a5,s2,80003e10 <namex+0x130>
    80003e02:	dfbd                	beqz	a5,80003d80 <namex+0xa0>
    path++;
    80003e04:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003e06:	0004c783          	lbu	a5,0(s1)
    80003e0a:	ff279ce3          	bne	a5,s2,80003e02 <namex+0x122>
    80003e0e:	bf8d                	j	80003d80 <namex+0xa0>
    memmove(name, s, len);
    80003e10:	2601                	sext.w	a2,a2
    80003e12:	8552                	mv	a0,s4
    80003e14:	ffffd097          	auipc	ra,0xffffd
    80003e18:	f1a080e7          	jalr	-230(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003e1c:	9cd2                	add	s9,s9,s4
    80003e1e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e22:	bf9d                	j	80003d98 <namex+0xb8>
  if(nameiparent){
    80003e24:	f20a83e3          	beqz	s5,80003d4a <namex+0x6a>
    iput(ip);
    80003e28:	854e                	mv	a0,s3
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	adc080e7          	jalr	-1316(ra) # 80003906 <iput>
    return 0;
    80003e32:	4981                	li	s3,0
    80003e34:	bf19                	j	80003d4a <namex+0x6a>
  if(*path == 0)
    80003e36:	d7fd                	beqz	a5,80003e24 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e38:	0004c783          	lbu	a5,0(s1)
    80003e3c:	85a6                	mv	a1,s1
    80003e3e:	b7d1                	j	80003e02 <namex+0x122>

0000000080003e40 <dirlink>:
{
    80003e40:	7139                	addi	sp,sp,-64
    80003e42:	fc06                	sd	ra,56(sp)
    80003e44:	f822                	sd	s0,48(sp)
    80003e46:	f426                	sd	s1,40(sp)
    80003e48:	f04a                	sd	s2,32(sp)
    80003e4a:	ec4e                	sd	s3,24(sp)
    80003e4c:	e852                	sd	s4,16(sp)
    80003e4e:	0080                	addi	s0,sp,64
    80003e50:	892a                	mv	s2,a0
    80003e52:	8a2e                	mv	s4,a1
    80003e54:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e56:	4601                	li	a2,0
    80003e58:	00000097          	auipc	ra,0x0
    80003e5c:	dd8080e7          	jalr	-552(ra) # 80003c30 <dirlookup>
    80003e60:	e93d                	bnez	a0,80003ed6 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e62:	04c92483          	lw	s1,76(s2)
    80003e66:	c49d                	beqz	s1,80003e94 <dirlink+0x54>
    80003e68:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e6a:	4741                	li	a4,16
    80003e6c:	86a6                	mv	a3,s1
    80003e6e:	fc040613          	addi	a2,s0,-64
    80003e72:	4581                	li	a1,0
    80003e74:	854a                	mv	a0,s2
    80003e76:	00000097          	auipc	ra,0x0
    80003e7a:	b8a080e7          	jalr	-1142(ra) # 80003a00 <readi>
    80003e7e:	47c1                	li	a5,16
    80003e80:	06f51163          	bne	a0,a5,80003ee2 <dirlink+0xa2>
    if(de.inum == 0)
    80003e84:	fc045783          	lhu	a5,-64(s0)
    80003e88:	c791                	beqz	a5,80003e94 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e8a:	24c1                	addiw	s1,s1,16
    80003e8c:	04c92783          	lw	a5,76(s2)
    80003e90:	fcf4ede3          	bltu	s1,a5,80003e6a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e94:	4639                	li	a2,14
    80003e96:	85d2                	mv	a1,s4
    80003e98:	fc240513          	addi	a0,s0,-62
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	f42080e7          	jalr	-190(ra) # 80000dde <strncpy>
  de.inum = inum;
    80003ea4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ea8:	4741                	li	a4,16
    80003eaa:	86a6                	mv	a3,s1
    80003eac:	fc040613          	addi	a2,s0,-64
    80003eb0:	4581                	li	a1,0
    80003eb2:	854a                	mv	a0,s2
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	c44080e7          	jalr	-956(ra) # 80003af8 <writei>
    80003ebc:	1541                	addi	a0,a0,-16
    80003ebe:	00a03533          	snez	a0,a0
    80003ec2:	40a00533          	neg	a0,a0
}
    80003ec6:	70e2                	ld	ra,56(sp)
    80003ec8:	7442                	ld	s0,48(sp)
    80003eca:	74a2                	ld	s1,40(sp)
    80003ecc:	7902                	ld	s2,32(sp)
    80003ece:	69e2                	ld	s3,24(sp)
    80003ed0:	6a42                	ld	s4,16(sp)
    80003ed2:	6121                	addi	sp,sp,64
    80003ed4:	8082                	ret
    iput(ip);
    80003ed6:	00000097          	auipc	ra,0x0
    80003eda:	a30080e7          	jalr	-1488(ra) # 80003906 <iput>
    return -1;
    80003ede:	557d                	li	a0,-1
    80003ee0:	b7dd                	j	80003ec6 <dirlink+0x86>
      panic("dirlink read");
    80003ee2:	00004517          	auipc	a0,0x4
    80003ee6:	74e50513          	addi	a0,a0,1870 # 80008630 <syscalls+0x1d0>
    80003eea:	ffffc097          	auipc	ra,0xffffc
    80003eee:	654080e7          	jalr	1620(ra) # 8000053e <panic>

0000000080003ef2 <namei>:

struct inode*
namei(char *path)
{
    80003ef2:	1101                	addi	sp,sp,-32
    80003ef4:	ec06                	sd	ra,24(sp)
    80003ef6:	e822                	sd	s0,16(sp)
    80003ef8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003efa:	fe040613          	addi	a2,s0,-32
    80003efe:	4581                	li	a1,0
    80003f00:	00000097          	auipc	ra,0x0
    80003f04:	de0080e7          	jalr	-544(ra) # 80003ce0 <namex>
}
    80003f08:	60e2                	ld	ra,24(sp)
    80003f0a:	6442                	ld	s0,16(sp)
    80003f0c:	6105                	addi	sp,sp,32
    80003f0e:	8082                	ret

0000000080003f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f10:	1141                	addi	sp,sp,-16
    80003f12:	e406                	sd	ra,8(sp)
    80003f14:	e022                	sd	s0,0(sp)
    80003f16:	0800                	addi	s0,sp,16
    80003f18:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f1a:	4585                	li	a1,1
    80003f1c:	00000097          	auipc	ra,0x0
    80003f20:	dc4080e7          	jalr	-572(ra) # 80003ce0 <namex>
}
    80003f24:	60a2                	ld	ra,8(sp)
    80003f26:	6402                	ld	s0,0(sp)
    80003f28:	0141                	addi	sp,sp,16
    80003f2a:	8082                	ret

0000000080003f2c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f2c:	1101                	addi	sp,sp,-32
    80003f2e:	ec06                	sd	ra,24(sp)
    80003f30:	e822                	sd	s0,16(sp)
    80003f32:	e426                	sd	s1,8(sp)
    80003f34:	e04a                	sd	s2,0(sp)
    80003f36:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f38:	0001e917          	auipc	s2,0x1e
    80003f3c:	80890913          	addi	s2,s2,-2040 # 80021740 <log>
    80003f40:	01892583          	lw	a1,24(s2)
    80003f44:	02892503          	lw	a0,40(s2)
    80003f48:	fffff097          	auipc	ra,0xfffff
    80003f4c:	fea080e7          	jalr	-22(ra) # 80002f32 <bread>
    80003f50:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f52:	02c92683          	lw	a3,44(s2)
    80003f56:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f58:	02d05763          	blez	a3,80003f86 <write_head+0x5a>
    80003f5c:	0001e797          	auipc	a5,0x1e
    80003f60:	81478793          	addi	a5,a5,-2028 # 80021770 <log+0x30>
    80003f64:	05c50713          	addi	a4,a0,92
    80003f68:	36fd                	addiw	a3,a3,-1
    80003f6a:	1682                	slli	a3,a3,0x20
    80003f6c:	9281                	srli	a3,a3,0x20
    80003f6e:	068a                	slli	a3,a3,0x2
    80003f70:	0001e617          	auipc	a2,0x1e
    80003f74:	80460613          	addi	a2,a2,-2044 # 80021774 <log+0x34>
    80003f78:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f7a:	4390                	lw	a2,0(a5)
    80003f7c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f7e:	0791                	addi	a5,a5,4
    80003f80:	0711                	addi	a4,a4,4
    80003f82:	fed79ce3          	bne	a5,a3,80003f7a <write_head+0x4e>
  }
  bwrite(buf);
    80003f86:	8526                	mv	a0,s1
    80003f88:	fffff097          	auipc	ra,0xfffff
    80003f8c:	09c080e7          	jalr	156(ra) # 80003024 <bwrite>
  brelse(buf);
    80003f90:	8526                	mv	a0,s1
    80003f92:	fffff097          	auipc	ra,0xfffff
    80003f96:	0d0080e7          	jalr	208(ra) # 80003062 <brelse>
}
    80003f9a:	60e2                	ld	ra,24(sp)
    80003f9c:	6442                	ld	s0,16(sp)
    80003f9e:	64a2                	ld	s1,8(sp)
    80003fa0:	6902                	ld	s2,0(sp)
    80003fa2:	6105                	addi	sp,sp,32
    80003fa4:	8082                	ret

0000000080003fa6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fa6:	0001d797          	auipc	a5,0x1d
    80003faa:	7c67a783          	lw	a5,1990(a5) # 8002176c <log+0x2c>
    80003fae:	0af05d63          	blez	a5,80004068 <install_trans+0xc2>
{
    80003fb2:	7139                	addi	sp,sp,-64
    80003fb4:	fc06                	sd	ra,56(sp)
    80003fb6:	f822                	sd	s0,48(sp)
    80003fb8:	f426                	sd	s1,40(sp)
    80003fba:	f04a                	sd	s2,32(sp)
    80003fbc:	ec4e                	sd	s3,24(sp)
    80003fbe:	e852                	sd	s4,16(sp)
    80003fc0:	e456                	sd	s5,8(sp)
    80003fc2:	e05a                	sd	s6,0(sp)
    80003fc4:	0080                	addi	s0,sp,64
    80003fc6:	8b2a                	mv	s6,a0
    80003fc8:	0001da97          	auipc	s5,0x1d
    80003fcc:	7a8a8a93          	addi	s5,s5,1960 # 80021770 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fd2:	0001d997          	auipc	s3,0x1d
    80003fd6:	76e98993          	addi	s3,s3,1902 # 80021740 <log>
    80003fda:	a00d                	j	80003ffc <install_trans+0x56>
    brelse(lbuf);
    80003fdc:	854a                	mv	a0,s2
    80003fde:	fffff097          	auipc	ra,0xfffff
    80003fe2:	084080e7          	jalr	132(ra) # 80003062 <brelse>
    brelse(dbuf);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	fffff097          	auipc	ra,0xfffff
    80003fec:	07a080e7          	jalr	122(ra) # 80003062 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ff0:	2a05                	addiw	s4,s4,1
    80003ff2:	0a91                	addi	s5,s5,4
    80003ff4:	02c9a783          	lw	a5,44(s3)
    80003ff8:	04fa5e63          	bge	s4,a5,80004054 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003ffc:	0189a583          	lw	a1,24(s3)
    80004000:	014585bb          	addw	a1,a1,s4
    80004004:	2585                	addiw	a1,a1,1
    80004006:	0289a503          	lw	a0,40(s3)
    8000400a:	fffff097          	auipc	ra,0xfffff
    8000400e:	f28080e7          	jalr	-216(ra) # 80002f32 <bread>
    80004012:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004014:	000aa583          	lw	a1,0(s5)
    80004018:	0289a503          	lw	a0,40(s3)
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	f16080e7          	jalr	-234(ra) # 80002f32 <bread>
    80004024:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004026:	40000613          	li	a2,1024
    8000402a:	05890593          	addi	a1,s2,88
    8000402e:	05850513          	addi	a0,a0,88
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	cfc080e7          	jalr	-772(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    8000403a:	8526                	mv	a0,s1
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	fe8080e7          	jalr	-24(ra) # 80003024 <bwrite>
    if(recovering == 0)
    80004044:	f80b1ce3          	bnez	s6,80003fdc <install_trans+0x36>
      bunpin(dbuf);
    80004048:	8526                	mv	a0,s1
    8000404a:	fffff097          	auipc	ra,0xfffff
    8000404e:	0f2080e7          	jalr	242(ra) # 8000313c <bunpin>
    80004052:	b769                	j	80003fdc <install_trans+0x36>
}
    80004054:	70e2                	ld	ra,56(sp)
    80004056:	7442                	ld	s0,48(sp)
    80004058:	74a2                	ld	s1,40(sp)
    8000405a:	7902                	ld	s2,32(sp)
    8000405c:	69e2                	ld	s3,24(sp)
    8000405e:	6a42                	ld	s4,16(sp)
    80004060:	6aa2                	ld	s5,8(sp)
    80004062:	6b02                	ld	s6,0(sp)
    80004064:	6121                	addi	sp,sp,64
    80004066:	8082                	ret
    80004068:	8082                	ret

000000008000406a <initlog>:
{
    8000406a:	7179                	addi	sp,sp,-48
    8000406c:	f406                	sd	ra,40(sp)
    8000406e:	f022                	sd	s0,32(sp)
    80004070:	ec26                	sd	s1,24(sp)
    80004072:	e84a                	sd	s2,16(sp)
    80004074:	e44e                	sd	s3,8(sp)
    80004076:	1800                	addi	s0,sp,48
    80004078:	892a                	mv	s2,a0
    8000407a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000407c:	0001d497          	auipc	s1,0x1d
    80004080:	6c448493          	addi	s1,s1,1732 # 80021740 <log>
    80004084:	00004597          	auipc	a1,0x4
    80004088:	5bc58593          	addi	a1,a1,1468 # 80008640 <syscalls+0x1e0>
    8000408c:	8526                	mv	a0,s1
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	ab8080e7          	jalr	-1352(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    80004096:	0149a583          	lw	a1,20(s3)
    8000409a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000409c:	0109a783          	lw	a5,16(s3)
    800040a0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040a2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040a6:	854a                	mv	a0,s2
    800040a8:	fffff097          	auipc	ra,0xfffff
    800040ac:	e8a080e7          	jalr	-374(ra) # 80002f32 <bread>
  log.lh.n = lh->n;
    800040b0:	4d34                	lw	a3,88(a0)
    800040b2:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040b4:	02d05563          	blez	a3,800040de <initlog+0x74>
    800040b8:	05c50793          	addi	a5,a0,92
    800040bc:	0001d717          	auipc	a4,0x1d
    800040c0:	6b470713          	addi	a4,a4,1716 # 80021770 <log+0x30>
    800040c4:	36fd                	addiw	a3,a3,-1
    800040c6:	1682                	slli	a3,a3,0x20
    800040c8:	9281                	srli	a3,a3,0x20
    800040ca:	068a                	slli	a3,a3,0x2
    800040cc:	06050613          	addi	a2,a0,96
    800040d0:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800040d2:	4390                	lw	a2,0(a5)
    800040d4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040d6:	0791                	addi	a5,a5,4
    800040d8:	0711                	addi	a4,a4,4
    800040da:	fed79ce3          	bne	a5,a3,800040d2 <initlog+0x68>
  brelse(buf);
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	f84080e7          	jalr	-124(ra) # 80003062 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040e6:	4505                	li	a0,1
    800040e8:	00000097          	auipc	ra,0x0
    800040ec:	ebe080e7          	jalr	-322(ra) # 80003fa6 <install_trans>
  log.lh.n = 0;
    800040f0:	0001d797          	auipc	a5,0x1d
    800040f4:	6607ae23          	sw	zero,1660(a5) # 8002176c <log+0x2c>
  write_head(); // clear the log
    800040f8:	00000097          	auipc	ra,0x0
    800040fc:	e34080e7          	jalr	-460(ra) # 80003f2c <write_head>
}
    80004100:	70a2                	ld	ra,40(sp)
    80004102:	7402                	ld	s0,32(sp)
    80004104:	64e2                	ld	s1,24(sp)
    80004106:	6942                	ld	s2,16(sp)
    80004108:	69a2                	ld	s3,8(sp)
    8000410a:	6145                	addi	sp,sp,48
    8000410c:	8082                	ret

000000008000410e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000410e:	1101                	addi	sp,sp,-32
    80004110:	ec06                	sd	ra,24(sp)
    80004112:	e822                	sd	s0,16(sp)
    80004114:	e426                	sd	s1,8(sp)
    80004116:	e04a                	sd	s2,0(sp)
    80004118:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000411a:	0001d517          	auipc	a0,0x1d
    8000411e:	62650513          	addi	a0,a0,1574 # 80021740 <log>
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	ab4080e7          	jalr	-1356(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    8000412a:	0001d497          	auipc	s1,0x1d
    8000412e:	61648493          	addi	s1,s1,1558 # 80021740 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004132:	4979                	li	s2,30
    80004134:	a039                	j	80004142 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004136:	85a6                	mv	a1,s1
    80004138:	8526                	mv	a0,s1
    8000413a:	ffffe097          	auipc	ra,0xffffe
    8000413e:	f90080e7          	jalr	-112(ra) # 800020ca <sleep>
    if(log.committing){
    80004142:	50dc                	lw	a5,36(s1)
    80004144:	fbed                	bnez	a5,80004136 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004146:	509c                	lw	a5,32(s1)
    80004148:	0017871b          	addiw	a4,a5,1
    8000414c:	0007069b          	sext.w	a3,a4
    80004150:	0027179b          	slliw	a5,a4,0x2
    80004154:	9fb9                	addw	a5,a5,a4
    80004156:	0017979b          	slliw	a5,a5,0x1
    8000415a:	54d8                	lw	a4,44(s1)
    8000415c:	9fb9                	addw	a5,a5,a4
    8000415e:	00f95963          	bge	s2,a5,80004170 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004162:	85a6                	mv	a1,s1
    80004164:	8526                	mv	a0,s1
    80004166:	ffffe097          	auipc	ra,0xffffe
    8000416a:	f64080e7          	jalr	-156(ra) # 800020ca <sleep>
    8000416e:	bfd1                	j	80004142 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004170:	0001d517          	auipc	a0,0x1d
    80004174:	5d050513          	addi	a0,a0,1488 # 80021740 <log>
    80004178:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	b10080e7          	jalr	-1264(ra) # 80000c8a <release>
      break;
    }
  }
}
    80004182:	60e2                	ld	ra,24(sp)
    80004184:	6442                	ld	s0,16(sp)
    80004186:	64a2                	ld	s1,8(sp)
    80004188:	6902                	ld	s2,0(sp)
    8000418a:	6105                	addi	sp,sp,32
    8000418c:	8082                	ret

000000008000418e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000418e:	7139                	addi	sp,sp,-64
    80004190:	fc06                	sd	ra,56(sp)
    80004192:	f822                	sd	s0,48(sp)
    80004194:	f426                	sd	s1,40(sp)
    80004196:	f04a                	sd	s2,32(sp)
    80004198:	ec4e                	sd	s3,24(sp)
    8000419a:	e852                	sd	s4,16(sp)
    8000419c:	e456                	sd	s5,8(sp)
    8000419e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041a0:	0001d497          	auipc	s1,0x1d
    800041a4:	5a048493          	addi	s1,s1,1440 # 80021740 <log>
    800041a8:	8526                	mv	a0,s1
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	a2c080e7          	jalr	-1492(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    800041b2:	509c                	lw	a5,32(s1)
    800041b4:	37fd                	addiw	a5,a5,-1
    800041b6:	0007891b          	sext.w	s2,a5
    800041ba:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041bc:	50dc                	lw	a5,36(s1)
    800041be:	e7b9                	bnez	a5,8000420c <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041c0:	04091e63          	bnez	s2,8000421c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041c4:	0001d497          	auipc	s1,0x1d
    800041c8:	57c48493          	addi	s1,s1,1404 # 80021740 <log>
    800041cc:	4785                	li	a5,1
    800041ce:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041d0:	8526                	mv	a0,s1
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	ab8080e7          	jalr	-1352(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041da:	54dc                	lw	a5,44(s1)
    800041dc:	06f04763          	bgtz	a5,8000424a <end_op+0xbc>
    acquire(&log.lock);
    800041e0:	0001d497          	auipc	s1,0x1d
    800041e4:	56048493          	addi	s1,s1,1376 # 80021740 <log>
    800041e8:	8526                	mv	a0,s1
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	9ec080e7          	jalr	-1556(ra) # 80000bd6 <acquire>
    log.committing = 0;
    800041f2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041f6:	8526                	mv	a0,s1
    800041f8:	ffffe097          	auipc	ra,0xffffe
    800041fc:	f36080e7          	jalr	-202(ra) # 8000212e <wakeup>
    release(&log.lock);
    80004200:	8526                	mv	a0,s1
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	a88080e7          	jalr	-1400(ra) # 80000c8a <release>
}
    8000420a:	a03d                	j	80004238 <end_op+0xaa>
    panic("log.committing");
    8000420c:	00004517          	auipc	a0,0x4
    80004210:	43c50513          	addi	a0,a0,1084 # 80008648 <syscalls+0x1e8>
    80004214:	ffffc097          	auipc	ra,0xffffc
    80004218:	32a080e7          	jalr	810(ra) # 8000053e <panic>
    wakeup(&log);
    8000421c:	0001d497          	auipc	s1,0x1d
    80004220:	52448493          	addi	s1,s1,1316 # 80021740 <log>
    80004224:	8526                	mv	a0,s1
    80004226:	ffffe097          	auipc	ra,0xffffe
    8000422a:	f08080e7          	jalr	-248(ra) # 8000212e <wakeup>
  release(&log.lock);
    8000422e:	8526                	mv	a0,s1
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	a5a080e7          	jalr	-1446(ra) # 80000c8a <release>
}
    80004238:	70e2                	ld	ra,56(sp)
    8000423a:	7442                	ld	s0,48(sp)
    8000423c:	74a2                	ld	s1,40(sp)
    8000423e:	7902                	ld	s2,32(sp)
    80004240:	69e2                	ld	s3,24(sp)
    80004242:	6a42                	ld	s4,16(sp)
    80004244:	6aa2                	ld	s5,8(sp)
    80004246:	6121                	addi	sp,sp,64
    80004248:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000424a:	0001da97          	auipc	s5,0x1d
    8000424e:	526a8a93          	addi	s5,s5,1318 # 80021770 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004252:	0001da17          	auipc	s4,0x1d
    80004256:	4eea0a13          	addi	s4,s4,1262 # 80021740 <log>
    8000425a:	018a2583          	lw	a1,24(s4)
    8000425e:	012585bb          	addw	a1,a1,s2
    80004262:	2585                	addiw	a1,a1,1
    80004264:	028a2503          	lw	a0,40(s4)
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	cca080e7          	jalr	-822(ra) # 80002f32 <bread>
    80004270:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004272:	000aa583          	lw	a1,0(s5)
    80004276:	028a2503          	lw	a0,40(s4)
    8000427a:	fffff097          	auipc	ra,0xfffff
    8000427e:	cb8080e7          	jalr	-840(ra) # 80002f32 <bread>
    80004282:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004284:	40000613          	li	a2,1024
    80004288:	05850593          	addi	a1,a0,88
    8000428c:	05848513          	addi	a0,s1,88
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	a9e080e7          	jalr	-1378(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    80004298:	8526                	mv	a0,s1
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	d8a080e7          	jalr	-630(ra) # 80003024 <bwrite>
    brelse(from);
    800042a2:	854e                	mv	a0,s3
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	dbe080e7          	jalr	-578(ra) # 80003062 <brelse>
    brelse(to);
    800042ac:	8526                	mv	a0,s1
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	db4080e7          	jalr	-588(ra) # 80003062 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042b6:	2905                	addiw	s2,s2,1
    800042b8:	0a91                	addi	s5,s5,4
    800042ba:	02ca2783          	lw	a5,44(s4)
    800042be:	f8f94ee3          	blt	s2,a5,8000425a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042c2:	00000097          	auipc	ra,0x0
    800042c6:	c6a080e7          	jalr	-918(ra) # 80003f2c <write_head>
    install_trans(0); // Now install writes to home locations
    800042ca:	4501                	li	a0,0
    800042cc:	00000097          	auipc	ra,0x0
    800042d0:	cda080e7          	jalr	-806(ra) # 80003fa6 <install_trans>
    log.lh.n = 0;
    800042d4:	0001d797          	auipc	a5,0x1d
    800042d8:	4807ac23          	sw	zero,1176(a5) # 8002176c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	c50080e7          	jalr	-944(ra) # 80003f2c <write_head>
    800042e4:	bdf5                	j	800041e0 <end_op+0x52>

00000000800042e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042e6:	1101                	addi	sp,sp,-32
    800042e8:	ec06                	sd	ra,24(sp)
    800042ea:	e822                	sd	s0,16(sp)
    800042ec:	e426                	sd	s1,8(sp)
    800042ee:	e04a                	sd	s2,0(sp)
    800042f0:	1000                	addi	s0,sp,32
    800042f2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800042f4:	0001d917          	auipc	s2,0x1d
    800042f8:	44c90913          	addi	s2,s2,1100 # 80021740 <log>
    800042fc:	854a                	mv	a0,s2
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	8d8080e7          	jalr	-1832(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004306:	02c92603          	lw	a2,44(s2)
    8000430a:	47f5                	li	a5,29
    8000430c:	06c7c563          	blt	a5,a2,80004376 <log_write+0x90>
    80004310:	0001d797          	auipc	a5,0x1d
    80004314:	44c7a783          	lw	a5,1100(a5) # 8002175c <log+0x1c>
    80004318:	37fd                	addiw	a5,a5,-1
    8000431a:	04f65e63          	bge	a2,a5,80004376 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000431e:	0001d797          	auipc	a5,0x1d
    80004322:	4427a783          	lw	a5,1090(a5) # 80021760 <log+0x20>
    80004326:	06f05063          	blez	a5,80004386 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000432a:	4781                	li	a5,0
    8000432c:	06c05563          	blez	a2,80004396 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004330:	44cc                	lw	a1,12(s1)
    80004332:	0001d717          	auipc	a4,0x1d
    80004336:	43e70713          	addi	a4,a4,1086 # 80021770 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000433a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000433c:	4314                	lw	a3,0(a4)
    8000433e:	04b68c63          	beq	a3,a1,80004396 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004342:	2785                	addiw	a5,a5,1
    80004344:	0711                	addi	a4,a4,4
    80004346:	fef61be3          	bne	a2,a5,8000433c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000434a:	0621                	addi	a2,a2,8
    8000434c:	060a                	slli	a2,a2,0x2
    8000434e:	0001d797          	auipc	a5,0x1d
    80004352:	3f278793          	addi	a5,a5,1010 # 80021740 <log>
    80004356:	963e                	add	a2,a2,a5
    80004358:	44dc                	lw	a5,12(s1)
    8000435a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000435c:	8526                	mv	a0,s1
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	da2080e7          	jalr	-606(ra) # 80003100 <bpin>
    log.lh.n++;
    80004366:	0001d717          	auipc	a4,0x1d
    8000436a:	3da70713          	addi	a4,a4,986 # 80021740 <log>
    8000436e:	575c                	lw	a5,44(a4)
    80004370:	2785                	addiw	a5,a5,1
    80004372:	d75c                	sw	a5,44(a4)
    80004374:	a835                	j	800043b0 <log_write+0xca>
    panic("too big a transaction");
    80004376:	00004517          	auipc	a0,0x4
    8000437a:	2e250513          	addi	a0,a0,738 # 80008658 <syscalls+0x1f8>
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	1c0080e7          	jalr	448(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004386:	00004517          	auipc	a0,0x4
    8000438a:	2ea50513          	addi	a0,a0,746 # 80008670 <syscalls+0x210>
    8000438e:	ffffc097          	auipc	ra,0xffffc
    80004392:	1b0080e7          	jalr	432(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004396:	00878713          	addi	a4,a5,8
    8000439a:	00271693          	slli	a3,a4,0x2
    8000439e:	0001d717          	auipc	a4,0x1d
    800043a2:	3a270713          	addi	a4,a4,930 # 80021740 <log>
    800043a6:	9736                	add	a4,a4,a3
    800043a8:	44d4                	lw	a3,12(s1)
    800043aa:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043ac:	faf608e3          	beq	a2,a5,8000435c <log_write+0x76>
  }
  release(&log.lock);
    800043b0:	0001d517          	auipc	a0,0x1d
    800043b4:	39050513          	addi	a0,a0,912 # 80021740 <log>
    800043b8:	ffffd097          	auipc	ra,0xffffd
    800043bc:	8d2080e7          	jalr	-1838(ra) # 80000c8a <release>
}
    800043c0:	60e2                	ld	ra,24(sp)
    800043c2:	6442                	ld	s0,16(sp)
    800043c4:	64a2                	ld	s1,8(sp)
    800043c6:	6902                	ld	s2,0(sp)
    800043c8:	6105                	addi	sp,sp,32
    800043ca:	8082                	ret

00000000800043cc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043cc:	1101                	addi	sp,sp,-32
    800043ce:	ec06                	sd	ra,24(sp)
    800043d0:	e822                	sd	s0,16(sp)
    800043d2:	e426                	sd	s1,8(sp)
    800043d4:	e04a                	sd	s2,0(sp)
    800043d6:	1000                	addi	s0,sp,32
    800043d8:	84aa                	mv	s1,a0
    800043da:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043dc:	00004597          	auipc	a1,0x4
    800043e0:	2b458593          	addi	a1,a1,692 # 80008690 <syscalls+0x230>
    800043e4:	0521                	addi	a0,a0,8
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	760080e7          	jalr	1888(ra) # 80000b46 <initlock>
  lk->name = name;
    800043ee:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043f2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043f6:	0204a423          	sw	zero,40(s1)
}
    800043fa:	60e2                	ld	ra,24(sp)
    800043fc:	6442                	ld	s0,16(sp)
    800043fe:	64a2                	ld	s1,8(sp)
    80004400:	6902                	ld	s2,0(sp)
    80004402:	6105                	addi	sp,sp,32
    80004404:	8082                	ret

0000000080004406 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004406:	1101                	addi	sp,sp,-32
    80004408:	ec06                	sd	ra,24(sp)
    8000440a:	e822                	sd	s0,16(sp)
    8000440c:	e426                	sd	s1,8(sp)
    8000440e:	e04a                	sd	s2,0(sp)
    80004410:	1000                	addi	s0,sp,32
    80004412:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004414:	00850913          	addi	s2,a0,8
    80004418:	854a                	mv	a0,s2
    8000441a:	ffffc097          	auipc	ra,0xffffc
    8000441e:	7bc080e7          	jalr	1980(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    80004422:	409c                	lw	a5,0(s1)
    80004424:	cb89                	beqz	a5,80004436 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004426:	85ca                	mv	a1,s2
    80004428:	8526                	mv	a0,s1
    8000442a:	ffffe097          	auipc	ra,0xffffe
    8000442e:	ca0080e7          	jalr	-864(ra) # 800020ca <sleep>
  while (lk->locked) {
    80004432:	409c                	lw	a5,0(s1)
    80004434:	fbed                	bnez	a5,80004426 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004436:	4785                	li	a5,1
    80004438:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000443a:	ffffd097          	auipc	ra,0xffffd
    8000443e:	572080e7          	jalr	1394(ra) # 800019ac <myproc>
    80004442:	591c                	lw	a5,48(a0)
    80004444:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004446:	854a                	mv	a0,s2
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	842080e7          	jalr	-1982(ra) # 80000c8a <release>
}
    80004450:	60e2                	ld	ra,24(sp)
    80004452:	6442                	ld	s0,16(sp)
    80004454:	64a2                	ld	s1,8(sp)
    80004456:	6902                	ld	s2,0(sp)
    80004458:	6105                	addi	sp,sp,32
    8000445a:	8082                	ret

000000008000445c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000445c:	1101                	addi	sp,sp,-32
    8000445e:	ec06                	sd	ra,24(sp)
    80004460:	e822                	sd	s0,16(sp)
    80004462:	e426                	sd	s1,8(sp)
    80004464:	e04a                	sd	s2,0(sp)
    80004466:	1000                	addi	s0,sp,32
    80004468:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000446a:	00850913          	addi	s2,a0,8
    8000446e:	854a                	mv	a0,s2
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	766080e7          	jalr	1894(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004478:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000447c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004480:	8526                	mv	a0,s1
    80004482:	ffffe097          	auipc	ra,0xffffe
    80004486:	cac080e7          	jalr	-852(ra) # 8000212e <wakeup>
  release(&lk->lk);
    8000448a:	854a                	mv	a0,s2
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	7fe080e7          	jalr	2046(ra) # 80000c8a <release>
}
    80004494:	60e2                	ld	ra,24(sp)
    80004496:	6442                	ld	s0,16(sp)
    80004498:	64a2                	ld	s1,8(sp)
    8000449a:	6902                	ld	s2,0(sp)
    8000449c:	6105                	addi	sp,sp,32
    8000449e:	8082                	ret

00000000800044a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044a0:	7179                	addi	sp,sp,-48
    800044a2:	f406                	sd	ra,40(sp)
    800044a4:	f022                	sd	s0,32(sp)
    800044a6:	ec26                	sd	s1,24(sp)
    800044a8:	e84a                	sd	s2,16(sp)
    800044aa:	e44e                	sd	s3,8(sp)
    800044ac:	1800                	addi	s0,sp,48
    800044ae:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044b0:	00850913          	addi	s2,a0,8
    800044b4:	854a                	mv	a0,s2
    800044b6:	ffffc097          	auipc	ra,0xffffc
    800044ba:	720080e7          	jalr	1824(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044be:	409c                	lw	a5,0(s1)
    800044c0:	ef99                	bnez	a5,800044de <holdingsleep+0x3e>
    800044c2:	4481                	li	s1,0
  release(&lk->lk);
    800044c4:	854a                	mv	a0,s2
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	7c4080e7          	jalr	1988(ra) # 80000c8a <release>
  return r;
}
    800044ce:	8526                	mv	a0,s1
    800044d0:	70a2                	ld	ra,40(sp)
    800044d2:	7402                	ld	s0,32(sp)
    800044d4:	64e2                	ld	s1,24(sp)
    800044d6:	6942                	ld	s2,16(sp)
    800044d8:	69a2                	ld	s3,8(sp)
    800044da:	6145                	addi	sp,sp,48
    800044dc:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044de:	0284a983          	lw	s3,40(s1)
    800044e2:	ffffd097          	auipc	ra,0xffffd
    800044e6:	4ca080e7          	jalr	1226(ra) # 800019ac <myproc>
    800044ea:	5904                	lw	s1,48(a0)
    800044ec:	413484b3          	sub	s1,s1,s3
    800044f0:	0014b493          	seqz	s1,s1
    800044f4:	bfc1                	j	800044c4 <holdingsleep+0x24>

00000000800044f6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044f6:	1141                	addi	sp,sp,-16
    800044f8:	e406                	sd	ra,8(sp)
    800044fa:	e022                	sd	s0,0(sp)
    800044fc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044fe:	00004597          	auipc	a1,0x4
    80004502:	1a258593          	addi	a1,a1,418 # 800086a0 <syscalls+0x240>
    80004506:	0001d517          	auipc	a0,0x1d
    8000450a:	38250513          	addi	a0,a0,898 # 80021888 <ftable>
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	638080e7          	jalr	1592(ra) # 80000b46 <initlock>
}
    80004516:	60a2                	ld	ra,8(sp)
    80004518:	6402                	ld	s0,0(sp)
    8000451a:	0141                	addi	sp,sp,16
    8000451c:	8082                	ret

000000008000451e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000451e:	1101                	addi	sp,sp,-32
    80004520:	ec06                	sd	ra,24(sp)
    80004522:	e822                	sd	s0,16(sp)
    80004524:	e426                	sd	s1,8(sp)
    80004526:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004528:	0001d517          	auipc	a0,0x1d
    8000452c:	36050513          	addi	a0,a0,864 # 80021888 <ftable>
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	6a6080e7          	jalr	1702(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004538:	0001d497          	auipc	s1,0x1d
    8000453c:	36848493          	addi	s1,s1,872 # 800218a0 <ftable+0x18>
    80004540:	0001e717          	auipc	a4,0x1e
    80004544:	30070713          	addi	a4,a4,768 # 80022840 <disk>
    if(f->ref == 0){
    80004548:	40dc                	lw	a5,4(s1)
    8000454a:	cf99                	beqz	a5,80004568 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000454c:	02848493          	addi	s1,s1,40
    80004550:	fee49ce3          	bne	s1,a4,80004548 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004554:	0001d517          	auipc	a0,0x1d
    80004558:	33450513          	addi	a0,a0,820 # 80021888 <ftable>
    8000455c:	ffffc097          	auipc	ra,0xffffc
    80004560:	72e080e7          	jalr	1838(ra) # 80000c8a <release>
  return 0;
    80004564:	4481                	li	s1,0
    80004566:	a819                	j	8000457c <filealloc+0x5e>
      f->ref = 1;
    80004568:	4785                	li	a5,1
    8000456a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000456c:	0001d517          	auipc	a0,0x1d
    80004570:	31c50513          	addi	a0,a0,796 # 80021888 <ftable>
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	716080e7          	jalr	1814(ra) # 80000c8a <release>
}
    8000457c:	8526                	mv	a0,s1
    8000457e:	60e2                	ld	ra,24(sp)
    80004580:	6442                	ld	s0,16(sp)
    80004582:	64a2                	ld	s1,8(sp)
    80004584:	6105                	addi	sp,sp,32
    80004586:	8082                	ret

0000000080004588 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004588:	1101                	addi	sp,sp,-32
    8000458a:	ec06                	sd	ra,24(sp)
    8000458c:	e822                	sd	s0,16(sp)
    8000458e:	e426                	sd	s1,8(sp)
    80004590:	1000                	addi	s0,sp,32
    80004592:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004594:	0001d517          	auipc	a0,0x1d
    80004598:	2f450513          	addi	a0,a0,756 # 80021888 <ftable>
    8000459c:	ffffc097          	auipc	ra,0xffffc
    800045a0:	63a080e7          	jalr	1594(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800045a4:	40dc                	lw	a5,4(s1)
    800045a6:	02f05263          	blez	a5,800045ca <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045aa:	2785                	addiw	a5,a5,1
    800045ac:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045ae:	0001d517          	auipc	a0,0x1d
    800045b2:	2da50513          	addi	a0,a0,730 # 80021888 <ftable>
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	6d4080e7          	jalr	1748(ra) # 80000c8a <release>
  return f;
}
    800045be:	8526                	mv	a0,s1
    800045c0:	60e2                	ld	ra,24(sp)
    800045c2:	6442                	ld	s0,16(sp)
    800045c4:	64a2                	ld	s1,8(sp)
    800045c6:	6105                	addi	sp,sp,32
    800045c8:	8082                	ret
    panic("filedup");
    800045ca:	00004517          	auipc	a0,0x4
    800045ce:	0de50513          	addi	a0,a0,222 # 800086a8 <syscalls+0x248>
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	f6c080e7          	jalr	-148(ra) # 8000053e <panic>

00000000800045da <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045da:	7139                	addi	sp,sp,-64
    800045dc:	fc06                	sd	ra,56(sp)
    800045de:	f822                	sd	s0,48(sp)
    800045e0:	f426                	sd	s1,40(sp)
    800045e2:	f04a                	sd	s2,32(sp)
    800045e4:	ec4e                	sd	s3,24(sp)
    800045e6:	e852                	sd	s4,16(sp)
    800045e8:	e456                	sd	s5,8(sp)
    800045ea:	0080                	addi	s0,sp,64
    800045ec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045ee:	0001d517          	auipc	a0,0x1d
    800045f2:	29a50513          	addi	a0,a0,666 # 80021888 <ftable>
    800045f6:	ffffc097          	auipc	ra,0xffffc
    800045fa:	5e0080e7          	jalr	1504(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800045fe:	40dc                	lw	a5,4(s1)
    80004600:	06f05163          	blez	a5,80004662 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004604:	37fd                	addiw	a5,a5,-1
    80004606:	0007871b          	sext.w	a4,a5
    8000460a:	c0dc                	sw	a5,4(s1)
    8000460c:	06e04363          	bgtz	a4,80004672 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004610:	0004a903          	lw	s2,0(s1)
    80004614:	0094ca83          	lbu	s5,9(s1)
    80004618:	0104ba03          	ld	s4,16(s1)
    8000461c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004620:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004624:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004628:	0001d517          	auipc	a0,0x1d
    8000462c:	26050513          	addi	a0,a0,608 # 80021888 <ftable>
    80004630:	ffffc097          	auipc	ra,0xffffc
    80004634:	65a080e7          	jalr	1626(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    80004638:	4785                	li	a5,1
    8000463a:	04f90d63          	beq	s2,a5,80004694 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000463e:	3979                	addiw	s2,s2,-2
    80004640:	4785                	li	a5,1
    80004642:	0527e063          	bltu	a5,s2,80004682 <fileclose+0xa8>
    begin_op();
    80004646:	00000097          	auipc	ra,0x0
    8000464a:	ac8080e7          	jalr	-1336(ra) # 8000410e <begin_op>
    iput(ff.ip);
    8000464e:	854e                	mv	a0,s3
    80004650:	fffff097          	auipc	ra,0xfffff
    80004654:	2b6080e7          	jalr	694(ra) # 80003906 <iput>
    end_op();
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	b36080e7          	jalr	-1226(ra) # 8000418e <end_op>
    80004660:	a00d                	j	80004682 <fileclose+0xa8>
    panic("fileclose");
    80004662:	00004517          	auipc	a0,0x4
    80004666:	04e50513          	addi	a0,a0,78 # 800086b0 <syscalls+0x250>
    8000466a:	ffffc097          	auipc	ra,0xffffc
    8000466e:	ed4080e7          	jalr	-300(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004672:	0001d517          	auipc	a0,0x1d
    80004676:	21650513          	addi	a0,a0,534 # 80021888 <ftable>
    8000467a:	ffffc097          	auipc	ra,0xffffc
    8000467e:	610080e7          	jalr	1552(ra) # 80000c8a <release>
  }
}
    80004682:	70e2                	ld	ra,56(sp)
    80004684:	7442                	ld	s0,48(sp)
    80004686:	74a2                	ld	s1,40(sp)
    80004688:	7902                	ld	s2,32(sp)
    8000468a:	69e2                	ld	s3,24(sp)
    8000468c:	6a42                	ld	s4,16(sp)
    8000468e:	6aa2                	ld	s5,8(sp)
    80004690:	6121                	addi	sp,sp,64
    80004692:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004694:	85d6                	mv	a1,s5
    80004696:	8552                	mv	a0,s4
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	34c080e7          	jalr	844(ra) # 800049e4 <pipeclose>
    800046a0:	b7cd                	j	80004682 <fileclose+0xa8>

00000000800046a2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800046a2:	715d                	addi	sp,sp,-80
    800046a4:	e486                	sd	ra,72(sp)
    800046a6:	e0a2                	sd	s0,64(sp)
    800046a8:	fc26                	sd	s1,56(sp)
    800046aa:	f84a                	sd	s2,48(sp)
    800046ac:	f44e                	sd	s3,40(sp)
    800046ae:	0880                	addi	s0,sp,80
    800046b0:	84aa                	mv	s1,a0
    800046b2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046b4:	ffffd097          	auipc	ra,0xffffd
    800046b8:	2f8080e7          	jalr	760(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046bc:	409c                	lw	a5,0(s1)
    800046be:	37f9                	addiw	a5,a5,-2
    800046c0:	4705                	li	a4,1
    800046c2:	04f76763          	bltu	a4,a5,80004710 <filestat+0x6e>
    800046c6:	892a                	mv	s2,a0
    ilock(f->ip);
    800046c8:	6c88                	ld	a0,24(s1)
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	082080e7          	jalr	130(ra) # 8000374c <ilock>
    stati(f->ip, &st);
    800046d2:	fb840593          	addi	a1,s0,-72
    800046d6:	6c88                	ld	a0,24(s1)
    800046d8:	fffff097          	auipc	ra,0xfffff
    800046dc:	2fe080e7          	jalr	766(ra) # 800039d6 <stati>
    iunlock(f->ip);
    800046e0:	6c88                	ld	a0,24(s1)
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	12c080e7          	jalr	300(ra) # 8000380e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046ea:	46e1                	li	a3,24
    800046ec:	fb840613          	addi	a2,s0,-72
    800046f0:	85ce                	mv	a1,s3
    800046f2:	08093503          	ld	a0,128(s2)
    800046f6:	ffffd097          	auipc	ra,0xffffd
    800046fa:	f72080e7          	jalr	-142(ra) # 80001668 <copyout>
    800046fe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004702:	60a6                	ld	ra,72(sp)
    80004704:	6406                	ld	s0,64(sp)
    80004706:	74e2                	ld	s1,56(sp)
    80004708:	7942                	ld	s2,48(sp)
    8000470a:	79a2                	ld	s3,40(sp)
    8000470c:	6161                	addi	sp,sp,80
    8000470e:	8082                	ret
  return -1;
    80004710:	557d                	li	a0,-1
    80004712:	bfc5                	j	80004702 <filestat+0x60>

0000000080004714 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004714:	7179                	addi	sp,sp,-48
    80004716:	f406                	sd	ra,40(sp)
    80004718:	f022                	sd	s0,32(sp)
    8000471a:	ec26                	sd	s1,24(sp)
    8000471c:	e84a                	sd	s2,16(sp)
    8000471e:	e44e                	sd	s3,8(sp)
    80004720:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004722:	00854783          	lbu	a5,8(a0)
    80004726:	c3d5                	beqz	a5,800047ca <fileread+0xb6>
    80004728:	84aa                	mv	s1,a0
    8000472a:	89ae                	mv	s3,a1
    8000472c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000472e:	411c                	lw	a5,0(a0)
    80004730:	4705                	li	a4,1
    80004732:	04e78963          	beq	a5,a4,80004784 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004736:	470d                	li	a4,3
    80004738:	04e78d63          	beq	a5,a4,80004792 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000473c:	4709                	li	a4,2
    8000473e:	06e79e63          	bne	a5,a4,800047ba <fileread+0xa6>
    ilock(f->ip);
    80004742:	6d08                	ld	a0,24(a0)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	008080e7          	jalr	8(ra) # 8000374c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000474c:	874a                	mv	a4,s2
    8000474e:	5094                	lw	a3,32(s1)
    80004750:	864e                	mv	a2,s3
    80004752:	4585                	li	a1,1
    80004754:	6c88                	ld	a0,24(s1)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	2aa080e7          	jalr	682(ra) # 80003a00 <readi>
    8000475e:	892a                	mv	s2,a0
    80004760:	00a05563          	blez	a0,8000476a <fileread+0x56>
      f->off += r;
    80004764:	509c                	lw	a5,32(s1)
    80004766:	9fa9                	addw	a5,a5,a0
    80004768:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000476a:	6c88                	ld	a0,24(s1)
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	0a2080e7          	jalr	162(ra) # 8000380e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004774:	854a                	mv	a0,s2
    80004776:	70a2                	ld	ra,40(sp)
    80004778:	7402                	ld	s0,32(sp)
    8000477a:	64e2                	ld	s1,24(sp)
    8000477c:	6942                	ld	s2,16(sp)
    8000477e:	69a2                	ld	s3,8(sp)
    80004780:	6145                	addi	sp,sp,48
    80004782:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004784:	6908                	ld	a0,16(a0)
    80004786:	00000097          	auipc	ra,0x0
    8000478a:	3c6080e7          	jalr	966(ra) # 80004b4c <piperead>
    8000478e:	892a                	mv	s2,a0
    80004790:	b7d5                	j	80004774 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004792:	02451783          	lh	a5,36(a0)
    80004796:	03079693          	slli	a3,a5,0x30
    8000479a:	92c1                	srli	a3,a3,0x30
    8000479c:	4725                	li	a4,9
    8000479e:	02d76863          	bltu	a4,a3,800047ce <fileread+0xba>
    800047a2:	0792                	slli	a5,a5,0x4
    800047a4:	0001d717          	auipc	a4,0x1d
    800047a8:	04470713          	addi	a4,a4,68 # 800217e8 <devsw>
    800047ac:	97ba                	add	a5,a5,a4
    800047ae:	639c                	ld	a5,0(a5)
    800047b0:	c38d                	beqz	a5,800047d2 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047b2:	4505                	li	a0,1
    800047b4:	9782                	jalr	a5
    800047b6:	892a                	mv	s2,a0
    800047b8:	bf75                	j	80004774 <fileread+0x60>
    panic("fileread");
    800047ba:	00004517          	auipc	a0,0x4
    800047be:	f0650513          	addi	a0,a0,-250 # 800086c0 <syscalls+0x260>
    800047c2:	ffffc097          	auipc	ra,0xffffc
    800047c6:	d7c080e7          	jalr	-644(ra) # 8000053e <panic>
    return -1;
    800047ca:	597d                	li	s2,-1
    800047cc:	b765                	j	80004774 <fileread+0x60>
      return -1;
    800047ce:	597d                	li	s2,-1
    800047d0:	b755                	j	80004774 <fileread+0x60>
    800047d2:	597d                	li	s2,-1
    800047d4:	b745                	j	80004774 <fileread+0x60>

00000000800047d6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800047d6:	715d                	addi	sp,sp,-80
    800047d8:	e486                	sd	ra,72(sp)
    800047da:	e0a2                	sd	s0,64(sp)
    800047dc:	fc26                	sd	s1,56(sp)
    800047de:	f84a                	sd	s2,48(sp)
    800047e0:	f44e                	sd	s3,40(sp)
    800047e2:	f052                	sd	s4,32(sp)
    800047e4:	ec56                	sd	s5,24(sp)
    800047e6:	e85a                	sd	s6,16(sp)
    800047e8:	e45e                	sd	s7,8(sp)
    800047ea:	e062                	sd	s8,0(sp)
    800047ec:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800047ee:	00954783          	lbu	a5,9(a0)
    800047f2:	10078663          	beqz	a5,800048fe <filewrite+0x128>
    800047f6:	892a                	mv	s2,a0
    800047f8:	8aae                	mv	s5,a1
    800047fa:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047fc:	411c                	lw	a5,0(a0)
    800047fe:	4705                	li	a4,1
    80004800:	02e78263          	beq	a5,a4,80004824 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004804:	470d                	li	a4,3
    80004806:	02e78663          	beq	a5,a4,80004832 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000480a:	4709                	li	a4,2
    8000480c:	0ee79163          	bne	a5,a4,800048ee <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004810:	0ac05d63          	blez	a2,800048ca <filewrite+0xf4>
    int i = 0;
    80004814:	4981                	li	s3,0
    80004816:	6b05                	lui	s6,0x1
    80004818:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000481c:	6b85                	lui	s7,0x1
    8000481e:	c00b8b9b          	addiw	s7,s7,-1024
    80004822:	a861                	j	800048ba <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004824:	6908                	ld	a0,16(a0)
    80004826:	00000097          	auipc	ra,0x0
    8000482a:	22e080e7          	jalr	558(ra) # 80004a54 <pipewrite>
    8000482e:	8a2a                	mv	s4,a0
    80004830:	a045                	j	800048d0 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004832:	02451783          	lh	a5,36(a0)
    80004836:	03079693          	slli	a3,a5,0x30
    8000483a:	92c1                	srli	a3,a3,0x30
    8000483c:	4725                	li	a4,9
    8000483e:	0cd76263          	bltu	a4,a3,80004902 <filewrite+0x12c>
    80004842:	0792                	slli	a5,a5,0x4
    80004844:	0001d717          	auipc	a4,0x1d
    80004848:	fa470713          	addi	a4,a4,-92 # 800217e8 <devsw>
    8000484c:	97ba                	add	a5,a5,a4
    8000484e:	679c                	ld	a5,8(a5)
    80004850:	cbdd                	beqz	a5,80004906 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004852:	4505                	li	a0,1
    80004854:	9782                	jalr	a5
    80004856:	8a2a                	mv	s4,a0
    80004858:	a8a5                	j	800048d0 <filewrite+0xfa>
    8000485a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000485e:	00000097          	auipc	ra,0x0
    80004862:	8b0080e7          	jalr	-1872(ra) # 8000410e <begin_op>
      ilock(f->ip);
    80004866:	01893503          	ld	a0,24(s2)
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	ee2080e7          	jalr	-286(ra) # 8000374c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004872:	8762                	mv	a4,s8
    80004874:	02092683          	lw	a3,32(s2)
    80004878:	01598633          	add	a2,s3,s5
    8000487c:	4585                	li	a1,1
    8000487e:	01893503          	ld	a0,24(s2)
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	276080e7          	jalr	630(ra) # 80003af8 <writei>
    8000488a:	84aa                	mv	s1,a0
    8000488c:	00a05763          	blez	a0,8000489a <filewrite+0xc4>
        f->off += r;
    80004890:	02092783          	lw	a5,32(s2)
    80004894:	9fa9                	addw	a5,a5,a0
    80004896:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000489a:	01893503          	ld	a0,24(s2)
    8000489e:	fffff097          	auipc	ra,0xfffff
    800048a2:	f70080e7          	jalr	-144(ra) # 8000380e <iunlock>
      end_op();
    800048a6:	00000097          	auipc	ra,0x0
    800048aa:	8e8080e7          	jalr	-1816(ra) # 8000418e <end_op>

      if(r != n1){
    800048ae:	009c1f63          	bne	s8,s1,800048cc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800048b2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048b6:	0149db63          	bge	s3,s4,800048cc <filewrite+0xf6>
      int n1 = n - i;
    800048ba:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800048be:	84be                	mv	s1,a5
    800048c0:	2781                	sext.w	a5,a5
    800048c2:	f8fb5ce3          	bge	s6,a5,8000485a <filewrite+0x84>
    800048c6:	84de                	mv	s1,s7
    800048c8:	bf49                	j	8000485a <filewrite+0x84>
    int i = 0;
    800048ca:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048cc:	013a1f63          	bne	s4,s3,800048ea <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048d0:	8552                	mv	a0,s4
    800048d2:	60a6                	ld	ra,72(sp)
    800048d4:	6406                	ld	s0,64(sp)
    800048d6:	74e2                	ld	s1,56(sp)
    800048d8:	7942                	ld	s2,48(sp)
    800048da:	79a2                	ld	s3,40(sp)
    800048dc:	7a02                	ld	s4,32(sp)
    800048de:	6ae2                	ld	s5,24(sp)
    800048e0:	6b42                	ld	s6,16(sp)
    800048e2:	6ba2                	ld	s7,8(sp)
    800048e4:	6c02                	ld	s8,0(sp)
    800048e6:	6161                	addi	sp,sp,80
    800048e8:	8082                	ret
    ret = (i == n ? n : -1);
    800048ea:	5a7d                	li	s4,-1
    800048ec:	b7d5                	j	800048d0 <filewrite+0xfa>
    panic("filewrite");
    800048ee:	00004517          	auipc	a0,0x4
    800048f2:	de250513          	addi	a0,a0,-542 # 800086d0 <syscalls+0x270>
    800048f6:	ffffc097          	auipc	ra,0xffffc
    800048fa:	c48080e7          	jalr	-952(ra) # 8000053e <panic>
    return -1;
    800048fe:	5a7d                	li	s4,-1
    80004900:	bfc1                	j	800048d0 <filewrite+0xfa>
      return -1;
    80004902:	5a7d                	li	s4,-1
    80004904:	b7f1                	j	800048d0 <filewrite+0xfa>
    80004906:	5a7d                	li	s4,-1
    80004908:	b7e1                	j	800048d0 <filewrite+0xfa>

000000008000490a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000490a:	7179                	addi	sp,sp,-48
    8000490c:	f406                	sd	ra,40(sp)
    8000490e:	f022                	sd	s0,32(sp)
    80004910:	ec26                	sd	s1,24(sp)
    80004912:	e84a                	sd	s2,16(sp)
    80004914:	e44e                	sd	s3,8(sp)
    80004916:	e052                	sd	s4,0(sp)
    80004918:	1800                	addi	s0,sp,48
    8000491a:	84aa                	mv	s1,a0
    8000491c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000491e:	0005b023          	sd	zero,0(a1)
    80004922:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	bf8080e7          	jalr	-1032(ra) # 8000451e <filealloc>
    8000492e:	e088                	sd	a0,0(s1)
    80004930:	c551                	beqz	a0,800049bc <pipealloc+0xb2>
    80004932:	00000097          	auipc	ra,0x0
    80004936:	bec080e7          	jalr	-1044(ra) # 8000451e <filealloc>
    8000493a:	00aa3023          	sd	a0,0(s4)
    8000493e:	c92d                	beqz	a0,800049b0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004940:	ffffc097          	auipc	ra,0xffffc
    80004944:	1a6080e7          	jalr	422(ra) # 80000ae6 <kalloc>
    80004948:	892a                	mv	s2,a0
    8000494a:	c125                	beqz	a0,800049aa <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000494c:	4985                	li	s3,1
    8000494e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004952:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004956:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000495a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000495e:	00004597          	auipc	a1,0x4
    80004962:	d8258593          	addi	a1,a1,-638 # 800086e0 <syscalls+0x280>
    80004966:	ffffc097          	auipc	ra,0xffffc
    8000496a:	1e0080e7          	jalr	480(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    8000496e:	609c                	ld	a5,0(s1)
    80004970:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004974:	609c                	ld	a5,0(s1)
    80004976:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000497a:	609c                	ld	a5,0(s1)
    8000497c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004980:	609c                	ld	a5,0(s1)
    80004982:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004986:	000a3783          	ld	a5,0(s4)
    8000498a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000498e:	000a3783          	ld	a5,0(s4)
    80004992:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004996:	000a3783          	ld	a5,0(s4)
    8000499a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000499e:	000a3783          	ld	a5,0(s4)
    800049a2:	0127b823          	sd	s2,16(a5)
  return 0;
    800049a6:	4501                	li	a0,0
    800049a8:	a025                	j	800049d0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049aa:	6088                	ld	a0,0(s1)
    800049ac:	e501                	bnez	a0,800049b4 <pipealloc+0xaa>
    800049ae:	a039                	j	800049bc <pipealloc+0xb2>
    800049b0:	6088                	ld	a0,0(s1)
    800049b2:	c51d                	beqz	a0,800049e0 <pipealloc+0xd6>
    fileclose(*f0);
    800049b4:	00000097          	auipc	ra,0x0
    800049b8:	c26080e7          	jalr	-986(ra) # 800045da <fileclose>
  if(*f1)
    800049bc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049c0:	557d                	li	a0,-1
  if(*f1)
    800049c2:	c799                	beqz	a5,800049d0 <pipealloc+0xc6>
    fileclose(*f1);
    800049c4:	853e                	mv	a0,a5
    800049c6:	00000097          	auipc	ra,0x0
    800049ca:	c14080e7          	jalr	-1004(ra) # 800045da <fileclose>
  return -1;
    800049ce:	557d                	li	a0,-1
}
    800049d0:	70a2                	ld	ra,40(sp)
    800049d2:	7402                	ld	s0,32(sp)
    800049d4:	64e2                	ld	s1,24(sp)
    800049d6:	6942                	ld	s2,16(sp)
    800049d8:	69a2                	ld	s3,8(sp)
    800049da:	6a02                	ld	s4,0(sp)
    800049dc:	6145                	addi	sp,sp,48
    800049de:	8082                	ret
  return -1;
    800049e0:	557d                	li	a0,-1
    800049e2:	b7fd                	j	800049d0 <pipealloc+0xc6>

00000000800049e4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049e4:	1101                	addi	sp,sp,-32
    800049e6:	ec06                	sd	ra,24(sp)
    800049e8:	e822                	sd	s0,16(sp)
    800049ea:	e426                	sd	s1,8(sp)
    800049ec:	e04a                	sd	s2,0(sp)
    800049ee:	1000                	addi	s0,sp,32
    800049f0:	84aa                	mv	s1,a0
    800049f2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049f4:	ffffc097          	auipc	ra,0xffffc
    800049f8:	1e2080e7          	jalr	482(ra) # 80000bd6 <acquire>
  if(writable){
    800049fc:	02090d63          	beqz	s2,80004a36 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a00:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a04:	21848513          	addi	a0,s1,536
    80004a08:	ffffd097          	auipc	ra,0xffffd
    80004a0c:	726080e7          	jalr	1830(ra) # 8000212e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a10:	2204b783          	ld	a5,544(s1)
    80004a14:	eb95                	bnez	a5,80004a48 <pipeclose+0x64>
    release(&pi->lock);
    80004a16:	8526                	mv	a0,s1
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	272080e7          	jalr	626(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004a20:	8526                	mv	a0,s1
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	fc8080e7          	jalr	-56(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    80004a2a:	60e2                	ld	ra,24(sp)
    80004a2c:	6442                	ld	s0,16(sp)
    80004a2e:	64a2                	ld	s1,8(sp)
    80004a30:	6902                	ld	s2,0(sp)
    80004a32:	6105                	addi	sp,sp,32
    80004a34:	8082                	ret
    pi->readopen = 0;
    80004a36:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a3a:	21c48513          	addi	a0,s1,540
    80004a3e:	ffffd097          	auipc	ra,0xffffd
    80004a42:	6f0080e7          	jalr	1776(ra) # 8000212e <wakeup>
    80004a46:	b7e9                	j	80004a10 <pipeclose+0x2c>
    release(&pi->lock);
    80004a48:	8526                	mv	a0,s1
    80004a4a:	ffffc097          	auipc	ra,0xffffc
    80004a4e:	240080e7          	jalr	576(ra) # 80000c8a <release>
}
    80004a52:	bfe1                	j	80004a2a <pipeclose+0x46>

0000000080004a54 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a54:	711d                	addi	sp,sp,-96
    80004a56:	ec86                	sd	ra,88(sp)
    80004a58:	e8a2                	sd	s0,80(sp)
    80004a5a:	e4a6                	sd	s1,72(sp)
    80004a5c:	e0ca                	sd	s2,64(sp)
    80004a5e:	fc4e                	sd	s3,56(sp)
    80004a60:	f852                	sd	s4,48(sp)
    80004a62:	f456                	sd	s5,40(sp)
    80004a64:	f05a                	sd	s6,32(sp)
    80004a66:	ec5e                	sd	s7,24(sp)
    80004a68:	e862                	sd	s8,16(sp)
    80004a6a:	1080                	addi	s0,sp,96
    80004a6c:	84aa                	mv	s1,a0
    80004a6e:	8aae                	mv	s5,a1
    80004a70:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	f3a080e7          	jalr	-198(ra) # 800019ac <myproc>
    80004a7a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffc097          	auipc	ra,0xffffc
    80004a82:	158080e7          	jalr	344(ra) # 80000bd6 <acquire>
  while(i < n){
    80004a86:	0b405663          	blez	s4,80004b32 <pipewrite+0xde>
  int i = 0;
    80004a8a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a8c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004a8e:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a92:	21c48b93          	addi	s7,s1,540
    80004a96:	a089                	j	80004ad8 <pipewrite+0x84>
      release(&pi->lock);
    80004a98:	8526                	mv	a0,s1
    80004a9a:	ffffc097          	auipc	ra,0xffffc
    80004a9e:	1f0080e7          	jalr	496(ra) # 80000c8a <release>
      return -1;
    80004aa2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004aa4:	854a                	mv	a0,s2
    80004aa6:	60e6                	ld	ra,88(sp)
    80004aa8:	6446                	ld	s0,80(sp)
    80004aaa:	64a6                	ld	s1,72(sp)
    80004aac:	6906                	ld	s2,64(sp)
    80004aae:	79e2                	ld	s3,56(sp)
    80004ab0:	7a42                	ld	s4,48(sp)
    80004ab2:	7aa2                	ld	s5,40(sp)
    80004ab4:	7b02                	ld	s6,32(sp)
    80004ab6:	6be2                	ld	s7,24(sp)
    80004ab8:	6c42                	ld	s8,16(sp)
    80004aba:	6125                	addi	sp,sp,96
    80004abc:	8082                	ret
      wakeup(&pi->nread);
    80004abe:	8562                	mv	a0,s8
    80004ac0:	ffffd097          	auipc	ra,0xffffd
    80004ac4:	66e080e7          	jalr	1646(ra) # 8000212e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004ac8:	85a6                	mv	a1,s1
    80004aca:	855e                	mv	a0,s7
    80004acc:	ffffd097          	auipc	ra,0xffffd
    80004ad0:	5fe080e7          	jalr	1534(ra) # 800020ca <sleep>
  while(i < n){
    80004ad4:	07495063          	bge	s2,s4,80004b34 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004ad8:	2204a783          	lw	a5,544(s1)
    80004adc:	dfd5                	beqz	a5,80004a98 <pipewrite+0x44>
    80004ade:	854e                	mv	a0,s3
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	8a8080e7          	jalr	-1880(ra) # 80002388 <killed>
    80004ae8:	f945                	bnez	a0,80004a98 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004aea:	2184a783          	lw	a5,536(s1)
    80004aee:	21c4a703          	lw	a4,540(s1)
    80004af2:	2007879b          	addiw	a5,a5,512
    80004af6:	fcf704e3          	beq	a4,a5,80004abe <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004afa:	4685                	li	a3,1
    80004afc:	01590633          	add	a2,s2,s5
    80004b00:	faf40593          	addi	a1,s0,-81
    80004b04:	0809b503          	ld	a0,128(s3)
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	bec080e7          	jalr	-1044(ra) # 800016f4 <copyin>
    80004b10:	03650263          	beq	a0,s6,80004b34 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b14:	21c4a783          	lw	a5,540(s1)
    80004b18:	0017871b          	addiw	a4,a5,1
    80004b1c:	20e4ae23          	sw	a4,540(s1)
    80004b20:	1ff7f793          	andi	a5,a5,511
    80004b24:	97a6                	add	a5,a5,s1
    80004b26:	faf44703          	lbu	a4,-81(s0)
    80004b2a:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b2e:	2905                	addiw	s2,s2,1
    80004b30:	b755                	j	80004ad4 <pipewrite+0x80>
  int i = 0;
    80004b32:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b34:	21848513          	addi	a0,s1,536
    80004b38:	ffffd097          	auipc	ra,0xffffd
    80004b3c:	5f6080e7          	jalr	1526(ra) # 8000212e <wakeup>
  release(&pi->lock);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffc097          	auipc	ra,0xffffc
    80004b46:	148080e7          	jalr	328(ra) # 80000c8a <release>
  return i;
    80004b4a:	bfa9                	j	80004aa4 <pipewrite+0x50>

0000000080004b4c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b4c:	715d                	addi	sp,sp,-80
    80004b4e:	e486                	sd	ra,72(sp)
    80004b50:	e0a2                	sd	s0,64(sp)
    80004b52:	fc26                	sd	s1,56(sp)
    80004b54:	f84a                	sd	s2,48(sp)
    80004b56:	f44e                	sd	s3,40(sp)
    80004b58:	f052                	sd	s4,32(sp)
    80004b5a:	ec56                	sd	s5,24(sp)
    80004b5c:	e85a                	sd	s6,16(sp)
    80004b5e:	0880                	addi	s0,sp,80
    80004b60:	84aa                	mv	s1,a0
    80004b62:	892e                	mv	s2,a1
    80004b64:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	e46080e7          	jalr	-442(ra) # 800019ac <myproc>
    80004b6e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffc097          	auipc	ra,0xffffc
    80004b76:	064080e7          	jalr	100(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b7a:	2184a703          	lw	a4,536(s1)
    80004b7e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b82:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b86:	02f71763          	bne	a4,a5,80004bb4 <piperead+0x68>
    80004b8a:	2244a783          	lw	a5,548(s1)
    80004b8e:	c39d                	beqz	a5,80004bb4 <piperead+0x68>
    if(killed(pr)){
    80004b90:	8552                	mv	a0,s4
    80004b92:	ffffd097          	auipc	ra,0xffffd
    80004b96:	7f6080e7          	jalr	2038(ra) # 80002388 <killed>
    80004b9a:	e941                	bnez	a0,80004c2a <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b9c:	85a6                	mv	a1,s1
    80004b9e:	854e                	mv	a0,s3
    80004ba0:	ffffd097          	auipc	ra,0xffffd
    80004ba4:	52a080e7          	jalr	1322(ra) # 800020ca <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ba8:	2184a703          	lw	a4,536(s1)
    80004bac:	21c4a783          	lw	a5,540(s1)
    80004bb0:	fcf70de3          	beq	a4,a5,80004b8a <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bb4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bb6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bb8:	05505363          	blez	s5,80004bfe <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004bbc:	2184a783          	lw	a5,536(s1)
    80004bc0:	21c4a703          	lw	a4,540(s1)
    80004bc4:	02f70d63          	beq	a4,a5,80004bfe <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004bc8:	0017871b          	addiw	a4,a5,1
    80004bcc:	20e4ac23          	sw	a4,536(s1)
    80004bd0:	1ff7f793          	andi	a5,a5,511
    80004bd4:	97a6                	add	a5,a5,s1
    80004bd6:	0187c783          	lbu	a5,24(a5)
    80004bda:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bde:	4685                	li	a3,1
    80004be0:	fbf40613          	addi	a2,s0,-65
    80004be4:	85ca                	mv	a1,s2
    80004be6:	080a3503          	ld	a0,128(s4)
    80004bea:	ffffd097          	auipc	ra,0xffffd
    80004bee:	a7e080e7          	jalr	-1410(ra) # 80001668 <copyout>
    80004bf2:	01650663          	beq	a0,s6,80004bfe <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bf6:	2985                	addiw	s3,s3,1
    80004bf8:	0905                	addi	s2,s2,1
    80004bfa:	fd3a91e3          	bne	s5,s3,80004bbc <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bfe:	21c48513          	addi	a0,s1,540
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	52c080e7          	jalr	1324(ra) # 8000212e <wakeup>
  release(&pi->lock);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffc097          	auipc	ra,0xffffc
    80004c10:	07e080e7          	jalr	126(ra) # 80000c8a <release>
  return i;
}
    80004c14:	854e                	mv	a0,s3
    80004c16:	60a6                	ld	ra,72(sp)
    80004c18:	6406                	ld	s0,64(sp)
    80004c1a:	74e2                	ld	s1,56(sp)
    80004c1c:	7942                	ld	s2,48(sp)
    80004c1e:	79a2                	ld	s3,40(sp)
    80004c20:	7a02                	ld	s4,32(sp)
    80004c22:	6ae2                	ld	s5,24(sp)
    80004c24:	6b42                	ld	s6,16(sp)
    80004c26:	6161                	addi	sp,sp,80
    80004c28:	8082                	ret
      release(&pi->lock);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffc097          	auipc	ra,0xffffc
    80004c30:	05e080e7          	jalr	94(ra) # 80000c8a <release>
      return -1;
    80004c34:	59fd                	li	s3,-1
    80004c36:	bff9                	j	80004c14 <piperead+0xc8>

0000000080004c38 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004c38:	1141                	addi	sp,sp,-16
    80004c3a:	e422                	sd	s0,8(sp)
    80004c3c:	0800                	addi	s0,sp,16
    80004c3e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004c40:	8905                	andi	a0,a0,1
    80004c42:	c111                	beqz	a0,80004c46 <flags2perm+0xe>
      perm = PTE_X;
    80004c44:	4521                	li	a0,8
    if(flags & 0x2)
    80004c46:	8b89                	andi	a5,a5,2
    80004c48:	c399                	beqz	a5,80004c4e <flags2perm+0x16>
      perm |= PTE_W;
    80004c4a:	00456513          	ori	a0,a0,4
    return perm;
}
    80004c4e:	6422                	ld	s0,8(sp)
    80004c50:	0141                	addi	sp,sp,16
    80004c52:	8082                	ret

0000000080004c54 <exec>:

int
exec(char *path, char **argv)
{
    80004c54:	de010113          	addi	sp,sp,-544
    80004c58:	20113c23          	sd	ra,536(sp)
    80004c5c:	20813823          	sd	s0,528(sp)
    80004c60:	20913423          	sd	s1,520(sp)
    80004c64:	21213023          	sd	s2,512(sp)
    80004c68:	ffce                	sd	s3,504(sp)
    80004c6a:	fbd2                	sd	s4,496(sp)
    80004c6c:	f7d6                	sd	s5,488(sp)
    80004c6e:	f3da                	sd	s6,480(sp)
    80004c70:	efde                	sd	s7,472(sp)
    80004c72:	ebe2                	sd	s8,464(sp)
    80004c74:	e7e6                	sd	s9,456(sp)
    80004c76:	e3ea                	sd	s10,448(sp)
    80004c78:	ff6e                	sd	s11,440(sp)
    80004c7a:	1400                	addi	s0,sp,544
    80004c7c:	892a                	mv	s2,a0
    80004c7e:	dea43423          	sd	a0,-536(s0)
    80004c82:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c86:	ffffd097          	auipc	ra,0xffffd
    80004c8a:	d26080e7          	jalr	-730(ra) # 800019ac <myproc>
    80004c8e:	84aa                	mv	s1,a0

  begin_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	47e080e7          	jalr	1150(ra) # 8000410e <begin_op>

  if((ip = namei(path)) == 0){
    80004c98:	854a                	mv	a0,s2
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	258080e7          	jalr	600(ra) # 80003ef2 <namei>
    80004ca2:	c93d                	beqz	a0,80004d18 <exec+0xc4>
    80004ca4:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ca6:	fffff097          	auipc	ra,0xfffff
    80004caa:	aa6080e7          	jalr	-1370(ra) # 8000374c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004cae:	04000713          	li	a4,64
    80004cb2:	4681                	li	a3,0
    80004cb4:	e5040613          	addi	a2,s0,-432
    80004cb8:	4581                	li	a1,0
    80004cba:	8556                	mv	a0,s5
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	d44080e7          	jalr	-700(ra) # 80003a00 <readi>
    80004cc4:	04000793          	li	a5,64
    80004cc8:	00f51a63          	bne	a0,a5,80004cdc <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004ccc:	e5042703          	lw	a4,-432(s0)
    80004cd0:	464c47b7          	lui	a5,0x464c4
    80004cd4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004cd8:	04f70663          	beq	a4,a5,80004d24 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004cdc:	8556                	mv	a0,s5
    80004cde:	fffff097          	auipc	ra,0xfffff
    80004ce2:	cd0080e7          	jalr	-816(ra) # 800039ae <iunlockput>
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	4a8080e7          	jalr	1192(ra) # 8000418e <end_op>
  }
  return -1;
    80004cee:	557d                	li	a0,-1
}
    80004cf0:	21813083          	ld	ra,536(sp)
    80004cf4:	21013403          	ld	s0,528(sp)
    80004cf8:	20813483          	ld	s1,520(sp)
    80004cfc:	20013903          	ld	s2,512(sp)
    80004d00:	79fe                	ld	s3,504(sp)
    80004d02:	7a5e                	ld	s4,496(sp)
    80004d04:	7abe                	ld	s5,488(sp)
    80004d06:	7b1e                	ld	s6,480(sp)
    80004d08:	6bfe                	ld	s7,472(sp)
    80004d0a:	6c5e                	ld	s8,464(sp)
    80004d0c:	6cbe                	ld	s9,456(sp)
    80004d0e:	6d1e                	ld	s10,448(sp)
    80004d10:	7dfa                	ld	s11,440(sp)
    80004d12:	22010113          	addi	sp,sp,544
    80004d16:	8082                	ret
    end_op();
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	476080e7          	jalr	1142(ra) # 8000418e <end_op>
    return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	b7f9                	j	80004cf0 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	d4a080e7          	jalr	-694(ra) # 80001a70 <proc_pagetable>
    80004d2e:	8b2a                	mv	s6,a0
    80004d30:	d555                	beqz	a0,80004cdc <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d32:	e7042783          	lw	a5,-400(s0)
    80004d36:	e8845703          	lhu	a4,-376(s0)
    80004d3a:	c735                	beqz	a4,80004da6 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004d3c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d3e:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004d42:	6a05                	lui	s4,0x1
    80004d44:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004d48:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004d4c:	6d85                	lui	s11,0x1
    80004d4e:	7d7d                	lui	s10,0xfffff
    80004d50:	a481                	j	80004f90 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d52:	00004517          	auipc	a0,0x4
    80004d56:	99650513          	addi	a0,a0,-1642 # 800086e8 <syscalls+0x288>
    80004d5a:	ffffb097          	auipc	ra,0xffffb
    80004d5e:	7e4080e7          	jalr	2020(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d62:	874a                	mv	a4,s2
    80004d64:	009c86bb          	addw	a3,s9,s1
    80004d68:	4581                	li	a1,0
    80004d6a:	8556                	mv	a0,s5
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	c94080e7          	jalr	-876(ra) # 80003a00 <readi>
    80004d74:	2501                	sext.w	a0,a0
    80004d76:	1aa91a63          	bne	s2,a0,80004f2a <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004d7a:	009d84bb          	addw	s1,s11,s1
    80004d7e:	013d09bb          	addw	s3,s10,s3
    80004d82:	1f74f763          	bgeu	s1,s7,80004f70 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004d86:	02049593          	slli	a1,s1,0x20
    80004d8a:	9181                	srli	a1,a1,0x20
    80004d8c:	95e2                	add	a1,a1,s8
    80004d8e:	855a                	mv	a0,s6
    80004d90:	ffffc097          	auipc	ra,0xffffc
    80004d94:	2cc080e7          	jalr	716(ra) # 8000105c <walkaddr>
    80004d98:	862a                	mv	a2,a0
    if(pa == 0)
    80004d9a:	dd45                	beqz	a0,80004d52 <exec+0xfe>
      n = PGSIZE;
    80004d9c:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d9e:	fd49f2e3          	bgeu	s3,s4,80004d62 <exec+0x10e>
      n = sz - i;
    80004da2:	894e                	mv	s2,s3
    80004da4:	bf7d                	j	80004d62 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004da6:	4901                	li	s2,0
  iunlockput(ip);
    80004da8:	8556                	mv	a0,s5
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	c04080e7          	jalr	-1020(ra) # 800039ae <iunlockput>
  end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	3dc080e7          	jalr	988(ra) # 8000418e <end_op>
  p = myproc();
    80004dba:	ffffd097          	auipc	ra,0xffffd
    80004dbe:	bf2080e7          	jalr	-1038(ra) # 800019ac <myproc>
    80004dc2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004dc4:	07853d03          	ld	s10,120(a0)
  sz = PGROUNDUP(sz);
    80004dc8:	6785                	lui	a5,0x1
    80004dca:	17fd                	addi	a5,a5,-1
    80004dcc:	993e                	add	s2,s2,a5
    80004dce:	77fd                	lui	a5,0xfffff
    80004dd0:	00f977b3          	and	a5,s2,a5
    80004dd4:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004dd8:	4691                	li	a3,4
    80004dda:	6609                	lui	a2,0x2
    80004ddc:	963e                	add	a2,a2,a5
    80004dde:	85be                	mv	a1,a5
    80004de0:	855a                	mv	a0,s6
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	62e080e7          	jalr	1582(ra) # 80001410 <uvmalloc>
    80004dea:	8c2a                	mv	s8,a0
  ip = 0;
    80004dec:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004dee:	12050e63          	beqz	a0,80004f2a <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004df2:	75f9                	lui	a1,0xffffe
    80004df4:	95aa                	add	a1,a1,a0
    80004df6:	855a                	mv	a0,s6
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	83e080e7          	jalr	-1986(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    80004e00:	7afd                	lui	s5,0xfffff
    80004e02:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e04:	df043783          	ld	a5,-528(s0)
    80004e08:	6388                	ld	a0,0(a5)
    80004e0a:	c925                	beqz	a0,80004e7a <exec+0x226>
    80004e0c:	e9040993          	addi	s3,s0,-368
    80004e10:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004e14:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e16:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004e18:	ffffc097          	auipc	ra,0xffffc
    80004e1c:	036080e7          	jalr	54(ra) # 80000e4e <strlen>
    80004e20:	0015079b          	addiw	a5,a0,1
    80004e24:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e28:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e2c:	13596663          	bltu	s2,s5,80004f58 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e30:	df043d83          	ld	s11,-528(s0)
    80004e34:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004e38:	8552                	mv	a0,s4
    80004e3a:	ffffc097          	auipc	ra,0xffffc
    80004e3e:	014080e7          	jalr	20(ra) # 80000e4e <strlen>
    80004e42:	0015069b          	addiw	a3,a0,1
    80004e46:	8652                	mv	a2,s4
    80004e48:	85ca                	mv	a1,s2
    80004e4a:	855a                	mv	a0,s6
    80004e4c:	ffffd097          	auipc	ra,0xffffd
    80004e50:	81c080e7          	jalr	-2020(ra) # 80001668 <copyout>
    80004e54:	10054663          	bltz	a0,80004f60 <exec+0x30c>
    ustack[argc] = sp;
    80004e58:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e5c:	0485                	addi	s1,s1,1
    80004e5e:	008d8793          	addi	a5,s11,8
    80004e62:	def43823          	sd	a5,-528(s0)
    80004e66:	008db503          	ld	a0,8(s11)
    80004e6a:	c911                	beqz	a0,80004e7e <exec+0x22a>
    if(argc >= MAXARG)
    80004e6c:	09a1                	addi	s3,s3,8
    80004e6e:	fb3c95e3          	bne	s9,s3,80004e18 <exec+0x1c4>
  sz = sz1;
    80004e72:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e76:	4a81                	li	s5,0
    80004e78:	a84d                	j	80004f2a <exec+0x2d6>
  sp = sz;
    80004e7a:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e7c:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e7e:	00349793          	slli	a5,s1,0x3
    80004e82:	f9040713          	addi	a4,s0,-112
    80004e86:	97ba                	add	a5,a5,a4
    80004e88:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdc580>
  sp -= (argc+1) * sizeof(uint64);
    80004e8c:	00148693          	addi	a3,s1,1
    80004e90:	068e                	slli	a3,a3,0x3
    80004e92:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e96:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e9a:	01597663          	bgeu	s2,s5,80004ea6 <exec+0x252>
  sz = sz1;
    80004e9e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004ea2:	4a81                	li	s5,0
    80004ea4:	a059                	j	80004f2a <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ea6:	e9040613          	addi	a2,s0,-368
    80004eaa:	85ca                	mv	a1,s2
    80004eac:	855a                	mv	a0,s6
    80004eae:	ffffc097          	auipc	ra,0xffffc
    80004eb2:	7ba080e7          	jalr	1978(ra) # 80001668 <copyout>
    80004eb6:	0a054963          	bltz	a0,80004f68 <exec+0x314>
  p->trapframe->a1 = sp;
    80004eba:	088bb783          	ld	a5,136(s7) # 1088 <_entry-0x7fffef78>
    80004ebe:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ec2:	de843783          	ld	a5,-536(s0)
    80004ec6:	0007c703          	lbu	a4,0(a5)
    80004eca:	cf11                	beqz	a4,80004ee6 <exec+0x292>
    80004ecc:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004ece:	02f00693          	li	a3,47
    80004ed2:	a039                	j	80004ee0 <exec+0x28c>
      last = s+1;
    80004ed4:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004ed8:	0785                	addi	a5,a5,1
    80004eda:	fff7c703          	lbu	a4,-1(a5)
    80004ede:	c701                	beqz	a4,80004ee6 <exec+0x292>
    if(*s == '/')
    80004ee0:	fed71ce3          	bne	a4,a3,80004ed8 <exec+0x284>
    80004ee4:	bfc5                	j	80004ed4 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ee6:	4641                	li	a2,16
    80004ee8:	de843583          	ld	a1,-536(s0)
    80004eec:	188b8513          	addi	a0,s7,392
    80004ef0:	ffffc097          	auipc	ra,0xffffc
    80004ef4:	f2c080e7          	jalr	-212(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80004ef8:	080bb503          	ld	a0,128(s7)
  p->pagetable = pagetable;
    80004efc:	096bb023          	sd	s6,128(s7)
  p->sz = sz;
    80004f00:	078bbc23          	sd	s8,120(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f04:	088bb783          	ld	a5,136(s7)
    80004f08:	e6843703          	ld	a4,-408(s0)
    80004f0c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f0e:	088bb783          	ld	a5,136(s7)
    80004f12:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f16:	85ea                	mv	a1,s10
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	bf4080e7          	jalr	-1036(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f20:	0004851b          	sext.w	a0,s1
    80004f24:	b3f1                	j	80004cf0 <exec+0x9c>
    80004f26:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004f2a:	df843583          	ld	a1,-520(s0)
    80004f2e:	855a                	mv	a0,s6
    80004f30:	ffffd097          	auipc	ra,0xffffd
    80004f34:	bdc080e7          	jalr	-1060(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80004f38:	da0a92e3          	bnez	s5,80004cdc <exec+0x88>
  return -1;
    80004f3c:	557d                	li	a0,-1
    80004f3e:	bb4d                	j	80004cf0 <exec+0x9c>
    80004f40:	df243c23          	sd	s2,-520(s0)
    80004f44:	b7dd                	j	80004f2a <exec+0x2d6>
    80004f46:	df243c23          	sd	s2,-520(s0)
    80004f4a:	b7c5                	j	80004f2a <exec+0x2d6>
    80004f4c:	df243c23          	sd	s2,-520(s0)
    80004f50:	bfe9                	j	80004f2a <exec+0x2d6>
    80004f52:	df243c23          	sd	s2,-520(s0)
    80004f56:	bfd1                	j	80004f2a <exec+0x2d6>
  sz = sz1;
    80004f58:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f5c:	4a81                	li	s5,0
    80004f5e:	b7f1                	j	80004f2a <exec+0x2d6>
  sz = sz1;
    80004f60:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f64:	4a81                	li	s5,0
    80004f66:	b7d1                	j	80004f2a <exec+0x2d6>
  sz = sz1;
    80004f68:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f6c:	4a81                	li	s5,0
    80004f6e:	bf75                	j	80004f2a <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004f70:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f74:	e0843783          	ld	a5,-504(s0)
    80004f78:	0017869b          	addiw	a3,a5,1
    80004f7c:	e0d43423          	sd	a3,-504(s0)
    80004f80:	e0043783          	ld	a5,-512(s0)
    80004f84:	0387879b          	addiw	a5,a5,56
    80004f88:	e8845703          	lhu	a4,-376(s0)
    80004f8c:	e0e6dee3          	bge	a3,a4,80004da8 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f90:	2781                	sext.w	a5,a5
    80004f92:	e0f43023          	sd	a5,-512(s0)
    80004f96:	03800713          	li	a4,56
    80004f9a:	86be                	mv	a3,a5
    80004f9c:	e1840613          	addi	a2,s0,-488
    80004fa0:	4581                	li	a1,0
    80004fa2:	8556                	mv	a0,s5
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	a5c080e7          	jalr	-1444(ra) # 80003a00 <readi>
    80004fac:	03800793          	li	a5,56
    80004fb0:	f6f51be3          	bne	a0,a5,80004f26 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    80004fb4:	e1842783          	lw	a5,-488(s0)
    80004fb8:	4705                	li	a4,1
    80004fba:	fae79de3          	bne	a5,a4,80004f74 <exec+0x320>
    if(ph.memsz < ph.filesz)
    80004fbe:	e4043483          	ld	s1,-448(s0)
    80004fc2:	e3843783          	ld	a5,-456(s0)
    80004fc6:	f6f4ede3          	bltu	s1,a5,80004f40 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fca:	e2843783          	ld	a5,-472(s0)
    80004fce:	94be                	add	s1,s1,a5
    80004fd0:	f6f4ebe3          	bltu	s1,a5,80004f46 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    80004fd4:	de043703          	ld	a4,-544(s0)
    80004fd8:	8ff9                	and	a5,a5,a4
    80004fda:	fbad                	bnez	a5,80004f4c <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004fdc:	e1c42503          	lw	a0,-484(s0)
    80004fe0:	00000097          	auipc	ra,0x0
    80004fe4:	c58080e7          	jalr	-936(ra) # 80004c38 <flags2perm>
    80004fe8:	86aa                	mv	a3,a0
    80004fea:	8626                	mv	a2,s1
    80004fec:	85ca                	mv	a1,s2
    80004fee:	855a                	mv	a0,s6
    80004ff0:	ffffc097          	auipc	ra,0xffffc
    80004ff4:	420080e7          	jalr	1056(ra) # 80001410 <uvmalloc>
    80004ff8:	dea43c23          	sd	a0,-520(s0)
    80004ffc:	d939                	beqz	a0,80004f52 <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ffe:	e2843c03          	ld	s8,-472(s0)
    80005002:	e2042c83          	lw	s9,-480(s0)
    80005006:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000500a:	f60b83e3          	beqz	s7,80004f70 <exec+0x31c>
    8000500e:	89de                	mv	s3,s7
    80005010:	4481                	li	s1,0
    80005012:	bb95                	j	80004d86 <exec+0x132>

0000000080005014 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005014:	7179                	addi	sp,sp,-48
    80005016:	f406                	sd	ra,40(sp)
    80005018:	f022                	sd	s0,32(sp)
    8000501a:	ec26                	sd	s1,24(sp)
    8000501c:	e84a                	sd	s2,16(sp)
    8000501e:	1800                	addi	s0,sp,48
    80005020:	892e                	mv	s2,a1
    80005022:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005024:	fdc40593          	addi	a1,s0,-36
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	b76080e7          	jalr	-1162(ra) # 80002b9e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005030:	fdc42703          	lw	a4,-36(s0)
    80005034:	47bd                	li	a5,15
    80005036:	02e7eb63          	bltu	a5,a4,8000506c <argfd+0x58>
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	972080e7          	jalr	-1678(ra) # 800019ac <myproc>
    80005042:	fdc42703          	lw	a4,-36(s0)
    80005046:	02070793          	addi	a5,a4,32
    8000504a:	078e                	slli	a5,a5,0x3
    8000504c:	953e                	add	a0,a0,a5
    8000504e:	611c                	ld	a5,0(a0)
    80005050:	c385                	beqz	a5,80005070 <argfd+0x5c>
    return -1;
  if(pfd)
    80005052:	00090463          	beqz	s2,8000505a <argfd+0x46>
    *pfd = fd;
    80005056:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000505a:	4501                	li	a0,0
  if(pf)
    8000505c:	c091                	beqz	s1,80005060 <argfd+0x4c>
    *pf = f;
    8000505e:	e09c                	sd	a5,0(s1)
}
    80005060:	70a2                	ld	ra,40(sp)
    80005062:	7402                	ld	s0,32(sp)
    80005064:	64e2                	ld	s1,24(sp)
    80005066:	6942                	ld	s2,16(sp)
    80005068:	6145                	addi	sp,sp,48
    8000506a:	8082                	ret
    return -1;
    8000506c:	557d                	li	a0,-1
    8000506e:	bfcd                	j	80005060 <argfd+0x4c>
    80005070:	557d                	li	a0,-1
    80005072:	b7fd                	j	80005060 <argfd+0x4c>

0000000080005074 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005074:	1101                	addi	sp,sp,-32
    80005076:	ec06                	sd	ra,24(sp)
    80005078:	e822                	sd	s0,16(sp)
    8000507a:	e426                	sd	s1,8(sp)
    8000507c:	1000                	addi	s0,sp,32
    8000507e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	92c080e7          	jalr	-1748(ra) # 800019ac <myproc>
    80005088:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000508a:	10050793          	addi	a5,a0,256
    8000508e:	4501                	li	a0,0
    80005090:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005092:	6398                	ld	a4,0(a5)
    80005094:	cb19                	beqz	a4,800050aa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005096:	2505                	addiw	a0,a0,1
    80005098:	07a1                	addi	a5,a5,8
    8000509a:	fed51ce3          	bne	a0,a3,80005092 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000509e:	557d                	li	a0,-1
}
    800050a0:	60e2                	ld	ra,24(sp)
    800050a2:	6442                	ld	s0,16(sp)
    800050a4:	64a2                	ld	s1,8(sp)
    800050a6:	6105                	addi	sp,sp,32
    800050a8:	8082                	ret
      p->ofile[fd] = f;
    800050aa:	02050793          	addi	a5,a0,32
    800050ae:	078e                	slli	a5,a5,0x3
    800050b0:	963e                	add	a2,a2,a5
    800050b2:	e204                	sd	s1,0(a2)
      return fd;
    800050b4:	b7f5                	j	800050a0 <fdalloc+0x2c>

00000000800050b6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050b6:	715d                	addi	sp,sp,-80
    800050b8:	e486                	sd	ra,72(sp)
    800050ba:	e0a2                	sd	s0,64(sp)
    800050bc:	fc26                	sd	s1,56(sp)
    800050be:	f84a                	sd	s2,48(sp)
    800050c0:	f44e                	sd	s3,40(sp)
    800050c2:	f052                	sd	s4,32(sp)
    800050c4:	ec56                	sd	s5,24(sp)
    800050c6:	e85a                	sd	s6,16(sp)
    800050c8:	0880                	addi	s0,sp,80
    800050ca:	8b2e                	mv	s6,a1
    800050cc:	89b2                	mv	s3,a2
    800050ce:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050d0:	fb040593          	addi	a1,s0,-80
    800050d4:	fffff097          	auipc	ra,0xfffff
    800050d8:	e3c080e7          	jalr	-452(ra) # 80003f10 <nameiparent>
    800050dc:	84aa                	mv	s1,a0
    800050de:	14050f63          	beqz	a0,8000523c <create+0x186>
    return 0;

  ilock(dp);
    800050e2:	ffffe097          	auipc	ra,0xffffe
    800050e6:	66a080e7          	jalr	1642(ra) # 8000374c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050ea:	4601                	li	a2,0
    800050ec:	fb040593          	addi	a1,s0,-80
    800050f0:	8526                	mv	a0,s1
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	b3e080e7          	jalr	-1218(ra) # 80003c30 <dirlookup>
    800050fa:	8aaa                	mv	s5,a0
    800050fc:	c931                	beqz	a0,80005150 <create+0x9a>
    iunlockput(dp);
    800050fe:	8526                	mv	a0,s1
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	8ae080e7          	jalr	-1874(ra) # 800039ae <iunlockput>
    ilock(ip);
    80005108:	8556                	mv	a0,s5
    8000510a:	ffffe097          	auipc	ra,0xffffe
    8000510e:	642080e7          	jalr	1602(ra) # 8000374c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005112:	000b059b          	sext.w	a1,s6
    80005116:	4789                	li	a5,2
    80005118:	02f59563          	bne	a1,a5,80005142 <create+0x8c>
    8000511c:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdc6c4>
    80005120:	37f9                	addiw	a5,a5,-2
    80005122:	17c2                	slli	a5,a5,0x30
    80005124:	93c1                	srli	a5,a5,0x30
    80005126:	4705                	li	a4,1
    80005128:	00f76d63          	bltu	a4,a5,80005142 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000512c:	8556                	mv	a0,s5
    8000512e:	60a6                	ld	ra,72(sp)
    80005130:	6406                	ld	s0,64(sp)
    80005132:	74e2                	ld	s1,56(sp)
    80005134:	7942                	ld	s2,48(sp)
    80005136:	79a2                	ld	s3,40(sp)
    80005138:	7a02                	ld	s4,32(sp)
    8000513a:	6ae2                	ld	s5,24(sp)
    8000513c:	6b42                	ld	s6,16(sp)
    8000513e:	6161                	addi	sp,sp,80
    80005140:	8082                	ret
    iunlockput(ip);
    80005142:	8556                	mv	a0,s5
    80005144:	fffff097          	auipc	ra,0xfffff
    80005148:	86a080e7          	jalr	-1942(ra) # 800039ae <iunlockput>
    return 0;
    8000514c:	4a81                	li	s5,0
    8000514e:	bff9                	j	8000512c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005150:	85da                	mv	a1,s6
    80005152:	4088                	lw	a0,0(s1)
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	45c080e7          	jalr	1116(ra) # 800035b0 <ialloc>
    8000515c:	8a2a                	mv	s4,a0
    8000515e:	c539                	beqz	a0,800051ac <create+0xf6>
  ilock(ip);
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	5ec080e7          	jalr	1516(ra) # 8000374c <ilock>
  ip->major = major;
    80005168:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000516c:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005170:	4905                	li	s2,1
    80005172:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005176:	8552                	mv	a0,s4
    80005178:	ffffe097          	auipc	ra,0xffffe
    8000517c:	50a080e7          	jalr	1290(ra) # 80003682 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005180:	000b059b          	sext.w	a1,s6
    80005184:	03258b63          	beq	a1,s2,800051ba <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005188:	004a2603          	lw	a2,4(s4)
    8000518c:	fb040593          	addi	a1,s0,-80
    80005190:	8526                	mv	a0,s1
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	cae080e7          	jalr	-850(ra) # 80003e40 <dirlink>
    8000519a:	06054f63          	bltz	a0,80005218 <create+0x162>
  iunlockput(dp);
    8000519e:	8526                	mv	a0,s1
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	80e080e7          	jalr	-2034(ra) # 800039ae <iunlockput>
  return ip;
    800051a8:	8ad2                	mv	s5,s4
    800051aa:	b749                	j	8000512c <create+0x76>
    iunlockput(dp);
    800051ac:	8526                	mv	a0,s1
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	800080e7          	jalr	-2048(ra) # 800039ae <iunlockput>
    return 0;
    800051b6:	8ad2                	mv	s5,s4
    800051b8:	bf95                	j	8000512c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051ba:	004a2603          	lw	a2,4(s4)
    800051be:	00003597          	auipc	a1,0x3
    800051c2:	54a58593          	addi	a1,a1,1354 # 80008708 <syscalls+0x2a8>
    800051c6:	8552                	mv	a0,s4
    800051c8:	fffff097          	auipc	ra,0xfffff
    800051cc:	c78080e7          	jalr	-904(ra) # 80003e40 <dirlink>
    800051d0:	04054463          	bltz	a0,80005218 <create+0x162>
    800051d4:	40d0                	lw	a2,4(s1)
    800051d6:	00003597          	auipc	a1,0x3
    800051da:	53a58593          	addi	a1,a1,1338 # 80008710 <syscalls+0x2b0>
    800051de:	8552                	mv	a0,s4
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	c60080e7          	jalr	-928(ra) # 80003e40 <dirlink>
    800051e8:	02054863          	bltz	a0,80005218 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800051ec:	004a2603          	lw	a2,4(s4)
    800051f0:	fb040593          	addi	a1,s0,-80
    800051f4:	8526                	mv	a0,s1
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	c4a080e7          	jalr	-950(ra) # 80003e40 <dirlink>
    800051fe:	00054d63          	bltz	a0,80005218 <create+0x162>
    dp->nlink++;  // for ".."
    80005202:	04a4d783          	lhu	a5,74(s1)
    80005206:	2785                	addiw	a5,a5,1
    80005208:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000520c:	8526                	mv	a0,s1
    8000520e:	ffffe097          	auipc	ra,0xffffe
    80005212:	474080e7          	jalr	1140(ra) # 80003682 <iupdate>
    80005216:	b761                	j	8000519e <create+0xe8>
  ip->nlink = 0;
    80005218:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000521c:	8552                	mv	a0,s4
    8000521e:	ffffe097          	auipc	ra,0xffffe
    80005222:	464080e7          	jalr	1124(ra) # 80003682 <iupdate>
  iunlockput(ip);
    80005226:	8552                	mv	a0,s4
    80005228:	ffffe097          	auipc	ra,0xffffe
    8000522c:	786080e7          	jalr	1926(ra) # 800039ae <iunlockput>
  iunlockput(dp);
    80005230:	8526                	mv	a0,s1
    80005232:	ffffe097          	auipc	ra,0xffffe
    80005236:	77c080e7          	jalr	1916(ra) # 800039ae <iunlockput>
  return 0;
    8000523a:	bdcd                	j	8000512c <create+0x76>
    return 0;
    8000523c:	8aaa                	mv	s5,a0
    8000523e:	b5fd                	j	8000512c <create+0x76>

0000000080005240 <sys_dup>:
{
    80005240:	7179                	addi	sp,sp,-48
    80005242:	f406                	sd	ra,40(sp)
    80005244:	f022                	sd	s0,32(sp)
    80005246:	ec26                	sd	s1,24(sp)
    80005248:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000524a:	fd840613          	addi	a2,s0,-40
    8000524e:	4581                	li	a1,0
    80005250:	4501                	li	a0,0
    80005252:	00000097          	auipc	ra,0x0
    80005256:	dc2080e7          	jalr	-574(ra) # 80005014 <argfd>
    return -1;
    8000525a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000525c:	02054363          	bltz	a0,80005282 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80005260:	fd843503          	ld	a0,-40(s0)
    80005264:	00000097          	auipc	ra,0x0
    80005268:	e10080e7          	jalr	-496(ra) # 80005074 <fdalloc>
    8000526c:	84aa                	mv	s1,a0
    return -1;
    8000526e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005270:	00054963          	bltz	a0,80005282 <sys_dup+0x42>
  filedup(f);
    80005274:	fd843503          	ld	a0,-40(s0)
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	310080e7          	jalr	784(ra) # 80004588 <filedup>
  return fd;
    80005280:	87a6                	mv	a5,s1
}
    80005282:	853e                	mv	a0,a5
    80005284:	70a2                	ld	ra,40(sp)
    80005286:	7402                	ld	s0,32(sp)
    80005288:	64e2                	ld	s1,24(sp)
    8000528a:	6145                	addi	sp,sp,48
    8000528c:	8082                	ret

000000008000528e <sys_read>:
{
    8000528e:	7179                	addi	sp,sp,-48
    80005290:	f406                	sd	ra,40(sp)
    80005292:	f022                	sd	s0,32(sp)
    80005294:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005296:	fd840593          	addi	a1,s0,-40
    8000529a:	4505                	li	a0,1
    8000529c:	ffffe097          	auipc	ra,0xffffe
    800052a0:	922080e7          	jalr	-1758(ra) # 80002bbe <argaddr>
  argint(2, &n);
    800052a4:	fe440593          	addi	a1,s0,-28
    800052a8:	4509                	li	a0,2
    800052aa:	ffffe097          	auipc	ra,0xffffe
    800052ae:	8f4080e7          	jalr	-1804(ra) # 80002b9e <argint>
  if(argfd(0, 0, &f) < 0)
    800052b2:	fe840613          	addi	a2,s0,-24
    800052b6:	4581                	li	a1,0
    800052b8:	4501                	li	a0,0
    800052ba:	00000097          	auipc	ra,0x0
    800052be:	d5a080e7          	jalr	-678(ra) # 80005014 <argfd>
    800052c2:	87aa                	mv	a5,a0
    return -1;
    800052c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800052c6:	0007cc63          	bltz	a5,800052de <sys_read+0x50>
  return fileread(f, p, n);
    800052ca:	fe442603          	lw	a2,-28(s0)
    800052ce:	fd843583          	ld	a1,-40(s0)
    800052d2:	fe843503          	ld	a0,-24(s0)
    800052d6:	fffff097          	auipc	ra,0xfffff
    800052da:	43e080e7          	jalr	1086(ra) # 80004714 <fileread>
}
    800052de:	70a2                	ld	ra,40(sp)
    800052e0:	7402                	ld	s0,32(sp)
    800052e2:	6145                	addi	sp,sp,48
    800052e4:	8082                	ret

00000000800052e6 <sys_write>:
{
    800052e6:	7179                	addi	sp,sp,-48
    800052e8:	f406                	sd	ra,40(sp)
    800052ea:	f022                	sd	s0,32(sp)
    800052ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800052ee:	fd840593          	addi	a1,s0,-40
    800052f2:	4505                	li	a0,1
    800052f4:	ffffe097          	auipc	ra,0xffffe
    800052f8:	8ca080e7          	jalr	-1846(ra) # 80002bbe <argaddr>
  argint(2, &n);
    800052fc:	fe440593          	addi	a1,s0,-28
    80005300:	4509                	li	a0,2
    80005302:	ffffe097          	auipc	ra,0xffffe
    80005306:	89c080e7          	jalr	-1892(ra) # 80002b9e <argint>
  if(argfd(0, 0, &f) < 0)
    8000530a:	fe840613          	addi	a2,s0,-24
    8000530e:	4581                	li	a1,0
    80005310:	4501                	li	a0,0
    80005312:	00000097          	auipc	ra,0x0
    80005316:	d02080e7          	jalr	-766(ra) # 80005014 <argfd>
    8000531a:	87aa                	mv	a5,a0
    return -1;
    8000531c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000531e:	0007cc63          	bltz	a5,80005336 <sys_write+0x50>
  return filewrite(f, p, n);
    80005322:	fe442603          	lw	a2,-28(s0)
    80005326:	fd843583          	ld	a1,-40(s0)
    8000532a:	fe843503          	ld	a0,-24(s0)
    8000532e:	fffff097          	auipc	ra,0xfffff
    80005332:	4a8080e7          	jalr	1192(ra) # 800047d6 <filewrite>
}
    80005336:	70a2                	ld	ra,40(sp)
    80005338:	7402                	ld	s0,32(sp)
    8000533a:	6145                	addi	sp,sp,48
    8000533c:	8082                	ret

000000008000533e <sys_close>:
{
    8000533e:	1101                	addi	sp,sp,-32
    80005340:	ec06                	sd	ra,24(sp)
    80005342:	e822                	sd	s0,16(sp)
    80005344:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005346:	fe040613          	addi	a2,s0,-32
    8000534a:	fec40593          	addi	a1,s0,-20
    8000534e:	4501                	li	a0,0
    80005350:	00000097          	auipc	ra,0x0
    80005354:	cc4080e7          	jalr	-828(ra) # 80005014 <argfd>
    return -1;
    80005358:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000535a:	02054563          	bltz	a0,80005384 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    8000535e:	ffffc097          	auipc	ra,0xffffc
    80005362:	64e080e7          	jalr	1614(ra) # 800019ac <myproc>
    80005366:	fec42783          	lw	a5,-20(s0)
    8000536a:	02078793          	addi	a5,a5,32
    8000536e:	078e                	slli	a5,a5,0x3
    80005370:	97aa                	add	a5,a5,a0
    80005372:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005376:	fe043503          	ld	a0,-32(s0)
    8000537a:	fffff097          	auipc	ra,0xfffff
    8000537e:	260080e7          	jalr	608(ra) # 800045da <fileclose>
  return 0;
    80005382:	4781                	li	a5,0
}
    80005384:	853e                	mv	a0,a5
    80005386:	60e2                	ld	ra,24(sp)
    80005388:	6442                	ld	s0,16(sp)
    8000538a:	6105                	addi	sp,sp,32
    8000538c:	8082                	ret

000000008000538e <sys_fstat>:
{
    8000538e:	1101                	addi	sp,sp,-32
    80005390:	ec06                	sd	ra,24(sp)
    80005392:	e822                	sd	s0,16(sp)
    80005394:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005396:	fe040593          	addi	a1,s0,-32
    8000539a:	4505                	li	a0,1
    8000539c:	ffffe097          	auipc	ra,0xffffe
    800053a0:	822080e7          	jalr	-2014(ra) # 80002bbe <argaddr>
  if(argfd(0, 0, &f) < 0)
    800053a4:	fe840613          	addi	a2,s0,-24
    800053a8:	4581                	li	a1,0
    800053aa:	4501                	li	a0,0
    800053ac:	00000097          	auipc	ra,0x0
    800053b0:	c68080e7          	jalr	-920(ra) # 80005014 <argfd>
    800053b4:	87aa                	mv	a5,a0
    return -1;
    800053b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053b8:	0007ca63          	bltz	a5,800053cc <sys_fstat+0x3e>
  return filestat(f, st);
    800053bc:	fe043583          	ld	a1,-32(s0)
    800053c0:	fe843503          	ld	a0,-24(s0)
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	2de080e7          	jalr	734(ra) # 800046a2 <filestat>
}
    800053cc:	60e2                	ld	ra,24(sp)
    800053ce:	6442                	ld	s0,16(sp)
    800053d0:	6105                	addi	sp,sp,32
    800053d2:	8082                	ret

00000000800053d4 <sys_link>:
{
    800053d4:	7169                	addi	sp,sp,-304
    800053d6:	f606                	sd	ra,296(sp)
    800053d8:	f222                	sd	s0,288(sp)
    800053da:	ee26                	sd	s1,280(sp)
    800053dc:	ea4a                	sd	s2,272(sp)
    800053de:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053e0:	08000613          	li	a2,128
    800053e4:	ed040593          	addi	a1,s0,-304
    800053e8:	4501                	li	a0,0
    800053ea:	ffffd097          	auipc	ra,0xffffd
    800053ee:	7f4080e7          	jalr	2036(ra) # 80002bde <argstr>
    return -1;
    800053f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053f4:	10054e63          	bltz	a0,80005510 <sys_link+0x13c>
    800053f8:	08000613          	li	a2,128
    800053fc:	f5040593          	addi	a1,s0,-176
    80005400:	4505                	li	a0,1
    80005402:	ffffd097          	auipc	ra,0xffffd
    80005406:	7dc080e7          	jalr	2012(ra) # 80002bde <argstr>
    return -1;
    8000540a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000540c:	10054263          	bltz	a0,80005510 <sys_link+0x13c>
  begin_op();
    80005410:	fffff097          	auipc	ra,0xfffff
    80005414:	cfe080e7          	jalr	-770(ra) # 8000410e <begin_op>
  if((ip = namei(old)) == 0){
    80005418:	ed040513          	addi	a0,s0,-304
    8000541c:	fffff097          	auipc	ra,0xfffff
    80005420:	ad6080e7          	jalr	-1322(ra) # 80003ef2 <namei>
    80005424:	84aa                	mv	s1,a0
    80005426:	c551                	beqz	a0,800054b2 <sys_link+0xde>
  ilock(ip);
    80005428:	ffffe097          	auipc	ra,0xffffe
    8000542c:	324080e7          	jalr	804(ra) # 8000374c <ilock>
  if(ip->type == T_DIR){
    80005430:	04449703          	lh	a4,68(s1)
    80005434:	4785                	li	a5,1
    80005436:	08f70463          	beq	a4,a5,800054be <sys_link+0xea>
  ip->nlink++;
    8000543a:	04a4d783          	lhu	a5,74(s1)
    8000543e:	2785                	addiw	a5,a5,1
    80005440:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005444:	8526                	mv	a0,s1
    80005446:	ffffe097          	auipc	ra,0xffffe
    8000544a:	23c080e7          	jalr	572(ra) # 80003682 <iupdate>
  iunlock(ip);
    8000544e:	8526                	mv	a0,s1
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	3be080e7          	jalr	958(ra) # 8000380e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005458:	fd040593          	addi	a1,s0,-48
    8000545c:	f5040513          	addi	a0,s0,-176
    80005460:	fffff097          	auipc	ra,0xfffff
    80005464:	ab0080e7          	jalr	-1360(ra) # 80003f10 <nameiparent>
    80005468:	892a                	mv	s2,a0
    8000546a:	c935                	beqz	a0,800054de <sys_link+0x10a>
  ilock(dp);
    8000546c:	ffffe097          	auipc	ra,0xffffe
    80005470:	2e0080e7          	jalr	736(ra) # 8000374c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005474:	00092703          	lw	a4,0(s2)
    80005478:	409c                	lw	a5,0(s1)
    8000547a:	04f71d63          	bne	a4,a5,800054d4 <sys_link+0x100>
    8000547e:	40d0                	lw	a2,4(s1)
    80005480:	fd040593          	addi	a1,s0,-48
    80005484:	854a                	mv	a0,s2
    80005486:	fffff097          	auipc	ra,0xfffff
    8000548a:	9ba080e7          	jalr	-1606(ra) # 80003e40 <dirlink>
    8000548e:	04054363          	bltz	a0,800054d4 <sys_link+0x100>
  iunlockput(dp);
    80005492:	854a                	mv	a0,s2
    80005494:	ffffe097          	auipc	ra,0xffffe
    80005498:	51a080e7          	jalr	1306(ra) # 800039ae <iunlockput>
  iput(ip);
    8000549c:	8526                	mv	a0,s1
    8000549e:	ffffe097          	auipc	ra,0xffffe
    800054a2:	468080e7          	jalr	1128(ra) # 80003906 <iput>
  end_op();
    800054a6:	fffff097          	auipc	ra,0xfffff
    800054aa:	ce8080e7          	jalr	-792(ra) # 8000418e <end_op>
  return 0;
    800054ae:	4781                	li	a5,0
    800054b0:	a085                	j	80005510 <sys_link+0x13c>
    end_op();
    800054b2:	fffff097          	auipc	ra,0xfffff
    800054b6:	cdc080e7          	jalr	-804(ra) # 8000418e <end_op>
    return -1;
    800054ba:	57fd                	li	a5,-1
    800054bc:	a891                	j	80005510 <sys_link+0x13c>
    iunlockput(ip);
    800054be:	8526                	mv	a0,s1
    800054c0:	ffffe097          	auipc	ra,0xffffe
    800054c4:	4ee080e7          	jalr	1262(ra) # 800039ae <iunlockput>
    end_op();
    800054c8:	fffff097          	auipc	ra,0xfffff
    800054cc:	cc6080e7          	jalr	-826(ra) # 8000418e <end_op>
    return -1;
    800054d0:	57fd                	li	a5,-1
    800054d2:	a83d                	j	80005510 <sys_link+0x13c>
    iunlockput(dp);
    800054d4:	854a                	mv	a0,s2
    800054d6:	ffffe097          	auipc	ra,0xffffe
    800054da:	4d8080e7          	jalr	1240(ra) # 800039ae <iunlockput>
  ilock(ip);
    800054de:	8526                	mv	a0,s1
    800054e0:	ffffe097          	auipc	ra,0xffffe
    800054e4:	26c080e7          	jalr	620(ra) # 8000374c <ilock>
  ip->nlink--;
    800054e8:	04a4d783          	lhu	a5,74(s1)
    800054ec:	37fd                	addiw	a5,a5,-1
    800054ee:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800054f2:	8526                	mv	a0,s1
    800054f4:	ffffe097          	auipc	ra,0xffffe
    800054f8:	18e080e7          	jalr	398(ra) # 80003682 <iupdate>
  iunlockput(ip);
    800054fc:	8526                	mv	a0,s1
    800054fe:	ffffe097          	auipc	ra,0xffffe
    80005502:	4b0080e7          	jalr	1200(ra) # 800039ae <iunlockput>
  end_op();
    80005506:	fffff097          	auipc	ra,0xfffff
    8000550a:	c88080e7          	jalr	-888(ra) # 8000418e <end_op>
  return -1;
    8000550e:	57fd                	li	a5,-1
}
    80005510:	853e                	mv	a0,a5
    80005512:	70b2                	ld	ra,296(sp)
    80005514:	7412                	ld	s0,288(sp)
    80005516:	64f2                	ld	s1,280(sp)
    80005518:	6952                	ld	s2,272(sp)
    8000551a:	6155                	addi	sp,sp,304
    8000551c:	8082                	ret

000000008000551e <sys_unlink>:
{
    8000551e:	7151                	addi	sp,sp,-240
    80005520:	f586                	sd	ra,232(sp)
    80005522:	f1a2                	sd	s0,224(sp)
    80005524:	eda6                	sd	s1,216(sp)
    80005526:	e9ca                	sd	s2,208(sp)
    80005528:	e5ce                	sd	s3,200(sp)
    8000552a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000552c:	08000613          	li	a2,128
    80005530:	f3040593          	addi	a1,s0,-208
    80005534:	4501                	li	a0,0
    80005536:	ffffd097          	auipc	ra,0xffffd
    8000553a:	6a8080e7          	jalr	1704(ra) # 80002bde <argstr>
    8000553e:	18054163          	bltz	a0,800056c0 <sys_unlink+0x1a2>
  begin_op();
    80005542:	fffff097          	auipc	ra,0xfffff
    80005546:	bcc080e7          	jalr	-1076(ra) # 8000410e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000554a:	fb040593          	addi	a1,s0,-80
    8000554e:	f3040513          	addi	a0,s0,-208
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	9be080e7          	jalr	-1602(ra) # 80003f10 <nameiparent>
    8000555a:	84aa                	mv	s1,a0
    8000555c:	c979                	beqz	a0,80005632 <sys_unlink+0x114>
  ilock(dp);
    8000555e:	ffffe097          	auipc	ra,0xffffe
    80005562:	1ee080e7          	jalr	494(ra) # 8000374c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005566:	00003597          	auipc	a1,0x3
    8000556a:	1a258593          	addi	a1,a1,418 # 80008708 <syscalls+0x2a8>
    8000556e:	fb040513          	addi	a0,s0,-80
    80005572:	ffffe097          	auipc	ra,0xffffe
    80005576:	6a4080e7          	jalr	1700(ra) # 80003c16 <namecmp>
    8000557a:	14050a63          	beqz	a0,800056ce <sys_unlink+0x1b0>
    8000557e:	00003597          	auipc	a1,0x3
    80005582:	19258593          	addi	a1,a1,402 # 80008710 <syscalls+0x2b0>
    80005586:	fb040513          	addi	a0,s0,-80
    8000558a:	ffffe097          	auipc	ra,0xffffe
    8000558e:	68c080e7          	jalr	1676(ra) # 80003c16 <namecmp>
    80005592:	12050e63          	beqz	a0,800056ce <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005596:	f2c40613          	addi	a2,s0,-212
    8000559a:	fb040593          	addi	a1,s0,-80
    8000559e:	8526                	mv	a0,s1
    800055a0:	ffffe097          	auipc	ra,0xffffe
    800055a4:	690080e7          	jalr	1680(ra) # 80003c30 <dirlookup>
    800055a8:	892a                	mv	s2,a0
    800055aa:	12050263          	beqz	a0,800056ce <sys_unlink+0x1b0>
  ilock(ip);
    800055ae:	ffffe097          	auipc	ra,0xffffe
    800055b2:	19e080e7          	jalr	414(ra) # 8000374c <ilock>
  if(ip->nlink < 1)
    800055b6:	04a91783          	lh	a5,74(s2)
    800055ba:	08f05263          	blez	a5,8000563e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055be:	04491703          	lh	a4,68(s2)
    800055c2:	4785                	li	a5,1
    800055c4:	08f70563          	beq	a4,a5,8000564e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055c8:	4641                	li	a2,16
    800055ca:	4581                	li	a1,0
    800055cc:	fc040513          	addi	a0,s0,-64
    800055d0:	ffffb097          	auipc	ra,0xffffb
    800055d4:	702080e7          	jalr	1794(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055d8:	4741                	li	a4,16
    800055da:	f2c42683          	lw	a3,-212(s0)
    800055de:	fc040613          	addi	a2,s0,-64
    800055e2:	4581                	li	a1,0
    800055e4:	8526                	mv	a0,s1
    800055e6:	ffffe097          	auipc	ra,0xffffe
    800055ea:	512080e7          	jalr	1298(ra) # 80003af8 <writei>
    800055ee:	47c1                	li	a5,16
    800055f0:	0af51563          	bne	a0,a5,8000569a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800055f4:	04491703          	lh	a4,68(s2)
    800055f8:	4785                	li	a5,1
    800055fa:	0af70863          	beq	a4,a5,800056aa <sys_unlink+0x18c>
  iunlockput(dp);
    800055fe:	8526                	mv	a0,s1
    80005600:	ffffe097          	auipc	ra,0xffffe
    80005604:	3ae080e7          	jalr	942(ra) # 800039ae <iunlockput>
  ip->nlink--;
    80005608:	04a95783          	lhu	a5,74(s2)
    8000560c:	37fd                	addiw	a5,a5,-1
    8000560e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005612:	854a                	mv	a0,s2
    80005614:	ffffe097          	auipc	ra,0xffffe
    80005618:	06e080e7          	jalr	110(ra) # 80003682 <iupdate>
  iunlockput(ip);
    8000561c:	854a                	mv	a0,s2
    8000561e:	ffffe097          	auipc	ra,0xffffe
    80005622:	390080e7          	jalr	912(ra) # 800039ae <iunlockput>
  end_op();
    80005626:	fffff097          	auipc	ra,0xfffff
    8000562a:	b68080e7          	jalr	-1176(ra) # 8000418e <end_op>
  return 0;
    8000562e:	4501                	li	a0,0
    80005630:	a84d                	j	800056e2 <sys_unlink+0x1c4>
    end_op();
    80005632:	fffff097          	auipc	ra,0xfffff
    80005636:	b5c080e7          	jalr	-1188(ra) # 8000418e <end_op>
    return -1;
    8000563a:	557d                	li	a0,-1
    8000563c:	a05d                	j	800056e2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000563e:	00003517          	auipc	a0,0x3
    80005642:	0da50513          	addi	a0,a0,218 # 80008718 <syscalls+0x2b8>
    80005646:	ffffb097          	auipc	ra,0xffffb
    8000564a:	ef8080e7          	jalr	-264(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000564e:	04c92703          	lw	a4,76(s2)
    80005652:	02000793          	li	a5,32
    80005656:	f6e7f9e3          	bgeu	a5,a4,800055c8 <sys_unlink+0xaa>
    8000565a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000565e:	4741                	li	a4,16
    80005660:	86ce                	mv	a3,s3
    80005662:	f1840613          	addi	a2,s0,-232
    80005666:	4581                	li	a1,0
    80005668:	854a                	mv	a0,s2
    8000566a:	ffffe097          	auipc	ra,0xffffe
    8000566e:	396080e7          	jalr	918(ra) # 80003a00 <readi>
    80005672:	47c1                	li	a5,16
    80005674:	00f51b63          	bne	a0,a5,8000568a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005678:	f1845783          	lhu	a5,-232(s0)
    8000567c:	e7a1                	bnez	a5,800056c4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000567e:	29c1                	addiw	s3,s3,16
    80005680:	04c92783          	lw	a5,76(s2)
    80005684:	fcf9ede3          	bltu	s3,a5,8000565e <sys_unlink+0x140>
    80005688:	b781                	j	800055c8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000568a:	00003517          	auipc	a0,0x3
    8000568e:	0a650513          	addi	a0,a0,166 # 80008730 <syscalls+0x2d0>
    80005692:	ffffb097          	auipc	ra,0xffffb
    80005696:	eac080e7          	jalr	-340(ra) # 8000053e <panic>
    panic("unlink: writei");
    8000569a:	00003517          	auipc	a0,0x3
    8000569e:	0ae50513          	addi	a0,a0,174 # 80008748 <syscalls+0x2e8>
    800056a2:	ffffb097          	auipc	ra,0xffffb
    800056a6:	e9c080e7          	jalr	-356(ra) # 8000053e <panic>
    dp->nlink--;
    800056aa:	04a4d783          	lhu	a5,74(s1)
    800056ae:	37fd                	addiw	a5,a5,-1
    800056b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056b4:	8526                	mv	a0,s1
    800056b6:	ffffe097          	auipc	ra,0xffffe
    800056ba:	fcc080e7          	jalr	-52(ra) # 80003682 <iupdate>
    800056be:	b781                	j	800055fe <sys_unlink+0xe0>
    return -1;
    800056c0:	557d                	li	a0,-1
    800056c2:	a005                	j	800056e2 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056c4:	854a                	mv	a0,s2
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	2e8080e7          	jalr	744(ra) # 800039ae <iunlockput>
  iunlockput(dp);
    800056ce:	8526                	mv	a0,s1
    800056d0:	ffffe097          	auipc	ra,0xffffe
    800056d4:	2de080e7          	jalr	734(ra) # 800039ae <iunlockput>
  end_op();
    800056d8:	fffff097          	auipc	ra,0xfffff
    800056dc:	ab6080e7          	jalr	-1354(ra) # 8000418e <end_op>
  return -1;
    800056e0:	557d                	li	a0,-1
}
    800056e2:	70ae                	ld	ra,232(sp)
    800056e4:	740e                	ld	s0,224(sp)
    800056e6:	64ee                	ld	s1,216(sp)
    800056e8:	694e                	ld	s2,208(sp)
    800056ea:	69ae                	ld	s3,200(sp)
    800056ec:	616d                	addi	sp,sp,240
    800056ee:	8082                	ret

00000000800056f0 <sys_open>:

uint64
sys_open(void)
{
    800056f0:	7131                	addi	sp,sp,-192
    800056f2:	fd06                	sd	ra,184(sp)
    800056f4:	f922                	sd	s0,176(sp)
    800056f6:	f526                	sd	s1,168(sp)
    800056f8:	f14a                	sd	s2,160(sp)
    800056fa:	ed4e                	sd	s3,152(sp)
    800056fc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800056fe:	f4c40593          	addi	a1,s0,-180
    80005702:	4505                	li	a0,1
    80005704:	ffffd097          	auipc	ra,0xffffd
    80005708:	49a080e7          	jalr	1178(ra) # 80002b9e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000570c:	08000613          	li	a2,128
    80005710:	f5040593          	addi	a1,s0,-176
    80005714:	4501                	li	a0,0
    80005716:	ffffd097          	auipc	ra,0xffffd
    8000571a:	4c8080e7          	jalr	1224(ra) # 80002bde <argstr>
    8000571e:	87aa                	mv	a5,a0
    return -1;
    80005720:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005722:	0a07c963          	bltz	a5,800057d4 <sys_open+0xe4>

  begin_op();
    80005726:	fffff097          	auipc	ra,0xfffff
    8000572a:	9e8080e7          	jalr	-1560(ra) # 8000410e <begin_op>

  if(omode & O_CREATE){
    8000572e:	f4c42783          	lw	a5,-180(s0)
    80005732:	2007f793          	andi	a5,a5,512
    80005736:	cfc5                	beqz	a5,800057ee <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005738:	4681                	li	a3,0
    8000573a:	4601                	li	a2,0
    8000573c:	4589                	li	a1,2
    8000573e:	f5040513          	addi	a0,s0,-176
    80005742:	00000097          	auipc	ra,0x0
    80005746:	974080e7          	jalr	-1676(ra) # 800050b6 <create>
    8000574a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000574c:	c959                	beqz	a0,800057e2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000574e:	04449703          	lh	a4,68(s1)
    80005752:	478d                	li	a5,3
    80005754:	00f71763          	bne	a4,a5,80005762 <sys_open+0x72>
    80005758:	0464d703          	lhu	a4,70(s1)
    8000575c:	47a5                	li	a5,9
    8000575e:	0ce7ed63          	bltu	a5,a4,80005838 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005762:	fffff097          	auipc	ra,0xfffff
    80005766:	dbc080e7          	jalr	-580(ra) # 8000451e <filealloc>
    8000576a:	89aa                	mv	s3,a0
    8000576c:	10050363          	beqz	a0,80005872 <sys_open+0x182>
    80005770:	00000097          	auipc	ra,0x0
    80005774:	904080e7          	jalr	-1788(ra) # 80005074 <fdalloc>
    80005778:	892a                	mv	s2,a0
    8000577a:	0e054763          	bltz	a0,80005868 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000577e:	04449703          	lh	a4,68(s1)
    80005782:	478d                	li	a5,3
    80005784:	0cf70563          	beq	a4,a5,8000584e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005788:	4789                	li	a5,2
    8000578a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000578e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005792:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005796:	f4c42783          	lw	a5,-180(s0)
    8000579a:	0017c713          	xori	a4,a5,1
    8000579e:	8b05                	andi	a4,a4,1
    800057a0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800057a4:	0037f713          	andi	a4,a5,3
    800057a8:	00e03733          	snez	a4,a4
    800057ac:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057b0:	4007f793          	andi	a5,a5,1024
    800057b4:	c791                	beqz	a5,800057c0 <sys_open+0xd0>
    800057b6:	04449703          	lh	a4,68(s1)
    800057ba:	4789                	li	a5,2
    800057bc:	0af70063          	beq	a4,a5,8000585c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800057c0:	8526                	mv	a0,s1
    800057c2:	ffffe097          	auipc	ra,0xffffe
    800057c6:	04c080e7          	jalr	76(ra) # 8000380e <iunlock>
  end_op();
    800057ca:	fffff097          	auipc	ra,0xfffff
    800057ce:	9c4080e7          	jalr	-1596(ra) # 8000418e <end_op>

  return fd;
    800057d2:	854a                	mv	a0,s2
}
    800057d4:	70ea                	ld	ra,184(sp)
    800057d6:	744a                	ld	s0,176(sp)
    800057d8:	74aa                	ld	s1,168(sp)
    800057da:	790a                	ld	s2,160(sp)
    800057dc:	69ea                	ld	s3,152(sp)
    800057de:	6129                	addi	sp,sp,192
    800057e0:	8082                	ret
      end_op();
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	9ac080e7          	jalr	-1620(ra) # 8000418e <end_op>
      return -1;
    800057ea:	557d                	li	a0,-1
    800057ec:	b7e5                	j	800057d4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800057ee:	f5040513          	addi	a0,s0,-176
    800057f2:	ffffe097          	auipc	ra,0xffffe
    800057f6:	700080e7          	jalr	1792(ra) # 80003ef2 <namei>
    800057fa:	84aa                	mv	s1,a0
    800057fc:	c905                	beqz	a0,8000582c <sys_open+0x13c>
    ilock(ip);
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	f4e080e7          	jalr	-178(ra) # 8000374c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005806:	04449703          	lh	a4,68(s1)
    8000580a:	4785                	li	a5,1
    8000580c:	f4f711e3          	bne	a4,a5,8000574e <sys_open+0x5e>
    80005810:	f4c42783          	lw	a5,-180(s0)
    80005814:	d7b9                	beqz	a5,80005762 <sys_open+0x72>
      iunlockput(ip);
    80005816:	8526                	mv	a0,s1
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	196080e7          	jalr	406(ra) # 800039ae <iunlockput>
      end_op();
    80005820:	fffff097          	auipc	ra,0xfffff
    80005824:	96e080e7          	jalr	-1682(ra) # 8000418e <end_op>
      return -1;
    80005828:	557d                	li	a0,-1
    8000582a:	b76d                	j	800057d4 <sys_open+0xe4>
      end_op();
    8000582c:	fffff097          	auipc	ra,0xfffff
    80005830:	962080e7          	jalr	-1694(ra) # 8000418e <end_op>
      return -1;
    80005834:	557d                	li	a0,-1
    80005836:	bf79                	j	800057d4 <sys_open+0xe4>
    iunlockput(ip);
    80005838:	8526                	mv	a0,s1
    8000583a:	ffffe097          	auipc	ra,0xffffe
    8000583e:	174080e7          	jalr	372(ra) # 800039ae <iunlockput>
    end_op();
    80005842:	fffff097          	auipc	ra,0xfffff
    80005846:	94c080e7          	jalr	-1716(ra) # 8000418e <end_op>
    return -1;
    8000584a:	557d                	li	a0,-1
    8000584c:	b761                	j	800057d4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000584e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005852:	04649783          	lh	a5,70(s1)
    80005856:	02f99223          	sh	a5,36(s3)
    8000585a:	bf25                	j	80005792 <sys_open+0xa2>
    itrunc(ip);
    8000585c:	8526                	mv	a0,s1
    8000585e:	ffffe097          	auipc	ra,0xffffe
    80005862:	ffc080e7          	jalr	-4(ra) # 8000385a <itrunc>
    80005866:	bfa9                	j	800057c0 <sys_open+0xd0>
      fileclose(f);
    80005868:	854e                	mv	a0,s3
    8000586a:	fffff097          	auipc	ra,0xfffff
    8000586e:	d70080e7          	jalr	-656(ra) # 800045da <fileclose>
    iunlockput(ip);
    80005872:	8526                	mv	a0,s1
    80005874:	ffffe097          	auipc	ra,0xffffe
    80005878:	13a080e7          	jalr	314(ra) # 800039ae <iunlockput>
    end_op();
    8000587c:	fffff097          	auipc	ra,0xfffff
    80005880:	912080e7          	jalr	-1774(ra) # 8000418e <end_op>
    return -1;
    80005884:	557d                	li	a0,-1
    80005886:	b7b9                	j	800057d4 <sys_open+0xe4>

0000000080005888 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005888:	7175                	addi	sp,sp,-144
    8000588a:	e506                	sd	ra,136(sp)
    8000588c:	e122                	sd	s0,128(sp)
    8000588e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005890:	fffff097          	auipc	ra,0xfffff
    80005894:	87e080e7          	jalr	-1922(ra) # 8000410e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005898:	08000613          	li	a2,128
    8000589c:	f7040593          	addi	a1,s0,-144
    800058a0:	4501                	li	a0,0
    800058a2:	ffffd097          	auipc	ra,0xffffd
    800058a6:	33c080e7          	jalr	828(ra) # 80002bde <argstr>
    800058aa:	02054963          	bltz	a0,800058dc <sys_mkdir+0x54>
    800058ae:	4681                	li	a3,0
    800058b0:	4601                	li	a2,0
    800058b2:	4585                	li	a1,1
    800058b4:	f7040513          	addi	a0,s0,-144
    800058b8:	fffff097          	auipc	ra,0xfffff
    800058bc:	7fe080e7          	jalr	2046(ra) # 800050b6 <create>
    800058c0:	cd11                	beqz	a0,800058dc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	0ec080e7          	jalr	236(ra) # 800039ae <iunlockput>
  end_op();
    800058ca:	fffff097          	auipc	ra,0xfffff
    800058ce:	8c4080e7          	jalr	-1852(ra) # 8000418e <end_op>
  return 0;
    800058d2:	4501                	li	a0,0
}
    800058d4:	60aa                	ld	ra,136(sp)
    800058d6:	640a                	ld	s0,128(sp)
    800058d8:	6149                	addi	sp,sp,144
    800058da:	8082                	ret
    end_op();
    800058dc:	fffff097          	auipc	ra,0xfffff
    800058e0:	8b2080e7          	jalr	-1870(ra) # 8000418e <end_op>
    return -1;
    800058e4:	557d                	li	a0,-1
    800058e6:	b7fd                	j	800058d4 <sys_mkdir+0x4c>

00000000800058e8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800058e8:	7135                	addi	sp,sp,-160
    800058ea:	ed06                	sd	ra,152(sp)
    800058ec:	e922                	sd	s0,144(sp)
    800058ee:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800058f0:	fffff097          	auipc	ra,0xfffff
    800058f4:	81e080e7          	jalr	-2018(ra) # 8000410e <begin_op>
  argint(1, &major);
    800058f8:	f6c40593          	addi	a1,s0,-148
    800058fc:	4505                	li	a0,1
    800058fe:	ffffd097          	auipc	ra,0xffffd
    80005902:	2a0080e7          	jalr	672(ra) # 80002b9e <argint>
  argint(2, &minor);
    80005906:	f6840593          	addi	a1,s0,-152
    8000590a:	4509                	li	a0,2
    8000590c:	ffffd097          	auipc	ra,0xffffd
    80005910:	292080e7          	jalr	658(ra) # 80002b9e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005914:	08000613          	li	a2,128
    80005918:	f7040593          	addi	a1,s0,-144
    8000591c:	4501                	li	a0,0
    8000591e:	ffffd097          	auipc	ra,0xffffd
    80005922:	2c0080e7          	jalr	704(ra) # 80002bde <argstr>
    80005926:	02054b63          	bltz	a0,8000595c <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000592a:	f6841683          	lh	a3,-152(s0)
    8000592e:	f6c41603          	lh	a2,-148(s0)
    80005932:	458d                	li	a1,3
    80005934:	f7040513          	addi	a0,s0,-144
    80005938:	fffff097          	auipc	ra,0xfffff
    8000593c:	77e080e7          	jalr	1918(ra) # 800050b6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005940:	cd11                	beqz	a0,8000595c <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005942:	ffffe097          	auipc	ra,0xffffe
    80005946:	06c080e7          	jalr	108(ra) # 800039ae <iunlockput>
  end_op();
    8000594a:	fffff097          	auipc	ra,0xfffff
    8000594e:	844080e7          	jalr	-1980(ra) # 8000418e <end_op>
  return 0;
    80005952:	4501                	li	a0,0
}
    80005954:	60ea                	ld	ra,152(sp)
    80005956:	644a                	ld	s0,144(sp)
    80005958:	610d                	addi	sp,sp,160
    8000595a:	8082                	ret
    end_op();
    8000595c:	fffff097          	auipc	ra,0xfffff
    80005960:	832080e7          	jalr	-1998(ra) # 8000418e <end_op>
    return -1;
    80005964:	557d                	li	a0,-1
    80005966:	b7fd                	j	80005954 <sys_mknod+0x6c>

0000000080005968 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005968:	7135                	addi	sp,sp,-160
    8000596a:	ed06                	sd	ra,152(sp)
    8000596c:	e922                	sd	s0,144(sp)
    8000596e:	e526                	sd	s1,136(sp)
    80005970:	e14a                	sd	s2,128(sp)
    80005972:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005974:	ffffc097          	auipc	ra,0xffffc
    80005978:	038080e7          	jalr	56(ra) # 800019ac <myproc>
    8000597c:	892a                	mv	s2,a0
  
  begin_op();
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	790080e7          	jalr	1936(ra) # 8000410e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005986:	08000613          	li	a2,128
    8000598a:	f6040593          	addi	a1,s0,-160
    8000598e:	4501                	li	a0,0
    80005990:	ffffd097          	auipc	ra,0xffffd
    80005994:	24e080e7          	jalr	590(ra) # 80002bde <argstr>
    80005998:	04054b63          	bltz	a0,800059ee <sys_chdir+0x86>
    8000599c:	f6040513          	addi	a0,s0,-160
    800059a0:	ffffe097          	auipc	ra,0xffffe
    800059a4:	552080e7          	jalr	1362(ra) # 80003ef2 <namei>
    800059a8:	84aa                	mv	s1,a0
    800059aa:	c131                	beqz	a0,800059ee <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059ac:	ffffe097          	auipc	ra,0xffffe
    800059b0:	da0080e7          	jalr	-608(ra) # 8000374c <ilock>
  if(ip->type != T_DIR){
    800059b4:	04449703          	lh	a4,68(s1)
    800059b8:	4785                	li	a5,1
    800059ba:	04f71063          	bne	a4,a5,800059fa <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059be:	8526                	mv	a0,s1
    800059c0:	ffffe097          	auipc	ra,0xffffe
    800059c4:	e4e080e7          	jalr	-434(ra) # 8000380e <iunlock>
  iput(p->cwd);
    800059c8:	18093503          	ld	a0,384(s2)
    800059cc:	ffffe097          	auipc	ra,0xffffe
    800059d0:	f3a080e7          	jalr	-198(ra) # 80003906 <iput>
  end_op();
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	7ba080e7          	jalr	1978(ra) # 8000418e <end_op>
  p->cwd = ip;
    800059dc:	18993023          	sd	s1,384(s2)
  return 0;
    800059e0:	4501                	li	a0,0
}
    800059e2:	60ea                	ld	ra,152(sp)
    800059e4:	644a                	ld	s0,144(sp)
    800059e6:	64aa                	ld	s1,136(sp)
    800059e8:	690a                	ld	s2,128(sp)
    800059ea:	610d                	addi	sp,sp,160
    800059ec:	8082                	ret
    end_op();
    800059ee:	ffffe097          	auipc	ra,0xffffe
    800059f2:	7a0080e7          	jalr	1952(ra) # 8000418e <end_op>
    return -1;
    800059f6:	557d                	li	a0,-1
    800059f8:	b7ed                	j	800059e2 <sys_chdir+0x7a>
    iunlockput(ip);
    800059fa:	8526                	mv	a0,s1
    800059fc:	ffffe097          	auipc	ra,0xffffe
    80005a00:	fb2080e7          	jalr	-78(ra) # 800039ae <iunlockput>
    end_op();
    80005a04:	ffffe097          	auipc	ra,0xffffe
    80005a08:	78a080e7          	jalr	1930(ra) # 8000418e <end_op>
    return -1;
    80005a0c:	557d                	li	a0,-1
    80005a0e:	bfd1                	j	800059e2 <sys_chdir+0x7a>

0000000080005a10 <sys_exec>:

uint64
sys_exec(void)
{
    80005a10:	7145                	addi	sp,sp,-464
    80005a12:	e786                	sd	ra,456(sp)
    80005a14:	e3a2                	sd	s0,448(sp)
    80005a16:	ff26                	sd	s1,440(sp)
    80005a18:	fb4a                	sd	s2,432(sp)
    80005a1a:	f74e                	sd	s3,424(sp)
    80005a1c:	f352                	sd	s4,416(sp)
    80005a1e:	ef56                	sd	s5,408(sp)
    80005a20:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005a22:	e3840593          	addi	a1,s0,-456
    80005a26:	4505                	li	a0,1
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	196080e7          	jalr	406(ra) # 80002bbe <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005a30:	08000613          	li	a2,128
    80005a34:	f4040593          	addi	a1,s0,-192
    80005a38:	4501                	li	a0,0
    80005a3a:	ffffd097          	auipc	ra,0xffffd
    80005a3e:	1a4080e7          	jalr	420(ra) # 80002bde <argstr>
    80005a42:	87aa                	mv	a5,a0
    return -1;
    80005a44:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005a46:	0c07c263          	bltz	a5,80005b0a <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005a4a:	10000613          	li	a2,256
    80005a4e:	4581                	li	a1,0
    80005a50:	e4040513          	addi	a0,s0,-448
    80005a54:	ffffb097          	auipc	ra,0xffffb
    80005a58:	27e080e7          	jalr	638(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a5c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005a60:	89a6                	mv	s3,s1
    80005a62:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a64:	02000a13          	li	s4,32
    80005a68:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a6c:	00391793          	slli	a5,s2,0x3
    80005a70:	e3040593          	addi	a1,s0,-464
    80005a74:	e3843503          	ld	a0,-456(s0)
    80005a78:	953e                	add	a0,a0,a5
    80005a7a:	ffffd097          	auipc	ra,0xffffd
    80005a7e:	086080e7          	jalr	134(ra) # 80002b00 <fetchaddr>
    80005a82:	02054a63          	bltz	a0,80005ab6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005a86:	e3043783          	ld	a5,-464(s0)
    80005a8a:	c3b9                	beqz	a5,80005ad0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a8c:	ffffb097          	auipc	ra,0xffffb
    80005a90:	05a080e7          	jalr	90(ra) # 80000ae6 <kalloc>
    80005a94:	85aa                	mv	a1,a0
    80005a96:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a9a:	cd11                	beqz	a0,80005ab6 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a9c:	6605                	lui	a2,0x1
    80005a9e:	e3043503          	ld	a0,-464(s0)
    80005aa2:	ffffd097          	auipc	ra,0xffffd
    80005aa6:	0b0080e7          	jalr	176(ra) # 80002b52 <fetchstr>
    80005aaa:	00054663          	bltz	a0,80005ab6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005aae:	0905                	addi	s2,s2,1
    80005ab0:	09a1                	addi	s3,s3,8
    80005ab2:	fb491be3          	bne	s2,s4,80005a68 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ab6:	10048913          	addi	s2,s1,256
    80005aba:	6088                	ld	a0,0(s1)
    80005abc:	c531                	beqz	a0,80005b08 <sys_exec+0xf8>
    kfree(argv[i]);
    80005abe:	ffffb097          	auipc	ra,0xffffb
    80005ac2:	f2c080e7          	jalr	-212(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ac6:	04a1                	addi	s1,s1,8
    80005ac8:	ff2499e3          	bne	s1,s2,80005aba <sys_exec+0xaa>
  return -1;
    80005acc:	557d                	li	a0,-1
    80005ace:	a835                	j	80005b0a <sys_exec+0xfa>
      argv[i] = 0;
    80005ad0:	0a8e                	slli	s5,s5,0x3
    80005ad2:	fc040793          	addi	a5,s0,-64
    80005ad6:	9abe                	add	s5,s5,a5
    80005ad8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005adc:	e4040593          	addi	a1,s0,-448
    80005ae0:	f4040513          	addi	a0,s0,-192
    80005ae4:	fffff097          	auipc	ra,0xfffff
    80005ae8:	170080e7          	jalr	368(ra) # 80004c54 <exec>
    80005aec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aee:	10048993          	addi	s3,s1,256
    80005af2:	6088                	ld	a0,0(s1)
    80005af4:	c901                	beqz	a0,80005b04 <sys_exec+0xf4>
    kfree(argv[i]);
    80005af6:	ffffb097          	auipc	ra,0xffffb
    80005afa:	ef4080e7          	jalr	-268(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005afe:	04a1                	addi	s1,s1,8
    80005b00:	ff3499e3          	bne	s1,s3,80005af2 <sys_exec+0xe2>
  return ret;
    80005b04:	854a                	mv	a0,s2
    80005b06:	a011                	j	80005b0a <sys_exec+0xfa>
  return -1;
    80005b08:	557d                	li	a0,-1
}
    80005b0a:	60be                	ld	ra,456(sp)
    80005b0c:	641e                	ld	s0,448(sp)
    80005b0e:	74fa                	ld	s1,440(sp)
    80005b10:	795a                	ld	s2,432(sp)
    80005b12:	79ba                	ld	s3,424(sp)
    80005b14:	7a1a                	ld	s4,416(sp)
    80005b16:	6afa                	ld	s5,408(sp)
    80005b18:	6179                	addi	sp,sp,464
    80005b1a:	8082                	ret

0000000080005b1c <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b1c:	7139                	addi	sp,sp,-64
    80005b1e:	fc06                	sd	ra,56(sp)
    80005b20:	f822                	sd	s0,48(sp)
    80005b22:	f426                	sd	s1,40(sp)
    80005b24:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b26:	ffffc097          	auipc	ra,0xffffc
    80005b2a:	e86080e7          	jalr	-378(ra) # 800019ac <myproc>
    80005b2e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005b30:	fd840593          	addi	a1,s0,-40
    80005b34:	4501                	li	a0,0
    80005b36:	ffffd097          	auipc	ra,0xffffd
    80005b3a:	088080e7          	jalr	136(ra) # 80002bbe <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005b3e:	fc840593          	addi	a1,s0,-56
    80005b42:	fd040513          	addi	a0,s0,-48
    80005b46:	fffff097          	auipc	ra,0xfffff
    80005b4a:	dc4080e7          	jalr	-572(ra) # 8000490a <pipealloc>
    return -1;
    80005b4e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b50:	0c054763          	bltz	a0,80005c1e <sys_pipe+0x102>
  fd0 = -1;
    80005b54:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b58:	fd043503          	ld	a0,-48(s0)
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	518080e7          	jalr	1304(ra) # 80005074 <fdalloc>
    80005b64:	fca42223          	sw	a0,-60(s0)
    80005b68:	08054e63          	bltz	a0,80005c04 <sys_pipe+0xe8>
    80005b6c:	fc843503          	ld	a0,-56(s0)
    80005b70:	fffff097          	auipc	ra,0xfffff
    80005b74:	504080e7          	jalr	1284(ra) # 80005074 <fdalloc>
    80005b78:	fca42023          	sw	a0,-64(s0)
    80005b7c:	06054a63          	bltz	a0,80005bf0 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b80:	4691                	li	a3,4
    80005b82:	fc440613          	addi	a2,s0,-60
    80005b86:	fd843583          	ld	a1,-40(s0)
    80005b8a:	60c8                	ld	a0,128(s1)
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	adc080e7          	jalr	-1316(ra) # 80001668 <copyout>
    80005b94:	02054063          	bltz	a0,80005bb4 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b98:	4691                	li	a3,4
    80005b9a:	fc040613          	addi	a2,s0,-64
    80005b9e:	fd843583          	ld	a1,-40(s0)
    80005ba2:	0591                	addi	a1,a1,4
    80005ba4:	60c8                	ld	a0,128(s1)
    80005ba6:	ffffc097          	auipc	ra,0xffffc
    80005baa:	ac2080e7          	jalr	-1342(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005bae:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bb0:	06055763          	bgez	a0,80005c1e <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80005bb4:	fc442783          	lw	a5,-60(s0)
    80005bb8:	02078793          	addi	a5,a5,32
    80005bbc:	078e                	slli	a5,a5,0x3
    80005bbe:	97a6                	add	a5,a5,s1
    80005bc0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005bc4:	fc042503          	lw	a0,-64(s0)
    80005bc8:	02050513          	addi	a0,a0,32
    80005bcc:	050e                	slli	a0,a0,0x3
    80005bce:	94aa                	add	s1,s1,a0
    80005bd0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005bd4:	fd043503          	ld	a0,-48(s0)
    80005bd8:	fffff097          	auipc	ra,0xfffff
    80005bdc:	a02080e7          	jalr	-1534(ra) # 800045da <fileclose>
    fileclose(wf);
    80005be0:	fc843503          	ld	a0,-56(s0)
    80005be4:	fffff097          	auipc	ra,0xfffff
    80005be8:	9f6080e7          	jalr	-1546(ra) # 800045da <fileclose>
    return -1;
    80005bec:	57fd                	li	a5,-1
    80005bee:	a805                	j	80005c1e <sys_pipe+0x102>
    if(fd0 >= 0)
    80005bf0:	fc442783          	lw	a5,-60(s0)
    80005bf4:	0007c863          	bltz	a5,80005c04 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    80005bf8:	02078793          	addi	a5,a5,32
    80005bfc:	078e                	slli	a5,a5,0x3
    80005bfe:	94be                	add	s1,s1,a5
    80005c00:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005c04:	fd043503          	ld	a0,-48(s0)
    80005c08:	fffff097          	auipc	ra,0xfffff
    80005c0c:	9d2080e7          	jalr	-1582(ra) # 800045da <fileclose>
    fileclose(wf);
    80005c10:	fc843503          	ld	a0,-56(s0)
    80005c14:	fffff097          	auipc	ra,0xfffff
    80005c18:	9c6080e7          	jalr	-1594(ra) # 800045da <fileclose>
    return -1;
    80005c1c:	57fd                	li	a5,-1
}
    80005c1e:	853e                	mv	a0,a5
    80005c20:	70e2                	ld	ra,56(sp)
    80005c22:	7442                	ld	s0,48(sp)
    80005c24:	74a2                	ld	s1,40(sp)
    80005c26:	6121                	addi	sp,sp,64
    80005c28:	8082                	ret
    80005c2a:	0000                	unimp
    80005c2c:	0000                	unimp
	...

0000000080005c30 <kernelvec>:
    80005c30:	7111                	addi	sp,sp,-256
    80005c32:	e006                	sd	ra,0(sp)
    80005c34:	e40a                	sd	sp,8(sp)
    80005c36:	e80e                	sd	gp,16(sp)
    80005c38:	ec12                	sd	tp,24(sp)
    80005c3a:	f016                	sd	t0,32(sp)
    80005c3c:	f41a                	sd	t1,40(sp)
    80005c3e:	f81e                	sd	t2,48(sp)
    80005c40:	fc22                	sd	s0,56(sp)
    80005c42:	e0a6                	sd	s1,64(sp)
    80005c44:	e4aa                	sd	a0,72(sp)
    80005c46:	e8ae                	sd	a1,80(sp)
    80005c48:	ecb2                	sd	a2,88(sp)
    80005c4a:	f0b6                	sd	a3,96(sp)
    80005c4c:	f4ba                	sd	a4,104(sp)
    80005c4e:	f8be                	sd	a5,112(sp)
    80005c50:	fcc2                	sd	a6,120(sp)
    80005c52:	e146                	sd	a7,128(sp)
    80005c54:	e54a                	sd	s2,136(sp)
    80005c56:	e94e                	sd	s3,144(sp)
    80005c58:	ed52                	sd	s4,152(sp)
    80005c5a:	f156                	sd	s5,160(sp)
    80005c5c:	f55a                	sd	s6,168(sp)
    80005c5e:	f95e                	sd	s7,176(sp)
    80005c60:	fd62                	sd	s8,184(sp)
    80005c62:	e1e6                	sd	s9,192(sp)
    80005c64:	e5ea                	sd	s10,200(sp)
    80005c66:	e9ee                	sd	s11,208(sp)
    80005c68:	edf2                	sd	t3,216(sp)
    80005c6a:	f1f6                	sd	t4,224(sp)
    80005c6c:	f5fa                	sd	t5,232(sp)
    80005c6e:	f9fe                	sd	t6,240(sp)
    80005c70:	d5dfc0ef          	jal	ra,800029cc <kerneltrap>
    80005c74:	6082                	ld	ra,0(sp)
    80005c76:	6122                	ld	sp,8(sp)
    80005c78:	61c2                	ld	gp,16(sp)
    80005c7a:	7282                	ld	t0,32(sp)
    80005c7c:	7322                	ld	t1,40(sp)
    80005c7e:	73c2                	ld	t2,48(sp)
    80005c80:	7462                	ld	s0,56(sp)
    80005c82:	6486                	ld	s1,64(sp)
    80005c84:	6526                	ld	a0,72(sp)
    80005c86:	65c6                	ld	a1,80(sp)
    80005c88:	6666                	ld	a2,88(sp)
    80005c8a:	7686                	ld	a3,96(sp)
    80005c8c:	7726                	ld	a4,104(sp)
    80005c8e:	77c6                	ld	a5,112(sp)
    80005c90:	7866                	ld	a6,120(sp)
    80005c92:	688a                	ld	a7,128(sp)
    80005c94:	692a                	ld	s2,136(sp)
    80005c96:	69ca                	ld	s3,144(sp)
    80005c98:	6a6a                	ld	s4,152(sp)
    80005c9a:	7a8a                	ld	s5,160(sp)
    80005c9c:	7b2a                	ld	s6,168(sp)
    80005c9e:	7bca                	ld	s7,176(sp)
    80005ca0:	7c6a                	ld	s8,184(sp)
    80005ca2:	6c8e                	ld	s9,192(sp)
    80005ca4:	6d2e                	ld	s10,200(sp)
    80005ca6:	6dce                	ld	s11,208(sp)
    80005ca8:	6e6e                	ld	t3,216(sp)
    80005caa:	7e8e                	ld	t4,224(sp)
    80005cac:	7f2e                	ld	t5,232(sp)
    80005cae:	7fce                	ld	t6,240(sp)
    80005cb0:	6111                	addi	sp,sp,256
    80005cb2:	10200073          	sret
    80005cb6:	00000013          	nop
    80005cba:	00000013          	nop
    80005cbe:	0001                	nop

0000000080005cc0 <timervec>:
    80005cc0:	34051573          	csrrw	a0,mscratch,a0
    80005cc4:	e10c                	sd	a1,0(a0)
    80005cc6:	e510                	sd	a2,8(a0)
    80005cc8:	e914                	sd	a3,16(a0)
    80005cca:	6d0c                	ld	a1,24(a0)
    80005ccc:	7110                	ld	a2,32(a0)
    80005cce:	6194                	ld	a3,0(a1)
    80005cd0:	96b2                	add	a3,a3,a2
    80005cd2:	e194                	sd	a3,0(a1)
    80005cd4:	4589                	li	a1,2
    80005cd6:	14459073          	csrw	sip,a1
    80005cda:	6914                	ld	a3,16(a0)
    80005cdc:	6510                	ld	a2,8(a0)
    80005cde:	610c                	ld	a1,0(a0)
    80005ce0:	34051573          	csrrw	a0,mscratch,a0
    80005ce4:	30200073          	mret
	...

0000000080005cea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005cea:	1141                	addi	sp,sp,-16
    80005cec:	e422                	sd	s0,8(sp)
    80005cee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005cf0:	0c0007b7          	lui	a5,0xc000
    80005cf4:	4705                	li	a4,1
    80005cf6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005cf8:	c3d8                	sw	a4,4(a5)
}
    80005cfa:	6422                	ld	s0,8(sp)
    80005cfc:	0141                	addi	sp,sp,16
    80005cfe:	8082                	ret

0000000080005d00 <plicinithart>:

void
plicinithart(void)
{
    80005d00:	1141                	addi	sp,sp,-16
    80005d02:	e406                	sd	ra,8(sp)
    80005d04:	e022                	sd	s0,0(sp)
    80005d06:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d08:	ffffc097          	auipc	ra,0xffffc
    80005d0c:	c78080e7          	jalr	-904(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d10:	0085171b          	slliw	a4,a0,0x8
    80005d14:	0c0027b7          	lui	a5,0xc002
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	40200713          	li	a4,1026
    80005d1e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d22:	00d5151b          	slliw	a0,a0,0xd
    80005d26:	0c2017b7          	lui	a5,0xc201
    80005d2a:	953e                	add	a0,a0,a5
    80005d2c:	00052023          	sw	zero,0(a0)
}
    80005d30:	60a2                	ld	ra,8(sp)
    80005d32:	6402                	ld	s0,0(sp)
    80005d34:	0141                	addi	sp,sp,16
    80005d36:	8082                	ret

0000000080005d38 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d38:	1141                	addi	sp,sp,-16
    80005d3a:	e406                	sd	ra,8(sp)
    80005d3c:	e022                	sd	s0,0(sp)
    80005d3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d40:	ffffc097          	auipc	ra,0xffffc
    80005d44:	c40080e7          	jalr	-960(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d48:	00d5179b          	slliw	a5,a0,0xd
    80005d4c:	0c201537          	lui	a0,0xc201
    80005d50:	953e                	add	a0,a0,a5
  return irq;
}
    80005d52:	4148                	lw	a0,4(a0)
    80005d54:	60a2                	ld	ra,8(sp)
    80005d56:	6402                	ld	s0,0(sp)
    80005d58:	0141                	addi	sp,sp,16
    80005d5a:	8082                	ret

0000000080005d5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d5c:	1101                	addi	sp,sp,-32
    80005d5e:	ec06                	sd	ra,24(sp)
    80005d60:	e822                	sd	s0,16(sp)
    80005d62:	e426                	sd	s1,8(sp)
    80005d64:	1000                	addi	s0,sp,32
    80005d66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d68:	ffffc097          	auipc	ra,0xffffc
    80005d6c:	c18080e7          	jalr	-1000(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d70:	00d5151b          	slliw	a0,a0,0xd
    80005d74:	0c2017b7          	lui	a5,0xc201
    80005d78:	97aa                	add	a5,a5,a0
    80005d7a:	c3c4                	sw	s1,4(a5)
}
    80005d7c:	60e2                	ld	ra,24(sp)
    80005d7e:	6442                	ld	s0,16(sp)
    80005d80:	64a2                	ld	s1,8(sp)
    80005d82:	6105                	addi	sp,sp,32
    80005d84:	8082                	ret

0000000080005d86 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d86:	1141                	addi	sp,sp,-16
    80005d88:	e406                	sd	ra,8(sp)
    80005d8a:	e022                	sd	s0,0(sp)
    80005d8c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d8e:	479d                	li	a5,7
    80005d90:	04a7cc63          	blt	a5,a0,80005de8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005d94:	0001d797          	auipc	a5,0x1d
    80005d98:	aac78793          	addi	a5,a5,-1364 # 80022840 <disk>
    80005d9c:	97aa                	add	a5,a5,a0
    80005d9e:	0187c783          	lbu	a5,24(a5)
    80005da2:	ebb9                	bnez	a5,80005df8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005da4:	00451613          	slli	a2,a0,0x4
    80005da8:	0001d797          	auipc	a5,0x1d
    80005dac:	a9878793          	addi	a5,a5,-1384 # 80022840 <disk>
    80005db0:	6394                	ld	a3,0(a5)
    80005db2:	96b2                	add	a3,a3,a2
    80005db4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005db8:	6398                	ld	a4,0(a5)
    80005dba:	9732                	add	a4,a4,a2
    80005dbc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005dc0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005dc4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005dc8:	953e                	add	a0,a0,a5
    80005dca:	4785                	li	a5,1
    80005dcc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005dd0:	0001d517          	auipc	a0,0x1d
    80005dd4:	a8850513          	addi	a0,a0,-1400 # 80022858 <disk+0x18>
    80005dd8:	ffffc097          	auipc	ra,0xffffc
    80005ddc:	356080e7          	jalr	854(ra) # 8000212e <wakeup>
}
    80005de0:	60a2                	ld	ra,8(sp)
    80005de2:	6402                	ld	s0,0(sp)
    80005de4:	0141                	addi	sp,sp,16
    80005de6:	8082                	ret
    panic("free_desc 1");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	97050513          	addi	a0,a0,-1680 # 80008758 <syscalls+0x2f8>
    80005df0:	ffffa097          	auipc	ra,0xffffa
    80005df4:	74e080e7          	jalr	1870(ra) # 8000053e <panic>
    panic("free_desc 2");
    80005df8:	00003517          	auipc	a0,0x3
    80005dfc:	97050513          	addi	a0,a0,-1680 # 80008768 <syscalls+0x308>
    80005e00:	ffffa097          	auipc	ra,0xffffa
    80005e04:	73e080e7          	jalr	1854(ra) # 8000053e <panic>

0000000080005e08 <virtio_disk_init>:
{
    80005e08:	1101                	addi	sp,sp,-32
    80005e0a:	ec06                	sd	ra,24(sp)
    80005e0c:	e822                	sd	s0,16(sp)
    80005e0e:	e426                	sd	s1,8(sp)
    80005e10:	e04a                	sd	s2,0(sp)
    80005e12:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e14:	00003597          	auipc	a1,0x3
    80005e18:	96458593          	addi	a1,a1,-1692 # 80008778 <syscalls+0x318>
    80005e1c:	0001d517          	auipc	a0,0x1d
    80005e20:	b4c50513          	addi	a0,a0,-1204 # 80022968 <disk+0x128>
    80005e24:	ffffb097          	auipc	ra,0xffffb
    80005e28:	d22080e7          	jalr	-734(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e2c:	100017b7          	lui	a5,0x10001
    80005e30:	4398                	lw	a4,0(a5)
    80005e32:	2701                	sext.w	a4,a4
    80005e34:	747277b7          	lui	a5,0x74727
    80005e38:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e3c:	14f71c63          	bne	a4,a5,80005f94 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e40:	100017b7          	lui	a5,0x10001
    80005e44:	43dc                	lw	a5,4(a5)
    80005e46:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e48:	4709                	li	a4,2
    80005e4a:	14e79563          	bne	a5,a4,80005f94 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e4e:	100017b7          	lui	a5,0x10001
    80005e52:	479c                	lw	a5,8(a5)
    80005e54:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005e56:	12e79f63          	bne	a5,a4,80005f94 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e5a:	100017b7          	lui	a5,0x10001
    80005e5e:	47d8                	lw	a4,12(a5)
    80005e60:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e62:	554d47b7          	lui	a5,0x554d4
    80005e66:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e6a:	12f71563          	bne	a4,a5,80005f94 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e6e:	100017b7          	lui	a5,0x10001
    80005e72:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e76:	4705                	li	a4,1
    80005e78:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e7a:	470d                	li	a4,3
    80005e7c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e7e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e80:	c7ffe737          	lui	a4,0xc7ffe
    80005e84:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbddf>
    80005e88:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e8a:	2701                	sext.w	a4,a4
    80005e8c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e8e:	472d                	li	a4,11
    80005e90:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005e92:	5bbc                	lw	a5,112(a5)
    80005e94:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005e98:	8ba1                	andi	a5,a5,8
    80005e9a:	10078563          	beqz	a5,80005fa4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e9e:	100017b7          	lui	a5,0x10001
    80005ea2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005ea6:	43fc                	lw	a5,68(a5)
    80005ea8:	2781                	sext.w	a5,a5
    80005eaa:	10079563          	bnez	a5,80005fb4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005eae:	100017b7          	lui	a5,0x10001
    80005eb2:	5bdc                	lw	a5,52(a5)
    80005eb4:	2781                	sext.w	a5,a5
  if(max == 0)
    80005eb6:	10078763          	beqz	a5,80005fc4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    80005eba:	471d                	li	a4,7
    80005ebc:	10f77c63          	bgeu	a4,a5,80005fd4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005ec0:	ffffb097          	auipc	ra,0xffffb
    80005ec4:	c26080e7          	jalr	-986(ra) # 80000ae6 <kalloc>
    80005ec8:	0001d497          	auipc	s1,0x1d
    80005ecc:	97848493          	addi	s1,s1,-1672 # 80022840 <disk>
    80005ed0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005ed2:	ffffb097          	auipc	ra,0xffffb
    80005ed6:	c14080e7          	jalr	-1004(ra) # 80000ae6 <kalloc>
    80005eda:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005edc:	ffffb097          	auipc	ra,0xffffb
    80005ee0:	c0a080e7          	jalr	-1014(ra) # 80000ae6 <kalloc>
    80005ee4:	87aa                	mv	a5,a0
    80005ee6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005ee8:	6088                	ld	a0,0(s1)
    80005eea:	cd6d                	beqz	a0,80005fe4 <virtio_disk_init+0x1dc>
    80005eec:	0001d717          	auipc	a4,0x1d
    80005ef0:	95c73703          	ld	a4,-1700(a4) # 80022848 <disk+0x8>
    80005ef4:	cb65                	beqz	a4,80005fe4 <virtio_disk_init+0x1dc>
    80005ef6:	c7fd                	beqz	a5,80005fe4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005ef8:	6605                	lui	a2,0x1
    80005efa:	4581                	li	a1,0
    80005efc:	ffffb097          	auipc	ra,0xffffb
    80005f00:	dd6080e7          	jalr	-554(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005f04:	0001d497          	auipc	s1,0x1d
    80005f08:	93c48493          	addi	s1,s1,-1732 # 80022840 <disk>
    80005f0c:	6605                	lui	a2,0x1
    80005f0e:	4581                	li	a1,0
    80005f10:	6488                	ld	a0,8(s1)
    80005f12:	ffffb097          	auipc	ra,0xffffb
    80005f16:	dc0080e7          	jalr	-576(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005f1a:	6605                	lui	a2,0x1
    80005f1c:	4581                	li	a1,0
    80005f1e:	6888                	ld	a0,16(s1)
    80005f20:	ffffb097          	auipc	ra,0xffffb
    80005f24:	db2080e7          	jalr	-590(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005f28:	100017b7          	lui	a5,0x10001
    80005f2c:	4721                	li	a4,8
    80005f2e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005f30:	4098                	lw	a4,0(s1)
    80005f32:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005f36:	40d8                	lw	a4,4(s1)
    80005f38:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005f3c:	6498                	ld	a4,8(s1)
    80005f3e:	0007069b          	sext.w	a3,a4
    80005f42:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005f46:	9701                	srai	a4,a4,0x20
    80005f48:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005f4c:	6898                	ld	a4,16(s1)
    80005f4e:	0007069b          	sext.w	a3,a4
    80005f52:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005f56:	9701                	srai	a4,a4,0x20
    80005f58:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005f5c:	4705                	li	a4,1
    80005f5e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80005f60:	00e48c23          	sb	a4,24(s1)
    80005f64:	00e48ca3          	sb	a4,25(s1)
    80005f68:	00e48d23          	sb	a4,26(s1)
    80005f6c:	00e48da3          	sb	a4,27(s1)
    80005f70:	00e48e23          	sb	a4,28(s1)
    80005f74:	00e48ea3          	sb	a4,29(s1)
    80005f78:	00e48f23          	sb	a4,30(s1)
    80005f7c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005f80:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f84:	0727a823          	sw	s2,112(a5)
}
    80005f88:	60e2                	ld	ra,24(sp)
    80005f8a:	6442                	ld	s0,16(sp)
    80005f8c:	64a2                	ld	s1,8(sp)
    80005f8e:	6902                	ld	s2,0(sp)
    80005f90:	6105                	addi	sp,sp,32
    80005f92:	8082                	ret
    panic("could not find virtio disk");
    80005f94:	00002517          	auipc	a0,0x2
    80005f98:	7f450513          	addi	a0,a0,2036 # 80008788 <syscalls+0x328>
    80005f9c:	ffffa097          	auipc	ra,0xffffa
    80005fa0:	5a2080e7          	jalr	1442(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    80005fa4:	00003517          	auipc	a0,0x3
    80005fa8:	80450513          	addi	a0,a0,-2044 # 800087a8 <syscalls+0x348>
    80005fac:	ffffa097          	auipc	ra,0xffffa
    80005fb0:	592080e7          	jalr	1426(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80005fb4:	00003517          	auipc	a0,0x3
    80005fb8:	81450513          	addi	a0,a0,-2028 # 800087c8 <syscalls+0x368>
    80005fbc:	ffffa097          	auipc	ra,0xffffa
    80005fc0:	582080e7          	jalr	1410(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80005fc4:	00003517          	auipc	a0,0x3
    80005fc8:	82450513          	addi	a0,a0,-2012 # 800087e8 <syscalls+0x388>
    80005fcc:	ffffa097          	auipc	ra,0xffffa
    80005fd0:	572080e7          	jalr	1394(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80005fd4:	00003517          	auipc	a0,0x3
    80005fd8:	83450513          	addi	a0,a0,-1996 # 80008808 <syscalls+0x3a8>
    80005fdc:	ffffa097          	auipc	ra,0xffffa
    80005fe0:	562080e7          	jalr	1378(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80005fe4:	00003517          	auipc	a0,0x3
    80005fe8:	84450513          	addi	a0,a0,-1980 # 80008828 <syscalls+0x3c8>
    80005fec:	ffffa097          	auipc	ra,0xffffa
    80005ff0:	552080e7          	jalr	1362(ra) # 8000053e <panic>

0000000080005ff4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005ff4:	7119                	addi	sp,sp,-128
    80005ff6:	fc86                	sd	ra,120(sp)
    80005ff8:	f8a2                	sd	s0,112(sp)
    80005ffa:	f4a6                	sd	s1,104(sp)
    80005ffc:	f0ca                	sd	s2,96(sp)
    80005ffe:	ecce                	sd	s3,88(sp)
    80006000:	e8d2                	sd	s4,80(sp)
    80006002:	e4d6                	sd	s5,72(sp)
    80006004:	e0da                	sd	s6,64(sp)
    80006006:	fc5e                	sd	s7,56(sp)
    80006008:	f862                	sd	s8,48(sp)
    8000600a:	f466                	sd	s9,40(sp)
    8000600c:	f06a                	sd	s10,32(sp)
    8000600e:	ec6e                	sd	s11,24(sp)
    80006010:	0100                	addi	s0,sp,128
    80006012:	8aaa                	mv	s5,a0
    80006014:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006016:	00c52d03          	lw	s10,12(a0)
    8000601a:	001d1d1b          	slliw	s10,s10,0x1
    8000601e:	1d02                	slli	s10,s10,0x20
    80006020:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006024:	0001d517          	auipc	a0,0x1d
    80006028:	94450513          	addi	a0,a0,-1724 # 80022968 <disk+0x128>
    8000602c:	ffffb097          	auipc	ra,0xffffb
    80006030:	baa080e7          	jalr	-1110(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006034:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006036:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006038:	0001db97          	auipc	s7,0x1d
    8000603c:	808b8b93          	addi	s7,s7,-2040 # 80022840 <disk>
  for(int i = 0; i < 3; i++){
    80006040:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006042:	0001dc97          	auipc	s9,0x1d
    80006046:	926c8c93          	addi	s9,s9,-1754 # 80022968 <disk+0x128>
    8000604a:	a08d                	j	800060ac <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000604c:	00fb8733          	add	a4,s7,a5
    80006050:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006054:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006056:	0207c563          	bltz	a5,80006080 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000605a:	2905                	addiw	s2,s2,1
    8000605c:	0611                	addi	a2,a2,4
    8000605e:	05690c63          	beq	s2,s6,800060b6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006062:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006064:	0001c717          	auipc	a4,0x1c
    80006068:	7dc70713          	addi	a4,a4,2012 # 80022840 <disk>
    8000606c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000606e:	01874683          	lbu	a3,24(a4)
    80006072:	fee9                	bnez	a3,8000604c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006074:	2785                	addiw	a5,a5,1
    80006076:	0705                	addi	a4,a4,1
    80006078:	fe979be3          	bne	a5,s1,8000606e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000607c:	57fd                	li	a5,-1
    8000607e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006080:	01205d63          	blez	s2,8000609a <virtio_disk_rw+0xa6>
    80006084:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006086:	000a2503          	lw	a0,0(s4)
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	cfc080e7          	jalr	-772(ra) # 80005d86 <free_desc>
      for(int j = 0; j < i; j++)
    80006092:	2d85                	addiw	s11,s11,1
    80006094:	0a11                	addi	s4,s4,4
    80006096:	ffb918e3          	bne	s2,s11,80006086 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000609a:	85e6                	mv	a1,s9
    8000609c:	0001c517          	auipc	a0,0x1c
    800060a0:	7bc50513          	addi	a0,a0,1980 # 80022858 <disk+0x18>
    800060a4:	ffffc097          	auipc	ra,0xffffc
    800060a8:	026080e7          	jalr	38(ra) # 800020ca <sleep>
  for(int i = 0; i < 3; i++){
    800060ac:	f8040a13          	addi	s4,s0,-128
{
    800060b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800060b2:	894e                	mv	s2,s3
    800060b4:	b77d                	j	80006062 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060b6:	f8042583          	lw	a1,-128(s0)
    800060ba:	00a58793          	addi	a5,a1,10
    800060be:	0792                	slli	a5,a5,0x4

  if(write)
    800060c0:	0001c617          	auipc	a2,0x1c
    800060c4:	78060613          	addi	a2,a2,1920 # 80022840 <disk>
    800060c8:	00f60733          	add	a4,a2,a5
    800060cc:	018036b3          	snez	a3,s8
    800060d0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800060d2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800060d6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800060da:	f6078693          	addi	a3,a5,-160
    800060de:	6218                	ld	a4,0(a2)
    800060e0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800060e2:	00878513          	addi	a0,a5,8
    800060e6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800060e8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800060ea:	6208                	ld	a0,0(a2)
    800060ec:	96aa                	add	a3,a3,a0
    800060ee:	4741                	li	a4,16
    800060f0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800060f2:	4705                	li	a4,1
    800060f4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800060f8:	f8442703          	lw	a4,-124(s0)
    800060fc:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006100:	0712                	slli	a4,a4,0x4
    80006102:	953a                	add	a0,a0,a4
    80006104:	058a8693          	addi	a3,s5,88
    80006108:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000610a:	6208                	ld	a0,0(a2)
    8000610c:	972a                	add	a4,a4,a0
    8000610e:	40000693          	li	a3,1024
    80006112:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006114:	001c3c13          	seqz	s8,s8
    80006118:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000611a:	001c6c13          	ori	s8,s8,1
    8000611e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006122:	f8842603          	lw	a2,-120(s0)
    80006126:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000612a:	0001c697          	auipc	a3,0x1c
    8000612e:	71668693          	addi	a3,a3,1814 # 80022840 <disk>
    80006132:	00258713          	addi	a4,a1,2
    80006136:	0712                	slli	a4,a4,0x4
    80006138:	9736                	add	a4,a4,a3
    8000613a:	587d                	li	a6,-1
    8000613c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006140:	0612                	slli	a2,a2,0x4
    80006142:	9532                	add	a0,a0,a2
    80006144:	f9078793          	addi	a5,a5,-112
    80006148:	97b6                	add	a5,a5,a3
    8000614a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000614c:	629c                	ld	a5,0(a3)
    8000614e:	97b2                	add	a5,a5,a2
    80006150:	4605                	li	a2,1
    80006152:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006154:	4509                	li	a0,2
    80006156:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000615a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000615e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006162:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006166:	6698                	ld	a4,8(a3)
    80006168:	00275783          	lhu	a5,2(a4)
    8000616c:	8b9d                	andi	a5,a5,7
    8000616e:	0786                	slli	a5,a5,0x1
    80006170:	97ba                	add	a5,a5,a4
    80006172:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006176:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000617a:	6698                	ld	a4,8(a3)
    8000617c:	00275783          	lhu	a5,2(a4)
    80006180:	2785                	addiw	a5,a5,1
    80006182:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006186:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000618a:	100017b7          	lui	a5,0x10001
    8000618e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006192:	004aa783          	lw	a5,4(s5)
    80006196:	02c79163          	bne	a5,a2,800061b8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000619a:	0001c917          	auipc	s2,0x1c
    8000619e:	7ce90913          	addi	s2,s2,1998 # 80022968 <disk+0x128>
  while(b->disk == 1) {
    800061a2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800061a4:	85ca                	mv	a1,s2
    800061a6:	8556                	mv	a0,s5
    800061a8:	ffffc097          	auipc	ra,0xffffc
    800061ac:	f22080e7          	jalr	-222(ra) # 800020ca <sleep>
  while(b->disk == 1) {
    800061b0:	004aa783          	lw	a5,4(s5)
    800061b4:	fe9788e3          	beq	a5,s1,800061a4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800061b8:	f8042903          	lw	s2,-128(s0)
    800061bc:	00290793          	addi	a5,s2,2
    800061c0:	00479713          	slli	a4,a5,0x4
    800061c4:	0001c797          	auipc	a5,0x1c
    800061c8:	67c78793          	addi	a5,a5,1660 # 80022840 <disk>
    800061cc:	97ba                	add	a5,a5,a4
    800061ce:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800061d2:	0001c997          	auipc	s3,0x1c
    800061d6:	66e98993          	addi	s3,s3,1646 # 80022840 <disk>
    800061da:	00491713          	slli	a4,s2,0x4
    800061de:	0009b783          	ld	a5,0(s3)
    800061e2:	97ba                	add	a5,a5,a4
    800061e4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800061e8:	854a                	mv	a0,s2
    800061ea:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	b98080e7          	jalr	-1128(ra) # 80005d86 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800061f6:	8885                	andi	s1,s1,1
    800061f8:	f0ed                	bnez	s1,800061da <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800061fa:	0001c517          	auipc	a0,0x1c
    800061fe:	76e50513          	addi	a0,a0,1902 # 80022968 <disk+0x128>
    80006202:	ffffb097          	auipc	ra,0xffffb
    80006206:	a88080e7          	jalr	-1400(ra) # 80000c8a <release>
}
    8000620a:	70e6                	ld	ra,120(sp)
    8000620c:	7446                	ld	s0,112(sp)
    8000620e:	74a6                	ld	s1,104(sp)
    80006210:	7906                	ld	s2,96(sp)
    80006212:	69e6                	ld	s3,88(sp)
    80006214:	6a46                	ld	s4,80(sp)
    80006216:	6aa6                	ld	s5,72(sp)
    80006218:	6b06                	ld	s6,64(sp)
    8000621a:	7be2                	ld	s7,56(sp)
    8000621c:	7c42                	ld	s8,48(sp)
    8000621e:	7ca2                	ld	s9,40(sp)
    80006220:	7d02                	ld	s10,32(sp)
    80006222:	6de2                	ld	s11,24(sp)
    80006224:	6109                	addi	sp,sp,128
    80006226:	8082                	ret

0000000080006228 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006228:	1101                	addi	sp,sp,-32
    8000622a:	ec06                	sd	ra,24(sp)
    8000622c:	e822                	sd	s0,16(sp)
    8000622e:	e426                	sd	s1,8(sp)
    80006230:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006232:	0001c497          	auipc	s1,0x1c
    80006236:	60e48493          	addi	s1,s1,1550 # 80022840 <disk>
    8000623a:	0001c517          	auipc	a0,0x1c
    8000623e:	72e50513          	addi	a0,a0,1838 # 80022968 <disk+0x128>
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	994080e7          	jalr	-1644(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000624a:	10001737          	lui	a4,0x10001
    8000624e:	533c                	lw	a5,96(a4)
    80006250:	8b8d                	andi	a5,a5,3
    80006252:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006254:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006258:	689c                	ld	a5,16(s1)
    8000625a:	0204d703          	lhu	a4,32(s1)
    8000625e:	0027d783          	lhu	a5,2(a5)
    80006262:	04f70863          	beq	a4,a5,800062b2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006266:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000626a:	6898                	ld	a4,16(s1)
    8000626c:	0204d783          	lhu	a5,32(s1)
    80006270:	8b9d                	andi	a5,a5,7
    80006272:	078e                	slli	a5,a5,0x3
    80006274:	97ba                	add	a5,a5,a4
    80006276:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006278:	00278713          	addi	a4,a5,2
    8000627c:	0712                	slli	a4,a4,0x4
    8000627e:	9726                	add	a4,a4,s1
    80006280:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006284:	e721                	bnez	a4,800062cc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006286:	0789                	addi	a5,a5,2
    80006288:	0792                	slli	a5,a5,0x4
    8000628a:	97a6                	add	a5,a5,s1
    8000628c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000628e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006292:	ffffc097          	auipc	ra,0xffffc
    80006296:	e9c080e7          	jalr	-356(ra) # 8000212e <wakeup>

    disk.used_idx += 1;
    8000629a:	0204d783          	lhu	a5,32(s1)
    8000629e:	2785                	addiw	a5,a5,1
    800062a0:	17c2                	slli	a5,a5,0x30
    800062a2:	93c1                	srli	a5,a5,0x30
    800062a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800062a8:	6898                	ld	a4,16(s1)
    800062aa:	00275703          	lhu	a4,2(a4)
    800062ae:	faf71ce3          	bne	a4,a5,80006266 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800062b2:	0001c517          	auipc	a0,0x1c
    800062b6:	6b650513          	addi	a0,a0,1718 # 80022968 <disk+0x128>
    800062ba:	ffffb097          	auipc	ra,0xffffb
    800062be:	9d0080e7          	jalr	-1584(ra) # 80000c8a <release>
}
    800062c2:	60e2                	ld	ra,24(sp)
    800062c4:	6442                	ld	s0,16(sp)
    800062c6:	64a2                	ld	s1,8(sp)
    800062c8:	6105                	addi	sp,sp,32
    800062ca:	8082                	ret
      panic("virtio_disk_intr status");
    800062cc:	00002517          	auipc	a0,0x2
    800062d0:	57450513          	addi	a0,a0,1396 # 80008840 <syscalls+0x3e0>
    800062d4:	ffffa097          	auipc	ra,0xffffa
    800062d8:	26a080e7          	jalr	618(ra) # 8000053e <panic>
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
