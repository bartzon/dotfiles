#!/usr/bin/ruby
# frozen_string_literal: true

require 'rubygems'
require 'time'
require 'dotiw'

require 'action_view'
include ActionView::Helpers::DateHelper

require './meeting'
require './meetings_formatter'
require './filter'

Time.zone = 'Amsterdam'

TITLE_LENGTH = 50
FILTERS = [
  Filter.new(->(m) { m.title.blank? }, 'No title'),
  Filter.new(->(m) { m.ended? }, 'Ended?'),
  Filter.new(->(m) { m.all_day? }, 'All day?'),
  Filter.new(->(m) { m.title.include?('OOO') }, 'OOO?'),
  Filter.new(->(m) { m.title =~ /out of office/i }, 'out of office?'),
  Filter.new(->(m) { m.title =~ /On Call/ }, 'On Call'),
  Filter.new(->(m) { m.starts_at > 8.hours.from_now }, 'Starts at > 8 hours'),
  Filter.new(->(m) { m.ends_at > 8.hours.from_now }, 'Ends at > 8 hours')
].freeze

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
