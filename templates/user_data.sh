#!/bin/bash
set -euo pipefail

# Non-interactive apt
export DEBIAN_FRONTEND=noninteractive

# Refresh package lists
apt-get update -y

# Install nginx + prerequisites that the AWS DRS replication agent needs to
# build its kernel module (DKMS-style compile) on Ubuntu:
#   - build-essential: gcc/make
#   - linux-headers-$(uname -r): kernel headers matching the running kernel
#   - dkms: helps rebuild the module across kernel updates
#   - python3, wget, tar, curl: used by the DRS installer
apt-get install -y \
  nginx \
  build-essential \
  dkms \
  "linux-headers-$(uname -r)" \
  python3 \
  wget \
  curl \
  tar

# Create simple HTML test page (Ubuntu nginx default web root)
cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${project_name} - Test Page</title>
  <style>
    body { font-family: system-ui, sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; background: #f0f4f8; }
    .card { background: #fff; padding: 2rem 3rem; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center; }
    h1 { color: #1a202c; }
    p { color: #4a5568; }
  </style>
</head>
<body>
  <div class="card">
    <h1>${project_name}</h1>
    <p>Nginx is running successfully on this Ubuntu 24.04 EC2 instance.</p>
  </div>
</body>
</html>
HTML

# Enable and start nginx
systemctl enable nginx
systemctl restart nginx
