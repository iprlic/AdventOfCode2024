#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

yea = true
s = 0

input.scan(/mul(?:\((\d{1,3}),(\d{1,3})\))|(do\(\))|(don't\(\))/).each do |l, r, d, n| 
    yea = true if !d.nil? 
    yea = false if !n.nil? 

    s += (yea && !l.nil?) ? l.to_i * r.to_i : 0 
end

puts s