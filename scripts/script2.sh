#!/bin/bash

set -e

echo "============================================="
echo "ATUALIZAÇÃO DEBIAN 11 (Bullseye) -> DEBIAN 12 (Bookworm)"
echo "============================================="
echo "by gabrick75"
echo ""
echo "Você deseja utilizar o eatmydata para acelerar a atualização?"
echo ""
echo "Benefícios:"
echo " - Processo significativamente mais rápido"
echo " - Ideal para cartões SD lentos"
echo ""
echo "Possíveis riscos:"
echo " - Menor proteção contra corrupção se houver queda de energia"
echo ""
read -p "Deseja usar eatmydata? (s/N): " USE_EATMYDATA

if [[ "$USE_EATMYDATA" =~ ^[Ss]$ ]]; then
    echo ">>> eatmydata será utilizado."
    APT_CMD="eatmydata apt"
    INSTALL_EATMYDATA=true
else
    echo ">>> Atualização seguirá sem eatmydata."
    APT_CMD="apt"
    INSTALL_EATMYDATA=false
fi

echo ""
echo "=== INICIANDO PROCESSO ==="

# Verificação de versão
if ! grep -q "11" /etc/debian_version; then
    echo "ATENÇÃO: Parece que o sistema ainda não está no Debian 11."
    echo "Versão atual: $(cat /etc/debian_version)"
    read -p "Deseja continuar mesmo assim? (s/N): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

# Instalar eatmydata se necessário
if [ "$INSTALL_EATMYDATA" = true ]; then
    echo "--- Instalando eatmydata ---"
    apt update
    apt install eatmydata -y
fi

# 1. Alterar repositórios para Bookworm
echo "--- Configurando repositórios Bookworm (Incluindo non-free-firmware) ---"

cat > /etc/apt/sources.list <<EOF
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-backports main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
EOF

# 2. Atualizar Armbian list
echo "--- Atualizando Armbian list para Bookworm ---"
if [ -f /etc/apt/sources.list.d/armbian.list ]; then
    sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/armbian.list
else
    echo "deb http://apt.armbian.com bookworm main" > /etc/apt/sources.list.d/armbian.list
fi

# 3. Atualização do Sistema
echo "--- Atualizando lista de pacotes ---"
$APT_CMD clean
$APT_CMD update

echo "--- Realizando upgrade para Debian 12 ---"
DEBIAN_FRONTEND=noninteractive $APT_CMD upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
DEBIAN_FRONTEND=noninteractive $APT_CMD dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# 4. Limpeza final
echo "--- Removendo pacotes desnecessários ---"
$APT_CMD autoremove -y

echo ""
echo "============================================="
echo "PROCESSO FINALIZADO"
echo "Versão final do sistema:"
cat /etc/debian_version
echo "Reinicie o sistema para concluir: reboot"
echo "============================================="
