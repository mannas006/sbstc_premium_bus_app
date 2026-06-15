import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'bus_discovery.dart';
import 'trip_history.dart';
import 'live_tracking.dart';

class HomeDashboard extends StatefulWidget {
  final int initialTab;
  const HomeDashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  void _selectTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Body based on tab
          Positioned.fill(
            child: _buildBody(),
          ),

          // Global Bottom Navigation Bar
          _buildBottomNavBar(context),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentTab) {
      case 0:
        return const HomeSearchView();
      case 1:
        return const TripHistoryView(showBackButton: false);
      case 2:
        return const LiveTrackingView(showBackButton: false);
      case 3:
        return const ProfileView();
      default:
        return const HomeSearchView();
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
            _buildNavItem(icon: Icons.confirmation_number, label: 'Bookings', index: 1),
            _buildNavItem(icon: Icons.explore, label: 'Live', index: 2),
            _buildNavItem(icon: Icons.person, label: 'Profile', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => _selectTab(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.primaryLight : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// TAB 0: HOME SEARCH VIEW
// -------------------------------------------------------------
class HomeSearchView extends StatefulWidget {
  const HomeSearchView({Key? key}) : super(key: key);

  @override
  _HomeSearchViewState createState() => _HomeSearchViewState();
}

class _HomeSearchViewState extends State<HomeSearchView> {
  final List<String> _cities = ['Kolkata', 'Durgapur', 'Digha', 'Puri', 'Siliguri', 'Asansol'];

  void _swapCities() {
    setState(() {
      final temp = BookingManager.fromCity;
      BookingManager.fromCity = BookingManager.toCity;
      BookingManager.toCity = temp;
    });
  }

  void _showCityPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFrom ? 'Select Departure City' : 'Select Destination City',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cities.length,
                  itemBuilder: (context, index) {
                    final city = _cities[index];
                    // Don't show the same city in destination if selected in departure
                    if (isFrom && city == BookingManager.toCity) return const SizedBox();
                    if (!isFrom && city == BookingManager.fromCity) return const SizedBox();

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        city,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onTap: () {
                        setState(() {
                          if (isFrom) {
                            BookingManager.fromCity = city;
                          } else {
                            BookingManager.toCity = city;
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: BookingManager.departureDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        BookingManager.departureDate = picked;
      });
    }
  }

  void _showTravellerDialog() {
    int localCount = BookingManager.travellersCount;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Select Travellers',
                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Number of Seats',
                    style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.primaryLight),
                        onPressed: localCount > 1
                            ? () {
                                setDialogState(() => localCount--);
                              }
                            : null,
                      ),
                      Text(
                        '$localCount',
                        style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryLight),
                        onPressed: localCount < 6
                            ? () {
                                setDialogState(() => localCount++);
                              }
                            : null,
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL', style: GoogleFonts.manrope(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      BookingManager.travellersCount = localCount;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('APPLY', style: GoogleFonts.manrope(color: AppColors.primaryLight, fontWeight: FontWeight.w700)),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // String formats for UI
    final String dateString = "${BookingManager.departureDate.day} ${_getMonthName(BookingManager.departureDate.month)} ${BookingManager.departureDate.year}";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 120,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero RedBus Style Branding Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SBSTC Premium',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Where to next?',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.outline),
                ),
                child: const Icon(Icons.notifications_none, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 24),

          // Search Form Card (Optimized: No BackdropFilter!)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Swap Location Stack
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        _buildSearchInputRow(
                          icon: Icons.location_on,
                          label: 'FROM',
                          value: BookingManager.fromCity,
                          onTap: () => _showCityPicker(true),
                        ),
                        const SizedBox(height: 12),
                        _buildSearchInputRow(
                          icon: Icons.navigation,
                          label: 'TO',
                          value: BookingManager.toCity,
                          onTap: () => _showCityPicker(false),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 16,
                      child: GestureDetector(
                        onTap: _swapCities,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: const Icon(Icons.swap_vert, color: AppColors.primaryLight, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Date & Travellers Row
                Row(
                  children: [
                    Expanded(
                      child: _buildSearchInputRow(
                        icon: Icons.calendar_month,
                        label: 'DATE',
                        value: dateString,
                        onTap: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildSearchInputRow(
                        icon: Icons.person,
                        label: 'TRAVELLERS',
                        value: "${BookingManager.travellersCount} Seat(s)",
                        onTap: _showTravellerDialog,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search button
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BusDiscoveryScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFEF5350)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Search Routes',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.search, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // AI Picks Recommendations Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Promotions & Offers',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildOfferCard(
                  title: 'Weekend Cashback',
                  code: 'WEEKEND30',
                  desc: 'Get 30% cashback on weekend trips',
                  color: const Color(0xFF1B2C24),
                  accentColor: const Color(0xFF2EC4B6),
                ),
                const SizedBox(width: 16),
                _buildOfferCard(
                  title: 'New User Discount',
                  code: 'FIRSTCLASS',
                  desc: 'Save ₹150 on your first premium booking',
                  color: const Color(0xFF352028),
                  accentColor: AppColors.primaryLight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Popular Routes List
          Text(
            'Popular Routes',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          _buildPopularRouteCard(
            from: 'Kolkata',
            to: 'Durgapur',
            duration: '3.5 hrs',
            price: '₹720',
          ),
          const SizedBox(height: 12),
          _buildPopularRouteCard(
            from: 'Kolkata',
            to: 'Puri',
            duration: '8 hrs',
            price: '₹1,250',
          ),
          const SizedBox(height: 12),
          _buildPopularRouteCard(
            from: 'Kolkata',
            to: 'Siliguri',
            duration: '12 hrs',
            price: '₹2,400',
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInputRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String code,
    required String desc,
    required Color color,
    required Color accentColor,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  code,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRouteCard({
    required String from,
    required String to,
    required String duration,
    required String price,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          BookingManager.fromCity = from;
          BookingManager.toCity = to;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BusDiscoveryScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.directions_bus, color: AppColors.primaryLight, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$from → $to',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$duration • Premium Class',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'from ',
                  style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  price,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getMonthName(int monthNum) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (monthNum >= 1 && monthNum <= 12) {
      return months[monthNum - 1];
    }
    return '';
  }
}

// -------------------------------------------------------------
// TAB 3: PROFILE VIEW
// -------------------------------------------------------------
class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 120,
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Profile',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // User Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDZmDhOCXgKKJTe_nAGtX1qF5Bo4Get-l1IPo4cz9CtRhqA4z2ErgxQ27cVtSNDVpb7uZOMsw84i1rt8Mvj_ETLiQAF2uyvo-Q0uVp2PeGxvURHnDv60es6PCYLemzRkrD59bb1c-82RzlxwICzIssY2xDsYHjHcQH4dcdBNTWQZKDg_Ov8YD7aa_P73uDdLePQsp1OnKahlvkHwiHa5uS2nLE6tJvW_EZXGtuEDkoaSECXy0HJpt4rYCGXS4OrK965Nai6T7vA7tyE',
                      ),
                      fit: BoxFit.cover,
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'GOLD CLUB MEMBER • 2,450 pts',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu items
          _buildMenuItem(Icons.person_outline, 'Personal Information'),
          _buildMenuItem(Icons.payment, 'Saved Payment Methods'),
          _buildMenuItem(Icons.wallet, 'Wallet & Loyalty Rewards'),
          _buildMenuItem(Icons.support_agent, 'Customer Support Helpline', subtitle: 'Call 1800-SBSTC-HELP'),
          _buildMenuItem(Icons.settings, 'Application Settings'),
          const SizedBox(height: 24),

          // Log out button
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'LOG OUT',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryLight,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryLight),
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
        onTap: () {},
      ),
    );
  }
}
