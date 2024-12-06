#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

s = 0

input.split("\n").map { |l| l.split(" ").map(&:to_i) }.each do |l|
    raising = -1
    failed = false
    l.each_cons(2) do |a, b|
        failed = true if (b-a).abs > 3
        if a > b && (raising == 0 || raising == -1)
            raising = 0
        elsif a < b && (raising == 1 || raising == -1)
            raising = 1
        else
            failed = true
        end
        break if failed
    end
    s += 1 if !failed
end

puts s