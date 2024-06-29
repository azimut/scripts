#!/usr/bin/env ruby

missings = ENV['PATH'].split(':').reject { File.directory? _1 }.sort

if missings.empty?
  puts 'All directories on $PATH exist. Good job!'
else
  puts missings
  puts "\nFound #{missings.count} non-existent dirs on $PATH!"
end
