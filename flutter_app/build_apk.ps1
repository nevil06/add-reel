Write-Host "Building AdReel APK..." -ForegroundColor Cyan
Write-Host ""

# Navigate to flutter app directory
Set-Location $PSScriptRoot

# Clean build
Write-Host "Cleaning previous build..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build APK
Write-Host "Building release APK (this may take 5-10 minutes)..." -ForegroundColor Yellow
flutter build apk --release --split-per-abi

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "SUCCESS! APK built successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Location:" -ForegroundColor Cyan
    Write-Host "build\app\outputs\flutter-apk\" -ForegroundColor White
    Write-Host ""
    
    # Open folder
    Start-Process explorer.exe -ArgumentList "build\app\outputs\flutter-apk\"
} else {
    Write-Host ""
    Write-Host "Build failed. Try building in Android Studio instead." -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
