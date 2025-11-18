// --- Kelas Abstrak: PaymentMethod ---
abstract class PaymentMethod {
  String get name;
  String get icon;

  void processPayment(double amount);

  void showReceipt(double amount) {
    print('✅ Pembayaran berhasil!');
    print('Jumlah: Rp${amount.toStringAsFixed(2)}');
    print('Metode: $name');
  }
}

// --- Interface: Refundable ---
abstract class Refundable {
  bool canRefund();
  void processRefund(double amount);
}

// --- Kelas CreditCard (Mengimplementasikan Refundable) ---
class CreditCard extends PaymentMethod implements Refundable {
  final String cardNumber;
  final String cardHolder;
  final List<double> transactions = [];

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
  });

  @override
  String get name => 'Kartu Kredit';

  @override
  String get icon => '💳';

  @override
  void processPayment(double amount) {
    transactions.add(amount);
    print('$icon Mendebet Rp${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }

  @override
  bool canRefund() {
    return transactions.isNotEmpty;
  }

  @override
  void processRefund(double amount) {
    if (!canRefund()) {
      print('❌ Tidak ada transaksi untuk direfund');
      return;
    }

    print('🔄 Memproses refund Rp${amount.toStringAsFixed(2)}');
    print('   Refund akan muncul dalam 3-5 hari kerja');
    transactions.add(-amount);  // Negatif untuk refund
  }
}

// --- Kelas Cash (Tidak mengimplementasikan Refundable) ---
class Cash extends PaymentMethod {
  @override
  String get name => 'Tunai';

  @override
  String get icon => '💵';

  @override
  void processPayment(double amount) {
    print('$icon Pembayaran tunai: Rp${amount.toStringAsFixed(2)}');
    showReceipt(amount);
  }
}

// --- Fungsi Utama ---
void main() {
  var card = CreditCard(
    cardNumber: '4532123456789012',
    cardHolder: 'John Doe',
  );
  var cash = Cash();

  card.processPayment(100.0);

  // Bisa refund kartu kredit
  if (card is Refundable) {
    card.processRefund(50.0);
  }

  cash.processPayment(50.0);

  // Tidak bisa refund tunai
  if (cash is Refundable) {
    // Kode ini TIDAK AKAN PERNAH dijalankan karena `cash` bukan Refundable
    // Tapi karena kita cek tipe dulu, maka aman.
    // Namun, jika kamu menulis `cash.processRefund(...)` langsung di sini,
    // itu akan menyebabkan error kompilasi.
    // Jadi, biarkan kosong atau cetak sesuatu.
    print('✅ Tunai bisa direfund (ini tidak akan muncul)');
  } else {
    print('❌ Pembayaran tunai tidak dapat direfund');
  }
}