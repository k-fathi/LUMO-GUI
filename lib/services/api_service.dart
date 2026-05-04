import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient_model.dart';

class ApiService {
  static const String baseUrl = 'https://clickexpress.delivery/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Initialize Dio and Interceptors
  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('auth_token');
          if (token != null) {
            // ensure token is clean of 'Bearer ' prefix if it already has it
            token = token.replaceAll('Bearer ', '').trim();
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
      ),
    );
  }

  // Login
  Future<String?> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Extract token based on generic standard format.
        final data = response.data;
        String? token;
        String? role;

        if (data is Map<String, dynamic>) {
          // Check role validation
          if (data.containsKey('role')) {
            role = data['role'];
          } else if (data.containsKey('user') &&
              data['user'] is Map &&
              data['user'].containsKey('role')) {
            role = data['user']['role'];
          } else if (data.containsKey('data') && data['data'] is Map) {
            if (data['data'].containsKey('role')) {
              role = data['data']['role'];
            } else if (data['data'].containsKey('user') &&
                data['data']['user'] is Map &&
                data['data']['user'].containsKey('role')) {
              role = data['data']['user']['role'];
            }
          }

          if (role == 'patient') {
            return 'Only doctors can sign-in to the GUI';
          }

          if (data.containsKey('token')) {
            token = data['token'];
          } else if (data.containsKey('data') &&
              data['data'] is Map &&
              data['data'].containsKey('token')) {
            token = data['data']['token'];
          } else if (data.containsKey('access_token')) {
            token = data['access_token'];
          }
        }

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          return null; // Success
        }
      }
      return 'Invalid credentials or server error';
    } catch (e) {
      print('Login error: $e');
      return 'Invalid credentials or server error';
    }
  }

  // Get Doctor Patients
  Future<List<Patient>> getPatients() async {
    try {
      final response = await _dio.get('/doctor/patients');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        List<dynamic> patientsData = [];
        dynamic responseData = response.data;

        if (responseData is List) {
          patientsData = responseData;
        } else if (responseData is Map) {
          if (responseData.containsKey('data')) {
            var innerData = responseData['data'];
            if (innerData is List) {
              patientsData = innerData;
            } else if (innerData is Map) {
              if (innerData.containsKey('patients') &&
                  innerData['patients'] is List) {
                patientsData = innerData['patients'];
              } else if (innerData.containsKey('data') &&
                  innerData['data'] is List) {
                patientsData = innerData['data'];
              }
            }
          }
          if (patientsData.isEmpty &&
              responseData.containsKey('patients') &&
              responseData['patients'] is List) {
            patientsData = responseData['patients'];
          }
        }

        return patientsData
            .whereType<Map>()
            .map((e) => Patient.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Get patients error: $e');
      String errorMsg =
          e.response?.data?.toString() ?? e.message ?? 'Unknown Error';
      return [
        Patient(
          id: 999,
          name: 'API Error: $errorMsg',
          childName: 'Error',
          childAge: 0,
        ),
      ];
    } catch (e) {
      print('Get patients error: $e');
      return [
        Patient(
          id: 999,
          name: 'App Error: $e',
          childName: 'Error',
          childAge: 0,
        ),
      ];
    }
  }
}
