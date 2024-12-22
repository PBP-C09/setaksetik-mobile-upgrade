# SetakSetik Mobile

Aplikasi yang didedikasikan untuk pecinta dan calon pecinta steak!

Versi _mobile_ dari aplikasi yang sudah ada di [SetakSetik Web](http://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/).

---

## Table of Contents
1. [Anggota Kelompok](#anggota-kelompok)
2. [Deskripsi Aplikasi](#deskripsi-aplikasi)
3. [Daftar Modul](#daftar-modul)
4. [Initial Dataset](#initial-dataset)
5. [Role atau Peran Pengguna](#role-atau-peran-pengguna)
6. [Alur Pengintegrasian](#alur-pengintegrasian-dengan-web-service)
7. [Rancangan](#rancangan-desain)
8. [Tautan Deployment](#tautan-deployment)
9. [Video Storyline](#dokumentasi)

---

## Anggota Kelompok
- 2306211401  |  Haliza Nafiah Syakira Arfa
- 2306244955  |  Muhammad Faizi Ismady Supardjo
- 2306165692  |  Nadira Aliya Nashwa
- 2306165963  |  Aimee Callista Ferlintera Prudence Ernanto
- 2306217304  |  Clara Aurelia Setiady

---

## Deskripsi Aplikasi
Untuk menjawab kebingungan pengguna dalam memilih menu _steak_ yang tepat, **SetakSetik** hadir sebagai solusi lengkap bagi para pecinta _steak_. Aplikasi ini dirancang dengan beragam fitur yang tidak hanya memudahkan pengguna dalam memilih menu, tetapi juga memberikan pengalaman bersantap yang lebih personal dan menyenangkan. 

**SetakSetik** dikembangkan dengan berbagai modul yang mendukung kemudahan dalam pemilihan menu serta kenyamanan pengguna. Fitur autentikasi memungkinkan pengguna untuk login dengan mudah. Pengguna dapat melakukan _explore_ dari banyaknya menu yang tersedia beserta filter, lalu selanjutnya melakukan _booking_ restoran dan memberikan _review_. Selain itu, terdapat juga fitur _spin the wheel_ yang merupakan elemen hiburan dalam menentukan pilihan menu, serta fitur _meat up_ untuk melihat pengguna lain dengan _public wishlist_ dan preferensi yang serupa.

Saat ini, aplikasi ini dirancang untuk pecinta _steak_ berbasis Jakarta. Dataset yang digunakan adalah menu dan _steakhouse_ yang tersebar di segala penjuru Jakarta. Jadi, jika menjejakkan kaki di Jakarta dan mendambakan _steak_, tak perlu bingung tak perlu ragu, **SetakSetik** akan membantu!

---

## Daftar Modul

1. **Autentikasi**
   - Mendaftar dan membuat akun (username, name, role, password, dan konfirmasi password).
   - Login dan logout.

2. **Explore Menu** _(Steak Lover, Steakhouse Owner, Admin)_ : Nadira
   - Fitur filter berdasarkan:
     - Jenis beef.
     - Kota.
     - Harga maksimum.
     - Nama menu melalui _search bar_.
   - Explore untuk Steakhouse Owner terintegrasi dengan fitur Claim.
   - Admin dapat menambah, mengedit, serta menghapus daftar menu yang tersedia.

3. **Spin the Wheel - Makan Apa Hari Ini** _(Steak Lover)_ : Haliza
   - Pilih preferensi beef untuk menambahkan menu ke daftar spin.
   - Tambah/hapus daftar menu dari _spin wheel_.
   - Simpan hasil spin ke dalam _spin history_.

4. **Rating dan Review** _(Steak Lover, Steakhouse Owner)_ : Clara
   - Steak Lover dapat memberi _rating_ dan _review_ pada menu yang dicoba.
   - Steakhouse Owner dapat membalas _review_.
   - Admin dapat menghapus _review_ yang tidak sesuai.

5. **Meat Up - Teman Makan** _(Steak Lover)_ : Aimee
   - Mengirim pesan ke Steak Lover lainnya.
   - Mengedit pesan yang telah dikirim.
   - Melakukan _reject_ terhadap pesan Meat Up dari Steak Lover lain.

6. **Booking Restoran** _(Steak Lover, Steakhouse Owner)_ : Faizi
   - _Booking_ berdasarkan restoran, nama pemesan, dan jumlah orang.
   - Melihat riwayat _booking_.
   - Steakhouse Owner dapat menyetujui _booking_.

7. **Claim Restoran** _(Steakhouse Owner, Admin)_
   - Steakhouse Owner dapat mengklaim kepemilikan restoran.
   - Admin dapat mencabut klaim kepemilikan restoran.

---

## Initial Dataset

**Kategori:** Menu _steak_ dari berbagai _steakhouse_ di Jakarta.

- **Sumber:** [Kaggle](https://www.kaggle.com/datasets/miradelimanr/steakhouse-jakarta?resource=download).
- **Dataset Terproses:** [Google Sheets](https://docs.google.com/spreadsheets/d/1NDPuzQpybnalNUVGGFEaG_dutWjPqhmTbliIAJ24xuU/edit?usp=sharing).

---

## Role atau Peran Pengguna

### 1. **Steak Lover (Pengguna Umum)**
- **Akses:**
  - Mengakses konten publik (daftar menu, informasi restoran, harga, dan ulasan).
  - Membuat akun dan login/logout.
- **Fitur:**
  - **Explore:** Menelusuri pilihan menu.
  - **Spin the Wheel:** Menentukan menu secara acak.
  - **Meat Up:** Menemukan teman makan dengan mengirim pesan ke Steak Lover lain.
  - **Rating dan Review:** Memberi _rating_ dan _review_ pada menu.
  - **Booking Restoran:** Memesan tempat dan melihat riwayat _booking_.

### 2. **Steakhouse Owner**
- **Akses:**
  - Mengelola proses booking restoran.
- **Fitur:**
  - Membalas ulasan.
  - Memantau dan mengelola booking restoran yang diklaim.

### 3. **Admin**
- **Akses:**
  - Mengelola informasi pada aplikasi.
- **Fitur:**
  - **Pengelolaan Menu & Restoran:** Menambah, mengedit, atau menghapus menu.
  - **Manajemen Review:** Menghapus ulasan yang tidak sesuai.
  - **Manajemen Claim Restoran:** Mencabut klaim kepemilikan restoran.

---

## Alur Pengintegrasian dengan Web Service

### Alur Request dan Response:
1. **Flutter** &rarr; (HTTP Request) &rarr; **Django Endpoint** &rarr; (Pemrosesan Data) &rarr; **Database**.
2. **Database** &rarr; (Fetch Data) &rarr; **Django** &rarr; (Response JSON) &rarr; **Flutter**.

### Langkah Implementasi:
- Gunakan package `HTTP` di Flutter untuk request.
- Buat model di Flutter sesuai struktur JSON dari Django.
- Implementasikan fungsi untuk menghubungkan request HTTP ke endpoint Django.
- Pastikan autentikasi menggunakan token cookie Django, lalu disimpan di Flutter.

---

## Rancangan Desain
**Rancangan Awal:** [Google Drive](https://drive.google.com/drive/folders/1O0XBPTdz9gD1TJ1LrmA1kOUIPMY3dUva?usp=drive_link).

---

## Tautan Deployment
**Aplikasi via App Center:** [SetakSetik Mobile](https://install.appcenter.ms/orgs/pbp-c09/apps/setaksetik/distribution_groups/public/releases/10).

---

## Dokumentasi
- **Video Storyline:** [YouTube](https://youtu.be/KW6MbHLqILY?si=hb9QnD6wYGYt6XDk).
- **Dokumentasi Aplikasi**: [Google Drive](https://drive.google.com/drive/folders/1RZED_cz4inNtOVT0_EubHG1Jb0msE876?usp=drive_link).
