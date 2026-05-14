import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
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

    // Redirect
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
      backgroundColor: const Color(0xFF121318), // surface
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF002366).withOpacity(0.9), // primary-container
                    const Color(0xFF0D0E12).withOpacity(0.9), // surface-container-lowest
                    const Color(0xFF121318).withOpacity(0.9), // background
                  ],
                ),
              ),
            ),
          ),
          
          // Ambient Glow Top Left
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB3C5FF).withOpacity(0.1), // primary-fixed-dim
                boxShadow: [
                  BoxShadow(color: const Color(0xFFB3C5FF).withOpacity(0.1), blurRadius: 120, spreadRadius: 120),
                ],
              ),
            ),
          ),
          
          // Ambient Glow Bottom Right
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF002E2E).withOpacity(0.2), // tertiary-container
                boxShadow: [
                  BoxShadow(color: const Color(0xFF002E2E).withOpacity(0.2), blurRadius: 120, spreadRadius: 120),
                ],
              ),
            ),
          ),

          // Bus Float Image
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.3,
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
                            colorBlendMode: BlendMode.screen,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                
                // Logo Section
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glass Ring
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
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
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.15)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00DDDD).withOpacity(0.15),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Center(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                                width: 110,
                                height: 110,
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
                
                // Title
                Text(
                  'SBSTC',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB3C5FF),
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium Bus Service',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00DDDD),
                    letterSpacing: 3.6,
                  ),
                ),
                
                const Spacer(),
                
                // Loading Component
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      // Shimmer Bar
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: 0.6,
                                alignment: Alignment(
                                  // Map 0..1 to -2..2 for infinite sliding effect
                                  (_shimmerController.value * 4) - 2, 
                                  0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Color(0xFF00DDDD),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00DDDD).withOpacity(0.5),
                                        blurRadius: 15,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Status Indicator
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.3 + (_pulseController.value * 0.7),
                            child: Text(
                              'Initializing Flight Systems',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xB3C5C6D2), // on-surface-variant / 70%
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            size: 14,
                            color: Color(0xFF00DDDD), // tertiary-fixed-dim
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ENCRYPTED CONNECTION',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00DDDD),
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF002E2E).withOpacity(0.4),
                            ),
                            child: const Icon(
                              Icons.stars,
                              color: Color(0xFF00DDDD),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First Class Experience',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFB3C5FF),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'The future of intercity travel is here.',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFC5C6D2),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  '© 2024 SBSTC Premium Division',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0x66C5C6D2),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
