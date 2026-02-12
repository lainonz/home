#!/bin/bash

# 1. Check Host VPN
IP=$(ip addr show tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)

if [ -n "$IP" ]; then
    CONFIG=$(ps -eo args | grep '[o]penvpn' | grep -oE '[^ ]+\.ovpn' | head -n 1 | xargs basename 2>/dev/null | tr -d '[:space:]')
    
    if [ -n "$CONFIG" ]; then
        echo "[$IP] > $CONFIG"
    else
        echo "$IP"
    fi
    exit 0
fi

# 2. Check Docker/Exegol VPN
# Iterate through running containers to find one with tun0
CONTAINERS=$(docker ps -q 2>/dev/null)

if [ -n "$CONTAINERS" ]; then
    for container in $CONTAINERS; do
        # Check for tun0 IP in container
        DOCKER_IP=$(docker exec "$container" ip addr show tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
        
        if [ -n "$DOCKER_IP" ]; then
            # Found a container with tun0
            # Try to get config name inside container
            DOCKER_CONFIG=$(docker exec "$container" ps -eo args 2>/dev/null | grep '[o]penvpn' | grep -oE '[^ ]+\.ovpn' | head -n 1 | xargs basename 2>/dev/null | tr -d '[:space:]')
            
            if [ -n "$DOCKER_CONFIG" ]; then
                echo "[$DOCKER_IP] > $DOCKER_CONFIG (Exegol)"
            else
                echo "[$DOCKER_IP] (Docker)"
            fi
            exit 0
        fi
    done
fi

echo "No Lab Connected"
