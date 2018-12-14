# BadUSB-Block
Author: mmcabee

This script will harden your system against the 'BadUSB' vulnerability. 
It will make several registry alterations, which aim to accomplish the following actions: 
  - Prevent reading and writing to and from removable storage mediums. 
  - Kill auto-trust-install drivers for bluetooth, HID, keyboard, and networking devices. 
  - Block user-access to shell-based utilities, which allow 'BadUSB' devices to interface with the system. 
  - The BadUSB that was used for testing was the Hak5 Bash Bunny, so this script will also block the DHCP address lease range to attempt to mitigate the BB from communicating with other systems across your network. (aimed at mitigating RNDIS_ETHERNET emulated attacks.

Once this script recurses, it will issue a reboot command. If you do not want the system to reboot, either remove or comment out line 122.

# Note: You MUST run this script with administrative/elevated privilege, or else you will not have the privilege necessary to make the required changes. #

Please know that this script severely limits certain functionality on the system in which it is run on. 
# I am not responsible for ANY adverse effects. Nothing. Nada. Nichts. Sorry, not sorry. 
