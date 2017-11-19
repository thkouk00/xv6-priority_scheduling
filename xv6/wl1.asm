
_wl1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int 
main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
	int i,y;
	long temp=0,temp1=0,temp2=0;
   7:	31 c0                	xor    %eax,%eax
	for (i=0;i<50000;i++)
   9:	31 d2                	xor    %edx,%edx
#include "stat.h"
#include "user.h"

int 
main()
{
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 08             	sub    $0x8,%esp
  18:	90                   	nop
  19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  20:	31 c9                	xor    %ecx,%ecx
  22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	long temp=0,temp1=0,temp2=0;
	for (i=0;i<50000;i++)
	{
		for (y=0;y<20000;y++)
		{
			temp = temp + i ;
  28:	01 d0                	add    %edx,%eax
			temp = temp*2;
  2a:	01 c0                	add    %eax,%eax
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
  2c:	29 d0                	sub    %edx,%eax
  2e:	8d 04 40             	lea    (%eax,%eax,2),%eax
  31:	89 c3                	mov    %eax,%ebx
  33:	c1 eb 1f             	shr    $0x1f,%ebx
  36:	01 c3                	add    %eax,%ebx
  38:	d1 fb                	sar    %ebx
  3a:	69 db e8 03 00 00    	imul   $0x3e8,%ebx,%ebx
  40:	0f af da             	imul   %edx,%ebx
  43:	0f af d9             	imul   %ecx,%ebx
			temp1 =temp + 2000*4000+4*temp*temp ;
  46:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  4d:	0f af c3             	imul   %ebx,%eax
  50:	8d b4 03 00 12 7a 00 	lea    0x7a1200(%ebx,%eax,1),%esi
			temp = temp*(temp1*temp + temp*2 + temp1*temp1 -3000);
  57:	8d 46 02             	lea    0x2(%esi),%eax
  5a:	89 f7                	mov    %esi,%edi
  5c:	0f af fe             	imul   %esi,%edi
  5f:	0f af c3             	imul   %ebx,%eax
  62:	8d 84 38 48 f4 ff ff 	lea    -0xbb8(%eax,%edi,1),%eax
  69:	0f af d8             	imul   %eax,%ebx
			temp2= (temp+temp1)*temp1*2*temp-100;
			temp2 = temp1 + temp2 + temp;
			temp = temp + i ;
  6c:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
			temp = temp*2;
  6f:	01 c0                	add    %eax,%eax
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
  71:	29 d0                	sub    %edx,%eax
  73:	8d 04 40             	lea    (%eax,%eax,2),%eax
  76:	89 c7                	mov    %eax,%edi
  78:	c1 ef 1f             	shr    $0x1f,%edi
  7b:	01 f8                	add    %edi,%eax
  7d:	d1 f8                	sar    %eax
  7f:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  85:	0f af c2             	imul   %edx,%eax
  88:	0f af c1             	imul   %ecx,%eax
{
	int i,y;
	long temp=0,temp1=0,temp2=0;
	for (i=0;i<50000;i++)
	{
		for (y=0;y<20000;y++)
  8b:	83 c1 01             	add    $0x1,%ecx
  8e:	81 f9 20 4e 00 00    	cmp    $0x4e20,%ecx
  94:	75 92                	jne    28 <main+0x28>
int 
main()
{
	int i,y;
	long temp=0,temp1=0,temp2=0;
	for (i=0;i<50000;i++)
  96:	83 c2 01             	add    $0x1,%edx
			temp = temp*2;
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
			temp1 =temp + 2000*4000+4*temp*temp1 ;
		}
		temp=1;
  99:	b8 01 00 00 00       	mov    $0x1,%eax
int 
main()
{
	int i,y;
	long temp=0,temp1=0,temp2=0;
	for (i=0;i<50000;i++)
  9e:	81 fa 50 c3 00 00    	cmp    $0xc350,%edx
  a4:	0f 85 76 ff ff ff    	jne    20 <main+0x20>
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
			temp1 =temp + 2000*4000+4*temp*temp ;
			temp = temp*(temp1*temp + temp*2 + temp1*temp1 -3000);
			temp2= (temp+temp1)*temp1*2*temp-100;
			temp2 = temp1 + temp2 + temp;
  aa:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
		}
		temp=1;
		temp1=2;
	}

	printf(1,"END WL1 %d\n",temp2-(temp+temp1));
  ad:	83 ec 04             	sub    $0x4,%esp
			temp = temp - i;
			temp = (temp *3/2)*1000*i*y ; 
			temp1 =temp + 2000*4000+4*temp*temp ;
			temp = temp*(temp1*temp + temp*2 + temp1*temp1 -3000);
			temp2= (temp+temp1)*temp1*2*temp-100;
			temp2 = temp1 + temp2 + temp;
  b0:	0f af c6             	imul   %esi,%eax
  b3:	01 c0                	add    %eax,%eax
  b5:	0f af c3             	imul   %ebx,%eax
  b8:	8d 44 06 9c          	lea    -0x64(%esi,%eax,1),%eax
		}
		temp=1;
		temp1=2;
	}

	printf(1,"END WL1 %d\n",temp2-(temp+temp1));
  bc:	8d 44 03 fd          	lea    -0x3(%ebx,%eax,1),%eax
  c0:	50                   	push   %eax
  c1:	68 90 07 00 00       	push   $0x790
  c6:	6a 01                	push   $0x1
  c8:	e8 a3 03 00 00       	call   470 <printf>
	exit();
  cd:	e8 50 02 00 00       	call   322 <exit>
  d2:	66 90                	xchg   %ax,%ax
  d4:	66 90                	xchg   %ax,%ax
  d6:	66 90                	xchg   %ax,%ax
  d8:	66 90                	xchg   %ax,%ax
  da:	66 90                	xchg   %ax,%ax
  dc:	66 90                	xchg   %ax,%ax
  de:	66 90                	xchg   %ax,%ax

000000e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ea:	89 c2                	mov    %eax,%edx
  ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f0:	83 c1 01             	add    $0x1,%ecx
  f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f7:	83 c2 01             	add    $0x1,%edx
  fa:	84 db                	test   %bl,%bl
  fc:	88 5a ff             	mov    %bl,-0x1(%edx)
  ff:	75 ef                	jne    f0 <strcpy+0x10>
    ;
  return os;
}
 101:	5b                   	pop    %ebx
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	56                   	push   %esi
 114:	53                   	push   %ebx
 115:	8b 55 08             	mov    0x8(%ebp),%edx
 118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 11b:	0f b6 02             	movzbl (%edx),%eax
 11e:	0f b6 19             	movzbl (%ecx),%ebx
 121:	84 c0                	test   %al,%al
 123:	75 1e                	jne    143 <strcmp+0x33>
 125:	eb 29                	jmp    150 <strcmp+0x40>
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 130:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 133:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 136:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 139:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 13d:	84 c0                	test   %al,%al
 13f:	74 0f                	je     150 <strcmp+0x40>
 141:	89 f1                	mov    %esi,%ecx
 143:	38 d8                	cmp    %bl,%al
 145:	74 e9                	je     130 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 147:	29 d8                	sub    %ebx,%eax
}
 149:	5b                   	pop    %ebx
 14a:	5e                   	pop    %esi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
 14d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 150:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 152:	29 d8                	sub    %ebx,%eax
}
 154:	5b                   	pop    %ebx
 155:	5e                   	pop    %esi
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    
 158:	90                   	nop
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 12                	je     17d <strlen+0x1d>
 16b:	31 d2                	xor    %edx,%edx
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	83 c2 01             	add    $0x1,%edx
 173:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 177:	89 d0                	mov    %edx,%eax
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 17d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    
 181:	eb 0d                	jmp    190 <memset>
 183:	90                   	nop
 184:	90                   	nop
 185:	90                   	nop
 186:	90                   	nop
 187:	90                   	nop
 188:	90                   	nop
 189:	90                   	nop
 18a:	90                   	nop
 18b:	90                   	nop
 18c:	90                   	nop
 18d:	90                   	nop
 18e:	90                   	nop
 18f:	90                   	nop

