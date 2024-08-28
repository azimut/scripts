require 'net/http'
require 'uri'
require 'json'

def usage
  puts %{
Returns a WaybackMachine snapshot ULR for the URL provided.

Usage:
    #{__FILE__} <URL> [LATEST]

Options:
  <URL>    the url to lookup
  LATEST   flag, if present returns latest snapshot url

Uses the WaybackMachine JSON API (https://archive.org/help/wayback_api.php)
}
end

def query_url(url, is_latest)
  parsed = URI(url)
  unencoded = parsed.host + parsed.path
  encoded = URI.encode_www_form_component(unencoded)
  latest = is_latest ? '&timestamp=19960101' : ''
  "http://archive.org/wayback/available?url=#{encoded + latest}"
end

def print_content(json_content)
  abort 'Empty response :(' if json_content.empty?
  snapshots = json_content['archived_snapshots']
  abort 'No snapshots found :(' unless snapshots.key?('closest')
  puts snapshots['closest']['status']
  puts snapshots['closest']['url']
end

def wayback_url(url, is_latest)
  res = Net::HTTP.get_response(URI(query_url(url, is_latest)))
  case res.code
  when '200'
    print_content(JSON.parse(res.body))
  else
    abort "Bad response code from WaybackMachine: #{res.code}"
  end
end

puts wayback_url('https://www.analogictips.com/analog-computation-part-1-what-and-why/', false)
