package design.pattern.structural.bridge;

/**
 * 15-2 桥接模式coding
 */
public class Test {
    public static void main(String[] args) {
        Bank icbcBank = new ICBCBank(new DepositAccount());
        Account icbcAccount = icbcBank.openAccount();
        icbcAccount.showAccountType();

        System.out.println();

        Bank icbcBank2 = new ICBCBank(new SavingAccount());
        Account icbcAccount2 = icbcBank2.openAccount();
        icbcAccount2.showAccountType();

        System.out.println();

        Bank abcBank = new ABCBank(new SavingAccount());
        Account abcAccount = abcBank.openAccount();
        abcAccount.showAccountType();
    }
}
/* Output:
打开中国工商银行账号
打开定期账号
这是一个定期账号

打开中国工商银行账号
打开活期账号
这是一个活期账号

打开中国农业银行账号
打开活期账号
这是一个活期账号
*///~