# go-lvm-helper

[![build](https://github.com/longhorn/go-lvm-helper/actions/workflows/build.yml/badge.svg)](https://github.com/longhorn/go-lvm-helper/actions/workflows/build.yml)

LVM helpers for the Longhorn local data engine: disk (volume group), instance
(logical volume) and metrics operations, built on a persistent LVM devices
file so Longhorn-managed devices stay isolated from the host's.

## Packages

- `pkg/lvm` — the local data engine operations consumed by
  [longhorn-instance-manager](https://github.com/longhorn/longhorn-instance-manager):
  - disk: create, adopt, refresh, grow and delete volume groups with a
    `longhorn-thin-pool` thin pool;
  - instance: replica instances as thin LVs, engine instances as LVM tags;
  - metrics: device I/O counters sampled from `/proc/diskstats`;
  - executor: an LVM command runner that terminates the whole process group
    on timeout so a timed-out command cannot hold a volume-group lock.

## Testing

```
make ci
```

runs `go vet`, `golangci-lint`, `go fmt` and the unit tests in a container.
