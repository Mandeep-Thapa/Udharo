import Navigationwrap from '@/components/Navigationwrap';
import axios from 'axios';
import React, { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom';
import { toast } from 'sonner';


interface Transaction {
   _id: string;
   total_amount: number;
   status: string;
   transaction_id: string | null;
   fee: number;
   refunded: boolean;
   paid_at: string;
   paidByName: string;
}

interface ApiResponse {
   status: string;
   message: Transaction[];
}

const TransactionDetails: React.FC = () => {
   const { _id } = useParams<{ _id: string }>();
   const [transactions, setTransactions] = useState<Transaction[]>([]);
   const [loading, setLoading] = useState<boolean>(true);
   const [error, setError] = useState<string | null>(null);

   useEffect(() => {
       const fetchTransactionDetails = async () => {
           try {
            const token = localStorage.getItem("token");
            if (!token) {
              throw new Error("Authentication token not found");
            }
               const response = await axios.get<ApiResponse>(`http://localhost:3004/api/admin/transactionDetails/${_id}`,{
               headers: {
                     Authorization: `Bearer ${token}`,
                  },
               },

               );
               const data = response.data;

               if (data.status === 'Success') {
                   setTransactions(data.message);
               } else {
                   toast.error('No transaction details found.');
               }
        setLoading(false);

           } catch (error) {
               toast.error('Error fetching transaction details.');
           }
       };

       fetchTransactionDetails();
   }, [_id]);
  return (
   <Navigationwrap>
   <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
       <h1 className="text-2xl font-bold mb-4">Transaction Details</h1>

       {loading ? (
           <div className="flex justify-center mt-10 h-screen">
               <div className="w-16 h-16 border-4 border-yellow-500 border-dotted rounded-full animate-spin"></div>
           </div>
       ) : (
           <>
               {error && <p className="text-red-500">{error}</p>}
               <div className="space-y-4">
                   {transactions.map(transaction => (
                       <div key={transaction._id} className="p-4 border rounded shadow-md bg-white hover:bg-gray-50 transition duration-300 ease-in-out">
                       <div className="grid grid-cols-2 gap-y-2">
                           <p className="font-semibold">Total Amount:</p>
                           <p>${transaction.total_amount}</p>

                           <p className="font-semibold">Status:</p>
                           <p>{transaction.status}</p>

                           <p className="font-semibold">Transaction ID:</p>
                           <p>{transaction.transaction_id !== "null" ? transaction.transaction_id : "N/A"}</p>

                           <p className="font-semibold">Fee:</p>
                           <p>${transaction.fee}</p>

                           <p className="font-semibold">Refunded:</p>
                           <p>{transaction.refunded ? "Yes" : "No"}</p>

                           <p className="font-semibold">Paid At:</p>
                           <p>{new Date(transaction.paid_at).toLocaleString()}</p>

                           <p className="font-semibold">Paid By:</p>
                           <p>{transaction.paidByName}</p>
                       </div>
                   </div>
                   ))}
               </div>
           </>
       )}
   </div>
</Navigationwrap>
  )
}

export default TransactionDetails
