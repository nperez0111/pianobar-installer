# Mac Install Simple (Shell Script)

This will install pianobar and setup autologin.

`wget https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Advanced.sh && chmod +x pianobar-Mac-Simple.sh && ./pianobar-Mac-Simple.sh`

# Mac Install Advanced (Shell Script)

This will install pianobar, setup autologin and add notifications.

`wget https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Advanced.sh && chmod +x pianobar-Mac-Advanced.sh && ./pianobar-Mac-Advanced.sh`

# Mac Install (Manually)
`cd ~/.config && mkdir pianobar && cd pianobar && touch config && subl config`

What this does is: 
 1. cd into .config folder
 2. make a directory called pianobar if it does not exist and cd into it
 3. makes a file called config which stores the configuration 
 4. uses sublime text to open the config file subl can be replaced with open to use any editor you like
 5. Copy and paste the contents below into the file and save. Change as you please.
 
Take out width and height lines as they dont apply in Mac OS

# Extended Mac Install (Manually)

This section will add notifications to pianobar that come up through notification center. Letting you know when the next song is playing.

`touch pianobarNotify.rb && subl pianobarNotify.rb && defaults write /usr/local/Cellar/terminal-notifier/1.6.3/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'`

What this does:
 1. Create a file called pianobarNotify.
 2. Sublime Text to edit the new file.
 3. All the crazy stuff at the end is just to change a setting to allow terminal notifications to include the cover art photo. If not run it will simply not show the cover art.
What you need to do: 
 1. Paste in the contents of pianobarNotify.rb into your sublime text window close and save
 2. open the config file you made prior (Located as:`~/.config/pianobar/config` or reopen it simply with `subl ~/.config/pianobar/config`)
 3. Add this Line `event_command = ~/.config/pianobar/pianobarNotify.rb`
 4. If you want a custom pandora icon change `~/.config/pianobar/PandoraIco.png` to be the location of your icon in every occurence in the `pianobarNotify.rb` file

# Windows Install 

Make a file called pianobar.cfg in the same directory that pianobar.exe is in and copy these contents in. Changing as you please.

# Some Config Stuff

1. If you want a certain station to start every time you open pianobar open up the pandora web player( pandora.com ). 
2. Select a station you want to be as the auto starting station. 
3. Copy the URL it will look something like this `http://www.pandora.com/station/play/3195239640586748282` take the mess of numbers at the end and copy that into the pianobar config and that station will now always start with pianobar.