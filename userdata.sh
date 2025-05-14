#!/bin/bash

# Update and install required packages
yum update -y
yum install -y httpd git cronie

# Start and enable Apache
systemctl enable httpd
systemctl start httpd

# Start and enable cron service
systemctl enable crond
systemctl start crond

# Define repo and web directory
REPO_URL="https://github.com/samuelcj/website_demo.git"
WEB_DIR="/var/www/html"

# Clone the repo if not already present
if [ ! -d "$WEB_DIR/.git" ]; then
    git clone $REPO_URL $WEB_DIR
else
    cd $WEB_DIR && git pull origin main
fi

# Set correct ownership for Apache
chown -R apache:apache $WEB_DIR

# Add cron job for automatic updates and make it safe safe for Git (important for cron or root context)
echo "* * * * * git config --global --add safe.directory $WEB_DIR && cd $WEB_DIR && /usr/bin/git pull origin main && /usr/sbin/chown -R apache:apache $WEB_DIR" >> /var/spool/cron/root

# The website file templates were gotten from: https://www.themezy.com/free-website-templates/48-free-aerial-responsive-website-template