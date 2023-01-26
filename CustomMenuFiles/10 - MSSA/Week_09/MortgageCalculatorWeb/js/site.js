const ORIGINATION_FEE_PERCENT = 0.01; 
const CLOSING_COSTS = 2500.0;
const PROPERTY_TAX_PERCENT = .0125;
const HOMEOWNERS_INS_PERCENT = .0075;
const LOAN_INS_PERCENT = .01;
const TERM_PAYMENTS = 12.0;
const PERCENT_CONVERTER = 100.0;
const EQUITY_PERCENT_NO_INS_MIN = 10.0;
const INCOME_RATIO_MAX_PERCENT = 25.0;

function calculatePayment(income, purchasePrice, marketValue, downPayment, termYears, interestRate, hoaFees)
{
    //get gap in downpayment vs marketvalue
    var valueAdjustment = purchasePrice - marketValue;

    //calculate the amount total on the cost + fees and subtract downpayment.
    var totalLoanValue = calculateLoanValue(purchasePrice, downPayment);

    var equityDown = downPayment + valueAdjustment;
    var equityValuePercentage = calculateEquityValuePercentage(totalLoanValue, equityDown);
    var insPayment = 0.0;
    if (equityValuePercentage < EQUITY_PERCENT_NO_INS_MIN)
    {
        insPayment = (LOAN_INS_PERCENT * totalLoanValue) / 12;
        insPayment = insPayment.toFixed(2);
    }

    var gMP = calculateMonthlyPayment(totalLoanValue, interestRate, 12, termYears);
    var escrow = calculateEscrow(marketValue);

    var tMP = calculateTotalPayment(gMP, insPayment, hoaFees, escrow);


    return tMP;

}

function calculateLoanValue(purchasePrice, downPayment)
{
    var originAmount = purchasePrice - downPayment;
    var originationFee = originAmount * ORIGINATION_FEE_PERCENT;
    return originAmount + originationFee + CLOSING_COSTS;
}

function getEquityValue(totalLoanValue, effectiveDownPayment)
{
    if (effectiveDownPayment <= 0.0) return 0.0;
    var equityPercent = (effectiveDownPayment / totalLoanValue) * PERCENT_CONVERTER;
    equityPercent = equityPercent.toFixed(2);
    equityValue = (totalLoanValue * equityPercent) / PERCENT_CONVERTER;

    return equityPercent;
}

function calculateMonthlyPayment(initialLoanAmount, annualInterestRate, numberOfPaymentsPerYear, termYears)
{
    //Payment = P x (r / n) x (1 + r / n)^n(t)] / (1 + r / n)^n(t) - 1
    var ratePerPayment = annualInterestRate / numberOfPaymentsPerYear;
    var additionalPaymentValue = 1.0 + ratePerPayment;
    var totalPayments = numberOfPaymentsPerYear * termYears;
    var ratePerPaymentTerm = Math.pow(additionalPaymentValue, totalPayments);
    var payment = (initialLoanAmount * ratePerPayment * ratePerPaymentTerm) / (ratePerPaymentTerm - 1.0);
    return payment.toFixed(2);
}

function calculateEscrow(marketValue) {
    var taxesPerYear = marketValue * PROPERTY_TAX_PERCENT;
    taxesPerYear = taxesPerYear.toFixed();
    var homeownersPerYear = marketValue * HOMEOWNERS_INS_PERCENT;
    homeownersPerYear = homeownersPerYear.toFixed();
    return taxesPerYear + homeownersPerYear;
}

function calculateTotalPayment(baseMonthlyPayment, insurancePayment, hoaPerMonth, monthlyEscrow){
    var totalMonthlyPayment = baseMonthlyPayment + insurancePayment + hoaPerMonth + monthlyEscrow;
    return totalMonthlyPayment.toFixed(2);
}

function computeApproveDeny(monthlyIncome, totalMonthlyPayment)
{
    var percentMonthlyIncome = totalMonthlyPayment / monthlyIncome  * PERCENT_CONVERTER;
    return approved = percentMonthlyIncome < INCOME_RATIO_MAX_PERCENT;
}