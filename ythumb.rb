#!/usr/bin/env ruby

require 'uri'
require 'cgi'
require 'pathname'

if ARGV.length != 1
  warn 'invalid number of arguments'
  usage
  exit 1
end

def usage
  puts 'Returns the thumbnail of the given youtube video url.'
  puts ''
  puts "\t #{File.basename $PROGRAM_NAME} [URL]"
end

def url_from_id(id)
  [
    "https://img.youtube.com/vi/#{id}/maxresdefault.jpg",
    "https://img.youtube.com/vi/#{id}/sddefault.jpg",
    "https://img.youtube.com/vi/#{id}/hqdefault.jpg"
  ]
end

def url_id(rawurl)
  url = URI.parse(rawurl)
  case rawurl
  when /youtube.com\/watch/
    CGI.parse(url.query)['v'][0]
  when /youtu.be/
    url.path[1..]
  else
    warn 'invalid url'
    usage
    exit 1
  end
end

puts url_from_id(url_id(ARGV[0]))
