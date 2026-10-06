import 'package:flutter/material.dart';

void main() {
  runApp(const UserMobileApp());
}

class UserMobileApp extends StatelessWidget {
  const UserMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Pemesanan Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: const UserLoginPage(),
    );
  }
}

// ======================================================
// 1. LOGIN USER
// ======================================================

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _namaController = TextEditingController();

  void _loginUser() {
    final nama = _namaController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan nama Anda terlebih dahulu'),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserHomePage(
          namaUser: nama,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Colors.deepOrange,
              ),

              const SizedBox(height: 16),

              const Text(
                'Aplikasi Pemesanan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Silakan masuk untuk melakukan pemesanan',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              TextField(
                controller: _namaController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama Anda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onSubmitted: (_) => _loginUser(),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Masuk Aplikasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// 2. HOME / KATALOG MENU
// ======================================================

class UserHomePage extends StatefulWidget {
  final String namaUser;

  const UserHomePage({
    super.key,
    required this.namaUser,
  });

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final List<Map<String, String>> daftarMenu = [
    {
      'nama': 'Nasi Goreng',
      'harga': 'Rp20.000',
    },
    {
      'nama': 'Ayam Bakar',
      'harga': 'Rp25.000',
    },
    {
      'nama': 'Mie Goreng',
      'harga': 'Rp18.000',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.namaUser}'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepOrange,
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                ),
              ),

              title: Text(
                item['nama']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                item['harga']!,
              ),

              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormPemesananPage(
                        namaUser: widget.namaUser,
                        namaMenu: item['nama']!,
                        hargaMenu: item['harga']!,
                      ),
                    ),
                  );
                },
                child: const Text('Pesan'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ======================================================
// 3. FORM PEMESANAN
// ======================================================

class FormPemesananPage extends StatefulWidget {
  final String namaUser;
  final String namaMenu;
  final String hargaMenu;

  const FormPemesananPage({
    super.key,
    required this.namaUser,
    required this.namaMenu,
    required this.hargaMenu,
  });

  @override
  State<FormPemesananPage> createState() => _FormPemesananPageState();
}

class _FormPemesananPageState extends State<FormPemesananPage> {
  final _formKey = GlobalKey<FormState>();

  final _jumlahController = TextEditingController(
    text: '1',
  );

  final _catatanController = TextEditingController();

  void _konfirmasiPesanan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final jumlah = int.parse(
      _jumlahController.text.trim(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Struk Pesanan'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pemesan: ${widget.namaUser}',
              ),

              const SizedBox(height: 6),

              Text(
                'Menu: ${widget.namaMenu}',
              ),

              const SizedBox(height: 6),

              Text(
                'Harga: ${widget.hargaMenu}',
              ),

              const SizedBox(height: 6),

              Text(
                'Jumlah: $jumlah porsi',
              ),

              const SizedBox(height: 6),

              Text(
                'Catatan: ${_catatanController.text.trim().isEmpty ? "-" : _catatanController.text.trim()}',
              ),

              const SizedBox(height: 12),

              const Text(
                'Status: Pesanan Berhasil Dibuat!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pemesanan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,

                leading: const CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: Icon(
                    Icons.restaurant,
                    color: Colors.white,
                  ),
                ),

                title: Text(
                  widget.namaMenu,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                subtitle: Text(
                  widget.hargaMenu,
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: 'Jumlah Porsi',
                  hintText: 'Masukkan jumlah porsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_cart),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah porsi wajib diisi';
                  }

                  final jumlah = int.tryParse(
                    value.trim(),
                  );

                  if (jumlah == null) {
                    return 'Jumlah harus berupa angka';
                  }

                  if (jumlah <= 0) {
                    return 'Jumlah porsi minimal 1';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _catatanController,
                maxLines: 3,

                decoration: const InputDecoration(
                  labelText: 'Catatan Tambahan',
                  hintText: 'Contoh: tidak pedas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _konfirmasiPesanan,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),

                  child: const Text(
                    'Kirim Pesanan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}