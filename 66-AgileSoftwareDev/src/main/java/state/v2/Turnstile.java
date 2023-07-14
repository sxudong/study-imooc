package state.v2;

/**
 * 程序29.7 P374
 * Context 环境角色，运作是在 Context 类中实现的，而逻辑则是分布在 State 类的派生类中。
 */
public class Turnstile {

    private static TurnstileState lockedState = new LockedTurnstileState();
    private static UnlockedTurnstileState unlockedState = new UnlockedTurnstileState();
    private TurnstileController turnstileController;
    private TurnstileState state = lockedState;

    public Turnstile(TurnstileController action) {
        this.turnstileController = action;
    }

    public TurnstileState getCurrentState() {
        return state;
    }

    public void coin() {
        System.out.println("扔进一个硬币，收到 coin 事件...");
        state.coin(this);
    }

    public void pass() {
        System.out.println("乘客通过转门，收到 pass 事件...");
        state.pass(this);
    }

    public void setLocked() {
        System.out.println("设置成 Locked 状态");
        this.state = lockedState;
    }

    public void setUnlocked() {
        System.out.println("设置成 Unlocked 状态");
        this.state = unlockedState;
    }

    public boolean isLocked() {
        return this.state == lockedState;
    }

    public boolean isUnlocked() {
        return this.state == unlockedState;
    }

    void thankyou() {
        turnstileController.thankyou();
    }

    void alarm() {
        turnstileController.alarm();
    }

    void lock() {
        System.out.println("门将锁上...");
        turnstileController.lock();
    }

    void unlock() {
        turnstileController.unlock();
    }

    public static void main(String[] args) {
        SZTurnstileController turnstileController = new SZTurnstileController();
        Turnstile turnstile = new Turnstile(turnstileController);
        turnstile.coin();
        turnstile.pass();
    }
}
