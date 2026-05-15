import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/patient_model.dart';
import '../../services/api_service.dart';

import '../auth/sign_in_screen.dart';
import '../main/main_screen.dart';

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
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.offAll(() => const SignInScreen()),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patients.isEmpty
              ? Center(
                  child: Text(
                    'No patients found.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    final isSelected = _selectedPatient?.id == patient.id;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isSelected 
                            ? const BorderSide(color: Colors.blueAccent, width: 2)
                            : BorderSide.none,
                      ),
                      elevation: isSelected ? 4 : 2,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _selectedPatient = patient;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          backgroundImage: patient.profileImage != null && patient.profileImage!.isNotEmpty
                              ? NetworkImage(patient.profileImage!) 
                              : null,
                          child: (patient.profileImage == null || patient.profileImage!.isEmpty)
                              ? const Icon(Icons.person, color: Colors.blueAccent)
                              : null,
                        ),
                        title: Text(
                          patient.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('ID: ${patient.id}'),
                            const SizedBox(height: 4),
                            Text('Child: ${patient.childName} (Age: ${patient.childAge})'),
                          ],
                        ),
                        trailing: isSelected 
                            ? const Icon(Icons.check_circle, color: Colors.blueAccent)
                            : null,
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
                    // Navigate to main application screen
                    Get.offAll(() => const MainScreen());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedPatient != null ? Colors.blueAccent : Colors.grey.shade400,
              disabledBackgroundColor: Colors.grey.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
            ),
            child: Text(
              "Start New Session",
              style: GoogleFonts.poppins(
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
