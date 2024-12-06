#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)

def safe(l)
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

    return !failed
end

def eliminate_one(o)
    result = []
    o.each_with_index do |_, i|
      result << o[0...i] + o[i+1..-1]
    end
    result
end

s = 0

input.split("\n").map { |l| l.split(" ").map(&:to_i) }.each do |l|
    if safe(l)
        s += 1
    else
       subs = eliminate_one(l)
         subs.each do |sub|
            if safe(sub)
                s += 1
                break
            end
        end
    end

end

puts s