#!/usr/bin/env bash
set -euo pipefail

REPO="Lax/yuedulijie.com"
SLUG="Lax-yuedulijie.com"
RUNNER_DIR="/home/lax/runners/yuedulijie"

echo "◆ Repo:      $REPO"
echo "◆ Runner ID: $SLUG"
echo "◆ Directory: $RUNNER_DIR"

# ── Check gh auth ──────────────────────────────
gh auth status &>/dev/null || { echo "❌ Not logged into gh"; exit 1; }

# ── Ensure runner directory ────────────────────
if [ -d "$RUNNER_DIR" ]; then
    echo "◆ Existing runner found at $RUNNER_DIR"
    if [ -f "$RUNNER_DIR/.runner" ]; then
        echo "◆ Runner already configured. Starting service..."
        systemctl --user daemon-reload
        systemctl --user enable actions.runner.${SLUG}.service
        systemctl --user start actions.runner.${SLUG}.service
        echo "✅ Runner service started (user-level)"
        systemctl --user --no-pager status actions.runner.${SLUG}.service | head -5
        exit 0
    fi
fi

# ── Get registration token ────────────────────
echo "◆ Getting runner registration token..."
TOKEN=$(gh api --method POST repos/$REPO/actions/runners/registration-token --jq '.token')
[ -z "$TOKEN" ] && { echo "❌ Failed to get token"; exit 1; }

# ── Download runner ───────────────────────────
RUNNER_VERSION=$(gh api repos/actions/runner/releases/latest --jq '.tag_name' | sed 's/^v//')
echo "◆ Downloading actions-runner v${RUNNER_VERSION}..."
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"
curl -sSfLO "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
tar xzf "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
rm -f "actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# ── Configure ────────────────────────────────
echo "◆ Configuring runner..."
./config.sh --url "https://github.com/$REPO" --token "$TOKEN" --unattended --name "$SLUG" --labels "self-hosted,linux"

# ── Enable user linger ──────────────────────
loginctl enable-linger $(whoami) 2>/dev/null || true

# ── Proxy config ────────────────────────────
mkdir -p ~/.config/systemd/user/actions.runner.${SLUG}.service.d
cat > ~/.config/systemd/user/actions.runner.${SLUG}.service.d/proxy.conf <<-EOF
[Service]
Environment="http_proxy=http://127.0.0.1:64540"
Environment="https_proxy=http://127.0.0.1:64540"
Environment="HTTP_PROXY=http://127.0.0.1:64540"
Environment="HTTPS_PROXY=http://127.0.0.1:64540"
Environment="no_proxy=localhost,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
Environment="NO_PROXY=localhost,127.0.0.0/8,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
EOF

# ── Configure PATH ──────────────────────────
cat > "$RUNNER_DIR/.path" <<-EOF
/home/lax/.cargo/bin:/home/lax/.local/share/mise/installs/ruby/3.2/bin:/home/lax/.local/share/mise/installs/ruby/3.4.7/bin:/home/lax/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/opt/bin
EOF
cat > "$RUNNER_DIR/.env" <<-EOF
LANG=C.utf8
EOF

# ── Install user service ─────────────────────
echo "◆ Installing systemd user service..."
mkdir -p ~/.config/systemd/user/
cat > ~/.config/systemd/user/actions.runner.${SLUG}.service <<-EOF
[Unit]
Description=GitHub Actions Runner ($REPO)

[Service]
ExecStart=$RUNNER_DIR/bin/runsvc.sh
WorkingDirectory=$RUNNER_DIR
Restart=on-failure
RestartSec=300

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable actions.runner.${SLUG}.service
systemctl --user start actions.runner.${SLUG}.service

echo ""
echo "✅ Runner registered and started:"
echo "   systemctl --user status actions.runner.${SLUG}.service"
echo "   journalctl --user -u actions.runner.${SLUG}.service -f"
echo ""
echo "◆ Repo: https://github.com/$REPO/settings/actions/runners"
