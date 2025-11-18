class Expense {
  String description;
  double amount;
  String category;
  DateTime date;
  String? notes;

  Expense(this.description, this.amount, this.category, this.date, {this.notes});

  // Constructor split bill
  Expense.splitBill(
    String desc,
    double totalAmount,
    int people,
  ) : description = '$desc (patungan $people orang)',
      amount = totalAmount / people,
      category = 'Makanan',
      date = DateTime.now(),
      notes = 'Patungan dengan $people orang';

  // Constructor kalkulator tip
  Expense.tip(
    String desc,
    double baseAmount,
    double tipPercent,
  ) : description = desc,
      amount = baseAmount * (1 + tipPercent / 100),
      category = 'Makanan',
      date = DateTime.now(),
      notes = 'Termasuk tip ${tipPercent}%';

  // Constructor expense berulang
  Expense.recurring(
    String desc,
    double amount,
    String frequency,
  ) : description = desc,
      this.amount = amount,
      category = 'Tagihan',
      date = DateTime.now(),
      notes = 'Berulang: $frequency';
}
