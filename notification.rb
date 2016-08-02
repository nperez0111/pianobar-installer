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