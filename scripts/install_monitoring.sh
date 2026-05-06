#!/bin/bash
set -e

apt-get update -y
apt-get install -y curl
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

echo "=== Installation de Prometheus ==="
useradd --no-create-home --shell /bin/false prometheus || true
mkdir -p /etc/prometheus /var/lib/prometheus
chown prometheus:prometheus /var/lib/prometheus
curl -sSL https://github.com/prometheus/prometheus/releases/download/v2.51.0/prometheus-2.51.0.linux-amd64.tar.gz -o /tmp/prometheus.tar.gz
tar xzf /tmp/prometheus.tar.gz -C /tmp
cp /tmp/prometheus-2.51.0.linux-amd64/{prometheus,promtool} /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
cat > /etc/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'monitoring'
    static_configs:
      - targets: ['localhost:9100']
  - job_name: 'k3s-node'
    static_configs:
      - targets: ['192.168.56.10:9100']
EOF
chown prometheus:prometheus /etc/prometheus/prometheus.yml
cat > /etc/systemd/system/prometheus.service << 'EOF'
[Unit]
Description=Prometheus
After=network.target
[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now prometheus

echo "=== Installation de Grafana ==="
apt-get update
apt-get install -y apt-transport-https software-properties-common gnupg2 curl
curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" > /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y grafana
systemctl enable --now grafana-server

echo "=== Monitoring installé avec succès ==="
