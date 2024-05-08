import axios from 'axios';
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Cookies from 'js-cookie';
import Navigationwrap from '../../components/Navigationwrap';

interface AdminDetails {
   name: string;
   email: string;
}
const Dashboard: React.FC = () => {
   const [adminDetails, setAdminDetails] = useState<AdminDetails | null>(null);
   const navigate = useNavigate();

   useEffect(() => {
      const fetchAdminDetails = async () => {
         try{
            const authToken = Cookies.get('authToken');
            const response = await axios.get('http://localhost:3004/api/admin/details', {
            headers: {
               Authorization: `Bearer ${authToken}`
            }
            });
            setAdminDetails(response.data);

            if(!response.data){
               navigate('/')
            }
         }catch{
            console.log("Error fetching admin details:", Error);
         }
      };
      fetchAdminDetails();
   }, []);
  return (
    <>
    <Navigationwrap>
      <div className="bg-gray-300 mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
         <h1 className='text-3xl font-bold'>Admin Details</h1>
         {
            adminDetails && (
               <div className="text-xl font-bold flex flex-wrap">
                  <div className='border rounded-md flex p-3 justify-start items-center mt-2'>User: {adminDetails.email}</div>
               </div>
            )
         }
         </div>
      </Navigationwrap>
    </>
  )
}

export default Dashboard
