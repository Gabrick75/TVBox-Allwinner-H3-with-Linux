#!/bin/bash

set -e

echo "============================================="
echo "ATUALIZAÇÃO DEBIAN 10 (Buster) -> DEBIAN 11 (Bullseye)"
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
echo " - Não recomendado para ambientes críticos sem UPS"
echo ""
read -p "Deseja usar eatmydata? (s/N): " USE_EATMYDATA

# Define variável de execução
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

# 1. Bloquear Kernel
echo "--- Bloqueando atualização do Kernel e DTB ---"
apt-mark hold linux-image-current-sunxi linux-dtb-current-sunxi

# 2. Ajustar timezone
echo "--- Ajustando Fuso Horário para America/Sao_Paulo ---"
timedatectl set-timezone America/Sao_Paulo
echo "Data atual: $(date)"

# 3. Configurar Buster (Archive)
echo "--- Configurando repositórios Buster (Archive) ---"
cat > /etc/apt/sources.list <<EOF
deb http://archive.debian.org/debian buster main contrib non-free
deb http://archive.debian.org/debian buster-updates main contrib non-free
deb http://archive.debian.org/debian buster-backports main contrib non-free
deb http://archive.debian.org/debian-security buster/updates main contrib non-free
EOF

# 4. Instalar eatmydata se escolhido
if [ "$INSTALL_EATMYDATA" = true ]; then
    echo "--- Instalando eatmydata ---"
    apt -o Acquire::Check-Valid-Until=false update
    apt -o Acquire::Check-Valid-Until=false install eatmydata -y
fi

echo "--- Atualizando sistema atual (Buster) ---"
$APT_CMD -o Acquire::Check-Valid-Until=false clean
$APT_CMD -o Acquire::Check-Valid-Until=false update
DEBIAN_FRONTEND=noninteractive $APT_CMD upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# 5. Alterar para Bullseye
echo "--- Alterando repositórios para Bullseye ---"
cat > /etc/apt/sources.list <<EOF
deb http://archive.debian.org/debian bullseye main contrib non-free
deb http://archive.debian.org/debian bullseye-updates main contrib non-free
deb http://archive.debian.org/debian bullseye-backports main contrib non-free
deb http://archive.debian.org/debian-security bullseye-security main contrib non-free
EOF

# Armbian list
echo "--- Atualizando Armbian list ---"
if [ -f /etc/apt/sources.list.d/armbian.list ]; then
    sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/armbian.list
else
    echo "deb http://apt.armbian.com bullseye main" > /etc/apt/sources.list.d/armbian.list
fi

# 6. Upgrade final para Debian 11
echo "--- Iniciando atualização para Debian 11 ---"
$APT_CMD clean
$APT_CMD update

DEBIAN_FRONTEND=noninteractive $APT_CMD upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
DEBIAN_FRONTEND=noninteractive $APT_CMD dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

echo ""
echo "============================================="
echo "ATUALIZAÇÃO CONCLUÍDA"
echo "Reinicie o sistema com: reboot"
echo "Após reiniciar, execute o script da Parte 2."
echo "============================================="
