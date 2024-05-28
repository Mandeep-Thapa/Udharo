
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:udharo/config.dart';

// class KhaltiRepository {
//   Future<String> initializeKhaltiPayment({
//     required int amount,
//     required String borrowId,
//     required String borrorwName,
//     required String lenderName,
//     required String lenderEmail,
//     required String lenderPhoneNumber,
//   }) async {
//     String url = '${Config.baseUrl}/user/khaltiPaymentInitialization';

//     Dio dio = Dio();

//     // request body
//     final data = {
//       "return_url": "https://udharo.com/payment/",
//       "website_url": "https://udharo.com/",
//       "amount": amount,
//       "purchase_order_id": borrowId,
//       "purchase_order_name": borrorwName,
//       "customer_info": {
//         "name": lenderName,
//         "email": lenderEmail,
//         "phone": lenderPhoneNumber,
//       },
//       "amount_breakdown": [
//         {
//           "label": "Mark Price",
//           "amount": amount,
//         },
//         {
//           "label": "VAT",
//           "amount": 0,
//         }
//       ],
//       "product_details": [
//         {
//           "identity": borrowId,
//           "name": "$borrorwName to $lenderName",
//           "total_price": amount,
//           "quantity": 1,
//           "unit_price": amount
//         }
//       ],
//       "merchant_username": "Udharo",
//       "merchant_extra": "Udharo Admin"
//     };

// // get token from shared preferences
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     // print('sending request to $url with body: ${jsonEncode(data)}');

//     try {
//       Response response = await dio.post(
//         url,
//         data: data,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {

//         final pidx = response.data['data']['pidx'];

//         // print('response: $pidx');

//         return pidx;
//       } else {
//         // handle error response
//         if (response.data['error'] != null) {
//           return response.data['error'];
//         } else {
//           // generic error message
//           return 'Khalti Initialization Unsuccessful';
//         }
//       }
//     } on DioException catch (e) {
//       // handle DioException
//       if (e.response != null && e.response!.data != null) {
//         // handle specific error message from the server
//         if (e.response!.data['error'] != null) {
//           // print('dio error message: ${e.response!.data}');
//           return e.response!.data['error'];
//         }
//       }
//       // generic error message
//       return 'Khalti Initialization Unsuccessful';
//     } catch (e) {
//       // handle other exceptions
//       return 'Khalti Initialization Unsuccessful: $e';
//     }
//   }
// }
