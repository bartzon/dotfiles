# frozen_string_literal: true

class Filter
  attr_reader :filter, :description

  def initialize(filter, description = '')
    @filter = filter
    @description = description
  end

  def call(m)
    filter.call(m)
  end

  def to_s
    description
  end
end
