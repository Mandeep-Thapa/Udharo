import React from 'react';
import KhaltiCheckout from "khalti-checkout-web";
import Navigationwrap from '@/components/Navigationwrap';
import config from './khaltiConfig';

interface KhaltiPaymentProps {
  amount: number;
  onSuccess: (payload: any) => void;
}
const KhaltiPayment: React.FC<KhaltiPaymentProps> = ({ amount }) => {

  const Checkout = new KhaltiCheckout(config);

  const initiatePayment = () => {
    Checkout.show({ amount: amount * 100});
  };
  return (
    <Navigationwrap>
       <div className="mt-[76px] xs:ml-0 sm:ml-[260px] p-3 flex flex-col">
        <div className="">
          <button onClick={initiatePayment} className='bg-custom-sudesh_blue rounded-md p-2 text-white transition duration-500'>
            Pay with Khalti
          </button>
        </div>
      </div>
     
    </Navigationwrap>
  );
};

export default KhaltiPayment;