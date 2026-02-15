import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Cairo'),
      home: const OnboardingFlow(),
    );
  }
}

// ──────────────────────────────────────────────
//               الـ Root مع الـ Bottom Nav
// ──────────────────────────────────────────────
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentNavIndex = 0; // 0 = onboarding, 1 = search, 2 = home (بعد finish)

  final List<Widget> _screens = [
    const OnboardingPages(), // صفحة الأونبوردينج كلها
    const Center(
      child: Text("صفحة البحث الرئيسية", style: TextStyle(fontSize: 30)),
    ),
    const Center(
      child: Text(
        "الصفحة الرئيسية بعد الـ onboarding",
        style: TextStyle(fontSize: 30),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.slideshow),
            label: 'Onboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
//           شاشات الأونبوردينج (PageView)
// ──────────────────────────────────────────────
class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'ليه تسيب عميل يمشي؟',
      'subtitle': 'لاقي الأدوية الناقصة فوراً وخدّم عملائك في المكان',
      'image': 'assets/images/pharmacy1.png',
    },
    {
      'title': 'وفر وقتك ووقت عميلك',
      'subtitle': 'ابحث بسرعة، قارن الأسعار، واطلب التوصيل لو مش موجود',
      'image': 'assets/images/pharmacy2.png',
    },
    {
      'title': 'جاهز تبدأ؟',
      'subtitle': 'انضم لأكتر من 5000 صيدلية واعمل فرق في خدمتك',
      'image': 'assets/images/pharmacy3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _skipToHome(),
            child: const Text("تخطي", style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page['image']!,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page['title']!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page['subtitle']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.teal
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // أزرار التحكم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text("رجوع"),
                    )
                  else
                    const SizedBox.shrink(),

                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _skipToHome();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: const Size(160, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? "التالي" : "ابدأ الآن",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 80,
            ), // مساحة تحت عشان الـ bottom nav ما يغطيش
          ],
        ),
      ),
    );
  }

  void _skipToHome() {
    // هنا بنروح للصفحة الرئيسية (index 2)
    // أو ممكن تحفظي في shared_preferences إن الأونبوردينج خلّص
    setState(() {
      (context.findAncestorStateOfType<_OnboardingFlowState>())
              ?._currentNavIndex =
          2;
    });
  }
}
