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

const MyRoutes = () => {
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
          <Route
            path="/transactiondetails/:_id"
            element={<TransactionDetails />}
          />
        </Route>
      </Routes>
    </Router>
  );
};

export default MyRoutes;
