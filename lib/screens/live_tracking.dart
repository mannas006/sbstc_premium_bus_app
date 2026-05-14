import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C), // map background
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Mock Map Background with CustomPainter
          _buildMapCanvas(),

          // Map Gradient Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.2, 0.8, 1.0],
                    colors: [
                      const Color(0xFF121318).withOpacity(0.8),
                      const Color(0xFF121318).withOpacity(0.0),
                      const Color(0xFF121318).withOpacity(0.0),
                      const Color(0xFF121318).withOpacity(1.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating UI Elements
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 64, // App bar clearance
                bottom: 120, // Space for Bottom Nav
                left: 24,
                right: 24,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  _buildTripStatusOverlay(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _buildVerticalTimeline(),
                    ),
                  ),
                  _buildBusDetailsCard(),
                ],
              ),
            ),
          ),

          _buildTopAppBar(context),
          _buildBottomNavBar(context),
        ],
      ),
    );
  }

  Widget _buildMapCanvas() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return CustomPaint(
            painter: MapRoutePainter(pulseAnimation: _pulseController.value),
          );
        },
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: MediaQuery.of(context).padding.top + 64,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 24, right: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF121318).withOpacity(0.8), // surface / 80
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              boxShadow: [
                BoxShadow(color: const Color(0xFF0D2C6E).withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 1)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFB3C5FF).withOpacity(0.2)),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQqb4RItC5iscLLPKVtyEql4Y_ewRYMgZRcYHRIeHtuLZ7KeVbe5RmigLtN-MwpGfFNbQ9MjHO2c5GXofQpDsPqfO_9xjhQHY_dZpQHnLUS7mC5gJKJfZWoX1WjW8RMY1zCZUouN66Y7B5qVYD8GXe9XEVzt_NTHL9UQyBJx2E1v6Jr8lJ9CR38sA-BCLtTo9EPFE3dyQJ-lmdfz9FgEQC1CuWdUwBu4VCbK-5q0_XbMca0ZJWV6V-pys0LP2bnxh-UAX67lB6-eDh',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SBSTC Premium Bus',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB3C5FF),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.notifications_none, color: Color(0xFFB3C5FF)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripStatusOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: -1,
            blurRadius: 1, // inner glow
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CURRENT LEG',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00DDDD), // tertiary
                            letterSpacing: 0.96,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Esplanade → Airport',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE3E2E8),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00DDDD).withOpacity(0.1), // tertiary/10
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF00DDDD).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: 0.3 + (_pulseController.value * 0.7),
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF00DDDD),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00DDDD),
                              letterSpacing: 0.96,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.65,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00DDDD),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFF00DDDD).withOpacity(0.5), blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passed: Science City',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFFC5C6D2),
                      ),
                    ),
                    Text(
                      '12 mins to next stop',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00DDDD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalTimeline() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildTimelineNode(
            location: 'Ultadanga',
            timeInfo: '14:45 • Done',
            icon: Icons.check_circle,
            iconColor: const Color(0xFF8E909C), // outline
            isLive: false,
            opacity: 0.6,
          ),
          const SizedBox(height: 12),
          _buildTimelineNode(
            location: 'Teghoria',
            timeInfo: '15:12',
            icon: Icons.near_me,
            iconColor: const Color(0xFF00DDDD), // tertiary
            isLive: true,
            opacity: 1.0,
          ),
          const SizedBox(height: 12),
          _buildTimelineNode(
            location: 'NSCBI Airport',
            timeInfo: '15:30 • Scheduled',
            icon: Icons.radio_button_unchecked,
            iconColor: const Color(0xFF8E909C),
            isLive: false,
            opacity: 0.6,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String location,
    required String timeInfo,
    required IconData icon,
    required Color iconColor,
    required bool isLive,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isLive ? const Color(0xFF002E2E).withOpacity(0.2) : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isLive ? const Color(0xFF00DDDD).withOpacity(0.4) : Colors.white.withOpacity(0.1)),
          boxShadow: isLive
              ? [
                  BoxShadow(color: const Color(0xFF00DDDD).withOpacity(0.3), blurRadius: 20),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      location,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLive ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2),
                        letterSpacing: 0.96,
                      ),
                    ),
                    Text(
                      timeInfo,
                      style: isLive
                          ? GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE3E2E8),
                            )
                          : GoogleFonts.manrope(
                              fontSize: 14,
                              color: const Color(0xFFC5C6D2).withOpacity(0.6),
                            ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Icon(icon, color: iconColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: -1,
            blurRadius: 1, // inner glow
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002366).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB3C5FF).withOpacity(0.2)),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Volvo 9600 B13R',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE3E2E8),
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Vehicle WB-01-AX-9921 • ',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: const Color(0xFFC5C6D2),
                            ),
                            children: [
                              TextSpan(
                                text: 'Gold Class',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: const Color(0xFF00DDDD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00DDDD).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Text(
                      'VIEW TICKET',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D2C6E),
                        letterSpacing: 0.96,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F24).withOpacity(0.6), // surface-container/60
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00DDDD).withOpacity(0.2),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, icon: Icons.home, label: 'Home', isActive: false, route: '/home'),
                _buildNavItem(context, icon: Icons.confirmation_number, label: 'Bookings', isActive: false, route: '/bookings'),
                _buildNavItem(context, icon: Icons.explore, label: 'Live', isActive: true, route: null),
                _buildNavItem(context, icon: Icons.person, label: 'Profile', isActive: false, route: null),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, required bool isActive, String? route}) {
    return GestureDetector(
      onTap: () {
        if (route == '/home') {
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (route == '/bookings') {
          Navigator.of(context).pop();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: isActive
                ? BoxDecoration(
                    color: const Color(0xFF002E2E).withOpacity(0.4), // tertiary-container/40
                    borderRadius: BorderRadius.circular(20),
                  )
                : null,
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2).withOpacity(0.7),
              letterSpacing: 0.96,
            ),
          ),
        ],
      ),
    );
  }
}

