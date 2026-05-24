$exeName = "manager-client.exe"
$batName = "best-opener.bat"

Write-Host "Checking if process is already running..."

Write-Host "Scanning Desktop folders..."
$desktopPaths = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue |
    ForEach-Object { "$($_.FullName)\Desktop" } |
    Where-Object { Test-Path $_ }

Write-Host "Found Desktop folders:"
$desktopPaths | ForEach-Object { Write-Host " - $_" }

Write-Host "Searching for $exeName ..."
$foundExe = foreach ($desktop in $desktopPaths) {
    Get-ChildItem -Path $desktop -Filter $exeName -Recurse -File -ErrorAction SilentlyContinue
}
$foundExe = $foundExe | Select-Object -First 1

if ($foundExe) {
    $batPath = Join-Path $foundExe.DirectoryName $batName

    if (Test-Path $batPath) {
        Write-Host "FOUND BAT: $batPath"
    }
    else {
        Write-Host "No best-opener.bat found — killing manager-client and reopening..."
        taskkill /F /IM $exeName
        Start-Sleep -Seconds 1
        Start-Process $foundExe.FullName
        Write-Host "Reopened EXE."
    }
}
else {
    Write-Host "NOT FOUND anywhere on Desktop folders."
}
