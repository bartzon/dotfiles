#!/usr/bin/env ruby
require 'json'

output = []

data = JSON.parse(`system_profiler -json SPBluetoothDataType`)
devices = data["SPBluetoothDataType"][0]["device_connected"] || []
found = devices.find { |hash| hash.keys.first =~ /AirPods/ }
airpods = found && found.values[0]

if airpods
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
  return {} if data == ""
  num = data.match(/\d+%;/)[0].to_s.gsub(/%;/, '')
  charging = data =~ / charging/
  { percentage: num, charging: charging }
end

def format_status(key, data)
  return unless data[:percentage]
  return if key == 'B' && data[:percentage] == '100'
  if data[:charging]
    "#{key}:🔋#{data[:percentage]}%"
  else
    "#{key}:#{data[:percentage]}%"
  end
end

phone_info = %x[ideviceinfo -u `idevice_id --list` --domain com.apple.mobile.battery].split("\n")
if phone_info
  phone_bat = phone_info.find { |str| str =~ /BatteryCurrentCapacity/ }
  if phone_bat
    pct = phone_bat.split(":")[1].strip.to_i

    charging = phone_info.any? { |str| str =~ /BatteryIsCharging: true/ }
    output << format_status("iP", { percentage: pct, charging: charging })
  end
end

mapping = { 'B' => 'InternalBattery', 'M' => 'Mouse', 'K' => 'Keyboard' }
mapping.each do |key, attr|
  bat_data = battery_status(attr)
  output << format_status(key, bat_data)
end

output.compact!
puts "#{output.join(" | ")}" if output.any?
