package design.pattern.structural.bridge;

/**
 * 银行
 */
public abstract class Bank {
    protected Account account; // 账号

    public Bank(Account account) { // 组合Account
        this.account = account;
    }

    abstract Account openAccount();
}
