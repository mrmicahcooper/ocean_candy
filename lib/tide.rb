require 'ostruct'

class Tide < OpenStruct

  def for_json
    {
      time: time.to_s,
      feet: feet,
      tide: tide
    }
  end

  def is_on_date?(date)
    date.year  == time.year &&
    date.month == time.month &&
    date.day   == time.day
  end

  def time
    @time ||= Time.parse(super)
  end
end
