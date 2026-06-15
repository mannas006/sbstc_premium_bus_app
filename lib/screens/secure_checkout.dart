import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'booking_confirmed.dart';

class SecureCheckoutScreen extends StatefulWidget {
  const SecureCheckoutScreen({Key? key}) : super(key: key);

  @override
  _SecureCheckoutScreenState createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  String _selectedMethod = 'UPI';

  final TextEditingController _cardController = TextEditingController(text: '4242 4242 4242 4242');
  final TextEditingController _expiryController = TextEditingController(text: '12/28');
  final TextEditingController _cvvController = TextEditingController(text: '123');

  double _pricePerSeat = 720.0;
  String _busName = 'SBSTC Premium Coach';

  @override
  void initState() {
    super.initState();
    if (BookingManager.selectedBus != null) {
      _pricePerSeat = BookingManager.selectedBus!['price'];
      _busName = BookingManager.selectedBus!['name'];
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment(double totalPayable) {
    // Show a realistic payment processing loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                'Securing Transaction...',
                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Please do not press back or close the app.',
                style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    // Wait 2 seconds, add booking dynamically, and navigate to confirmation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Pop loading dialog

      // Add to BookingManager list
      final String formattedDate = "${BookingManager.departureDate.day} ${_getMonthName(BookingManager.departureDate.month)} ${BookingManager.departureDate.year}";
      final String depTime = BookingManager.selectedBus != null ? BookingManager.selectedBus!['departureTime'] : '08:30';
      final String arrTime = BookingManager.selectedBus != null ? BookingManager.selectedBus!['arrivalTime'] : '11:45';
      final String duration = BookingManager.selectedBus != null ? BookingManager.selectedBus!['duration'] : '3h 15m';

      BookingManager.addBooking(
        from: BookingManager.fromCity,
        to: BookingManager.toCity,
        date: formattedDate,
        departureTime: depTime,
        arrivalTime: arrTime,
        duration: duration,
        busName: _busName,
        seats: BookingManager.selectedSeats.join(', '),
        totalFare: totalPayable,
      );

      // Navigate to BookingConfirmedScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookingConfirmedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic price calculation
    int seatCount = BookingManager.selectedSeats.length;
    double baseFare = seatCount * _pricePerSeat;
    double amenityFee = seatCount * 120.0;
    double taxes = (baseFare + amenityFee) * 0.18; // 18% GST
    double discount = -50.0;
    double totalPayable = baseFare + amenityFee + taxes + discount;

    final String dateString = "${BookingManager.departureDate.day} ${_getMonthName(BookingManager.departureDate.month)}";
    final routeText = "${BookingManager.fromCity} to ${BookingManager.toCity}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Secure Checkout',
          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 160, // Space for footer CTA
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrustHeader(),
                const SizedBox(height: 16),

                // Dynamic Fare Card
                _buildFareCard(routeText, dateString, baseFare, amenityFee, taxes, discount, totalPayable),
                const SizedBox(height: 24),

                // Payment selector
                _buildPaymentSelection(),
              ],
            ),
          ),

          // Pay Now Bottom Bar
          _buildPayNowFooter(totalPayable),
        ],
      ),
    );
  }

  Widget _buildTrustHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user, color: AppColors.tertiary, size: 16),
        const SizedBox(width: 8),
        Text(
          'SECURE 256-BIT ENCRYPTED TRANSACTION',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFareCard(
    String route,
    String date,
    double base,
    double amenity,
    double taxes,
    double discount,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRIP SUMMARY',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryLight,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            route,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            '$date • $_busName • Seat(s): ${BookingManager.selectedSeats.join(', ')}',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.outline),
          const SizedBox(height: 12),

          _buildFareRow('Base Fare (${BookingManager.selectedSeats.length} seat(s))', '₹${base.round()}'),
          const SizedBox(height: 8),
          _buildFareRow('Premium Amenity Fee', '₹${amenity.round()}'),
          const SizedBox(height: 8),
          _buildFareRow('Taxes & GST (18%)', '₹${taxes.round()}'),
          const SizedBox(height: 8),
          _buildFareRow('Promotional Discount', '-₹${discount.abs().round()}', isDiscount: true),
          const SizedBox(height: 16),
          const Divider(color: AppColors.outline),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '₹${total.round()}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: isDiscount ? AppColors.tertiary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDiscount ? AppColors.tertiary : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT METHODS',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),

        // UPI Toggle
        _buildPaymentOption(
          id: 'UPI',
          icon: Icons.account_balance_wallet_outlined,
          title: 'UPI (GPay, PhonePe, BHIM)',
          desc: 'Instant checkout using secure UPI app',
        ),
        const SizedBox(height: 12),

        // Card Toggle
        _buildPaymentOption(
          id: 'CARD',
          icon: Icons.credit_card_outlined,
          title: 'Credit / Debit Card',
          desc: 'Visa, MasterCard, RuPay, Amex',
          expandChild: _selectedMethod == 'CARD' ? _buildCardForm() : null,
        ),
        const SizedBox(height: 12),

        // Net Banking
        _buildPaymentOption(
          id: 'NET',
          icon: Icons.account_balance_outlined,
          title: 'Net Banking',
          desc: 'All major Indian banks supported',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required IconData icon,
    required String title,
    required String desc,
    Widget? expandChild,
  }) {
    bool isSelected = _selectedMethod == id;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedMethod = id;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: expandChild != null ? const BorderRadius.vertical(top: Radius.circular(12)) : BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.outline),
            ),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? AppColors.primaryLight : AppColors.textSecondary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
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
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        if (expandChild != null) expandChild,
      ],
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        children: [
          TextField(
            controller: _cardController,
            style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'CARD NUMBER',
              labelStyle: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
              filled: true,
              fillColor: AppColors.background,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'EXPIRY',
                    labelStyle: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                    filled: true,
                    fillColor: AppColors.background,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  obscureText: true,
                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    labelStyle: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                    filled: true,
                    fillColor: AppColors.background,
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPayNowFooter(double totalPayable) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAYABLE AMOUNT',
                  style: GoogleFonts.manrope(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '₹${totalPayable.round()}',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => _processPayment(totalPayable),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Pay Now',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
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
