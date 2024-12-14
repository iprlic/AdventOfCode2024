#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map{ |l| l.scan(/p=(\d*),(\d*) v=(-?\d*),(-?\d*)/).map { |a, b, c, d| {p: { x: a.to_i, y: b.to_i}, v: { x: c.to_i, y: d.to_i} } } }.flatten

maxX = 101
maxY = 103

maxX -= 1
maxY -= 1

quadrants = [0,0,0,0]

100.times do |i|
    input.each do |r|
        r[:p][:x] += r[:v][:x]
        
        r[:p][:x] = r[:p][:x]-maxX-1 if r[:p][:x] > maxX
        r[:p][:x] = r[:p][:x]+maxX+1 if r[:p][:x] < 0

        r[:p][:y] += r[:v][:y]

        r[:p][:y] = r[:p][:y]-maxY-1 if r[:p][:y] > maxY
        r[:p][:y] = r[:p][:y]+maxY+1 if r[:p][:y] < 0

        if i == 99
            if r[:p][:x] < maxX/2 && r[:p][:y] < maxY/2
                quadrants[0] += 1
            elsif r[:p][:x] > maxX/2 && r[:p][:y] < maxY/2
                quadrants[1] += 1
            elsif r[:p][:x] < maxX/2 && r[:p][:y] > maxY/2
                quadrants[2] += 1
            elsif r[:p][:x] > maxX/2 && r[:p][:y] > maxY/2
                quadrants[3] += 1
            end
        end
    end

end

puts quadrants.reduce(:*)