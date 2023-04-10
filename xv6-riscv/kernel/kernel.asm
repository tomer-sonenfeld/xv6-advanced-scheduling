
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
    80000068:	d5c78793          	addi	a5,a5,-676 # 80005dc0 <timervec>
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
    80000130:	512080e7          	jalr	1298(ra) # 8000263e <either_copyin>
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
    800001cc:	27e080e7          	jalr	638(ra) # 80002446 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	f48080e7          	jalr	-184(ra) # 8000211e <sleep>
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
    80000216:	3d6080e7          	jalr	982(ra) # 800025e8 <either_copyout>
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
    800002f6:	3a2080e7          	jalr	930(ra) # 80002694 <procdump>
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
    8000044a:	d3c080e7          	jalr	-708(ra) # 80002182 <wakeup>
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
    80000896:	8f0080e7          	jalr	-1808(ra) # 80002182 <wakeup>
    
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
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	802080e7          	jalr	-2046(ra) # 8000211e <sleep>
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
    80000ec2:	93a080e7          	jalr	-1734(ra) # 800027f8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	f3a080e7          	jalr	-198(ra) # 80005e00 <plicinithart>
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
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	89a080e7          	jalr	-1894(ra) # 800027d0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	8ba080e7          	jalr	-1862(ra) # 800027f8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	ea4080e7          	jalr	-348(ra) # 80005dea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	eb2080e7          	jalr	-334(ra) # 80005e00 <plicinithart>
    binit();         // buffer cache
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	05a080e7          	jalr	90(ra) # 80002fb0 <binit>
    iinit();         // inode table
    80000f5e:	00002097          	auipc	ra,0x2
    80000f62:	6fe080e7          	jalr	1790(ra) # 8000365c <iinit>
    fileinit();      // file table
    80000f66:	00003097          	auipc	ra,0x3
    80000f6a:	69c080e7          	jalr	1692(ra) # 80004602 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	f9a080e7          	jalr	-102(ra) # 80005f08 <virtio_disk_init>
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
    80001962:	f4bc                	sd	a5,104(s1)
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
    80001a0a:	e0a080e7          	jalr	-502(ra) # 80002810 <usertrapret>
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
    80001a24:	bbc080e7          	jalr	-1092(ra) # 800035dc <fsinit>
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
    80001c84:	e0c8                	sd	a0,128(s1)
    80001c86:	c131                	beqz	a0,80001cca <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	00000097          	auipc	ra,0x0
    80001c8e:	de6080e7          	jalr	-538(ra) # 80001a70 <proc_pagetable>
    80001c92:	892a                	mv	s2,a0
    80001c94:	fca8                	sd	a0,120(s1)
  if(p->pagetable == 0){
    80001c96:	c531                	beqz	a0,80001ce2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001c98:	07000613          	li	a2,112
    80001c9c:	4581                	li	a1,0
    80001c9e:	08848513          	addi	a0,s1,136
    80001ca2:	fffff097          	auipc	ra,0xfffff
    80001ca6:	030080e7          	jalr	48(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001caa:	00000797          	auipc	a5,0x0
    80001cae:	d3a78793          	addi	a5,a5,-710 # 800019e4 <forkret>
    80001cb2:	e4dc                	sd	a5,136(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cb4:	74bc                	ld	a5,104(s1)
    80001cb6:	6705                	lui	a4,0x1
    80001cb8:	97ba                	add	a5,a5,a4
    80001cba:	e8dc                	sd	a5,144(s1)
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
    80001d22:	7d28                	ld	a0,120(a0)
    80001d24:	fffff097          	auipc	ra,0xfffff
    80001d28:	632080e7          	jalr	1586(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001d2c:	6785                	lui	a5,0x1
    80001d2e:	f8bc                	sd	a5,112(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d30:	60d8                	ld	a4,128(s1)
    80001d32:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d36:	60d8                	ld	a4,128(s1)
    80001d38:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d3a:	4641                	li	a2,16
    80001d3c:	00006597          	auipc	a1,0x6
    80001d40:	4c458593          	addi	a1,a1,1220 # 80008200 <digits+0x1c0>
    80001d44:	18048513          	addi	a0,s1,384
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	0d4080e7          	jalr	212(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	4c050513          	addi	a0,a0,1216 # 80008210 <digits+0x1d0>
    80001d58:	00002097          	auipc	ra,0x2
    80001d5c:	2a6080e7          	jalr	678(ra) # 80003ffe <namei>
    80001d60:	16a4bc23          	sd	a0,376(s1)
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
    80001d94:	792c                	ld	a1,112(a0)
  if(n > 0){
    80001d96:	01204c63          	bgtz	s2,80001dae <growproc+0x32>
  } else if(n < 0){
    80001d9a:	02094663          	bltz	s2,80001dc6 <growproc+0x4a>
  p->sz = sz;
    80001d9e:	f8ac                	sd	a1,112(s1)
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
    80001db4:	7d28                	ld	a0,120(a0)
    80001db6:	fffff097          	auipc	ra,0xfffff
    80001dba:	65a080e7          	jalr	1626(ra) # 80001410 <uvmalloc>
    80001dbe:	85aa                	mv	a1,a0
    80001dc0:	fd79                	bnez	a0,80001d9e <growproc+0x22>
      return -1;
    80001dc2:	557d                	li	a0,-1
    80001dc4:	bff9                	j	80001da2 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dc6:	00b90633          	add	a2,s2,a1
    80001dca:	7d28                	ld	a0,120(a0)
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
    80001e02:	070ab603          	ld	a2,112(s5)
    80001e06:	7d2c                	ld	a1,120(a0)
    80001e08:	078ab503          	ld	a0,120(s5)
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	758080e7          	jalr	1880(ra) # 80001564 <uvmcopy>
    80001e14:	04054863          	bltz	a0,80001e64 <fork+0x8c>
  np->sz = p->sz;
    80001e18:	070ab783          	ld	a5,112(s5)
    80001e1c:	06fa3823          	sd	a5,112(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e20:	080ab683          	ld	a3,128(s5)
    80001e24:	87b6                	mv	a5,a3
    80001e26:	080a3703          	ld	a4,128(s4)
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
    80001e4e:	080a3783          	ld	a5,128(s4)
    80001e52:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e56:	0f8a8493          	addi	s1,s5,248
    80001e5a:	0f8a0913          	addi	s2,s4,248
    80001e5e:	178a8993          	addi	s3,s5,376
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
    80001e88:	00003097          	auipc	ra,0x3
    80001e8c:	80c080e7          	jalr	-2036(ra) # 80004694 <filedup>
    80001e90:	00a93023          	sd	a0,0(s2)
    80001e94:	b7e5                	j	80001e7c <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e96:	178ab503          	ld	a0,376(s5)
    80001e9a:	00002097          	auipc	ra,0x2
    80001e9e:	980080e7          	jalr	-1664(ra) # 8000381a <idup>
    80001ea2:	16aa3c23          	sd	a0,376(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea6:	4641                	li	a2,16
    80001ea8:	180a8593          	addi	a1,s5,384
    80001eac:	180a0513          	addi	a0,s4,384
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
    80001ed8:	075a3023          	sd	s5,96(s4)
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
    80001f18:	7159                	addi	sp,sp,-112
    80001f1a:	f486                	sd	ra,104(sp)
    80001f1c:	f0a2                	sd	s0,96(sp)
    80001f1e:	eca6                	sd	s1,88(sp)
    80001f20:	e8ca                	sd	s2,80(sp)
    80001f22:	e4ce                	sd	s3,72(sp)
    80001f24:	e0d2                	sd	s4,64(sp)
    80001f26:	fc56                	sd	s5,56(sp)
    80001f28:	f85a                	sd	s6,48(sp)
    80001f2a:	f45e                	sd	s7,40(sp)
    80001f2c:	f062                	sd	s8,32(sp)
    80001f2e:	ec66                	sd	s9,24(sp)
    80001f30:	e86a                	sd	s10,16(sp)
    80001f32:	e46e                	sd	s11,8(sp)
    80001f34:	1880                	addi	s0,sp,112
    80001f36:	8792                	mv	a5,tp
  int id = r_tp();
    80001f38:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f3a:	00779d13          	slli	s10,a5,0x7
    80001f3e:	0000f717          	auipc	a4,0xf
    80001f42:	c3270713          	addi	a4,a4,-974 # 80010b70 <pid_lock>
    80001f46:	976a                	add	a4,a4,s10
    80001f48:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &min_acc_proc->context);
    80001f4c:	0000f717          	auipc	a4,0xf
    80001f50:	c5c70713          	addi	a4,a4,-932 # 80010ba8 <cpus+0x8>
    80001f54:	9d3a                	add	s10,s10,a4
    struct proc * min_acc_proc = 0;
    80001f56:	4c81                	li	s9,0
      if(p->state == RUNNABLE){
    80001f58:	4b8d                	li	s7,3
    for(p = proc; p < &proc[NPROC]; p++){
    80001f5a:	00015b17          	auipc	s6,0x15
    80001f5e:	646b0b13          	addi	s6,s6,1606 # 800175a0 <tickslock>
      min_acc_proc->state = RUNNING;
    80001f62:	4d91                	li	s11,4
      c->proc = min_acc_proc;
    80001f64:	079e                	slli	a5,a5,0x7
    80001f66:	0000fc17          	auipc	s8,0xf
    80001f6a:	c0ac0c13          	addi	s8,s8,-1014 # 80010b70 <pid_lock>
    80001f6e:	9c3e                	add	s8,s8,a5
    80001f70:	a835                	j	80001fac <scheduler+0x94>
        if(min_acc_proc == 0) {min_acc_proc = p;}
    80001f72:	8a26                	mv	s4,s1
    80001f74:	a8bd                	j	80001ff2 <scheduler+0xda>
      else {release(&p->lock);}
    80001f76:	8526                	mv	a0,s1
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	d12080e7          	jalr	-750(ra) # 80000c8a <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80001f80:	05696863          	bltu	s2,s6,80001fd0 <scheduler+0xb8>
    if(min_acc_proc != 0){
    80001f84:	020a0463          	beqz	s4,80001fac <scheduler+0x94>
      min_acc_proc->state = RUNNING;
    80001f88:	01ba2c23          	sw	s11,24(s4)
      c->proc = min_acc_proc;
    80001f8c:	034c3823          	sd	s4,48(s8)
      swtch(&c->context, &min_acc_proc->context);
    80001f90:	088a0593          	addi	a1,s4,136
    80001f94:	856a                	mv	a0,s10
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	7d0080e7          	jalr	2000(ra) # 80002766 <swtch>
      c->proc = 0;
    80001f9e:	020c3823          	sd	zero,48(s8)
      release(&min_acc_proc->lock);
    80001fa2:	8552                	mv	a0,s4
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	ce6080e7          	jalr	-794(ra) # 80000c8a <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb4:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++){
    80001fb8:	0000f497          	auipc	s1,0xf
    80001fbc:	fe848493          	addi	s1,s1,-24 # 80010fa0 <proc>
    80001fc0:	0000f917          	auipc	s2,0xf
    80001fc4:	17890913          	addi	s2,s2,376 # 80011138 <proc+0x198>
    struct proc * min_acc_proc = 0;
    80001fc8:	8a66                	mv	s4,s9
    80001fca:	a039                	j	80001fd8 <scheduler+0xc0>
    for(p = proc; p < &proc[NPROC]; p++){
    80001fcc:	fb69fee3          	bgeu	s3,s6,80001f88 <scheduler+0x70>
    80001fd0:	19848493          	addi	s1,s1,408
    80001fd4:	19890913          	addi	s2,s2,408
    80001fd8:	8aa6                	mv	s5,s1
      acquire(&p->lock);
    80001fda:	8526                	mv	a0,s1
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	bfa080e7          	jalr	-1030(ra) # 80000bd6 <acquire>
      if(p->state == RUNNABLE){
    80001fe4:	89ca                	mv	s3,s2
    80001fe6:	e8092783          	lw	a5,-384(s2)
    80001fea:	f97796e3          	bne	a5,s7,80001f76 <scheduler+0x5e>
        if(min_acc_proc == 0) {min_acc_proc = p;}
    80001fee:	f80a02e3          	beqz	s4,80001f72 <scheduler+0x5a>
        if(min_acc_proc->accumulator > p->accumulator){
    80001ff2:	058a3703          	ld	a4,88(s4)
    80001ff6:	ec09b783          	ld	a5,-320(s3)
    80001ffa:	fce7d9e3          	bge	a5,a4,80001fcc <scheduler+0xb4>
          release(&min_acc_proc->lock);
    80001ffe:	8552                	mv	a0,s4
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	c8a080e7          	jalr	-886(ra) # 80000c8a <release>
    80002008:	8a56                	mv	s4,s5
    8000200a:	b7c9                	j	80001fcc <scheduler+0xb4>

000000008000200c <sched>:
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	e44e                	sd	s3,8(sp)
    80002018:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	992080e7          	jalr	-1646(ra) # 800019ac <myproc>
    80002022:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	b38080e7          	jalr	-1224(ra) # 80000b5c <holding>
    8000202c:	c93d                	beqz	a0,800020a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	0000f717          	auipc	a4,0xf
    80002038:	b3c70713          	addi	a4,a4,-1220 # 80010b70 <pid_lock>
    8000203c:	97ba                	add	a5,a5,a4
    8000203e:	0a87a703          	lw	a4,168(a5)
    80002042:	4785                	li	a5,1
    80002044:	06f71763          	bne	a4,a5,800020b2 <sched+0xa6>
  if(p->state == RUNNING)
    80002048:	4c98                	lw	a4,24(s1)
    8000204a:	4791                	li	a5,4
    8000204c:	06f70b63          	beq	a4,a5,800020c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002050:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002054:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002056:	efb5                	bnez	a5,800020d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002058:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000205a:	0000f917          	auipc	s2,0xf
    8000205e:	b1690913          	addi	s2,s2,-1258 # 80010b70 <pid_lock>
    80002062:	2781                	sext.w	a5,a5
    80002064:	079e                	slli	a5,a5,0x7
    80002066:	97ca                	add	a5,a5,s2
    80002068:	0ac7a983          	lw	s3,172(a5)
    8000206c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000206e:	2781                	sext.w	a5,a5
    80002070:	079e                	slli	a5,a5,0x7
    80002072:	0000f597          	auipc	a1,0xf
    80002076:	b3658593          	addi	a1,a1,-1226 # 80010ba8 <cpus+0x8>
    8000207a:	95be                	add	a1,a1,a5
    8000207c:	08848513          	addi	a0,s1,136
    80002080:	00000097          	auipc	ra,0x0
    80002084:	6e6080e7          	jalr	1766(ra) # 80002766 <swtch>
    80002088:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000208a:	2781                	sext.w	a5,a5
    8000208c:	079e                	slli	a5,a5,0x7
    8000208e:	97ca                	add	a5,a5,s2
    80002090:	0b37a623          	sw	s3,172(a5)
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret
    panic("sched p->lock");
    800020a2:	00006517          	auipc	a0,0x6
    800020a6:	17650513          	addi	a0,a0,374 # 80008218 <digits+0x1d8>
    800020aa:	ffffe097          	auipc	ra,0xffffe
    800020ae:	494080e7          	jalr	1172(ra) # 8000053e <panic>
    panic("sched locks");
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	17650513          	addi	a0,a0,374 # 80008228 <digits+0x1e8>
    800020ba:	ffffe097          	auipc	ra,0xffffe
    800020be:	484080e7          	jalr	1156(ra) # 8000053e <panic>
    panic("sched running");
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	17650513          	addi	a0,a0,374 # 80008238 <digits+0x1f8>
    800020ca:	ffffe097          	auipc	ra,0xffffe
    800020ce:	474080e7          	jalr	1140(ra) # 8000053e <panic>
    panic("sched interruptible");
    800020d2:	00006517          	auipc	a0,0x6
    800020d6:	17650513          	addi	a0,a0,374 # 80008248 <digits+0x208>
    800020da:	ffffe097          	auipc	ra,0xffffe
    800020de:	464080e7          	jalr	1124(ra) # 8000053e <panic>

00000000800020e2 <yield>:
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	8c0080e7          	jalr	-1856(ra) # 800019ac <myproc>
    800020f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	ae0080e7          	jalr	-1312(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    800020fe:	478d                	li	a5,3
    80002100:	cc9c                	sw	a5,24(s1)
  sched();
    80002102:	00000097          	auipc	ra,0x0
    80002106:	f0a080e7          	jalr	-246(ra) # 8000200c <sched>
  release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	b7e080e7          	jalr	-1154(ra) # 80000c8a <release>
}
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000211e:	7179                	addi	sp,sp,-48
    80002120:	f406                	sd	ra,40(sp)
    80002122:	f022                	sd	s0,32(sp)
    80002124:	ec26                	sd	s1,24(sp)
    80002126:	e84a                	sd	s2,16(sp)
    80002128:	e44e                	sd	s3,8(sp)
    8000212a:	1800                	addi	s0,sp,48
    8000212c:	89aa                	mv	s3,a0
    8000212e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002130:	00000097          	auipc	ra,0x0
    80002134:	87c080e7          	jalr	-1924(ra) # 800019ac <myproc>
    80002138:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	a9c080e7          	jalr	-1380(ra) # 80000bd6 <acquire>
  release(lk);
    80002142:	854a                	mv	a0,s2
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	b46080e7          	jalr	-1210(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    8000214c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002150:	4789                	li	a5,2
    80002152:	cc9c                	sw	a5,24(s1)

  sched();
    80002154:	00000097          	auipc	ra,0x0
    80002158:	eb8080e7          	jalr	-328(ra) # 8000200c <sched>

  // Tidy up.
  p->chan = 0;
    8000215c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	b28080e7          	jalr	-1240(ra) # 80000c8a <release>
  acquire(lk);
    8000216a:	854a                	mv	a0,s2
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	a6a080e7          	jalr	-1430(ra) # 80000bd6 <acquire>
}
    80002174:	70a2                	ld	ra,40(sp)
    80002176:	7402                	ld	s0,32(sp)
    80002178:	64e2                	ld	s1,24(sp)
    8000217a:	6942                	ld	s2,16(sp)
    8000217c:	69a2                	ld	s3,8(sp)
    8000217e:	6145                	addi	sp,sp,48
    80002180:	8082                	ret

0000000080002182 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002182:	711d                	addi	sp,sp,-96
    80002184:	ec86                	sd	ra,88(sp)
    80002186:	e8a2                	sd	s0,80(sp)
    80002188:	e4a6                	sd	s1,72(sp)
    8000218a:	e0ca                	sd	s2,64(sp)
    8000218c:	fc4e                	sd	s3,56(sp)
    8000218e:	f852                	sd	s4,48(sp)
    80002190:	f456                	sd	s5,40(sp)
    80002192:	f05a                	sd	s6,32(sp)
    80002194:	ec5e                	sd	s7,24(sp)
    80002196:	e862                	sd	s8,16(sp)
    80002198:	e466                	sd	s9,8(sp)
    8000219a:	e06a                	sd	s10,0(sp)
    8000219c:	1080                	addi	s0,sp,96
    8000219e:	8baa                	mv	s7,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021a0:	0000f917          	auipc	s2,0xf
    800021a4:	e0090913          	addi	s2,s2,-512 # 80010fa0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800021a8:	4b09                	li	s6,2


            struct proc *other_p;
            long long min=LLONG_MAX;
    800021aa:	5c7d                	li	s8,-1
    800021ac:	001c5c13          	srli	s8,s8,0x1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
                if(other_p != p){
                  acquire(&other_p->lock);
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    800021b0:	4a05                	li	s4,1
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800021b2:	00015997          	auipc	s3,0x15
    800021b6:	3ee98993          	addi	s3,s3,1006 # 800175a0 <tickslock>
          
      



        p->state = RUNNABLE;
    800021ba:	4c8d                	li	s9,3
            p->accumulator=0;
    800021bc:	4d01                	li	s10,0
    800021be:	a889                	j	80002210 <wakeup+0x8e>
                release(&other_p->lock);
    800021c0:	8526                	mv	a0,s1
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	ac8080e7          	jalr	-1336(ra) # 80000c8a <release>
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    800021ca:	19848493          	addi	s1,s1,408
    800021ce:	03348263          	beq	s1,s3,800021f2 <wakeup+0x70>
                if(other_p != p){
    800021d2:	fe990ce3          	beq	s2,s1,800021ca <wakeup+0x48>
                  acquire(&other_p->lock);
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	9fe080e7          	jalr	-1538(ra) # 80000bd6 <acquire>
                    if((other_p->state == RUNNABLE) || (other_p->state ==RUNNING)) {
    800021e0:	4c9c                	lw	a5,24(s1)
    800021e2:	37f5                	addiw	a5,a5,-3
    800021e4:	fcfa6ee3          	bltu	s4,a5,800021c0 <wakeup+0x3e>
                      if(min>other_p->accumulator)
    800021e8:	6cbc                	ld	a5,88(s1)
    800021ea:	fd57dbe3          	bge	a5,s5,800021c0 <wakeup+0x3e>
    800021ee:	8abe                	mv	s5,a5
    800021f0:	bfc1                	j	800021c0 <wakeup+0x3e>
          if(min==LLONG_MAX){
    800021f2:	058a8863          	beq	s5,s8,80002242 <wakeup+0xc0>
    800021f6:	05593c23          	sd	s5,88(s2)
        p->state = RUNNABLE;
    800021fa:	01992c23          	sw	s9,24(s2)
      }
      release(&p->lock);
    800021fe:	854a                	mv	a0,s2
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	a8a080e7          	jalr	-1398(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002208:	19890913          	addi	s2,s2,408
    8000220c:	03390d63          	beq	s2,s3,80002246 <wakeup+0xc4>
    if(p != myproc()){
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	79c080e7          	jalr	1948(ra) # 800019ac <myproc>
    80002218:	fea908e3          	beq	s2,a0,80002208 <wakeup+0x86>
      acquire(&p->lock);
    8000221c:	854a                	mv	a0,s2
    8000221e:	fffff097          	auipc	ra,0xfffff
    80002222:	9b8080e7          	jalr	-1608(ra) # 80000bd6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002226:	01892783          	lw	a5,24(s2)
    8000222a:	fd679ae3          	bne	a5,s6,800021fe <wakeup+0x7c>
    8000222e:	02093783          	ld	a5,32(s2)
    80002232:	fd7796e3          	bne	a5,s7,800021fe <wakeup+0x7c>
            long long min=LLONG_MAX;
    80002236:	8ae2                	mv	s5,s8
            for(other_p = proc; other_p < &proc[NPROC]; other_p++) {
    80002238:	0000f497          	auipc	s1,0xf
    8000223c:	d6848493          	addi	s1,s1,-664 # 80010fa0 <proc>
    80002240:	bf49                	j	800021d2 <wakeup+0x50>
            p->accumulator=0;
    80002242:	8aea                	mv	s5,s10
    80002244:	bf4d                	j	800021f6 <wakeup+0x74>
    }
  }
}
    80002246:	60e6                	ld	ra,88(sp)
    80002248:	6446                	ld	s0,80(sp)
    8000224a:	64a6                	ld	s1,72(sp)
    8000224c:	6906                	ld	s2,64(sp)
    8000224e:	79e2                	ld	s3,56(sp)
    80002250:	7a42                	ld	s4,48(sp)
    80002252:	7aa2                	ld	s5,40(sp)
    80002254:	7b02                	ld	s6,32(sp)
    80002256:	6be2                	ld	s7,24(sp)
    80002258:	6c42                	ld	s8,16(sp)
    8000225a:	6ca2                	ld	s9,8(sp)
    8000225c:	6d02                	ld	s10,0(sp)
    8000225e:	6125                	addi	sp,sp,96
    80002260:	8082                	ret

0000000080002262 <reparent>:
{
    80002262:	7179                	addi	sp,sp,-48
    80002264:	f406                	sd	ra,40(sp)
    80002266:	f022                	sd	s0,32(sp)
    80002268:	ec26                	sd	s1,24(sp)
    8000226a:	e84a                	sd	s2,16(sp)
    8000226c:	e44e                	sd	s3,8(sp)
    8000226e:	e052                	sd	s4,0(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002274:	0000f497          	auipc	s1,0xf
    80002278:	d2c48493          	addi	s1,s1,-724 # 80010fa0 <proc>
      pp->parent = initproc;
    8000227c:	00006a17          	auipc	s4,0x6
    80002280:	67ca0a13          	addi	s4,s4,1660 # 800088f8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002284:	00015997          	auipc	s3,0x15
    80002288:	31c98993          	addi	s3,s3,796 # 800175a0 <tickslock>
    8000228c:	a029                	j	80002296 <reparent+0x34>
    8000228e:	19848493          	addi	s1,s1,408
    80002292:	01348d63          	beq	s1,s3,800022ac <reparent+0x4a>
    if(pp->parent == p){
    80002296:	70bc                	ld	a5,96(s1)
    80002298:	ff279be3          	bne	a5,s2,8000228e <reparent+0x2c>
      pp->parent = initproc;
    8000229c:	000a3503          	ld	a0,0(s4)
    800022a0:	f0a8                	sd	a0,96(s1)
      wakeup(initproc);
    800022a2:	00000097          	auipc	ra,0x0
    800022a6:	ee0080e7          	jalr	-288(ra) # 80002182 <wakeup>
    800022aa:	b7d5                	j	8000228e <reparent+0x2c>
}
    800022ac:	70a2                	ld	ra,40(sp)
    800022ae:	7402                	ld	s0,32(sp)
    800022b0:	64e2                	ld	s1,24(sp)
    800022b2:	6942                	ld	s2,16(sp)
    800022b4:	69a2                	ld	s3,8(sp)
    800022b6:	6a02                	ld	s4,0(sp)
    800022b8:	6145                	addi	sp,sp,48
    800022ba:	8082                	ret

00000000800022bc <exit>:
{
    800022bc:	7139                	addi	sp,sp,-64
    800022be:	fc06                	sd	ra,56(sp)
    800022c0:	f822                	sd	s0,48(sp)
    800022c2:	f426                	sd	s1,40(sp)
    800022c4:	f04a                	sd	s2,32(sp)
    800022c6:	ec4e                	sd	s3,24(sp)
    800022c8:	e852                	sd	s4,16(sp)
    800022ca:	e456                	sd	s5,8(sp)
    800022cc:	0080                	addi	s0,sp,64
    800022ce:	8aaa                	mv	s5,a0
    800022d0:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	6da080e7          	jalr	1754(ra) # 800019ac <myproc>
    800022da:	89aa                	mv	s3,a0
  if(p == initproc)
    800022dc:	00006797          	auipc	a5,0x6
    800022e0:	61c7b783          	ld	a5,1564(a5) # 800088f8 <initproc>
    800022e4:	0f850493          	addi	s1,a0,248
    800022e8:	17850913          	addi	s2,a0,376
    800022ec:	02a79363          	bne	a5,a0,80002312 <exit+0x56>
    panic("init exiting");
    800022f0:	00006517          	auipc	a0,0x6
    800022f4:	f7050513          	addi	a0,a0,-144 # 80008260 <digits+0x220>
    800022f8:	ffffe097          	auipc	ra,0xffffe
    800022fc:	246080e7          	jalr	582(ra) # 8000053e <panic>
      fileclose(f);
    80002300:	00002097          	auipc	ra,0x2
    80002304:	3e6080e7          	jalr	998(ra) # 800046e6 <fileclose>
      p->ofile[fd] = 0;
    80002308:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000230c:	04a1                	addi	s1,s1,8
    8000230e:	01248563          	beq	s1,s2,80002318 <exit+0x5c>
    if(p->ofile[fd]){
    80002312:	6088                	ld	a0,0(s1)
    80002314:	f575                	bnez	a0,80002300 <exit+0x44>
    80002316:	bfdd                	j	8000230c <exit+0x50>
  begin_op();
    80002318:	00002097          	auipc	ra,0x2
    8000231c:	f02080e7          	jalr	-254(ra) # 8000421a <begin_op>
  iput(p->cwd);
    80002320:	1789b503          	ld	a0,376(s3)
    80002324:	00001097          	auipc	ra,0x1
    80002328:	6ee080e7          	jalr	1774(ra) # 80003a12 <iput>
  end_op();
    8000232c:	00002097          	auipc	ra,0x2
    80002330:	f6e080e7          	jalr	-146(ra) # 8000429a <end_op>
  p->cwd = 0;
    80002334:	1609bc23          	sd	zero,376(s3)
  acquire(&wait_lock);
    80002338:	0000f497          	auipc	s1,0xf
    8000233c:	85048493          	addi	s1,s1,-1968 # 80010b88 <wait_lock>
    80002340:	8526                	mv	a0,s1
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	894080e7          	jalr	-1900(ra) # 80000bd6 <acquire>
  reparent(p);
    8000234a:	854e                	mv	a0,s3
    8000234c:	00000097          	auipc	ra,0x0
    80002350:	f16080e7          	jalr	-234(ra) # 80002262 <reparent>
  wakeup(p->parent);
    80002354:	0609b503          	ld	a0,96(s3)
    80002358:	00000097          	auipc	ra,0x0
    8000235c:	e2a080e7          	jalr	-470(ra) # 80002182 <wakeup>
  acquire(&p->lock);
    80002360:	854e                	mv	a0,s3
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	874080e7          	jalr	-1932(ra) # 80000bd6 <acquire>
  p->xstate = status;
    8000236a:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, sizeof(p->exit_msg));
    8000236e:	02000613          	li	a2,32
    80002372:	85d2                	mv	a1,s4
    80002374:	03498513          	addi	a0,s3,52
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	aa4080e7          	jalr	-1372(ra) # 80000e1c <safestrcpy>
  p->state = ZOMBIE;
    80002380:	4795                	li	a5,5
    80002382:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002386:	8526                	mv	a0,s1
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	902080e7          	jalr	-1790(ra) # 80000c8a <release>
  sched();
    80002390:	00000097          	auipc	ra,0x0
    80002394:	c7c080e7          	jalr	-900(ra) # 8000200c <sched>
  panic("zombie exit");
    80002398:	00006517          	auipc	a0,0x6
    8000239c:	ed850513          	addi	a0,a0,-296 # 80008270 <digits+0x230>
    800023a0:	ffffe097          	auipc	ra,0xffffe
    800023a4:	19e080e7          	jalr	414(ra) # 8000053e <panic>

00000000800023a8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023a8:	7179                	addi	sp,sp,-48
    800023aa:	f406                	sd	ra,40(sp)
    800023ac:	f022                	sd	s0,32(sp)
    800023ae:	ec26                	sd	s1,24(sp)
    800023b0:	e84a                	sd	s2,16(sp)
    800023b2:	e44e                	sd	s3,8(sp)
    800023b4:	1800                	addi	s0,sp,48
    800023b6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023b8:	0000f497          	auipc	s1,0xf
    800023bc:	be848493          	addi	s1,s1,-1048 # 80010fa0 <proc>
    800023c0:	00015997          	auipc	s3,0x15
    800023c4:	1e098993          	addi	s3,s3,480 # 800175a0 <tickslock>
    acquire(&p->lock);
    800023c8:	8526                	mv	a0,s1
    800023ca:	fffff097          	auipc	ra,0xfffff
    800023ce:	80c080e7          	jalr	-2036(ra) # 80000bd6 <acquire>
    if(p->pid == pid){
    800023d2:	589c                	lw	a5,48(s1)
    800023d4:	01278d63          	beq	a5,s2,800023ee <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023d8:	8526                	mv	a0,s1
    800023da:	fffff097          	auipc	ra,0xfffff
    800023de:	8b0080e7          	jalr	-1872(ra) # 80000c8a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023e2:	19848493          	addi	s1,s1,408
    800023e6:	ff3491e3          	bne	s1,s3,800023c8 <kill+0x20>
  }
  return -1;
    800023ea:	557d                	li	a0,-1
    800023ec:	a829                	j	80002406 <kill+0x5e>
      p->killed = 1;
    800023ee:	4785                	li	a5,1
    800023f0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023f2:	4c98                	lw	a4,24(s1)
    800023f4:	4789                	li	a5,2
    800023f6:	00f70f63          	beq	a4,a5,80002414 <kill+0x6c>
      release(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	88e080e7          	jalr	-1906(ra) # 80000c8a <release>
      return 0;
    80002404:	4501                	li	a0,0
}
    80002406:	70a2                	ld	ra,40(sp)
    80002408:	7402                	ld	s0,32(sp)
    8000240a:	64e2                	ld	s1,24(sp)
    8000240c:	6942                	ld	s2,16(sp)
    8000240e:	69a2                	ld	s3,8(sp)
    80002410:	6145                	addi	sp,sp,48
    80002412:	8082                	ret
        p->state = RUNNABLE;
    80002414:	478d                	li	a5,3
    80002416:	cc9c                	sw	a5,24(s1)
    80002418:	b7cd                	j	800023fa <kill+0x52>

000000008000241a <setkilled>:

void
setkilled(struct proc *p)
{
    8000241a:	1101                	addi	sp,sp,-32
    8000241c:	ec06                	sd	ra,24(sp)
    8000241e:	e822                	sd	s0,16(sp)
    80002420:	e426                	sd	s1,8(sp)
    80002422:	1000                	addi	s0,sp,32
    80002424:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002426:	ffffe097          	auipc	ra,0xffffe
    8000242a:	7b0080e7          	jalr	1968(ra) # 80000bd6 <acquire>
  p->killed = 1;
    8000242e:	4785                	li	a5,1
    80002430:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002432:	8526                	mv	a0,s1
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	856080e7          	jalr	-1962(ra) # 80000c8a <release>
}
    8000243c:	60e2                	ld	ra,24(sp)
    8000243e:	6442                	ld	s0,16(sp)
    80002440:	64a2                	ld	s1,8(sp)
    80002442:	6105                	addi	sp,sp,32
    80002444:	8082                	ret

0000000080002446 <killed>:

int
killed(struct proc *p)
{
    80002446:	1101                	addi	sp,sp,-32
    80002448:	ec06                	sd	ra,24(sp)
    8000244a:	e822                	sd	s0,16(sp)
    8000244c:	e426                	sd	s1,8(sp)
    8000244e:	e04a                	sd	s2,0(sp)
    80002450:	1000                	addi	s0,sp,32
    80002452:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	782080e7          	jalr	1922(ra) # 80000bd6 <acquire>
  k = p->killed;
    8000245c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002460:	8526                	mv	a0,s1
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	828080e7          	jalr	-2008(ra) # 80000c8a <release>
  return k;
}
    8000246a:	854a                	mv	a0,s2
    8000246c:	60e2                	ld	ra,24(sp)
    8000246e:	6442                	ld	s0,16(sp)
    80002470:	64a2                	ld	s1,8(sp)
    80002472:	6902                	ld	s2,0(sp)
    80002474:	6105                	addi	sp,sp,32
    80002476:	8082                	ret

0000000080002478 <wait>:
{
    80002478:	711d                	addi	sp,sp,-96
    8000247a:	ec86                	sd	ra,88(sp)
    8000247c:	e8a2                	sd	s0,80(sp)
    8000247e:	e4a6                	sd	s1,72(sp)
    80002480:	e0ca                	sd	s2,64(sp)
    80002482:	fc4e                	sd	s3,56(sp)
    80002484:	f852                	sd	s4,48(sp)
    80002486:	f456                	sd	s5,40(sp)
    80002488:	f05a                	sd	s6,32(sp)
    8000248a:	ec5e                	sd	s7,24(sp)
    8000248c:	e862                	sd	s8,16(sp)
    8000248e:	e466                	sd	s9,8(sp)
    80002490:	1080                	addi	s0,sp,96
    80002492:	8baa                	mv	s7,a0
    80002494:	8b2e                	mv	s6,a1
  struct proc *p = myproc();
    80002496:	fffff097          	auipc	ra,0xfffff
    8000249a:	516080e7          	jalr	1302(ra) # 800019ac <myproc>
    8000249e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800024a0:	0000e517          	auipc	a0,0xe
    800024a4:	6e850513          	addi	a0,a0,1768 # 80010b88 <wait_lock>
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	72e080e7          	jalr	1838(ra) # 80000bd6 <acquire>
    havekids = 0;
    800024b0:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800024b2:	4a15                	li	s4,5
        havekids = 1;
    800024b4:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024b6:	00015997          	auipc	s3,0x15
    800024ba:	0ea98993          	addi	s3,s3,234 # 800175a0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024be:	0000ec97          	auipc	s9,0xe
    800024c2:	6cac8c93          	addi	s9,s9,1738 # 80010b88 <wait_lock>
    havekids = 0;
    800024c6:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024c8:	0000f497          	auipc	s1,0xf
    800024cc:	ad848493          	addi	s1,s1,-1320 # 80010fa0 <proc>
    800024d0:	a06d                	j	8000257a <wait+0x102>
          pid = pp->pid;
    800024d2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800024d6:	040b9463          	bnez	s7,8000251e <wait+0xa6>
          if(addr_exitmsg != 0 && copyout(p->pagetable, addr_exitmsg, (char *)&pp->exit_msg,
    800024da:	000b0f63          	beqz	s6,800024f8 <wait+0x80>
    800024de:	02000693          	li	a3,32
    800024e2:	03448613          	addi	a2,s1,52
    800024e6:	85da                	mv	a1,s6
    800024e8:	07893503          	ld	a0,120(s2)
    800024ec:	fffff097          	auipc	ra,0xfffff
    800024f0:	17c080e7          	jalr	380(ra) # 80001668 <copyout>
    800024f4:	06054063          	bltz	a0,80002554 <wait+0xdc>
          freeproc(pp);
    800024f8:	8526                	mv	a0,s1
    800024fa:	fffff097          	auipc	ra,0xfffff
    800024fe:	664080e7          	jalr	1636(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	786080e7          	jalr	1926(ra) # 80000c8a <release>
          release(&wait_lock);
    8000250c:	0000e517          	auipc	a0,0xe
    80002510:	67c50513          	addi	a0,a0,1660 # 80010b88 <wait_lock>
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	776080e7          	jalr	1910(ra) # 80000c8a <release>
          return pid;
    8000251c:	a04d                	j	800025be <wait+0x146>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000251e:	4691                	li	a3,4
    80002520:	02c48613          	addi	a2,s1,44
    80002524:	85de                	mv	a1,s7
    80002526:	07893503          	ld	a0,120(s2)
    8000252a:	fffff097          	auipc	ra,0xfffff
    8000252e:	13e080e7          	jalr	318(ra) # 80001668 <copyout>
    80002532:	fa0554e3          	bgez	a0,800024da <wait+0x62>
            release(&pp->lock);
    80002536:	8526                	mv	a0,s1
    80002538:	ffffe097          	auipc	ra,0xffffe
    8000253c:	752080e7          	jalr	1874(ra) # 80000c8a <release>
            release(&wait_lock);
    80002540:	0000e517          	auipc	a0,0xe
    80002544:	64850513          	addi	a0,a0,1608 # 80010b88 <wait_lock>
    80002548:	ffffe097          	auipc	ra,0xffffe
    8000254c:	742080e7          	jalr	1858(ra) # 80000c8a <release>
            return -1;
    80002550:	59fd                	li	s3,-1
    80002552:	a0b5                	j	800025be <wait+0x146>
            release(&pp->lock);
    80002554:	8526                	mv	a0,s1
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	734080e7          	jalr	1844(ra) # 80000c8a <release>
            release(&wait_lock);
    8000255e:	0000e517          	auipc	a0,0xe
    80002562:	62a50513          	addi	a0,a0,1578 # 80010b88 <wait_lock>
    80002566:	ffffe097          	auipc	ra,0xffffe
    8000256a:	724080e7          	jalr	1828(ra) # 80000c8a <release>
            return -1;
    8000256e:	59fd                	li	s3,-1
    80002570:	a0b9                	j	800025be <wait+0x146>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002572:	19848493          	addi	s1,s1,408
    80002576:	03348463          	beq	s1,s3,8000259e <wait+0x126>
      if(pp->parent == p){
    8000257a:	70bc                	ld	a5,96(s1)
    8000257c:	ff279be3          	bne	a5,s2,80002572 <wait+0xfa>
        acquire(&pp->lock);
    80002580:	8526                	mv	a0,s1
    80002582:	ffffe097          	auipc	ra,0xffffe
    80002586:	654080e7          	jalr	1620(ra) # 80000bd6 <acquire>
        if(pp->state == ZOMBIE){
    8000258a:	4c9c                	lw	a5,24(s1)
    8000258c:	f54783e3          	beq	a5,s4,800024d2 <wait+0x5a>
        release(&pp->lock);
    80002590:	8526                	mv	a0,s1
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	6f8080e7          	jalr	1784(ra) # 80000c8a <release>
        havekids = 1;
    8000259a:	8756                	mv	a4,s5
    8000259c:	bfd9                	j	80002572 <wait+0xfa>
    if(!havekids || killed(p)){
    8000259e:	c719                	beqz	a4,800025ac <wait+0x134>
    800025a0:	854a                	mv	a0,s2
    800025a2:	00000097          	auipc	ra,0x0
    800025a6:	ea4080e7          	jalr	-348(ra) # 80002446 <killed>
    800025aa:	c905                	beqz	a0,800025da <wait+0x162>
      release(&wait_lock);
    800025ac:	0000e517          	auipc	a0,0xe
    800025b0:	5dc50513          	addi	a0,a0,1500 # 80010b88 <wait_lock>
    800025b4:	ffffe097          	auipc	ra,0xffffe
    800025b8:	6d6080e7          	jalr	1750(ra) # 80000c8a <release>
      return -1;
    800025bc:	59fd                	li	s3,-1
}
    800025be:	854e                	mv	a0,s3
    800025c0:	60e6                	ld	ra,88(sp)
    800025c2:	6446                	ld	s0,80(sp)
    800025c4:	64a6                	ld	s1,72(sp)
    800025c6:	6906                	ld	s2,64(sp)
    800025c8:	79e2                	ld	s3,56(sp)
    800025ca:	7a42                	ld	s4,48(sp)
    800025cc:	7aa2                	ld	s5,40(sp)
    800025ce:	7b02                	ld	s6,32(sp)
    800025d0:	6be2                	ld	s7,24(sp)
    800025d2:	6c42                	ld	s8,16(sp)
    800025d4:	6ca2                	ld	s9,8(sp)
    800025d6:	6125                	addi	sp,sp,96
    800025d8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800025da:	85e6                	mv	a1,s9
    800025dc:	854a                	mv	a0,s2
    800025de:	00000097          	auipc	ra,0x0
    800025e2:	b40080e7          	jalr	-1216(ra) # 8000211e <sleep>
    havekids = 0;
    800025e6:	b5c5                	j	800024c6 <wait+0x4e>

00000000800025e8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800025e8:	7179                	addi	sp,sp,-48
    800025ea:	f406                	sd	ra,40(sp)
    800025ec:	f022                	sd	s0,32(sp)
    800025ee:	ec26                	sd	s1,24(sp)
    800025f0:	e84a                	sd	s2,16(sp)
    800025f2:	e44e                	sd	s3,8(sp)
    800025f4:	e052                	sd	s4,0(sp)
    800025f6:	1800                	addi	s0,sp,48
    800025f8:	84aa                	mv	s1,a0
    800025fa:	892e                	mv	s2,a1
    800025fc:	89b2                	mv	s3,a2
    800025fe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002600:	fffff097          	auipc	ra,0xfffff
    80002604:	3ac080e7          	jalr	940(ra) # 800019ac <myproc>
  if(user_dst){
    80002608:	c08d                	beqz	s1,8000262a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000260a:	86d2                	mv	a3,s4
    8000260c:	864e                	mv	a2,s3
    8000260e:	85ca                	mv	a1,s2
    80002610:	7d28                	ld	a0,120(a0)
    80002612:	fffff097          	auipc	ra,0xfffff
    80002616:	056080e7          	jalr	86(ra) # 80001668 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000261a:	70a2                	ld	ra,40(sp)
    8000261c:	7402                	ld	s0,32(sp)
    8000261e:	64e2                	ld	s1,24(sp)
    80002620:	6942                	ld	s2,16(sp)
    80002622:	69a2                	ld	s3,8(sp)
    80002624:	6a02                	ld	s4,0(sp)
    80002626:	6145                	addi	sp,sp,48
    80002628:	8082                	ret
    memmove((char *)dst, src, len);
    8000262a:	000a061b          	sext.w	a2,s4
    8000262e:	85ce                	mv	a1,s3
    80002630:	854a                	mv	a0,s2
    80002632:	ffffe097          	auipc	ra,0xffffe
    80002636:	6fc080e7          	jalr	1788(ra) # 80000d2e <memmove>
    return 0;
    8000263a:	8526                	mv	a0,s1
    8000263c:	bff9                	j	8000261a <either_copyout+0x32>

000000008000263e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000263e:	7179                	addi	sp,sp,-48
    80002640:	f406                	sd	ra,40(sp)
    80002642:	f022                	sd	s0,32(sp)
    80002644:	ec26                	sd	s1,24(sp)
    80002646:	e84a                	sd	s2,16(sp)
    80002648:	e44e                	sd	s3,8(sp)
    8000264a:	e052                	sd	s4,0(sp)
    8000264c:	1800                	addi	s0,sp,48
    8000264e:	892a                	mv	s2,a0
    80002650:	84ae                	mv	s1,a1
    80002652:	89b2                	mv	s3,a2
    80002654:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002656:	fffff097          	auipc	ra,0xfffff
    8000265a:	356080e7          	jalr	854(ra) # 800019ac <myproc>
  if(user_src){
    8000265e:	c08d                	beqz	s1,80002680 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002660:	86d2                	mv	a3,s4
    80002662:	864e                	mv	a2,s3
    80002664:	85ca                	mv	a1,s2
    80002666:	7d28                	ld	a0,120(a0)
    80002668:	fffff097          	auipc	ra,0xfffff
    8000266c:	08c080e7          	jalr	140(ra) # 800016f4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002670:	70a2                	ld	ra,40(sp)
    80002672:	7402                	ld	s0,32(sp)
    80002674:	64e2                	ld	s1,24(sp)
    80002676:	6942                	ld	s2,16(sp)
    80002678:	69a2                	ld	s3,8(sp)
    8000267a:	6a02                	ld	s4,0(sp)
    8000267c:	6145                	addi	sp,sp,48
    8000267e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002680:	000a061b          	sext.w	a2,s4
    80002684:	85ce                	mv	a1,s3
    80002686:	854a                	mv	a0,s2
    80002688:	ffffe097          	auipc	ra,0xffffe
    8000268c:	6a6080e7          	jalr	1702(ra) # 80000d2e <memmove>
    return 0;
    80002690:	8526                	mv	a0,s1
    80002692:	bff9                	j	80002670 <either_copyin+0x32>

0000000080002694 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002694:	715d                	addi	sp,sp,-80
    80002696:	e486                	sd	ra,72(sp)
    80002698:	e0a2                	sd	s0,64(sp)
    8000269a:	fc26                	sd	s1,56(sp)
    8000269c:	f84a                	sd	s2,48(sp)
    8000269e:	f44e                	sd	s3,40(sp)
    800026a0:	f052                	sd	s4,32(sp)
    800026a2:	ec56                	sd	s5,24(sp)
    800026a4:	e85a                	sd	s6,16(sp)
    800026a6:	e45e                	sd	s7,8(sp)
    800026a8:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800026aa:	00006517          	auipc	a0,0x6
    800026ae:	a1e50513          	addi	a0,a0,-1506 # 800080c8 <digits+0x88>
    800026b2:	ffffe097          	auipc	ra,0xffffe
    800026b6:	ed6080e7          	jalr	-298(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800026ba:	0000f497          	auipc	s1,0xf
    800026be:	a6648493          	addi	s1,s1,-1434 # 80011120 <proc+0x180>
    800026c2:	00015917          	auipc	s2,0x15
    800026c6:	05e90913          	addi	s2,s2,94 # 80017720 <bcache+0x168>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026ca:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800026cc:	00006997          	auipc	s3,0x6
    800026d0:	bb498993          	addi	s3,s3,-1100 # 80008280 <digits+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800026d4:	00006a97          	auipc	s5,0x6
    800026d8:	bb4a8a93          	addi	s5,s5,-1100 # 80008288 <digits+0x248>
    printf("\n");
    800026dc:	00006a17          	auipc	s4,0x6
    800026e0:	9eca0a13          	addi	s4,s4,-1556 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800026e4:	00006b97          	auipc	s7,0x6
    800026e8:	be4b8b93          	addi	s7,s7,-1052 # 800082c8 <states.0>
    800026ec:	a00d                	j	8000270e <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800026ee:	eb06a583          	lw	a1,-336(a3)
    800026f2:	8556                	mv	a0,s5
    800026f4:	ffffe097          	auipc	ra,0xffffe
    800026f8:	e94080e7          	jalr	-364(ra) # 80000588 <printf>
    printf("\n");
    800026fc:	8552                	mv	a0,s4
    800026fe:	ffffe097          	auipc	ra,0xffffe
    80002702:	e8a080e7          	jalr	-374(ra) # 80000588 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002706:	19848493          	addi	s1,s1,408
    8000270a:	03248163          	beq	s1,s2,8000272c <procdump+0x98>
    if(p->state == UNUSED)
    8000270e:	86a6                	mv	a3,s1
    80002710:	e984a783          	lw	a5,-360(s1)
    80002714:	dbed                	beqz	a5,80002706 <procdump+0x72>
      state = "???";
    80002716:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002718:	fcfb6be3          	bltu	s6,a5,800026ee <procdump+0x5a>
    8000271c:	1782                	slli	a5,a5,0x20
    8000271e:	9381                	srli	a5,a5,0x20
    80002720:	078e                	slli	a5,a5,0x3
    80002722:	97de                	add	a5,a5,s7
    80002724:	6390                	ld	a2,0(a5)
    80002726:	f661                	bnez	a2,800026ee <procdump+0x5a>
      state = "???";
    80002728:	864e                	mv	a2,s3
    8000272a:	b7d1                	j	800026ee <procdump+0x5a>
  }
}
    8000272c:	60a6                	ld	ra,72(sp)
    8000272e:	6406                	ld	s0,64(sp)
    80002730:	74e2                	ld	s1,56(sp)
    80002732:	7942                	ld	s2,48(sp)
    80002734:	79a2                	ld	s3,40(sp)
    80002736:	7a02                	ld	s4,32(sp)
    80002738:	6ae2                	ld	s5,24(sp)
    8000273a:	6b42                	ld	s6,16(sp)
    8000273c:	6ba2                	ld	s7,8(sp)
    8000273e:	6161                	addi	sp,sp,80
    80002740:	8082                	ret

0000000080002742 <set_ps_priority>:


int
set_ps_priority(int new_ps)
{
    80002742:	1101                	addi	sp,sp,-32
    80002744:	ec06                	sd	ra,24(sp)
    80002746:	e822                	sd	s0,16(sp)
    80002748:	e426                	sd	s1,8(sp)
    8000274a:	1000                	addi	s0,sp,32
    8000274c:	84aa                	mv	s1,a0
  struct proc *p = myproc(); 
    8000274e:	fffff097          	auipc	ra,0xfffff
    80002752:	25e080e7          	jalr	606(ra) # 800019ac <myproc>
  p->ps_priority = new_ps;
    80002756:	18952823          	sw	s1,400(a0)
   
  return 0;
}
    8000275a:	4501                	li	a0,0
    8000275c:	60e2                	ld	ra,24(sp)
    8000275e:	6442                	ld	s0,16(sp)
    80002760:	64a2                	ld	s1,8(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret

0000000080002766 <swtch>:
    80002766:	00153023          	sd	ra,0(a0)
    8000276a:	00253423          	sd	sp,8(a0)
    8000276e:	e900                	sd	s0,16(a0)
    80002770:	ed04                	sd	s1,24(a0)
    80002772:	03253023          	sd	s2,32(a0)
    80002776:	03353423          	sd	s3,40(a0)
    8000277a:	03453823          	sd	s4,48(a0)
    8000277e:	03553c23          	sd	s5,56(a0)
    80002782:	05653023          	sd	s6,64(a0)
    80002786:	05753423          	sd	s7,72(a0)
    8000278a:	05853823          	sd	s8,80(a0)
    8000278e:	05953c23          	sd	s9,88(a0)
    80002792:	07a53023          	sd	s10,96(a0)
    80002796:	07b53423          	sd	s11,104(a0)
    8000279a:	0005b083          	ld	ra,0(a1)
    8000279e:	0085b103          	ld	sp,8(a1)
    800027a2:	6980                	ld	s0,16(a1)
    800027a4:	6d84                	ld	s1,24(a1)
    800027a6:	0205b903          	ld	s2,32(a1)
    800027aa:	0285b983          	ld	s3,40(a1)
    800027ae:	0305ba03          	ld	s4,48(a1)
    800027b2:	0385ba83          	ld	s5,56(a1)
    800027b6:	0405bb03          	ld	s6,64(a1)
    800027ba:	0485bb83          	ld	s7,72(a1)
    800027be:	0505bc03          	ld	s8,80(a1)
    800027c2:	0585bc83          	ld	s9,88(a1)
    800027c6:	0605bd03          	ld	s10,96(a1)
    800027ca:	0685bd83          	ld	s11,104(a1)
    800027ce:	8082                	ret

00000000800027d0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800027d0:	1141                	addi	sp,sp,-16
    800027d2:	e406                	sd	ra,8(sp)
    800027d4:	e022                	sd	s0,0(sp)
    800027d6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800027d8:	00006597          	auipc	a1,0x6
    800027dc:	b2058593          	addi	a1,a1,-1248 # 800082f8 <states.0+0x30>
    800027e0:	00015517          	auipc	a0,0x15
    800027e4:	dc050513          	addi	a0,a0,-576 # 800175a0 <tickslock>
    800027e8:	ffffe097          	auipc	ra,0xffffe
    800027ec:	35e080e7          	jalr	862(ra) # 80000b46 <initlock>
}
    800027f0:	60a2                	ld	ra,8(sp)
    800027f2:	6402                	ld	s0,0(sp)
    800027f4:	0141                	addi	sp,sp,16
    800027f6:	8082                	ret

00000000800027f8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027f8:	1141                	addi	sp,sp,-16
    800027fa:	e422                	sd	s0,8(sp)
    800027fc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027fe:	00003797          	auipc	a5,0x3
    80002802:	53278793          	addi	a5,a5,1330 # 80005d30 <kernelvec>
    80002806:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000280a:	6422                	ld	s0,8(sp)
    8000280c:	0141                	addi	sp,sp,16
    8000280e:	8082                	ret

0000000080002810 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002810:	1141                	addi	sp,sp,-16
    80002812:	e406                	sd	ra,8(sp)
    80002814:	e022                	sd	s0,0(sp)
    80002816:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002818:	fffff097          	auipc	ra,0xfffff
    8000281c:	194080e7          	jalr	404(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002820:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002824:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002826:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000282a:	00004617          	auipc	a2,0x4
    8000282e:	7d660613          	addi	a2,a2,2006 # 80007000 <_trampoline>
    80002832:	00004697          	auipc	a3,0x4
    80002836:	7ce68693          	addi	a3,a3,1998 # 80007000 <_trampoline>
    8000283a:	8e91                	sub	a3,a3,a2
    8000283c:	040007b7          	lui	a5,0x4000
    80002840:	17fd                	addi	a5,a5,-1
    80002842:	07b2                	slli	a5,a5,0xc
    80002844:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002846:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000284a:	6158                	ld	a4,128(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000284c:	180026f3          	csrr	a3,satp
    80002850:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002852:	6158                	ld	a4,128(a0)
    80002854:	7534                	ld	a3,104(a0)
    80002856:	6585                	lui	a1,0x1
    80002858:	96ae                	add	a3,a3,a1
    8000285a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000285c:	6158                	ld	a4,128(a0)
    8000285e:	00000697          	auipc	a3,0x0
    80002862:	13068693          	addi	a3,a3,304 # 8000298e <usertrap>
    80002866:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002868:	6158                	ld	a4,128(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000286a:	8692                	mv	a3,tp
    8000286c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000286e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002872:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002876:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000287a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000287e:	6158                	ld	a4,128(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002880:	6f18                	ld	a4,24(a4)
    80002882:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002886:	7d28                	ld	a0,120(a0)
    80002888:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000288a:	00005717          	auipc	a4,0x5
    8000288e:	81270713          	addi	a4,a4,-2030 # 8000709c <userret>
    80002892:	8f11                	sub	a4,a4,a2
    80002894:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002896:	577d                	li	a4,-1
    80002898:	177e                	slli	a4,a4,0x3f
    8000289a:	8d59                	or	a0,a0,a4
    8000289c:	9782                	jalr	a5
}
    8000289e:	60a2                	ld	ra,8(sp)
    800028a0:	6402                	ld	s0,0(sp)
    800028a2:	0141                	addi	sp,sp,16
    800028a4:	8082                	ret

00000000800028a6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800028a6:	1101                	addi	sp,sp,-32
    800028a8:	ec06                	sd	ra,24(sp)
    800028aa:	e822                	sd	s0,16(sp)
    800028ac:	e426                	sd	s1,8(sp)
    800028ae:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800028b0:	00015497          	auipc	s1,0x15
    800028b4:	cf048493          	addi	s1,s1,-784 # 800175a0 <tickslock>
    800028b8:	8526                	mv	a0,s1
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	31c080e7          	jalr	796(ra) # 80000bd6 <acquire>
  ticks++;
    800028c2:	00006517          	auipc	a0,0x6
    800028c6:	03e50513          	addi	a0,a0,62 # 80008900 <ticks>
    800028ca:	411c                	lw	a5,0(a0)
    800028cc:	2785                	addiw	a5,a5,1
    800028ce:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800028d0:	00000097          	auipc	ra,0x0
    800028d4:	8b2080e7          	jalr	-1870(ra) # 80002182 <wakeup>
  release(&tickslock);
    800028d8:	8526                	mv	a0,s1
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	3b0080e7          	jalr	944(ra) # 80000c8a <release>
}
    800028e2:	60e2                	ld	ra,24(sp)
    800028e4:	6442                	ld	s0,16(sp)
    800028e6:	64a2                	ld	s1,8(sp)
    800028e8:	6105                	addi	sp,sp,32
    800028ea:	8082                	ret

00000000800028ec <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800028ec:	1101                	addi	sp,sp,-32
    800028ee:	ec06                	sd	ra,24(sp)
    800028f0:	e822                	sd	s0,16(sp)
    800028f2:	e426                	sd	s1,8(sp)
    800028f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800028fa:	00074d63          	bltz	a4,80002914 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800028fe:	57fd                	li	a5,-1
    80002900:	17fe                	slli	a5,a5,0x3f
    80002902:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002904:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002906:	06f70363          	beq	a4,a5,8000296c <devintr+0x80>
  }
}
    8000290a:	60e2                	ld	ra,24(sp)
    8000290c:	6442                	ld	s0,16(sp)
    8000290e:	64a2                	ld	s1,8(sp)
    80002910:	6105                	addi	sp,sp,32
    80002912:	8082                	ret
     (scause & 0xff) == 9){
    80002914:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002918:	46a5                	li	a3,9
    8000291a:	fed792e3          	bne	a5,a3,800028fe <devintr+0x12>
    int irq = plic_claim();
    8000291e:	00003097          	auipc	ra,0x3
    80002922:	51a080e7          	jalr	1306(ra) # 80005e38 <plic_claim>
    80002926:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002928:	47a9                	li	a5,10
    8000292a:	02f50763          	beq	a0,a5,80002958 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    8000292e:	4785                	li	a5,1
    80002930:	02f50963          	beq	a0,a5,80002962 <devintr+0x76>
    return 1;
    80002934:	4505                	li	a0,1
    } else if(irq){
    80002936:	d8f1                	beqz	s1,8000290a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002938:	85a6                	mv	a1,s1
    8000293a:	00006517          	auipc	a0,0x6
    8000293e:	9c650513          	addi	a0,a0,-1594 # 80008300 <states.0+0x38>
    80002942:	ffffe097          	auipc	ra,0xffffe
    80002946:	c46080e7          	jalr	-954(ra) # 80000588 <printf>
      plic_complete(irq);
    8000294a:	8526                	mv	a0,s1
    8000294c:	00003097          	auipc	ra,0x3
    80002950:	510080e7          	jalr	1296(ra) # 80005e5c <plic_complete>
    return 1;
    80002954:	4505                	li	a0,1
    80002956:	bf55                	j	8000290a <devintr+0x1e>
      uartintr();
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	042080e7          	jalr	66(ra) # 8000099a <uartintr>
    80002960:	b7ed                	j	8000294a <devintr+0x5e>
      virtio_disk_intr();
    80002962:	00004097          	auipc	ra,0x4
    80002966:	9c6080e7          	jalr	-1594(ra) # 80006328 <virtio_disk_intr>
    8000296a:	b7c5                	j	8000294a <devintr+0x5e>
    if(cpuid() == 0){
    8000296c:	fffff097          	auipc	ra,0xfffff
    80002970:	014080e7          	jalr	20(ra) # 80001980 <cpuid>
    80002974:	c901                	beqz	a0,80002984 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002976:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000297a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000297c:	14479073          	csrw	sip,a5
    return 2;
    80002980:	4509                	li	a0,2
    80002982:	b761                	j	8000290a <devintr+0x1e>
      clockintr();
    80002984:	00000097          	auipc	ra,0x0
    80002988:	f22080e7          	jalr	-222(ra) # 800028a6 <clockintr>
    8000298c:	b7ed                	j	80002976 <devintr+0x8a>

000000008000298e <usertrap>:
{
    8000298e:	1101                	addi	sp,sp,-32
    80002990:	ec06                	sd	ra,24(sp)
    80002992:	e822                	sd	s0,16(sp)
    80002994:	e426                	sd	s1,8(sp)
    80002996:	e04a                	sd	s2,0(sp)
    80002998:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000299a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000299e:	1007f793          	andi	a5,a5,256
    800029a2:	e3b1                	bnez	a5,800029e6 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800029a4:	00003797          	auipc	a5,0x3
    800029a8:	38c78793          	addi	a5,a5,908 # 80005d30 <kernelvec>
    800029ac:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800029b0:	fffff097          	auipc	ra,0xfffff
    800029b4:	ffc080e7          	jalr	-4(ra) # 800019ac <myproc>
    800029b8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800029ba:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029bc:	14102773          	csrr	a4,sepc
    800029c0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029c2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800029c6:	47a1                	li	a5,8
    800029c8:	02f70763          	beq	a4,a5,800029f6 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	f20080e7          	jalr	-224(ra) # 800028ec <devintr>
    800029d4:	892a                	mv	s2,a0
    800029d6:	c951                	beqz	a0,80002a6a <usertrap+0xdc>
  if(killed(p))
    800029d8:	8526                	mv	a0,s1
    800029da:	00000097          	auipc	ra,0x0
    800029de:	a6c080e7          	jalr	-1428(ra) # 80002446 <killed>
    800029e2:	cd29                	beqz	a0,80002a3c <usertrap+0xae>
    800029e4:	a099                	j	80002a2a <usertrap+0x9c>
    panic("usertrap: not from user mode");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	93a50513          	addi	a0,a0,-1734 # 80008320 <states.0+0x58>
    800029ee:	ffffe097          	auipc	ra,0xffffe
    800029f2:	b50080e7          	jalr	-1200(ra) # 8000053e <panic>
    if(killed(p))
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	a50080e7          	jalr	-1456(ra) # 80002446 <killed>
    800029fe:	ed21                	bnez	a0,80002a56 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002a00:	60d8                	ld	a4,128(s1)
    80002a02:	6f1c                	ld	a5,24(a4)
    80002a04:	0791                	addi	a5,a5,4
    80002a06:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002a0c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a10:	10079073          	csrw	sstatus,a5
    syscall();
    80002a14:	00000097          	auipc	ra,0x0
    80002a18:	2e4080e7          	jalr	740(ra) # 80002cf8 <syscall>
  if(killed(p))
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	00000097          	auipc	ra,0x0
    80002a22:	a28080e7          	jalr	-1496(ra) # 80002446 <killed>
    80002a26:	cd11                	beqz	a0,80002a42 <usertrap+0xb4>
    80002a28:	4901                	li	s2,0
    exit(-1, "killed");
    80002a2a:	00006597          	auipc	a1,0x6
    80002a2e:	96e58593          	addi	a1,a1,-1682 # 80008398 <states.0+0xd0>
    80002a32:	557d                	li	a0,-1
    80002a34:	00000097          	auipc	ra,0x0
    80002a38:	888080e7          	jalr	-1912(ra) # 800022bc <exit>
  if(which_dev == 2)
    80002a3c:	4789                	li	a5,2
    80002a3e:	06f90363          	beq	s2,a5,80002aa4 <usertrap+0x116>
  usertrapret();
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	dce080e7          	jalr	-562(ra) # 80002810 <usertrapret>
}
    80002a4a:	60e2                	ld	ra,24(sp)
    80002a4c:	6442                	ld	s0,16(sp)
    80002a4e:	64a2                	ld	s1,8(sp)
    80002a50:	6902                	ld	s2,0(sp)
    80002a52:	6105                	addi	sp,sp,32
    80002a54:	8082                	ret
      exit(-1 , "killed ");
    80002a56:	00006597          	auipc	a1,0x6
    80002a5a:	8ea58593          	addi	a1,a1,-1814 # 80008340 <states.0+0x78>
    80002a5e:	557d                	li	a0,-1
    80002a60:	00000097          	auipc	ra,0x0
    80002a64:	85c080e7          	jalr	-1956(ra) # 800022bc <exit>
    80002a68:	bf61                	j	80002a00 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a6a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002a6e:	5890                	lw	a2,48(s1)
    80002a70:	00006517          	auipc	a0,0x6
    80002a74:	8d850513          	addi	a0,a0,-1832 # 80008348 <states.0+0x80>
    80002a78:	ffffe097          	auipc	ra,0xffffe
    80002a7c:	b10080e7          	jalr	-1264(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a84:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a88:	00006517          	auipc	a0,0x6
    80002a8c:	8f050513          	addi	a0,a0,-1808 # 80008378 <states.0+0xb0>
    80002a90:	ffffe097          	auipc	ra,0xffffe
    80002a94:	af8080e7          	jalr	-1288(ra) # 80000588 <printf>
    setkilled(p);
    80002a98:	8526                	mv	a0,s1
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	980080e7          	jalr	-1664(ra) # 8000241a <setkilled>
    80002aa2:	bfad                	j	80002a1c <usertrap+0x8e>
    yield();
    80002aa4:	fffff097          	auipc	ra,0xfffff
    80002aa8:	63e080e7          	jalr	1598(ra) # 800020e2 <yield>
    80002aac:	bf59                	j	80002a42 <usertrap+0xb4>

0000000080002aae <kerneltrap>:
{
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	e84a                	sd	s2,16(sp)
    80002ab8:	e44e                	sd	s3,8(sp)
    80002aba:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002abc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ac0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ac4:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002ac8:	1004f793          	andi	a5,s1,256
    80002acc:	cb85                	beqz	a5,80002afc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ace:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002ad2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002ad4:	ef85                	bnez	a5,80002b0c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	e16080e7          	jalr	-490(ra) # 800028ec <devintr>
    80002ade:	cd1d                	beqz	a0,80002b1c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002ae0:	4789                	li	a5,2
    80002ae2:	06f50a63          	beq	a0,a5,80002b56 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ae6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002aea:	10049073          	csrw	sstatus,s1
}
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6145                	addi	sp,sp,48
    80002afa:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002afc:	00006517          	auipc	a0,0x6
    80002b00:	8a450513          	addi	a0,a0,-1884 # 800083a0 <states.0+0xd8>
    80002b04:	ffffe097          	auipc	ra,0xffffe
    80002b08:	a3a080e7          	jalr	-1478(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002b0c:	00006517          	auipc	a0,0x6
    80002b10:	8bc50513          	addi	a0,a0,-1860 # 800083c8 <states.0+0x100>
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	a2a080e7          	jalr	-1494(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002b1c:	85ce                	mv	a1,s3
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	8ca50513          	addi	a0,a0,-1846 # 800083e8 <states.0+0x120>
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	a62080e7          	jalr	-1438(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b2e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b32:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b36:	00006517          	auipc	a0,0x6
    80002b3a:	8c250513          	addi	a0,a0,-1854 # 800083f8 <states.0+0x130>
    80002b3e:	ffffe097          	auipc	ra,0xffffe
    80002b42:	a4a080e7          	jalr	-1462(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002b46:	00006517          	auipc	a0,0x6
    80002b4a:	8ca50513          	addi	a0,a0,-1846 # 80008410 <states.0+0x148>
    80002b4e:	ffffe097          	auipc	ra,0xffffe
    80002b52:	9f0080e7          	jalr	-1552(ra) # 8000053e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b56:	fffff097          	auipc	ra,0xfffff
    80002b5a:	e56080e7          	jalr	-426(ra) # 800019ac <myproc>
    80002b5e:	d541                	beqz	a0,80002ae6 <kerneltrap+0x38>
    80002b60:	fffff097          	auipc	ra,0xfffff
    80002b64:	e4c080e7          	jalr	-436(ra) # 800019ac <myproc>
    80002b68:	4d18                	lw	a4,24(a0)
    80002b6a:	4791                	li	a5,4
    80002b6c:	f6f71de3          	bne	a4,a5,80002ae6 <kerneltrap+0x38>
    yield();
    80002b70:	fffff097          	auipc	ra,0xfffff
    80002b74:	572080e7          	jalr	1394(ra) # 800020e2 <yield>
    80002b78:	b7bd                	j	80002ae6 <kerneltrap+0x38>

0000000080002b7a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002b7a:	1101                	addi	sp,sp,-32
    80002b7c:	ec06                	sd	ra,24(sp)
    80002b7e:	e822                	sd	s0,16(sp)
    80002b80:	e426                	sd	s1,8(sp)
    80002b82:	1000                	addi	s0,sp,32
    80002b84:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002b86:	fffff097          	auipc	ra,0xfffff
    80002b8a:	e26080e7          	jalr	-474(ra) # 800019ac <myproc>
  switch (n) {
    80002b8e:	4795                	li	a5,5
    80002b90:	0497e163          	bltu	a5,s1,80002bd2 <argraw+0x58>
    80002b94:	048a                	slli	s1,s1,0x2
    80002b96:	00006717          	auipc	a4,0x6
    80002b9a:	8b270713          	addi	a4,a4,-1870 # 80008448 <states.0+0x180>
    80002b9e:	94ba                	add	s1,s1,a4
    80002ba0:	409c                	lw	a5,0(s1)
    80002ba2:	97ba                	add	a5,a5,a4
    80002ba4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ba6:	615c                	ld	a5,128(a0)
    80002ba8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret
    return p->trapframe->a1;
    80002bb4:	615c                	ld	a5,128(a0)
    80002bb6:	7fa8                	ld	a0,120(a5)
    80002bb8:	bfcd                	j	80002baa <argraw+0x30>
    return p->trapframe->a2;
    80002bba:	615c                	ld	a5,128(a0)
    80002bbc:	63c8                	ld	a0,128(a5)
    80002bbe:	b7f5                	j	80002baa <argraw+0x30>
    return p->trapframe->a3;
    80002bc0:	615c                	ld	a5,128(a0)
    80002bc2:	67c8                	ld	a0,136(a5)
    80002bc4:	b7dd                	j	80002baa <argraw+0x30>
    return p->trapframe->a4;
    80002bc6:	615c                	ld	a5,128(a0)
    80002bc8:	6bc8                	ld	a0,144(a5)
    80002bca:	b7c5                	j	80002baa <argraw+0x30>
    return p->trapframe->a5;
    80002bcc:	615c                	ld	a5,128(a0)
    80002bce:	6fc8                	ld	a0,152(a5)
    80002bd0:	bfe9                	j	80002baa <argraw+0x30>
  panic("argraw");
    80002bd2:	00006517          	auipc	a0,0x6
    80002bd6:	84e50513          	addi	a0,a0,-1970 # 80008420 <states.0+0x158>
    80002bda:	ffffe097          	auipc	ra,0xffffe
    80002bde:	964080e7          	jalr	-1692(ra) # 8000053e <panic>

0000000080002be2 <fetchaddr>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	e04a                	sd	s2,0(sp)
    80002bec:	1000                	addi	s0,sp,32
    80002bee:	84aa                	mv	s1,a0
    80002bf0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002bf2:	fffff097          	auipc	ra,0xfffff
    80002bf6:	dba080e7          	jalr	-582(ra) # 800019ac <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002bfa:	793c                	ld	a5,112(a0)
    80002bfc:	02f4f863          	bgeu	s1,a5,80002c2c <fetchaddr+0x4a>
    80002c00:	00848713          	addi	a4,s1,8
    80002c04:	02e7e663          	bltu	a5,a4,80002c30 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c08:	46a1                	li	a3,8
    80002c0a:	8626                	mv	a2,s1
    80002c0c:	85ca                	mv	a1,s2
    80002c0e:	7d28                	ld	a0,120(a0)
    80002c10:	fffff097          	auipc	ra,0xfffff
    80002c14:	ae4080e7          	jalr	-1308(ra) # 800016f4 <copyin>
    80002c18:	00a03533          	snez	a0,a0
    80002c1c:	40a00533          	neg	a0,a0
}
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6902                	ld	s2,0(sp)
    80002c28:	6105                	addi	sp,sp,32
    80002c2a:	8082                	ret
    return -1;
    80002c2c:	557d                	li	a0,-1
    80002c2e:	bfcd                	j	80002c20 <fetchaddr+0x3e>
    80002c30:	557d                	li	a0,-1
    80002c32:	b7fd                	j	80002c20 <fetchaddr+0x3e>

0000000080002c34 <fetchstr>:
{
    80002c34:	7179                	addi	sp,sp,-48
    80002c36:	f406                	sd	ra,40(sp)
    80002c38:	f022                	sd	s0,32(sp)
    80002c3a:	ec26                	sd	s1,24(sp)
    80002c3c:	e84a                	sd	s2,16(sp)
    80002c3e:	e44e                	sd	s3,8(sp)
    80002c40:	1800                	addi	s0,sp,48
    80002c42:	892a                	mv	s2,a0
    80002c44:	84ae                	mv	s1,a1
    80002c46:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002c48:	fffff097          	auipc	ra,0xfffff
    80002c4c:	d64080e7          	jalr	-668(ra) # 800019ac <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002c50:	86ce                	mv	a3,s3
    80002c52:	864a                	mv	a2,s2
    80002c54:	85a6                	mv	a1,s1
    80002c56:	7d28                	ld	a0,120(a0)
    80002c58:	fffff097          	auipc	ra,0xfffff
    80002c5c:	b2a080e7          	jalr	-1238(ra) # 80001782 <copyinstr>
    80002c60:	00054e63          	bltz	a0,80002c7c <fetchstr+0x48>
  return strlen(buf);
    80002c64:	8526                	mv	a0,s1
    80002c66:	ffffe097          	auipc	ra,0xffffe
    80002c6a:	1e8080e7          	jalr	488(ra) # 80000e4e <strlen>
}
    80002c6e:	70a2                	ld	ra,40(sp)
    80002c70:	7402                	ld	s0,32(sp)
    80002c72:	64e2                	ld	s1,24(sp)
    80002c74:	6942                	ld	s2,16(sp)
    80002c76:	69a2                	ld	s3,8(sp)
    80002c78:	6145                	addi	sp,sp,48
    80002c7a:	8082                	ret
    return -1;
    80002c7c:	557d                	li	a0,-1
    80002c7e:	bfc5                	j	80002c6e <fetchstr+0x3a>

0000000080002c80 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002c80:	1101                	addi	sp,sp,-32
    80002c82:	ec06                	sd	ra,24(sp)
    80002c84:	e822                	sd	s0,16(sp)
    80002c86:	e426                	sd	s1,8(sp)
    80002c88:	1000                	addi	s0,sp,32
    80002c8a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	eee080e7          	jalr	-274(ra) # 80002b7a <argraw>
    80002c94:	c088                	sw	a0,0(s1)
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	64a2                	ld	s1,8(sp)
    80002c9c:	6105                	addi	sp,sp,32
    80002c9e:	8082                	ret

0000000080002ca0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002ca0:	1101                	addi	sp,sp,-32
    80002ca2:	ec06                	sd	ra,24(sp)
    80002ca4:	e822                	sd	s0,16(sp)
    80002ca6:	e426                	sd	s1,8(sp)
    80002ca8:	1000                	addi	s0,sp,32
    80002caa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	ece080e7          	jalr	-306(ra) # 80002b7a <argraw>
    80002cb4:	e088                	sd	a0,0(s1)
}
    80002cb6:	60e2                	ld	ra,24(sp)
    80002cb8:	6442                	ld	s0,16(sp)
    80002cba:	64a2                	ld	s1,8(sp)
    80002cbc:	6105                	addi	sp,sp,32
    80002cbe:	8082                	ret

0000000080002cc0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002cc0:	7179                	addi	sp,sp,-48
    80002cc2:	f406                	sd	ra,40(sp)
    80002cc4:	f022                	sd	s0,32(sp)
    80002cc6:	ec26                	sd	s1,24(sp)
    80002cc8:	e84a                	sd	s2,16(sp)
    80002cca:	1800                	addi	s0,sp,48
    80002ccc:	84ae                	mv	s1,a1
    80002cce:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002cd0:	fd840593          	addi	a1,s0,-40
    80002cd4:	00000097          	auipc	ra,0x0
    80002cd8:	fcc080e7          	jalr	-52(ra) # 80002ca0 <argaddr>
  return fetchstr(addr, buf, max);
    80002cdc:	864a                	mv	a2,s2
    80002cde:	85a6                	mv	a1,s1
    80002ce0:	fd843503          	ld	a0,-40(s0)
    80002ce4:	00000097          	auipc	ra,0x0
    80002ce8:	f50080e7          	jalr	-176(ra) # 80002c34 <fetchstr>
}
    80002cec:	70a2                	ld	ra,40(sp)
    80002cee:	7402                	ld	s0,32(sp)
    80002cf0:	64e2                	ld	s1,24(sp)
    80002cf2:	6942                	ld	s2,16(sp)
    80002cf4:	6145                	addi	sp,sp,48
    80002cf6:	8082                	ret

0000000080002cf8 <syscall>:

};

void
syscall(void)
{
    80002cf8:	1101                	addi	sp,sp,-32
    80002cfa:	ec06                	sd	ra,24(sp)
    80002cfc:	e822                	sd	s0,16(sp)
    80002cfe:	e426                	sd	s1,8(sp)
    80002d00:	e04a                	sd	s2,0(sp)
    80002d02:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002d04:	fffff097          	auipc	ra,0xfffff
    80002d08:	ca8080e7          	jalr	-856(ra) # 800019ac <myproc>
    80002d0c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002d0e:	08053903          	ld	s2,128(a0)
    80002d12:	0a893783          	ld	a5,168(s2)
    80002d16:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002d1a:	37fd                	addiw	a5,a5,-1
    80002d1c:	4759                	li	a4,22
    80002d1e:	00f76f63          	bltu	a4,a5,80002d3c <syscall+0x44>
    80002d22:	00369713          	slli	a4,a3,0x3
    80002d26:	00005797          	auipc	a5,0x5
    80002d2a:	73a78793          	addi	a5,a5,1850 # 80008460 <syscalls>
    80002d2e:	97ba                	add	a5,a5,a4
    80002d30:	639c                	ld	a5,0(a5)
    80002d32:	c789                	beqz	a5,80002d3c <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002d34:	9782                	jalr	a5
    80002d36:	06a93823          	sd	a0,112(s2)
    80002d3a:	a839                	j	80002d58 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002d3c:	18048613          	addi	a2,s1,384
    80002d40:	588c                	lw	a1,48(s1)
    80002d42:	00005517          	auipc	a0,0x5
    80002d46:	6e650513          	addi	a0,a0,1766 # 80008428 <states.0+0x160>
    80002d4a:	ffffe097          	auipc	ra,0xffffe
    80002d4e:	83e080e7          	jalr	-1986(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002d52:	60dc                	ld	a5,128(s1)
    80002d54:	577d                	li	a4,-1
    80002d56:	fbb8                	sd	a4,112(a5)
  }
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret

0000000080002d64 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002d64:	7139                	addi	sp,sp,-64
    80002d66:	fc06                	sd	ra,56(sp)
    80002d68:	f822                	sd	s0,48(sp)
    80002d6a:	0080                	addi	s0,sp,64
  int n;
  char exit_msg[32];
  argint(0, &n);
    80002d6c:	fec40593          	addi	a1,s0,-20
    80002d70:	4501                	li	a0,0
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	f0e080e7          	jalr	-242(ra) # 80002c80 <argint>
  argstr(1, exit_msg, MAXARG);
    80002d7a:	02000613          	li	a2,32
    80002d7e:	fc840593          	addi	a1,s0,-56
    80002d82:	4505                	li	a0,1
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	f3c080e7          	jalr	-196(ra) # 80002cc0 <argstr>
  exit(n,exit_msg);
    80002d8c:	fc840593          	addi	a1,s0,-56
    80002d90:	fec42503          	lw	a0,-20(s0)
    80002d94:	fffff097          	auipc	ra,0xfffff
    80002d98:	528080e7          	jalr	1320(ra) # 800022bc <exit>
  return 0;  // not reached
}
    80002d9c:	4501                	li	a0,0
    80002d9e:	70e2                	ld	ra,56(sp)
    80002da0:	7442                	ld	s0,48(sp)
    80002da2:	6121                	addi	sp,sp,64
    80002da4:	8082                	ret

0000000080002da6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002da6:	1141                	addi	sp,sp,-16
    80002da8:	e406                	sd	ra,8(sp)
    80002daa:	e022                	sd	s0,0(sp)
    80002dac:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002dae:	fffff097          	auipc	ra,0xfffff
    80002db2:	bfe080e7          	jalr	-1026(ra) # 800019ac <myproc>
}
    80002db6:	5908                	lw	a0,48(a0)
    80002db8:	60a2                	ld	ra,8(sp)
    80002dba:	6402                	ld	s0,0(sp)
    80002dbc:	0141                	addi	sp,sp,16
    80002dbe:	8082                	ret

0000000080002dc0 <sys_fork>:

uint64
sys_fork(void)
{
    80002dc0:	1141                	addi	sp,sp,-16
    80002dc2:	e406                	sd	ra,8(sp)
    80002dc4:	e022                	sd	s0,0(sp)
    80002dc6:	0800                	addi	s0,sp,16
  return fork();
    80002dc8:	fffff097          	auipc	ra,0xfffff
    80002dcc:	010080e7          	jalr	16(ra) # 80001dd8 <fork>
}
    80002dd0:	60a2                	ld	ra,8(sp)
    80002dd2:	6402                	ld	s0,0(sp)
    80002dd4:	0141                	addi	sp,sp,16
    80002dd6:	8082                	ret

0000000080002dd8 <sys_wait>:

uint64
sys_wait(void)
{
    80002dd8:	1101                	addi	sp,sp,-32
    80002dda:	ec06                	sd	ra,24(sp)
    80002ddc:	e822                	sd	s0,16(sp)
    80002dde:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 exit_msg;
  
  argaddr(0, &p);
    80002de0:	fe840593          	addi	a1,s0,-24
    80002de4:	4501                	li	a0,0
    80002de6:	00000097          	auipc	ra,0x0
    80002dea:	eba080e7          	jalr	-326(ra) # 80002ca0 <argaddr>
  argaddr(1, &exit_msg);
    80002dee:	fe040593          	addi	a1,s0,-32
    80002df2:	4505                	li	a0,1
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	eac080e7          	jalr	-340(ra) # 80002ca0 <argaddr>
  return wait(p,exit_msg);
    80002dfc:	fe043583          	ld	a1,-32(s0)
    80002e00:	fe843503          	ld	a0,-24(s0)
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	674080e7          	jalr	1652(ra) # 80002478 <wait>
}
    80002e0c:	60e2                	ld	ra,24(sp)
    80002e0e:	6442                	ld	s0,16(sp)
    80002e10:	6105                	addi	sp,sp,32
    80002e12:	8082                	ret

0000000080002e14 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002e14:	7179                	addi	sp,sp,-48
    80002e16:	f406                	sd	ra,40(sp)
    80002e18:	f022                	sd	s0,32(sp)
    80002e1a:	ec26                	sd	s1,24(sp)
    80002e1c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002e1e:	fdc40593          	addi	a1,s0,-36
    80002e22:	4501                	li	a0,0
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	e5c080e7          	jalr	-420(ra) # 80002c80 <argint>
  addr = myproc()->sz;
    80002e2c:	fffff097          	auipc	ra,0xfffff
    80002e30:	b80080e7          	jalr	-1152(ra) # 800019ac <myproc>
    80002e34:	7924                	ld	s1,112(a0)
  if(growproc(n) < 0)
    80002e36:	fdc42503          	lw	a0,-36(s0)
    80002e3a:	fffff097          	auipc	ra,0xfffff
    80002e3e:	f42080e7          	jalr	-190(ra) # 80001d7c <growproc>
    80002e42:	00054863          	bltz	a0,80002e52 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002e46:	8526                	mv	a0,s1
    80002e48:	70a2                	ld	ra,40(sp)
    80002e4a:	7402                	ld	s0,32(sp)
    80002e4c:	64e2                	ld	s1,24(sp)
    80002e4e:	6145                	addi	sp,sp,48
    80002e50:	8082                	ret
    return -1;
    80002e52:	54fd                	li	s1,-1
    80002e54:	bfcd                	j	80002e46 <sys_sbrk+0x32>

0000000080002e56 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002e56:	7139                	addi	sp,sp,-64
    80002e58:	fc06                	sd	ra,56(sp)
    80002e5a:	f822                	sd	s0,48(sp)
    80002e5c:	f426                	sd	s1,40(sp)
    80002e5e:	f04a                	sd	s2,32(sp)
    80002e60:	ec4e                	sd	s3,24(sp)
    80002e62:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002e64:	fcc40593          	addi	a1,s0,-52
    80002e68:	4501                	li	a0,0
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	e16080e7          	jalr	-490(ra) # 80002c80 <argint>
  acquire(&tickslock);
    80002e72:	00014517          	auipc	a0,0x14
    80002e76:	72e50513          	addi	a0,a0,1838 # 800175a0 <tickslock>
    80002e7a:	ffffe097          	auipc	ra,0xffffe
    80002e7e:	d5c080e7          	jalr	-676(ra) # 80000bd6 <acquire>
  ticks0 = ticks;
    80002e82:	00006917          	auipc	s2,0x6
    80002e86:	a7e92903          	lw	s2,-1410(s2) # 80008900 <ticks>
  while(ticks - ticks0 < n){
    80002e8a:	fcc42783          	lw	a5,-52(s0)
    80002e8e:	cf9d                	beqz	a5,80002ecc <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002e90:	00014997          	auipc	s3,0x14
    80002e94:	71098993          	addi	s3,s3,1808 # 800175a0 <tickslock>
    80002e98:	00006497          	auipc	s1,0x6
    80002e9c:	a6848493          	addi	s1,s1,-1432 # 80008900 <ticks>
    if(killed(myproc())){
    80002ea0:	fffff097          	auipc	ra,0xfffff
    80002ea4:	b0c080e7          	jalr	-1268(ra) # 800019ac <myproc>
    80002ea8:	fffff097          	auipc	ra,0xfffff
    80002eac:	59e080e7          	jalr	1438(ra) # 80002446 <killed>
    80002eb0:	ed15                	bnez	a0,80002eec <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002eb2:	85ce                	mv	a1,s3
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	268080e7          	jalr	616(ra) # 8000211e <sleep>
  while(ticks - ticks0 < n){
    80002ebe:	409c                	lw	a5,0(s1)
    80002ec0:	412787bb          	subw	a5,a5,s2
    80002ec4:	fcc42703          	lw	a4,-52(s0)
    80002ec8:	fce7ece3          	bltu	a5,a4,80002ea0 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002ecc:	00014517          	auipc	a0,0x14
    80002ed0:	6d450513          	addi	a0,a0,1748 # 800175a0 <tickslock>
    80002ed4:	ffffe097          	auipc	ra,0xffffe
    80002ed8:	db6080e7          	jalr	-586(ra) # 80000c8a <release>
  return 0;
    80002edc:	4501                	li	a0,0
}
    80002ede:	70e2                	ld	ra,56(sp)
    80002ee0:	7442                	ld	s0,48(sp)
    80002ee2:	74a2                	ld	s1,40(sp)
    80002ee4:	7902                	ld	s2,32(sp)
    80002ee6:	69e2                	ld	s3,24(sp)
    80002ee8:	6121                	addi	sp,sp,64
    80002eea:	8082                	ret
      release(&tickslock);
    80002eec:	00014517          	auipc	a0,0x14
    80002ef0:	6b450513          	addi	a0,a0,1716 # 800175a0 <tickslock>
    80002ef4:	ffffe097          	auipc	ra,0xffffe
    80002ef8:	d96080e7          	jalr	-618(ra) # 80000c8a <release>
      return -1;
    80002efc:	557d                	li	a0,-1
    80002efe:	b7c5                	j	80002ede <sys_sleep+0x88>

0000000080002f00 <sys_kill>:

uint64
sys_kill(void)
{
    80002f00:	1101                	addi	sp,sp,-32
    80002f02:	ec06                	sd	ra,24(sp)
    80002f04:	e822                	sd	s0,16(sp)
    80002f06:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002f08:	fec40593          	addi	a1,s0,-20
    80002f0c:	4501                	li	a0,0
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	d72080e7          	jalr	-654(ra) # 80002c80 <argint>
  return kill(pid);
    80002f16:	fec42503          	lw	a0,-20(s0)
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	48e080e7          	jalr	1166(ra) # 800023a8 <kill>
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	6105                	addi	sp,sp,32
    80002f28:	8082                	ret

0000000080002f2a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002f2a:	1101                	addi	sp,sp,-32
    80002f2c:	ec06                	sd	ra,24(sp)
    80002f2e:	e822                	sd	s0,16(sp)
    80002f30:	e426                	sd	s1,8(sp)
    80002f32:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002f34:	00014517          	auipc	a0,0x14
    80002f38:	66c50513          	addi	a0,a0,1644 # 800175a0 <tickslock>
    80002f3c:	ffffe097          	auipc	ra,0xffffe
    80002f40:	c9a080e7          	jalr	-870(ra) # 80000bd6 <acquire>
  xticks = ticks;
    80002f44:	00006497          	auipc	s1,0x6
    80002f48:	9bc4a483          	lw	s1,-1604(s1) # 80008900 <ticks>
  release(&tickslock);
    80002f4c:	00014517          	auipc	a0,0x14
    80002f50:	65450513          	addi	a0,a0,1620 # 800175a0 <tickslock>
    80002f54:	ffffe097          	auipc	ra,0xffffe
    80002f58:	d36080e7          	jalr	-714(ra) # 80000c8a <release>
  return xticks;
}
    80002f5c:	02049513          	slli	a0,s1,0x20
    80002f60:	9101                	srli	a0,a0,0x20
    80002f62:	60e2                	ld	ra,24(sp)
    80002f64:	6442                	ld	s0,16(sp)
    80002f66:	64a2                	ld	s1,8(sp)
    80002f68:	6105                	addi	sp,sp,32
    80002f6a:	8082                	ret

0000000080002f6c <sys_memsize>:

uint64
sys_memsize(void)
{
    80002f6c:	1141                	addi	sp,sp,-16
    80002f6e:	e406                	sd	ra,8(sp)
    80002f70:	e022                	sd	s0,0(sp)
    80002f72:	0800                	addi	s0,sp,16
  return myproc()->sz;  
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	a38080e7          	jalr	-1480(ra) # 800019ac <myproc>
}
    80002f7c:	7928                	ld	a0,112(a0)
    80002f7e:	60a2                	ld	ra,8(sp)
    80002f80:	6402                	ld	s0,0(sp)
    80002f82:	0141                	addi	sp,sp,16
    80002f84:	8082                	ret

0000000080002f86 <sys_set_ps_priority>:

uint64
sys_set_ps_priority(void)
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	1000                	addi	s0,sp,32
  int new_priority;
  argint(0, &new_priority);
    80002f8e:	fec40593          	addi	a1,s0,-20
    80002f92:	4501                	li	a0,0
    80002f94:	00000097          	auipc	ra,0x0
    80002f98:	cec080e7          	jalr	-788(ra) # 80002c80 <argint>
  return set_ps_priority(new_priority);
    80002f9c:	fec42503          	lw	a0,-20(s0)
    80002fa0:	fffff097          	auipc	ra,0xfffff
    80002fa4:	7a2080e7          	jalr	1954(ra) # 80002742 <set_ps_priority>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	6105                	addi	sp,sp,32
    80002fae:	8082                	ret

0000000080002fb0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002fb0:	7179                	addi	sp,sp,-48
    80002fb2:	f406                	sd	ra,40(sp)
    80002fb4:	f022                	sd	s0,32(sp)
    80002fb6:	ec26                	sd	s1,24(sp)
    80002fb8:	e84a                	sd	s2,16(sp)
    80002fba:	e44e                	sd	s3,8(sp)
    80002fbc:	e052                	sd	s4,0(sp)
    80002fbe:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002fc0:	00005597          	auipc	a1,0x5
    80002fc4:	56058593          	addi	a1,a1,1376 # 80008520 <syscalls+0xc0>
    80002fc8:	00014517          	auipc	a0,0x14
    80002fcc:	5f050513          	addi	a0,a0,1520 # 800175b8 <bcache>
    80002fd0:	ffffe097          	auipc	ra,0xffffe
    80002fd4:	b76080e7          	jalr	-1162(ra) # 80000b46 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002fd8:	0001c797          	auipc	a5,0x1c
    80002fdc:	5e078793          	addi	a5,a5,1504 # 8001f5b8 <bcache+0x8000>
    80002fe0:	0001d717          	auipc	a4,0x1d
    80002fe4:	84070713          	addi	a4,a4,-1984 # 8001f820 <bcache+0x8268>
    80002fe8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002fec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ff0:	00014497          	auipc	s1,0x14
    80002ff4:	5e048493          	addi	s1,s1,1504 # 800175d0 <bcache+0x18>
    b->next = bcache.head.next;
    80002ff8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ffa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ffc:	00005a17          	auipc	s4,0x5
    80003000:	52ca0a13          	addi	s4,s4,1324 # 80008528 <syscalls+0xc8>
    b->next = bcache.head.next;
    80003004:	2b893783          	ld	a5,696(s2)
    80003008:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000300a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000300e:	85d2                	mv	a1,s4
    80003010:	01048513          	addi	a0,s1,16
    80003014:	00001097          	auipc	ra,0x1
    80003018:	4c4080e7          	jalr	1220(ra) # 800044d8 <initsleeplock>
    bcache.head.next->prev = b;
    8000301c:	2b893783          	ld	a5,696(s2)
    80003020:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003022:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003026:	45848493          	addi	s1,s1,1112
    8000302a:	fd349de3          	bne	s1,s3,80003004 <binit+0x54>
  }
}
    8000302e:	70a2                	ld	ra,40(sp)
    80003030:	7402                	ld	s0,32(sp)
    80003032:	64e2                	ld	s1,24(sp)
    80003034:	6942                	ld	s2,16(sp)
    80003036:	69a2                	ld	s3,8(sp)
    80003038:	6a02                	ld	s4,0(sp)
    8000303a:	6145                	addi	sp,sp,48
    8000303c:	8082                	ret

000000008000303e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000303e:	7179                	addi	sp,sp,-48
    80003040:	f406                	sd	ra,40(sp)
    80003042:	f022                	sd	s0,32(sp)
    80003044:	ec26                	sd	s1,24(sp)
    80003046:	e84a                	sd	s2,16(sp)
    80003048:	e44e                	sd	s3,8(sp)
    8000304a:	1800                	addi	s0,sp,48
    8000304c:	892a                	mv	s2,a0
    8000304e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003050:	00014517          	auipc	a0,0x14
    80003054:	56850513          	addi	a0,a0,1384 # 800175b8 <bcache>
    80003058:	ffffe097          	auipc	ra,0xffffe
    8000305c:	b7e080e7          	jalr	-1154(ra) # 80000bd6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003060:	0001d497          	auipc	s1,0x1d
    80003064:	8104b483          	ld	s1,-2032(s1) # 8001f870 <bcache+0x82b8>
    80003068:	0001c797          	auipc	a5,0x1c
    8000306c:	7b878793          	addi	a5,a5,1976 # 8001f820 <bcache+0x8268>
    80003070:	02f48f63          	beq	s1,a5,800030ae <bread+0x70>
    80003074:	873e                	mv	a4,a5
    80003076:	a021                	j	8000307e <bread+0x40>
    80003078:	68a4                	ld	s1,80(s1)
    8000307a:	02e48a63          	beq	s1,a4,800030ae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000307e:	449c                	lw	a5,8(s1)
    80003080:	ff279ce3          	bne	a5,s2,80003078 <bread+0x3a>
    80003084:	44dc                	lw	a5,12(s1)
    80003086:	ff3799e3          	bne	a5,s3,80003078 <bread+0x3a>
      b->refcnt++;
    8000308a:	40bc                	lw	a5,64(s1)
    8000308c:	2785                	addiw	a5,a5,1
    8000308e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003090:	00014517          	auipc	a0,0x14
    80003094:	52850513          	addi	a0,a0,1320 # 800175b8 <bcache>
    80003098:	ffffe097          	auipc	ra,0xffffe
    8000309c:	bf2080e7          	jalr	-1038(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800030a0:	01048513          	addi	a0,s1,16
    800030a4:	00001097          	auipc	ra,0x1
    800030a8:	46e080e7          	jalr	1134(ra) # 80004512 <acquiresleep>
      return b;
    800030ac:	a8b9                	j	8000310a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030ae:	0001c497          	auipc	s1,0x1c
    800030b2:	7ba4b483          	ld	s1,1978(s1) # 8001f868 <bcache+0x82b0>
    800030b6:	0001c797          	auipc	a5,0x1c
    800030ba:	76a78793          	addi	a5,a5,1898 # 8001f820 <bcache+0x8268>
    800030be:	00f48863          	beq	s1,a5,800030ce <bread+0x90>
    800030c2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800030c4:	40bc                	lw	a5,64(s1)
    800030c6:	cf81                	beqz	a5,800030de <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030c8:	64a4                	ld	s1,72(s1)
    800030ca:	fee49de3          	bne	s1,a4,800030c4 <bread+0x86>
  panic("bget: no buffers");
    800030ce:	00005517          	auipc	a0,0x5
    800030d2:	46250513          	addi	a0,a0,1122 # 80008530 <syscalls+0xd0>
    800030d6:	ffffd097          	auipc	ra,0xffffd
    800030da:	468080e7          	jalr	1128(ra) # 8000053e <panic>
      b->dev = dev;
    800030de:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800030e2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800030e6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800030ea:	4785                	li	a5,1
    800030ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800030ee:	00014517          	auipc	a0,0x14
    800030f2:	4ca50513          	addi	a0,a0,1226 # 800175b8 <bcache>
    800030f6:	ffffe097          	auipc	ra,0xffffe
    800030fa:	b94080e7          	jalr	-1132(ra) # 80000c8a <release>
      acquiresleep(&b->lock);
    800030fe:	01048513          	addi	a0,s1,16
    80003102:	00001097          	auipc	ra,0x1
    80003106:	410080e7          	jalr	1040(ra) # 80004512 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000310a:	409c                	lw	a5,0(s1)
    8000310c:	cb89                	beqz	a5,8000311e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000310e:	8526                	mv	a0,s1
    80003110:	70a2                	ld	ra,40(sp)
    80003112:	7402                	ld	s0,32(sp)
    80003114:	64e2                	ld	s1,24(sp)
    80003116:	6942                	ld	s2,16(sp)
    80003118:	69a2                	ld	s3,8(sp)
    8000311a:	6145                	addi	sp,sp,48
    8000311c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000311e:	4581                	li	a1,0
    80003120:	8526                	mv	a0,s1
    80003122:	00003097          	auipc	ra,0x3
    80003126:	fd2080e7          	jalr	-46(ra) # 800060f4 <virtio_disk_rw>
    b->valid = 1;
    8000312a:	4785                	li	a5,1
    8000312c:	c09c                	sw	a5,0(s1)
  return b;
    8000312e:	b7c5                	j	8000310e <bread+0xd0>

0000000080003130 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003130:	1101                	addi	sp,sp,-32
    80003132:	ec06                	sd	ra,24(sp)
    80003134:	e822                	sd	s0,16(sp)
    80003136:	e426                	sd	s1,8(sp)
    80003138:	1000                	addi	s0,sp,32
    8000313a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000313c:	0541                	addi	a0,a0,16
    8000313e:	00001097          	auipc	ra,0x1
    80003142:	46e080e7          	jalr	1134(ra) # 800045ac <holdingsleep>
    80003146:	cd01                	beqz	a0,8000315e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003148:	4585                	li	a1,1
    8000314a:	8526                	mv	a0,s1
    8000314c:	00003097          	auipc	ra,0x3
    80003150:	fa8080e7          	jalr	-88(ra) # 800060f4 <virtio_disk_rw>
}
    80003154:	60e2                	ld	ra,24(sp)
    80003156:	6442                	ld	s0,16(sp)
    80003158:	64a2                	ld	s1,8(sp)
    8000315a:	6105                	addi	sp,sp,32
    8000315c:	8082                	ret
    panic("bwrite");
    8000315e:	00005517          	auipc	a0,0x5
    80003162:	3ea50513          	addi	a0,a0,1002 # 80008548 <syscalls+0xe8>
    80003166:	ffffd097          	auipc	ra,0xffffd
    8000316a:	3d8080e7          	jalr	984(ra) # 8000053e <panic>

000000008000316e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000316e:	1101                	addi	sp,sp,-32
    80003170:	ec06                	sd	ra,24(sp)
    80003172:	e822                	sd	s0,16(sp)
    80003174:	e426                	sd	s1,8(sp)
    80003176:	e04a                	sd	s2,0(sp)
    80003178:	1000                	addi	s0,sp,32
    8000317a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000317c:	01050913          	addi	s2,a0,16
    80003180:	854a                	mv	a0,s2
    80003182:	00001097          	auipc	ra,0x1
    80003186:	42a080e7          	jalr	1066(ra) # 800045ac <holdingsleep>
    8000318a:	c92d                	beqz	a0,800031fc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000318c:	854a                	mv	a0,s2
    8000318e:	00001097          	auipc	ra,0x1
    80003192:	3da080e7          	jalr	986(ra) # 80004568 <releasesleep>

  acquire(&bcache.lock);
    80003196:	00014517          	auipc	a0,0x14
    8000319a:	42250513          	addi	a0,a0,1058 # 800175b8 <bcache>
    8000319e:	ffffe097          	auipc	ra,0xffffe
    800031a2:	a38080e7          	jalr	-1480(ra) # 80000bd6 <acquire>
  b->refcnt--;
    800031a6:	40bc                	lw	a5,64(s1)
    800031a8:	37fd                	addiw	a5,a5,-1
    800031aa:	0007871b          	sext.w	a4,a5
    800031ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800031b0:	eb05                	bnez	a4,800031e0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800031b2:	68bc                	ld	a5,80(s1)
    800031b4:	64b8                	ld	a4,72(s1)
    800031b6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800031b8:	64bc                	ld	a5,72(s1)
    800031ba:	68b8                	ld	a4,80(s1)
    800031bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800031be:	0001c797          	auipc	a5,0x1c
    800031c2:	3fa78793          	addi	a5,a5,1018 # 8001f5b8 <bcache+0x8000>
    800031c6:	2b87b703          	ld	a4,696(a5)
    800031ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800031cc:	0001c717          	auipc	a4,0x1c
    800031d0:	65470713          	addi	a4,a4,1620 # 8001f820 <bcache+0x8268>
    800031d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800031d6:	2b87b703          	ld	a4,696(a5)
    800031da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800031dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800031e0:	00014517          	auipc	a0,0x14
    800031e4:	3d850513          	addi	a0,a0,984 # 800175b8 <bcache>
    800031e8:	ffffe097          	auipc	ra,0xffffe
    800031ec:	aa2080e7          	jalr	-1374(ra) # 80000c8a <release>
}
    800031f0:	60e2                	ld	ra,24(sp)
    800031f2:	6442                	ld	s0,16(sp)
    800031f4:	64a2                	ld	s1,8(sp)
    800031f6:	6902                	ld	s2,0(sp)
    800031f8:	6105                	addi	sp,sp,32
    800031fa:	8082                	ret
    panic("brelse");
    800031fc:	00005517          	auipc	a0,0x5
    80003200:	35450513          	addi	a0,a0,852 # 80008550 <syscalls+0xf0>
    80003204:	ffffd097          	auipc	ra,0xffffd
    80003208:	33a080e7          	jalr	826(ra) # 8000053e <panic>

000000008000320c <bpin>:

void
bpin(struct buf *b) {
    8000320c:	1101                	addi	sp,sp,-32
    8000320e:	ec06                	sd	ra,24(sp)
    80003210:	e822                	sd	s0,16(sp)
    80003212:	e426                	sd	s1,8(sp)
    80003214:	1000                	addi	s0,sp,32
    80003216:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003218:	00014517          	auipc	a0,0x14
    8000321c:	3a050513          	addi	a0,a0,928 # 800175b8 <bcache>
    80003220:	ffffe097          	auipc	ra,0xffffe
    80003224:	9b6080e7          	jalr	-1610(ra) # 80000bd6 <acquire>
  b->refcnt++;
    80003228:	40bc                	lw	a5,64(s1)
    8000322a:	2785                	addiw	a5,a5,1
    8000322c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000322e:	00014517          	auipc	a0,0x14
    80003232:	38a50513          	addi	a0,a0,906 # 800175b8 <bcache>
    80003236:	ffffe097          	auipc	ra,0xffffe
    8000323a:	a54080e7          	jalr	-1452(ra) # 80000c8a <release>
}
    8000323e:	60e2                	ld	ra,24(sp)
    80003240:	6442                	ld	s0,16(sp)
    80003242:	64a2                	ld	s1,8(sp)
    80003244:	6105                	addi	sp,sp,32
    80003246:	8082                	ret

0000000080003248 <bunpin>:

void
bunpin(struct buf *b) {
    80003248:	1101                	addi	sp,sp,-32
    8000324a:	ec06                	sd	ra,24(sp)
    8000324c:	e822                	sd	s0,16(sp)
    8000324e:	e426                	sd	s1,8(sp)
    80003250:	1000                	addi	s0,sp,32
    80003252:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003254:	00014517          	auipc	a0,0x14
    80003258:	36450513          	addi	a0,a0,868 # 800175b8 <bcache>
    8000325c:	ffffe097          	auipc	ra,0xffffe
    80003260:	97a080e7          	jalr	-1670(ra) # 80000bd6 <acquire>
  b->refcnt--;
    80003264:	40bc                	lw	a5,64(s1)
    80003266:	37fd                	addiw	a5,a5,-1
    80003268:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000326a:	00014517          	auipc	a0,0x14
    8000326e:	34e50513          	addi	a0,a0,846 # 800175b8 <bcache>
    80003272:	ffffe097          	auipc	ra,0xffffe
    80003276:	a18080e7          	jalr	-1512(ra) # 80000c8a <release>
}
    8000327a:	60e2                	ld	ra,24(sp)
    8000327c:	6442                	ld	s0,16(sp)
    8000327e:	64a2                	ld	s1,8(sp)
    80003280:	6105                	addi	sp,sp,32
    80003282:	8082                	ret

0000000080003284 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	e426                	sd	s1,8(sp)
    8000328c:	e04a                	sd	s2,0(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003292:	00d5d59b          	srliw	a1,a1,0xd
    80003296:	0001d797          	auipc	a5,0x1d
    8000329a:	9fe7a783          	lw	a5,-1538(a5) # 8001fc94 <sb+0x1c>
    8000329e:	9dbd                	addw	a1,a1,a5
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	d9e080e7          	jalr	-610(ra) # 8000303e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032a8:	0074f713          	andi	a4,s1,7
    800032ac:	4785                	li	a5,1
    800032ae:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032b2:	14ce                	slli	s1,s1,0x33
    800032b4:	90d9                	srli	s1,s1,0x36
    800032b6:	00950733          	add	a4,a0,s1
    800032ba:	05874703          	lbu	a4,88(a4)
    800032be:	00e7f6b3          	and	a3,a5,a4
    800032c2:	c69d                	beqz	a3,800032f0 <bfree+0x6c>
    800032c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800032c6:	94aa                	add	s1,s1,a0
    800032c8:	fff7c793          	not	a5,a5
    800032cc:	8ff9                	and	a5,a5,a4
    800032ce:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800032d2:	00001097          	auipc	ra,0x1
    800032d6:	120080e7          	jalr	288(ra) # 800043f2 <log_write>
  brelse(bp);
    800032da:	854a                	mv	a0,s2
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	e92080e7          	jalr	-366(ra) # 8000316e <brelse>
}
    800032e4:	60e2                	ld	ra,24(sp)
    800032e6:	6442                	ld	s0,16(sp)
    800032e8:	64a2                	ld	s1,8(sp)
    800032ea:	6902                	ld	s2,0(sp)
    800032ec:	6105                	addi	sp,sp,32
    800032ee:	8082                	ret
    panic("freeing free block");
    800032f0:	00005517          	auipc	a0,0x5
    800032f4:	26850513          	addi	a0,a0,616 # 80008558 <syscalls+0xf8>
    800032f8:	ffffd097          	auipc	ra,0xffffd
    800032fc:	246080e7          	jalr	582(ra) # 8000053e <panic>

0000000080003300 <balloc>:
{
    80003300:	711d                	addi	sp,sp,-96
    80003302:	ec86                	sd	ra,88(sp)
    80003304:	e8a2                	sd	s0,80(sp)
    80003306:	e4a6                	sd	s1,72(sp)
    80003308:	e0ca                	sd	s2,64(sp)
    8000330a:	fc4e                	sd	s3,56(sp)
    8000330c:	f852                	sd	s4,48(sp)
    8000330e:	f456                	sd	s5,40(sp)
    80003310:	f05a                	sd	s6,32(sp)
    80003312:	ec5e                	sd	s7,24(sp)
    80003314:	e862                	sd	s8,16(sp)
    80003316:	e466                	sd	s9,8(sp)
    80003318:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000331a:	0001d797          	auipc	a5,0x1d
    8000331e:	9627a783          	lw	a5,-1694(a5) # 8001fc7c <sb+0x4>
    80003322:	10078163          	beqz	a5,80003424 <balloc+0x124>
    80003326:	8baa                	mv	s7,a0
    80003328:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000332a:	0001db17          	auipc	s6,0x1d
    8000332e:	94eb0b13          	addi	s6,s6,-1714 # 8001fc78 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003332:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003334:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003336:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003338:	6c89                	lui	s9,0x2
    8000333a:	a061                	j	800033c2 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000333c:	974a                	add	a4,a4,s2
    8000333e:	8fd5                	or	a5,a5,a3
    80003340:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003344:	854a                	mv	a0,s2
    80003346:	00001097          	auipc	ra,0x1
    8000334a:	0ac080e7          	jalr	172(ra) # 800043f2 <log_write>
        brelse(bp);
    8000334e:	854a                	mv	a0,s2
    80003350:	00000097          	auipc	ra,0x0
    80003354:	e1e080e7          	jalr	-482(ra) # 8000316e <brelse>
  bp = bread(dev, bno);
    80003358:	85a6                	mv	a1,s1
    8000335a:	855e                	mv	a0,s7
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	ce2080e7          	jalr	-798(ra) # 8000303e <bread>
    80003364:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003366:	40000613          	li	a2,1024
    8000336a:	4581                	li	a1,0
    8000336c:	05850513          	addi	a0,a0,88
    80003370:	ffffe097          	auipc	ra,0xffffe
    80003374:	962080e7          	jalr	-1694(ra) # 80000cd2 <memset>
  log_write(bp);
    80003378:	854a                	mv	a0,s2
    8000337a:	00001097          	auipc	ra,0x1
    8000337e:	078080e7          	jalr	120(ra) # 800043f2 <log_write>
  brelse(bp);
    80003382:	854a                	mv	a0,s2
    80003384:	00000097          	auipc	ra,0x0
    80003388:	dea080e7          	jalr	-534(ra) # 8000316e <brelse>
}
    8000338c:	8526                	mv	a0,s1
    8000338e:	60e6                	ld	ra,88(sp)
    80003390:	6446                	ld	s0,80(sp)
    80003392:	64a6                	ld	s1,72(sp)
    80003394:	6906                	ld	s2,64(sp)
    80003396:	79e2                	ld	s3,56(sp)
    80003398:	7a42                	ld	s4,48(sp)
    8000339a:	7aa2                	ld	s5,40(sp)
    8000339c:	7b02                	ld	s6,32(sp)
    8000339e:	6be2                	ld	s7,24(sp)
    800033a0:	6c42                	ld	s8,16(sp)
    800033a2:	6ca2                	ld	s9,8(sp)
    800033a4:	6125                	addi	sp,sp,96
    800033a6:	8082                	ret
    brelse(bp);
    800033a8:	854a                	mv	a0,s2
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	dc4080e7          	jalr	-572(ra) # 8000316e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800033b2:	015c87bb          	addw	a5,s9,s5
    800033b6:	00078a9b          	sext.w	s5,a5
    800033ba:	004b2703          	lw	a4,4(s6)
    800033be:	06eaf363          	bgeu	s5,a4,80003424 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800033c2:	41fad79b          	sraiw	a5,s5,0x1f
    800033c6:	0137d79b          	srliw	a5,a5,0x13
    800033ca:	015787bb          	addw	a5,a5,s5
    800033ce:	40d7d79b          	sraiw	a5,a5,0xd
    800033d2:	01cb2583          	lw	a1,28(s6)
    800033d6:	9dbd                	addw	a1,a1,a5
    800033d8:	855e                	mv	a0,s7
    800033da:	00000097          	auipc	ra,0x0
    800033de:	c64080e7          	jalr	-924(ra) # 8000303e <bread>
    800033e2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033e4:	004b2503          	lw	a0,4(s6)
    800033e8:	000a849b          	sext.w	s1,s5
    800033ec:	8662                	mv	a2,s8
    800033ee:	faa4fde3          	bgeu	s1,a0,800033a8 <balloc+0xa8>
      m = 1 << (bi % 8);
    800033f2:	41f6579b          	sraiw	a5,a2,0x1f
    800033f6:	01d7d69b          	srliw	a3,a5,0x1d
    800033fa:	00c6873b          	addw	a4,a3,a2
    800033fe:	00777793          	andi	a5,a4,7
    80003402:	9f95                	subw	a5,a5,a3
    80003404:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003408:	4037571b          	sraiw	a4,a4,0x3
    8000340c:	00e906b3          	add	a3,s2,a4
    80003410:	0586c683          	lbu	a3,88(a3)
    80003414:	00d7f5b3          	and	a1,a5,a3
    80003418:	d195                	beqz	a1,8000333c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000341a:	2605                	addiw	a2,a2,1
    8000341c:	2485                	addiw	s1,s1,1
    8000341e:	fd4618e3          	bne	a2,s4,800033ee <balloc+0xee>
    80003422:	b759                	j	800033a8 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003424:	00005517          	auipc	a0,0x5
    80003428:	14c50513          	addi	a0,a0,332 # 80008570 <syscalls+0x110>
    8000342c:	ffffd097          	auipc	ra,0xffffd
    80003430:	15c080e7          	jalr	348(ra) # 80000588 <printf>
  return 0;
    80003434:	4481                	li	s1,0
    80003436:	bf99                	j	8000338c <balloc+0x8c>

0000000080003438 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003438:	7179                	addi	sp,sp,-48
    8000343a:	f406                	sd	ra,40(sp)
    8000343c:	f022                	sd	s0,32(sp)
    8000343e:	ec26                	sd	s1,24(sp)
    80003440:	e84a                	sd	s2,16(sp)
    80003442:	e44e                	sd	s3,8(sp)
    80003444:	e052                	sd	s4,0(sp)
    80003446:	1800                	addi	s0,sp,48
    80003448:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000344a:	47ad                	li	a5,11
    8000344c:	02b7e763          	bltu	a5,a1,8000347a <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003450:	02059493          	slli	s1,a1,0x20
    80003454:	9081                	srli	s1,s1,0x20
    80003456:	048a                	slli	s1,s1,0x2
    80003458:	94aa                	add	s1,s1,a0
    8000345a:	0504a903          	lw	s2,80(s1)
    8000345e:	06091e63          	bnez	s2,800034da <bmap+0xa2>
      addr = balloc(ip->dev);
    80003462:	4108                	lw	a0,0(a0)
    80003464:	00000097          	auipc	ra,0x0
    80003468:	e9c080e7          	jalr	-356(ra) # 80003300 <balloc>
    8000346c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003470:	06090563          	beqz	s2,800034da <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003474:	0524a823          	sw	s2,80(s1)
    80003478:	a08d                	j	800034da <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000347a:	ff45849b          	addiw	s1,a1,-12
    8000347e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003482:	0ff00793          	li	a5,255
    80003486:	08e7e563          	bltu	a5,a4,80003510 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000348a:	08052903          	lw	s2,128(a0)
    8000348e:	00091d63          	bnez	s2,800034a8 <bmap+0x70>
      addr = balloc(ip->dev);
    80003492:	4108                	lw	a0,0(a0)
    80003494:	00000097          	auipc	ra,0x0
    80003498:	e6c080e7          	jalr	-404(ra) # 80003300 <balloc>
    8000349c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034a0:	02090d63          	beqz	s2,800034da <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800034a4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800034a8:	85ca                	mv	a1,s2
    800034aa:	0009a503          	lw	a0,0(s3)
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	b90080e7          	jalr	-1136(ra) # 8000303e <bread>
    800034b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034b8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800034bc:	02049593          	slli	a1,s1,0x20
    800034c0:	9181                	srli	a1,a1,0x20
    800034c2:	058a                	slli	a1,a1,0x2
    800034c4:	00b784b3          	add	s1,a5,a1
    800034c8:	0004a903          	lw	s2,0(s1)
    800034cc:	02090063          	beqz	s2,800034ec <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800034d0:	8552                	mv	a0,s4
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	c9c080e7          	jalr	-868(ra) # 8000316e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800034da:	854a                	mv	a0,s2
    800034dc:	70a2                	ld	ra,40(sp)
    800034de:	7402                	ld	s0,32(sp)
    800034e0:	64e2                	ld	s1,24(sp)
    800034e2:	6942                	ld	s2,16(sp)
    800034e4:	69a2                	ld	s3,8(sp)
    800034e6:	6a02                	ld	s4,0(sp)
    800034e8:	6145                	addi	sp,sp,48
    800034ea:	8082                	ret
      addr = balloc(ip->dev);
    800034ec:	0009a503          	lw	a0,0(s3)
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	e10080e7          	jalr	-496(ra) # 80003300 <balloc>
    800034f8:	0005091b          	sext.w	s2,a0
      if(addr){
    800034fc:	fc090ae3          	beqz	s2,800034d0 <bmap+0x98>
        a[bn] = addr;
    80003500:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003504:	8552                	mv	a0,s4
    80003506:	00001097          	auipc	ra,0x1
    8000350a:	eec080e7          	jalr	-276(ra) # 800043f2 <log_write>
    8000350e:	b7c9                	j	800034d0 <bmap+0x98>
  panic("bmap: out of range");
    80003510:	00005517          	auipc	a0,0x5
    80003514:	07850513          	addi	a0,a0,120 # 80008588 <syscalls+0x128>
    80003518:	ffffd097          	auipc	ra,0xffffd
    8000351c:	026080e7          	jalr	38(ra) # 8000053e <panic>

0000000080003520 <iget>:
{
    80003520:	7179                	addi	sp,sp,-48
    80003522:	f406                	sd	ra,40(sp)
    80003524:	f022                	sd	s0,32(sp)
    80003526:	ec26                	sd	s1,24(sp)
    80003528:	e84a                	sd	s2,16(sp)
    8000352a:	e44e                	sd	s3,8(sp)
    8000352c:	e052                	sd	s4,0(sp)
    8000352e:	1800                	addi	s0,sp,48
    80003530:	89aa                	mv	s3,a0
    80003532:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003534:	0001c517          	auipc	a0,0x1c
    80003538:	76450513          	addi	a0,a0,1892 # 8001fc98 <itable>
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	69a080e7          	jalr	1690(ra) # 80000bd6 <acquire>
  empty = 0;
    80003544:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003546:	0001c497          	auipc	s1,0x1c
    8000354a:	76a48493          	addi	s1,s1,1898 # 8001fcb0 <itable+0x18>
    8000354e:	0001e697          	auipc	a3,0x1e
    80003552:	1f268693          	addi	a3,a3,498 # 80021740 <log>
    80003556:	a039                	j	80003564 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003558:	02090b63          	beqz	s2,8000358e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000355c:	08848493          	addi	s1,s1,136
    80003560:	02d48a63          	beq	s1,a3,80003594 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003564:	449c                	lw	a5,8(s1)
    80003566:	fef059e3          	blez	a5,80003558 <iget+0x38>
    8000356a:	4098                	lw	a4,0(s1)
    8000356c:	ff3716e3          	bne	a4,s3,80003558 <iget+0x38>
    80003570:	40d8                	lw	a4,4(s1)
    80003572:	ff4713e3          	bne	a4,s4,80003558 <iget+0x38>
      ip->ref++;
    80003576:	2785                	addiw	a5,a5,1
    80003578:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000357a:	0001c517          	auipc	a0,0x1c
    8000357e:	71e50513          	addi	a0,a0,1822 # 8001fc98 <itable>
    80003582:	ffffd097          	auipc	ra,0xffffd
    80003586:	708080e7          	jalr	1800(ra) # 80000c8a <release>
      return ip;
    8000358a:	8926                	mv	s2,s1
    8000358c:	a03d                	j	800035ba <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000358e:	f7f9                	bnez	a5,8000355c <iget+0x3c>
    80003590:	8926                	mv	s2,s1
    80003592:	b7e9                	j	8000355c <iget+0x3c>
  if(empty == 0)
    80003594:	02090c63          	beqz	s2,800035cc <iget+0xac>
  ip->dev = dev;
    80003598:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000359c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035a0:	4785                	li	a5,1
    800035a2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035a6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800035aa:	0001c517          	auipc	a0,0x1c
    800035ae:	6ee50513          	addi	a0,a0,1774 # 8001fc98 <itable>
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	6d8080e7          	jalr	1752(ra) # 80000c8a <release>
}
    800035ba:	854a                	mv	a0,s2
    800035bc:	70a2                	ld	ra,40(sp)
    800035be:	7402                	ld	s0,32(sp)
    800035c0:	64e2                	ld	s1,24(sp)
    800035c2:	6942                	ld	s2,16(sp)
    800035c4:	69a2                	ld	s3,8(sp)
    800035c6:	6a02                	ld	s4,0(sp)
    800035c8:	6145                	addi	sp,sp,48
    800035ca:	8082                	ret
    panic("iget: no inodes");
    800035cc:	00005517          	auipc	a0,0x5
    800035d0:	fd450513          	addi	a0,a0,-44 # 800085a0 <syscalls+0x140>
    800035d4:	ffffd097          	auipc	ra,0xffffd
    800035d8:	f6a080e7          	jalr	-150(ra) # 8000053e <panic>

00000000800035dc <fsinit>:
fsinit(int dev) {
    800035dc:	7179                	addi	sp,sp,-48
    800035de:	f406                	sd	ra,40(sp)
    800035e0:	f022                	sd	s0,32(sp)
    800035e2:	ec26                	sd	s1,24(sp)
    800035e4:	e84a                	sd	s2,16(sp)
    800035e6:	e44e                	sd	s3,8(sp)
    800035e8:	1800                	addi	s0,sp,48
    800035ea:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035ec:	4585                	li	a1,1
    800035ee:	00000097          	auipc	ra,0x0
    800035f2:	a50080e7          	jalr	-1456(ra) # 8000303e <bread>
    800035f6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035f8:	0001c997          	auipc	s3,0x1c
    800035fc:	68098993          	addi	s3,s3,1664 # 8001fc78 <sb>
    80003600:	02000613          	li	a2,32
    80003604:	05850593          	addi	a1,a0,88
    80003608:	854e                	mv	a0,s3
    8000360a:	ffffd097          	auipc	ra,0xffffd
    8000360e:	724080e7          	jalr	1828(ra) # 80000d2e <memmove>
  brelse(bp);
    80003612:	8526                	mv	a0,s1
    80003614:	00000097          	auipc	ra,0x0
    80003618:	b5a080e7          	jalr	-1190(ra) # 8000316e <brelse>
  if(sb.magic != FSMAGIC)
    8000361c:	0009a703          	lw	a4,0(s3)
    80003620:	102037b7          	lui	a5,0x10203
    80003624:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003628:	02f71263          	bne	a4,a5,8000364c <fsinit+0x70>
  initlog(dev, &sb);
    8000362c:	0001c597          	auipc	a1,0x1c
    80003630:	64c58593          	addi	a1,a1,1612 # 8001fc78 <sb>
    80003634:	854a                	mv	a0,s2
    80003636:	00001097          	auipc	ra,0x1
    8000363a:	b40080e7          	jalr	-1216(ra) # 80004176 <initlog>
}
    8000363e:	70a2                	ld	ra,40(sp)
    80003640:	7402                	ld	s0,32(sp)
    80003642:	64e2                	ld	s1,24(sp)
    80003644:	6942                	ld	s2,16(sp)
    80003646:	69a2                	ld	s3,8(sp)
    80003648:	6145                	addi	sp,sp,48
    8000364a:	8082                	ret
    panic("invalid file system");
    8000364c:	00005517          	auipc	a0,0x5
    80003650:	f6450513          	addi	a0,a0,-156 # 800085b0 <syscalls+0x150>
    80003654:	ffffd097          	auipc	ra,0xffffd
    80003658:	eea080e7          	jalr	-278(ra) # 8000053e <panic>

000000008000365c <iinit>:
{
    8000365c:	7179                	addi	sp,sp,-48
    8000365e:	f406                	sd	ra,40(sp)
    80003660:	f022                	sd	s0,32(sp)
    80003662:	ec26                	sd	s1,24(sp)
    80003664:	e84a                	sd	s2,16(sp)
    80003666:	e44e                	sd	s3,8(sp)
    80003668:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000366a:	00005597          	auipc	a1,0x5
    8000366e:	f5e58593          	addi	a1,a1,-162 # 800085c8 <syscalls+0x168>
    80003672:	0001c517          	auipc	a0,0x1c
    80003676:	62650513          	addi	a0,a0,1574 # 8001fc98 <itable>
    8000367a:	ffffd097          	auipc	ra,0xffffd
    8000367e:	4cc080e7          	jalr	1228(ra) # 80000b46 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003682:	0001c497          	auipc	s1,0x1c
    80003686:	63e48493          	addi	s1,s1,1598 # 8001fcc0 <itable+0x28>
    8000368a:	0001e997          	auipc	s3,0x1e
    8000368e:	0c698993          	addi	s3,s3,198 # 80021750 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003692:	00005917          	auipc	s2,0x5
    80003696:	f3e90913          	addi	s2,s2,-194 # 800085d0 <syscalls+0x170>
    8000369a:	85ca                	mv	a1,s2
    8000369c:	8526                	mv	a0,s1
    8000369e:	00001097          	auipc	ra,0x1
    800036a2:	e3a080e7          	jalr	-454(ra) # 800044d8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036a6:	08848493          	addi	s1,s1,136
    800036aa:	ff3498e3          	bne	s1,s3,8000369a <iinit+0x3e>
}
    800036ae:	70a2                	ld	ra,40(sp)
    800036b0:	7402                	ld	s0,32(sp)
    800036b2:	64e2                	ld	s1,24(sp)
    800036b4:	6942                	ld	s2,16(sp)
    800036b6:	69a2                	ld	s3,8(sp)
    800036b8:	6145                	addi	sp,sp,48
    800036ba:	8082                	ret

00000000800036bc <ialloc>:
{
    800036bc:	715d                	addi	sp,sp,-80
    800036be:	e486                	sd	ra,72(sp)
    800036c0:	e0a2                	sd	s0,64(sp)
    800036c2:	fc26                	sd	s1,56(sp)
    800036c4:	f84a                	sd	s2,48(sp)
    800036c6:	f44e                	sd	s3,40(sp)
    800036c8:	f052                	sd	s4,32(sp)
    800036ca:	ec56                	sd	s5,24(sp)
    800036cc:	e85a                	sd	s6,16(sp)
    800036ce:	e45e                	sd	s7,8(sp)
    800036d0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800036d2:	0001c717          	auipc	a4,0x1c
    800036d6:	5b272703          	lw	a4,1458(a4) # 8001fc84 <sb+0xc>
    800036da:	4785                	li	a5,1
    800036dc:	04e7fa63          	bgeu	a5,a4,80003730 <ialloc+0x74>
    800036e0:	8aaa                	mv	s5,a0
    800036e2:	8bae                	mv	s7,a1
    800036e4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036e6:	0001ca17          	auipc	s4,0x1c
    800036ea:	592a0a13          	addi	s4,s4,1426 # 8001fc78 <sb>
    800036ee:	00048b1b          	sext.w	s6,s1
    800036f2:	0044d793          	srli	a5,s1,0x4
    800036f6:	018a2583          	lw	a1,24(s4)
    800036fa:	9dbd                	addw	a1,a1,a5
    800036fc:	8556                	mv	a0,s5
    800036fe:	00000097          	auipc	ra,0x0
    80003702:	940080e7          	jalr	-1728(ra) # 8000303e <bread>
    80003706:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003708:	05850993          	addi	s3,a0,88
    8000370c:	00f4f793          	andi	a5,s1,15
    80003710:	079a                	slli	a5,a5,0x6
    80003712:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003714:	00099783          	lh	a5,0(s3)
    80003718:	c3a1                	beqz	a5,80003758 <ialloc+0x9c>
    brelse(bp);
    8000371a:	00000097          	auipc	ra,0x0
    8000371e:	a54080e7          	jalr	-1452(ra) # 8000316e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003722:	0485                	addi	s1,s1,1
    80003724:	00ca2703          	lw	a4,12(s4)
    80003728:	0004879b          	sext.w	a5,s1
    8000372c:	fce7e1e3          	bltu	a5,a4,800036ee <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003730:	00005517          	auipc	a0,0x5
    80003734:	ea850513          	addi	a0,a0,-344 # 800085d8 <syscalls+0x178>
    80003738:	ffffd097          	auipc	ra,0xffffd
    8000373c:	e50080e7          	jalr	-432(ra) # 80000588 <printf>
  return 0;
    80003740:	4501                	li	a0,0
}
    80003742:	60a6                	ld	ra,72(sp)
    80003744:	6406                	ld	s0,64(sp)
    80003746:	74e2                	ld	s1,56(sp)
    80003748:	7942                	ld	s2,48(sp)
    8000374a:	79a2                	ld	s3,40(sp)
    8000374c:	7a02                	ld	s4,32(sp)
    8000374e:	6ae2                	ld	s5,24(sp)
    80003750:	6b42                	ld	s6,16(sp)
    80003752:	6ba2                	ld	s7,8(sp)
    80003754:	6161                	addi	sp,sp,80
    80003756:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003758:	04000613          	li	a2,64
    8000375c:	4581                	li	a1,0
    8000375e:	854e                	mv	a0,s3
    80003760:	ffffd097          	auipc	ra,0xffffd
    80003764:	572080e7          	jalr	1394(ra) # 80000cd2 <memset>
      dip->type = type;
    80003768:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000376c:	854a                	mv	a0,s2
    8000376e:	00001097          	auipc	ra,0x1
    80003772:	c84080e7          	jalr	-892(ra) # 800043f2 <log_write>
      brelse(bp);
    80003776:	854a                	mv	a0,s2
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	9f6080e7          	jalr	-1546(ra) # 8000316e <brelse>
      return iget(dev, inum);
    80003780:	85da                	mv	a1,s6
    80003782:	8556                	mv	a0,s5
    80003784:	00000097          	auipc	ra,0x0
    80003788:	d9c080e7          	jalr	-612(ra) # 80003520 <iget>
    8000378c:	bf5d                	j	80003742 <ialloc+0x86>

000000008000378e <iupdate>:
{
    8000378e:	1101                	addi	sp,sp,-32
    80003790:	ec06                	sd	ra,24(sp)
    80003792:	e822                	sd	s0,16(sp)
    80003794:	e426                	sd	s1,8(sp)
    80003796:	e04a                	sd	s2,0(sp)
    80003798:	1000                	addi	s0,sp,32
    8000379a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000379c:	415c                	lw	a5,4(a0)
    8000379e:	0047d79b          	srliw	a5,a5,0x4
    800037a2:	0001c597          	auipc	a1,0x1c
    800037a6:	4ee5a583          	lw	a1,1262(a1) # 8001fc90 <sb+0x18>
    800037aa:	9dbd                	addw	a1,a1,a5
    800037ac:	4108                	lw	a0,0(a0)
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	890080e7          	jalr	-1904(ra) # 8000303e <bread>
    800037b6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037b8:	05850793          	addi	a5,a0,88
    800037bc:	40c8                	lw	a0,4(s1)
    800037be:	893d                	andi	a0,a0,15
    800037c0:	051a                	slli	a0,a0,0x6
    800037c2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800037c4:	04449703          	lh	a4,68(s1)
    800037c8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800037cc:	04649703          	lh	a4,70(s1)
    800037d0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800037d4:	04849703          	lh	a4,72(s1)
    800037d8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800037dc:	04a49703          	lh	a4,74(s1)
    800037e0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800037e4:	44f8                	lw	a4,76(s1)
    800037e6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037e8:	03400613          	li	a2,52
    800037ec:	05048593          	addi	a1,s1,80
    800037f0:	0531                	addi	a0,a0,12
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	53c080e7          	jalr	1340(ra) # 80000d2e <memmove>
  log_write(bp);
    800037fa:	854a                	mv	a0,s2
    800037fc:	00001097          	auipc	ra,0x1
    80003800:	bf6080e7          	jalr	-1034(ra) # 800043f2 <log_write>
  brelse(bp);
    80003804:	854a                	mv	a0,s2
    80003806:	00000097          	auipc	ra,0x0
    8000380a:	968080e7          	jalr	-1688(ra) # 8000316e <brelse>
}
    8000380e:	60e2                	ld	ra,24(sp)
    80003810:	6442                	ld	s0,16(sp)
    80003812:	64a2                	ld	s1,8(sp)
    80003814:	6902                	ld	s2,0(sp)
    80003816:	6105                	addi	sp,sp,32
    80003818:	8082                	ret

000000008000381a <idup>:
{
    8000381a:	1101                	addi	sp,sp,-32
    8000381c:	ec06                	sd	ra,24(sp)
    8000381e:	e822                	sd	s0,16(sp)
    80003820:	e426                	sd	s1,8(sp)
    80003822:	1000                	addi	s0,sp,32
    80003824:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003826:	0001c517          	auipc	a0,0x1c
    8000382a:	47250513          	addi	a0,a0,1138 # 8001fc98 <itable>
    8000382e:	ffffd097          	auipc	ra,0xffffd
    80003832:	3a8080e7          	jalr	936(ra) # 80000bd6 <acquire>
  ip->ref++;
    80003836:	449c                	lw	a5,8(s1)
    80003838:	2785                	addiw	a5,a5,1
    8000383a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000383c:	0001c517          	auipc	a0,0x1c
    80003840:	45c50513          	addi	a0,a0,1116 # 8001fc98 <itable>
    80003844:	ffffd097          	auipc	ra,0xffffd
    80003848:	446080e7          	jalr	1094(ra) # 80000c8a <release>
}
    8000384c:	8526                	mv	a0,s1
    8000384e:	60e2                	ld	ra,24(sp)
    80003850:	6442                	ld	s0,16(sp)
    80003852:	64a2                	ld	s1,8(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret

0000000080003858 <ilock>:
{
    80003858:	1101                	addi	sp,sp,-32
    8000385a:	ec06                	sd	ra,24(sp)
    8000385c:	e822                	sd	s0,16(sp)
    8000385e:	e426                	sd	s1,8(sp)
    80003860:	e04a                	sd	s2,0(sp)
    80003862:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003864:	c115                	beqz	a0,80003888 <ilock+0x30>
    80003866:	84aa                	mv	s1,a0
    80003868:	451c                	lw	a5,8(a0)
    8000386a:	00f05f63          	blez	a5,80003888 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000386e:	0541                	addi	a0,a0,16
    80003870:	00001097          	auipc	ra,0x1
    80003874:	ca2080e7          	jalr	-862(ra) # 80004512 <acquiresleep>
  if(ip->valid == 0){
    80003878:	40bc                	lw	a5,64(s1)
    8000387a:	cf99                	beqz	a5,80003898 <ilock+0x40>
}
    8000387c:	60e2                	ld	ra,24(sp)
    8000387e:	6442                	ld	s0,16(sp)
    80003880:	64a2                	ld	s1,8(sp)
    80003882:	6902                	ld	s2,0(sp)
    80003884:	6105                	addi	sp,sp,32
    80003886:	8082                	ret
    panic("ilock");
    80003888:	00005517          	auipc	a0,0x5
    8000388c:	d6850513          	addi	a0,a0,-664 # 800085f0 <syscalls+0x190>
    80003890:	ffffd097          	auipc	ra,0xffffd
    80003894:	cae080e7          	jalr	-850(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003898:	40dc                	lw	a5,4(s1)
    8000389a:	0047d79b          	srliw	a5,a5,0x4
    8000389e:	0001c597          	auipc	a1,0x1c
    800038a2:	3f25a583          	lw	a1,1010(a1) # 8001fc90 <sb+0x18>
    800038a6:	9dbd                	addw	a1,a1,a5
    800038a8:	4088                	lw	a0,0(s1)
    800038aa:	fffff097          	auipc	ra,0xfffff
    800038ae:	794080e7          	jalr	1940(ra) # 8000303e <bread>
    800038b2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038b4:	05850593          	addi	a1,a0,88
    800038b8:	40dc                	lw	a5,4(s1)
    800038ba:	8bbd                	andi	a5,a5,15
    800038bc:	079a                	slli	a5,a5,0x6
    800038be:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038c0:	00059783          	lh	a5,0(a1)
    800038c4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800038c8:	00259783          	lh	a5,2(a1)
    800038cc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800038d0:	00459783          	lh	a5,4(a1)
    800038d4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800038d8:	00659783          	lh	a5,6(a1)
    800038dc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800038e0:	459c                	lw	a5,8(a1)
    800038e2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800038e4:	03400613          	li	a2,52
    800038e8:	05b1                	addi	a1,a1,12
    800038ea:	05048513          	addi	a0,s1,80
    800038ee:	ffffd097          	auipc	ra,0xffffd
    800038f2:	440080e7          	jalr	1088(ra) # 80000d2e <memmove>
    brelse(bp);
    800038f6:	854a                	mv	a0,s2
    800038f8:	00000097          	auipc	ra,0x0
    800038fc:	876080e7          	jalr	-1930(ra) # 8000316e <brelse>
    ip->valid = 1;
    80003900:	4785                	li	a5,1
    80003902:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003904:	04449783          	lh	a5,68(s1)
    80003908:	fbb5                	bnez	a5,8000387c <ilock+0x24>
      panic("ilock: no type");
    8000390a:	00005517          	auipc	a0,0x5
    8000390e:	cee50513          	addi	a0,a0,-786 # 800085f8 <syscalls+0x198>
    80003912:	ffffd097          	auipc	ra,0xffffd
    80003916:	c2c080e7          	jalr	-980(ra) # 8000053e <panic>

000000008000391a <iunlock>:
{
    8000391a:	1101                	addi	sp,sp,-32
    8000391c:	ec06                	sd	ra,24(sp)
    8000391e:	e822                	sd	s0,16(sp)
    80003920:	e426                	sd	s1,8(sp)
    80003922:	e04a                	sd	s2,0(sp)
    80003924:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003926:	c905                	beqz	a0,80003956 <iunlock+0x3c>
    80003928:	84aa                	mv	s1,a0
    8000392a:	01050913          	addi	s2,a0,16
    8000392e:	854a                	mv	a0,s2
    80003930:	00001097          	auipc	ra,0x1
    80003934:	c7c080e7          	jalr	-900(ra) # 800045ac <holdingsleep>
    80003938:	cd19                	beqz	a0,80003956 <iunlock+0x3c>
    8000393a:	449c                	lw	a5,8(s1)
    8000393c:	00f05d63          	blez	a5,80003956 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003940:	854a                	mv	a0,s2
    80003942:	00001097          	auipc	ra,0x1
    80003946:	c26080e7          	jalr	-986(ra) # 80004568 <releasesleep>
}
    8000394a:	60e2                	ld	ra,24(sp)
    8000394c:	6442                	ld	s0,16(sp)
    8000394e:	64a2                	ld	s1,8(sp)
    80003950:	6902                	ld	s2,0(sp)
    80003952:	6105                	addi	sp,sp,32
    80003954:	8082                	ret
    panic("iunlock");
    80003956:	00005517          	auipc	a0,0x5
    8000395a:	cb250513          	addi	a0,a0,-846 # 80008608 <syscalls+0x1a8>
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	be0080e7          	jalr	-1056(ra) # 8000053e <panic>

0000000080003966 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003966:	7179                	addi	sp,sp,-48
    80003968:	f406                	sd	ra,40(sp)
    8000396a:	f022                	sd	s0,32(sp)
    8000396c:	ec26                	sd	s1,24(sp)
    8000396e:	e84a                	sd	s2,16(sp)
    80003970:	e44e                	sd	s3,8(sp)
    80003972:	e052                	sd	s4,0(sp)
    80003974:	1800                	addi	s0,sp,48
    80003976:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003978:	05050493          	addi	s1,a0,80
    8000397c:	08050913          	addi	s2,a0,128
    80003980:	a021                	j	80003988 <itrunc+0x22>
    80003982:	0491                	addi	s1,s1,4
    80003984:	01248d63          	beq	s1,s2,8000399e <itrunc+0x38>
    if(ip->addrs[i]){
    80003988:	408c                	lw	a1,0(s1)
    8000398a:	dde5                	beqz	a1,80003982 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000398c:	0009a503          	lw	a0,0(s3)
    80003990:	00000097          	auipc	ra,0x0
    80003994:	8f4080e7          	jalr	-1804(ra) # 80003284 <bfree>
      ip->addrs[i] = 0;
    80003998:	0004a023          	sw	zero,0(s1)
    8000399c:	b7dd                	j	80003982 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000399e:	0809a583          	lw	a1,128(s3)
    800039a2:	e185                	bnez	a1,800039c2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800039a4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800039a8:	854e                	mv	a0,s3
    800039aa:	00000097          	auipc	ra,0x0
    800039ae:	de4080e7          	jalr	-540(ra) # 8000378e <iupdate>
}
    800039b2:	70a2                	ld	ra,40(sp)
    800039b4:	7402                	ld	s0,32(sp)
    800039b6:	64e2                	ld	s1,24(sp)
    800039b8:	6942                	ld	s2,16(sp)
    800039ba:	69a2                	ld	s3,8(sp)
    800039bc:	6a02                	ld	s4,0(sp)
    800039be:	6145                	addi	sp,sp,48
    800039c0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800039c2:	0009a503          	lw	a0,0(s3)
    800039c6:	fffff097          	auipc	ra,0xfffff
    800039ca:	678080e7          	jalr	1656(ra) # 8000303e <bread>
    800039ce:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800039d0:	05850493          	addi	s1,a0,88
    800039d4:	45850913          	addi	s2,a0,1112
    800039d8:	a021                	j	800039e0 <itrunc+0x7a>
    800039da:	0491                	addi	s1,s1,4
    800039dc:	01248b63          	beq	s1,s2,800039f2 <itrunc+0x8c>
      if(a[j])
    800039e0:	408c                	lw	a1,0(s1)
    800039e2:	dde5                	beqz	a1,800039da <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800039e4:	0009a503          	lw	a0,0(s3)
    800039e8:	00000097          	auipc	ra,0x0
    800039ec:	89c080e7          	jalr	-1892(ra) # 80003284 <bfree>
    800039f0:	b7ed                	j	800039da <itrunc+0x74>
    brelse(bp);
    800039f2:	8552                	mv	a0,s4
    800039f4:	fffff097          	auipc	ra,0xfffff
    800039f8:	77a080e7          	jalr	1914(ra) # 8000316e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800039fc:	0809a583          	lw	a1,128(s3)
    80003a00:	0009a503          	lw	a0,0(s3)
    80003a04:	00000097          	auipc	ra,0x0
    80003a08:	880080e7          	jalr	-1920(ra) # 80003284 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003a0c:	0809a023          	sw	zero,128(s3)
    80003a10:	bf51                	j	800039a4 <itrunc+0x3e>

0000000080003a12 <iput>:
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	e04a                	sd	s2,0(sp)
    80003a1c:	1000                	addi	s0,sp,32
    80003a1e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a20:	0001c517          	auipc	a0,0x1c
    80003a24:	27850513          	addi	a0,a0,632 # 8001fc98 <itable>
    80003a28:	ffffd097          	auipc	ra,0xffffd
    80003a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a30:	4498                	lw	a4,8(s1)
    80003a32:	4785                	li	a5,1
    80003a34:	02f70363          	beq	a4,a5,80003a5a <iput+0x48>
  ip->ref--;
    80003a38:	449c                	lw	a5,8(s1)
    80003a3a:	37fd                	addiw	a5,a5,-1
    80003a3c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a3e:	0001c517          	auipc	a0,0x1c
    80003a42:	25a50513          	addi	a0,a0,602 # 8001fc98 <itable>
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	244080e7          	jalr	580(ra) # 80000c8a <release>
}
    80003a4e:	60e2                	ld	ra,24(sp)
    80003a50:	6442                	ld	s0,16(sp)
    80003a52:	64a2                	ld	s1,8(sp)
    80003a54:	6902                	ld	s2,0(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003a5a:	40bc                	lw	a5,64(s1)
    80003a5c:	dff1                	beqz	a5,80003a38 <iput+0x26>
    80003a5e:	04a49783          	lh	a5,74(s1)
    80003a62:	fbf9                	bnez	a5,80003a38 <iput+0x26>
    acquiresleep(&ip->lock);
    80003a64:	01048913          	addi	s2,s1,16
    80003a68:	854a                	mv	a0,s2
    80003a6a:	00001097          	auipc	ra,0x1
    80003a6e:	aa8080e7          	jalr	-1368(ra) # 80004512 <acquiresleep>
    release(&itable.lock);
    80003a72:	0001c517          	auipc	a0,0x1c
    80003a76:	22650513          	addi	a0,a0,550 # 8001fc98 <itable>
    80003a7a:	ffffd097          	auipc	ra,0xffffd
    80003a7e:	210080e7          	jalr	528(ra) # 80000c8a <release>
    itrunc(ip);
    80003a82:	8526                	mv	a0,s1
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	ee2080e7          	jalr	-286(ra) # 80003966 <itrunc>
    ip->type = 0;
    80003a8c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a90:	8526                	mv	a0,s1
    80003a92:	00000097          	auipc	ra,0x0
    80003a96:	cfc080e7          	jalr	-772(ra) # 8000378e <iupdate>
    ip->valid = 0;
    80003a9a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	00001097          	auipc	ra,0x1
    80003aa4:	ac8080e7          	jalr	-1336(ra) # 80004568 <releasesleep>
    acquire(&itable.lock);
    80003aa8:	0001c517          	auipc	a0,0x1c
    80003aac:	1f050513          	addi	a0,a0,496 # 8001fc98 <itable>
    80003ab0:	ffffd097          	auipc	ra,0xffffd
    80003ab4:	126080e7          	jalr	294(ra) # 80000bd6 <acquire>
    80003ab8:	b741                	j	80003a38 <iput+0x26>

0000000080003aba <iunlockput>:
{
    80003aba:	1101                	addi	sp,sp,-32
    80003abc:	ec06                	sd	ra,24(sp)
    80003abe:	e822                	sd	s0,16(sp)
    80003ac0:	e426                	sd	s1,8(sp)
    80003ac2:	1000                	addi	s0,sp,32
    80003ac4:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	e54080e7          	jalr	-428(ra) # 8000391a <iunlock>
  iput(ip);
    80003ace:	8526                	mv	a0,s1
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	f42080e7          	jalr	-190(ra) # 80003a12 <iput>
}
    80003ad8:	60e2                	ld	ra,24(sp)
    80003ada:	6442                	ld	s0,16(sp)
    80003adc:	64a2                	ld	s1,8(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003ae2:	1141                	addi	sp,sp,-16
    80003ae4:	e422                	sd	s0,8(sp)
    80003ae6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003ae8:	411c                	lw	a5,0(a0)
    80003aea:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003aec:	415c                	lw	a5,4(a0)
    80003aee:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003af0:	04451783          	lh	a5,68(a0)
    80003af4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003af8:	04a51783          	lh	a5,74(a0)
    80003afc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b00:	04c56783          	lwu	a5,76(a0)
    80003b04:	e99c                	sd	a5,16(a1)
}
    80003b06:	6422                	ld	s0,8(sp)
    80003b08:	0141                	addi	sp,sp,16
    80003b0a:	8082                	ret

0000000080003b0c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b0c:	457c                	lw	a5,76(a0)
    80003b0e:	0ed7e963          	bltu	a5,a3,80003c00 <readi+0xf4>
{
    80003b12:	7159                	addi	sp,sp,-112
    80003b14:	f486                	sd	ra,104(sp)
    80003b16:	f0a2                	sd	s0,96(sp)
    80003b18:	eca6                	sd	s1,88(sp)
    80003b1a:	e8ca                	sd	s2,80(sp)
    80003b1c:	e4ce                	sd	s3,72(sp)
    80003b1e:	e0d2                	sd	s4,64(sp)
    80003b20:	fc56                	sd	s5,56(sp)
    80003b22:	f85a                	sd	s6,48(sp)
    80003b24:	f45e                	sd	s7,40(sp)
    80003b26:	f062                	sd	s8,32(sp)
    80003b28:	ec66                	sd	s9,24(sp)
    80003b2a:	e86a                	sd	s10,16(sp)
    80003b2c:	e46e                	sd	s11,8(sp)
    80003b2e:	1880                	addi	s0,sp,112
    80003b30:	8b2a                	mv	s6,a0
    80003b32:	8bae                	mv	s7,a1
    80003b34:	8a32                	mv	s4,a2
    80003b36:	84b6                	mv	s1,a3
    80003b38:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003b3a:	9f35                	addw	a4,a4,a3
    return 0;
    80003b3c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003b3e:	0ad76063          	bltu	a4,a3,80003bde <readi+0xd2>
  if(off + n > ip->size)
    80003b42:	00e7f463          	bgeu	a5,a4,80003b4a <readi+0x3e>
    n = ip->size - off;
    80003b46:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b4a:	0a0a8963          	beqz	s5,80003bfc <readi+0xf0>
    80003b4e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b50:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b54:	5c7d                	li	s8,-1
    80003b56:	a82d                	j	80003b90 <readi+0x84>
    80003b58:	020d1d93          	slli	s11,s10,0x20
    80003b5c:	020ddd93          	srli	s11,s11,0x20
    80003b60:	05890793          	addi	a5,s2,88
    80003b64:	86ee                	mv	a3,s11
    80003b66:	963e                	add	a2,a2,a5
    80003b68:	85d2                	mv	a1,s4
    80003b6a:	855e                	mv	a0,s7
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	a7c080e7          	jalr	-1412(ra) # 800025e8 <either_copyout>
    80003b74:	05850d63          	beq	a0,s8,80003bce <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003b78:	854a                	mv	a0,s2
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	5f4080e7          	jalr	1524(ra) # 8000316e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b82:	013d09bb          	addw	s3,s10,s3
    80003b86:	009d04bb          	addw	s1,s10,s1
    80003b8a:	9a6e                	add	s4,s4,s11
    80003b8c:	0559f763          	bgeu	s3,s5,80003bda <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003b90:	00a4d59b          	srliw	a1,s1,0xa
    80003b94:	855a                	mv	a0,s6
    80003b96:	00000097          	auipc	ra,0x0
    80003b9a:	8a2080e7          	jalr	-1886(ra) # 80003438 <bmap>
    80003b9e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ba2:	cd85                	beqz	a1,80003bda <readi+0xce>
    bp = bread(ip->dev, addr);
    80003ba4:	000b2503          	lw	a0,0(s6)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	496080e7          	jalr	1174(ra) # 8000303e <bread>
    80003bb0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bb2:	3ff4f613          	andi	a2,s1,1023
    80003bb6:	40cc87bb          	subw	a5,s9,a2
    80003bba:	413a873b          	subw	a4,s5,s3
    80003bbe:	8d3e                	mv	s10,a5
    80003bc0:	2781                	sext.w	a5,a5
    80003bc2:	0007069b          	sext.w	a3,a4
    80003bc6:	f8f6f9e3          	bgeu	a3,a5,80003b58 <readi+0x4c>
    80003bca:	8d3a                	mv	s10,a4
    80003bcc:	b771                	j	80003b58 <readi+0x4c>
      brelse(bp);
    80003bce:	854a                	mv	a0,s2
    80003bd0:	fffff097          	auipc	ra,0xfffff
    80003bd4:	59e080e7          	jalr	1438(ra) # 8000316e <brelse>
      tot = -1;
    80003bd8:	59fd                	li	s3,-1
  }
  return tot;
    80003bda:	0009851b          	sext.w	a0,s3
}
    80003bde:	70a6                	ld	ra,104(sp)
    80003be0:	7406                	ld	s0,96(sp)
    80003be2:	64e6                	ld	s1,88(sp)
    80003be4:	6946                	ld	s2,80(sp)
    80003be6:	69a6                	ld	s3,72(sp)
    80003be8:	6a06                	ld	s4,64(sp)
    80003bea:	7ae2                	ld	s5,56(sp)
    80003bec:	7b42                	ld	s6,48(sp)
    80003bee:	7ba2                	ld	s7,40(sp)
    80003bf0:	7c02                	ld	s8,32(sp)
    80003bf2:	6ce2                	ld	s9,24(sp)
    80003bf4:	6d42                	ld	s10,16(sp)
    80003bf6:	6da2                	ld	s11,8(sp)
    80003bf8:	6165                	addi	sp,sp,112
    80003bfa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003bfc:	89d6                	mv	s3,s5
    80003bfe:	bff1                	j	80003bda <readi+0xce>
    return 0;
    80003c00:	4501                	li	a0,0
}
    80003c02:	8082                	ret

0000000080003c04 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c04:	457c                	lw	a5,76(a0)
    80003c06:	10d7e863          	bltu	a5,a3,80003d16 <writei+0x112>
{
    80003c0a:	7159                	addi	sp,sp,-112
    80003c0c:	f486                	sd	ra,104(sp)
    80003c0e:	f0a2                	sd	s0,96(sp)
    80003c10:	eca6                	sd	s1,88(sp)
    80003c12:	e8ca                	sd	s2,80(sp)
    80003c14:	e4ce                	sd	s3,72(sp)
    80003c16:	e0d2                	sd	s4,64(sp)
    80003c18:	fc56                	sd	s5,56(sp)
    80003c1a:	f85a                	sd	s6,48(sp)
    80003c1c:	f45e                	sd	s7,40(sp)
    80003c1e:	f062                	sd	s8,32(sp)
    80003c20:	ec66                	sd	s9,24(sp)
    80003c22:	e86a                	sd	s10,16(sp)
    80003c24:	e46e                	sd	s11,8(sp)
    80003c26:	1880                	addi	s0,sp,112
    80003c28:	8aaa                	mv	s5,a0
    80003c2a:	8bae                	mv	s7,a1
    80003c2c:	8a32                	mv	s4,a2
    80003c2e:	8936                	mv	s2,a3
    80003c30:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c32:	00e687bb          	addw	a5,a3,a4
    80003c36:	0ed7e263          	bltu	a5,a3,80003d1a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c3a:	00043737          	lui	a4,0x43
    80003c3e:	0ef76063          	bltu	a4,a5,80003d1e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c42:	0c0b0863          	beqz	s6,80003d12 <writei+0x10e>
    80003c46:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c48:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c4c:	5c7d                	li	s8,-1
    80003c4e:	a091                	j	80003c92 <writei+0x8e>
    80003c50:	020d1d93          	slli	s11,s10,0x20
    80003c54:	020ddd93          	srli	s11,s11,0x20
    80003c58:	05848793          	addi	a5,s1,88
    80003c5c:	86ee                	mv	a3,s11
    80003c5e:	8652                	mv	a2,s4
    80003c60:	85de                	mv	a1,s7
    80003c62:	953e                	add	a0,a0,a5
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	9da080e7          	jalr	-1574(ra) # 8000263e <either_copyin>
    80003c6c:	07850263          	beq	a0,s8,80003cd0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c70:	8526                	mv	a0,s1
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	780080e7          	jalr	1920(ra) # 800043f2 <log_write>
    brelse(bp);
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	4f2080e7          	jalr	1266(ra) # 8000316e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c84:	013d09bb          	addw	s3,s10,s3
    80003c88:	012d093b          	addw	s2,s10,s2
    80003c8c:	9a6e                	add	s4,s4,s11
    80003c8e:	0569f663          	bgeu	s3,s6,80003cda <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003c92:	00a9559b          	srliw	a1,s2,0xa
    80003c96:	8556                	mv	a0,s5
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	7a0080e7          	jalr	1952(ra) # 80003438 <bmap>
    80003ca0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003ca4:	c99d                	beqz	a1,80003cda <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003ca6:	000aa503          	lw	a0,0(s5)
    80003caa:	fffff097          	auipc	ra,0xfffff
    80003cae:	394080e7          	jalr	916(ra) # 8000303e <bread>
    80003cb2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cb4:	3ff97513          	andi	a0,s2,1023
    80003cb8:	40ac87bb          	subw	a5,s9,a0
    80003cbc:	413b073b          	subw	a4,s6,s3
    80003cc0:	8d3e                	mv	s10,a5
    80003cc2:	2781                	sext.w	a5,a5
    80003cc4:	0007069b          	sext.w	a3,a4
    80003cc8:	f8f6f4e3          	bgeu	a3,a5,80003c50 <writei+0x4c>
    80003ccc:	8d3a                	mv	s10,a4
    80003cce:	b749                	j	80003c50 <writei+0x4c>
      brelse(bp);
    80003cd0:	8526                	mv	a0,s1
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	49c080e7          	jalr	1180(ra) # 8000316e <brelse>
  }

  if(off > ip->size)
    80003cda:	04caa783          	lw	a5,76(s5)
    80003cde:	0127f463          	bgeu	a5,s2,80003ce6 <writei+0xe2>
    ip->size = off;
    80003ce2:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003ce6:	8556                	mv	a0,s5
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	aa6080e7          	jalr	-1370(ra) # 8000378e <iupdate>

  return tot;
    80003cf0:	0009851b          	sext.w	a0,s3
}
    80003cf4:	70a6                	ld	ra,104(sp)
    80003cf6:	7406                	ld	s0,96(sp)
    80003cf8:	64e6                	ld	s1,88(sp)
    80003cfa:	6946                	ld	s2,80(sp)
    80003cfc:	69a6                	ld	s3,72(sp)
    80003cfe:	6a06                	ld	s4,64(sp)
    80003d00:	7ae2                	ld	s5,56(sp)
    80003d02:	7b42                	ld	s6,48(sp)
    80003d04:	7ba2                	ld	s7,40(sp)
    80003d06:	7c02                	ld	s8,32(sp)
    80003d08:	6ce2                	ld	s9,24(sp)
    80003d0a:	6d42                	ld	s10,16(sp)
    80003d0c:	6da2                	ld	s11,8(sp)
    80003d0e:	6165                	addi	sp,sp,112
    80003d10:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003d12:	89da                	mv	s3,s6
    80003d14:	bfc9                	j	80003ce6 <writei+0xe2>
    return -1;
    80003d16:	557d                	li	a0,-1
}
    80003d18:	8082                	ret
    return -1;
    80003d1a:	557d                	li	a0,-1
    80003d1c:	bfe1                	j	80003cf4 <writei+0xf0>
    return -1;
    80003d1e:	557d                	li	a0,-1
    80003d20:	bfd1                	j	80003cf4 <writei+0xf0>

0000000080003d22 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d22:	1141                	addi	sp,sp,-16
    80003d24:	e406                	sd	ra,8(sp)
    80003d26:	e022                	sd	s0,0(sp)
    80003d28:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d2a:	4639                	li	a2,14
    80003d2c:	ffffd097          	auipc	ra,0xffffd
    80003d30:	076080e7          	jalr	118(ra) # 80000da2 <strncmp>
}
    80003d34:	60a2                	ld	ra,8(sp)
    80003d36:	6402                	ld	s0,0(sp)
    80003d38:	0141                	addi	sp,sp,16
    80003d3a:	8082                	ret

0000000080003d3c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d3c:	7139                	addi	sp,sp,-64
    80003d3e:	fc06                	sd	ra,56(sp)
    80003d40:	f822                	sd	s0,48(sp)
    80003d42:	f426                	sd	s1,40(sp)
    80003d44:	f04a                	sd	s2,32(sp)
    80003d46:	ec4e                	sd	s3,24(sp)
    80003d48:	e852                	sd	s4,16(sp)
    80003d4a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d4c:	04451703          	lh	a4,68(a0)
    80003d50:	4785                	li	a5,1
    80003d52:	00f71a63          	bne	a4,a5,80003d66 <dirlookup+0x2a>
    80003d56:	892a                	mv	s2,a0
    80003d58:	89ae                	mv	s3,a1
    80003d5a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d5c:	457c                	lw	a5,76(a0)
    80003d5e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d60:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d62:	e79d                	bnez	a5,80003d90 <dirlookup+0x54>
    80003d64:	a8a5                	j	80003ddc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d66:	00005517          	auipc	a0,0x5
    80003d6a:	8aa50513          	addi	a0,a0,-1878 # 80008610 <syscalls+0x1b0>
    80003d6e:	ffffc097          	auipc	ra,0xffffc
    80003d72:	7d0080e7          	jalr	2000(ra) # 8000053e <panic>
      panic("dirlookup read");
    80003d76:	00005517          	auipc	a0,0x5
    80003d7a:	8b250513          	addi	a0,a0,-1870 # 80008628 <syscalls+0x1c8>
    80003d7e:	ffffc097          	auipc	ra,0xffffc
    80003d82:	7c0080e7          	jalr	1984(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d86:	24c1                	addiw	s1,s1,16
    80003d88:	04c92783          	lw	a5,76(s2)
    80003d8c:	04f4f763          	bgeu	s1,a5,80003dda <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d90:	4741                	li	a4,16
    80003d92:	86a6                	mv	a3,s1
    80003d94:	fc040613          	addi	a2,s0,-64
    80003d98:	4581                	li	a1,0
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	d70080e7          	jalr	-656(ra) # 80003b0c <readi>
    80003da4:	47c1                	li	a5,16
    80003da6:	fcf518e3          	bne	a0,a5,80003d76 <dirlookup+0x3a>
    if(de.inum == 0)
    80003daa:	fc045783          	lhu	a5,-64(s0)
    80003dae:	dfe1                	beqz	a5,80003d86 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003db0:	fc240593          	addi	a1,s0,-62
    80003db4:	854e                	mv	a0,s3
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	f6c080e7          	jalr	-148(ra) # 80003d22 <namecmp>
    80003dbe:	f561                	bnez	a0,80003d86 <dirlookup+0x4a>
      if(poff)
    80003dc0:	000a0463          	beqz	s4,80003dc8 <dirlookup+0x8c>
        *poff = off;
    80003dc4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003dc8:	fc045583          	lhu	a1,-64(s0)
    80003dcc:	00092503          	lw	a0,0(s2)
    80003dd0:	fffff097          	auipc	ra,0xfffff
    80003dd4:	750080e7          	jalr	1872(ra) # 80003520 <iget>
    80003dd8:	a011                	j	80003ddc <dirlookup+0xa0>
  return 0;
    80003dda:	4501                	li	a0,0
}
    80003ddc:	70e2                	ld	ra,56(sp)
    80003dde:	7442                	ld	s0,48(sp)
    80003de0:	74a2                	ld	s1,40(sp)
    80003de2:	7902                	ld	s2,32(sp)
    80003de4:	69e2                	ld	s3,24(sp)
    80003de6:	6a42                	ld	s4,16(sp)
    80003de8:	6121                	addi	sp,sp,64
    80003dea:	8082                	ret

0000000080003dec <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003dec:	711d                	addi	sp,sp,-96
    80003dee:	ec86                	sd	ra,88(sp)
    80003df0:	e8a2                	sd	s0,80(sp)
    80003df2:	e4a6                	sd	s1,72(sp)
    80003df4:	e0ca                	sd	s2,64(sp)
    80003df6:	fc4e                	sd	s3,56(sp)
    80003df8:	f852                	sd	s4,48(sp)
    80003dfa:	f456                	sd	s5,40(sp)
    80003dfc:	f05a                	sd	s6,32(sp)
    80003dfe:	ec5e                	sd	s7,24(sp)
    80003e00:	e862                	sd	s8,16(sp)
    80003e02:	e466                	sd	s9,8(sp)
    80003e04:	1080                	addi	s0,sp,96
    80003e06:	84aa                	mv	s1,a0
    80003e08:	8aae                	mv	s5,a1
    80003e0a:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e0c:	00054703          	lbu	a4,0(a0)
    80003e10:	02f00793          	li	a5,47
    80003e14:	02f70363          	beq	a4,a5,80003e3a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e18:	ffffe097          	auipc	ra,0xffffe
    80003e1c:	b94080e7          	jalr	-1132(ra) # 800019ac <myproc>
    80003e20:	17853503          	ld	a0,376(a0)
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	9f6080e7          	jalr	-1546(ra) # 8000381a <idup>
    80003e2c:	89aa                	mv	s3,a0
  while(*path == '/')
    80003e2e:	02f00913          	li	s2,47
  len = path - s;
    80003e32:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003e34:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e36:	4b85                	li	s7,1
    80003e38:	a865                	j	80003ef0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003e3a:	4585                	li	a1,1
    80003e3c:	4505                	li	a0,1
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	6e2080e7          	jalr	1762(ra) # 80003520 <iget>
    80003e46:	89aa                	mv	s3,a0
    80003e48:	b7dd                	j	80003e2e <namex+0x42>
      iunlockput(ip);
    80003e4a:	854e                	mv	a0,s3
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c6e080e7          	jalr	-914(ra) # 80003aba <iunlockput>
      return 0;
    80003e54:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e56:	854e                	mv	a0,s3
    80003e58:	60e6                	ld	ra,88(sp)
    80003e5a:	6446                	ld	s0,80(sp)
    80003e5c:	64a6                	ld	s1,72(sp)
    80003e5e:	6906                	ld	s2,64(sp)
    80003e60:	79e2                	ld	s3,56(sp)
    80003e62:	7a42                	ld	s4,48(sp)
    80003e64:	7aa2                	ld	s5,40(sp)
    80003e66:	7b02                	ld	s6,32(sp)
    80003e68:	6be2                	ld	s7,24(sp)
    80003e6a:	6c42                	ld	s8,16(sp)
    80003e6c:	6ca2                	ld	s9,8(sp)
    80003e6e:	6125                	addi	sp,sp,96
    80003e70:	8082                	ret
      iunlock(ip);
    80003e72:	854e                	mv	a0,s3
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	aa6080e7          	jalr	-1370(ra) # 8000391a <iunlock>
      return ip;
    80003e7c:	bfe9                	j	80003e56 <namex+0x6a>
      iunlockput(ip);
    80003e7e:	854e                	mv	a0,s3
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	c3a080e7          	jalr	-966(ra) # 80003aba <iunlockput>
      return 0;
    80003e88:	89e6                	mv	s3,s9
    80003e8a:	b7f1                	j	80003e56 <namex+0x6a>
  len = path - s;
    80003e8c:	40b48633          	sub	a2,s1,a1
    80003e90:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003e94:	099c5463          	bge	s8,s9,80003f1c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003e98:	4639                	li	a2,14
    80003e9a:	8552                	mv	a0,s4
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	e92080e7          	jalr	-366(ra) # 80000d2e <memmove>
  while(*path == '/')
    80003ea4:	0004c783          	lbu	a5,0(s1)
    80003ea8:	01279763          	bne	a5,s2,80003eb6 <namex+0xca>
    path++;
    80003eac:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003eae:	0004c783          	lbu	a5,0(s1)
    80003eb2:	ff278de3          	beq	a5,s2,80003eac <namex+0xc0>
    ilock(ip);
    80003eb6:	854e                	mv	a0,s3
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	9a0080e7          	jalr	-1632(ra) # 80003858 <ilock>
    if(ip->type != T_DIR){
    80003ec0:	04499783          	lh	a5,68(s3)
    80003ec4:	f97793e3          	bne	a5,s7,80003e4a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ec8:	000a8563          	beqz	s5,80003ed2 <namex+0xe6>
    80003ecc:	0004c783          	lbu	a5,0(s1)
    80003ed0:	d3cd                	beqz	a5,80003e72 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ed2:	865a                	mv	a2,s6
    80003ed4:	85d2                	mv	a1,s4
    80003ed6:	854e                	mv	a0,s3
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	e64080e7          	jalr	-412(ra) # 80003d3c <dirlookup>
    80003ee0:	8caa                	mv	s9,a0
    80003ee2:	dd51                	beqz	a0,80003e7e <namex+0x92>
    iunlockput(ip);
    80003ee4:	854e                	mv	a0,s3
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	bd4080e7          	jalr	-1068(ra) # 80003aba <iunlockput>
    ip = next;
    80003eee:	89e6                	mv	s3,s9
  while(*path == '/')
    80003ef0:	0004c783          	lbu	a5,0(s1)
    80003ef4:	05279763          	bne	a5,s2,80003f42 <namex+0x156>
    path++;
    80003ef8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003efa:	0004c783          	lbu	a5,0(s1)
    80003efe:	ff278de3          	beq	a5,s2,80003ef8 <namex+0x10c>
  if(*path == 0)
    80003f02:	c79d                	beqz	a5,80003f30 <namex+0x144>
    path++;
    80003f04:	85a6                	mv	a1,s1
  len = path - s;
    80003f06:	8cda                	mv	s9,s6
    80003f08:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003f0a:	01278963          	beq	a5,s2,80003f1c <namex+0x130>
    80003f0e:	dfbd                	beqz	a5,80003e8c <namex+0xa0>
    path++;
    80003f10:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003f12:	0004c783          	lbu	a5,0(s1)
    80003f16:	ff279ce3          	bne	a5,s2,80003f0e <namex+0x122>
    80003f1a:	bf8d                	j	80003e8c <namex+0xa0>
    memmove(name, s, len);
    80003f1c:	2601                	sext.w	a2,a2
    80003f1e:	8552                	mv	a0,s4
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	e0e080e7          	jalr	-498(ra) # 80000d2e <memmove>
    name[len] = 0;
    80003f28:	9cd2                	add	s9,s9,s4
    80003f2a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003f2e:	bf9d                	j	80003ea4 <namex+0xb8>
  if(nameiparent){
    80003f30:	f20a83e3          	beqz	s5,80003e56 <namex+0x6a>
    iput(ip);
    80003f34:	854e                	mv	a0,s3
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	adc080e7          	jalr	-1316(ra) # 80003a12 <iput>
    return 0;
    80003f3e:	4981                	li	s3,0
    80003f40:	bf19                	j	80003e56 <namex+0x6a>
  if(*path == 0)
    80003f42:	d7fd                	beqz	a5,80003f30 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003f44:	0004c783          	lbu	a5,0(s1)
    80003f48:	85a6                	mv	a1,s1
    80003f4a:	b7d1                	j	80003f0e <namex+0x122>

0000000080003f4c <dirlink>:
{
    80003f4c:	7139                	addi	sp,sp,-64
    80003f4e:	fc06                	sd	ra,56(sp)
    80003f50:	f822                	sd	s0,48(sp)
    80003f52:	f426                	sd	s1,40(sp)
    80003f54:	f04a                	sd	s2,32(sp)
    80003f56:	ec4e                	sd	s3,24(sp)
    80003f58:	e852                	sd	s4,16(sp)
    80003f5a:	0080                	addi	s0,sp,64
    80003f5c:	892a                	mv	s2,a0
    80003f5e:	8a2e                	mv	s4,a1
    80003f60:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f62:	4601                	li	a2,0
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	dd8080e7          	jalr	-552(ra) # 80003d3c <dirlookup>
    80003f6c:	e93d                	bnez	a0,80003fe2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f6e:	04c92483          	lw	s1,76(s2)
    80003f72:	c49d                	beqz	s1,80003fa0 <dirlink+0x54>
    80003f74:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f76:	4741                	li	a4,16
    80003f78:	86a6                	mv	a3,s1
    80003f7a:	fc040613          	addi	a2,s0,-64
    80003f7e:	4581                	li	a1,0
    80003f80:	854a                	mv	a0,s2
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	b8a080e7          	jalr	-1142(ra) # 80003b0c <readi>
    80003f8a:	47c1                	li	a5,16
    80003f8c:	06f51163          	bne	a0,a5,80003fee <dirlink+0xa2>
    if(de.inum == 0)
    80003f90:	fc045783          	lhu	a5,-64(s0)
    80003f94:	c791                	beqz	a5,80003fa0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f96:	24c1                	addiw	s1,s1,16
    80003f98:	04c92783          	lw	a5,76(s2)
    80003f9c:	fcf4ede3          	bltu	s1,a5,80003f76 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003fa0:	4639                	li	a2,14
    80003fa2:	85d2                	mv	a1,s4
    80003fa4:	fc240513          	addi	a0,s0,-62
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	e36080e7          	jalr	-458(ra) # 80000dde <strncpy>
  de.inum = inum;
    80003fb0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fb4:	4741                	li	a4,16
    80003fb6:	86a6                	mv	a3,s1
    80003fb8:	fc040613          	addi	a2,s0,-64
    80003fbc:	4581                	li	a1,0
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	c44080e7          	jalr	-956(ra) # 80003c04 <writei>
    80003fc8:	1541                	addi	a0,a0,-16
    80003fca:	00a03533          	snez	a0,a0
    80003fce:	40a00533          	neg	a0,a0
}
    80003fd2:	70e2                	ld	ra,56(sp)
    80003fd4:	7442                	ld	s0,48(sp)
    80003fd6:	74a2                	ld	s1,40(sp)
    80003fd8:	7902                	ld	s2,32(sp)
    80003fda:	69e2                	ld	s3,24(sp)
    80003fdc:	6a42                	ld	s4,16(sp)
    80003fde:	6121                	addi	sp,sp,64
    80003fe0:	8082                	ret
    iput(ip);
    80003fe2:	00000097          	auipc	ra,0x0
    80003fe6:	a30080e7          	jalr	-1488(ra) # 80003a12 <iput>
    return -1;
    80003fea:	557d                	li	a0,-1
    80003fec:	b7dd                	j	80003fd2 <dirlink+0x86>
      panic("dirlink read");
    80003fee:	00004517          	auipc	a0,0x4
    80003ff2:	64a50513          	addi	a0,a0,1610 # 80008638 <syscalls+0x1d8>
    80003ff6:	ffffc097          	auipc	ra,0xffffc
    80003ffa:	548080e7          	jalr	1352(ra) # 8000053e <panic>

0000000080003ffe <namei>:

struct inode*
namei(char *path)
{
    80003ffe:	1101                	addi	sp,sp,-32
    80004000:	ec06                	sd	ra,24(sp)
    80004002:	e822                	sd	s0,16(sp)
    80004004:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004006:	fe040613          	addi	a2,s0,-32
    8000400a:	4581                	li	a1,0
    8000400c:	00000097          	auipc	ra,0x0
    80004010:	de0080e7          	jalr	-544(ra) # 80003dec <namex>
}
    80004014:	60e2                	ld	ra,24(sp)
    80004016:	6442                	ld	s0,16(sp)
    80004018:	6105                	addi	sp,sp,32
    8000401a:	8082                	ret

000000008000401c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000401c:	1141                	addi	sp,sp,-16
    8000401e:	e406                	sd	ra,8(sp)
    80004020:	e022                	sd	s0,0(sp)
    80004022:	0800                	addi	s0,sp,16
    80004024:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004026:	4585                	li	a1,1
    80004028:	00000097          	auipc	ra,0x0
    8000402c:	dc4080e7          	jalr	-572(ra) # 80003dec <namex>
}
    80004030:	60a2                	ld	ra,8(sp)
    80004032:	6402                	ld	s0,0(sp)
    80004034:	0141                	addi	sp,sp,16
    80004036:	8082                	ret

0000000080004038 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004038:	1101                	addi	sp,sp,-32
    8000403a:	ec06                	sd	ra,24(sp)
    8000403c:	e822                	sd	s0,16(sp)
    8000403e:	e426                	sd	s1,8(sp)
    80004040:	e04a                	sd	s2,0(sp)
    80004042:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004044:	0001d917          	auipc	s2,0x1d
    80004048:	6fc90913          	addi	s2,s2,1788 # 80021740 <log>
    8000404c:	01892583          	lw	a1,24(s2)
    80004050:	02892503          	lw	a0,40(s2)
    80004054:	fffff097          	auipc	ra,0xfffff
    80004058:	fea080e7          	jalr	-22(ra) # 8000303e <bread>
    8000405c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000405e:	02c92683          	lw	a3,44(s2)
    80004062:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004064:	02d05763          	blez	a3,80004092 <write_head+0x5a>
    80004068:	0001d797          	auipc	a5,0x1d
    8000406c:	70878793          	addi	a5,a5,1800 # 80021770 <log+0x30>
    80004070:	05c50713          	addi	a4,a0,92
    80004074:	36fd                	addiw	a3,a3,-1
    80004076:	1682                	slli	a3,a3,0x20
    80004078:	9281                	srli	a3,a3,0x20
    8000407a:	068a                	slli	a3,a3,0x2
    8000407c:	0001d617          	auipc	a2,0x1d
    80004080:	6f860613          	addi	a2,a2,1784 # 80021774 <log+0x34>
    80004084:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80004086:	4390                	lw	a2,0(a5)
    80004088:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000408a:	0791                	addi	a5,a5,4
    8000408c:	0711                	addi	a4,a4,4
    8000408e:	fed79ce3          	bne	a5,a3,80004086 <write_head+0x4e>
  }
  bwrite(buf);
    80004092:	8526                	mv	a0,s1
    80004094:	fffff097          	auipc	ra,0xfffff
    80004098:	09c080e7          	jalr	156(ra) # 80003130 <bwrite>
  brelse(buf);
    8000409c:	8526                	mv	a0,s1
    8000409e:	fffff097          	auipc	ra,0xfffff
    800040a2:	0d0080e7          	jalr	208(ra) # 8000316e <brelse>
}
    800040a6:	60e2                	ld	ra,24(sp)
    800040a8:	6442                	ld	s0,16(sp)
    800040aa:	64a2                	ld	s1,8(sp)
    800040ac:	6902                	ld	s2,0(sp)
    800040ae:	6105                	addi	sp,sp,32
    800040b0:	8082                	ret

00000000800040b2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800040b2:	0001d797          	auipc	a5,0x1d
    800040b6:	6ba7a783          	lw	a5,1722(a5) # 8002176c <log+0x2c>
    800040ba:	0af05d63          	blez	a5,80004174 <install_trans+0xc2>
{
    800040be:	7139                	addi	sp,sp,-64
    800040c0:	fc06                	sd	ra,56(sp)
    800040c2:	f822                	sd	s0,48(sp)
    800040c4:	f426                	sd	s1,40(sp)
    800040c6:	f04a                	sd	s2,32(sp)
    800040c8:	ec4e                	sd	s3,24(sp)
    800040ca:	e852                	sd	s4,16(sp)
    800040cc:	e456                	sd	s5,8(sp)
    800040ce:	e05a                	sd	s6,0(sp)
    800040d0:	0080                	addi	s0,sp,64
    800040d2:	8b2a                	mv	s6,a0
    800040d4:	0001da97          	auipc	s5,0x1d
    800040d8:	69ca8a93          	addi	s5,s5,1692 # 80021770 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040dc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800040de:	0001d997          	auipc	s3,0x1d
    800040e2:	66298993          	addi	s3,s3,1634 # 80021740 <log>
    800040e6:	a00d                	j	80004108 <install_trans+0x56>
    brelse(lbuf);
    800040e8:	854a                	mv	a0,s2
    800040ea:	fffff097          	auipc	ra,0xfffff
    800040ee:	084080e7          	jalr	132(ra) # 8000316e <brelse>
    brelse(dbuf);
    800040f2:	8526                	mv	a0,s1
    800040f4:	fffff097          	auipc	ra,0xfffff
    800040f8:	07a080e7          	jalr	122(ra) # 8000316e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800040fc:	2a05                	addiw	s4,s4,1
    800040fe:	0a91                	addi	s5,s5,4
    80004100:	02c9a783          	lw	a5,44(s3)
    80004104:	04fa5e63          	bge	s4,a5,80004160 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004108:	0189a583          	lw	a1,24(s3)
    8000410c:	014585bb          	addw	a1,a1,s4
    80004110:	2585                	addiw	a1,a1,1
    80004112:	0289a503          	lw	a0,40(s3)
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	f28080e7          	jalr	-216(ra) # 8000303e <bread>
    8000411e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004120:	000aa583          	lw	a1,0(s5)
    80004124:	0289a503          	lw	a0,40(s3)
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	f16080e7          	jalr	-234(ra) # 8000303e <bread>
    80004130:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004132:	40000613          	li	a2,1024
    80004136:	05890593          	addi	a1,s2,88
    8000413a:	05850513          	addi	a0,a0,88
    8000413e:	ffffd097          	auipc	ra,0xffffd
    80004142:	bf0080e7          	jalr	-1040(ra) # 80000d2e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004146:	8526                	mv	a0,s1
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	fe8080e7          	jalr	-24(ra) # 80003130 <bwrite>
    if(recovering == 0)
    80004150:	f80b1ce3          	bnez	s6,800040e8 <install_trans+0x36>
      bunpin(dbuf);
    80004154:	8526                	mv	a0,s1
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	0f2080e7          	jalr	242(ra) # 80003248 <bunpin>
    8000415e:	b769                	j	800040e8 <install_trans+0x36>
}
    80004160:	70e2                	ld	ra,56(sp)
    80004162:	7442                	ld	s0,48(sp)
    80004164:	74a2                	ld	s1,40(sp)
    80004166:	7902                	ld	s2,32(sp)
    80004168:	69e2                	ld	s3,24(sp)
    8000416a:	6a42                	ld	s4,16(sp)
    8000416c:	6aa2                	ld	s5,8(sp)
    8000416e:	6b02                	ld	s6,0(sp)
    80004170:	6121                	addi	sp,sp,64
    80004172:	8082                	ret
    80004174:	8082                	ret

0000000080004176 <initlog>:
{
    80004176:	7179                	addi	sp,sp,-48
    80004178:	f406                	sd	ra,40(sp)
    8000417a:	f022                	sd	s0,32(sp)
    8000417c:	ec26                	sd	s1,24(sp)
    8000417e:	e84a                	sd	s2,16(sp)
    80004180:	e44e                	sd	s3,8(sp)
    80004182:	1800                	addi	s0,sp,48
    80004184:	892a                	mv	s2,a0
    80004186:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004188:	0001d497          	auipc	s1,0x1d
    8000418c:	5b848493          	addi	s1,s1,1464 # 80021740 <log>
    80004190:	00004597          	auipc	a1,0x4
    80004194:	4b858593          	addi	a1,a1,1208 # 80008648 <syscalls+0x1e8>
    80004198:	8526                	mv	a0,s1
    8000419a:	ffffd097          	auipc	ra,0xffffd
    8000419e:	9ac080e7          	jalr	-1620(ra) # 80000b46 <initlock>
  log.start = sb->logstart;
    800041a2:	0149a583          	lw	a1,20(s3)
    800041a6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800041a8:	0109a783          	lw	a5,16(s3)
    800041ac:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800041ae:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800041b2:	854a                	mv	a0,s2
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	e8a080e7          	jalr	-374(ra) # 8000303e <bread>
  log.lh.n = lh->n;
    800041bc:	4d34                	lw	a3,88(a0)
    800041be:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800041c0:	02d05563          	blez	a3,800041ea <initlog+0x74>
    800041c4:	05c50793          	addi	a5,a0,92
    800041c8:	0001d717          	auipc	a4,0x1d
    800041cc:	5a870713          	addi	a4,a4,1448 # 80021770 <log+0x30>
    800041d0:	36fd                	addiw	a3,a3,-1
    800041d2:	1682                	slli	a3,a3,0x20
    800041d4:	9281                	srli	a3,a3,0x20
    800041d6:	068a                	slli	a3,a3,0x2
    800041d8:	06050613          	addi	a2,a0,96
    800041dc:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800041de:	4390                	lw	a2,0(a5)
    800041e0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800041e2:	0791                	addi	a5,a5,4
    800041e4:	0711                	addi	a4,a4,4
    800041e6:	fed79ce3          	bne	a5,a3,800041de <initlog+0x68>
  brelse(buf);
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	f84080e7          	jalr	-124(ra) # 8000316e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800041f2:	4505                	li	a0,1
    800041f4:	00000097          	auipc	ra,0x0
    800041f8:	ebe080e7          	jalr	-322(ra) # 800040b2 <install_trans>
  log.lh.n = 0;
    800041fc:	0001d797          	auipc	a5,0x1d
    80004200:	5607a823          	sw	zero,1392(a5) # 8002176c <log+0x2c>
  write_head(); // clear the log
    80004204:	00000097          	auipc	ra,0x0
    80004208:	e34080e7          	jalr	-460(ra) # 80004038 <write_head>
}
    8000420c:	70a2                	ld	ra,40(sp)
    8000420e:	7402                	ld	s0,32(sp)
    80004210:	64e2                	ld	s1,24(sp)
    80004212:	6942                	ld	s2,16(sp)
    80004214:	69a2                	ld	s3,8(sp)
    80004216:	6145                	addi	sp,sp,48
    80004218:	8082                	ret

000000008000421a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000421a:	1101                	addi	sp,sp,-32
    8000421c:	ec06                	sd	ra,24(sp)
    8000421e:	e822                	sd	s0,16(sp)
    80004220:	e426                	sd	s1,8(sp)
    80004222:	e04a                	sd	s2,0(sp)
    80004224:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004226:	0001d517          	auipc	a0,0x1d
    8000422a:	51a50513          	addi	a0,a0,1306 # 80021740 <log>
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	9a8080e7          	jalr	-1624(ra) # 80000bd6 <acquire>
  while(1){
    if(log.committing){
    80004236:	0001d497          	auipc	s1,0x1d
    8000423a:	50a48493          	addi	s1,s1,1290 # 80021740 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000423e:	4979                	li	s2,30
    80004240:	a039                	j	8000424e <begin_op+0x34>
      sleep(&log, &log.lock);
    80004242:	85a6                	mv	a1,s1
    80004244:	8526                	mv	a0,s1
    80004246:	ffffe097          	auipc	ra,0xffffe
    8000424a:	ed8080e7          	jalr	-296(ra) # 8000211e <sleep>
    if(log.committing){
    8000424e:	50dc                	lw	a5,36(s1)
    80004250:	fbed                	bnez	a5,80004242 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004252:	509c                	lw	a5,32(s1)
    80004254:	0017871b          	addiw	a4,a5,1
    80004258:	0007069b          	sext.w	a3,a4
    8000425c:	0027179b          	slliw	a5,a4,0x2
    80004260:	9fb9                	addw	a5,a5,a4
    80004262:	0017979b          	slliw	a5,a5,0x1
    80004266:	54d8                	lw	a4,44(s1)
    80004268:	9fb9                	addw	a5,a5,a4
    8000426a:	00f95963          	bge	s2,a5,8000427c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000426e:	85a6                	mv	a1,s1
    80004270:	8526                	mv	a0,s1
    80004272:	ffffe097          	auipc	ra,0xffffe
    80004276:	eac080e7          	jalr	-340(ra) # 8000211e <sleep>
    8000427a:	bfd1                	j	8000424e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000427c:	0001d517          	auipc	a0,0x1d
    80004280:	4c450513          	addi	a0,a0,1220 # 80021740 <log>
    80004284:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004286:	ffffd097          	auipc	ra,0xffffd
    8000428a:	a04080e7          	jalr	-1532(ra) # 80000c8a <release>
      break;
    }
  }
}
    8000428e:	60e2                	ld	ra,24(sp)
    80004290:	6442                	ld	s0,16(sp)
    80004292:	64a2                	ld	s1,8(sp)
    80004294:	6902                	ld	s2,0(sp)
    80004296:	6105                	addi	sp,sp,32
    80004298:	8082                	ret

000000008000429a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000429a:	7139                	addi	sp,sp,-64
    8000429c:	fc06                	sd	ra,56(sp)
    8000429e:	f822                	sd	s0,48(sp)
    800042a0:	f426                	sd	s1,40(sp)
    800042a2:	f04a                	sd	s2,32(sp)
    800042a4:	ec4e                	sd	s3,24(sp)
    800042a6:	e852                	sd	s4,16(sp)
    800042a8:	e456                	sd	s5,8(sp)
    800042aa:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800042ac:	0001d497          	auipc	s1,0x1d
    800042b0:	49448493          	addi	s1,s1,1172 # 80021740 <log>
    800042b4:	8526                	mv	a0,s1
    800042b6:	ffffd097          	auipc	ra,0xffffd
    800042ba:	920080e7          	jalr	-1760(ra) # 80000bd6 <acquire>
  log.outstanding -= 1;
    800042be:	509c                	lw	a5,32(s1)
    800042c0:	37fd                	addiw	a5,a5,-1
    800042c2:	0007891b          	sext.w	s2,a5
    800042c6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800042c8:	50dc                	lw	a5,36(s1)
    800042ca:	e7b9                	bnez	a5,80004318 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800042cc:	04091e63          	bnez	s2,80004328 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800042d0:	0001d497          	auipc	s1,0x1d
    800042d4:	47048493          	addi	s1,s1,1136 # 80021740 <log>
    800042d8:	4785                	li	a5,1
    800042da:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800042dc:	8526                	mv	a0,s1
    800042de:	ffffd097          	auipc	ra,0xffffd
    800042e2:	9ac080e7          	jalr	-1620(ra) # 80000c8a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800042e6:	54dc                	lw	a5,44(s1)
    800042e8:	06f04763          	bgtz	a5,80004356 <end_op+0xbc>
    acquire(&log.lock);
    800042ec:	0001d497          	auipc	s1,0x1d
    800042f0:	45448493          	addi	s1,s1,1108 # 80021740 <log>
    800042f4:	8526                	mv	a0,s1
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	8e0080e7          	jalr	-1824(ra) # 80000bd6 <acquire>
    log.committing = 0;
    800042fe:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004302:	8526                	mv	a0,s1
    80004304:	ffffe097          	auipc	ra,0xffffe
    80004308:	e7e080e7          	jalr	-386(ra) # 80002182 <wakeup>
    release(&log.lock);
    8000430c:	8526                	mv	a0,s1
    8000430e:	ffffd097          	auipc	ra,0xffffd
    80004312:	97c080e7          	jalr	-1668(ra) # 80000c8a <release>
}
    80004316:	a03d                	j	80004344 <end_op+0xaa>
    panic("log.committing");
    80004318:	00004517          	auipc	a0,0x4
    8000431c:	33850513          	addi	a0,a0,824 # 80008650 <syscalls+0x1f0>
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	21e080e7          	jalr	542(ra) # 8000053e <panic>
    wakeup(&log);
    80004328:	0001d497          	auipc	s1,0x1d
    8000432c:	41848493          	addi	s1,s1,1048 # 80021740 <log>
    80004330:	8526                	mv	a0,s1
    80004332:	ffffe097          	auipc	ra,0xffffe
    80004336:	e50080e7          	jalr	-432(ra) # 80002182 <wakeup>
  release(&log.lock);
    8000433a:	8526                	mv	a0,s1
    8000433c:	ffffd097          	auipc	ra,0xffffd
    80004340:	94e080e7          	jalr	-1714(ra) # 80000c8a <release>
}
    80004344:	70e2                	ld	ra,56(sp)
    80004346:	7442                	ld	s0,48(sp)
    80004348:	74a2                	ld	s1,40(sp)
    8000434a:	7902                	ld	s2,32(sp)
    8000434c:	69e2                	ld	s3,24(sp)
    8000434e:	6a42                	ld	s4,16(sp)
    80004350:	6aa2                	ld	s5,8(sp)
    80004352:	6121                	addi	sp,sp,64
    80004354:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004356:	0001da97          	auipc	s5,0x1d
    8000435a:	41aa8a93          	addi	s5,s5,1050 # 80021770 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000435e:	0001da17          	auipc	s4,0x1d
    80004362:	3e2a0a13          	addi	s4,s4,994 # 80021740 <log>
    80004366:	018a2583          	lw	a1,24(s4)
    8000436a:	012585bb          	addw	a1,a1,s2
    8000436e:	2585                	addiw	a1,a1,1
    80004370:	028a2503          	lw	a0,40(s4)
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	cca080e7          	jalr	-822(ra) # 8000303e <bread>
    8000437c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000437e:	000aa583          	lw	a1,0(s5)
    80004382:	028a2503          	lw	a0,40(s4)
    80004386:	fffff097          	auipc	ra,0xfffff
    8000438a:	cb8080e7          	jalr	-840(ra) # 8000303e <bread>
    8000438e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004390:	40000613          	li	a2,1024
    80004394:	05850593          	addi	a1,a0,88
    80004398:	05848513          	addi	a0,s1,88
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	992080e7          	jalr	-1646(ra) # 80000d2e <memmove>
    bwrite(to);  // write the log
    800043a4:	8526                	mv	a0,s1
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	d8a080e7          	jalr	-630(ra) # 80003130 <bwrite>
    brelse(from);
    800043ae:	854e                	mv	a0,s3
    800043b0:	fffff097          	auipc	ra,0xfffff
    800043b4:	dbe080e7          	jalr	-578(ra) # 8000316e <brelse>
    brelse(to);
    800043b8:	8526                	mv	a0,s1
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	db4080e7          	jalr	-588(ra) # 8000316e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043c2:	2905                	addiw	s2,s2,1
    800043c4:	0a91                	addi	s5,s5,4
    800043c6:	02ca2783          	lw	a5,44(s4)
    800043ca:	f8f94ee3          	blt	s2,a5,80004366 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800043ce:	00000097          	auipc	ra,0x0
    800043d2:	c6a080e7          	jalr	-918(ra) # 80004038 <write_head>
    install_trans(0); // Now install writes to home locations
    800043d6:	4501                	li	a0,0
    800043d8:	00000097          	auipc	ra,0x0
    800043dc:	cda080e7          	jalr	-806(ra) # 800040b2 <install_trans>
    log.lh.n = 0;
    800043e0:	0001d797          	auipc	a5,0x1d
    800043e4:	3807a623          	sw	zero,908(a5) # 8002176c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800043e8:	00000097          	auipc	ra,0x0
    800043ec:	c50080e7          	jalr	-944(ra) # 80004038 <write_head>
    800043f0:	bdf5                	j	800042ec <end_op+0x52>

00000000800043f2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800043f2:	1101                	addi	sp,sp,-32
    800043f4:	ec06                	sd	ra,24(sp)
    800043f6:	e822                	sd	s0,16(sp)
    800043f8:	e426                	sd	s1,8(sp)
    800043fa:	e04a                	sd	s2,0(sp)
    800043fc:	1000                	addi	s0,sp,32
    800043fe:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004400:	0001d917          	auipc	s2,0x1d
    80004404:	34090913          	addi	s2,s2,832 # 80021740 <log>
    80004408:	854a                	mv	a0,s2
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	7cc080e7          	jalr	1996(ra) # 80000bd6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004412:	02c92603          	lw	a2,44(s2)
    80004416:	47f5                	li	a5,29
    80004418:	06c7c563          	blt	a5,a2,80004482 <log_write+0x90>
    8000441c:	0001d797          	auipc	a5,0x1d
    80004420:	3407a783          	lw	a5,832(a5) # 8002175c <log+0x1c>
    80004424:	37fd                	addiw	a5,a5,-1
    80004426:	04f65e63          	bge	a2,a5,80004482 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000442a:	0001d797          	auipc	a5,0x1d
    8000442e:	3367a783          	lw	a5,822(a5) # 80021760 <log+0x20>
    80004432:	06f05063          	blez	a5,80004492 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004436:	4781                	li	a5,0
    80004438:	06c05563          	blez	a2,800044a2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000443c:	44cc                	lw	a1,12(s1)
    8000443e:	0001d717          	auipc	a4,0x1d
    80004442:	33270713          	addi	a4,a4,818 # 80021770 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004446:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004448:	4314                	lw	a3,0(a4)
    8000444a:	04b68c63          	beq	a3,a1,800044a2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000444e:	2785                	addiw	a5,a5,1
    80004450:	0711                	addi	a4,a4,4
    80004452:	fef61be3          	bne	a2,a5,80004448 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004456:	0621                	addi	a2,a2,8
    80004458:	060a                	slli	a2,a2,0x2
    8000445a:	0001d797          	auipc	a5,0x1d
    8000445e:	2e678793          	addi	a5,a5,742 # 80021740 <log>
    80004462:	963e                	add	a2,a2,a5
    80004464:	44dc                	lw	a5,12(s1)
    80004466:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004468:	8526                	mv	a0,s1
    8000446a:	fffff097          	auipc	ra,0xfffff
    8000446e:	da2080e7          	jalr	-606(ra) # 8000320c <bpin>
    log.lh.n++;
    80004472:	0001d717          	auipc	a4,0x1d
    80004476:	2ce70713          	addi	a4,a4,718 # 80021740 <log>
    8000447a:	575c                	lw	a5,44(a4)
    8000447c:	2785                	addiw	a5,a5,1
    8000447e:	d75c                	sw	a5,44(a4)
    80004480:	a835                	j	800044bc <log_write+0xca>
    panic("too big a transaction");
    80004482:	00004517          	auipc	a0,0x4
    80004486:	1de50513          	addi	a0,a0,478 # 80008660 <syscalls+0x200>
    8000448a:	ffffc097          	auipc	ra,0xffffc
    8000448e:	0b4080e7          	jalr	180(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004492:	00004517          	auipc	a0,0x4
    80004496:	1e650513          	addi	a0,a0,486 # 80008678 <syscalls+0x218>
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	0a4080e7          	jalr	164(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    800044a2:	00878713          	addi	a4,a5,8
    800044a6:	00271693          	slli	a3,a4,0x2
    800044aa:	0001d717          	auipc	a4,0x1d
    800044ae:	29670713          	addi	a4,a4,662 # 80021740 <log>
    800044b2:	9736                	add	a4,a4,a3
    800044b4:	44d4                	lw	a3,12(s1)
    800044b6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800044b8:	faf608e3          	beq	a2,a5,80004468 <log_write+0x76>
  }
  release(&log.lock);
    800044bc:	0001d517          	auipc	a0,0x1d
    800044c0:	28450513          	addi	a0,a0,644 # 80021740 <log>
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	7c6080e7          	jalr	1990(ra) # 80000c8a <release>
}
    800044cc:	60e2                	ld	ra,24(sp)
    800044ce:	6442                	ld	s0,16(sp)
    800044d0:	64a2                	ld	s1,8(sp)
    800044d2:	6902                	ld	s2,0(sp)
    800044d4:	6105                	addi	sp,sp,32
    800044d6:	8082                	ret

00000000800044d8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800044d8:	1101                	addi	sp,sp,-32
    800044da:	ec06                	sd	ra,24(sp)
    800044dc:	e822                	sd	s0,16(sp)
    800044de:	e426                	sd	s1,8(sp)
    800044e0:	e04a                	sd	s2,0(sp)
    800044e2:	1000                	addi	s0,sp,32
    800044e4:	84aa                	mv	s1,a0
    800044e6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800044e8:	00004597          	auipc	a1,0x4
    800044ec:	1b058593          	addi	a1,a1,432 # 80008698 <syscalls+0x238>
    800044f0:	0521                	addi	a0,a0,8
    800044f2:	ffffc097          	auipc	ra,0xffffc
    800044f6:	654080e7          	jalr	1620(ra) # 80000b46 <initlock>
  lk->name = name;
    800044fa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800044fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004502:	0204a423          	sw	zero,40(s1)
}
    80004506:	60e2                	ld	ra,24(sp)
    80004508:	6442                	ld	s0,16(sp)
    8000450a:	64a2                	ld	s1,8(sp)
    8000450c:	6902                	ld	s2,0(sp)
    8000450e:	6105                	addi	sp,sp,32
    80004510:	8082                	ret

0000000080004512 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004512:	1101                	addi	sp,sp,-32
    80004514:	ec06                	sd	ra,24(sp)
    80004516:	e822                	sd	s0,16(sp)
    80004518:	e426                	sd	s1,8(sp)
    8000451a:	e04a                	sd	s2,0(sp)
    8000451c:	1000                	addi	s0,sp,32
    8000451e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004520:	00850913          	addi	s2,a0,8
    80004524:	854a                	mv	a0,s2
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	6b0080e7          	jalr	1712(ra) # 80000bd6 <acquire>
  while (lk->locked) {
    8000452e:	409c                	lw	a5,0(s1)
    80004530:	cb89                	beqz	a5,80004542 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004532:	85ca                	mv	a1,s2
    80004534:	8526                	mv	a0,s1
    80004536:	ffffe097          	auipc	ra,0xffffe
    8000453a:	be8080e7          	jalr	-1048(ra) # 8000211e <sleep>
  while (lk->locked) {
    8000453e:	409c                	lw	a5,0(s1)
    80004540:	fbed                	bnez	a5,80004532 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004542:	4785                	li	a5,1
    80004544:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004546:	ffffd097          	auipc	ra,0xffffd
    8000454a:	466080e7          	jalr	1126(ra) # 800019ac <myproc>
    8000454e:	591c                	lw	a5,48(a0)
    80004550:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004552:	854a                	mv	a0,s2
    80004554:	ffffc097          	auipc	ra,0xffffc
    80004558:	736080e7          	jalr	1846(ra) # 80000c8a <release>
}
    8000455c:	60e2                	ld	ra,24(sp)
    8000455e:	6442                	ld	s0,16(sp)
    80004560:	64a2                	ld	s1,8(sp)
    80004562:	6902                	ld	s2,0(sp)
    80004564:	6105                	addi	sp,sp,32
    80004566:	8082                	ret

0000000080004568 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004568:	1101                	addi	sp,sp,-32
    8000456a:	ec06                	sd	ra,24(sp)
    8000456c:	e822                	sd	s0,16(sp)
    8000456e:	e426                	sd	s1,8(sp)
    80004570:	e04a                	sd	s2,0(sp)
    80004572:	1000                	addi	s0,sp,32
    80004574:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004576:	00850913          	addi	s2,a0,8
    8000457a:	854a                	mv	a0,s2
    8000457c:	ffffc097          	auipc	ra,0xffffc
    80004580:	65a080e7          	jalr	1626(ra) # 80000bd6 <acquire>
  lk->locked = 0;
    80004584:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004588:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000458c:	8526                	mv	a0,s1
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	bf4080e7          	jalr	-1036(ra) # 80002182 <wakeup>
  release(&lk->lk);
    80004596:	854a                	mv	a0,s2
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	6f2080e7          	jalr	1778(ra) # 80000c8a <release>
}
    800045a0:	60e2                	ld	ra,24(sp)
    800045a2:	6442                	ld	s0,16(sp)
    800045a4:	64a2                	ld	s1,8(sp)
    800045a6:	6902                	ld	s2,0(sp)
    800045a8:	6105                	addi	sp,sp,32
    800045aa:	8082                	ret

00000000800045ac <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800045ac:	7179                	addi	sp,sp,-48
    800045ae:	f406                	sd	ra,40(sp)
    800045b0:	f022                	sd	s0,32(sp)
    800045b2:	ec26                	sd	s1,24(sp)
    800045b4:	e84a                	sd	s2,16(sp)
    800045b6:	e44e                	sd	s3,8(sp)
    800045b8:	1800                	addi	s0,sp,48
    800045ba:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800045bc:	00850913          	addi	s2,a0,8
    800045c0:	854a                	mv	a0,s2
    800045c2:	ffffc097          	auipc	ra,0xffffc
    800045c6:	614080e7          	jalr	1556(ra) # 80000bd6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800045ca:	409c                	lw	a5,0(s1)
    800045cc:	ef99                	bnez	a5,800045ea <holdingsleep+0x3e>
    800045ce:	4481                	li	s1,0
  release(&lk->lk);
    800045d0:	854a                	mv	a0,s2
    800045d2:	ffffc097          	auipc	ra,0xffffc
    800045d6:	6b8080e7          	jalr	1720(ra) # 80000c8a <release>
  return r;
}
    800045da:	8526                	mv	a0,s1
    800045dc:	70a2                	ld	ra,40(sp)
    800045de:	7402                	ld	s0,32(sp)
    800045e0:	64e2                	ld	s1,24(sp)
    800045e2:	6942                	ld	s2,16(sp)
    800045e4:	69a2                	ld	s3,8(sp)
    800045e6:	6145                	addi	sp,sp,48
    800045e8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800045ea:	0284a983          	lw	s3,40(s1)
    800045ee:	ffffd097          	auipc	ra,0xffffd
    800045f2:	3be080e7          	jalr	958(ra) # 800019ac <myproc>
    800045f6:	5904                	lw	s1,48(a0)
    800045f8:	413484b3          	sub	s1,s1,s3
    800045fc:	0014b493          	seqz	s1,s1
    80004600:	bfc1                	j	800045d0 <holdingsleep+0x24>

0000000080004602 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004602:	1141                	addi	sp,sp,-16
    80004604:	e406                	sd	ra,8(sp)
    80004606:	e022                	sd	s0,0(sp)
    80004608:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000460a:	00004597          	auipc	a1,0x4
    8000460e:	09e58593          	addi	a1,a1,158 # 800086a8 <syscalls+0x248>
    80004612:	0001d517          	auipc	a0,0x1d
    80004616:	27650513          	addi	a0,a0,630 # 80021888 <ftable>
    8000461a:	ffffc097          	auipc	ra,0xffffc
    8000461e:	52c080e7          	jalr	1324(ra) # 80000b46 <initlock>
}
    80004622:	60a2                	ld	ra,8(sp)
    80004624:	6402                	ld	s0,0(sp)
    80004626:	0141                	addi	sp,sp,16
    80004628:	8082                	ret

000000008000462a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000462a:	1101                	addi	sp,sp,-32
    8000462c:	ec06                	sd	ra,24(sp)
    8000462e:	e822                	sd	s0,16(sp)
    80004630:	e426                	sd	s1,8(sp)
    80004632:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004634:	0001d517          	auipc	a0,0x1d
    80004638:	25450513          	addi	a0,a0,596 # 80021888 <ftable>
    8000463c:	ffffc097          	auipc	ra,0xffffc
    80004640:	59a080e7          	jalr	1434(ra) # 80000bd6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004644:	0001d497          	auipc	s1,0x1d
    80004648:	25c48493          	addi	s1,s1,604 # 800218a0 <ftable+0x18>
    8000464c:	0001e717          	auipc	a4,0x1e
    80004650:	1f470713          	addi	a4,a4,500 # 80022840 <disk>
    if(f->ref == 0){
    80004654:	40dc                	lw	a5,4(s1)
    80004656:	cf99                	beqz	a5,80004674 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004658:	02848493          	addi	s1,s1,40
    8000465c:	fee49ce3          	bne	s1,a4,80004654 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004660:	0001d517          	auipc	a0,0x1d
    80004664:	22850513          	addi	a0,a0,552 # 80021888 <ftable>
    80004668:	ffffc097          	auipc	ra,0xffffc
    8000466c:	622080e7          	jalr	1570(ra) # 80000c8a <release>
  return 0;
    80004670:	4481                	li	s1,0
    80004672:	a819                	j	80004688 <filealloc+0x5e>
      f->ref = 1;
    80004674:	4785                	li	a5,1
    80004676:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004678:	0001d517          	auipc	a0,0x1d
    8000467c:	21050513          	addi	a0,a0,528 # 80021888 <ftable>
    80004680:	ffffc097          	auipc	ra,0xffffc
    80004684:	60a080e7          	jalr	1546(ra) # 80000c8a <release>
}
    80004688:	8526                	mv	a0,s1
    8000468a:	60e2                	ld	ra,24(sp)
    8000468c:	6442                	ld	s0,16(sp)
    8000468e:	64a2                	ld	s1,8(sp)
    80004690:	6105                	addi	sp,sp,32
    80004692:	8082                	ret

0000000080004694 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004694:	1101                	addi	sp,sp,-32
    80004696:	ec06                	sd	ra,24(sp)
    80004698:	e822                	sd	s0,16(sp)
    8000469a:	e426                	sd	s1,8(sp)
    8000469c:	1000                	addi	s0,sp,32
    8000469e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800046a0:	0001d517          	auipc	a0,0x1d
    800046a4:	1e850513          	addi	a0,a0,488 # 80021888 <ftable>
    800046a8:	ffffc097          	auipc	ra,0xffffc
    800046ac:	52e080e7          	jalr	1326(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    800046b0:	40dc                	lw	a5,4(s1)
    800046b2:	02f05263          	blez	a5,800046d6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800046b6:	2785                	addiw	a5,a5,1
    800046b8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800046ba:	0001d517          	auipc	a0,0x1d
    800046be:	1ce50513          	addi	a0,a0,462 # 80021888 <ftable>
    800046c2:	ffffc097          	auipc	ra,0xffffc
    800046c6:	5c8080e7          	jalr	1480(ra) # 80000c8a <release>
  return f;
}
    800046ca:	8526                	mv	a0,s1
    800046cc:	60e2                	ld	ra,24(sp)
    800046ce:	6442                	ld	s0,16(sp)
    800046d0:	64a2                	ld	s1,8(sp)
    800046d2:	6105                	addi	sp,sp,32
    800046d4:	8082                	ret
    panic("filedup");
    800046d6:	00004517          	auipc	a0,0x4
    800046da:	fda50513          	addi	a0,a0,-38 # 800086b0 <syscalls+0x250>
    800046de:	ffffc097          	auipc	ra,0xffffc
    800046e2:	e60080e7          	jalr	-416(ra) # 8000053e <panic>

00000000800046e6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800046e6:	7139                	addi	sp,sp,-64
    800046e8:	fc06                	sd	ra,56(sp)
    800046ea:	f822                	sd	s0,48(sp)
    800046ec:	f426                	sd	s1,40(sp)
    800046ee:	f04a                	sd	s2,32(sp)
    800046f0:	ec4e                	sd	s3,24(sp)
    800046f2:	e852                	sd	s4,16(sp)
    800046f4:	e456                	sd	s5,8(sp)
    800046f6:	0080                	addi	s0,sp,64
    800046f8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800046fa:	0001d517          	auipc	a0,0x1d
    800046fe:	18e50513          	addi	a0,a0,398 # 80021888 <ftable>
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	4d4080e7          	jalr	1236(ra) # 80000bd6 <acquire>
  if(f->ref < 1)
    8000470a:	40dc                	lw	a5,4(s1)
    8000470c:	06f05163          	blez	a5,8000476e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004710:	37fd                	addiw	a5,a5,-1
    80004712:	0007871b          	sext.w	a4,a5
    80004716:	c0dc                	sw	a5,4(s1)
    80004718:	06e04363          	bgtz	a4,8000477e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000471c:	0004a903          	lw	s2,0(s1)
    80004720:	0094ca83          	lbu	s5,9(s1)
    80004724:	0104ba03          	ld	s4,16(s1)
    80004728:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000472c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004730:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004734:	0001d517          	auipc	a0,0x1d
    80004738:	15450513          	addi	a0,a0,340 # 80021888 <ftable>
    8000473c:	ffffc097          	auipc	ra,0xffffc
    80004740:	54e080e7          	jalr	1358(ra) # 80000c8a <release>

  if(ff.type == FD_PIPE){
    80004744:	4785                	li	a5,1
    80004746:	04f90d63          	beq	s2,a5,800047a0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000474a:	3979                	addiw	s2,s2,-2
    8000474c:	4785                	li	a5,1
    8000474e:	0527e063          	bltu	a5,s2,8000478e <fileclose+0xa8>
    begin_op();
    80004752:	00000097          	auipc	ra,0x0
    80004756:	ac8080e7          	jalr	-1336(ra) # 8000421a <begin_op>
    iput(ff.ip);
    8000475a:	854e                	mv	a0,s3
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	2b6080e7          	jalr	694(ra) # 80003a12 <iput>
    end_op();
    80004764:	00000097          	auipc	ra,0x0
    80004768:	b36080e7          	jalr	-1226(ra) # 8000429a <end_op>
    8000476c:	a00d                	j	8000478e <fileclose+0xa8>
    panic("fileclose");
    8000476e:	00004517          	auipc	a0,0x4
    80004772:	f4a50513          	addi	a0,a0,-182 # 800086b8 <syscalls+0x258>
    80004776:	ffffc097          	auipc	ra,0xffffc
    8000477a:	dc8080e7          	jalr	-568(ra) # 8000053e <panic>
    release(&ftable.lock);
    8000477e:	0001d517          	auipc	a0,0x1d
    80004782:	10a50513          	addi	a0,a0,266 # 80021888 <ftable>
    80004786:	ffffc097          	auipc	ra,0xffffc
    8000478a:	504080e7          	jalr	1284(ra) # 80000c8a <release>
  }
}
    8000478e:	70e2                	ld	ra,56(sp)
    80004790:	7442                	ld	s0,48(sp)
    80004792:	74a2                	ld	s1,40(sp)
    80004794:	7902                	ld	s2,32(sp)
    80004796:	69e2                	ld	s3,24(sp)
    80004798:	6a42                	ld	s4,16(sp)
    8000479a:	6aa2                	ld	s5,8(sp)
    8000479c:	6121                	addi	sp,sp,64
    8000479e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800047a0:	85d6                	mv	a1,s5
    800047a2:	8552                	mv	a0,s4
    800047a4:	00000097          	auipc	ra,0x0
    800047a8:	34c080e7          	jalr	844(ra) # 80004af0 <pipeclose>
    800047ac:	b7cd                	j	8000478e <fileclose+0xa8>

00000000800047ae <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800047ae:	715d                	addi	sp,sp,-80
    800047b0:	e486                	sd	ra,72(sp)
    800047b2:	e0a2                	sd	s0,64(sp)
    800047b4:	fc26                	sd	s1,56(sp)
    800047b6:	f84a                	sd	s2,48(sp)
    800047b8:	f44e                	sd	s3,40(sp)
    800047ba:	0880                	addi	s0,sp,80
    800047bc:	84aa                	mv	s1,a0
    800047be:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800047c0:	ffffd097          	auipc	ra,0xffffd
    800047c4:	1ec080e7          	jalr	492(ra) # 800019ac <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800047c8:	409c                	lw	a5,0(s1)
    800047ca:	37f9                	addiw	a5,a5,-2
    800047cc:	4705                	li	a4,1
    800047ce:	04f76763          	bltu	a4,a5,8000481c <filestat+0x6e>
    800047d2:	892a                	mv	s2,a0
    ilock(f->ip);
    800047d4:	6c88                	ld	a0,24(s1)
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	082080e7          	jalr	130(ra) # 80003858 <ilock>
    stati(f->ip, &st);
    800047de:	fb840593          	addi	a1,s0,-72
    800047e2:	6c88                	ld	a0,24(s1)
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	2fe080e7          	jalr	766(ra) # 80003ae2 <stati>
    iunlock(f->ip);
    800047ec:	6c88                	ld	a0,24(s1)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	12c080e7          	jalr	300(ra) # 8000391a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800047f6:	46e1                	li	a3,24
    800047f8:	fb840613          	addi	a2,s0,-72
    800047fc:	85ce                	mv	a1,s3
    800047fe:	07893503          	ld	a0,120(s2)
    80004802:	ffffd097          	auipc	ra,0xffffd
    80004806:	e66080e7          	jalr	-410(ra) # 80001668 <copyout>
    8000480a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000480e:	60a6                	ld	ra,72(sp)
    80004810:	6406                	ld	s0,64(sp)
    80004812:	74e2                	ld	s1,56(sp)
    80004814:	7942                	ld	s2,48(sp)
    80004816:	79a2                	ld	s3,40(sp)
    80004818:	6161                	addi	sp,sp,80
    8000481a:	8082                	ret
  return -1;
    8000481c:	557d                	li	a0,-1
    8000481e:	bfc5                	j	8000480e <filestat+0x60>

0000000080004820 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004820:	7179                	addi	sp,sp,-48
    80004822:	f406                	sd	ra,40(sp)
    80004824:	f022                	sd	s0,32(sp)
    80004826:	ec26                	sd	s1,24(sp)
    80004828:	e84a                	sd	s2,16(sp)
    8000482a:	e44e                	sd	s3,8(sp)
    8000482c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000482e:	00854783          	lbu	a5,8(a0)
    80004832:	c3d5                	beqz	a5,800048d6 <fileread+0xb6>
    80004834:	84aa                	mv	s1,a0
    80004836:	89ae                	mv	s3,a1
    80004838:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000483a:	411c                	lw	a5,0(a0)
    8000483c:	4705                	li	a4,1
    8000483e:	04e78963          	beq	a5,a4,80004890 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004842:	470d                	li	a4,3
    80004844:	04e78d63          	beq	a5,a4,8000489e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004848:	4709                	li	a4,2
    8000484a:	06e79e63          	bne	a5,a4,800048c6 <fileread+0xa6>
    ilock(f->ip);
    8000484e:	6d08                	ld	a0,24(a0)
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	008080e7          	jalr	8(ra) # 80003858 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004858:	874a                	mv	a4,s2
    8000485a:	5094                	lw	a3,32(s1)
    8000485c:	864e                	mv	a2,s3
    8000485e:	4585                	li	a1,1
    80004860:	6c88                	ld	a0,24(s1)
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	2aa080e7          	jalr	682(ra) # 80003b0c <readi>
    8000486a:	892a                	mv	s2,a0
    8000486c:	00a05563          	blez	a0,80004876 <fileread+0x56>
      f->off += r;
    80004870:	509c                	lw	a5,32(s1)
    80004872:	9fa9                	addw	a5,a5,a0
    80004874:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004876:	6c88                	ld	a0,24(s1)
    80004878:	fffff097          	auipc	ra,0xfffff
    8000487c:	0a2080e7          	jalr	162(ra) # 8000391a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004880:	854a                	mv	a0,s2
    80004882:	70a2                	ld	ra,40(sp)
    80004884:	7402                	ld	s0,32(sp)
    80004886:	64e2                	ld	s1,24(sp)
    80004888:	6942                	ld	s2,16(sp)
    8000488a:	69a2                	ld	s3,8(sp)
    8000488c:	6145                	addi	sp,sp,48
    8000488e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004890:	6908                	ld	a0,16(a0)
    80004892:	00000097          	auipc	ra,0x0
    80004896:	3c6080e7          	jalr	966(ra) # 80004c58 <piperead>
    8000489a:	892a                	mv	s2,a0
    8000489c:	b7d5                	j	80004880 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000489e:	02451783          	lh	a5,36(a0)
    800048a2:	03079693          	slli	a3,a5,0x30
    800048a6:	92c1                	srli	a3,a3,0x30
    800048a8:	4725                	li	a4,9
    800048aa:	02d76863          	bltu	a4,a3,800048da <fileread+0xba>
    800048ae:	0792                	slli	a5,a5,0x4
    800048b0:	0001d717          	auipc	a4,0x1d
    800048b4:	f3870713          	addi	a4,a4,-200 # 800217e8 <devsw>
    800048b8:	97ba                	add	a5,a5,a4
    800048ba:	639c                	ld	a5,0(a5)
    800048bc:	c38d                	beqz	a5,800048de <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800048be:	4505                	li	a0,1
    800048c0:	9782                	jalr	a5
    800048c2:	892a                	mv	s2,a0
    800048c4:	bf75                	j	80004880 <fileread+0x60>
    panic("fileread");
    800048c6:	00004517          	auipc	a0,0x4
    800048ca:	e0250513          	addi	a0,a0,-510 # 800086c8 <syscalls+0x268>
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	c70080e7          	jalr	-912(ra) # 8000053e <panic>
    return -1;
    800048d6:	597d                	li	s2,-1
    800048d8:	b765                	j	80004880 <fileread+0x60>
      return -1;
    800048da:	597d                	li	s2,-1
    800048dc:	b755                	j	80004880 <fileread+0x60>
    800048de:	597d                	li	s2,-1
    800048e0:	b745                	j	80004880 <fileread+0x60>

00000000800048e2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800048e2:	715d                	addi	sp,sp,-80
    800048e4:	e486                	sd	ra,72(sp)
    800048e6:	e0a2                	sd	s0,64(sp)
    800048e8:	fc26                	sd	s1,56(sp)
    800048ea:	f84a                	sd	s2,48(sp)
    800048ec:	f44e                	sd	s3,40(sp)
    800048ee:	f052                	sd	s4,32(sp)
    800048f0:	ec56                	sd	s5,24(sp)
    800048f2:	e85a                	sd	s6,16(sp)
    800048f4:	e45e                	sd	s7,8(sp)
    800048f6:	e062                	sd	s8,0(sp)
    800048f8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800048fa:	00954783          	lbu	a5,9(a0)
    800048fe:	10078663          	beqz	a5,80004a0a <filewrite+0x128>
    80004902:	892a                	mv	s2,a0
    80004904:	8aae                	mv	s5,a1
    80004906:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004908:	411c                	lw	a5,0(a0)
    8000490a:	4705                	li	a4,1
    8000490c:	02e78263          	beq	a5,a4,80004930 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004910:	470d                	li	a4,3
    80004912:	02e78663          	beq	a5,a4,8000493e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004916:	4709                	li	a4,2
    80004918:	0ee79163          	bne	a5,a4,800049fa <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000491c:	0ac05d63          	blez	a2,800049d6 <filewrite+0xf4>
    int i = 0;
    80004920:	4981                	li	s3,0
    80004922:	6b05                	lui	s6,0x1
    80004924:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004928:	6b85                	lui	s7,0x1
    8000492a:	c00b8b9b          	addiw	s7,s7,-1024
    8000492e:	a861                	j	800049c6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004930:	6908                	ld	a0,16(a0)
    80004932:	00000097          	auipc	ra,0x0
    80004936:	22e080e7          	jalr	558(ra) # 80004b60 <pipewrite>
    8000493a:	8a2a                	mv	s4,a0
    8000493c:	a045                	j	800049dc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000493e:	02451783          	lh	a5,36(a0)
    80004942:	03079693          	slli	a3,a5,0x30
    80004946:	92c1                	srli	a3,a3,0x30
    80004948:	4725                	li	a4,9
    8000494a:	0cd76263          	bltu	a4,a3,80004a0e <filewrite+0x12c>
    8000494e:	0792                	slli	a5,a5,0x4
    80004950:	0001d717          	auipc	a4,0x1d
    80004954:	e9870713          	addi	a4,a4,-360 # 800217e8 <devsw>
    80004958:	97ba                	add	a5,a5,a4
    8000495a:	679c                	ld	a5,8(a5)
    8000495c:	cbdd                	beqz	a5,80004a12 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    8000495e:	4505                	li	a0,1
    80004960:	9782                	jalr	a5
    80004962:	8a2a                	mv	s4,a0
    80004964:	a8a5                	j	800049dc <filewrite+0xfa>
    80004966:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    8000496a:	00000097          	auipc	ra,0x0
    8000496e:	8b0080e7          	jalr	-1872(ra) # 8000421a <begin_op>
      ilock(f->ip);
    80004972:	01893503          	ld	a0,24(s2)
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	ee2080e7          	jalr	-286(ra) # 80003858 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000497e:	8762                	mv	a4,s8
    80004980:	02092683          	lw	a3,32(s2)
    80004984:	01598633          	add	a2,s3,s5
    80004988:	4585                	li	a1,1
    8000498a:	01893503          	ld	a0,24(s2)
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	276080e7          	jalr	630(ra) # 80003c04 <writei>
    80004996:	84aa                	mv	s1,a0
    80004998:	00a05763          	blez	a0,800049a6 <filewrite+0xc4>
        f->off += r;
    8000499c:	02092783          	lw	a5,32(s2)
    800049a0:	9fa9                	addw	a5,a5,a0
    800049a2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800049a6:	01893503          	ld	a0,24(s2)
    800049aa:	fffff097          	auipc	ra,0xfffff
    800049ae:	f70080e7          	jalr	-144(ra) # 8000391a <iunlock>
      end_op();
    800049b2:	00000097          	auipc	ra,0x0
    800049b6:	8e8080e7          	jalr	-1816(ra) # 8000429a <end_op>

      if(r != n1){
    800049ba:	009c1f63          	bne	s8,s1,800049d8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800049be:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800049c2:	0149db63          	bge	s3,s4,800049d8 <filewrite+0xf6>
      int n1 = n - i;
    800049c6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800049ca:	84be                	mv	s1,a5
    800049cc:	2781                	sext.w	a5,a5
    800049ce:	f8fb5ce3          	bge	s6,a5,80004966 <filewrite+0x84>
    800049d2:	84de                	mv	s1,s7
    800049d4:	bf49                	j	80004966 <filewrite+0x84>
    int i = 0;
    800049d6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800049d8:	013a1f63          	bne	s4,s3,800049f6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800049dc:	8552                	mv	a0,s4
    800049de:	60a6                	ld	ra,72(sp)
    800049e0:	6406                	ld	s0,64(sp)
    800049e2:	74e2                	ld	s1,56(sp)
    800049e4:	7942                	ld	s2,48(sp)
    800049e6:	79a2                	ld	s3,40(sp)
    800049e8:	7a02                	ld	s4,32(sp)
    800049ea:	6ae2                	ld	s5,24(sp)
    800049ec:	6b42                	ld	s6,16(sp)
    800049ee:	6ba2                	ld	s7,8(sp)
    800049f0:	6c02                	ld	s8,0(sp)
    800049f2:	6161                	addi	sp,sp,80
    800049f4:	8082                	ret
    ret = (i == n ? n : -1);
    800049f6:	5a7d                	li	s4,-1
    800049f8:	b7d5                	j	800049dc <filewrite+0xfa>
    panic("filewrite");
    800049fa:	00004517          	auipc	a0,0x4
    800049fe:	cde50513          	addi	a0,a0,-802 # 800086d8 <syscalls+0x278>
    80004a02:	ffffc097          	auipc	ra,0xffffc
    80004a06:	b3c080e7          	jalr	-1220(ra) # 8000053e <panic>
    return -1;
    80004a0a:	5a7d                	li	s4,-1
    80004a0c:	bfc1                	j	800049dc <filewrite+0xfa>
      return -1;
    80004a0e:	5a7d                	li	s4,-1
    80004a10:	b7f1                	j	800049dc <filewrite+0xfa>
    80004a12:	5a7d                	li	s4,-1
    80004a14:	b7e1                	j	800049dc <filewrite+0xfa>

0000000080004a16 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004a16:	7179                	addi	sp,sp,-48
    80004a18:	f406                	sd	ra,40(sp)
    80004a1a:	f022                	sd	s0,32(sp)
    80004a1c:	ec26                	sd	s1,24(sp)
    80004a1e:	e84a                	sd	s2,16(sp)
    80004a20:	e44e                	sd	s3,8(sp)
    80004a22:	e052                	sd	s4,0(sp)
    80004a24:	1800                	addi	s0,sp,48
    80004a26:	84aa                	mv	s1,a0
    80004a28:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004a2a:	0005b023          	sd	zero,0(a1)
    80004a2e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004a32:	00000097          	auipc	ra,0x0
    80004a36:	bf8080e7          	jalr	-1032(ra) # 8000462a <filealloc>
    80004a3a:	e088                	sd	a0,0(s1)
    80004a3c:	c551                	beqz	a0,80004ac8 <pipealloc+0xb2>
    80004a3e:	00000097          	auipc	ra,0x0
    80004a42:	bec080e7          	jalr	-1044(ra) # 8000462a <filealloc>
    80004a46:	00aa3023          	sd	a0,0(s4)
    80004a4a:	c92d                	beqz	a0,80004abc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004a4c:	ffffc097          	auipc	ra,0xffffc
    80004a50:	09a080e7          	jalr	154(ra) # 80000ae6 <kalloc>
    80004a54:	892a                	mv	s2,a0
    80004a56:	c125                	beqz	a0,80004ab6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004a58:	4985                	li	s3,1
    80004a5a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004a5e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004a62:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004a66:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004a6a:	00004597          	auipc	a1,0x4
    80004a6e:	c7e58593          	addi	a1,a1,-898 # 800086e8 <syscalls+0x288>
    80004a72:	ffffc097          	auipc	ra,0xffffc
    80004a76:	0d4080e7          	jalr	212(ra) # 80000b46 <initlock>
  (*f0)->type = FD_PIPE;
    80004a7a:	609c                	ld	a5,0(s1)
    80004a7c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004a80:	609c                	ld	a5,0(s1)
    80004a82:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004a86:	609c                	ld	a5,0(s1)
    80004a88:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004a8c:	609c                	ld	a5,0(s1)
    80004a8e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004a92:	000a3783          	ld	a5,0(s4)
    80004a96:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004a9a:	000a3783          	ld	a5,0(s4)
    80004a9e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004aa2:	000a3783          	ld	a5,0(s4)
    80004aa6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004aaa:	000a3783          	ld	a5,0(s4)
    80004aae:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ab2:	4501                	li	a0,0
    80004ab4:	a025                	j	80004adc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ab6:	6088                	ld	a0,0(s1)
    80004ab8:	e501                	bnez	a0,80004ac0 <pipealloc+0xaa>
    80004aba:	a039                	j	80004ac8 <pipealloc+0xb2>
    80004abc:	6088                	ld	a0,0(s1)
    80004abe:	c51d                	beqz	a0,80004aec <pipealloc+0xd6>
    fileclose(*f0);
    80004ac0:	00000097          	auipc	ra,0x0
    80004ac4:	c26080e7          	jalr	-986(ra) # 800046e6 <fileclose>
  if(*f1)
    80004ac8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004acc:	557d                	li	a0,-1
  if(*f1)
    80004ace:	c799                	beqz	a5,80004adc <pipealloc+0xc6>
    fileclose(*f1);
    80004ad0:	853e                	mv	a0,a5
    80004ad2:	00000097          	auipc	ra,0x0
    80004ad6:	c14080e7          	jalr	-1004(ra) # 800046e6 <fileclose>
  return -1;
    80004ada:	557d                	li	a0,-1
}
    80004adc:	70a2                	ld	ra,40(sp)
    80004ade:	7402                	ld	s0,32(sp)
    80004ae0:	64e2                	ld	s1,24(sp)
    80004ae2:	6942                	ld	s2,16(sp)
    80004ae4:	69a2                	ld	s3,8(sp)
    80004ae6:	6a02                	ld	s4,0(sp)
    80004ae8:	6145                	addi	sp,sp,48
    80004aea:	8082                	ret
  return -1;
    80004aec:	557d                	li	a0,-1
    80004aee:	b7fd                	j	80004adc <pipealloc+0xc6>

0000000080004af0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004af0:	1101                	addi	sp,sp,-32
    80004af2:	ec06                	sd	ra,24(sp)
    80004af4:	e822                	sd	s0,16(sp)
    80004af6:	e426                	sd	s1,8(sp)
    80004af8:	e04a                	sd	s2,0(sp)
    80004afa:	1000                	addi	s0,sp,32
    80004afc:	84aa                	mv	s1,a0
    80004afe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004b00:	ffffc097          	auipc	ra,0xffffc
    80004b04:	0d6080e7          	jalr	214(ra) # 80000bd6 <acquire>
  if(writable){
    80004b08:	02090d63          	beqz	s2,80004b42 <pipeclose+0x52>
    pi->writeopen = 0;
    80004b0c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004b10:	21848513          	addi	a0,s1,536
    80004b14:	ffffd097          	auipc	ra,0xffffd
    80004b18:	66e080e7          	jalr	1646(ra) # 80002182 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004b1c:	2204b783          	ld	a5,544(s1)
    80004b20:	eb95                	bnez	a5,80004b54 <pipeclose+0x64>
    release(&pi->lock);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffc097          	auipc	ra,0xffffc
    80004b28:	166080e7          	jalr	358(ra) # 80000c8a <release>
    kfree((char*)pi);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	ffffc097          	auipc	ra,0xffffc
    80004b32:	ebc080e7          	jalr	-324(ra) # 800009ea <kfree>
  } else
    release(&pi->lock);
}
    80004b36:	60e2                	ld	ra,24(sp)
    80004b38:	6442                	ld	s0,16(sp)
    80004b3a:	64a2                	ld	s1,8(sp)
    80004b3c:	6902                	ld	s2,0(sp)
    80004b3e:	6105                	addi	sp,sp,32
    80004b40:	8082                	ret
    pi->readopen = 0;
    80004b42:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004b46:	21c48513          	addi	a0,s1,540
    80004b4a:	ffffd097          	auipc	ra,0xffffd
    80004b4e:	638080e7          	jalr	1592(ra) # 80002182 <wakeup>
    80004b52:	b7e9                	j	80004b1c <pipeclose+0x2c>
    release(&pi->lock);
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffc097          	auipc	ra,0xffffc
    80004b5a:	134080e7          	jalr	308(ra) # 80000c8a <release>
}
    80004b5e:	bfe1                	j	80004b36 <pipeclose+0x46>

0000000080004b60 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004b60:	711d                	addi	sp,sp,-96
    80004b62:	ec86                	sd	ra,88(sp)
    80004b64:	e8a2                	sd	s0,80(sp)
    80004b66:	e4a6                	sd	s1,72(sp)
    80004b68:	e0ca                	sd	s2,64(sp)
    80004b6a:	fc4e                	sd	s3,56(sp)
    80004b6c:	f852                	sd	s4,48(sp)
    80004b6e:	f456                	sd	s5,40(sp)
    80004b70:	f05a                	sd	s6,32(sp)
    80004b72:	ec5e                	sd	s7,24(sp)
    80004b74:	e862                	sd	s8,16(sp)
    80004b76:	1080                	addi	s0,sp,96
    80004b78:	84aa                	mv	s1,a0
    80004b7a:	8aae                	mv	s5,a1
    80004b7c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004b7e:	ffffd097          	auipc	ra,0xffffd
    80004b82:	e2e080e7          	jalr	-466(ra) # 800019ac <myproc>
    80004b86:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ffffc097          	auipc	ra,0xffffc
    80004b8e:	04c080e7          	jalr	76(ra) # 80000bd6 <acquire>
  while(i < n){
    80004b92:	0b405663          	blez	s4,80004c3e <pipewrite+0xde>
  int i = 0;
    80004b96:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b98:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004b9a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004b9e:	21c48b93          	addi	s7,s1,540
    80004ba2:	a089                	j	80004be4 <pipewrite+0x84>
      release(&pi->lock);
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	ffffc097          	auipc	ra,0xffffc
    80004baa:	0e4080e7          	jalr	228(ra) # 80000c8a <release>
      return -1;
    80004bae:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004bb0:	854a                	mv	a0,s2
    80004bb2:	60e6                	ld	ra,88(sp)
    80004bb4:	6446                	ld	s0,80(sp)
    80004bb6:	64a6                	ld	s1,72(sp)
    80004bb8:	6906                	ld	s2,64(sp)
    80004bba:	79e2                	ld	s3,56(sp)
    80004bbc:	7a42                	ld	s4,48(sp)
    80004bbe:	7aa2                	ld	s5,40(sp)
    80004bc0:	7b02                	ld	s6,32(sp)
    80004bc2:	6be2                	ld	s7,24(sp)
    80004bc4:	6c42                	ld	s8,16(sp)
    80004bc6:	6125                	addi	sp,sp,96
    80004bc8:	8082                	ret
      wakeup(&pi->nread);
    80004bca:	8562                	mv	a0,s8
    80004bcc:	ffffd097          	auipc	ra,0xffffd
    80004bd0:	5b6080e7          	jalr	1462(ra) # 80002182 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004bd4:	85a6                	mv	a1,s1
    80004bd6:	855e                	mv	a0,s7
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	546080e7          	jalr	1350(ra) # 8000211e <sleep>
  while(i < n){
    80004be0:	07495063          	bge	s2,s4,80004c40 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004be4:	2204a783          	lw	a5,544(s1)
    80004be8:	dfd5                	beqz	a5,80004ba4 <pipewrite+0x44>
    80004bea:	854e                	mv	a0,s3
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	85a080e7          	jalr	-1958(ra) # 80002446 <killed>
    80004bf4:	f945                	bnez	a0,80004ba4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004bf6:	2184a783          	lw	a5,536(s1)
    80004bfa:	21c4a703          	lw	a4,540(s1)
    80004bfe:	2007879b          	addiw	a5,a5,512
    80004c02:	fcf704e3          	beq	a4,a5,80004bca <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004c06:	4685                	li	a3,1
    80004c08:	01590633          	add	a2,s2,s5
    80004c0c:	faf40593          	addi	a1,s0,-81
    80004c10:	0789b503          	ld	a0,120(s3)
    80004c14:	ffffd097          	auipc	ra,0xffffd
    80004c18:	ae0080e7          	jalr	-1312(ra) # 800016f4 <copyin>
    80004c1c:	03650263          	beq	a0,s6,80004c40 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004c20:	21c4a783          	lw	a5,540(s1)
    80004c24:	0017871b          	addiw	a4,a5,1
    80004c28:	20e4ae23          	sw	a4,540(s1)
    80004c2c:	1ff7f793          	andi	a5,a5,511
    80004c30:	97a6                	add	a5,a5,s1
    80004c32:	faf44703          	lbu	a4,-81(s0)
    80004c36:	00e78c23          	sb	a4,24(a5)
      i++;
    80004c3a:	2905                	addiw	s2,s2,1
    80004c3c:	b755                	j	80004be0 <pipewrite+0x80>
  int i = 0;
    80004c3e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004c40:	21848513          	addi	a0,s1,536
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	53e080e7          	jalr	1342(ra) # 80002182 <wakeup>
  release(&pi->lock);
    80004c4c:	8526                	mv	a0,s1
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	03c080e7          	jalr	60(ra) # 80000c8a <release>
  return i;
    80004c56:	bfa9                	j	80004bb0 <pipewrite+0x50>

0000000080004c58 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004c58:	715d                	addi	sp,sp,-80
    80004c5a:	e486                	sd	ra,72(sp)
    80004c5c:	e0a2                	sd	s0,64(sp)
    80004c5e:	fc26                	sd	s1,56(sp)
    80004c60:	f84a                	sd	s2,48(sp)
    80004c62:	f44e                	sd	s3,40(sp)
    80004c64:	f052                	sd	s4,32(sp)
    80004c66:	ec56                	sd	s5,24(sp)
    80004c68:	e85a                	sd	s6,16(sp)
    80004c6a:	0880                	addi	s0,sp,80
    80004c6c:	84aa                	mv	s1,a0
    80004c6e:	892e                	mv	s2,a1
    80004c70:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004c72:	ffffd097          	auipc	ra,0xffffd
    80004c76:	d3a080e7          	jalr	-710(ra) # 800019ac <myproc>
    80004c7a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	ffffc097          	auipc	ra,0xffffc
    80004c82:	f58080e7          	jalr	-168(ra) # 80000bd6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c86:	2184a703          	lw	a4,536(s1)
    80004c8a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004c8e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004c92:	02f71763          	bne	a4,a5,80004cc0 <piperead+0x68>
    80004c96:	2244a783          	lw	a5,548(s1)
    80004c9a:	c39d                	beqz	a5,80004cc0 <piperead+0x68>
    if(killed(pr)){
    80004c9c:	8552                	mv	a0,s4
    80004c9e:	ffffd097          	auipc	ra,0xffffd
    80004ca2:	7a8080e7          	jalr	1960(ra) # 80002446 <killed>
    80004ca6:	e941                	bnez	a0,80004d36 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004ca8:	85a6                	mv	a1,s1
    80004caa:	854e                	mv	a0,s3
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	472080e7          	jalr	1138(ra) # 8000211e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004cb4:	2184a703          	lw	a4,536(s1)
    80004cb8:	21c4a783          	lw	a5,540(s1)
    80004cbc:	fcf70de3          	beq	a4,a5,80004c96 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cc0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cc2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004cc4:	05505363          	blez	s5,80004d0a <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004cc8:	2184a783          	lw	a5,536(s1)
    80004ccc:	21c4a703          	lw	a4,540(s1)
    80004cd0:	02f70d63          	beq	a4,a5,80004d0a <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004cd4:	0017871b          	addiw	a4,a5,1
    80004cd8:	20e4ac23          	sw	a4,536(s1)
    80004cdc:	1ff7f793          	andi	a5,a5,511
    80004ce0:	97a6                	add	a5,a5,s1
    80004ce2:	0187c783          	lbu	a5,24(a5)
    80004ce6:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004cea:	4685                	li	a3,1
    80004cec:	fbf40613          	addi	a2,s0,-65
    80004cf0:	85ca                	mv	a1,s2
    80004cf2:	078a3503          	ld	a0,120(s4)
    80004cf6:	ffffd097          	auipc	ra,0xffffd
    80004cfa:	972080e7          	jalr	-1678(ra) # 80001668 <copyout>
    80004cfe:	01650663          	beq	a0,s6,80004d0a <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004d02:	2985                	addiw	s3,s3,1
    80004d04:	0905                	addi	s2,s2,1
    80004d06:	fd3a91e3          	bne	s5,s3,80004cc8 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004d0a:	21c48513          	addi	a0,s1,540
    80004d0e:	ffffd097          	auipc	ra,0xffffd
    80004d12:	474080e7          	jalr	1140(ra) # 80002182 <wakeup>
  release(&pi->lock);
    80004d16:	8526                	mv	a0,s1
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	f72080e7          	jalr	-142(ra) # 80000c8a <release>
  return i;
}
    80004d20:	854e                	mv	a0,s3
    80004d22:	60a6                	ld	ra,72(sp)
    80004d24:	6406                	ld	s0,64(sp)
    80004d26:	74e2                	ld	s1,56(sp)
    80004d28:	7942                	ld	s2,48(sp)
    80004d2a:	79a2                	ld	s3,40(sp)
    80004d2c:	7a02                	ld	s4,32(sp)
    80004d2e:	6ae2                	ld	s5,24(sp)
    80004d30:	6b42                	ld	s6,16(sp)
    80004d32:	6161                	addi	sp,sp,80
    80004d34:	8082                	ret
      release(&pi->lock);
    80004d36:	8526                	mv	a0,s1
    80004d38:	ffffc097          	auipc	ra,0xffffc
    80004d3c:	f52080e7          	jalr	-174(ra) # 80000c8a <release>
      return -1;
    80004d40:	59fd                	li	s3,-1
    80004d42:	bff9                	j	80004d20 <piperead+0xc8>

0000000080004d44 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004d44:	1141                	addi	sp,sp,-16
    80004d46:	e422                	sd	s0,8(sp)
    80004d48:	0800                	addi	s0,sp,16
    80004d4a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004d4c:	8905                	andi	a0,a0,1
    80004d4e:	c111                	beqz	a0,80004d52 <flags2perm+0xe>
      perm = PTE_X;
    80004d50:	4521                	li	a0,8
    if(flags & 0x2)
    80004d52:	8b89                	andi	a5,a5,2
    80004d54:	c399                	beqz	a5,80004d5a <flags2perm+0x16>
      perm |= PTE_W;
    80004d56:	00456513          	ori	a0,a0,4
    return perm;
}
    80004d5a:	6422                	ld	s0,8(sp)
    80004d5c:	0141                	addi	sp,sp,16
    80004d5e:	8082                	ret

0000000080004d60 <exec>:

int
exec(char *path, char **argv)
{
    80004d60:	de010113          	addi	sp,sp,-544
    80004d64:	20113c23          	sd	ra,536(sp)
    80004d68:	20813823          	sd	s0,528(sp)
    80004d6c:	20913423          	sd	s1,520(sp)
    80004d70:	21213023          	sd	s2,512(sp)
    80004d74:	ffce                	sd	s3,504(sp)
    80004d76:	fbd2                	sd	s4,496(sp)
    80004d78:	f7d6                	sd	s5,488(sp)
    80004d7a:	f3da                	sd	s6,480(sp)
    80004d7c:	efde                	sd	s7,472(sp)
    80004d7e:	ebe2                	sd	s8,464(sp)
    80004d80:	e7e6                	sd	s9,456(sp)
    80004d82:	e3ea                	sd	s10,448(sp)
    80004d84:	ff6e                	sd	s11,440(sp)
    80004d86:	1400                	addi	s0,sp,544
    80004d88:	892a                	mv	s2,a0
    80004d8a:	dea43423          	sd	a0,-536(s0)
    80004d8e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004d92:	ffffd097          	auipc	ra,0xffffd
    80004d96:	c1a080e7          	jalr	-998(ra) # 800019ac <myproc>
    80004d9a:	84aa                	mv	s1,a0

  begin_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	47e080e7          	jalr	1150(ra) # 8000421a <begin_op>

  if((ip = namei(path)) == 0){
    80004da4:	854a                	mv	a0,s2
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	258080e7          	jalr	600(ra) # 80003ffe <namei>
    80004dae:	c93d                	beqz	a0,80004e24 <exec+0xc4>
    80004db0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	aa6080e7          	jalr	-1370(ra) # 80003858 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004dba:	04000713          	li	a4,64
    80004dbe:	4681                	li	a3,0
    80004dc0:	e5040613          	addi	a2,s0,-432
    80004dc4:	4581                	li	a1,0
    80004dc6:	8556                	mv	a0,s5
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	d44080e7          	jalr	-700(ra) # 80003b0c <readi>
    80004dd0:	04000793          	li	a5,64
    80004dd4:	00f51a63          	bne	a0,a5,80004de8 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004dd8:	e5042703          	lw	a4,-432(s0)
    80004ddc:	464c47b7          	lui	a5,0x464c4
    80004de0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004de4:	04f70663          	beq	a4,a5,80004e30 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004de8:	8556                	mv	a0,s5
    80004dea:	fffff097          	auipc	ra,0xfffff
    80004dee:	cd0080e7          	jalr	-816(ra) # 80003aba <iunlockput>
    end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	4a8080e7          	jalr	1192(ra) # 8000429a <end_op>
  }
  return -1;
    80004dfa:	557d                	li	a0,-1
}
    80004dfc:	21813083          	ld	ra,536(sp)
    80004e00:	21013403          	ld	s0,528(sp)
    80004e04:	20813483          	ld	s1,520(sp)
    80004e08:	20013903          	ld	s2,512(sp)
    80004e0c:	79fe                	ld	s3,504(sp)
    80004e0e:	7a5e                	ld	s4,496(sp)
    80004e10:	7abe                	ld	s5,488(sp)
    80004e12:	7b1e                	ld	s6,480(sp)
    80004e14:	6bfe                	ld	s7,472(sp)
    80004e16:	6c5e                	ld	s8,464(sp)
    80004e18:	6cbe                	ld	s9,456(sp)
    80004e1a:	6d1e                	ld	s10,448(sp)
    80004e1c:	7dfa                	ld	s11,440(sp)
    80004e1e:	22010113          	addi	sp,sp,544
    80004e22:	8082                	ret
    end_op();
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	476080e7          	jalr	1142(ra) # 8000429a <end_op>
    return -1;
    80004e2c:	557d                	li	a0,-1
    80004e2e:	b7f9                	j	80004dfc <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffd097          	auipc	ra,0xffffd
    80004e36:	c3e080e7          	jalr	-962(ra) # 80001a70 <proc_pagetable>
    80004e3a:	8b2a                	mv	s6,a0
    80004e3c:	d555                	beqz	a0,80004de8 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e3e:	e7042783          	lw	a5,-400(s0)
    80004e42:	e8845703          	lhu	a4,-376(s0)
    80004e46:	c735                	beqz	a4,80004eb2 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004e48:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e4a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004e4e:	6a05                	lui	s4,0x1
    80004e50:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004e54:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004e58:	6d85                	lui	s11,0x1
    80004e5a:	7d7d                	lui	s10,0xfffff
    80004e5c:	a481                	j	8000509c <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004e5e:	00004517          	auipc	a0,0x4
    80004e62:	89250513          	addi	a0,a0,-1902 # 800086f0 <syscalls+0x290>
    80004e66:	ffffb097          	auipc	ra,0xffffb
    80004e6a:	6d8080e7          	jalr	1752(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004e6e:	874a                	mv	a4,s2
    80004e70:	009c86bb          	addw	a3,s9,s1
    80004e74:	4581                	li	a1,0
    80004e76:	8556                	mv	a0,s5
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	c94080e7          	jalr	-876(ra) # 80003b0c <readi>
    80004e80:	2501                	sext.w	a0,a0
    80004e82:	1aa91a63          	bne	s2,a0,80005036 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    80004e86:	009d84bb          	addw	s1,s11,s1
    80004e8a:	013d09bb          	addw	s3,s10,s3
    80004e8e:	1f74f763          	bgeu	s1,s7,8000507c <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    80004e92:	02049593          	slli	a1,s1,0x20
    80004e96:	9181                	srli	a1,a1,0x20
    80004e98:	95e2                	add	a1,a1,s8
    80004e9a:	855a                	mv	a0,s6
    80004e9c:	ffffc097          	auipc	ra,0xffffc
    80004ea0:	1c0080e7          	jalr	448(ra) # 8000105c <walkaddr>
    80004ea4:	862a                	mv	a2,a0
    if(pa == 0)
    80004ea6:	dd45                	beqz	a0,80004e5e <exec+0xfe>
      n = PGSIZE;
    80004ea8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004eaa:	fd49f2e3          	bgeu	s3,s4,80004e6e <exec+0x10e>
      n = sz - i;
    80004eae:	894e                	mv	s2,s3
    80004eb0:	bf7d                	j	80004e6e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004eb2:	4901                	li	s2,0
  iunlockput(ip);
    80004eb4:	8556                	mv	a0,s5
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	c04080e7          	jalr	-1020(ra) # 80003aba <iunlockput>
  end_op();
    80004ebe:	fffff097          	auipc	ra,0xfffff
    80004ec2:	3dc080e7          	jalr	988(ra) # 8000429a <end_op>
  p = myproc();
    80004ec6:	ffffd097          	auipc	ra,0xffffd
    80004eca:	ae6080e7          	jalr	-1306(ra) # 800019ac <myproc>
    80004ece:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004ed0:	07053d03          	ld	s10,112(a0)
  sz = PGROUNDUP(sz);
    80004ed4:	6785                	lui	a5,0x1
    80004ed6:	17fd                	addi	a5,a5,-1
    80004ed8:	993e                	add	s2,s2,a5
    80004eda:	77fd                	lui	a5,0xfffff
    80004edc:	00f977b3          	and	a5,s2,a5
    80004ee0:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004ee4:	4691                	li	a3,4
    80004ee6:	6609                	lui	a2,0x2
    80004ee8:	963e                	add	a2,a2,a5
    80004eea:	85be                	mv	a1,a5
    80004eec:	855a                	mv	a0,s6
    80004eee:	ffffc097          	auipc	ra,0xffffc
    80004ef2:	522080e7          	jalr	1314(ra) # 80001410 <uvmalloc>
    80004ef6:	8c2a                	mv	s8,a0
  ip = 0;
    80004ef8:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004efa:	12050e63          	beqz	a0,80005036 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004efe:	75f9                	lui	a1,0xffffe
    80004f00:	95aa                	add	a1,a1,a0
    80004f02:	855a                	mv	a0,s6
    80004f04:	ffffc097          	auipc	ra,0xffffc
    80004f08:	732080e7          	jalr	1842(ra) # 80001636 <uvmclear>
  stackbase = sp - PGSIZE;
    80004f0c:	7afd                	lui	s5,0xfffff
    80004f0e:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004f10:	df043783          	ld	a5,-528(s0)
    80004f14:	6388                	ld	a0,0(a5)
    80004f16:	c925                	beqz	a0,80004f86 <exec+0x226>
    80004f18:	e9040993          	addi	s3,s0,-368
    80004f1c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004f20:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004f22:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004f24:	ffffc097          	auipc	ra,0xffffc
    80004f28:	f2a080e7          	jalr	-214(ra) # 80000e4e <strlen>
    80004f2c:	0015079b          	addiw	a5,a0,1
    80004f30:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004f34:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004f38:	13596663          	bltu	s2,s5,80005064 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004f3c:	df043d83          	ld	s11,-528(s0)
    80004f40:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004f44:	8552                	mv	a0,s4
    80004f46:	ffffc097          	auipc	ra,0xffffc
    80004f4a:	f08080e7          	jalr	-248(ra) # 80000e4e <strlen>
    80004f4e:	0015069b          	addiw	a3,a0,1
    80004f52:	8652                	mv	a2,s4
    80004f54:	85ca                	mv	a1,s2
    80004f56:	855a                	mv	a0,s6
    80004f58:	ffffc097          	auipc	ra,0xffffc
    80004f5c:	710080e7          	jalr	1808(ra) # 80001668 <copyout>
    80004f60:	10054663          	bltz	a0,8000506c <exec+0x30c>
    ustack[argc] = sp;
    80004f64:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004f68:	0485                	addi	s1,s1,1
    80004f6a:	008d8793          	addi	a5,s11,8
    80004f6e:	def43823          	sd	a5,-528(s0)
    80004f72:	008db503          	ld	a0,8(s11)
    80004f76:	c911                	beqz	a0,80004f8a <exec+0x22a>
    if(argc >= MAXARG)
    80004f78:	09a1                	addi	s3,s3,8
    80004f7a:	fb3c95e3          	bne	s9,s3,80004f24 <exec+0x1c4>
  sz = sz1;
    80004f7e:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f82:	4a81                	li	s5,0
    80004f84:	a84d                	j	80005036 <exec+0x2d6>
  sp = sz;
    80004f86:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004f88:	4481                	li	s1,0
  ustack[argc] = 0;
    80004f8a:	00349793          	slli	a5,s1,0x3
    80004f8e:	f9040713          	addi	a4,s0,-112
    80004f92:	97ba                	add	a5,a5,a4
    80004f94:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdc580>
  sp -= (argc+1) * sizeof(uint64);
    80004f98:	00148693          	addi	a3,s1,1
    80004f9c:	068e                	slli	a3,a3,0x3
    80004f9e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004fa2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004fa6:	01597663          	bgeu	s2,s5,80004fb2 <exec+0x252>
  sz = sz1;
    80004faa:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004fae:	4a81                	li	s5,0
    80004fb0:	a059                	j	80005036 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004fb2:	e9040613          	addi	a2,s0,-368
    80004fb6:	85ca                	mv	a1,s2
    80004fb8:	855a                	mv	a0,s6
    80004fba:	ffffc097          	auipc	ra,0xffffc
    80004fbe:	6ae080e7          	jalr	1710(ra) # 80001668 <copyout>
    80004fc2:	0a054963          	bltz	a0,80005074 <exec+0x314>
  p->trapframe->a1 = sp;
    80004fc6:	080bb783          	ld	a5,128(s7) # 1080 <_entry-0x7fffef80>
    80004fca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004fce:	de843783          	ld	a5,-536(s0)
    80004fd2:	0007c703          	lbu	a4,0(a5)
    80004fd6:	cf11                	beqz	a4,80004ff2 <exec+0x292>
    80004fd8:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004fda:	02f00693          	li	a3,47
    80004fde:	a039                	j	80004fec <exec+0x28c>
      last = s+1;
    80004fe0:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004fe4:	0785                	addi	a5,a5,1
    80004fe6:	fff7c703          	lbu	a4,-1(a5)
    80004fea:	c701                	beqz	a4,80004ff2 <exec+0x292>
    if(*s == '/')
    80004fec:	fed71ce3          	bne	a4,a3,80004fe4 <exec+0x284>
    80004ff0:	bfc5                	j	80004fe0 <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ff2:	4641                	li	a2,16
    80004ff4:	de843583          	ld	a1,-536(s0)
    80004ff8:	180b8513          	addi	a0,s7,384
    80004ffc:	ffffc097          	auipc	ra,0xffffc
    80005000:	e20080e7          	jalr	-480(ra) # 80000e1c <safestrcpy>
  oldpagetable = p->pagetable;
    80005004:	078bb503          	ld	a0,120(s7)
  p->pagetable = pagetable;
    80005008:	076bbc23          	sd	s6,120(s7)
  p->sz = sz;
    8000500c:	078bb823          	sd	s8,112(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005010:	080bb783          	ld	a5,128(s7)
    80005014:	e6843703          	ld	a4,-408(s0)
    80005018:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000501a:	080bb783          	ld	a5,128(s7)
    8000501e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005022:	85ea                	mv	a1,s10
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	ae8080e7          	jalr	-1304(ra) # 80001b0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000502c:	0004851b          	sext.w	a0,s1
    80005030:	b3f1                	j	80004dfc <exec+0x9c>
    80005032:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005036:	df843583          	ld	a1,-520(s0)
    8000503a:	855a                	mv	a0,s6
    8000503c:	ffffd097          	auipc	ra,0xffffd
    80005040:	ad0080e7          	jalr	-1328(ra) # 80001b0c <proc_freepagetable>
  if(ip){
    80005044:	da0a92e3          	bnez	s5,80004de8 <exec+0x88>
  return -1;
    80005048:	557d                	li	a0,-1
    8000504a:	bb4d                	j	80004dfc <exec+0x9c>
    8000504c:	df243c23          	sd	s2,-520(s0)
    80005050:	b7dd                	j	80005036 <exec+0x2d6>
    80005052:	df243c23          	sd	s2,-520(s0)
    80005056:	b7c5                	j	80005036 <exec+0x2d6>
    80005058:	df243c23          	sd	s2,-520(s0)
    8000505c:	bfe9                	j	80005036 <exec+0x2d6>
    8000505e:	df243c23          	sd	s2,-520(s0)
    80005062:	bfd1                	j	80005036 <exec+0x2d6>
  sz = sz1;
    80005064:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005068:	4a81                	li	s5,0
    8000506a:	b7f1                	j	80005036 <exec+0x2d6>
  sz = sz1;
    8000506c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005070:	4a81                	li	s5,0
    80005072:	b7d1                	j	80005036 <exec+0x2d6>
  sz = sz1;
    80005074:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005078:	4a81                	li	s5,0
    8000507a:	bf75                	j	80005036 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000507c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005080:	e0843783          	ld	a5,-504(s0)
    80005084:	0017869b          	addiw	a3,a5,1
    80005088:	e0d43423          	sd	a3,-504(s0)
    8000508c:	e0043783          	ld	a5,-512(s0)
    80005090:	0387879b          	addiw	a5,a5,56
    80005094:	e8845703          	lhu	a4,-376(s0)
    80005098:	e0e6dee3          	bge	a3,a4,80004eb4 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000509c:	2781                	sext.w	a5,a5
    8000509e:	e0f43023          	sd	a5,-512(s0)
    800050a2:	03800713          	li	a4,56
    800050a6:	86be                	mv	a3,a5
    800050a8:	e1840613          	addi	a2,s0,-488
    800050ac:	4581                	li	a1,0
    800050ae:	8556                	mv	a0,s5
    800050b0:	fffff097          	auipc	ra,0xfffff
    800050b4:	a5c080e7          	jalr	-1444(ra) # 80003b0c <readi>
    800050b8:	03800793          	li	a5,56
    800050bc:	f6f51be3          	bne	a0,a5,80005032 <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800050c0:	e1842783          	lw	a5,-488(s0)
    800050c4:	4705                	li	a4,1
    800050c6:	fae79de3          	bne	a5,a4,80005080 <exec+0x320>
    if(ph.memsz < ph.filesz)
    800050ca:	e4043483          	ld	s1,-448(s0)
    800050ce:	e3843783          	ld	a5,-456(s0)
    800050d2:	f6f4ede3          	bltu	s1,a5,8000504c <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800050d6:	e2843783          	ld	a5,-472(s0)
    800050da:	94be                	add	s1,s1,a5
    800050dc:	f6f4ebe3          	bltu	s1,a5,80005052 <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800050e0:	de043703          	ld	a4,-544(s0)
    800050e4:	8ff9                	and	a5,a5,a4
    800050e6:	fbad                	bnez	a5,80005058 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800050e8:	e1c42503          	lw	a0,-484(s0)
    800050ec:	00000097          	auipc	ra,0x0
    800050f0:	c58080e7          	jalr	-936(ra) # 80004d44 <flags2perm>
    800050f4:	86aa                	mv	a3,a0
    800050f6:	8626                	mv	a2,s1
    800050f8:	85ca                	mv	a1,s2
    800050fa:	855a                	mv	a0,s6
    800050fc:	ffffc097          	auipc	ra,0xffffc
    80005100:	314080e7          	jalr	788(ra) # 80001410 <uvmalloc>
    80005104:	dea43c23          	sd	a0,-520(s0)
    80005108:	d939                	beqz	a0,8000505e <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000510a:	e2843c03          	ld	s8,-472(s0)
    8000510e:	e2042c83          	lw	s9,-480(s0)
    80005112:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005116:	f60b83e3          	beqz	s7,8000507c <exec+0x31c>
    8000511a:	89de                	mv	s3,s7
    8000511c:	4481                	li	s1,0
    8000511e:	bb95                	j	80004e92 <exec+0x132>

0000000080005120 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005120:	7179                	addi	sp,sp,-48
    80005122:	f406                	sd	ra,40(sp)
    80005124:	f022                	sd	s0,32(sp)
    80005126:	ec26                	sd	s1,24(sp)
    80005128:	e84a                	sd	s2,16(sp)
    8000512a:	1800                	addi	s0,sp,48
    8000512c:	892e                	mv	s2,a1
    8000512e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005130:	fdc40593          	addi	a1,s0,-36
    80005134:	ffffe097          	auipc	ra,0xffffe
    80005138:	b4c080e7          	jalr	-1204(ra) # 80002c80 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000513c:	fdc42703          	lw	a4,-36(s0)
    80005140:	47bd                	li	a5,15
    80005142:	02e7eb63          	bltu	a5,a4,80005178 <argfd+0x58>
    80005146:	ffffd097          	auipc	ra,0xffffd
    8000514a:	866080e7          	jalr	-1946(ra) # 800019ac <myproc>
    8000514e:	fdc42703          	lw	a4,-36(s0)
    80005152:	01e70793          	addi	a5,a4,30
    80005156:	078e                	slli	a5,a5,0x3
    80005158:	953e                	add	a0,a0,a5
    8000515a:	651c                	ld	a5,8(a0)
    8000515c:	c385                	beqz	a5,8000517c <argfd+0x5c>
    return -1;
  if(pfd)
    8000515e:	00090463          	beqz	s2,80005166 <argfd+0x46>
    *pfd = fd;
    80005162:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005166:	4501                	li	a0,0
  if(pf)
    80005168:	c091                	beqz	s1,8000516c <argfd+0x4c>
    *pf = f;
    8000516a:	e09c                	sd	a5,0(s1)
}
    8000516c:	70a2                	ld	ra,40(sp)
    8000516e:	7402                	ld	s0,32(sp)
    80005170:	64e2                	ld	s1,24(sp)
    80005172:	6942                	ld	s2,16(sp)
    80005174:	6145                	addi	sp,sp,48
    80005176:	8082                	ret
    return -1;
    80005178:	557d                	li	a0,-1
    8000517a:	bfcd                	j	8000516c <argfd+0x4c>
    8000517c:	557d                	li	a0,-1
    8000517e:	b7fd                	j	8000516c <argfd+0x4c>

0000000080005180 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005180:	1101                	addi	sp,sp,-32
    80005182:	ec06                	sd	ra,24(sp)
    80005184:	e822                	sd	s0,16(sp)
    80005186:	e426                	sd	s1,8(sp)
    80005188:	1000                	addi	s0,sp,32
    8000518a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000518c:	ffffd097          	auipc	ra,0xffffd
    80005190:	820080e7          	jalr	-2016(ra) # 800019ac <myproc>
    80005194:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005196:	0f850793          	addi	a5,a0,248
    8000519a:	4501                	li	a0,0
    8000519c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000519e:	6398                	ld	a4,0(a5)
    800051a0:	cb19                	beqz	a4,800051b6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800051a2:	2505                	addiw	a0,a0,1
    800051a4:	07a1                	addi	a5,a5,8
    800051a6:	fed51ce3          	bne	a0,a3,8000519e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800051aa:	557d                	li	a0,-1
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret
      p->ofile[fd] = f;
    800051b6:	01e50793          	addi	a5,a0,30
    800051ba:	078e                	slli	a5,a5,0x3
    800051bc:	963e                	add	a2,a2,a5
    800051be:	e604                	sd	s1,8(a2)
      return fd;
    800051c0:	b7f5                	j	800051ac <fdalloc+0x2c>

00000000800051c2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800051c2:	715d                	addi	sp,sp,-80
    800051c4:	e486                	sd	ra,72(sp)
    800051c6:	e0a2                	sd	s0,64(sp)
    800051c8:	fc26                	sd	s1,56(sp)
    800051ca:	f84a                	sd	s2,48(sp)
    800051cc:	f44e                	sd	s3,40(sp)
    800051ce:	f052                	sd	s4,32(sp)
    800051d0:	ec56                	sd	s5,24(sp)
    800051d2:	e85a                	sd	s6,16(sp)
    800051d4:	0880                	addi	s0,sp,80
    800051d6:	8b2e                	mv	s6,a1
    800051d8:	89b2                	mv	s3,a2
    800051da:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800051dc:	fb040593          	addi	a1,s0,-80
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	e3c080e7          	jalr	-452(ra) # 8000401c <nameiparent>
    800051e8:	84aa                	mv	s1,a0
    800051ea:	14050f63          	beqz	a0,80005348 <create+0x186>
    return 0;

  ilock(dp);
    800051ee:	ffffe097          	auipc	ra,0xffffe
    800051f2:	66a080e7          	jalr	1642(ra) # 80003858 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800051f6:	4601                	li	a2,0
    800051f8:	fb040593          	addi	a1,s0,-80
    800051fc:	8526                	mv	a0,s1
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	b3e080e7          	jalr	-1218(ra) # 80003d3c <dirlookup>
    80005206:	8aaa                	mv	s5,a0
    80005208:	c931                	beqz	a0,8000525c <create+0x9a>
    iunlockput(dp);
    8000520a:	8526                	mv	a0,s1
    8000520c:	fffff097          	auipc	ra,0xfffff
    80005210:	8ae080e7          	jalr	-1874(ra) # 80003aba <iunlockput>
    ilock(ip);
    80005214:	8556                	mv	a0,s5
    80005216:	ffffe097          	auipc	ra,0xffffe
    8000521a:	642080e7          	jalr	1602(ra) # 80003858 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000521e:	000b059b          	sext.w	a1,s6
    80005222:	4789                	li	a5,2
    80005224:	02f59563          	bne	a1,a5,8000524e <create+0x8c>
    80005228:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdc6c4>
    8000522c:	37f9                	addiw	a5,a5,-2
    8000522e:	17c2                	slli	a5,a5,0x30
    80005230:	93c1                	srli	a5,a5,0x30
    80005232:	4705                	li	a4,1
    80005234:	00f76d63          	bltu	a4,a5,8000524e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005238:	8556                	mv	a0,s5
    8000523a:	60a6                	ld	ra,72(sp)
    8000523c:	6406                	ld	s0,64(sp)
    8000523e:	74e2                	ld	s1,56(sp)
    80005240:	7942                	ld	s2,48(sp)
    80005242:	79a2                	ld	s3,40(sp)
    80005244:	7a02                	ld	s4,32(sp)
    80005246:	6ae2                	ld	s5,24(sp)
    80005248:	6b42                	ld	s6,16(sp)
    8000524a:	6161                	addi	sp,sp,80
    8000524c:	8082                	ret
    iunlockput(ip);
    8000524e:	8556                	mv	a0,s5
    80005250:	fffff097          	auipc	ra,0xfffff
    80005254:	86a080e7          	jalr	-1942(ra) # 80003aba <iunlockput>
    return 0;
    80005258:	4a81                	li	s5,0
    8000525a:	bff9                	j	80005238 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000525c:	85da                	mv	a1,s6
    8000525e:	4088                	lw	a0,0(s1)
    80005260:	ffffe097          	auipc	ra,0xffffe
    80005264:	45c080e7          	jalr	1116(ra) # 800036bc <ialloc>
    80005268:	8a2a                	mv	s4,a0
    8000526a:	c539                	beqz	a0,800052b8 <create+0xf6>
  ilock(ip);
    8000526c:	ffffe097          	auipc	ra,0xffffe
    80005270:	5ec080e7          	jalr	1516(ra) # 80003858 <ilock>
  ip->major = major;
    80005274:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005278:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000527c:	4905                	li	s2,1
    8000527e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005282:	8552                	mv	a0,s4
    80005284:	ffffe097          	auipc	ra,0xffffe
    80005288:	50a080e7          	jalr	1290(ra) # 8000378e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000528c:	000b059b          	sext.w	a1,s6
    80005290:	03258b63          	beq	a1,s2,800052c6 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80005294:	004a2603          	lw	a2,4(s4)
    80005298:	fb040593          	addi	a1,s0,-80
    8000529c:	8526                	mv	a0,s1
    8000529e:	fffff097          	auipc	ra,0xfffff
    800052a2:	cae080e7          	jalr	-850(ra) # 80003f4c <dirlink>
    800052a6:	06054f63          	bltz	a0,80005324 <create+0x162>
  iunlockput(dp);
    800052aa:	8526                	mv	a0,s1
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	80e080e7          	jalr	-2034(ra) # 80003aba <iunlockput>
  return ip;
    800052b4:	8ad2                	mv	s5,s4
    800052b6:	b749                	j	80005238 <create+0x76>
    iunlockput(dp);
    800052b8:	8526                	mv	a0,s1
    800052ba:	fffff097          	auipc	ra,0xfffff
    800052be:	800080e7          	jalr	-2048(ra) # 80003aba <iunlockput>
    return 0;
    800052c2:	8ad2                	mv	s5,s4
    800052c4:	bf95                	j	80005238 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800052c6:	004a2603          	lw	a2,4(s4)
    800052ca:	00003597          	auipc	a1,0x3
    800052ce:	44658593          	addi	a1,a1,1094 # 80008710 <syscalls+0x2b0>
    800052d2:	8552                	mv	a0,s4
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	c78080e7          	jalr	-904(ra) # 80003f4c <dirlink>
    800052dc:	04054463          	bltz	a0,80005324 <create+0x162>
    800052e0:	40d0                	lw	a2,4(s1)
    800052e2:	00003597          	auipc	a1,0x3
    800052e6:	43658593          	addi	a1,a1,1078 # 80008718 <syscalls+0x2b8>
    800052ea:	8552                	mv	a0,s4
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	c60080e7          	jalr	-928(ra) # 80003f4c <dirlink>
    800052f4:	02054863          	bltz	a0,80005324 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800052f8:	004a2603          	lw	a2,4(s4)
    800052fc:	fb040593          	addi	a1,s0,-80
    80005300:	8526                	mv	a0,s1
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	c4a080e7          	jalr	-950(ra) # 80003f4c <dirlink>
    8000530a:	00054d63          	bltz	a0,80005324 <create+0x162>
    dp->nlink++;  // for ".."
    8000530e:	04a4d783          	lhu	a5,74(s1)
    80005312:	2785                	addiw	a5,a5,1
    80005314:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005318:	8526                	mv	a0,s1
    8000531a:	ffffe097          	auipc	ra,0xffffe
    8000531e:	474080e7          	jalr	1140(ra) # 8000378e <iupdate>
    80005322:	b761                	j	800052aa <create+0xe8>
  ip->nlink = 0;
    80005324:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005328:	8552                	mv	a0,s4
    8000532a:	ffffe097          	auipc	ra,0xffffe
    8000532e:	464080e7          	jalr	1124(ra) # 8000378e <iupdate>
  iunlockput(ip);
    80005332:	8552                	mv	a0,s4
    80005334:	ffffe097          	auipc	ra,0xffffe
    80005338:	786080e7          	jalr	1926(ra) # 80003aba <iunlockput>
  iunlockput(dp);
    8000533c:	8526                	mv	a0,s1
    8000533e:	ffffe097          	auipc	ra,0xffffe
    80005342:	77c080e7          	jalr	1916(ra) # 80003aba <iunlockput>
  return 0;
    80005346:	bdcd                	j	80005238 <create+0x76>
    return 0;
    80005348:	8aaa                	mv	s5,a0
    8000534a:	b5fd                	j	80005238 <create+0x76>

000000008000534c <sys_dup>:
{
    8000534c:	7179                	addi	sp,sp,-48
    8000534e:	f406                	sd	ra,40(sp)
    80005350:	f022                	sd	s0,32(sp)
    80005352:	ec26                	sd	s1,24(sp)
    80005354:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005356:	fd840613          	addi	a2,s0,-40
    8000535a:	4581                	li	a1,0
    8000535c:	4501                	li	a0,0
    8000535e:	00000097          	auipc	ra,0x0
    80005362:	dc2080e7          	jalr	-574(ra) # 80005120 <argfd>
    return -1;
    80005366:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005368:	02054363          	bltz	a0,8000538e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000536c:	fd843503          	ld	a0,-40(s0)
    80005370:	00000097          	auipc	ra,0x0
    80005374:	e10080e7          	jalr	-496(ra) # 80005180 <fdalloc>
    80005378:	84aa                	mv	s1,a0
    return -1;
    8000537a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000537c:	00054963          	bltz	a0,8000538e <sys_dup+0x42>
  filedup(f);
    80005380:	fd843503          	ld	a0,-40(s0)
    80005384:	fffff097          	auipc	ra,0xfffff
    80005388:	310080e7          	jalr	784(ra) # 80004694 <filedup>
  return fd;
    8000538c:	87a6                	mv	a5,s1
}
    8000538e:	853e                	mv	a0,a5
    80005390:	70a2                	ld	ra,40(sp)
    80005392:	7402                	ld	s0,32(sp)
    80005394:	64e2                	ld	s1,24(sp)
    80005396:	6145                	addi	sp,sp,48
    80005398:	8082                	ret

000000008000539a <sys_read>:
{
    8000539a:	7179                	addi	sp,sp,-48
    8000539c:	f406                	sd	ra,40(sp)
    8000539e:	f022                	sd	s0,32(sp)
    800053a0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800053a2:	fd840593          	addi	a1,s0,-40
    800053a6:	4505                	li	a0,1
    800053a8:	ffffe097          	auipc	ra,0xffffe
    800053ac:	8f8080e7          	jalr	-1800(ra) # 80002ca0 <argaddr>
  argint(2, &n);
    800053b0:	fe440593          	addi	a1,s0,-28
    800053b4:	4509                	li	a0,2
    800053b6:	ffffe097          	auipc	ra,0xffffe
    800053ba:	8ca080e7          	jalr	-1846(ra) # 80002c80 <argint>
  if(argfd(0, 0, &f) < 0)
    800053be:	fe840613          	addi	a2,s0,-24
    800053c2:	4581                	li	a1,0
    800053c4:	4501                	li	a0,0
    800053c6:	00000097          	auipc	ra,0x0
    800053ca:	d5a080e7          	jalr	-678(ra) # 80005120 <argfd>
    800053ce:	87aa                	mv	a5,a0
    return -1;
    800053d0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800053d2:	0007cc63          	bltz	a5,800053ea <sys_read+0x50>
  return fileread(f, p, n);
    800053d6:	fe442603          	lw	a2,-28(s0)
    800053da:	fd843583          	ld	a1,-40(s0)
    800053de:	fe843503          	ld	a0,-24(s0)
    800053e2:	fffff097          	auipc	ra,0xfffff
    800053e6:	43e080e7          	jalr	1086(ra) # 80004820 <fileread>
}
    800053ea:	70a2                	ld	ra,40(sp)
    800053ec:	7402                	ld	s0,32(sp)
    800053ee:	6145                	addi	sp,sp,48
    800053f0:	8082                	ret

00000000800053f2 <sys_write>:
{
    800053f2:	7179                	addi	sp,sp,-48
    800053f4:	f406                	sd	ra,40(sp)
    800053f6:	f022                	sd	s0,32(sp)
    800053f8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800053fa:	fd840593          	addi	a1,s0,-40
    800053fe:	4505                	li	a0,1
    80005400:	ffffe097          	auipc	ra,0xffffe
    80005404:	8a0080e7          	jalr	-1888(ra) # 80002ca0 <argaddr>
  argint(2, &n);
    80005408:	fe440593          	addi	a1,s0,-28
    8000540c:	4509                	li	a0,2
    8000540e:	ffffe097          	auipc	ra,0xffffe
    80005412:	872080e7          	jalr	-1934(ra) # 80002c80 <argint>
  if(argfd(0, 0, &f) < 0)
    80005416:	fe840613          	addi	a2,s0,-24
    8000541a:	4581                	li	a1,0
    8000541c:	4501                	li	a0,0
    8000541e:	00000097          	auipc	ra,0x0
    80005422:	d02080e7          	jalr	-766(ra) # 80005120 <argfd>
    80005426:	87aa                	mv	a5,a0
    return -1;
    80005428:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000542a:	0007cc63          	bltz	a5,80005442 <sys_write+0x50>
  return filewrite(f, p, n);
    8000542e:	fe442603          	lw	a2,-28(s0)
    80005432:	fd843583          	ld	a1,-40(s0)
    80005436:	fe843503          	ld	a0,-24(s0)
    8000543a:	fffff097          	auipc	ra,0xfffff
    8000543e:	4a8080e7          	jalr	1192(ra) # 800048e2 <filewrite>
}
    80005442:	70a2                	ld	ra,40(sp)
    80005444:	7402                	ld	s0,32(sp)
    80005446:	6145                	addi	sp,sp,48
    80005448:	8082                	ret

000000008000544a <sys_close>:
{
    8000544a:	1101                	addi	sp,sp,-32
    8000544c:	ec06                	sd	ra,24(sp)
    8000544e:	e822                	sd	s0,16(sp)
    80005450:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005452:	fe040613          	addi	a2,s0,-32
    80005456:	fec40593          	addi	a1,s0,-20
    8000545a:	4501                	li	a0,0
    8000545c:	00000097          	auipc	ra,0x0
    80005460:	cc4080e7          	jalr	-828(ra) # 80005120 <argfd>
    return -1;
    80005464:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005466:	02054463          	bltz	a0,8000548e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000546a:	ffffc097          	auipc	ra,0xffffc
    8000546e:	542080e7          	jalr	1346(ra) # 800019ac <myproc>
    80005472:	fec42783          	lw	a5,-20(s0)
    80005476:	07f9                	addi	a5,a5,30
    80005478:	078e                	slli	a5,a5,0x3
    8000547a:	97aa                	add	a5,a5,a0
    8000547c:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80005480:	fe043503          	ld	a0,-32(s0)
    80005484:	fffff097          	auipc	ra,0xfffff
    80005488:	262080e7          	jalr	610(ra) # 800046e6 <fileclose>
  return 0;
    8000548c:	4781                	li	a5,0
}
    8000548e:	853e                	mv	a0,a5
    80005490:	60e2                	ld	ra,24(sp)
    80005492:	6442                	ld	s0,16(sp)
    80005494:	6105                	addi	sp,sp,32
    80005496:	8082                	ret

0000000080005498 <sys_fstat>:
{
    80005498:	1101                	addi	sp,sp,-32
    8000549a:	ec06                	sd	ra,24(sp)
    8000549c:	e822                	sd	s0,16(sp)
    8000549e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800054a0:	fe040593          	addi	a1,s0,-32
    800054a4:	4505                	li	a0,1
    800054a6:	ffffd097          	auipc	ra,0xffffd
    800054aa:	7fa080e7          	jalr	2042(ra) # 80002ca0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800054ae:	fe840613          	addi	a2,s0,-24
    800054b2:	4581                	li	a1,0
    800054b4:	4501                	li	a0,0
    800054b6:	00000097          	auipc	ra,0x0
    800054ba:	c6a080e7          	jalr	-918(ra) # 80005120 <argfd>
    800054be:	87aa                	mv	a5,a0
    return -1;
    800054c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800054c2:	0007ca63          	bltz	a5,800054d6 <sys_fstat+0x3e>
  return filestat(f, st);
    800054c6:	fe043583          	ld	a1,-32(s0)
    800054ca:	fe843503          	ld	a0,-24(s0)
    800054ce:	fffff097          	auipc	ra,0xfffff
    800054d2:	2e0080e7          	jalr	736(ra) # 800047ae <filestat>
}
    800054d6:	60e2                	ld	ra,24(sp)
    800054d8:	6442                	ld	s0,16(sp)
    800054da:	6105                	addi	sp,sp,32
    800054dc:	8082                	ret

00000000800054de <sys_link>:
{
    800054de:	7169                	addi	sp,sp,-304
    800054e0:	f606                	sd	ra,296(sp)
    800054e2:	f222                	sd	s0,288(sp)
    800054e4:	ee26                	sd	s1,280(sp)
    800054e6:	ea4a                	sd	s2,272(sp)
    800054e8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054ea:	08000613          	li	a2,128
    800054ee:	ed040593          	addi	a1,s0,-304
    800054f2:	4501                	li	a0,0
    800054f4:	ffffd097          	auipc	ra,0xffffd
    800054f8:	7cc080e7          	jalr	1996(ra) # 80002cc0 <argstr>
    return -1;
    800054fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800054fe:	10054e63          	bltz	a0,8000561a <sys_link+0x13c>
    80005502:	08000613          	li	a2,128
    80005506:	f5040593          	addi	a1,s0,-176
    8000550a:	4505                	li	a0,1
    8000550c:	ffffd097          	auipc	ra,0xffffd
    80005510:	7b4080e7          	jalr	1972(ra) # 80002cc0 <argstr>
    return -1;
    80005514:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005516:	10054263          	bltz	a0,8000561a <sys_link+0x13c>
  begin_op();
    8000551a:	fffff097          	auipc	ra,0xfffff
    8000551e:	d00080e7          	jalr	-768(ra) # 8000421a <begin_op>
  if((ip = namei(old)) == 0){
    80005522:	ed040513          	addi	a0,s0,-304
    80005526:	fffff097          	auipc	ra,0xfffff
    8000552a:	ad8080e7          	jalr	-1320(ra) # 80003ffe <namei>
    8000552e:	84aa                	mv	s1,a0
    80005530:	c551                	beqz	a0,800055bc <sys_link+0xde>
  ilock(ip);
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	326080e7          	jalr	806(ra) # 80003858 <ilock>
  if(ip->type == T_DIR){
    8000553a:	04449703          	lh	a4,68(s1)
    8000553e:	4785                	li	a5,1
    80005540:	08f70463          	beq	a4,a5,800055c8 <sys_link+0xea>
  ip->nlink++;
    80005544:	04a4d783          	lhu	a5,74(s1)
    80005548:	2785                	addiw	a5,a5,1
    8000554a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000554e:	8526                	mv	a0,s1
    80005550:	ffffe097          	auipc	ra,0xffffe
    80005554:	23e080e7          	jalr	574(ra) # 8000378e <iupdate>
  iunlock(ip);
    80005558:	8526                	mv	a0,s1
    8000555a:	ffffe097          	auipc	ra,0xffffe
    8000555e:	3c0080e7          	jalr	960(ra) # 8000391a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005562:	fd040593          	addi	a1,s0,-48
    80005566:	f5040513          	addi	a0,s0,-176
    8000556a:	fffff097          	auipc	ra,0xfffff
    8000556e:	ab2080e7          	jalr	-1358(ra) # 8000401c <nameiparent>
    80005572:	892a                	mv	s2,a0
    80005574:	c935                	beqz	a0,800055e8 <sys_link+0x10a>
  ilock(dp);
    80005576:	ffffe097          	auipc	ra,0xffffe
    8000557a:	2e2080e7          	jalr	738(ra) # 80003858 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000557e:	00092703          	lw	a4,0(s2)
    80005582:	409c                	lw	a5,0(s1)
    80005584:	04f71d63          	bne	a4,a5,800055de <sys_link+0x100>
    80005588:	40d0                	lw	a2,4(s1)
    8000558a:	fd040593          	addi	a1,s0,-48
    8000558e:	854a                	mv	a0,s2
    80005590:	fffff097          	auipc	ra,0xfffff
    80005594:	9bc080e7          	jalr	-1604(ra) # 80003f4c <dirlink>
    80005598:	04054363          	bltz	a0,800055de <sys_link+0x100>
  iunlockput(dp);
    8000559c:	854a                	mv	a0,s2
    8000559e:	ffffe097          	auipc	ra,0xffffe
    800055a2:	51c080e7          	jalr	1308(ra) # 80003aba <iunlockput>
  iput(ip);
    800055a6:	8526                	mv	a0,s1
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	46a080e7          	jalr	1130(ra) # 80003a12 <iput>
  end_op();
    800055b0:	fffff097          	auipc	ra,0xfffff
    800055b4:	cea080e7          	jalr	-790(ra) # 8000429a <end_op>
  return 0;
    800055b8:	4781                	li	a5,0
    800055ba:	a085                	j	8000561a <sys_link+0x13c>
    end_op();
    800055bc:	fffff097          	auipc	ra,0xfffff
    800055c0:	cde080e7          	jalr	-802(ra) # 8000429a <end_op>
    return -1;
    800055c4:	57fd                	li	a5,-1
    800055c6:	a891                	j	8000561a <sys_link+0x13c>
    iunlockput(ip);
    800055c8:	8526                	mv	a0,s1
    800055ca:	ffffe097          	auipc	ra,0xffffe
    800055ce:	4f0080e7          	jalr	1264(ra) # 80003aba <iunlockput>
    end_op();
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	cc8080e7          	jalr	-824(ra) # 8000429a <end_op>
    return -1;
    800055da:	57fd                	li	a5,-1
    800055dc:	a83d                	j	8000561a <sys_link+0x13c>
    iunlockput(dp);
    800055de:	854a                	mv	a0,s2
    800055e0:	ffffe097          	auipc	ra,0xffffe
    800055e4:	4da080e7          	jalr	1242(ra) # 80003aba <iunlockput>
  ilock(ip);
    800055e8:	8526                	mv	a0,s1
    800055ea:	ffffe097          	auipc	ra,0xffffe
    800055ee:	26e080e7          	jalr	622(ra) # 80003858 <ilock>
  ip->nlink--;
    800055f2:	04a4d783          	lhu	a5,74(s1)
    800055f6:	37fd                	addiw	a5,a5,-1
    800055f8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800055fc:	8526                	mv	a0,s1
    800055fe:	ffffe097          	auipc	ra,0xffffe
    80005602:	190080e7          	jalr	400(ra) # 8000378e <iupdate>
  iunlockput(ip);
    80005606:	8526                	mv	a0,s1
    80005608:	ffffe097          	auipc	ra,0xffffe
    8000560c:	4b2080e7          	jalr	1202(ra) # 80003aba <iunlockput>
  end_op();
    80005610:	fffff097          	auipc	ra,0xfffff
    80005614:	c8a080e7          	jalr	-886(ra) # 8000429a <end_op>
  return -1;
    80005618:	57fd                	li	a5,-1
}
    8000561a:	853e                	mv	a0,a5
    8000561c:	70b2                	ld	ra,296(sp)
    8000561e:	7412                	ld	s0,288(sp)
    80005620:	64f2                	ld	s1,280(sp)
    80005622:	6952                	ld	s2,272(sp)
    80005624:	6155                	addi	sp,sp,304
    80005626:	8082                	ret

0000000080005628 <sys_unlink>:
{
    80005628:	7151                	addi	sp,sp,-240
    8000562a:	f586                	sd	ra,232(sp)
    8000562c:	f1a2                	sd	s0,224(sp)
    8000562e:	eda6                	sd	s1,216(sp)
    80005630:	e9ca                	sd	s2,208(sp)
    80005632:	e5ce                	sd	s3,200(sp)
    80005634:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005636:	08000613          	li	a2,128
    8000563a:	f3040593          	addi	a1,s0,-208
    8000563e:	4501                	li	a0,0
    80005640:	ffffd097          	auipc	ra,0xffffd
    80005644:	680080e7          	jalr	1664(ra) # 80002cc0 <argstr>
    80005648:	18054163          	bltz	a0,800057ca <sys_unlink+0x1a2>
  begin_op();
    8000564c:	fffff097          	auipc	ra,0xfffff
    80005650:	bce080e7          	jalr	-1074(ra) # 8000421a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005654:	fb040593          	addi	a1,s0,-80
    80005658:	f3040513          	addi	a0,s0,-208
    8000565c:	fffff097          	auipc	ra,0xfffff
    80005660:	9c0080e7          	jalr	-1600(ra) # 8000401c <nameiparent>
    80005664:	84aa                	mv	s1,a0
    80005666:	c979                	beqz	a0,8000573c <sys_unlink+0x114>
  ilock(dp);
    80005668:	ffffe097          	auipc	ra,0xffffe
    8000566c:	1f0080e7          	jalr	496(ra) # 80003858 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005670:	00003597          	auipc	a1,0x3
    80005674:	0a058593          	addi	a1,a1,160 # 80008710 <syscalls+0x2b0>
    80005678:	fb040513          	addi	a0,s0,-80
    8000567c:	ffffe097          	auipc	ra,0xffffe
    80005680:	6a6080e7          	jalr	1702(ra) # 80003d22 <namecmp>
    80005684:	14050a63          	beqz	a0,800057d8 <sys_unlink+0x1b0>
    80005688:	00003597          	auipc	a1,0x3
    8000568c:	09058593          	addi	a1,a1,144 # 80008718 <syscalls+0x2b8>
    80005690:	fb040513          	addi	a0,s0,-80
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	68e080e7          	jalr	1678(ra) # 80003d22 <namecmp>
    8000569c:	12050e63          	beqz	a0,800057d8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800056a0:	f2c40613          	addi	a2,s0,-212
    800056a4:	fb040593          	addi	a1,s0,-80
    800056a8:	8526                	mv	a0,s1
    800056aa:	ffffe097          	auipc	ra,0xffffe
    800056ae:	692080e7          	jalr	1682(ra) # 80003d3c <dirlookup>
    800056b2:	892a                	mv	s2,a0
    800056b4:	12050263          	beqz	a0,800057d8 <sys_unlink+0x1b0>
  ilock(ip);
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	1a0080e7          	jalr	416(ra) # 80003858 <ilock>
  if(ip->nlink < 1)
    800056c0:	04a91783          	lh	a5,74(s2)
    800056c4:	08f05263          	blez	a5,80005748 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800056c8:	04491703          	lh	a4,68(s2)
    800056cc:	4785                	li	a5,1
    800056ce:	08f70563          	beq	a4,a5,80005758 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800056d2:	4641                	li	a2,16
    800056d4:	4581                	li	a1,0
    800056d6:	fc040513          	addi	a0,s0,-64
    800056da:	ffffb097          	auipc	ra,0xffffb
    800056de:	5f8080e7          	jalr	1528(ra) # 80000cd2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800056e2:	4741                	li	a4,16
    800056e4:	f2c42683          	lw	a3,-212(s0)
    800056e8:	fc040613          	addi	a2,s0,-64
    800056ec:	4581                	li	a1,0
    800056ee:	8526                	mv	a0,s1
    800056f0:	ffffe097          	auipc	ra,0xffffe
    800056f4:	514080e7          	jalr	1300(ra) # 80003c04 <writei>
    800056f8:	47c1                	li	a5,16
    800056fa:	0af51563          	bne	a0,a5,800057a4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800056fe:	04491703          	lh	a4,68(s2)
    80005702:	4785                	li	a5,1
    80005704:	0af70863          	beq	a4,a5,800057b4 <sys_unlink+0x18c>
  iunlockput(dp);
    80005708:	8526                	mv	a0,s1
    8000570a:	ffffe097          	auipc	ra,0xffffe
    8000570e:	3b0080e7          	jalr	944(ra) # 80003aba <iunlockput>
  ip->nlink--;
    80005712:	04a95783          	lhu	a5,74(s2)
    80005716:	37fd                	addiw	a5,a5,-1
    80005718:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000571c:	854a                	mv	a0,s2
    8000571e:	ffffe097          	auipc	ra,0xffffe
    80005722:	070080e7          	jalr	112(ra) # 8000378e <iupdate>
  iunlockput(ip);
    80005726:	854a                	mv	a0,s2
    80005728:	ffffe097          	auipc	ra,0xffffe
    8000572c:	392080e7          	jalr	914(ra) # 80003aba <iunlockput>
  end_op();
    80005730:	fffff097          	auipc	ra,0xfffff
    80005734:	b6a080e7          	jalr	-1174(ra) # 8000429a <end_op>
  return 0;
    80005738:	4501                	li	a0,0
    8000573a:	a84d                	j	800057ec <sys_unlink+0x1c4>
    end_op();
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	b5e080e7          	jalr	-1186(ra) # 8000429a <end_op>
    return -1;
    80005744:	557d                	li	a0,-1
    80005746:	a05d                	j	800057ec <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005748:	00003517          	auipc	a0,0x3
    8000574c:	fd850513          	addi	a0,a0,-40 # 80008720 <syscalls+0x2c0>
    80005750:	ffffb097          	auipc	ra,0xffffb
    80005754:	dee080e7          	jalr	-530(ra) # 8000053e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005758:	04c92703          	lw	a4,76(s2)
    8000575c:	02000793          	li	a5,32
    80005760:	f6e7f9e3          	bgeu	a5,a4,800056d2 <sys_unlink+0xaa>
    80005764:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005768:	4741                	li	a4,16
    8000576a:	86ce                	mv	a3,s3
    8000576c:	f1840613          	addi	a2,s0,-232
    80005770:	4581                	li	a1,0
    80005772:	854a                	mv	a0,s2
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	398080e7          	jalr	920(ra) # 80003b0c <readi>
    8000577c:	47c1                	li	a5,16
    8000577e:	00f51b63          	bne	a0,a5,80005794 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005782:	f1845783          	lhu	a5,-232(s0)
    80005786:	e7a1                	bnez	a5,800057ce <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005788:	29c1                	addiw	s3,s3,16
    8000578a:	04c92783          	lw	a5,76(s2)
    8000578e:	fcf9ede3          	bltu	s3,a5,80005768 <sys_unlink+0x140>
    80005792:	b781                	j	800056d2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005794:	00003517          	auipc	a0,0x3
    80005798:	fa450513          	addi	a0,a0,-92 # 80008738 <syscalls+0x2d8>
    8000579c:	ffffb097          	auipc	ra,0xffffb
    800057a0:	da2080e7          	jalr	-606(ra) # 8000053e <panic>
    panic("unlink: writei");
    800057a4:	00003517          	auipc	a0,0x3
    800057a8:	fac50513          	addi	a0,a0,-84 # 80008750 <syscalls+0x2f0>
    800057ac:	ffffb097          	auipc	ra,0xffffb
    800057b0:	d92080e7          	jalr	-622(ra) # 8000053e <panic>
    dp->nlink--;
    800057b4:	04a4d783          	lhu	a5,74(s1)
    800057b8:	37fd                	addiw	a5,a5,-1
    800057ba:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800057be:	8526                	mv	a0,s1
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	fce080e7          	jalr	-50(ra) # 8000378e <iupdate>
    800057c8:	b781                	j	80005708 <sys_unlink+0xe0>
    return -1;
    800057ca:	557d                	li	a0,-1
    800057cc:	a005                	j	800057ec <sys_unlink+0x1c4>
    iunlockput(ip);
    800057ce:	854a                	mv	a0,s2
    800057d0:	ffffe097          	auipc	ra,0xffffe
    800057d4:	2ea080e7          	jalr	746(ra) # 80003aba <iunlockput>
  iunlockput(dp);
    800057d8:	8526                	mv	a0,s1
    800057da:	ffffe097          	auipc	ra,0xffffe
    800057de:	2e0080e7          	jalr	736(ra) # 80003aba <iunlockput>
  end_op();
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	ab8080e7          	jalr	-1352(ra) # 8000429a <end_op>
  return -1;
    800057ea:	557d                	li	a0,-1
}
    800057ec:	70ae                	ld	ra,232(sp)
    800057ee:	740e                	ld	s0,224(sp)
    800057f0:	64ee                	ld	s1,216(sp)
    800057f2:	694e                	ld	s2,208(sp)
    800057f4:	69ae                	ld	s3,200(sp)
    800057f6:	616d                	addi	sp,sp,240
    800057f8:	8082                	ret

00000000800057fa <sys_open>:

uint64
sys_open(void)
{
    800057fa:	7131                	addi	sp,sp,-192
    800057fc:	fd06                	sd	ra,184(sp)
    800057fe:	f922                	sd	s0,176(sp)
    80005800:	f526                	sd	s1,168(sp)
    80005802:	f14a                	sd	s2,160(sp)
    80005804:	ed4e                	sd	s3,152(sp)
    80005806:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005808:	f4c40593          	addi	a1,s0,-180
    8000580c:	4505                	li	a0,1
    8000580e:	ffffd097          	auipc	ra,0xffffd
    80005812:	472080e7          	jalr	1138(ra) # 80002c80 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005816:	08000613          	li	a2,128
    8000581a:	f5040593          	addi	a1,s0,-176
    8000581e:	4501                	li	a0,0
    80005820:	ffffd097          	auipc	ra,0xffffd
    80005824:	4a0080e7          	jalr	1184(ra) # 80002cc0 <argstr>
    80005828:	87aa                	mv	a5,a0
    return -1;
    8000582a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000582c:	0a07c963          	bltz	a5,800058de <sys_open+0xe4>

  begin_op();
    80005830:	fffff097          	auipc	ra,0xfffff
    80005834:	9ea080e7          	jalr	-1558(ra) # 8000421a <begin_op>

  if(omode & O_CREATE){
    80005838:	f4c42783          	lw	a5,-180(s0)
    8000583c:	2007f793          	andi	a5,a5,512
    80005840:	cfc5                	beqz	a5,800058f8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005842:	4681                	li	a3,0
    80005844:	4601                	li	a2,0
    80005846:	4589                	li	a1,2
    80005848:	f5040513          	addi	a0,s0,-176
    8000584c:	00000097          	auipc	ra,0x0
    80005850:	976080e7          	jalr	-1674(ra) # 800051c2 <create>
    80005854:	84aa                	mv	s1,a0
    if(ip == 0){
    80005856:	c959                	beqz	a0,800058ec <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005858:	04449703          	lh	a4,68(s1)
    8000585c:	478d                	li	a5,3
    8000585e:	00f71763          	bne	a4,a5,8000586c <sys_open+0x72>
    80005862:	0464d703          	lhu	a4,70(s1)
    80005866:	47a5                	li	a5,9
    80005868:	0ce7ed63          	bltu	a5,a4,80005942 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000586c:	fffff097          	auipc	ra,0xfffff
    80005870:	dbe080e7          	jalr	-578(ra) # 8000462a <filealloc>
    80005874:	89aa                	mv	s3,a0
    80005876:	10050363          	beqz	a0,8000597c <sys_open+0x182>
    8000587a:	00000097          	auipc	ra,0x0
    8000587e:	906080e7          	jalr	-1786(ra) # 80005180 <fdalloc>
    80005882:	892a                	mv	s2,a0
    80005884:	0e054763          	bltz	a0,80005972 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005888:	04449703          	lh	a4,68(s1)
    8000588c:	478d                	li	a5,3
    8000588e:	0cf70563          	beq	a4,a5,80005958 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005892:	4789                	li	a5,2
    80005894:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005898:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000589c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800058a0:	f4c42783          	lw	a5,-180(s0)
    800058a4:	0017c713          	xori	a4,a5,1
    800058a8:	8b05                	andi	a4,a4,1
    800058aa:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800058ae:	0037f713          	andi	a4,a5,3
    800058b2:	00e03733          	snez	a4,a4
    800058b6:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800058ba:	4007f793          	andi	a5,a5,1024
    800058be:	c791                	beqz	a5,800058ca <sys_open+0xd0>
    800058c0:	04449703          	lh	a4,68(s1)
    800058c4:	4789                	li	a5,2
    800058c6:	0af70063          	beq	a4,a5,80005966 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800058ca:	8526                	mv	a0,s1
    800058cc:	ffffe097          	auipc	ra,0xffffe
    800058d0:	04e080e7          	jalr	78(ra) # 8000391a <iunlock>
  end_op();
    800058d4:	fffff097          	auipc	ra,0xfffff
    800058d8:	9c6080e7          	jalr	-1594(ra) # 8000429a <end_op>

  return fd;
    800058dc:	854a                	mv	a0,s2
}
    800058de:	70ea                	ld	ra,184(sp)
    800058e0:	744a                	ld	s0,176(sp)
    800058e2:	74aa                	ld	s1,168(sp)
    800058e4:	790a                	ld	s2,160(sp)
    800058e6:	69ea                	ld	s3,152(sp)
    800058e8:	6129                	addi	sp,sp,192
    800058ea:	8082                	ret
      end_op();
    800058ec:	fffff097          	auipc	ra,0xfffff
    800058f0:	9ae080e7          	jalr	-1618(ra) # 8000429a <end_op>
      return -1;
    800058f4:	557d                	li	a0,-1
    800058f6:	b7e5                	j	800058de <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800058f8:	f5040513          	addi	a0,s0,-176
    800058fc:	ffffe097          	auipc	ra,0xffffe
    80005900:	702080e7          	jalr	1794(ra) # 80003ffe <namei>
    80005904:	84aa                	mv	s1,a0
    80005906:	c905                	beqz	a0,80005936 <sys_open+0x13c>
    ilock(ip);
    80005908:	ffffe097          	auipc	ra,0xffffe
    8000590c:	f50080e7          	jalr	-176(ra) # 80003858 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005910:	04449703          	lh	a4,68(s1)
    80005914:	4785                	li	a5,1
    80005916:	f4f711e3          	bne	a4,a5,80005858 <sys_open+0x5e>
    8000591a:	f4c42783          	lw	a5,-180(s0)
    8000591e:	d7b9                	beqz	a5,8000586c <sys_open+0x72>
      iunlockput(ip);
    80005920:	8526                	mv	a0,s1
    80005922:	ffffe097          	auipc	ra,0xffffe
    80005926:	198080e7          	jalr	408(ra) # 80003aba <iunlockput>
      end_op();
    8000592a:	fffff097          	auipc	ra,0xfffff
    8000592e:	970080e7          	jalr	-1680(ra) # 8000429a <end_op>
      return -1;
    80005932:	557d                	li	a0,-1
    80005934:	b76d                	j	800058de <sys_open+0xe4>
      end_op();
    80005936:	fffff097          	auipc	ra,0xfffff
    8000593a:	964080e7          	jalr	-1692(ra) # 8000429a <end_op>
      return -1;
    8000593e:	557d                	li	a0,-1
    80005940:	bf79                	j	800058de <sys_open+0xe4>
    iunlockput(ip);
    80005942:	8526                	mv	a0,s1
    80005944:	ffffe097          	auipc	ra,0xffffe
    80005948:	176080e7          	jalr	374(ra) # 80003aba <iunlockput>
    end_op();
    8000594c:	fffff097          	auipc	ra,0xfffff
    80005950:	94e080e7          	jalr	-1714(ra) # 8000429a <end_op>
    return -1;
    80005954:	557d                	li	a0,-1
    80005956:	b761                	j	800058de <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005958:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000595c:	04649783          	lh	a5,70(s1)
    80005960:	02f99223          	sh	a5,36(s3)
    80005964:	bf25                	j	8000589c <sys_open+0xa2>
    itrunc(ip);
    80005966:	8526                	mv	a0,s1
    80005968:	ffffe097          	auipc	ra,0xffffe
    8000596c:	ffe080e7          	jalr	-2(ra) # 80003966 <itrunc>
    80005970:	bfa9                	j	800058ca <sys_open+0xd0>
      fileclose(f);
    80005972:	854e                	mv	a0,s3
    80005974:	fffff097          	auipc	ra,0xfffff
    80005978:	d72080e7          	jalr	-654(ra) # 800046e6 <fileclose>
    iunlockput(ip);
    8000597c:	8526                	mv	a0,s1
    8000597e:	ffffe097          	auipc	ra,0xffffe
    80005982:	13c080e7          	jalr	316(ra) # 80003aba <iunlockput>
    end_op();
    80005986:	fffff097          	auipc	ra,0xfffff
    8000598a:	914080e7          	jalr	-1772(ra) # 8000429a <end_op>
    return -1;
    8000598e:	557d                	li	a0,-1
    80005990:	b7b9                	j	800058de <sys_open+0xe4>

0000000080005992 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005992:	7175                	addi	sp,sp,-144
    80005994:	e506                	sd	ra,136(sp)
    80005996:	e122                	sd	s0,128(sp)
    80005998:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000599a:	fffff097          	auipc	ra,0xfffff
    8000599e:	880080e7          	jalr	-1920(ra) # 8000421a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800059a2:	08000613          	li	a2,128
    800059a6:	f7040593          	addi	a1,s0,-144
    800059aa:	4501                	li	a0,0
    800059ac:	ffffd097          	auipc	ra,0xffffd
    800059b0:	314080e7          	jalr	788(ra) # 80002cc0 <argstr>
    800059b4:	02054963          	bltz	a0,800059e6 <sys_mkdir+0x54>
    800059b8:	4681                	li	a3,0
    800059ba:	4601                	li	a2,0
    800059bc:	4585                	li	a1,1
    800059be:	f7040513          	addi	a0,s0,-144
    800059c2:	00000097          	auipc	ra,0x0
    800059c6:	800080e7          	jalr	-2048(ra) # 800051c2 <create>
    800059ca:	cd11                	beqz	a0,800059e6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800059cc:	ffffe097          	auipc	ra,0xffffe
    800059d0:	0ee080e7          	jalr	238(ra) # 80003aba <iunlockput>
  end_op();
    800059d4:	fffff097          	auipc	ra,0xfffff
    800059d8:	8c6080e7          	jalr	-1850(ra) # 8000429a <end_op>
  return 0;
    800059dc:	4501                	li	a0,0
}
    800059de:	60aa                	ld	ra,136(sp)
    800059e0:	640a                	ld	s0,128(sp)
    800059e2:	6149                	addi	sp,sp,144
    800059e4:	8082                	ret
    end_op();
    800059e6:	fffff097          	auipc	ra,0xfffff
    800059ea:	8b4080e7          	jalr	-1868(ra) # 8000429a <end_op>
    return -1;
    800059ee:	557d                	li	a0,-1
    800059f0:	b7fd                	j	800059de <sys_mkdir+0x4c>

00000000800059f2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800059f2:	7135                	addi	sp,sp,-160
    800059f4:	ed06                	sd	ra,152(sp)
    800059f6:	e922                	sd	s0,144(sp)
    800059f8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800059fa:	fffff097          	auipc	ra,0xfffff
    800059fe:	820080e7          	jalr	-2016(ra) # 8000421a <begin_op>
  argint(1, &major);
    80005a02:	f6c40593          	addi	a1,s0,-148
    80005a06:	4505                	li	a0,1
    80005a08:	ffffd097          	auipc	ra,0xffffd
    80005a0c:	278080e7          	jalr	632(ra) # 80002c80 <argint>
  argint(2, &minor);
    80005a10:	f6840593          	addi	a1,s0,-152
    80005a14:	4509                	li	a0,2
    80005a16:	ffffd097          	auipc	ra,0xffffd
    80005a1a:	26a080e7          	jalr	618(ra) # 80002c80 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a1e:	08000613          	li	a2,128
    80005a22:	f7040593          	addi	a1,s0,-144
    80005a26:	4501                	li	a0,0
    80005a28:	ffffd097          	auipc	ra,0xffffd
    80005a2c:	298080e7          	jalr	664(ra) # 80002cc0 <argstr>
    80005a30:	02054b63          	bltz	a0,80005a66 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005a34:	f6841683          	lh	a3,-152(s0)
    80005a38:	f6c41603          	lh	a2,-148(s0)
    80005a3c:	458d                	li	a1,3
    80005a3e:	f7040513          	addi	a0,s0,-144
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	780080e7          	jalr	1920(ra) # 800051c2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005a4a:	cd11                	beqz	a0,80005a66 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	06e080e7          	jalr	110(ra) # 80003aba <iunlockput>
  end_op();
    80005a54:	fffff097          	auipc	ra,0xfffff
    80005a58:	846080e7          	jalr	-1978(ra) # 8000429a <end_op>
  return 0;
    80005a5c:	4501                	li	a0,0
}
    80005a5e:	60ea                	ld	ra,152(sp)
    80005a60:	644a                	ld	s0,144(sp)
    80005a62:	610d                	addi	sp,sp,160
    80005a64:	8082                	ret
    end_op();
    80005a66:	fffff097          	auipc	ra,0xfffff
    80005a6a:	834080e7          	jalr	-1996(ra) # 8000429a <end_op>
    return -1;
    80005a6e:	557d                	li	a0,-1
    80005a70:	b7fd                	j	80005a5e <sys_mknod+0x6c>

0000000080005a72 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005a72:	7135                	addi	sp,sp,-160
    80005a74:	ed06                	sd	ra,152(sp)
    80005a76:	e922                	sd	s0,144(sp)
    80005a78:	e526                	sd	s1,136(sp)
    80005a7a:	e14a                	sd	s2,128(sp)
    80005a7c:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005a7e:	ffffc097          	auipc	ra,0xffffc
    80005a82:	f2e080e7          	jalr	-210(ra) # 800019ac <myproc>
    80005a86:	892a                	mv	s2,a0
  
  begin_op();
    80005a88:	ffffe097          	auipc	ra,0xffffe
    80005a8c:	792080e7          	jalr	1938(ra) # 8000421a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005a90:	08000613          	li	a2,128
    80005a94:	f6040593          	addi	a1,s0,-160
    80005a98:	4501                	li	a0,0
    80005a9a:	ffffd097          	auipc	ra,0xffffd
    80005a9e:	226080e7          	jalr	550(ra) # 80002cc0 <argstr>
    80005aa2:	04054b63          	bltz	a0,80005af8 <sys_chdir+0x86>
    80005aa6:	f6040513          	addi	a0,s0,-160
    80005aaa:	ffffe097          	auipc	ra,0xffffe
    80005aae:	554080e7          	jalr	1364(ra) # 80003ffe <namei>
    80005ab2:	84aa                	mv	s1,a0
    80005ab4:	c131                	beqz	a0,80005af8 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005ab6:	ffffe097          	auipc	ra,0xffffe
    80005aba:	da2080e7          	jalr	-606(ra) # 80003858 <ilock>
  if(ip->type != T_DIR){
    80005abe:	04449703          	lh	a4,68(s1)
    80005ac2:	4785                	li	a5,1
    80005ac4:	04f71063          	bne	a4,a5,80005b04 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ac8:	8526                	mv	a0,s1
    80005aca:	ffffe097          	auipc	ra,0xffffe
    80005ace:	e50080e7          	jalr	-432(ra) # 8000391a <iunlock>
  iput(p->cwd);
    80005ad2:	17893503          	ld	a0,376(s2)
    80005ad6:	ffffe097          	auipc	ra,0xffffe
    80005ada:	f3c080e7          	jalr	-196(ra) # 80003a12 <iput>
  end_op();
    80005ade:	ffffe097          	auipc	ra,0xffffe
    80005ae2:	7bc080e7          	jalr	1980(ra) # 8000429a <end_op>
  p->cwd = ip;
    80005ae6:	16993c23          	sd	s1,376(s2)
  return 0;
    80005aea:	4501                	li	a0,0
}
    80005aec:	60ea                	ld	ra,152(sp)
    80005aee:	644a                	ld	s0,144(sp)
    80005af0:	64aa                	ld	s1,136(sp)
    80005af2:	690a                	ld	s2,128(sp)
    80005af4:	610d                	addi	sp,sp,160
    80005af6:	8082                	ret
    end_op();
    80005af8:	ffffe097          	auipc	ra,0xffffe
    80005afc:	7a2080e7          	jalr	1954(ra) # 8000429a <end_op>
    return -1;
    80005b00:	557d                	li	a0,-1
    80005b02:	b7ed                	j	80005aec <sys_chdir+0x7a>
    iunlockput(ip);
    80005b04:	8526                	mv	a0,s1
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	fb4080e7          	jalr	-76(ra) # 80003aba <iunlockput>
    end_op();
    80005b0e:	ffffe097          	auipc	ra,0xffffe
    80005b12:	78c080e7          	jalr	1932(ra) # 8000429a <end_op>
    return -1;
    80005b16:	557d                	li	a0,-1
    80005b18:	bfd1                	j	80005aec <sys_chdir+0x7a>

0000000080005b1a <sys_exec>:

uint64
sys_exec(void)
{
    80005b1a:	7145                	addi	sp,sp,-464
    80005b1c:	e786                	sd	ra,456(sp)
    80005b1e:	e3a2                	sd	s0,448(sp)
    80005b20:	ff26                	sd	s1,440(sp)
    80005b22:	fb4a                	sd	s2,432(sp)
    80005b24:	f74e                	sd	s3,424(sp)
    80005b26:	f352                	sd	s4,416(sp)
    80005b28:	ef56                	sd	s5,408(sp)
    80005b2a:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005b2c:	e3840593          	addi	a1,s0,-456
    80005b30:	4505                	li	a0,1
    80005b32:	ffffd097          	auipc	ra,0xffffd
    80005b36:	16e080e7          	jalr	366(ra) # 80002ca0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005b3a:	08000613          	li	a2,128
    80005b3e:	f4040593          	addi	a1,s0,-192
    80005b42:	4501                	li	a0,0
    80005b44:	ffffd097          	auipc	ra,0xffffd
    80005b48:	17c080e7          	jalr	380(ra) # 80002cc0 <argstr>
    80005b4c:	87aa                	mv	a5,a0
    return -1;
    80005b4e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005b50:	0c07c263          	bltz	a5,80005c14 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005b54:	10000613          	li	a2,256
    80005b58:	4581                	li	a1,0
    80005b5a:	e4040513          	addi	a0,s0,-448
    80005b5e:	ffffb097          	auipc	ra,0xffffb
    80005b62:	174080e7          	jalr	372(ra) # 80000cd2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005b66:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005b6a:	89a6                	mv	s3,s1
    80005b6c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005b6e:	02000a13          	li	s4,32
    80005b72:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005b76:	00391793          	slli	a5,s2,0x3
    80005b7a:	e3040593          	addi	a1,s0,-464
    80005b7e:	e3843503          	ld	a0,-456(s0)
    80005b82:	953e                	add	a0,a0,a5
    80005b84:	ffffd097          	auipc	ra,0xffffd
    80005b88:	05e080e7          	jalr	94(ra) # 80002be2 <fetchaddr>
    80005b8c:	02054a63          	bltz	a0,80005bc0 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005b90:	e3043783          	ld	a5,-464(s0)
    80005b94:	c3b9                	beqz	a5,80005bda <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005b96:	ffffb097          	auipc	ra,0xffffb
    80005b9a:	f50080e7          	jalr	-176(ra) # 80000ae6 <kalloc>
    80005b9e:	85aa                	mv	a1,a0
    80005ba0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ba4:	cd11                	beqz	a0,80005bc0 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ba6:	6605                	lui	a2,0x1
    80005ba8:	e3043503          	ld	a0,-464(s0)
    80005bac:	ffffd097          	auipc	ra,0xffffd
    80005bb0:	088080e7          	jalr	136(ra) # 80002c34 <fetchstr>
    80005bb4:	00054663          	bltz	a0,80005bc0 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005bb8:	0905                	addi	s2,s2,1
    80005bba:	09a1                	addi	s3,s3,8
    80005bbc:	fb491be3          	bne	s2,s4,80005b72 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bc0:	10048913          	addi	s2,s1,256
    80005bc4:	6088                	ld	a0,0(s1)
    80005bc6:	c531                	beqz	a0,80005c12 <sys_exec+0xf8>
    kfree(argv[i]);
    80005bc8:	ffffb097          	auipc	ra,0xffffb
    80005bcc:	e22080e7          	jalr	-478(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bd0:	04a1                	addi	s1,s1,8
    80005bd2:	ff2499e3          	bne	s1,s2,80005bc4 <sys_exec+0xaa>
  return -1;
    80005bd6:	557d                	li	a0,-1
    80005bd8:	a835                	j	80005c14 <sys_exec+0xfa>
      argv[i] = 0;
    80005bda:	0a8e                	slli	s5,s5,0x3
    80005bdc:	fc040793          	addi	a5,s0,-64
    80005be0:	9abe                	add	s5,s5,a5
    80005be2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005be6:	e4040593          	addi	a1,s0,-448
    80005bea:	f4040513          	addi	a0,s0,-192
    80005bee:	fffff097          	auipc	ra,0xfffff
    80005bf2:	172080e7          	jalr	370(ra) # 80004d60 <exec>
    80005bf6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005bf8:	10048993          	addi	s3,s1,256
    80005bfc:	6088                	ld	a0,0(s1)
    80005bfe:	c901                	beqz	a0,80005c0e <sys_exec+0xf4>
    kfree(argv[i]);
    80005c00:	ffffb097          	auipc	ra,0xffffb
    80005c04:	dea080e7          	jalr	-534(ra) # 800009ea <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c08:	04a1                	addi	s1,s1,8
    80005c0a:	ff3499e3          	bne	s1,s3,80005bfc <sys_exec+0xe2>
  return ret;
    80005c0e:	854a                	mv	a0,s2
    80005c10:	a011                	j	80005c14 <sys_exec+0xfa>
  return -1;
    80005c12:	557d                	li	a0,-1
}
    80005c14:	60be                	ld	ra,456(sp)
    80005c16:	641e                	ld	s0,448(sp)
    80005c18:	74fa                	ld	s1,440(sp)
    80005c1a:	795a                	ld	s2,432(sp)
    80005c1c:	79ba                	ld	s3,424(sp)
    80005c1e:	7a1a                	ld	s4,416(sp)
    80005c20:	6afa                	ld	s5,408(sp)
    80005c22:	6179                	addi	sp,sp,464
    80005c24:	8082                	ret

0000000080005c26 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005c26:	7139                	addi	sp,sp,-64
    80005c28:	fc06                	sd	ra,56(sp)
    80005c2a:	f822                	sd	s0,48(sp)
    80005c2c:	f426                	sd	s1,40(sp)
    80005c2e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005c30:	ffffc097          	auipc	ra,0xffffc
    80005c34:	d7c080e7          	jalr	-644(ra) # 800019ac <myproc>
    80005c38:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005c3a:	fd840593          	addi	a1,s0,-40
    80005c3e:	4501                	li	a0,0
    80005c40:	ffffd097          	auipc	ra,0xffffd
    80005c44:	060080e7          	jalr	96(ra) # 80002ca0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005c48:	fc840593          	addi	a1,s0,-56
    80005c4c:	fd040513          	addi	a0,s0,-48
    80005c50:	fffff097          	auipc	ra,0xfffff
    80005c54:	dc6080e7          	jalr	-570(ra) # 80004a16 <pipealloc>
    return -1;
    80005c58:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005c5a:	0c054463          	bltz	a0,80005d22 <sys_pipe+0xfc>
  fd0 = -1;
    80005c5e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005c62:	fd043503          	ld	a0,-48(s0)
    80005c66:	fffff097          	auipc	ra,0xfffff
    80005c6a:	51a080e7          	jalr	1306(ra) # 80005180 <fdalloc>
    80005c6e:	fca42223          	sw	a0,-60(s0)
    80005c72:	08054b63          	bltz	a0,80005d08 <sys_pipe+0xe2>
    80005c76:	fc843503          	ld	a0,-56(s0)
    80005c7a:	fffff097          	auipc	ra,0xfffff
    80005c7e:	506080e7          	jalr	1286(ra) # 80005180 <fdalloc>
    80005c82:	fca42023          	sw	a0,-64(s0)
    80005c86:	06054863          	bltz	a0,80005cf6 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005c8a:	4691                	li	a3,4
    80005c8c:	fc440613          	addi	a2,s0,-60
    80005c90:	fd843583          	ld	a1,-40(s0)
    80005c94:	7ca8                	ld	a0,120(s1)
    80005c96:	ffffc097          	auipc	ra,0xffffc
    80005c9a:	9d2080e7          	jalr	-1582(ra) # 80001668 <copyout>
    80005c9e:	02054063          	bltz	a0,80005cbe <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005ca2:	4691                	li	a3,4
    80005ca4:	fc040613          	addi	a2,s0,-64
    80005ca8:	fd843583          	ld	a1,-40(s0)
    80005cac:	0591                	addi	a1,a1,4
    80005cae:	7ca8                	ld	a0,120(s1)
    80005cb0:	ffffc097          	auipc	ra,0xffffc
    80005cb4:	9b8080e7          	jalr	-1608(ra) # 80001668 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005cb8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cba:	06055463          	bgez	a0,80005d22 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005cbe:	fc442783          	lw	a5,-60(s0)
    80005cc2:	07f9                	addi	a5,a5,30
    80005cc4:	078e                	slli	a5,a5,0x3
    80005cc6:	97a6                	add	a5,a5,s1
    80005cc8:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005ccc:	fc042503          	lw	a0,-64(s0)
    80005cd0:	0579                	addi	a0,a0,30
    80005cd2:	050e                	slli	a0,a0,0x3
    80005cd4:	94aa                	add	s1,s1,a0
    80005cd6:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005cda:	fd043503          	ld	a0,-48(s0)
    80005cde:	fffff097          	auipc	ra,0xfffff
    80005ce2:	a08080e7          	jalr	-1528(ra) # 800046e6 <fileclose>
    fileclose(wf);
    80005ce6:	fc843503          	ld	a0,-56(s0)
    80005cea:	fffff097          	auipc	ra,0xfffff
    80005cee:	9fc080e7          	jalr	-1540(ra) # 800046e6 <fileclose>
    return -1;
    80005cf2:	57fd                	li	a5,-1
    80005cf4:	a03d                	j	80005d22 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005cf6:	fc442783          	lw	a5,-60(s0)
    80005cfa:	0007c763          	bltz	a5,80005d08 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005cfe:	07f9                	addi	a5,a5,30
    80005d00:	078e                	slli	a5,a5,0x3
    80005d02:	94be                	add	s1,s1,a5
    80005d04:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005d08:	fd043503          	ld	a0,-48(s0)
    80005d0c:	fffff097          	auipc	ra,0xfffff
    80005d10:	9da080e7          	jalr	-1574(ra) # 800046e6 <fileclose>
    fileclose(wf);
    80005d14:	fc843503          	ld	a0,-56(s0)
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	9ce080e7          	jalr	-1586(ra) # 800046e6 <fileclose>
    return -1;
    80005d20:	57fd                	li	a5,-1
}
    80005d22:	853e                	mv	a0,a5
    80005d24:	70e2                	ld	ra,56(sp)
    80005d26:	7442                	ld	s0,48(sp)
    80005d28:	74a2                	ld	s1,40(sp)
    80005d2a:	6121                	addi	sp,sp,64
    80005d2c:	8082                	ret
	...

0000000080005d30 <kernelvec>:
    80005d30:	7111                	addi	sp,sp,-256
    80005d32:	e006                	sd	ra,0(sp)
    80005d34:	e40a                	sd	sp,8(sp)
    80005d36:	e80e                	sd	gp,16(sp)
    80005d38:	ec12                	sd	tp,24(sp)
    80005d3a:	f016                	sd	t0,32(sp)
    80005d3c:	f41a                	sd	t1,40(sp)
    80005d3e:	f81e                	sd	t2,48(sp)
    80005d40:	fc22                	sd	s0,56(sp)
    80005d42:	e0a6                	sd	s1,64(sp)
    80005d44:	e4aa                	sd	a0,72(sp)
    80005d46:	e8ae                	sd	a1,80(sp)
    80005d48:	ecb2                	sd	a2,88(sp)
    80005d4a:	f0b6                	sd	a3,96(sp)
    80005d4c:	f4ba                	sd	a4,104(sp)
    80005d4e:	f8be                	sd	a5,112(sp)
    80005d50:	fcc2                	sd	a6,120(sp)
    80005d52:	e146                	sd	a7,128(sp)
    80005d54:	e54a                	sd	s2,136(sp)
    80005d56:	e94e                	sd	s3,144(sp)
    80005d58:	ed52                	sd	s4,152(sp)
    80005d5a:	f156                	sd	s5,160(sp)
    80005d5c:	f55a                	sd	s6,168(sp)
    80005d5e:	f95e                	sd	s7,176(sp)
    80005d60:	fd62                	sd	s8,184(sp)
    80005d62:	e1e6                	sd	s9,192(sp)
    80005d64:	e5ea                	sd	s10,200(sp)
    80005d66:	e9ee                	sd	s11,208(sp)
    80005d68:	edf2                	sd	t3,216(sp)
    80005d6a:	f1f6                	sd	t4,224(sp)
    80005d6c:	f5fa                	sd	t5,232(sp)
    80005d6e:	f9fe                	sd	t6,240(sp)
    80005d70:	d3ffc0ef          	jal	ra,80002aae <kerneltrap>
    80005d74:	6082                	ld	ra,0(sp)
    80005d76:	6122                	ld	sp,8(sp)
    80005d78:	61c2                	ld	gp,16(sp)
    80005d7a:	7282                	ld	t0,32(sp)
    80005d7c:	7322                	ld	t1,40(sp)
    80005d7e:	73c2                	ld	t2,48(sp)
    80005d80:	7462                	ld	s0,56(sp)
    80005d82:	6486                	ld	s1,64(sp)
    80005d84:	6526                	ld	a0,72(sp)
    80005d86:	65c6                	ld	a1,80(sp)
    80005d88:	6666                	ld	a2,88(sp)
    80005d8a:	7686                	ld	a3,96(sp)
    80005d8c:	7726                	ld	a4,104(sp)
    80005d8e:	77c6                	ld	a5,112(sp)
    80005d90:	7866                	ld	a6,120(sp)
    80005d92:	688a                	ld	a7,128(sp)
    80005d94:	692a                	ld	s2,136(sp)
    80005d96:	69ca                	ld	s3,144(sp)
    80005d98:	6a6a                	ld	s4,152(sp)
    80005d9a:	7a8a                	ld	s5,160(sp)
    80005d9c:	7b2a                	ld	s6,168(sp)
    80005d9e:	7bca                	ld	s7,176(sp)
    80005da0:	7c6a                	ld	s8,184(sp)
    80005da2:	6c8e                	ld	s9,192(sp)
    80005da4:	6d2e                	ld	s10,200(sp)
    80005da6:	6dce                	ld	s11,208(sp)
    80005da8:	6e6e                	ld	t3,216(sp)
    80005daa:	7e8e                	ld	t4,224(sp)
    80005dac:	7f2e                	ld	t5,232(sp)
    80005dae:	7fce                	ld	t6,240(sp)
    80005db0:	6111                	addi	sp,sp,256
    80005db2:	10200073          	sret
    80005db6:	00000013          	nop
    80005dba:	00000013          	nop
    80005dbe:	0001                	nop

0000000080005dc0 <timervec>:
    80005dc0:	34051573          	csrrw	a0,mscratch,a0
    80005dc4:	e10c                	sd	a1,0(a0)
    80005dc6:	e510                	sd	a2,8(a0)
    80005dc8:	e914                	sd	a3,16(a0)
    80005dca:	6d0c                	ld	a1,24(a0)
    80005dcc:	7110                	ld	a2,32(a0)
    80005dce:	6194                	ld	a3,0(a1)
    80005dd0:	96b2                	add	a3,a3,a2
    80005dd2:	e194                	sd	a3,0(a1)
    80005dd4:	4589                	li	a1,2
    80005dd6:	14459073          	csrw	sip,a1
    80005dda:	6914                	ld	a3,16(a0)
    80005ddc:	6510                	ld	a2,8(a0)
    80005dde:	610c                	ld	a1,0(a0)
    80005de0:	34051573          	csrrw	a0,mscratch,a0
    80005de4:	30200073          	mret
	...

0000000080005dea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dea:	1141                	addi	sp,sp,-16
    80005dec:	e422                	sd	s0,8(sp)
    80005dee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005df0:	0c0007b7          	lui	a5,0xc000
    80005df4:	4705                	li	a4,1
    80005df6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005df8:	c3d8                	sw	a4,4(a5)
}
    80005dfa:	6422                	ld	s0,8(sp)
    80005dfc:	0141                	addi	sp,sp,16
    80005dfe:	8082                	ret

0000000080005e00 <plicinithart>:

void
plicinithart(void)
{
    80005e00:	1141                	addi	sp,sp,-16
    80005e02:	e406                	sd	ra,8(sp)
    80005e04:	e022                	sd	s0,0(sp)
    80005e06:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e08:	ffffc097          	auipc	ra,0xffffc
    80005e0c:	b78080e7          	jalr	-1160(ra) # 80001980 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e10:	0085171b          	slliw	a4,a0,0x8
    80005e14:	0c0027b7          	lui	a5,0xc002
    80005e18:	97ba                	add	a5,a5,a4
    80005e1a:	40200713          	li	a4,1026
    80005e1e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e22:	00d5151b          	slliw	a0,a0,0xd
    80005e26:	0c2017b7          	lui	a5,0xc201
    80005e2a:	953e                	add	a0,a0,a5
    80005e2c:	00052023          	sw	zero,0(a0)
}
    80005e30:	60a2                	ld	ra,8(sp)
    80005e32:	6402                	ld	s0,0(sp)
    80005e34:	0141                	addi	sp,sp,16
    80005e36:	8082                	ret

0000000080005e38 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e38:	1141                	addi	sp,sp,-16
    80005e3a:	e406                	sd	ra,8(sp)
    80005e3c:	e022                	sd	s0,0(sp)
    80005e3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e40:	ffffc097          	auipc	ra,0xffffc
    80005e44:	b40080e7          	jalr	-1216(ra) # 80001980 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e48:	00d5179b          	slliw	a5,a0,0xd
    80005e4c:	0c201537          	lui	a0,0xc201
    80005e50:	953e                	add	a0,a0,a5
  return irq;
}
    80005e52:	4148                	lw	a0,4(a0)
    80005e54:	60a2                	ld	ra,8(sp)
    80005e56:	6402                	ld	s0,0(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e5c:	1101                	addi	sp,sp,-32
    80005e5e:	ec06                	sd	ra,24(sp)
    80005e60:	e822                	sd	s0,16(sp)
    80005e62:	e426                	sd	s1,8(sp)
    80005e64:	1000                	addi	s0,sp,32
    80005e66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e68:	ffffc097          	auipc	ra,0xffffc
    80005e6c:	b18080e7          	jalr	-1256(ra) # 80001980 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e70:	00d5151b          	slliw	a0,a0,0xd
    80005e74:	0c2017b7          	lui	a5,0xc201
    80005e78:	97aa                	add	a5,a5,a0
    80005e7a:	c3c4                	sw	s1,4(a5)
}
    80005e7c:	60e2                	ld	ra,24(sp)
    80005e7e:	6442                	ld	s0,16(sp)
    80005e80:	64a2                	ld	s1,8(sp)
    80005e82:	6105                	addi	sp,sp,32
    80005e84:	8082                	ret

0000000080005e86 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e86:	1141                	addi	sp,sp,-16
    80005e88:	e406                	sd	ra,8(sp)
    80005e8a:	e022                	sd	s0,0(sp)
    80005e8c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e8e:	479d                	li	a5,7
    80005e90:	04a7cc63          	blt	a5,a0,80005ee8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005e94:	0001d797          	auipc	a5,0x1d
    80005e98:	9ac78793          	addi	a5,a5,-1620 # 80022840 <disk>
    80005e9c:	97aa                	add	a5,a5,a0
    80005e9e:	0187c783          	lbu	a5,24(a5)
    80005ea2:	ebb9                	bnez	a5,80005ef8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ea4:	00451613          	slli	a2,a0,0x4
    80005ea8:	0001d797          	auipc	a5,0x1d
    80005eac:	99878793          	addi	a5,a5,-1640 # 80022840 <disk>
    80005eb0:	6394                	ld	a3,0(a5)
    80005eb2:	96b2                	add	a3,a3,a2
    80005eb4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005eb8:	6398                	ld	a4,0(a5)
    80005eba:	9732                	add	a4,a4,a2
    80005ebc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005ec0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005ec4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005ec8:	953e                	add	a0,a0,a5
    80005eca:	4785                	li	a5,1
    80005ecc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005ed0:	0001d517          	auipc	a0,0x1d
    80005ed4:	98850513          	addi	a0,a0,-1656 # 80022858 <disk+0x18>
    80005ed8:	ffffc097          	auipc	ra,0xffffc
    80005edc:	2aa080e7          	jalr	682(ra) # 80002182 <wakeup>
}
    80005ee0:	60a2                	ld	ra,8(sp)
    80005ee2:	6402                	ld	s0,0(sp)
    80005ee4:	0141                	addi	sp,sp,16
    80005ee6:	8082                	ret
    panic("free_desc 1");
    80005ee8:	00003517          	auipc	a0,0x3
    80005eec:	87850513          	addi	a0,a0,-1928 # 80008760 <syscalls+0x300>
    80005ef0:	ffffa097          	auipc	ra,0xffffa
    80005ef4:	64e080e7          	jalr	1614(ra) # 8000053e <panic>
    panic("free_desc 2");
    80005ef8:	00003517          	auipc	a0,0x3
    80005efc:	87850513          	addi	a0,a0,-1928 # 80008770 <syscalls+0x310>
    80005f00:	ffffa097          	auipc	ra,0xffffa
    80005f04:	63e080e7          	jalr	1598(ra) # 8000053e <panic>

0000000080005f08 <virtio_disk_init>:
{
    80005f08:	1101                	addi	sp,sp,-32
    80005f0a:	ec06                	sd	ra,24(sp)
    80005f0c:	e822                	sd	s0,16(sp)
    80005f0e:	e426                	sd	s1,8(sp)
    80005f10:	e04a                	sd	s2,0(sp)
    80005f12:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f14:	00003597          	auipc	a1,0x3
    80005f18:	86c58593          	addi	a1,a1,-1940 # 80008780 <syscalls+0x320>
    80005f1c:	0001d517          	auipc	a0,0x1d
    80005f20:	a4c50513          	addi	a0,a0,-1460 # 80022968 <disk+0x128>
    80005f24:	ffffb097          	auipc	ra,0xffffb
    80005f28:	c22080e7          	jalr	-990(ra) # 80000b46 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f2c:	100017b7          	lui	a5,0x10001
    80005f30:	4398                	lw	a4,0(a5)
    80005f32:	2701                	sext.w	a4,a4
    80005f34:	747277b7          	lui	a5,0x74727
    80005f38:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f3c:	14f71c63          	bne	a4,a5,80006094 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f40:	100017b7          	lui	a5,0x10001
    80005f44:	43dc                	lw	a5,4(a5)
    80005f46:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f48:	4709                	li	a4,2
    80005f4a:	14e79563          	bne	a5,a4,80006094 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f4e:	100017b7          	lui	a5,0x10001
    80005f52:	479c                	lw	a5,8(a5)
    80005f54:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f56:	12e79f63          	bne	a5,a4,80006094 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f5a:	100017b7          	lui	a5,0x10001
    80005f5e:	47d8                	lw	a4,12(a5)
    80005f60:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f62:	554d47b7          	lui	a5,0x554d4
    80005f66:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f6a:	12f71563          	bne	a4,a5,80006094 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f6e:	100017b7          	lui	a5,0x10001
    80005f72:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f76:	4705                	li	a4,1
    80005f78:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f7a:	470d                	li	a4,3
    80005f7c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f7e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f80:	c7ffe737          	lui	a4,0xc7ffe
    80005f84:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdbddf>
    80005f88:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f8a:	2701                	sext.w	a4,a4
    80005f8c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f8e:	472d                	li	a4,11
    80005f90:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005f92:	5bbc                	lw	a5,112(a5)
    80005f94:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005f98:	8ba1                	andi	a5,a5,8
    80005f9a:	10078563          	beqz	a5,800060a4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f9e:	100017b7          	lui	a5,0x10001
    80005fa2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005fa6:	43fc                	lw	a5,68(a5)
    80005fa8:	2781                	sext.w	a5,a5
    80005faa:	10079563          	bnez	a5,800060b4 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fae:	100017b7          	lui	a5,0x10001
    80005fb2:	5bdc                	lw	a5,52(a5)
    80005fb4:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fb6:	10078763          	beqz	a5,800060c4 <virtio_disk_init+0x1bc>
  if(max < NUM)
    80005fba:	471d                	li	a4,7
    80005fbc:	10f77c63          	bgeu	a4,a5,800060d4 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80005fc0:	ffffb097          	auipc	ra,0xffffb
    80005fc4:	b26080e7          	jalr	-1242(ra) # 80000ae6 <kalloc>
    80005fc8:	0001d497          	auipc	s1,0x1d
    80005fcc:	87848493          	addi	s1,s1,-1928 # 80022840 <disk>
    80005fd0:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005fd2:	ffffb097          	auipc	ra,0xffffb
    80005fd6:	b14080e7          	jalr	-1260(ra) # 80000ae6 <kalloc>
    80005fda:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005fdc:	ffffb097          	auipc	ra,0xffffb
    80005fe0:	b0a080e7          	jalr	-1270(ra) # 80000ae6 <kalloc>
    80005fe4:	87aa                	mv	a5,a0
    80005fe6:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005fe8:	6088                	ld	a0,0(s1)
    80005fea:	cd6d                	beqz	a0,800060e4 <virtio_disk_init+0x1dc>
    80005fec:	0001d717          	auipc	a4,0x1d
    80005ff0:	85c73703          	ld	a4,-1956(a4) # 80022848 <disk+0x8>
    80005ff4:	cb65                	beqz	a4,800060e4 <virtio_disk_init+0x1dc>
    80005ff6:	c7fd                	beqz	a5,800060e4 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80005ff8:	6605                	lui	a2,0x1
    80005ffa:	4581                	li	a1,0
    80005ffc:	ffffb097          	auipc	ra,0xffffb
    80006000:	cd6080e7          	jalr	-810(ra) # 80000cd2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006004:	0001d497          	auipc	s1,0x1d
    80006008:	83c48493          	addi	s1,s1,-1988 # 80022840 <disk>
    8000600c:	6605                	lui	a2,0x1
    8000600e:	4581                	li	a1,0
    80006010:	6488                	ld	a0,8(s1)
    80006012:	ffffb097          	auipc	ra,0xffffb
    80006016:	cc0080e7          	jalr	-832(ra) # 80000cd2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000601a:	6605                	lui	a2,0x1
    8000601c:	4581                	li	a1,0
    8000601e:	6888                	ld	a0,16(s1)
    80006020:	ffffb097          	auipc	ra,0xffffb
    80006024:	cb2080e7          	jalr	-846(ra) # 80000cd2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006028:	100017b7          	lui	a5,0x10001
    8000602c:	4721                	li	a4,8
    8000602e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006030:	4098                	lw	a4,0(s1)
    80006032:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006036:	40d8                	lw	a4,4(s1)
    80006038:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000603c:	6498                	ld	a4,8(s1)
    8000603e:	0007069b          	sext.w	a3,a4
    80006042:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006046:	9701                	srai	a4,a4,0x20
    80006048:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000604c:	6898                	ld	a4,16(s1)
    8000604e:	0007069b          	sext.w	a3,a4
    80006052:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006056:	9701                	srai	a4,a4,0x20
    80006058:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000605c:	4705                	li	a4,1
    8000605e:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    80006060:	00e48c23          	sb	a4,24(s1)
    80006064:	00e48ca3          	sb	a4,25(s1)
    80006068:	00e48d23          	sb	a4,26(s1)
    8000606c:	00e48da3          	sb	a4,27(s1)
    80006070:	00e48e23          	sb	a4,28(s1)
    80006074:	00e48ea3          	sb	a4,29(s1)
    80006078:	00e48f23          	sb	a4,30(s1)
    8000607c:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006080:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006084:	0727a823          	sw	s2,112(a5)
}
    80006088:	60e2                	ld	ra,24(sp)
    8000608a:	6442                	ld	s0,16(sp)
    8000608c:	64a2                	ld	s1,8(sp)
    8000608e:	6902                	ld	s2,0(sp)
    80006090:	6105                	addi	sp,sp,32
    80006092:	8082                	ret
    panic("could not find virtio disk");
    80006094:	00002517          	auipc	a0,0x2
    80006098:	6fc50513          	addi	a0,a0,1788 # 80008790 <syscalls+0x330>
    8000609c:	ffffa097          	auipc	ra,0xffffa
    800060a0:	4a2080e7          	jalr	1186(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    800060a4:	00002517          	auipc	a0,0x2
    800060a8:	70c50513          	addi	a0,a0,1804 # 800087b0 <syscalls+0x350>
    800060ac:	ffffa097          	auipc	ra,0xffffa
    800060b0:	492080e7          	jalr	1170(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    800060b4:	00002517          	auipc	a0,0x2
    800060b8:	71c50513          	addi	a0,a0,1820 # 800087d0 <syscalls+0x370>
    800060bc:	ffffa097          	auipc	ra,0xffffa
    800060c0:	482080e7          	jalr	1154(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    800060c4:	00002517          	auipc	a0,0x2
    800060c8:	72c50513          	addi	a0,a0,1836 # 800087f0 <syscalls+0x390>
    800060cc:	ffffa097          	auipc	ra,0xffffa
    800060d0:	472080e7          	jalr	1138(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    800060d4:	00002517          	auipc	a0,0x2
    800060d8:	73c50513          	addi	a0,a0,1852 # 80008810 <syscalls+0x3b0>
    800060dc:	ffffa097          	auipc	ra,0xffffa
    800060e0:	462080e7          	jalr	1122(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    800060e4:	00002517          	auipc	a0,0x2
    800060e8:	74c50513          	addi	a0,a0,1868 # 80008830 <syscalls+0x3d0>
    800060ec:	ffffa097          	auipc	ra,0xffffa
    800060f0:	452080e7          	jalr	1106(ra) # 8000053e <panic>

00000000800060f4 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800060f4:	7119                	addi	sp,sp,-128
    800060f6:	fc86                	sd	ra,120(sp)
    800060f8:	f8a2                	sd	s0,112(sp)
    800060fa:	f4a6                	sd	s1,104(sp)
    800060fc:	f0ca                	sd	s2,96(sp)
    800060fe:	ecce                	sd	s3,88(sp)
    80006100:	e8d2                	sd	s4,80(sp)
    80006102:	e4d6                	sd	s5,72(sp)
    80006104:	e0da                	sd	s6,64(sp)
    80006106:	fc5e                	sd	s7,56(sp)
    80006108:	f862                	sd	s8,48(sp)
    8000610a:	f466                	sd	s9,40(sp)
    8000610c:	f06a                	sd	s10,32(sp)
    8000610e:	ec6e                	sd	s11,24(sp)
    80006110:	0100                	addi	s0,sp,128
    80006112:	8aaa                	mv	s5,a0
    80006114:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006116:	00c52d03          	lw	s10,12(a0)
    8000611a:	001d1d1b          	slliw	s10,s10,0x1
    8000611e:	1d02                	slli	s10,s10,0x20
    80006120:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006124:	0001d517          	auipc	a0,0x1d
    80006128:	84450513          	addi	a0,a0,-1980 # 80022968 <disk+0x128>
    8000612c:	ffffb097          	auipc	ra,0xffffb
    80006130:	aaa080e7          	jalr	-1366(ra) # 80000bd6 <acquire>
  for(int i = 0; i < 3; i++){
    80006134:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006136:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006138:	0001cb97          	auipc	s7,0x1c
    8000613c:	708b8b93          	addi	s7,s7,1800 # 80022840 <disk>
  for(int i = 0; i < 3; i++){
    80006140:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006142:	0001dc97          	auipc	s9,0x1d
    80006146:	826c8c93          	addi	s9,s9,-2010 # 80022968 <disk+0x128>
    8000614a:	a08d                	j	800061ac <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000614c:	00fb8733          	add	a4,s7,a5
    80006150:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006154:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006156:	0207c563          	bltz	a5,80006180 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000615a:	2905                	addiw	s2,s2,1
    8000615c:	0611                	addi	a2,a2,4
    8000615e:	05690c63          	beq	s2,s6,800061b6 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80006162:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006164:	0001c717          	auipc	a4,0x1c
    80006168:	6dc70713          	addi	a4,a4,1756 # 80022840 <disk>
    8000616c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000616e:	01874683          	lbu	a3,24(a4)
    80006172:	fee9                	bnez	a3,8000614c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80006174:	2785                	addiw	a5,a5,1
    80006176:	0705                	addi	a4,a4,1
    80006178:	fe979be3          	bne	a5,s1,8000616e <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000617c:	57fd                	li	a5,-1
    8000617e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006180:	01205d63          	blez	s2,8000619a <virtio_disk_rw+0xa6>
    80006184:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80006186:	000a2503          	lw	a0,0(s4)
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	cfc080e7          	jalr	-772(ra) # 80005e86 <free_desc>
      for(int j = 0; j < i; j++)
    80006192:	2d85                	addiw	s11,s11,1
    80006194:	0a11                	addi	s4,s4,4
    80006196:	ffb918e3          	bne	s2,s11,80006186 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000619a:	85e6                	mv	a1,s9
    8000619c:	0001c517          	auipc	a0,0x1c
    800061a0:	6bc50513          	addi	a0,a0,1724 # 80022858 <disk+0x18>
    800061a4:	ffffc097          	auipc	ra,0xffffc
    800061a8:	f7a080e7          	jalr	-134(ra) # 8000211e <sleep>
  for(int i = 0; i < 3; i++){
    800061ac:	f8040a13          	addi	s4,s0,-128
{
    800061b0:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800061b2:	894e                	mv	s2,s3
    800061b4:	b77d                	j	80006162 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061b6:	f8042583          	lw	a1,-128(s0)
    800061ba:	00a58793          	addi	a5,a1,10
    800061be:	0792                	slli	a5,a5,0x4

  if(write)
    800061c0:	0001c617          	auipc	a2,0x1c
    800061c4:	68060613          	addi	a2,a2,1664 # 80022840 <disk>
    800061c8:	00f60733          	add	a4,a2,a5
    800061cc:	018036b3          	snez	a3,s8
    800061d0:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800061d2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800061d6:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800061da:	f6078693          	addi	a3,a5,-160
    800061de:	6218                	ld	a4,0(a2)
    800061e0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061e2:	00878513          	addi	a0,a5,8
    800061e6:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    800061e8:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800061ea:	6208                	ld	a0,0(a2)
    800061ec:	96aa                	add	a3,a3,a0
    800061ee:	4741                	li	a4,16
    800061f0:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800061f2:	4705                	li	a4,1
    800061f4:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800061f8:	f8442703          	lw	a4,-124(s0)
    800061fc:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006200:	0712                	slli	a4,a4,0x4
    80006202:	953a                	add	a0,a0,a4
    80006204:	058a8693          	addi	a3,s5,88
    80006208:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000620a:	6208                	ld	a0,0(a2)
    8000620c:	972a                	add	a4,a4,a0
    8000620e:	40000693          	li	a3,1024
    80006212:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006214:	001c3c13          	seqz	s8,s8
    80006218:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000621a:	001c6c13          	ori	s8,s8,1
    8000621e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006222:	f8842603          	lw	a2,-120(s0)
    80006226:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000622a:	0001c697          	auipc	a3,0x1c
    8000622e:	61668693          	addi	a3,a3,1558 # 80022840 <disk>
    80006232:	00258713          	addi	a4,a1,2
    80006236:	0712                	slli	a4,a4,0x4
    80006238:	9736                	add	a4,a4,a3
    8000623a:	587d                	li	a6,-1
    8000623c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006240:	0612                	slli	a2,a2,0x4
    80006242:	9532                	add	a0,a0,a2
    80006244:	f9078793          	addi	a5,a5,-112
    80006248:	97b6                	add	a5,a5,a3
    8000624a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    8000624c:	629c                	ld	a5,0(a3)
    8000624e:	97b2                	add	a5,a5,a2
    80006250:	4605                	li	a2,1
    80006252:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006254:	4509                	li	a0,2
    80006256:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    8000625a:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000625e:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006262:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006266:	6698                	ld	a4,8(a3)
    80006268:	00275783          	lhu	a5,2(a4)
    8000626c:	8b9d                	andi	a5,a5,7
    8000626e:	0786                	slli	a5,a5,0x1
    80006270:	97ba                	add	a5,a5,a4
    80006272:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006276:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000627a:	6698                	ld	a4,8(a3)
    8000627c:	00275783          	lhu	a5,2(a4)
    80006280:	2785                	addiw	a5,a5,1
    80006282:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006286:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000628a:	100017b7          	lui	a5,0x10001
    8000628e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006292:	004aa783          	lw	a5,4(s5)
    80006296:	02c79163          	bne	a5,a2,800062b8 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    8000629a:	0001c917          	auipc	s2,0x1c
    8000629e:	6ce90913          	addi	s2,s2,1742 # 80022968 <disk+0x128>
  while(b->disk == 1) {
    800062a2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800062a4:	85ca                	mv	a1,s2
    800062a6:	8556                	mv	a0,s5
    800062a8:	ffffc097          	auipc	ra,0xffffc
    800062ac:	e76080e7          	jalr	-394(ra) # 8000211e <sleep>
  while(b->disk == 1) {
    800062b0:	004aa783          	lw	a5,4(s5)
    800062b4:	fe9788e3          	beq	a5,s1,800062a4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800062b8:	f8042903          	lw	s2,-128(s0)
    800062bc:	00290793          	addi	a5,s2,2
    800062c0:	00479713          	slli	a4,a5,0x4
    800062c4:	0001c797          	auipc	a5,0x1c
    800062c8:	57c78793          	addi	a5,a5,1404 # 80022840 <disk>
    800062cc:	97ba                	add	a5,a5,a4
    800062ce:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800062d2:	0001c997          	auipc	s3,0x1c
    800062d6:	56e98993          	addi	s3,s3,1390 # 80022840 <disk>
    800062da:	00491713          	slli	a4,s2,0x4
    800062de:	0009b783          	ld	a5,0(s3)
    800062e2:	97ba                	add	a5,a5,a4
    800062e4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800062e8:	854a                	mv	a0,s2
    800062ea:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	b98080e7          	jalr	-1128(ra) # 80005e86 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800062f6:	8885                	andi	s1,s1,1
    800062f8:	f0ed                	bnez	s1,800062da <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800062fa:	0001c517          	auipc	a0,0x1c
    800062fe:	66e50513          	addi	a0,a0,1646 # 80022968 <disk+0x128>
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
}
    8000630a:	70e6                	ld	ra,120(sp)
    8000630c:	7446                	ld	s0,112(sp)
    8000630e:	74a6                	ld	s1,104(sp)
    80006310:	7906                	ld	s2,96(sp)
    80006312:	69e6                	ld	s3,88(sp)
    80006314:	6a46                	ld	s4,80(sp)
    80006316:	6aa6                	ld	s5,72(sp)
    80006318:	6b06                	ld	s6,64(sp)
    8000631a:	7be2                	ld	s7,56(sp)
    8000631c:	7c42                	ld	s8,48(sp)
    8000631e:	7ca2                	ld	s9,40(sp)
    80006320:	7d02                	ld	s10,32(sp)
    80006322:	6de2                	ld	s11,24(sp)
    80006324:	6109                	addi	sp,sp,128
    80006326:	8082                	ret

0000000080006328 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006328:	1101                	addi	sp,sp,-32
    8000632a:	ec06                	sd	ra,24(sp)
    8000632c:	e822                	sd	s0,16(sp)
    8000632e:	e426                	sd	s1,8(sp)
    80006330:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006332:	0001c497          	auipc	s1,0x1c
    80006336:	50e48493          	addi	s1,s1,1294 # 80022840 <disk>
    8000633a:	0001c517          	auipc	a0,0x1c
    8000633e:	62e50513          	addi	a0,a0,1582 # 80022968 <disk+0x128>
    80006342:	ffffb097          	auipc	ra,0xffffb
    80006346:	894080e7          	jalr	-1900(ra) # 80000bd6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000634a:	10001737          	lui	a4,0x10001
    8000634e:	533c                	lw	a5,96(a4)
    80006350:	8b8d                	andi	a5,a5,3
    80006352:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006354:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006358:	689c                	ld	a5,16(s1)
    8000635a:	0204d703          	lhu	a4,32(s1)
    8000635e:	0027d783          	lhu	a5,2(a5)
    80006362:	04f70863          	beq	a4,a5,800063b2 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006366:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000636a:	6898                	ld	a4,16(s1)
    8000636c:	0204d783          	lhu	a5,32(s1)
    80006370:	8b9d                	andi	a5,a5,7
    80006372:	078e                	slli	a5,a5,0x3
    80006374:	97ba                	add	a5,a5,a4
    80006376:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006378:	00278713          	addi	a4,a5,2
    8000637c:	0712                	slli	a4,a4,0x4
    8000637e:	9726                	add	a4,a4,s1
    80006380:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006384:	e721                	bnez	a4,800063cc <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006386:	0789                	addi	a5,a5,2
    80006388:	0792                	slli	a5,a5,0x4
    8000638a:	97a6                	add	a5,a5,s1
    8000638c:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000638e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006392:	ffffc097          	auipc	ra,0xffffc
    80006396:	df0080e7          	jalr	-528(ra) # 80002182 <wakeup>

    disk.used_idx += 1;
    8000639a:	0204d783          	lhu	a5,32(s1)
    8000639e:	2785                	addiw	a5,a5,1
    800063a0:	17c2                	slli	a5,a5,0x30
    800063a2:	93c1                	srli	a5,a5,0x30
    800063a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800063a8:	6898                	ld	a4,16(s1)
    800063aa:	00275703          	lhu	a4,2(a4)
    800063ae:	faf71ce3          	bne	a4,a5,80006366 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800063b2:	0001c517          	auipc	a0,0x1c
    800063b6:	5b650513          	addi	a0,a0,1462 # 80022968 <disk+0x128>
    800063ba:	ffffb097          	auipc	ra,0xffffb
    800063be:	8d0080e7          	jalr	-1840(ra) # 80000c8a <release>
}
    800063c2:	60e2                	ld	ra,24(sp)
    800063c4:	6442                	ld	s0,16(sp)
    800063c6:	64a2                	ld	s1,8(sp)
    800063c8:	6105                	addi	sp,sp,32
    800063ca:	8082                	ret
      panic("virtio_disk_intr status");
    800063cc:	00002517          	auipc	a0,0x2
    800063d0:	47c50513          	addi	a0,a0,1148 # 80008848 <syscalls+0x3e8>
    800063d4:	ffffa097          	auipc	ra,0xffffa
    800063d8:	16a080e7          	jalr	362(ra) # 8000053e <panic>
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
