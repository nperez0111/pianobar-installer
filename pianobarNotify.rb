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