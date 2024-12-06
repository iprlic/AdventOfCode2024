#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


rows = input.split("\n")
cnt = rows.size
rcnt = rows.map(&:size).max
sum = 0

sum += input.scan(/(?=(?:XMAS)|(?:SAMX))/).size
sum += rows.map(&:chars).transpose.map(&:join).join("\n").scan(/(?=(?:XMAS)|(?:SAMX))/).size
sum += rows.each_with_index.map { |l, i| (" " * i + l).ljust(rcnt+cnt).chars }.transpose.map(&:join).join("\n").scan(/(?=(?:XMAS)|(?:SAMX))/).size
sum += rows.each_with_index.map { |l, i| (" " * (cnt-i) + l).ljust(rcnt+cnt).chars }.transpose.map(&:join).join("\n").scan(/(?=(?:XMAS)|(?:SAMX))/).size

puts sum