# 📝 Deployment Note - GitHub URL Configuration

## ⚠️ QUAN TRỌNG: Cập nhật GitHub URL trước khi deploy

Trước khi deploy lên Vercel, bạn cần cập nhật các GitHub URLs trong code để trỏ đến repository thực tế của bạn.

---

## 🔧 Files cần cập nhật:

### 1. `src/App.jsx`

Tìm và thay thế **3 chỗ** sau:

#### Chỗ 1: Download ZIP link (dòng ~285)
```jsx
// BEFORE
href="https://github.com/your-username/phasmophobia-community-hub/archive/refs/heads/main.zip"

// AFTER
href="https://github.com/YOUR_ACTUAL_USERNAME/YOUR_REPO_NAME/archive/refs/heads/main.zip"
```

#### Chỗ 2: Download GUI Tool button (dòng ~330)
```jsx
// BEFORE
href="https://github.com/your-username/phasmophobia-community-hub/archive/refs/heads/main.zip"

// AFTER
href="https://github.com/YOUR_ACTUAL_USERNAME/YOUR_REPO_NAME/archive/refs/heads/main.zip"
```

#### Chỗ 3: GitHub repository link (dòng ~337)
```jsx
// BEFORE
href="https://github.com/your-username/phasmophobia-community-hub"

// AFTER
href="https://github.com/YOUR_ACTUAL_USERNAME/YOUR_REPO_NAME"
```

---

## 📋 Cách tìm GitHub URL của bạn:

1. **Tạo repository trên GitHub** (nếu chưa có):
   - Vào https://github.com
   - Click "New repository"
   - Đặt tên repository (ví dụ: `phasmophobia-community-hub`)
   - Click "Create repository"

2. **Lấy URL**:
   - URL sẽ có dạng: `https://github.com/YOUR_USERNAME/YOUR_REPO_NAME`
   - Ví dụ: `https://github.com/john-doe/phasmophobia-saves`

3. **Push code lên GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git
   git push -u origin main
   ```

---

## 🚀 Deploy lên Vercel:

### Bước 1: Chuẩn bị
- ✅ Đã cập nhật GitHub URLs trong `src/App.jsx`
- ✅ Đã push code lên GitHub
- ✅ Firebase config đã được cấu hình đúng

### Bước 2: Deploy
1. Vào https://vercel.com
2. Click "New Project"
3. Import repository từ GitHub
4. Vercel sẽ tự động detect Vite project
5. Click "Deploy"

### Bước 3: Verify
- Mở web app đã deploy
- Test nút "Tải Game (Cả 2 Parts)"
- Test nút "Download GUI Tool"
- Đảm bảo tất cả links hoạt động

---

## 🔍 Quick Search & Replace

Sử dụng VS Code hoặc editor của bạn:

1. **Mở Find & Replace** (Ctrl + H hoặc Cmd + H)

2. **Find**:
   ```
   https://github.com/your-username/phasmophobia-community-hub
   ```

3. **Replace with**:
   ```
   https://github.com/YOUR_ACTUAL_USERNAME/YOUR_REPO_NAME
   ```

4. **Replace All** trong file `src/App.jsx`

---

## ✅ Checklist trước khi deploy:

- [ ] Đã tạo GitHub repository
- [ ] Đã cập nhật 3 GitHub URLs trong `src/App.jsx`
- [ ] Đã push code lên GitHub
- [ ] Firebase config đã đúng
- [ ] Đã test local (`npm run dev`)
- [ ] Đã build thành công (`npm run build`)
- [ ] Sẵn sàng deploy lên Vercel

---

## 🐛 Troubleshooting:

### Problem: GitHub download link không hoạt động
**Solution**: 
- Đảm bảo repository là **public** (không phải private)
- Kiểm tra URL có đúng format không
- Test link bằng cách paste vào browser

### Problem: GUI download về nhưng không chạy được
**Solution**:
- Đảm bảo file `Launch-GUI.bat` có trong repository
- Đảm bảo file `phasmophobia-sync-gui.ps1` có trong repository
- Hướng dẫn user cài Node.js

### Problem: Vercel build failed
**Solution**:
- Check build logs
- Đảm bảo `package.json` có đúng dependencies
- Test `npm run build` locally trước

---

## 📚 Tài liệu tham khảo:

- [GitHub Docs - Creating a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [Vercel Docs - Deploying Vite](https://vercel.com/docs/frameworks/vite)
- [Firebase Docs - Web Setup](https://firebase.google.com/docs/web/setup)

---

## 💡 Tips:

1. **Sử dụng GitHub Releases** (Optional):
   - Tạo release cho mỗi version
   - User có thể download specific version
   - URL: `https://github.com/USER/REPO/releases/download/v1.0.0/archive.zip`

2. **Tạo README.md trong repository**:
   - Hướng dẫn cách sử dụng GUI
   - Screenshots
   - Installation guide

3. **Add GitHub Actions** (Optional):
   - Auto-deploy to Vercel on push
   - Run tests before deploy
   - Auto-generate release notes

---

**Made with 💜 for the Phasmophobia community**

**Happy Ghost Hunting!** 👻

