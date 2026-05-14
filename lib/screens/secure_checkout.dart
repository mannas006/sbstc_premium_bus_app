import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_confirmed.dart';

class SecureCheckoutScreen extends StatefulWidget {
  const SecureCheckoutScreen({Key? key}) : super(key: key);

  @override
  _SecureCheckoutScreenState createState() => _SecureCheckoutScreenState();
}

class _SecureCheckoutScreenState extends State<SecureCheckoutScreen> {
  final TextEditingController _cardController = TextEditingController(text: '**** **** **** 4242');
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121318), // background
      extendBodyBehindAppBar: true,
      extendBody: true,
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
          
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 120, // Space for Final CTA Footer
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64), // App bar clearance
                  _buildTrustBadge(),
                  const SizedBox(height: 16),
                  _buildFareCard(),
                  const SizedBox(height: 32),
                  _buildCouponEntry(),
                  const SizedBox(height: 32),
                  _buildPaymentMethods(),
                  const SizedBox(height: 32),
                  _buildSecurityFooter(),
                ],
              ),
            ),
          ),
          
          _buildTopAppBar(context),
          _buildFinalCTA(context),
        ],
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
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Color(0xFFB3C5FF)),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Complete Payment',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFB3C5FF),
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                      fit: BoxFit.cover,
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

  Widget _buildTrustBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user, color: Color(0xFF00FBFB), size: 18), // tertiary-fixed
        const SizedBox(width: 8),
        Text(
          'SECURE 256-BIT ENCRYPTED TRANSACTION',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFC5C6D2).withOpacity(0.8), // on-surface-variant/80
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildFareCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9C400).withOpacity(0.2)), // secondary-fixed-dim/20
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE9C400).withOpacity(0.2), // gold-glow
            blurRadius: 15,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative blob
          Positioned(
            top: -36,
            right: -36,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE16D).withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFE16D).withOpacity(0.1),
                    blurRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
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
                            'TRIP SUMMARY',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFE9C400), // secondary-fixed-dim
                              letterSpacing: 0.96,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kolkata to Asansol',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFE3E2E8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dec 24 • Premium Lounge Class • Seat 12A',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFC5C6D2),
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.confirmation_number, color: Color(0xFFE9C400), size: 32),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        _buildFareRow('Base Fare', '₹1,250.00'),
                        const SizedBox(height: 12),
                        _buildFareRow('Premium Amenity Fee', '₹150.00'),
                        const SizedBox(height: 12),
                        _buildFareRow('Taxes & GST', '₹84.50'),
                        const SizedBox(height: 12),
                        _buildFareRow('Loyalty Discount', '-₹50.00', isDiscount: true),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ), // Normally dashed, using solid for simplicity or can use a custom painter, but standard border is fine.
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFE16D), // secondary-fixed
                                ),
                              ),
                              Text(
                                '₹1,434.50',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFFE16D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            fontSize: 16,
            color: isDiscount ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16,
            color: isDiscount ? const Color(0xFF00DDDD) : const Color(0xFFE3E2E8),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponEntry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'PROMOTIONAL CODE',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC5C6D2),
              letterSpacing: 0.96,
            ),
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF343439).withOpacity(0.4), // surface-container-highest/40
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    hintStyle: GoogleFonts.manrope(color: const Color(0xFFC5C6D2).withOpacity(0.4), fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002E2E), // tertiary-container
                    foregroundColor: const Color(0xFF00FBFB), // tertiary-fixed
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'APPLY',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.96,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'SELECT PAYMENT METHOD',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC5C6D2),
              letterSpacing: 0.96,
            ),
          ),
        ),
        // UPI Option
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF002366).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.account_balance_wallet, color: Color(0xFFB3C5FF)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Unified Payments Interface (UPI)',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE3E2E8),
                      ),
                    ),
                    Text(
                      'PhonePe, Google Pay, BHIM',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFFC5C6D2),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFC5C6D2)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Card Option (Expanded)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF002366).withOpacity(0.1), // primary-container/10
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB3C5FF).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF002366),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.credit_card, color: Color(0xFFB3C5FF)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credit / Debit Card',
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE3E2E8),
                          ),
                        ),
                        Text(
                          'Visa, Mastercard, RuPay',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFFC5C6D2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.expand_more, color: Color(0xFFB3C5FF)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                ),
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    _buildPaymentTextField('CARD NUMBER', _cardController),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildPaymentTextField('EXPIRY', _expiryController, hint: 'MM/YY')),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPaymentTextField('CVV', _cvvController, hint: '***', isPassword: true)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Digital Wallet Option
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF292A2F), // surface-container-high
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.wallet, color: Color(0xFFC5C6D2)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digital Wallets',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE3E2E8),
                      ),
                    ),
                    Text(
                      'Paytm, Amazon Pay',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: const Color(0xFFC5C6D2),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFC5C6D2)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTextField(String label, TextEditingController controller, {String? hint, bool isPassword = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF0D0E12), // surface-container-lowest
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            style: GoogleFonts.manrope(color: const Color(0xFFE3E2E8), fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.manrope(color: const Color(0xFFC5C6D2).withOpacity(0.5), fontSize: 16),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Centered text vertically
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: -8,
          child: Container(
            color: const Color(0xFF002366).withOpacity(0.1), // Matches the background behind the field perfectly
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC5C6D2), // Using consistent label color instead of dark background specific ones
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield, color: Colors.white.withOpacity(0.6), size: 40),
            const SizedBox(width: 24),
            Icon(Icons.lock, color: Colors.white.withOpacity(0.6), size: 40),
            const SizedBox(width: 24),
            Icon(Icons.security, color: Colors.white.withOpacity(0.6), size: 40),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Your payment details are encrypted and processed by our secure partners. We do not store your full card details.',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: const Color(0xFFC5C6D2).withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalCTA(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF121318).withOpacity(0.9), // surface/90
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAYABLE AMOUNT',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC5C6D2),
                        letterSpacing: 0.96,
                      ),
                    ),
                    Text(
                      '₹1,434.50',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE3E2E8), // on-surface
                      ),
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BookingConfirmedScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00FBFB), Color(0xFF435B9F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 1), // inner shadow simulation
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_person, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Pay Now',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
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
            ),
          ),
        ),
      ),
    );
  }
}
