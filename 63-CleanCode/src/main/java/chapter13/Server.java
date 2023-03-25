package chapter13;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;

/**
 * A.1 客户端/服务器的例子 P297
 * 《代码整洁之道》代码清单 A-3 P321
 */
public class Server implements Runnable {
    ServerSocket serverSocket;
    volatile boolean keepProcessing = true;

    public Server(int port, int millisecondsTimeout) throws IOException {
        serverSocket = new ServerSocket(port);
        serverSocket.setSoTimeout(millisecondsTimeout);
    }

    @Override
    public void run() {
        System.out.println("Server Starting\n");

        while (keepProcessing) {
            try {
                System.out.println("accepting client\n");
                Socket socket = serverSocket.accept();
                System.out.println("got client\n");
                process(socket);
            } catch (Exception e) {
                handle(e);
            }
        }
    }

    private void handle(Exception e) {
        if (!(e instanceof SocketException)) {
            e.printStackTrace();
        }
    }

    public void stopProcessing() {
        keepProcessing = false;
        closeIgnoringException(serverSocket);
    }

    void process(Socket socket) {
        if(socket == null)
            return;

        try {
            System.out.println("Server: getting message\n");
            String message = MessageUtils.getMessage(socket);
            System.out.printf("Server: get message: %s\n", message);
            Thread.sleep(1000);
            System.out.printf("Server: sending reply: %s\n", message);
            MessageUtils.sendMessage(socket, "Processed: " + message);
            System.out.printf("Server: sent\n");
            closeIgnoringException(socket);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * A.10.2 使用线程的客户端/服务器代码
     * 把服务器修改为使用多线程，只需要对处理方法进行修改即可
     */
//    void process(Socket socket) {
//        if (socket == null)
//            return;
//
//        Runnable clientHandler = new Runnable() {
//            @Override
//            public void run() {
//                try {
//                    System.out.println("Server: getting message\n");
//                    String message = MessageUtils.getMessage(socket);
//                    System.out.printf("Server: get message: %s\n", message);
//                    Thread.sleep(1000);
//                    System.out.printf("Server: sending reply: %s\n", message);
//                    MessageUtils.sendMessage(socket, "Processed: " + message);
//                    System.out.printf("Server: sent\n");
//                    closeIgnoringException(socket);
//                } catch( Exception e){
//                    e.printStackTrace();
//                }
//            }
//        };
//
//        Thread clientConnection = new Thread(clientHandler);
//        clientConnection.start();
//    }

    private void closeIgnoringException(Socket socket) {
        if (socket != null)
            try {
                socket.close();
            } catch (IOException ignore) {
            }
    }

    private void closeIgnoringException(ServerSocket serverSocket) {
        if (serverSocket != null)
            try {
                serverSocket.close();
            } catch (IOException ignore) {
            }
    }
}
