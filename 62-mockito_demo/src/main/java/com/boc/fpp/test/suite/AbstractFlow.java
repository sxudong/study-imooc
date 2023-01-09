package com.boc.fpp.test.suite;

import java.util.Map;
import java.util.function.Supplier;

public abstract class AbstractFlow {
    protected Suite suite;
    public AbstractFlow(Suite suite) {
        this.suite = suite;
    }

    @SuppressWarnings("unchecked")
    protected <T> T getValueFromContext(String repositoryName, Supplier<T> repositorySupplier){
        Map<String, Object> repositoryContext = suite.getRepositoryContext();
        if(!repositoryContext.containsKey(repositoryName)){
            repositoryContext.put(repositoryName, repositorySupplier.get());
        }
        return (T) repositoryContext.get(repositoryName);
    }
}
