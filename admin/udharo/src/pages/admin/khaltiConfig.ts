import axios from 'axios';
import myKey from '../../../config';
const config = {
   "publicKey": "test_public_key_cd5611efda9846fd926b3e19015d1641",
   "productIdentity": "1234567890",
   "productName": "Drogon",
   "productUrl": "http://localhost:3004",
   "eventHandler": {
       onSuccess (payload: any) {
           // hit merchant api for initiating verfication
           console.log(payload);
           let purpose = "";
           if (payload.isLenderPayment) {
             purpose = "Returned money from admin"; 
           } else {
             purpose = "Sent Money to borrower from admin";
           }
          const paymentData = {
            idx: payload.token,
            amount: payload.amount,
            fee_amount: 0,
            created_on: new Date().toISOString(),
            senderName: "Sender Name",
            receiverName: "Receiver Name",
            purpose: purpose,
          };
          axios.post("http://localhost:3004/api/user/saveKhaltiPaymentDetails", paymentData).then(response => {
            console.log(response.data); 
            alert('Payment Successful');
          })
          .catch(error => {
            console.error('Error while saving payment details:', error);
          });

interface VerifyData {
  token: string;
  amount: number;
}

const data: VerifyData = {
  token: payload.token,
  amount: payload.amount,
};

const config = {
  headers: { 'Authorization': `Key ${myKey.KHALTI_TEST_SECRET_KEY}` }
};

axios.post<{ data: any }>("https://khalti.com/api/v2/payment/verify/", data, config)
  .then(response => {
    alert('Payment Successful');
  })
  .catch((error: any) => {
    console.log(error);
  });

       },
       onError (error) {
           console.log(error);
       },
       onClose () {
           console.log('widget is closing');
       }
   },
   "paymentPreference": ["KHALTI", "EBANKING","MOBILE_BANKING", "CONNECT_IPS", "SCT"],
};

 export default config;