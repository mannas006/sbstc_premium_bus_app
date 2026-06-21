import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'secure_checkout.dart';

class PassengerInformationScreen extends StatefulWidget {
  const PassengerInformationScreen({Key? key}) : super(key: key);

  @override
  _PassengerInformationScreenState createState() => _PassengerInformationScreenState();
}

class _PassengerInformationScreenState extends State<PassengerInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _mealSwitch = true;
  String? _gender = 'Male';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  double _pricePerSeat = 720.0;

  @override
  void initState() {
    super.initState();
    if (BookingManager.selectedBus != null) {
      _pricePerSeat = BookingManager.selectedBus!['price'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _autofill(String name, String age, String gender, String phone, String email) {
    setState(() {
      _nameController.text = name;
      _ageController.text = age;
      _gender = gender;
      _phoneController.text = phone;
      _emailController.text = email;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // Save details to BookingManager
      BookingManager.passengerName = _nameController.text;
      BookingManager.passengerAge = _ageController.text;
      BookingManager.passengerGender = _gender ?? 'Male';
      BookingManager.passengerPhone = _phoneController.text;
      BookingManager.passengerEmail = _emailController.text;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecureCheckoutScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalBase = BookingManager.selectedSeats.length * _pricePerSeat;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Passenger Details',
          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 160, // Space for footer
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress line
                  _buildProgressHeader(),
                  const SizedBox(height: 20),

                  // Recent passenger autofill cards
                  _buildSmartAutofill(),
                  const SizedBox(height: 20),

                  // Form card
                  _buildFormSection(),
                  const SizedBox(height: 20),

                  // Selected seats summary
                  _buildSummaryCard(),
                  const SizedBox(height: 20),

                  // Meal switch
                  _buildMealPreferences(),
                ],
              ),
            ),
          ),

          // Total & Proceed Footer
          _buildProceedFooter(totalBase),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enter Traveler Info',
              style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            Text(
              'STEP 2 OF 3',
              style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.outline,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.66,
            child: Container(
              color: AppColors.primary,
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
        Text(
          'QUICK AUTOFILL',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildAutofillCard(
                initials: 'AM',
                name: 'Alex Morgan',
                details: 'Self • 28 • Male',
                onTap: () => _autofill('Alex Morgan', '28', 'Male', '9876543210', 'alex.morgan@gmail.com'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAutofillCard(
                initials: 'SM',
                name: 'Sarah Miller',
                details: 'Family • 26 • Female',
                onTap: () => _autofill('Sarah Miller', '26', 'Female', '9876543211', 'sarah.miller@gmail.com'),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildAutofillCard({
    required String initials,
    required String name,
    required String details,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    details,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
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

  Widget _buildFormSection() {
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
            'PRIMARY TRAVELER',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: 'FULL NAME',
            icon: Icons.person_outline,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter passenger name';
              if (v.trim().split(' ').length < 2) return 'Please enter full name (First & Last)';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Age & Gender Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _ageController,
                  label: 'AGE',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final age = int.tryParse(v);
                    if (age == null || age < 1 || age > 120) return 'Invalid';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Phone field
          _buildTextField(
            controller: _phoneController,
            label: 'MOBILE NUMBER',
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter mobile number';
              if (v.length != 10 || int.tryParse(v) == null) return 'Enter valid 10-digit number';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email field
          _buildTextField(
            controller: _emailController,
            label: 'EMAIL ADDRESS',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Please enter email';
              if (!v.contains('@') || !v.contains('.')) return 'Enter valid email address';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textPrimary),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        floatingLabelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
        filled: true,
        fillColor: AppColors.background,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _gender,
      icon: const Icon(Icons.expand_more, color: AppColors.textSecondary),
      dropdownColor: AppColors.surface,
      style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'GENDER',
        labelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        floatingLabelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
        prefixIcon: const Icon(Icons.wc_outlined, color: AppColors.primary, size: 18),
        filled: true,
        fillColor: AppColors.background,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: ['Male', 'Female', 'Other'].map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      onChanged: (newVal) {
        setState(() {
          _gender = newVal;
        });
      },
    );
  }

  Widget _buildSummaryCard() {
    final seatsText = BookingManager.selectedSeats.join(', ');
    final busType = BookingManager.selectedBus != null ? BookingManager.selectedBus!['type'] : 'Premium Volvo';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SELECTED SEAT(S)',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                seatsText,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                busType,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'CHANGE',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMealPreferences() {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.restaurant, color: AppColors.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complimentary Snack Box',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Snacks and bottled water included',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            activeColor: AppColors.primary,
            value: _mealSwitch,
            onChanged: (v) {
              setState(() {
                _mealSwitch = v;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProceedFooter(double totalBase) {
    double totalPayable = totalBase + 84.50; // add mock taxes/gst

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
                  'TOTAL PAYABLE',
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
              onTap: _onSubmit,
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
                    Text(
                      'PROCEED',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
