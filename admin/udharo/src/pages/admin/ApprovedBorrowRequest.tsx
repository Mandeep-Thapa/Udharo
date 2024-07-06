import { useEffect, useState } from 'react';
import axios, { AxiosError } from 'axios';
import Navigationwrap from '@/components/Navigationwrap';
import { ApprovedRequest } from '@/types';
import KhaltiPayment from './KhaltiPayment';
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
        console.log(response.data.data)
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
  const handlePaymentSuccess = (payload: any) => {
    console.log('Payment successful:', payload);
    <div className="">Payment Succesfull</div>
    // Add logic to update the status of the request in your database
  };

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
          <div className="grid grid-cols-1 gap-4">
            {approvedRequests.length === 0 ? (
              <p>No approved borrow requests found.</p>
            ) : (
              <div className="overflow-x-auto">
                <table className="min-w-full bg-white border border-gray-200">
                  <thead className="bg-custom-sudesh_blue text-white">
                    <tr>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Borrower Name</th>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Amount Requested</th>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Borrow Request Status</th>
                      
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Number of Lenders</th>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Lenders</th>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Amount Remaining</th>
                      <th className="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider">Pay to Lenders</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {approvedRequests.map((request, index) => (
                      <tr key={index} className="cursor-pointer hover:bg-gray-50">
                        <td className="px-6 py-4 whitespace-nowrap uppercase flex flex-col">{request.borrowerName}
                        <span className="px-6 py-4 whitespace-nowrap  flex justify-start">
                          {request.borrowRequestStatus === "approved" && (
                            <KhaltiPayment amount={request.amountRequested} onSuccess={handlePaymentSuccess} />
                          )}
                        </span>

                        </td>
                        <td className="px-6 py-4 whitespace-nowrap uppercase">Rs{request.amountRequested}</td>
                        <td className="px-6 py-4 whitespace-nowrap">{request.borrowRequestStatus}</td>
                        <td className="px-6 py-4 whitespace-nowrap">{request.numberOfLenders}</td>
 
                        <td className="px-6 py-4 whitespace-nowrap">
                          {request.lenders.map((lender, id) => (
                            <div key={id} className="mt-2">
                              <p><strong>Lender Name:</strong> {lender.lenderName}</p>
                              <p><strong>Fulfilled Amount:</strong> Rs{lender.fulfilledAmount}</p>
                              <p><strong>Return Amount:</strong> Rs{lender.returnAmount}</p>
                             
                            </div>
                          ))}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap">${request.amountRequested - request.lenders.reduce((sum, lender) => sum + lender.fulfilledAmount, 0)}</td>
                        
                        <td>
                       {
                        request.lenders.map((lender, id) => (
                            <div key={id} className="mt-2">
                              <p><strong>Return Amount:</strong> ${lender.returnAmount}</p>
                              <KhaltiPayment amount={lender.returnAmount} onSuccess={handlePaymentSuccess} />
                            </div>
                          ))
                       }
                        </td>
                      </tr>
                    ))}
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
