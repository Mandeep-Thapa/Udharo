import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:udharo/config.dart';
import 'package:udharo/data/repository/auth_repository.dart';
import 'package:mockito/mockito.dart';

// generate mocks for Dio, AuthRepository and SharedPreferences
@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthRepository>(), MockSpec<SharedPreferences>()])
import 'auth_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize mock objects
  final mockDio = MockDio();
  final authRepository = AuthRepository(dio: mockDio);

  // Set up mock SharedPreferences for consistency
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthRepository - Dio Tests', () {
    // test for signIn function
    test('signIn calls Dio with correct URL and data', () async {
      const email = 'test@example.com';
      const password = 'password';
      const responseToken = 'mock_token';

      // mock the Dio response
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'token': responseToken},
      );

      // set up the Dio mock to return the response
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => response);

      // call the signIn method
      final result = await authRepository.signIn(email, password);

      // verify the internal logic
      expect(result, 'Login Success'); // Assert the expected result

      // verify that Dio.post was called with the correct parameters
      verify(mockDio.post(
        '${Config.baseUrl}/user/login',
        data: {
          'email': email,
          'password': password,
        },
        options: anyNamed('options'),
      )).called(1);
    });

    
    

    // test for signUp function (similar structure as signIn)
    test('signUp calls Dio with correct URL and data', () async {
      // test data
      const fullName = 'Ram Bahadur';
      const email = 'test@example.com';
      const occupation = 'Developer';
      const password = 'password';
      const phoneNumber = 1234567890;

      // mock the Dio response
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'message': 'SignUp Success'},
      );

      // set up the Dio mock to return the response
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => response);

      // call the signUp method
      final result = await authRepository.signUp(
        fullName: fullName,
        email: email,
        occupation: occupation,
        password: password,
        phoneNumber: phoneNumber,
      );

      // verify the internal logic
      expect(result, 'SignUp Success'); // Assert the expected result

      // verify that Dio.post was called with the correct parameters
      verify(mockDio.post(
        '${Config.baseUrl}/user/register',
        data: {
          'fullName': fullName,
          'email': email,
          'occupation': occupation,
          'password': password,
          'phoneNumber': phoneNumber,
        },
        options: anyNamed('options'),
      )).called(1);
    });

    // test for sendEmailVerification function (similar structure as signIn)
    test('sendEmailVerification calls Dio with correct URL and data', () async {
      const email = 'test@example.com';

      // mock the Dio response
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {'message': 'Verification Sent Successfully'},
      );

      // set up the Dio mock to return the response
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => response);

      // call the sendEmailVerification method
      final result = await authRepository.sendEmailVerification(email);

      // verify the internal logic
      expect(result, 'Verification Sent Successfully'); // Assert the expected result

      // verify that Dio.post was called with the correct parameters
      verify(mockDio.post(
        '${Config.baseUrl}/user/send-verification-email',
        data: {'email': email},
        options: anyNamed('options'),
      )).called(1);
    });
  });

  // group for testing mock behavior of AuthRepository class
  group('AuthRepository - Mock Tests', () {
    final mockAuthRepository = MockAuthRepository();

    // test signIn function in mockAuthRepository
    test('signIn returns Login Success on valid credentials', () async {
      const email = 'test@example.com';
      const password = 'password';

      // mock the signIn method of mockAuthRepository
      when(mockAuthRepository.signIn(email, password)).thenAnswer((_) async => 'Login Success');

      // call the signIn method and get the result
      final result = await mockAuthRepository.signIn(email, password);

      // verify the result is 'Login Success'
      expect(result, 'Login Success');
    });

    // add more tests for other functions in MockAuthRepository as needed
  });
}
