import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:udharo/data/model/borrow_history_model.dart';
import 'package:udharo/data/model/browse_borrow_model.dart';

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

  // accept borrow history
  Future<void> acceptBorrowRequest(
    String borrowId,
  ) async {
    String url = '${Config.baseUrl}/borrow/approveBorrowRequest/$borrowId';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // api call
    // print('sending request to $url with body: $data');
    try {
      Response response = await dio.put(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // success response
        // print('response: ${response.data}');
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
}
