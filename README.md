# cromite_ubuntu
A set of scripts to install and keep Cromite up to date on Ubuntu Linux Desktop


Uazo has done amazing work with Cromite - A privacy focused chromium browser that was forked from Bromite. I wanted to create a script that makes it easy for the average user to add this to their Ubuntu desktop installations. Check out his amazing work, here: https://github.com/uazo/cromite

Installation
1. Download the latest release package from here https://github.com/cloudcoroner/cromite_ubuntu/releases.
2. Go to your Downloads folder.
     1. Double-click on the zip or tar.gz file to unpack it. It will extract the files in a new folder.
     2. Double-click on the setup_cromite folder.
     3. Once you find the setup_cromite.sh file, right-click on the file and click Properties (at the bottom of the list)
3. In Ubuntu 24.04
     1. In the properties window, turn on the toggle at the bottom named "Exectuable as a program" and then close the window by clicking the X in the top right corner.
     2. Right click on the file setup_cromite.sh again and click "Run as a Program"
4. In Ubuntu 22.04 - In the properties window, click on the permissions tab in the properties window and check the box "Allow executing file as a program"

FAQs

1. Why focus on Ubuntu? Ubuntu is the most common distro of choice for average and first time Linux users due to it's ease of use and compatability with the tools people use at work (including VPN clients). For many users, the steps required to manually install a binary can be daunting and I think it is important for users of all skillsets to have an accessible option for a private browser. This is my way of contributing.

3. What does this script do? It checks that the user is running Ubuntu, downloads the binary package from Uazo's repo, and installs it into /usr/bin/cromite for all users. It also creates the necessary desktop icons, permissions and update mechanism.

4. How does it update? When the script installs Cromite, it saves the version it downloads from Uazo's repo. Each time Cromite is started, the script checks Uazo's repo for an updated version. if one exists, the user will be prompted to install it. If the user never opens Cromite, the script never checks for an update. There is no running service. I wanted to give the user as much control and privacy as possible.

5. Why does it ask for a root password? For new Linux users, going into a command prompt can be scary. I know this is a bash script, but I figured putting a GUI on it and asking for a password once is more user friendly. You can lok through the script, the password is only kept during script execution.
