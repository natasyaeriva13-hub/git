class BudgetManager {
  // Menyimpan budget dan pengeluaran per kategori
  final Map<String, double> _budgets = {};
  final Map<String, double> _expenses = {};

  // Set budget bulanan per kategori
  void setBudget(String category, double amount) {
    if (amount < 0) {
      print('❌ Budget tidak boleh negatif.');
      return;
    }
    _budgets[category] = amount;
    _expenses.putIfAbsent(category, () => 0.0);
    print('✅ Budget untuk "$category": Rp${amount.toStringAsFixed(2)}');
  }

  // Lacak pengeluaran
  void recordExpense(String category, double amount) {
    if (amount <= 0) {
      print('❌ Jumlah pengeluaran harus lebih dari 0.');
      return;
    }

    if (!_budgets.containsKey(category)) {
      print('❌ Kategori "$category" belum memiliki budget. Silakan set terlebih dahulu.');
      return;
    }

    _expenses[category] = (_expenses[category] ?? 0.0) + amount;

    double currentExpense = _expenses[category]!;
    double budget = _budgets[category]!;

    // Tampilkan warning jika mendekati atau melebihi limit
    double remaining = budget - currentExpense;
    double percentageUsed = (currentExpense / budget) * 100;

    if (percentageUsed >= 90) {
      print('⚠️ PERINGATAN: Anda telah menggunakan ${percentageUsed.toStringAsFixed(1)}% dari budget "$category"!');
      if (remaining < 0) {
        print('🚨 MELEBIHI BUDGET! Melebihi Rp${(-remaining).toStringAsFixed(2)}');
      } else {
        print('💰 Sisa budget: Rp${remaining.toStringAsFixed(2)}');
      }
    } else {
      print('📈 Pengeluaran "$category": Rp${currentExpense.toStringAsFixed(2)} / Rp${budget.toStringAsFixed(2)}');
    }
  }

  // Generate laporan budget
  void generateReport() {
    print('\n📊 LAPORAN BUDGET BULANAN');
    print('-' * 40);

    for (var category in _budgets.keys) {
      double budget = _budgets[category]!;
      double expense = _expenses[category] ?? 0.0;
      double remaining = budget - expense;
      double percentageUsed = budget > 0 ? (expense / budget) * 100 : 0;

      String status = '';
      if (expense == 0) {
        status = '🟢 Belum ada pengeluaran';
      } else if (percentageUsed >= 100) {
        status = '🔴 MELEBIHI BUDGET';
      } else if (percentageUsed >= 80) {
        status = '🟡 Mendekati limit';
      } else {
        status = '🔵 Aman';
      }

      print(
          '$category: Rp${expense.toStringAsFixed(2)} / Rp${budget.toStringAsFixed(2)} ($percentageUsed.toStringAsFixed(1)%) — $status');
      if (remaining < 0) {
        print('   ⚠️ Melebihi: Rp${(-remaining).toStringAsFixed(2)}');
      } else {
        print('   💰 Sisa: Rp${remaining.toStringAsFixed(2)}');
      }
      print('');
    }

    // Total keseluruhan
    double totalBudget = _budgets.values.reduce((a, b) => a + b);
    double totalExpense = _expenses.values.reduce((a, b) => a + b);
    double totalRemaining = totalBudget - totalExpense;

    print('-' * 40);
    print('TOTAL: Rp${totalExpense.toStringAsFixed(2)} / Rp${totalBudget.toStringAsFixed(2)}');
    if (totalRemaining < 0) {
      print('🚨 TOTAL MELEBIHI BUDGET: Rp${(-totalRemaining).toStringAsFixed(2)}');
    } else {
      print('💰 TOTAL SISA: Rp${totalRemaining.toStringAsFixed(2)}');
    }
  }
}

// --- Fungsi Utama ---
void main() {
  var budgetManager = BudgetManager();

  // Set budget per kategori
  budgetManager.setBudget('Makanan', 500.0);
  budgetManager.setBudget('Transportasi', 200.0);
  budgetManager.setBudget('Hiburan', 300.0);

  // Catat pengeluaran
  budgetManager.recordExpense('Makanan', 150.0);  // 30%
  budgetManager.recordExpense('Makanan', 250.0);  // 80%
  budgetManager.recordExpense('Makanan', 120.0);  // 104% → warning!

  budgetManager.recordExpense('Transportasi', 180.0);  // 90% → warning
  budgetManager.recordExpense('Hiburan', 290.0);      // 96.7% → warning

  // Tampilkan laporan
  budgetManager.generateReport();
}