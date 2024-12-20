#!/bin/bash
#setup_cromite.sh

export HISTIGNORE='*sudo -S*'

#GitHub repo redirect for latest release
cromiteurllatestredirect="https://github.com/uazo/cromite/releases/latest"

#GitHub release download repo
cromitedownloadurl="https://github.com/uazo/cromite/releases/download/"

#follow redirect to get the latest release version
cromitelatest=$(wget --max-redirect=0 $cromiteurllatestredirect 2>&1 | awk '/Location: /,// { print }' | awk '{print $2}' | awk -F "/" '{print $NF}')










create_file_cromite_desktop()
{
echo $password | sudo -S rm -rf "/usr/share/applications/cromite.desktop"
echo $password | sudo -S touch "/usr/share/applications/cromite.desktop"
echo $password | sudo -S tee -a "/usr/share/applications/cromite.desktop" >/dev/null <<EOF
#!/bin/sh

# Author:      cloud coroner, cloud coroner [dot] com
# Description: Cromite is a Chromium fork based on Bromite with built-in support for adblocking and an eye for privacy.
# Executed by: user, on-demand
# Resources:   /bin/sh, zenity, latest Cromite release from Uazo

[Desktop Entry]
Name=Cromite
X-MultipleArgs=false
Exec=/usr/bin/cromite/start_cromite.sh %u
Terminal=false
Type=Application
Icon=/usr/share/icons/hicolor/48x48/apps/cromite.png
Comment=Browse the World Wide Web
Keywords=Internet;WWW;Browser;Web;Explorer
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
StartupWMClass=Chromium-browser
EOF

#end of create_file_cromite_desktop
}











create_file_apparmor()
{
echo $password | sudo -S rm -rf "/etc/apparmor.d/usr.bin.cromite.chrome"
echo $password | sudo -S touch "/etc/apparmor.d/usr.bin.cromite.chrome"
echo $password | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome" >/dev/null <<EOF
abi <abi/4.0>,
include <tunables/global>

profile cromite /usr/bin/cromite/chrome flags=(unconfined) {
  userns,

  include if exists <local/chrome>
}
EOF

#end of create_file_apparmor
}











create_file_start_cromite()
{
echo $password | sudo -S rm -rf "/usr/bin/cromite/start_cromite.sh"
echo $password | sudo -S touch "/usr/bin/cromite/start_cromite.sh"
echo $password | sudo -S tee -a "/usr/bin/cromite/start_cromite.sh" >/dev/null <<EOF
#!/bin/bash
# start_cromite.sh


clear
loggedinuser=\$(who | head -n1 | awk '{print $1;}')
echo ""
echo "Cromite Update Tool started for " \$loggedinuser

if [ -f "/usr/bin/cromite/chrome" ]; then

	cromiterunning=\$(ps -ef | awk '{print $8}' | grep -oP /usr/bin/cromite/chrome | head -1)

	if [ "$cromiterunning" = "/usr/bin/cromite/chrome" ]; then

		zenity --info --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite is already open. Update check will be skipped."
		setsid nohup /usr/bin/cromite/chrome \$1 &
		sleep 2

	else

		if ping -q -c 1 -W 1 '8.8.8.8' >/dev/null; then

			#GitHub repo redirect for latest release
			cromiteurllatestredirect="https://github.com/uazo/cromite/releases/latest"

			#GitHub release download repo
			cromitedownloadurl="https://github.com/uazo/cromite/releases/download/"

			cromite_inst_ver=\$(cat /usr/bin/cromite/cromite.ver)
			cromitelatest=\$(wget --max-redirect=0 \$cromiteurllatestredirect 2>&1 | awk '/Location: /,// { print }' | awk '{print \$2}' | awk -F "/" '{print \$NF}')

			if [[ \$cromite_inst_ver != \$cromitelatest ]]; then
				
				if zenity --question --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite has an update!\nClick Yes to proceed with the installation  OR \nclick No to open Cromite without Updating."; then
					
					password=\$(zenity --forms --title "Cromite Update Tool" --width 500 --height 100 --text "Enter your password to update Cromite." --add-password "Password:")
					
					#download cromite tarball
					echo \$password | sudo -S wget -O chrome-lin64.tar.gz \$cromitedownloadurl/\$cromitelatest/chrome-lin64.tar.gz | zenity --title "Cromite Update Tool" --width 500 --height 100 --text "Downloading Update..." --progress --pulsate --auto-close --auto-kill

					#extract to install directory
					echo \$password | sudo -S tar xf chrome-lin64.tar.gz -C /usr/bin/cromite --strip-components=1
					echo \$password | sudo -S echo \$cromitelatest | tee /usr/bin/cromite/cromite.ver

					#clean up
					echo \$password | sudo -S rm -rf chrome-lin64.tar.gz
					
					setsid nohup /usr/bin/cromite/chrome \$1 &
					sleep 2
				
				else
				
					setsid nohup /usr/bin/cromite/chrome \$1 &
					sleep 2
				
				fi
			
			else

				setsid nohup /usr/bin/cromite/chrome \$1 &
				sleep 2

			fi

		else

			zenity --info --title "Cromite Update Tool" --width 500 --height 100 --text "No internet. Update check will be skipped."
			setsid nohup /usr/bin/cromite/chrome \$1 &
			sleep 2

		fi
		
	fi

else

	zenity --error --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite is NOT installed and cannot be updated."

fi

exit
EOF

#end of create_file_start_cromite
}










