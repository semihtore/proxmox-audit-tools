#!/bin/bash
# Proxmox Cluster Audit Script
# Checks: quorum, Corosync links, Ceph status, HA resource state
# Part of proxmox-audit-tools by Tux Bilişim
# https://tuxbilisim.com

set -e

echo "=========================================="
echo " Proxmox Cluster Audit"
echo " $(date)"
echo "=========================================="

# 1. Cluster Status
echo ""
echo "[1/5] Cluster Status"
echo "---------------------"
pvecm status 2>/dev/null || echo "ERROR: Not a cluster node or pvecm not found"

# 2. Corosync Links
echo ""
echo "[2/5] Corosync Link Status"
echo "---------------------------"
corosync-cfgtool -s 2>/dev/null || echo "corosync-cfgtool not available"

# 3. Quorum Information
echo ""
echo "[3/5] Quorum Information"
echo "-------------------------"
corosync-quorumtool -p 2>/dev/null || echo "corosync-quorumtool not available"

# 4. Ceph Status (if configured)
echo ""
echo "[4/5] Ceph Status"
echo "------------------"
if command -v ceph &>/dev/null; then
  ceph -s 2>/dev/null || echo "Ceph not configured on this node"
  echo ""
  ceph osd tree 2>/dev/null | head -20
else
  echo "Ceph CLI not found — skipping"
fi

# 5. HA Resources
echo ""
echo "[5/5] HA Resource Status"
echo "--------------------------"
ha-manager status 2>/dev/null || echo "ha-manager not available"

echo ""
echo "=========================================="
echo " Audit complete"
echo " For professional support:"
echo " https://tuxbilisim.com"
echo "=========================================="
