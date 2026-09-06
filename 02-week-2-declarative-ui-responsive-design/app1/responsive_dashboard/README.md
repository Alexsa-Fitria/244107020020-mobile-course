# **AI Prompt Challenge**

---
## 1. Prompt Desain.

Prompt:

>*"Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Jelaskan trade-off responsif dan aksesibilitasnya."*

Analisis & Keputusan:
Penggunaan GridView sangat praktis untuk menyusun kartu informasi secara otomatis lewat crossAxisCount tanpa perlu menghitung baris secara manual, sekaligus terstruktur rapi bagi screen reader. Di sisi lain, kombinasi LayoutBuilder + Column memang memberikan kebebasan posisi, tetapi lebih rentan memicu overflow jika kontennya dinamis. Kita akhirnya menggabungkan keduanya—menggunakan LayoutBuilder untuk memantau breakpoint layar, lalu merender GridView di dalamnya agar tampilan responsif dan tetap aman dari error.

## 2. Prompt penguatan konsep.

Prompt:

>*"Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya."*

Penjelasan & Contoh:
Widget Expanded butuh batasan lebar yang jelas dari induknya. Jika Row dibungkus dalam parent dengan lebar tak terbatas (seperti SingleChildScrollView horizontal), Expanded akan memicu error infinite width.

Contoh Kode Gagal:
```dart
// ERROR: Infinite width
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      Expanded(child: Text('Teks Error')),
    ],
  ),
)
```
Contoh Perbaikan:
```dart
// PERBAIKAN: Beri batas lebar eksplisit atau gunakan Flexible/SizedBox
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      SizedBox(
        width: 200,
        child: Text('Teks Aman'),
      ),
    ],
  ),
)
```

## 3. Verification prompt.

Prompt:

>*"Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"*

Hasil Tinjauan Mandiri:

Uji Adaptif Layar Sempit (<600px): Berdasarkan evaluasi ulang, struktur tata letak dipastikan tetap aman. Ketika layar menyusut di bawah batas tersebut, sistem otomatis menyesuaikan tampilan menjadi satu kolom linier guna menghindari potensi elemen terpotong.

Validasi Aksesibilitas: Aspek aksesibilitas tetap diprioritaskan melalui penyematan label Semantics pada elemen interaktif utama, sehingga pengguna yang mengandalkan pembaca layar tetap bisa mendapatkan informasi secara akurat.

Kompatibilitas Komponen: Seluruh daftar widget yang diimplementasikan (LayoutBuilder, GridView, Card, CupertinoSwitch, Semantics) merupakan pustaka bawaan yang sudah stabil dan resmi didukung penuh oleh Flutter SDK.

## 4. Dokumentasi Bukti Pengujian

<details>
<summary><b>Screenshot Tampilan Layar Sempit (1 Kolom)</b></summary>
<p></p>

![Tampilan Layar Sempit](screenshot/Academic%20Overview%20iPad%20Min.png)

</details>

<details>
<summary><b>Screenshot Tampilan Layar Lebar (2 Kolom)</b></summary>
<p></p>

![Tampilan Layar Lebar](screenshot/Academic%20Overview%20Samsung%20Galaxy%20S8+.png)

</details>

---

# **Refactoring Challenge**

---

## 1. Ekstrak Kartu Informasi Menjadi Widget Reusable:
   Membuat widget `InfoCard` yang menerima parameter `title` dan `value` untuk menghindari duplikasi kode pada kartu statistik:

   ```dart
   class InfoCard extends StatelessWidget {
     const InfoCard({required this.title, required this.value, super.key});
     
     final String title;
     final String value;

     @override
     Widget build(BuildContext context) {
       return Semantics(
         label: 'Informasi $title bernilai$value',
         child: Card(
           elevation: 2,
           child: Padding(
             padding: const EdgeInsets.all(20),
             child: Row(
               children: [
                 Expanded(
                   child: Text(
                     title,
                     style: Theme.of(context).textTheme.bodyLarge,
                   ),
                 ),
                 Text(
                   value,
                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: Theme.of(context).colorScheme.primary,
                       ),
                 ),
               ],
             ),
           ),
         ),
       );
     }
   }
   ```
## 2. Mengganti Nilai Hardcoded dengan Theme.of(context):
Seluruh warna elemen seperti latar belakang kartu profil, warna teks, hingga aksen warna utama pada angka statistik kini menggunakan skema Theme.of(context) agar bisa beradaptasi secara otomatis ketika mode terang maupun mode gelap diaktifkan.

## 3. Penyusunan Konstanta Breakpoint:
Nilai batas ukuran layar responsif dipusatkan pada satu variabel konstanta di bagian atas file:

``` dart
const double kWideBreakpoint = 700;
```

## 4. Verifikasi Linter Menggunakan flutter analyze:

```bash
flutter analyze
# Output: No issues found! (ran in 1.8s)
```

---

# **Checklist verifikasi**

---

- [x] `flutter analyze` tidak menghasilkan error.
- [x] `flutter test` lulus semua widget test responsif.
- [x] Aplikasi dapat dijalankan pada ukuran layar sempit dan lebar.
- [x] Dark mode memiliki kontras dan teks yang terbaca.
- [x] Struktur widget dapat dijelaskan saat code review.
- [x] Screenshot, folder `test`, dan README sudah tersimpan pada folder tugas Week 2.


---

# **Refleksi**

---

## 1. Perbedaan Cara Berpikir Imperatif dan Declarative saat Membangun UI:
Pada pendekatan imperatif, kita harus menuliskan instruksi langkah-demi-langkah secara manual untuk mengubah status atau tampilan UI (misalnya mencari elemen lalu mengubah warnanya satu per satu secara langsung). Sedangkan pada pendekatan deklaratif (yang digunakan Flutter), kita cukup mendefinisikan struktur tampilan akhir berdasarkan kondisi atau state saat ini, dan framework yang akan mengurus bagaimana cara merender serta memperbaruinya secara otomatis ketika ada perubahan.

## 2. Kapan Expanded Membantu dan Kapan Penggunaannya Justru Menghasilkan Layout Error:
Widget Expanded sangat membantu ketika kita ingin memaksa sebuah anak widget (seperti Row atau Column) untuk mengisi sisa ruang kosong yang tersedia secara fleksibel. Namun, penggunaannya akan menghasilkan error layout (seperti RenderFlex overflow) jika dibungkus di dalam wadah yang ukurannya tidak terbatas (unbounded constraints), misalnya menggunakan ListView atau Column yang tingginya dinamis tanpa batasan pasti.

## 3. Bagaimana Breakpoint dan Theme Memengaruhi Pengalaman Pengguna:
Breakpoint sangat penting untuk memastikan tata letak aplikasi responsif dan nyaman dilihat di berbagai ukuran layar—baik perangkat sempit (ponsel) maupun layar lebar (tablet/desktop). Sementara itu, pengelolaan theme yang baik (mendukung mode terang dan gelap secara dinamis menggunakan Theme.of(context)) menjaga kenyamanan mata pengguna dalam berbagai kondisi pencahayaan serta memberikan konsistensi visual pada aplikasi.

## 4. Apa yang Anda Verifikasi dari Rekomendasi AI Setelah Tugas Inti Selesai:
Setelah tugas utama dan proses refactoring selesai dengan bantuan AI, hal yang diverifikasi meliputi kesesuaian struktur kode dengan standar modul praktikum, memastikan tidak ada error ataupun warning saat menjalankan flutter analyze, serta memastikan seluruh logika pengujian otomatis pada flutter test berhasil lulus (passed) tanpa ada kendala.