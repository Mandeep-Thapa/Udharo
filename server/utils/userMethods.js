const userMethods = {
  ensureRiskFactorDetailsInitialized: function () {
    if (!this.riskFactorDetails) {
      this.riskFactorDetails = {
        verificationStatus: 0,
        moneyInvested: 0,
        timelyRepayment: 0,
        lateRepayment: 0,
      };
    }
  },

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
    if (moneyInvestedDetails > 200) {
      this.riskFactorDetails.moneyInvested = 5;
    } else if (moneyInvestedDetails > 150) {
      this.riskFactorDetails.moneyInvested = 4;
    } else if (moneyInvestedDetails > 100) {
      this.riskFactorDetails.moneyInvested = 3;
    } else if (moneyInvestedDetails > 50) {
      this.riskFactorDetails.moneyInvested = 2;
    } else {
      this.riskFactorDetails.moneyInvested = 1;
    }
  },

  updateTimelyRepayment: function (timelyRepaymentDetails) {
<<<<<<< HEAD
    if (timelyRepaymentDetails > 20) {   //{(total number of timely repayment)%(total number of transactions)} * 100
=======
    if (timelyRepaymentDetails > 15) {
>>>>>>> 7dc0cbe1edcdaf320b2e4cf94ed34fbc8ddfcb67
      this.riskFactorDetails.timelyRepayment = 5;
    } else if (timelyRepaymentDetails > 10) {
      this.riskFactorDetails.timelyRepayment = 4;
    } else if (timelyRepaymentDetails > 5) {
      this.riskFactorDetails.timelyRepayment = 3;
    } else if (timelyRepaymentDetails > 2) {
      this.riskFactorDetails.timelyRepayment = 2;
    } else {
      this.riskFactorDetails.timelyRepayment = 1;
    }
  },

  updateLateRepayment: function (lateRepaymentDetails) {
    if (lateRepaymentDetails > 15) {
      this.riskFactorDetails.lateRepayment = 1;
    } else if (lateRepaymentDetails > 10) {
      this.riskFactorDetails.lateRepayment = 2;
    } else if (lateRepaymentDetails > 5) {
      this.riskFactorDetails.lateRepayment = 3;
    } else if (lateRepaymentDetails > 2) {
      this.riskFactorDetails.lateRepayment = 4;
    } else {
      this.riskFactorDetails.lateRepayment = 5;
    }
  },
};

module.exports = userMethods;
