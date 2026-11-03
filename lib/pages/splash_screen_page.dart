// Mengimpor pustaka kontrol waktu dan timer asinkron bawaan bahasa Dart
import 'dart:async';

// Mengimpor pustaka antarmuka Material Design utama Flutter
import 'package:flutter/material.dart';

// Mengimpor halaman navigasi utama sebagai tujuan perpindahan layar
import 'main_navigation_page.dart';

// SplashScreenPage turunan StatefulWidget: mengelola status timer hitung mundur
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

// Kelas pengelola state, timer asinkron, dan logika navigasi Splash Screen
class _SplashScreenPageState extends State<SplashScreenPage> {
  // --- DEKLARASI VARIABEL STATE & TIMER ---
  // Durasi hitung mundur dalam detik (nilai awal: 5 detik)
  int _durasiDetik = 10;

  // Objek timer asinkron (nullable '?' karena belum dibuat saat kelas diinisialisasi)
  Timer? _timer;

  // initState: siklus hidup yang dieksekusi satu kali saat widget pertama dipasang
  @override
  void initState() {
    super.initState();
    // Memulai penghitung waktu mundur saat splash screen terbuka
    _mulaiHitungMundur();
  }

  // --- FUNGSI LOGIKA HITUNG MUNDUR & NAVIGASI OTOMATIS ---
  void _mulaiHitungMundur() {
    // PERULANGAN WAKTU ASINKRON: callback dieksekusi setiap 1 detik secara berulang
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // --- PERCABANGAN LOGIKA EVALUASI TIMER ---
      // Kondisi 1: waktu masih lebih besar dari 1 detik
      if (_durasiDetik > 1) {
        // setState: kurangi angka durasi dan perbarui angka di layar
        setState(() {
          _durasiDetik--; // Decrement: kurangi _durasiDetik sebanyak 1
        });
      }
      // Kondisi 2: waktu habis (mencapai angka 1)
      else {
        _timer?.cancel(); // Hentikan perulangan timer

        // SAFETY CHECK: pastikan widget masih terpasang sebelum navigasi
        if (!mounted) return;

        // NAVIGASI SATU ARAH: ganti Splash Screen dengan MainNavigationPage
        // agar pengguna tidak bisa kembali (Back) ke Splash Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationPage()),
        );
      }
    });
  }

  // dispose: siklus hidup pembersihan memori saat widget dihancurkan
  @override
  void dispose() {
    // Matikan timer untuk mencegah kebocoran memori (memory leak)
    _timer?.cancel();
    super.dispose();
  }

  // build: merender tata letak visual halaman pembuka
  @override
  Widget build(BuildContext context) {
    // Scaffold: layar penuh dengan latar biru navy
    return Scaffold(
      backgroundColor: Colors.teal, // Biru Navy Elegan
      // Center: posisikan semua komponen di tengah layar
      body: Center(
        // Column: susun logo, judul, indikator putar, dan timer secara vertikal
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Rata tengah vertikal
          children: [
            // =============================================================
            // BAGIAN 1: LOGO APLIKASI SMARTKASIR
            // =============================================================
            // Container: wadah lingkaran putih dengan bayangan
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle, // Bentuk lingkaran sempurna
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.2,
                    ), // Bayangan semi-transparan
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              // Icon: ikon mesin kasir berukuran besar
              child: const Icon(
                Icons.point_of_sale_rounded,
                size: 72,
                color: Color(
                  0xFF1E3A8A,
                ), // Serasi dengan warna tema (Biru Navy)
              ),
            ),
            const SizedBox(height: 24), // Jarak vertikal 24 piksel
            // =============================================================
            // BAGIAN 2: IDENTITAS & TAGLINE PRODUK DIGITAL
            // =============================================================
            // Text: nama aplikasi
            const Text(
              'SmartKasir',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2, // Jarak antar huruf
              ),
            ),
            const SizedBox(height: 6), // Jarak 6 piksel
            // Text: slogan aplikasi
            const Text(
              'Aplikasi Kasir Point of Sale Digital',
              style: TextStyle(fontSize: 13, color: Colors.white70),
            ),
            const SizedBox(height: 36), // Jarak 36 piksel
            // =============================================================
            // BAGIAN 3: INDIKATOR LOADING & TEKS TIMER DINAMIS
            // =============================================================
            // SizedBox: membatasi dimensi indikator putar (28 x 28)
            const SizedBox(
              width: 28,
              height: 28,
              // CircularProgressIndicator: animasi putaran loading
              child: CircularProgressIndicator(
                color: Colors.amber, // Warna indikator: emas
                strokeWidth: 3, // Ketebalan garis 3 piksel
              ),
            ),
            const SizedBox(height: 14), // Jarak 14 piksel
            // Text: status hitung mundur reaktif dari variabel _durasiDetik
            Text(
              'Menyiapkan sistem SmartKasir ($_durasiDetik detik)...',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 40), // Jarak ke footer
            // Text: catatan versi modul praktikum
            Text(
              'Versi 1.0.0 — Modul Pertemuan 10',
              style: TextStyle(fontSize: 11, color: Colors.blue.shade200),
            ),
          ],
        ),
      ),
    );
  }
}
