# P4 Development Environment Setup Guide

## Overview

This guide helps you set up a containerized P4 (Programming Protocol-independent Packet Processors) development environment using Docker. The container includes all necessary tools and dependencies for P4 programming, including BMv2 (behavioral model version 2), P4C compiler, and other related utilities.

## Prerequisites

### Install Docker and Docker Compose

Before starting, you need to install Docker and Docker Compose on your system.

#### Quick Installation Steps

**For Ubuntu/Debian:**
```bash
# Update package index
sudo apt-get update

# Install Docker
sudo apt-get install -y docker.io

# Install Docker Compose
sudo apt-get install -y docker-compose-plugin

# Add your user to the docker group (optional, to run docker without sudo)
sudo usermod -aG docker $USER
# Note: Log out and log back in for this to take effect
```

**For other operating systems:**
- Docker Installation: Visit [Docker Official Documentation](https://docs.docker.com/engine/install/)
- Docker Compose Installation: Visit [Docker Compose Official Documentation](https://docs.docker.com/compose/install/)

#### Verify Installation

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version
```

## Configuration

### Step 1: Modify the docker-compose.yaml

Edit the `docker-compose.yaml` file in the p4 directory and customize the following parameters:

- **`your_name`**: Replace with your username (used for container name and directory mapping)
- **`your_user_id`**: Replace with your user ID (UID)
   - Find your user ID by running:
   ```bash
   $ id
   ```
   - Use the `uid` value from the output (e.g., if output shows `uid=1000`, use `1000`)
- **`your_group_id`**: Replace with your primary group ID (GID)
   - Use the `gid` value from the `id` command output (e.g., if output shows `gid=1000`, use `1000`)
- **`your_group`**: Replace with your primary group name
   - Use the group name shown in parentheses after `gid` in the `id` command output
   - For example, if output shows `gid=1000(username)`, use `username`
   - Or you can also run `groups` command to see your group names
- **`your_password`**: Replace with your desired SSH password for accessing the container
- **`your_port`**: Replace with your desired SSH port number (e.g., `2222`, `2223`, etc.)
   - Make sure the port is not already in use on your host system

**Example Configuration:**

If your `id` command shows:
```
uid=1000(alice) gid=1000(alice) groups=1000(alice),27(sudo),999(docker)
```

Then your `docker-compose.yaml` should look like:
```yaml
services:
  ubuntu-alice:
    image: "jinxdh/p4-ubuntu:24.04"
    restart: unless-stopped
    privileged: true
    ports:
      - "2222:22"
    volumes:
      - /home/alice:/home/alice
      - /data/alice:/data/alice
    environment:
      - "USER_NAME=alice"
      - "USER_UID=1000"
      - "USER_GID=1000"
      - "USER_GROUP=alice"
      - "SSH_PASSWORD=mySecurePassword123"
    command: ["/bin/bash", "-c", "/usr/local/bin/adduser.sh && /usr/sbin/sshd -D"]
```

## Docker Operations

### Start the Container

Navigate to the directory containing `docker-compose.yaml` and run:

```bash
cd docker/p4
sudo docker compose up -d
```

The `-d` flag runs the container in detached mode (in the background).

### Check Container Status

```bash
sudo docker compose ps
```

### Stop the Container

When you need to stop the container:

```bash
sudo docker compose down
```

### Restart the Container

If you need to restart your container (e.g., after configuration changes):

```bash
sudo docker compose restart
```

## Accessing the Container

### Method 1: SSH Access (Recommended)

Once the container is running, you can SSH into it using the port you configured:

```bash
ssh your_name@localhost -p your_port
```

**Example:**
```bash
# If your username is 'alice' and port is '2222'
ssh alice@localhost -p 2222
```

When prompted, enter the password you set in the `docker-compose.yaml` file.

**First-time SSH connection:**
If this is your first time connecting, you'll see a message about the host's authenticity. Type `yes` to continue.

### Method 2: Direct Shell Access

Alternatively, you can access the container directly using Docker:

```bash
# Find your container name
sudo docker ps

# Access the container shell
sudo docker exec -it <container_name> /bin/bash
```

**Example:**
```bash
sudo docker exec -it ubuntu-alice /bin/bash
```

## Troubleshooting

### Port Already in Use

If you get a "port already in use" error, either:
1. Choose a different port in your `docker-compose.yaml`, or
2. Stop the service using that port

### Container Won't Start

Check the container logs:
```bash
sudo docker compose logs
```

### Permission Issues

If you encounter permission issues with mounted volumes, ensure:
1. The directories specified in `volumes` exist on your host system
2. Your `USER_UID` matches your actual user ID
3. You have appropriate permissions for the mounted directories

## Next Steps

After successfully accessing your container, you're ready to start working with P4!

### Explore P4 Examples

This repository includes hands-on P4 examples specifically designed for the TUNA architecture. We recommend starting with these practical examples:

1. **[Ping (Basic Forwarding)](../tuna/app/ping)** - Your first P4 program for basic packet forwarding
2. **[L3 Forwarding](../tuna/app/l3_forward)** - IPv4 layer 3 routing between different network segments
3. **[Calculator](../tuna/app/calculator)** - Custom protocol with arithmetic and logic operations
4. **[GRE Tunnel](../tuna/app/tunnel)** - Packet encapsulation and tunneling
5. **[Firewall](../tuna/app/firewall)** - Stateful packet filtering

**See the [Root README](../README.md) for a complete guide to all examples with detailed descriptions.**

### Development Tools

Inside your container, you'll have access to:
- **p4c-apollo-tuna**: The P4 compiler for TUNA architecture
- **tunic**: TUNA NIC driver and control interface
- **make**: Build automation for compiling and testing examples
- Test scripts and utilities for verifying your P4 programs

### Learning Resources

For general P4 programming concepts and language documentation:
- [P4 Official Website](https://p4.org/) - Language specifications and community resources
- [P4 Tutorials](https://github.com/p4lang/tutorials) - Comprehensive P4 tutorials for BMv2 architecture
- [P4 Language Specification](https://p4.org/specs/) - Official P4_16 language reference
