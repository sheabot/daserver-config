#!/bin/sh

if [ "$(id -u)" != 0 ]; then
    echo "error: must be run as root"
    exit 1
fi

ROOT="${1:-/mnt/raid/docker}"

echo "Deploying to: $ROOT"

# avahi
install -o root -g root -m 0755 -d "$ROOT/avahi"
install -o root -g root -m 0644 avahi/docker-compose.yml "$ROOT/avahi"
install -o root -g root -m 0644 avahi/avahi-daemon.conf "$ROOT/avahi"
install -o root -g root -m 0755 -d "$ROOT/avahi/services"
install -o root -g root -m 0644 avahi/services/*.service "$ROOT/avahi/services"

# dasd
install -o root -g root -m 0755 -d "$ROOT/dasd"
install -o root -g root -m 0644 dasd/docker-compose.yml "$ROOT/dasd"
install -o dasd -g dasd -m 0700 -d "$ROOT/dasd/ssh"
PRIV_KEY_PATH="$ROOT/dasd/ssh/id_rsa"
if [ ! -f "$PRIV_KEY_PATH" ]; then
    ssh-keygen -t rsa -f "$PRIV_KEY_PATH" -C "dasd@daserver"
    chown dasd:dasd "$ROOT/dasd/ssh/"id_rsa*
fi

# minidlna
install -o root -g root -m 0755 -d "$ROOT/minidlna"
install -o root -g root -m 0644 minidlna/docker-compose.yml "$ROOT/minidlna"
install -o root -g root -m 0644 minidlna/minidlna.conf "$ROOT/minidlna"

# samba
install -o root -g root -m 0755 -d "$ROOT/samba"
install -o root -g root -m 0644 samba/docker-compose.yml "$ROOT/samba"
install -o root -g root -m 0644 samba/smb.conf "$ROOT/samba"
install -o root -g root -m 0755 -d "$ROOT/samba/private"
#install -o root -g root -m 0600 samba/private/*.tdb "$ROOT/samba/private"

# sshfs
install -o root -g root -m 0755 -d "$ROOT/sshfs"
install -o root -g root -m 0644 sshfs/docker-compose.yml "$ROOT/sshfs"
install -o root -g root -m 0644 sshfs/sshfs.env "$ROOT/sshfs"
install -o root -g root -m 0700 -d "$ROOT/sshfs/ssh"
PRIV_KEY_PATH="$ROOT/sshfs/ssh/id_rsa"
if [ ! -f "$PRIV_KEY_PATH" ]; then
    ssh-keygen -t rsa -f "$PRIV_KEY_PATH" -C "sshfs@daserver"
fi
