import React from 'react'
import { Outlet } from 'react-router-dom';
import Cookies from 'js-cookie'
import AdminLogin from '../pages/admin/AdminLogin';

const Protected = () => {
   const token:string | undefined = Cookies.get("authToken")
  return (
    
      token ? <Outlet/> : <AdminLogin/>
    
  )
}

export default Protected
