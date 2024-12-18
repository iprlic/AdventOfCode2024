#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

def move_up(x, y, corrupted, visited, len)
    return nil if y == 0 || corrupted[y - 1][x] == '#' || visited.has_key?("#{x},#{y - 1}")
    return { x: x, y: y - 1 }
end

def move_down(x, y, corrupted, visited, len)
    return nil if y == len - 1 || corrupted[y + 1][x] == '#' || visited.has_key?("#{x},#{y + 1}")
    return { x: x, y: y + 1 }
end

def move_left(x, y, corrupted, visited, len)
    return nil if x == 0 || corrupted[y][x - 1] == '#' || visited.has_key?("#{x - 1},#{y}")
    return { x: x - 1, y: y }
end

def move_right(x, y, corrupted, visited, len)
    return nil if x == len - 1 || corrupted[y][x + 1] == '#' || visited.has_key?("#{x + 1},#{y}")
    return { x: x + 1, y: y }
end

input = File.read(file_path).split("\n").map{ |line| {x: line.split(',')[0], y: line.split(',')[1] } }


len = 71
#len = 7

bytes = 1024


for i in bytes..input.length do
    
corrupted = Array.new(len) { Array.new(len, '.') }
    input.take(i).each do |point|
        corrupted[point[:x].to_i][point[:y].to_i] = '#'
    end

    exited = false

    start = { x: 0, y: 0 }
    finish = { x: len-1, y: len-1 }
    candidates = [{last: start, score: 1, visited: { "0,0" => 1 }}]
    all_visited = { "0,0" => 1 }
    moves_left = true

    while moves_left
        moves_left = false

        new_candidates = []
        candidates.each do |candidate|
            x = candidate[:last][:x]
            y = candidate[:last][:y]
            visited = candidate[:visited]
            score = candidate[:score]

            if x == finish[:x] && y == finish[:y]
                exited = true
                break
            end

            up = move_up(x, y, corrupted, visited, len)
            down = move_down(x, y, corrupted, visited, len)
            left = move_left(x, y, corrupted, visited, len)
            right = move_right(x, y, corrupted, visited, len)

            if !up.nil? && (!all_visited.has_key?("#{up[:x]},#{up[:y]}") || all_visited["#{up[:x]},#{up[:y]}"] > score + 1)
                new_visited = visited.dup
                new_visited["#{up[:x]},#{up[:y]}"] = 1
                candidates.push({ last: up, score: score + 1, visited: new_visited })
                all_visited["#{up[:x]},#{up[:y]}"] = score + 1
                moves_left = true
            end

            if !down.nil? && (!all_visited.has_key?("#{down[:x]},#{down[:y]}") || all_visited["#{down[:x]},#{down[:y]}"] > score + 1)
                new_visited = visited.dup
                new_visited["#{down[:x]},#{down[:y]}"] = 1
                candidates.push({ last: down, score: score + 1, visited: new_visited })
                all_visited["#{down[:x]},#{down[:y]}"] = score + 1
                moves_left = true
            end

            if !left.nil? && (!all_visited.has_key?("#{left[:x]},#{left[:y]}") || all_visited["#{left[:x]},#{left[:y]}"] > score + 1)
                new_visited = visited.dup
                new_visited["#{left[:x]},#{left[:y]}"] = 1
                candidates.push({ last: left, score: score + 1, visited: new_visited })
                all_visited["#{left[:x]},#{left[:y]}"] = score + 1
                moves_left = true
            end

            if !right.nil? && (!all_visited.has_key?("#{right[:x]},#{right[:y]}") || all_visited["#{right[:x]},#{right[:y]}"] > score + 1)
                new_visited = visited.dup
                new_visited["#{right[:x]},#{right[:y]}"] = 1
                candidates.push({ last: right, score: score + 1, visited: new_visited })
                all_visited["#{right[:x]},#{right[:y]}"] = score + 1
                moves_left = true
            end
            
        end

        candidates = new_candidates
    end

    if exited == false
        puts "#{input[i-1][:x]},#{input[i-1][:y]}"
        exit
    end

end