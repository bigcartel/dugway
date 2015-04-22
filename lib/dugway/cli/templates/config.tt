require 'dugway'

begin
  file = File.read('.dugway.json')
  json = JSON.parse(file)
  options = HashWithIndifferentAccess.new(json)
rescue Exception => e
  puts e
  options = {}
end

run Dugway.application(options)
