import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'seat_selection.dart';

class BusDiscoveryScreen extends StatefulWidget {
  const BusDiscoveryScreen({Key? key}) : super(key: key);

  @override
  _BusDiscoveryScreenState createState() => _BusDiscoveryScreenState();
}

class _BusDiscoveryScreenState extends State<BusDiscoveryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121318), // background
      extendBodyBehindAppBar: true,
      extendBody: true,
      drawer: _buildDrawer(context),
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
          
          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 16, // Top app bar height + margin is handled by padding
                bottom: 120, // space for bottom nav bar and FAB
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 16),
                  _buildSortTabs(),
                  const SizedBox(height: 24),
                  _buildBusCards(context),
                ],
              ),
            ),
          ),
          
          // Top App Bar
          _buildTopAppBar(context),
          
          // Bottom Nav Bar
          _buildBottomNavBar(context),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Above bottom nav
        child: FloatingActionButton(
          onPressed: () => _showFilterBottomSheet(context),
          backgroundColor: const Color(0xFFFFDB3C), // secondary-container
          child: const Icon(Icons.tune, color: Color(0xFF725F00)), // on-secondary-container
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
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
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF002366),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAxuM8pYrQlJnZYHgjmjPKzXBQmhhgZQH30G8f-Mf0L8zQbc0lCaEEh_YFBa0zwt-OvxxkR6nBMjZhvuQTd4x3BQTU7T3qVTfnpFwX4Gy41Ld6A_EqERJgLP1XMppnKU9ieyZXQOBWIl7bcO_lU828smeuxJyQcViZR66mH0G0xPJRfwJUqzMwLrP2kObeRzCt1P8a7egW5ytdYakLdbZnsipJlLPA-wN9OnODMPx3s2fwerIIQxz8XhlAn791bkUK0jEHZpoLooK1x',
                            fit: BoxFit.cover,
                          ),
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
                IconButton(
                  icon: const Icon(Icons.notifications, color: Color(0xFFB3C5FF)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 80), // To clear app bar
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kolkata to Durgapur',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFF9EF), // secondary
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '24 Oct • 12 Buses Available',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFC5C6D2), // on-surface-variant
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PREMIUM ACCESS',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFDB3C), // secondary-container
                  letterSpacing: 0.96,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 4,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDB3C),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildSortTab(label: 'CHEAPEST FIRST', isActive: true),
          const SizedBox(width: 12),
          _buildSortTab(label: 'FASTEST', isActive: false),
          const SizedBox(width: 12),
          _buildSortTab(label: 'TOP RATED', isActive: false),
          const SizedBox(width: 12),
          _buildSortTab(label: 'EARLIEST', isActive: false),
        ],
      ),
    );
  }

  Widget _buildSortTab({required String label, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF002E2E).withOpacity(0.4) : Colors.white.withOpacity(0.05),
        border: Border.all(color: isActive ? const Color(0xFF00DDDD) : Colors.white.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isActive ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2),
          letterSpacing: 0.96,
        ),
      ),
    );
  }

  Widget _buildBusCards(BuildContext context) {
    return Column(
      children: [
        _buildBusCard(
          context: context,
          isPremium: true,
          classTitle: 'GOLD CLASS • VOLVO 9600',
          busName: 'SBSTC Royal Cruiser',
          rating: '4.9',
          departureTime: '06:30',
          departurePlace: 'ESPLANADE',
          duration: '3h 15m',
          arrivalTime: '09:45',
          arrivalPlace: 'CITY CENTRE',
          amenities: ['A/C SLEEPER', 'CHARGING POINT', 'WATER BOTTLE'],
          seatsLeft: '12 Available',
          isSeatsLow: false,
          oldPrice: '₹850',
          price: '₹720',
        ),
        const SizedBox(height: 12),
        _buildBusCard(
          context: context,
          isPremium: false,
          classTitle: 'PLATINUM • SCANIA METROLINK',
          busName: 'Express Executive',
          rating: '4.7',
          departureTime: '08:00',
          departurePlace: 'KARUNAMOYEE',
          duration: '3h 30m',
          arrivalTime: '11:30',
          arrivalPlace: 'MUCHIPARA',
          amenities: [],
          seatsLeft: '2 Left',
          isSeatsLow: true,
          oldPrice: '',
          price: '₹650',
        ),
        const SizedBox(height: 12),
        _buildBusCard(
          context: context,
          isPremium: false,
          classTitle: 'ELITE • MERCEDES-BENZ',
          busName: 'SBSTC Midnight Star',
          rating: '4.8',
          departureTime: '22:45',
          departurePlace: 'HOWRAH',
          duration: '3h 00m',
          arrivalTime: '01:45',
          arrivalPlace: 'DURGAPUR STN',
          amenities: [],
          seatsLeft: '22 Available',
          isSeatsLow: false,
          oldPrice: '',
          price: '₹890',
        ),
      ],
    );
  }

  Widget _buildBusCard({
    required BuildContext context,
    required bool isPremium,
    required String classTitle,
    required String busName,
    required String rating,
    required String departureTime,
    required String departurePlace,
    required String duration,
    required String arrivalTime,
    required String arrivalPlace,
    required List<String> amenities,
    required String seatsLeft,
    required bool isSeatsLow,
    required String oldPrice,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: BorderSide(
            color: isPremium ? const Color(0xFFFFDB3C) : Colors.white.withOpacity(0.15),
            width: isPremium ? 4 : 1,
          ),
          right: BorderSide(color: Colors.white.withOpacity(0.15)),
          bottom: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.37),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classTitle,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isPremium ? const Color(0xFFFFDB3C) : const Color(0xFFC5C6D2),
                                letterSpacing: 0.96,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              busName,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFE3E2E8),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFDB3C), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating,
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
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Timeline
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              departureTime,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              departurePlace,
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
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
                                Text(
                                  duration,
                                  style: GoogleFonts.manrope(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00DDDD),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.directions_bus, color: Color(0xFF00DDDD), size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              arrivalTime,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            Text(
                              arrivalPlace,
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
                    const SizedBox(height: 24),
                    
                    if (amenities.isNotEmpty) ...[
                      Row(
                        children: amenities.map((amenity) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: Text(
                              amenity,
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFC5C6D2),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Footer Row
                    Container(
                      padding: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SEATS LEFT',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFC5C6D2),
                                  letterSpacing: 0.96,
                                ),
                              ),
                              Text(
                                seatsLeft,
                                style: GoogleFonts.manrope(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSeatsLow ? const Color(0xFFFFB4AB) : const Color(0xFF00DDDD), // error or tertiary
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (oldPrice.isNotEmpty)
                                Text(
                                  oldPrice,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFC5C6D2),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'FROM ',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFFDB3C), // secondary-container
                                      letterSpacing: 0.96,
                                    ),
                                  ),
                                  Text(
                                    price,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Select Seats Button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SeatSelectionScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: isPremium ? const LinearGradient(
                        colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ) : null,
                      color: isPremium ? null : Colors.white.withOpacity(0.1),
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                      boxShadow: isPremium ? [
                        BoxShadow(
                          color: const Color(0xFF00DDDD).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Center(
                      child: Text(
                        'SELECT SEATS',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isPremium ? const Color(0xFF0D2C6E) : Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121318).withOpacity(0.95), // surface-dim / 95
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF002366),
                          border: Border.all(color: const Color(0xFFFFDB3C), width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDgVheeBQEeOVO_WHA_EIrX8Rxd1rzvZe7F91JU2bKUv159bWEbbXb83pBv3ntNosw0cdipwrWwV6b9_a2oNF_8fnH9tVbDTDT4Sr-cyEYJl6KY1uhJoFNC507HhQXk5AB0uKFN5-5NUnuKKIaMaSER21j1ow5Gl2EalChrsxCay2yCF-HQz6rkT_OutpVh5ZDtbL0s3wd5ze1ozYsdxxmOXfmSdC46tcEbG7mOQPKjIhy-LhCpHjCYltxE1X_ky2UKycZf1NHIOGTF',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Morgan',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'GOLD MEMBER • 2,450 pts',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFDB3C),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildDrawerItem(icon: Icons.king_bed, title: 'Premium Lounge', isHighlighted: true),
                  _buildDrawerItem(icon: Icons.verified_user, title: 'Travel Insurance'),
                  _buildDrawerItem(icon: Icons.military_tech, title: 'Loyalty Rewards'),
                  _buildDrawerItem(icon: Icons.support_agent, title: 'Support'),
                  _buildDrawerItem(icon: Icons.settings, title: 'Settings'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.white.withOpacity(0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isHighlighted ? const Color(0xFFFFDB3C) : const Color(0xFFC5C6D2),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                    color: isHighlighted ? const Color(0xFFFFDB3C) : const Color(0xFFC5C6D2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF343439), // surface-container-highest
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.2))),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.only(bottom: 32),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Advanced Filters',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'RESET ALL',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00DDDD),
                        letterSpacing: 0.96,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Price Range
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRICE RANGE',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC5C6D2),
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RangeSlider(
                    values: const RangeValues(400, 1200),
                    min: 0,
                    max: 2000,
                    activeColor: const Color(0xFF00DDDD),
                    inactiveColor: Colors.white.withOpacity(0.1),
                    onChanged: (values) {},
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹400', style: GoogleFonts.manrope(fontSize: 14, color: Colors.white)),
                      Text('₹1200', style: GoogleFonts.manrope(fontSize: 14, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Bus Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BUS TYPE',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC5C6D2),
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildFilterChip(label: 'SLEEPER', isSelected: true),
                      const SizedBox(width: 8),
                      _buildFilterChip(label: 'SEATER', isSelected: false),
                      const SizedBox(width: 8),
                      _buildFilterChip(label: 'NON A/C', isSelected: false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00DDDD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'SHOW 12 BUSES',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF003737), // on-tertiary
                      letterSpacing: 0.96,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF00DDDD) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: isSelected ? const Color(0xFF003737) : Colors.white,
          letterSpacing: 0.96,
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
                _buildNavItem(icon: Icons.home, label: 'Home', isActive: false),
                _buildNavItem(icon: Icons.confirmation_number, label: 'Bookings', isActive: false),
                _buildNavItem(icon: Icons.explore, label: 'Live', isActive: true),
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
