import { useState, useEffect } from 'react';
import { db, signInAnonymous } from './firebase';
import { collection, onSnapshot, addDoc, doc, getDoc, serverTimestamp, query, orderBy } from 'firebase/firestore';

function App() {
  const [activeTab, setActiveTab] = useState('download');
  const [saves, setSaves] = useState([]);
  const [loading, setLoading] = useState(true);
  const [authenticated, setAuthenticated] = useState(false);
  const [uploadName, setUploadName] = useState('');
  const [uploadFile, setUploadFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [downloading, setDownloading] = useState(false);

  // Sign in anonymously on mount
  useEffect(() => {
    const authenticate = async () => {
      const success = await signInAnonymous();
      setAuthenticated(success);
    };
    authenticate();
  }, []);

  // Listen to saves collection
  useEffect(() => {
    if (!authenticated) return;

    const savesRef = collection(db, 'shared_saves');
    const q = query(savesRef, orderBy('timestamp', 'desc'));

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const savesData = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setSaves(savesData);
      setLoading(false);
    }, (error) => {
      console.error('Error listening to saves:', error);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [authenticated]);

  // Handle manual upload
  const handleUpload = async (e) => {
    e.preventDefault();
    if (!uploadName || !uploadFile) {
      alert('Please provide a name and select a file');
      return;
    }

    setUploading(true);
    try {
      const reader = new FileReader();
      reader.onload = async (event) => {
        const base64Content = event.target.result.split(',')[1];

        await addDoc(collection(db, 'shared_saves'), {
          name: uploadName,
          content: base64Content,
          timestamp: serverTimestamp(),
          uploaded_by: 'Web UI'
        });

        alert('Save uploaded successfully!');
        setUploadName('');
        setUploadFile(null);
        e.target.reset();
      };
      reader.readAsDataURL(uploadFile);
    } catch (error) {
      console.error('Error uploading save:', error);
      alert('Error uploading save: ' + error.message);
    } finally {
      setUploading(false);
    }
  };

  // Handle manual download
  const handleDownload = async (saveId) => {
    setDownloading(true);
    try {
      const saveDoc = await getDoc(doc(db, 'shared_saves', saveId));
      if (!saveDoc.exists()) {
        alert('Save not found');
        return;
      }

      const saveData = saveDoc.data();
      const base64Content = saveData.content;
      const blob = base64ToBlob(base64Content, 'application/zip');
      const url = URL.createObjectURL(blob);

      const a = document.createElement('a');
      a.href = url;
      a.download = `${saveData.name}.zip`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (error) {
      console.error('Error downloading save:', error);
      alert('Error downloading save: ' + error.message);
    } finally {
      setDownloading(false);
    }
  };

  // Helper function to convert base64 to blob
  const base64ToBlob = (base64, type) => {
    const binary = atob(base64);
    const array = [];
    for (let i = 0; i < binary.length; i++) {
      array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type });
  };

  // Copy ID to clipboard
  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
    alert('ID copied to clipboard!');
  };

  // Format timestamp
  const formatTimestamp = (timestamp) => {
    if (!timestamp) return 'N/A';
    return new Date(timestamp.seconds * 1000).toLocaleString();
  };

  // Shorten ID for display
  const shortenId = (id) => {
    return id.substring(0, 8) + '...';
  };

  return (
    <div className="min-h-screen p-4 md:p-8">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-2">
            👻 Phasmophobia Community Hub
          </h1>
          <p className="text-gray-300 text-lg">
            Tải Game & Quản lý Save Game
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="bg-gray-800 rounded-t-lg border-b border-gray-700">
          <div className="flex flex-wrap">
            <button
              onClick={() => setActiveTab('download')}
              className={`px-6 py-3 font-medium transition-colors ${activeTab === 'download'
                ? 'bg-purple-600 text-white'
                : 'text-gray-300 hover:bg-gray-700'
                }`}
            >
              🎮 Tải Game
            </button>
            <button
              onClick={() => setActiveTab('saves')}
              className={`px-6 py-3 font-medium transition-colors ${activeTab === 'saves'
                ? 'bg-purple-600 text-white'
                : 'text-gray-300 hover:bg-gray-700'
                }`}
            >
              💾 Quản lý Save Game
            </button>
          </div>
        </div>

        {/* Tab Content */}
        <div className="bg-gray-800 rounded-b-lg p-6 shadow-xl">
          {/* Download Game Tab */}
          {activeTab === 'download' && (
            <div className="text-gray-200 space-y-6">
              <h2 className="text-2xl font-bold text-purple-400 mb-4">🎮 Tải Game Phasmophobia</h2>

              <div className="bg-gray-900 p-6 rounded-lg">
                <h3 className="text-xl font-semibold text-white mb-4">📦 Download Links</h3>
                <p className="text-gray-300 mb-4">
                  Game được chia thành 2 parts. Bạn cần tải cả 2 parts và giải nén để chơi.
                </p>

                <div className="space-y-4">
                  {/* Part 1 */}
                  <div className="bg-gray-800 p-4 rounded-lg border border-gray-700">
                    <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                      <div>
                        <h4 className="text-white font-semibold text-lg">Part 1</h4>
                        <p className="text-gray-400 text-sm">Google Drive Link</p>
                      </div>
                      <a
                        href="https://drive.google.com/file/d/1HTVT4qtDiOTwpjMLUkbVGp_x-hpvHiil/view?usp=sharing"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg transition-colors text-center font-semibold"
                      >
                        ⬇️ Tải Part 1
                      </a>
                    </div>
                  </div>

                  {/* Part 2 */}
                  <div className="bg-gray-800 p-4 rounded-lg border border-gray-700">
                    <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                      <div>
                        <h4 className="text-white font-semibold text-lg">Part 2</h4>
                        <p className="text-gray-400 text-sm">Google Drive Link</p>
                      </div>
                      <a
                        href="https://drive.google.com/file/d/1hQBOQdSuhLoF-PXadhexDpete-oWZl7v/view?usp=sharing"
                        target="_blank"
                        rel="noopener noreferrer"
                        className="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg transition-colors text-center font-semibold"
                      >
                        ⬇️ Tải Part 2
                      </a>
                    </div>
                  </div>
                </div>
              </div>

              <div className="bg-gray-900 p-6 rounded-lg">
                <h3 className="text-xl font-semibold text-white mb-4">📝 Hướng dẫn cài đặt</h3>
                <ol className="list-decimal list-inside space-y-3 ml-4 text-gray-300">
                  <li>Tải cả 2 parts từ Google Drive về máy</li>
                  <li>Giải nén Part 1 (Part 2 sẽ tự động được giải nén cùng)</li>
                  <li>Chạy file setup hoặc executable để cài đặt game</li>
                  <li>Làm theo hướng dẫn trên màn hình</li>
                  <li>Sau khi cài đặt xong, chuyển sang tab "Quản lý Save Game" để tải saves từ cộng đồng!</li>
                </ol>
              </div>

              <div className="bg-blue-900 border border-blue-600 p-4 rounded-lg">
                <p className="text-blue-200">
                  <strong>💡 Mẹo:</strong> Sau khi cài đặt game, bạn có thể tải saves từ cộng đồng
                  để bắt đầu với level cao hoặc có đầy đủ items!
                </p>
              </div>

              <div className="bg-yellow-900 border border-yellow-600 p-4 rounded-lg">
                <p className="text-yellow-200">
                  <strong>⚠️ Lưu ý:</strong> Đảm bảo bạn có đủ dung lượng ổ cứng và tắt antivirus
                  tạm thời khi cài đặt để tránh bị chặn.
                </p>
              </div>
            </div>
          )}

          {/* Save Management Tab */}
          {activeTab === 'saves' && (
            <div className="space-y-6">
              <h2 className="text-2xl font-bold text-purple-400">💾 Quản lý Save Game</h2>

              {/* GUI Instructions */}
              <div className="bg-gradient-to-r from-purple-900 to-blue-900 border border-purple-600 p-6 rounded-lg">
                <h3 className="text-xl font-semibold text-white mb-4">💻 Sử dụng Hacker GUI (Khuyến nghị)</h3>
                <p className="text-gray-200 mb-4">
                  Cách dễ nhất để upload và download saves là sử dụng Hacker Style GUI - giao diện CLI đơn giản, chỉ cần chọn số!
                </p>

                <div className="bg-gray-900 bg-opacity-50 p-4 rounded-lg mb-4">
                  <h4 className="text-white font-semibold mb-3">⚡ Cách 1: Chạy Online (NHANH NHẤT)</h4>
                  <ol className="list-decimal list-inside space-y-2 ml-4 text-gray-200">
                    <li>Mở PowerShell trên Windows</li>
                    <li>Copy và chạy lệnh sau:
                      <div className="mt-2 mb-2 bg-gray-800 p-3 rounded-lg font-mono text-sm text-green-300 overflow-x-auto">
                        irm https://raw.githubusercontent.com/duonghuyhieu/hieu-phap-su/main/quick-run.ps1 | iex
                      </div>
                    </li>
                    <li>GUI sẽ tự động tải và mở ngay lập tức!</li>
                  </ol>
                </div>

                <div className="bg-gray-900 bg-opacity-50 p-4 rounded-lg mb-4">
                  <h4 className="text-white font-semibold mb-3">📥 Cách 2: Download và chạy Local</h4>
                  <ol className="list-decimal list-inside space-y-2 ml-4 text-gray-200">
                    <li>Download repository từ GitHub:
                      <div className="mt-2 mb-2">
                        <a
                          href="https://github.com/duonghuyhieu/hieu-phap-su/archive/refs/heads/main.zip"
                          target="_blank"
                          rel="noopener noreferrer"
                          className="inline-block bg-gray-800 hover:bg-gray-700 text-purple-300 px-4 py-2 rounded-lg transition-colors text-sm font-semibold"
                        >
                          📦 Download ZIP
                        </a>
                      </div>
                    </li>
                    <li>Giải nén file ZIP vừa tải về</li>
                    <li>Mở thư mục đã giải nén</li>
                    <li>Double-click file <code className="bg-gray-800 px-2 py-1 rounded">Launch-Hacker-GUI.bat</code></li>
                  </ol>
                </div>

                <div className="bg-gray-900 bg-opacity-50 p-4 rounded-lg mb-4">
                  <h4 className="text-white font-semibold mb-3">🎮 Sử dụng GUI</h4>
                  <p className="text-gray-200 mb-2">Giao diện kiểu Hacker với menu đơn giản:</p>
                  <ul className="list-disc list-inside ml-6 space-y-1 text-gray-200">
                    <li><strong>[1]</strong> Upload Save to Cloud - Upload save của bạn</li>
                    <li><strong>[2]</strong> Download Save from Cloud - Download save từ cộng đồng</li>
                    <li><strong>[3]</strong> Open Web Interface - Mở web để browse saves</li>
                    <li><strong>[4]</strong> Open Save Folder - Mở thư mục save</li>
                    <li><strong>[5]</strong> System Info - Xem thông tin hệ thống</li>
                    <li><strong>[0]</strong> Exit - Thoát</li>
                  </ul>
                </div>

                <div className="bg-green-900 bg-opacity-50 border border-green-600 p-3 rounded-lg mb-4">
                  <p className="text-green-200 text-sm">
                    <strong>✨ Đặc điểm:</strong> Giao diện màu xanh Matrix, ASCII art đẹp mắt, chỉ dùng bàn phím, không cần chuột!
                  </p>
                </div>

                <div className="bg-yellow-900 bg-opacity-50 border border-yellow-600 p-3 rounded-lg mb-4">
                  <p className="text-yellow-200 text-sm">
                    <strong>💡 Mẹo:</strong> GUI sẽ tự động backup save cũ của bạn trước khi download save mới!
                  </p>
                </div>

                <div className="bg-blue-900 bg-opacity-50 border border-blue-600 p-3 rounded-lg mb-4">
                  <p className="text-blue-200 text-sm">
                    <strong>ℹ️ Lưu ý:</strong> Bạn cần cài đặt Node.js trên máy để upload/download hoạt động.
                    Tải Node.js tại <a href="https://nodejs.org" target="_blank" rel="noopener noreferrer" className="underline hover:text-blue-100">nodejs.org</a>
                  </p>
                </div>

                <div className="flex flex-wrap gap-3">
                  <a
                    href="https://github.com/duonghuyhieu/hieu-phap-su/archive/refs/heads/main.zip"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="bg-purple-600 hover:bg-purple-700 text-white px-6 py-3 rounded-lg transition-colors font-semibold"
                  >
                    📥 Download GUI Tool
                  </a>
                  <a
                    href="https://github.com/duonghuyhieu/hieu-phap-su"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="bg-gray-700 hover:bg-gray-600 text-white px-6 py-3 rounded-lg transition-colors font-semibold"
                  >
                    🔗 Xem trên GitHub
                  </a>
                </div>
              </div>

              {/* Save Location Info */}
              <div className="bg-gray-900 p-6 rounded-lg">
                <h3 className="text-xl font-semibold text-white mb-4">📁 Vị trí Save Game</h3>
                <p className="text-gray-300 mb-3">Save game của Phasmophobia được lưu tại:</p>
                <div className="bg-gray-800 p-4 rounded-lg font-mono text-sm text-purple-300 mb-3">
                  C:\Users\[TÊN_BẠN]\AppData\LocalLow\Kinetic Games\Phasmophobia
                </div>
                <p className="text-gray-400 text-sm">
                  <strong>Cách mở nhanh:</strong> Nhấn Win + R, dán đường dẫn sau và Enter:
                </p>
                <div className="bg-gray-800 p-3 rounded-lg font-mono text-sm text-green-300 mt-2">
                  %APPDATA%\..\LocalLow\Kinetic Games\Phasmophobia
                </div>
              </div>

              {/* Available Saves List */}
              <div className="bg-gray-900 p-6 rounded-lg">
                <h3 className="text-xl font-semibold text-white mb-4">📥 Saves có sẵn từ cộng đồng</h3>
                <p className="text-gray-300 mb-4">
                  Dưới đây là danh sách saves đã được upload bởi cộng đồng.
                  Copy Save ID và sử dụng GUI để download!
                </p>
                {loading ? (
                  <p className="text-gray-400">Đang tải danh sách saves...</p>
                ) : saves.length === 0 ? (
                  <p className="text-gray-400">Chưa có saves nào. Hãy là người đầu tiên upload!</p>
                ) : (
                  <div className="space-y-3">
                    {saves.map((save) => (
                      <div key={save.id} className="bg-gray-800 p-4 rounded-lg border border-gray-700 hover:border-purple-500 transition-colors">
                        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                          <div className="flex-1">
                            <h4 className="text-white font-semibold text-lg">{save.name}</h4>
                            <p className="text-gray-400 text-sm">
                              ID: <code className="bg-gray-900 px-2 py-1 rounded text-purple-300">{shortenId(save.id)}</code> |
                              Uploaded: {formatTimestamp(save.timestamp)}
                            </p>
                          </div>
                          <div className="flex gap-2">
                            <button
                              onClick={() => copyToClipboard(save.id)}
                              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors text-sm font-semibold"
                            >
                              📋 Copy ID
                            </button>
                            <button
                              onClick={() => handleDownload(save.id)}
                              disabled={downloading}
                              className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded-lg transition-colors text-sm font-semibold disabled:opacity-50"
                            >
                              ⬇️ Download ZIP
                            </button>
                          </div>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              {/* Advanced: Manual Upload */}
              <details className="bg-gray-900 p-6 rounded-lg">
                <summary className="text-xl font-semibold text-white mb-4 cursor-pointer hover:text-purple-400 transition-colors">
                  ⚙️ Nâng cao: Upload thủ công qua Web (Không khuyến nghị)
                </summary>
                <div className="mt-4 space-y-4">
                  <p className="text-gray-400 text-sm">
                    Bạn cũng có thể upload save trực tiếp qua web, nhưng sử dụng GUI sẽ dễ dàng hơn nhiều.
                  </p>
                  <form onSubmit={handleUpload} className="space-y-4">
                    <div>
                      <label className="block text-gray-300 mb-2">Tên Save</label>
                      <input
                        type="text"
                        value={uploadName}
                        onChange={(e) => setUploadName(e.target.value)}
                        className="w-full px-4 py-2 bg-gray-800 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none"
                        placeholder="VD: Level 50 All Items"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-gray-300 mb-2">Chọn file ZIP</label>
                      <input
                        type="file"
                        accept=".zip"
                        onChange={(e) => setUploadFile(e.target.files[0])}
                        className="w-full px-4 py-2 bg-gray-800 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none"
                        required
                      />
                    </div>
                    <button
                      type="submit"
                      disabled={uploading}
                      className="w-full bg-purple-600 hover:bg-purple-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      {uploading ? 'Đang upload...' : '📤 Upload Save'}
                    </button>
                  </form>
                </div>
              </details>
            </div>
          )}

        </div>

        {/* Footer */}
        <div className="text-center mt-8 text-gray-400 text-sm">
          <p>Made with 💜 for the Phasmophobia community</p>
        </div>
      </div>
    </div>
  );
}

export default App;