00000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 197:	8b 4d 10             	mov    0x10(%ebp),%ecx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 d7                	mov    %edx,%edi
 19f:	fc                   	cld    
 1a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	5f                   	pop    %edi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	89 f6                	mov    %esi,%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	84 d2                	test   %dl,%dl
 1bf:	74 1d                	je     1de <strchr+0x2e>
    if(*s == c)
 1c1:	38 d3                	cmp    %dl,%bl
 1c3:	89 d9                	mov    %ebx,%ecx
 1c5:	75 0d                	jne    1d4 <strchr+0x24>
 1c7:	eb 17                	jmp    1e0 <strchr+0x30>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d0:	38 ca                	cmp    %cl,%dl
 1d2:	74 0c                	je     1e0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1d4:	83 c0 01             	add    $0x1,%eax
 1d7:	0f b6 10             	movzbl (%eax),%edx
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1de:	31 c0                	xor    %eax,%eax
}
 1e0:	5b                   	pop    %ebx
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    
 1e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 1f8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 1fb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	eb 29                	jmp    229 <gets+0x39>
    cc = read(0, &c, 1);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	6a 01                	push   $0x1
 205:	57                   	push   %edi
 206:	6a 00                	push   $0x0
 208:	e8 2d 01 00 00       	call   33a <read>
    if(cc < 1)
 20d:	83 c4 10             	add    $0x10,%esp
 210:	85 c0                	test   %eax,%eax
 212:	7e 1d                	jle    231 <gets+0x41>
      break;
    buf[i++] = c;
 214:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 218:	8b 55 08             	mov    0x8(%ebp),%edx
 21b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 21d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 21f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 223:	74 1b                	je     240 <gets+0x50>
 225:	3c 0d                	cmp    $0xd,%al
 227:	74 17                	je     240 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 229:	8d 5e 01             	lea    0x1(%esi),%ebx
 22c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 22f:	7c cf                	jl     200 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 238:	8d 65 f4             	lea    -0xc(%ebp),%esp
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 240:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 243:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 245:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
 251:	eb 0d                	jmp    260 <stat>
 253:	90                   	nop
 254:	90                   	nop
 255:	90                   	nop
 256:	90                   	nop
 257:	90                   	nop
 258:	90                   	nop
 259:	90                   	nop
 25a:	90                   	nop
 25b:	90                   	nop
 25c:	90                   	nop
 25d:	90                   	nop
 25e:	90                   	nop
 25f:	90                   	nop

