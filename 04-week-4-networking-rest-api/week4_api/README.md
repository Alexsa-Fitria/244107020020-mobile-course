# **Uji tiga skenario error**

---

### 1.Jalankan aplikasi dengan internet normal, amati loading lalu daftar 100 posts.

**Bukti:**
![Skenario Normal](screenshots/01_skenario_normal_100_posts.png)

### 2. Matikan internet (mode pesawat), tekan refresh, amati pesan ramah + tombol Coba lagi. Nyalakan kembali internet, tekan Coba lagi.

**Bukti 1 (Saat Internet Dimatikan / Mode Pesawat Aktif):**
![Internet Mati - Muncul Pesan Error](screenshots/02_skenario_internet_mati1.png)

**Bukti 2 (Setelah Internet Dinyalakan Kembali & Tekan Coba Lagi):**
![Internet Nyala - Berhasil Refresh](screenshots/02_skenario_internet_mati2.png)


### 3. Sementara ubah baseUrl menjadi URL salah, amati pesan error koneksi. Kembalikan setelah uji.

**Bukti:**
![URL Salah](screenshots/03_skenario_url_salah.png)

# **Praktikum 3**

---

### Ubah home di main.dart menjadi PagedPostPage, jalankan, dan scroll sampai bawah. Amati: halaman 1 tampil dulu, indikator muncul, data bertambah tanpa reload penuh.

**Bukti:**
![Praktikum 3 - Pagination Berhasil](screenshots/praktikum3_pagination_berhasil.png)