import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../booking_manager.dart';
import '../theme/colors.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: LiveTrackingView(showBackButton: true),
    );
  }
}

class LiveTrackingView extends StatefulWidget {
  final bool showBackButton;
  const LiveTrackingView({Key? key, this.showBackButton = false}) : super(key: key);

  @override
  _LiveTrackingViewState createState() => _LiveTrackingViewState();
}

class _LiveTrackingViewState extends State<LiveTrackingView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _progressTimer;
  double _routeProgress = 0.25; // 0.0 to 1.0 along route
  int _minutesRemaining = 42;
  String _currentStop = 'Kolkata (Esplanade)';
  String _nextStop = 'Airport Gate 4';

  final List<Map<String, dynamic>> _stops = [
    {'name': 'Kolkata (Esplanade)', 'done': true, 'time': '08:30'},
    {'name': 'Science City', 'done': true, 'time': '08:45'},
    {'name': 'Airport Gate 4', 'done': false, 'time': '09:15'},
    {'name': 'Dankuni Toll', 'done': false, 'time': '09:45'},
    {'name': 'Durgapur Terminal', 'done': false, 'time': '11:45'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate route progress updates every 5 seconds
    _progressTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      setState(() {
        _routeProgress += 0.05;
        if (_routeProgress > 0.95) {
          _routeProgress = 0.95;
          _minutesRemaining = 0;
          _stops[2]['done'] = true;
          _stops[3]['done'] = true;
          _stops[4]['done'] = true;
        } else {
          _minutesRemaining = (_minutesRemaining - 2).clamp(1, 120);
          
          if (_routeProgress > 0.4) {
            _currentStop = 'Airport Gate 4';
            _nextStop = 'Dankuni Toll';
            _stops[2]['done'] = true;
          }
          if (_routeProgress > 0.7) {
            _currentStop = 'Dankuni Toll';
            _nextStop = 'Durgapur Terminal';
            _stops[3]['done'] = true;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine target cities dynamically from BookingManager or defaults
    final String routeText = '${BookingManager.fromCity} → ${BookingManager.toCity}';

    return Stack(
      children: [
        // Simulated map background
        Positioned.fill(
          child: Container(
            color: AppColors.background,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: MapRoutePainter(
                    pulseAnimation: _pulseController.value,
                    routeProgress: _routeProgress,
                  ),
                );
              },
            ),
          ),
        ),

        // Gradient overlay for visual contrast
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.2, 0.8, 1.0],
                  colors: [
                    AppColors.background.withOpacity(0.8),
                    AppColors.background.withOpacity(0.0),
                    AppColors.background.withOpacity(0.0),
                    AppColors.background.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Floating info cards
        SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    if (widget.showBackButton) ...[
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Text(
                      'Live Tracking',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Trip Status Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACTIVE ROUTE',
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryLight,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                routeText,
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'TRACKING',
                                  style: GoogleFonts.manrope(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.outline,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _routeProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryLight.withOpacity(0.2),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Passed: $_currentStop',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '$_minutesRemaining mins left',
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Timeline overlay on the right
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _stops.map((stop) {
                      bool isDone = stop['done'];
                      bool isCurrent = stop['name'] == _nextStop;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isCurrent ? AppColors.primary : AppColors.outline,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    stop['name'],
                                    style: GoogleFonts.manrope(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isCurrent ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                  Text(
                                    stop['time'],
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isCurrent ? AppColors.secondary : AppColors.textSecondary.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isDone ? Icons.check_circle : (isCurrent ? Icons.near_me : Icons.radio_button_unchecked),
                                size: 16,
                                color: isCurrent ? AppColors.primary : (isDone ? AppColors.tertiary : AppColors.textSecondary.withOpacity(0.4)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Bus Details Card at bottom
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 110),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.directions_bus, color: AppColors.primaryLight),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                BookingManager.selectedBus != null
                                    ? BookingManager.selectedBus!['name']
                                    : 'SBSTC Royal Volvo 9600',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'WB-38-AX-8824 • Gold Class',
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.share, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MapRoutePainter extends CustomPainter {
  final double pulseAnimation;
  final double routeProgress;

  MapRoutePainter({required this.pulseAnimation, required this.routeProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.4)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double dashWidth = 8;
    const double dashSpace = 12;

    Path path = Path();
    path.moveTo(size.width * 0.4, size.height * 0.15);
    path.cubicTo(
      size.width * 0.7, size.height * 0.25,
      size.width * 0.2, size.height * 0.45,
      size.width * 0.5, size.height * 0.55,
    );
    path.cubicTo(
      size.width * 0.8, size.height * 0.65,
      size.width * 0.3, size.height * 0.8,
      size.width * 0.5, size.height * 0.9,
    );

    // Draw dashed path
    double distance = 0;
    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final double length = distance + dashWidth < pathMetric.length ? dashWidth : pathMetric.length - distance;
        canvas.drawPath(pathMetric.extractPath(distance, distance + length), paint);
        distance += dashWidth + dashSpace;
      }
    }

    // Draw landmark dots
    final landmarkPaint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.15), 6, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.55), 6, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), 6, landmarkPaint);

    // Draw Pulse Circle at current location along the path
    final currentMetric = path.computeMetrics().first;
    final currentOffset = currentMetric.getTangentForOffset(currentMetric.length * routeProgress)?.position ?? Offset(size.width * 0.5, size.height * 0.5);

    final pulsePaint = Paint()
      ..color = AppColors.primaryLight.withOpacity(1 - pulseAnimation)
      ..style = PaintingStyle.fill;

    final corePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(currentOffset, 8 + (16 * pulseAnimation), pulsePaint);
    canvas.drawCircle(currentOffset, 8, corePaint);
  }

  @override
  bool shouldRepaint(covariant MapRoutePainter oldDelegate) {
    return oldDelegate.pulseAnimation != pulseAnimation || oldDelegate.routeProgress != routeProgress;
  }
}
