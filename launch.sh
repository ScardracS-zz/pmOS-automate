# TODO
# AUTOMATE THE ALIASES IN ORDER TO SET ONCE AND FOR ALL
# ADD THE ABILITY TO ADD -c VALUES DIRECTLY ON SH LIKE OTHER COMMANDS
	echo "Hi there! I am a simply script created by @ScardracS."
	echo "I will check if your folders are set up and programs on pmbootstrap upgraded as well in order to build pmOS."
	echo "Be sure you have git, adb and fastboot installed."
	
# Set global git pull in order to fix any possible problem when updating pmbootstrap
git config --global pull.rebase false

# Check if aliases is set on shell
clear
echo "Which shell do you use?"
echo "BASH or ZSH?"
echo "NB: write the answer in UPPERCASE"
read shell
case $shell in
	BASH) 
		W=~/.bashrc
		if grep -q alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py "$W"; then
		 	echo "Aliases already set. Skipping..."
		 else 
		 	echo "alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py" >> ~/.bashrc
		fi
	;;
	
	ZSH) 
		Z=~/.zshrc
		if grep -q alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py "$Z"; then
		 	echo "Aliases already set. Skipping..."
		 else 
		 	echo "alias pmbootstrap=~/code/pmbootstrap/pmbootstrap.py" >> ~/.zshrc
		fi
	;;
esac
clear

# Verify if code/linux and code/pmbootstrap are already on your home folder.
	A=~/code/pmbootstrap
	B=~/code/linux

	if test -e "$A"; then
		echo "pmbootstrap's folder exist. Skipping..."
	else
		mkdir ~/code
		git clone https://gitlab.com/postmarketOS/pmbootstrap ~/code/pmbootstrap
		mkdir -p ~/.local/var/pmbootstrap
		pmbootstrap init
		pmbootstrap chroot -- apk add abootimg android-tools mkbootimg dtbtool
		mkdir ~/code/.installed
	fi

# Check everytime for pmbootstrap update in order to be sure everything is working as it should
	pmbootstrap chroot -- apk upgrade
	git pull
	if test -e "$B"; then
		echo "linux's folder exist. Skipping..."
	else
		echo "Which GIT do you want to take as linux folder? Put here the link."
		echo "Are accepted both HTTPS and git@git links."
		read C
		git clone $C ~/code/linux
	fi

# Start the build of pmOS
	cd ~/code/linux
	source ~/code/pmbootstrap/helpers/envkernel.sh
	echo "Which device do you want to compile? Be sure to know the exact defconfig name, for eg: omap4_samsung_maguro_defconfig"
	read D
	make $D
	make -j6
	pmbootstrap export
	export DEVICE="$(pmbootstrap config device)"
	export WORK="$(pmbootstrap config work)"
	export TEMP="$WORK/chroot_native/tmp/mainline/"
	mkdir -p "$TEMP"
	cd ~/code/linux/.output/arch/arm/boot
	ls dts
	echo "Write the name of your DTB file in order to continue the build. For eg: omap4-samsung-maguro.dtb"
	read E
	cat zImage dts/$E > "$TEMP"/zImage-dtb
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
