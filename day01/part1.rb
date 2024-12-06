#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


l, r = input.split("\n").map { |l| l.split("   ") }.transpose.map { |l| l.map(&:to_i).sort }
puts l.zip(r).map { |l, r| (r - l).abs }.sum
