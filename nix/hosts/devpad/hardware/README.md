# laptop

## filesystems
**A note about filesystem labels vs partition labels**

- Partition labels are only available on GPT disks (not on the older MBR)
    - On GParted, this is the "Name" column
    - They show up on /dev/disk/by-partlabel.
- Filesystem labels are applied on the specific filesystem of the partition
    - Most major filesystems support this, but not all (e.g. FAT doesn't support)
    - On GParted, this is the "Label" column
    - They show up on /dev/disk/by-label.

|Partition Label|Description|
|---|---|
|EFI|EFI System Partition
|NixOS|NixOS's `/` and `/home/$USER` lives|
|Ubuntu|Small sized, for recovery purposes|
|Data|User data|
|Swap|Swap partition|

