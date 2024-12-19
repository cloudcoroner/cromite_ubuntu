#!/bin/bash
#setup_cromite.sh

export HISTIGNORE='*sudo -S*'

if [ "$(lsb_release -s -i)" = "Ubuntu" ]; then
	# This computer is running Ubuntu
	
        #zentity comes with the default Ubuntu install, but if not, install it
        if [ ! -f "/usr/bin/zenity" ]; then
		sudo apt install zenity
        fi
	
        if zenity --question --title "Cromite Install Tool" --width 500 --height 100 --text "This will install Cromite and set it as the default web browser!\nClick Yes to proceed with the installation  OR \nclick No to cancel."; then
        					
  		#GitHub repo redirect for latest release
		cromiteurllatestredirect="https://github.com/uazo/cromite/releases/latest"
		
		#GitHub release download repo
		cromitedownloadurl="https://github.com/uazo/cromite/releases/download/"
		
		#Cromite startup file location
		cromitestartupurl="https://github.com/cloudcoroner/cromite_ubuntu/blob/main/start_cromite.sh"
		
		#follow redirect to get the latest release version
		cromitelatest=$(wget --max-redirect=0 $cromiteurllatestredirect 2>&1 | awk '/Location: /,// { print }' | awk '{print $2}' | awk -F "/" '{print $NF}')

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
		
		#download cromite startup file with update check and make executable
		echo $password | sudo -S wget $cromitestartupurl -P /usr/bin/cromite/
		echo $password | sudo -S chmod +x /usr/bin/cromite/start_cromite.sh
		
		#clean up
		echo $password | sudo -S rm -rf chrome-lin64.tar.gz
		
		#copy icon from downloaded release to the icon cache
		echo $password | sudo -S cp /usr/bin/cromite/product_logo_48.png /usr/share/icons/hicolor/48x48/apps/cromite.png
		
		#remove existing cromite desktop file
		echo $password | sudo -S rm -rf "/usr/share/applications/cromite.desktop"
            
            	#create cromite desktop file
		echo $password | sudo -S touch "/usr/share/applications/cromite.desktop"
		echo $password | echo "#!/bin/sh" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo '' | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "# Author:      SAEOS, saeos [dot] com" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "# Description: Cromite is a Chromium fork based on Bromite with built-in support for adblocking and an eye for privacy." | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "# Executed by: user, on-demand" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "# Resources:   /bin/bash, default Ubuntu icon set" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "#" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "[Desktop Entry]" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Name=Cromite" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "X-MultipleArgs=false" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Exec=/usr/bin/cromite/start_cromite.sh %u" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Terminal=false" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Type=Application" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Icon=/usr/share/icons/hicolor/48x48/apps/cromite.png" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Comment=Browse the World Wide Web" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Keywords=Internet;WWW;Browser;Web;Explorer" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "Categories=GNOME;GTK;Network;WebBrowser;" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "StartupNotify=true" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
		echo $password | echo "StartupWMClass=Chromium-browser" | sudo -S tee -a "/usr/share/applications/cromite.desktop"
            
            
		#set desktop file permissions
		echo $password | sudo -S chmod 644 /usr/share/applications/cromite.desktop
		
		#configure gnome to see cromite as an alternative browser and then update the database
		echo $password | sudo -S update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/cromite/chrome 100
		echo $password | sudo -S update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/cromite/chrome 100
		echo $password | sudo -S xdg-settings set default-web-browser cromite.desktop
		echo $password | sudo -S update-desktop-database
            
        	if [ "$(lsb_release -s -r)" = "24.04" ]; then
        	
			echo $password | sudo -S touch "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "abi <abi/4.0>," | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "include <tunables/global>" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "profile cromite /usr/bin/cromite/chrome flags=(unconfined) {" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "userns," | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "include if exists <local/chrome>" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			echo $password | echo "}" | sudo -S tee -a "/etc/apparmor.d/usr.bin.cromite.chrome"
			
			echo $password | sudo -S apparmor_parser -r /etc/apparmor.d/usr.bin.cromite.chrome
            
		#end of Ubuntu 24.04 check for apparmor
		fi

        #end of Install verification check
        fi

#end of Ubuntu check
fi

exit
