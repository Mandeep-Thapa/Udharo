// import React from 'react'
import { BrowserRouter, Route, Routes } from "react-router-dom";
import AdminLogin from './pages/admin/AdminLogin';
import Admin from "./pages/Admin";



const MyRoutes = () => {
  return (
 
   <BrowserRouter>
     <Routes>

     <Route path="/"  element={<AdminLogin />} />
     <Route path="/dashboard"  element={<Admin />} />

     </Routes>
    </BrowserRouter>
  )
}

export default MyRoutes
