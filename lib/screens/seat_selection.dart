import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final double _pricePerSeat = 1250.00;

  // Manually match the layout from the HTML
  List<SeatData?> _seatGrid = [
    SeatData(id: '1A', label: '1A', status: SeatStatus.available),
    SeatData(id: '1B', label: '1B', status: SeatStatus.available),
    null, // Aisle
    SeatData(id: '1C', label: '', status: SeatStatus.booked),
    SeatData(id: '1D', label: '', status: SeatStatus.booked),

    SeatData(id: '2A', label: '2A', status: SeatStatus.selected), // Initially selected
    SeatData(id: '2B', label: '2B', status: SeatStatus.available),
    null,
    SeatData(id: '2C', label: '2C', status: SeatStatus.ladies),
    SeatData(id: '2D', label: '2D', status: SeatStatus.ladies),

    SeatData(id: '3A', label: '3A', status: SeatStatus.available),
    SeatData(id: '3B', label: '3B', status: SeatStatus.available),
    null,
    SeatData(id: '3C', label: '3C', status: SeatStatus.available),
    SeatData(id: '3D', label: '3D', status: SeatStatus.available),

    SeatData(id: '4A', label: '', status: SeatStatus.booked),
    SeatData(id: '4B', label: '', status: SeatStatus.booked),
    null,
    SeatData(id: '4C', label: '4C', status: SeatStatus.available),
    SeatData(id: '4D', label: '4D', status: SeatStatus.available),
  ];

  List<SeatData> get _selectedSeats => _seatGrid.where((s) => s != null && s.status == SeatStatus.selected).cast<SeatData>().toList();

  void _toggleSeat(SeatData seat) {
    if (seat.status == SeatStatus.booked) return;
    
    setState(() {
      if (seat.status == SeatStatus.selected) {
        if (seat.id == '2C' || seat.id == '2D') {
          seat.status = SeatStatus.ladies;
        } else {
          seat.status = SeatStatus.available;
        }
      } else {
        seat.status = SeatStatus.selected;
      }
    });
  }

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
          
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 16,
                bottom: 160, // Space for floating bar
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJourneySummary(),
                  const SizedBox(height: 12),
                  _buildSeatMapLegend(),
                  const SizedBox(height: 16),
                  _buildInteractiveSeatMap(),
                  const SizedBox(height: 24),
                  _buildAmenitiesPreview(),
                ],
              ),
            ),
          ),
          
          _buildTopAppBar(context),
          
          // Only show floating bar if there are selected seats
          if (_selectedSeats.isNotEmpty)
            _buildFloatingSelectionBar(context),
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
                Row(
                  children: [
                    const Icon(Icons.notifications, color: Color(0xFFC5C6D2)),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFB3C5FF).withOpacity(0.2)),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
                            fit: BoxFit.cover,
                          ),
                        ),
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

  Widget _buildJourneySummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.15)),
          left: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KOLKATA → ASANSOL',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC5C6D2),
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Premium Volvo Multi-Axle',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFFF9EF), // secondary
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '08:30 AM',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00DDDD), // tertiary
                      letterSpacing: 0.96,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gate 4, Esplanade',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFC5C6D2), // on-surface-variant
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

  Widget _buildSeatMapLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildLegendItem(
            color: const Color(0xFF343439), // surface-container-highest
            borderColor: Colors.white.withOpacity(0.1),
            label: 'AVAILABLE',
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            color: const Color(0xFF00DDDD),
            borderColor: Colors.transparent,
            label: 'SELECTED',
            glowColor: const Color(0xFF00DDDD).withOpacity(0.4),
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            color: const Color(0xFFC5C6D2).withOpacity(0.2),
            borderColor: Colors.transparent,
            label: 'BOOKED',
            icon: Icons.close,
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            color: const Color(0xFFFFB4AB).withOpacity(0.3),
            borderColor: const Color(0xFFFFB4AB).withOpacity(0.5),
            label: 'LADIES',
            glowColor: const Color(0xFFFFB4AB).withOpacity(0.3),
            labelColor: const Color(0xFFFFB4AB),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
    Color? glowColor,
    IconData? icon,
    Color? labelColor,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
            boxShadow: glowColor != null
                ? [BoxShadow(color: glowColor, blurRadius: 15)]
                : null,
          ),
          child: icon != null
              ? Icon(icon, size: 14, color: const Color(0xFFC5C6D2))
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: labelColor ?? const Color(0xFFC5C6D2),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveSeatMap() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Color(0xFF1E1F24), // surface-container
            Color(0xFF0D0E12), // surface-container-lowest
          ],
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Front of Bus
          Container(
            padding: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: const Icon(Icons.airline_seat_recline_extra, color: Color(0xFFC5C6D2)),
                ),
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB3C5FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'FRONT OF BUS',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC5C6D2).withOpacity(0.4),
                        letterSpacing: 0.96,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF343439),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.navigation, color: Color(0xFFC5C6D2)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seatGrid.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              final seat = _seatGrid[index];
              if (seat == null) return const SizedBox(); // Aisle
              return _buildSeat(seat);
            },
          ),
          
          const SizedBox(height: 48),
          
          // Rear Indicator
          Container(
            width: 64,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(SeatData seat) {
    bool isAvailable = seat.status == SeatStatus.available;
    bool isSelected = seat.status == SeatStatus.selected;
    bool isBooked = seat.status == SeatStatus.booked;
    bool isLadies = seat.status == SeatStatus.ladies;

    Color bgColor;
    Color borderColor;
    Color textColor;
    List<BoxShadow>? shadows;
    Widget? icon;

    if (isSelected) {
      bgColor = const Color(0xFF00DDDD);
      borderColor = Colors.transparent;
      textColor = const Color(0xFF0D2C6E);
      shadows = [BoxShadow(color: const Color(0xFF00DDDD).withOpacity(0.4), blurRadius: 15)];
    } else if (isBooked) {
      bgColor = const Color(0xFFC5C6D2).withOpacity(0.1);
      borderColor = Colors.transparent;
      textColor = Colors.transparent;
      icon = const Icon(Icons.close, color: Color(0xFFC5C6D2), size: 14);
    } else if (isLadies) {
      bgColor = const Color(0xFFFFB4AB).withOpacity(0.2);
      borderColor = const Color(0xFFFFB4AB).withOpacity(0.4);
      textColor = const Color(0xFFFFB4AB);
      shadows = [BoxShadow(color: const Color(0xFFFFB4AB).withOpacity(0.3), blurRadius: 15)];
    } else {
      // Available
      bgColor = Colors.white.withOpacity(0.08);
      borderColor = Colors.white.withOpacity(0.1);
      textColor = const Color(0xFFC5C6D2);
    }

    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: shadows,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isAvailable || isLadies
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Center(
                    child: Text(
                      seat.label,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: 0.96,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: icon ?? Text(
                    seat.label,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                      letterSpacing: 0.96,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAmenitiesPreview() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.15)),
                left: BorderSide(color: Colors.white.withOpacity(0.15)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002366),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.wifi, color: Color(0xFFB3C5FF)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STARLINK',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC5C6D2),
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'Free Wi-Fi',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFFF9EF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.15)),
                left: BorderSide(color: Colors.white.withOpacity(0.15)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002E2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.bolt, color: Color(0xFF00DDDD)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CHARGING',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC5C6D2),
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          'USB-C Port',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFFF9EF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingSelectionBar(BuildContext context) {
    double totalFare = _selectedSeats.length * _pricePerSeat;

    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 50,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELECTED SEATS',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFC5C6D2),
                              letterSpacing: 0.96,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _selectedSeats.map((s) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00DDDD).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: const Color(0xFF00DDDD).withOpacity(0.4)),
                                ),
                                child: Text(
                                  s.label,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00DDDD),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'TOTAL FARE',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC5C6D2),
                            letterSpacing: 0.96,
                          ),
                        ),
                        Text(
                          '₹${totalFare.toStringAsFixed(2)}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFB3C5FF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PassengerInformationScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00DDDD), Color(0xFF435B9F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 1,
                            offset: const Offset(0, 1), // inner shadow simulation
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm Selection',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.trending_flat, color: Colors.white),
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
                          border: Border.all(color: const Color(0xFFB3C5FF), width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipOval(
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCFzE72WiBAGPAT8iyjSR5hZ2Kp7rkmFfwjDu1EiUQaW8bn4HbvqPpFiv9Us1ThOn-SRHnF9Nx9zVwLmxaCTUSzSjJftREu8j3RvPpBKoPYkpIBl3yiELn69OGZCXSgKZeOJddInET_32ilfrWlsgZTEFOAhcotueD8c4LAFkLRnqMvVmO_t8LF8xdZCWm-NMan_JLheRyLZIbewvHu5YGQJJ1KcS5YairQMufr3uxH-goGTeoluVbhnSn9sUD74_IYND_c6IXtsgJE',
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
                              color: const Color(0xFFB3C5FF),
                            ),
                          ),
                          Text(
                            'Gold Member • 2,450 pts',
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFC5C6D2),
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
}
