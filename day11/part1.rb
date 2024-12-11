#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path)

stones = input.split(" ")

25.times do
    new_stones = []
    stones.each do |stone|
        if stone == '0'
            new_stones.push('1')
            next
        end


        if stone.size % 2 == 0
            stone1 = stone[0..stone.size/2-1]
            stone2 = stone[stone.size/2..stone.size].sub(/^0+/,'')
            stone2 = '0' if stone2.nil? || stone2.empty?

            new_stones.push(stone1)
            new_stones.push(stone2)
            next
        end

        new_stones.push((stone.to_i * 2024).to_s)
    end

    stones = new_stones
end


puts stones.size