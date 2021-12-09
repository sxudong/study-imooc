# 漏洞扫描

## 扫描方式
**版本扫描**：通过发现服务的版本，根据cve，标识该版本的服务软件，具有哪些漏洞信息。
**原理扫描**：通过POC（观点验证程序）程序，验证相应服务是否具备某种漏洞。

关于漏洞:
​    0-day漏洞:发现漏洞后，还没有发布补丁。
​    1-day漏洞:漏洞发现后，已经发布漏洞补丁，还没有进行安全升级。(持续时间比较断)
​    N-day漏洞:漏洞已经发现，也发布漏洞补丁，
**(安全界的三大威胁：弱口令、N-day漏洞、协议栈。)**



openVAS：



## 漏洞源码级解决:

一般从源里升级软件包。

up-stream：以`openssh`为例，最开始，开放源码的地方。有一帮人在维护。叫上游

ubuntu源：系统级维护的`openssh`源码。
个人进行安全升级(源码级)：确认当前版本，上游解决安全漏洞和你当前版本不同。通常将高版本的安全patch补丁，添加你的当前版本的源码种来。



## 关于漏洞

1. 了解cve：公开漏洞披露的地方。从"攻"的角度，我可以开发一些工具，找到一些开源poc(观点验证程序)： http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-11776

2. 和cve相关的，还有个网站：NVD https://nvd.nist.gov/vuln/detail/CVE-2011-14733
3. 中国国家漏洞信息库：https://nvd.nist.gov/vuln/detail/CVE-2011-14733



## linux下的环境

vim 编辑代码，gcc编译代码，makefile组织源码，通常项目配合`git/svn`源码管理工具管理源码。

gdb作为调试器，只能调试运行时的问题。



## linux内核启动

cpu执行指令：
取指，译码，执行：从pc寄存器（程序计数器，存放的是，下一条指令的地址。）内容为地址，去要执行指令。



**结论：想从哪里执行，就把地址放到pc寄存器中来。**（约定好的地址）



虚拟地址/物理地址?

加电 - 运行ROM中代码(boolloader-1) - 加载bootloader (BIOS) ---加载内核 -- 创建一些内核线程，-- 执行用户态的init进程。也就是1号进程。（pstree查看1号进程，which init）



```shell
vim hello.c

#include <stdio.h>
int main(int argc, char *argv[])
{
  int a = 5;
  printf ("Hello worldin" );
  while(1);
  return 0;
}

gcc hello.c -o hello -g
# objdump命令是Linux下的反汇编目标文件或者可执行文件的命令，
# 它以一种可阅读的格式让你更多地了解二进制文件可能带有的附加信息。
objdump -Ssx hello
objdump -Ssx hello > hello.s
file hello
```



```shell
root@kali-itcast:~# readelf-h hello
ELF头:
  Magic :   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  类别:      ELF64
  数据:      2补码，小端序( little endian)
  版本:      1 (current)
  oS/ABI:   UNIX - System v
  ABI版本:   0
  类型:      DYN(共享目标文件)
  系统架构:   Advanced Micro Devices X86-64
  版本:      0x1
  入口点地址: 0x6130
  程序头起点∶ 64 (bytes into file)
  start of section headers: 137000 ( bytes into file)
  标志:       0x0
  本头的大小:  64(字节)
  程序头大小:  56(字节)
  Number of program headers: 11
  节头大小:    64(字节)
  节头数量∶    29
  字符串表索引节头: 28
root@kali-itcast:~# ./hello
Hello World
root@kali-itcast:~# ps aux | grep hello
root 776 105 0.0 2260 740 pts/0 R+ 16:41 0:09 ./hello
root@kali-itcast:~# cat /proc/776/maps | less
```

