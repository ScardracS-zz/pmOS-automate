# TODO
# AUTOMATE THE ALIASES IN ORDER TO SET ONCE AND FOR ALL
# ADD THE ABILITY TO ADD -c VALUES DIRECTLY ON SH LIKE OTHER VALUES
	echo "Hi there! I am a simply script created by @ScardracS."
	echo "I will check if your folders are set up and programs on pmbootstrap upgraded as well in order to build pmOS."
	echo "Be sure you have git, adb and fastboot installed."

#Verify if code/linux and code/pmbootstrap are already on your home folder.
	A=~/code/pmbootstrap
	B=~/code/linux

	if test -e "$A"; then
		alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py
	else
		mkdir ~/code
		cd ~/code
		git clone https://gitlab.com/postmarketOS/pmbootstrap
		alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py
		pmbootstrap chroot -- apk add abootimg android-tools mkbootimg dtbtool
		mkdir ~/code/.installed
	fi

# Check everytime for pmbootstrap update in order to be sure everything is working as it should
	pmbootstrap chroot -- apk upgrade
	git pull
	if test -e "$B"; then
		cd
	else
		cd ~/code
		echo "Which GIT do you want to take as linux folder?"
		echo "Copy the 'Clone with HTTPS' on GitLab or GitHub and put here."
		read GIT
		git clone $GIT
		echo "Write the exact name of git folder"
		read FOLDER
		mv $FOLDER linux
	fi

#Start the build of pmOS
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
	ls dts
	echo "Write the name of your DTB file in order to continue the build. For eg: omap4-samsung-maguro.dtb"
	read DTB
	cat zImage dts/$DTB > ~/code/linux/.zImage-dtb
	cp ~/code/linux/.zImage-dtb "$TEMP"/zImage-dtb
	cp "/tmp/postmarketOS-export/boot.img-$DEVICE" "$TEMP/boot.img"

# Again: be sure to check these values for your device!
	pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "bootsize = 6490112"
	pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "cmdline = pd_ignore_unused clk_ignore_unused earlyprintk ignore_loglevel panic=1"
	pmbootstrap flasher list_devices
	pmbootstrap chroot -- fastboot flash boot /tmp/mainline/boot.img
	pmbootstrap shutdown
	fastboot reboot
	cd ~/
	deactivate
	exit
