class Meeting
  attr_reader :starts_at, :ends_at, :title

  def initialize(line)
    timestamps, title = line.split("\t")
    @starts_at, @ends_at = timestamps.split(' - ').map { |t| parse(t) }

    @title = title.to_s.strip
    @title = @title[0..TITLE_LENGTH] + "…" if @title.length > TITLE_LENGTH
  end

  def parse(timestamp)
    date, hh, mm = timestamp.split(':')
    Time.zone.parse("#{date} #{hh}:#{mm}:00")
  rescue ArgumentError
    100.days.ago
  end

  def starts_in
    p (starts_at - Time.zone.now)
    (starts_at - Time.zone.now).hours
  end

  def all_day?
    starts_at.hour == 0 && ends_at.hour == 0
  end

  def ended?
    return false unless ends_at

    ends_at < Time.now
  end

  def since_started
    Time.zone.now - starts_at
  end

  def duration
    ends_at - starts_at
  end

  def time_left
    duration - since_started
  end

  def percentage
    (since_started / duration) * 100.0
  end

  def to_s
    "<#{@title} #{@starts_at}:#{@ends_at}>"
  end
end
