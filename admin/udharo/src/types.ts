
export interface Lender {
   lenderName: string;
   fulfilledAmount: number;
   returnAmount: number;
 }
 
 export interface ApprovedRequest {
   borrowerName: string;
   amountRequested: number;
   numberOfLenders: number;
   lenders: Lender[];
 }
 export interface BorrowerRole {
  id: string;
  name: string;
}
export interface RiskFactorDetails {
  verificationStatus: number;
  moneyInvested: number;
  timelyRepayment: number;
  lateRepayment: number;
}

export interface IsVerifiedDetails {
  is_emailVerified: boolean;
  is_kycVerified: boolean;
  is_panVerified: boolean;
}

export interface UserRole {
  riskFactorDetails: RiskFactorDetails;
  is_verifiedDetails: IsVerifiedDetails;
  totalTransactions: number;
  _id: string;
  fullName: string;
  email: string;
  occupation: string;
  rewardPoints: number;
  hasActiveTransaction: boolean;
  userRole: string;
  riskFactor: number;
  moneyInvestedDetails: number;
  timelyRepaymentDetails: number;
  lateRepaymentDetails: number;
  createdAt: string;
  updatedAt: string;
}

export interface ApiResponse {
  status: string;
  data: {
    users: UserRole[];
  };
}