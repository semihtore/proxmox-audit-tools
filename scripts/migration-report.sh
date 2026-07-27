#!/bin/bash
# Proxmox Migration Readiness Report
# Generates VM inventory, snapshot age and backup status
# Part of proxmox-audit-tools by Tux Bilişim
# https://tuxbilisim.com

set -e

OUTPUT="migration-report-$(date +%Y%m%d).txt"

echo "=========================================="
echo " Proxmox Migration Readiness Report"
echo " Output: $OUTPUT"
echo "=========================================="

{
echo "=========================================="
echo " Migration Report - $(date)"
echo "=========================================="
echo ""

# 1. VM Inventory
echo "[VM Inventory]"
echo "--------------"
qm list 2>/dev/null || echo "No VMs found"
echo ""

# 2. Container Inventory
echo "[Container Inventory]"
echo "---------------------"
pct list 2>/dev/null || echo "No containers found"
echo ""

# 3. Snapshot Age
echo "[Snapshot Age Check]"
echo "--------------------"
for vmid in $(qm list 2>/dev/null | awk 'NR>1 {print $1}'); do
  snaps=$(qm listsnapshot $vmid 2>/dev/null | tail -n +2 | head -5)
  if [ -n "$snaps" ]; then
    echo "VM $vmid has snapshots:"
    echo "$snaps"
  fi
done
echo ""

# 4. Backup Status
echo "[Backup Status]"
echo "---------------"
ls -lh /var/lib/vz/dump/ 2>/dev/null | tail -20 || echo "No backups found in default location"
echo ""

# 5. Storage Usage
echo "[Storage Usage by VM]"
echo "---------------------"
for vmid in $(qm list 2>/dev/null | awk 'NR>1 {print $1}'); do
  disks=$(qm config $vmid 2>/dev/null | grep -E "^((virtio|scsi|ide|sata).*:)" | wc -l)
  echo "VM $vmid: $disks disk(s)"
done

echo ""
echo "=========================================="
echo " Report generated: $(date)"
echo " For migration planning support:"
echo " https://tuxbilisim.com"
echo "=========================================="
} > "$OUTPUT"

echo "Report written to $OUTPUT"
cat "$OUTPUT"
