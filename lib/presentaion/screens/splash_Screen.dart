import 'package:flutter/material.dart';
import 'package:quran_tracker/core/colors.dart';
import 'package:quran_tracker/presentaion/screens/login_Screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin {
  // متغير للتحكم بالأنيميشن
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation; 
  
  @override
  void initState() {
    super.initState();
    // تهيئة الـ AnimationController لمدة 2 ثانية
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // أنيميشن التلاشي (Fade) من 0 إلى 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // أنيميشن التكبير (Scale) من 0.8 إلى 1
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // تشغيل الأنيميشن
    _controller.forward();






    // بعد 3 ثواني، ننتقل لصفحة تسجيل الدخول
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, size: 70, color: Colors.green),

              const SizedBox(height: 25),
              //أسم التطبيق
              const Text(
                "تطبيق حافظ",

                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: AppColors.textPrimary,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // الجملة التعريفية
              const Text(
                "لمتابعة تحفيظ القرآن الكريم 💚",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                      color: Colors.black12,
                      offset: Offset(0.5, 0.5),
                    ),
                  ],
                ),
              ),
              //مؤشر التحميل
              const SizedBox(height: 50),
             const CircularProgressIndicator(
                color:const Color(0xFF2E7D32),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
