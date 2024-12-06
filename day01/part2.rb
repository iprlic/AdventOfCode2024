#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


l, r = input.split("\n").map { |l| l.split("   ") }.transpose.map { |l| l.map(&:to_i) }

puts l.reduce(0) { |acc, l| acc + (l * r.reduce(0) { |acc, r| acc + (r==l && 1 || 0) }) }
