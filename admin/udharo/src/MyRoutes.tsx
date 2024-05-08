// import React from 'react'
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import AdminLogin from "./pages/admin/AdminLogin";
import AdminRegister from "./pages/admin/AdminRegister";
import Dashboard from "./pages/admin/Dashboard";
import Navigation from "./pages/Navigation";

const MyRoutes = () => {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<AdminLogin />} />
        <Route path="/register" element={<AdminRegister />} />
        <Route path="/navigation" element={<Navigation />}/>
          <Route path="/dashboard" element={<Dashboard />} />
       
      </Routes>
    </Router>
  );
};

export default MyRoutes;
