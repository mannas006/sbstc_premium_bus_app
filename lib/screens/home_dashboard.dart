import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bus_discovery.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatYAnimation;
  late Animation<double> _floatScaleAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121318), // surface
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Cinematic Background
          _buildCinematicBackground(context),
          
          // Main Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 80,
              bottom: 120, // space for bottom nav bar
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(context),
                const SizedBox(height: 32),
                _buildRecommendations(),
                const SizedBox(height: 32),
                _buildPopularRoutes(),
              ],
            ),
          ),
          
          // Top App Bar
          _buildTopAppBar(context),
          
          // Bottom Nav Bar
          _buildBottomNavBar(context),
        ],
      ),
    );
  }

  Widget _buildCinematicBackground(BuildContext context) {
    return Stack(
      children: [
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
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB3C5FF).withOpacity(0.1),
              boxShadow: [
                BoxShadow(color: const Color(0xFFB3C5FF).withOpacity(0.1), blurRadius: 120, spreadRadius: 120),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF002E2E).withOpacity(0.2),
              boxShadow: [
                BoxShadow(color: const Color(0xFF002E2E).withOpacity(0.2), blurRadius: 120, spreadRadius: 120),
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
                    ClipOval(
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SBSTC',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB3C5FF),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Color(0xFFC5C6D2)),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF002366),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDZmDhOCXgKKJTe_nAGtX1qF5Bo4Get-l1IPo4cz9CtRhqA4z2ErgxQ27cVtSNDVpb7uZOMsw84i1rt8Mvj_ETLiQAF2uyvo-Q0uVp2PeGxvURHnDv60es6PCYLemzRkrD59bb1c-82RzlxwICzIssY2xDsYHjHcQH4dcdBNTWQZKDg_Ov8YD7aa_P73uDdLePQsp1OnKahlvkHwiHa5uS2nLE6tJvW_EZXGtuEDkoaSECXy0HJpt4rYCGXS4OrK965Nai6T7vA7tyE',
                          fit: BoxFit.cover,
                        ),
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

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where to next?',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFFF9EF), // secondary
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Book your first-class travel experience.',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFC5C6D2), // on-surface-variant
          ),
        ),
        const SizedBox(height: 24),
        
        // Glass Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Column(
                children: [
                  // From/To
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Column(
                        children: [
                          _buildInputRow(
                            icon: Icons.location_on,
                            label: 'FROM',
                            value: 'Kolkata City',
                          ),
                          const SizedBox(height: 12),
                          _buildInputRow(
                            icon: Icons.navigation,
                            label: 'TO',
                            value: 'Digha Premium',
                          ),
                        ],
                      ),
                      Positioned(
                        right: 32,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF002E2E), // tertiary-container
                            border: Border.all(color: const Color(0xFF00DDDD).withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.swap_vert, color: Color(0xFF00DDDD), size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Date & Passengers
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputRow(
                          icon: Icons.calendar_month,
                          label: 'DATE',
                          value: 'Oct 24, 2023',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputRow(
                          icon: Icons.person,
                          label: 'TRAVELLERS',
                          value: '01 Person',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Search Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.3))),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00DDDD).withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BusDiscoveryScreen()),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Search Routes',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0E12).withOpacity(0.5), // surface-container-lowest/50
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00DDDD), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE9C400), // secondary-fixed-dim
                    letterSpacing: 0.96,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFE3E2E8), // on-surface
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF00DDDD)),
                const SizedBox(width: 8),
                Text(
                  'AI Picks For You',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E2E8),
                  ),
                ),
              ],
            ),
            Text(
              'REFRESH',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF00DDDD),
                letterSpacing: 0.96,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildRecommendationCard(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBOEnuJqmKv2v5KhHRPeZK-jelZynMOffsuroA9IQuynivmFJZAe8TovZcTNOedZoV-EV4220SphH17I66wcq_07t_o1VGveDNugBWL-_9JRaTYfvnh6k7iLDP65SGai6SgWWLSl86VP5z4VN1rUH4MbyGfOcBsIDq8rPXPd8znnzAFsn-DVYcqZX-Tz1fDsN24VA2vwyqLgXtC1lUn7j9D3to91D5LDSYii1vmo_Z4dB2Da3Q4vQ12kayzSbC-tdZYSGVsIoiz3tCb',
                title: 'Weekend in Darjeeling',
                subtitle: 'Based on your last trip',
                badgeText: 'PREMIUM+',
                badgeColor: const Color(0xFF002E2E), // tertiary-container
                badgeTextColor: const Color(0xFF00DDDD), // tertiary
                icon: Icons.stars,
                matchText: '98% Match',
              ),
              const SizedBox(width: 16),
              _buildRecommendationCard(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjoWpAdeK6VVkXe10Oa96tuEHiyTowF_wkdxQrFHNh3M-XJ3aYAs1v3_zDw5Ik3hkmedZqrdTojwtnhxOOiV8DjXfWGqaC9xAHvk2N7ezByo5XTp8zBwg89vpzDYHa5AGth3o6yuOR1s66TqdqNMzd65_yYtU_1ZaibmfC88nRgSJ2f62gPChn7PjJ-mO4kdaT94dM39CBDd4145EYgWKKzue_2JkRgYV_4EcyTLNSsByy5KGodeU2SUZnFmfKpLm1C1cudYKntQxi',
                title: 'Digha Ocean View',
                subtitle: 'Popular this week',
                badgeText: 'FAST TRACK',
                badgeColor: const Color(0xFF002366), // primary-container
                badgeTextColor: const Color(0xFFB3C5FF), // primary
                icon: Icons.trending_up,
                matchText: 'High Demand',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required IconData icon,
    required String matchText,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFF9EF),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFC5C6D2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(icon, color: const Color(0xFF00DDDD), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          matchText,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00DDDD),
                            letterSpacing: 0.96,
                            shadows: [
                              Shadow(
                                color: const Color(0xFF00DDDD).withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Routes',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE3E2E8),
          ),
        ),
        const SizedBox(height: 16),
        _buildRouteCard(
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuByKW9PBn5yS24kotuGUebh010vLaU4YooFdbz-Ba0c77ZuYfg3HnQZ5aCYwnO83tFCa_E30M3MTDPrBnuvDKOtqjbTgaQJl2IVKzPmfHAierOaZN-g8Ahd8xKZDwOQ8Y-kIDUPugnsbd7kBgMN5h26-hY-MO84oeHLN3xigd2KL_GCaNc4o4F7koX-O0Gi0K2NkZMWLMuHyJcQ96u4e1k_sh7gyBOlqOoh5yWZgjOf_9zpRK8jVQr2aJgJva-OKP-71-VUANf4FnF2',
          route: 'KOLKATA → PURI',
          details: '8.5 hrs • Starting from ₹1,250',
        ),
        const SizedBox(height: 12),
        _buildRouteCard(
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQ1mgph7XN9D_0HHAoOSpNMrzetFhVy_alhbsczaQC-zuUP2s5Yhup8QNR8I3NiQotPsfKT-9RAZX1dzUna8Ibt1f1qsa3PyYEWKyqFkFWRdPVFkRDkmnzOA-9q8e_G4TqP0EH0oIm_MRvYbbyCfNlbLphchKWfi82fL8uWe-B7n6OAdy7VBg0Rz43y4qQzEcWRju2UQOfY-pyVirVUFMCDeHI1hwSYMGuw0483rv4rH4f7GdwGMzKXs5ebGe6gJSN5gORFCjgTxRM',
          route: 'KOLKATA → SILIGURI',
          details: '12 hrs • Starting from ₹2,400',
        ),
      ],
    );
  }

  Widget _buildRouteCard({required String imageUrl, required String route, required String details}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF343439), // surface-container-highest
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE9C400),
                          letterSpacing: 0.96,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details,
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
              const Icon(Icons.chevron_right, color: Color(0xFFC5C6D2)),
            ],
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
                _buildNavItem(icon: Icons.home, label: 'Home', isActive: true),
                _buildNavItem(icon: Icons.confirmation_number, label: 'Bookings', isActive: false),
                _buildNavItem(icon: Icons.explore, label: 'Live', isActive: false),
                _buildNavItem(icon: Icons.person, label: 'Profile', isActive: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required bool isActive}) {
    return Column(
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
    );
  }
}
