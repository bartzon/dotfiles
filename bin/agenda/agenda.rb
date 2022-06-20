#!/usr/bin/ruby

require 'rubygems'
require 'time'
require 'dotiw'

require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

require './meeting'
require './meetings_formatter'

Time.zone = 'Amsterdam'

TITLE_LENGTH = 50
FILTERS = [
  -> (m) { m.ended? },
  -> (m) { m.all_day? },
  -> (m) { m.title.include?('OOO') },
  -> (m) { m.title =~ /out of office/i },
  -> (m) { m.title =~ /On Call/ },
  -> (m) { m.starts_in > 8.hours }
]
FILE = '/tmp/next_calendar_meeting'
PARSED = '/tmp/next_calendar_meeting_parsed'

def fetch
  data = `gcalendar`.force_encoding('UTF-8').delete("^\u{0000}-\u{007F}").split("\n")
  lines = data.join("\n")
  File.open(FILE, 'w') { |fp| fp.write(lines) }
end

def parse
  fetch unless File.exist?(FILE)

  meetings = []

  lines = File.read(FILE).split("\n")
  lines.each do |line|
    m = Meeting.new(line)
    next if FILTERS.any? { |f| f.call(m) }
    meetings << m
  end

  str = MeetingsFormatter.new(meetings).format

  File.open(PARSED, 'w') { |fp| fp.write(str) }
end

if ARGV[0] == 'fetch'
  fetch
else
  parse
end
