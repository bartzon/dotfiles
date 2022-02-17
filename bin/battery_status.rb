#!/usr/bin/env ruby
require 'json'

output = []

data = JSON.parse(`system_profiler -json SPBluetoothDataType`)
devices = data["SPBluetoothDataType"][0]["devices_list"]
airpods = devices.find { |hash| hash.keys.first =~ /AirPods/ }.values[0]

if airpods["device_connected"] == "Yes"
  left = airpods["device_batteryLevelLeft"].to_i
  right = airpods["device_batteryLevelLeft"].to_i
  avg = ((left + right) / 2.0).to_i

  if airpods["device_batteryLevelCase"]
    output << 'C:' + airpods["device_batteryLevelCase"]
  end

  output << "A:#{avg}%"
end

def battery_status(type)
  data = `pmset -g accps | grep "#{type}" | sed '1q'`
  num = data.match(/\d+%;/)[0].gsub(/%;/, '')
  charging = data =~ / charging/
  { percentage: num, charging: charging }
end

def format_status(key, data)
  return if key == 'B' && data[:percentage] == '100'
  if data[:charging]
    "#{key}:🔋#{data[:percentage]}%"
  else
    "#{key}:#{data[:percentage]}%"
  end
end

mapping = { 'B' => 'InternalBattery', 'M' => 'Mouse', 'K' => 'Keyboard' }
mapping.each do |key, attr|
  bat_data = battery_status(attr)
  output << format_status(key, bat_data)
end

output.compact!
puts "#{output.join(" | ")}"
