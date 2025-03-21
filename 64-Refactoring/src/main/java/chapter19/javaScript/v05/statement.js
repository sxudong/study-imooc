function statement(invoice, plays) {
    function amountFor(aPerformance) {
        let thisAmount = 0;

        switch (playFor(aPerformance).type) {
            case "tragedy":
                thisAmount = 40000;
                if (aPerformance.audience > 30) {
                    thisAmount += 1000 * (aPerformance.audience - 30);
                }
                break;
            case "comedy":
                thisAmount = 30000;
                if (aPerformance.audience > 20) {
                    thisAmount += 10000 + 500 * (aPerformance.audience - 20);
                }
                thisAmount += 300 * aPerformance.audience;
                break;
            default:
                throw new Error(`unknown type: ${playFor(aPerformance).type}`);
        }

        return thisAmount;
    }

    function playFor(aPerformance) {
        return plays[aPerformance.playID];
    }

    function volumeCreditsFor(aPerformance) {
        let result = 0;
        result += Math.max(aPerformance.audience - 30, 0);
        if ("comedy" === playFor(aPerformance).type) result += Math.floor(aPerformance.audience / 5);
        return result;
    }

    function usd(aNumber) {
        return new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            minimumFractionDigits: 2
        }).format(aNumber / 100);
    }

    function totalVolumeCredits() {
        let volumeCredits = 0;
        for (let perf of invoice.performances) {
            volumeCredits += volumeCreditsFor(perf);
        }
        return volumeCredits;
    }

    let totalAmount = 0;
    let result = `Statement for ${invoice.customer}\n`;

    for (let perf of invoice.performances) {
        // print line for this order
        result += ` ${playFor(perf).name}: ${usd(amountFor(perf))} (${perf.audience} seats)\n`;
        totalAmount += amountFor(perf);
    }

    // let volumeCredits = 0;
    // for (let perf of invoice.performances) {
    //   volumeCredits += volumeCreditsFor(perf);
    // }

    // let volumeCredits = totalVolumeCredits();

    result += `Amount owed is ${usd(totalAmount)}\n`;
    result += `You earned ${totalVolumeCredits()} credits\n`;

    console.info(result);

    return result;
}

module.exports = statement;