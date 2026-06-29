import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/patient_model.dart';
import '../../models/session_model.dart';
import '../../services/api_service.dart';
import '../main/main_screen.dart';

class SessionsScreen extends StatefulWidget {
  final Patient patient;

  const SessionsScreen({super.key, required this.patient});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  bool _isStarting = false;
  List<Session> _sessions = [];
  Session? _selectedSession;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    setState(() => _isLoading = true);
    final sessions = await _apiService.getPatientSessions(widget.patient.id);
    if (mounted) {
      setState(() {
        sessions.sort((a, b) => a.sessionId.compareTo(b.sessionId));
        _sessions = sessions;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleStartSession() async {
    if (_selectedSession == null) return;
    setState(() => _isStarting = true);

    final startedSession = await _apiService.startSession(_selectedSession!.sessionId);

    if (!mounted) return;
    setState(() => _isStarting = false);

    if (startedSession != null) {
      Get.to(() => MainScreen(session: startedSession));
    } else {
      Get.snackbar(
        'Error',
        'Failed to start session. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Color _statusColor(Session s) =>
      s.isCompleted ? Colors.green.shade600 : Colors.orange.shade700;

  Color _statusBgColor(Session s) =>
      s.isCompleted ? Colors.green.shade50 : Colors.orange.shade50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F8),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.patient.name,
              style: TextStyle(fontFamily: 'Poppins', 
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 17,
              ),
            ),
            Text(
              'Child: ${widget.patient.childName}',
              style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
              ? Center(
                  child: Text(
                    'No sessions found.',
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Instruction banner
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade600, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Select one session, then tap "Start Session"',
                              style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 13,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Sessions list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: _sessions.length,
                        itemBuilder: (context, index) {
                          final session = _sessions[index];
                          final isSelected =
                              _selectedSession?.sessionId == session.sessionId;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSession = isSelected ? null : session;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? Colors.blueAccent.withOpacity(0.15)
                                        : Colors.black.withOpacity(0.06),
                                    blurRadius: isSelected ? 12 : 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Selection indicator
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? Colors.blueAccent
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.blueAccent
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? Icon(Icons.check,
                                              size: 14, color: Colors.white)
                                          : null,
                                    ),
                                    SizedBox(width: 14),

                                    // Session info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Session #${index + 1}',
                                                style: TextStyle(fontFamily: 'Poppins', 
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _statusBgColor(session),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  session.status.toUpperCase(),
                                                  style: TextStyle(fontFamily: 'Poppins', 
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: _statusColor(session),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          if (session.date != null)
                                            _infoRow(Icons.calendar_today,
                                                session.date!),
                                          _infoRow(
                                              Icons.access_time_rounded,
                                              'Start: ${session.startTime}'),
                                          if (session.endTime != null &&
                                              session.endTime!.isNotEmpty)
                                            _infoRow(Icons.flag_rounded,
                                                'End: ${session.endTime}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomNavigationBar: (!_isLoading && _sessions.isNotEmpty)
          ? Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      (_selectedSession != null && !_isStarting && !_selectedSession!.isCompleted)
                          ? _handleStartSession
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                  ),
                  child: _isStarting
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Start Session',
                          style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 13, color: Colors.grey.shade500),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
