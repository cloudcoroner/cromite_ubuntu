#!/bin/bash
#setup_cromite.sh

export HISTIGNORE='*sudo -S*'

#GitHub repo redirect for latest release
cromiteurllatestredirect="https://github.com/uazo/cromite/releases/latest"

#GitHub release download repo
cromitedownloadurl="https://github.com/uazo/cromite/releases/download/"

#follow redirect to get the latest release version
cromitelatest=$(wget --max-redirect=0 $cromiteurllatestredirect 2>&1 | awk '/Location: /,// { print }' | awk '{print $2}' | awk -F "/" '{print $NF}')





file_cromite_desktop()
{
echo $password | sudo -S cat <<EOF > "/usr/share/applications/cromite.desktop"
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

#end of file_cromite_desktop
}





file_start_cromite()
{
echo $password | sudo -S cat <<EOF > "/etc/apparmor.d/usr.bin.cromite.chrome"
abi <abi/4.0>,
include <tunables/global>

profile cromite /usr/bin/cromite/chrome flags=(unconfined) {
  userns,

  include if exists <local/chrome>
}
EOF

#end of file_start_cromite
}








if [ "$(lsb_release -s -i)" = "Ubuntu" ]; then
	# This computer is running Ubuntu
	
        #zentity comes with the default Ubuntu install, but if not, install it
        if [ ! -f "/usr/bin/zenity" ]; then
		sudo apt install zenity
        fi
	
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
		file_cromite_desktop
            
            
		#set desktop file permissions
		echo $password | sudo -S chmod 644 /usr/share/applications/cromite.desktop
		
		#configure gnome to see cromite as an alternative browser and then update the database
		echo $password | sudo -S update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/cromite/chrome 100
		echo $password | sudo -S update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /usr/bin/cromite/chrome 100
		echo $password | sudo -S xdg-settings set default-web-browser cromite.desktop
		echo $password | sudo -S update-desktop-database
            
        	if [ "$(lsb_release -s -r)" = "24.04" ]; then
        	
			echo $password | sudo -S touch "/etc/apparmor.d/usr.bin.cromite.chrome"
			file_start_cromite
			
			echo $password | sudo -S apparmor_parser -r /etc/apparmor.d/usr.bin.cromite.chrome
            
		#end of Ubuntu 24.04 check for apparmor
		fi

        #end of Install verification check
        fi

#end of Ubuntu check
fi

exit
