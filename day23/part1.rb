#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n").map{ |line| line.split('-') }

temp_groups = []
groups = []

(input.size).times do |i|

    x1 = input[i][0]
    x2 = input[i][1]

    (input.size).times do |j|
        next if i == j
        y1 = input[j][0]
        y2 = input[j][1]

        if (x1 == x2 || x1 == y2 || y1 == x2 || y1 == y2)
            temp_groups << [input[i], input[j]]
        end
    end
        
end



temp_groups = temp_groups.map { |group| group.sort }

temp_groups.each do |group|
    (input.size).times do |i|
        x1 = input[i][0]
        x2 = input[i][1]

        non_overlapping = group.flatten(1).tally.select { |k, v| v == 1 }.keys
        c1 = non_overlapping[0]
        c2 = non_overlapping[1]


        if (x1 == c1 && x2 == c2) || (x1 == c2 && x2 == c1)
            new_group = group.concat([input[i]])
            groups << new_group
        end
    end
end

groups = groups.map { |group| group.flatten.uniq.sort }.uniq

puts groups.select { |group| group.any? { |comp| comp[0] == "t"} }.size