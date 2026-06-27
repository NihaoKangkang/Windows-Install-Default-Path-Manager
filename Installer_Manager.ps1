if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting Administrator privileges..." -ForegroundColor Yellow
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"
$DefaultPF = "C:\Program Files"
$DefaultPF86 = "C:\Program Files (x86)"

# --- Main Logic ---
$running = $true
while ($running) {
    Clear-Host
    $CurrentPF = (Get-ItemProperty -Path $RegPath -Name "ProgramFilesDir").ProgramFilesDir
    Write-Host "=== Windows Install Default Path Manager ===" -ForegroundColor Cyan
    Write-Host "===         Author: Kyi Wong             ===" -ForegroundColor Cyan
    
    Write-Host "Current Global Path: $CurrentPF" -ForegroundColor Yellow
    
    Write-Host "`n1. Update Global Path"
    Write-Host "2. Restore to Default (C: Drive)"
    Write-Host "3. Exit"
    
    $choice = Read-Host "`nSelect an option"
    switch ($choice) {
        '1' {
            $newBase = Read-Host "Enter NEW base path (e.g., D:\MyPrograms)"
            if ([string]::IsNullOrWhiteSpace($newBase) -or $newBase.StartsWith("C:", [System.StringComparison]::OrdinalIgnoreCase)) {
                Write-Host "Invalid input or C: drive prohibited." -ForegroundColor Red; Pause; continue
            }

            if ($newBase.EndsWith("Program Files", [System.StringComparison]::OrdinalIgnoreCase)) {
                $PF64 = $newBase
                $PF86 = $newBase -replace "Program Files", "Program Files (x86)"
            } else {
                $PF64 = Join-Path $newBase "Program Files"
                $PF86 = Join-Path $newBase "Program Files (x86)"
            }
            
            $ShadowRoot = Join-Path (Split-Path $PF64 -Parent) "AppData\Local"
            $LocalShadow = "$env:LOCALAPPDATA\Shadow"
            
            try {
                foreach ($path in @($PF64, $PF86, $ShadowRoot)) {
                    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory -Force | Out-Null }
                }
                if (!(Test-Path $LocalShadow)) { cmd /c mklink /j "$LocalShadow" "$ShadowRoot" }
                
                Set-ItemProperty -Path $RegPath -Name "ProgramFilesDir" -Value $PF64
                Set-ItemProperty -Path $RegPath -Name "ProgramFilesDir (x86)" -Value $PF86
                Set-ItemProperty -Path $RegPath -Name "ProgramW6432Dir" -Value $PF64
                
                Write-Host "`n[SUCCESS] Path has been updated!" -ForegroundColor Green
                Write-Host "------------------------------------------------------------" -ForegroundColor White
                Write-Host "1. System now installs software to your target path." -ForegroundColor White
                Write-Host "2. Shadow folder created at: $LocalShadow" -ForegroundColor White
                Write-Host "   (If an installer forces AppData usage, choose this folder)" -ForegroundColor Cyan
                Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
                Write-Host "READ CAREFULLY: Please ensure you have noted these changes." -ForegroundColor Red
            } catch { Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red }
            Pause
        }
        '2' {
            Set-ItemProperty -Path $RegPath -Name "ProgramFilesDir" -Value $DefaultPF
            Set-ItemProperty -Path $RegPath -Name "ProgramFilesDir (x86)" -Value $DefaultPF86
            Set-ItemProperty -Path $RegPath -Name "ProgramW6432Dir" -Value $DefaultPF
            
            Write-Host "`n[RESTORED] System default settings applied." -ForegroundColor Green
            Write-Host "------------------------------------------------------------" -ForegroundColor White
            Write-Host "1. Program installation path reverted to C: drive." -ForegroundColor White
            Write-Host "2. IMPORTANT: The 'Shadow' folder and its link remain" -ForegroundColor White
            Write-Host "   untouched to prevent application crashes/data loss." -ForegroundColor Cyan
            Write-Host "------------------------------------------------------------" -ForegroundColor Yellow
            Write-Host "READ CAREFULLY: Default settings restored. Press Enter to exit." -ForegroundColor Red
            Pause
        }
        '3' { $running = $false }
    }
}
