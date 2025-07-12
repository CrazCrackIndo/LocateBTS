#!/bin/bash

# Webhook Discord kamu
WEBHOOK_URL="https://discord.com/api/webhooks/1298242162709889068/Cw7RQfdXfNH2CpffzljbVz8ZKmJZszEo7c-Y81r-fAIRmAG4oBOhtEZplanALE6L15Cq"

# Cek dependencies
echo "[*] Mengecek dependency..."
pkg update -y && pkg install -y termux-api jq

# Cek file 510.csv
if [ ! -f "510.csv" ]; then
    echo "⚠️ File 510.csv tidak ditemukan. Letakkan file di direktori yang sama."
    exit 1
fi

# Ambil data BTS
echo "[*] Mengambil data BTS..."
DATA=$(termux-telephony-cellinfo)

MCC=$(echo "$DATA" | jq -r '[.[] | select(.registered == true)][0].mcc')
MNC=$(echo "$DATA" | jq -r '[.[] | select(.registered == true)][0].mnc')
LAC=$(echo "$DATA" | jq -r '[.[] | select(.registered == true)][0].tac')
CID=$(echo "$DATA" | jq -r '[.[] | select(.registered == true)][0].ci')

# Fallback jika parsing gagal
if [ "$MCC" = "null" ] || [ "$MNC" = "null" ] || [ "$LAC" = "null" ] || [ "$CID" = "null" ]; then
    echo "⚠️ Gagal ambil data otomatis. Masukkan data secara manual:"
    read -p "MCC: " MCC
    read -p "MNC: " MNC
    read -p "LAC: " LAC
    read -p "CID: " CID
fi

# Ambil lokasi GPS
echo "[*] Mengambil lokasi GPS..."
LOC=$(termux-location -p gps)
LAT=$(echo "$LOC" | jq -r '.latitude')
LON=$(echo "$LOC" | jq -r '.longitude')

# Cek 510.csv untuk info tower
INFO=$(awk -F',' -v mcc="$MCC" -v mnc="$MNC" -v lac="$LAC" -v cid="$CID" '$1==mcc && $2==mnc && $3==lac && $4==cid' 510.csv)

if [ -z "$INFO" ]; then
    TOWER_INFO="📡 Data tower tidak ditemukan di database lokal."
else
    TOWER_INFO="📡 Menara ditemukan:\n$INFO"
fi

# Kirim ke Discord
curl -s -X POST -H "Content-Type: application/json" \
-d "{
  \"username\": \"SkizaLocator\",
  \"avatar_url\": \"https://i.imgur.com/JFzZQZZ.png\",
  \"content\": \"🚨 **Laporan CID**\nMCC: $MCC | MNC: $MNC | LAC: $LAC | CID: $CID\n📍 Lokasi: https://maps.google.com/?q=$LAT,$LON\n$TOWER_INFO\"
}" \
"$WEBHOOK_URL" > /dev/null

# Notifikasi akhir
if [ -z "$INFO" ]; then
  echo "⚠️ Menara tidak ditemukan dalam database lokal."
else
  echo "✅ Menara ditemukan dan dilaporkan ke Discord."
fi
