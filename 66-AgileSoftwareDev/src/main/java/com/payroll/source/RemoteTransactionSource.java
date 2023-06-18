package com.payroll.source;

import com.payroll.transactionApplication.Transaction;
import com.payroll.transactionApplication.TransactionSource;

public class RemoteTransactionSource implements TransactionSource {
    @Override
    public Transaction getTransaction(String type) {
        return null;
    }
}
