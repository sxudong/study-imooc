package com.payroll.transactionApplication;

import com.payroll.application.Application;
import com.payroll.textParserTransactionSource.TextParserTransactionSource;

public abstract class TransactionApplication implements Application {
    private TransactionSource textParserTransactionSource = new TextParserTransactionSource();

    public TransactionSource getTextParserTransactionSource() {
        return textParserTransactionSource;
    }

}
