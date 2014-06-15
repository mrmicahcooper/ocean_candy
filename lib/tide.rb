require 'ostruct'

class Tide < OpenStruct
  def date
    Time.parse(super)
  end
end
