// --- Kelas Category ---
class Category {
  String name;
  String icon;
  String color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  String getLabel() {
    return '$icon $name';
  }
}

// --- Fungsi Utama ---
void main() {
  // Buat objek kategori
  var food = Category(name: 'Makanan', icon: '🍔', color: 'green');
  var transport = Category(name: 'Transport', icon: '🚗', color: 'blue');

  // Cetak label kategori
  print(food.getLabel());
  print(transport.getLabel());
}