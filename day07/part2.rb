#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

equations = input.split("\n").map { |line| [line.split(": ")[0].to_i, line.split(": ")[1].split(" ").map(&:to_i)] }

sum = 0

equations.each do |equation|
    result = equation[0]
    possible_results = []
    equation[1].each do |num|
        found = false
        if possible_results.empty?
            possible_results << num
        else
            new_possible_results = []
            possible_results.each do |res|
                add = res + num
                mul = res * num
                concat = "#{res}#{num}".to_i
                if add == result || mul == result || concat == result
                    sum += result
                    found = true
                    break
                end
                new_possible_results << add if add <= result
                new_possible_results << mul if mul <= result
                new_possible_results << concat if concat <= result
            end
            break if found
            possible_results = new_possible_results
        end
    end
end

puts sum