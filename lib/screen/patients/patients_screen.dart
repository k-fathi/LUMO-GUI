import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/patient_model.dart';

import '../../services/api_service.dart';
import '../auth/sign_in_screen.dart';
import '../sessions/sessions_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Patient> _patients = [];
  Patient? _selectedPatient;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() => _isLoading = true);
    final patients = await _apiService.getPatients();
    if (mounted) {
      setState(() {
        _patients = patients;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      appBar: AppBar(
        title: Text(
          'Your Patients',
          style: TextStyle(fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.offAll(() => const SignInScreen()),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _patients.isEmpty
          ? Center(
              child: Text(
                'No patients found.',
                style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: _patients.length,
              itemBuilder: (context, index) {
                final patient = _patients[index];
                final isSelected = _selectedPatient?.id == patient.id;
                return Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: isSelected
                        ? const BorderSide(color: Colors.blueAccent, width: 3)
                        : BorderSide.none,
                  ),
                  elevation: isSelected ? 6 : 2,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPatient = patient;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                                  backgroundImage:
                                      patient.profileImage != null &&
                                              patient.profileImage!.isNotEmpty
                                          ? NetworkImage(patient.profileImage!)
                                          : null,
                                  child: (patient.profileImage == null ||
                                          patient.profileImage!.isEmpty)
                                      ? Icon(Icons.person, color: Colors.blueAccent, size: 40)
                                      : null,
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.blueAccent,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            patient.name,
                            style: TextStyle(fontFamily: 'Poppins', 
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Child: ${patient.childName}',
                            style: TextStyle(fontFamily: 'Poppins',

                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Age: ${patient.childAge}',
                            style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: (_isLoading || _patients.isEmpty)
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _selectedPatient != null
                      ? () {
                          Get.to(
                            () => SessionsScreen(patient: _selectedPatient!),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedPatient != null
                        ? Colors.blueAccent
                        : Colors.grey.shade400,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    "Show All Sessions",
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
