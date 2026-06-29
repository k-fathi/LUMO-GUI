import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient_model.dart';
import '../models/session_model.dart';

class ApiService {
  static const String baseUrl = 'https://app2.clickexpress.delivery/api';
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Initialize Dio and Interceptors
  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final token = (prefs.getString('auth_token') ?? '')
              .replaceAll('Bearer ', '')
              .trim();

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          options.headers['Accept'] = 'application/json';
          options.headers['Content-Type'] = 'application/json';

          handler.next(options);
        },
      ),
    );
  }

  // ─── Auth ────────────────────────────────────────────────────────────────

  /// Returns null on success, or an error message string on failure.
  Future<String?> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        String? token;
        String? role;

        if (data is Map<String, dynamic>) {
          // Detect role to block patient logins
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

          // Extract token
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
          return null; // success
        }
      }
      return 'Invalid credentials or server error';
    } catch (e) {
      print('Login error: $e');
      return 'Invalid credentials or server error';
    }
  }

  // ─── Doctor ───────────────────────────────────────────────────────────────

  /// GET /doctor/patients — returns list of patients for the logged-in doctor.
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
      final errorMsg =
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

  // ─── Sessions ─────────────────────────────────────────────────────────────

  /// GET /sessions/list/<patientId> — returns all sessions for a patient.
  Future<List<Session>> getPatientSessions(int patientId) async {
    try {
      final response = await _dio.get('/sessions/list/$patientId');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        dynamic responseData = response.data;
        List<dynamic> sessionsData = [];

        if (responseData is Map) {
          if (responseData.containsKey('data')) {
            var data = responseData['data'];
            if (data is List) {
              sessionsData = data;
            } else if (data is Map) {
              sessionsData = [data];
            }
          }
        } else if (responseData is List) {
          sessionsData = responseData;
        }

        return sessionsData
            .whereType<Map>()
            .map((e) => Session.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      print('Get sessions error: $e');
      return [];
    } catch (e) {
      print('Get sessions error: $e');
      return [];
    }
  }

  /// POST /sessions/<sessionId>/start — starts a session and returns full data including segments.
  Future<Session?> startSession(int sessionId) async {
    try {
      final response = await _dio.post('/sessions/$sessionId/start');
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          response.data != null) {
        dynamic responseData = response.data;
        Map<String, dynamic>? sessionData;

        if (responseData is Map) {
          if (responseData.containsKey('data') && responseData['data'] is Map) {
            sessionData = Map<String, dynamic>.from(responseData['data']);
          } else {
            sessionData = Map<String, dynamic>.from(responseData);
          }
        }

        if (sessionData != null) {
          return Session.fromJson(sessionData);
        }
      }
      return null;
    } on DioException catch (e) {
      print('Start session error: $e');
      return null;
    } catch (e) {
      print('Start session error: $e');
      return null;
    }
  }

  /// POST /sessions/<sessionId>/end — ends an active session.
  Future<bool> endSession(int sessionId) async {
    try {
      final response = await _dio.post('/sessions/$sessionId/end');
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      print('End session error: $e');
      return false;
    } catch (e) {
      print('End session error: $e');
      return false;
    }
  }

  // ─── Segments ─────────────────────────────────────────────────────────────

  /// POST /segments/<segmentId>/start — starts a segment (AI tracking begins).
  Future<bool> startSegment(int segmentId) async {
    try {
      final response = await _dio.post('/segments/$segmentId/start');
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      print('Start segment error: $e');
      return false;
    } catch (e) {
      print('Start segment error: $e');
      return false;
    }
  }

  /// POST /segments/<segmentId>/complete — marks a segment as completed.
  Future<bool> completeSegment(
    int segmentId, {
    String? storyTrait,
    bool? isAnswerCorrect,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (storyTrait != null) data['story_trait'] = storyTrait;
      if (isAnswerCorrect != null) data['is_answer_correct'] = isAnswerCorrect;

      final response = await _dio.post(
        '/segments/$segmentId/complete',
        data: data.isNotEmpty ? data : null,
      );
      return response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300;
    } on DioException catch (e) {
      print('Complete segment error: $e');
      return false;
    } catch (e) {
      print('Complete segment error: $e');
      return false;
    }
  }
}
