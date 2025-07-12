#!/bin/bash

# Check dependencies
echo "[*] Menyiapkan lingkungan..."
pkg update -y && pkg install -y termux-api jq

# Cek file 510.csv
if [ ! -f "510.csv" ]; then
    echo "⚠️ File 510.csv tidak ditemukan. Pastikan file berada di direktori yang sama."
    exit 1
fi

# Ambil data tower dari termux
echo "[*] Mengambil data telephony..."
DATA=$(termux-telephony-cellinfo)
MCC=$(echo "$DATA" | jq -r '.[0].cellIdentity.mcc')
MNC=$(echo "$DATA" | jq -r '.[0].cellIdentity.mnc')
LAC=$(echo "$DATA" | jq -r '.[0].cellIdentity.lac // .[0].cellIdentity.tac')
CID=$(echo "$DATA" | jq -r '.[0].cellIdentity.cid // .[0].cellIdentity.nci')

# Ambil lokasi GPS
echo "[*] Mengambil lokasi GPS..."
LOC=$(termux-location)
LAT=$(echo "$LOC" | jq -r '.latitude')
LON=$(echo "$LOC" | jq -r '.longitude')

# Cari info CID di file 510.csv
INFO=$(awk -F',' -v cid="$CID" -v lac="$LAC" '$4==cid && $3==lac {print}' 510.csv)

if [ -z "$INFO" ]; then
    TOWER_INFO="📡 Data tower tidak ditemukan di 510.csv (MCC:$MCC, MNC:$MNC, LAC:$LAC, CID:$CID)"
else
    TOWER_INFO="📡 Menara ditemukan:
$INFO"
fi

# Kirim ke Discord
echo "[*] Mengirim data ke Discord Webhook..."
curl -X POST -H "Content-Type: application/json" \
-d "{
  \"username\": \"SkizaLocator\",
  \"avatar_url\": \"https://i.imgur.com/JFzZQZZ.png\",
  \"content\": \"🚨 **Laporan CID**\nMCC: $MCC | MNC: $MNC | LAC: $LAC | CID: $CID\n📍 Lokasi: https://maps.google.com/?q=$LAT,$LON\n$TOWER_INFO\"
}" \
https://discord.com/api/webhooks/1298242162709889068/Cw7RQfdXfNH2CpffzljbVz8ZKmJZszEo7c-Y81r-fAIRmAG4oBOhtEZplanALE6L15Cq

echo "[✓] Data berhasil dikirim ke Discord."
