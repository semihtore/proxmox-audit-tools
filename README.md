# Proxmox Audit Tools

A collection of audit, validation and reporting scripts for **Proxmox VE** production environments.

Built from real operational experience at [Tux Bilişim](https://tuxbilisim.com) — enterprise open source infrastructure consulting.

## What's Inside

| Script | Description |
|--------|-------------|
| `scripts/cluster-audit.sh` | Cluster health check: quorum, Corosync links, Ceph status, HA resource state |
| `scripts/storage-check.sh` | Storage path validation: NFS mount options, Ceph OSD status, ZFS pool health |
| `scripts/migration-report.sh` | Pre/post migration validation: VM inventory, snapshot age, backup verification |
| `scripts/network-diag.sh` | Network diagnostics: MTU consistency, bond status, VLAN configuration checks |

## Quick Start

```bash
git clone https://github.com/semihtore/proxmox-audit-tools.git
cd proxmox-audit-tools

# Run a full cluster audit
bash scripts/cluster-audit.sh

# Check storage paths
bash scripts/storage-check.sh
```

## Use Cases

- **Pre-migration validation** — Verify environment readiness before VMware to Proxmox migration. See the full [VMware to Proxmox migration guide](https://tuxbilisim.com/migration-guide/).
- **Production health checks** — Regular cluster, storage and network consistency audits
- **Incident analysis** — Gather system state data during troubleshooting
- **Compliance reporting** — Generate infrastructure state reports for operations teams

## Requirements

- Proxmox VE 7.x or 8.x
- Root or sudo access to Proxmox nodes
- `jq` for JSON parsing (install via `apt install jq`)

## License

MIT

---

*Professional Proxmox consulting, migration and support — [Tux Bilişim](https://tuxbilisim.com)*
