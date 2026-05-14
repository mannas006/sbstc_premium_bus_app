import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'secure_checkout.dart';

class PassengerInformationScreen extends StatefulWidget {
  const PassengerInformationScreen({Key? key}) : super(key: key);

  @override
  _PassengerInformationScreenState createState() => _PassengerInformationScreenState();
}

class _PassengerInformationScreenState extends State<PassengerInformationScreen> {
  bool _mealSwitch = true;
  String? _gender;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
                bottom: 240, // Space for floating bar and bottom nav
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64), // App bar clearance
                  _buildProgressHeader(),
                  const SizedBox(height: 32),
                  _buildSmartAutofill(),
                  const SizedBox(height: 24),
                  _buildFormSection(),
                  const SizedBox(height: 24),
                  _buildSummaryCard(),
                  const SizedBox(height: 24),
                  _buildMealPreferences(),
                ],
              ),
            ),
          ),
          
          _buildTopAppBar(context),
          
          _buildFloatingActionSummary(context),
          
          _buildBottomNavBar(context),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAQLbsH5KVhL77uwgpYPIynEmn_VF2Aqg-I912GcGomF5ceIIoX4TTQH2SHbUNlyaYln67l7sBU_8Xz_n3Zv2t01USsRsdHyuRXnJROhq5BrnXeQl5zyUkhTIaZsd9EPdheMoN_CZDvzr-4CV2d6xe-VFOwT4EISmKztQhzT2q3Sx9a81ia4Ke67RTarNG_iMHA3qIyzfht7OJEJQPv_X59TIPT-6Duul0RvpeIIZlZp0Xyzp8su9I9bRHijEHbx6_ZGs6SVCnLLKLg',
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

  Widget _buildProgressHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Passenger Details',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFFF9EF), // secondary
                height: 1.3,
              ),
            ),
            Text(
              'STEP 2 OF 3',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF00DDDD), // tertiary
                letterSpacing: 0.96,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.66,
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
      ],
    );
  }

  Widget _buildSmartAutofill() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Color(0xFF00DDDD), size: 16),
            const SizedBox(width: 8),
            Text(
              'RECENT PASSENGERS',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC5C6D2),
                letterSpacing: 0.96,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildAutofillCard(
                initials: 'AM',
                name: 'Alex Morgan',
                details: 'Self • 28 yrs',
                isActive: true,
              ),
              const SizedBox(width: 12),
              _buildAutofillCard(
                initials: 'SM',
                name: 'Sarah Miller',
                details: 'Family • 26 yrs',
                isActive: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAutofillCard({
    required String initials,
    required String name,
    required String details,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          setState(() {
            _nameController.text = 'Alex Morgan';
            _ageController.text = '28';
            _gender = 'Male';
            _phoneController.text = '9876543210';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? const Color(0xFF00DDDD).withOpacity(0.2) : Colors.white.withOpacity(0.05),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF002366) : const Color(0xFF292A2F),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isActive ? const Color(0xFFB3C5FF) : const Color(0xFFC5C6D2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFE3E2E8), // on-surface
                      ),
                    ),
                    Text(
                      details,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: const Color(0xFFC5C6D2).withOpacity(0.7),
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

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Stack(
            children: [
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.person, color: Color(0x6600DDDD)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRIMARY PASSENGER',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00DDDD),
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _nameController,
                    label: 'FULL NAME',
                    suffixIcon: _nameController.text.isNotEmpty
                        ? const Icon(Icons.check_circle, color: Color(0xFF00DDDD), size: 18)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _ageController,
                          label: 'AGE',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildDropdownField(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(
        fontSize: 16,
        color: const Color(0xFFE3E2E8),
      ),
      onChanged: (v) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFC5C6D2),
          letterSpacing: 0.96,
        ),
        floatingLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF00DDDD),
          letterSpacing: 0.96,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00DDDD), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _gender,
      icon: const Icon(Icons.expand_more, color: Color(0xFFC5C6D2)),
      dropdownColor: const Color(0xFF121318),
      style: GoogleFonts.manrope(
        fontSize: 16,
        color: const Color(0xFFE3E2E8),
      ),
      decoration: InputDecoration(
        labelText: 'GENDER',
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFC5C6D2),
          letterSpacing: 0.96,
        ),
        floatingLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF00DDDD),
          letterSpacing: 0.96,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00DDDD), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
      items: ['Male', 'Female', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _gender = newValue;
        });
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.manrope(
        fontSize: 16,
        color: const Color(0xFFE3E2E8),
      ),
      decoration: InputDecoration(
        labelText: 'MOBILE NUMBER',
        labelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFC5C6D2),
          letterSpacing: 0.96,
        ),
        floatingLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF00DDDD),
          letterSpacing: 0.96,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(top: 14, right: 12),
          child: Text(
            '+91',
            style: GoogleFonts.manrope(
              fontSize: 16,
              color: const Color(0xFFC5C6D2),
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00DDDD), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: const BorderSide(color: Color(0xFF00DDDD), width: 4),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECTED SEATS',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00DDDD),
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '12A, 12B',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE3E2E8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Upper Deck • Window',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC5C6D2),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'CHANGE',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFB3C5FF),
                    letterSpacing: 0.96,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealPreferences() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COMPLIMENTS OF SBSTC',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFC5C6D2),
                  letterSpacing: 0.96,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant, color: Color(0xFF00DDDD)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Snack Box',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              color: const Color(0xFFE3E2E8),
                            ),
                          ),
                          Text(
                            'Includes bottled water & snacks',
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _mealSwitch = !_mealSwitch;
                      });
                    },
                    child: Container(
                      width: 48,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _mealSwitch ? const Color(0xFF00DDDD).withOpacity(0.2) : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            left: _mealSwitch ? 24 : 4,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: _mealSwitch ? const Color(0xFF00DDDD) : const Color(0xFFC5C6D2),
                                shape: BoxShape.circle,
                                boxShadow: _mealSwitch ? [
                                  BoxShadow(color: const Color(0xFF00DDDD).withOpacity(0.5), blurRadius: 8)
                                ] : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionSummary(BuildContext context) {
    return Positioned(
      bottom: 112,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL PAYABLE',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC5C6D2),
                        letterSpacing: 0.96,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹3,450',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFF9EF), // secondary
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ALL INCL.',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            color: const Color(0xFFC5C6D2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecureCheckoutScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00DDDD).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'PROCEED',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
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
                _buildNavItem(icon: Icons.confirmation_number, label: 'Bookings', isActive: true),
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
