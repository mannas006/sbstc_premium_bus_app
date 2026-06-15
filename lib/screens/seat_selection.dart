import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'passenger_information.dart';

enum SeatStatus { available, selected, booked, ladies }

class SeatData {
  final String id;
  final String label;
  SeatStatus status;

  SeatData({required this.id, required this.label, required this.status});
}

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({Key? key}) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  double _pricePerSeat = 720.0;
  bool _isSleeperBus = false;

  // 5-Column Grid Layout (Aisle is column 3 / index 2 of each row)
  late List<SeatData?> _seatGrid;

  @override
  void initState() {
    super.initState();
    final bus = BookingManager.selectedBus;
    if (bus != null) {
      _pricePerSeat = bus['price'];
      _isSleeperBus = bus['type'].toString().contains('Sleeper');
    }

    _initializeSeatGrid();
  }

  void _initializeSeatGrid() {
    _seatGrid = [
      SeatData(id: '1A', label: '1A', status: SeatStatus.available),
      SeatData(id: '1B', label: '1B', status: SeatStatus.available),
      null, // Aisle
      SeatData(id: '1C', label: '1C', status: SeatStatus.booked),
      SeatData(id: '1D', label: '1D', status: SeatStatus.booked),

      SeatData(id: '2A', label: '2A', status: SeatStatus.available),
      SeatData(id: '2B', label: '2B', status: SeatStatus.available),
      null,
      SeatData(id: '2C', label: '2C', status: SeatStatus.ladies),
      SeatData(id: '2D', label: '2D', status: SeatStatus.ladies),

      SeatData(id: '3A', label: '3A', status: SeatStatus.available),
      SeatData(id: '3B', label: '3B', status: SeatStatus.booked),
      null,
      SeatData(id: '3C', label: '3C', status: SeatStatus.available),
      SeatData(id: '3D', label: '3D', status: SeatStatus.available),

      SeatData(id: '4A', label: '4A', status: SeatStatus.available),
      SeatData(id: '4B', label: '4B', status: SeatStatus.available),
      null,
      SeatData(id: '4C', label: '4C', status: SeatStatus.available),
      SeatData(id: '4D', label: '4D', status: SeatStatus.available),

      SeatData(id: '5A', label: '5A', status: SeatStatus.booked),
      SeatData(id: '5B', label: '5B', status: SeatStatus.available),
      null,
      SeatData(id: '5C', label: '5C', status: SeatStatus.available),
      SeatData(id: '5D', label: '5D', status: SeatStatus.available),

      SeatData(id: '6A', label: '6A', status: SeatStatus.available),
      SeatData(id: '6B', label: '6B', status: SeatStatus.available),
      null,
      SeatData(id: '6C', label: '6C', status: SeatStatus.available),
      SeatData(id: '6D', label: '6D', status: SeatStatus.available),
    ];
  }

  List<SeatData> get _selectedSeats => _seatGrid.where((s) => s != null && s.status == SeatStatus.selected).cast<SeatData>().toList();

  void _toggleSeat(SeatData seat) {
    if (seat.status == SeatStatus.booked) return;

    final maxAllowed = BookingManager.travellersCount;

    setState(() {
      if (seat.status == SeatStatus.selected) {
        // Revert to original type
        if (seat.id == '2C' || seat.id == '2D') {
          seat.status = SeatStatus.ladies;
        } else {
          seat.status = SeatStatus.available;
        }
      } else {
        // Enforce maximum seat selections matching travellersCount
        if (_selectedSeats.length >= maxAllowed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              content: Text(
                'You searched for $maxAllowed travellers. Adjust travellers count on Home page to book more seats.',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          );
          return;
        }
        seat.status = SeatStatus.selected;
      }

      // Sync with global booking manager
      BookingManager.selectedSeats = _selectedSeats.map((s) => s.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final routeText = "${BookingManager.fromCity} → ${BookingManager.toCity}";
    final busName = BookingManager.selectedBus != null ? BookingManager.selectedBus!['name'] : 'Premium Shuttle';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Seats',
              style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              routeText,
              style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
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
              bottom: 180, // space for bottom confirm card
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Journey Summary Card
                Container(
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
                            busName,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            BookingManager.selectedBus != null ? BookingManager.selectedBus!['type'] : 'Premium Class',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'FARE PER SEAT',
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '₹${_pricePerSeat.round()}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Legend row
                _buildLegendRow(),
                const SizedBox(height: 24),

                // Seat Map Container (Styled like RedBus driver at front)
                _buildSeatLayout(),
              ],
            ),
          ),

          // Confirm Floating Action Bar
          if (_selectedSeats.isNotEmpty) _buildConfirmBar(),
        ],
      ),
    );
  }

  Widget _buildLegendRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildLegendItem(color: AppColors.outline, border: AppColors.outline, label: 'Available'),
          const SizedBox(width: 12),
          _buildLegendItem(color: AppColors.primary, border: Colors.transparent, label: 'Selected'),
          const SizedBox(width: 12),
          _buildLegendItem(color: const Color(0x33A0A5B5), border: Colors.transparent, label: 'Booked', hasCross: true),
          const SizedBox(width: 12),
          _buildLegendItem(color: const Color(0x33FF9F43), border: const Color(0xFFFF9F43), label: 'Ladies'),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required Color border, required String label, bool hasCross = false}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: hasCross ? const Icon(Icons.close, size: 12, color: AppColors.textSecondary) : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSeatLayout() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          // Front of Bus & Driver Seat Visual (Signature RedBus style)
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Front / Steer Visual
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'FRONT',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                // Driver Seat Icon
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: const Icon(Icons.radio_button_checked, color: AppColors.textSecondary, size: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seats Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seatGrid.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: _isSleeperBus ? 0.55 : 0.9, // rectangular sleeper berths vs square seaters
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final seat = _seatGrid[index];
              if (seat == null) return const SizedBox(); // Aisle
              return _buildSeatWidget(seat);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeatWidget(SeatData seat) {
    bool isSelected = seat.status == SeatStatus.selected;
    bool isBooked = seat.status == SeatStatus.booked;
    bool isLadies = seat.status == SeatStatus.ladies;

    Color bgColor = AppColors.background;
    Color borderColor = AppColors.outline;
    Color textColor = AppColors.textSecondary;
    Widget? icon;

    if (isSelected) {
      bgColor = AppColors.primary;
      borderColor = Colors.transparent;
      textColor = Colors.white;
    } else if (isBooked) {
      bgColor = const Color(0x11A0A5B5);
      borderColor = Colors.transparent;
      textColor = Colors.transparent;
      icon = const Icon(Icons.close, color: AppColors.textSecondary, size: 12);
    } else if (isLadies) {
      bgColor = const Color(0x22FF9F43);
      borderColor = const Color(0xFFFF9F43);
      textColor = const Color(0xFFFF9F43);
    }

    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: icon ??
              Text(
                seat.label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildConfirmBar() {
    double totalFare = _selectedSeats.length * _pricePerSeat;

    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEATS SELECTED',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedSeats.map((s) => s.id).join(', '),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL FARE',
                      style: GoogleFonts.manrope(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${totalFare.round()}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PassengerInformationScreen()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Confirm Seats',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
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
