package design.pattern.structural.bridge;

/**
 * 账号接口
 */
public interface Account {
    Account openAccount();  // 打开账号
    void showAccountType(); // 看账号类型
}
