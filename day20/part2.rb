#!/usr/bin/env ruby
# frozen_string_literal: true
require 'memoist'

file_path = File.expand_path('input.txt', __dir__)

$non_cheaters_scores = {}
$must_improve = 100


class Helper
    extend Memoist

    def manhattan_distance(x1, y1, x2, y2)
        return (x1 - x2).abs + (y1 - y2).abs
    end

    memoize :manhattan_distance

    def move_up(x, y, corrupted, visited, len, score = 10000)
        return nil if y == 0 || corrupted[y - 1][x] == '#'
        return nil if visited.has_key?("#{x},#{y - 1}") && visited["#{x},#{y - 1}"] < score
        return { x: x, y: y - 1 }
    end

    memoize :move_up

    def move_down(x, y, corrupted, visited, len, score = 10000)
        return nil if y == len - 1 || corrupted[y + 1][x] == '#' 
        return nil if visited.has_key?("#{x},#{y + 1}") && visited["#{x},#{y + 1}"] < score
        return { x: x, y: y + 1 }
    end

    memoize :move_down

    def move_left(x, y, corrupted, visited, len, score = 10000)
        return nil if x == 0 || corrupted[y][x - 1] == '#'
        return nil if visited.has_key?("#{x - 1},#{y}") && visited["#{x - 1},#{y}"] < score
        return { x: x - 1, y: y }
    end

    memoize :move_left

    def move_right(x, y, corrupted, visited, len, score = 10000)
        return nil if x == len - 1 || corrupted[y][x + 1] == '#' 
        return nil if visited.has_key?("#{x + 1},#{y}") && visited["#{x + 1},#{y}"] < score
        return { x: x + 1, y: y }
    end

    memoize :move_right

    def teleport(x, y, corrupted, visited, len, score, max_distance = 20)
        possible_locations = []


        (x-max_distance).upto(x+max_distance) do |i|
            (y-max_distance).upto(y+max_distance) do |j|
                next if i == x && j == y
                next if i < 0 || i >= len || j < 0 || j >= len
                next if corrupted[j][i] == '#'
                manhattan_distance = manhattan_distance(x, y, i, j)
                next if manhattan_distance > max_distance

                next if visited.has_key?("#{i},#{j}") 
                next if $non_cheaters_scores["#{i},#{j}"] - (score + manhattan_distance) < $must_improve

           
                
                possible_locations.push({ x: i, y: j, score: (score + manhattan_distance)})
               
            end
        end

        return possible_locations
    end

    memoize :teleport
end

corrupted = File.read(file_path).split("\n").map { |line| line.chars }
helper = Helper.new

start = {x: 0, y: 0}
finish = {x: 0, y: 0}
max_teleport = 20

corrupted.each_with_index do |row, y|
    row.each_with_index do |cell, x|
        if cell == 'S'
            start = {x: x, y: y}
        elsif cell == 'E'
            finish = {x: x, y: y}
        end
    end
end

len = corrupted[0].size

#########

candidates = [{last: start, score: 0, visited: { "#{start[:x]},#{start[:y]}" => 0 }, cheated: false, cheat: nil}]
moves_left = true

last_candidates = []




while moves_left
    moves_left = false

    new_candidates = []

    candidates.each do |candidate|
        x = candidate[:last][:x]
        y = candidate[:last][:y]
        visited = candidate[:visited]
        score = candidate[:score]

        if x == finish[:x] && y == finish[:y]
            next
        end

        up = helper.move_up(x, y, corrupted, visited, len)
        down = helper.move_down(x, y, corrupted, visited, len)
        left = helper.move_left(x, y, corrupted, visited, len)
        right = helper.move_right(x, y, corrupted, visited, len)

        if !up.nil? && (!visited.has_key?("#{up[:x]},#{up[:y]}") || visited["#{up[:x]},#{up[:y]}"] > score + 1)
            new_visited = visited.dup
            new_visited["#{up[:x]},#{up[:y]}"] = score + 1
            new_candidates.push({ last: up, score: score + 1, visited: new_visited })
            moves_left = true
        end

        if !down.nil? && (!visited.has_key?("#{down[:x]},#{down[:y]}") || visited["#{down[:x]},#{down[:y]}"] > score + 1)
            new_visited = visited.dup
            new_visited["#{down[:x]},#{down[:y]}"] = score + 1
            new_candidates.push({ last: down, score: score + 1, visited: new_visited })
            moves_left = true
        end

        if !left.nil? && (!visited.has_key?("#{left[:x]},#{left[:y]}") || visited["#{left[:x]},#{left[:y]}"] > score + 1)
            new_visited = visited.dup
            new_visited["#{left[:x]},#{left[:y]}"] = score + 1
            new_candidates.push({ last: left, score: score + 1, visited: new_visited})
            moves_left = true
        end

        if !right.nil? && (!visited.has_key?("#{right[:x]},#{right[:y]}") || visited["#{right[:x]},#{right[:y]}"] > score + 1)
            new_visited = visited.dup
            new_visited["#{right[:x]},#{right[:y]}"] = score + 1
            new_candidates.push({ last: right, score: score + 1, visited: new_visited })
            moves_left = true
        end
        
    end

    last_candidates = candidates
    candidates = new_candidates
end

highest_score = last_candidates.map { |candidate| candidate[:score] }.min
i = 0
last_candidates.first[:visited].each do |key, value|
    $non_cheaters_scores[key] = i
    i += 1
end

moves_left = true

final_candidates = []
last_candidates = []



sum = 0
$non_cheaters_scores.to_a.each_with_index do |non_cheat, i|
    next if highest_score - i < $must_improve
    x, y = non_cheat[0].split(",").map { |n| n.to_i }
    score = non_cheat[1]
    visited = $non_cheaters_scores.to_a[0..i].to_h
    start = {x: x, y: y}


    possible_locations = helper.teleport(x, y, corrupted, visited, len, score, max_teleport)
    sum += possible_locations.size

end

puts sum
