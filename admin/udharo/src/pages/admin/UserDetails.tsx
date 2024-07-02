import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import Navigationwrap from '../../components/Navigationwrap';
import { FaCheckCircle, FaTimesCircle } from 'react-icons/fa';
import { Toaster, toast } from 'sonner';
import Switch from "react-switch";
import '../../../public/style.css'

interface RiskFactorDetails {
   verificationStatus: number;
   moneyInvested: number;
   timelyRepayment: number;
   lateRepayment: number;
 }
interface isVerified{
  UserId: string;
  email: boolean;
  kyc: boolean;
  pan: boolean;
}
interface UserDetails {
  _id: string;
  userName: string;
  email: string;
  riskFactor: number;
  isVerified: isVerified;
  riskFactorDetails: RiskFactorDetails;
  moneyInvestedDetails: number;
  timelyRepaymentDetails: number;
  lateRepaymentDetails: string;
}

const UserDetails: React.FC = () => {
  const { _id } = useParams<{ _id: string }>();
  console.log('User ID:', _id);
  const [userDetails, setUserDetails] = useState<UserDetails | null>(null);
  const [error, setError] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(true);
  const [panVerified, setPanVerified] = useState<boolean>(false);

  useEffect(() => {
    const fetchUserDetails = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          throw new Error('Authentication token not found!');
        }

        const response = await axios.get(`http://localhost:3004/api/admin/userdetails/${_id}`, {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        setUserDetails(response.data.data);
        console.log(response.data.data.isVerified.pan) //pan ko boolean ayo
        

        setPanVerified(response.data.data.isVerified.pan);//pan ko boolean ayo set vayo
        setLoading(false);
      } catch (error) {
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

    fetchUserDetails();
  }, [_id]);


  if (error) {
    return <p className="error">{error}</p>;
  }
const handlePanToggle = async () => {
  try{
    const token = localStorage.getItem('token');
    // console.log('switch:',token)
    if(!token){
      toast.error('Authentication token not found!');
    }
    const newPanStatus = !panVerified;
    console.log('New:',newPanStatus)
     await axios.put(
      `http://localhost:3004/api/admin/verifyPan/${_id}`,
      { "_id": _id,
        "is_panVerified": newPanStatus }, // Request body with the new PAN status
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    setPanVerified(newPanStatus);
    if(newPanStatus===true){
    toast.success('PAN Verified successfully!');
    }else{
      toast.success('PAN Verification removed!');
    }
  }catch(error){
    toast.error('Failed to update PAN verification!');
  }
};
  return (
    <>
   <Navigationwrap>
    <Toaster/>
    <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
      <h1 className='font-bold text-3xl mx-3'>User Details</h1>

      {loading ? (
               <div className="flex justify-center mt-10 h-screen">
                 <div className="w-16 h-16 border-4 border-yellow-500 border-dotted rounded-full animate-spin"></div>
               </div>
             ) : (
      userDetails && (
      <div className="mt-3 m-2 p-2 rounded-md flex justify-center items-start gap-10 " key={_id}>
      <table className="w-full border-collapse">
        <tbody>
          <tr className="bg-custom-sudesh_grey hover:bg-custom-sudesh_grey">
            <td className="p-2 border font-bold">Full Name:</td>
            <td className="p-2 border text-center">{userDetails.userName.charAt(0).toUpperCase() + userDetails.userName.slice(1)}</td>
          </tr>
          <tr className='hover:bg-custom-sudesh_grey'>
            <td className="p-2 border font-bold">Email:</td>
            <td className="p-2 border text-center">{userDetails.email}</td>
          </tr>
          <tr className="bg-custom-sudesh_grey hover:bg-custom-sudesh_grey">
            <td className="p-2 border font-bold">Risk Factor:</td>
            <td className="p-2 border text-center">{userDetails.riskFactor}</td>
          </tr>
          <tr className='hover:bg-custom-sudesh_grey'>
            <td className="p-2 border font-bold">Verification Status:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.verificationStatus}</td>
          </tr>
          <tr className="bg-custom-sudesh_grey hover:bg-custom-sudesh_grey">
            <td className="p-2 border font-bold">Money Invested:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.moneyInvested}</td>
          </tr>
          <tr className='hover:bg-custom-sudesh_grey'>
            <td className="p-2 border font-bold">Timely Repayment:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.timelyRepayment}</td>
          </tr>
          <tr className="bg-custom-sudesh_grey hover:bg-custom-sudesh_grey">
            <td className="p-2 border font-bold">Late Repayment:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.lateRepayment}</td>
          </tr>
          <tr className='hover:bg-custom-sudesh_grey'>
            <td className="p-2 border font-bold">Money Invested Details:</td>
            <td className="p-2 border text-center">{userDetails.moneyInvestedDetails}</td>
          </tr>
          <tr className="bg-custom-sudesh_grey hover:bg-custom-sudesh_grey">
            <td className="p-2 border font-bold">Timely Repayment Details:</td>
            <td className="p-2 border text-center">{userDetails.timelyRepaymentDetails}</td>
          </tr>
          <tr className='hover:bg-custom-sudesh_grey'>
            <td className="p-2 border font-bold">Late Repayment Details:</td>
            <td className="p-2 border text-center">{userDetails.lateRepaymentDetails}</td>
          </tr>
        </tbody>
      </table>
      <div className="flex flex-col gap-10 border-2 p-12 rounded-lg border-custom-sudesh_yellow ">
       <span className='text-xl font-bold my-4'> Verifications</span>
        <div className="flex flex-col gap-16">
          <span className='flex gap-4 justify-center items-center font-bold'>Email:  {userDetails.isVerified.email ? (
                      <FaCheckCircle className="text-green-600 text-xl ml-2" />
                    ) : (
                      <FaTimesCircle className="text-red-600 text-xl ml-2" />
                    )}</span>
          <span className='flex gap-4 justify-center items-center font-bold'>KYC:   {userDetails.isVerified.kyc ? (
                      <FaCheckCircle className="text-green-600 text-xl ml-2" />
                    ) : (
                      <FaTimesCircle className="text-red-600 text-xl ml-2" />
                    )}</span>
          <span className='flex gap-4 justify-center items-center font-bold'>Pan:
          <Switch
                        className="switch-root"
                        checked={panVerified}
                        onChange={handlePanToggle}
                      
                      />
                     
                    </span>
        </div>
      </div>
    </div>
      )
      )}
    </div>
    </Navigationwrap>
    </>
  );
};

export default UserDetails;