install_cromite()
{
if zenity --question --title "Cromite Install Tool" --width 500 --height 100 --text "This will install Cromite and set it as the default web browser!\nClick Yes to proceed with the installation  OR \nclick No to cancel."; then
        					
  		#get root password for install
  		password=$(zenity --forms --title "Cromite Install Tool" --width 500 --height 100 --text "Enter root password to install Cromite." --add-password "Password:")
        			
		#create install directory
		echo $password | sudo -S rm -rf /usr/bin/cromite
		echo $password | sudo -S mkdir /usr/bin/cromite
		
		#chmod 400 /usr/bin/cromite
		echo $password | sudo -S chown -R root:root /usr/bin/cromite
		
		#download cromite tarball
		echo $password | sudo -S wget -O chrome-lin64.tar.gz $cromitedownloadurl/$cromitelatest/chrome-lin64.tar.gz
		
		#extract to install directory
		echo $password | sudo -S tar xf chrome-lin64.tar.gz -C /usr/bin/cromite --strip-components=1
		
		#create file with installed version for future updates
		echo $password | sudo -S touch /usr/bin/cromite/cromite.ver
		echo $password | echo $cromitelatest | sudo -S tee /usr/bin/cromite/cromite.ver
		
		#create cromite startup file with update check and make executable
		create_file_start_cromite
		echo $password | sudo -S chmod +x /usr/bin/cromite/start_cromite.sh
		
		#clean up
		echo $password | sudo -S rm -rf chrome-lin64.tar.gz
		
		#copy icon from downloaded release to the icon cache
		echo $password | sudo -S cp /usr/bin/cromite/product_logo_48.png /usr/share/icons/hicolor/48x48/apps/cromite.png
		
            	#create cromite desktop file and set permissions
		create_file_cromite_desktop
		echo $password | sudo -S chmod 644 /usr/share/applications/cromite.desktop
		
		#configure gnome to see cromite as an alternative browser and then update the database
		echo $password | sudo -S update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/cromite/chrome 100
		echo $password | sudo -S update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/cromite/chrome 100
		xdg-settings set default-web-browser cromite.desktop
		echo $password | sudo -S update-desktop-database
            
        	if [ "$(lsb_release -s -r)" = "24.04" ]; then
        	
			#create apparmor definition
   			create_file_apparmor
			echo $password | sudo -S apparmor_parser -r /etc/apparmor.d/usr.bin.cromite.chrome
            
		#end of Ubuntu 24.04 check for apparmor
		fi

		if [ "$(lsb_release -s -r)" = "24.04" ]; then
        	
			zenity --info --title "Cromite Install Tool 24.04" --width 500 --height 100 --text "Cromite has been Installed and set as the default Web Browser.\n\nYou will be notified of updates when you start Cromite.\n\nIf you would like to set Firefox back to default,\ngo to Settings -> Apps -> Default Apps"
           
		#end of Ubuntu 24.04 check for install next steps
		fi

		if [ "$(lsb_release -s -r)" = "22.04" ]; then
        	
			zenity --info --title "Cromite Install Tool 22.04" --width 500 --height 100 --text "Cromite has been Installed and set as the default Web Browser.\n\nYou will be notified of updates when you start Cromite.\n\nIf you would like to set Firefox back to default,\ngo to Settings, Default Applications "
           
		#end of Ubuntu 24.04 check for install next steps
		fi
  
#end of Install verification check
fi

#end of install_cromite
}









