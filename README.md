arch
hobn's Arch Linux project for SVE14A27CXH
====

TODO:
Wifi on resume/wifi-menu alternative
Occasional "Operating system not found"
Brightness widget/notification in awesomewm
Theming awesomewm
Battery drain in suspend
Login manager/screen locker
Complete CLI/GUI environment

IDEAS:
Clean under keyboard/touchpad

DONE:
Boot Arch (format EFI partition as VFAT instead of FAT32)
Fix grub.cfg (manually replace .cfg with .cfg.new file)
Run X as non-root user (copy /root/.xinitrc file to /home/$USER)
Hybrid graphics (turn off discrete at boot, back on before suspend/hibernate and back off on resume; see install.sh)
