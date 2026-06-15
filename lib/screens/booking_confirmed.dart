import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'home_dashboard.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Read the most recent booking dynamically
    final booking = BookingManager.bookings.isNotEmpty
        ? BookingManager.bookings.first
        : {
            'pnr': 'PR-992841',
            'from': 'Kolkata',
            'to': 'Durgapur',
            'date': '24 Oct 2026',
            'departureTime': '08:30 AM',
            'arrivalTime': '11:45 AM',
            'duration': '3h 15m',
            'busName': 'Volvo 9600 Gold Class',
            'seat': 'Lower Deck, 04A',
            'price': '₹850.00',
            'status': 'Confirmed',
          };

    final routeText = "${booking['from']} → ${booking['to']}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _buildSuccessHeader(),
              const SizedBox(height: 28),

              // Dynamic Ticket Card (Optimized: No BackdropFilter!)
              _buildTicketCard(context, booking, routeText),
              const SizedBox(height: 28),

              // CTA Action Grid
              _buildActionGrid(context),
              const SizedBox(height: 24),

              // Secondary View History Link
              _buildSecondaryAction(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
          ),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.tertiary,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Booking Confirmed',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Your premium bus travel is secured. Have a safe flight!',
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTicketCard(BuildContext context, Map<String, dynamic> booking, String route) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ticket Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BOOKING ID / PNR',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['pnr'] ?? 'PR-000000',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    'CONFIRMED',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Journey Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEPARTURE',
                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['departureTime'] ?? '08:30',
                          style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        Text(
                          booking['from'] ?? 'Kolkata',
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward, color: AppColors.primaryLight),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ARRIVAL',
                          style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['arrivalTime'] ?? '11:45',
                          style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        Text(
                          booking['to'] ?? 'Durgapur',
                          style: GoogleFonts.manrope(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.outline),
                const SizedBox(height: 12),

                // Seat & Date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATE OF JOURNEY',
                          style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['date'] ?? '24 Oct 2026',
                          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'SEAT(S)',
                          style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          booking['seat'] ?? '04A',
                          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // QR Code visual
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 140,
                        height: 140,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.qr_code_2,
                          size: 130,
                          color: Color(0xFF0F1015),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SCAN AT BOARDING GATE',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Ticket Card Footer (Perforated Style)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.wifi, color: AppColors.textSecondary, size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.restaurant, color: AppColors.textSecondary, size: 16),
                    SizedBox(width: 8),
                    Icon(Icons.bolt, color: AppColors.textSecondary, size: 16),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL FARE PAID',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      booking['price'] ?? '₹1,240.00',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return Row(
      children: [
        // Track Bus CTA
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () {
                // Navigate back to Home shell on tab index 2 (Live Tracking)
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeDashboard(initialTab: 2)),
                  (route) => false,
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Track Bus',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Share Ticket
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.outline),
            ),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surface,
                    content: Text(
                      'Ticket shared successfully!',
                      style: GoogleFonts.manrope(color: Colors.white),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Share Pass',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Widget _buildSecondaryAction(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate back to Home shell on tab index 1 (Bookings history)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeDashboard(initialTab: 1)),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 2),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.textSecondary, width: 1)),
        ),
        child: Text(
          'GO TO TRIP HISTORY',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
