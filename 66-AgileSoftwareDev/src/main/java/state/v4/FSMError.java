package state.v4;

/**
 * 程序29.16 P386
 */
public class FSMError extends Exception{
    public FSMError(String event, String state) {
        super("Invalid event: " + event + " in state: " + state);
    }
}
