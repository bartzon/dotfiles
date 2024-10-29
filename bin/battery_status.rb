#!/usr/bin/env ruby

require 'json'

output = []

def battery_status(type)
  data = `pmset -g accps | sed 's/[^\x20-\x7E]//g' | grep "#{type}"`
  num = data.match(/\d+%;/)[0].to_s.gsub(/%;/, '')
  charging = if data =~ /not charging present: true/
               false
             elsif data =~ /discharging present/
               false
             else
               true
             end
  { percentage: num.to_i, charging: }
end

def format_status(key, data)
  color = case data[:percentage].to_i
          when 30..50
            '#[fg=#A3BE8C,bg=black]'
          when 10..30
            '#[fg=#d08770,bg=black]'
          when 0..10
            '#[fg=#bf616a,bg=black]'
          else
            '#[fg=white,bg=black]'
          end
  charging = data[:charging] ? '🔋' : ''
  "#{color}#{key}:#{charging}#{data[:percentage]}%"
end

mapping = { 'B' => 'InternalBattery', 'M' => 'Mouse', 'K' => 'Keyboard' }

mapping.each do |key, attr|
  bat_data = battery_status(attr)
  output << format_status(key, bat_data)
end

output.compact!
return unless output.any?

output = output.join(' | ')
output += '#[fg=white,bg=black]'

puts output
