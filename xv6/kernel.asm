
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c8 10 80       	mov    $0x8010c8d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 c9 10 80       	mov    $0x8010c914,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 40 76 10 80       	push   $0x80107640
80100051:	68 e0 c8 10 80       	push   $0x8010c8e0
80100056:	e8 75 48 00 00       	call   801048d0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 10 11 80 dc 	movl   $0x80110fdc,0x8011102c
80100062:	0f 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 10 11 80 dc 	movl   $0x80110fdc,0x80111030
8010006c:	0f 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0f 11 80       	mov    $0x80110fdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0f 11 80 	movl   $0x80110fdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 76 10 80       	push   $0x80107647
80100097:	50                   	push   %eax
80100098:	e8 23 47 00 00       	call   801047c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 10 11 80       	mov    0x80111030,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 30 10 11 80    	mov    %ebx,0x80111030

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 0f 11 80       	cmp    $0x80110fdc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 e0 c8 10 80       	push   $0x8010c8e0
801000e4:	e8 e7 48 00 00       	call   801049d0 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 10 11 80    	mov    0x80111030,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0f 11 80    	cmp    $0x80110fdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0f 11 80    	cmp    $0x80110fdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 10 11 80    	mov    0x8011102c,%ebx
80100126:	81 fb dc 0f 11 80    	cmp    $0x80110fdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0f 11 80    	cmp    $0x80110fdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c8 10 80       	push   $0x8010c8e0
80100162:	e8 89 49 00 00       	call   80104af0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 46 00 00       	call   80104800 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 76 10 80       	push   $0x8010764e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 46 00 00       	call   801048a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 76 10 80       	push   $0x8010765f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 46 00 00       	call   801048a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 46 00 00       	call   80104860 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 c8 10 80 	movl   $0x8010c8e0,(%esp)
8010020b:	e8 c0 47 00 00       	call   801049d0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 10 11 80       	mov    0x80111030,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 0f 11 80 	movl   $0x80110fdc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 30 10 11 80       	mov    0x80111030,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 10 11 80    	mov    %ebx,0x80111030
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 c8 10 80 	movl   $0x8010c8e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 8f 48 00 00       	jmp    80104af0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 76 10 80       	push   $0x80107666
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 3f 47 00 00       	call   801049d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 c0 12 11 80       	mov    0x801112c0,%eax
801002a6:	3b 05 c4 12 11 80    	cmp    0x801112c4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 c0 12 11 80       	push   $0x801112c0
801002bd:	e8 7e 36 00 00       	call   80103940 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 c0 12 11 80       	mov    0x801112c0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 c4 12 11 80    	cmp    0x801112c4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 f9 34 00 00       	call   801037d0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 05 48 00 00       	call   80104af0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 c0 12 11 80    	mov    %edx,0x801112c0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 40 12 11 80 	movsbl -0x7feeedc0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 a5 47 00 00       	call   80104af0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 c0 12 11 80       	mov    %eax,0x801112c0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 62 23 00 00       	call   801026f0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 6d 76 10 80       	push   $0x8010766d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 8f 7c 10 80 	movl   $0x80107c8f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 33 45 00 00       	call   801048f0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 81 76 10 80       	push   $0x80107681
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 f1 5d 00 00       	call   80106210 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 38 5d 00 00       	call   80106210 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 2c 5d 00 00       	call   80106210 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 20 5d 00 00       	call   80106210 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 d7 46 00 00       	call   80104bf0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 12 46 00 00       	call   80104b40 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 85 76 10 80       	push   $0x80107685
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 b0 76 10 80 	movzbl -0x7fef8950(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 b0 43 00 00       	call   801049d0 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 a4 44 00 00       	call   80104af0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 de 43 00 00       	call   80104af0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 98 76 10 80       	mov    $0x80107698,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 03 42 00 00       	call   801049d0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 9f 76 10 80       	push   $0x8010769f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 c8 41 00 00       	call   801049d0 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80100836:	3b 05 c4 12 11 80    	cmp    0x801112c4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 c8 12 11 80       	mov    %eax,0x801112c8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 83 42 00 00       	call   80104af0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 c0 12 11 80    	sub    0x801112c0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 c8 12 11 80    	mov    %edx,0x801112c8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 40 12 11 80    	mov    %cl,-0x7feeedc0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 c0 12 11 80       	mov    0x801112c0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 c8 12 11 80    	cmp    %eax,0x801112c8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 c4 12 11 80       	mov    %eax,0x801112c4
          wakeup(&input.r);
801008f1:	68 c0 12 11 80       	push   $0x801112c0
801008f6:	e8 85 38 00 00       	call   80104180 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010090d:	39 05 c4 12 11 80    	cmp    %eax,0x801112c4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 c8 12 11 80       	mov    %eax,0x801112c8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80100934:	3b 05 c4 12 11 80    	cmp    0x801112c4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 40 12 11 80 0a 	cmpb   $0xa,-0x7feeedc0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 24 32 00 00       	jmp    80103ba0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 40 12 11 80 0a 	movb   $0xa,-0x7feeedc0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 a8 76 10 80       	push   $0x801076a8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 1b 3f 00 00       	call   801048d0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 8c 1c 11 80 00 	movl   $0x80100600,0x80111c8c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 88 1c 11 80 70 	movl   $0x80100270,0x80111c88
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 c2 18 00 00       	call   801022a0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 cf 2d 00 00       	call   801037d0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 44 21 00 00       	call   80102b50 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 6c 21 00 00       	call   80102bc0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 27 69 00 00       	call   801073a0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 e7 66 00 00       	call   801071f0 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 f1 65 00 00       	call   80107130 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 c2 67 00 00       	call   80107320 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 4c 20 00 00       	call   80102bc0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 56 66 00 00       	call   801071f0 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 6f 67 00 00       	call   80107320 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 fd 1f 00 00       	call   80102bc0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 c1 76 10 80       	push   $0x801076c1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 4a 68 00 00       	call   80107440 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 4e 41 00 00       	call   80104d80 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 3b 41 00 00       	call   80104d80 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 4a 69 00 00       	call   801075a0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 e0 68 00 00       	call   801075a0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 3b 40 00 00       	call   80104d40 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  //curproc->priority = 0.0;      //mine
  //curproc->creation_time = ticks;
  //curproc->running_time = 0;
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 6f 62 00 00       	call   80106fa0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 e7 65 00 00       	call   80107320 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 cd 76 10 80       	push   $0x801076cd
80100d5b:	68 e0 12 11 80       	push   $0x801112e0
80100d60:	e8 6b 3b 00 00       	call   801048d0 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb 14 13 11 80       	mov    $0x80111314,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 e0 12 11 80       	push   $0x801112e0
80100d81:	e8 4a 3c 00 00       	call   801049d0 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 74 1c 11 80    	cmp    $0x80111c74,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 e0 12 11 80       	push   $0x801112e0
80100db1:	e8 3a 3d 00 00       	call   80104af0 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 e0 12 11 80       	push   $0x801112e0
80100dc8:	e8 23 3d 00 00       	call   80104af0 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 e0 12 11 80       	push   $0x801112e0
80100def:	e8 dc 3b 00 00       	call   801049d0 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 e0 12 11 80       	push   $0x801112e0
80100e0c:	e8 df 3c 00 00       	call   80104af0 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 d4 76 10 80       	push   $0x801076d4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 e0 12 11 80       	push   $0x801112e0
80100e41:	e8 8a 3b 00 00       	call   801049d0 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 e0 12 11 80 	movl   $0x801112e0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 7f 3c 00 00       	jmp    80104af0 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 e0 12 11 80       	push   $0x801112e0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 53 3c 00 00       	call   80104af0 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 2a 24 00 00       	call   801032f0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 7b 1c 00 00       	call   80102b50 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 d1 1c 00 00       	jmp    80102bc0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 dc 76 10 80       	push   $0x801076dc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 ce 24 00 00       	jmp    80103490 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 e6 76 10 80       	push   $0x801076e6
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 82 1b 00 00       	call   80102bc0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 e5 1a 00 00       	call   80102b50 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 1e 1b 00 00       	call   80102bc0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 af 22 00 00       	jmp    80103390 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 ef 76 10 80       	push   $0x801076ef
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 f5 76 10 80       	push   $0x801076f5
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d e0 1c 11 80    	mov    0x80111ce0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 f8 1c 11 80    	add    0x80111cf8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 e0 1c 11 80       	mov    0x80111ce0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 e0 1c 11 80    	cmp    %eax,0x80111ce0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 ff 76 10 80       	push   $0x801076ff
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 6e 1b 00 00       	call   80102d30 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 56 39 00 00       	call   80104b40 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 3e 1b 00 00       	call   80102d30 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 34 1d 11 80       	mov    $0x80111d34,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 00 1d 11 80       	push   $0x80111d00
8010122a:	e8 a1 37 00 00       	call   801049d0 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 54 39 11 80    	cmp    $0x80113954,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 00 1d 11 80       	push   $0x80111d00

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 79 38 00 00       	call   80104af0 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 54 39 11 80    	cmp    $0x80113954,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 00 1d 11 80       	push   $0x80111d00
801012bf:	e8 2c 38 00 00       	call   80104af0 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 15 77 10 80       	push   $0x80107715
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 de 19 00 00       	call   80102d30 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 25 77 10 80       	push   $0x80107725
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 1a 38 00 00       	call   80104bf0 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 e0 1c 11 80       	push   $0x80111ce0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 f8 1c 11 80    	add    0x80111cf8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 df 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 38 77 10 80       	push   $0x80107738
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 40 1d 11 80       	mov    $0x80111d40,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 4b 77 10 80       	push   $0x8010774b
80101481:	68 00 1d 11 80       	push   $0x80111d00
80101486:	e8 45 34 00 00       	call   801048d0 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 52 77 10 80       	push   $0x80107752
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 1c 33 00 00       	call   801047c0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 60 39 11 80    	cmp    $0x80113960,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 e0 1c 11 80       	push   $0x80111ce0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 f8 1c 11 80    	pushl  0x80111cf8
801014c5:	ff 35 f4 1c 11 80    	pushl  0x80111cf4
801014cb:	ff 35 f0 1c 11 80    	pushl  0x80111cf0
801014d1:	ff 35 ec 1c 11 80    	pushl  0x80111cec
801014d7:	ff 35 e8 1c 11 80    	pushl  0x80111ce8
801014dd:	ff 35 e4 1c 11 80    	pushl  0x80111ce4
801014e3:	ff 35 e0 1c 11 80    	pushl  0x80111ce0
801014e9:	68 b8 77 10 80       	push   $0x801077b8
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d e8 1c 11 80 01 	cmpl   $0x1,0x80111ce8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d e8 1c 11 80    	cmp    %ebx,0x80111ce8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 f4 1c 11 80    	add    0x80111cf4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 bd 35 00 00       	call   80104b40 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 9b 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 58 77 10 80       	push   $0x80107758
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 f4 1c 11 80    	add    0x80111cf4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 ca 35 00 00       	call   80104bf0 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 02 17 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 00 1d 11 80       	push   $0x80111d00
8010164f:	e8 7c 33 00 00       	call   801049d0 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 00 1d 11 80 	movl   $0x80111d00,(%esp)
8010165f:	e8 8c 34 00 00       	call   80104af0 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 69 31 00 00       	call   80104800 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 f4 1c 11 80    	add    0x80111cf4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 e3 34 00 00       	call   80104bf0 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 70 77 10 80       	push   $0x80107770
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 6a 77 10 80       	push   $0x8010776a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 38 31 00 00       	call   801048a0 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 dc 30 00 00       	jmp    80104860 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 7f 77 10 80       	push   $0x8010777f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 4b 30 00 00       	call   80104800 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 91 30 00 00       	call   80104860 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 00 1d 11 80 	movl   $0x80111d00,(%esp)
801017d6:	e8 f5 31 00 00       	call   801049d0 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 00 1d 11 80 	movl   $0x80111d00,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 fb 32 00 00       	jmp    80104af0 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 00 1d 11 80       	push   $0x80111d00
80101800:	e8 cb 31 00 00       	call   801049d0 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 00 1d 11 80 	movl   $0x80111d00,(%esp)
8010180f:	e8 dc 32 00 00       	call   80104af0 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 f3 31 00 00       	call   80104bf0 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 80 1c 11 80 	mov    -0x7feee380(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 f7 30 00 00       	call   80104bf0 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 2f 12 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 84 1c 11 80 	mov    -0x7feee37c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 dd 30 00 00       	call   80104c70 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 76 30 00 00       	call   80104c70 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 99 77 10 80       	push   $0x80107799
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 87 77 10 80       	push   $0x80107787
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 62 1b 00 00       	call   801037d0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 00 1d 11 80       	push   $0x80111d00
80101c79:	e8 52 2d 00 00       	call   801049d0 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 00 1d 11 80 	movl   $0x80111d00,(%esp)
80101c89:	e8 62 2e 00 00       	call   80104af0 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 06 2f 00 00       	call   80104bf0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 77 2e 00 00       	call   80104bf0 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 7e 2e 00 00       	call   80104ce0 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 a8 77 10 80       	push   $0x801077a8
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 a2 7e 10 80       	push   $0x80107ea2
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	83 e0 01             	and    $0x1,%eax
80101f6c:	c1 e0 04             	shl    $0x4,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 14 78 10 80       	push   $0x80107814
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 0b 78 10 80       	push   $0x8010780b
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fd6:	68 26 78 10 80       	push   $0x80107826
80101fdb:	68 80 b5 10 80       	push   $0x8010b580
80101fe0:	e8 eb 28 00 00       	call   801048d0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 20 40 11 80       	mov    0x80114020,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 b5 10 80       	push   $0x8010b580
8010205e:	e8 6d 29 00 00       	call   801049d0 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 ed 20 00 00       	call   80104180 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 b5 10 80       	push   $0x8010b580
801020ac:	e8 3f 2a 00 00       	call   80104af0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 9d 27 00 00       	call   801048a0 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 b5 10 80       	push   $0x8010b580
80102138:	e8 93 28 00 00       	call   801049d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	53                   	push   %ebx
80102189:	e8 b2 17 00 00       	call   80103940 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010219b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021a6:	e9 45 29 00 00       	jmp    80104af0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 2a 78 10 80       	push   $0x8010782a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 55 78 10 80       	push   $0x80107855
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 40 78 10 80       	push   $0x80107840
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 54 39 11 80 00 	movl   $0xfec00000,0x80113954
801021f8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 54 39 11 80    	mov    0x80113954,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 80 3a 11 80 	movzbl 0x80113a80,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	89 f0                	mov    %esi,%eax
80102227:	c1 e8 10             	shr    $0x10,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102230:	c1 e8 18             	shr    $0x18,%eax
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 74 78 10 80       	push   $0x80107874
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a1:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 54 39 11 80    	mov    0x80113954,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 54 39 11 80       	mov    0x80113954,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb c8 6c 11 80    	cmp    $0x80116cc8,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 29 28 00 00       	call   80104b40 <memset>

  if(kmem.use_lock)
80102317:	8b 15 94 39 11 80    	mov    0x80113994,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 98 39 11 80       	mov    0x80113998,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 94 39 11 80       	mov    0x80113994,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102330:	89 1d 98 39 11 80    	mov    %ebx,0x80113998
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102340:	c7 45 08 60 39 11 80 	movl   $0x80113960,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010234b:	e9 a0 27 00 00       	jmp    80104af0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 60 39 11 80       	push   $0x80113960
80102358:	e8 73 26 00 00       	call   801049d0 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 a6 78 10 80       	push   $0x801078a6
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
    kfree(p);
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 ac 78 10 80       	push   $0x801078ac
801023d0:	68 60 39 11 80       	push   $0x80113960
801023d5:	e8 f6 24 00 00       	call   801048d0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023e0:	c7 05 94 39 11 80 00 	movl   $0x0,0x80113994
801023e7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102474:	c7 05 94 39 11 80 01 	movl   $0x1,0x80113994
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 94 39 11 80       	mov    0x80113994,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 98 39 11 80    	mov    0x80113998,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 98 39 11 80    	mov    %edx,0x80113998
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 60 39 11 80       	push   $0x80113960
801024be:	e8 2d 26 00 00       	call   80104af0 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 60 39 11 80       	push   $0x80113960
801024d8:	e8 f3 24 00 00       	call   801049d0 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d 98 39 11 80    	mov    0x80113998,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 94 39 11 80       	mov    0x80113994,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102500:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	ba 64 00 00 00       	mov    $0x64,%edx
80102506:	89 e5                	mov    %esp,%ebp
80102508:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102509:	a8 01                	test   $0x1,%al
8010250b:	0f 84 af 00 00 00    	je     801025c0 <kbdgetc+0xc0>
80102511:	ba 60 00 00 00       	mov    $0x60,%edx
80102516:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102517:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010251a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102520:	74 7e                	je     801025a0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102522:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010252a:	79 24                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010252c:	f6 c1 40             	test   $0x40,%cl
8010252f:	75 05                	jne    80102536 <kbdgetc+0x36>
80102531:	89 c2                	mov    %eax,%edx
80102533:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102536:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
8010253d:	83 c8 40             	or     $0x40,%eax
80102540:	0f b6 c0             	movzbl %al,%eax
80102543:	f7 d0                	not    %eax
80102545:	21 c8                	and    %ecx,%eax
80102547:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010254c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102550:	f6 c1 40             	test   $0x40,%cl
80102553:	74 09                	je     8010255e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102558:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010255e:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
80102565:	09 c1                	or     %eax,%ecx
80102567:	0f b6 82 e0 78 10 80 	movzbl -0x7fef8720(%edx),%eax
8010256e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102570:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102572:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102578:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010257b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257e:	8b 04 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%eax
80102585:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102589:	74 c3                	je     8010254e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010258b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010258e:	83 fa 19             	cmp    $0x19,%edx
80102591:	77 1d                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102593:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025a0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025b6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c5:	5d                   	pop    %ebp
801025c6:	c3                   	ret    
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <kbdintr>:

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025d6:	68 00 25 10 80       	push   $0x80102500
801025db:	e8 10 e2 ff ff       	call   801007f0 <consoleintr>
}
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025f0:	a1 9c 39 11 80       	mov    0x8011399c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025f5:	55                   	push   %ebp
801025f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025f8:	85 c0                	test   %eax,%eax
801025fa:	0f 84 c8 00 00 00    	je     801026c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102600:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102607:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102617:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102621:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102627:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010262e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102631:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102634:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010263b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102641:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102648:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010264e:	8b 50 30             	mov    0x30(%eax),%edx
80102651:	c1 ea 10             	shr    $0x10,%edx
80102654:	80 fa 03             	cmp    $0x3,%dl
80102657:	77 77                	ja     801026d0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102659:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102663:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102666:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102670:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102673:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102687:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026b6:	80 e6 10             	and    $0x10,%dh
801026b9:	75 f5                	jne    801026b0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026c8:	5d                   	pop    %ebp
801026c9:	c3                   	ret    
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
801026dd:	e9 77 ff ff ff       	jmp    80102659 <lapicinit+0x69>
801026e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026f0:	a1 9c 39 11 80       	mov    0x8011399c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	74 0c                	je     80102708 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ff:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102700:	c1 e8 18             	shr    $0x18,%eax
}
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102708:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010270a:	5d                   	pop    %ebp
8010270b:	c3                   	ret    
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102710:	a1 9c 39 11 80       	mov    0x8011399c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102718:	85 c0                	test   %eax,%eax
8010271a:	74 0d                	je     80102729 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102723:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102726:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
}
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102740:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102741:	ba 70 00 00 00       	mov    $0x70,%edx
80102746:	b8 0f 00 00 00       	mov    $0xf,%eax
8010274b:	89 e5                	mov    %esp,%ebp
8010274d:	53                   	push   %ebx
8010274e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102751:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102754:	ee                   	out    %al,(%dx)
80102755:	ba 71 00 00 00       	mov    $0x71,%edx
8010275a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010275f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102760:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102762:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102765:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010276b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010276d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102770:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102775:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102778:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277e:	a1 9c 39 11 80       	mov    0x8011399c,%eax
80102783:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102789:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102793:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102799:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ac:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ca:	5b                   	pop    %ebx
801027cb:	5d                   	pop    %ebp
801027cc:	c3                   	ret    
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027d0:	55                   	push   %ebp
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	57                   	push   %edi
801027de:	56                   	push   %esi
801027df:	53                   	push   %ebx
801027e0:	83 ec 4c             	sub    $0x4c,%esp
801027e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e4:	ba 71 00 00 00       	mov    $0x71,%edx
801027e9:	ec                   	in     (%dx),%al
801027ea:	83 e0 04             	and    $0x4,%eax
801027ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	31 db                	xor    %ebx,%ebx
801027f2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027f5:	bf 70 00 00 00       	mov    $0x70,%edi
801027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102800:	89 d8                	mov    %ebx,%eax
80102802:	89 fa                	mov    %edi,%edx
80102804:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102805:	b9 71 00 00 00       	mov    $0x71,%ecx
8010280a:	89 ca                	mov    %ecx,%edx
8010280c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010280d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102810:	89 fa                	mov    %edi,%edx
80102812:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102815:	b8 02 00 00 00       	mov    $0x2,%eax
8010281a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281b:	89 ca                	mov    %ecx,%edx
8010281d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010281e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	89 fa                	mov    %edi,%edx
80102823:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102826:	b8 04 00 00 00       	mov    $0x4,%eax
8010282b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282c:	89 ca                	mov    %ecx,%edx
8010282e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010282f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102832:	89 fa                	mov    %edi,%edx
80102834:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102837:	b8 07 00 00 00       	mov    $0x7,%eax
8010283c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	89 ca                	mov    %ecx,%edx
8010283f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102840:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102843:	89 fa                	mov    %edi,%edx
80102845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102848:	b8 08 00 00 00       	mov    $0x8,%eax
8010284d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284e:	89 ca                	mov    %ecx,%edx
80102850:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102851:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102854:	89 fa                	mov    %edi,%edx
80102856:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102859:	b8 09 00 00 00       	mov    $0x9,%eax
8010285e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285f:	89 ca                	mov    %ecx,%edx
80102861:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102862:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102865:	89 fa                	mov    %edi,%edx
80102867:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010286a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102873:	84 c0                	test   %al,%al
80102875:	78 89                	js     80102800 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102877:	89 d8                	mov    %ebx,%eax
80102879:	89 fa                	mov    %edi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010287f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 fa                	mov    %edi,%edx
80102884:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102887:	b8 02 00 00 00       	mov    $0x2,%eax
8010288c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288d:	89 ca                	mov    %ecx,%edx
8010288f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102890:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102893:	89 fa                	mov    %edi,%edx
80102895:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028a1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 fa                	mov    %edi,%edx
801028a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028a9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028af:	89 ca                	mov    %ecx,%edx
801028b1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028b2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b5:	89 fa                	mov    %edi,%edx
801028b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ba:	b8 08 00 00 00       	mov    $0x8,%eax
801028bf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028c3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 fa                	mov    %edi,%edx
801028c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028cb:	b8 09 00 00 00       	mov    $0x9,%eax
801028d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d1:	89 ca                	mov    %ecx,%edx
801028d3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028d4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028d7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028e0:	6a 18                	push   $0x18
801028e2:	56                   	push   %esi
801028e3:	50                   	push   %eax
801028e4:	e8 a7 22 00 00       	call   80104b90 <memcmp>
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	85 c0                	test   %eax,%eax
801028ee:	0f 85 0c ff ff ff    	jne    80102800 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028f4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f8:	75 78                	jne    80102972 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fd:	89 c2                	mov    %eax,%edx
801028ff:	83 e0 0f             	and    $0xf,%eax
80102902:	c1 ea 04             	shr    $0x4,%edx
80102905:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102908:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102911:	89 c2                	mov    %eax,%edx
80102913:	83 e0 0f             	and    $0xf,%eax
80102916:	c1 ea 04             	shr    $0x4,%edx
80102919:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102922:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102925:	89 c2                	mov    %eax,%edx
80102927:	83 e0 0f             	and    $0xf,%eax
8010292a:	c1 ea 04             	shr    $0x4,%edx
8010292d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102930:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102933:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102939:	89 c2                	mov    %eax,%edx
8010293b:	83 e0 0f             	and    $0xf,%eax
8010293e:	c1 ea 04             	shr    $0x4,%edx
80102941:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102944:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102947:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294d:	89 c2                	mov    %eax,%edx
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	c1 ea 04             	shr    $0x4,%edx
80102955:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102958:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102961:	89 c2                	mov    %eax,%edx
80102963:	83 e0 0f             	and    $0xf,%eax
80102966:	c1 ea 04             	shr    $0x4,%edx
80102969:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102972:	8b 75 08             	mov    0x8(%ebp),%esi
80102975:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102978:	89 06                	mov    %eax,(%esi)
8010297a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297d:	89 46 04             	mov    %eax,0x4(%esi)
80102980:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102983:	89 46 08             	mov    %eax,0x8(%esi)
80102986:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102989:	89 46 0c             	mov    %eax,0xc(%esi)
8010298c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010298f:	89 46 10             	mov    %eax,0x10(%esi)
80102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102995:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102998:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010299f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a2:	5b                   	pop    %ebx
801029a3:	5e                   	pop    %esi
801029a4:	5f                   	pop    %edi
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b0:	8b 0d e8 39 11 80    	mov    0x801139e8,%ecx
801029b6:	85 c9                	test   %ecx,%ecx
801029b8:	0f 8e 85 00 00 00    	jle    80102a43 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	31 db                	xor    %ebx,%ebx
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029d0:	a1 d4 39 11 80       	mov    0x801139d4,%eax
801029d5:	83 ec 08             	sub    $0x8,%esp
801029d8:	01 d8                	add    %ebx,%eax
801029da:	83 c0 01             	add    $0x1,%eax
801029dd:	50                   	push   %eax
801029de:	ff 35 e4 39 11 80    	pushl  0x801139e4
801029e4:	e8 e7 d6 ff ff       	call   801000d0 <bread>
801029e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029eb:	58                   	pop    %eax
801029ec:	5a                   	pop    %edx
801029ed:	ff 34 9d ec 39 11 80 	pushl  -0x7feec614(,%ebx,4)
801029f4:	ff 35 e4 39 11 80    	pushl  0x801139e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fd:	e8 ce d6 ff ff       	call   801000d0 <bread>
80102a02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a07:	83 c4 0c             	add    $0xc,%esp
80102a0a:	68 00 02 00 00       	push   $0x200
80102a0f:	50                   	push   %eax
80102a10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a13:	50                   	push   %eax
80102a14:	e8 d7 21 00 00       	call   80104bf0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 7f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a21:	89 3c 24             	mov    %edi,(%esp)
80102a24:	e8 b7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a29:	89 34 24             	mov    %esi,(%esp)
80102a2c:	e8 af d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	39 1d e8 39 11 80    	cmp    %ebx,0x801139e8
80102a3a:	7f 94                	jg     801029d0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	f3 c3                	repz ret 
80102a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	53                   	push   %ebx
80102a54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a57:	ff 35 d4 39 11 80    	pushl  0x801139d4
80102a5d:	ff 35 e4 39 11 80    	pushl  0x801139e4
80102a63:	e8 68 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a68:	8b 0d e8 39 11 80    	mov    0x801139e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a6e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a71:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a73:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a75:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a78:	7e 1f                	jle    80102a99 <write_head+0x49>
80102a7a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a81:	31 d2                	xor    %edx,%edx
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 8a ec 39 11 80    	mov    -0x7feec614(%edx),%ecx
80102a8e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a92:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a95:	39 c2                	cmp    %eax,%edx
80102a97:	75 ef                	jne    80102a88 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a99:	83 ec 0c             	sub    $0xc,%esp
80102a9c:	53                   	push   %ebx
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 1c 24             	mov    %ebx,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    
80102aaf:	90                   	nop

80102ab0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 2c             	sub    $0x2c,%esp
80102ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aba:	68 e0 7a 10 80       	push   $0x80107ae0
80102abf:	68 a0 39 11 80       	push   $0x801139a0
80102ac4:	e8 07 1e 00 00       	call   801048d0 <initlock>
  readsb(dev, &sb);
80102ac9:	58                   	pop    %eax
80102aca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102acd:	5a                   	pop    %edx
80102ace:	50                   	push   %eax
80102acf:	53                   	push   %ebx
80102ad0:	e8 db e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102adb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102adc:	89 1d e4 39 11 80    	mov    %ebx,0x801139e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae2:	89 15 d8 39 11 80    	mov    %edx,0x801139d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae8:	a3 d4 39 11 80       	mov    %eax,0x801139d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 db d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102af5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102af8:	83 c4 10             	add    $0x10,%esp
80102afb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102afd:	89 0d e8 39 11 80    	mov    %ecx,0x801139e8
  for (i = 0; i < log.lh.n; i++) {
80102b03:	7e 1c                	jle    80102b21 <initlog+0x71>
80102b05:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b0c:	31 d2                	xor    %edx,%edx
80102b0e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b14:	83 c2 04             	add    $0x4,%edx
80102b17:	89 8a e8 39 11 80    	mov    %ecx,-0x7feec618(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	50                   	push   %eax
80102b25:	e8 b6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b2a:	e8 81 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b2f:	c7 05 e8 39 11 80 00 	movl   $0x0,0x801139e8
80102b36:	00 00 00 
  write_head(); // clear the log
80102b39:	e8 12 ff ff ff       	call   80102a50 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b41:	c9                   	leave  
80102b42:	c3                   	ret    
80102b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b56:	68 a0 39 11 80       	push   $0x801139a0
80102b5b:	e8 70 1e 00 00       	call   801049d0 <acquire>
80102b60:	83 c4 10             	add    $0x10,%esp
80102b63:	eb 18                	jmp    80102b7d <begin_op+0x2d>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	83 ec 08             	sub    $0x8,%esp
80102b6b:	68 a0 39 11 80       	push   $0x801139a0
80102b70:	68 a0 39 11 80       	push   $0x801139a0
80102b75:	e8 c6 0d 00 00       	call   80103940 <sleep>
80102b7a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b7d:	a1 e0 39 11 80       	mov    0x801139e0,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	75 e2                	jne    80102b68 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b86:	a1 dc 39 11 80       	mov    0x801139dc,%eax
80102b8b:	8b 15 e8 39 11 80    	mov    0x801139e8,%edx
80102b91:	83 c0 01             	add    $0x1,%eax
80102b94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b9a:	83 fa 1e             	cmp    $0x1e,%edx
80102b9d:	7f c9                	jg     80102b68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ba2:	a3 dc 39 11 80       	mov    %eax,0x801139dc
      release(&log.lock);
80102ba7:	68 a0 39 11 80       	push   $0x801139a0
80102bac:	e8 3f 1f 00 00       	call   80104af0 <release>
      break;
    }
  }
}
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	57                   	push   %edi
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bc9:	68 a0 39 11 80       	push   $0x801139a0
80102bce:	e8 fd 1d 00 00       	call   801049d0 <acquire>
  log.outstanding -= 1;
80102bd3:	a1 dc 39 11 80       	mov    0x801139dc,%eax
  if(log.committing)
80102bd8:	8b 1d e0 39 11 80    	mov    0x801139e0,%ebx
80102bde:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102be4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be6:	a3 dc 39 11 80       	mov    %eax,0x801139dc
  if(log.committing)
80102beb:	0f 85 23 01 00 00    	jne    80102d14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	0f 85 f7 00 00 00    	jne    80102cf0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bfc:	c7 05 e0 39 11 80 01 	movl   $0x1,0x801139e0
80102c03:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c06:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	68 a0 39 11 80       	push   $0x801139a0
80102c0d:	e8 de 1e 00 00       	call   80104af0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c12:	8b 0d e8 39 11 80    	mov    0x801139e8,%ecx
80102c18:	83 c4 10             	add    $0x10,%esp
80102c1b:	85 c9                	test   %ecx,%ecx
80102c1d:	0f 8e 8a 00 00 00    	jle    80102cad <end_op+0xed>
80102c23:	90                   	nop
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c28:	a1 d4 39 11 80       	mov    0x801139d4,%eax
80102c2d:	83 ec 08             	sub    $0x8,%esp
80102c30:	01 d8                	add    %ebx,%eax
80102c32:	83 c0 01             	add    $0x1,%eax
80102c35:	50                   	push   %eax
80102c36:	ff 35 e4 39 11 80    	pushl  0x801139e4
80102c3c:	e8 8f d4 ff ff       	call   801000d0 <bread>
80102c41:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c43:	58                   	pop    %eax
80102c44:	5a                   	pop    %edx
80102c45:	ff 34 9d ec 39 11 80 	pushl  -0x7feec614(,%ebx,4)
80102c4c:	ff 35 e4 39 11 80    	pushl  0x801139e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c52:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c55:	e8 76 d4 ff ff       	call   801000d0 <bread>
80102c5a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c5c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c5f:	83 c4 0c             	add    $0xc,%esp
80102c62:	68 00 02 00 00       	push   $0x200
80102c67:	50                   	push   %eax
80102c68:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6b:	50                   	push   %eax
80102c6c:	e8 7f 1f 00 00       	call   80104bf0 <memmove>
    bwrite(to);  // write the log
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 27 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c79:	89 3c 24             	mov    %edi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 57 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c89:	83 c4 10             	add    $0x10,%esp
80102c8c:	3b 1d e8 39 11 80    	cmp    0x801139e8,%ebx
80102c92:	7c 94                	jl     80102c28 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c94:	e8 b7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102c99:	e8 12 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102c9e:	c7 05 e8 39 11 80 00 	movl   $0x0,0x801139e8
80102ca5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ca8:	e8 a3 fd ff ff       	call   80102a50 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cad:	83 ec 0c             	sub    $0xc,%esp
80102cb0:	68 a0 39 11 80       	push   $0x801139a0
80102cb5:	e8 16 1d 00 00       	call   801049d0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cba:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cc1:	c7 05 e0 39 11 80 00 	movl   $0x0,0x801139e0
80102cc8:	00 00 00 
    wakeup(&log);
80102ccb:	e8 b0 14 00 00       	call   80104180 <wakeup>
    release(&log.lock);
80102cd0:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80102cd7:	e8 14 1e 00 00       	call   80104af0 <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
  }
}
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	89 f6                	mov    %esi,%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	68 a0 39 11 80       	push   $0x801139a0
80102cf8:	e8 83 14 00 00       	call   80104180 <wakeup>
  }
  release(&log.lock);
