#!/usr/bin/env ruby

missings = ENV['PATH'].split(':').filter { !File.directory? _1 }.sort

if missings.count.zero?
  puts "All directories on $PATH exist. Good job!"
else
  puts missings
  puts "\nFound #{missings.count} non-existent dirs on $PATH!"
end