00000260 <stat>:

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	pushl  0x8(%ebp)
 26d:	e8 f0 00 00 00       	call   362 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	pushl  0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 f3 00 00 00       	call   37a <fstat>
 287:	89 c6                	mov    %eax,%esi
  close(fd);
 289:	89 1c 24             	mov    %ebx,(%esp)
 28c:	e8 b9 00 00 00       	call   34a <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
 294:	89 f0                	mov    %esi,%eax
}
 296:	8d 65 f8             	lea    -0x8(%ebp),%esp
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a5:	eb ef                	jmp    296 <stat+0x36>
 2a7:	89 f6                	mov    %esi,%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 11             	movsbl (%ecx),%edx
 2ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 2bd:	3c 09                	cmp    $0x9,%al
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
 2c4:	77 1f                	ja     2e5 <atoi+0x35>
 2c6:	8d 76 00             	lea    0x0(%esi),%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2d3:	83 c1 01             	add    $0x1,%ecx
 2d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2da:	0f be 11             	movsbl (%ecx),%edx
 2dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2e0:	80 fb 09             	cmp    $0x9,%bl
 2e3:	76 eb                	jbe    2d0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 2e5:	5b                   	pop    %ebx
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret    
 2e8:	90                   	nop
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
 2f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	85 db                	test   %ebx,%ebx
 300:	7e 14                	jle    316 <memmove+0x26>
 302:	31 d2                	xor    %edx,%edx
 304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 308:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 30c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 30f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 312:	39 da                	cmp    %ebx,%edx
 314:	75 f2                	jne    308 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5d                   	pop    %ebp
 319:	c3                   	ret    

