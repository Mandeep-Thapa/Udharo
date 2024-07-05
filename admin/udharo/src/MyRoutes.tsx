// import React from 'react'
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import AdminLogin from "./pages/admin/AdminLogin";
import AdminRegister from "./pages/admin/AdminRegister";
import Dashboard from "./pages/admin/Dashboard";
import Protected from "./components/Protected";
import AllUsers from "./pages/admin/AllUsers";
import UserDetails from "./pages/admin/UserDetails";
import KycDetails from "./pages/admin/KycDetails";
import TransactionDetails from "./pages/admin/TransactionDetails";
import ApprovedBorrowRequest from "./pages/admin/ApprovedBorrowRequest";
import BorrowersRole from "./pages/admin/BorrowersRole";
import KhaltiPayment from "./pages/admin/KhaltiPayment";
import axios from "axios";
import LenderRoleComponent from "./pages/admin/LendersRole";
const MyRoutes = () => {
  const handleSuccess = async (payload: any) => {
    try {
      const response = await axios.post('http://localhost:5000/api/verify-payment', {
        token: payload.token,
        amount: payload.amount,
      });

      if (response.data.success) {
        alert('Payment Successful');
        // Further actions like updating the order status in your database
      } else {
        alert('Payment Failed');
      }
    } catch (error) {
      console.error(error);
      alert('Payment Verification Failed');
    }
  };
  return (
    <Router>
      <Routes>
        <Route path="/" element={<AdminLogin />} />
        <Route path="/register" element={<AdminRegister />} />
        <Route element={<Protected />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/users" element={<AllUsers />} />
          <Route path="/userdetails/:_id" element={<UserDetails />} />
          <Route path="/kycdetails/:_id" element={<KycDetails />} />
          <Route path="/transactions/:_id" element={<TransactionDetails />} />
          <Route
            path="/payment"
            element={
              <KhaltiPayment
                amount={100}
                purchaseOrderId="1234"
                purchaseOrderName="Test Product"
                onSuccess={handleSuccess}
              />
            }
          />
          <Route path="/approvedborrowrequest" element={<ApprovedBorrowRequest />} />
          <Route path="/borrowers" element={<BorrowersRole />} />
          <Route path="/lenders" element={<LenderRoleComponent />} />
        </Route>
      </Routes>
    </Router>
  );
};

export default MyRoutes;
