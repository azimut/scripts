#!/usr/bin/env ruby

warn '[*] Starting...'

missings = ENV['PATH'].split(':').reject { File.directory? _1 }.sort

if missings.empty?
  warn '[*] All directories on $PATH exist. Good job!'
else
  warn "[*] Found #{missings.count} non-existent dirs on $PATH!"
  puts missings
end
