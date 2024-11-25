# Setaksetik Mobile

Sebuah aplikasi yang didekasikan untuk pecinta dan calon pecinta steak!

Versi _mobile_ dari aplikasi yang sudah ada di [Setaksetik Web](http://muhammad-faizi-setaksetik.pbp.cs.ui.ac.id/)

---

# Table of Contents
1. [Anggota Kelompok](#anggota-kelompok)
2. [Deskripsi Aplikasi](#deskripsi-aplikasi)
3. [Daftar Modul](#daftar-modul)
4. [Initial Dataset](#initial-dataset)
5. [Role atau Peran Pengguna](#role-atau-peran-pengguna)
6. [Alur Pengintegrasian](#alur-pengintegrasian-dengan-web-service)
7. [Tautan Deployment](#tautan-deployment)


# Anggota Kelompok
- 2306211401  |  Haliza Nafiah Syakira Arfa
- 2306244955  |  Muhammad Faizi Ismady Supardjo
- 2306165692  |  Nadira Aliya Nashwa
- 2306165963  |  Aimee Callista Ferlintera Prudence Ernanto
- 2306217304  |  Clara Aurelia Setiady


# Deskripsi Aplikasi
Untuk menjawab kebingungan pengguna dalam memilih menu steak yang tepat, **Setaksetik** hadir sebagai solusi lengkap bagi para pecinta steak. Aplikasi ini dirancang dengan beragam fitur yang tidak hanya memudahkan pengguna dalam memilih menu, tetapi juga memberikan pengalaman bersantap yang lebih personal dan menyenangkan. 

**Setaksetik** dikembangkan dengan berbagai modul yang mendukung kemudahan dalam pemilihan menu serta kenyamanan pengguna. Fitur autentikasi memungkinkan pengguna untuk login dengan mudah. Pengguna dapat melakukan _explore_ dari banyaknya menu yang tersedia beserta filter, lalu selanjutnya melakukan _booking_ restoran dan memberikan _review_. Selain itu, terdapat juga fitur _spin the wheel_ yang merupakan elemen hiburan dalam menentukan pilihan menu, serta fitur _meat up_ untuk melihat pengguna lain dengan _public wishlist_ dan preferensi yang serupa.

Saat ini, aplikasi ini dirancang untuk pecinta steak berbasis Jakarta. Dataset yang digunakan adalah menu dan _steakhouse_ yang tersebar di segala penjuru Jakarta. Jadi, jika menjejakkan kaki di Jakarta dan mendambakan steak, tak perlu bingung tak perlu ragu, **Setaksetik** akan membantu!


# Daftar Modul
1. **Autentikasi**
   - Pengguna register dan membuat akun (username, name, role, password and password confirmation)
   - Pengguna melakukan aktivitas login dan logout.

2. **Explore Menu** (Steak Lover, Steakhouse Owner) : Nadira
   - Pengguna dapat memfilter menu berdasarkan:
     - Jenis beef
     - Kota
     - Harga maksimum
     - Search bar untuk nama menu

3. **Spin the Wheel - Makan apa hari ini** (Steak Lover) : Haliza
   - Pilih jenis preferensi beef untuk add all, atau add manual makanan yang akan di-spin
   - Pengguna dapat menambah atau menghapus daftar menu yang dijadikan opsi pada _spin wheel_
   - Pengguna melakukan _spin_ yang selanjutnya dapat disimpan pada _spin history_.

4. **Rating dan Review** (Steak Lover, Steakhouse Owner) : Clara
   - Steak Lover dapat memberikan _review_ dan _rating_ pada setiap menu yang telah dicoba.
   - Steakhouse Owner dapat memberikan balasan komentar terhadap _review_.
   - Admin dapat menghapus _review_ Steak Lover.

5. **Meat Up - Teman Makan** (Steak Lover) : Aimee
   - Steak Lover dapat memilih satu menu untuk dijadikan _public wishlist_.
   - _Public wishlist_ dapat dilihat siapapun, sehingga Steak Lover bisa mencari teman makan dari _wishlist_ dengan preferensi yang serupa.

6. **Booking Restoran** (Steak Lover, Steakhouse Owner) : Faizi
   - Booking dilakukan berdasarkan restoran, nama pemesan, dan jumlah orang.
   - Pengguna memesan berdasarkan jumlah porsi.
   - Riwayat booking yang sudah dilakukan.
   - Steak house owner bisa approve booking

7. **Claim Restoran** (Steakhouse Owner)
   - Steakhouse Owner melakukan _ownership claim_ terhadap restoran yang tersedia.
   - Admin dapat melakukan _revoke ownership_ dari Steakhouse Owner.


# Initial Dataset
Kategori utama produk berupa menu _steak_ unggulan dari berbagai _steakhouse_ di Jakarta.

- Sumber initial dataset didapatkan dari [Kaggle](https://www.kaggle.com/datasets/miradelimanr/steakhouse-jakarta?resource=download).
- Dataset yang telah dibersihkan dan difilter terdapat pada link [Sheets](https://docs.google.com/spreadsheets/d/1NDPuzQpybnalNUVGGFEaG_dutWjPqhmTbliIAJ24xuU/edit?usp=sharing).


# Role atau Peran Pengguna
1. **Steak Lover - Pengguna Umum**
   - Akses:
     - Mengakses seluruh konten publik seperti daftar menu, informasi restoran, harga, dan ulasan.
     - Membuat akun dan login/logout menggunakan akun yang sudah dibuat
   - Fitur:
     - **Spin the Wheel**: Menggunakan fitur "spin the wheel" untuk memilih menu secara acak.
     - **Meat Up**: Menyimpan menu favorit yang ingin dicoba di masa depan dan melihat pengguna lain dengan preferensi sama.
     - **Rating dan Review**: Memberi _rating_ dan _review_ pada menu yang sudah dicoba.
     - **Booking Restoran**: Melakukan pemesanan tempat di restoran dan melihat riwayat booking.
       
2. **Admin**
   - Akses:
     - Membuat perubahan seperti edit dan delete informasi yang terdapat pada app.
   - Fitur:
     - **Pengelolaan Menu & Restoran**: Menambah, mengedit, atau menghapus informasi tentang menu.
     - **Manajemen Ulasan**: Mengedit atau menghapus ulasan yang tidak sesuai.
     - **Manajemen Claim Restoran**: Melakukan penghapusan _ownership_ restoran.
       
3. **Steakhouse Owner**
   - Akses:
     - Mengelola proses booking restoran yang dimiliki.
   - Fitur:
     - **Membalas ulasan**: Menjawab ulasan yang diberikan Steak Lover.
     - **Manajemen Booking**: Memantau dan mengelola booking dari _steakhouse_ yang telah di-_claim_.
    

# Alur Pengintegrasian dengan Web Service
Secara umum, alur untuk request adalah **Flutter** &rarr; (HTTP Request) &rarr; **Django Endpoint** &rarr; (Pemrosesan Data) &rarr; **Database**.

Selanjutnya, alur untuk pengiriman data adalah **Database** &rarr; (Fetch Data) &rarr; **Django** &rarr; (Response JSON) &rarr; **Flutter**.

Berikut langkah-langkah implementasinya:
- Pada Flutter ditambahkan package HTTP untuk mengelola request HTTP.
- Dibuat model pada Flutter yang sesuai dengan struktur JSON model pada Django.
- Fungsi di Flutter dibuat dengan mengaitkan request HTTP ke endpoint Django.
- Autentikasi (Login, Register, Logout) divalidasi dan dikirimkan token cookie oleh Django, Flutter menyimpan cookie tersebut.


# Tautan Deployment
Tautan deployment aplikasi **Setaksetik**. (TBA)


