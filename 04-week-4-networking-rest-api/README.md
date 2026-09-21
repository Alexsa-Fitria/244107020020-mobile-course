# **Uji tiga skenario error**

---

### 1.Jalankan aplikasi dengan internet normal, amati loading lalu daftar 100 posts.

**Bukti:**
![Skenario Normal](week4_api/screenshots/01_skenario_normal_100_posts.png)

### 2. Matikan internet (mode pesawat), tekan refresh, amati pesan ramah + tombol Coba lagi. Nyalakan kembali internet, tekan Coba lagi.

**Bukti 1 (Saat Internet Dimatikan / Mode Pesawat Aktif):**
![Internet Mati - Muncul Pesan Error](week4_api/screenshots/02_skenario_internet_mati1.png)

**Bukti 2 (Setelah Internet Dinyalakan Kembali & Tekan Coba Lagi):**
![Internet Nyala - Berhasil Refresh](week4_api/screenshots/02_skenario_internet_mati2.png)


### 3. Sementara ubah baseUrl menjadi URL salah, amati pesan error koneksi. Kembalikan setelah uji.

**Bukti:**
![URL Salah](week4_api/screenshots/03_skenario_url_salah.png)

# **Praktikum 3**

---

### Ubah home di main.dart menjadi PagedPostPage, jalankan, dan scroll sampai bawah. Amati: halaman 1 tampil dulu, indikator muncul, data bertambah tanpa reload penuh.

**Bukti:**
![Praktikum 3 - Pagination Berhasil](week4_api/screenshots/praktikum3_pagination_berhasil.png)

# **AI Verification Checklist**

---
### 1. Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository?
Jawaban: Lewat repository (CommentRepository). ✅

### 2. Apakah fromJson aman null, atau masih memakai cast langsung yang bisa crash?
Jawaban: Ya, menggunakan defensive casting seperti (json['postId'] as num?)?.toInt() ?? 0. ✅

### 3. Apakah semua tipe DioExceptionType (timeout, connectionError, badResponse) dipetakan ke pesan pengguna?
Jawaban: Ya, ada friendlyErrorMessage yang menangani timeout, connectionError, dan badResponse. ✅

### 4. Apakah baseUrl/timeout terpusat di satu client, bukan tersebar di tiap method?
Jawaban: Ya, baseUrl ada di api_client.dart, tapi timeout masih tersebar di dalam method fetchComments. ⚠️ 
sudah diperbaiki. ✅

### 5. Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path? Tambahkan minimal 1 edge case sendiri.
Jawaban: Ya, ada test dengan json = <String, dynamic>{}. ✅

### 6. Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?
Jawaban: Ya, lolos tanpa warning. ✅
**Bukti**
![Flutter Analyze & Test](ai_challenge_comments/screenshots/flutter_analyze_dan_flutter_test.png)