import React, { useEffect, useState } from "react";
import axios from "axios";
import { useParams } from "react-router-dom";

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
  const { userId } = useParams();
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>("");
const token = localStorage.getItem("token");
  useEffect(() => {
    const fetchTransactionDetails = async () => {
      try {
        const response = await axios.get(
          `http://localhost:3004/api/admin/transactionDetails/${userId}`,
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
            setError(`No transactions found for user with id ${userId}`);
          } else {
            setError("Error fetching transaction details");
          }
        }
        setLoading(false);
      }
    };

    fetchTransactionDetails();
  }, [userId, token]);

  return (
    <div>
      <h1>Transaction Details for User {userId}</h1>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <>
          {error ? (
            <p>{error}</p>
          ) : (
            transactions.length > 0 ? (
              transactions.map((transaction) => (
                <div key={transaction._id} className="border p-2 m-2 rounded">
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
              <p>No transactions found.</p>
            )
          )}
        </>
      )}
    </div>
  );
};

export default TransactionDetails;
