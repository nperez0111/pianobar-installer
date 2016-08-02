#!/bin/sh
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
        echo "Simple Installer not running..."
    ;;
    *)
        bash <(curl -s https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Simple.sh)
    ;;
esac


if command_exists terminal-notifier; then
    #Pianobar is fine so we do nothing and continue script
    echo "Terminal-Notifier exists. Awesome..."

else 

	echo "Installing Terminal-Notifier"
	brew update >/dev/null
	brew install terminal-notifier >/dev/null
	echo "Terminal-Notifier has successfully Installed"

fi

#Handle Images
read -p "Do you want a specific image to show in each notification? (y/N)" answe
case ${answe:0:1} in
    "y"|"Y")
        echo "Please enter the file path of the image you would like as the icon of each notification: "
		read imgFilePath
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
		        echo "Please enter the number of the terminal in the list above: "
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
		        echo "Please enter the name of the terminal program you use."
				read termProgram

				termApp="$(osascript -e "id of app \"${termProgram}\"")"

				echo "The Bundle ID we found was:${termApp}"
		        
		    ;;
		esac
		showTerm="-activate \"${termApp}\""
    ;;
    *)
        showTerm=""
        echo "No action will be performed on click of notification..."
    ;;
esac

cd ~/.config/pianobar

rmv pianobarNotify.rb
#Actually write file
cat <<EOT >> pianobarNotify.rb
#!/usr/bin/ruby

trigger = ARGV.shift

if trigger == 'songstart'
  songinfo = {}

  STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}

  \`terminal-notifier -title "Pianobar" -subtitle "#{songinfo['title']} by #{songinfo['artist']}" -group "Pianobar" ${image} ${showTerm} -message "album: '#{songinfo['album']}' on #{songinfo['stationName']}" -contentImage "#{songinfo['coverArt']}"\`

elsif trigger == 'userlogin'

	\`terminal-notifier -title "Pianobar Started" -message "Welcome back" -group "Pianobar" ${image}\`

elsif trigger == 'stationfetchplaylist'

	\`terminal-notifier -title "Fetching songs..." -message "Changing stations" -group "Pianobar" ${image}\`

end
EOT
echo "Wrote Notification Script."

chmod +x pianobarNotify.rb
cat <<EOT >> config
event_command = ~/.config/pianobar/pianobarNotify.rb
EOT

echo "Writing setting to terminal-notifier"
defaults write /usr/local/Cellar/terminal-notifier/1.6.3/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'

echo "Success..."
read -p "Do you want to run pianobar now? (Y/n)" answe
case ${answe:0:1} in
    "n"|"N")
        exit 0;
    ;;
    *)
        echo "Pianobar Starting...."
        echo ""
        echo ""
        pianobar
    ;;
esac
exit 0;