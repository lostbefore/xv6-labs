
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7d2050ef          	jal	ra,800057e8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17a080e7          	jalr	378(ra) # 800001c2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	188080e7          	jalr	392(ra) # 800061e2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	228080e7          	jalr	552(ra) # 80006296 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c0e080e7          	jalr	-1010(ra) # 80005c98 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	05e080e7          	jalr	94(ra) # 80006152 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0b6080e7          	jalr	182(ra) # 800061e2 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	152080e7          	jalr	338(ra) # 80006296 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	070080e7          	jalr	112(ra) # 800001c2 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	128080e7          	jalr	296(ra) # 80006296 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <acquire_freemem>:

//Calculate the free memory
uint64 
acquire_freemem(){
    80000178:	1101                	addi	sp,sp,-32
    8000017a:	ec06                	sd	ra,24(sp)
    8000017c:	e822                	sd	s0,16(sp)
    8000017e:	e426                	sd	s1,8(sp)
    80000180:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 cnt = 0;

  acquire(&kmem.lock);
    80000182:	00009497          	auipc	s1,0x9
    80000186:	eae48493          	addi	s1,s1,-338 # 80009030 <kmem>
    8000018a:	8526                	mv	a0,s1
    8000018c:	00006097          	auipc	ra,0x6
    80000190:	056080e7          	jalr	86(ra) # 800061e2 <acquire>
  r=kmem.freelist;
    80000194:	6c9c                	ld	a5,24(s1)
  while(r){
    80000196:	c785                	beqz	a5,800001be <acquire_freemem+0x46>
  uint64 cnt = 0;
    80000198:	4481                	li	s1,0
    r=r->next;
    8000019a:	639c                	ld	a5,0(a5)
    cnt++;
    8000019c:	0485                	addi	s1,s1,1
  while(r){
    8000019e:	fff5                	bnez	a5,8000019a <acquire_freemem+0x22>
  }
  release(&kmem.lock);
    800001a0:	00009517          	auipc	a0,0x9
    800001a4:	e9050513          	addi	a0,a0,-368 # 80009030 <kmem>
    800001a8:	00006097          	auipc	ra,0x6
    800001ac:	0ee080e7          	jalr	238(ra) # 80006296 <release>
  
  return cnt*PGSIZE;
    800001b0:	00c49513          	slli	a0,s1,0xc
    800001b4:	60e2                	ld	ra,24(sp)
    800001b6:	6442                	ld	s0,16(sp)
    800001b8:	64a2                	ld	s1,8(sp)
    800001ba:	6105                	addi	sp,sp,32
    800001bc:	8082                	ret
  uint64 cnt = 0;
    800001be:	4481                	li	s1,0
    800001c0:	b7c5                	j	800001a0 <acquire_freemem+0x28>

00000000800001c2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001c8:	ce09                	beqz	a2,800001e2 <memset+0x20>
    800001ca:	87aa                	mv	a5,a0
    800001cc:	fff6071b          	addiw	a4,a2,-1
    800001d0:	1702                	slli	a4,a4,0x20
    800001d2:	9301                	srli	a4,a4,0x20
    800001d4:	0705                	addi	a4,a4,1
    800001d6:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x16>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	ca0d                	beqz	a2,8000025a <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	00a5f963          	bgeu	a1,a0,8000023c <memmove+0x1a>
    8000022e:	02061693          	slli	a3,a2,0x20
    80000232:	9281                	srli	a3,a3,0x20
    80000234:	00d58733          	add	a4,a1,a3
    80000238:	02e56463          	bltu	a0,a4,80000260 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	0785                	addi	a5,a5,1
    80000246:	97ae                	add	a5,a5,a1
    80000248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000024a:	0585                	addi	a1,a1,1
    8000024c:	0705                	addi	a4,a4,1
    8000024e:	fff5c683          	lbu	a3,-1(a1)
    80000252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000256:	fef59ae3          	bne	a1,a5,8000024a <memmove+0x28>

  return dst;
}
    8000025a:	6422                	ld	s0,8(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret
    d += n;
    80000260:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000262:	fff6079b          	addiw	a5,a2,-1
    80000266:	1782                	slli	a5,a5,0x20
    80000268:	9381                	srli	a5,a5,0x20
    8000026a:	fff7c793          	not	a5,a5
    8000026e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000270:	177d                	addi	a4,a4,-1
    80000272:	16fd                	addi	a3,a3,-1
    80000274:	00074603          	lbu	a2,0(a4)
    80000278:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000027c:	fef71ae3          	bne	a4,a5,80000270 <memmove+0x4e>
    80000280:	bfe9                	j	8000025a <memmove+0x38>

0000000080000282 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	f98080e7          	jalr	-104(ra) # 80000222 <memmove>
}
    80000292:	60a2                	ld	ra,8(sp)
    80000294:	6402                	ld	s0,0(sp)
    80000296:	0141                	addi	sp,sp,16
    80000298:	8082                	ret

000000008000029a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000029a:	1141                	addi	sp,sp,-16
    8000029c:	e422                	sd	s0,8(sp)
    8000029e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002a0:	ce11                	beqz	a2,800002bc <strncmp+0x22>
    800002a2:	00054783          	lbu	a5,0(a0)
    800002a6:	cf89                	beqz	a5,800002c0 <strncmp+0x26>
    800002a8:	0005c703          	lbu	a4,0(a1)
    800002ac:	00f71a63          	bne	a4,a5,800002c0 <strncmp+0x26>
    n--, p++, q++;
    800002b0:	367d                	addiw	a2,a2,-1
    800002b2:	0505                	addi	a0,a0,1
    800002b4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b6:	f675                	bnez	a2,800002a2 <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b8:	4501                	li	a0,0
    800002ba:	a809                	j	800002cc <strncmp+0x32>
    800002bc:	4501                	li	a0,0
    800002be:	a039                	j	800002cc <strncmp+0x32>
  if(n == 0)
    800002c0:	ca09                	beqz	a2,800002d2 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002c2:	00054503          	lbu	a0,0(a0)
    800002c6:	0005c783          	lbu	a5,0(a1)
    800002ca:	9d1d                	subw	a0,a0,a5
}
    800002cc:	6422                	ld	s0,8(sp)
    800002ce:	0141                	addi	sp,sp,16
    800002d0:	8082                	ret
    return 0;
    800002d2:	4501                	li	a0,0
    800002d4:	bfe5                	j	800002cc <strncmp+0x32>

00000000800002d6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e422                	sd	s0,8(sp)
    800002da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002dc:	872a                	mv	a4,a0
    800002de:	8832                	mv	a6,a2
    800002e0:	367d                	addiw	a2,a2,-1
    800002e2:	01005963          	blez	a6,800002f4 <strncpy+0x1e>
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	0005c783          	lbu	a5,0(a1)
    800002ec:	fef70fa3          	sb	a5,-1(a4)
    800002f0:	0585                	addi	a1,a1,1
    800002f2:	f7f5                	bnez	a5,800002de <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f4:	00c05d63          	blez	a2,8000030e <strncpy+0x38>
    800002f8:	86ba                	mv	a3,a4
    *s++ = 0;
    800002fa:	0685                	addi	a3,a3,1
    800002fc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000300:	fff6c793          	not	a5,a3
    80000304:	9fb9                	addw	a5,a5,a4
    80000306:	010787bb          	addw	a5,a5,a6
    8000030a:	fef048e3          	bgtz	a5,800002fa <strncpy+0x24>
  return os;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret

0000000080000314 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e422                	sd	s0,8(sp)
    80000318:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000031a:	02c05363          	blez	a2,80000340 <safestrcpy+0x2c>
    8000031e:	fff6069b          	addiw	a3,a2,-1
    80000322:	1682                	slli	a3,a3,0x20
    80000324:	9281                	srli	a3,a3,0x20
    80000326:	96ae                	add	a3,a3,a1
    80000328:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000032a:	00d58963          	beq	a1,a3,8000033c <safestrcpy+0x28>
    8000032e:	0585                	addi	a1,a1,1
    80000330:	0785                	addi	a5,a5,1
    80000332:	fff5c703          	lbu	a4,-1(a1)
    80000336:	fee78fa3          	sb	a4,-1(a5)
    8000033a:	fb65                	bnez	a4,8000032a <safestrcpy+0x16>
    ;
  *s = 0;
    8000033c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret

0000000080000346 <strlen>:

int
strlen(const char *s)
{
    80000346:	1141                	addi	sp,sp,-16
    80000348:	e422                	sd	s0,8(sp)
    8000034a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf91                	beqz	a5,8000036c <strlen+0x26>
    80000352:	0505                	addi	a0,a0,1
    80000354:	87aa                	mv	a5,a0
    80000356:	4685                	li	a3,1
    80000358:	9e89                	subw	a3,a3,a0
    8000035a:	00f6853b          	addw	a0,a3,a5
    8000035e:	0785                	addi	a5,a5,1
    80000360:	fff7c703          	lbu	a4,-1(a5)
    80000364:	fb7d                	bnez	a4,8000035a <strlen+0x14>
    ;
  return n;
}
    80000366:	6422                	ld	s0,8(sp)
    80000368:	0141                	addi	sp,sp,16
    8000036a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000036c:	4501                	li	a0,0
    8000036e:	bfe5                	j	80000366 <strlen+0x20>

0000000080000370 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000378:	00001097          	auipc	ra,0x1
    8000037c:	aee080e7          	jalr	-1298(ra) # 80000e66 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000380:	00009717          	auipc	a4,0x9
    80000384:	c8070713          	addi	a4,a4,-896 # 80009000 <started>
  if(cpuid() == 0){
    80000388:	c139                	beqz	a0,800003ce <main+0x5e>
    while(started == 0)
    8000038a:	431c                	lw	a5,0(a4)
    8000038c:	2781                	sext.w	a5,a5
    8000038e:	dff5                	beqz	a5,8000038a <main+0x1a>
      ;
    __sync_synchronize();
    80000390:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000394:	00001097          	auipc	ra,0x1
    80000398:	ad2080e7          	jalr	-1326(ra) # 80000e66 <cpuid>
    8000039c:	85aa                	mv	a1,a0
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c9a50513          	addi	a0,a0,-870 # 80008038 <etext+0x38>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	93c080e7          	jalr	-1732(ra) # 80005ce2 <printf>
    kvminithart();    // turn on paging
    800003ae:	00000097          	auipc	ra,0x0
    800003b2:	0d8080e7          	jalr	216(ra) # 80000486 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b6:	00001097          	auipc	ra,0x1
    800003ba:	78a080e7          	jalr	1930(ra) # 80001b40 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003be:	00005097          	auipc	ra,0x5
    800003c2:	db2080e7          	jalr	-590(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    800003c6:	00001097          	auipc	ra,0x1
    800003ca:	fe2080e7          	jalr	-30(ra) # 800013a8 <scheduler>
    consoleinit();
    800003ce:	00005097          	auipc	ra,0x5
    800003d2:	7dc080e7          	jalr	2012(ra) # 80005baa <consoleinit>
    printfinit();
    800003d6:	00006097          	auipc	ra,0x6
    800003da:	af2080e7          	jalr	-1294(ra) # 80005ec8 <printfinit>
    printf("\n");
    800003de:	00008517          	auipc	a0,0x8
    800003e2:	c6a50513          	addi	a0,a0,-918 # 80008048 <etext+0x48>
    800003e6:	00006097          	auipc	ra,0x6
    800003ea:	8fc080e7          	jalr	-1796(ra) # 80005ce2 <printf>
    printf("xv6 kernel is booting\n");
    800003ee:	00008517          	auipc	a0,0x8
    800003f2:	c3250513          	addi	a0,a0,-974 # 80008020 <etext+0x20>
    800003f6:	00006097          	auipc	ra,0x6
    800003fa:	8ec080e7          	jalr	-1812(ra) # 80005ce2 <printf>
    printf("\n");
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c4a50513          	addi	a0,a0,-950 # 80008048 <etext+0x48>
    80000406:	00006097          	auipc	ra,0x6
    8000040a:	8dc080e7          	jalr	-1828(ra) # 80005ce2 <printf>
    kinit();         // physical page allocator
    8000040e:	00000097          	auipc	ra,0x0
    80000412:	cce080e7          	jalr	-818(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	322080e7          	jalr	802(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	068080e7          	jalr	104(ra) # 80000486 <kvminithart>
    procinit();      // process table
    80000426:	00001097          	auipc	ra,0x1
    8000042a:	990080e7          	jalr	-1648(ra) # 80000db6 <procinit>
    trapinit();      // trap vectors
    8000042e:	00001097          	auipc	ra,0x1
    80000432:	6ea080e7          	jalr	1770(ra) # 80001b18 <trapinit>
    trapinithart();  // install kernel trap vector
    80000436:	00001097          	auipc	ra,0x1
    8000043a:	70a080e7          	jalr	1802(ra) # 80001b40 <trapinithart>
    plicinit();      // set up interrupt controller
    8000043e:	00005097          	auipc	ra,0x5
    80000442:	d1c080e7          	jalr	-740(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000446:	00005097          	auipc	ra,0x5
    8000044a:	d2a080e7          	jalr	-726(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    8000044e:	00002097          	auipc	ra,0x2
    80000452:	f0c080e7          	jalr	-244(ra) # 8000235a <binit>
    iinit();         // inode table
    80000456:	00002097          	auipc	ra,0x2
    8000045a:	59c080e7          	jalr	1436(ra) # 800029f2 <iinit>
    fileinit();      // file table
    8000045e:	00003097          	auipc	ra,0x3
    80000462:	546080e7          	jalr	1350(ra) # 800039a4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000466:	00005097          	auipc	ra,0x5
    8000046a:	e2c080e7          	jalr	-468(ra) # 80005292 <virtio_disk_init>
    userinit();      // first user process
    8000046e:	00001097          	auipc	ra,0x1
    80000472:	d00080e7          	jalr	-768(ra) # 8000116e <userinit>
    __sync_synchronize();
    80000476:	0ff0000f          	fence
    started = 1;
    8000047a:	4785                	li	a5,1
    8000047c:	00009717          	auipc	a4,0x9
    80000480:	b8f72223          	sw	a5,-1148(a4) # 80009000 <started>
    80000484:	b789                	j	800003c6 <main+0x56>

0000000080000486 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e422                	sd	s0,8(sp)
    8000048a:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00009797          	auipc	a5,0x9
    80000490:	b7c7b783          	ld	a5,-1156(a5) # 80009008 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00005097          	auipc	ra,0x5
    800004dc:	7c0080e7          	jalr	1984(ra) # 80005c98 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c34080e7          	jalr	-972(ra) # 80000118 <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cce080e7          	jalr	-818(ra) # 800001c2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	00a7d513          	srli	a0,a5,0xa
    8000058a:	0532                	slli	a0,a0,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c205                	beqz	a2,800005c8 <mappages+0x36>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	77fd                	lui	a5,0xfffff
    800005b0:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	15fd                	addi	a1,a1,-1
    800005b6:	00c589b3          	add	s3,a1,a2
    800005ba:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800005be:	8952                	mv	s2,s4
    800005c0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	a015                	j	800005ea <mappages+0x58>
    panic("mappages: size");
    800005c8:	00008517          	auipc	a0,0x8
    800005cc:	a9050513          	addi	a0,a0,-1392 # 80008058 <etext+0x58>
    800005d0:	00005097          	auipc	ra,0x5
    800005d4:	6c8080e7          	jalr	1736(ra) # 80005c98 <panic>
      panic("mappages: remap");
    800005d8:	00008517          	auipc	a0,0x8
    800005dc:	a9050513          	addi	a0,a0,-1392 # 80008068 <etext+0x68>
    800005e0:	00005097          	auipc	ra,0x5
    800005e4:	6b8080e7          	jalr	1720(ra) # 80005c98 <panic>
    a += PGSIZE;
    800005e8:	995e                	add	s2,s2,s7
  for(;;){
    800005ea:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	4605                	li	a2,1
    800005f0:	85ca                	mv	a1,s2
    800005f2:	8556                	mv	a0,s5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	eb6080e7          	jalr	-330(ra) # 800004aa <walk>
    800005fc:	cd19                	beqz	a0,8000061a <mappages+0x88>
    if(*pte & PTE_V)
    800005fe:	611c                	ld	a5,0(a0)
    80000600:	8b85                	andi	a5,a5,1
    80000602:	fbf9                	bnez	a5,800005d8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000604:	80b1                	srli	s1,s1,0xc
    80000606:	04aa                	slli	s1,s1,0xa
    80000608:	0164e4b3          	or	s1,s1,s6
    8000060c:	0014e493          	ori	s1,s1,1
    80000610:	e104                	sd	s1,0(a0)
    if(a == last)
    80000612:	fd391be3          	bne	s2,s3,800005e8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000616:	4501                	li	a0,0
    80000618:	a011                	j	8000061c <mappages+0x8a>
      return -1;
    8000061a:	557d                	li	a0,-1
}
    8000061c:	60a6                	ld	ra,72(sp)
    8000061e:	6406                	ld	s0,64(sp)
    80000620:	74e2                	ld	s1,56(sp)
    80000622:	7942                	ld	s2,48(sp)
    80000624:	79a2                	ld	s3,40(sp)
    80000626:	7a02                	ld	s4,32(sp)
    80000628:	6ae2                	ld	s5,24(sp)
    8000062a:	6b42                	ld	s6,16(sp)
    8000062c:	6ba2                	ld	s7,8(sp)
    8000062e:	6161                	addi	sp,sp,80
    80000630:	8082                	ret

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	63e080e7          	jalr	1598(ra) # 80005c98 <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aaa080e7          	jalr	-1366(ra) # 80000118 <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b46080e7          	jalr	-1210(ra) # 800001c2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	5fe080e7          	jalr	1534(ra) # 80000d20 <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00009797          	auipc	a5,0x9
    8000074c:	8ca7b023          	sd	a0,-1856(a5) # 80009008 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e863          	bltu	a1,s3,800007f4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	4f2080e7          	jalr	1266(ra) # 80005c98 <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	4e2080e7          	jalr	1250(ra) # 80005c98 <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	4d2080e7          	jalr	1234(ra) # 80005c98 <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	4c2080e7          	jalr	1218(ra) # 80005c98 <panic>
      uint64 pa = PTE2PA(*pte);
    800007de:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007e0:	0532                	slli	a0,a0,0xc
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	83a080e7          	jalr	-1990(ra) # 8000001c <kfree>
    *pte = 0;
    800007ea:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ee:	995a                	add	s2,s2,s6
    800007f0:	f9397ce3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007f4:	4601                	li	a2,0
    800007f6:	85ca                	mv	a1,s2
    800007f8:	8552                	mv	a0,s4
    800007fa:	00000097          	auipc	ra,0x0
    800007fe:	cb0080e7          	jalr	-848(ra) # 800004aa <walk>
    80000802:	84aa                	mv	s1,a0
    80000804:	d54d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000806:	6108                	ld	a0,0(a0)
    80000808:	00157793          	andi	a5,a0,1
    8000080c:	dbcd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000080e:	3ff57793          	andi	a5,a0,1023
    80000812:	fb778ee3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    80000816:	fc0a8ae3          	beqz	s5,800007ea <uvmunmap+0x92>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f2080e7          	jalr	-1806(ra) # 80000118 <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	98c080e7          	jalr	-1652(ra) # 800001c2 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvminit+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b2080e7          	jalr	-1870(ra) # 80000118 <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	94e080e7          	jalr	-1714(ra) # 800001c2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("inituvm: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	3e4080e7          	jalr	996(ra) # 80005c98 <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	767d                	lui	a2,0xfffff
    800008d8:	8f71                	and	a4,a4,a2
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff1                	and	a5,a5,a2
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66163          	bltu	a2,a1,800009a6 <uvmalloc+0xa2>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	0080                	addi	s0,sp,64
    8000091a:	8aaa                	mv	s5,a0
    8000091c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091e:	6985                	lui	s3,0x1
    80000920:	19fd                	addi	s3,s3,-1
    80000922:	95ce                	add	a1,a1,s3
    80000924:	79fd                	lui	s3,0xfffff
    80000926:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092a:	08c9f063          	bgeu	s3,a2,800009aa <uvmalloc+0xa6>
    8000092e:	894e                	mv	s2,s3
    mem = kalloc();
    80000930:	fffff097          	auipc	ra,0xfffff
    80000934:	7e8080e7          	jalr	2024(ra) # 80000118 <kalloc>
    80000938:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093a:	c51d                	beqz	a0,80000968 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000093c:	6605                	lui	a2,0x1
    8000093e:	4581                	li	a1,0
    80000940:	00000097          	auipc	ra,0x0
    80000944:	882080e7          	jalr	-1918(ra) # 800001c2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000948:	4779                	li	a4,30
    8000094a:	86a6                	mv	a3,s1
    8000094c:	6605                	lui	a2,0x1
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	c40080e7          	jalr	-960(ra) # 80000592 <mappages>
    8000095a:	e905                	bnez	a0,8000098a <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095c:	6785                	lui	a5,0x1
    8000095e:	993e                	add	s2,s2,a5
    80000960:	fd4968e3          	bltu	s2,s4,80000930 <uvmalloc+0x2c>
  return newsz;
    80000964:	8552                	mv	a0,s4
    80000966:	a809                	j	80000978 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000968:	864e                	mv	a2,s3
    8000096a:	85ca                	mv	a1,s2
    8000096c:	8556                	mv	a0,s5
    8000096e:	00000097          	auipc	ra,0x0
    80000972:	f4e080e7          	jalr	-178(ra) # 800008bc <uvmdealloc>
      return 0;
    80000976:	4501                	li	a0,0
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	74a2                	ld	s1,40(sp)
    8000097e:	7902                	ld	s2,32(sp)
    80000980:	69e2                	ld	s3,24(sp)
    80000982:	6a42                	ld	s4,16(sp)
    80000984:	6aa2                	ld	s5,8(sp)
    80000986:	6121                	addi	sp,sp,64
    80000988:	8082                	ret
      kfree(mem);
    8000098a:	8526                	mv	a0,s1
    8000098c:	fffff097          	auipc	ra,0xfffff
    80000990:	690080e7          	jalr	1680(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000994:	864e                	mv	a2,s3
    80000996:	85ca                	mv	a1,s2
    80000998:	8556                	mv	a0,s5
    8000099a:	00000097          	auipc	ra,0x0
    8000099e:	f22080e7          	jalr	-222(ra) # 800008bc <uvmdealloc>
      return 0;
    800009a2:	4501                	li	a0,0
    800009a4:	bfd1                	j	80000978 <uvmalloc+0x74>
    return oldsz;
    800009a6:	852e                	mv	a0,a1
}
    800009a8:	8082                	ret
  return newsz;
    800009aa:	8532                	mv	a0,a2
    800009ac:	b7f1                	j	80000978 <uvmalloc+0x74>

00000000800009ae <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009ae:	7179                	addi	sp,sp,-48
    800009b0:	f406                	sd	ra,40(sp)
    800009b2:	f022                	sd	s0,32(sp)
    800009b4:	ec26                	sd	s1,24(sp)
    800009b6:	e84a                	sd	s2,16(sp)
    800009b8:	e44e                	sd	s3,8(sp)
    800009ba:	e052                	sd	s4,0(sp)
    800009bc:	1800                	addi	s0,sp,48
    800009be:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c0:	84aa                	mv	s1,a0
    800009c2:	6905                	lui	s2,0x1
    800009c4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c6:	4985                	li	s3,1
    800009c8:	a821                	j	800009e0 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009ca:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009cc:	0532                	slli	a0,a0,0xc
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	fe0080e7          	jalr	-32(ra) # 800009ae <freewalk>
      pagetable[i] = 0;
    800009d6:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009da:	04a1                	addi	s1,s1,8
    800009dc:	03248163          	beq	s1,s2,800009fe <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009e0:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009e2:	00f57793          	andi	a5,a0,15
    800009e6:	ff3782e3          	beq	a5,s3,800009ca <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ea:	8905                	andi	a0,a0,1
    800009ec:	d57d                	beqz	a0,800009da <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ee:	00007517          	auipc	a0,0x7
    800009f2:	70a50513          	addi	a0,a0,1802 # 800080f8 <etext+0xf8>
    800009f6:	00005097          	auipc	ra,0x5
    800009fa:	2a2080e7          	jalr	674(ra) # 80005c98 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fe:	8552                	mv	a0,s4
    80000a00:	fffff097          	auipc	ra,0xfffff
    80000a04:	61c080e7          	jalr	1564(ra) # 8000001c <kfree>
}
    80000a08:	70a2                	ld	ra,40(sp)
    80000a0a:	7402                	ld	s0,32(sp)
    80000a0c:	64e2                	ld	s1,24(sp)
    80000a0e:	6942                	ld	s2,16(sp)
    80000a10:	69a2                	ld	s3,8(sp)
    80000a12:	6a02                	ld	s4,0(sp)
    80000a14:	6145                	addi	sp,sp,48
    80000a16:	8082                	ret

0000000080000a18 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a18:	1101                	addi	sp,sp,-32
    80000a1a:	ec06                	sd	ra,24(sp)
    80000a1c:	e822                	sd	s0,16(sp)
    80000a1e:	e426                	sd	s1,8(sp)
    80000a20:	1000                	addi	s0,sp,32
    80000a22:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a24:	e999                	bnez	a1,80000a3a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a26:	8526                	mv	a0,s1
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	f86080e7          	jalr	-122(ra) # 800009ae <freewalk>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6105                	addi	sp,sp,32
    80000a38:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a3a:	6605                	lui	a2,0x1
    80000a3c:	167d                	addi	a2,a2,-1
    80000a3e:	962e                	add	a2,a2,a1
    80000a40:	4685                	li	a3,1
    80000a42:	8231                	srli	a2,a2,0xc
    80000a44:	4581                	li	a1,0
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	d12080e7          	jalr	-750(ra) # 80000758 <uvmunmap>
    80000a4e:	bfe1                	j	80000a26 <uvmfree+0xe>

0000000080000a50 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a50:	c679                	beqz	a2,80000b1e <uvmcopy+0xce>
{
    80000a52:	715d                	addi	sp,sp,-80
    80000a54:	e486                	sd	ra,72(sp)
    80000a56:	e0a2                	sd	s0,64(sp)
    80000a58:	fc26                	sd	s1,56(sp)
    80000a5a:	f84a                	sd	s2,48(sp)
    80000a5c:	f44e                	sd	s3,40(sp)
    80000a5e:	f052                	sd	s4,32(sp)
    80000a60:	ec56                	sd	s5,24(sp)
    80000a62:	e85a                	sd	s6,16(sp)
    80000a64:	e45e                	sd	s7,8(sp)
    80000a66:	0880                	addi	s0,sp,80
    80000a68:	8b2a                	mv	s6,a0
    80000a6a:	8aae                	mv	s5,a1
    80000a6c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a70:	4601                	li	a2,0
    80000a72:	85ce                	mv	a1,s3
    80000a74:	855a                	mv	a0,s6
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	a34080e7          	jalr	-1484(ra) # 800004aa <walk>
    80000a7e:	c531                	beqz	a0,80000aca <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a80:	6118                	ld	a4,0(a0)
    80000a82:	00177793          	andi	a5,a4,1
    80000a86:	cbb1                	beqz	a5,80000ada <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a88:	00a75593          	srli	a1,a4,0xa
    80000a8c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a90:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a94:	fffff097          	auipc	ra,0xfffff
    80000a98:	684080e7          	jalr	1668(ra) # 80000118 <kalloc>
    80000a9c:	892a                	mv	s2,a0
    80000a9e:	c939                	beqz	a0,80000af4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aa0:	6605                	lui	a2,0x1
    80000aa2:	85de                	mv	a1,s7
    80000aa4:	fffff097          	auipc	ra,0xfffff
    80000aa8:	77e080e7          	jalr	1918(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aac:	8726                	mv	a4,s1
    80000aae:	86ca                	mv	a3,s2
    80000ab0:	6605                	lui	a2,0x1
    80000ab2:	85ce                	mv	a1,s3
    80000ab4:	8556                	mv	a0,s5
    80000ab6:	00000097          	auipc	ra,0x0
    80000aba:	adc080e7          	jalr	-1316(ra) # 80000592 <mappages>
    80000abe:	e515                	bnez	a0,80000aea <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	99be                	add	s3,s3,a5
    80000ac4:	fb49e6e3          	bltu	s3,s4,80000a70 <uvmcopy+0x20>
    80000ac8:	a081                	j	80000b08 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aca:	00007517          	auipc	a0,0x7
    80000ace:	63e50513          	addi	a0,a0,1598 # 80008108 <etext+0x108>
    80000ad2:	00005097          	auipc	ra,0x5
    80000ad6:	1c6080e7          	jalr	454(ra) # 80005c98 <panic>
      panic("uvmcopy: page not present");
    80000ada:	00007517          	auipc	a0,0x7
    80000ade:	64e50513          	addi	a0,a0,1614 # 80008128 <etext+0x128>
    80000ae2:	00005097          	auipc	ra,0x5
    80000ae6:	1b6080e7          	jalr	438(ra) # 80005c98 <panic>
      kfree(mem);
    80000aea:	854a                	mv	a0,s2
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af4:	4685                	li	a3,1
    80000af6:	00c9d613          	srli	a2,s3,0xc
    80000afa:	4581                	li	a1,0
    80000afc:	8556                	mv	a0,s5
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	c5a080e7          	jalr	-934(ra) # 80000758 <uvmunmap>
  return -1;
    80000b06:	557d                	li	a0,-1
}
    80000b08:	60a6                	ld	ra,72(sp)
    80000b0a:	6406                	ld	s0,64(sp)
    80000b0c:	74e2                	ld	s1,56(sp)
    80000b0e:	7942                	ld	s2,48(sp)
    80000b10:	79a2                	ld	s3,40(sp)
    80000b12:	7a02                	ld	s4,32(sp)
    80000b14:	6ae2                	ld	s5,24(sp)
    80000b16:	6b42                	ld	s6,16(sp)
    80000b18:	6ba2                	ld	s7,8(sp)
    80000b1a:	6161                	addi	sp,sp,80
    80000b1c:	8082                	ret
  return 0;
    80000b1e:	4501                	li	a0,0
}
    80000b20:	8082                	ret

0000000080000b22 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b2a:	4601                	li	a2,0
    80000b2c:	00000097          	auipc	ra,0x0
    80000b30:	97e080e7          	jalr	-1666(ra) # 800004aa <walk>
  if(pte == 0)
    80000b34:	c901                	beqz	a0,80000b44 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	9bbd                	andi	a5,a5,-17
    80000b3a:	e11c                	sd	a5,0(a0)
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret
    panic("uvmclear");
    80000b44:	00007517          	auipc	a0,0x7
    80000b48:	60450513          	addi	a0,a0,1540 # 80008148 <etext+0x148>
    80000b4c:	00005097          	auipc	ra,0x5
    80000b50:	14c080e7          	jalr	332(ra) # 80005c98 <panic>

0000000080000b54 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b54:	c6bd                	beqz	a3,80000bc2 <copyout+0x6e>
{
    80000b56:	715d                	addi	sp,sp,-80
    80000b58:	e486                	sd	ra,72(sp)
    80000b5a:	e0a2                	sd	s0,64(sp)
    80000b5c:	fc26                	sd	s1,56(sp)
    80000b5e:	f84a                	sd	s2,48(sp)
    80000b60:	f44e                	sd	s3,40(sp)
    80000b62:	f052                	sd	s4,32(sp)
    80000b64:	ec56                	sd	s5,24(sp)
    80000b66:	e85a                	sd	s6,16(sp)
    80000b68:	e45e                	sd	s7,8(sp)
    80000b6a:	e062                	sd	s8,0(sp)
    80000b6c:	0880                	addi	s0,sp,80
    80000b6e:	8b2a                	mv	s6,a0
    80000b70:	8c2e                	mv	s8,a1
    80000b72:	8a32                	mv	s4,a2
    80000b74:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b76:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b78:	6a85                	lui	s5,0x1
    80000b7a:	a015                	j	80000b9e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7c:	9562                	add	a0,a0,s8
    80000b7e:	0004861b          	sext.w	a2,s1
    80000b82:	85d2                	mv	a1,s4
    80000b84:	41250533          	sub	a0,a0,s2
    80000b88:	fffff097          	auipc	ra,0xfffff
    80000b8c:	69a080e7          	jalr	1690(ra) # 80000222 <memmove>

    len -= n;
    80000b90:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b94:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b96:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b9a:	02098263          	beqz	s3,80000bbe <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba2:	85ca                	mv	a1,s2
    80000ba4:	855a                	mv	a0,s6
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	9aa080e7          	jalr	-1622(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bae:	cd01                	beqz	a0,80000bc6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bb0:	418904b3          	sub	s1,s2,s8
    80000bb4:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bb6:	fc99f3e3          	bgeu	s3,s1,80000b7c <copyout+0x28>
    80000bba:	84ce                	mv	s1,s3
    80000bbc:	b7c1                	j	80000b7c <copyout+0x28>
  }
  return 0;
    80000bbe:	4501                	li	a0,0
    80000bc0:	a021                	j	80000bc8 <copyout+0x74>
    80000bc2:	4501                	li	a0,0
}
    80000bc4:	8082                	ret
      return -1;
    80000bc6:	557d                	li	a0,-1
}
    80000bc8:	60a6                	ld	ra,72(sp)
    80000bca:	6406                	ld	s0,64(sp)
    80000bcc:	74e2                	ld	s1,56(sp)
    80000bce:	7942                	ld	s2,48(sp)
    80000bd0:	79a2                	ld	s3,40(sp)
    80000bd2:	7a02                	ld	s4,32(sp)
    80000bd4:	6ae2                	ld	s5,24(sp)
    80000bd6:	6b42                	ld	s6,16(sp)
    80000bd8:	6ba2                	ld	s7,8(sp)
    80000bda:	6c02                	ld	s8,0(sp)
    80000bdc:	6161                	addi	sp,sp,80
    80000bde:	8082                	ret

0000000080000be0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000be0:	c6bd                	beqz	a3,80000c4e <copyin+0x6e>
{
    80000be2:	715d                	addi	sp,sp,-80
    80000be4:	e486                	sd	ra,72(sp)
    80000be6:	e0a2                	sd	s0,64(sp)
    80000be8:	fc26                	sd	s1,56(sp)
    80000bea:	f84a                	sd	s2,48(sp)
    80000bec:	f44e                	sd	s3,40(sp)
    80000bee:	f052                	sd	s4,32(sp)
    80000bf0:	ec56                	sd	s5,24(sp)
    80000bf2:	e85a                	sd	s6,16(sp)
    80000bf4:	e45e                	sd	s7,8(sp)
    80000bf6:	e062                	sd	s8,0(sp)
    80000bf8:	0880                	addi	s0,sp,80
    80000bfa:	8b2a                	mv	s6,a0
    80000bfc:	8a2e                	mv	s4,a1
    80000bfe:	8c32                	mv	s8,a2
    80000c00:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c02:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c04:	6a85                	lui	s5,0x1
    80000c06:	a015                	j	80000c2a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c08:	9562                	add	a0,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412505b3          	sub	a1,a0,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60e080e7          	jalr	1550(ra) # 80000222 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	91e080e7          	jalr	-1762(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c42:	fc99f3e3          	bgeu	s3,s1,80000c08 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	b7c1                	j	80000c08 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x74>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c6c5                	beqz	a3,80000d14 <copyinstr+0xa8>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a035                	j	80000cbc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	0017b793          	seqz	a5,a5
    80000c9c:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ca0:	60a6                	ld	ra,72(sp)
    80000ca2:	6406                	ld	s0,64(sp)
    80000ca4:	74e2                	ld	s1,56(sp)
    80000ca6:	7942                	ld	s2,48(sp)
    80000ca8:	79a2                	ld	s3,40(sp)
    80000caa:	7a02                	ld	s4,32(sp)
    80000cac:	6ae2                	ld	s5,24(sp)
    80000cae:	6b42                	ld	s6,16(sp)
    80000cb0:	6ba2                	ld	s7,8(sp)
    80000cb2:	6161                	addi	sp,sp,80
    80000cb4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cba:	c8a9                	beqz	s1,80000d0c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cbc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cc0:	85ca                	mv	a1,s2
    80000cc2:	8552                	mv	a0,s4
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	88c080e7          	jalr	-1908(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000ccc:	c131                	beqz	a0,80000d10 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cce:	41790833          	sub	a6,s2,s7
    80000cd2:	984e                	add	a6,a6,s3
    if(n > max)
    80000cd4:	0104f363          	bgeu	s1,a6,80000cda <copyinstr+0x6e>
    80000cd8:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cda:	955e                	add	a0,a0,s7
    80000cdc:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ce0:	fc080be3          	beqz	a6,80000cb6 <copyinstr+0x4a>
    80000ce4:	985a                	add	a6,a6,s6
    80000ce6:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce8:	41650633          	sub	a2,a0,s6
    80000cec:	14fd                	addi	s1,s1,-1
    80000cee:	9b26                	add	s6,s6,s1
    80000cf0:	00f60733          	add	a4,a2,a5
    80000cf4:	00074703          	lbu	a4,0(a4)
    80000cf8:	df49                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cfa:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfe:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d02:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d04:	ff0796e3          	bne	a5,a6,80000cf0 <copyinstr+0x84>
      dst++;
    80000d08:	8b42                	mv	s6,a6
    80000d0a:	b775                	j	80000cb6 <copyinstr+0x4a>
    80000d0c:	4781                	li	a5,0
    80000d0e:	b769                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d10:	557d                	li	a0,-1
    80000d12:	b779                	j	80000ca0 <copyinstr+0x34>
  int got_null = 0;
    80000d14:	4781                	li	a5,0
  if(got_null){
    80000d16:	0017b793          	seqz	a5,a5
    80000d1a:	40f00533          	neg	a0,a5
}
    80000d1e:	8082                	ret

0000000080000d20 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d20:	7139                	addi	sp,sp,-64
    80000d22:	fc06                	sd	ra,56(sp)
    80000d24:	f822                	sd	s0,48(sp)
    80000d26:	f426                	sd	s1,40(sp)
    80000d28:	f04a                	sd	s2,32(sp)
    80000d2a:	ec4e                	sd	s3,24(sp)
    80000d2c:	e852                	sd	s4,16(sp)
    80000d2e:	e456                	sd	s5,8(sp)
    80000d30:	e05a                	sd	s6,0(sp)
    80000d32:	0080                	addi	s0,sp,64
    80000d34:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	74a48493          	addi	s1,s1,1866 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	8b26                	mv	s6,s1
    80000d40:	00007a97          	auipc	s5,0x7
    80000d44:	2c0a8a93          	addi	s5,s5,704 # 80008000 <etext>
    80000d48:	04000937          	lui	s2,0x4000
    80000d4c:	197d                	addi	s2,s2,-1
    80000d4e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000ea17          	auipc	s4,0xe
    80000d54:	330a0a13          	addi	s4,s4,816 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	3c0080e7          	jalr	960(ra) # 80000118 <kalloc>
    80000d60:	862a                	mv	a2,a0
    if(pa == 0)
    80000d62:	c131                	beqz	a0,80000da6 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d64:	416485b3          	sub	a1,s1,s6
    80000d68:	8591                	srai	a1,a1,0x4
    80000d6a:	000ab783          	ld	a5,0(s5)
    80000d6e:	02f585b3          	mul	a1,a1,a5
    80000d72:	2585                	addiw	a1,a1,1
    80000d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d78:	4719                	li	a4,6
    80000d7a:	6685                	lui	a3,0x1
    80000d7c:	40b905b3          	sub	a1,s2,a1
    80000d80:	854e                	mv	a0,s3
    80000d82:	00000097          	auipc	ra,0x0
    80000d86:	8b0080e7          	jalr	-1872(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d8a:	17048493          	addi	s1,s1,368
    80000d8e:	fd4495e3          	bne	s1,s4,80000d58 <proc_mapstacks+0x38>
  }
}
    80000d92:	70e2                	ld	ra,56(sp)
    80000d94:	7442                	ld	s0,48(sp)
    80000d96:	74a2                	ld	s1,40(sp)
    80000d98:	7902                	ld	s2,32(sp)
    80000d9a:	69e2                	ld	s3,24(sp)
    80000d9c:	6a42                	ld	s4,16(sp)
    80000d9e:	6aa2                	ld	s5,8(sp)
    80000da0:	6b02                	ld	s6,0(sp)
    80000da2:	6121                	addi	sp,sp,64
    80000da4:	8082                	ret
      panic("kalloc");
    80000da6:	00007517          	auipc	a0,0x7
    80000daa:	3b250513          	addi	a0,a0,946 # 80008158 <etext+0x158>
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	eea080e7          	jalr	-278(ra) # 80005c98 <panic>

0000000080000db6 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000db6:	7139                	addi	sp,sp,-64
    80000db8:	fc06                	sd	ra,56(sp)
    80000dba:	f822                	sd	s0,48(sp)
    80000dbc:	f426                	sd	s1,40(sp)
    80000dbe:	f04a                	sd	s2,32(sp)
    80000dc0:	ec4e                	sd	s3,24(sp)
    80000dc2:	e852                	sd	s4,16(sp)
    80000dc4:	e456                	sd	s5,8(sp)
    80000dc6:	e05a                	sd	s6,0(sp)
    80000dc8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39658593          	addi	a1,a1,918 # 80008160 <etext+0x160>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	27e50513          	addi	a0,a0,638 # 80009050 <pid_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	378080e7          	jalr	888(ra) # 80006152 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	360080e7          	jalr	864(ra) # 80006152 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	00007a17          	auipc	s4,0x7
    80000e10:	1f4a0a13          	addi	s4,s4,500 # 80008000 <etext>
    80000e14:	04000937          	lui	s2,0x4000
    80000e18:	197d                	addi	s2,s2,-1
    80000e1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e1c:	0000e997          	auipc	s3,0xe
    80000e20:	26498993          	addi	s3,s3,612 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000e24:	85da                	mv	a1,s6
    80000e26:	8526                	mv	a0,s1
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	32a080e7          	jalr	810(ra) # 80006152 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	415487b3          	sub	a5,s1,s5
    80000e34:	8791                	srai	a5,a5,0x4
    80000e36:	000a3703          	ld	a4,0(s4)
    80000e3a:	02e787b3          	mul	a5,a5,a4
    80000e3e:	2785                	addiw	a5,a5,1
    80000e40:	00d7979b          	slliw	a5,a5,0xd
    80000e44:	40f907b3          	sub	a5,s2,a5
    80000e48:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4a:	17048493          	addi	s1,s1,368
    80000e4e:	fd349be3          	bne	s1,s3,80000e24 <procinit+0x6e>
  }
}
    80000e52:	70e2                	ld	ra,56(sp)
    80000e54:	7442                	ld	s0,48(sp)
    80000e56:	74a2                	ld	s1,40(sp)
    80000e58:	7902                	ld	s2,32(sp)
    80000e5a:	69e2                	ld	s3,24(sp)
    80000e5c:	6a42                	ld	s4,16(sp)
    80000e5e:	6aa2                	ld	s5,8(sp)
    80000e60:	6b02                	ld	s6,0(sp)
    80000e62:	6121                	addi	sp,sp,64
    80000e64:	8082                	ret

0000000080000e66 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e422                	sd	s0,8(sp)
    80000e6a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e6c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e6e:	2501                	sext.w	a0,a0
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
    80000e7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e7e:	2781                	sext.w	a5,a5
    80000e80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e82:	00008517          	auipc	a0,0x8
    80000e86:	1fe50513          	addi	a0,a0,510 # 80009080 <cpus>
    80000e8a:	953e                	add	a0,a0,a5
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret

0000000080000e92 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	1000                	addi	s0,sp,32
  push_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	2fa080e7          	jalr	762(ra) # 80006196 <push_off>
    80000ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ea6:	2781                	sext.w	a5,a5
    80000ea8:	079e                	slli	a5,a5,0x7
    80000eaa:	00008717          	auipc	a4,0x8
    80000eae:	1a670713          	addi	a4,a4,422 # 80009050 <pid_lock>
    80000eb2:	97ba                	add	a5,a5,a4
    80000eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	380080e7          	jalr	896(ra) # 80006236 <pop_off>
  return p;
}
    80000ebe:	8526                	mv	a0,s1
    80000ec0:	60e2                	ld	ra,24(sp)
    80000ec2:	6442                	ld	s0,16(sp)
    80000ec4:	64a2                	ld	s1,8(sp)
    80000ec6:	6105                	addi	sp,sp,32
    80000ec8:	8082                	ret

0000000080000eca <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eca:	1141                	addi	sp,sp,-16
    80000ecc:	e406                	sd	ra,8(sp)
    80000ece:	e022                	sd	s0,0(sp)
    80000ed0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	fc0080e7          	jalr	-64(ra) # 80000e92 <myproc>
    80000eda:	00005097          	auipc	ra,0x5
    80000ede:	3bc080e7          	jalr	956(ra) # 80006296 <release>

  if (first) {
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	abe7a783          	lw	a5,-1346(a5) # 800089a0 <first.1673>
    80000eea:	eb89                	bnez	a5,80000efc <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eec:	00001097          	auipc	ra,0x1
    80000ef0:	c6c080e7          	jalr	-916(ra) # 80001b58 <usertrapret>
}
    80000ef4:	60a2                	ld	ra,8(sp)
    80000ef6:	6402                	ld	s0,0(sp)
    80000ef8:	0141                	addi	sp,sp,16
    80000efa:	8082                	ret
    first = 0;
    80000efc:	00008797          	auipc	a5,0x8
    80000f00:	aa07a223          	sw	zero,-1372(a5) # 800089a0 <first.1673>
    fsinit(ROOTDEV);
    80000f04:	4505                	li	a0,1
    80000f06:	00002097          	auipc	ra,0x2
    80000f0a:	a6c080e7          	jalr	-1428(ra) # 80002972 <fsinit>
    80000f0e:	bff9                	j	80000eec <forkret+0x22>

0000000080000f10 <allocpid>:
allocpid() {
    80000f10:	1101                	addi	sp,sp,-32
    80000f12:	ec06                	sd	ra,24(sp)
    80000f14:	e822                	sd	s0,16(sp)
    80000f16:	e426                	sd	s1,8(sp)
    80000f18:	e04a                	sd	s2,0(sp)
    80000f1a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f1c:	00008917          	auipc	s2,0x8
    80000f20:	13490913          	addi	s2,s2,308 # 80009050 <pid_lock>
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	2bc080e7          	jalr	700(ra) # 800061e2 <acquire>
  pid = nextpid;
    80000f2e:	00008797          	auipc	a5,0x8
    80000f32:	a7678793          	addi	a5,a5,-1418 # 800089a4 <nextpid>
    80000f36:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f38:	0014871b          	addiw	a4,s1,1
    80000f3c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f3e:	854a                	mv	a0,s2
    80000f40:	00005097          	auipc	ra,0x5
    80000f44:	356080e7          	jalr	854(ra) # 80006296 <release>
}
    80000f48:	8526                	mv	a0,s1
    80000f4a:	60e2                	ld	ra,24(sp)
    80000f4c:	6442                	ld	s0,16(sp)
    80000f4e:	64a2                	ld	s1,8(sp)
    80000f50:	6902                	ld	s2,0(sp)
    80000f52:	6105                	addi	sp,sp,32
    80000f54:	8082                	ret

0000000080000f56 <proc_pagetable>:
{
    80000f56:	1101                	addi	sp,sp,-32
    80000f58:	ec06                	sd	ra,24(sp)
    80000f5a:	e822                	sd	s0,16(sp)
    80000f5c:	e426                	sd	s1,8(sp)
    80000f5e:	e04a                	sd	s2,0(sp)
    80000f60:	1000                	addi	s0,sp,32
    80000f62:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	8b8080e7          	jalr	-1864(ra) # 8000081c <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	c121                	beqz	a0,80000fae <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	60e080e7          	jalr	1550(ra) # 80000592 <mappages>
    80000f8c:	02054863          	bltz	a0,80000fbc <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f90:	4719                	li	a4,6
    80000f92:	05893683          	ld	a3,88(s2)
    80000f96:	6605                	lui	a2,0x1
    80000f98:	020005b7          	lui	a1,0x2000
    80000f9c:	15fd                	addi	a1,a1,-1
    80000f9e:	05b6                	slli	a1,a1,0xd
    80000fa0:	8526                	mv	a0,s1
    80000fa2:	fffff097          	auipc	ra,0xfffff
    80000fa6:	5f0080e7          	jalr	1520(ra) # 80000592 <mappages>
    80000faa:	02054163          	bltz	a0,80000fcc <proc_pagetable+0x76>
}
    80000fae:	8526                	mv	a0,s1
    80000fb0:	60e2                	ld	ra,24(sp)
    80000fb2:	6442                	ld	s0,16(sp)
    80000fb4:	64a2                	ld	s1,8(sp)
    80000fb6:	6902                	ld	s2,0(sp)
    80000fb8:	6105                	addi	sp,sp,32
    80000fba:	8082                	ret
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a58080e7          	jalr	-1448(ra) # 80000a18 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	b7d5                	j	80000fae <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	040005b7          	lui	a1,0x4000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b2                	slli	a1,a1,0xc
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	77e080e7          	jalr	1918(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fe2:	4581                	li	a1,0
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	a32080e7          	jalr	-1486(ra) # 80000a18 <uvmfree>
    return 0;
    80000fee:	4481                	li	s1,0
    80000ff0:	bf7d                	j	80000fae <proc_pagetable+0x58>

0000000080000ff2 <proc_freepagetable>:
{
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	e04a                	sd	s2,0(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
    80001000:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	040005b7          	lui	a1,0x4000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b2                	slli	a1,a1,0xc
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	74a080e7          	jalr	1866(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001016:	4681                	li	a3,0
    80001018:	4605                	li	a2,1
    8000101a:	020005b7          	lui	a1,0x2000
    8000101e:	15fd                	addi	a1,a1,-1
    80001020:	05b6                	slli	a1,a1,0xd
    80001022:	8526                	mv	a0,s1
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	734080e7          	jalr	1844(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8526                	mv	a0,s1
    80001030:	00000097          	auipc	ra,0x0
    80001034:	9e8080e7          	jalr	-1560(ra) # 80000a18 <uvmfree>
}
    80001038:	60e2                	ld	ra,24(sp)
    8000103a:	6442                	ld	s0,16(sp)
    8000103c:	64a2                	ld	s1,8(sp)
    8000103e:	6902                	ld	s2,0(sp)
    80001040:	6105                	addi	sp,sp,32
    80001042:	8082                	ret

0000000080001044 <freeproc>:
{
    80001044:	1101                	addi	sp,sp,-32
    80001046:	ec06                	sd	ra,24(sp)
    80001048:	e822                	sd	s0,16(sp)
    8000104a:	e426                	sd	s1,8(sp)
    8000104c:	1000                	addi	s0,sp,32
    8000104e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001050:	6d28                	ld	a0,88(a0)
    80001052:	c509                	beqz	a0,8000105c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001054:	fffff097          	auipc	ra,0xfffff
    80001058:	fc8080e7          	jalr	-56(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000105c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001060:	68a8                	ld	a0,80(s1)
    80001062:	c511                	beqz	a0,8000106e <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001064:	64ac                	ld	a1,72(s1)
    80001066:	00000097          	auipc	ra,0x0
    8000106a:	f8c080e7          	jalr	-116(ra) # 80000ff2 <proc_freepagetable>
  p->pagetable = 0;
    8000106e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001072:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001076:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000107a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000107e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001082:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001086:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000108a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000108e:	0004ac23          	sw	zero,24(s1)
  p->trace_mask=0;
    80001092:	1604a423          	sw	zero,360(s1)
}
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret

00000000800010a0 <allocproc>:
{
    800010a0:	1101                	addi	sp,sp,-32
    800010a2:	ec06                	sd	ra,24(sp)
    800010a4:	e822                	sd	s0,16(sp)
    800010a6:	e426                	sd	s1,8(sp)
    800010a8:	e04a                	sd	s2,0(sp)
    800010aa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ac:	00008497          	auipc	s1,0x8
    800010b0:	3d448493          	addi	s1,s1,980 # 80009480 <proc>
    800010b4:	0000e917          	auipc	s2,0xe
    800010b8:	fcc90913          	addi	s2,s2,-52 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010bc:	8526                	mv	a0,s1
    800010be:	00005097          	auipc	ra,0x5
    800010c2:	124080e7          	jalr	292(ra) # 800061e2 <acquire>
    if(p->state == UNUSED) {
    800010c6:	4c9c                	lw	a5,24(s1)
    800010c8:	cf81                	beqz	a5,800010e0 <allocproc+0x40>
      release(&p->lock);
    800010ca:	8526                	mv	a0,s1
    800010cc:	00005097          	auipc	ra,0x5
    800010d0:	1ca080e7          	jalr	458(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010d4:	17048493          	addi	s1,s1,368
    800010d8:	ff2492e3          	bne	s1,s2,800010bc <allocproc+0x1c>
  return 0;
    800010dc:	4481                	li	s1,0
    800010de:	a889                	j	80001130 <allocproc+0x90>
  p->pid = allocpid();
    800010e0:	00000097          	auipc	ra,0x0
    800010e4:	e30080e7          	jalr	-464(ra) # 80000f10 <allocpid>
    800010e8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ea:	4785                	li	a5,1
    800010ec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	02a080e7          	jalr	42(ra) # 80000118 <kalloc>
    800010f6:	892a                	mv	s2,a0
    800010f8:	eca8                	sd	a0,88(s1)
    800010fa:	c131                	beqz	a0,8000113e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010fc:	8526                	mv	a0,s1
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	e58080e7          	jalr	-424(ra) # 80000f56 <proc_pagetable>
    80001106:	892a                	mv	s2,a0
    80001108:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000110a:	c531                	beqz	a0,80001156 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000110c:	07000613          	li	a2,112
    80001110:	4581                	li	a1,0
    80001112:	06048513          	addi	a0,s1,96
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	0ac080e7          	jalr	172(ra) # 800001c2 <memset>
  p->context.ra = (uint64)forkret;
    8000111e:	00000797          	auipc	a5,0x0
    80001122:	dac78793          	addi	a5,a5,-596 # 80000eca <forkret>
    80001126:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001128:	60bc                	ld	a5,64(s1)
    8000112a:	6705                	lui	a4,0x1
    8000112c:	97ba                	add	a5,a5,a4
    8000112e:	f4bc                	sd	a5,104(s1)
}
    80001130:	8526                	mv	a0,s1
    80001132:	60e2                	ld	ra,24(sp)
    80001134:	6442                	ld	s0,16(sp)
    80001136:	64a2                	ld	s1,8(sp)
    80001138:	6902                	ld	s2,0(sp)
    8000113a:	6105                	addi	sp,sp,32
    8000113c:	8082                	ret
    freeproc(p);
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	f04080e7          	jalr	-252(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001148:	8526                	mv	a0,s1
    8000114a:	00005097          	auipc	ra,0x5
    8000114e:	14c080e7          	jalr	332(ra) # 80006296 <release>
    return 0;
    80001152:	84ca                	mv	s1,s2
    80001154:	bff1                	j	80001130 <allocproc+0x90>
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	eec080e7          	jalr	-276(ra) # 80001044 <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	134080e7          	jalr	308(ra) # 80006296 <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	b7d1                	j	80001130 <allocproc+0x90>

000000008000116e <userinit>:
{
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	1000                	addi	s0,sp,32
  p = allocproc();
    80001178:	00000097          	auipc	ra,0x0
    8000117c:	f28080e7          	jalr	-216(ra) # 800010a0 <allocproc>
    80001180:	84aa                	mv	s1,a0
  initproc = p;
    80001182:	00008797          	auipc	a5,0x8
    80001186:	e8a7b723          	sd	a0,-370(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000118a:	03400613          	li	a2,52
    8000118e:	00008597          	auipc	a1,0x8
    80001192:	82258593          	addi	a1,a1,-2014 # 800089b0 <initcode>
    80001196:	6928                	ld	a0,80(a0)
    80001198:	fffff097          	auipc	ra,0xfffff
    8000119c:	6b2080e7          	jalr	1714(ra) # 8000084a <uvminit>
  p->sz = PGSIZE;
    800011a0:	6785                	lui	a5,0x1
    800011a2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011a4:	6cb8                	ld	a4,88(s1)
    800011a6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011aa:	6cb8                	ld	a4,88(s1)
    800011ac:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011ae:	4641                	li	a2,16
    800011b0:	00007597          	auipc	a1,0x7
    800011b4:	fd058593          	addi	a1,a1,-48 # 80008180 <etext+0x180>
    800011b8:	15848513          	addi	a0,s1,344
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	158080e7          	jalr	344(ra) # 80000314 <safestrcpy>
  p->cwd = namei("/");
    800011c4:	00007517          	auipc	a0,0x7
    800011c8:	fcc50513          	addi	a0,a0,-52 # 80008190 <etext+0x190>
    800011cc:	00002097          	auipc	ra,0x2
    800011d0:	1d4080e7          	jalr	468(ra) # 800033a0 <namei>
    800011d4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011d8:	478d                	li	a5,3
    800011da:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011dc:	8526                	mv	a0,s1
    800011de:	00005097          	auipc	ra,0x5
    800011e2:	0b8080e7          	jalr	184(ra) # 80006296 <release>
}
    800011e6:	60e2                	ld	ra,24(sp)
    800011e8:	6442                	ld	s0,16(sp)
    800011ea:	64a2                	ld	s1,8(sp)
    800011ec:	6105                	addi	sp,sp,32
    800011ee:	8082                	ret

00000000800011f0 <growproc>:
{
    800011f0:	1101                	addi	sp,sp,-32
    800011f2:	ec06                	sd	ra,24(sp)
    800011f4:	e822                	sd	s0,16(sp)
    800011f6:	e426                	sd	s1,8(sp)
    800011f8:	e04a                	sd	s2,0(sp)
    800011fa:	1000                	addi	s0,sp,32
    800011fc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011fe:	00000097          	auipc	ra,0x0
    80001202:	c94080e7          	jalr	-876(ra) # 80000e92 <myproc>
    80001206:	892a                	mv	s2,a0
  sz = p->sz;
    80001208:	652c                	ld	a1,72(a0)
    8000120a:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000120e:	00904f63          	bgtz	s1,8000122c <growproc+0x3c>
  } else if(n < 0){
    80001212:	0204cc63          	bltz	s1,8000124a <growproc+0x5a>
  p->sz = sz;
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	04c93423          	sd	a2,72(s2)
  return 0;
    8000121e:	4501                	li	a0,0
}
    80001220:	60e2                	ld	ra,24(sp)
    80001222:	6442                	ld	s0,16(sp)
    80001224:	64a2                	ld	s1,8(sp)
    80001226:	6902                	ld	s2,0(sp)
    80001228:	6105                	addi	sp,sp,32
    8000122a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000122c:	9e25                	addw	a2,a2,s1
    8000122e:	1602                	slli	a2,a2,0x20
    80001230:	9201                	srli	a2,a2,0x20
    80001232:	1582                	slli	a1,a1,0x20
    80001234:	9181                	srli	a1,a1,0x20
    80001236:	6928                	ld	a0,80(a0)
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	6cc080e7          	jalr	1740(ra) # 80000904 <uvmalloc>
    80001240:	0005061b          	sext.w	a2,a0
    80001244:	fa69                	bnez	a2,80001216 <growproc+0x26>
      return -1;
    80001246:	557d                	li	a0,-1
    80001248:	bfe1                	j	80001220 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000124a:	9e25                	addw	a2,a2,s1
    8000124c:	1602                	slli	a2,a2,0x20
    8000124e:	9201                	srli	a2,a2,0x20
    80001250:	1582                	slli	a1,a1,0x20
    80001252:	9181                	srli	a1,a1,0x20
    80001254:	6928                	ld	a0,80(a0)
    80001256:	fffff097          	auipc	ra,0xfffff
    8000125a:	666080e7          	jalr	1638(ra) # 800008bc <uvmdealloc>
    8000125e:	0005061b          	sext.w	a2,a0
    80001262:	bf55                	j	80001216 <growproc+0x26>

0000000080001264 <fork>:
{
    80001264:	7179                	addi	sp,sp,-48
    80001266:	f406                	sd	ra,40(sp)
    80001268:	f022                	sd	s0,32(sp)
    8000126a:	ec26                	sd	s1,24(sp)
    8000126c:	e84a                	sd	s2,16(sp)
    8000126e:	e44e                	sd	s3,8(sp)
    80001270:	e052                	sd	s4,0(sp)
    80001272:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001274:	00000097          	auipc	ra,0x0
    80001278:	c1e080e7          	jalr	-994(ra) # 80000e92 <myproc>
    8000127c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	e22080e7          	jalr	-478(ra) # 800010a0 <allocproc>
    80001286:	10050f63          	beqz	a0,800013a4 <fork+0x140>
    8000128a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128c:	04893603          	ld	a2,72(s2)
    80001290:	692c                	ld	a1,80(a0)
    80001292:	05093503          	ld	a0,80(s2)
    80001296:	fffff097          	auipc	ra,0xfffff
    8000129a:	7ba080e7          	jalr	1978(ra) # 80000a50 <uvmcopy>
    8000129e:	04054a63          	bltz	a0,800012f2 <fork+0x8e>
  np->sz = p->sz;
    800012a2:	04893783          	ld	a5,72(s2)
    800012a6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012aa:	05893683          	ld	a3,88(s2)
    800012ae:	87b6                	mv	a5,a3
    800012b0:	0589b703          	ld	a4,88(s3)
    800012b4:	12068693          	addi	a3,a3,288
    800012b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012bc:	6788                	ld	a0,8(a5)
    800012be:	6b8c                	ld	a1,16(a5)
    800012c0:	6f90                	ld	a2,24(a5)
    800012c2:	01073023          	sd	a6,0(a4)
    800012c6:	e708                	sd	a0,8(a4)
    800012c8:	eb0c                	sd	a1,16(a4)
    800012ca:	ef10                	sd	a2,24(a4)
    800012cc:	02078793          	addi	a5,a5,32
    800012d0:	02070713          	addi	a4,a4,32
    800012d4:	fed792e3          	bne	a5,a3,800012b8 <fork+0x54>
  np->trapframe->a0 = 0;
    800012d8:	0589b783          	ld	a5,88(s3)
    800012dc:	0607b823          	sd	zero,112(a5)
  np->trace_mask=p->trace_mask;
    800012e0:	16892783          	lw	a5,360(s2)
    800012e4:	16f9a423          	sw	a5,360(s3)
    800012e8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012ec:	15000a13          	li	s4,336
    800012f0:	a03d                	j	8000131e <fork+0xba>
    freeproc(np);
    800012f2:	854e                	mv	a0,s3
    800012f4:	00000097          	auipc	ra,0x0
    800012f8:	d50080e7          	jalr	-688(ra) # 80001044 <freeproc>
    release(&np->lock);
    800012fc:	854e                	mv	a0,s3
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	f98080e7          	jalr	-104(ra) # 80006296 <release>
    return -1;
    80001306:	5a7d                	li	s4,-1
    80001308:	a069                	j	80001392 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    8000130a:	00002097          	auipc	ra,0x2
    8000130e:	72c080e7          	jalr	1836(ra) # 80003a36 <filedup>
    80001312:	009987b3          	add	a5,s3,s1
    80001316:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001318:	04a1                	addi	s1,s1,8
    8000131a:	01448763          	beq	s1,s4,80001328 <fork+0xc4>
    if(p->ofile[i])
    8000131e:	009907b3          	add	a5,s2,s1
    80001322:	6388                	ld	a0,0(a5)
    80001324:	f17d                	bnez	a0,8000130a <fork+0xa6>
    80001326:	bfcd                	j	80001318 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001328:	15093503          	ld	a0,336(s2)
    8000132c:	00002097          	auipc	ra,0x2
    80001330:	880080e7          	jalr	-1920(ra) # 80002bac <idup>
    80001334:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001338:	4641                	li	a2,16
    8000133a:	15890593          	addi	a1,s2,344
    8000133e:	15898513          	addi	a0,s3,344
    80001342:	fffff097          	auipc	ra,0xfffff
    80001346:	fd2080e7          	jalr	-46(ra) # 80000314 <safestrcpy>
  pid = np->pid;
    8000134a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000134e:	854e                	mv	a0,s3
    80001350:	00005097          	auipc	ra,0x5
    80001354:	f46080e7          	jalr	-186(ra) # 80006296 <release>
  acquire(&wait_lock);
    80001358:	00008497          	auipc	s1,0x8
    8000135c:	d1048493          	addi	s1,s1,-752 # 80009068 <wait_lock>
    80001360:	8526                	mv	a0,s1
    80001362:	00005097          	auipc	ra,0x5
    80001366:	e80080e7          	jalr	-384(ra) # 800061e2 <acquire>
  np->parent = p;
    8000136a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	00005097          	auipc	ra,0x5
    80001374:	f26080e7          	jalr	-218(ra) # 80006296 <release>
  acquire(&np->lock);
    80001378:	854e                	mv	a0,s3
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	e68080e7          	jalr	-408(ra) # 800061e2 <acquire>
  np->state = RUNNABLE;
    80001382:	478d                	li	a5,3
    80001384:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001388:	854e                	mv	a0,s3
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	f0c080e7          	jalr	-244(ra) # 80006296 <release>
}
    80001392:	8552                	mv	a0,s4
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6a02                	ld	s4,0(sp)
    800013a0:	6145                	addi	sp,sp,48
    800013a2:	8082                	ret
    return -1;
    800013a4:	5a7d                	li	s4,-1
    800013a6:	b7f5                	j	80001392 <fork+0x12e>

00000000800013a8 <scheduler>:
{
    800013a8:	7139                	addi	sp,sp,-64
    800013aa:	fc06                	sd	ra,56(sp)
    800013ac:	f822                	sd	s0,48(sp)
    800013ae:	f426                	sd	s1,40(sp)
    800013b0:	f04a                	sd	s2,32(sp)
    800013b2:	ec4e                	sd	s3,24(sp)
    800013b4:	e852                	sd	s4,16(sp)
    800013b6:	e456                	sd	s5,8(sp)
    800013b8:	e05a                	sd	s6,0(sp)
    800013ba:	0080                	addi	s0,sp,64
    800013bc:	8792                	mv	a5,tp
  int id = r_tp();
    800013be:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013c0:	00779a93          	slli	s5,a5,0x7
    800013c4:	00008717          	auipc	a4,0x8
    800013c8:	c8c70713          	addi	a4,a4,-884 # 80009050 <pid_lock>
    800013cc:	9756                	add	a4,a4,s5
    800013ce:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013d2:	00008717          	auipc	a4,0x8
    800013d6:	cb670713          	addi	a4,a4,-842 # 80009088 <cpus+0x8>
    800013da:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013dc:	498d                	li	s3,3
        p->state = RUNNING;
    800013de:	4b11                	li	s6,4
        c->proc = p;
    800013e0:	079e                	slli	a5,a5,0x7
    800013e2:	00008a17          	auipc	s4,0x8
    800013e6:	c6ea0a13          	addi	s4,s4,-914 # 80009050 <pid_lock>
    800013ea:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ec:	0000e917          	auipc	s2,0xe
    800013f0:	c9490913          	addi	s2,s2,-876 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013fc:	10079073          	csrw	sstatus,a5
    80001400:	00008497          	auipc	s1,0x8
    80001404:	08048493          	addi	s1,s1,128 # 80009480 <proc>
    80001408:	a03d                	j	80001436 <scheduler+0x8e>
        p->state = RUNNING;
    8000140a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000140e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001412:	06048593          	addi	a1,s1,96
    80001416:	8556                	mv	a0,s5
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	696080e7          	jalr	1686(ra) # 80001aae <swtch>
        c->proc = 0;
    80001420:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001424:	8526                	mv	a0,s1
    80001426:	00005097          	auipc	ra,0x5
    8000142a:	e70080e7          	jalr	-400(ra) # 80006296 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142e:	17048493          	addi	s1,s1,368
    80001432:	fd2481e3          	beq	s1,s2,800013f4 <scheduler+0x4c>
      acquire(&p->lock);
    80001436:	8526                	mv	a0,s1
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	daa080e7          	jalr	-598(ra) # 800061e2 <acquire>
      if(p->state == RUNNABLE) {
    80001440:	4c9c                	lw	a5,24(s1)
    80001442:	ff3791e3          	bne	a5,s3,80001424 <scheduler+0x7c>
    80001446:	b7d1                	j	8000140a <scheduler+0x62>

0000000080001448 <sched>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	a3c080e7          	jalr	-1476(ra) # 80000e92 <myproc>
    8000145e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001460:	00005097          	auipc	ra,0x5
    80001464:	d08080e7          	jalr	-760(ra) # 80006168 <holding>
    80001468:	c93d                	beqz	a0,800014de <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	00008717          	auipc	a4,0x8
    80001474:	be070713          	addi	a4,a4,-1056 # 80009050 <pid_lock>
    80001478:	97ba                	add	a5,a5,a4
    8000147a:	0a87a703          	lw	a4,168(a5)
    8000147e:	4785                	li	a5,1
    80001480:	06f71763          	bne	a4,a5,800014ee <sched+0xa6>
  if(p->state == RUNNING)
    80001484:	4c98                	lw	a4,24(s1)
    80001486:	4791                	li	a5,4
    80001488:	06f70b63          	beq	a4,a5,800014fe <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000148c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001490:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001492:	efb5                	bnez	a5,8000150e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001494:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001496:	00008917          	auipc	s2,0x8
    8000149a:	bba90913          	addi	s2,s2,-1094 # 80009050 <pid_lock>
    8000149e:	2781                	sext.w	a5,a5
    800014a0:	079e                	slli	a5,a5,0x7
    800014a2:	97ca                	add	a5,a5,s2
    800014a4:	0ac7a983          	lw	s3,172(a5)
    800014a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	00008597          	auipc	a1,0x8
    800014b2:	bda58593          	addi	a1,a1,-1062 # 80009088 <cpus+0x8>
    800014b6:	95be                	add	a1,a1,a5
    800014b8:	06048513          	addi	a0,s1,96
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	5f2080e7          	jalr	1522(ra) # 80001aae <swtch>
    800014c4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014c6:	2781                	sext.w	a5,a5
    800014c8:	079e                	slli	a5,a5,0x7
    800014ca:	97ca                	add	a5,a5,s2
    800014cc:	0b37a623          	sw	s3,172(a5)
}
    800014d0:	70a2                	ld	ra,40(sp)
    800014d2:	7402                	ld	s0,32(sp)
    800014d4:	64e2                	ld	s1,24(sp)
    800014d6:	6942                	ld	s2,16(sp)
    800014d8:	69a2                	ld	s3,8(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    panic("sched p->lock");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cba50513          	addi	a0,a0,-838 # 80008198 <etext+0x198>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	7b2080e7          	jalr	1970(ra) # 80005c98 <panic>
    panic("sched locks");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cba50513          	addi	a0,a0,-838 # 800081a8 <etext+0x1a8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	7a2080e7          	jalr	1954(ra) # 80005c98 <panic>
    panic("sched running");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	cba50513          	addi	a0,a0,-838 # 800081b8 <etext+0x1b8>
    80001506:	00004097          	auipc	ra,0x4
    8000150a:	792080e7          	jalr	1938(ra) # 80005c98 <panic>
    panic("sched interruptible");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	cba50513          	addi	a0,a0,-838 # 800081c8 <etext+0x1c8>
    80001516:	00004097          	auipc	ra,0x4
    8000151a:	782080e7          	jalr	1922(ra) # 80005c98 <panic>

000000008000151e <yield>:
{
    8000151e:	1101                	addi	sp,sp,-32
    80001520:	ec06                	sd	ra,24(sp)
    80001522:	e822                	sd	s0,16(sp)
    80001524:	e426                	sd	s1,8(sp)
    80001526:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001528:	00000097          	auipc	ra,0x0
    8000152c:	96a080e7          	jalr	-1686(ra) # 80000e92 <myproc>
    80001530:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001532:	00005097          	auipc	ra,0x5
    80001536:	cb0080e7          	jalr	-848(ra) # 800061e2 <acquire>
  p->state = RUNNABLE;
    8000153a:	478d                	li	a5,3
    8000153c:	cc9c                	sw	a5,24(s1)
  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	f0a080e7          	jalr	-246(ra) # 80001448 <sched>
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	d4e080e7          	jalr	-690(ra) # 80006296 <release>
}
    80001550:	60e2                	ld	ra,24(sp)
    80001552:	6442                	ld	s0,16(sp)
    80001554:	64a2                	ld	s1,8(sp)
    80001556:	6105                	addi	sp,sp,32
    80001558:	8082                	ret

000000008000155a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000155a:	7179                	addi	sp,sp,-48
    8000155c:	f406                	sd	ra,40(sp)
    8000155e:	f022                	sd	s0,32(sp)
    80001560:	ec26                	sd	s1,24(sp)
    80001562:	e84a                	sd	s2,16(sp)
    80001564:	e44e                	sd	s3,8(sp)
    80001566:	1800                	addi	s0,sp,48
    80001568:	89aa                	mv	s3,a0
    8000156a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	926080e7          	jalr	-1754(ra) # 80000e92 <myproc>
    80001574:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	c6c080e7          	jalr	-916(ra) # 800061e2 <acquire>
  release(lk);
    8000157e:	854a                	mv	a0,s2
    80001580:	00005097          	auipc	ra,0x5
    80001584:	d16080e7          	jalr	-746(ra) # 80006296 <release>

  // Go to sleep.
  p->chan = chan;
    80001588:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000158c:	4789                	li	a5,2
    8000158e:	cc9c                	sw	a5,24(s1)

  sched();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	eb8080e7          	jalr	-328(ra) # 80001448 <sched>

  // Tidy up.
  p->chan = 0;
    80001598:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	00005097          	auipc	ra,0x5
    800015a2:	cf8080e7          	jalr	-776(ra) # 80006296 <release>
  acquire(lk);
    800015a6:	854a                	mv	a0,s2
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	c3a080e7          	jalr	-966(ra) # 800061e2 <acquire>
}
    800015b0:	70a2                	ld	ra,40(sp)
    800015b2:	7402                	ld	s0,32(sp)
    800015b4:	64e2                	ld	s1,24(sp)
    800015b6:	6942                	ld	s2,16(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	6145                	addi	sp,sp,48
    800015bc:	8082                	ret

00000000800015be <wait>:
{
    800015be:	715d                	addi	sp,sp,-80
    800015c0:	e486                	sd	ra,72(sp)
    800015c2:	e0a2                	sd	s0,64(sp)
    800015c4:	fc26                	sd	s1,56(sp)
    800015c6:	f84a                	sd	s2,48(sp)
    800015c8:	f44e                	sd	s3,40(sp)
    800015ca:	f052                	sd	s4,32(sp)
    800015cc:	ec56                	sd	s5,24(sp)
    800015ce:	e85a                	sd	s6,16(sp)
    800015d0:	e45e                	sd	s7,8(sp)
    800015d2:	e062                	sd	s8,0(sp)
    800015d4:	0880                	addi	s0,sp,80
    800015d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	8ba080e7          	jalr	-1862(ra) # 80000e92 <myproc>
    800015e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015e2:	00008517          	auipc	a0,0x8
    800015e6:	a8650513          	addi	a0,a0,-1402 # 80009068 <wait_lock>
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	bf8080e7          	jalr	-1032(ra) # 800061e2 <acquire>
    havekids = 0;
    800015f2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015f4:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015f6:	0000e997          	auipc	s3,0xe
    800015fa:	a8a98993          	addi	s3,s3,-1398 # 8000f080 <tickslock>
        havekids = 1;
    800015fe:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001600:	00008c17          	auipc	s8,0x8
    80001604:	a68c0c13          	addi	s8,s8,-1432 # 80009068 <wait_lock>
    havekids = 0;
    80001608:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000160a:	00008497          	auipc	s1,0x8
    8000160e:	e7648493          	addi	s1,s1,-394 # 80009480 <proc>
    80001612:	a0bd                	j	80001680 <wait+0xc2>
          pid = np->pid;
    80001614:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001618:	000b0e63          	beqz	s6,80001634 <wait+0x76>
    8000161c:	4691                	li	a3,4
    8000161e:	02c48613          	addi	a2,s1,44
    80001622:	85da                	mv	a1,s6
    80001624:	05093503          	ld	a0,80(s2)
    80001628:	fffff097          	auipc	ra,0xfffff
    8000162c:	52c080e7          	jalr	1324(ra) # 80000b54 <copyout>
    80001630:	02054563          	bltz	a0,8000165a <wait+0x9c>
          freeproc(np);
    80001634:	8526                	mv	a0,s1
    80001636:	00000097          	auipc	ra,0x0
    8000163a:	a0e080e7          	jalr	-1522(ra) # 80001044 <freeproc>
          release(&np->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	00005097          	auipc	ra,0x5
    80001644:	c56080e7          	jalr	-938(ra) # 80006296 <release>
          release(&wait_lock);
    80001648:	00008517          	auipc	a0,0x8
    8000164c:	a2050513          	addi	a0,a0,-1504 # 80009068 <wait_lock>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	c46080e7          	jalr	-954(ra) # 80006296 <release>
          return pid;
    80001658:	a09d                	j	800016be <wait+0x100>
            release(&np->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	c3a080e7          	jalr	-966(ra) # 80006296 <release>
            release(&wait_lock);
    80001664:	00008517          	auipc	a0,0x8
    80001668:	a0450513          	addi	a0,a0,-1532 # 80009068 <wait_lock>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	c2a080e7          	jalr	-982(ra) # 80006296 <release>
            return -1;
    80001674:	59fd                	li	s3,-1
    80001676:	a0a1                	j	800016be <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001678:	17048493          	addi	s1,s1,368
    8000167c:	03348463          	beq	s1,s3,800016a4 <wait+0xe6>
      if(np->parent == p){
    80001680:	7c9c                	ld	a5,56(s1)
    80001682:	ff279be3          	bne	a5,s2,80001678 <wait+0xba>
        acquire(&np->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	00005097          	auipc	ra,0x5
    8000168c:	b5a080e7          	jalr	-1190(ra) # 800061e2 <acquire>
        if(np->state == ZOMBIE){
    80001690:	4c9c                	lw	a5,24(s1)
    80001692:	f94781e3          	beq	a5,s4,80001614 <wait+0x56>
        release(&np->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	bfe080e7          	jalr	-1026(ra) # 80006296 <release>
        havekids = 1;
    800016a0:	8756                	mv	a4,s5
    800016a2:	bfd9                	j	80001678 <wait+0xba>
    if(!havekids || p->killed){
    800016a4:	c701                	beqz	a4,800016ac <wait+0xee>
    800016a6:	02892783          	lw	a5,40(s2)
    800016aa:	c79d                	beqz	a5,800016d8 <wait+0x11a>
      release(&wait_lock);
    800016ac:	00008517          	auipc	a0,0x8
    800016b0:	9bc50513          	addi	a0,a0,-1604 # 80009068 <wait_lock>
    800016b4:	00005097          	auipc	ra,0x5
    800016b8:	be2080e7          	jalr	-1054(ra) # 80006296 <release>
      return -1;
    800016bc:	59fd                	li	s3,-1
}
    800016be:	854e                	mv	a0,s3
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6c02                	ld	s8,0(sp)
    800016d4:	6161                	addi	sp,sp,80
    800016d6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d8:	85e2                	mv	a1,s8
    800016da:	854a                	mv	a0,s2
    800016dc:	00000097          	auipc	ra,0x0
    800016e0:	e7e080e7          	jalr	-386(ra) # 8000155a <sleep>
    havekids = 0;
    800016e4:	b715                	j	80001608 <wait+0x4a>

00000000800016e6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016e6:	7139                	addi	sp,sp,-64
    800016e8:	fc06                	sd	ra,56(sp)
    800016ea:	f822                	sd	s0,48(sp)
    800016ec:	f426                	sd	s1,40(sp)
    800016ee:	f04a                	sd	s2,32(sp)
    800016f0:	ec4e                	sd	s3,24(sp)
    800016f2:	e852                	sd	s4,16(sp)
    800016f4:	e456                	sd	s5,8(sp)
    800016f6:	0080                	addi	s0,sp,64
    800016f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016fa:	00008497          	auipc	s1,0x8
    800016fe:	d8648493          	addi	s1,s1,-634 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001702:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001704:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001706:	0000e917          	auipc	s2,0xe
    8000170a:	97a90913          	addi	s2,s2,-1670 # 8000f080 <tickslock>
    8000170e:	a821                	j	80001726 <wakeup+0x40>
        p->state = RUNNABLE;
    80001710:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001714:	8526                	mv	a0,s1
    80001716:	00005097          	auipc	ra,0x5
    8000171a:	b80080e7          	jalr	-1152(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171e:	17048493          	addi	s1,s1,368
    80001722:	03248463          	beq	s1,s2,8000174a <wakeup+0x64>
    if(p != myproc()){
    80001726:	fffff097          	auipc	ra,0xfffff
    8000172a:	76c080e7          	jalr	1900(ra) # 80000e92 <myproc>
    8000172e:	fea488e3          	beq	s1,a0,8000171e <wakeup+0x38>
      acquire(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	aae080e7          	jalr	-1362(ra) # 800061e2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000173c:	4c9c                	lw	a5,24(s1)
    8000173e:	fd379be3          	bne	a5,s3,80001714 <wakeup+0x2e>
    80001742:	709c                	ld	a5,32(s1)
    80001744:	fd4798e3          	bne	a5,s4,80001714 <wakeup+0x2e>
    80001748:	b7e1                	j	80001710 <wakeup+0x2a>
    }
  }
}
    8000174a:	70e2                	ld	ra,56(sp)
    8000174c:	7442                	ld	s0,48(sp)
    8000174e:	74a2                	ld	s1,40(sp)
    80001750:	7902                	ld	s2,32(sp)
    80001752:	69e2                	ld	s3,24(sp)
    80001754:	6a42                	ld	s4,16(sp)
    80001756:	6aa2                	ld	s5,8(sp)
    80001758:	6121                	addi	sp,sp,64
    8000175a:	8082                	ret

000000008000175c <reparent>:
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	e052                	sd	s4,0(sp)
    8000176a:	1800                	addi	s0,sp,48
    8000176c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176e:	00008497          	auipc	s1,0x8
    80001772:	d1248493          	addi	s1,s1,-750 # 80009480 <proc>
      pp->parent = initproc;
    80001776:	00008a17          	auipc	s4,0x8
    8000177a:	89aa0a13          	addi	s4,s4,-1894 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177e:	0000e997          	auipc	s3,0xe
    80001782:	90298993          	addi	s3,s3,-1790 # 8000f080 <tickslock>
    80001786:	a029                	j	80001790 <reparent+0x34>
    80001788:	17048493          	addi	s1,s1,368
    8000178c:	01348d63          	beq	s1,s3,800017a6 <reparent+0x4a>
    if(pp->parent == p){
    80001790:	7c9c                	ld	a5,56(s1)
    80001792:	ff279be3          	bne	a5,s2,80001788 <reparent+0x2c>
      pp->parent = initproc;
    80001796:	000a3503          	ld	a0,0(s4)
    8000179a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000179c:	00000097          	auipc	ra,0x0
    800017a0:	f4a080e7          	jalr	-182(ra) # 800016e6 <wakeup>
    800017a4:	b7d5                	j	80001788 <reparent+0x2c>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6a02                	ld	s4,0(sp)
    800017b2:	6145                	addi	sp,sp,48
    800017b4:	8082                	ret

00000000800017b6 <exit>:
{
    800017b6:	7179                	addi	sp,sp,-48
    800017b8:	f406                	sd	ra,40(sp)
    800017ba:	f022                	sd	s0,32(sp)
    800017bc:	ec26                	sd	s1,24(sp)
    800017be:	e84a                	sd	s2,16(sp)
    800017c0:	e44e                	sd	s3,8(sp)
    800017c2:	e052                	sd	s4,0(sp)
    800017c4:	1800                	addi	s0,sp,48
    800017c6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017c8:	fffff097          	auipc	ra,0xfffff
    800017cc:	6ca080e7          	jalr	1738(ra) # 80000e92 <myproc>
    800017d0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017d2:	00008797          	auipc	a5,0x8
    800017d6:	83e7b783          	ld	a5,-1986(a5) # 80009010 <initproc>
    800017da:	0d050493          	addi	s1,a0,208
    800017de:	15050913          	addi	s2,a0,336
    800017e2:	02a79363          	bne	a5,a0,80001808 <exit+0x52>
    panic("init exiting");
    800017e6:	00007517          	auipc	a0,0x7
    800017ea:	9fa50513          	addi	a0,a0,-1542 # 800081e0 <etext+0x1e0>
    800017ee:	00004097          	auipc	ra,0x4
    800017f2:	4aa080e7          	jalr	1194(ra) # 80005c98 <panic>
      fileclose(f);
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	292080e7          	jalr	658(ra) # 80003a88 <fileclose>
      p->ofile[fd] = 0;
    800017fe:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001802:	04a1                	addi	s1,s1,8
    80001804:	01248563          	beq	s1,s2,8000180e <exit+0x58>
    if(p->ofile[fd]){
    80001808:	6088                	ld	a0,0(s1)
    8000180a:	f575                	bnez	a0,800017f6 <exit+0x40>
    8000180c:	bfdd                	j	80001802 <exit+0x4c>
  begin_op();
    8000180e:	00002097          	auipc	ra,0x2
    80001812:	dae080e7          	jalr	-594(ra) # 800035bc <begin_op>
  iput(p->cwd);
    80001816:	1509b503          	ld	a0,336(s3)
    8000181a:	00001097          	auipc	ra,0x1
    8000181e:	58a080e7          	jalr	1418(ra) # 80002da4 <iput>
  end_op();
    80001822:	00002097          	auipc	ra,0x2
    80001826:	e1a080e7          	jalr	-486(ra) # 8000363c <end_op>
  p->cwd = 0;
    8000182a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000182e:	00008497          	auipc	s1,0x8
    80001832:	83a48493          	addi	s1,s1,-1990 # 80009068 <wait_lock>
    80001836:	8526                	mv	a0,s1
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	9aa080e7          	jalr	-1622(ra) # 800061e2 <acquire>
  reparent(p);
    80001840:	854e                	mv	a0,s3
    80001842:	00000097          	auipc	ra,0x0
    80001846:	f1a080e7          	jalr	-230(ra) # 8000175c <reparent>
  wakeup(p->parent);
    8000184a:	0389b503          	ld	a0,56(s3)
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	e98080e7          	jalr	-360(ra) # 800016e6 <wakeup>
  acquire(&p->lock);
    80001856:	854e                	mv	a0,s3
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	98a080e7          	jalr	-1654(ra) # 800061e2 <acquire>
  p->xstate = status;
    80001860:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001864:	4795                	li	a5,5
    80001866:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000186a:	8526                	mv	a0,s1
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	a2a080e7          	jalr	-1494(ra) # 80006296 <release>
  sched();
    80001874:	00000097          	auipc	ra,0x0
    80001878:	bd4080e7          	jalr	-1068(ra) # 80001448 <sched>
  panic("zombie exit");
    8000187c:	00007517          	auipc	a0,0x7
    80001880:	97450513          	addi	a0,a0,-1676 # 800081f0 <etext+0x1f0>
    80001884:	00004097          	auipc	ra,0x4
    80001888:	414080e7          	jalr	1044(ra) # 80005c98 <panic>

000000008000188c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000188c:	7179                	addi	sp,sp,-48
    8000188e:	f406                	sd	ra,40(sp)
    80001890:	f022                	sd	s0,32(sp)
    80001892:	ec26                	sd	s1,24(sp)
    80001894:	e84a                	sd	s2,16(sp)
    80001896:	e44e                	sd	s3,8(sp)
    80001898:	1800                	addi	s0,sp,48
    8000189a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000189c:	00008497          	auipc	s1,0x8
    800018a0:	be448493          	addi	s1,s1,-1052 # 80009480 <proc>
    800018a4:	0000d997          	auipc	s3,0xd
    800018a8:	7dc98993          	addi	s3,s3,2012 # 8000f080 <tickslock>
    acquire(&p->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	934080e7          	jalr	-1740(ra) # 800061e2 <acquire>
    if(p->pid == pid){
    800018b6:	589c                	lw	a5,48(s1)
    800018b8:	01278d63          	beq	a5,s2,800018d2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018bc:	8526                	mv	a0,s1
    800018be:	00005097          	auipc	ra,0x5
    800018c2:	9d8080e7          	jalr	-1576(ra) # 80006296 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018c6:	17048493          	addi	s1,s1,368
    800018ca:	ff3491e3          	bne	s1,s3,800018ac <kill+0x20>
  }
  return -1;
    800018ce:	557d                	li	a0,-1
    800018d0:	a829                	j	800018ea <kill+0x5e>
      p->killed = 1;
    800018d2:	4785                	li	a5,1
    800018d4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018d6:	4c98                	lw	a4,24(s1)
    800018d8:	4789                	li	a5,2
    800018da:	00f70f63          	beq	a4,a5,800018f8 <kill+0x6c>
      release(&p->lock);
    800018de:	8526                	mv	a0,s1
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	9b6080e7          	jalr	-1610(ra) # 80006296 <release>
      return 0;
    800018e8:	4501                	li	a0,0
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6145                	addi	sp,sp,48
    800018f6:	8082                	ret
        p->state = RUNNABLE;
    800018f8:	478d                	li	a5,3
    800018fa:	cc9c                	sw	a5,24(s1)
    800018fc:	b7cd                	j	800018de <kill+0x52>

00000000800018fe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	84aa                	mv	s1,a0
    80001910:	892e                	mv	s2,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	57c080e7          	jalr	1404(ra) # 80000e92 <myproc>
  if(user_dst){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	22c080e7          	jalr	556(ra) # 80000b54 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove((char *)dst, src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	8da080e7          	jalr	-1830(ra) # 80000222 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyout+0x32>

0000000080001954 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001954:	7179                	addi	sp,sp,-48
    80001956:	f406                	sd	ra,40(sp)
    80001958:	f022                	sd	s0,32(sp)
    8000195a:	ec26                	sd	s1,24(sp)
    8000195c:	e84a                	sd	s2,16(sp)
    8000195e:	e44e                	sd	s3,8(sp)
    80001960:	e052                	sd	s4,0(sp)
    80001962:	1800                	addi	s0,sp,48
    80001964:	892a                	mv	s2,a0
    80001966:	84ae                	mv	s1,a1
    80001968:	89b2                	mv	s3,a2
    8000196a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	526080e7          	jalr	1318(ra) # 80000e92 <myproc>
  if(user_src){
    80001974:	c08d                	beqz	s1,80001996 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001976:	86d2                	mv	a3,s4
    80001978:	864e                	mv	a2,s3
    8000197a:	85ca                	mv	a1,s2
    8000197c:	6928                	ld	a0,80(a0)
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	262080e7          	jalr	610(ra) # 80000be0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001986:	70a2                	ld	ra,40(sp)
    80001988:	7402                	ld	s0,32(sp)
    8000198a:	64e2                	ld	s1,24(sp)
    8000198c:	6942                	ld	s2,16(sp)
    8000198e:	69a2                	ld	s3,8(sp)
    80001990:	6a02                	ld	s4,0(sp)
    80001992:	6145                	addi	sp,sp,48
    80001994:	8082                	ret
    memmove(dst, (char*)src, len);
    80001996:	000a061b          	sext.w	a2,s4
    8000199a:	85ce                	mv	a1,s3
    8000199c:	854a                	mv	a0,s2
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	884080e7          	jalr	-1916(ra) # 80000222 <memmove>
    return 0;
    800019a6:	8526                	mv	a0,s1
    800019a8:	bff9                	j	80001986 <either_copyin+0x32>

00000000800019aa <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019aa:	715d                	addi	sp,sp,-80
    800019ac:	e486                	sd	ra,72(sp)
    800019ae:	e0a2                	sd	s0,64(sp)
    800019b0:	fc26                	sd	s1,56(sp)
    800019b2:	f84a                	sd	s2,48(sp)
    800019b4:	f44e                	sd	s3,40(sp)
    800019b6:	f052                	sd	s4,32(sp)
    800019b8:	ec56                	sd	s5,24(sp)
    800019ba:	e85a                	sd	s6,16(sp)
    800019bc:	e45e                	sd	s7,8(sp)
    800019be:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019c0:	00006517          	auipc	a0,0x6
    800019c4:	68850513          	addi	a0,a0,1672 # 80008048 <etext+0x48>
    800019c8:	00004097          	auipc	ra,0x4
    800019cc:	31a080e7          	jalr	794(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d0:	00008497          	auipc	s1,0x8
    800019d4:	c0848493          	addi	s1,s1,-1016 # 800095d8 <proc+0x158>
    800019d8:	0000e917          	auipc	s2,0xe
    800019dc:	80090913          	addi	s2,s2,-2048 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019e2:	00007997          	auipc	s3,0x7
    800019e6:	81e98993          	addi	s3,s3,-2018 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ea:	00007a97          	auipc	s5,0x7
    800019ee:	81ea8a93          	addi	s5,s5,-2018 # 80008208 <etext+0x208>
    printf("\n");
    800019f2:	00006a17          	auipc	s4,0x6
    800019f6:	656a0a13          	addi	s4,s4,1622 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019fa:	00007b97          	auipc	s7,0x7
    800019fe:	846b8b93          	addi	s7,s7,-1978 # 80008240 <states.1710>
    80001a02:	a00d                	j	80001a24 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a04:	ed86a583          	lw	a1,-296(a3)
    80001a08:	8556                	mv	a0,s5
    80001a0a:	00004097          	auipc	ra,0x4
    80001a0e:	2d8080e7          	jalr	728(ra) # 80005ce2 <printf>
    printf("\n");
    80001a12:	8552                	mv	a0,s4
    80001a14:	00004097          	auipc	ra,0x4
    80001a18:	2ce080e7          	jalr	718(ra) # 80005ce2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1c:	17048493          	addi	s1,s1,368
    80001a20:	03248163          	beq	s1,s2,80001a42 <procdump+0x98>
    if(p->state == UNUSED)
    80001a24:	86a6                	mv	a3,s1
    80001a26:	ec04a783          	lw	a5,-320(s1)
    80001a2a:	dbed                	beqz	a5,80001a1c <procdump+0x72>
      state = "???";
    80001a2c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2e:	fcfb6be3          	bltu	s6,a5,80001a04 <procdump+0x5a>
    80001a32:	1782                	slli	a5,a5,0x20
    80001a34:	9381                	srli	a5,a5,0x20
    80001a36:	078e                	slli	a5,a5,0x3
    80001a38:	97de                	add	a5,a5,s7
    80001a3a:	6390                	ld	a2,0(a5)
    80001a3c:	f661                	bnez	a2,80001a04 <procdump+0x5a>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    80001a40:	b7d1                	j	80001a04 <procdump+0x5a>
  }
}
    80001a42:	60a6                	ld	ra,72(sp)
    80001a44:	6406                	ld	s0,64(sp)
    80001a46:	74e2                	ld	s1,56(sp)
    80001a48:	7942                	ld	s2,48(sp)
    80001a4a:	79a2                	ld	s3,40(sp)
    80001a4c:	7a02                	ld	s4,32(sp)
    80001a4e:	6ae2                	ld	s5,24(sp)
    80001a50:	6b42                	ld	s6,16(sp)
    80001a52:	6ba2                	ld	s7,8(sp)
    80001a54:	6161                	addi	sp,sp,80
    80001a56:	8082                	ret

0000000080001a58 <acquire_nproc>:

// Calculate used process
uint64 acquire_nproc(){
    80001a58:	7179                	addi	sp,sp,-48
    80001a5a:	f406                	sd	ra,40(sp)
    80001a5c:	f022                	sd	s0,32(sp)
    80001a5e:	ec26                	sd	s1,24(sp)
    80001a60:	e84a                	sd	s2,16(sp)
    80001a62:	e44e                	sd	s3,8(sp)
    80001a64:	1800                	addi	s0,sp,48
  struct proc *p;
  int cnt=0;
    80001a66:	4901                	li	s2,0
  for(p=proc;p<&proc[NPROC];p++){
    80001a68:	00008497          	auipc	s1,0x8
    80001a6c:	a1848493          	addi	s1,s1,-1512 # 80009480 <proc>
    80001a70:	0000d997          	auipc	s3,0xd
    80001a74:	61098993          	addi	s3,s3,1552 # 8000f080 <tickslock>
    80001a78:	a811                	j	80001a8c <acquire_nproc+0x34>
    acquire(&p->lock);
    if(p->state != UNUSED){
      cnt++;
    }
    release(&p->lock);
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	00005097          	auipc	ra,0x5
    80001a80:	81a080e7          	jalr	-2022(ra) # 80006296 <release>
  for(p=proc;p<&proc[NPROC];p++){
    80001a84:	17048493          	addi	s1,s1,368
    80001a88:	01348b63          	beq	s1,s3,80001a9e <acquire_nproc+0x46>
    acquire(&p->lock);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	00004097          	auipc	ra,0x4
    80001a92:	754080e7          	jalr	1876(ra) # 800061e2 <acquire>
    if(p->state != UNUSED){
    80001a96:	4c9c                	lw	a5,24(s1)
    80001a98:	d3ed                	beqz	a5,80001a7a <acquire_nproc+0x22>
      cnt++;
    80001a9a:	2905                	addiw	s2,s2,1
    80001a9c:	bff9                	j	80001a7a <acquire_nproc+0x22>
  }
  return cnt;
}
    80001a9e:	854a                	mv	a0,s2
    80001aa0:	70a2                	ld	ra,40(sp)
    80001aa2:	7402                	ld	s0,32(sp)
    80001aa4:	64e2                	ld	s1,24(sp)
    80001aa6:	6942                	ld	s2,16(sp)
    80001aa8:	69a2                	ld	s3,8(sp)
    80001aaa:	6145                	addi	sp,sp,48
    80001aac:	8082                	ret

0000000080001aae <swtch>:
    80001aae:	00153023          	sd	ra,0(a0)
    80001ab2:	00253423          	sd	sp,8(a0)
    80001ab6:	e900                	sd	s0,16(a0)
    80001ab8:	ed04                	sd	s1,24(a0)
    80001aba:	03253023          	sd	s2,32(a0)
    80001abe:	03353423          	sd	s3,40(a0)
    80001ac2:	03453823          	sd	s4,48(a0)
    80001ac6:	03553c23          	sd	s5,56(a0)
    80001aca:	05653023          	sd	s6,64(a0)
    80001ace:	05753423          	sd	s7,72(a0)
    80001ad2:	05853823          	sd	s8,80(a0)
    80001ad6:	05953c23          	sd	s9,88(a0)
    80001ada:	07a53023          	sd	s10,96(a0)
    80001ade:	07b53423          	sd	s11,104(a0)
    80001ae2:	0005b083          	ld	ra,0(a1)
    80001ae6:	0085b103          	ld	sp,8(a1)
    80001aea:	6980                	ld	s0,16(a1)
    80001aec:	6d84                	ld	s1,24(a1)
    80001aee:	0205b903          	ld	s2,32(a1)
    80001af2:	0285b983          	ld	s3,40(a1)
    80001af6:	0305ba03          	ld	s4,48(a1)
    80001afa:	0385ba83          	ld	s5,56(a1)
    80001afe:	0405bb03          	ld	s6,64(a1)
    80001b02:	0485bb83          	ld	s7,72(a1)
    80001b06:	0505bc03          	ld	s8,80(a1)
    80001b0a:	0585bc83          	ld	s9,88(a1)
    80001b0e:	0605bd03          	ld	s10,96(a1)
    80001b12:	0685bd83          	ld	s11,104(a1)
    80001b16:	8082                	ret

0000000080001b18 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b18:	1141                	addi	sp,sp,-16
    80001b1a:	e406                	sd	ra,8(sp)
    80001b1c:	e022                	sd	s0,0(sp)
    80001b1e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b20:	00006597          	auipc	a1,0x6
    80001b24:	75058593          	addi	a1,a1,1872 # 80008270 <states.1710+0x30>
    80001b28:	0000d517          	auipc	a0,0xd
    80001b2c:	55850513          	addi	a0,a0,1368 # 8000f080 <tickslock>
    80001b30:	00004097          	auipc	ra,0x4
    80001b34:	622080e7          	jalr	1570(ra) # 80006152 <initlock>
}
    80001b38:	60a2                	ld	ra,8(sp)
    80001b3a:	6402                	ld	s0,0(sp)
    80001b3c:	0141                	addi	sp,sp,16
    80001b3e:	8082                	ret

0000000080001b40 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b40:	1141                	addi	sp,sp,-16
    80001b42:	e422                	sd	s0,8(sp)
    80001b44:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b46:	00003797          	auipc	a5,0x3
    80001b4a:	55a78793          	addi	a5,a5,1370 # 800050a0 <kernelvec>
    80001b4e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b52:	6422                	ld	s0,8(sp)
    80001b54:	0141                	addi	sp,sp,16
    80001b56:	8082                	ret

0000000080001b58 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b58:	1141                	addi	sp,sp,-16
    80001b5a:	e406                	sd	ra,8(sp)
    80001b5c:	e022                	sd	s0,0(sp)
    80001b5e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b60:	fffff097          	auipc	ra,0xfffff
    80001b64:	332080e7          	jalr	818(ra) # 80000e92 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b72:	00005617          	auipc	a2,0x5
    80001b76:	48e60613          	addi	a2,a2,1166 # 80007000 <_trampoline>
    80001b7a:	00005697          	auipc	a3,0x5
    80001b7e:	48668693          	addi	a3,a3,1158 # 80007000 <_trampoline>
    80001b82:	8e91                	sub	a3,a3,a2
    80001b84:	040007b7          	lui	a5,0x4000
    80001b88:	17fd                	addi	a5,a5,-1
    80001b8a:	07b2                	slli	a5,a5,0xc
    80001b8c:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b8e:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b92:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b94:	180026f3          	csrr	a3,satp
    80001b98:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b9a:	6d38                	ld	a4,88(a0)
    80001b9c:	6134                	ld	a3,64(a0)
    80001b9e:	6585                	lui	a1,0x1
    80001ba0:	96ae                	add	a3,a3,a1
    80001ba2:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ba4:	6d38                	ld	a4,88(a0)
    80001ba6:	00000697          	auipc	a3,0x0
    80001baa:	13868693          	addi	a3,a3,312 # 80001cde <usertrap>
    80001bae:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bb0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb2:	8692                	mv	a3,tp
    80001bb4:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb6:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bba:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bbe:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc2:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bc6:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc8:	6f18                	ld	a4,24(a4)
    80001bca:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bce:	692c                	ld	a1,80(a0)
    80001bd0:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001bd2:	00005717          	auipc	a4,0x5
    80001bd6:	4be70713          	addi	a4,a4,1214 # 80007090 <userret>
    80001bda:	8f11                	sub	a4,a4,a2
    80001bdc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bde:	577d                	li	a4,-1
    80001be0:	177e                	slli	a4,a4,0x3f
    80001be2:	8dd9                	or	a1,a1,a4
    80001be4:	02000537          	lui	a0,0x2000
    80001be8:	157d                	addi	a0,a0,-1
    80001bea:	0536                	slli	a0,a0,0xd
    80001bec:	9782                	jalr	a5
}
    80001bee:	60a2                	ld	ra,8(sp)
    80001bf0:	6402                	ld	s0,0(sp)
    80001bf2:	0141                	addi	sp,sp,16
    80001bf4:	8082                	ret

0000000080001bf6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf6:	1101                	addi	sp,sp,-32
    80001bf8:	ec06                	sd	ra,24(sp)
    80001bfa:	e822                	sd	s0,16(sp)
    80001bfc:	e426                	sd	s1,8(sp)
    80001bfe:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c00:	0000d497          	auipc	s1,0xd
    80001c04:	48048493          	addi	s1,s1,1152 # 8000f080 <tickslock>
    80001c08:	8526                	mv	a0,s1
    80001c0a:	00004097          	auipc	ra,0x4
    80001c0e:	5d8080e7          	jalr	1496(ra) # 800061e2 <acquire>
  ticks++;
    80001c12:	00007517          	auipc	a0,0x7
    80001c16:	40650513          	addi	a0,a0,1030 # 80009018 <ticks>
    80001c1a:	411c                	lw	a5,0(a0)
    80001c1c:	2785                	addiw	a5,a5,1
    80001c1e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c20:	00000097          	auipc	ra,0x0
    80001c24:	ac6080e7          	jalr	-1338(ra) # 800016e6 <wakeup>
  release(&tickslock);
    80001c28:	8526                	mv	a0,s1
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	66c080e7          	jalr	1644(ra) # 80006296 <release>
}
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6105                	addi	sp,sp,32
    80001c3a:	8082                	ret

0000000080001c3c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c46:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4a:	00074d63          	bltz	a4,80001c64 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c4e:	57fd                	li	a5,-1
    80001c50:	17fe                	slli	a5,a5,0x3f
    80001c52:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c54:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c56:	06f70363          	beq	a4,a5,80001cbc <devintr+0x80>
  }
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	64a2                	ld	s1,8(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret
     (scause & 0xff) == 9){
    80001c64:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c68:	46a5                	li	a3,9
    80001c6a:	fed792e3          	bne	a5,a3,80001c4e <devintr+0x12>
    int irq = plic_claim();
    80001c6e:	00003097          	auipc	ra,0x3
    80001c72:	53a080e7          	jalr	1338(ra) # 800051a8 <plic_claim>
    80001c76:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c78:	47a9                	li	a5,10
    80001c7a:	02f50763          	beq	a0,a5,80001ca8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c7e:	4785                	li	a5,1
    80001c80:	02f50963          	beq	a0,a5,80001cb2 <devintr+0x76>
    return 1;
    80001c84:	4505                	li	a0,1
    } else if(irq){
    80001c86:	d8f1                	beqz	s1,80001c5a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c88:	85a6                	mv	a1,s1
    80001c8a:	00006517          	auipc	a0,0x6
    80001c8e:	5ee50513          	addi	a0,a0,1518 # 80008278 <states.1710+0x38>
    80001c92:	00004097          	auipc	ra,0x4
    80001c96:	050080e7          	jalr	80(ra) # 80005ce2 <printf>
      plic_complete(irq);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	00003097          	auipc	ra,0x3
    80001ca0:	530080e7          	jalr	1328(ra) # 800051cc <plic_complete>
    return 1;
    80001ca4:	4505                	li	a0,1
    80001ca6:	bf55                	j	80001c5a <devintr+0x1e>
      uartintr();
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	45a080e7          	jalr	1114(ra) # 80006102 <uartintr>
    80001cb0:	b7ed                	j	80001c9a <devintr+0x5e>
      virtio_disk_intr();
    80001cb2:	00004097          	auipc	ra,0x4
    80001cb6:	9fa080e7          	jalr	-1542(ra) # 800056ac <virtio_disk_intr>
    80001cba:	b7c5                	j	80001c9a <devintr+0x5e>
    if(cpuid() == 0){
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	1aa080e7          	jalr	426(ra) # 80000e66 <cpuid>
    80001cc4:	c901                	beqz	a0,80001cd4 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc6:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cca:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ccc:	14479073          	csrw	sip,a5
    return 2;
    80001cd0:	4509                	li	a0,2
    80001cd2:	b761                	j	80001c5a <devintr+0x1e>
      clockintr();
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	f22080e7          	jalr	-222(ra) # 80001bf6 <clockintr>
    80001cdc:	b7ed                	j	80001cc6 <devintr+0x8a>

0000000080001cde <usertrap>:
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cea:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cee:	1007f793          	andi	a5,a5,256
    80001cf2:	e3ad                	bnez	a5,80001d54 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf4:	00003797          	auipc	a5,0x3
    80001cf8:	3ac78793          	addi	a5,a5,940 # 800050a0 <kernelvec>
    80001cfc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d00:	fffff097          	auipc	ra,0xfffff
    80001d04:	192080e7          	jalr	402(ra) # 80000e92 <myproc>
    80001d08:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0c:	14102773          	csrr	a4,sepc
    80001d10:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d12:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d16:	47a1                	li	a5,8
    80001d18:	04f71c63          	bne	a4,a5,80001d70 <usertrap+0x92>
    if(p->killed)
    80001d1c:	551c                	lw	a5,40(a0)
    80001d1e:	e3b9                	bnez	a5,80001d64 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d20:	6cb8                	ld	a4,88(s1)
    80001d22:	6f1c                	ld	a5,24(a4)
    80001d24:	0791                	addi	a5,a5,4
    80001d26:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d28:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d2c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d30:	10079073          	csrw	sstatus,a5
    syscall();
    80001d34:	00000097          	auipc	ra,0x0
    80001d38:	2e0080e7          	jalr	736(ra) # 80002014 <syscall>
  if(p->killed)
    80001d3c:	549c                	lw	a5,40(s1)
    80001d3e:	ebc1                	bnez	a5,80001dce <usertrap+0xf0>
  usertrapret();
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	e18080e7          	jalr	-488(ra) # 80001b58 <usertrapret>
}
    80001d48:	60e2                	ld	ra,24(sp)
    80001d4a:	6442                	ld	s0,16(sp)
    80001d4c:	64a2                	ld	s1,8(sp)
    80001d4e:	6902                	ld	s2,0(sp)
    80001d50:	6105                	addi	sp,sp,32
    80001d52:	8082                	ret
    panic("usertrap: not from user mode");
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	54450513          	addi	a0,a0,1348 # 80008298 <states.1710+0x58>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	f3c080e7          	jalr	-196(ra) # 80005c98 <panic>
      exit(-1);
    80001d64:	557d                	li	a0,-1
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	a50080e7          	jalr	-1456(ra) # 800017b6 <exit>
    80001d6e:	bf4d                	j	80001d20 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	ecc080e7          	jalr	-308(ra) # 80001c3c <devintr>
    80001d78:	892a                	mv	s2,a0
    80001d7a:	c501                	beqz	a0,80001d82 <usertrap+0xa4>
  if(p->killed)
    80001d7c:	549c                	lw	a5,40(s1)
    80001d7e:	c3a1                	beqz	a5,80001dbe <usertrap+0xe0>
    80001d80:	a815                	j	80001db4 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d82:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d86:	5890                	lw	a2,48(s1)
    80001d88:	00006517          	auipc	a0,0x6
    80001d8c:	53050513          	addi	a0,a0,1328 # 800082b8 <states.1710+0x78>
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	f52080e7          	jalr	-174(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d98:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d9c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	54850513          	addi	a0,a0,1352 # 800082e8 <states.1710+0xa8>
    80001da8:	00004097          	auipc	ra,0x4
    80001dac:	f3a080e7          	jalr	-198(ra) # 80005ce2 <printf>
    p->killed = 1;
    80001db0:	4785                	li	a5,1
    80001db2:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001db4:	557d                	li	a0,-1
    80001db6:	00000097          	auipc	ra,0x0
    80001dba:	a00080e7          	jalr	-1536(ra) # 800017b6 <exit>
  if(which_dev == 2)
    80001dbe:	4789                	li	a5,2
    80001dc0:	f8f910e3          	bne	s2,a5,80001d40 <usertrap+0x62>
    yield();
    80001dc4:	fffff097          	auipc	ra,0xfffff
    80001dc8:	75a080e7          	jalr	1882(ra) # 8000151e <yield>
    80001dcc:	bf95                	j	80001d40 <usertrap+0x62>
  int which_dev = 0;
    80001dce:	4901                	li	s2,0
    80001dd0:	b7d5                	j	80001db4 <usertrap+0xd6>

0000000080001dd2 <kerneltrap>:
{
    80001dd2:	7179                	addi	sp,sp,-48
    80001dd4:	f406                	sd	ra,40(sp)
    80001dd6:	f022                	sd	s0,32(sp)
    80001dd8:	ec26                	sd	s1,24(sp)
    80001dda:	e84a                	sd	s2,16(sp)
    80001ddc:	e44e                	sd	s3,8(sp)
    80001dde:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dec:	1004f793          	andi	a5,s1,256
    80001df0:	cb85                	beqz	a5,80001e20 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df8:	ef85                	bnez	a5,80001e30 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dfa:	00000097          	auipc	ra,0x0
    80001dfe:	e42080e7          	jalr	-446(ra) # 80001c3c <devintr>
    80001e02:	cd1d                	beqz	a0,80001e40 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e04:	4789                	li	a5,2
    80001e06:	06f50a63          	beq	a0,a5,80001e7a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e0a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e0e:	10049073          	csrw	sstatus,s1
}
    80001e12:	70a2                	ld	ra,40(sp)
    80001e14:	7402                	ld	s0,32(sp)
    80001e16:	64e2                	ld	s1,24(sp)
    80001e18:	6942                	ld	s2,16(sp)
    80001e1a:	69a2                	ld	s3,8(sp)
    80001e1c:	6145                	addi	sp,sp,48
    80001e1e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e20:	00006517          	auipc	a0,0x6
    80001e24:	4e850513          	addi	a0,a0,1256 # 80008308 <states.1710+0xc8>
    80001e28:	00004097          	auipc	ra,0x4
    80001e2c:	e70080e7          	jalr	-400(ra) # 80005c98 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	50050513          	addi	a0,a0,1280 # 80008330 <states.1710+0xf0>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	e60080e7          	jalr	-416(ra) # 80005c98 <panic>
    printf("scause %p\n", scause);
    80001e40:	85ce                	mv	a1,s3
    80001e42:	00006517          	auipc	a0,0x6
    80001e46:	50e50513          	addi	a0,a0,1294 # 80008350 <states.1710+0x110>
    80001e4a:	00004097          	auipc	ra,0x4
    80001e4e:	e98080e7          	jalr	-360(ra) # 80005ce2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e56:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	50650513          	addi	a0,a0,1286 # 80008360 <states.1710+0x120>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	e80080e7          	jalr	-384(ra) # 80005ce2 <printf>
    panic("kerneltrap");
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	50e50513          	addi	a0,a0,1294 # 80008378 <states.1710+0x138>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	e26080e7          	jalr	-474(ra) # 80005c98 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	018080e7          	jalr	24(ra) # 80000e92 <myproc>
    80001e82:	d541                	beqz	a0,80001e0a <kerneltrap+0x38>
    80001e84:	fffff097          	auipc	ra,0xfffff
    80001e88:	00e080e7          	jalr	14(ra) # 80000e92 <myproc>
    80001e8c:	4d18                	lw	a4,24(a0)
    80001e8e:	4791                	li	a5,4
    80001e90:	f6f71de3          	bne	a4,a5,80001e0a <kerneltrap+0x38>
    yield();
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	68a080e7          	jalr	1674(ra) # 8000151e <yield>
    80001e9c:	b7bd                	j	80001e0a <kerneltrap+0x38>

0000000080001e9e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e9e:	1101                	addi	sp,sp,-32
    80001ea0:	ec06                	sd	ra,24(sp)
    80001ea2:	e822                	sd	s0,16(sp)
    80001ea4:	e426                	sd	s1,8(sp)
    80001ea6:	1000                	addi	s0,sp,32
    80001ea8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001eaa:	fffff097          	auipc	ra,0xfffff
    80001eae:	fe8080e7          	jalr	-24(ra) # 80000e92 <myproc>
  switch (n) {
    80001eb2:	4795                	li	a5,5
    80001eb4:	0497e163          	bltu	a5,s1,80001ef6 <argraw+0x58>
    80001eb8:	048a                	slli	s1,s1,0x2
    80001eba:	00006717          	auipc	a4,0x6
    80001ebe:	5be70713          	addi	a4,a4,1470 # 80008478 <states.1710+0x238>
    80001ec2:	94ba                	add	s1,s1,a4
    80001ec4:	409c                	lw	a5,0(s1)
    80001ec6:	97ba                	add	a5,a5,a4
    80001ec8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001eca:	6d3c                	ld	a5,88(a0)
    80001ecc:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ece:	60e2                	ld	ra,24(sp)
    80001ed0:	6442                	ld	s0,16(sp)
    80001ed2:	64a2                	ld	s1,8(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret
    return p->trapframe->a1;
    80001ed8:	6d3c                	ld	a5,88(a0)
    80001eda:	7fa8                	ld	a0,120(a5)
    80001edc:	bfcd                	j	80001ece <argraw+0x30>
    return p->trapframe->a2;
    80001ede:	6d3c                	ld	a5,88(a0)
    80001ee0:	63c8                	ld	a0,128(a5)
    80001ee2:	b7f5                	j	80001ece <argraw+0x30>
    return p->trapframe->a3;
    80001ee4:	6d3c                	ld	a5,88(a0)
    80001ee6:	67c8                	ld	a0,136(a5)
    80001ee8:	b7dd                	j	80001ece <argraw+0x30>
    return p->trapframe->a4;
    80001eea:	6d3c                	ld	a5,88(a0)
    80001eec:	6bc8                	ld	a0,144(a5)
    80001eee:	b7c5                	j	80001ece <argraw+0x30>
    return p->trapframe->a5;
    80001ef0:	6d3c                	ld	a5,88(a0)
    80001ef2:	6fc8                	ld	a0,152(a5)
    80001ef4:	bfe9                	j	80001ece <argraw+0x30>
  panic("argraw");
    80001ef6:	00006517          	auipc	a0,0x6
    80001efa:	49250513          	addi	a0,a0,1170 # 80008388 <states.1710+0x148>
    80001efe:	00004097          	auipc	ra,0x4
    80001f02:	d9a080e7          	jalr	-614(ra) # 80005c98 <panic>

0000000080001f06 <fetchaddr>:
{
    80001f06:	1101                	addi	sp,sp,-32
    80001f08:	ec06                	sd	ra,24(sp)
    80001f0a:	e822                	sd	s0,16(sp)
    80001f0c:	e426                	sd	s1,8(sp)
    80001f0e:	e04a                	sd	s2,0(sp)
    80001f10:	1000                	addi	s0,sp,32
    80001f12:	84aa                	mv	s1,a0
    80001f14:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f16:	fffff097          	auipc	ra,0xfffff
    80001f1a:	f7c080e7          	jalr	-132(ra) # 80000e92 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f1e:	653c                	ld	a5,72(a0)
    80001f20:	02f4f863          	bgeu	s1,a5,80001f50 <fetchaddr+0x4a>
    80001f24:	00848713          	addi	a4,s1,8
    80001f28:	02e7e663          	bltu	a5,a4,80001f54 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f2c:	46a1                	li	a3,8
    80001f2e:	8626                	mv	a2,s1
    80001f30:	85ca                	mv	a1,s2
    80001f32:	6928                	ld	a0,80(a0)
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	cac080e7          	jalr	-852(ra) # 80000be0 <copyin>
    80001f3c:	00a03533          	snez	a0,a0
    80001f40:	40a00533          	neg	a0,a0
}
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6902                	ld	s2,0(sp)
    80001f4c:	6105                	addi	sp,sp,32
    80001f4e:	8082                	ret
    return -1;
    80001f50:	557d                	li	a0,-1
    80001f52:	bfcd                	j	80001f44 <fetchaddr+0x3e>
    80001f54:	557d                	li	a0,-1
    80001f56:	b7fd                	j	80001f44 <fetchaddr+0x3e>

0000000080001f58 <fetchstr>:
{
    80001f58:	7179                	addi	sp,sp,-48
    80001f5a:	f406                	sd	ra,40(sp)
    80001f5c:	f022                	sd	s0,32(sp)
    80001f5e:	ec26                	sd	s1,24(sp)
    80001f60:	e84a                	sd	s2,16(sp)
    80001f62:	e44e                	sd	s3,8(sp)
    80001f64:	1800                	addi	s0,sp,48
    80001f66:	892a                	mv	s2,a0
    80001f68:	84ae                	mv	s1,a1
    80001f6a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	f26080e7          	jalr	-218(ra) # 80000e92 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f74:	86ce                	mv	a3,s3
    80001f76:	864a                	mv	a2,s2
    80001f78:	85a6                	mv	a1,s1
    80001f7a:	6928                	ld	a0,80(a0)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	cf0080e7          	jalr	-784(ra) # 80000c6c <copyinstr>
  if(err < 0)
    80001f84:	00054763          	bltz	a0,80001f92 <fetchstr+0x3a>
  return strlen(buf);
    80001f88:	8526                	mv	a0,s1
    80001f8a:	ffffe097          	auipc	ra,0xffffe
    80001f8e:	3bc080e7          	jalr	956(ra) # 80000346 <strlen>
}
    80001f92:	70a2                	ld	ra,40(sp)
    80001f94:	7402                	ld	s0,32(sp)
    80001f96:	64e2                	ld	s1,24(sp)
    80001f98:	6942                	ld	s2,16(sp)
    80001f9a:	69a2                	ld	s3,8(sp)
    80001f9c:	6145                	addi	sp,sp,48
    80001f9e:	8082                	ret

0000000080001fa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	1000                	addi	s0,sp,32
    80001faa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fac:	00000097          	auipc	ra,0x0
    80001fb0:	ef2080e7          	jalr	-270(ra) # 80001e9e <argraw>
    80001fb4:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fb6:	4501                	li	a0,0
    80001fb8:	60e2                	ld	ra,24(sp)
    80001fba:	6442                	ld	s0,16(sp)
    80001fbc:	64a2                	ld	s1,8(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret

0000000080001fc2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	ed0080e7          	jalr	-304(ra) # 80001e9e <argraw>
    80001fd6:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fd8:	4501                	li	a0,0
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret

0000000080001fe4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fe4:	1101                	addi	sp,sp,-32
    80001fe6:	ec06                	sd	ra,24(sp)
    80001fe8:	e822                	sd	s0,16(sp)
    80001fea:	e426                	sd	s1,8(sp)
    80001fec:	e04a                	sd	s2,0(sp)
    80001fee:	1000                	addi	s0,sp,32
    80001ff0:	84ae                	mv	s1,a1
    80001ff2:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	eaa080e7          	jalr	-342(ra) # 80001e9e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001ffc:	864a                	mv	a2,s2
    80001ffe:	85a6                	mv	a1,s1
    80002000:	00000097          	auipc	ra,0x0
    80002004:	f58080e7          	jalr	-168(ra) # 80001f58 <fetchstr>
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6902                	ld	s2,0(sp)
    80002010:	6105                	addi	sp,sp,32
    80002012:	8082                	ret

0000000080002014 <syscall>:
  "uptime","open","write","mknod","unlink","link","mkdir","close","trace","sysinfo"
};

void
syscall(void)
{
    80002014:	7179                	addi	sp,sp,-48
    80002016:	f406                	sd	ra,40(sp)
    80002018:	f022                	sd	s0,32(sp)
    8000201a:	ec26                	sd	s1,24(sp)
    8000201c:	e84a                	sd	s2,16(sp)
    8000201e:	e44e                	sd	s3,8(sp)
    80002020:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	e70080e7          	jalr	-400(ra) # 80000e92 <myproc>
    8000202a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000202c:	05853903          	ld	s2,88(a0)
    80002030:	0a893783          	ld	a5,168(s2)
    80002034:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002038:	37fd                	addiw	a5,a5,-1
    8000203a:	4759                	li	a4,22
    8000203c:	04f76a63          	bltu	a4,a5,80002090 <syscall+0x7c>
    80002040:	00399713          	slli	a4,s3,0x3
    80002044:	00006797          	auipc	a5,0x6
    80002048:	44c78793          	addi	a5,a5,1100 # 80008490 <syscalls>
    8000204c:	97ba                	add	a5,a5,a4
    8000204e:	639c                	ld	a5,0(a5)
    80002050:	c3a1                	beqz	a5,80002090 <syscall+0x7c>
    p->trapframe->a0 = syscalls[num]();//return value stored in register a0
    80002052:	9782                	jalr	a5
    80002054:	06a93823          	sd	a0,112(s2)
    int trace_mask=p->trace_mask;
    if((trace_mask>>num)&1){
    80002058:	1684a783          	lw	a5,360(s1)
    8000205c:	4137d7bb          	sraw	a5,a5,s3
    80002060:	8b85                	andi	a5,a5,1
    80002062:	c7b1                	beqz	a5,800020ae <syscall+0x9a>
      printf("%d: syscall %s -> %d\n",p->pid,syscall_names[num-1],p->trapframe->a0);
    80002064:	6cb8                	ld	a4,88(s1)
    80002066:	39fd                	addiw	s3,s3,-1
    80002068:	00399793          	slli	a5,s3,0x3
    8000206c:	00006997          	auipc	s3,0x6
    80002070:	42498993          	addi	s3,s3,1060 # 80008490 <syscalls>
    80002074:	99be                	add	s3,s3,a5
    80002076:	7b34                	ld	a3,112(a4)
    80002078:	0c09b603          	ld	a2,192(s3)
    8000207c:	588c                	lw	a1,48(s1)
    8000207e:	00006517          	auipc	a0,0x6
    80002082:	31250513          	addi	a0,a0,786 # 80008390 <states.1710+0x150>
    80002086:	00004097          	auipc	ra,0x4
    8000208a:	c5c080e7          	jalr	-932(ra) # 80005ce2 <printf>
    8000208e:	a005                	j	800020ae <syscall+0x9a>
    }
  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002090:	86ce                	mv	a3,s3
    80002092:	15848613          	addi	a2,s1,344
    80002096:	588c                	lw	a1,48(s1)
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	31050513          	addi	a0,a0,784 # 800083a8 <states.1710+0x168>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	c42080e7          	jalr	-958(ra) # 80005ce2 <printf>
    p->trapframe->a0 = -1;
    800020a8:	6cbc                	ld	a5,88(s1)
    800020aa:	577d                	li	a4,-1
    800020ac:	fbb8                	sd	a4,112(a5)
  }
}
    800020ae:	70a2                	ld	ra,40(sp)
    800020b0:	7402                	ld	s0,32(sp)
    800020b2:	64e2                	ld	s1,24(sp)
    800020b4:	6942                	ld	s2,16(sp)
    800020b6:	69a2                	ld	s3,8(sp)
    800020b8:	6145                	addi	sp,sp,48
    800020ba:	8082                	ret

00000000800020bc <sys_exit>:
uint64 acquire_freemem();
uint64 acquire_nproc();

uint64
sys_exit(void)
{
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020c4:	fec40593          	addi	a1,s0,-20
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	ed6080e7          	jalr	-298(ra) # 80001fa0 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	00054963          	bltz	a0,800020e6 <sys_exit+0x2a>
  exit(n);
    800020d8:	fec42503          	lw	a0,-20(s0)
    800020dc:	fffff097          	auipc	ra,0xfffff
    800020e0:	6da080e7          	jalr	1754(ra) # 800017b6 <exit>
  return 0;  // not reached
    800020e4:	4781                	li	a5,0
}
    800020e6:	853e                	mv	a0,a5
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	6105                	addi	sp,sp,32
    800020ee:	8082                	ret

00000000800020f0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020f0:	1141                	addi	sp,sp,-16
    800020f2:	e406                	sd	ra,8(sp)
    800020f4:	e022                	sd	s0,0(sp)
    800020f6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	d9a080e7          	jalr	-614(ra) # 80000e92 <myproc>
}
    80002100:	5908                	lw	a0,48(a0)
    80002102:	60a2                	ld	ra,8(sp)
    80002104:	6402                	ld	s0,0(sp)
    80002106:	0141                	addi	sp,sp,16
    80002108:	8082                	ret

000000008000210a <sys_fork>:

uint64
sys_fork(void)
{
    8000210a:	1141                	addi	sp,sp,-16
    8000210c:	e406                	sd	ra,8(sp)
    8000210e:	e022                	sd	s0,0(sp)
    80002110:	0800                	addi	s0,sp,16
  return fork();
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	152080e7          	jalr	338(ra) # 80001264 <fork>
}
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_wait>:

uint64
sys_wait(void)
{
    80002122:	1101                	addi	sp,sp,-32
    80002124:	ec06                	sd	ra,24(sp)
    80002126:	e822                	sd	s0,16(sp)
    80002128:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000212a:	fe840593          	addi	a1,s0,-24
    8000212e:	4501                	li	a0,0
    80002130:	00000097          	auipc	ra,0x0
    80002134:	e92080e7          	jalr	-366(ra) # 80001fc2 <argaddr>
    80002138:	87aa                	mv	a5,a0
    return -1;
    8000213a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000213c:	0007c863          	bltz	a5,8000214c <sys_wait+0x2a>
  return wait(p);
    80002140:	fe843503          	ld	a0,-24(s0)
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	47a080e7          	jalr	1146(ra) # 800015be <wait>
}
    8000214c:	60e2                	ld	ra,24(sp)
    8000214e:	6442                	ld	s0,16(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000215e:	fdc40593          	addi	a1,s0,-36
    80002162:	4501                	li	a0,0
    80002164:	00000097          	auipc	ra,0x0
    80002168:	e3c080e7          	jalr	-452(ra) # 80001fa0 <argint>
    8000216c:	87aa                	mv	a5,a0
    return -1;
    8000216e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002170:	0207c063          	bltz	a5,80002190 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	d1e080e7          	jalr	-738(ra) # 80000e92 <myproc>
    8000217c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000217e:	fdc42503          	lw	a0,-36(s0)
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	06e080e7          	jalr	110(ra) # 800011f0 <growproc>
    8000218a:	00054863          	bltz	a0,8000219a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000218e:	8526                	mv	a0,s1
}
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6145                	addi	sp,sp,48
    80002198:	8082                	ret
    return -1;
    8000219a:	557d                	li	a0,-1
    8000219c:	bfd5                	j	80002190 <sys_sbrk+0x3c>

000000008000219e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000219e:	7139                	addi	sp,sp,-64
    800021a0:	fc06                	sd	ra,56(sp)
    800021a2:	f822                	sd	s0,48(sp)
    800021a4:	f426                	sd	s1,40(sp)
    800021a6:	f04a                	sd	s2,32(sp)
    800021a8:	ec4e                	sd	s3,24(sp)
    800021aa:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ac:	fcc40593          	addi	a1,s0,-52
    800021b0:	4501                	li	a0,0
    800021b2:	00000097          	auipc	ra,0x0
    800021b6:	dee080e7          	jalr	-530(ra) # 80001fa0 <argint>
    return -1;
    800021ba:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021bc:	06054563          	bltz	a0,80002226 <sys_sleep+0x88>
  acquire(&tickslock);
    800021c0:	0000d517          	auipc	a0,0xd
    800021c4:	ec050513          	addi	a0,a0,-320 # 8000f080 <tickslock>
    800021c8:	00004097          	auipc	ra,0x4
    800021cc:	01a080e7          	jalr	26(ra) # 800061e2 <acquire>
  ticks0 = ticks;
    800021d0:	00007917          	auipc	s2,0x7
    800021d4:	e4892903          	lw	s2,-440(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021d8:	fcc42783          	lw	a5,-52(s0)
    800021dc:	cf85                	beqz	a5,80002214 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021de:	0000d997          	auipc	s3,0xd
    800021e2:	ea298993          	addi	s3,s3,-350 # 8000f080 <tickslock>
    800021e6:	00007497          	auipc	s1,0x7
    800021ea:	e3248493          	addi	s1,s1,-462 # 80009018 <ticks>
    if(myproc()->killed){
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	ca4080e7          	jalr	-860(ra) # 80000e92 <myproc>
    800021f6:	551c                	lw	a5,40(a0)
    800021f8:	ef9d                	bnez	a5,80002236 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021fa:	85ce                	mv	a1,s3
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	35c080e7          	jalr	860(ra) # 8000155a <sleep>
  while(ticks - ticks0 < n){
    80002206:	409c                	lw	a5,0(s1)
    80002208:	412787bb          	subw	a5,a5,s2
    8000220c:	fcc42703          	lw	a4,-52(s0)
    80002210:	fce7efe3          	bltu	a5,a4,800021ee <sys_sleep+0x50>
  }
  release(&tickslock);
    80002214:	0000d517          	auipc	a0,0xd
    80002218:	e6c50513          	addi	a0,a0,-404 # 8000f080 <tickslock>
    8000221c:	00004097          	auipc	ra,0x4
    80002220:	07a080e7          	jalr	122(ra) # 80006296 <release>
  return 0;
    80002224:	4781                	li	a5,0
}
    80002226:	853e                	mv	a0,a5
    80002228:	70e2                	ld	ra,56(sp)
    8000222a:	7442                	ld	s0,48(sp)
    8000222c:	74a2                	ld	s1,40(sp)
    8000222e:	7902                	ld	s2,32(sp)
    80002230:	69e2                	ld	s3,24(sp)
    80002232:	6121                	addi	sp,sp,64
    80002234:	8082                	ret
      release(&tickslock);
    80002236:	0000d517          	auipc	a0,0xd
    8000223a:	e4a50513          	addi	a0,a0,-438 # 8000f080 <tickslock>
    8000223e:	00004097          	auipc	ra,0x4
    80002242:	058080e7          	jalr	88(ra) # 80006296 <release>
      return -1;
    80002246:	57fd                	li	a5,-1
    80002248:	bff9                	j	80002226 <sys_sleep+0x88>

000000008000224a <sys_kill>:

uint64
sys_kill(void)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002252:	fec40593          	addi	a1,s0,-20
    80002256:	4501                	li	a0,0
    80002258:	00000097          	auipc	ra,0x0
    8000225c:	d48080e7          	jalr	-696(ra) # 80001fa0 <argint>
    80002260:	87aa                	mv	a5,a0
    return -1;
    80002262:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002264:	0007c863          	bltz	a5,80002274 <sys_kill+0x2a>
  return kill(pid);
    80002268:	fec42503          	lw	a0,-20(s0)
    8000226c:	fffff097          	auipc	ra,0xfffff
    80002270:	620080e7          	jalr	1568(ra) # 8000188c <kill>
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	dfa50513          	addi	a0,a0,-518 # 8000f080 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	f54080e7          	jalr	-172(ra) # 800061e2 <acquire>
  xticks = ticks;
    80002296:	00007497          	auipc	s1,0x7
    8000229a:	d824a483          	lw	s1,-638(s1) # 80009018 <ticks>
  release(&tickslock);
    8000229e:	0000d517          	auipc	a0,0xd
    800022a2:	de250513          	addi	a0,a0,-542 # 8000f080 <tickslock>
    800022a6:	00004097          	auipc	ra,0x4
    800022aa:	ff0080e7          	jalr	-16(ra) # 80006296 <release>
  return xticks;
}
    800022ae:	02049513          	slli	a0,s1,0x20
    800022b2:	9101                	srli	a0,a0,0x20
    800022b4:	60e2                	ld	ra,24(sp)
    800022b6:	6442                	ld	s0,16(sp)
    800022b8:	64a2                	ld	s1,8(sp)
    800022ba:	6105                	addi	sp,sp,32
    800022bc:	8082                	ret

00000000800022be <sys_trace>:

//Add a sys_trace() function in kernel/sysproc.c
uint64
sys_trace(void)
{
    800022be:	1101                	addi	sp,sp,-32
    800022c0:	ec06                	sd	ra,24(sp)
    800022c2:	e822                	sd	s0,16(sp)
    800022c4:	1000                	addi	s0,sp,32
  int mask;
  if(argint(0, &mask) < 0)
    800022c6:	fec40593          	addi	a1,s0,-20
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	cd4080e7          	jalr	-812(ra) # 80001fa0 <argint>
    return -1;
    800022d4:	57fd                	li	a5,-1
  if(argint(0, &mask) < 0)
    800022d6:	00054b63          	bltz	a0,800022ec <sys_trace+0x2e>
  struct proc *p = myproc();
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	bb8080e7          	jalr	-1096(ra) # 80000e92 <myproc>
  p->trace_mask = mask;
    800022e2:	fec42783          	lw	a5,-20(s0)
    800022e6:	16f52423          	sw	a5,360(a0)
  return 0;
    800022ea:	4781                	li	a5,0
}
    800022ec:	853e                	mv	a0,a5
    800022ee:	60e2                	ld	ra,24(sp)
    800022f0:	6442                	ld	s0,16(sp)
    800022f2:	6105                	addi	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <sys_sysinfo>:

//Add a sys_sysinfo() function in kernel/sysproc.c
uint64
sys_sysinfo(void)
{
    800022f6:	7139                	addi	sp,sp,-64
    800022f8:	fc06                	sd	ra,56(sp)
    800022fa:	f822                	sd	s0,48(sp)
    800022fc:	f426                	sd	s1,40(sp)
    800022fe:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 addr;

  info.nproc=acquire_nproc();
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	758080e7          	jalr	1880(ra) # 80001a58 <acquire_nproc>
    80002308:	fca43c23          	sd	a0,-40(s0)
  info.freemem=acquire_freemem();
    8000230c:	ffffe097          	auipc	ra,0xffffe
    80002310:	e6c080e7          	jalr	-404(ra) # 80000178 <acquire_freemem>
    80002314:	fca43823          	sd	a0,-48(s0)

  struct proc *p = myproc();
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	b7a080e7          	jalr	-1158(ra) # 80000e92 <myproc>
    80002320:	84aa                	mv	s1,a0

  if(argaddr(0, &addr) < 0)
    80002322:	fc840593          	addi	a1,s0,-56
    80002326:	4501                	li	a0,0
    80002328:	00000097          	auipc	ra,0x0
    8000232c:	c9a080e7          	jalr	-870(ra) # 80001fc2 <argaddr>
    return -1;
    80002330:	57fd                	li	a5,-1
  if(argaddr(0, &addr) < 0)
    80002332:	00054e63          	bltz	a0,8000234e <sys_sysinfo+0x58>
  
  if(copyout(p->pagetable, addr, (char *)&info, sizeof(info)) < 0)
    80002336:	46c1                	li	a3,16
    80002338:	fd040613          	addi	a2,s0,-48
    8000233c:	fc843583          	ld	a1,-56(s0)
    80002340:	68a8                	ld	a0,80(s1)
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	812080e7          	jalr	-2030(ra) # 80000b54 <copyout>
    8000234a:	43f55793          	srai	a5,a0,0x3f
      return -1;
    
  return 0;
}
    8000234e:	853e                	mv	a0,a5
    80002350:	70e2                	ld	ra,56(sp)
    80002352:	7442                	ld	s0,48(sp)
    80002354:	74a2                	ld	s1,40(sp)
    80002356:	6121                	addi	sp,sp,64
    80002358:	8082                	ret

000000008000235a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000235a:	7179                	addi	sp,sp,-48
    8000235c:	f406                	sd	ra,40(sp)
    8000235e:	f022                	sd	s0,32(sp)
    80002360:	ec26                	sd	s1,24(sp)
    80002362:	e84a                	sd	s2,16(sp)
    80002364:	e44e                	sd	s3,8(sp)
    80002366:	e052                	sd	s4,0(sp)
    80002368:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000236a:	00006597          	auipc	a1,0x6
    8000236e:	29e58593          	addi	a1,a1,670 # 80008608 <syscall_names+0xb8>
    80002372:	0000d517          	auipc	a0,0xd
    80002376:	d2650513          	addi	a0,a0,-730 # 8000f098 <bcache>
    8000237a:	00004097          	auipc	ra,0x4
    8000237e:	dd8080e7          	jalr	-552(ra) # 80006152 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002382:	00015797          	auipc	a5,0x15
    80002386:	d1678793          	addi	a5,a5,-746 # 80017098 <bcache+0x8000>
    8000238a:	00015717          	auipc	a4,0x15
    8000238e:	f7670713          	addi	a4,a4,-138 # 80017300 <bcache+0x8268>
    80002392:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002396:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000239a:	0000d497          	auipc	s1,0xd
    8000239e:	d1648493          	addi	s1,s1,-746 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023a2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a6:	00006a17          	auipc	s4,0x6
    800023aa:	26aa0a13          	addi	s4,s4,618 # 80008610 <syscall_names+0xc0>
    b->next = bcache.head.next;
    800023ae:	2b893783          	ld	a5,696(s2)
    800023b2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b8:	85d2                	mv	a1,s4
    800023ba:	01048513          	addi	a0,s1,16
    800023be:	00001097          	auipc	ra,0x1
    800023c2:	4bc080e7          	jalr	1212(ra) # 8000387a <initsleeplock>
    bcache.head.next->prev = b;
    800023c6:	2b893783          	ld	a5,696(s2)
    800023ca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023d0:	45848493          	addi	s1,s1,1112
    800023d4:	fd349de3          	bne	s1,s3,800023ae <binit+0x54>
  }
}
    800023d8:	70a2                	ld	ra,40(sp)
    800023da:	7402                	ld	s0,32(sp)
    800023dc:	64e2                	ld	s1,24(sp)
    800023de:	6942                	ld	s2,16(sp)
    800023e0:	69a2                	ld	s3,8(sp)
    800023e2:	6a02                	ld	s4,0(sp)
    800023e4:	6145                	addi	sp,sp,48
    800023e6:	8082                	ret

00000000800023e8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e8:	7179                	addi	sp,sp,-48
    800023ea:	f406                	sd	ra,40(sp)
    800023ec:	f022                	sd	s0,32(sp)
    800023ee:	ec26                	sd	s1,24(sp)
    800023f0:	e84a                	sd	s2,16(sp)
    800023f2:	e44e                	sd	s3,8(sp)
    800023f4:	1800                	addi	s0,sp,48
    800023f6:	89aa                	mv	s3,a0
    800023f8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023fa:	0000d517          	auipc	a0,0xd
    800023fe:	c9e50513          	addi	a0,a0,-866 # 8000f098 <bcache>
    80002402:	00004097          	auipc	ra,0x4
    80002406:	de0080e7          	jalr	-544(ra) # 800061e2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000240a:	00015497          	auipc	s1,0x15
    8000240e:	f464b483          	ld	s1,-186(s1) # 80017350 <bcache+0x82b8>
    80002412:	00015797          	auipc	a5,0x15
    80002416:	eee78793          	addi	a5,a5,-274 # 80017300 <bcache+0x8268>
    8000241a:	02f48f63          	beq	s1,a5,80002458 <bread+0x70>
    8000241e:	873e                	mv	a4,a5
    80002420:	a021                	j	80002428 <bread+0x40>
    80002422:	68a4                	ld	s1,80(s1)
    80002424:	02e48a63          	beq	s1,a4,80002458 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002428:	449c                	lw	a5,8(s1)
    8000242a:	ff379ce3          	bne	a5,s3,80002422 <bread+0x3a>
    8000242e:	44dc                	lw	a5,12(s1)
    80002430:	ff2799e3          	bne	a5,s2,80002422 <bread+0x3a>
      b->refcnt++;
    80002434:	40bc                	lw	a5,64(s1)
    80002436:	2785                	addiw	a5,a5,1
    80002438:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243a:	0000d517          	auipc	a0,0xd
    8000243e:	c5e50513          	addi	a0,a0,-930 # 8000f098 <bcache>
    80002442:	00004097          	auipc	ra,0x4
    80002446:	e54080e7          	jalr	-428(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    8000244a:	01048513          	addi	a0,s1,16
    8000244e:	00001097          	auipc	ra,0x1
    80002452:	466080e7          	jalr	1126(ra) # 800038b4 <acquiresleep>
      return b;
    80002456:	a8b9                	j	800024b4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002458:	00015497          	auipc	s1,0x15
    8000245c:	ef04b483          	ld	s1,-272(s1) # 80017348 <bcache+0x82b0>
    80002460:	00015797          	auipc	a5,0x15
    80002464:	ea078793          	addi	a5,a5,-352 # 80017300 <bcache+0x8268>
    80002468:	00f48863          	beq	s1,a5,80002478 <bread+0x90>
    8000246c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000246e:	40bc                	lw	a5,64(s1)
    80002470:	cf81                	beqz	a5,80002488 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002472:	64a4                	ld	s1,72(s1)
    80002474:	fee49de3          	bne	s1,a4,8000246e <bread+0x86>
  panic("bget: no buffers");
    80002478:	00006517          	auipc	a0,0x6
    8000247c:	1a050513          	addi	a0,a0,416 # 80008618 <syscall_names+0xc8>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	818080e7          	jalr	-2024(ra) # 80005c98 <panic>
      b->dev = dev;
    80002488:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000248c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002490:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002494:	4785                	li	a5,1
    80002496:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002498:	0000d517          	auipc	a0,0xd
    8000249c:	c0050513          	addi	a0,a0,-1024 # 8000f098 <bcache>
    800024a0:	00004097          	auipc	ra,0x4
    800024a4:	df6080e7          	jalr	-522(ra) # 80006296 <release>
      acquiresleep(&b->lock);
    800024a8:	01048513          	addi	a0,s1,16
    800024ac:	00001097          	auipc	ra,0x1
    800024b0:	408080e7          	jalr	1032(ra) # 800038b4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b4:	409c                	lw	a5,0(s1)
    800024b6:	cb89                	beqz	a5,800024c8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b8:	8526                	mv	a0,s1
    800024ba:	70a2                	ld	ra,40(sp)
    800024bc:	7402                	ld	s0,32(sp)
    800024be:	64e2                	ld	s1,24(sp)
    800024c0:	6942                	ld	s2,16(sp)
    800024c2:	69a2                	ld	s3,8(sp)
    800024c4:	6145                	addi	sp,sp,48
    800024c6:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c8:	4581                	li	a1,0
    800024ca:	8526                	mv	a0,s1
    800024cc:	00003097          	auipc	ra,0x3
    800024d0:	f0a080e7          	jalr	-246(ra) # 800053d6 <virtio_disk_rw>
    b->valid = 1;
    800024d4:	4785                	li	a5,1
    800024d6:	c09c                	sw	a5,0(s1)
  return b;
    800024d8:	b7c5                	j	800024b8 <bread+0xd0>

00000000800024da <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024da:	1101                	addi	sp,sp,-32
    800024dc:	ec06                	sd	ra,24(sp)
    800024de:	e822                	sd	s0,16(sp)
    800024e0:	e426                	sd	s1,8(sp)
    800024e2:	1000                	addi	s0,sp,32
    800024e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e6:	0541                	addi	a0,a0,16
    800024e8:	00001097          	auipc	ra,0x1
    800024ec:	466080e7          	jalr	1126(ra) # 8000394e <holdingsleep>
    800024f0:	cd01                	beqz	a0,80002508 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024f2:	4585                	li	a1,1
    800024f4:	8526                	mv	a0,s1
    800024f6:	00003097          	auipc	ra,0x3
    800024fa:	ee0080e7          	jalr	-288(ra) # 800053d6 <virtio_disk_rw>
}
    800024fe:	60e2                	ld	ra,24(sp)
    80002500:	6442                	ld	s0,16(sp)
    80002502:	64a2                	ld	s1,8(sp)
    80002504:	6105                	addi	sp,sp,32
    80002506:	8082                	ret
    panic("bwrite");
    80002508:	00006517          	auipc	a0,0x6
    8000250c:	12850513          	addi	a0,a0,296 # 80008630 <syscall_names+0xe0>
    80002510:	00003097          	auipc	ra,0x3
    80002514:	788080e7          	jalr	1928(ra) # 80005c98 <panic>

0000000080002518 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002518:	1101                	addi	sp,sp,-32
    8000251a:	ec06                	sd	ra,24(sp)
    8000251c:	e822                	sd	s0,16(sp)
    8000251e:	e426                	sd	s1,8(sp)
    80002520:	e04a                	sd	s2,0(sp)
    80002522:	1000                	addi	s0,sp,32
    80002524:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002526:	01050913          	addi	s2,a0,16
    8000252a:	854a                	mv	a0,s2
    8000252c:	00001097          	auipc	ra,0x1
    80002530:	422080e7          	jalr	1058(ra) # 8000394e <holdingsleep>
    80002534:	c92d                	beqz	a0,800025a6 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002536:	854a                	mv	a0,s2
    80002538:	00001097          	auipc	ra,0x1
    8000253c:	3d2080e7          	jalr	978(ra) # 8000390a <releasesleep>

  acquire(&bcache.lock);
    80002540:	0000d517          	auipc	a0,0xd
    80002544:	b5850513          	addi	a0,a0,-1192 # 8000f098 <bcache>
    80002548:	00004097          	auipc	ra,0x4
    8000254c:	c9a080e7          	jalr	-870(ra) # 800061e2 <acquire>
  b->refcnt--;
    80002550:	40bc                	lw	a5,64(s1)
    80002552:	37fd                	addiw	a5,a5,-1
    80002554:	0007871b          	sext.w	a4,a5
    80002558:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000255a:	eb05                	bnez	a4,8000258a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000255c:	68bc                	ld	a5,80(s1)
    8000255e:	64b8                	ld	a4,72(s1)
    80002560:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002562:	64bc                	ld	a5,72(s1)
    80002564:	68b8                	ld	a4,80(s1)
    80002566:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002568:	00015797          	auipc	a5,0x15
    8000256c:	b3078793          	addi	a5,a5,-1232 # 80017098 <bcache+0x8000>
    80002570:	2b87b703          	ld	a4,696(a5)
    80002574:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002576:	00015717          	auipc	a4,0x15
    8000257a:	d8a70713          	addi	a4,a4,-630 # 80017300 <bcache+0x8268>
    8000257e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002580:	2b87b703          	ld	a4,696(a5)
    80002584:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002586:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000258a:	0000d517          	auipc	a0,0xd
    8000258e:	b0e50513          	addi	a0,a0,-1266 # 8000f098 <bcache>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	d04080e7          	jalr	-764(ra) # 80006296 <release>
}
    8000259a:	60e2                	ld	ra,24(sp)
    8000259c:	6442                	ld	s0,16(sp)
    8000259e:	64a2                	ld	s1,8(sp)
    800025a0:	6902                	ld	s2,0(sp)
    800025a2:	6105                	addi	sp,sp,32
    800025a4:	8082                	ret
    panic("brelse");
    800025a6:	00006517          	auipc	a0,0x6
    800025aa:	09250513          	addi	a0,a0,146 # 80008638 <syscall_names+0xe8>
    800025ae:	00003097          	auipc	ra,0x3
    800025b2:	6ea080e7          	jalr	1770(ra) # 80005c98 <panic>

00000000800025b6 <bpin>:

void
bpin(struct buf *b) {
    800025b6:	1101                	addi	sp,sp,-32
    800025b8:	ec06                	sd	ra,24(sp)
    800025ba:	e822                	sd	s0,16(sp)
    800025bc:	e426                	sd	s1,8(sp)
    800025be:	1000                	addi	s0,sp,32
    800025c0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025c2:	0000d517          	auipc	a0,0xd
    800025c6:	ad650513          	addi	a0,a0,-1322 # 8000f098 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	c18080e7          	jalr	-1000(ra) # 800061e2 <acquire>
  b->refcnt++;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	2785                	addiw	a5,a5,1
    800025d6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d8:	0000d517          	auipc	a0,0xd
    800025dc:	ac050513          	addi	a0,a0,-1344 # 8000f098 <bcache>
    800025e0:	00004097          	auipc	ra,0x4
    800025e4:	cb6080e7          	jalr	-842(ra) # 80006296 <release>
}
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret

00000000800025f2 <bunpin>:

void
bunpin(struct buf *b) {
    800025f2:	1101                	addi	sp,sp,-32
    800025f4:	ec06                	sd	ra,24(sp)
    800025f6:	e822                	sd	s0,16(sp)
    800025f8:	e426                	sd	s1,8(sp)
    800025fa:	1000                	addi	s0,sp,32
    800025fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025fe:	0000d517          	auipc	a0,0xd
    80002602:	a9a50513          	addi	a0,a0,-1382 # 8000f098 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	bdc080e7          	jalr	-1060(ra) # 800061e2 <acquire>
  b->refcnt--;
    8000260e:	40bc                	lw	a5,64(s1)
    80002610:	37fd                	addiw	a5,a5,-1
    80002612:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002614:	0000d517          	auipc	a0,0xd
    80002618:	a8450513          	addi	a0,a0,-1404 # 8000f098 <bcache>
    8000261c:	00004097          	auipc	ra,0x4
    80002620:	c7a080e7          	jalr	-902(ra) # 80006296 <release>
}
    80002624:	60e2                	ld	ra,24(sp)
    80002626:	6442                	ld	s0,16(sp)
    80002628:	64a2                	ld	s1,8(sp)
    8000262a:	6105                	addi	sp,sp,32
    8000262c:	8082                	ret

000000008000262e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000262e:	1101                	addi	sp,sp,-32
    80002630:	ec06                	sd	ra,24(sp)
    80002632:	e822                	sd	s0,16(sp)
    80002634:	e426                	sd	s1,8(sp)
    80002636:	e04a                	sd	s2,0(sp)
    80002638:	1000                	addi	s0,sp,32
    8000263a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000263c:	00d5d59b          	srliw	a1,a1,0xd
    80002640:	00015797          	auipc	a5,0x15
    80002644:	1347a783          	lw	a5,308(a5) # 80017774 <sb+0x1c>
    80002648:	9dbd                	addw	a1,a1,a5
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	d9e080e7          	jalr	-610(ra) # 800023e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002652:	0074f713          	andi	a4,s1,7
    80002656:	4785                	li	a5,1
    80002658:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000265c:	14ce                	slli	s1,s1,0x33
    8000265e:	90d9                	srli	s1,s1,0x36
    80002660:	00950733          	add	a4,a0,s1
    80002664:	05874703          	lbu	a4,88(a4)
    80002668:	00e7f6b3          	and	a3,a5,a4
    8000266c:	c69d                	beqz	a3,8000269a <bfree+0x6c>
    8000266e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002670:	94aa                	add	s1,s1,a0
    80002672:	fff7c793          	not	a5,a5
    80002676:	8ff9                	and	a5,a5,a4
    80002678:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000267c:	00001097          	auipc	ra,0x1
    80002680:	118080e7          	jalr	280(ra) # 80003794 <log_write>
  brelse(bp);
    80002684:	854a                	mv	a0,s2
    80002686:	00000097          	auipc	ra,0x0
    8000268a:	e92080e7          	jalr	-366(ra) # 80002518 <brelse>
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6902                	ld	s2,0(sp)
    80002696:	6105                	addi	sp,sp,32
    80002698:	8082                	ret
    panic("freeing free block");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	fa650513          	addi	a0,a0,-90 # 80008640 <syscall_names+0xf0>
    800026a2:	00003097          	auipc	ra,0x3
    800026a6:	5f6080e7          	jalr	1526(ra) # 80005c98 <panic>

00000000800026aa <balloc>:
{
    800026aa:	711d                	addi	sp,sp,-96
    800026ac:	ec86                	sd	ra,88(sp)
    800026ae:	e8a2                	sd	s0,80(sp)
    800026b0:	e4a6                	sd	s1,72(sp)
    800026b2:	e0ca                	sd	s2,64(sp)
    800026b4:	fc4e                	sd	s3,56(sp)
    800026b6:	f852                	sd	s4,48(sp)
    800026b8:	f456                	sd	s5,40(sp)
    800026ba:	f05a                	sd	s6,32(sp)
    800026bc:	ec5e                	sd	s7,24(sp)
    800026be:	e862                	sd	s8,16(sp)
    800026c0:	e466                	sd	s9,8(sp)
    800026c2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026c4:	00015797          	auipc	a5,0x15
    800026c8:	0987a783          	lw	a5,152(a5) # 8001775c <sb+0x4>
    800026cc:	cbd1                	beqz	a5,80002760 <balloc+0xb6>
    800026ce:	8baa                	mv	s7,a0
    800026d0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026d2:	00015b17          	auipc	s6,0x15
    800026d6:	086b0b13          	addi	s6,s6,134 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026dc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026de:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026e0:	6c89                	lui	s9,0x2
    800026e2:	a831                	j	800026fe <balloc+0x54>
    brelse(bp);
    800026e4:	854a                	mv	a0,s2
    800026e6:	00000097          	auipc	ra,0x0
    800026ea:	e32080e7          	jalr	-462(ra) # 80002518 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026ee:	015c87bb          	addw	a5,s9,s5
    800026f2:	00078a9b          	sext.w	s5,a5
    800026f6:	004b2703          	lw	a4,4(s6)
    800026fa:	06eaf363          	bgeu	s5,a4,80002760 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026fe:	41fad79b          	sraiw	a5,s5,0x1f
    80002702:	0137d79b          	srliw	a5,a5,0x13
    80002706:	015787bb          	addw	a5,a5,s5
    8000270a:	40d7d79b          	sraiw	a5,a5,0xd
    8000270e:	01cb2583          	lw	a1,28(s6)
    80002712:	9dbd                	addw	a1,a1,a5
    80002714:	855e                	mv	a0,s7
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	cd2080e7          	jalr	-814(ra) # 800023e8 <bread>
    8000271e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002720:	004b2503          	lw	a0,4(s6)
    80002724:	000a849b          	sext.w	s1,s5
    80002728:	8662                	mv	a2,s8
    8000272a:	faa4fde3          	bgeu	s1,a0,800026e4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000272e:	41f6579b          	sraiw	a5,a2,0x1f
    80002732:	01d7d69b          	srliw	a3,a5,0x1d
    80002736:	00c6873b          	addw	a4,a3,a2
    8000273a:	00777793          	andi	a5,a4,7
    8000273e:	9f95                	subw	a5,a5,a3
    80002740:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002744:	4037571b          	sraiw	a4,a4,0x3
    80002748:	00e906b3          	add	a3,s2,a4
    8000274c:	0586c683          	lbu	a3,88(a3)
    80002750:	00d7f5b3          	and	a1,a5,a3
    80002754:	cd91                	beqz	a1,80002770 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002756:	2605                	addiw	a2,a2,1
    80002758:	2485                	addiw	s1,s1,1
    8000275a:	fd4618e3          	bne	a2,s4,8000272a <balloc+0x80>
    8000275e:	b759                	j	800026e4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002760:	00006517          	auipc	a0,0x6
    80002764:	ef850513          	addi	a0,a0,-264 # 80008658 <syscall_names+0x108>
    80002768:	00003097          	auipc	ra,0x3
    8000276c:	530080e7          	jalr	1328(ra) # 80005c98 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002770:	974a                	add	a4,a4,s2
    80002772:	8fd5                	or	a5,a5,a3
    80002774:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002778:	854a                	mv	a0,s2
    8000277a:	00001097          	auipc	ra,0x1
    8000277e:	01a080e7          	jalr	26(ra) # 80003794 <log_write>
        brelse(bp);
    80002782:	854a                	mv	a0,s2
    80002784:	00000097          	auipc	ra,0x0
    80002788:	d94080e7          	jalr	-620(ra) # 80002518 <brelse>
  bp = bread(dev, bno);
    8000278c:	85a6                	mv	a1,s1
    8000278e:	855e                	mv	a0,s7
    80002790:	00000097          	auipc	ra,0x0
    80002794:	c58080e7          	jalr	-936(ra) # 800023e8 <bread>
    80002798:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000279a:	40000613          	li	a2,1024
    8000279e:	4581                	li	a1,0
    800027a0:	05850513          	addi	a0,a0,88
    800027a4:	ffffe097          	auipc	ra,0xffffe
    800027a8:	a1e080e7          	jalr	-1506(ra) # 800001c2 <memset>
  log_write(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00001097          	auipc	ra,0x1
    800027b2:	fe6080e7          	jalr	-26(ra) # 80003794 <log_write>
  brelse(bp);
    800027b6:	854a                	mv	a0,s2
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	d60080e7          	jalr	-672(ra) # 80002518 <brelse>
}
    800027c0:	8526                	mv	a0,s1
    800027c2:	60e6                	ld	ra,88(sp)
    800027c4:	6446                	ld	s0,80(sp)
    800027c6:	64a6                	ld	s1,72(sp)
    800027c8:	6906                	ld	s2,64(sp)
    800027ca:	79e2                	ld	s3,56(sp)
    800027cc:	7a42                	ld	s4,48(sp)
    800027ce:	7aa2                	ld	s5,40(sp)
    800027d0:	7b02                	ld	s6,32(sp)
    800027d2:	6be2                	ld	s7,24(sp)
    800027d4:	6c42                	ld	s8,16(sp)
    800027d6:	6ca2                	ld	s9,8(sp)
    800027d8:	6125                	addi	sp,sp,96
    800027da:	8082                	ret

00000000800027dc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027dc:	7179                	addi	sp,sp,-48
    800027de:	f406                	sd	ra,40(sp)
    800027e0:	f022                	sd	s0,32(sp)
    800027e2:	ec26                	sd	s1,24(sp)
    800027e4:	e84a                	sd	s2,16(sp)
    800027e6:	e44e                	sd	s3,8(sp)
    800027e8:	e052                	sd	s4,0(sp)
    800027ea:	1800                	addi	s0,sp,48
    800027ec:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027ee:	47ad                	li	a5,11
    800027f0:	04b7fe63          	bgeu	a5,a1,8000284c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027f4:	ff45849b          	addiw	s1,a1,-12
    800027f8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027fc:	0ff00793          	li	a5,255
    80002800:	0ae7e363          	bltu	a5,a4,800028a6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002804:	08052583          	lw	a1,128(a0)
    80002808:	c5ad                	beqz	a1,80002872 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000280a:	00092503          	lw	a0,0(s2)
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	bda080e7          	jalr	-1062(ra) # 800023e8 <bread>
    80002816:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002818:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000281c:	02049593          	slli	a1,s1,0x20
    80002820:	9181                	srli	a1,a1,0x20
    80002822:	058a                	slli	a1,a1,0x2
    80002824:	00b784b3          	add	s1,a5,a1
    80002828:	0004a983          	lw	s3,0(s1)
    8000282c:	04098d63          	beqz	s3,80002886 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002830:	8552                	mv	a0,s4
    80002832:	00000097          	auipc	ra,0x0
    80002836:	ce6080e7          	jalr	-794(ra) # 80002518 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000283a:	854e                	mv	a0,s3
    8000283c:	70a2                	ld	ra,40(sp)
    8000283e:	7402                	ld	s0,32(sp)
    80002840:	64e2                	ld	s1,24(sp)
    80002842:	6942                	ld	s2,16(sp)
    80002844:	69a2                	ld	s3,8(sp)
    80002846:	6a02                	ld	s4,0(sp)
    80002848:	6145                	addi	sp,sp,48
    8000284a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000284c:	02059493          	slli	s1,a1,0x20
    80002850:	9081                	srli	s1,s1,0x20
    80002852:	048a                	slli	s1,s1,0x2
    80002854:	94aa                	add	s1,s1,a0
    80002856:	0504a983          	lw	s3,80(s1)
    8000285a:	fe0990e3          	bnez	s3,8000283a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000285e:	4108                	lw	a0,0(a0)
    80002860:	00000097          	auipc	ra,0x0
    80002864:	e4a080e7          	jalr	-438(ra) # 800026aa <balloc>
    80002868:	0005099b          	sext.w	s3,a0
    8000286c:	0534a823          	sw	s3,80(s1)
    80002870:	b7e9                	j	8000283a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002872:	4108                	lw	a0,0(a0)
    80002874:	00000097          	auipc	ra,0x0
    80002878:	e36080e7          	jalr	-458(ra) # 800026aa <balloc>
    8000287c:	0005059b          	sext.w	a1,a0
    80002880:	08b92023          	sw	a1,128(s2)
    80002884:	b759                	j	8000280a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002886:	00092503          	lw	a0,0(s2)
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	e20080e7          	jalr	-480(ra) # 800026aa <balloc>
    80002892:	0005099b          	sext.w	s3,a0
    80002896:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000289a:	8552                	mv	a0,s4
    8000289c:	00001097          	auipc	ra,0x1
    800028a0:	ef8080e7          	jalr	-264(ra) # 80003794 <log_write>
    800028a4:	b771                	j	80002830 <bmap+0x54>
  panic("bmap: out of range");
    800028a6:	00006517          	auipc	a0,0x6
    800028aa:	dca50513          	addi	a0,a0,-566 # 80008670 <syscall_names+0x120>
    800028ae:	00003097          	auipc	ra,0x3
    800028b2:	3ea080e7          	jalr	1002(ra) # 80005c98 <panic>

00000000800028b6 <iget>:
{
    800028b6:	7179                	addi	sp,sp,-48
    800028b8:	f406                	sd	ra,40(sp)
    800028ba:	f022                	sd	s0,32(sp)
    800028bc:	ec26                	sd	s1,24(sp)
    800028be:	e84a                	sd	s2,16(sp)
    800028c0:	e44e                	sd	s3,8(sp)
    800028c2:	e052                	sd	s4,0(sp)
    800028c4:	1800                	addi	s0,sp,48
    800028c6:	89aa                	mv	s3,a0
    800028c8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028ca:	00015517          	auipc	a0,0x15
    800028ce:	eae50513          	addi	a0,a0,-338 # 80017778 <itable>
    800028d2:	00004097          	auipc	ra,0x4
    800028d6:	910080e7          	jalr	-1776(ra) # 800061e2 <acquire>
  empty = 0;
    800028da:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028dc:	00015497          	auipc	s1,0x15
    800028e0:	eb448493          	addi	s1,s1,-332 # 80017790 <itable+0x18>
    800028e4:	00017697          	auipc	a3,0x17
    800028e8:	93c68693          	addi	a3,a3,-1732 # 80019220 <log>
    800028ec:	a039                	j	800028fa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ee:	02090b63          	beqz	s2,80002924 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f2:	08848493          	addi	s1,s1,136
    800028f6:	02d48a63          	beq	s1,a3,8000292a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028fa:	449c                	lw	a5,8(s1)
    800028fc:	fef059e3          	blez	a5,800028ee <iget+0x38>
    80002900:	4098                	lw	a4,0(s1)
    80002902:	ff3716e3          	bne	a4,s3,800028ee <iget+0x38>
    80002906:	40d8                	lw	a4,4(s1)
    80002908:	ff4713e3          	bne	a4,s4,800028ee <iget+0x38>
      ip->ref++;
    8000290c:	2785                	addiw	a5,a5,1
    8000290e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002910:	00015517          	auipc	a0,0x15
    80002914:	e6850513          	addi	a0,a0,-408 # 80017778 <itable>
    80002918:	00004097          	auipc	ra,0x4
    8000291c:	97e080e7          	jalr	-1666(ra) # 80006296 <release>
      return ip;
    80002920:	8926                	mv	s2,s1
    80002922:	a03d                	j	80002950 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002924:	f7f9                	bnez	a5,800028f2 <iget+0x3c>
    80002926:	8926                	mv	s2,s1
    80002928:	b7e9                	j	800028f2 <iget+0x3c>
  if(empty == 0)
    8000292a:	02090c63          	beqz	s2,80002962 <iget+0xac>
  ip->dev = dev;
    8000292e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002932:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002936:	4785                	li	a5,1
    80002938:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000293c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002940:	00015517          	auipc	a0,0x15
    80002944:	e3850513          	addi	a0,a0,-456 # 80017778 <itable>
    80002948:	00004097          	auipc	ra,0x4
    8000294c:	94e080e7          	jalr	-1714(ra) # 80006296 <release>
}
    80002950:	854a                	mv	a0,s2
    80002952:	70a2                	ld	ra,40(sp)
    80002954:	7402                	ld	s0,32(sp)
    80002956:	64e2                	ld	s1,24(sp)
    80002958:	6942                	ld	s2,16(sp)
    8000295a:	69a2                	ld	s3,8(sp)
    8000295c:	6a02                	ld	s4,0(sp)
    8000295e:	6145                	addi	sp,sp,48
    80002960:	8082                	ret
    panic("iget: no inodes");
    80002962:	00006517          	auipc	a0,0x6
    80002966:	d2650513          	addi	a0,a0,-730 # 80008688 <syscall_names+0x138>
    8000296a:	00003097          	auipc	ra,0x3
    8000296e:	32e080e7          	jalr	814(ra) # 80005c98 <panic>

0000000080002972 <fsinit>:
fsinit(int dev) {
    80002972:	7179                	addi	sp,sp,-48
    80002974:	f406                	sd	ra,40(sp)
    80002976:	f022                	sd	s0,32(sp)
    80002978:	ec26                	sd	s1,24(sp)
    8000297a:	e84a                	sd	s2,16(sp)
    8000297c:	e44e                	sd	s3,8(sp)
    8000297e:	1800                	addi	s0,sp,48
    80002980:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002982:	4585                	li	a1,1
    80002984:	00000097          	auipc	ra,0x0
    80002988:	a64080e7          	jalr	-1436(ra) # 800023e8 <bread>
    8000298c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000298e:	00015997          	auipc	s3,0x15
    80002992:	dca98993          	addi	s3,s3,-566 # 80017758 <sb>
    80002996:	02000613          	li	a2,32
    8000299a:	05850593          	addi	a1,a0,88
    8000299e:	854e                	mv	a0,s3
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	882080e7          	jalr	-1918(ra) # 80000222 <memmove>
  brelse(bp);
    800029a8:	8526                	mv	a0,s1
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	b6e080e7          	jalr	-1170(ra) # 80002518 <brelse>
  if(sb.magic != FSMAGIC)
    800029b2:	0009a703          	lw	a4,0(s3)
    800029b6:	102037b7          	lui	a5,0x10203
    800029ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029be:	02f71263          	bne	a4,a5,800029e2 <fsinit+0x70>
  initlog(dev, &sb);
    800029c2:	00015597          	auipc	a1,0x15
    800029c6:	d9658593          	addi	a1,a1,-618 # 80017758 <sb>
    800029ca:	854a                	mv	a0,s2
    800029cc:	00001097          	auipc	ra,0x1
    800029d0:	b4c080e7          	jalr	-1204(ra) # 80003518 <initlog>
}
    800029d4:	70a2                	ld	ra,40(sp)
    800029d6:	7402                	ld	s0,32(sp)
    800029d8:	64e2                	ld	s1,24(sp)
    800029da:	6942                	ld	s2,16(sp)
    800029dc:	69a2                	ld	s3,8(sp)
    800029de:	6145                	addi	sp,sp,48
    800029e0:	8082                	ret
    panic("invalid file system");
    800029e2:	00006517          	auipc	a0,0x6
    800029e6:	cb650513          	addi	a0,a0,-842 # 80008698 <syscall_names+0x148>
    800029ea:	00003097          	auipc	ra,0x3
    800029ee:	2ae080e7          	jalr	686(ra) # 80005c98 <panic>

00000000800029f2 <iinit>:
{
    800029f2:	7179                	addi	sp,sp,-48
    800029f4:	f406                	sd	ra,40(sp)
    800029f6:	f022                	sd	s0,32(sp)
    800029f8:	ec26                	sd	s1,24(sp)
    800029fa:	e84a                	sd	s2,16(sp)
    800029fc:	e44e                	sd	s3,8(sp)
    800029fe:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a00:	00006597          	auipc	a1,0x6
    80002a04:	cb058593          	addi	a1,a1,-848 # 800086b0 <syscall_names+0x160>
    80002a08:	00015517          	auipc	a0,0x15
    80002a0c:	d7050513          	addi	a0,a0,-656 # 80017778 <itable>
    80002a10:	00003097          	auipc	ra,0x3
    80002a14:	742080e7          	jalr	1858(ra) # 80006152 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a18:	00015497          	auipc	s1,0x15
    80002a1c:	d8848493          	addi	s1,s1,-632 # 800177a0 <itable+0x28>
    80002a20:	00017997          	auipc	s3,0x17
    80002a24:	81098993          	addi	s3,s3,-2032 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a28:	00006917          	auipc	s2,0x6
    80002a2c:	c9090913          	addi	s2,s2,-880 # 800086b8 <syscall_names+0x168>
    80002a30:	85ca                	mv	a1,s2
    80002a32:	8526                	mv	a0,s1
    80002a34:	00001097          	auipc	ra,0x1
    80002a38:	e46080e7          	jalr	-442(ra) # 8000387a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a3c:	08848493          	addi	s1,s1,136
    80002a40:	ff3498e3          	bne	s1,s3,80002a30 <iinit+0x3e>
}
    80002a44:	70a2                	ld	ra,40(sp)
    80002a46:	7402                	ld	s0,32(sp)
    80002a48:	64e2                	ld	s1,24(sp)
    80002a4a:	6942                	ld	s2,16(sp)
    80002a4c:	69a2                	ld	s3,8(sp)
    80002a4e:	6145                	addi	sp,sp,48
    80002a50:	8082                	ret

0000000080002a52 <ialloc>:
{
    80002a52:	715d                	addi	sp,sp,-80
    80002a54:	e486                	sd	ra,72(sp)
    80002a56:	e0a2                	sd	s0,64(sp)
    80002a58:	fc26                	sd	s1,56(sp)
    80002a5a:	f84a                	sd	s2,48(sp)
    80002a5c:	f44e                	sd	s3,40(sp)
    80002a5e:	f052                	sd	s4,32(sp)
    80002a60:	ec56                	sd	s5,24(sp)
    80002a62:	e85a                	sd	s6,16(sp)
    80002a64:	e45e                	sd	s7,8(sp)
    80002a66:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a68:	00015717          	auipc	a4,0x15
    80002a6c:	cfc72703          	lw	a4,-772(a4) # 80017764 <sb+0xc>
    80002a70:	4785                	li	a5,1
    80002a72:	04e7fa63          	bgeu	a5,a4,80002ac6 <ialloc+0x74>
    80002a76:	8aaa                	mv	s5,a0
    80002a78:	8bae                	mv	s7,a1
    80002a7a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a7c:	00015a17          	auipc	s4,0x15
    80002a80:	cdca0a13          	addi	s4,s4,-804 # 80017758 <sb>
    80002a84:	00048b1b          	sext.w	s6,s1
    80002a88:	0044d593          	srli	a1,s1,0x4
    80002a8c:	018a2783          	lw	a5,24(s4)
    80002a90:	9dbd                	addw	a1,a1,a5
    80002a92:	8556                	mv	a0,s5
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	954080e7          	jalr	-1708(ra) # 800023e8 <bread>
    80002a9c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a9e:	05850993          	addi	s3,a0,88
    80002aa2:	00f4f793          	andi	a5,s1,15
    80002aa6:	079a                	slli	a5,a5,0x6
    80002aa8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aaa:	00099783          	lh	a5,0(s3)
    80002aae:	c785                	beqz	a5,80002ad6 <ialloc+0x84>
    brelse(bp);
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	a68080e7          	jalr	-1432(ra) # 80002518 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ab8:	0485                	addi	s1,s1,1
    80002aba:	00ca2703          	lw	a4,12(s4)
    80002abe:	0004879b          	sext.w	a5,s1
    80002ac2:	fce7e1e3          	bltu	a5,a4,80002a84 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ac6:	00006517          	auipc	a0,0x6
    80002aca:	bfa50513          	addi	a0,a0,-1030 # 800086c0 <syscall_names+0x170>
    80002ace:	00003097          	auipc	ra,0x3
    80002ad2:	1ca080e7          	jalr	458(ra) # 80005c98 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ad6:	04000613          	li	a2,64
    80002ada:	4581                	li	a1,0
    80002adc:	854e                	mv	a0,s3
    80002ade:	ffffd097          	auipc	ra,0xffffd
    80002ae2:	6e4080e7          	jalr	1764(ra) # 800001c2 <memset>
      dip->type = type;
    80002ae6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	ca8080e7          	jalr	-856(ra) # 80003794 <log_write>
      brelse(bp);
    80002af4:	854a                	mv	a0,s2
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	a22080e7          	jalr	-1502(ra) # 80002518 <brelse>
      return iget(dev, inum);
    80002afe:	85da                	mv	a1,s6
    80002b00:	8556                	mv	a0,s5
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	db4080e7          	jalr	-588(ra) # 800028b6 <iget>
}
    80002b0a:	60a6                	ld	ra,72(sp)
    80002b0c:	6406                	ld	s0,64(sp)
    80002b0e:	74e2                	ld	s1,56(sp)
    80002b10:	7942                	ld	s2,48(sp)
    80002b12:	79a2                	ld	s3,40(sp)
    80002b14:	7a02                	ld	s4,32(sp)
    80002b16:	6ae2                	ld	s5,24(sp)
    80002b18:	6b42                	ld	s6,16(sp)
    80002b1a:	6ba2                	ld	s7,8(sp)
    80002b1c:	6161                	addi	sp,sp,80
    80002b1e:	8082                	ret

0000000080002b20 <iupdate>:
{
    80002b20:	1101                	addi	sp,sp,-32
    80002b22:	ec06                	sd	ra,24(sp)
    80002b24:	e822                	sd	s0,16(sp)
    80002b26:	e426                	sd	s1,8(sp)
    80002b28:	e04a                	sd	s2,0(sp)
    80002b2a:	1000                	addi	s0,sp,32
    80002b2c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b2e:	415c                	lw	a5,4(a0)
    80002b30:	0047d79b          	srliw	a5,a5,0x4
    80002b34:	00015597          	auipc	a1,0x15
    80002b38:	c3c5a583          	lw	a1,-964(a1) # 80017770 <sb+0x18>
    80002b3c:	9dbd                	addw	a1,a1,a5
    80002b3e:	4108                	lw	a0,0(a0)
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	8a8080e7          	jalr	-1880(ra) # 800023e8 <bread>
    80002b48:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b4a:	05850793          	addi	a5,a0,88
    80002b4e:	40c8                	lw	a0,4(s1)
    80002b50:	893d                	andi	a0,a0,15
    80002b52:	051a                	slli	a0,a0,0x6
    80002b54:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b56:	04449703          	lh	a4,68(s1)
    80002b5a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b5e:	04649703          	lh	a4,70(s1)
    80002b62:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b66:	04849703          	lh	a4,72(s1)
    80002b6a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b6e:	04a49703          	lh	a4,74(s1)
    80002b72:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b76:	44f8                	lw	a4,76(s1)
    80002b78:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b7a:	03400613          	li	a2,52
    80002b7e:	05048593          	addi	a1,s1,80
    80002b82:	0531                	addi	a0,a0,12
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	69e080e7          	jalr	1694(ra) # 80000222 <memmove>
  log_write(bp);
    80002b8c:	854a                	mv	a0,s2
    80002b8e:	00001097          	auipc	ra,0x1
    80002b92:	c06080e7          	jalr	-1018(ra) # 80003794 <log_write>
  brelse(bp);
    80002b96:	854a                	mv	a0,s2
    80002b98:	00000097          	auipc	ra,0x0
    80002b9c:	980080e7          	jalr	-1664(ra) # 80002518 <brelse>
}
    80002ba0:	60e2                	ld	ra,24(sp)
    80002ba2:	6442                	ld	s0,16(sp)
    80002ba4:	64a2                	ld	s1,8(sp)
    80002ba6:	6902                	ld	s2,0(sp)
    80002ba8:	6105                	addi	sp,sp,32
    80002baa:	8082                	ret

0000000080002bac <idup>:
{
    80002bac:	1101                	addi	sp,sp,-32
    80002bae:	ec06                	sd	ra,24(sp)
    80002bb0:	e822                	sd	s0,16(sp)
    80002bb2:	e426                	sd	s1,8(sp)
    80002bb4:	1000                	addi	s0,sp,32
    80002bb6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bb8:	00015517          	auipc	a0,0x15
    80002bbc:	bc050513          	addi	a0,a0,-1088 # 80017778 <itable>
    80002bc0:	00003097          	auipc	ra,0x3
    80002bc4:	622080e7          	jalr	1570(ra) # 800061e2 <acquire>
  ip->ref++;
    80002bc8:	449c                	lw	a5,8(s1)
    80002bca:	2785                	addiw	a5,a5,1
    80002bcc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bce:	00015517          	auipc	a0,0x15
    80002bd2:	baa50513          	addi	a0,a0,-1110 # 80017778 <itable>
    80002bd6:	00003097          	auipc	ra,0x3
    80002bda:	6c0080e7          	jalr	1728(ra) # 80006296 <release>
}
    80002bde:	8526                	mv	a0,s1
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6105                	addi	sp,sp,32
    80002be8:	8082                	ret

0000000080002bea <ilock>:
{
    80002bea:	1101                	addi	sp,sp,-32
    80002bec:	ec06                	sd	ra,24(sp)
    80002bee:	e822                	sd	s0,16(sp)
    80002bf0:	e426                	sd	s1,8(sp)
    80002bf2:	e04a                	sd	s2,0(sp)
    80002bf4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bf6:	c115                	beqz	a0,80002c1a <ilock+0x30>
    80002bf8:	84aa                	mv	s1,a0
    80002bfa:	451c                	lw	a5,8(a0)
    80002bfc:	00f05f63          	blez	a5,80002c1a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c00:	0541                	addi	a0,a0,16
    80002c02:	00001097          	auipc	ra,0x1
    80002c06:	cb2080e7          	jalr	-846(ra) # 800038b4 <acquiresleep>
  if(ip->valid == 0){
    80002c0a:	40bc                	lw	a5,64(s1)
    80002c0c:	cf99                	beqz	a5,80002c2a <ilock+0x40>
}
    80002c0e:	60e2                	ld	ra,24(sp)
    80002c10:	6442                	ld	s0,16(sp)
    80002c12:	64a2                	ld	s1,8(sp)
    80002c14:	6902                	ld	s2,0(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret
    panic("ilock");
    80002c1a:	00006517          	auipc	a0,0x6
    80002c1e:	abe50513          	addi	a0,a0,-1346 # 800086d8 <syscall_names+0x188>
    80002c22:	00003097          	auipc	ra,0x3
    80002c26:	076080e7          	jalr	118(ra) # 80005c98 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c2a:	40dc                	lw	a5,4(s1)
    80002c2c:	0047d79b          	srliw	a5,a5,0x4
    80002c30:	00015597          	auipc	a1,0x15
    80002c34:	b405a583          	lw	a1,-1216(a1) # 80017770 <sb+0x18>
    80002c38:	9dbd                	addw	a1,a1,a5
    80002c3a:	4088                	lw	a0,0(s1)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	7ac080e7          	jalr	1964(ra) # 800023e8 <bread>
    80002c44:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c46:	05850593          	addi	a1,a0,88
    80002c4a:	40dc                	lw	a5,4(s1)
    80002c4c:	8bbd                	andi	a5,a5,15
    80002c4e:	079a                	slli	a5,a5,0x6
    80002c50:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c52:	00059783          	lh	a5,0(a1)
    80002c56:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c5a:	00259783          	lh	a5,2(a1)
    80002c5e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c62:	00459783          	lh	a5,4(a1)
    80002c66:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c6a:	00659783          	lh	a5,6(a1)
    80002c6e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c72:	459c                	lw	a5,8(a1)
    80002c74:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c76:	03400613          	li	a2,52
    80002c7a:	05b1                	addi	a1,a1,12
    80002c7c:	05048513          	addi	a0,s1,80
    80002c80:	ffffd097          	auipc	ra,0xffffd
    80002c84:	5a2080e7          	jalr	1442(ra) # 80000222 <memmove>
    brelse(bp);
    80002c88:	854a                	mv	a0,s2
    80002c8a:	00000097          	auipc	ra,0x0
    80002c8e:	88e080e7          	jalr	-1906(ra) # 80002518 <brelse>
    ip->valid = 1;
    80002c92:	4785                	li	a5,1
    80002c94:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c96:	04449783          	lh	a5,68(s1)
    80002c9a:	fbb5                	bnez	a5,80002c0e <ilock+0x24>
      panic("ilock: no type");
    80002c9c:	00006517          	auipc	a0,0x6
    80002ca0:	a4450513          	addi	a0,a0,-1468 # 800086e0 <syscall_names+0x190>
    80002ca4:	00003097          	auipc	ra,0x3
    80002ca8:	ff4080e7          	jalr	-12(ra) # 80005c98 <panic>

0000000080002cac <iunlock>:
{
    80002cac:	1101                	addi	sp,sp,-32
    80002cae:	ec06                	sd	ra,24(sp)
    80002cb0:	e822                	sd	s0,16(sp)
    80002cb2:	e426                	sd	s1,8(sp)
    80002cb4:	e04a                	sd	s2,0(sp)
    80002cb6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cb8:	c905                	beqz	a0,80002ce8 <iunlock+0x3c>
    80002cba:	84aa                	mv	s1,a0
    80002cbc:	01050913          	addi	s2,a0,16
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00001097          	auipc	ra,0x1
    80002cc6:	c8c080e7          	jalr	-884(ra) # 8000394e <holdingsleep>
    80002cca:	cd19                	beqz	a0,80002ce8 <iunlock+0x3c>
    80002ccc:	449c                	lw	a5,8(s1)
    80002cce:	00f05d63          	blez	a5,80002ce8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cd2:	854a                	mv	a0,s2
    80002cd4:	00001097          	auipc	ra,0x1
    80002cd8:	c36080e7          	jalr	-970(ra) # 8000390a <releasesleep>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	64a2                	ld	s1,8(sp)
    80002ce2:	6902                	ld	s2,0(sp)
    80002ce4:	6105                	addi	sp,sp,32
    80002ce6:	8082                	ret
    panic("iunlock");
    80002ce8:	00006517          	auipc	a0,0x6
    80002cec:	a0850513          	addi	a0,a0,-1528 # 800086f0 <syscall_names+0x1a0>
    80002cf0:	00003097          	auipc	ra,0x3
    80002cf4:	fa8080e7          	jalr	-88(ra) # 80005c98 <panic>

0000000080002cf8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cf8:	7179                	addi	sp,sp,-48
    80002cfa:	f406                	sd	ra,40(sp)
    80002cfc:	f022                	sd	s0,32(sp)
    80002cfe:	ec26                	sd	s1,24(sp)
    80002d00:	e84a                	sd	s2,16(sp)
    80002d02:	e44e                	sd	s3,8(sp)
    80002d04:	e052                	sd	s4,0(sp)
    80002d06:	1800                	addi	s0,sp,48
    80002d08:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d0a:	05050493          	addi	s1,a0,80
    80002d0e:	08050913          	addi	s2,a0,128
    80002d12:	a021                	j	80002d1a <itrunc+0x22>
    80002d14:	0491                	addi	s1,s1,4
    80002d16:	01248d63          	beq	s1,s2,80002d30 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d1a:	408c                	lw	a1,0(s1)
    80002d1c:	dde5                	beqz	a1,80002d14 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d1e:	0009a503          	lw	a0,0(s3)
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	90c080e7          	jalr	-1780(ra) # 8000262e <bfree>
      ip->addrs[i] = 0;
    80002d2a:	0004a023          	sw	zero,0(s1)
    80002d2e:	b7dd                	j	80002d14 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d30:	0809a583          	lw	a1,128(s3)
    80002d34:	e185                	bnez	a1,80002d54 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d36:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d3a:	854e                	mv	a0,s3
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	de4080e7          	jalr	-540(ra) # 80002b20 <iupdate>
}
    80002d44:	70a2                	ld	ra,40(sp)
    80002d46:	7402                	ld	s0,32(sp)
    80002d48:	64e2                	ld	s1,24(sp)
    80002d4a:	6942                	ld	s2,16(sp)
    80002d4c:	69a2                	ld	s3,8(sp)
    80002d4e:	6a02                	ld	s4,0(sp)
    80002d50:	6145                	addi	sp,sp,48
    80002d52:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d54:	0009a503          	lw	a0,0(s3)
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	690080e7          	jalr	1680(ra) # 800023e8 <bread>
    80002d60:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d62:	05850493          	addi	s1,a0,88
    80002d66:	45850913          	addi	s2,a0,1112
    80002d6a:	a811                	j	80002d7e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	8be080e7          	jalr	-1858(ra) # 8000262e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d78:	0491                	addi	s1,s1,4
    80002d7a:	01248563          	beq	s1,s2,80002d84 <itrunc+0x8c>
      if(a[j])
    80002d7e:	408c                	lw	a1,0(s1)
    80002d80:	dde5                	beqz	a1,80002d78 <itrunc+0x80>
    80002d82:	b7ed                	j	80002d6c <itrunc+0x74>
    brelse(bp);
    80002d84:	8552                	mv	a0,s4
    80002d86:	fffff097          	auipc	ra,0xfffff
    80002d8a:	792080e7          	jalr	1938(ra) # 80002518 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d8e:	0809a583          	lw	a1,128(s3)
    80002d92:	0009a503          	lw	a0,0(s3)
    80002d96:	00000097          	auipc	ra,0x0
    80002d9a:	898080e7          	jalr	-1896(ra) # 8000262e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d9e:	0809a023          	sw	zero,128(s3)
    80002da2:	bf51                	j	80002d36 <itrunc+0x3e>

0000000080002da4 <iput>:
{
    80002da4:	1101                	addi	sp,sp,-32
    80002da6:	ec06                	sd	ra,24(sp)
    80002da8:	e822                	sd	s0,16(sp)
    80002daa:	e426                	sd	s1,8(sp)
    80002dac:	e04a                	sd	s2,0(sp)
    80002dae:	1000                	addi	s0,sp,32
    80002db0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002db2:	00015517          	auipc	a0,0x15
    80002db6:	9c650513          	addi	a0,a0,-1594 # 80017778 <itable>
    80002dba:	00003097          	auipc	ra,0x3
    80002dbe:	428080e7          	jalr	1064(ra) # 800061e2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc2:	4498                	lw	a4,8(s1)
    80002dc4:	4785                	li	a5,1
    80002dc6:	02f70363          	beq	a4,a5,80002dec <iput+0x48>
  ip->ref--;
    80002dca:	449c                	lw	a5,8(s1)
    80002dcc:	37fd                	addiw	a5,a5,-1
    80002dce:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dd0:	00015517          	auipc	a0,0x15
    80002dd4:	9a850513          	addi	a0,a0,-1624 # 80017778 <itable>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	4be080e7          	jalr	1214(ra) # 80006296 <release>
}
    80002de0:	60e2                	ld	ra,24(sp)
    80002de2:	6442                	ld	s0,16(sp)
    80002de4:	64a2                	ld	s1,8(sp)
    80002de6:	6902                	ld	s2,0(sp)
    80002de8:	6105                	addi	sp,sp,32
    80002dea:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dec:	40bc                	lw	a5,64(s1)
    80002dee:	dff1                	beqz	a5,80002dca <iput+0x26>
    80002df0:	04a49783          	lh	a5,74(s1)
    80002df4:	fbf9                	bnez	a5,80002dca <iput+0x26>
    acquiresleep(&ip->lock);
    80002df6:	01048913          	addi	s2,s1,16
    80002dfa:	854a                	mv	a0,s2
    80002dfc:	00001097          	auipc	ra,0x1
    80002e00:	ab8080e7          	jalr	-1352(ra) # 800038b4 <acquiresleep>
    release(&itable.lock);
    80002e04:	00015517          	auipc	a0,0x15
    80002e08:	97450513          	addi	a0,a0,-1676 # 80017778 <itable>
    80002e0c:	00003097          	auipc	ra,0x3
    80002e10:	48a080e7          	jalr	1162(ra) # 80006296 <release>
    itrunc(ip);
    80002e14:	8526                	mv	a0,s1
    80002e16:	00000097          	auipc	ra,0x0
    80002e1a:	ee2080e7          	jalr	-286(ra) # 80002cf8 <itrunc>
    ip->type = 0;
    80002e1e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e22:	8526                	mv	a0,s1
    80002e24:	00000097          	auipc	ra,0x0
    80002e28:	cfc080e7          	jalr	-772(ra) # 80002b20 <iupdate>
    ip->valid = 0;
    80002e2c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e30:	854a                	mv	a0,s2
    80002e32:	00001097          	auipc	ra,0x1
    80002e36:	ad8080e7          	jalr	-1320(ra) # 8000390a <releasesleep>
    acquire(&itable.lock);
    80002e3a:	00015517          	auipc	a0,0x15
    80002e3e:	93e50513          	addi	a0,a0,-1730 # 80017778 <itable>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	3a0080e7          	jalr	928(ra) # 800061e2 <acquire>
    80002e4a:	b741                	j	80002dca <iput+0x26>

0000000080002e4c <iunlockput>:
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	e426                	sd	s1,8(sp)
    80002e54:	1000                	addi	s0,sp,32
    80002e56:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	e54080e7          	jalr	-428(ra) # 80002cac <iunlock>
  iput(ip);
    80002e60:	8526                	mv	a0,s1
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	f42080e7          	jalr	-190(ra) # 80002da4 <iput>
}
    80002e6a:	60e2                	ld	ra,24(sp)
    80002e6c:	6442                	ld	s0,16(sp)
    80002e6e:	64a2                	ld	s1,8(sp)
    80002e70:	6105                	addi	sp,sp,32
    80002e72:	8082                	ret

0000000080002e74 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e74:	1141                	addi	sp,sp,-16
    80002e76:	e422                	sd	s0,8(sp)
    80002e78:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e7a:	411c                	lw	a5,0(a0)
    80002e7c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e7e:	415c                	lw	a5,4(a0)
    80002e80:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e82:	04451783          	lh	a5,68(a0)
    80002e86:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e8a:	04a51783          	lh	a5,74(a0)
    80002e8e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e92:	04c56783          	lwu	a5,76(a0)
    80002e96:	e99c                	sd	a5,16(a1)
}
    80002e98:	6422                	ld	s0,8(sp)
    80002e9a:	0141                	addi	sp,sp,16
    80002e9c:	8082                	ret

0000000080002e9e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e9e:	457c                	lw	a5,76(a0)
    80002ea0:	0ed7e963          	bltu	a5,a3,80002f92 <readi+0xf4>
{
    80002ea4:	7159                	addi	sp,sp,-112
    80002ea6:	f486                	sd	ra,104(sp)
    80002ea8:	f0a2                	sd	s0,96(sp)
    80002eaa:	eca6                	sd	s1,88(sp)
    80002eac:	e8ca                	sd	s2,80(sp)
    80002eae:	e4ce                	sd	s3,72(sp)
    80002eb0:	e0d2                	sd	s4,64(sp)
    80002eb2:	fc56                	sd	s5,56(sp)
    80002eb4:	f85a                	sd	s6,48(sp)
    80002eb6:	f45e                	sd	s7,40(sp)
    80002eb8:	f062                	sd	s8,32(sp)
    80002eba:	ec66                	sd	s9,24(sp)
    80002ebc:	e86a                	sd	s10,16(sp)
    80002ebe:	e46e                	sd	s11,8(sp)
    80002ec0:	1880                	addi	s0,sp,112
    80002ec2:	8baa                	mv	s7,a0
    80002ec4:	8c2e                	mv	s8,a1
    80002ec6:	8ab2                	mv	s5,a2
    80002ec8:	84b6                	mv	s1,a3
    80002eca:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ecc:	9f35                	addw	a4,a4,a3
    return 0;
    80002ece:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ed0:	0ad76063          	bltu	a4,a3,80002f70 <readi+0xd2>
  if(off + n > ip->size)
    80002ed4:	00e7f463          	bgeu	a5,a4,80002edc <readi+0x3e>
    n = ip->size - off;
    80002ed8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002edc:	0a0b0963          	beqz	s6,80002f8e <readi+0xf0>
    80002ee0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ee6:	5cfd                	li	s9,-1
    80002ee8:	a82d                	j	80002f22 <readi+0x84>
    80002eea:	020a1d93          	slli	s11,s4,0x20
    80002eee:	020ddd93          	srli	s11,s11,0x20
    80002ef2:	05890613          	addi	a2,s2,88
    80002ef6:	86ee                	mv	a3,s11
    80002ef8:	963a                	add	a2,a2,a4
    80002efa:	85d6                	mv	a1,s5
    80002efc:	8562                	mv	a0,s8
    80002efe:	fffff097          	auipc	ra,0xfffff
    80002f02:	a00080e7          	jalr	-1536(ra) # 800018fe <either_copyout>
    80002f06:	05950d63          	beq	a0,s9,80002f60 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f0a:	854a                	mv	a0,s2
    80002f0c:	fffff097          	auipc	ra,0xfffff
    80002f10:	60c080e7          	jalr	1548(ra) # 80002518 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f14:	013a09bb          	addw	s3,s4,s3
    80002f18:	009a04bb          	addw	s1,s4,s1
    80002f1c:	9aee                	add	s5,s5,s11
    80002f1e:	0569f763          	bgeu	s3,s6,80002f6c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f22:	000ba903          	lw	s2,0(s7)
    80002f26:	00a4d59b          	srliw	a1,s1,0xa
    80002f2a:	855e                	mv	a0,s7
    80002f2c:	00000097          	auipc	ra,0x0
    80002f30:	8b0080e7          	jalr	-1872(ra) # 800027dc <bmap>
    80002f34:	0005059b          	sext.w	a1,a0
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	4ae080e7          	jalr	1198(ra) # 800023e8 <bread>
    80002f42:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f44:	3ff4f713          	andi	a4,s1,1023
    80002f48:	40ed07bb          	subw	a5,s10,a4
    80002f4c:	413b06bb          	subw	a3,s6,s3
    80002f50:	8a3e                	mv	s4,a5
    80002f52:	2781                	sext.w	a5,a5
    80002f54:	0006861b          	sext.w	a2,a3
    80002f58:	f8f679e3          	bgeu	a2,a5,80002eea <readi+0x4c>
    80002f5c:	8a36                	mv	s4,a3
    80002f5e:	b771                	j	80002eea <readi+0x4c>
      brelse(bp);
    80002f60:	854a                	mv	a0,s2
    80002f62:	fffff097          	auipc	ra,0xfffff
    80002f66:	5b6080e7          	jalr	1462(ra) # 80002518 <brelse>
      tot = -1;
    80002f6a:	59fd                	li	s3,-1
  }
  return tot;
    80002f6c:	0009851b          	sext.w	a0,s3
}
    80002f70:	70a6                	ld	ra,104(sp)
    80002f72:	7406                	ld	s0,96(sp)
    80002f74:	64e6                	ld	s1,88(sp)
    80002f76:	6946                	ld	s2,80(sp)
    80002f78:	69a6                	ld	s3,72(sp)
    80002f7a:	6a06                	ld	s4,64(sp)
    80002f7c:	7ae2                	ld	s5,56(sp)
    80002f7e:	7b42                	ld	s6,48(sp)
    80002f80:	7ba2                	ld	s7,40(sp)
    80002f82:	7c02                	ld	s8,32(sp)
    80002f84:	6ce2                	ld	s9,24(sp)
    80002f86:	6d42                	ld	s10,16(sp)
    80002f88:	6da2                	ld	s11,8(sp)
    80002f8a:	6165                	addi	sp,sp,112
    80002f8c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f8e:	89da                	mv	s3,s6
    80002f90:	bff1                	j	80002f6c <readi+0xce>
    return 0;
    80002f92:	4501                	li	a0,0
}
    80002f94:	8082                	ret

0000000080002f96 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f96:	457c                	lw	a5,76(a0)
    80002f98:	10d7e863          	bltu	a5,a3,800030a8 <writei+0x112>
{
    80002f9c:	7159                	addi	sp,sp,-112
    80002f9e:	f486                	sd	ra,104(sp)
    80002fa0:	f0a2                	sd	s0,96(sp)
    80002fa2:	eca6                	sd	s1,88(sp)
    80002fa4:	e8ca                	sd	s2,80(sp)
    80002fa6:	e4ce                	sd	s3,72(sp)
    80002fa8:	e0d2                	sd	s4,64(sp)
    80002faa:	fc56                	sd	s5,56(sp)
    80002fac:	f85a                	sd	s6,48(sp)
    80002fae:	f45e                	sd	s7,40(sp)
    80002fb0:	f062                	sd	s8,32(sp)
    80002fb2:	ec66                	sd	s9,24(sp)
    80002fb4:	e86a                	sd	s10,16(sp)
    80002fb6:	e46e                	sd	s11,8(sp)
    80002fb8:	1880                	addi	s0,sp,112
    80002fba:	8b2a                	mv	s6,a0
    80002fbc:	8c2e                	mv	s8,a1
    80002fbe:	8ab2                	mv	s5,a2
    80002fc0:	8936                	mv	s2,a3
    80002fc2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fc4:	00e687bb          	addw	a5,a3,a4
    80002fc8:	0ed7e263          	bltu	a5,a3,800030ac <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fcc:	00043737          	lui	a4,0x43
    80002fd0:	0ef76063          	bltu	a4,a5,800030b0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd4:	0c0b8863          	beqz	s7,800030a4 <writei+0x10e>
    80002fd8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fda:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fde:	5cfd                	li	s9,-1
    80002fe0:	a091                	j	80003024 <writei+0x8e>
    80002fe2:	02099d93          	slli	s11,s3,0x20
    80002fe6:	020ddd93          	srli	s11,s11,0x20
    80002fea:	05848513          	addi	a0,s1,88
    80002fee:	86ee                	mv	a3,s11
    80002ff0:	8656                	mv	a2,s5
    80002ff2:	85e2                	mv	a1,s8
    80002ff4:	953a                	add	a0,a0,a4
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	95e080e7          	jalr	-1698(ra) # 80001954 <either_copyin>
    80002ffe:	07950263          	beq	a0,s9,80003062 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003002:	8526                	mv	a0,s1
    80003004:	00000097          	auipc	ra,0x0
    80003008:	790080e7          	jalr	1936(ra) # 80003794 <log_write>
    brelse(bp);
    8000300c:	8526                	mv	a0,s1
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	50a080e7          	jalr	1290(ra) # 80002518 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003016:	01498a3b          	addw	s4,s3,s4
    8000301a:	0129893b          	addw	s2,s3,s2
    8000301e:	9aee                	add	s5,s5,s11
    80003020:	057a7663          	bgeu	s4,s7,8000306c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003024:	000b2483          	lw	s1,0(s6)
    80003028:	00a9559b          	srliw	a1,s2,0xa
    8000302c:	855a                	mv	a0,s6
    8000302e:	fffff097          	auipc	ra,0xfffff
    80003032:	7ae080e7          	jalr	1966(ra) # 800027dc <bmap>
    80003036:	0005059b          	sext.w	a1,a0
    8000303a:	8526                	mv	a0,s1
    8000303c:	fffff097          	auipc	ra,0xfffff
    80003040:	3ac080e7          	jalr	940(ra) # 800023e8 <bread>
    80003044:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003046:	3ff97713          	andi	a4,s2,1023
    8000304a:	40ed07bb          	subw	a5,s10,a4
    8000304e:	414b86bb          	subw	a3,s7,s4
    80003052:	89be                	mv	s3,a5
    80003054:	2781                	sext.w	a5,a5
    80003056:	0006861b          	sext.w	a2,a3
    8000305a:	f8f674e3          	bgeu	a2,a5,80002fe2 <writei+0x4c>
    8000305e:	89b6                	mv	s3,a3
    80003060:	b749                	j	80002fe2 <writei+0x4c>
      brelse(bp);
    80003062:	8526                	mv	a0,s1
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	4b4080e7          	jalr	1204(ra) # 80002518 <brelse>
  }

  if(off > ip->size)
    8000306c:	04cb2783          	lw	a5,76(s6)
    80003070:	0127f463          	bgeu	a5,s2,80003078 <writei+0xe2>
    ip->size = off;
    80003074:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003078:	855a                	mv	a0,s6
    8000307a:	00000097          	auipc	ra,0x0
    8000307e:	aa6080e7          	jalr	-1370(ra) # 80002b20 <iupdate>

  return tot;
    80003082:	000a051b          	sext.w	a0,s4
}
    80003086:	70a6                	ld	ra,104(sp)
    80003088:	7406                	ld	s0,96(sp)
    8000308a:	64e6                	ld	s1,88(sp)
    8000308c:	6946                	ld	s2,80(sp)
    8000308e:	69a6                	ld	s3,72(sp)
    80003090:	6a06                	ld	s4,64(sp)
    80003092:	7ae2                	ld	s5,56(sp)
    80003094:	7b42                	ld	s6,48(sp)
    80003096:	7ba2                	ld	s7,40(sp)
    80003098:	7c02                	ld	s8,32(sp)
    8000309a:	6ce2                	ld	s9,24(sp)
    8000309c:	6d42                	ld	s10,16(sp)
    8000309e:	6da2                	ld	s11,8(sp)
    800030a0:	6165                	addi	sp,sp,112
    800030a2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a4:	8a5e                	mv	s4,s7
    800030a6:	bfc9                	j	80003078 <writei+0xe2>
    return -1;
    800030a8:	557d                	li	a0,-1
}
    800030aa:	8082                	ret
    return -1;
    800030ac:	557d                	li	a0,-1
    800030ae:	bfe1                	j	80003086 <writei+0xf0>
    return -1;
    800030b0:	557d                	li	a0,-1
    800030b2:	bfd1                	j	80003086 <writei+0xf0>

00000000800030b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030b4:	1141                	addi	sp,sp,-16
    800030b6:	e406                	sd	ra,8(sp)
    800030b8:	e022                	sd	s0,0(sp)
    800030ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030bc:	4639                	li	a2,14
    800030be:	ffffd097          	auipc	ra,0xffffd
    800030c2:	1dc080e7          	jalr	476(ra) # 8000029a <strncmp>
}
    800030c6:	60a2                	ld	ra,8(sp)
    800030c8:	6402                	ld	s0,0(sp)
    800030ca:	0141                	addi	sp,sp,16
    800030cc:	8082                	ret

00000000800030ce <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ce:	7139                	addi	sp,sp,-64
    800030d0:	fc06                	sd	ra,56(sp)
    800030d2:	f822                	sd	s0,48(sp)
    800030d4:	f426                	sd	s1,40(sp)
    800030d6:	f04a                	sd	s2,32(sp)
    800030d8:	ec4e                	sd	s3,24(sp)
    800030da:	e852                	sd	s4,16(sp)
    800030dc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030de:	04451703          	lh	a4,68(a0)
    800030e2:	4785                	li	a5,1
    800030e4:	00f71a63          	bne	a4,a5,800030f8 <dirlookup+0x2a>
    800030e8:	892a                	mv	s2,a0
    800030ea:	89ae                	mv	s3,a1
    800030ec:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ee:	457c                	lw	a5,76(a0)
    800030f0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030f2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f4:	e79d                	bnez	a5,80003122 <dirlookup+0x54>
    800030f6:	a8a5                	j	8000316e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	60050513          	addi	a0,a0,1536 # 800086f8 <syscall_names+0x1a8>
    80003100:	00003097          	auipc	ra,0x3
    80003104:	b98080e7          	jalr	-1128(ra) # 80005c98 <panic>
      panic("dirlookup read");
    80003108:	00005517          	auipc	a0,0x5
    8000310c:	60850513          	addi	a0,a0,1544 # 80008710 <syscall_names+0x1c0>
    80003110:	00003097          	auipc	ra,0x3
    80003114:	b88080e7          	jalr	-1144(ra) # 80005c98 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003118:	24c1                	addiw	s1,s1,16
    8000311a:	04c92783          	lw	a5,76(s2)
    8000311e:	04f4f763          	bgeu	s1,a5,8000316c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003122:	4741                	li	a4,16
    80003124:	86a6                	mv	a3,s1
    80003126:	fc040613          	addi	a2,s0,-64
    8000312a:	4581                	li	a1,0
    8000312c:	854a                	mv	a0,s2
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	d70080e7          	jalr	-656(ra) # 80002e9e <readi>
    80003136:	47c1                	li	a5,16
    80003138:	fcf518e3          	bne	a0,a5,80003108 <dirlookup+0x3a>
    if(de.inum == 0)
    8000313c:	fc045783          	lhu	a5,-64(s0)
    80003140:	dfe1                	beqz	a5,80003118 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003142:	fc240593          	addi	a1,s0,-62
    80003146:	854e                	mv	a0,s3
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	f6c080e7          	jalr	-148(ra) # 800030b4 <namecmp>
    80003150:	f561                	bnez	a0,80003118 <dirlookup+0x4a>
      if(poff)
    80003152:	000a0463          	beqz	s4,8000315a <dirlookup+0x8c>
        *poff = off;
    80003156:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000315a:	fc045583          	lhu	a1,-64(s0)
    8000315e:	00092503          	lw	a0,0(s2)
    80003162:	fffff097          	auipc	ra,0xfffff
    80003166:	754080e7          	jalr	1876(ra) # 800028b6 <iget>
    8000316a:	a011                	j	8000316e <dirlookup+0xa0>
  return 0;
    8000316c:	4501                	li	a0,0
}
    8000316e:	70e2                	ld	ra,56(sp)
    80003170:	7442                	ld	s0,48(sp)
    80003172:	74a2                	ld	s1,40(sp)
    80003174:	7902                	ld	s2,32(sp)
    80003176:	69e2                	ld	s3,24(sp)
    80003178:	6a42                	ld	s4,16(sp)
    8000317a:	6121                	addi	sp,sp,64
    8000317c:	8082                	ret

000000008000317e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
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
    80003198:	84aa                	mv	s1,a0
    8000319a:	8b2e                	mv	s6,a1
    8000319c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000319e:	00054703          	lbu	a4,0(a0)
    800031a2:	02f00793          	li	a5,47
    800031a6:	02f70363          	beq	a4,a5,800031cc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031aa:	ffffe097          	auipc	ra,0xffffe
    800031ae:	ce8080e7          	jalr	-792(ra) # 80000e92 <myproc>
    800031b2:	15053503          	ld	a0,336(a0)
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	9f6080e7          	jalr	-1546(ra) # 80002bac <idup>
    800031be:	89aa                	mv	s3,a0
  while(*path == '/')
    800031c0:	02f00913          	li	s2,47
  len = path - s;
    800031c4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031c6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031c8:	4c05                	li	s8,1
    800031ca:	a865                	j	80003282 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031cc:	4585                	li	a1,1
    800031ce:	4505                	li	a0,1
    800031d0:	fffff097          	auipc	ra,0xfffff
    800031d4:	6e6080e7          	jalr	1766(ra) # 800028b6 <iget>
    800031d8:	89aa                	mv	s3,a0
    800031da:	b7dd                	j	800031c0 <namex+0x42>
      iunlockput(ip);
    800031dc:	854e                	mv	a0,s3
    800031de:	00000097          	auipc	ra,0x0
    800031e2:	c6e080e7          	jalr	-914(ra) # 80002e4c <iunlockput>
      return 0;
    800031e6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031e8:	854e                	mv	a0,s3
    800031ea:	60e6                	ld	ra,88(sp)
    800031ec:	6446                	ld	s0,80(sp)
    800031ee:	64a6                	ld	s1,72(sp)
    800031f0:	6906                	ld	s2,64(sp)
    800031f2:	79e2                	ld	s3,56(sp)
    800031f4:	7a42                	ld	s4,48(sp)
    800031f6:	7aa2                	ld	s5,40(sp)
    800031f8:	7b02                	ld	s6,32(sp)
    800031fa:	6be2                	ld	s7,24(sp)
    800031fc:	6c42                	ld	s8,16(sp)
    800031fe:	6ca2                	ld	s9,8(sp)
    80003200:	6125                	addi	sp,sp,96
    80003202:	8082                	ret
      iunlock(ip);
    80003204:	854e                	mv	a0,s3
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	aa6080e7          	jalr	-1370(ra) # 80002cac <iunlock>
      return ip;
    8000320e:	bfe9                	j	800031e8 <namex+0x6a>
      iunlockput(ip);
    80003210:	854e                	mv	a0,s3
    80003212:	00000097          	auipc	ra,0x0
    80003216:	c3a080e7          	jalr	-966(ra) # 80002e4c <iunlockput>
      return 0;
    8000321a:	89d2                	mv	s3,s4
    8000321c:	b7f1                	j	800031e8 <namex+0x6a>
  len = path - s;
    8000321e:	40b48633          	sub	a2,s1,a1
    80003222:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003226:	094cd463          	bge	s9,s4,800032ae <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000322a:	4639                	li	a2,14
    8000322c:	8556                	mv	a0,s5
    8000322e:	ffffd097          	auipc	ra,0xffffd
    80003232:	ff4080e7          	jalr	-12(ra) # 80000222 <memmove>
  while(*path == '/')
    80003236:	0004c783          	lbu	a5,0(s1)
    8000323a:	01279763          	bne	a5,s2,80003248 <namex+0xca>
    path++;
    8000323e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	ff278de3          	beq	a5,s2,8000323e <namex+0xc0>
    ilock(ip);
    80003248:	854e                	mv	a0,s3
    8000324a:	00000097          	auipc	ra,0x0
    8000324e:	9a0080e7          	jalr	-1632(ra) # 80002bea <ilock>
    if(ip->type != T_DIR){
    80003252:	04499783          	lh	a5,68(s3)
    80003256:	f98793e3          	bne	a5,s8,800031dc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000325a:	000b0563          	beqz	s6,80003264 <namex+0xe6>
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	d3cd                	beqz	a5,80003204 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003264:	865e                	mv	a2,s7
    80003266:	85d6                	mv	a1,s5
    80003268:	854e                	mv	a0,s3
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	e64080e7          	jalr	-412(ra) # 800030ce <dirlookup>
    80003272:	8a2a                	mv	s4,a0
    80003274:	dd51                	beqz	a0,80003210 <namex+0x92>
    iunlockput(ip);
    80003276:	854e                	mv	a0,s3
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	bd4080e7          	jalr	-1068(ra) # 80002e4c <iunlockput>
    ip = next;
    80003280:	89d2                	mv	s3,s4
  while(*path == '/')
    80003282:	0004c783          	lbu	a5,0(s1)
    80003286:	05279763          	bne	a5,s2,800032d4 <namex+0x156>
    path++;
    8000328a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	ff278de3          	beq	a5,s2,8000328a <namex+0x10c>
  if(*path == 0)
    80003294:	c79d                	beqz	a5,800032c2 <namex+0x144>
    path++;
    80003296:	85a6                	mv	a1,s1
  len = path - s;
    80003298:	8a5e                	mv	s4,s7
    8000329a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000329c:	01278963          	beq	a5,s2,800032ae <namex+0x130>
    800032a0:	dfbd                	beqz	a5,8000321e <namex+0xa0>
    path++;
    800032a2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032a4:	0004c783          	lbu	a5,0(s1)
    800032a8:	ff279ce3          	bne	a5,s2,800032a0 <namex+0x122>
    800032ac:	bf8d                	j	8000321e <namex+0xa0>
    memmove(name, s, len);
    800032ae:	2601                	sext.w	a2,a2
    800032b0:	8556                	mv	a0,s5
    800032b2:	ffffd097          	auipc	ra,0xffffd
    800032b6:	f70080e7          	jalr	-144(ra) # 80000222 <memmove>
    name[len] = 0;
    800032ba:	9a56                	add	s4,s4,s5
    800032bc:	000a0023          	sb	zero,0(s4)
    800032c0:	bf9d                	j	80003236 <namex+0xb8>
  if(nameiparent){
    800032c2:	f20b03e3          	beqz	s6,800031e8 <namex+0x6a>
    iput(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	adc080e7          	jalr	-1316(ra) # 80002da4 <iput>
    return 0;
    800032d0:	4981                	li	s3,0
    800032d2:	bf19                	j	800031e8 <namex+0x6a>
  if(*path == 0)
    800032d4:	d7fd                	beqz	a5,800032c2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	85a6                	mv	a1,s1
    800032dc:	b7d1                	j	800032a0 <namex+0x122>

00000000800032de <dirlink>:
{
    800032de:	7139                	addi	sp,sp,-64
    800032e0:	fc06                	sd	ra,56(sp)
    800032e2:	f822                	sd	s0,48(sp)
    800032e4:	f426                	sd	s1,40(sp)
    800032e6:	f04a                	sd	s2,32(sp)
    800032e8:	ec4e                	sd	s3,24(sp)
    800032ea:	e852                	sd	s4,16(sp)
    800032ec:	0080                	addi	s0,sp,64
    800032ee:	892a                	mv	s2,a0
    800032f0:	8a2e                	mv	s4,a1
    800032f2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032f4:	4601                	li	a2,0
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	dd8080e7          	jalr	-552(ra) # 800030ce <dirlookup>
    800032fe:	e93d                	bnez	a0,80003374 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003300:	04c92483          	lw	s1,76(s2)
    80003304:	c49d                	beqz	s1,80003332 <dirlink+0x54>
    80003306:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003308:	4741                	li	a4,16
    8000330a:	86a6                	mv	a3,s1
    8000330c:	fc040613          	addi	a2,s0,-64
    80003310:	4581                	li	a1,0
    80003312:	854a                	mv	a0,s2
    80003314:	00000097          	auipc	ra,0x0
    80003318:	b8a080e7          	jalr	-1142(ra) # 80002e9e <readi>
    8000331c:	47c1                	li	a5,16
    8000331e:	06f51163          	bne	a0,a5,80003380 <dirlink+0xa2>
    if(de.inum == 0)
    80003322:	fc045783          	lhu	a5,-64(s0)
    80003326:	c791                	beqz	a5,80003332 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003328:	24c1                	addiw	s1,s1,16
    8000332a:	04c92783          	lw	a5,76(s2)
    8000332e:	fcf4ede3          	bltu	s1,a5,80003308 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003332:	4639                	li	a2,14
    80003334:	85d2                	mv	a1,s4
    80003336:	fc240513          	addi	a0,s0,-62
    8000333a:	ffffd097          	auipc	ra,0xffffd
    8000333e:	f9c080e7          	jalr	-100(ra) # 800002d6 <strncpy>
  de.inum = inum;
    80003342:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003346:	4741                	li	a4,16
    80003348:	86a6                	mv	a3,s1
    8000334a:	fc040613          	addi	a2,s0,-64
    8000334e:	4581                	li	a1,0
    80003350:	854a                	mv	a0,s2
    80003352:	00000097          	auipc	ra,0x0
    80003356:	c44080e7          	jalr	-956(ra) # 80002f96 <writei>
    8000335a:	872a                	mv	a4,a0
    8000335c:	47c1                	li	a5,16
  return 0;
    8000335e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003360:	02f71863          	bne	a4,a5,80003390 <dirlink+0xb2>
}
    80003364:	70e2                	ld	ra,56(sp)
    80003366:	7442                	ld	s0,48(sp)
    80003368:	74a2                	ld	s1,40(sp)
    8000336a:	7902                	ld	s2,32(sp)
    8000336c:	69e2                	ld	s3,24(sp)
    8000336e:	6a42                	ld	s4,16(sp)
    80003370:	6121                	addi	sp,sp,64
    80003372:	8082                	ret
    iput(ip);
    80003374:	00000097          	auipc	ra,0x0
    80003378:	a30080e7          	jalr	-1488(ra) # 80002da4 <iput>
    return -1;
    8000337c:	557d                	li	a0,-1
    8000337e:	b7dd                	j	80003364 <dirlink+0x86>
      panic("dirlink read");
    80003380:	00005517          	auipc	a0,0x5
    80003384:	3a050513          	addi	a0,a0,928 # 80008720 <syscall_names+0x1d0>
    80003388:	00003097          	auipc	ra,0x3
    8000338c:	910080e7          	jalr	-1776(ra) # 80005c98 <panic>
    panic("dirlink");
    80003390:	00005517          	auipc	a0,0x5
    80003394:	49850513          	addi	a0,a0,1176 # 80008828 <syscall_names+0x2d8>
    80003398:	00003097          	auipc	ra,0x3
    8000339c:	900080e7          	jalr	-1792(ra) # 80005c98 <panic>

00000000800033a0 <namei>:

struct inode*
namei(char *path)
{
    800033a0:	1101                	addi	sp,sp,-32
    800033a2:	ec06                	sd	ra,24(sp)
    800033a4:	e822                	sd	s0,16(sp)
    800033a6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a8:	fe040613          	addi	a2,s0,-32
    800033ac:	4581                	li	a1,0
    800033ae:	00000097          	auipc	ra,0x0
    800033b2:	dd0080e7          	jalr	-560(ra) # 8000317e <namex>
}
    800033b6:	60e2                	ld	ra,24(sp)
    800033b8:	6442                	ld	s0,16(sp)
    800033ba:	6105                	addi	sp,sp,32
    800033bc:	8082                	ret

00000000800033be <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033be:	1141                	addi	sp,sp,-16
    800033c0:	e406                	sd	ra,8(sp)
    800033c2:	e022                	sd	s0,0(sp)
    800033c4:	0800                	addi	s0,sp,16
    800033c6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c8:	4585                	li	a1,1
    800033ca:	00000097          	auipc	ra,0x0
    800033ce:	db4080e7          	jalr	-588(ra) # 8000317e <namex>
}
    800033d2:	60a2                	ld	ra,8(sp)
    800033d4:	6402                	ld	s0,0(sp)
    800033d6:	0141                	addi	sp,sp,16
    800033d8:	8082                	ret

00000000800033da <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033da:	1101                	addi	sp,sp,-32
    800033dc:	ec06                	sd	ra,24(sp)
    800033de:	e822                	sd	s0,16(sp)
    800033e0:	e426                	sd	s1,8(sp)
    800033e2:	e04a                	sd	s2,0(sp)
    800033e4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e6:	00016917          	auipc	s2,0x16
    800033ea:	e3a90913          	addi	s2,s2,-454 # 80019220 <log>
    800033ee:	01892583          	lw	a1,24(s2)
    800033f2:	02892503          	lw	a0,40(s2)
    800033f6:	fffff097          	auipc	ra,0xfffff
    800033fa:	ff2080e7          	jalr	-14(ra) # 800023e8 <bread>
    800033fe:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003400:	02c92683          	lw	a3,44(s2)
    80003404:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003406:	02d05763          	blez	a3,80003434 <write_head+0x5a>
    8000340a:	00016797          	auipc	a5,0x16
    8000340e:	e4678793          	addi	a5,a5,-442 # 80019250 <log+0x30>
    80003412:	05c50713          	addi	a4,a0,92
    80003416:	36fd                	addiw	a3,a3,-1
    80003418:	1682                	slli	a3,a3,0x20
    8000341a:	9281                	srli	a3,a3,0x20
    8000341c:	068a                	slli	a3,a3,0x2
    8000341e:	00016617          	auipc	a2,0x16
    80003422:	e3660613          	addi	a2,a2,-458 # 80019254 <log+0x34>
    80003426:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003428:	4390                	lw	a2,0(a5)
    8000342a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000342c:	0791                	addi	a5,a5,4
    8000342e:	0711                	addi	a4,a4,4
    80003430:	fed79ce3          	bne	a5,a3,80003428 <write_head+0x4e>
  }
  bwrite(buf);
    80003434:	8526                	mv	a0,s1
    80003436:	fffff097          	auipc	ra,0xfffff
    8000343a:	0a4080e7          	jalr	164(ra) # 800024da <bwrite>
  brelse(buf);
    8000343e:	8526                	mv	a0,s1
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	0d8080e7          	jalr	216(ra) # 80002518 <brelse>
}
    80003448:	60e2                	ld	ra,24(sp)
    8000344a:	6442                	ld	s0,16(sp)
    8000344c:	64a2                	ld	s1,8(sp)
    8000344e:	6902                	ld	s2,0(sp)
    80003450:	6105                	addi	sp,sp,32
    80003452:	8082                	ret

0000000080003454 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003454:	00016797          	auipc	a5,0x16
    80003458:	df87a783          	lw	a5,-520(a5) # 8001924c <log+0x2c>
    8000345c:	0af05d63          	blez	a5,80003516 <install_trans+0xc2>
{
    80003460:	7139                	addi	sp,sp,-64
    80003462:	fc06                	sd	ra,56(sp)
    80003464:	f822                	sd	s0,48(sp)
    80003466:	f426                	sd	s1,40(sp)
    80003468:	f04a                	sd	s2,32(sp)
    8000346a:	ec4e                	sd	s3,24(sp)
    8000346c:	e852                	sd	s4,16(sp)
    8000346e:	e456                	sd	s5,8(sp)
    80003470:	e05a                	sd	s6,0(sp)
    80003472:	0080                	addi	s0,sp,64
    80003474:	8b2a                	mv	s6,a0
    80003476:	00016a97          	auipc	s5,0x16
    8000347a:	ddaa8a93          	addi	s5,s5,-550 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003480:	00016997          	auipc	s3,0x16
    80003484:	da098993          	addi	s3,s3,-608 # 80019220 <log>
    80003488:	a035                	j	800034b4 <install_trans+0x60>
      bunpin(dbuf);
    8000348a:	8526                	mv	a0,s1
    8000348c:	fffff097          	auipc	ra,0xfffff
    80003490:	166080e7          	jalr	358(ra) # 800025f2 <bunpin>
    brelse(lbuf);
    80003494:	854a                	mv	a0,s2
    80003496:	fffff097          	auipc	ra,0xfffff
    8000349a:	082080e7          	jalr	130(ra) # 80002518 <brelse>
    brelse(dbuf);
    8000349e:	8526                	mv	a0,s1
    800034a0:	fffff097          	auipc	ra,0xfffff
    800034a4:	078080e7          	jalr	120(ra) # 80002518 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a8:	2a05                	addiw	s4,s4,1
    800034aa:	0a91                	addi	s5,s5,4
    800034ac:	02c9a783          	lw	a5,44(s3)
    800034b0:	04fa5963          	bge	s4,a5,80003502 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b4:	0189a583          	lw	a1,24(s3)
    800034b8:	014585bb          	addw	a1,a1,s4
    800034bc:	2585                	addiw	a1,a1,1
    800034be:	0289a503          	lw	a0,40(s3)
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	f26080e7          	jalr	-218(ra) # 800023e8 <bread>
    800034ca:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034cc:	000aa583          	lw	a1,0(s5)
    800034d0:	0289a503          	lw	a0,40(s3)
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	f14080e7          	jalr	-236(ra) # 800023e8 <bread>
    800034dc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034de:	40000613          	li	a2,1024
    800034e2:	05890593          	addi	a1,s2,88
    800034e6:	05850513          	addi	a0,a0,88
    800034ea:	ffffd097          	auipc	ra,0xffffd
    800034ee:	d38080e7          	jalr	-712(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034f2:	8526                	mv	a0,s1
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	fe6080e7          	jalr	-26(ra) # 800024da <bwrite>
    if(recovering == 0)
    800034fc:	f80b1ce3          	bnez	s6,80003494 <install_trans+0x40>
    80003500:	b769                	j	8000348a <install_trans+0x36>
}
    80003502:	70e2                	ld	ra,56(sp)
    80003504:	7442                	ld	s0,48(sp)
    80003506:	74a2                	ld	s1,40(sp)
    80003508:	7902                	ld	s2,32(sp)
    8000350a:	69e2                	ld	s3,24(sp)
    8000350c:	6a42                	ld	s4,16(sp)
    8000350e:	6aa2                	ld	s5,8(sp)
    80003510:	6b02                	ld	s6,0(sp)
    80003512:	6121                	addi	sp,sp,64
    80003514:	8082                	ret
    80003516:	8082                	ret

0000000080003518 <initlog>:
{
    80003518:	7179                	addi	sp,sp,-48
    8000351a:	f406                	sd	ra,40(sp)
    8000351c:	f022                	sd	s0,32(sp)
    8000351e:	ec26                	sd	s1,24(sp)
    80003520:	e84a                	sd	s2,16(sp)
    80003522:	e44e                	sd	s3,8(sp)
    80003524:	1800                	addi	s0,sp,48
    80003526:	892a                	mv	s2,a0
    80003528:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352a:	00016497          	auipc	s1,0x16
    8000352e:	cf648493          	addi	s1,s1,-778 # 80019220 <log>
    80003532:	00005597          	auipc	a1,0x5
    80003536:	1fe58593          	addi	a1,a1,510 # 80008730 <syscall_names+0x1e0>
    8000353a:	8526                	mv	a0,s1
    8000353c:	00003097          	auipc	ra,0x3
    80003540:	c16080e7          	jalr	-1002(ra) # 80006152 <initlock>
  log.start = sb->logstart;
    80003544:	0149a583          	lw	a1,20(s3)
    80003548:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354a:	0109a783          	lw	a5,16(s3)
    8000354e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003550:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003554:	854a                	mv	a0,s2
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	e92080e7          	jalr	-366(ra) # 800023e8 <bread>
  log.lh.n = lh->n;
    8000355e:	4d3c                	lw	a5,88(a0)
    80003560:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003562:	02f05563          	blez	a5,8000358c <initlog+0x74>
    80003566:	05c50713          	addi	a4,a0,92
    8000356a:	00016697          	auipc	a3,0x16
    8000356e:	ce668693          	addi	a3,a3,-794 # 80019250 <log+0x30>
    80003572:	37fd                	addiw	a5,a5,-1
    80003574:	1782                	slli	a5,a5,0x20
    80003576:	9381                	srli	a5,a5,0x20
    80003578:	078a                	slli	a5,a5,0x2
    8000357a:	06050613          	addi	a2,a0,96
    8000357e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003580:	4310                	lw	a2,0(a4)
    80003582:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003584:	0711                	addi	a4,a4,4
    80003586:	0691                	addi	a3,a3,4
    80003588:	fef71ce3          	bne	a4,a5,80003580 <initlog+0x68>
  brelse(buf);
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	f8c080e7          	jalr	-116(ra) # 80002518 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003594:	4505                	li	a0,1
    80003596:	00000097          	auipc	ra,0x0
    8000359a:	ebe080e7          	jalr	-322(ra) # 80003454 <install_trans>
  log.lh.n = 0;
    8000359e:	00016797          	auipc	a5,0x16
    800035a2:	ca07a723          	sw	zero,-850(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	e34080e7          	jalr	-460(ra) # 800033da <write_head>
}
    800035ae:	70a2                	ld	ra,40(sp)
    800035b0:	7402                	ld	s0,32(sp)
    800035b2:	64e2                	ld	s1,24(sp)
    800035b4:	6942                	ld	s2,16(sp)
    800035b6:	69a2                	ld	s3,8(sp)
    800035b8:	6145                	addi	sp,sp,48
    800035ba:	8082                	ret

00000000800035bc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035bc:	1101                	addi	sp,sp,-32
    800035be:	ec06                	sd	ra,24(sp)
    800035c0:	e822                	sd	s0,16(sp)
    800035c2:	e426                	sd	s1,8(sp)
    800035c4:	e04a                	sd	s2,0(sp)
    800035c6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c8:	00016517          	auipc	a0,0x16
    800035cc:	c5850513          	addi	a0,a0,-936 # 80019220 <log>
    800035d0:	00003097          	auipc	ra,0x3
    800035d4:	c12080e7          	jalr	-1006(ra) # 800061e2 <acquire>
  while(1){
    if(log.committing){
    800035d8:	00016497          	auipc	s1,0x16
    800035dc:	c4848493          	addi	s1,s1,-952 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e0:	4979                	li	s2,30
    800035e2:	a039                	j	800035f0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035e4:	85a6                	mv	a1,s1
    800035e6:	8526                	mv	a0,s1
    800035e8:	ffffe097          	auipc	ra,0xffffe
    800035ec:	f72080e7          	jalr	-142(ra) # 8000155a <sleep>
    if(log.committing){
    800035f0:	50dc                	lw	a5,36(s1)
    800035f2:	fbed                	bnez	a5,800035e4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f4:	509c                	lw	a5,32(s1)
    800035f6:	0017871b          	addiw	a4,a5,1
    800035fa:	0007069b          	sext.w	a3,a4
    800035fe:	0027179b          	slliw	a5,a4,0x2
    80003602:	9fb9                	addw	a5,a5,a4
    80003604:	0017979b          	slliw	a5,a5,0x1
    80003608:	54d8                	lw	a4,44(s1)
    8000360a:	9fb9                	addw	a5,a5,a4
    8000360c:	00f95963          	bge	s2,a5,8000361e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003610:	85a6                	mv	a1,s1
    80003612:	8526                	mv	a0,s1
    80003614:	ffffe097          	auipc	ra,0xffffe
    80003618:	f46080e7          	jalr	-186(ra) # 8000155a <sleep>
    8000361c:	bfd1                	j	800035f0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000361e:	00016517          	auipc	a0,0x16
    80003622:	c0250513          	addi	a0,a0,-1022 # 80019220 <log>
    80003626:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003628:	00003097          	auipc	ra,0x3
    8000362c:	c6e080e7          	jalr	-914(ra) # 80006296 <release>
      break;
    }
  }
}
    80003630:	60e2                	ld	ra,24(sp)
    80003632:	6442                	ld	s0,16(sp)
    80003634:	64a2                	ld	s1,8(sp)
    80003636:	6902                	ld	s2,0(sp)
    80003638:	6105                	addi	sp,sp,32
    8000363a:	8082                	ret

000000008000363c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000363c:	7139                	addi	sp,sp,-64
    8000363e:	fc06                	sd	ra,56(sp)
    80003640:	f822                	sd	s0,48(sp)
    80003642:	f426                	sd	s1,40(sp)
    80003644:	f04a                	sd	s2,32(sp)
    80003646:	ec4e                	sd	s3,24(sp)
    80003648:	e852                	sd	s4,16(sp)
    8000364a:	e456                	sd	s5,8(sp)
    8000364c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000364e:	00016497          	auipc	s1,0x16
    80003652:	bd248493          	addi	s1,s1,-1070 # 80019220 <log>
    80003656:	8526                	mv	a0,s1
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	b8a080e7          	jalr	-1142(ra) # 800061e2 <acquire>
  log.outstanding -= 1;
    80003660:	509c                	lw	a5,32(s1)
    80003662:	37fd                	addiw	a5,a5,-1
    80003664:	0007891b          	sext.w	s2,a5
    80003668:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000366a:	50dc                	lw	a5,36(s1)
    8000366c:	efb9                	bnez	a5,800036ca <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000366e:	06091663          	bnez	s2,800036da <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003672:	00016497          	auipc	s1,0x16
    80003676:	bae48493          	addi	s1,s1,-1106 # 80019220 <log>
    8000367a:	4785                	li	a5,1
    8000367c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000367e:	8526                	mv	a0,s1
    80003680:	00003097          	auipc	ra,0x3
    80003684:	c16080e7          	jalr	-1002(ra) # 80006296 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003688:	54dc                	lw	a5,44(s1)
    8000368a:	06f04763          	bgtz	a5,800036f8 <end_op+0xbc>
    acquire(&log.lock);
    8000368e:	00016497          	auipc	s1,0x16
    80003692:	b9248493          	addi	s1,s1,-1134 # 80019220 <log>
    80003696:	8526                	mv	a0,s1
    80003698:	00003097          	auipc	ra,0x3
    8000369c:	b4a080e7          	jalr	-1206(ra) # 800061e2 <acquire>
    log.committing = 0;
    800036a0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036a4:	8526                	mv	a0,s1
    800036a6:	ffffe097          	auipc	ra,0xffffe
    800036aa:	040080e7          	jalr	64(ra) # 800016e6 <wakeup>
    release(&log.lock);
    800036ae:	8526                	mv	a0,s1
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	be6080e7          	jalr	-1050(ra) # 80006296 <release>
}
    800036b8:	70e2                	ld	ra,56(sp)
    800036ba:	7442                	ld	s0,48(sp)
    800036bc:	74a2                	ld	s1,40(sp)
    800036be:	7902                	ld	s2,32(sp)
    800036c0:	69e2                	ld	s3,24(sp)
    800036c2:	6a42                	ld	s4,16(sp)
    800036c4:	6aa2                	ld	s5,8(sp)
    800036c6:	6121                	addi	sp,sp,64
    800036c8:	8082                	ret
    panic("log.committing");
    800036ca:	00005517          	auipc	a0,0x5
    800036ce:	06e50513          	addi	a0,a0,110 # 80008738 <syscall_names+0x1e8>
    800036d2:	00002097          	auipc	ra,0x2
    800036d6:	5c6080e7          	jalr	1478(ra) # 80005c98 <panic>
    wakeup(&log);
    800036da:	00016497          	auipc	s1,0x16
    800036de:	b4648493          	addi	s1,s1,-1210 # 80019220 <log>
    800036e2:	8526                	mv	a0,s1
    800036e4:	ffffe097          	auipc	ra,0xffffe
    800036e8:	002080e7          	jalr	2(ra) # 800016e6 <wakeup>
  release(&log.lock);
    800036ec:	8526                	mv	a0,s1
    800036ee:	00003097          	auipc	ra,0x3
    800036f2:	ba8080e7          	jalr	-1112(ra) # 80006296 <release>
  if(do_commit){
    800036f6:	b7c9                	j	800036b8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f8:	00016a97          	auipc	s5,0x16
    800036fc:	b58a8a93          	addi	s5,s5,-1192 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003700:	00016a17          	auipc	s4,0x16
    80003704:	b20a0a13          	addi	s4,s4,-1248 # 80019220 <log>
    80003708:	018a2583          	lw	a1,24(s4)
    8000370c:	012585bb          	addw	a1,a1,s2
    80003710:	2585                	addiw	a1,a1,1
    80003712:	028a2503          	lw	a0,40(s4)
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	cd2080e7          	jalr	-814(ra) # 800023e8 <bread>
    8000371e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003720:	000aa583          	lw	a1,0(s5)
    80003724:	028a2503          	lw	a0,40(s4)
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	cc0080e7          	jalr	-832(ra) # 800023e8 <bread>
    80003730:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003732:	40000613          	li	a2,1024
    80003736:	05850593          	addi	a1,a0,88
    8000373a:	05848513          	addi	a0,s1,88
    8000373e:	ffffd097          	auipc	ra,0xffffd
    80003742:	ae4080e7          	jalr	-1308(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    80003746:	8526                	mv	a0,s1
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	d92080e7          	jalr	-622(ra) # 800024da <bwrite>
    brelse(from);
    80003750:	854e                	mv	a0,s3
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	dc6080e7          	jalr	-570(ra) # 80002518 <brelse>
    brelse(to);
    8000375a:	8526                	mv	a0,s1
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	dbc080e7          	jalr	-580(ra) # 80002518 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003764:	2905                	addiw	s2,s2,1
    80003766:	0a91                	addi	s5,s5,4
    80003768:	02ca2783          	lw	a5,44(s4)
    8000376c:	f8f94ee3          	blt	s2,a5,80003708 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003770:	00000097          	auipc	ra,0x0
    80003774:	c6a080e7          	jalr	-918(ra) # 800033da <write_head>
    install_trans(0); // Now install writes to home locations
    80003778:	4501                	li	a0,0
    8000377a:	00000097          	auipc	ra,0x0
    8000377e:	cda080e7          	jalr	-806(ra) # 80003454 <install_trans>
    log.lh.n = 0;
    80003782:	00016797          	auipc	a5,0x16
    80003786:	ac07a523          	sw	zero,-1334(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000378a:	00000097          	auipc	ra,0x0
    8000378e:	c50080e7          	jalr	-944(ra) # 800033da <write_head>
    80003792:	bdf5                	j	8000368e <end_op+0x52>

0000000080003794 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003794:	1101                	addi	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	e04a                	sd	s2,0(sp)
    8000379e:	1000                	addi	s0,sp,32
    800037a0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a2:	00016917          	auipc	s2,0x16
    800037a6:	a7e90913          	addi	s2,s2,-1410 # 80019220 <log>
    800037aa:	854a                	mv	a0,s2
    800037ac:	00003097          	auipc	ra,0x3
    800037b0:	a36080e7          	jalr	-1482(ra) # 800061e2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b4:	02c92603          	lw	a2,44(s2)
    800037b8:	47f5                	li	a5,29
    800037ba:	06c7c563          	blt	a5,a2,80003824 <log_write+0x90>
    800037be:	00016797          	auipc	a5,0x16
    800037c2:	a7e7a783          	lw	a5,-1410(a5) # 8001923c <log+0x1c>
    800037c6:	37fd                	addiw	a5,a5,-1
    800037c8:	04f65e63          	bge	a2,a5,80003824 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037cc:	00016797          	auipc	a5,0x16
    800037d0:	a747a783          	lw	a5,-1420(a5) # 80019240 <log+0x20>
    800037d4:	06f05063          	blez	a5,80003834 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d8:	4781                	li	a5,0
    800037da:	06c05563          	blez	a2,80003844 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037de:	44cc                	lw	a1,12(s1)
    800037e0:	00016717          	auipc	a4,0x16
    800037e4:	a7070713          	addi	a4,a4,-1424 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ea:	4314                	lw	a3,0(a4)
    800037ec:	04b68c63          	beq	a3,a1,80003844 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037f0:	2785                	addiw	a5,a5,1
    800037f2:	0711                	addi	a4,a4,4
    800037f4:	fef61be3          	bne	a2,a5,800037ea <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f8:	0621                	addi	a2,a2,8
    800037fa:	060a                	slli	a2,a2,0x2
    800037fc:	00016797          	auipc	a5,0x16
    80003800:	a2478793          	addi	a5,a5,-1500 # 80019220 <log>
    80003804:	963e                	add	a2,a2,a5
    80003806:	44dc                	lw	a5,12(s1)
    80003808:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000380a:	8526                	mv	a0,s1
    8000380c:	fffff097          	auipc	ra,0xfffff
    80003810:	daa080e7          	jalr	-598(ra) # 800025b6 <bpin>
    log.lh.n++;
    80003814:	00016717          	auipc	a4,0x16
    80003818:	a0c70713          	addi	a4,a4,-1524 # 80019220 <log>
    8000381c:	575c                	lw	a5,44(a4)
    8000381e:	2785                	addiw	a5,a5,1
    80003820:	d75c                	sw	a5,44(a4)
    80003822:	a835                	j	8000385e <log_write+0xca>
    panic("too big a transaction");
    80003824:	00005517          	auipc	a0,0x5
    80003828:	f2450513          	addi	a0,a0,-220 # 80008748 <syscall_names+0x1f8>
    8000382c:	00002097          	auipc	ra,0x2
    80003830:	46c080e7          	jalr	1132(ra) # 80005c98 <panic>
    panic("log_write outside of trans");
    80003834:	00005517          	auipc	a0,0x5
    80003838:	f2c50513          	addi	a0,a0,-212 # 80008760 <syscall_names+0x210>
    8000383c:	00002097          	auipc	ra,0x2
    80003840:	45c080e7          	jalr	1116(ra) # 80005c98 <panic>
  log.lh.block[i] = b->blockno;
    80003844:	00878713          	addi	a4,a5,8
    80003848:	00271693          	slli	a3,a4,0x2
    8000384c:	00016717          	auipc	a4,0x16
    80003850:	9d470713          	addi	a4,a4,-1580 # 80019220 <log>
    80003854:	9736                	add	a4,a4,a3
    80003856:	44d4                	lw	a3,12(s1)
    80003858:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000385a:	faf608e3          	beq	a2,a5,8000380a <log_write+0x76>
  }
  release(&log.lock);
    8000385e:	00016517          	auipc	a0,0x16
    80003862:	9c250513          	addi	a0,a0,-1598 # 80019220 <log>
    80003866:	00003097          	auipc	ra,0x3
    8000386a:	a30080e7          	jalr	-1488(ra) # 80006296 <release>
}
    8000386e:	60e2                	ld	ra,24(sp)
    80003870:	6442                	ld	s0,16(sp)
    80003872:	64a2                	ld	s1,8(sp)
    80003874:	6902                	ld	s2,0(sp)
    80003876:	6105                	addi	sp,sp,32
    80003878:	8082                	ret

000000008000387a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000387a:	1101                	addi	sp,sp,-32
    8000387c:	ec06                	sd	ra,24(sp)
    8000387e:	e822                	sd	s0,16(sp)
    80003880:	e426                	sd	s1,8(sp)
    80003882:	e04a                	sd	s2,0(sp)
    80003884:	1000                	addi	s0,sp,32
    80003886:	84aa                	mv	s1,a0
    80003888:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000388a:	00005597          	auipc	a1,0x5
    8000388e:	ef658593          	addi	a1,a1,-266 # 80008780 <syscall_names+0x230>
    80003892:	0521                	addi	a0,a0,8
    80003894:	00003097          	auipc	ra,0x3
    80003898:	8be080e7          	jalr	-1858(ra) # 80006152 <initlock>
  lk->name = name;
    8000389c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a4:	0204a423          	sw	zero,40(s1)
}
    800038a8:	60e2                	ld	ra,24(sp)
    800038aa:	6442                	ld	s0,16(sp)
    800038ac:	64a2                	ld	s1,8(sp)
    800038ae:	6902                	ld	s2,0(sp)
    800038b0:	6105                	addi	sp,sp,32
    800038b2:	8082                	ret

00000000800038b4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b4:	1101                	addi	sp,sp,-32
    800038b6:	ec06                	sd	ra,24(sp)
    800038b8:	e822                	sd	s0,16(sp)
    800038ba:	e426                	sd	s1,8(sp)
    800038bc:	e04a                	sd	s2,0(sp)
    800038be:	1000                	addi	s0,sp,32
    800038c0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038c2:	00850913          	addi	s2,a0,8
    800038c6:	854a                	mv	a0,s2
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	91a080e7          	jalr	-1766(ra) # 800061e2 <acquire>
  while (lk->locked) {
    800038d0:	409c                	lw	a5,0(s1)
    800038d2:	cb89                	beqz	a5,800038e4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d4:	85ca                	mv	a1,s2
    800038d6:	8526                	mv	a0,s1
    800038d8:	ffffe097          	auipc	ra,0xffffe
    800038dc:	c82080e7          	jalr	-894(ra) # 8000155a <sleep>
  while (lk->locked) {
    800038e0:	409c                	lw	a5,0(s1)
    800038e2:	fbed                	bnez	a5,800038d4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e4:	4785                	li	a5,1
    800038e6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e8:	ffffd097          	auipc	ra,0xffffd
    800038ec:	5aa080e7          	jalr	1450(ra) # 80000e92 <myproc>
    800038f0:	591c                	lw	a5,48(a0)
    800038f2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f4:	854a                	mv	a0,s2
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	9a0080e7          	jalr	-1632(ra) # 80006296 <release>
}
    800038fe:	60e2                	ld	ra,24(sp)
    80003900:	6442                	ld	s0,16(sp)
    80003902:	64a2                	ld	s1,8(sp)
    80003904:	6902                	ld	s2,0(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret

000000008000390a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	e426                	sd	s1,8(sp)
    80003912:	e04a                	sd	s2,0(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003918:	00850913          	addi	s2,a0,8
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	8c4080e7          	jalr	-1852(ra) # 800061e2 <acquire>
  lk->locked = 0;
    80003926:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000392a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000392e:	8526                	mv	a0,s1
    80003930:	ffffe097          	auipc	ra,0xffffe
    80003934:	db6080e7          	jalr	-586(ra) # 800016e6 <wakeup>
  release(&lk->lk);
    80003938:	854a                	mv	a0,s2
    8000393a:	00003097          	auipc	ra,0x3
    8000393e:	95c080e7          	jalr	-1700(ra) # 80006296 <release>
}
    80003942:	60e2                	ld	ra,24(sp)
    80003944:	6442                	ld	s0,16(sp)
    80003946:	64a2                	ld	s1,8(sp)
    80003948:	6902                	ld	s2,0(sp)
    8000394a:	6105                	addi	sp,sp,32
    8000394c:	8082                	ret

000000008000394e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000394e:	7179                	addi	sp,sp,-48
    80003950:	f406                	sd	ra,40(sp)
    80003952:	f022                	sd	s0,32(sp)
    80003954:	ec26                	sd	s1,24(sp)
    80003956:	e84a                	sd	s2,16(sp)
    80003958:	e44e                	sd	s3,8(sp)
    8000395a:	1800                	addi	s0,sp,48
    8000395c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000395e:	00850913          	addi	s2,a0,8
    80003962:	854a                	mv	a0,s2
    80003964:	00003097          	auipc	ra,0x3
    80003968:	87e080e7          	jalr	-1922(ra) # 800061e2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396c:	409c                	lw	a5,0(s1)
    8000396e:	ef99                	bnez	a5,8000398c <holdingsleep+0x3e>
    80003970:	4481                	li	s1,0
  release(&lk->lk);
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	922080e7          	jalr	-1758(ra) # 80006296 <release>
  return r;
}
    8000397c:	8526                	mv	a0,s1
    8000397e:	70a2                	ld	ra,40(sp)
    80003980:	7402                	ld	s0,32(sp)
    80003982:	64e2                	ld	s1,24(sp)
    80003984:	6942                	ld	s2,16(sp)
    80003986:	69a2                	ld	s3,8(sp)
    80003988:	6145                	addi	sp,sp,48
    8000398a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398c:	0284a983          	lw	s3,40(s1)
    80003990:	ffffd097          	auipc	ra,0xffffd
    80003994:	502080e7          	jalr	1282(ra) # 80000e92 <myproc>
    80003998:	5904                	lw	s1,48(a0)
    8000399a:	413484b3          	sub	s1,s1,s3
    8000399e:	0014b493          	seqz	s1,s1
    800039a2:	bfc1                	j	80003972 <holdingsleep+0x24>

00000000800039a4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039a4:	1141                	addi	sp,sp,-16
    800039a6:	e406                	sd	ra,8(sp)
    800039a8:	e022                	sd	s0,0(sp)
    800039aa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ac:	00005597          	auipc	a1,0x5
    800039b0:	de458593          	addi	a1,a1,-540 # 80008790 <syscall_names+0x240>
    800039b4:	00016517          	auipc	a0,0x16
    800039b8:	9b450513          	addi	a0,a0,-1612 # 80019368 <ftable>
    800039bc:	00002097          	auipc	ra,0x2
    800039c0:	796080e7          	jalr	1942(ra) # 80006152 <initlock>
}
    800039c4:	60a2                	ld	ra,8(sp)
    800039c6:	6402                	ld	s0,0(sp)
    800039c8:	0141                	addi	sp,sp,16
    800039ca:	8082                	ret

00000000800039cc <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039cc:	1101                	addi	sp,sp,-32
    800039ce:	ec06                	sd	ra,24(sp)
    800039d0:	e822                	sd	s0,16(sp)
    800039d2:	e426                	sd	s1,8(sp)
    800039d4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d6:	00016517          	auipc	a0,0x16
    800039da:	99250513          	addi	a0,a0,-1646 # 80019368 <ftable>
    800039de:	00003097          	auipc	ra,0x3
    800039e2:	804080e7          	jalr	-2044(ra) # 800061e2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e6:	00016497          	auipc	s1,0x16
    800039ea:	99a48493          	addi	s1,s1,-1638 # 80019380 <ftable+0x18>
    800039ee:	00017717          	auipc	a4,0x17
    800039f2:	93270713          	addi	a4,a4,-1742 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039f6:	40dc                	lw	a5,4(s1)
    800039f8:	cf99                	beqz	a5,80003a16 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fa:	02848493          	addi	s1,s1,40
    800039fe:	fee49ce3          	bne	s1,a4,800039f6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a02:	00016517          	auipc	a0,0x16
    80003a06:	96650513          	addi	a0,a0,-1690 # 80019368 <ftable>
    80003a0a:	00003097          	auipc	ra,0x3
    80003a0e:	88c080e7          	jalr	-1908(ra) # 80006296 <release>
  return 0;
    80003a12:	4481                	li	s1,0
    80003a14:	a819                	j	80003a2a <filealloc+0x5e>
      f->ref = 1;
    80003a16:	4785                	li	a5,1
    80003a18:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a1a:	00016517          	auipc	a0,0x16
    80003a1e:	94e50513          	addi	a0,a0,-1714 # 80019368 <ftable>
    80003a22:	00003097          	auipc	ra,0x3
    80003a26:	874080e7          	jalr	-1932(ra) # 80006296 <release>
}
    80003a2a:	8526                	mv	a0,s1
    80003a2c:	60e2                	ld	ra,24(sp)
    80003a2e:	6442                	ld	s0,16(sp)
    80003a30:	64a2                	ld	s1,8(sp)
    80003a32:	6105                	addi	sp,sp,32
    80003a34:	8082                	ret

0000000080003a36 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a36:	1101                	addi	sp,sp,-32
    80003a38:	ec06                	sd	ra,24(sp)
    80003a3a:	e822                	sd	s0,16(sp)
    80003a3c:	e426                	sd	s1,8(sp)
    80003a3e:	1000                	addi	s0,sp,32
    80003a40:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a42:	00016517          	auipc	a0,0x16
    80003a46:	92650513          	addi	a0,a0,-1754 # 80019368 <ftable>
    80003a4a:	00002097          	auipc	ra,0x2
    80003a4e:	798080e7          	jalr	1944(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003a52:	40dc                	lw	a5,4(s1)
    80003a54:	02f05263          	blez	a5,80003a78 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a58:	2785                	addiw	a5,a5,1
    80003a5a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a5c:	00016517          	auipc	a0,0x16
    80003a60:	90c50513          	addi	a0,a0,-1780 # 80019368 <ftable>
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	832080e7          	jalr	-1998(ra) # 80006296 <release>
  return f;
}
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	60e2                	ld	ra,24(sp)
    80003a70:	6442                	ld	s0,16(sp)
    80003a72:	64a2                	ld	s1,8(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret
    panic("filedup");
    80003a78:	00005517          	auipc	a0,0x5
    80003a7c:	d2050513          	addi	a0,a0,-736 # 80008798 <syscall_names+0x248>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	218080e7          	jalr	536(ra) # 80005c98 <panic>

0000000080003a88 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a88:	7139                	addi	sp,sp,-64
    80003a8a:	fc06                	sd	ra,56(sp)
    80003a8c:	f822                	sd	s0,48(sp)
    80003a8e:	f426                	sd	s1,40(sp)
    80003a90:	f04a                	sd	s2,32(sp)
    80003a92:	ec4e                	sd	s3,24(sp)
    80003a94:	e852                	sd	s4,16(sp)
    80003a96:	e456                	sd	s5,8(sp)
    80003a98:	0080                	addi	s0,sp,64
    80003a9a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a9c:	00016517          	auipc	a0,0x16
    80003aa0:	8cc50513          	addi	a0,a0,-1844 # 80019368 <ftable>
    80003aa4:	00002097          	auipc	ra,0x2
    80003aa8:	73e080e7          	jalr	1854(ra) # 800061e2 <acquire>
  if(f->ref < 1)
    80003aac:	40dc                	lw	a5,4(s1)
    80003aae:	06f05163          	blez	a5,80003b10 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ab2:	37fd                	addiw	a5,a5,-1
    80003ab4:	0007871b          	sext.w	a4,a5
    80003ab8:	c0dc                	sw	a5,4(s1)
    80003aba:	06e04363          	bgtz	a4,80003b20 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003abe:	0004a903          	lw	s2,0(s1)
    80003ac2:	0094ca83          	lbu	s5,9(s1)
    80003ac6:	0104ba03          	ld	s4,16(s1)
    80003aca:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ace:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ad2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad6:	00016517          	auipc	a0,0x16
    80003ada:	89250513          	addi	a0,a0,-1902 # 80019368 <ftable>
    80003ade:	00002097          	auipc	ra,0x2
    80003ae2:	7b8080e7          	jalr	1976(ra) # 80006296 <release>

  if(ff.type == FD_PIPE){
    80003ae6:	4785                	li	a5,1
    80003ae8:	04f90d63          	beq	s2,a5,80003b42 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aec:	3979                	addiw	s2,s2,-2
    80003aee:	4785                	li	a5,1
    80003af0:	0527e063          	bltu	a5,s2,80003b30 <fileclose+0xa8>
    begin_op();
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	ac8080e7          	jalr	-1336(ra) # 800035bc <begin_op>
    iput(ff.ip);
    80003afc:	854e                	mv	a0,s3
    80003afe:	fffff097          	auipc	ra,0xfffff
    80003b02:	2a6080e7          	jalr	678(ra) # 80002da4 <iput>
    end_op();
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	b36080e7          	jalr	-1226(ra) # 8000363c <end_op>
    80003b0e:	a00d                	j	80003b30 <fileclose+0xa8>
    panic("fileclose");
    80003b10:	00005517          	auipc	a0,0x5
    80003b14:	c9050513          	addi	a0,a0,-880 # 800087a0 <syscall_names+0x250>
    80003b18:	00002097          	auipc	ra,0x2
    80003b1c:	180080e7          	jalr	384(ra) # 80005c98 <panic>
    release(&ftable.lock);
    80003b20:	00016517          	auipc	a0,0x16
    80003b24:	84850513          	addi	a0,a0,-1976 # 80019368 <ftable>
    80003b28:	00002097          	auipc	ra,0x2
    80003b2c:	76e080e7          	jalr	1902(ra) # 80006296 <release>
  }
}
    80003b30:	70e2                	ld	ra,56(sp)
    80003b32:	7442                	ld	s0,48(sp)
    80003b34:	74a2                	ld	s1,40(sp)
    80003b36:	7902                	ld	s2,32(sp)
    80003b38:	69e2                	ld	s3,24(sp)
    80003b3a:	6a42                	ld	s4,16(sp)
    80003b3c:	6aa2                	ld	s5,8(sp)
    80003b3e:	6121                	addi	sp,sp,64
    80003b40:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b42:	85d6                	mv	a1,s5
    80003b44:	8552                	mv	a0,s4
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	34c080e7          	jalr	844(ra) # 80003e92 <pipeclose>
    80003b4e:	b7cd                	j	80003b30 <fileclose+0xa8>

0000000080003b50 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b50:	715d                	addi	sp,sp,-80
    80003b52:	e486                	sd	ra,72(sp)
    80003b54:	e0a2                	sd	s0,64(sp)
    80003b56:	fc26                	sd	s1,56(sp)
    80003b58:	f84a                	sd	s2,48(sp)
    80003b5a:	f44e                	sd	s3,40(sp)
    80003b5c:	0880                	addi	s0,sp,80
    80003b5e:	84aa                	mv	s1,a0
    80003b60:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b62:	ffffd097          	auipc	ra,0xffffd
    80003b66:	330080e7          	jalr	816(ra) # 80000e92 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b6a:	409c                	lw	a5,0(s1)
    80003b6c:	37f9                	addiw	a5,a5,-2
    80003b6e:	4705                	li	a4,1
    80003b70:	04f76763          	bltu	a4,a5,80003bbe <filestat+0x6e>
    80003b74:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b76:	6c88                	ld	a0,24(s1)
    80003b78:	fffff097          	auipc	ra,0xfffff
    80003b7c:	072080e7          	jalr	114(ra) # 80002bea <ilock>
    stati(f->ip, &st);
    80003b80:	fb840593          	addi	a1,s0,-72
    80003b84:	6c88                	ld	a0,24(s1)
    80003b86:	fffff097          	auipc	ra,0xfffff
    80003b8a:	2ee080e7          	jalr	750(ra) # 80002e74 <stati>
    iunlock(f->ip);
    80003b8e:	6c88                	ld	a0,24(s1)
    80003b90:	fffff097          	auipc	ra,0xfffff
    80003b94:	11c080e7          	jalr	284(ra) # 80002cac <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b98:	46e1                	li	a3,24
    80003b9a:	fb840613          	addi	a2,s0,-72
    80003b9e:	85ce                	mv	a1,s3
    80003ba0:	05093503          	ld	a0,80(s2)
    80003ba4:	ffffd097          	auipc	ra,0xffffd
    80003ba8:	fb0080e7          	jalr	-80(ra) # 80000b54 <copyout>
    80003bac:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bb0:	60a6                	ld	ra,72(sp)
    80003bb2:	6406                	ld	s0,64(sp)
    80003bb4:	74e2                	ld	s1,56(sp)
    80003bb6:	7942                	ld	s2,48(sp)
    80003bb8:	79a2                	ld	s3,40(sp)
    80003bba:	6161                	addi	sp,sp,80
    80003bbc:	8082                	ret
  return -1;
    80003bbe:	557d                	li	a0,-1
    80003bc0:	bfc5                	j	80003bb0 <filestat+0x60>

0000000080003bc2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bc2:	7179                	addi	sp,sp,-48
    80003bc4:	f406                	sd	ra,40(sp)
    80003bc6:	f022                	sd	s0,32(sp)
    80003bc8:	ec26                	sd	s1,24(sp)
    80003bca:	e84a                	sd	s2,16(sp)
    80003bcc:	e44e                	sd	s3,8(sp)
    80003bce:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bd0:	00854783          	lbu	a5,8(a0)
    80003bd4:	c3d5                	beqz	a5,80003c78 <fileread+0xb6>
    80003bd6:	84aa                	mv	s1,a0
    80003bd8:	89ae                	mv	s3,a1
    80003bda:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bdc:	411c                	lw	a5,0(a0)
    80003bde:	4705                	li	a4,1
    80003be0:	04e78963          	beq	a5,a4,80003c32 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003be4:	470d                	li	a4,3
    80003be6:	04e78d63          	beq	a5,a4,80003c40 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bea:	4709                	li	a4,2
    80003bec:	06e79e63          	bne	a5,a4,80003c68 <fileread+0xa6>
    ilock(f->ip);
    80003bf0:	6d08                	ld	a0,24(a0)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	ff8080e7          	jalr	-8(ra) # 80002bea <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bfa:	874a                	mv	a4,s2
    80003bfc:	5094                	lw	a3,32(s1)
    80003bfe:	864e                	mv	a2,s3
    80003c00:	4585                	li	a1,1
    80003c02:	6c88                	ld	a0,24(s1)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	29a080e7          	jalr	666(ra) # 80002e9e <readi>
    80003c0c:	892a                	mv	s2,a0
    80003c0e:	00a05563          	blez	a0,80003c18 <fileread+0x56>
      f->off += r;
    80003c12:	509c                	lw	a5,32(s1)
    80003c14:	9fa9                	addw	a5,a5,a0
    80003c16:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c18:	6c88                	ld	a0,24(s1)
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	092080e7          	jalr	146(ra) # 80002cac <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c22:	854a                	mv	a0,s2
    80003c24:	70a2                	ld	ra,40(sp)
    80003c26:	7402                	ld	s0,32(sp)
    80003c28:	64e2                	ld	s1,24(sp)
    80003c2a:	6942                	ld	s2,16(sp)
    80003c2c:	69a2                	ld	s3,8(sp)
    80003c2e:	6145                	addi	sp,sp,48
    80003c30:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c32:	6908                	ld	a0,16(a0)
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	3c8080e7          	jalr	968(ra) # 80003ffc <piperead>
    80003c3c:	892a                	mv	s2,a0
    80003c3e:	b7d5                	j	80003c22 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c40:	02451783          	lh	a5,36(a0)
    80003c44:	03079693          	slli	a3,a5,0x30
    80003c48:	92c1                	srli	a3,a3,0x30
    80003c4a:	4725                	li	a4,9
    80003c4c:	02d76863          	bltu	a4,a3,80003c7c <fileread+0xba>
    80003c50:	0792                	slli	a5,a5,0x4
    80003c52:	00015717          	auipc	a4,0x15
    80003c56:	67670713          	addi	a4,a4,1654 # 800192c8 <devsw>
    80003c5a:	97ba                	add	a5,a5,a4
    80003c5c:	639c                	ld	a5,0(a5)
    80003c5e:	c38d                	beqz	a5,80003c80 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c60:	4505                	li	a0,1
    80003c62:	9782                	jalr	a5
    80003c64:	892a                	mv	s2,a0
    80003c66:	bf75                	j	80003c22 <fileread+0x60>
    panic("fileread");
    80003c68:	00005517          	auipc	a0,0x5
    80003c6c:	b4850513          	addi	a0,a0,-1208 # 800087b0 <syscall_names+0x260>
    80003c70:	00002097          	auipc	ra,0x2
    80003c74:	028080e7          	jalr	40(ra) # 80005c98 <panic>
    return -1;
    80003c78:	597d                	li	s2,-1
    80003c7a:	b765                	j	80003c22 <fileread+0x60>
      return -1;
    80003c7c:	597d                	li	s2,-1
    80003c7e:	b755                	j	80003c22 <fileread+0x60>
    80003c80:	597d                	li	s2,-1
    80003c82:	b745                	j	80003c22 <fileread+0x60>

0000000080003c84 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c84:	715d                	addi	sp,sp,-80
    80003c86:	e486                	sd	ra,72(sp)
    80003c88:	e0a2                	sd	s0,64(sp)
    80003c8a:	fc26                	sd	s1,56(sp)
    80003c8c:	f84a                	sd	s2,48(sp)
    80003c8e:	f44e                	sd	s3,40(sp)
    80003c90:	f052                	sd	s4,32(sp)
    80003c92:	ec56                	sd	s5,24(sp)
    80003c94:	e85a                	sd	s6,16(sp)
    80003c96:	e45e                	sd	s7,8(sp)
    80003c98:	e062                	sd	s8,0(sp)
    80003c9a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c9c:	00954783          	lbu	a5,9(a0)
    80003ca0:	10078663          	beqz	a5,80003dac <filewrite+0x128>
    80003ca4:	892a                	mv	s2,a0
    80003ca6:	8aae                	mv	s5,a1
    80003ca8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003caa:	411c                	lw	a5,0(a0)
    80003cac:	4705                	li	a4,1
    80003cae:	02e78263          	beq	a5,a4,80003cd2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cb2:	470d                	li	a4,3
    80003cb4:	02e78663          	beq	a5,a4,80003ce0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb8:	4709                	li	a4,2
    80003cba:	0ee79163          	bne	a5,a4,80003d9c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cbe:	0ac05d63          	blez	a2,80003d78 <filewrite+0xf4>
    int i = 0;
    80003cc2:	4981                	li	s3,0
    80003cc4:	6b05                	lui	s6,0x1
    80003cc6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cca:	6b85                	lui	s7,0x1
    80003ccc:	c00b8b9b          	addiw	s7,s7,-1024
    80003cd0:	a861                	j	80003d68 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cd2:	6908                	ld	a0,16(a0)
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	22e080e7          	jalr	558(ra) # 80003f02 <pipewrite>
    80003cdc:	8a2a                	mv	s4,a0
    80003cde:	a045                	j	80003d7e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ce0:	02451783          	lh	a5,36(a0)
    80003ce4:	03079693          	slli	a3,a5,0x30
    80003ce8:	92c1                	srli	a3,a3,0x30
    80003cea:	4725                	li	a4,9
    80003cec:	0cd76263          	bltu	a4,a3,80003db0 <filewrite+0x12c>
    80003cf0:	0792                	slli	a5,a5,0x4
    80003cf2:	00015717          	auipc	a4,0x15
    80003cf6:	5d670713          	addi	a4,a4,1494 # 800192c8 <devsw>
    80003cfa:	97ba                	add	a5,a5,a4
    80003cfc:	679c                	ld	a5,8(a5)
    80003cfe:	cbdd                	beqz	a5,80003db4 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d00:	4505                	li	a0,1
    80003d02:	9782                	jalr	a5
    80003d04:	8a2a                	mv	s4,a0
    80003d06:	a8a5                	j	80003d7e <filewrite+0xfa>
    80003d08:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d0c:	00000097          	auipc	ra,0x0
    80003d10:	8b0080e7          	jalr	-1872(ra) # 800035bc <begin_op>
      ilock(f->ip);
    80003d14:	01893503          	ld	a0,24(s2)
    80003d18:	fffff097          	auipc	ra,0xfffff
    80003d1c:	ed2080e7          	jalr	-302(ra) # 80002bea <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d20:	8762                	mv	a4,s8
    80003d22:	02092683          	lw	a3,32(s2)
    80003d26:	01598633          	add	a2,s3,s5
    80003d2a:	4585                	li	a1,1
    80003d2c:	01893503          	ld	a0,24(s2)
    80003d30:	fffff097          	auipc	ra,0xfffff
    80003d34:	266080e7          	jalr	614(ra) # 80002f96 <writei>
    80003d38:	84aa                	mv	s1,a0
    80003d3a:	00a05763          	blez	a0,80003d48 <filewrite+0xc4>
        f->off += r;
    80003d3e:	02092783          	lw	a5,32(s2)
    80003d42:	9fa9                	addw	a5,a5,a0
    80003d44:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d48:	01893503          	ld	a0,24(s2)
    80003d4c:	fffff097          	auipc	ra,0xfffff
    80003d50:	f60080e7          	jalr	-160(ra) # 80002cac <iunlock>
      end_op();
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	8e8080e7          	jalr	-1816(ra) # 8000363c <end_op>

      if(r != n1){
    80003d5c:	009c1f63          	bne	s8,s1,80003d7a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d60:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d64:	0149db63          	bge	s3,s4,80003d7a <filewrite+0xf6>
      int n1 = n - i;
    80003d68:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d6c:	84be                	mv	s1,a5
    80003d6e:	2781                	sext.w	a5,a5
    80003d70:	f8fb5ce3          	bge	s6,a5,80003d08 <filewrite+0x84>
    80003d74:	84de                	mv	s1,s7
    80003d76:	bf49                	j	80003d08 <filewrite+0x84>
    int i = 0;
    80003d78:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d7a:	013a1f63          	bne	s4,s3,80003d98 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d7e:	8552                	mv	a0,s4
    80003d80:	60a6                	ld	ra,72(sp)
    80003d82:	6406                	ld	s0,64(sp)
    80003d84:	74e2                	ld	s1,56(sp)
    80003d86:	7942                	ld	s2,48(sp)
    80003d88:	79a2                	ld	s3,40(sp)
    80003d8a:	7a02                	ld	s4,32(sp)
    80003d8c:	6ae2                	ld	s5,24(sp)
    80003d8e:	6b42                	ld	s6,16(sp)
    80003d90:	6ba2                	ld	s7,8(sp)
    80003d92:	6c02                	ld	s8,0(sp)
    80003d94:	6161                	addi	sp,sp,80
    80003d96:	8082                	ret
    ret = (i == n ? n : -1);
    80003d98:	5a7d                	li	s4,-1
    80003d9a:	b7d5                	j	80003d7e <filewrite+0xfa>
    panic("filewrite");
    80003d9c:	00005517          	auipc	a0,0x5
    80003da0:	a2450513          	addi	a0,a0,-1500 # 800087c0 <syscall_names+0x270>
    80003da4:	00002097          	auipc	ra,0x2
    80003da8:	ef4080e7          	jalr	-268(ra) # 80005c98 <panic>
    return -1;
    80003dac:	5a7d                	li	s4,-1
    80003dae:	bfc1                	j	80003d7e <filewrite+0xfa>
      return -1;
    80003db0:	5a7d                	li	s4,-1
    80003db2:	b7f1                	j	80003d7e <filewrite+0xfa>
    80003db4:	5a7d                	li	s4,-1
    80003db6:	b7e1                	j	80003d7e <filewrite+0xfa>

0000000080003db8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db8:	7179                	addi	sp,sp,-48
    80003dba:	f406                	sd	ra,40(sp)
    80003dbc:	f022                	sd	s0,32(sp)
    80003dbe:	ec26                	sd	s1,24(sp)
    80003dc0:	e84a                	sd	s2,16(sp)
    80003dc2:	e44e                	sd	s3,8(sp)
    80003dc4:	e052                	sd	s4,0(sp)
    80003dc6:	1800                	addi	s0,sp,48
    80003dc8:	84aa                	mv	s1,a0
    80003dca:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dcc:	0005b023          	sd	zero,0(a1)
    80003dd0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	bf8080e7          	jalr	-1032(ra) # 800039cc <filealloc>
    80003ddc:	e088                	sd	a0,0(s1)
    80003dde:	c551                	beqz	a0,80003e6a <pipealloc+0xb2>
    80003de0:	00000097          	auipc	ra,0x0
    80003de4:	bec080e7          	jalr	-1044(ra) # 800039cc <filealloc>
    80003de8:	00aa3023          	sd	a0,0(s4)
    80003dec:	c92d                	beqz	a0,80003e5e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dee:	ffffc097          	auipc	ra,0xffffc
    80003df2:	32a080e7          	jalr	810(ra) # 80000118 <kalloc>
    80003df6:	892a                	mv	s2,a0
    80003df8:	c125                	beqz	a0,80003e58 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dfa:	4985                	li	s3,1
    80003dfc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e00:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e04:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e08:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e0c:	00004597          	auipc	a1,0x4
    80003e10:	5d458593          	addi	a1,a1,1492 # 800083e0 <states.1710+0x1a0>
    80003e14:	00002097          	auipc	ra,0x2
    80003e18:	33e080e7          	jalr	830(ra) # 80006152 <initlock>
  (*f0)->type = FD_PIPE;
    80003e1c:	609c                	ld	a5,0(s1)
    80003e1e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e22:	609c                	ld	a5,0(s1)
    80003e24:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e28:	609c                	ld	a5,0(s1)
    80003e2a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e2e:	609c                	ld	a5,0(s1)
    80003e30:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e34:	000a3783          	ld	a5,0(s4)
    80003e38:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e3c:	000a3783          	ld	a5,0(s4)
    80003e40:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e44:	000a3783          	ld	a5,0(s4)
    80003e48:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e4c:	000a3783          	ld	a5,0(s4)
    80003e50:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e54:	4501                	li	a0,0
    80003e56:	a025                	j	80003e7e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e58:	6088                	ld	a0,0(s1)
    80003e5a:	e501                	bnez	a0,80003e62 <pipealloc+0xaa>
    80003e5c:	a039                	j	80003e6a <pipealloc+0xb2>
    80003e5e:	6088                	ld	a0,0(s1)
    80003e60:	c51d                	beqz	a0,80003e8e <pipealloc+0xd6>
    fileclose(*f0);
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	c26080e7          	jalr	-986(ra) # 80003a88 <fileclose>
  if(*f1)
    80003e6a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e6e:	557d                	li	a0,-1
  if(*f1)
    80003e70:	c799                	beqz	a5,80003e7e <pipealloc+0xc6>
    fileclose(*f1);
    80003e72:	853e                	mv	a0,a5
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	c14080e7          	jalr	-1004(ra) # 80003a88 <fileclose>
  return -1;
    80003e7c:	557d                	li	a0,-1
}
    80003e7e:	70a2                	ld	ra,40(sp)
    80003e80:	7402                	ld	s0,32(sp)
    80003e82:	64e2                	ld	s1,24(sp)
    80003e84:	6942                	ld	s2,16(sp)
    80003e86:	69a2                	ld	s3,8(sp)
    80003e88:	6a02                	ld	s4,0(sp)
    80003e8a:	6145                	addi	sp,sp,48
    80003e8c:	8082                	ret
  return -1;
    80003e8e:	557d                	li	a0,-1
    80003e90:	b7fd                	j	80003e7e <pipealloc+0xc6>

0000000080003e92 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e92:	1101                	addi	sp,sp,-32
    80003e94:	ec06                	sd	ra,24(sp)
    80003e96:	e822                	sd	s0,16(sp)
    80003e98:	e426                	sd	s1,8(sp)
    80003e9a:	e04a                	sd	s2,0(sp)
    80003e9c:	1000                	addi	s0,sp,32
    80003e9e:	84aa                	mv	s1,a0
    80003ea0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	340080e7          	jalr	832(ra) # 800061e2 <acquire>
  if(writable){
    80003eaa:	02090d63          	beqz	s2,80003ee4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003eae:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb2:	21848513          	addi	a0,s1,536
    80003eb6:	ffffe097          	auipc	ra,0xffffe
    80003eba:	830080e7          	jalr	-2000(ra) # 800016e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ebe:	2204b783          	ld	a5,544(s1)
    80003ec2:	eb95                	bnez	a5,80003ef6 <pipeclose+0x64>
    release(&pi->lock);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	00002097          	auipc	ra,0x2
    80003eca:	3d0080e7          	jalr	976(ra) # 80006296 <release>
    kfree((char*)pi);
    80003ece:	8526                	mv	a0,s1
    80003ed0:	ffffc097          	auipc	ra,0xffffc
    80003ed4:	14c080e7          	jalr	332(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed8:	60e2                	ld	ra,24(sp)
    80003eda:	6442                	ld	s0,16(sp)
    80003edc:	64a2                	ld	s1,8(sp)
    80003ede:	6902                	ld	s2,0(sp)
    80003ee0:	6105                	addi	sp,sp,32
    80003ee2:	8082                	ret
    pi->readopen = 0;
    80003ee4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee8:	21c48513          	addi	a0,s1,540
    80003eec:	ffffd097          	auipc	ra,0xffffd
    80003ef0:	7fa080e7          	jalr	2042(ra) # 800016e6 <wakeup>
    80003ef4:	b7e9                	j	80003ebe <pipeclose+0x2c>
    release(&pi->lock);
    80003ef6:	8526                	mv	a0,s1
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	39e080e7          	jalr	926(ra) # 80006296 <release>
}
    80003f00:	bfe1                	j	80003ed8 <pipeclose+0x46>

0000000080003f02 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f02:	7159                	addi	sp,sp,-112
    80003f04:	f486                	sd	ra,104(sp)
    80003f06:	f0a2                	sd	s0,96(sp)
    80003f08:	eca6                	sd	s1,88(sp)
    80003f0a:	e8ca                	sd	s2,80(sp)
    80003f0c:	e4ce                	sd	s3,72(sp)
    80003f0e:	e0d2                	sd	s4,64(sp)
    80003f10:	fc56                	sd	s5,56(sp)
    80003f12:	f85a                	sd	s6,48(sp)
    80003f14:	f45e                	sd	s7,40(sp)
    80003f16:	f062                	sd	s8,32(sp)
    80003f18:	ec66                	sd	s9,24(sp)
    80003f1a:	1880                	addi	s0,sp,112
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	8aae                	mv	s5,a1
    80003f20:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	f70080e7          	jalr	-144(ra) # 80000e92 <myproc>
    80003f2a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	2b4080e7          	jalr	692(ra) # 800061e2 <acquire>
  while(i < n){
    80003f36:	0d405163          	blez	s4,80003ff8 <pipewrite+0xf6>
    80003f3a:	8ba6                	mv	s7,s1
  int i = 0;
    80003f3c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f3e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f40:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f44:	21c48c13          	addi	s8,s1,540
    80003f48:	a08d                	j	80003faa <pipewrite+0xa8>
      release(&pi->lock);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	00002097          	auipc	ra,0x2
    80003f50:	34a080e7          	jalr	842(ra) # 80006296 <release>
      return -1;
    80003f54:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f56:	854a                	mv	a0,s2
    80003f58:	70a6                	ld	ra,104(sp)
    80003f5a:	7406                	ld	s0,96(sp)
    80003f5c:	64e6                	ld	s1,88(sp)
    80003f5e:	6946                	ld	s2,80(sp)
    80003f60:	69a6                	ld	s3,72(sp)
    80003f62:	6a06                	ld	s4,64(sp)
    80003f64:	7ae2                	ld	s5,56(sp)
    80003f66:	7b42                	ld	s6,48(sp)
    80003f68:	7ba2                	ld	s7,40(sp)
    80003f6a:	7c02                	ld	s8,32(sp)
    80003f6c:	6ce2                	ld	s9,24(sp)
    80003f6e:	6165                	addi	sp,sp,112
    80003f70:	8082                	ret
      wakeup(&pi->nread);
    80003f72:	8566                	mv	a0,s9
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	772080e7          	jalr	1906(ra) # 800016e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f7c:	85de                	mv	a1,s7
    80003f7e:	8562                	mv	a0,s8
    80003f80:	ffffd097          	auipc	ra,0xffffd
    80003f84:	5da080e7          	jalr	1498(ra) # 8000155a <sleep>
    80003f88:	a839                	j	80003fa6 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f8a:	21c4a783          	lw	a5,540(s1)
    80003f8e:	0017871b          	addiw	a4,a5,1
    80003f92:	20e4ae23          	sw	a4,540(s1)
    80003f96:	1ff7f793          	andi	a5,a5,511
    80003f9a:	97a6                	add	a5,a5,s1
    80003f9c:	f9f44703          	lbu	a4,-97(s0)
    80003fa0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fa4:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fa6:	03495d63          	bge	s2,s4,80003fe0 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003faa:	2204a783          	lw	a5,544(s1)
    80003fae:	dfd1                	beqz	a5,80003f4a <pipewrite+0x48>
    80003fb0:	0289a783          	lw	a5,40(s3)
    80003fb4:	fbd9                	bnez	a5,80003f4a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fb6:	2184a783          	lw	a5,536(s1)
    80003fba:	21c4a703          	lw	a4,540(s1)
    80003fbe:	2007879b          	addiw	a5,a5,512
    80003fc2:	faf708e3          	beq	a4,a5,80003f72 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc6:	4685                	li	a3,1
    80003fc8:	01590633          	add	a2,s2,s5
    80003fcc:	f9f40593          	addi	a1,s0,-97
    80003fd0:	0509b503          	ld	a0,80(s3)
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	c0c080e7          	jalr	-1012(ra) # 80000be0 <copyin>
    80003fdc:	fb6517e3          	bne	a0,s6,80003f8a <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fe0:	21848513          	addi	a0,s1,536
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	702080e7          	jalr	1794(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	2a8080e7          	jalr	680(ra) # 80006296 <release>
  return i;
    80003ff6:	b785                	j	80003f56 <pipewrite+0x54>
  int i = 0;
    80003ff8:	4901                	li	s2,0
    80003ffa:	b7dd                	j	80003fe0 <pipewrite+0xde>

0000000080003ffc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ffc:	715d                	addi	sp,sp,-80
    80003ffe:	e486                	sd	ra,72(sp)
    80004000:	e0a2                	sd	s0,64(sp)
    80004002:	fc26                	sd	s1,56(sp)
    80004004:	f84a                	sd	s2,48(sp)
    80004006:	f44e                	sd	s3,40(sp)
    80004008:	f052                	sd	s4,32(sp)
    8000400a:	ec56                	sd	s5,24(sp)
    8000400c:	e85a                	sd	s6,16(sp)
    8000400e:	0880                	addi	s0,sp,80
    80004010:	84aa                	mv	s1,a0
    80004012:	892e                	mv	s2,a1
    80004014:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	e7c080e7          	jalr	-388(ra) # 80000e92 <myproc>
    8000401e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004020:	8b26                	mv	s6,s1
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	1be080e7          	jalr	446(ra) # 800061e2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402c:	2184a703          	lw	a4,536(s1)
    80004030:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004034:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004038:	02f71463          	bne	a4,a5,80004060 <piperead+0x64>
    8000403c:	2244a783          	lw	a5,548(s1)
    80004040:	c385                	beqz	a5,80004060 <piperead+0x64>
    if(pr->killed){
    80004042:	028a2783          	lw	a5,40(s4)
    80004046:	ebc1                	bnez	a5,800040d6 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004048:	85da                	mv	a1,s6
    8000404a:	854e                	mv	a0,s3
    8000404c:	ffffd097          	auipc	ra,0xffffd
    80004050:	50e080e7          	jalr	1294(ra) # 8000155a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004054:	2184a703          	lw	a4,536(s1)
    80004058:	21c4a783          	lw	a5,540(s1)
    8000405c:	fef700e3          	beq	a4,a5,8000403c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004060:	09505263          	blez	s5,800040e4 <piperead+0xe8>
    80004064:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004066:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004068:	2184a783          	lw	a5,536(s1)
    8000406c:	21c4a703          	lw	a4,540(s1)
    80004070:	02f70d63          	beq	a4,a5,800040aa <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004074:	0017871b          	addiw	a4,a5,1
    80004078:	20e4ac23          	sw	a4,536(s1)
    8000407c:	1ff7f793          	andi	a5,a5,511
    80004080:	97a6                	add	a5,a5,s1
    80004082:	0187c783          	lbu	a5,24(a5)
    80004086:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000408a:	4685                	li	a3,1
    8000408c:	fbf40613          	addi	a2,s0,-65
    80004090:	85ca                	mv	a1,s2
    80004092:	050a3503          	ld	a0,80(s4)
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	abe080e7          	jalr	-1346(ra) # 80000b54 <copyout>
    8000409e:	01650663          	beq	a0,s6,800040aa <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a2:	2985                	addiw	s3,s3,1
    800040a4:	0905                	addi	s2,s2,1
    800040a6:	fd3a91e3          	bne	s5,s3,80004068 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040aa:	21c48513          	addi	a0,s1,540
    800040ae:	ffffd097          	auipc	ra,0xffffd
    800040b2:	638080e7          	jalr	1592(ra) # 800016e6 <wakeup>
  release(&pi->lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00002097          	auipc	ra,0x2
    800040bc:	1de080e7          	jalr	478(ra) # 80006296 <release>
  return i;
}
    800040c0:	854e                	mv	a0,s3
    800040c2:	60a6                	ld	ra,72(sp)
    800040c4:	6406                	ld	s0,64(sp)
    800040c6:	74e2                	ld	s1,56(sp)
    800040c8:	7942                	ld	s2,48(sp)
    800040ca:	79a2                	ld	s3,40(sp)
    800040cc:	7a02                	ld	s4,32(sp)
    800040ce:	6ae2                	ld	s5,24(sp)
    800040d0:	6b42                	ld	s6,16(sp)
    800040d2:	6161                	addi	sp,sp,80
    800040d4:	8082                	ret
      release(&pi->lock);
    800040d6:	8526                	mv	a0,s1
    800040d8:	00002097          	auipc	ra,0x2
    800040dc:	1be080e7          	jalr	446(ra) # 80006296 <release>
      return -1;
    800040e0:	59fd                	li	s3,-1
    800040e2:	bff9                	j	800040c0 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e4:	4981                	li	s3,0
    800040e6:	b7d1                	j	800040aa <piperead+0xae>

00000000800040e8 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040e8:	df010113          	addi	sp,sp,-528
    800040ec:	20113423          	sd	ra,520(sp)
    800040f0:	20813023          	sd	s0,512(sp)
    800040f4:	ffa6                	sd	s1,504(sp)
    800040f6:	fbca                	sd	s2,496(sp)
    800040f8:	f7ce                	sd	s3,488(sp)
    800040fa:	f3d2                	sd	s4,480(sp)
    800040fc:	efd6                	sd	s5,472(sp)
    800040fe:	ebda                	sd	s6,464(sp)
    80004100:	e7de                	sd	s7,456(sp)
    80004102:	e3e2                	sd	s8,448(sp)
    80004104:	ff66                	sd	s9,440(sp)
    80004106:	fb6a                	sd	s10,432(sp)
    80004108:	f76e                	sd	s11,424(sp)
    8000410a:	0c00                	addi	s0,sp,528
    8000410c:	84aa                	mv	s1,a0
    8000410e:	dea43c23          	sd	a0,-520(s0)
    80004112:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	d7c080e7          	jalr	-644(ra) # 80000e92 <myproc>
    8000411e:	892a                	mv	s2,a0

  begin_op();
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	49c080e7          	jalr	1180(ra) # 800035bc <begin_op>

  if((ip = namei(path)) == 0){
    80004128:	8526                	mv	a0,s1
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	276080e7          	jalr	630(ra) # 800033a0 <namei>
    80004132:	c92d                	beqz	a0,800041a4 <exec+0xbc>
    80004134:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	ab4080e7          	jalr	-1356(ra) # 80002bea <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000413e:	04000713          	li	a4,64
    80004142:	4681                	li	a3,0
    80004144:	e5040613          	addi	a2,s0,-432
    80004148:	4581                	li	a1,0
    8000414a:	8526                	mv	a0,s1
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	d52080e7          	jalr	-686(ra) # 80002e9e <readi>
    80004154:	04000793          	li	a5,64
    80004158:	00f51a63          	bne	a0,a5,8000416c <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000415c:	e5042703          	lw	a4,-432(s0)
    80004160:	464c47b7          	lui	a5,0x464c4
    80004164:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004168:	04f70463          	beq	a4,a5,800041b0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000416c:	8526                	mv	a0,s1
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	cde080e7          	jalr	-802(ra) # 80002e4c <iunlockput>
    end_op();
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	4c6080e7          	jalr	1222(ra) # 8000363c <end_op>
  }
  return -1;
    8000417e:	557d                	li	a0,-1
}
    80004180:	20813083          	ld	ra,520(sp)
    80004184:	20013403          	ld	s0,512(sp)
    80004188:	74fe                	ld	s1,504(sp)
    8000418a:	795e                	ld	s2,496(sp)
    8000418c:	79be                	ld	s3,488(sp)
    8000418e:	7a1e                	ld	s4,480(sp)
    80004190:	6afe                	ld	s5,472(sp)
    80004192:	6b5e                	ld	s6,464(sp)
    80004194:	6bbe                	ld	s7,456(sp)
    80004196:	6c1e                	ld	s8,448(sp)
    80004198:	7cfa                	ld	s9,440(sp)
    8000419a:	7d5a                	ld	s10,432(sp)
    8000419c:	7dba                	ld	s11,424(sp)
    8000419e:	21010113          	addi	sp,sp,528
    800041a2:	8082                	ret
    end_op();
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	498080e7          	jalr	1176(ra) # 8000363c <end_op>
    return -1;
    800041ac:	557d                	li	a0,-1
    800041ae:	bfc9                	j	80004180 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b0:	854a                	mv	a0,s2
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	da4080e7          	jalr	-604(ra) # 80000f56 <proc_pagetable>
    800041ba:	8baa                	mv	s7,a0
    800041bc:	d945                	beqz	a0,8000416c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041be:	e7042983          	lw	s3,-400(s0)
    800041c2:	e8845783          	lhu	a5,-376(s0)
    800041c6:	c7ad                	beqz	a5,80004230 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ca:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041cc:	6c85                	lui	s9,0x1
    800041ce:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041d2:	def43823          	sd	a5,-528(s0)
    800041d6:	a42d                	j	80004400 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041d8:	00004517          	auipc	a0,0x4
    800041dc:	5f850513          	addi	a0,a0,1528 # 800087d0 <syscall_names+0x280>
    800041e0:	00002097          	auipc	ra,0x2
    800041e4:	ab8080e7          	jalr	-1352(ra) # 80005c98 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041e8:	8756                	mv	a4,s5
    800041ea:	012d86bb          	addw	a3,s11,s2
    800041ee:	4581                	li	a1,0
    800041f0:	8526                	mv	a0,s1
    800041f2:	fffff097          	auipc	ra,0xfffff
    800041f6:	cac080e7          	jalr	-852(ra) # 80002e9e <readi>
    800041fa:	2501                	sext.w	a0,a0
    800041fc:	1aaa9963          	bne	s5,a0,800043ae <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004200:	6785                	lui	a5,0x1
    80004202:	0127893b          	addw	s2,a5,s2
    80004206:	77fd                	lui	a5,0xfffff
    80004208:	01478a3b          	addw	s4,a5,s4
    8000420c:	1f897163          	bgeu	s2,s8,800043ee <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004210:	02091593          	slli	a1,s2,0x20
    80004214:	9181                	srli	a1,a1,0x20
    80004216:	95ea                	add	a1,a1,s10
    80004218:	855e                	mv	a0,s7
    8000421a:	ffffc097          	auipc	ra,0xffffc
    8000421e:	336080e7          	jalr	822(ra) # 80000550 <walkaddr>
    80004222:	862a                	mv	a2,a0
    if(pa == 0)
    80004224:	d955                	beqz	a0,800041d8 <exec+0xf0>
      n = PGSIZE;
    80004226:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004228:	fd9a70e3          	bgeu	s4,s9,800041e8 <exec+0x100>
      n = sz - i;
    8000422c:	8ad2                	mv	s5,s4
    8000422e:	bf6d                	j	800041e8 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004230:	4901                	li	s2,0
  iunlockput(ip);
    80004232:	8526                	mv	a0,s1
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	c18080e7          	jalr	-1000(ra) # 80002e4c <iunlockput>
  end_op();
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	400080e7          	jalr	1024(ra) # 8000363c <end_op>
  p = myproc();
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	c4e080e7          	jalr	-946(ra) # 80000e92 <myproc>
    8000424c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000424e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004252:	6785                	lui	a5,0x1
    80004254:	17fd                	addi	a5,a5,-1
    80004256:	993e                	add	s2,s2,a5
    80004258:	757d                	lui	a0,0xfffff
    8000425a:	00a977b3          	and	a5,s2,a0
    8000425e:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004262:	6609                	lui	a2,0x2
    80004264:	963e                	add	a2,a2,a5
    80004266:	85be                	mv	a1,a5
    80004268:	855e                	mv	a0,s7
    8000426a:	ffffc097          	auipc	ra,0xffffc
    8000426e:	69a080e7          	jalr	1690(ra) # 80000904 <uvmalloc>
    80004272:	8b2a                	mv	s6,a0
  ip = 0;
    80004274:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004276:	12050c63          	beqz	a0,800043ae <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000427a:	75f9                	lui	a1,0xffffe
    8000427c:	95aa                	add	a1,a1,a0
    8000427e:	855e                	mv	a0,s7
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	8a2080e7          	jalr	-1886(ra) # 80000b22 <uvmclear>
  stackbase = sp - PGSIZE;
    80004288:	7c7d                	lui	s8,0xfffff
    8000428a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000428c:	e0043783          	ld	a5,-512(s0)
    80004290:	6388                	ld	a0,0(a5)
    80004292:	c535                	beqz	a0,800042fe <exec+0x216>
    80004294:	e9040993          	addi	s3,s0,-368
    80004298:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000429c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	0a8080e7          	jalr	168(ra) # 80000346 <strlen>
    800042a6:	2505                	addiw	a0,a0,1
    800042a8:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042ac:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042b0:	13896363          	bltu	s2,s8,800043d6 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042b4:	e0043d83          	ld	s11,-512(s0)
    800042b8:	000dba03          	ld	s4,0(s11)
    800042bc:	8552                	mv	a0,s4
    800042be:	ffffc097          	auipc	ra,0xffffc
    800042c2:	088080e7          	jalr	136(ra) # 80000346 <strlen>
    800042c6:	0015069b          	addiw	a3,a0,1
    800042ca:	8652                	mv	a2,s4
    800042cc:	85ca                	mv	a1,s2
    800042ce:	855e                	mv	a0,s7
    800042d0:	ffffd097          	auipc	ra,0xffffd
    800042d4:	884080e7          	jalr	-1916(ra) # 80000b54 <copyout>
    800042d8:	10054363          	bltz	a0,800043de <exec+0x2f6>
    ustack[argc] = sp;
    800042dc:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e0:	0485                	addi	s1,s1,1
    800042e2:	008d8793          	addi	a5,s11,8
    800042e6:	e0f43023          	sd	a5,-512(s0)
    800042ea:	008db503          	ld	a0,8(s11)
    800042ee:	c911                	beqz	a0,80004302 <exec+0x21a>
    if(argc >= MAXARG)
    800042f0:	09a1                	addi	s3,s3,8
    800042f2:	fb3c96e3          	bne	s9,s3,8000429e <exec+0x1b6>
  sz = sz1;
    800042f6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042fa:	4481                	li	s1,0
    800042fc:	a84d                	j	800043ae <exec+0x2c6>
  sp = sz;
    800042fe:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004300:	4481                	li	s1,0
  ustack[argc] = 0;
    80004302:	00349793          	slli	a5,s1,0x3
    80004306:	f9040713          	addi	a4,s0,-112
    8000430a:	97ba                	add	a5,a5,a4
    8000430c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004310:	00148693          	addi	a3,s1,1
    80004314:	068e                	slli	a3,a3,0x3
    80004316:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000431a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000431e:	01897663          	bgeu	s2,s8,8000432a <exec+0x242>
  sz = sz1;
    80004322:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004326:	4481                	li	s1,0
    80004328:	a059                	j	800043ae <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000432a:	e9040613          	addi	a2,s0,-368
    8000432e:	85ca                	mv	a1,s2
    80004330:	855e                	mv	a0,s7
    80004332:	ffffd097          	auipc	ra,0xffffd
    80004336:	822080e7          	jalr	-2014(ra) # 80000b54 <copyout>
    8000433a:	0a054663          	bltz	a0,800043e6 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000433e:	058ab783          	ld	a5,88(s5)
    80004342:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004346:	df843783          	ld	a5,-520(s0)
    8000434a:	0007c703          	lbu	a4,0(a5)
    8000434e:	cf11                	beqz	a4,8000436a <exec+0x282>
    80004350:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004352:	02f00693          	li	a3,47
    80004356:	a039                	j	80004364 <exec+0x27c>
      last = s+1;
    80004358:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000435c:	0785                	addi	a5,a5,1
    8000435e:	fff7c703          	lbu	a4,-1(a5)
    80004362:	c701                	beqz	a4,8000436a <exec+0x282>
    if(*s == '/')
    80004364:	fed71ce3          	bne	a4,a3,8000435c <exec+0x274>
    80004368:	bfc5                	j	80004358 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000436a:	4641                	li	a2,16
    8000436c:	df843583          	ld	a1,-520(s0)
    80004370:	158a8513          	addi	a0,s5,344
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	fa0080e7          	jalr	-96(ra) # 80000314 <safestrcpy>
  oldpagetable = p->pagetable;
    8000437c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004380:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004384:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004388:	058ab783          	ld	a5,88(s5)
    8000438c:	e6843703          	ld	a4,-408(s0)
    80004390:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004392:	058ab783          	ld	a5,88(s5)
    80004396:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000439a:	85ea                	mv	a1,s10
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	c56080e7          	jalr	-938(ra) # 80000ff2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043a4:	0004851b          	sext.w	a0,s1
    800043a8:	bbe1                	j	80004180 <exec+0x98>
    800043aa:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043ae:	e0843583          	ld	a1,-504(s0)
    800043b2:	855e                	mv	a0,s7
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	c3e080e7          	jalr	-962(ra) # 80000ff2 <proc_freepagetable>
  if(ip){
    800043bc:	da0498e3          	bnez	s1,8000416c <exec+0x84>
  return -1;
    800043c0:	557d                	li	a0,-1
    800043c2:	bb7d                	j	80004180 <exec+0x98>
    800043c4:	e1243423          	sd	s2,-504(s0)
    800043c8:	b7dd                	j	800043ae <exec+0x2c6>
    800043ca:	e1243423          	sd	s2,-504(s0)
    800043ce:	b7c5                	j	800043ae <exec+0x2c6>
    800043d0:	e1243423          	sd	s2,-504(s0)
    800043d4:	bfe9                	j	800043ae <exec+0x2c6>
  sz = sz1;
    800043d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043da:	4481                	li	s1,0
    800043dc:	bfc9                	j	800043ae <exec+0x2c6>
  sz = sz1;
    800043de:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e2:	4481                	li	s1,0
    800043e4:	b7e9                	j	800043ae <exec+0x2c6>
  sz = sz1;
    800043e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ea:	4481                	li	s1,0
    800043ec:	b7c9                	j	800043ae <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043ee:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f2:	2b05                	addiw	s6,s6,1
    800043f4:	0389899b          	addiw	s3,s3,56
    800043f8:	e8845783          	lhu	a5,-376(s0)
    800043fc:	e2fb5be3          	bge	s6,a5,80004232 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004400:	2981                	sext.w	s3,s3
    80004402:	03800713          	li	a4,56
    80004406:	86ce                	mv	a3,s3
    80004408:	e1840613          	addi	a2,s0,-488
    8000440c:	4581                	li	a1,0
    8000440e:	8526                	mv	a0,s1
    80004410:	fffff097          	auipc	ra,0xfffff
    80004414:	a8e080e7          	jalr	-1394(ra) # 80002e9e <readi>
    80004418:	03800793          	li	a5,56
    8000441c:	f8f517e3          	bne	a0,a5,800043aa <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004420:	e1842783          	lw	a5,-488(s0)
    80004424:	4705                	li	a4,1
    80004426:	fce796e3          	bne	a5,a4,800043f2 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    8000442a:	e4043603          	ld	a2,-448(s0)
    8000442e:	e3843783          	ld	a5,-456(s0)
    80004432:	f8f669e3          	bltu	a2,a5,800043c4 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004436:	e2843783          	ld	a5,-472(s0)
    8000443a:	963e                	add	a2,a2,a5
    8000443c:	f8f667e3          	bltu	a2,a5,800043ca <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004440:	85ca                	mv	a1,s2
    80004442:	855e                	mv	a0,s7
    80004444:	ffffc097          	auipc	ra,0xffffc
    80004448:	4c0080e7          	jalr	1216(ra) # 80000904 <uvmalloc>
    8000444c:	e0a43423          	sd	a0,-504(s0)
    80004450:	d141                	beqz	a0,800043d0 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004452:	e2843d03          	ld	s10,-472(s0)
    80004456:	df043783          	ld	a5,-528(s0)
    8000445a:	00fd77b3          	and	a5,s10,a5
    8000445e:	fba1                	bnez	a5,800043ae <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004460:	e2042d83          	lw	s11,-480(s0)
    80004464:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004468:	f80c03e3          	beqz	s8,800043ee <exec+0x306>
    8000446c:	8a62                	mv	s4,s8
    8000446e:	4901                	li	s2,0
    80004470:	b345                	j	80004210 <exec+0x128>

0000000080004472 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004472:	7179                	addi	sp,sp,-48
    80004474:	f406                	sd	ra,40(sp)
    80004476:	f022                	sd	s0,32(sp)
    80004478:	ec26                	sd	s1,24(sp)
    8000447a:	e84a                	sd	s2,16(sp)
    8000447c:	1800                	addi	s0,sp,48
    8000447e:	892e                	mv	s2,a1
    80004480:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004482:	fdc40593          	addi	a1,s0,-36
    80004486:	ffffe097          	auipc	ra,0xffffe
    8000448a:	b1a080e7          	jalr	-1254(ra) # 80001fa0 <argint>
    8000448e:	04054063          	bltz	a0,800044ce <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004492:	fdc42703          	lw	a4,-36(s0)
    80004496:	47bd                	li	a5,15
    80004498:	02e7ed63          	bltu	a5,a4,800044d2 <argfd+0x60>
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	9f6080e7          	jalr	-1546(ra) # 80000e92 <myproc>
    800044a4:	fdc42703          	lw	a4,-36(s0)
    800044a8:	01a70793          	addi	a5,a4,26
    800044ac:	078e                	slli	a5,a5,0x3
    800044ae:	953e                	add	a0,a0,a5
    800044b0:	611c                	ld	a5,0(a0)
    800044b2:	c395                	beqz	a5,800044d6 <argfd+0x64>
    return -1;
  if(pfd)
    800044b4:	00090463          	beqz	s2,800044bc <argfd+0x4a>
    *pfd = fd;
    800044b8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044bc:	4501                	li	a0,0
  if(pf)
    800044be:	c091                	beqz	s1,800044c2 <argfd+0x50>
    *pf = f;
    800044c0:	e09c                	sd	a5,0(s1)
}
    800044c2:	70a2                	ld	ra,40(sp)
    800044c4:	7402                	ld	s0,32(sp)
    800044c6:	64e2                	ld	s1,24(sp)
    800044c8:	6942                	ld	s2,16(sp)
    800044ca:	6145                	addi	sp,sp,48
    800044cc:	8082                	ret
    return -1;
    800044ce:	557d                	li	a0,-1
    800044d0:	bfcd                	j	800044c2 <argfd+0x50>
    return -1;
    800044d2:	557d                	li	a0,-1
    800044d4:	b7fd                	j	800044c2 <argfd+0x50>
    800044d6:	557d                	li	a0,-1
    800044d8:	b7ed                	j	800044c2 <argfd+0x50>

00000000800044da <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044da:	1101                	addi	sp,sp,-32
    800044dc:	ec06                	sd	ra,24(sp)
    800044de:	e822                	sd	s0,16(sp)
    800044e0:	e426                	sd	s1,8(sp)
    800044e2:	1000                	addi	s0,sp,32
    800044e4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044e6:	ffffd097          	auipc	ra,0xffffd
    800044ea:	9ac080e7          	jalr	-1620(ra) # 80000e92 <myproc>
    800044ee:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044f0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044f4:	4501                	li	a0,0
    800044f6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044f8:	6398                	ld	a4,0(a5)
    800044fa:	cb19                	beqz	a4,80004510 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044fc:	2505                	addiw	a0,a0,1
    800044fe:	07a1                	addi	a5,a5,8
    80004500:	fed51ce3          	bne	a0,a3,800044f8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004504:	557d                	li	a0,-1
}
    80004506:	60e2                	ld	ra,24(sp)
    80004508:	6442                	ld	s0,16(sp)
    8000450a:	64a2                	ld	s1,8(sp)
    8000450c:	6105                	addi	sp,sp,32
    8000450e:	8082                	ret
      p->ofile[fd] = f;
    80004510:	01a50793          	addi	a5,a0,26
    80004514:	078e                	slli	a5,a5,0x3
    80004516:	963e                	add	a2,a2,a5
    80004518:	e204                	sd	s1,0(a2)
      return fd;
    8000451a:	b7f5                	j	80004506 <fdalloc+0x2c>

000000008000451c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000451c:	715d                	addi	sp,sp,-80
    8000451e:	e486                	sd	ra,72(sp)
    80004520:	e0a2                	sd	s0,64(sp)
    80004522:	fc26                	sd	s1,56(sp)
    80004524:	f84a                	sd	s2,48(sp)
    80004526:	f44e                	sd	s3,40(sp)
    80004528:	f052                	sd	s4,32(sp)
    8000452a:	ec56                	sd	s5,24(sp)
    8000452c:	0880                	addi	s0,sp,80
    8000452e:	89ae                	mv	s3,a1
    80004530:	8ab2                	mv	s5,a2
    80004532:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004534:	fb040593          	addi	a1,s0,-80
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	e86080e7          	jalr	-378(ra) # 800033be <nameiparent>
    80004540:	892a                	mv	s2,a0
    80004542:	12050f63          	beqz	a0,80004680 <create+0x164>
    return 0;

  ilock(dp);
    80004546:	ffffe097          	auipc	ra,0xffffe
    8000454a:	6a4080e7          	jalr	1700(ra) # 80002bea <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000454e:	4601                	li	a2,0
    80004550:	fb040593          	addi	a1,s0,-80
    80004554:	854a                	mv	a0,s2
    80004556:	fffff097          	auipc	ra,0xfffff
    8000455a:	b78080e7          	jalr	-1160(ra) # 800030ce <dirlookup>
    8000455e:	84aa                	mv	s1,a0
    80004560:	c921                	beqz	a0,800045b0 <create+0x94>
    iunlockput(dp);
    80004562:	854a                	mv	a0,s2
    80004564:	fffff097          	auipc	ra,0xfffff
    80004568:	8e8080e7          	jalr	-1816(ra) # 80002e4c <iunlockput>
    ilock(ip);
    8000456c:	8526                	mv	a0,s1
    8000456e:	ffffe097          	auipc	ra,0xffffe
    80004572:	67c080e7          	jalr	1660(ra) # 80002bea <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004576:	2981                	sext.w	s3,s3
    80004578:	4789                	li	a5,2
    8000457a:	02f99463          	bne	s3,a5,800045a2 <create+0x86>
    8000457e:	0444d783          	lhu	a5,68(s1)
    80004582:	37f9                	addiw	a5,a5,-2
    80004584:	17c2                	slli	a5,a5,0x30
    80004586:	93c1                	srli	a5,a5,0x30
    80004588:	4705                	li	a4,1
    8000458a:	00f76c63          	bltu	a4,a5,800045a2 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000458e:	8526                	mv	a0,s1
    80004590:	60a6                	ld	ra,72(sp)
    80004592:	6406                	ld	s0,64(sp)
    80004594:	74e2                	ld	s1,56(sp)
    80004596:	7942                	ld	s2,48(sp)
    80004598:	79a2                	ld	s3,40(sp)
    8000459a:	7a02                	ld	s4,32(sp)
    8000459c:	6ae2                	ld	s5,24(sp)
    8000459e:	6161                	addi	sp,sp,80
    800045a0:	8082                	ret
    iunlockput(ip);
    800045a2:	8526                	mv	a0,s1
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	8a8080e7          	jalr	-1880(ra) # 80002e4c <iunlockput>
    return 0;
    800045ac:	4481                	li	s1,0
    800045ae:	b7c5                	j	8000458e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800045b0:	85ce                	mv	a1,s3
    800045b2:	00092503          	lw	a0,0(s2)
    800045b6:	ffffe097          	auipc	ra,0xffffe
    800045ba:	49c080e7          	jalr	1180(ra) # 80002a52 <ialloc>
    800045be:	84aa                	mv	s1,a0
    800045c0:	c529                	beqz	a0,8000460a <create+0xee>
  ilock(ip);
    800045c2:	ffffe097          	auipc	ra,0xffffe
    800045c6:	628080e7          	jalr	1576(ra) # 80002bea <ilock>
  ip->major = major;
    800045ca:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045ce:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045d2:	4785                	li	a5,1
    800045d4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045d8:	8526                	mv	a0,s1
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	546080e7          	jalr	1350(ra) # 80002b20 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045e2:	2981                	sext.w	s3,s3
    800045e4:	4785                	li	a5,1
    800045e6:	02f98a63          	beq	s3,a5,8000461a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ea:	40d0                	lw	a2,4(s1)
    800045ec:	fb040593          	addi	a1,s0,-80
    800045f0:	854a                	mv	a0,s2
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	cec080e7          	jalr	-788(ra) # 800032de <dirlink>
    800045fa:	06054b63          	bltz	a0,80004670 <create+0x154>
  iunlockput(dp);
    800045fe:	854a                	mv	a0,s2
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	84c080e7          	jalr	-1972(ra) # 80002e4c <iunlockput>
  return ip;
    80004608:	b759                	j	8000458e <create+0x72>
    panic("create: ialloc");
    8000460a:	00004517          	auipc	a0,0x4
    8000460e:	1e650513          	addi	a0,a0,486 # 800087f0 <syscall_names+0x2a0>
    80004612:	00001097          	auipc	ra,0x1
    80004616:	686080e7          	jalr	1670(ra) # 80005c98 <panic>
    dp->nlink++;  // for ".."
    8000461a:	04a95783          	lhu	a5,74(s2)
    8000461e:	2785                	addiw	a5,a5,1
    80004620:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004624:	854a                	mv	a0,s2
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	4fa080e7          	jalr	1274(ra) # 80002b20 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000462e:	40d0                	lw	a2,4(s1)
    80004630:	00004597          	auipc	a1,0x4
    80004634:	1d058593          	addi	a1,a1,464 # 80008800 <syscall_names+0x2b0>
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	ca4080e7          	jalr	-860(ra) # 800032de <dirlink>
    80004642:	00054f63          	bltz	a0,80004660 <create+0x144>
    80004646:	00492603          	lw	a2,4(s2)
    8000464a:	00004597          	auipc	a1,0x4
    8000464e:	1be58593          	addi	a1,a1,446 # 80008808 <syscall_names+0x2b8>
    80004652:	8526                	mv	a0,s1
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	c8a080e7          	jalr	-886(ra) # 800032de <dirlink>
    8000465c:	f80557e3          	bgez	a0,800045ea <create+0xce>
      panic("create dots");
    80004660:	00004517          	auipc	a0,0x4
    80004664:	1b050513          	addi	a0,a0,432 # 80008810 <syscall_names+0x2c0>
    80004668:	00001097          	auipc	ra,0x1
    8000466c:	630080e7          	jalr	1584(ra) # 80005c98 <panic>
    panic("create: dirlink");
    80004670:	00004517          	auipc	a0,0x4
    80004674:	1b050513          	addi	a0,a0,432 # 80008820 <syscall_names+0x2d0>
    80004678:	00001097          	auipc	ra,0x1
    8000467c:	620080e7          	jalr	1568(ra) # 80005c98 <panic>
    return 0;
    80004680:	84aa                	mv	s1,a0
    80004682:	b731                	j	8000458e <create+0x72>

0000000080004684 <sys_dup>:
{
    80004684:	7179                	addi	sp,sp,-48
    80004686:	f406                	sd	ra,40(sp)
    80004688:	f022                	sd	s0,32(sp)
    8000468a:	ec26                	sd	s1,24(sp)
    8000468c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000468e:	fd840613          	addi	a2,s0,-40
    80004692:	4581                	li	a1,0
    80004694:	4501                	li	a0,0
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	ddc080e7          	jalr	-548(ra) # 80004472 <argfd>
    return -1;
    8000469e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046a0:	02054363          	bltz	a0,800046c6 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046a4:	fd843503          	ld	a0,-40(s0)
    800046a8:	00000097          	auipc	ra,0x0
    800046ac:	e32080e7          	jalr	-462(ra) # 800044da <fdalloc>
    800046b0:	84aa                	mv	s1,a0
    return -1;
    800046b2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046b4:	00054963          	bltz	a0,800046c6 <sys_dup+0x42>
  filedup(f);
    800046b8:	fd843503          	ld	a0,-40(s0)
    800046bc:	fffff097          	auipc	ra,0xfffff
    800046c0:	37a080e7          	jalr	890(ra) # 80003a36 <filedup>
  return fd;
    800046c4:	87a6                	mv	a5,s1
}
    800046c6:	853e                	mv	a0,a5
    800046c8:	70a2                	ld	ra,40(sp)
    800046ca:	7402                	ld	s0,32(sp)
    800046cc:	64e2                	ld	s1,24(sp)
    800046ce:	6145                	addi	sp,sp,48
    800046d0:	8082                	ret

00000000800046d2 <sys_read>:
{
    800046d2:	7179                	addi	sp,sp,-48
    800046d4:	f406                	sd	ra,40(sp)
    800046d6:	f022                	sd	s0,32(sp)
    800046d8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046da:	fe840613          	addi	a2,s0,-24
    800046de:	4581                	li	a1,0
    800046e0:	4501                	li	a0,0
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	d90080e7          	jalr	-624(ra) # 80004472 <argfd>
    return -1;
    800046ea:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ec:	04054163          	bltz	a0,8000472e <sys_read+0x5c>
    800046f0:	fe440593          	addi	a1,s0,-28
    800046f4:	4509                	li	a0,2
    800046f6:	ffffe097          	auipc	ra,0xffffe
    800046fa:	8aa080e7          	jalr	-1878(ra) # 80001fa0 <argint>
    return -1;
    800046fe:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004700:	02054763          	bltz	a0,8000472e <sys_read+0x5c>
    80004704:	fd840593          	addi	a1,s0,-40
    80004708:	4505                	li	a0,1
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	8b8080e7          	jalr	-1864(ra) # 80001fc2 <argaddr>
    return -1;
    80004712:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004714:	00054d63          	bltz	a0,8000472e <sys_read+0x5c>
  return fileread(f, p, n);
    80004718:	fe442603          	lw	a2,-28(s0)
    8000471c:	fd843583          	ld	a1,-40(s0)
    80004720:	fe843503          	ld	a0,-24(s0)
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	49e080e7          	jalr	1182(ra) # 80003bc2 <fileread>
    8000472c:	87aa                	mv	a5,a0
}
    8000472e:	853e                	mv	a0,a5
    80004730:	70a2                	ld	ra,40(sp)
    80004732:	7402                	ld	s0,32(sp)
    80004734:	6145                	addi	sp,sp,48
    80004736:	8082                	ret

0000000080004738 <sys_write>:
{
    80004738:	7179                	addi	sp,sp,-48
    8000473a:	f406                	sd	ra,40(sp)
    8000473c:	f022                	sd	s0,32(sp)
    8000473e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004740:	fe840613          	addi	a2,s0,-24
    80004744:	4581                	li	a1,0
    80004746:	4501                	li	a0,0
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	d2a080e7          	jalr	-726(ra) # 80004472 <argfd>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004752:	04054163          	bltz	a0,80004794 <sys_write+0x5c>
    80004756:	fe440593          	addi	a1,s0,-28
    8000475a:	4509                	li	a0,2
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	844080e7          	jalr	-1980(ra) # 80001fa0 <argint>
    return -1;
    80004764:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004766:	02054763          	bltz	a0,80004794 <sys_write+0x5c>
    8000476a:	fd840593          	addi	a1,s0,-40
    8000476e:	4505                	li	a0,1
    80004770:	ffffe097          	auipc	ra,0xffffe
    80004774:	852080e7          	jalr	-1966(ra) # 80001fc2 <argaddr>
    return -1;
    80004778:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477a:	00054d63          	bltz	a0,80004794 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000477e:	fe442603          	lw	a2,-28(s0)
    80004782:	fd843583          	ld	a1,-40(s0)
    80004786:	fe843503          	ld	a0,-24(s0)
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	4fa080e7          	jalr	1274(ra) # 80003c84 <filewrite>
    80004792:	87aa                	mv	a5,a0
}
    80004794:	853e                	mv	a0,a5
    80004796:	70a2                	ld	ra,40(sp)
    80004798:	7402                	ld	s0,32(sp)
    8000479a:	6145                	addi	sp,sp,48
    8000479c:	8082                	ret

000000008000479e <sys_close>:
{
    8000479e:	1101                	addi	sp,sp,-32
    800047a0:	ec06                	sd	ra,24(sp)
    800047a2:	e822                	sd	s0,16(sp)
    800047a4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047a6:	fe040613          	addi	a2,s0,-32
    800047aa:	fec40593          	addi	a1,s0,-20
    800047ae:	4501                	li	a0,0
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	cc2080e7          	jalr	-830(ra) # 80004472 <argfd>
    return -1;
    800047b8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047ba:	02054463          	bltz	a0,800047e2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047be:	ffffc097          	auipc	ra,0xffffc
    800047c2:	6d4080e7          	jalr	1748(ra) # 80000e92 <myproc>
    800047c6:	fec42783          	lw	a5,-20(s0)
    800047ca:	07e9                	addi	a5,a5,26
    800047cc:	078e                	slli	a5,a5,0x3
    800047ce:	97aa                	add	a5,a5,a0
    800047d0:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047d4:	fe043503          	ld	a0,-32(s0)
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	2b0080e7          	jalr	688(ra) # 80003a88 <fileclose>
  return 0;
    800047e0:	4781                	li	a5,0
}
    800047e2:	853e                	mv	a0,a5
    800047e4:	60e2                	ld	ra,24(sp)
    800047e6:	6442                	ld	s0,16(sp)
    800047e8:	6105                	addi	sp,sp,32
    800047ea:	8082                	ret

00000000800047ec <sys_fstat>:
{
    800047ec:	1101                	addi	sp,sp,-32
    800047ee:	ec06                	sd	ra,24(sp)
    800047f0:	e822                	sd	s0,16(sp)
    800047f2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f4:	fe840613          	addi	a2,s0,-24
    800047f8:	4581                	li	a1,0
    800047fa:	4501                	li	a0,0
    800047fc:	00000097          	auipc	ra,0x0
    80004800:	c76080e7          	jalr	-906(ra) # 80004472 <argfd>
    return -1;
    80004804:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004806:	02054563          	bltz	a0,80004830 <sys_fstat+0x44>
    8000480a:	fe040593          	addi	a1,s0,-32
    8000480e:	4505                	li	a0,1
    80004810:	ffffd097          	auipc	ra,0xffffd
    80004814:	7b2080e7          	jalr	1970(ra) # 80001fc2 <argaddr>
    return -1;
    80004818:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000481a:	00054b63          	bltz	a0,80004830 <sys_fstat+0x44>
  return filestat(f, st);
    8000481e:	fe043583          	ld	a1,-32(s0)
    80004822:	fe843503          	ld	a0,-24(s0)
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	32a080e7          	jalr	810(ra) # 80003b50 <filestat>
    8000482e:	87aa                	mv	a5,a0
}
    80004830:	853e                	mv	a0,a5
    80004832:	60e2                	ld	ra,24(sp)
    80004834:	6442                	ld	s0,16(sp)
    80004836:	6105                	addi	sp,sp,32
    80004838:	8082                	ret

000000008000483a <sys_link>:
{
    8000483a:	7169                	addi	sp,sp,-304
    8000483c:	f606                	sd	ra,296(sp)
    8000483e:	f222                	sd	s0,288(sp)
    80004840:	ee26                	sd	s1,280(sp)
    80004842:	ea4a                	sd	s2,272(sp)
    80004844:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004846:	08000613          	li	a2,128
    8000484a:	ed040593          	addi	a1,s0,-304
    8000484e:	4501                	li	a0,0
    80004850:	ffffd097          	auipc	ra,0xffffd
    80004854:	794080e7          	jalr	1940(ra) # 80001fe4 <argstr>
    return -1;
    80004858:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485a:	10054e63          	bltz	a0,80004976 <sys_link+0x13c>
    8000485e:	08000613          	li	a2,128
    80004862:	f5040593          	addi	a1,s0,-176
    80004866:	4505                	li	a0,1
    80004868:	ffffd097          	auipc	ra,0xffffd
    8000486c:	77c080e7          	jalr	1916(ra) # 80001fe4 <argstr>
    return -1;
    80004870:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004872:	10054263          	bltz	a0,80004976 <sys_link+0x13c>
  begin_op();
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	d46080e7          	jalr	-698(ra) # 800035bc <begin_op>
  if((ip = namei(old)) == 0){
    8000487e:	ed040513          	addi	a0,s0,-304
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	b1e080e7          	jalr	-1250(ra) # 800033a0 <namei>
    8000488a:	84aa                	mv	s1,a0
    8000488c:	c551                	beqz	a0,80004918 <sys_link+0xde>
  ilock(ip);
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	35c080e7          	jalr	860(ra) # 80002bea <ilock>
  if(ip->type == T_DIR){
    80004896:	04449703          	lh	a4,68(s1)
    8000489a:	4785                	li	a5,1
    8000489c:	08f70463          	beq	a4,a5,80004924 <sys_link+0xea>
  ip->nlink++;
    800048a0:	04a4d783          	lhu	a5,74(s1)
    800048a4:	2785                	addiw	a5,a5,1
    800048a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048aa:	8526                	mv	a0,s1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	274080e7          	jalr	628(ra) # 80002b20 <iupdate>
  iunlock(ip);
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	3f6080e7          	jalr	1014(ra) # 80002cac <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048be:	fd040593          	addi	a1,s0,-48
    800048c2:	f5040513          	addi	a0,s0,-176
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	af8080e7          	jalr	-1288(ra) # 800033be <nameiparent>
    800048ce:	892a                	mv	s2,a0
    800048d0:	c935                	beqz	a0,80004944 <sys_link+0x10a>
  ilock(dp);
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	318080e7          	jalr	792(ra) # 80002bea <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048da:	00092703          	lw	a4,0(s2)
    800048de:	409c                	lw	a5,0(s1)
    800048e0:	04f71d63          	bne	a4,a5,8000493a <sys_link+0x100>
    800048e4:	40d0                	lw	a2,4(s1)
    800048e6:	fd040593          	addi	a1,s0,-48
    800048ea:	854a                	mv	a0,s2
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	9f2080e7          	jalr	-1550(ra) # 800032de <dirlink>
    800048f4:	04054363          	bltz	a0,8000493a <sys_link+0x100>
  iunlockput(dp);
    800048f8:	854a                	mv	a0,s2
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	552080e7          	jalr	1362(ra) # 80002e4c <iunlockput>
  iput(ip);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffe097          	auipc	ra,0xffffe
    80004908:	4a0080e7          	jalr	1184(ra) # 80002da4 <iput>
  end_op();
    8000490c:	fffff097          	auipc	ra,0xfffff
    80004910:	d30080e7          	jalr	-720(ra) # 8000363c <end_op>
  return 0;
    80004914:	4781                	li	a5,0
    80004916:	a085                	j	80004976 <sys_link+0x13c>
    end_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	d24080e7          	jalr	-732(ra) # 8000363c <end_op>
    return -1;
    80004920:	57fd                	li	a5,-1
    80004922:	a891                	j	80004976 <sys_link+0x13c>
    iunlockput(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	526080e7          	jalr	1318(ra) # 80002e4c <iunlockput>
    end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	d0e080e7          	jalr	-754(ra) # 8000363c <end_op>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	a83d                	j	80004976 <sys_link+0x13c>
    iunlockput(dp);
    8000493a:	854a                	mv	a0,s2
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	510080e7          	jalr	1296(ra) # 80002e4c <iunlockput>
  ilock(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	2a4080e7          	jalr	676(ra) # 80002bea <ilock>
  ip->nlink--;
    8000494e:	04a4d783          	lhu	a5,74(s1)
    80004952:	37fd                	addiw	a5,a5,-1
    80004954:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	1c6080e7          	jalr	454(ra) # 80002b20 <iupdate>
  iunlockput(ip);
    80004962:	8526                	mv	a0,s1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	4e8080e7          	jalr	1256(ra) # 80002e4c <iunlockput>
  end_op();
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	cd0080e7          	jalr	-816(ra) # 8000363c <end_op>
  return -1;
    80004974:	57fd                	li	a5,-1
}
    80004976:	853e                	mv	a0,a5
    80004978:	70b2                	ld	ra,296(sp)
    8000497a:	7412                	ld	s0,288(sp)
    8000497c:	64f2                	ld	s1,280(sp)
    8000497e:	6952                	ld	s2,272(sp)
    80004980:	6155                	addi	sp,sp,304
    80004982:	8082                	ret

0000000080004984 <sys_unlink>:
{
    80004984:	7151                	addi	sp,sp,-240
    80004986:	f586                	sd	ra,232(sp)
    80004988:	f1a2                	sd	s0,224(sp)
    8000498a:	eda6                	sd	s1,216(sp)
    8000498c:	e9ca                	sd	s2,208(sp)
    8000498e:	e5ce                	sd	s3,200(sp)
    80004990:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004992:	08000613          	li	a2,128
    80004996:	f3040593          	addi	a1,s0,-208
    8000499a:	4501                	li	a0,0
    8000499c:	ffffd097          	auipc	ra,0xffffd
    800049a0:	648080e7          	jalr	1608(ra) # 80001fe4 <argstr>
    800049a4:	18054163          	bltz	a0,80004b26 <sys_unlink+0x1a2>
  begin_op();
    800049a8:	fffff097          	auipc	ra,0xfffff
    800049ac:	c14080e7          	jalr	-1004(ra) # 800035bc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049b0:	fb040593          	addi	a1,s0,-80
    800049b4:	f3040513          	addi	a0,s0,-208
    800049b8:	fffff097          	auipc	ra,0xfffff
    800049bc:	a06080e7          	jalr	-1530(ra) # 800033be <nameiparent>
    800049c0:	84aa                	mv	s1,a0
    800049c2:	c979                	beqz	a0,80004a98 <sys_unlink+0x114>
  ilock(dp);
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	226080e7          	jalr	550(ra) # 80002bea <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049cc:	00004597          	auipc	a1,0x4
    800049d0:	e3458593          	addi	a1,a1,-460 # 80008800 <syscall_names+0x2b0>
    800049d4:	fb040513          	addi	a0,s0,-80
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	6dc080e7          	jalr	1756(ra) # 800030b4 <namecmp>
    800049e0:	14050a63          	beqz	a0,80004b34 <sys_unlink+0x1b0>
    800049e4:	00004597          	auipc	a1,0x4
    800049e8:	e2458593          	addi	a1,a1,-476 # 80008808 <syscall_names+0x2b8>
    800049ec:	fb040513          	addi	a0,s0,-80
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	6c4080e7          	jalr	1732(ra) # 800030b4 <namecmp>
    800049f8:	12050e63          	beqz	a0,80004b34 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049fc:	f2c40613          	addi	a2,s0,-212
    80004a00:	fb040593          	addi	a1,s0,-80
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	6c8080e7          	jalr	1736(ra) # 800030ce <dirlookup>
    80004a0e:	892a                	mv	s2,a0
    80004a10:	12050263          	beqz	a0,80004b34 <sys_unlink+0x1b0>
  ilock(ip);
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	1d6080e7          	jalr	470(ra) # 80002bea <ilock>
  if(ip->nlink < 1)
    80004a1c:	04a91783          	lh	a5,74(s2)
    80004a20:	08f05263          	blez	a5,80004aa4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a24:	04491703          	lh	a4,68(s2)
    80004a28:	4785                	li	a5,1
    80004a2a:	08f70563          	beq	a4,a5,80004ab4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a2e:	4641                	li	a2,16
    80004a30:	4581                	li	a1,0
    80004a32:	fc040513          	addi	a0,s0,-64
    80004a36:	ffffb097          	auipc	ra,0xffffb
    80004a3a:	78c080e7          	jalr	1932(ra) # 800001c2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a3e:	4741                	li	a4,16
    80004a40:	f2c42683          	lw	a3,-212(s0)
    80004a44:	fc040613          	addi	a2,s0,-64
    80004a48:	4581                	li	a1,0
    80004a4a:	8526                	mv	a0,s1
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	54a080e7          	jalr	1354(ra) # 80002f96 <writei>
    80004a54:	47c1                	li	a5,16
    80004a56:	0af51563          	bne	a0,a5,80004b00 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a5a:	04491703          	lh	a4,68(s2)
    80004a5e:	4785                	li	a5,1
    80004a60:	0af70863          	beq	a4,a5,80004b10 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a64:	8526                	mv	a0,s1
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	3e6080e7          	jalr	998(ra) # 80002e4c <iunlockput>
  ip->nlink--;
    80004a6e:	04a95783          	lhu	a5,74(s2)
    80004a72:	37fd                	addiw	a5,a5,-1
    80004a74:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	0a6080e7          	jalr	166(ra) # 80002b20 <iupdate>
  iunlockput(ip);
    80004a82:	854a                	mv	a0,s2
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	3c8080e7          	jalr	968(ra) # 80002e4c <iunlockput>
  end_op();
    80004a8c:	fffff097          	auipc	ra,0xfffff
    80004a90:	bb0080e7          	jalr	-1104(ra) # 8000363c <end_op>
  return 0;
    80004a94:	4501                	li	a0,0
    80004a96:	a84d                	j	80004b48 <sys_unlink+0x1c4>
    end_op();
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	ba4080e7          	jalr	-1116(ra) # 8000363c <end_op>
    return -1;
    80004aa0:	557d                	li	a0,-1
    80004aa2:	a05d                	j	80004b48 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	d8c50513          	addi	a0,a0,-628 # 80008830 <syscall_names+0x2e0>
    80004aac:	00001097          	auipc	ra,0x1
    80004ab0:	1ec080e7          	jalr	492(ra) # 80005c98 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ab4:	04c92703          	lw	a4,76(s2)
    80004ab8:	02000793          	li	a5,32
    80004abc:	f6e7f9e3          	bgeu	a5,a4,80004a2e <sys_unlink+0xaa>
    80004ac0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac4:	4741                	li	a4,16
    80004ac6:	86ce                	mv	a3,s3
    80004ac8:	f1840613          	addi	a2,s0,-232
    80004acc:	4581                	li	a1,0
    80004ace:	854a                	mv	a0,s2
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	3ce080e7          	jalr	974(ra) # 80002e9e <readi>
    80004ad8:	47c1                	li	a5,16
    80004ada:	00f51b63          	bne	a0,a5,80004af0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ade:	f1845783          	lhu	a5,-232(s0)
    80004ae2:	e7a1                	bnez	a5,80004b2a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae4:	29c1                	addiw	s3,s3,16
    80004ae6:	04c92783          	lw	a5,76(s2)
    80004aea:	fcf9ede3          	bltu	s3,a5,80004ac4 <sys_unlink+0x140>
    80004aee:	b781                	j	80004a2e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004af0:	00004517          	auipc	a0,0x4
    80004af4:	d5850513          	addi	a0,a0,-680 # 80008848 <syscall_names+0x2f8>
    80004af8:	00001097          	auipc	ra,0x1
    80004afc:	1a0080e7          	jalr	416(ra) # 80005c98 <panic>
    panic("unlink: writei");
    80004b00:	00004517          	auipc	a0,0x4
    80004b04:	d6050513          	addi	a0,a0,-672 # 80008860 <syscall_names+0x310>
    80004b08:	00001097          	auipc	ra,0x1
    80004b0c:	190080e7          	jalr	400(ra) # 80005c98 <panic>
    dp->nlink--;
    80004b10:	04a4d783          	lhu	a5,74(s1)
    80004b14:	37fd                	addiw	a5,a5,-1
    80004b16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	004080e7          	jalr	4(ra) # 80002b20 <iupdate>
    80004b24:	b781                	j	80004a64 <sys_unlink+0xe0>
    return -1;
    80004b26:	557d                	li	a0,-1
    80004b28:	a005                	j	80004b48 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b2a:	854a                	mv	a0,s2
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	320080e7          	jalr	800(ra) # 80002e4c <iunlockput>
  iunlockput(dp);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	316080e7          	jalr	790(ra) # 80002e4c <iunlockput>
  end_op();
    80004b3e:	fffff097          	auipc	ra,0xfffff
    80004b42:	afe080e7          	jalr	-1282(ra) # 8000363c <end_op>
  return -1;
    80004b46:	557d                	li	a0,-1
}
    80004b48:	70ae                	ld	ra,232(sp)
    80004b4a:	740e                	ld	s0,224(sp)
    80004b4c:	64ee                	ld	s1,216(sp)
    80004b4e:	694e                	ld	s2,208(sp)
    80004b50:	69ae                	ld	s3,200(sp)
    80004b52:	616d                	addi	sp,sp,240
    80004b54:	8082                	ret

0000000080004b56 <sys_open>:

uint64
sys_open(void)
{
    80004b56:	7131                	addi	sp,sp,-192
    80004b58:	fd06                	sd	ra,184(sp)
    80004b5a:	f922                	sd	s0,176(sp)
    80004b5c:	f526                	sd	s1,168(sp)
    80004b5e:	f14a                	sd	s2,160(sp)
    80004b60:	ed4e                	sd	s3,152(sp)
    80004b62:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b64:	08000613          	li	a2,128
    80004b68:	f5040593          	addi	a1,s0,-176
    80004b6c:	4501                	li	a0,0
    80004b6e:	ffffd097          	auipc	ra,0xffffd
    80004b72:	476080e7          	jalr	1142(ra) # 80001fe4 <argstr>
    return -1;
    80004b76:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b78:	0c054163          	bltz	a0,80004c3a <sys_open+0xe4>
    80004b7c:	f4c40593          	addi	a1,s0,-180
    80004b80:	4505                	li	a0,1
    80004b82:	ffffd097          	auipc	ra,0xffffd
    80004b86:	41e080e7          	jalr	1054(ra) # 80001fa0 <argint>
    80004b8a:	0a054863          	bltz	a0,80004c3a <sys_open+0xe4>

  begin_op();
    80004b8e:	fffff097          	auipc	ra,0xfffff
    80004b92:	a2e080e7          	jalr	-1490(ra) # 800035bc <begin_op>

  if(omode & O_CREATE){
    80004b96:	f4c42783          	lw	a5,-180(s0)
    80004b9a:	2007f793          	andi	a5,a5,512
    80004b9e:	cbdd                	beqz	a5,80004c54 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004ba0:	4681                	li	a3,0
    80004ba2:	4601                	li	a2,0
    80004ba4:	4589                	li	a1,2
    80004ba6:	f5040513          	addi	a0,s0,-176
    80004baa:	00000097          	auipc	ra,0x0
    80004bae:	972080e7          	jalr	-1678(ra) # 8000451c <create>
    80004bb2:	892a                	mv	s2,a0
    if(ip == 0){
    80004bb4:	c959                	beqz	a0,80004c4a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb6:	04491703          	lh	a4,68(s2)
    80004bba:	478d                	li	a5,3
    80004bbc:	00f71763          	bne	a4,a5,80004bca <sys_open+0x74>
    80004bc0:	04695703          	lhu	a4,70(s2)
    80004bc4:	47a5                	li	a5,9
    80004bc6:	0ce7ec63          	bltu	a5,a4,80004c9e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bca:	fffff097          	auipc	ra,0xfffff
    80004bce:	e02080e7          	jalr	-510(ra) # 800039cc <filealloc>
    80004bd2:	89aa                	mv	s3,a0
    80004bd4:	10050263          	beqz	a0,80004cd8 <sys_open+0x182>
    80004bd8:	00000097          	auipc	ra,0x0
    80004bdc:	902080e7          	jalr	-1790(ra) # 800044da <fdalloc>
    80004be0:	84aa                	mv	s1,a0
    80004be2:	0e054663          	bltz	a0,80004cce <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be6:	04491703          	lh	a4,68(s2)
    80004bea:	478d                	li	a5,3
    80004bec:	0cf70463          	beq	a4,a5,80004cb4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf0:	4789                	li	a5,2
    80004bf2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bfa:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bfe:	f4c42783          	lw	a5,-180(s0)
    80004c02:	0017c713          	xori	a4,a5,1
    80004c06:	8b05                	andi	a4,a4,1
    80004c08:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c0c:	0037f713          	andi	a4,a5,3
    80004c10:	00e03733          	snez	a4,a4
    80004c14:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c18:	4007f793          	andi	a5,a5,1024
    80004c1c:	c791                	beqz	a5,80004c28 <sys_open+0xd2>
    80004c1e:	04491703          	lh	a4,68(s2)
    80004c22:	4789                	li	a5,2
    80004c24:	08f70f63          	beq	a4,a5,80004cc2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c28:	854a                	mv	a0,s2
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	082080e7          	jalr	130(ra) # 80002cac <iunlock>
  end_op();
    80004c32:	fffff097          	auipc	ra,0xfffff
    80004c36:	a0a080e7          	jalr	-1526(ra) # 8000363c <end_op>

  return fd;
}
    80004c3a:	8526                	mv	a0,s1
    80004c3c:	70ea                	ld	ra,184(sp)
    80004c3e:	744a                	ld	s0,176(sp)
    80004c40:	74aa                	ld	s1,168(sp)
    80004c42:	790a                	ld	s2,160(sp)
    80004c44:	69ea                	ld	s3,152(sp)
    80004c46:	6129                	addi	sp,sp,192
    80004c48:	8082                	ret
      end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	9f2080e7          	jalr	-1550(ra) # 8000363c <end_op>
      return -1;
    80004c52:	b7e5                	j	80004c3a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c54:	f5040513          	addi	a0,s0,-176
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	748080e7          	jalr	1864(ra) # 800033a0 <namei>
    80004c60:	892a                	mv	s2,a0
    80004c62:	c905                	beqz	a0,80004c92 <sys_open+0x13c>
    ilock(ip);
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	f86080e7          	jalr	-122(ra) # 80002bea <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c6c:	04491703          	lh	a4,68(s2)
    80004c70:	4785                	li	a5,1
    80004c72:	f4f712e3          	bne	a4,a5,80004bb6 <sys_open+0x60>
    80004c76:	f4c42783          	lw	a5,-180(s0)
    80004c7a:	dba1                	beqz	a5,80004bca <sys_open+0x74>
      iunlockput(ip);
    80004c7c:	854a                	mv	a0,s2
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	1ce080e7          	jalr	462(ra) # 80002e4c <iunlockput>
      end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	9b6080e7          	jalr	-1610(ra) # 8000363c <end_op>
      return -1;
    80004c8e:	54fd                	li	s1,-1
    80004c90:	b76d                	j	80004c3a <sys_open+0xe4>
      end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	9aa080e7          	jalr	-1622(ra) # 8000363c <end_op>
      return -1;
    80004c9a:	54fd                	li	s1,-1
    80004c9c:	bf79                	j	80004c3a <sys_open+0xe4>
    iunlockput(ip);
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	1ac080e7          	jalr	428(ra) # 80002e4c <iunlockput>
    end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	994080e7          	jalr	-1644(ra) # 8000363c <end_op>
    return -1;
    80004cb0:	54fd                	li	s1,-1
    80004cb2:	b761                	j	80004c3a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cb4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cb8:	04691783          	lh	a5,70(s2)
    80004cbc:	02f99223          	sh	a5,36(s3)
    80004cc0:	bf2d                	j	80004bfa <sys_open+0xa4>
    itrunc(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	034080e7          	jalr	52(ra) # 80002cf8 <itrunc>
    80004ccc:	bfb1                	j	80004c28 <sys_open+0xd2>
      fileclose(f);
    80004cce:	854e                	mv	a0,s3
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	db8080e7          	jalr	-584(ra) # 80003a88 <fileclose>
    iunlockput(ip);
    80004cd8:	854a                	mv	a0,s2
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	172080e7          	jalr	370(ra) # 80002e4c <iunlockput>
    end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	95a080e7          	jalr	-1702(ra) # 8000363c <end_op>
    return -1;
    80004cea:	54fd                	li	s1,-1
    80004cec:	b7b9                	j	80004c3a <sys_open+0xe4>

0000000080004cee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cee:	7175                	addi	sp,sp,-144
    80004cf0:	e506                	sd	ra,136(sp)
    80004cf2:	e122                	sd	s0,128(sp)
    80004cf4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	8c6080e7          	jalr	-1850(ra) # 800035bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cfe:	08000613          	li	a2,128
    80004d02:	f7040593          	addi	a1,s0,-144
    80004d06:	4501                	li	a0,0
    80004d08:	ffffd097          	auipc	ra,0xffffd
    80004d0c:	2dc080e7          	jalr	732(ra) # 80001fe4 <argstr>
    80004d10:	02054963          	bltz	a0,80004d42 <sys_mkdir+0x54>
    80004d14:	4681                	li	a3,0
    80004d16:	4601                	li	a2,0
    80004d18:	4585                	li	a1,1
    80004d1a:	f7040513          	addi	a0,s0,-144
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	7fe080e7          	jalr	2046(ra) # 8000451c <create>
    80004d26:	cd11                	beqz	a0,80004d42 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	124080e7          	jalr	292(ra) # 80002e4c <iunlockput>
  end_op();
    80004d30:	fffff097          	auipc	ra,0xfffff
    80004d34:	90c080e7          	jalr	-1780(ra) # 8000363c <end_op>
  return 0;
    80004d38:	4501                	li	a0,0
}
    80004d3a:	60aa                	ld	ra,136(sp)
    80004d3c:	640a                	ld	s0,128(sp)
    80004d3e:	6149                	addi	sp,sp,144
    80004d40:	8082                	ret
    end_op();
    80004d42:	fffff097          	auipc	ra,0xfffff
    80004d46:	8fa080e7          	jalr	-1798(ra) # 8000363c <end_op>
    return -1;
    80004d4a:	557d                	li	a0,-1
    80004d4c:	b7fd                	j	80004d3a <sys_mkdir+0x4c>

0000000080004d4e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d4e:	7135                	addi	sp,sp,-160
    80004d50:	ed06                	sd	ra,152(sp)
    80004d52:	e922                	sd	s0,144(sp)
    80004d54:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	866080e7          	jalr	-1946(ra) # 800035bc <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d5e:	08000613          	li	a2,128
    80004d62:	f7040593          	addi	a1,s0,-144
    80004d66:	4501                	li	a0,0
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	27c080e7          	jalr	636(ra) # 80001fe4 <argstr>
    80004d70:	04054a63          	bltz	a0,80004dc4 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d74:	f6c40593          	addi	a1,s0,-148
    80004d78:	4505                	li	a0,1
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	226080e7          	jalr	550(ra) # 80001fa0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d82:	04054163          	bltz	a0,80004dc4 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d86:	f6840593          	addi	a1,s0,-152
    80004d8a:	4509                	li	a0,2
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	214080e7          	jalr	532(ra) # 80001fa0 <argint>
     argint(1, &major) < 0 ||
    80004d94:	02054863          	bltz	a0,80004dc4 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d98:	f6841683          	lh	a3,-152(s0)
    80004d9c:	f6c41603          	lh	a2,-148(s0)
    80004da0:	458d                	li	a1,3
    80004da2:	f7040513          	addi	a0,s0,-144
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	776080e7          	jalr	1910(ra) # 8000451c <create>
     argint(2, &minor) < 0 ||
    80004dae:	c919                	beqz	a0,80004dc4 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	09c080e7          	jalr	156(ra) # 80002e4c <iunlockput>
  end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	884080e7          	jalr	-1916(ra) # 8000363c <end_op>
  return 0;
    80004dc0:	4501                	li	a0,0
    80004dc2:	a031                	j	80004dce <sys_mknod+0x80>
    end_op();
    80004dc4:	fffff097          	auipc	ra,0xfffff
    80004dc8:	878080e7          	jalr	-1928(ra) # 8000363c <end_op>
    return -1;
    80004dcc:	557d                	li	a0,-1
}
    80004dce:	60ea                	ld	ra,152(sp)
    80004dd0:	644a                	ld	s0,144(sp)
    80004dd2:	610d                	addi	sp,sp,160
    80004dd4:	8082                	ret

0000000080004dd6 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dd6:	7135                	addi	sp,sp,-160
    80004dd8:	ed06                	sd	ra,152(sp)
    80004dda:	e922                	sd	s0,144(sp)
    80004ddc:	e526                	sd	s1,136(sp)
    80004dde:	e14a                	sd	s2,128(sp)
    80004de0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	0b0080e7          	jalr	176(ra) # 80000e92 <myproc>
    80004dea:	892a                	mv	s2,a0
  
  begin_op();
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	7d0080e7          	jalr	2000(ra) # 800035bc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df4:	08000613          	li	a2,128
    80004df8:	f6040593          	addi	a1,s0,-160
    80004dfc:	4501                	li	a0,0
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	1e6080e7          	jalr	486(ra) # 80001fe4 <argstr>
    80004e06:	04054b63          	bltz	a0,80004e5c <sys_chdir+0x86>
    80004e0a:	f6040513          	addi	a0,s0,-160
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	592080e7          	jalr	1426(ra) # 800033a0 <namei>
    80004e16:	84aa                	mv	s1,a0
    80004e18:	c131                	beqz	a0,80004e5c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	dd0080e7          	jalr	-560(ra) # 80002bea <ilock>
  if(ip->type != T_DIR){
    80004e22:	04449703          	lh	a4,68(s1)
    80004e26:	4785                	li	a5,1
    80004e28:	04f71063          	bne	a4,a5,80004e68 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e2c:	8526                	mv	a0,s1
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	e7e080e7          	jalr	-386(ra) # 80002cac <iunlock>
  iput(p->cwd);
    80004e36:	15093503          	ld	a0,336(s2)
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	f6a080e7          	jalr	-150(ra) # 80002da4 <iput>
  end_op();
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	7fa080e7          	jalr	2042(ra) # 8000363c <end_op>
  p->cwd = ip;
    80004e4a:	14993823          	sd	s1,336(s2)
  return 0;
    80004e4e:	4501                	li	a0,0
}
    80004e50:	60ea                	ld	ra,152(sp)
    80004e52:	644a                	ld	s0,144(sp)
    80004e54:	64aa                	ld	s1,136(sp)
    80004e56:	690a                	ld	s2,128(sp)
    80004e58:	610d                	addi	sp,sp,160
    80004e5a:	8082                	ret
    end_op();
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	7e0080e7          	jalr	2016(ra) # 8000363c <end_op>
    return -1;
    80004e64:	557d                	li	a0,-1
    80004e66:	b7ed                	j	80004e50 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	fe2080e7          	jalr	-30(ra) # 80002e4c <iunlockput>
    end_op();
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	7ca080e7          	jalr	1994(ra) # 8000363c <end_op>
    return -1;
    80004e7a:	557d                	li	a0,-1
    80004e7c:	bfd1                	j	80004e50 <sys_chdir+0x7a>

0000000080004e7e <sys_exec>:

uint64
sys_exec(void)
{
    80004e7e:	7145                	addi	sp,sp,-464
    80004e80:	e786                	sd	ra,456(sp)
    80004e82:	e3a2                	sd	s0,448(sp)
    80004e84:	ff26                	sd	s1,440(sp)
    80004e86:	fb4a                	sd	s2,432(sp)
    80004e88:	f74e                	sd	s3,424(sp)
    80004e8a:	f352                	sd	s4,416(sp)
    80004e8c:	ef56                	sd	s5,408(sp)
    80004e8e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e90:	08000613          	li	a2,128
    80004e94:	f4040593          	addi	a1,s0,-192
    80004e98:	4501                	li	a0,0
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	14a080e7          	jalr	330(ra) # 80001fe4 <argstr>
    return -1;
    80004ea2:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea4:	0c054a63          	bltz	a0,80004f78 <sys_exec+0xfa>
    80004ea8:	e3840593          	addi	a1,s0,-456
    80004eac:	4505                	li	a0,1
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	114080e7          	jalr	276(ra) # 80001fc2 <argaddr>
    80004eb6:	0c054163          	bltz	a0,80004f78 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004eba:	10000613          	li	a2,256
    80004ebe:	4581                	li	a1,0
    80004ec0:	e4040513          	addi	a0,s0,-448
    80004ec4:	ffffb097          	auipc	ra,0xffffb
    80004ec8:	2fe080e7          	jalr	766(ra) # 800001c2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ecc:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ed0:	89a6                	mv	s3,s1
    80004ed2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ed4:	02000a13          	li	s4,32
    80004ed8:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004edc:	00391513          	slli	a0,s2,0x3
    80004ee0:	e3040593          	addi	a1,s0,-464
    80004ee4:	e3843783          	ld	a5,-456(s0)
    80004ee8:	953e                	add	a0,a0,a5
    80004eea:	ffffd097          	auipc	ra,0xffffd
    80004eee:	01c080e7          	jalr	28(ra) # 80001f06 <fetchaddr>
    80004ef2:	02054a63          	bltz	a0,80004f26 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ef6:	e3043783          	ld	a5,-464(s0)
    80004efa:	c3b9                	beqz	a5,80004f40 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004efc:	ffffb097          	auipc	ra,0xffffb
    80004f00:	21c080e7          	jalr	540(ra) # 80000118 <kalloc>
    80004f04:	85aa                	mv	a1,a0
    80004f06:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f0a:	cd11                	beqz	a0,80004f26 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f0c:	6605                	lui	a2,0x1
    80004f0e:	e3043503          	ld	a0,-464(s0)
    80004f12:	ffffd097          	auipc	ra,0xffffd
    80004f16:	046080e7          	jalr	70(ra) # 80001f58 <fetchstr>
    80004f1a:	00054663          	bltz	a0,80004f26 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f1e:	0905                	addi	s2,s2,1
    80004f20:	09a1                	addi	s3,s3,8
    80004f22:	fb491be3          	bne	s2,s4,80004ed8 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f26:	10048913          	addi	s2,s1,256
    80004f2a:	6088                	ld	a0,0(s1)
    80004f2c:	c529                	beqz	a0,80004f76 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f2e:	ffffb097          	auipc	ra,0xffffb
    80004f32:	0ee080e7          	jalr	238(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f36:	04a1                	addi	s1,s1,8
    80004f38:	ff2499e3          	bne	s1,s2,80004f2a <sys_exec+0xac>
  return -1;
    80004f3c:	597d                	li	s2,-1
    80004f3e:	a82d                	j	80004f78 <sys_exec+0xfa>
      argv[i] = 0;
    80004f40:	0a8e                	slli	s5,s5,0x3
    80004f42:	fc040793          	addi	a5,s0,-64
    80004f46:	9abe                	add	s5,s5,a5
    80004f48:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f4c:	e4040593          	addi	a1,s0,-448
    80004f50:	f4040513          	addi	a0,s0,-192
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	194080e7          	jalr	404(ra) # 800040e8 <exec>
    80004f5c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5e:	10048993          	addi	s3,s1,256
    80004f62:	6088                	ld	a0,0(s1)
    80004f64:	c911                	beqz	a0,80004f78 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f66:	ffffb097          	auipc	ra,0xffffb
    80004f6a:	0b6080e7          	jalr	182(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6e:	04a1                	addi	s1,s1,8
    80004f70:	ff3499e3          	bne	s1,s3,80004f62 <sys_exec+0xe4>
    80004f74:	a011                	j	80004f78 <sys_exec+0xfa>
  return -1;
    80004f76:	597d                	li	s2,-1
}
    80004f78:	854a                	mv	a0,s2
    80004f7a:	60be                	ld	ra,456(sp)
    80004f7c:	641e                	ld	s0,448(sp)
    80004f7e:	74fa                	ld	s1,440(sp)
    80004f80:	795a                	ld	s2,432(sp)
    80004f82:	79ba                	ld	s3,424(sp)
    80004f84:	7a1a                	ld	s4,416(sp)
    80004f86:	6afa                	ld	s5,408(sp)
    80004f88:	6179                	addi	sp,sp,464
    80004f8a:	8082                	ret

0000000080004f8c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f8c:	7139                	addi	sp,sp,-64
    80004f8e:	fc06                	sd	ra,56(sp)
    80004f90:	f822                	sd	s0,48(sp)
    80004f92:	f426                	sd	s1,40(sp)
    80004f94:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f96:	ffffc097          	auipc	ra,0xffffc
    80004f9a:	efc080e7          	jalr	-260(ra) # 80000e92 <myproc>
    80004f9e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fa0:	fd840593          	addi	a1,s0,-40
    80004fa4:	4501                	li	a0,0
    80004fa6:	ffffd097          	auipc	ra,0xffffd
    80004faa:	01c080e7          	jalr	28(ra) # 80001fc2 <argaddr>
    return -1;
    80004fae:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fb0:	0e054063          	bltz	a0,80005090 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fb4:	fc840593          	addi	a1,s0,-56
    80004fb8:	fd040513          	addi	a0,s0,-48
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	dfc080e7          	jalr	-516(ra) # 80003db8 <pipealloc>
    return -1;
    80004fc4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fc6:	0c054563          	bltz	a0,80005090 <sys_pipe+0x104>
  fd0 = -1;
    80004fca:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fce:	fd043503          	ld	a0,-48(s0)
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	508080e7          	jalr	1288(ra) # 800044da <fdalloc>
    80004fda:	fca42223          	sw	a0,-60(s0)
    80004fde:	08054c63          	bltz	a0,80005076 <sys_pipe+0xea>
    80004fe2:	fc843503          	ld	a0,-56(s0)
    80004fe6:	fffff097          	auipc	ra,0xfffff
    80004fea:	4f4080e7          	jalr	1268(ra) # 800044da <fdalloc>
    80004fee:	fca42023          	sw	a0,-64(s0)
    80004ff2:	06054863          	bltz	a0,80005062 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ff6:	4691                	li	a3,4
    80004ff8:	fc440613          	addi	a2,s0,-60
    80004ffc:	fd843583          	ld	a1,-40(s0)
    80005000:	68a8                	ld	a0,80(s1)
    80005002:	ffffc097          	auipc	ra,0xffffc
    80005006:	b52080e7          	jalr	-1198(ra) # 80000b54 <copyout>
    8000500a:	02054063          	bltz	a0,8000502a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000500e:	4691                	li	a3,4
    80005010:	fc040613          	addi	a2,s0,-64
    80005014:	fd843583          	ld	a1,-40(s0)
    80005018:	0591                	addi	a1,a1,4
    8000501a:	68a8                	ld	a0,80(s1)
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	b38080e7          	jalr	-1224(ra) # 80000b54 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005024:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005026:	06055563          	bgez	a0,80005090 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000502a:	fc442783          	lw	a5,-60(s0)
    8000502e:	07e9                	addi	a5,a5,26
    80005030:	078e                	slli	a5,a5,0x3
    80005032:	97a6                	add	a5,a5,s1
    80005034:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005038:	fc042503          	lw	a0,-64(s0)
    8000503c:	0569                	addi	a0,a0,26
    8000503e:	050e                	slli	a0,a0,0x3
    80005040:	9526                	add	a0,a0,s1
    80005042:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005046:	fd043503          	ld	a0,-48(s0)
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	a3e080e7          	jalr	-1474(ra) # 80003a88 <fileclose>
    fileclose(wf);
    80005052:	fc843503          	ld	a0,-56(s0)
    80005056:	fffff097          	auipc	ra,0xfffff
    8000505a:	a32080e7          	jalr	-1486(ra) # 80003a88 <fileclose>
    return -1;
    8000505e:	57fd                	li	a5,-1
    80005060:	a805                	j	80005090 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005062:	fc442783          	lw	a5,-60(s0)
    80005066:	0007c863          	bltz	a5,80005076 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000506a:	01a78513          	addi	a0,a5,26
    8000506e:	050e                	slli	a0,a0,0x3
    80005070:	9526                	add	a0,a0,s1
    80005072:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005076:	fd043503          	ld	a0,-48(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	a0e080e7          	jalr	-1522(ra) # 80003a88 <fileclose>
    fileclose(wf);
    80005082:	fc843503          	ld	a0,-56(s0)
    80005086:	fffff097          	auipc	ra,0xfffff
    8000508a:	a02080e7          	jalr	-1534(ra) # 80003a88 <fileclose>
    return -1;
    8000508e:	57fd                	li	a5,-1
}
    80005090:	853e                	mv	a0,a5
    80005092:	70e2                	ld	ra,56(sp)
    80005094:	7442                	ld	s0,48(sp)
    80005096:	74a2                	ld	s1,40(sp)
    80005098:	6121                	addi	sp,sp,64
    8000509a:	8082                	ret
    8000509c:	0000                	unimp
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	cf3fc0ef          	jal	ra,80001dd2 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	cee080e7          	jalr	-786(ra) # 80000e66 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	953e                	add	a0,a0,a5
    8000519c:	00052023          	sw	zero,0(a0)
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	cb6080e7          	jalr	-842(ra) # 80000e66 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5179b          	slliw	a5,a0,0xd
    800051bc:	0c201537          	lui	a0,0xc201
    800051c0:	953e                	add	a0,a0,a5
  return irq;
}
    800051c2:	4148                	lw	a0,4(a0)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c8e080e7          	jalr	-882(ra) # 80000e66 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	06a7c963          	blt	a5,a0,80005272 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00016797          	auipc	a5,0x16
    80005208:	dfc78793          	addi	a5,a5,-516 # 8001b000 <disk>
    8000520c:	00a78733          	add	a4,a5,a0
    80005210:	6789                	lui	a5,0x2
    80005212:	97ba                	add	a5,a5,a4
    80005214:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005218:	e7ad                	bnez	a5,80005282 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000521a:	00451793          	slli	a5,a0,0x4
    8000521e:	00018717          	auipc	a4,0x18
    80005222:	de270713          	addi	a4,a4,-542 # 8001d000 <disk+0x2000>
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000522e:	6314                	ld	a3,0(a4)
    80005230:	96be                	add	a3,a3,a5
    80005232:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005236:	6314                	ld	a3,0(a4)
    80005238:	96be                	add	a3,a3,a5
    8000523a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000523e:	6318                	ld	a4,0(a4)
    80005240:	97ba                	add	a5,a5,a4
    80005242:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005246:	00016797          	auipc	a5,0x16
    8000524a:	dba78793          	addi	a5,a5,-582 # 8001b000 <disk>
    8000524e:	97aa                	add	a5,a5,a0
    80005250:	6509                	lui	a0,0x2
    80005252:	953e                	add	a0,a0,a5
    80005254:	4785                	li	a5,1
    80005256:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000525a:	00018517          	auipc	a0,0x18
    8000525e:	dbe50513          	addi	a0,a0,-578 # 8001d018 <disk+0x2018>
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	484080e7          	jalr	1156(ra) # 800016e6 <wakeup>
}
    8000526a:	60a2                	ld	ra,8(sp)
    8000526c:	6402                	ld	s0,0(sp)
    8000526e:	0141                	addi	sp,sp,16
    80005270:	8082                	ret
    panic("free_desc 1");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	5fe50513          	addi	a0,a0,1534 # 80008870 <syscall_names+0x320>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	a1e080e7          	jalr	-1506(ra) # 80005c98 <panic>
    panic("free_desc 2");
    80005282:	00003517          	auipc	a0,0x3
    80005286:	5fe50513          	addi	a0,a0,1534 # 80008880 <syscall_names+0x330>
    8000528a:	00001097          	auipc	ra,0x1
    8000528e:	a0e080e7          	jalr	-1522(ra) # 80005c98 <panic>

0000000080005292 <virtio_disk_init>:
{
    80005292:	1101                	addi	sp,sp,-32
    80005294:	ec06                	sd	ra,24(sp)
    80005296:	e822                	sd	s0,16(sp)
    80005298:	e426                	sd	s1,8(sp)
    8000529a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000529c:	00003597          	auipc	a1,0x3
    800052a0:	5f458593          	addi	a1,a1,1524 # 80008890 <syscall_names+0x340>
    800052a4:	00018517          	auipc	a0,0x18
    800052a8:	e8450513          	addi	a0,a0,-380 # 8001d128 <disk+0x2128>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	ea6080e7          	jalr	-346(ra) # 80006152 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b4:	100017b7          	lui	a5,0x10001
    800052b8:	4398                	lw	a4,0(a5)
    800052ba:	2701                	sext.w	a4,a4
    800052bc:	747277b7          	lui	a5,0x74727
    800052c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052c4:	0ef71163          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	43dc                	lw	a5,4(a5)
    800052ce:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d0:	4705                	li	a4,1
    800052d2:	0ce79a63          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d6:	100017b7          	lui	a5,0x10001
    800052da:	479c                	lw	a5,8(a5)
    800052dc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052de:	4709                	li	a4,2
    800052e0:	0ce79363          	bne	a5,a4,800053a6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052e4:	100017b7          	lui	a5,0x10001
    800052e8:	47d8                	lw	a4,12(a5)
    800052ea:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ec:	554d47b7          	lui	a5,0x554d4
    800052f0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052f4:	0af71963          	bne	a4,a5,800053a6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	4705                	li	a4,1
    800052fe:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005300:	470d                	li	a4,3
    80005302:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005304:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005306:	c7ffe737          	lui	a4,0xc7ffe
    8000530a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    8000530e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005310:	2701                	sext.w	a4,a4
    80005312:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005314:	472d                	li	a4,11
    80005316:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005318:	473d                	li	a4,15
    8000531a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000531c:	6705                	lui	a4,0x1
    8000531e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005320:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005324:	5bdc                	lw	a5,52(a5)
    80005326:	2781                	sext.w	a5,a5
  if(max == 0)
    80005328:	c7d9                	beqz	a5,800053b6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000532a:	471d                	li	a4,7
    8000532c:	08f77d63          	bgeu	a4,a5,800053c6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005330:	100014b7          	lui	s1,0x10001
    80005334:	47a1                	li	a5,8
    80005336:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005338:	6609                	lui	a2,0x2
    8000533a:	4581                	li	a1,0
    8000533c:	00016517          	auipc	a0,0x16
    80005340:	cc450513          	addi	a0,a0,-828 # 8001b000 <disk>
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	e7e080e7          	jalr	-386(ra) # 800001c2 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000534c:	00016717          	auipc	a4,0x16
    80005350:	cb470713          	addi	a4,a4,-844 # 8001b000 <disk>
    80005354:	00c75793          	srli	a5,a4,0xc
    80005358:	2781                	sext.w	a5,a5
    8000535a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000535c:	00018797          	auipc	a5,0x18
    80005360:	ca478793          	addi	a5,a5,-860 # 8001d000 <disk+0x2000>
    80005364:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005366:	00016717          	auipc	a4,0x16
    8000536a:	d1a70713          	addi	a4,a4,-742 # 8001b080 <disk+0x80>
    8000536e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005370:	00017717          	auipc	a4,0x17
    80005374:	c9070713          	addi	a4,a4,-880 # 8001c000 <disk+0x1000>
    80005378:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000537a:	4705                	li	a4,1
    8000537c:	00e78c23          	sb	a4,24(a5)
    80005380:	00e78ca3          	sb	a4,25(a5)
    80005384:	00e78d23          	sb	a4,26(a5)
    80005388:	00e78da3          	sb	a4,27(a5)
    8000538c:	00e78e23          	sb	a4,28(a5)
    80005390:	00e78ea3          	sb	a4,29(a5)
    80005394:	00e78f23          	sb	a4,30(a5)
    80005398:	00e78fa3          	sb	a4,31(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret
    panic("could not find virtio disk");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	4fa50513          	addi	a0,a0,1274 # 800088a0 <syscall_names+0x350>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	8ea080e7          	jalr	-1814(ra) # 80005c98 <panic>
    panic("virtio disk has no queue 0");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	50a50513          	addi	a0,a0,1290 # 800088c0 <syscall_names+0x370>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8da080e7          	jalr	-1830(ra) # 80005c98 <panic>
    panic("virtio disk max queue too short");
    800053c6:	00003517          	auipc	a0,0x3
    800053ca:	51a50513          	addi	a0,a0,1306 # 800088e0 <syscall_names+0x390>
    800053ce:	00001097          	auipc	ra,0x1
    800053d2:	8ca080e7          	jalr	-1846(ra) # 80005c98 <panic>

00000000800053d6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053d6:	7159                	addi	sp,sp,-112
    800053d8:	f486                	sd	ra,104(sp)
    800053da:	f0a2                	sd	s0,96(sp)
    800053dc:	eca6                	sd	s1,88(sp)
    800053de:	e8ca                	sd	s2,80(sp)
    800053e0:	e4ce                	sd	s3,72(sp)
    800053e2:	e0d2                	sd	s4,64(sp)
    800053e4:	fc56                	sd	s5,56(sp)
    800053e6:	f85a                	sd	s6,48(sp)
    800053e8:	f45e                	sd	s7,40(sp)
    800053ea:	f062                	sd	s8,32(sp)
    800053ec:	ec66                	sd	s9,24(sp)
    800053ee:	e86a                	sd	s10,16(sp)
    800053f0:	1880                	addi	s0,sp,112
    800053f2:	892a                	mv	s2,a0
    800053f4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053f6:	00c52c83          	lw	s9,12(a0)
    800053fa:	001c9c9b          	slliw	s9,s9,0x1
    800053fe:	1c82                	slli	s9,s9,0x20
    80005400:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005404:	00018517          	auipc	a0,0x18
    80005408:	d2450513          	addi	a0,a0,-732 # 8001d128 <disk+0x2128>
    8000540c:	00001097          	auipc	ra,0x1
    80005410:	dd6080e7          	jalr	-554(ra) # 800061e2 <acquire>
  for(int i = 0; i < 3; i++){
    80005414:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005416:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005418:	00016b97          	auipc	s7,0x16
    8000541c:	be8b8b93          	addi	s7,s7,-1048 # 8001b000 <disk>
    80005420:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005422:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005424:	8a4e                	mv	s4,s3
    80005426:	a051                	j	800054aa <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005428:	00fb86b3          	add	a3,s7,a5
    8000542c:	96da                	add	a3,a3,s6
    8000542e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005432:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005434:	0207c563          	bltz	a5,8000545e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005438:	2485                	addiw	s1,s1,1
    8000543a:	0711                	addi	a4,a4,4
    8000543c:	25548063          	beq	s1,s5,8000567c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005440:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005442:	00018697          	auipc	a3,0x18
    80005446:	bd668693          	addi	a3,a3,-1066 # 8001d018 <disk+0x2018>
    8000544a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000544c:	0006c583          	lbu	a1,0(a3)
    80005450:	fde1                	bnez	a1,80005428 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005452:	2785                	addiw	a5,a5,1
    80005454:	0685                	addi	a3,a3,1
    80005456:	ff879be3          	bne	a5,s8,8000544c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000545a:	57fd                	li	a5,-1
    8000545c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000545e:	02905a63          	blez	s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005462:	f9042503          	lw	a0,-112(s0)
    80005466:	00000097          	auipc	ra,0x0
    8000546a:	d90080e7          	jalr	-624(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    8000546e:	4785                	li	a5,1
    80005470:	0297d163          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005474:	f9442503          	lw	a0,-108(s0)
    80005478:	00000097          	auipc	ra,0x0
    8000547c:	d7e080e7          	jalr	-642(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005480:	4789                	li	a5,2
    80005482:	0097d863          	bge	a5,s1,80005492 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005486:	f9842503          	lw	a0,-104(s0)
    8000548a:	00000097          	auipc	ra,0x0
    8000548e:	d6c080e7          	jalr	-660(ra) # 800051f6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005492:	00018597          	auipc	a1,0x18
    80005496:	c9658593          	addi	a1,a1,-874 # 8001d128 <disk+0x2128>
    8000549a:	00018517          	auipc	a0,0x18
    8000549e:	b7e50513          	addi	a0,a0,-1154 # 8001d018 <disk+0x2018>
    800054a2:	ffffc097          	auipc	ra,0xffffc
    800054a6:	0b8080e7          	jalr	184(ra) # 8000155a <sleep>
  for(int i = 0; i < 3; i++){
    800054aa:	f9040713          	addi	a4,s0,-112
    800054ae:	84ce                	mv	s1,s3
    800054b0:	bf41                	j	80005440 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054b2:	20058713          	addi	a4,a1,512
    800054b6:	00471693          	slli	a3,a4,0x4
    800054ba:	00016717          	auipc	a4,0x16
    800054be:	b4670713          	addi	a4,a4,-1210 # 8001b000 <disk>
    800054c2:	9736                	add	a4,a4,a3
    800054c4:	4685                	li	a3,1
    800054c6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054ca:	20058713          	addi	a4,a1,512
    800054ce:	00471693          	slli	a3,a4,0x4
    800054d2:	00016717          	auipc	a4,0x16
    800054d6:	b2e70713          	addi	a4,a4,-1234 # 8001b000 <disk>
    800054da:	9736                	add	a4,a4,a3
    800054dc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054e0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054e4:	7679                	lui	a2,0xffffe
    800054e6:	963e                	add	a2,a2,a5
    800054e8:	00018697          	auipc	a3,0x18
    800054ec:	b1868693          	addi	a3,a3,-1256 # 8001d000 <disk+0x2000>
    800054f0:	6298                	ld	a4,0(a3)
    800054f2:	9732                	add	a4,a4,a2
    800054f4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054f6:	6298                	ld	a4,0(a3)
    800054f8:	9732                	add	a4,a4,a2
    800054fa:	4541                	li	a0,16
    800054fc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054fe:	6298                	ld	a4,0(a3)
    80005500:	9732                	add	a4,a4,a2
    80005502:	4505                	li	a0,1
    80005504:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005508:	f9442703          	lw	a4,-108(s0)
    8000550c:	6288                	ld	a0,0(a3)
    8000550e:	962a                	add	a2,a2,a0
    80005510:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005514:	0712                	slli	a4,a4,0x4
    80005516:	6290                	ld	a2,0(a3)
    80005518:	963a                	add	a2,a2,a4
    8000551a:	05890513          	addi	a0,s2,88
    8000551e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005520:	6294                	ld	a3,0(a3)
    80005522:	96ba                	add	a3,a3,a4
    80005524:	40000613          	li	a2,1024
    80005528:	c690                	sw	a2,8(a3)
  if(write)
    8000552a:	140d0063          	beqz	s10,8000566a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000552e:	00018697          	auipc	a3,0x18
    80005532:	ad26b683          	ld	a3,-1326(a3) # 8001d000 <disk+0x2000>
    80005536:	96ba                	add	a3,a3,a4
    80005538:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000553c:	00016817          	auipc	a6,0x16
    80005540:	ac480813          	addi	a6,a6,-1340 # 8001b000 <disk>
    80005544:	00018517          	auipc	a0,0x18
    80005548:	abc50513          	addi	a0,a0,-1348 # 8001d000 <disk+0x2000>
    8000554c:	6114                	ld	a3,0(a0)
    8000554e:	96ba                	add	a3,a3,a4
    80005550:	00c6d603          	lhu	a2,12(a3)
    80005554:	00166613          	ori	a2,a2,1
    80005558:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000555c:	f9842683          	lw	a3,-104(s0)
    80005560:	6110                	ld	a2,0(a0)
    80005562:	9732                	add	a4,a4,a2
    80005564:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005568:	20058613          	addi	a2,a1,512
    8000556c:	0612                	slli	a2,a2,0x4
    8000556e:	9642                	add	a2,a2,a6
    80005570:	577d                	li	a4,-1
    80005572:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005576:	00469713          	slli	a4,a3,0x4
    8000557a:	6114                	ld	a3,0(a0)
    8000557c:	96ba                	add	a3,a3,a4
    8000557e:	03078793          	addi	a5,a5,48
    80005582:	97c2                	add	a5,a5,a6
    80005584:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005586:	611c                	ld	a5,0(a0)
    80005588:	97ba                	add	a5,a5,a4
    8000558a:	4685                	li	a3,1
    8000558c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000558e:	611c                	ld	a5,0(a0)
    80005590:	97ba                	add	a5,a5,a4
    80005592:	4809                	li	a6,2
    80005594:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005598:	611c                	ld	a5,0(a0)
    8000559a:	973e                	add	a4,a4,a5
    8000559c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055a0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800055a4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055a8:	6518                	ld	a4,8(a0)
    800055aa:	00275783          	lhu	a5,2(a4)
    800055ae:	8b9d                	andi	a5,a5,7
    800055b0:	0786                	slli	a5,a5,0x1
    800055b2:	97ba                	add	a5,a5,a4
    800055b4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055b8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055bc:	6518                	ld	a4,8(a0)
    800055be:	00275783          	lhu	a5,2(a4)
    800055c2:	2785                	addiw	a5,a5,1
    800055c4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055c8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055cc:	100017b7          	lui	a5,0x10001
    800055d0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055d4:	00492703          	lw	a4,4(s2)
    800055d8:	4785                	li	a5,1
    800055da:	02f71163          	bne	a4,a5,800055fc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055de:	00018997          	auipc	s3,0x18
    800055e2:	b4a98993          	addi	s3,s3,-1206 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055e6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055e8:	85ce                	mv	a1,s3
    800055ea:	854a                	mv	a0,s2
    800055ec:	ffffc097          	auipc	ra,0xffffc
    800055f0:	f6e080e7          	jalr	-146(ra) # 8000155a <sleep>
  while(b->disk == 1) {
    800055f4:	00492783          	lw	a5,4(s2)
    800055f8:	fe9788e3          	beq	a5,s1,800055e8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055fc:	f9042903          	lw	s2,-112(s0)
    80005600:	20090793          	addi	a5,s2,512
    80005604:	00479713          	slli	a4,a5,0x4
    80005608:	00016797          	auipc	a5,0x16
    8000560c:	9f878793          	addi	a5,a5,-1544 # 8001b000 <disk>
    80005610:	97ba                	add	a5,a5,a4
    80005612:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005616:	00018997          	auipc	s3,0x18
    8000561a:	9ea98993          	addi	s3,s3,-1558 # 8001d000 <disk+0x2000>
    8000561e:	00491713          	slli	a4,s2,0x4
    80005622:	0009b783          	ld	a5,0(s3)
    80005626:	97ba                	add	a5,a5,a4
    80005628:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000562c:	854a                	mv	a0,s2
    8000562e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005632:	00000097          	auipc	ra,0x0
    80005636:	bc4080e7          	jalr	-1084(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000563a:	8885                	andi	s1,s1,1
    8000563c:	f0ed                	bnez	s1,8000561e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000563e:	00018517          	auipc	a0,0x18
    80005642:	aea50513          	addi	a0,a0,-1302 # 8001d128 <disk+0x2128>
    80005646:	00001097          	auipc	ra,0x1
    8000564a:	c50080e7          	jalr	-944(ra) # 80006296 <release>
}
    8000564e:	70a6                	ld	ra,104(sp)
    80005650:	7406                	ld	s0,96(sp)
    80005652:	64e6                	ld	s1,88(sp)
    80005654:	6946                	ld	s2,80(sp)
    80005656:	69a6                	ld	s3,72(sp)
    80005658:	6a06                	ld	s4,64(sp)
    8000565a:	7ae2                	ld	s5,56(sp)
    8000565c:	7b42                	ld	s6,48(sp)
    8000565e:	7ba2                	ld	s7,40(sp)
    80005660:	7c02                	ld	s8,32(sp)
    80005662:	6ce2                	ld	s9,24(sp)
    80005664:	6d42                	ld	s10,16(sp)
    80005666:	6165                	addi	sp,sp,112
    80005668:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000566a:	00018697          	auipc	a3,0x18
    8000566e:	9966b683          	ld	a3,-1642(a3) # 8001d000 <disk+0x2000>
    80005672:	96ba                	add	a3,a3,a4
    80005674:	4609                	li	a2,2
    80005676:	00c69623          	sh	a2,12(a3)
    8000567a:	b5c9                	j	8000553c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000567c:	f9042583          	lw	a1,-112(s0)
    80005680:	20058793          	addi	a5,a1,512
    80005684:	0792                	slli	a5,a5,0x4
    80005686:	00016517          	auipc	a0,0x16
    8000568a:	a2250513          	addi	a0,a0,-1502 # 8001b0a8 <disk+0xa8>
    8000568e:	953e                	add	a0,a0,a5
  if(write)
    80005690:	e20d11e3          	bnez	s10,800054b2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005694:	20058713          	addi	a4,a1,512
    80005698:	00471693          	slli	a3,a4,0x4
    8000569c:	00016717          	auipc	a4,0x16
    800056a0:	96470713          	addi	a4,a4,-1692 # 8001b000 <disk>
    800056a4:	9736                	add	a4,a4,a3
    800056a6:	0a072423          	sw	zero,168(a4)
    800056aa:	b505                	j	800054ca <virtio_disk_rw+0xf4>

00000000800056ac <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056ac:	1101                	addi	sp,sp,-32
    800056ae:	ec06                	sd	ra,24(sp)
    800056b0:	e822                	sd	s0,16(sp)
    800056b2:	e426                	sd	s1,8(sp)
    800056b4:	e04a                	sd	s2,0(sp)
    800056b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056b8:	00018517          	auipc	a0,0x18
    800056bc:	a7050513          	addi	a0,a0,-1424 # 8001d128 <disk+0x2128>
    800056c0:	00001097          	auipc	ra,0x1
    800056c4:	b22080e7          	jalr	-1246(ra) # 800061e2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056c8:	10001737          	lui	a4,0x10001
    800056cc:	533c                	lw	a5,96(a4)
    800056ce:	8b8d                	andi	a5,a5,3
    800056d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056d6:	00018797          	auipc	a5,0x18
    800056da:	92a78793          	addi	a5,a5,-1750 # 8001d000 <disk+0x2000>
    800056de:	6b94                	ld	a3,16(a5)
    800056e0:	0207d703          	lhu	a4,32(a5)
    800056e4:	0026d783          	lhu	a5,2(a3)
    800056e8:	06f70163          	beq	a4,a5,8000574a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ec:	00016917          	auipc	s2,0x16
    800056f0:	91490913          	addi	s2,s2,-1772 # 8001b000 <disk>
    800056f4:	00018497          	auipc	s1,0x18
    800056f8:	90c48493          	addi	s1,s1,-1780 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056fc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005700:	6898                	ld	a4,16(s1)
    80005702:	0204d783          	lhu	a5,32(s1)
    80005706:	8b9d                	andi	a5,a5,7
    80005708:	078e                	slli	a5,a5,0x3
    8000570a:	97ba                	add	a5,a5,a4
    8000570c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000570e:	20078713          	addi	a4,a5,512
    80005712:	0712                	slli	a4,a4,0x4
    80005714:	974a                	add	a4,a4,s2
    80005716:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000571a:	e731                	bnez	a4,80005766 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000571c:	20078793          	addi	a5,a5,512
    80005720:	0792                	slli	a5,a5,0x4
    80005722:	97ca                	add	a5,a5,s2
    80005724:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005726:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000572a:	ffffc097          	auipc	ra,0xffffc
    8000572e:	fbc080e7          	jalr	-68(ra) # 800016e6 <wakeup>

    disk.used_idx += 1;
    80005732:	0204d783          	lhu	a5,32(s1)
    80005736:	2785                	addiw	a5,a5,1
    80005738:	17c2                	slli	a5,a5,0x30
    8000573a:	93c1                	srli	a5,a5,0x30
    8000573c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005740:	6898                	ld	a4,16(s1)
    80005742:	00275703          	lhu	a4,2(a4)
    80005746:	faf71be3          	bne	a4,a5,800056fc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000574a:	00018517          	auipc	a0,0x18
    8000574e:	9de50513          	addi	a0,a0,-1570 # 8001d128 <disk+0x2128>
    80005752:	00001097          	auipc	ra,0x1
    80005756:	b44080e7          	jalr	-1212(ra) # 80006296 <release>
}
    8000575a:	60e2                	ld	ra,24(sp)
    8000575c:	6442                	ld	s0,16(sp)
    8000575e:	64a2                	ld	s1,8(sp)
    80005760:	6902                	ld	s2,0(sp)
    80005762:	6105                	addi	sp,sp,32
    80005764:	8082                	ret
      panic("virtio_disk_intr status");
    80005766:	00003517          	auipc	a0,0x3
    8000576a:	19a50513          	addi	a0,a0,410 # 80008900 <syscall_names+0x3b0>
    8000576e:	00000097          	auipc	ra,0x0
    80005772:	52a080e7          	jalr	1322(ra) # 80005c98 <panic>

0000000080005776 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005776:	1141                	addi	sp,sp,-16
    80005778:	e422                	sd	s0,8(sp)
    8000577a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000577c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005780:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005784:	0037979b          	slliw	a5,a5,0x3
    80005788:	02004737          	lui	a4,0x2004
    8000578c:	97ba                	add	a5,a5,a4
    8000578e:	0200c737          	lui	a4,0x200c
    80005792:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005796:	000f4637          	lui	a2,0xf4
    8000579a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000579e:	95b2                	add	a1,a1,a2
    800057a0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057a2:	00269713          	slli	a4,a3,0x2
    800057a6:	9736                	add	a4,a4,a3
    800057a8:	00371693          	slli	a3,a4,0x3
    800057ac:	00019717          	auipc	a4,0x19
    800057b0:	85470713          	addi	a4,a4,-1964 # 8001e000 <timer_scratch>
    800057b4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057b6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057b8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ba:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057be:	00000797          	auipc	a5,0x0
    800057c2:	97278793          	addi	a5,a5,-1678 # 80005130 <timervec>
    800057c6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ca:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057ce:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057d6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057da:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057de:	30479073          	csrw	mie,a5
}
    800057e2:	6422                	ld	s0,8(sp)
    800057e4:	0141                	addi	sp,sp,16
    800057e6:	8082                	ret

00000000800057e8 <start>:
{
    800057e8:	1141                	addi	sp,sp,-16
    800057ea:	e406                	sd	ra,8(sp)
    800057ec:	e022                	sd	s0,0(sp)
    800057ee:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057f0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057f4:	7779                	lui	a4,0xffffe
    800057f6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057fa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057fc:	6705                	lui	a4,0x1
    800057fe:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005802:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005804:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005808:	ffffb797          	auipc	a5,0xffffb
    8000580c:	b6878793          	addi	a5,a5,-1176 # 80000370 <main>
    80005810:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005814:	4781                	li	a5,0
    80005816:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000581a:	67c1                	lui	a5,0x10
    8000581c:	17fd                	addi	a5,a5,-1
    8000581e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005822:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005826:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000582a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000582e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005832:	57fd                	li	a5,-1
    80005834:	83a9                	srli	a5,a5,0xa
    80005836:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000583a:	47bd                	li	a5,15
    8000583c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005840:	00000097          	auipc	ra,0x0
    80005844:	f36080e7          	jalr	-202(ra) # 80005776 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005848:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000584c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000584e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005850:	30200073          	mret
}
    80005854:	60a2                	ld	ra,8(sp)
    80005856:	6402                	ld	s0,0(sp)
    80005858:	0141                	addi	sp,sp,16
    8000585a:	8082                	ret

000000008000585c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000585c:	715d                	addi	sp,sp,-80
    8000585e:	e486                	sd	ra,72(sp)
    80005860:	e0a2                	sd	s0,64(sp)
    80005862:	fc26                	sd	s1,56(sp)
    80005864:	f84a                	sd	s2,48(sp)
    80005866:	f44e                	sd	s3,40(sp)
    80005868:	f052                	sd	s4,32(sp)
    8000586a:	ec56                	sd	s5,24(sp)
    8000586c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000586e:	04c05663          	blez	a2,800058ba <consolewrite+0x5e>
    80005872:	8a2a                	mv	s4,a0
    80005874:	84ae                	mv	s1,a1
    80005876:	89b2                	mv	s3,a2
    80005878:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000587a:	5afd                	li	s5,-1
    8000587c:	4685                	li	a3,1
    8000587e:	8626                	mv	a2,s1
    80005880:	85d2                	mv	a1,s4
    80005882:	fbf40513          	addi	a0,s0,-65
    80005886:	ffffc097          	auipc	ra,0xffffc
    8000588a:	0ce080e7          	jalr	206(ra) # 80001954 <either_copyin>
    8000588e:	01550c63          	beq	a0,s5,800058a6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005892:	fbf44503          	lbu	a0,-65(s0)
    80005896:	00000097          	auipc	ra,0x0
    8000589a:	78e080e7          	jalr	1934(ra) # 80006024 <uartputc>
  for(i = 0; i < n; i++){
    8000589e:	2905                	addiw	s2,s2,1
    800058a0:	0485                	addi	s1,s1,1
    800058a2:	fd299de3          	bne	s3,s2,8000587c <consolewrite+0x20>
  }

  return i;
}
    800058a6:	854a                	mv	a0,s2
    800058a8:	60a6                	ld	ra,72(sp)
    800058aa:	6406                	ld	s0,64(sp)
    800058ac:	74e2                	ld	s1,56(sp)
    800058ae:	7942                	ld	s2,48(sp)
    800058b0:	79a2                	ld	s3,40(sp)
    800058b2:	7a02                	ld	s4,32(sp)
    800058b4:	6ae2                	ld	s5,24(sp)
    800058b6:	6161                	addi	sp,sp,80
    800058b8:	8082                	ret
  for(i = 0; i < n; i++){
    800058ba:	4901                	li	s2,0
    800058bc:	b7ed                	j	800058a6 <consolewrite+0x4a>

00000000800058be <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058be:	7119                	addi	sp,sp,-128
    800058c0:	fc86                	sd	ra,120(sp)
    800058c2:	f8a2                	sd	s0,112(sp)
    800058c4:	f4a6                	sd	s1,104(sp)
    800058c6:	f0ca                	sd	s2,96(sp)
    800058c8:	ecce                	sd	s3,88(sp)
    800058ca:	e8d2                	sd	s4,80(sp)
    800058cc:	e4d6                	sd	s5,72(sp)
    800058ce:	e0da                	sd	s6,64(sp)
    800058d0:	fc5e                	sd	s7,56(sp)
    800058d2:	f862                	sd	s8,48(sp)
    800058d4:	f466                	sd	s9,40(sp)
    800058d6:	f06a                	sd	s10,32(sp)
    800058d8:	ec6e                	sd	s11,24(sp)
    800058da:	0100                	addi	s0,sp,128
    800058dc:	8b2a                	mv	s6,a0
    800058de:	8aae                	mv	s5,a1
    800058e0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058e2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058e6:	00021517          	auipc	a0,0x21
    800058ea:	85a50513          	addi	a0,a0,-1958 # 80026140 <cons>
    800058ee:	00001097          	auipc	ra,0x1
    800058f2:	8f4080e7          	jalr	-1804(ra) # 800061e2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058f6:	00021497          	auipc	s1,0x21
    800058fa:	84a48493          	addi	s1,s1,-1974 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058fe:	89a6                	mv	s3,s1
    80005900:	00021917          	auipc	s2,0x21
    80005904:	8d890913          	addi	s2,s2,-1832 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005908:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000590a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000590c:	4da9                	li	s11,10
  while(n > 0){
    8000590e:	07405863          	blez	s4,8000597e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005912:	0984a783          	lw	a5,152(s1)
    80005916:	09c4a703          	lw	a4,156(s1)
    8000591a:	02f71463          	bne	a4,a5,80005942 <consoleread+0x84>
      if(myproc()->killed){
    8000591e:	ffffb097          	auipc	ra,0xffffb
    80005922:	574080e7          	jalr	1396(ra) # 80000e92 <myproc>
    80005926:	551c                	lw	a5,40(a0)
    80005928:	e7b5                	bnez	a5,80005994 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000592a:	85ce                	mv	a1,s3
    8000592c:	854a                	mv	a0,s2
    8000592e:	ffffc097          	auipc	ra,0xffffc
    80005932:	c2c080e7          	jalr	-980(ra) # 8000155a <sleep>
    while(cons.r == cons.w){
    80005936:	0984a783          	lw	a5,152(s1)
    8000593a:	09c4a703          	lw	a4,156(s1)
    8000593e:	fef700e3          	beq	a4,a5,8000591e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005942:	0017871b          	addiw	a4,a5,1
    80005946:	08e4ac23          	sw	a4,152(s1)
    8000594a:	07f7f713          	andi	a4,a5,127
    8000594e:	9726                	add	a4,a4,s1
    80005950:	01874703          	lbu	a4,24(a4)
    80005954:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005958:	079c0663          	beq	s8,s9,800059c4 <consoleread+0x106>
    cbuf = c;
    8000595c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005960:	4685                	li	a3,1
    80005962:	f8f40613          	addi	a2,s0,-113
    80005966:	85d6                	mv	a1,s5
    80005968:	855a                	mv	a0,s6
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	f94080e7          	jalr	-108(ra) # 800018fe <either_copyout>
    80005972:	01a50663          	beq	a0,s10,8000597e <consoleread+0xc0>
    dst++;
    80005976:	0a85                	addi	s5,s5,1
    --n;
    80005978:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000597a:	f9bc1ae3          	bne	s8,s11,8000590e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000597e:	00020517          	auipc	a0,0x20
    80005982:	7c250513          	addi	a0,a0,1986 # 80026140 <cons>
    80005986:	00001097          	auipc	ra,0x1
    8000598a:	910080e7          	jalr	-1776(ra) # 80006296 <release>

  return target - n;
    8000598e:	414b853b          	subw	a0,s7,s4
    80005992:	a811                	j	800059a6 <consoleread+0xe8>
        release(&cons.lock);
    80005994:	00020517          	auipc	a0,0x20
    80005998:	7ac50513          	addi	a0,a0,1964 # 80026140 <cons>
    8000599c:	00001097          	auipc	ra,0x1
    800059a0:	8fa080e7          	jalr	-1798(ra) # 80006296 <release>
        return -1;
    800059a4:	557d                	li	a0,-1
}
    800059a6:	70e6                	ld	ra,120(sp)
    800059a8:	7446                	ld	s0,112(sp)
    800059aa:	74a6                	ld	s1,104(sp)
    800059ac:	7906                	ld	s2,96(sp)
    800059ae:	69e6                	ld	s3,88(sp)
    800059b0:	6a46                	ld	s4,80(sp)
    800059b2:	6aa6                	ld	s5,72(sp)
    800059b4:	6b06                	ld	s6,64(sp)
    800059b6:	7be2                	ld	s7,56(sp)
    800059b8:	7c42                	ld	s8,48(sp)
    800059ba:	7ca2                	ld	s9,40(sp)
    800059bc:	7d02                	ld	s10,32(sp)
    800059be:	6de2                	ld	s11,24(sp)
    800059c0:	6109                	addi	sp,sp,128
    800059c2:	8082                	ret
      if(n < target){
    800059c4:	000a071b          	sext.w	a4,s4
    800059c8:	fb777be3          	bgeu	a4,s7,8000597e <consoleread+0xc0>
        cons.r--;
    800059cc:	00021717          	auipc	a4,0x21
    800059d0:	80f72623          	sw	a5,-2036(a4) # 800261d8 <cons+0x98>
    800059d4:	b76d                	j	8000597e <consoleread+0xc0>

00000000800059d6 <consputc>:
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e406                	sd	ra,8(sp)
    800059da:	e022                	sd	s0,0(sp)
    800059dc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059de:	10000793          	li	a5,256
    800059e2:	00f50a63          	beq	a0,a5,800059f6 <consputc+0x20>
    uartputc_sync(c);
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	564080e7          	jalr	1380(ra) # 80005f4a <uartputc_sync>
}
    800059ee:	60a2                	ld	ra,8(sp)
    800059f0:	6402                	ld	s0,0(sp)
    800059f2:	0141                	addi	sp,sp,16
    800059f4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059f6:	4521                	li	a0,8
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	552080e7          	jalr	1362(ra) # 80005f4a <uartputc_sync>
    80005a00:	02000513          	li	a0,32
    80005a04:	00000097          	auipc	ra,0x0
    80005a08:	546080e7          	jalr	1350(ra) # 80005f4a <uartputc_sync>
    80005a0c:	4521                	li	a0,8
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	53c080e7          	jalr	1340(ra) # 80005f4a <uartputc_sync>
    80005a16:	bfe1                	j	800059ee <consputc+0x18>

0000000080005a18 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a18:	1101                	addi	sp,sp,-32
    80005a1a:	ec06                	sd	ra,24(sp)
    80005a1c:	e822                	sd	s0,16(sp)
    80005a1e:	e426                	sd	s1,8(sp)
    80005a20:	e04a                	sd	s2,0(sp)
    80005a22:	1000                	addi	s0,sp,32
    80005a24:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a26:	00020517          	auipc	a0,0x20
    80005a2a:	71a50513          	addi	a0,a0,1818 # 80026140 <cons>
    80005a2e:	00000097          	auipc	ra,0x0
    80005a32:	7b4080e7          	jalr	1972(ra) # 800061e2 <acquire>

  switch(c){
    80005a36:	47d5                	li	a5,21
    80005a38:	0af48663          	beq	s1,a5,80005ae4 <consoleintr+0xcc>
    80005a3c:	0297ca63          	blt	a5,s1,80005a70 <consoleintr+0x58>
    80005a40:	47a1                	li	a5,8
    80005a42:	0ef48763          	beq	s1,a5,80005b30 <consoleintr+0x118>
    80005a46:	47c1                	li	a5,16
    80005a48:	10f49a63          	bne	s1,a5,80005b5c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	f5e080e7          	jalr	-162(ra) # 800019aa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a54:	00020517          	auipc	a0,0x20
    80005a58:	6ec50513          	addi	a0,a0,1772 # 80026140 <cons>
    80005a5c:	00001097          	auipc	ra,0x1
    80005a60:	83a080e7          	jalr	-1990(ra) # 80006296 <release>
}
    80005a64:	60e2                	ld	ra,24(sp)
    80005a66:	6442                	ld	s0,16(sp)
    80005a68:	64a2                	ld	s1,8(sp)
    80005a6a:	6902                	ld	s2,0(sp)
    80005a6c:	6105                	addi	sp,sp,32
    80005a6e:	8082                	ret
  switch(c){
    80005a70:	07f00793          	li	a5,127
    80005a74:	0af48e63          	beq	s1,a5,80005b30 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a78:	00020717          	auipc	a4,0x20
    80005a7c:	6c870713          	addi	a4,a4,1736 # 80026140 <cons>
    80005a80:	0a072783          	lw	a5,160(a4)
    80005a84:	09872703          	lw	a4,152(a4)
    80005a88:	9f99                	subw	a5,a5,a4
    80005a8a:	07f00713          	li	a4,127
    80005a8e:	fcf763e3          	bltu	a4,a5,80005a54 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a92:	47b5                	li	a5,13
    80005a94:	0cf48763          	beq	s1,a5,80005b62 <consoleintr+0x14a>
      consputc(c);
    80005a98:	8526                	mv	a0,s1
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	f3c080e7          	jalr	-196(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa2:	00020797          	auipc	a5,0x20
    80005aa6:	69e78793          	addi	a5,a5,1694 # 80026140 <cons>
    80005aaa:	0a07a703          	lw	a4,160(a5)
    80005aae:	0017069b          	addiw	a3,a4,1
    80005ab2:	0006861b          	sext.w	a2,a3
    80005ab6:	0ad7a023          	sw	a3,160(a5)
    80005aba:	07f77713          	andi	a4,a4,127
    80005abe:	97ba                	add	a5,a5,a4
    80005ac0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ac4:	47a9                	li	a5,10
    80005ac6:	0cf48563          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005aca:	4791                	li	a5,4
    80005acc:	0cf48263          	beq	s1,a5,80005b90 <consoleintr+0x178>
    80005ad0:	00020797          	auipc	a5,0x20
    80005ad4:	7087a783          	lw	a5,1800(a5) # 800261d8 <cons+0x98>
    80005ad8:	0807879b          	addiw	a5,a5,128
    80005adc:	f6f61ce3          	bne	a2,a5,80005a54 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ae0:	863e                	mv	a2,a5
    80005ae2:	a07d                	j	80005b90 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ae4:	00020717          	auipc	a4,0x20
    80005ae8:	65c70713          	addi	a4,a4,1628 # 80026140 <cons>
    80005aec:	0a072783          	lw	a5,160(a4)
    80005af0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005af4:	00020497          	auipc	s1,0x20
    80005af8:	64c48493          	addi	s1,s1,1612 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005afc:	4929                	li	s2,10
    80005afe:	f4f70be3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b02:	37fd                	addiw	a5,a5,-1
    80005b04:	07f7f713          	andi	a4,a5,127
    80005b08:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b0a:	01874703          	lbu	a4,24(a4)
    80005b0e:	f52703e3          	beq	a4,s2,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b12:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b16:	10000513          	li	a0,256
    80005b1a:	00000097          	auipc	ra,0x0
    80005b1e:	ebc080e7          	jalr	-324(ra) # 800059d6 <consputc>
    while(cons.e != cons.w &&
    80005b22:	0a04a783          	lw	a5,160(s1)
    80005b26:	09c4a703          	lw	a4,156(s1)
    80005b2a:	fcf71ce3          	bne	a4,a5,80005b02 <consoleintr+0xea>
    80005b2e:	b71d                	j	80005a54 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b30:	00020717          	auipc	a4,0x20
    80005b34:	61070713          	addi	a4,a4,1552 # 80026140 <cons>
    80005b38:	0a072783          	lw	a5,160(a4)
    80005b3c:	09c72703          	lw	a4,156(a4)
    80005b40:	f0f70ae3          	beq	a4,a5,80005a54 <consoleintr+0x3c>
      cons.e--;
    80005b44:	37fd                	addiw	a5,a5,-1
    80005b46:	00020717          	auipc	a4,0x20
    80005b4a:	68f72d23          	sw	a5,1690(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b4e:	10000513          	li	a0,256
    80005b52:	00000097          	auipc	ra,0x0
    80005b56:	e84080e7          	jalr	-380(ra) # 800059d6 <consputc>
    80005b5a:	bded                	j	80005a54 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b5c:	ee048ce3          	beqz	s1,80005a54 <consoleintr+0x3c>
    80005b60:	bf21                	j	80005a78 <consoleintr+0x60>
      consputc(c);
    80005b62:	4529                	li	a0,10
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e72080e7          	jalr	-398(ra) # 800059d6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b6c:	00020797          	auipc	a5,0x20
    80005b70:	5d478793          	addi	a5,a5,1492 # 80026140 <cons>
    80005b74:	0a07a703          	lw	a4,160(a5)
    80005b78:	0017069b          	addiw	a3,a4,1
    80005b7c:	0006861b          	sext.w	a2,a3
    80005b80:	0ad7a023          	sw	a3,160(a5)
    80005b84:	07f77713          	andi	a4,a4,127
    80005b88:	97ba                	add	a5,a5,a4
    80005b8a:	4729                	li	a4,10
    80005b8c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b90:	00020797          	auipc	a5,0x20
    80005b94:	64c7a623          	sw	a2,1612(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b98:	00020517          	auipc	a0,0x20
    80005b9c:	64050513          	addi	a0,a0,1600 # 800261d8 <cons+0x98>
    80005ba0:	ffffc097          	auipc	ra,0xffffc
    80005ba4:	b46080e7          	jalr	-1210(ra) # 800016e6 <wakeup>
    80005ba8:	b575                	j	80005a54 <consoleintr+0x3c>

0000000080005baa <consoleinit>:

void
consoleinit(void)
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e406                	sd	ra,8(sp)
    80005bae:	e022                	sd	s0,0(sp)
    80005bb0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bb2:	00003597          	auipc	a1,0x3
    80005bb6:	d6658593          	addi	a1,a1,-666 # 80008918 <syscall_names+0x3c8>
    80005bba:	00020517          	auipc	a0,0x20
    80005bbe:	58650513          	addi	a0,a0,1414 # 80026140 <cons>
    80005bc2:	00000097          	auipc	ra,0x0
    80005bc6:	590080e7          	jalr	1424(ra) # 80006152 <initlock>

  uartinit();
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	330080e7          	jalr	816(ra) # 80005efa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bd2:	00013797          	auipc	a5,0x13
    80005bd6:	6f678793          	addi	a5,a5,1782 # 800192c8 <devsw>
    80005bda:	00000717          	auipc	a4,0x0
    80005bde:	ce470713          	addi	a4,a4,-796 # 800058be <consoleread>
    80005be2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005be4:	00000717          	auipc	a4,0x0
    80005be8:	c7870713          	addi	a4,a4,-904 # 8000585c <consolewrite>
    80005bec:	ef98                	sd	a4,24(a5)
}
    80005bee:	60a2                	ld	ra,8(sp)
    80005bf0:	6402                	ld	s0,0(sp)
    80005bf2:	0141                	addi	sp,sp,16
    80005bf4:	8082                	ret

0000000080005bf6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bf6:	7179                	addi	sp,sp,-48
    80005bf8:	f406                	sd	ra,40(sp)
    80005bfa:	f022                	sd	s0,32(sp)
    80005bfc:	ec26                	sd	s1,24(sp)
    80005bfe:	e84a                	sd	s2,16(sp)
    80005c00:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c02:	c219                	beqz	a2,80005c08 <printint+0x12>
    80005c04:	08054663          	bltz	a0,80005c90 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c08:	2501                	sext.w	a0,a0
    80005c0a:	4881                	li	a7,0
    80005c0c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c10:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c12:	2581                	sext.w	a1,a1
    80005c14:	00003617          	auipc	a2,0x3
    80005c18:	d3460613          	addi	a2,a2,-716 # 80008948 <digits>
    80005c1c:	883a                	mv	a6,a4
    80005c1e:	2705                	addiw	a4,a4,1
    80005c20:	02b577bb          	remuw	a5,a0,a1
    80005c24:	1782                	slli	a5,a5,0x20
    80005c26:	9381                	srli	a5,a5,0x20
    80005c28:	97b2                	add	a5,a5,a2
    80005c2a:	0007c783          	lbu	a5,0(a5)
    80005c2e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c32:	0005079b          	sext.w	a5,a0
    80005c36:	02b5553b          	divuw	a0,a0,a1
    80005c3a:	0685                	addi	a3,a3,1
    80005c3c:	feb7f0e3          	bgeu	a5,a1,80005c1c <printint+0x26>

  if(sign)
    80005c40:	00088b63          	beqz	a7,80005c56 <printint+0x60>
    buf[i++] = '-';
    80005c44:	fe040793          	addi	a5,s0,-32
    80005c48:	973e                	add	a4,a4,a5
    80005c4a:	02d00793          	li	a5,45
    80005c4e:	fef70823          	sb	a5,-16(a4)
    80005c52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c56:	02e05763          	blez	a4,80005c84 <printint+0x8e>
    80005c5a:	fd040793          	addi	a5,s0,-48
    80005c5e:	00e784b3          	add	s1,a5,a4
    80005c62:	fff78913          	addi	s2,a5,-1
    80005c66:	993a                	add	s2,s2,a4
    80005c68:	377d                	addiw	a4,a4,-1
    80005c6a:	1702                	slli	a4,a4,0x20
    80005c6c:	9301                	srli	a4,a4,0x20
    80005c6e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c72:	fff4c503          	lbu	a0,-1(s1)
    80005c76:	00000097          	auipc	ra,0x0
    80005c7a:	d60080e7          	jalr	-672(ra) # 800059d6 <consputc>
  while(--i >= 0)
    80005c7e:	14fd                	addi	s1,s1,-1
    80005c80:	ff2499e3          	bne	s1,s2,80005c72 <printint+0x7c>
}
    80005c84:	70a2                	ld	ra,40(sp)
    80005c86:	7402                	ld	s0,32(sp)
    80005c88:	64e2                	ld	s1,24(sp)
    80005c8a:	6942                	ld	s2,16(sp)
    80005c8c:	6145                	addi	sp,sp,48
    80005c8e:	8082                	ret
    x = -xx;
    80005c90:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c94:	4885                	li	a7,1
    x = -xx;
    80005c96:	bf9d                	j	80005c0c <printint+0x16>

0000000080005c98 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c98:	1101                	addi	sp,sp,-32
    80005c9a:	ec06                	sd	ra,24(sp)
    80005c9c:	e822                	sd	s0,16(sp)
    80005c9e:	e426                	sd	s1,8(sp)
    80005ca0:	1000                	addi	s0,sp,32
    80005ca2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ca4:	00020797          	auipc	a5,0x20
    80005ca8:	5407ae23          	sw	zero,1372(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cac:	00003517          	auipc	a0,0x3
    80005cb0:	c7450513          	addi	a0,a0,-908 # 80008920 <syscall_names+0x3d0>
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	02e080e7          	jalr	46(ra) # 80005ce2 <printf>
  printf(s);
    80005cbc:	8526                	mv	a0,s1
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	024080e7          	jalr	36(ra) # 80005ce2 <printf>
  printf("\n");
    80005cc6:	00002517          	auipc	a0,0x2
    80005cca:	38250513          	addi	a0,a0,898 # 80008048 <etext+0x48>
    80005cce:	00000097          	auipc	ra,0x0
    80005cd2:	014080e7          	jalr	20(ra) # 80005ce2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cd6:	4785                	li	a5,1
    80005cd8:	00003717          	auipc	a4,0x3
    80005cdc:	34f72223          	sw	a5,836(a4) # 8000901c <panicked>
  for(;;)
    80005ce0:	a001                	j	80005ce0 <panic+0x48>

0000000080005ce2 <printf>:
{
    80005ce2:	7131                	addi	sp,sp,-192
    80005ce4:	fc86                	sd	ra,120(sp)
    80005ce6:	f8a2                	sd	s0,112(sp)
    80005ce8:	f4a6                	sd	s1,104(sp)
    80005cea:	f0ca                	sd	s2,96(sp)
    80005cec:	ecce                	sd	s3,88(sp)
    80005cee:	e8d2                	sd	s4,80(sp)
    80005cf0:	e4d6                	sd	s5,72(sp)
    80005cf2:	e0da                	sd	s6,64(sp)
    80005cf4:	fc5e                	sd	s7,56(sp)
    80005cf6:	f862                	sd	s8,48(sp)
    80005cf8:	f466                	sd	s9,40(sp)
    80005cfa:	f06a                	sd	s10,32(sp)
    80005cfc:	ec6e                	sd	s11,24(sp)
    80005cfe:	0100                	addi	s0,sp,128
    80005d00:	8a2a                	mv	s4,a0
    80005d02:	e40c                	sd	a1,8(s0)
    80005d04:	e810                	sd	a2,16(s0)
    80005d06:	ec14                	sd	a3,24(s0)
    80005d08:	f018                	sd	a4,32(s0)
    80005d0a:	f41c                	sd	a5,40(s0)
    80005d0c:	03043823          	sd	a6,48(s0)
    80005d10:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d14:	00020d97          	auipc	s11,0x20
    80005d18:	4ecdad83          	lw	s11,1260(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d1c:	020d9b63          	bnez	s11,80005d52 <printf+0x70>
  if (fmt == 0)
    80005d20:	040a0263          	beqz	s4,80005d64 <printf+0x82>
  va_start(ap, fmt);
    80005d24:	00840793          	addi	a5,s0,8
    80005d28:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2c:	000a4503          	lbu	a0,0(s4)
    80005d30:	16050263          	beqz	a0,80005e94 <printf+0x1b2>
    80005d34:	4481                	li	s1,0
    if(c != '%'){
    80005d36:	02500a93          	li	s5,37
    switch(c){
    80005d3a:	07000b13          	li	s6,112
  consputc('x');
    80005d3e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d40:	00003b97          	auipc	s7,0x3
    80005d44:	c08b8b93          	addi	s7,s7,-1016 # 80008948 <digits>
    switch(c){
    80005d48:	07300c93          	li	s9,115
    80005d4c:	06400c13          	li	s8,100
    80005d50:	a82d                	j	80005d8a <printf+0xa8>
    acquire(&pr.lock);
    80005d52:	00020517          	auipc	a0,0x20
    80005d56:	49650513          	addi	a0,a0,1174 # 800261e8 <pr>
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	488080e7          	jalr	1160(ra) # 800061e2 <acquire>
    80005d62:	bf7d                	j	80005d20 <printf+0x3e>
    panic("null fmt");
    80005d64:	00003517          	auipc	a0,0x3
    80005d68:	bcc50513          	addi	a0,a0,-1076 # 80008930 <syscall_names+0x3e0>
    80005d6c:	00000097          	auipc	ra,0x0
    80005d70:	f2c080e7          	jalr	-212(ra) # 80005c98 <panic>
      consputc(c);
    80005d74:	00000097          	auipc	ra,0x0
    80005d78:	c62080e7          	jalr	-926(ra) # 800059d6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d7c:	2485                	addiw	s1,s1,1
    80005d7e:	009a07b3          	add	a5,s4,s1
    80005d82:	0007c503          	lbu	a0,0(a5)
    80005d86:	10050763          	beqz	a0,80005e94 <printf+0x1b2>
    if(c != '%'){
    80005d8a:	ff5515e3          	bne	a0,s5,80005d74 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d8e:	2485                	addiw	s1,s1,1
    80005d90:	009a07b3          	add	a5,s4,s1
    80005d94:	0007c783          	lbu	a5,0(a5)
    80005d98:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d9c:	cfe5                	beqz	a5,80005e94 <printf+0x1b2>
    switch(c){
    80005d9e:	05678a63          	beq	a5,s6,80005df2 <printf+0x110>
    80005da2:	02fb7663          	bgeu	s6,a5,80005dce <printf+0xec>
    80005da6:	09978963          	beq	a5,s9,80005e38 <printf+0x156>
    80005daa:	07800713          	li	a4,120
    80005dae:	0ce79863          	bne	a5,a4,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	4605                	li	a2,1
    80005dc0:	85ea                	mv	a1,s10
    80005dc2:	4388                	lw	a0,0(a5)
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	e32080e7          	jalr	-462(ra) # 80005bf6 <printint>
      break;
    80005dcc:	bf45                	j	80005d7c <printf+0x9a>
    switch(c){
    80005dce:	0b578263          	beq	a5,s5,80005e72 <printf+0x190>
    80005dd2:	0b879663          	bne	a5,s8,80005e7e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005dd6:	f8843783          	ld	a5,-120(s0)
    80005dda:	00878713          	addi	a4,a5,8
    80005dde:	f8e43423          	sd	a4,-120(s0)
    80005de2:	4605                	li	a2,1
    80005de4:	45a9                	li	a1,10
    80005de6:	4388                	lw	a0,0(a5)
    80005de8:	00000097          	auipc	ra,0x0
    80005dec:	e0e080e7          	jalr	-498(ra) # 80005bf6 <printint>
      break;
    80005df0:	b771                	j	80005d7c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005df2:	f8843783          	ld	a5,-120(s0)
    80005df6:	00878713          	addi	a4,a5,8
    80005dfa:	f8e43423          	sd	a4,-120(s0)
    80005dfe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e02:	03000513          	li	a0,48
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	bd0080e7          	jalr	-1072(ra) # 800059d6 <consputc>
  consputc('x');
    80005e0e:	07800513          	li	a0,120
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	bc4080e7          	jalr	-1084(ra) # 800059d6 <consputc>
    80005e1a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e1c:	03c9d793          	srli	a5,s3,0x3c
    80005e20:	97de                	add	a5,a5,s7
    80005e22:	0007c503          	lbu	a0,0(a5)
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	bb0080e7          	jalr	-1104(ra) # 800059d6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e2e:	0992                	slli	s3,s3,0x4
    80005e30:	397d                	addiw	s2,s2,-1
    80005e32:	fe0915e3          	bnez	s2,80005e1c <printf+0x13a>
    80005e36:	b799                	j	80005d7c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e38:	f8843783          	ld	a5,-120(s0)
    80005e3c:	00878713          	addi	a4,a5,8
    80005e40:	f8e43423          	sd	a4,-120(s0)
    80005e44:	0007b903          	ld	s2,0(a5)
    80005e48:	00090e63          	beqz	s2,80005e64 <printf+0x182>
      for(; *s; s++)
    80005e4c:	00094503          	lbu	a0,0(s2)
    80005e50:	d515                	beqz	a0,80005d7c <printf+0x9a>
        consputc(*s);
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	b84080e7          	jalr	-1148(ra) # 800059d6 <consputc>
      for(; *s; s++)
    80005e5a:	0905                	addi	s2,s2,1
    80005e5c:	00094503          	lbu	a0,0(s2)
    80005e60:	f96d                	bnez	a0,80005e52 <printf+0x170>
    80005e62:	bf29                	j	80005d7c <printf+0x9a>
        s = "(null)";
    80005e64:	00003917          	auipc	s2,0x3
    80005e68:	ac490913          	addi	s2,s2,-1340 # 80008928 <syscall_names+0x3d8>
      for(; *s; s++)
    80005e6c:	02800513          	li	a0,40
    80005e70:	b7cd                	j	80005e52 <printf+0x170>
      consputc('%');
    80005e72:	8556                	mv	a0,s5
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	b62080e7          	jalr	-1182(ra) # 800059d6 <consputc>
      break;
    80005e7c:	b701                	j	80005d7c <printf+0x9a>
      consputc('%');
    80005e7e:	8556                	mv	a0,s5
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	b56080e7          	jalr	-1194(ra) # 800059d6 <consputc>
      consputc(c);
    80005e88:	854a                	mv	a0,s2
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	b4c080e7          	jalr	-1204(ra) # 800059d6 <consputc>
      break;
    80005e92:	b5ed                	j	80005d7c <printf+0x9a>
  if(locking)
    80005e94:	020d9163          	bnez	s11,80005eb6 <printf+0x1d4>
}
    80005e98:	70e6                	ld	ra,120(sp)
    80005e9a:	7446                	ld	s0,112(sp)
    80005e9c:	74a6                	ld	s1,104(sp)
    80005e9e:	7906                	ld	s2,96(sp)
    80005ea0:	69e6                	ld	s3,88(sp)
    80005ea2:	6a46                	ld	s4,80(sp)
    80005ea4:	6aa6                	ld	s5,72(sp)
    80005ea6:	6b06                	ld	s6,64(sp)
    80005ea8:	7be2                	ld	s7,56(sp)
    80005eaa:	7c42                	ld	s8,48(sp)
    80005eac:	7ca2                	ld	s9,40(sp)
    80005eae:	7d02                	ld	s10,32(sp)
    80005eb0:	6de2                	ld	s11,24(sp)
    80005eb2:	6129                	addi	sp,sp,192
    80005eb4:	8082                	ret
    release(&pr.lock);
    80005eb6:	00020517          	auipc	a0,0x20
    80005eba:	33250513          	addi	a0,a0,818 # 800261e8 <pr>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	3d8080e7          	jalr	984(ra) # 80006296 <release>
}
    80005ec6:	bfc9                	j	80005e98 <printf+0x1b6>

0000000080005ec8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ec8:	1101                	addi	sp,sp,-32
    80005eca:	ec06                	sd	ra,24(sp)
    80005ecc:	e822                	sd	s0,16(sp)
    80005ece:	e426                	sd	s1,8(sp)
    80005ed0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ed2:	00020497          	auipc	s1,0x20
    80005ed6:	31648493          	addi	s1,s1,790 # 800261e8 <pr>
    80005eda:	00003597          	auipc	a1,0x3
    80005ede:	a6658593          	addi	a1,a1,-1434 # 80008940 <syscall_names+0x3f0>
    80005ee2:	8526                	mv	a0,s1
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	26e080e7          	jalr	622(ra) # 80006152 <initlock>
  pr.locking = 1;
    80005eec:	4785                	li	a5,1
    80005eee:	cc9c                	sw	a5,24(s1)
}
    80005ef0:	60e2                	ld	ra,24(sp)
    80005ef2:	6442                	ld	s0,16(sp)
    80005ef4:	64a2                	ld	s1,8(sp)
    80005ef6:	6105                	addi	sp,sp,32
    80005ef8:	8082                	ret

0000000080005efa <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005efa:	1141                	addi	sp,sp,-16
    80005efc:	e406                	sd	ra,8(sp)
    80005efe:	e022                	sd	s0,0(sp)
    80005f00:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f02:	100007b7          	lui	a5,0x10000
    80005f06:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f0a:	f8000713          	li	a4,-128
    80005f0e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f12:	470d                	li	a4,3
    80005f14:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f18:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f1c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f20:	469d                	li	a3,7
    80005f22:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f26:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f2a:	00003597          	auipc	a1,0x3
    80005f2e:	a3658593          	addi	a1,a1,-1482 # 80008960 <digits+0x18>
    80005f32:	00020517          	auipc	a0,0x20
    80005f36:	2d650513          	addi	a0,a0,726 # 80026208 <uart_tx_lock>
    80005f3a:	00000097          	auipc	ra,0x0
    80005f3e:	218080e7          	jalr	536(ra) # 80006152 <initlock>
}
    80005f42:	60a2                	ld	ra,8(sp)
    80005f44:	6402                	ld	s0,0(sp)
    80005f46:	0141                	addi	sp,sp,16
    80005f48:	8082                	ret

0000000080005f4a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f4a:	1101                	addi	sp,sp,-32
    80005f4c:	ec06                	sd	ra,24(sp)
    80005f4e:	e822                	sd	s0,16(sp)
    80005f50:	e426                	sd	s1,8(sp)
    80005f52:	1000                	addi	s0,sp,32
    80005f54:	84aa                	mv	s1,a0
  push_off();
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	240080e7          	jalr	576(ra) # 80006196 <push_off>

  if(panicked){
    80005f5e:	00003797          	auipc	a5,0x3
    80005f62:	0be7a783          	lw	a5,190(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f66:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f6a:	c391                	beqz	a5,80005f6e <uartputc_sync+0x24>
    for(;;)
    80005f6c:	a001                	j	80005f6c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f72:	0ff7f793          	andi	a5,a5,255
    80005f76:	0207f793          	andi	a5,a5,32
    80005f7a:	dbf5                	beqz	a5,80005f6e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f7c:	0ff4f793          	andi	a5,s1,255
    80005f80:	10000737          	lui	a4,0x10000
    80005f84:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f88:	00000097          	auipc	ra,0x0
    80005f8c:	2ae080e7          	jalr	686(ra) # 80006236 <pop_off>
}
    80005f90:	60e2                	ld	ra,24(sp)
    80005f92:	6442                	ld	s0,16(sp)
    80005f94:	64a2                	ld	s1,8(sp)
    80005f96:	6105                	addi	sp,sp,32
    80005f98:	8082                	ret

0000000080005f9a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f9a:	00003717          	auipc	a4,0x3
    80005f9e:	08673703          	ld	a4,134(a4) # 80009020 <uart_tx_r>
    80005fa2:	00003797          	auipc	a5,0x3
    80005fa6:	0867b783          	ld	a5,134(a5) # 80009028 <uart_tx_w>
    80005faa:	06e78c63          	beq	a5,a4,80006022 <uartstart+0x88>
{
    80005fae:	7139                	addi	sp,sp,-64
    80005fb0:	fc06                	sd	ra,56(sp)
    80005fb2:	f822                	sd	s0,48(sp)
    80005fb4:	f426                	sd	s1,40(sp)
    80005fb6:	f04a                	sd	s2,32(sp)
    80005fb8:	ec4e                	sd	s3,24(sp)
    80005fba:	e852                	sd	s4,16(sp)
    80005fbc:	e456                	sd	s5,8(sp)
    80005fbe:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc4:	00020a17          	auipc	s4,0x20
    80005fc8:	244a0a13          	addi	s4,s4,580 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fcc:	00003497          	auipc	s1,0x3
    80005fd0:	05448493          	addi	s1,s1,84 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fd4:	00003997          	auipc	s3,0x3
    80005fd8:	05498993          	addi	s3,s3,84 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fdc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fe0:	0ff7f793          	andi	a5,a5,255
    80005fe4:	0207f793          	andi	a5,a5,32
    80005fe8:	c785                	beqz	a5,80006010 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fea:	01f77793          	andi	a5,a4,31
    80005fee:	97d2                	add	a5,a5,s4
    80005ff0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ff4:	0705                	addi	a4,a4,1
    80005ff6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ff8:	8526                	mv	a0,s1
    80005ffa:	ffffb097          	auipc	ra,0xffffb
    80005ffe:	6ec080e7          	jalr	1772(ra) # 800016e6 <wakeup>
    
    WriteReg(THR, c);
    80006002:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006006:	6098                	ld	a4,0(s1)
    80006008:	0009b783          	ld	a5,0(s3)
    8000600c:	fce798e3          	bne	a5,a4,80005fdc <uartstart+0x42>
  }
}
    80006010:	70e2                	ld	ra,56(sp)
    80006012:	7442                	ld	s0,48(sp)
    80006014:	74a2                	ld	s1,40(sp)
    80006016:	7902                	ld	s2,32(sp)
    80006018:	69e2                	ld	s3,24(sp)
    8000601a:	6a42                	ld	s4,16(sp)
    8000601c:	6aa2                	ld	s5,8(sp)
    8000601e:	6121                	addi	sp,sp,64
    80006020:	8082                	ret
    80006022:	8082                	ret

0000000080006024 <uartputc>:
{
    80006024:	7179                	addi	sp,sp,-48
    80006026:	f406                	sd	ra,40(sp)
    80006028:	f022                	sd	s0,32(sp)
    8000602a:	ec26                	sd	s1,24(sp)
    8000602c:	e84a                	sd	s2,16(sp)
    8000602e:	e44e                	sd	s3,8(sp)
    80006030:	e052                	sd	s4,0(sp)
    80006032:	1800                	addi	s0,sp,48
    80006034:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006036:	00020517          	auipc	a0,0x20
    8000603a:	1d250513          	addi	a0,a0,466 # 80026208 <uart_tx_lock>
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	1a4080e7          	jalr	420(ra) # 800061e2 <acquire>
  if(panicked){
    80006046:	00003797          	auipc	a5,0x3
    8000604a:	fd67a783          	lw	a5,-42(a5) # 8000901c <panicked>
    8000604e:	c391                	beqz	a5,80006052 <uartputc+0x2e>
    for(;;)
    80006050:	a001                	j	80006050 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006052:	00003797          	auipc	a5,0x3
    80006056:	fd67b783          	ld	a5,-42(a5) # 80009028 <uart_tx_w>
    8000605a:	00003717          	auipc	a4,0x3
    8000605e:	fc673703          	ld	a4,-58(a4) # 80009020 <uart_tx_r>
    80006062:	02070713          	addi	a4,a4,32
    80006066:	02f71b63          	bne	a4,a5,8000609c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000606a:	00020a17          	auipc	s4,0x20
    8000606e:	19ea0a13          	addi	s4,s4,414 # 80026208 <uart_tx_lock>
    80006072:	00003497          	auipc	s1,0x3
    80006076:	fae48493          	addi	s1,s1,-82 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607a:	00003917          	auipc	s2,0x3
    8000607e:	fae90913          	addi	s2,s2,-82 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006082:	85d2                	mv	a1,s4
    80006084:	8526                	mv	a0,s1
    80006086:	ffffb097          	auipc	ra,0xffffb
    8000608a:	4d4080e7          	jalr	1236(ra) # 8000155a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000608e:	00093783          	ld	a5,0(s2)
    80006092:	6098                	ld	a4,0(s1)
    80006094:	02070713          	addi	a4,a4,32
    80006098:	fef705e3          	beq	a4,a5,80006082 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000609c:	00020497          	auipc	s1,0x20
    800060a0:	16c48493          	addi	s1,s1,364 # 80026208 <uart_tx_lock>
    800060a4:	01f7f713          	andi	a4,a5,31
    800060a8:	9726                	add	a4,a4,s1
    800060aa:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060ae:	0785                	addi	a5,a5,1
    800060b0:	00003717          	auipc	a4,0x3
    800060b4:	f6f73c23          	sd	a5,-136(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	ee2080e7          	jalr	-286(ra) # 80005f9a <uartstart>
      release(&uart_tx_lock);
    800060c0:	8526                	mv	a0,s1
    800060c2:	00000097          	auipc	ra,0x0
    800060c6:	1d4080e7          	jalr	468(ra) # 80006296 <release>
}
    800060ca:	70a2                	ld	ra,40(sp)
    800060cc:	7402                	ld	s0,32(sp)
    800060ce:	64e2                	ld	s1,24(sp)
    800060d0:	6942                	ld	s2,16(sp)
    800060d2:	69a2                	ld	s3,8(sp)
    800060d4:	6a02                	ld	s4,0(sp)
    800060d6:	6145                	addi	sp,sp,48
    800060d8:	8082                	ret

00000000800060da <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060da:	1141                	addi	sp,sp,-16
    800060dc:	e422                	sd	s0,8(sp)
    800060de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e0:	100007b7          	lui	a5,0x10000
    800060e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060e8:	8b85                	andi	a5,a5,1
    800060ea:	cb91                	beqz	a5,800060fe <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060f4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060f8:	6422                	ld	s0,8(sp)
    800060fa:	0141                	addi	sp,sp,16
    800060fc:	8082                	ret
    return -1;
    800060fe:	557d                	li	a0,-1
    80006100:	bfe5                	j	800060f8 <uartgetc+0x1e>

0000000080006102 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006102:	1101                	addi	sp,sp,-32
    80006104:	ec06                	sd	ra,24(sp)
    80006106:	e822                	sd	s0,16(sp)
    80006108:	e426                	sd	s1,8(sp)
    8000610a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000610c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	fcc080e7          	jalr	-52(ra) # 800060da <uartgetc>
    if(c == -1)
    80006116:	00950763          	beq	a0,s1,80006124 <uartintr+0x22>
      break;
    consoleintr(c);
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	8fe080e7          	jalr	-1794(ra) # 80005a18 <consoleintr>
  while(1){
    80006122:	b7f5                	j	8000610e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006124:	00020497          	auipc	s1,0x20
    80006128:	0e448493          	addi	s1,s1,228 # 80026208 <uart_tx_lock>
    8000612c:	8526                	mv	a0,s1
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	0b4080e7          	jalr	180(ra) # 800061e2 <acquire>
  uartstart();
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	e64080e7          	jalr	-412(ra) # 80005f9a <uartstart>
  release(&uart_tx_lock);
    8000613e:	8526                	mv	a0,s1
    80006140:	00000097          	auipc	ra,0x0
    80006144:	156080e7          	jalr	342(ra) # 80006296 <release>
}
    80006148:	60e2                	ld	ra,24(sp)
    8000614a:	6442                	ld	s0,16(sp)
    8000614c:	64a2                	ld	s1,8(sp)
    8000614e:	6105                	addi	sp,sp,32
    80006150:	8082                	ret

0000000080006152 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006152:	1141                	addi	sp,sp,-16
    80006154:	e422                	sd	s0,8(sp)
    80006156:	0800                	addi	s0,sp,16
  lk->name = name;
    80006158:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000615e:	00053823          	sd	zero,16(a0)
}
    80006162:	6422                	ld	s0,8(sp)
    80006164:	0141                	addi	sp,sp,16
    80006166:	8082                	ret

0000000080006168 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006168:	411c                	lw	a5,0(a0)
    8000616a:	e399                	bnez	a5,80006170 <holding+0x8>
    8000616c:	4501                	li	a0,0
  return r;
}
    8000616e:	8082                	ret
{
    80006170:	1101                	addi	sp,sp,-32
    80006172:	ec06                	sd	ra,24(sp)
    80006174:	e822                	sd	s0,16(sp)
    80006176:	e426                	sd	s1,8(sp)
    80006178:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617a:	6904                	ld	s1,16(a0)
    8000617c:	ffffb097          	auipc	ra,0xffffb
    80006180:	cfa080e7          	jalr	-774(ra) # 80000e76 <mycpu>
    80006184:	40a48533          	sub	a0,s1,a0
    80006188:	00153513          	seqz	a0,a0
}
    8000618c:	60e2                	ld	ra,24(sp)
    8000618e:	6442                	ld	s0,16(sp)
    80006190:	64a2                	ld	s1,8(sp)
    80006192:	6105                	addi	sp,sp,32
    80006194:	8082                	ret

0000000080006196 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006196:	1101                	addi	sp,sp,-32
    80006198:	ec06                	sd	ra,24(sp)
    8000619a:	e822                	sd	s0,16(sp)
    8000619c:	e426                	sd	s1,8(sp)
    8000619e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a0:	100024f3          	csrr	s1,sstatus
    800061a4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061a8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061aa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061ae:	ffffb097          	auipc	ra,0xffffb
    800061b2:	cc8080e7          	jalr	-824(ra) # 80000e76 <mycpu>
    800061b6:	5d3c                	lw	a5,120(a0)
    800061b8:	cf89                	beqz	a5,800061d2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ba:	ffffb097          	auipc	ra,0xffffb
    800061be:	cbc080e7          	jalr	-836(ra) # 80000e76 <mycpu>
    800061c2:	5d3c                	lw	a5,120(a0)
    800061c4:	2785                	addiw	a5,a5,1
    800061c6:	dd3c                	sw	a5,120(a0)
}
    800061c8:	60e2                	ld	ra,24(sp)
    800061ca:	6442                	ld	s0,16(sp)
    800061cc:	64a2                	ld	s1,8(sp)
    800061ce:	6105                	addi	sp,sp,32
    800061d0:	8082                	ret
    mycpu()->intena = old;
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	ca4080e7          	jalr	-860(ra) # 80000e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061da:	8085                	srli	s1,s1,0x1
    800061dc:	8885                	andi	s1,s1,1
    800061de:	dd64                	sw	s1,124(a0)
    800061e0:	bfe9                	j	800061ba <push_off+0x24>

00000000800061e2 <acquire>:
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
    800061ec:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	fa8080e7          	jalr	-88(ra) # 80006196 <push_off>
  if(holding(lk))
    800061f6:	8526                	mv	a0,s1
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	f70080e7          	jalr	-144(ra) # 80006168 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006200:	4705                	li	a4,1
  if(holding(lk))
    80006202:	e115                	bnez	a0,80006226 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006204:	87ba                	mv	a5,a4
    80006206:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620a:	2781                	sext.w	a5,a5
    8000620c:	ffe5                	bnez	a5,80006204 <acquire+0x22>
  __sync_synchronize();
    8000620e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	c64080e7          	jalr	-924(ra) # 80000e76 <mycpu>
    8000621a:	e888                	sd	a0,16(s1)
}
    8000621c:	60e2                	ld	ra,24(sp)
    8000621e:	6442                	ld	s0,16(sp)
    80006220:	64a2                	ld	s1,8(sp)
    80006222:	6105                	addi	sp,sp,32
    80006224:	8082                	ret
    panic("acquire");
    80006226:	00002517          	auipc	a0,0x2
    8000622a:	74250513          	addi	a0,a0,1858 # 80008968 <digits+0x20>
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	a6a080e7          	jalr	-1430(ra) # 80005c98 <panic>

0000000080006236 <pop_off>:

void
pop_off(void)
{
    80006236:	1141                	addi	sp,sp,-16
    80006238:	e406                	sd	ra,8(sp)
    8000623a:	e022                	sd	s0,0(sp)
    8000623c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	c38080e7          	jalr	-968(ra) # 80000e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006246:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000624c:	e78d                	bnez	a5,80006276 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000624e:	5d3c                	lw	a5,120(a0)
    80006250:	02f05b63          	blez	a5,80006286 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006254:	37fd                	addiw	a5,a5,-1
    80006256:	0007871b          	sext.w	a4,a5
    8000625a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000625c:	eb09                	bnez	a4,8000626e <pop_off+0x38>
    8000625e:	5d7c                	lw	a5,124(a0)
    80006260:	c799                	beqz	a5,8000626e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006262:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006266:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000626e:	60a2                	ld	ra,8(sp)
    80006270:	6402                	ld	s0,0(sp)
    80006272:	0141                	addi	sp,sp,16
    80006274:	8082                	ret
    panic("pop_off - interruptible");
    80006276:	00002517          	auipc	a0,0x2
    8000627a:	6fa50513          	addi	a0,a0,1786 # 80008970 <digits+0x28>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	a1a080e7          	jalr	-1510(ra) # 80005c98 <panic>
    panic("pop_off");
    80006286:	00002517          	auipc	a0,0x2
    8000628a:	70250513          	addi	a0,a0,1794 # 80008988 <digits+0x40>
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	a0a080e7          	jalr	-1526(ra) # 80005c98 <panic>

0000000080006296 <release>:
{
    80006296:	1101                	addi	sp,sp,-32
    80006298:	ec06                	sd	ra,24(sp)
    8000629a:	e822                	sd	s0,16(sp)
    8000629c:	e426                	sd	s1,8(sp)
    8000629e:	1000                	addi	s0,sp,32
    800062a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	ec6080e7          	jalr	-314(ra) # 80006168 <holding>
    800062aa:	c115                	beqz	a0,800062ce <release+0x38>
  lk->cpu = 0;
    800062ac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b4:	0f50000f          	fence	iorw,ow
    800062b8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	f7a080e7          	jalr	-134(ra) # 80006236 <pop_off>
}
    800062c4:	60e2                	ld	ra,24(sp)
    800062c6:	6442                	ld	s0,16(sp)
    800062c8:	64a2                	ld	s1,8(sp)
    800062ca:	6105                	addi	sp,sp,32
    800062cc:	8082                	ret
    panic("release");
    800062ce:	00002517          	auipc	a0,0x2
    800062d2:	6c250513          	addi	a0,a0,1730 # 80008990 <digits+0x48>
    800062d6:	00000097          	auipc	ra,0x0
    800062da:	9c2080e7          	jalr	-1598(ra) # 80005c98 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
