package com.boc.fpp.test.suite;

public class When extends AbstractFlow{
    public When(Suite suite) {
        super(suite);
    }

    public ICLMessage fromICL() {
        return new ICLMessage(super.suite);
    }
}
