import 'package:flutter/material.dart';
import 'package:pharmacy_app/Login/Login%20Screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingData> _pages = [
    OnBoardingData(
      title: "Why Let a Customer Leave?",
      description:
          "Find missing medicines instantly and serve your customers on the spot.",
      buttonText: "Get Started",
      footerText: "Trusted by over 5,000+ licensed pharmacies",
      color: const Color(0xFF00E5BC),
      image: "onBoarding1",
    ),
    OnBoardingData(
      title: "Why Let Medicines Expire?",
      description:
          "Sell surplus stock before expiry and reduce financial loss effortlessly.",
      buttonText: "Continue",
      footerText: "",
      color: const Color(0xFF1E88E5),
      image: "onBoarding2",
    ),
    OnBoardingData(
      title: "One Network. Smarter Pharmacies.",
      description: "Buy what you need. Sell what you don't. Increase profit.",
      buttonText: "Get Started",
      footerText: "By joining, you agree to our Terms of Service",
      color: const Color(0xFF00E5BC),
      image: "onBoarding3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 18, color: Colors.grey),
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(_pages.length, (index) => _buildDot(index)),
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages[_currentPage].color,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _pages[_currentPage].buttonText,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward,
                        color: Colors.black, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            if (_pages[_currentPage].footerText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _pages[_currentPage].footerText,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              )
            else
              const SizedBox(height: 31),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnBoardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/${data.image}.png', // هياخد onboarding1.png , onboarding2.png , إلخ
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 80, color: Colors.grey));
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(data.title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, color: Colors.grey, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 6,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? _pages[_currentPage].color : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnBoardingData {
  final String title;
  final String description;
  final String buttonText;
  final String footerText;
  final Color color;
  final String image;

  OnBoardingData({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.footerText,
    required this.color,
    required this.image,
  });
}
