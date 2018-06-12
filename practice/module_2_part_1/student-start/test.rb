require './assignment.rb'
s = Solution.new

stuff = s.test_method 1280
puts "test method: #{stuff}"
puts "first returned: #{stuff.first}"

stuff = s.groups_faster_than 1280
puts "real method: #{stuff}"
puts "first returned: #{stuff.first}"

