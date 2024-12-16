#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)

def where_straight(x, y, dir, map, visited)
    where = nil
    case dir
    when '>'
        where = {x: x + 1, y: y} if map[y][x + 1] == '.' || map[y][x + 1] == 'E'
    when '<'
        where = {x: x -1 , y: y} if map[y][x - 1] == '.' || map[y][x - 1] == 'E'
    when '^'
        where = {x: x , y: y - 1} if map[y - 1][x] == '.' || map[y - 1][x] == 'E'
    when 'v'
        where = {x: x , y: y + 1} if map[y + 1][x] == '.' || map[y + 1][x] == 'E'
    end

    where = nil if !where.nil? && visited.has_key?("#{where[:x]},#{where[:y]}")

    return where
end

def where_left(x, y, dir, map, visited)
    where = nil
    case dir
    when '>'
        where = {x: x, y: y - 1} if map[y - 1][x] == '.' || map[y - 1][x] == 'E'
    when '<'
        where = {x: x, y: y + 1} if map[y + 1][x] == '.' || map[y + 1][x] == 'E'
    when '^'
        where = {x: x - 1, y: y} if map[y][x - 1] == '.' || map[y][x - 1] == 'E'
    when 'v'
        where = {x: x + 1, y: y} if map[y][x + 1] == '.' || map[y][x + 1] == 'E'
    end

    where = nil if !where.nil? && visited.has_key?("#{where[:x]},#{where[:y]}")

    return where
end

def where_right(x, y, dir, map, visited)
    where = nil
    case dir
    when '>'
        where = {x: x, y: y + 1} if map[y + 1][x] == '.' || map[y + 1][x] == 'E'
    when '<'
        where = {x: x, y: y - 1} if map[y - 1][x] == '.' || map[y - 1][x] == 'E'
    when '^'
        where = {x: x + 1, y: y} if map[y][x + 1] == '.' || map[y][x + 1] == 'E'
    when 'v'
        where = {x: x - 1, y: y} if map[y][x - 1] == '.' || map[y][x - 1] == 'E'
    end

    where = nil if !where.nil? && visited.has_key?("#{where[:x]},#{where[:y]}")

    return where
end

def new_dir(dir, turn)
    case dir
    when '>'
        return turn == 'L' ? '^' : 'v'
    when '<'
        return turn == 'L' ? 'v' : '^'
    when '^'
        return turn == 'L' ? '<' : '>'
    when 'v'
        return turn == 'L' ? '>' : '<'
    end
end


map = File.read(file_path).split("\n").map { |line| line.chars }

start = {x: 0, y: 0}
goal = {x: 0, y: 0}

map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
        if cell == 'S'
            start = {x: x, y: y, dir: '>', score: 0, visited: {"#{x},#{y}": true}}
        elsif cell == 'E'
            goal = {x: x, y: y}
        end
    end
end

moves_left = true
paths = {}
paths["#{start[:x]},#{start[:y]},#{start[:dir]}"] = start
visited_with_score = {}
visited_with_score = {"#{start[:x]},#{start[:y]},#{start[:dir]}": 0}


while moves_left
    moves_left = false

    new_paths = {}
    paths_before = paths.clone
    paths.each do |key, path|
        x, y, dir, score, visited = path[:x], path[:y], path[:dir], path[:score], path[:visited]

        if x == goal[:x] && y == goal[:y]
            if (visited_with_score[key].nil? || visited_with_score[key] >= score) && (!new_paths.has_key?(key) || new_paths[key][:score] >= score)
                new_paths[key] = path 
                visited_with_score[key] = score
                next
            end
        end

        straight_visited = visited.clone
        where = where_straight(x, y, dir, map, visited)
        if !where.nil?
            if (!new_paths.has_key?("#{where[:x]},#{where[:y]},#{dir}") || new_paths["#{where[:x]},#{where[:y]},#{dir}"][:score] >= score + 1) && (visited_with_score["#{where[:x]},#{where[:y]},#{dir}"].nil? || visited_with_score["#{where[:x]},#{where[:y]},#{dir}"] >= score) 
                straight_visited["#{where[:x]},#{where[:y]}"] = true
                new_paths["#{where[:x]},#{where[:y]},#{dir}"] = {x: where[:x], y: where[:y], dir: dir, score: score + 1, visited: straight_visited}
                visited_with_score["#{where[:x]},#{where[:y]},#{dir}"] = score + 1
                moves_left = true
            end
        end

        left_visited = visited.clone
        where = where_left(x, y, dir, map, visited)
        if !where.nil?
            if (!new_paths.has_key?("#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}") || new_paths["#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"][:score] >= score + 1001) && (visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"].nil? || visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"] >= score + 1001)
                left_visited["#{where[:x]},#{where[:y]}"] = true
                new_paths["#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"] = {x: where[:x], y: where[:y], dir: new_dir(dir, 'L'), score: score + 1001, visited: left_visited}
                visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"] = score + 1001
                moves_left = true
            end
        end

        right_visited = visited.clone
        where = where_right(x, y, dir, map, visited)
        if !where.nil?
            if (!new_paths.has_key?("#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}") || new_paths["#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"][:score] >= score + 1001) && (visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"].nil? || visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"] >= score + 1001)
                right_visited["#{where[:x]},#{where[:y]}"] = true
                new_paths["#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"] = {x: where[:x], y: where[:y], dir: new_dir(dir, 'R'), score: score + 1001, visited: right_visited}
                visited_with_score["#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"] = score + 1001
                moves_left = true
            end
        end
    end
    paths = new_paths
end

puts visited_with_score.keys.select { |key| key.to_s.split(',')[0].to_i == goal[:x] && key.to_s.split(',')[1].to_i == goal[:y] }.map { |key| visited_with_score[key] }.min
