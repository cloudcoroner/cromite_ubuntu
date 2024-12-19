#!/bin/bash
# start_cromite.sh


clear
loggedinuser=$(who | head -n1 | awk '{print $1;}')
echo ""
echo "Cromite Update Tool started for " $loggedinuser

if [ -f "/usr/bin/cromite/chrome" ]; then

	cromiterunning=$(ps -ef | awk '{print $8}' | grep -oP /usr/bin/cromite/chrome | head -1)

	if [ "$cromiterunning" = "/usr/bin/cromite/chrome" ]; then

		zenity --info --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite is already open. Update check will be skipped."
		setsid nohup /usr/bin/cromite/chrome $1 &
		sleep 2

	else

		if ping -q -c 1 -W 1 '8.8.8.8' >/dev/null; then

			#GitHub repo redirect for latest release
			cromiteurllatestredirect="https://github.com/uazo/cromite/releases/latest"

			#GitHub release download repo
			cromitedownloadurl="https://github.com/uazo/cromite/releases/download/"

			cromite_inst_ver=$(cat /usr/bin/cromite/cromite.ver)
			cromitelatest=$(wget --max-redirect=0 $cromiteurllatestredirect 2>&1 | awk '/Location: /,// { print }' | awk '{print $2}' | awk -F "/" '{print $NF}')

			if [[ $cromite_inst_ver != $cromitelatest ]]; then
				
				if zenity --question --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite has an update!\nClick Yes to proceed with the installation  OR \nclick No to open Cromite without Updating."; then
					
					password=$(zenity --forms --title "Cromite Update Tool" --width 500 --height 100 --text "Enter your password to update Cromite." --add-password "Password:")
					
					#download cromite tarball
					echo $password | sudo -S wget -O chrome-lin64.tar.gz $cromitedownloadurl/$cromitelatest/chrome-lin64.tar.gz | zenity --title "Cromite Update Tool" --width 500 --height 100 --text "Downloading Update..." --progress --pulsate --auto-close --auto-kill

					#extract to install directory
					echo $password | sudo -S tar xf chrome-lin64.tar.gz -C /usr/bin/cromite --strip-components=1
					echo $password | sudo -S echo $cromitelatest | tee /usr/bin/cromite/cromite.ver

					#clean up
					echo $password | sudo -S rm -rf chrome-lin64.tar.gz
					
					setsid nohup /usr/bin/cromite/chrome $1 &
					sleep 2
				
				else
				
					setsid nohup /usr/bin/cromite/chrome $1 &
					sleep 2
				
				fi
			
			else

				setsid nohup /usr/bin/cromite/chrome $1 &
				sleep 2

			fi

		else

			zenity --info --title "Cromite Update Tool" --width 500 --height 100 --text "No internet. Update check will be skipped."
			setsid nohup /usr/bin/cromite/chrome $1 &
			sleep 2

		fi
		
	fi

else

	zenity --error --title "Cromite Update Tool" --width 500 --height 100 --text "Cromite is NOT installed and cannot be updated."

fi

exit