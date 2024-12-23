#!/usr/bin/env ruby3.0

# Description:
# - helper to select and change to a resolution that respects current (? aspect_ratio

aspect_ratio = '16/9' # 1.33 1.25 1.5 1.8

current = `xrandr`.scan(/current (\d+) x (\d+)/).flatten.join('x')
puts "Current: #{current}"

dimensions =
  `xrandr`
    .split('HDMI-1') # assumes is the last one
    .last
    .lines[1..]
    .map { |line| line.scan(/([0-9]+)x([0-9]+)/).flatten }
    .reject { |(w,h)| current == "#{w}x#{h}" }
    .select { |(w,h)| Rational(aspect_ratio) == Rational(w,h) }
    .map { |(w,h)| "#{w}x#{h}" }

selected = `gum choose #{dimensions.join(' ')}`
abort 'Nothing selected!' if selected.empty?

system("xrandr --output eDP-1 --off --output HDMI-1 --mode #{selected} --rotation normal")
