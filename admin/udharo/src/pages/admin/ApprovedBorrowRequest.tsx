import { useEffect, useState } from 'react';
import axios, { AxiosError } from 'axios';
import Navigationwrap from '@/components/Navigationwrap';
import { ApprovedRequest } from '@/types';
const ApprovedBorrowRequest = () => {
  const [approvedRequests, setApprovedRequests] = useState<ApprovedRequest[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;
  useEffect(() => {
    const fetchBorrowRequest = async () => {
      const token = localStorage.getItem('token');
      try {
        const response = await axios.get(`${API_BASE_URL}/approvedBorrowRequests`,{
         headers: {
            'Authorization': `Bearer ${token}`
          }
        });
        setApprovedRequests(response.data.data);
      } catch (err) {
        if (axios.isAxiosError(err)) {
          const axiosError = err as AxiosError;
          setError(axiosError.message);
        } else {
          setError('An unexpected error occurred');
        }
      } finally {
        setLoading(false);
      }
    };

    fetchBorrowRequest();
  }, [API_BASE_URL]);


  return (
   <Navigationwrap>
   <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3">
   <h2 className="font-bold text-3xl mx-3 mb-5">Approved Borrow Requests</h2>
   {loading ? (
          <div className="flex justify-center mt-10 h-screen">
          <div className="w-16 h-16 border-4 border-custom-sudesh_blue border-dotted rounded-full animate-spin"></div>
        </div>
        ) : error ? (
          <div className="text-center text-red-500">Error fetching approved borrow request {error}</div>
        ) : (
   <div className="grid grid-cols-3">
   {approvedRequests.length === 0 ? (
     <p>No approved borrow requests found.</p>
   ) : (
    <div className="">
    <table className="min-w-full bg-white border border-gray-200">
      <thead className="bg-custom-sudesh_blue text-white">
        <tr>
          <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Borrower Name</th>
          <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Amount Requested</th>
          <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Number of Lenders</th>
          <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Lenders</th>
        </tr>
      </thead>
      <tbody className="divide-y divide-gray-200">
        {approvedRequests.length === 0 ? (
          <tr>
            <td colSpan={4} className="px-6 py-4 text-center">No approved borrow requests found.</td>
          </tr>
        ) : (
          approvedRequests.map((request, index) => (
            <tr key={index} className="cursor-pointer hover:bg-gray-50">
              <td className="px-6 py-4 whitespace-nowrap uppercase">{request.borrowerName}</td>
              <td className="px-6 py-4 whitespace-nowrap uppercase">${request.amountRequested}</td>
              <td className="px-6 py-4 whitespace-nowrap">{request.numberOfLenders}</td>
              <td className="px-6 py-4 whitespace-nowrap">
                {request.lenders.map((lender, id) => (
                  <div key={id} className="mt-2">
                    <p><strong>Lender Name:</strong> {lender.lenderName}</p>
                    <p><strong>Fulfilled Amount:</strong> ${lender.fulfilledAmount}</p>
                    <p><strong>Return Amount:</strong> ${lender.returnAmount}</p>
                  </div>
                ))}
              </td>
            </tr>
          ))
        )}
      </tbody>
    </table>
  </div>
)}
</div>
        )}
    </div>
</Navigationwrap>
  );
};

export default ApprovedBorrowRequest;
