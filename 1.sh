#!/bin/bash
# --------------------------------------------------------------------
# Samsoft MARIOOS 1.0 CORE OS X Branding Wizard
# --------------------------------------------------------------------
# This script rebrands your macOS shell environment to look/feel like
# Samsoft MARIOOS OS X 1.0 without touching SIP-protected files.
# --------------------------------------------------------------------

TARGET_NAME="Samsoft MARIOOS"
TARGET_VERSION="1.0 CORE"
TARGET_BUILD="OS X"

ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.bak.$(date +%s)"

echo "[INFO] Backing up your shell config → $BACKUP"
cp "$ZSHRC" "$BACKUP" 2>/dev/null || true

# --- sw_vers alias ---
echo "[INFO] Branding sw_vers output..."
cat <<EOF >> "$ZSHRC"
alias sw_vers='echo "ProductName:    $TARGET_NAME
ProductVersion: $TARGET_VERSION
BuildVersion:   $TARGET_BUILD"'
EOF

# --- Custom prompt ---
echo "[INFO] Adding Samsoft prompt..."
cat <<'EOF' >> "$ZSHRC"

# Samsoft MARIOOS PS1
export PS1="[\u@\h] \W (Samsoft MARIOOS 1.0) % "
EOF

# --- MOTD / login banner ---
MOTD="/etc/motd"
if [ -w "$MOTD" ]; then
  echo "[INFO] Updating login banner (/etc/motd)"
  echo "Welcome to $TARGET_NAME $TARGET_VERSION ($TARGET_BUILD)" | sudo tee "$MOTD"
else
  echo "[WARN] Could not write /etc/motd (SIP may block). Skipping."
fi

# --- Hostname spoof ---
echo "[INFO] Setting system name → $TARGET_NAME"
sudo scutil --set HostName "$TARGET_NAME"
sudo scutil --set ComputerName "$TARGET_NAME"
sudo scutil --set LocalHostName "$TARGET_NAME"

echo "[SUCCESS] Samsoft MARIOOS branding applied!"
echo "Run: source ~/.zshrc OR restart Terminal"
