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
        if possible_results.empty?
            possible_results << num
        else
            new_possible_results = []
            possible_results.each do |result|
                new_possible_results << result + num
                new_possible_results << result * num
            end
            possible_results = new_possible_results
        end
    end

    sum += result if possible_results.include?(result)
end

puts sum