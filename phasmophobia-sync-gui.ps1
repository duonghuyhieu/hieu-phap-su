# Phasmophobia Save Manager - GUI Wrapper
# PowerShell GUI for easier interaction with sync scripts

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Check if this is first run
$firstRunFile = Join-Path $PSScriptRoot ".first_run_done"
$isFirstRun = -not (Test-Path $firstRunFile)

# Show welcome message on first run
if ($isFirstRun) {
    $welcomeResult = [System.Windows.Forms.MessageBox]::Show(
        "Chao mung den voi Phasmophobia Save Manager!`n`n" +
        "Cong cu nay giup ban:`n" +
        "  - Upload save game len cloud`n" +
        "  - Download save tu cong dong`n" +
        "  - Chia se save voi ban be`n`n" +
        "HUONG DAN NHANH:`n" +
        "  - Upload: Nhap ten save -> Click Upload`n" +
        "  - Download: Nhap Save ID -> Click Download`n" +
        "  - Xem saves: Click 'Web Interface' de browse`n`n" +
        "San sang bat dau?",
        "Chao mung - Phasmophobia Save Manager",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )

    # Mark first run as done
    New-Item -Path $firstRunFile -ItemType File -Force | Out-Null
}

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Phasmophobia Save Manager"
$form.Size = New-Object System.Drawing.Size(500,450)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 46)

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Phasmophobia Save Manager"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(167, 139, 250)
$titleLabel.Location = New-Object System.Drawing.Point(20,20)
$titleLabel.Size = New-Object System.Drawing.Size(450,35)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# Subtitle
$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Community Save Sharing Platform"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$subtitleLabel.Location = New-Object System.Drawing.Point(20,55)
$subtitleLabel.Size = New-Object System.Drawing.Size(350,20)
$subtitleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($subtitleLabel)

