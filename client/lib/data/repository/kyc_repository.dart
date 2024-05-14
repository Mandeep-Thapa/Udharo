import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:udharo/data/model/view_kyc_model.dart';

class KYCRepository {
  Future<String> uploadKYC({
    required String firstName,
    required String lastName,
    required String gender,
    required String citizenshipNumber,
    String? panNumber,
    required File citizenshipFrontPhoto,
    required File citizenshipBackPhoto,
    required File passportSizePhoto,
  }) async {
    String url = '${Config.baseUrl}/kyc/kycUpload';

    Dio dio = Dio();

    // print(
    //   'received data: $firstName, $lastName, $citizenshipNumber, $panNumber, $citizenshipFrontPhoto, $citizenshipBackPhoto, $passportSizePhoto',
    // );

    // print('type of: ${passportSizePhoto.runtimeType}');

    // final imageFile = await MultipartFile.fromFile(
    //   passportSizePhoto.path,
    //   filename: 'passportSizePhoto.jpg',
    //   contentType: MediaType('image', 'jpeg'),
    // );

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // request body with multipart form data
    FormData data = FormData.fromMap(
      {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'citizenshipNumber': citizenshipNumber,
        if (panNumber != null) 'panNumber': panNumber,
        'photo': await MultipartFile.fromFile(
          passportSizePhoto.path,
          filename: 'photoFileName',
          contentType: MediaType('image', 'png'),
        ),
        'citizenshipFrontPhoto': await MultipartFile.fromFile(
          citizenshipFrontPhoto.path,
          filename: 'citizenshipFrontFileName',
          contentType: MediaType('image', 'png'),
        ),
        'citizenshipBackPhoto': await MultipartFile.fromFile(
          citizenshipBackPhoto.path,
          filename: 'citizenshipBackFileName',
          contentType: MediaType('image', 'png'),
        ),
      },
    );

// api call
    // print('sending request to $url with body: ${data.fields}');

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // print('response status code: ${response.statusCode}');
      if (response.statusCode == 201) {
        // success response
        // print('response: ${response.data}');

        return 'success';
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error uploading KYC');
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
      throw Exception('Error uploading KYC');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error uploading KYC');
    }
  }

  // view KYC history
  Future<ViewKycModel> fetchKYC() async {
    String url = '${Config.baseUrl}/kyc/viewKyc';

    Dio dio = Dio();

    // get token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // api call
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
        // print('response: ${response.data}');
        return ViewKycModel.fromJson(response.data);
      } else {
        // handle error response
        if (response.data['message'] != null) {
          // print('error message: ${response.data['message']}');
          throw Exception(response.data['message']);
        } else {
          // generic error message
          // print('error innit');
          throw Exception('Error fetching KYC');
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
      throw Exception('Error fetching KYC');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('dio error: $e');
      throw Exception('Error fetching KYC: $e');
    }
  }
}
