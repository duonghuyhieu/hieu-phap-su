# 🧪 Test Plan - Phasmophobia Save Manager

## Test Environment

- **URL**: http://localhost:3001
- **Browser**: Any modern browser (Chrome, Firefox, Edge, Safari)
- **Firebase**: Firestore with Anonymous Authentication
- **Status**: ✅ Dev server running

---

## 📋 Test Checklist

### 1. Initial Load Test

- [ ] Open http://localhost:3001 in browser
- [ ] Verify page loads without errors
- [ ] Check browser console for errors (F12)
- [ ] Verify Firebase authentication completes
- [ ] Verify "List Saves" tab is active by default

**Expected Result**: Page loads successfully, no console errors, Firebase connected.

---

### 2. List Saves Tab Tests

#### 2.1 View Saves List
- [ ] Click "List Saves" tab
- [ ] Verify saves are loaded from Firestore
- [ ] Check if saves are sorted by creation date (newest first)
- [ ] Verify each save shows:
  - Save name
  - Save ID
  - Created date
  - Updated date
  - "View Content" button
  - "Copy ID" button
  - "Edit" button
  - "Delete" button

**Expected Result**: All saves displayed correctly with all information.

#### 2.2 View Content
- [ ] Click "View Content" on any save
- [ ] Verify content is displayed
- [ ] Click "Hide Content"
- [ ] Verify content is hidden

**Expected Result**: Content toggles correctly.

#### 2.3 Copy Save ID
- [ ] Click "Copy ID" button
- [ ] Paste into a text editor (Ctrl+V)
- [ ] Verify the correct Save ID is copied

**Expected Result**: Save ID copied to clipboard successfully.

#### 2.4 Refresh List
- [ ] Click "🔄 Refresh" button
- [ ] Verify loading state appears
- [ ] Verify list is reloaded

**Expected Result**: List refreshes successfully.

---

### 3. Create Save Tab Tests

#### 3.1 Create Save with Text Input
- [ ] Click "Create Save" tab
- [ ] Enter save name: "Test Save 1"
- [ ] Type content in textarea: "This is a test save content"
- [ ] Click "Create Save" button
- [ ] Verify success alert appears
- [ ] Verify form is cleared
- [ ] Verify redirected to "List Saves" tab
- [ ] Verify new save appears in list

**Expected Result**: Save created successfully and appears in list.

#### 3.2 Create Save with File Upload
- [ ] Create a test file `test.txt` with content: "File upload test"
- [ ] Click "Create Save" tab
- [ ] Enter save name: "Test Save 2"
- [ ] Click "Choose File" and select `test.txt`
- [ ] Verify file name appears
- [ ] Verify textarea is populated with file content
- [ ] Click "Create Save" button
- [ ] Verify success alert appears
- [ ] Verify new save appears in list

**Expected Result**: Save created from file successfully.

#### 3.3 Validation Tests
- [ ] Click "Create Save" tab
- [ ] Leave name empty, add content
- [ ] Click "Create Save"
- [ ] Verify error alert: "Please provide both name and content"

- [ ] Enter name, leave content empty
- [ ] Click "Create Save"
- [ ] Verify error alert: "Please provide both name and content"

**Expected Result**: Validation works correctly.

---

### 4. Edit Save Tests

#### 4.1 Edit Save Name
- [ ] Click "Edit" on any save
- [ ] Change the save name
- [ ] Click "Save Changes"
- [ ] Verify success alert
- [ ] Verify name updated in list

**Expected Result**: Save name updated successfully.

#### 4.2 Edit Save Content
- [ ] Click "Edit" on any save
- [ ] Change the content
- [ ] Click "Save Changes"
- [ ] Verify success alert
- [ ] Click "View Content" to verify changes

**Expected Result**: Save content updated successfully.

#### 4.3 Cancel Edit
- [ ] Click "Edit" on any save
- [ ] Make changes
- [ ] Click "Cancel"
- [ ] Verify edit form closes
- [ ] Verify changes were not saved

**Expected Result**: Edit cancelled successfully.

---

### 5. Delete Save Tests

#### 5.1 Delete Save
- [ ] Click "Delete" on any save
- [ ] Verify confirmation dialog appears
- [ ] Click "OK" to confirm
- [ ] Verify success alert
- [ ] Verify save removed from list

**Expected Result**: Save deleted successfully.

#### 5.2 Cancel Delete
- [ ] Click "Delete" on any save
- [ ] Click "Cancel" in confirmation dialog
- [ ] Verify save is NOT deleted

**Expected Result**: Delete cancelled successfully.

---

### 6. Download Save Tab Tests

