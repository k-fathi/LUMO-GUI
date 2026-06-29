import 'segment_model.dart';

class Session {
  final int sessionId;
  final String patientName;
  final String status;
  final bool isCompleted;
  final String? date;
  final String startTime;
  final String? endTime;
  final int? durationMins;
  final String? doctorNotes;
  final String? createdAt;
  final List<Segment> segments;

  Session({
    required this.sessionId,
    required this.patientName,
    required this.status,
    required this.isCompleted,
    this.date,
    required this.startTime,
    this.endTime,
    this.durationMins,
    this.doctorNotes,
    this.createdAt,
    this.segments = const [],
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    // Parse segments if present (from sessions/<id>/start response)
    List<Segment> segments = [];
    if (json['segments'] != null && json['segments'] is List) {
      segments = (json['segments'] as List)
          .whereType<Map>()
          .map((e) => Segment.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return Session(
      sessionId: json['session_id'] ?? 0,
      patientName: json['patient_name'] ?? 'Unknown',
      status: json['status'] ?? 'unknown',
      isCompleted: json['is_completed'] == true || json['is_completed'] == 1,
      date: json['date']?.toString(),
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString(),
      durationMins: json['duration_mins'],
      doctorNotes: json['doctor_notes'],
      createdAt: json['created_at']?.toString(),
      segments: segments,
    );
  }
}