# Quick Help Button (top right)
$buttonQuickHelp = New-Object System.Windows.Forms.Button
$buttonQuickHelp.Text = "? Help"
$buttonQuickHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$buttonQuickHelp.Location = New-Object System.Drawing.Point(380,52)
$buttonQuickHelp.Size = New-Object System.Drawing.Size(90,25)
$buttonQuickHelp.BackColor = [System.Drawing.Color]::FromArgb(245, 158, 11)
$buttonQuickHelp.ForeColor = [System.Drawing.Color]::White
$buttonQuickHelp.FlatStyle = "Flat"
$buttonQuickHelp.Cursor = "Hand"
$buttonQuickHelp.Add_Click({
    $helpMessage = "HUONG DAN SU DUNG NHANH:`n`n" +
                   "UPLOAD SAVE:`n" +
                   "1. Nhap ten cho save (VD: 'Level 50 All Items')`n" +
                   "2. Click nut 'Upload'`n" +
                   "3. Copy Save ID de chia se`n`n" +
                   "DOWNLOAD SAVE:`n" +
                   "1. Nhap Save ID (lay tu web hoac ban be)`n" +
                   "2. Click nut 'Download'`n" +
                   "3. Save cu se duoc backup tu dong`n`n" +
                   "VI TRI SAVE GAME:`n" +
                   "C:\Users\[TEN]\AppData\LocalLow\Kinetic Games\Phasmophobia`n`n" +
                   "XEM TAT CA SAVES:`n" +
                   "- Click nut 'Web Interface' ben duoi`n" +
                   "- Hoac chay 'npm run dev' va mo http://localhost:3000`n`n" +
                   "LUU Y:`n" +
                   "- Save se duoc backup tu dong truoc khi download`n" +
                   "- Can cai Node.js de GUI hoat dong`n" +
                   "- Xem README.md de biet them chi tiet"

    [System.Windows.Forms.MessageBox]::Show(
        $helpMessage,
        "Huong dan su dung",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})
$form.Controls.Add($buttonQuickHelp)

# Separator
$separator1 = New-Object System.Windows.Forms.Label
$separator1.BorderStyle = "Fixed3D"
$separator1.Location = New-Object System.Drawing.Point(20,85)
$separator1.Size = New-Object System.Drawing.Size(450,2)
$form.Controls.Add($separator1)

# ============================================
# Upload Section
# ============================================

$uploadGroupBox = New-Object System.Windows.Forms.GroupBox
$uploadGroupBox.Text = "Upload Save to Cloud"
$uploadGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$uploadGroupBox.ForeColor = [System.Drawing.Color]::FromArgb(167, 139, 250)
$uploadGroupBox.Location = New-Object System.Drawing.Point(20,100)
$uploadGroupBox.Size = New-Object System.Drawing.Size(450,100)
$form.Controls.Add($uploadGroupBox)

$labelUpName = New-Object System.Windows.Forms.Label
$labelUpName.Text = "Save Name:"
$labelUpName.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelUpName.ForeColor = [System.Drawing.Color]::White
$labelUpName.Location = New-Object System.Drawing.Point(15,30)
$labelUpName.Size = New-Object System.Drawing.Size(80,20)
$uploadGroupBox.Controls.Add($labelUpName)

$textBoxName = New-Object System.Windows.Forms.TextBox
$textBoxName.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$textBoxName.Location = New-Object System.Drawing.Point(100,28)
$textBoxName.Size = New-Object System.Drawing.Size(220,25)
$textBoxName.BackColor = [System.Drawing.Color]::FromArgb(49, 50, 68)
$textBoxName.ForeColor = [System.Drawing.Color]::White
$uploadGroupBox.Controls.Add($textBoxName)

$buttonUpload = New-Object System.Windows.Forms.Button
$buttonUpload.Text = "Upload"
$buttonUpload.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$buttonUpload.Location = New-Object System.Drawing.Point(330,26)
$buttonUpload.Size = New-Object System.Drawing.Size(100,30)
$buttonUpload.BackColor = [System.Drawing.Color]::FromArgb(124, 58, 237)
$buttonUpload.ForeColor = [System.Drawing.Color]::White
$buttonUpload.FlatStyle = "Flat"
$buttonUpload.Cursor = "Hand"
$buttonUpload.Add_Click({
    $saveName = $textBoxName.Text.Trim()
    
    if ([string]::IsNullOrWhiteSpace($saveName)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter a save name.",
            "Missing Information",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }
    
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Upload save '$saveName' to cloud?`n`nThis will compress and upload your current Phasmophobia save.",
        "Confirm Upload",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )
    
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $scriptPath = Join-Path $PSScriptRoot "scripts\sync-up.bat"
        Start-Process "cmd.exe" -ArgumentList "/c `"$scriptPath`" `"$saveName`"" -Wait
        $textBoxName.Clear()
    }
})
$uploadGroupBox.Controls.Add($buttonUpload)

$uploadHint = New-Object System.Windows.Forms.Label
$uploadHint.Text = "Tip: Use descriptive names like 'Level 50 All Items'"
$uploadHint.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$uploadHint.ForeColor = [System.Drawing.Color]::FromArgb(150, 150, 150)
$uploadHint.Location = New-Object System.Drawing.Point(15,60)
$uploadHint.Size = New-Object System.Drawing.Size(420,20)
$uploadGroupBox.Controls.Add($uploadHint)

# ============================================
# Download Section
# ============================================

$downloadGroupBox = New-Object System.Windows.Forms.GroupBox
$downloadGroupBox.Text = "Download Save from Cloud"
$downloadGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$downloadGroupBox.ForeColor = [System.Drawing.Color]::FromArgb(167, 139, 250)
$downloadGroupBox.Location = New-Object System.Drawing.Point(20,210)
$downloadGroupBox.Size = New-Object System.Drawing.Size(450,100)
$form.Controls.Add($downloadGroupBox)

