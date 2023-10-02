#Test_Users
#AdeleV@M365x10024863.OnMicrosoft.com
#Alexw@M365x10024863.OnMicrosoft.com

# Set the timezone
Set-TimeZone -Id "AUS Eastern Standard Time"

# Create a log directory and log file
$logPath = "C:\poshlog"
if (-not (Test-Path -Path $logPath -PathType Container)) {
    New-Item -Path $logPath -ItemType Directory
}
$logFilePath = Join-Path -Path $logPath -ChildPath "featurelog.txt"

# Check if the log file exists before creating it
if (-not (Test-Path -Path $logFilePath -PathType Leaf)) {
    New-Item -Path $logFilePath -ItemType File
}

# Define the URL for the Chrome installer
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$installerPath = "$env:TEMP\chrome_installer.exe"

# Download and install Chrome silently
try {
    Write-Host "Downloading and installing Chrome..."
    Invoke-WebRequest -Uri $chromeUrl -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/silent", "/install" -Wait
    
    # Set Chrome as the default browser using PowerShell
    Write-Host "Setting Chrome as the default browser..."
    $chromePath = Join-Path (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe")."(default)" "chrome.exe"
    $chromeHTML = "ChromeHTML"
    $httpProgId = "http"
    $httpsProgId = "https"
    
    # Set Chrome as the default browser for HTTP and HTTPS
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$httpProgId\UserChoice" -Name "ProgId" -Value $chromeHTML
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\$httpsProgId\UserChoice" -Name "ProgId" -Value $chromeHTML
    
    Write-Host "Chrome installation and default browser setup completed."

} catch {
    Write-Host "Error installing Chrome: $_"
}

# Define the URL of the MSI file for Zscaler Client Connector
$msiUrl = "https://d32a6ru7mhaq0c.cloudfront.net/Zscaler-windows-4.3.0.121-installer-x64.msi"
$downloadPath = "$env:TEMP\Zscaler-windows-4.3.0.121-installer-x64.msi"

# Define the new POLICYTOKEN value
$policyToken = "393335313A333A38636464623136322D303930302D346636632D396534362D376265313361613266336165"

# Download and install Zscaler Client Connector silently with additional parameters
try {
    Write-Host "Downloading and installing Zscaler Client Connector..."
    Invoke-WebRequest -Uri $msiUrl -OutFile $downloadPath
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$downloadPath`" /qn CLOUDNAME=zscalerthree HIDEAPPUIONLAUNCH=1 POLICYTOKEN=$policyToken REINSTALLDRIVER=1 STRICTENFORCEMENT=0 USERDOMAIN=petethebear.com" -Wait
    Write-Host "Zscaler Client Connector installation completed."

} catch {
    Write-Host "Error installing Zscaler Client Connector: $_"
}

#Add Dropbox Shortcut to Desktop get get GPO Backup


$shortcutPath = "$env:USERPROFILE\Desktop\Dropbox.lnk"
$targetURL = "https://www.dropbox.com/sh/pb86h95x693fw4t/AAC7qH41WdAe_8jnEbIWzBP8a?dl=0"

$chromePath = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe' -ErrorAction SilentlyContinue).'(default)'
if ($chromePath -eq $null) {
    Write-Host "Chrome is not installed."
    exit
}

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $chromePath
$shortcut.Arguments = $targetURL
$shortcut.Save()
