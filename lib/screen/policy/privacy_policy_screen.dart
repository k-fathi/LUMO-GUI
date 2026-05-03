// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../main/main_screen.dart';
//
// class PrivacyPolicyScreen extends StatefulWidget {
//   const PrivacyPolicyScreen({super.key});
//
//   @override
//   State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
// }
//
// class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
//   bool _loading = false;
//
//   Future<void> _acceptAndContinue() async {
//     setState(() => _loading = true);
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('privacy_accepted', true);
//     // small delay so user sees pressed state
//     await Future.delayed(const Duration(milliseconds: 200));
//     if (!mounted) return;
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (_) => const MainScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F8F8),
//       appBar: AppBar(
//         title: Text('Privacy & Safety', style: GoogleFonts.poppins(
//             fontWeight: FontWeight.w600,
//           color: Colors.white
//         )),
//         backgroundColor: Color(0xffFFB74D),
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: 8),
//                       Text(
//                         'A simple privacy policy for kids',
//                         style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'This app is made for children to learn through games, drawing and spinning activities. We care about kids’ safety and privacy. Below is a short, easy-to-understand summary.',
//                         style: TextStyle(fontSize: 15, color: Colors.grey[800]),
//                       ),
//
//                       const SizedBox(height: 18),
//                       _sectionTitle('1. Information we collect'),
//                       _sectionText('We do not ask for or collect personal information from children like their name, email or address. The app only uses basic device information for analytics and app performance, and only if parents have allowed it. We do not create accounts for kids.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('2. No targeted advertising to kids'),
//                       _sectionText('We do not show ads that are targeted to a child based on personal information. Any ads shown (if enabled) are general and not personalized. If you want ads removed, please use the in-app settings or consider the paid version.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('3. Parental control & supervision'),
//                       _sectionText('Parents or guardians should supervise a child while using the app. If the app asks for permissions (camera, storage) those are only used to enable drawing, saving pictures, or sharing with family. You can decline permissions and the core learning games will still work.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('4. Safety from abuse & inappropriate content'),
//                       _sectionText('We do not allow user-generated public chat or open content from strangers. If you see something inappropriate, contact us immediately (contact info below). Any content in the app is curated by our team to be child-friendly.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('5. Third-party services'),
//                       _sectionText('We may use trusted third-party services for analytics, ads, or in-app purchases. These services may collect anonymous usage data. We do not share personal information about children with third parties.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('6. Privacy choices & data removal'),
//                       _sectionText('If you (the parent) want to know what data we have or request deletion, please contact us. We will respond and help remove data when appropriate.'),
//
//                       const SizedBox(height: 12),
//                       _sectionTitle('7. Contact & report abuse'),
//                       _sectionText('If you believe a child’s privacy has been violated or you find abusive content, please email us at support@kidsworld.example (replace with your real support email). Include details and we will act promptly.'),
//
//                       const SizedBox(height: 18),
//                       Text(
//                         'By tapping Continue, you acknowledge that you (as the parent or guardian) have read and agree to this summary. You confirm this is appropriate for your child to use.',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[800]),
//                       ),
//
//                       const SizedBox(height: 28),
//                     ],
//                   ),
//                 ),
//               ),
//
//               // Continue button
//               SafeArea(
//                 top: false,
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _loading ? null : _acceptAndContinue,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xffFFB74D),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: _loading
//                         ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                         : Text('Continue', style: GoogleFonts.poppins(fontSize: 18,
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String text) {
//     return Text(text, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600));
//   }
//
//   Widget _sectionText(String text) {
//     return Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[800]));
//   }
// }
