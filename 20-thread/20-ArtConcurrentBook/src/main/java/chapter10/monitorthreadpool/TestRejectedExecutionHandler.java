package chapter10.monitorthreadpool;

import java.util.concurrent.RejectedExecutionHandler;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * 任务拒绝执行策略
 */
/*
public class TestRejectedExecutionHandler implements RejectedExecutionHandler {

    private Logger logger = LoggerFactory.getLogger(TestRejectedExecutionHandler.class);

    @Override
    public void rejectedExecution(Runnable r, ThreadPoolExecutor executor) {
        logger.debug(r.toString() + ": has been rejected.");
    }

}
*/