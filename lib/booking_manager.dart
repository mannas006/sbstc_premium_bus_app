
class BookingManager {
  // Static lists and maps to act as our global memory state
  static List<Map<String, dynamic>> bookings = [
    {
      'pnr': 'PR-742910',
      'from': 'Kolkata',
      'to': 'Siliguri',
      'date': '24 Oct 2023',
      'departureTime': '20:30',
      'arrivalTime': '08:30',
      'duration': '12h 00m',
      'busName': 'SBSTC Midnight Star Scania',
      'seat': 'Upper Deck, 02C',
      'price': '₹2,400.00',
      'status': 'Completed',
    },
    {
      'pnr': 'PR-881023',
      'from': 'Durgapur',
      'to': 'Kolkata',
      'date': '12 Nov 2023',
      'departureTime': '14:30',
      'arrivalTime': '17:45',
      'duration': '3h 15m',
      'busName': 'Volvo 9600 Multi-Axle',
      'seat': 'Lower Deck, 08A',
      'price': '₹720.00',
      'status': 'Completed',
    }
  ];

  // Active search parameters
  static String fromCity = 'Kolkata';
  static String toCity = 'Digha';
  static DateTime departureDate = DateTime(2026, 6, 16);
  static int travellersCount = 1;

  // Selected bus for checkout
  static Map<String, dynamic>? selectedBus;

  // Selected seats for checkout
  static List<String> selectedSeats = [];

  // Primary passenger details (synchronized with user profile)
  static String passengerName = 'Alex Morgan';
  static String passengerAge = '28';
  static String passengerGender = 'Male';
  static String passengerPhone = '9876543210';
  static String passengerEmail = 'alex.morgan@gmail.com';

  static int loyaltyPoints = 2450;
  static double walletBalance = 450.0;
  static String appliedPromoCode = '';
  static List<String> savedCards = ['4242 4242 4242 4242'];

  // Reset checkout details (transaction specific)
  static void resetCheckout() {
    selectedBus = null;
    selectedSeats = [];
    appliedPromoCode = '';
  }

  // Add a new confirmed booking
  static String addBooking({
    required String from,
    required String to,
    required String date,
    required String departureTime,
    required String arrivalTime,
    required String duration,
    required String busName,
    required String seats,
    required double totalFare,
  }) {
    final String pnr = 'PR-${(100000 + (bookings.length * 37) + DateTime.now().millisecond) % 999999}';
    bookings.insert(0, {
      'pnr': pnr,
      'from': from,
      'to': to,
      'date': date,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'duration': duration,
      'busName': busName,
      'seat': seats,
      'price': '₹${totalFare.toStringAsFixed(2)}',
      'status': 'Confirmed',
    });
    return pnr;
  }
}
