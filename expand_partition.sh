lsblk # show info about partitions
# (EXAMPLE OUTPUT)
# NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
# sda       8:0    0    2T  0 disk
# ├─sda1    8:1    0  2.9G  0 part /
# ├─sda14   8:14   0    3M  0 part
# └─sda15   8:15   0  124M  0 part /boot/efi

# expand partition (make sure to specify the right partition by looking at the tree you got above!
sudo apt install cloud-guest-utils -y
sudo growpart /dev/sda 1

# you may need to do the following to expand the filesystem
sudo resize2fs /dev/sda1
