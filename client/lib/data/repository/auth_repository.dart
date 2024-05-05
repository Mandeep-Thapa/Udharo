import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';

class AuthRepository {
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
        // login successful
        final token = response.data['token'];
        print('login successful: $token');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        return 'Login Success';
      } else if (response.data['error'] != null) {
        return response.data['error'];
      } else {
        return 'Login Unsuccessful';
      }
      // print('Response: ${response.data}');
    } on Exception catch (e) {
      // handle exception
      return e.toString();
    }
  }
}
