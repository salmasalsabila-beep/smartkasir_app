// Mengimpor pustaka material design Flutter untuk komponen antarmuka
import 'package:flutter/material.dart';
// Mengimpor pustaka pemformat internasionalisasi (intl) untuk format angka & mata uang Rupiah
import 'package:intl/intl.dart';

// Mengimpor model data dan daftar produk dummy dari folder models
import '../models/produk.dart';

// DashboardPage turunan StatefulWidget: memiliki state dinamis yang dapat berubah saat berinteraksi
class DashboardPage extends StatefulWidget {
  // Konstruktor konstan dengan parameter key
  const DashboardPage({super.key});

  // Method createState: menghubungkan widget dengan kelas pengelola state internalnya
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// Kelas pengelola state dan logika bisnis tampilan halaman Dashboard Beranda
class _DashboardPageState extends State<DashboardPage> {
  // --- DEKLARASI VARIABEL STATE & KONFIGURASI TAMPILAN ---
  // Indeks filter kategori yang sedang aktif (0: Semua, 1: Makanan, 2: Minuman, 3: Snack)
  int _kategoriTerpilih = 0;

  // Koleksi opsi filter kategori toko kasir (List of String, immutable)
  final List<String> _kategoriList = ['Semua', 'Makanan', 'Minuman', 'Snack'];

  // --- FUNGSI FORMAT MATA UANG RUPIAH ---
  // Mengonversi angka double menjadi string format mata uang Indonesia (Rp)
  String _formatRupiah(double nominal) {
    // Pemformat mata uang menggunakan pustaka NumberFormat
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID', // Lokal Indonesia (pemisah ribuan menggunakan titik)
      symbol: 'Rp ', // Simbol mata uang Indonesia
      decimalDigits: 0, // Jumlah angka di belakang koma (0 digit)
    );
    // Contoh: 18000.0 menjadi "Rp 18.000"
    return formatCurrency.format(nominal);
  }

