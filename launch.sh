A=~/code/pmbootstrap
B=~/code/linux
echo "Hi there! I will check if your folders are set up and programs upgraded as well in order to build pmOS"
echo "First thing to do is to install git, so please install it on your system and press ENTER."
read -n 1 -r -s -p $"Press ENTER to continue the script"
if test -e "$A"; then
	cd ~/code/pmbootstrap
else mkdir -p ~/code && cd code && git clone https://gitlab.com/postmarketOS/pmbootstrap && pmbootstrap chroot -- apk upgrade && apk add abootimg android-tools mkbootimg dtbtool
fi
	alias pmbootstrap=pmboostrap.py
	git pull
	if test -e "$B"; then
		cd ~/code
	else
		cd ~/code
		echo "Which GIT do you want to take as linux folder?"
		echo "Copy the ''Clone with HTTPS'' on GitLab or GitHub and put here."
		read GIT
		git clone $GIT
		echo "Write the exact name of git folder"
		read FOLDER
		mv $FOLDER linux
fi
		cd ~/code/linux
		source ~/code/pmbootstrap/helpers/envkernel.sh
		echo "Which device do you want to compile? Be sure to know the exact defconfig name, for eg: omap4_samsung_maguro_defconfig"
		read DEFCONFIG
		make $DEFCONFIG
		make -j6
		pmbootstrap export
		export DEVICE="$(pmbootstrap config device)"
		export WORK="$(pmbootstrap config work)"
		export TEMP="$WORK/chroot_native/tmp/mainline/"
		mkdir -p "$TEMP"
		cd ~/code/linux/.output/arch/arm/boot
		clear
		ls dts
		echo "write the name of your DTB file in order to continue the build. For eg: omap4-samsung-maguro.dtb"
		read DTB
		cat zImage dts/$DTB > ~/code/linux/.zImage-dtb
		cp ~/code/linux/.zImage-dtb "$TEMP"/zImage-dtb
		cp "/tmp/postmarketOS-export/boot.img-$DEVICE" "$TEMP/boot.img"
		pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "bootsize = 6490112"
		pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "cmdline = pd_ignore_unused clk_ignore_unused earlyprintk ignore_loglevel panic=1"
		pmbootstrap flasher list_devices
		pmbootstrap chroot -- fastboot flash boot /tmp/mainline/boot.img
		pmbootstrap shutdown
		fastboot reboot
		cd ~/
		deactivate
