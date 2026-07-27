#!/bin/bash
# Proxmox Storage Audit Script
# Checks: NFS mount options, ZFS pool health, disk status
# Part of proxmox-audit-tools by Tux Bilişim
# https://tuxbilisim.com

set -e

echo "=========================================="
echo " Proxmox Storage Audit"
echo " $(date)"
echo "=========================================="

# 1. Mounted Storage
echo ""
echo "[1/4] Mounted Storage Paths"
echo "---------------------------"
grep -E "(nfs|ceph|zfs)" /etc/fstab 2>/dev/null || echo "No NFS/Ceph/ZFS entries in fstab"
echo ""
df -hT | grep -E "(nfs|ceph|zfs)" 2>/dev/null || echo "No NFS/Ceph/ZFS mounts active"

# 2. NFS Mount Options
echo ""
echo "[2/4] NFS Mount Check"
echo "----------------------"
nfsstat -m 2>/dev/null || echo "nfsstat not available"
echo ""
mount | grep nfs | while read line; do
  echo "$line" | grep -q "rsize=1048576" && echo "✓ Large rsize found" || echo "✗ rsize not optimized — consider rsize=1048576"
done

# 3. ZFS Pool Status
echo ""
echo "[3/4] ZFS Pool Status"
echo "----------------------"
if command -v zpool &>/dev/null; then
  zpool list 2>/dev/null || echo "No ZFS pools"
  echo ""
  zpool status 2>/dev/null | head -30
else
  echo "ZFS not installed"
fi

# 4. Disk Health
echo ""
echo "[4/4] Disk Health (smartctl)"
echo "-----------------------------"
for disk in $(lsblk -ndo NAME 2>/dev/null | grep -E "^(sd|nvme|vd)" | head -10); do
  if command -v smartctl &>/dev/null; then
    realloc=$(smartctl -A /dev/$disk 2>/dev/null | grep -i realloc | awk '{print $10}')
    [ -n "$realloc" ] && echo "/dev/$disk: Reallocated sectors: $realloc"
  fi
done

echo ""
echo "=========================================="
echo " Storage audit complete"
echo " Need help optimizing your storage?"
echo " https://tuxbilisim.com/analiz/"
echo "=========================================="