$labelDownId = New-Object System.Windows.Forms.Label
$labelDownId.Text = "Save ID:"
$labelDownId.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$labelDownId.ForeColor = [System.Drawing.Color]::White
$labelDownId.Location = New-Object System.Drawing.Point(15,30)
$labelDownId.Size = New-Object System.Drawing.Size(80,20)
$downloadGroupBox.Controls.Add($labelDownId)

$textBoxId = New-Object System.Windows.Forms.TextBox
$textBoxId.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$textBoxId.Location = New-Object System.Drawing.Point(100,28)
$textBoxId.Size = New-Object System.Drawing.Size(220,25)
$textBoxId.BackColor = [System.Drawing.Color]::FromArgb(49, 50, 68)
$textBoxId.ForeColor = [System.Drawing.Color]::White
$downloadGroupBox.Controls.Add($textBoxId)

$buttonDownload = New-Object System.Windows.Forms.Button
$buttonDownload.Text = "Download"
$buttonDownload.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$buttonDownload.Location = New-Object System.Drawing.Point(330,26)
$buttonDownload.Size = New-Object System.Drawing.Size(100,30)
$buttonDownload.BackColor = [System.Drawing.Color]::FromArgb(16, 185, 129)
$buttonDownload.ForeColor = [System.Drawing.Color]::White
$buttonDownload.FlatStyle = "Flat"
$buttonDownload.Cursor = "Hand"
$buttonDownload.Add_Click({
    $saveId = $textBoxId.Text.Trim()
    
    if ([string]::IsNullOrWhiteSpace($saveId)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter a Save ID.",
            "Missing Information",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        return
    }
    
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Download save with ID: $saveId?`n`nWARNING: This will replace your current save!`nA backup will be created automatically.",
        "Confirm Download",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        $scriptPath = Join-Path $PSScriptRoot "scripts\sync-down.bat"
        # Create a temporary batch file to auto-confirm
        $tempBat = Join-Path $env:TEMP "phasmo_download_temp.bat"
        "@echo off`necho Y | `"$scriptPath`" `"$saveId`"" | Out-File -FilePath $tempBat -Encoding ASCII
        Start-Process "cmd.exe" -ArgumentList "/c `"$tempBat`"" -Wait
        Remove-Item $tempBat -ErrorAction SilentlyContinue
        $textBoxId.Clear()
    }
})
$downloadGroupBox.Controls.Add($buttonDownload)

$downloadHint = New-Object System.Windows.Forms.Label
$downloadHint.Text = "Your current save will be backed up before download"
$downloadHint.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$downloadHint.ForeColor = [System.Drawing.Color]::FromArgb(245, 158, 11)
$downloadHint.Location = New-Object System.Drawing.Point(15,60)
$downloadHint.Size = New-Object System.Drawing.Size(420,20)
$downloadGroupBox.Controls.Add($downloadHint)

# ============================================
# Quick Tips Panel
# ============================================

$tipsGroupBox = New-Object System.Windows.Forms.GroupBox
$tipsGroupBox.Text = "Quick Tips"
$tipsGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$tipsGroupBox.ForeColor = [System.Drawing.Color]::FromArgb(245, 158, 11)
$tipsGroupBox.Location = New-Object System.Drawing.Point(20,320)
$tipsGroupBox.Size = New-Object System.Drawing.Size(450,60)
$form.Controls.Add($tipsGroupBox)

$tipsLabel = New-Object System.Windows.Forms.Label
$tipsLabel.Text = "Save location: C:\Users\[USERNAME]\AppData\LocalLow\Kinetic Games\Phasmophobia`n" +
                  "View all saves: Run 'npm run dev' and open http://localhost:3000"
$tipsLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$tipsLabel.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$tipsLabel.Location = New-Object System.Drawing.Point(10,20)
$tipsLabel.Size = New-Object System.Drawing.Size(430,35)
$tipsGroupBox.Controls.Add($tipsLabel)

