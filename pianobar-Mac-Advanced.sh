#!/bin/sh
# Advanced Version does use notifications
bid() {
	local shortname location

	# combine all args as regex
	# (and remove ".app" from the end if it exists due to autocomplete)
	shortname=$(echo "${@%%.app}"|sed 's/ /.*/g')
	# if the file is a full match in apps folder, roll with it
	if [ -d "/Applications/$shortname.app" ]; then
		location="/Applications/$shortname.app"
	else # otherwise, start searching
		location=$(mdfind -onlyin /Applications -onlyin ~/Applications -onlyin /Developer/Applications 'kMDItemKind==Application'|awk -F '/' -v re="$shortname" 'tolower($NF) ~ re {print $0}'|head -n1)
	fi
	# No results? Die.
	[[ -z $location || $location = "" ]] && echo "$1 not found, I quit" && return
	# Otherwise, find the bundleid using spotlight metadata
	bundleid=$(mdls -name kMDItemCFBundleIdentifier -r "$location")
	# return the result or an error message
	[[ -z $bundleid || $bundleid = "" ]] && echo "Error getting bundle ID for \"$@\"" || echo "$location: $bundleid"
}

command_exists () {
    type "$1" &> /dev/null ;
}

wget https://raw.githubusercontent.com/nperez0111/pianobar-installer/master/pianobar-Mac-Simple.sh
chmod +x pianobar-Mac-Simple.sh
./pianobar-Mac-Simple.sh

if command_exists terminal-notifier; then
    #Pianobar is fine so we do nothing and continue script
    echo "Terminal-Notifier exists. Awesome..."

else 

	echo "Installing Terminal-Notifier"
	brew install terminal-notifier
	echo "Terminal-Notifier has successfully Installed"

fi

cd ~/.config/pianobar
rm pianobarNotify.rb -f

#Handle Images
read -p "Do you want a specific image to show in each notification? (y/N)" answer
case ${answer:0:1} in
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
read -p "Do you want pianobar to show on click of notification (y/N)" answer
case ${answer:0:1} in
    "y"|"Y")
        echo "1)iTerm2"
        echo "2)Terminal"
        echo "3)HyperTerm"
        read -p "Is your Terminal shown in this list? (y/N)" answer
		case ${answer:0:1} in
		    "y"|"Y")
				#terminal is in list ask index
		        echo "Please enter the number of the terminal in the list above: "
				read num
				case ${num:01} in
					"1")
						termApp="com.googlecode.iterm2"
					;;
					"2")
						termApp="com.apple.terminal"
					;;
					"3")
						termApp="co.zeit.hyperterm"
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

				termApp="$(bid termProgram)"

				echo "The Bundle ID we found was:${termApp}"
		        
		    ;;
		esac
		read imgFilePath
		showTerm="-activate \"${termApp}\""
    ;;
    *)
        showTerm=""
    ;;
esac

#Actually write file
cat <<EOT >> pianobarNotify.rb
#!/usr/bin/ruby

trigger = ARGV.shift

if trigger == 'songstart'
  songinfo = {}

  STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}

  `terminal-notifier -title "Pianobar" -subtitle "#{songinfo['title']} by #{songinfo['artist']}" -group "Pianobar" ${image} ${showTerm} -message "album: '#{songinfo['album']}' on #{songinfo['stationName']}" -contentImage "#{songinfo['coverArt']}"`

elsif trigger == 'userlogin'

	`terminal-notifier -title "Pianobar Started" -message "Welcome back" -group "Pianobar" ${image}`

elsif trigger == 'stationfetchplaylist'

	`terminal-notifier -title "Fetching songs..." -message "Changing stations" -group "Pianobar" ${image}`
	
end
EOT
defaults write /usr/local/Cellar/terminal-notifier/1.6.3/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'