uninstall_cromite()
{
if zenity --question --title "Cromite Uninstall Tool" --width 500 --height 100 --text "This will Uninstall Cromite and set Firefox as the default web browser!\n\nClick Yes to proceed or click No to cancel."; then
        					
  		#get root password for install
  		password=$(zenity --forms --title "Cromite Uninstall Tool" --width 500 --height 100 --text "Enter root password to uninstall Cromite." --add-password "Password:")
        			
		#remove install directory
		echo $password | sudo -S rm -rf /usr/bin/cromite
		
		#remove downloaded cromite package
		echo $password | sudo -S rm -rf chrome-lin64.tar.gz
		
		#copy icon copied to the icon cache
		echo $password | sudo -S rm -rf /usr/share/icons/hicolor/48x48/apps/cromite.png
		
            	#remove cromite desktop file
		echo $password | sudo -S rm -rf /usr/share/applications/cromite.desktop
		
		#remove cromite as an alternative browser from gnome and then update the database
		echo $password | sudo -S update-alternatives --remove x-www-browser /usr/bin/cromite/chrome
		echo $password | sudo -S update-alternatives --remove gnome-www-browser /usr/bin/cromite/chrome
		xdg-settings set default-web-browser firefox_firefox.desktop
		echo $password | sudo -S update-desktop-database
            
        	if [ "$(lsb_release -s -r)" = "24.04" ]; then
        	
			#remove apparmor definition
   			echo $password | sudo -S apparmor_parser -R /etc/apparmor.d/usr.bin.cromite.chrome
      			echo $password | sudo -S rm -rf "/etc/apparmor.d/usr.bin.cromite.chrome"
            
		#end of Ubuntu 24.04 check for apparmor
		fi

		if zenity --question --title "Cromite Uninstall Tool" --width 500 --height 100 --text "Cromite has been Uninstalled.\n\nIf you would like to remove your app profile, click Yes,\nor click No to keep your Cromite settings for future installs."; then

			if zenity --question --icon-name "dialog-warning" --title "Cromite Uninstall Tool" --width 500 --height 100 --text "IF YOU HAVE OTHER CHROME OR CHROMIUM BROWSERS INSTALLED\nTHIS COULD REMOVE THOSE PROFILES AS WELL\n\nClick Yes to continue or No to keep your settings for future installs."; then

				rm -rf ~/.config/chromium
				rm -rf ~/.gnome/apps/chrome-*
				rm -rf ~/.local/share/desktop-directories/chrome-apps.directory
				rm -rf ~/.local/share/applications/chrome-*
				rm -rf ~/.config/menus/applications-merged/user-chrome-apps.menu

			#end of profile removal final check
 			fi

		#end of profile removal check
		fi
#end of Uninstall verification check
fi

#end of uninstall_cromite
}










install_cromite_profile()
{
if zenity --question --title "Cromite Install Tool" --width 500 --height 100 --text "Would you like to configure Cromite with\nPRivate Search, additional Adblock and other settings?\n(Open the readme for more information)\nClick Yes to continue or No to keep default settings."; then

	#unzip profile zip from release package into users profile
	unzip cromite-home-config-chromium.zip -d ~/.config/

#end of profile removal final check
fi

#end of install_cromite_profile
}










if [ "$(lsb_release -s -i)" = "Ubuntu" ]; then
	# This computer is running Ubuntu
	
        #zentity comes with the default Ubuntu install, but if not, install it
        if [ ! -f "/usr/bin/zenity" ]; then
		sudo apt install zenity
        fi
	setupchoice=$(zenity --forms --title "Cromite Setup Tool" --width 500 --height 100 --text "This tool helps automate the install and uninstall of Cromite from Ubuntu." --add-combo "Setup Choice:" --combo-values "Install|Uninstall")

  	if [ "$setupchoice" = "Install" ]; then
		install_cromite
  		install_cromite_profile
  	fi
   
	if [ "$setupchoice" = "Uninstall" ]; then
		uninstall_cromite
  	fi

     	if [ "$setupchoice" = "Cancel" ]; then
		exit
  	fi
#end of Ubuntu check
fi

exit
