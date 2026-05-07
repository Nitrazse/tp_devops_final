# TP DevOps Final - Lacets Connectés API

## Équipe
- MOUKOUMI ELYSEE SHALOM
- KOPHY AURIANE-ESTHER
- KEBE ABDOUL KADER JUNIOR

## Présentation

Ce projet met en place l'infrastructure de déploiement d'une API REST pour une startup de lacets connectés. L'API est développée en Node.js avec une base MariaDB, déployée sur un cluster k3s, avec un pipeline CI/CD et du monitoring.

Deux VMs Debian sont utilisées :
- k3s-node (192.168.56.10) : cluster k3s avec l'API et la base de données, Node Exporter
- monitoring (192.168.56.11) : Prometheus, Grafana, Node Exporter

## Partie 1 - Infrastructure

Prérequis : VirtualBox et Vagrant.

Lancer les VMs :

    vagrant up

Deux VMs Debian Bookworm avec 2Go de RAM et 2 CPUs. Le provisioning installe k3s et Node Exporter sur k3s-node, Prometheus/Grafana/Node Exporter sur monitoring.

Connexion SSH :

    vagrant ssh k3s-node
    vagrant ssh monitoring

## Partie 2 - Conteneurisation

Image Docker basée sur Node.js 18 Alpine (~152MB). Seules les dépendances de production sont installées.

    docker build -t nitrase/laces-api:latest -f Dockerfile.txt .
    docker push nitrase/laces-api:latest

Modifications apportées : Dockerfile Alpine, npm install --production.

## Partie 3 - Déploiement Kubernetes

Manifestes dans kubernetes/mysql.yaml et kubernetes/api.yaml.

    sudo kubectl apply -f kubernetes/mysql.yaml
    sudo kubectl apply -f kubernetes/api.yaml

L'API est accessible uniquement dans le cluster (ClusterIP). Le HPA scale de 1 a 3 pods selon CPU/RAM (seuil 50%). MariaDB utilise un PVC de 1Gi. Credentials : root/root, base lacesdb.

## Partie 4 - CI/CD

Pipeline GitHub Actions (.github/workflows/cicd.yml) declenche a chaque push sur main. Il build l'image Docker, la push sur Docker Hub, puis deploie sur k3s via SSH.

Le runner self-hosted tourne sur une machine Linux et se connecte a la VM k3s-node.

Secrets GitHub : DOCKER_USERNAME et DOCKER_PASSWORD.

## Partie 5 - Monitoring

Prometheus (port 9090) collecte les metriques des deux VMs via Node Exporter (port 9100). Grafana (port 3000) affiche le dashboard Node Exporter Full (ID 1860).

Prometheus scrape localhost:9100 (monitoring) et 192.168.56.10:9100 (k3s-node).

Acces Grafana : http://192.168.56.11:3000 (admin/admin)
Acces Prometheus : http://192.168.56.11:9090
