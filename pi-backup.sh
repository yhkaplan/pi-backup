#!/bin/bash
# Referenced https://raspberrypi.stackexchange.com/questions/72044/is-there-a-way-to-compress-a-backup-of-the-rpi-because-the-backup-has-empty-spac

OUTPUT_DIR=~/
OUTPUT_NAME="raspbian_backup"

# Looks for disk w/ Linux parition
pi_disk=$(diskutil list | grep "Linux" | sed 's/.*\(disk[0-9]\).*/\1/' | uniq)

if [ $? ]; then
    echo "Disk is $pi_disk"
    echo "Output dir is $OUTPUT_DIR"
else
    echo "Disk not found"
    exit
fi

diskutil unmountDisk /dev/$pi_disk
echo "Backing up... (ctrl+T for progress)"
time sudo dd if=/dev/r$pi_disk bs=4m | gzip -9 > $OUTPUT_DIR/$OUTPUT_NAME

echo "Adding date to name"
mv -n $OUTPUT_DIR/$OUTPUT_NAME $OUTPUT_DIR/$OUTPUT_NAME_$(date +%Y-%m-%d).img.gz
