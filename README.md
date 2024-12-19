# cromite_ubuntu
A set of scripts to install and keep Cromite up to date


Uazo has done amazing work with Cromite - A privacy focused chromium browser that was forked from Bromite. I wanted to create a script that makes it easy for the average user to add this to their Ubuntu desktop installations. Check out his work, here: https://github.com/uazo/cromite

FAQs

1. Why not other Linux distros? Well, Ubuntu is the most common distro of choice for average and first time Linux users. Installing a binary manually can be daunting for some users and I think it is important for users of all skillsets to have an option for a private browser.

2. What does this script do? It checks that the user is running Ubuntu, downloads the binary package from Uazo's repo, and installs it into /usr/bin/cromite for all users. It also creates the necessary desktop icons, permissions and update mechanism.

3. How does it update? When the script installs Cromite, it saves the version it downloads from Uazo's repo. Each time Cromite is started, the script checks Uazo's repo for an updated version. if one exists, the user will be prompted to install it. If the user never opens Cromite, the script never checks for an update. There is no running service. I wanted to give the user as much control and privacy as possible.

4. Why does it ask for a root password? For new Linux users, going into a command prompt can be scary. I know this is a bash script, but I figured putting a GUI on it and asking for a password once is more user friendly. You can lok through the script, the password is only kept during script execution.
