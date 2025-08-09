#!/usr/bin/env ruby

require 'shellwords'

abort('Invalid number of arguments.') if ARGV.length <= 2
abort('File does not exits.') unless File.exist?(ARGV[0])

path = File.expand_path(ARGV[0])
safepath = path.shellescape
cmd = ARGV[1..].map(&:shellescape).join(' ')

puts "[*] Running #{cmd}"
if File.owned? path
  system("#{cmd} #{safepath}", exception: true)
elsif system('sudo -n true')
  system("sudo #{cmd} #{safepath}", exception: true)
else
  system("zenity --password | sudo -S #{cmd} #{safepath}", exception: true)
end
puts '[*] Done!'
