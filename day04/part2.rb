#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


rows = input.split("\n").map(&:chars)

sum = 0

rows.each_with_index do |row, i|
    row.each_with_index do |cell, j|
        next if cell != "A"
        next if i == 0 || j == 0 || i == rows.size-1 || j == row.size-1
        
        if ((rows[i-1][j-1] == "M" && rows[i+1][j+1] == "S") || (rows[i-1][j-1] == "S" && rows[i+1][j+1] == "M")) &&
            ((rows[i-1][j+1] == "M" && rows[i+1][j-1] == "S") || (rows[i-1][j+1] == "S" && rows[i+1][j-1] == "M"))
            sum += 1
        end
    end
end

puts sum