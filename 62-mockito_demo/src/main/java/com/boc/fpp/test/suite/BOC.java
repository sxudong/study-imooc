package com.boc.fpp.test.suite;

import com.boc.fpp.test.suite.Suite;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import java.util.Map;

public class BOC extends Suite {
    @InjectMocks
    private Object businessObject;
    @Mock
    private EaiCallUtil eaiCallUtil;

    private Suite suite;

    public BOC(Suite suite) {
        this.suite = suite;
    }

    public Map<String, Object>  getRepositoryContext(){
        return null;
    }
}
