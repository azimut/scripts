#!/usr/bin/env ruby

require 'shellwords'

abort('Invalid number of arguments.') if ARGV.length <= 2
abort('File does not exits.') unless File.exist?(ARGV[0])
abort('Argument is not a file.') unless File.file?(ARGV[0])

path = File.expand_path(ARGV[0])
safepath = path.shellescape
cmd = ARGV[1..].map(&:shellescape).join(" ")

puts "[*] running #{cmd} ON #{path}"
if File.owned? path
  system("#{cmd} #{safepath}", exception: true)
else
  system("pkexec #{cmd} #{safepath}", exception: true)
end
puts '[*] Done!'
