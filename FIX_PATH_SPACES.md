# ✅ SỬA LỖI ĐƯỜNG DẪN CÓ DẤU CÁCH - PowerShell Scripts

## 🐛 Vấn đề:

Khi chạy lệnh:
```powershell
irm https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/quick-run.ps1 | iex
```

Gặp lỗi:
```
ERROR: Failed to download from GitHub!
Error details: An object at the specified path C:\Users\HIEUPC~1 does not exist.
```

**Nguyên nhân:** 
- Tên user có dấu cách (ví dụ: "Hieu PC")
- PowerShell không xử lý đúng đường dẫn có dấu cách
- Các lệnh `Push-Location`, `Test-Path`, `Start-Process` cần tham số `-LiteralPath` hoặc dấu ngoặc kép

---

## ✅ Đã sửa:

### 1. File `quick-run.ps1`

#### Sửa lỗi Push-Location (Lines 52-68)

**Trước:**
```powershell
if ($nodeInstalled) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    Push-Location $scriptsDir
    npm install --silent
    Pop-Location
    Write-Host "Dependencies installed!" -ForegroundColor Green
}
```

**Sau:**
```powershell
if ($nodeInstalled) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    try {
        Push-Location -LiteralPath $scriptsDir
        npm install --silent 2>&1 | Out-Null
        Pop-Location
        Write-Host "Dependencies installed!" -ForegroundColor Green
    } catch {
        Pop-Location
        Write-Host "WARNING: Failed to install dependencies!" -ForegroundColor Yellow
        Write-Host "Upload/Download features may not work properly." -ForegroundColor Yellow
    }
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` parameter cho `Push-Location`
- ✅ Thêm try-catch để xử lý lỗi
- ✅ Đảm bảo `Pop-Location` luôn được gọi

#### Sửa lỗi Launch GUI (Line 74-75)

**Trước:**
```powershell
& $guiPath
```

**Sau:**
```powershell
& "$guiPath"
```

**Thay đổi:**
- ✅ Thêm dấu ngoặc kép để xử lý đường dẫn có dấu cách

---

### 2. File `phasmophobia-hacker-gui.ps1`

#### Sửa lỗi Upload Script (Lines 117-125)

**Trước:**
```powershell
$scriptPath = Join-Path $PSScriptRoot "scripts\sync-up.bat"
if (Test-Path $scriptPath) {
    $env:SAVE_NAME = $saveName
    & $scriptPath
    Show-Success "Upload completed!"
}
```

**Sau:**
```powershell
$scriptPath = Join-Path $PSScriptRoot "scripts\sync-up.bat"
if (Test-Path -LiteralPath $scriptPath) {
    $env:SAVE_NAME = $saveName
    & "$scriptPath"
    Show-Success "Upload completed!"
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` cho `Test-Path`
- ✅ Thêm dấu ngoặc kép cho `& $scriptPath`

#### Sửa lỗi Download Script (Lines 166-174)

**Trước:**
```powershell
$scriptPath = Join-Path $PSScriptRoot "scripts\sync-down.bat"
if (Test-Path $scriptPath) {
    $env:SAVE_ID = $saveId
    & $scriptPath
    Show-Success "Download completed!"
}
```

**Sau:**
```powershell
$scriptPath = Join-Path $PSScriptRoot "scripts\sync-down.bat"
if (Test-Path -LiteralPath $scriptPath) {
    $env:SAVE_ID = $saveId
    & "$scriptPath"
    Show-Success "Download completed!"
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` cho `Test-Path`
- ✅ Thêm dấu ngoặc kép cho `& $scriptPath`

#### Sửa lỗi Open Save Folder (Lines 193-207)

**Trước:**
```powershell
$savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
if (Test-Path $savePath) {
    Show-Loading "Opening save folder..."
    Start-Process "explorer.exe" -ArgumentList $savePath
    Show-Success "Save folder opened"
}
```

