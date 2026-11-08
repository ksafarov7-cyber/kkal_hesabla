@echo off
chcp 65001 >nul
cd /d "%~dp0"
where python >nul 2>nul
if errorlevel 1 (
  echo Python tapilmadi. https://www.python.org/downloads/ den quraşdırın.
  pause
  exit /b 1
)
echo.
echo   Kalori AI: http://localhost:8123
echo   Dayandirmaq ucun bu pəncərəni bağlayın.
echo.
start "" "http://localhost:8123/"
python -m http.server 8123 --bind 127.0.0.1
pause
