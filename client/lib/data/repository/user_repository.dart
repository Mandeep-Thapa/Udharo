import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:udharo/data/model/user_profile_model.dart';

class UserRepository {
  Future<UserProfileModel> fetchUserProfile() async {
    String url = '${Config.baseUrl}/user/profile';

    Dio dio = Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // print('sending request to: $url with token: $token');

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            throw Exception(
              'Unauthorized: Please login again',
            );
          }
          return handler.next(error);
        },
      ),
    );

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
      return userProfileModelFromJson(response.toString());
    } on DioException catch (e) {
      // handle DioException
      // print('DioException: $e');
      throw Exception('Something went wrong: $e');
      // generic error message
    } catch (e) {
      // handle other exceptions
      // print('Exception: $e');
      throw Exception('Something went wrong: $e');
    }
  }
}
