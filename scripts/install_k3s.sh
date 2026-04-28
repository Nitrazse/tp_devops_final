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