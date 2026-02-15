import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/Login/Widgets.dart';
import 'package:pharmacy_app/screens/main/main_navigation_screen.dart'; // ← التعديل المهم

class SignupStep3 extends StatefulWidget {
  const SignupStep3({super.key});

  @override
  State<SignupStep3> createState() => _SignupStep3State();
}

class _SignupStep3State extends State<SignupStep3> {
  String? _crFileName;
  String? _licenseFileName;

  Future<void> uploadImage(bool isCamera, bool isCr) async {
    try {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (pickedImage != null) {
        setState(() {
          if (isCr) {
            _crFileName = pickedImage.name;
          } else {
            _licenseFileName = pickedImage.name;
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _showImagePickerOptions(bool isCr) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1DE9B6)),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(true, isCr);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xFF1DE9B6)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                uploadImage(false, isCr);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteFile(bool isCr) {
    setState(() {
      if (isCr)
        _crFileName = null;
      else
        _licenseFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(step: 3, totalSteps: 3, percent: 1.0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.verified_user_outlined,
                      size: 80, color: Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Final Step: Verify Your Pharmacy",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  "Upload your legal documents to unlock full marketplace access.",
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              const CustomLabel(text: "Commercial Registration (CR)"),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _crFileName == null
                    ? DocumentUploadCard(
                        onTap: () => _showImagePickerOptions(true))
                    : UploadedFileCard(
                        fileName: _crFileName!,
                        onDelete: () => _deleteFile(true)),
              ),
              const SizedBox(height: 24),
              const CustomLabel(text: "Pharmacy Practice License"),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _licenseFileName == null
                    ? DocumentUploadCard(
                        onTap: () => _showImagePickerOptions(false))
                    : UploadedFileCard(
                        fileName: _licenseFileName!,
                        onDelete: () => _deleteFile(false)),
              ),
              const SizedBox(height: 30),
              Opacity(
                opacity: (_crFileName != null && _licenseFileName != null)
                    ? 1.0
                    : 0.6,
                child: PrimaryButton(
                  text: "Submit for Verification",
                  icon: Icons.check,
                  onPressed: () {
                    if (_crFileName != null && _licenseFileName != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Account Created Successfully!"),
                          backgroundColor: Color(0xFF1DE9B6),
                        ),
                      );

                      // ← التعديل الأهم هنا
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen()),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please upload both documents")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