80102cfd:	c7 04 24 a0 39 11 80 	movl   $0x801139a0,(%esp)
80102d04:	e8 e7 1d 00 00       	call   80104af0 <release>
80102d09:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d14:	83 ec 0c             	sub    $0xc,%esp
80102d17:	68 e4 7a 10 80       	push   $0x80107ae4
80102d1c:	e8 4f d6 ff ff       	call   80100370 <panic>
80102d21:	eb 0d                	jmp    80102d30 <log_write>
80102d23:	90                   	nop
80102d24:	90                   	nop
80102d25:	90                   	nop
80102d26:	90                   	nop
80102d27:	90                   	nop
80102d28:	90                   	nop
80102d29:	90                   	nop
80102d2a:	90                   	nop
80102d2b:	90                   	nop
80102d2c:	90                   	nop
80102d2d:	90                   	nop
80102d2e:	90                   	nop
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	8b 15 e8 39 11 80    	mov    0x801139e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d40:	83 fa 1d             	cmp    $0x1d,%edx
80102d43:	0f 8f 97 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d49:	a1 d8 39 11 80       	mov    0x801139d8,%eax
80102d4e:	83 e8 01             	sub    $0x1,%eax
80102d51:	39 c2                	cmp    %eax,%edx
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 dc 39 11 80       	mov    0x801139dc,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 87 00 00 00    	jle    80102ded <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 a0 39 11 80       	push   $0x801139a0
80102d6e:	e8 5d 1c 00 00       	call   801049d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d73:	8b 15 e8 39 11 80    	mov    0x801139e8,%edx
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	83 fa 00             	cmp    $0x0,%edx
80102d7f:	7e 50                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d81:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d84:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d86:	3b 0d ec 39 11 80    	cmp    0x801139ec,%ecx
80102d8c:	75 0b                	jne    80102d99 <log_write+0x69>
80102d8e:	eb 38                	jmp    80102dc8 <log_write+0x98>
80102d90:	39 0c 85 ec 39 11 80 	cmp    %ecx,-0x7feec614(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 ec 39 11 80 	mov    %ecx,-0x7feec614(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 e8 39 11 80    	mov    %edx,0x801139e8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 a0 39 11 80 	movl   $0x801139a0,0x8(%ebp)
}
80102dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dbd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbe:	e9 2d 1d 00 00       	jmp    80104af0 <release>
80102dc3:	90                   	nop
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 ec 39 11 80 	mov    %ecx,-0x7feec614(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 ec 39 11 80       	mov    %eax,0x801139ec
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	83 ec 0c             	sub    $0xc,%esp
80102de3:	68 f3 7a 10 80       	push   $0x80107af3
80102de8:	e8 83 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	68 09 7b 10 80       	push   $0x80107b09
80102df5:	e8 76 d5 ff ff       	call   80100370 <panic>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 a4 09 00 00       	call   801037b0 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 9d 09 00 00       	call   801037b0 <cpuid>
80102e13:	83 ec 04             	sub    $0x4,%esp
80102e16:	53                   	push   %ebx
80102e17:	50                   	push   %eax
80102e18:	68 24 7b 10 80       	push   $0x80107b24
80102e1d:	e8 3e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e22:	e8 e9 2f 00 00       	call   80105e10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e27:	e8 04 09 00 00       	call   80103730 <mycpu>
80102e2c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e2e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e33:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3a:	e8 f1 14 00 00       	call   80104330 <scheduler>
80102e3f:	90                   	nop

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 35 41 00 00       	call   80106f80 <switchkvm>
  seginit();
80102e4b:	e8 30 40 00 00       	call   80106e80 <seginit>
  lapicinit();
80102e50:	e8 9b f7 ff ff       	call   801025f0 <lapicinit>
  mpmain();
80102e55:	e8 a6 ff ff ff       	call   80102e00 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e64:	83 e4 f0             	and    $0xfffffff0,%esp
80102e67:	ff 71 fc             	pushl  -0x4(%ecx)
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	53                   	push   %ebx
80102e6e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e6f:	bb a0 3a 11 80       	mov    $0x80113aa0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e74:	83 ec 08             	sub    $0x8,%esp
80102e77:	68 00 00 40 80       	push   $0x80400000
80102e7c:	68 c8 6c 11 80       	push   $0x80116cc8
80102e81:	e8 3a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102e86:	e8 95 45 00 00       	call   80107420 <kvmalloc>
  mpinit();        // detect other processors
80102e8b:	e8 70 01 00 00       	call   80103000 <mpinit>
  lapicinit();     // interrupt controller
80102e90:	e8 5b f7 ff ff       	call   801025f0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 e6 3f 00 00       	call   80106e80 <seginit>
  picinit();       // disable pic
80102e9a:	e8 31 03 00 00       	call   801031d0 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 f7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 a2 32 00 00       	call   80106150 <uartinit>
  pinit();         // process table
80102eae:	e8 3d 08 00 00       	call   801036f0 <pinit>
  tvinit();        // trap vectors
80102eb3:	e8 b8 2e 00 00       	call   80105d70 <tvinit>
  binit();         // buffer cache
80102eb8:	e8 83 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ebd:	e8 8e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ec2:	e8 09 f1 ff ff       	call   80101fd0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ec7:	83 c4 0c             	add    $0xc,%esp
80102eca:	68 8a 00 00 00       	push   $0x8a
80102ecf:	68 8c b4 10 80       	push   $0x8010b48c
80102ed4:	68 00 70 00 80       	push   $0x80007000
80102ed9:	e8 12 1d 00 00       	call   80104bf0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ede:	69 05 20 40 11 80 b0 	imul   $0xb0,0x80114020,%eax
80102ee5:	00 00 00 
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	05 a0 3a 11 80       	add    $0x80113aa0,%eax
80102ef0:	39 d8                	cmp    %ebx,%eax
80102ef2:	76 6f                	jbe    80102f63 <main+0x103>
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ef8:	e8 33 08 00 00       	call   80103730 <mycpu>
80102efd:	39 d8                	cmp    %ebx,%eax
80102eff:	74 49                	je     80102f4a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f01:	e8 8a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f06:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f0b:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f12:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f15:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f1c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f1f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f24:	0f b6 03             	movzbl (%ebx),%eax
80102f27:	83 ec 08             	sub    $0x8,%esp
80102f2a:	68 00 70 00 00       	push   $0x7000
80102f2f:	50                   	push   %eax
80102f30:	e8 0b f8 ff ff       	call   80102740 <lapicstartap>
80102f35:	83 c4 10             	add    $0x10,%esp
80102f38:	90                   	nop
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f40:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	74 f6                	je     80102f40 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f4a:	69 05 20 40 11 80 b0 	imul   $0xb0,0x80114020,%eax
80102f51:	00 00 00 
80102f54:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f5a:	05 a0 3a 11 80       	add    $0x80113aa0,%eax
80102f5f:	39 c3                	cmp    %eax,%ebx
80102f61:	72 95                	jb     80102ef8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f63:	83 ec 08             	sub    $0x8,%esp
80102f66:	68 00 00 00 8e       	push   $0x8e000000
80102f6b:	68 00 00 40 80       	push   $0x80400000
80102f70:	e8 bb f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f75:	e8 e6 0d 00 00       	call   80103d60 <userinit>
  mpmain();        // finish this processor's setup
80102f7a:	e8 81 fe ff ff       	call   80102e00 <mpmain>
80102f7f:	90                   	nop

80102f80 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f85:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f8c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f92:	39 de                	cmp    %ebx,%esi
80102f94:	73 48                	jae    80102fde <mpsearch1+0x5e>
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa0:	83 ec 04             	sub    $0x4,%esp
80102fa3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fa6:	6a 04                	push   $0x4
80102fa8:	68 38 7b 10 80       	push   $0x80107b38
80102fad:	56                   	push   %esi
80102fae:	e8 dd 1b 00 00       	call   80104b90 <memcmp>
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	75 1e                	jne    80102fd8 <mpsearch1+0x58>
80102fba:	8d 7e 10             	lea    0x10(%esi),%edi
80102fbd:	89 f2                	mov    %esi,%edx
80102fbf:	31 c9                	xor    %ecx,%ecx
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fc8:	0f b6 02             	movzbl (%edx),%eax
80102fcb:	83 c2 01             	add    $0x1,%edx
80102fce:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd0:	39 fa                	cmp    %edi,%edx
80102fd2:	75 f4                	jne    80102fc8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fd4:	84 c9                	test   %cl,%cl
80102fd6:	74 10                	je     80102fe8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd8:	39 fb                	cmp    %edi,%ebx
80102fda:	89 fe                	mov    %edi,%esi
80102fdc:	77 c2                	ja     80102fa0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fe1:	31 c0                	xor    %eax,%eax
}
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret    
80102fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102feb:	89 f0                	mov    %esi,%eax
80102fed:	5b                   	pop    %ebx
80102fee:	5e                   	pop    %esi
80102fef:	5f                   	pop    %edi
80102ff0:	5d                   	pop    %ebp
80102ff1:	c3                   	ret    
80102ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103009:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103010:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103017:	c1 e0 08             	shl    $0x8,%eax
8010301a:	09 d0                	or     %edx,%eax
8010301c:	c1 e0 04             	shl    $0x4,%eax
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 1b                	jne    8010303e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103023:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010302a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103031:	c1 e0 08             	shl    $0x8,%eax
80103034:	09 d0                	or     %edx,%eax
80103036:	c1 e0 0a             	shl    $0xa,%eax
80103039:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010303e:	ba 00 04 00 00       	mov    $0x400,%edx
80103043:	e8 38 ff ff ff       	call   80102f80 <mpsearch1>
80103048:	85 c0                	test   %eax,%eax
8010304a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010304d:	0f 84 37 01 00 00    	je     8010318a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103056:	8b 58 04             	mov    0x4(%eax),%ebx
80103059:	85 db                	test   %ebx,%ebx
8010305b:	0f 84 43 01 00 00    	je     801031a4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103061:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103067:	83 ec 04             	sub    $0x4,%esp
8010306a:	6a 04                	push   $0x4
8010306c:	68 3d 7b 10 80       	push   $0x80107b3d
80103071:	56                   	push   %esi
80103072:	e8 19 1b 00 00       	call   80104b90 <memcmp>
80103077:	83 c4 10             	add    $0x10,%esp
8010307a:	85 c0                	test   %eax,%eax
8010307c:	0f 85 22 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103082:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103089:	3c 01                	cmp    $0x1,%al
8010308b:	74 08                	je     80103095 <mpinit+0x95>
8010308d:	3c 04                	cmp    $0x4,%al
8010308f:	0f 85 0f 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103095:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010309c:	85 ff                	test   %edi,%edi
8010309e:	74 21                	je     801030c1 <mpinit+0xc1>
801030a0:	31 d2                	xor    %edx,%edx
801030a2:	31 c0                	xor    %eax,%eax
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030a8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030af:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030b3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b5:	39 c7                	cmp    %eax,%edi
801030b7:	75 ef                	jne    801030a8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b9:	84 d2                	test   %dl,%dl
801030bb:	0f 85 e3 00 00 00    	jne    801031a4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030c1:	85 f6                	test   %esi,%esi
801030c3:	0f 84 db 00 00 00    	je     801031a4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030c9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030cf:	a3 9c 39 11 80       	mov    %eax,0x8011399c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030db:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030e1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e6:	01 d6                	add    %edx,%esi
801030e8:	90                   	nop
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f0:	39 c6                	cmp    %eax,%esi
801030f2:	76 23                	jbe    80103117 <mpinit+0x117>
801030f4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030f7:	80 fa 04             	cmp    $0x4,%dl
801030fa:	0f 87 c0 00 00 00    	ja     801031c0 <mpinit+0x1c0>
80103100:	ff 24 95 7c 7b 10 80 	jmp    *-0x7fef8484(,%edx,4)
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103110:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103113:	39 c6                	cmp    %eax,%esi
80103115:	77 dd                	ja     801030f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103117:	85 db                	test   %ebx,%ebx
80103119:	0f 84 92 00 00 00    	je     801031b1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103122:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103126:	74 15                	je     8010313d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103128:	ba 22 00 00 00       	mov    $0x22,%edx
8010312d:	b8 70 00 00 00       	mov    $0x70,%eax
80103132:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103133:	ba 23 00 00 00       	mov    $0x23,%edx
80103138:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103139:	83 c8 01             	or     $0x1,%eax
8010313c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010313d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103140:	5b                   	pop    %ebx
80103141:	5e                   	pop    %esi
80103142:	5f                   	pop    %edi
80103143:	5d                   	pop    %ebp
80103144:	c3                   	ret    
80103145:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103148:	8b 0d 20 40 11 80    	mov    0x80114020,%ecx
8010314e:	83 f9 07             	cmp    $0x7,%ecx
80103151:	7f 19                	jg     8010316c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103153:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103157:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010315d:	83 c1 01             	add    $0x1,%ecx
80103160:	89 0d 20 40 11 80    	mov    %ecx,0x80114020
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103166:	88 97 a0 3a 11 80    	mov    %dl,-0x7feec560(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010316c:	83 c0 14             	add    $0x14,%eax
      continue;
8010316f:	e9 7c ff ff ff       	jmp    801030f0 <mpinit+0xf0>
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010317c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010317f:	88 15 80 3a 11 80    	mov    %dl,0x80113a80
      p += sizeof(struct mpioapic);
      continue;
80103185:	e9 66 ff ff ff       	jmp    801030f0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010318f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103194:	e8 e7 fd ff ff       	call   80102f80 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103199:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010319e:	0f 85 af fe ff ff    	jne    80103053 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031a4:	83 ec 0c             	sub    $0xc,%esp
801031a7:	68 42 7b 10 80       	push   $0x80107b42
801031ac:	e8 bf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031b1:	83 ec 0c             	sub    $0xc,%esp
801031b4:	68 5c 7b 10 80       	push   $0x80107b5c
801031b9:	e8 b2 d1 ff ff       	call   80100370 <panic>
801031be:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031c0:	31 db                	xor    %ebx,%ebx
801031c2:	e9 30 ff ff ff       	jmp    801030f7 <mpinit+0xf7>
801031c7:	66 90                	xchg   %ax,%ax
801031c9:	66 90                	xchg   %ax,%ax
801031cb:	66 90                	xchg   %ax,%ax
801031cd:	66 90                	xchg   %ax,%ax
801031cf:	90                   	nop

801031d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	ba 21 00 00 00       	mov    $0x21,%edx
801031d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	ee                   	out    %al,(%dx)
801031de:	ba a1 00 00 00       	mov    $0xa1,%edx
801031e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031e4:	5d                   	pop    %ebp
801031e5:	c3                   	ret    
801031e6:	66 90                	xchg   %ax,%ax
801031e8:	66 90                	xchg   %ax,%ax
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	8b 75 08             	mov    0x8(%ebp),%esi
801031fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103205:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010320b:	e8 60 db ff ff       	call   80100d70 <filealloc>
80103210:	85 c0                	test   %eax,%eax
80103212:	89 06                	mov    %eax,(%esi)
80103214:	0f 84 a8 00 00 00    	je     801032c2 <pipealloc+0xd2>
8010321a:	e8 51 db ff ff       	call   80100d70 <filealloc>
8010321f:	85 c0                	test   %eax,%eax
80103221:	89 03                	mov    %eax,(%ebx)
80103223:	0f 84 87 00 00 00    	je     801032b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103229:	e8 62 f2 ff ff       	call   80102490 <kalloc>
8010322e:	85 c0                	test   %eax,%eax
80103230:	89 c7                	mov    %eax,%edi
80103232:	0f 84 b0 00 00 00    	je     801032e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103238:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010323b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103242:	00 00 00 
  p->writeopen = 1;
80103245:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010324c:	00 00 00 
  p->nwrite = 0;
8010324f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103256:	00 00 00 
  p->nread = 0;
80103259:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103260:	00 00 00 
  initlock(&p->lock, "pipe");
80103263:	68 90 7b 10 80       	push   $0x80107b90
80103268:	50                   	push   %eax
80103269:	e8 62 16 00 00       	call   801048d0 <initlock>
  (*f0)->type = FD_PIPE;
8010326e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103270:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103273:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103279:	8b 06                	mov    (%esi),%eax
8010327b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010327f:	8b 06                	mov    (%esi),%eax
80103281:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103285:	8b 06                	mov    (%esi),%eax
80103287:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010328a:	8b 03                	mov    (%ebx),%eax
8010328c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103292:	8b 03                	mov    (%ebx),%eax
80103294:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103298:	8b 03                	mov    (%ebx),%eax
8010329a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010329e:	8b 03                	mov    (%ebx),%eax
801032a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032a6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a8:	5b                   	pop    %ebx
801032a9:	5e                   	pop    %esi
801032aa:	5f                   	pop    %edi
801032ab:	5d                   	pop    %ebp
801032ac:	c3                   	ret    
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b0:	8b 06                	mov    (%esi),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 1e                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 71 db ff ff       	call   80100e30 <fileclose>
801032bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c2:	8b 03                	mov    (%ebx),%eax
801032c4:	85 c0                	test   %eax,%eax
801032c6:	74 0c                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f1);
801032c8:	83 ec 0c             	sub    $0xc,%esp
801032cb:	50                   	push   %eax
801032cc:	e8 5f db ff ff       	call   80100e30 <fileclose>
801032d1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5f                   	pop    %edi
801032df:	5d                   	pop    %ebp
801032e0:	c3                   	ret    
801032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032e8:	8b 06                	mov    (%esi),%eax
801032ea:	85 c0                	test   %eax,%eax
801032ec:	75 c8                	jne    801032b6 <pipealloc+0xc6>
801032ee:	eb d2                	jmp    801032c2 <pipealloc+0xd2>

801032f0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	56                   	push   %esi
801032f4:	53                   	push   %ebx
801032f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032fb:	83 ec 0c             	sub    $0xc,%esp
801032fe:	53                   	push   %ebx
801032ff:	e8 cc 16 00 00       	call   801049d0 <acquire>
  if(writable){
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 f6                	test   %esi,%esi
80103309:	74 45                	je     80103350 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010330b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103311:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103314:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010331b:	00 00 00 
    wakeup(&p->nread);
8010331e:	50                   	push   %eax
8010331f:	e8 5c 0e 00 00       	call   80104180 <wakeup>
80103324:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103327:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010332d:	85 d2                	test   %edx,%edx
8010332f:	75 0a                	jne    8010333b <pipeclose+0x4b>
80103331:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103337:	85 c0                	test   %eax,%eax
80103339:	74 35                	je     80103370 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010333b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010333e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103341:	5b                   	pop    %ebx
80103342:	5e                   	pop    %esi
80103343:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103344:	e9 a7 17 00 00       	jmp    80104af0 <release>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103350:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103356:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103359:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103360:	00 00 00 
    wakeup(&p->nwrite);
80103363:	50                   	push   %eax
80103364:	e8 17 0e 00 00       	call   80104180 <wakeup>
80103369:	83 c4 10             	add    $0x10,%esp
8010336c:	eb b9                	jmp    80103327 <pipeclose+0x37>
8010336e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	53                   	push   %ebx
80103374:	e8 77 17 00 00       	call   80104af0 <release>
    kfree((char*)p);
80103379:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010337c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010337f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103385:	e9 56 ef ff ff       	jmp    801022e0 <kfree>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103390 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 28             	sub    $0x28,%esp
80103399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010339c:	53                   	push   %ebx
8010339d:	e8 2e 16 00 00       	call   801049d0 <acquire>
  for(i = 0; i < n; i++){
801033a2:	8b 45 10             	mov    0x10(%ebp),%eax
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	85 c0                	test   %eax,%eax
801033aa:	0f 8e b9 00 00 00    	jle    80103469 <pipewrite+0xd9>
801033b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033bf:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033c8:	03 4d 10             	add    0x10(%ebp),%ecx
801033cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ce:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033d4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033da:	39 d0                	cmp    %edx,%eax
801033dc:	74 38                	je     80103416 <pipewrite+0x86>
801033de:	eb 59                	jmp    80103439 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033e0:	e8 eb 03 00 00       	call   801037d0 <myproc>
801033e5:	8b 48 24             	mov    0x24(%eax),%ecx
801033e8:	85 c9                	test   %ecx,%ecx
801033ea:	75 34                	jne    80103420 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ec:	83 ec 0c             	sub    $0xc,%esp
801033ef:	57                   	push   %edi
801033f0:	e8 8b 0d 00 00       	call   80104180 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f5:	58                   	pop    %eax
801033f6:	5a                   	pop    %edx
801033f7:	53                   	push   %ebx
801033f8:	56                   	push   %esi
801033f9:	e8 42 05 00 00       	call   80103940 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033fe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103404:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010340a:	83 c4 10             	add    $0x10,%esp
8010340d:	05 00 02 00 00       	add    $0x200,%eax
80103412:	39 c2                	cmp    %eax,%edx
80103414:	75 2a                	jne    80103440 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103416:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010341c:	85 c0                	test   %eax,%eax
8010341e:	75 c0                	jne    801033e0 <pipewrite+0x50>
        release(&p->lock);
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	53                   	push   %ebx
80103424:	e8 c7 16 00 00       	call   80104af0 <release>
        return -1;
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103434:	5b                   	pop    %ebx
80103435:	5e                   	pop    %esi
80103436:	5f                   	pop    %edi
80103437:	5d                   	pop    %ebp
80103438:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103439:	89 c2                	mov    %eax,%edx
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103440:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103443:	8d 42 01             	lea    0x1(%edx),%eax
80103446:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010344a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103450:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103456:	0f b6 09             	movzbl (%ecx),%ecx
80103459:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010345d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103460:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103463:	0f 85 65 ff ff ff    	jne    801033ce <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103469:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010346f:	83 ec 0c             	sub    $0xc,%esp
80103472:	50                   	push   %eax
80103473:	e8 08 0d 00 00       	call   80104180 <wakeup>
  release(&p->lock);
80103478:	89 1c 24             	mov    %ebx,(%esp)
8010347b:	e8 70 16 00 00       	call   80104af0 <release>
  return n;
80103480:	83 c4 10             	add    $0x10,%esp
80103483:	8b 45 10             	mov    0x10(%ebp),%eax
80103486:	eb a9                	jmp    80103431 <pipewrite+0xa1>
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103490 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 18             	sub    $0x18,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010349c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010349f:	53                   	push   %ebx
801034a0:	e8 2b 15 00 00       	call   801049d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034a5:	83 c4 10             	add    $0x10,%esp
801034a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034ae:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034b4:	75 6a                	jne    80103520 <piperead+0x90>
801034b6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034bc:	85 f6                	test   %esi,%esi
801034be:	0f 84 cc 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034c4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ca:	eb 2d                	jmp    801034f9 <piperead+0x69>
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	53                   	push   %ebx
801034d4:	56                   	push   %esi
801034d5:	e8 66 04 00 00       	call   80103940 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034da:	83 c4 10             	add    $0x10,%esp
801034dd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034e3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034e9:	75 35                	jne    80103520 <piperead+0x90>
801034eb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034f1:	85 d2                	test   %edx,%edx
801034f3:	0f 84 97 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
801034f9:	e8 d2 02 00 00       	call   801037d0 <myproc>
801034fe:	8b 48 24             	mov    0x24(%eax),%ecx
80103501:	85 c9                	test   %ecx,%ecx
80103503:	74 cb                	je     801034d0 <piperead+0x40>
      release(&p->lock);
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	53                   	push   %ebx
80103509:	e8 e2 15 00 00       	call   80104af0 <release>
      return -1;
8010350e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103519:	5b                   	pop    %ebx
8010351a:	5e                   	pop    %esi
8010351b:	5f                   	pop    %edi
8010351c:	5d                   	pop    %ebp
8010351d:	c3                   	ret    
8010351e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103520:	8b 45 10             	mov    0x10(%ebp),%eax
80103523:	85 c0                	test   %eax,%eax
80103525:	7e 69                	jle    80103590 <piperead+0x100>
    if(p->nread == p->nwrite)
80103527:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352d:	31 c9                	xor    %ecx,%ecx
8010352f:	eb 15                	jmp    80103546 <piperead+0xb6>
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103538:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103544:	74 5a                	je     801035a0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103546:	8d 70 01             	lea    0x1(%eax),%esi
80103549:	25 ff 01 00 00       	and    $0x1ff,%eax
8010354e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103554:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103559:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010355c:	83 c1 01             	add    $0x1,%ecx
8010355f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103562:	75 d4                	jne    80103538 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103564:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	50                   	push   %eax
8010356e:	e8 0d 0c 00 00       	call   80104180 <wakeup>
  release(&p->lock);
80103573:	89 1c 24             	mov    %ebx,(%esp)
80103576:	e8 75 15 00 00       	call   80104af0 <release>
  return i;
8010357b:	8b 45 10             	mov    0x10(%ebp),%eax
8010357e:	83 c4 10             	add    $0x10,%esp
}
80103581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103584:	5b                   	pop    %ebx
80103585:	5e                   	pop    %esi
80103586:	5f                   	pop    %edi
80103587:	5d                   	pop    %ebp
80103588:	c3                   	ret    
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103597:	eb cb                	jmp    80103564 <piperead+0xd4>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801035a3:	eb bf                	jmp    80103564 <piperead+0xd4>
801035a5:	66 90                	xchg   %ax,%ax
801035a7:	66 90                	xchg   %ax,%ax
801035a9:	66 90                	xchg   %ax,%ax
801035ab:	66 90                	xchg   %ax,%ax
801035ad:	66 90                	xchg   %ax,%ax
801035af:	90                   	nop

801035b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b4:	bb 74 40 11 80       	mov    $0x80114074,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035bc:	68 40 40 11 80       	push   $0x80114040
801035c1:	e8 0a 14 00 00       	call   801049d0 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	eb 17                	jmp    801035e2 <allocproc+0x32>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035d0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801035d6:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
801035dc:	0f 84 9e 00 00 00    	je     80103680 <allocproc+0xd0>
    if(p->state == UNUSED)
801035e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801035e5:	85 c0                	test   %eax,%eax
801035e7:	75 e7                	jne    801035d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 0.0;      // default priority , create a process mine
  p->running_time = 0;
  p->creation_time = ticks;
  p->sleeping_counter =0;
  release(&ptable.lock);
801035ee:	83 ec 0c             	sub    $0xc,%esp
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->priority = 0.0;      // default priority , create a process mine
801035f1:	d9 ee                	fldz   
  p->running_time = 0;
  p->creation_time = ticks;
  p->sleeping_counter =0;
  release(&ptable.lock);
801035f3:	68 40 40 11 80       	push   $0x80114040

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035f8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
  p->priority = 0.0;      // default priority , create a process mine
801035ff:	dd 5b 7c             	fstpl  0x7c(%ebx)
  p->running_time = 0;
80103602:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103609:	00 00 00 
  p->creation_time = ticks;
  p->sleeping_counter =0;
8010360c:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103613:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103616:	8d 50 01             	lea    0x1(%eax),%edx
80103619:	89 43 10             	mov    %eax,0x10(%ebx)
  p->priority = 0.0;      // default priority , create a process mine
  p->running_time = 0;
  p->creation_time = ticks;
8010361c:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103621:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  p->priority = 0.0;      // default priority , create a process mine
  p->running_time = 0;
  p->creation_time = ticks;
80103627:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  p->sleeping_counter =0;
  release(&ptable.lock);
8010362d:	e8 be 14 00 00       	call   80104af0 <release>
  

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103632:	e8 59 ee ff ff       	call   80102490 <kalloc>
80103637:	83 c4 10             	add    $0x10,%esp
8010363a:	85 c0                	test   %eax,%eax
8010363c:	89 43 08             	mov    %eax,0x8(%ebx)
8010363f:	74 56                	je     80103697 <allocproc+0xe7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103641:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103647:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010364a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010364f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103652:	c7 40 14 61 5d 10 80 	movl   $0x80105d61,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103659:	6a 14                	push   $0x14
8010365b:	6a 00                	push   $0x0
8010365d:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010365e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103661:	e8 da 14 00 00       	call   80104b40 <memset>
  p->context->eip = (uint)forkret;
80103666:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103669:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
8010366c:	c7 40 10 a0 36 10 80 	movl   $0x801036a0,0x10(%eax)

  return p;
80103673:	89 d8                	mov    %ebx,%eax
}
80103675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103678:	c9                   	leave  
80103679:	c3                   	ret    
8010367a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	68 40 40 11 80       	push   $0x80114040
80103688:	e8 63 14 00 00       	call   80104af0 <release>
  return 0;
8010368d:	83 c4 10             	add    $0x10,%esp
80103690:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103695:	c9                   	leave  
80103696:	c3                   	ret    
  release(&ptable.lock);
  

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103697:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010369e:	eb d5                	jmp    80103675 <allocproc+0xc5>

801036a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 14             	sub    $0x14,%esp
	static int first = 1;
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);
801036a6:	68 40 40 11 80       	push   $0x80114040
801036ab:	e8 40 14 00 00       	call   80104af0 <release>

	if (first)
801036b0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	85 c0                	test   %eax,%eax
801036ba:	75 04                	jne    801036c0 <forkret+0x20>
		iinit(ROOTDEV);
		initlog(ROOTDEV);
	}

  // Return to "caller", actually trapret (see allocproc).
}
801036bc:	c9                   	leave  
801036bd:	c3                   	ret    
801036be:	66 90                	xchg   %ax,%ax
	{
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot
		// be run from main().
		first = 0;
		iinit(ROOTDEV);
801036c0:	83 ec 0c             	sub    $0xc,%esp
	if (first)
	{
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot
		// be run from main().
		first = 0;
801036c3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801036ca:	00 00 00 
		iinit(ROOTDEV);
801036cd:	6a 01                	push   $0x1
801036cf:	e8 9c dd ff ff       	call   80101470 <iinit>
		initlog(ROOTDEV);
801036d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036db:	e8 d0 f3 ff ff       	call   80102ab0 <initlog>
801036e0:	83 c4 10             	add    $0x10,%esp
	}

  // Return to "caller", actually trapret (see allocproc).
}
801036e3:	c9                   	leave  
801036e4:	c3                   	ret    
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <pinit>:
static Min_Heap min_heap[NPROC];
////////////////////////////////////////////////////////////////////////////////////////////////////

void
pinit(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036f6:	68 95 7b 10 80       	push   $0x80107b95
801036fb:	68 40 40 11 80       	push   $0x80114040
80103700:	e8 cb 11 00 00       	call   801048d0 <initlock>
80103705:	b8 c8 b5 10 80       	mov    $0x8010b5c8,%eax
8010370a:	83 c4 10             	add    $0x10,%esp
8010370d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0;i<NPROC;i++)
    min_heap[i].priority = -1.0;*/

    int i;
    for(i=0;i<NPROC;i++)
    	min_heap[i].p=NULL;
80103710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103716:	83 c0 0c             	add    $0xc,%eax
  /*int i;
  for(i=0;i<NPROC;i++)
    min_heap[i].priority = -1.0;*/

    int i;
    for(i=0;i<NPROC;i++)
80103719:	3d c8 b8 10 80       	cmp    $0x8010b8c8,%eax
8010371e:	75 f0                	jne    80103710 <pinit+0x20>
pinit(void)
{
  initlock(&ptable.lock, "ptable");

  init_heap();                //mine
}
80103720:	c9                   	leave  
80103721:	c3                   	ret    
80103722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	56                   	push   %esi
80103734:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103735:	9c                   	pushf  
80103736:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103737:	f6 c4 02             	test   $0x2,%ah
8010373a:	75 5b                	jne    80103797 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010373c:	e8 af ef ff ff       	call   801026f0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103741:	8b 35 20 40 11 80    	mov    0x80114020,%esi
80103747:	85 f6                	test   %esi,%esi
80103749:	7e 3f                	jle    8010378a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010374b:	0f b6 15 a0 3a 11 80 	movzbl 0x80113aa0,%edx
80103752:	39 d0                	cmp    %edx,%eax
80103754:	74 30                	je     80103786 <mycpu+0x56>
80103756:	b9 50 3b 11 80       	mov    $0x80113b50,%ecx
8010375b:	31 d2                	xor    %edx,%edx
8010375d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103760:	83 c2 01             	add    $0x1,%edx
80103763:	39 f2                	cmp    %esi,%edx
80103765:	74 23                	je     8010378a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103767:	0f b6 19             	movzbl (%ecx),%ebx
8010376a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103770:	39 d8                	cmp    %ebx,%eax
80103772:	75 ec                	jne    80103760 <mycpu+0x30>
      return &cpus[i];
80103774:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010377a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010377d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010377e:	05 a0 3a 11 80       	add    $0x80113aa0,%eax
  }
  panic("unknown apicid\n");
}
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
80103785:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103786:	31 d2                	xor    %edx,%edx
80103788:	eb ea                	jmp    80103774 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010378a:	83 ec 0c             	sub    $0xc,%esp
8010378d:	68 9c 7b 10 80       	push   $0x80107b9c
80103792:	e8 d9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103797:	83 ec 0c             	sub    $0xc,%esp
8010379a:	68 bc 7c 10 80       	push   $0x80107cbc
8010379f:	e8 cc cb ff ff       	call   80100370 <panic>
801037a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037b0 <cpuid>:
  init_heap();                //mine
}

// Must be called with interrupts disabled
int
cpuid() {
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037b6:	e8 75 ff ff ff       	call   80103730 <mycpu>
801037bb:	2d a0 3a 11 80       	sub    $0x80113aa0,%eax
}
801037c0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037c1:	c1 f8 04             	sar    $0x4,%eax
801037c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037ca:	c3                   	ret    
801037cb:	90                   	nop
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037d0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037d7:	e8 b4 11 00 00       	call   80104990 <pushcli>
  c = mycpu();
801037dc:	e8 4f ff ff ff       	call   80103730 <mycpu>
  p = c->proc;
801037e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037e7:	e8 94 12 00 00       	call   80104a80 <popcli>
  return p;
}
801037ec:	83 c4 04             	add    $0x4,%esp
801037ef:	89 d8                	mov    %ebx,%eax
801037f1:	5b                   	pop    %ebx
801037f2:	5d                   	pop    %ebp
801037f3:	c3                   	ret    
801037f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103800 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103808:	e8 83 11 00 00       	call   80104990 <pushcli>
  c = mycpu();
8010380d:	e8 1e ff ff ff       	call   80103730 <mycpu>
  p = c->proc;
80103812:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103818:	e8 63 12 00 00       	call   80104a80 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010381d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103820:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103822:	7e 34                	jle    80103858 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103824:	83 ec 04             	sub    $0x4,%esp
80103827:	01 c6                	add    %eax,%esi
80103829:	56                   	push   %esi
8010382a:	50                   	push   %eax
8010382b:	ff 73 04             	pushl  0x4(%ebx)
8010382e:	e8 bd 39 00 00       	call   801071f0 <allocuvm>
80103833:	83 c4 10             	add    $0x10,%esp
80103836:	85 c0                	test   %eax,%eax
80103838:	74 36                	je     80103870 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010383a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010383d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010383f:	53                   	push   %ebx
80103840:	e8 5b 37 00 00       	call   80106fa0 <switchuvm>
  return 0;
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	31 c0                	xor    %eax,%eax
}
8010384a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010384d:	5b                   	pop    %ebx
8010384e:	5e                   	pop    %esi
8010384f:	5d                   	pop    %ebp
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103858:	74 e0                	je     8010383a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010385a:	83 ec 04             	sub    $0x4,%esp
8010385d:	01 c6                	add    %eax,%esi
8010385f:	56                   	push   %esi
80103860:	50                   	push   %eax
80103861:	ff 73 04             	pushl  0x4(%ebx)
80103864:	e8 87 3a 00 00       	call   801072f0 <deallocuvm>
80103869:	83 c4 10             	add    $0x10,%esp
8010386c:	85 c0                	test   %eax,%eax
8010386e:	75 ca                	jne    8010383a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103875:	eb d3                	jmp    8010384a <growproc+0x4a>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103885:	e8 06 11 00 00       	call   80104990 <pushcli>
  c = mycpu();
8010388a:	e8 a1 fe ff ff       	call   80103730 <mycpu>
  p = c->proc;
8010388f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103895:	e8 e6 11 00 00       	call   80104a80 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
8010389a:	83 ec 0c             	sub    $0xc,%esp
8010389d:	68 40 40 11 80       	push   $0x80114040
801038a2:	e8 a9 10 00 00       	call   80104950 <holding>
801038a7:	83 c4 10             	add    $0x10,%esp
801038aa:	85 c0                	test   %eax,%eax
801038ac:	74 4f                	je     801038fd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
801038ae:	e8 7d fe ff ff       	call   80103730 <mycpu>
801038b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801038ba:	75 68                	jne    80103924 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
801038bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801038c0:	74 55                	je     80103917 <sched+0x97>
801038c2:	9c                   	pushf  
801038c3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
801038c4:	f6 c4 02             	test   $0x2,%ah
801038c7:	75 41                	jne    8010390a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
801038c9:	e8 62 fe ff ff       	call   80103730 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801038ce:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
801038d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801038d7:	e8 54 fe ff ff       	call   80103730 <mycpu>
801038dc:	83 ec 08             	sub    $0x8,%esp
801038df:	ff 70 04             	pushl  0x4(%eax)
801038e2:	53                   	push   %ebx
801038e3:	e8 b3 14 00 00       	call   80104d9b <swtch>
  mycpu()->intena = intena;
801038e8:	e8 43 fe ff ff       	call   80103730 <mycpu>
}
801038ed:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
801038f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801038f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038f9:	5b                   	pop    %ebx
801038fa:	5e                   	pop    %esi
801038fb:	5d                   	pop    %ebp
801038fc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
801038fd:	83 ec 0c             	sub    $0xc,%esp
80103900:	68 ac 7b 10 80       	push   $0x80107bac
80103905:	e8 66 ca ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	68 d8 7b 10 80       	push   $0x80107bd8
80103912:	e8 59 ca ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103917:	83 ec 0c             	sub    $0xc,%esp
8010391a:	68 ca 7b 10 80       	push   $0x80107bca
8010391f:	e8 4c ca ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103924:	83 ec 0c             	sub    $0xc,%esp
80103927:	68 be 7b 10 80       	push   $0x80107bbe
8010392c:	e8 3f ca ff ff       	call   80100370 <panic>
80103931:	eb 0d                	jmp    80103940 <sleep>
80103933:	90                   	nop
80103934:	90                   	nop
80103935:	90                   	nop
80103936:	90                   	nop
80103937:	90                   	nop
80103938:	90                   	nop
80103939:	90                   	nop
8010393a:	90                   	nop
8010393b:	90                   	nop
8010393c:	90                   	nop
8010393d:	90                   	nop
8010393e:	90                   	nop
8010393f:	90                   	nop

80103940 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 0c             	sub    $0xc,%esp
80103949:	8b 7d 08             	mov    0x8(%ebp),%edi
8010394c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010394f:	e8 3c 10 00 00       	call   80104990 <pushcli>
  c = mycpu();
80103954:	e8 d7 fd ff ff       	call   80103730 <mycpu>
  p = c->proc;
80103959:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010395f:	e8 1c 11 00 00       	call   80104a80 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
	struct proc *p = myproc();

	if(p == 0)
80103964:	85 db                	test   %ebx,%ebx
80103966:	0f 84 96 00 00 00    	je     80103a02 <sleep+0xc2>
	panic("sleep");

	if(lk == 0)
8010396c:	85 f6                	test   %esi,%esi
8010396e:	0f 84 81 00 00 00    	je     801039f5 <sleep+0xb5>
	// change p->state and then call sched.
	// Once we hold ptable.lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup runs with ptable.lock locked),
	// so it's okay to release lk.
	if(lk != &ptable.lock)			//DOC: sleeplock0
80103974:	81 fe 40 40 11 80    	cmp    $0x80114040,%esi
8010397a:	74 54                	je     801039d0 <sleep+0x90>
	{  
		acquire(&ptable.lock);  	//DOC: sleeplock1
8010397c:	83 ec 0c             	sub    $0xc,%esp
8010397f:	68 40 40 11 80       	push   $0x80114040
80103984:	e8 47 10 00 00       	call   801049d0 <acquire>
		release(lk);
80103989:	89 34 24             	mov    %esi,(%esp)
8010398c:	e8 5f 11 00 00       	call   80104af0 <release>
	}
	// Go to sleep.
	p->chan = chan;
	p->state = SLEEPING;
	p->sleeping_counter++;
80103991:	83 83 8c 00 00 00 01 	addl   $0x1,0x8c(%ebx)
	{  
		acquire(&ptable.lock);  	//DOC: sleeplock1
		release(lk);
	}
	// Go to sleep.
	p->chan = chan;
80103998:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
8010399b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	p->sleeping_counter++;
	sched();
801039a2:	e8 d9 fe ff ff       	call   80103880 <sched>

	// Tidy up.
	p->chan = 0;
801039a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

	// Reacquire original lock.
	if(lk != &ptable.lock)				//DOC: sleeplock2
	{  
		release(&ptable.lock);
801039ae:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
801039b5:	e8 36 11 00 00       	call   80104af0 <release>
		acquire(lk);
801039ba:	89 75 08             	mov    %esi,0x8(%ebp)
801039bd:	83 c4 10             	add    $0x10,%esp
	}
}
801039c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c3:	5b                   	pop    %ebx
801039c4:	5e                   	pop    %esi
801039c5:	5f                   	pop    %edi
801039c6:	5d                   	pop    %ebp

	// Reacquire original lock.
	if(lk != &ptable.lock)				//DOC: sleeplock2
	{  
		release(&ptable.lock);
		acquire(lk);
801039c7:	e9 04 10 00 00       	jmp    801049d0 <acquire>
801039cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		release(lk);
	}
	// Go to sleep.
	p->chan = chan;
	p->state = SLEEPING;
	p->sleeping_counter++;
