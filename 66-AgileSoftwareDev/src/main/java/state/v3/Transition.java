package state.v3;

public class Transition {
    int currentState;
    int event;
    int newState;
    Action action;

    public Transition(int currentState, int event, int newState, Action action) {
        this.currentState = currentState;
        this.event = event;
        this.newState = newState;
        this.action = action;
    }
}
