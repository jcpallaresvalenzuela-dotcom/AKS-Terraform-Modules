#!/bin/bash

echo "=== Creando Service Principal simple para AKS ==="

# Crear Service Principal con permisos básicos
echo "Creando Service Principal..."
SP_OUTPUT=$(az ad sp create-for-rbac \
    --name "aks-stop-and-start" \
    --role "Contributor" \
    --scopes "/subscriptions/$(az account show --query id -o tsv)" \
    --sdk-auth)

echo "✅ Service Principal creado exitosamente"
echo ""
echo "=== CREDENCIALES PARA GITHUB ACTIONS ==="
echo ""
echo "AZURE_CREDENTIALS:"
echo "$SP_OUTPUT"
echo ""
echo "⚠️  IMPORTANTE: Copia todo el contenido anterior en el secret AZURE_CREDENTIALS"
echo "   Esta información solo se muestra una vez"
echo ""
echo "✅ Service Principal listo para usar!"
