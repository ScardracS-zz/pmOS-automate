echo "Set your bootsize here:"
read bootsize
abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c $bootsize
echo "Set your cmdline here, with quotes:"
read cmdline
abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c $cmdline
flasher list_devices
chroot -- fastboot flash boot /tmp/mainline/boot.img
shutdown
fastboot reboot
cd ~/
deactivate
exit
