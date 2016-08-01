#!/bin/sh
# Simple Version does not use notifications

command_exists () {
    type "$1" &> /dev/null ;
}

if command_exists pianobar; then
    #Pianobar is fine so we do nothing and continue script
    echo "Pianobar exists: Awesome..."
else 
	if command_exists brew; then
		#Pianobar is not available but brew is so 
		brew install pianobar
	else
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		brew install pianobar
	fi
fi

if command_exists pianobar; then
	#Pianobar is fine so keep going
	echo ""
else
	echo "something went wrong now exiting..."; exit 1;
fi

#cd ~/.config
#mkdir pianobar
#cd pianobar
read -p "Do you have an autostart station ready? (y/N)? " answer
case ${answer:0:1} in
    y|Y )
        echo "Please enter the autostart station you have prepared: "
		read autostart
    ;;
    * )
        echo "It's alright that's cool..."
    ;;
esac
echo "Please enter user name for pandora (For Auto-login): "
read username
echo "Please Enter pandora password (For Auto-Login): "
read password
cat <<EOT >> config
user = ${username}
password = ${password}
autostart_station = ${autostart}
format_nowplaying_song = "[92m%t[0m", by: "[96m%a[0m" on the album: "[93m%l[0m"[91m%r[0m%@%s
format_nowplaying_station = Station "[95m%n[0m" [90m(%i)[0m
format_list_song = %i) %a - [92m%t[0m%r
format_msg_info = [97m(i) [0m%s
format_msg_nowplaying = [36m|>[0m  %s
format_msg_time = [90m#   [97m%s[0m
format_msg_err = [90m/!\[0m %s
format_msg_question = [97m[?][0m %s
format_msg_debug = [90m%s[0m
EOT
