const userMethods = {
  calculateRiskFactor: function () {
    this.riskFactor = Math.round(
      (this.riskFactorDetails.verificationStatus * 5 +
        this.riskFactorDetails.moneyInvested * 5 +
        this.riskFactorDetails.timelyRepayment * 5 +
        this.riskFactorDetails.lateRepayment * 5) /
        20
    );
  },

  updateVerificationStatus: function (is_verifiedDetails) {
    if (
      this.is_verifiedDetails.is_panVerified &&
      this.is_verifiedDetails.is_kycVerified &&
      this.is_verifiedDetails.is_emailVerified
    ) {
      this.riskFactorDetails.verificationStatus = 5;
    } else if (
      this.is_verifiedDetails.is_kycVerified &&
      this.is_verifiedDetails.is_emailVerified
    ) {
      this.riskFactorDetails.verificationStatus = 3;
    } else if (this.is_verifiedDetails.is_emailVerified) {
      this.riskFactorDetails.verificationStatus = 2;
    } else {
      this.riskFactorDetails.verificationStatus = 1;
    }
  },

  updateMoneyInvested: function (moneyInvestedDetails) {
    if (moneyInvestedDetails > 20000) {
      this.riskFactorDetails.moneyInvested = 5;
    } else if (moneyInvestedDetails > 15000) {
      this.riskFactorDetails.moneyInvested = 4;
    } else if (moneyInvestedDetails > 10000) {
      this.riskFactorDetails.moneyInvested = 3;
    } else if (moneyInvestedDetails > 5000) {
      this.riskFactorDetails.moneyInvested = 2;
    } else {
      this.riskFactorDetails.moneyInvested = 1;
    }
  },

  updateTimelyRepayment: function (timelyRepaymentDetails) {
    if (timelyRepaymentDetails > 20) {   //{(total number of timely repayment)%(total number of transactions)} * 100
      this.riskFactorDetails.timelyRepayment = 5;
    } else if (timelyRepaymentDetails > 15) {
      this.riskFactorDetails.timelyRepayment = 4;
    } else if (timelyRepaymentDetails > 10) {
      this.riskFactorDetails.timelyRepayment = 3;
    } else if (timelyRepaymentDetails > 5) {
      this.riskFactorDetails.timelyRepayment = 2;
    } else {
      this.riskFactorDetails.timelyRepayment = 1;
    }
  },

  updateLateRepayment: function (lateRepaymentDetails) {
    if (lateRepaymentDetails > 20) {
      this.riskFactorDetails.lateRepayment = 1;
    } else if (lateRepaymentDetails > 15) {
      this.riskFactorDetails.lateRepayment = 2;
    } else if (lateRepaymentDetails > 10) {
      this.riskFactorDetails.lateRepayment = 3;
    } else if (lateRepaymentDetails > 5) {
      this.riskFactorDetails.lateRepayment = 4;
    } else {
      this.riskFactorDetails.lateRepayment = 5;
    }
  },
};

module.exports = userMethods;
