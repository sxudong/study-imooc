package com.SpringSourceAnalysis.ch10.transactional;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Transactional(propagation = Propagation.REQUIRED)
public interface UserService {
    void save(User user) throws Exception;
}
