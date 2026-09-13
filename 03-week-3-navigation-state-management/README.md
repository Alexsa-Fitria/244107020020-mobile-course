# **Praktikum 3 — Uji ketiga state**

---
### 1. Salin kode di atas ke project ToDo Anda (atau project terpisah) dan jalankan. Amati tampilan loading selama 2 detik pertama.

Aplikasi memunculkan indikator pemuatan terlebih dahulu, lalu menyajikan daftar data secara otomatis setelah proses unduh selesai.

### 2.Ubah build() sementara untuk melempar error: throw Exception('Gagal terhubung ke server');. Jalankan dan amati UI error beserta tombol Coba lagi.
State error berfungsi untuk menginformasikan kendala koneksi kepada pengguna sekaligus menyediakan opsi interaktif agar mereka bisa mengulang proses pengambilan data.

### 3.Tekan tombol Coba lagi, ref.invalidate membuat provider dijalankan ulang. Pulihkan kode, pastikan state success tampil.
ref.invalidate() dimanfaatkan untuk memicu pembaruan ulang pada provider sehingga data segar berhasil ditarik kembali ke antarmuka

### 4.Refleksikan: mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting?
Menampilkan informasi lama (stale data) disertai indikator penyegaran jauh lebih nyaman bagi pengguna dibanding membuat layar kosong mendadak, karena mereka masih bisa membaca isi sebelumnya tanpa mengalami gangguan visual (layout shift). Pola semacam ini sangat krusial saat kondisi jaringan kurang stabil, proses unduh memakan waktu, atau ketika informasi sebelumnya masih relevan untuk dilihat sementara, seperti pada platform berita, lini masa media sosial, maupun dasbor analitik.

# **AI Verification Checklist**

---

### 1. Apakah state diubah secara immutable (tidak ada state.add() atau mutasi list langsung)?
Ya. State pada aplikasi sudah diubah secara immutable. Tidak ditemukan penggunaan mutasi langsung terhadap list yang sedang digunakan, sehingga setiap pembaruan menghasilkan nilai/instance baru.

### 2. Apakah ref.watch hanya dipakai di dalam build, dan ref.read di callback?
Ya. Pemantauan state menggunakan ref.watch diterapkan di dalam method build(), sedangkan eksekusi pemicu seperti ref.invalidate ditempatkan pada fungsi callback event.

### 3. Apakah ketiga state AsyncValue benar-benar ditangani (bukan hanya success)?
Ya. Ketiga kondisi AsyncValue (loading, error, dan data/success) telah ditangani secara komprehensif pada antarmuka aplikasi.

### 4. Apakah provider dideklarasikan dengan tipe eksplisit dan tidak duplikat dengan provider lain?
Ya. Provider dideklarasikan dengan tipe data yang terstruktur dengan jelas dan dihindari dari duplikasi nama agar pengelolaan state tetap bersih.

### 5. Apakah kode AI memakai API Riverpod versi lama (StateProvider antipattern, StateNotifierProvider usang, atau Consumer bertingkat yang tidak perlu)? Perbaiki ke pola Notifier/ConsumerWidget.
Ya. Implementasi telah diarahkan menggunakan pola modern berbasis AsyncNotifier dan ConsumerWidget tanpa menggunakan antipattern lama.

### 6. Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?
Belum sepenuhnya lolos. Berdasarkan pengujian awal, terdapat kendala sintaks pada file lib/providers/product_provider.dart (seperti kesalahan token pada pendeklarasian AsyncNotifier dan penamaan identifier) serta ketidaksesuaian nama provider (productStatsProvider) yang dipanggil pada halaman. Perbaikan lanjutan sedang dilakukan agar perintah flutter analyze dan flutter test dapat berjalan sukses tanpa error.

#### *Flutter Analyze*
![Flutter Analyze 1](async_value/screenshot/fultter%20analyze1.png)

### *Flutter Test*
![Flutter Test 1](async_value/screenshot/fultter%20test1.png)


# **Checklist Verifikasi Mandiri**

---

- [x] Navigasi GoRouter bekerja: pindah halaman, back, dan akses path detail langsung.
- [x] ProviderScope membungkus root aplikasi; state ToDo bertahan saat berpindah halaman.
- [x] UI AsyncValue menangani loading, error, dan success, bukan hanya success.
- [ ] `flutter analyze` tanpa issue dan semua test lulus 
- [x] Hasil AI diverifikasi dan didokumentasikan pada folder terkait.


# **Refleksi**

---

**1. Kapan `setState` masih cukup, dan kapan state harus naik ke Riverpod?**

`setState` sudah sangat memadai jika data atau perubahan tampilannya hanya bersifat lokal di dalam satu widget saja (misalnya status toggle atau animasi kecil). Namun, jika state harus dibagikan ke banyak halaman, bertahan saat pindah rute, atau melibatkan proses asinkron, maka wajib dinaikkan menggunakan Riverpod.

**2. Apa perbedaan `context.go` dan `context.push`, dan kapan masing-masing tepat digunakan?**

`context.go()` digunakan untuk berpindah halaman sekaligus mereset riwayat navigasi sebelumnya, yang sangat pas untuk menu utama atau bottom navigation. Sebaliknya, context.push() menumpuk halaman baru di atas halaman saat ini dengan menyediakan tombol back, sehingga ideal dipakai saat membuka halaman detail.

**3. Bagaimana `AsyncValue` mencegah bug dibanding tiga boolean terpisah?**

`AsyncValue` membungkus status asinkron (loading, error, dan data) ke dalam satu wadah yang eksklusif. Hal ini mencegah terjadinya human error atau bug logika—seperti kondisi mustahil di mana variabel loading dan error bernilai true secara bersamaan—yang kerap terjadi jika menggunakan tiga variabel boolean terpisah.

**4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?**

Beberapa bagian kode dari AI perlu disesuaikan dengan struktur proyek, seperti memperbaiki sintaks deklarasi `AsyncNotifier` dan penamaan identifier yang sempat error saat dianalisis. Selain itu, pemisahan `ref.watch` di dalam method `build` dan `ref.readdi` dalam callback aksi tombol. Lalu, menyesuaikan struktur test dan pengelolaan state list secara immutable guna memastikan aplikasi tidak melakukan mutasi langsung serta mampu melewati tahap pengujian dengan baik.