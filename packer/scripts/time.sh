#!/usr/bin/env bash
set -e

# Configure host to use timezone
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html

echo "### Setting timezone to $TIMEZONE ###"
sudo yum install -y chrony
sudo tee /etc/sysconfig/clock << EOF > /dev/null
ZONE="$TIMEZONE"
UTC=true
EOF

sudo tee /etc/chrony.conf << EOF > /dev/null
server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4
EOF

echo "### Linking timezone file /usr/share/zoneinfo/$TIMEZONE ###"
sudo ln -sf /usr/share/zoneinfo/"$TIMEZONE" /etc/localtime

sudo systemctl enable chronyd.service
sudo systemctl start chronyd.service

echo "### Checking chrony config ###"
sudo chronyc tracking