801039d0:	83 83 8c 00 00 00 01 	addl   $0x1,0x8c(%ebx)
	{  
		acquire(&ptable.lock);  	//DOC: sleeplock1
		release(lk);
	}
	// Go to sleep.
	p->chan = chan;
801039d7:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
801039da:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	p->sleeping_counter++;
	sched();
801039e1:	e8 9a fe ff ff       	call   80103880 <sched>

	// Tidy up.
	p->chan = 0;
801039e6:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
	if(lk != &ptable.lock)				//DOC: sleeplock2
	{  
		release(&ptable.lock);
		acquire(lk);
	}
}
801039ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f0:	5b                   	pop    %ebx
801039f1:	5e                   	pop    %esi
801039f2:	5f                   	pop    %edi
801039f3:	5d                   	pop    %ebp
801039f4:	c3                   	ret    

	if(p == 0)
	panic("sleep");

	if(lk == 0)
	panic("sleep without lk");
801039f5:	83 ec 0c             	sub    $0xc,%esp
801039f8:	68 f2 7b 10 80       	push   $0x80107bf2
801039fd:	e8 6e c9 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
	struct proc *p = myproc();

	if(p == 0)
	panic("sleep");
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 ec 7b 10 80       	push   $0x80107bec
80103a0a:	e8 61 c9 ff ff       	call   80100370 <panic>
80103a0f:	90                   	nop

80103a10 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	56                   	push   %esi
80103a14:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103a15:	e8 76 0f 00 00       	call   80104990 <pushcli>
  c = mycpu();
80103a1a:	e8 11 fd ff ff       	call   80103730 <mycpu>
  p = c->proc;
80103a1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103a25:	e8 56 10 00 00       	call   80104a80 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103a2a:	83 ec 0c             	sub    $0xc,%esp
80103a2d:	68 40 40 11 80       	push   $0x80114040
80103a32:	e8 99 0f 00 00       	call   801049d0 <acquire>
80103a37:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103a3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a3c:	bb 74 40 11 80       	mov    $0x80114074,%ebx
80103a41:	eb 13                	jmp    80103a56 <wait+0x46>
80103a43:	90                   	nop
80103a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a48:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103a4e:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
80103a54:	74 22                	je     80103a78 <wait+0x68>
      if(p->parent != curproc)
80103a56:	39 73 14             	cmp    %esi,0x14(%ebx)
80103a59:	75 ed                	jne    80103a48 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103a5b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103a5f:	74 35                	je     80103a96 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a61:	81 c3 90 00 00 00    	add    $0x90,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103a67:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a6c:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
80103a72:	75 e2                	jne    80103a56 <wait+0x46>
80103a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	74 70                	je     80103aec <wait+0xdc>
80103a7c:	8b 46 24             	mov    0x24(%esi),%eax
80103a7f:	85 c0                	test   %eax,%eax
80103a81:	75 69                	jne    80103aec <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103a83:	83 ec 08             	sub    $0x8,%esp
80103a86:	68 40 40 11 80       	push   $0x80114040
80103a8b:	56                   	push   %esi
80103a8c:	e8 af fe ff ff       	call   80103940 <sleep>
  }
80103a91:	83 c4 10             	add    $0x10,%esp
80103a94:	eb a4                	jmp    80103a3a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103a9c:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103a9f:	e8 3c e8 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103aa4:	5a                   	pop    %edx
80103aa5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103aa8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103aaf:	e8 6c 38 00 00       	call   80107320 <freevm>
        p->pid = 0;
80103ab4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103abb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ac2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ac6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103acd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ad4:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103adb:	e8 10 10 00 00       	call   80104af0 <release>
        return pid;
80103ae0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ae3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103ae6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ae8:	5b                   	pop    %ebx
80103ae9:	5e                   	pop    %esi
80103aea:	5d                   	pop    %ebp
80103aeb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103aec:	83 ec 0c             	sub    $0xc,%esp
80103aef:	68 40 40 11 80       	push   $0x80114040
80103af4:	e8 f7 0f 00 00       	call   80104af0 <release>
      return -1;
80103af9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103afc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103b04:	5b                   	pop    %ebx
80103b05:	5e                   	pop    %esi
80103b06:	5d                   	pop    %ebp
80103b07:	c3                   	ret    
80103b08:	90                   	nop
80103b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	53                   	push   %ebx
80103b14:	83 ec 10             	sub    $0x10,%esp
80103b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *p;

	acquire(&ptable.lock);
80103b1a:	68 40 40 11 80       	push   $0x80114040
80103b1f:	e8 ac 0e 00 00       	call   801049d0 <acquire>
80103b24:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b27:	b8 74 40 11 80       	mov    $0x80114074,%eax
80103b2c:	eb 0e                	jmp    80103b3c <kill+0x2c>
80103b2e:	66 90                	xchg   %ax,%ax
80103b30:	05 90 00 00 00       	add    $0x90,%eax
80103b35:	3d 74 64 11 80       	cmp    $0x80116474,%eax
80103b3a:	74 3c                	je     80103b78 <kill+0x68>
	{
		if(p->pid == pid)
80103b3c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103b3f:	75 ef                	jne    80103b30 <kill+0x20>
		{
			p->killed = 1;
			// Wake process from sleep if necessary.
			if(p->state == SLEEPING)
80103b41:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	{
		if(p->pid == pid)
		{
			p->killed = 1;
80103b45:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
			// Wake process from sleep if necessary.
			if(p->state == SLEEPING)
80103b4c:	74 1a                	je     80103b68 <kill+0x58>
			{
				p->state = RUNNABLE;
				//p->priority = (double)(p->running_time)/((double)(ticks) - (double)(p->creation_time));
				//insert_to_heap(p);
		  	}
		  	release(&ptable.lock);
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	68 40 40 11 80       	push   $0x80114040
80103b56:	e8 95 0f 00 00       	call   80104af0 <release>
		  	return 0;
80103b5b:	83 c4 10             	add    $0x10,%esp
80103b5e:	31 c0                	xor    %eax,%eax
		}
	}
	release(&ptable.lock);
	return -1;
}
80103b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b63:	c9                   	leave  
80103b64:	c3                   	ret    
80103b65:	8d 76 00             	lea    0x0(%esi),%esi
		{
			p->killed = 1;
			// Wake process from sleep if necessary.
			if(p->state == SLEEPING)
			{
				p->state = RUNNABLE;
80103b68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103b6f:	eb dd                	jmp    80103b4e <kill+0x3e>
80103b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		  	}
		  	release(&ptable.lock);
		  	return 0;
		}
	}
	release(&ptable.lock);
80103b78:	83 ec 0c             	sub    $0xc,%esp
80103b7b:	68 40 40 11 80       	push   $0x80114040
80103b80:	e8 6b 0f 00 00       	call   80104af0 <release>
	return -1;
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b90:	c9                   	leave  
80103b91:	c3                   	ret    
80103b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	57                   	push   %edi
80103ba4:	56                   	push   %esi
80103ba5:	53                   	push   %ebx
80103ba6:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ba9:	bb e0 40 11 80       	mov    $0x801140e0,%ebx
80103bae:	83 ec 3c             	sub    $0x3c,%esp
80103bb1:	eb 27                	jmp    80103bda <procdump+0x3a>
80103bb3:	90                   	nop
80103bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	68 8f 7c 10 80       	push   $0x80107c8f
80103bc0:	e8 9b ca ff ff       	call   80100660 <cprintf>
80103bc5:	83 c4 10             	add    $0x10,%esp
80103bc8:	81 c3 90 00 00 00    	add    $0x90,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bce:	81 fb e0 64 11 80    	cmp    $0x801164e0,%ebx
80103bd4:	0f 84 7e 00 00 00    	je     80103c58 <procdump+0xb8>
    if(p->state == UNUSED)
80103bda:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103bdd:	85 c0                	test   %eax,%eax
80103bdf:	74 e7                	je     80103bc8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103be1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103be4:	ba 03 7c 10 80       	mov    $0x80107c03,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103be9:	77 11                	ja     80103bfc <procdump+0x5c>
80103beb:	8b 14 85 a4 7d 10 80 	mov    -0x7fef825c(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103bf2:	b8 03 7c 10 80       	mov    $0x80107c03,%eax
80103bf7:	85 d2                	test   %edx,%edx
80103bf9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103bfc:	53                   	push   %ebx
80103bfd:	52                   	push   %edx
80103bfe:	ff 73 a4             	pushl  -0x5c(%ebx)
80103c01:	68 07 7c 10 80       	push   $0x80107c07
80103c06:	e8 55 ca ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80103c0b:	83 c4 10             	add    $0x10,%esp
80103c0e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103c12:	75 a4                	jne    80103bb8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103c14:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103c17:	83 ec 08             	sub    $0x8,%esp
80103c1a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103c1d:	50                   	push   %eax
80103c1e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103c21:	8b 40 0c             	mov    0xc(%eax),%eax
80103c24:	83 c0 08             	add    $0x8,%eax
80103c27:	50                   	push   %eax
80103c28:	e8 c3 0c 00 00       	call   801048f0 <getcallerpcs>
80103c2d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80103c30:	8b 17                	mov    (%edi),%edx
80103c32:	85 d2                	test   %edx,%edx
80103c34:	74 82                	je     80103bb8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103c36:	83 ec 08             	sub    $0x8,%esp
80103c39:	83 c7 04             	add    $0x4,%edi
80103c3c:	52                   	push   %edx
80103c3d:	68 81 76 10 80       	push   $0x80107681
80103c42:	e8 19 ca ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103c47:	83 c4 10             	add    $0x10,%esp
80103c4a:	39 f7                	cmp    %esi,%edi
80103c4c:	75 e2                	jne    80103c30 <procdump+0x90>
80103c4e:	e9 65 ff ff ff       	jmp    80103bb8 <procdump+0x18>
80103c53:	90                   	nop
80103c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c5b:	5b                   	pop    %ebx
80103c5c:	5e                   	pop    %esi
80103c5d:	5f                   	pop    %edi
80103c5e:	5d                   	pop    %ebp
80103c5f:	c3                   	ret    

80103c60 <init_heap>:

//////////////////////////////////////////////////////////////////////////////////////////////////////

void                                    // min_heap structure
init_heap()
{
80103c60:	55                   	push   %ebp
80103c61:	b8 c8 b5 10 80       	mov    $0x8010b5c8,%eax
80103c66:	89 e5                	mov    %esp,%ebp
80103c68:	90                   	nop
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0;i<NPROC;i++)
    min_heap[i].priority = -1.0;*/

    int i;
    for(i=0;i<NPROC;i++)
    	min_heap[i].p=NULL;
80103c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c76:	83 c0 0c             	add    $0xc,%eax
  /*int i;
  for(i=0;i<NPROC;i++)
    min_heap[i].priority = -1.0;*/

    int i;
    for(i=0;i<NPROC;i++)
80103c79:	3d c8 b8 10 80       	cmp    $0x8010b8c8,%eax
80103c7e:	75 f0                	jne    80103c70 <init_heap+0x10>
    	min_heap[i].p=NULL;
}
80103c80:	5d                   	pop    %ebp
80103c81:	c3                   	ret    
80103c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c90 <heapify>:
	}
}

void
heapify()
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	bf 40 00 00 00       	mov    $0x40,%edi
80103c9b:	83 ec 0c             	sub    $0xc,%esp
80103c9e:	66 90                	xchg   %ax,%ax
80103ca0:	b8 bc b8 10 80       	mov    $0x8010b8bc,%eax
80103ca5:	ba 3e 00 00 00       	mov    $0x3e,%edx
80103caa:	89 7d ec             	mov    %edi,-0x14(%ebp)
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
  	struct Min_Heap temp;
  	for (y=0;y<NPROC;y++)          //isos den xreiazetai ayto 
 	{ 
	    for (i=NPROC-1;i>=0;i--)
	    {
	      if ((min_heap[i].p) && (min_heap[i].p->priority < min_heap[(i-1)/2].p->priority))
80103cb0:	8b 18                	mov    (%eax),%ebx
80103cb2:	85 db                	test   %ebx,%ebx
80103cb4:	74 47                	je     80103cfd <heapify+0x6d>
80103cb6:	89 d1                	mov    %edx,%ecx
80103cb8:	c1 e9 1f             	shr    $0x1f,%ecx
80103cbb:	01 d1                	add    %edx,%ecx
80103cbd:	d1 f9                	sar    %ecx
80103cbf:	8d 34 49             	lea    (%ecx,%ecx,2),%esi
80103cc2:	8d 0c b5 c0 b5 10 80 	lea    -0x7fef4a40(,%esi,4),%ecx
80103cc9:	8b 79 08             	mov    0x8(%ecx),%edi
80103ccc:	dd 47 7c             	fldl   0x7c(%edi)
80103ccf:	dd 43 7c             	fldl   0x7c(%ebx)
80103cd2:	d9 c9                	fxch   %st(1)
80103cd4:	df e9                	fucomip %st(1),%st
80103cd6:	dd d8                	fstp   %st(0)
80103cd8:	76 23                	jbe    80103cfd <heapify+0x6d>
	      {
	        temp = min_heap[(i-1)/2];
80103cda:	89 fb                	mov    %edi,%ebx
	        min_heap[(i-1)/2] = min_heap[i];
80103cdc:	8b 78 f8             	mov    -0x8(%eax),%edi
 	{ 
	    for (i=NPROC-1;i>=0;i--)
	    {
	      if ((min_heap[i].p) && (min_heap[i].p->priority < min_heap[(i-1)/2].p->priority))
	      {
	        temp = min_heap[(i-1)/2];
80103cdf:	dd 04 b5 c0 b5 10 80 	fldl   -0x7fef4a40(,%esi,4)
	        min_heap[(i-1)/2] = min_heap[i];
80103ce6:	89 3c b5 c0 b5 10 80 	mov    %edi,-0x7fef4a40(,%esi,4)
80103ced:	8b 70 fc             	mov    -0x4(%eax),%esi
80103cf0:	89 71 04             	mov    %esi,0x4(%ecx)
80103cf3:	8b 30                	mov    (%eax),%esi
80103cf5:	89 71 08             	mov    %esi,0x8(%ecx)
	        min_heap[i] = temp;
80103cf8:	dd 58 f8             	fstpl  -0x8(%eax)
80103cfb:	89 18                	mov    %ebx,(%eax)
80103cfd:	83 ea 01             	sub    $0x1,%edx
80103d00:	83 e8 0c             	sub    $0xc,%eax
	int i;
  	int y;
  	struct Min_Heap temp;
  	for (y=0;y<NPROC;y++)          //isos den xreiazetai ayto 
 	{ 
	    for (i=NPROC-1;i>=0;i--)
80103d03:	83 fa fe             	cmp    $0xfffffffe,%edx
80103d06:	75 a8                	jne    80103cb0 <heapify+0x20>
80103d08:	8b 7d ec             	mov    -0x14(%ebp),%edi
  //}*/

	int i;
  	int y;
  	struct Min_Heap temp;
  	for (y=0;y<NPROC;y++)          //isos den xreiazetai ayto 
80103d0b:	83 ef 01             	sub    $0x1,%edi
80103d0e:	75 90                	jne    80103ca0 <heapify+0x10>
	        min_heap[(i-1)/2] = min_heap[i];
	        min_heap[i] = temp;
	      }
	    }
	}
}
80103d10:	83 c4 0c             	add    $0xc,%esp
80103d13:	5b                   	pop    %ebx
80103d14:	5e                   	pop    %esi
80103d15:	5f                   	pop    %edi
80103d16:	5d                   	pop    %ebp
80103d17:	c3                   	ret    
80103d18:	90                   	nop
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d20 <insert_to_heap>:
    	min_heap[i].p=NULL;
}

void
insert_to_heap(struct proc* p)
{
80103d20:	55                   	push   %ebp
80103d21:	ba c8 b5 10 80       	mov    $0x8010b5c8,%edx
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80103d26:	31 c0                	xor    %eax,%eax
    	min_heap[i].p=NULL;
}

void
insert_to_heap(struct proc* p)
{
80103d28:	89 e5                	mov    %esp,%ebp
80103d2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d2d:	eb 0c                	jmp    80103d3b <insert_to_heap+0x1b>
80103d2f:	90                   	nop
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80103d30:	83 c0 01             	add    $0x1,%eax
80103d33:	83 c2 0c             	add    $0xc,%edx
80103d36:	83 f8 40             	cmp    $0x40,%eax
80103d39:	74 15                	je     80103d50 <insert_to_heap+0x30>
	{
		if (!min_heap[i].p)
80103d3b:	83 3a 00             	cmpl   $0x0,(%edx)
80103d3e:	75 f0                	jne    80103d30 <insert_to_heap+0x10>
			min_heap[i].p = p;
			heapify();
			break;
		}
	}
}
80103d40:	5d                   	pop    %ebp
	int i;
	for (i=0;i<NPROC;i++)
	{
		if (!min_heap[i].p)
		{
			min_heap[i].p = p;
80103d41:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103d44:	89 0c 85 c8 b5 10 80 	mov    %ecx,-0x7fef4a38(,%eax,4)
			heapify();
80103d4b:	e9 40 ff ff ff       	jmp    80103c90 <heapify>
			break;
		}
	}
}
80103d50:	5d                   	pop    %ebp
80103d51:	c3                   	ret    
80103d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d60 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103d67:	e8 44 f8 ff ff       	call   801035b0 <allocproc>
80103d6c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103d6e:	a3 c0 b8 10 80       	mov    %eax,0x8010b8c0
  if((p->pgdir = setupkvm()) == 0)
80103d73:	e8 28 36 00 00       	call   801073a0 <setupkvm>
80103d78:	85 c0                	test   %eax,%eax
80103d7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103d7d:	0f 84 f2 00 00 00    	je     80103e75 <userinit+0x115>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103d83:	83 ec 04             	sub    $0x4,%esp
80103d86:	68 2c 00 00 00       	push   $0x2c
80103d8b:	68 60 b4 10 80       	push   $0x8010b460
80103d90:	50                   	push   %eax
80103d91:	e8 1a 33 00 00       	call   801070b0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103d96:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103d99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103d9f:	6a 4c                	push   $0x4c
80103da1:	6a 00                	push   $0x0
80103da3:	ff 73 18             	pushl  0x18(%ebx)
80103da6:	e8 95 0d 00 00       	call   80104b40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dab:	8b 43 18             	mov    0x18(%ebx),%eax
80103dae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103db3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103db8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103dbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103dbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103dc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103dd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103dd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ddc:	8b 43 18             	mov    0x18(%ebx),%eax
80103ddf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103de6:	8b 43 18             	mov    0x18(%ebx),%eax
80103de9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103df0:	8b 43 18             	mov    0x18(%ebx),%eax
80103df3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103dfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103dfd:	6a 10                	push   $0x10
80103dff:	68 29 7c 10 80       	push   $0x80107c29
80103e04:	50                   	push   %eax
80103e05:	e8 36 0f 00 00       	call   80104d40 <safestrcpy>
  p->cwd = namei("/");
80103e0a:	c7 04 24 32 7c 10 80 	movl   $0x80107c32,(%esp)
80103e11:	e8 aa e0 ff ff       	call   80101ec0 <namei>
80103e16:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103e19:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103e20:	e8 ab 0b 00 00       	call   801049d0 <acquire>
  p->state = RUNNABLE;
80103e25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
80103e2c:	ba c8 b5 10 80       	mov    $0x8010b5c8,%edx
80103e31:	83 c4 10             	add    $0x10,%esp
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80103e34:	31 c0                	xor    %eax,%eax
80103e36:	eb 13                	jmp    80103e4b <userinit+0xeb>
80103e38:	90                   	nop
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e40:	83 c0 01             	add    $0x1,%eax
80103e43:	83 c2 0c             	add    $0xc,%edx
80103e46:	83 f8 40             	cmp    $0x40,%eax
80103e49:	74 15                	je     80103e60 <userinit+0x100>
	{
		if (!min_heap[i].p)
80103e4b:	8b 0a                	mov    (%edx),%ecx
80103e4d:	85 c9                	test   %ecx,%ecx
80103e4f:	75 ef                	jne    80103e40 <userinit+0xe0>
		{
			min_heap[i].p = p;
80103e51:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103e54:	89 1c 85 c8 b5 10 80 	mov    %ebx,-0x7fef4a38(,%eax,4)
			heapify();
80103e5b:	e8 30 fe ff ff       	call   80103c90 <heapify>
////////////////////////////////////////////////////////////////////////////////////////////////////////////

  insert_to_heap(p);		//default priority = 0
////////////////////////////////////////////////////////////////////////////////////////////////////////////

  release(&ptable.lock);
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	68 40 40 11 80       	push   $0x80114040
80103e68:	e8 83 0c 00 00       	call   80104af0 <release>
}
80103e6d:	83 c4 10             	add    $0x10,%esp
80103e70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e73:	c9                   	leave  
80103e74:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103e75:	83 ec 0c             	sub    $0xc,%esp
80103e78:	68 10 7c 10 80       	push   $0x80107c10
80103e7d:	e8 ee c4 ff ff       	call   80100370 <panic>
80103e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e90 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e99:	e8 f2 0a 00 00       	call   80104990 <pushcli>
  c = mycpu();
80103e9e:	e8 8d f8 ff ff       	call   80103730 <mycpu>
  p = c->proc;
80103ea3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea9:	e8 d2 0b 00 00       	call   80104a80 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103eae:	e8 fd f6 ff ff       	call   801035b0 <allocproc>
80103eb3:	85 c0                	test   %eax,%eax
80103eb5:	89 c7                	mov    %eax,%edi
80103eb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103eba:	0f 84 ed 00 00 00    	je     80103fad <fork+0x11d>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ec0:	83 ec 08             	sub    $0x8,%esp
80103ec3:	ff 33                	pushl  (%ebx)
80103ec5:	ff 73 04             	pushl  0x4(%ebx)
80103ec8:	e8 a3 35 00 00       	call   80107470 <copyuvm>
80103ecd:	83 c4 10             	add    $0x10,%esp
80103ed0:	85 c0                	test   %eax,%eax
80103ed2:	89 47 04             	mov    %eax,0x4(%edi)
80103ed5:	0f 84 d9 00 00 00    	je     80103fb4 <fork+0x124>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103edb:	8b 03                	mov    (%ebx),%eax
80103edd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ee0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103ee2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103ee5:	89 c8                	mov    %ecx,%eax
80103ee7:	8b 79 18             	mov    0x18(%ecx),%edi
80103eea:	8b 73 18             	mov    0x18(%ebx),%esi
80103eed:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ef2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103ef4:	31 f6                	xor    %esi,%esi
  np->parent = curproc;
  *np->tf = *curproc->tf;


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103ef6:	8b 40 18             	mov    0x18(%eax),%eax
80103ef9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103f00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	74 13                	je     80103f1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	50                   	push   %eax
80103f0c:	e8 cf ce ff ff       	call   80100de0 <filedup>
80103f11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103f14:	83 c4 10             	add    $0x10,%esp
80103f17:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)


  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103f1b:	83 c6 01             	add    $0x1,%esi
80103f1e:	83 fe 10             	cmp    $0x10,%esi
80103f21:	75 dd                	jne    80103f00 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	ff 73 68             	pushl  0x68(%ebx)
80103f29:	e8 12 d7 ff ff       	call   80101640 <idup>
80103f2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f31:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103f34:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f37:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f3a:	6a 10                	push   $0x10
80103f3c:	50                   	push   %eax
80103f3d:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f40:	50                   	push   %eax
80103f41:	e8 fa 0d 00 00       	call   80104d40 <safestrcpy>

  pid = np->pid;
  np->priority = curproc->priority;				//mine
80103f46:	dd 43 7c             	fldl   0x7c(%ebx)
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;
80103f49:	8b 77 10             	mov    0x10(%edi),%esi
  np->priority = curproc->priority;				//mine
80103f4c:	dd 5f 7c             	fstpl  0x7c(%edi)

  acquire(&ptable.lock);
80103f4f:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80103f56:	e8 75 0a 00 00       	call   801049d0 <acquire>

  np->state = RUNNABLE;                 //insert min-heap
