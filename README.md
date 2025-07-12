# 📡 LocatorBTS – CID Tower Tracker via Termux

**LocatorBTS** adalah alat investigasi digital berbentuk binary untuk mendeteksi posisi BTS (menara seluler) berdasarkan CID, LAC, MCC, dan MNC langsung dari perangkat Android menggunakan Termux.

Dikembangkan untuk keperluan OSINT, investigasi pribadi, atau pelacakan sinyal, alat ini cocok untuk lingkungan stealth dan taktis.

---

## ⚙️ Fitur

- Ambil otomatis MCC, MNC, LAC, CID dari SIM aktif
- Dapatkan lokasi GPS langsung dari perangkat
- Cocokkan ke database `510.csv` untuk data tower publik

---

## 📲 PERSYARATAN WAJIB

Sebelum menjalankan file binary `locator`, pastikan kamu:

### ✅ 1. Install Termux & Termux:API
```bash
pkg update && pkg install termux-api
```
### 2. Aktifkan izin Lokasi dengan execute command
```bash
termux-location
```

