# frozen_string_literal: true

require 'dotiw'

class MeetingsFormatter
  def initialize(meetings)
    @meetings = meetings
  end

  def format
    return 'No meetings' unless @meetings.any?

    m = @meetings[0]
    n = @meetings[1]

    if m.percentage.negative?
      upcoming(m)
    elsif m.percentage > 75
      upcoming(n) if n
    else
      started(m)
    end
  end

  def upcoming(m)
    "#{m.title} in #{format_ts m.starts_at}"
  end

  def started(m)
    "#{m.title} #{format_ts Time.zone.now + m.time_left} left"
  end

  def format_ts(ts)
    distance_of_time_in_words(Time.zone.now, ts, false)
  end
end
