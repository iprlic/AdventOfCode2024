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

#goal = {x: 15, y: 6}

moves_left = true
paths = {}
paths["#{start[:x]},#{start[:y]},#{start[:dir]}"] = start
visited_with_score = {}
visited_with_score = {"#{start[:x]},#{start[:y]},#{start[:dir]}": 0}

paths_before = {}
while moves_left
    moves_left = false

    new_paths = {}
    paths_before = paths.clone
    paths.each do |key, path|
        x, y, dir, score, visited = path[:x], path[:y], path[:dir], path[:score], path[:visited]

        if x == goal[:x] && y == goal[:y]
            if (visited_with_score[key].nil? || visited_with_score[key] >= score) && (!new_paths.has_key?(key) || new_paths[key][:score] >= score)
                new_visited = visited.clone

                if new_paths.has_key?(key) && new_paths[key][:score] == score
                    new_visited.merge!(new_paths[key][:visited])
                end

                new_paths[key] = path 
                new_paths[key][:visited] = new_visited
                visited_with_score[key] = score
                next
            end
        end

        straight_visited = visited.clone
        where = where_straight(x, y, dir, map, visited)
        if !where.nil?
            if (!new_paths.has_key?("#{where[:x]},#{where[:y]},#{dir}") || new_paths["#{where[:x]},#{where[:y]},#{dir}"][:score] >= score + 1) && (visited_with_score["#{where[:x]},#{where[:y]},#{dir}"].nil? || visited_with_score["#{where[:x]},#{where[:y]},#{dir}"] >= score) 
                straight_visited["#{where[:x]},#{where[:y]},#{dir}"] = true
                new_visited = straight_visited.clone

                if new_paths.has_key?("#{where[:x]},#{where[:y]},#{dir}") && new_paths["#{where[:x]},#{where[:y]},#{dir}"][:score] == score + 1
                    new_visited.merge!(new_paths["#{where[:x]},#{where[:y]},#{dir}"][:visited])
                end

                new_paths["#{where[:x]},#{where[:y]},#{dir}"] = {x: where[:x], y: where[:y], dir: dir, score: score + 1, visited: straight_visited}
                new_paths["#{where[:x]},#{where[:y]},#{dir}"][:visited] = new_visited
                visited_with_score["#{where[:x]},#{where[:y]},#{dir}"] = score + 1
                moves_left = true
            end
            
        end

        left_visited = visited.clone
        where = where_left(x, y, dir, map, visited)
        if !where.nil?
            new_key = "#{where[:x]},#{where[:y]},#{new_dir(dir, 'L')}"
            if (!new_paths.has_key?(new_key) || new_paths[new_key][:score] >= score + 1001) && (visited_with_score[new_key].nil? || visited_with_score[new_key] >= score + 1001)
                left_visited[new_key] = true

                new_visited = left_visited.clone

                if new_paths.has_key?(new_key) && new_paths[new_key][:score] == score + 1001
                    new_visited.merge!(new_paths[new_key][:visited])
                end

                new_paths[new_key] = {x: where[:x], y: where[:y], dir: new_dir(dir, 'L'), score: score + 1001, visited: left_visited}
                new_paths[new_key][:visited] = new_visited
                visited_with_score[new_key] = score + 1001
                moves_left = true
            end

        end

        right_visited = visited.clone
        where = where_right(x, y, dir, map, visited)
        if !where.nil?
            new_key = "#{where[:x]},#{where[:y]},#{new_dir(dir, 'R')}"
            if (!new_paths.has_key?(new_key) || new_paths[new_key][:score] >= score + 1001) && (visited_with_score[new_key].nil? || visited_with_score[new_key] >= score + 1001)
                right_visited[new_key] = true

                new_visited = right_visited.clone

                if new_paths.has_key?(new_key) && new_paths[new_key][:score] == score + 1001
                    new_visited.merge!(new_paths[new_key][:visited])
                end

                new_paths[new_key] = {x: where[:x], y: where[:y], dir: new_dir(dir, 'R'), score: score + 1001, visited: right_visited}
                new_paths[new_key][:visited] = new_visited
                visited_with_score[new_key] = score + 1001
                moves_left = true
            end
        end
    end
    paths = new_paths
end

ending = visited_with_score.select { |key, value| key.to_s.split(',')[0].to_i == goal[:x] && key.to_s.split(',')[1].to_i == goal[:y] }

min_score = ending.map { |key, value| value }.min

all_visited = {}
paths_before.each do |key, path|
    if path[:score] == min_score
        path[:visited].each do |key, value|
            new_key = key.to_s.split(',')[0] + ',' + key.to_s.split(',')[1]
            all_visited[new_key] = true
        end
    end
end

puts all_visited.size
