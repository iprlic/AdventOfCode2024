#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path).split("\n\n").map { |line| line.split("\n").map(&:chars) }


keys = input.select { |line| line.first.all?{ |f| f == "." } && line.last.all?{ |f| f == "#" }  }.map { |line| line.first(6).transpose.map { |line| line.count { |l| l == "#"} } }
locks = input.select { |line| line.first.all?{ |f| f == "#" }  && line.last.all?{ |f| f == "." }  }.map { |line| line.last(6).transpose.map { |line| line.count { |l| l == "#"} }  }

cnt = 0

keys.each do |key|
    locks.each do |lock|
        match = true
        key.each_with_index do |line, i|
            if line + lock[i] > 5
                match = false
                break
            end
        end
        
        cnt += 1 if match
    end
end

puts cnt