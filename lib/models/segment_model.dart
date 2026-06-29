class Segment {
  final int id;
  final String type;
  final int plannedMinutes;
  final String status;
  final String? startedAt;
  final String? endedAt;

  Segment({
    required this.id,
    required this.type,
    required this.plannedMinutes,
    required this.status,
    this.startedAt,
    this.endedAt,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      id: json['id'] ?? 0,
      type: json['type'] ?? 'unknown',
      plannedMinutes: json['planned_minutes'] ?? json['planned_duration'] ?? 0,
      status: json['status'] ?? 'pending',
      startedAt: json['started_at']?.toString() ?? json['actual_started_at']?.toString(),
      endedAt: json['ended_at']?.toString() ?? json['actual_ended_at']?.toString(),
    );
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isActive => status == 'active';
}
