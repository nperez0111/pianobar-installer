#!/bin/sh
# Advanced Version does use notifications

command_exists () {
    type "$1" &> /dev/null ;
}

wget https://gist.githubusercontent.com/nperez0111/2ad48cf5bee2f10a8478/raw/19fd8ec20bb11a43221fc8e83d034529e29e8333/pianobar-Mac-Simple.sh
chmod +x pianobar-Mac-Simple.sh
./pianobar-Mac-Simple.sh

if command_exists terminal-notifier; then
    #Pianobar is fine so we do nothing and continue script
    echo "Terminal-Notifier exists. Awesome..."
else 
	brew install terminal-notifier
fi

cd ~/.config/pianobar
touch pianobarNotify.rb
cat <<EOT >> pianobarNotify.rb
#!/usr/bin/ruby

trigger = ARGV.shift

songinfo = {}
STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}

if trigger == 'songstart'
	`terminal-notifier -title "#{songinfo['title']}" -subtitle "By:#{songinfo['artist']}" -group "Pianobar" -appIcon "~/.config/pianobar/PandoraIco.png" -activate "com.googlecode.iterm2" -message "Album:#{songinfo['album']} on #{songinfo['stationName']}" -contentImage "#{songinfo['coverArt']}"`
elsif trigger == 'userlogin'
	`terminal-notifier -title "Pianobar Started" -message "Welcome back" -group "Pianobar" -appIcon "~/.config/pianobar/PandoraIco.png"`
elsif trigger == 'stationfetchplaylist'
	`terminal-notifier -title "Fetching songs..." -message "Changing stations" -group "Pianobar" -appIcon "~/.config/pianobar/PandoraIco.png"`
end
EOT
defaults write /usr/local/Cellar/terminal-notifier/1.6.3/terminal-notifier.app/Contents/Info.plist NSAppTransportSecurity '<dict> <key>NSAllowsArbitraryLoads</key> <true/> </dict>'
