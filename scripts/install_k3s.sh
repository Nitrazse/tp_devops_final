#!/bin/bash
set -e
echo "=== Installation des dépendances ==="
apt-get update -y
apt-get install -y curl

echo "=== Installation de k3s ==="
if command -v k3s &> /dev/null; then
  echo "k3s est déjà installé, on passe."
  exit 0
fi
curl -sfL https://get.k3s.io | sh -
echo "=== Attente que k3s soit prêt ==="
sleep 15
k3s kubectl get nodes
echo "=== k3s installé avec succès ==="

echo "=== Installation de Node Exporter ==="
useradd --no-create-home --shell /bin/false node_exporter || true
curl -sSL https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz -o /tmp/node_exporter.tar.gz
tar xzf /tmp/node_exporter.tar.gz -C /tmp
cp /tmp/node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
chown node_exporter:node_exporter /usr/local/bin/node_exporter
cat > /etc/systemd/system/node_exporter.service << 'EOF'
[Unit]
Description=Node Exporter
After=network.target
[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now node_exporter
echo "=== Node Exporter installé ==="
