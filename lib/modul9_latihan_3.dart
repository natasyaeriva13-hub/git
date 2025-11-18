// --- Import harus diletakkan di AWAL file ---
import 'dart:io';

// --- Kelas User ---
class User {
  final String username;
  String password; // Bisa diubah (misalnya ganti password)
  String name;
  String? email;
  DateTime createdAt;

  // Pengaturan pribadi
  Map<String, dynamic> settings = {
    'currency': 'IDR',
    'theme': 'light',
    'notifications': true,
  };

  // Data keuangan per user
  late BudgetManager budgetManager;

  User({
    required this.username,
    required this.password,
    this.name = 'User',
    this.email,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now() {
    budgetManager = BudgetManager();
  }

  @override
  String toString() {
    return '👤 $name ($username) - Email: $email';
  }
}

// --- Kelas Expense ---
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  @override
  String toString() {
    return '${date.toString().split(' ')[0]} | $category | Rp${amount.toStringAsFixed(2)} | $description';
  }
}

// --- Kelas BudgetManager (diperbarui dari Latihan 2) ---
class BudgetManager {
  final Map<String, double> _budgets = {};
  final List<Expense> _expenses = [];

  void setBudget(String category, double amount) {
    if (amount < 0) {
      print('❌ Budget tidak boleh negatif.');
      return;
    }
    _budgets[category] = amount;
    print('✅ Budget untuk "$category": Rp${amount.toStringAsFixed(2)}');
  }

  void recordExpense(Expense expense) {
    _expenses.add(expense);
    double currentExpense = _expenses
        .where((e) => e.category == expense.category)
        .map((e) => e.amount)
        .reduce((a, b) => a + b);

    double budget = _budgets[expense.category] ?? 0.0;
    double remaining = budget - currentExpense;
    double percentageUsed = budget > 0 ? (currentExpense / budget) * 100 : 0;

    if (percentageUsed >= 90) {
      print('⚠️ PERINGATAN: "$expense.category" telah ${percentageUsed.toStringAsFixed(1)}% digunakan!');
      if (remaining < 0) {
        print('🚨 MELEBIHI BUDGET! Melebihi Rp${(-remaining).toStringAsFixed(2)}');
      } else {
        print('💰 Sisa budget: Rp${remaining.toStringAsFixed(2)}');
      }
    }
  }

  void generateReport() {
    print('\n📊 LAPORAN BUDGET');
    print('-' * 50);

    // Group by category
    var groupedExpenses = <String, double>{};
    for (var e in _expenses) {
      groupedExpenses[e.category] = (groupedExpenses[e.category] ?? 0) + e.amount;
    }

    for (var category in _budgets.keys) {
      double budget = _budgets[category]!;
      double expense = groupedExpenses[category] ?? 0.0;
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

    // Total
    double totalBudget = _budgets.values.reduce((a, b) => a + b);
    double totalExpense = groupedExpenses.values.reduce((a, b) => a + b);
    double totalRemaining = totalBudget - totalExpense;

    print('-' * 50);
    print('TOTAL: Rp${totalExpense.toStringAsFixed(2)} / Rp${totalBudget.toStringAsFixed(2)}');
    if (totalRemaining < 0) {
      print('🚨 TOTAL MELEBIHI BUDGET: Rp${(-totalRemaining).toStringAsFixed(2)}');
    } else {
      print('💰 TOTAL SISA: Rp${totalRemaining.toStringAsFixed(2)}');
    }
  }

  // Ambil semua pengeluaran
  List<Expense> get expenses => List.unmodifiable(_expenses);
}

// --- Kelas UserManager ---
class UserManager {
  final Map<String, User> _users = {};

  // Login
  User? login(String username, String password) {
    if (!_users.containsKey(username)) {
      print('❌ Pengguna tidak ditemukan.');
      return null;
    }

    User user = _users[username]!;
    if (user.password != password) {
      print('❌ Password salah.');
      return null;
    }

    print('✅ Selamat datang, ${user.name}!');
    return user;
  }

