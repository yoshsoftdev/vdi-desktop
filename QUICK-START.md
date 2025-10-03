# Quick Start Guide - Alpine XFCE noVNC

## 🔧 Perbaikan yang Dilakukan

1. ✅ **VNC Server Wait Logic** - Memastikan VNC server ready sebelum noVNC start
2. ✅ **Install net-tools** - Untuk command netstat
3. ✅ **Port Configuration** - noVNC proxy listen di port 6080
4. ✅ **Resolusi Custom** - Default 1920x1080 Full HD
5. ✅ **Error Handling** - Better error messages dan timeout handling

## 🚀 Cara Build & Test

### 1. Build Image

```bash
cd /home/yosh/custom-image/Alpine_xfce4_noVNC
docker build -t alpine-xfce-novnc .
```

### 2. Jalankan Container

```bash
docker run -d \
  --name alpine-desktop \
  -p 6080:6080 \
  -p 5999:5999 \
  alpine-xfce-novnc
```

### 3. Cek Logs (Untuk Memastikan VNC Server Ready)

```bash
docker logs -f alpine-desktop
```

**Output yang benar:**
```
Starting VNC Server...
New 'X' desktop is alpine-desktop:99
...
Waiting for VNC server to be ready...
VNC server is ready!
Starting noVNC proxy on port 6080...
```

### 4. Akses Desktop

Buka browser dan akses:
```
http://localhost:6080/vnc.html
```

**Langkah:**
1. Klik tombol **"Connect"**
2. Masukkan password: **alpine**
3. Desktop XFCE4 akan muncul

## ⚠️ Troubleshooting

### Error: "Connection refused"

**Penyebab:** VNC server belum ready

**Solusi:**
```bash
# Cek logs
docker logs alpine-desktop

# Jika VNC server error, restart container
docker restart alpine-desktop

# Tunggu 10-15 detik, lalu akses lagi
```

### Error: "Failed to connect"

**Penyebab:** Port tidak tersedia

**Solusi:**
```bash
# Cek apakah port sudah digunakan
netstat -tuln | grep 6080

# Atau gunakan port lain
docker run -d --name alpine-desktop -p 8080:6080 -p 5999:5999 alpine-xfce-novnc

# Akses via: http://localhost:8080/vnc.html
```

### Layar Hitam Setelah Connect

**Penyebab:** XFCE4 masih loading

**Solusi:**
- Tunggu 10-20 detik
- XFCE4 membutuhkan waktu untuk initialize
- Cek logs untuk memastikan tidak ada error

### Desktop Tidak Responsif

**Penyebab:** Resource tidak cukup

**Solusi:**
```bash
# Stop container
docker stop alpine-desktop

# Jalankan dengan lebih banyak resource
docker run -d \
  --name alpine-desktop \
  --memory="2g" \
  --cpus="2" \
  -p 6080:6080 \
  -p 5999:5999 \
  alpine-xfce-novnc
```

## 🔄 Update Container

Jika ada perubahan pada Dockerfile atau entry.sh:

```bash
# Stop dan remove container lama
docker stop alpine-desktop
docker rm alpine-desktop

# Rebuild image
docker build -t alpine-xfce-novnc .

# Jalankan container baru
docker run -d --name alpine-desktop -p 6080:6080 -p 5999:5999 alpine-xfce-novnc
```

## 📝 Mengganti Resolusi

Edit file `entry.sh` baris 8:
```bash
/usr/bin/vncserver :99 -geometry 1920x1080 -depth 24
```

Ganti `1920x1080` dengan:
- `1366x768` - Untuk laptop
- `1280x720` - Untuk layar kecil
- `2560x1440` - Untuk monitor 2K
- `3840x2160` - Untuk monitor 4K

Setelah edit, rebuild image dan restart container.

## 🔐 Mengganti Password

Masuk ke container dan ganti password VNC:

```bash
docker exec -it alpine-desktop bash
vncpasswd
# Masukkan password baru 2x
exit

# Restart container
docker restart alpine-desktop
```

## ✅ Checklist Sebelum Production

- [ ] Ganti password default VNC
- [ ] Set resolusi sesuai kebutuhan
- [ ] Test dengan berbagai browser
- [ ] Setup firewall untuk port 6080
- [ ] Pertimbangkan gunakan HTTPS/SSL
- [ ] Backup konfigurasi VNC

## 📊 Info Teknis

| Item | Value |
|------|-------|
| OS | Alpine Linux (latest) |
| Desktop | XFCE4 |
| VNC Server | TigerVNC |
| VNC Port | 5999 |
| Web Port | 6080 |
| Default User | alpine |
| Default Password | alpine |
| Resolusi Default | 1920x1080 |
| Color Depth | 24-bit |

## 🆘 Support

Jika masih ada masalah, cek:
1. Docker logs: `docker logs alpine-desktop`
2. VNC log: `docker exec alpine-desktop cat /home/alpine/.vnc/*.log`
3. Network: `docker exec alpine-desktop netstat -tuln` 