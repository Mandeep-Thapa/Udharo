import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';

class AuthRepository {
  // constants for token expiration
  static const String _tokenKey = 'token';
  static const String _expiryKey = 'expiry';

  // method to save the token along with its expiration time
  Future<void> saveToken(String token, int expiresIn) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final expiryTime = currentTime + (expiresIn * 1000);
    prefs.setString(_tokenKey, token);
    prefs.setInt(_expiryKey, expiryTime);
  }

  // method to check if the token is expired
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_expiryKey);
    if (expiryTime != null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      return currentTime > expiryTime;
    }
    // assume token is expired if expiry time is not found
    return true;
  }

  // method to clear the token and log out the user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
    prefs.remove(_expiryKey);
  }

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
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('token', token);
        await saveToken(token, 1);

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
