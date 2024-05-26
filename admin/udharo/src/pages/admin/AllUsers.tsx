import React, { useEffect, useState } from 'react'
import Navigationwrap from '../../components/Navigationwrap'
import axios from 'axios';
import { MdDelete } from "react-icons/md";
import { useNavigate } from 'react-router-dom';
interface User{
  _id: number;
  fullName: string;
  email: string;
  riskFactor: number;
  hasKycDetails?: boolean;
}
const AllUsers: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [error, setError] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(true);
  const navigate = useNavigate();
useEffect(() => {
  let isMounted = true;

  const fetchAllUsers = async () => {
    try{
      const token = localStorage.getItem('token');
      if(!token){
        throw new Error('Authentication token not found!');
      }
      // console.log("Fetching all users...");
      const response = await axios.get('http://localhost:3004/api/admin/allUsers',   {
        headers: {
          Authorization: `Bearer ${token}`,
        },
    });


       const users = response.data.message;

        if (isMounted) {
          // Fetch KYC details status for each user
          const usersWithKycStatus = await Promise.all(users.map(async (user: User) => {
            try {
              const kycResponse = await axios.get(`http://localhost:3004/api/admin/kycDetails/${user._id}`, {
                headers: {
                  Authorization: `Bearer ${token}`,
                },
              });
              return { ...user, hasKycDetails: true };
            } catch (error) {
              if (axios.isAxiosError(error) && error.response && error.response.data.message === "KYC not found") {
                return { ...user, hasKycDetails: false };
              }
              return { ...user, hasKycDetails: false };
            }
          }));

          setUsers(usersWithKycStatus);
          setLoading(false);
        }
    }catch (error) {
      if (axios.isAxiosError(error)) {
        console.error("Axios error occurred:", error);
        if (error.response) {
          setError(`Error: ${error.response.status} - ${error.response.data.message}`);
        } else if (error.request) {
          setError('Error: No response from server. Please try again later.');
        } else {
          setError(`Error: ${error.message}`);
        }
      } else {
        console.error("Non-Axios error occurred:", error);
        setError(`Error: ${(error as Error).message}`);
      }
    }
  };

  fetchAllUsers();
  return () => {
    isMounted = false;
  };
}, []);

const handleUserDetailsClick = (_id: number) => {
  console.log('Navigating to user details with id:', _id);
  navigate(`/userdetails/${_id}`);
}
const handleKycDetailsClick = (_id: number) => {
  console.log('Navigating to Kyc details with id:', _id);
  navigate(`/kycdetails/${_id}`);
}

  return (
    <>
    <Navigationwrap>

    <div className=" mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">

      <h1 className='font-bold text-3xl mx-3'>All Users</h1>
      {error && <p className="error">{error}</p>}
      {loading ? (
            <div className="flex justify-center mt-20 h-screen">
              <div className="newtons-cradle">
                <div className="newtons-cradle__dot"></div>
                <div className="newtons-cradle__dot"></div>
                <div className="newtons-cradle__dot"></div>
                <div className="newtons-cradle__dot"></div>
              </div>
            </div>
          ) : (
      <ul>
        <div className="grid grid-cols-2">
        {users.map(user => (
          <div className="border-2 m-2 p-2 rounded-md border-orange-300 shadow-md flex justify-between items-center hover:cursor-pointer transition duration-300 ease-in-out" key={user._id}
          >
            <div className="">
          <p className='p-2 font-bold'>{user.fullName.charAt(0).toUpperCase() + user.fullName.slice(1)}</p>
          <p className='p-2 '>{user.email}</p>
          <p className='p-2 '>Risk Factor - {user.riskFactor}</p>
          </div>
          <div className="flex flex-col">
          <div className=""><button className='border border-orange-300 rounded-md p-2 m-2 hover:bg-orange-300 transition duration-500 '  onClick={() => handleUserDetailsClick(user._id)}>User Details</button></div>

          {user.hasKycDetails && (
          <div className=""><button className='border border-orange-300 rounded-md p-2 m-2 hover:bg-orange-300 transition duration-500'  onClick={() => handleKycDetailsClick(user._id)}>KYC Details</button></div>
          )}
          <div className="flex justify-center">
            <button className='bg-red-400 rounded-full hover:transition duration-700 text-2xl hover:bg-red-600 m-1 p-2 text-white font-bold'><MdDelete /></button>
          </div>
          </div>
          </div>
        ))}
        </div>
      </ul>
        )}
    </div>
    </Navigationwrap>
    </>
  );
};

export default AllUsers;