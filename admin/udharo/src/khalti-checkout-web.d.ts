declare module 'khalti-checkout-web' {
   interface Config {
     publicKey: string;
     productIdentity: string;
     productName: string;
     productUrl: string;
     eventHandler: {
       onSuccess: (payload: any) => void;
       onError: (error: any) => void;
       onClose: () => void;
     };
     paymentPreference: string[];
   }
 
   class KhaltiCheckout {
     constructor(config: Config);
     show(options: { amount: number }): void;
   }
 
   export default KhaltiCheckout;
 }
 