#!/usr/bin/env ruby

require 'shellwords'

abort('Wrong number of arguments.') unless ARGV.length == 1
abort('File does not exits.') unless File.exist?(ARGV[0])
abort('Argument is not a file.') unless File.file?(ARGV[0])

path = File.expand_path(ARGV[0])

puts "[*] Deleting #{path}"
if File.owned? path
  system("rm -vf #{path.shellescape}")
else
  system("pkexec rm -vf #{path.shellescape}")
end
puts '[*] Done!'
