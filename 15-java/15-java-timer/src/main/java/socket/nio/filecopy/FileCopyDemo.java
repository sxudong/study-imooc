package socket.nio.filecopy;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;

/**
 * 6-4 实战：多方法实现本地文件拷贝
 */
public class FileCopyDemo {

    // 不使用用任何缓冲的流进行拷贝文件（使用 Closeable 函数）
    private static FileCopyRunner noBufferStreamCopy = (source, target) -> {
        InputStream fin = null;
        OutputStream fout = null;
        try {
            fin = new FileInputStream(source);
            fout = new FileOutputStream(target);
            int result;
            while ((result = fin.read()) != -1) {
                fout.write(result);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(fin);
            close(fout);
        }
    };

    // 使用缓冲进行拷贝文件（使用 Closeable 函数）
    private static FileCopyRunner bufferStreamCopy = (source, target) -> {
        InputStream fin = null;
        OutputStream fout = null;
        try {
            fin = new BufferedInputStream(new FileInputStream(source));
            fout = new BufferedOutputStream(new FileOutputStream(target));
            byte[] buffer = new byte[1024];

            // 最多读取 1024 个字节，如最后一次，可能只剩余 10 个字节，
            // result 就是 buffer 读取的字节数
            int result;
            while ((result = fin.read(buffer)) != -1) {
                // 第一个参数：缓冲区
                // 第二个参数：从缓冲区哪个位置开始读
                // 第三个参数：当前 buffer 这个缓冲区所读进来的数量
                fout.write(buffer, 0, result);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(fin);
            close(fout);
        }
    };

    // 6-5 实战：多方法实现本地文件拷贝（下）
    // 使用 nio 的 buffer 进行拷贝文件（使用 Closeable 函数）
    private static FileCopyRunner nioBufferCopy = (source, target) -> {
        FileChannel fin = null;
        FileChannel fout = null;
        try {
            fin = new FileInputStream(source).getChannel();
            fout = new FileOutputStream(target).getChannel();
            // 分配一个新的字节缓冲区
            ByteBuffer buffer = ByteBuffer.allocate(1024);
            // 读取到 buffer 当中
            while (fin.read(buffer) != -1) {
                // 翻转"读模式"转换为"写模式"
                buffer.flip();
                // 为了保证把buffer里的数据写入到 fout 里去，包裹到 while() 里去
                // 判断 buffer 中是否还有可以读的元素，即告诉当前 position位置 和 limit位置 之间是否存在任何元素
                while (buffer.hasRemaining()) {
                    fout.write(buffer);
                }
                // "读模式"调整为"写模式"
                buffer.clear();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(fin);
            close(fout);
        }
    };

    // 使用 nio 直接进行拷贝（使用 Closeable 函数）
    private static FileCopyRunner nioTransferCopy = (source, target) -> {
        FileChannel fin = null;
        FileChannel fout = null;
        try {
            fin = new FileInputStream(source).getChannel();
            fout = new FileOutputStream(target).getChannel();

            long transferred = 0L;
            long size = fin.size(); //源文件大小
            while (transferred != size) {
                // 将该通道文件的字节传输到给定的可写字节通道，
                // while 循环如果拷贝的大小没有达到源文件的大小就一直拷贝
                transferred += fin.transferTo(0, size, fout);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(fin);
            close(fout);
        }
    };

    private static void close(Closeable closeable) {
        if (null != closeable) {
            try {
                closeable.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 执行5次，之后求时间平均数
     */
    private static final int ROUNDS = 5;

    /**
     * 测试文件拷贝效率，计算平均值
     *
     * @param test
     * @param source
     * @param target
     */
    private static void benchMark(FileCopyRunner test, File source, File target) {
        long elapsed = 0L;
        for (int i = 0; i < ROUNDS; i++) {
            long startTime = System.currentTimeMillis();
            test.copyFile(source, target);
            elapsed += System.currentTimeMillis() - startTime;
            target.delete();
        }
        System.out.println(test + ":" + elapsed / ROUNDS);
    }

    public static void main(String[] args) {

        // 100k
        File smallFile = new File("/Users/caojx/Desktop/风控规则自动化测试报文4.json");
        File smallFileCopy = new File("/Users/caojx/Desktop/a.json");

        System.out.println("---Copying small file---");
        benchMark(noBufferStreamCopy, smallFile, smallFileCopy);
        benchMark(bufferStreamCopy, smallFile, smallFileCopy);
        benchMark(nioBufferCopy, smallFile, smallFileCopy);
        benchMark(nioTransferCopy, smallFile, smallFileCopy);

        // 13M，发现没有缓冲的noBufferStreamCopy巨慢，运行就跳过吧
        File bigFile = new File("/Users/caojx/book/Java程序的151个建议.pdf");
        File bigFileCopy = new File("/Users/caojx/Desktop/b.pdf");

        System.out.println("---Copying bigFile file---");
//        benchMark(noBufferStreamCopy, bigFile, bigFileCopy);
        benchMark(bufferStreamCopy, bigFile, bigFileCopy);
        benchMark(nioBufferCopy, bigFile, bigFileCopy);
        benchMark(nioTransferCopy, bigFile, bigFileCopy);

        // 47M 超大文件
        File hugeFile = new File("/Users/caojx/book/Spring Cloud微服务实战.pdf");
        File hugeFileCopy = new File("/Users/caojx/Desktop/c.pdf");

        System.out.println("---Copying hugeFile file---");
//        benchMark(noBufferStreamCopy, hugeFile, hugeFileCopy);
        benchMark(bufferStreamCopy, hugeFile, hugeFileCopy);
        benchMark(nioBufferCopy, hugeFile, hugeFileCopy);
        benchMark(nioTransferCopy, hugeFile, hugeFileCopy);
    }
}
/* Output:
 可以看到，nio效率多数情况下比bio效率高
 ---Copying small file---
   caojx.learn.filecopy.FileCopyDemo$$Lambda$1/1607521710@15aeb7ab:582
   caojx.learn.filecopy.FileCopyDemo$$Lambda$2/2129789493@7b23ec81:1
   caojx.learn.filecopy.FileCopyDemo$$Lambda$3/668386784@6acbcfc0:4
   caojx.learn.filecopy.FileCopyDemo$$Lambda$4/1329552164@5f184fc6:1
 ---Copying bigFile file---
   caojx.learn.filecopy.FileCopyDemo$$Lambda$2/2129789493@7b23ec81:28
   caojx.learn.filecopy.FileCopyDemo$$Lambda$3/668386784@6acbcfc0:90
   caojx.learn.filecopy.FileCopyDemo$$Lambda$4/1329552164@5f184fc6:7
 ---Copying hugeFile file---
   caojx.learn.filecopy.FileCopyDemo$$Lambda$2/2129789493@7b23ec81:92
   caojx.learn.filecopy.FileCopyDemo$$Lambda$3/668386784@6acbcfc0:335
   caojx.learn.filecopy.FileCopyDemo$$Lambda$4/1329552164@5f184fc6:41
 */