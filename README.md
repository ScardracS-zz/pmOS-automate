# pmOS-updater
A simple sh file that automate the build of pmOS

It is divided in more parts:

1) Check if pmbootstrap and linux folder exist inside code,
2) Download them from proper location (for linux you'll need to set the git you prefer to use),
3) Check if everything is up to date on pmbootstrap (I haven't added a git push as it could be not your repo),
4) Build everything you need
5) Upload to your phone
6) Finish

NB: BE SURE TO CHECK WHICH COMMANDS YOU NEED FOR YOUR BOOT DEVICE. THESE ARE FOR SAMSUNG GALAXY MAGURO!
