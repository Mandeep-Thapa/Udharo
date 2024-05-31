import React, { useEffect } from 'react'
import { Outlet, useNavigate } from 'react-router-dom';
import Cookies from 'js-cookie'
import AdminLogin from '../pages/admin/AdminLogin';
import { toast } from 'sonner';

interface JwtPayload {
  exp: number;
  [key: string]: any; 
}
const Protected = () => {
  const navigate = useNavigate();
  useEffect(() => {
    const authToken = Cookies.get('authToken');

    if (authToken) {
      try {
        const decodedToken = parseJwt(authToken) as JwtPayload;
        const currentTime = Date.now() / 1000;

        if (decodedToken.exp < currentTime) {
          // Token has expired
          handleLogout();
        }
      } catch (error) {
        // If there's an error decoding the token, handle it by logging out
        handleLogout();
      }
    } else {
      // No token, redirect to login
      navigate('/');
    }
    
  }, [navigate]);
  const handleLogout = () => {
    toast('Session Expired! Please login again.');
    Cookies.remove('authToken');
    localStorage.removeItem('token');
    setTimeout(() => {
    navigate('/');
    }, 1000);
  };
  const parseJwt = (token: string): JwtPayload | null => {
    try {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(
        atob(base64)
          .split('')
          .map((c) => {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
          })
          .join('')
      );

      return JSON.parse(jsonPayload);
    } catch (error) {
      return null;
    }
  };
  const authToken = Cookies.get('authToken');
  return authToken ? <Outlet/> : <AdminLogin/>
}

export default Protected