0000031a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31a:	b8 01 00 00 00       	mov    $0x1,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <exit>:
SYSCALL(exit)
 322:	b8 02 00 00 00       	mov    $0x2,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <wait>:
SYSCALL(wait)
 32a:	b8 03 00 00 00       	mov    $0x3,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <pipe>:
SYSCALL(pipe)
 332:	b8 04 00 00 00       	mov    $0x4,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <read>:
SYSCALL(read)
 33a:	b8 05 00 00 00       	mov    $0x5,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <write>:
SYSCALL(write)
 342:	b8 10 00 00 00       	mov    $0x10,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <close>:
SYSCALL(close)
 34a:	b8 15 00 00 00       	mov    $0x15,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <kill>:
SYSCALL(kill)
 352:	b8 06 00 00 00       	mov    $0x6,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <exec>:
SYSCALL(exec)
 35a:	b8 07 00 00 00       	mov    $0x7,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <open>:
SYSCALL(open)
 362:	b8 0f 00 00 00       	mov    $0xf,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <mknod>:
SYSCALL(mknod)
 36a:	b8 11 00 00 00       	mov    $0x11,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <unlink>:
SYSCALL(unlink)
 372:	b8 12 00 00 00       	mov    $0x12,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <fstat>:
SYSCALL(fstat)
 37a:	b8 08 00 00 00       	mov    $0x8,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <link>:
SYSCALL(link)
 382:	b8 13 00 00 00       	mov    $0x13,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <mkdir>:
SYSCALL(mkdir)
 38a:	b8 14 00 00 00       	mov    $0x14,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <chdir>:
SYSCALL(chdir)
 392:	b8 09 00 00 00       	mov    $0x9,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <dup>:
SYSCALL(dup)
 39a:	b8 0a 00 00 00       	mov    $0xa,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <getpid>:
SYSCALL(getpid)
 3a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <sbrk>:
SYSCALL(sbrk)
 3aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <sleep>:
SYSCALL(sleep)
 3b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <uptime>:
SYSCALL(uptime)
 3ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <cps>:
