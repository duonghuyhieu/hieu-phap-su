# 🚀 Hướng dẫn chạy GUI Online

Có 3 cách để chạy GUI mà không cần download repository về máy:

---

## 🎯 Cách 1: Chạy trực tiếp từ PowerShell (KHUYẾN NGHỊ)

### Bước 1: Mở PowerShell
- Nhấn `Win + X`
- Chọn "Windows PowerShell" hoặc "Terminal"

### Bước 2: Chạy lệnh sau
```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/quick-run.ps1 | iex
```

**Giải thích:**
- `irm` = Invoke-RestMethod (tải script từ GitHub)
- `iex` = Invoke-Expression (chạy script)

### Bước 3: Đợi GUI mở ra
- Script sẽ tự động:
  - Tải GUI và scripts từ GitHub
  - Cài đặt dependencies (nếu có Node.js)
  - Mở GUI

---

## 🎯 Cách 2: Sử dụng file .bat

### Bước 1: Tải file `run-gui-online.bat`
```
https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/run-gui-online.bat
```

### Bước 2: Cập nhật GitHub URL
- Mở file `run-gui-online.bat` bằng Notepad
- Tìm và thay thế:
  ```
  YOUR_USERNAME/YOUR_REPO_NAME
  ```
  Thành:
  ```
  your-actual-username/your-actual-repo-name
  ```

### Bước 3: Double-click file .bat
- GUI sẽ tự động tải và chạy

---

## 🎯 Cách 3: Tạo shortcut 1-click

### Bước 1: Tạo file .bat mới
- Tạo file mới tên `Launch-Phasmophobia-GUI.bat`
- Paste nội dung sau:

```batch
@echo off
powershell -Command "irm https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO_NAME/main/quick-run.ps1 | iex"
pause
```

### Bước 2: Cập nhật URL
- Thay `YOUR_USERNAME/YOUR_REPO_NAME` bằng thông tin thực tế

### Bước 3: Tạo shortcut
- Right-click file .bat → Send to → Desktop (create shortcut)
- Đổi tên shortcut thành "Phasmophobia Save Manager"
- Đổi icon (optional)

### Bước 4: Sử dụng
- Double-click shortcut trên desktop
- GUI sẽ tự động chạy

---

## 📋 Yêu cầu hệ thống:

### Bắt buộc:
- ✅ Windows 10/11
- ✅ PowerShell (có sẵn trong Windows)
- ✅ Internet connection

### Khuyến nghị:
- ✅ Node.js (để upload/download hoạt động)
  - Tải tại: https://nodejs.org
  - Chọn phiên bản LTS

---

## 🔧 Troubleshooting:

### Lỗi: "Execution Policy"
**Triệu chứng:**
```
File cannot be loaded because running scripts is disabled on this system
```

**Giải pháp:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

### Lỗi: "Failed to download from GitHub"
**Nguyên nhân:**
- Không có internet
- GitHub URL sai
- File không tồn tại

**Giải pháp:**
1. Kiểm tra internet connection
2. Verify GitHub URL trong browser
3. Đảm bảo repository là public

### Lỗi: "Node.js not found"
**Triệu chứng:**
```
WARNING: Node.js not found!
Upload/Download features may not work.
```

**Giải pháp:**
1. Tải Node.js: https://nodejs.org
2. Cài đặt (chọn "Add to PATH")
3. Restart PowerShell/Command Prompt
4. Chạy lại script

### GUI không mở
**Giải pháp:**
1. Kiểm tra Windows Defender/Antivirus
2. Cho phép PowerShell chạy
3. Thử chạy với quyền Administrator

---

## 🎨 Ưu điểm của cách chạy Online:

### ✅ Không cần download repository
- Tiết kiệm dung lượng
- Không cần quản lý files

### ✅ Luôn cập nhật
- Mỗi lần chạy = phiên bản mới nhất
- Không cần pull/update

### ✅ Đơn giản
- 1 lệnh hoặc 1 click
- Không cần setup

### ✅ Portable
- Chạy được trên bất kỳ máy Windows nào
- Không cần cài đặt

---

## ⚠️ Lưu ý:

### 1. Cần internet mỗi lần chạy
- Script tải files từ GitHub mỗi lần
- Nếu không có internet → không chạy được

### 2. Temporary files
- Files được lưu tại: `%TEMP%\phasmophobia-gui`
- Có thể xóa sau khi dùng xong
- Sẽ tải lại lần sau

### 3. Node.js dependencies
- Nếu có Node.js: tự động cài dependencies
- Nếu không: GUI vẫn mở nhưng upload/download không hoạt động

### 4. GitHub URL
- Phải cập nhật đúng username và repo name
- Repository phải là public
- Files phải tồn tại trong repo

---

## 📊 So sánh các cách:

| Cách | Ưu điểm | Nhược điểm | Khuyến nghị |
|------|---------|------------|-------------|
| **PowerShell 1-liner** | Nhanh nhất, đơn giản | Cần gõ lệnh | ⭐⭐⭐⭐⭐ |
| **File .bat** | Dễ chia sẻ | Cần tải file trước | ⭐⭐⭐⭐ |
| **Desktop shortcut** | 1-click, tiện lợi | Cần setup 1 lần | ⭐⭐⭐⭐⭐ |

---

## 🎯 Khuyến nghị:

### Cho người dùng thường xuyên:
→ Tạo **Desktop shortcut** (Cách 3)

### Cho người dùng thử nghiệm:
→ Dùng **PowerShell 1-liner** (Cách 1)

### Cho người chia sẻ với bạn bè:
→ Gửi file **.bat** (Cách 2)

---

## 📝 Ví dụ thực tế:

### Ví dụ 1: Chạy nhanh
```powershell
# Mở PowerShell và chạy:
irm https://raw.githubusercontent.com/john-doe/phasmophobia-saves/main/quick-run.ps1 | iex
```

### Ví dụ 2: Tạo shortcut
```batch
# Tạo file Launch.bat với nội dung:
@echo off
powershell -Command "irm https://raw.githubusercontent.com/john-doe/phasmophobia-saves/main/quick-run.ps1 | iex"
pause
```

### Ví dụ 3: Chạy với alias
```powershell
# Thêm vào PowerShell profile:
function Start-PhasmoGUI {
    irm https://raw.githubusercontent.com/john-doe/phasmophobia-saves/main/quick-run.ps1 | iex
}

# Sau đó chỉ cần gõ:
Start-PhasmoGUI
```

---

## 🔗 Links hữu ích:

- **Node.js Download**: https://nodejs.org
- **PowerShell Documentation**: https://docs.microsoft.com/powershell
- **GitHub Raw URLs**: https://raw.githubusercontent.com

---

## 💡 Tips:

1. **Bookmark PowerShell command** để dễ copy-paste
2. **Pin shortcut to taskbar** để truy cập nhanh
3. **Share .bat file** với bạn bè qua Discord/Email
4. **Update URL** khi repository thay đổi

---

## 🎉 Kết luận:

Với các cách trên, bạn có thể chạy GUI mà không cần:
- ❌ Clone repository
- ❌ Download ZIP
- ❌ Quản lý files
- ❌ Update thủ công

Chỉ cần:
- ✅ 1 lệnh PowerShell
- ✅ Hoặc 1 click chuột
- ✅ Internet connection

**Happy Ghost Hunting!** 👻

---

**Made with 💜 for the Phasmophobia community**

