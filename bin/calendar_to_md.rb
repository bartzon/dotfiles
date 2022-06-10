#!/usr/bin/ruby

require 'time'

JOURNAL_FOLDER = File.expand_path('~/Documents/Logseq/journals/')

FILTERS = [
  -> (m) { m.title =~ /out of office/i },
  -> (m) { m.title =~ /OOO/i },
  -> (m) { m.all_day? },
  -> (m) { !m.today? }
]

class Event
  attr_reader :start, :stop, :title

  def self.all
    parser = EventParser.new
    events = `gcalendar --no-of-days 1`.split("\n").collect { |row| parser.parse(row) }
    filtered = events.reject do |ev|
      FILTERS.any? { |f| f.call(ev) }
    end
  end

  def initialize(start:, stop:, title: '')
    @start = start
    @stop = stop
    @title = title
  end

  def today?
    start.to_date == Date.today && stop.to_date == Date.today
  end

  def all_day?
    stop - start == 1
  end
end

class EventParser
  def parse(data)
    dates, title, _ = data.split("\t")
    t0, t1 = dates.split(' - ')

    Event.new(
      start: str_to_ts(t0),
      stop: str_to_ts(t1),
      title: title.delete("^\u{0000}-\u{007F}")
    )
  end

  def str_to_ts(str)
    date, hh, mm = str.split(':')
    Time.parse("#{date} #{hh}:#{mm}:00")
  end
end

class JournalWriter
  def self.write(events, date: Date.today)
    new(date: date).write(events)
  end

  def initialize(date: Date.today)
    @date = date
  end

  def write(events, folder: JOURNAL_FOLDER)
    file = @date.strftime('%Y_%m_%d') + '.md'
    @filename = File.join(folder, file)

    return if File.exists?(@filename)

    fp = File.open(@filename, 'w')

    events.each do |ev|
      str = event_to_md(ev)
      fp.write(str)
    end
  end

  def event_to_md(ev)
    tag_name = ev.title
      .downcase
      .gsub(/\s+/, ' ')
      .gsub(/[^a-z0-9]/, ' ')
      .strip
      .gsub(/ {2,}/, '-')
      .gsub(/-{2,}/, '-')
      .gsub(' ', '-')

    [
      "## #{ev.title}",
      "\t- ### #{ev.start.strftime('%H:%M')} - #{ev.stop.strftime('%H:%M')}",
      "\t- #shopify #meeting ##{tag_name}",
      "\t- ",
      "- ",
      "- ",
    ].join("\n")
  end
end

JournalWriter.write(Event.all)
