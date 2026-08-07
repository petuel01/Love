#!/bin/bash

set -e

APP_DIR="/root/tofaith-site"

echo "======================================"
echo " Deploying ToFaith website"
echo "======================================"

cd "$APP_DIR"

echo "[1/4] Pulling latest GitHub changes..."
git pull origin main

echo "[2/4] Building Docker image..."
docker compose build --no-cache

echo "[3/4] Starting container..."
docker compose up -d

echo "[4/4] Checking container..."
docker compose ps

if docker inspect -f '{{.State.Running}}' tofaith 2>/dev/null | grep -q true; then
    echo ""
    echo "======================================"
    echo " ToFaith deployment successful!"
    echo "======================================"
else
    echo ""
    echo "ERROR: ToFaith container failed to start."
    docker compose logs --tail=50
    exit 1
fi