  // --- FUNGSI PEMBUAT WIDGET BADGE INDIKATOR STOK (LOGIKA BISNIS KASIR) ---
  // Membangun badge stok dengan warna dan label adaptif sesuai sisa persediaan
  Widget _buildBadgeStok(int stok) {
    // Variabel lokal penampung warna latar, warna teks, dan label badge
    Color warnaLatar;
    Color warnaTeks;
    String label;

    // --- KONTROL PERCABANGAN / LOGIKA INDIKATOR PERSEDIAAN STOK ---
    // Kondisi 1: stok bernilai 0 (habis total)
    if (stok == 0) {
      warnaLatar = Colors.red.shade100; // Latar merah muda
      warnaTeks = Colors.red.shade900; // Teks merah pekat
      label = 'Habis'; // Label status kosong
    }
    // Kondisi 2: stok tersisa 1 hingga 5 unit (menipis/kritis)
    else if (stok <= 5) {
      warnaLatar = Colors.amber.shade100; // Latar kuning muda
      warnaTeks = Colors.amber.shade900; // Teks oranye gelap
      label = 'Sisa $stok'; // Interpolasi string sisa unit
    }
    // Kondisi 3: stok lebih dari 5 unit (aman)
    else {
      warnaLatar = Colors.green.shade100; // Latar hijau muda
      warnaTeks = Colors.green.shade900; // Teks hijau pekat
      label = 'Stok $stok'; // Interpolasi string jumlah stok
    }

    // Container: wadah kotak pembungkus badge dengan sudut melengkung
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: warnaLatar, // Warna latar hasil percabangan
        borderRadius: BorderRadius.circular(6), // Sudut melengkung 6 piksel
      ),
      // Text: label status stok
      child: Text(
        label, // Teks hasil percabangan
        style: TextStyle(
          fontSize: 10, // Ukuran font 10 pt
          fontWeight: FontWeight.bold, // Tebal
          color: warnaTeks, // Warna font hasil percabangan
        ),
      ),
    );
  }

  // Method build: merender seluruh hierarki antarmuka Dashboard
  @override
  Widget build(BuildContext context) {
    // --- KONTROL PERCABANGAN LOGIKA PENYARINGAN (FILTER) KATALOG PRODUK ---
    // Operator ternary (kondisi ? jika_benar : jika_salah)
    final listTampil = _kategoriTerpilih == 0
        ? daftarProdukDummy // Jika "Semua" aktif, tampilkan seluruh 6 produk
        : daftarProdukDummy // Jika kategori spesifik, filter dengan .where()
              .where((p) => p.kategori == _kategoriList[_kategoriTerpilih])
              .toList(); // Ubah hasil filter kembali menjadi List<Produk>

    // Scaffold: kerangka dasar halaman
    return Scaffold(
      // AppBar: bilah navigasi atas halaman beranda
      appBar: AppBar(
        // Row: ikon kasir dan teks nama aplikasi secara horizontal
        title: const Row(
          mainAxisSize: MainAxisSize.min, // Lebar baris menyesuaikan isi
          children: [
            // Icon: simbol mesin kasir POS berwarna emas
            Icon(Icons.point_of_sale, color: Colors.amber, size: 24),
            SizedBox(width: 8), // Jarak horizontal 8 piksel
            // Text: judul nama aplikasi
            Text(
              'SmartKasir',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        // actions: tombol aksi di pojok kanan AppBar
        actions: [
          // IconButton: tombol lonceng notifikasi penjualan
          IconButton(
            tooltip: 'Notifikasi Penjualan',
            icon: const Icon(Icons.notifications_none),
            onPressed: () {}, // Placeholder aksi tombol notifikasi
          ),
        ],
      ),
      // Column: susunan vertikal 3 blok utama dari atas ke bawah
      body: Column(
        children: [
          // =============================================================
          // BLOK 1: BANNER RINGKASAN PENJUALAN TOKO HARI INI (OMZET KASIR)
          // =============================================================
          // Container: kartu ringkasan omzet dengan gradasi warna
          Container(
            margin: const EdgeInsets.all(12), // Jarak luar dari tepi layar
            padding: const EdgeInsets.all(16), // Jarak dalam ke konten kartu
            decoration: BoxDecoration(
              // Gradasi linier dari Biru Navy ke Biru Terang
              gradient: const LinearGradient(
                colors: [Colors.teal, Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12), // Sudut melengkung 12
              boxShadow: [
                // Bayangan elevasi di bawah kartu omzet
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Row: teks omzet di kiri dan badge transaksi di kanan
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column: label omzet dan nominal rupiah secara vertikal
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Penjualan Hari Ini',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 4), // Jarak vertikal 4 piksel
                    // Text: nominal omzet terformat
                    Text(
                      _formatRupiah(845000), // Memanggil fungsi format Rupiah
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Container: kapsul penanda jumlah transaksi berhasil
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2), // Semi-transparan
                    borderRadius: BorderRadius.circular(20), // Bentuk kapsul
                  ),
                  // Row: ikon struk berjajar dengan jumlah transaksi
                  child: const Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white, size: 16),
                      SizedBox(width: 4), // Spasi 4 piksel
                      Text(
                        '34 Transaksi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // =============================================================
          // BLOK 2: PERULANGAN FILTER KATEGORI CEPAT (HORIZONTAL CHIPS)
          // =============================================================
          // SizedBox: membatasi tinggi baris tombol filter (42 dp)
          SizedBox(
            height: 42,
            // ListView.builder: PERULANGAN membangun daftar tombol geser horizontal
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Arah gulir menyamping
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _kategoriList.length, // Batas loop sebanyak 4 item
              itemBuilder: (context, index) {
                // Boolean: apakah tombol kategori ini sedang aktif
                final isSelected = _kategoriTerpilih == index;

                // Padding: jarak pemisah antar tombol filter
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  // FilterChip: tombol interaktif penyaring kategori
                  child: FilterChip(
                    // Label teks kategori sesuai indeks saat ini
                    label: Text(_kategoriList[index]),
                    selected: isSelected, // Status aktif/tidaknya tombol
                    selectedColor: const Color(
                      0xFF1E3A8A,
                    ), // Biru Navy saat terpilih
                    // PERCABANGAN gaya teks: putih jika aktif, hitam jika tidak
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    // Event handler saat tombol diklik
                    onSelected: (val) {
                      // setState: perbarui variabel state dan picu render ulang
                      setState(() {
                        _kategoriTerpilih = index; // Ubah indeks kategori aktif
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8), // Jarak pemisah vertikal 8 piksel
          // =============================================================
          // BLOK 3: PERULANGAN GRIDVIEW KATALOG PRODUK KASIR 2 KOLOM
          // =============================================================
          // Expanded: katalog memenuhi sisa ruang layar ke bawah
          Expanded(
            // PERCABANGAN tampilan: jika hasil filter kosong, tampilkan pemberitahuan
            child: listTampil.isEmpty
                ? const Center(
                    child: Text('Tidak ada produk pada kategori ini'),
                  )
                // GridView.builder: PERULANGAN membangun kartu produk 2 kolom
                : GridView.builder(
                    padding: const EdgeInsets.all(12), // Jarak luar kisi
                    // Konfigurasi tata letak kisi (grid)
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Tepat 2 kolom kartu
                          childAspectRatio: 0.90, // Rasio lebar:tinggi kartu
                          crossAxisSpacing: 12, // Jarak horizontal antar kolom
                          mainAxisSpacing: 12, // Jarak vertikal antar baris
                        ),
                    itemCount:
                        listTampil.length, // Jumlah kartu sebanyak listTampil
                    itemBuilder: (context, index) {
                      // Objek produk yang sedang diproses pada perulangan ini
                      final produk = listTampil[index];

                      // Card: kartu pembungkus informasi produk
                      return Card(
                        elevation: 2, // Ketinggian bayangan kartu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior:
                            Clip.antiAlias, // Potong konten mengikuti sudut
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------------------------------------------------
                            // BAGIAN 1: FOTO PRODUK + BADGE PROMO DISKON
                            // -------------------------------------------------
                            // Stack: menumpuk badge promo di atas foto produk
                            Stack(
                              children: [
                                // Image.network: memuat foto produk dari URL internet
                                Image.network(
                                  produk.gambarUrl,
                                  height: 125, // Tinggi gambar 125 piksel
                                  width: double.infinity, // Lebar penuh kartu
                                  fit: BoxFit.cover, // Skala proporsional tanpa distorsi
                                  // Indikator saat gambar sedang diunduh
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        // Gambar selesai diunduh
                                        if (loadingProgress == null)
                                          return child;
                                        return Container(
                                          height: 125,
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  // Tampilan pengganti jika internet putus atau URL gagal
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        height: 125,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 36,
                                          ),
                                        ),
                                      ),
                                ),

                                // --- PERCABANGAN LOGIKA BADGE PROMO DISKON ---
                                // Badge hanya tampil jika diskonPersen > 0
                                if (produk.diskonPersen > 0)
                                  // Positioned: kunci posisi badge di pojok kiri atas foto
                                  Positioned(
                                    top: 6,
                                    left: 6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .red
                                            .shade700, // Merah untuk promo
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'PROMO ${produk.diskonPersen}%', // Nilai diskon
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            // -------------------------------------------------
                            // BAGIAN 2: INFORMASI NAMA, STOK, DAN HARGA PRODUK
                            // -------------------------------------------------
                            // Padding: jarak bantalan yang rapat dan presisi
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize
                                    .min, // Pas dengan tinggi konten
                                children: [
                                  // Text: nama barang dagangan
                                  Text(
                                    produk.nama,
                                    maxLines: 1, // Maksimal 1 baris
                                    overflow: TextOverflow
                                        .ellipsis, // Potong dengan "..."
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ), // Jarak rapat 3 piksel
                                  // Memanggil fungsi badge stok (hijau/kuning/merah)
                                  _buildBadgeStok(produk.stok),
                                  const SizedBox(
                                    height: 3,
                                  ), // Jarak ke baris harga
                                  // Row: harga di kiri dan tombol tambah di kanan
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Text: harga jual dalam format Rupiah
                                      Text(
                                        _formatRupiah(produk.harga),
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      // InkWell: area sentuh tombol aksi dengan efek riak
                                      InkWell(
                                        // --- PERCABANGAN PROTEKSI TRANSAKSI KASIR ---
                                        // Jika stok habis (0), onTap dinonaktifkan (null)
                                        // agar kasir tidak bisa menambah barang kosong
                                        onTap: produk.stok == 0 ? null : () {},
                                        borderRadius: BorderRadius.circular(15),
                                        // CircleAvatar: tombol bulat ikon tambah (+)
                                        child: CircleAvatar(
                                          radius: 14,
                                          // PERCABANGAN warna: abu-abu jika habis, Biru Navy jika ada
                                          backgroundColor: produk.stok == 0
                                              ? Colors.grey.shade300
                                              : Colors.teal,
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
