import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:udharo/data/model/borrow_history_model.dart';
import 'package:udharo/data/model/browse_borrow_model.dart';
import 'package:udharo/data/model/khalti_verification_success_model.dart';

class BorrowRepository {
  // create borrow request
  Future<void> createBorrowRequest({
    required int amount,
    required String purpose,
    required double interestRate,
    required int paybackPeriod,
  }) async {
    String url = '${Config.baseUrl}/borrow/createBorrowRequest';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // request body
    final data = {
      "amount": amount,
      "purpose": purpose,
      "interestRate": interestRate,
      "paybackPeriod": paybackPeriod,
    };

    // api call
    // print('sending request to $url with body: $data');
    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
        // success response
        // print('response: ${response.data}');
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error creating borrow request');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          // print('dio error message: ${e.response!.data['message']}');
          throw Exception(e.response!.data['message']);
        }
      }
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error creating borrow request');
    }
  }

  // browse borrow requests
  Future<BrowseBorrowRequestModel> fetchBorrowRequest() async {
    String url = '${Config.baseUrl}/borrow/browseBorrowRequests';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // api call
    // print('sending request to $url');
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print('response: ${response.data}');

      if (response.statusCode == 200) {
        // success response
        // print('success response: ${response.data}');

        return BrowseBorrowRequestModel.fromJson(response.data);
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error fetching borrow request');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          // print('dio error message: ${e.response!.data['message']}');
          throw Exception(e.response!.data['message']);
        }
      }
      throw Exception('Error fetching borrow request');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error fetching borrow request');
    }
  }

  // browse borrow history
  Future<List<BorrowHistoryModel>> fetchBorrowHistory() async {
    String url = '${Config.baseUrl}/borrow/borrowRequestHistory';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // api call
    // print('sending request to $url with body: $data');
    try {
      Response response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // success response

        return borrowHistoryModelFromJson(jsonEncode(response.data));
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error fetching borrow history');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          // print('dio error message: ${e.response!.data['message']}');
          throw Exception(e.response!.data['message']);
        }
      }
      throw Exception('Error fetching borrow history');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error fetching borrow history');
    }
  }

  // accept borrow request
  Future<void> acceptBorrowRequest(
    String borrowId,
    int amount,
  ) async {
    String url = '${Config.baseUrl}/borrow/approveBorrowRequest/$borrowId';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final data = {
      "amountToBeFulfilled": amount,
    };

    // api call
    // print('sending request to $url');
    try {
      Response response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print('response: ${response.data}');

      if (response.statusCode == 200) {
        // success response
        // print('success response: ${response.data}');
        return;
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error accepting borrow request');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          // print('dio error message: ${e.response!.data['message']}');
          throw Exception(e.response!.data['message']);
        }
      }
      throw Exception('Error accepting borrow request');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error accepting borrow request');
    }
  }

  // verify khalti transaction
  Future<KhaltiVerificationSuccessModel> verifyKhaltiTransaction({
    required String token,
    required int amount,
  }) async {
    String url = '${Config.baseUrl}/user/khaltiPaymentVerification';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bearerToken = prefs.getString('token');

    // request body
    final data = {
      "token": token,
      "amount": amount,
    };
// api call
    // print('sending request to $url with body: $data');
    try {
      Response response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      // print('response: ${response.data}');

      if (response.statusCode == 200) {
        // success response
        // print('success response: ${response.data}');
        return khaltiVerificationSuccessModelFromJson(response.toString());
      } else {
        // handle error response
        if (response.data['error'] != null) {
          // print('error message: ${response.data['error']}');
          throw Exception(response.data['error']);
        } else {
          // generic error message
          throw Exception('Error verifying khalti transaction');
        }
      }
    } on DioException catch (e) {
      // print('dio error: $e');
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['error'] != null) {
          // print('dio error message: ${e.response!.data['error']}');
          throw Exception(e.response!.data['error']);
        }
      }
      // generic error message
      throw Exception('Error verifying khalti transaction');
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error verifying khalti transaction: $e');
    }
  }

  // save khalti transaction
  Future<void> saveKhaltiTransaction({
    required String idx,
    required int amount,
    required String createdOn,
    required String sendername,
    required String receiverName,
    required int feeAmount,
    required String purpose,
  }) async {
    String url = '${Config.baseUrl}/user/saveKhaltiPaymentDetails';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // request body
    final data = {
      "idx": idx,
      "amount": amount,
      "created_on": createdOn,
      "senderName": sendername,
      "receiverName ": receiverName,
      "fee_amount": feeAmount,
      "purpose": purpose,
    };

    // api call
    // print('sending request to $url with body: $data');
    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print(' response: ${response.data}');

      if (response.statusCode == 200) {
        // success response
        // print('success response: ${response.data}');

        return;
      } else {
        // handle error response
        if (response.data['error'] != null) {
          // print('error message: ${response.data['error']}');
          throw Exception(response.data['error']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error saving khalti transaction');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['error'] != null) {
          // print('dio error message: ${e.response!.data['error']}');
          throw Exception(e.response!.data['error']);
        }
      }
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error saving khalti transaction: $e');
    }
  }

  // return money
  Future<void> returnMoney(
    String borrowId,
    int amount,
  ) async {
    String url = '${Config.baseUrl}/borrow/returnMoney/$borrowId';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final data = {
      "amountReturned": amount,
    };

    // api call
    // print('sending request to $url');
    try {
      Response response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print('response: ${response.data}');

      if (response.statusCode == 200) {
        // success response
        // print('success response: ${response.data}');
        return;
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error returning money');
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          // print('dio error message: ${e.response!.data['message']}');
          throw Exception(e.response!.data['message']);
        }
      }
      throw Exception('Error returning money');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error returning money: $e');
    }
  }
}