80103f5b:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
80103f62:	b8 c8 b5 10 80       	mov    $0x8010b5c8,%eax
80103f67:	83 c4 10             	add    $0x10,%esp
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80103f6a:	31 d2                	xor    %edx,%edx
80103f6c:	eb 0d                	jmp    80103f7b <fork+0xeb>
80103f6e:	66 90                	xchg   %ax,%ax
80103f70:	83 c2 01             	add    $0x1,%edx
80103f73:	83 c0 0c             	add    $0xc,%eax
80103f76:	83 fa 40             	cmp    $0x40,%edx
80103f79:	74 18                	je     80103f93 <fork+0x103>
	{
		if (!min_heap[i].p)
80103f7b:	8b 08                	mov    (%eax),%ecx
80103f7d:	85 c9                	test   %ecx,%ecx
80103f7f:	75 ef                	jne    80103f70 <fork+0xe0>
		{
			min_heap[i].p = p;
80103f81:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f84:	8d 04 52             	lea    (%edx,%edx,2),%eax
80103f87:	89 1c 85 c8 b5 10 80 	mov    %ebx,-0x7fef4a38(,%eax,4)
			heapify();
80103f8e:	e8 fd fc ff ff       	call   80103c90 <heapify>
  np->state = RUNNABLE;                 //insert min-heap
////////////////////////////////////////////////////////////////////////////////////////////////////////////
  	
  insert_to_heap(np);
////////////////////////////////////////////////////////////////////////////////////////////////////////////
  release(&ptable.lock);
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	68 40 40 11 80       	push   $0x80114040
80103f9b:	e8 50 0b 00 00       	call   80104af0 <release>

  return pid;
80103fa0:	83 c4 10             	add    $0x10,%esp
80103fa3:	89 f0                	mov    %esi,%eax
}
80103fa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fa8:	5b                   	pop    %ebx
80103fa9:	5e                   	pop    %esi
80103faa:	5f                   	pop    %edi
80103fab:	5d                   	pop    %ebp
80103fac:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103fad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fb2:	eb f1                	jmp    80103fa5 <fork+0x115>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103fb4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fb7:	83 ec 0c             	sub    $0xc,%esp
80103fba:	ff 73 08             	pushl  0x8(%ebx)
80103fbd:	e8 1e e3 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103fc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103fc9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103fd0:	83 c4 10             	add    $0x10,%esp
80103fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd8:	eb cb                	jmp    80103fa5 <fork+0x115>
80103fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fe0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	89 c6                	mov    %eax,%esi
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe7:	bb 74 40 11 80       	mov    $0x80114074,%ebx
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103fec:	83 ec 10             	sub    $0x10,%esp
80103fef:	eb 15                	jmp    80104006 <wakeup1+0x26>
80103ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ffe:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
80104004:	74 78                	je     8010407e <wakeup1+0x9e>
	{
		if(p->state == SLEEPING && p->chan == chan)
80104006:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010400a:	75 ec                	jne    80103ff8 <wakeup1+0x18>
8010400c:	39 73 20             	cmp    %esi,0x20(%ebx)
8010400f:	75 e7                	jne    80103ff8 <wakeup1+0x18>
		{
			p->state = RUNNABLE;
			p->priority = (double)(p->running_time)/((double)(ticks) - (double)(p->creation_time));
80104011:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
80104016:	db 83 88 00 00 00    	fildl  0x88(%ebx)
8010401c:	31 d2                	xor    %edx,%edx
8010401e:	89 55 ec             	mov    %edx,-0x14(%ebp)
80104021:	31 d2                	xor    %edx,%edx
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	{
		if(p->state == SLEEPING && p->chan == chan)
		{
			p->state = RUNNABLE;
80104023:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
8010402a:	b9 c8 b5 10 80       	mov    $0x8010b5c8,%ecx
			p->priority = (double)(p->running_time)/((double)(ticks) - (double)(p->creation_time));
8010402f:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104032:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80104038:	df 6d e8             	fildll -0x18(%ebp)
8010403b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
8010403e:	31 d2                	xor    %edx,%edx
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
	{
		if(p->state == SLEEPING && p->chan == chan)
		{
			p->state = RUNNABLE;
			p->priority = (double)(p->running_time)/((double)(ticks) - (double)(p->creation_time));
80104040:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104043:	df 6d e8             	fildll -0x18(%ebp)
80104046:	de e9                	fsubrp %st,%st(1)
80104048:	de f9                	fdivrp %st,%st(1)
8010404a:	dd 5b 7c             	fstpl  0x7c(%ebx)
8010404d:	eb 0c                	jmp    8010405b <wakeup1+0x7b>
8010404f:	90                   	nop
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80104050:	83 c2 01             	add    $0x1,%edx
80104053:	83 c1 0c             	add    $0xc,%ecx
80104056:	83 fa 40             	cmp    $0x40,%edx
80104059:	74 9d                	je     80103ff8 <wakeup1+0x18>
	{
		if (!min_heap[i].p)
8010405b:	8b 01                	mov    (%ecx),%eax
8010405d:	85 c0                	test   %eax,%eax
8010405f:	75 ef                	jne    80104050 <wakeup1+0x70>
		{
			min_heap[i].p = p;
80104061:	8d 04 52             	lea    (%edx,%edx,2),%eax
80104064:	89 1c 85 c8 b5 10 80 	mov    %ebx,-0x7fef4a38(,%eax,4)
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010406b:	81 c3 90 00 00 00    	add    $0x90,%ebx
	for (i=0;i<NPROC;i++)
	{
		if (!min_heap[i].p)
		{
			min_heap[i].p = p;
			heapify();
80104071:	e8 1a fc ff ff       	call   80103c90 <heapify>
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104076:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
8010407c:	75 88                	jne    80104006 <wakeup1+0x26>
		  	insert_to_heap(p);
			

		}
	}
}     
8010407e:	83 c4 10             	add    $0x10,%esp
80104081:	5b                   	pop    %ebx
80104082:	5e                   	pop    %esi
80104083:	5d                   	pop    %ebp
80104084:	c3                   	ret    
80104085:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104099:	e8 f2 08 00 00       	call   80104990 <pushcli>
  c = mycpu();
8010409e:	e8 8d f6 ff ff       	call   80103730 <mycpu>
  p = c->proc;
801040a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040a9:	e8 d2 09 00 00       	call   80104a80 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801040ae:	39 35 c0 b8 10 80    	cmp    %esi,0x8010b8c0
801040b4:	8d 5e 28             	lea    0x28(%esi),%ebx
801040b7:	8d 7e 68             	lea    0x68(%esi),%edi
801040ba:	0f 84 b1 00 00 00    	je     80104171 <exit+0xe1>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
801040c0:	8b 03                	mov    (%ebx),%eax
801040c2:	85 c0                	test   %eax,%eax
801040c4:	74 12                	je     801040d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	50                   	push   %eax
801040ca:	e8 61 cd ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
801040cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801040db:	39 fb                	cmp    %edi,%ebx
801040dd:	75 e1                	jne    801040c0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
801040df:	e8 6c ea ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	ff 76 68             	pushl  0x68(%esi)

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040ea:	bb 74 40 11 80       	mov    $0x80114074,%ebx
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
801040ef:	e8 ac d6 ff ff       	call   801017a0 <iput>
  end_op();
801040f4:	e8 c7 ea ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
801040f9:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80104100:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80104107:	e8 c4 08 00 00       	call   801049d0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
8010410c:	8b 46 14             	mov    0x14(%esi),%eax
8010410f:	e8 cc fe ff ff       	call   80103fe0 <wakeup1>
80104114:	83 c4 10             	add    $0x10,%esp
80104117:	eb 15                	jmp    8010412e <exit+0x9e>
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104120:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104126:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
8010412c:	74 2a                	je     80104158 <exit+0xc8>
    if(p->parent == curproc){
8010412e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104131:	75 ed                	jne    80104120 <exit+0x90>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80104133:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80104137:	a1 c0 b8 10 80       	mov    0x8010b8c0,%eax
8010413c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010413f:	75 df                	jne    80104120 <exit+0x90>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104141:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
80104147:	e8 94 fe ff ff       	call   80103fe0 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414c:	81 fb 74 64 11 80    	cmp    $0x80116474,%ebx
80104152:	75 da                	jne    8010412e <exit+0x9e>
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104158:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010415f:	e8 1c f7 ff ff       	call   80103880 <sched>
  panic("zombie exit");
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	68 41 7c 10 80       	push   $0x80107c41
8010416c:	e8 ff c1 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104171:	83 ec 0c             	sub    $0xc,%esp
80104174:	68 34 7c 10 80       	push   $0x80107c34
80104179:	e8 f2 c1 ff ff       	call   80100370 <panic>
8010417e:	66 90                	xchg   %ax,%ax

80104180 <wakeup>:
}     

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
8010418a:	68 40 40 11 80       	push   $0x80114040
8010418f:	e8 3c 08 00 00       	call   801049d0 <acquire>
	wakeup1(chan);
80104194:	89 d8                	mov    %ebx,%eax
80104196:	e8 45 fe ff ff       	call   80103fe0 <wakeup1>
	release(&ptable.lock);
8010419b:	83 c4 10             	add    $0x10,%esp
8010419e:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
801041a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a8:	c9                   	leave  
void
wakeup(void *chan)
{
	acquire(&ptable.lock);
	wakeup1(chan);
	release(&ptable.lock);
801041a9:	e9 42 09 00 00       	jmp    80104af0 <release>
801041ae:	66 90                	xchg   %ax,%ax

801041b0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	83 ec 2c             	sub    $0x2c,%esp
  	acquire(&ptable.lock);  //DOC: yieldlock
801041b8:	68 40 40 11 80       	push   $0x80114040
801041bd:	e8 0e 08 00 00       	call   801049d0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041c2:	e8 c9 07 00 00       	call   80104990 <pushcli>
  c = mycpu();
801041c7:	e8 64 f5 ff ff       	call   80103730 <mycpu>
  p = c->proc;
801041cc:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041d2:	e8 a9 08 00 00       	call   80104a80 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  	acquire(&ptable.lock);  //DOC: yieldlock
  	myproc()->state = RUNNABLE;
801041d7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041de:	e8 ad 07 00 00       	call   80104990 <pushcli>
  c = mycpu();
801041e3:	e8 48 f5 ff ff       	call   80103730 <mycpu>
  p = c->proc;
801041e8:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041ee:	e8 8d 08 00 00       	call   80104a80 <popcli>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801041f3:	e8 98 07 00 00       	call   80104990 <pushcli>
  c = mycpu();
801041f8:	e8 33 f5 ff ff       	call   80103730 <mycpu>
  p = c->proc;
801041fd:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104203:	e8 78 08 00 00       	call   80104a80 <popcli>
{
  	acquire(&ptable.lock);  //DOC: yieldlock
  	myproc()->state = RUNNABLE;
  	//myproc()->running_time++;
  	
  	myproc()->priority = ((double)(myproc()->running_time))/((double)(ticks) - (double)(myproc()->creation_time));
80104208:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
8010420d:	31 d2                	xor    %edx,%edx
8010420f:	db 86 88 00 00 00    	fildl  0x88(%esi)
80104215:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104218:	dd 5d e8             	fstpl  -0x18(%ebp)
8010421b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010421e:	df 6d e0             	fildll -0x20(%ebp)
80104221:	dd 5d e0             	fstpl  -0x20(%ebp)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104224:	e8 67 07 00 00       	call   80104990 <pushcli>
  c = mycpu();
80104229:	e8 02 f5 ff ff       	call   80103730 <mycpu>
  p = c->proc;
8010422e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104234:	e8 47 08 00 00       	call   80104a80 <popcli>
{
  	acquire(&ptable.lock);  //DOC: yieldlock
  	myproc()->state = RUNNABLE;
  	//myproc()->running_time++;
  	
  	myproc()->priority = ((double)(myproc()->running_time))/((double)(ticks) - (double)(myproc()->creation_time));
80104239:	31 d2                	xor    %edx,%edx
8010423b:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
80104241:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104244:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104247:	df 6d d8             	fildll -0x28(%ebp)
8010424a:	dc 6d e0             	fsubrl -0x20(%ebp)
8010424d:	dc 7d e8             	fdivrl -0x18(%ebp)
80104250:	dd 5b 7c             	fstpl  0x7c(%ebx)
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104253:	e8 38 07 00 00       	call   80104990 <pushcli>
  c = mycpu();
80104258:	e8 d3 f4 ff ff       	call   80103730 <mycpu>
  p = c->proc;
8010425d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104263:	e8 18 08 00 00       	call   80104a80 <popcli>
80104268:	ba c8 b5 10 80       	mov    $0x8010b5c8,%edx
8010426d:	83 c4 10             	add    $0x10,%esp
		  heapify();
		  break ;
		}
	}*/
	int i;
	for (i=0;i<NPROC;i++)
80104270:	31 c0                	xor    %eax,%eax
80104272:	eb 0f                	jmp    80104283 <yield+0xd3>
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104278:	83 c0 01             	add    $0x1,%eax
8010427b:	83 c2 0c             	add    $0xc,%edx
8010427e:	83 f8 40             	cmp    $0x40,%eax
80104281:	74 15                	je     80104298 <yield+0xe8>
	{
		if (!min_heap[i].p)
80104283:	8b 0a                	mov    (%edx),%ecx
80104285:	85 c9                	test   %ecx,%ecx
80104287:	75 ef                	jne    80104278 <yield+0xc8>
		{
			min_heap[i].p = p;
80104289:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010428c:	89 1c 85 c8 b5 10 80 	mov    %ebx,-0x7fef4a38(,%eax,4)
			heapify();
80104293:	e8 f8 f9 ff ff       	call   80103c90 <heapify>
  	
  	myproc()->priority = ((double)(myproc()->running_time))/((double)(ticks) - (double)(myproc()->creation_time));
  	
  	insert_to_heap(myproc());
  
  	sched();
80104298:	e8 e3 f5 ff ff       	call   80103880 <sched>
  	release(&ptable.lock);
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 40 40 11 80       	push   $0x80114040
801042a5:	e8 46 08 00 00       	call   80104af0 <release>
}
801042aa:	83 c4 10             	add    $0x10,%esp
801042ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b0:	5b                   	pop    %ebx
801042b1:	5e                   	pop    %esi
801042b2:	5d                   	pop    %ebp
801042b3:	c3                   	ret    
801042b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042c0 <pop>:
	}
}

struct proc*
pop()
{
801042c0:	55                   	push   %ebp
801042c1:	b8 bc b8 10 80       	mov    $0x8010b8bc,%eax
	heapify();
	return temp_p;*/

	int i;
	struct proc* temp_p;
	for (i=NPROC-1;i>=0;i--)
801042c6:	ba 3f 00 00 00       	mov    $0x3f,%edx
	}
}

struct proc*
pop()
{
801042cb:	89 e5                	mov    %esp,%ebp
801042cd:	53                   	push   %ebx
801042ce:	83 ec 04             	sub    $0x4,%esp
801042d1:	eb 10                	jmp    801042e3 <pop+0x23>
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	heapify();
	return temp_p;*/

	int i;
	struct proc* temp_p;
	for (i=NPROC-1;i>=0;i--)
801042d8:	83 ea 01             	sub    $0x1,%edx
801042db:	83 e8 0c             	sub    $0xc,%eax
801042de:	83 fa ff             	cmp    $0xffffffff,%edx
801042e1:	74 06                	je     801042e9 <pop+0x29>
	{
		if (min_heap[i].p)
801042e3:	8b 08                	mov    (%eax),%ecx
801042e5:	85 c9                	test   %ecx,%ecx
801042e7:	74 ef                	je     801042d8 <pop+0x18>
			break;
	}
	temp_p = min_heap[0].p; 
	min_heap[0]=min_heap[i];
801042e9:	8d 14 52             	lea    (%edx,%edx,2),%edx
	for (i=NPROC-1;i>=0;i--)
	{
		if (min_heap[i].p)
			break;
	}
	temp_p = min_heap[0].p; 
801042ec:	8b 1d c8 b5 10 80    	mov    0x8010b5c8,%ebx
	min_heap[0]=min_heap[i];
801042f2:	c1 e2 02             	shl    $0x2,%edx
801042f5:	8d 82 c0 b5 10 80    	lea    -0x7fef4a40(%edx),%eax
801042fb:	8b 92 c0 b5 10 80    	mov    -0x7fef4a40(%edx),%edx
80104301:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
80104307:	8b 50 04             	mov    0x4(%eax),%edx
8010430a:	89 15 c4 b5 10 80    	mov    %edx,0x8010b5c4
80104310:	8b 50 08             	mov    0x8(%eax),%edx
80104313:	89 15 c8 b5 10 80    	mov    %edx,0x8010b5c8
	min_heap[i].p = 0;
80104319:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	heapify();
80104320:	e8 6b f9 ff ff       	call   80103c90 <heapify>
	return temp_p;

}
80104325:	83 c4 04             	add    $0x4,%esp
80104328:	89 d8                	mov    %ebx,%eax
8010432a:	5b                   	pop    %ebx
8010432b:	5d                   	pop    %ebp
8010432c:	c3                   	ret    
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 1c             	sub    $0x1c,%esp
	
  struct proc *p;
  struct cpu *c = mycpu();
80104339:	e8 f2 f3 ff ff       	call   80103730 <mycpu>
  c->proc = 0;
8010433e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104345:	00 00 00 
void
scheduler(void)
{
	
  struct proc *p;
  struct cpu *c = mycpu();
80104348:	89 c6                	mov    %eax,%esi
8010434a:	8d 40 04             	lea    0x4(%eax),%eax
8010434d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static inline void
sti(void)
{
  asm volatile("sti");
80104350:	fb                   	sti    
	{
	    // Enable interrupts on this processor.
	    sti();

	    // Loop over process table looking for process to run.
	    acquire(&ptable.lock);
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	bb 40 00 00 00       	mov    $0x40,%ebx
80104359:	68 40 40 11 80       	push   $0x80114040
8010435e:	e8 6d 06 00 00       	call   801049d0 <acquire>
80104363:	83 c4 10             	add    $0x10,%esp
80104366:	eb 0d                	jmp    80104375 <scheduler+0x45>
80104368:	90                   	nop
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	   
	    //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){   		// RR scheduling
	      
	    int i;
	    for(i=0;i<NPROC;i++)
80104370:	83 eb 01             	sub    $0x1,%ebx
80104373:	74 53                	je     801043c8 <scheduler+0x98>
	    {
			
			//if (min_heap[0].priority!=-1.0 && min_heap[0].p->state == RUNNABLE)
			if (min_heap[0].p && min_heap[0].p->state == RUNNABLE)
80104375:	a1 c8 b5 10 80       	mov    0x8010b5c8,%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 f2                	je     80104370 <scheduler+0x40>
8010437e:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104382:	75 ec                	jne    80104370 <scheduler+0x40>
			{
				p = pop();
80104384:	e8 37 ff ff ff       	call   801042c0 <pop>
	  
			// Switch to chosen process.  It is the process's job
			// to release ptable.lock and then reacquire it
			// before jumping back to us.
			c->proc = p;
			switchuvm(p);
80104389:	83 ec 0c             	sub    $0xc,%esp
	      		continue;
	  
			// Switch to chosen process.  It is the process's job
			// to release ptable.lock and then reacquire it
			// before jumping back to us.
			c->proc = p;
8010438c:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
	    {
			
			//if (min_heap[0].priority!=-1.0 && min_heap[0].p->state == RUNNABLE)
			if (min_heap[0].p && min_heap[0].p->state == RUNNABLE)
			{
				p = pop();
80104392:	89 c7                	mov    %eax,%edi
	  
			// Switch to chosen process.  It is the process's job
			// to release ptable.lock and then reacquire it
			// before jumping back to us.
			c->proc = p;
			switchuvm(p);
80104394:	50                   	push   %eax
80104395:	e8 06 2c 00 00       	call   80106fa0 <switchuvm>
			p->state = RUNNING;
8010439a:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)


			swtch(&(c->scheduler), p->context);
801043a1:	58                   	pop    %eax
801043a2:	5a                   	pop    %edx
801043a3:	ff 77 1c             	pushl  0x1c(%edi)
801043a6:	ff 75 e4             	pushl  -0x1c(%ebp)
801043a9:	e8 ed 09 00 00       	call   80104d9b <swtch>
			switchkvm();
801043ae:	e8 cd 2b 00 00       	call   80106f80 <switchkvm>
			// Process is done running for now.
			// It should have changed its p->state before coming back.
			c->proc = 0;
801043b3:	83 c4 10             	add    $0x10,%esp
	    acquire(&ptable.lock);
	   
	    //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){   		// RR scheduling
	      
	    int i;
	    for(i=0;i<NPROC;i++)
801043b6:	83 eb 01             	sub    $0x1,%ebx

			swtch(&(c->scheduler), p->context);
			switchkvm();
			// Process is done running for now.
			// It should have changed its p->state before coming back.
			c->proc = 0;
801043b9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801043c0:	00 00 00 
	    acquire(&ptable.lock);
	   
	    //for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){   		// RR scheduling
	      
	    int i;
	    for(i=0;i<NPROC;i++)
801043c3:	75 b0                	jne    80104375 <scheduler+0x45>
801043c5:	8d 76 00             	lea    0x0(%esi),%esi
			switchkvm();
			// Process is done running for now.
			// It should have changed its p->state before coming back.
			c->proc = 0;
    	}
    	release(&ptable.lock);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	68 40 40 11 80       	push   $0x80114040
801043d0:	e8 1b 07 00 00       	call   80104af0 <release>
  	}
801043d5:	83 c4 10             	add    $0x10,%esp
801043d8:	e9 73 ff ff ff       	jmp    80104350 <scheduler+0x20>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <show_heap>:
	return temp_p;

}

void show_heap()
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	be c8 b5 10 80       	mov    $0x8010b5c8,%esi
			cprintf("pos %d and min id = %d and name %s\n",i,min_heap[i].p->pid,min_heap[i].p->name);
			cprintf("priority: %d and p.priority: %d\n",(int)(min_heap[i].priority*10),(int)(min_heap[i].p->priority*10));	
		}
	}*/

	for(i=0;i<NPROC;i++)
801043ea:	31 db                	xor    %ebx,%ebx
	return temp_p;

}

void show_heap()
{
801043ec:	83 ec 1c             	sub    $0x1c,%esp
	cprintf("mpika show\n");
801043ef:	68 4d 7c 10 80       	push   $0x80107c4d
801043f4:	e8 67 c2 ff ff       	call   80100660 <cprintf>
801043f9:	83 c4 10             	add    $0x10,%esp
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		}
	}*/

	for(i=0;i<NPROC;i++)
	{
		if (min_heap[i].p)
80104400:	8b 06                	mov    (%esi),%eax
80104402:	85 c0                	test   %eax,%eax
80104404:	74 46                	je     8010444c <show_heap+0x6c>
		{
			cprintf("pos %d and min id = %d and name %s\n",i,min_heap[i].p->pid,min_heap[i].p->name);
80104406:	8d 50 6c             	lea    0x6c(%eax),%edx
80104409:	52                   	push   %edx
8010440a:	ff 70 10             	pushl  0x10(%eax)
8010440d:	53                   	push   %ebx
8010440e:	68 e4 7c 10 80       	push   $0x80107ce4
80104413:	e8 48 c2 ff ff       	call   80100660 <cprintf>
			cprintf("p.priority: %d\n",(int)(min_heap[i].p->priority*100));	
80104418:	58                   	pop    %eax
80104419:	8b 06                	mov    (%esi),%eax
8010441b:	d9 05 bc 7d 10 80    	flds   0x80107dbc
80104421:	5a                   	pop    %edx
80104422:	dc 48 7c             	fmull  0x7c(%eax)
80104425:	d9 7d f6             	fnstcw -0xa(%ebp)
80104428:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
8010442c:	b4 0c                	mov    $0xc,%ah
8010442e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80104432:	d9 6d f4             	fldcw  -0xc(%ebp)
80104435:	db 5d f0             	fistpl -0x10(%ebp)
80104438:	d9 6d f6             	fldcw  -0xa(%ebp)
8010443b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010443e:	50                   	push   %eax
8010443f:	68 59 7c 10 80       	push   $0x80107c59
80104444:	e8 17 c2 ff ff       	call   80100660 <cprintf>
80104449:	83 c4 10             	add    $0x10,%esp
			cprintf("pos %d and min id = %d and name %s\n",i,min_heap[i].p->pid,min_heap[i].p->name);
			cprintf("priority: %d and p.priority: %d\n",(int)(min_heap[i].priority*10),(int)(min_heap[i].p->priority*10));	
		}
	}*/

	for(i=0;i<NPROC;i++)
8010444c:	83 c3 01             	add    $0x1,%ebx
8010444f:	83 c6 0c             	add    $0xc,%esi
80104452:	83 fb 40             	cmp    $0x40,%ebx
80104455:	75 a9                	jne    80104400 <show_heap+0x20>
		{
			cprintf("pos %d and min id = %d and name %s\n",i,min_heap[i].p->pid,min_heap[i].p->name);
			cprintf("p.priority: %d\n",(int)(min_heap[i].p->priority*100));	
		}
	}
}
80104457:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445a:	5b                   	pop    %ebx
8010445b:	5e                   	pop    %esi
8010445c:	5d                   	pop    %ebp
8010445d:	c3                   	ret    
8010445e:	66 90                	xchg   %ax,%ax

80104460 <cps>:

////////////////////////////////////////////////////////////////////////////////////////////////////

int
cps()
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	83 ec 1c             	sub    $0x1c,%esp
80104468:	fb                   	sti    
  struct proc *p;
  int num=1;
  sti();

  acquire(&ptable.lock);
80104469:	68 40 40 11 80       	push   $0x80114040
8010446e:	bb e0 40 11 80       	mov    $0x801140e0,%ebx
80104473:	be e0 64 11 80       	mov    $0x801164e0,%esi
80104478:	e8 53 05 00 00       	call   801049d0 <acquire>
  cprintf("name \t pid \t state \t \tpriority \t \n");
8010447d:	c7 04 24 08 7d 10 80 	movl   $0x80107d08,(%esp)
80104484:	e8 d7 c1 ff ff       	call   80100660 <cprintf>
80104489:	83 c4 10             	add    $0x10,%esp

int
cps()
{
  struct proc *p;
  int num=1;
8010448c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104493:	eb 23                	jmp    801044b8 <cps+0x58>
80104495:	8d 76 00             	lea    0x0(%esi),%esi
		{	num=100;
    		cprintf("0.5<prior<=1\n");
    	}
    	cprintf("%s \t %d \t SLEEPING \t %d,%d,%d + %d \t\n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
    else if (p->state == RUNNING)
80104498:	83 f8 04             	cmp    $0x4,%eax
8010449b:	0f 84 df 00 00 00    	je     80104580 <cps+0x120>
		{	num=100;
    		cprintf("0.5<prior<=1\n");
    	}
    	cprintf("%s \t %d \t RUNNING \t %d,%d,%d + %d \t \n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
    else if (p->state == RUNNABLE)
801044a1:	83 f8 03             	cmp    $0x3,%eax
801044a4:	0f 84 5e 01 00 00    	je     80104608 <cps+0x1a8>
801044aa:	81 c3 90 00 00 00    	add    $0x90,%ebx
  int num=1;
  sti();

  acquire(&ptable.lock);
  cprintf("name \t pid \t state \t \tpriority \t \n");
  for (p=ptable.proc;p<&ptable.proc[NPROC];p++)
801044b0:	39 de                	cmp    %ebx,%esi
801044b2:	0f 84 95 00 00 00    	je     8010454d <cps+0xed>
  {
    
    if (p->state == SLEEPING)
801044b8:	8b 43 a0             	mov    -0x60(%ebx),%eax
801044bb:	83 f8 02             	cmp    $0x2,%eax
801044be:	75 d8                	jne    80104498 <cps+0x38>
    {
    	if (p->priority ==0)
801044c0:	dd 43 10             	fldl   0x10(%ebx)
801044c3:	d9 ee                	fldz   
801044c5:	d9 c9                	fxch   %st(1)
801044c7:	db e9                	fucomi %st(1),%st
801044c9:	dd d9                	fstp   %st(1)
801044cb:	7a 06                	jp     801044d3 <cps+0x73>
801044cd:	0f 84 bd 01 00 00    	je     80104690 <cps+0x230>
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
801044d3:	d9 ee                	fldz   
801044d5:	d9 c9                	fxch   %st(1)
801044d7:	db e9                	fucomi %st(1),%st
801044d9:	dd d9                	fstp   %st(1)
801044db:	76 0e                	jbe    801044eb <cps+0x8b>
801044dd:	d9 05 c0 7d 10 80    	flds   0x80107dc0
801044e3:	df e9                	fucomip %st(1),%st
801044e5:	0f 83 f5 01 00 00    	jae    801046e0 <cps+0x280>
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
801044eb:	d9 05 c0 7d 10 80    	flds   0x80107dc0
801044f1:	d9 c9                	fxch   %st(1)
801044f3:	db e9                	fucomi %st(1),%st
801044f5:	dd d9                	fstp   %st(1)
801044f7:	76 0a                	jbe    80104503 <cps+0xa3>
801044f9:	d9 e8                	fld1   
801044fb:	df e9                	fucomip %st(1),%st
801044fd:	0f 83 8d 02 00 00    	jae    80104790 <cps+0x330>
80104503:	db 45 ec             	fildl  -0x14(%ebp)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
    	}
    	cprintf("%s \t %d \t SLEEPING \t %d,%d,%d + %d \t\n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
80104506:	d9 7d f6             	fnstcw -0xa(%ebp)
80104509:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
8010450d:	de c9                	fmulp  %st,%st(1)
8010450f:	83 ec 04             	sub    $0x4,%esp
80104512:	b4 0c                	mov    $0xc,%ah
80104514:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80104518:	d9 6d f4             	fldcw  -0xc(%ebp)
8010451b:	db 5d f0             	fistpl -0x10(%ebp)
8010451e:	d9 6d f6             	fldcw  -0xa(%ebp)
80104521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104524:	50                   	push   %eax
80104525:	ff 73 20             	pushl  0x20(%ebx)
80104528:	ff 73 1c             	pushl  0x1c(%ebx)
8010452b:	ff 73 18             	pushl  0x18(%ebx)
8010452e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104531:	53                   	push   %ebx
80104532:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104538:	68 2c 7d 10 80       	push   $0x80107d2c
8010453d:	e8 1e c1 ff ff       	call   80100660 <cprintf>
80104542:	83 c4 20             	add    $0x20,%esp
  int num=1;
  sti();

  acquire(&ptable.lock);
  cprintf("name \t pid \t state \t \tpriority \t \n");
  for (p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104545:	39 de                	cmp    %ebx,%esi
80104547:	0f 85 6b ff ff ff    	jne    801044b8 <cps+0x58>
    		cprintf("0.5<prior<=1\n");
    	}
      	cprintf("%s \t %d \t RUNNABLE \t %d,%d,%d + %d \t \n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
  }
  cprintf("\n\n");
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	68 8e 7c 10 80       	push   $0x80107c8e
80104555:	e8 06 c1 ff ff       	call   80100660 <cprintf>
  show_heap();
8010455a:	e8 81 fe ff ff       	call   801043e0 <show_heap>

  release(&ptable.lock);
8010455f:	c7 04 24 40 40 11 80 	movl   $0x80114040,(%esp)
80104566:	e8 85 05 00 00       	call   80104af0 <release>
  
  return 22;
}
8010456b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456e:	b8 16 00 00 00       	mov    $0x16,%eax
80104573:	5b                   	pop    %ebx
80104574:	5e                   	pop    %esi
80104575:	5d                   	pop    %ebp
80104576:	c3                   	ret    
80104577:	89 f6                	mov    %esi,%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    	}
    	cprintf("%s \t %d \t SLEEPING \t %d,%d,%d + %d \t\n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
    else if (p->state == RUNNING)
    {
    	if (p->priority ==0)
80104580:	dd 43 10             	fldl   0x10(%ebx)
80104583:	d9 ee                	fldz   
80104585:	d9 c9                	fxch   %st(1)
80104587:	db e9                	fucomi %st(1),%st
80104589:	dd d9                	fstp   %st(1)
8010458b:	7a 06                	jp     80104593 <cps+0x133>
8010458d:	0f 84 25 01 00 00    	je     801046b8 <cps+0x258>
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
80104593:	d9 ee                	fldz   
80104595:	d9 c9                	fxch   %st(1)
80104597:	db e9                	fucomi %st(1),%st
80104599:	dd d9                	fstp   %st(1)
8010459b:	76 0e                	jbe    801045ab <cps+0x14b>
8010459d:	d9 05 c0 7d 10 80    	flds   0x80107dc0
801045a3:	df e9                	fucomip %st(1),%st
801045a5:	0f 83 8d 01 00 00    	jae    80104738 <cps+0x2d8>
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
801045ab:	d9 05 c0 7d 10 80    	flds   0x80107dc0
801045b1:	d9 c9                	fxch   %st(1)
801045b3:	db e9                	fucomi %st(1),%st
801045b5:	dd d9                	fstp   %st(1)
801045b7:	76 0a                	jbe    801045c3 <cps+0x163>
801045b9:	d9 e8                	fld1   
801045bb:	df e9                	fucomip %st(1),%st
801045bd:	0f 83 dc 01 00 00    	jae    8010479f <cps+0x33f>
801045c3:	db 45 ec             	fildl  -0x14(%ebp)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
    	}
    	cprintf("%s \t %d \t RUNNING \t %d,%d,%d + %d \t \n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
801045c6:	d9 7d f6             	fnstcw -0xa(%ebp)
801045c9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
801045cd:	de c9                	fmulp  %st,%st(1)
801045cf:	83 ec 04             	sub    $0x4,%esp
801045d2:	b4 0c                	mov    $0xc,%ah
801045d4:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
801045d8:	d9 6d f4             	fldcw  -0xc(%ebp)
801045db:	db 5d f0             	fistpl -0x10(%ebp)
801045de:	d9 6d f6             	fldcw  -0xa(%ebp)
801045e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045e4:	50                   	push   %eax
801045e5:	ff 73 20             	pushl  0x20(%ebx)
801045e8:	ff 73 1c             	pushl  0x1c(%ebx)
801045eb:	ff 73 18             	pushl  0x18(%ebx)
801045ee:	ff 73 a4             	pushl  -0x5c(%ebx)
801045f1:	53                   	push   %ebx
801045f2:	68 54 7d 10 80       	push   $0x80107d54
801045f7:	e8 64 c0 ff ff       	call   80100660 <cprintf>
801045fc:	83 c4 20             	add    $0x20,%esp
801045ff:	e9 a6 fe ff ff       	jmp    801044aa <cps+0x4a>
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    else if (p->state == RUNNABLE)
    {
    	if (p->priority ==0)
80104608:	dd 43 10             	fldl   0x10(%ebx)
8010460b:	d9 ee                	fldz   
8010460d:	d9 c9                	fxch   %st(1)
8010460f:	db e9                	fucomi %st(1),%st
80104611:	dd d9                	fstp   %st(1)
80104613:	7a 06                	jp     8010461b <cps+0x1bb>
80104615:	0f 84 f5 00 00 00    	je     80104710 <cps+0x2b0>
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
8010461b:	d9 ee                	fldz   
8010461d:	d9 c9                	fxch   %st(1)
8010461f:	db e9                	fucomi %st(1),%st
80104621:	dd d9                	fstp   %st(1)
80104623:	76 0e                	jbe    80104633 <cps+0x1d3>
80104625:	d9 05 c0 7d 10 80    	flds   0x80107dc0
8010462b:	df e9                	fucomip %st(1),%st
8010462d:	0f 83 2d 01 00 00    	jae    80104760 <cps+0x300>
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
80104633:	d9 05 c0 7d 10 80    	flds   0x80107dc0
80104639:	d9 c9                	fxch   %st(1)
8010463b:	db e9                	fucomi %st(1),%st
8010463d:	dd d9                	fstp   %st(1)
8010463f:	76 0a                	jbe    8010464b <cps+0x1eb>
80104641:	d9 e8                	fld1   
80104643:	df e9                	fucomip %st(1),%st
80104645:	0f 83 60 01 00 00    	jae    801047ab <cps+0x34b>
8010464b:	db 45 ec             	fildl  -0x14(%ebp)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
    	}
      	cprintf("%s \t %d \t RUNNABLE \t %d,%d,%d + %d \t \n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
8010464e:	d9 7d f6             	fnstcw -0xa(%ebp)
80104651:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80104655:	de c9                	fmulp  %st,%st(1)
80104657:	83 ec 04             	sub    $0x4,%esp
8010465a:	b4 0c                	mov    $0xc,%ah
8010465c:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80104660:	d9 6d f4             	fldcw  -0xc(%ebp)
80104663:	db 5d f0             	fistpl -0x10(%ebp)
80104666:	d9 6d f6             	fldcw  -0xa(%ebp)
80104669:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010466c:	50                   	push   %eax
8010466d:	ff 73 20             	pushl  0x20(%ebx)
80104670:	ff 73 1c             	pushl  0x1c(%ebx)
80104673:	ff 73 18             	pushl  0x18(%ebx)
80104676:	ff 73 a4             	pushl  -0x5c(%ebx)
80104679:	53                   	push   %ebx
8010467a:	68 7c 7d 10 80       	push   $0x80107d7c
8010467f:	e8 dc bf ff ff       	call   80100660 <cprintf>
80104684:	83 c4 20             	add    $0x20,%esp
80104687:	e9 1e fe ff ff       	jmp    801044aa <cps+0x4a>
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104690:	dd d8                	fstp   %st(0)
    
    if (p->state == SLEEPING)
    {
    	if (p->priority ==0)
    	{	num=1;
    		cprintf("prior=0\n");
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	68 69 7c 10 80       	push   $0x80107c69
8010469a:	e8 c1 bf ff ff       	call   80100660 <cprintf>
8010469f:	dd 43 10             	fldl   0x10(%ebx)
801046a2:	83 c4 10             	add    $0x10,%esp
  {
    
    if (p->state == SLEEPING)
    {
    	if (p->priority ==0)
    	{	num=1;
801046a5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
801046ac:	d9 e8                	fld1   
801046ae:	e9 53 fe ff ff       	jmp    80104506 <cps+0xa6>
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b8:	dd d8                	fstp   %st(0)
    }
    else if (p->state == RUNNING)
    {
    	if (p->priority ==0)
    	{	num=1;
    		cprintf("prior=0\n");
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	68 69 7c 10 80       	push   $0x80107c69
801046c2:	e8 99 bf ff ff       	call   80100660 <cprintf>
801046c7:	dd 43 10             	fldl   0x10(%ebx)
801046ca:	83 c4 10             	add    $0x10,%esp
    	cprintf("%s \t %d \t SLEEPING \t %d,%d,%d + %d \t\n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
    else if (p->state == RUNNING)
    {
    	if (p->priority ==0)
    	{	num=1;
801046cd:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
801046d4:	d9 e8                	fld1   
801046d6:	e9 eb fe ff ff       	jmp    801045c6 <cps+0x166>
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e0:	dd d8                	fstp   %st(0)
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
801046e2:	83 ec 0c             	sub    $0xc,%esp
801046e5:	68 72 7c 10 80       	push   $0x80107c72
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
801046ea:	e8 71 bf ff ff       	call   80100660 <cprintf>
801046ef:	dd 43 10             	fldl   0x10(%ebx)
801046f2:	83 c4 10             	add    $0x10,%esp
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
801046f5:	c7 45 ec 64 00 00 00 	movl   $0x64,-0x14(%ebp)
    		cprintf("0.5<prior<=1\n");
801046fc:	d9 05 bc 7d 10 80    	flds   0x80107dbc
80104702:	e9 ff fd ff ff       	jmp    80104506 <cps+0xa6>
80104707:	89 f6                	mov    %esi,%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104710:	dd d8                	fstp   %st(0)
    }
    else if (p->state == RUNNABLE)
    {
    	if (p->priority ==0)
    	{	num=1;
    		cprintf("prior=0\n");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 69 7c 10 80       	push   $0x80107c69
8010471a:	e8 41 bf ff ff       	call   80100660 <cprintf>
8010471f:	dd 43 10             	fldl   0x10(%ebx)
80104722:	83 c4 10             	add    $0x10,%esp
    	cprintf("%s \t %d \t RUNNING \t %d,%d,%d + %d \t \n",p->name,p->pid,p->creation_time,p->running_time,p->sleeping_counter,(int)(p->priority*num));
    }
    else if (p->state == RUNNABLE)
    {
    	if (p->priority ==0)
    	{	num=1;
80104725:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010472c:	d9 e8                	fld1   
8010472e:	e9 1b ff ff ff       	jmp    8010464e <cps+0x1ee>
80104733:	90                   	nop
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104738:	dd d8                	fstp   %st(0)
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	68 72 7c 10 80       	push   $0x80107c72
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
80104742:	e8 19 bf ff ff       	call   80100660 <cprintf>
80104747:	dd 43 10             	fldl   0x10(%ebx)
8010474a:	83 c4 10             	add    $0x10,%esp
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
8010474d:	c7 45 ec 64 00 00 00 	movl   $0x64,-0x14(%ebp)
    		cprintf("0.5<prior<=1\n");
80104754:	d9 05 bc 7d 10 80    	flds   0x80107dbc
8010475a:	e9 67 fe ff ff       	jmp    801045c6 <cps+0x166>
8010475f:	90                   	nop
80104760:	dd d8                	fstp   %st(0)
    	{	num=1;
    		cprintf("prior=0\n");
    	}
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
80104762:	83 ec 0c             	sub    $0xc,%esp
80104765:	68 72 7c 10 80       	push   $0x80107c72
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
8010476a:	e8 f1 be ff ff       	call   80100660 <cprintf>
8010476f:	dd 43 10             	fldl   0x10(%ebx)
80104772:	83 c4 10             	add    $0x10,%esp
    	else if (p->priority>0 && p->priority<=0.5)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
80104775:	c7 45 ec 64 00 00 00 	movl   $0x64,-0x14(%ebp)
    		cprintf("0.5<prior<=1\n");
8010477c:	d9 05 bc 7d 10 80    	flds   0x80107dbc
80104782:	e9 c7 fe ff ff       	jmp    8010464e <cps+0x1ee>
80104787:	89 f6                	mov    %esi,%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104790:	dd d8                	fstp   %st(0)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
80104792:	83 ec 0c             	sub    $0xc,%esp
80104795:	68 80 7c 10 80       	push   $0x80107c80
8010479a:	e9 4b ff ff ff       	jmp    801046ea <cps+0x28a>
8010479f:	dd d8                	fstp   %st(0)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
801047a1:	83 ec 0c             	sub    $0xc,%esp
801047a4:	68 80 7c 10 80       	push   $0x80107c80
801047a9:	eb 97                	jmp    80104742 <cps+0x2e2>
801047ab:	dd d8                	fstp   %st(0)
    	{	num=100;
    		cprintf("0<prior<=0.5\n");
    	}
    	else if (p->priority>0.5 && p->priority<=1)
		{	num=100;
    		cprintf("0.5<prior<=1\n");
801047ad:	83 ec 0c             	sub    $0xc,%esp
801047b0:	68 80 7c 10 80       	push   $0x80107c80
801047b5:	eb b3                	jmp    8010476a <cps+0x30a>
801047b7:	66 90                	xchg   %ax,%ax
801047b9:	66 90                	xchg   %ax,%ax
801047bb:	66 90                	xchg   %ax,%ax
801047bd:	66 90                	xchg   %ax,%ax
801047bf:	90                   	nop

801047c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ca:	68 c4 7d 10 80       	push   $0x80107dc4
801047cf:	8d 43 04             	lea    0x4(%ebx),%eax
801047d2:	50                   	push   %eax
801047d3:	e8 f8 00 00 00       	call   801048d0 <initlock>
  lk->name = name;
801047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801047e1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801047e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801047eb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801047ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f1:	c9                   	leave  
801047f2:	c3                   	ret    
801047f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8d 73 04             	lea    0x4(%ebx),%esi
8010480e:	56                   	push   %esi
8010480f:	e8 bc 01 00 00       	call   801049d0 <acquire>
  while (lk->locked) {
80104814:	8b 13                	mov    (%ebx),%edx
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 d2                	test   %edx,%edx
8010481b:	74 16                	je     80104833 <acquiresleep+0x33>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104820:	83 ec 08             	sub    $0x8,%esp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	e8 16 f1 ff ff       	call   80103940 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010482a:	8b 03                	mov    (%ebx),%eax
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 ed                	jne    80104820 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104833:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104839:	e8 92 ef ff ff       	call   801037d0 <myproc>
8010483e:	8b 40 10             	mov    0x10(%eax),%eax
80104841:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104844:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010484d:	e9 9e 02 00 00       	jmp    80104af0 <release>
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	8d 73 04             	lea    0x4(%ebx),%esi
8010486e:	56                   	push   %esi
8010486f:	e8 5c 01 00 00       	call   801049d0 <acquire>
  lk->locked = 0;
80104874:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010487a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104881:	89 1c 24             	mov    %ebx,(%esp)
80104884:	e8 f7 f8 ff ff       	call   80104180 <wakeup>
  release(&lk->lk);
80104889:	89 75 08             	mov    %esi,0x8(%ebp)
8010488c:	83 c4 10             	add    $0x10,%esp
}
8010488f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104895:	e9 56 02 00 00       	jmp    80104af0 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	8d 5e 04             	lea    0x4(%esi),%ebx
801048ae:	53                   	push   %ebx
801048af:	e8 1c 01 00 00       	call   801049d0 <acquire>
  r = lk->locked;
801048b4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801048b6:	89 1c 24             	mov    %ebx,(%esp)
801048b9:	e8 32 02 00 00       	call   80104af0 <release>
  return r;
}
801048be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048c1:	89 f0                	mov    %esi,%eax
801048c3:	5b                   	pop    %ebx
801048c4:	5e                   	pop    %esi
801048c5:	5d                   	pop    %ebp
801048c6:	c3                   	ret    
801048c7:	66 90                	xchg   %ax,%ax
801048c9:	66 90                	xchg   %ax,%ax
801048cb:	66 90                	xchg   %ax,%ax
801048cd:	66 90                	xchg   %ax,%ax
801048cf:	90                   	nop

801048d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801048d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801048d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801048df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801048e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801048e9:	5d                   	pop    %ebp
801048ea:	c3                   	ret    
801048eb:	90                   	nop
801048ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801048f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048fa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801048fd:	31 c0                	xor    %eax,%eax
801048ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104900:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104906:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010490c:	77 1a                	ja     80104928 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010490e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104911:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104914:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104917:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104919:	83 f8 0a             	cmp    $0xa,%eax
8010491c:	75 e2                	jne    80104900 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010491e:	5b                   	pop    %ebx
8010491f:	5d                   	pop    %ebp
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104928:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010492f:	83 c0 01             	add    $0x1,%eax
80104932:	83 f8 0a             	cmp    $0xa,%eax
80104935:	74 e7                	je     8010491e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104937:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010493e:	83 c0 01             	add    $0x1,%eax
80104941:	83 f8 0a             	cmp    $0xa,%eax
80104944:	75 e2                	jne    80104928 <getcallerpcs+0x38>
80104946:	eb d6                	jmp    8010491e <getcallerpcs+0x2e>
80104948:	90                   	nop
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104950 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010495a:	8b 02                	mov    (%edx),%eax
8010495c:	85 c0                	test   %eax,%eax
8010495e:	75 10                	jne    80104970 <holding+0x20>
}
80104960:	83 c4 04             	add    $0x4,%esp
80104963:	31 c0                	xor    %eax,%eax
80104965:	5b                   	pop    %ebx
80104966:	5d                   	pop    %ebp
80104967:	c3                   	ret    
80104968:	90                   	nop
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104970:	8b 5a 08             	mov    0x8(%edx),%ebx
80104973:	e8 b8 ed ff ff       	call   80103730 <mycpu>
80104978:	39 c3                	cmp    %eax,%ebx
8010497a:	0f 94 c0             	sete   %al
}
8010497d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104980:	0f b6 c0             	movzbl %al,%eax
}
80104983:	5b                   	pop    %ebx
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	8d 76 00             	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104997:	9c                   	pushf  
80104998:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104999:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010499a:	e8 91 ed ff ff       	call   80103730 <mycpu>
8010499f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049a5:	85 c0                	test   %eax,%eax
801049a7:	75 11                	jne    801049ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801049a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049af:	e8 7c ed ff ff       	call   80103730 <mycpu>
801049b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049ba:	e8 71 ed ff ff       	call   80103730 <mycpu>
801049bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049c6:	83 c4 04             	add    $0x4,%esp
801049c9:	5b                   	pop    %ebx
801049ca:	5d                   	pop    %ebp
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049d0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801049d5:	e8 b6 ff ff ff       	call   80104990 <pushcli>
  if(holding(lk))
801049da:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049dd:	8b 03                	mov    (%ebx),%eax
801049df:	85 c0                	test   %eax,%eax
801049e1:	75 7d                	jne    80104a60 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801049e3:	ba 01 00 00 00       	mov    $0x1,%edx
801049e8:	eb 09                	jmp    801049f3 <acquire+0x23>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049f3:	89 d0                	mov    %edx,%eax
801049f5:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801049f8:	85 c0                	test   %eax,%eax
801049fa:	75 f4                	jne    801049f0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801049fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a04:	e8 27 ed ff ff       	call   80103730 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a09:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a0b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a0e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a11:	31 c0                	xor    %eax,%eax
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a18:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a1e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a24:	77 1a                	ja     80104a40 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a26:	8b 5a 04             	mov    0x4(%edx),%ebx
80104a29:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a2c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104a2f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a31:	83 f8 0a             	cmp    $0xa,%eax
80104a34:	75 e2                	jne    80104a18 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a39:	5b                   	pop    %ebx
80104a3a:	5e                   	pop    %esi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104a40:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a47:	83 c0 01             	add    $0x1,%eax
80104a4a:	83 f8 0a             	cmp    $0xa,%eax
80104a4d:	74 e7                	je     80104a36 <acquire+0x66>
    pcs[i] = 0;
80104a4f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104a56:	83 c0 01             	add    $0x1,%eax
80104a59:	83 f8 0a             	cmp    $0xa,%eax
80104a5c:	75 e2                	jne    80104a40 <acquire+0x70>
80104a5e:	eb d6                	jmp    80104a36 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104a60:	8b 73 08             	mov    0x8(%ebx),%esi
80104a63:	e8 c8 ec ff ff       	call   80103730 <mycpu>
80104a68:	39 c6                	cmp    %eax,%esi
80104a6a:	0f 85 73 ff ff ff    	jne    801049e3 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	68 cf 7d 10 80       	push   $0x80107dcf
80104a78:	e8 f3 b8 ff ff       	call   80100370 <panic>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi

80104a80 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a86:	9c                   	pushf  
80104a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a88:	f6 c4 02             	test   $0x2,%ah
80104a8b:	75 52                	jne    80104adf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a8d:	e8 9e ec ff ff       	call   80103730 <mycpu>
80104a92:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104a98:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104a9b:	85 d2                	test   %edx,%edx
80104a9d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104aa3:	78 2d                	js     80104ad2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104aa5:	e8 86 ec ff ff       	call   80103730 <mycpu>
80104aaa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ab0:	85 d2                	test   %edx,%edx
80104ab2:	74 0c                	je     80104ac0 <popcli+0x40>
    sti();
}
80104ab4:	c9                   	leave  
80104ab5:	c3                   	ret    
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ac0:	e8 6b ec ff ff       	call   80103730 <mycpu>
80104ac5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104acb:	85 c0                	test   %eax,%eax
80104acd:	74 e5                	je     80104ab4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104acf:	fb                   	sti    
    sti();
}
80104ad0:	c9                   	leave  
80104ad1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104ad2:	83 ec 0c             	sub    $0xc,%esp
80104ad5:	68 ee 7d 10 80       	push   $0x80107dee
80104ada:	e8 91 b8 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104adf:	83 ec 0c             	sub    $0xc,%esp
80104ae2:	68 d7 7d 10 80       	push   $0x80107dd7
80104ae7:	e8 84 b8 ff ff       	call   80100370 <panic>
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104af8:	8b 03                	mov    (%ebx),%eax
80104afa:	85 c0                	test   %eax,%eax
80104afc:	75 12                	jne    80104b10 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104afe:	83 ec 0c             	sub    $0xc,%esp
80104b01:	68 f5 7d 10 80       	push   $0x80107df5
80104b06:	e8 65 b8 ff ff       	call   80100370 <panic>
80104b0b:	90                   	nop
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b10:	8b 73 08             	mov    0x8(%ebx),%esi
80104b13:	e8 18 ec ff ff       	call   80103730 <mycpu>
80104b18:	39 c6                	cmp    %eax,%esi
80104b1a:	75 e2                	jne    80104afe <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104b1c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b23:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104b2a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b2f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b38:	5b                   	pop    %ebx
80104b39:	5e                   	pop    %esi
80104b3a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104b3b:	e9 40 ff ff ff       	jmp    80104a80 <popcli>

80104b40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	53                   	push   %ebx
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
80104b48:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b4b:	f6 c2 03             	test   $0x3,%dl
80104b4e:	75 05                	jne    80104b55 <memset+0x15>
80104b50:	f6 c1 03             	test   $0x3,%cl
80104b53:	74 13                	je     80104b68 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104b55:	89 d7                	mov    %edx,%edi
80104b57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5a:	fc                   	cld    
80104b5b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b5d:	5b                   	pop    %ebx
80104b5e:	89 d0                	mov    %edx,%eax
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104b68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104b6c:	c1 e9 02             	shr    $0x2,%ecx
80104b6f:	89 fb                	mov    %edi,%ebx
80104b71:	89 f8                	mov    %edi,%eax
80104b73:	c1 e3 18             	shl    $0x18,%ebx
80104b76:	c1 e0 10             	shl    $0x10,%eax
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b87:	5b                   	pop    %ebx
80104b88:	89 d0                	mov    %edx,%eax
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 45 10             	mov    0x10(%ebp),%eax
80104b98:	53                   	push   %ebx
80104b99:	8b 75 0c             	mov    0xc(%ebp),%esi
80104b9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104b9f:	85 c0                	test   %eax,%eax
80104ba1:	74 29                	je     80104bcc <memcmp+0x3c>
    if(*s1 != *s2)
80104ba3:	0f b6 13             	movzbl (%ebx),%edx
80104ba6:	0f b6 0e             	movzbl (%esi),%ecx
80104ba9:	38 d1                	cmp    %dl,%cl
80104bab:	75 2b                	jne    80104bd8 <memcmp+0x48>
80104bad:	8d 78 ff             	lea    -0x1(%eax),%edi
80104bb0:	31 c0                	xor    %eax,%eax
80104bb2:	eb 14                	jmp    80104bc8 <memcmp+0x38>
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104bbd:	83 c0 01             	add    $0x1,%eax
80104bc0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104bc4:	38 ca                	cmp    %cl,%dl
80104bc6:	75 10                	jne    80104bd8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bc8:	39 f8                	cmp    %edi,%eax
80104bca:	75 ec                	jne    80104bb8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bcc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104bcd:	31 c0                	xor    %eax,%eax
}
80104bcf:	5e                   	pop    %esi
80104bd0:	5f                   	pop    %edi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bd8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104bdb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104bdc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104bde:	5e                   	pop    %esi
80104bdf:	5f                   	pop    %edi
80104be0:	5d                   	pop    %ebp
80104be1:	c3                   	ret    
80104be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104bfe:	39 c6                	cmp    %eax,%esi
80104c00:	73 2e                	jae    80104c30 <memmove+0x40>
80104c02:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104c05:	39 c8                	cmp    %ecx,%eax
80104c07:	73 27                	jae    80104c30 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104c09:	85 db                	test   %ebx,%ebx
80104c0b:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104c0e:	74 17                	je     80104c27 <memmove+0x37>
      *--d = *--s;
80104c10:	29 d9                	sub    %ebx,%ecx
80104c12:	89 cb                	mov    %ecx,%ebx
80104c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c18:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c1c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104c1f:	83 ea 01             	sub    $0x1,%edx
80104c22:	83 fa ff             	cmp    $0xffffffff,%edx
80104c25:	75 f1                	jne    80104c18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	5e                   	pop    %esi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c30:	31 d2                	xor    %edx,%edx
80104c32:	85 db                	test   %ebx,%ebx
80104c34:	74 f1                	je     80104c27 <memmove+0x37>
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104c40:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104c44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c47:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104c4a:	39 d3                	cmp    %edx,%ebx
80104c4c:	75 f2                	jne    80104c40 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret    
80104c52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c63:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104c64:	eb 8a                	jmp    80104bf0 <memmove>
80104c66:	8d 76 00             	lea    0x0(%esi),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c78:	53                   	push   %ebx
80104c79:	8b 7d 08             	mov    0x8(%ebp),%edi
80104c7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c7f:	85 c9                	test   %ecx,%ecx
80104c81:	74 37                	je     80104cba <strncmp+0x4a>
80104c83:	0f b6 17             	movzbl (%edi),%edx
80104c86:	0f b6 1e             	movzbl (%esi),%ebx
80104c89:	84 d2                	test   %dl,%dl
80104c8b:	74 3f                	je     80104ccc <strncmp+0x5c>
80104c8d:	38 d3                	cmp    %dl,%bl
80104c8f:	75 3b                	jne    80104ccc <strncmp+0x5c>
80104c91:	8d 47 01             	lea    0x1(%edi),%eax
80104c94:	01 cf                	add    %ecx,%edi
80104c96:	eb 1b                	jmp    80104cb3 <strncmp+0x43>
80104c98:	90                   	nop
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ca0:	0f b6 10             	movzbl (%eax),%edx
80104ca3:	84 d2                	test   %dl,%dl
80104ca5:	74 21                	je     80104cc8 <strncmp+0x58>
80104ca7:	0f b6 19             	movzbl (%ecx),%ebx
80104caa:	83 c0 01             	add    $0x1,%eax
80104cad:	89 ce                	mov    %ecx,%esi
80104caf:	38 da                	cmp    %bl,%dl
80104cb1:	75 19                	jne    80104ccc <strncmp+0x5c>
80104cb3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104cb5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104cb8:	75 e6                	jne    80104ca0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cba:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104cbb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104cbd:	5e                   	pop    %esi
80104cbe:	5f                   	pop    %edi
80104cbf:	5d                   	pop    %ebp
80104cc0:	c3                   	ret    
80104cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ccc:	0f b6 c2             	movzbl %dl,%eax
80104ccf:	29 d8                	sub    %ebx,%eax
}
80104cd1:	5b                   	pop    %ebx
80104cd2:	5e                   	pop    %esi
80104cd3:	5f                   	pop    %edi
80104cd4:	5d                   	pop    %ebp
80104cd5:	c3                   	ret    
80104cd6:	8d 76 00             	lea    0x0(%esi),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cee:	89 c2                	mov    %eax,%edx
80104cf0:	eb 19                	jmp    80104d0b <strncpy+0x2b>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cff:	83 c2 01             	add    $0x1,%edx
80104d02:	84 c9                	test   %cl,%cl
80104d04:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d07:	74 09                	je     80104d12 <strncpy+0x32>
80104d09:	89 f1                	mov    %esi,%ecx
80104d0b:	85 c9                	test   %ecx,%ecx
80104d0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d10:	7f e6                	jg     80104cf8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d12:	31 c9                	xor    %ecx,%ecx
80104d14:	85 f6                	test   %esi,%esi
80104d16:	7e 17                	jle    80104d2f <strncpy+0x4f>
80104d18:	90                   	nop
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d24:	89 f3                	mov    %esi,%ebx
80104d26:	83 c1 01             	add    $0x1,%ecx
80104d29:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104d2b:	85 db                	test   %ebx,%ebx
80104d2d:	7f f1                	jg     80104d20 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104d2f:	5b                   	pop    %ebx
80104d30:	5e                   	pop    %esi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d48:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d4e:	85 c9                	test   %ecx,%ecx
80104d50:	7e 26                	jle    80104d78 <safestrcpy+0x38>
80104d52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d56:	89 c1                	mov    %eax,%ecx
80104d58:	eb 17                	jmp    80104d71 <safestrcpy+0x31>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d60:	83 c2 01             	add    $0x1,%edx
80104d63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d67:	83 c1 01             	add    $0x1,%ecx
80104d6a:	84 db                	test   %bl,%bl
80104d6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d6f:	74 04                	je     80104d75 <safestrcpy+0x35>
80104d71:	39 f2                	cmp    %esi,%edx
80104d73:	75 eb                	jne    80104d60 <safestrcpy+0x20>
    ;
  *s = 0;
80104d75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d78:	5b                   	pop    %ebx
80104d79:	5e                   	pop    %esi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d80 <strlen>:

int
strlen(const char *s)
{
80104d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d81:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104d88:	80 3a 00             	cmpb   $0x0,(%edx)
80104d8b:	74 0c                	je     80104d99 <strlen+0x19>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d97:	75 f7                	jne    80104d90 <strlen+0x10>
    ;
  return n;
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    

80104d9b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104da3:	55                   	push   %ebp
  pushl %ebx
80104da4:	53                   	push   %ebx
  pushl %esi
80104da5:	56                   	push   %esi
  pushl %edi
80104da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104da9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104dab:	5f                   	pop    %edi
  popl %esi
80104dac:	5e                   	pop    %esi
  popl %ebx
80104dad:	5b                   	pop    %ebx
  popl %ebp
80104dae:	5d                   	pop    %ebp
  ret
80104daf:	c3                   	ret    

80104db0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dba:	e8 11 ea ff ff       	call   801037d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbf:	8b 00                	mov    (%eax),%eax
80104dc1:	39 d8                	cmp    %ebx,%eax
80104dc3:	76 1b                	jbe    80104de0 <fetchint+0x30>
80104dc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dc8:	39 d0                	cmp    %edx,%eax
80104dca:	72 14                	jb     80104de0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 13                	mov    (%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	83 c4 04             	add    $0x4,%esp
80104dd8:	5b                   	pop    %ebx
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	90                   	nop
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <fetchint+0x25>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dfa:	e8 d1 e9 ff ff       	call   801037d0 <myproc>

  if(addr >= curproc->sz)
80104dff:	39 18                	cmp    %ebx,(%eax)
80104e01:	76 29                	jbe    80104e2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e06:	89 da                	mov    %ebx,%edx
80104e08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e0c:	39 c3                	cmp    %eax,%ebx
80104e0e:	73 1c                	jae    80104e2c <fetchstr+0x3c>
    if(*s == 0)
80104e10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e13:	75 10                	jne    80104e25 <fetchstr+0x35>
80104e15:	eb 29                	jmp    80104e40 <fetchstr+0x50>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	80 3a 00             	cmpb   $0x0,(%edx)
80104e23:	74 1b                	je     80104e40 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104e25:	83 c2 01             	add    $0x1,%edx
80104e28:	39 d0                	cmp    %edx,%eax
80104e2a:	77 f4                	ja     80104e20 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e2c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104e34:	5b                   	pop    %ebx
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e40:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104e43:	89 d0                	mov    %edx,%eax
80104e45:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104e47:	5b                   	pop    %ebx
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e55:	e8 76 e9 ff ff       	call   801037d0 <myproc>
80104e5a:	8b 40 18             	mov    0x18(%eax),%eax
80104e5d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e60:	8b 40 44             	mov    0x44(%eax),%eax
80104e63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104e66:	e8 65 e9 ff ff       	call   801037d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e6b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e6d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e70:	39 c6                	cmp    %eax,%esi
80104e72:	73 1c                	jae    80104e90 <argint+0x40>
80104e74:	8d 53 08             	lea    0x8(%ebx),%edx
80104e77:	39 d0                	cmp    %edx,%eax
80104e79:	72 15                	jb     80104e90 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e7e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e81:	89 10                	mov    %edx,(%eax)
  return 0;
80104e83:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104e85:	5b                   	pop    %ebx
80104e86:	5e                   	pop    %esi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104e90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e95:	eb ee                	jmp    80104e85 <argint+0x35>
80104e97:	89 f6                	mov    %esi,%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	83 ec 10             	sub    $0x10,%esp
80104ea8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eab:	e8 20 e9 ff ff       	call   801037d0 <myproc>
80104eb0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104eb2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eb5:	83 ec 08             	sub    $0x8,%esp
80104eb8:	50                   	push   %eax
80104eb9:	ff 75 08             	pushl  0x8(%ebp)
80104ebc:	e8 8f ff ff ff       	call   80104e50 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ec1:	c1 e8 1f             	shr    $0x1f,%eax
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	84 c0                	test   %al,%al
80104ec9:	75 2d                	jne    80104ef8 <argptr+0x58>
80104ecb:	89 d8                	mov    %ebx,%eax
80104ecd:	c1 e8 1f             	shr    $0x1f,%eax
80104ed0:	84 c0                	test   %al,%al
80104ed2:	75 24                	jne    80104ef8 <argptr+0x58>
80104ed4:	8b 16                	mov    (%esi),%edx
80104ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed9:	39 c2                	cmp    %eax,%edx
80104edb:	76 1b                	jbe    80104ef8 <argptr+0x58>
80104edd:	01 c3                	add    %eax,%ebx
80104edf:	39 da                	cmp    %ebx,%edx
80104ee1:	72 15                	jb     80104ef8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104ee3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ee6:	89 02                	mov    %eax,(%edx)
  return 0;
80104ee8:	31 c0                	xor    %eax,%eax
}
80104eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eed:	5b                   	pop    %ebx
80104eee:	5e                   	pop    %esi
80104eef:	5d                   	pop    %ebp
80104ef0:	c3                   	ret    
80104ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb eb                	jmp    80104eea <argptr+0x4a>
80104eff:	90                   	nop

80104f00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f09:	50                   	push   %eax
80104f0a:	ff 75 08             	pushl  0x8(%ebp)
80104f0d:	e8 3e ff ff ff       	call   80104e50 <argint>
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 17                	js     80104f30 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f19:	83 ec 08             	sub    $0x8,%esp
80104f1c:	ff 75 0c             	pushl  0xc(%ebp)
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 c9 fe ff ff       	call   80104df0 <fetchstr>
80104f27:	83 c4 10             	add    $0x10,%esp
}
80104f2a:	c9                   	leave  
80104f2b:	c3                   	ret    
80104f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104f35:	c9                   	leave  
80104f36:	c3                   	ret    
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <syscall>:
[SYS_cps]     sys_cps,
};

void
syscall(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104f45:	e8 86 e8 ff ff       	call   801037d0 <myproc>

  num = curproc->tf->eax;
80104f4a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104f4d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f4f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f52:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f55:	83 fa 15             	cmp    $0x15,%edx
80104f58:	77 1e                	ja     80104f78 <syscall+0x38>
80104f5a:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104f61:	85 d2                	test   %edx,%edx
80104f63:	74 13                	je     80104f78 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f65:	ff d2                	call   *%edx
80104f67:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6d:	5b                   	pop    %ebx
80104f6e:	5e                   	pop    %esi
80104f6f:	5d                   	pop    %ebp
80104f70:	c3                   	ret    
80104f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f78:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f79:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104f7c:	50                   	push   %eax
80104f7d:	ff 73 10             	pushl  0x10(%ebx)
80104f80:	68 fd 7d 10 80       	push   $0x80107dfd
80104f85:	e8 d6 b6 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104f8a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f9a:	5b                   	pop    %ebx
80104f9b:	5e                   	pop    %esi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fa6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fa9:	83 ec 44             	sub    $0x44,%esp
80104fac:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104faf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fb2:	56                   	push   %esi
80104fb3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fb4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104fb7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fba:	e8 21 cf ff ff       	call   80101ee0 <nameiparent>
80104fbf:	83 c4 10             	add    $0x10,%esp
80104fc2:	85 c0                	test   %eax,%eax
80104fc4:	0f 84 f6 00 00 00    	je     801050c0 <create+0x120>
    return 0;
  ilock(dp);
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	89 c7                	mov    %eax,%edi
80104fcf:	50                   	push   %eax
80104fd0:	e8 9b c6 ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104fd5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104fd8:	83 c4 0c             	add    $0xc,%esp
80104fdb:	50                   	push   %eax
80104fdc:	56                   	push   %esi
80104fdd:	57                   	push   %edi
80104fde:	e8 bd cb ff ff       	call   80101ba0 <dirlookup>
80104fe3:	83 c4 10             	add    $0x10,%esp
80104fe6:	85 c0                	test   %eax,%eax
80104fe8:	89 c3                	mov    %eax,%ebx
80104fea:	74 54                	je     80105040 <create+0xa0>
    iunlockput(dp);
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	57                   	push   %edi
80104ff0:	e8 0b c9 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104ff5:	89 1c 24             	mov    %ebx,(%esp)
80104ff8:	e8 73 c6 ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105005:	75 19                	jne    80105020 <create+0x80>
80105007:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010500c:	89 d8                	mov    %ebx,%eax
8010500e:	75 10                	jne    80105020 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105013:	5b                   	pop    %ebx
80105014:	5e                   	pop    %esi
80105015:	5f                   	pop    %edi
80105016:	5d                   	pop    %ebp
80105017:	c3                   	ret    
80105018:	90                   	nop
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	53                   	push   %ebx
80105024:	e8 d7 c8 ff ff       	call   80101900 <iunlockput>
    return 0;
80105029:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010502c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010502f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5f                   	pop    %edi
80105034:	5d                   	pop    %ebp
80105035:	c3                   	ret    
80105036:	8d 76 00             	lea    0x0(%esi),%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105040:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105044:	83 ec 08             	sub    $0x8,%esp
80105047:	50                   	push   %eax
80105048:	ff 37                	pushl  (%edi)
8010504a:	e8 b1 c4 ff ff       	call   80101500 <ialloc>
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	85 c0                	test   %eax,%eax
80105054:	89 c3                	mov    %eax,%ebx
80105056:	0f 84 cc 00 00 00    	je     80105128 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010505c:	83 ec 0c             	sub    $0xc,%esp
8010505f:	50                   	push   %eax
80105060:	e8 0b c6 ff ff       	call   80101670 <ilock>
  ip->major = major;
80105065:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105069:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010506d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105071:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105075:	b8 01 00 00 00       	mov    $0x1,%eax
8010507a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010507e:	89 1c 24             	mov    %ebx,(%esp)
80105081:	e8 3a c5 ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105086:	83 c4 10             	add    $0x10,%esp
80105089:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010508e:	74 40                	je     801050d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105090:	83 ec 04             	sub    $0x4,%esp
80105093:	ff 73 04             	pushl  0x4(%ebx)
80105096:	56                   	push   %esi
80105097:	57                   	push   %edi
80105098:	e8 63 cd ff ff       	call   80101e00 <dirlink>
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 77                	js     8010511b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	57                   	push   %edi
801050a8:	e8 53 c8 ff ff       	call   80101900 <iunlockput>

  return ip;
801050ad:	83 c4 10             	add    $0x10,%esp
}
801050b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801050b3:	89 d8                	mov    %ebx,%eax
}
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5f                   	pop    %edi
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801050c0:	31 c0                	xor    %eax,%eax
801050c2:	e9 49 ff ff ff       	jmp    80105010 <create+0x70>
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801050d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801050d5:	83 ec 0c             	sub    $0xc,%esp
801050d8:	57                   	push   %edi
801050d9:	e8 e2 c4 ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050de:	83 c4 0c             	add    $0xc,%esp
801050e1:	ff 73 04             	pushl  0x4(%ebx)
801050e4:	68 98 7e 10 80       	push   $0x80107e98
801050e9:	53                   	push   %ebx
801050ea:	e8 11 cd ff ff       	call   80101e00 <dirlink>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	85 c0                	test   %eax,%eax
801050f4:	78 18                	js     8010510e <create+0x16e>
801050f6:	83 ec 04             	sub    $0x4,%esp
801050f9:	ff 77 04             	pushl  0x4(%edi)
801050fc:	68 97 7e 10 80       	push   $0x80107e97
80105101:	53                   	push   %ebx
80105102:	e8 f9 cc ff ff       	call   80101e00 <dirlink>
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	85 c0                	test   %eax,%eax
8010510c:	79 82                	jns    80105090 <create+0xf0>
      panic("create dots");
8010510e:	83 ec 0c             	sub    $0xc,%esp
80105111:	68 8b 7e 10 80       	push   $0x80107e8b
80105116:	e8 55 b2 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010511b:	83 ec 0c             	sub    $0xc,%esp
8010511e:	68 9a 7e 10 80       	push   $0x80107e9a
80105123:	e8 48 b2 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105128:	83 ec 0c             	sub    $0xc,%esp
8010512b:	68 7c 7e 10 80       	push   $0x80107e7c
80105130:	e8 3b b2 ff ff       	call   80100370 <panic>
80105135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
80105145:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105147:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010514a:	89 d3                	mov    %edx,%ebx
8010514c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010514f:	50                   	push   %eax
80105150:	6a 00                	push   $0x0
80105152:	e8 f9 fc ff ff       	call   80104e50 <argint>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	85 c0                	test   %eax,%eax
8010515c:	78 32                	js     80105190 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105162:	77 2c                	ja     80105190 <argfd.constprop.0+0x50>
80105164:	e8 67 e6 ff ff       	call   801037d0 <myproc>
80105169:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010516c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105170:	85 c0                	test   %eax,%eax
80105172:	74 1c                	je     80105190 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105174:	85 f6                	test   %esi,%esi
80105176:	74 02                	je     8010517a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105178:	89 16                	mov    %edx,(%esi)
  if(pf)
8010517a:	85 db                	test   %ebx,%ebx
8010517c:	74 22                	je     801051a0 <argfd.constprop.0+0x60>
    *pf = f;
8010517e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105180:	31 c0                	xor    %eax,%eax
}
80105182:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105185:	5b                   	pop    %ebx
80105186:	5e                   	pop    %esi
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105190:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105193:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105198:	5b                   	pop    %ebx
80105199:	5e                   	pop    %esi
8010519a:	5d                   	pop    %ebp
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801051a0:	31 c0                	xor    %eax,%eax
801051a2:	eb de                	jmp    80105182 <argfd.constprop.0+0x42>
801051a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801051b0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801051b0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051b1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	56                   	push   %esi
801051b6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801051ba:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801051bd:	e8 7e ff ff ff       	call   80105140 <argfd.constprop.0>
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 1a                	js     801051e0 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051c6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801051c8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801051cb:	e8 00 e6 ff ff       	call   801037d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801051d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d4:	85 d2                	test   %edx,%edx
801051d6:	74 18                	je     801051f0 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801051d8:	83 c3 01             	add    $0x1,%ebx
801051db:	83 fb 10             	cmp    $0x10,%ebx
801051de:	75 f0                	jne    801051d0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
801051e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
801051e8:	5b                   	pop    %ebx
801051e9:	5e                   	pop    %esi
801051ea:	5d                   	pop    %ebp
801051eb:	c3                   	ret    
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801051f0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	ff 75 f4             	pushl  -0xc(%ebp)
801051fa:	e8 e1 bb ff ff       	call   80100de0 <filedup>
  return fd;
801051ff:	83 c4 10             	add    $0x10,%esp
}
80105202:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105205:	89 d8                	mov    %ebx,%eax
}
80105207:	5b                   	pop    %ebx
80105208:	5e                   	pop    %esi
80105209:	5d                   	pop    %ebp
8010520a:	c3                   	ret    
8010520b:	90                   	nop
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_read>:

int
sys_read(void)
{
80105210:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105211:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105213:	89 e5                	mov    %esp,%ebp
80105215:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105218:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010521b:	e8 20 ff ff ff       	call   80105140 <argfd.constprop.0>
80105220:	85 c0                	test   %eax,%eax
80105222:	78 4c                	js     80105270 <sys_read+0x60>
80105224:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	50                   	push   %eax
8010522b:	6a 02                	push   $0x2
8010522d:	e8 1e fc ff ff       	call   80104e50 <argint>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	85 c0                	test   %eax,%eax
80105237:	78 37                	js     80105270 <sys_read+0x60>
80105239:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523c:	83 ec 04             	sub    $0x4,%esp
8010523f:	ff 75 f0             	pushl  -0x10(%ebp)
80105242:	50                   	push   %eax
80105243:	6a 01                	push   $0x1
80105245:	e8 56 fc ff ff       	call   80104ea0 <argptr>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	78 1f                	js     80105270 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105251:	83 ec 04             	sub    $0x4,%esp
80105254:	ff 75 f0             	pushl  -0x10(%ebp)
80105257:	ff 75 f4             	pushl  -0xc(%ebp)
8010525a:	ff 75 ec             	pushl  -0x14(%ebp)
8010525d:	e8 ee bc ff ff       	call   80100f50 <fileread>
80105262:	83 c4 10             	add    $0x10,%esp
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_write>:

int
sys_write(void)
{
80105280:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105281:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105283:	89 e5                	mov    %esp,%ebp
80105285:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105288:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010528b:	e8 b0 fe ff ff       	call   80105140 <argfd.constprop.0>
80105290:	85 c0                	test   %eax,%eax
80105292:	78 4c                	js     801052e0 <sys_write+0x60>
80105294:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	50                   	push   %eax
8010529b:	6a 02                	push   $0x2
8010529d:	e8 ae fb ff ff       	call   80104e50 <argint>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	85 c0                	test   %eax,%eax
801052a7:	78 37                	js     801052e0 <sys_write+0x60>
801052a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ac:	83 ec 04             	sub    $0x4,%esp
801052af:	ff 75 f0             	pushl  -0x10(%ebp)
801052b2:	50                   	push   %eax
801052b3:	6a 01                	push   $0x1
801052b5:	e8 e6 fb ff ff       	call   80104ea0 <argptr>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	85 c0                	test   %eax,%eax
801052bf:	78 1f                	js     801052e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801052c1:	83 ec 04             	sub    $0x4,%esp
801052c4:	ff 75 f0             	pushl  -0x10(%ebp)
801052c7:	ff 75 f4             	pushl  -0xc(%ebp)
801052ca:	ff 75 ec             	pushl  -0x14(%ebp)
801052cd:	e8 0e bd ff ff       	call   80100fe0 <filewrite>
801052d2:	83 c4 10             	add    $0x10,%esp
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_close>:

int
sys_close(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052fc:	e8 3f fe ff ff       	call   80105140 <argfd.constprop.0>
80105301:	85 c0                	test   %eax,%eax
80105303:	78 2b                	js     80105330 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105305:	e8 c6 e4 ff ff       	call   801037d0 <myproc>
8010530a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010530d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105310:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105317:	00 
  fileclose(f);
80105318:	ff 75 f4             	pushl  -0xc(%ebp)
8010531b:	e8 10 bb ff ff       	call   80100e30 <fileclose>
  return 0;
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	31 c0                	xor    %eax,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_fstat>:

int
sys_fstat(void)
{
80105340:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105341:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105348:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010534b:	e8 f0 fd ff ff       	call   80105140 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 2c                	js     80105380 <sys_fstat+0x40>
80105354:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105357:	83 ec 04             	sub    $0x4,%esp
8010535a:	6a 14                	push   $0x14
8010535c:	50                   	push   %eax
8010535d:	6a 01                	push   $0x1
8010535f:	e8 3c fb ff ff       	call   80104ea0 <argptr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	78 15                	js     80105380 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010536b:	83 ec 08             	sub    $0x8,%esp
8010536e:	ff 75 f4             	pushl  -0xc(%ebp)
80105371:	ff 75 f0             	pushl  -0x10(%ebp)
80105374:	e8 87 bb ff ff       	call   80100f00 <filestat>
80105379:	83 c4 10             	add    $0x10,%esp
}
8010537c:	c9                   	leave  
8010537d:	c3                   	ret    
8010537e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105396:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105399:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 5c fb ff ff       	call   80104f00 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 fb 00 00 00    	js     801054aa <sys_link+0x11a>
801053af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053b2:	83 ec 08             	sub    $0x8,%esp
801053b5:	50                   	push   %eax
801053b6:	6a 01                	push   $0x1
801053b8:	e8 43 fb ff ff       	call   80104f00 <argstr>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	0f 88 e2 00 00 00    	js     801054aa <sys_link+0x11a>
    return -1;

  begin_op();
801053c8:	e8 83 d7 ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053d3:	e8 e8 ca ff ff       	call   80101ec0 <namei>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	89 c3                	mov    %eax,%ebx
801053df:	0f 84 f3 00 00 00    	je     801054d8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
801053e5:	83 ec 0c             	sub    $0xc,%esp
801053e8:	50                   	push   %eax
801053e9:	e8 82 c2 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 c4 00 00 00    	je     801054c0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105404:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105407:	53                   	push   %ebx
80105408:	e8 b3 c1 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
8010540d:	89 1c 24             	mov    %ebx,(%esp)
80105410:	e8 3b c3 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105415:	58                   	pop    %eax
80105416:	5a                   	pop    %edx
80105417:	57                   	push   %edi
80105418:	ff 75 d0             	pushl  -0x30(%ebp)
8010541b:	e8 c0 ca ff ff       	call   80101ee0 <nameiparent>
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	85 c0                	test   %eax,%eax
80105425:	89 c6                	mov    %eax,%esi
80105427:	74 5b                	je     80105484 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	50                   	push   %eax
8010542d:	e8 3e c2 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	8b 03                	mov    (%ebx),%eax
80105437:	39 06                	cmp    %eax,(%esi)
80105439:	75 3d                	jne    80105478 <sys_link+0xe8>
8010543b:	83 ec 04             	sub    $0x4,%esp
8010543e:	ff 73 04             	pushl  0x4(%ebx)
80105441:	57                   	push   %edi
80105442:	56                   	push   %esi
80105443:	e8 b8 c9 ff ff       	call   80101e00 <dirlink>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	78 29                	js     80105478 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	56                   	push   %esi
80105453:	e8 a8 c4 ff ff       	call   80101900 <iunlockput>
  iput(ip);
80105458:	89 1c 24             	mov    %ebx,(%esp)
8010545b:	e8 40 c3 ff ff       	call   801017a0 <iput>

  end_op();
80105460:	e8 5b d7 ff ff       	call   80102bc0 <end_op>

  return 0;
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret    
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	56                   	push   %esi
8010547c:	e8 7f c4 ff ff       	call   80101900 <iunlockput>
    goto bad;
80105481:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	53                   	push   %ebx
80105488:	e8 e3 c1 ff ff       	call   80101670 <ilock>
  ip->nlink--;
8010548d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105492:	89 1c 24             	mov    %ebx,(%esp)
80105495:	e8 26 c1 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
8010549a:	89 1c 24             	mov    %ebx,(%esp)
8010549d:	e8 5e c4 ff ff       	call   80101900 <iunlockput>
  end_op();
801054a2:	e8 19 d7 ff ff       	call   80102bc0 <end_op>
  return -1;
801054a7:	83 c4 10             	add    $0x10,%esp
}
801054aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801054ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5f                   	pop    %edi
801054b5:	5d                   	pop    %ebp
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 37 c4 ff ff       	call   80101900 <iunlockput>
    end_op();
801054c9:	e8 f2 d6 ff ff       	call   80102bc0 <end_op>
    return -1;
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d6:	eb 92                	jmp    8010546a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
801054d8:	e8 e3 d6 ff ff       	call   80102bc0 <end_op>
    return -1;
801054dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e2:	eb 86                	jmp    8010546a <sys_link+0xda>
801054e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801054f0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054f9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 fc f9 ff ff       	call   80104f00 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 82 01 00 00    	js     80105691 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010550f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105512:	e8 39 d6 ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	53                   	push   %ebx
8010551b:	ff 75 c0             	pushl  -0x40(%ebp)
8010551e:	e8 bd c9 ff ff       	call   80101ee0 <nameiparent>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010552b:	0f 84 6a 01 00 00    	je     8010569b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105531:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105534:	83 ec 0c             	sub    $0xc,%esp
80105537:	56                   	push   %esi
80105538:	e8 33 c1 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010553d:	58                   	pop    %eax
8010553e:	5a                   	pop    %edx
8010553f:	68 98 7e 10 80       	push   $0x80107e98
80105544:	53                   	push   %ebx
80105545:	e8 36 c6 ff ff       	call   80101b80 <namecmp>
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	85 c0                	test   %eax,%eax
8010554f:	0f 84 fc 00 00 00    	je     80105651 <sys_unlink+0x161>
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	68 97 7e 10 80       	push   $0x80107e97
8010555d:	53                   	push   %ebx
8010555e:	e8 1d c6 ff ff       	call   80101b80 <namecmp>
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	0f 84 e3 00 00 00    	je     80105651 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010556e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105571:	83 ec 04             	sub    $0x4,%esp
80105574:	50                   	push   %eax
80105575:	53                   	push   %ebx
80105576:	56                   	push   %esi
80105577:	e8 24 c6 ff ff       	call   80101ba0 <dirlookup>
8010557c:	83 c4 10             	add    $0x10,%esp
8010557f:	85 c0                	test   %eax,%eax
80105581:	89 c3                	mov    %eax,%ebx
80105583:	0f 84 c8 00 00 00    	je     80105651 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105589:	83 ec 0c             	sub    $0xc,%esp
8010558c:	50                   	push   %eax
8010558d:	e8 de c0 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010559a:	0f 8e 24 01 00 00    	jle    801056c4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801055a8:	74 66                	je     80105610 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055aa:	83 ec 04             	sub    $0x4,%esp
801055ad:	6a 10                	push   $0x10
801055af:	6a 00                	push   $0x0
801055b1:	56                   	push   %esi
801055b2:	e8 89 f5 ff ff       	call   80104b40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055b7:	6a 10                	push   $0x10
801055b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801055bc:	56                   	push   %esi
801055bd:	ff 75 b4             	pushl  -0x4c(%ebp)
801055c0:	e8 8b c4 ff ff       	call   80101a50 <writei>
801055c5:	83 c4 20             	add    $0x20,%esp
801055c8:	83 f8 10             	cmp    $0x10,%eax
801055cb:	0f 85 e6 00 00 00    	jne    801056b7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d6:	0f 84 9c 00 00 00    	je     80105678 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055dc:	83 ec 0c             	sub    $0xc,%esp
801055df:	ff 75 b4             	pushl  -0x4c(%ebp)
801055e2:	e8 19 c3 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
801055e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055ec:	89 1c 24             	mov    %ebx,(%esp)
801055ef:	e8 cc bf ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
801055f4:	89 1c 24             	mov    %ebx,(%esp)
801055f7:	e8 04 c3 ff ff       	call   80101900 <iunlockput>

  end_op();
801055fc:	e8 bf d5 ff ff       	call   80102bc0 <end_op>

  return 0;
80105601:	83 c4 10             	add    $0x10,%esp
80105604:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105606:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105609:	5b                   	pop    %ebx
8010560a:	5e                   	pop    %esi
8010560b:	5f                   	pop    %edi
8010560c:	5d                   	pop    %ebp
8010560d:	c3                   	ret    
8010560e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105610:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105614:	76 94                	jbe    801055aa <sys_unlink+0xba>
80105616:	bf 20 00 00 00       	mov    $0x20,%edi
8010561b:	eb 0f                	jmp    8010562c <sys_unlink+0x13c>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
80105620:	83 c7 10             	add    $0x10,%edi
80105623:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105626:	0f 83 7e ff ff ff    	jae    801055aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010562c:	6a 10                	push   $0x10
8010562e:	57                   	push   %edi
8010562f:	56                   	push   %esi
80105630:	53                   	push   %ebx
80105631:	e8 1a c3 ff ff       	call   80101950 <readi>
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	83 f8 10             	cmp    $0x10,%eax
8010563c:	75 6c                	jne    801056aa <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010563e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105643:	74 db                	je     80105620 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105645:	83 ec 0c             	sub    $0xc,%esp
80105648:	53                   	push   %ebx
80105649:	e8 b2 c2 ff ff       	call   80101900 <iunlockput>
    goto bad;
8010564e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105651:	83 ec 0c             	sub    $0xc,%esp
80105654:	ff 75 b4             	pushl  -0x4c(%ebp)
80105657:	e8 a4 c2 ff ff       	call   80101900 <iunlockput>
  end_op();
8010565c:	e8 5f d5 ff ff       	call   80102bc0 <end_op>
  return -1;
80105661:	83 c4 10             	add    $0x10,%esp
}
80105664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010566c:	5b                   	pop    %ebx
8010566d:	5e                   	pop    %esi
8010566e:	5f                   	pop    %edi
8010566f:	5d                   	pop    %ebp
80105670:	c3                   	ret    
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105678:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010567b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010567e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105683:	50                   	push   %eax
80105684:	e8 37 bf ff ff       	call   801015c0 <iupdate>
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	e9 4b ff ff ff       	jmp    801055dc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105696:	e9 6b ff ff ff       	jmp    80105606 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010569b:	e8 20 d5 ff ff       	call   80102bc0 <end_op>
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a5:	e9 5c ff ff ff       	jmp    80105606 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801056aa:	83 ec 0c             	sub    $0xc,%esp
801056ad:	68 bc 7e 10 80       	push   $0x80107ebc
801056b2:	e8 b9 ac ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801056b7:	83 ec 0c             	sub    $0xc,%esp
801056ba:	68 ce 7e 10 80       	push   $0x80107ece
801056bf:	e8 ac ac ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	68 aa 7e 10 80       	push   $0x80107eaa
801056cc:	e8 9f ac ff ff       	call   80100370 <panic>
801056d1:	eb 0d                	jmp    801056e0 <sys_open>
801056d3:	90                   	nop
801056d4:	90                   	nop
801056d5:	90                   	nop
801056d6:	90                   	nop
801056d7:	90                   	nop
801056d8:	90                   	nop
801056d9:	90                   	nop
801056da:	90                   	nop
801056db:	90                   	nop
801056dc:	90                   	nop
801056dd:	90                   	nop
801056de:	90                   	nop
801056df:	90                   	nop

801056e0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	57                   	push   %edi
801056e4:	56                   	push   %esi
801056e5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801056e9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056ec:	50                   	push   %eax
801056ed:	6a 00                	push   $0x0
801056ef:	e8 0c f8 ff ff       	call   80104f00 <argstr>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	0f 88 9e 00 00 00    	js     8010579d <sys_open+0xbd>
801056ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105702:	83 ec 08             	sub    $0x8,%esp
80105705:	50                   	push   %eax
80105706:	6a 01                	push   $0x1
80105708:	e8 43 f7 ff ff       	call   80104e50 <argint>
8010570d:	83 c4 10             	add    $0x10,%esp
80105710:	85 c0                	test   %eax,%eax
80105712:	0f 88 85 00 00 00    	js     8010579d <sys_open+0xbd>
    return -1;

  begin_op();
80105718:	e8 33 d4 ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
8010571d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105721:	0f 85 89 00 00 00    	jne    801057b0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105727:	83 ec 0c             	sub    $0xc,%esp
8010572a:	ff 75 e0             	pushl  -0x20(%ebp)
8010572d:	e8 8e c7 ff ff       	call   80101ec0 <namei>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	89 c6                	mov    %eax,%esi
80105739:	0f 84 8e 00 00 00    	je     801057cd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010573f:	83 ec 0c             	sub    $0xc,%esp
80105742:	50                   	push   %eax
80105743:	e8 28 bf ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105750:	0f 84 d2 00 00 00    	je     80105828 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105756:	e8 15 b6 ff ff       	call   80100d70 <filealloc>
8010575b:	85 c0                	test   %eax,%eax
8010575d:	89 c7                	mov    %eax,%edi
8010575f:	74 2b                	je     8010578c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105761:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105763:	e8 68 e0 ff ff       	call   801037d0 <myproc>
80105768:	90                   	nop
80105769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105770:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105774:	85 d2                	test   %edx,%edx
80105776:	74 68                	je     801057e0 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105778:	83 c3 01             	add    $0x1,%ebx
8010577b:	83 fb 10             	cmp    $0x10,%ebx
8010577e:	75 f0                	jne    80105770 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	57                   	push   %edi
80105784:	e8 a7 b6 ff ff       	call   80100e30 <fileclose>
80105789:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010578c:	83 ec 0c             	sub    $0xc,%esp
8010578f:	56                   	push   %esi
80105790:	e8 6b c1 ff ff       	call   80101900 <iunlockput>
    end_op();
80105795:	e8 26 d4 ff ff       	call   80102bc0 <end_op>
    return -1;
8010579a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010579d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801057a5:	5b                   	pop    %ebx
801057a6:	5e                   	pop    %esi
801057a7:	5f                   	pop    %edi
801057a8:	5d                   	pop    %ebp
801057a9:	c3                   	ret    
801057aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 02 00 00 00       	mov    $0x2,%edx
801057bf:	e8 dc f7 ff ff       	call   80104fa0 <create>
    if(ip == 0){
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801057c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057cb:	75 89                	jne    80105756 <sys_open+0x76>
      end_op();
801057cd:	e8 ee d3 ff ff       	call   80102bc0 <end_op>
      return -1;
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb 43                	jmp    8010581c <sys_open+0x13c>
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801057e3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e7:	56                   	push   %esi
801057e8:	e8 63 bf ff ff       	call   80101750 <iunlock>
  end_op();
801057ed:	e8 ce d3 ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
801057f2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057fb:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801057fe:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105801:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105808:	89 d0                	mov    %edx,%eax
8010580a:	83 e0 01             	and    $0x1,%eax
8010580d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105810:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105813:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105816:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010581a:	89 d8                	mov    %ebx,%eax
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010581f:	5b                   	pop    %ebx
80105820:	5e                   	pop    %esi
80105821:	5f                   	pop    %edi
80105822:	5d                   	pop    %ebp
80105823:	c3                   	ret    
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105828:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010582b:	85 c9                	test   %ecx,%ecx
8010582d:	0f 84 23 ff ff ff    	je     80105756 <sys_open+0x76>
80105833:	e9 54 ff ff ff       	jmp    8010578c <sys_open+0xac>
80105838:	90                   	nop
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105846:	e8 05 d3 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010584b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584e:	83 ec 08             	sub    $0x8,%esp
80105851:	50                   	push   %eax
80105852:	6a 00                	push   $0x0
80105854:	e8 a7 f6 ff ff       	call   80104f00 <argstr>
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	85 c0                	test   %eax,%eax
8010585e:	78 30                	js     80105890 <sys_mkdir+0x50>
80105860:	83 ec 0c             	sub    $0xc,%esp
80105863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105866:	31 c9                	xor    %ecx,%ecx
80105868:	6a 00                	push   $0x0
8010586a:	ba 01 00 00 00       	mov    $0x1,%edx
8010586f:	e8 2c f7 ff ff       	call   80104fa0 <create>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	74 15                	je     80105890 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010587b:	83 ec 0c             	sub    $0xc,%esp
8010587e:	50                   	push   %eax
8010587f:	e8 7c c0 ff ff       	call   80101900 <iunlockput>
  end_op();
80105884:	e8 37 d3 ff ff       	call   80102bc0 <end_op>
  return 0;
80105889:	83 c4 10             	add    $0x10,%esp
8010588c:	31 c0                	xor    %eax,%eax
}
8010588e:	c9                   	leave  
8010588f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105890:	e8 2b d3 ff ff       	call   80102bc0 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010589a:	c9                   	leave  
8010589b:	c3                   	ret    
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_mknod>:

int
sys_mknod(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058a6:	e8 a5 d2 ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058ae:	83 ec 08             	sub    $0x8,%esp
801058b1:	50                   	push   %eax
801058b2:	6a 00                	push   $0x0
801058b4:	e8 47 f6 ff ff       	call   80104f00 <argstr>
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	85 c0                	test   %eax,%eax
801058be:	78 60                	js     80105920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c3:	83 ec 08             	sub    $0x8,%esp
801058c6:	50                   	push   %eax
801058c7:	6a 01                	push   $0x1
801058c9:	e8 82 f5 ff ff       	call   80104e50 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
801058d3:	78 4b                	js     80105920 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801058d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058d8:	83 ec 08             	sub    $0x8,%esp
801058db:	50                   	push   %eax
801058dc:	6a 02                	push   $0x2
801058de:	e8 6d f5 ff ff       	call   80104e50 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	78 36                	js     80105920 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801058ee:	83 ec 0c             	sub    $0xc,%esp
801058f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801058f5:	ba 03 00 00 00       	mov    $0x3,%edx
801058fa:	50                   	push   %eax
801058fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058fe:	e8 9d f6 ff ff       	call   80104fa0 <create>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	74 16                	je     80105920 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010590a:	83 ec 0c             	sub    $0xc,%esp
8010590d:	50                   	push   %eax
8010590e:	e8 ed bf ff ff       	call   80101900 <iunlockput>
  end_op();
80105913:	e8 a8 d2 ff ff       	call   80102bc0 <end_op>
  return 0;
80105918:	83 c4 10             	add    $0x10,%esp
8010591b:	31 c0                	xor    %eax,%eax
}
8010591d:	c9                   	leave  
8010591e:	c3                   	ret    
8010591f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105920:	e8 9b d2 ff ff       	call   80102bc0 <end_op>
    return -1;
80105925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_chdir>:

int
sys_chdir(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	56                   	push   %esi
80105934:	53                   	push   %ebx
80105935:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105938:	e8 93 de ff ff       	call   801037d0 <myproc>
8010593d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010593f:	e8 0c d2 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105947:	83 ec 08             	sub    $0x8,%esp
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 ae f5 ff ff       	call   80104f00 <argstr>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 77                	js     801059d0 <sys_chdir+0xa0>
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	ff 75 f4             	pushl  -0xc(%ebp)
8010595f:	e8 5c c5 ff ff       	call   80101ec0 <namei>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	89 c3                	mov    %eax,%ebx
8010596b:	74 63                	je     801059d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	50                   	push   %eax
80105971:	e8 fa bc ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010597e:	75 30                	jne    801059b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	53                   	push   %ebx
80105984:	e8 c7 bd ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105989:	58                   	pop    %eax
8010598a:	ff 76 68             	pushl  0x68(%esi)
8010598d:	e8 0e be ff ff       	call   801017a0 <iput>
  end_op();
80105992:	e8 29 d2 ff ff       	call   80102bc0 <end_op>
  curproc->cwd = ip;
80105997:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010599a:	83 c4 10             	add    $0x10,%esp
8010599d:	31 c0                	xor    %eax,%eax
}
8010599f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059a2:	5b                   	pop    %ebx
801059a3:	5e                   	pop    %esi
801059a4:	5d                   	pop    %ebp
801059a5:	c3                   	ret    
801059a6:	8d 76 00             	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 47 bf ff ff       	call   80101900 <iunlockput>
    end_op();
801059b9:	e8 02 d2 ff ff       	call   80102bc0 <end_op>
    return -1;
801059be:	83 c4 10             	add    $0x10,%esp
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c6:	eb d7                	jmp    8010599f <sys_chdir+0x6f>
801059c8:	90                   	nop
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801059d0:	e8 eb d1 ff ff       	call   80102bc0 <end_op>
    return -1;
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb c3                	jmp    8010599f <sys_chdir+0x6f>
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
801059e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
801059ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f2:	50                   	push   %eax
801059f3:	6a 00                	push   $0x0
801059f5:	e8 06 f5 ff ff       	call   80104f00 <argstr>
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	85 c0                	test   %eax,%eax
801059ff:	78 7f                	js     80105a80 <sys_exec+0xa0>
80105a01:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a07:	83 ec 08             	sub    $0x8,%esp
80105a0a:	50                   	push   %eax
80105a0b:	6a 01                	push   $0x1
80105a0d:	e8 3e f4 ff ff       	call   80104e50 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 67                	js     80105a80 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a19:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a1f:	83 ec 04             	sub    $0x4,%esp
80105a22:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105a28:	68 80 00 00 00       	push   $0x80
80105a2d:	6a 00                	push   $0x0
80105a2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a35:	50                   	push   %eax
80105a36:	31 db                	xor    %ebx,%ebx
80105a38:	e8 03 f1 ff ff       	call   80104b40 <memset>
80105a3d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a40:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a46:	83 ec 08             	sub    $0x8,%esp
80105a49:	57                   	push   %edi
80105a4a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105a4d:	50                   	push   %eax
80105a4e:	e8 5d f3 ff ff       	call   80104db0 <fetchint>
80105a53:	83 c4 10             	add    $0x10,%esp
80105a56:	85 c0                	test   %eax,%eax
80105a58:	78 26                	js     80105a80 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105a5a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a60:	85 c0                	test   %eax,%eax
80105a62:	74 2c                	je     80105a90 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a64:	83 ec 08             	sub    $0x8,%esp
80105a67:	56                   	push   %esi
80105a68:	50                   	push   %eax
80105a69:	e8 82 f3 ff ff       	call   80104df0 <fetchstr>
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	85 c0                	test   %eax,%eax
80105a73:	78 0b                	js     80105a80 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105a75:	83 c3 01             	add    $0x1,%ebx
80105a78:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105a7b:	83 fb 20             	cmp    $0x20,%ebx
80105a7e:	75 c0                	jne    80105a40 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105a88:	5b                   	pop    %ebx
80105a89:	5e                   	pop    %esi
80105a8a:	5f                   	pop    %edi
80105a8b:	5d                   	pop    %ebp
80105a8c:	c3                   	ret    
80105a8d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105a90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a96:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105a99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105aa0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105aa4:	50                   	push   %eax
80105aa5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105aab:	e8 40 af ff ff       	call   801009f0 <exec>
80105ab0:	83 c4 10             	add    $0x10,%esp
}
80105ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab6:	5b                   	pop    %ebx
80105ab7:	5e                   	pop    %esi
80105ab8:	5f                   	pop    %edi
80105ab9:	5d                   	pop    %ebp
80105aba:	c3                   	ret    
80105abb:	90                   	nop
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_pipe>:

int
sys_pipe(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ac6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105ac9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105acc:	6a 08                	push   $0x8
80105ace:	50                   	push   %eax
80105acf:	6a 00                	push   $0x0
80105ad1:	e8 ca f3 ff ff       	call   80104ea0 <argptr>
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	78 4a                	js     80105b27 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105add:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ae0:	83 ec 08             	sub    $0x8,%esp
80105ae3:	50                   	push   %eax
80105ae4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ae7:	50                   	push   %eax
80105ae8:	e8 03 d7 ff ff       	call   801031f0 <pipealloc>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 33                	js     80105b27 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105af4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105af6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105af9:	e8 d2 dc ff ff       	call   801037d0 <myproc>
80105afe:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105b00:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b04:	85 f6                	test   %esi,%esi
80105b06:	74 30                	je     80105b38 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b08:	83 c3 01             	add    $0x1,%ebx
80105b0b:	83 fb 10             	cmp    $0x10,%ebx
80105b0e:	75 f0                	jne    80105b00 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	ff 75 e0             	pushl  -0x20(%ebp)
80105b16:	e8 15 b3 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105b1b:	58                   	pop    %eax
80105b1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b1f:	e8 0c b3 ff ff       	call   80100e30 <fileclose>
    return -1;
80105b24:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105b2f:	5b                   	pop    %ebx
80105b30:	5e                   	pop    %esi
80105b31:	5f                   	pop    %edi
80105b32:	5d                   	pop    %ebp
80105b33:	c3                   	ret    
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b38:	8d 73 08             	lea    0x8(%ebx),%esi
80105b3b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105b42:	e8 89 dc ff ff       	call   801037d0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105b47:	31 d2                	xor    %edx,%edx
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105b50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b54:	85 c9                	test   %ecx,%ecx
80105b56:	74 18                	je     80105b70 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105b58:	83 c2 01             	add    $0x1,%edx
80105b5b:	83 fa 10             	cmp    $0x10,%edx
80105b5e:	75 f0                	jne    80105b50 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105b60:	e8 6b dc ff ff       	call   801037d0 <myproc>
80105b65:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b6c:	00 
80105b6d:	eb a1                	jmp    80105b10 <sys_pipe+0x50>
80105b6f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105b82:	31 c0                	xor    %eax,%eax
}
80105b84:	5b                   	pop    %ebx
80105b85:	5e                   	pop    %esi
80105b86:	5f                   	pop    %edi
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    
80105b89:	66 90                	xchg   %ax,%ax
80105b8b:	66 90                	xchg   %ax,%ax
80105b8d:	66 90                	xchg   %ax,%ax
80105b8f:	90                   	nop

80105b90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b93:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105b94:	e9 f7 e2 ff ff       	jmp    80103e90 <fork>
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exit>:
}

int
sys_exit(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ba6:	e8 e5 e4 ff ff       	call   80104090 <exit>
  return 0;  // not reached
}
80105bab:	31 c0                	xor    %eax,%eax
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    
80105baf:	90                   	nop

80105bb0 <sys_wait>:

int
sys_wait(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105bb3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105bb4:	e9 57 de ff ff       	jmp    80103a10 <wait>
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_kill>:
}

int
sys_kill(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bc9:	50                   	push   %eax
80105bca:	6a 00                	push   $0x0
80105bcc:	e8 7f f2 ff ff       	call   80104e50 <argint>
80105bd1:	83 c4 10             	add    $0x10,%esp
80105bd4:	85 c0                	test   %eax,%eax
80105bd6:	78 18                	js     80105bf0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105bd8:	83 ec 0c             	sub    $0xc,%esp
80105bdb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bde:	e8 2d df ff ff       	call   80103b10 <kill>
80105be3:	83 c4 10             	add    $0x10,%esp
}
80105be6:	c9                   	leave  
80105be7:	c3                   	ret    
80105be8:	90                   	nop
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c00 <sys_getpid>:

int
sys_getpid(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c06:	e8 c5 db ff ff       	call   801037d0 <myproc>
80105c0b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c0e:	c9                   	leave  
80105c0f:	c3                   	ret    

80105c10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105c17:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 2e f2 ff ff       	call   80104e50 <argint>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 27                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c29:	e8 a2 db ff ff       	call   801037d0 <myproc>
  if(growproc(n) < 0)
80105c2e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105c31:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c33:	ff 75 f4             	pushl  -0xc(%ebp)
80105c36:	e8 c5 db ff ff       	call   80103800 <growproc>
80105c3b:	83 c4 10             	add    $0x10,%esp
80105c3e:	85 c0                	test   %eax,%eax
80105c40:	78 0e                	js     80105c50 <sys_sbrk+0x40>
    return -1;
  return addr;
80105c42:	89 d8                	mov    %ebx,%eax
}
80105c44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c47:	c9                   	leave  
80105c48:	c3                   	ret    
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c55:	eb ed                	jmp    80105c44 <sys_sbrk+0x34>
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105c67:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c6a:	50                   	push   %eax
80105c6b:	6a 00                	push   $0x0
80105c6d:	e8 de f1 ff ff       	call   80104e50 <argint>
80105c72:	83 c4 10             	add    $0x10,%esp
80105c75:	85 c0                	test   %eax,%eax
80105c77:	0f 88 8a 00 00 00    	js     80105d07 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	68 80 64 11 80       	push   $0x80116480
80105c85:	e8 46 ed ff ff       	call   801049d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c8d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105c90:	8b 1d c0 6c 11 80    	mov    0x80116cc0,%ebx
  while(ticks - ticks0 < n){
80105c96:	85 d2                	test   %edx,%edx
80105c98:	75 27                	jne    80105cc1 <sys_sleep+0x61>
80105c9a:	eb 54                	jmp    80105cf0 <sys_sleep+0x90>
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	68 80 64 11 80       	push   $0x80116480
80105ca8:	68 c0 6c 11 80       	push   $0x80116cc0
80105cad:	e8 8e dc ff ff       	call   80103940 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cb2:	a1 c0 6c 11 80       	mov    0x80116cc0,%eax
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	29 d8                	sub    %ebx,%eax
80105cbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cbf:	73 2f                	jae    80105cf0 <sys_sleep+0x90>
    if(myproc()->killed){
80105cc1:	e8 0a db ff ff       	call   801037d0 <myproc>
80105cc6:	8b 40 24             	mov    0x24(%eax),%eax
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 d3                	je     80105ca0 <sys_sleep+0x40>
      release(&tickslock);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	68 80 64 11 80       	push   $0x80116480
80105cd5:	e8 16 ee ff ff       	call   80104af0 <release>
      return -1;
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105ce2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ce5:	c9                   	leave  
80105ce6:	c3                   	ret    
80105ce7:	89 f6                	mov    %esi,%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	68 80 64 11 80       	push   $0x80116480
80105cf8:	e8 f3 ed ff ff       	call   80104af0 <release>
  return 0;
80105cfd:	83 c4 10             	add    $0x10,%esp
80105d00:	31 c0                	xor    %eax,%eax
}
80105d02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0c:	eb d4                	jmp    80105ce2 <sys_sleep+0x82>
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	53                   	push   %ebx
80105d14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d17:	68 80 64 11 80       	push   $0x80116480
80105d1c:	e8 af ec ff ff       	call   801049d0 <acquire>
  xticks = ticks;
80105d21:	8b 1d c0 6c 11 80    	mov    0x80116cc0,%ebx
  release(&tickslock);
80105d27:	c7 04 24 80 64 11 80 	movl   $0x80116480,(%esp)
80105d2e:	e8 bd ed ff ff       	call   80104af0 <release>
  return xticks;
}
80105d33:	89 d8                	mov    %ebx,%eax
80105d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d38:	c9                   	leave  
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d40 <sys_cps>:
//mine
int 
sys_cps(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return cps();
80105d43:	5d                   	pop    %ebp
}
//mine
int 
sys_cps(void)
{
  return cps();
80105d44:	e9 17 e7 ff ff       	jmp    80104460 <cps>

80105d49 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105d49:	1e                   	push   %ds
  pushl %es
80105d4a:	06                   	push   %es
  pushl %fs
80105d4b:	0f a0                	push   %fs
  pushl %gs
80105d4d:	0f a8                	push   %gs
  pushal
80105d4f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d50:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d54:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d56:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d58:	54                   	push   %esp
  call trap
80105d59:	e8 e2 00 00 00       	call   80105e40 <trap>
  addl $4, %esp
80105d5e:	83 c4 04             	add    $0x4,%esp

80105d61 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d61:	61                   	popa   
  popl %gs
80105d62:	0f a9                	pop    %gs
  popl %fs
80105d64:	0f a1                	pop    %fs
  popl %es
80105d66:	07                   	pop    %es
  popl %ds
80105d67:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d68:	83 c4 08             	add    $0x8,%esp
  iret
80105d6b:	cf                   	iret   
80105d6c:	66 90                	xchg   %ax,%ax
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105d70:	31 c0                	xor    %eax,%eax
80105d72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d78:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d7f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105d84:	c6 04 c5 c4 64 11 80 	movb   $0x0,-0x7fee9b3c(,%eax,8)
80105d8b:	00 
80105d8c:	66 89 0c c5 c2 64 11 	mov    %cx,-0x7fee9b3e(,%eax,8)
80105d93:	80 
80105d94:	c6 04 c5 c5 64 11 80 	movb   $0x8e,-0x7fee9b3b(,%eax,8)
80105d9b:	8e 
80105d9c:	66 89 14 c5 c0 64 11 	mov    %dx,-0x7fee9b40(,%eax,8)
80105da3:	80 
80105da4:	c1 ea 10             	shr    $0x10,%edx
80105da7:	66 89 14 c5 c6 64 11 	mov    %dx,-0x7fee9b3a(,%eax,8)
80105dae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105daf:	83 c0 01             	add    $0x1,%eax
80105db2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105db7:	75 bf                	jne    80105d78 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105db9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dba:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105dbf:	89 e5                	mov    %esp,%ebp
80105dc1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dc4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105dc9:	68 dd 7e 10 80       	push   $0x80107edd
80105dce:	68 80 64 11 80       	push   $0x80116480
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105dd3:	66 89 15 c2 66 11 80 	mov    %dx,0x801166c2
80105dda:	c6 05 c4 66 11 80 00 	movb   $0x0,0x801166c4
80105de1:	66 a3 c0 66 11 80    	mov    %ax,0x801166c0
80105de7:	c1 e8 10             	shr    $0x10,%eax
80105dea:	c6 05 c5 66 11 80 ef 	movb   $0xef,0x801166c5
80105df1:	66 a3 c6 66 11 80    	mov    %ax,0x801166c6

  initlock(&tickslock, "time");
80105df7:	e8 d4 ea ff ff       	call   801048d0 <initlock>
}
80105dfc:	83 c4 10             	add    $0x10,%esp
80105dff:	c9                   	leave  
80105e00:	c3                   	ret    
80105e01:	eb 0d                	jmp    80105e10 <idtinit>
80105e03:	90                   	nop
80105e04:	90                   	nop
80105e05:	90                   	nop
80105e06:	90                   	nop
80105e07:	90                   	nop
80105e08:	90                   	nop
80105e09:	90                   	nop
80105e0a:	90                   	nop
80105e0b:	90                   	nop
80105e0c:	90                   	nop
80105e0d:	90                   	nop
80105e0e:	90                   	nop
80105e0f:	90                   	nop

80105e10 <idtinit>:

void
idtinit(void)
{
80105e10:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105e11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e16:	89 e5                	mov    %esp,%ebp
80105e18:	83 ec 10             	sub    $0x10,%esp
80105e1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e1f:	b8 c0 64 11 80       	mov    $0x801164c0,%eax
80105e24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e28:	c1 e8 10             	shr    $0x10,%eax
80105e2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105e2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	57                   	push   %edi
80105e44:	56                   	push   %esi
80105e45:	53                   	push   %ebx
80105e46:	83 ec 1c             	sub    $0x1c,%esp
80105e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105e4c:	8b 47 30             	mov    0x30(%edi),%eax
80105e4f:	83 f8 40             	cmp    $0x40,%eax
80105e52:	0f 84 28 01 00 00    	je     80105f80 <trap+0x140>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105e58:	83 e8 20             	sub    $0x20,%eax
80105e5b:	83 f8 1f             	cmp    $0x1f,%eax
80105e5e:	0f 87 5c 01 00 00    	ja     80105fc0 <trap+0x180>
80105e64:	ff 24 85 84 7f 10 80 	jmp    *-0x7fef807c(,%eax,4)
80105e6b:	90                   	nop
80105e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105e70:	e8 3b d9 ff ff       	call   801037b0 <cpuid>
80105e75:	85 c0                	test   %eax,%eax
80105e77:	0f 84 cb 01 00 00    	je     80106048 <trap+0x208>
      if (myproc())
      wakeup(&ticks);
      release(&tickslock);
    }
    
    if (myproc())
80105e7d:	e8 4e d9 ff ff       	call   801037d0 <myproc>
80105e82:	85 c0                	test   %eax,%eax
80105e84:	74 0f                	je     80105e95 <trap+0x55>
    {
      if (myproc()->state == RUNNING)
80105e86:	e8 45 d9 ff ff       	call   801037d0 <myproc>
80105e8b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e8f:	0f 84 fb 01 00 00    	je     80106090 <trap+0x250>

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105e95:	e8 76 c8 ff ff       	call   80102710 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e9a:	e8 31 d9 ff ff       	call   801037d0 <myproc>
80105e9f:	85 c0                	test   %eax,%eax
80105ea1:	74 0c                	je     80105eaf <trap+0x6f>
80105ea3:	e8 28 d9 ff ff       	call   801037d0 <myproc>
80105ea8:	8b 50 24             	mov    0x24(%eax),%edx
80105eab:	85 d2                	test   %edx,%edx
80105ead:	75 49                	jne    80105ef8 <trap+0xb8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105eaf:	e8 1c d9 ff ff       	call   801037d0 <myproc>
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	74 0b                	je     80105ec3 <trap+0x83>
80105eb8:	e8 13 d9 ff ff       	call   801037d0 <myproc>
80105ebd:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ec1:	74 4d                	je     80105f10 <trap+0xd0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ec3:	e8 08 d9 ff ff       	call   801037d0 <myproc>
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	74 1d                	je     80105ee9 <trap+0xa9>
80105ecc:	e8 ff d8 ff ff       	call   801037d0 <myproc>
80105ed1:	8b 40 24             	mov    0x24(%eax),%eax
80105ed4:	85 c0                	test   %eax,%eax
80105ed6:	74 11                	je     80105ee9 <trap+0xa9>
80105ed8:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105edc:	83 e0 03             	and    $0x3,%eax
80105edf:	66 83 f8 03          	cmp    $0x3,%ax
80105ee3:	0f 84 c4 00 00 00    	je     80105fad <trap+0x16d>
    exit();
}
80105ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eec:	5b                   	pop    %ebx
80105eed:	5e                   	pop    %esi
80105eee:	5f                   	pop    %edi
80105eef:	5d                   	pop    %ebp
80105ef0:	c3                   	ret    
80105ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef8:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105efc:	83 e0 03             	and    $0x3,%eax
80105eff:	66 83 f8 03          	cmp    $0x3,%ax
80105f03:	75 aa                	jne    80105eaf <trap+0x6f>
    exit();
80105f05:	e8 86 e1 ff ff       	call   80104090 <exit>
80105f0a:	eb a3                	jmp    80105eaf <trap+0x6f>
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f10:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f14:	75 ad                	jne    80105ec3 <trap+0x83>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105f16:	e8 95 e2 ff ff       	call   801041b0 <yield>
80105f1b:	eb a6                	jmp    80105ec3 <trap+0x83>
80105f1d:	8d 76 00             	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105f20:	e8 ab c6 ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80105f25:	e8 e6 c7 ff ff       	call   80102710 <lapiceoi>
    break;
80105f2a:	e9 6b ff ff ff       	jmp    80105e9a <trap+0x5a>
80105f2f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105f30:	e8 0b 03 00 00       	call   80106240 <uartintr>
    lapiceoi();
80105f35:	e8 d6 c7 ff ff       	call   80102710 <lapiceoi>
    break;
80105f3a:	e9 5b ff ff ff       	jmp    80105e9a <trap+0x5a>
80105f3f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f40:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105f44:	8b 77 38             	mov    0x38(%edi),%esi
80105f47:	e8 64 d8 ff ff       	call   801037b0 <cpuid>
80105f4c:	56                   	push   %esi
80105f4d:	53                   	push   %ebx
80105f4e:	50                   	push   %eax
80105f4f:	68 e8 7e 10 80       	push   $0x80107ee8
80105f54:	e8 07 a7 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105f59:	e8 b2 c7 ff ff       	call   80102710 <lapiceoi>
    break;
80105f5e:	83 c4 10             	add    $0x10,%esp
80105f61:	e9 34 ff ff ff       	jmp    80105e9a <trap+0x5a>
80105f66:	8d 76 00             	lea    0x0(%esi),%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    

    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105f70:	e8 db c0 ff ff       	call   80102050 <ideintr>
80105f75:	e9 1b ff ff ff       	jmp    80105e95 <trap+0x55>
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105f80:	e8 4b d8 ff ff       	call   801037d0 <myproc>
80105f85:	8b 58 24             	mov    0x24(%eax),%ebx
80105f88:	85 db                	test   %ebx,%ebx
80105f8a:	0f 85 a8 00 00 00    	jne    80106038 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
80105f90:	e8 3b d8 ff ff       	call   801037d0 <myproc>
80105f95:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105f98:	e8 a3 ef ff ff       	call   80104f40 <syscall>
    if(myproc()->killed)
80105f9d:	e8 2e d8 ff ff       	call   801037d0 <myproc>
80105fa2:	8b 48 24             	mov    0x24(%eax),%ecx
80105fa5:	85 c9                	test   %ecx,%ecx
80105fa7:	0f 84 3c ff ff ff    	je     80105ee9 <trap+0xa9>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb0:	5b                   	pop    %ebx
80105fb1:	5e                   	pop    %esi
80105fb2:	5f                   	pop    %edi
80105fb3:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105fb4:	e9 d7 e0 ff ff       	jmp    80104090 <exit>
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105fc0:	e8 0b d8 ff ff       	call   801037d0 <myproc>
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	0f 84 d4 00 00 00    	je     801060a1 <trap+0x261>
80105fcd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fd1:	0f 84 ca 00 00 00    	je     801060a1 <trap+0x261>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fd7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fda:	8b 57 38             	mov    0x38(%edi),%edx
80105fdd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105fe0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105fe3:	e8 c8 d7 ff ff       	call   801037b0 <cpuid>
80105fe8:	8b 77 34             	mov    0x34(%edi),%esi
80105feb:	8b 5f 30             	mov    0x30(%edi),%ebx
80105fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105ff1:	e8 da d7 ff ff       	call   801037d0 <myproc>
80105ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ff9:	e8 d2 d7 ff ff       	call   801037d0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ffe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106001:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106004:	51                   	push   %ecx
80106005:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106006:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106009:	ff 75 e4             	pushl  -0x1c(%ebp)
8010600c:	56                   	push   %esi
8010600d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010600e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106011:	52                   	push   %edx
80106012:	ff 70 10             	pushl  0x10(%eax)
80106015:	68 40 7f 10 80       	push   $0x80107f40
8010601a:	e8 41 a6 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010601f:	83 c4 20             	add    $0x20,%esp
80106022:	e8 a9 d7 ff ff       	call   801037d0 <myproc>
80106027:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010602e:	e9 67 fe ff ff       	jmp    80105e9a <trap+0x5a>
80106033:	90                   	nop
80106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106038:	e8 53 e0 ff ff       	call   80104090 <exit>
8010603d:	e9 4e ff ff ff       	jmp    80105f90 <trap+0x150>
80106042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106048:	83 ec 0c             	sub    $0xc,%esp
8010604b:	68 80 64 11 80       	push   $0x80116480
80106050:	e8 7b e9 ff ff       	call   801049d0 <acquire>
      ticks++;
80106055:	83 05 c0 6c 11 80 01 	addl   $0x1,0x80116cc0
      if (myproc())
8010605c:	e8 6f d7 ff ff       	call   801037d0 <myproc>
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	85 c0                	test   %eax,%eax
80106066:	74 10                	je     80106078 <trap+0x238>
      wakeup(&ticks);
80106068:	83 ec 0c             	sub    $0xc,%esp
8010606b:	68 c0 6c 11 80       	push   $0x80116cc0
80106070:	e8 0b e1 ff ff       	call   80104180 <wakeup>
80106075:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106078:	83 ec 0c             	sub    $0xc,%esp
8010607b:	68 80 64 11 80       	push   $0x80116480
80106080:	e8 6b ea ff ff       	call   80104af0 <release>
80106085:	83 c4 10             	add    $0x10,%esp
80106088:	e9 f0 fd ff ff       	jmp    80105e7d <trap+0x3d>
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    
    if (myproc())
    {
      if (myproc()->state == RUNNING)
        myproc()->running_time++;
80106090:	e8 3b d7 ff ff       	call   801037d0 <myproc>
80106095:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
8010609c:	e9 f4 fd ff ff       	jmp    80105e95 <trap+0x55>
801060a1:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060a4:	8b 5f 38             	mov    0x38(%edi),%ebx
801060a7:	e8 04 d7 ff ff       	call   801037b0 <cpuid>
801060ac:	83 ec 0c             	sub    $0xc,%esp
801060af:	56                   	push   %esi
801060b0:	53                   	push   %ebx
801060b1:	50                   	push   %eax
801060b2:	ff 77 30             	pushl  0x30(%edi)
801060b5:	68 0c 7f 10 80       	push   $0x80107f0c
801060ba:	e8 a1 a5 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801060bf:	83 c4 14             	add    $0x14,%esp
801060c2:	68 e2 7e 10 80       	push   $0x80107ee2
801060c7:	e8 a4 a2 ff ff       	call   80100370 <panic>
801060cc:	66 90                	xchg   %ax,%ax
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801060d0:	a1 c4 b8 10 80       	mov    0x8010b8c4,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801060d5:	55                   	push   %ebp
801060d6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060d8:	85 c0                	test   %eax,%eax
801060da:	74 1c                	je     801060f8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060e1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060e2:	a8 01                	test   $0x1,%al
801060e4:	74 12                	je     801060f8 <uartgetc+0x28>
801060e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060eb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060ec:	0f b6 c0             	movzbl %al,%eax
}
801060ef:	5d                   	pop    %ebp
801060f0:	c3                   	ret    
801060f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
801060f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
801060fd:	5d                   	pop    %ebp
801060fe:	c3                   	ret    
801060ff:	90                   	nop

80106100 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	57                   	push   %edi
80106104:	56                   	push   %esi
80106105:	53                   	push   %ebx
80106106:	89 c7                	mov    %eax,%edi
80106108:	bb 80 00 00 00       	mov    $0x80,%ebx
8010610d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106112:	83 ec 0c             	sub    $0xc,%esp
80106115:	eb 1b                	jmp    80106132 <uartputc.part.0+0x32>
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	6a 0a                	push   $0xa
80106125:	e8 06 c6 ff ff       	call   80102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010612a:	83 c4 10             	add    $0x10,%esp
8010612d:	83 eb 01             	sub    $0x1,%ebx
80106130:	74 07                	je     80106139 <uartputc.part.0+0x39>
80106132:	89 f2                	mov    %esi,%edx
80106134:	ec                   	in     (%dx),%al
80106135:	a8 20                	test   $0x20,%al
80106137:	74 e7                	je     80106120 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106139:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613e:	89 f8                	mov    %edi,%eax
80106140:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106141:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106144:	5b                   	pop    %ebx
80106145:	5e                   	pop    %esi
80106146:	5f                   	pop    %edi
80106147:	5d                   	pop    %ebp
80106148:	c3                   	ret    
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106150 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106150:	55                   	push   %ebp
80106151:	31 c9                	xor    %ecx,%ecx
80106153:	89 c8                	mov    %ecx,%eax
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	56                   	push   %esi
80106159:	53                   	push   %ebx
8010615a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010615f:	89 da                	mov    %ebx,%edx
80106161:	83 ec 0c             	sub    $0xc,%esp
80106164:	ee                   	out    %al,(%dx)
80106165:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010616a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010616f:	89 fa                	mov    %edi,%edx
80106171:	ee                   	out    %al,(%dx)
80106172:	b8 0c 00 00 00       	mov    $0xc,%eax
80106177:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617c:	ee                   	out    %al,(%dx)
8010617d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106182:	89 c8                	mov    %ecx,%eax
80106184:	89 f2                	mov    %esi,%edx
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 03 00 00 00       	mov    $0x3,%eax
8010618c:	89 fa                	mov    %edi,%edx
8010618e:	ee                   	out    %al,(%dx)
8010618f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106194:	89 c8                	mov    %ecx,%eax
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 01 00 00 00       	mov    $0x1,%eax
8010619c:	89 f2                	mov    %esi,%edx
8010619e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801061a5:	3c ff                	cmp    $0xff,%al
801061a7:	74 5a                	je     80106203 <uartinit+0xb3>
    return;
  uart = 1;
801061a9:	c7 05 c4 b8 10 80 01 	movl   $0x1,0x8010b8c4
801061b0:	00 00 00 
801061b3:	89 da                	mov    %ebx,%edx
801061b5:	ec                   	in     (%dx),%al
801061b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
801061bc:	83 ec 08             	sub    $0x8,%esp
801061bf:	bb 04 80 10 80       	mov    $0x80108004,%ebx
801061c4:	6a 00                	push   $0x0
801061c6:	6a 04                	push   $0x4
801061c8:	e8 d3 c0 ff ff       	call   801022a0 <ioapicenable>
801061cd:	83 c4 10             	add    $0x10,%esp
801061d0:	b8 78 00 00 00       	mov    $0x78,%eax
801061d5:	eb 13                	jmp    801061ea <uartinit+0x9a>
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061e0:	83 c3 01             	add    $0x1,%ebx
801061e3:	0f be 03             	movsbl (%ebx),%eax
801061e6:	84 c0                	test   %al,%al
801061e8:	74 19                	je     80106203 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
801061ea:	8b 15 c4 b8 10 80    	mov    0x8010b8c4,%edx
801061f0:	85 d2                	test   %edx,%edx
801061f2:	74 ec                	je     801061e0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801061f4:	83 c3 01             	add    $0x1,%ebx
801061f7:	e8 04 ff ff ff       	call   80106100 <uartputc.part.0>
801061fc:	0f be 03             	movsbl (%ebx),%eax
801061ff:	84 c0                	test   %al,%al
80106201:	75 e7                	jne    801061ea <uartinit+0x9a>
    uartputc(*p);
}
80106203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106206:	5b                   	pop    %ebx
80106207:	5e                   	pop    %esi
80106208:	5f                   	pop    %edi
80106209:	5d                   	pop    %ebp
8010620a:	c3                   	ret    
8010620b:	90                   	nop
8010620c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106210 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106210:	8b 15 c4 b8 10 80    	mov    0x8010b8c4,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106216:	55                   	push   %ebp
80106217:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106219:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010621b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010621e:	74 10                	je     80106230 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106220:	5d                   	pop    %ebp
80106221:	e9 da fe ff ff       	jmp    80106100 <uartputc.part.0>
80106226:	8d 76 00             	lea    0x0(%esi),%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106230:	5d                   	pop    %ebp
80106231:	c3                   	ret    
80106232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106240 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106246:	68 d0 60 10 80       	push   $0x801060d0
8010624b:	e8 a0 a5 ff ff       	call   801007f0 <consoleintr>
}
80106250:	83 c4 10             	add    $0x10,%esp
80106253:	c9                   	leave  
80106254:	c3                   	ret    

80106255 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $0
80106257:	6a 00                	push   $0x0
  jmp alltraps
80106259:	e9 eb fa ff ff       	jmp    80105d49 <alltraps>

8010625e <vector1>:
.globl vector1
vector1:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $1
80106260:	6a 01                	push   $0x1
  jmp alltraps
80106262:	e9 e2 fa ff ff       	jmp    80105d49 <alltraps>

80106267 <vector2>:
.globl vector2
vector2:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $2
80106269:	6a 02                	push   $0x2
  jmp alltraps
8010626b:	e9 d9 fa ff ff       	jmp    80105d49 <alltraps>

80106270 <vector3>:
.globl vector3
vector3:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $3
80106272:	6a 03                	push   $0x3
  jmp alltraps
80106274:	e9 d0 fa ff ff       	jmp    80105d49 <alltraps>

80106279 <vector4>:
.globl vector4
vector4:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $4
8010627b:	6a 04                	push   $0x4
  jmp alltraps
8010627d:	e9 c7 fa ff ff       	jmp    80105d49 <alltraps>

80106282 <vector5>:
.globl vector5
vector5:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $5
80106284:	6a 05                	push   $0x5
  jmp alltraps
80106286:	e9 be fa ff ff       	jmp    80105d49 <alltraps>

8010628b <vector6>:
.globl vector6
vector6:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $6
8010628d:	6a 06                	push   $0x6
  jmp alltraps
8010628f:	e9 b5 fa ff ff       	jmp    80105d49 <alltraps>

80106294 <vector7>:
.globl vector7
vector7:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $7
80106296:	6a 07                	push   $0x7
  jmp alltraps
80106298:	e9 ac fa ff ff       	jmp    80105d49 <alltraps>

8010629d <vector8>:
.globl vector8
vector8:
  pushl $8
8010629d:	6a 08                	push   $0x8
  jmp alltraps
8010629f:	e9 a5 fa ff ff       	jmp    80105d49 <alltraps>

801062a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $9
801062a6:	6a 09                	push   $0x9
  jmp alltraps
801062a8:	e9 9c fa ff ff       	jmp    80105d49 <alltraps>

801062ad <vector10>:
.globl vector10
vector10:
  pushl $10
801062ad:	6a 0a                	push   $0xa
  jmp alltraps
801062af:	e9 95 fa ff ff       	jmp    80105d49 <alltraps>

801062b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801062b4:	6a 0b                	push   $0xb
  jmp alltraps
801062b6:	e9 8e fa ff ff       	jmp    80105d49 <alltraps>

801062bb <vector12>:
.globl vector12
vector12:
  pushl $12
801062bb:	6a 0c                	push   $0xc
  jmp alltraps
801062bd:	e9 87 fa ff ff       	jmp    80105d49 <alltraps>

801062c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801062c2:	6a 0d                	push   $0xd
  jmp alltraps
801062c4:	e9 80 fa ff ff       	jmp    80105d49 <alltraps>

801062c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801062c9:	6a 0e                	push   $0xe
  jmp alltraps
801062cb:	e9 79 fa ff ff       	jmp    80105d49 <alltraps>

801062d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801062d0:	6a 00                	push   $0x0
  pushl $15
801062d2:	6a 0f                	push   $0xf
  jmp alltraps
801062d4:	e9 70 fa ff ff       	jmp    80105d49 <alltraps>

801062d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801062d9:	6a 00                	push   $0x0
  pushl $16
801062db:	6a 10                	push   $0x10
  jmp alltraps
801062dd:	e9 67 fa ff ff       	jmp    80105d49 <alltraps>

801062e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062e2:	6a 11                	push   $0x11
  jmp alltraps
801062e4:	e9 60 fa ff ff       	jmp    80105d49 <alltraps>

801062e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $18
801062eb:	6a 12                	push   $0x12
  jmp alltraps
801062ed:	e9 57 fa ff ff       	jmp    80105d49 <alltraps>

801062f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $19
801062f4:	6a 13                	push   $0x13
  jmp alltraps
801062f6:	e9 4e fa ff ff       	jmp    80105d49 <alltraps>

801062fb <vector20>:
.globl vector20
vector20:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $20
801062fd:	6a 14                	push   $0x14
  jmp alltraps
801062ff:	e9 45 fa ff ff       	jmp    80105d49 <alltraps>

80106304 <vector21>:
.globl vector21
vector21:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $21
80106306:	6a 15                	push   $0x15
  jmp alltraps
80106308:	e9 3c fa ff ff       	jmp    80105d49 <alltraps>

8010630d <vector22>:
.globl vector22
vector22:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $22
8010630f:	6a 16                	push   $0x16
  jmp alltraps
80106311:	e9 33 fa ff ff       	jmp    80105d49 <alltraps>

80106316 <vector23>:
.globl vector23
vector23:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $23
80106318:	6a 17                	push   $0x17
  jmp alltraps
8010631a:	e9 2a fa ff ff       	jmp    80105d49 <alltraps>

8010631f <vector24>:
.globl vector24
vector24:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $24
80106321:	6a 18                	push   $0x18
  jmp alltraps
80106323:	e9 21 fa ff ff       	jmp    80105d49 <alltraps>

80106328 <vector25>:
.globl vector25
vector25:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $25
8010632a:	6a 19                	push   $0x19
  jmp alltraps
8010632c:	e9 18 fa ff ff       	jmp    80105d49 <alltraps>

80106331 <vector26>:
.globl vector26
vector26:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $26
80106333:	6a 1a                	push   $0x1a
  jmp alltraps
80106335:	e9 0f fa ff ff       	jmp    80105d49 <alltraps>

8010633a <vector27>:
.globl vector27
vector27:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $27
8010633c:	6a 1b                	push   $0x1b
  jmp alltraps
8010633e:	e9 06 fa ff ff       	jmp    80105d49 <alltraps>

80106343 <vector28>:
.globl vector28
vector28:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $28
80106345:	6a 1c                	push   $0x1c
  jmp alltraps
80106347:	e9 fd f9 ff ff       	jmp    80105d49 <alltraps>

8010634c <vector29>:
.globl vector29
vector29:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $29
8010634e:	6a 1d                	push   $0x1d
  jmp alltraps
80106350:	e9 f4 f9 ff ff       	jmp    80105d49 <alltraps>

80106355 <vector30>:
.globl vector30
vector30:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $30
80106357:	6a 1e                	push   $0x1e
  jmp alltraps
80106359:	e9 eb f9 ff ff       	jmp    80105d49 <alltraps>

8010635e <vector31>:
.globl vector31
vector31:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $31
80106360:	6a 1f                	push   $0x1f
  jmp alltraps
80106362:	e9 e2 f9 ff ff       	jmp    80105d49 <alltraps>

80106367 <vector32>:
.globl vector32
vector32:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $32
80106369:	6a 20                	push   $0x20
  jmp alltraps
8010636b:	e9 d9 f9 ff ff       	jmp    80105d49 <alltraps>

80106370 <vector33>:
.globl vector33
vector33:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $33
80106372:	6a 21                	push   $0x21
  jmp alltraps
80106374:	e9 d0 f9 ff ff       	jmp    80105d49 <alltraps>

80106379 <vector34>:
.globl vector34
vector34:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $34
8010637b:	6a 22                	push   $0x22
  jmp alltraps
8010637d:	e9 c7 f9 ff ff       	jmp    80105d49 <alltraps>

80106382 <vector35>:
.globl vector35
vector35:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $35
80106384:	6a 23                	push   $0x23
  jmp alltraps
80106386:	e9 be f9 ff ff       	jmp    80105d49 <alltraps>

8010638b <vector36>:
.globl vector36
vector36:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $36
8010638d:	6a 24                	push   $0x24
  jmp alltraps
8010638f:	e9 b5 f9 ff ff       	jmp    80105d49 <alltraps>

80106394 <vector37>:
.globl vector37
vector37:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $37
80106396:	6a 25                	push   $0x25
  jmp alltraps
80106398:	e9 ac f9 ff ff       	jmp    80105d49 <alltraps>

8010639d <vector38>:
.globl vector38
vector38:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $38
8010639f:	6a 26                	push   $0x26
  jmp alltraps
801063a1:	e9 a3 f9 ff ff       	jmp    80105d49 <alltraps>

801063a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $39
801063a8:	6a 27                	push   $0x27
  jmp alltraps
801063aa:	e9 9a f9 ff ff       	jmp    80105d49 <alltraps>

801063af <vector40>:
.globl vector40
vector40:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $40
801063b1:	6a 28                	push   $0x28
  jmp alltraps
801063b3:	e9 91 f9 ff ff       	jmp    80105d49 <alltraps>

801063b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $41
801063ba:	6a 29                	push   $0x29
  jmp alltraps
801063bc:	e9 88 f9 ff ff       	jmp    80105d49 <alltraps>

801063c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $42
801063c3:	6a 2a                	push   $0x2a
  jmp alltraps
801063c5:	e9 7f f9 ff ff       	jmp    80105d49 <alltraps>

801063ca <vector43>:
.globl vector43
vector43:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $43
801063cc:	6a 2b                	push   $0x2b
  jmp alltraps
801063ce:	e9 76 f9 ff ff       	jmp    80105d49 <alltraps>

801063d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $44
801063d5:	6a 2c                	push   $0x2c
  jmp alltraps
801063d7:	e9 6d f9 ff ff       	jmp    80105d49 <alltraps>

801063dc <vector45>:
.globl vector45
vector45:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $45
801063de:	6a 2d                	push   $0x2d
  jmp alltraps
801063e0:	e9 64 f9 ff ff       	jmp    80105d49 <alltraps>

801063e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $46
801063e7:	6a 2e                	push   $0x2e
  jmp alltraps
801063e9:	e9 5b f9 ff ff       	jmp    80105d49 <alltraps>

801063ee <vector47>:
.globl vector47
vector47:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $47
801063f0:	6a 2f                	push   $0x2f
  jmp alltraps
801063f2:	e9 52 f9 ff ff       	jmp    80105d49 <alltraps>

801063f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $48
801063f9:	6a 30                	push   $0x30
  jmp alltraps
801063fb:	e9 49 f9 ff ff       	jmp    80105d49 <alltraps>

80106400 <vector49>:
.globl vector49
vector49:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $49
80106402:	6a 31                	push   $0x31
  jmp alltraps
80106404:	e9 40 f9 ff ff       	jmp    80105d49 <alltraps>

80106409 <vector50>:
.globl vector50
vector50:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $50
8010640b:	6a 32                	push   $0x32
  jmp alltraps
8010640d:	e9 37 f9 ff ff       	jmp    80105d49 <alltraps>

80106412 <vector51>:
.globl vector51
vector51:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $51
80106414:	6a 33                	push   $0x33
  jmp alltraps
80106416:	e9 2e f9 ff ff       	jmp    80105d49 <alltraps>

8010641b <vector52>:
.globl vector52
vector52:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $52
8010641d:	6a 34                	push   $0x34
  jmp alltraps
8010641f:	e9 25 f9 ff ff       	jmp    80105d49 <alltraps>

80106424 <vector53>:
.globl vector53
vector53:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $53
80106426:	6a 35                	push   $0x35
  jmp alltraps
80106428:	e9 1c f9 ff ff       	jmp    80105d49 <alltraps>

8010642d <vector54>:
.globl vector54
vector54:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $54
8010642f:	6a 36                	push   $0x36
  jmp alltraps
80106431:	e9 13 f9 ff ff       	jmp    80105d49 <alltraps>

80106436 <vector55>:
.globl vector55
vector55:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $55
80106438:	6a 37                	push   $0x37
  jmp alltraps
8010643a:	e9 0a f9 ff ff       	jmp    80105d49 <alltraps>

8010643f <vector56>:
.globl vector56
vector56:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $56
80106441:	6a 38                	push   $0x38
  jmp alltraps
80106443:	e9 01 f9 ff ff       	jmp    80105d49 <alltraps>

80106448 <vector57>:
.globl vector57
vector57:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $57
8010644a:	6a 39                	push   $0x39
  jmp alltraps
8010644c:	e9 f8 f8 ff ff       	jmp    80105d49 <alltraps>

80106451 <vector58>:
.globl vector58
vector58:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $58
80106453:	6a 3a                	push   $0x3a
  jmp alltraps
80106455:	e9 ef f8 ff ff       	jmp    80105d49 <alltraps>

8010645a <vector59>:
.globl vector59
vector59:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $59
8010645c:	6a 3b                	push   $0x3b
  jmp alltraps
8010645e:	e9 e6 f8 ff ff       	jmp    80105d49 <alltraps>

80106463 <vector60>:
.globl vector60
vector60:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $60
80106465:	6a 3c                	push   $0x3c
  jmp alltraps
80106467:	e9 dd f8 ff ff       	jmp    80105d49 <alltraps>

8010646c <vector61>:
.globl vector61
vector61:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $61
8010646e:	6a 3d                	push   $0x3d
  jmp alltraps
80106470:	e9 d4 f8 ff ff       	jmp    80105d49 <alltraps>

80106475 <vector62>:
.globl vector62
vector62:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $62
80106477:	6a 3e                	push   $0x3e
  jmp alltraps
80106479:	e9 cb f8 ff ff       	jmp    80105d49 <alltraps>

8010647e <vector63>:
.globl vector63
vector63:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $63
80106480:	6a 3f                	push   $0x3f
  jmp alltraps
80106482:	e9 c2 f8 ff ff       	jmp    80105d49 <alltraps>

80106487 <vector64>:
.globl vector64
vector64:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $64
80106489:	6a 40                	push   $0x40
  jmp alltraps
8010648b:	e9 b9 f8 ff ff       	jmp    80105d49 <alltraps>

80106490 <vector65>:
.globl vector65
vector65:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $65
80106492:	6a 41                	push   $0x41
  jmp alltraps
80106494:	e9 b0 f8 ff ff       	jmp    80105d49 <alltraps>

80106499 <vector66>:
.globl vector66
vector66:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $66
8010649b:	6a 42                	push   $0x42
  jmp alltraps
8010649d:	e9 a7 f8 ff ff       	jmp    80105d49 <alltraps>

801064a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $67
801064a4:	6a 43                	push   $0x43
  jmp alltraps
801064a6:	e9 9e f8 ff ff       	jmp    80105d49 <alltraps>

801064ab <vector68>:
.globl vector68
vector68:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $68
801064ad:	6a 44                	push   $0x44
  jmp alltraps
801064af:	e9 95 f8 ff ff       	jmp    80105d49 <alltraps>

801064b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $69
801064b6:	6a 45                	push   $0x45
  jmp alltraps
801064b8:	e9 8c f8 ff ff       	jmp    80105d49 <alltraps>

801064bd <vector70>:
.globl vector70
vector70:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $70
801064bf:	6a 46                	push   $0x46
  jmp alltraps
801064c1:	e9 83 f8 ff ff       	jmp    80105d49 <alltraps>

801064c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $71
801064c8:	6a 47                	push   $0x47
  jmp alltraps
801064ca:	e9 7a f8 ff ff       	jmp    80105d49 <alltraps>

801064cf <vector72>:
.globl vector72
vector72:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $72
801064d1:	6a 48                	push   $0x48
  jmp alltraps
801064d3:	e9 71 f8 ff ff       	jmp    80105d49 <alltraps>

801064d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $73
801064da:	6a 49                	push   $0x49
  jmp alltraps
801064dc:	e9 68 f8 ff ff       	jmp    80105d49 <alltraps>

801064e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $74
801064e3:	6a 4a                	push   $0x4a
  jmp alltraps
801064e5:	e9 5f f8 ff ff       	jmp    80105d49 <alltraps>

801064ea <vector75>:
.globl vector75
vector75:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $75
801064ec:	6a 4b                	push   $0x4b
  jmp alltraps
801064ee:	e9 56 f8 ff ff       	jmp    80105d49 <alltraps>

801064f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $76
801064f5:	6a 4c                	push   $0x4c
  jmp alltraps
801064f7:	e9 4d f8 ff ff       	jmp    80105d49 <alltraps>

801064fc <vector77>:
.globl vector77
vector77:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $77
801064fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106500:	e9 44 f8 ff ff       	jmp    80105d49 <alltraps>

80106505 <vector78>:
.globl vector78
vector78:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $78
80106507:	6a 4e                	push   $0x4e
  jmp alltraps
80106509:	e9 3b f8 ff ff       	jmp    80105d49 <alltraps>

8010650e <vector79>:
.globl vector79
vector79:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $79
80106510:	6a 4f                	push   $0x4f
  jmp alltraps
80106512:	e9 32 f8 ff ff       	jmp    80105d49 <alltraps>

80106517 <vector80>:
.globl vector80
vector80:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $80
80106519:	6a 50                	push   $0x50
  jmp alltraps
8010651b:	e9 29 f8 ff ff       	jmp    80105d49 <alltraps>

80106520 <vector81>:
.globl vector81
vector81:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $81
80106522:	6a 51                	push   $0x51
  jmp alltraps
80106524:	e9 20 f8 ff ff       	jmp    80105d49 <alltraps>

80106529 <vector82>:
.globl vector82
vector82:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $82
8010652b:	6a 52                	push   $0x52
  jmp alltraps
8010652d:	e9 17 f8 ff ff       	jmp    80105d49 <alltraps>

80106532 <vector83>:
.globl vector83
vector83:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $83
80106534:	6a 53                	push   $0x53
  jmp alltraps
80106536:	e9 0e f8 ff ff       	jmp    80105d49 <alltraps>

8010653b <vector84>:
.globl vector84
vector84:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $84
8010653d:	6a 54                	push   $0x54
  jmp alltraps
8010653f:	e9 05 f8 ff ff       	jmp    80105d49 <alltraps>

80106544 <vector85>:
.globl vector85
vector85:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $85
80106546:	6a 55                	push   $0x55
  jmp alltraps
80106548:	e9 fc f7 ff ff       	jmp    80105d49 <alltraps>

8010654d <vector86>:
.globl vector86
vector86:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $86
8010654f:	6a 56                	push   $0x56
  jmp alltraps
80106551:	e9 f3 f7 ff ff       	jmp    80105d49 <alltraps>

80106556 <vector87>:
.globl vector87
vector87:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $87
80106558:	6a 57                	push   $0x57
  jmp alltraps
8010655a:	e9 ea f7 ff ff       	jmp    80105d49 <alltraps>

8010655f <vector88>:
.globl vector88
vector88:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $88
80106561:	6a 58                	push   $0x58
  jmp alltraps
80106563:	e9 e1 f7 ff ff       	jmp    80105d49 <alltraps>

80106568 <vector89>:
.globl vector89
vector89:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $89
8010656a:	6a 59                	push   $0x59
  jmp alltraps
8010656c:	e9 d8 f7 ff ff       	jmp    80105d49 <alltraps>

80106571 <vector90>:
.globl vector90
vector90:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $90
80106573:	6a 5a                	push   $0x5a
  jmp alltraps
80106575:	e9 cf f7 ff ff       	jmp    80105d49 <alltraps>

8010657a <vector91>:
.globl vector91
vector91:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $91
8010657c:	6a 5b                	push   $0x5b
  jmp alltraps
8010657e:	e9 c6 f7 ff ff       	jmp    80105d49 <alltraps>

80106583 <vector92>:
.globl vector92
vector92:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $92
80106585:	6a 5c                	push   $0x5c
  jmp alltraps
80106587:	e9 bd f7 ff ff       	jmp    80105d49 <alltraps>

8010658c <vector93>:
.globl vector93
vector93:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $93
8010658e:	6a 5d                	push   $0x5d
  jmp alltraps
80106590:	e9 b4 f7 ff ff       	jmp    80105d49 <alltraps>

80106595 <vector94>:
.globl vector94
vector94:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $94
80106597:	6a 5e                	push   $0x5e
  jmp alltraps
80106599:	e9 ab f7 ff ff       	jmp    80105d49 <alltraps>

8010659e <vector95>:
.globl vector95
vector95:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $95
801065a0:	6a 5f                	push   $0x5f
  jmp alltraps
801065a2:	e9 a2 f7 ff ff       	jmp    80105d49 <alltraps>

801065a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $96
801065a9:	6a 60                	push   $0x60
  jmp alltraps
801065ab:	e9 99 f7 ff ff       	jmp    80105d49 <alltraps>

801065b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $97
801065b2:	6a 61                	push   $0x61
  jmp alltraps
801065b4:	e9 90 f7 ff ff       	jmp    80105d49 <alltraps>

801065b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $98
801065bb:	6a 62                	push   $0x62
  jmp alltraps
801065bd:	e9 87 f7 ff ff       	jmp    80105d49 <alltraps>

801065c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $99
801065c4:	6a 63                	push   $0x63
  jmp alltraps
801065c6:	e9 7e f7 ff ff       	jmp    80105d49 <alltraps>

801065cb <vector100>:
.globl vector100
vector100:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $100
801065cd:	6a 64                	push   $0x64
  jmp alltraps
801065cf:	e9 75 f7 ff ff       	jmp    80105d49 <alltraps>

801065d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $101
801065d6:	6a 65                	push   $0x65
  jmp alltraps
801065d8:	e9 6c f7 ff ff       	jmp    80105d49 <alltraps>

801065dd <vector102>:
.globl vector102
vector102:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $102
801065df:	6a 66                	push   $0x66
  jmp alltraps
801065e1:	e9 63 f7 ff ff       	jmp    80105d49 <alltraps>

801065e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $103
801065e8:	6a 67                	push   $0x67
  jmp alltraps
801065ea:	e9 5a f7 ff ff       	jmp    80105d49 <alltraps>

801065ef <vector104>:
.globl vector104
vector104:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $104
801065f1:	6a 68                	push   $0x68
  jmp alltraps
801065f3:	e9 51 f7 ff ff       	jmp    80105d49 <alltraps>

801065f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $105
801065fa:	6a 69                	push   $0x69
  jmp alltraps
801065fc:	e9 48 f7 ff ff       	jmp    80105d49 <alltraps>

80106601 <vector106>:
.globl vector106
vector106:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $106
80106603:	6a 6a                	push   $0x6a
  jmp alltraps
80106605:	e9 3f f7 ff ff       	jmp    80105d49 <alltraps>

8010660a <vector107>:
.globl vector107
vector107:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $107
8010660c:	6a 6b                	push   $0x6b
  jmp alltraps
8010660e:	e9 36 f7 ff ff       	jmp    80105d49 <alltraps>

80106613 <vector108>:
.globl vector108
vector108:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $108
80106615:	6a 6c                	push   $0x6c
  jmp alltraps
80106617:	e9 2d f7 ff ff       	jmp    80105d49 <alltraps>

8010661c <vector109>:
.globl vector109
vector109:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $109
8010661e:	6a 6d                	push   $0x6d
  jmp alltraps
80106620:	e9 24 f7 ff ff       	jmp    80105d49 <alltraps>

80106625 <vector110>:
.globl vector110
vector110:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $110
80106627:	6a 6e                	push   $0x6e
  jmp alltraps
80106629:	e9 1b f7 ff ff       	jmp    80105d49 <alltraps>

8010662e <vector111>:
.globl vector111
vector111:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $111
80106630:	6a 6f                	push   $0x6f
  jmp alltraps
80106632:	e9 12 f7 ff ff       	jmp    80105d49 <alltraps>

80106637 <vector112>:
.globl vector112
vector112:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $112
80106639:	6a 70                	push   $0x70
  jmp alltraps
8010663b:	e9 09 f7 ff ff       	jmp    80105d49 <alltraps>

80106640 <vector113>:
.globl vector113
vector113:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $113
80106642:	6a 71                	push   $0x71
  jmp alltraps
80106644:	e9 00 f7 ff ff       	jmp    80105d49 <alltraps>

80106649 <vector114>:
.globl vector114
vector114:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $114
8010664b:	6a 72                	push   $0x72
  jmp alltraps
8010664d:	e9 f7 f6 ff ff       	jmp    80105d49 <alltraps>

80106652 <vector115>:
.globl vector115
vector115:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $115
80106654:	6a 73                	push   $0x73
  jmp alltraps
80106656:	e9 ee f6 ff ff       	jmp    80105d49 <alltraps>

8010665b <vector116>:
.globl vector116
vector116:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $116
8010665d:	6a 74                	push   $0x74
  jmp alltraps
8010665f:	e9 e5 f6 ff ff       	jmp    80105d49 <alltraps>

80106664 <vector117>:
.globl vector117
vector117:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $117
80106666:	6a 75                	push   $0x75
  jmp alltraps
80106668:	e9 dc f6 ff ff       	jmp    80105d49 <alltraps>

8010666d <vector118>:
.globl vector118
vector118:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $118
8010666f:	6a 76                	push   $0x76
  jmp alltraps
80106671:	e9 d3 f6 ff ff       	jmp    80105d49 <alltraps>

80106676 <vector119>:
.globl vector119
vector119:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $119
80106678:	6a 77                	push   $0x77
  jmp alltraps
8010667a:	e9 ca f6 ff ff       	jmp    80105d49 <alltraps>

8010667f <vector120>:
.globl vector120
vector120:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $120
80106681:	6a 78                	push   $0x78
  jmp alltraps
80106683:	e9 c1 f6 ff ff       	jmp    80105d49 <alltraps>

80106688 <vector121>:
.globl vector121
vector121:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $121
8010668a:	6a 79                	push   $0x79
  jmp alltraps
8010668c:	e9 b8 f6 ff ff       	jmp    80105d49 <alltraps>

80106691 <vector122>:
.globl vector122
vector122:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $122
80106693:	6a 7a                	push   $0x7a
  jmp alltraps
80106695:	e9 af f6 ff ff       	jmp    80105d49 <alltraps>

8010669a <vector123>:
.globl vector123
vector123:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $123
8010669c:	6a 7b                	push   $0x7b
  jmp alltraps
8010669e:	e9 a6 f6 ff ff       	jmp    80105d49 <alltraps>

801066a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $124
801066a5:	6a 7c                	push   $0x7c
  jmp alltraps
801066a7:	e9 9d f6 ff ff       	jmp    80105d49 <alltraps>

801066ac <vector125>:
.globl vector125
vector125:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $125
801066ae:	6a 7d                	push   $0x7d
  jmp alltraps
801066b0:	e9 94 f6 ff ff       	jmp    80105d49 <alltraps>

801066b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $126
801066b7:	6a 7e                	push   $0x7e
  jmp alltraps
801066b9:	e9 8b f6 ff ff       	jmp    80105d49 <alltraps>

801066be <vector127>:
.globl vector127
vector127:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $127
801066c0:	6a 7f                	push   $0x7f
  jmp alltraps
801066c2:	e9 82 f6 ff ff       	jmp    80105d49 <alltraps>

801066c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $128
801066c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801066ce:	e9 76 f6 ff ff       	jmp    80105d49 <alltraps>

801066d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $129
801066d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801066da:	e9 6a f6 ff ff       	jmp    80105d49 <alltraps>

801066df <vector130>:
.globl vector130
vector130:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $130
801066e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066e6:	e9 5e f6 ff ff       	jmp    80105d49 <alltraps>

801066eb <vector131>:
.globl vector131
vector131:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $131
801066ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066f2:	e9 52 f6 ff ff       	jmp    80105d49 <alltraps>

801066f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $132
801066f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066fe:	e9 46 f6 ff ff       	jmp    80105d49 <alltraps>

80106703 <vector133>:
.globl vector133
vector133:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $133
80106705:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010670a:	e9 3a f6 ff ff       	jmp    80105d49 <alltraps>

8010670f <vector134>:
.globl vector134
vector134:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $134
80106711:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106716:	e9 2e f6 ff ff       	jmp    80105d49 <alltraps>

8010671b <vector135>:
.globl vector135
vector135:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $135
8010671d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106722:	e9 22 f6 ff ff       	jmp    80105d49 <alltraps>

80106727 <vector136>:
.globl vector136
vector136:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $136
80106729:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010672e:	e9 16 f6 ff ff       	jmp    80105d49 <alltraps>

80106733 <vector137>:
.globl vector137
vector137:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $137
80106735:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010673a:	e9 0a f6 ff ff       	jmp    80105d49 <alltraps>

8010673f <vector138>:
.globl vector138
vector138:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $138
80106741:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106746:	e9 fe f5 ff ff       	jmp    80105d49 <alltraps>

8010674b <vector139>:
.globl vector139
vector139:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $139
8010674d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106752:	e9 f2 f5 ff ff       	jmp    80105d49 <alltraps>

80106757 <vector140>:
.globl vector140
vector140:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $140
80106759:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010675e:	e9 e6 f5 ff ff       	jmp    80105d49 <alltraps>

80106763 <vector141>:
.globl vector141
vector141:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $141
80106765:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010676a:	e9 da f5 ff ff       	jmp    80105d49 <alltraps>

8010676f <vector142>:
.globl vector142
vector142:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $142
80106771:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106776:	e9 ce f5 ff ff       	jmp    80105d49 <alltraps>

8010677b <vector143>:
.globl vector143
vector143:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $143
8010677d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106782:	e9 c2 f5 ff ff       	jmp    80105d49 <alltraps>

80106787 <vector144>:
.globl vector144
vector144:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $144
80106789:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010678e:	e9 b6 f5 ff ff       	jmp    80105d49 <alltraps>

80106793 <vector145>:
.globl vector145
vector145:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $145
80106795:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010679a:	e9 aa f5 ff ff       	jmp    80105d49 <alltraps>

8010679f <vector146>:
.globl vector146
vector146:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $146
801067a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067a6:	e9 9e f5 ff ff       	jmp    80105d49 <alltraps>

801067ab <vector147>:
.globl vector147
vector147:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $147
801067ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801067b2:	e9 92 f5 ff ff       	jmp    80105d49 <alltraps>

801067b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $148
801067b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801067be:	e9 86 f5 ff ff       	jmp    80105d49 <alltraps>

801067c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $149
801067c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801067ca:	e9 7a f5 ff ff       	jmp    80105d49 <alltraps>

801067cf <vector150>:
.globl vector150
vector150:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $150
801067d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801067d6:	e9 6e f5 ff ff       	jmp    80105d49 <alltraps>

801067db <vector151>:
.globl vector151
vector151:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $151
801067dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067e2:	e9 62 f5 ff ff       	jmp    80105d49 <alltraps>

801067e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $152
801067e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ee:	e9 56 f5 ff ff       	jmp    80105d49 <alltraps>

801067f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $153
801067f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067fa:	e9 4a f5 ff ff       	jmp    80105d49 <alltraps>

801067ff <vector154>:
.globl vector154
vector154:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $154
80106801:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106806:	e9 3e f5 ff ff       	jmp    80105d49 <alltraps>

8010680b <vector155>:
.globl vector155
vector155:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $155
8010680d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106812:	e9 32 f5 ff ff       	jmp    80105d49 <alltraps>

80106817 <vector156>:
.globl vector156
vector156:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $156
80106819:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010681e:	e9 26 f5 ff ff       	jmp    80105d49 <alltraps>

80106823 <vector157>:
.globl vector157
vector157:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $157
80106825:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010682a:	e9 1a f5 ff ff       	jmp    80105d49 <alltraps>

8010682f <vector158>:
.globl vector158
vector158:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $158
80106831:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106836:	e9 0e f5 ff ff       	jmp    80105d49 <alltraps>

8010683b <vector159>:
.globl vector159
vector159:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $159
8010683d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106842:	e9 02 f5 ff ff       	jmp    80105d49 <alltraps>

80106847 <vector160>:
.globl vector160
vector160:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $160
80106849:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010684e:	e9 f6 f4 ff ff       	jmp    80105d49 <alltraps>

80106853 <vector161>:
.globl vector161
vector161:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $161
80106855:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010685a:	e9 ea f4 ff ff       	jmp    80105d49 <alltraps>

8010685f <vector162>:
.globl vector162
vector162:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $162
80106861:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106866:	e9 de f4 ff ff       	jmp    80105d49 <alltraps>

8010686b <vector163>:
.globl vector163
vector163:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $163
8010686d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106872:	e9 d2 f4 ff ff       	jmp    80105d49 <alltraps>

80106877 <vector164>:
.globl vector164
vector164:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $164
80106879:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010687e:	e9 c6 f4 ff ff       	jmp    80105d49 <alltraps>

80106883 <vector165>:
.globl vector165
vector165:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $165
80106885:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010688a:	e9 ba f4 ff ff       	jmp    80105d49 <alltraps>

8010688f <vector166>:
.globl vector166
vector166:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $166
80106891:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106896:	e9 ae f4 ff ff       	jmp    80105d49 <alltraps>

8010689b <vector167>:
.globl vector167
vector167:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $167
8010689d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068a2:	e9 a2 f4 ff ff       	jmp    80105d49 <alltraps>

801068a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $168
801068a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068ae:	e9 96 f4 ff ff       	jmp    80105d49 <alltraps>

801068b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $169
801068b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801068ba:	e9 8a f4 ff ff       	jmp    80105d49 <alltraps>

801068bf <vector170>:
.globl vector170
vector170:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $170
801068c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801068c6:	e9 7e f4 ff ff       	jmp    80105d49 <alltraps>

801068cb <vector171>:
.globl vector171
vector171:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $171
801068cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801068d2:	e9 72 f4 ff ff       	jmp    80105d49 <alltraps>

801068d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $172
801068d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801068de:	e9 66 f4 ff ff       	jmp    80105d49 <alltraps>

801068e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $173
801068e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068ea:	e9 5a f4 ff ff       	jmp    80105d49 <alltraps>

801068ef <vector174>:
.globl vector174
vector174:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $174
801068f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068f6:	e9 4e f4 ff ff       	jmp    80105d49 <alltraps>

801068fb <vector175>:
.globl vector175
vector175:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $175
801068fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106902:	e9 42 f4 ff ff       	jmp    80105d49 <alltraps>

80106907 <vector176>:
.globl vector176
vector176:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $176
80106909:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010690e:	e9 36 f4 ff ff       	jmp    80105d49 <alltraps>

80106913 <vector177>:
.globl vector177
vector177:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $177
80106915:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010691a:	e9 2a f4 ff ff       	jmp    80105d49 <alltraps>

8010691f <vector178>:
.globl vector178
vector178:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $178
80106921:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106926:	e9 1e f4 ff ff       	jmp    80105d49 <alltraps>

8010692b <vector179>:
.globl vector179
vector179:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $179
8010692d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106932:	e9 12 f4 ff ff       	jmp    80105d49 <alltraps>

80106937 <vector180>:
.globl vector180
vector180:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $180
80106939:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010693e:	e9 06 f4 ff ff       	jmp    80105d49 <alltraps>

80106943 <vector181>:
.globl vector181
vector181:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $181
80106945:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010694a:	e9 fa f3 ff ff       	jmp    80105d49 <alltraps>

8010694f <vector182>:
.globl vector182
vector182:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $182
80106951:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106956:	e9 ee f3 ff ff       	jmp    80105d49 <alltraps>

8010695b <vector183>:
.globl vector183
vector183:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $183
8010695d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106962:	e9 e2 f3 ff ff       	jmp    80105d49 <alltraps>

80106967 <vector184>:
.globl vector184
vector184:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $184
80106969:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010696e:	e9 d6 f3 ff ff       	jmp    80105d49 <alltraps>

80106973 <vector185>:
.globl vector185
vector185:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $185
80106975:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010697a:	e9 ca f3 ff ff       	jmp    80105d49 <alltraps>

8010697f <vector186>:
.globl vector186
vector186:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $186
80106981:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106986:	e9 be f3 ff ff       	jmp    80105d49 <alltraps>

8010698b <vector187>:
.globl vector187
vector187:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $187
8010698d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106992:	e9 b2 f3 ff ff       	jmp    80105d49 <alltraps>

80106997 <vector188>:
.globl vector188
vector188:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $188
80106999:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010699e:	e9 a6 f3 ff ff       	jmp    80105d49 <alltraps>

801069a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $189
801069a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069aa:	e9 9a f3 ff ff       	jmp    80105d49 <alltraps>

801069af <vector190>:
.globl vector190
vector190:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $190
801069b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801069b6:	e9 8e f3 ff ff       	jmp    80105d49 <alltraps>

801069bb <vector191>:
.globl vector191
vector191:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $191
801069bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801069c2:	e9 82 f3 ff ff       	jmp    80105d49 <alltraps>

801069c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $192
801069c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801069ce:	e9 76 f3 ff ff       	jmp    80105d49 <alltraps>

801069d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $193
801069d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801069da:	e9 6a f3 ff ff       	jmp    80105d49 <alltraps>

801069df <vector194>:
.globl vector194
vector194:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $194
801069e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069e6:	e9 5e f3 ff ff       	jmp    80105d49 <alltraps>

801069eb <vector195>:
.globl vector195
vector195:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $195
801069ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069f2:	e9 52 f3 ff ff       	jmp    80105d49 <alltraps>

801069f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $196
801069f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069fe:	e9 46 f3 ff ff       	jmp    80105d49 <alltraps>

80106a03 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $197
80106a05:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a0a:	e9 3a f3 ff ff       	jmp    80105d49 <alltraps>

80106a0f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $198
80106a11:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a16:	e9 2e f3 ff ff       	jmp    80105d49 <alltraps>

80106a1b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $199
80106a1d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a22:	e9 22 f3 ff ff       	jmp    80105d49 <alltraps>

80106a27 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $200
80106a29:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a2e:	e9 16 f3 ff ff       	jmp    80105d49 <alltraps>

80106a33 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $201
80106a35:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a3a:	e9 0a f3 ff ff       	jmp    80105d49 <alltraps>

80106a3f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $202
80106a41:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a46:	e9 fe f2 ff ff       	jmp    80105d49 <alltraps>

80106a4b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $203
80106a4d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a52:	e9 f2 f2 ff ff       	jmp    80105d49 <alltraps>

80106a57 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $204
80106a59:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a5e:	e9 e6 f2 ff ff       	jmp    80105d49 <alltraps>

80106a63 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $205
80106a65:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a6a:	e9 da f2 ff ff       	jmp    80105d49 <alltraps>

80106a6f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $206
80106a71:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a76:	e9 ce f2 ff ff       	jmp    80105d49 <alltraps>

80106a7b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $207
80106a7d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a82:	e9 c2 f2 ff ff       	jmp    80105d49 <alltraps>

80106a87 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $208
80106a89:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a8e:	e9 b6 f2 ff ff       	jmp    80105d49 <alltraps>

80106a93 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $209
80106a95:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a9a:	e9 aa f2 ff ff       	jmp    80105d49 <alltraps>

80106a9f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $210
80106aa1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106aa6:	e9 9e f2 ff ff       	jmp    80105d49 <alltraps>

80106aab <vector211>:
.globl vector211
vector211:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $211
80106aad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ab2:	e9 92 f2 ff ff       	jmp    80105d49 <alltraps>

80106ab7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $212
80106ab9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106abe:	e9 86 f2 ff ff       	jmp    80105d49 <alltraps>

80106ac3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $213
80106ac5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106aca:	e9 7a f2 ff ff       	jmp    80105d49 <alltraps>

80106acf <vector214>:
.globl vector214
vector214:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $214
80106ad1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ad6:	e9 6e f2 ff ff       	jmp    80105d49 <alltraps>

80106adb <vector215>:
.globl vector215
vector215:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $215
80106add:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ae2:	e9 62 f2 ff ff       	jmp    80105d49 <alltraps>

80106ae7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $216
80106ae9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aee:	e9 56 f2 ff ff       	jmp    80105d49 <alltraps>

80106af3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $217
80106af5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106afa:	e9 4a f2 ff ff       	jmp    80105d49 <alltraps>

80106aff <vector218>:
.globl vector218
vector218:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $218
80106b01:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b06:	e9 3e f2 ff ff       	jmp    80105d49 <alltraps>

80106b0b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $219
80106b0d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b12:	e9 32 f2 ff ff       	jmp    80105d49 <alltraps>

80106b17 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $220
80106b19:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b1e:	e9 26 f2 ff ff       	jmp    80105d49 <alltraps>

80106b23 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $221
80106b25:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b2a:	e9 1a f2 ff ff       	jmp    80105d49 <alltraps>

80106b2f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $222
80106b31:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b36:	e9 0e f2 ff ff       	jmp    80105d49 <alltraps>

80106b3b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $223
80106b3d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b42:	e9 02 f2 ff ff       	jmp    80105d49 <alltraps>

80106b47 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $224
80106b49:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b4e:	e9 f6 f1 ff ff       	jmp    80105d49 <alltraps>

80106b53 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $225
80106b55:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b5a:	e9 ea f1 ff ff       	jmp    80105d49 <alltraps>

80106b5f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $226
80106b61:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b66:	e9 de f1 ff ff       	jmp    80105d49 <alltraps>

80106b6b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $227
80106b6d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b72:	e9 d2 f1 ff ff       	jmp    80105d49 <alltraps>

80106b77 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $228
80106b79:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b7e:	e9 c6 f1 ff ff       	jmp    80105d49 <alltraps>

80106b83 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $229
80106b85:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b8a:	e9 ba f1 ff ff       	jmp    80105d49 <alltraps>

80106b8f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $230
80106b91:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b96:	e9 ae f1 ff ff       	jmp    80105d49 <alltraps>

80106b9b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $231
80106b9d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ba2:	e9 a2 f1 ff ff       	jmp    80105d49 <alltraps>

80106ba7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $232
80106ba9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bae:	e9 96 f1 ff ff       	jmp    80105d49 <alltraps>

80106bb3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $233
80106bb5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106bba:	e9 8a f1 ff ff       	jmp    80105d49 <alltraps>

80106bbf <vector234>:
.globl vector234
vector234:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $234
80106bc1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106bc6:	e9 7e f1 ff ff       	jmp    80105d49 <alltraps>

80106bcb <vector235>:
.globl vector235
vector235:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $235
80106bcd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106bd2:	e9 72 f1 ff ff       	jmp    80105d49 <alltraps>

80106bd7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $236
80106bd9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106bde:	e9 66 f1 ff ff       	jmp    80105d49 <alltraps>

80106be3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $237
80106be5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106bea:	e9 5a f1 ff ff       	jmp    80105d49 <alltraps>

80106bef <vector238>:
.globl vector238
vector238:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $238
80106bf1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bf6:	e9 4e f1 ff ff       	jmp    80105d49 <alltraps>

80106bfb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $239
80106bfd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c02:	e9 42 f1 ff ff       	jmp    80105d49 <alltraps>

80106c07 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $240
80106c09:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c0e:	e9 36 f1 ff ff       	jmp    80105d49 <alltraps>

80106c13 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $241
80106c15:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c1a:	e9 2a f1 ff ff       	jmp    80105d49 <alltraps>

80106c1f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $242
80106c21:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c26:	e9 1e f1 ff ff       	jmp    80105d49 <alltraps>

80106c2b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $243
80106c2d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c32:	e9 12 f1 ff ff       	jmp    80105d49 <alltraps>

80106c37 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $244
80106c39:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c3e:	e9 06 f1 ff ff       	jmp    80105d49 <alltraps>

80106c43 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $245
80106c45:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c4a:	e9 fa f0 ff ff       	jmp    80105d49 <alltraps>

80106c4f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $246
80106c51:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c56:	e9 ee f0 ff ff       	jmp    80105d49 <alltraps>

80106c5b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $247
80106c5d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c62:	e9 e2 f0 ff ff       	jmp    80105d49 <alltraps>

80106c67 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $248
80106c69:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c6e:	e9 d6 f0 ff ff       	jmp    80105d49 <alltraps>

80106c73 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $249
80106c75:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c7a:	e9 ca f0 ff ff       	jmp    80105d49 <alltraps>

80106c7f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $250
80106c81:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c86:	e9 be f0 ff ff       	jmp    80105d49 <alltraps>

80106c8b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $251
80106c8d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c92:	e9 b2 f0 ff ff       	jmp    80105d49 <alltraps>

80106c97 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $252
80106c99:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c9e:	e9 a6 f0 ff ff       	jmp    80105d49 <alltraps>

80106ca3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $253
80106ca5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106caa:	e9 9a f0 ff ff       	jmp    80105d49 <alltraps>

80106caf <vector254>:
.globl vector254
vector254:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $254
80106cb1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106cb6:	e9 8e f0 ff ff       	jmp    80105d49 <alltraps>

80106cbb <vector255>:
.globl vector255
vector255:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $255
80106cbd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106cc2:	e9 82 f0 ff ff       	jmp    80105d49 <alltraps>
80106cc7:	66 90                	xchg   %ax,%ax
80106cc9:	66 90                	xchg   %ax,%ax
80106ccb:	66 90                	xchg   %ax,%ax
80106ccd:	66 90                	xchg   %ax,%ax
80106ccf:	90                   	nop

80106cd0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106cd8:	c1 ea 16             	shr    $0x16,%edx
80106cdb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106cde:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106ce1:	8b 07                	mov    (%edi),%eax
80106ce3:	a8 01                	test   $0x1,%al
80106ce5:	74 29                	je     80106d10 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ce7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cec:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106cf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106cf5:	c1 eb 0a             	shr    $0xa,%ebx
80106cf8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106cfe:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106d01:	5b                   	pop    %ebx
80106d02:	5e                   	pop    %esi
80106d03:	5f                   	pop    %edi
80106d04:	5d                   	pop    %ebp
80106d05:	c3                   	ret    
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d10:	85 c9                	test   %ecx,%ecx
80106d12:	74 2c                	je     80106d40 <walkpgdir+0x70>
80106d14:	e8 77 b7 ff ff       	call   80102490 <kalloc>
80106d19:	85 c0                	test   %eax,%eax
80106d1b:	89 c6                	mov    %eax,%esi
80106d1d:	74 21                	je     80106d40 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106d1f:	83 ec 04             	sub    $0x4,%esp
80106d22:	68 00 10 00 00       	push   $0x1000
80106d27:	6a 00                	push   $0x0
80106d29:	50                   	push   %eax
80106d2a:	e8 11 de ff ff       	call   80104b40 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d2f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d35:	83 c4 10             	add    $0x10,%esp
80106d38:	83 c8 07             	or     $0x7,%eax
80106d3b:	89 07                	mov    %eax,(%edi)
80106d3d:	eb b3                	jmp    80106cf2 <walkpgdir+0x22>
80106d3f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106d40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106d43:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	57                   	push   %edi
80106d54:	56                   	push   %esi
80106d55:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d56:	89 d3                	mov    %edx,%ebx
80106d58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d5e:	83 ec 1c             	sub    $0x1c,%esp
80106d61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d64:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d76:	29 df                	sub    %ebx,%edi
80106d78:	83 c8 01             	or     $0x1,%eax
80106d7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d7e:	eb 15                	jmp    80106d95 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106d80:	f6 00 01             	testb  $0x1,(%eax)
80106d83:	75 45                	jne    80106dca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d85:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d88:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d8b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d8d:	74 31                	je     80106dc0 <mappages+0x70>
      break;
    a += PGSIZE;
80106d8f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d98:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d9d:	89 da                	mov    %ebx,%edx
80106d9f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106da2:	e8 29 ff ff ff       	call   80106cd0 <walkpgdir>
80106da7:	85 c0                	test   %eax,%eax
80106da9:	75 d5                	jne    80106d80 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dab:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5f                   	pop    %edi
80106db6:	5d                   	pop    %ebp
80106db7:	c3                   	ret    
80106db8:	90                   	nop
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106dc3:	31 c0                	xor    %eax,%eax
}
80106dc5:	5b                   	pop    %ebx
80106dc6:	5e                   	pop    %esi
80106dc7:	5f                   	pop    %edi
80106dc8:	5d                   	pop    %ebp
80106dc9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106dca:	83 ec 0c             	sub    $0xc,%esp
80106dcd:	68 0c 80 10 80       	push   $0x8010800c
80106dd2:	e8 99 95 ff ff       	call   80100370 <panic>
80106dd7:	89 f6                	mov    %esi,%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106de6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dec:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106dee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106df4:	83 ec 1c             	sub    $0x1c,%esp
80106df7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106dfa:	39 d3                	cmp    %edx,%ebx
80106dfc:	73 66                	jae    80106e64 <deallocuvm.part.0+0x84>
80106dfe:	89 d6                	mov    %edx,%esi
80106e00:	eb 3d                	jmp    80106e3f <deallocuvm.part.0+0x5f>
80106e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e08:	8b 10                	mov    (%eax),%edx
80106e0a:	f6 c2 01             	test   $0x1,%dl
80106e0d:	74 26                	je     80106e35 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e15:	74 58                	je     80106e6f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e17:	83 ec 0c             	sub    $0xc,%esp
80106e1a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e23:	52                   	push   %edx
80106e24:	e8 b7 b4 ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e2c:	83 c4 10             	add    $0x10,%esp
80106e2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e35:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e3b:	39 f3                	cmp    %esi,%ebx
80106e3d:	73 25                	jae    80106e64 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e3f:	31 c9                	xor    %ecx,%ecx
80106e41:	89 da                	mov    %ebx,%edx
80106e43:	89 f8                	mov    %edi,%eax
80106e45:	e8 86 fe ff ff       	call   80106cd0 <walkpgdir>
    if(!pte)
80106e4a:	85 c0                	test   %eax,%eax
80106e4c:	75 ba                	jne    80106e08 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e4e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e54:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e60:	39 f3                	cmp    %esi,%ebx
80106e62:	72 db                	jb     80106e3f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106e64:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e6a:	5b                   	pop    %ebx
80106e6b:	5e                   	pop    %esi
80106e6c:	5f                   	pop    %edi
80106e6d:	5d                   	pop    %ebp
80106e6e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106e6f:	83 ec 0c             	sub    $0xc,%esp
80106e72:	68 a6 78 10 80       	push   $0x801078a6
80106e77:	e8 f4 94 ff ff       	call   80100370 <panic>
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106e86:	e8 25 c9 ff ff       	call   801037b0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e8b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106e91:	31 c9                	xor    %ecx,%ecx
80106e93:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106e98:	66 89 90 18 3b 11 80 	mov    %dx,-0x7feec4e8(%eax)
80106e9f:	66 89 88 1a 3b 11 80 	mov    %cx,-0x7feec4e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ea6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106eab:	31 c9                	xor    %ecx,%ecx
80106ead:	66 89 90 20 3b 11 80 	mov    %dx,-0x7feec4e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106eb4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eb9:	66 89 88 22 3b 11 80 	mov    %cx,-0x7feec4de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106ec0:	31 c9                	xor    %ecx,%ecx
80106ec2:	66 89 90 28 3b 11 80 	mov    %dx,-0x7feec4d8(%eax)
80106ec9:	66 89 88 2a 3b 11 80 	mov    %cx,-0x7feec4d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ed0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ed5:	31 c9                	xor    %ecx,%ecx
80106ed7:	66 89 90 30 3b 11 80 	mov    %dx,-0x7feec4d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ede:	c6 80 1c 3b 11 80 00 	movb   $0x0,-0x7feec4e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106ee5:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106eea:	c6 80 1d 3b 11 80 9a 	movb   $0x9a,-0x7feec4e3(%eax)
80106ef1:	c6 80 1e 3b 11 80 cf 	movb   $0xcf,-0x7feec4e2(%eax)
80106ef8:	c6 80 1f 3b 11 80 00 	movb   $0x0,-0x7feec4e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eff:	c6 80 24 3b 11 80 00 	movb   $0x0,-0x7feec4dc(%eax)
80106f06:	c6 80 25 3b 11 80 92 	movb   $0x92,-0x7feec4db(%eax)
80106f0d:	c6 80 26 3b 11 80 cf 	movb   $0xcf,-0x7feec4da(%eax)
80106f14:	c6 80 27 3b 11 80 00 	movb   $0x0,-0x7feec4d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f1b:	c6 80 2c 3b 11 80 00 	movb   $0x0,-0x7feec4d4(%eax)
80106f22:	c6 80 2d 3b 11 80 fa 	movb   $0xfa,-0x7feec4d3(%eax)
80106f29:	c6 80 2e 3b 11 80 cf 	movb   $0xcf,-0x7feec4d2(%eax)
80106f30:	c6 80 2f 3b 11 80 00 	movb   $0x0,-0x7feec4d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f37:	66 89 88 32 3b 11 80 	mov    %cx,-0x7feec4ce(%eax)
80106f3e:	c6 80 34 3b 11 80 00 	movb   $0x0,-0x7feec4cc(%eax)
80106f45:	c6 80 35 3b 11 80 f2 	movb   $0xf2,-0x7feec4cb(%eax)
80106f4c:	c6 80 36 3b 11 80 cf 	movb   $0xcf,-0x7feec4ca(%eax)
80106f53:	c6 80 37 3b 11 80 00 	movb   $0x0,-0x7feec4c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106f5a:	05 10 3b 11 80       	add    $0x80113b10,%eax
80106f5f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106f63:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f67:	c1 e8 10             	shr    $0x10,%eax
80106f6a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106f6e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f71:	0f 01 10             	lgdtl  (%eax)
}
80106f74:	c9                   	leave  
80106f75:	c3                   	ret    
80106f76:	8d 76 00             	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f80 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f80:	a1 c4 6c 11 80       	mov    0x80116cc4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106f85:	55                   	push   %ebp
80106f86:	89 e5                	mov    %esp,%ebp
80106f88:	05 00 00 00 80       	add    $0x80000000,%eax
80106f8d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
80106f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 1c             	sub    $0x1c,%esp
80106fa9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106fac:	85 f6                	test   %esi,%esi
80106fae:	0f 84 cd 00 00 00    	je     80107081 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106fb4:	8b 46 08             	mov    0x8(%esi),%eax
80106fb7:	85 c0                	test   %eax,%eax
80106fb9:	0f 84 dc 00 00 00    	je     8010709b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106fbf:	8b 7e 04             	mov    0x4(%esi),%edi
80106fc2:	85 ff                	test   %edi,%edi
80106fc4:	0f 84 c4 00 00 00    	je     8010708e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106fca:	e8 c1 d9 ff ff       	call   80104990 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fcf:	e8 5c c7 ff ff       	call   80103730 <mycpu>
80106fd4:	89 c3                	mov    %eax,%ebx
80106fd6:	e8 55 c7 ff ff       	call   80103730 <mycpu>
80106fdb:	89 c7                	mov    %eax,%edi
80106fdd:	e8 4e c7 ff ff       	call   80103730 <mycpu>
80106fe2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fe5:	83 c7 08             	add    $0x8,%edi
80106fe8:	e8 43 c7 ff ff       	call   80103730 <mycpu>
80106fed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ff0:	83 c0 08             	add    $0x8,%eax
80106ff3:	ba 67 00 00 00       	mov    $0x67,%edx
80106ff8:	c1 e8 18             	shr    $0x18,%eax
80106ffb:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107002:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107009:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107010:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107017:	83 c1 08             	add    $0x8,%ecx
8010701a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107020:	c1 e9 10             	shr    $0x10,%ecx
80107023:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107029:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010702e:	e8 fd c6 ff ff       	call   80103730 <mycpu>
80107033:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010703a:	e8 f1 c6 ff ff       	call   80103730 <mycpu>
8010703f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107044:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107048:	e8 e3 c6 ff ff       	call   80103730 <mycpu>
8010704d:	8b 56 08             	mov    0x8(%esi),%edx
80107050:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107056:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107059:	e8 d2 c6 ff ff       	call   80103730 <mycpu>
8010705e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107062:	b8 28 00 00 00       	mov    $0x28,%eax
80107067:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010706a:	8b 46 04             	mov    0x4(%esi),%eax
8010706d:	05 00 00 00 80       	add    $0x80000000,%eax
80107072:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107075:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107078:	5b                   	pop    %ebx
80107079:	5e                   	pop    %esi
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010707c:	e9 ff d9 ff ff       	jmp    80104a80 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107081:	83 ec 0c             	sub    $0xc,%esp
80107084:	68 12 80 10 80       	push   $0x80108012
80107089:	e8 e2 92 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010708e:	83 ec 0c             	sub    $0xc,%esp
80107091:	68 3d 80 10 80       	push   $0x8010803d
80107096:	e8 d5 92 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010709b:	83 ec 0c             	sub    $0xc,%esp
8010709e:	68 28 80 10 80       	push   $0x80108028
801070a3:	e8 c8 92 ff ff       	call   80100370 <panic>
801070a8:	90                   	nop
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070b0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 1c             	sub    $0x1c,%esp
801070b9:	8b 75 10             	mov    0x10(%ebp),%esi
801070bc:	8b 45 08             	mov    0x8(%ebp),%eax
801070bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801070c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801070c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801070cb:	77 49                	ja     80107116 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801070cd:	e8 be b3 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801070d2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801070d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801070d7:	68 00 10 00 00       	push   $0x1000
801070dc:	6a 00                	push   $0x0
801070de:	50                   	push   %eax
801070df:	e8 5c da ff ff       	call   80104b40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070e4:	58                   	pop    %eax
801070e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070f0:	5a                   	pop    %edx
801070f1:	6a 06                	push   $0x6
801070f3:	50                   	push   %eax
801070f4:	31 d2                	xor    %edx,%edx
801070f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070f9:	e8 52 fc ff ff       	call   80106d50 <mappages>
  memmove(mem, init, sz);
801070fe:	89 75 10             	mov    %esi,0x10(%ebp)
80107101:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107104:	83 c4 10             	add    $0x10,%esp
80107107:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010710a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010710d:	5b                   	pop    %ebx
8010710e:	5e                   	pop    %esi
8010710f:	5f                   	pop    %edi
80107110:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107111:	e9 da da ff ff       	jmp    80104bf0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107116:	83 ec 0c             	sub    $0xc,%esp
80107119:	68 51 80 10 80       	push   $0x80108051
8010711e:	e8 4d 92 ff ff       	call   80100370 <panic>
80107123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107130 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107139:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107140:	0f 85 91 00 00 00    	jne    801071d7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107146:	8b 75 18             	mov    0x18(%ebp),%esi
80107149:	31 db                	xor    %ebx,%ebx
8010714b:	85 f6                	test   %esi,%esi
8010714d:	75 1a                	jne    80107169 <loaduvm+0x39>
8010714f:	eb 6f                	jmp    801071c0 <loaduvm+0x90>
80107151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107158:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010715e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107164:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107167:	76 57                	jbe    801071c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107169:	8b 55 0c             	mov    0xc(%ebp),%edx
8010716c:	8b 45 08             	mov    0x8(%ebp),%eax
8010716f:	31 c9                	xor    %ecx,%ecx
80107171:	01 da                	add    %ebx,%edx
80107173:	e8 58 fb ff ff       	call   80106cd0 <walkpgdir>
80107178:	85 c0                	test   %eax,%eax
8010717a:	74 4e                	je     801071ca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010717c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010717e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107181:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107186:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010718b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107191:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107194:	01 d9                	add    %ebx,%ecx
80107196:	05 00 00 00 80       	add    $0x80000000,%eax
8010719b:	57                   	push   %edi
8010719c:	51                   	push   %ecx
8010719d:	50                   	push   %eax
8010719e:	ff 75 10             	pushl  0x10(%ebp)
801071a1:	e8 aa a7 ff ff       	call   80101950 <readi>
801071a6:	83 c4 10             	add    $0x10,%esp
801071a9:	39 c7                	cmp    %eax,%edi
801071ab:	74 ab                	je     80107158 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801071b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801071b5:	5b                   	pop    %ebx
801071b6:	5e                   	pop    %esi
801071b7:	5f                   	pop    %edi
801071b8:	5d                   	pop    %ebp
801071b9:	c3                   	ret    
801071ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801071c3:	31 c0                	xor    %eax,%eax
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801071ca:	83 ec 0c             	sub    $0xc,%esp
801071cd:	68 6b 80 10 80       	push   $0x8010806b
801071d2:	e8 99 91 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801071d7:	83 ec 0c             	sub    $0xc,%esp
801071da:	68 0c 81 10 80       	push   $0x8010810c
801071df:	e8 8c 91 ff ff       	call   80100370 <panic>
801071e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071f0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801071f0:	55                   	push   %ebp
801071f1:	89 e5                	mov    %esp,%ebp
801071f3:	57                   	push   %edi
801071f4:	56                   	push   %esi
801071f5:	53                   	push   %ebx
801071f6:	83 ec 0c             	sub    $0xc,%esp
801071f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801071fc:	85 ff                	test   %edi,%edi
801071fe:	0f 88 ca 00 00 00    	js     801072ce <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107204:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107207:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010720a:	0f 82 82 00 00 00    	jb     80107292 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107210:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107216:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010721c:	39 df                	cmp    %ebx,%edi
8010721e:	77 43                	ja     80107263 <allocuvm+0x73>
80107220:	e9 bb 00 00 00       	jmp    801072e0 <allocuvm+0xf0>
80107225:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107228:	83 ec 04             	sub    $0x4,%esp
8010722b:	68 00 10 00 00       	push   $0x1000
80107230:	6a 00                	push   $0x0
80107232:	50                   	push   %eax
80107233:	e8 08 d9 ff ff       	call   80104b40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107238:	58                   	pop    %eax
80107239:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010723f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107244:	5a                   	pop    %edx
80107245:	6a 06                	push   $0x6
80107247:	50                   	push   %eax
80107248:	89 da                	mov    %ebx,%edx
8010724a:	8b 45 08             	mov    0x8(%ebp),%eax
8010724d:	e8 fe fa ff ff       	call   80106d50 <mappages>
80107252:	83 c4 10             	add    $0x10,%esp
80107255:	85 c0                	test   %eax,%eax
80107257:	78 47                	js     801072a0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107259:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010725f:	39 df                	cmp    %ebx,%edi
80107261:	76 7d                	jbe    801072e0 <allocuvm+0xf0>
    mem = kalloc();
80107263:	e8 28 b2 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80107268:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010726a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010726c:	75 ba                	jne    80107228 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010726e:	83 ec 0c             	sub    $0xc,%esp
80107271:	68 89 80 10 80       	push   $0x80108089
80107276:	e8 e5 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010727b:	83 c4 10             	add    $0x10,%esp
8010727e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107281:	76 4b                	jbe    801072ce <allocuvm+0xde>
80107283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107286:	8b 45 08             	mov    0x8(%ebp),%eax
80107289:	89 fa                	mov    %edi,%edx
8010728b:	e8 50 fb ff ff       	call   80106de0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107290:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107295:	5b                   	pop    %ebx
80107296:	5e                   	pop    %esi
80107297:	5f                   	pop    %edi
80107298:	5d                   	pop    %ebp
80107299:	c3                   	ret    
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801072a0:	83 ec 0c             	sub    $0xc,%esp
801072a3:	68 a1 80 10 80       	push   $0x801080a1
801072a8:	e8 b3 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072ad:	83 c4 10             	add    $0x10,%esp
801072b0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801072b3:	76 0d                	jbe    801072c2 <allocuvm+0xd2>
801072b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072b8:	8b 45 08             	mov    0x8(%ebp),%eax
801072bb:	89 fa                	mov    %edi,%edx
801072bd:	e8 1e fb ff ff       	call   80106de0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801072c2:	83 ec 0c             	sub    $0xc,%esp
801072c5:	56                   	push   %esi
801072c6:	e8 15 b0 ff ff       	call   801022e0 <kfree>
      return 0;
801072cb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801072ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801072d1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801072d3:	5b                   	pop    %ebx
801072d4:	5e                   	pop    %esi
801072d5:	5f                   	pop    %edi
801072d6:	5d                   	pop    %ebp
801072d7:	c3                   	ret    
801072d8:	90                   	nop
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801072e3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801072f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801072f9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072fc:	39 d1                	cmp    %edx,%ecx
801072fe:	73 10                	jae    80107310 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107300:	5d                   	pop    %ebp
80107301:	e9 da fa ff ff       	jmp    80106de0 <deallocuvm.part.0>
80107306:	8d 76 00             	lea    0x0(%esi),%esi
80107309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107310:	89 d0                	mov    %edx,%eax
80107312:	5d                   	pop    %ebp
80107313:	c3                   	ret    
80107314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010731a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107320 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 0c             	sub    $0xc,%esp
80107329:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010732c:	85 f6                	test   %esi,%esi
8010732e:	74 59                	je     80107389 <freevm+0x69>
80107330:	31 c9                	xor    %ecx,%ecx
80107332:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107337:	89 f0                	mov    %esi,%eax
80107339:	e8 a2 fa ff ff       	call   80106de0 <deallocuvm.part.0>
8010733e:	89 f3                	mov    %esi,%ebx
80107340:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107346:	eb 0f                	jmp    80107357 <freevm+0x37>
80107348:	90                   	nop
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107350:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107353:	39 fb                	cmp    %edi,%ebx
80107355:	74 23                	je     8010737a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107357:	8b 03                	mov    (%ebx),%eax
80107359:	a8 01                	test   $0x1,%al
8010735b:	74 f3                	je     80107350 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010735d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107362:	83 ec 0c             	sub    $0xc,%esp
80107365:	83 c3 04             	add    $0x4,%ebx
80107368:	05 00 00 00 80       	add    $0x80000000,%eax
8010736d:	50                   	push   %eax
8010736e:	e8 6d af ff ff       	call   801022e0 <kfree>
80107373:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107376:	39 fb                	cmp    %edi,%ebx
80107378:	75 dd                	jne    80107357 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010737a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010737d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107380:	5b                   	pop    %ebx
80107381:	5e                   	pop    %esi
80107382:	5f                   	pop    %edi
80107383:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107384:	e9 57 af ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107389:	83 ec 0c             	sub    $0xc,%esp
8010738c:	68 bd 80 10 80       	push   $0x801080bd
80107391:	e8 da 8f ff ff       	call   80100370 <panic>
80107396:	8d 76 00             	lea    0x0(%esi),%esi
80107399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073a0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	56                   	push   %esi
801073a4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801073a5:	e8 e6 b0 ff ff       	call   80102490 <kalloc>
801073aa:	85 c0                	test   %eax,%eax
801073ac:	74 6a                	je     80107418 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801073ae:	83 ec 04             	sub    $0x4,%esp
801073b1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073b3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801073b8:	68 00 10 00 00       	push   $0x1000
801073bd:	6a 00                	push   $0x0
801073bf:	50                   	push   %eax
801073c0:	e8 7b d7 ff ff       	call   80104b40 <memset>
801073c5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073c8:	8b 43 04             	mov    0x4(%ebx),%eax
801073cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073ce:	83 ec 08             	sub    $0x8,%esp
801073d1:	8b 13                	mov    (%ebx),%edx
801073d3:	ff 73 0c             	pushl  0xc(%ebx)
801073d6:	50                   	push   %eax
801073d7:	29 c1                	sub    %eax,%ecx
801073d9:	89 f0                	mov    %esi,%eax
801073db:	e8 70 f9 ff ff       	call   80106d50 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	85 c0                	test   %eax,%eax
801073e5:	78 19                	js     80107400 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073e7:	83 c3 10             	add    $0x10,%ebx
801073ea:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801073f0:	75 d6                	jne    801073c8 <setupkvm+0x28>
801073f2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801073f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801073f7:	5b                   	pop    %ebx
801073f8:	5e                   	pop    %esi
801073f9:	5d                   	pop    %ebp
801073fa:	c3                   	ret    
801073fb:	90                   	nop
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107400:	83 ec 0c             	sub    $0xc,%esp
80107403:	56                   	push   %esi
80107404:	e8 17 ff ff ff       	call   80107320 <freevm>
      return 0;
80107409:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010740c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010740f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107411:	5b                   	pop    %ebx
80107412:	5e                   	pop    %esi
80107413:	5d                   	pop    %ebp
80107414:	c3                   	ret    
80107415:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107418:	31 c0                	xor    %eax,%eax
8010741a:	eb d8                	jmp    801073f4 <setupkvm+0x54>
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107420 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107426:	e8 75 ff ff ff       	call   801073a0 <setupkvm>
8010742b:	a3 c4 6c 11 80       	mov    %eax,0x80116cc4
80107430:	05 00 00 00 80       	add    $0x80000000,%eax
80107435:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107438:	c9                   	leave  
80107439:	c3                   	ret    
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107440 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107441:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107443:	89 e5                	mov    %esp,%ebp
80107445:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744b:	8b 45 08             	mov    0x8(%ebp),%eax
8010744e:	e8 7d f8 ff ff       	call   80106cd0 <walkpgdir>
  if(pte == 0)
80107453:	85 c0                	test   %eax,%eax
80107455:	74 05                	je     8010745c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107457:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010745a:	c9                   	leave  
8010745b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	68 ce 80 10 80       	push   $0x801080ce
80107464:	e8 07 8f ff ff       	call   80100370 <panic>
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107470 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107479:	e8 22 ff ff ff       	call   801073a0 <setupkvm>
8010747e:	85 c0                	test   %eax,%eax
80107480:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107483:	0f 84 b2 00 00 00    	je     8010753b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107489:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010748c:	85 c9                	test   %ecx,%ecx
8010748e:	0f 84 9c 00 00 00    	je     80107530 <copyuvm+0xc0>
80107494:	31 f6                	xor    %esi,%esi
80107496:	eb 4a                	jmp    801074e2 <copyuvm+0x72>
80107498:	90                   	nop
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074a0:	83 ec 04             	sub    $0x4,%esp
801074a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074a9:	68 00 10 00 00       	push   $0x1000
801074ae:	57                   	push   %edi
801074af:	50                   	push   %eax
801074b0:	e8 3b d7 ff ff       	call   80104bf0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801074b5:	58                   	pop    %eax
801074b6:	5a                   	pop    %edx
801074b7:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
801074bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801074c3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074c8:	52                   	push   %edx
801074c9:	89 f2                	mov    %esi,%edx
801074cb:	e8 80 f8 ff ff       	call   80106d50 <mappages>
801074d0:	83 c4 10             	add    $0x10,%esp
801074d3:	85 c0                	test   %eax,%eax
801074d5:	78 3e                	js     80107515 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074dd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801074e0:	76 4e                	jbe    80107530 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801074e2:	8b 45 08             	mov    0x8(%ebp),%eax
801074e5:	31 c9                	xor    %ecx,%ecx
801074e7:	89 f2                	mov    %esi,%edx
801074e9:	e8 e2 f7 ff ff       	call   80106cd0 <walkpgdir>
801074ee:	85 c0                	test   %eax,%eax
801074f0:	74 5a                	je     8010754c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801074f2:	8b 18                	mov    (%eax),%ebx
801074f4:	f6 c3 01             	test   $0x1,%bl
801074f7:	74 46                	je     8010753f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801074f9:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801074fb:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107501:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107504:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010750a:	e8 81 af ff ff       	call   80102490 <kalloc>
8010750f:	85 c0                	test   %eax,%eax
80107511:	89 c3                	mov    %eax,%ebx
80107513:	75 8b                	jne    801074a0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107515:	83 ec 0c             	sub    $0xc,%esp
80107518:	ff 75 e0             	pushl  -0x20(%ebp)
8010751b:	e8 00 fe ff ff       	call   80107320 <freevm>
  return 0;
80107520:	83 c4 10             	add    $0x10,%esp
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107528:	5b                   	pop    %ebx
80107529:	5e                   	pop    %esi
8010752a:	5f                   	pop    %edi
8010752b:	5d                   	pop    %ebp
8010752c:	c3                   	ret    
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107533:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107536:	5b                   	pop    %ebx
80107537:	5e                   	pop    %esi
80107538:	5f                   	pop    %edi
80107539:	5d                   	pop    %ebp
8010753a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010753b:	31 c0                	xor    %eax,%eax
8010753d:	eb e6                	jmp    80107525 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	68 f2 80 10 80       	push   $0x801080f2
80107547:	e8 24 8e ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010754c:	83 ec 0c             	sub    $0xc,%esp
8010754f:	68 d8 80 10 80       	push   $0x801080d8
80107554:	e8 17 8e ff ff       	call   80100370 <panic>
80107559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107560 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107560:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107561:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107563:	89 e5                	mov    %esp,%ebp
80107565:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107568:	8b 55 0c             	mov    0xc(%ebp),%edx
8010756b:	8b 45 08             	mov    0x8(%ebp),%eax
8010756e:	e8 5d f7 ff ff       	call   80106cd0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107573:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107575:	89 c2                	mov    %eax,%edx
80107577:	83 e2 05             	and    $0x5,%edx
8010757a:	83 fa 05             	cmp    $0x5,%edx
8010757d:	75 11                	jne    80107590 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010757f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107584:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107585:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010758a:	c3                   	ret    
8010758b:	90                   	nop
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107590:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107592:	c9                   	leave  
80107593:	c3                   	ret    
80107594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010759a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
801075a9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801075af:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075b2:	85 db                	test   %ebx,%ebx
801075b4:	75 40                	jne    801075f6 <copyout+0x56>
801075b6:	eb 70                	jmp    80107628 <copyout+0x88>
801075b8:	90                   	nop
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801075c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801075c3:	89 f1                	mov    %esi,%ecx
801075c5:	29 d1                	sub    %edx,%ecx
801075c7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801075cd:	39 d9                	cmp    %ebx,%ecx
801075cf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801075d2:	29 f2                	sub    %esi,%edx
801075d4:	83 ec 04             	sub    $0x4,%esp
801075d7:	01 d0                	add    %edx,%eax
801075d9:	51                   	push   %ecx
801075da:	57                   	push   %edi
801075db:	50                   	push   %eax
801075dc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801075df:	e8 0c d6 ff ff       	call   80104bf0 <memmove>
    len -= n;
    buf += n;
801075e4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075e7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
801075ea:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
801075f0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801075f2:	29 cb                	sub    %ecx,%ebx
801075f4:	74 32                	je     80107628 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801075f6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801075f8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
801075fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801075fe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107604:	56                   	push   %esi
80107605:	ff 75 08             	pushl  0x8(%ebp)
80107608:	e8 53 ff ff ff       	call   80107560 <uva2ka>
    if(pa0 == 0)
8010760d:	83 c4 10             	add    $0x10,%esp
80107610:	85 c0                	test   %eax,%eax
80107612:	75 ac                	jne    801075c0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010761c:	5b                   	pop    %ebx
8010761d:	5e                   	pop    %esi
8010761e:	5f                   	pop    %edi
8010761f:	5d                   	pop    %ebp
80107620:	c3                   	ret    
80107621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107628:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010762b:	31 c0                	xor    %eax,%eax
}
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
