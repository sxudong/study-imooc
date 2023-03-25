package chapter13;

import java.io.*;
import java.net.Socket;

/**
 * A.1 客户端/服务器的例子 P297
 * 《代码整洁之道》代码清单 A-5 P324
 */
public class MessageUtils {
    public static void sendMessage(Socket socket, String message) throws IOException {
        OutputStream stream = socket.getOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(stream);
        oos.writeUTF(message);
        oos.flush();
    }

    public static String getMessage(Socket socket) throws IOException {
        InputStream stream = socket.getInputStream();
        ObjectInputStream ois = new ObjectInputStream(stream);
        return ois.readUTF();
    }
}
