# cromite_ubuntu
A set of scripts to install and keep Cromite up to date on Ubuntu Linux Desktop


Uazo has done amazing work with Cromite - A privacy focused chromium browser that was forked from Bromite. I wanted to create a script that makes it easy for the average user to add this to their Ubuntu desktop installations. Check out his amazing work, here: https://github.com/uazo/cromite

Installation Video:

  If you have 2 minutes, go to the wiki to watch a short install video that walks through installing Cromite on Ubuntu Desktop 24.04.
  Link is here -> https://github.com/cloudcoroner/cromite_ubuntu/wiki/Video-Installing-Cromite-on-Ubuntu-24.04

Setup Steps:
  1. Download the latest zip package from https://github.com/cloudcoroner/cromite_ubuntu/releases
  2. Go to your Downloads folder.
  3. Double-click on the zip file to unpack it. It will extract the files in a new folder.
  4. Double-click on the newly created folder.
  5. Right-click on the setup_cromite.sh file, click Properties (at the bottom of the list).
  6. In the properties window, turn on the toggle at the bottom named "Executable as a program" and then close the window by clicking the X in the top right corner.
  7. Right click on the file setup_cromite.sh again and click "Run as a Program" to begin setup
  8. On the first screen, “Install” should already be chosen in the the drop-down for Setup Choice (you can also choose “Uninstall”) and Click OK to proceed.
  9. You will be asked to confirm you want to Install (or uninstall) Cromite
  10.Next you will be asked for a root password (the same as a Windows admin password). This is used to make the appropriate changes to Ubuntu and is not stored anywhere.

User Profile with Enhanced Privacy
  Cromite is secure and private out of the box. You have the option to install a user profile that includes the following changes:
  1. User history dicarded when Cromite is closed
  2. DNS over HTTPS configured to use Cloudflare DNS' Family security servers to filter malicious sites
  3. Startpage.com set as default search engine. Startpage is based in the Netherlands. They proxy Google searches on your behalf and implment safe search. The add-on is not installed, Cromite is configured to use startpage.
  4. EFF.org Privacy Badger extension is pre-installed to block even more trackers. Go to https://privacybadger.org to learn more.
  5. Site search is configured to only search Bookmarks, History and open tabs. Google Gemini has been disabled.
  6. Adblock Plus easylist and easyprivacy subscriptions have been added.

More detailed setup instructions are available on the wiki:     https://github.com/cloudcoroner/cromite_ubuntu/wiki
