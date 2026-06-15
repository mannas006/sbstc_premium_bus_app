import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';
import 'seat_selection.dart';

class BusDiscoveryScreen extends StatefulWidget {
  const BusDiscoveryScreen({Key? key}) : super(key: key);

  @override
  _BusDiscoveryScreenState createState() => _BusDiscoveryScreenState();
}

class _BusDiscoveryScreenState extends State<BusDiscoveryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _allBuses = [];
  List<Map<String, dynamic>> _filteredBuses = [];
  String _activeSort = 'CHEAPEST FIRST';

  // Filters
  bool _filterAC = false;
  bool _filterSleeper = false;
  double _priceLimit = 2500.0;
  double _maxPriceFound = 2500.0;

  @override
  void initState() {
    super.initState();
    _generateBuses();
  }

  void _generateBuses() {
    final from = BookingManager.fromCity;
    final to = BookingManager.toCity;

    double priceFactor = 1.0;
    int durationMinutes = 195; // 3h 15m default

    if ((from == 'Kolkata' && to == 'Siliguri') || (from == 'Siliguri' && to == 'Kolkata')) {
      priceFactor = 2.8;
      durationMinutes = 720; // 12 hrs
    } else if ((from == 'Kolkata' && to == 'Puri') || (from == 'Puri' && to == 'Kolkata')) {
      priceFactor = 2.0;
      durationMinutes = 510; // 8.5 hrs
    } else if ((from == 'Kolkata' && to == 'Digha') || (from == 'Digha' && to == 'Kolkata')) {
      priceFactor = 0.8;
      durationMinutes = 240; // 4 hrs
    } else if ((from == 'Kolkata' && to == 'Durgapur') || (from == 'Durgapur' && to == 'Kolkata')) {
      priceFactor = 1.0;
      durationMinutes = 195; // 3h 15m
    } else if ((from == 'Kolkata' && to == 'Asansol') || (from == 'Asansol' && to == 'Kolkata')) {
      priceFactor = 1.1;
      durationMinutes = 225; // 3h 45m
    }

    _allBuses = [
      {
        'name': 'SBSTC Royal Cruiser Volvo',
        'type': 'Volvo 9600 A/C Sleeper (2+1)',
        'classTitle': 'GOLD CLASS • VOLVO 9600',
        'rating': 4.9,
        'departureTime': '06:30',
        'arrivalTime': _calculateArrivalTime('06:30', durationMinutes),
        'duration': _formatMinutes(durationMinutes),
        'durationMinutes': durationMinutes,
        'price': (720.0 * priceFactor).roundToDouble(),
        'seatsLeft': 12,
        'isAC': true,
        'isSleeper': true,
        'amenities': ['A/C SLEEPER', 'CHARGING POINT', 'WATER BOTTLE'],
      },
      {
        'name': 'Express Executive Scania',
        'type': 'Scania Metrolink A/C Seater (2+2)',
        'classTitle': 'PLATINUM • SCANIA METROLINK',
        'rating': 4.7,
        'departureTime': '08:00',
        'arrivalTime': _calculateArrivalTime('08:00', durationMinutes + 15),
        'duration': _formatMinutes(durationMinutes + 15),
        'durationMinutes': durationMinutes + 15,
        'price': (650.0 * priceFactor).roundToDouble(),
        'seatsLeft': 2,
        'isAC': true,
        'isSleeper': false,
        'amenities': ['A/C SEATER', 'CHARGING PORT'],
      },
      {
        'name': 'SBSTC Midnight Star Benz',
        'type': 'Mercedes-Benz A/C Sleeper (2+1)',
        'classTitle': 'ELITE • MERCEDES-BENZ',
        'rating': 4.8,
        'departureTime': '22:45',
        'arrivalTime': _calculateArrivalTime('22:45', durationMinutes - 15),
        'duration': _formatMinutes(durationMinutes - 15),
        'durationMinutes': durationMinutes - 15,
        'price': (890.0 * priceFactor).roundToDouble(),
        'seatsLeft': 22,
        'isAC': true,
        'isSleeper': true,
        'amenities': ['A/C SLEEPER', 'CHARGING PORT', 'BLANKET'],
      },
      {
        'name': 'SBSTC Regular Seater',
        'type': 'Non-A/C Seater (3+2)',
        'classTitle': 'STANDARD CLASS',
        'rating': 4.2,
        'departureTime': '11:15',
        'arrivalTime': _calculateArrivalTime('11:15', durationMinutes + 30),
        'duration': _formatMinutes(durationMinutes + 30),
        'durationMinutes': durationMinutes + 30,
        'price': (450.0 * priceFactor).roundToDouble(),
        'seatsLeft': 35,
        'isAC': false,
        'isSleeper': false,
        'amenities': ['CHARGING PORT'],
      }
    ];

    // Find the max price to set filter limits
    double maxP = 0;
    for (var bus in _allBuses) {
      if (bus['price'] > maxP) maxP = bus['price'];
    }
    _maxPriceFound = maxP;
    _priceLimit = maxP;

    _applyFiltersAndSort();
  }

  String _calculateArrivalTime(String depTime, int durationMins) {
    final parts = depTime.split(':');
    int hour = int.parse(parts[0]);
    int min = int.parse(parts[1]);

    int totalMin = hour * 60 + min + durationMins;
    int arrHour = (totalMin ~/ 60) % 24;
    int arrMin = totalMin % 60;

    return "${arrHour.toString().padLeft(2, '0')}:${arrMin.toString().padLeft(2, '0')}";
  }

  String _formatMinutes(int totalMins) {
    int h = totalMins ~/ 60;
    int m = totalMins % 60;
    return "${h}h ${m}m";
  }

  void _applyFiltersAndSort() {
    setState(() {
      _filteredBuses = _allBuses.where((bus) {
        if (_filterAC && !(bus['isAC'] as bool)) return false;
        if (_filterSleeper && !(bus['isSleeper'] as bool)) return false;
        if ((bus['price'] as double) > _priceLimit) return false;
        return true;
      }).toList();

      if (_activeSort == 'CHEAPEST FIRST') {
        _filteredBuses.sort((a, b) => (a['price'] as double).compareTo(b['price'] as double));
      } else if (_activeSort == 'FASTEST') {
        _filteredBuses.sort((a, b) => (a['durationMinutes'] as int).compareTo(b['durationMinutes'] as int));
      } else if (_activeSort == 'TOP RATED') {
        _filteredBuses.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
      } else if (_activeSort == 'EARLIEST') {
        _filteredBuses.sort((a, b) => (a['departureTime'] as String).compareTo(b['departureTime'] as String));
      }
    });
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        double tempPriceLimit = _priceLimit;
        bool tempAC = _filterAC;
        bool tempSleeper = _filterSleeper;

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
                        'Filter Buses',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setSheetState(() {
                            tempPriceLimit = _maxPriceFound;
                            tempAC = false;
                            tempSleeper = false;
                          });
                        },
                        child: Text(
                          'RESET',
                          style: GoogleFonts.manrope(
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AC Switch
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Air Conditioned (A/C)',
                      style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
                    ),
                    value: tempAC,
                    onChanged: (v) => setSheetState(() => tempAC = v),
                  ),

                  // Sleeper Switch
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Sleeper Coaches',
                      style: GoogleFonts.manrope(color: Colors.white, fontSize: 16),
                    ),
                    value: tempSleeper,
                    onChanged: (v) => setSheetState(() => tempSleeper = v),
                  ),

                  const SizedBox(height: 16),

                  // Price range
                  Text(
                    'Max Price: ₹${tempPriceLimit.round()}',
                    style: GoogleFonts.manrope(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.outline,
                    min: 300,
                    max: _maxPriceFound + 100,
                    value: tempPriceLimit.clamp(300.0, _maxPriceFound + 100.0),
                    onChanged: (val) {
                      setSheetState(() {
                        tempPriceLimit = val;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _priceLimit = tempPriceLimit;
                          _filterAC = tempAC;
                          _filterSleeper = tempSleeper;
                        });
                        _applyFiltersAndSort();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w700),
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

  @override
  Widget build(BuildContext context) {
    final String dateString = "${BookingManager.departureDate.day} ${_getMonthShortName(BookingManager.departureDate.month)}";
    final routeText = "${BookingManager.fromCity} to ${BookingManager.toCity}";

    return Scaffold(
      key: _scaffoldKey,
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
              routeText,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              '$dateString • ${BookingManager.travellersCount} Traveller(s)',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(context),
          )
        ],
        backgroundColor: AppColors.surface,
        elevation: 0,
        shape: Border(bottom: BorderSide(color: AppColors.outline, width: 1)),
      ),
      body: Column(
        children: [
          // Sort Navigation Bar
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildSortTab(label: 'CHEAPEST FIRST'),
                  const SizedBox(width: 8),
                  _buildSortTab(label: 'FASTEST'),
                  const SizedBox(width: 8),
                  _buildSortTab(label: 'TOP RATED'),
                  const SizedBox(width: 8),
                  _buildSortTab(label: 'EARLIEST'),
                ],
              ),
            ),
          ),

          // Bus cards list
          Expanded(
            child: _filteredBuses.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredBuses.length,
                    itemBuilder: (context, index) {
                      final bus = _filteredBuses[index];
                      return _buildBusCard(bus);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_bus_filled_outlined,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No buses match your filters',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try resetting or relaxing your filter constraints.',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortTab({required String label}) {
    bool isActive = _activeSort == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeSort = label;
        });
        _applyFiltersAndSort();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.background,
          border: Border.all(color: isActive ? AppColors.primary : AppColors.outline),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBusCard(Map<String, dynamic> bus) {
    bool isPromoPrice = bus['rating'] > 4.7;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus['classTitle'],
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryLight,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          bus['name'],
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          bus['type'],
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.secondary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            bus['rating'].toString(),
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Departure/Arrival/Duration Timeline Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bus['departureTime'],
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          BookingManager.fromCity,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              bus['duration'],
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.outline)),
                                Expanded(child: Container(height: 1, color: AppColors.outline)),
                                const Icon(Icons.directions_bus, size: 16, color: AppColors.primaryLight),
                                Expanded(child: Container(height: 1, color: AppColors.outline)),
                                Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.outline)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          bus['arrivalTime'],
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          BookingManager.toCity,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities badges
                Row(
                  children: (bus['amenities'] as List<String>).map((amenity) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.outline.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        amenity,
                        style: GoogleFonts.manrope(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Price and Seat Status bottom bar
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SEATS REMAINING',
                            style: GoogleFonts.manrope(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            "${bus['seatsLeft']} Seats Left",
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: bus['seatsLeft'] <= 5 ? AppColors.primaryLight : AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          if (isPromoPrice) ...[
                            Text(
                              '₹${(bus['price'] * 1.15).round()} ',
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                          Text(
                            '₹${bus['price'].round()}',
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
                ),
              ],
            ),
          ),

          // Select Seats Button
          InkWell(
            onTap: () {
              BookingManager.selectedBus = bus;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SeatSelectionScreen()),
              );
            },
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Center(
                child: Text(
                  'SELECT SEATS',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthShortName(int monthNum) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (monthNum >= 1 && monthNum <= 12) {
      return months[monthNum - 1];
    }
    return '';
  }
}
