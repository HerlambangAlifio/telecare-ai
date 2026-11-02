# TeleCare AI — prototipe Flutter

Aplikasi ini memakai backend Node.js untuk meminta edukasi kesehatan dari xAI Grok. Chat dokter tetap simulasi offline, bukan layanan dokter aktif.

## Menyiapkan backend

1. Cabut token xAI yang pernah dibagikan dan buat token baru di xAI Console.
2. Salin `backend/.env.example` menjadi `backend/.env` jika file `.env` belum ada. Jika sudah ada, tambahkan/ubah `XAI_API_KEY` di file tersebut. Isi dengan token baru; jangan masukkan token ke Flutter, commit, atau bagikan.
3. Jalankan backend:

   ```powershell
   cd backend
   npm install
   npm start
   ```

Backend lokal mendengarkan di `127.0.0.1:3000`. Endpoint memakai xAI Responses API dengan `store: false`; keluhan tetap diproses oleh xAI untuk menghasilkan jawaban.

## Menjalankan aplikasi

Di terminal lain dari folder proyek:

```powershell
flutter pub get
flutter devices
flutter run
```

URL default `http://10.0.2.2:3000` ditujukan untuk Android Emulator. Di perangkat fisik, backend perlu dapat dijangkau dari jaringan perangkat; atur dan jalankan backend di PowerShell:

```powershell
$env:HOST = "0.0.0.0"
npm start
```

Lalu jalankan Flutter dengan `--dart-define=API_BASE_URL=http://ALAMAT-SERVER:3000`. Gunakan HTTPS untuk deployment/release, bukan HTTP.

Sebelum keluhan dikirim, aplikasi meminta persetujuan dan memberi tahu bahwa data akan dikirim ke xAI. Jangan masukkan nama atau informasi pribadi. Jawaban AI adalah edukasi umum, bukan diagnosis atau pengganti tenaga kesehatan. Jangan membuka backend lokal ke internet tanpa autentikasi dan pembatasan penggunaan.

## Pemeriksaan

```powershell
flutter analyze
flutter test
npm --prefix backend test
```
