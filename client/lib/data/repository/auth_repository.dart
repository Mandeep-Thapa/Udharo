import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository({Dio? dio}) : dio = dio ?? Dio();

  static const String tokenKey = 'token';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tokenKey);
  }

  Future<String> signIn(String email, String password) async {
  String url = '${Config.baseUrl}/user/login';

  final data = {
    "email": email,
    "password": password,
  };

  try {
    Response response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // print('Response Status Code: ${response.statusCode}');
    // print('Response Data: ${response.data}');

    if (response.statusCode == 200 && response.data['token'] != null) {
      final token = response.data['token'];
      // print('Token: $token');
      await saveToken(token);
      return 'Login Success';
    } else {
      if (response.data['message'] != null) {
        return response.data['message'];
      } else {
        return 'Login Unsuccessful';
      }
    }
  } on DioException catch (e) {
    if (e.response != null && e.response!.data != null) {
      if (e.response!.data['message'] != null) {
        return e.response!.data['message'];
      }
    }
    return 'Login Unsuccessful';
  } catch (e) {
    return 'Login Unsuccessful';
  }
}


  Future<String> signUp({
    required String fullName,
    required String email,
    required String occupation,
    required String password,
    required int phoneNumber,
  }) async {
    String url = '${Config.baseUrl}/user/register';

    final data = {
      "fullName": fullName,
      "email": email,
      "password": password,
      "occupation": occupation,
      "phoneNumber": phoneNumber,
    };

    // print('sending data: $data to $url');

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return 'SignUp Success';
      } else {
        if (response.data['message'] != null) {
          return response.data['message'];
        } else {
          return 'SignUp Unsuccessful';
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data['message'] != null) {
          return e.response!.data['message'];
        }
      }
      return 'SignUp Unsuccessful';
    } catch (e) {
      return 'SignUp Unsuccessful';
    }
  }

  Future<String> sendEmailVerification(String email) async {
    String url = '${Config.baseUrl}/user/send-verification-email';

    final data = {
      "email": email,
    };

    try {
      Response response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return 'Verification Sent Successfully';
      } else {
        if (response.data['error'] != null) {
          return response.data['error'];
        } else {
          return 'Could not send verification';
        }
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data['error'] != null) {
          return e.response!.data['error'];
        }
      }
      return 'Could not send verification';
    } catch (e) {
      return 'Could not send verification';
    }
  }
}
