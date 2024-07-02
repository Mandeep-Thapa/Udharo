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
    <div className="w-full mx-auto p-6 bg-yellow-50 rounded-lg shadow-lg">
    <h1 className="text-2xl font-bold text-yellow-800 text-center mb-6">Transaction Details</h1>
    {loading ? (
               <div className="flex justify-center mt-10 h-screen">
                 <div className="w-16 h-16 border-4 border-yellow-500 border-dotted rounded-full animate-spin"></div>
               </div>
             ) : (
      <>
        {error ? (
          <p className="text-center text-red-600">{error}</p>
        ) : (
          transactions.length > 0 ? (
            transactions.map((transaction) => (
              <div key={transaction._id} className="border border-yellow-300 p-4 m-2 rounded-lg bg-yellow-100 hover:bg-yellow-200 transition duration-300 ">
                <p><strong>Transaction ID:</strong> {transaction._id}</p>
                <p><strong>Total Amount:</strong> {transaction.total_amount}</p>
                <p><strong>Status:</strong> {transaction.status}</p>
                <p><strong>Transaction ID:</strong> {transaction.transaction_id}</p>
                <p><strong>Fee:</strong> {transaction.fee}</p>
                <p><strong>Refunded:</strong> {transaction.refunded ? "Yes" : "No"}</p>
                <p><strong>Paid At:</strong> {new Date(transaction.paid_at).toLocaleString()}</p>
                <p><strong>Paid By:</strong> {transaction.paidByName}</p>
              </div>
            ))
          ) : (
            <p className="text-center text-yellow-700">No transactions found.</p>
          )
        )}
      </>
    )}
  </div>
  </div>
  </Navigationwrap>
  );
};

export default TransactionDetails;
