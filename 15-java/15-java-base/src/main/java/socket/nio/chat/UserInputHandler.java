package socket.nio.chat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * 使用 nio编程模型 实现多人聊天室 - 处理用户输入信息
 */
public class UserInputHandler implements Runnable {

    private ChatClient chartClient;

    public UserInputHandler(ChatClient chartClient) {
        this.chartClient = chartClient;
    }

    @Override
    public void run() {
        // 等待用户输入消息
        BufferedReader consoleReader = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            try {
                String input = consoleReader.readLine();
                // 向服务器发送消息
                chartClient.send(input);
                // 检查一下用户是否准备推出了
                if (chartClient.readyToQuit(input)) {
                    break;
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