  // Registrasi
  User register(String username, String password, {String name = 'User', String? email}) {
    if (_users.containsKey(username)) {
      throw Exception('Username sudah digunakan.');
    }

    User newUser = User(
      username: username,
      password: password,
      name: name,
      email: email,
    );
    _users[username] = newUser;
    print('✅ Akun "$username" berhasil dibuat.');
    return newUser;
  }

  // Ubah password
  bool changePassword(User user, String oldPassword, String newPassword) {
    if (user.password != oldPassword) {
      print('❌ Password lama salah.');
      return false;
    }
    user.password = newPassword;
    print('✅ Password berhasil diubah.');
    return true;
  }

  // Ambil semua user (untuk admin)
  List<User> getAllUsers() => _users.values.toList();

  // Ambil user berdasarkan username
  User? getUser(String username) => _users[username];
}

// --- Kelas Utama: FinanceApp ---
class FinanceApp {
  final UserManager userManager = UserManager();
  User? currentUser;

  void run() {
    print('🌟 Selamat datang di FinanceApp Multi-User!');
    print('Gunakan "login", "register", atau "quit".');

    while (true) {
      print('\n> Masukkan perintah:');
      String? input = stdin.readLineSync(); // <-- Sekarang aman karena import sudah di awal
      if (input == null) continue;

      List<String> parts = input.split(' ');
      String command = parts[0].toLowerCase();

      switch (command) {
        case 'login':
          if (parts.length < 3) {
            print('❌ Format: login <username> <password>');
            break;
          }
          String username = parts[1];
          String password = parts[2];
          currentUser = userManager.login(username, password);
          if (currentUser != null) {
            print('📌 Anda masuk sebagai: ${currentUser!.username}');
          }
          break;

        case 'register':
          if (parts.length < 3) {
            print('❌ Format: register <username> <password> [nama] [email]');
            break;
          }
          String regUsername = parts[1];
          String regPassword = parts[2];
          String regName = parts.length > 3 ? parts[3] : 'User';
          String? regEmail = parts.length > 4 ? parts[4] : null;

          try {
            userManager.register(regUsername, regPassword, name: regName, email: regEmail);
          } catch (e) {
            print('❌ Error: $e');
          }
          break;

        case 'profile':
          if (currentUser == null) {
            print('❌ Silakan login terlebih dahulu.');
            break;
          }
          print('\n📋 PROFIL USER');
          print(currentUser);
          print('Pengaturan:');
          currentUser!.settings.forEach((key, value) {
            print('  • $key: $value');
          });
          break;

        case 'setbudget':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          if (parts.length < 3) {
            print('❌ Format: setbudget <kategori> <jumlah>');
            break;
          }
          String category = parts[1];
          double amount = double.tryParse(parts[2]) ?? 0.0;
          currentUser!.budgetManager.setBudget(category, amount);
          break;

        case 'expense':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          if (parts.length < 4) {
            print('❌ Format: expense <kategori> <jumlah> <deskripsi>');
            break;
          }
          String cat = parts[1];
          double amt = double.tryParse(parts[2]) ?? 0.0;
          String desc = parts.sublist(3).join(' ');

          var expense = Expense(
            description: desc,
            amount: amt,
            category: cat,
          );
          currentUser!.budgetManager.recordExpense(expense);
          break;

        case 'report':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          currentUser!.budgetManager.generateReport();
          break;

        case 'logout':
          currentUser = null;
          print('👋 Anda telah logout.');
          break;

        case 'quit':
          print('🔒 Terima kasih telah menggunakan FinanceApp!');
          return;

        default:
          print('❌ Perintah tidak dikenali. Gunakan: login, register, profile, setbudget, expense, report, logout, quit');
      }
    }
  }
}

// --- Main Function ---
void main() {
  var app = FinanceApp();
  app.run();
}