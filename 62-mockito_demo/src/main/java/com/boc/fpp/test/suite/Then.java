package com.boc.fpp.test.suite;

public class Then extends AbstractFlow {
    public Then(Suite suite){
        super(suite);
    }

    public Database database(){
        return getValueFromContext("database", () -> new Database(super.suite));
    }

    public BOC boc() {
        return getValueFromContext("boc", () -> new BOC(super.suite));
    }

    public Notification notification() {
        return getValueFromContext("notification",() -> new Notification(super.suite));
    }
}
