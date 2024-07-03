import React, { useEffect, useState } from 'react';
import axios from 'axios';
import Navigationwrap from '@/components/Navigationwrap';

const ApprovedBorrowRequest = () => {
  const [approvedRequests, setApprovedRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchBorrowRequest = async () => {
      const token = localStorage.getItem('token');
      try {
        const response = await axios.get('http://localhost:3004/api/admin/approvedBorrowRequests',{
         headers: {
            'Authorization': `Bearer ${token}`
          }
        });
        setApprovedRequests(response.data.data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchBorrowRequest();
  }, []);

  if (loading) {
    return <div className="text-center">Loading...</div>;
  }

  if (error) {
    return <div className="text-center text-red-500">Error: {error}</div>;
  }

  return (
   <Navigationwrap>
   <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3">
   <h2 className="text-xl font-bold mb-2">Approved Borrow Requests</h2>
   <div className="grid grid-cols-3">
   {approvedRequests.length === 0 ? (
     <p>No approved borrow requests found.</p>
   ) : (
     approvedRequests.map((request, index) => (
       <div key={index} className="border p-3 rounded-md bg-custom-sudesh_dark_gray w-80 gap-5 text-white ">
         <p><strong>Borrower Name:</strong> {request.borrowerName}</p>
         <p><strong>Amount Requested:</strong> ${request.amountRequested}</p>
         <p><strong>Number of Lenders:</strong> {request.numberOfLenders}</p>
         <h3 className="text-lg font-semibold mt-2">Lenders:</h3>
           {request.lenders.map((lender, id) => (
             <div key={id} className="mt-2">
               <p><strong>Lender Name:</strong> {lender.lenderName}</p>
               <p><strong>Fulfilled Amount:</strong> ${lender.fulfilledAmount}</p>
               <p><strong>Return Amount:</strong> ${lender.returnAmount}</p>
             </div>
           ))}
       </div>
     ))
   )}
   </div>
 </div>
 </Navigationwrap>
  );
};

export default ApprovedBorrowRequest;
