import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';

class AuthRepository {
  // sign in
  Future<String> signIn(String email, String password) async {
    String url = '${Config.baseUrl}/user/login';

    Dio dio = Dio();
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

      if (response.statusCode == 200) {
        final token = response.data['token'];

        // save token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        return 'Login Success';
      } else {
        // handle error response
        if (response.data['error'] != null) {
          return response.data['error'];
        } else {
          // generic error message
          return 'Login Unsuccessful';
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['error'] != null) {
          return e.response!.data['error'];
        }
      }
      // generic error message
      return 'Login Unsuccessful';
    } catch (e) {
      // handle other exceptions
      return 'Login Unsuccessful';
    }
  }

  // sign up
  Future<String> signUp(
    String fullName,
    String email,
    String password,
  ) async {
    String url = '${Config.baseUrl}/user/register';

    Dio dio = Dio();
    final data = {
      "fullName": fullName,
      "email": email,
      "password": password,
    };

    print('sending url: $url with data: $data');

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

      print('response: ${response.data}');

      if (response.statusCode == 201) {
        return 'SignUp Success';
      } else {
        // handle error response
        if (response.data['error'] != null) {
          return response.data['error'];
        } else {
          // generic error message
          return 'SignUp Unsuccessful';
        }
      }
    } on DioException catch (e) {
      // handle DioException
      if (e.response != null && e.response!.data != null) {
        // handle specific error message from the server
        if (e.response!.data['message'] != null) {
          return e.response!.data['message'];
        }
      }
      // generic error message
      return 'SignUp Unsuccessful';
    } catch (e) {
      // handle other exceptions
      return 'SignUp Unsuccessful';
    }
  }
}
