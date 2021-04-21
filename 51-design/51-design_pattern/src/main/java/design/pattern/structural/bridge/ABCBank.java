package design.pattern.structural.bridge;

/**
 * 中国农业银行
 */
public class ABCBank extends Bank {
    public ABCBank(Account account) {
        super(account);
    }

    @Override
    Account openAccount() {
        System.out.println("打开中国农业银行账号");
        account.openAccount(); // 委托给Account
        return account;
    }
}
