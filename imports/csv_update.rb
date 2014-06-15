require 'csv'

files = Dir.entries('./tides')

files[2..-1].each do |file|
# files[2..3].each do |file|
  filename = "./tides/#{file}"
  old_csv = CSV.read(filename)
  old_csv.first[3] = "feet"

  CSV.open(filename, 'w') do |new_csv|
    old_csv.each do |row|
      new_csv << row
    end
  end

end
