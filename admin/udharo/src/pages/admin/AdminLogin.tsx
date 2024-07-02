import React, { useState, useEffect } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faUserTie } from '@fortawesome/free-solid-svg-icons'
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import Cookies from 'js-cookie'
import { Toaster, toast } from 'sonner';
const AdminLogin = () => {

const [username, setUsername] = useState<string>('');
const [password, setPassword] = useState<string>('');
const [error, setError] = useState<string | boolean>('');
const navigate = useNavigate();

const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
   e.preventDefault();

    try{
      const response = await axios.post('http://localhost:3004/api/admin/login', {
        email: username,
        password: password
      });
if(response.data){
      const token = response.data.token;
      //Store gareko token lai
      localStorage.setItem('token', token);
      //authentication cookie with expiration time
      Cookies.set('authToken', token, {expires: 1}); //Expires in 1 day

      //  console.log('Response:', response);
      console.log('Token', response.data.token);
      toast.success('Logged in successfully!', );
      setUsername('');
      setPassword('');
      setError('');
      setTimeout(() => {
        navigate('/dashboard');
      }, 1000);

   } else{
    setError('Invalid username or password');
   }
  }catch (error){
    setError('Login failed. Please try again.');
   }
  };

useEffect(() => {
  //check authentication cookie exist garxaki nai
  const authToken =  Cookies.get('authToken');
  
  //if yes then navigate to admin.
  if(authToken) {
    navigate('/dashboard');
  }
}, [navigate]);

  return (
    <>
    <Toaster/>
      <div className="bg-custom-sudesh_yellow dark:bg-gray-800 h-screen overflow-hidden flex items-center justify-center">
  <div className="bg-white lg:w-6/12 md:7/12 w-8/12 shadow-3xl rounded-xl">
    <div className="bg-black text-4xl text-white shadow shadow-gray-200 absolute left-1/2 transform -translate-x-1/2 -translate-y-1/2 rounded-full p-4 md:p-6">
    <FontAwesomeIcon icon={faUserTie} />
    </div>
    <form className="p-12 md:p-24" onSubmit={handleSubmit}>
      <h1 className='text-5xl font-bold text-center p-2 mb-2'>Admin</h1>
      <div className="flex items-center text-lg mb-6 md:mb-8">
        <svg className="absolute ml-3" width="24" viewBox="0 0 24 24">
          <path d="M20.822 18.096c-3.439-.794-6.64-1.49-5.09-4.418 4.72-8.912 1.251-13.678-3.732-13.678-5.082 0-8.464 4.949-3.732 13.678 1.597 2.945-1.725 3.641-5.09 4.418-3.073.71-3.188 2.236-3.178 4.904l.004 1h23.99l.004-.969c.012-2.688-.092-4.222-3.176-4.935z"/>
        </svg>
        <input type="text" id="username" className="bg-gray-200 rounded pl-12 py-2 md:py-4 focus:outline-none w-full" placeholder="Username"  value={username} onChange={(e) => setUsername(e.target.value)}/>
      </div>
      <div className="flex items-center text-lg mb-6 md:mb-8">
        <svg className="absolute ml-3" viewBox="0 0 24 24" width="24">
          <path d="m18.75 9h-.75v-3c0-3.309-2.691-6-6-6s-6 2.691-6 6v3h-.75c-1.24 0-2.25 1.009-2.25 2.25v10.5c0 1.241 1.01 2.25 2.25 2.25h13.5c1.24 0 2.25-1.009 2.25-2.25v-10.5c0-1.241-1.01-2.25-2.25-2.25zm-10.75-3c0-2.206 1.794-4 4-4s4 1.794 4 4v3h-8zm5 10.722v2.278c0 .552-.447 1-1 1s-1-.448-1-1v-2.278c-.595-.347-1-.985-1-1.722 0-1.103.897-2 2-2s2 .897 2 2c0 .737-.405 1.375-1 1.722z"/>
        </svg>
        <input type="password" id="password" className="bg-gray-200 rounded pl-12 py-2 md:py-4 focus:outline-none w-full" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)} />
      </div>
      {error && <p className="text-red-500">{error}</p>}
      <button className="bg-gradient-to-b from-orange-400 to-custom-sudesh_yellow font-medium p-2 md:p-4 text-white uppercase w-full rounded" type='submit'>Login</button>
<div className="flex justify-end">
      <a href='/register' className='font-bold rounded-md p-2'>Register?</a></div>
    </form>
  </div>
 </div>
    </>
  )
}

export default AdminLogin
