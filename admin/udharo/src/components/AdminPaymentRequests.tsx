import React, { useEffect, useState } from 'react';

const AdminPaymentRequests: React.FC = () => {
  const [paymentRequests, setPaymentRequests] = useState([]);

  useEffect(() => {
    fetch('/api/payment/requests')
      .then(response => response.json())
      .then(data => setPaymentRequests(data))
      .catch(error => console.error('Error fetching payment requests:', error));
  }, []);

  const approvePayment = (id: string) => {
    fetch(`/api/payment/approve/${id}`, { method: 'POST' })
      .then(response => {
        if (response.ok) {
          setPaymentRequests(prev => prev.filter(request => request._id !== id));
        } else {
          console.error('Failed to approve payment');
        }
      });
  };

  return (
    <div>
      <h1>Payment Requests</h1>
      <ul>
        {paymentRequests.map(request => (
          <li key={request._id}>
            {request.purchaseOrderName} - {request.amount}
            <button onClick={() => approvePayment(request._id)}>Approve</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default AdminPaymentRequests;
