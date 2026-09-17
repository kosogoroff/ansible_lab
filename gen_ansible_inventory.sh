#!/bin/bash
# gen_inventory.sh — генерирует инвентарь из vagrant ssh-config

PROVIDER="${VAGRANT_DEFAULT_PROVIDER:-virtualbox}"
HOSTS_FILE="./staging/hosts"

# Получаем SSH-конфиг для всех машин
SSH_CONFIG=$(vagrant ssh-config nginx 2>/dev/null)

# Парсим нужные поля
HOST=$(echo "$SSH_CONFIG" | grep -i 'HostName' | awk '{print $2}')
PORT=$(echo "$SSH_CONFIG" | grep -i 'Port' | awk '{print $2}')
KEY=$(echo "$SSH_CONFIG" | grep -i 'IdentityFile' | awk '{print $2}' | sed 's/"//g')

cat > "$HOSTS_FILE" <<EOF
[web]
nginx ansible_host=${HOST} ansible_port=${PORT} ansible_user=vagrant ansible_private_key_file=${KEY}
EOF

echo "Inventory generated:"
cat "$HOSTS_FILE"
