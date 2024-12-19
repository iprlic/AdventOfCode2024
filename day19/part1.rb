#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n")
$cache = {}

def possible_towel(rule, possible_towels)
    return $cache[rule] if $cache.has_key?(rule)
    return 1 if rule == ""
        
    $cache[rule] = possible_towels.reduce(0) { |sum, towel| sum += (rule.start_with?(towel) ? possible_towel(rule[towel.size..-1], possible_towels) : 0) }
    
    return $cache[rule]
end

towels = input[0].split(", ").sort_by { |towel| towel.size }.reverse
rules = input[1].split("\n")

puts rules.map { |rule| possible_towel(rule, towels) }.select { |possible| possible != 0 }.size