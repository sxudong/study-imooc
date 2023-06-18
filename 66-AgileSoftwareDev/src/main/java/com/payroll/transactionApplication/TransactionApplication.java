package com.payroll.transactionApplication;

import com.payroll.textParserTransactionSource.TextParserTransactionSource;

public abstract class TransactionApplication {
    private TransactionSource textParserTransactionSource = new TextParserTransactionSource();

    public TransactionSource getTextParserTransactionSource() {
        return textParserTransactionSource;
    }


}
