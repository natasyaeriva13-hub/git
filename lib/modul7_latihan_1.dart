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

// ✅ Implementasi class BusinessExpense sesuai permintaan
class BusinessExpense extends Expense {
  final String client;
  final bool isReimbursable;

  BusinessExpense({
    required String description,
    required double amount,
    required String category,
    required this.client,
    this.isReimbursable = true,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          date: DateTime.now(),
        );

  @override
  void printDetails() {
    print('💼 PENGELUARAN BISNIS');
    super.printDetails();
    print('   Klien: $client');
    print('   Bisa di-reimburse: ${isReimbursable ? "Ya ✅" : "Tidak ❌"}');
  }
}

void main() {
  var expense = BusinessExpense(
    description: 'Makan siang klien',
    amount: 85.0,
    category: 'Makan',
    client: 'PT Acme',
    isReimbursable: true,
  );

  expense.printDetails();
}