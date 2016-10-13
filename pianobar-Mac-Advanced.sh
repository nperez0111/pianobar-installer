#!/bin/bash
# Advanced Version does use notifications

command_exists () {
    type "$1" &> /dev/null ;
}

rmv () {
	if [ -f $1 ]
	then 
	    rm -f $1
	fi 
}

read -p "Do you want to run the Simple Installer (This runs the installer for pianobar and fixes warnings and sets up auto login auto start station)? (Y/n)" answer
case ${answer:0:1} in
    "n"|"N")
        echo "Simple Installer will not run..."
    ;;
    *)
        echo "Running Simple Script..."
        bash <(curl -s https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Simple.sh)
        echo "Simple Script Installed Pianobar Successfully."
    ;;
esac


if command_exists terminal-notifier; then
    #Pianobar is fine so we do nothing and continue script
    echo "Terminal-Notifier exists. OK..."

else 

	printf "Terminal-Notifier Installing..."
	brew update >/dev/null
	brew install terminal-notifier >/dev/null
	printf "OK\n"

fi

if command_exists pidof; then
    #Pianobar is fine so we do nothing and continue script
    echo "pidof exists. OK..."

else 

	printf "pidof Installing..."
	brew update >/dev/null
	brew install pidof >/dev/null
	printf "OK\n"

fi

read -p "Do you want to make Notifications Last Longer? (Y/n)?" answer
case ${answer:0:1} in
    "n"|"N")
		defaults delete com.apple.notificationcenterui bannerTime
        echo "Notification Timing Will not be set"

    ;;
    *)
		
		printf "Writing Notification time to 10 seconds..."
		defaults write com.apple.notificationcenterui bannerTime 10
		printf "OK\n"

    ;;
esac

#Handle Images
read -p "Do you want a specific image to show in each notification? (y/N)" answe
case ${answe:0:1} in
    "y"|"Y")
		touch ~/.config/pianobar/PandoraIco.png
		open ~/.config/pianobar/.
        echo "Please save an image to the finder window that just opened with the file name PandoraIco.png."
		imgFilePath="~/.config/pianobar/PandoraIco.png"
		image="-appIcon \"${imgFilePath}\""
    ;;
    *)
        image=""
    ;;
esac

#Handle Terminal
read -p "Do you want pianobar to show on click of notification (Y/n)" answ
case ${answ:0:1} in
    "y"|"Y")
        echo "1)iTerm2"
        echo "2)Terminal"
        echo "3)HyperTerm"
        read -p "Is your Terminal shown in this list? (Y/n)" answer
		case ${answer:0:1} in
		    "y"|"Y")
				#terminal is in list ask index
		        printf "Please enter the number of the terminal in the list above:\n"
				read num
				case ${num:0:1} in
					1)
						termApp="com.googlecode.iterm2"
						echo "iTerm2 Selected"
					;;
					2)
						termApp="com.apple.terminal"
						echo "Terminal Selected"
					;;
					3)
						termApp="co.zeit.hyperterm"
						echo "HyperTerm Selected"
					;;
					*)
						echo "Not valid value. Exiting..."
						exit 1;
					;;
				esac
		    ;;
		    *)
		        #terminal is not shown so must do a prompt for the bundle id
		        printf "Please enter the name of the terminal program you use.\n"
				read termProgram

				termApp="$(osascript -e "id of app \"${termProgram}\"")"

				echo "The Bundle ID we found was:${termApp}"
		        
		    ;;
		esac
		showTerm="-activate \"${termApp}\""
    ;;
    *)
        showTerm="-open \"#{songinfo['detailUrl']}\""
        echo "On click of Notification will redirect you to the album art and songinfo..."
    ;;
esac

cd ~/.config/pianobar

printf "Removing old Notification Script..."
rmv pianobarNotify.rb
printf "OK\n"

#Actually write file
printf "Writng Notification Script..."
cat <<EOT >> pianobarNotify.rb
#!/usr/bin/ruby

trigger = ARGV.shift

if trigger == 'songstart'
  songinfo = {}

  STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}

  \`terminal-notifier -title "#{songinfo['title'].gsub('"', '')}" -subtitle "By: #{songinfo['artist'].gsub('"', '')}" -group "Pianobar" ${image} ${showTerm} -message "Album: #{songinfo['album']} on #{songinfo['stationName']}" -contentImage "#{songinfo['coverArt']}"\`


elsif trigger == 'userlogin'

	\`
	rm "~/.config/pianobar/ctl" 2> /dev/null
	rm "~/.config/pianobar/isplaying" 2> /dev/null
	mkfifo "~/.config/pianobar/ctl" 2> /dev/null
	terminal-notifier -title "Pianobar Started" -message "Welcome back" -group "Pianobar" ${image}
	\`

elsif trigger == 'stationfetchplaylist'

	\`terminal-notifier -title "Fetching songs..." -message "Changing stations" -group "Pianobar" ${image}\`

end
EOT
printf "OK\n"

chmod +x pianobarNotify.rb

printf "Writing to config file..."
cat <<EOT >> config
event_command = ~/.config/pianobar/pianobarNotify.rb
fifo = ~/.config/pianobar/ctl
EOT
printf "OK\n"

printf "Writing setting to terminal-notifier..."
#the whol brew info thing is to get the current version of terminal notifier from brew
defaults write /usr/local/Cellar/terminal-notifier/$(brew info terminal-notifier | grep -i stable | grep -o [0-9].[0-9].[0-9])/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'
printf "OK\n"

echo "Success..."

read -p "Do you want to control Pianobar through shortcuts? (Y/n)" answe
case ${answe:0:1} in
    "n"|"N")
        echo "I thought it was pretty cool..."
    ;;
    *)

        printf "Downloading Workflows..."
        cd ~/Library/Services
        curl -sS https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/WorkFlows.zip > WorkFlows.zip
        printf "OK\n"

        printf "Unzipping..."
        unzip -o WorkFlows.zip &> /dev/null
        printf "OK\n"

        printf "Removing Extra Files..."
        rm WorkFlows.zip
        rm -r __MACOSX
        printf "OK\n\n"

     	open -b com.apple.systempreferences /System/Library/PreferencePanes/Keyboard.prefPane
     	echo ""
     	echo "Setup of keyboard shortcuts complete, mostly will require a reboot."
     	echo "Go to Shortcuts > Services > Scroll to General at the bottom, Select the shortcuts you want for each combination."
     	echo "On Reboot to enable the shortcuts, go to Finder, at the top bar click the word Finder > Services and each shortcut you would like to use, this enables them to be used throughout the system."
		echo "This can be used in any program open if the shortcut conflicts with a program shortcut."
		echo "Simply go to the app name at the top bar > Services and control pianobar through there."
		echo ""
     	echo "Successfully Installed Shortcuts!"
     	
    ;;
esac

read -p "Do you want to run pianobar now? (Y/n)" answe
case ${answe:0:1} in
    "n"|"N")
        exit 0;
    ;;
    *)
        printf "\nPianobar Starting....\n\n"
        pianobar
    ;;
esac
exit 0;