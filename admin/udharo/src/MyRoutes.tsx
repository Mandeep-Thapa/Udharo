// import React from 'react'
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import AdminLogin from "./pages/admin/AdminLogin";
import AdminRegister from "./pages/admin/AdminRegister";
import Dashboard from "./pages/admin/Dashboard";
import Protected from "./components/Protected";

const MyRoutes = () => {
  
  return (
    <Router>
      <Routes>
        <Route path="/" element={<AdminLogin />} />
        <Route path="/register" element={<AdminRegister />} />
        <Route element={<Protected/>}>
          <Route path="/dashboard" element={<Dashboard />} />
        </Route>
        
       
      </Routes>
    </Router>
  );
};

export default MyRoutes;
