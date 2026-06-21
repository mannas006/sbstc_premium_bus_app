import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import 'home_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatYAnimation;
  late Animation<double> _floatScaleAnimation;

  late AnimationController _shimmerController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // Float Animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _floatYAnimation = Tween<double>(begin: 0, end: -15.0).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));
    
    _floatScaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Shimmer Animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Pulse Animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Redirect to Home Dashboard after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeDashboard()),
        );
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient (Midnight Navy Base)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.background,
                    AppColors.surface,
                  ],
                ),
              ),
            ),
          ),
          
          // Ambient Glow Top Left (Royal Blue Glow)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 120,
                    spreadRadius: 120,
                  ),
                ],
              ),
            ),
          ),
          
          // Ambient Glow Bottom Right (Sky Blue Glow)
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withOpacity(0.08),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLight.withOpacity(0.08),
                    blurRadius: 120,
                    spreadRadius: 120,
                  ),
                ],
              ),
            ),
          ),

          // Bus Float Image (Transparent overlay adjusted for light mode)
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.06,
                child: Transform.rotate(
                  angle: -0.035, // -2 deg
                  child: AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatYAnimation.value),
                        child: Transform.scale(
                          scale: _floatScaleAnimation.value,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuB5e_XctxudXfT8H54lIAmGtvtG1Jqxf44bO2efw78Enls3l40YR9UkiASC2Xe025qUJDk3Ur93dwY-WFdfRA-294-UoJVHnvKhwEVxYXoeYwMRElT3uM9Q51YvIfLijGNuENTLl4fwQHhukrFRKu6gXSehvhqa4ngV6yRrkbmpOubZsmEcyWjcJgaUXr_oDY-fo0is3jth8PTPbGJkepg8OiOrgd82Gh0bCUWgq5FRIMkXHMmBvmAuRyVZVq8V5erhOXZINhHmLuc_',
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Main Branding Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                
                // Logo Section with Glassmorphism Ring
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glass Outer Ring
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outline, width: 1.2),
                          ),
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ),
                        // Inner Logo Circle
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surface,
                            border: Border.all(color: AppColors.outline),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryLight.withOpacity(0.08),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Center(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                                width: 100,
                                height: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // SBSTC Brand Title
                Text(
                  'SBSTC',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Premium Bus Service',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryLight,
                    letterSpacing: 4.5,
                  ),
                ),
                
                const Spacer(),
                
                // Progress Loader
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      // Sliding Shimmer Bar
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: 0.4,
                                alignment: Alignment(
                                  (_shimmerController.value * 4) - 2, 
                                  0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.primaryLight,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryLight.withOpacity(0.4),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Animated Status Text
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.4 + (_pulseController.value * 0.6),
                            child: Text(
                              'Initializing Travel Systems',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 13,
                            color: AppColors.tertiary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SECURE CONNECTION',
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: AppColors.tertiary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Bottom Feature Promo Card (using AppColors.surface)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.15),
                        ),
                        child: const Icon(
                          Icons.stars,
                          color: AppColors.primaryLight,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Premium Travel Standard',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Comfortable reclining chairs & complimentary water.',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  '© 2026 SBSTC Premium Division',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary.withOpacity(0.4),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
