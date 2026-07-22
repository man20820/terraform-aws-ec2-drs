#!/bin/bash
set -euo pipefail

# Install nginx
dnf install -y nginx

# Create simple HTML test page
cat > /usr/share/nginx/html/index.html <<'HTML'
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
    <p>Nginx is running successfully on this EC2 instance.</p>
    <p><small>Served via NLB with TLS termination on port 9001</small></p>
  </div>
</body>
</html>
HTML

# Enable and start nginx
systemctl enable nginx
systemctl start nginx
