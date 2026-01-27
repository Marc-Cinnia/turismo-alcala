#!/bin/bash
echo "========================================"
echo "Generador de Keystore para Alcala App"
echo "========================================"
echo ""
echo "Este script generara un nuevo keystore para tu app."
echo "IMPORTANTE: Guarda bien las contraseñas que uses!"
echo ""
cd app
keytool -genkey -v -keystore alcala-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias alcala
echo ""
echo "========================================"
echo "Keystore generado exitosamente!"
echo "Ubicacion: android/app/alcala-keystore.jks"
echo "========================================"
