import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import Navigationwrap from '../../components/Navigationwrap';

interface RiskFactorDetails {
   verificationStatus: number;
   moneyInvested: number;
   timelyRepayment: number;
   lateRepayment: number;
 }

interface UserDetails {
  _id: string;
  userName: string;
  email: string;
  riskFactor: number;
  riskFactorDetails: RiskFactorDetails;
  moneyInvestedDetails: number;
  timelyRepaymentDetails: number;
  lateRepaymentDetails: string;
}

const UserDetails: React.FC = () => {
  const { _id } = useParams<{ _id: string }>();
//   console.log('User ID:', _id);
  const [userDetails, setUserDetails] = useState<UserDetails | null>(null);
  const [error, setError] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(true);

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

  return (
   <Navigationwrap>
    <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
      <h1 className='font-bold text-3xl mx-3'>User Details</h1>

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
      userDetails && (
      <div className="mt-3 m-2 p-2 rounded-md flex justify-center items-start flex-col w-[700px] border border-orange-300" key={_id}>
      <table className="w-full border-collapse">
        <tbody>
          <tr className="bg-orange-200">
            <td className="p-2 border font-bold">Full Name:</td>
            <td className="p-2 border text-center">{userDetails.userName.charAt(0).toUpperCase() + userDetails.userName.slice(1)}</td>
          </tr>
          <tr>
            <td className="p-2 border font-bold">Email:</td>
            <td className="p-2 border text-center">{userDetails.email}</td>
          </tr>
          <tr className="bg-orange-200">
            <td className="p-2 border font-bold">Risk Factor:</td>
            <td className="p-2 border text-center">{userDetails.riskFactor}</td>
          </tr>
          <tr>
            <td className="p-2 border font-bold">Verification Status:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.verificationStatus}</td>
          </tr>
          <tr className="bg-orange-200">
            <td className="p-2 border font-bold">Money Invested:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.moneyInvested}</td>
          </tr>
          <tr>
            <td className="p-2 border font-bold">Timely Repayment:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.timelyRepayment}</td>
          </tr>
          <tr className="bg-orange-200">
            <td className="p-2 border font-bold">Late Repayment:</td>
            <td className="p-2 border text-center">{userDetails.riskFactorDetails.lateRepayment}</td>
          </tr>
          <tr>
            <td className="p-2 border font-bold">Money Invested Details:</td>
            <td className="p-2 border text-center">{userDetails.moneyInvestedDetails}</td>
          </tr>
          <tr className="bg-orange-200">
            <td className="p-2 border font-bold">Timely Repayment Details:</td>
            <td className="p-2 border text-center">{userDetails.timelyRepaymentDetails}</td>
          </tr>
          <tr>
            <td className="p-2 border font-bold">Late Repayment Details:</td>
            <td className="p-2 border text-center">{userDetails.lateRepaymentDetails}</td>
          </tr>
        </tbody>
      </table>
    </div>
      )
      )}
    </div>
    </Navigationwrap>
  );
};

export default UserDetails;
