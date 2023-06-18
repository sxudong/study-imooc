package com.payroll.transactionApplication;

import com.payroll.transactionApplication.Transaction;

public interface TransactionSource {
    Transaction getTransaction(String type);
}