SYSCALL(cps)
 3c2:	b8 16 00 00 00       	mov    $0x16,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    
 3ca:	66 90                	xchg   %ax,%ax
 3cc:	66 90                	xchg   %ax,%ax
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	89 c6                	mov    %eax,%esi
 3d8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3de:	85 db                	test   %ebx,%ebx
 3e0:	74 7e                	je     460 <printint+0x90>
 3e2:	89 d0                	mov    %edx,%eax
 3e4:	c1 e8 1f             	shr    $0x1f,%eax
 3e7:	84 c0                	test   %al,%al
 3e9:	74 75                	je     460 <printint+0x90>
    neg = 1;
    x = -xx;
 3eb:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 3ed:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 3f4:	f7 d8                	neg    %eax
 3f6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f9:	31 ff                	xor    %edi,%edi
 3fb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3fe:	89 ce                	mov    %ecx,%esi
 400:	eb 08                	jmp    40a <printint+0x3a>
 402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 408:	89 cf                	mov    %ecx,%edi
 40a:	31 d2                	xor    %edx,%edx
 40c:	8d 4f 01             	lea    0x1(%edi),%ecx
 40f:	f7 f6                	div    %esi
 411:	0f b6 92 a4 07 00 00 	movzbl 0x7a4(%edx),%edx
  }while((x /= base) != 0);
 418:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 41a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 41d:	75 e9                	jne    408 <printint+0x38>
  if(neg)
 41f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 422:	8b 75 c0             	mov    -0x40(%ebp),%esi
 425:	85 c0                	test   %eax,%eax
 427:	74 08                	je     431 <printint+0x61>
    buf[i++] = '-';
 429:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 42e:	8d 4f 02             	lea    0x2(%edi),%ecx
 431:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 435:	8d 76 00             	lea    0x0(%esi),%esi
 438:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	83 ef 01             	sub    $0x1,%edi
 441:	6a 01                	push   $0x1
 443:	53                   	push   %ebx
 444:	56                   	push   %esi
 445:	88 45 d7             	mov    %al,-0x29(%ebp)
 448:	e8 f5 fe ff ff       	call   342 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44d:	83 c4 10             	add    $0x10,%esp
 450:	39 df                	cmp    %ebx,%edi
 452:	75 e4                	jne    438 <printint+0x68>
    putc(fd, buf[i]);
}
 454:	8d 65 f4             	lea    -0xc(%ebp),%esp
 457:	5b                   	pop    %ebx
 458:	5e                   	pop    %esi
 459:	5f                   	pop    %edi
 45a:	5d                   	pop    %ebp
 45b:	c3                   	ret    
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 460:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 462:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 469:	eb 8b                	jmp    3f6 <printint+0x26>
 46b:	90                   	nop
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 476:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 479:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 47c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 482:	89 45 d0             	mov    %eax,-0x30(%ebp)
 485:	0f b6 1e             	movzbl (%esi),%ebx
 488:	83 c6 01             	add    $0x1,%esi
 48b:	84 db                	test   %bl,%bl
 48d:	0f 84 b0 00 00 00    	je     543 <printf+0xd3>
 493:	31 d2                	xor    %edx,%edx
 495:	eb 39                	jmp    4d0 <printf+0x60>
 497:	89 f6                	mov    %esi,%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4a0:	83 f8 25             	cmp    $0x25,%eax
 4a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4a6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4ab:	74 18                	je     4c5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ad:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4b6:	6a 01                	push   $0x1
 4b8:	50                   	push   %eax
 4b9:	57                   	push   %edi
 4ba:	e8 83 fe ff ff       	call   342 <write>
 4bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4c2:	83 c4 10             	add    $0x10,%esp
 4c5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4c8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4cc:	84 db                	test   %bl,%bl
 4ce:	74 73                	je     543 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 4d0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4d2:	0f be cb             	movsbl %bl,%ecx
 4d5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d8:	74 c6                	je     4a0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4da:	83 fa 25             	cmp    $0x25,%edx
 4dd:	75 e6                	jne    4c5 <printf+0x55>
      if(c == 'd'){
 4df:	83 f8 64             	cmp    $0x64,%eax
 4e2:	0f 84 f8 00 00 00    	je     5e0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4ee:	83 f9 70             	cmp    $0x70,%ecx
 4f1:	74 5d                	je     550 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f3:	83 f8 73             	cmp    $0x73,%eax
 4f6:	0f 84 84 00 00 00    	je     580 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fc:	83 f8 63             	cmp    $0x63,%eax
 4ff:	0f 84 ea 00 00 00    	je     5ef <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 505:	83 f8 25             	cmp    $0x25,%eax
 508:	0f 84 c2 00 00 00    	je     5d0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 50e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 511:	83 ec 04             	sub    $0x4,%esp
 514:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 518:	6a 01                	push   $0x1
 51a:	50                   	push   %eax
 51b:	57                   	push   %edi
 51c:	e8 21 fe ff ff       	call   342 <write>
 521:	83 c4 0c             	add    $0xc,%esp
 524:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 527:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 52a:	6a 01                	push   $0x1
 52c:	50                   	push   %eax
 52d:	57                   	push   %edi
 52e:	83 c6 01             	add    $0x1,%esi
 531:	e8 0c fe ff ff       	call   342 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 536:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 53f:	84 db                	test   %bl,%bl
 541:	75 8d                	jne    4d0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 543:	8d 65 f4             	lea    -0xc(%ebp),%esp
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret    
 54b:	90                   	nop
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
 558:	6a 00                	push   $0x0
 55a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 55d:	89 f8                	mov    %edi,%eax
 55f:	8b 13                	mov    (%ebx),%edx
 561:	e8 6a fe ff ff       	call   3d0 <printint>
        ap++;
 566:	89 d8                	mov    %ebx,%eax
 568:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d0             	mov    %eax,-0x30(%ebp)
 573:	e9 4d ff ff ff       	jmp    4c5 <printf+0x55>
 578:	90                   	nop
 579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 580:	8b 45 d0             	mov    -0x30(%ebp),%eax
 583:	8b 18                	mov    (%eax),%ebx
        ap++;
 585:	83 c0 04             	add    $0x4,%eax
 588:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 58b:	b8 9c 07 00 00       	mov    $0x79c,%eax
 590:	85 db                	test   %ebx,%ebx
 592:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 595:	0f b6 03             	movzbl (%ebx),%eax
 598:	84 c0                	test   %al,%al
 59a:	74 23                	je     5bf <printf+0x14f>
 59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5a0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5ab:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ae:	50                   	push   %eax
 5af:	57                   	push   %edi
 5b0:	e8 8d fd ff ff       	call   342 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b5:	0f b6 03             	movzbl (%ebx),%eax
 5b8:	83 c4 10             	add    $0x10,%esp
 5bb:	84 c0                	test   %al,%al
 5bd:	75 e1                	jne    5a0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5bf:	31 d2                	xor    %edx,%edx
 5c1:	e9 ff fe ff ff       	jmp    4c5 <printf+0x55>
 5c6:	8d 76 00             	lea    0x0(%esi),%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d0:	83 ec 04             	sub    $0x4,%esp
 5d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5d9:	6a 01                	push   $0x1
 5db:	e9 4c ff ff ff       	jmp    52c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	e9 6b ff ff ff       	jmp    55a <printf+0xea>
 5ef:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f2:	83 ec 04             	sub    $0x4,%esp
 5f5:	8b 03                	mov    (%ebx),%eax
 5f7:	6a 01                	push   $0x1
 5f9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 5fc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5ff:	50                   	push   %eax
 600:	57                   	push   %edi
 601:	e8 3c fd ff ff       	call   342 <write>
 606:	e9 5b ff ff ff       	jmp    566 <printf+0xf6>
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 48 0a 00 00       	mov    0xa48,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 620:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 623:	39 c8                	cmp    %ecx,%eax
 625:	73 19                	jae    640 <free+0x30>
 627:	89 f6                	mov    %esi,%esi
 629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 630:	39 d1                	cmp    %edx,%ecx
 632:	72 1c                	jb     650 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 634:	39 d0                	cmp    %edx,%eax
 636:	73 18                	jae    650 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 638:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	72 f0                	jb     630 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	39 d0                	cmp    %edx,%eax
 642:	72 f4                	jb     638 <free+0x28>
 644:	39 d1                	cmp    %edx,%ecx
 646:	73 f0                	jae    638 <free+0x28>
 648:	90                   	nop
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 650:	8b 73 fc             	mov    -0x4(%ebx),%esi
 653:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 656:	39 d7                	cmp    %edx,%edi
 658:	74 19                	je     673 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 663:	39 f1                	cmp    %esi,%ecx
 665:	74 23                	je     68a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 667:	89 08                	mov    %ecx,(%eax)
  freep = p;
 669:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 66e:	5b                   	pop    %ebx
 66f:	5e                   	pop    %esi
 670:	5f                   	pop    %edi
 671:	5d                   	pop    %ebp
 672:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 673:	03 72 04             	add    0x4(%edx),%esi
 676:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 679:	8b 10                	mov    (%eax),%edx
 67b:	8b 12                	mov    (%edx),%edx
 67d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 680:	8b 50 04             	mov    0x4(%eax),%edx
 683:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 686:	39 f1                	cmp    %esi,%ecx
 688:	75 dd                	jne    667 <free+0x57>
    p->s.size += bp->s.size;
 68a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 68d:	a3 48 0a 00 00       	mov    %eax,0xa48
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 692:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 695:	8b 53 f8             	mov    -0x8(%ebx),%edx
 698:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 69a:	5b                   	pop    %ebx
 69b:	5e                   	pop    %esi
 69c:	5f                   	pop    %edi
 69d:	5d                   	pop    %ebp
 69e:	c3                   	ret    
 69f:	90                   	nop

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ac:	8b 15 48 0a 00 00    	mov    0xa48,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	8d 78 07             	lea    0x7(%eax),%edi
 6b5:	c1 ef 03             	shr    $0x3,%edi
 6b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6bb:	85 d2                	test   %edx,%edx
 6bd:	0f 84 a3 00 00 00    	je     766 <malloc+0xc6>
 6c3:	8b 02                	mov    (%edx),%eax
 6c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6c8:	39 cf                	cmp    %ecx,%edi
 6ca:	76 74                	jbe    740 <malloc+0xa0>
 6cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6d2:	be 00 10 00 00       	mov    $0x1000,%esi
 6d7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 6de:	0f 43 f7             	cmovae %edi,%esi
 6e1:	ba 00 80 00 00       	mov    $0x8000,%edx
 6e6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 6ec:	0f 46 da             	cmovbe %edx,%ebx
 6ef:	eb 10                	jmp    701 <malloc+0x61>
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6fa:	8b 48 04             	mov    0x4(%eax),%ecx
 6fd:	39 cf                	cmp    %ecx,%edi
 6ff:	76 3f                	jbe    740 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 701:	39 05 48 0a 00 00    	cmp    %eax,0xa48
 707:	89 c2                	mov    %eax,%edx
 709:	75 ed                	jne    6f8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 70b:	83 ec 0c             	sub    $0xc,%esp
 70e:	53                   	push   %ebx
 70f:	e8 96 fc ff ff       	call   3aa <sbrk>
  if(p == (char*)-1)
 714:	83 c4 10             	add    $0x10,%esp
 717:	83 f8 ff             	cmp    $0xffffffff,%eax
 71a:	74 1c                	je     738 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 71c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 71f:	83 ec 0c             	sub    $0xc,%esp
 722:	83 c0 08             	add    $0x8,%eax
 725:	50                   	push   %eax
 726:	e8 e5 fe ff ff       	call   610 <free>
  return freep;
 72b:	8b 15 48 0a 00 00    	mov    0xa48,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 731:	83 c4 10             	add    $0x10,%esp
 734:	85 d2                	test   %edx,%edx
 736:	75 c0                	jne    6f8 <malloc+0x58>
        return 0;
 738:	31 c0                	xor    %eax,%eax
 73a:	eb 1c                	jmp    758 <malloc+0xb8>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 740:	39 cf                	cmp    %ecx,%edi
 742:	74 1c                	je     760 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 744:	29 f9                	sub    %edi,%ecx
 746:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 749:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 74c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 74f:	89 15 48 0a 00 00    	mov    %edx,0xa48
      return (void*)(p + 1);
 755:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 758:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75b:	5b                   	pop    %ebx
 75c:	5e                   	pop    %esi
 75d:	5f                   	pop    %edi
 75e:	5d                   	pop    %ebp
 75f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb e9                	jmp    74f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 766:	c7 05 48 0a 00 00 4c 	movl   $0xa4c,0xa48
 76d:	0a 00 00 
 770:	c7 05 4c 0a 00 00 4c 	movl   $0xa4c,0xa4c
 777:	0a 00 00 
    base.s.size = 0;
 77a:	b8 4c 0a 00 00       	mov    $0xa4c,%eax
 77f:	c7 05 50 0a 00 00 00 	movl   $0x0,0xa50
 786:	00 00 00 
 789:	e9 3e ff ff ff       	jmp    6cc <malloc+0x2c>
