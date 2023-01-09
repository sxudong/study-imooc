package com.boc.fpp.test.suite;

public class Given extends AbstractFlow{
    public Given(Suite suite) {
        super(suite);
    }

    public Database database() throws Exception {
        return getValueFromContext("database", () -> new Database(super.suite));
    }

    public BOC boc() {
        return getValueFromContext("boc", () -> new BOC(super.suite));
    }

    public Notification notification() {
        return getValueFromContext("notification", () -> new Notification(super.suite));
    }

}
