#!/usr/bin/env ruby

# frozen_string_literal: true

require 'json'

output = []

data = JSON.parse(`system_profiler -json SPBluetoothDataType`)
devices = data['SPBluetoothDataType'][0]['device_connected'] || []
found = devices.find { |hash| hash.keys.first =~ /AirPods/ }
airpods = found && found.values[0]

if airpods
  left = airpods['device_batteryLevelLeft'].to_i
  right = airpods['device_batteryLevelLeft'].to_i
  avg = ((left + right) / 2.0).to_i

  output << "C:#{airpods['device_batteryLevelCase']}" if airpods['device_batteryLevelCase']

  output << "A:#{avg}%"
end

def battery_status(type)
  data = `pmset -g accps | grep "#{type}" | sed '1q'`
  return {} if data == ''

  num = data.match(/\d+%;/)[0].to_s.gsub(/%;/, '')
  charging = (data =~ / charging/)
  { percentage: num.to_i, charging: }
end

COLORS = {
  30..50 => '#[fg=#A3BE8C]',
  10..30 => '#[fg=#d08770]',
  0..10 => '#[fg=#bf616a]'
}.freeze

def format_status(key, data)
  return unless data[:percentage]

  color = COLORS[data[:percentage].to_i]
  charging = data[:charging] ? '🔋' : ''
  "#{color}#{key}:#{charging}#{data[:percentage]}%"
end

phone_info = %x(ideviceinfo -u `idevice_id --list` --domain com.apple.mobile.battery).split("\n")
if phone_info
  phone_bat = phone_info.find { |str| str =~ /BatteryCurrentCapacity/ }
  if phone_bat
    pct = phone_bat.split(':')[1].strip.to_i

    charging = phone_info.any? { |str| str =~ /BatteryIsCharging: true/ }
    output << format_status('iP', { percentage: pct, charging: })
  end
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
