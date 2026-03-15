# One People Mobile

Project ini adalah aplikasi iOS SwiftUI bergaya HRIS untuk kebutuhan employee self-service milik PT. Ekozer.

Repository:

- Source code: `https://github.com/ekoardiantopro-cpu/one-people-mobile`
- Live demo web: `https://ekoardiantopro-cpu.github.io/one-people-mobile/`
- Mockup gallery: `https://ekoardiantopro-cpu.github.io/one-people-mobile/one-people-gallery.html`

Fitur utama:

- Dashboard One People dengan status absensi harian
- Login dengan pengaturan server yang bisa di-expand
- Attendance, approval, izin, roster, aset, dan slip gaji
- Profil akun, pengaturan, dan pesan internal
- Skill Inventory dan Internal Project Marketplace
- AI HR Assistant
- Data mock lokal agar mudah dipreview di Xcode

## Cara Install dan Menjalankan dari GitHub

### Opsi 1: Clone Repository

```bash
git clone https://github.com/ekoardiantopro-cpu/one-people-mobile.git
cd one-people-mobile
open OnePeople.xcodeproj
```

Setelah project terbuka di Xcode:

1. Pilih scheme `One People`
2. Pilih simulator, misalnya `iPhone 14`
3. Jika ingin dijalankan ke device fisik, buka `Signing & Capabilities`
4. Pilih `Team` Apple Developer Anda bila diperlukan
5. Tekan `Run`

### Opsi 2: Download ZIP dari GitHub

1. Buka repository `one-people-mobile` di GitHub
2. Klik `Code`
3. Pilih `Download ZIP`
4. Extract hasil download
5. Buka `OnePeople.xcodeproj` di Xcode
6. Jalankan dengan langkah yang sama seperti opsi clone

## Build via Terminal

Anda juga bisa build dari terminal:

```bash
xcodebuild -project OnePeople.xcodeproj -scheme "One People" -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 14' build
```

## Struktur Project Utama

- `OnePeople/` berisi source SwiftUI aplikasi
- `OnePeople.xcodeproj/` berisi konfigurasi project Xcode
- `docs/` berisi live demo, gallery, dan portfolio presentation untuk GitHub Pages

## Catatan

- App ini memakai mock data lokal, jadi belum perlu backend untuk preview UI
- URL server default yang digunakan di mockup adalah `https://hcm.ekozer.com`
- Untuk live demo web, GitHub Pages hanya menampilkan simulasi interaktif HTML, bukan menjalankan app iOS asli

## Referensi Desain Modul

- One People mengambil pola pengalaman aplikasi employee self-service dengan modul seperti `Personal Info`, `Attendance`, `Permission`, `Leave Info`, `Approval`, `Roster`, `Payroll`, `Skill Inventory`, `Project Marketplace`, dan `AI HR Assistant`
