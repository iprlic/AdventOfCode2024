#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)
input = File.read(file_path)


def turn_right(dir)
    case dir
    when "UP"
        "RIGHT"
    when "RIGHT"
        "DOWN"
    when "DOWN"
        "LEFT"
    when "LEFT"
        "UP"
    end
end

def can_move(dir, current, obstacles)
    case dir
    when "UP"
        return !obstacles[[current[0]-1, current[1]]]
    when "RIGHT"
        return !obstacles[[current[0], current[1]+1]]
    when "DOWN"
        return !obstacles[[current[0]+1, current[1]]]
    when "LEFT"
        return !obstacles[[current[0], current[1]-1]]
    end
end

def move(dir, current)
    case dir
    when "UP"
        return [current[0]-1, current[1]]
    when "RIGHT"
        return [current[0], current[1]+1]
    when "DOWN"
        return [current[0]+1, current[1]]
    when "LEFT"
        return [current[0], current[1]-1]
    end
end

def is_out(current, grid)
    return current[0] < 0 || current[1] < 0 || current[0] >= grid.size || current[1] >= grid[0].size
end

grid = input.split("\n").map(&:chars)
start = [0, 0]
current = [0, 0]
obstacles = {}
visited = {}
posible_obstacles = []

dir = "UP"

grid.each_with_index do |row, i|
    row.each_with_index do |cell, j|
        if cell == "^"
            current = [i, j]
            start = [i, j]
            visited[[i, j]] = 1
            dir = "UP"
        end

        if cell == "#"
            obstacles[[i, j]] = true
        end
    end
end



loop do
    if can_move(dir, current, obstacles)
        current = move(dir, current)
        if is_out(current, grid)
            posible_obstacles += visited.keys
            break
        end
        visited[current] = true
    else
        dir = turn_right(dir)
    end
end

sum = 0
prev = nil

posible_obstacles.each do |pos|
    visited = {}
    current = start

    obstacles.delete(prev) if !prev.nil?
    obstacles[pos] = true
    prev = pos

    dir = "UP"

    loop do
        if can_move(dir, current, obstacles)
            current = move(dir, current)
            if is_out(current, grid)
                break
            end
            if visited[current] == dir
                sum += 1
                break
            end
            visited[current] = dir
        else
            dir = turn_right(dir)
        end
    end
end

puts sum


