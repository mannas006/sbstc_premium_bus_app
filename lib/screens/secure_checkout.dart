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

  // Card Controllers
  final TextEditingController _cardController = TextEditingController(text: '4242 4242 4242 4242');
  final TextEditingController _expiryController = TextEditingController(text: '12/28');
  final TextEditingController _cvvController = TextEditingController(text: '123');
  final TextEditingController _savedCvvController = TextEditingController(text: '123');

  // Checkout States
  bool _payWithNewCard = false;
  bool _saveCardForFuture = true;
  String _selectedUPIApp = 'GPay';
  final TextEditingController _upiIdController = TextEditingController(text: 'alex.morgan@okaxis');
  String _selectedBank = 'HDFC';

  double _pricePerSeat = 720.0;
  String _busName = 'SBSTC Premium Coach';

  @override
  void initState() {
    super.initState();
    if (BookingManager.selectedBus != null) {
      _pricePerSeat = BookingManager.selectedBus!['price'];
      _busName = BookingManager.selectedBus!['name'];
    }
    // If user has no saved cards, default to pay with new card
    if (BookingManager.savedCards.isEmpty) {
      _payWithNewCard = true;
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _savedCvvController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _showPromoCodesSelectorSheet() {
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
                    'Available Offers',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildPromoOptionRow('WEEKEND30', 'Weekend Cashback', 'Save 30% on your base fare'),
              const SizedBox(height: 12),
              _buildPromoOptionRow('FIRSTCLASS', 'First Booking Discount', 'Flat ₹150 discount for first time users'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromoOptionRow(String code, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    code,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                BookingManager.appliedPromoCode = code;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.tertiary,
                  content: Text('Promo code "$code" applied!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'APPLY',
              style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment(double totalPayable) {
    // If they paid with a new card and opted to save it
    if (_selectedMethod == 'CARD' && _payWithNewCard && _saveCardForFuture) {
      final newCard = _cardController.text.trim();
      if (newCard.isNotEmpty && !BookingManager.savedCards.contains(newCard)) {
        BookingManager.savedCards.add(newCard);
      }
    }

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
                style: GoogleFonts.spaceGrotesk(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
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

    // Wait 2 seconds, add booking, and navigate to confirmation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Pop loader

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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BookingConfirmedScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    int seatCount = BookingManager.selectedSeats.length;
    double baseFare = seatCount * _pricePerSeat;
    double amenityFee = seatCount * 120.0;
    double taxes = (baseFare + amenityFee) * 0.18; // 18% GST

    // Calculate dynamic discount
    double discount = 0.0;
    if (BookingManager.appliedPromoCode == 'WEEKEND30') {
      discount = -(baseFare * 0.3);
    } else if (BookingManager.appliedPromoCode == 'FIRSTCLASS') {
      discount = -150.0;
    }

    double totalPayable = baseFare + amenityFee + taxes + discount;
    if (totalPayable < 0) totalPayable = 0;

    final String dateString = "${BookingManager.departureDate.day} ${_getMonthName(BookingManager.departureDate.month)}";
    final routeText = "${BookingManager.fromCity} to ${BookingManager.toCity}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Secure Checkout',
          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
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
              bottom: 160,
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
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            route,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
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
          
          if (BookingManager.appliedPromoCode.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildFareRow('Promo Discount (${BookingManager.appliedPromoCode})', '-₹${discount.abs().round()}', isDiscount: true),
          ],
          
          const SizedBox(height: 16),
          const Divider(color: AppColors.outline),
          const SizedBox(height: 16),

          // Coupon application input/status row
          if (BookingManager.appliedPromoCode.isEmpty)
            InkWell(
              onTap: _showPromoCodesSelectorSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_offer, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Apply Coupon / Promo Code',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.tertiary, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Promo "${BookingManager.appliedPromoCode}" Applied',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        BookingManager.appliedPromoCode = '';
                      });
                    },
                    child: const Icon(Icons.close, color: AppColors.textSecondary, size: 16),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
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
            color: isDiscount ? AppColors.tertiary : AppColors.textPrimary,
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

        // UPI Option
        _buildPaymentOption(
          id: 'UPI',
          icon: Icons.account_balance_wallet_outlined,
          title: 'UPI (GPay, PhonePe, BHIM)',
          desc: 'Instant checkout using secure UPI app',
          expandChild: _selectedMethod == 'UPI' ? _buildUPIForm() : null,
        ),
        const SizedBox(height: 12),

        // Card Option
        _buildPaymentOption(
          id: 'CARD',
          icon: Icons.credit_card_outlined,
          title: 'Credit / Debit Card',
          desc: 'Visa, MasterCard, RuPay, Amex',
          expandChild: _selectedMethod == 'CARD' ? _buildCardForm() : null,
        ),
        const SizedBox(height: 12),

        // Net Banking Option
        _buildPaymentOption(
          id: 'NET',
          icon: Icons.account_balance_outlined,
          title: 'Net Banking',
          desc: 'All major Indian banks supported',
          expandChild: _selectedMethod == 'NET' ? _buildNetBankingForm() : null,
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
                Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
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
                          color: AppColors.textPrimary,
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
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
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

  Widget _buildUPIForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['GPay', 'PhonePe', 'Paytm', 'BHIM'].map((app) {
              bool isSelected = _selectedUPIApp == app;
              return ChoiceChip(
                label: Text(app),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                labelStyle: GoogleFonts.manrope(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedUPIApp = app;
                      _upiIdController.text = 'alex.morgan@ok${app.toLowerCase()}';
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _upiIdController,
            style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              labelText: 'ENTER UPI ID',
              labelStyle: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
              filled: true,
              fillColor: AppColors.background,
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    final bool hasSavedCards = BookingManager.savedCards.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasSavedCards && !_payWithNewCard) ...[
            Text(
              'SELECT SAVED CARD',
              style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      const Icon(Icons.credit_card, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Visa ending in ${BookingManager.savedCards.first.substring(BookingManager.savedCards.first.length - 4)}',
                        style: GoogleFonts.manrope(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Icon(Icons.check_circle, color: AppColors.tertiary, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _savedCvvController,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'ENTER CVV',
                labelStyle: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                filled: true,
                fillColor: AppColors.background,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.outline)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _payWithNewCard = true;
                  });
                },
                child: Text(
                  'Pay with another card',
                  style: GoogleFonts.manrope(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ] else ...[
            TextField(
              controller: _cardController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 14),
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
                    style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 14),
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
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 14),
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
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text('Save card for future payments', style: GoogleFonts.manrope(color: AppColors.textPrimary, fontSize: 13)),
              activeColor: AppColors.primary,
              value: _saveCardForFuture,
              contentPadding: EdgeInsets.zero,
              onChanged: (v) {
                setState(() {
                  _saveCardForFuture = v;
                });
              },
            ),
            if (hasSavedCards)
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _payWithNewCard = false;
                    });
                  },
                  child: Text(
                    'Use saved card',
                    style: GoogleFonts.manrope(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ]
        ],
      ),
    );
  }

  Widget _buildNetBankingForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border.all(color: AppColors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['SBI', 'HDFC', 'ICICI', 'AXIS'].map((bank) {
              bool isSelected = _selectedBank == bank;
              return ChoiceChip(
                label: Text(bank),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                labelStyle: GoogleFonts.manrope(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _selectedBank = bank;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'You will be redirected to the secure portal of $_selectedBank to complete authorization.',
            style: GoogleFonts.manrope(color: AppColors.textSecondary, fontSize: 12),
          ),
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
              color: Colors.black.withOpacity(0.06),
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
            InkWell(
              onTap: () => _processPayment(totalPayable),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Pay Now',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
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
