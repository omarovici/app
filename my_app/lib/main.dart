import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ala Mahlak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFC616)),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _onAnimationLoaded(LottieComposition composition) {
    _lottieController
      ..duration = composition.duration
      ..forward().whenComplete(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'animation/Copy of Ala Mahlak Animation.json',
          controller: _lottieController,
          onLoaded: _onAnimationLoaded,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  final int _totalSteps = 3;
  late final AnimationController _controller;
  final PageController _pageController = PageController();
  Animation<double> _progressAnimation = const AlwaysStoppedAnimation(1 / 3);

  final List<Map<String, String>> _pages = const [
    {
      'image': 'images/Anywhere you are.svg',
      'title': 'Anywhere you are',
      'subtitle':
          'Sell houses easily with the help of\nListenoryx and to make this line big\nI am writing more.',
    },
    {
      'image': 'images/At anytime.svg',
      'title': 'At anytime',
      'subtitle':
          'Sell houses easily with the help of\nListenoryx and to make this line big\nI am writing more.',
    },
    {
      'image': 'images/Frame 1.svg',
      'title': 'Book your car',
      'subtitle':
          'Sell houses easily with the help of\nListenoryx and to make this line big\nI am writing more.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnimation = Tween<double>(
      begin: _currentStep / _totalSteps,
      end: _currentStep / _totalSteps,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      final oldProgress = _currentStep / _totalSteps;
      setState(() {
        _currentStep++;
      });
      final newProgress = _currentStep / _totalSteps;
      _progressAnimation = Tween<double>(
        begin: oldProgress,
        end: newProgress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0);
      _pageController.animateToPage(
        _currentStep - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, right: 24),
                child: GestureDetector(
                  onTap: () {
                    // Handle skip
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _totalSteps,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      // Illustration
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SvgPicture.asset(
                          page['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        page['title']!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF414141),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Subtitle
                      SizedBox(
                        width: 280,
                        child: Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA0A0A0),
                            height: 1.36,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Progress Next Button
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return ProgressNextButton(
                  progress: _progressAnimation.value,
                  onTap: _nextStep,
                  isLastPage: _currentStep == _totalSteps,
                );
              },
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

/// Circular progress button from Figma (node-id: 2:276)
class ProgressNextButton extends StatelessWidget {
  final double progress;
  final VoidCallback? onTap;
  final bool isLastPage;

  const ProgressNextButton({
    super.key,
    required this.progress,
    this.onTap,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        height: 86,
        child: CustomPaint(
          painter: _ProgressRingPainter(progress: progress),
          child: Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFC616),
              ),
              child: isLastPage
                  ? Center(
                      child: Text(
                        'Go',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5A5A5A),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF5A5A5A),
                      size: 24,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;

  _ProgressRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 4.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    // Full track ring — Primary/50
    final trackPaint = Paint()
      ..color = const Color(0xFFFFECAF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius - strokeWidth / 2, trackPaint);

    // Progress arc — Primary/800
    final progressPaint = Paint()
      ..color = const Color(0xFFDCA701)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
