import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: OnBoardingScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

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
      image:
          "https://via.placeholder.com/300x300?text=Pharmacy+1", // Placeholder
    ),
    OnBoardingData(
      title: "Why Let Medicines Expire?",
      description:
          "Sell surplus stock before expiry and reduce financial loss effortlessly.",
      buttonText: "Continue",
      footerText: "",
      color: const Color(0xFF1E88E5),
      image:
          "https://via.placeholder.com/300x300?text=Pharmacy+2", // Placeholder
    ),
    OnBoardingData(
      title: "One Network. Smarter Pharmacies.",
      description: "Buy what you need. Sell what you don't. Increase profit.",
      buttonText: "Get Started",
      footerText: "By joining, you agree to our Terms of Service",
      color: const Color(0xFF00E5BC),
      image:
          "https://via.placeholder.com/300x300?text=Pharmacy+3", // Placeholder
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (Skip Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  else
                    const SizedBox(width: 48),
                  TextButton(
                    onPressed: () {
                      // Skip logic
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Dots Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),
            const SizedBox(height: 32),

            // Bottom Button
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
                    // Final action
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _pages[_currentPage].color,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _pages[_currentPage].buttonText,
                      style: const TextStyle(
                        color: Colors
                            .black, // Matching the image's text color on button
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            // Footer Text
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
              const SizedBox(height: 31), // Maintain layout stability
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
          // Illustration Placeholder
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.network(
                data.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, size: 100, color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
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