#### 6.1 Download Save by ID
- [ ] Go to "List Saves" tab
- [ ] Copy a Save ID
- [ ] Click "Download Save" tab
- [ ] Paste the Save ID
- [ ] Click "Download as .txt"
- [ ] Verify file downloads
- [ ] Open downloaded file
- [ ] Verify content matches the save

**Expected Result**: Save downloaded as .txt file with correct content.

#### 6.2 Download with Invalid ID
- [ ] Click "Download Save" tab
- [ ] Enter invalid ID: "invalid123"
- [ ] Click "Download as .txt"
- [ ] Verify error alert appears

**Expected Result**: Error message displayed for invalid ID.

#### 6.3 Download with Empty ID
- [ ] Click "Download Save" tab
- [ ] Leave ID field empty
- [ ] Click "Download as .txt"
- [ ] Verify error alert: "Please enter a save ID"

**Expected Result**: Validation works correctly.

---

### 7. Firebase Integration Tests

#### 7.1 Check Firestore Data
- [ ] Open Firebase Console
- [ ] Navigate to Firestore Database
- [ ] Check "saves" collection
- [ ] Verify documents have correct structure:
  - saveName (string)
  - saveContent (string)
  - createdAt (timestamp)
  - updatedAt (timestamp)

**Expected Result**: Data structure matches schema.

#### 7.2 Real-time Updates
- [ ] Open app in two browser tabs
- [ ] Create a save in Tab 1
- [ ] Click "Refresh" in Tab 2
- [ ] Verify new save appears

**Expected Result**: Changes sync across tabs.

---

### 8. Error Handling Tests

#### 8.1 Network Error Simulation
- [ ] Open browser DevTools (F12)
- [ ] Go to Network tab
- [ ] Set throttling to "Offline"
- [ ] Try to create a save
- [ ] Verify error alert appears
- [ ] Set throttling back to "No throttling"

**Expected Result**: Graceful error handling.

#### 8.2 Firebase Permission Error
- [ ] Temporarily change Firestore rules to deny all
- [ ] Try to create a save
- [ ] Verify error alert appears
- [ ] Restore original rules

**Expected Result**: Permission errors handled gracefully.

---

### 9. UI/UX Tests

#### 9.1 Responsive Design
- [ ] Resize browser window to mobile size (375px)
- [ ] Verify layout adapts correctly
- [ ] Test all features on mobile size
- [ ] Resize to tablet size (768px)
- [ ] Verify layout works
- [ ] Resize to desktop size (1920px)
- [ ] Verify layout works

**Expected Result**: Responsive design works on all screen sizes.

#### 9.2 Loading States
- [ ] Verify loading spinner appears during:
  - Creating save
  - Downloading save
  - Deleting save
  - Updating save
  - Loading saves list

**Expected Result**: Loading states provide feedback.

#### 9.3 Tab Navigation
- [ ] Click each tab
- [ ] Verify active tab is highlighted
- [ ] Verify content changes correctly

**Expected Result**: Tab navigation works smoothly.

---

### 10. Performance Tests

#### 10.1 Large Content Test
- [ ] Create a save with 10,000+ characters
- [ ] Verify it saves successfully
- [ ] Verify it displays correctly
- [ ] Download and verify content

**Expected Result**: Handles large content without issues.

#### 10.2 Multiple Saves Test
- [ ] Create 20+ saves
- [ ] Verify list loads quickly
- [ ] Verify scrolling is smooth
- [ ] Verify all operations still work

**Expected Result**: Performance remains good with many saves.

---

## 🐛 Known Issues to Watch For

1. **Firestore 1MB Limit**: Very large saves may exceed Firestore document limit
2. **Browser Compatibility**: Test on multiple browsers
3. **Timestamp Display**: Verify timestamps show correct timezone
4. **File Upload**: Test with various file types (should only accept .txt)

---

## ✅ Test Results

### Test Date: _____________

### Tester: _____________

### Results Summary:

- [ ] All tests passed
- [ ] Some tests failed (list below)
- [ ] Critical issues found (list below)

### Failed Tests:
```
(List any failed tests here)
```

### Critical Issues:
```
(List any critical issues here)
```

### Notes:
```
(Add any additional notes here)
```

---

## 📊 Test Coverage

- **Unit Tests**: N/A (manual testing only)
- **Integration Tests**: Firebase CRUD operations
- **E2E Tests**: Full user workflows
- **UI Tests**: Responsive design, loading states
- **Error Handling**: Network errors, validation

---

## 🚀 Next Steps After Testing

1. Fix any critical issues found
2. Implement automated tests (Jest, React Testing Library)
3. Add E2E tests (Playwright, Cypress)
4. Set up CI/CD pipeline
5. Deploy to production

---

**Happy Testing!** 🧪👻

