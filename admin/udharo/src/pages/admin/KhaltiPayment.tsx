import React, { useState } from 'react';
import KhaltiCheckout from "khalti-checkout-web";
import Navigationwrap from '@/components/Navigationwrap';
import AdminPaymentRequests from '../../components/AdminPaymentRequests';
import axios from 'axios';


interface KhaltiPaymentProps {
  amount: number;
  onSuccess: (payload: any) => void;
}
const authToken = localStorage.getItem('token');
console.log(authToken)
const KhaltiPayment: React.FC<KhaltiPaymentProps> = ({ amount, onSuccess }) => {
  const [paymentSuccess, setPaymentSuccess] = useState(false);
  const config = {
    publicKey: "test_public_key_cd5611efda9846fd926b3e19015d1641",
    productIdentity: 1234567890,
    productName: "Dragon",
    productUrl: "http://gameofthrones.wikia.com/wiki/Dragons",
    eventHandler: {
      onSuccess(payload: any) {
        const { idx, amount , token } = payload;

        axios.post(`http://localhost:3004/api/user/khaltiPaymentVerification`, {
          idx,
          amount,
          token,
        },{
          headers: {
            Authorization: `Bearer ${authToken}`,
          },
        }
      ).then(() => {
          setPaymentSuccess(true);
          onSuccess(payload); // On successful verification, trigger success handler
        }).catch(error => {
          console.error('Payment failed:', error);
        });
      },
      onError(error: any) {
        console.log(error);
      },
      onClose() {
        console.log("widget is closing");
      },
    },
    paymentPreference: ["KHALTI", "EBANKING", "MOBILE_BANKING", "CONNECT_IPS", "SCT"],
  };

  const khaltiCheckout = new KhaltiCheckout(config);

  const initiatePayment = () => {
    khaltiCheckout.show({ amount: amount * 10 });
  };
  return (
    <Navigationwrap>
       <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
        <AdminPaymentRequests />
        <div className="">
          <button onClick={initiatePayment} className='bg-custom-sudesh_blue rounded-md p-2 text-white transition duration-500'>
            Pay with Khalti
          </button>
        </div>
      </div>
      {paymentSuccess && (
        <div className="fixed inset-0 flex items-center justify-center z-50">
          <div className="bg-green-500 text-white px-6 py-3 rounded-md shadow-lg">
            Payment Successful!
          </div>
        </div>
      )}
    </Navigationwrap>
  );
};

export default KhaltiPayment;
