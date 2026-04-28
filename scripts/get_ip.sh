#!/bin/bash

VM_IP="192.168.56.10"
INVENTORY_FILE="ansible/inventory.ini"

echo "=== Génération de l'inventaire Ansible ==="

cat > "$INVENTORY_FILE" <<EOF
[k3s]
k3s-node ansible_host=${VM_IP} ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/k3s-node/virtualbox/private_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

echo "Inventaire généré :"
cat "$INVENTORY_FILE"