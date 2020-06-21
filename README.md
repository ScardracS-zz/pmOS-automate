# pmOS-updater
A simple sh file that automate the build of pmOS

It is divided in more parts:

1) Check if pmbootstrap and linux folder exist inside code,
2) Download them and put on proper location (for linux you'll need to set the git you prefer to use),
3) Check if everything is up to date on pmbootstrap (I haven't added a git push as it could be not your repo),
4) Build everything you need
5) Upload to your phone
6) Finish

NB: BE SURE TO CHECK THESE clk_ignore_unused

pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "bootsize = 6490112"
pmbootstrap chroot -- abootimg -u /tmp/mainline/boot.img  -k /tmp/mainline/zImage-dtb -c "cmdline = pd_ignore_unused clk_ignore_unused earlyprintk ignore_loglevel panic=1"

THEY ARE DEVICE SPECIFIC. THESE VALUES ARE FOR MAGURO SO BE SURE TO CHECK THEM BEFORE LAUNCH THE SH!
