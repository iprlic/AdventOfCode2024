#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

antenas = {}
max_x = 0
max_y = 0

input.split("\n").map(&:chars).each_with_index do |line, i| 
    line.each_with_index do |char, j|
        max_x = j if j > max_x
        next if char == '.'

        if antenas[char].nil?
            antenas[char] = [[i, j]] 
        else
            antenas[char] << [i, j]
        end
       
    end
    max_y = i if i > max_y
end

antinodes = {}
antenas.each do |key, value|
    value.combination(2) do |f, s|
        next if f == s
        x1 = f[0]
        y1 = f[1]

        x2 = s[0]
        y2 = s[1]

        antinodes[[x1, y1]] = true
        antinodes[[x2, y2]] = true

        dx = x2 - x1
        dy = y2 - y1

        loop do
            ant1 = false
            ant2 = false

            sx1 = x1-dx
            sy1 = y1-dy
    
            sx2 = x2+dx
            sy2 = y2+dy
    
            ant1 = true if sx1 >= 0 && sx1 <= max_x && sy1 >= 0 && sy1 <= max_y 
            ant2 = true if sx2 >= 0 && sx2 <= max_x && sy2 >= 0 && sy2 <= max_y 


            antinodes[[sx1, sy1]] = true if ant1
            antinodes[[sx2, sy2]] = true if ant2
            
            break if !ant1 && !ant2

            x1 = sx1
            y1 = sy1

            x2 = sx2
            y2 = sy2
            
  
        end
    end

end

p antinodes.size