class MapRoutePainter extends CustomPainter {
  final double pulseAnimation;

  MapRoutePainter({required this.pulseAnimation});

  @override
  void paint(Canvas canvas, Size size) {
    // We scale the drawing to the size of the container, simulating the SVG path
    final paint = Paint()
      ..color = const Color(0xFF00DDDD).withOpacity(0.4)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double dashWidth = 8;
    final double dashSpace = 12;

    Path path = Path();
    // Adjusted coordinates from SVG for full screen mapping
    path.moveTo(size.width * 0.6, size.height * 0.1);
    path.cubicTo(
        size.width * 0.8, size.height * 0.2,
        size.width * 0.3, size.height * 0.4,
        size.width * 0.5, size.height * 0.5);
    path.cubicTo(
        size.width * 0.7, size.height * 0.6,
        size.width * 0.4, size.height * 0.8,
        size.width * 0.4, size.height * 0.9);

    // Draw dashed path
    double distance = 0;
    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double length = distance + dashWidth < pathMetric.length ? dashWidth : pathMetric.length - distance;
        canvas.drawPath(pathMetric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }

    // Draw landmarks
    final landmarkPaint = Paint()
      ..color = const Color(0xFF444650)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.1), 6, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 6, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.9), 6, landmarkPaint);

    // Draw Pulse Circle at current location (roughly 40% through the path)
    final currentOffset = path.computeMetrics().first.getTangentForOffset(path.computeMetrics().first.length * 0.4)?.position ?? Offset(size.width * 0.5, size.height * 0.4);
    
    final pulsePaint = Paint()
      ..color = const Color(0xFF00DDDD).withOpacity(1 - pulseAnimation)
      ..style = PaintingStyle.fill;
      
    final corePaint = Paint()
      ..color = const Color(0xFF00DDDD)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(currentOffset, 8 + (16 * pulseAnimation), pulsePaint);
    canvas.drawCircle(currentOffset, 8, corePaint);
  }

  @override
  bool shouldRepaint(covariant MapRoutePainter oldDelegate) {
    return oldDelegate.pulseAnimation != pulseAnimation;
  }
}
