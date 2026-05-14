import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'live_tracking.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pingController;
  late Animation<double> _pingAnimation;
  bool _isUpcomingTab = true;

  @override
  void initState() {
    super.initState();
    _pingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _pingController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _pingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121318), // background
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradient & Blur Elements
          _buildBackground(),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 120, // Space for Bottom Nav
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64), // App bar clearance
                  _buildBookingTabs(),
                  const SizedBox(height: 24),
                  _buildCurrentJourney(),
                  const SizedBox(height: 32),
                  _buildUpcomingTimeline(),
                  const SizedBox(height: 32),
                  _buildStatsGrid(),
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

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(color: const Color(0xFF121318)),
        ),
        // Top right blur
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF002366).withOpacity(0.2), // primary-container/20
              boxShadow: [
                BoxShadow(color: const Color(0xFF002366).withOpacity(0.2), blurRadius: 120),
              ],
            ),
          ),
        ),
        // Bottom left blur
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF002E2E).withOpacity(0.2), // tertiary-container/20
              boxShadow: [
                BoxShadow(color: const Color(0xFF002E2E).withOpacity(0.2), blurRadius: 120),
              ],
            ),
          ),
        ),
      ],
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
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCuzsyiotE17aVbabn2Q2Saf_o6FhDaLG5pGZ69yFaEBXD1cNnE7EWLbWl01WUecs3v_38wxy1R6oDF2-tgKWzUSxBPoqpOnPqskZUcTsSGk2HOwgBpj4ClzpA_IdBN2qr_6tOxxtE3mceBBybPnNSeafX978ATQgdh6zpyoqxvJZHk89B_ySSZsI3esUMB_duwjSre3oVFd7KVMOa76pRNyHZx0e2PUgoC0v15DauTPRugIByiY4JEwSX-r3gQfY7akgVtZrPyBI5g',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'My Bookings',
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

  Widget _buildBookingTabs() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1F24), // surface-container
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() => _isUpcomingTab = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: _isUpcomingTab ? const Color(0xFF002366) : Colors.transparent, // primary-container
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'Upcoming',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _isUpcomingTab ? const Color(0xFFB3C5FF) : const Color(0xFFC5C6D2),
                    letterSpacing: 0.96,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isUpcomingTab = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: !_isUpcomingTab ? const Color(0xFF002366) : Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'History',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: !_isUpcomingTab ? const Color(0xFFB3C5FF) : const Color(0xFFC5C6D2),
                    letterSpacing: 0.96,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentJourney() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CURRENT JOURNEY',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF00DDDD), // tertiary
                letterSpacing: 0.96,
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                  height: 8,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _pingAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 1.0 - _pingAnimation.value,
                            child: Transform.scale(
                              scale: 1.0 + (_pingAnimation.value * 2),
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00DDDD),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00DDDD),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Live',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC5C6D2),
                    letterSpacing: 0.96,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.1)),
              right: BorderSide(color: Colors.white.withOpacity(0.1)),
              bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              left: const BorderSide(color: Color(0xFF00DDDD), width: 4), // border-l-4 border-tertiary
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.15),
                spreadRadius: -1,
                blurRadius: 1, // inner-glow simulation
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BOARDING PASS',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFC5C6D2),
                                    letterSpacing: 0.96,
                                  ),
                                ),
                                Text(
                                  'LX-204',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFB3C5FF),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'PREMIUM GOLD',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFDB3C), // secondary-container
                                letterSpacing: 0.96,
                              ),
                            ),
                            Text(
                              'Seat 12A',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: const Color(0xFFE3E2E8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CCU',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE3E2E8),
                              ),
                            ),
                            Text(
                              'Kolkata',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: const Color(0xFFC5C6D2),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: List.generate(
                                            (constraints.constrainWidth() / 8).floor(),
                                            (index) => SizedBox(
                                              width: 4,
                                              height: 1,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const Positioned(
                                      top: -12,
                                      child: Icon(Icons.directions_bus, color: Color(0xFF00DDDD)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '2H 45M',
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
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'DGP',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE3E2E8),
                              ),
                            ),
                            Text(
                              'Durgapur',
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                color: const Color(0xFFC5C6D2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LiveTrackingScreen()),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.map, color: Color(0xFFE3E2E8), size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Track Bus',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFE3E2E8),
                                          letterSpacing: 0.96,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00DDDD).withOpacity(0.3),
                                    blurRadius: 15,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.qr_code, color: Color(0xFF0D2C6E), size: 18), // on-primary
                                      const SizedBox(width: 8),
                                      Text(
                                        'E-Ticket',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0D2C6E),
                                          letterSpacing: 0.96,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UPCOMING JOURNEYS',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFC5C6D2),
            letterSpacing: 0.96,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Vertical Line
              Positioned(
                left: 0,
                top: 8,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00DDDD), Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  _buildTimelineItem(
                    date: 'OCT 24, 09:00 AM',
                    route: 'Kolkata → Asansol',
                    status: 'Confirmed • Bus SB-501',
                    isActive: true,
                    hasInvoice: true,
                  ),
                  const SizedBox(height: 24),
                  _buildTimelineItem(
                    date: 'NOV 02, 14:30 PM',
                    route: 'Durgapur → Kolkata',
                    status: 'Processing • Bus SB-202',
                    isActive: false,
                    hasInvoice: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String route,
    required String status,
    required bool isActive,
    required bool hasInvoice,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Dot marker
        Positioned(
          left: -11,
          top: 6,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF121318),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? const Color(0xFFB3C5FF) : Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFB3C5FF) : Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        // Card Content
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Opacity(
            opacity: isActive ? 1.0 : 0.7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    spreadRadius: -1,
                    blurRadius: 1, // inner-glow
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isActive ? const Color(0xFFB3C5FF) : const Color(0xFFC5C6D2),
                                letterSpacing: 0.96,
                              ),
                            ),
                            const Icon(Icons.expand_more, color: Color(0xFFC5C6D2), size: 20),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  route,
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  status,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    color: const Color(0xFFC5C6D2),
                                  ),
                                ),
                              ],
                            ),
                            if (hasInvoice)
                              Column(
                                children: [
                                  const Icon(Icons.download, color: Color(0xFFB3C5FF), size: 20),
                                  const SizedBox(height: 4),
                                  Text(
                                    'INVOICE',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFC5C6D2),
                                      letterSpacing: 0.96,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            iconColor: const Color(0xFF00DDDD), // tertiary
            label: 'LOYALTY PTS',
            value: '2,450',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            icon: Icons.timeline,
            iconColor: const Color(0xFFFFDB3C), // secondary-container
            label: 'TOTAL KMS',
            value: '1,240',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            spreadRadius: -1,
            blurRadius: 1, // inner-glow
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC5C6D2),
                    letterSpacing: 0.96,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E2E8),
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
                _buildNavItem(context, icon: Icons.confirmation_number, label: 'Bookings', isActive: true, route: null),
                _buildNavItem(context, icon: Icons.explore, label: 'Live', isActive: false, route: null),
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