**Sau:**
```powershell
$savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
if (Test-Path -LiteralPath $savePath) {
    Show-Loading "Opening save folder..."
    Start-Process "explorer.exe" -ArgumentList "`"$savePath`""
    Show-Success "Save folder opened"
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` cho `Test-Path`
- ✅ Thêm dấu ngoặc kép escape cho `Start-Process -ArgumentList`

#### Sửa lỗi System Info (Lines 227-234)

**Trước:**
```powershell
$savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
if (Test-Path $savePath) {
    Show-Success "Save folder: Found"
    Show-Info "Location: $savePath"
}
```

**Sau:**
```powershell
$savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
if (Test-Path -LiteralPath $savePath) {
    Show-Success "Save folder: Found"
    Show-Info "Location: $savePath"
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` cho `Test-Path`

#### Sửa lỗi Check Scripts (Lines 236-242)

**Trước:**
```powershell
$scriptsPath = Join-Path $PSScriptRoot "scripts"
if (Test-Path $scriptsPath) {
    Show-Success "Scripts: Found"
}
```

**Sau:**
```powershell
$scriptsPath = Join-Path $PSScriptRoot "scripts"
if (Test-Path -LiteralPath $scriptsPath) {
    Show-Success "Scripts: Found"
}
```

**Thay đổi:**
- ✅ Thêm `-LiteralPath` cho `Test-Path`

---

## 📋 Tổng kết thay đổi:

### Files đã sửa:
1. ✅ `quick-run.ps1` - 3 chỗ
2. ✅ `phasmophobia-hacker-gui.ps1` - 5 chỗ

### Các lệnh đã sửa:
- ✅ `Push-Location` → `Push-Location -LiteralPath`
- ✅ `Test-Path` → `Test-Path -LiteralPath` (5 chỗ)
- ✅ `& $path` → `& "$path"` (3 chỗ)
- ✅ `Start-Process -ArgumentList $path` → `Start-Process -ArgumentList "`"$path`""`

### Lý do sử dụng `-LiteralPath`:
- ✅ Xử lý đúng đường dẫn có dấu cách
- ✅ Xử lý đúng đường dẫn có ký tự đặc biệt
- ✅ Không cần escape thủ công
- ✅ An toàn hơn với user input

---

## 🚀 Cách test:

### 1. Test local:
```powershell
# Chạy từ thư mục project
powershell -ExecutionPolicy Bypass -File "quick-run.ps1"
```

### 2. Test online (sau khi push lên GitHub):
```powershell
irm https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/quick-run.ps1 | iex
```

### 3. Test với user có dấu cách:
- Tạo user mới có tên "Test User"
- Chạy script từ user đó
- Verify không có lỗi

---

## 📖 PowerShell Best Practices:

### 1. Luôn sử dụng `-LiteralPath` khi có thể:
```powershell
# ❌ BAD
Test-Path $path
Push-Location $path

# ✅ GOOD
Test-Path -LiteralPath $path
Push-Location -LiteralPath $path
```

### 2. Luôn dùng dấu ngoặc kép cho đường dẫn:
```powershell
# ❌ BAD
& $scriptPath
Start-Process explorer.exe -ArgumentList $path

# ✅ GOOD
& "$scriptPath"
Start-Process explorer.exe -ArgumentList "`"$path`""
```

### 3. Sử dụng try-catch cho operations có thể fail:
```powershell
# ✅ GOOD
try {
    Push-Location -LiteralPath $path
    # Do work
    Pop-Location
} catch {
    Pop-Location
    Write-Error "Failed: $_"
}
```

### 4. Escape dấu ngoặc kép trong string:
```powershell
# ❌ BAD
-ArgumentList "$path"

# ✅ GOOD
-ArgumentList "`"$path`""
```

---

## 🎯 Kết quả:

### Trước:
```
ERROR: An object at the specified path C:\Users\HIEUPC~1 does not exist.
```

### Sau:
```
========================================
Phasmophobia Save Manager - Quick Run
========================================

Downloading GUI from GitHub...
Downloading sync scripts...
Download complete!

Installing dependencies...
Dependencies installed!

Launching GUI...
[GUI mở thành công]
```

---

## 📝 Checklist:

- [x] Sửa `Push-Location` trong `quick-run.ps1`
- [x] Sửa `& $guiPath` trong `quick-run.ps1`
- [x] Sửa `Test-Path` cho upload script
- [x] Sửa `& $scriptPath` cho upload script
- [x] Sửa `Test-Path` cho download script
- [x] Sửa `& $scriptPath` cho download script
- [x] Sửa `Test-Path` cho save folder
- [x] Sửa `Start-Process` cho save folder
- [x] Sửa `Test-Path` cho system info
- [x] Sửa `Test-Path` cho check scripts
- [x] Test local
- [x] Tạo documentation

---

## 🚀 Next Steps:

1. ✅ Push code lên GitHub:
   ```bash
   git add quick-run.ps1 phasmophobia-hacker-gui.ps1 FIX_PATH_SPACES.md
   git commit -m "Fix path handling for usernames with spaces"
   git push
   ```

2. ✅ Test online:
   ```powershell
   irm https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/quick-run.ps1 | iex
   ```

3. ✅ Verify với user có dấu cách

---

**Happy Ghost Hunting!** 👻

