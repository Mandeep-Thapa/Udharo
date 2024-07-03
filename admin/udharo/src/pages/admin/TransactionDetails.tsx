import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";
import Navigationwrap from "@/components/Navigationwrap";

interface Transaction {
  _id: string;
  total_amount: number;
  status: string;
  transaction_id: string;
  fee: number;
  refunded: boolean;
  paid_at: string;
  paidByName: string;
}

const TransactionDetails = () => {
  const { _id } = useParams<{_id: string}>();
  console.log(_id)
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>("");
const token = localStorage.getItem("token");
  useEffect(() => {
    const fetchTransactionDetails = async () => {
      try {
        const response = await axios.get(
          `http://localhost:3004/api/admin/transactionDetails/${_id}`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        if (
          response.data &&
          response.data.message &&
          Array.isArray(response.data.message) &&
          response.data.message.length > 0
        ) {
          console.log(response.data.message)
          setTransactions(response.data.message);
        } else {
          setTransactions([]);
        }
        setLoading(false);
      } catch (error) {
        if (axios.isAxiosError(error)) {
          if (error.response?.status === 404) {
            setError(`No transactions found for user with id ${_id}`);
          } else {
            setError("Error fetching transaction details");
          }
        }
        setLoading(false);
      }
    };

    fetchTransactionDetails();
  }, [_id, token]);

  return (
    <Navigationwrap>
      <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
    <h1 className="font-bold text-3xl mx-3 mb-2">Transaction Details</h1>
    {loading ? (
               <div className="flex justify-center mt-10 h-screen">
                 <div className="w-16 h-16 border-4 border-custom-sudesh_blue border-dotted rounded-full animate-spin"></div>
               </div>
             ) : (
      <>
        {error ? (
          <p className="text-center text-red-600">{error}</p>
        ) : (
          transactions.length > 0 ? (
            transactions.map((transaction) => (
              <div key={transaction._id} className="p-4 m-2 rounded-lg bg-custom-sudesh_blue transition duration-300">
              <div className="overflow-x-auto">
                <table className="min-w-full bg-white border border-gray-200">
                  <tbody className="divide-y divide-gray-200 ">
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Transaction ID:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{transaction._id}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Total Amount:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">${transaction.total_amount}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Status:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{transaction.status}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Transaction ID:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{transaction.transaction_id}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Fee:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">${transaction.fee}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Refunded:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{transaction.refunded ? 'Yes' : 'No'}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Paid At:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{new Date(transaction.paid_at).toLocaleString()}</td>
                    </tr>
                    <tr>
                      <td className="px-6 py-4 whitespace-nowrap"><strong>Paid By:</strong></td>
                      <td className="px-6 py-4 whitespace-nowrap">{transaction.paidByName}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            ))
          ) : (
            <p className="text-center text-yellow-700">No transactions found.</p>
          )
        )}
      </>
    )}
  </div>
  </Navigationwrap>
  );
};

export default TransactionDetails;
