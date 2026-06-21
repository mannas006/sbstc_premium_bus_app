import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
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
        return ProfileView(onLogout: () => _selectTab(0));
      default:
        return const HomeSearchView();
    }
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / 4;
          return Container(
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Stack(
                  children: [
                    // Sliding background pill
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      left: _currentTab * itemWidth,
                      top: 8,
                      bottom: 8,
                      width: itemWidth,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.12),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    // Items Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            activeIcon: Icons.home_rounded,
                            inactiveIcon: Icons.home_outlined,
                            label: 'Home',
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            activeIcon: Icons.confirmation_number_rounded,
                            inactiveIcon: Icons.confirmation_number_outlined,
                            label: 'Bookings',
                            index: 1,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            activeIcon: Icons.explore_rounded,
                            inactiveIcon: Icons.explore_outlined,
                            label: 'Live',
                            index: 2,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            activeIcon: Icons.person_rounded,
                            inactiveIcon: Icons.person_outline_rounded,
                            label: 'Profile',
                            index: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
    required int index,
  }) {
    bool isActive = _currentTab == index;
    return GestureDetector(
      onTap: () => _selectTab(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isActive ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            child: Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            child: Text(label),
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
                  color: AppColors.textPrimary,
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
            colorScheme: const ColorScheme.light(
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
                style: GoogleFonts.spaceGrotesk(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
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
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                        onPressed: localCount > 1
                            ? () {
                                setDialogState(() => localCount--);
                              }
                            : null,
                      ),
                      Text(
                        '$localCount',
                        style: GoogleFonts.spaceGrotesk(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
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
                  child: Text('APPLY', style: GoogleFonts.manrope(color: AppColors.primary, fontWeight: FontWeight.w700)),
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
                      color: AppColors.primary,
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
                child: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
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
                  color: Colors.black.withOpacity(0.04),
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
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: const Icon(Icons.swap_vert, color: AppColors.primary, size: 20),
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
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
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
                      color: AppColors.textPrimary,
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
                  color: const Color(0xFFEFF6FF),
                  accentColor: AppColors.primary,
                ),
                const SizedBox(width: 16),
                _buildOfferCard(
                  title: 'New User Discount',
                  code: 'FIRSTCLASS',
                  desc: 'Save ₹150 on your first premium booking',
                  color: const Color(0xFFFFF7ED),
                  accentColor: AppColors.secondary,
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
              color: AppColors.textPrimary,
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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

  void _showPromoDetailsSheet(String title, String code, String desc, Color accentColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isAlreadyApplied = BookingManager.appliedPromoCode == code;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: accentColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          code,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: accentColor,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'TERMS & CONDITIONS\n• Valid on all SBSTC Premium intercity routes.\n• Coupon must be applied before selecting checkout payments.\n• Minimum booking amount: ₹400.',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppColors.textSecondary.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isAlreadyApplied
                          ? null
                          : () {
                              setState(() {
                                BookingManager.appliedPromoCode = code;
                              });
                              setSheetState(() {
                                isAlreadyApplied = true;
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.tertiary,
                                  content: Text(
                                    'Promo code "$code" applied! Discount will be deducted at checkout.',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAlreadyApplied ? AppColors.outline : AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        isAlreadyApplied ? 'PROMO APPLIED' : 'APPLY PROMO CODE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOfferCard({
    required String title,
    required String code,
    required String desc,
    required Color color,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () => _showPromoDetailsSheet(title, code, desc, accentColor),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withOpacity(0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.15)),
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
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
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
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
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
                  child: const Icon(Icons.directions_bus, color: AppColors.primary, size: 18),
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
                        color: AppColors.textPrimary,
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
class ProfileView extends StatefulWidget {
  final VoidCallback onLogout;
  const ProfileView({Key? key, required this.onLogout}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Local Settings States
  bool _pushNotifications = true;
  bool _biometricLock = false;
  bool _whatsappUpdates = true;
  String _appLanguage = 'English';

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
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic User Info Profile Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        BookingManager.passengerName.isNotEmpty ? BookingManager.passengerName : 'Guest Traveler',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'GOLD CLUB MEMBER • ${BookingManager.loyaltyPoints} pts',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu items
          _buildMenuItem(Icons.person_outline, 'Personal Information', onTap: () => _showPersonalInformationSheet(context)),
          _buildMenuItem(Icons.payment, 'Saved Payment Methods', onTap: () => _showSavedPaymentsSheet(context)),
          _buildMenuItem(Icons.wallet, 'Wallet & Loyalty Rewards', onTap: () => _showWalletRewardsSheet(context)),
          _buildMenuItem(Icons.support_agent, 'Customer Support Helpline', subtitle: 'Call or chat live with agents', onTap: () => _showHelplineSupportSheet(context)),
          _buildMenuItem(Icons.settings, 'Application Settings', onTap: () => _showSettingsSheet(context)),
          const SizedBox(height: 24),

          // Log out button
          Center(
            child: TextButton(
              onPressed: () => _showLogoutDialog(context),
              child: Text(
                'LOG OUT',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.redAccent,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? subtitle, required VoidCallback onTap}) {
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
        onTap: onTap,
      ),
    );
  }

  // 1. Personal Information Sheet
  void _showPersonalInformationSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: BookingManager.passengerName);
    final ageCtrl = TextEditingController(text: BookingManager.passengerAge);
    final phoneCtrl = TextEditingController(text: BookingManager.passengerPhone);
    final emailCtrl = TextEditingController(text: BookingManager.passengerEmail);
    String? localGender = BookingManager.passengerGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Information',
                      style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Name Field
                TextFormField(
                  controller: nameCtrl,
                  style: GoogleFonts.manrope(color: Colors.white),
                  decoration: _sheetInputDecoration('Full Name', Icons.person_outline),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Age & Gender Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageCtrl,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.manrope(color: Colors.white),
                        decoration: _sheetInputDecoration('Age', Icons.cake_outlined),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: localGender,
                        dropdownColor: AppColors.surface,
                        style: GoogleFonts.manrope(color: Colors.white),
                        decoration: _sheetInputDecoration('Gender', Icons.wc),
                        items: ['Male', 'Female', 'Other'].map((String val) {
                          return DropdownMenuItem<String>(value: val, child: Text(val));
                        }).toList(),
                        onChanged: (v) => localGender = v,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Phone Field
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.manrope(color: Colors.white),
                  decoration: _sheetInputDecoration('Mobile Number', Icons.phone_android_outlined),
                  validator: (v) => v != null && v.length != 10 ? 'Enter 10-digit number' : null,
                ),
                const SizedBox(height: 12),

                // Email Field
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.manrope(color: Colors.white),
                  decoration: _sheetInputDecoration('Email Address', Icons.email_outlined),
                  validator: (v) => v != null && !v.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          BookingManager.passengerName = nameCtrl.text;
                          BookingManager.passengerAge = ageCtrl.text;
                          BookingManager.passengerPhone = phoneCtrl.text;
                          BookingManager.passengerEmail = emailCtrl.text;
                          BookingManager.passengerGender = localGender ?? 'Male';
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.tertiary,
                            content: Text(
                              'Profile updated successfully!',
                              style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('SAVE CHANGES', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  InputDecoration _sheetInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
      prefixIcon: Icon(icon, color: AppColors.primaryLight, size: 18),
      filled: true,
      fillColor: AppColors.background,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  // 2. Saved Payments Sheet
  void _showSavedPaymentsSheet(BuildContext context) {
    final cardCtrl = TextEditingController();
    final cardFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Cards',
                        style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Saved cards list
                  if (BookingManager.savedCards.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No saved cards available',
                          style: GoogleFonts.manrope(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: BookingManager.savedCards.length,
                      itemBuilder: (context, index) {
                        final card = BookingManager.savedCards[index];
                        final last4 = card.length >= 4 ? card.substring(card.length - 4) : card;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.credit_card, color: AppColors.primaryLight),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Visa ending in $last4',
                                    style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () {
                                  setSheetState(() {
                                    BookingManager.savedCards.removeAt(index);
                                  });
                                  setState(() {}); // refresh parent
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.outline),
                  const SizedBox(height: 16),

                  // Add Card form
                  Form(
                    key: cardFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ADD NEW CREDIT/DEBIT CARD',
                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: cardCtrl,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
                          decoration: _sheetInputDecoration('Card Number (16 Digits)', Icons.credit_card),
                          validator: (v) => v != null && v.trim().length != 16 ? 'Card must be 16 digits' : null,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              if (cardFormKey.currentState!.validate()) {
                                setSheetState(() {
                                  BookingManager.savedCards.add(cardCtrl.text.trim());
                                  cardCtrl.clear();
                                });
                                setState(() {}); // refresh parent
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.tertiary,
                                    content: Text(
                                      'Card added successfully!',
                                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text('ADD CARD', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 3. Wallet & Loyalty Rewards Sheet
  void _showWalletRewardsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wallet & Loyalty',
                        style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Wallet and Loyalty Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF1D4ED8)]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('WALLET BALANCE', style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text('₹${BookingManager.walletBalance.round()}', style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.outline,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('LOYALTY POINTS', style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text('${BookingManager.loyaltyPoints} pts', style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add Money Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quick Top-Up:',
                        style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [100, 500, 1000].map((amount) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: InkWell(
                              onTap: () {
                                setSheetState(() {
                                  BookingManager.walletBalance += amount;
                                  BookingManager.loyaltyPoints += (amount * 0.1).round(); // 10% points credit
                                });
                                setState(() {}); // refresh parent
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.tertiary,
                                    content: Text('Added ₹$amount to Wallet! Earned ${(amount * 0.1).round()} points.'),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  border: Border.all(color: AppColors.outline),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text('+₹$amount', style: GoogleFonts.spaceGrotesk(color: AppColors.primaryLight, fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'RECENT TRANSACTIONS',
                    style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildTxRow('₹150 Cashback - FIRSTCLASS Coupon', 'Credited', AppColors.tertiary),
                        _buildTxRow('+250 pts - Kolkata to Siliguri Booking', 'Earned', AppColors.secondary),
                        _buildTxRow('+120 pts - Durgapur to Kolkata Booking', 'Earned', AppColors.secondary),
                        _buildTxRow('₹200 - Cancelled Ticket Refund', 'Refunded', AppColors.tertiary),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTxRow(String desc, String status, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(desc, style: GoogleFonts.manrope(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
          ),
          Text(status, style: GoogleFonts.spaceGrotesk(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // 4. Customer Support Helpline & Live Chat Sheet
  void _showHelplineSupportSheet(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer Helpline',
                    style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Helpline number
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.phone, color: AppColors.primaryLight),
                ),
                title: Text('Call Toll-Free Helpline', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700)),
                subtitle: Text('1800-SBSTC-HELP (1800-72782-4357)', style: GoogleFonts.manrope(color: AppColors.textSecondary)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Simulating call to 1800-SBSTC-HELP...')),
                  );
                },
              ),
              const Divider(color: AppColors.outline),

              // Helpline email
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.email, color: AppColors.primaryLight),
                ),
                title: Text('Email Customer Support', style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700)),
                subtitle: Text('support@sbstcpremium.co.in', style: GoogleFonts.manrope(color: AppColors.textSecondary)),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email editor...')),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Live support chat button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close helpline sheet
                    _showSupportChat(context); // open chat dialog
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.forum, size: 18),
                      const SizedBox(width: 8),
                      Text('START LIVE SUPPORT CHAT', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Simulated Chat dialog/sheet
  void _showSupportChat(BuildContext context) {
    List<Map<String, String>> chatLog = [
      {'sender': 'bot', 'text': 'Hello! I am your SBSTC Virtual Assistant. How can I assist you today?'},
    ];

    bool isTyping = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setChatState) {
            void triggerBotResponse(String userMsg, String botMsg) {
              setChatState(() {
                chatLog.add({'sender': 'user', 'text': userMsg});
                isTyping = true;
              });

              Future.delayed(const Duration(seconds: 1), () {
                if (context.mounted) {
                  setChatState(() {
                    isTyping = false;
                    chatLog.add({'sender': 'bot', 'text': botMsg});
                  });
                }
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.chat_bubble, color: AppColors.primaryLight),
                          const SizedBox(width: 8),
                          Text('SBSTC Assistant', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.outline),
                  
                  // Message Log
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatLog.length + (isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chatLog.length && isTyping) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                              child: Text('Agent is typing...', style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 12)),
                            ),
                          );
                        }
                        
                        final msg = chatLog[index];
                        bool isBot = msg['sender'] == 'bot';
                        return Align(
                          alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isBot ? AppColors.background : AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                              border: isBot ? Border.all(color: AppColors.outline) : null,
                            ),
                            child: Text(
                              msg['text'] ?? '',
                              style: GoogleFonts.manrope(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Option suggestions
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.outline),
                  const SizedBox(height: 8),
                  Text('Quick Queries:', style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildQuickChatBtn(
                        label: 'Is my bus on time?',
                        onTap: () {
                          triggerBotResponse(
                            'Is my bus on time?',
                            'All SBSTC Premium buses are tracked in real-time. Navigate to the "Live" tab in your bottom menu to view active GPS schedules.',
                          );
                        },
                      ),
                      _buildQuickChatBtn(
                        label: 'How do I refund my wallet?',
                        onTap: () {
                          triggerBotResponse(
                            'How do I refund my wallet?',
                            'Loyalty wallet credits are credited instantly upon ticket cancellations. Go to settings or request cancellation on ticket screen.',
                          );
                        },
                      ),
                      _buildQuickChatBtn(
                        label: 'Can I change seats?',
                        onTap: () {
                          triggerBotResponse(
                            'Can I change seats?',
                            'Once a booking is completed, seat changes are restricted. You can cancel your current ticket and book a new one with full refund.',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickChatBtn({required String label, required VoidCallback onTap}) {
    return ActionChip(
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.outline),
      label: Text(label, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.primaryLight, fontWeight: FontWeight.w600)),
      onPressed: onTap,
    );
  }

  // 5. Application Settings Sheet
  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Application Settings',
                        style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: Text('Push Notifications', style: GoogleFonts.manrope(color: Colors.white, fontSize: 15)),
                    subtitle: Text('Receive tracking updates & booking alerts', style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11)),
                    activeColor: AppColors.primary,
                    value: _pushNotifications,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {
                      setSheetState(() => _pushNotifications = v);
                      setState(() {});
                    },
                  ),
                  const Divider(color: AppColors.outline),

                  SwitchListTile(
                    title: Text('Biometric Authentication', style: GoogleFonts.manrope(color: Colors.white, fontSize: 15)),
                    subtitle: Text('Secure checkout payments using Face ID / Fingerprint', style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11)),
                    activeColor: AppColors.primary,
                    value: _biometricLock,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {
                      setSheetState(() => _biometricLock = v);
                      setState(() {});
                    },
                  ),
                  const Divider(color: AppColors.outline),

                  SwitchListTile(
                    title: Text('WhatsApp Updates', style: GoogleFonts.manrope(color: Colors.white, fontSize: 15)),
                    subtitle: Text('Send boarding passes directly to WhatsApp', style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11)),
                    activeColor: AppColors.primary,
                    value: _whatsappUpdates,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {
                      setSheetState(() => _whatsappUpdates = v);
                      setState(() {});
                    },
                  ),
                  const Divider(color: AppColors.outline),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('App Language', style: GoogleFonts.manrope(color: Colors.white, fontSize: 15)),
                    trailing: DropdownButton<String>(
                      value: _appLanguage,
                      dropdownColor: AppColors.surface,
                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
                      items: ['English', 'Bengali', 'Hindi'].map((val) {
                        return DropdownMenuItem<String>(value: val, child: Text(val));
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setSheetState(() => _appLanguage = v);
                          setState(() {});
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 6. Log Out Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Confirm Log Out',
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to log out from SBSTC Premium?',
            style: GoogleFonts.manrope(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: GoogleFonts.manrope(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                // Clear user details
                BookingManager.passengerName = '';
                BookingManager.passengerAge = '';
                BookingManager.passengerPhone = '';
                BookingManager.passengerEmail = '';
                BookingManager.loyaltyPoints = 0;
                BookingManager.walletBalance = 0;
                BookingManager.savedCards = [];
                BookingManager.appliedPromoCode = '';

                Navigator.pop(context); // Close dialog
                widget.onLogout(); // Switch to home tab

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      'Logged out successfully!',
                      style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              },
              child: Text(
                'LOG OUT',
                style: GoogleFonts.manrope(color: Colors.redAccent, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }
}

