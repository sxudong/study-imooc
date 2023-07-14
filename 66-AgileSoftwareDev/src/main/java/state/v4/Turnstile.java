package state.v4;

/**
 * 程序29.13 （由SMC生成）P384
 */
public class Turnstile extends TurnstileActions{
    private State itsState;
    private static String itsVersion = "";

    // instance variables for each state
    private static Locked itsLockedState;
    private static Unlocked itsUnlockedState;

    public Turnstile() {
        this.itsLockedState = new Locked();
        this.itsUnlockedState = new Unlocked();
        itsState = itsLockedState;
        // Entry functions for: Locked
    }

    // accessor functions
    public String getVersion() {
        return itsVersion;
    }

    public String getCurrentStateName() {
        return itsState.stateName();
    }

    // event functions - forward to the current State
    public void pass() throws FSMError {
        itsState.pass();
    }

    public void coin() throws FSMError{
        itsState.coin();
    }

    //-------------------------------------------------
    // private class State
    // This is the base State class
    private abstract class State {
        public abstract String stateName();
        // default event functions
        public void pass() throws FSMError {
            throw new FSMError("pass", itsState.stateName());
        }

        public void coin() throws FSMError {
            throw new FSMError("coin", itsState.stateName());
        }
    }

    //-------------------------------------------------
    // private Locked
    // handles the Locked State and its events
    private class Locked extends State {
        public String stateName() {
            return "Locked";
        }

        // responds to coin event
        public void coin() {
            unlock();
            // change the state
            itsState = itsUnlockedState;
        }

        // responds to pass event
        public void pass() {
            alarm();
            // change the state
            itsState = itsLockedState;
        }
    }

    //-------------------------------------------------
    // private Unlocked
    // handles the Unlocked State and its events
    private class Unlocked extends State {
        public String stateName() {
            return "Unlocked";
        }

        // responds to pass event
        public void pass() {
            lock();
            // change the state
            itsState = itsLockedState;
        }

        // responds to coin event
        public void coin() {
            thankyou();
            // change the state
            itsState = itsUnlockedState;
        }
    }

}
