#!/usr/bin/env bash
echo "### Performing final clean-up tasks ###"
sudo stop ecs
sudo docker system prune -f -a
sudo systemctl disable docker.service
sudo systemctl stop docker.service
sudo rm -rf /var/log/docker /var/log/ecs/*