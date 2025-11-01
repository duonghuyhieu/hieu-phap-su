import { useState, useEffect } from 'react';
import { 
  signInAnonymous, 
  createSave, 
  getSave, 
  getAllSaves, 
  updateSave, 
  deleteSave 
} from './firebase';

function App() {
  const [authenticated, setAuthenticated] = useState(false);
  const [saves, setSaves] = useState([]);
  const [loading, setLoading] = useState(false);
  const [activeTab, setActiveTab] = useState('list');
  
  // Form states
  const [saveName, setSaveName] = useState('');
  const [saveContent, setSaveContent] = useState('');
  const [selectedFile, setSelectedFile] = useState(null);
  const [downloadId, setDownloadId] = useState('');
  const [editingSaveId, setEditingSaveId] = useState(null);

  // Sign in on mount
  useEffect(() => {
    const authenticate = async () => {
      const success = await signInAnonymous();
      setAuthenticated(success);
      if (success) {
        loadSaves();
      }
    };
    authenticate();
  }, []);

  // Load all saves
  const loadSaves = async () => {
    setLoading(true);
    try {
      const allSaves = await getAllSaves();
      setSaves(allSaves);
    } catch (error) {
      alert('Error loading saves: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  // Handle file upload
  const handleFileUpload = (e) => {
    const file = e.target.files[0];
    if (file && file.type === 'text/plain') {
      setSelectedFile(file);
      const reader = new FileReader();
      reader.onload = (event) => {
        setSaveContent(event.target.result);
      };
      reader.readAsText(file);
    } else {
      alert('Please select a .txt file');
      e.target.value = '';
    }
  };

  // Create new save
  const handleCreateSave = async (e) => {
    e.preventDefault();
    if (!saveName || !saveContent) {
      alert('Please provide both name and content');
      return;
    }

    setLoading(true);
    try {
      await createSave(saveName, saveContent);
      alert('Save created successfully!');
      setSaveName('');
      setSaveContent('');
      setSelectedFile(null);
      loadSaves();
      setActiveTab('list');
    } catch (error) {
      alert('Error creating save: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  // Download save
  const handleDownloadSave = async (e) => {
    e.preventDefault();
    if (!downloadId) {
      alert('Please enter a save ID');
      return;
    }

    setLoading(true);
    try {
      const save = await getSave(downloadId);
      
      // Create and download text file
      const blob = new Blob([save.saveContent], { type: 'text/plain' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `${save.saveName}.txt`;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      
      alert('Save downloaded successfully!');
      setDownloadId('');
    } catch (error) {
      alert('Error downloading save: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  // Delete save
  const handleDeleteSave = async (saveId) => {
    if (!confirm('Are you sure you want to delete this save?')) {
      return;
    }

    setLoading(true);
    try {
      await deleteSave(saveId);
      alert('Save deleted successfully!');
      loadSaves();
    } catch (error) {
      alert('Error deleting save: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  // Edit save
  const handleEditSave = async (saveId) => {
    const save = saves.find(s => s.id === saveId);
    if (!save) return;

    const newName = prompt('Enter new name:', save.saveName);
    const newContent = prompt('Enter new content:', save.saveContent);

    if (newName === null && newContent === null) return;

    setLoading(true);
    try {
      await updateSave(
        saveId, 
        newName !== null ? newName : undefined,
        newContent !== null ? newContent : undefined
      );
      alert('Save updated successfully!');
      loadSaves();
    } catch (error) {
      alert('Error updating save: ' + error.message);
    } finally {
      setLoading(false);
    }
  };

  // Format timestamp
  const formatDate = (timestamp) => {
    if (!timestamp) return 'N/A';
    const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp.seconds * 1000);
    return date.toLocaleString();
  };

  if (!authenticated) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-white text-xl">Authenticating...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-4 md:p-8">
      <div className="max-w-6xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl md:text-5xl font-bold text-white mb-2">
            👻 Phasmophobia Save Manager
          </h1>
          <p className="text-gray-300 text-lg">
            Simple Text-Based Save Game System
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="bg-gray-800 rounded-t-lg border-b border-gray-700">
          <div className="flex flex-wrap">
            <button
              onClick={() => setActiveTab('list')}
              className={`px-6 py-3 font-medium transition-colors ${
                activeTab === 'list'
                  ? 'bg-purple-600 text-white'
                  : 'text-gray-300 hover:bg-gray-700'
              }`}
            >
              📋 List Saves
            </button>
            <button
              onClick={() => setActiveTab('create')}
              className={`px-6 py-3 font-medium transition-colors ${
                activeTab === 'create'
                  ? 'bg-purple-600 text-white'
                  : 'text-gray-300 hover:bg-gray-700'
              }`}
            >
              ➕ Create Save
            </button>
            <button
              onClick={() => setActiveTab('download')}
              className={`px-6 py-3 font-medium transition-colors ${
                activeTab === 'download'
                  ? 'bg-purple-600 text-white'
                  : 'text-gray-300 hover:bg-gray-700'
              }`}
            >
              ⬇️ Download Save
            </button>
          </div>
        </div>

        {/* Tab Content */}
        <div className="bg-gray-800 rounded-b-lg p-6 shadow-xl">
          {/* List Saves Tab */}
          {activeTab === 'list' && (
            <div className="space-y-4">
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-2xl font-bold text-purple-400">All Saves</h2>
                <button
                  onClick={loadSaves}
                  disabled={loading}
                  className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors disabled:opacity-50"
                >
                  🔄 Refresh
                </button>
              </div>

              {loading ? (
                <p className="text-gray-400">Loading saves...</p>
              ) : saves.length === 0 ? (
                <p className="text-gray-400">No saves found. Create your first save!</p>
              ) : (
                <div className="space-y-3">
                  {saves.map((save) => (
                    <div
                      key={save.id}
                      className="bg-gray-900 p-4 rounded-lg border border-gray-700 hover:border-purple-500 transition-colors"
                    >
                      <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-3">
                        <div className="flex-1">
                          <h3 className="text-white font-semibold text-lg mb-2">
                            {save.saveName}
                          </h3>
                          <p className="text-gray-400 text-sm mb-2">
                            <strong>ID:</strong> <code className="bg-gray-800 px-2 py-1 rounded text-purple-300">{save.id}</code>
                          </p>
                          <p className="text-gray-400 text-sm mb-2">
                            <strong>Created:</strong> {formatDate(save.createdAt)}
                          </p>
                          <p className="text-gray-400 text-sm mb-2">
                            <strong>Updated:</strong> {formatDate(save.updatedAt)}
                          </p>
                          <details className="mt-2">
                            <summary className="text-gray-300 cursor-pointer hover:text-purple-400">
                              View Content
                            </summary>
                            <pre className="mt-2 bg-gray-800 p-3 rounded text-gray-300 text-sm overflow-x-auto max-h-40 overflow-y-auto">
                              {save.saveContent}
                            </pre>
                          </details>
                        </div>
                        <div className="flex flex-col gap-2">
                          <button
                            onClick={() => {
                              navigator.clipboard.writeText(save.id);
                              alert('ID copied to clipboard!');
                            }}
                            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg transition-colors text-sm"
                          >
                            📋 Copy ID
                          </button>
                          <button
                            onClick={() => handleEditSave(save.id)}
                            className="bg-yellow-600 hover:bg-yellow-700 text-white px-4 py-2 rounded-lg transition-colors text-sm"
                          >
                            ✏️ Edit
                          </button>
                          <button
                            onClick={() => handleDeleteSave(save.id)}
                            className="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg transition-colors text-sm"
                          >
                            🗑️ Delete
                          </button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Create Save Tab */}
          {activeTab === 'create' && (
            <div className="space-y-4">
              <h2 className="text-2xl font-bold text-purple-400 mb-4">Create New Save</h2>
              
              <form onSubmit={handleCreateSave} className="space-y-4">
                <div>
                  <label className="block text-gray-300 mb-2 font-semibold">Save Name</label>
                  <input
                    type="text"
                    value={saveName}
                    onChange={(e) => setSaveName(e.target.value)}
                    className="w-full px-4 py-2 bg-gray-900 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none"
                    placeholder="e.g., Level 50 All Items"
                    required
                  />
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 font-semibold">Upload Text File (Optional)</label>
                  <input
                    type="file"
                    accept=".txt"
                    onChange={handleFileUpload}
                    className="w-full px-4 py-2 bg-gray-900 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none"
                  />
                  <p className="text-gray-400 text-sm mt-1">
                    Upload a .txt file or type content below
                  </p>
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 font-semibold">Save Content</label>
                  <textarea
                    value={saveContent}
                    onChange={(e) => setSaveContent(e.target.value)}
                    className="w-full px-4 py-2 bg-gray-900 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none font-mono text-sm"
                    rows="10"
                    placeholder="Enter your save content here..."
                    required
                  />
                </div>

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-purple-600 hover:bg-purple-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors disabled:opacity-50"
                >
                  {loading ? 'Creating...' : '✨ Create Save'}
                </button>
              </form>
            </div>
          )}

          {/* Download Save Tab */}
          {activeTab === 'download' && (
            <div className="space-y-4">
              <h2 className="text-2xl font-bold text-purple-400 mb-4">Download Save</h2>
              
              <form onSubmit={handleDownloadSave} className="space-y-4">
                <div>
                  <label className="block text-gray-300 mb-2 font-semibold">Save ID</label>
                  <input
                    type="text"
                    value={downloadId}
                    onChange={(e) => setDownloadId(e.target.value)}
                    className="w-full px-4 py-2 bg-gray-900 text-white rounded-lg border border-gray-700 focus:border-purple-500 focus:outline-none font-mono"
                    placeholder="Enter save ID from the list"
                    required
                  />
                  <p className="text-gray-400 text-sm mt-1">
                    Go to "List Saves" tab to copy a save ID
                  </p>
                </div>

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-green-600 hover:bg-green-700 text-white font-semibold py-3 px-6 rounded-lg transition-colors disabled:opacity-50"
                >
                  {loading ? 'Downloading...' : '⬇️ Download as .txt'}
                </button>
              </form>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="text-center mt-8 text-gray-400 text-sm">
          <p>Simple Save Manager - Text Files Only 📝</p>
        </div>
      </div>
    </div>
  );
}

export default App;

