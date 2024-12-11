#!/usr/bin/env ruby
# frozen_string_literal: true

file_path = File.expand_path('input.txt', __dir__)


def can_go_up(i, j, value, grid)
    return false if i == 0
    return false if grid[i - 1][j] != value + 1
    return true
end

def can_go_down(i, j, value, grid)
    return false if i == grid.length - 1
    return false if grid[i + 1][j] != value + 1
    return true
end

def can_go_left(i, j, value, grid)
    return false if j == 0
    return false if grid[i][j - 1] != value + 1
    return true
end

def can_go_right(i, j, value, grid)
    return false if j == grid[0].length - 1
    return false if grid[i][j + 1] != value + 1
    return true
end

input = File.read(file_path)
input = input.split("\n").map{|x| x.chars.map(&:to_i)}

trailheads = {}

input.each_with_index do |row, i|
    row.each_with_index do |cell, j|
        if cell == 0
            trailheads[[i, j]] = [{position: [i, j], value: 0}]
        end
    end
end

trailheads.each do |key, val|
    i, j = key
    while true
        new_vals = []
        val.each do |possible_path|
            i, j = possible_path[:position]
            value = possible_path[:value]
            if value == 9
                new_vals.push({position: [i, j], value: 9})
                next
            end

            if can_go_up(i, j, value, input)
                new_vals.push({position: [i - 1, j], value: value + 1})
            end
            if can_go_down(i, j, value, input)
                new_vals.push({position: [i + 1, j], value: value + 1})
            end
            if can_go_left(i, j, value, input)
                new_vals.push({position: [i, j - 1], value: value + 1})
            end
            if can_go_right(i, j, value, input)
                new_vals.push({position: [i, j + 1], value: value + 1})
            end
        end

        val = new_vals

        if val.empty? || val.all?{|x| x[:value] == 9}
            trailheads[key] = val
            break
        end
    end
end


puts trailheads.select{|k, v| !v.empty? }.map{|k, v| v.size}.sum