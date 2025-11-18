// ✅ Definisikan class Expense terlebih dahulu
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  void printDetails() {
    print('   Deskripsi: $description');
    print('   Jumlah: \$$amount');
    print('   Kategori: $category');
    print('   Tanggal: ${date.toLocal().toString().split(' ')[0]}');
  }
}

// ✅ Sekarang TravelExpense bisa meng-extend Expense tanpa error
class TravelExpense extends Expense {
  final String destination;
  final int tripDuration;

  TravelExpense({
    required String description,
    required double amount,
    required this.destination,
    required this.tripDuration,
    DateTime? date,
  }) : super(
          description: description,
          amount: amount,
          category: 'Perjalanan',
          date: date ?? DateTime.now(),
        );

  /// Menghitung biaya rata-rata per hari
  double getDailyCost() {
    if (tripDuration <= 0) return amount;
    return amount / tripDuration;
  }

  /// Menentukan apakah perjalanan ini internasional
  bool isInternational() {
    final domesticKeywords = ['Indonesia', 'Jakarta', 'Bandung', 'Bali', 'Yogyakarta', 'Surabaya'];
    final lowerDest = destination.toLowerCase();

    if (domesticKeywords.any((loc) => lowerDest.contains(loc.toLowerCase()))) {
      return false;
    }

    final internationalKeywords = [
      'jepang', 'singapura', 'malaysia', 'korea', 'thailand', 'china',
      'amerika', 'jerman', 'inggris', 'prancis', 'australia', 'turki',
      'japan', 'singapore', 'malaysia', 'korea', 'thailand', 'china',
      'usa', 'united states', 'germany', 'uk', 'france', 'australia', 'turkey'
    ];

    return internationalKeywords.any((country) => lowerDest.contains(country));
  }

  @override
  void printDetails() {
    print('✈️ PENGELUARAN PERJALANAN');
    super.printDetails();
    print('   Destinasi: $destination');
    print('   Durasi: $tripDuration hari');
    print('   Biaya harian: Rp ${getDailyCost().toStringAsFixed(2)}');
    print('   Internasional: ${isInternational() ? "Ya 🌍" : "Tidak 🏠"}');
  }
}

// ✅ Contoh penggunaan
void main() {
  var trip = TravelExpense(
    description: 'Liburan Tokyo',
    amount: 25000000.0,
    destination: 'Tokyo, Jepang',
    tripDuration: 7,
  );

  trip.printDetails();
}