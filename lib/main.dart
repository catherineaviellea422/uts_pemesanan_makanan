import 'package:flutter/material.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Pemesanan Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// ------------------- 1. HALAMAN LOGIN -------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_usernameController.text == 'admin' && _passwordController.text == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username/Password salah! (Gunakan: admin / admin123)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Login Admin', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Sistem Pemesanan Makanan', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- 2. DASHBOARD UTAMA -------------------
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock Data Menu
  List<Map<String, dynamic>> menuList = [
    {'nama': 'Nasi Goreng', 'harga': 'Rp20.000'},
    {'nama': 'Ayam Bakar', 'harga': 'Rp25.000'},
  ];

  final _namaMenuController = TextEditingController();
  final _hargaMenuController = TextEditingController();

  void _tambahMenu() {
    if (_namaMenuController.text.isNotEmpty && _hargaMenuController.text.isNotEmpty) {
      setState(() {
        menuList.add({
          'nama': _namaMenuController.text,
          'harga': _hargaMenuController.text,
        });
      });
      _namaMenuController.clear();
      _hargaMenuController.clear();
    }
  }

  void _hapusMenu(int index) {
    setState(() {
      menuList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Chip(
              label: const Text('Admin', style: TextStyle(color: Colors.green)),
              backgroundColor: Colors.green.shade50,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Cards Statistik
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard('Total Pesanan', '125', context),
                    _buildStatCard('Total Menu', '${menuList.length + 28}', context),
                    _buildStatCard('Pesanan Baru', '12', context),
                    _buildStatCard('Total Pelanggan', '85', context),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),

            // Tabel Data Pesanan
            const Text('Daftar Pesanan Terbaru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Pelanggan')),
                    DataColumn(label: Text('Menu')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: const [
                    DataRow(cells: [DataCell(Text('001')), DataCell(Text('Andi')), DataCell(Text('Nasi Goreng')), DataCell(Text('Selesai'))]),
                    DataRow(cells: [DataCell(Text('002')), DataCell(Text('Budi')), DataCell(Text('Ayam Bakar')), DataCell(Text('Diproses'))]),
                    DataRow(cells: [DataCell(Text('003')), DataCell(Text('Citra')), DataCell(Text('Mie Goreng')), DataCell(Text('Baru'))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Form Kelola Menu
            const Text('Kelola Menu Makanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _namaMenuController,
                      decoration: const InputDecoration(labelText: 'Nama menu', hintText: 'Nama makanan', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _hargaMenuController,
                      decoration: const InputDecoration(labelText: 'Harga', hintText: 'Contoh: Rp20.000', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _tambahMenu,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                        child: const Text('Tambah Menu'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menuList.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(menuList[index]['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(menuList[index]['harga']!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OutlinedButton(onPressed: () {}, child: const Text('Edit')),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () => _hapusMenu(index),
                                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}