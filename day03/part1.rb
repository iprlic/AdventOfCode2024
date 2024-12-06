#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

puts input.scan(/mul\((\d{1,3}),(\d{1,3})\)/).map { |l, r| l.to_i * r.to_i }.sum
