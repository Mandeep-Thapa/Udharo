import axios from 'axios';
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Cookies from 'js-cookie';
import Navigationwrap from '../../components/Navigationwrap';

interface AdminDetails {
   email: string;
}
// interface UserDetails {
//    id: number;
//    userName: string;
// }
const Dashboard: React.FC = () => {
   const [adminDetails, setAdminDetails] = useState<AdminDetails | null>(null);
   // const [userDetails, setUserDetails] = useState<UserDetails | null>(null);
   // const { id } = useParams<{ id: string }>();
   const navigate = useNavigate();

   useEffect(() => {
      const fetchAdminDetails = async () => {
         try{
            const authToken = Cookies.get('authToken');
            const response = await axios.get('http://localhost:3004/api/admin/admindetails', {
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
   // useEffect(() =>{
   //    const fetchUserDetails = async () => {
     
   //       try{
   //          const authTokenUser = Cookies.get('authToken');
   //          const responseUser = await axios.get(`http://localhost:3004/api/admin/userdetails/${id}`, {
   //          headers: {
   //             Authorization: `Bearer ${authTokenUser}`
   //          }
   //          });
   //          setUserDetails(responseUser.data);

   //          if(!responseUser.data){
   //             navigate('/')
   //          }
   //       }catch(error: any){
   //          console.log("Error fetching user details:", error.message);
   //       }
   // };
   // fetchUserDetails();
   // }, [id]);
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
         {/* <h1>User Details</h1>
         {
            userDetails && (
               <div className="bg-gray-300 mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
                  <div className="border rounded-md flex p-3 justify-start items-center mt-2">{userDetails.userName}</div>
               </div>
            )
         } */}
      </Navigationwrap>
    </>
  )
}

export default Dashboard
