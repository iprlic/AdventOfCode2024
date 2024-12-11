#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

input = File.read(file_path)

stones = {}
input.split(" ").each do |stone|
    stones[stone] = 1
end

prev_stones = {'0' => ['1']}

75.times do |i|

    new_stones = {}
    stones.each do |stone, cnt|

        if prev_stones[stone]
            prev_stones[stone].each do |prev_stone|
                if new_stones[prev_stone]
                    new_stones[prev_stone] += cnt
                else
                    new_stones[prev_stone] = cnt
                end
            end 
            next
        end

        if stone.size % 2 == 0
            stone1 = stone[0..stone.size/2-1]
            stone2 = stone[stone.size/2..stone.size].sub(/^0+/,'')
            stone2 = '0' if stone2.nil? || stone2.empty?


            new_stones[stone1] += cnt if new_stones[stone1]
            new_stones[stone1] = cnt if new_stones[stone1].nil?
            new_stones[stone2] += cnt if new_stones[stone2]
            new_stones[stone2] = cnt if new_stones[stone2].nil?


            prev_stones[stone] = [stone1, stone2]
            next
        end

        stone_value = (stone.to_i * 2024).to_s
        new_stones[stone_value] += cnt if new_stones[stone_value]
        new_stones[stone_value] = cnt if new_stones[stone_value].nil?
        prev_stones[stone] = [stone_value]
    end

    stones = new_stones
end

puts stones.values.sum