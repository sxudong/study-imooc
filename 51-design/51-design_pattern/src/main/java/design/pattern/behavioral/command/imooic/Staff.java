package design.pattern.behavioral.command.imooic;

import java.util.ArrayList;
import java.util.List;

/**
 * 员工（调动者）
 */
public class Staff {
    private List<Command> commandList = new ArrayList<>();

    public void addCommand(Command command) {
        commandList.add(command);
    }

    public void executeCommands() {
        // 遍历执行集合中的命令
        for (Command command : commandList) {
            command.execute();
        }
        // 清空命令
        commandList.clear();
    }
}