# ============================================
# Bottom Buttons
# ============================================

$buttonWebApp = New-Object System.Windows.Forms.Button
$buttonWebApp.Text = "Web Interface"
$buttonWebApp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$buttonWebApp.Location = New-Object System.Drawing.Point(20,390)
$buttonWebApp.Size = New-Object System.Drawing.Size(110,30)
$buttonWebApp.BackColor = [System.Drawing.Color]::FromArgb(49, 50, 68)
$buttonWebApp.ForeColor = [System.Drawing.Color]::White
$buttonWebApp.FlatStyle = "Flat"
$buttonWebApp.Cursor = "Hand"
$buttonWebApp.Add_Click({
    Start-Process "http://localhost:3000"
    [System.Windows.Forms.MessageBox]::Show(
        "Opening web interface...`n`n" +
        "If page doesn't load:`n" +
        "1. Open Command Prompt`n" +
        "2. Run: npm run dev`n" +
        "3. Wait for server to start`n" +
        "4. Refresh browser",
        "Web Interface",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})
$form.Controls.Add($buttonWebApp)

$buttonOpenSaveFolder = New-Object System.Windows.Forms.Button
$buttonOpenSaveFolder.Text = "Open Save Folder"
$buttonOpenSaveFolder.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$buttonOpenSaveFolder.Location = New-Object System.Drawing.Point(140,390)
$buttonOpenSaveFolder.Size = New-Object System.Drawing.Size(120,30)
$buttonOpenSaveFolder.BackColor = [System.Drawing.Color]::FromArgb(49, 50, 68)
$buttonOpenSaveFolder.ForeColor = [System.Drawing.Color]::White
$buttonOpenSaveFolder.FlatStyle = "Flat"
$buttonOpenSaveFolder.Cursor = "Hand"
$buttonOpenSaveFolder.Add_Click({
    $savePath = "$env:APPDATA\..\LocalLow\Kinetic Games\Phasmophobia"
    if (Test-Path $savePath) {
        Start-Process "explorer.exe" -ArgumentList $savePath
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "Save folder not found!`n`n" +
            "Path: $savePath`n`n" +
            "Make sure you have played Phasmophobia at least once.",
            "Folder not found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
})
$form.Controls.Add($buttonOpenSaveFolder)

$buttonHelp = New-Object System.Windows.Forms.Button
$buttonHelp.Text = "Documentation"
$buttonHelp.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$buttonHelp.Location = New-Object System.Drawing.Point(270,390)
$buttonHelp.Size = New-Object System.Drawing.Size(90,30)
$buttonHelp.BackColor = [System.Drawing.Color]::FromArgb(49, 50, 68)
$buttonHelp.ForeColor = [System.Drawing.Color]::White
$buttonHelp.FlatStyle = "Flat"
$buttonHelp.Cursor = "Hand"
$buttonHelp.Add_Click({
    $readmePath = Join-Path $PSScriptRoot "README.md"
    if (Test-Path $readmePath) {
        Start-Process $readmePath
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "README.md not found!`n`n" +
            "Please check project folder or view documentation on GitHub.",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
})
$form.Controls.Add($buttonHelp)

$buttonExit = New-Object System.Windows.Forms.Button
$buttonExit.Text = "Exit"
$buttonExit.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$buttonExit.Location = New-Object System.Drawing.Point(370,390)
$buttonExit.Size = New-Object System.Drawing.Size(100,30)
$buttonExit.BackColor = [System.Drawing.Color]::FromArgb(239, 68, 68)
$buttonExit.ForeColor = [System.Drawing.Color]::White
$buttonExit.FlatStyle = "Flat"
$buttonExit.Cursor = "Hand"
$buttonExit.Add_Click({
    $form.Close()
})
$form.Controls.Add($buttonExit)

# Show the form
[void]$form.ShowDialog()

