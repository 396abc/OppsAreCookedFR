@echo off
title Sigma Offline Password Simulator
setlocal enabledelayedexpansion
chcp 65001 >nul

:: --- CONFIGURATION ---
set "usb_drive=E:"  :: Change if your USB drive letter is different
set "state_file=%usb_drive%\sigma_state.txt"
set "session_speed=50"  :: milliseconds per combo
set "letters=abcdefghijklmnopqrstuvwxyz"
set "numbers=0123456789"

:: --- LOAD LAST COMBO INDEX ---
if exist "%state_file%" (
    set /p last_index=<"%state_file%"
) else (
    set last_index=0
)

:: --- MOCK UAC PROMPT FUNCTION ---
:mockUAC
cls


echo ╭━━━┳╮╱╭┳━━━┳━━━━┳━━━┳━━━┳━━━━╮╭━━━┳━━━╮╭━━━━┳╮╱╭┳━━┳━━━╮╭━━━┳━━━┳━━━╮╭━╮╭━┳━━━╮
echo ┃╭━╮┃┃╱┃┃╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃╭╮╭╮┃╰╮╭╮┃╭━╮┃┃╭╮╭╮┃┃╱┃┣┫┣┫╭━╮┃┃╭━━┫╭━╮┃╭━╮┃┃┃╰╯┃┃╭━━╯
echo ┃┃╱╰┫╰━╯┃┃╱┃┣╯┃┃╰┫┃╱╰┫╰━╯┣╯┃┃╰╯╱┃┃┃┃┃╱┃┃╰╯┃┃╰┫╰━╯┃┃┃┃╰━━╮┃╰━━┫┃╱┃┃╰━╯┃┃╭╮╭╮┃╰━━╮
echo ┃┃╱╭┫╭━╮┃╰━╯┃╱┃┃╱┃┃╭━┫╭━━╯╱┃┃╱╱╱┃┃┃┃┃╱┃┃╱╱┃┃╱┃╭━╮┃┃┃╰━━╮┃┃╭━━┫┃╱┃┃╭╮╭╯┃┃┃┃┃┃╭━━╯
echo ┃╰━╯┃┃╱┃┃╭━╮┃╱┃┃╱┃╰┻━┃┃╱╱╱╱┃┃╱╱╭╯╰╯┃╰━╯┃╱╱┃┃╱┃┃╱┃┣┫┣┫╰━╯┃┃┃╱╱┃╰━╯┃┃┃╰╮┃┃┃┃┃┃╰━━╮
echo ╰━━━┻╯╱╰┻╯╱╰╯╱╰╯╱╰━━━┻╯╱╱╱╱╰╯╱╱╰━━━┻━━━╯╱╱╰╯╱╰╯╱╰┻━━┻━━━╯╰╯╱╱╰━━━┻╯╰━╯╰╯╰╯╰┻━━━╯

echo User: %user%
echo Password: %pass%
echo ========================================
timeout /t 1 >nul
goto :eof

:: --- MENU ---
:start
cls
echo ==============================
echo      SIGMA PASSWORD SIM
echo ==============================
echo 1. Start Sigma Simulation
echo 2. Exit
echo ==============================
set /p choice=">> "

if "%choice%"=="1" goto simulation
if "%choice%"=="2" exit
goto start

:: --- SIMULATION ---
:simulation
echo.
set /p user="Enter mock target user: "
echo.
set /a count=%last_index%
for %%l1 in (%letters%) do (
  for %%l2 in (%letters%) do (
    for %%l3 in (%letters%) do (
      for %%n1 in (%numbers%) do (
        for %%n2 in (%numbers%) do (
          for %%l4 in (%letters%) do (
            set /a count+=1
            :: skip if already tried
            if !count! LEQ %last_index% (
              rem already done
            ) else (
              set "pass=%%l1%%l2%%l3%%n1%%n2%%l4"
              echo [ATTEMPT !count!] !pass!
              call :mockUAC
              timeout /t %session_speed% >nul
              :: save progress to USB
              echo !count! > "%state_file%"
            )
          )
        )
      )
    )
  )
)
echo Sigma simulation complete!
pause >nul
goto start
