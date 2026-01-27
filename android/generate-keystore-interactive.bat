@echo off
chcp 65001 >nul
echo ========================================
echo Generador de Keystore para Alcala App
echo ========================================
echo.
echo Este script generara un nuevo keystore para tu app.
echo IMPORTANTE: Guarda bien las contraseñas que uses!
echo.
echo.

set /p STORE_PASS="Ingresa la contraseña del almacén (mínimo 6 caracteres): "
set /p KEY_PASS="Ingresa la contraseña de la clave (puede ser la misma): "
if "%KEY_PASS%"=="" set KEY_PASS=%STORE_PASS%

set /p ALIAS_NAME="Ingresa el alias de la clave (ej: alcala): "
if "%ALIAS_NAME%"=="" set ALIAS_NAME=alcala

set /p KEYSTORE_NAME="Ingresa el nombre del archivo keystore (ej: alcala-keystore.jks): "
if "%KEYSTORE_NAME%"=="" set KEYSTORE_NAME=alcala-keystore.jks

echo.
echo ========================================
echo Generando keystore...
echo ========================================
echo Alias: %ALIAS_NAME%
echo Archivo: %KEYSTORE_NAME%
echo.

cd app

keytool -genkey -v ^
  -keystore %KEYSTORE_NAME% ^
  -keyalg RSA ^
  -keysize 2048 ^
  -validity 10000 ^
  -alias %ALIAS_NAME% ^
  -storepass %STORE_PASS% ^
  -keypass %KEY_PASS% ^
  -dname "CN=Alcala App, OU=Development, O=Alcala, L=Madrid, ST=Madrid, C=ES"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo ¡Keystore generado exitosamente!
    echo ========================================
    echo Ubicacion: android/app/%KEYSTORE_NAME%
    echo Alias: %ALIAS_NAME%
    echo.
    echo IMPORTANTE: Guarda estos datos en un lugar seguro:
    echo   - Archivo: %KEYSTORE_NAME%
    echo   - Alias: %ALIAS_NAME%
    echo   - Contraseña almacén: %STORE_PASS%
    echo   - Contraseña clave: %KEY_PASS%
    echo.
    echo Ahora actualizaremos el archivo key.properties...
    echo.
    
    cd ..
    echo storePassword=%STORE_PASS% > key.properties
    echo keyPassword=%KEY_PASS% >> key.properties
    echo keyAlias=%ALIAS_NAME% >> key.properties
    echo storeFile=app/%KEYSTORE_NAME% >> key.properties
    
    echo ¡key.properties actualizado!
    echo.
) else (
    echo.
    echo ERROR: No se pudo generar el keystore.
    echo.
)

cd ..
pause
