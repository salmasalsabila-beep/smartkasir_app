// Mengimpor pustaka antarmuka Material Design utama dari Flutter
import 'package:flutter/material.dart';

// Mengimpor halaman DashboardPage untuk tab menu pertama (Beranda)
import 'dashboard_page.dart';

// MainNavigationPage turunan StatefulWidget: mengelola status tab menu yang aktif
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

// Kelas pengelola state dan logika navigasi bawah aplikasi SmartKasir
class _MainNavigationPageState extends State<MainNavigationPage> {
  // --- DEKLARASI VARIABEL STATE NAVIGASI ---
  // Indeks tab yang sedang aktif (nilai awal: 0 = tab Beranda)
  int _currentIndex = 0;

  // Koleksi layar halaman menu operasional kasir (List of Widget)
  final List<Widget> _pages = [
    const DashboardPage(), // Indeks 0: Dashboard Katalog Kasir
    const Center(
      child: Text(
        'Menu 2: Transaksi Kasir POS (Modul M14)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 1: POS Kasir
    const Center(
      child: Text(
        'Menu 3: Riwayat Penjualan & Laporan (Modul M12)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 2: Riwayat
    const Center(
      child: Text(
        'Menu 4: Profil Toko & Pengaturan (Modul M12)',
        style: TextStyle(fontSize: 16),
      ),
    ), // Indeks 3: Pengaturan
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold: pondasi visual penyedia slot halaman dan bilah navigasi bawah
    return Scaffold(
      // --- PERCABANGAN BERBASIS INDEKS ARRAY (DYNAMIC VIEW SWITCHING) ---
      // Menampilkan halaman dari list _pages sesuai nilai _currentIndex
      body: _pages[_currentIndex],

      // Container: pembungkus bilah navigasi bawah dengan efek bayangan
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            // Bayangan halus pemisah navigasi bawah dengan konten di atasnya
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2), // Bayangan mengarah ke atas
            ),
          ],
        ),
        // BottomNavigationBar: navigasi standar Material Design 4 tab
        child: BottomNavigationBar(
          currentIndex: _currentIndex, // Tab yang sedang aktif
          // Event handler saat pengguna mengetuk salah satu tab
          onTap: (index) {
            // setState: perbarui indeks aktif dan render ulang halaman
            setState(() {
              _currentIndex =
                  index; // Ubah _currentIndex sesuai tab yang diketuk
            });
          },
          type: BottomNavigationBarType.fixed, // Kunci lebar 4 tab agar stabil
          backgroundColor: Colors.white, // Latar bilah navigasi: putih
          selectedItemColor: const Color(
            0xFF1E3A8A,
          ), // Warna tab aktif: Biru Navy
          unselectedItemColor: Colors.grey.shade500, // Warna tab pasif: abu-abu
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ), // Gaya teks aktif tebal
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
          ), // Gaya teks pasif
          // --- DAFTAR ITEM NAVIGASI BAWAH (4 TAB MENU UTAMA) ---
          items: const [
            // Tab 1: Beranda Toko
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined), // Ikon pasif (outline)
              activeIcon: Icon(Icons.storefront), // Ikon aktif (solid)
              label: 'Beranda', // Label menu
            ),
            // Tab 2: Kasir POS
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Kasir',
            ),
            // Tab 3: Riwayat Transaksi & Laporan
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Riwayat',
            ),
            // Tab 4: Profil Toko & Pengaturan
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Toko',
            ),
          ],
        ),
      ),
    );
  }
}