#!/usr/bin/ruby

trigger = ARGV.shift

if trigger == 'songstart'
  songinfo = {}

  STDIN.each_line { |line| songinfo.store(*line.chomp.split('=', 2))}
  `terminal-notifier -title "Pianobar" -subtitle "Another Great Song coming up..." -group "Pianobar" -contentImage "/Users/nickthesick/Documents/PandoraIco.png" -activate "com.googlecode.iterm2" -message "Now Playing" -m "#{songinfo['title']}\nby #{songinfo['artist']}"`
end