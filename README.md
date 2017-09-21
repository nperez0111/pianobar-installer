# Pianobar Installer Scripts and Guide
======================================
![Simple Install of Pianobar](SimpleInstall.gif)
![Advanced Install of Pianobar](AdvancedInstall.gif)

These Scripts Help Install [Pianobar](http://) (A Command Line Pandora Player) onto Windows and Mac OS X. For Mac I've written a bash script that can be copied and pasted into a terminal emulator of your choice to install pianobar and fix some settings. 

# The difference between the two installers

## What the Simple Install does
* Pianobar on mac is not so simple of an install.
* This is a full install that can be performed on a mac with absolutely no prior apps or commands.
* This fixes non-obvious errors in the install of pianobar that have to do with the audio.
* Fully sets up the config file of pianobar so that you don't have to mess with its config file.
* Sets up auto login to pianobar so that you don't have to enter the username and password every time you use it.
* Sets up auto start station to automatically specify a station to start pianobar with.

## What the Advanced Install does (All options are optional)
  * Does everything that the simple installer does. 
  * Adds Notifications on changing a song
  	* Notification looks like this:
  	* ![Notification Image](Notification.png)
  * Adds Shortcuts to (Play/Pause, Next, Select Station, Like, Dislike, Ban, Quit)
  	* These can be accessed in any app which supports services, the keyboard shortcuts themselves are specified by you.

# Mac Install Simple (Shell Script)

This will install pianobar and setup autologin.

`bash <(curl -s https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Simple.sh)`

# Mac Install Advanced (Shell Script) - Adds Notifications

This will install pianobar, setup autologin and add notifications.

`bash <(curl -s https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Advanced.sh)`

# Windows Install 

Make a file called `pianobar.cfg` in the same directory that pianobar.exe is in and copy these contents in. Changing as you please.

# Setting Up Auto Start Station

1. If you want a certain station to start every time you open pianobar open up the pandora web player( pandora.com ). 
2. Select a station you want to be as the auto starting station. 
3. Copy the URL it will look something like this `http://www.pandora.com/station/play/3195239640586748282` take the mess of numbers at the end and copy that into the pianobar config and that station will now always start with pianobar.

# Mac Install (Manually)
`cd ~/.config && mkdir pianobar && cd pianobar && touch config && subl config`

What this does is: 
 1. cd into .config folder
 2. make a directory called pianobar if it does not exist and cd into it
 3. makes a file called config which stores the configuration 
 4. uses sublime text to open the config file subl can be replaced with open to use any editor you like
 5. Copy and paste the contents of `pianobar.cfg` into the file and save. Change as you please.
 
Take out width and height lines as they dont apply in Mac OS

# Extended Mac Install (Manually)

This section will add notifications to pianobar that come up through notification center. Letting you know when the next song is playing.

`touch pianobarNotify.rb && subl pianobarNotify.rb && defaults write /usr/local/Cellar/terminal-notifier/1.6.3/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'`

What this does:
 1. Create a file called `pianobarNotify.rb`.
 2. Sublime Text to edit the new file.
 3. All the crazy stuff at the end is just to change a setting to allow terminal notifications to include the cover art photo. If not run it will simply not show the cover art.
What you need to do: 
 1. Paste in the contents of `pianobarNotify.rb` into your sublime text window close and save
 2. open the config file you made prior (Located as:`~/.config/pianobar/config` or reopen it simply with `subl ~/.config/pianobar/config`)
 3. Add this Line `event_command = ~/.config/pianobar/pianobarNotify.rb`
 4. If you want a custom pandora icon change `~/.config/pianobar/PandoraIco.png` to be the location of your icon in every occurence in the `pianobarNotify.rb` file
