# GitHub Upload and Install Guide

Panduan ini dipakai untuk mengunggah, membagikan, dan menjalankan project `One People` dari GitHub.

## Repository Aktif

- Source repository: `https://github.com/ekoardiantopro-cpu/one-people-mobile`
- Live demo: `https://ekoardiantopro-cpu.github.io/one-people-mobile/`

## File yang Perlu Ada di Repository

Upload isi root project berikut:

- `OnePeople/`
- `OnePeople.xcodeproj/`
- `docs/`
- `README.md`
- `GITHUB_UPLOAD.md`
- `.gitignore`

Jangan upload:

- `build/`
- `*.xcarchive`
- `DerivedData`
- `xcuserdata`

## Cara Push dengan Git Command

Jika repository GitHub sudah dibuat kosong, jalankan:

```bash
cd /Users/ekozer/Documents/hcis
git init
git add .
git commit -m "Initial One People iOS app"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

Ganti `USERNAME/REPOSITORY` dengan alamat repo GitHub Anda.

Contoh untuk project ini:

```bash
cd /Users/ekozer/Documents/hcis
git remote add origin https://github.com/ekoardiantopro-cpu/one-people-mobile.git
git push -u origin main
```

## Cara Install Project dari GitHub di Mac Lain

### Metode Clone

```bash
git clone https://github.com/ekoardiantopro-cpu/one-people-mobile.git
cd one-people-mobile
open OnePeople.xcodeproj
```

### Metode Download ZIP

1. Buka repository GitHub
2. Klik `Code`
3. Pilih `Download ZIP`
4. Extract ZIP
5. Buka `OnePeople.xcodeproj`

## Langkah Menjalankan App di Xcode

1. Buka `OnePeople.xcodeproj`
2. Pilih scheme `One People`
3. Pilih simulator seperti `iPhone 14`
4. Jika perlu, buka `Signing & Capabilities`
5. Pilih `Team`
6. Jika menjalankan di device fisik, gunakan bundle id unik bila dibutuhkan
7. Tekan `Run`

## Build via Terminal

```bash
xcodebuild -project OnePeople.xcodeproj -scheme "One People" -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 14' build
```

## GitHub Pages untuk Demo Web

Repository ini juga memiliki demo web berbasis GitHub Pages.

Untuk mengaktifkannya:

1. Buka repository di GitHub
2. Masuk ke `Settings`
3. Pilih `Pages`
4. Pada `Build and deployment`, pilih:
   - `Source`: `Deploy from a branch`
   - `Branch`: `main`
   - `Folder`: `/docs`
5. Klik `Save`

Setelah aktif, demo akan tersedia di:

`https://USERNAME.github.io/REPOSITORY/`

Contoh project ini:

`https://ekoardiantopro-cpu.github.io/one-people-mobile/`

## Catatan

- GitHub Pages hanya menampilkan demo web interaktif, bukan menjalankan aplikasi iOS SwiftUI asli
- Untuk menjalankan aplikasi sebenarnya, tetap gunakan Xcode dan iOS Simulator atau device fisik
