# Alpine Linux XFCE4 with noVNC

Docker container untuk Alpine Linux dengan XFCE4 desktop yang dapat diakses via web browser menggunakan noVNC.

## 🎯 Fitur

- **Alpine Linux** - Lightweight dan cepat
- **XFCE4 Desktop** - Desktop environment yang ringan
- **noVNC** - Akses desktop via web browser (tanpa VNC client)
- **Firefox** - Web browser
- **Terminal** - XFCE4 Terminal
- **Resolusi Custom** - Default 1920x1080 (Full HD)

## 📦 Build Image

```bash
docker build -t alpine-xfce-novnc .
```

## 🚀 Menjalankan Container

### Resolusi Default (1920x1080)

```bash
docker run -d \
  --name alpine-desktop \
  -p 6080:6080 \
  -p 5999:5999 \
  alpine-xfce-novnc
```

### Dengan Custom Resolusi

Untuk mengubah resolusi, edit file `entry.sh` baris:
```bash
/usr/bin/vncserver :99 -geometry 1920x1080 -depth 24 &
```

Ganti `1920x1080` dengan resolusi yang diinginkan:
- **1920x1080** - Full HD (Default)
- **1366x768** - HD Ready
- **1280x720** - HD
- **1600x900** - HD+
- **2560x1440** - 2K QHD
- **3840x2160** - 4K UHD

## 🌐 Akses Desktop

Buka web browser dan akses:
```
http://localhost:6080/vnc.html
```

### Kredensial VNC

- **Password**: `alpine`

## 🖥️ Cara Menggunakan

1. Akses `http://localhost:6080/vnc.html`
2. Klik tombol "Connect"
3. Masukkan password: `alpine`
4. Desktop XFCE4 akan muncul

### Membuka Aplikasi

**Di Desktop:**
- Klik kanan pada desktop → Applications

**Dari Terminal:**
- Klik Applications Menu (pojok kiri atas)
- Pilih "Terminal Emulator"
- Atau klik kanan → Terminal

**Membuka Firefox:**
- Applications → Internet → Firefox

## 📝 Konfigurasi VNC

File konfigurasi VNC berada di: `/home/alpine/.vnc/`

Untuk mengubah startup aplikasi, edit:
```
/home/alpine/.vnc/xstartup
```

## 🔧 Troubleshooting

### Desktop Tidak Muncul

1. Cek logs container:
```bash
docker logs alpine-desktop
```

2. Restart container:
```bash
docker restart alpine-desktop
```

### Resolusi Tidak Sesuai

1. Stop container:
```bash
docker stop alpine-desktop
docker rm alpine-desktop
```

2. Edit `entry.sh` dan ubah parameter `-geometry`

3. Rebuild image:
```bash
docker build -t alpine-xfce-novnc .
```

4. Jalankan ulang container

### Layar Hitam

Tunggu beberapa detik hingga XFCE4 selesai loading. XFCE4 membutuhkan waktu ~5-10 detik untuk start.

## 📊 Port

| Port | Service |
|------|---------|
| 6080 | noVNC Web Interface |
| 5999 | VNC Server |

## 🛠️ Customization

### Menambah Aplikasi

Edit Dockerfile dan tambahkan package di baris `apk add`:
```dockerfile
RUN apk add --no-cache ... your-package
```

### Mengubah Password VNC

Masuk ke container dan jalankan:
```bash
docker exec -it alpine-desktop vncpasswd
```

## 📌 Catatan

- User default: `alpine`
- Password default: `alpine`
- User memiliki sudo privileges
- Desktop menggunakan XFCE4 (lightweight)
- VNC server: TigerVNC
- Web interface: noVNC

## 🔐 Security

**PERINGATAN:** Container ini menggunakan password default (`alpine`). 
Untuk production, **WAJIB** ganti password dengan menjalankan `vncpasswd` di dalam container.

## 📄 License

Based on Alpine Linux and noVNC projects. 