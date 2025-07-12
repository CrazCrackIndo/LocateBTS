# 📡 LocateBTS – CID Tower Tracker via Termux

**SkizaLocator** adalah skrip pelacak posisi menara seluler (BTS) berbasis MCC, MNC, LAC, dan CID menggunakan Android + Termux.  
Dikembangkan sebagai bagian dari sistem **SkizaNiza**, alat ini memanfaatkan data langsung dari perangkat untuk mengirim laporan ke **Discord Webhook** secara otomatis.

---

## ⚙️ Fitur

- Deteksi otomatis MCC, MNC, LAC, CID dari SIM Card aktif
- Ambil lokasi GPS dari perangkat (via `termux-location`)
- Cocokkan data tower dengan file referensi `510.csv`
- Kirim hasilnya ke Discord webhook dalam format terstruktur

---

## 📦 Persyaratan

- Perangkat Android dengan SIM aktif
- [Termux](https://f-droid.org/packages/com.termux/) + izin lokasi dan telephony
- File `510.csv` (sudah tersedia di repo ini)
- Internet aktif

---

## 🚀 Cara Menggunakan

### 1. Instalasi di Termux
```bash
pkg update && pkg install termux-api jq
git clone https://github.com/kamu/skizalocator.git
cd skizalocator

bash main.sh

