#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update system packages
echo "Updating package lists..."
sudo apt update -y

# Install NGINX
echo "Installing NGINX..."
sudo apt install -y nginx

# Start and enable NGINX
echo "Starting and enabling NGINX..."
sudo systemctl start nginx
sudo systemctl enable nginx

# Create an HTML page with red-colored text
WEBPAGE="/var/www/html/index.html"

echo "Creating a sample webpage..."
sudo bash -c "cat > $WEBPAGE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to NGINX</title>
    <style>
        body { text-align: center; font-family: Arial, sans-serif; }
        h1 { color: red; }
    </style>
</head>
<body>
    <h1>Welcome to My NGINX Web Server</h1>
</body>
</html>
EOF

# Set proper permissions
echo "Setting permissions..."
sudo chmod 644 $WEBPAGE

# Restart NGINX to apply changes
echo "Restarting NGINX..."
sudo systemctl restart nginx

echo "NGINX is installed and serving a webpage with red text!"