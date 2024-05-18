import axios from 'axios';
import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom';
import Cookies from 'js-cookie';
import Navigationwrap from '../../components/Navigationwrap';
import { FaUser, FaRegMoneyBillAlt} from "react-icons/fa";
import { LiaBlenderSolid } from "react-icons/lia";
import { HiUserGroup } from "react-icons/hi";
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
      <div className=" mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
         <h1 className='text-3xl font-bold'></h1>
         {
            adminDetails && (
               <div className="text-xl font-bold flex flex-wrap">
                  <div className='border rounded-md flex p-3 justify-start items-center mt-2'><span className='mx-3'>Admin:</span> {adminDetails.email}</div>
               </div>
            )
         }
<div className="rounded-lg grid xs:grid-cols-1 md:grid-cols-3 m-4">
   <a href="/users">
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>All Users</h1>
<span className=' text-4xl'><FaUser /></span>
</div>
</a>

<a href="/details">
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>KYC Details</h1>
<span className=' text-4xl'><FaUser /></span>
</div>
</a>
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>Lenders</h1>
<span className=' text-4xl'><FaRegMoneyBillAlt /></span>
</div>
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>Borrowers</h1>
<span className=' text-4xl'><LiaBlenderSolid /></span>
</div>
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>Account Management</h1>
<span className=' text-4xl'><FaUser /></span>
</div>
<div className="border-2 border-yellow-400 rounded-md hover:cursor-pointer hover:bg-yellow-100 hover:transition  duration-500 flex items-center flex-col m-3 p-3 h-36">
<h1 className='text-2xl font-bold m-3'>Our Team</h1>
<span className=' text-4xl'><HiUserGroup /></span>
</div>
</div>


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
