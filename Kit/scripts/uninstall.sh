#! /bin/sh

sudo launchctl unload /Library/LaunchDaemons/com.textd.MacStats.SMC.Helper.plist
sudo rm /Library/LaunchDaemons/com.textd.MacStats.SMC.Helper.plist
sudo rm /Library/PrivilegedHelperTools/com.textd.MacStats.SMC.Helper
sudo rm $HOME/Library/Application Support/Stats
