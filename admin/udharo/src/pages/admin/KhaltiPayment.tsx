import React from 'react';
import KhaltiCheckout from "khalti-checkout-web";
import Navigationwrap from '@/components/Navigationwrap';
import AdminPaymentRequests from '../../components/AdminPaymentRequests';
interface KhaltiPaymentProps {
  amount: number;
  purchaseOrderId: string;
  purchaseOrderName: string;
  onSuccess: (payload: any) => void;
}

const KhaltiPayment: React.FC<KhaltiPaymentProps> = ({ amount, purchaseOrderId, purchaseOrderName, onSuccess }) => {
  const config = {
    publicKey: "test_public_key_cd5611efda9846fd926b3e19015d1641",
    productIdentity: purchaseOrderId,
    productName: purchaseOrderName,
    productUrl: "http://example.com/product",
    eventHandler: {
      onSuccess(payload: any) {
        onSuccess(payload);
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
  // const initiatePayment = () => {
  //   // Capture payment request and send to backend
  //   fetch('/api/payment/request', {
  //     method: 'POST',
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: JSON.stringify({
  //       amount: amount * 100,
  //       purchaseOrderId,
  //       purchaseOrderName,
  //     }),
  //   }).then(response => {
  //     // Handle response
  //     if (response.ok) {
  //       console.log('Payment request sent to admin for approval');
  //     } else {
  //       console.error('Failed to send payment request');
  //     }
  //   });
  // };
  return (
    <Navigationwrap>
      <div className=" mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col ">
        <AdminPaymentRequests />
        <div className="">
    <button onClick={initiatePayment} className='bg-custom-sudesh_blue rounded-md p-2 text-white transition duration-500'>Pay with Khalti</button>
    </div>
    </div>
    </Navigationwrap>
  );
};

export default KhaltiPayment;
