import React  from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';
import { useState, useEffect } from 'react';
import Navigationwrap from '../../components/Navigationwrap';

interface KycDetailsProps {
   _id: string;
   firstName: string;
   lastName: string;
   gender: string;
   photo: string;
   citizenshipNumber: number;
   citizenshipFrontPhoto: string;
   citizenshipBackPhoto: string;
   isKYCVerified: boolean;
   __v: number;
}

const KycDetails: React.FC = () => {

   const {_id} = useParams<{_id: string}>();
   const [kycdetails, setKycDetails] = useState<KycDetailsProps | null>(null);
   const [error, setError] = useState<string>('');
   const [loading, setLoading] = useState<boolean>(true);
   
useEffect(() => {
   const fetchKycDetails = async () => {
      try {
         const token = localStorage.getItem('token');
         if(!token){
            throw new Error('Authentication token not found')
         }
         const response = await axios.get(`http://localhost:3004/api/admin/kycDetails/${_id}`, {
            headers: {
               Authorization: `Bearer ${token}`,
            },
         });
         setKycDetails(response.data.messgae);
         setLoading(false);
      } catch (error) {
         if(axios.isAxiosError(error)){
            console.log("Axios error occured:", error);
            if(error.response){
               setError(`Error: ${error.response.status} - ${error.response.data.message}`);
            }else if(error.request){
               setError('Error: No response from server. Please try again later.');
            }else {
               setError(`Error: ${error.message}`);
             }
           } else {
             console.error("Non-Axios error occurred:", error);
             setError(`Error: ${(error as Error).message}`);
           }
           setLoading(false);
         }
      };
      fetchKycDetails();
   }, [_id]);

   if(error){
      return <p className='error'>{error}</p>
   }
   return (
      <>
      <Navigationwrap>
      <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
        <h1 className='font-bold text-3xl mx-3'>KYC Details</h1>
        {loading ? (
          <div className="flex justify-center mt-20 h-screen">
            <div className="newtons-cradle">
              <div className="newtons-cradle__dot"></div>
              <div className="newtons-cradle__dot"></div>
              <div className="newtons-cradle__dot"></div>
              <div className="newtons-cradle__dot"></div>
            </div>
          </div>
        ) : error ? (
          <p className='error'>{error}</p>
        ) : (
   kycdetails && (
      <div className="mt-3 m-2 p-2 rounded-md flex justify-center items-start flex-col border border-orange-300" key={_id}>
        <div className="m-4 p-1">
                <img src={kycdetails.photo} alt="User Photo" className="w-32 h-32 object-cover rounded-full mx-auto" />
                <p className='text-center'>{kycdetails.firstName.charAt(0).toUpperCase() + kycdetails.firstName.slice(1)} {kycdetails.lastName}</p>

              </div>
              <div className="flex flex-col items-start p-3 m-3 w-full">
              <div className="mb-2 p-1">
                <p className="font-bold p-2">Full Name:</p>
                <p className='p-2'>{kycdetails.firstName.charAt(0).toUpperCase() + kycdetails.firstName.slice(1)} {kycdetails.lastName}</p>
              </div>
              <div className="mb-2 p-1">
                <p className="font-bold p-2">Gender:</p>
                <p className='p-2'>{kycdetails.gender}</p>
              </div>
              <div className="mb-2 p-1">
                <p className="font-bold p-2">Citizenship Number:</p>
                <p className='p-2'>{kycdetails.citizenshipNumber}</p>
              </div>
              <div className="mb-4 p-1">
                <p className="font-bold p-2">Citizenship Front Photo:</p>
                <img src={kycdetails.citizenshipFrontPhoto} alt="Citizenship Front Photo" className="w-32 h-32 object-cover mx-auto" />
              </div>
              <div className="mb-4 p-1">
                <p className="font-bold p-2">Citizenship Back Photo:</p>
                <img src={kycdetails.citizenshipBackPhoto} alt="Citizenship Back Photo" className="w-32 h-32 object-cover mx-auto" />
              </div>
              <div className="mb-2 p-1">
                <p className="font-bold p-2">KYC Verified:</p>
                <p className='p-2'>{kycdetails.isKYCVerified ? 'Yes' : 'No'}</p>
              </div>
              </div>
      </div>
   )
   )
}
         </div>
      </Navigationwrap>
      </>
   );
}

export default KycDetails;
