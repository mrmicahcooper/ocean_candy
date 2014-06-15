require 'ostruct'

class Tide < OpenStruct

  def date
    Time.parse(super)
  end

  def for_json
    {
      date_time: date_time,
      feet: feet,
      tide: tide
    }

  end

  def date_time
    require 'pry'; binding.pry
  end

end
