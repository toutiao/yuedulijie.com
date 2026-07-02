#!/usr/bin/env bash
set -euo pipefail

echo "◆ HN environment setup"

# ── Check Docker ────────────────────────────
command -v docker >/dev/null || { echo "❌ Docker required"; exit 1; }
echo "◆ Docker $(docker --version 2>&1 | head -1)"

# ── Build renderer image ────────────────────
echo "◆ Building playwright-renderer image..."
docker compose build renderer 2>&1 | tail -3

# ── Start renderer service ──────────────────
echo "◆ Starting renderer..."
docker compose up -d renderer 2>&1

# ── Wait for readiness ─────────────────────
echo "◆ Waiting for renderer..."
for i in $(seq 1 10); do
  if curl -sf http://localhost:3000/health >/dev/null 2>&1; then
    echo "✅ Renderer ready at http://localhost:3000"
    exit 0
  fi
  sleep 2
done
echo "❌ Renderer failed to start"
exit 1
