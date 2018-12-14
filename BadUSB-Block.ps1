# Author: Matthew McAbee
# This script will harden your system against the 'BadUSB' vulnerability. #
# It will make several registry alterations, which aim to accomplish the following actions: #
#    1. Prevent reading and writing to and from removable storage mediums. #
#    2. Kill auto-trust-install drivers for bluetooth, HID, keyboard, and networking devices. #
#    3. Block user-access to shell-based utilities, which allow 'BadUSB' devices to interface with the system. #

# Note: You MUST run this script with administrative/elevated privilege, or else you will not have the privilege necessary to make the required changes. #
# Once this script recurses, it will issue a reboot command. If you do not want the system to reboot, either remove or comment out line 122.

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# - - - - - Blocking Windows shells (CMD/PowerShell) to prevent BadUSB <-> System Interaction - - - - - #

Write-Host "Restricting CMD access system wide. Stand by." -BackgroundColor Red
Start-Sleep -s 1
Write-Host "Restricting CMD access system wide. Stand by.." -BackgroundColor Red
Start-Sleep -s 1
Write-Host "Restricting CMD access system wide. Stand by..." -BackgroundColor Red
Start-Sleep -s 1
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "DisallowRun" -Value 1 -PropertyType DWORD -Force | Out-Null
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "1" -Value "cmd.exe" -PropertyType "String" | Out-Null
Write-Host "CMD has been restricted. Switching focus to PowerShell. Stand by." -BackgroundColor Red
Start-Sleep -s 2

# PowerShell has been restricted, but the Interactive Scripting Environment has not. This must also be restricted.

New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "2" -Value "powershell.exe" -PropertyType "String" | Out-Null
Write-Host "PowerShell has been restricted. Also restricting PS ISE. Stand by." -BackgroundColor Red
Start-Sleep -s 2
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "3" -Value "powershell_ise.exe" -PropertyType "String" | Out-Null
Write-Host "PS ISE has been restricted. Switching focus to Microsoft Management Console. Stand by." -BackgroundColor Red
Start-Sleep -s 2

# Restrict MMC as well... because.

New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "4" -Value "mmc.exe" -PropertyType "String" | Out-Null
Write-Host "MMC has been restricted." -BackgroundColor Red
Start-Sleep -s 2

# Finally, let's restrict access to Regedit so that user's cannot undo changes set in this script.
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Name "5" -Value "regedit.exe" -PropertyType "String" | Out-Null
Write-Host "Regedit has been restricted." -BackgroundColor Red
Start-Sleep -s 2


# - - - - - Restricting Auto-Install of Particular GUID-Classes - - - - - #

# Creating necessary registry keys 
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\" | Out-Null
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\" | Out-Null
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" | Out-Null

# - - - - - Creating necessary key values - - - - - #
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name "DenyDeviceClasses" -Value "1" -PropertyType "DWord" | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name "DenyDeviceClassesRetroactive" -Value "0" -PropertyType "DWord" | Out-Null

# - - - - - Blocking auto-install of Bluetooth Devices - - - - - #
Write-Host "Preventing the auto-installation of Bluetooth drivers. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "1" -Value "e0cbf06c-cd8b-4647-bb8a-263b43f0f974" -PropertyType "String" | Out-Null
Write-Host "Complete. Switching focus to HID drivers. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2

# - - - - - Blocking auto-install of Human Interface Devices (HID's) - - - - - #
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "2" -Value "745a17a0-74d3-11d0-b6fe-00a0c90f57da" -PropertyType "String" | Out-Null
Write-Host "Complete. Switching focus to keyboard drivers. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2

# - - - - - Blocking auto-install of keyboard drivers. - - - - - #
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "3" -Value "4d36e96b-e325-11ce-bfc1-08002be10318" -PropertyType "String" | Out-Null
Write-Host "Complete. Switching focus to Networking-specific drivers." -BackgroundColor DarkCyan
Start-Sleep -s 2

# - - - - - Networking-driver restrictions - - - - - #
Write-Host "Restricting NIC adapter driver auto install. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "4" -Value "4d36e972-e325-11ce-bfc1-08002be10318" -PropertyType "String" | Out-Null

Write-Host "Restricting networking client drivers auto install. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "5" -Value "4d36e973-e325-11ce-bfc1-08002be10318" -PropertyType "String" | Out-Null

Write-Host "Restricting networking service  drivers auto install. Stand by." -BackgroundColor DarkCyan
Start-Sleep -s 2
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceClasses" -Name "6" -Value "4d36e974-e325-11ce-bfc1-08002be10318" -PropertyType "String" | Out-Null
Write-Host "Driver auto-installation based on class GUID is suffeciently locked down." -BackgroundColor DarkCyan
Start-Sleep -s 2

# - - - - - Denying all access to/from removable media - - - - - #
Write-Host "Denying all access to removable medium. Standy by." -BackgroundColor Magenta
Start-Sleep -s 2
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\RemovableStorageDevices" | Out-Null
New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\RemovableStorageDevices" -Name "Deny_All" -Value "1" -PropertyType "DWord" | Out-Null

# - - - - - Removable media locked down message. - - - - - #
Write-Host "Removable media completely denied." -BackgroundColor Magenta
Start-Sleep -s 3

# - - - - - The Bash Bunny runs its own DHCP server and leases addresses over the 172.16.64.10-12 range. Let's restrict that entrie range using CIDR. # - - - - -
Write-Host "Blacklisting communications to the Bash Bunny's default DHCP lease range. Standy by." -BackgroundColor DarkGray
Start-Sleep -s 5
New-NetFirewallRule -DisplayName "BashBunny-DHCP-Restriction-Outbound" -Direction Outbound –LocalPort Any -Protocol TCP -Action Block -RemoteAddress "172.16.64.0/24" | Out-Null
New-NetFirewallRule -DisplayName "BashBunny-DHCP-Restriction-Inbound" -Direction Inbound –LocalPort Any -Protocol TCP -Action Block -RemoteAddress "172.16.64.0/24" | Out-Null

# - - - - - Final messages. - - - - - #
Write-Host "System locked down. So long and thanks for all the fish." -BackgroundColor DarkGreen
Start-Sleep -s 3

Write-Host "Rebooting system in 3." -BackgroundColor DarkGreen
Start-Sleep -s 1

Write-Host "Rebooting system in 2." -BackgroundColor DarkGreen
Start-Sleep -s 1

Write-Host "Rebooting system in 1." -BackgroundColor DarkGreen
Start-Sleep -s 3

# - - - - - Reboot the system to apply all changes. - - - - - #
Restart-Computer
# - - - - - That's it! The system is now much more secure against BadUSB attacks then it was previously! - - - - - #
# - - - - - Now to get your epoxy out and fill those USB ports up... - - - - - #