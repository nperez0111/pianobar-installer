#!/usr/bin/ruby

trigger = ARGV.shift

if trigger == 'songstart'
  songinfo = {}

  STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}
  `terminal-notifier -title "Pianobar" -subtitle "#{songinfo['title']} by #{songinfo['artist']}" -group "Pianobar" -appIcon "/Users/nickthesick/Documents/PandoraIco.png" -activate "com.googlecode.iterm2" -message "on the album: '#{songinfo['album']}' on #{songinfo['stationName']}" -contentImage "#{songinfo['coverArt']}"`
end