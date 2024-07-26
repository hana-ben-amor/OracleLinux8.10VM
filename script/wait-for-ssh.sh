#!/bin/bash
# Script to wait for SSH to be available and start the SSH service

# Wait for SSH to be available
while ! nc -z localhost 22; do
  sleep 1
done

# Ensure SSH service is started
sudo systemctl start ssh
