package com.payroll.payrollDomain;

import java.util.Date;

/**
 * 支付时间表抽象
 */
public abstract class PaymentSchedule {
    /** 是否是发薪日 */
    public abstract boolean isPayDate(Date date);
    public abstract Date getPayPeriodStartDate(Date payPeriodEndDate);
}
