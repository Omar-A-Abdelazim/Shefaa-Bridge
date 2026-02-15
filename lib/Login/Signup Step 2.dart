import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // مكتبة تحديد الموقع
import 'package:geocoding/geocoding.dart'; // مكتبة تحويل الإحداثيات لعنوان
import 'package:pharmacy_app/Login/Signup%20Step%203.dart';
import 'package:pharmacy_app/Login/Widgets.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة فتح الروابط الخارجية (للخرائط)

class SignupStep2 extends StatefulWidget {
  const SignupStep2({super.key});

  @override
  State<SignupStep2> createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  // Controller للتحكم في حقل العنوان
  final TextEditingController _locationController = TextEditingController();
  bool _isLoadingLocation = false; // لعرض مؤشر التحميل في الودجت
  Position? _currentPosition; // لحفظ الإحداثيات الحالية

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // دالة الحصول على الموقع الحالي
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 1. التحقق من تفعيل خدمة الموقع (GPS)
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled. Please enable GPS.');
        setState(() => _isLoadingLocation = false);
        return;
      }

      // 2. التحقق من الأذونات (Permissions)
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permissions are denied');
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied.');
        setState(() => _isLoadingLocation = false);
        return;
      }

      // 3. جلب الإحداثيات الحالية (مع مهلة زمنية 5 ثواني لتجنب التعليق)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5), // Timeout added
      );

      _currentPosition = position;

      // 4. تحويل الإحداثيات إلى عنوان (Reverse Geocoding)
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          // تنسيق العنوان: الشارع، المنطقة، المدينة، الدولة
          String formattedAddress = [
            place.street,
            place.subLocality,
            place.locality,
            place.country
          ]
              .where((element) => element != null && element.isNotEmpty)
              .join(', ');

          setState(() {
            _locationController.text = formattedAddress;
          });
          _showSnackBar('Location updated successfully!');
        }
      } catch (e) {
        debugPrint("Geocoding error: $e");
        setState(() {
          _locationController.text =
              "${position.latitude}, ${position.longitude}";
        });
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      _showSnackBar('Could not auto-detect location. Please pick manually.');
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  // دالة لفتح خرائط جوجل
  Future<void> _openMap() async {
    // نستخدم الموقع الحالي إذا وجد، أو موقع افتراضي (القاهرة)
    final double lat = _currentPosition?.latitude ?? 30.0444;
    final double lng = _currentPosition?.longitude ?? 31.2357;

    // رابط خرائط جوجل
    final Uri googleMapsUrl =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(googleMapsUrl);
      }
    } catch (e) {
      debugPrint("Error launching map: $e");
      _showSnackBar('Error opening maps.');
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(step: 2, totalSteps: 3, percent: 0.66),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Pharmacy Business Info",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Verify your professional credentials to start exchanging medicines safely.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),

              const CustomLabel(text: "PHARMACY NAME"),
              const CustomTextField(
                  hintText: "e.g. Green Valley Pharma",
                  prefixIcon: Icons.local_pharmacy_outlined),
              const SizedBox(height: 20),

              const CustomLabel(text: "LICENSE NUMBER"),
              const CustomTextField(
                  hintText: "PH-987654321", prefixIcon: Icons.badge_outlined),
              const SizedBox(height: 20),

              const CustomLabel(text: "PHARMACY LOCATION"),
              CustomTextField(
                controller: _locationController,
                hintText: "Search address or pin on map",
                prefixIcon: Icons.location_on_outlined,
                suffixIcon: _isLoadingLocation
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : null,
              ),
              const SizedBox(height: 16),

              // جعلنا الـ Widget قابلة للضغط لفتح الخرائط حتى لو لم يتم تحديد الموقع بدقة
              GestureDetector(
                onTap: _openMap,
                child: AbsorbPointer(
                  absorbing:
                      _isLoadingLocation, // نمنع الضغط المتكرر أثناء التحميل
                  child: LocationPickerWidget(
                    onGetCurrentLocation: _getCurrentLocation,
                    isLoading: _isLoadingLocation,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // زر إضافي لفتح الخرائط يدوياً
              Center(
                child: TextButton.icon(
                  onPressed: _openMap,
                  icon: const Icon(Icons.map_outlined,
                      size: 18, color: Color(0xFF1DE9B6)),
                  label: const Text(
                    "Open Google Maps",
                    style: TextStyle(
                        color: Color(0xFF1DE9B6), fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "By proceeding, you agree that your pharmacy information will be verified.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),
              PrimaryButton(
                text: "Next Step",
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupStep3()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
